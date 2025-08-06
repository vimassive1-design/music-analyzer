FROM ubuntu:20.04

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install Python and system dependencies
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
    pkg-config \
    wget && \
    apt-get clean

# Set Python alias
RUN ln -s /usr/bin/python3 /usr/bin/python

# Build Essentia from source
WORKDIR /essentia
RUN git clone --depth=1 https://github.com/MTG/essentia.git . && \
    mkdir build && cd build && \
    cmake .. -DBUILD_PYTHON_BINDINGS=ON -DPYTHON_EXECUTABLE=/usr/bin/python3 && \
    make -j4 && \
    make install && \
    ldconfig

# Set app directory
WORKDIR /app
COPY ./app /app

# Install Python packages
RUN pip3 install --upgrade pip && \
    pip3 install streamlit

# Expose Streamlit port
EXPOSE 10000

# Start the app
CMD ["streamlit", "run", "main.py", "--server.port=10000", "--server.address=0.0.0.0"]
