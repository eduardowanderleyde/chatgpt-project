require 'net/http'
require 'uri'
require 'net/http/post/multipart'

def send_pdf(file_path)
  uri = URI.parse("http://localhost:4567/upload_pdf")
  File.open(file_path) do |file|
    request = Net::HTTP::Post::Multipart.new uri.path,
                                             "file" => UploadIO.new(file, "application/pdf", File.basename(file_path))
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"
  end
end

send_pdf("/path/to/your/pdf/file.pdf")
