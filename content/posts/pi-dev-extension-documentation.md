+++
date = '2026-09-12T17:04:02+10:00'
draft = false
title = 'pi.dev self-help on extensions'
categories = ['harness', 'extensions']
+++

Notably, when you install a [pi.dev](https://pi.dev/) extension, the harness never actually reads or tries to present the README.md documentation associated with the extensions installed. Often, the new ecosystem of harness extensions coming forward are not just only extensible, but may also require some aspect of configuration up-front.

<https://pi.dev/packages>

```bash
$ pi --version
0.85.1
```

The [pi.dev](https://pi.dev/) system prompt already advertises skills with their locations and descriptions. However, this rule is not applied for extensions. Therefore pi.dev agent treats extensions like opaque blobs of code, without any help documentation.

I've been considering what the right mechanism for the [pi.dev](https://pi.dev/) harness would be in order to support finding extension documentation via self-help. For the first version, I'll look at creating an new extension which can resolve `.md`-based documentation lookups. The tool needs to handle both `git:` and `npm:` package instalments, while also supporting multiple scopes of project vs global harness configurations.

An example:

```bash
$ tree .pi/npm/node_modules/@mcwalrus -L2 -P 'README.md'
.pi/npm/node_modules/@mcwalrus
└── fresh-data
    ├── commands
    ├── pi-extension
    ├── README.md
    └── scripts

5 directories, 1 file
```

Where `pi` should fetch `.pi/npm/node_modules/@mcwalrus/fresh-data/README.md` when required. Currently, either the underlying model's understanding of the `pi` harness's configuration, or the self-knowledge tool cannot guarantee means of resolving this.

The current behaviour of `pi`'s self-knowledge support currently describes the purpose and API of the extensions system, but _does not_ directly provide tools for context to say where specific packages are located in the file-system. Additional requirements will include concerns for sandboxing +  when `PI_CODING_AGENT_DIR` env var is set.

An example:

```bash
$ export PI_CODING_AGENT_DIR="~/pi-configs/my-favourite"
$ tree ~/pi-configs/my-favourite -L 2
~/pi-configs/my-favourite
├── npm
│   ├── node_modules
│   ├── package-lock.json
│   └── package.json
├── settings.json
└── skills
    ...

8 directories, 3 files
```

In the case above, documentation for extensions would need to be fetched from `~/pi-configs/my-favourite/npm/node_modules` instead of `$(pwd)/.pi/npm/node_modules` to be accurate.

To note, <https://pi.dev/packages> server provides no API routes for searching the package catalog. This is may be for good intentions to protect against the registry hosting against LLMs, or to suggest users into doing their own research to their extensions installed. The query would still work for:

```bash
curl https://pi.dev/packages\?name=hello
```

However it would be a fairly verbose as un-parsed HTML, no specified versioning, and generally unnecessary seeing as README.md files are already stored locally on disk on extension instalments.

Regarding security concerns, I don't think there would be any abject risk for this approach - it should always be common practice for developers to review any third party skills and extensions installed before use. An extended solution would be to source retrieval for any `md`-related documentation under the extension based on a config flag. A potential attack vector would be to include prompt injections via secondary documentation files on newly popular extensions.
