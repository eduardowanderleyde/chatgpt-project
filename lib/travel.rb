require './lib/services/open_ai_service'
require './lib/utils/prompt_util'
require 'prawn'
require 'tempfile'

class Travel
  def with_dates(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    self
  end

  def from(origin)
    @origin = origin
    self
  end

  def to(destination)
    @destination = destination
    self
  end

  def plan!
    validate_inputs
    itinerary = fetch_travel_itinerary
    weather = fetch_weather
    violence = fetch_violence_info
    best_way = fetch_best_way

    data = {
      travel_itinerary: itinerary,
      weather: weather,
      violence_info: violence,
      best_way: best_way
    }

    generate_pdf(data)
  rescue StandardError => e
    { error: e.message }
  end

  private

  def validate_inputs
    raise 'Start date is missing' unless @start_date
    raise 'End date is missing' unless @end_date
    raise 'Origin is missing' unless @origin
    raise 'Destination is missing' unless @destination
  end

  def fetch_travel_itinerary
    prompt = Utils::Prompt.itinerary_text(@destination, @start_date, @end_date)
    OpenAiService.new.call(prompt)
  end

  def fetch_weather
    prompt = Utils::Prompt.weather_text(@start_date, @destination)
    OpenAiService.new.call(prompt)
  end

  def fetch_violence_info
    prompt = Utils::Prompt.violence_text(@destination)
    OpenAiService.new.call(prompt)
  end

  def fetch_best_way
    prompt = Utils::Prompt.best_way_text(@origin, @destination)
    OpenAiService.new.call(prompt)
  end

  def generate_pdf(data)
    pdf = Prawn::Document.new
    pdf.text "Travel Itinerary", size: 20, style: :bold
    pdf.move_down 10
    pdf.text "Destination: #{@destination}", size: 15
    pdf.text "From: #{@start_date}", size: 15
    pdf.text "To: #{@end_date}", size: 15
    pdf.move_down 10
    pdf.text "Itinerary:", size: 15, style: :bold
    pdf.text data[:travel_itinerary]
    pdf.move_down 10
    pdf.text "Weather:", size: 15, style: :bold
    pdf.text data[:weather]
    pdf.move_down 10
    pdf.text "Security Information:", size: 15, style: :bold
    pdf.text data[:violence_info]
    pdf.move_down 10
    pdf.text "Best Way to Travel:", size: 15, style: :bold
    pdf.text data[:best_way]

    tempfile = Tempfile.new(['travel_itinerary', '.pdf'])
    pdf.render_file(tempfile.path)

    { pdf_path: tempfile.path }
  end
end
