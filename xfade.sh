#多个图片多个转场效果
# !/bin/sh
ulimit -c 9999999

#test 两个
#METHOD_STRS="fade"
#IMAGE_STRS="002.jpg 003.jpg"
#TIME_STRS="7 8 "
#DURATION_STRS="1"
#OFFSET_STRS="6.5"
#test 多个
METHOD_STRS="fade slideleft"
IMAGE_STRS="002.jpg 003.jpg 26.mp4"
TIME_STRS="6 7 8"
DURATION_STRS="2 2"
OFFSET_STRS="4 7"
FORMAT_STRS="1 1 2" # 格式数组，1为图片 2为视频
OUT_WIDTH="640"
OUT_HEIGHT="360"
TRANSPARENT_IMAGE="008.png" #透明图片。为了整合Xfade效果
TEXT_IN_EFFECT_STRS="slideleft" #无效果为0
TEXT_OUT_EFFECT_STRS="vuslice" #无效果为0
TEXT_FONTCOLOR_STRS="red"
TEXT_FONTSIZE_STRS="60"
TEXT_FONTFILE_STRS="fz.ttf"
TEXT_STRS="购房大抢购"
TEXT_X_STRS="50"
TEXT_Y_STRS="200"
TEXT_IN_OFFECT_STRS="2.5"
TEXT_IN_DURATION_STRS="1"
TEXT_OUT_OFFECT_STRS="1.5"
TEXT_OUT_DURATION_STRS="1"

# 传参
#METHOD_STRS=$1
#IMAGE_STRS=$2
#TIME_STRS=$3
#DURATION_STRS=$4
#OFFSET_STRS=$5


OUT_SIZE=$OUT_WIDTH":"$OUT_HEIGHT
METHOD_ARRAY=($METHOD_STRS)
IMAGE_ARRAY=($IMAGE_STRS)
DURATION_ARRAY=($DURATION_STRS)
OFFSET_ARRAY=($OFFSET_STRS)
TIME_ARRAY=($TIME_STRS)
FORMAT_ARRAY=($FORMAT_STRS)
TEXT_IN_EFFECT_ARRAY=($TEXT_IN_EFFECT_STRS)
TEXT_OUT_EFFECT_ARRAY=($TEXT_OUT_EFFECT_STRS)
TEXT_FONTCOLOR_ARRAY=($TEXT_FONTCOLOR_STRS)
TEXT_FONTSIZE_ARRAY=($TEXT_FONTSIZE_STRS)
TEXT_FONTFILE_ARRAY=($TEXT_FONTFILE_STRS)
TEXT_ARRAY=($TEXT_STRS)
TEXT_X_ARRAY=($TEXT_X_STRS)
TEXT_Y_ARRAY=($TEXT_Y_STRS)
TEXT_IN_OFFECT_ARRAY=($TEXT_IN_OFFECT_STRS)
TEXT_IN_DURATION_ARRAY=($TEXT_IN_DURATION_STRS)
TEXT_OUT_OFFECT_ARRAY=($TEXT_OUT_OFFECT_STRS)
TEXT_OUT_DURATION_ARRAY=($TEXT_OUT_DURATION_STRS)




IMAGE_ARRAY_LENGTH=${#IMAGE_ARRAY[@]}
echo $IMAGE_ARRAY_LENGTH
TEXT_ARRAY_LENGTH=${#TEXT_ARRAY[@]}
echo $TEXT_ARRAY_LENGTH
METHOD_ARRAY_LENGTH=${#METHOD_ARRAY[@]}
echo $METHOD_ARRAY_LENGTH


if [ $IMAGE_ARRAY_LENGTH -eq 2 ];
  then
    m1=${METHOD_ARRAY[0]}
    d1=${DURATION_ARRAY[0]}
    o1=${OFFSET_ARRAY[0]}
    h1="[0][1]xfade=transition="$m1":duration="$d1":offset="$o1
    echo "======h1========="$h1
else
    $(> temp)
    tempstr=""
    index_scale=1
    echo -n "[0:v]scale=$OUT_SIZE["0"]," >> temp
    while [ $index_scale -le $IMAGE_ARRAY_LENGTH ]
    do
        echo -n "["$index_scale":v]scale=$OUT_SIZE["$index_scale"]," >> temp
        index_scale=$(($index_scale+1))
    done
    index=0
    for method in $METHOD_STRS;
    do
      echo "============index============="$index
      if [ $index -eq 0 ];
      then
            echo "============0============="
            m1=${METHOD_ARRAY[0]}
            d1=${DURATION_ARRAY[0]}
            o1=${OFFSET_ARRAY[0]}
            echo -n "[1][2]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
            let "index+=1"
      else
          echo "============>0============="
          m1=${METHOD_ARRAY[$index]}
          d1=${DURATION_ARRAY[$index]}
          o1=${OFFSET_ARRAY[$index]}
          x=$(expr "$index" + "2")
          echo "===x===" $x
          echo -n "[mid][$x]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
          let "index+=1"
      fi
      echo "============index==end============="$index

    done
    h1=$(cat temp)
    echo $h1
fi

if [ $TEXT_ARRAY_LENGTH -gt 0 ]; then
  $(> temp)
  index=0
  for text in $TEXT_ARRAY; do
    tc1=${TEXT_FONTCOLOR_ARRAY[$index]}
    ts1=${TEXT_FONTSIZE_ARRAY[$index]}
    tf1=${TEXT_FONTFILE_ARRAY[$index]}
    tx1=${TEXT_X_ARRAY[$index]}
    ty1=${TEXT_Y_ARRAY[$index]}
    ti1=${TEXT_IN_EFFECT_ARRAY[$index]}
    to1=${TEXT_OUT_EFFECT_ARRAY[$index]}
    echo -n "[0]drawtext=fontcolor=$tc1:fontsize=$ts1:fontfile=$tf1:line_spacing=7:text=$text:x=$tx1:y=$ty1[text$index],"  >> temp
    if [ ti1 != "0" ]; then
      tio1=${TEXT_IN_OFFECT_ARRAY[$index]}
      tid1=${TEXT_IN_DURATION_ARRAY[$index]}
      echo -n "[text$index][0]xfade=transition=$ti1:duration=$tid1:offset=$tio1[text$index],"  >> temp
    fi
    if [ to1 != "0" ]; then
      too1=${TEXT_OUT_OFFECT_ARRAY[$index]}
      tod1=${TEXT_OUT_DURATION_ARRAY[index]}
      echo -n "[0][text$index]xfade=transition=$to1:duration=$tod1:offset=$too1[text$index],"  >> temp
    fi
    echo -n "[text$index]scale=w=$OUT_WIDTH:h=$OUT_HEIGHT[text$index],[mid][text$index]overlay=x=0:y=0[mid]," >> temp
  done
    h3=$(cat temp)
    h3=${h3%[*}
    echo $h3
else
    h1=${h1%[*}
    echo $h1
fi

echo "================== start ==================== "


$(> temp)
cycleStr=""
index=0
if [ $TEXT_ARRAY_LENGTH -gt 0 ]; then
   echo $cycleStr " -r 24 -loop 1 -t 5 -i " $TRANSPARENT_IMAGE >> temp
fi
for image in $IMAGE_STRS;
do
 if [ ${FORMAT_ARRAY[$index]} -eq 1 ];
 then
      echo $cycleStr " -r 24 -loop 1 -t "${TIME_ARRAY[$index]}" -i " $image >> temp
      let "index+=1"
 else
      echo $cycleStr " -r 24 -i " $image >> temp
      let "index+=1"
 fi

done

echo "=========h2========"
h2=$(cat temp)
echo $h2
echo "=========h2 end========"

execStr="./ffmpeg.exe $h2 -filter_complex $h1$h3,format=yuv420p 2.mp4"


echo "=========execStr========"

echo $execStr
${execStr}

echo "==== end ===="
