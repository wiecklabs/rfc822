require File.expand_path(File.dirname(__FILE__) + "/helper")

class AddressTest < Test::Unit::TestCase

  def test_parse_simple_email
    email = RFC822::Address.parse("john@example.com")[0]
    assert_equal "john@example.com", email.address
  end

  def test_parse_address_with_display_name
    email = RFC822::Address.parse('"John Doe" <john@example.com>')[0]
    assert_equal "john@example.com", email.address
    assert_equal "John Doe", email.name
  end

  def test_parse_address_with_tricky_display_name
    email = RFC822::Address.parse('"John\"<> Doe" <john@example.com>')[0]
    assert_equal "john@example.com", email.address
    assert_equal 'John\"<> Doe', email.name
  end

  def test_parse_address_with_comma_in_display_name
    email = RFC822::Address.parse('"John, Doe" <john@example.com>')[0]
    assert_equal "john@example.com", email.address
    assert_equal 'John, Doe', email.name
  end

  def test_parse_list_of_simple_addresses
    addresses = RFC822::Address.parse("john@example.com, jane@example.com")
    assert_equal "john@example.com", addresses[0].address
    assert_equal "jane@example.com", addresses[1].address
  end

  def test_parse_list_of_simple_addresses_with_no_space
    addresses = RFC822::Address.parse("john@example.com,jane@example.com")
    assert_equal "john@example.com", addresses[0].address
    assert_equal "jane@example.com", addresses[1].address
  end
  
  def test_parse_newline_separated_addresses
    addresses = RFC822::Address.parse("john@example.com\r\njane@example.com")
    assert_equal "john@example.com", addresses[0].address
    assert_equal "jane@example.com", addresses[1].address
  end

  def test_parse_comma_separated_addresses_with_display_names
    addresses = RFC822::Address.parse('"John" <john@example.com>, "Jane" <jane@example.com>')
    assert_equal "john@example.com", addresses[0].address
    assert_equal "John", addresses[0].name
    assert_equal "jane@example.com", addresses[1].address
    assert_equal "Jane", addresses[1].name
  end

  def test_parse_newline_separated_addresses_with_display_names
    addresses = RFC822::Address.parse("\"John\" <john@example.com>\r\n\"Jane\" <jane@example.com>")
    assert_equal "john@example.com", addresses[0].address
    assert_equal "John", addresses[0].name
    assert_equal "jane@example.com", addresses[1].address
    assert_equal "Jane", addresses[1].name
  end

  def test_parse_with_mixed_addresses
    addresses = RFC822::Address.parse("\"John\" <john@example.com>,jane@example.com\r\njames@example.com")
    assert_equal "john@example.com", addresses[0].address
    assert_equal "John", addresses[0].name
    assert_equal "jane@example.com", addresses[1].address
    assert_equal "james@example.com", addresses[2].address
  end

  def test_malformed_addresses
    email = RFC822::Address.build("John <john@example.com>")

    assert_equal "john@example.com", email.address
    assert_equal "John", email.name

    email = RFC822::Address.build("")
    assert_equal "", email.address

    email = RFC822::Address.build("John Doe <john@example.com")
    assert_equal "john@example.com", email.address

    email = RFC822::Address.build('"')
    assert_equal "", email.address
  end

  def test_split_addresses
    addresses = RFC822::Address.split("\r\n\"John\" <john@example.com>,jane@example.com\r\n\r\njames@example.com")
    assert_equal 3, addresses.size
    assert_equal ['"John" <john@example.com>', 'jane@example.com', 'james@example.com'], addresses
  end

  def test_split_with_comma_in_display_name
    addresses = RFC822::Address.split("\r\n\"John, Doe\" <john@example.com>,jane@example.com\r\n\r\njames@example.com")
    assert_equal 3, addresses.size
    assert_equal ['"John, Doe" <john@example.com>', 'jane@example.com', 'james@example.com'], addresses
  end

  def test_valid
    valid_emails = [
      "john@example.com",
      "first.last@sub.domain.co.au",
      "name+mailbox@domain.com"
    ]

    valid_emails.each do |email|
      assert RFC822::Address.new(email).valid?, "#{email} expected to be valid"
    end

    invalid_emails = [
      "j",
      "j<doe@example.com",
      "name@localhost"
    ]

    invalid_emails.each do |email|
      assert !RFC822::Address.new(email).valid?, "#{email} expected to be invalid"
    end
  end

end