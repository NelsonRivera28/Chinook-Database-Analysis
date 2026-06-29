# Chinook-SQL-Analysis

## Project Overview

This project analyzes the Chinook database using SQL to explore sales performance, customer behavior, product and genre trends, and revenue evolution over time.

The goal of the project is to practice real Data Analyst workflows: understanding a relational database, writing business-oriented SQL queries, creating useful metrics, and extracting insights from structured data.

## Dataset

The project uses the **Chinook database**, a sample database that represents a digital music store.

It includes information about:

* Customers
* Invoices
* Invoice lines
* Tracks
* Albums
* Artists
* Genres
* Employees
* Playlists

## Business Questions Analyzed

The analysis is organized into five sections:

### 01. Exploration

Initial exploration of the dataset:

* Number of customers, invoices, tracks, genres, artists, and albums
* Sales date range
* Customers by country
* Tracks by genre
* Albums by artist
* Sample invoice data joined with customer information

### 02. Sales Overview

General business performance:

* Total revenue, number of invoices, and average ticket
* Revenue by country
* Countries with the highest customer count and revenue
* Average ticket by country
* Countries above or below the average revenue by country

### 03. Customer Analysis

Customer behavior and value:

* Customers with the highest number of purchases
* Best customer by country
* Customers above the average spending of their country
* High-ticket customers with low purchase frequency
* Customer segmentation by total spending
* Dormant customers based on last purchase date

### 04. Product and Genre Analysis

Product, genre, and artist performance:

* Genres generating the most revenue
* Revenue share by genre
* Artists generating the most revenue
* Artists with large catalogues but low revenue per track
* Most sold tracks
* Genres with large catalogues but low commercial performance

### 05. Temporal Analysis

Revenue evolution over time:

* Monthly revenue
* Monthly revenue compared with the previous month using `LAG()`
* Monthly percentage variation
* Cumulative revenue using `SUM() OVER()`
* Months above or below the average monthly revenue of their year

## Tools & SQL Techniques Used

### Tools

- MySQL
- MySQL Workbench
- GitHub
- Chinook Database

### SQL Techniques

- Relational database analysis
- Multi-table `JOIN` and `LEFT JOIN`
- Aggregations with `SUM`, `COUNT`, `AVG`, `MIN`, and `MAX`
- `COUNT(DISTINCT)` to avoid duplicated metrics
- `GROUP BY` and `HAVING`
- Common Table Expressions (`CTEs`)
- Window functions:
  - `ROW_NUMBER()`
  - `RANK()`
  - `LAG()`
  - `SUM() OVER()`
  - `AVG() OVER()`
  - `PARTITION BY`
- Date analysis with `YEAR()`, `MONTH()`, `DATE_FORMAT()`, and `DATEDIFF()`
- Conditional logic with `CASE WHEN`
- Revenue, customer, product, and time-based analysis
- Business-oriented SQL reporting


## Project Structure

```text
chinook-sql-analysis/
│
├── 01_exploration.sql
├── 02_sales_overview.sql
├── 03_customer_analysis.sql
├── 04_product_genre_analysis.sql
├── 05_temporal_analysis.sql
├── insights.md
└── README.md
```

## Key Learnings

Through this project, I practiced how to:

* Translate business questions into SQL queries
* Work with a relational database using primary and foreign keys
* Build intermediate tables with CTEs
* Use window functions for rankings, comparisons, and cumulative metrics
* Analyze customers, sales, products, and time-based trends
* Structure a SQL project for portfolio presentation

## Tools Used

* MySQL
* MySQL Workbench
* Chinook Database
* GitHub

## Purpose

This project was built as part of my Data Analyst learning path, with the objective of improving my SQL skills and creating a portfolio-ready analysis based on real business questions.
