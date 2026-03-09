-- ============================================================
-- Neurology EHR Data Quality Validation Framework
-- File: schema.sql
-- Purpose: Create database and core tables for neurology clinic EHR
-- Execute: mysql -u root -p < schema.sql
-- ============================================================

DROP DATABASE IF EXISTS neurology_ehr;
CREATE DATABASE neurology_ehr
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE neurology_ehr;

-- ------------------------------------------------------------
-- Table: patients
-- Stores patient demographics. Schema is intentionally loose
-- (no UNIQUE on name+DOB, no ENUM on gender) so that the QC
-- layer can detect duplicates and invalid values.
-- ------------------------------------------------------------
CREATE TABLE patients (
    patient_id   INT            PRIMARY KEY AUTO_INCREMENT,
    first_name   VARCHAR(50)    NOT NULL,
    last_name    VARCHAR(50)    NOT NULL,
    date_of_birth DATE          NOT NULL,
    gender       VARCHAR(10),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    address      VARCHAR(255),
    insurance_id VARCHAR(30),
    created_at   TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- Table: encounters
-- Clinic visits linked to a patient.
-- ------------------------------------------------------------
CREATE TABLE encounters (
    encounter_id   INT            PRIMARY KEY AUTO_INCREMENT,
    patient_id     INT            NOT NULL,
    encounter_date DATE           NOT NULL,
    encounter_type VARCHAR(50)    NOT NULL,
    provider       VARCHAR(100),
    department     VARCHAR(50)    DEFAULT 'Neurology',
    notes          TEXT,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Table: diagnoses
-- Diagnosis records tied to an encounter and patient.
-- icd10_code is VARCHAR without regex CHECK — QC validates.
-- ------------------------------------------------------------
CREATE TABLE diagnoses (
    diagnosis_id   INT            PRIMARY KEY AUTO_INCREMENT,
    encounter_id   INT,
    patient_id     INT,
    icd10_code     VARCHAR(10)    NOT NULL,
    description    VARCHAR(255),
    diagnosis_date DATE,
    status         VARCHAR(20)    DEFAULT 'active',
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (encounter_id) REFERENCES encounters(encounter_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- Table: medications
-- Prescriptions linked to patient and optionally to a diagnosis.
-- diagnosis_id is nullable to allow orphan medication records.
-- ------------------------------------------------------------
CREATE TABLE medications (
    medication_id        INT            PRIMARY KEY AUTO_INCREMENT,
    patient_id           INT            NOT NULL,
    diagnosis_id         INT,
    medication_name      VARCHAR(100)   NOT NULL,
    dosage_mg            DECIMAL(10,2),
    frequency            VARCHAR(50),
    start_date           DATE,
    end_date             DATE,
    prescribing_provider VARCHAR(100),
    created_at           TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(diagnosis_id) ON DELETE SET NULL
);

-- ------------------------------------------------------------
-- Indexes for QC query performance
-- ------------------------------------------------------------
CREATE INDEX idx_encounters_patient   ON encounters(patient_id);
CREATE INDEX idx_encounters_date      ON encounters(encounter_date);
CREATE INDEX idx_diagnoses_encounter  ON diagnoses(encounter_id);
CREATE INDEX idx_diagnoses_patient    ON diagnoses(patient_id);
CREATE INDEX idx_diagnoses_icd10      ON diagnoses(icd10_code);
CREATE INDEX idx_medications_patient  ON medications(patient_id);
CREATE INDEX idx_medications_diagnosis ON medications(diagnosis_id);
