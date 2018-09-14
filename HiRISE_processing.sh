 #!/bin/bash
set -ue
# set -xv

# ---------------------------------------------------------------------------------------------------------------------------------------------------------
# Every HiRISE image is composed by 20 raw edr (.IMG) files. This script will mosaic the 20 raw edr files into 1 processed image. Repeated for every image. 
# The data_list.txt file must contain the list of the HiRISE names until RED -->   e.g: ESP_016963_1680_RED
#                                                                                       ESP_018598_1680_RED
# ---------------------------------------------------------------------------------------------------------------------------------------------------------

INPUT_FILE="$1"

declare -a FILES=()
# declare -a NAMES=()


OLDIFS="$IFS"
IFS=$'\n' FILES=($(cat $INPUT_FILE))
IFS="$OLDIFS"
NUMLINES=${#FILES[@]}

for ((i=0;i<$NUMLINES;i++)); do
    FILE=${FILES[$i]}

    NAME=${FILE:0:19}
    #NAME=${LINE%.IMG}
    #NAME=${NAME%.img}
#     NAMES[$i]=${NAME}
    
    hiedr2mosaic.py ${NAME}*.IMG

done

 






