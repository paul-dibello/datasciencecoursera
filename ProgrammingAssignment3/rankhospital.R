rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  ## Check that state and outcome are valid
  ## Return hospital name in that state with the given rank
  ## 30-day death rate


outcomeDF <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
states <- unique(outcomeDF[["State"]])
outcomes <- c("heart attack","heart failure", "pneumonia")
outComesColNum <- c(15,21,27)
outComesLookup <- data.frame("heart attack"= integer(0),
                             "heart failure"= integer(0),
                             "pneumonia"= integer(0))

outComesLookup <- rbind( outComesLookup, data.frame("heart attack" = 11,
                                                    "heart failure" = 17,
                                                    "pneumonia" = 23))
hospCol <- 2

  if(!state %in% states){
    stop("invalid state")
  }
  if(!outcome %in% outcomes){
    stop("invalid outcome")
  }
  outComeCol <- outComesLookup[[outcome]]
  if(outcome == "heart attack"){
    outComeCol = 11
  }
  if(outcome == "heart failure"){
    outComeCol = 17
  }
  
  statesubsetDF <- subset(outcomeDF, State == state)

  if(num == "best")
  {
    hospDF <- (statesubsetDF[which.min(statesubsetDF[[outComeCol]]),])
    output = hospDF[["Hospital.Name"]]
  }
  else if(num == "worst"){
    hospDF <- (statesubsetDF[which.max(statesubsetDF[[outComeCol]]),])
    output = hospDF[["Hospital.Name"]]
  }
  else {
    reorderedDF <- statesubsetDF[ order(as.integer(statesubsetDF[,outComeCol]), statesubsetDF[,hospCol], na.last = TRUE),]
    integerList <- as.integer(reorderedDF[[outComeCol]])
    ##integerList2 <- reorderedDF[["Hospital.Name"]]
    ##print(integerList2)
    ##print(integerList)
    outcomeLength <- length(na.omit(integerList))
    ##print(outcomeLength)
    number <- as.integer(num)
    if (number > outcomeLength){
      output = "NA"
    } else {
      hospDF <- reorderedDF[number,]
      output = hospDF[["Hospital.Name"]]
    }
    
  }
output
}
