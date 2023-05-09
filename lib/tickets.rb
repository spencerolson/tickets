require 'json'
require 'tty-prompt'

require_relative 'ticket'
require_relative 'placeholder_ticket'

class Tickets
  def initialize
    @prompt = TTY::Prompt.new
    @filename = File.join(File.dirname(__FILE__), '../tickets.json')

    begin
      @tickets = JSON.parse(File.read(@filename)).map do |ticket|
        Ticket.new(ticket)
      end
    rescue StandardError => e
      @tickets = []
    end
  end

  def run(options)
    if options[:add]
      add
    elsif options[:edit]
      edit
    elsif options[:delete]
      delete
    elsif options[:list]
      list
    else
      main_menu
    end
  end

  private

  def main_menu
    choices = {
      "Add a ticket" => :add,
      "Edit a ticket" => :edit,
      "Delete a ticket" => :delete,
      "List tickets" => :list,
      "Quit" => :quit
    }
    action = @prompt.select("What do you want to do?", choices, cycle: true)
    send(action)
    main_menu unless action == :quit
  end

  def add
    clear
    set_ticket_details(PlaceholderTicket.new)
    clear
  end

  def edit
    clear
    name = select_ticket("Which ticket do you want to edit?") do
      puts "No tickets to edit. Add one first."
      return
    end

    clear and return if name == main_menu_option

    ticket = @tickets.find { |ticket| ticket.name == name }
    set_ticket_details(ticket)
    clear
  end

  def delete
    clear
    name = select_ticket("Which ticket do you want to delete?") do
      puts "No tickets to edit. Add one first."
      return
    end

    clear and return if name == main_menu_option

    @tickets.reject! { |ticket| ticket.name == name }
    write_file
    clear
  end

  def list
    clear
    ordered_tickets.each { |ticket| puts ticket }
    puts ""
  end

  def select_ticket(prompt)
    yield if @tickets.empty?

    options = ordered_tickets.map(&:name)
    ticket_name = @prompt.select(prompt, options_with_main_menu(options))
  end

  def set_ticket_details(ticket)
    name = @prompt.ask("Ticket name:", required: true, default: ticket.name)
    description = @prompt.ask("Ticket description:", default: ticket.description)
    priority = @prompt.ask("Ticket Priority:", convert: :integer, required: true, default: ticket.priority)
    completed = @prompt.ask("Completed?", convert: :boolean, required: true, default: ticket.completed?)
    save_ticket(name: name, description: description, priority: priority, completed: completed)
  end

  def quit
    @prompt.say("Bye bye!")
  end

  def clear
    system "clear"
    true
  end

  def write_file
    File.write(@filename, @tickets.to_json)
  end

  def save_ticket(attrs)
    ticket = Ticket.new(attrs)
    @tickets.unshift(ticket)
    @tickets.uniq! { |ticket| ticket.name }
    write_file
  end

  def ordered_tickets
    @tickets.sort_by(&:priority)
  end

  def main_menu_option
    "🏠 Main Menu"
  end

  def options_with_main_menu(options)
    options + [main_menu_option]
  end
end
