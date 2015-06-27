module BundlerGemfileLicenseAudit
  class LicenseError < StandardError; end

  module License
    LICENSES = {
      mit:     /MIT/i,
      ruby:    /Ruby/i,
      gpl2:    /GPL[-v]?2/i,
      gpl3:    /GPL[-v]?3/i,
      apache2: /Apache[- ]2.0/i,
      bsd4:    /BSD\z/i,          # Original(4-clause)BSD License
      bsd3:    /BSD-3-Clause\z/i, # Modified(3-clause)BSD License
    }
    VIOLATION_MAP = {
      mit:     [],
      ruby:    [],
      # http://www.gnu.org/licenses/license-list.ja.html#GPLIncompatibleLicenses
      gpl2:    [:bsd4, :apache2],
      gpl3:    [:bsd4],
      apache2: [:gpl2],
      bsd4:    [],
      bsd3:    [],
    }

    def check_violation(gemname, depend_license, *gemspec_licenses)
      return if gemspec_licenses.empty?
      gemspec_license_syms = gemspec_licenses.collect { |s|
        to_license_sym(s)
      }
      depend_license_sym = to_license_sym(depend_license)

      violated = true
      gemspec_license_syms.each do |sym|
        if !VIOLATION_MAP[sym].include?(depend_license_sym)
          violated = false
        end
      end
      if violated
        msg = "#{gemspec_licenses.inspect} and #{depend_license}(#{gemname}) is violated!!"
        raise LicenseError, msg
      end
    end

    module_function :check_violation

    def to_license_sym(s)
      sym, = LICENSES.detect { |_sym, regexp| regexp.match(s) }
      sym
    end

    module_function :to_license_sym
  end
end
