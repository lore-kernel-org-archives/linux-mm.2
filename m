Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ED8C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B206B0098; Fri, 28 Aug 2026 00:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DF56B0099; Fri, 28 Aug 2026 00:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2186B009B; Fri, 28 Aug 2026 00:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEEEB6B0098
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:16:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 499A3A3CD5
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:16:51 +0000 (UTC)
X-FDA: 85149367422.28.B688B10
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010004.outbound.protection.outlook.com [52.101.193.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53FFD1C0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:16:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMG1hjip;
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K051lvoOXuKBKIvlTSjJybYPZ4jUeTpY9bWOPLd57LU=;
	b=kuUzeECq1s48UXyM8960VkKmS6rrt+eElgAfEyeT5pXh8TsflcvDGZ4uJutc7s6fl5UowP
	se4FBeiXm/HJA2W3mDV9oUCkFDV6rOxWoo/m0Z7eE1w532Adj4noqhvoD/j0jGNIjOgffs
	uuiICPD8I0MyefR9He1B99gvYPcxXxA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787890608;
	b=iaPIIIT2W/EUhdF7oocPhlx3wpK7g6asz077ibF0CA3LykiZ5sCWKLOvsRmGmfiWTsa7eT
	j0dmLdDAs77YLQagpAGtovwA+neArFmp0/XO56Xoxf8HYjPtHer52gK5z1K5IoQmomIslR
	OeDO9/OOP4vNe8fuqbIuvaEGVzaqX3o=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MMG1hjip;
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.4 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyMrB0Dhhyho/PJyanqfpNE0V+DVMpYAl9ifW09R50gxUcSGMRrkT0WfhNLHUSmbUu/hbJOoD0AKLVL+Zr/xR4epsM8b8pfb2srmCh5cH/0aVHyoAzInrly9jRw7K5DuAOp6YYdzJHXwKq8AdnK2iVmDPUSQfsXM458rC+37fAvMOUs+TetpPMhTo3jXgV/xfpNsL3nE1wPx+ISMme0VcE0PpS60rWNuVqHYnQ+UskXHt2Dc9vcMfiV+ghSQCnxryK/zkOA6dZJVWu7w1QX04d/xlesOh9AHpsTswncyUUxhROagb60wctI7hgSBK5fedDz+JpFW92Hm9Y14yRCRbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K051lvoOXuKBKIvlTSjJybYPZ4jUeTpY9bWOPLd57LU=;
 b=ilWb5PBn02oABhIX7UnA5viRin8zx4gTwU7bFs6S0tF+Rb+6Uk33t3U+8gz/r1eeEgzQj9rf3hdmYg2GtHtr/K8qCB9y45taHn6luHlfZAuuR5SAACbDmL8q6JZQM9eIZfVzDRj8m1Z92Xon7R6M+AoS6x0gaJvP6MSiBIdrPKk8hwWEDFKFAWyCvmODktr0XT4ibERxl/nwfb5tnFQFdP+gl82932YALnez9+GH4ORKIlP9zQT91wvjA+8QEVN3eGw2UR1kWvGiPAQgQ20el80tGP7jGWQKRuF5bJUT9L0VXk8FyU2FXunOuQnYq9xoNgAR+wHU4jaQd8E7XI6DnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K051lvoOXuKBKIvlTSjJybYPZ4jUeTpY9bWOPLd57LU=;
 b=MMG1hjipuyQBtLVjqw8FTR2GyarcXnUho7BALkErMySNsLtUpH7C1lriY3N3Badk8+3lpeMvY+KeVWCMnSOwpEo2HiLubcX8ABvRaGzrTwMluH0YzgWlc2vT1sy/ta2ouzpfcKjzAV0lwCe9omKXf4xrjhzSWXkGwhOqXSKeC2Lu1Zxn0Lr8p+92KqGewxkly7GTe3CCbqy+0EXjiXFGbKHZBnDB8E9IjGmUqdZtHdLXKDFFozBzVB6/sWAk13NUrEbW49e5LUoY3jn4/y/mko62b72PHW7vGiUWONTRZa3Kwm6c+KZr4zPGkFGmqyO9i0ARMFCdE05RaijVVs22EQ==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by CY5PR12MB6057.namprd12.prod.outlook.com (2603:10b6:930:2e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Fri, 28 Aug
 2026 04:16:44 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 04:16:43 +0000
Message-ID: <53fbd974-71ab-40f8-88b1-f34254494fe6@nvidia.com>
Date: Fri, 28 Aug 2026 14:16:34 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: add class-based migration trace
 events
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20260828040817.1504092-1-balbirs@nvidia.com>
 <apEK/oZhWHsJ+kas@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <apEK/oZhWHsJ+kas@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWP282CA0195.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1d6::6) To CY1PR12MB9651.namprd12.prod.outlook.com
 (2603:10b6:930:104::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|CY5PR12MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: b2838088-6a62-4b6c-d584-08df04bb2a5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|23010399003|1800799024|366016|6133799003|10067099003|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4Sm/Ha4LNzYE/iqf7t4dsV+p5+QhRayTVuvM0DmO4eKrcw/tg30uLlLlsxKUzdPYnvZ2YXrn+ICfPq6AuaI3Cmq5NyMaNIOV9U1p9yNiPxLdmtugeZ4XSHeuaWYw8o/rwflEL1gGjhVp1h3bczSj/JyMIc02IRUlCHDzPAygJnloY20F82PTYPDiYoJPvxV8qNi4zGDmcXgB9onMED1i+6DimSXKc22H03t9EM3p1ApyflA2XcNVh9krBfiT22TWx7MudviHpbP0hBldgtzqftZQ2UEMhMw46emumkYK67fWomKVwtKVDI31ur5dYH7mRnbpMRHxxeEnULu2niiSmM/jpiClv9OAn2bUBrPimpbNCheQi9A4pMoA5/ifDzQdxrMi3AtcV1Qr9RV+HeimOBpa8/0QBxYiuyNH1WIa/0lJQLfLa1gu+whLQw6Yx1la/cWts8ztfZl76VFQzv/aS8tmIHP9vGwCrEw1FlwMqYYD5/Gavjpj8CK3aXYnKoNvQ0ASMareHSghfo0XVcSLmXuMjmO8n5JFac5oMGXwygUFAeAp7JJqbAF0pYMq566wwwGcVMndFVZ21rTZMzT8n1BuMnSDNGjy+2kBZD4CUHDa/3WVxtJesa/FZD4fZ7UlZm7A+/a2cv7gA72YVz/M5wde/5adldW4fMm3J0JDuH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1EyM2h3dDIwVklLaG9SVGZEdjh4ZVprSHRBaWtYRVppOTN2TVZzcjZBYUFr?=
 =?utf-8?B?SzNrSUtldUVUU2NVSU5neDA1RVMyU2dMUnk4Mk50Y0ZDTXJBQWhlL0JIcTR1?=
 =?utf-8?B?NEo3L1JtN0gzTTFDSXdkbitPR0ExcEd5eUhEcXo1bU5RUCtYMGpJYlhyKy94?=
 =?utf-8?B?Unhha3NOT0ZmeEtoL3NtK2VIVnV4SWpCY2hMUUpmdVhiaUNrbXVLR2FXWDY4?=
 =?utf-8?B?QjQvckR3WUE0MGNWSEUwZzN0NGhxYmNObE1UdXY0VzdTeU93bW80ekNNcUhS?=
 =?utf-8?B?cjNidjJybktNMlZ2dHp1NkRtaDZRclVJaUJqNGcrNHZjdHAwY2o4SzdHOFNH?=
 =?utf-8?B?OHdScndIS3UyUG1qb0s4YzVDRGp0a2tRNkRqbnZwK29LQnpIRXB4Z2xGM3lJ?=
 =?utf-8?B?eEFHb0tGRlhpZVpQdFd0b0xnb25Ib3RhVHJ1U0tBekMzaWdtY3lrdjRKdVJB?=
 =?utf-8?B?V050cDFwb0pQQlZJNXFwdVFwQklEeUEvU2hYZ1ZQVW05Z0ZYcjhJREdUbHVs?=
 =?utf-8?B?ZElUdU9WaHJTODdnQk5GSEErWnZDL0s2QzR4RVJSY1NWWlZXUjhtRkJiM0JZ?=
 =?utf-8?B?K0xPV0p6NmhVYWJsaUpUbFNYMlFib2tNeE93TmhyMm1zdnFhUHRQTFd3MXpU?=
 =?utf-8?B?YVdxQ05uSk02OWF4SjR3Znh6aGZVMVM1cDNpN2FBUitVSVo5d205WEFCcmM3?=
 =?utf-8?B?QnN0RzlrL044Q1hkOHZYZ01ya1NCa09kbzRmT1pjQU1kaW5ZMi9FdnpCaDh1?=
 =?utf-8?B?ZUhQQS9iOUVYVnFaWWtNSWxCNUZzV0FFUGR1eVk4V2ZPNzNiRzQ2dmNFdkFh?=
 =?utf-8?B?YlRsbks2ZzBKTmVUVUcwUkJhdWEzV0hmMjI5TG9oSkQ2UFBUOVpOd3hxUUEr?=
 =?utf-8?B?VzdRUXdQNWpzWEtNRDJNUjRZZzMrVkJNMUlWRnNVSXJaUjlxbEJSVkZFMm9n?=
 =?utf-8?B?SEZ6QUU0cXVMU2pmUHZvZDlCSUwxVEdPOEZOTHJ3cGtQUERJQVBjeU9oTGVh?=
 =?utf-8?B?RDBra2JiZ2Q4dWdIQjIzbnZmRG1wRnNUUVhzUFlyOEFVYzR6cVFtRE92clNM?=
 =?utf-8?B?Y2p5WC9OV0FhSHZtUVk2dkhVN1FkYkVDVUlDM2RqMVowcytzenZ4bm1JZVFD?=
 =?utf-8?B?c2hFVzhZbU1iYU1YOXkvQk54cTBsaElmaUgxZFNKcFoyNTdNSUdQL2t5N3Az?=
 =?utf-8?B?Tzl4b0I3UjdodC8ya2hieTlsZTdUdTlDMC9VU0hPSDBteHVnVGxwdW12N3Vm?=
 =?utf-8?B?c1RTZnBORlZiaFQzbDRhVEQ1cjROanluVGx3S1VPNXRPNmF0eERIWFhjNFli?=
 =?utf-8?B?ZGl6RFI0OXlpUU9KelB1eWZQOG96anNramhleU9senFTNzg5bmNVd0lTQ1cw?=
 =?utf-8?B?WWxyOTJFaHNaeERhZW9oVFBpQ3BzLzc2MTJ5d0lBVWo2bm5xUUtlRERyMndK?=
 =?utf-8?B?c205OVZ3NzR3eTkvTXRMWkJxMHluUHpvdUNybXhkUjZPMkM2TUdvTFVabFZP?=
 =?utf-8?B?Y0xwZ0tLZjhiYmlMVUdPRnMwVVRnYWN3enlxQ21LL1M0K2lpUFJFeXI1K3k3?=
 =?utf-8?B?ZEZwdU4rT3QyMjA0THUrcVcyYmxiY1BxVnNwY1FxbmRFSFFKVEp6YWdqcjQ5?=
 =?utf-8?B?bnJ0UUNuWW5SamJkaTZuNzBWYlMrKzd1ZXJPcTZKckVHY1UxMzBLREdqTzYv?=
 =?utf-8?B?dGhNaWk1NjkvWUVXMFZUVzNxR255aTkwbWtrdDEyZGRNOEQyZDByZnVqNjdN?=
 =?utf-8?B?NC9xdjFVM3RJQTZmWUtkTDdhVzg2OElJZG84LzRNNGQ5cGRvZktySFVBelJW?=
 =?utf-8?B?cUhWSHY2Y0hFa0dLSFhyOWIrQktDZ0xRd1VqV0tLamQwalZQOFdxRVFaMlBK?=
 =?utf-8?B?UEdCTzBTa2owdERycjJZT1doUUd3VDdHbEpUV3dLQzlTRHVpd2pSbzlBYzEz?=
 =?utf-8?B?V0lYNXozWGJjMURPajA1ZU5VbWd0UGJIdkZZTy9ZUkRNbTZ6aGVaWFp4VmdU?=
 =?utf-8?B?K256STlNc0llSU1WT3N1STI3Vm9MdVU2QURYZlQ2RlBVdFNSZ3R3SjcrcnBZ?=
 =?utf-8?B?OVJFbHRFTlh5ekYvWUROQ29ZT3F4U3lMZWJaNzI3cG9IN2lQbzdOM1VtR3lL?=
 =?utf-8?B?Q1lMVVdBa0ZyTWhuck84NjRwSlZ3MTJhL3FwenB0bDFnWUdONzZDMXBDcnBl?=
 =?utf-8?B?U1ZOblBTMDlvRlhBR0hxVHdTU1QvbHFLV1JEamNKN1A3YjBIajgwOG1QRzJ6?=
 =?utf-8?B?TDJ3aHVGazZWTTI1dVlQWm9TK21uRzhhL0N3WGpoc0l5NW1KWGxnTnFJRGR4?=
 =?utf-8?B?ZXI0QjNhZTRRY1F2NTBUZmZSK3pQU2cyZ01LZG1SbUdkWjBWYU5mUkNJamxJ?=
 =?utf-8?Q?hNBUh2+KvcouV5ly2N48rXwXcaJGsNeHy1VHiJ4JHx+en?=
X-MS-Exchange-AntiSpam-MessageData-1: Jm88rHXcTYZXxw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2838088-6a62-4b6c-d584-08df04bb2a5a
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9651.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 04:16:43.7575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FVzB/Y69v0RDSfXUxTv9FbDlGLVgoCDyca9UZGA79hguQfLiD5cnNejJtOA7j8yPSP0HuAHsRX5bNLc2lI+4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6057
X-Stat-Signature: fncyea5mdckazt46n14hn8dbiscfpkuq
X-Rspamd-Queue-Id: 53FFD1C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787890608-382388
X-HE-Meta: U2FsdGVkX19DyyYeL4CugYmRBUAmHVs5YHJYzTx8I22UmzlheP/hdvY4xKIq0KGc79zJy310Ig+t4KQ5+JwH9dpt4zqcEZW4NOMu/F3nHGvFcQWOX18lXo5Zm0Ryu0ImackgyhKj6MsZo783LwUz4vY5IIKhmE9s1MT93hAKTfqdOLPihf53sXlMHmTbClAaub/+Gc0jxxODbFUcj1THX12eWpQzFcREW/sZaN9DkOpMl+MM+ejjLa8TvgxvvzCIl4J8kTUXKlx3UMuZflPnh+fg6kx3KqyW0ZjUUP5gTsQ0NiH1i5JZa6hZ7cTlQrdfESWwv/GfeuZ4D0iIsqEDGUZUZwokWpHmeMSBLqLMJRhczcp4aKyg+ozdXWlZKXwOOfHnQJCLUzt6YXksSHHCaELpIgpBTsWocivB55JZ2BAoGqjIcMpnl0Z1q1JLEMxNWgLCjz8Udcs/yZBRRsfNrSkq1m4n8gqKofGQYwaqjGvXmd+ud3dRO34Pl2Sx/kFJ82AsjHRbKFv25N5pdnFEOU6vDTDKezrXk9Cf8cgxjRqPQ4CjeWnIbLL56337wFVi0FxgFuLI1W6YB0UIDYs4nu4+yGfj+bkYTHX+QUN652QcQmKvXFHw9jRVOE8Z5beTO+4Dss+bWsHo33re5X9S+lxSt7FaebWBALdF8EzPDpvk3B4H4fCaGPShaTA7CqUUp0yZ5ZpeoIvlgrf2jXaEabK6PpEF+lJtgesCRYWNdWeLrqRTbVMwFd5pxGcHBP7T/WKv9AyD0g/eCqsH/3V6xEofoSMmGWS8xNZ0EECMFpiQDGAeRwSwnwNxVEgfFQMwpbcFojZUgpSHi/qt/YLJP5ClcrgNNX+Nkimg5Db1UVeaH5tA5MIcOnJUv38/m8txDuhqVOD1S/93YudBBxKOlMVV1C7mlJsxRLGajJ82D5/hjkDCthu4IPiC8wp2QVB3ywDjcKIYQkvnd53Mgja
 AWFvwfKW
 7RfOGS1czpUkj94KjaYoPpjf7741xn8cOr1lzf+laRrNB4avWqT/ZDvOdPItPYZZMOwsJYLITFVlHNuZlQu7LvgjZrwdLK3SeUGRXhQ9uN+y/dppQ0fYrT4Y1khKZTX/3F/31Ny1t1XRhW4kziTZTF8rdLoEUxa1GgMVmjYFH0OfEy6/Bt+b/m5lm3ahF7gVm0tARBlYgqQuuGDJ3+yBxx9uRMcdYoTj6O58eEh0YXP6VbLuz/WqERsjM2nxsF6Btm2iRwtXltV56Uv4voDx+NY9quTI2tXBpiCgAL3l5AEWwKT+aCjfeTuRl0ljO0vBRx7b3l65SQxHVQNfRrLmzlNJ+N711xG52GiBjUC05Gfnm2FjalSdAr6+ZwTuEgOJb90b4Gmt2fjAbelOCrdtcl3Q+Vf+xigpabwQMe0K7ti6WIxzmo74cfrlTybc9nXcGmyNV5YQTrSrvJaRGX/pEEb0C5SRHcfbZXVU1/JpiErbbSSSPoaFH7pUqGG7WNqrxbyl27HP1M+Qd/oBl/mArLoVcuYcT20SbvBPDSkxVB2Le0+l7n6QgWs9UXll6dN+J3cIMZUeSF49jRtVvPFQxmWt5M/XAcdTUAQnjvr5NIrcpaoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 2:13 PM, Matthew Brost wrote:
> On Fri, Aug 28, 2026 at 02:08:17PM +1000, Balbir Singh wrote:
>> Device-private migrations currently require ad-hoc instrumentation to
>> understand selection, unmap, copy, and finalization behavior.
>>
>> Add reusable ftrace event classes for migrate_vma ranges, device
>> batches, and individual folios. Emit start, done traces with
>> ranges, flags, page counts, success/failure summaries, PFNs,
>> and migrate flags.
>>
>> Enabling all traces can make the migration traces verbose, when used
>> they can also help debug issues with device migration.
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This seems like a pretty good adding tracepoints - anytime I've had to
> debug issues in migrate_device.c it has basically start adding printks to
> figure out what is going on. Hopefully witth the right tracepoints, this
> would now be turn on ftrace.
> 
> So +1 on the idea.
> 
> In the middle of a few other things, but will circle back with an in
> depth look at individual tracepoints added here when a bit more time.

Thanks, I am hoping to add more tests and use these for debugging
corner cases and hopefully get easier debug for issues reported.

Balbir


