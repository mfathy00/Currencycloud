class PaymentsController < ApplicationController
  before_filter :authorize
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @recipient = params[:recipient]
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    update_params = payment_params.merge(ref_payment_id: ref_payment_id, status: payment_status)
    @payment = Payment.new(update_params)
    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
      else
        flash.now[:alert] = "Error transaction declined"
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def recipient
      Recipient.find(payment_params[:recipient_id])
    end

    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:amount, :currency, :ref_payment_id, :recipient_id, :status)
    end
    #i was facing 400 error HERE
    def payment_status
      payment["status"]
    end

    def ref_payment_id
      payment["id"]
    end

    def payment
      values = "{\"payment\": {\"amount\": #{payment_params[:amount]},\"currency\": \"#{payment_params[:currency]}\",\"recipient_id\": \"#{recipient.ref_recipient_id}\"}}"
      headers = { :content_type => 'application/json', :authorization => "Bearer " + valid_token["token"]}
      response = RestClient.post('https://coolpay.herokuapp.com/api/payments', values, headers)
      payment = JSON.parse(response)["payment"]
    end
end
