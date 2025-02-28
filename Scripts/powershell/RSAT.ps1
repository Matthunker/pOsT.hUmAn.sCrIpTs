# Define the list of RSAT tools to install
$features = @(
    "RSAT.ActiveDirectory.DS-LDS.Tools",
    "RSAT.ActiveDirectory.Management.Tools",
    "RSAT.GroupPolicy.Management.Tools",
    "RSAT.NetworkController.Tools",
    "RSAT.FileServices.Tools",
    "RSAT.AdministrativeCenter",
    "RSAT.SnapIn",
    "RSAT.Dns.Tools"
)

# Install RSAT features
foreach ($feature in $features) {
    try {
        Write-Output "Installing $feature..."
        Add-WindowsCapability -Online -Name $feature
        Write-Output "$feature installed successfully."
    } catch {
        Write-Output "Failed to install $feature. $_"
    }
}

# Optionally, you can use the following command to install all RSAT tools available
# Install-WindowsFeature RSAT
