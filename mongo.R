if(!require("devtools")){
  install.packages("devtools",repos="http://cran.rstudio.com/")
} 
library(devtools)
if(!("rmongodb" %in% rownames(installed.packages()))){
  
  #install_github(repo = "mongosoup/rmongodb")
  install.packages("rmongodb")  
}

#desenv
hostDesenv <- "127.0.0.1:27017"
usernameDesenv <-""
passwordDesenv <- ""

#prod
#hostDesenv <- "192.168.3.13:27017"
#usernameDesenv <-"deri"
#passwordDesenv <- "n1kon,c@mera"

#test
# parametersSchemaVar <- "multivision_jbjares.TransformationTO"
# dataSetCacheSchemaVar <- "multivision_jbjares.DataSetHashCacheTO"
# projectNameVar <- "PROJECTTEST"
# hostDesenv <- "ds061371.mongolab.com:61371"
# usernameDesenv <-"jbjares"
# passwordDesenv <- "multivision"
# dbDesenv = "multivision_jbjares"

parametersSchemaVar <- "sifem.TransformationTO"
dataSetCacheSchemaVar <- "sifem.DataSetHashCacheTO"
#projectNameVar <- "PROJECTTEST"
#simulationNameVar <- "SIMULATIONUNITTEST"
dbDesenv = "sifem"
xValues <- list()
yValues <- list()
zValues <- list()





mongoHelper <- list(

  library(rmongodb), 
    connect = function(){
     mongo <- mongo.create(host = hostDesenv, username = usernameDesenv, password = passwordDesenv, db = dbDesenv, timeout = 0L)
     return(mongo)
    },
                                                                                                      
    findOneCache = function(xName,yName,zName=NULL,id=id,conn=mongo,dataSetCache=dataSetCacheSchemaVar){

      #browser()
      
      if(xName=="Select"){
        print("You must select at least Y and Z to show 2D view.")
        return(NULL)
      }
      if(yName=="Select"){
        print("You must select at least Y and Z to show 2D view.")
        return(NULL)
      }
      

      buf <- mongo.bson.buffer.create()
      if(!is.null(id) && id!=""){
        id <- id;
        mongo.bson.buffer.append(buf, "id",id)
      }
#       if(!is.null(simulationName) && simulationName!=""){
#         simulationName <- simulationNameVar;
#         mongo.bson.buffer.append(buf, "simulationName",simulationName)
#       }
      
      mongo.bson.buffer.append(buf, "xName", xName)
      mongo.bson.buffer.append(buf, "yName", yName)
      if(!is.null(zName) && zName!="" && zName!="Select"){
        mongo.bson.buffer.append(buf, "zName", zName)
      }
      if(is.null(zName) || zName=="Select"){
        print("Try select Z option to show 3D view.")
      }
      
      
      
      query <- mongo.bson.from.buffer(buf)
      yAndYQueryReturn <- mongo.find.one(conn,dataSetCache,query)
      
      print(paste0("before map"))
      
#       print(paste0("class(yAndYQueryReturn)==mongo.bson: ",class(yAndYQueryReturn)=="mongo.bson"))
#       print(paste0("class(yAndYQueryReturn): ",class(yAndYQueryReturn)))
#       print(paste0("xName: ",xName))
#       print(paste0("yName: ",yName))
#       print(paste0("zName: ",zName))
#       print(paste0("projectName: ",projectName))
#       print(paste0("simulationName: ",simulationName))
#       print(paste0("dataSetCache: ",dataSetCache))
    

      
      if(class(yAndYQueryReturn)!="mongo.bson"){
        print(paste0("into map"))
        #if query based on x and y names doesn't retreives anything, try the query based on project and simulation name
        #browser()
        buf <- NULL
        query <- NULL
        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "id",id)
        mongo.bson.buffer.append(buf, "xName",NULL)
        mongo.bson.buffer.append(buf, "yName",NULL)
        
        query <- mongo.bson.from.buffer(buf)
        tmp <- mongo.find.one(conn,dataSetCache,query)
        tmpList <- mongo.bson.to.list(tmp)["viewTO"]
        viewTOList <- tmpList$viewTO
        
        if(length(viewTOList$xView)>0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0001]")
          return(NULL)
        }
        if(length(viewTOList$yView)>0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0002]")
          return(NULL)
        }
        if(length(viewTOList$zView>0)){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0003]")
          return(NULL)
        }
        if(length(viewTOList$dimValMap)<=0){
          print("Data set is not properly well defined. Try contact the system admin, and ask about code [ERR0004]")
          return(NULL)
        }
        
        map <- viewTOList$dimValMap
        newAttributes <- as.list(names(map))
        
        xValues <- map[xName]
        yValues <- map[yName]
        zValues <- map[zName]
        
        
        
        if(class(tmp)!="mongo.bson"){
          print("Result not defined for query.")
          return(NULL)
        }
        
        
        
      }
      
      return(
        
        list(
            getX = function(){
              if(length(xValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListX = doubleList$viewTO$xView
                doubleListXNumeric = as.numeric(unlist(doubleListX))
                return(doubleListXNumeric)
              }
              if(length(xValues)>0){
                xValuesResult <- as.numeric(unlist(xValues))
                return(xValuesResult)
              }

            },
            getY = function(){
              if(length(yValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListY = doubleList$viewTO$yView
                doubleListYNumeric = as.numeric(unlist(doubleListY))
                return(doubleListYNumeric)
              }
              if(length(yValues)>0){
                yValuesResult <- as.numeric(unlist(yValues))
                return(yValuesResult)
              }

            },
            getZ = function(){
              if(length(zValues)==0 && class(yAndYQueryReturn)=="mongo.bson"){
                doubleList <- mongo.bson.to.list(yAndYQueryReturn)
                doubleListZ = doubleList$viewTO$zView
                doubleListZNumeric = as.numeric(unlist(doubleListZ))
                return(doubleListZNumeric)
              }
              if(length(zValues)>0){
                zValuesResult <- as.numeric(unlist(zValues))
                return(zValuesResult)
              }

            }
          
          )
        
      )
      
    },
  
  
  findAllAttributes = function(parametersSchema=parametersSchemaVar,ids=ids,conn=mongo){
    buf <- mongo.bson.buffer.create()
    if(!is.null(ids)){
      mongo.bson.buffer.append(buf, id,ids )
    }
    query <- mongo.bson.from.buffer(buf)  
    bson <- mongo.find.one(conn,parametersSchemaVar,query)
    #makeList
    vec <- mongo.bson.to.list(bson)$parameters
    len <- length(vec[-1])
    out <- suppressWarnings(as.list(rep(as.numeric(vec[1]), len)))
    names(out) <- as.character(vec[-1])
    return(out)
  }
#,
#   isFindOneCacheInputValid = function(xName=NULL,yName=NULL,zName=NULL,projectName,conn,dataSetCache){
#     if(!mongo.is.connected(conn)){
#       print("Mongo connection is not available.")
#       return(F)
#     }
#   
#     if(is.null(dataSetCache) || dataSetCache==""){
#       print("Please, input the name of the db and table.")
#       return(F)
#     }
#     
#     if(is.null(xName) || xName==""){
#       print("Please, input the xName.")
#       return(F)
#     }
#     if(is.null(yName) || yName==""){
#       print("Please, input the yName")
#       return(F)
#     }
# 
#     if(is.null(projectName) || projectName==""){
#       print("Please, input the projectName")
#       return(F)
#     }
# 
#     return(TRUE)
#   }
    

)

mongo <- mongoHelper$connect()