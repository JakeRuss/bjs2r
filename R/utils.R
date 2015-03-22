check_year <- function(year) {
  if(!(is.numeric(year) && nchar(year) == 4)){
  stop("Specify the year as a four digit number.")
  }
  return(year)
}

check_survey <- function(survey) {
  survey <- tolower(survey)
  if(!(survey %in% c("personal", "household"))) {
  stop(survey, " is not an accepted survey type. Accepted options are 'personal' or 'household'.")
  }
  return(survey)
}

construct_ncvs_url <- function(survey, year, pop, ext) {

  # Base url for the NCVS API on the BJS website
  api_url <- "http://www.bjs.gov:8080/bjs/ncvs/v2/"
  
  if(pop == TRUE) {
    file_url <- paste0(api_url, survey, "/", "population", "/", year, "?format=", ext)
  } else {
    file_url <- paste0(api_url, survey, "/", year, "?format=", ext)
  }
  return(file_url)
}

download_file <- function(file_url, filename) {
  
  resp <- download.file(url = file_url, destfile = filename, quiet = FALSE, 
                        mode = "wb")
  
  if (!(resp == 0)) {
    stop('Unable to download the file' )
    }
}
