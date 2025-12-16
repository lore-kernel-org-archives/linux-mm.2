Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7FFAD609D7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F6F6B0088; Tue, 16 Dec 2025 13:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222ED6B0089; Tue, 16 Dec 2025 13:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD2B6B008A; Tue, 16 Dec 2025 13:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF9DB6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:59:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 900C213678D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:59:02 +0000 (UTC)
X-FDA: 84226246524.25.EA6218C
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by imf30.hostedemail.com (Postfix) with ESMTP id C133B80007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:58:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YAj2zp0P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765911539; a=rsa-sha256;
	cv=pass;
	b=lNL8MMIzJAyOAPrlUvVFyPWwSjnnctY1+X8e4HQ51IPdN3GjNqdJ+fZWXp3Gv7GMsnW2R3
	ORpwRKyyX8/fp4a2KF9YyNlBNkwXPbKaWCO8bGETz10AeAaHOgUpDPxHHx1++dhTkinIBp
	QA19d4OJ1qkQ0HKrW7sfB3hx1wx7w4c=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YAj2zp0P;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765911539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfSd9oCgX8aOTJ/KD8FWS+mVEuX3VvBm/11ki+D7k6Y=;
	b=GcyVktbQzZIBp0Ta7V7MkjIJPXQlz6AAQ31sTduQBQcolesIFkczP97bxdS+zWN5x+yNp5
	m5O8h2pH9DaAZNFxcCiApAER+ZyxQybRV6Fyr3RDV1VlXMo62tYwBz7XofBXEzDJMAgBgV
	Ac0JxNXf3FQ9ysl5zxeG91Icz5stTV0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afCAyiXpXPVo5NuqWBOwlfcQmI9rHuYISBecnWM+wBWn715w1IL+EDeC0KlyQhVyVFc4T1zFnE1hEOfD2z+76eU8PZwGGvzo84HRBl/4fV4kr53HxXU0/oRIsqISvRk5Umq4aGXRVJKr3pu0ZN0CvPCSfBRPMpKOAr7GZp7EZ/RZMP1RInA/RwPKUwZ0HS62i3il5/mWkxdke4Cb3WaRLyPmnO1UQsuMrQdP+oonP8k+9+vF93qt5+mgXUJRDT5O9M595r6meD7TvOppsK+znxCdq91x6f7HEkaoidYKyLCJRtdX9N5X52+aseq1qKiseTdObDNg2f/ZEfIFG2Pd7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfSd9oCgX8aOTJ/KD8FWS+mVEuX3VvBm/11ki+D7k6Y=;
 b=GJwXBBhImAyJHFFI3Zdy7aerhv0lU+Xadc6juxk7zvLyZ7uWBaQOshTKwYs5IPajpS6ZqtRT1gpX4xzOcEN0gZcosuB5S1QFb7GFr1xAgZb0GV9k4dElSexFBjlJUJrpL7798PRU8+eSGq+vMo2lzM0WvC4+dqJcbafsiSR2Eira3i0GZvYga0bt4zhjy9tKg/2w8L1gekWSF7XdmclB3NJGPr6St7jn2iz9dlHqKSz4OiQXZUaWy23YSH/tsuD68sUD1yGsLOtC6tLJUsgigjeLsWsm9l+Xr3O/4K+tU4Oh6ywF5AE51m0PC7srDWv/WfFiYHcr+0RlB9sjl9IVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfSd9oCgX8aOTJ/KD8FWS+mVEuX3VvBm/11ki+D7k6Y=;
 b=YAj2zp0P6TfVSLn7B7r7ERvc+j05UfDWacyNlZx779Rj+y0sKFur8PaU0ox381KrBzZnpO+6fOqsjHCrX9cWIAL3AL6KXcw0VgCXsjlDy0P/dTUcFlrj25J9jgsPXWUSJgvDCiFMkmFBVnRe9fduAzqpAnwoUA59vnq7a6jpKd3DUbHT2QWIv1H90ZZKb0xw1pRV88S1wGPdQocOHfq4rGp1b1UzPnQ460JjCffqjZzCB4dVxRLFo3kDBvAnxKfzdEstS8YBvGzcM2wdY61hHK2TIUy1fLVmc3pg50TnTvCFXfrlrYK9gMtMyjChYJRRyjDCTsrofrCY2NMNWNwQ7A==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 18:58:52 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:58:52 +0000
Date: Tue, 16 Dec 2025 14:58:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <20251216185850.GH6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
 <aUGYjfE7mlSUfL_3@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGYjfE7mlSUfL_3@x1.local>
X-ClientProxiedBy: BY5PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::25) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f19088-ec0a-4dba-7b8a-08de3cd52767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LXFcGs5inIUV17h9onn7IGQLfunsjfPaeyDc4LgE7D/O2QlgmcGaY8MXS41H?=
 =?us-ascii?Q?hpm/wfHWYq1YOyjrQkALIOcgBPQjG53ef0piuUouZCi+wB9FxtmzALrpYtF+?=
 =?us-ascii?Q?JAPIBZuNEB+7oc0vIhDsCPy3NMtFGyHdy1dyfb+kOXWmT846wMwfRD5BNUr3?=
 =?us-ascii?Q?nHZCOnZfPcpzTgeBlI+xRukNKnZdVtOQRrXFzceGQiTG9Wv2ryBk55C5ejHI?=
 =?us-ascii?Q?2VKM9Bz7/VKOG6AxFcVsKubtbuBzySsUHGZ/ukExp3GnnJbcmqLeejjyd0Ah?=
 =?us-ascii?Q?Ryimd3RRn/Lq7cK6iQjqDjgPkJ/EubWdZr56IZDi6RmM9/Kl3wChoyddJoTu?=
 =?us-ascii?Q?R5rLIEFCxSzvirJNwHf2YLS0rhAFOYvnF5Mi67I8y71aeZOdBXhlg7CueF/+?=
 =?us-ascii?Q?XDvlhygKAB2FCuU+/dzDKRQQnPlRP5QFeOu011VmqnLjPvRzeXP8p5df9Fo0?=
 =?us-ascii?Q?8KfeQ1hrcXJSYt5BjjbSXEI4rWtK7ObNMxZXpmpN4NuboIWxfwvfrxFCsSRF?=
 =?us-ascii?Q?y3QwB+geO4vAeDuwOzmJZsDlk2681YK5fe0XObOTF6LhdAUHG2PTgwIzPl1J?=
 =?us-ascii?Q?b0bNJ6v/GaZ44uBoOq75CPl9+sfvtXJ328saW0NI8vhGHWLqy/uk6PeW8yNe?=
 =?us-ascii?Q?3ZCYa9u6t87fZjqiCTosVM0HcpYRt42k6YggnQJfo1akOehOfP9xsRPB/hxq?=
 =?us-ascii?Q?ryGkat5bUoSCSmYibbOc2e0AY8gDlGfqr1CgtrgErng1MOc1avJ6U65GvfWL?=
 =?us-ascii?Q?3CAtkvkDaJiLFavo+/BtFb99RoWXba8DEnogBRugniMYalZbea0afDkCeiGe?=
 =?us-ascii?Q?Crf5+B+2BG8vutO2sdO8PQtcxC5EFk48VFIk1V0L4xSi4ZH6M5fPyNkClrNu?=
 =?us-ascii?Q?LMxAcin6GD/HJGcG6SkRWGvrdeqcR+MPvzlWQszCKJy0v27SGsuD3jfTNBZZ?=
 =?us-ascii?Q?cYkILmaH3Rv7//AkLZLoHKHRI8pD1+VH/TSndOv9pGPQS4ZPHbIOQytmHpPl?=
 =?us-ascii?Q?7E6pOAQ4EwB+TFyru038jX0m08XAY5dyUxWxgjNrojBfSpu70k13T/yunN0E?=
 =?us-ascii?Q?mzDLjJiIR8CxAJh0biR3oBgmC/FNSKEfvqrhLu0BqYr7hqDF9mKFlyjEuXfC?=
 =?us-ascii?Q?lajMVdw3pJ16Um3bKDsx9vML7YlnGJZF37j71JLPsaDGCM3N3Je2q5B7n4D4?=
 =?us-ascii?Q?6VhZw1a1Aa3nvlfiAhPaip4q6Q7n0mYZw7KM1ggjAkB2Qk8tVCCVfeiEqE5A?=
 =?us-ascii?Q?DHz3EVQJMwOny8oB3EkzjYS1Q78KbEJs9kJF7xNcEueuSWA6TL4ojh9cc1Y2?=
 =?us-ascii?Q?nOUH+K2hQJJG/v2TeRcSpuUNUNSzMyjsu2wQ++GTPBHyzQkkvN/NiHkzlsEm?=
 =?us-ascii?Q?NQwiI3o6FW5+0RZDotwv0g2Qdc1PUBrLWix9qgCL2l5awuB1+VqfbAMJ1q5I?=
 =?us-ascii?Q?P4ZtM/6Dj5Q4ov7IS7wyzVtVT4VMbRE6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YEYfhPhbz3+7Edpqa19mNnKAmxxxcA3sXL+3wqsQMaIn3Rvkzb+9d+d5Rwms?=
 =?us-ascii?Q?LDhL99epMq4sUL1zNxdQuixG8fcy3ggGxaiH6kf0FBlPwqjeCjZKFQe5Eqrq?=
 =?us-ascii?Q?qiSjt9iTEpowH82gwxhktMFukjCpqytQ2qNQcY1juB7tABQH6yvf9kmEYDsJ?=
 =?us-ascii?Q?sl+qnJAOy90/8demnWf3epT00pAnYER4oxOZGYX382ssvVoCblCLMpYvWNVg?=
 =?us-ascii?Q?txPfnyYjxyqSHR0nL3uTgpgZ7f7Ovl94+fTHBjgpjGPHFuVSxgn+HK1FOHcD?=
 =?us-ascii?Q?wKHGkblJaKcNTbcaJfiNrTjN7u+Z7sNhJz4LODQ5vER0ftffDlFBlg6GssJL?=
 =?us-ascii?Q?raoEA5xM13rxrla2rUvkUM2hSQxO2i+w7A/Xnw6J6zK/YSn8r5SUkouFBUxa?=
 =?us-ascii?Q?6ZUsS54yf8qn0LsXvbqDfA5jccnItf2EHVXLFiKJbrLEygq7C1vDOCatHJrb?=
 =?us-ascii?Q?qu/PFErzwkODskdpVw1ZtHuvLLLLhlQc5ZoM6yaVkEmX8CSB32UxJdf78WoR?=
 =?us-ascii?Q?p1rHtM9jUS19Gn57pM50kwxYJ4+K4v5k9b90WCfeu2+ncdRA4Rf5KRVfRkon?=
 =?us-ascii?Q?kiWXhElrRttWk0C7dUDWVVLIG0CQvOvpVISLhqc3NaWBoddtYk0Wfqv78aUU?=
 =?us-ascii?Q?7d/NkGOs3E+SZsbxhFK4PlDDBuAodFauSoTwTz02xaVK2G6aUvvoFmtUqfZJ?=
 =?us-ascii?Q?Z49D68OtSMngMMiz7AmSqKkQzQnZf3ETl6Jwv+WgsKhQsA4X4MWnBfYMc+v2?=
 =?us-ascii?Q?luxi4Ie9UnwDtQer6p5VUaUc00XekIqf5TT6cHFrCgK/j8mPvqSyLAOCzUu0?=
 =?us-ascii?Q?XuKQXkx9KoyIyMWrmRsd7mJRlnGBled7bqAZLlujL3gcPfP3hW4qjJyPtp2a?=
 =?us-ascii?Q?nQUDf1BWy+/kp9OwMbHDtzcVRZurOZ8vlSVwL79UVOJEI/9VcZumemTxTW/3?=
 =?us-ascii?Q?HkQ1JTQzS1UAdgmrnyQBVzwIJYtD4SU1p2pbq4qGhvGZi2N8cBKfTW6oLVu4?=
 =?us-ascii?Q?JMusyGsHxDsESj3WsRX8SDMjsxfbUugQptAyGkOJ4JQ9ahSmhg6NOlObKt5M?=
 =?us-ascii?Q?lqdNgX5rAEK/0m0chHy8ASRHDdjfXhqJxGZk18zNgFwnh0u9o2SHK4vQGZ9s?=
 =?us-ascii?Q?pnra2jopMUAxgriAPCtGMGx43jipLekhrmxRap8ERAT/tamAZwvqWIvoLS2M?=
 =?us-ascii?Q?Qatk2l1NNd+t+kafoJwCzbygrTcAkJ96qhes4KZqNmxrJAcd3YC6ytavlbzt?=
 =?us-ascii?Q?PHo1F5J95LRWpeO6lZYJyw+K/FypuZYMnxwcA8VKBMXIqSaIumO24kkEbQ9k?=
 =?us-ascii?Q?mZJfqr13dSOjPyikMfY05Mt3sdJb4F6r6T95qnWdQNhW/Z2FKk31fpEALZGl?=
 =?us-ascii?Q?5jNWehnIX4QjTDupuPIHZZVcWqOKGBC+4fGaxaJ1VJhjI08ogcYqRGUx61UO?=
 =?us-ascii?Q?vj4Y6py36AhW+l3DrBsNCqeZr9UuNnKuFLzk74S8RpJdHLncaBJ/VqSCId4N?=
 =?us-ascii?Q?VlsxMUkfe0V6xcWiyNq71Na5foVYIjoKJD6Avmh3y+AMJiZM2OnzA4DeeoR2?=
 =?us-ascii?Q?ogWXYOyXVKlw892pJnIQ4YjHYjQA7eqVCzhUQbnb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f19088-ec0a-4dba-7b8a-08de3cd52767
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 18:58:52.1379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LLh5OUACPFl/UIQ4PjtqS+ZxeYy7nF3LoYxMzefstfE8rmv4XjIA+tk6bu0T2DR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Rspamd-Queue-Id: C133B80007
X-Stat-Signature: ynd8mmbdxa195mtwn9o9h3yttjoxjca8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765911539-732595
X-HE-Meta: U2FsdGVkX1/ljUcoLWFsVRpUCjywQvk6tfVo/NrXsvNbjDpxwpDgcsb7KDV2jfSlQxj/tFvEoC3TJjIx6LpCwqrrQmTFJxMp8wEo7JuBPvtjJ3PRpNRtxEIIqMuiMpmurJN/msARp4FgWIStFhl/eDlpzG3gY5gBw3WTKAfojRfhPZGo2pTc9jscrz9nSM6E9ksaTI/Medu2/JvwlzQJLQMdHNIF7EU/9b07WdRL/GYE05EpieVBka0jHPiUQPkpDEgThx8RaMXa43JGEkDxX6/JFpWm9LdN5locYyTbCrez3JDywZ3rX8VFxXqH2OHiB6ZCU7WTjBCB4wzi/vh87GKitSatpGpZ+ujhWfgtfF0i24sQfLqL93H4Qd1jNMOe9VbzHNzTt02jX2zO63Tna6ILqWQNCMUUt7zTROX+oQd2q2ILgEFUNt3dewigVXMxDXEY9uBHO/gliwn5A46gcfckr0+dQPgG3FyDKUddijuMqZxXBhk9DTdCVFkBgdvadxxJmK4khBR5mQ4UzXvJJF0KPseFRfIpL8g1bHWiSohAdF61IzAwjXkr2EHnGuo9hh9W+hKWSiAQVBd5jAEKayHA4YPLXDi1tvx/2wIQwOd3N+GnEVwzbb4TABJJCYYWjQT/IVHk/6+NbL7ZN3QtpjDHNoBE8WQmZywx9V/ACw/up24SCMQu8Vhl3kCXn3pzEmk5ta0j67a3CUdvOyNXlBuqddsHtPbmeSPNrkVn18r2WjKQu4DZMO7Aw5ieqAXu2POu9JGUs5i+85SEH9St9kkCibAD6SKvJnjy5o/a9cYSKWz4ZlyIaIshFQivqaybO/MRh70RVmHiWicu+qRvA95+q03lKvbAhlUO4hjw46E1b7j5QWRjG8Aaf5VCCRI4EggRP6XzyqBEqUqoiuN77Ifx0CPonhm9wcgeS0918KvAyod1seVCMIEYal/gagY0iWcW5fVCLmNPnDbJ861
 43goCX0a
 1wLFU0MSKtzowByLw/yho9GZ7Sbl+Ic8Ki28G0BHcFSLeSubB8bpLGi2d5WlAywAflaKCccQNbE7XcQOJ0UJd23j03XzNUENvXxqaeBdJnSlz5Qg2x5iKyxehWggJEsrqx87/FLJjvyzs875Cl4AOYZjkAC9GjpWlXn7I327Ms/70EagmtpQ8YbEiNDAOeLY+QzDpi+Y9grQ8RHKCQYC3GYkF6eO8BpZP8xJe3Mr2UJUfvrJzKCct4yux17X4g19v1O69j99Vnd0p4nauqILDM2TKZYvxyLzfwoan5FmkAb4U7CdxCKobCIqn8HDC+JaKx9SxvKkEdmi8CeJhvj36m/xwV6KmCxSZc7Zb50T/v13v+RRr6Pufrouhx3hrz4nSOGjURYvmM2j3at8DCKYY967oU7TJkaXeWV2PUyXaJxJyssph47/CNkuLTZ1wEg6CPV4hgv/5Jr5IIgNJaT5ecPycFQGb1jSAoe54wdHasu7dzCKMaVGW8llJD6qB+nQhwvKMu1dQ0RgjZv4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 12:36:13PM -0500, Peter Xu wrote:
> On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > > with len_pad (not len), and pad the retval at last.
> > > 
> > > Please let me know if it didn't work like it, then it might be a bug.
> > 
> > It should all be documented then in the kdoc for the new ops, in this
> > kind of language that the resulting VA flows from pgoff
> 
> IMHO that's one of the major benefits of this API, so that there's no need
> to mention impl details like this.

It needs to be clearly explained exactly how pgoff and the returned
order are related because it impacts how the drivers need to manage
their pgoff space.

> Here the point is, the driver should only care about the size of mapping,
> nothing else like how exactly the alignments will be calculated, and how
> that interacts with pgoff.  The kernel mm manages that. It's done exactly
> like what anon thp does already when len is pmd aligned.

The driver owns the pgoff number space, it has to care about how that
relates to the PTEs.

> Or maybe I misunderstood what you're suggesting to document?  If so, please
> let me know; some example would be greatly helpful.

Just document the 'VA % order = pgoff % order' equation in the kdoc
for the new op.

Jason

