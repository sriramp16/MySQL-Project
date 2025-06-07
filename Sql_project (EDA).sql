-- ==========================================
-- Layoffs Dataset: Data Cleaning SQL Script
-- Steps:
--   1. Create staging table
--   2. Remove duplicates
--   3. Standardize data
--   4. Handle NULLs and blanks
--   5. Drop unnecessary columns
-- Author: Paidisetty Sriram
-- ==========================================

-- Step 1: Create a staging table from original
CREATE TABLE layoffs_staging LIKE layoffs;

-- Insert data into the staging table
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Step 2: Identify and remove duplicates
-- Create a second staging table with row numbers
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  date TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_num INT DEFAULT NULL
);

-- Insert data into layoffs_staging2 with row numbers for duplicate detection
INSERT INTO layoffs_staging2
SELECT *,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, country, funds_raised_millions
  ) AS row_num
FROM layoffs_staging;

-- Disable safe update mode (if enabled)
SET SQL_SAFE_UPDATES = 0;

-- Remove duplicates (rows with row_num > 1)
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Step 3: Standardize text data (remove leading/trailing spaces)
UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry names (example: crypto variations → 'Crypto')
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Standardize country names
UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

-- Step 4: Standardize date format (convert to DATE type)
UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- Modify column to store dates properly
ALTER TABLE layoffs_staging2
MODIFY COLUMN date DATE;

-- Step 5: Handle blank or NULL values
-- Convert empty string in industry to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Fill missing industry by matching same company with known industry
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- Remove rows with no layoff data
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Step 6: Drop helper column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Final data view
SELECT * FROM layoffs_staging2;

