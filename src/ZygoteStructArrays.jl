module ZygoteStructArrays

using Zygote, StructArrays, LinearAlgebra
using Zygote: @adjoint, Numeric, literal_getproperty, accum

include("others.jl")
include("adjoints.jl")

end