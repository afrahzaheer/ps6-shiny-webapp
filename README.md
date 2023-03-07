# ps6-shiny-webapp

link to shiny web app: https://afrah.shinyapps.io/PS6-webapp/

For this assignment, I used a dataset which contains a list of video games that
sold at least 100,000 copies, between the years of 1980 and 2020. The data set 
includes elements like video game names, platforms, publishers, number of sales
in millions, etc.

There are 3 main sections on the web app:

1. Introduction
        - short overview and background of the dataset, including how many observations
          and what variables are included
2. Plot
        - includes a plot of genres vs. global sales
        - slider widgets allow user to change the data on the plot by choosing
          a starting and ending year
        - checkbox group widget allows user to pick which genres to include in the plot
        - color of bars on plot can be switched with radio buttons
3. Table
        - includes a data table with platforms as well as their average global sales in millions
        - checkbox group widget allows user to pick which platforms to include in the table
        - users can pick one genre with radio buttons, which specifies what genre of sales are
          taken into account when generating the data for the sales column