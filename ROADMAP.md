# Roadmap

Goal: maintained releases of the extension Events (`t3events`) for all
current TYPO3 versions (11 to 14), developed in one environment, with automated
checks and automated publishing to Packagist and TER. Both repositories follow
the branching model described in [CONTRIBUTING.md](CONTRIBUTING.md).

Issues: [bundle](https://github.com/dwenzel/t3events-bundle/issues),
[extension](https://github.com/dwenzel/t3events/issues)

## Starting point (November 2026)

| TYPO3      | Extension branch              | Last tag | Notes |
|------------|-------------------------------|----------|-------|
| 6.2        | `6.2`                         | 0.33.5   | not maintained |
| 9.5 / 10.4 | history of `develop`          | 1.1.0    | not maintained |
| 11.5       | `master` / `develop`          | 2.0.0    | `master` is a squash of `develop`, same content; tag 2.0.0 is on `develop`. Packagist has 2.0.0, TER only 1.0.2 |
| 11.5       | `feature/version11compatible` | none     | merged into 2.0.0 (3 files differ, `*_flashmessagefix` is identical) |
| 11.5       | `upgrade/v11`                 | none     | separate history (see below), includes project specific changes |
| 12.4       | `upgrade/v12`                 | none     | separate history; unit tests abort (missing test trait) |
| 13.4 / 14  | `upgrade/v13`                 | none     | separate history; Rector/Fractor applied; 912 unit tests, 5 errors; not installable with TYPO3 14 |

The branches `upgrade/v11`, `upgrade/v12` and `upgrade/v13` (April to
September 2026) start from their own root commit ("Initial: brannow feature/v11
base") and share no history with `master`. `upgrade/v13` contains `upgrade/v12`;
`upgrade/v11` is a backport branched off the TYPO3 12 line.

There is no CI apart from an outdated Travis configuration, and the dev
dependencies of 2.0.0 (nimut/testing-framework, PHPUnit 7) cannot be installed
on PHP 8.

## Decisions

* The `upgrade/*` line is the code base for TYPO3 12, 13 and 14. It is joined
  into the main history by merge commits whose tree equals the upgrade branch,
  so its commits are kept.
* `support/typo3-v11` continues from tag 2.0.0. Generic fixes from
  `upgrade/v11` are cherry-picked; project specific changes are not.
* Version lines:

| TYPO3       | Extension branch    | Version line |
|-------------|---------------------|--------------|
| 14.3 / 13.4 | `main`              | 4.x          |
| 12.4        | `support/typo3-v12` | 3.x          |
| 11.5        | `support/typo3-v11` | 2.x          |

  4.x supports TYPO3 13.4 and 14 from one code base. Support for TYPO3 13 is
  dropped with 5.0 (TYPO3 15); before that, `support/typo3-v13` is created
  from the last 4.x tag if needed.

## Phase 1: Development environment (bundle)

| Status    | Issue | Item |
|-----------|-------|------|
| in review | #2    | Multi-version DDEV environment (TYPO3 11 to 14), `ddev t3-switch`, `ddev ext` (#4) |
| in review | #3    | CI for the bundle (#5) |
| in review | #1    | Branching model, `master` renamed to `main`, CONTRIBUTING.md, this roadmap (#6) |

## Phase 2: Branching model in the extension

| Status    | Issue         | Item |
|-----------|---------------|------|
| done      | extension#92  | `master` renamed to `main`; `support/typo3-v11` and `support/typo3-v12` created from tag 2.0.0; `6.2`, `develop`, `feature/version11compatible` tagged as `archive/*`; ruleset for `main` and `support/*` |
| in review | extension#92  | CONTRIBUTING.md, support matrix (extension#112) |
| open      | extension#92  | Required status checks; delete archived branches; archive `upgrade/*` after integration |
| in review | extension#93  | Join `upgrade/v12` into `support/typo3-v12` (extension#105) |
| open      | extension#93  | 3.x test suite (take over `Tests/` from 4.x, about 50 remaining errors), constraints, CI and publish workflow |
| in review | extension#94  | Join `upgrade/v13` into `main` (extension#106) |
| in review | extension#94  | TYPO3 14 support, fixes in NotificationService (extension#107) |
| open      | extension#95  | Take over generic fixes from `upgrade/v11` into `support/typo3-v11` |
| open      | extension#103 | Dev dependencies of `support/typo3-v11` installable on PHP 8.2 |

## Phase 3: Checks and automation

| Status    | Issue         | Item |
|-----------|---------------|------|
| in review | extension#97  | Rector and Fractor configuration on `main`, PHP 8.3 rules applied (extension#109) |
| open      | extension#108 | TYPO3 14 deprecations that need TYPO3 13 to be dropped (5.0) |
| in review | extension#96  | GitHub Actions on `main`: composer validate, PHP lint, Rector/Fractor, unit tests TYPO3 13.4/14.3 x PHP 8.3/8.4; Travis CI removed (extension#110) |
| open      | extension#96  | GitHub Actions on the support branches |
| in review | extension#98  | Publish tags to TER automatically, `ext_emconf.php` restored (extension#111); Packagist via the existing GitHub hook |

## Phase 4: Releases

| Status | Issue         | Item |
|--------|---------------|------|
| open   | extension#99  | 2.0.1 (TYPO3 11), first TER release since 1.0.2 |
| open   | extension#100 | 3.0.0 (TYPO3 12) |
| open   | extension#101 | 4.0.0 (TYPO3 13.4 and 14) |

## Phase 5: Code quality and maintenance

| Status | Issue         | Item |
|--------|---------------|------|
| open   | extension#102 | PHPStan, functional tests (backend modules and plugins are not covered), coverage, editorconfig; replace the compatibility shims in `Tests/Compatibility` and the `@test` annotations (PHPUnit 12) |
| open   | extension#104 | Triage the open issues from 2016 to 2021 |

Not yet planned: compatibility of dependent extensions (`t3events_course`,
`t3calendar`) with 3.x and 4.x, and rendering of the documentation on
docs.typo3.org.
