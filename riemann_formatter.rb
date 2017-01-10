require 'riemann/client'

class RiemannFormatter

  RSpec::Core::Formatters.register self, :example_passed, :example_failed

  def initialize(_output)
    @client = Riemann::Client.new host: 'localhost', port: 5555, timeout: 5
  end

  def example_passed(notification)
    @client.tcp << format_example(notification.example)
  end

  def example_failed(notification)
    @client.tcp << format_example(notification.example)
  end

  private

  def format_example(example)
    {
      :description => example.full_description,
      :service => example.full_description,
      :state => example.execution_result.status.to_s,
      :tags => [:rspec],
      :ttl => 300,
    }
  end
end
