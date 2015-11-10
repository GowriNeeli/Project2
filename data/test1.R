#    temp_x = reactive({ investment_result()$summary })
#     temp_tr = reactive({ (tail(temp_x()$Reinvested, 1) + tail(temp_x()$Cash, 1)) / temp_x()$invested[1] })
#     submition_data = reactive({
#       data_frame(
#         Name = input$Name_submit,
#         Full_Return = temp_tr() * 100,
#         Annual_Return = (round(temp_tr()^(12/nrow(temp_x())),3)-1)*100,
#         Strategy = sprintf("%s_%s.RDS", name, as.integer(Sys.time()))
#       )
#     })


tr = 1.5
name = "JF"
data_frame(
        Name = name,
        Full_Return = tr,
        Annual_Return = round(tr^(12/66),1)-1,
        Strategy = sprintf("%s_%s.RDS", name, as.integer(Sys.time()))
      )


runExample("10_download")

saved_data = list(
        to_invest = list(a = 10, b = 15),
        start_date = 20)

saved_data$to_invest
saveRDS(saved_data, file = "responses/test2.RDS")
temp = readRDS("responses/test_1445214182.RDS")

a = 2
saved_data = NULL

save_data(saved_data, "test2")

    investment_result = reactive({
      a = input$Invest
      if (a == 0) {
        x = invest(LCtest, 
                   input$to_invest, 
                   input$start_date, 
                   input$re_invest, 
                   input$max_amount,
                   input$cash_rate)
        return(x)
      } else {
        input$Invest
        isolate({
        x = invest(my_data(), 
                   input$to_invest, 
                   input$start_date, 
                   input$re_invest, 
                   input$max_amount,
                   input$cash_rate)
        return(x)
        })
      }
    })

t = as.Date("2010-01-15")
as.numeric(format(t, "%Y%m"))

# function to run simulation
invest = function(my_data, to_invest, t, re_invest, max_amount){
  t = as.numeric(format(t, "%Y%m"))
  my_data = mutate(my_data, invested = 0, pymnt = 0)
  range = sort(unique(pmax(range,t)))
  
  portfolio = c()
  summary = c()
  summary$time = t
  summary$invested = to_invest
  summary$received = 0
  summary$total_received = 0
  summary = as.data.frame(summary)
  i = 0

  for (t in range) {
    i = i + 1
    summary_temp = c()
    summary_temp[1] = i
    
    if (!is.null(portfolio)) { 
      portfolio = mutate(portfolio, pymnt = invested / loan_amnt * 
                                            ifelse(last_pymnt_ym == t, last_pymnt_amnt + recoveries,
                                            ifelse(last_pymnt_ym  > t, installment, 0)))
      to_invest = to_invest + re_invest/100 * sum(portfolio$pymnt)
      summary_temp[3] = sum(portfolio$pymnt)
      summary_temp[2] = sum(portfolio$invested)
      summary_temp[4] = summary_temp[3] + tail(summary$total_received,1)
    } else { 
      summary_temp[3] = 0
      summary_temp[2] = to_invest
      summary_temp[4] = 0
    }
    
    summary = rbind(summary, summary_temp)
    
    data = filter(my_data, issue_ym == t)
    if (nrow(data) == 0) { next }
    
    purchase = buy(data, to_invest, max_amount)
    to_invest = purchase$to_invest_next
    portfolio = rbind(portfolio, purchase$purchased)
  }
  
  summary = summary[2:nrow(summary),]
  result = list(portfolio = portfolio,
                portfolio_short = portfolio[,c("id","issue_d","loan_amnt","term","rate","grade","Purpose","invested","loan_status_new")],
                summary = summary)
  return(result)
}


buy = function(data, to_invest, max_amount) {
  n = nrow(data)
  purchased_loans = c()

  for (i in 1:n) {
    if (to_invest < max_amount) { break }
    select = ceiling(runif(1)*nrow(data))
    temp = data[select,]
    invest = pmin(max_amount, temp$loan_amnt)
    temp$invested = invest
    to_invest = to_invest - invest
    purchased_loans = rbind(purchased_loans, temp)
    data = data[-select,]
    if (nrow(data) == 0) { break }
  }

  result = list(purchased = purchased_loans, to_invest_next = to_invest)
  return(result)
}


ggplot(data) +
  geom_histogram(aes(x=time, y=total_received), stat="identity", fill= "steelblue", alpha = 0.7, width = 0.9) +
  ggtitle("Performance of the portfolio") +
  ylab("Wealth") + 
  xlab("Time period in months") +
  scale_x_continuous(breaks=seq(0,120,6)) +
  theme_bw() +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0)) +
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18))


ggplot(plot_data, aes_string(x=a, y=c, fill=a)) +
  geom_bar(stat="identity") +
  theme_bw() +
  scale_size(range = c(low_size,100), guide = F) +
  ggtitle(paste0(c," in each ",a)) +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0)) +
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18))


ggplot(LCtest, aes_string(x=b)) +
  geom_density() +
  theme_bw() +
  scale_size(range = c(low_size,100), guide = F) +
  ggtitle(paste0(c," in each ",a)) +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0)) +
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18))


as.Date("20100115", "%Y%m%d")
as.Date("jan-2010", format = "%d%b-%Y")
x <- c("jan-1960", "jan-1960", "mar-1960", "jul-1960")
z <- as.Date(x, "%b-%Y")
a = "Home_Ownership"
b = "DTI"
c = "Loan_Amount_in_mm"
d = "Defaults"

(plot_data = full_summup(LCtest, a)[,c(a, b, c, d)])
(low_size = min(plot_data[, d])/max(plot_data[, d])*100)
(x_lim = c(-0.25,1.25)*max(plot_data[, b]))
(y_lim = c(-0.25,1.25)*max(plot_data[, c]))

ggplot(plot_data, aes_string(x=b, y=c, size=d, color=a)) +
  geom_point(alpha = 0.5, guide = "") +
  theme_bw() +
  scale_size(range = c(low_size,100), guide = F) +
  ggtitle(paste0(a,": ",b," vs. ",c," with size representing ",d)) +
  theme(plot.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18, hjust=0)) +
  theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=18)) +
  coord_cartesian(xlim = x_lim, ylim = y_lim)


full_summup = function(x, y){
  group_by_(x, y) %>% summarize(
    LC_score           = round(mean(LC_score),1),
    FICO_score         = round(mean(fico_range_high),1),
    Avg_Loan_Amount    = round(mean(loan_amnt),1),
    Loan_Amount_in_mm  = round(sum(loan_amnt)/1000000,1),
    Term               = round(mean(terms),1),
    Interest           = round(mean(rate),1),
    Employment_Length  = round(mean(emp),1),
    Annual_Income      = round(mean(annual_inc),1),
    DTI                = round(mean(dti),1),
    Delinquency_2yrs   = round(mean(delinq_2yrs),1),
    Credit_Age         = round(mean(credit_ym),1),
    Inquieries_6mths   = round(mean(inq_last_6mths),1),
    Number_of_Accounts = round(mean(open_acc),1),
    Public_Records     = round(mean(pub_rec),1),
    Revolving_Balance  = round(mean(revol_bal),1),
    Revolving_Utilized = round(mean(revol_util_new),1),
    Defaults           = round(sum(loan_status_new == "Charged Off") / n() * 100, 2),
    Net_Expected_Loss  = round(sum((1 - total_rec_prncp / funded_amnt) * 100) / n(), 2)
  )
}


plottest = function(x, a, b, c, d="home"){
  temp = group_by_(x, d) %>% summarize(
    LC_score           = round(mean(LC_score),1),
    LC_sub_grade       = sub_grade_vec[mean(LC_score)],
    FICO_score         = round(mean(fico_range_high),1),
    Loan_Amount        = round(mean(loan_amnt),1),
    Term               = round(mean(terms),1),
    Interest           = round(mean(rate),1),
    Employment_Length  = round(mean(emp),1),
    Annual_Income      = round(mean(annual_inc),1),
    DTI                = round(mean(dti),1),
    Delinquency_2yrs   = round(mean(delinq_2yrs),1),
    Credit_Age         = round(mean(credit_ym),1),
    Inquieries_6mths   = round(mean(inq_last_6mths),1),
    Number_of_Accounts = round(mean(open_acc),1),
    Public_Records     = round(mean(pub_rec),1),
    Revolving_Balance  = round(mean(revol_bal),1),
    Revolving_Utilized = round(mean(revol_util_new),1),
    Defaults           = round(sum(loan_status_new == "Charged Off") / n() * 100, 2),
    Net_Expected_Loss  = round(sum((1 - total_rec_prncp / funded_amnt) * 100) / n(), 2)
  )
  return(temp[, c(a, b, c)])
}


(plottest(LCtest, "DTI", "Defaults", "Loan_Amount"))

names(LCtest)

group_by(LCtest, home) %>% summarize(total_issued = round(sum(loan_amnt/1e6),1), n())
plot_data2(LCtest, home)
plot_data(LCtest, home)



testDF <- data.frame(v1 = c(1,3,5,7,8,3,5,NA,4,5,7,9),
                     v2 = c(11,33,55,77,88,33,55,NA,44,55,77,99) )
by1 <- c("red", "blue", 1,  2,  NA, "big",  1,  2,  "red", 1,  NA, 12)
by2 <- c("wet", "dry",  99, 95, NA, "damp", 95, 99, "red", 99, NA, NA)
aggregate(x = testDF, by = list(by1, by2), FUN = "mean")
         

sumAmnt(LCtest, home) %>% merge(sumPerSatus(LCtest, home)) %>%
  plot_ly(x = n, 
          y = charged, 
          size = total_issued,
          text = paste(home, "<br>", "Total Issued: ", prettyNum(total_issued, big.mark = ",")),
          mode = "markers", 
          marker = list(color = net_EL,
                        colorscale = list(c(0, "rgb(255, 255, 255)"), list(1, "rgb(65, 50, 103)")),
                        colorbar = list(title = "Net Expected Loss"),
                        cauto = F,
                        cmin = 5,
                        cmax = 13,
                        opacity = 1,
                        line = list(size = 2))
  )%>%
  layout(xaxis = list(title = toupper("Number of issued loans")),
         yaxis = list(title = toupper("Default rates"), range = c(-2, 25)),
         title = toupper('Loan Issued grouped by home ownership<br>(Hover for breakdown)'))



a = list("A","C")
"B" %in% a
?list.files
summary(LCtest)
names(LC)
(unique(LC$revol_util))
unique(LC$purpose_new)
max(unique(LC$annual_inc))
unique(LC$home)
unique(LC$term)
median(as.numeric(gsub("%", "", sort(unique(LC$revol_util)))))
as.numeric(gsub(" years*","",unique(LC$emp_length)))
LCtest
a = list("A", "B", "C", "D")
nrow(filter(LCtest, grade %in% a))
nrow(LCtest)
a[2]
as.numeric(unique(LCtest$fico_range_high))
unique(LC$pymnt_plan)

filter(LC, pymnt_plan == "y")
t(filter(LC, id == 7295409))
names(LCtest)
min(LC$issue_ym)

filter(LC, loan_status == "Charged Off")
t(filter(LC, id == 1069559))

LC = mutate(LC, invested = 0)
LC = mutate(LC, test = installment * as.numeric(gsub(" months*","",term)) / loan_amnt)
max(LC$test)

filter(LC, test > 1.8)
t(filter(LC, id == 53009859))
LC = select(LC,-test)

unique(LC$last_pymnt_ym)
filter(LC, is.na(last_pymnt_ym), initial_list_status == 'w')
t(filter(LC, id == 8095448))

?is.numeric



LCtest = mutate(LCtest, invested = 0, pymnt = 0, received = 0)
LCreduced = LCtest

t = 201001
range = sort(unique(LC$issue_ym))
range = sort(unique(pmax(LC$issue_ym,t)))
to_invest = 100000
portfolio = c()
for (t in range) {
  if(!is.null(portfolio)) { 
    portfolio = mutate(portfolio, pymnt = invested / loan_amnt * 
                                          ifelse(last_pymnt_ym == t, last_pymnt_amnt + recoveries,
                                          ifelse(last_pymnt_ym  > t, installment, 0)))
    portfolio = mutate(portfolio, received = received + pymnt)
    to_invest = to_invest + 0 * sum(portfolio$pymnt)
  }
  
  temp = filter(LCreduced, issue_ym == t)
  investable = sum(temp$loan_amnt)
  if(investable < to_invest) {
    temp = mutate(temp, invested = loan_amnt)
    to_invest = to_invest - investable
  } else {
    temp = mutate(temp, invested = loan_amnt * to_invest / investable)
    to_invest = 0
  }
  portfolio = rbind(portfolio, filter(temp, invested != 0))
}
group_by(portfolio, loan_status_new) %>% summarize(total = sum(n))
sum(portfolio$invested)
sum(portfolio$received)
filter(portfolio, loan_status_new == "Late (31-120 days)")
t(filter(portfolio, id ==474632))
sum(portfolio$pymnt)
length(portfolio$terms)
(a = sum((portfolio$terms * portfolio$invested))/sum(portfolio$invested))
(sum(portfolio$pymnt)*12-100000/a*12)/sum(portfolio$invested)

portfolio


