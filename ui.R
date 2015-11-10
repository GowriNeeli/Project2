library(shinythemes)

shinyUI(
  navbarPage(
    title = "Lending Club investment simulator",
    id = "nav",
    theme = "bootstrap.css",
    inverse = TRUE,
    #position = "fixed-top",
    tabPanel("Introduction",
      wellPanel(h2(toupper("Lending Club"))),
      
      wellPanel(
        h3("Lending club:"),
        h5("For this project, we wish to present and explore the data provided by", span(a(href="https://www.lendingclub.com", "Lending Club"))),
        h5("Lending Club (LC) is a peer to peer online lending platform. It is the world’s largest marketplace connecting borrowers and investors,"),
        h5("where consumers and small business owners lower the cost of their credit and enjoy a better experience than traditional bank lending,"),
        h5("and investors earn attractive risk-adjusted returns.")
      ),
      
      wellPanel(
        h3("How it works:"),
        h5("  1. Customers interested in a loan complete a simple application at LendingClub.com"),
        h5("  2. LC leverage online data and technology to quickly assess risk, determine a credit rating and assign appropriate interest rates."),
        h5("  3. Qualified applicants receive offers in just minutes and can evaluate loan options with no impact to their credit score"),
        h5("  4. Investors ranging from individuals to institutions select loans in which to invest and can earn monthly returns"),
        h5("The entire process is online, using technology to lower the cost of credit and pass the savings back in the form of lower rates for borrowers and solid returns for investors."),
        h5("Here is the link to", span(a(href="https://www.lendingclub.com/public/how-peer-lending-works.action>", "more details")), "about Lending Club.")
      ),
      
      wellPanel(
        h3("Goal of the project:"),
        h5("We will present and explore the data provided by LC at this", span(a(href="https://www.lendingclub.com/info/download-data.action>", "address."))), 
        h5("This data was made available to us after the creation of an investor account."),
        h5("The data consists in 4 files updated every quarter on the same day as the quaterly results of the compagny are released. They contain information on almost all"),
        h5("the loans issued by LC. The only loans missing from these files are the few loans where LC was not authorized to release publicly the details of the transactions."),
        h5("The information available for each loan consists of all the details of the loans at the time of their issuance as well as more information relative to the latest"),
        h5("status of loan such as how much principal has been paid so far, how much interest, if the loan was fully paid or defaulted, or if the borrower is late on payments etc.")
      ),
      
      wellPanel(
        h3("Instructions:"),
        h5("1. Checkout the report that we already made for porject1 where we explore the relationship between defaults rates and all the features available to us."), 
        h5("2. You can run more analysis of the data yourself using the tab: 'Explore the data' where you can graph different discrete variable against any continuous variable available."),
        h5("3. When you are ready, move on to the 'Invest' tab and try running different simulations corresponding to your selected strategy and see how you perform!"),
        h5("4. This is yet to be done but we would like to add a Machine Learning tab where you will be able to run many kind of ML techniques and see how they perform!"),
        h5("5. Checkout how you performed in the 'Hall of fame' tab! you can compare your performance with everyone who submitted before!"),
        h5("6. Finally, if you are interested you can checkout the code and contribute!")
      )
    ),
           
    tabPanel("Full analysis",
      fluidPage(
        wellPanel(
          h5("Here is a link to the ", span(a(href="http://rpubs.com/jfdarre/119147","full analysis."))),
          actionButton("Load_report", "Load Report", icon = icon("arrow-circle-o-down")),
          conditionalPanel(
            condition = 'input.Load_report > 0',
              includeMarkdown("data/Project1_new.Rmd")
          )
        )
      )
    ),

    tabPanel("Explore the data",    
      h4("Use this tab to explore the relationship between the different features and credit risk"),
      fluidRow(
        column(2,
          wellPanel(
            selectInput(
              "sub_data",
              label = "Filter data",
              choices = list("ALL" = "ALL",
                             "Matured Only" = "Matured",
                             "Survived" = "Survived",
                             "Defaulted" = "Defaulted",
                             "Current" = "Current"),
              selected = c("ALL")
            )
          ),
          
          wellPanel(
            selectInput(
              "Bub_category",
              label = "Group",
              choices = discrete_var,
              selected = c("Inquieries_bucket")
            )
          ),
          
          wellPanel(
            selectInput(
              "Bub_x_axis",
              label = "X-Axis",
              choices = continuous_var,
              selected = c("Defaults")
            )
          ),
          
          wellPanel(
            selectInput(
              "Bub_y_axis",
              label = "Y-Axis",
              choices = continuous_var,
              selected = c("LC_Score")
            )
          ),
          
          wellPanel(
            selectInput(
              "Bub_size",
              label = "Size",
              choices = continuous_var,
              selected = c("Interest")
            )
          )
        ),

        column(10,        
          wellPanel(
            textOutput("Remaining_Bub_Plot")
          )
        ),
        
        column(6,
          plotOutput("explore_plot"),
          br(),
          dataTableOutput("bub_data")
        ),
        
        column(4,
          plotOutput("plot_amounts"),
          br(),
          plotOutput("plot_number")
        )
      )
    ),
                    
    tabPanel("Invest",
      h4("Create a systematic strategy to select the loans you want to invest in and see if you can beat the market!"),
      fluidRow(
        conditionalPanel(
          condition = '!input.Confirm || input.Disclaimer == 0',
#           column(1,
#             p("")
#           ),
          column(12,
            wellPanel(
              h2("TERMS OF USE / DISCLAIMER")
            ),
            
            wellPanel(
              h3("1. No Financial Advice"),
              p("The Company is not a Registered Investment Advisor, Broker/Dealer, Financial Analyst, Financial Bank, Securities Broker or Financial Planner. The Information on the Site is provided for information purposes only. The Information is not intended to be and does not constitute financial advice or any other advice, is general in nature and not specific to you. Before using the Company’s information to make an investment decision, you should seek the advice of a qualified and registered securities professional and undertake your own due diligence. None of the information on our Site is intended as investment advice, as an offer or solicitation of an offer to buy or sell, or as a recommendation, endorsement, or sponsorship of any security, Company, or fund. The Company is not responsible for any investment decision made by you. You are responsible for your own investment research and investment decisions.")
            ),
            
            wellPanel(
              h3("2. Disclosure Policy"),
              p("The Company’s affiliates or associates and/or its employees may hold positions in securities that are described on the Site. They may, from time to time, hold positions consistent or inconsistent with information contained on the Site, have no obligation to notify Subscribers in any way regarding said positions and shall have no liability to Subscribers that relates in any way to said positions. Their affiliation or relationship to the Company or its Subscribers shall in no way limit the positions they may hold or when they may hold them.")
            ),
            
            wellPanel(
              h3("3. Risk Disclosure"),
              p("There is a substantial amount of risk in trading securities, and the possibility exists that you can lose all, most or a portion of your capital. The Company does not, cannot and will not assess or guarantee the suitability or profitability of any particular investment, or the potential value of any investment or informational source. The securities mentioned on our Site may not be suitable for investors depending on their specific investment objectives and financial condition. The information provided by the Company, including but not limited to its opinion and analyses, is based on financial models believed to be reliable but is not guaranteed, represented or warranted to be accurate or complete. The charts depict the results of our models and are not influenced by any other factors except the updated parameters which the models use. The models’ signals should not be construed to be investment advice.  The information may contain forward-looking statements about various economic trends and strategies. You are cautioned that such forward-looking statements are subject to significant business, economic and competitive uncertainties and actual results could be materially different. There are no guarantees associated with any forecast and the opinions stated here could be wrong due to false signals from the models, or the models being incorrectly structured, incorrectly updated and/or incorrectly interpreted. The signals, forecasts, the Site and Company’s products and services, only express our opinion of various securities.  Our opinion will be wrong at times because of the limitations of investment analysis. Investment analysis, whether fundamental, technical or any other form of investment analysis, can not predict the future and is not a science that predicts precise and accurate results. Your use of any information from the Site is at your own risk and without recourse against the Company, its owners, directors, officers, employees or content providers.")
            ),
            
            wellPanel(
              h3("4. Backtesting"),
              p("The information from the Site is based on financial models, and trading signals are generated mathematically. All of the signals, timing systems, and forecasts are the result of backtesting, and are therefore merely hypothetical. Trading signals or forecasts used to produce our results were derived from equations which were developed through hypothetical reasoning based on a variety of factors. Theoretical buy and sell methods were tested against the past to prove the profitability of those methods in the past. Performance generated through back testing has many and possibly serious limitations. We do not claim that the historical performance of the Company’s timing systems, signals or forecasts will be indicative of future results. There will be substantial and possibly extreme differences between historical performance and future performance.  Past performance is no guarantee of future performance. There is no guarantee that out-of-sample performance will match that of prior in-sample performance. The Company does not claim or warrant that its timing systems, signals, forecasts, opinions or analyses are consistent, logical or free from hindsight or other bias or that the data used to generate signals in the backtests was available to investors on the dates for which theoretical signals were generated.")
            ),
            
            wellPanel(
              h3("5. Disclaimer of Warranties and Limitation of Liability"),
              p("a) Member expressly agrees that use of the Site are at his or her sole risk. Neither the Company, its affiliates, nor any of their respective employees, agents, third-party content providers, or licensors warrants that use of the Site will be uninterrupted or error free, or secure, that defects or errors will be corrected, or that the Site or the server(s) on which the Site is hosted will be free of viruses or other harmful components; nor do they make any warranty as to the results that may be obtained from use of the Site or as to the accuracy, reliability, or content of any information, service, or merchandise provided through the Site.  You assume complete responsibility and risk for your use of the Site and your reliance thereon.  The Company has no obligation to update information on the Site or advise on future developments regarding topics mentioned or introduced. In the event that the Site refers to or contains links to other Internet web sites or resources, we make no representation or warranty and hereby expressly deny that the Company has reviewed, approved, controls or endorses any content that appears on such other web sites. You acknowledge and agree that we shall not be held responsible for any loss or damages caused or alleged to have been caused by the reliance on or use of any such content nor for the accuracy, legality, or inappropriate nature of any content, products, services, advertising, or information located in, on or through any other web sites."),
              p("b) The Site is provided on an “as is” basis without warranties of any kind, either express or implied, including but not limited to warranties of title or implied warranties of merchantability or fitness for a particular purpose, other than those warranties which are implied by and incapable of exclusion, restriction, or modification under the laws applicable to this agreement."),
              p("c) The disclaimers of liability contained in this section apply to any damages or injury caused by any failure of performance, error, omission, interruption, deletion, defect, delay in operation or transmission, computer virus, communication line failure, theft or destruction or unauthorized access to, alteration of, or use of record, whether for breach of contract, tortious behavior, negligence, or under any other cause of action. Member specifically acknowledges that the Company is not liable for the defamatory, offensive, or illegal conduct of other third parties, members, or other users of the forums and that the risk of injury from the forgoing rests entirely with each member."),
              p("d) In no event will the Company or any person or entity involved in creating, producing, or distributing content of the Site be liable for any direct, indirect, incidental, special, or consequential damages (including but not limited to lost profits or trading losses) arising out of the use of or inability to use the Site or out of the breach of any warranty. Member hereby acknowledges that the provisions of this section shall apply to all content of the Site."),
              p("e) The Company neither endorses nor is responsible for the accuracy or reliability of any opinion, advice, or statement on the Site, nor for any offensive, defamatory, or obscene posting made on the forums by anyone other than authorized the Company employee spokespersons while acting in their official capacities. Under no circumstances will the Company be liable for any loss or damage caused by a member’s reliance on information obtained through the content on the Site. It is the responsibility of each member to evaluate the accuracy, completeness, or usefulness of any information, opinion, advice, or other content available through the Site."),
              p("f) The Company does not endorse, warrant, or guarantee any product or service offered by a third party through the Site."),
              p("g) Under no circumstances shall the Company, its officers, directors, shareholders agents or its third-party providers be liable for any direct, indirect, incidental, punitive, special or consequential damages (including without limitation, attorneys’ fees), whether in an action of contract, negligence or other tortious action, that result from the use of, or the inability to use, any materials available on the Site, even if the Company has been advised of such damages. If you are dissatisfied with any of the Site’s Information or other materials, or with any of the terms and conditions contained in the Site, your sole and exclusive remedy is to discontinue using the Site. If the Company is found liable in connection with a claim arising out of or related to the services or the Site, their aggregate liability in such an event shall not exceed the amount of the fees paid by you for use of the service during the month in which the event giving rise to the liability occurred. Your right to monetary damages in such amount shall be in lieu of all other remedies to which you may otherwise be entitled from the Company, or its third-party providers.")
            ),
            
            wellPanel(
              checkboxInput("Confirm", "I confirm I read the disclaimer", value = FALSE),
              conditionalPanel(
                condition = 'input.Confirm',
                actionButton("Disclaimer", "I understand!", icon = icon("thumbs-o-up"))
              )
            ),
            
            br(),
            br(),
            br(),
            br(),
            br()
          )
        ),
        
        conditionalPanel(
          condition = 'input.Confirm && input.Disclaimer > 0',
          column(2,
            wellPanel(
              h4("Options:"),
              checkboxGroupInput("Options",
                label = "Choose what tool bars to display:",
                choices = list("Investment details" = "A",
                               "Loan details" = "B",
                               "Personal details" = "C",
                               "Financial detail" = "D",
                               "Save/Load" = "E",
                               "Submissions" = "F"),
                selected = c("A")
              ),
              br(),
              checkboxInput("Transpose", "Transpose summary"),
              actionButton("Invest", "Invest!", icon = icon("dollar")),
              numericInput("Seed","Seed",value=1)
            ),
            
            conditionalPanel(
              condition = 'input.Options.indexOf("A") > -1',
              wellPanel(
                h4("Investment details:"),
                numericInput("to_invest",
                  label = "Amount to be invested:",
                  value = 100000,
                  min = 0,
                  max = 1000000000
                ),
                
                dateInput("start_date",
                  label = "Start date:",
                  format = "M-yyyy",
                  value = "2010-01-01",
                  min = "2007-06-01",
                  max = "2015-06-01"
                ),
                
                numericInput("max_amount",
                  label = "Maximum amount to invest in a given loan:",
                  value = 2000,
                  min = 0,
                  max = 35000
                ),
                
                numericInput("re_invest",
                  label = "Portion of the payments to be re-invested in %:",
                  value = 80,
                  min = 0,
                  max = 100
                ),
                
                numericInput("cash_rate",
                  label = "Return you expect to get on cash in %:",
                  value = 4,
                  min = 0,
                  max = 100
                )
              )
            ),
            
            conditionalPanel(
              condition = 'input.Options.indexOf("B") > -1',
              wellPanel(
                h4("Details on the loans:"),
                sliderInput("Amount",
                  label = "Amount:",
                  width = "95%",
                  min = 500, max = 35000, value = c(0,35000)
                ),
      
                sliderInput("Rate",
                  label = "Interest rates:",
                  width = "95%",
                  min = 5, max = 30, value = c(5,30)
                ),
                
                sliderInput("FICOrange",
                  label = "FICO scores:",
                  width = "95%",
                  min = 660, max = 850, value = c(660,850)
                ),
  
                checkboxGroupInput("LCgrade",
                  label = "LC-grades to invest in:",
                  choices = list("A" = "A",
                                "B" = "B",
                                "C" = "C",
                                "D" = "D",
                                "E" = "E",
                                "F" = "F",
                                "G" = "G"),
                  inline = T,
                  selected = c("A", "B", "C", "D", "E", "F", "G")
                ),
                  
                checkboxGroupInput("Term",
                  label = "Terms:",
                  choices = list("3y" = " 36 months",
                                "5y" = " 60 months"),
                  selected = c(" 36 months", " 60 months")
                ),
                  
                checkboxGroupInput("Purpose",
                  label = "Purpose:",
                  choices = list("Debt reconciliation" = "debt",
                                "Purchase" = "purchase",
                                "Business" = "small_business",
                                "Education" = "educational"),
                  selected = c("debt", "purchase", "small_business", "educational")
                )
              )
            )
          ),
          
          column(2,
            conditionalPanel(
              condition = 'input.Options.indexOf("F") > -1',
              wellPanel(
                h4("Submissions:"),
                textInput("Name_submit", "Your name:"),
                
                conditionalPanel(
                  condition = 'input.Name_submit != ""',
                  actionButton("Submit", "Submit!", icon = icon("cloud"))
                ),
                
                conditionalPanel(
                  condition = 'input.Name_submit == ""',
                  br()
                )
              )
            ),
            
            conditionalPanel(
              condition = 'input.Options.indexOf("E") > -1',
              wellPanel(
                h4("Save/Load:"),
                textInput("Name", "Name of the strategy"),
                
                conditionalPanel(
                  condition = 'input.Name != ""',
                  actionButton("Save", "Save", icon = icon("download"))
                ),
                
                conditionalPanel(
                  condition = 'input.Name == ""',
                  br()
                ),
                
                selectInput(
                  "Select_load",
                  label = "Select a strategy to load",
                  choices = file_list
                ),
                
                actionButton("Load", "Load", icon = icon("upload"))
              )
            ),
            
            conditionalPanel(
              condition = 'input.Options.indexOf("C") > -1',
              wellPanel(
                h4("Personal details:"),
                sliderInput("Inquieries",
                  label = "Number of inquieries last 6mths",
                  width = "95%",
                  min = 0, max = 20, value = c(0,20)
                ),
      
                sliderInput("Income",
                  label = "Annual income in USD 1,000s:",
                  width = "95%",
                  step = 5,
                  min = 0, max = 200, value = c(0,200)
                ),
      
                sliderInput("Emp",
                  label = p("Employement length:", h6("0 means unemployed and 10 means 10+ years")),
                  width = "95%",
                  step = 0.5,
                  min = 0, max = 10, value = c(0,10)
                ),
  
                sliderInput("DTI",
                  label = "Debt To Income ratio:",
                  width = "95%",
                  step = 2,
                  min = 0, max = 40, value = c(0,40)
                ),
      
                checkboxGroupInput("Home",
                  label = "Choose the home ownership:",
                  choices = list("Own" = "OWN",
                                 "Rent" = "RENT",
                                 "Mortgage" = "MORTGAGE",
                                 "Other" = "OTHER"),
                  inline = T,
                  selected = c("OWN", "RENT", "MORTGAGE", "OTHER")
                )
              )
            ),
            
            conditionalPanel(
              condition = 'input.Options.indexOf("D") > -1',
              wellPanel(
                h4("Financial details:"),
                sliderInput("Delinq",
                  label = "Number of delinquencies commited by the borrower over the past 2 years:",
                  width = "95%",
                  min = 0, max = 5, value = c(0,5)
                ),
                
                sliderInput("Records",
                  label = "Number of public records:",
                  width = "95%",
                  min = 0, max = 5, value = c(0,5)
                ),
      
                sliderInput("Credit_History",
                  label = "Age of the borrower's credit:",
                  width = "95%",
                  min = 0, max = 20, value = c(0,20)
                ),
      
                sliderInput("Balance",
                  label = "Revolving Balance in USD 1,000s:",
                  width = "95%",
                  min = 0, max = 100, value = c(0,100)
                ),
      
                sliderInput("Rev_util",
                  label = "Credit line utilization:",
                  width = "95%",
                  min = 0, max = 100, value = c(0,100)
                ),
  
                sliderInput("Accounts",
                  label = "Number of accounts:",
                  width = "95%",
                  min = 0, max = 30, value = c(0,30)
                )
              )
            )
          ),
              
          column(8,
            wellPanel(
              textOutput("Remaining")
            ),
            
            conditionalPanel(
              condition = 'input.Invest > 0',
              wellPanel(
                textOutput("Investment_result"),
                plotOutput("plot1")
              ),
              
              wellPanel(
                h4("Investment summary:"),
                dataTableOutput("Investment_summup")
              ),
              
              wellPanel(
                h4("Portfolio details:"),
                dataTableOutput("Portfolio")
              )
            )
          )
        )
      )
    ),
    
    tabPanel("ML",
      h4("Train the machine and see how it performs against us humans!")
    ),
    
    tabPanel("HoF",
      h4("See how your strategy performed compared to others!"),      
      wellPanel(
        dataTableOutput("HOF")
      )
    ),
    
    tabPanel("Code",
      h4("Please find below the code:"),      
      tabsetPanel(
        type = "pills", 
        position = "left",
        tabPanel("ui.R", includeMarkdown("ui.Rmd")), 
        tabPanel("server.R", includeMarkdown("server.Rmd")), 
        tabPanel("helpers.R", includeMarkdown("helpers.Rmd")), 
        tabPanel("global.R", includeMarkdown("global.Rmd")),
        tabPanel("prepData.R", includeMarkdown("prepData.Rmd"))
      )
    ),
    
    tabPanel("About",
      h4("hi!")
    )
  )
)