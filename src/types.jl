import DSP, PortAudio

MonoAudioSlice = SampleBuf{T, 1} where T <: AbstractFloat
StereoAudioSlice = SampleBuf{T, 2} where T <: AbstractFloat
AudioSlice = Union{StereoAudioSlice, MonoAudioSlice} 

# abstract type AudioRepresentationSlice <: Union{AudioSlice, SpectrumSlice} end

# abstract type AudioStream <: PortAudioStream{T} where T <: AbstractFloat end
# abstract type AudioFeature <: Any end

AudioFeature = Any
