@echo off
@pushd %~dp0
setlocal enabledelayedexpansion 


SET TL="drawtext=text='MPEG':x=10:y=10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET TR="drawtext=text='MPEG':x=W-th-220:y=10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET BR="drawtext=text='MPEG':x=W-th-220:y=H-th-10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"
SET BL="drawtext=text='MPEG':x=10:y=H-th-10:fontsize=90:fontcolor=#ffcccc:shadowcolor=black:shadowx=5:shadowy=5"



for %%f in (*.mkv;*.mov;*.mp4;*.mpg;*.avi) do ( 
	SET InFile=%%f
	SET OutFile=..\video_mpg\%%~nf.mov
	ECHO "!InFile! -> !OutFile!"
	ffmpeg -n -i "!InFile!" -s 1280x720 -vf "!TL!, !TR!, !BR!, !BL!, fps=25" -c:v mpeg2video -q:v 20 -c:a libmp3lame "!OutFile!"
)


SET ParentD=%~dp0

REM echo "!ParentD!"

FOR /D /r %%I IN (*) DO (
	
	SET CurrentD=%%I

	call:ReplaceText "!CurrentD!" "!ParentD!" "" RelativeD

	SET MpgD=!ParentD!..\video_mpg\!RelativeD!
	
	REM echo "!CurrentD!"
	REM echo "!RelativeD!"
	REM echo "!MpgD!"

	IF EXIST !MpgD! (
		echo mpg folder already exists 
	) ELSE (
		echo creating folder !MpgD!
		mkdir !MpgD!
	)

	for %%f in (!CurrentD!\*.mkv;!CurrentD!\*.mov;!CurrentD!\*.mp4;!CurrentD!\*.mpg;!CurrentD!\*.avi) do ( 
		SET InFile=%%f
		SET OutFile=!MpgD!\%%~nf.mov
		ECHO "!InFile! -> !OutFile!"
		ffmpeg -n -i "!InFile!" -s 1280x720 -vf "!TL!, !TR!, !BR!, !BL!, fps=25" -c:v mpeg2video -q:v 20 -c:a libmp3lame "!OutFile!"
	)

 )

@popd




:FUNCTIONS
@REM FUNCTIONS AREA
GOTO:EOF
EXIT /B

:ReplaceText
::Replace Text In String
::USE:
:: CALL:ReplaceText "!OrginalText!" OldWordToReplace NewWordToUse  Result
::Example
::SET "MYTEXT=jump over the chair"
::  echo !MYTEXT!
::  call:ReplaceText "!MYTEXT!" chair table RESULT
::  echo !RESULT!
::
:: Remember to use the "! on the input text, but NOT on the Output text.
:: The Following is Wrong: "!MYTEXT!" !chair! !table! !RESULT!
:: ^^Because it has a ! around the chair table and RESULT
:: Remember to add quotes "" around the MYTEXT Variable when calling.
:: If you don't add quotes, it won't treat it as a single string
::
set "OrginalText=%~1"
set "OldWord=%~2"
set "NewWord=%~3"
call set OrginalText=%%OrginalText:!OldWord!=!NewWord!%%
SET %4=!OrginalText!
GOTO:EOF
