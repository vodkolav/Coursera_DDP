library(shiny)
library(ggplot2)
shinyServer(function(input, output) {
  
  vals <- reactiveValues(
    
    trees = eval(trees)
    #keeprows = rep(TRUE, nrow(mtcars))
  )
  
  observeEvent(input$click1, {
    res <- nearPoints(vals$trees, input$click1, xvar = "Girth",  yvar = "Volume", threshold = 5, allRows = T, addDist = T)
    
    if (sum(res$selected_)==0){
      pts <- input$click1
      vals$trees <- rbind(vals$trees, list(Girth = pts$x, Height = 10, Volume = pts$y))
    }
    else{
      vals$trees <- vals$trees[!res$selected_,]
    }

  })
  
  # model <- reactive({
  #   clickData <-  input$click1
  #   #brushed_data <-  brushedPoints(trees, input$brush1, xvar = "Girth", yvar = "Volume")
  #   if(is.null(clickData) ){
  #     return(NULL)
  #   }
  #   
  #   # trees<- rbind(trees, list(Girth = clickData$x, Height = clickData$y, Volume = 10))
  #   # 
  #   # lm(Volume ~ Girth, data = trees)
  #   return(clickData)
  # })
  
  # output$slopeOut <- renderText({
  #   if(is.null(model())){
  #     "No Model Found"
  #   } else {
  #     vals$trees$x
  #     # model()[[1]][2]
  #   }
  # })
  
  # output$intOut <- renderText({
  #   if(is.null(model())){
  #     "No Model Found"
  #   } else {
  #     vals$trees$y
  #     #model()[[1]][1]
  #   }
  # })
  
  output$plot1 <- renderPlot({
    #pts <- model()
    #trees<- rbind(trees, list(Girth = pts$x, Height = pts$y, Volume = 10))
    ggplot(data = vals$trees)  +   geom_point(aes(x = Girth, y = Volume ))
  
    
    
    #xlab = "Girth",  ylab = "Volume", main = "Tree Measurements", cex = 1.5, pch = 16, bty = "n"  
         
       
    # if(
       #  !is.null(model())){
    #   points(model()$x, model()$y, col = "blue", lwd = 2)
    #}
  })
  
  
})