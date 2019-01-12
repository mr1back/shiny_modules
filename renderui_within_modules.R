# inside of a module, you may want to use uiOutput/renderUI. If your renderUI block itself 
# contains inputs/outputs, you need to use ns() to wrap your ID arguments, just like in the examples 
# above. But those ns instances were created using NS(id), and in this case, there's no id parameter to use. What to do?

# The session parameter can provide the ns for you; just call ns <- session$ns. This will put the ID in the same namespace as the session.

columnChooserUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("controls"))
}

columnChooser <- function(input, output, session, data) {
  output$controls <- renderUI({
    ns <- session$ns
    selectInput(ns("col"), "Columns", names(data), multiple = TRUE)
  })
  
  return(reactive({
    validate(need(input$col, FALSE))
    data[,input$col]
  }))
}