---
title         : "Working with stockVis"
subtitle      : "Stock Visualization Made Easy"
author        : "Salma Rodriguez, Student"
job           : "Johns Hopkins Bloomberg School of Public Health"
date          : "Friday, June 19, 2015"
framework     : io2012
highlighter   : highlights.js
hitheme       : tomorrow
widgets       : [mathjax, quiz]
mode          : selfcontained
output        : html_document

---

## About stockVis

Wouldn't it be cool to have a financial app to monitor the performance of a stock in your portfolio? Well, now you can! We introduce the one-of-a-kind stockVis!

The stockVis application allows the user to look up stock prices pulled from Yahoo! Finance, and stock prices adjusted for inflation from the Federal Reserve Bank of St. Louis. The original application can be found in the Shiny tutorial at: http://shiny.rstudio.com/tutorial/lesson6/.

We have made some modifications to include a dotplot comparison of an equity to a widely known stock market index: SPY, as well as a plot to determine the autocorrelation for a given stock. This modification is under `Extra Information`.

---

## How to Use stockVis

### Retrieving Stock Information

The `Symbol` field is where the ticker symbol is specified. Input a valid ticker symbol from the New York Stock Exchange (NYSE), NASDAQ, or other quotation databases to view the price for that stock. After clicking on the `Date Range` field, you can specify dates for adjusted closing prices by selecting values from the pop up calendar. The `Get Stock` button retrieves information from the database, drawing a plot of the adjusted closing prices on the right hand panel. You can specify to plot the y axis of the timeseries plot on the log scale, or adjust prices for inflation, by selecting the corresponding checkboxes.

### Calculating Extra Information

You can plot the daily return, compare the stock specified in the `Symbol` field against the market index, or determine the autocorrelation. All this can be done by selecting the corresponding checkbox. More information about this extra information is provided in the following slides.

---

## Interpreting Results from the Extra Information

### Daily Return

We used the following transformation on the daily price to compute the daily return:

$$
    R = 100\times{\left(\frac{P_t-P_{t-1}}{P_{t-1}}\right)} \approx 100\times{\log\left(\frac{P_t}{P_{t-1}}\right)}
$$

Here, $R$ is the daily return, which we computed as 100 times the closing price difference between today and yesterday, $P_t-P_{t-1}$, adjusted for cash dividends and splits, over the adjusted closing price yesterday, $P_{t-1}$. This is approximately 100 times the natural logarithm of the closing price quotient between today and yesterday when the return is small.

### SPY Correlation

You can select `SPY Correlation` to make a scatter plot of the equity against the Standard & Poor's 500 exchange traded fund, using their respective daily returns. A regression line is added to the scatter plot in order to capture the correlation of daily returns. $\beta$ is the correlation coefficient.

---

## Interpreting Results from the Extra Information

### Autocorrelation Function

The autocorrelation function is a mathematical tool for finding repeating patterns in time series data. The dotted blue lines generated in the stockVis plot after checking `Autocorrelation Function` represent the confidence interval. Anything above or below the confidence interval would indicate a significant cross-correlation in the data. The definition of the autocorrelation between time periods *s* and *t* is given below:

$$
  R(s, t) = \frac{E[(X_t-\mu_t)(X_s-\mu_s)]}{\sigma_t\sigma_s}
$$

Here, $\sigma_t$ is the standard deviation of the closing prices at time period $t$, and $\sigma_s$ is the standard deviation of the closing prices at time period $s$. $\mu_s$ and $\mu_t$ are the average prices.

$E[(X_t-\mu_t)(X_s-\mu_s)]$ is the covariance between random variable $X_s$ at time $s$ and random variable $X_t$ at time $t$.


