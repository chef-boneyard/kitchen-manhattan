require "thor/util"
require "kitchen/provisioner/manhattan_version"
require "kitchen/provisioner/chef_zero"

module Kitchen
  module Provisioner
    class Manhattan < Kitchen::Provisioner::ChefZero

      default_config :build_platform, "ubuntu"

      def create_sandbox
        super
        prepare_client
      end

      def install_command
      end

      def prepare_command
        puts @available_file

        vars = if powershell_shell?
                 install_vars_for_powershell
               else
                 install_vars_for_bourne
               end

        puts vars
        shell_code(vars, "manhattan_install_command")
      end

      # The omnibus build pipeline puts the artifacts in a directory structure like:
      #
      #   `architecture=x86_64,platform=ubuntu-12.04,project=private-chef,role=builder/pkg/private-chef_11.1.2-1.ubuntu.10.04_amd64.deb.metadata.json`
      def prepare_client
        Dir.glob("*#{config[:build_platform]}*,project=#{project}*/**/*.metadata.json").each do |metadata_file_path|
          metadata = JSON.parse(File.read(metadata_file_path), symbolize_names: true)
          next unless metadata[:arch] == 'x86_64'
          package_local_path = File.join(Dir.pwd, metadata_file_path.gsub('.metadata.json', ''))
          @available_file = File.basename(package_local_path)
          FileUtils.cp(package_local_path, sandbox_path)
        end
      end

      def install_vars_for_bourne
        [
          shell_var("install_platform", config[:build_platform]),
          shell_var("install_file", uploaded_filename(@available_file)),
          shell_var("sudo", config[:sudo_command])
        ].join("\n")
      end

      def install_vars_for_powershell
        shell_var("install_file", uploaded_filename)
      end

      def shell_code(vars, file)
        src_file = File.join(
          File.dirname(__FILE__),
          %w[.. .. .. support],
          file + (powershell_shell? ? ".ps1" : ".sh")
        )

        code = [vars, "", IO.read(src_file)].join("\n")

        if powershell_shell?
          code
        else
          Util.wrap_command(code)
        end
      end

      # conceivably we'll want to change this at some point.
      def project
        "chef"
      end

      def uploaded_filename(fn)
        File.join(config[:root_path], fn)
      end

      def modern?
        true
      end
    end
  end
end
