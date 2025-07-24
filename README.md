# 📊 SQL Data Cleaning & EDA Project


## Objective

This project focuses on using SQL to:

Clean and prepare raw layoff data

Perform exploratory data analysis (EDA)

Derive actionable insights from global tech layoffs during 2020–2023



### 📊 Phase 1: Data Cleaning Steps

1️⃣ Created a Staging Table
Duplicated raw data into layoffs_staging

Worked in layoffs_staging2 to preserve original dataset

2️⃣ Removed Duplicate Records
Used ROW_NUMBER() and PARTITION BY to identify duplicates

Kept the first instance and removed the rest

3️⃣ Standardized Text Fields
Unified inconsistent entries:

"CryptoCurrency" and "Crypto Currency" → "Crypto"

"United States." → "United States"

Converted empty strings to NULL

4️⃣ Handled Missing Values
Filled missing industry values using matching company data

Removed rows where both total_laid_off and percentage_laid_off were NULL

5️⃣ Date Format Conversion
Converted string dates from MM/DD/YYYY to SQL DATE (YYYY-MM-DD) using STR_TO_DATE()

Final clean table: layoffs_staging2

### 📊 Phase 2: EDA (Exploratory Data Analysis)

### Key EDA Queries & Insights

#### General Trends:

Maximum single layoff: 26,000 employees

Highest percentage laid off: 100% – multiple startups shut down entirely

Companies like Quibi and BritishVolt raised millions but still shut down

From 2020 to 2023, the companies with the highest layoffs each year were Uber (7,525) in 2020, Bytedance (3,600) in 2021, Meta (11,000) in 2022, and Google (12,000) in 2023.

Meta, Amazon, and Google topped layoffs in 2022–23, reflecting post-pandemic scaling corrections.

#### 📈 Total Layoffs by Country:

United States experienced the highest total layoffs

Layoffs were concentrated in major tech hubs like San Francisco, New York, London, and Bangalore

#### 📈 Layoffs by Location:

Top 5 impacted locations:

San Francisco

New York

London

Bangalore

Seattle

#### 📈 Top Industries by Layoffs:

Retail, Transportation, and Finance were heavily affected

Crypto sector saw a wave of collapses post-2021 boom

#### 📈 Layoffs by Company Stage:

Late Stage and Post-IPO startups were hit the hardest

Many early-stage startups with limited funding also went under

#### 📈 Cumulative Layoffs Over Time (Rolling Total)

Layoffs increased drastically from early 2022

Peaked in January 2023 with 342,696 total layoffs

Continued to rise in Q1 2023, hitting 383,659 by March 2023

#### Insight:

The post-pandemic tech hiring boom led to unsustainable growth in 2021. By late 2022, macroeconomic pressure, inflation, and investor caution triggered mass layoffs across industries.



