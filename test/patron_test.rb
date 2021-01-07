require 'minitest/autorun'
require 'minitest/pride'
require './lib/exhibit'
require './lib/patron'

class PatronTest < Minitest::Test
  def setup
     @patron_1 = Patron.new("Bob", 20)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Patron, @patron_1
    assert_equal "Bob", @patron.name
    assert_equal 20, @patron.spending_money 
  end
end
