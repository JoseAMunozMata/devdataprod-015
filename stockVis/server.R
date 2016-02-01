# server.R

library(quantmod)
library(PerformanceAnalytics)
library(zoo)
source("helpers.R")

shinyServer(function(input, output) {
  
  dataInput <- reactive({
          validate (
                  need(input$dates[2] >  input$dates[1], 
                        "End date is earlier than start date, or start date is blank.")
          )
          
                  validate (
            need(as.Date(input$dates[2]) <= Sys.Date(), 
                        "End date took a leap forward in time!")
          )
          
          validate (
                  need(difftime(input$dates[2], input$dates[1], "days") > 14, 
                        "The date range is less the 14 days. Try a bigger range of days.")
          )
          
          data <- try(getSymbols(input$sym1, src = "yahoo", 
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE)     )
          
          validate(
                  need(!is.null(data) && class(data) != "try-error",
                        "Either we failed to connect, or we have an unregistered ticker symbol.")
          ); data
  })
  
  dataInput1 <- reactive({
          validate (
            need(input$dates[2] >  input$dates[1], 
                 "End date is earlier than start date, or start date is blank.")
          )
          
          validate (
            need(as.Date(input$dates[2]) <= Sys.Date(), 
                 "End date took a leap forward in time!")
          )
          
          validate (
            need(difftime(input$dates[2], input$dates[1], "days") > 14, 
                 "The date range is less the 14 days. Try a bigger range of days.")
          )
          
          data <- try(getSymbols(input$sym2, input$sym3, src = "yahoo", 
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE)     )
          
          validate(
            need(!is.null(data) && class(data) != "try-error",
                 "Either we failed to connect, or we have an unregistered ticker symbol.")
          ); data
  })
  
  dataInput2 <- reactive({
          validate (
            need(input$dates[2] >  input$dates[1], 
                 "End date is earlier than start date, or start date is blank.")
          )
          
          validate (
            need(as.Date(input$dates[2]) <= Sys.Date(), 
                 "End date took a leap forward in time!")
          )
          
          validate (
            need(difftime(input$dates[2], input$dates[1], "days") > 14, 
                 "The date range is less the 14 days. Try a bigger range of days.")
          )
          
          data <- try(getSymbols(input$sym3, src = "yahoo", 
                                 from = input$dates[1],
                                 to = input$dates[2],
                                 auto.assign = FALSE)     )
          
          validate(
            need(!is.null(data) && class(data) != "try-error",
                 "Either we failed to connect, or we have an unregistered ticker symbol.")
          ); data
  })
  
  stockPrice <- reactive({
          if (!input$adjust) 
                    return(dataInput())
          adjust(dataInput(    ))
  })
  
  stockPrice1 <- reactive({
          if (!input$adjust) 
                    return(dataInput1())
          adjust(dataInput1(    ))
  })
  
  stockPrice2 <- reactive({
          if (!input$adjust) 
                    return(dataInput2())
          adjust(dataInput2(    ))
  })
  
  dailyReturns <- reactive({
          ts <- stockPrice()
          dailyReturn(ts[, 6]   )
  })
  
  monthlyReturns1 <- reactive({
          ts <- stockPrice1()
          monthlyReturn(ts[, 6] , type = "log")
  })
  
  monthlyReturns2 <- reactive({
          ts <- stockPrice2()
          monthlyReturn(ts[, 6] , type = "log")
  })
  
  retrieve_acf <- function() {
          acf(stockPrice()[, 6], main = "Autocorrelation of Adjusted Closing Price")
  }
  
  retrieve_sp500 <- reactive({
      data <- try(getSymbols("spy", src = "yahoo", 
                              from = input$dates[1],
                              to = input$dates[2],
                              auto.assign = FALSE))
      
      validate(
            need(data != "try-error", 
                  "Failed to connect to database. Try again later.")
      )
      
      dailyReturn(data[, 6] )
  })
      
  output$plot1 <- renderPlot({
        chartSeries(stockPrice(), theme = chartTheme("white"), 
                    type = "line", log.scale = input$log, TA = NULL)
  })
  
  output$plot2 <- renderPlot({
          return_matrix <- coredata(dailyReturns())
    
          par(mfrow=c(2,2))
          hist(return_matrix,main="Monthly Returns",
                              xlab=input$sym1, probability=T, col="slateblue1")
    
          boxplot(return_matrix,outchar=T, main="Boxplot", col="slateblue1")
    
          plot(density(return_matrix, na.rm = T),type="l", main="Smoothed Density",
                     xlab="monthly return", ylab="density estimate", col="slateblue1")
    
          qqnorm(return_matrix, col="slateblue1")
          qqline(return_matrix)
  })
  
  output$plot3 <- renderPlot({
          if (input$misc == "auto") retrieve_acf()
          else if (!input$log && input$misc == "rets")
                chartSeries(dailyReturns(), theme = chartTheme("white"),
                        type = "line", log.scale = input$log, TA = NULL)
          else if (input$misc == "vsap") {
                graphics::plot(as.numeric(retrieve_sp500()), as.numeric(dailyReturns()), 
                               pch = 19,
                               col = "darkgreen", xlab = "SPY", ylab = input$sym1)
                fit <- lm(as.numeric(dailyReturns()) ~ as.numeric(retrieve_sp500()))
                graphics::abline(fit)
                graphics::legend("topleft", NULL, sprintf("Beta: %.2f", summary(fit)$coef[2]))
          }
  })
  
  output$plot4 <- renderPlot({
          t_bill_rate <- input$tbill
          
          monthly1 <- monthlyReturns1()
          monthly2 <- monthlyReturns2()
          
          monthly_all <- data.frame(matrix(monthly1), matrix(monthly2))
          colnames(monthly_all) <- c(input$sym2, input$sym3)
          
          mu_hat_annual <- apply(monthly_all,2,mean)*nrow(monthly_all)
          sigma2_annual <- apply(monthly_all,2,var )*nrow(monthly_all)
          
          sigma_annual <- sqrt(sigma2_annual)
          
          cov_mat_annual <- cov(monthly_all)*nrow(monthly_all)
          cov_hat_annual <- cov(monthly_all)[1,2]*nrow(monthly_all)
          
          # construct portfolio with two assets
          
          stock1weights <- seq(from=-1, to=2, by=0.1)
          stock2weights <- 1 - stock1weights
          
          mu_portfolio <-  stock1weights*mu_hat_annual[1] + stock2weights*mu_hat_annual[2]
          
          sigma2_portfolio <- stock1weights^2*sigma2_annual[1] + 
                              stock2weights^2*sigma2_annual[2] +
                              stock1weights*stock2weights*cov_hat_annual
          sigma_portfolio <- sqrt(sigma2_portfolio)
          
          # compute tangency portfolio
          tangency_portfolio <-  tangency.portfolio(mu_hat_annual, cov_mat_annual, t_bill_rate)
          
          # plot portfolio risk vs returns
          plot(sigma_portfolio,
               mu_portfolio, 
               type="b", 
               pch=16, 
               ylim=c(0, max(mu_portfolio)), 
               xlim=c(0, max(sigma_portfolio)), 
               xlab=expression(sigma[p]), 
               ylab=expression(mu[p]),
               col=c(rep("green", 18), rep("red", 13)))
          
          text(x=sigma_annual[1], y=mu_hat_annual[1], labels=input$sym2, pos=4)
          text(x=sigma_annual[2], y=mu_hat_annual[2], labels=input$sym3, pos=4)
          
          # tangency weights
          tangency_weights <- seq(from=0, to=2, by=0.1)
          
          # tangency parameters
          mu_portfolio_tangency_bill <- t_bill_rate + tangency_weights*(tangency_portfolio$er - t_bill_rate)
          sigma_portfolio_tangency_bill <- tangency_weights*tangency_portfolio$sd
          
          # Plot portfolio combinations of tangency portfolio and T-bills
          text(x=tangency_portfolio$sd, y=tangency_portfolio$er, labels="Tangency", pos=2)
          points(sigma_portfolio_tangency_bill, mu_portfolio_tangency_bill, col = "blue", type = "b", pch=16)
  })

})