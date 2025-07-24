-- View Raw Data
SELECT * FROM world_layoffs.layoffs;

-- Create a Staging Table (Keep original data safe)
CREATE TABLE world_layoffs.layoffs_staging LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging
SELECT * FROM world_layoffs.layoffs;

-- -----------------------------------------------------------
-- Remove Duplicate Records
-- Logic: Keep only the first row for each identical group
-- -----------------------------------------------------------

CREATE TABLE world_layoffs.layoffs_staging2 AS
SELECT * FROM (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
                        `date`, stage, country, funds_raised_millions
           ORDER BY company
         ) AS row_num
  FROM world_layoffs.layoffs_staging
) AS ranked
WHERE row_num = 1;

DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;

-- Drop the helper column after de-duplication
ALTER TABLE world_layoffs.layoffs_staging2 DROP COLUMN row_num;

-- -----------------------------------------------------------
-- Standardize Categorical Text Fields
-- -----------------------------------------------------------

-- Convert empty strings in 'industry' to NULL
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate missing industry values using matching company names
UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Normalize spelling variations in the 'industry' field
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Standardize 'country' values (e.g., "United States." → "United States")
UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- -----------------------------------------------------------
-- Clean and Convert the Date Column
-- -----------------------------------------------------------

-- Convert text to proper DATE format (MM/DD/YYYY to YYYY-MM-DD)
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Change column type from TEXT to DATE
ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

-- -----------------------------------------------------------
-- Handle Nulls and Remove Useless Records
-- -----------------------------------------------------------

-- Remove rows with both total_laid_off AND percentage_laid_off as NULL

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Final cleaned data ready for analysis
SELECT * FROM world_layoffs.layoffs_staging2;
