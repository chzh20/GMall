class ProductsController < ApplicationController
    before_action :validate_search_key, only: [:search]
    def index
        @products = Product.all
    end
    def show
        @product = Product.find(params[:id])       
    end
    
    def add_to_cart
        @product = Product.find(params[:id])
        if !current_cart.products.include?(@product)
          current_cart.add_product_to_cart(@product)
          flash[:notice] = "商品已经成功加入购物车"
          flash[:notice] = "已将 #{@product.title}加入购物车"
        else
          flash[:notice] = "#{@product.title} 已在购物车中"
        end
        redirect_to :back
    end
    def search
       @products = Product.where(id:-1)
       if @query_string.present?
         search_result = Product.ransack(@search_criteria).result(:distinct => true)
         @products = search_result.paginate(:page => params[:page], :per_page => 5 )
       end
       render :index
    end

    protected

    def validate_search_key
       @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
       @search_criteria = search_criteria(@query_string)
    end

    def search_criteria(query_string)
       { :title_cont => query_string }
    end
end
