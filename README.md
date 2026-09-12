# mcwalrus.github.io

Personal blog. Built with [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod), deployed to GitHub Pages via Actions.

## Getting started

This repo uses [just](https://github.com/casey/just) as a command runner. Run `just` to see all recipes.

First-time setup — fetch the PaperMod theme submodule:

```
just init
```

Run the local dev server with drafts visible at <http://localhost:1313/>:

```
just serve
```

List all recipes:

```
just
```

## Recipes

| Command         | What it does                                                  |
| --------------- | ------------------------------------------------------------- |
| `just init`     | Initialise git submodules (PaperMod theme)                    |
| `just serve`    | Run `hugo server -D` (local dev server, includes drafts)     |
| `just build`    | Production build into `public/` (`hugo --gc --minify`)       |
| `just post TITLE` | Scaffold a new post at `content/posts/TITLE.md`             |
| `just deploy MSG` | Commit and push everything (CI deploys to GitHub Pages)     |
| `just clean`    | Remove generated `public/`, `resources/`, and `.hugo_build.lock` |

## Writing a post

```
just post my-new-post
```

…then edit `content/posts/my-new-post.md`. Set `draft: false` in the front matter when it's ready to publish.