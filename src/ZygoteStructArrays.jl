module ZygoteStructArrays

using Zygote, StructArrays
using Zygote: @adjoint, literal_getproperty

include("adjoints.jl")

end