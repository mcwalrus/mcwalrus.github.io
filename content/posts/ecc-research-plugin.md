+++
date = '2026-09-12T14:21:35+10:00'
draft = false
title = 'ECC Research Plugin'
categories = ['AI-harness', 'extensions-review']
+++

https://github.com/affaan-m/ECC

*The Basic Premise:*

```
plan -> test -> implement -> review -> verify -> remember -> improve
```

> Your agent can write code, but ECC gives it a coordinated engineering system and toolbox: it plans before it builds, verifies changes with tests, reviews its own work from a fresh context, remembers what matters, and turns repeated wins into reusable skills and workflows.

I am not a fan of this harness extension for a *variety of reasons:*

* It's mostly AI generated garbage.
* The skills directory is incredibly boated
* The installer package installs to home by default
* It uses far more context than previously considered useful
* The repo stores nearly 100+ skills across a random variety of topics 

Obvious examples:

* Repo skills: https://github.com/affaan-m/ECC/tree/main/skills
* See skill *ui-demo*: https://github.com/affaan-m/ECC/blob/main/skills/ui-demo/SKILL.md
* Verbose command: `npx ecc-universal@2.2.1 install --help`

The general approach to research is nice, however actual implementation is beyond terrible and of poor taste. I would say less is more in this respect. Also, skills are far to heavy in content as well :/ 

This harness extension needs a refactor back down to basic principles.

DO NOT USE.