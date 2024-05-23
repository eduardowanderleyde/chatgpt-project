require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Drive API Ruby Quickstart'
CREDENTIALS_PATH = 'credentials.json'
TOKEN_PATH = 'token.yaml'
SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_READONLY

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the resulting code after authorization:"
    puts url
    code = gets.chomp
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

def list_files_in_folder(folder_id)
  drive_service = Google::Apis::DriveV3::DriveService.new
  drive_service.client_options.application_name = APPLICATION_NAME
  drive_service.authorization = authorize

  response = drive_service.list_files(q: "'#{folder_id}' in parents and mimeType='application/pdf'",
                                      spaces: 'drive',
                                      fields: 'nextPageToken, files(id, name)',
                                      page_size: 10)
  response.files
end
