# Captain Craken slides for Typst

A 16:9 slide template for maths and computer science talks, built on the Captain Craken design system: its ten colours in Paper and Lantern, Fraunces, Newsreader, DM Mono and STIX Two Math, and the sucker as the only ornament.

## Install

```sh
./install.sh
```

This installs the package as `@local/craken-slides:0.1.0` and copies the fonts to `~/.local/share/fonts/craken-slides` (on macOS, `~/Library/Fonts/craken-slides`), so you never need `--font-path`. DM Mono and STIX Two Math are skipped when they're already installed, for example by the Captain Craken book template. Run it again after changing the template.

## Use

```sh
typst init @local/craken-slides:0.1.0 my-talk         # start a new talk
typst compile talk.typ                                # Paper
typst compile --input theme=lantern talk.typ          # Lantern (dark)
typst watch talk.typ                                  # while writing
```

A talk starts with `#import "@local/craken-slides:0.1.0": *`. `examples/example.typ` shows every slide type.

`fonts/` holds static instances made from the variable fonts, because Typst can't set variation axes. Fraunces is fixed at `SOFT 100` (as the system asks). It ships as **Craken Display** (opsz 72, for titles) and **Craken Label** (opsz 18, for labels). Newsreader ships as **Craken Text**. The fonts were renamed because the OFL doesn't allow modified fonts to keep their reserved names. DM Mono and STIX Two Math are unmodified. Licences are in `fonts/`.

The logo isn't bundled. Put `captain-craken.png` next to your talk and pass `logo: image("captain-craken.png")`. In Lantern it sits on a light disc automatically.

## Slides

| Call | What it makes |
| --- | --- |
| `title-slide()` | Title, subtitle, author, date, event, and a curl of suckers |
| `outline-slide()` | Every section, numbered in coral |
| `section-slide(title, lede: ..)` | A big coral numeral; steps the section counter |
| `slide(title: .., aside: ..)[..]` | Content slide; `aside` adds the margin column |
| `idea-slide[..]` | One sentence, large |
| `reveal-slide(title: .., label: [Answer])[prompt][answer]` | Two pages: hidden (open ring), then shown (filled ring) |
| `closing-slide[..]` | Last slide |

The footer has one sucker per section (filled once you reach it) and the page number in rust.

## Inside a slide

- Callouts: `tip`, `question`, `try-this`
- Mathematics: `theorem`, `lemma`, `proposition`, `corollary`, `definition`, `example` (all take `name:`), `proof` (ends with a sucker), `dfn[term]`
- Practice: `exercise(difficulty: 1–3)`, and `exercises[..]` to group several
- Code: fenced raw blocks are styled automatically; `code(title: [file.py], numbers: true)[```…```]` adds a title and line numbers
- Figures: `canvas(width, height, node(..), edge(..), tag(..))` for diagrams, `plot(series: ((label: [$n^2$], f: x => x * x),), ..)` for charts
- Layout: `cols(..)`, `note[..]` for asides, `section-break()`
- Numbers include the section (Figure 2.1, Theorem 3.1, (2.1)). Display equations are numbered only when they have a label, and `@ref` always shows the target's own section.
