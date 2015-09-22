# league_table globals.R

#install.packages(c("shiny", "dplyr", "htmlwidgets", "digest", "bit"))
#devtools::install_github("rstudio/shinydashboard")
#devtools::install_github("hadley/shinySignals")

library(shiny)
library(shinySignals)
library(dplyr)
library(shinydashboard)

# An empty prototype of the data frame we want to create
prototype <- data.frame(position = numeric(), full_name = character(),
                        title = character(), profile_picture = character(),
                        outlet_picture = character(), score = numeric(),
                        received = numeric())

# Connects to twibalist_data to return league-table data
# Returns a reactive expression that serves up the table as a data frame
leagueData <- function(session) {
  # Connect to db
  con<-dbConnect(drv=dbDriver('PostgreSQL'), 
            host='localhost',
            port='5432',
            dbname="twibalist",
            user='xxxxxxxx',          # your name here
            password='XXXXXXXX')      # your password here
  # Clean up when session is over
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
  
  # Returns table
  newTable <- reactive({
    invalidateLater(1000, session)
    nT <- dbGetQuery(con, "select * from twibalist_dashboards.league_table")
    if (length(nT) == 0)
      return()
    nT <- nT[order(-newTable$score),]
    mutate(nT, position = 1:nrow(newTable), received = as.numeric(Sys.time()))
  })
}

getRandString <- function(len = 12) {
  paste(sample(c(rep(0:9, each = 5), LETTERS, letters), len, replace = TRUE), collapse = '')
}

dummyLeagueRow <- function() {
  data.frame(full_name = getRandString(), title = getRandString(60),
             profile_picture = 'https://pbs.twimg.com/profile_images/1219847835/d0b2cb7b-1504-4af9-97f2-0078c1553c5b.jpg',
             outlet_picture = 'https://pbs.twimg.com/profile_images/564829693736546305/8o1OPz2e_400x400.png',
             score = sample(1:1000, 1),
             stringsAsFactors = FALSE)
}

dummyLeagueData <- function(session) {

  # Returns table
  newTable <- reactive({
    invalidateLater(1000, session)
    nT <- t(sapply(1:(10 + sample(1:10, 1)), function(x) {dummyLeagueRow()}))
    df <- as.data.frame(nT)
    df <- df[order(-unlist(df$score)),]
    mutate(df, position = 1:nrow(df), received = as.numeric(Sys.time()))
  })
}
