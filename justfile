default:
    @just --list

# Run local dev server with drafts
serve:
    hugo server -D

# Build the site
build:
    hugo --gc --minify

# Create a new post: just post my-title
post title:
    hugo new content posts/{{title}}.md

# Commit and push (CI deploys to Pages)
deploy msg="update":
    git add -A && git commit -m "{{msg}}" && git push

# Clean generated files
clean:
    rm -rf public resources .hugo_build.lock
