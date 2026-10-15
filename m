Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBA8CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8403F6B008C; Thu, 15 Oct 2026 03:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818136B0092; Thu, 15 Oct 2026 03:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF726B0095; Thu, 15 Oct 2026 03:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 433626B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:59:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CEBA808DD
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:59:25 +0000 (UTC)
X-FDA: 85324110690.16.B2D2346
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9246B1C0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:59:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ejygrzo3;
	spf=pass (imf20.hostedemail.com: domain of icheng@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792051162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LjhI9A+fatS+RC8e+X8W4TZybnwY8MkP0XnG1+bKJA=;
	b=y/2VbE8Eq7cKgmG9ELK4V+njy/Lfu1j0o7SD6Tgvg7S07o9aPCSKU8Xag/fHkQhKb6bwhm
	hlxG0+9KL/EOjw5qeS8Li00JCvFTx0D8sC67KgW7LTZa5xnJAn3FXh5T4KQ7Y0GNE5Xcbc
	A7PT8703J34LLJzQH+SaK8yjZWdR2bQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792051162;
	b=Vn5FS5sz3GI1jbL6SNxxDJAg7tTTnyw6dq+S+nPuhqxDxsGNw1guggU05hQk2wRF1efjWE
	x6ULENx4UdyiImKW/BR4RgJsHcFolDJJD8ScGhLl0IhxBN82Yb/aFjg3NxOHQ4D9MkkW8c
	oDvvgqZow8O4L6/KoH2Y3LzmTNLc/tA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ejygrzo3;
	spf=pass (imf20.hostedemail.com: domain of icheng@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=psb5x2BeNPlerF6Y4zhSnsBldeBPx3BJ3h4tYXcB/46c+MtD++avy9WV3ozkpu1hsih99Z/Qw1aGC+AbYvPD46/sTapgj2PY6JoqW00o/3ra2hcdYAGCkl98T1zTSV73MuY50TQR7KGFJnn6ikFtKVQOnwv6OTAXTeIOUjG/0yXsKo5S+OFcKW+YJmn3YmLyzwwkJL6NmXm/E2MiUlIqO43tiTxJQ/AUHM3d+8RnUZ8nABA+6rD4/t2Ob329SVdQ+DpFy0xcJ7meNp4fbyOSFWQZUci9INIfCQDmwwFcnLFuOhUoFrGmaO20x3IqUeB1aMyJQx6tn+/rqe/sHc30oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LjhI9A+fatS+RC8e+X8W4TZybnwY8MkP0XnG1+bKJA=;
 b=ooxrSPg32tMZIdjluayLWfjUUUjU4YRMrW3kBj7byUpCA0mo/5j7MnyLBRdCyR0P3J0reHG+9LlkwfkltBMDQq7fCkEusN2FBi6VSP+9NYOnKTW1JebpXjZlzlMfugGQade289Zqgp5kh/C1favlG0JrGu8NdxmOq2OvHmcQpVHwWpNPYj5rbx534R9xSwATAwB0G/ww6j1I58XAZRHThx2ObMswzgcM6vUI0L+OPouQZ103+em4u+kgwvv38BFlRWhCKmYLqAF1UlJSyUeVLFbMBCu0Z56xmnNNu8qVMqIPJ9h2k3nK3VV4xZ75xPLGNDrniGfs+nv0b5IgSSYCGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LjhI9A+fatS+RC8e+X8W4TZybnwY8MkP0XnG1+bKJA=;
 b=ejygrzo33pvpEDtuKT335XtHTfLlVfHSXsC0+pOoiqLKR0GnJOkKMezhAvDiXmLZLqeXTNLvIiDMsmb3/luHCQHUro+NN1RuPNx2m2mYcerDeK7pAohxkqpTA6iPNuOKBOUG1AZWxEMzd88uEpWNrFieys81oPWLV0mU5PDcPZ5jJyrNSEp2eqyxvjgsOEJoerBIXbwnKvVptsc1rgorO8QAOwhNdsswf1xxEOVqeBkhJEfXIIiytW7qJYUFib/XwGKt0H1TgMS0u4JBG7vjOyKJZ3pfEHlAK6pvumcJmkiAjeb8baHZhcCNTjD9xWhtqKVnBTsWQpbFfrwX/PCF8Q==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BN7PPFB3F5C406F.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 07:59:18 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0496.020; Thu, 15 Oct 2026
 07:59:18 +0000
Date: Thu, 15 Oct 2026 15:59:13 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, 
	Jonathan Cameron <jic23@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <djbw@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kiryl Shutsemau <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 5/5] cxl/region: Register device poison before
 exposing RAM
Message-ID: <atCGJHmnk8Ll8pA_@MWDK4CY14F>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
 <20261010162017.62506-6-shaikhkamal2012@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010162017.62506-6-shaikhkamal2012@gmail.com>
X-ClientProxiedBy: TP0P295CA0040.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::13) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BN7PPFB3F5C406F:EE_
X-MS-Office365-Filtering-Correlation-Id: 783a9167-db5e-45e3-1abc-08df2a9236cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|261009223027099003|5023799004|11063799006|56012099006|6133799003|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	nL/kEEwkCJ51h1sH7admAidGxLqohRmikiHDg5S1Hiu0T9pcRIHpiUACNz9jv8/8Gk+Al/jj77fs2Ah0OnzXGRpgd2TqZbVr+7EK8w8By2WCtvvw+luZRlq0u728xnIJ+8LinA3CbsloFJpg+mJWeT5IwDgd96HirY9LmDIMg6I2vtcbhWyGj4dElLysBvc6ZBnBYZ/KNd3LWykFWh2Y7eHupK/JDEKuWRZUIoNduJL2A0n/N6nxLtWp2jnseWrq1oBkZOpylJ3paAdFACGetNrhJRxt82dO46hMSsy3Nxnt+ex22Xhs8WqA3WmPEHcqoayZkDX6rJbeQoSjHebB1wQFIWUWw7ZH9KHbrUcpE+L5ByM8T7rHNs3/cikwCLvlroBfImPDuZO6ZGjj4E50M21aUr0JV0SjqCNoMvS1No8v1AL4u2cE8ivYHBieFjMs8zVncrAFwuF/iGoSdDjnRvPYC1fZ9liEPhNFkGEs8K8v84pz6fIy1nYpaWKvnXptPe6mHqFU2GZnCzgLTc4roAZK6NDazCrV38pSZnnPoPZPeMGf9CPh2S2vCy23WrdIEpsuSDN9WwgpoEc4hJuA5jgv1IAfe5RAWblfglrDpKWZ6MlDvxJGyp/Qw1BLcUS4vzR/wmR3mla1SDtkD3u0R6X0Ug0gHh8RTYc+qnMxLGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oem9J2cNBnDabVJLmxRETFp7X2Zv38I5j8SzqLLxI+Q0pcqTYPCDKHTNWNMq?=
 =?us-ascii?Q?awH6mmj+IF6rehD2c1a095NULI4ZfYmsqr/ErNBIInWkesLnUK261KcTrqS2?=
 =?us-ascii?Q?qjx9332hLbGwYG9HLxA3ROX/6eWutOoZ2pxbTcTgJr5Jpu5jo0wftG33NuMY?=
 =?us-ascii?Q?+bnUbcnvE9Hh9q7RbodgumRh5T5/dvzURwYzX2nH4tqxE/k9tBimxt5P2PDi?=
 =?us-ascii?Q?kMEqltrTNX/Q1EmkTl7GMS2pm/BLQiQRhR8+khgqgkq3rJB9Af+FnigR6zKd?=
 =?us-ascii?Q?EIL3NvdH6J0g2h8QHPwldvqVNWKLRsYmgkfr2m+1xK9pwPkBwWQMk/7VLDx5?=
 =?us-ascii?Q?UO3fel+YV7m+BMeUQXEH4SMVLb4xQBrq5Yez4KWe9gBZspuTQGDorY2umbif?=
 =?us-ascii?Q?GEdamomCag/GjJOwgM1zGdb8KfyS1Jt97JP72J75VyLJVGx5n8dGpC7aQm1C?=
 =?us-ascii?Q?/+rEOhnYigNjJEkvYMc48tutZhVwknyda8ei0thnRojnuyfvnB9UGCYOVVO1?=
 =?us-ascii?Q?lUJnzlKE3l1Ezj+2lAEn47TbW4kUQgQ/dZzCeCZlA9epLPOYTOOZSI0N8Slr?=
 =?us-ascii?Q?TOwVtnClqJTCpda4Tl1Rs721+DNzBwabNsbqJU2pgRyzhfWNWHUf8V59t/KQ?=
 =?us-ascii?Q?L3mvfoBaY9dh/PbBvBTI83cGch5OpG3LTMMRKsJiwWKS++q1ZAI2KsamWveD?=
 =?us-ascii?Q?ecjz0HKxI6b+mK773VIkENEbaM/VhAMSNz9SC+IvPpEcAJ02poSrVC/o8EyM?=
 =?us-ascii?Q?w1Bs7QDdX2k2ITO9FjEtF+xQ9nnmel8unQwYM1RURbaEKNAHAcJo38vUdTHj?=
 =?us-ascii?Q?eK1OV8jUsFJUxz5IILHlLO1JIOBA0SYDa4A7Dw/h7/xPog//rCWTBB31czw7?=
 =?us-ascii?Q?BN3XR9ZGG8ADoSRXMTNtR0SzUWnHz32FQEtnWl5C2IjfPq71OFYV5viTSKSh?=
 =?us-ascii?Q?oE6d+KqfcDbN0AF5GUieTOwH9mnEadruU08QuMx6EIKUaaEYqoZ+VFzalX30?=
 =?us-ascii?Q?yVG/+kj4mzBnYr7YMhVIJaNukpP5ShqKPj+INE7UZ1POfV7+sml18FALck0S?=
 =?us-ascii?Q?Dm7CfKde9m2Mgpoup4XGFHFytWaYAJMk0IMW4FIDTyaNs8Zd2fkIMeSlUcwW?=
 =?us-ascii?Q?QlV5FuUr5ymBbeFKBwaDfgezj+dZyO35Z8SmSIwJTq7Pz0k0VX7NH/GtNzSv?=
 =?us-ascii?Q?PPziiGSNOCy8I381IdjerisN42UMnYC0WWx2lOu2ZTR567G+/1L1k/tD5GCw?=
 =?us-ascii?Q?U+fRJjgdeKM+TLDksZjH/gR9SuBwROi/khTD8+xERJxoZj3N8lQ0QX/PDWSt?=
 =?us-ascii?Q?NPKChzdijnrh8n3vIhIO249F4rvDX7ZVXz+XA8m+xKunXB7oOYJMkCxRH6sI?=
 =?us-ascii?Q?1cAG6M1L7GMdeDd9wR47z0hIG1IOhidZB1cAcwQzw9K59RKtSputJSz4T6M9?=
 =?us-ascii?Q?D6KGmg+bZ+2olNtLRQlKctbo7Q40glud3vCWlkCLZTVwKs0dRpFSkachKUxC?=
 =?us-ascii?Q?MW9KKgarJFVctJqUmOAcak8MbHKV+H0ZzhWxE7XuLB3LOOirHp+SuJImKLNy?=
 =?us-ascii?Q?9MRZSgs1RsBEnB4zQPUzgkS4NbaKUGcVLJgvPSHt/5g8//VuZyMPRlR4vNfZ?=
 =?us-ascii?Q?7f5Jzv5p9xfkyf2qHF8MDL9Bq8mQRQMkq6HRTlURuoJtjXNFiWtQ2G1USAKy?=
 =?us-ascii?Q?sqjElEC50fpwID+uK85176buuu2qLiMc3hCKdOAM/xXBamqN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783a9167-db5e-45e3-1abc-08df2a9236cf
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 07:59:18.4260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: noG01ic9F8rZrCe/ZXUTHIXdrHNR+/P84DNacKUmsxauKUGhsTgGgpLHYvE+HxAPYOWWm2i6ekJvXI1nAbeRCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFB3F5C406F
X-Rspamd-Queue-Id: 9246B1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: i35336xxcpccouf6cznhzr5uoj8erhbn
X-HE-Tag: 1792051162-823425
X-HE-Meta: U2FsdGVkX1/gAWjiRTXEp12el/i9jeMnNIN4uV9yaupDQ8/crxDa385cx0/PGHboewi7lGSCkXf85PaXrA3f+I9Mp6EryxHzgLTkyw1uWc6+p4Ae3v7EjgaSPvXbrCPfHW4FafvTydR7bfFsglgNo3hXpQ8MMJ0RZMNNKVZEkGiY5gI5rk47T0jzCK/y1NPpVj/gS/RJbIaAOImy7Zdeek3bo/hYRr7UvSTz3rQptCuZ1sB0sSqzjXhjHys/Hj1s0fhWJOTbXOUGXa8I9gDOLAw++mECf2mb91dE26DefhC2lPLH4y+JCqJpcnP8Sd1UeNrYmRGbtSNfuF4pMaZ65PPhdsNgnSZSxzn7xQQ+smxdyFXtDNVvVDBHVnWufsQ8W8u2NkmxwdIZKTMF02ZTrYBs0YGx7Vl8mVqg+9KXgQbEM9SpAKq/1aGctDZNXMFJjTgP9U9yrzXWE9s+vgqCpZHdMXn9sdi9P6jq/GkBPc0rv0E3w6eLivdjwtKEBILjpvGGS5AVFClvgN/6EnQlbH2+zN0ovrFxbLuoBAt7kZ56e/iVa0MH6AcgMnN635UL2mBcK9bImNq+2GaznZuqxxc4ytiqJiggdzah32G/iHgZxk1FnfGKlyRz5yk7QKSr1tfiTszDPn2olrIvoVY6/AwrQIz+AJIqVED1ttv104YIaFwicZ05/xHSFkbZ7tlVd3JROEjN4gl/STgkVmkzusmYg3tx6ERSdU+m9pqm2zOOIgA6FRTkAj1L1GSQztXjUtzu93DDKCAML38hCdfVI5AHlerlNV9tQajbgtNg3pZiSPIXOHwp9oqgmARElqZKS1o1Nb5RNrV3yA6f0HRg3ypNFzQRziaz8u4/+ZWrQJPYrqCrcc8BO1wDZ3Falt6+BNt/FgFl7NTt/ovyRin5CTyR8ivauc2byoUknlnv+Zt7OKzZ3irPU6qkeNTKELzx3tn0GsyQPPGOP54z+py
 G7xEeXxN
 b/0SXu0iVyALxUzyG6UM57SWPLEDWHywaNau/xJ+hYGXr0Zo6dNCeC4DcLA1SUoYKYdSAscC2vJ2kpzehFv+aJqHMxRMqeFiWNA9spSzCFKdXLzQwjWpukyYeMDehrKigCqU8jLuC9S30IvMW1HxLuXUiaHJWhDAdazY6pxYYcKnwKa3yWV0q+gnzN6l6+ZdgBluiGvztM5+BZXTR2AmbtN4+W9f5hv+kbMf0MFrCQdjSdONjrGgbhaVrKfCfQaR93EVy2rkQT/UfACTC/8YjR2bWTQ52mCWGHQzUSQsHS8Fiw7mNFN7Z9P2P6hKLXdShQCxocL95Uk9cbY26CDPsoZNm5VAhWx4R45gByj97IMn+v1tmx4tZklF7h60uSq0/ygOkDJyFWX2k2Z9af2geVtHHjeGlvEcx+iuYCD5dNC7F5km5outVOPCpcmc/a/+ejbNBFGX7/fg+uqgD7WnGMAWrxYjudnfMcXz4Fg67ASBJc9+1xpCQzbUN7vBvLSKSbAZnAn+GqQfz+DD6aOht/U9IEGh2kT0w0v/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 09:50:13PM +0800, Shaikh Kamaluddin wrote:
> The trigger_poison_list interface may retrieve poison after CXL memory
> is already online, which is too late to prevent known-bad frames from
> entering the page allocator.
> 
> During RAM-region probe, retrieve a poison-list snapshot for each
> participating endpoint decoder. Validate each record against the
> decoder's assigned DPA range, translate its poisoned DPA units to HPA
> and PFN, and collect the affected PFNs in an xarray. Coalesce consecutive
> PFNs and register the resulting ranges with the pre-online hwpoison
> registry before creating the DAX region.
> 
> When Get Poison List is supported, abort region probe if the list is
> incomplete, malformed, or cannot be translated. If volatile poison-list
> retrieval is unsupported, preserve the existing behavior and warn that
> poison cannot be withheld before memory onlining.
> 
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
>  drivers/cxl/core/region.c | 322 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 322 insertions(+)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index c72524923b38..e3ffa77927df 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -14,6 +14,7 @@
>  #include <linux/string_choices.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
> +#include <linux/memory-failure.h>
>  #include "core.h"
>  #include "mce.h"
>  
> @@ -3038,6 +3039,323 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
>  	return rc;
>  }
>  
> +/*
> + * Device-reported poison is gathered at RAM-region probe, before the range
> + * reaches dax/kmem, and registered with the pre-online registry so the
> + * frames it covers are withheld when the memory is onlined.
> + */
> +static int cxl_poison_store_pfn(struct xarray *pfns, u64 hpa)
> +{
> +	return xa_err(xa_store(pfns, PHYS_PFN(hpa), xa_mk_value(1),
> +			GFP_KERNEL));
> +}
> +
> +static int cxl_poison_store_hpa(struct cxl_region *cxlr, struct xarray *pfns,
> +				u64 hpa)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	int rc;
> +
> +	/* Outside this region: not ours to withhold. */
> +	if (!cxl_resource_contains_addr(p->res, hpa))
> +		return -ERANGE;
> +
> +	rc = cxl_poison_store_pfn(pfns, hpa);
> +	if (rc || !p->cache_size)
> +		return rc;
> +
> +	/*
> +	 * An extended linear cache makes the same DPA visible a second time
> +	 * at hpa - cache_size. Match the translation used by the
> +	 * cxl_general_media and cxl_dram trace events.
> +	 */
> +	if (WARN_ON_ONCE(hpa < p->res->start + p->cache_size))
> +		return -ERANGE;
> +
> +	return cxl_poison_store_pfn(pfns, hpa - p->cache_size);
> +}
> +
> +static int cxl_poison_record_to_pfns(struct cxl_region *cxlr,
> +				     struct cxl_memdev *cxlmd,
> +				     const struct cxl_poison_record *record,
> +				     struct xarray *pfns)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	u64 raw = le64_to_cpu(record->address);
> +	u64 units = le32_to_cpu(record->length);
> +	u64 dpa = raw & CXL_POISON_START_MASK;
> +	u8 source = raw & CXL_POISON_SOURCE_MASK;
> +	u64 length, end, step, cur;
> +
> +	if (!units ||
> +	    check_mul_overflow(units, (u64)CXL_POISON_LEN_MULT, &length) ||
> +	    check_add_overflow(dpa, length, &end))
> +		return -EPROTO;
> +
> +	/*
> +	 * A corrected error never reaches the poison list, so every record
> +	 * is uncorrectable. Only a failure of the device's own media is
> +	 * withheld: External poison was written by the host into healthy
> +	 * media and a rewrite or Clear Poison recovers it, and Injected
> +	 * poison is a test artifact. Withholding either would make a
> +	 * recoverable state permanent.
> +	 */
> +	if (source != CXL_POISON_SOURCE_INTERNAL) {
> +		dev_dbg(&cxlr->dev, "%s: dpa %#llx source %u not withheld\n",
> +			dev_name(&cxlmd->dev), dpa, source);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Translate once per unit of HPA contiguity rather than per 64
> +	 * bytes. Consecutive DPAs within an interleave granule map to
> +	 * consecutive HPAs, and a granule no larger than a page lies within
> +	 * one page, so stepping by min(granule, PAGE_SIZE) from an aligned
> +	 * start reaches every page the record covers.
> +	 */
> +	step = clamp_t(u64, p->interleave_granularity, CXL_POISON_LEN_MULT,
> +		       PAGE_SIZE);
> +
> +	for (cur = ALIGN_DOWN(dpa, step); cur < end; cur += step) {
> +		u64 hpa = cxl_dpa_to_hpa(cxlr, cxlmd, max(cur, dpa));
> +		int rc;
> +
> +		/* Not mapped by this region; nothing here to withhold. */
> +		if (hpa == ULLONG_MAX)
> +			continue;
> +
> +		rc = cxl_poison_store_hpa(cxlr, pfns, hpa);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cxl_region_collect_decoder_poison(struct cxl_region *cxlr,
> +					     struct cxl_endpoint_decoder *cxled,
> +					     struct xarray *pfns)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	struct cxl_poison_snapshot snapshot;
> +	int rc;
> +
> +	rc = cxl_poison_snapshot_init(cxlmd, &snapshot);
> +	if (rc == -EOPNOTSUPP) {
> +		dev_info(&cxlr->dev,
> +			 "%s: no Get Poison List support, nothing withheld\n",
> +			 dev_name(&cxlmd->dev));
> +		return 0;
> +	}
> +	if (rc)
> +		return rc;
> +
> +	rc = cxl_get_poison_by_decoder(cxled, &snapshot,
> +				       CXL_POISON_QUERY_PREONLINE);
> +	if (rc == -EFAULT) {
> +		/*
> +		 * The device keeps no poison list for volatile ranges, which
> +		 * CXL r3.2 8.2.9.8.4.1 permits. Online the region as today.
> +		 */
> +		dev_info(&cxlr->dev,
> +			 "%s: no volatile poison list, nothing withheld\n",
> +			 dev_name(&cxlmd->dev));
> +		rc = 0;
> +		goto out;
> +	}
> +	if (rc)
> +		goto out;
> +
> +	/*
> +	 * Withholding from a partial list would online the region on the
> +	 * belief that every bad frame had been named.
> +	 */
> +	if (snapshot.truncated ||
> +	    (snapshot.device_flags & CXL_POISON_FLAG_OVERFLOW)) {
> +		dev_err(&cxlr->dev, "%s: poison list incomplete\n",
> +			dev_name(&cxlmd->dev));
> +		rc = -EOVERFLOW;
> +		goto out;
> +	}
> +	if (snapshot.device_flags & CXL_POISON_FLAG_SCANNING) {
> +		dev_err(&cxlr->dev, "%s: media scan in progress\n",
> +			dev_name(&cxlmd->dev));
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
> +	for (u32 i = 0; i < snapshot.nr_records; i++) {
> +		rc = cxl_poison_record_to_pfns(cxlr, cxlmd,
> +					       &snapshot.records[i], pfns);
> +		if (rc)
> +			break;
> +	}
> +out:
> +	cxl_poison_snapshot_destroy(&snapshot);
> +	return rc;
> +}
> +
> +static unsigned int cxl_count_poison_ranges(struct xarray *pfns)
> +{
> +	unsigned long index, previous = 0;
> +	unsigned int nr = 0;
> +	void *entry;
> +	bool first = true;
> +
> +	xa_for_each(pfns, index, entry) {
> +		if (first || index != previous + 1)
> +			nr++;
> +		first = false;
> +		previous = index;
> +	}
> +	return nr;
> +}
> +
> +/*
> + * The xarray holds each PFN once and xa_for_each() walks them in ascending
> + * order, so runs of consecutive indices are exactly the sorted,
> + * nonoverlapping ranges preonline_hwpoison_register() requires.
> + */
> +static int cxl_pfns_to_ranges(struct xarray *pfns,
> +			      struct preonline_hwpoison_range **ranges_out,
> +			      unsigned int *nr_ranges_out)
> +{
> +	struct preonline_hwpoison_range *ranges;
> +	unsigned long index, previous = 0, run_start = 0;
> +	unsigned int nr_ranges, nr = 0;
> +	void *entry;
> +	bool first = true;
> +
> +	nr_ranges = cxl_count_poison_ranges(pfns);
> +	if (!nr_ranges) {
> +		*ranges_out = NULL;
> +		*nr_ranges_out = 0;
> +		return 0;
> +	}
> +
> +	ranges = kvmalloc_array(nr_ranges, sizeof(*ranges), GFP_KERNEL);
> +	if (!ranges)
> +		return -ENOMEM;
> +
> +	xa_for_each(pfns, index, entry) {
> +		if (first) {
> +			run_start = index;
> +			previous = index;
> +			first = false;
> +			continue;
> +		}
> +		if (index == previous + 1) {
> +			previous = index;
> +			continue;
> +		}
> +		ranges[nr++] = (struct preonline_hwpoison_range) {
> +			.start_pfn = run_start,
> +			.nr_pages = previous - run_start + 1,
> +		};
> +		run_start = index;
> +		previous = index;
> +	}
> +	ranges[nr++] = (struct preonline_hwpoison_range){
> +		.start_pfn = run_start,
> +		.nr_pages = previous - run_start + 1,
> +	};
> +
> +	WARN_ON_ONCE(nr != nr_ranges);
> +	*ranges_out = ranges;
> +	*nr_ranges_out = nr;
> +	return 0;
> +}
> +
> +static void cxl_unregister_device_poison(void *data)
> +{
> +	preonline_hwpoison_unregister(data);
> +}
> +
> +static int cxl_region_register_device_poison(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	struct preonline_hwpoison_range *ranges = NULL;
> +	struct preonline_hwpoison *handle;
> +	unsigned int nr_ranges = 0;
> +	unsigned long nr_frames = 0;
> +	struct xarray pfns;
> +	int rc = 0;
> +
> +	lockdep_assert_held(&cxl_rwsem.region);
> +	lockdep_assert_held(&cxl_rwsem.dpa);
> +
> +	/* The region may have been decommitted while the lock was dropped. */
> +	if (p->state < CXL_CONFIG_COMMIT)
> +		return -ENXIO;
> +
> +	if (test_bit(CXL_REGION_F_NORMALIZED_ADDRESSING, &cxlr->flags)) {
> +		dev_info(&cxlr->dev,
> +			 "normalized addressing, poison not translated\n");
> +		return 0;
> +	}
> +
> +	xa_init(&pfns);
> +
> +	for (int i = 0; i < p->nr_targets; i++) {
> +		struct cxl_endpoint_decoder *cxled = p->targets[i];
> +
> +		if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
> +			continue;
> +		rc = cxl_region_collect_decoder_poison(cxlr, cxled, &pfns);
> +		if (rc)
> +			goto out;
> +	}
> +
> +	if (xa_empty(&pfns))
> +		goto out;
> +
> +	rc = cxl_pfns_to_ranges(&pfns, &ranges, &nr_ranges);
> +	if (rc)
> +		goto out;
> +
> +	rc = preonline_hwpoison_register(ranges, nr_ranges, &handle);
> +	if (rc == -EOPNOTSUPP) {
> +		/* No poison tracking in this kernel; nothing to withhold. */
> +		rc = 0;
> +		goto out;
> +	}
> +	if (rc)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < nr_ranges; i++)
> +		nr_frames += ranges[i].nr_pages;
> +	dev_warn(&cxlr->dev,
> +		 "withholding %lu frame(s) reported poisoned by the device\n",
> +		 nr_frames);
> +
> +	rc = devm_add_action_or_reset(&cxlr->dev, cxl_unregister_device_poison,
> +				      handle);

Hi Shaikh,

I think you are trying to propose the architecture as the following ?
- CXL region driver collects the device's poison info and owns the registration
- MM use the registration to keep poisoned pages out of the page allocator
  when memory is onlined
- DAX/kmem adds and removes the corresponding system RAM

The registration belongs to the driver, but the memory that needs it can
outlive the driver binding.

Unbinding the driver doesn't necessarily remove the memory. If some mem blocks
are still online, removal of the range can fail.
When driver cleanup removes the registration, MM loses poison info of those
memory blocks as well.

I don't have a good idea how we should re-design the ownership here, maybe
we can discuss about it.

Best regards,
Richard Cheng.




> +out:
> +	kvfree(ranges);
> +	xa_destroy(&pfns);
> +	return rc;
> +}
> +
> +static int cxl_region_scan_device_poison(struct cxl_region *cxlr)
> +{
> +	int rc;
> +
> +	/* Nothing would consume the result. */
> +	if (!IS_ENABLED(CONFIG_MEMORY_FAILURE))
> +		return 0;
> +
> +	ACQUIRE(rwsem_read_intr, region_rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_read_intr, &region_rwsem);
> +	if (rc)
> +		return rc;
> +	ACQUIRE(rwsem_read_intr, dpa_rwsem)(&cxl_rwsem.dpa);
> +	rc = ACQUIRE_ERR(rwsem_read_intr, &dpa_rwsem);
> +	if (rc)
> +		return rc;
> +
> +	return cxl_region_register_device_poison(cxlr);
> +}
> +
>  struct cxl_dpa_to_region_context {
>  	struct cxl_region *cxlr;
>  	u64 dpa;
> @@ -4262,6 +4580,10 @@ static int cxl_region_probe(struct device *dev)
>  					p->res->start, p->res->end, cxlr,
>  					is_system_ram) > 0)
>  			return 0;
> +		rc = cxl_region_scan_device_poison(cxlr);
> +		if (rc)
> +			return rc;
> +
>  		return devm_cxl_add_dax_region(cxlr);
>  	default:
>  		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
> -- 
> 2.43.0
> 

