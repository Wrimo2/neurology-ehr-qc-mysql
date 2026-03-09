-- ============================================================
-- Neurology EHR Data Quality Validation Framework
-- File: seed_data.sql
-- Purpose: Populate tables with synthetic neurology data
--          containing INTENTIONAL dirty records for QC testing
-- Execute: mysql -u root -p neurology_ehr < seed_data.sql
-- ============================================================

USE neurology_ehr;

-- Disable FK checks to allow orphan records (encounter_id 998/999, diagnosis_id 997)
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- PATIENTS (40 rows)
-- Defects: 2 duplicate pairs, 2 missing phone+email,
--          2 invalid gender values
-- ============================================================
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, phone, email, address, insurance_id) VALUES
-- Clean patients (1-10)
(1,  'Robert',    'Johnson',    '1952-08-14', 'Male',   '555-0101', 'rjohnson@email.com',    '123 Oak St, Boston, MA',        'INS-10001'),
(2,  'Linda',     'Williams',   '1968-11-23', 'Female', '555-0102', 'lwilliams@email.com',   '456 Elm Ave, Chicago, IL',      'INS-10002'),
(3,  'James',     'Brown',      '1975-03-07', 'Male',   '555-0103', 'jbrown@email.com',      '789 Pine Rd, Houston, TX',      'INS-10003'),
(4,  'Patricia',  'Davis',      '1960-06-30', 'Female', '555-0104', 'pdavis@email.com',      '321 Maple Dr, Phoenix, AZ',     'INS-10004'),
(5,  'Maria',     'Garcia',     '1965-03-12', 'Female', '555-0105', 'mgarcia@email.com',     '654 Cedar Ln, San Diego, CA',   'INS-10005'),
(6,  'David',     'Martinez',   '1980-09-18', 'Male',   '555-0106', 'dmartinez@email.com',   '987 Birch St, Dallas, TX',      'INS-10006'),
(7,  'Susan',     'Anderson',   '1973-12-01', 'Female', '555-0107', 'sanderson@email.com',   '147 Walnut Ave, San Jose, CA',  'INS-10007'),
(8,  'Michael',   'Taylor',     '1958-04-22', 'Male',   '555-0108', 'mtaylor@email.com',     '258 Spruce Rd, Austin, TX',     'INS-10008'),
(9,  'Jennifer',  'Thomas',     '1985-07-16', 'Female', '555-0109', 'jthomas@email.com',     '369 Ash Dr, Jacksonville, FL',  'INS-10009'),
(10, 'William',   'Jackson',    '1948-01-05', 'Male',   '555-0110', 'wjackson@email.com',    '741 Willow Ln, Columbus, OH',   'INS-10010'),

-- Clean patients (11-20) — patient 11 is DEFECT: NULL phone AND email
(11, 'Elizabeth', 'White',      '1970-10-28', 'Female', NULL,       NULL,                     '852 Poplar St, Charlotte, NC',  'INS-10011'),  -- DEFECT: no contact info
(12, 'Richard',  'Harris',     '1955-05-19', 'Male',   '555-0112', 'rharris@email.com',     '963 Hickory Ave, Indianapolis, IN', 'INS-10012'),
(13, 'Barbara',  'Clark',      '1982-02-14', 'Female', '555-0113', 'bclark@email.com',      '159 Cypress Rd, San Francisco, CA', 'INS-10013'),
(14, 'Charles',  'Lewis',      '1963-08-03', 'Male',   '555-0114', 'clewis@email.com',      '357 Magnolia Dr, Seattle, WA',  'INS-10014'),
(15, 'Margaret', 'Robinson',   '1977-11-11', 'Female', '555-0115', 'mrobinson@email.com',   '468 Dogwood Ln, Denver, CO',    'INS-10015'),
(16, 'Joseph',   'Walker',     '1990-04-25', 'Male',   '555-0116', 'jwalker@email.com',     '579 Sycamore St, Nashville, TN','INS-10016'),
(17, 'Dorothy',  'Hall',       '1945-09-08', 'Female', '555-0117', 'dhall@email.com',       '681 Chestnut Ave, Portland, OR','INS-10017'),
(18, 'Thomas',   'Allen',      '1988-06-20', 'Male',   '555-0118', 'tallen@email.com',      '792 Beech Rd, Las Vegas, NV',   'INS-10018'),
(19, 'Sarah',    'Young',      '1972-01-30', 'Female', '555-0119', 'syoung@email.com',      '804 Redwood Dr, Memphis, TN',   'INS-10019'),
(20, 'Daniel',   'King',       '1956-12-17', 'Male',   '555-0120', 'dking@email.com',       '915 Sequoia Ln, Louisville, KY','INS-10020'),

-- Clean patients (21-30) — patient 25 is DEFECT: gender = 'Unknown', patient 29 is DEFECT: NULL phone+email
(21, 'Nancy',    'Wright',     '1983-03-22', 'Female', '555-0121', 'nwright@email.com',     '101 Ivy St, Baltimore, MD',     'INS-10021'),
(22, 'Paul',     'Lopez',      '1967-07-14', 'Male',   '555-0122', 'plopez@email.com',      '202 Fern Ave, Milwaukee, WI',   'INS-10022'),
(23, 'Karen',    'Hill',       '1979-05-09', 'Female', '555-0123', 'khill@email.com',       '303 Moss Rd, Albuquerque, NM',  'INS-10023'),
(24, 'Steven',   'Scott',      '1953-10-02', 'Male',   '555-0124', 'sscott@email.com',      '404 Clover Dr, Tucson, AZ',     'INS-10024'),
(25, 'Betty',    'Green',      '1961-08-26', 'Unknown','555-0125', 'bgreen@email.com',      '505 Sage Ln, Fresno, CA',       'INS-10025'),  -- DEFECT: invalid gender
(26, 'George',   'Adams',      '1986-02-11', 'Male',   '555-0126', 'gadams@email.com',      '606 Thyme St, Sacramento, CA',  'INS-10026'),
(27, 'Helen',    'Nelson',     '1974-04-18', 'Female', '555-0127', 'hnelson@email.com',     '707 Basil Ave, Kansas City, MO','INS-10027'),
(28, 'Edward',   'Carter',     '1950-06-05', 'Male',   '555-0128', 'ecarter@email.com',     '808 Dill Rd, Mesa, AZ',         'INS-10028'),
(29, 'Sandra',   'Mitchell',   '1992-09-13', 'N/A',    NULL,       NULL,                     '909 Mint Dr, Omaha, NE',        'INS-10029'),  -- DEFECT: invalid gender + no contact
(30, 'Kenneth',  'Perez',      '1969-11-27', 'Male',   '555-0130', 'kperez@email.com',      '111 Rosemary Ln, Raleigh, NC',  'INS-10030'),

-- Clean patients (31-37)
(31, 'Donna',    'Roberts',    '1981-01-15', 'Female', '555-0131', 'droberts@email.com',    '222 Parsley St, Cleveland, OH', 'INS-10031'),
(32, 'Brian',    'Turner',     '1957-08-09', 'Male',   '555-0132', 'bturner@email.com',     '333 Oregano Ave, Tampa, FL',    'INS-10032'),
(33, 'Carol',    'Phillips',   '1984-12-03', 'Female', '555-0133', 'cphillips@email.com',   '444 Cumin Rd, Pittsburgh, PA',  'INS-10033'),
(34, 'Ronald',   'Campbell',   '1946-03-21', 'Male',   '555-0134', 'rcampbell@email.com',   '555 Nutmeg Dr, Cincinnati, OH', 'INS-10034'),
(35, 'Lisa',     'Parker',     '1993-06-14', 'Female', '555-0135', 'lparker@email.com',     '666 Cinnamon Ln, Orlando, FL',  'INS-10035'),
(36, 'Anthony',  'Evans',      '1971-10-08', 'Male',   '555-0136', 'aevans@email.com',      '777 Vanilla St, St Louis, MO',  'INS-10036'),
(37, 'Ruth',     'Edwards',    '1964-05-29', 'Female', '555-0137', 'redwards@email.com',    '888 Cocoa Ave, Minneapolis, MN','INS-10037'),

-- DEFECT: Duplicate patients (same name+DOB as patient 5 and patient 3)
(38, 'Maria',    'Garcia',     '1965-03-12', 'Female', '555-0238', 'mgarcia2@email.com',    '100 Hazel St, Los Angeles, CA', 'INS-10038'),  -- DUPLICATE of patient 5
(39, 'James',    'Brown',      '1975-03-07', 'Male',   '555-0239', 'jbrown2@email.com',     '200 Laurel Ave, Miami, FL',     'INS-10039'),  -- DUPLICATE of patient 3

-- Patient 40: no encounters will be linked (orphan patient for QC-C2)
(40, 'Victor',   'Ramirez',    '1987-04-16', 'Male',   '555-0140', 'vramirez@email.com',    '300 Juniper Rd, Detroit, MI',   'INS-10040');


-- ============================================================
-- ENCOUNTERS (80 rows)
-- Defects: 3 dates before patient DOB, 6 with no linked diagnosis,
--          4 NULL providers, 3 duplicate pairs, 2 future dates
-- ============================================================
INSERT INTO encounters (encounter_id, patient_id, encounter_date, encounter_type, provider, department, notes) VALUES
-- Clean encounters (1-20)
(1,  1,  '2024-01-15', 'initial',    'Dr. Sarah Chen',       'Neurology', 'New patient evaluation for tremor'),
(2,  1,  '2024-04-10', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Tremor follow-up, medication adjustment'),
(3,  2,  '2024-02-08', 'initial',    'Dr. James Okafor',     'Neurology', 'Chronic headache evaluation'),
(4,  2,  '2024-06-12', 'follow-up',  'Dr. James Okafor',     'Neurology', 'Migraine management review'),
(5,  3,  '2024-03-20', 'initial',    'Dr. Priya Patel',      'Neurology', 'Seizure workup'),
(6,  3,  '2024-07-18', 'follow-up',  'Dr. Priya Patel',      'Neurology', 'Epilepsy medication review'),
(7,  4,  '2024-01-22', 'initial',    'Dr. Michael Rodriguez','Neurology', 'Progressive memory loss evaluation'),
(8,  4,  '2024-05-30', 'follow-up',  'Dr. Michael Rodriguez','Neurology', 'Cognitive assessment follow-up'),
(9,  5,  '2024-02-14', 'initial',    'Dr. Anna Kowalski',    'Neurology', 'Numbness and tingling in extremities'),
(10, 5,  '2024-08-05', 'follow-up',  'Dr. Anna Kowalski',    'Neurology', 'Neuropathy treatment review'),
(11, 6,  '2024-03-11', 'initial',    'Dr. David Nguyen',     'Neurology', 'First seizure evaluation'),
(12, 6,  '2024-09-15', 'follow-up',  'Dr. David Nguyen',     'Neurology', 'EEG review and medication titration'),  -- DEFECT: no diagnosis will be linked
(13, 7,  '2024-04-02', 'initial',    'Dr. Rachel Thompson',  'Neurology', 'Chronic daily headache'),
(14, 7,  '2024-10-20', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Headache diary review'),
(15, 8,  '2024-01-08', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Parkinson disease screening'),
(16, 8,  '2024-06-25', 'follow-up',  'Dr. Amit Sharma',      'Neurology', 'Motor symptom progression'),
(17, 9,  '2024-05-14', 'initial',    'Dr. Sarah Chen',       'Neurology', 'MS symptom evaluation'),
(18, 9,  '2024-11-08', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'MS relapse assessment'),
(19, 10, '2024-02-28', 'initial',    'Dr. James Okafor',     'Neurology', 'Alzheimer screening'),
(20, 10, '2024-07-22', 'follow-up',  'Dr. James Okafor',     'Neurology', 'Cognitive decline monitoring'),

-- Clean encounters (21-40)
(21, 12, '2024-03-05', 'initial',    'Dr. Priya Patel',      'Neurology', 'Carpal tunnel evaluation'),
(22, 13, '2024-04-18', 'initial',    'Dr. Michael Rodriguez','Neurology', 'Migraine with aura workup'),
(23, 14, '2024-05-22', 'initial',    'Dr. Anna Kowalski',    'Neurology', 'Essential tremor evaluation'),
(24, 15, '2024-06-08', 'initial',    'Dr. David Nguyen',     'Neurology', 'Peripheral neuropathy assessment'),
(25, 15, '2024-11-15', 'follow-up',  'Dr. David Nguyen',     'Neurology', 'Neuropathy management'),  -- DEFECT: no diagnosis linked
(26, 16, '2024-02-19', 'initial',    'Dr. Rachel Thompson',  'Neurology', 'First-time seizure in young adult'),
(27, 17, '2024-03-28', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Memory concerns in elderly'),
(28, 18, '2024-07-01', 'initial',    'Dr. Sarah Chen',       'Neurology', 'Recurrent headaches'),
(29, 19, '2024-08-12', 'initial',    'Dr. James Okafor',     'Neurology', 'Numbness evaluation'),
(30, 20, '2024-09-03', 'initial',    'Dr. Priya Patel',      'Neurology', 'Tremor and rigidity workup'),
(31, 21, '2024-01-30', 'initial',    'Dr. Michael Rodriguez','Neurology', 'MS initial consult'),
(32, 22, '2024-04-25', 'initial',    'Dr. Anna Kowalski',    'Neurology', 'Epilepsy monitoring'),
(33, 23, '2024-05-10', 'telehealth', 'Dr. David Nguyen',     'Neurology', 'Migraine telehealth check-in'),  -- DEFECT: no diagnosis linked
(34, 24, '2024-06-15', 'initial',    'Dr. Rachel Thompson',  'Neurology', 'Parkinson evaluation'),
(35, 26, '2024-07-20', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Post-concussion syndrome'),
(36, 27, '2024-08-30', 'initial',    'Dr. Sarah Chen',       'Neurology', 'Trigeminal neuralgia'),
(37, 28, '2024-09-18', 'initial',    'Dr. James Okafor',     'Neurology', 'Alzheimer progression check'),
(38, 30, '2024-10-05', 'initial',    'Dr. Priya Patel',      'Neurology', 'Restless leg syndrome'),
(39, 31, '2024-11-12', 'initial',    'Dr. Michael Rodriguez','Neurology', 'Chronic pain with neuropathy'),
(40, 32, '2024-01-18', 'initial',    'Dr. Anna Kowalski',    'Neurology', 'Parkinson medication review'),

-- Clean encounters (41-55)
(41, 33, '2024-02-22', 'initial',    'Dr. David Nguyen',     'Neurology', 'New-onset seizures'),
(42, 34, '2024-03-15', 'initial',    'Dr. Rachel Thompson',  'Neurology', 'Dementia evaluation'),
(43, 35, '2024-04-08', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Migraine in young female'),
(44, 36, '2024-05-30', 'initial',    'Dr. Sarah Chen',       'Neurology', 'Peripheral neuropathy workup'),
(45, 37, '2024-06-20', 'initial',    'Dr. James Okafor',     'Neurology', 'Epilepsy medication change'),
(46, 1,  '2024-08-18', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Tremor stable, continue meds'),
(47, 2,  '2024-10-02', 'telehealth', 'Dr. James Okafor',     'Neurology', 'Migraine check-in'),  -- DEFECT: no diagnosis linked
(48, 3,  '2024-11-25', 'follow-up',  'Dr. Priya Patel',      'Neurology', 'Seizure freedom assessment'),
(49, 12, '2024-09-10', 'follow-up',  'Dr. Priya Patel',      'Neurology', 'Post-surgery carpal tunnel review'),
(50, 16, '2024-08-05', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Seizure control check'),
(51, 17, '2024-07-14', 'follow-up',  'Dr. Amit Sharma',      'Neurology', 'Alzheimer caregiver meeting'),
(52, 22, '2024-10-30', 'follow-up',  'Dr. Anna Kowalski',    'Neurology', 'EEG follow-up'),
(53, 27, '2024-12-01', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Neuralgia pain management'),
(54, 30, '2024-12-15', 'follow-up',  'Dr. Priya Patel',      'Neurology', 'RLS sleep study results'),
(55, 36, '2024-11-20', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Nerve conduction follow-up'),

-- DEFECT: NULL provider (encounters 56-59)
(56, 13, '2024-09-22', 'follow-up',  NULL,                    'Neurology', 'Migraine follow-up'),
(57, 14, '2024-10-14', 'follow-up',  NULL,                    'Neurology', 'Tremor reassessment'),
(58, 19, '2024-12-05', 'follow-up',  NULL,                    'Neurology', 'Neuropathy check'),  -- DEFECT: also no diagnosis linked
(59, 21, '2024-06-28', 'follow-up',  NULL,                    'Neurology', 'MS medication review'),

-- DEFECT: Encounter date BEFORE patient DOB
(60, 6,  '1975-06-10', 'initial',    'Dr. David Nguyen',     'Neurology', 'Data migration artifact'),   -- Patient 6 DOB: 1980-09-18
(61, 9,  '1980-01-01', 'emergency',  'Dr. Sarah Chen',       'Neurology', 'Impossible historical record'), -- Patient 9 DOB: 1985-07-16
(62, 16, '1985-03-20', 'initial',    'Dr. Rachel Thompson',  'Neurology', 'System migration error'),    -- Patient 16 DOB: 1990-04-25

-- DEFECT: Duplicate encounters (same patient + date + type)
(63, 7,  '2024-10-20', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Duplicate entry - headache review'),  -- DUPLICATE of encounter 14
(64, 7,  '2024-10-20', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Triplicate entry - headache review'), -- DUPLICATE of encounter 14
(65, 3,  '2024-03-20', 'initial',    'Dr. Priya Patel',      'Neurology', 'Duplicate entry - seizure workup'),   -- DUPLICATE of encounter 5
(66, 8,  '2024-01-08', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Duplicate entry - Parkinson screening'), -- DUPLICATE of encounter 15

-- DEFECT: Future encounter dates
(67, 18, '2027-06-15', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Scheduled far in advance'),
(68, 26, '2027-09-01', 'initial',    'Dr. Amit Sharma',      'Neurology', 'Future placeholder entry'),

-- DEFECT: no diagnosis linked (encounter 69)
(69, 35, '2024-10-10', 'telehealth', 'Dr. Amit Sharma',      'Neurology', 'Quick telehealth check-in'),

-- Clean encounters (70-80)
(70, 4,  '2024-09-14', 'follow-up',  'Dr. Michael Rodriguez','Neurology', 'Alzheimer medication titration'),
(71, 20, '2024-11-28', 'follow-up',  'Dr. Priya Patel',      'Neurology', 'Parkinson motor assessment'),
(72, 24, '2024-12-10', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Parkinson gait analysis'),
(73, 31, '2025-01-08', 'follow-up',  'Dr. Michael Rodriguez','Neurology', 'Chronic pain reassessment'),
(74, 32, '2024-05-20', 'follow-up',  'Dr. Anna Kowalski',    'Neurology', 'Parkinson medication adjustment'),
(75, 33, '2024-07-15', 'follow-up',  'Dr. David Nguyen',     'Neurology', 'Seizure diary review'),
(76, 34, '2024-08-22', 'follow-up',  'Dr. Rachel Thompson',  'Neurology', 'Dementia behavioral assessment'),
(77, 35, '2024-12-18', 'follow-up',  'Dr. Amit Sharma',      'Neurology', 'Migraine prophylaxis review'),
(78, 36, '2025-01-15', 'follow-up',  'Dr. Sarah Chen',       'Neurology', 'Neuropathy long-term plan'),
(79, 37, '2024-10-25', 'follow-up',  'Dr. James Okafor',     'Neurology', 'Epilepsy stable on meds'),
(80, 26, '2024-12-08', 'follow-up',  'Dr. Amit Sharma',      'Neurology', 'Post-concussion clearance');


-- ============================================================
-- DIAGNOSES (70 rows)
-- Defects: 5 malformed ICD-10 codes, 3 date mismatches,
--          3 NULL descriptions, 2 duplicate pairs,
--          2 orphan (non-existent encounter_id)
-- ============================================================
INSERT INTO diagnoses (diagnosis_id, encounter_id, patient_id, icd10_code, description, diagnosis_date, status) VALUES
-- Clean diagnoses for encounters 1-20
(1,  1,  1,  'G25.0',   'Essential tremor',                         '2024-01-15', 'active'),
(2,  2,  1,  'G25.0',   'Essential tremor - follow-up',             '2024-04-10', 'active'),
(3,  3,  2,  'G43.009', 'Migraine without aura, not intractable',   '2024-02-08', 'active'),
(4,  4,  2,  'G43.009', 'Migraine without aura - management',       '2024-06-12', 'active'),
(5,  5,  3,  'G40.309', 'Generalized epilepsy, not intractable',    '2024-03-20', 'active'),
(6,  6,  3,  'G40.309', 'Epilepsy - medication review',             '2024-07-18', 'chronic'),
(7,  7,  4,  'G30.9',   'Alzheimer disease, unspecified',           '2024-01-22', 'active'),
(8,  8,  4,  'G30.9',   'Alzheimer disease - progression',          '2024-05-30', 'chronic'),
(9,  9,  5,  'G62.9',   'Polyneuropathy, unspecified',              '2024-02-14', 'active'),
(10, 10, 5,  'G62.9',   'Neuropathy - treatment response',          '2024-08-05', 'active'),
(11, 11, 6,  'G40.109', 'Focal epilepsy, not intractable',          '2024-03-11', 'active'),
-- encounter 12 intentionally has NO diagnosis (defect)
(12, 13, 7,  'G43.109', 'Migraine with aura, not intractable',      '2024-04-02', 'active'),
(13, 14, 7,  'G43.109', 'Migraine with aura - diary review',        '2024-10-20', 'active'),
(14, 15, 8,  'G20',     'Parkinson disease',                        '2024-01-08', 'chronic'),
(15, 16, 8,  'G20',     'Parkinson disease - motor progression',    '2024-06-25', 'chronic'),
(16, 17, 9,  'G35',     'Multiple sclerosis',                       '2024-05-14', 'active'),
(17, 18, 9,  'G35',     'MS relapse evaluation',                    '2024-11-08', 'active'),
(18, 19, 10, 'G30.9',   'Alzheimer disease, unspecified',           '2024-02-28', 'chronic'),
(19, 20, 10, 'G30.9',   'Alzheimer - cognitive decline',            '2024-07-22', 'chronic'),

-- Clean diagnoses for encounters 21-55
(20, 21, 12, 'G56.00',  'Carpal tunnel syndrome, unspecified',      '2024-03-05', 'active'),
(21, 22, 13, 'G43.109', 'Migraine with aura',                       '2024-04-18', 'active'),
(22, 23, 14, 'G25.0',   'Essential tremor',                         '2024-05-22', 'active'),
(23, 24, 15, 'G62.9',   'Peripheral neuropathy',                    '2024-06-08', 'active'),
-- encounter 25 intentionally has NO diagnosis
(24, 26, 16, 'G40.309', 'Generalized epilepsy',                     '2024-02-19', 'active'),
(25, 27, 17, 'G30.9',   'Alzheimer disease',                        '2024-03-28', 'suspected'),
(26, 28, 18, 'G43.009', 'Migraine without aura',                    '2024-07-01', 'active'),
(27, 29, 19, 'G62.9',   'Peripheral neuropathy',                    '2024-08-12', 'active'),
(28, 30, 20, 'G20',     'Parkinson disease',                        '2024-09-03', 'active'),
(29, 31, 21, 'G35',     'Multiple sclerosis',                       '2024-01-30', 'active'),
(30, 32, 22, 'G40.309', 'Generalized epilepsy',                     '2024-04-25', 'chronic'),
-- encounter 33 intentionally has NO diagnosis
(31, 34, 24, 'G20',     'Parkinson disease',                        '2024-06-15', 'active'),
(32, 35, 26, 'G93.5',   'Post-concussion syndrome',                 '2024-07-20', 'active'),
(33, 36, 27, 'G50.0',   'Trigeminal neuralgia',                     '2024-08-30', 'active'),
(34, 37, 28, 'G30.9',   'Alzheimer disease',                        '2024-09-18', 'chronic'),
(35, 38, 30, 'G25.81',  'Restless legs syndrome',                   '2024-10-05', 'active'),
(36, 39, 31, 'G62.9',   'Neuropathic pain',                         '2024-11-12', 'active'),
(37, 40, 32, 'G20',     'Parkinson disease',                        '2024-01-18', 'chronic'),
(38, 41, 33, 'G40.109', 'Focal epilepsy',                           '2024-02-22', 'active'),
(39, 42, 34, 'G30.1',   'Alzheimer disease with late onset',        '2024-03-15', 'active'),
(40, 43, 35, 'G43.009', 'Migraine without aura',                    '2024-04-08', 'active'),
(41, 44, 36, 'G62.9',   'Peripheral neuropathy',                    '2024-05-30', 'active'),
(42, 45, 37, 'G40.309', 'Generalized epilepsy',                     '2024-06-20', 'chronic'),
(43, 46, 1,  'G25.0',   'Essential tremor - stable',                '2024-08-18', 'active'),
-- encounter 47 intentionally has NO diagnosis
(44, 48, 3,  'G40.309', 'Epilepsy - seizure freedom',               '2024-11-25', 'resolved'),
(45, 49, 12, 'G56.00',  'Carpal tunnel - post-surgical',            '2024-09-10', 'resolved'),
(46, 50, 16, 'G40.309', 'Epilepsy - controlled',                    '2024-08-05', 'active'),
(47, 51, 17, 'G30.9',   'Alzheimer disease - caregiver support',    '2024-07-14', 'chronic'),
(48, 52, 22, 'G40.309', 'Epilepsy - EEG stable',                    '2024-10-30', 'chronic'),
(49, 53, 27, 'G50.0',   'Trigeminal neuralgia - pain control',      '2024-12-01', 'active'),
(50, 54, 30, 'G25.81',  'RLS - sleep study results',                '2024-12-15', 'active'),
(51, 55, 36, 'G62.9',   'Neuropathy - nerve conduction stable',     '2024-11-20', 'active'),

-- DEFECT: Malformed ICD-10 codes
(52, 56, 13, 'G409',    NULL,                                        '2024-09-22', 'active'),   -- DEFECT: missing dot + NULL description
(53, 57, 14, 'ABC.1',   'Invalid code - data entry error',          '2024-10-14', 'active'),   -- DEFECT: invalid prefix
(54, 59, 21, 'Z99.1',   'Non-neurology code entered by mistake',    '2024-06-28', 'active'),   -- DEFECT: wrong specialty code
(55, 70, 4,  'G40.',    NULL,                                        '2024-09-14', 'active'),   -- DEFECT: trailing dot + NULL description
(56, 71, 20, '43.0',    NULL,                                        '2024-11-28', 'active'),   -- DEFECT: missing letter prefix + NULL description

-- encounter 58 intentionally has NO diagnosis (NULL provider encounter)

-- DEFECT: Diagnosis date significantly mismatched from encounter date (>7 day gap)
(57, 72, 24, 'G20',     'Parkinson gait analysis',                  '2024-11-01', 'active'),   -- encounter 72 is 2024-12-10, gap = 39 days
(58, 73, 31, 'G62.9',   'Chronic neuropathic pain',                 '2024-12-20', 'active'),   -- encounter 73 is 2025-01-08, gap = 19 days
(59, 74, 32, 'G20',     'Parkinson medication review',              '2024-04-01', 'chronic'),  -- encounter 74 is 2024-05-20, gap = 49 days

-- DEFECT: Duplicate diagnosis per encounter (same ICD-10 on same encounter)
(60, 75, 33, 'G40.109', 'Focal epilepsy - seizure diary',           '2024-07-15', 'active'),
(61, 75, 33, 'G40.109', 'Focal epilepsy - duplicate entry',         '2024-07-15', 'active'),   -- DUPLICATE of diagnosis 60
(62, 76, 34, 'G30.1',   'Alzheimer behavioral assessment',          '2024-08-22', 'chronic'),
(63, 76, 34, 'G30.1',   'Alzheimer behavioral - duplicate',         '2024-08-22', 'chronic'),  -- DUPLICATE of diagnosis 62

-- Clean diagnoses for remaining encounters
(64, 77, 35, 'G43.009', 'Migraine prophylaxis review',              '2024-12-18', 'active'),
(65, 78, 36, 'G62.9',   'Neuropathy long-term management',          '2025-01-15', 'active'),
(66, 79, 37, 'G40.309', 'Epilepsy stable on medication',            '2024-10-25', 'chronic'),
(67, 80, 26, 'G93.5',   'Post-concussion clearance',                '2024-12-08', 'resolved'),

-- DEFECT: Orphan diagnoses referencing non-existent encounter_ids
(68, 998, 5,  'G62.9',  'Orphan diagnosis - encounter missing',     '2024-06-01', 'active'),   -- encounter 998 does not exist
(69, 999, 10, 'G30.9',  'Orphan diagnosis - system error',          '2024-07-20', 'active'),   -- encounter 999 does not exist

-- One more clean diagnosis
(70, 60, 6,  'G40.109', 'Focal epilepsy - historical note',         '1975-06-10', 'active');


-- ============================================================
-- MEDICATIONS (60 rows)
-- Defects: 3 end_date < start_date, 2 zero dosage,
--          3 extreme dosage outliers, 4 NULL diagnosis_id,
--          2 NULL start_date, 1 orphan (non-existent diagnosis_id)
-- ============================================================
INSERT INTO medications (medication_id, patient_id, diagnosis_id, medication_name, dosage_mg, frequency, start_date, end_date, prescribing_provider) VALUES
-- Clean medications (1-20)
(1,  1,  1,  'Propranolol',           80.00,   'twice daily',       '2024-01-15', '2024-07-15', 'Dr. Sarah Chen'),
(2,  1,  2,  'Propranolol',           120.00,  'twice daily',       '2024-04-10', NULL,         'Dr. Sarah Chen'),
(3,  2,  3,  'Sumatriptan',           50.00,   'as needed',         '2024-02-08', NULL,         'Dr. James Okafor'),
(4,  2,  4,  'Topiramate',            50.00,   'once daily',        '2024-06-12', NULL,         'Dr. James Okafor'),
(5,  3,  5,  'Levetiracetam',         1000.00, 'twice daily',       '2024-03-20', NULL,         'Dr. Priya Patel'),
(6,  3,  6,  'Levetiracetam',         1500.00, 'twice daily',       '2024-07-18', NULL,         'Dr. Priya Patel'),
(7,  4,  7,  'Donepezil',             10.00,   'once daily',        '2024-01-22', NULL,         'Dr. Michael Rodriguez'),
(8,  4,  8,  'Memantine',             10.00,   'once daily',        '2024-05-30', NULL,         'Dr. Michael Rodriguez'),
(9,  5,  9,  'Gabapentin',            300.00,  'three times daily', '2024-02-14', NULL,         'Dr. Anna Kowalski'),
(10, 5,  10, 'Pregabalin',            75.00,   'twice daily',       '2024-08-05', NULL,         'Dr. Anna Kowalski'),
(11, 6,  11, 'Carbamazepine',         400.00,  'twice daily',       '2024-03-11', NULL,         'Dr. David Nguyen'),
(12, 7,  12, 'Sumatriptan',           100.00,  'as needed',         '2024-04-02', NULL,         'Dr. Rachel Thompson'),
(13, 7,  13, 'Amitriptyline',         25.00,   'at bedtime',        '2024-10-20', NULL,         'Dr. Rachel Thompson'),
(14, 8,  14, 'Levodopa/Carbidopa',    250.00,  'three times daily', '2024-01-08', NULL,         'Dr. Amit Sharma'),
(15, 8,  15, 'Pramipexole',           0.50,    'three times daily', '2024-06-25', NULL,         'Dr. Amit Sharma'),
(16, 9,  16, 'Dimethyl Fumarate',     240.00,  'twice daily',       '2024-05-14', NULL,         'Dr. Sarah Chen'),
(17, 9,  17, 'Dimethyl Fumarate',     240.00,  'twice daily',       '2024-11-08', NULL,         'Dr. Sarah Chen'),
(18, 10, 18, 'Donepezil',             5.00,    'once daily',        '2024-02-28', NULL,         'Dr. James Okafor'),
(19, 10, 19, 'Memantine',             20.00,   'once daily',        '2024-07-22', NULL,         'Dr. James Okafor'),
(20, 12, 20, 'Gabapentin',            200.00,  'three times daily', '2024-03-05', '2024-09-10', 'Dr. Priya Patel'),

-- Clean medications (21-35)
(21, 13, 21, 'Sumatriptan',           50.00,   'as needed',         '2024-04-18', NULL,         'Dr. Michael Rodriguez'),
(22, 14, 22, 'Primidone',             250.00,  'once daily',        '2024-05-22', NULL,         'Dr. Anna Kowalski'),
(23, 15, 23, 'Pregabalin',            150.00,  'twice daily',       '2024-06-08', NULL,         'Dr. David Nguyen'),
(24, 16, 24, 'Valproic Acid',         500.00,  'twice daily',       '2024-02-19', NULL,         'Dr. Rachel Thompson'),
(25, 17, 25, 'Donepezil',             10.00,   'once daily',        '2024-03-28', NULL,         'Dr. Amit Sharma'),
(26, 18, 26, 'Topiramate',            100.00,  'twice daily',       '2024-07-01', NULL,         'Dr. Sarah Chen'),
(27, 19, 27, 'Gabapentin',            600.00,  'three times daily', '2024-08-12', NULL,         'Dr. James Okafor'),
(28, 20, 28, 'Levodopa/Carbidopa',    300.00,  'three times daily', '2024-09-03', NULL,         'Dr. Priya Patel'),
(29, 21, 29, 'Fingolimod',            0.50,    'once daily',        '2024-01-30', NULL,         'Dr. Michael Rodriguez'),
(30, 22, 30, 'Levetiracetam',         1000.00, 'twice daily',       '2024-04-25', NULL,         'Dr. Anna Kowalski'),
(31, 24, 31, 'Ropinirole',            2.00,    'three times daily', '2024-06-15', NULL,         'Dr. Rachel Thompson'),
(32, 27, 33, 'Carbamazepine',         200.00,  'twice daily',       '2024-08-30', NULL,         'Dr. Sarah Chen'),
(33, 30, 35, 'Pramipexole',           0.25,    'at bedtime',        '2024-10-05', NULL,         'Dr. Priya Patel'),
(34, 31, 36, 'Duloxetine',            60.00,   'once daily',        '2024-11-12', NULL,         'Dr. Michael Rodriguez'),
(35, 32, 37, 'Levodopa/Carbidopa',    200.00,  'three times daily', '2024-01-18', NULL,         'Dr. Anna Kowalski'),

-- Clean medications (36-45)
(36, 33, 38, 'Lamotrigine',           200.00,  'twice daily',       '2024-02-22', NULL,         'Dr. David Nguyen'),
(37, 34, 39, 'Rivastigmine',          6.00,    'twice daily',       '2024-03-15', NULL,         'Dr. Rachel Thompson'),
(38, 35, 40, 'Topiramate',            75.00,   'once daily',        '2024-04-08', NULL,         'Dr. Amit Sharma'),
(39, 36, 41, 'Pregabalin',            100.00,  'twice daily',       '2024-05-30', NULL,         'Dr. Sarah Chen'),
(40, 37, 42, 'Valproic Acid',         750.00,  'twice daily',       '2024-06-20', NULL,         'Dr. James Okafor'),
(41, 26, 32, 'Acetaminophen',         500.00,  'as needed',         '2024-07-20', '2024-08-20', 'Dr. Amit Sharma'),
(42, 28, 34, 'Memantine',             10.00,   'once daily',        '2024-09-18', NULL,         'Dr. James Okafor'),
(43, 22, 48, 'Levetiracetam',         1250.00, 'twice daily',       '2024-10-30', NULL,         'Dr. Anna Kowalski'),
(44, 16, 46, 'Valproic Acid',         500.00,  'twice daily',       '2024-08-05', NULL,         'Dr. Rachel Thompson'),
(45, 35, 64, 'Sumatriptan',           100.00,  'as needed',         '2024-12-18', NULL,         'Dr. Amit Sharma'),

-- DEFECT: end_date BEFORE start_date
(46, 3,  44, 'Lamotrigine',           150.00,  'twice daily',       '2024-06-01', '2024-03-15', 'Dr. Priya Patel'),        -- DEFECT: end before start
(47, 14, 22, 'Propranolol',           40.00,   'once daily',        '2024-08-01', '2024-05-20', 'Dr. Anna Kowalski'),      -- DEFECT: end before start
(48, 20, 28, 'Amantadine',            100.00,  'twice daily',       '2024-10-15', '2024-09-01', 'Dr. Priya Patel'),        -- DEFECT: end before start

-- DEFECT: Zero dosage
(49, 9,  16, 'Interferon Beta-1a',    0.00,    'once weekly',       '2024-06-01', NULL,         'Dr. Sarah Chen'),          -- DEFECT: zero dose
(50, 17, 47, 'Galantamine',           0.00,    'twice daily',       '2024-08-01', NULL,         'Dr. Amit Sharma'),         -- DEFECT: zero dose

-- DEFECT: Extreme dosage outliers
(51, 3,  5,  'Levetiracetam',         50000.00,'twice daily',       '2024-04-01', NULL,         'Dr. Priya Patel'),         -- DEFECT: 50000 mg (normal max ~3000)
(52, 18, 26, 'Topiramate',            9999.00, 'once daily',        '2024-08-01', NULL,         'Dr. Sarah Chen'),          -- DEFECT: 9999 mg (normal max ~400)
(53, 22, 30, 'Levetiracetam',         25000.00,'once daily',        '2024-06-01', NULL,         'Dr. Anna Kowalski'),       -- DEFECT: 25000 mg outlier

-- DEFECT: NULL diagnosis_id (medication with no corresponding diagnosis)
(54, 6,  NULL, 'Lorazepam',           1.00,    'as needed',         '2024-04-15', '2024-05-15', 'Dr. David Nguyen'),        -- DEFECT: no diagnosis
(55, 13, NULL, 'Ibuprofen',           400.00,  'as needed',         '2024-05-01', '2024-06-01', 'Dr. Michael Rodriguez'),   -- DEFECT: no diagnosis
(56, 19, NULL, 'Vitamin B12',         1000.00, 'once daily',        '2024-09-01', NULL,         'Dr. James Okafor'),        -- DEFECT: no diagnosis
(57, 27, NULL, 'Gabapentin',          300.00,  'at bedtime',        '2024-10-01', NULL,         'Dr. Sarah Chen'),          -- DEFECT: no diagnosis

-- DEFECT: NULL start_date
(58, 34, 39, 'Memantine',             20.00,   'once daily',        NULL,         NULL,         'Dr. Rachel Thompson'),     -- DEFECT: no start date
(59, 37, 66, 'Lamotrigine',           100.00,  'twice daily',       NULL,         '2025-06-01', 'Dr. James Okafor'),        -- DEFECT: no start date

-- DEFECT: Medication referencing non-existent diagnosis_id
(60, 10, 997, 'Donepezil',            23.00,   'once daily',        '2024-08-01', NULL,         'Dr. James Okafor');        -- DEFECT: diagnosis 997 doesn't exist


SET FOREIGN_KEY_CHECKS = 1;
