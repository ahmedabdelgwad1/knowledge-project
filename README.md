---
title: Disease Diagnosis
emoji: 🏥
colorFrom: blue
colorTo: green
sdk: docker
app_file: interface.py
pinned: false
---

# Expert System for Disease Diagnosis using Prolog and Python

**Course:** Knowledge Representation and Reasoning (A1406)  
**Institution:** Pharos University in Alexandria - Faculty Of Computer Science & AI (AI Department)  
**Instructors:** Dr. Nihal Mabrouk / Eng. Renad Khalil  
**Semester:** Spring 2025-2026  

## Project Overview
This project is an Expert System capable of diagnosing common diseases based on user-input symptoms. It uses Prolog for knowledge representation and rule-based reasoning, integrated with a Python (Flask) backend to provide a seamless web interface (HTML/CSS/JS) for the users.

## Features
- **Prolog Knowledge Base**: Contains facts and rules for 10 common diseases and their symptoms.
- **Python Backend**: Uses `pyswip` to bridge the gap between Python and Prolog.
- **Dynamic User Interface**: Clean HTML/JS frontend allowing users to select symptoms and receive instant diagnoses.
- **Bilingual UI**: Supports English and Arabic interface via a toggle button.
- **Smart Matching**: Displays full matches (matched over 3 symptoms) and partial matches with percentage progress.

## Prerequisites / Requirements
- macOS / Windows / Linux
- Python 3.10+
- SWI-Prolog

## Setup Instructions

1) **Install SWI-Prolog:**
   * **macOS:** `brew install swi-prolog`
   * **Windows:** Download the installer from the [SWI-Prolog website](https://www.swi-prolog.org/download/stable)

2) **Create and activate a virtual environment:**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
   ```

3) **Install Python dependencies:**
   ```bash
   python -m pip install flask pyswip
   ```

## Run the Project

Start the Flask server:
```bash
python interface.py
```
*Note: The app runs on port 5001 by default to avoid conflicts on macOS.*

Open in your browser:
```
http://127.0.0.1:5001
```

## Project Structure
- `expert_system.pl`: Prolog Knowledge Base (facts, rules, symptoms, and treatments).
- `interface.py`: Python Flask server and pyswip integration logic.
- `templates/index.html`: The frontend User Interface.

## Team
- Student 1: [Name]
- Student 2: [Name]
