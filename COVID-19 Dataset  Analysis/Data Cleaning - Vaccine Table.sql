/*
  Cleaning Vaccine Table
*/

-- Selecting All the Data
SELECT * FROM Vaccine


-- Deleting Null Columns
ALTER TABLE Vaccine
DROP COLUMN IF EXISTS F17, 
     COLUMN IF EXISTS F19, 
	 COLUMN IF EXISTS F20;


-- Deleting Useless Columns
ALTER TABLE Vaccine
DROP COLUMN IF EXISTS iso_code,
     COLUMN IF EXISTS new_cases_smoothed, 
     COLUMN IF EXISTS new_deaths_smoothed, 
	 COLUMN IF EXISTS new_cases_smoothed_per_million, 
	 COLUMN IF EXISTS new__smoothed_per_million;


-- Convert Data Types into int, float & date for varchar 
ALTER TABLE Vaccine ALTER COLUMN icu_patients int
ALTER TABLE Vaccine ALTER COLUMN icu_patients_per_million float
ALTER TABLE Vaccine ALTER COLUMN hosp_patients int
ALTER TABLE Vaccine ALTER COLUMN hosp_patients_per_million float
ALTER TABLE Vaccine ALTER COLUMN new_tests int
ALTER TABLE Vaccine ALTER COLUMN total_tests int
ALTER TABLE Vaccine ALTER COLUMN total_tests_per_thousand float

ALTER TABLE Vaccine ALTER COLUMN people_fully_vaccinated int
ALTER TABLE Vaccine ALTER COLUMN new_vaccinations int
ALTER TABLE Vaccine ALTER COLUMN total_vaccinations float
ALTER TABLE Vaccine ALTER COLUMN people_vaccinated int
ALTER TABLE Vaccine ALTER COLUMN people_fully_vaccinated int
ALTER TABLE Vaccine ALTER COLUMN total_vaccinations_per_hundred float

ALTER TABLE Vaccine ALTER COLUMN date date



-- Replace NULL values in each column by 0
UPDATE Vaccine
SET icu_patients = 0 WHERE icu_patients IS NULL
UPDATE Vaccine
SET icu_patients_per_million = 0 WHERE icu_patients_per_million IS NULL
UPDATE Vaccine
SET hosp_patients = 0 WHERE hosp_patients IS NULL
UPDATE Vaccine
SET hosp_patients_per_million = 0 WHERE hosp_patients_per_million IS NULL
UPDATE Vaccine
SET new_tests = 0 WHERE new_tests IS NULL
UPDATE Vaccine
SET total_tests = 0 WHERE total_tests IS NULL
UPDATE Vaccine
SET total_tests_per_thousand = 0 WHERE total_tests_per_thousand IS NULL
UPDATE Vaccine
SET new_tests_per_thousand = 0 WHERE new_tests_per_thousand IS NULL
UPDATE Vaccine
SET new_vaccinations=0 WHERE new_vaccinations IS NULL
UPDATE Vaccine
SET people_vaccinated = 0 WHERE new_vaccinations IS NULL
UPDATE Vaccine
SET total_vaccinations = 0 WHERE total_vaccinations IS NULL
UPDATE Vaccine
SET people_vaccinated = 0 WHERE people_vaccinated IS NULL
UPDATE Vaccine
SET people_fully_vaccinated = 0 WHERE people_fully_vaccinated IS NULL
UPDATE Vaccine
SET total_vaccinations_per_hundred = 0 WHERE total_vaccinations_per_hundred IS NULL



-- Adding NOT NULL Constraints to Columns location & date
ALTER TABLE Vaccine ALTER COLUMN location VARCHAR(64) NOT NULL;
ALTER TABLE Vaccine ALTER COLUMN date date NOT NULL;



-- Creating Composite Key of location & date
ALTER TABLE Vaccine
ADD CONSTRAINT Composite_Key_3 PRIMARY KEY (location, date)


-- Deleting unnecessory rows containting regions at location fields
DELETE FROM Vaccine WHERE location IN  ('World', 'Asia', 'Upper middle income', 'Africa', 'Europe', 'Lower middle income', 'North America', 'South America', 'High income', 'European Union')
