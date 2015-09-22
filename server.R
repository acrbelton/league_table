# league_table server.R

source("globals.R")

function(input, output, session) {

  lgData <- dummyLeagueData(session)
  
  output$leagueTable <- renderTable({
    lgData() %>%
      mutate(profile_picture = paste0('<img src="', profile_picture, '", height=32></img>'),
             outlet_picture = paste0('<img src="', outlet_picture, '", height=32></img>')) %>%
      select("Position" = position, "Name" = full_name, "Title" = title,
             "Picture" = profile_picture, "Outlet" = outlet_picture,
             "Influence score" = score) %>%
      as.data.frame() %>%
      head(15)
  }, sanitize.text.function = function(x) x, digits = 0)
}
