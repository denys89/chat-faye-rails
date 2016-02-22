class HomeController < ApplicationController
  def index
    @messages = Chat.all
  end

  def create
    chat = Hash.new
    chat = {
      'content' => params[:content]
    }

    datachat = Hash.new
    datachat ={
      'channel' => '/messages',
      'ext' => {:auth_token => FAYE_TOKEN},
      'data' => chat
    }

    chat = Chat.new
    chat.content = params[:content]
    chat.save

    sent_chat(datachat)
    render :json => chat
	end

	def sent_chat(json)
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => json.to_json)
	end
end
