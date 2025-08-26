# Audio Transcriber

This tool lets you transcribe audio files easily on your computer.

---

## Setup

### 1. Install dependencies
Make sure you have Python 3 installed. Then install the required packages:

```bash
pip install -r requirements.txt
```

### 2. Configure environment variables
	•	Find the file called [.env.example](<5 - Ignore-This-Folder/.env.example>) in the project folder.
	•	Rename it to .env:

```bash
mv .env.example .env
```

	•	Open .env in a text editor and replace the placeholder with your own AssemblyAI API key.

⚠️ Important: Keep your .env file private. Never commit it to GitHub.

⸻

## Usage

1. Place audio files

Put the audio files you want to transcribe in the folder:

1 - Put-Audio-Files-Here

2. Run the transcriber
	•	On Mac: double-click

2 - CLICK-TO-TRANSCRIBE-MAC.command

	•	On Windows: double-click

2 - CLICK-TO-TRANSCRIBE-WINDOWS.bat

3. Read your transcripts

Your transcripts will appear in:

3 - Read-Your-Transcripts-Here

4. Finished audio

Once processed, audio files are moved automatically to:

4 - Finished-Audio-Moved-Here


⸻

## Notes
	•	Do not edit or remove anything in:

5 - Ignore-This-Folder

	•	If you see errors, make sure your .env file is set up correctly with your valid API key.