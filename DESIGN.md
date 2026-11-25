# CAPRICORN — Design Notes

Theme for Capri ("Capricorn"), the cyborg wolf from Cyberpunk: Edgerunners 2.
The character reads as red, green, and orange over dark gunmetal blues —
chrome, arterial spray, and the wolf's green optics against the Night City
night.

## Palette

Extracted by quantizing `backgrounds/01.png` (the Capri artwork) and
hand-tuned for contrast.

| Role | Hex | Notes |
|------|-----|-------|
| background | `#021228` | deepest navy from the artwork |
| foreground | `#d8d2c9` | warm bone white, night-city concrete |
| accent | `#24d120` | the wolf's neon green optics |
| red | `#f80824` | arterial red, straight from the art |
| orange | `#f77302` | hot orange highlights |
| yellow | `#f99204` | amber mid-tones |
| blue | `#1f65a2` | steel blue chrome |
| cyan | `#40b1d3` | coolant cyan |
| magenta | `#b864a8` | rare pink neon, kept for range |
| muted | `#7e8a9e` | desaturated chrome |
| selection | `#0e4477` | blue steel selection wash |

## Rules

- **Green is Capri.** The accent — selections, titles, CPU meters — glows
  green like her optics.
- **Red is warning.** Box outlines in btop and error surfaces run arterial
  red.
- **Orange is heat.** Amber → orange → red gradients carry temperature and
  memory pressure.
- **Backgrounds stay transparent** where the app supports it (btop) so the
  Capri wallpaper shows through.

## Sources

- Wallpapers: provided by the user in `backgrounds/` (see SOURCES.md).
