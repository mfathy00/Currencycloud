class RecipientsController < ApplicationController
  before_filter :authorize
  before_action :set_recipient, only: [:show, :edit, :update, :destroy]

  # GET /recipients
  # GET /recipients.json
  def index
    @recipients = Recipient.all
  end

  # GET /recipients/1
  # GET /recipients/1.json
  def show
  end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
    #
  end

  # GET /recipients/1/edit
  def edit
  end

  # POST /recipients
  # POST /recipients.json
  def create
    update_params = recipient_params.merge(ref_recipient_id: ref_recipient_id)
    @recipient = Recipient.new(update_params)
    respond_to do |format|
      if @recipient.save
        format.html { redirect_to @recipient, notice: 'Recipient was successfully created.' }
      else
        flash.now[:alert] = "Error while creating recipient"
      end
    end
  end

  # PATCH/PUT /recipients/1
  # PATCH/PUT /recipients/1.json
  def update
    respond_to do |format|
      if @recipient.update(recipient_params)
        format.html { redirect_to @recipient, notice: 'Recipient was successfully updated.' }
      else
        flash.now[:alert] = "Error while creating recipient"
      end
    end
  end

  # DELETE /recipients/1
  # DELETE /recipients/1.json
  def destroy
    @recipient.destroy
    respond_to do |format|
      format.html { redirect_to recipients_url, notice: 'Recipient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient
      @recipient = Recipient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recipient_params
      params.require(:recipient).permit(:name, :ref_recipient_id)
    end

    def ref_recipient_id
      values = '{"recipient": {"name": "' + recipient_params[:name] + '"} }'
      headers = { content_type: 'application/json', authorization: "Bearer " + valid_token["token"]}
      response = JSON.parse(RestClient.post('https://coolpay.herokuapp.com/api/recipients', values, headers))
      recipient = response["recipient"]
      ref_recipient_id = recipient["id"]
      ref_recipient_id
    end
end
