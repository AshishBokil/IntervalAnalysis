#!/usr/bin/env bash


## DO NOT EDIT THIS FILE

set -e

if [ $# -ne 4 ]; then
    echo "Usage: run-analysis-one.sh  dirname mainclass tclass tmethod"
    exit 1
fi

DIRNAME=$1
MAINCLASS=$2
TARGETCLASS=$3
TARGETMETHOD=$4

# export CLASSPATH=.:pkgs/soot-4.3.0-20210915.120431-213-jar-with-dependencies.jar
# export CLASSPATH=.:pkgs/soot-4.3.0-with-deps.jar
source environ.sh

echo === running Analysis.java
echo === Interval ANALYSIS

# time java  -Xms800m -Xmx3g Analysis "./target" "AddNumFun" "AddNumFun" "expr"


## clean the output files
rm -f $DIRNAME/$TARGETCLASS.$TARGETMETHOD.output.txt
rm -f $DIRNAME/$TARGETCLASS.$TARGETMETHOD.fulloutput.txt

echo  "=== Running" Analysis "$DIRNAME" "$MAINCLASS"  "$TARGETCLASS"  "$TARGETMETHOD"

time \
    java -Xms800m -Xmx3g Analysis "$DIRNAME"  "$MAINCLASS"  "$TARGETCLASS"  "$TARGETMETHOD"


dot -Tpng -o cfg.png cfg.dot


errstatus=0
function checkfile() {
    f=$1
    echo === checking for file: $f
    if [ ! -r $f ]; then
        echo "    **** WARNING:  file missing:" $f
        errstatus=-1
    fi
}

checkfile $DIRNAME/$TARGETCLASS.$TARGETMETHOD.output.txt
checkfile $DIRNAME/$TARGETCLASS.$TARGETMETHOD.fulloutput.txt

# if any errors, then exit with errorcode
[ $errstatus -eq 0 ] || exit 1

