#!/bin/bash

GEM5_DIR=~/cs6304/caches/gem5
BENCHMARK_DIR=~/cs6304/caches/benchmarks/Project1_SPEC
OUT_DIR=~/cs6304/caches/out/
SCRIPT_DIR=~/cs6304/caches/scripts

# $1 - L1D Size
# $2 - L1I Size
# $3 - L2 Size
# $4 - Cacheline
# $5 - L1D Associativity
# $6 - L1I Associativity
# $7 - L2 Associativity
# $8 - Run on 401.bzip2
# $9 - Run on 429.mcf

run() {
	echo "/*** Running Simulation $1 $2 $3 $4 $5 $6 $7 ***/"

	#Modify parameters
	if [ $8 = "1" ]; then
		rm $BENCHMARK_DIR/401.bzip2/runGem5.sh
		cp $SCRIPT_DIR/runGem5.sh.ori.401 $BENCHMARK_DIR/401.bzip2/runGem5.sh
		sed -i "s/L1D_SIZE/$1/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/L1I_SIZE/$2/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/L2_SIZE/$3/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/CACHELINE/$4/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/L1D_ASSOC/$5/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/L1I_ASSOC/$6/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
		sed -i "s/L2_ASSOC/$7/" "$BENCHMARK_DIR/401.bzip2/runGem5.sh"
	fi
	
	if [ $9 = "1" ]; then
		rm $BENCHMARK_DIR/429.mcf/runGem5.sh
		cp $SCRIPT_DIR/runGem5.sh.ori.429 $BENCHMARK_DIR/429.mcf/runGem5.sh
		sed -i "s/L1D_SIZE/$1/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/L1I_SIZE/$2/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/L2_SIZE/$3/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/CACHELINE/$4/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/L1D_ASSOC/$5/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/L1I_ASSOC/$6/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
		sed -i "s/L2_ASSOC/$7/" "$BENCHMARK_DIR/429.mcf/runGem5.sh"
	fi

	#Run benchmark
	if [ $8 = "1" ]; then
		cd $BENCHMARK_DIR/401.bzip2/
		echo -n "Running 401.bzip2 benchmark..."
		bash runGem5.sh
		echo "done"
	fi
	
	if [ $9 = "1" ]; then
		cd $BENCHMARK_DIR/429.mcf/
		echo -n "Running 429.mcf benchmark..."
		bash runGem5.sh
		echo "done"
	fi

	#Backup results
	echo -n "Backing up output files..."
	mkdir -p $OUT_DIR/$1_$2_$3_$4_$5_$6_$7
	if [ $8 = "1" ]; then
		cp $BENCHMARK_DIR/401.bzip2/m5out/stats.txt $OUT_DIR/$1_$2_$3_$4_$5_$6_$7/401_stats.txt
	fi
	if [ $9 = "1" ]; then
		cp $BENCHMARK_DIR/429.mcf/m5out/stats.txt $OUT_DIR/$1_$2_$3_$4_$5_$6_$7/429_stats.txt
	fi
	echo "done"
	
	echo "/*** Simulation $1 $2 $3 $4 $5 $6 $7 done ***/"
}

run 32 32 4 512 2 2 1 0 1
run 32 32 1 512 2 2 1 1 0

