require 'bundler/setup'
require 'ffi'

module Linenoise
  extend FFI::Library
  def library_path path=nil
    if path
      @library_path = path
    end
    @library_path ||= "#{File.dirname(__FILE__)}/linenoise/linenoise.dylib"
    Linenoise.setup_ffi 
  end

  def history_file path=nil
    if path
      @history_file = path
    end
    @history_file ||= File.join( File.expand_path("~/"), ".linenoise_history.txt" )
  end

  def setup_ffi
    ffi_lib @library_path
    attach_function "linenoise",            [:buffer_in], :string
    attach_function "linenoiseHistoryAdd",  [:string],    :int
    attach_function "linenoiseHistorySave", [:string],    :int
    attach_function "linenoiseHistoryLoad", [:string],    :int

    attach_function "linenoiseSetCompletionCallback",  [:pointer],   :void
    attach_function "linenoiseAddCompletion", [:pointer, :string], :void
  end

  module_function :library_path, :history_file, :setup_ffi
  
  class Prompt
    attr_reader :buffer

    def initialize prompt, size = 1024
      @size   = size
      @buffer = FFI::Buffer.new :char, size
      @buffer.write_array_of_char prompt.bytes.to_a
      if File.exist? Linenoise.history_file
        ::Linenoise.linenoiseHistoryLoad Linenoise.history_file
      end
    end

    def set_completion_callback _proc
      ::Linenoise.linenoiseSetCompletionCallback _proc
    end

    def prompt
      last = @__last_command
      line = ::Linenoise.linenoise(@buffer)
      if line && line.chomp != '' && line.chomp != last
        @__last_command = line

        # Prevent repeated commands from entering the history
        if line != last
          ::Linenoise.linenoiseHistoryAdd(line)
          ::Linenoise.linenoiseHistorySave Linenoise.history_file
        end
      end
    end
  end
end

