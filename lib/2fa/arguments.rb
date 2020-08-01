require 'optparse'
require 'ostruct'

module TwoFactorAuth
  class Arguments
    def initialize(filename, arguments)
      @filename = filename
      @arguments = Array(arguments)
    end

    def options
      parse
      options!
    end

    def to_s
      parser.help + "\n"
    end

    private 

    attr_reader :filename, :arguments

    def options!
      @options ||= default_options
    end

    def default_options
      OpenStruct.new mode: ''
    end

    def parse
      return options!.mode = :help if arguments.empty?
      parser.parse arguments
    rescue OptionParser::InvalidOption => exception
      options!.mode = :help
      options!.warnings = red(exception.message.capitalize + '. Try --help for help.')
    end

    def parser
      OptionParser.new do |parser|
        parser.banner = ''
        parser.separator green('  Usage: ') + bold("#{filename} [options]")
        parser.separator ''
        parser.separator green '  Example:  '
        parser.separator '    ' + bold("#{filename} --name twitter")
        parser.separator '    ' + bold("#{filename} twitter") + '                      # Generate 6-digit OTP code for key with name twitter'
        parser.separator '    ' + bold("#{filename} --list")
        parser.separator ''
        parser.separator green '   Options:'
        
        parser.on('-l', '--list', 'List the names of all the keys in the keychain') do
          options!.mode = :list
        end

        parser.on('-n', '--name [NAME]', 'Add new key to the keychain') do |name|
          options!.mode = :name
          options!.name = name
        end

        parser.on_tail('-h', '--help', 'Show this message') do
          options!.mode = :help
        end
      end
    end

    def bold(string)
      "\033[1m#{string}\033[22m"
    end

    def green(string)
      "\033[32m#{string}\033[0m"
    end

    def red(string)
      "\033[31m#{string}\033[0m"
    end
  end
end
