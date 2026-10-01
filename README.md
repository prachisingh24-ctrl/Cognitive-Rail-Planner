```markdown
# Cognitive Rail Maintenance Planner (CRMP)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.11](https://img.shields.io/badge/Python-3.11-3776AB.svg?logo=python)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/Backend-FastAPI-009688.svg?logo=fastapi)](https://fastapi.tiangolo.com/)
[![Next.js 14](https://img.shields.io/badge/Frontend-Next.js%2014-000000.svg?logo=next.js)](https://nextjs.org/)
[![Optimization: OR-Tools](https://img.shields.io/badge/Engine-OR--Tools-FF6F00.svg)](https://developers.google.com/optimization)

CRMP is a decision-support framework for coordinating track maintenance across high-density railway corridors. It brings together requests from Track Engineering, Signalling & Telecommunication (S&T), and Traction/Overhead Equipment (OHE) teams to help plan shared maintenance windows, evaluate timetable conflicts, and present recommendations for human review.

> **Operational note:** CRMP is a planning aid, not a railway interlocking or movement-authority system. All recommendations must be reviewed and approved by authorized railway personnel before operational use.

## Overview

In busy railway networks, maintenance teams may request corridor closures independently. This can lead to:

- Repeated possessions of the same corridor, increasing setup and clearance overhead.
- Timetable conflicts and delays that propagate to other services.
- Crew and maintenance equipment waiting for access or clearance.

CRMP is designed to combine compatible work requests into coordinated possession windows while accounting for spatial, temporal, resource, and timetable constraints.

## Decision pipeline

```text
Fault reports and asset telemetry
                 │
                 ▼
       Ingestion and validation
                 │
                 ▼
       Request bundling and solver
                 │
                 ▼
       Timetable conflict evaluation
                 │
                 ▼
       Recommendation for controller review
```

The pipeline has four main stages:

1. **Ingestion and validation**  
   Processes maintenance requests, telemetry, and inspection records; validates required fields and maps requests to track segments.

2. **Corridor bundling and scheduling**  
   Identifies requests that may be coordinated into shared possession windows, subject to track, crew, equipment, and clearance constraints.

3. **Timetable conflict evaluation**  
   Evaluates candidate windows against train schedules and estimates potential timetable impacts.

4. **Human approval**  
   Presents a recommendation and supporting information for review by an authorized Section Controller. Approval remains a human responsibility.

## Optimization model

The scheduling objective is to balance projected train delay, possession overhead, and equipment idle or transfer time:

```text
Minimize:
  Z = α × total projected train delay
    + β × total possession cost
    + γ × total equipment idle and transfer time
```

Where:

- **Projected train delay** is the estimated timetable impact of scheduled activities.
- **Possession cost** represents the operational overhead associated with a maintenance block.
- **Equipment idle and transfer time** represents waiting and movement between work locations.
- **α, β, and γ** are configurable weighting factors.

The model may account for constraints such as:

- Track-segment and spatial-clearance requirements.
- Maintenance activity duration and time windows.
- Crew and equipment availability.
- Train headways and timetable conflicts.
- Non-overlapping use of track resources.

The exact constraints and solver behavior depend on the implementation and input data.

## Reported pilot results

The figures below are reported results for the Pune Division pilot described by the project team. They should be interpreted in the context of the pilot data, assumptions, and evaluation methodology; they are not a guarantee of results in other settings.

| Metric | Baseline | Reported CRMP result | Reported change |
| :--- | :--- | :--- | :--- |
| Annual corridor delay hours | 1,400 hours | 600 hours | −57.1% |
| Maintenance planning | Decoupled closures | Coordinated multi-team blocks | +25.0% bundling efficiency |
| Crew deployment | Unsynchronized | Coordinated rosters | +35.0% utilization |
| Idle fuel/traction loss | High idle queuing | Optimized clearance profiles | −20.0% idle burn |
| Direct economic reclamation | — | Approximately ₹60 crore/year on Pune–Solapur | Reported estimate |

## Technology stack

- **Optimization:** Python 3.11, Google OR-Tools, NumPy, and SciPy
- **API:** FastAPI
- **Background tasks:** Celery and Redis
- **Geospatial data:** PostgreSQL 16 with PostGIS
- **Frontend:** Next.js 14, TypeScript, and Tailwind CSS
- **Integrations:** Designed for compatibility with railway EAM and COA interfaces

## Getting started

### Prerequisites

- Python 3.11 or newer
- Node.js 18 or newer
- PostgreSQL with the PostGIS extension
- Redis, if using Celery background workers

### Clone the repository

```bash
git clone https://github.com/prachisingh24-ctrl/Cognitive-Rail-Planner.git
cd Cognitive-Rail-Planner
```

### Set up the backend

```bash
cd backend
python -m venv .venv
```

Activate the virtual environment:

```bash
# macOS/Linux
source .venv/bin/activate

# Windows PowerShell
.venv\Scripts\Activate.ps1
```

Install dependencies and configure the environment:

```bash
pip install -r requirements.txt
cp .env.example .env
```

Edit `.env` with the required database, Redis, and application settings. Then start the API:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

### Set up the frontend

In a separate terminal:

```bash
cd frontend
npm install
npm run build
npm start
```

## Configuration

Configure secrets and environment-specific settings through environment variables or the `.env` file. Do not commit credentials, API keys, or production connection strings to the repository.

Before running the application, confirm that:

- PostgreSQL is available and PostGIS is enabled.
- Database connection settings are correct.
- Redis is running if background tasks are enabled.
- The backend and frontend environment variables are configured.

## Project status and limitations

CRMP is intended as a decision-support and planning framework. Its recommendations depend on the accuracy and completeness of maintenance, asset, crew, equipment, and timetable data. Solver outputs must be validated against operational rules and approved by authorized personnel.

The reported pilot metrics are project-reported results. Reproduction requires access to the underlying datasets, model configuration, and evaluation procedure.

## Project information

- **Program:** Bharat Agentic 2026
- **Track:** GovTech / Mobility Infrastructure
- **Team:** Team Vortex
- **Lead researcher/developer:** Prachi Singh

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```
