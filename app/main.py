import streamlit as st
import tempfile
import os
from analyzer import analyze_audio

st.set_page_config(page_title="DJ Music Analyzer", layout="centered")

st.title("🎵 DJ Music Analyzer with Essentia")
st.write("Upload an MP3 file to extract BPM and musical key.")

uploaded_file = st.file_uploader("Choose a MP3 file", type=["mp3"])

if uploaded_file is not None:
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as tmp_file:
        tmp_file.write(uploaded_file.read())
        tmp_path = tmp_file.name

    st.success(f"Analyzing `{uploaded_file.name}`...")
    result = analyze_audio(tmp_path)

    st.markdown("### 🎧 Analysis Result")
    st.write(f"**BPM:** {result['bpm']}")
    st.write(f"**Key:** {result['key']}")
    st.write(f"**Confidence:** {result['strength']}")

    os.remove(tmp_path)