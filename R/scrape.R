#' Scrape Sagarin ratings
#'
#' Scrape Sagarin ratings from the USA Today website.
#'
#' @param url a character indicating the url to scrape
#' @return a data.frame containing all the scraped data
#' @export
#'
scrape <- function(url = "https://sagarin.usatoday.com/2023-2/college-basketball-team-ratings-2022-23/") {
  doc <- readLines(url)

  # Determine lines that correspond to the table
  RATING_lines <- which(grepl("RATING", doc))+2
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
  foo <- tempfile()
  writeLines(doc[table_rows], con = foo)

  d <- read.fwf(foo, sep = ";",
                widths = c(-28,
                            24,  # team
                           -30,
                            7,   # RATING
                           -29, #
                            5,   # wins
                            4,   # losses
                            8,   # SCHEDL
                           -1,
                            4,   # RANK
                           -1,
                            5,   # wins vs top 25
                            4,   # losses vs top 25
                           -3,
                            5,   # wins vs top 50
                            4,   # losses vs top 50
                           -32,
                            8,   # PREDICTOR
                           -5,
                           -31,
                            8,   # GOLDEN_MEAN
                           -5,
                           -31,
                            8,   # RECENT
                           -5,
                           -9,
                            16   # conference
                           ),
                col.names = c("team","RATING","wins","losses","SCHEDL","RANK",
                  "wins_vs_top_25","losses_vs_top_25",
                  "wins_vs_top_50","losses_vs_top_50",
                  "PREDICTOR","GOLDEN_MEAN","RECENT",
                  "conference")
                )

  d$team <- trimws(d$team)

  return(d)
}
