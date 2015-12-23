complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  id_string = sprintf("%03d", id)
  len <- length(id) #length of array
  # Initialize Dataframe
  df <- data.frame("id"=integer(0),
                   "nobs"=numeric(0))
  
  ## Return a data frame of the form:
  ## id nobs
  
  for(y in 1:len)
  {
    csv <- ".csv"
    file <- paste(directory,"/", id_string[y],csv, sep = "", collapse = "")
    df.file = read.csv(file)
    df.file = na.omit(df.file) # remove NA
    rowcount <- nrow(df.file)  # count the number of rows
    df <- rbind( df, data.frame("id"= id[y], "nobs"= rowcount)) # Add a new row to the DF
  }
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  df
}
