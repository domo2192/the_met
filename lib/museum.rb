class Museum
  attr_reader:name,
             :exhibits,
             :patrons
  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.find_all do |exhibit|
       patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron
  end

  def patron_interests(exhibit)
    @patrons.find_all do |patron|
      patron.interests.include?(exhibit.name)
    end
  end

  def patrons_by_exhibit_interest
    @exhibits.reduce({}) do |acc, exhibit|
      if acc[exhibit].nil?
        acc[exhibit] = patron_interests(exhibit)
      end
      acc
    end
  end

  def ticket_lottery_contestants(exhibit)
    @patrons.find_all do |patron|
      patron.spending_money < exhibit.cost
    end
  end

  def draw_lottery_winner(exhibit)
    y = ticket_lottery_contestants(exhibit)
    x = y.sample
    if x == nil
      return nil
    else
      x.name
    end
  end

  def announce_lottery_winner(exhibit)
    if draw_lottery_winner(exhibit) == nil
       "No winners for this lottery"
    else draw_lottery_winner(exhibit) + " has won the #{exhibit.name} exhibit lottery"
    end
  end
end
