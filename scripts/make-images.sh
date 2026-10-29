#!/bin/sh
# Cut the two robot illustrations out of poster.png into img/.
# Crop boxes are in poster pixels (WxH+X+Y) and assume the poster is
# about 1190 x 1684. Adjust if the poster file has different dimensions.
set -e
cd "$(dirname "$0")/.."
convert poster.png -crop 400x760+0+880 +repage img/robot-cape.png
convert poster.png -crop 620x540+575+1145 +repage img/robot-wings.png
echo "wrote img/robot-cape.png img/robot-wings.png"
