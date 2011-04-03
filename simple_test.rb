load "./lib/linenoise.rb"

# Specify the path the linenoise lib. make doesn't build one by default.
# Adding -dylib to the gcc command options built it on OSX, however.
Linenoise.library_path File.join(File.expand_path("~/"), "/software/linenoise/linenoise.dylib")

# Specify the file where we store command history
Linenoise.history_file File.join( File.expand_path("~/"), ".linenoise_history.txt" )

# Specify a completion callback. In this example, h<TAB> will first show 'hello!!!'
callback  = FFI::Function.new(:void, [:string, :pointer]) do |string, ptr|
  if string =~ /h/
    Linenoise.linenoiseAddCompletion ptr, "hello!!!"
    Linenoise.linenoiseAddCompletion ptr, "hello world"
  end
end

# Hook into linenoise and register the above callback
linenoise = Linenoise::Prompt.new "fake irb> "
linenoise.set_completion_callback  callback


# Simulate IRB-like STDIN monitoring
loop do
  trap("SIGINT"){ exit } # This doesn't work :[

  return_value = linenoise.prompt
  
  if(return_value == -1)
    exit
  end
end



