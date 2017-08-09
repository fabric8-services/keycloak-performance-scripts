#!/bin/bash

VEGETA_BIN_FILES_DIR=$1

echo "Generating reports for the vegeta files in $1"

FILES=${VEGETA_BIN_FILES_DIR}/*.bin
for f in $FILES
do
  echo "Processing $f file..."
  cat $f | vegeta report -reporter=plot > $f.html
done
