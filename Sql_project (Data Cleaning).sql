-- ==========================================
-- Layoffs Dataset: Exploratory Data Analysis
-- Author: Paidisetty Sriram
-- ==========================================

-- View the cleaned dataset
SELECT * 
FROM world_layoffs.layoffs_staging2;

-- ==========================================
-- 🔍 BASIC EXPLORATION
-- ==========================================

-- Max number of employees laid off in a single entry
SELECT MAX(total_laid_off) AS max_laid_off
FROM world_layoffs.layoffs_staging2;

-- Max and Min percentage of layoffs
SELECT MAX(percentage_laid_off) AS max_percentage,
       MIN(percentage_laid_off) AS min_percentage
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- Companies with 100% layoffs
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- 100% layoffs ordered by funds raised (to find big failures)
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ==========================================
-- 📊 GROUPED ANALYSIS
-- ==========================================

-- Companies with largest single layoff (single record)
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with the most total layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Layoffs by location
SELECT location, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_laid_off DESC
LIMIT 10;

-- Layoffs by country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- Layoffs by year
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY year ASC;

-- Layoffs by industry
SELECT industry, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Layoffs by funding stage
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- ==========================================
-- 🧠 ADVANCED ANALYSIS
-- ==========================================

-- Top 3 companies with most layoffs per year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
  SELECT company, year, total_laid_off,
         DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
  AND year IS NOT NULL
ORDER BY year ASC, total_laid_off DESC;

-- Monthly total layoffs (formatted YYYY-MM)
SELECT DATE_FORMAT(date, '%Y-%m') AS month, 
       SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY month
ORDER BY month ASC;

-- Rolling total layoffs over time (month-wise)
WITH DATE_CTE AS 
(
  SELECT DATE_FORMAT(date, '%Y-%m') AS month, 
         SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  GROUP BY month
)
SELECT month, 
       SUM(total_laid_off) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY month ASC;

-- ==========================================
-- End of EDA
-- ==========================================
