-- ============================================================
-- Neurology EHR Data Quality Validation Framework
-- File: qc_checks.sql
-- Purpose: Structured QC validation queries across 6 categories
-- Execute: mysql -u root -p neurology_ehr < qc_checks.sql
-- ============================================================

USE neurology_ehr;

-- ************************************************************
-- CATEGORY 1: COMPLETENESS CHECKS
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 1: COMPLETENESS CHECKS' AS qc_category;
SELECT '========================================' AS '';

-- QC-C1: Encounters with no linked diagnosis
-- Every neurology visit should yield at least a working diagnosis.
-- Missing diagnoses indicate incomplete charting.
SELECT '--- QC-C1: Encounters with no diagnosis ---' AS qc_check;
SELECT e.encounter_id, e.patient_id, e.encounter_date, e.encounter_type, e.provider
FROM encounters e
LEFT JOIN diagnoses d ON e.encounter_id = d.encounter_id
WHERE d.diagnosis_id IS NULL;

-- QC-C2: Patients with no encounters (registered but never seen)
SELECT '--- QC-C2: Patients with no encounters ---' AS qc_check;
SELECT p.patient_id, p.first_name, p.last_name, p.date_of_birth
FROM patients p
LEFT JOIN encounters e ON p.patient_id = e.patient_id
WHERE e.encounter_id IS NULL;

-- QC-C3: Patients missing both phone AND email (no contact method)
SELECT '--- QC-C3: Patients with no contact info ---' AS qc_check;
SELECT patient_id, first_name, last_name, phone, email
FROM patients
WHERE phone IS NULL AND email IS NULL;

-- QC-C4: Encounters with NULL provider
SELECT '--- QC-C4: Encounters with NULL provider ---' AS qc_check;
SELECT encounter_id, patient_id, encounter_date, encounter_type
FROM encounters
WHERE provider IS NULL;

-- QC-C5: Diagnoses with NULL or empty description
SELECT '--- QC-C5: Diagnoses with missing description ---' AS qc_check;
SELECT diagnosis_id, encounter_id, icd10_code, description
FROM diagnoses
WHERE description IS NULL OR TRIM(description) = '';


-- ************************************************************
-- CATEGORY 2: VALIDITY CHECKS
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 2: VALIDITY CHECKS' AS qc_category;
SELECT '========================================' AS '';

-- QC-V1: ICD-10 code regex pattern validation
-- Valid format: One letter + two digits + optional (dot + 1-4 alphanumeric)
-- Examples valid: G40.309, G20, G35, G62.9
-- Examples invalid: G409, ABC.1, 43.0, G40.
SELECT '--- QC-V1: Invalid ICD-10 codes ---' AS qc_check;
SELECT diagnosis_id, encounter_id, patient_id, icd10_code, description
FROM diagnoses
WHERE icd10_code NOT REGEXP '^[A-Z][0-9]{2}(\\.[0-9A-Z]{1,4})?$';

-- QC-V2: Invalid gender values
SELECT '--- QC-V2: Invalid gender values ---' AS qc_check;
SELECT patient_id, first_name, last_name, gender
FROM patients
WHERE gender NOT IN ('Male', 'Female', 'Other', 'Non-binary', 'Prefer not to say')
   OR gender IS NULL;

-- QC-V3: Future encounter dates (should not exist unless pre-scheduled)
SELECT '--- QC-V3: Future encounter dates ---' AS qc_check;
SELECT encounter_id, patient_id, encounter_date, encounter_type, provider
FROM encounters
WHERE encounter_date > CURDATE();

-- QC-V4: Invalid medication frequency values
SELECT '--- QC-V4: Invalid medication frequency ---' AS qc_check;
SELECT medication_id, medication_name, frequency
FROM medications
WHERE frequency NOT IN (
    'once daily', 'twice daily', 'three times daily',
    'four times daily', 'every 8 hours', 'every 12 hours',
    'as needed', 'once weekly', 'every other day', 'at bedtime'
)
AND frequency IS NOT NULL;


-- ************************************************************
-- CATEGORY 3: CONSISTENCY CHECKS
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 3: CONSISTENCY CHECKS' AS qc_category;
SELECT '========================================' AS '';

-- QC-CS1: Encounter date before patient date of birth
-- A clinic visit cannot occur before the patient was born.
SELECT '--- QC-CS1: Encounter date before patient DOB ---' AS qc_check;
SELECT e.encounter_id, e.encounter_date,
       p.patient_id, p.first_name, p.last_name, p.date_of_birth,
       DATEDIFF(e.encounter_date, p.date_of_birth) AS days_difference
FROM encounters e
JOIN patients p ON e.patient_id = p.patient_id
WHERE e.encounter_date < p.date_of_birth;

-- QC-CS2: Medication end_date before start_date
-- A prescription cannot end before it started.
SELECT '--- QC-CS2: Medication end_date before start_date ---' AS qc_check;
SELECT medication_id, medication_name, patient_id,
       start_date, end_date,
       DATEDIFF(end_date, start_date) AS duration_days
FROM medications
WHERE end_date IS NOT NULL
  AND start_date IS NOT NULL
  AND end_date < start_date;

-- QC-CS3: Diagnosis date significantly deviating from encounter date
-- Gap > 7 days suggests data entry error or wrong encounter linkage.
SELECT '--- QC-CS3: Diagnosis date mismatch (>7 day gap) ---' AS qc_check;
SELECT d.diagnosis_id, d.icd10_code, d.diagnosis_date,
       e.encounter_id, e.encounter_date,
       ABS(DATEDIFF(d.diagnosis_date, e.encounter_date)) AS day_gap
FROM diagnoses d
JOIN encounters e ON d.encounter_id = e.encounter_id
WHERE d.diagnosis_date IS NOT NULL
  AND e.encounter_date IS NOT NULL
  AND ABS(DATEDIFF(d.diagnosis_date, e.encounter_date)) > 7;

-- QC-CS4: Medication start_date before patient date of birth
SELECT '--- QC-CS4: Medication start before patient DOB ---' AS qc_check;
SELECT m.medication_id, m.medication_name, m.start_date,
       p.patient_id, p.first_name, p.last_name, p.date_of_birth
FROM medications m
JOIN patients p ON m.patient_id = p.patient_id
WHERE m.start_date IS NOT NULL
  AND m.start_date < p.date_of_birth;


-- ************************************************************
-- CATEGORY 4: DUPLICATE DETECTION
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 4: DUPLICATE DETECTION' AS qc_category;
SELECT '========================================' AS '';

-- QC-D1: Duplicate patients (same first_name + last_name + DOB)
-- In neurology, duplicate records cause fragmented medication histories
-- which is dangerous for anti-epileptic drug management.
SELECT '--- QC-D1: Duplicate patients (name + DOB) ---' AS qc_check;
SELECT first_name, last_name, date_of_birth,
       COUNT(*) AS occurrence_count,
       GROUP_CONCAT(patient_id ORDER BY patient_id) AS patient_ids
FROM patients
GROUP BY first_name, last_name, date_of_birth
HAVING COUNT(*) > 1;

-- QC-D2: Duplicate encounters (same patient + date + type)
SELECT '--- QC-D2: Duplicate encounters ---' AS qc_check;
SELECT patient_id, encounter_date, encounter_type,
       COUNT(*) AS occurrence_count,
       GROUP_CONCAT(encounter_id ORDER BY encounter_id) AS encounter_ids
FROM encounters
GROUP BY patient_id, encounter_date, encounter_type
HAVING COUNT(*) > 1;

-- QC-D3: Duplicate diagnosis per encounter (same ICD-10 on same encounter)
SELECT '--- QC-D3: Duplicate diagnoses per encounter ---' AS qc_check;
SELECT encounter_id, icd10_code,
       COUNT(*) AS occurrence_count,
       GROUP_CONCAT(diagnosis_id ORDER BY diagnosis_id) AS diagnosis_ids
FROM diagnoses
GROUP BY encounter_id, icd10_code
HAVING COUNT(*) > 1;


-- ************************************************************
-- CATEGORY 5: STATISTICAL OUTLIER DETECTION
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 5: STATISTICAL OUTLIER DETECTION' AS qc_category;
SELECT '========================================' AS '';

-- QC-S1: Dosage outliers per medication using AVG +/- 2*STDDEV
-- Flags dosages that are statistically extreme.
-- Critical in neurology for narrow-therapeutic-index drugs
-- (Carbamazepine, Valproic Acid) where overdose causes toxicity.
SELECT '--- QC-S1: Dosage outliers (z-score > 2) ---' AS qc_check;
WITH med_stats AS (
    SELECT medication_name,
           AVG(dosage_mg) AS avg_dosage,
           STDDEV(dosage_mg) AS stddev_dosage,
           COUNT(*) AS sample_count
    FROM medications
    WHERE dosage_mg IS NOT NULL AND dosage_mg > 0
    GROUP BY medication_name
    HAVING COUNT(*) >= 2
)
SELECT m.medication_id, m.medication_name, m.dosage_mg,
       ROUND(ms.avg_dosage, 2) AS avg_dosage,
       ROUND(ms.stddev_dosage, 2) AS stddev_dosage,
       ROUND((m.dosage_mg - ms.avg_dosage) / NULLIF(ms.stddev_dosage, 0), 2) AS z_score,
       ms.sample_count
FROM medications m
JOIN med_stats ms ON m.medication_name = ms.medication_name
WHERE m.dosage_mg IS NOT NULL
  AND ms.stddev_dosage > 0
  AND ABS(m.dosage_mg - ms.avg_dosage) > 2 * ms.stddev_dosage
ORDER BY ABS((m.dosage_mg - ms.avg_dosage) / ms.stddev_dosage) DESC;

-- QC-S2: Zero or NULL dosages
-- A zero or missing dosage is never clinically valid.
SELECT '--- QC-S2: Zero or NULL dosages ---' AS qc_check;
SELECT medication_id, medication_name, dosage_mg, patient_id, prescribing_provider
FROM medications
WHERE dosage_mg = 0 OR dosage_mg IS NULL;


-- ************************************************************
-- CATEGORY 6: CROSS-TABLE INTEGRITY
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'CATEGORY 6: CROSS-TABLE INTEGRITY' AS qc_category;
SELECT '========================================' AS '';

-- QC-X1: Medications with no corresponding diagnosis (NULL diagnosis_id)
-- Every prescription should trace back to a diagnosis.
SELECT '--- QC-X1: Medications with NULL diagnosis_id ---' AS qc_check;
SELECT m.medication_id, m.medication_name, m.patient_id,
       m.dosage_mg, m.prescribing_provider
FROM medications m
WHERE m.diagnosis_id IS NULL;

-- QC-X2: Medications referencing non-existent diagnoses
SELECT '--- QC-X2: Medications referencing missing diagnoses ---' AS qc_check;
SELECT m.medication_id, m.medication_name, m.diagnosis_id, m.patient_id
FROM medications m
LEFT JOIN diagnoses d ON m.diagnosis_id = d.diagnosis_id
WHERE m.diagnosis_id IS NOT NULL
  AND d.diagnosis_id IS NULL;

-- QC-X3: Diagnoses referencing non-existent encounters
SELECT '--- QC-X3: Diagnoses referencing missing encounters ---' AS qc_check;
SELECT d.diagnosis_id, d.icd10_code, d.encounter_id, d.patient_id
FROM diagnoses d
LEFT JOIN encounters e ON d.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL;

-- QC-X4: Orphaned records summary (aggregate view)
SELECT '--- QC-X4: Orphaned records summary ---' AS qc_check;
SELECT 'Medications without diagnosis' AS issue_type,
       COUNT(*) AS record_count
FROM medications WHERE diagnosis_id IS NULL
UNION ALL
SELECT 'Medications referencing missing diagnosis',
       COUNT(*)
FROM medications m
LEFT JOIN diagnoses d ON m.diagnosis_id = d.diagnosis_id
WHERE m.diagnosis_id IS NOT NULL AND d.diagnosis_id IS NULL
UNION ALL
SELECT 'Diagnoses referencing missing encounter',
       COUNT(*)
FROM diagnoses d
LEFT JOIN encounters e ON d.encounter_id = e.encounter_id
WHERE e.encounter_id IS NULL
UNION ALL
SELECT 'Encounters with no diagnosis',
       COUNT(*)
FROM encounters e
LEFT JOIN diagnoses d ON e.encounter_id = d.encounter_id
WHERE d.diagnosis_id IS NULL
UNION ALL
SELECT 'Patients with no encounters',
       COUNT(*)
FROM patients p
LEFT JOIN encounters e ON p.patient_id = e.patient_id
WHERE e.encounter_id IS NULL;


-- ************************************************************
-- QC DASHBOARD: Summary of all data quality issues
-- ************************************************************

SELECT '========================================' AS '';
SELECT 'QC DASHBOARD: DATA QUALITY SUMMARY' AS qc_category;
SELECT '========================================' AS '';

SELECT 'Total patients' AS metric, COUNT(*) AS value FROM patients
UNION ALL
SELECT 'Total encounters', COUNT(*) FROM encounters
UNION ALL
SELECT 'Total diagnoses', COUNT(*) FROM diagnoses
UNION ALL
SELECT 'Total medications', COUNT(*) FROM medications
UNION ALL
SELECT '---', 0
UNION ALL
SELECT 'Duplicate patients (groups)', COUNT(*) FROM (
    SELECT first_name, last_name, date_of_birth
    FROM patients GROUP BY first_name, last_name, date_of_birth
    HAVING COUNT(*) > 1
) dup
UNION ALL
SELECT 'Invalid ICD-10 codes', COUNT(*) FROM diagnoses
WHERE icd10_code NOT REGEXP '^[A-Z][0-9]{2}(\\.[0-9A-Z]{1,4})?$'
UNION ALL
SELECT 'Encounters before patient DOB', COUNT(*)
FROM encounters e JOIN patients p ON e.patient_id = p.patient_id
WHERE e.encounter_date < p.date_of_birth
UNION ALL
SELECT 'Future encounter dates', COUNT(*)
FROM encounters WHERE encounter_date > CURDATE()
UNION ALL
SELECT 'Medication end before start', COUNT(*)
FROM medications WHERE end_date IS NOT NULL AND start_date IS NOT NULL AND end_date < start_date
UNION ALL
SELECT 'Zero/NULL dosages', COUNT(*)
FROM medications WHERE dosage_mg = 0 OR dosage_mg IS NULL
UNION ALL
SELECT 'Encounters with no diagnosis', COUNT(*)
FROM encounters e LEFT JOIN diagnoses d ON e.encounter_id = d.encounter_id
WHERE d.diagnosis_id IS NULL
UNION ALL
SELECT 'Medications without diagnosis', COUNT(*)
FROM medications WHERE diagnosis_id IS NULL
UNION ALL
SELECT 'Patients missing contact info', COUNT(*)
FROM patients WHERE phone IS NULL AND email IS NULL
UNION ALL
SELECT 'Invalid gender values', COUNT(*)
FROM patients WHERE gender NOT IN ('Male', 'Female', 'Other', 'Non-binary', 'Prefer not to say') OR gender IS NULL;
