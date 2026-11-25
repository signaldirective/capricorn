#!/usr/bin/env bash
# Generate the breach-protocol unlock art for the Capricorn theme.
# Outputs:
#   unlock.png        - breach console panel shown at the GDM/Plymouth
#                       password screen (transparent edges, opaque navy fill)
#   preview-unlock.png - 1920x1080 preview: navy background + panel placed
#                       the way GDM renders it (bottom center, 48px margin)
set -eo pipefail

cd "$(dirname "$0")/.."
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# --- palette -------------------------------------------------------------
BG='#021228'
PANEL='rgba(4,26,56,0.70)'
GREEN='#24d120'
AMBER='#f99204'
RED='#f80824'
STEEL='#7e8a9e'
DIM='#595c64'

FB='JetBrains-Mono-ExtraBold'
FM='JetBrains-Mono-Bold'
FR='JetBrains-Mono-Regular'

# Panel geometry
PW=1240
PH=320

# --- build ---------------------------------------------------------------
canvas="$WORK/canvas.png"
magick -size ${PW}x${PH} xc:none \
  -draw "fill $BG roundrectangle 0,0 $((PW-1)),$((PH-1)) 12,12" \
  -draw "fill none stroke ${GREEN}99 stroke-width 2 roundrectangle 0,0 $((PW-1)),$((PH-1)) 12,12" \
  "$canvas"

# Title with soft green glow (blurred copy behind crisp text)
magick -size ${PW}x${PH} xc:none -font "$FB" -pointsize 26 -fill "$GREEN" \
  -annotate +28+40 '// BREACH PROTOCOL v4.2' -blur 0x6 "$WORK/title-glow.png"
magick "$canvas" "$WORK/title-glow.png" -compose over -composite \
  -font "$FB" -pointsize 26 -fill "$GREEN" -annotate +28+40 '// BREACH PROTOCOL v4.2' \
  -font "$FR" -pointsize 14 -fill "$AMBER" -annotate +30+66 'ICE: CAPRICORN.NET' \
  "$canvas"

# Trace timer (top right)
magick "$canvas" \
  -font "$FM" -pointsize 13 -fill "$AMBER" -annotate +1016+32 'TRACE TIMER' \
  -font "$FB" -pointsize 32 -fill "$RED" -annotate +1016+62 '00:42' \
  -fill "$RED" -draw "rectangle 1016,84 1160,87" \
  "$canvas"

# --- hex matrix (left block) ---------------------------------------------
magick "$canvas" -draw "fill $PANEL roundrectangle 28,96 940,236 8,8" \
  -draw "fill none stroke ${GREEN}40 stroke-width 2 roundrectangle 28,96 940,236 8,8" \
  "$canvas"

ROW1="1C 55 E9 BD 7A FF 13 8C D4 02 A9 37"
ROW2="5B CE 91 46 F0 28 9D B7 60 E2 3A C8"
read -ra R1 <<< "$ROW1"
read -ra R2 <<< "$ROW2"

cell_x0=40
cell_y0=108
CW=64
CH=48
GAP=4

# highlight cells: row1 col2 (E9) green, row2 col7 (B7) amber
for idx in 0 1 2 3 4 5 6 7 8 9 10 11; do
  x=$((cell_x0 + idx*(CW+GAP)))
  y1=$((cell_y0))
  y2=$((cell_y0 + CH + GAP))
  if [[ $idx == 2 ]]; then
    magick "$canvas" -draw "fill rgba(36,209,32,0.12) roundrectangle $x,$y1 $((x+CW)),$((y1+CH)) 4,4" \
      -draw "fill none stroke ${GREEN}CC stroke-width 2 roundrectangle $x,$y1 $((x+CW)),$((y1+CH)) 4,4" "$canvas"
  elif [[ $idx == 7 ]]; then
    magick "$canvas" -draw "fill rgba(249,146,4,0.12) roundrectangle $x,$y2 $((x+CW)),$((y2+CH)) 4,4" \
      -draw "fill none stroke ${AMBER}CC stroke-width 2 roundrectangle $x,$y2 $((x+CW)),$((y2+CH)) 4,4" "$canvas"
  fi
done

for idx in 0 1 2 3 4 5 6 7 8 9 10 11; do
  x=$((cell_x0 + idx*(CW+GAP)))
  c1="${R1[$idx]}"; c2="${R2[$idx]}"
  color="$STEEL"; c2color="$STEEL"
  [[ $idx == 2 ]] && color="$GREEN"
  [[ $idx == 7 ]] && c2color="$AMBER"
  magick "$canvas" -font "$FM" -pointsize 24 -fill "$color" \
    -annotate +$((x+12))+$((cell_y0+33)) "$c1" \
    -fill "$c2color" \
    -annotate +$((x+12))+$((cell_y0+CH+GAP+33)) "$c2" \
    "$canvas"
done

# --- required sequences + buffer (right block) ----------------------------
magick "$canvas" \
  -font "$FM" -pointsize 13 -fill "$GREEN" -annotate +960+96 'REQUIRED SEQUENCES' \
  -font "$FM" -pointsize 22 \
  -fill "$GREEN" -annotate +960+134 '55' -annotate +1018+134 '1C' -annotate +1076+134 '7A' \
  -fill "$AMBER" -annotate +960+168 'BD' \
  -fill "$STEEL" -annotate +1018+168 'E9' -annotate +1076+168 'FF' \
  -font "$FR" -pointsize 12 -fill "$STEEL" -annotate +960+210 'BUFFER' \
  "$canvas"

# buffer slots: 2 green, 1 red, 3 empty
for i in 0 1 2 3 4 5; do
  x=$((960 + i*26))
  case $i in
    0|1) magick "$canvas" -draw "fill $GREEN roundrectangle $x,220 $((x+20)),240 3,3" "$canvas" ;;
    2)   magick "$canvas" -draw "fill $RED roundrectangle $x,220 $((x+20)),240 3,3" "$canvas" ;;
    *)   magick "$canvas" -draw "fill none stroke ${STEEL}66 stroke-width 2 rectangle $x,220 $((x+20)),240" "$canvas" ;;
  esac
done

# --- footer ----------------------------------------------------------------
magick "$canvas" \
  -fill "${GREEN}66" -draw "line 28,262 1212,262" \
  -font "$FR" -pointsize 13 -fill "$STEEL" -annotate +28+290 'SYS://CAPRICORN.NET — SEC LVL 4' \
  -font "$FM" -pointsize 13 -fill "$RED" -annotate +640+290 '[!] ICE TRACER: ACTIVE' \
  -draw "fill none stroke ${RED}CC stroke-width 2 roundrectangle 1080,266 1204,298 4,4" \
  -font "$FM" -pointsize 14 -fill "$RED" -annotate +1106+289 'UPLOAD' \
  -strip -depth 8 unlock.png

# --- preview ----------------------------------------------------------------
magick -size 1920x1080 xc:"$BG" \
  unlock.png -gravity NorthWest -geometry +340+712 -composite \
  -strip -depth 8 preview-unlock.png

echo "unlock.png         $(identify -format '%wx%h' unlock.png)"
echo "preview-unlock.png $(identify -format '%wx%h' preview-unlock.png)"
