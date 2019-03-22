#! /bin/sh

scanner=$(find . -name scanner)
if [ "$scanner" == "" ]; then
    echo '***********************************************************'
    echo '* Make sure your scanner program is in the same directory *'
    echo '* as the sample.input and sample-test.sh.                 *'
    echo '***********************************************************'
    exit -1
fi

./scanner < sample.input > your.output 2>&1
diff_result=$(diff sample.output your.output)
if [ "$diff_result" == "" ]; then
    echo '*******************************************************'
    echo '* Congratulation!                                     *'
    echo '* Both of your scanner and output format are correct. *'
    echo '*******************************************************'
else
    echo '*********************************************************'
    echo '* Oops! Your output is not correct.                     *'
    echo '* Please use "diff sample.output your.output" to check  *'
    echo '* the different between your output and sample output.  *'
    echo '*********************************************************'
fi
