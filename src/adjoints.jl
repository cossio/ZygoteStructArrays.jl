@adjoint function (::Type{T})(t::Tuple) where {T<:StructArray}
    result = T(t)
    back(Δ::NamedTuple) = (values(Δ),)
    function back(Δ::AbstractArray{<:NamedTuple})
        nt = (; (p => [getproperty(dx, p) for dx in Δ] for p in propertynames(result))...)
        return back(nt)
    end
    return result, back
end

@adjoint function (::Type{T})(t::NamedTuple) where {T<:StructArray}
    result = T(t)
    back(Δ::NamedTuple) = (NamedTuple{propertynames(result)}(Δ),)
    function back(Δ::AbstractArray{<:NamedTuple})
        nt = (; (p => [dx[p] for dx in Δ] for p in propertynames(result))...)
        return back(nt)
    end
    return result, back
end

@adjoint function literal_getproperty(sa::StructArray, ::Val{key}) where {key}
    key::Symbol
    result = getproperty(sa, key)
    function back(Δ::AbstractArray)
        nt = (; (k => zero(v) for (k,v) in pairs(fieldarrays(sa)))...)
        return (Base.setindex(nt, Δ, key), nothing)
    end
    return result, back
end

@adjoint function (::Type{T})(t::Tuple) where {K,T<:NamedTuple{K}}
    result = T(t)
    back(Δ::NamedTuple) = (values(T(Δ)),)
    return result, back
end

@adjoint Base.getindex(x::StructArray, i...) = x[i...], Δ -> ∇getindex(x, i, Δ)
@adjoint Base.view(x::StructArray, i...) = view(x, i...), Δ -> ∇getindex(x, i, Δ)
function ∇getindex(x::StructArray, i, Δ::NamedTuple)
    dx = (; (k => ∇getindex(v, i, Δ[k]) for (k,v) in pairs(fieldarrays(x)))...)
    di = map(_ -> nothing, i)
    return (dx, map(_ -> nothing, i)...)
end
# based on 
# https://github.com/FluxML/Zygote.jl/blob/64c02dccc698292c548c334a15ce2100a11403e2/src/lib/array.jl#L41
∇getindex(x::AbstractArray, i, Δ::Nothing) = nothing
function ∇getindex(x::AbstractArray, i, Δ)
    if i isa NTuple{<:Any, Integer}
        dx = Zygote._zero(x, typeof(Δ))
        dx[i...] = Δ
    else
        dx = Zygote._zero(x, eltype(Δ))
        dxv = view(dx, i...)
        dxv .= Zygote.accum.(dxv, Zygote._droplike(Δ, dxv))
    end
    return dx
end
