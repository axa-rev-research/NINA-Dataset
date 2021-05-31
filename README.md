# Naturalistic IN-vehicle Audio Dataset

The NINA dataset is a collection of sounds generated inside and outside (EV sirens) a car cabin. It is intented for research purposes.
In this repository, we provide a script to create the dataset. 

Sounds are recorded with dashcam or smartphone mic. As recordings are taken in a not controlled environment, we do not have the vehicle speed or the specific recording device model or microphone detail.



Categories:

|           Class          | Clip | Total Duration [sec] |
|:------------------------:|:----:|:--------------:|
| Crash                    |  751 |       865      |
| Driving                  |  295 |      1086      |
| Tire skidding            |  186 |       208      |
| Horn                     |  261 |       314      |
| Harsh acceleration       |  22  |       63       |
| Talking                  |  265 |       653      |
| Screaming                |  157 |       113      |
| Music                    |  198 |       821      |
| Pothole                  |  144 |       138      |
| Meteo (strong rain/hail) |  94  |      3613      |
| Police siren             |  39  |       288      |
| Ambulance siren          |  159 |      1253      |
| Firetruck siren          |  76  |       822      |

## Requirements
In order to run this script, you should have already installed:
- youtube-dl
- sox
- gsed (macOS only)

## Files
- dasetCreation.sh: the main script
- youtube_IDs.csv: list of youtube videos.
- labels: folder with txt files, each with the annotation [start time] [end time] [class] 

## Script running
```
$ bash datasetCreation.sh ./labels/ ./output
```
This will create a output folder with a sub-folder per category, including wav files.

## Main Youtube channels
- Bad drivers of Italy: https://www.youtube.com/channel/UCqYkaHQFrorRCAj2WgH-G5g/videos
- Car crashes time: https://www.youtube.com/user/CarCrashesTime/videos
- Car crashes time: https://www.youtube.com/channel/UCil5Tyte_KTTrPgt5cC5Q4w/videos

## Contribution/Extension

1. Add the new {video_youtube_id} and relative title to the youtube_IDs.csv file.
2. Use Audacity to annotate the file. 
      - Open the file
      - Right click on the track -> split stereo to mono and delete one of the two tracks
      - Track menu -> add new track- > label track
      - Select part and them command+b (or ctrl+b) to add the label
      - Edit menu -> Labels -> edit labels -> check and export into a file named {video_youtube_id}.txt
      - Finally to save clips: File menu -> Export -> Export Multiple. Option: split files based on Labels and Name files numbering before Label/track name. At this point file name has this convention {video_youtube_id}_{2_digits_counter}-category (e.g., HRamesEI1Iw_39-ambulance.wav) 
3. Save the annotation in a video_youtube_id.txt file in the labels folder.

If you prefere a different tool for annotation (e.g. Elan https://archive.mpi.nl/tla/elan), be sure that the video_youtube_id.txt file is in the format:
```
starting_time ending_time label_1
starting_time ending_time label_2
...
```


## Wavenet audio generation

```
nsynth_generate --checkpoint_path=matteo/wavenet-ckpt/model.ckpt-200000 -source_path=matteo/Dataset/AudioFiles/crash/ --save_path=matteo/wavenet_generated/ --batch_size=32 --gpu_number=4
```

Trimming starting and ending silence from wavenet generated clips:

```
sox input.wav output.wav silence 1 0.05 1% reverse silence 1 0.05 1% reverse;
```

## Convert Keras model to Tensorflow-lite
```
tflite_convert --output_file=KfoldNormCNN_3.tflite --keras_model_file=KfoldNormCNN_3.h5
```

## Tensorflow-lite inference on Android
https://thinkmobile.dev/automate-testing-of-tensorflow-lite-model-implementation/

