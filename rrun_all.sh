#!/bin/bash

SRC="parMDS_optimized_commented.cpp"
EXE="parMDS.out"

echo "Compiling ${SRC} ..."

g++ -O3 -fopenmp -std=c++14 "${SRC}" -o "${EXE}"

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

echo "Compilation successful."
echo

INPUTS=(
"inputs/E-n101-k14.vrp"
"inputs/P-n101-k4.vrp"
"inputs/CMT5.vrp"
"inputs/Golden_19.vrp"
"inputs/Golden_20.vrp"
"inputs/Brussels2.vrp"
"inputs/X-n916-k207.vrp"
"inputs/X-n936-k151.vrp"
"inputs/X-n957-k87.vrp"
"inputs/X-n979-k58.vrp"
"inputs/X-n1001-k43.vrp"
)

THREADS=(1 2 4 8 16 24 32 48 64 72 80 96)

mkdir -p results

for instance in "${INPUTS[@]}"
do
    echo "=========================================="
    echo "Instance: ${instance}"
    echo "=========================================="

    base=$(basename "${instance}" .vrp)

    for t in "${THREADS[@]}"
    do
        echo "Running ${base} with ${t} threads"

        OUTFILE="results/${base}_T${t}.txt"
        TIMEFILE="results/${base}_T${t}.time"

        /usr/bin/time -f "Elapsed_Time=%e" \
        ./${EXE} "${instance}" -nthreads "${t}" -round 1 \
        > "${OUTFILE}" \
        2> "${TIMEFILE}"

        echo "Completed ${base} T=${t}"
    done

    echo
done

echo "=========================================="
echo "All experiments completed."
echo "=========================================="
