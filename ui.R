library(shiny)
library(shinydashboard)
library(plotly)

prefcode <- read.csv("prefcode.csv", stringsAsFactors = FALSE)$pref

shinyUI(dashboardPage(
    dashboardHeader(title="Municipal Code Viewer"),
    dashboardSidebar(
      checkboxGroupInput("pref", "都道府県", prefcode, "神奈川県")
    ),
    dashboardBody(
      plotlyOutput("distPlot", height = "800px")
    )
))
