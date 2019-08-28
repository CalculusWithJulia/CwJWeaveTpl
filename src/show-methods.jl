## Show method


## WeaveTpl
function Base.show(io::IO, ::MIME"text/html", x::ImageFile)
    write(io, gif_to_data(x.f, x.caption))
end


# Show SymPy
## Type piracy
function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
    write(io, "<div class=\"well well-sm\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end

function Base.show(io::IO, ::MIME"text/html", x::Array{T}) where {T <: SymPy.SymbolicObject}
    write(io, "<div class=\"well well-sm\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end
