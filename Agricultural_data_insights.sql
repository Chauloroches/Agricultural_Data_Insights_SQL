CREATE DATABASE Agricultural_Data_Insights;

USE Agricultural_Data_Insights;

-- Creating the tables
CREATE TABLE production_data(
	production_Date DATE,
    Crop_Type VARCHAR(50),
    Region VARCHAR(30),
    Production_Volume_Tonnes INT,
    Price_Per_Tonne_USD FLOAT,
    Temperature_Celsius FLOAT,
    Rainfall_mm FLOAT
);
ALTER TABLE production_data
RENAME COLUMN production_Date to Date;

CREATE TABLE weather_condition(
	weather_Date DATE,
    Region VARCHAR(30),
    Avg_Temperature_Celsius FLOAT,
    Avg_Rainfall_mm FLOAT
);
ALTER TABLE weather_condition
RENAME COLUMN weather_Date to Date;

CREATE TABLE market_prices(
	Date DATE,	
	Crop_Type VARCHAR(50),
	Region VARCHAR(30),
	Market_Price_Per_Tonne_USD FLOAT
);

CREATE TABLE regions(
	Region VARCHAR(30),
    Soil_Type VARCHAR(30),
    Avg_Elevation_m INT
);

-- Normalize Data: Ensure foreign keys are consistent across tables. For example, Region in Production_Data should match the Region field in Regions.
SELECT COUNT(*)
FROM Production_Data p
LEFT JOIN Regions r
ON p.Region = r.Region
WHERE r.Region IS NULL;

-- Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;

-- Delete Inconsistent Rows
DELETE FROM Production_Data
WHERE Region NOT IN (SELECT Region FROM Regions);

-- Re-enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;

-- Create an Index on Regions.Region
CREATE INDEX idx_region ON Regions (Region);

-- Add a Foreign Key Constraint
ALTER TABLE Production_Data
ADD CONSTRAINT fk_region
FOREIGN KEY (Region) REFERENCES Regions (Region);
 
-- Top 5 Production by Region
SELECT p.Date,p.Crop_Type, p.Region, SUM(p.Production_Volume_Tonnes) Total_Production
FROM Production_Data p
JOIN Weather_Condition w
ON p.Region = w.Region
WHERE w.Avg_Rainfall_mm > 100  -- Example: High rainfall
GROUP BY 1,2,3
ORDER BY 3 DESC
limit 5;

-- Revenue by Region and Crop Type
SELECT p.Region, p.Crop_Type, ROUND(SUM(p.Production_Volume_Tonnes * p.Price_Per_Tonne_USD),2) Total_Revenue
FROM Production_Data p
GROUP BY 1,2
ORDER BY 3 DESC;

-- Market Price Fluctuation
SELECT m.Date,m.Region,m.Crop_Type,m.Market_Price_Per_Tonne_USD, p.Production_Volume_Tonnes
FROM Market_Prices m
JOIN Production_Data p ON m.Date = p.Date AND m.Region = p.Region AND m.Crop_Type = p.Crop_Type
WHERE m.Market_Price_Per_Tonne_USD > 100  -- Example: Price threshold
ORDER BY 3,1;

-- Calculate the high rainfall threshold based on average and standard deviation
WITH RainfallThreshold AS (
    SELECT ROUND(AVG(Avg_Rainfall_mm), 2) + 1.5 * STDDEV(Avg_Rainfall_mm) AS HighRainfallThreshold
    FROM Weather_Condition
),

-- Select months with average rainfall above the threshold
HighRainfallMonths AS (
    SELECT DATE_FORMAT(Date, '%y-%m') AS Month,Region,ROUND(AVG(Avg_Rainfall_mm), 2) AS Avg_Monthly_Rainfall
    FROM Weather_Condition
    GROUP BY 1,2
    HAVING Avg_Monthly_Rainfall >= (SELECT HighRainfallThreshold FROM RainfallThreshold)
)

-- Join high rainfall months with production data to analyze impact on crop production
SELECT h.Month,p.Region,p.Crop_Type,SUM(p.Production_Volume_Tonnes) AS Total_Production,h.Avg_Monthly_Rainfall
FROM HighRainfallMonths h
JOIN Production_Data p 
ON p.Region = h.Region
GROUP BY 1,2,3,5
ORDER BY 1;