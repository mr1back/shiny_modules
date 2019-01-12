library(shiny)

source("working_sample.R")

ui <- fixedPage(
  h2("Module example"),
  linkedScatterUI("scatters"),
  textOutput("summary")
)

server <- function(input, output, session) {
  df <- callModule(linkedScatter, "scatters", reactive(mpg),
                   left = reactive(c("cty", "hwy")),
                   right = reactive(c("drv", "hwy"))
  )
  
  output$summary <- renderText({
    sprintf("%d observation(s) selected", nrow(dplyr::filter(df(), selected_)))
  })
}

shinyApp(ui, server)