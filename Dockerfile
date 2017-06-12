FROM alpine:latest
MAINTAINER Lennard Cornelis "lennardcornelis@gmail.com


RUN apk add --update curl git unzip python2 py-pip tar
#RUN apk add --update curl git unzip python2 py-pip && pip install -U py4

ENV PYTHONHASHSEED=0 \
    PYTHONIOENCODING=UTF-8 \
    HADOOP_VERSION=2.7.3 \
    HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION \
    HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
    PATH=$PATH:$HADOOP_HOME/bin \
    SPARK_VERSION=2.1.1 \
    SPARK_PACKAGE=spark-$(SPARK_VERSION)-bin-hadoop2.7 \
    SPARK_HOME=/usr/spark-$(SPARK_VERSION) \
    PYSPARK_PYTHON=python2
    RUN curl -sL --retry 3 \
    "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | gunzip \
    | tar -x -C /usr/ \
    && rm -rf $HADOOP_HOME/share/doc

    ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*" \
    PATH=$PATH:$SPARK_HOME/bin
#   "https://d3kbcqa49mib13.cloudfront.net/$SPARK_PACKAGE.tgz" \
#    https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz
    RUN curl -sL --retry 3 \
    "https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz" \
    | gunzip \
    | tar -x -C /usr/ \
    && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
    && rm -rf $SPARK_HOME/examples $SPARK_HOME/ec2
 
    WORKDIR $SPARK_HOME
    CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
