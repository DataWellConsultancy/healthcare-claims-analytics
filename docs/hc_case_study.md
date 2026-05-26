# Case Study — Healthcare Claims Analytics

**Prepared by:** Datawell Consultancy
**Sector:** Healthcare & Insurance
**Scope:** Data Engineering, Fraud Analytics & Claims KPI Analysis

---

## 1. The Situation

A healthcare insurance company processed thousands of claims annually across multiple
provider networks and patient segments. Despite the volume, the business operated
without a unified view of its own data. Claims records, provider profiles, patient
demographics, and payment settlements lived in four separate systems that had never
been formally connected or audited.

The consequence was that leadership could not reliably measure approval rates, identify
fraud patterns, track payment performance, or understand which providers and patient
segments were driving costs. Reporting was manual, slow, and inconsistent across teams.

**The business needed reliable answers to these questions:**

- What is our actual claim approval rate and how does it vary by insurance type?
- Which provider specialties and insurance types carry disproportionate fraud risk?
- How long does it take to settle payments and are all payment methods performing equally?
- Do providers with lapsed accreditation generate higher fraud rates?
- Which patient age groups and chronic condition profiles drive the highest claim volumes?

---

## 2. Our Approach

We structured the engagement in two sequential phases. Phase 1 established data
quality and a unified data model across all four sources. Phase 2 built the
analytics layer on top of it.

| Phase | Focus | What Was Delivered |
|-------|-------|-------------------|
| Phase 1 | Data Quality and Engineering | Full audit of all four datasets across completeness, uniqueness, validity, and business rule compliance. Cleaning pipeline built in Python and DuckDB. Fifteen derived analytical columns engineered. All four tables joined into a single unified master dataset of 50+ columns. |
| Phase 2 | KPI Analytics and Insights | Eight KPI modules covering claim status and approval rates, fraud pattern analysis, provider performance, payment settlement performance, patient demographic analysis, diagnosis and visit type breakdown, and yearly trend analysis. |

### Data Sources

| File | Records | Content |
|------|---------|---------|
| `claims.csv` | 10,000 | Claim amounts, status, fraud flag, diagnosis, visit type |
| `providers.csv` | 200 | Provider specialty, hospital type, rating, accreditation status |
| `patients.csv` | 10,000 | Patient age, gender, BMI, income band, chronic conditions |
| `payments.csv` | 10,000 | Payment method, status, days to settlement, late flag |

---

## 3. At a Glance

| Metric | Value |
|--------|-------|
| Total Claims Analysed | 10,000 |
| Unique Providers | 200 |
| Claim Approval Rate | approximately 65% |
| Rejection Rate | approximately 17% |
| Pending Rate | approximately 16% |
| Overall Fraud Rate | approximately 10% |
| Highest Fraud Specialty | Pediatrics at 11% |
| Highest Fraud Insurance Type | Medicaid at 10.7% |
| Highest Fraud Visit Type | Emergency at 11% |
| Avg Days to Payment | approximately 60 days across all methods |
| Late Payment Rate | approximately 25% across all methods |
| Fraud Rate 2020 | 11% — highest in dataset |
| Fraud Rate 2021 | 9.2% — lowest in dataset |
| Fraud Rate 2024 | 10.3% — rising again |

---

## 4. Findings and Recommendations

---

### Finding 01 — Approval Rate is Consistent Across All Insurance Types at Approximately 65%

The claim status chart shows approximately 6,500 approved claims, 1,750 rejected, and
1,600 pending out of 10,000 total. The approval rate chart shows all four insurance
types — Medicare, Medicaid, Private, and Self-Pay — performing at virtually identical
approval rates of approximately 65% to 67%. There is no meaningful differentiation
between insurance types in terms of how often claims are approved.

**Recommendation:** The uniform approval rate across insurance types indicates the
approval decision is being driven by claim-level factors — diagnosis, provider, visit
type — rather than insurance type. The business should investigate whether rejection
criteria are being applied consistently or whether certain claim categories are being
rejected at disproportionately higher rates regardless of insurance type. A 17%
rejection rate on a 10,000 claim portfolio represents significant denied revenue
that warrants a detailed rejection reason analysis as a next engagement.

---

### Finding 02 — Pediatrics and Cardiology Carry the Highest Fraud Rates Among All Specialties

The fraud analysis chart shows Pediatrics at approximately 11% fraud rate — the highest
of all six specialties — followed closely by Cardiology at approximately 10.5%.
Orthopedics and Oncology sit at approximately 10%. General Practice at approximately
9.5% and Neurology at approximately 8.5% are the lowest risk specialties. The spread
between highest and lowest is approximately 2.5 percentage points — meaningful but
not extreme.

**Recommendation:** Pediatrics and Cardiology claims should be subject to enhanced
review protocols given their elevated fraud rates. Given that Cardiology also generates
the highest total claim count at approximately 2,000 claims — the combination of high
volume and elevated fraud rate makes it the single highest priority specialty for
fraud intervention. A dedicated audit of the top 50 highest-value Cardiology claims
from high-risk providers would be the highest-return investigative action.

---

### Finding 03 — Medicaid Carries the Highest Fraud Rate Among Insurance Types

The fraud by insurance type chart shows Medicaid at approximately 10.7% fraud rate —
the highest of all four insurance types. Private follows at approximately 10%, Medicare
at approximately 9.8%, and Self-Pay at approximately 9.6%. The difference between
highest and lowest is approximately 1 percentage point — indicating fraud is broadly
distributed but Medicaid claims carry a marginally higher risk profile.

**Recommendation:** Medicaid claims warrant a slightly elevated scrutiny threshold
in the automated review pipeline. Given that Medicaid is also one of the four
equally-distributed insurance types in this portfolio, the additional fraud exposure
from Medicaid relative to other types is manageable with targeted rule-based flagging
rather than wholesale manual review.

---

### Finding 04 — Emergency Visit Claims Carry the Highest Fraud Rate at 11%

Among the three visit types, Emergency visits show a fraud rate of approximately 11%
— materially higher than Inpatient at approximately 9.3% and Outpatient at
approximately 9.3%. Average claim amounts are broadly similar across all three
visit types at approximately $25,000 — meaning Emergency fraud events carry the
same financial impact per claim as other visit types but occur more frequently.

**Recommendation:** Emergency claim submissions should trigger automatic enhanced
review when combined with any other fraud risk indicator — high-risk provider flag,
Medicaid insurance type, or Pediatrics/Cardiology specialty. The intersection of
Emergency visit type with these other elevated-risk dimensions is where the highest
concentration of genuine fraud is most likely to occur.

---

### Finding 05 — All Payment Methods Take Approximately 60 Days to Settle with a 25% Late Rate

The payment performance chart shows a concerning uniformity — all four payment methods
(Online, Cheque, Bank Transfer, Direct Deposit) average approximately 60 days to
payment with no meaningful difference between them. Similarly, the late payment rate
is approximately 25% across all four methods. This uniformity suggests the bottleneck
is not in the payment method itself but in an upstream process — likely claim
processing and approval cycle time.

**Recommendation:** Since all payment methods perform identically, switching payment
methods will not improve settlement speed. The 60-day average and 25% late rate point
to a process bottleneck in the claim review and approval workflow. The business should
map the end-to-end claim lifecycle to identify where the delay originates — whether
in initial claim review, supporting document requests, approval authority queues, or
payment initiation. Targeting a 30-day average settlement cycle should be a defined
operational KPI for the next financial year.

---

### Finding 06 — Fraud Rate Peaked in 2020 at 11% then Dropped to 9.2% in 2021 Before Rising Again

The yearly fraud trend chart shows a clear pattern — fraud rate started at
approximately 11% in 2020, dropped sharply to approximately 9.2% in 2021 — the
lowest point in the five-year dataset — then gradually rose through 2022 (9.6%)
and 2023 (9.6%) before climbing again to approximately 10.3% in 2024. The 2020 peak
likely coincides with elevated fraudulent activity during a period of operational
disruption. The 2024 rise is the most operationally concerning data point.

**Recommendation:** The rising fraud rate in 2024 should be treated as an early
warning signal requiring immediate investigation. The business should analyse whether
the 2024 increase is concentrated in specific specialties, providers, or claim types
or whether it represents a broad-based increase across the portfolio. If the trend
continues at the same rate into 2025, the fraud rate will exceed the 2020 peak —
making 2024 the most important year for fraud intervention investment.

---

### Finding 07 — Providers with Lapsed Accreditation Carry the Highest Fraud Rate

The provider performance chart shows Lapsed accreditation status at approximately
11% fraud rate — the highest of the three accreditation categories. Pending Review
follows at approximately 10.7% and Accredited providers at approximately 9.5%.
Despite having the lowest fraud rate among the three categories, even fully Accredited
providers are generating a 9.5% fraud rate — indicating the overall fraud problem
is not exclusively concentrated in non-accredited providers.

**Recommendation:** Accreditation status should be used as a fraud risk multiplier
in the automated review system rather than a binary filter. Claims from Lapsed
providers should receive mandatory enhanced review. However the fact that Accredited
providers also generate a 9.5% fraud rate means accreditation status alone is
insufficient as a fraud screen. A composite risk score combining accreditation
status, specialty, visit type, and claim amount will produce better fraud detection
outcomes than any single factor in isolation.

---

### Finding 08 — The 65-Plus Age Group Submits the Highest Claim Volume of All Age Groups

The patient demographics chart shows the 65+ age group generating the highest claim
count of all six age groups at approximately 1,700 for female and 1,650 for male
patients. Volume is lowest in the 18-25 group at approximately 500-550 claims.
Average claim amounts are broadly consistent across income bands at approximately
$24,000 to $25,000 — suggesting income band does not materially influence claim
size in this portfolio.

**Recommendation:** The 65+ patient segment drives disproportionate claim volume
relative to its population size. Healthcare management programmes targeting this
segment — preventive care, chronic disease management, reduced emergency
presentations — would have the highest volume impact of any patient intervention.
The consistent average claim amount across income bands indicates pricing and
cost management should focus on diagnosis and visit type rather than patient
income segmentation.

---

## 5. Deliverables

| Deliverable | Format |
|-------------|--------|
| Data Quality Audit | `notebooks/01_data_quality.ipynb` |
| Cleaned Master Dataset | `data/cleaned/master_dataset.csv` — 50+ columns, four sources joined |
| SQL Cleaning Scripts | `sql/01_cleaning_logic.sql` |
| SQL KPI Scripts | `sql/02_kpi_aggregations.sql` |
| KPI Analysis Notebook | `notebooks/02_analysis_kpis.ipynb` — 8 modules with charts |
| Dashboard Chart Exports | `dashboard/*.png` — 7 professional charts |
| Executive Case Study | This document |

---

## 6. Technology Stack

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
