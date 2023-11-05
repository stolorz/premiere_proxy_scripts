#!/usr/bin/env bash

# uasege:
# ./4k50p input_folder crf
# ./4k50p prores_4k_50p 13.0

INPUT_DIR=$1 # usually "prores_4k_50p"
CRF=$2

OUTPUT_DIR="${INPUT_DIR}/../hevc_4k_50p_q${CRF}"

echo $CRF




# sanity checks 
if [ ! -d "$INPUT_DIR" ]; then
  echo "$INPUT_DIR does not exist."
  exit 1
fi


FLOAT_REGEX='^[0-9][0-9].[0-9]$'
if ! [[ $CRF =~ $FLOAT_REGEX ]] ; then
   echo "error: Not a number" >&2
   exit 1
fi


mkdir -p $OUTPUT_DIR


for INPUT_FILE_PATH in $INPUT_DIR/*.mov; do

  OUTPUT_FILE=`echo ${INPUT_FILE_PATH##*/} | sed -e "s/.mov/.mkv/g"`
  
  echo "${INPUT_FILE_PATH} -> ${OUTPUT_DIR}/${OUTPUT_FILE}"
  
  ffmpeg -i "${INPUT_FILE_PATH}" \
    -n \
    -c:a aac -b:a 160k \
    -c:v libx265 -pix_fmt yuv420p -x265-params "crf=${CRF}:level-idc=6.2" -preset veryslow\
    -movflags  isml+frag_keyframe+separate_moof+faststart \
    "$OUTPUT_DIR/${OUTPUT_FILE}"

done

# -x265-params crf=$CRF:level-idc=6.2:preset=veryfast \

#ffmpeg -i "${INPUT_DIR}/${INPUT_FILE}" -c:a aac -b:a 160k \
#-c:v libx265 -pix_fmt yuv420p -x265-params crf=$CRF:level-idc=6.2:preset=veryslow \
#"$OUTPUT_DIR/${OUTPUT_FILE}"

