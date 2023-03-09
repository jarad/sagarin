#' Scrape Sagarin ratings
#'
#' Scrape Sagarin ratings from the USA Today website.
#'
#' @param url
#' @return a data.frame containing all the scraped data
#'
scrape <- function(url = "https://sagarin.usatoday.com/2023-2/college-basketball-team-ratings-2022-23/") {
  doc <- read_html(url)
}


library(rvest)

url <- "https://sagarin.usatoday.com/2023-2/college-basketball-team-ratings-2022-23/"

doc <- rvest::read_html(url)

doc %>% html_elements("pre")


doc2 <- readLines(url)

RATING_lines <- which(grepl("RATING", doc2))+2
diff13 <- which(diff(RATING_lines)==13)
table_starts <- RATING_lines[diff13]

n <- length(table_starts)

table_rows <- numeric(0)
for (i in seq_along(table_starts)) {
  if (i < length(table_starts)) {
    table_rows <- c(table_rows, table_starts[i] + 0:9)
  } else {
    table_rows <- c(table_rows, table_starts[i] + 0:2)
  }
}

read_row <- function(row) {
  row <- gsub('</font>', '', row)
  row <- gsub('<font color=\"#000000\">', '', row)
  row <- gsub('=<font color=\"#9900ff\">', '', row)
  row <- gsub('|<font color=\"#0000ff\">', '', row)
  row <- gsub('|<font color=\"#000000\">', '', row)
  row <- gsub('|<font color=\"#bb0000\">', '', row)
  row <- gsub('|<font color=\"#006B3C\">', '', row)
}

writeLines(doc2[table_rows], con = "temp.txt")

d <- read.fwf("temp.txt", sep = ";",
              widths = c(-28, 24, -30, 7, -30, 4, 4, 8, 1, 4, 2,
                         4, 4, 4, 4, 5,
                         -31, 8, 5,
                         -31, 8, 5,
                         -31, 8, 5,
                         -31, 8, 5,
                         9, 16))

