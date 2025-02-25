FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    adb \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Android SDK
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV PATH $ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Install Android SDK
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
    && cd $ANDROID_SDK_ROOT/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip commandlinetools-linux-11076708_latest.zip \
    && rm commandlinetools-linux-11076708_latest.zip \
    && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && mv cmdline-tools/* $ANDROID_SDK_ROOT/cmdline-tools/latest/

# Accept Android SDK licenses
RUN yes | sdkmanager --licenses
RUN sdkmanager "system-images;android-29;default;x86_64" "platforms;android-29" "emulator" "platform-tools"
RUN avdmanager create avd -n test_device -k "system-images;android-29;default;x86_64" -d pixel

WORKDIR /src/

# Expose the necessary ports for adb to communicate with the emulator
EXPOSE 5554 5555
