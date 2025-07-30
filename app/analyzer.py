import essentia
import essentia.standard as es

def analyze_audio(file_path):
    loader = es.MonoLoader(filename=file_path)
    audio = loader()

    # BPM Detection
    rhythm_extractor = es.RhythmExtractor2013(method="multifeature")
    bpm, _, _, _, _ = rhythm_extractor(audio)

    # Key Detection
    key_extractor = es.KeyExtractor()
    key, scale, strength = key_extractor(audio)

    return {
        "bpm": round(bpm, 2),
        "key": f"{key} {scale}",
        "strength": round(strength, 2)
    }