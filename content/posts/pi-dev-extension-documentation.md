+++
date = '2026-09-12T17:04:02+10:00'
draft = false
title = 'pi.dev self-help on extensions'
+++

Notably, when you install a [pi.dev](https://pi.dev/) extension, the harness never actually reads or tries to present the README.md documentation associated with the extensions installed. Often, the new ecosystem of harness extensions coming forward are not just only extensible, but may also require some aspect of configuration up-front.

https://pi.dev/packages

```bash
$ pi
--version 0.85.1
```

The [pi.dev](https://pi.dev/) system prompt already advertises skills with their locations and descriptions. However, this rule is not applied for extensions. Therefore pi.dev agent treats extensions like opaque blobs of code, without any help documentation.

I've been considering what the right mechanism for the [pi.dev](https://pi.dev/) harness would be in order to support finding extension documentation via self-help. For the first version, I'll probably look at creating an new extension which can resolve package documentation (`.md`) lookups based on either `git:` and `npm:` package instalments - supporting project + workspace + configuration based package locations.

To note, https://pi.dev/packages server provides no API routes for searching the package catalog. This is may be for good intentions to protect against the registry hosting against LLMs. The query would still work for: 

```
$ curl https://pi.dev/packages\?name=hello
```

However it would be a bit verbose, unversioned, and unnecessary, seeing as README.md files are already stored locally on disk. There is always security to consider: I don't think there would be any abject risk for this which doesn't come without reviewing your skills / extension README.md first. A solution should only be targeted at extension docs and not docs of nested dependencies. 


I didn't expect to find such an issue which hasn't been covered yet. 

Happy for input on this.
