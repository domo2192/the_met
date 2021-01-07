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
    assert_equal "Bob", @patron_1.name
    assert_equal 20, @patron_1.spending_money
  end

  def test_patrons_start_with_an_empty_array_of_interests
    assert_equal [], @patron_1.interests
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    assert_equal ["Dead sea Scrolls", "Gems and Minirals"]
  end
end
