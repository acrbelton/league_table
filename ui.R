# league_table ui.R

dashboardPage(
  dashboardHeader(title = "Dynamic league table"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(width = 8, status = "info", solidHeader = TRUE,
          title = "Journalist league table",
          tableOutput("leagueTable")
      )
    )
  )
)