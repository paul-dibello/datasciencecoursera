pollutantmean <- function(directory, pollutant, id = 1:332) {
  id = sprintf("%03d", id)
  len <- length(id) #length of array
  # Initialize Dataframe
  df <- data.frame(Date=as.Date(character()),
                   sulfate=numeric(), 
                   nitrate=numeric(),
                   id=integer(),
                   stringsAsFactors=FALSE)
  

  for(y in 1:len) # Loop through id array
  {
    csv <- ".csv"
    file <- paste(directory,"/", id[y],csv, sep = "", collapse = "")
    df.new = read.csv(file)
    df = rbind(df, df.new)   # add to the DF
  }
  #calculate mean (remove NA values)
  mean(na.omit(df[[pollutant]]))

}