---
output: 
  html_document: 
    keep_md: yes
---
#A visual demonstration of some popular Machine Learning models

This app allows you to visualise what prediction boundaries for some of machine learning models look like.

It trains a selected model on provided data and then the model predicts a value for each point of (x,y) plane in a defined domain with defined resolution. So basically the whole plane is the test set.  
  
The datasets are limited to 2 independent variables due to 2D nature of the plots. However the dependent variable might be extended to 3 or more classes in the future (Not really, I will not return to this project after the course:). 
  
All models are powered by caret  

##The typical workflow is as follows:  
- Add points to the graph by clicking on it.  
- Remove points you don't like by clicking on them.
- Select model type  
- Leave number of cores as it is. With more cores the app will probably crash due to memory limitation of the free tier shinyapps hosting. If it still crashes, try to reduce number of cores  
- Press "Train the model" button and wait up to a dosen seconds.  
- Observe.  
- Repeat with other models and points.  
- Contemlate the difference between linear and various nonlinear classifiers.  


##What may be improved or added
- currently every time you train a model, it replaces the previous one, so if you want to turn back to a see a previous one, you have to train it again.  
- add more models
- upload user datasets options
- allow datasets with more than 2 classes
- adding points in "drawing" style instead of clicking them one by one


