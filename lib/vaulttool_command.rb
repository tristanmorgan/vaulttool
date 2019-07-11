# frozen_string_literal: true

require 'awskeyring/awsapi'
require 'awskeyring/input'
require 'thor'
require 'vault'
require 'vaulttool'
require 'vaulttool/version'

# Vaulttool command line interface.
class VaulttoolCommand < Thor
  map %w[--version -v] => :__version
  map %w[--help -h] => :help

  desc '--version, -v', 'Prints the version'
  # print the version number
  def __version
    puts "Vaulttool v#{Vaulttool::VERSION}"
    puts "Homepage #{Vaulttool::HOMEPAGE}"
  end

  desc 'login', 'Login to Vault'
  # Login to Vault
  def login
    password = Awskeyring::Input.read_secret("password for #{ENV['USER']}".rjust(20) + ': ')

    Vaulttool.passcheck(password)

    token = Vault.auth.ldap(ENV['USER'], password)

    Vaulttool.store(token.auth.client_token) unless token.nil?
  end

  desc 'renew', 'Renew you Vault Token'
  # Renew you Vault Token
  def renew
    token = Vault.auth_token.renew_self

    Vaulttool.store(token.auth.client_token) unless token.nil?
  end

  desc 'creds ROLE', 'Retrieve IAM credentials for AWS from Vault'
  # Retrieve IAM credentials for AWS from Vault
  def creds(role)
    creds = Vault.logical.read("aws/creds/#{role}")

    creds.data[:access_key]
    creds.data[:secret_key]

    Awskeyring.add_account(
      account: 'vaulttool',
      key: creds.data[:access_key],
      secret: creds.data[:secret_key],
      mfa: ''
    )
  end

  desc 'sts ROLE', 'Retrieve STS credentials for AWS from Vault'
  # Retrieve STS credentials for AWS from Vault
  def sts(role)
    creds = Vault.logical.read("aws/sts/#{role}")

    creds.data[:access_key]
    creds.data[:secret_key]
    creds.data[:security_token]

    Awskeyring.add_token(
      account: 'vaulttool',
      key: creds.data[:access_key],
      secret: creds.data[:secret_key],
      token: creds.data[:security_token],
      expiry: (Time.new + Awskeyring::Awsapi::ONE_HOUR).iso8601, # TODO
      role: role
    )
  end

  desc 'env', 'Outputs bourne shell environment exports'
  # Print Env vars
  def env
    cred = Awskeyring.get_valid_creds(account: 'vaulttool', no_token: false)
    put_env_string(cred)
  end

  desc 'exec command...', 'Execute an external command with env set'
  # execute an external command with env set
  def exec(*command)
    if command.empty?
      warn '# COMMAND not provided'
      exit 1
    end
    cred = Awskeyring.get_valid_creds(account: 'vaulttool', no_token: false)
    env_vars = Awskeyring::Awsapi.get_env_array(cred)
    begin
      pid = Process.spawn(env_vars, command.join(' '))
      Process.wait pid
      $CHILD_STATUS
    rescue Errno::ENOENT => e
      warn e.to_s
      exit 1
    end
  end

  private

  def put_env_string(cred)
    env_var = Awskeyring::Awsapi.get_env_array(cred)
    env_var.each { |var, value| puts "export #{var}=\"#{value}\"" }
    Awskeyring::Awsapi::AWS_ENV_VARS.each { |key| puts "unset #{key}" unless env_var.key?(key) }
  end
end
