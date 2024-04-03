# European Sales Performance Analysis
### A data analysis project that uses PostgreSQL to ingest data and perform analysis to provide useful insights

## Overview
This documentation outlines the high-level details of the “European Sales Performance Analysis” project, which aims to evaluate the sales performance of a company across various European regions.

## Data Source
The dataset for this analysis was sourced from Kaggle, which provides a comprehensive collection of sales data, including transactional records, customer demographics, and product details.

## Tools Used
- **PostgreSQL:** An advanced open-source relational database was utilized for data ingestion, storage, and complex analysis queries.
- **Power BI and Tableau:** For Data visualization.

## Key Performance Indicators (KPIs)
* Total Revenue: The sum of all sales transactions.
* Total Cost: The sum of all costs associated with the sold products.
* Profit: Calculated as `Profit = Total Revenue − Total Cost`
* Total Orders: The count of all completed sales transactions.

## Objectives
This analysis can be used by the sales and marketing teams to strategize and optimize their efforts based on the performance metrics and trends identified.

## Data Analyis
Example of SQL Code for Month-Over-month Profit Growth:

```
  WITH mom_profit_growth AS (
  	SELECT
  		EXTRACT(YEAR FROM order_date) AS year,
  		EXTRACT(MONTH FROM order_date) AS month,
  		SUM(total_profit) AS profit
  	FROM europeansales
  	GROUP BY 1,2
  )
  SELECT
  	year as Current_year,
  	month as Current_month,
  	profit as profit_cm,
  	LAG(year,12) OVER (ORDER BY year, month) as Previuos_year,
  	LAG(month, 12) OVER (ORDER BY year, month) as Compared_Month_LY,
  	LAG(profit, 12) OVER (ORDER BY year, month) as LY_monthly_profit,
  	profit - LAG(profit, 12) OVER (ORDER BY year, month) as MOM_Diff,
  	round(
  		(profit - LAG(profit, 12) OVER (ORDER BY year, month))/
  		   LAG(profit, 12) OVER (ORDER BY year, month),2
  	)*100 as mom_pct_change
  FROM mom_profit_growth
  ORDER BY 1,2;
```

## Conclusion
The “European Sales Performance Analysis” project leverages robust data analysis techniques to provide a clear picture of the company’s sales performance, enabling data-driven decision-making for future strategies.

## For Visualization
Kindly visit: https://www.novypro.com/project/european-sales-performance-from-2010-to-2017
