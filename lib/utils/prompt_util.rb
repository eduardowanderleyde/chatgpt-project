module Utils
  class Prompt
    def self.itinerary_text(destination, start_date, end_date)
      "I'm traveling to #{destination} on #{start_date} and returning on #{end_date}. Please help me plan my trip."
    end

    def self.weather_text(start_date, destination)
      "I'm traveling to #{destination} on #{start_date}. What is the weather like based on past data?"
    end

    def self.violence_text(destination)
      "I'm traveling to #{destination}. Based on past events, should I worry about security?"
    end

    def self.best_way_text(origin, destination)
      "I live in #{origin}. What is the best way to go to #{destination}?"
    end
  end
end
