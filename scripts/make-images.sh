#!/bin/sh
# Cut the two robot illustrations out of poster.jpg into img/ with
# transparent backgrounds. Needs ImageMagick (convert).
#
# For each robot: crop a box around it, flood-fill the orange halftone
# to transparent from seed points that sit on plain orange (never on
# the robot's white outline or dark parts, or the fill splits it),
# drop every leftover island smaller than 6000 px (candy, bats, bits
# of speech bubble), and trim to the content.
set -e
cd "$(dirname "$0")/.."
mkdir -p img

cutout() {
  # cutout <name> <crop WxH+X+Y> <seed> [<seed>...]
  name=$1; crop=$2; shift 2
  convert poster.jpg -crop "$crop" +repage "img/$name-raw.png"
  cmd="convert img/$name-raw.png -alpha set -fuzz 22% -fill none"
  for pt in "$@"; do
    xy=$(echo "$pt" | sed 's/^+//; s/+/,/')
    color=$(convert "img/$name-raw.png" -format "%[pixel:p{$xy}]" info:)
    cmd="$cmd -floodfill $pt '$color'"
  done
  eval "$cmd img/$name-cut.png"
  convert "img/$name-cut.png" -alpha extract -threshold 50% \
    -define connected-components:area-threshold=6000 \
    -define connected-components:mean-color=true \
    -connected-components 8 -threshold 50% "img/$name-mask.png"
  convert "img/$name-cut.png" "img/$name-mask.png" -alpha off \
    -compose CopyOpacity -composite -trim +repage -strip "img/$name.png"
  rm "img/$name-raw.png" "img/$name-cut.png" "img/$name-mask.png"
}

cutout robot-cape  400x760+0+870    +200+0 +399+0 +399+759 +380+400
cutout robot-wings 605x524+585+1160 +0+0 +0+523 +300+30
echo "wrote img/robot-cape.png img/robot-wings.png"
