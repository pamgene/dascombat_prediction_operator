library(tercen)
library(tim) #tercen/tim
library(dplyr, warn.conflicts = FALSE)
library(reshape2)
source("R/core.R")

# http://localhost:5402/admin/w/55b87c4ed069d42cc8d1e1efde0155af/ds/57056488-ecce-480a-a791-de6596f0306e
# http://localhost:5402/admin/w/55b87c4ed069d42cc8d1e1efde0155af/ds/57056488-ecce-480a-a791-de6596f0306e
options("tercen.workflowId" = "55b87c4ed069d42cc8d1e1efde0155af")
options("tercen.stepId"     = "57056488-ecce-480a-a791-de6596f0306e")

getOption("tercen.workflowId")
getOption("tercen.stepId")

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
  rename(rowSeq = Var1, colSeq = Var2) %>%
  mutate(.ci = 0) %>%
  mutate(.ri = 0) %>%
  ctx$addNamespace() %>%
  ctx$save()

