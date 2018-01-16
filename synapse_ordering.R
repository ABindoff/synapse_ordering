library(prodlim)
set.seed(1)

distance <- function(a, b){
  # a = (x1, y1), b = (x2, y2)
  # returns Euclidean distance between a and b
  # example: distance(c(4, 3), c(0, 0))
  sqrt((a[1] - b[1])^2 + (a[2] - b[2])^2)
}

adj_matrix <- function(xy){
  # xy is a two-column matrix of (x, y) coordinates
  # returns an adjacency matrix of the distance between every combination of points
  # with NA instead of 0
  A <- matrix(NA, ncol = nrow(xy), nrow = nrow(xy))
  for(i in 1:nrow(xy)){
    for(j in 2:nrow(xy)){
      A[i, j] <- distance(xy[i,], xy[j,])
    }
  }
  A[A == 0] <- NA
  #A[lower.tri(A)] <- NA
  A
}

path_finder <- function(xy){
  # xy is a two column matrix of <x, y> coordinates
  A <- adj_matrix(xy)
  r <- 1; path <- c(1)
  while(!all(is.na(A))){
    (r <- which.min(A[r,]))
    (path <- c(path, r))
    A[,r] <- NA
  }
  path
}

generate_axon <- function(n, tortuosity, sinuosity = FALSE) {
  # n is the number of synapses on the axon
  # tortuosity is the amount of random noise to add
  # sinuosity = TRUE adds a sinusoidal wave
  xs <- c(1:n) + rnorm(n, 0, tortuosity)
  if (sinuosity) {
    ys <- sin(c(1:n)) + rnorm(n, 0, tortuosity)
  } else {
    ys <- c(1:n) + rnorm(n, 0, tortuosity)
  }
  
  shuffle <-
    c(1, sample(2:length(xs), length(xs) - 1, replace = F))  # shuffle all but first observation
  
  
  xy <-
    cbind(xs[shuffle], ys[shuffle])  # shuffle the order of observation
  
  # find the order of observations from table `xy` and assign these as node labels
  nodes <- apply(cbind(xs, ys), 1, function(x)
    row.match(x, xy))
  
  
  plot(ys ~ xs, type = "l")
  text(ys ~ xs, labels = nodes)
  
  return(list(xy, nodes))
}


n <- 6
tortuosity <- 1/3
axon <- generate_axon(n, tortuosity, sin = F)
# look at the adjacency matrix
(A <- adj_matrix(axon[[1L]]))
# compare with plot and table of observations -
axon[[1L]]

path <- path_finder(axon[[1L]])
path  ## check path has same sequence as plotted path
all(path == axon[[2L]]) ## FALSE means at least one node is out of order


## now increase `tortuosity` or `n` and see how bad it can get before it falls over!

n <- 12
tortuosity <- 2/3
axon <- generate_axon(n, tortuosity, sin = F)
path <- path_finder(axon[[1L]])
path  ## check path has same sequence as plotted path
all(path == axon[[2L]]) ## FALSE means at least one node is out of order


## add some sinuosity
tortuosity <- 1/20
axon <- generate_axon(n, tortuosity, sin = T)
path <- path_finder(axon[[1L]])
path  ## check path has same sequence as plotted path
all(path == axon[[2L]]) ## FALSE means at least one node is out of order
