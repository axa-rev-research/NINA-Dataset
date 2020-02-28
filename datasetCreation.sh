#!/bin/bash
#
# Example: bash datasetCreation.sh -/labels ./output

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

system=$(uname)
if [[ "$system" == 'Linux' ]]; then
   alias gsed='sed'
fi

fileCounter=1
totFiles=$(ls ${labelsFolder} | grep txt | wc -l)
for labelFile in $(ls ${labelsFolder} | grep txt); do
  counter=1
  fileCounter=$(($fileCounter+1))
  progress=$(echo "scale=2;${fileCounter}/${totFiles}*100" | bc -l)
  echo "------------ Progress=${progress}% -------------"
  videoID=$(echo ${labelFile} | cut -d '.' -f1)
  isAlreadyPresent=$(ls -R ${outputFolder} | grep -- "${videoID}" | wc -l)
  if [ "${isAlreadyPresent}" -gt 0 ]; then  # Skipping already downloaded files for incremental dataset creation
    continue
  fi
  echo -e "Downloading and trimming file ${labelFile} ..."
  youtube-dl --force-ipv4 -f bestaudio --extract-audio --audio-format wav --audio-quality 0  --output "%(id)s.%(ext)s" "https://www.youtube.com/watch?v=${videoID}"
  for line in $(cat ${labelsFolder}/${labelFile}  | gsed -e "s/\r/\n/g" | grep -v "^\\\\"); do
    startTime=$(echo ${line} | awk '{print $1}')
    stopTime=$(echo ${line} | awk '{print $2}')
    category=$(echo ${line} | awk '{print $3}')
    [ ! -e ${outputFolder}/${category} ] && mkdir ${outputFolder}/${category}
    trimmedFileName="${outputFolder}/${category}/${videoID}_${counter}-${category}.wav"   # ex. filename trimmed: 2mzHohHcvJk_22-crash.wav
    [ -e  "${trimmedFileName}" ] && rm "${trimmedFileName}"
    sox -t wav "./${videoID}.wav" "${trimmedFileName}" trim ${startTime} =${stopTime}
    counter=$(($counter+1))
  done
  rm  "./${videoID}.wav"
  sleep 120  # throttling to avoid "Youtube Error 429 Too many requests"
done
echo "DONE!"
