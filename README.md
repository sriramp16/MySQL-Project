# MySQL-Project

# 🧠 Layoffs SQL Project

This project focuses on **data cleaning** and **exploratory data analysis (EDA)** of a global layoffs dataset using **MySQL**.

The data includes records of company layoffs during recent years, particularly around the COVID-19 and post-pandemic economic shifts.

---

## 📂 Project Structure

- `layoffs.csv` – Raw dataset of global layoffs
- `cleaned_data.csv` – Cleaned version of the data after transformation
- `Sql_project.sql` – SQL script for data cleaning (staging, deduplication, standardization)
- `Sql_project._02sql.sql` – SQL script for exploratory data analysis (EDA queries)

---

## 🧼 SQL Data Cleaning Steps

File: `Sql_project.sql`

1. Created staging tables to avoid modifying raw data.
2. Removed exact duplicates using `ROW_NUMBER()` and deleted rows where `row_num > 1`.
3. Trimmed spaces and standardized text formats (e.g., "crypto" to "Crypto").
4. Converted `date` column from `TEXT` to proper `DATE` type.
5. Replaced blank strings with `NULL` values.
6. Filled missing `industry` values using available values from the same company.
7. Removed records with no layoff data.

---

## 📊 Exploratory Data Analysis (EDA)

File: `Sql_project._02sql.sql`

### 🔹 Basic Insights

- Maximum number of people laid off in a single instance.
- Companies with 100% workforce laid off.
- Min/Max percentage of layoffs.
- High-profile shutdowns like Quibi and BritishVolt.

### 🔹 Grouped Trends

- Total layoffs by company, country, location, and industry.
- Year-wise layoffs and funding stage analysis.

### 🔹 Advanced Analysis

- Top 3 companies with most layoffs each year using `DENSE_RANK()`.
- Rolling monthly layoffs using window functions.
- Visualization-ready monthly summaries (useful for dashboarding tools).

---

## 📈 Tools Used

- **SQL (MySQL)** – Data cleaning, transformation, and analysis
- **CSV files** – Raw and cleaned datasets
- *(Optional)* Can be extended to Power BI / Tableau for visualization

---

## 📌 Author

**Paidisetty Sriram**

---

## 🏁 How to Use

1. Clone the repo.
2. Import `layoffs.csv` into your MySQL database.
3. Run `Sql_project.sql` to clean the data.
4. Run `Sql_project._02sql.sql` to explore insights.
