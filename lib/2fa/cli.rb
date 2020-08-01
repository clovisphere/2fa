require '2fa/arguments'

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
      if %i[name].include?(options.mode)
        if options.name.to_s == ''
          red 'You must also specify a --name. Try --help for help.'
        end
      end
    end

    def output
      return options.warnings if options.warnings
      return errors if errors
      return arguments.to_s if options.mode == :help
    end

    def arguments
      @arguments ||= TwoFactorAuth::Arguments.new(filename, argv)
    end

    def options
      arguments.options
    end
    
    def red(string)
      "\033[31m#{string}\033[0m"
    end
  end
end
