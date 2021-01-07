require 'minitest/autorun'
require 'minitest/pride'
require './lib/patron'
require './lib/museum'
require './lib/exhibit'
require 'mocha/minitest'

class MuseumTest < Minitest::Test

  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Museum, @dmns
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
  end

  def test_exhibits_can_be_added
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits

  end

  def test_recomend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_patrons_are_held_by_museum_class
    assert_equal [], @dmns.patrons
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_patrons_interets
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal [@patron_1], @dmns.patron_interests(@gems_and_minerals)
  end

  def test_patrons_by_exhibit_interest
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    expected = {@gems_and_minerals=> [@patron_1],
                @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
                @imax => []}
    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_ticket_lottery_contestants
    patron_1 = Patron.new("Bob", 0)
    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal [patron_1, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
    # changed patron_1 scope because his spending_money had changed
  end

  def test_draw_lottery_winner
    patron_1 = Patron.new("Bob", 0)
    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    johnny = mock
    johnny.expects(name).returns("Johnny")

    assert_equal nil, @dmns.draw_lottery_winner(@gems_and_minerals)
    # @dmns.stub(:draw_lottery_winner).returns("Jonny")
    assert_equal johnny, @dmns.draw_lottery_winner(@dead_sea_scrolls)

  end

  def test_announce_lottery_winnner
    patron_1 = Patron.new("Bob", 0)
    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal "Bob has won the IMAX exhibit lottery", @dmns.announce_lottery_winner(@imax)
    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)
  end
end
