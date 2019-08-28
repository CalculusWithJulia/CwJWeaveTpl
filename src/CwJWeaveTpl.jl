module CwJWeaveTpl

import Base64: base64encode
using Random

using Weave


using Mustache
import Markdown
using JSON
using Reexport
@reexport using LaTeXStrings

using SymPy
using Plots
#Plots.plotly() = Plots.gr()
# just show body, not standalone
function Plots._show(io::IO, ::MIME"text/html", plt::Plots.Plot{Plots.PlotlyBackend})
    write(io, Plots.html_body(plt))
end


include("formatting.jl")
include("bootstrap.jl")
include("questions.jl")
include("show-methods.jl")

## we have jmd files that convert to html files
## using a specialized template

const tpl_path = joinpath(@__DIR__,"..", "tpl", "bootstrap.tpl")
const tpl_tokens = Mustache.template_from_file(tpl_path)
"""

Notes:
* rename?
* to use with *non* jmd files, include
---
options:
  eval : true
  echo : true
  line_width : 1000
---
* cache=:user should cache blocks marked with `cache=true`
"""
function mmd(f; cache=:user) # :off to turn off

    ## hack the evaluation module to load this package
    PKG = "CwJWeaveTpl"
    sandbox = "WeaveSandBox$(rand(1:10^10))"
    mod = Core.eval(Main, Meta.parse("module $sandbox\nusing $PKG\nend"))

    Weave.rcParams[:chunk_defaults][:line_width] = 1000  # set chunk options

    # run weave
    weave(f,
          template = tpl_tokens,
          informat="markdown",
          doctype="md2html",
          mod = mod,
          cache=cache
          )
end

macro q_str(x)
    "`$x`"
end

export mmd
export @q_str
export ImageFile#, Verbatim, Invisible, Outputonly, HTMLonly
export alert, warning, note
export example, popup, table
export gif_to_data
export numericq, radioq, booleanq, yesnoq, shortq, longq, multiq


end # module
