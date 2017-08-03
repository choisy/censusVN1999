# Downloading the data from GSO ------------------------------------------------
# the webpage:
# http://www.gso.gov.vn/default_en.aspx?tabid=476&idmid=&ItemID=1841

library(magrittr)

# General parameters:
path <- "http://www.gso.gov.vn/Modules/Doc_Download.aspx?DocID="
indexes <- 2157:2289

# Downloading the excel files:
for(i in indexes)
  download.file(paste0(path, i), paste0("data-raw/", i, ".xls"),
                "wget", extra = "--content-disposition")

# Reading in the excel files:
out <- lapply(indexes, function(x) read_excel(paste0("data-raw/", x, ".xls")))
# Names the list elements:
names(out) <- paste0("x", indexes)
# Moving the list elements to the global environment:
list2env(out, globalenv())

# Extracting the descriptions of the files:
first_line <- sapply(out, function(x) names(x)[1])
second_line <- sapply(out, function(x) x[1, 1])
third_line <- sapply(out, function(x) x[2, 1])
replNA <- function(x) {
  x[which(is.na(x))] <- ""
  x
}
second_line %<>% replNA
third_line %<>% replNA
description <- paste(first_line, second_line, third_line) %>%
  gsub("  ", " ", .) %>% trimws
descriptions <- data.frame(dataset = names(out), description = description)

##
#a <- read_excel("data-raw/2159.xls")
#b <- read_excel("data-raw/2160.xls")
