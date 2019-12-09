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
