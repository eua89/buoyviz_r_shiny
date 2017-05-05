library(quantmod)
library(ggplot2)
library(scales)
#source("helper.r")

shinyServer(function(input, output) {
  
  buoy_data=reactive({
    fn = "http://localhost:5000/WAQM3.csv"
    fn = paste("http://localhost:5000/",input$select1,".csv", sep="")
    f = read.csv(fn,header=T, sep=",")
    f$Date <- format(as.POSIXct(paste(f$X.YY, f$MM, f$DD, f$hh ,f$mm, sep = "/"), format= "%Y/%m/%d/%H/%M"))
    #f$POSDATE <- as.POSIXct(f$Date)
    colnames(f)[10] <- "O2"
    f
# Instead of running the above function here we could load it from a helper.r file    
#    read_csv(input$select1)
  }) 
  
  
  output$table <- renderTable({
    data <- buoy_data()
    data[6:16]
    })

  output$plot <- renderPlot({
    data <- buoy_data()
    POSDATE <- as.POSIXct(data$Date)
    
    ggplot(data, aes_string(x = "POSDATE", y = input$select2)) +
      geom_line() +
      scale_x_datetime(labels = date_format("%Y-%m-%d %mm"))
    })
  
  output$text <- renderText({paste(input$select2, "of buoy with ID=", input$select1 )})
  
}) 
