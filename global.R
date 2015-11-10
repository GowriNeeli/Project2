backcolor = "#4e5d6c"

outputDir = "data/responses"
submitDir = "data/submits"

file_list = list.files(outputDir, full.names = F)

sub_grade_vec = c("G5", "G4", "G3", "G2", "G1",
                  "F5", "F4", "F3", "F2", "F1",
                  "E5", "E4", "E3", "E2", "E1",
                  "D5", "D4", "D3", "D2", "D1",
                  "C5", "C4", "C3", "C2", "C1",
                  "B5", "B4", "B3", "B2", "B1",
                  "A5", "A4", "A3", "A2", "A1")
  
range = c(200706, 200707, 200708, 200709, 200710, 200711, 200712,
          200801, 200802, 200803, 200804, 200805, 200806, 200807,
          200808, 200809, 200810, 200811, 200812, 200901, 200902,
          200903, 200904, 200905, 200906, 200907, 200908, 200909,
          200910, 200911, 200912, 201001, 201002, 201003, 201004,
          201005, 201006, 201007, 201008, 201009, 201010, 201011,
          201012, 201101, 201102, 201103, 201104, 201105, 201106,
          201107, 201108, 201109, 201110, 201111, 201112, 201201,
          201202, 201203, 201204, 201205, 201206, 201207, 201208,
          201209, 201210, 201211, 201212, 201301, 201302, 201303,
          201304, 201305, 201306, 201307, 201308, 201309, 201310,
          201311, 201312, 201401, 201402, 201403, 201404, 201405,
          201406, 201407, 201408, 201409, 201410, 201411, 201412,
          201501, 201502, 201503, 201504, 201505, 201506)

continuous_var = c("LC_score",
                   "FICO_score",
                   "Defaults",
                   "Avg_Loan_Amount",
                   "Loan_Amount_in_mm",
                   "Term",
                   "Interest",
                   "Employment_Length",
                   "Annual_Income",
                   "DTI",
                   "Delinquency_2yrs",
                   "Credit_Age",
                   "Inquieries_6mths",
                   "Number_of_Accounts",
                   "Public_Records",
                   "Revolving_Balance",
                   "Revolving_Utilized")

discrete_var = c("LC_Grade",
                 "Home_Ownership",
                 "Purpose",
                 "Delinquencies_bucket",
                 "Inquiries_bucket",
                 "Public_Record_bucket",
                 "Annual_Income_qbucket",
                 "DTI_qbucket",
                 "Revol_Util_qbucket",
                 "Revol_Bal_qbucket",
                 "Total_Accounts_qbucket",
                 "Open_Accounts_qbucket",
                 "Credit_Age_qbucket")