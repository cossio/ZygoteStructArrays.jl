module ZygoteStructArrays

using Zygote, StructArrays, LinearAlgebra
using Zygote: @adjoint, Numeric, literal_getproperty, accum

include("adjoints.jl")

end