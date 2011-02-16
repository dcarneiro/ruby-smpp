require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "../../lib/smpp")

class EncodingTest < Test::Unit::TestCase

  def test_should_decode_pound_sign_from_hp_roman_8_to_utf_8
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 2950 6C65 6173 6520
    6465 706F 7369 7420 BB35 2069 6E74 6F20
    6D79 2061 6363 6F75 6E74 2C20 4A6F 73C5
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    expected = "Please deposit \302\2435 into my account, Jos\303\251"
    assert_equal expected, pdu.short_message
  end

  def test_should_unescape_gsm_escaped_euro_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 1950 6c65 6173 6520
    6465 706f 7369 7420 8d65 3520 7468 616e
    6b73
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    expected = "Please deposit \342\202\2545 thanks"
    assert_equal expected, pdu.short_message
  end

  def test_should_unescape_gsm_escaped_left_curly_bracket_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 28
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "{", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_right_curly_bracket_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 29
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "}", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_tilde_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 7e
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "~", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_left_square_bracket_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 5b
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "[", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_right_square_bracket_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 5d
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "]", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_backslash_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 5c
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "\\", pdu.short_message
  end

  def test_should_unescape_gsm_escaped_vertical_bar_symbol
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0000 028d 7c
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 0, pdu.data_coding

    assert_equal "|", pdu.short_message
  end

  def test_should_convert_ucs_2_into_utf_8_where_data_coding_indicates_its_presence
    raw_data = <<-EOF
    0000 003d 0000 0005 0000 0000 0000 0002
    0001 0134 3437 3830 3330 3239 3833 3700
    0101 3434 3738 3033 3032 3938 3337 0000
    0000 0000 0000 0800 0E00 db00 f100 ef00
    e700 f800 6401 13
    EOF

    pdu = create_pdu(raw_data)
    assert_equal Smpp::Pdu::DeliverSm, pdu.class
    assert_equal 8, pdu.data_coding

    expected = "\303\233\303\261\303\257\303\247\303\270d\304\223" # Ûñïçødē
    assert_equal expected, pdu.short_message
  end

  protected
  def create_pdu(raw_data)
    hex_data = [raw_data.chomp.gsub(" ","").gsub(/\n/,"")].pack("H*")
    Smpp::Pdu::Base.create(hex_data)
  end

end