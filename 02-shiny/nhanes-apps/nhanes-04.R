# Load packages -----------------------------------------------------
library(shiny)
library(tidyverse)
library(NHANES)

# Define UI ---------------------------------------------------------
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions --------------
  sidebarLayout(
    
    # Inputs: Select variables to plot ------------------------------
    sidebarPanel(
      
      # Select variable for y-axis ----------------------------------
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("Age", "Poverty", "Pulse", "AlcoholYear", "BPSysAve"), 
                  selected = "BPSysAve"),
      
      # Select variable for x-axis ----------------------------------
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("Age", "Poverty", "Pulse", "AlcoholYear", "BPDiaAve"), 
                  selected = "BPDiaAve"),
      
      # Select variable for color -----------------------------------
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Gender", "Depressed", "SleepTrouble", "SmokeNow", "Marijuana"),
                  selected = "SleepTrouble"),
      
      # Set alpha level ---------------------------------------------
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Add checkbox
      checkboxInput(inputId = "showdata",
                    label = "Show data table",
                    value = TRUE)
    ),
    
    # Output: --------------------------------------------------------
    mainPanel(
      # Show scatterplot --------------------------------------------
      plotOutput(outputId = "scatterplot"),
      # Show data table ---------------------------------------------
      DT::dataTableOutput(outputId = "nhanestable", height = 500)
    )
  )
)

# Define server function required to create the scatterplot ---------
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting --
  output$scatterplot <- renderPlot({
    ggplot(data = NHANES, aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point(alpha = input$alpha)
  })
  
  # Print data table if checked -------------------------------------
  output$nhanestable <- DT::renderDataTable({
    if(input$showdata){
      DT::datatable(data = NHANES[, 1:7], 
                    options = list(pageLength = 10, rownames = FALSE) 
      )  
    }
  })
  
}

# Run the application -----------------------------------------------
shinyApp(ui = ui, server = server)
