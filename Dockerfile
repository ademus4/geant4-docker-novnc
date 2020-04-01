FROM ubuntu:bionic
USER root
WORKDIR /work
ENV HOME /work

# some requirements
RUN apt-get update -y && \
    apt-get install -y cmake wget g++ libexpat1-dev

# get geant4 and untar
RUN wget -c http://cern.ch/geant4-data/releases/geant4.10.06.p01.tar.gz -O - | tar -xz

# build and install
RUN cd geant4.10.06.p01 && \
    mkdir build && \
    cd build && \
    cmake -DGEANT4_INSTALL_DATA=ON ../ && \
    make -j6 && \
    make install

# install requirements for novnc server
RUN apt-get install -y \
    fluxbox \
    novnc \
    x11vnc \
    xterm \
    xvfb \
    socat \
    supervisor \
    net-tools

# Allow incoming connections
EXPOSE 8080

# Setup demo environment variables
ENV DISPLAY=:0.0 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=720 \
    RUN_XTERM=yes \
    RUN_FLUXBOX=yes

# general environment variables
ADD environment.sh .bashrc


# run novnc server
COPY . /app
CMD ["/app/entrypoint.sh"]
