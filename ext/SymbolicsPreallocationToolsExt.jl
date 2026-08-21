module SymbolicsPreallocationToolsExt

using PreallocationTools
import PreallocationTools: _restructure, get_tmp
using Symbolics, ForwardDiff

function _symbolics_get_tmp(dc, ::Type{X}) where {X}
    if hasfield(typeof(dc), :any_du)
        any_du = getfield(dc, :any_du)
        if length(dc.du) > length(any_du)
            resize!(any_du, length(dc.du))
        end
        return _restructure(dc.du, any_du)
    end

    typed_du = getfield(dc, :typed_du)
    buf = get!(typed_du, X) do
        similar(dc.du, X, length(dc.du))
    end
    if length(buf) != length(dc.du)
        buf = typed_du[X] = similar(dc.du, X, length(dc.du))
    end
    return _restructure(dc.du, buf)
end

function get_tmp(dc::DiffCache, ::Type{X}) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

function get_tmp(dc::DiffCache, ::X) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

function get_tmp(dc::DiffCache, ::AbstractArray{X}) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

function get_tmp(dc::FixedSizeDiffCache, ::Type{X}) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

function get_tmp(dc::FixedSizeDiffCache, ::X) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

function get_tmp(dc::FixedSizeDiffCache, ::AbstractArray{X}) where {T, N, X <: ForwardDiff.Dual{T, Num, N}}
    return _symbolics_get_tmp(dc, X)
end

end
