using Makie, MakieThemes, Colors
AbstractPlotting.set_theme!(ggthemr(:earth))

using SampledSignals, DSP, LinearAlgebra, PortAudio
using Observables

using FileIO: load, save, loadstreaming, savestreaming
import LibSndFile

function getTestSampleBuf()
  wav_dir = "../data/reaper-files"
  files = glob("*.wav", wav_dir)
  return load(files[1])
end

"Return a scene which visualizes the wave form of an n channel SampleBuf"
function visualize(samples::SampleBuf{T, N})::Scene where {T<:AbstractFloat, N<:Any}
  track_scenes = []
  for track in eachcol(samples)
    push!(track_scenes, lines(track; colormap=:bmw))
  end

  return vbox(track_scenes...)
end

function visualize(periodogram::DSP.Periodograms.Periodogram)::Scene
  return lines(freq(periodogram), power(periodogram))
end

"A live visualizer which updates the returned scene if the input buffer changes."
function visualize(live_sample_buffer::Observable{SampleBuf{T, N}})::Scene where {T<:AbstractFloat, N<:Any}
  n_tracks = size(live_sample_buffer.val)[2]
  track_scenes = []
  for iₜ in 1:n_tracks
    scene_for_track = lines(lift(buffer -> buffer[:, iₜ], live_sample_buffer); colormap=:bmw)
    push!(track_scenes, scene_for_track)

    axis = scene_for_track[Axis]
    axis[:names][:axisnames] = ("Sample #", "Amplitude")
  end

  return hbox(track_scenes...)
end

function visualize(spectrogram::DSP.Periodograms.Spectrogram)
  time_window_index = Node(1)
  scene = lines(freq(spectrogram), lift(tᵢ -> power(spectrogram)[:, tᵢ], time_window_index))
  axis = scene[Axis]
  axis[:names][:axisnames] = ("Frequency", "Power")
  xlims!(scene, (0, 5000))

  parent_scene = Scene(resolution = (1920, 1080))
  hbox(scene; parent = parent_scene)
  @async begin
    spectrogram_time = time(spectrogram)
      while !isopen(parent_scene) # wait for screen to be open
          sleep(0.01)
      end
      while isopen(parent_scene)
        print("-")
        for i in 1:length(spectrogram_time)
          time_window_index[] = i
          sleep(step(spectrogram_time))
        end
      end
  end
  return parent_scene
end


