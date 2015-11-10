library(shiny)
setwd("/Users/jfdarre/Documents/NYCDS")
runApp("Project2")

load("Project2/data/LCtest.RData")  
my_data = LCtest
to_invest = 200000
re_invest = 1
range = sort(unique(LC$issue_ym))
data = filter(LCtest, issue_ym == t)
max_amount = 2000
buy(data, to_invest, max_amount)

portfolio = invest(LCtest, 100000, as.Date("2011-01-15"), 100, 2000, 0)
print(portfolio$portfolio_short, n=100)
(data = portfolio$summary)

plot_portfolio(data)
investment_summup(portfolio$portfolio)
transpose(investment_summup(portfolio$portfolio))

a = "Home_Ownership"
b = "DTI"
c = "Loan_Amount_in_mm"
d = "Defaults"
full_summup(LCtest, a)
bub_plot(LCtest, a, b, c, d)
plot_amounts(LCtest, a)

setwd("/Users/jfdarre/Documents/NYCDS/Project2")
files <- list.files(outputDir, full.names = F)
