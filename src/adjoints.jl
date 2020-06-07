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
    back(Δ::NamedTuple) = (fieldarrays(T(Δ)),)
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
        nt = (; (p => zero(getproperty(sa, p)) for p in propertynames(sa))...)
        return (Base.setindex(nt, Δ, key), nothing)
    end
    return result, back
end

@adjoint function (::Type{T})(t::Tuple) where {K,T<:NamedTuple{K}}
    result = T(t)
    back(Δ::NamedTuple) = (values(T(Δ)),)
    return result, back
end
