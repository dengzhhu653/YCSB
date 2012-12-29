kinit ec2-user
# HDFS:
~/hadoop-runtime/bin/hadoop  --config conf  fs  -ls /

#running a MR job:
~/mr1/bin/hadoop --config /home/ec2-user/YCSB/conf jar ~/mr1/build/hadoop-examples-mr1-2.1.0.tm6.jar  pi 5 5

#hbase shell:
export HBASE_CONF_DIR=/home/ec2-user/YCSB/conf
~/hbase/bin/hbase shell

#as hbase admin, in hbase shell:
## create table 'usertable' with column family 'ycsb':
create 'usertable','ycsb'
## allow full access for ec2-user:
put '_acl_','usertable','info:ec2-user','RWXCA'

# link your actual hbase conf to where YCSB will look for it:
mv hbase/src/main/conf hbase/src/main/conf-tmp
ln -s `pwd`/conf hbase/src/main

# back on client (ec2-user):
bin/ycsb load hbase -p columnfamily=ycsb  -P workloads/workloada
bin/ycsb run  hbase -p columnfamily=ycsb  -P workloads/workloada


