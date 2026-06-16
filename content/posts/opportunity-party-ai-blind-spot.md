---
title: "The Opportunity Party Has an AI Blind Spot"
date: 2026-06-17
draft: false
tags: ["ai", "politics", "new-zealand", "seo", "web"]
summary: "Ask an AI who leads The Opportunity Party and it gets the name wrong. Here's why — and the two fixes that would let voters actually find the party's policies."
---

Ask any of the big AI assistants who leads The Opportunity Party right now, and
you'll likely get a confident, friendly, and wrong answer. Most of them will
tell you it's Raf Manji. The really stale ones will reach all the way back to
Gareth Morgan. The actual leader, since November 2025, is **Qiulae Wong** — but
the models haven't met her yet, and the party's own website is part of the
reason why.

I'm a software engineer, I build things for a living, and I care about New
Zealand getting good ideas in front of voters. TOP — sorry, *Opportunity*, they
rebranded — is fighting to cross the 5% MMP threshold with policy that deserves
to be read on its merits. So when I noticed their website is quietly invisible
to the tools more and more people use to research politics, I went and checked.
The concern turned out to be real, and the fixes are not hard.

This post is in two halves. First, the problem and why it matters — no
technical background needed. Then, for anyone who wants to reproduce it, the
exact plumbing that's causing it and how to fix it.

## Why this is worth caring about

Search has changed. When someone wants to know "what's [party]'s position on
tax," a growing share of them no longer scroll a list of blue links — they ask
ChatGPT, or Gemini, or whatever assistant is baked into their phone. Google
itself now answers a huge fraction of queries with an AI summary *above* the
results. AI is the new front page.

For most websites, being read by AI is a mixed bag — publishers lose ad clicks,
shops lose visits. For a political party the maths is the opposite. You *want*
your message in as many heads as possible. You don't sell ad space. The content
is campaign material you are actively trying to push out. So if an assistant can
read the party's own words, it tends to repeat the party's own framing. If it
can't, it falls back on stale training data, Wikipedia, news coverage, or
whatever hostile commentary happens to fill the vacuum.

Getting this right is close to free, and it's the single cheapest way to put the
party's actual positions in front of curious voters. Which makes the two
problems below genuinely frustrating.

## Problem 1: The policies are locked in Google Drive

Open the [Tax Reset policy page](https://www.opportunity.org.nz/tax-reset) and
you'll find the detailed plan — the actual transition document — linked as a
**Google Drive** file. Same story on a handful of other policy pages.

Here's the catch: a Google Drive "view" link doesn't hand back a document. It
hands back a web app — a page full of JavaScript that *renders* the document in
your browser. A human with a browser sees a PDF. An AI assistant fetching that
same link gets a wall of script and no readable text. The policy may as well not
exist.

This one is the worst of the two, because it blocks *everyone*. It doesn't
matter whether an assistant is allowed to read the site or not — the moment it
follows the link to the real detail, it hits the Drive viewer and comes back
empty-handed. The headline policy summaries get read; the substance behind them
doesn't.

## Problem 2: The site tells AI to stay out

The second problem is a deliberate setting. The website currently tells AI
crawlers two things: *don't train on this content*, and — for several named
assistants — *don't read this site at all.* Anthropic's Claude, OpenAI's
crawler, Google's AI crawler, Apple's, Meta's, and the big training-data
collectors are all explicitly turned away at the door.

The platforms affected are the web and desktop assistants people actually use:

- **ChatGPT** (OpenAI)
- **Claude** (Anthropic) — blocked from the whole site
- **Google Gemini** and AI Overviews
- **Apple Intelligence**
- **Meta AI**
- **Common Crawl**, the open dataset that feeds a long tail of other models

(Worth noting for the technically curious: a developer running a tool in a
terminal fetches the site as an ordinary visitor and isn't caught by these
name-based blocks — though they'd still trip over the Google Drive wall in
Problem 1. It's the consumer-facing assistants, the ones a voter would actually
open, that get stopped.)

Now, blocking *training* is a defensible call — content baked into a model
arrives with no link back, no attribution, and can resurface years out of date.
But blocking the assistants from *reading the live site* is the part that hurts.
That's not protecting anything. It's just removing the party's own voice from
the answer a voter is about to receive — and guaranteeing the model keeps
believing Raf Manji is in charge.

## The impact, in one sentence

A voter asks their assistant about Opportunity's policies, and gets: the wrong
leader, year-old framing, and whatever third parties have said — because the
party's own current words are either behind a Google Drive wall or behind a
"no entry" sign. For a party that lives or dies by reaching 5%, that's
mindshare left on the table for free.

---

## How I checked this (and how you can too)

Everything below is reproducible with `curl` and about five minutes. No special
access.

**The robots file, where the AI rules live.** A site's `robots.txt` is the
note it leaves for automated visitors. Opportunity's says:

```bash
curl -s https://opportunity.org.nz/robots.txt
```

```
User-agent: *
Content-Signal: search=yes,ai-train=no
Allow: /

User-agent: ClaudeBot
Disallow: /

User-agent: GPTBot
Disallow: /

User-agent: Google-Extended
Disallow: /
# ...plus Applebot-Extended, meta-externalagent, CCBot, Bytespider, Amazonbot
```

`search=yes, ai-train=no` is the content-signal: search indexing welcome, model
training refused. Then specific assistants are turned away entirely with
`Disallow: /`. This is Cloudflare's managed bot configuration doing the work —
which matters for the fix.

**The Google Drive wall.** On the Tax Reset page, the policy document is a Drive
link. Fetch it as an assistant would:

```bash
curl -sL "https://drive.google.com/file/d/1c0gMASTHrVvZI87WGFV9NNKyGj1WzpgW/view" \
  -o out.html
file out.html        # HTML document, not a PDF
grep -o '<title>[^<]*</title>' out.html
# <title>Opportunity_Tax Reset_Transition Plan.pdf - Google Drive</title>
```

You get 75KB of JavaScript titled like a PDF, but no document. That's exactly
what an AI agent receives: a viewer app, not a transition plan.

**A small bonus oddity.** The site is built on NationBuilder, and its config
still points at the founder's original account — the favicon loads from
`assets.nationbuilder.com/garethmorgan/...`. The plumbing has a longer memory
than the rebrand. Harmless, but a nice reminder of how these things linger.

**Two files, two eras.** There are actually *two* different `robots.txt`
responses depending on which hostname you ask:

```bash
curl -s https://opportunity.org.nz/robots.txt        # AI blocks present
curl -s https://www.opportunity.org.nz/robots.txt    # AI blocks absent
```

The bare `opportunity.org.nz` domain carries the AI content-signals and the
named-bot blocks — this is the deliberate, current configuration, managed at the
Cloudflare layer. The `www.` host serves a plainer file without them, which
reads like the default left over from the underlying NationBuilder platform (the
same legacy plumbing whose favicon still says `garethmorgan`). In other words,
the AI blocking isn't an accident or an old leftover — it's the *new* setup, and
that's exactly the part worth reconsidering.

## How to fix it

**Fix 1 — get the policy PDFs out of Google Drive.** Host the documents as plain
files on the website itself, e.g. `opportunity.org.nz/policy/tax-reset.pdf`, and
link straight to them. A direct PDF is readable by *every* assistant, allowed or
not, browser or terminal. This is the single highest-value change and it's
mostly an upload. (As a stop-gap, a Drive *direct-download* URL —
`drive.google.com/uc?export=download&id=...` — returns the file rather than the
viewer, but hosting it on the party's own domain is the proper answer.)

**Fix 2 — decide the crawler policy on purpose.** This lives in Cloudflare, not
NationBuilder. At minimum, stop blocking the live assistants from *reading* the
site so they can ground their answers in current policy. The `ai-train=no`
training refusal is a reasonable position to keep if the party wants it — that's
a values call, and a legitimate one. But "don't train" and "don't even read" are
two different switches, and right now both are flipped. Reading is the one that
helps voters.

And while they're in there: reconcile the two hostnames so the live policy is
the one the party actually intends — not a deliberate "no entry" on one host and
a legacy default on the other.

## The point

None of this is about chasing the AI hype. It's about a party with real ideas
making sure those ideas are *findable* by the tools people now reach for first.
Exposing Opportunity's actual positions — current leader and all — is the ideal
outcome for the party. The technology to do it is sitting right there. It just
needs someone to open the door and take the policies out of the drawer.

I'd love to see them do it. We could all do with more good ideas in the room,
and fewer assistants insisting the last leader is still in charge.
