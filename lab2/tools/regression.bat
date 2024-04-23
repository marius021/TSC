@REM call C:\Users\Zbook\Desktop\TSC\TSC\lab2\tools\run_test.bat 10 10 0 0 rezultat_1 Test_Simulare c 
@REM call C:\Users\Zbook\Desktop\TSC\TSC\lab2\tools\run_test.bat 20 20 1 1 rezultat_1 Test_Simulare c 

if exist "C:\Users\Zbook\Desktop\TSC\TSC\lab2\reports\regression_transcript\regression_status.txt" (
    del "C:\Users\Zbook\Desktop\TSC\TSC\lab2\reports\regression_transcript\regression_status.txt"
    echo Fișierul final_report a fost șters.
) else (
    echo Fișierul final_report nu există.
)

call ./run_test.bat 50 32 0 0  case1_c 107257 gui
call ./run_test.bat 50 32 0 0  case2_c 262444 gui
call ./run_test.bat 50 32 0 1  case3_c 132312 gui
call ./run_test.bat 50 32 0 2  case4_c 453463 gui
call ./run_test.bat 50 32 1 0  case5_c 123124 gui
@REM call ./run_test.bat 50 32 1 1  case6_c 754356 c
@REM call ./run_test.bat 50 32 1 2  case7_c 182246 c
@REM call ./run_test.bat 50 32 2 0  case8_c 234526 c
@REM call ./run_test.bat 50 32 2 1  case9_c 234526 c
@REM call ./run_test.bat 50 32 2 2 case_10  508854 c 
@REM call ./run_test.bat 50 32 2 2 case_11  832176 c 
@REM call ./run_test.bat 50 32 2 2 case_12  612636 c 
@REM call ./run_test.bat 50 32 2 2 case_13  494519 c 
@REM call ./run_test.bat 50 32 2 2 case_14  109316 c 
@REM call ./run_test.bat 50 32 2 2 case_15  615062 c 
@REM call ./run_test.bat 50 32 2 2 case_16  513337 c 
@REM call ./run_test.bat 50 32 2 2 case_17  424195 c 
@REM call ./run_test.bat 50 32 2 2 case_18  449473 c 
@REM call ./run_test.bat 50 32 2 2 case_19  140754 c 
@REM call ./run_test.bat 50 32 2 2 case_20  418687 c 
@REM call ./run_test.bat 50 32 2 2 case_21  845992 c 
@REM call ./run_test.bat 50 32 2 2 case_22  433771 c 
@REM call ./run_test.bat 50 32 2 2 case_23  132456 c 
@REM call ./run_test.bat 50 32 2 2 case_24  269034 c 
@REM call ./run_test.bat 50 32 2 2 case_25  740223 c 
@REM call ./run_test.bat 50 32 2 2 case_26  698256 c 
@REM call ./run_test.bat 50 32 2 2 case_27  176720 c 
@REM call ./run_test.bat 50 32 2 2 case_28  498601 c 
@REM call ./run_test.bat 50 32 2 2 case_29  804262 c 
@REM call ./run_test.bat 50 32 2 2 case_30  839768 c 
@REM call ./run_test.bat 50 32 2 2 case_31  803173 c 
@REM call ./run_test.bat 50 32 2 2 case_32  824614 c 
@REM call ./run_test.bat 50 32 2 2 case_33  536807 c 
@REM call ./run_test.bat 50 32 2 2 case_34  985823 c 
@REM call ./run_test.bat 50 32 2 2 case_35  235405 c 
@REM call ./run_test.bat 50 32 2 2 case_36  321848 c 
@REM call ./run_test.bat 50 32 2 2 case_37  532760 c 
@REM call ./run_test.bat 50 32 2 2 case_38  926965 c 
@REM call ./run_test.bat 50 32 2 2 case_39  296999 c 
@REM call ./run_test.bat 50 32 2 2 case_40  993621 c 
@REM call ./run_test.bat 50 32 2 2 case_41  220521 c 
@REM call ./run_test.bat 50 32 2 2 case_42  492528 c 
@REM call ./run_test.bat 50 32 2 2 case_43  984131 c 
@REM call ./run_test.bat 50 32 2 2 case_44  846079 c 
@REM call ./run_test.bat 50 32 2 2 case_45  947571 c 
@REM call ./run_test.bat 50 32 2 2 case_46  412215 c 
@REM call ./run_test.bat 50 32 2 2 case_47  113487 c 
@REM call ./run_test.bat 50 32 2 2 case_48  147526 c 
@REM call ./run_test.bat 50 32 2 2 case_49  969764 c 
@REM call ./run_test.bat 50 32 2 2 case_50  567188 c 


