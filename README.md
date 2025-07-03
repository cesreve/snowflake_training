# ❄️ Snowflake SQL Exercises 📊

A personal repository dedicated to practicing and mastering SQL queries on the Snowflake Data Cloud. This collection of exercises is designed to strengthen data engineering, data warehousing, and analytical skills, with a strong focus on both core SQL concepts and Snowflake-specific functionalities.

## 🚀 Purpose

This repository serves as my personal lab for:
* Solidifying SQL fundamentals.
* Deep diving into advanced SQL patterns.
* Exploring and utilizing Snowflake's unique features.
* Practicing data modeling and transformation challenges relevant to data engineering.

## ✨ Features & Content

You'll find various exercises covering topics such as:

* **Data Definition Language (DDL):** `CREATE`, `ALTER`, `DROP` for databases, schemas, tables, and views.
* **Data Manipulation Language (DML):** `INSERT`, `UPDATE`, `DELETE`, `MERGE` operations.
* **Advanced SQL Concepts:**
    * Window Functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, `SUM/AVG OVER(...)`).
    * Common Table Expressions (CTEs).
    * Subqueries (`IN`, `EXISTS`, correlated subqueries).
    * Date and Time manipulation.
    * String and JSON parsing (`VARIANT` data type handling).
* **Snowflake-Specific Optimizations & Features:**
    * `QUALIFY` clause for simplified window function filtering.
    * `COPY INTO` for efficient data loading from stages.
    * External Stages and Internal Stages.
    * `TIME TRAVEL` for historical data access.
    * `STREAM`s for Change Data Capture (CDC).
    * `TASK`s for scheduling and orchestration.
    * Clustering and Partitioning concepts (though physical implementation may vary in exercises).
* **Data Engineering Patterns:**
    * Identifying and handling duplicates.
    * Calculating running totals and cumulative sums.
    * Implementing simple data quality checks.
    * Data type conversions and handling `NULL` values (`TRY_CAST`, `COALESCE`).

## 📋 Prerequisites

To run these exercises, you will need:

* A **Snowflake Account** (a free 30-day trial account is sufficient).
* **Basic understanding of SQL** syntax.
* Familiarity with **Git and GitHub** for cloning the repository.

## 🚀 How to Use

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YourGitHubUsername/snowflake-sql-exercises.git](https://github.com/YourGitHubUsername/snowflake-sql-exercises.git)
    cd snowflake-sql-exercises
    ```
2.  **Set up your Snowflake environment:**
    * Log in to your Snowflake account via the web UI or your preferred SQL client (e.g., DBeaver, VS Code with Snowflake extension).
    * Ensure you have a database and schema created where you can create tables and run queries (e.g., `USE DATABASE MY_DB; USE SCHEMA MY_DB.MY_SCHEMA;`).
3.  **Run Setup Scripts (if any):**
    * Some exercises might have prerequisite table creations and data insertions. Look for a `setup/` folder or `_setup.sql` files within exercise directories. Run these first.
4.  **Execute Exercises:**
    * Navigate to the exercise files (e.g., `window_functions/running_sum.sql`).
    * Copy the SQL query.
    * Paste it into your Snowflake Worksheet or SQL client.
    * Execute the query.
    * Review the results and try to understand the logic. Feel free to modify and experiment!

## 📂 Repository Structure
Markdown

# ❄️ Snowflake SQL Exercises 📊

A personal repository dedicated to practicing and mastering SQL queries on the Snowflake Data Cloud. This collection of exercises is designed to strengthen data engineering, data warehousing, and analytical skills, with a strong focus on both core SQL concepts and Snowflake-specific functionalities.

## 🚀 Purpose

This repository serves as my personal lab for:
* Solidifying SQL fundamentals.
* Deep diving into advanced SQL patterns.
* Exploring and utilizing Snowflake's unique features.
* Practicing data modeling and transformation challenges relevant to data engineering.

## ✨ Features & Content

You'll find various exercises covering topics such as:

* **Data Definition Language (DDL):** `CREATE`, `ALTER`, `DROP` for databases, schemas, tables, and views.
* **Data Manipulation Language (DML):** `INSERT`, `UPDATE`, `DELETE`, `MERGE` operations.
* **Advanced SQL Concepts:**
    * Window Functions (`ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, `SUM/AVG OVER(...)`).
    * Common Table Expressions (CTEs).
    * Subqueries (`IN`, `EXISTS`, correlated subqueries).
    * Date and Time manipulation.
    * String and JSON parsing (`VARIANT` data type handling).
* **Snowflake-Specific Optimizations & Features:**
    * `QUALIFY` clause for simplified window function filtering.
    * `COPY INTO` for efficient data loading from stages.
    * External Stages and Internal Stages.
    * `TIME TRAVEL` for historical data access.
    * `STREAM`s for Change Data Capture (CDC).
    * `TASK`s for scheduling and orchestration.
    * Clustering and Partitioning concepts (though physical implementation may vary in exercises).
* **Data Engineering Patterns:**
    * Identifying and handling duplicates.
    * Calculating running totals and cumulative sums.
    * Implementing simple data quality checks.
    * Data type conversions and handling `NULL` values (`TRY_CAST`, `COALESCE`).

## 📋 Prerequisites

To run these exercises, you will need:

* A **Snowflake Account** (a free 30-day trial account is sufficient).
* **Basic understanding of SQL** syntax.
* Familiarity with **Git and GitHub** for cloning the repository.

## 🚀 How to Use

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YourGitHubUsername/snowflake-sql-exercises.git](https://github.com/YourGitHubUsername/snowflake-sql-exercises.git)
    cd snowflake-sql-exercises
    ```
2.  **Set up your Snowflake environment:**
    * Log in to your Snowflake account via the web UI or your preferred SQL client (e.g., DBeaver, VS Code with Snowflake extension).
    * Ensure you have a database and schema created where you can create tables and run queries (e.g., `USE DATABASE MY_DB; USE SCHEMA MY_DB.MY_SCHEMA;`).
3.  **Run Setup Scripts (if any):**
    * Some exercises might have prerequisite table creations and data insertions. Look for a `setup/` folder or `_setup.sql` files within exercise directories. Run these first.
4.  **Execute Exercises:**
    * Navigate to the exercise files (e.g., `window_functions/running_sum.sql`).
    * Copy the SQL query.
    * Paste it into your Snowflake Worksheet or SQL client.
    * Execute the query.
    * Review the results and try to understand the logic. Feel free to modify and experiment!

## 📂 Repository Structure

.
├── dd_dml/                   # Exercises on CREATE, INSERT, UPDATE, DELETE
│   ├── create_sample_table.sql
│   └── insert_update_delete_data.sql
├── window_functions/         # Exercises on ROW_NUMBER, RANK, LAG, LEAD, SUM OVER, etc.
│   ├── running_totals.sql
│   └── customer_ranking.sql
├── snowflake_features/       # Exercises leveraging unique Snowflake capabilities
│   ├── time_travel_example.sql
│   ├── copy_into_stage.sql
│   └── stream_task_pipeline.sql
├── data_manipulation/        # General data cleaning, string, date manipulation
│   ├── json_parsing.sql
│   └── date_formatting.sql
├── advanced_sql/             # More complex CTEs, subqueries, analytical challenges
│   └── complex_user_sessions.sql
└── README.md                 # This file

*(Note: The exact folder structure and file names may evolve as more exercises are added.)*

---

Happy querying! Feel free to raise issues or suggestions.
