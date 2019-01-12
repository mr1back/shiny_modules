library(shiny)
library(ggplot2)

# First we'll make the module UI function. We want two plots, 'plot1' and 'plot2', side-by-side with a common brush ID of 'brush'. 
# (Notice that the brush ID needs to be wrapped in 'ns()', just like the plotOutput IDs.)

linkedScatterUI <- function(id) {
  ns <- NS(id)
  
  fluidRow(
    column(6, plotOutput(ns("plot1"), brush = ns("brush"))),
    column(6, plotOutput(ns("plot2"), brush = ns("brush")))
  )
}


# The module server function comes next. Besides the mandatory input, output, and session parameters, 
# we need to know the data frame to plot (data), and the column names that should be used 
# as x and y for each plot (left and right).

# To allow the data frame and columns to change in response to user actions, the data, left, 
# right must all be reactive expressions.

linkedScatter <- function(input, output, session, data, left, right) {
  # Yields the data frame with an additional column "selected_"
  # that indicates whether that observation is brushed
  dataWithSelection <- reactive({
    brushedPoints(data(), input$brush, allRows = TRUE)
  })
  
  output$plot1 <- renderPlot({
    scatterPlot(dataWithSelection(), left())
  })
  
  output$plot2 <- renderPlot({
    scatterPlot(dataWithSelection(), right())
  })
  
  return(dataWithSelection)
}

# Notice that the 'linkedScatter' function returns the 'dataWithSelection' reactive. This means that 
# the caller of this module can make use of the brushed data as well, such as showing it in a table 
# below the plots, for example.

# For clarity and ease of testing, let's put the plotting code in a standalone function. 
# The 'scale_color_manual' call sets the colors of unselected vs. selected points, 
# and 'guide = FALSE' hides the legend.

scatterPlot <- function(data, cols) {
  ggplot(data, aes_string(x = cols[1], y = cols[2])) +
    geom_point(aes(color = selected_)) +
    scale_color_manual(values = c("black", "#66D65C"), guide = FALSE)
}
