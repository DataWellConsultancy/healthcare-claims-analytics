-- ============================================================
-- Datawell Consultancy
-- Project: Healthcare Claims Analytics
-- File: 01_cleaning_logic.sql
-- Purpose: Data cleaning and transformation logic for all four tables
-- Note: Queries use DuckDB syntax referencing CSV files directly.
--       In a database environment replace file paths with table names.
-- ============================================================


-- ─────────────────────────────────────────
-- CLAIMS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    Claim_ID,
    Provider_ID,
    Patient_ID,
    Diagnosis_Code,
    Procedure_Code,
    Claim_Amount,
    Approved_Amount,

    -- Derived: Amount denied
    ROUND(Claim_Amount - Approved_Amount, 2)                               AS Denied_Amount,

    -- Derived: Approval ratio
    ROUND(Approved_Amount / NULLIF(Claim_Amount, 0), 4)                    AS Approval_Ratio,

    Insurance_Type,
    CAST(Claim_Submission_Date AS DATE)                                    AS Claim_Submission_Date,
    EXTRACT(YEAR  FROM CAST(Claim_Submission_Date AS DATE))                AS Claim_Year,
    EXTRACT(MONTH FROM CAST(Claim_Submission_Date AS DATE))                AS Claim_Month,
    EXTRACT(QUARTER FROM CAST(Claim_Submission_Date AS DATE))              AS Claim_Quarter,
    Claim_Status,

    -- Derived: Status flags
    CASE WHEN Claim_Status = 'Approved' THEN 1 ELSE 0 END                 AS Is_Approved,
    CASE WHEN Claim_Status = 'Rejected' THEN 1 ELSE 0 END                 AS Is_Rejected,
    CASE WHEN Claim_Status = 'Pending'  THEN 1 ELSE 0 END                 AS Is_Pending,

    Is_Fraud,
    Visit_Type,
    Length_of_Stay,
    Days_Between_Service_and_Claim,
    Number_of_Claims_Per_Provider_Monthly,
    Chronic_Condition_Flag,

    -- Derived: Claim amount bucket
    CASE
        WHEN Claim_Amount < 1000    THEN 'Low (<1K)'
        WHEN Claim_Amount < 5000    THEN 'Mid (1K-5K)'
        WHEN Claim_Amount < 10000   THEN 'High (5K-10K)'
        WHEN Claim_Amount < 25000   THEN 'Major (10K-25K)'
        ELSE 'Premium (25K+)'
    END                                                                    AS Claim_Amount_Bucket

FROM read_csv_auto('data/raw/claims.csv')
WHERE Claim_Amount > 0;


-- ─────────────────────────────────────────
-- PROVIDERS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    Provider_ID,
    Provider_Name,
    Hospital_Name,
    Hospital_Type,
    Provider_Specialty,
    State,
    Years_in_Practice,
    Provider_Rating,
    Total_Beds,
    Accreditation_Status,
    Is_High_Risk,

    -- Derived: Rating tier
    CASE
        WHEN Provider_Rating < 2.0 THEN 'Poor'
        WHEN Provider_Rating < 3.0 THEN 'Average'
        WHEN Provider_Rating < 4.0 THEN 'Good'
        ELSE 'Excellent'
    END                                                                    AS Rating_Tier,

    -- Derived: Experience tier
    CASE
        WHEN Years_in_Practice < 5  THEN 'Junior'
        WHEN Years_in_Practice < 15 THEN 'Mid'
        WHEN Years_in_Practice < 25 THEN 'Senior'
        ELSE 'Expert'
    END                                                                    AS Experience_Tier,

    -- Derived: Hospital size
    CASE
        WHEN Total_Beds < 100  THEN 'Small'
        WHEN Total_Beds < 300  THEN 'Medium'
        WHEN Total_Beds < 600  THEN 'Large'
        ELSE 'Major'
    END                                                                    AS Hospital_Size

FROM read_csv_auto('data/raw/providers.csv');


-- ─────────────────────────────────────────
-- PATIENTS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    Patient_ID,
    Patient_Name,
    Patient_Age,
    Patient_Gender,
    BMI,
    Smoking_Status,
    Employment_Status,
    Annual_Income_Band,
    Chronic_Condition_Flag,
    Prior_Visits_12m,
    State,
    Blood_Type,

    -- Derived: Age group
    CASE
        WHEN Patient_Age BETWEEN 0  AND 25 THEN '18-25'
        WHEN Patient_Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Patient_Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Patient_Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Patient_Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '65+'
    END                                                                    AS Age_Group,

    -- Derived: BMI category
    CASE
        WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI < 25.0 THEN 'Normal'
        WHEN BMI < 30.0 THEN 'Overweight'
        ELSE 'Obese'
    END                                                                    AS BMI_Category,

    -- Derived: High utiliser flag
    CASE WHEN Prior_Visits_12m > 8 THEN 1 ELSE 0 END                     AS High_Utiliser

FROM read_csv_auto('data/raw/patients.csv')
WHERE Patient_Age >= 18;


-- ─────────────────────────────────────────
-- PAYMENTS TABLE — Cleaning Logic
-- ─────────────────────────────────────────

SELECT
    Payment_ID,
    Claim_ID,
    CAST(Payment_Date AS DATE)                                             AS Payment_Date,
    Payment_Amount,
    Payment_Method,
    Payment_Status,
    Days_to_Payment,
    Payment_Reference,
    Late_Payment_Flag,

    -- Derived: Payment speed tier
    CASE
        WHEN Days_to_Payment <= 15  THEN 'Fast (0-15d)'
        WHEN Days_to_Payment <= 30  THEN 'Normal (15-30d)'
        WHEN Days_to_Payment <= 60  THEN 'Slow (30-60d)'
        ELSE 'Very Slow (60d+)'
    END                                                                    AS Payment_Speed,

    -- Derived: Status flags
    CASE WHEN Payment_Status = 'Paid'     THEN 1 ELSE 0 END               AS Is_Paid,
    CASE WHEN Payment_Status = 'Failed'   THEN 1 ELSE 0 END               AS Is_Failed,
    CASE WHEN Payment_Status = 'Disputed' THEN 1 ELSE 0 END               AS Is_Disputed

FROM read_csv_auto('data/raw/payments.csv')
WHERE Payment_Amount > 0;
