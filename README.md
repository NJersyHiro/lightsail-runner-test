# AWS Lightsail Self-Hosted Runner Test

This repository demonstrates how to set up and use GitHub Actions self-hosted runners on AWS Lightsail instances.

## Overview

Self-hosted runners give you more control over your CI/CD environment, allowing you to:
- Use custom hardware configurations
- Install system dependencies
- Cache dependencies between jobs
- Run on your own infrastructure

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── test-runner.yml    # Workflow to test the self-hosted runner
├── scripts/
│   └── setup-runner.sh        # Script to install GitHub runner on Lightsail
├── terraform/
│   ├── main.tf               # Terraform configuration for Lightsail instance
│   ├── variables.tf          # Terraform variables
│   └── outputs.tf            # Terraform outputs
├── docs/                     # Additional documentation
└── README.md                 # This file
```

## Running Multiple Runners for Parallel Execution

To run 3 workflow jobs simultaneously, you need 3 self-hosted runners. Use the provided script to set up multiple runners on a single Lightsail instance:

### Quick Setup for 3 Parallel Runners

1. **SSH into your Lightsail instance**
2. **Set the runner token**:
   ```bash
   export GITHUB_REPOSITORY="your-username/lightsail-runner-test"
   export RUNNER_TOKEN="your_runner_token_here"
   ```
   Get the token from: https://github.com/your-username/lightsail-runner-test/settings/actions/runners/new

3. **Run the multi-runner setup script**:
   ```bash
   curl -sSL https://raw.githubusercontent.com/your-username/lightsail-runner-test/main/scripts/setup-multiple-runners.sh | bash
   ```

This will create 3 runners named:
- `lightsail-runner-1`
- `lightsail-runner-2`
- `lightsail-runner-3`

### How Parallel Execution Works

The workflow has been updated with a matrix strategy that creates 3 jobs. When you trigger the workflow:
- Each job will be picked up by an available runner
- With 3 runners, all 3 jobs run simultaneously
- The matrix strategy ensures proper job distribution

### Managing Multiple Runners

Check runner status:
```bash
for i in 1 2 3; do
    sudo /home/ubuntu/actions-runners/runner-$i/svc.sh status runner-$i
done
```

Stop all runners:
```bash
for i in 1 2 3; do
    sudo /home/ubuntu/actions-runners/runner-$i/svc.sh stop runner-$i
done
```

Start all runners:
```bash
for i in 1 2 3; do
    sudo /home/ubuntu/actions-runners/runner-$i/svc.sh start runner-$i
done
```

## Quick Start

### 1. Create AWS Lightsail Instance

Using Terraform:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Or manually through AWS Console:
1. Go to AWS Lightsail Console
2. Create a new instance with Ubuntu 20.04
3. Choose the Nano plan (512 MB RAM) or larger
4. Note the public IP address

### 2. Setup GitHub Runner

1. SSH into your Lightsail instance:
   ```bash
   ssh ubuntu@<instance-public-ip>
   ```

2. Download and run the setup script:
   ```bash
   curl -O https://raw.githubusercontent.com/NJersyHiro/lightsail-runner-test/main/scripts/setup-runner.sh
   chmod +x setup-runner.sh
   ./setup-runner.sh
   ```

3. Get a runner registration token:
   - Go to Settings > Actions > Runners in this repository
   - Click "New self-hosted runner"
   - Copy the registration token

4. Configure the runner:
   ```bash
   cd ~/actions-runner
   ./config.sh --url https://github.com/NJersyHiro/lightsail-runner-test --token <YOUR_TOKEN>
   ```

5. Start the runner:
   ```bash
   ./run.sh
   ```

### 3. Test the Runner

Push any change to this repository or manually trigger the workflow:
```bash
gh workflow run test-runner.yml
```

## Runner as a Service (Optional)

To run the GitHub Actions runner as a service:

```bash
cd ~/actions-runner
sudo ./svc.sh install
sudo ./svc.sh start
sudo ./svc.sh status
```

## Security Considerations

- Keep your runner registration token secure
- Use dedicated runners for sensitive workloads
- Regularly update the runner software
- Consider using ephemeral runners for better security

## Troubleshooting

### Runner not appearing in GitHub
- Verify the registration token is correct
- Check network connectivity from Lightsail instance
- Ensure the runner service is running

### Runner going offline
- Check instance is running in Lightsail console
- SSH and verify runner process: `ps aux | grep Runner.Listener`
- Check logs: `journalctl -u actions.runner.*`

## Resources

- [GitHub Actions Self-Hosted Runners Documentation](https://docs.github.com/en/actions/hosting-your-own-runners)
- [AWS Lightsail Documentation](https://docs.aws.amazon.com/lightsail/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest)

## License

This project is for demonstration purposes.