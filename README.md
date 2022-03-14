# DasCombat prediction operator

##### Description

The `dascombat_prediction_operator` is a operator to apply a fitted model based on the
DasCOMBAT software developed at PamGene. This fitted model can be obtained through the
`dascombat_fit_operator`.

##### Usage

Input projection|.
---|---
`y-axis`        | the y values
`row`           | the peptide IDs
`column`        | the barcodes
`colors`        | the reference batches
`labels`        | the `model` obtained from the `dascombat_fit_operator`

Output relations|.
---|---
`CmbCor`        | the combat corrected values (the `y-axis` values in the input)

##### Details

Details on the computation can be found in the `pamgene::pgbatch` and 
`SVA::combat` applications.

##### See Also

[dascombat_fit_operator](https://github.com/tercen/dascombat_fit_operator),
[dascombat_shiny_fit_operator](https://github.com/tercen/dascombat_shiny_fit_operator)
