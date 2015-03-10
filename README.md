# bjs2r

bjs2r is a set of convience functions for importing Bureau of Justice Statistics 
(BJS) data directly into R from the BJS Data API.

This product uses the BJS Data API but is not endorsed or certified by BJS.

## Installation

```R
# install.packages("devtools")
devtools::install_github("jakeruss/bjs2r")
```

## Usage

* Current offers support for the National Crime Victimization Survey (NCVS)

`get_ncvs(survey   = "personal", 
          year     = 2009, 
          pop      = TRUE, 
          filename = "filename.csv", 
          path     = "path/to/directory", 
          as.is    = TRUE)`