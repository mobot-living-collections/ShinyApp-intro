# Load packages ----
library(shiny)
library(bslib)
library(quantmod)

# Source helpers ----
source("helpers.R")

# User interface ----
ui <- page_sidebar(
  title = "stockVis",
  sidebar = sidebar(
    helpText(
      "Select a stock to examine.

        Information will be collected from Yahoo finance."
    ),
    textInput("symb", "Symbol", "SPY"),
    dateRangeInput(
      "dates",
      "Date range",
      start = "2013-01-01",
      end = as.character(Sys.Date())
    ),
    br(),
    br(),
    checkboxInput(
      "log",
      "Plot y axis on log scale",
      value = FALSE
    ),
    checkboxInput(
      "adjust",
      "Adjust prices for inflation",
      value = FALSE
    )
  ),
  card(
    card_header("Price over time"),
    plotOutput("plot")
  )
)

# Server logic
server <- function(input, output) {
  
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  
  output$plot <- renderPlot({
    
    chartSeries(finalInput(), theme = chartTheme("white"),
                type = "line", log.scale = input$log, TA = NULL)
  })
  
}

# Run the app
shinyApp(ui, server)

# here's an example of the flow
# A user clicks “Plot y axis on the log scale.”
# renderPlot re-runs.
# renderPlot calls finalInput.
# finalInput checks with dataInput and input$adjust.
# If neither has changed, finalInput returns its saved value.
# If either has changed, finalInput calculates a new value with the current inputs. 
# It will pass the new value to renderPlot and store the new value for future queries.

##### how to share R Shiny Apps ##########
# https://shiny.posit.co/r/getstarted/shiny-basics/lesson7/ 









