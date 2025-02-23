create database co2;
use co2;

SELECT * FROM global;

# 'Column MtCO2 per day (i.e CO₂ emissions in metric tons per day) renamed to 'value' for consistency'
ALTER TABLE global RENAME COLUMN MtCO2_per_day TO value;

# Overall CO₂ Emissions Analysis
-----------------------------------

# Total CO₂ Emissions 2024
SELECT SUM(value) AS total_emissions 
FROM global
WHERE country != 'World';

# Total CO₂ Emissions by Country in 2024
SELECT country, SUM(value) AS total_emissions
FROM global
WHERE country != 'World'  
GROUP BY country
ORDER BY total_emissions DESC;

# CO₂ Emissions by Sector
SELECT sector, SUM(value) AS total_emissions 
FROM global
WHERE country != 'World'  
GROUP BY sector 
ORDER BY total_emissions DESC;

# Top 10 Countries with Highest CO₂ Emissions
SELECT country, total_emissions, ranking
FROM (
    SELECT 
        country, 
        SUM(value) AS total_emissions,
        DENSE_RANK() OVER (ORDER BY SUM(value) DESC) AS ranking  
    FROM global
    WHERE country != 'World' 
    GROUP BY country
) ranked_data
WHERE ranking <= 10;

# Average Emissions per Country & Sector
SELECT 
    country, 
    AVG(value) AS avg_emission 
FROM global 
WHERE country != 'World'
GROUP BY country 
ORDER BY avg_emission DESC 
LIMIT 10;

SELECT 
    sector, 
    AVG(value) AS avg_emission 
FROM global 
WHERE country != 'World'
GROUP BY sector 
ORDER BY avg_emission DESC 
LIMIT 10;

# Top 5 Sectors with Highest CO₂ Emissions
SELECT 
    sector, 
    SUM(value) AS total_emission 
FROM global 
WHERE country != 'World'
GROUP BY sector 
ORDER BY total_emission DESC 
LIMIT 5;

# Sector-Wise CO₂ Emissions Distribution
SELECT 
    sector, 
    SUM(value) AS total_emission, 
    (SUM(value) / (SELECT SUM(value) FROM global WHERE country != 'World')) * 100 AS percentage_share 
FROM global 
WHERE country != 'World'
GROUP BY sector 
ORDER BY total_emission DESC;

# Monthly CO₂ Emissions Trends
SELECT 
    MONTHNAME(STR_TO_DATE(date, '%d-%m-%Y')) AS month_name, 
    SUM(value) AS total_emission
FROM global
WHERE country != 'World'
GROUP BY month_name;

# Country-Specific CO₂ Emissions by Sector (TOP 5 are China, ROW, United States, India, EU27 & UK)
SELECT sector, SUM(value) AS total_emission
FROM global
WHERE country = 'China'
GROUP BY sector
ORDER BY total_emission DESC;

SELECT sector, SUM(value) AS total_emission
FROM global
WHERE country = 'ROW'
GROUP BY sector
ORDER BY total_emission DESC;

SELECT sector, SUM(value) AS total_emission
FROM global
WHERE country = 'United States'
GROUP BY sector
ORDER BY total_emission DESC;

SELECT sector, SUM(value) AS total_emission
FROM global
WHERE country = 'India'
GROUP BY sector
ORDER BY total_emission DESC;

SELECT sector, SUM(value) AS total_emission
FROM global
WHERE country = 'EU27 & UK'
GROUP BY sector
ORDER BY total_emission DESC;
