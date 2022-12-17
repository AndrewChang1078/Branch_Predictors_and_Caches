#!/bin/bash

GEM5_DIR=~/cs6304/branch_predict/gem5
BRANCH_PREDICTOR_DIR=$GEM5_DIR/src/cpu/pred
BASE_SIMPLE_CPU_DIR=$GEM5_DIR/src/cpu/simple
BENCHMARK_DIR=~/cs6304/branch_predict/Project1_SPEC
OUT_DIR=~/cs6304/branch_predict/out/TournamentBP
SCRIPT_DIR=~/cs6304/branch_predict/TournamentBP

# $1 - BTB_ENTRIES_NUM
# $2 - LOCAL_PREDICTOR_SIZE
# $3 - GLOBAL_PREDICTOR_SIZE
# $4 - CHOICE_PREDICTOR_SIZE

run() {
	echo "/*** Running TournamentBP $1 $2 $3 $4 ***/"

	#Modify predictor type
	echo -n "Modifying predictor type..."
	rm $BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py
	cp $SCRIPT_DIR/BaseSimpleCPU.py.ori $BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py
	sed -i "s/NULL/TournamentBP()/" "$BASE_SIMPLE_CPU_DIR/BaseSimpleCPU.py"
	echo "done"
	
	#Modify parameters
	echo -n "Modifying branch prediction params..."
	rm $BRANCH_PREDICTOR_DIR/BranchPredictor.py
	cp $SCRIPT_DIR/BranchPredictor.py.ori $BRANCH_PREDICTOR_DIR/BranchPredictor.py
	sed -i "s/BTB_ENTRIES_NUM/$1/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
	sed -i "s/LOCAL_PREDICTOR_SIZE/$2/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
	sed -i "s/GLOBAL_PREDICTOR_SIZE/$3/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
	sed -i "s/CHOICE_PREDICTOR_SIZE/$4/" "$BRANCH_PREDICTOR_DIR/BranchPredictor.py"
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
	mkdir -p $OUT_DIR/$1_$2_$3_$4
	cp $BENCHMARK_DIR/401.bzip2/m5out/stats.txt $OUT_DIR/$1_$2_$3_$4/401_stats.txt
	cp $BENCHMARK_DIR/429.mcf/m5out/stats.txt $OUT_DIR/$1_$2_$3_$4/429_stats.txt
	echo "done"
	
	echo "/*** TournamentBP $1 $2 $3 $4 is done ***/"
}

#run 2048 1024 4096 4096

#run 1024 1024 4096 4096
#run 4096 1024 4096 4096

#run 2048 512 4096 4096
#run 2048 2048 4096 4096

#run 2048 1024 2048 4096
#run 2048 1024 8192 4096

#run 2048 1024 4096 2048
#run 2048 1024 4096 8192

run 8192 4096 4096 4096
