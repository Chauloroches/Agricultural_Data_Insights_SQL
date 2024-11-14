# Project overview:Agricultural Data Insights
## Objectives
This project focuses on analyzing agricultural production and market trends to support data-driven planning for crop production, weather conditions, and sales. By exploring correlations between weather patterns and production metrics, it offers insights to optimize agricultural strategies.
## Database Structure
Database: Agricultural_Data_Insights

### 1.Tables:
#### production_data:
Contains data on crop types, production volumes, prices, and environmental conditions.
Fields: Date, Crop_Type, Region, Production_Volume_Tonnes, Price_Per_Tonne_USD, Temperature_Celsius, Rainfall_mm
#### weather_condition:
Tracks weather metrics by region and date.
Fields: Date, Region, Avg_Temperature_Celsius, Avg_Rainfall_mm
#### market_prices:
Contains market prices for different crops by date and region.
Fields: Date, Crop_Type, Region, Market_Price_Per_Tonne_USD
#### regions:
Stores regional information including soil type and elevation.
Fields: Region, Soil_Type, Avg_Elevation_m

### 1.Data Normalization & Integrity:
Check data integrity in Excel
Verified foreign key consistency (e.g., Region in production_data must match Region in regions).
Cleaned inconsistent records and enabled indexing on Region.

## Key Queries & Insights
Top 5 Production by Region:

Analyzed crop production for regions with high rainfall, listing the top five based on production volume.
Revenue by Region and Crop Type:

Computed total revenue for each crop type by region.
Market Price Fluctuations:

Analyzed market price fluctuations, focusing on cases where prices exceed a set threshold.
High Rainfall Impact on Production:

Identified months with rainfall above a calculated threshold to assess its impact on crop production.

## Conclusion
This project created an in-depth agricultural database for analyzing the relationship between production metrics, market trends, and weather patterns. The insights drawn will help strategize agricultural production and optimize resource allocation based on environmental conditions.

