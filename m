Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2A3C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 17:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3DED6B00BA; Sun, 10 Aug 2025 13:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF078E0006; Sun, 10 Aug 2025 13:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6586B00BE; Sun, 10 Aug 2025 13:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B842B6B00BA
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 13:02:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57E481DCFCA
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:02:12 +0000 (UTC)
X-FDA: 83761465704.21.BB79B8D
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89AB54000D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 17:02:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=esaqSj8b;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.86 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754845329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Twvo1MGwqVkIFIxri1sLWRAUlkj0wwBSKggdGXA8Hqc=;
	b=o8MRv0Md9pwoNIC0pO7gkElzoYnBn+UO50L0ZwHoRdVEgpdkKAlL9A9puMk200cAf7EGUe
	vxmRV6j+Lo3fGXEBFZ3i3qghiXk0u1467zX8RZCRDfWTCq2k36dR98e7+DaZGgcLGsyyrj
	zVax7Wm8C6YXBAldxOmEGeHZzJeH73I=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=esaqSj8b;
	spf=pass (imf11.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.86 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754845329; a=rsa-sha256;
	cv=pass;
	b=24KZeC6Xv1A01vDgqTluUogjQz/pjDHDlxyCT4CJfJbGwofpqpucUUTh6JOMTI0OzVrjBA
	CgptOcgmR09+SyCfiQGvGVAW4DTtswLkiEAol/Xon6AmgTDdgHsMPuk7cKibUaxqPlhJVZ
	jxnpY2czOC3fDHGLQ+nzYM9IAVLseh0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DMRLHMDJvs4Dw51AHB0C/toHvAnkUMx83nUrbZgwAmrohiQwvqiWrVeNpY4s6GPJEJdqWljBHaE7NqrWh/ZiHoITJP1fZjOXRaqJL/qBSVpMBk1Ac48svWQn/z9II72HeGeGTHn19uu9JD0iQLRXZArYc2aJ6GVmBLLDX2057tDIGCxubfcqHCF1AltFf5a3vefDk/dMnMhXAr3ho9EJIWAQ01IR2iBbKDs+03VLE+Mrp/6ZMbG7cKBhEJbQaal7oaK7YlKTv4hIp7pwJa652rG2FiMhCTFOEzNKIPMERNCRIudLFS4ENN+maWygCgJJEY6Tli29Rs6AI1roFOaTZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Twvo1MGwqVkIFIxri1sLWRAUlkj0wwBSKggdGXA8Hqc=;
 b=FmwCDkrxqMDJZd9SiWxxD2PaihTYKmDPTPsBjrspsEubvJ/X7HGk01fJ1pNu6PMmxK8A2uOudtiDP07B2EQiras7H+qkbq9K1eSnIXi8q/hKz6YyhFwriY2G2K6mT5C8ArjZYDmASDZJFuujhWe5Sk8FuTFy/+DxafILE3Ydwz5aYRC4hr5k0N2vImv34UtId3GmFbWs0Lsy2ZxjKWTVR0v/D2kfIc4jHMCjKVGkoorT+XSuVBszau6gM21h4BDnEvJkfo4OPUapTEuUPV+zn5PnLzADrH+5vdDULeABEfmyPGzjiTPhwwe578rfvHd9RrgI1zNYVM7Pz59CKEn7/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Twvo1MGwqVkIFIxri1sLWRAUlkj0wwBSKggdGXA8Hqc=;
 b=esaqSj8bYMgfNy9YNWn/bD1qrC05cydZsn7MILq3cKWDWf7UW21ZV/MdjiA3yUg7Z8S//X9XIeRzUUR1ZOxIOS7IyMGAwk3cvEvdGnAwmtdC0CSxfrU8QUGAr11dI+zdzB3KkdTpDXx3AzJhzrtdlmRc80FmykbCEDcCRq+fqiWrqecoX53zj5ybUIjxvT6VYSyIFTeocZtPZtZ5Gn2HhQtZRBDHDkcDnYyzHpDM2cWxamI66j94yQNtFWD3/mU8zRLIl7OkhwlN4f6VW0MFNUpLpUvFEPQLdPLBhwqLuwugFqcT5t9qe5St2YMzJ5mu503tXtV/ojasWagE/PoolA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Sun, 10 Aug
 2025 17:02:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.018; Sun, 10 Aug 2025
 17:02:03 +0000
Date: Sun, 10 Aug 2025 14:02:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leon@kernel.org>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <20250810170202.GQ184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <CGME20250807141938eucas1p2319a0526b25db120b3c9aeb49f69cce1@eucas1p2.samsung.com>
 <20250807141929.GN184255@nvidia.com>
 <a154e058-c0e6-4208-9f52-57cec22eaf7d@samsung.com>
 <20250809133454.GP184255@nvidia.com>
 <6cbaa3a3-694e-4951-abb3-b88e6c9d6638@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cbaa3a3-694e-4951-abb3-b88e6c9d6638@gmail.com>
X-ClientProxiedBy: YT4PR01CA0163.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: fec849dc-1ee6-4528-8aba-08ddd82fa0dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tQ7R8t1K+FbIOGnc0aJmvxih0vp1cw9yA1yhHKE6+q0uUN5Qdl+Rlhg9ZSCb?=
 =?us-ascii?Q?Qo2keWV9B6ntQxdesYFS4a/Sfse6j7UKnxNTGuCMChZSZDnbTNLbvJrRsZdE?=
 =?us-ascii?Q?hepTFH1q7vgcNIvrmS5hlHUSAnNHxmSX42I/UI8xSHtaZo+PEr+Z/alXGQIK?=
 =?us-ascii?Q?QuGj9uZxAdbSs0wtYKEL8Yc7ZCNUuj/bAmql5VrKwAfR5Z6kD1C4jVBZC162?=
 =?us-ascii?Q?PFqQMQE3Alc9ZXx7EAm2SmE7sIErmtjpPYkAPmPHa8aA1hcP2uePrahBqS6y?=
 =?us-ascii?Q?V6Cnrfc7Whlac65SqD5Nwe5cACms/vP8r5cHO0PKaDpcgaiHxlIULjkHh/ez?=
 =?us-ascii?Q?GFrD/fJmov5ZoJFRPOk7lNOTe0wL1ObyiVHIgFPyjkZO3Kvf1tac5C6BxrhB?=
 =?us-ascii?Q?j7w8meCgGYUxzYRvxLMb9it2QXTjZA+TRZ5kIIDNUTdiUfaqMFedwJOn62TM?=
 =?us-ascii?Q?kmj4HXwtUTJtxqQGL4z267xtb4o4WN3+gIHxSbBVidGjzig8xJzS/sklhLGC?=
 =?us-ascii?Q?D44SK7WyFpZv/SHDscq94Sw8zJ7QpuejWHEJSvdmiqB4Tc3/pHD/coPi75iH?=
 =?us-ascii?Q?0UvyLysJ6zsIEQZAiEjLkg82dbGJIeerPLaLxgl44Ip90d5j5ktjouMjqVE7?=
 =?us-ascii?Q?uvwO2/KfzlOJLif3Xp+iwsmJVFM+NNBuqT3XXMcBH3Lv13ZR3qpMebnJdNFC?=
 =?us-ascii?Q?maBW8Hzj7QKbl92n9tAwxsvc50X0at/AHo6cdE/8Skv+R/4+mpJh6nSCCauk?=
 =?us-ascii?Q?8TA0wPUNrpCnNFzzarYuV+ZKwdnA9y57zSWbvN9pf1jB3DXGVmR6OhBcIMdI?=
 =?us-ascii?Q?GHNodaeA/Ct7PSfiNUkeycvt8c/ODVcvWSnbf7HQltjWV1dInOD7c5M3trC0?=
 =?us-ascii?Q?V5K3ntgj/vQ0NzKRU01lALB5Sxj2NVPOxf1wp4aZcdqFnaGw7/l5RROVrDud?=
 =?us-ascii?Q?oQhgIEpV1kL7VF2ZPLveObCaPoABBtQl5JWYw51OdW3nNmCmZmNZ7YFRYulk?=
 =?us-ascii?Q?7QZF4LpzOJ5Fx0TDefciNhrtzaFt1CpCdPzpLZhxIkSuBerYa20Z7wZdo9/3?=
 =?us-ascii?Q?3caSGtHtn7AAFhohOV9toc7r81df1eoLgXfS6V67zTj25uTZxYWjRDDTX7Cr?=
 =?us-ascii?Q?FDwjuv4VjrJJysz/rjY94XyqwVcEZO4XffIjYCUsRwiNEESpVtc6he1qzVLJ?=
 =?us-ascii?Q?cuslVADC1KFhHrDzIVb+VFGcv2wm8YZ3BTDRIfebpeiN98rCZv9IUTld7CIX?=
 =?us-ascii?Q?jTFyYVxYjZQtyQzaSEXG2Uc6452KRKVyQeLkdVRADeWN1n8aAOvNVp4HAu9Q?=
 =?us-ascii?Q?x+PQcSgUSknsyDgjJZ//mdhB8tlc6LnCatIi3+hfxcR6v8NGlp9d/laqnv2d?=
 =?us-ascii?Q?1k3SMuRg5Dd6s7yyYdlfoyfU3iNc/Amrj+GVkacOr/7w/EmtHSCq7azvCzwY?=
 =?us-ascii?Q?zo926LRBsL0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s4vtM7QfcEK3pnSfpgdvdzEG1xxhmc0TDHTkbowPQHBiG7Js+F0EgSX3gR6e?=
 =?us-ascii?Q?LXKcn+Fk2D6v6uf0owIyEpBDKzCXNNkKlfOplXJD7I78uN251+l/4KRZbDV4?=
 =?us-ascii?Q?VC3ekjb0ET/hs/ETa04VhoVGGTuOBs9EB0viANhV7QCclMJ2RP70oTo/ySnD?=
 =?us-ascii?Q?UyzL16K+lCHpLy6KnA7WOk7myWGn2w872BSqBT6lbQWwAdUuFhCW/mIZxXkD?=
 =?us-ascii?Q?aHAi7LPZ2GHY30eZbSWG2YyTgBXolbuQBDyWlrGxra0dpOBsRY5aIwXPph3u?=
 =?us-ascii?Q?M3hcDrp7XBjkPyeaueEs2BUFfvmfZnQEg847Wlqbe2QWDM3RPoC1PGHnzKpt?=
 =?us-ascii?Q?/E3B7B6fE4vShteFtFySv/mR5e78pydy6dlyc0rvOClY/K9Atr0QXJxws9Uh?=
 =?us-ascii?Q?RBNxaEzBKZOGcfDPUqlZiPVB+a4WkR9tVQASiO072FkxLemZdiFGxoTZ5/XL?=
 =?us-ascii?Q?3ep6s5SDm69wRPq/KpfGd4SyPxzwTSTJ65667r5peGCUmSdSrJegZOogwFCA?=
 =?us-ascii?Q?bL3ey7+p5VpMa3+oGQd8wruIQlR8PX5Tmpd46QfVzhxfv5YTrXhunKbFzhZO?=
 =?us-ascii?Q?+ORlxaSx8DuOkCSQ6JOlK+rpd5Zr/aT6bq2XO0A+xk+dr6h6mHTPIsUb0Ba7?=
 =?us-ascii?Q?hASmrGZBJ+Yz9y9sekurvDHP+3+WT4gF6OYe80bzPjvXJxwrOcXAW0eVhlBl?=
 =?us-ascii?Q?MIk7XstZuj8qPWjqzcYzkde4AbmRw6pnLCIX6lTKViKmk29dxQlN3DS0Nic4?=
 =?us-ascii?Q?yBH9mRFgEtzGe+VbJQS4sCFtjNpg5Jo7Xok56YYIYIF3gg2tWCYlDBLIwtPS?=
 =?us-ascii?Q?BjddUK9zHiYo5OwYs6ukon6HM/ubFasl3RJc9wpQ631Ar6fmei/9GxDhcaMS?=
 =?us-ascii?Q?nZtXb+MQxbVt+DweGbOu8cClr2OjauWTWlEHhbfj7mAMGbv8R+EdbFfPlU1h?=
 =?us-ascii?Q?SysghU6TUunBigsYnjs1XQ3/FwkJm32lyxevA2jmvSkLGZF9wvTGkQF13Maa?=
 =?us-ascii?Q?HouAIwU8PPnf5xKke5aogbMEfyEOowGRxDKN9iR8nE/Rs4nIWlBMZwNuvPtu?=
 =?us-ascii?Q?2ZPbElPvkuHRmtyBswzUf0JZ3FeR2CKnn4lpl3mLD4EoSCeuevnmWr/LYQHK?=
 =?us-ascii?Q?nyg1SQTFKr7oxPt8sv/hm6l4x9UpgtrXocfyg4tpklBDinzsMkBd3ViazkLO?=
 =?us-ascii?Q?XuZmQy9EfznyFUStLHpG7lr6V32jIzjQHbkQDvy6qBEcvdrOHfHjW6/AXic6?=
 =?us-ascii?Q?cm6U3Vw2RHqiVeBduCcYFcdJ6H2i85FM2/k0SQpnIxDnY6Zcrsgas9pPWmJ3?=
 =?us-ascii?Q?4FmsWwSQbIbgx4Z+G+hR4eeF9FESAofr1cX0+Dm7xknDbs8e0u3eB+gcsZoO?=
 =?us-ascii?Q?0f6Pv/QeJvaf2BMhwTKL/TdhKKJ/Z09hIa9AM8dSY1WQJAMxmjNxK4mC/JAs?=
 =?us-ascii?Q?vu26/xOtRQPcN3L7DWyUgCf50rVmAOjmZZJ8ZARKMHj3KkM5NlKwjqO6DV77?=
 =?us-ascii?Q?9vdc1etf8ZozpPf3kvFM/NMKI/SpLZ6W16sJFD+ysAcbQNC/6sUsgSFmvEW9?=
 =?us-ascii?Q?sPp/rkUVFUz3DGY6d4Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec849dc-1ee6-4528-8aba-08ddd82fa0dd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2025 17:02:03.3537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ATcPNo+pa28eZCR8JftR0i9jgCDxmwcDt/C1JwNANqcLcmzpVdD0nFciBdhhfL3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596
X-Rspam-User: 
X-Rspamd-Queue-Id: 89AB54000D
X-Rspamd-Server: rspam06
X-Stat-Signature: uzcasw9c991w4o1mfxuce6jyp4w3taog
X-HE-Tag: 1754845329-113954
X-HE-Meta: U2FsdGVkX19RQ5GvRhAOsbd+KG22ETaFXS94BpOWkHbZTHSiZcShgOloIGV7RSt2Z3Wxq4ZX8pNYPBOLvn7Qj/gjXSYNIqu+AwSAu3taSZI1LIpIa74tms8XurnvwrGtdpV6DuHV5mJDBzKI9UYGCaXrUXDk9CP1c83Q0u2+GrXnDtxUoWxZ+16pEbE7HvYOuhMQUg4pOPs9n/y/Ga6CFcN7HF9wU4e8gGCpSO79UdfDahuu4uJZPV6znEqdDDXxHx98wDBryuV3WSgf9YyuQuWusYWYhCcPOZq0xmVpxjoNbFAQpd/eIbshzMOzjxXbKe9qPYgW1MZSPHNeJGD1SmKhDdA3b/o6WL1+f5K/8WZrYOHUQi3fgAoSX4aYrAfjp/i7uaMGe8997JWoWoq5vBGnhWfY1LLQhfS2vh9PFsnffKWbbeCwn12SOqfCBs0xknMeGYOjAWBxgotedtOonArjLCMr8GswItwN82qfuiYu8kNnQj9lJaqyEDDq4nkD6ygVSxdUgoAUVkZ7mY6qfeLcedcGiBUOae/GNmFM8N5YiDjO+Id5dp9h+cPkyldZeB5jY4++K0iy66cJ/gv/5ePe7+lBaBszVVDcF9nctmRk9Lp0cjWb6MRAUHmWZGI9xPnyoSFA+l1sCIlpoFL4WB6tqzXnYuBDzjxz4DRauvBdFJX6xanIHElDJR9FJGGVvqLRjyD9TIvZMDkMru3VVsoKnDS918Fxb2m7N6KLM3fLLyr8+4/bEbJGuzs3fmxEl4sAZNOSE9eObbcBiDMt/6pfn31lP/msvIF431dP5PlLXxFrDYdNRGrahJb5TR17QG3vjCZn5pgqbvO4+XKtS0HS5ciO55D9EVe5xde8Y8Vv16VySk/5wBrICL3f8XijxA0jkJZfT1ajeqQz4WNOskWacq5d9qc+1LUmRKGdidgEZqb7Zlgl+zNK7fAvXscWuQRe5AIkWWIieqeeEOH
 CmBS8sR7
 gfcJpCksBu+0wC15ADQNQwUYRreSW3QE/+xFkxzZa5jFTA3iaGEPxYlCMG2UIp5dILmvx7LYkftp0BRjrgLWAqdF5Ur2JspZcG8mhGiCPMpdOPvQ0bIeDFCqforl5wm6uhs3jVM4kTHjMeIHgLy+d7OpqBj+6osNVYyvSOjrkPsMKQdfE6+b137mcYli/aY94rBs0RJlfjp89CowPPAQ+QVLgE4Jys45L4CliVMnaRQyVt5d46HQZAFihx6uIQ2bpvzsSbbLTG3t4A94Lo/4H/i8fi6qwfNMg603H6Irkm3E8L8MxDPG49DkDH3afiW1eWBIrCbUpmmr7vJmbFA1j3jnhm5NZI3bS4sN/yKfxcOSh/HwKflKgCoQaC1165HsD1TQL5YMjy+sy9MbUIB4FJWd0cr5CillhEEHfZ2zj20INbpecyfJCNIKvypyntXWrCq6fnCbdBhWcmOdc39VyTwOvSHPYySmhnEuxyr18+kB+Pf3D6HIuN2X4y27buYR7nUygRwkxWWQ8QRLr/3hcX/gvzCrwo1H6GuoWvZOtX3VWaxCDliwMOHfdb2kq5k3DUtFK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 12:53:09PM -0400, Demi Marie Obenour wrote:
> > With a long term goal that struct page only exists for legacy code,
> > and is maybe entirely compiled out of modern server kernels.
> 
> Why just server kernels?  I suspect client systems actually run
> newer kernels than servers do.

I would guess this is because of the people who are interested in this
work. Frankly there isn't much benifit for small memory client
systems. Modern servers have > 1TB of memory and struct page really
hurts here.

The flip side of this is the work is enormous and I think there is a
general idea that the smaller set of server related drivers and
subsystems will get ready well before the wider universe of stuff a
client or android might use.

It is not that more can't happen it just ultimately depends on
interest and time.

Many modern servers use quite new kernels if you ignore the enterprise
distros :\

Jason

