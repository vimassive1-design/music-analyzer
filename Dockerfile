FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y build-essential ffmpeg libfftw3-dev libsamplerate0-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswresample-dev libessentia-dev && \
    apt-get clean

WORKDIR /app

COPY ./app /app

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 8501

CMD ["streamlit", "run", "main.py", "--server.port=8501", "--server.address=0.0.0.0"]