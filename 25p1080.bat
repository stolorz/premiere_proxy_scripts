@echo off
@pushd %~dp0
setlocal enabledelayedexpansion 


REM uasege:
REM ./25p1080 input_folder crf
REM ./25p1080 prores_4k_50p 13.0

REM usually "prores_4k_50p"
SET INPUT_DIR=%1
SET CRF=%2

SET OUTPUT_DIR=!INPUT_DIR!\..\hevc_1080_25p_q!CRF!


ECHO !CRF!
ECHO !OUTPUT_DIR!



REM sanity checks 
REM TODO check if INPUT_DIR exists
REM TODo check if crf is float


if not exist !OUTPUT_DIR! mkdir !OUTPUT_DIR!


echo starting loop

for %%f in (!INPUT_DIR!\*.mkv;!INPUT_DIR!\*mov;!INPUT_DIR!\*.mp4;!INPUT_DIR!\*.mpg;!INPUT_DIR!\*.avi) do ( 
    SET InFile=%%f
    SET OutFile=!OUTPUT_DIR!\%%~nf.mov
    ECHO "!InFile! -> !OutFile!"
  
     ffmpeg -i "!InFile!" ^
         -threads 10 ^
         -n ^
         -c:a aac -b:a 160k ^
         -c:v libx265 -pix_fmt yuv420p -x265-params "crf=!CRF!:level-idc=6.2" -preset veryslow ^
         -movflags  isml+frag_keyframe+separate_moof+faststart ^
         "!OutFile!"
  )

