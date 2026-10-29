# CandyBot

Event page for CandyBot: robots handing out candy to kids at
374 Connecticut St, San Francisco, 5 to 8 pm.

Live at https://candybot.exe.xyz/

## Editing

Everything is in `index.html`. There is no build step. Edit, commit,
push to `main`, and the live site updates within a minute.

The artwork in `img/` comes from the Figma developer handoff
(https://www.figma.com/design/AWKpUqx8NIJqSOLR92iqcd/CandyBot). The page
is a full-width layout built from the handoff's transparent pieces;
labels and speech bubbles are live text in Kanit and Gochi Hand. When a new handoff folder
arrives, run `scripts/import-assets.sh <folder>` to refresh `img/` and
`poster.png`.

## How deploys work

The server at candybot.exe.xyz serves this repo's checkout at
`~/candybot` on port 8000 using `serve.sh` (Python's built-in static
file server). A cron job on that machine runs `git pull --ff-only`
every minute, so any push to `main` goes live on the next tick.
Pull output is written to `deploy.log` in the checkout.

If the server has rebooted and the site is down, run `~/candybot/serve.sh`
on the machine to bring it back.
