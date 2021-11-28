/*
  Cleaning Country Table
*/
-- Country table
SELECT * FROM Country 

-- Dropping unnecessary columns
ALTER TABLE Country
DROP COLUMN IF EXISTS iso_code,
     COLUMN IF EXISTS population_density,
	 COLUMN IF EXISTS stringency_index;

-- Adding NOT NULL constraints to columns location & date
ALTER TABLE Country ALTER COLUMN location VARCHAR(64) NOT NULL;
ALTER TABLE Country ALTER COLUMN date date NOT NULL;


-- Creating Composite Key of location & date
ALTER TABLE Country
ADD CONSTRAINT Composite_Key_2 PRIMARY KEY (location, date)

-- Deleting unnecessory rows containting regions at location fields
DELETE FROM Country WHERE location IN  ('World', 'Asia', 'Upper middle income', 'Africa', 'Europe', 'Lower middle income', 'North America', 'South America', 'High income', 'European Union')
