class Spree::StockEmailsController < ApplicationController
  def create
    variant = Spree::Variant.find_by(id: stock_email_params[:variant])
    render :json => { errors: 'No variant found' }, status: :unprocessable_entity and return unless variant

    current_email = spree_current_user ? spree_current_user.email : stock_email_params[:email]
    stock_email = Spree::StockEmail.new(variant: variant, email: current_email)
    if stock_email.save
      render json: { message: Spree.t('stock_email.messages.back_in_stock_email_message', product: variant.product.name) }
    else
      render json: { errors: stock_email.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def stock_email_params
      params.require(:stock_email).permit([:variant, :email])
    end
end
