FROM ubuntu:20.04

# Avoid interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    cmake \
    git \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    libsamplerate0-dev \
    libfftw3-dev \
    libyaml-dev \
    libeigen3-dev \
    libboost-all-dev \
    swig \
    pkg-config \
    wget && \
    apt-get clean

RUN ln -s /usr/bin/python3 /usr/bin/python

# Build Essentia from source
WORKDIR /opt
WORKDIR /opt
RUN git clone https://github.com/MTG/essentia.git /opt/essentia && \
    ls -la /opt/essentia && \
    cd /opt/essentia && \
    mkdir build && cd build && \
    cmake .. -DBUILD_PYTHON_BINDINGS=ON -DPYTHON_EXECUTABLE=/usr/bin/python3 && \
    make -j4 && \
    make install && \
    ldconfig

# Set up app
WORKDIR /app
COPY ./app /app

RUN pip3 install --upgrade pip && \
    pip3 install streamlit

EXPOSE 10000

CMD ["streamlit", "run", "main.py", "--server.port=10000", "--server.address=0.0.0.0"]

# Set Python alias for compatibility
RUN ln -s /usr/bin/python3 /usr/bin/python

# Build Essentia from source
WORKDIR /opt
RUN git clone --depth=1 https://github.com/MTG/essentia.git && \
    cd essentia && \
    mkdir build && cd build && \
    cmake .. -DBUILD_PYTHON_BINDINGS=ON -DPYTHON_EXECUTABLE=/usr/bin/python3 && \
    make -j4 && \
    make install && \
    ldconfig

# Copy your app code into the container
WORKDIR /app
COPY ./app /app

# Install Python packages
RUN pip3 install --upgrade pip && \
    pip3 install streamlit

# Expose the port Streamlit will use
EXPOSE 10000

# Start the Streamlit app
CMD ["streamlit", "run", "main.py", "--server.port=10000", "--server.address=0.0.0.0"]
