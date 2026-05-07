from __future__ import annotations

import os
from typing import Any

from flask import Flask, jsonify, render_template, request
from pyswip import Prolog

PROLOG_FILE = "expert_system.pl"

app = Flask(__name__)
prolog = Prolog()
prolog.consult(PROLOG_FILE)


def normalize_symptom(symptom: str) -> str:
    """
    * Normalize a symptom string for Prolog atoms.
    * @param symptom: Raw symptom label.
    * @returns: Normalized symptom atom.
    """
    return symptom.strip().lower().replace(" ", "_")


def get_all_symptoms(engine: Prolog) -> list[str]:
    """
    * Get all known symptoms from Prolog.
    * @param engine: Prolog engine instance.
    * @returns: Sorted list of symptom atoms.
    """
    symptoms = [str(row["S"]) for row in engine.query("known_symptom(S)")]
    return sorted(set(symptoms))


def get_all_diseases(engine: Prolog) -> list[str]:
    """
    * Get all diseases from Prolog.
    * @param engine: Prolog engine instance.
    * @returns: Sorted list of disease atoms.
    """
    diseases = [str(row["D"]) for row in engine.query("disease(D)")]
    return sorted(set(diseases))


def get_disease_symptoms(engine: Prolog, disease: str) -> list[str]:
    """
    * Get symptoms for a specific disease.
    * @param engine: Prolog engine instance.
    * @param disease: Disease atom.
    * @returns: List of symptom atoms.
    """
    query = f"symptom_of({disease}, S)"
    return [str(row["S"]) for row in engine.query(query)]


def get_treatments(engine: Prolog, disease: str) -> list[str]:
    """
    * Get treatments for a specific disease.
    * @param engine: Prolog engine instance.
    * @param disease: Disease atom.
    * @returns: List of treatment atoms.
    """
    query = f"treatment({disease}, T)"
    return [str(row["T"]) for row in engine.query(query)]


def clear_symptoms(engine: Prolog) -> None:
    """
    * Remove all asserted symptoms from Prolog.
    * @param engine: Prolog engine instance.
    * @returns: None.
    """
    engine.query("retractall(has_symptom(_))")


def assert_symptoms(engine: Prolog, symptoms: list[str]) -> None:
    """
    * Assert user symptoms into Prolog.
    * @param engine: Prolog engine instance.
    * @param symptoms: List of symptom atoms.
    * @returns: None.
    """
    for symptom in symptoms:
        engine.assertz(f"has_symptom({symptom})")


def get_diagnoses(engine: Prolog) -> list[str]:
    """
    * Get diseases that satisfy diagnose/1.
    * @param engine: Prolog engine instance.
    * @returns: List of disease atoms.
    """
    return [str(row["D"]) for row in engine.query("diagnose(D)")]


def severity_from_count(count: int) -> str:
    """
    * Convert match count to severity label.
    * @param count: Number of matched symptoms.
    * @returns: Severity label.
    """
    if count >= 5:
        return "severe"
    if count == 4:
        return "moderate"
    return "mild"


def get_partial_matches(engine: Prolog, selected: list[str]) -> list[dict[str, Any]]:
    """
    * Get top partial matches for the selected symptoms.
    * @param engine: Prolog engine instance.
    * @param selected: Normalized symptom atoms.
    * @returns: Top 3 partial matches with scores.
    """
    results: list[dict[str, Any]] = []
    diseases = get_all_diseases(engine)
    selected_set = set(selected)

    for disease in diseases:
        symptoms = get_disease_symptoms(engine, disease)
        total = len(symptoms)
        match_count = len(selected_set.intersection(symptoms))
        if match_count == 0:
            continue
        score = round(match_count / total, 2) if total else 0.0
        results.append(
            {
                "disease": disease,
                "matchCount": match_count,
                "totalSymptoms": total,
                "score": score,
                "treatments": get_treatments(engine, disease),
            }
        )

    results.sort(key=lambda item: (item["score"], item["matchCount"]), reverse=True)
    return results[:3]


def build_full_match(engine: Prolog, disease: str, selected: list[str]) -> dict[str, Any]:
    """
    * Build a full match payload for a disease.
    * @param engine: Prolog engine instance.
    * @param disease: Disease atom.
    * @param selected: Selected symptom atoms.
    * @returns: Full match payload dictionary.
    """
    symptoms = get_disease_symptoms(engine, disease)
    matched = [s for s in symptoms if s in set(selected)]
    match_count = len(matched)
    return {
        "disease": disease,
        "matchCount": match_count,
        "totalSymptoms": len(symptoms),
        "treatments": get_treatments(engine, disease),
        "severity": severity_from_count(match_count),
        "matchedSymptoms": matched,
    }


def diagnose_payload(symptoms: list[str]) -> dict[str, Any]:
    """
    * Run diagnosis flow and return API payload.
    * @param symptoms: Raw user symptom labels.
    * @returns: Diagnosis payload.
    """
    normalized = [normalize_symptom(s) for s in symptoms if s.strip()]
    if not normalized:
        return {"full_matches": [], "partial_matches": []}

    clear_symptoms(prolog)
    assert_symptoms(prolog, normalized)

    try:
        matches = get_diagnoses(prolog)
        full = [build_full_match(prolog, disease, normalized) for disease in matches]
        partial = [] if full else get_partial_matches(prolog, normalized)
        return {"full_matches": full, "partial_matches": partial}
    finally:
        clear_symptoms(prolog)


@app.get("/")
def index() -> Any:
    """
    * Render the main UI.
    * @returns: HTML page.
    """
    return render_template("index.html")


@app.get("/api/symptoms")
def api_symptoms() -> Any:
    """
    * Return all known symptoms.
    * @returns: JSON list of symptoms.
    """
    return jsonify(get_all_symptoms(prolog))


@app.post("/api/diagnose")
def api_diagnose() -> Any:
    """
    * Diagnose diseases from selected symptoms.
    * @returns: JSON diagnosis payload.
    """
    data = request.get_json(silent=True) or {}
    symptoms = data.get("symptoms", [])
    payload = diagnose_payload(symptoms)
    return jsonify(payload)


if __name__ == "__main__":
    port = int(os.getenv("PORT", "5001"))
    app.run(debug=True, port=port)
