# server.R

library(quantmod)
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
      
      data <- try(getSymbols(input$symb, src = "yahoo", 
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
      adjust(dataInput    ())
  })
  
  dailyReturns <- reactive({
      ts <- stockPrice()
      getret(ts[, 6]   )
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
      
      getret(data[, 6] )
  })
      
  output$plot1 <- renderPlot({
          chartSeries(stockPrice(), theme = chartTheme("white"), 
                      type = "line", log.scale = input$log, TA = NULL)
  })
  
  output$plot2 <- renderPlot({
          if (input$misc == "auto") retrieve_acf()
          else if (!input$log && input$misc == "rets")
                  chartSeries(dailyReturns(), theme = chartTheme("white"),
                    type = "line", log.scale = input$log, TA = NULL)
          else if (input$misc == "vsap") {
                  graphics::plot(as.numeric(retrieve_sp500()), as.numeric(dailyReturns()), 
                         pch = 19,
                         col = "darkgreen", xlab = "SPY", ylab = input$symb)
                  fit <- lm(as.numeric(dailyReturns()) ~ as.numeric(retrieve_sp500()))
                  graphics::abline(fit)
                  graphics::legend("topleft", NULL, sprintf("Beta: %.2f", summary(fit)$coef[2]))
          }
  })

})