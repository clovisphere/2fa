require '2fa/arguments'
require '2fa/generator'

module TwoFactorAuth
  class CLI
    attr_reader :filename, :argv

    def initialize(filename, argv)
      @filename = filename
      @argv = argv
    end

    def run
      puts output
    end

    def errors
      if %i[name].include? options.mode
        if options.name.nil?
          return red 'You must also specify a --name. Try --help for help.'
        end
      end
      if options.raw.length > 1
        if  %i[help list].include? options.mode or options.mode.empty? or options.name && options.raw.length >= 3
          red "Unknow action: #{options.raw.join(' ')}. Try --help for help"
        end
      end
    end

    def output
      return options.warnings if options.warnings
      return errors if errors
      return arguments.to_s if options.mode == :help 

      # if we get here, we have valid command line arguments
      # .2fa file could be anywhere, but we chose to have it in the current working directory
      g = gen_keychain(File.join(ENV['PWD'], '.2fa'))
      if options.mode == :list
        g.display_all
      elsif options.mode == :name
        g.add(options.name.downcase)
      else
        g.display(options.raw[0].downcase)
      end
    end

    def arguments
      @arguments ||= TwoFactorAuth::Arguments.new(filename, argv)
    end

    def options
      arguments.options
    end

    def gen_keychain(file)
      g = TwoFactorAuth::Generator.new(file)
      unless File.exist? g.file
        # the file doesn't exit, we can safely return
        return g
      end

      File.foreach(g.file) do |line|
        if !line.empty?
          line = line.gsub(/[\[,\]]/, '').split.map {|e| e.to_i}
          col = line.pack('c*').split
          name = col[0]
          if g.keys[name].empty?
            g.keys[name] = {size: col[1], secret: col[2]}
          end
          next
        end
        # TODO: maybe print file errors ~> "%s:%d: malformed key" % [g.file, line.lineno]
      end
      return g
    end

    def red(string)
      "\033[31m#{string}\033[0m"
    end
  end
end
