module RFC822
  VERSION = "1.0"

  ATOM = '[^\(\)\<\>@,;:\\\\.\[\] ]'.freeze

  # NOTE: This is simplified from the RFC822 guidelines,
  #       because we're not allowing for quoted mailbox names.
  LOCAL_PART = "#{ATOM}+(\\.#{ATOM}+)*".freeze

  # NOTE: This is simplified from the RFC822 guidelines,
  #       because we're not allowing for quoted domains.
  SUBDOMAIN = "#{ATOM}".freeze

  # NOTE: We require domains to have more than 1 part, since
  #       an address like "john@localhost" would be an invalid
  #       user email address, though it is technically valid.
  DOMAIN = "#{SUBDOMAIN}+(\\.#{SUBDOMAIN}+)+".freeze

  ADDR_SPEC = Regexp.new("^#{LOCAL_PART}@#{DOMAIN}$").freeze
end

require "rfc822/address"