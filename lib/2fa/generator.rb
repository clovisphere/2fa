require 'base64'
require 'rotp'

module TwoFactorAuth
  class Generator
    attr_reader :file
    attr_accessor :keys

    def initialize(file, keys=Hash.new(''))
      @file = file
      @keys = keys
    end

    def add(name, size=6)
      if keys.include? name
        return red "Error: '#{name}' already exists in keychain"
      end
      print "2fa key for #{name}: "
      passphrase = STDIN.gets.chop.downcase
      passphrase = self.encode(passphrase.gsub(/\s/, ''))
      begin
        self.decode(passphrase)
      rescue ArgumentError => e
        return red "Error: #{e.message}"
      end
      # if all goes well, save to file
      File.open(file, 'a') do |f|
        line = "#{name} #{size} #{passphrase}".bytes
        f.print line, f.puts
        "\t#{name} was added successfully to the keychain ✅" if File.chmod(0600, file)
      end
    end

    def display(name)
      key = keys[name]
      if key.empty?
        red "Error: no such key '#{name}'"
      else
        totp = ROTP::TOTP.new(decode(key[:secret]), issuer: name)
        totp.now
      end
    end

    def display_all
      if keys.length > 0
        names = ''
        keys.each_key { |key| if key then names.concat(key).concat(' ') end }
        names.split(' ')
      else
        red 'No keys in the keychain'
      end
    end

    private

    def encode(bin)
      Base64.strict_encode64(bin)
    end

    def decode(str)
      Base64.strict_decode64(str)
    end

    def red(string)
      "\033[31m#{string}\033[0m"
    end
  end
end
