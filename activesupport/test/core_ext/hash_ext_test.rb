require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/active_support/core_ext/hash'

class HashExtTest < Test::Unit::TestCase
  def setup
    
    @strings = { 'a' => 1, 'b' => 2 }
    @symbols = { :a  => 1, :b  => 2 }
    @mixed   = { :a  => 1, 'b' => 2 }
  end

  def test_methods
    h = {}
    assert_respond_to h, :symbolize_keys
    assert_respond_to h, :symbolize_keys!
    assert_respond_to h, :stringify_keys
    assert_respond_to h, :stringify_keys!
    assert_respond_to h, :to_options
    assert_respond_to h, :to_options!
  end

  def test_symbolize_keys
    assert_equal @symbols, @symbols.symbolize_keys
    assert_equal @symbols, @strings.symbolize_keys
    assert_equal @symbols, @mixed.symbolize_keys

    assert_raises(NoMethodError) { { [] => 1 }.symbolize_keys }
  end

  def test_symbolize_keys!
    assert_equal @symbols, @symbols.dup.symbolize_keys!
    assert_equal @symbols, @strings.dup.symbolize_keys!
    assert_equal @symbols, @mixed.dup.symbolize_keys!

    assert_raises(NoMethodError) { { [] => 1 }.symbolize_keys }
  end

  def test_stringify_keys
    assert_equal @strings, @symbols.stringify_keys
    assert_equal @strings, @strings.stringify_keys
    assert_equal @strings, @mixed.stringify_keys
  end

  def test_stringify_keys!
    assert_equal @strings, @symbols.dup.stringify_keys!
    assert_equal @strings, @strings.dup.stringify_keys!
    assert_equal @strings, @mixed.dup.stringify_keys!
  end

  def test_indifferent_access
    @strings = @strings.with_indifferent_access
    @symbols = @symbols.with_indifferent_access
    @mixed   = @mixed.with_indifferent_access
  
    assert_equal @strings[:a], @strings['a']
    assert_equal @symbols[:a], @symbols['a']
    assert_equal @strings['b'], @mixed['b']
    assert_equal @strings[:b], @mixed['b']
  end
  
  def test_indifferent_writing
    hash = HashWithIndifferentAccess.new
    hash[:a] = 1
    hash['b'] = 2
    hash[3] = 3
    
    assert_equal hash['a'], 1
    assert_equal hash['b'], 2
    assert_equal hash[:a], 1
    assert_equal hash[:b], 2
    assert_equal hash[3], 3
  end

  def test_assert_valid_keys
    assert_nothing_raised do
      { :failure => "stuff", :funny => "business" }.assert_valid_keys([ :failure, :funny ])
    end
    
    assert_raises(ArgumentError, "Unknown key(s): failore") do
      { :failore => "stuff", :funny => "business" }.assert_valid_keys([ :failure, :funny ])
    end
  end
end
