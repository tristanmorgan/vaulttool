# frozen_string_literal: true

require 'thor'

require 'vault'
require 'vaulttool'
require 'vaulttool/version'
require 'awskeyring/input'

# Vaulttool command line interface.
class VaulttoolCommand < Thor # rubocop:disable Metrics/ClassLength

  map %w[--version -v] => :__version
  map %w[--help -h] => :help

  desc '--version, -v', 'Prints the version'
  # print the version number
  def __version
    puts "Vaulttool v#{Vaulttool::VERSION}"
    puts "Homepage #{Vaulttool::HOMEPAGE}"
  end

  desc 'login', 'Login to Vault'
  # print the version number
  def login
    password = Awskeyring::Input.read_secret("password for #{ENV['USER']}".rjust(20) + ': ')

    token = Vault.auth.ldap(ENV['USER'], password)

    File.write(Vault::Default.VAULT_DISK_TOKEN, token.auth.client_token)
  end

  desc 'renew', 'Renew you Vault Token'
  # print the version number
  def renew
    token = Vault.auth_token.renew_self

    File.write(Vault::Default.VAULT_DISK_TOKEN, token.auth.client_token)

  end
end
