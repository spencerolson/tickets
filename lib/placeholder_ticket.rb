class PlaceholderTicket < Ticket
  def initialize
    super(name: "", description: "", priority: "1", completed: "false")
  end

  def placeholder?
    true
  end
end
