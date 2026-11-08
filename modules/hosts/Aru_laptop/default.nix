{ self, inputs, ... }: {
  flake.nixosConfigurations.Aru_laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.Aru_laptopConfiguration
    ];
  };
}
