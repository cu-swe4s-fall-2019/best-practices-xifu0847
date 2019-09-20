import sys
import math
import argparse


def getargs():
    '''
    Get argument setting from command line input
    This function specify the description and manual page of each argument.
    '''
    parser = argparse.ArgumentParser(
        description='Read filename and column number')
    parser.add_argument('--file_name',
                        type=str, default='',
                        help='The name of file to read')
    parser.add_argument('--col_num',
                        type=int,
                        default=0,
                        help='The column number you want to calculate')
    args = parser.parse_args()
    return args


def calculate_mean(V):
    '''
    if len(V) == 0:
        raise ZeroDivisionError('ZeroDivisionError: V has len 0')
    '''
    mean = None
    try:
        mean = sum(V) / len(V)
    except ZeroDivisionError as error:
        print('ZeroDivisionError:{}'.format(error))
        raise ZeroDivisionError('ZeroDivisionError: V has len 0')
    return mean


def calculate_stdev(V):
    mean = calculate_mean(V)
    stdev = None
    try:
        stdev = math.sqrt(sum([(mean-x)**2 for x in V]) / len(V))
    except ZeroDivisionError as error:
        print('ZeroDivisionError:{}'.format(error))
        raise ZeroDivisionError('ZeroDivisionError: V has len 0')
    return stdev


if __name__ == "__main__":
    # get argument parser config
    args = getargs()
    if args.col_num < 0:
        raise IndexError('IndexError: Negative column number')

    # try to read the file, define exception and exit code
    try:
        file = open(args.file_name, 'r')
    except FileNotFoundError as error:
        print('FileNotFoundError: {}'.format(error))
        print('exit with error code 1')
        sys.exit(1)

    V = []
    mean = None
    stdev = None

    # traverse the file line by line, stored the num in
    # col_num into a list V
    for line in file:
        A = [int(x) for x in line.split()]
        # A = {1,2,3,4} A[100] A[0] A[1] A[100] index out of boundary
        try:
            V.append(A[args.col_num])
        except IndexError as error:
            print('IndexError: {}'.format(error))
            print('exit with error code 2')
            sys.exit(2)

    # calculate result
    mean = sum(V) / len(V)
    stdev = math.sqrt(sum([(mean-x)**2 for x in V]) / len(V))

    # print result
    print('mean:', mean)
    print('stdev:', stdev)
