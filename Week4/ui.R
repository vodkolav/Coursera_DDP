library(shiny)
shinyUI(fluidPage(
  titlePanel("Visualize Many Models"),
  sidebarLayout(
    sidebarPanel(
      h3("Purchased"),
      radioButtons("rbtnPrchsd", "Purchased", c("Yes" = 1, "No" = 0)),
      h3("Select model type to train"),
      selectInput("method", "Choose a model to train:",
                  list("Random Forest" = "rf", 
                       "Generalized Linear Model" = "glm",
                       "Naive Bayes" = "nb",
                       "Generalized Additive Model"="gam",
                       "Neural Network"="nnet")),
      numericInput('numNCores', "Number of cores to run on", min = 1, max = 12, value = 5),
      actionButton("btnTrain","Train the model"),
      textOutput("lblMessages")
      
    ),
    mainPanel(
      plotOutput("plot1", height = "800px", click = clickOpts(
        id = "click1"
      ))
    )
  )
))