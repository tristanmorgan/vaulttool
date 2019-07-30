# frozen_string_literal: true

require 'vault'
require 'pathname'

# Vaulttool Module,
module Vaulttool
  VAULT_CONFIG = Pathname.new("#{ENV['HOME']}/.vault").expand_path.freeze

  # Stored the Vault token using the configured vault token helper
  # or fall back to the ~/.vault-token file
  #
  # @param [String] token The token retrieved from vault to store
  def self.store(token)
    if VAULT_CONFIG.exist? && VAULT_CONFIG.readable?
      VAULT_CONFIG.each_line do |line|
        # token_helper = "/Users/tristan/.vault-security.sh"
        if /token_helper\s*=\s*.*/.match?(line)
          output = system("echo #{line.split('=')[1]} store #{token}")
          puts "testing #{output} done."
        end
      end
    else
      File.write(Vault::Default.VAULT_DISK_TOKEN, token)
    end
  end

  # Checks a password against the Pwned Passwords list by querying with its sha hash
  #
  # @param [String] password The potentially weak password
  def self.passcheck(password)
    sha1 = OpenSSL::Digest.new('SHA1')
    digest = sha1.digest(password).unpack1('H*').upcase

    uri       = URI("https://api.pwnedpasswords.com/range/#{digest[0..4]}")
    request   = Net::HTTP.new(uri.host, uri.port)
    request.use_ssl = true
    returned_content = request.get(uri).body

    raise 'insecure password' if returned_content.include?(digest[5..-1])

    password
  end
end
