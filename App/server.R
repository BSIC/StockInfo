# server.R

library(downloader)
library(quantmod)
source("helpers.R")

shinyServer(function(input, output) {
  ## Reactive Data ##
  dataInputprint<- reactive({
    Z<-print(dataInput())  
    Z<-as.data.frame(Z)
    Z$Date<-as.Date(rownames(Z))
    rownames(Z)<-NULL
    return(Z)
                            })  
  
    dataInput<- reactive({
      getSymbols(input$symb, src = "yahoo", 
                       from = input$dates[1],
                       to = input$dates[2],
                       auto.assign = FALSE)
                         })
      
    dataFinSt <- reactive ({
    na.omit(data.frame(viewFin(getFin(input$symb, auto.assign=FALSE), 
                                 input$fs, input$period)))
                          })
    
  ## Log checkbox fix ##
  finalInput <- reactive({
      if (!input$adjust) return(dataInput())
      adjust(dataInput())
  })
  ## Output ##
  output$plot <- renderPlot({
  chartSeries(finalInput(), theme = chartTheme("white"), 
      type = "line", log.scale = input$log, TA = NULL)
  })

  output$finst <- renderTable({
      dataFinSt()
  })
  ## Download Buttons ##
  output$downloadFS <- downloadHandler(
      filename = function() { paste(input$symb, input$fs, "csv", sep=".") },
      content = function(file) {
        write.csv(dataFinSt(), file)
  })
  output$downloadPrice <- downloadHandler(
    filename = function() {paste(input$symb, "price", "csv", sep=".") },
    content = function(file) {
      write.csv(dataInputprint(), file)
    })
})