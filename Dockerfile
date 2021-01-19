FROM ubuntu:18.04  
#python:3.6

# set the working directory
RUN ["mkdir", "app"]
WORKDIR "app"

#install build dependencies
RUN apt-get update && apt-get install -y git 
RUN apt-get install -y libmysqlclient-dev mysql-client libsm6 libxext6 libxrender-dev
#RUN apt-get install -y python-pip
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y curl libgl1-mesa-glx unzip vim

# install code dependencies
COPY "requirements.txt" .
RUN pip3 install scikit-build
RUN pip3 install cython
RUN pip3 install cmake
RUN pip3 install tensorflow-object-detection-api
RUN ["pip3", "install", "-r", "requirements.txt"]

RUN PROTOC_ZIP=protoc-3.7.1-linux-x86_64.zip && curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/$PROTOC_ZIP && unzip -o $PROTOC_ZIP -d /usr/local bin/protoc &&  unzip -o $PROTOC_ZIP -d /usr/local 'include/*' && rm -f $PROTOC_ZIP

RUN git clone https://github.com/tensorflow/models.git ;cd models ; git reset fe748d4a4a1576b57c279014ac0ceb47344399c4 --hard ; cd  ..
RUN protoc ./models/research/object_detection/protos/string_int_label_map.proto --python_out=.
RUN cp -R models/research/object_detection/ object_detection/

#COPY "BatchCreator.ipynb" .
#COPY codebuild-prediction.py /app/codebuild-prediction.py
#COPY codebuild-objectdetection.py /app/codebuild-objectdetection.py

