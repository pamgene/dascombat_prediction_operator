library(tercen)
library(tim) #tercen/tim
library(dplyr, warn.conflicts = FALSE)
library(reshape2)
source("R/core.R")

ctx = tercenCtx()

# obtain data
data = ctx %>% select(.y, .ri, .ci)
y = acast(data, .ri ~ .ci, value.var = ".y")

# obtain model from the label
model = get_model_from_name(ctx, ctx$labels[[1]])

out <- ctx %>%
  select(.y, .ri, .ci) %>%
  acast(., .ri ~ .ci, value.var = ".y") %>%
  applyModel(., model, model$bx) %>%
  melt %>%
  as.data.frame %>%
  rename(.ri = Var1, .ci = Var2, CmbCor = value) %>%
  ctx$addNamespace() %>%
  ctx$save()
