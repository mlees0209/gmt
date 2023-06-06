#!/usr/bin/env bash
# Test gmt convert -Z option to take a single-segment dataset transpose
# but this time use binary data with huge dimensions; rows = 1000 cols = 5
# so transposed file will have 1000 columns and exceed ASCII record output limits.
# We then check that the original input equals the twice transposed dataset.

N=1000	# Number of rows in binary input file
# Create a dataset using normally distributed numbers around 0 with stddev = 10
gmt math -T1/$N/1 -N5/0 -bo5f 0 10 NRAND = orig.bin
# Transpose the original data file using binary mode
gmt convert orig.bin -Z -bi5f -bo${N}f > tr.bin
# Transpose it back to get the original dimensions and layout
gmt convert tr.bin -Z -bi${N}f -bo5f > same.bin
# Look for differences between results and truth by subtracting the two data sets
# then do a cumulative sum and see if it is zero
gmt math -bi5f -Sl orig.bin same.bin SUB SUM = result.txt
# Set the expected answer record:
echo "${N}	0	0	0	0" > answer.txt
diff result.txt answer.txt --strip-trailing-cr > fail
