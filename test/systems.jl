include("../src/QualitativeAudioFeatures.jl")

using Test, PortAudio, WAV, Glob
using .QualitativeAudioFeatures

@testset "System Test" begin
  @testset "Live Extraction" begin
    audio_device = "system"
    number_of_tracks = 1
    # stream = PortAudioStream(audio_device, number_of_tracks)

    # for i in 1:1000
    #   audio_data = read(stream, 1s)
    # end
  end

  @testset "WAV Files" begin
    wav_dir = "../data/reaper-files"
    @testset "Location" begin
      pan_files = glob("*.wav", wav_dir)
    end
  end

end

