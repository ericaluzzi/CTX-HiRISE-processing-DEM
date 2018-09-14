#!/bin/bash
set -ue
set -xv

# ------------------------------------------------------------------------------------------------
# This script receives a input file with a list of two files names for the DEM (left and right)
# ------------------------------------------------------------------------------------------------

INPUT_FILE="$1"

declare -a FILES=()
declare -a NAMES=()
declare -a FILESL2=()

OLDIFS="$IFS"
IFS=$'\n' FILES=($(cat $INPUT_FILE))
IFS="$OLDIFS"
NUMLINES=${#FILES[@]}

for ((i=0;i<$NUMLINES;i++)); do
    FILE=${FILES[$i]}

    NAME=${FILE:0:26}
    #NAME=${LINE%.IMG}
    #NAME=${NAME%.img}
    NAMES[$i]=${NAME}

    FILE_L2="${NAME}_L2.cub"
    FILESL2[$i]="$FILE_L2"
done

parallel mroctx2isis from={}.IMG to={.}_L0.cub ::: ${NAMES[@]}

parallel ctxcal from={.}_L0.cub to={.}_L1cal.cub ::: ${NAMES[@]}

parallel ctxevenodd from={.}_L1cal.cub to={.}_L1.cub ::: ${NAMES[@]}

parallel spiceinit from={.}_L1.cub ::: ${NAMES[@]}

parallel cam2map from={.}_L1.cub to={.}_L2.cub map=map_template.eqc ::: ${NAMES[@]}

bundle_adjust ${FILESL2[*]} -o match_files/match

RES_STEREO=$(printf "_%s" "${NAMES[@]}")
RES_STEREO="${RES_STEREO:1}"

stereo --threads=4 ${FILESL2[*]} \
    results_ba/$RES_STEREO \
    --bundle-adjust-prefix match_files/match

point2dem --t_srs "+proj=eqc +lat_0=0 +lon_0=0 +k=1 +a=3396190 +b=3396190 +units=m +no_defs" \
    --nodata -32767 --dem-hole-fill-len 500 --orthoimage-hole-fill-len 500 --remove-outliers-params 75.0 3.0 \
    --orthoimage results_ba/${RES_STEREO}-L.tif  results_ba/${RES_STEREO}-PC.tif \
    -o ASP-${RES_STEREO}

    
# Cleaning

rm *_L0.cub

rm *_L1cal.cub

rm *_L1.cub

# The end.






# while IFS='' read -r line || [[ -n "$line" ]]; do
# 
#     #NAME=${line%.IMG}
#     NAME=${line:0:26}
# 
#     CUBNAME_i="$NAME"
#     CUBFILE_i="${NAME}_L2.cub"
# 
#     i_=${#CUBFILES[@]}
#     
#     CUBFILES[$i_]="$CUBFILE_i"
#     CUBNAMES[$i_]="$CUBNAME_i"
# 
#     
#     parallel mroctx2isis from={}.IMG to={.}_L0.cub ::: $NAME
# 
#     parallel ctxcal from={.}_L0.cub to={.}_L1cal.cub ::: $NAME
# 
#     parallel ctxevenodd from={.}_L1cal.cub to={.}_L1.cub ::: $NAME
# 
#     parallel spiceinit from={.}_L1.cub ::: $NAME
# 
#     parallel cam2map from={.}_L1.cub to="${CUBFILE_i}" map=map_template.eqc ::: $NAME
# 
#     rm "$NAME"_L0.cub
# 
#     rm "$NAME"_L1cal.cub
# 
#     rm "$NAME"_L1.cub
# 
# done < "$INPUT_FILE"

