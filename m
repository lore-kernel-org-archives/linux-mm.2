Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73CBC88E6A
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D286B009F; Sun, 13 Sep 2026 22:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D806B00A0; Sun, 13 Sep 2026 22:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52E26B00A1; Sun, 13 Sep 2026 22:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BADC6B009F
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C9B541A0EC9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:38 +0000 (UTC)
X-FDA: 85210774236.03.6BB01B7
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 082CD120004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZeGN1PiF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
	b=T2bUUfZCAIK0DSuIQLDHfeIRrDPK5pDE5rMZcRjbG4Gp/vElq/JMG8QihjgRdFV6+6hvBw
	9sw/hZOcvb+HCiDkPuvZwQc8qgDrqEt3JskhUWWQ5N1hobS+fUydpUm97Nkx3QoWj6V3xW
	EhTSx/DcbggCBlUwiqDCfPuyB0XOH08=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352676;
	b=IyuKHOWfVqsMC7P9fdAaIMKg25tyv3h/kjUoUwI6WDrBeoLGKtPMwHxQJZhoMfYZIWIU+U
	OCJfMrkKQ3tgYuExz54T+U1ZBNotDM2UeT/YOIlJsLp6JcBB1o7RjPU6APwWDzV/afcVz+
	RaAY6JQU7hi43BvjMFO+aA2bgh8PPKE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZeGN1PiF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyeUyT24uaoa6vhNMRnp19Q+DjDQYkx8+vKwcJyXEIOjzOjIWXxvSJq0scmoWoo40n224tcSsYvu282BQF0y6g5lqYQ8cOZrl/+DX4wdXDU8zt8HYn39BtlVa+K+54Xuuh9vquqlH0ncHakQ9d1vNAbztxuGF0Py6IAfB2TRTG87gMYcvv1qN8tsXArUy3nrJXVPdcBFYDddAxuRAzkrzMN+GdDI5K/KKYQwjkFRx5QWY6rP3fLUis4wzUhBh0Hhk1WJHDPcgJPjEFjk3H4KdcGvf2Jqqfw4gBwzyYHVHHSuGBRe+c+SpuQeueii4veyJL3msLCuqoM5234wDubX3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
 b=x1OstSI4vBfoh86AUdUo4MSY2UKlX47pNESipU/y8c3Ord6w38us0EoFaXhj1JO2PuuEH/8phmztqxwqvQKl19Qbg6XKScMfTaRZmceh3ddu3ym/4Sq3PCpOhx9SEesT3a7EB/V9BVBdThvzSwQU/IvfAcmslIJLY7EjODoA4WHDON+NxzVB6eHOF9g42bMPjwhiGNuppFeY2b98+rRu3oNuNmMbqRbVUZYvUKAGIhLp77jMjF/GSEUyCG2GrvhMsbyp+G1Kvz3rKgrXiRnK+occ1g1C4A0LWdo3+3l+XOr6LjOoiGBv04wOoybXvnfhmlltzqHh66InQzNsGPIyrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmJueOys4162YTP727zQmwKPUht4GWCKnV6YwC01lf4=;
 b=ZeGN1PiF9BgyQCXrKhajxbSwPIijlIF6f0+kaqX5Ahm05kOf7WJdDtiyNG4b7VqQ3lrjbnTbdpUV6C7/5g1XkfnP+2kyQ9ZjjWOh+XkbNYLn2m2gpilbu7BwXNvKTOrbld0NHXx9ddBpN25ejJbT77GFUoZDmQfjgI2IV1rVrwFG4DtLd8eZjHTRKix8AtjmWv7mh2e+gqRd6njTsc52u46T6mrM1CKPUqtqS5c/eCbQ8htK2TWwkHp/4g8Q2HgDwrpa3xz1Ufxd68P9XcPhEaaMPKJPqI/OTZOZ0bMLhClnUBtw1G8c0Num1HY1EMVXPBjZYE2/aaHmRgu1oRmNPg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:20 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:05 -0400
Subject: [PATCH v4 07/16] f2fs: convert the ->private flag helpers to
 folio-only
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-7-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Tal Zussman <tz2294@columbia.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:52c::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c12b514-a3ba-4eea-979a-08df120748b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cpMkaUZNJ466GAw45De0V+gsLJuf5jEyB0VOkKILYIA/a5D5sYlllWFG/PwTfSkdFAMxNc0GibU1ryLsZcaw3VM+AoEnHYhB1w3gU13NPn6jxJ2FncUtUB5qstaMJXxfvXybdb/LIvMWx52/dfomvfBefuauSFYzF+j3SWMg0sYE+p8xXQlCawA76fmKk301Hbetso05ZDz1QuhFxDNN0V+wn6paE2ZgAIkypLYYqwqgjI0TcGleyQjlVTOAPKBg56IWYjYmT2GMpO0aqthDB2IUquzBf/uJMNgnp5kt143dC8Ynw/4edjTppQZrARBH0tRbMNX696NZQqQZjQo4MMPFTWID7UUcpH1jYjhYke0mjM9HJsZ7PcuygvwiMZJpKiQBO6ty+Zz5OWY5k+jCm5jO9EqZkK32wK3G2KubHulgSh+FOCOTG5pVNjHOGU/wiCZ+nLKuvufYuGu5t0Mcj5lADiEljyxdfy4lDA9dwsBj0wZxQW5XstGJkuzX+BTB5+pbvQ76exl3vr+O++AiU/cTQNghs+be3EDB7+yqarfZrXYZ86GeInKtxGd8EoZSSfYvfBuINnOoIjkpjN675xsIAGm9Z3M6piUE6VmmR8rPl5NBIy/lWOHkxLvzMWaX1sgW6nobcbHxWDDGdatG9X7G0P0TFyVMycd1VWrgaBQolThpv2rPY7QeL1fdz6G0oFUCw0QWt8fW1i6cGzChsQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjBKNm1FSTlyZ2JBNG5xSGt0VlZyODdxMjlSUHZCbVRUTCt1Y2JoN0hidXhI?=
 =?utf-8?B?aWQ0cUpUdzBiNXNJN2NNMHgvU3V6Mk9BdXBVZjBRWWExNGpKb2pFc0hMejVV?=
 =?utf-8?B?dXpzcm5nZ3BaY1BxVFZQdDBmS3pxSm1oZ1RmbnBsL1JNU3k3THAwWTc1emNq?=
 =?utf-8?B?TjdSV3V4RzB2aURqQkhpcWhIUkhoS2UydnRDVmNHR1JPQUFaYjdaUVZad1gy?=
 =?utf-8?B?cWZEMEtwcTE0UURpMm0xMTVGQlpaYzR5ZmtLRUZkb1QyYVNJbTQ2S09VbnFz?=
 =?utf-8?B?aTFSaUhoV1pSdlp3RUlxRDhLalU4bWVFVkxEOVFDMDhFblNJT01nblpHK3Nq?=
 =?utf-8?B?MVdFa0xWSlNDS2M4L25JWFJPQXk3M1R1OE5meHdpVkxpd1JndXgrUEpTR1Fz?=
 =?utf-8?B?UmdZaTFNYitLN014ZWdFaUdLTWtlWjhYckJ1M29DOEZwK2wzTDIwMUNqc3BV?=
 =?utf-8?B?Zlk3bGhqYlA2dFEzOHhWQ3V5N1ZXRllTK0RaL2Ewc2FJeFByR2YxZFR2RFVI?=
 =?utf-8?B?aWRyOUpEK1dGL3FKbFl3dEIvSHdUVVFsNklrbUtYYWIzZ3NrbXBXclE4SnJ5?=
 =?utf-8?B?cDMrVEcxOUtqNlEyWmszcjdBTk84blNNT3E3MFJRcE83aGZ4RVNmY0dKRzN5?=
 =?utf-8?B?WXhJekhQMFpRMWQrc2haeFVqbk1XaHR4VHRXOWpxTlBKNWtTMlJyVGMwVEdT?=
 =?utf-8?B?bCt1dUtsa003S3JyV2tWL3MxUU5ldktlRGt3VytxRkVtWHNSUDJqV3RhMndN?=
 =?utf-8?B?Z1laNG9hYUpGWTlDVWR2QWFOYWI2c2tmTFh5ckltajRvTDNmTCt4K3FSNWpE?=
 =?utf-8?B?ZVJRRXkwem5HRVl3a2Q1QUlqeG1FTFNsa2daS3ZuMUJXYnk2ckV4M3M5MzZ2?=
 =?utf-8?B?QVVwQllhbmZ3SFJmOVpvSEh0QWZqQVVNcXJiMHRqUmczV0JxWjhGMXlPNDda?=
 =?utf-8?B?RXhTWXFYdkQzZkJ5SFhsRHdOOWFiVnpHK3k3cnpwYjJLSXJpTXhBMlpDM0dM?=
 =?utf-8?B?TTlmdDJTeVV4UldjT0QwRGxjYjFTZkxXVGJXaERxKzRHYyswbElDdi9XSzVR?=
 =?utf-8?B?SktzY1N3b0FjK3pYbks1d3hYOG1nNzNKZ2hWSGFYaGFNbThnR3BXU3YrMjdF?=
 =?utf-8?B?VWNFT0RvcEVqS2xOQXptaURYUWhJMnMvTjJlTWxZUWswdVZvbFhpbzZGaGYw?=
 =?utf-8?B?eW05aHoxRjNoQnV3VlVuTUlleFQzM0kva1Vmd2EvVWhTTURIa1d3ODVBRzAw?=
 =?utf-8?B?QVBGS1owQ3JKV1A3a0JCNS9KR2s1aC8rNEtIUXZ2enl1a1owUGhILzZON3hz?=
 =?utf-8?B?dzQxYmhRbCs4RHlQUDRRZWlxemliMXcybGNzSmtoNGlDRmVWcnlQWUlYLzdI?=
 =?utf-8?B?SnkxRjhuTlVCdDZncWdHY29JMXhZVk9WMjhLZlk3UCtidU9oY1NiNnhESEJP?=
 =?utf-8?B?NXVyQThGYXZ4MGs3dUNzTzFRK0lJc2xkTXYyZ0pjL3hkM3pFdHBtM0Vwenpi?=
 =?utf-8?B?ZERjU3lmUGFZcTlINkFmWEZjMDlHVDExVC9LaEtoK09MbWFyL3pEdmFKTitO?=
 =?utf-8?B?bkN1aWdNWjFoRi9hSTVkRHc5QzVxQmV4UmZKZjV1MG5qTkZjc05vQjlPdWVR?=
 =?utf-8?B?OHBBc2VKQ254TmE2REVvRFhNN3Z3TC8yVmpUTXMwcGE1TEtuVzUwQ3RpOVo1?=
 =?utf-8?B?MmFBV2pIUzVKazM2Y3lKTENBaTQ1L29BWUlNWFNxQnRVYUYzaDBhQ01pTm50?=
 =?utf-8?B?bGxwdlFrbytzeUhnOThwK0dCSklqZGNUSFJDZVRWYVRzYjlsdVBlZGFMV1ZD?=
 =?utf-8?B?OTdCc0NBZksrZVJUNWd5Z21JQ3htaENnVmVaUWQ1NGl5SVBWRUNDMjdjRjVs?=
 =?utf-8?B?SjNXNk9Xa0lUK1czRmdySjk0L1kwUlI4UG0xVTNoZnhZTEs1MXRGMkZXVkU1?=
 =?utf-8?B?bnZ3V0V2QkIrU0xnWkFhS0xPYU5ySEFYM1B5bjRYdCt3TzFIOXJnMXROR21y?=
 =?utf-8?B?UVZ4cE5ZRXhmNEFpNjFKenlYTEFEMjVaaTlHaUkwdHgwUS9wSHppeUI2K0NX?=
 =?utf-8?B?ckhJZStpdzhhbG9kUEJWOEE4WU9TcS8wUHJQVlhudmcxZ3Fha1JLT0VnSzZ3?=
 =?utf-8?B?bVM3cGpzeGpDd2k5dHpPY1g0R2xQTXM3eVRJcEZkd2pLc1VOY1BnM0NNUGY2?=
 =?utf-8?B?ZlJwOFRkekZUWDdrWkRuSjZvWkd5dWZZVHg4T1hmQ3ZsUGNOSDROZ1A3dEQy?=
 =?utf-8?B?VDlPcG5kS1ZLazN6eE53VWtuKzlUQnFqRk9PVHhZOTBLUUN0UEhiUnJyWEtN?=
 =?utf-8?Q?SyYbQVsUglvuogXEUo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c12b514-a3ba-4eea-979a-08df120748b3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:20.4722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKsvlYwX6onBWxi3rfWuJ7rRMzPsLuzNJldGgPOSrAsNOodFbjLLiFWqx7+naphA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 082CD120004
X-Stat-Signature: 9phqo5pnwhtthxs38md9te3ssaruk7wc
X-HE-Tag: 1789352675-894560
X-HE-Meta: U2FsdGVkX19kaXBLhoBezinwW6cF4O8egTv4Y9WGuVv+NY8c2KCUWvxt9XHl3ttR5ogNFxvznj9U6jy8vbCROT4VR0TguVaSrcnOtdRC6w2uMAGjzJn259iRl4UPfSsb54ElihOB+ZjjVSp5cAD/nr63LSINu+gQas0J3xij43FbpPsxuRdLPR3Ie3YO5N7FbIPeYn5x8fzF3g3SHF+H77AvuHp9NPIjPJQDB8pbDo7fyE6I7fG/y9ZCW7QDZXbXPg9E50rR0aQas17zoXUbN9hdz05JiXJ0Ut9gskz9UFD14vKkvxttLHLEoT11mojEvUzdIB6Imcw0ddnKyX5LoFyLciYvTmmCizeHc1+s5ZwTBmfsRwjC5TjiFX40FzFKPrWgpNlfdvhYwTFitG61mJPr+5PyyB20RDWBuGtz7hArhksIKQE8hRxxgHPhT89KRT8XFPi7qrsz58vmEs81lWgnXZXhbtDj6Lp6TytyPns07AXTdnc4KZhTKtg4WGaL1ZsOyiP+7mtRpQWyHBEQb5O9WQF9zqmvaP1Cp6DJT26ZVIha7F6TDJj2Uh0beTCVEXlXU3UIy9RLOhnPlrVlSr417IcSuLTauK8IxlLeYjSzqRSCNSWI43heEBufqAge/q3JUZMZIgGi2OKbCxgflJFs//njOjRPHy7pcu58R2KUGfxwVdHTVA6RK5x95f2fdatP7ft7hmHkJxil2FJy8GS2KOJ5fyJD9HmzhTEmMLKbf3nmkbnN9w9uJ/6McVw6SLqvueIwC6W9+NDkyiOrpBTymnSwBkJeAqRMpvYXB87ujlo33YeJuPMLD6lbWqsUAhp/rV2FBma+mdW0I7Bl9/Rj/iofEVOIPzyYkNNmUdMP5jqoiLqTMwBIvj61/oSZF17Er/e4esJZKj3bq44CdQp0ke2ErifBXsw+qr1i9eiNZYoTo7Ld7qUpaKWTLSq4RO6czk+4OxIChp48KS9
 6VjroiQa
 r2gNBkuTyaS8aQ4aTp9dofUdP4/NymJUSy3BiD7v5misjgGRM/ED3pLBBPXo54sg7J8I5Ot996Rs+SGhDpZQWgLf9igY8K67HgTA/JeR188JtqF4CEXjcocTY0y8ghdwEBB8CbDvj3QySAile+ImanjYeOLOHZI6tx+wLZntIJ3MZiJ26PTlS2Lyoxlr7zbrTNu0LSd8yNVV6xAn9JFFZ/eY+vohrEqh08BiTbuiC7uXJU3GOqvrbKs9AyYQxVSRB8V0/Pjj3UiZpXlHrxSRxs6SVv4i4bQXKkm/8Ax0zrk99XHvlx/7lUmre7tXkn63uVFoQfVJkMbV2EbNO8i4lnTDswLFaNVQM+xTW7xUhZaLutcWxnrSCEs14LFfTCLqEdi7qQEorU3n4YseyKvNeiXEoezonWr738JbFMaDXwCr4G1Kcgwgbah9U+Dq/psKv4Rhz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page-based ->private flag helpers are used in the compression path, where
large folios are not enabled. They can use folio versions with
page_folio(). The two remaining users in data.c and segment.c can use
fio->folio instead of fio->page (two are in a union).

Drop page-based helpers after the conversion and rename
PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
f2fs_io_info union to folio only, since no page user is left.

The folio helpers do a plain read-modify-write where the page ones used
set_bit()/clear_bit(). It is fine because the converted code either holds
folio lock or, in f2fs_compress_write_end_io(), matches what the
non-compressed code does in f2fs_write_end_bio().

Assisted-by: LLM
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/compress.c | 35 ++++++++++++-------
 fs/f2fs/data.c     |  2 +-
 fs/f2fs/f2fs.h     | 99 +++++++++++++++++++++---------------------------------
 fs/f2fs/segment.c  |  2 +-
 4 files changed, 63 insertions(+), 75 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index ce88092d9ce26..09d9b8d0fdcce 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
 
 	/* Cancel writeback and stay locked. */
 	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio = page_folio(cc->rpages[i]);
+
 		if (i < submitted) {
 			inode_inc_dirty_pages(cc->inode);
-			lock_page(cc->rpages[i]);
+			folio_lock(folio);
 		}
-		clear_page_private_gcing(cc->rpages[i]);
-		if (folio_test_writeback(page_folio(cc->rpages[i])))
-			end_page_writeback(cc->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		if (folio_test_writeback(folio))
+			folio_end_writeback(folio);
 	}
 }
 
@@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *cc)
 {
 	int i;
 
-	for (i = 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i]) {
-			set_page_dirty(cc->rpages[i]);
-			set_page_private_gcing(cc->rpages[i]);
-		}
+	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio;
+
+		if (!cc->rpages[i])
+			continue;
+		folio = page_folio(cc->rpages[i]);
+		folio_mark_dirty(folio);
+		folio_set_f2fs_gcing(folio);
+	}
 }
 
 static int prepare_compress_overwrite(struct compress_ctx *cc,
@@ -1281,7 +1287,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		.op = REQ_OP_WRITE,
 		.op_flags = wbc_to_write_flags(wbc),
 		.old_blkaddr = NEW_ADDR,
-		.page = NULL,
+		.folio = NULL,
 		.encrypted_page = NULL,
 		.compressed_page = NULL,
 		.io_type = io_type,
@@ -1370,7 +1376,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		block_t blkaddr;
 
 		blkaddr = f2fs_data_blkaddr(&dn);
-		fio.page = cc->rpages[i];
+		fio.folio = page_folio(cc->rpages[i]);
 		fio.old_blkaddr = blkaddr;
 
 		/* cluster header */
@@ -1476,9 +1482,12 @@ void f2fs_compress_write_end_io(struct bio *bio, struct folio *folio)
 	}
 
 	for (i = 0; i < cic->nr_rpages; i++) {
+		struct folio *rfolio;
+
 		WARN_ON(!cic->rpages[i]);
-		clear_page_private_gcing(cic->rpages[i]);
-		end_page_writeback(cic->rpages[i]);
+		rfolio = page_folio(cic->rpages[i]);
+		folio_clear_f2fs_gcing(rfolio);
+		folio_end_writeback(rfolio);
 	}
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21f396ebe22ca..ca8232a9095f8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2923,7 +2923,7 @@ bool f2fs_should_update_outplace(struct inode *inode, struct f2fs_io_info *fio)
 		return true;
 
 	if (fio) {
-		if (page_private_gcing(fio->page))
+		if (folio_test_f2fs_gcing(fio->folio))
 			return true;
 		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
 			f2fs_is_checkpointed_data(sbi, fio->old_blkaddr)))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2f7ab5888b078..85937de3d7016 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1357,10 +1357,7 @@ struct f2fs_io_info {
 	blk_opf_t op_flags;	/* req_flag_bits */
 	block_t new_blkaddr;	/* new block address to be written */
 	block_t old_blkaddr;	/* old block address before Cow */
-	union {
-		struct page *page;	/* page to be written */
-		struct folio *folio;
-	};
+	struct folio *folio;	/* folio to be written */
 	struct page *encrypted_page;	/* encrypted page */
 	struct page *compressed_page;	/* compressed page */
 	struct list_head list;		/* serialize IOs */
@@ -1613,27 +1610,27 @@ static inline void f2fs_set_bit(unsigned int nr, char *addr);
 static inline void f2fs_clear_bit(unsigned int nr, char *addr);
 
 /*
- * Layout of f2fs page.private:
+ * Layout of f2fs folio->private:
  *
  * Layout A: lowest bit should be 1
  * | bit0 = 1 | bit1 | bit2 | ... | bit MAX | private data .... |
- * bit 0	PAGE_PRIVATE_NOT_POINTER
- * bit 1	PAGE_PRIVATE_ONGOING_MIGRATION
- * bit 2	PAGE_PRIVATE_INLINE_INODE
- * bit 3	PAGE_PRIVATE_REF_RESOURCE
- * bit 4	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 0	F2FS_FOLIO_PRIVATE_NOT_POINTER
+ * bit 1	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION
+ * bit 2	F2FS_FOLIO_PRIVATE_INLINE_INODE
+ * bit 3	F2FS_FOLIO_PRIVATE_REF_RESOURCE
+ * bit 4	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE
  * bit 5-	f2fs private data
  *
  * Layout B: lowest bit should be 0
- * page.private is a wrapped pointer.
+ * folio->private is a wrapped pointer.
  */
 enum {
-	PAGE_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
-	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
-	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
-	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
-	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
-	PAGE_PRIVATE_MAX
+	F2FS_FOLIO_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
+	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
+	F2FS_FOLIO_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
+	F2FS_FOLIO_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
+	F2FS_FOLIO_PRIVATE_MAX
 };
 
 /* For compression */
@@ -2681,86 +2678,68 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 	return -ENOSPC;
 }
 
-#define PAGE_PRIVATE_GET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_GET_FUNC(name, flagname) \
 static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 {									\
 	unsigned long priv = (unsigned long)folio->private;		\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	return (priv & v) == v;						\
-}									\
-static inline bool page_private_##name(struct page *page) \
-{ \
-	return page_private(page) && \
-		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
-		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_SET_FUNC(name, flagname) \
 static inline void folio_set_f2fs_##name(struct folio *folio)		\
 {									\
-	unsigned long v = (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	if (!folio->private)						\
 		folio_attach_private(folio, (void *)v);			\
 	else {								\
 		v |= (unsigned long)folio->private;			\
 		folio->private = (void *)v;				\
 	}								\
-}									\
-static inline void set_page_private_##name(struct page *page) \
-{ \
-	if (!page_private(page)) \
-		attach_page_private(page, \
-				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
-	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
-#define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_CLEAR_FUNC(name, flagname) \
 static inline void folio_clear_f2fs_##name(struct folio *folio)		\
 {									\
 	unsigned long v = (unsigned long)folio->private;		\
 									\
-	v &= ~(1UL << PAGE_PRIVATE_##flagname);				\
-	if (v == (1UL << PAGE_PRIVATE_NOT_POINTER))			\
+	v &= ~(1UL << F2FS_FOLIO_PRIVATE_##flagname);			\
+	if (v == (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER))		\
 		folio_detach_private(folio);				\
 	else								\
 		folio->private = (void *)v;				\
-}									\
-static inline void clear_page_private_##name(struct page *page) \
-{ \
-	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
-		detach_page_private(page); \
 }
 
-PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
+F2FS_FOLIO_PRIVATE_GET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
 
-PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
 
-PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
 
 static inline unsigned long folio_get_f2fs_data(struct folio *folio)
 {
 	unsigned long data = (unsigned long)folio->private;
 
-	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+	if (!test_bit(F2FS_FOLIO_PRIVATE_NOT_POINTER, &data))
 		return 0;
-	return data >> PAGE_PRIVATE_MAX;
+	return data >> F2FS_FOLIO_PRIVATE_MAX;
 }
 
 static inline void folio_set_f2fs_data(struct folio *folio, unsigned long data)
 {
-	data = (1UL << PAGE_PRIVATE_NOT_POINTER) | (data << PAGE_PRIVATE_MAX);
+	data = (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |
+	       (data << F2FS_FOLIO_PRIVATE_MAX);
 
 	if (!folio_test_private(folio))
 		folio_attach_private(folio, (void *)data);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 63b712d3d599e..8c156e1fd37d0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3803,7 +3803,7 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 		if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
 			return CURSEG_COLD_DATA_PINNED;
 
-		if (page_private_gcing(fio->page)) {
+		if (folio_test_f2fs_gcing(fio->folio)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type == FS_DATA_IO) &&
 				(fio->sbi->gc_mode != GC_URGENT_HIGH) &&

-- 
2.53.0


