# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("Stock Info"),
  
  sidebarLayout(
    sidebarPanel(
      h4(strong("Stock price plot")),
      helpText("Select a stock to examine. 
               Information will be collected from yahoo finance."),
      textInput("symb", "Symbol", "AAPL"),
      dateRangeInput("dates", 
                     "Date range",
                     start = "2010-01-01", 
                     end = as.character(Sys.Date())),
      
      checkboxInput("log", "Plot y axis on log scale", 
                    value = FALSE),
      checkboxInput("adjust", 
                    "Adjust prices for inflation", value = FALSE),
      downloadButton("downloadPrice", "Download Stock Price"),
      br(),
      br(),
      
      h4(strong("Financial Statment")),
      helpText("Which financial statments to display:"),
      helpText("IS = Income Statment"), 
      helpText("BS = Balance Sheet"), 
      helpText("CF = Cash Flow Statment"),
      selectInput("fs", label="",
                  choices = c("BS", "IS", "CF"), selected="BS"),
      h5(strong("Period")),
      helpText(h5("Select the periodicity of the financial statments")),
      helpText("Q = Quarterly"),
      helpText("A = Yearly"),
      selectInput("period", label = "",
                  choices = c("A", "Q"), selected = ),
      br(),
      downloadButton("downloadFS", "Download Financial Statments")
      ),

mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Price Plot", plotOutput("plot")),
                  tabPanel("Financial Statments", tableOutput("finst"))
          )
        )
      )
  ))
  