# Load CO2 dataset
data("co2")  
ts_data = as.numeric(co2)  # Convert time series to numeric
time_index = 1:length(ts_data)  # Time index for regression

# Plot Original Data
plot(time_index, ts_data, type="l", col="black", lwd=2,
     main="Atmospheric CO₂ Levels (1959-1997)", 
     ylab="CO₂ (ppm)", xlab="Time")

# Function to calculate Moving Average manually
moving_average = function(series, n) 
  {
  ma = rep(NA, length(series))  # Initialize with NA values
  for (i in n:length(series)) 
    {
    ma[i] = mean(series[(i-n+1):i])  # Compute mean of last 'n' values
  }
  return(ma)
}

# Compute 12-month Moving Average (1 Year)
ma_12 = moving_average(ts_data, 12)

# Plot Moving Average
lines(ma_12, col="blue", lwd=2)  # 12 months MA

# Add Legend
legend("topleft", legend = c("Original", "12-MA"), col = c("black", "blue"), lwd = 2)

# Function to compute Exponential Smoothing manually
exp_smoothing = function(series, alpha) 
  {
  smoothed = rep(NA, length(series))  # Initialize with NA values
  smoothed[1] = series[1]  # First value remains unchanged
  for (i in 2:length(series)) 
    {
    smoothed[i] = alpha * series[i] + (1 - alpha) * smoothed[i-1]
  }
  return(smoothed)
}

# Apply Exponential Smoothing with alpha = 0.3
smoothed_co2 = exp_smoothing(ts_data, 0.3)

# Plot Exponential Smoothing
lines(smoothed_co2, col="red", lwd=2)  # Smoothed Trend

# Add Legend
legend("topleft", legend = c("Original", "12-MA", "Exp Smoothing"), 
       col = c("black", "blue", "red"), lwd = 2)


# Compute Mean Function
mean_calc = function(x) 
  {
  return(sum(x) / length(x))
}

# Compute Variance Function
variance_calc = function(x) 
  {
  mu = mean_calc(x)
  return(sum((x - mu)^2) / (length(x) - 1))
}

# Compute Covariance Function
covariance_calc = function(x, y) 
  {
  mu_x = mean_calc(x)
  mu_y = mean_calc(y)
  return(sum((x - mu_x) * (y - mu_y)) / (length(x) - 1))
}

# Linear Regression Coefficients (Y = a + bX)
b1 = covariance_calc(time_index, ts_data) / variance_calc(time_index)
b0 = mean_calc(ts_data) - b1 * mean_calc(time_index)

# Quadratic Regression Coefficients (Y = a + bX + cX²)
X_sq = time_index^2
b2 = (covariance_calc(X_sq, ts_data) - b1 * covariance_calc(X_sq, time_index) / variance_calc(time_index)) /
  variance_calc(X_sq)
b1_adj = (covariance_calc(time_index, ts_data) - b2 * covariance_calc(X_sq, time_index)) / variance_calc(time_index)
b0_adj = mean_calc(ts_data) - b1_adj * mean_calc(time_index) - b2 * mean_calc(X_sq)

# Compute Residual Sum of Squares (RSS)
rss_linear = sum((ts_data - (b0 + b1 * time_index))^2)
rss_quadratic = sum((ts_data - (b0_adj + b1_adj * time_index + b2 * X_sq))^2)

# Compute F-statistic
n = length(ts_data)
k1 = 2  # Linear model (2 parameters: b0, b1)
k2 = 3  # Quadratic model (3 parameters: b0, b1, b2)

F_stat = ((rss_linear - rss_quadratic) / (k2 - k1)) / (rss_quadratic / (n - k2))
F_critical = qf(0.95, df1=(k2-k1), df2=(n-k2))  # Critical F-value at 95% confidence

# Decision Rule
if (F_stat > F_critical) 
  {
  print("Reject H₀: Quadratic trend is statistically significant.")
} else 
  {
  print("Fail to Reject H₀: Linear trend is sufficient.")
}

# Predict values for both models
linear_pred = b0 + b1 * time_index
quadratic_pred = b0_adj + b1_adj * time_index + b2 * X_sq

# Plot Original Data
plot(time_index, ts_data, type="l", col="black", lwd=2, 
     main="CO₂ Trend Analysis with Curve Fitting", 
     ylab="CO₂ Levels", xlab="Time")

# Add Regression Trends
lines(time_index, linear_pred, col="blue", lwd=2, lty=2)  # Linear Trend
lines(time_index, quadratic_pred, col="red", lwd=2, lty=2)  # Quadratic Trend

# Add Legend
legend("topleft", legend=c("Original Data", "Linear Trend", "Quadratic Trend"), 
       col=c("black", "blue", "red"), lwd=2, lty=c(1, 2, 2))
