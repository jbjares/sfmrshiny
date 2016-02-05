
parametersSchemaVar <- "sifem.TransformationTO"
dataSetCacheSchemaVar <- "sifem.DataSetHashCacheTO"
projectNameVar <- "PROJECTTEST"
simulationNameVar <- "SIMULATIONUNITTEST"
hostDesenv <- "127.0.0.1"
usernameDesenv <-""
passwordDesenv <- ""
dbDesenv = "sifem"

xValues <- NULL
yValues <- NULL
zValues <- NULL

exe <- function(){
  mongo <- mongo.create(host = hostDesenv, username = usernameDesenv, password = passwordDesenv, db = dbDesenv, timeout = 0L)
  
  buf <- mongo.bson.buffer.create()
  mongo.bson.buffer.append(buf, "projectName",projectNameVar)
  mongo.bson.buffer.append(buf, "xName","DISTANCEFROMTHECOCHLEAAPEX")
  mongo.bson.buffer.append(buf, "yName","FREQUENCYATSTAPLES")

  query <- mongo.bson.from.buffer(buf)
  tmp <- mongo.find.one(mongo,dataSetCacheSchemaVar,query)
  tmpList <- mongo.bson.to.list(tmp)["viewTO"]
  print(class(tmpList))
  print(names(tmpList))
  viewTOList <- tmpList$viewTO
  print(class(viewTOList))
  print(names(viewTOList))
  
  print(length(viewTOList$xView))
  print(length(viewTOList$yView))
  print(length(viewTOList$zView))
  print(length(viewTOList$dimValMap))

  #print(viewTOList$dimValMap)
  map <- viewTOList$dimValMap
  newAttributes <- as.list(names(map))
  
  xValues <<- map["xCoord"]
  yValues <<- map["yCoord"]
  zValues <<- map["zCoord"]

}

exe()