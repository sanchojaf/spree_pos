Spree::OrdersController.class_eval do
  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], params[:quantity])
      current_order.ensure_updated_shipments

      respond_with(@order) do |format|
        format.html { redirect_to spree.root_path }
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_to :back
    end
  end
end
