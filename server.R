# server.R
library(dplyr)
library(stats)
library(reshape)
library(ggplot2)
library(ggthemes)
library(grid)

load("data/LCtest.RData")
source("helpers.R")

shinyServer(
  function(input, output, session) {
    my_data = reactive({
      filter(LCtest, 
             grade %in% input$LCgrade,
             fico_range_high >= input$FICOrange[1],
             fico_range_high <= input$FICOrange[2],
             loan_amnt >= input$Amount[1],
             loan_amnt <= input$Amount[2],
             term %in% input$Term,
             rate >= input$Rate[1],
             rate <= input$Rate[2],
             emp >= input$Emp[1],
             emp <= input$Emp[2],
             Home_Ownership %in% input$Home,
             income >= input$Income[1] * 1000,
             income <= input$Income[2] * 1000,
             Purpose %in% input$Purpose,
             dti >= input$DTI[1],
             dti <= input$DTI[2],
             delinq >= input$Delinq[1],
             delinq <= input$Delinq[2],
             credit_y >= input$Credit_History[1],
             credit_y <= input$Credit_History[2],
             inq >= input$Inquieries[1],
             inq <= input$Inquieries[2],
             accounts >= input$Accounts[1],
             accounts <= input$Accounts[2],
             records >= input$Records[1],
             records <= input$Records[2],
             balance >= input$Balance[1] * 1000,
             balance <= input$Balance[2] * 1000,
             revol_util_new >= input$Rev_util[1],
             revol_util_new <= input$Rev_util[2])
    })
    
    
    save_data = reactive({
      list(to_invest = input$to_invest,
           start_date = input$start_date,
           max_amount = input$max_amount,
           re_invest = input$re_invest,
           cash_rate = input$cash_rate,
           Amount = input$Amount,
           Rate = input$Rate,
           FICOrange = input$FICOrange,
           LCgrade = input$LCgrade,
           Term = input$Term,
           Purpose = input$Purpose,
           Inquieries = input$Inquieries,
           Income = input$Income,
           Emp = input$Emp,
           DTI = input$DTI,
           Home = input$Home,
           Delinq = input$Delinq,
           Records = input$Records,
           Credit_History = input$Credit_History,
           Balance = input$Balance,
           Rev_util = input$Rev_util,
           Accounts = input$Accounts,
           Seed = input$Seed
           )
    })
    
    
    investment_result = reactive({
      input$Invest
      isolate(invest(my_data(),
                 input$to_invest,
                 input$start_date,
                 input$re_invest,
                 input$max_amount,
                 input$cash_rate,
                 input$Seed))
    })
    
    
    bub_plot_data = reactive({
      filter_plot_data(LCtest, input$sub_data)
    })
    
    
    observeEvent(input$Save, {
      tryCatch({
        saveData(save_data(), input$Name, outputDir)
        file_list2 = list.files(outputDir, full.names = F)
        updateSelectInput(session, "Select_load", choices = file_list2)
      })
    })
    
    
    loaded_data = reactive({
      input$Load
      isolate(loadData(input$Select_load))
    })
    
    
    observeEvent(input$Load, {
      tryCatch({
        updateNumericInput(session, "to_invest", value = loaded_data()$to_invest)
        updateDateInput(session, "start_date", value = loaded_data()$start_date)
        updateNumericInput(session, "max_amount", value = loaded_data()$max_amount)
        updateNumericInput(session, "re_invest", value = loaded_data()$re_invest)
        updateNumericInput(session, "cash_rate", value = loaded_data()$cash_rate)
        updateSliderInput(session, "Amount", value = loaded_data()$Amount)
        updateSliderInput(session, "Rate", value = loaded_data()$Rate)
        updateSliderInput(session, "FICOrange", value = loaded_data()$FICOrange)
        updateCheckboxGroupInput(session, "LCgrade", selected = loaded_data()$LCgrade)
        updateCheckboxGroupInput(session, "Term", selected = loaded_data()$Term)
        updateCheckboxGroupInput(session, "Purpose", selected = loaded_data()$Purpose)
        updateSliderInput(session, "Inquieries", value = loaded_data()$Inquieries)
        updateSliderInput(session, "Income", value = loaded_data()$Income)
        updateSliderInput(session, "Emp", value = loaded_data()$Emp)
        updateSliderInput(session, "DTI", value = loaded_data()$DTI)
        updateCheckboxGroupInput(session, "Home", selected = loaded_data()$Home)
        updateSliderInput(session, "Delinq", value = loaded_data()$Delinq)
        updateSliderInput(session, "Records", value = loaded_data()$Records)
        updateSliderInput(session, "Credit_History", value = loaded_data()$Credit_History)
        updateSliderInput(session, "Balance", value = loaded_data()$Balance)
        updateSliderInput(session, "Rev_util", value = loaded_data()$Rev_util)
        updateSliderInput(session, "Accounts", value = loaded_data()$Accounts)
        updateNumericInput(session, "Seed", value = loaded_data()$Seed)
      })
    })
    
    
    observeEvent(input$Submit, {
      tryCatch({
        saveData(save_data(), input$Name_submit, outputDir)
        file_list2 = list.files(outputDir, full.names = F)
        updateSelectInput(session, "Select_load", choices = file_list2)
        
        x = investment_result()$summary
        tr = (tail(x$Principal, 1) + tail(x$Cash, 1) + tail(x$Reinvested, 1)) / input$to_invest
        submition_data = data_frame(
          Name = input$Name_submit,
          Full_Return = tr * 100,
          Annual_Return = (round(tr^(12/nrow(x)),3)-1)*100,
          Strategy = sprintf("%s_%s.RDS", input$Name_submit, as.integer(Sys.time()))
        )
        
        saveData(submition_data, input$Name_submit, submitDir)
        
      })
    })
    
    
    HOF = reactive({
      input$Submit
      submits_list = list.files(submitDir, full.names = TRUE)
      return(load_HOF(submits_list))
    })
    
    
    output$HOF = renderDataTable({
      HOF()
    })
    
    
    output$explore_plot = renderPlot({
      bub_plot(bub_plot_data(), input$Bub_category, input$Bub_x_axis, input$Bub_y_axis, input$Bub_size)
    })
    
    
    output$plot_amounts = renderPlot({
      plot_amounts(bub_plot_data(), input$Bub_category)
    })
    
    
    output$plot_number = renderPlot({
      plot_number(bub_plot_data(), input$Bub_category)
    })
    
    
    output$bub_data = renderDataTable(
      full_summup(bub_plot_data(), input$Bub_category)[,c(input$Bub_category, input$Bub_x_axis, input$Bub_y_axis, input$Bub_size)],
      options = list(searching = FALSE, paging = FALSE)
    )
    
    
    output$Remaining_Bub_Plot = renderText({ 
      paste0("Remaining Loans: ", prettyNum(nrow(bub_plot_data()), big.mark = ","), " for a total of: $", 
            prettyNum(sum(bub_plot_data()$loan_amnt/1), big.mark = ","),".") 
    })
    
    
    output$Remaining = renderText({ 
      paste0("Remaining Loans: ", prettyNum(nrow(my_data()), big.mark = ","), " for a total of: $", 
            prettyNum(sum(my_data()$loan_amnt/1), big.mark = ","),".") 
    })
    
    
    output$Investment_result = renderText({
      x = investment_result()$summary
      tr = tail(x$Principal, 1) + tail(x$Cash, 1) + tail(x$Reinvested, 1)
      paste0("You ended up with a final return of: $", prettyNum(round(tr,0), big.mark = ","),
             ". This corresponds to an annual return of: ", round((tr/input$to_invest)^(12/nrow(x))-1,3)*100, "%.")
    })
    
    
    output$plot1 = renderPlot({
      plot_portfolio(investment_result()$summary)
    })    
    
    
    output$Investment_summup = renderDataTable(
      if(input$Transpose) {
        transpose(investment_summup(investment_result()$portfolio))
      } else {
        investment_summup(investment_result()$portfolio)
      },
      options = list(searching = FALSE, paging = FALSE)
    )
    
    
    output$Portfolio = renderDataTable(
      investment_result()$portfolio_short,
      options = list(
        lengthMenu = list(c(20, 50, -1), c('20', '50', 'All')),
        pageLength = -1)
    )
    
    
  }
)