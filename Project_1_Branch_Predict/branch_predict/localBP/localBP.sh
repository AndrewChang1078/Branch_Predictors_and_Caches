#!/bin/bash

GEM5_DIR=~/cs6304/branch_predict/gem5
BRANCH_PREDICTOR_DIR=$GEM5_DIR/src/cpu/pred
BASE_SIMPLE_CPU_DIR=$GEM5_DIR/src/cpu/simple
BENCHMARK_DIR=~/cs6304/branch_predict/Project1_SPEC
OUT_DIR=~/cs6304/branch_predict/out/localBP
SCRIPT_DIR=~/cs6304/branch_predict/localBP

# $1 - BTB_ENTRIES_NUM
# $2 - LOCAL_PREDICTOR_SIZE

run() {
	echo "/*** Running LocalBP $1 $2 ***/"

	#Modify predictor type
	echo -n "Modifying predictor type..."
	rm $BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py
	cp $SCRIPT_DIR/BaseSimpleCPU.py.ori $BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py
	sed -i "s/NULL/LocalBP()/" "$BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py"
	echo "done"
	
	#Modify parameters
	echo -n "Modifying branch prediction params..."
	rm $BRANCH_PREDICTOR_DIR/BranchPredictor.py
	cp $SCRIPT_DIR/BranchPredictor.py.ori $BRANCH_PREDICTOR_DIR/BranchPredictor.py
	sed -i "s/BTB_ENTRIES_NUM/$1/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
	sed -i "s/LOCAL_PREDICTOR_SIZE/$2/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
	echo "done"
	
	#Build the project
	cd $GEM5_DIR
	echo -n "Removing old build files..."
	rm -rf build/X86/
	echo "done"
	echo -n "Building project..."
	scons -s build/X86/gem5.opt -j5
	echo "done"
	
	#Run benchmark
	cd $BENCHMARK_DIR/401.bzip2/
	echo -n "Running 401.bzip2 benchmark..."
	bash runGem5.sh
	echo "done"
	cd $BENCHMARK_DIR/429.mcf/
	echo -n "Running 429.mcf benchmark..."
	bash runGem5.sh
	echo "done"

	#Backup results
	echo -n "Backing up output files..."
	mkdir -p $OUT_DIR/$1_$2
	cp $BENCHMARK_DIR/401.bzip2/m5out/stats.txt $OUT_DIR/$1_$2/401_stats.txt
	cp $BENCHMARK_DIR/429.mcf/m5out/stats.txt $OUT_DIR/$1_$2/429_stats.txt
	echo "done"
	
	echo "/*** LocalBP $1 $2 is done ***/"
}

#run 2048 1024

#run 4096 1024
#run 1024 1024

#run 2048 2048
#run 2048 512

run 4096 512
