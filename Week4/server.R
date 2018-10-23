library(dplyr)
library(shiny)
library(ggplot2)
library(caTools)
library(caret)
library(randomForest)
library(fastAdaboost)
library(kknn)
library(e1071)
library(lattice)
library(iterators,quietly=TRUE)
library(parallel,quietly=TRUE)
library(foreach,quietly=TRUE)
library(doParallel,quietly=TRUE)
library(profvis)

dataset = read.csv('Social.csv')

dataset[-3] = scale(dataset[-3])
dataset$Purchased = factor(dataset$Purchased, levels = c(0,1), labels = c("No" ,"Yes"))

debug = F

if (debug){
  dataset = read.csv('Week4/Social.csv')
  dataset[-3] = scale(dataset[-3])
  dataset$Purchased = factor(dataset$Purchased, levels = c(0,1), labels = c("No" ,"Yes"))
  vals <- NULL
  vals$Ads = dataset
  vals$Grid = 1
  vals$method <- 'rf'
  input = NULL
  input$method <- 'glm'
}

shinyServer(function(input, output) {
  
  vals <- reactiveValues(
    
    Ads = dataset,
    Grid = NULL,
    Raster = NULL,
    LastModel = ""
    #keeprows = rep(TRUE, nrow(mtcars)) trees
  )

  observeEvent(input$click1, {
    res <- nearPoints(vals$Ads, input$click1, xvar = "Age",  yvar = "EstimatedSalary", threshold = 3, allRows = T, addDist = T)
    
    if (sum(res$selected_)==0){ #adding point
      pts <- input$click1
      vals$Ads <- rbind(vals$Ads, list(Age = pts$x, Purchased = input$rbtnPrchsd, EstimatedSalary = pts$y))
    }
    else{                       #removing existing point
      vals$Ads <- vals$Ads[!res$selected_,]
    }

  })
  
  
  observeEvent(input$btnTrain, {
    output$lblMessages <- renderText({"Training the model. Please wait..."})
    profile <- profvis({    
      #availCores <- detectCores()
      availCores <- input$numCores
      cluster <- makeCluster(availCores)
      registerDoParallel(cluster)
      
      tC = trainControl(method="cv", number=availCores-1, allowParallel=T)
      #tC = trainControl(method="none",allowParallel=F)
      model <-train( Purchased ~ . , data = vals$Ads ,method=input$method, trControl = tC)
      #print(model$times$everything)
      set = vals$Ads
      X1 = seq(min(set[, 1]) , max(set[, 1]) , by = 0.05)
      X2 = seq(min(set[, 2]) , max(set[, 2]) , by = 0.05)
      grid_set = expand.grid(X1, X2)
      colnames(grid_set) = c('Age', 'EstimatedSalary')
      grid_set$Purchased = predict(model, grid_set)
      #vals$Grid <-grid_set
      vals$LastModel <- input$method
    
      
      if(!is.null(grid_set)){
        vals$raster <- geom_raster(data = grid_set, aes(Age, EstimatedSalary, fill = Purchased))
      }
    stopCluster(cluster)      
    })
    save(profile, file = 'profiling/profile.rdata')
    #output$intOut <- renderText({mtd})
    

    output$lblMessages <- renderText({paste(vals$LastModel, "training finished with", availCores ,"cores in ",
                                            sprintf("%.2f",model$times$everything['elapsed']), "seconds")})
    
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
    #
    g <- ggplot() + ggtitle(vals$method) + theme(legend.position="left")
    if(!is.null(vals$raster)){
      g <- g  + vals$raster
    }
    g<-g+ geom_point(data = vals$Ads, aes(x = Age, y = EstimatedSalary, fill = Purchased) ,col = 'black', shape =  21, size = 2 )
    
    g
})  
  
})  
  
   # ggplot(data = dataset)  +   geom_point(aes(x = Age, y = EstimatedSalary, color = Purchased ))
    
    
    #xlab = "Girth",  ylab = "Volume", main = "Tree Measurements", cex = 1.5, pch = 16, bty = "n"  
         
       
    # if(
       #  !is.null(model())){
    #   points(model()$x, model()$y, col = "blue", lwd = 2)
    #}
    
    
    
    

  
