###########################
# File: get_ncvs.R
#
# Description:
#   
# Date: 03/09/2015
# Author: Jake Russ
# Notes:
# To do: Add support for the xml file format.
###########################

# In order to get this working quickly I have copied this internal downloader 
# method from raster::getData. I'll need to refactor or attribute it somehow 
# for a wider release. 

.download <- function(aurl, filename) {
  fn <- paste(tempfile(), '.download', sep = '')
  res <- download.file(url = aurl, destfile = fn, method = "auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
  if (res == 0) {
    w <- getOption('warn')
    on.exit(options('warn' = w))
    options('warn' = -1) 
    if (! file.rename(fn, filename) ) { 
      # rename failed, perhaps because fn and filename refer to different devices
      file.copy(fn, filename)
      file.remove(fn)
    }
  } else {
    stop('could not download the file' )
  }
}

get_ncvs <- function(survey, year, pop = NULL, filename, path, format = "csv", ...){
  
  # Check for an accepted data file format type
  if(!(tolower(format) %in% c("csv", "json"))) {
    stop(format, " is not an accepted file format type. Accepted options are 'csv' or 'json'.")
  }
  
  # Check for an accepted survey type
  if(!(tolower(survey) %in% c("personal", "household"))) {
    stop(survey, " is not an accepted survey type. Accepted options are 'personal' or 'household'.")
  }
  
  # Make sure the year is numeric and four digits
  if(!(is.numeric(year) & nchar(year) == 4)){
    stop("Specify the year as a four digit number.")
  }
  
  # First, check for a local copy of the file. If there is a local version,
  # then read the file into R. If the file does not exist, then download
  # from BJS.
  file_name <- paste0(path, "/", filename)
  
  if(file.exists(file_name) && format == "csv") {
    
    data <- read.csv(file_name, ...)
    
    return(data)
    
  } else if(file.exists(file_name) && format == "json"){
    
    data <- jsonlite::fromJSON(file_name, ...)
    
    return(data)
    
  }  else {
    
    # Base url for the NCVS API on the BJS website
    bjs_url <- "http://www.bjs.gov:8080/bjs/ncvs/v2/" 
    
    # Construct the url to the desired file
    if(pop == TRUE) {
      
      file_url <- paste0(bjs_url, survey, "/", "population", "/", year, "?format=", format)
      
    } else {
      
      file_url <- paste0(bjs_url, survey, "/", year, "?format=", format)
    }
    
    # Place a call to the BJS NCVS API (will fail here if not able to download)
    res <- .download(aurl = file_url, filename = file_name)
    
    # Final step is to load the downloaded data
    if(file.exists(file_name) && format == "csv") {
      
      data <- read.csv(file_name, ...)
      
      return(data)
      
    } else {
      
      data <- jsonlite::fromJSON(file_name, ...)
      
      return(data)
      
    }
    
  }
  
}
