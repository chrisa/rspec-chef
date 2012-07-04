module RSpec
  module Chef
    module ChefSupport

      include ::Chef::Mixin::ConvertToClassName

      def lookup_recipe(cookbook_name, cookbook_path, dna)
        recipe_name = ::Chef::Recipe.parse_recipe_name(cookbook_name)
        cookbook_collection = ::Chef::CookbookCollection.new(::Chef::CookbookLoader.new(*cookbook_path))
        node = ::Chef::Node.new
        node.consume_attributes(dna)

        run_context = ::Chef::RunContext.new(node, cookbook_collection)

        run_list = ::Chef::RunList.new(cookbook_name)
        silently do
          run_context.load(run_list.expand('_default', 'disk'))
        end

        cookbook = run_context.cookbook_collection[recipe_name[0]]
        cookbook.load_recipe(recipe_name[1], run_context)
      end

      def lookup_provider(provider_full_name, cookbook_path, dna, resource)
        match = provider_full_name.match(/^([^_]+)_(.+)$/)
        cookbook_name = match[1]
        provider_name = match[2]

        cookbook_collection = ::Chef::CookbookCollection.new(::Chef::CookbookLoader.new(*cookbook_path))
        node = ::Chef::Node.new
        node.consume_attributes(dna)

        run_context = ::Chef::RunContext.new(node, cookbook_collection)

        run_list = ::Chef::RunList.new(cookbook_name)
        silently do
          run_context.load(run_list.expand('_default', 'disk'))
        end

        provider_class = ::Chef::Provider.const_get(convert_to_class_name(provider_full_name))
        resource_class = ::Chef::Resource.const_get(convert_to_class_name(provider_full_name))

        new_resource = resource_class.new(resource['name'], run_context)
        resource.each do |k, v|
          new_resource.instance_variable_set("@#{k}".to_sym, v)
        end

        provider_class.new(new_resource, run_context)
      end

      private

      def silently
        begin
          verbose = $VERBOSE
          $VERBOSE = nil
          yield
        ensure
          $VERBOSE = verbose
        end
      end
    end
  end
end
