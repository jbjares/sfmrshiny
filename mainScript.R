source("mongo.R")

installRequiredPackages <- function(){

  

  
  if(!("rthreejs" %in% rownames(installed.packages()))){
    #install.packages("rthreejs")  
    devtools::install_github("bwlewis/rthreejs",force = TRUE)
  }
  if(!("shinyBS" %in% rownames(installed.packages()))){
    install.packages("shinyBS")  
  }
  if(!("jsonlite" %in% rownames(installed.packages()))){
    install.packages("jsonlite")  
  }
  if(!("curl" %in% rownames(installed.packages()))){
    install.packages("curl")  
  }
  if(!("scatterplot3d" %in% rownames(installed.packages()))){
    install.packages("scatterplot3d", repos="http://R-Forge.R-project.org")
  }
  

  
}



installRequiredPackages()





#mongo <- mongoHelper$connect()
attribs <- c("Select",names(mongoHelper$findAllAttributes(mongo,NULL)))
scatterplot3js <- NULL
