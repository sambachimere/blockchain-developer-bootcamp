contract UpgradableContract {
        address owner = msg.sender;
        address latestVersion;
        mapping(bytes32 => uint) uIntStorage;
        function upgradeVersion(address _newVersion) public {
                require(msg.sender == owner);
                latestVersion = _newVersion;
        }

        function getUint(bytes32 _key) external view returns(uint) {
                return uIntStorage[_key];
        }

        function setUint(bytes32 _key, uint _value) external {
                require(msg.sender == latestVersion);
                uIntStorage[_key] = _value;
        }

        function deleteUint(bytes32 _key) external {
                require(msg.sender == latestVersion);
                delete uIntStorage[_key];
        }
}

