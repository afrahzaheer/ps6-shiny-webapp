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
               
         p("This app uses a dataset which contains a list of",em("video games"), "with sales greater than 100,000 copies between the years of 1980 and 2020."),
         p("It was found on kaggle.com and generated from data on vgchartz.com."),
         p("There are", nrow(vgsales), "observations in the dataset."),
         
               
         p("The", em("variables"), "in the data set are:"),
               
         p(strong("Rank")," - Ranking of overall sales"),
               
         p(strong("Name")," - The games name"),
               
         p(strong("Platform")," - Platform of the games release (i.e. PC,PS4, etc.)"),
               
         p(strong("Year")," - Year of the game's release"),

         p(strong("Genre")," - Genre of the game"),

         p(strong("Publisher")," - Publisher of the game"),

         p(strong("NA_Sales"), " - Sales in North America (in millions)"),

         p(strong("EU_Sales"), " - Sales in Europe (in millions)"),

         p(strong("JP_Sales")," - Sales in Japan (in millions)"),

         p(strong("Other_Sales")," - Sales in the rest of the world (in millions)"),

         p(strong("Global_Sales")," - Total worldwide sales.")
      ),
      
      tabPanel("plot", 
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
                   plotOutput("genreSalesPlot"),
                   textOutput("genreSalesPlotDescription"),
                   radioButtons("color", "Select color", choices = c("purple", "red"))
                 )
               )
      ),
      
      tabPanel("table", 
               sidebarLayout(
                 sidebarPanel(
                   checkboxGroupInput("platform", "Choose the platform of the game's release", 
                                choices = unique(vgsales$Platform)),
                   radioButtons("genresfortable", "Choose genre of video game", 
                                choices = unique(vgsales$Genre))
                  
                 ),
                 mainPanel(
                   dataTableOutput("sample"),
                   textOutput("tableDescription")
                 )
               )
      )
    )
)


server <- function(input, output) {
  output$genreSalesPlot <- renderPlot({
    vgsales %>% 
      filter(!is.na(Global_Sales),!is.na(Year)) %>%
      filter(Genre%in%input$genres) %>%
      filter(Year >= input$min) %>% 
      filter(Year <= input$max) %>% 
      ggplot(aes(x = Genre, y = Global_Sales, show_col_types = FALSE)) +
        geom_col(col = input$color) +
        labs(title = "Global Sales by Genre", x = "Genres", y = "Global Sales in Millions")
  })
  
  output$genreSalesPlotDescription <- renderText({
    paste("The above bar graph shows data between the years of", input$min, " and ", input$max, 
          ". The following selected genres are represented: ", paste(input$genres, collapse=", "))
  })
  
  
  output$sample <- renderDataTable ({
    vgsales %>% 
      filter(Platform != "N/A", Global_Sales != "N/A", Genre != "N/A") %>% 
      group_by(Platform) %>% 
      filter(Platform%in%input$platform) %>% 
      filter(Genre%in%input$genresfortable) %>% 
      summarize(Averagesales = mean(Global_Sales)) %>% 
      select(Platform, Averagesales)
  })
  
  output$tableDescription <- renderText({
    paste("The table shows data for the following platforms", paste(input$platform, collapse=", "),
          ". The following selected genre is taken into account: ", input$genresfortable)
  })
  
  
    
}

# Run the application 
shinyApp(ui = ui, server = server)
