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

IMAGE_ARRAY_LENGTH=${#IMAGE_ARRAY[@]}
echo $IMAGE_ARRAY_LENGTH
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
    index_scale=0
    while [ $index_scale -lt $IMAGE_ARRAY_LENGTH ]
    do
        echo -n "["$index_scale":v]scale=640:360["$index_scale"]," >> temp
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
            echo -n "[0][1]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
            let "index+=1"
      else
          echo "============>0============="
          m1=${METHOD_ARRAY[$index]}
          d1=${DURATION_ARRAY[$index]}
          o1=${OFFSET_ARRAY[$index]}
          x=$(expr "$index" + "1")
          echo "===x===" $x
          echo -n "[mid][$x]xfade=transition="$m1":duration="$d1":offset="$o1"[mid]," >> temp
          let "index+=1"
      fi
      echo "============index==end============="$index

    done
    h1=$(cat temp)
    h1=${h1%[*}
    echo $h1
fi

echo "================== start ==================== "


$(> temp)
cycleStr=""
index=0
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

execStr="./ffmpeg.exe $h2 -filter_complex $h1,format=yuv420p 2.mp4"


echo "=========execStr========"

echo $execStr
${execStr}

echo "==== end ===="
