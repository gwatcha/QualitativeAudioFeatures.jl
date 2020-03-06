using SampledSignals, PortAudio, LibSndFile, DSP
using Logging, Observables, Unitful, Makie

include("./visualizer.jl")
include("./types.jl")

"A dictionary of different representations of the input audio signal that update when the signal updates."
struct SignalRepresentations
  map::Dict{String, Union{SignalRepresentations,Observable}}
end

# function TrackSpectrumSlice(TrackSlice)::SpectrumSlice
#   fft_periodogram = periodogram(TrackSlice, fs=TrackSlice.samplerate)
#   return SpectrumBuf(power(fft_periodogram, TrackSlice.samplerate)
# end

function SignalRepresentations(audio_sample_buffer::Observable{SampleBuf{T, 1}})::SignalRepresentations where T <: AbstractFloat

  smoothSignal(sample_buffer, width=100, σ=.5) = conv(gaussian(width, σ), sample_buffer)
  firstDerivative(sample_buffer) = conv(sample_buffer, [-1, 0, 1,])
  secondDerivative(sample_buffer) = conv(sample_buffer, [-1, 2, -1,])
  generateSpectrogram(mono_sample_buffer) = spectrogram(mono_sample_buffer; fs=mono_sample_buffer.samplerate)

  rMap = SignalRepresentations(Dict(
    "audio" => audio_sample_buffer,
    "smooth audio" => map(smoothSignal, audio_sample_buffer),
    "da/dt" => SignalRepresentations(Dict(
      "audio" => map(firstDerivative, audio_sample_buffer),
      "smooth audio" => map(firstDerivative, rMap["smooth audio"]),
    )),
    "(da/dt)²" => SignalRepresentations(Dict(
      "audio" => map(secondDerivative, audio_sample_buffer),
      "smooth audio" => map(secondDerivative, rmap["smooth audio"]),
    )),
    "spectrogram" => map(generateSpectrogram, audio_sample_buffer),
  ))

  return rMap
end


t = Template(;
             user="mostlysimilar",
             license="MIT",
             authors=["Michael Muszynski"],
             dir="~/Soft/projects",
             julia_version=v"1.3",
             plugins=[
               TravisCI(),
               Coveralls(),
               GitHubPages(),
             ],
             )

generate("QualitativeAudioFeatures", t)
