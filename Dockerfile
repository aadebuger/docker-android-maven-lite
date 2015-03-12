
#Dockerfile to build an image with the local version of golang.org/x/mobile.
#
#  > docker build -t mobile $GOPATH/src/golang.org/x/mobile
#  > docker run -it --rm -v $GOPATH/src:/src mobile

FROM  dockerfile/java:oracle-java7

# Install system-level dependencies.
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
	echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

# Install Ant.
RUN curl -L http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.2-bin.tar.gz | tar xz -C /usr/local
ENV ANT_HOME /usr/local/apache-ant-1.9.2


RUN curl -L   http://mirror.bit.edu.cn/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar xz -C /usr/local
#RUN  add-apt-repository ppa:natecarlson/maven3
#RUN apt-get update 
#RUN   apt-get -y install maven3

RUN  ln -s /usr/bin/mvn3 /usr/bin/mvn
# Install Android SDK.
#RUN curl -L http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz | tar xz -C /usr/local
RUN curl -L http://dl.google.com/android/android-sdk_r24.0.2-linux.tgz | tar xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter build-tools-19.1.0 && \
	echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter platform-tools && \
	echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-19

# Install Android NDK.
#RUN curl -L http://dl.google.com/android/ndk/android-ndk-r9d-linux-x86_64.tar.bz2 | tar xj -C /usr/local
#ENV NDK_ROOT /usr/local/android-ndk-r9d
#RUN $NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=android-9 --install-dir=$NDK_ROOT --system=linux-x86_64

# Install Gradle 2.1
# : android-gradle compatibility
#   http://tools.android.com/tech-docs/new-build-system/version-compatibility
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter build-tools-19.1.0 && \
echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter platform-tools && \
echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s  --filter android-19
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all  -s --filter build-tools-19.1.0 
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter platform-tools 
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-16
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-21
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter build-tools-21.1.2 
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-19
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter build-tools-20.0.0 
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter build-tools-21.1.1 
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter  extra
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-20
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all -s --filter android-10
# Update PATH for the above.
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools
#ENV PATH $PATH:$NDK_ROOT
#kENV PATH $PATH:$ANT_HOME/bin
#ENV PATH $PATH:$GRADLE_HOME/bin
#run git clone https://github.com/simpligility/maven-android-sdk-deployer
run apt-get update
run apt-get install -y lib32stdc++6 lib32z1 lib32ncurses5 lib32bz2-1.0
#run cd /data/maven-android-sdk-deployer/extras/compatibility-v4 && /usr/local/apache-maven-3.2.5/bin/mvn clean install 
#run cd /data/maven-android-sdk-deployer/ && /usr/local/apache-maven-3.2.5/bin/mvn  install  -P 5.0 -rf :google-apis-21
#run cd /data/maven-android-sdk-deployer/extras && /usr/local/apache-maven-3.2.5/bin/mvn  clean install  
run wget http://dl-ssl.google.com/android/repository/android_m2repository_r11.zip
run unzip android_m2repository_r11.zip -d /usr/local/android-sdk-linux/extras/android
run wget http://dl-ssl.google.com/android/repository/google_m2repository_r15.zip
run unzip -o google_m2repository_r15.zip  -d /usr/local/android-sdk-linux/extras/android
