# Chinook SQL Analysis - Insights


## 1. Sales Overview

The dataset covers sales from **2021-01-01** to **2025-12-22**.

Total revenue generated during the period was **$2,328.60**, across **412 invoices**, with an average ticket of **$5.65**.

The highest-revenue country was the **USA**, generating **$523.06** across **91 invoices**. This represents approximately **22.46%** of total revenue, making it the strongest market in the dataset.

The next highest-revenue countries were **Canada ($303.96)**, **France ($195.10)**, **Brazil ($190.10)**, and **Germany ($156.48)**. Together, the top five countries generated around **58.78%** of total revenue.

Only **6 out of 24 countries** generated revenue above the average revenue per country. This suggests that revenue is concentrated in a relatively small number of markets.

Chile had the highest average ticket at **$6.66**, followed by Ireland and Hungary at **$6.52**. However, these countries had only **7 invoices each**, so this result should be interpreted carefully due to the small sample size.


## 2. Customer Analysis

The top customer by total spending was **Helena Holý** from the **Czech Republic**, with **$49.62** in total purchases.

Other high-value customers included **Richard Cunningham** from the USA (**$47.62**), **Luis Rojas** from Chile (**$46.62**), **Ladislav Kovács** from Hungary (**$45.62**), and **Hugh O'Reilly** from Ireland (**$45.62**).

Using `ROW_NUMBER()` with `PARTITION BY country` made it possible to identify the best customer within each country. This is more useful than only ranking customers globally because it compares customers within their local market context.

A total of **13 customers** spent above the average spending level of their own country. The strongest positive difference was **Richard Cunningham**, who spent **$47.62**, compared with a USA customer average of **$40.24**.


## 3. Product and Genre Analysis

The highest-revenue genre was **Rock**, generating **$826.65**, which represents **35.50%** of total revenue.

The next strongest genres were **Latin ($382.14 / 16.41%)**, **Metal ($261.36 / 11.22%)**, and **Alternative & Punk ($241.56 / 10.37%)**.

Together, the top four genres generated approximately **73.51%** of total revenue. This shows that sales performance is heavily concentrated in a few music categories.

The top-performing artist by revenue was **Iron Maiden**, generating **$138.60**. Other strong artists included **U2 ($105.93)**, **Metallica ($90.09)**, **Led Zeppelin ($86.13)**, and **Lost ($81.59)**.


## 4. Temporal Analysis

Yearly revenue remained relatively stable across the period:

- **2021:** $449.46
- **2022:** $481.45
- **2023:** $469.58
- **2024:** $477.53
- **2025:** $450.58

The highest-revenue year was **2022**, with **$481.45**.

The highest-revenue month was **2022-01**, with **$52.62**.

Using `LAG()`, monthly revenue was compared with the previous month. The largest positive monthly percentage change occurred in **2023-12**, when revenue increased from **$23.76** to **$37.62**, a **58.33%** increase.

The largest monthly decline occurred in **2023-11**, when revenue decreased from **$37.62** to **$23.76**, a **36.84%** decrease.


## 5. Key Takeaways

- The USA is the strongest market by total revenue.
- The top five countries generate almost 59% of total revenue.
- Rock is the dominant genre, generating over one third of total revenue.
- The top four genres generate more than 73% of total revenue.
- Iron Maiden is the highest-revenue artist in the dataset.
- Customer-level analysis shows that some customers outperform their local country average.
- Monthly and yearly revenue trends are relatively stable, with some isolated peaks and drops.
- CTEs and window functions were especially useful for rankings, customer comparisons, period-over-period analysis, and cumulative metrics.
