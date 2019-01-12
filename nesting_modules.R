# Modules can use other modules. When doing so, when the outer module's UI function calls the inner 
# module's UI function, ensure that the 'id' is wrapped in 'ns()'. In the following example, when 
# 'outerUI' calls 'innerUI', notice that the id argument is 'ns("inner1")':

innerUI <- function(id) {
  ns <- NS(id)
  "This is the inner UI"
}

outerUI <- function(id) {
  ns <- NS(id)
  wellPanel(
    innerUI(ns("inner1"))
  )
}


# As for the module server functions, just ensure that the call to callModule for the inner module 
# happens inside the outer module's server function. There's generally no need to use ns().

inner <- function(input, output, session) {
  # inner logic
}
outer <- function(input, output, session) {
  innerResult <- callModule(inner, "inner1")
  # outer logic
}