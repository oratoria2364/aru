{ self, inputs, ... }: {
  flake.nixosConfigurations.aru_fix = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.Aru_fixConfiguration
    ];
  };
}
