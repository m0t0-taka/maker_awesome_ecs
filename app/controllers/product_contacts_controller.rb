class ProductContactsController < ApplicationController
  def create
    # raise
    # binding.irb
    @user = current_user
    @product = Product.find(params[:product_id])
    @product_contact = @product.product_contacts.build(product_contact_params)
    respond_to do |format|
      if @product_contact.save
        format.js { render :index }
      else
        format.html { redirect_to product_path(@product), notice: '投稿できませんでした' }
      end
    end
  end
  
  private

  def product_contact_params
    params.require(:product_contact).permit(:product_id, :contact_message).merge(user_id: current_user.id)
  end
end
