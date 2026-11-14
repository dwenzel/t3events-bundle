# t3events-bundle

DDEV based development environment for the TYPO3 extension
[Events](https://github.com/dwenzel/t3events)
(extension key `t3events`, package `dwenzel/t3events`).

The extension is maintained for several TYPO3 versions. This bundle
contains one TYPO3 installation per version and lets you switch between them.

## Requirements

* DDEV >= 1.24
* Docker (also used by `Build/lint.sh`)

## Quick start

```bash
ddev start
ddev ext-checkout            # clones the extension into packages/t3events
ddev t3-switch 13            # configures, installs and sets up TYPO3 13
```

Open https://t3events-bundle.ddev.site/typo3/ and log in with `admin` / `Password.1`.

## Switching TYPO3 versions

```bash
ddev t3-switch               # list versions, show the active one
ddev t3-switch 11            # switch to TYPO3 11
ddev t3-switch 12 --keep-branch   # keep the currently checked out extension branch
```

`t3-switch` checks out the extension branch mapped to the version (it refuses if
`packages/t3events` has uncommitted changes), writes
`.ddev/config.zz-version.yaml` (PHP version, docroot, composer root, database),
restarts DDEV and runs `composer install` and `composer bundle:setup` in the
instance. Then it runs `ddev ext update`, because the extension's untracked
`composer.lock` still holds the dependencies of the previous branch. With
`--no-setup`, these steps are skipped. Data of each version stays in its own
database.

The mapping of versions to PHP and extension branches is in `.ddev/versions`.

## Layout

| Path                    | Purpose                                                     |
|-------------------------|-------------------------------------------------------------|
| `.ddev/`                | DDEV configuration and custom commands                      |
| `packages/t3events/`    | Working copy of the extension (own git repo, gitignored)    |
| `instances/v11` - `v14` | One TYPO3 installation (composer root) per major version    |
| `instances/shared/`     | Development settings and setup script used by all instances |
| `Build/lint.sh`         | Lint the bundle (shellcheck, editorconfig)                  |

## TYPO3 instances

| Instance | TYPO3 | PHP | Extension branch     | Database | Console          |
|----------|-------|-----|----------------------|----------|------------------|
| v11      | 11.5  | 8.2 | `support/typo3-v11`  | `t3_v11` | 7.x (`typo3cms`) |
| v12      | 12.4  | 8.3 | `support/typo3-v12`  | `t3_v12` | 8.x              |
| v13      | 13.4  | 8.3 | `main`               | `t3_v13` | 8.x              |
| v14      | 14.3  | 8.4 | `main`               | `t3_v14` | 9.x              |

Each instance requires the extension from `packages/t3events` through a
symlinked path repository. The database connection is taken from the
environment variable `TYPO3_INSTANCE_DB` (see `instances/shared/development.php`).

Backend login for all instances: `admin` / `Password.1`.

TYPO3 11 and 12 are out of free support. Their last public releases depend on
packages with known security advisories, so `config.audit.block-insecure` is
disabled in these two instances. They are meant for local development only.

Until the extension's branches are consolidated (see [ROADMAP.md](ROADMAP.md)),
`support/typo3-v12` and the TYPO3 13 code on `main` may not exist yet. Check out
the branch to work on and keep it:

```bash
ddev ext-checkout upgrade/v13
ddev t3-switch 13 --keep-branch
```

## Commands

| Command                      | Description                                                 |
|------------------------------|-------------------------------------------------------------|
| `ddev ext-checkout [branch]` | Clone the extension, optionally check out a branch          |
| `ddev t3-switch [major]`     | Switch the active TYPO3 version, or list versions           |
| `ddev composer bundle:setup` | Install TYPO3 in the active instance (idempotent)           |
| `ddev ext <composer args>`   | Run composer in `packages/t3events` (tests, linters)        |

## Testing the extension

`ddev ext` runs the extension's own composer scripts with the PHP version of the
active TYPO3 instance. Functional tests use the DDEV database server.

```bash
ddev ext update              # install the extension's dev dependencies (t3-switch does this)
ddev ext exec -- phpunit -c phpunit.xml
```

Run `ddev ext update` after checking out another extension branch without
`t3-switch` (or after `t3-switch --no-setup`): the branches use different
dependencies.

### File synchronisation

On macOS, DDEV uses Mutagen to synchronise the project between host and
container. Changes are synced with a short delay, in both directions. `ddev ext`
syncs before and after running composer. For other commands in the container
right after editing files on the host (e.g. `ddev exec`), run `ddev mutagen sync`
first. `Build/lint.sh` does not mount the project but streams the files into the
linter containers, for the same reason.

## Former setup

Until November 2026 this repository contained a single TYPO3 installation
(TYPO3 9 to 11) with the composer root in the project root and the build output
in `app/`. Its branches are kept as tags (`archive/develop`,
`archive/v10compatible`, `archive/version11compatible`). Leftover directories of
that setup (`app/`, `var/`, `tmp/`, `.build/`) are ignored and can be deleted.

## Linting the bundle

```bash
Build/lint.sh
```
