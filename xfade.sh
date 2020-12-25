#多个图片多个转场效果
# !/bin/sh
ulimit -c 9999999

#test 多个
ffm=$1
IMAGE_LENGTH=$2
LOGO_LENGTH=$3
TEXT_LENGTH=$4
MUSIC=$5
OUT=$6
OUT_WIDTH=$7
OUT_HEIGHT=$8
DURATION_TIME=$9
TRANSPARENT_IMAGE=${10}


MIDDLE_LENTH=$(($IMAGE_LENGTH-1))
METHOD_STRS=${@:11:$MIDDLE_LENTH}
START=$(($MIDDLE_LENTH+11))
IMAGE_STRS=${@:$START:$IMAGE_LENGTH}
START=$(($START+$IMAGE_LENGTH))
TIME_STRS=${@:$START:$IMAGE_LENGTH}
START=$(($START+$IMAGE_LENGTH))
DURATION_STRS=${@:$START:$MIDDLE_LENTH}
START=$(($START+$MIDDLE_LENTH))
OFFSET_STRS=${@:$START:$MIDDLE_LENTH}
START=$(($START+$MIDDLE_LENTH))
FORMAT_STRS=${@:$START:$IMAGE_LENGTH}
START=$(($START+$IMAGE_LENGTH))
echo "  ---FORMAT_STRS:"$FORMAT_STRS


OUT_SIZE=$OUT_WIDTH":"$OUT_HEIGHT
METHOD_ARRAY=($METHOD_STRS)
IMAGE_ARRAY=($IMAGE_STRS)
DURATION_ARRAY=($DURATION_STRS)
OFFSET_ARRAY=($OFFSET_STRS)
TIME_ARRAY=($TIME_STRS)
FORMAT_ARRAY=($FORMAT_STRS)
IMAGE_ARRAY_LENGTH=${#IMAGE_ARRAY[@]}
echo $IMAGE_ARRAY_LENGTH
METHOD_ARRAY_LENGTH=${#METHOD_ARRAY[@]}
echo $METHOD_ARRAY_LENGTH

echo "  ---TEXT_LENGTH:"$TEXT_LENGTH
if [ $TEXT_LENGTH -gt 0 ]; then
    MIDDLE_LENTH=$(($TEXT_LENGTH-1))
    TEXT_IN_EFFECT_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_FONTCOLOR_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_FONTSIZE_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_FONTFILE_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_X_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_Y_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_IN_OFFECT_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_IN_DURATION_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
    TEXT_OUT_OFFECT_STRS=${@:$START:$TEXT_LENGTH}
    START=$(($START+$TEXT_LENGTH))
fi
if [ $LOGO_LENGTH -gt 0 ]; then
    LOGO_STRS=${@:$START:$LOGO_LENGTH}
    START=$(($START+$LOGO_LENGTH))
    MIDDLE_LENTH=$(($LOGO_LENGTH-1))
    LOGO_IN_EFFECT_STRS=${@:$START:$LOGO_LENGTH}
    START=$(($START+$LOGO_LENGTH))
    LOGO_IN_OFFECT_STRS=${@:$START:$LOGO_LENGTH}
    START=$(($START+$LOGO_LENGTH))
    LOGO_IN_DURATION_STRS=${@:$START:$LOGO_LENGTH}
    START=$(($START+$LOGO_LENGTH))
    LOGO_OUT_OFFECT_STRS=${@:$START:$LOGO_LENGTH}
    START=$(($START+$LOGO_LENGTH))
    else
      LOGO_STRS=""
fi
AUDIO_START_TIME=${@:$START:1}



if [ $TEXT_LENGTH -gt 0 ]; then
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
  TEXT_ARRAY_LENGTH=${#TEXT_ARRAY[@]}
  echo $TEXT_ARRAY_LENGTH
  else
    TEXT_ARRAY_LENGTH=0
fi
if [ $LOGO_LENGTH -gt 0 ]; then
  LOGO_ARRAY=($LOGO_STRS)
  LOGO_IN_EFFECT_ARRAY=($LOGO_IN_EFFECT_STRS)
  #LOGO_X_ARRAY=($LOGO_X_STRS)
  #LOGO_Y_ARRAY=($LOGO_Y_STRS)
  LOGO_IN_OFFECT_ARRAY=($LOGO_IN_OFFECT_STRS)
  LOGO_IN_DURATION_ARRAY=($LOGO_IN_DURATION_STRS)
  LOGO_OUT_OFFECT_ARRAY=($LOGO_OUT_OFFECT_STRS)
  #TEXT_OUT_DURATION_ARRAY=($TEXT_OUT_DURATION_STRS)
  LOGO_ARRAY_LENGTH=${#LOGO_ARRAY[@]}
  echo $LOGO_ARRAY_LENGTH
  else
    LOGO_ARRAY_LENGTH=0
fi





if [ $IMAGE_ARRAY_LENGTH -eq 2 ];
  then
    m1=${METHOD_ARRAY[0]}
    d1=${DURATION_ARRAY[0]}
    o1=${OFFSET_ARRAY[0]}
    if [ $TEXT_ARRAY_LENGTH -gt 0 ];
      then
         h1="[0:v]scale=$OUT_SIZE[0],[1:v]scale=$OUT_SIZE[1],[2:v]scale=$OUT_SIZE[2],[1][2]xfade=transition="$m1":duration="$d1":offset="$o1"[mid],"
      else
         h1="[0:v]scale=$OUT_SIZE[0],[1:v]scale=$OUT_SIZE[1],[0][1]xfade=transition="$m1":duration="$d1":offset="$o1"[mid],"
    fi
    if [ $TEXT_ARRAY_LENGTH -eq 0 -a $LOGO_ARRAY_LENGTH -eq 0 ]; then
      h1=${h1%[*}","
      echo "---------h1---------"$h1
    fi
elif [ $IMAGE_ARRAY_LENGTH -eq 1 ]; then
    if [ $TEXT_ARRAY_LENGTH -gt 0 ];
      then
         h1="[0:v]scale=$OUT_SIZE[0],[1:v]scale=$OUT_SIZE[mid],"
      else
         h1="[0:v]scale=$OUT_SIZE[mid],"
    fi
    if [ $TEXT_ARRAY_LENGTH -eq 0 -a $LOGO_ARRAY_LENGTH -eq 0 ]; then
      h1=${h1%[*}","
      echo "---------h1---------"$h1
    fi
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
      if [ $index -eq 0 ];
      then
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
          echo -n "[$mid][$x]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
          let "index+=1"
      fi

    done
    h1=$(cat temp)
    if [ $TEXT_ARRAY_LENGTH -eq 0 -a $LOGO_ARRAY_LENGTH -eq 0 ]; then
      h1=${h1%[*}","
      echo "---------h1---------"$h1
    fi
fi

if [ $LOGO_ARRAY_LENGTH -gt 0 ]; then
  $(> temp)
  index=0
  streamnum=$IMAGE_ARRAY_LENGTH
  if [  $TEXT_ARRAY_LENGTH -gt 0  ]; then
      streamnum=$(expr "$streamnum" + "1")
  fi
  if [  -n "$MUSIC" ]; then
      streamnum=$(expr "$streamnum" + "1")
  fi
  for logo in $LOGO_STRS; do
#    lx1=${LOGO_X_ARRAY[$index]}
#    ly1=${LOGO_Y_ARRAY[$index]}
    li1=${LOGO_IN_EFFECT_ARRAY[$index]}
    loo1=${LOGO_OUT_OFFECT_ARRAY[$index]}
    lio1=${LOGO_IN_OFFECT_ARRAY[$index]}
    lid1=${LOGO_IN_DURATION_ARRAY[$index]}
    echo -n "[$streamnum:v]scale=$OUT_SIZE[$streamnum],"  >> temp
    echo -n "[0][$streamnum]xfade=transition=$li1:offset=$lio1:duration=$lid1[$streamnum],"  >> temp
    echo -n "[$streamnum]scale=w=$OUT_WIDTH:h=$OUT_HEIGHT[$streamnum],[mid][$streamnum]overlay=x=0:y=0:enable='between(t,0,$loo1)'[mid]," >> temp
    let "index+=1"
    streamnum=$(expr "$streamnum" + "1")
  done
    h4=$(cat temp)
    if [ $TEXT_ARRAY_LENGTH -eq 0 ]; then
      h4=${h4%[*}","
    fi
    echo "--------------------h4-------------:"$h4
fi

if [ $TEXT_ARRAY_LENGTH -gt 0 ]; then
  $(> temp)
  index=0
  for text in $TEXT_STRS; do
    tc1=${TEXT_FONTCOLOR_ARRAY[$index]}
    ts1=${TEXT_FONTSIZE_ARRAY[$index]}
    tf1=${TEXT_FONTFILE_ARRAY[$index]}
    tx1=${TEXT_X_ARRAY[$index]}
    ty1=${TEXT_Y_ARRAY[$index]}
    ti1=${TEXT_IN_EFFECT_ARRAY[$index]}
    too1=${TEXT_OUT_OFFECT_ARRAY[$index]}
    echo -n "[0]drawtext=fontcolor=$tc1:fontsize=$ts1:fontfile=$tf1:line_spacing=7:text=$text:x=$tx1:y=$ty1[text$index],"  >> temp
    if [ $ti1 != "0" ]; then
      tio1=${TEXT_IN_OFFECT_ARRAY[$index]}
      tid1=${TEXT_IN_DURATION_ARRAY[$index]}
      echo -n "[0][text$index]xfade=transition=$ti1:offset=$tio1:duration=$tid1[text$index],"  >> temp
    fi
      echo -n "[text$index]scale=w=$OUT_WIDTH:h=$OUT_HEIGHT[text$index],[mid][text$index]overlay=x=0:y=0:enable='between(t,0,$too1):eof_action=1'[mid]," >> temp
    let "index+=1"
  done
    h3=$(cat temp)
    h3=${h3%[*}","
  echo "--------------------h3-------------:"$h3
fi



$(> temp)
cycleStr=""
index=0
if [ $TEXT_ARRAY_LENGTH -gt 0 ]; then
   echo $cycleStr "-r 30 -loop 1 -t $DURATION_TIME -i " $TRANSPARENT_IMAGE >> temp
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
if [ -n "$MUSIC" ]; then
  echo $cycleStr " -i " $MUSIC >> temp
fi
for logo in $LOGO_STRS;
do
  echo $cycleStr " -r 30 -loop 1 -t $DURATION_TIME -i " $logo >> temp
done

h2=$(cat temp)
echo $h2

execStr="$ffm $h2 -filter_complex "$h1$h4$h3"format=yuv420p -b:v 15000k -bufsize 15000k -y temp.mp4"

echo "=========execStr========"
echo $execStr
$execStr
if [ $AUDIO_START_TIME -gt 0 ]; then
    audioStr="$ffm -i temp.mp4 -filter_complex [0:a]adelay=$AUDIO_START_TIME|$AUDIO_START_TIME -c:v copy $OUT"
    $audioStr
fi
echo "==== end ===="
