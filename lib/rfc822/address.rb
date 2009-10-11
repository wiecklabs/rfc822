class RFC822::Address

  TERMINALS = [?,, ?\r, ?\n].freeze
  TERMINALS_WITH_SPACE = (TERMINALS + [?\s]).freeze

  def self.parse(addresses)
    split(addresses).map { |address| build(address) }
  end

  def self.build(address)
    i = 0
    buffer = ""
    mark = i
    email = new

    while i <= address.length
      case address[i]
      when ?" # okay! we've got the display name, so let's skip ahead
        mark = i += 1

        # We jump forward until we hit an un-escaped quote character...
        i += 1 until (address[i] == ?" && address[i - 1] != ?\\) || !address[i]

        email.name = address[mark..i - 1]
      when ?<
        if !email.name && mark < i
          email.name = address[mark..i - 1].strip
        end

        mark = i += 1

        i += 1 until address[i] == ?> || !address[i]

        email.address = address[mark..i - 1]
        break
      end

      if !address[i + 1]
        email.address = address[mark..i]
        break
      end

      i += 1
    end

    email
  end

  def self.split(string)
    emails = []

    i = 0
    mark = nil
    in_display_name = false

    while i <= string.length
      if !mark
        i += 1 while TERMINALS_WITH_SPACE.include?(string[i])
      end

      mark ||= i

      char = string[i]

      case
      when !in_display_name && char == ?"
        in_display_name = true
      when in_display_name && char == ?" && string[i - 1] != ?\\
        in_display_name = false
      when !in_display_name && TERMINALS.include?(char)
        emails << string[mark..i - 1]
        mark = nil
      when !string[i + 1]
        emails << string[mark..i]
        break
      end

      i += 1
    end

    emails
  end

  attr_accessor :address, :name

  def initialize(address = nil, name = nil)
    @address = address || ""
    @name = name
  end

  def to_s
    name ? "\"#{@name}\" <#{@address}>" : "#{@address}"
  end

  ##
  # Email validator, with some minor simplifications from RFC 822
  # (http://www.faqs.org/rfcs/rfc822.html).
  # 
  # Since we've already parse the display name form the address we
  # validate the address directly.
  # 
  # DEVIATIONS FROM SPEC:
  #   No quoted LOCAL_PART or DOMAIN
  #   Single part domains (name@localhost) are invalid
  ##
  def valid?
    !!(@address =~ RFC822::ADDR_SPEC)
  end
end