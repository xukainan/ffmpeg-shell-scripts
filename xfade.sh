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
METHOD_STRS="smoothup  wipedown"
IMAGE_STRS="x211.jpg x2.mp4 x212.jpg"
DURATION_TIME="35"
TIME_STRS="3 30 4"
DURATION_STRS="1 1"
OFFSET_STRS="2 31"
FORMAT_STRS="1 2 1" # 格式数组，1为图片 2为视频
OUT_WIDTH="1920"
OUT_HEIGHT="1080"
TRANSPARENT_IMAGE="008.png"
TEXT_IN_EFFECT_STRS="diagbr diagbr"
#TEXT_OUT_EFFECT_STRS="0 0"
TEXT_FONTCOLOR_STRS="white white"
TEXT_FONTSIZE_STRS="34 34"
TEXT_FONTFILE_STRS="fz.ttf fz.ttf"
TEXT_STRS="典藏版山水晓院别墅 花园叠拼"
TEXT_X_STRS="80 80"
TEXT_Y_STRS="280 280"
TEXT_IN_OFFECT_STRS="6 12"
TEXT_IN_DURATION_STRS="2 2"
TEXT_OUT_OFFECT_STRS="9 15"
#TEXT_OUT_DURATION_STRS=""
OUT="20.mp4"

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
#TEXT_OUT_EFFECT_ARRAY=($TEXT_OUT_EFFECT_STRS)
TEXT_FONTCOLOR_ARRAY=($TEXT_FONTCOLOR_STRS)
TEXT_FONTSIZE_ARRAY=($TEXT_FONTSIZE_STRS)
TEXT_FONTFILE_ARRAY=($TEXT_FONTFILE_STRS)
TEXT_ARRAY=($TEXT_STRS)
TEXT_X_ARRAY=($TEXT_X_STRS)
TEXT_Y_ARRAY=($TEXT_Y_STRS)
TEXT_IN_OFFECT_ARRAY=($TEXT_IN_OFFECT_STRS)
TEXT_IN_DURATION_ARRAY=($TEXT_IN_DURATION_STRS)
TEXT_OUT_OFFECT_ARRAY=($TEXT_OUT_OFFECT_STRS)
#TEXT_OUT_DURATION_ARRAY=($TEXT_OUT_DURATION_STRS)





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
    if [ $TEXT_ARRAY_LENGTH -gt 0 ];
      then
         h1="[0:v]scale=$OUT_SIZE[0],[1:v]scale=$OUT_SIZE[1],[2:v]scale=$OUT_SIZE[2],[1][2]xfade=transition="$m1":duration="$d1":offset="$o1
      else
         h1="[0:v]scale=$OUT_SIZE[0],[1:v]scale=$OUT_SIZE[1],[0][1]xfade=transition="$m1":duration="$d1":offset="$o1
    fi
    echo "======h1========="$h1
elif [ $IMAGE_ARRAY_LENGTH -eq 1 ]; then
       h1="[1:v]scale=$OUT_SIZE[mid],"
elif [ $IMAGE_ARRAY_LENGTH -gt 2 ]; then
    $(> temp)
    tempstr=""
    index_scale=0
    index_scale_length=$(($IMAGE_ARRAY_LENGTH-1))
    if [ $TEXT_ARRAY_LENGTH -gt 0 ];
    then
      echo -n "[0:v]scale=$OUT_SIZE[0]," >> temp
      index_scale=$(($index_scale+1))
      index_scale_length=$IMAGE_ARRAY_LENGTH
    fi

    while [ $index_scale -le $index_scale_length ]
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
            if [ $TEXT_ARRAY_LENGTH -gt 0 ];
              then
                echo -n "[1][2]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
              else
                echo -n "[0][1]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
            fi
            let "index+=1"
      else
          echo "============>0============="
          m1=${METHOD_ARRAY[$index]}
          d1=${DURATION_ARRAY[$index]}
          o1=${OFFSET_ARRAY[$index]}
          mid="mid"
          if [ $TEXT_ARRAY_LENGTH -gt 0 ];
            then
              x=$(expr "$index" + "2")
            else
              x=$(expr "$index" + "1")
          fi
          echo "===x===" $x
          echo -n "[$mid][$x]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
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
  enablet=${OFFSET_ARRAY[$index]}
  echo "---------------text-------------------： "$TEXT_ARRAY_LENGTH
  for text in $TEXT_STRS; do
    echo "-----------text:"$text
    tc1=${TEXT_FONTCOLOR_ARRAY[$index]}
    ts1=${TEXT_FONTSIZE_ARRAY[$index]}
    tf1=${TEXT_FONTFILE_ARRAY[$index]}
    tx1=${TEXT_X_ARRAY[$index]}
    ty1=${TEXT_Y_ARRAY[$index]}
    ti1=${TEXT_IN_EFFECT_ARRAY[$index]}
    too1=${TEXT_OUT_OFFECT_ARRAY[$index]}
#    to1=${TEXT_OUT_EFFECT_ARRAY[$index]}
    echo "tx1"$tx1",ty1"$ty1
#    echo -n "[0]drawtext=fontcolor=$tc1:fontsize=$ts1:fontfile=$tf1:line_spacing=7:text=$text:x=$tx1:y=$ty1:enable='lte(t\,$enablet)'[text$index],"  >> temp
    echo -n "[0]drawtext=fontcolor=$tc1:fontsize=$ts1:fontfile=$tf1:line_spacing=7:text=$text:x=$tx1:y=$ty1[text$index],"  >> temp
    let "enablet+=${OFFSET_ARRAY[$index]}"
    if [ $ti1 != "0" ]; then
      tio1=${TEXT_IN_OFFECT_ARRAY[$index]}
      tid1=${TEXT_IN_DURATION_ARRAY[$index]}
      echo -n "[0][text$index]xfade=transition=$ti1:offset=$tio1:duration=$tid1[text$index],"  >> temp
    fi
#    if [ $to1 != "0" ]; then
#      too1=${TEXT_OUT_OFFECT_ARRAY[$index]}
#      tod1=${TEXT_OUT_DURATION_ARRAY[index]}
#      echo -n "[text$index][0]xfade=transition=$to1:offset=$too1:duration=$tod1[text$index],"  >> temp
#    fi
      echo -n "[text$index]scale=w=$OUT_WIDTH:h=$OUT_HEIGHT[text$index],[mid][text$index]overlay=x=0:y=0:enable='between(t,0,$too1)'[mid]," >> temp
    let "index+=1"
  done
    h3=$(cat temp)
    echo "--------------------h3 169-------------:"$h3
    h3=${h3%[*}","
    echo $h3
else
  if [ $IMAGE_ARRAY_LENGTH -ne 1 ]; then
     if [ $IMAGE_ARRAY_LENGTH -gt 2 ];
      then
       h1=${h1%[*}","
      else
       h1=$h1","
    fi
  fi
    echo $h1
fi

echo "================== start ==================== "


$(> temp)
cycleStr=""
index=0
if [ $TEXT_ARRAY_LENGTH -gt 0 ]; then
   echo $cycleStr " -r 30 -loop 1 -t $DURATION_TIME -i " $TRANSPARENT_IMAGE >> temp
fi
for image in $IMAGE_STRS;
do
 if [ ${FORMAT_ARRAY[$index]} -eq 1 ];
 then
      echo $cycleStr " -r 30 -loop 1 -t "${TIME_ARRAY[$index]}" -i " $image >> temp
      let "index+=1"
 else
      echo $cycleStr " -r 30 -i " $image >> temp
      let "index+=1"
 fi

done

echo "=========h2========"
h2=$(cat temp)
echo $h2
echo "=========h2 end========"

execStr="./ffmpeg.exe $h2 -filter_complex "$h1$h3"format=yuv420p -b:v 9000k -bufsize 9000k "$OUT


echo "=========execStr========"

echo $execStr
${execStr}

echo "==== end ===="
