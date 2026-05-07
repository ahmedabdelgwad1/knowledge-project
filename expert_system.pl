:- dynamic has_symptom/1.

% Diseases

disease(flu).
disease(cold).
disease(covid19).
disease(malaria).
disease(diabetes).
disease(hypertension).
disease(pneumonia).
disease(dengue).
disease(tuberculosis).
disease(anemia).

% Symptoms per disease (5 each)

symptom_of(flu, fever).
symptom_of(flu, cough).
symptom_of(flu, sore_throat).
symptom_of(flu, body_ache).
symptom_of(flu, fatigue).

symptom_of(cold, sneezing).
symptom_of(cold, runny_nose).
symptom_of(cold, sore_throat).
symptom_of(cold, mild_cough).
symptom_of(cold, congestion).

symptom_of(covid19, fever).
symptom_of(covid19, dry_cough).
symptom_of(covid19, shortness_of_breath).
symptom_of(covid19, loss_of_taste).
symptom_of(covid19, fatigue).

symptom_of(malaria, fever).
symptom_of(malaria, chills).
symptom_of(malaria, sweating).
symptom_of(malaria, headache).
symptom_of(malaria, nausea).

symptom_of(diabetes, frequent_urination).
symptom_of(diabetes, increased_thirst).
symptom_of(diabetes, increased_hunger).
symptom_of(diabetes, fatigue).
symptom_of(diabetes, blurred_vision).

symptom_of(hypertension, headache).
symptom_of(hypertension, dizziness).
symptom_of(hypertension, chest_pain).
symptom_of(hypertension, shortness_of_breath).
symptom_of(hypertension, nosebleeds).

symptom_of(pneumonia, fever).
symptom_of(pneumonia, cough).
symptom_of(pneumonia, chest_pain).
symptom_of(pneumonia, shortness_of_breath).
symptom_of(pneumonia, fatigue).

symptom_of(dengue, high_fever).
symptom_of(dengue, severe_headache).
symptom_of(dengue, joint_pain).
symptom_of(dengue, muscle_pain).
symptom_of(dengue, rash).

symptom_of(tuberculosis, persistent_cough).
symptom_of(tuberculosis, weight_loss).
symptom_of(tuberculosis, night_sweats).
symptom_of(tuberculosis, fever).
symptom_of(tuberculosis, chest_pain).

symptom_of(anemia, fatigue).
symptom_of(anemia, weakness).
symptom_of(anemia, pale_skin).
symptom_of(anemia, dizziness).
symptom_of(anemia, shortness_of_breath).

% Treatments (2 each)

treatment(flu, rest).
treatment(flu, hydration).

treatment(cold, warm_fluids).
treatment(cold, decongestant).

treatment(covid19, isolation).
treatment(covid19, supportive_care).

treatment(malaria, antimalarial_medication).
treatment(malaria, hydration).

treatment(diabetes, blood_sugar_monitoring).
treatment(diabetes, balanced_diet).

treatment(hypertension, low_sodium_diet).
treatment(hypertension, regular_exercise).

treatment(pneumonia, antibiotics).
treatment(pneumonia, rest).

treatment(dengue, fluid_replacement).
treatment(dengue, pain_relief).

treatment(tuberculosis, antibiotics).
treatment(tuberculosis, long_term_followup).

treatment(anemia, iron_supplements).
treatment(anemia, healthy_diet).

% Known symptoms (unique list)

known_symptom(fever).
known_symptom(cough).
known_symptom(sore_throat).
known_symptom(body_ache).
known_symptom(fatigue).
known_symptom(sneezing).
known_symptom(runny_nose).
known_symptom(mild_cough).
known_symptom(congestion).
known_symptom(dry_cough).
known_symptom(shortness_of_breath).
known_symptom(loss_of_taste).
known_symptom(chills).
known_symptom(sweating).
known_symptom(headache).
known_symptom(nausea).
known_symptom(frequent_urination).
known_symptom(increased_thirst).
known_symptom(increased_hunger).
known_symptom(blurred_vision).
known_symptom(dizziness).
known_symptom(chest_pain).
known_symptom(nosebleeds).
known_symptom(high_fever).
known_symptom(severe_headache).
known_symptom(joint_pain).
known_symptom(muscle_pain).
known_symptom(rash).
known_symptom(persistent_cough).
known_symptom(weight_loss).
known_symptom(night_sweats).
known_symptom(weakness).
known_symptom(pale_skin).

% Diagnosis rule

matched_symptoms(Disease, Matches) :-
    findall(S,
        (has_symptom(S), symptom_of(Disease, S)),
        Matches).

diagnose(Disease) :-
    disease(Disease),
    matched_symptoms(Disease, Matches),
    length(Matches, Count),
    Count >= 3.
