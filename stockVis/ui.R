library(shiny)

shinyUI(navbarPage(
  titlePanel("PepViz"),
  tabPanel("Basics",
  
  sidebarLayout(
    
    sidebarPanel(
        helpText("Select a stock to examine. 
                  Information will be collected from yahoo finance."),
    
        textInput("sym1", "Symbol", "AAPL"),
    
        dateRangeInput("dates","Date Range",
                       start = "2013-01-01",
                       end = as.character(Sys.Date())),
   
        actionButton("get", "Get Stock"),
      
        br(),br(),
      
        checkboxInput("log", "Plot y axis on log scale", 
                      value = FALSE),
      
        checkboxInput("adjust", 
                      "Adjust prices for inflation", value = FALSE)
    ),
    
    mainPanel(plotOutput("plot1"))
  )),
  
  tabPanel("Extra",
           sidebarPanel(
                        radioButtons("misc", "Advanced Plots",
                                     c("Daily Returns" = "rets",
                                     "SPY Correlation" = "vsap",
                                    "Autocorrelation Function" = "auto"))),
             
           mainPanel(plotOutput("plot2"),
                        plotOutput("plot3"))
  ),
  tabPanel("Advanced",
            sidebarPanel(
                        sliderInput("tbill", "T-bill Rate", 
                                    min = 0.01,
                                    max = 0.09,
                                    step = 0.01,
                                    value = 0.03,
                                    format = "#.##"),
                        textInput("sym2", "Symbol 1", "AAPL"),
                        textInput("sym3", "Symbol 2", "GOOGL")),
           
           mainPanel(plotOutput("plot4"))
  )))