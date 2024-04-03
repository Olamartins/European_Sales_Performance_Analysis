/* Main KPIs */
SELECT
	SUM(total_revenue) AS "Total Revenue",
	SUM(total_cost) AS "Total Cost",
	SUM(total_profit) AS "Total Profit",
	COUNT(*) AS "Total Orders"
FROM
europeansales;

/* REVENUE BREAKDOWN */
SELECT 
	EXTRACT(YEAR FROM order_date) AS "Year",
	SUM(total_revenue) AS "Total_Revenue"
FROM europeansales
	GROUP BY "Year"
	ORDER BY "Total_Revenue" DESC;

/* YoY Revenue Growth */

SELECT 
	EXTRACT(YEAR FROM order_date) AS "Year",
	SUM(total_revenue) AS "CY_Revenue",
	LAG(SUM(total_revenue)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS "PY_Revenue",
	SUM(total_revenue) - 
		LAG(SUM(total_revenue)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS "YOY_Difference",
	ROUND((SUM(total_revenue) - 
	 	LAG(SUM(total_revenue)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)))
		/
		(LAG(SUM(total_revenue)) OVER (ORDER BY EXTRACT(YEAR FROM order_date))),2)*100 AS "Percentage_Growth"
FROM europeansales
GROUP BY "Year";

/* Month on Month Revenue Growth */
WITH monthly_metrics AS (
	SELECT
		EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(MONTH FROM order_date) AS month,
		SUM(total_revenue) AS revenue
	FROM europeansales
	GROUP BY 1,2
)
SELECT
	year as Current_year,
	month as Current_month,
	revenue as revenue_cm,
	LAG(year,12) OVER (ORDER BY year, month) as Previuos_year,
	LAG(month, 12) OVER (ORDER BY year, month) as Compared_Month_LY,
	LAG(revenue, 12) OVER (ORDER BY year, month) as LY_monthly_revenue,
	revenue - LAG(revenue, 12) OVER (ORDER BY year, month) as MOM_Diff,
	round(
		(revenue - LAG(revenue, 12) OVER (ORDER BY year, month))/
		   LAG(revenue, 12) OVER (ORDER BY year, month),2
	)*100 as mom_pct_change
FROM monthly_metrics
ORDER BY 1,2;

/* Total Revenue By Item Type */

SELECT item_type, SUM(total_revenue) AS Revenue
FROM europeansales
GROUP BY item_type
ORDER BY Revenue DESC;

/* Total Revenue By Sales Channel From 2010 - 2017 */

SELECT sales_channel, SUM(total_revenue) AS revenue
FROM europeansales
GROUP BY sales_channel;

SELECT EXTRACT(YEAR FROM order_date) AS Year, sales_channel, SUM(total_revenue) AS Revenue
FROM europeansales
GROUP BY Year, sales_channel
ORDER BY Year, Revenue DESC;

/* PROFIT ANALYSIS BREAKDOWN */

SELECT 
	EXTRACT(YEAR FROM order_date) AS "Year",
	SUM(total_profit) AS "Total_Profit"
FROM europeansales
	GROUP BY "Year"
	ORDER BY "Total_Profit" DESC;

/* Analyzing YOY Profit Growth */
WITH monthly_profit AS 
(
	SELECT
	EXTRACT(YEAR FROM order_date) AS year,
	SUM(total_profit) AS total_profit,
	LAG(SUM(total_profit)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS py_profit
	FROM europeansales
	GROUP BY Year
)
SELECT 
	year,
	total_profit,
	py_profit,
	total_profit - py_profit AS YOY_Difference,
	ROUND((total_profit - py_profit) / py_profit,2)*100 AS "Percentage_Growth"
FROM monthly_profit
ORDER BY year;

/* Analyzing Month Over Month Profit Growth */
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

/* Total Profit By Item Type */

SELECT item_type, SUM(total_profit) AS Profit
FROM europeansales
GROUP BY item_type
ORDER BY Profit DESC;

/* Total Profit By Sales Channel From 2010 - 2017 */

SELECT sales_channel, SUM(total_profit) AS profit
FROM europeansales
GROUP BY sales_channel;

SELECT EXTRACT(YEAR FROM order_date) AS Year, sales_channel, SUM(total_profit) AS Profit
FROM europeansales
GROUP BY Year, sales_channel
ORDER BY Year, Profit DESC;