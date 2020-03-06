using Documenter, QualitativeAudioFeatures

makedocs(;
    modules=[QualitativeAudioFeatures],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/mostlysimilar/QualitativeAudioFeatures.jl/blob/{commit}{path}#L{line}",
    sitename="QualitativeAudioFeatures.jl",
    authors="Michael Muszynski",
    assets=String[],
)

deploydocs(;
    repo="github.com/mostlysimilar/QualitativeAudioFeatures.jl",
)
