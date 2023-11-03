ffmpeg -i handycam_01_chf3_ddv3_iris1.mov -vf tmix=frames=128 -c:v prores_ks -profile:v 4 -vendor apl0 -pix_fmt yuv422p10le  handycam_01_chf3_ddv3_iris1_averaged.mov
