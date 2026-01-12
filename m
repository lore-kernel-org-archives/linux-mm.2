Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC73CF45AE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15BA6B0088; Mon, 12 Jan 2026 12:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2966B0089; Mon, 12 Jan 2026 12:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B666B008A; Mon, 12 Jan 2026 12:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B97846B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:02:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 547DE1AE347
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:02:29 +0000 (UTC)
X-FDA: 84323930418.10.FB94285
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012040.outbound.protection.outlook.com [40.107.200.40])
	by imf16.hostedemail.com (Postfix) with ESMTP id 727CA180005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:02:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bEJpftdP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768237346; a=rsa-sha256;
	cv=pass;
	b=oMkmn/HD+O7wGdIjBlZITgPAhdZlUGnC6gru/5y8IrSLw01QRUs/O60zWhun046eWdFhFa
	4qlAS5fuqQtjkGslapS89kJmJjw8Qrbb0S+y51Ny47lnn0r46CMBj7Vqa8SRgEkH+hHKoR
	lVKhsgS9oljKn4DsArct0RTqWUOTkig=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bEJpftdP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768237346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHE6trrlO2eICSlwpm1J6V7BWcwSM+S4i/eHIVZDsVI=;
	b=7GvkwXwOEm3ZthLntyjJFpWaL1Epk17SK4RTplh5NtKvks55pLtzD27O0gofn2x+KoPuI5
	sxoDjHhxVuMoZ71RreYehGNrBs6GbzWIj3gQEucplyOMY5Pwm6Oh7zhYjwxDMR1yfOmRjr
	zNBwUTMfy1y1qJKV4nTyjjTAvO+IPfE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxF78Uy6OGi6ZmcF5t/PKHvLdVMca1kD6V/tQxNPyFkBNkFxu+FPbKSklEpefepX4+gwRC1RmYNxmMZRS9JK/Do5WzDci8pQNwvW/g+KjjgJMvAo/eS3JanHCsnwEG5/JDQ8AAL4MRu1uNw62Fikpltz44WDUp2wnC0NUPBYdkiG7s7lDWMQ/yh+0Yq+7WZL0KN200E7uKiNHrUwSl/bXHiEK9Xb90HJCRonzqV0lqCW6G1KKRc7nlbKoMk5M5bXjSq6PKjwAedhPFbAA05s84TbTG5KgQiSw+ku0NQHZEAUpSo6ryolT9LBbpzhppBXpUhZyk5SV8jLU/DEe5Q9xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHE6trrlO2eICSlwpm1J6V7BWcwSM+S4i/eHIVZDsVI=;
 b=Nm1dWASySOJL3YnSKLBVcWGnp4duwLVqpZ5rzILJsGnDETKQ0jRmXkoyLVJAKq2AhSpyY9dy9du5KOC2QTG11bUebsuu7lYKuHgkxLgNy5C11jCmlCknnFSPxpDbW2YSsSMxz5k8IMOhqwYoyTjEjSkyTboSRHYv1Q0GhBu7jmXJaAIt9xdz8dli0p7y++lKT5c4ZnzlfbcTR+yndTG7MeWTzxjSJnC8M1qwi2ck9L4NVLCCujABogZngNPlnE9EB2OzBFPbVRwdol6pIZ5Wbe1besxNqoRyRELU58Nj6jFbEsf1bwcA1nptcwu3zScyfkuKi8wTHRYzT4btwgLGfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHE6trrlO2eICSlwpm1J6V7BWcwSM+S4i/eHIVZDsVI=;
 b=bEJpftdPwB2GCXq6IUWFUGz4A+Nz7OCG1KLJupfU9AfCrPhU6mh2eSurPMWPKyTX5OVt8UEaU3ZSPviZSU+mnDlQ3tbo+Tc151EqPdcu7QlT3p45O94CHnpD0NcZmzLLCpYQ9lJ4kZBAksxv5XWGrgMpYY1aVkpRB3qq2kY+HO7HlfIcBSlkMUasHeSYdfbS7gzCgP1rWuqQhALqZjmBCVGA7GPEFHDRNprLDbFxtitv6l72fimAAqt8x/qZyOm1DAXkZvQNejDpNlEZqe9yYOpkfQKKXGBjuGsvVGTecrOADHTO7dErT5mFh75IGTxPADNt5Uan2Lz7BdqJgcfoDA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:138::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Mon, 12 Jan 2026 17:02:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 17:02:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Mon, 12 Jan 2026 12:02:16 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <926A149E-FE2F-4F88-92D6-FA607398605F@nvidia.com>
In-Reply-To: <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d33ed26-fc82-4831-612a-08de51fc59a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVlsWlN5UFdkeGRFKzlFTDRhUHg3ak8rNTcxc0JBOXJBMnZRZUtqanRtMXhZ?=
 =?utf-8?B?d0Q1WjJ3aUdyRWdIYjJyM0lJaXB4aWRiU1VNRjczanV1TUE2d3pOU1MyMGZ3?=
 =?utf-8?B?TnlVcWFaTUYydjdtTzhxcnhaeVQ3MzExSjc4cUZDQzhIbU8xTE9OTXcxWVlM?=
 =?utf-8?B?ZndCdHFZdXk4dTF6VVh1RHVVV1pkSmhHUWtVZ2Z1U281anRZNTdYQThwc1Zm?=
 =?utf-8?B?Rm1FWDZGWDhzVVdwbGhZaVVpM1ZJOXVJanVoV2VINHFpNHNrRjJoNFRkaDlH?=
 =?utf-8?B?VS9LZnB6OTFSMjRDbHQ1Z1FsbWVTc0hCSmhRY2ZWQUI1MUlFc0craHYzMldY?=
 =?utf-8?B?MFdSa0R2RUJZT24yamtib3JhVWo1SWxBV3V0SzltNi9VMVlpMUhDMEszWER4?=
 =?utf-8?B?ZW14SmUydmpVY2xZd2JjclIzUjRnbms4d0xPcWhTaHhyZWdYSU1QVkpSV1J3?=
 =?utf-8?B?K2MyMGZyS21tVUtqNHZDZGhyUWdER1R0THhOaVlnaDdjNEtKNG1nLzJGYlFO?=
 =?utf-8?B?Wm9ROUxpeHpEdGpKQ29CY0ZYUnhRcDJ5djI4bzZSUFUwd0hIWEppNkcxNWpX?=
 =?utf-8?B?S0ltUW1aUGY2amdzRkJYNTEwbC80cU1CalUxMVUzTFhIblUvN1JvbEZpRkU3?=
 =?utf-8?B?S2FITkZPckc3all1UU1QOXJ0cDRTT2FTWG9BMk02cHMxLzM4VmptSXRCdSs3?=
 =?utf-8?B?Z1NCOXZRL05CbG1Kb0tDODI0VExaMm9pam9XUHB4Z2ZGenM1bldyKzhGNHlU?=
 =?utf-8?B?MCsxa0JWZXBHZE9NQmV5OGllWm4xaGpiZUIrM001MHdHTjcxeVgzK3F5ZEhI?=
 =?utf-8?B?Wk9XcWZiZHE1MlRZVjYzekF5TEdPUnA3eS9pV1J4dzNVcVVPRTYzNUloRFJR?=
 =?utf-8?B?ZWZCU3hrbW9FOXVxRElBYmo5WjdUeHVBMFJBRmljdTlITFJnaVBCdGhjNS91?=
 =?utf-8?B?bjNsb2crVUU0RUdxWWl0M0pBcTBwYmRJcXhYRnhKdGlmck5GZTQ2OXozUW9h?=
 =?utf-8?B?S0M0LzFEMWVFcTZ0MjFRK09oVjdYM013cVR2K2RnbXFVaHJhd0RVcDJrZkIw?=
 =?utf-8?B?c2h0UTQ5eG9pejFWT0xvVGdlSzNYTTFzRS9WbmZMdDBQS2hiOVBOUElvWmls?=
 =?utf-8?B?MFZqQW1hQk5GSDc1ek9NaW1WR2pQdjhsaTZqMGU3UEpuUHZySGJiZGZ3REVS?=
 =?utf-8?B?c3o3QmVUdjZlNVRLdVdLTkU1Q3BsRGtTNGdwZUxqazhPSDhyUlQvbGZCU3A5?=
 =?utf-8?B?eitOOFlGY0NvU0pLVFNyRkNzUFhqd29TN0NGbnhoYldoWEJ2c1JlYjIzZzNX?=
 =?utf-8?B?dkFFSkFJWXdDbzczUDJwU3BIOE4reEZsRExicEE3UmJGOC9NbzBRK3ZGZURK?=
 =?utf-8?B?NldGT1JHZnVXNHl5L2lFWWtXRktud3dqYXVVR1RWeXZLT2gydFJyR0xDTU1C?=
 =?utf-8?B?RzRQMHZRZ0lMeE0vbkpRZHJlUjF3RDRkUStmSk50VkpRbmcza21lNEhOWVpS?=
 =?utf-8?B?ZEVkZmZJRFVQbmwwVlllbWJoZEphSmk1cHhSTkdOQ0grWGU3OFhuV3dMdFMy?=
 =?utf-8?B?TGY0eGZ0Q1BRZ3FXTFAzbHk3M2FvQW5HYmVKRjI1eEVGN09YbTdXOHAyK0Vw?=
 =?utf-8?B?SHBkRVVuRlIvNzhkdEozdWxCcjA1SDJ1WXlqcWJiUWRNZVBTRmpuczJkUU5N?=
 =?utf-8?B?Q1hBU0wrOVhzSERGN2NwUlVSaWtsQU5XQ0c4L1JyVFdlcWIrSW5hUURBaTZT?=
 =?utf-8?B?dDBYbXZrNHRZZ0VEdm90NTg4eDh1L29iVVo0ZzBuaHpZT0RuSGNFL01EUVVR?=
 =?utf-8?B?WEl6YVQ3Uk1KeHlMd0QzYnYvZk1SNi82aUc5Q3lwaC8xdy9vVG52V2huUFVM?=
 =?utf-8?B?MHhaY2RtdHhuT3JmdHl5UjV4UzJwWU8ybTRLUS9JVXg1REZtTllIMFJGLzNa?=
 =?utf-8?Q?A0nXQc159Mvrk2i4CqQlrYANn6z2SyyC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UFVwMU85QTJyZ1RZbnlWTE5PcWk2RVZuQ3QxbE5xOERCbFhQMGphSmp5NkJw?=
 =?utf-8?B?akFmT0ozOUxtcm4zUFVYbDY5eFg3bitFRjYxZ2tRZlBvVmZzQSttMG4rNXhp?=
 =?utf-8?B?OFRZRFJVTitRSmhxZEtKM1Z4L1lCQXJFeG4zcmlkczdIZ0hyVTVyNng3Wmk5?=
 =?utf-8?B?cnB4Vjgyb3F1NFVXZGFPVkJvbzZ5Sk9BWDZzZGU3SlNUQ0U0V29JdE02LzNz?=
 =?utf-8?B?ZVdTV1JGVkZ1WUxBUnM2NkFlRUViVVRENlhJeE44akVHYmdHa1FBSHRzSU9V?=
 =?utf-8?B?ckp5ek5td0ZjZzZUSkNvZWg3SlZLYStjSlpDWmVFRW4waXRLUjZ3THBRaWgx?=
 =?utf-8?B?VmxvcjErV3doV2RyZFdKTXgzcEZkcUVqTWlvR291T3l5NitTWUNPcFVFaWJu?=
 =?utf-8?B?ZGtHajhpSHVocW9WZDNXTk4zcFpYeXRNOXNZbnFRL0UycGRRTUdsWitRUnFr?=
 =?utf-8?B?cytHUmE0RituOWxubDRrclFraEVQOVhRZmJORkJqZlJMUGxmRjNFbDUvVTV4?=
 =?utf-8?B?UnV2dnlTalBKLzUrTHU1eFZScVI3SXpncmNIT1I2NW1EL2Y4VlB2NEY5Y0tu?=
 =?utf-8?B?dTRjK3hKREgxeUxTTVFPMVlENHhDcUF6bEJaeWhYQ1JWaklaVzFDaUpacTRL?=
 =?utf-8?B?aXF2U2NGbWt0NFJ3d0lsVnNnamtSS2xiUnIwMFcxYS9RVGVMOWpSSlNFVzZx?=
 =?utf-8?B?SzFFVDN0cytvZkE4ZkJ1bUhHYWszUnVnUDlPdzlBQlZ1MkZjZWdZZ1RqRElU?=
 =?utf-8?B?ZGNvcnV5SWhXVkFYNnM5NFNBZFo0VEVCVDNnS0FiU3ZPVGVjcW91VFZPZHVM?=
 =?utf-8?B?ZXhQR0NXR1BDeUp0OTJDaUs2NDViZWN2ZnB2cWdpSTBjNEJyTGQ2ejVvRmVP?=
 =?utf-8?B?N0JxV3FsTis1V3h2eVBIQkI3ZmtYclgrd1ZBamI3S1dSdEdxRnRjNWtBRlkw?=
 =?utf-8?B?ZWFsZUFycWF4T2t6d3Zqc2h6UER1cmgxbTJrN0haMExzZmhCUitaYmRsWFJh?=
 =?utf-8?B?SytWTlJ2REdmRjNIbWlic3ZJN2wvT2RhakRmdDhVN0VpbEZWOHVoVjNtZk1F?=
 =?utf-8?B?VVJMbU9aMG9GcXQ0ckExaHNXMzV5VW9nS29HZjBMNWRhTHlXejFLOHU1MGJT?=
 =?utf-8?B?bmlSMTJGRS9DRTduQ0JESnltUG5HYjVwUjFhUWg0b1h0MjhSSU93RFBPVVVW?=
 =?utf-8?B?dVREbmtyNU1oaVdCeDVwVXhkSmdlNzVxMi9uSDdJQVlzaTZjMXo5KzlrdS9Q?=
 =?utf-8?B?azkrbHduSWhQQ2lLUFNySjV4RVBib2lqSmw4dDNqOVl3SGhLRHErUnhXVGRK?=
 =?utf-8?B?RTljQ1F1bWtjZklvU1NQT3NmSTJ1OUQ1UjNUYTltaVl1bmM2WGNBejNMakpr?=
 =?utf-8?B?NEczL0g1MU1FYkRWS08ydzloa3B2UzJwY3pZWXBBVWdWVStmOFhZN3pkeldJ?=
 =?utf-8?B?SGlUSmIzTjBtYTNLMEhYdlRpVDAxSGg2SlNYZEU4cEJNajhsQmZWNjRJTWFn?=
 =?utf-8?B?cmhUeHNxYllHOWwzeVdhNEUxV2MxVEJNdlp2Rk83RVdBYytiejB2dmFSeVow?=
 =?utf-8?B?ZEhwLzdiU3R1UysrUytzaGNBNUY4L3RJLzVFeUx3Qkc2R1RkWncyVXg3RURL?=
 =?utf-8?B?clhtdXRYK01oNHJpeXRqeUZLcTU4aGltNEY5VHFoWFQvMm1BQVllSEdKUGg5?=
 =?utf-8?B?bU5COEk5TVhPNGNSNU1jZkZEM05CRFlvYlZQVFBEYkpGcENUVnF1c3lQZ3ho?=
 =?utf-8?B?eTBqTU5NUThRSUM3MU5zTE1PRWNDZm9hbVNkWWFlMDVKY095dWt0NkFMREFm?=
 =?utf-8?B?d0srMUZFR2UvVDFURVh6aGk4VWVzMHVWdnBWTnJreWRacko2bCtsWjh5Ymxh?=
 =?utf-8?B?RlpVOUZ2dmsvTUgxSnI3YVMzSnZBdnFYZWdNZWZRMnVIYmpBSUp3K081WW1T?=
 =?utf-8?B?SVJnZnJzRktQSmpVN1FvdExRS1BOREpLK2JSN1dBVnRTMk9WRlIvRU5kcDc2?=
 =?utf-8?B?NXpUN3lUWk1BVms5UVpxVUVjM0tJRWlzWHpTVkNFQld6K3FUZXJaU21ha2lM?=
 =?utf-8?B?ZWF3UWpXaENhR1I4L1V4aFZ2ZFhOd3Nmb29WMktBSzVaTnFMTzl5WEhoVVpJ?=
 =?utf-8?B?T0V4WGJKRWtGZkttMmpabGt6ZDRGU2pzMzZBenF4QXNpRmRHSDZ0WnUyKzcy?=
 =?utf-8?B?V3RWais0akxXWGdETHRxS09Fdm96RUxoRzBDKzFDM3RpT2UxZFZ4OHZOajR0?=
 =?utf-8?B?N2lNM1N2WkVPelgxRUgydWJSTHJxN1ZSb29CVEZWVDI4OXVXQU5hQVdoRy83?=
 =?utf-8?Q?DO34VmCtbRyw2aEthF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d33ed26-fc82-4831-612a-08de51fc59a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 17:02:21.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /JIcU7kCZIVKDcMiWTZcXdflLuBhrcH/iNy+14+C7MqcclFU/uyTBpVyAX2cRYYo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 727CA180005
X-Stat-Signature: zahu494phwszcdiqcaqaohikz4pfewon
X-Rspam-User: 
X-HE-Tag: 1768237346-24394
X-HE-Meta: U2FsdGVkX1/RmW+4QofCJk5eTYEuJtA6DIca97ZLOX7hg35u6DeLa/Ln3aYl5ckGcViM5r23MJ8lP4PBgxXSxgOBpMX5Ca26QTYX2yNUhn2LfBRRAFgw3VAiL9HbsgbAQkA+7PofdHk5E6JMg3iKNU/g3u08JpRyUSURiZTpSzHGZUj7lIF7khG0cxQ0rIzppAJfJBsHT7oFduw0mXoFxQAHibrOwdCEagI57vd2Vb/YtOgT1YgzjN9GoUE9LKSWTBksRLlGTGJKJWSxlNCDPTZwt9uOY8faUxoFry+NU6i00ickN3pnm+td+4jgwKHqQWf087PkvzStH2aAJwAm8TLH2MVCulqGiFLn8YwnXqmAgxfv1XrMUWscUFG8JxfFM+AsE4k3BLX1YCXMu9nbWJm/N7vxvHFv21QcHhF98i86NHWfNstxFlk4nO0dbuD2QpbdwvI4AN0jtJHGxJJQn+tDoANhkoIxrTBRboMwlrUMxOQ4cu9If3YVODb1s1RHbQNXH0Bwg2BvAsk1OfwfHLLwBuRsafWDyxBKXojylpgZpOxfhttf/L5qbpIVkoB6g3CFB9iwNBCJcpsf6rIy1KttGmwMCfWbjAyAkeyeCxO3PalfevDgmfZ0Db8RUqnCLLx1hFEevSswYHmvaj7VgMSb1ucdOOdmkr+xtW/HIxiZMHptDnJv4YVkUUOdoLZCxD68kQFyejOg94TElydFnfkYd19sKBW2nu+tFzl5nua8lH7EHxQe8fIDU6B8qVy4Gs+GU96fkAjTWNKzxHsZsVMx+LQYinh98RZ0ApIywo5qvK0vGyzCDxDGUg47lTWWkTdLE2bERu6MfY3h9+hy0lTF1KpG4+LC5sZksQSBZ9C4mNZE6pJEIrpymq+zBCHa0bYrNaLE5m5l9fPsFqg+DSr6yPFpHmiX8ZutVAfkvD4wvQyQrw4tA52a4yjovQztUWAuXPC+MuVU/x7jNhX
 icYkrljB
 BMtbYZt/8NHkAcXz1dZCAtBoLdauUpTtcJEwgUKyw3Oq5M7E/JQcpjvhhBWgTr3/1f/bGnFXE0rNWCXUnRvoPFTft47Ts0ur7ZeQ3G1HGyAtq2WLTtiP1h6x6Da4ruV2sgSOK4AgiIZ7RH8Kyv4buac4MIp2IK2iIJrHDhdewOYHplp2traem55AbQsl0YVtVbugLJeNwv37mncQO4FOQ/DKSMLYpHDaUaIurXwBUWJk9MyBcAaM7EQAgDEb7eXb3N45b1urrvqD1m/PHtcqJ1cXD+vqssrEPuSRMUW9eekSiaQtzwoJZONfUDVGTA62LNy2m0+B73pemP1hovYcqm0dRnKJA9GD9cjoOq/4zOf8oNR1tB33EXm2nYMHhbRDTlA7l7YDE8QKmrIv/XFBH4OdC7m0Xzlo2tbKt3LkIL6Whh5J8k2Se3lQnfIlk3QMBgX5S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 10:09, Kefeng Wang wrote:

> The alloc_contig_pages() spends a significant amount of time within
> pfn_range_valid_contig().
>
> - set_max_huge_pages
>    - 99.98% alloc_pool_huge_folio
>         only_alloc_fresh_hugetlb_folio.isra.0
>       - alloc_contig_frozen_pages_noprof
>          - 87.00% pfn_range_valid_contig
>               pfn_to_online_page
>          - 12.91% alloc_contig_frozen_range_noprof
>               4.51% replace_free_hugepage_folios
>             - 4.02% prep_new_page
>                  prep_compound_page
>             - 2.98% undo_isolate_page_range
>                - 2.79% unset_migratetype_isolate
>                   - 2.75% __move_freepages_block_isolate
>                        2.71% __move_freepages_block
>             - 0.98% start_isolate_page_range
>                  0.66% set_migratetype_isolate
>
> To optimize this process, use the new helper has_unmovable_pages()

s/has_unmovable_pages/page_is_unmovable

> to avoid more unnecessary iterations for compound pages, such as
> THP, and high-order buddy pages, which significantly improving the

s/THP/THP not on LRU/

> efficiency of contiguous memory allocation.
>
> A simple test on machine with 114G free memory, allocate 120 * 1G
> HugeTLB folios(104 successfully returned),
>
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepag=
es
>
> Before: 0m3.605s
> After:  0m0.602s
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/page_alloc.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d8d5379c44dc..813c5f57883f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struct zone *z=
, unsigned long start_pfn,
>  				   unsigned long nr_pages, bool skip_hugetlb,
>  				   bool *skipped_hugetlb)
>  {
> -	unsigned long i, end_pfn =3D start_pfn + nr_pages;
> +	unsigned long end_pfn =3D start_pfn + nr_pages;
>  	struct page *page;
>
> -	for (i =3D start_pfn; i < end_pfn; i++) {
> -		page =3D pfn_to_online_page(i);
> +	while (start_pfn < end_pfn) {
> +		unsigned long step =3D 1;
> +
> +		page =3D pfn_to_online_page(start_pfn);
>  		if (!page)
>  			return false;
>
>  		if (page_zone(page) !=3D z)
>  			return false;
>
> -		if (PageReserved(page))
> +		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
>  			return false;
>
>  		/*
> @@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z, =
unsigned long start_pfn,
>  		if (PageHuge(page)) {
>  			unsigned int order;
>
> -			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> -				return false;
> -
>  			if (skip_hugetlb) {
>  				*skipped_hugetlb =3D true;
>  				return false;
> @@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *z,=
 unsigned long start_pfn,
>  			if ((order >=3D MAX_FOLIO_ORDER) ||
>  			    (nr_pages <=3D (1 << order)))
>  				return false;

How does page_is_unmovable() interact with the code inside =E2=80=9Cif (Pag=
eHuge(page))=E2=80=9D?
page_is_unmovable() only identify 1GB hugetlb as unmovable, so skip_hugetlb=
 still
works?

> -
> -			/*
> -			 * Reaching this point means we've encounted a huge page
> -			 * smaller than nr_pages, skip all pfn's for that page.
> -			 *
> -			 * We can't get here from a tail-PageHuge, as it implies
> -			 * we started a scan in the middle of a hugepage larger
> -			 * than nr_pages - which the prior check filters for.
> -			 */
> -			i +=3D (1 << order) - 1;
>  		}
> +
> +		start_pfn +=3D step;
>  	}
>  	return true;
>  }
> --=20
> 2.27.0


Best Regards,
Yan, Zi

