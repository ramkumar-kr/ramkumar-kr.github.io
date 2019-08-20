---
layout: post
title: Optimizing spend on AWS
author: Ramkumar K R
tags:
- DevOps
- AWS
- Cost optimization
date: 2019-08-19 17:23 -0700
---
# Optimizing spend on AWS

A large chunk of the internet today is currently hosted on AWS. However, without proper measures, the cost of running infrastructure on AWS can increase dramatically. Taking on the responsibility of DevOps at my company, (which should ideally be called as DevSecFinOps) I was tasked with bringing down our AWS spend. After 2 months, and a region migration, we brought down the cost of our bill down by 50%. This post will talk about the various steps I took in optimizing the spend on AWS.


## Where am I spending money?

We must first identify the areas where money is being spent on AWS. AWS provides three tools of various levels of granularity to identify expensive resources.

### AWS monthly bill
AWS provides a monthly bill which provides a region and service level visibility. For example, the bill can say that $100 was spent on m5.large instances in ap-south-1 region for the month.

### Cost explorer

AWS Cost explorer goes one level deeper by providing a day level visibility. The cost explorer can be very useful to perform preliminary analysis on the cost. For example, the cost explorer can say that an additional m5.large instance runs in the ap-south-1 region every monday.

### AWS Cost and usage report

The cost and usage report provides the highest level of visibility with a hourly account of expenses. However, it is also very bulky and requires proper tagging of resources and other tools such as athena or elasticsearch to analyze the data.

#### Tagging your resources

Tagging resources is one of the most important steps to be done for cost optimization. Providing proper tags can be highly effective in identifying the areas of expenses in your infrastructure. To paraphrase Edna mode, "Done properly, Tagging Resources can be a heroic act...Done properly"

Usually there can be about 3-4 tags common for all resources and other application specific tags. A few common tags which I use are **Application**, **Stack**, **Team**, **Owner**, **Environment** etc.,

#### Indexing the report to elasticsearch

The Cost and usage report usually is huge and cannot be analysed manually. One way to analyse the data is to index the report to elasticsearch. With a Visualization tool such as kibana or grafana, it is possible to build dashboards and visualize your spends.
I indexed the report to elasticsearch using logstash.

Another way to analyze the report is to use Amazon Athena to perform relational database like queries on files in S3.

Some opensource repos which do these are
- [https://github.com/ProTip/aws-elk-billing](https://github.com/ProTip/aws-elk-billing)
- [https://github.com/awslabs/aws-detailed-billing-parser](https://github.com/awslabs/aws-detailed-billing-parser)

## Elasticity

The infra requirements change in my company from time to time. For example, we may require more instances during office hours or during the sale. Instead of running instances to handle the maximum load all the time, we can scale up or down the instances as required. The following document by AWS provides much more detail - [https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-benefits.html#autoscaling-benefits-example](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-benefits.html#autoscaling-benefits-example)

Along with the number of instances, the configuration of each instance is also a contributing factor for both performance and cost. Having the right instance to run the right application requires a profound understanding of the application as well as a scientific way to measure the performance of the application under various conditions.

## Design for cost optimization

While designing applications, we must always consider the cost factor and take decisions which can optimize our spend in the long run. For example, if you have multiple services which require load balancing, using a single ALB with host or path based routing is more cost efficient compared to having separate load balancers for each service. In order to achieve this, the applications must be designed such a way that by adding host or path based routing should not cause side-effects.

## Services

Here, I go through 2-3 commonly used services and list some common tips on optimizing cost

### EC2

* **Running hours** - It is possible to reduce the cost by turning off the instances when not in use. For instance, dev and test environment instances can be turned off on nights, weekends and holidays.

* **Right Sizing** - Having the right instance size can play a crucial role in obtaining better performance and lower our costs.

* **Spot instances** - AWS provides instances at ridiculously high discounts based on availability of extra capacity called "Spot instances". However, these instances are available based on demand and have a termination window of 2 minutes. It is a great way to run dev and test workloads or even containers in production. Note that applications such as databases may not play well with these instances.

* **EBS Volumes** - AWS provides different types of volumes to cater various use cases. In case you are using io1 volumes, it would be cheaper and performant to switch to a gp2 volume of a bigger size. To illustrate - 
A io1 volume of size 100 GiB and 1000 IOPS costs about $78 per month in the us-east-1 region. However, a gp2 volume of 400 GiB and 1200 IOPS costs about $37 per month in the same region.

* **EBS Snapshots** - EBS snapshots are incremental and are internally linked with the sections which have not changed (Refer to [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html#how_snapshots_work](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSSnapshots.html#how_snapshots_work) for more details). Over a period of time, snapshots can be stale since the data in the volume might have changed completely and it may not be useful to have them anymore. In such a case, deleting these snapshots can reduce storage costs. More information is available in here - [https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-storage-optimization/optimizing-amazon-ebs-storage.html#delete-stale-amazon-ebs-snapshots](https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-storage-optimization/optimizing-amazon-ebs-storage.html#delete-stale-amazon-ebs-snapshots)

* **Reserved instances** - There are different types of Reserved instances (RIs) available with AWS. Please consider buying an RI if an instance meets the following criteria
  * The instance runs more than 75% of the time per month.
  * The application run by this instance has a predictable workload and the requirements can be pre-determined.
  * There is no further optimization which can be done for the instance.

### S3

* **Storage classes** - S3 provides various storage classes to serve different use cases. The lifetime of the object stored in S3 is an important factor for the cost. For example, if an object is being stored for 90 days, the infrequent access storage class may be cheaper than Glacier.

### Data transfer

* **Communication between internal applications** - If there are multiple applications talking to each other within a VPC, Data transfer costs can be minimized by not using Elastic IPs or public endpoints. You can have a private route53 hosted zone accessible inside the VPC instead of referring to private IPs.

## Checklists

Checklists serve as a way to systematically optimize your resources. For example, a checklist for EC2 instances can be built and verified on each instance. An action can be taken to optimize whenever the criterial in the checklist is not met. These checklists differ for each company. You can find the checklists I used as a sample below - 

### EC2

```
1. Can I stop this instance at night and weekends?
	a. Yes - stop the instance at night and weekends. This reduces cost by 50%.
2. Can I use a linux instance instead of windows?
	a. Yes - migrate to using linux. This reduces cost by 23%.
3. Is my maximum CPU utilization < 40% over 30 days?
4. Is my maximum RAM utilization < 40% over 30 days?
	a. If both 3 and 4 are yes, downgrade the instance to 1 level lower (example: m5.xlarge to m5.large)
	b. If only 4 is yes, use a c series instance with same number of cores (since the application is compute intensive)(example: m5.xlarge to c5.xlarge)
	c. If only 3 is yes, use a r series instance with same memory (since the application is memory intensive)(example: m5.xlarge to r5.large)
5. Is my application fault tolerant and does not depend on local file storage (except writing logs. Example - all dockerized applications)?
	a. If yes, then please run spot instances. I would recommend a 50-50 split between on-demand/RI and spot instances
6. Will my instance keep running 24x7 for more than a year?
	a. Then please purchase an RI (Reserved Instance). Decide whether to buy for 1 or 3 years and also to buy No-upfront, partial upfront and full-upfront
7. Am I using the latest generation of EC2 instances?
	a. If no, then please take a downtime to upgrade the instances to the latest generation. Prepare a plan for the migration. This reduces cost by 10-15%.
```

### S3
```
1. Do we need the S3 bucket and its data?
  a. If no, then please delete it
2. Do we need all the data in Standard Storage?
	a. If no, then consider uploading new objects in a different storage class such as IA or Glacier. Please refer to Log retention policy to decide on the right storage class
```

### RDS

```
1. Can the RDS instance be shut down at night and weekends?
	a. If yes, then shut down the RDS instance at night and weekends. This will reduce cost by 50%
2. Is the RDS instance Multi-AZ and running non-production environments only?
	a. If yes, then turn off Multi-AZ for non-prod environments
3. Is the maximum CPU utilization < 30% over the last 6 months?
	a. If yes, then try to downgrade the instance by 1 level
4. Is the storage space used < 20% over the last 6 months?
	a. If yes, then try to reduce the storage space allocated for the RDS instance
5. Are there databases which are not being used since last 1 year?
	a. If yes, then discuss if they are still required. If not, then remove it.
6. Are there manual database snapshots which are not required?
	a. Then delete it.
```

## Continuous monitoring

Cost optimization is not a one time exercise. It has to be constantly monitored and the infra has to be reviewed regularly to avoid any leaks. For example, every new instance brought up can be run through the checklist to ensure that we effectively utilize the services provided by AWS.

I hope this post was useful in providing some insights on optimizing spend on AWS.
