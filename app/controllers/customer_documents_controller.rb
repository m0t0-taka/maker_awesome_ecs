class CustomerDocumentsController < ApplicationController
  before_action :set_customer_document, only: %i[show edit update destroy]

  def index
    @customer = Customer.where(id: params[:customer_id]).first
    @customer_documents = @customer.customer_documents.all
    if params[:general]
      @documents = @customer_documents.where(public_level: 0)
    elsif params[:technical]
      @documents = @customer_documents.where(public_level: 1)
    end
  end

  def show; end

  def new
    @customer = Customer.where(id: params[:customer_id]).first
    @customer_document = @customer.customer_documents.build
  end

  def edit; end

  def create
    @customer = Customer.where(id: params[:customer_id]).first
    @customer_document = @customer.customer_documents.build(customer_document_params)
    @customer_document.user_id = current_user.id

    respond_to do |format|
      if @customer_document.save
        format.html { redirect_to [@customer, @customer_document], notice: "Customer document was successfully created." }
        format.json { render :show, status: :created, location: @customer_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @customer_document.update(customer_document_params)
        format.html { redirect_to [@customer, @customer_document], notice: "Customer document was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer_document.destroy
    respond_to do |format|
      # if @customer_document.public_level == 0
      #   format.html { redirect_to customer_customer_documents_path(general: "true"), notice: "Customer document was successfully destroyed." }
      #   format.json { head :no_content }
      # elsif @customer_document.public_level == 1
      #   format.html { redirect_to customer_customer_documents_path(technical: "true"), notice: "Customer document was successfully destroyed." }
      #   format.json { head :no_content }
      # end
      case @customer_document.public_level
      when 0
        format.html { redirect_to customer_customer_documents_path(general: "true"), notice: "Customer document was successfully destroyed." }
        format.json { head :no_content }
      when 1
        format.html { redirect_to customer_customer_documents_path(technical: "true"), notice: "Customer document was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_customer_document
    @customer = Customer.where(id: params[:customer_id]).first
    @customer_document = @customer.customer_documents.where(id: params[:id]).first
  end

  def customer_document_params
    params.require(:customer_document).permit(:name, :content, :public_level, :user_id, :customer_id, :document, :document_cache)
  end
end