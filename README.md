# CO-Trend-Analysis-Moving-Average-Smoothing-Regression
## Overview
This project analyzes atmospheric CO₂ levels from 1959 to 1997 using time series smoothing, moving averages, and regression techniques. The dataset is sourced from the built-in co2 dataset in R, which records monthly CO₂ measurements at Mauna Loa Observatory.

## Features
* Data Preprocessing: Converts time series to numeric format for analysis.
* Time Series Smoothing:
  * Moving Average (12-month): Computes a rolling mean to smooth fluctuations.
  * Exponential Smoothing (α = 0.3): Applies weighted smoothing for trend detection.
* Regression Analysis:
  * Linear Regression: Models the long-term CO₂ trend.
  * Quadratic Regression: Captures possible acceleration in CO₂ growth.
* Model Evaluation:
  * Calculates Residual Sum of Squares (RSS) for both models.
  * Uses an F-test to compare linear vs. quadratic trends.
## Result: Upward Trend in CO₂ Levels
The analysis confirms a consistent upward trend in atmospheric CO₂ levels from 1959 to 1997. Both the moving average and exponential smoothing highlight a steady increase, while quadratic regression suggests that the growth rate is accelerating over time.
## How to Run the Analysis
* Run the script in an R environment (RStudio recommended).
* The co2 dataset is preloaded in R, so no external data is required.
* Modify smoothing parameters (n for moving average, α for exponential smoothing) to explore different trends.
