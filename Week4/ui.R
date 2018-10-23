library(shiny)
shinyUI(fluidPage(
 # titlePanel("Visualize Many Models"),
  navbarPage(
    title = 'A visual demonstration of some popular Machine Learning models',
    tabPanel(title = "Home",
      sidebarLayout(
        sidebarPanel(
          #h3("Purchased"),
          radioButtons("rbtnPrchsd", "Choose class of new data points that you whant to place on the plot",inline = T, choiceValues = c("No", "Yes"), 
                       choiceNames = list(HTML("<p style='color:#F8766D;'>No</p>"),HTML("<p style='color:#00BFC4;'>Yes</p>"))),
         # h3("Select model type to train"),
          selectInput("method", "Choose a model type to train:",
                      list("Random Forest" = "rf", 
                           "Generalized Linear Model" = "glm",
                           "Naive Bayes" = "nb",
                           "Generalized Additive Model"="gam",
                           "Neural Network"="nnet",
                           "Support Vector Machines with Linear Kernel"="svmLinear",
                           "Support Vector Machines with Radial Basis Function Kernel" = "svmRadial",
                           "k-Nearest Neighbors"="kknn",
                           "AdaBoost Classification Trees"="adaboost",
                           "Linear Discriminant Analysis"="lda")),
          numericInput('numCores', "Number of cores to run on. Not recommended to change.", min = 1, max = 12, value = 4),
          actionButton("btnTrain","Train the model"),
          textOutput("lblMessages")
          
        ),
    
        mainPanel(
          plotOutput("plot1", height = "800px", click = clickOpts(
            id = "click1"
          ))
        )) ),
      tabPanel(
        title = "Help",
        includeHTML("Readme.html")
     
  ))
))