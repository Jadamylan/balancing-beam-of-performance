# The Balancing Beam of Performance

A GitHub Pages-ready, interactive portfolio case study using four seasons of anonymized youth gymnastics competition data.

## What is in this repo

- **index.html** — the interactive portfolio story. This is the page GitHub Pages serves.
- **data/gymnastics_public.csv** — anonymized public dataset. Exact meet dates, cities, and family names are intentionally excluded.
- **R/analysis_refreshed.R** — refreshed R analysis with descriptive statistics, an exact permutation test, HC3 robust standard errors, and secondary exploratory analyses.

## Key finding

The original hypothesis was that the gymnast would score higher when her father was the only spectator. In the 27-meet historical sample, Only Dad meets averaged about 35.37 versus 35.72 for all other meets, a difference of about -0.36 points. With only three Only Dad meets, the estimate is highly uncertain. An exact permutation test did not support a meaningful difference, and the level-adjusted estimate was close to zero.

## Why the analysis changed

The earlier project explored multiple spectator indicators and a random forest. For the refreshed version, the analysis is intentionally simpler because the sample is small. The portfolio emphasizes effect sizes, uncertainty, missingness, an exact permutation test, and a small number of pre-specified regression terms.

Historical meal fields are especially sparse. N/A and blanks are treated as unknown/unusable for the meal question rather than as No. No mean or median imputation is used.

## Publish with GitHub Pages

1. Create a new GitHub repository.
2. Upload the contents of this folder so `index.html` is at the repository root.
3. In GitHub, open **Settings → Pages**.
4. Under **Build and deployment**, choose **Deploy from a branch**.
5. Select the `main` branch and `/` (root) folder, then save.

GitHub will provide a public URL in the form `https://YOUR-USERNAME.github.io/REPO-NAME/`.

Plotly is embedded directly in `index.html`, so the charts do not depend on a separate JavaScript file. The optional brand fonts load from Google Fonts when available and fall back to system fonts otherwise.

## Privacy note

This is a single-athlete case study involving a minor. The public dataset is deliberately de-identified. Keep the original workbook and any file containing exact dates, locations, names, or raw family information out of the public repository.
