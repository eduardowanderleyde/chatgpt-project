require 'sinatra'
require 'pdf-reader'
require 'json'
require './lib/services/open_ai_service'

get '/' do
  erb :index
end

post '/upload_pdf' do
  file = params[:file][:tempfile]
  
  # Supondo que a primeira página seja o sumário
  summary_content = read_summary(file.path)
  prompt_response = OpenAiService.new.call("Identifique a página onde está o Ministério dos Transportes no sumário abaixo: #{summary_content}")
  
  page_number = extract_page_number(prompt_response)

  erb :result, locals: { prompt_response: prompt_response, page_number: page_number }
end

def read_summary(file_path)
  reader = PDF::Reader.new(file_path)
  summary_page = reader.pages.first.text  # Lê apenas a primeira página, que assumimos ser o sumário
  summary_page
end

def extract_page_number(gpt_response)
  # Ajusta a regex para capturar números de página no formato comum
  match = gpt_response.match(/Ministério dos Transportes.*?(\d+)/)
  match ? match[1] : "Page number not found"
end

set :port, 4567
