#!/usr/bin/env bash

LOG_FILE="hadoop_mahout_install.log"

#get sun version of java for hadoop
sudo wget https://github.com/flexiondotorg/oab-java6/raw/0.2.8/oab-java.sh -O oab-java.sh
sudo chmod +x oab-java.sh
sudo ./oab-java.sh
sudo apt-get -y install --force-yes sun-java6-jre sun-java6-jdk sun-java6-plugin sun-java6-fonts
sudo apt-get -y install --force-yes python-setuptools python-dev python-pip 
sudo update-java-alternatives -s java-6-sun

#generate ssh keys
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

#disable ipv6
sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/sysctl.conf
sudo cp sysctl.conf /etc

#get cloudera versions of hadoop and mahout
cd /usr/local
sudo wget http://archive.cloudera.com/cdh/3/hadoop-0.20.2-cdh3u4.tar.gz
sudo tar xvfz hadoop-0.20.2-cdh3u4.tar.gz
sudo mv hadoop-0.20.2-cdh3u4 hadoop
sudo chown -R ubuntu hadoop
sudo wget http://archive.cloudera.com/cdh/3/mahout-0.5-cdh3u4.tar.gz 
sudo tar xvfz mahout-0.5-cdh3u4.tar.gz
sudo mv mahout-0.5-cdh3u4 mahout
sudo chown -R ubuntu mahout
sudo rm hadoop-0.20.2-cdh3u4.tar.gz 
sudo rm mahout-0.5-cdh3u4.tar.gz
sudo apt-get -y install --force-yes maven 

#set hadoop site settings
cd /home/ubuntu
sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/hadoop-env.sh
sudo cp hadoop-env.sh /usr/local/hadoop/conf

sudo mkdir -p /app/hadoop/tmp
sudo chown ubuntu /app/hadoop/tmp

sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/bash.bashrc
sudo cp bash.bashrc /etc

cd /home/ubuntu
sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/core-site.xml
sudo cp core-site.xml /usr/local/hadoop/conf
sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/mapred-site.xml
sudo cp mapred-site.xml /usr/local/hadoop/conf
sudo wget https://github.com/lotterblad/ubuntu-hadoop-install/hdfs-site.xml
sudo cp mapred-site.xml /usr/local/hadoop/conf
sudo /usr/local/hadoop/bin/hadoop namenode -format

#compile mahout using maven
cd /usr/local/mahout
mvn package
/usr/local/hadoop/bin/start-all.sh
