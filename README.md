# Nonna Papera

A handmade pasta ratio calculator. One screen, big numbers, designed for use on an iPhone in the kitchen.

The first recipe is **Hearty ribbons** — a classic semolina + 00 flour egg dough that holds up to chunky sauces. More recipes can be added later by editing one object in `public/index.html`.

---

## What's in this folder

```
nonna-papera/
├── public/
│   ├── index.html        # The whole app — single self-contained file
│   ├── manifest.json     # PWA manifest for "Add to Home Screen"
│   └── icons/
│       └── README.md     # Where to drop the duck image and icon files
├── nginx.conf            # Static-site nginx config (gzip, caching, headers)
├── Dockerfile            # nginx-alpine, ~25 MB final image
├── docker-compose.yml    # One-service compose file
├── .dockerignore
└── README.md             # This file
```

---

## Before you build: drop in the duck image

The app expects a few image files in `public/icons/`. None of them exist yet — see `public/icons/README.md` for the list and sizes. The app will still run if they're missing (the in-app mascot falls back to a serif "N"), but you'll want them in place for the iPhone home-screen install to look right.

The minimum to get a polished look:

- `public/icons/nonna.png` — the in-app mascot (any reasonable size, ~256x256 or larger)
- `public/icons/apple-touch-icon.png` — 180x180, what iOS uses for the home screen icon

---

## Local quick test (optional, on your laptop)

If you have Docker running locally:

```bash
cd nonna-papera
docker compose up --build
```

Then open `http://localhost:8080` in your browser.

---

## Deploying to your GCP VPS

Assuming you'll have Claude on the server do the work, give it these instructions:

1. **Get the code onto the server.** Either push this folder to a GitHub repo and `git clone` it, or `scp` the folder up directly.

2. **Drop the icon files into `public/icons/`** (see "Before you build" above). If you skip this, the app still works but the home-screen icon will be a generic browser one.

3. **Build and start the container:**

   ```bash
   cd nonna-papera
   docker compose up -d --build
   ```

   The container exposes port 8080 on the host. Confirm it's serving:

   ```bash
   curl -I http://localhost:8080
   ```

   You should see `HTTP/1.1 200 OK`.

4. **Wire up the domain.** In Cloudflare DNS, add a record:

   | Type | Name  | Content        | Proxy status |
   |------|-------|----------------|--------------|
   | A    | pasta | (your VPS IP)  | Proxied (orange cloud) |

   That gives you `https://pasta.danimal.work` with Cloudflare-terminated TLS for free.

5. **Tell Cloudflare how to reach the container.** You have two reasonable options:

   - **Option A — Cloudflare Tunnel** (recommended; no inbound ports needed):
     Install `cloudflared` on the VPS, log in (`cloudflared tunnel login`), create a tunnel, and route `pasta.danimal.work` to `http://localhost:8080`. The tunnel keeps an outbound connection to Cloudflare, so you never expose port 80/443 on your VPS.

   - **Option B — Reverse proxy on the VPS** (if you already run nginx/Caddy/Traefik for other services):
     Add a vhost for `pasta.danimal.work` pointing to `http://localhost:8080`. With Cloudflare proxying enabled, you can use Cloudflare's "Flexible" SSL mode and skip getting a real cert on the origin — or use Cloudflare Origin Certificates if you want end-to-end TLS.

That's it. Open `https://pasta.danimal.work` on your iPhone, then **Share → Add to Home Screen** to install it as an app icon.

---

## Updating the app

When you change `public/index.html` (or anything else):

```bash
cd nonna-papera
docker compose up -d --build
```

Compose will rebuild the image and restart the container. The whole thing takes ~10 seconds because the image is so small.

---

## Adding more recipes

Open `public/index.html` and find the `recipes` object near the bottom. Add a new entry:

```js
const recipes = {
  'hearty-ribbons': {
    name: 'Hearty ribbons',
    base: 'eggs',
    ingredients: [
      { id: 'flour-00', label: '00 flour', ratio: 1.20, sub: '120% of eggs' },
      { id: 'semolina', label: 'Semolina', ratio: 0.80, sub: '80% of eggs' },
      { id: 'water',    label: 'Water',    ratio: 0.05, sub: '5% of eggs' }
    ]
  },
  'silky-ravioli': {
    name: 'Silky ravioli',
    base: 'eggs',
    ingredients: [
      // your formula here
    ]
  }
};
```

You'll also need to wire up the recipe picker (right now the "change" pill is a no-op placeholder for the future) — when you're ready, that's a small change and you can ask Claude to do it.

---

## Tech notes

- **No build step.** It's literally one HTML file with inline CSS and JS. Edit, save, refresh.
- **No tracking, no analytics, no external calls** beyond the Google Fonts CDN for the Fraunces serif. If you want fully offline, swap the `<link>` for a self-hosted woff2.
- **PWA-capable.** When installed to iOS home screen, it opens full-screen with the buttered-cream theme color and no Safari chrome.
- **Persistence.** None — there's nothing to save. Reload gives you a fresh `100g` default.
