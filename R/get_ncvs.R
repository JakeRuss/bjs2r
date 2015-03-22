#' Download National Crime Victimization Survey (NCVS) data from the Bureau 
#' of Justice Statistics' API.
#' 
#' Currently provides support for csv and json file formats.
#' 
#' @param filename File name, to be downloaded if local file does not exist
#' @param path path to local file or alternative download directory
#' @param survey survey type string, accepts \code{"personal"} or 
#'   \code{"household"}
#' @param year survey year in yyyy format
#' @param pop logical; \code{TRUE} indicates population data, \code{FALSE} 
#'   indicates counts
#' @param ... additional arguments are passed on to \code{\link[utils]{read.csv}()}
#'   or \code{\link[jsonlite]{fromJSON}()}
#' @export
#'
get_ncvs <- function(filename, path = NULL, survey, year, pop = NULL, ...){
  
  if (is.null(filename)) {
    stop("Must specify a file name", call. = FALSE)
  }
  
  if (!is.null(path)) {
    filename <- file.path(path, filename)
  }
  
  ext      <- tolower(tools::file_ext(filename))
  year     <- check_year(year)
  survey   <- check_survey(survey)
  file_url <- construct_ncvs_url(survey, year, pop, ext)
  
  # If a local copy exists, load it, else download and then load it
  if (file.exists(filename)) {
    
  switch(ext,
         csv  = read.csv(filename),
         json = jsonlite::fromJSON(filename),
         stop("Unsupported format ", ext, call. = FALSE))
    
  } else {    
    download_file(file_url, filename)

    switch(ext,
           csv  = read.csv(filename, ...),
           json = jsonlite::fromJSON(filename, ...),
           stop("Unsupported format ", ext, call. = FALSE))
  } 
}