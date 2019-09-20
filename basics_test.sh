#!/bin/bash

test -e ssshtest || wget -q https://raw.githubusercontent.com/ryanlayer/ssshtest/master/ssshtest
. ssshtest

# test part 1: Style test
echo -e "\n\033[31m[Test] Style test \033[0m\n"
run Style_test_style pycodestyle style.py
assert_no_stdout

run Style_test_get_column_stats pycodestyle get_column_stats.py
assert_no_stdout

run Style_test_basics_test pycodestyle basics_test.py
assert_no_stdout

# Prepraing test set 1
echo -e "\nPreparing random data for test set 1 ..."
(for i in `seq 1 100`; do 
    echo -e "$RANDOM\t$RANDOM\t$RANDOM\t$RANDOM\t$RANDOM";
done )> data.txt

# test part 2: Test Set 1
echo -e "\n\033[31m[Test] TestSet1 \033[0m\n"
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

# Preparing test set 2
echo -e "\nPreparing consist data for test set 2 ..."
V=1
(for i in `seq 1 100`; do 
    echo -e "$V\t$V\t$V\t$V\t$V";
done )> data.txt

echo -e "\n\033[31m[Test] TestSet2 \033[0m\n"
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

# Preparing Integration Test Set
echo -e "\nPreparing consist data for Integration test ..."
seed=$RANDOM
col=`expr $seed % 100`
(for i in `seq 1 $col`;
do
    echo -e "$RANDOM";
done )> data.txt

# test part 4: Test Set 3: Integration Test
# Calculate Mean and Stdev
# But I don't think it's good to calculate stdev in shell script since shell script is
# not good for complicated math calculation and its precision is limited. Instead, an
# integration test can be done in python.
echo -e "\n\033[31m[Test] Integration Test \033[0m\n"
mean=`awk '{sum+=$1} END {print int(sum/NR)}' data.txt`
stdev=`awk '{sum+=$1; sumsq+=$1*$1} END {print int(sqrt(sumsq/NR - (sum/NR)^2))}' data.txt`

run Test_Integration_testcase python get_column_stats.py --file_name=data.txt --col_num=0
assert_exit_code 0
assert_in_stdout $mean
assert_in_stdout $stdev

