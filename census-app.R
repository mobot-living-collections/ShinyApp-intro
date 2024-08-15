#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

########################### DISPLAY REACTIVE OUTPUT ###########################################

#############################                     #############################################
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
# https://shiny.posit.co/r/getstarted/shiny-basics/lesson2/
library(shiny)
library(bslib)
library(bsicons)

#You can create reactive output with a two step process.

#Add an R object to your user interface.
#Tell Shiny how to build the object in the server function. 
#The object will be reactive if the code that builds it calls a widget value.

ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = 
        c("Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0,
      max = 100,
      value = c(0,100)
    )
  ),
  textOutput("selected_var"),
  textOutput("min_max")
)
# textOutput takes an argument, character string "selected_var". Shiny will use
# this as the name of your reactive element. Your users will not see this name

# tell Shiny how to build the object with the server function
# it builds a list-like object named output that contains all of the code needed to update the R objects
# in your app. Each R object needs to have its own entry in the list.
# in the server function below, output$selected_var matches textOutput("selected_Var") in your ui

#server <- function(input, output) {
 # output$selected_var <- renderText({
  #  "You have selected"
  #})
 
#}
# each entry to output should contain the output of one of Shiny's render functions
# use the render function that corresponds to the type of reactive object you are making
# think of this expression as a set of instructions that you give Shiny to store for later

#input is a second list-like object, it stores the current values of all the widgets in your app.
# these values will be saved under the names that you gave the widgets in your ui
# Shiny will automatically make an object reactive if the object uses an input value

server <- function(input, output) {
  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })
  
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })
}
# this is how you create reactivity with Shiny, by connecting the values of input to the objects in output.
# Shiny takes care of all the other details


shinyApp(ui, server)

counties <- readRDS("data/counties.rds")
head(counties)

library(maps)
library(mapproj)

# helpers.R is an R script that can help you make choropleth maps
# In our case, helpers.R will create percent_map, a function designed to map the data in counties.rds

source("helpers.R")
percent_map(counties$white, "darkgreen", "% White")
# percent_map plots the counties data as a choropleth map

# Take a look at the above code. To use percent_map, we first ran helpers.R with the source function, 
# and then loaded counties.rds with the readRDS function. We also ran library(maps) and library(mapproj).

# You will need to ask Shiny to call the same functions before it uses percent_map in your app, 
# but how you write these functions will change. Both source and readRDS require a file path, 
# and file paths do not behave the same way in a Shiny app as they do at the command line.

# When Shiny runs the commands in server.R, it will treat all file paths as 
# if they begin in the same directory as server.R. In other words, 
# the directory that you save server.R in will become the working directory of your Shiny app.

# Since you saved helpers.R in the same directory as server.R, you can ask Shiny to load it with
source("helpers.R")
# Since you saved counties.rds in a sub-directory (named data) 
# of the directory that server.R is in, you can load it with.
counties <- readRDS("data/counties.rds")

# building the app
source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

# user interface

ui <- page_sidebar(
  title = "censusVis",
  
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = 
        c( 
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
          ),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0,
      max = 100,
      value = c(0,100)
    )
  ),
  card(plotOutput("map"))
)

# server logic
# The census visualization app has one reactive object, a plot named "map". 
# The plot is built with the percent_map function, which takes five arguments.
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
   percent_map(data, color, legend, input$range[1], input$range[2])
  })
}
# switch is a useful companion to multiple choice Shiny widgets. 
# Use switch to change the values of a widget into R expressions

# run the app
shinyApp(ui, server)







