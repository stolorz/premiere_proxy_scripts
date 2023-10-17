@echo off
@pushd %~dp0
setlocal enabledelayedexpansion 

SET TL="drawtext=text='MPEG':x=10:y=10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET TR="drawtext=text='MPEG':x=W-th-220:y=10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET BR="drawtext=text='MPEG':x=W-th-220:y=H-th-10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET BL="drawtext=text='MPEG':x=10:y=H-th-10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"



FOR /D /r %%I IN (.) DO (
	
	SET CurrentD=%%~nI%%~xI
	SET MpgDir=..\video_mpg\!CurrentD!

	IF "!CurrentD!" == "prores_ai"    ( SET MpgDir=..\video_mpg& SET CurrentD=.& echo setting currentD to empty string )
	IF "!CurrentD!" == "prores_noisy" ( SET MpgDir=..\video_mpg& SET CurrentD=.& echo setting currentD to empty string )
	IF "!CurrentD!" == "video_ai"     ( SET MpgDir=..\video_mpg& SET CurrentD=.& echo setting currentD to empty string )
	IF "!CurrentD!" == "video_noisy"  ( SET MpgDir=..\video_mpg& SET CurrentD=.& echo setting currentD to empty string )

	echo "!CurrentD!"

 	IF EXIST !MpgDir! (
		echo mpg folder already exists 
	) ELSE (
		echo creating folder !MpgDir!
		mkdir !MpgDir!
	)

	for %%f in (!CurrentD!\*.mkv;!CurrentD!\*.mov;!CurrentD!\*.mp4;!CurrentD!\*.mpg;!CurrentD!\*.avi) do ( 
		SET InFile=%%f
		SET OutFile=!MpgDir!\%%~nf.mov
		ECHO "!InFile! -> !OutFile!"
		ffmpeg -n -i "!InFile!" -s 1920x1080 -vf "!TL!, !TR!, !BR!, !BL!, fps=25" -c:v mpeg2video -q:v 20 -c:a libmp3lame "!OutFile!"
	)

 )

@popd