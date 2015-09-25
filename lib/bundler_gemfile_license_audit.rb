require 'bundler_gemfile_license_audit/version'
require 'bundler_gemfile_license_audit/license'

module BundlerGemfileLicenseAudit
  module LicenceCheckerForInstall
    def self.prepended(base)
      class << base
        self.prepend(ClassMethods)
      end
    end

    module ClassMethods
      def install(root, definition, options = {})
        Bundler.ui.debug("bundler_gemfile_license_audit enabled.")
        Bundler.ui.debug("start checking dependency library licenses...")

        # TODO: use more good method.
        base_dep = Bundler.definition.dependencies.detect { |dep|
          path = dep.to_spec.source.options["path"]
          path && path == "."
        }

        if base_dep.nil?
          Bundler.ui.debug("base license: nil")
          Bundler.ui.debug("skip checking.")
          return super
        end

        base_spec = base_dep.to_spec
        Bundler.ui.debug("base license: #{base_spec.license.inspect}")
        Bundler.definition.dependencies.each do |dependency|
          next if dependency == base_dep
          # do not check recursive because it is depend gem's license problem.
          dep_spec = dependency.to_spec
          Bundler.ui.debug("checking with #{dep_spec.name}(#{dep_spec.license.inspect})...")
          BundlerGemfileLicenseAudit::License.check_violation(dep_spec.name, dep_spec.license, *base_spec.license)
        end

        # TODO: need to check violation during each dependencies?
        # Bundler.definition.dependencies.combination(2).each do |dep_a, dep_b|
        #   Bundler.ui.debug("checking #{dep_a.name}(#{dep_a.license.inspect}) with #{dep_b.name}(#{dep_b.license.inspect})...")
        #   BundlerGemfileLicenseAudit::License.check_violation(dep_a.name, dep_a.license, *dep_b.license)
        # end

        Bundler.ui.debug("done checking dependency library licenses.")
        super
      end
    end
  end
end

module Bundler
  class Installer
    prepend BundlerGemfileLicenseAudit::LicenceCheckerForInstall
  end
end
