#!/bin/bash

while IFS='' read -r line || [[ -n "$line" ]]; do

NAME=${line:0:26}

parallel mroctx2isis from={}.IMG to={.}_L0.cub ::: $NAME

parallel ctxcal from={.}_L0.cub to={.}_L1cal.cub ::: $NAME

parallel ctxevenodd from={.}_L1cal.cub to={.}_L1.cub ::: $NAME

parallel spiceinit from={.}_L1.cub ::: $NAME

parallel cam2map from={.}_L1.cub to={.}_L2.cub map=map_template.eqc ::: $NAME

gdal_translate "$NAME"_L2.cub "$NAME"_L2_simp0.tif

rm "$NAME"_L0.cub

rm "$NAME"_L1cal.cub

rm "$NAME"_L1.cub

rm "$NAME"_L2.cub

done < "$1"
