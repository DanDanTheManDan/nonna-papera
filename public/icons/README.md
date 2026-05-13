# Icons

Drop the following PNG files in this folder before deploying:

| File              | Size      | Used for                                          |
|-------------------|-----------|---------------------------------------------------|
| nonna.png         | any       | The mascot circle inside the app header           |
| favicon.png       | 32x32     | Browser tab icon                                  |
| apple-touch-icon.png | 180x180 | iOS "Add to Home Screen" icon                     |
| icon-192.png      | 192x192   | PWA manifest standard icon                        |
| icon-512.png      | 512x512   | PWA manifest large icon                           |

## Quick way to make all of these from one source

1. Take the duck image you generated with Sora.
2. Tightly crop to her head + chef hat (square aspect) → save as the source for `apple-touch-icon.png`, `icon-192.png`, `icon-512.png`. The in-app circle (`nonna.png`) can use the same crop or a slightly looser one — it's masked to a circle anyway.
3. Resize to the sizes in the table above (any image editor or ImageMagick can do this in one batch).
4. For the iOS icon, leave a small amount of buttered-cream `#FAF1D6` background around the duck so she doesn't get clipped when iOS rounds the corners.

If any of these files are missing, the app still works — the in-app mascot falls back to a serif "N" and the home-screen icon becomes a generic browser icon.
