# Healthcare Claims Analytics
### Datawell Consultancy

---

## Business Problem

A healthcare insurance company operated four disconnected data systems — claims
records, provider profiles, patient demographics, and payment settlements — none
of which had been formally audited or connected. The business had no reliable way
to measure its own operational performance and could not answer basic questions:

- What is our claim approval and rejection rate across insurance types and providers?
- Which specialties and insurance types carry the highest fraud risk?
- How long does it take to settle payments and where are the bottlenecks?
- Are providers with lapsed accreditation generating higher fraud rates?
- Which patient age groups and diagnosis categories drive the highest claim volumes?

**Our engagement:** Profile, clean, and unify all four data sources into a single
analytics layer that answers these questions with confidence.

---

## Dataset

| File | Records | Description |
|------|---------|-------------|
| `claims.csv` | 10,000 | Core claims — amounts, status, fraud flag, diagnosis, visit type |
| `providers.csv` | 200 | Provider specialty, hospital type, rating, accreditation |
| `patients.csv` | 10,000 | Patient demographics — age, BMI, income band, chronic conditions |
| `payments.csv` | 10,000 | Payment settlement — method, status, days to payment, late flag |

---

## Key Findings

| Area | Finding |
|------|---------|
| Claim Approval | Approximately 65% approval rate — consistent across all four insurance types |
| Rejection Rate | 17% rejected — rejection reason analysis recommended as next engagement |
| Fraud — Specialty | Pediatrics highest at 11%, Cardiology second at 10.5%, Neurology lowest at 8.5% |
| Fraud — Insurance | Medicaid highest at 10.7%, Self-Pay lowest at 9.6% |
| Fraud — Visit Type | Emergency highest at 11%, Inpatient and Outpatient both at 9.3% |
| Fraud — Accreditation | Lapsed providers at 11%, Accredited at 9.5% — accreditation alone insufficient as fraud screen |
| Payment Performance | All methods average 60 days to settlement — bottleneck is upstream in approval process |
| Late Payments | 25% late payment rate uniform across all payment methods |
| Fraud Trend | Peaked at 11% in 2020, dropped to 9.2% in 2021, rising again to 10.3% in 2024 |
| Patient Volume | 65-plus age group drives highest claim volume of all age segments |

---

## Project Structure

```
healthcare-claims-analytics/
├── data/
│   ├── raw/                        <- Original source files
│   │   ├── claims.csv
│   │   ├── providers.csv
│   │   ├── patients.csv
│   │   └── payments.csv
│   └── cleaned/                    <- Output of cleaning pipeline
│       ├── claims_cleaned.csv
│       ├── providers_cleaned.csv
│       ├── patients_cleaned.csv
│       ├── payments_cleaned.csv
│       ├── master_dataset.csv      <- Unified joined table
│       └── kpi_*.csv               <- All KPI output tables
├── notebooks/
│   ├── 01_data_quality.ipynb       <- Phase 1: Audit, clean, join
│   └── 02_analysis_kpis.ipynb      <- Phase 2: KPI calculations and charts
├── sql/
│   ├── 01_cleaning_logic.sql       <- All cleaning transformations in SQL
│   └── 02_kpi_aggregations.sql     <- All KPI queries in SQL
├── dashboard/
│   ├── claim_status_analysis.png
│   ├── fraud_analysis.png
│   ├── provider_performance.png
│   ├── payment_performance.png
│   ├── patient_demographics.png
│   ├── diagnosis_visit_analysis.png
│   └── yearly_trends.png
└── docs/
    └── case_study.md
```

---

## How to Run

**Prerequisites:**
```bash
pip install pandas numpy matplotlib seaborn duckdb faker
```

**Run in order:**
```
1. notebooks/01_data_quality.ipynb
2. notebooks/02_analysis_kpis.ipynb
```

---

## Technology Stack

| Tool | Purpose |
|------|---------|
| Python / Pandas | Data cleaning and transformation |
| DuckDB | SQL queries on dataframes and CSV files |
| Matplotlib / Seaborn | Charts and visualisations |
| Jupyter Notebook | Analysis and portfolio presentation |
| GitHub | Version control and portfolio |

---

## About Datawell Consultancy

We help fintech, servicing, and healthcare businesses organise their data,
build reliable dashboards, and make better decisions.

datawellconsultants@gmail.com
datawellconsultancy.com

---

*Data used in this project is synthetically generated for portfolio demonstration
purposes. All client references are illustrative.*
