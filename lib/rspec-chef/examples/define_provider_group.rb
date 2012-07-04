module RSpec
  module Chef
    module DefineProviderGroup
      include RSpec::Chef::Matchers
      include JSONSupport
      include ChefSupport

      def subject
        @provider ||= provider
      end

      def node
        subject.node
      end

      def provider
        raise "must define :resource" unless self.respond_to?(:resource)
        raise "must define :action" unless self.respond_to?(:action)

        ::Chef::Log.level = self.respond_to?(:log_level) ? log_level : RSpec.configuration.log_level
        path = self.respond_to?(:cookbook_path) ? cookbook_path : RSpec.configuration.cookbook_path
        dna = ::Chef::Mixin::DeepMerge.merge(
          RSpec.configuration.default_attributes,
          json(self.respond_to?(:json_attributes) ? json_attributes : RSpec.configuration.json_attributes)
        )

        provider_name = self.class.top_level_description.downcase
        provider = lookup_provider(provider_name, path, dna, resource)

        method = "action_#{action}"
        provider.send(method)

        provider
      end
    end
  end
end
