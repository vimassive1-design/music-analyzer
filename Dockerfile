FROM python:3.9-slim

# Install system-level dependencies
RUN apt-get update && \
    apt-get install -y \
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
    python3-dev \
    wget && \
    apt-get clean

# Build Essentia from source
WORKDIR /essentia
RUN git clone --depth=1 https://github.com/MTG/essentia.git . && \
    mkdir -p build && cd build && \
    cmake .. -DBUILD_PYTHON_BINDINGS=ON -DPYTHON_EXECUTABLE=/usr/local/bin/python3 && \
    make -j4 && \
    make install && \
    ldconfig

# Copy your app
WORKDIR /app
COPY ./app /app

# Install Python packages
RUN pip install --upgrade pip && \
    pip install streamlit

# Expose Streamlit default port
EXPOSE 10000

# Start Streamlit app
CMD ["streamlit", "run", "main.py", "--server.port=10000", "--server.address=0.0.0.0"]
