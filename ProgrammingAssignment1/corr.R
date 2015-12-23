corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
 files <- list.files(path = directory, pattern = NULL, all.files = FALSE,
             full.names = FALSE, recursive = FALSE,
             ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)
 #initialize vector
 correlations <-c()
 
 
 len <- length(files) #length of files array

 #Loop through files
 for(y in 1:len)
 {
   file <- paste(directory, "/",files[y], sep="") 
   df.file = read.csv(file)
   df.obs = na.omit(df.file) # remove NA
   rowcount <- nrow(df.obs)  # count the number of rows
   if(rowcount > threshold){
     #add to vector
     corvalue <- cor(df.file[["nitrate"]], df.file[["sulfate"]], use = "complete.obs")
     correlations <- append(correlations, corvalue, after = length(correlations))
   }
 }
 
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  ## NOTE: Do not round the result!
 correlations
}