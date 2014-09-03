
# my thinking is that functions loads functions that should be available at 
# at any point. If I clear the workspace, I need to run fuctions again
# before running the next program

# as an improvement, I should try writting a seasonal adjustment function
# it would be my approach of taking a series, adjusting it, and then 
# the output would be an object with the various resulting series.
# maybe could have an argument that dictated whether it would be 
# additive or multiplicative. Might need to read about the "transform"
# spec.



#source("/scripts/functions.R")

source("/scripts/load.R")


source("/scripts/prep.R")

source("/scripts/analyze.R")


#source("/scripts/graphs.R")

