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

The autocorrelation function is a mathematical tool for finding repeating patterns in time series data. The dotted blue lines generated in the stockVis plot after checking `Autocorrelation Function` represent the confidence interval. Anything above or below the confidence interval would indicate a significant cross-correlation in the data. The definition of the autocorrelation between times *s* and *t* is given below:

$$
  R(s, t) = \frac{E[(X_t-\mu_t)(X_s-\mu_s)]}{\sigma_t\sigma_s}
$$

Here, $\sigma_t$ is the standard deviation of the closing prices between time $t$ and time $s$, and $\sigma_s$ is the standard deviation of the closing prices at an earlier time frame, ending at time $s$. $\mu_s$ and $\mu_t$ are the average prices.

$E[(X_t-\mu_t){X_s-\mu_s)}]$ is the covariance between spot price $X_s$ at time $s$ and spot price $X_t$ at time $t$.

---

## Error Messages Produced by the Application

**End date is earlier than start date, or start date is blank.** --- This message occurs when the end date in the `Date Range` field is either earlier than the start date, or the start date is blank.

**End date took a leap forward in time!** --- This message occurs when the end date is later than the present date.

**The date range is less the 14 days. Try a bigger range of days.** --- We set the minimum date range to 14. If the date range inputted by the user is smaller than this, the user will get this error message.

**Either we failed to connect, or we have an unregistered ticker symbol.** --- This message occurs when the application is unable to connect to either Yahoo! Finance, or the Federal Reserve Bank of St. Louis to retrieve stock data, or when the ticker symbol provided in the `Symbol` field is not registered in the database. It could also be that no symbol was provided.

**Failed to connect to database. Try again later.** --- This message occurs when the application fails to connect to SPY to retrieve data for the validated date range. Retrieving data from SPY is necessary for measuring the performance of a stock in the stock market.


