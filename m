Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B879CF45CD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D7A6B0005; Mon, 12 Jan 2026 15:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B466B0088; Mon, 12 Jan 2026 15:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6626B0089; Mon, 12 Jan 2026 15:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABFA26B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:23:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A3F113C2F1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:19 +0000 (UTC)
X-FDA: 84324436518.07.6BA670C
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011068.outbound.protection.outlook.com [52.101.52.68])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76C73C0016
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:23:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5g7ekIOV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768249396; a=rsa-sha256;
	cv=pass;
	b=HE/pHCI4xePG22YOL0UzuE0axlSk5EXFOQ8nV/+ItatqEj8jW7gdQN4V9l1Iyg6A6bgDFH
	nEKy09jrboWY/4np5Q3W0VraF+pvMRlSMfLH+e56Z0I+4SSGDNA/LH3et8wO0A6X1DGRam
	Mh5yX+aXuwaOPIzLkQCMN7ZOw+q1KiI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=5g7ekIOV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.52.68 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768249396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WYfy5ZmJ4WlnpF2x1FQZQAqPjUQ5GDf1S4UlccU6HLQ=;
	b=Gmjnv/iDOlZNGowohD+kEYD2rGLlbouD1mRPz38lw8GhSCaS7WuUDGYVDZLLDAbVPrWe8E
	V866+PFqLIKBkraEhYe3Rumbvsr9xojPa8SMIA3/8MAP5QxF9SVDiB4XVYrrp+cJba4GwY
	lsK9y+vMQFhjrrKC3Y5tfHIyu37yZ3Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dv1mlr1Ee3ZC/bwfzO+yr668xECk2Qkr3aUf7crsjabQHPBW0bogVgopsXuyF6jta6loPNOAAlIhlBwAcG00JvE8iese6pcPnr/uumfl+LeePCds5eDECYHwsCJMdQtm1eb5BOU47kvYX6qIViqPultPr1fjVIxAbXMyrAWjMM/drF3qiLEcFgyBszXcyp/Kx6DZDSA0zEmChf74nWybWNWuZV2nueocbB0IO9qqkUVIvL05h96kmBGhmvhlQeLHy5o3xNYtAkZZw+LOA4blG2ipYSBfOOu+Ficft2PWh+63MSYq05Lo+G2D3n5YwTLLsJrkyepzOE6RLhuvHSikxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYfy5ZmJ4WlnpF2x1FQZQAqPjUQ5GDf1S4UlccU6HLQ=;
 b=CXDnC0QevZTFVp6JOv3tEU7KlbhFP4CGZTC8zuJ3vJPQxtP9Gy5w82HMGrBV3fBh/bHspPxEodle+0DwIOKVOy1zsTonWF2lcV6qs7S6pm7uD/UmLyWxwGalMGGgs/09eaRMm7oY2fIn5/QV6Lgs0q4YSaZXGa0bFqF+QYEscyX+7g89JRGrSig9kmynK0+097a9qrf6VBIws8x8ndwmI/tT/BRax0fGp94FKYpOo4Z7Gvdd96ZALWlKtrZTsHgYr0Gic6xanSP2aCV4J5GYl5LIsCcAUbBDecEGc5yQmCoBrEznwtDVx08u15772qKgxsQgTdVCuyuFUZf/KxHrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYfy5ZmJ4WlnpF2x1FQZQAqPjUQ5GDf1S4UlccU6HLQ=;
 b=5g7ekIOVk+9OMXM8xnI7lDSR6DtRbq4yopNJCqeWr/Fse5kgJySYtOtn+GeWclI8BP8WbnZRnZRRaSG3iK+EAmH51pmS5YaqbIu2P8baVP/de19q/1yIQTXuLBGYdCi615zTUifiv2xb1GvecPCcUxNBfW4PqBOJk43hws3Yabc=
Received: from MN2PR06CA0017.namprd06.prod.outlook.com (2603:10b6:208:23d::22)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 20:23:08 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:208:23d:cafe::80) by MN2PR06CA0017.outlook.office365.com
 (2603:10b6:208:23d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.7 via Frontend Transport; Mon,
 12 Jan 2026 20:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Mon, 12 Jan 2026 20:23:07 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 12 Jan
 2026 14:23:06 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v2 0/2] SEV-SNP Unaccepted Memory Hotplug
Date: Mon, 12 Jan 2026 14:22:58 -0600
Message-ID: <20260112202300.43546-1-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 35566be6-fefb-46a5-10b5-08de521865c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f/cZt0Rvv8Ugn3Pw8U1HiVa+nrFquq5SoswH9XZG0/Aj3iZ27T+uGA83sAyZ?=
 =?us-ascii?Q?u5HkPg02IHDEyeBgDRAD+0An20ZKUL4om1EqnX4JNUaGfDmdv4Dnc34TQz68?=
 =?us-ascii?Q?GyVw5bk+seVH7PAkQNNUT53iel4n68txc4ROJmag7DH+0wfUdaJcSrKcJLuI?=
 =?us-ascii?Q?bDLVWmLU+wpfuVefYDlf4p0yO1WmzLVkjYREVQHl/SwzhKnEidVNciSM9leX?=
 =?us-ascii?Q?QJgcBol78/k2FAsMXDFaalVMCIrp+Ln0RH6nr09f7a0NKwBiBEzJQHcbk8hg?=
 =?us-ascii?Q?nwtND7PibJgbYLf79KbNphogr9ic4OwiMfJDccC8zG2qyzTPPfh4JW1rnzyJ?=
 =?us-ascii?Q?FYAz5fL8G+id85RDuO9fydljPxFuBPy8zsXM/knhBUpILzLp0iHW449Dh2ur?=
 =?us-ascii?Q?tkCMpfGMWqCXBqlxgggiyVKOi4cxwZTw5AxjpEt+mHG5hC2EHGebHs8gWIKE?=
 =?us-ascii?Q?UoWmmOVZqYWfyor9Ju4yXhh2pyMcPbipbMFAlyXxAl5zu10MreggR0UpVbXE?=
 =?us-ascii?Q?Rlr9VnER6pQ89O08iInIzwOYbkkccdxgGh1iPRoTj5Ex8+VlSr3eJslI7c97?=
 =?us-ascii?Q?ZYewRvzcELw61NpW3i/68oNn93QhavrA17zEPey+pA6WpGPQHR2lV4T3eCRE?=
 =?us-ascii?Q?NhV0mWtHzC3RlJz1JuEDIpaNbgBsiwmj0rUWHTgMR3zNs7/wjsxVycYWLZcL?=
 =?us-ascii?Q?fbbNKNtZO8ty9an1vJ6fksH2pRBDF5UUqJlhiRdY7qx27PwH1asB7lmu0kpG?=
 =?us-ascii?Q?9BK5JvCnSo2Jj3g4K6trpP69N1jiTh6q3AuQBxUwzGZtPsbiRKNGSPwVoxeE?=
 =?us-ascii?Q?9cS0cz0gYJUj8LlEl3ezGSVrcekp0nnl03vf25UTC9m8ImWCQj4oNNlh11qW?=
 =?us-ascii?Q?6kQE1IF9hhhs+kllMOvbNz/mlZGYYphSv5sREfmMTWWoddLSE3LipI0ojJUi?=
 =?us-ascii?Q?I6AXYnUVcZVgvlAUzwe6nZka4DW3z4zqdySij2sXASul8m4IXFXP/PJBtTQy?=
 =?us-ascii?Q?Nup3tdrrxZ6MpRfY6Le9YrEOZ1TcxNYlBW44AbZyjAwdwE4J800SlQHhPq5K?=
 =?us-ascii?Q?DPC531xBrcE0fthcMnc2vZBpN8Ow0LyMVbsWq0HfTiYF1jEZ9TQs/aQGFh7J?=
 =?us-ascii?Q?ZVBSS2Y5lHj7vrFYgBcynxH+olwNpZ+RTfHLh7YrLcAlRxZaNQ9s1U9Jj9jt?=
 =?us-ascii?Q?a7E4syxj3csJ5AUfFyeQWl0bjJ+I8yz+cvM4IHqnkusHcFkCxOsRvQ2IJQK0?=
 =?us-ascii?Q?16xpA3bof9q4of6pkCVvE4R22NDq1P7dsn0ogbDCKtmVlHkFVckvc79kzypf?=
 =?us-ascii?Q?Qz15okyNC3dOd6Us7XhyzmPEkesiyQrgt/AXznKR6FLrzdbEJX+lHrmBKTRd?=
 =?us-ascii?Q?ZwnMEhbYSPM6T0esZyrQqPRES9Vinx/ndjuqVGwGzu30R6P/t1yzRTVPEple?=
 =?us-ascii?Q?8dyDgmYR6l/O+01w2t5+Kk/2XVRPHxF/x3NbQkrpS0MT20PUPzCTJgRrrd6I?=
 =?us-ascii?Q?zcVQhBs+kXXjvgSNArcronH3YJwSXZueRhnT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 20:23:07.3142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35566be6-fefb-46a5-10b5-08de521865c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267
X-Rspamd-Queue-Id: 76C73C0016
X-Rspamd-Server: rspam06
X-Stat-Signature: 5i4sikg88hxuds88usgc3yrub54poxgg
X-Rspam-User: 
X-HE-Tag: 1768249396-776709
X-HE-Meta: U2FsdGVkX1/XNeVrFalpaIf4ncQ8DDPNid+CwqNVEYfPVk84tuvO3TbnIqjDmT7hLafNRPIQ4xYO4ID9l0k29ftYvk1WovkuAKiKhYIdowkeqa6ym95+vNor4JSAeeVlw0oBD/7LeDgCyk0ic0NiNCKNZrqmF7lM9HBV9NVyTS8+f6gU9RpMLPy90MCPm+TfCmprf4katICPwrSp6dWvXLBuEWld035g8jdm1HQXSeJ6gRqJoUyqOHyCVqPbrKm33KjeX8EgUApzGcqZB6T6bQbNDKFpmJtlQMbi9RQyxNpPBiyg4UZ+sFdTXSSP9EpXskjctzNe96SDHnez3fqALYo/EX7+aHhLgoOgoE1yyYHwDEDErwWS0PWKWmE2BO3Gf8SRYdzq3u5uhnoCKzNXSoDsj/YEyA6ds+XqGYC7tEdZPJPruqy/Dm9v6xlTumIy6ETf+7k0avKHWZkIyaj48ysWQg2UGJuQHgAbsMGRrXAw+gzZ2z+M91C68NbOOQwOOw7GvnsxK38Pc9KQ/13J3gwCRifZb5BtFrt9fo74kjhDO14sB4TGq7O18SUA6vIWrWlOEyhjQTBa0ZYUvRoxBW05bN8R5mgl2zbVdqD6Mc7aCWXdxvWCmJ/3VHsIP1F7nSAKx3Xycaqe/33oz7+W6GoL09kDu1+IojM/ovA/Lw5LDSqcAxCkbz6VQaSLiX14CCRU3Kxf+E21TQaQ9zIgAQull0m0LJ1mPwHonN2bJkbervzX5I/YPlzB+XSGEyzes0DNq8rYt6TH+WH9L60fONVOQXPfEKVWRaD/sbVy9xULeuFjKrGIrFk176PcWCbJYlYMd9yO7RnHCsD1Mo+Y8aJW6CSQATbAJo5sYrWOGRpb4sCAnSEBsO7GfZYqLkv99mCuP0YE0MT9ZUPgBBB1gy6h7nNTuXKwimEr8LUxBVLyDa/gQzOBItLo4apmiiVNM12VlkWdRckmOAnhV/g
 6ADlgk5x
 qIytoZv4zVH2VPhGl8uY5ZJjAkQSbYe7p1rg2XXFRGQJDsv5m5UT/MzKYixVzWk+1Q1t5FYagjfF8DMpf6OZtPPMcvAa0vSewi3ngoFkA/gi7VHUssi3AuySzjklIS6jn6a9TO3A3fT4ILEdrRdgkJgzr9LxY33sUBKXFw5nGA0Bl+hDCZsDQ9RCNuGr422/monI76mauPfLYi2+nVN8THtyKj9UTFNUnShVmo56E8SVwTAmKNwCkQowrBRwb8rSOtGA66OOwXA2W3+taHyQXzcoMDhUl8hgYc6GQCUrkbgQj6i/+ThStX/3+fbkKh5HTAUy77GmMZfaKmUwf1lzf39PBAHFwY86rsot2ksovJ+8JA/sdM5+obQifZppA6YGFuPAf5c1WCLlF4704zoZGgreks1QQCRnzS16nLPN7bdWfl+/izqVDqY88h+S4IyNSrHYv/chOa/u1/gFHKBdeUGjTXaXx28tDuvZpXIFAxkPbIxJ/QVqPU2HmRyya1vlPczhpCuU/B5ZFfvODJHqDHenQVCl+a+2UagCT8mMBUfdBZ6GmY7EAxlEm7gvHJKvr0mjJ5oluR1o3MK/9kyUiqKy7tA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guest memory hot-plug/remove via the QEMU monitor is used by virtual
machines to dynamically scale the memory capacity of a system with
virtually zero downtime to the guest. For confidential VMs, memory has
to be first accepted before it can be used. Add support to accept
memory that has been hot-added and revert back it's state for
hypervisors to be able to use the pages during hot-remove.

Usage (for SNP guests)
----------------------
Step1: Spawn a QEMU SNP guest with the additional parameter of slots and
maximum possible memory, along with the initial memory as below:
"-m X,slots=Y,maxmem=Z".

Step2: Once the guest is booted, launch the qemu monitor and hotplug
the memory as follows:
(qemu) object_add memory-backend-memfd,id=mem1,size=1G
(qemu) device_add pc-dimm,id=dimm1,memdev=mem1

Memory is accepted up-front when added to the guest.

If using auto-onlining by either:
    a) echo online > /sys/devices/system/memory/auto_online_blocks, OR
    b) enable CONFIG_MHP_DEFAULT_ONLINE_TYPE_* while compiling kernel
Memory should show up automatically.

Otherwise, memory can also be onlined by echoing 1 to the newly added
blocks in: /sys/devices/system/memory/memoryXX/online

Step3: memory can be hot-removed using the qemu monitor using:
(qemu) device_remove dimm1
(qemu) object_remove mem1

Tip: Enable the kvm_convert_memory event in QEMU to observe memory
conversions between private and shared during hotplug/remove.

The series is based on
        git.kernel.org/pub/scm/virt/kvm/kvm.git next

Comments and feedback appreciated!

Changelog RFC..Patch v2:
------------------------
https://lore.kernel.org/all/20251125175753.1428857-1-prsampat@amd.com/
Based on feedback from the RFC, reworked the series to accept memory
upfront on hotplug. This is done for two reasons:
1. Avoids modifying the unaccepted bitmap. Extending the bitmap would
   require either:
   * Dynamically allocating the bitmap, which would need changes to EFI
     struct definitions, or
   * Pre-allocating a larger bitmap to accommodate hotpluggable memory.
     This poses challenges since e820 is parsed before SRAT, which
     contains the actual memory ranges information.
2. There are currently no known use-cases that would benefit from lazy
   acceptance of hotplugged ranges which warrants this additional
   complexity.

Pratik R. Sampat (2):
  mm/memory_hotplug: Add support to accept memory during hot-add
  mm/memory_hotplug: Add support to unaccept memory after hot-remove

 arch/x86/coco/sev/core.c                 | 13 +++++++++++++
 arch/x86/include/asm/sev.h               |  2 ++
 arch/x86/include/asm/unaccepted_memory.h |  9 +++++++++
 mm/memory_hotplug.c                      |  7 +++++++
 4 files changed, 31 insertions(+)

-- 
2.52.0


