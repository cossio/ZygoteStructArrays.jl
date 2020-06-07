using Test, Random, Zygote, StructArrays, ZygoteStructArrays

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((X,Y))
    sum(S.re) + 2sum(S.im)
end == ([1.0, 1.0], [2.0, 2.0])

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((im = Y, re = X))
    sum(S.re) + 2sum(S.im)
end == ([1.0, 1.0], [2.0, 2.0])

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((re = X, im = Y))
    sum(S.re) + 2sum(S.im)
end == ([1.0, 1.0], [2.0, 2.0])

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((X,Y))
    sum(S).re + 2sum(S).im
end == ([1.0, 1.0], [2.0, 2.0])

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((re = X, im = Y))
    sum(S).re + 2sum(S).im
end == ([1.0, 1.0], [2.0, 2.0])

@test gradient(randn(2), randn(2)) do X,Y
    S = StructArray{Complex}((im = Y, re = X))
    sum(S).re + 2sum(S).im
end == ([1.0, 1.0], [2.0, 2.0])
