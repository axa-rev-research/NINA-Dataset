#!/bin/bash
#
# This script fetches and trims the audio track from youtube videos.
# It takes advantage of youtube-dl and youtube2wav.sh scripts.
# youtube-dl is installable with brew.
# The script takes two inputs:
#  - a text file listing the youtube links and the relative trimming
#  - and output folder where to store trimmed audio files (wav)
#
# The text file has the following structure:
# [youtube link file] [comma separated list of trims]
# trims have this structure of example: 3:19-0:05, where 3:19 is the starting point in
# the video and 0:05 is de duration of the trim
#
# The output folder will contain only trimmed wav files.
#
# Comment with '#' lines to skip in the [video_list] file
#
# Example: bash youtubeScraping.sh youtubeFileList_path folder_to_save_clips_path 1 8000

IFS=$'\n'

# Check parameters
if [ $# -ne 2 ]; then
    echo "Check input parameters:"
    echo "[1. Folder with videoID.txt files with annotation]"
    echo "[2. output folder]"
    echo ""
    exit
fi

labelsFolder=$1
outputFolder=$2
[ ! -e ${outputFolder} ] && mkdir ${outputFolder}

for labelFile in $(ls ${labelsFolder} | grep txt); do
  counter=1
  videoID=$(echo ${labelFile} | cut -d '.' -f1)
  echo -e "Downloading and trimming file ${labelFile} ..."
  youtube-dl -f bestaudio --extract-audio --audio-format wav --audio-quality 0  --output "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=${videoID}"
  for line in $(cat ${labelsFolder}/${labelFile}  | gsed -e "s/\r/\n/g" | grep -v "^\\\\"); do
    startTime=$(echo ${line} | awk '{print $1}')
    stopTime=$(echo ${line} | awk '{print $2}')
    category=$(echo ${line} | awk '{print $3}')
    [ ! -e ${outputFolder}/${category} ] && mkdir ${outputFolder}/${category}
    trimmedFileName="${outputFolder}/${category}/${videoID}_${counter}-${category}.wav"   # ex. filename trimmed: 2mzHohHcvJk_22-crash.wav
    [ -e  ${trimmedFileName} ] && rm ${trimmedFileName}
    sox -t wav "${videoID}.wav" ${trimmedFileName} trim ${startTime} =${stopTime}
    counter=$(($counter+1))
  done
  rm  "${videoID}.wav"
done
echo "DONE!"
