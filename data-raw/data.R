## code to prepare `DATASET` dataset goes here

mens_college_basketball <- sagarin::scrape("https://sagarin.usatoday.com/2023-2/college-basketball-team-ratings-2022-23/")

usethis::use_data(mens_college_basketball, overwrite = TRUE)
