#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

vgsales <- read_delim("vgsales.csv")


ui <- fluidPage(
    titlePanel("Video Game Sales"),
    tabsetPanel (
      tabPanel("Introduction", 
          sidebarLayout(
              sidebarPanel(
                
                  
              ),
              mainPanel(
                 dataTableOutput("sample")
              )
          )
      ),
      
      tabPanel("Plot", 
               sidebarLayout(
                 sidebarPanel(titlePanel("Video Game Sales by Genre over Time"), 
                    p("This page allows you to pick a starting a ending year, select
                    different video game genres, and then be able to see a graph that
                    shows you how the global sales compare between your chosen genres
                    and years."),
                    checkboxGroupInput("genres","Choose Genres", choices = unique(vgsales$Genre)),
                    sliderInput("min", "Choose Starting Year", min = 1980, 
                                max = 2020, value = 1980, step = 1),
                    sliderInput("max", "Choose Ending Year", min = 1980, 
                                max = 2020, value = 2020, step = 1)
                 ),
                 mainPanel(
                   plotOutput("plot"),
                   textOutput("plotDescription")
                   
                 )
               )
        
      )
    )
)


server <- function(input, output) {
  output$plot <- renderPlot({
    vgsales %>% 
      filter(!is.na(Global_Sales),!is.na(Year)) %>%
      filter(Genre%in%input$genres) %>%
      filter(Year >= input$min) %>% 
      filter(Year <= input$max) %>% 
      ggplot(aes(x = Genre, y = Global_Sales, fill = factor(Genre))) +
        geom_col() +
        labs(title = "Global Sales by Genre", x = "Genres", y = "Global Sales in Millions")
  })
  output$plotDescription <- renderText({
    paste("The above bar graph shows data between the years of", input$min, " and ", input$max, 
          ". The following selected genres are represented: ", paste(input$genres, collapse=", "))
  })
  
  output$sample <- renderDataTable ({
    vgsales %>% 
      group_by(Genre) 
    
  })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
