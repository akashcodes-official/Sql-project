-- ------------------------------------------------------------------
-- Exploratory Data Analysis (EDA) on Global Layoffs Dataset
-- ------------------------------------------------------------------
-- Objective: To explore patterns, trends, outliers, and key insights 
-- related to layoffs from 2020 to 2023 using SQL.
-- ------------------------------------------------------------------

-- View all data
SELECT * 
FROM world_layoffs.layoffs_staging2;


--  1. Basic Stats and Observations
-- ------------------------------------------------------------------

-- 1.1 Highest number of layoffs in a single record
SELECT MAX(total_laid_off) AS max_layoffs
FROM world_layoffs.layoffs_staging2;

-- 1.2 Highest and lowest percentage of workforce laid off
SELECT 
    MAX(percentage_laid_off) AS max_percentage,
    MIN(percentage_laid_off) AS min_percentage
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- 1.3 Companies that laid off 100% of their employees
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- 1.4 Companies that raised large funds but still laid off 100%
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ------------------------------------------------------------------
--  2. Grouped Insights
-- ------------------------------------------------------------------

-- 2.1 Companies with the largest single-day layoff
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging
ORDER BY total_laid_off DESC
LIMIT 5;

-- 2.2 Companies with the most total layoffs across all dates
SELECT company, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total DESC
LIMIT 10;

-- 2.3 Locations with the highest layoffs
SELECT location, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total DESC
LIMIT 10;

-- 2.4 Country-wise total layoffs
SELECT country, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total DESC;

-- 2.5 Year-wise layoffs
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY year;

-- 2.6 Industry-wise layoffs
SELECT industry, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total DESC;

-- 2.7 Funding stage-wise layoffs
SELECT stage, SUM(total_laid_off) AS total
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total DESC;


-- ------------------------------------------------------------------
--  3. Advanced Insights
-- ------------------------------------------------------------------

-- 3.1 Top 3 companies with highest layoffs per year
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
ORDER BY year, total_laid_off DESC;

-- 3.2 Monthly layoffs trend
SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY month
ORDER BY month ASC;

-- 3.3 Rolling (Cumulative) layoffs over months
WITH DATE_CTE AS 
(
  SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
  FROM world_layoffs.layoffs_staging2
  GROUP BY month
)
SELECT month, 
       SUM(total_laid_off) OVER (ORDER BY month ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY month ASC;
