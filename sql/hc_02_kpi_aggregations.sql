-- ============================================================
-- Datawell Consultancy
-- Project: Healthcare Claims Analytics
-- File: 02_kpi_aggregations.sql
-- Purpose: Core KPI calculations on the unified master dataset
-- Note: Assumes master table is available. In DuckDB replace
--       master with read_csv_auto('data/cleaned/master_dataset.csv')
-- ============================================================


-- ─────────────────────────────────────────
-- KPI 1: Executive Summary
-- ─────────────────────────────────────────

SELECT
    COUNT(*)                                                               AS total_claims,
    COUNT(DISTINCT Provider_ID)                                            AS unique_providers,
    COUNT(DISTINCT Patient_ID)                                             AS unique_patients,
    ROUND(SUM(Claim_Amount), 2)                                            AS total_claimed_usd,
    ROUND(SUM(Approved_Amount), 2)                                         AS total_approved_usd,
    ROUND(SUM(Denied_Amount), 2)                                           AS total_denied_usd,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Approval_Ratio)*100, 2)                                      AS avg_approval_ratio_pct,
    SUM(CASE WHEN Claim_Status = 'Approved' THEN 1 ELSE 0 END)            AS approved_claims,
    SUM(CASE WHEN Claim_Status = 'Rejected' THEN 1 ELSE 0 END)            AS rejected_claims,
    SUM(CASE WHEN Claim_Status = 'Pending'  THEN 1 ELSE 0 END)            AS pending_claims,
    SUM(Is_Fraud)                                                          AS fraud_claims,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    ROUND(AVG(Days_to_Payment), 2)                                         AS avg_days_to_payment,
    SUM(Late_Payment_Flag)                                                 AS late_payments
FROM master;


-- ─────────────────────────────────────────
-- KPI 2: Claim Status & Insurance Type
-- ─────────────────────────────────────────

SELECT
    Claim_Status,
    Insurance_Type,
    COUNT(*)                                                               AS claim_count,
    ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER(), 2)                         AS share_pct,
    ROUND(SUM(Claim_Amount), 2)                                            AS total_claimed,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct
FROM master
GROUP BY Claim_Status, Insurance_Type
ORDER BY Claim_Status, claim_count DESC;


-- ─────────────────────────────────────────
-- KPI 3: Fraud Analysis by Dimension
-- ─────────────────────────────────────────

SELECT
    Provider_Specialty,
    Visit_Type,
    Insurance_Type,
    COUNT(*)                                                               AS total_claims,
    SUM(Is_Fraud)                                                          AS fraud_claims,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN Is_Fraud=1 THEN Claim_Amount ELSE 0 END), 2)      AS fraud_amount_usd
FROM master
WHERE Provider_Specialty IS NOT NULL
GROUP BY Provider_Specialty, Visit_Type, Insurance_Type
ORDER BY fraud_rate_pct DESC;


-- ─────────────────────────────────────────
-- KPI 4: Provider Performance
-- ─────────────────────────────────────────

SELECT
    Provider_Specialty,
    Hospital_Type,
    Accreditation_Status,
    COUNT(*)                                                               AS total_claims,
    ROUND(SUM(Claim_Amount), 2)                                            AS total_claimed,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Is_Approved)*100, 2)                                         AS approval_rate_pct,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    ROUND(AVG(Provider_Rating), 2)                                         AS avg_provider_rating
FROM master
WHERE Provider_Specialty IS NOT NULL
GROUP BY Provider_Specialty, Hospital_Type, Accreditation_Status
ORDER BY total_claimed DESC;


-- ─────────────────────────────────────────
-- KPI 5: Payment Performance
-- ─────────────────────────────────────────

SELECT
    Payment_Status,
    Payment_Method,
    Payment_Speed,
    COUNT(*)                                                               AS payment_count,
    ROUND(SUM(Payment_Amount), 2)                                          AS total_amount,
    ROUND(AVG(Payment_Amount), 2)                                          AS avg_amount,
    ROUND(AVG(Days_to_Payment), 2)                                         AS avg_days_to_payment,
    ROUND(AVG(Late_Payment_Flag)*100, 2)                                   AS late_payment_rate_pct
FROM master
WHERE Payment_Status IS NOT NULL
GROUP BY Payment_Status, Payment_Method, Payment_Speed
ORDER BY payment_count DESC;


-- ─────────────────────────────────────────
-- KPI 6: Patient Demographics
-- ─────────────────────────────────────────

SELECT
    Age_Group,
    Patient_Gender,
    Annual_Income_Band,
    Chronic_Condition_Flag,
    COUNT(*)                                                               AS claim_count,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Is_Approved)*100, 2)                                         AS approval_rate_pct,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    ROUND(AVG(Length_of_Stay), 2)                                          AS avg_length_of_stay
FROM master
WHERE Age_Group IS NOT NULL
AND Annual_Income_Band IS NOT NULL
GROUP BY Age_Group, Patient_Gender, Annual_Income_Band, Chronic_Condition_Flag
ORDER BY claim_count DESC;


-- ─────────────────────────────────────────
-- KPI 7: Diagnosis and Visit Type
-- ─────────────────────────────────────────

SELECT
    Diagnosis_Code,
    Visit_Type,
    COUNT(*)                                                               AS claim_count,
    ROUND(SUM(Claim_Amount), 2)                                            AS total_claimed,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Is_Approved)*100, 2)                                         AS approval_rate_pct,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    ROUND(AVG(Length_of_Stay), 2)                                          AS avg_length_of_stay
FROM master
GROUP BY Diagnosis_Code, Visit_Type
ORDER BY total_claimed DESC;


-- ─────────────────────────────────────────
-- KPI 8: Yearly Trend
-- ─────────────────────────────────────────

SELECT
    Claim_Year,
    COUNT(*)                                                               AS total_claims,
    ROUND(SUM(Claim_Amount), 2)                                            AS total_claimed,
    ROUND(AVG(Claim_Amount), 2)                                            AS avg_claim_amount,
    ROUND(AVG(Is_Approved)*100, 2)                                         AS approval_rate_pct,
    ROUND(AVG(Is_Fraud)*100, 2)                                            AS fraud_rate_pct,
    SUM(Is_Fraud)                                                          AS fraud_count,
    ROUND(AVG(Days_to_Payment), 2)                                         AS avg_days_to_payment
FROM master
WHERE Claim_Year IS NOT NULL
GROUP BY Claim_Year
ORDER BY Claim_Year;
