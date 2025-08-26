import os, sys, pathlib, time
import assemblyai as aai

IGN_DIR = pathlib.Path(__file__).parent
ROOT = IGN_DIR.parent

AUDIO_DIR = ROOT / "1 - Put-Audio-Files-Here"
OUT_DIR   = ROOT / "3 - Read-Your-Transcripts-Here"
DONE_DIR  = ROOT / "4 - Finished-Audio-Moved-Here"

OUT_DIR.mkdir(parents=True, exist_ok=True)
DONE_DIR.mkdir(parents=True, exist_ok=True)

api_key = os.getenv("ASSEMBLYAI_API_KEY")
if not api_key:
    env_path = IGN_DIR / ".env"
    if env_path.exists():
        for line in env_path.read_text().splitlines():
            if line.strip().startswith("ASSEMBLYAI_API_KEY="):
                api_key = line.split("=", 1)[1].strip()
                break
if not api_key:
    sys.exit("Missing API key. Put ASSEMBLYAI_API_KEY=... into 5 - Ignore-This-Folder/.env")

aai.settings.api_key = api_key

config = aai.TranscriptionConfig(
    speaker_labels=True,
    speech_model=aai.SpeechModel.best,
)

EXTS = {".mp3",".wav",".m4a",".mp4",".aac",".flac",".ogg",".wma",".webm",".mkv",".mov"}
files = sorted(p for p in AUDIO_DIR.glob("*") if p.suffix.lower() in EXTS)
if not files:
    print(f"No audio files found in: {AUDIO_DIR}")
    sys.exit(0)

def transcribe_one(src: pathlib.Path) -> bool:
    print(f"\nTranscribing: {src.name}")
    try:
        tr = aai.Transcriber(config=config).transcribe(str(src))
    except Exception as e:
        print(f"  ERROR: {e}")
        return False

    txt_path = OUT_DIR / f"{src.stem}.txt"
    try:
        with txt_path.open("w", encoding="utf-8") as f:
            if getattr(tr, "utterances", None):
                for utt in tr.utterances:
                    f.write(f"Speaker {utt.speaker}: {utt.text}\n\n")
            else:
                f.write(tr.text or "")
        print(f"  Saved → {txt_path}")
    except Exception as e:
        print(f"  ERROR writing output: {e}")
        return False
    return True

for src in files:
    if transcribe_one(src):
        dest = DONE_DIR / src.name
        if dest.exists():
            ts = time.strftime("%Y%m%d-%H%M%S")
            dest = DONE_DIR / f"{src.stem}_{ts}{src.suffix}"
        src.rename(dest)
        print(f"  Moved audio → {dest}")

print("\nAll done.")