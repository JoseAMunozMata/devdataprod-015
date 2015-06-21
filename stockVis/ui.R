library(shiny)

shinyUI(fluidPage(
  titlePanel("stockVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine. 
        Information will be collected from yahoo finance."),
    
      textInput("symb", "Symbol", "SPY"),
    
      dateRangeInput("dates", 
        "Date Range",
        start = "2013-01-01", 
        end = as.character(Sys.Date())),
   
      actionButton("get", "Get Stock"),
      
      br(),
      br(),
      
      checkboxInput("log", "Plot y axis on log scale", 
        value = FALSE),
      
      checkboxInput("adjust", 
        "Adjust prices for inflation", value = FALSE),
      
      radioButtons("misc", "Extra Information",
                   c("Daily Returns" = "rets",
                     "SPY Correlation" = "vsap",
                     "Autocorrelation Function" = "auto"))
    ),
    
    mainPanel(plotOutput("plot1"),
              plotOutput("plot2"))
  )
))