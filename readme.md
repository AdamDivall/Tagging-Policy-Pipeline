# AWS Tagging Policy Pipelines

The CloudFormation Template has been created to resolve a common issue of deploying and updating Tagging Policies to an AWS Organization through automation since Customisations for Control Tower (CfCT) only supports the ability to deploy either CloudFormation Templates as StackSets or Service Control Policies (SCP).

The CloudFormation Stack will deploy the necessary resources to configure a pipeline that will be able to create or update tagging policies with AWS Organizations based on the JSON Files that are committed to AWS CodeCommit.

## Pre-Requisites and Installation

### Pre-Requisites

1.  Clone the GitHub Repo to your local device.
2.  Modify the varying tagging policy JSON files (Automation, Business, Operations, Security & Technical) as per your Organizations requirements.

### Installation

1.  Deploy the CloudFormation Template to the Management Account of the AWS Organization.
2.  Clone the CodeCommit Repository that is deployed as part of the CloudFormation Stack in step 1.
3.  Commit the varying tagging policy JSON files (Automation, Business, Operations, Security & Technical) as per your Organizations requirements to a folder named `policies` and ensure the `deploy.sh` is at the root.
4.  Wait for the Pipeline to execute.