# The Balancing Beam of Performance

### A small-data case study in asking a personal question without forcing the data to give me a dramatic answer.

This project uses **four seasons of anonymized youth gymnastics competition data** to revisit an old question:

> Did the gymnast perform differently depending on who was in the audience?

The first version of this project was more exploratory. For the refresh, I came back to the same dataset with a more mature analytics mindset: smaller claims, clearer uncertainty, better treatment of missing data, and methods that fit the sample I actually had.

That change in approach is the part I am most interested in showing.

---

## The short version

The historical sample contains **27 meets**.

The original hypothesis was that the gymnast would score higher when her father was the only spectator.

In the observed data:

- **Only Dad:** average score ≈ **35.37**
- **All other meets:** average score ≈ **35.72**
- observed difference ≈ **-0.36 points**
- only **3 meets** were in the Only Dad group

With a comparison group that small, the uncertainty is the story.

An exact permutation test did **not** support a meaningful difference, and the level-adjusted estimate was close to zero.

So the refreshed conclusion is not:

> “I proved who should be in the stands.”

It is:

> **This dataset does not give me strong evidence that spectator configuration meaningfully changed performance.**

That is a much better answer.

---

## What changed in the 2026 refresh

Earlier versions explored more spectator indicators and a random forest.

For this version, I intentionally simplified the analysis.

### I focused on:

- descriptive statistics
- effect size instead of headline hunting
- an **exact permutation test**
- **HC3 robust standard errors**
- a small number of pre-specified regression terms
- missingness as a data-quality issue, not something to quietly fill in
- privacy-safe storytelling around a minor

The sample is small. The analysis should respect that.

---

## Repository contents

```text
balancing-beam-of-performance/
├── index.html
├── README.md
├── .nojekyll
├── data/
│   └── gymnastics_public.csv
└── R/
    └── analysis_refreshed.R
```

### `index.html`
The interactive portfolio story. Plotly is embedded directly in the page.

### `data/gymnastics_public.csv`
A deliberately de-identified public dataset.

Exact meet dates, cities, family names, and other identifying details are excluded.

### `R/analysis_refreshed.R`
The refreshed R workflow containing the descriptive analysis, exact permutation test, HC3 robust-standard-error model, and secondary exploratory work.

---

## Missing data decisions

Historical meal fields are especially sparse.

For those variables:

- `N/A` and blank values are treated as **unknown / unusable**
- unknown values are **not** recoded to `No`
- no mean or median imputation is used just to make the column easier to model

If the data was not captured well enough to answer a question, I would rather say that clearly than manufacture precision.

---

## Why this project stays in my portfolio

This is not my largest dataset or most complicated model.

That is exactly why I keep it.

It shows a part of analytics that matters a lot in real work: knowing when **not** to oversell a result.

The project is a good example of how my thinking has changed from:

```text
Can I find a pattern?
```

to:

```text
How strong is the evidence?
How uncertain is the estimate?
What can this data actually support?
What should I leave alone?
```

---

## Privacy note

This is a single-athlete case study involving a minor.

The public repository is intentionally de-identified. The original workbook and any file containing exact dates, locations, names, or raw family information should remain outside the public repo.

---

**Tools:** R · statistical inference · robust regression · permutation testing · Plotly · GitHub Pages
