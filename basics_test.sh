#!/bin/bash

test -e ssshtest || wget -q https://raw.githubusercontent.com/ryanlayer/ssshtest/master/ssshtest
. ssshtest

echo -e "\n\033[31m[Test] Style test \033[0m\n"
run Style_test pycodestyle style.py
assert_no_stdout

run Style_test pycodestyle get_column_stats.py
assert_no_stdout

echo -e "\nPreparing random data for test set 1 ..."
(for i in `seq 1 100`; do 
    echo -e "$RANDOM\t$RANDOM\t$RANDOM\t$RANDOM\t$RANDOM";
done )> data.txt

echo -e "\n\033[31m[Test] Integration TestSet1 \033[0m\n"
run Test_Bad_file_name python get_column_stats.py --file_name=bad_file_name.txt --col_num=2
assert_in_stdout 'FileNotFoundError:'
assert_exit_code 1

run Test_Neg_col_num python get_column_stats.py --file_name=data.txt --col_num=-1
assert_in_stderr 'IndexError:'
assert_stderr

run Test_col_num_overflow python get_column_stats.py --file_name=data.txt --col_num=1000
assert_in_stdout 'IndexError:'
assert_exit_code 2

run Test_Good_testcase python get_column_stats.py --file_name=data.txt --col_num=3
assert_exit_code 0


echo -e "\nPreparing consist data for test set 2 ..."
V=1
(for i in `seq 1 100`; do 
    echo -e "$V\t$V\t$V\t$V\t$V";
done )> data.txt

echo -e "\n\033[31m[Test] Integration TestSet2 \033[0m\n"
run Test_Bad_file_name python get_column_stats.py --file_name=bad_file_name.txt --col_num=2
assert_in_stdout 'FileNotFoundError:'
assert_exit_code 1

run Test_Neg_col_num python get_column_stats.py --file_name=data.txt --col_num=-1
assert_in_stderr 'IndexError:'
assert_stderr

run Test_col_num_overflow python get_column_stats.py --file_name=data.txt --col_num=1000
assert_in_stdout 'IndexError:'
assert_exit_code 2

run Test_Good_testcase python get_column_stats.py --file_name=data.txt --col_num=3
assert_exit_code 0
