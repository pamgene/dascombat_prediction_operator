library(data.table)
library(dplyr)

get_model_from_name <- function(ctx, model_name) {
  schema = find_schema_by_factor_name(ctx, model_name)
  table = ctx$client$tableSchemaService$select(schema$id,
                                               Map(function(x)
                                                 x$name, schema$columns),
                                               0,
                                               schema$nRows)
  
  lapply(as_tibble(table)[[".base64.serialized.r.model"]], deserialize_from_string)[[1]]
}


batchcorrect = function(Z,
                        bx,
                        model.levels,
                        post,
                        lambda_g,
                        sigmasq_g) {
  Ystar = matrix(nrow = nrow(Z) , ncol = ncol(Z))
  for (i in 1:nrow(Z)) {
    bIdx = (1:length(model.levels))[bx[i] == model.levels]
    zstar = (Z[i, ] - post$lambda.star[[bIdx]]) / sqrt(post$sigma.star[[bIdx]])
    Ystar[i, ] = sqrt(sigmasq_g) * zstar + lambda_g
  }
  return(Ystar)
}



#' applyModel function
#'
#' @param Y intput
#' @param model intput
#' @param bx intput
#'
#' @return data.frame
#'
#' @import dplyr data.table
#' @export
applyModel = function(tY, model, bx) {
  if (!inherits(tY, 'matrix'))
    stop('A matrix is required')
  if (anyNA(tY))
    stop('Missing values are not allowed')
  
  if (is.null(bx)) {
    stop("apply.bad.batch.variable")
  }
  
  if (length(bx) != ncol(tY))
    stop('Bad length')
  
  if (!all(levels(bx) %in% levels(model$bx))) {
    stop("apply.bad.batch.variable")
  }
  
  Y = t(tY)
  
  Z = scale(Y,
            center = model$alpha_g,
            scale = sqrt(model$siggsq))
  
  
  
  if (nrow(Y) != length(bx)) {
    stop("apply.bad.batch.variable.length")
  }
  
  Ystar = batchcorrect(Z,
                       bx,
                       levels(model$bx),
                       model$post,
                       model$alpha_g,
                       model$siggsq)
  
  result = t(Ystar)
  
  colnames(result) = colnames(tY)
  rownames(result) = rownames(tY)
  
  result
}