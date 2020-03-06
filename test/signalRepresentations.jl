using Revise

include("../src/signalRepresentations.jl")
include("../src/types.jl")

"Update buffer using audio stream every Stream and track must have the same number of channels."
function updateBufferContinuously(stream::PortAudioStream, buffer::Observable, done::Observable{Bool}; window=10ms)
  while done[] == false {
    buffer[] = read(stream, window)
    sleep_time = uconvert(s, window).val
    sleep(sleep_time)
  }
  end
end

convertToMonoThroughAvg(sample_buffer) = (sample_buffer[:, 1] + sample_buffer[:, 2]) / 2

done = Observable(false)
stream = PortAudioStream("PulseAudio JACK Sink", 2, 0)
input_buffer = Observable(read(stream, 5ms))
mono_input_buffer = map(convertToMonoThroughAvg, input_buffer)
representations = SignalRepresentations(mono_input_buffer)

@async updateBufferContinuously(stream, input_buffer, done)

# done[] = false
# close(stream)


# s1 = slider(LinRange(1, 100, 100), raw = true, camera = campixel!, start = 10)
# buffer_size = s1[end][:value]

# scene = hbox(visualize(obs_buffer), s1)

# @async begin
#   while !isopen(scene) # wait for screen to be open
#     sleep(0.01)
#   end
#   while isopen(scene)
#     obs_buffer[] = read(stream, buffer_size[]ms)
#     sleep(buffer_size[] / 1000)
#   end

#   close(stream)
# end
