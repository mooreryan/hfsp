#!/bin/bash

if [[ $# -ne 5 ]]; then
    >&2 echo "usage: run_mmseqs.sh <queries> <targets> <output> <tmpdir> <threads>"
    exit 1
fi

QUERIES="${1}"
TARGETS="${2}"
OUTPUT="${3}"
TMPDIR="${4}"
THREADS="${5}"

CMD="mmseqs easy-search \
  ${QUERIES} \
  ${TARGETS} \
  ${OUTPUT} \
  ${TMPDIR} \
  --threads ${THREADS} \
  --alignment-mode 3 \
  --num-iterations 3 \
  --e-profile 1e-10 \
  -e 1e-3 \
  -s 5.6 \
  --format-output query,target,fident,bits,cigar
"

time $CMD
echo $CMD
