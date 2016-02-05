library(threejs)


surface3DPlot <- function(){
  xyz <- read.csv(file="pakDatMesh_ztranslation.csv",header=FALSE,sep=";");
  x <- xyz$V1
  y <- xyz$V2
  z <- xyz$V3
  scatterplot3js(x,y,z, color=rainbow(length(z)))  
}


