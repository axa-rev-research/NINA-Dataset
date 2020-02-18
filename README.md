# DeepCrashzam-Dataset
Script to create the crash sound dataset. Sounds are recorded inside the car cabin with dashcam or smartphone.

Categories:
- Crash
- Driving
- Tire skidding
- Horn
- Harsh acceleration
- People taking
- People screaming
- Music
- Pothole
- Meteo (strong rain/hail)
- Police siren
- Ambulance siren
- Firetruck siren

## Requirements
In order to run this script, you should have already installed:
- youtube-dl
- sox

## Files
- dasetCreation.sh: the main script
- youtube_IDs.csv: list of youtube videos.
- labels: folder with txt files, each with the annotation [start time] [end time] [class] 

## Script running
```
$ bash datasetCreation.sh ./labels/ ./output
```
This will create a output folder with a sub-folder per category, including wav files.

## Contribution/Extension

1. Add the new {video_youtube_id} and relative title to the youtube_IDs.csv file.
2. Use Audacity to annotate the file.
      - Open the file in Audacity
      - Right click on the track -> split stereo to mono and delete one of the two tracks
      - Track menu -> add new track- > label track
      - Select part and them command+b (or ctrl+b) to add the label
      - Edit menu -> Labels -> edit labels -> check and export into a file named {video_youtube_id}.txt
      - Finally to save clips: File menu -> Export -> Export Multiple. Option: split files based on Labels and Name files numbering before Label/track name
3. Save the annotation in a video_youtube_id.txt file in the labels folder.

## Acknowledgement

If you use this dataset, please cite it:

```
@InProceedings{10.1007/978-3-030-26633-2_8,
author="Sammarco, Matteo and Detyniecki, Marcin",
editor="Donnellan, Brian and Klein, Cornel and Helfert, Markus and Gusikhin, Oleg",
title="Car Accident Detection and Reconstruction Through Sound Analysis with Crashzam",
booktitle="Smart Cities, Green Technologies and Intelligent Transport Systems",
year="2019",
publisher="Springer International Publishing",
pages="159--180",
isbn="978-3-030-26633-2"
}
```