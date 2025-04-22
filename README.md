# SparCC_Extended

SparCC_Extended is an enhanced implementation of the original SparCC algorithm for inferring correlation networks from compositional microbiome data (e.g., 16S rRNA, metagenomics). It introduces key improvements in zero-value handling, P-value estimation, and the incorporation of environmental variables. The package integrates both Python and R components for flexible and efficient computation.

********************************

## Key Features:

********************************

- Improved zero-value handling to reduce sparsity bias.

- Accelerated and more robust P-value computation.

- Support for environmental variable integration.

- Optional support for time-series network modeling.

- Developed in Python with R-based statistical components.

Quick Start:
------------------------

By default, the code performs zero-value handling to reduce the impact of data sparsity.

Run `SparCC_Extended/SparCC-Extended/DataFission/datafission.R` using R to perform data fission, and then use the command line to run the SparCC computation.

~~~bash
# Correlation Estimation
python Compute_SparCC.py -n Experiment_SparCC -di yourfile.csv -ni 5 --save_cor=cor_sparcc.csv
~~~

Run `SparCC_Extended/SparCC-Extended/DataFission/pvalue.R` using R to perform the subsequent P-value estimation.

Integration of Environmental Factors:
---------------------------

If your dataset includes environmental factors, you can run `"SparCC-Extended/Dirichlet/Dirichlet.R"` after executing `datafission.R`, and use the resulting dataset for the subsequent steps.

---

## Directory Structure:

---

Only some important files are shown:

```
SparCC-Extended
├── DataFission
│   ├── datafission.R  
│   └── pvalue.R
├── Dirichlet
│   └── Dirichlet.R
├── LV        # Dynamic Network Prediction
│   └── LV.py
├── SparCC
│   ├── SparCC.py   # Zero value processing
│   ├──……
├── example    # Data available
├── Compute_SparCC.py     # Correlation Estimation
├── MakeBootstraps.py     # Original method
├── PseudoPvals.py        # Original method
└── README.md
```

**************************

## Citations

**************************

Friedman, J., & Alm, E. J. (2012). *Inferring correlation networks from genomic survey data*. PLoS Computational Biology, **8**(9), e1002687. https://doi.org/10.1371/journal.pcbi.1002687
