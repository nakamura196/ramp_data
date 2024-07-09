# ramp_data

## Project Overview

This project demonstrates how to display audio files with subtitles using IIIF viewers. The example used is 「[日本のアクセントと言葉調子（下）](https://rekion.dl.ndl.go.jp/pid/3571280)」, available from the National Diet Library's Historical Recordings Collection. Transcriptions are generated using OpenAI's [Speech to Text](https://platform.openai.com/docs/guides/speech-to-text) service. Please note that the transcription results may contain errors.

### Viewer Implementations

#### Ramp Viewer

- **URL**: <https://ramp.avalonmediasystem.org/?iiif-content=https://nakamura196.github.io/ramp_data/demo/3571280/manifest.json>
- ![Ramp Viewer Screenshot](https://storage.googleapis.com/zenn-user-upload/c735c0eb1d09-20240710.png)

#### Clover Viewer

- **URL**: <https://samvera-labs.github.io/clover-iiif/docs/viewer/demo?iiif-content=https://nakamura196.github.io/ramp_data/demo/3571280/manifest.json>
- ![Clover Viewer Screenshot](https://storage.googleapis.com/zenn-user-upload/b6e4ba70522e-20240710.png)

#### Aviary Viewer

- **URL**: <https://iiif.aviaryplatform.com/player?manifest=https://nakamura196.github.io/ramp_data/demo/3571280/manifest.json>
- ![Aviary Viewer Screenshot](https://storage.googleapis.com/zenn-user-upload/baf1e91a0208-20240710.png)

### How to Create Manifest Files

#### Preparing mp4 Files

Follow the instructions in this article to obtain mp4 files:

- [Getting mp4 Files](https://zenn.dev/nakamura196/articles/60fbd0c96b44c5)

#### Creating vtt Files

Transcribe audio using OpenAI's API:

```python
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
audio_file = open(output_mp4_path, "rb")
transcript = client.audio.transcriptions.create(
    model="whisper-1",
    file=audio_file,
    response_format="vtt")
with open(output_vtt_path, "w", encoding="utf-8") as file:
    file.write(transcript)
```

#### Generating Manifest Files

Example code to create a manifest file:

```python
from iiif_prezi3 import Manifest, AnnotationPage, Annotation, ResourceItem, config
from moviepy.editor import VideoFileClip

def get_video_duration(filename):
    with VideoFileClip(filename) as video:
        return video.duration

config.configs['helpers.auto_fields.AutoLang'].auto_lang = "ja"

duration = get_video_duration(mp4_path)

manifest = Manifest(id=f"{prefix}/manifest.json", label=label)
canvas = manifest.make_canvas(id=f"{prefix}/canvas", duration=duration)
anno_body = ResourceItem(id=mp4_url, type="Sound", format="audio/mp4", duration=duration)
anno_page = AnnotationPage(id=f"{prefix}/canvas/page")
anno = Annotation(id=f"{prefix}/canvas/page/annotation", motivation="painting", body=anno_body, target=canvas.id)
anno_page.add_item(anno)
canvas.add_item(anno_page)

# Adding VTT URL
vtt_body = ResourceItem(id=vtt_url, type="Text", format="text/vtt")
vtt_anno = Annotation(
    id=f"{prefix}/canvas/annotation/webvtt",
    motivation="supplementing",
    body=vtt_body,
    target=canvas.id,
    label="WebVTT Transcript (machine-generated)"
)

vtt_anno_page = AnnotationPage(id=f"{prefix}/canvas/page/2")
vtt_anno_page.add_item(vtt_anno)

canvas.annotations = [vtt_anno_page]

with open(output_path, "w") as f:
    f.write(manifest.json(indent=2))
```

This project uses the `iiif-prezi3` library for manifest creation. For more detailed information, please refer to this article:

- [Using iiif-prezi3](https://zenn.dev/nakamura196/articles/c07753e47ab393)

### Conclusion

This README aims to assist those interested in applying IIIF to enhance their audio and video projects. Should you have any further inquiries or need more details, feel free to reach out.
