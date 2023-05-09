require 'json'

class Ticket
  def initialize(details)
    @ticket = parse(details)
  end

  def name
    @ticket.fetch(:name)
  end

  def description
    @ticket.fetch(:description)
  end

  def priority
    @ticket.fetch(:priority)
  end

  def completed?
    @ticket.fetch(:completed)
  end

  def to_json(_options)
    { name: name, description: description, priority: priority, completed: completed? }.to_json
  end

  def to_s
    emoji = completed? ? '✅' : '🔳'
    str = "#{emoji} #{priority}. << #{name} >>"
    str << "\n\n\s\s#{description}\n\n" unless description.empty?
    str
  end

  def placeholder?
    false
  end

  private

  def parse(details)
    details = details.transform_keys(&:to_sym)
    {
      name: details.fetch(:name),
      description: details.fetch(:description),
      priority: details.fetch(:priority),
      completed: details.fetch(:completed)
    }
  end
end
