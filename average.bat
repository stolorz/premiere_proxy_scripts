@echo off
@pushd %~dp0
setlocal enabledelayedexpansion 


SET INPUT_FILE=%1 # usually something like "handycam_01_chf3_ddv3_iris1.mov"
SET OUTPUT_FILE=!INPUT_FILE!_avg


// output is prores
ffmpeg -threads 10 -i !INPUT_FILE! -vf tmix=frames=128 -c:v prores_ks -profile:v 4 -vendor apl0 -pix_fmt yuv422p10le   !OUTPUT_FILE!

// output is x265
ffmpeg -threads 10 -i !INPUT_FILE! -vf tmix=frames=128 -c:v libx265 -x265-params lossless=1 -tag:v hvc1 -preset slow   !OUTPUT_FILE!


