# Neurology EHR Data Quality Validation Framework

A MySQL-based data quality validation framework for neurology electronic health records (EHR). The project uses synthetic but realistic clinic data with **intentionally embedded defects** to demonstrate structured QC validation techniques across completeness, validity, consistency, duplicate detection, statistical outlier analysis, and cross-table integrity checks.

## Prerequisites

- MySQL 8.0+
- MySQL command-line client or MySQL Workbench

## Project Structure

| File | Purpose |
|------|---------|
| `schema.sql` | Creates the `neurology_ehr` database and 4 interrelated tables |
| `seed_data.sql` | Populates tables with 250 synthetic rows containing intentional dirty data |
| `qc_checks.sql` | 22 validation queries across 6 QC categories plus a summary dashboard |
| `README.md` | Documentation |

## How to Run

Execute the files in order:

```bash
# Step 1: Create database and tables
mysql -u root -p < schema.sql

# Step 2: Load synthetic data
mysql -u root -p neurology_ehr < seed_data.sql

# Step 3: Run all QC validation checks
mysql -u root -p neurology_ehr < qc_checks.sql
```

## Schema Overview

Four tables with foreign key relationships:

```
patients (40 rows)
  |
  |--- 1:many ---> encounters (80 rows)
  |                    |
  |                    |--- 1:many ---> diagnoses (70 rows)
  |                                        |
  |--- 1:many ---> medications (60 rows) --|
                   (diagnosis_id nullable)
```

### Table Details

**patients** — Patient demographics. No UNIQUE constraint on name+DOB and no ENUM on gender — the QC layer detects these issues instead of the schema.

**encounters** — Clinic visits (initial, follow-up, emergency, telehealth) linked to patients via FK.

**diagnoses** — Diagnosis records with ICD-10 codes, linked to both encounters and patients. The `icd10_code` column is VARCHAR without regex constraints.

**medications** — Prescriptions with dosage and frequency, linked to patients (required) and diagnoses (nullable FK, ON DELETE SET NULL).

## Seeded Defects Summary

The seed data contains **56 intentional defects** distributed across all four tables:

| Table | Total Rows | Defect Type | Count |
|-------|-----------|-------------|-------|
| **patients** | 40 | Duplicate patients (same name+DOB) | 2 pairs |
| | | Missing both phone AND email | 2 |
| | | Invalid gender ('Unknown', 'N/A') | 2 |
| **encounters** | 80 | Encounter date before patient DOB | 3 |
| | | No linked diagnosis | 6 |
| | | NULL provider | 4 |
| | | Duplicate encounters (same patient+date+type) | 3 groups |
| | | Future dates (year 2027) | 2 |
| **diagnoses** | 70 | Malformed ICD-10 codes | 5 |
| | | Diagnosis date >7 days from encounter | 3 |
| | | NULL description | 3 |
| | | Duplicate diagnosis per encounter | 2 pairs |
| | | Orphan (non-existent encounter_id) | 2 |
| **medications** | 60 | end_date before start_date | 3 |
| | | Zero dosage | 2 |
| | | Extreme dosage outliers (50000mg, 25000mg, 9999mg) | 3 |
| | | NULL diagnosis_id (no linked diagnosis) | 4 |
| | | NULL start_date | 2 |
| | | Orphan (non-existent diagnosis_id) | 1 |

## QC Validation Checks

### Category 1: Completeness Checks

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-C1 | Encounters with no diagnosis | Every neurology visit should produce at least a working diagnosis for continuity of care |
| QC-C2 | Patients with no encounters | Registered patients never seen indicate workflow gaps |
| QC-C3 | Patients missing phone AND email | No way to contact patient for critical lab results or medication recalls |
| QC-C4 | Encounters with NULL provider | Provider attribution required for prescribing authority and malpractice tracking |
| QC-C5 | Diagnoses with NULL/empty description | ICD-10 code alone is insufficient for clinical context |

<img width="840" height="762" alt="image" src="https://github.com/user-attachments/assets/683f4f27-a603-4d06-b51e-087d0fa1f186" />

<img width="725" height="405" alt="image" src="https://github.com/user-attachments/assets/41759f72-be08-4165-a538-0d7098779975" />

<img width="712" height="350" alt="image" src="https://github.com/user-attachments/assets/d6ed5051-2df8-4478-8a28-36bad1abc5a5" />

<img width="670" height="360" alt="image" src="https://github.com/user-attachments/assets/a778c28a-3a7c-47aa-bcb5-9556dd1baaf0" />

<img width="694" height="339" alt="image" src="https://github.com/user-attachments/assets/f7640967-6fe5-47a8-aecc-8747dc821a36" />





### Category 2: Validity Checks

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-V1 | ICD-10 code regex validation | Malformed codes cause insurance claim denials and break clinical decision support alerts |
| QC-V2 | Invalid gender values | Non-standard values disrupt demographic reporting and drug interaction checks |
| QC-V3 | Future encounter dates | Visits dated in the future indicate data entry errors or test records in production |
| QC-V4 | Invalid medication frequency | Non-standard frequencies cause confusion in medication reconciliation |

### Category 3: Consistency Checks

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-CS1 | Encounter date before patient DOB | Impossible temporal relationship, often from EHR system migration errors |
| QC-CS2 | Medication end_date before start_date | Logically impossible, indicates data entry error in prescription management |
| QC-CS3 | Diagnosis date >7 days from encounter | Suggests wrong encounter linkage, critical for tracking disease progression in conditions like MS |
| QC-CS4 | Medication start_date before patient DOB | Prescription cannot predate birth, indicates field mapping errors |

### Category 4: Duplicate Detection

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-D1 | Duplicate patients (name+DOB) | Fragmented records risk missed drug interactions, especially for anti-epileptic drugs with narrow therapeutic windows |
| QC-D2 | Duplicate encounters (patient+date+type) | Double-billed visits and inflated utilization metrics |
| QC-D3 | Duplicate diagnosis per encounter | Same ICD-10 code entered twice wastes clinical resources and distorts prevalence data |

### Category 5: Statistical Outlier Detection

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-S1 | Dosage outliers (AVG +/- 2*STDDEV) | Extreme dosages of narrow-therapeutic-index drugs (Carbamazepine, Valproic Acid) can cause hepatotoxicity or Stevens-Johnson syndrome |
| QC-S2 | Zero/NULL dosages | A zero-dose prescription is never clinically valid |

### Category 6: Cross-Table Integrity

| Check | Purpose | Neurology Context |
|-------|---------|-------------------|
| QC-X1 | Medications with NULL diagnosis_id | Every prescription should trace to a diagnosis for medication reconciliation |
| QC-X2 | Medications referencing missing diagnosis | Broken FK indicates deleted or never-created diagnosis records |
| QC-X3 | Diagnoses referencing missing encounter | Orphan diagnoses indicate workflow breakdown in the order-entry system |
| QC-X4 | Orphaned records summary | Aggregate dashboard of all cross-table integrity issues |

## Dashboard Output

The final query in `qc_checks.sql` produces a summary dashboard showing total record counts and counts of each issue type in a single result set, giving a quick overview of overall data quality.

## Clinical Conditions Covered

The dataset uses realistic neurology conditions and their standard ICD-10 codes:

| Condition | ICD-10 | Common Medications | Typical Dosage (mg) |
|-----------|--------|-------------------|---------------------|
| Epilepsy (generalized) | G40.309 | Levetiracetam, Valproic Acid, Lamotrigine | 250-3000 |
| Epilepsy (focal) | G40.109 | Carbamazepine, Lacosamide | 200-1200 |
| Migraine without aura | G43.009 | Sumatriptan, Topiramate | 25-200 |
| Migraine with aura | G43.109 | Sumatriptan, Amitriptyline | 25-100 |
| Parkinson disease | G20 | Levodopa/Carbidopa, Pramipexole | 100-1000 |
| Multiple sclerosis | G35 | Dimethyl Fumarate, Fingolimod | 120-240 |
| Peripheral neuropathy | G62.9 | Gabapentin, Pregabalin, Duloxetine | 75-3600 |
| Alzheimer disease | G30.9 | Donepezil, Memantine, Rivastigmine | 5-23 |
| Essential tremor | G25.0 | Propranolol, Primidone | 40-320 |
| Restless legs syndrome | G25.81 | Pramipexole | 0.25-1.5 |

## Technical Notes

- **FK checks disabled during seeding:** `seed_data.sql` uses `SET FOREIGN_KEY_CHECKS = 0` to insert orphan records (encounter_id 998/999, diagnosis_id 997) that would otherwise be rejected. This is restored at the end of the file.
- **MySQL REGEXP:** The ICD-10 validation uses MySQL 8.0 ICU regex syntax with `\\. ` for literal dot matching inside SQL strings.
- **STDDEV edge case:** The outlier query uses `HAVING COUNT(*) >= 2` and `NULLIF(stddev_dosage, 0)` to avoid division-by-zero when a medication appears only once.
