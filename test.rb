require './lib/travel'

result = Travel
  .new
  .with_dates("10/08/2024", "15/08/2024")
  .from("Macaé - RJ")
  .to("Porto Alegre - RS")
  .plan!

if result[:pdf_path]
  puts "PDF generated successfully: #{result[:pdf_path]}"
else
  puts "Error: #{result[:error]}"
end
