# ZygoteStructArrays.jl

Defines [Zygote](https://github.com/FluxML/Zygote.jl) adjoint rules for [StructArrays](https://github.com/JuliaArrays/StructArrays.jl).

## Usage

Install with `] add ZygoteStructArrays`. Then simply `import ZygoteStructArrays` and the adjoint rules will just work.

## Examples

Try to run the following code (without loading this package first):

```julia
using Zygote, StructArrays
gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((X,Y))
    sum(S).re + 2sum(S).im
end
```

Now load this package and run that again.
