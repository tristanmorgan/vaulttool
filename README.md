# Vaulttool

This is a demo of using [Awskeyring](https://github.com/vibrato/awskeyring) as a Gem dependancy and as a little tool that helps interact with [HashiCorp Vault](https://vaultproject.io/). It is also, generally a place where I'm stuffing useful features that don't belong in Awskeyring.

## Installation

Install it with:

    $ gem install vaulttool --user-install

## Usage

Again the CLI is using [Thor](http://whatisthor.com) with help provided interactively.

    Commands:
      vaulttool --version, -v    # Prints the version
      vaulttool console          # Open the AWS Console
      vaulttool creds ROLE       # Retrieve IAM credentials for AWS from Vault
      vaulttool env              # Outputs bourne shell environment exports
      vaulttool exec command...  # Execute an external command with env set
      vaulttool help [COMMAND]   # Describe available commands or one specific command
      vaulttool login            # Login to Vault
      vaulttool renew            # Renew you Vault Token
      vaulttool sts ROLE         # Retrieve STS credentials for AWS from Vault

## Development

After checking out the repo, run `bundle update` to install dependencies. Then, run `rake` to run the tests. Run `bundle exec vaulttool` to use the gem in this directory, ignoring other installed copies of this gem. Vaulttool is tested against the last two versions of Ruby shipped with macOS.

To install this gem onto your local machine, run `bundle exec rake install`.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
