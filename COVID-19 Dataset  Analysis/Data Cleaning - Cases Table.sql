/*
  Cleaning Cases Table
*/

-- Selecting All the Data
SELECT * FROM Cases


-- Deleting Null Columns
ALTER TABLE Cases
DROP COLUMN IF EXISTS F17, 
     COLUMN IF EXISTS F19, 
	 COLUMN IF EXISTS F20;


-- Deleting Useless Columns
ALTER TABLE Cases
DROP COLUMN IF EXISTS iso_code,
     COLUMN IF EXISTS new_cases_smoothed, 
     COLUMN IF EXISTS new_deaths_smoothed, 
	 COLUMN IF EXISTS new_cases_smoothed_per_million, 
	 COLUMN IF EXISTS new__smoothed_per_million;



-- Convert Data Types into int, float & date for varchar 
ALTER TABLE Cases ALTER COLUMN total_cases float
ALTER TABLE Cases ALTER COLUMN new_cases float
ALTER TABLE Cases ALTER COLUMN total_deaths float
ALTER TABLE Cases ALTER COLUMN new_deaths float
ALTER TABLE Cases ALTER COLUMN new_cases_per_million float
ALTER TABLE Cases ALTER COLUMN new_deaths_per_million float
ALTER TABLE Cases ALTER COLUMN total_cases_per_million float
ALTER TABLE Cases ALTER COLUMN total_deaths_per_million float
ALTER TABLE Cases ALTER COLUMN date date



-- Replace NULL values in each column by 0
UPDATE CASES
SET new_cases = 0 WHERE new_cases IS NULL
UPDATE CASES
SET new_deaths = 0 WHERE new_deaths IS NULL
UPDATE CASES
SET total_cases = 0 WHERE total_cases IS NULL
UPDATE CASES
SET total_deaths = 0 WHERE total_deaths IS NULL
UPDATE CASES
SET new_cases_per_million = 0 WHERE new_cases_per_million IS NULL
UPDATE CASES
SET new_deaths_per_million = 0 WHERE new_deaths_per_million IS NULL
UPDATE CASES
SET total_cases_per_million = 0 WHERE total_cases_per_million IS NULL
UPDATE CASES
SET total_deaths_per_million = 0 WHERE total_deaths_per_million IS NULL


-- Adding NOT NULL Constraints to Columns location & date
ALTER TABLE Cases ALTER COLUMN location VARCHAR(64) NOT NULL;
ALTER TABLE Cases ALTER COLUMN date date NOT NULL;


-- Creating Composite Key of location & date
ALTER TABLE Cases
ADD CONSTRAINT Composite_Key PRIMARY KEY (location, date)


-- Deleting unnecessory rows containting regions at location fields
DELETE FROM Cases WHERE location IN  ('World', 'Asia', 'Upper middle income', 'Africa', 'Europe', 'Lower middle income', 'North America', 'South America', 'High income', 'European Union')
