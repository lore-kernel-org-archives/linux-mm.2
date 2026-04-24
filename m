Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8663F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE976B009B; Thu, 23 Apr 2026 22:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596926B009D; Thu, 23 Apr 2026 22:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD346B009E; Thu, 23 Apr 2026 22:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 399906B009B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:53:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C071BC37EC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:53:01 +0000 (UTC)
X-FDA: 84691927362.12.7329E13
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B25320008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gV6rChs5;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUkQ9VY+MTJt6n4cWazSUfRlH2DOHqT/Skwgr3P/y3Q=;
	b=OSgncbqKZeT6jNoEKvXP0q7tiqm75uxOgV/PkxfsVlKrfoksviaAbu1aLp0DMFZ9Wgecca
	JuaCvJLC26PIq/bRRDwgD5WJGNyS4LqGiAHOegv+vo2rLh3hiG3Yn9079ltjdk4nBUjTrC
	a6ejiWscIo0TTNn0+2JKOKX/o/KpLYM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gV6rChs5;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999179; a=rsa-sha256;
	cv=pass;
	b=4qtMpJxGi1ELzL0LliwhO9p2x5THoSoXzjqVIeiYdllBkUWpAGKkB1UwxMM5Y7PIfKw5B6
	iBlIoAvN22Je8+u29EcqdbtpZLYmUp9SDcZABQx+tlkKl64yazBDsezyoJfemhohJ9COcv
	yybxVS4zGUpRz6N0XduEbIrGzayvBT0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnteWQ7oqmyXoFsh8YlNGkW0LIqUauiiDkOZ4ImknOarFtYOc31twkAgPSPLYkOC4W1S0Qh94VXgBMYRsxg5fxxSXDgeEUi4cSyk1u+QDKQLnVFZUEhNTirB9yQoDVsHDSVy+EGqCsQ0pr9Crv4gNKtQKqqp9ioWbNZjY9hX3MI5i+6ZCrgWmVCclU6DFX96cZEa7Q0VkYve10+8rF+NaGbZQmHj8dT1fj7OB1TK4GLhhdAQxN2ijQ6eCCOadsyDW54qnj2mwwOu5s/8+PSo8gKs7sMpVLfrwiwf/gUqFGfjWo+JLFYMcSsrwZiW96wtNuPi3FMQzNprDlVaq3HPSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUkQ9VY+MTJt6n4cWazSUfRlH2DOHqT/Skwgr3P/y3Q=;
 b=wxX4uOW+ZPai4OaQJ/h7LgHOLrA79Jfbp+aSFAXDyvd/nVvPa56qvmLHSYNdxJ/ZQ4bcLtwcvoekRqCBbR/rIQvaY+aNqCsxCevLinr2FXwjiMl7u4RJjAYNWWOguCaPK8UpB+EXEJIyaSYX2AgAM9os9ds6Gtdl0PrjFFcIwJ5V8up1hJ/jkWSvQlfuekKmj+3fibA5wgUsQVG9r9U2qDULhtWh+FgqUE6V3qbzJPXKc+MuCFVa7fw1SnXzC3BcUmvP9IK9VH4ZkVvHLqNhJEOLfHycEdeCcLXEXh1Gomp+77BORwE/f7u9KyaXH6w9JYxZ1b+QGgbhhcZhwFcPgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUkQ9VY+MTJt6n4cWazSUfRlH2DOHqT/Skwgr3P/y3Q=;
 b=gV6rChs5mQITajpNDk1mT7xIfKqSPvOmOt//3qlZj/NDWeyfzyrY/cEGW4/udJyDduKmZLk4gPEl9bb+eavUQN2kAlv6T+T4aDcE9HlSIIwNFVntKv3Oh7UiJ9lIwWQnrLILmrVgLvhX7Vk6CeXZo3/jrmhTRj6NoRpElV2SrOB7FZpXcwQkIU4fIbp3O2skWKt/t+y31vTAbqd7fS2oISgoe/sjm7XIFUQZNjhbHv5SXPMkPv09qNBGMwRtY2hi3tkePo9oXPcZTMfZ4rUunO0n8gGJenv4FnZlsKYtdkSTQITZWTkloruOWqgxEKMa31z6+dbIa9lzWOtnx3MrBQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 06/12] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Thu, 23 Apr 2026 22:49:09 -0400
Message-ID: <20260424024915.28758-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:208:32e::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 83480e9b-aef1-420f-4cf9-08dea1ac7ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f/yuDbESHxIL1aWL0JmsYOevyfTm79pTBoi492TAoG9wO5s3CXF/2N7TYqlutpzjnRwlHED/x1uTR7/7eXwI2XdEUG0HrprkpPaL13HxtKddxoLD9+m35UbKhvojcqz5w0YysamRC1gHLKuCoVhbm1LFgmgNVfnT+P4qlKvH9PzJR/6tvdjFJjKzfVOJ7rm7jkF7/O0esJhTSk/kbuwUhDZgg0/jhQpkGp0FECNQFeP65w8J1QD8Mo9QhWGMBuV+uNoW1XdobQC2q4xT6MvOY98t6a/uepCshc/q6u/RNHz7GT1+lJM86XJEvj8cTB4WKqpPDVoHTsSQIPrJLjWNuhAiY3oBzXdetZqXTM0uL5buy4yq1DJQ1nuGiGVwsowrKud5HAB8NlEC5s5Rc+UkndHEmLcyeh/txGvuuy7noqmYHZcJDLLSqSBNXTcgK3+ViFBFHVseOFSSxw2Lz+MQtSPJnu/oxVTXjxaKtt9T2xOALyxN6RS4yiteHE5f+3BVsYDnFyZt/RvpbysPKmW+aH1BPDtajlpAK2V5mfGBKtqxu2D2NdhcK8LoMJNpFyqGMnh4W+nSwQCEPLrM+JRgjvSMcaDi4zlksv/mcYkKUtLfnQIx8r5v9znpIhQKMzMcCmeCotx6spuRtzwmGKJuw5HhA+DlS/Gz+JQCPrv/ZyHQh3BDEO2v03ZyxZx9S8hTOirLdAtriegbU+3B4+h5T/jOpAgzlH9e96/vMDJr6eE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kxgNAgM5doLonf5SOZg1CTNtLpTfbTCp8kyDp6BULwMSX8ob9iqlvo5q4ZO5?=
 =?us-ascii?Q?Y6Ep9NP9yIjimDfOHF5zaPXa629NRYIiQuLOqZBDmM3x/rZEyN+EdUGgLUQm?=
 =?us-ascii?Q?3gnBLaiShIyOsfYOa4u+cvRKTzmJCY6i5Bf23gt0SaiDCIh8gbB2f+TSlvoA?=
 =?us-ascii?Q?53nga7IAvLxlxJzZMJoIZMGEhmsdQI07KJzgT2d09ACVAv+F2y2WqMobbrvo?=
 =?us-ascii?Q?kim7Jov7kkHmj166DfppNT8TJtPdhlz7XVHZ2KYRetpcCZu0GYqOoRBfIkrr?=
 =?us-ascii?Q?CyuBQpOU33gYAvy7l+2lCwSqFrSaZkPWj9xAIYJ8RY7NkZWNgg99qo4TFEf1?=
 =?us-ascii?Q?wUIR7Uf7hDig1EzZISw5u5oNJew7EpeV+dn+RfqGc3d2cCvYkoOGqhQ2Yx36?=
 =?us-ascii?Q?zsICDR8kmflKuxNf63wFzern/jABCJdnojKHZcb91IUWot4O3W9JQYSTQ1sZ?=
 =?us-ascii?Q?aDGeUTlGYVTSw7nmW91952OD87U1wDtd6AvloBsPHm2u6w+K+o71ObwBhejP?=
 =?us-ascii?Q?sDT+3YqHz5vQdY1xE9IUP5BfA6hcJIg6L/VZllIvHUoGioflYPmox/cx3um5?=
 =?us-ascii?Q?JX3XxwHrULzSUKP7AoIQNGlZNDa6BMF20uFknpr/dNsDoeUsi6lrEn0COp/j?=
 =?us-ascii?Q?wQMEz3GHdhcLuUtGEMTNE3H82LYSMNubdKnQpzpvTbNMiTSamMhDnblOBhYH?=
 =?us-ascii?Q?npW7nHWP0gktpDa8i7lNhBtY0bC7tTNUn+azlAsOEdoiZOJRVxvaZiMaUlh6?=
 =?us-ascii?Q?+NPMRCTpR5xTOEWxJipv/DanPFhMx03KiCQyq9knjutZPJ8NxjNc473Lq/kn?=
 =?us-ascii?Q?nFHmxx0NVj1rJ1/fXNYrpflfjZqxmsQ6zcuLoI0d2UJyTyEM2/aU9ZfdFTYj?=
 =?us-ascii?Q?vOb9sGKjJuoKAzq9fpa3uXwIfUl0gM7O5Q6gEsqbbDZHjvPwP2J5aYPE8QSJ?=
 =?us-ascii?Q?TLnWnroE3vK2LL0V9LiEWuIyRdw/8SwPJQLZB/11NidYkhL1vv0jLUu2lI1q?=
 =?us-ascii?Q?NtmyR6rw6dSGQeYeztC61D2TiSewBaz71AOYOQQCJqElmvO5zQfNPlLPWgxn?=
 =?us-ascii?Q?dAyjyIh0ZtI8Yj06YrE4TwNYuR/qo3FwVXYL2nW6MeLIWBADOhVoSp7Tf6XJ?=
 =?us-ascii?Q?xiTjDUBcHwdKR2yiPtiGniwswtwzM+5jVB5HDEbUIoIAFAUGu1CeAlU4xEda?=
 =?us-ascii?Q?fnW7/Aginbmjll0kZKkMiHSlwD4qibAg14dGSsAuRuW+8wmBkIwSWzrvhZzL?=
 =?us-ascii?Q?/258at8gAGRCMNS13f1Ra3TFdyMN6FiKsIYLTjfO+dmCsDE6p018hfR0367x?=
 =?us-ascii?Q?nRQeRZ+8ny4VnRxdM7F1NRbNmx69JOGSuXqZXwAWXs8GGU9giJqg6DmWQBmD?=
 =?us-ascii?Q?rvn3vnyqgosT4AcPfEnZslB45Mcqb+7MEglzvRct8v/SxPrKtsLw8U5vJta1?=
 =?us-ascii?Q?gldfnzv8r3jI7/TAruQViKL0y6ZjCvMpXRsKnG0YCCHQcnxK4V4GxyYOWX7Q?=
 =?us-ascii?Q?gYKaTCUD1TuG3k2t5sndHKrQl3H3X59VjrgXxjGhvZ+fp8ZW4q47DgSrDzRh?=
 =?us-ascii?Q?Hf0q3YAaCg1TVXiAcBxb+ywByOyP3jTMbR80d4zl68swYOnkVF20OYkVHJPQ?=
 =?us-ascii?Q?5rRbFFHC37JOcjKHEY3HmlBYO/jKi20nTjcES6/sJSL5DojnksY4/CwtX6UX?=
 =?us-ascii?Q?BarS8oZ6Eo68pu2+lOruLxd+xGdhE7WCHxC/3Cue9BVsnTmz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83480e9b-aef1-420f-4cf9-08dea1ac7ecb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:16.8195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzIJu8jCK1zXbGbWqSYrMkh9feOq1s+mwAuhmXtz6AT7jmGO61dS6oPbybmALyE7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Stat-Signature: x3mijhpeefkywkrhgtczr8k66gnrqp6d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B25320008
X-HE-Tag: 1776999178-713650
X-HE-Meta: U2FsdGVkX18HSzSDCNc7fhNl2Y3y/APzDxcq6FlThcPlCwhByvpD0ozuYFn2svuYKTLk8HRDpQO25GkSHh+7JEYofwrKPRbmIspP4vJAKJ+aww5w9bEYefJmJoHalX+cMEuBm4V8XFJSIUEekVav23Iw2mNoFekTIUQFskmtKbBdLb0K47ah5FmcpGKd1ynzZ85Cdf9BB6SRto0TLQyKL+dzPFPUAKTc5sHTvlySdGhQX9Fr6T8ub7WBFHHj6wblk518r3KYIEwSqTiwqKtLG9epxOg7b4nuSeXNPBGv14ypNiS+lzbhJ9QBSEcLSlJSpZ93DuZn4DyKT1Ms6YIFUJ/dPFhsjoZIWQ4UPn7P63WR7Kbsk21Uvir9h3sklqHC/cqubMw1USg+51UPMShj1bf0hHRuTTQAXdH5NyL8W7oBnp9BMHOFuJtIu3uDouenQ3MibzfR2Ywdu30tgAE8QlfH6+rz5E1rIfzmpsl5TbVYAGT29owooMFmXYL8QVcWMWIDBYrWvWlvHULOkJvvB4bt1ae7TR1ECRhjqSK/unIrkiO4BZ/24L2go+WyWxNiUUZw34olVb/4RjKXxZ9KQqHP+CPhaUm2tUNCrb36adt4m/A94w8p7cGyqy28/0OQUITkt+KNUS6KuAxvrHmBSkmUY5e0OfpdYV1OP7Sfsjxq+ge+/9Xqd7pNbnMLYZBPh9a2D5KLRQumDvV73fraMfZ0vlwP9Bc2mug9WgACNl4fkXT2O/nSxlSlpoqxlp0K5s+9kFEHe8ys0aS+5ROC1/s/I7hrV2ZNdUuZvBmeNjrK840OZpoYhKa25nsYpw77Ujgbfb9TegYNLIEeg+f+/GTkHFOP8z0APG4ZqSMOmeIN6UEKpsQBw0fixSov+uIjShI/g8fW15MAE1qZCpnbnK9IUdyZ+ukNz1niEU8zPgTnWWwaRCdaaNP2CeaMn15BXhkMfPovlqYbHHSz09X
 kViz/+DS
 p/y5AEsXbWOpQclS+5cr7O5RYy5J9ss59weO/3WCR6x1HLh9A25nVWbKoF8k2NqnMhv1ArV6TcsoBZ8lo2XPb1ASPiFN+xYUgGvMQZRLItVi5BySnIcCjwjDSFDGVze/DhfcomzuxaKczUseKV7CnDredgCBy6mwn8GfjjA3yJs0QiloUTLjKAS9F5uVVddh8WvDNPFHnGfxRt3bYEt5Omff2LLwnFmX0k5CARSzfC9KE19gdYg5GGpmWkcjDxEYtdchXo8hkK3jbKkkZxSldoYFH812FeaaEB2nSO6ChseLlHdMmpj6fbrZhY7b+SUw8oiKWs+I96+1TfDMmQgBB/g6bWpk7bUMnbZa6QY9gl4USUhKIri4Xs6VQUvIPf4dZ8Zk1gXmJPdzziM4CvMtA1KNmLbltzW/UNb8nZu7rhPvvYaCENsWBuxv11b3HDqKTj+68gfkEMsujWEnv3D/7avHNfLV+MTnpPsiNA9c519OSfHyP3Ty45TMp7Hz0Vjq/8iU8xETJmUlRiViDnNuVqWLyfb6M21u4LHXXPCAllR5l0V2dR/iYAe+ctavLZa5CWHnT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable. Now read-only PMD
THPs only appear in a FS with large folio support and the supported orders
include PMD_ORDRE.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() in
collapse_file() to make sure no writable folio can be collapsed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 fs/open.c               | 27 ---------------------------
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 mm/khugepaged.c         | 28 ----------------------------
 5 files changed, 86 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 681d405bc61e..c321b80027f1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -968,33 +968,6 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 5b4313d91137..88e58ca79bb5 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -528,35 +528,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..d3cd4d2f3734 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f0db1390a18f..8b85a3e58b00 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3937,7 +3937,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cdd4b37e4a68..4de7e30c4b71 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2469,21 +2469,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
-		filemap_nr_thps_inc(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure i_writecount is up to date and the update to nr_thps
-		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
-		 */
-		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
-			result = SCAN_FAIL;
-			filemap_nr_thps_dec(mapping);
-		}
-	}
-
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2661,19 +2646,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio_putback_lru(folio);
 		folio_put(folio);
 	}
-	/*
-	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
-	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
-		filemap_nr_thps_dec(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure the update to nr_thps is visible.
-		 */
-		smp_mb();
-	}
 
 	new_folio->mapping = NULL;
 
-- 
2.43.0


