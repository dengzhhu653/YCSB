#!/usr/bin/env bash

# run test on ec2 for hbase. -mingjie
set -x
dir=`dirname "$0"`
dir=`cd "$dir"; pwd`


HBASE_HOME=/usr/lib/hbase
. $HBASE_HOME/conf/hbase-env.sh
YCSB_HOME=/home/ec2-user/YCSB

now=`date +%Y%m%d-%H%M`
resultDir=${dir}/results/${now}

parameters=$@
echo "all parameters: ${parameters}" 

mkdir -p $resultDir

#load data
${JAVA_HOME}/bin/java -cp ${YCSB_HOME}/build/ycsb.jar:${HBASE_HOME}/lib/*:${HBASE_HOME}/*:$HBASE_HOME/conf/ \
        com.yahoo.ycsb.Client -load -db com.yahoo.ycsb.db.HBaseClient \
        -P ${YCSB_HOME}/workloads/workloada -p columnfamily=family -s \
        ${parameters} > ${resultDir}/load.txt
        
#sed '/^[]|READ|UPDATE|INSERT|SCAN|field|<]/d' ${resultDir}/load.txt > ${resultDir}/load.txt
        
# for each ycsb build-in workload files:
for workload in workloada workloadb workloadc workloadd workloade workloadf increment-workload; do
  workload_file="${YCSB_HOME}/workloads/${workload}"
  if [ -f $workload_file ]; then
    #echo "workload_file: " $workload_file
    ${JAVA_HOME}/bin/java -cp ${YCSB_HOME}/build/ycsb.jar:${HBASE_HOME}/lib/*:${HBASE_HOME}/*:$HBASE_HOME/conf/ \
        com.yahoo.ycsb.Client \
        -P ${workload_file} -p columnfamily=family -s \
        ${parameters} > ${resultDir}/${workload}.txt
    #sed  '/^[]|READ|UPDATE|INSERT|SCAN|field|<]/d' ${resultDir}/${workload}.txt > ${resultDir}/${workload}.dat
  fi
done
