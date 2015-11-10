names(LCtest)
temp = filter(LCtest, grade == 'A')
print(arrange(unique(temp[,'last_pymnt_d']),last_pymnt_d), n=100)

nrow(filter(LCtest, last_pymnt_d == '')['loan_status_new'])
filter(temp, last_pymnt_d == '')['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())

unique(filter(temp, last_pymnt_d == 'Aug-2015')['loan_status_new'])



filter(temp, last_pymnt_d == 'Jun-2015')['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())
filter(temp, last_pymnt_d == 'Jul-2015')['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())
filter(temp, last_pymnt_d == 'Aug-2015')['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())
filter(temp, last_pymnt_d != 'Aug-2015')['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())
temp['loan_status_new'] %>% group_by(loan_status_new) %>% summarize(n())


unique(filter(temp, last_pymnt_d != 'Aug-2015', loan_status_new == 'Current')['last_pymnt_d'])
t(filter(LCtest, id == 2373127))

load("data/LC.RData")
t(filter(LC, id == 2373127))




filter(temp, last_pymnt_d == 'Aug-2014', loan_status_new == 'Current')








 [1] "id"                     "loan_amnt"              "funded_amnt"            "term"                  
 [5] "installment"            "grade"                  "sub_grade"              "home_ownership"        
 [9] "annual_inc"             "issue_d"                "purpose"                "dti"                   
[13] "delinq_2yrs"            "fico_range_high"        "inq_last_6mths"         "open_acc"              
[17] "pub_rec"                "revol_bal"              "total_acc"              "total_pymnt_inv"       
[21] "total_rec_prncp"        "recoveries"             "last_pymnt_d"           "last_pymnt_amnt"       
[25] "loan_status_new"        "issue_ym"               "last_pymnt_ym"          "FICO_buckets_Original" 
[29] "FICO_buckets_Last"      "FICO_bin_name_Original" "FICO_bin_name_Last"     "matured"               
[33] "terms"                  "LC_score"               "credit_ym"              "issue_bucket"          
[37] "Delinquencies_bucket"   "Inquiries_bucket"       "Public_Record_bucket"   "Annual_Income_qbucket" 
[41] "DTI_qbucket"            "revol"                  "Revol_Util_qbucket"     "Revol_Bal_qbucket"     
[45] "Total_Accounts_qbucket" "Open_Accounts_qbucket"  "Credit_Age_qbucket"     "Purpose"               
[49] "Home_Ownership"         "credit_y"               "inq"                    "rate"                  
[53] "emp"                    "income"                 "balance"                "delinq"                
[57] "accounts"               "records"                "revol_util_new"         "revol_util_maxed"      
[61] "LC_Grade"               "Status"  