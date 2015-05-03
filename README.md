What?
=====

Handles backup settings through rsync

Configuration
-------------

Create `config.yml` with source, targets and optional includes.

Example:

```
assets:
  - source: /media/pics/
    targets:
      - /backup/pics/
  - source: /media/vids/
    targets:
      - /backup/vids/
    includes:
      - '*on_the_moon*'
      - '*in-the-sea*'
```

Run with `ruby backup-runner.rb`
