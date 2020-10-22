# By: Alan Lampa

FROM openjdk:8

# Sets language to UTF8
ENV LANG en_US.UTF-8

RUN which java
RUN javac -version

# Installing packages
RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  wget \
  unzip \
  vim \
  sudo \
  && apt-get clean
  
# install Node 12, also installs NPM  
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Install Android SDK tools
RUN mkdir -p /usr/local/android-sdk
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools-linux-4333796.zip
RUN mv tools /usr/local/android-sdk
RUN rm sdk-tools-linux-4333796.zip

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools/bin

RUN echo y | sdkmanager "cmake;3.6.4111459" "platform-tools" "platforms;android-28" "build-tools;28.0.3" "ndk-bundle"

# Environment variables
ENV ANDROID_HOME /usr/local/android-sdk
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV ANDROID_NDK_HOME /usr/local/android-sdk/ndk-bundle
ENV JENKINS_HOME $HOME
ENV PATH ${INFER_HOME}/bin:${PATH}
ENV PATH $PATH:$ANDROID_SDK_HOME/tools
ENV PATH $PATH:$ANDROID_SDK_HOME/platform-tools
ENV PATH $PATH:$ANDROID_SDK_HOME/build-tools/23.0.2
ENV PATH $PATH:$ANDROID_SDK_HOME/build-tools/24.0.0
ENV PATH $PATH:$ANDROID_NDK_HOME

# install gradle
RUN wget -q https://services.gradle.org/distributions/gradle-6.7-bin.zip \
    && unzip gradle-6.7-bin.zip -d /opt \
    && rm gradle-6.7-bin.zip

ENV GRADLE_HOME /opt/gradle-6.7
ENV PATH $PATH:/opt/gradle-6.7/bin

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms4096m -Xmx4096m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

# Install cordova cli
RUN npm install -g cordova

# Cleaning
RUN apt-get clean

# Create local properties file
RUN echo "sdk.dir=$ANDROID_HOME" > local.properties
RUN echo "ndk.dir=$ANDROID_NDK_HOME" >> local.properties
