Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A800AC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682166B0093; Sun, 13 Sep 2026 22:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633D96B0095; Sun, 13 Sep 2026 22:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512DB6B0096; Sun, 13 Sep 2026 22:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16E106B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38026120E90
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:28 +0000 (UTC)
X-FDA: 85210773816.17.CECE7C1
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 544F9120004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KBemojQH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
	b=ht5BzS7t75szNRhFb18p+a7o1kUmF21JXgNdPnM5DLw02mwymQYqxgMgc8PFy7IrkOfJWg
	CEWkd+9glGCdCyoXiI7pwaDMBzg2L9cjnEZFCFBTOzvKa3/mv3mmvBeK4Xp2/o+I4U3Haq
	or2E1XaNmIyHqN9FDsMpE02r4NvLutU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352664;
	b=Buxjao7yLC4g7//SwOCIvAJ4Uv5LO1RW3mDPwvhOyNV6rEkux8TcEo3QMjFbZEJvXrs6yx
	g22FDulxPacmnK+GTF2/SpNBu+n7ImSkoNghRsKJMOo1TuJU4dxUcnIUN2wk764FwANpa1
	4Orp5fe8cWA1wKoUDCfc5KcnW/aDSvs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KBemojQH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9B6VK3iYGrP99iu3trhB0yw7Z5OmiMG4b/hRE/v0Ez+pfFB0RysLqQdMx/VpPLkLcS98H1/G9VidRjJXf7U1Wnlqq4YJvfm4yX3/yFJTkcFwD4fAPeJ06oGsmtbtuVmk4YAOIfB+bKhkAG5/BzUYRE9XJTTTBEJBW3P5NMr7L/EB3TUJFcWg/MQ0lJ4pIZprGlNtWqWPwzgYrHt3hhcd2hD11BP8dH8OfC2u3vHt4rvv2OLISKfIE/I9BJ2HWlE1OyNVtmFzrRWcj7vd+i0iUFkivBeVfhTaO33/hIVaaZRyw2agIkU6YTxrz6kLZlhs3LF5nnEZ4WRO+ZrTrdeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
 b=R06FrhrbtlnarqHSbcUcmo8Uj1qUolZclU0MGfzN8cFsld1jd1w7V7/VfEY3rEUzzwaOyHOEt21t+6alBVSb1AWQ1BUJKlLZgVHm7tMnxp6i6JhCFXOyMxrRXcPXuTvjLMwakGliajNVBxGW/HBrnPEpmjVilyndeuLjrDKZEFPk6z8VjFI+gLQR1u04PEt+Eft+6aigv+3HTlPpqwCZq+fdBlowG+oYJoSuF1/ul8cIPEho1Apu93q22stv4IrQeEAO9VZq+Fwck7RaG0iIo3Up7i2nNPMbRJntLWeHRFd//S+SRQh5R3XlXjhiua0NpAbuOn/bKNotfppgqpC7KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2exs/HrKls73cpHbMG/JtXwC2lJhkBDc5l1lfu+a19A=;
 b=KBemojQHJA2qARIkMsaKZhCRxM+pV7F1dqmn8CtYP4YfCgk4kyAoWYCf6tmz7pEWNqwarmWr6XZH2g1hvCYHtq1bnfJtdhzyIVO3PHDYI8I1+UHN83vnmWsHcMPu18L07UE63uLEQJrkHzZoSaeiMST7xitXmLAGNDUXhZN1kTcHZvFiVFCjz/tWn7pG+ZXlP0krtH8VjYcrzvJegnhoN94giG590cfLKkEorXJ2z0CtYPtwkREFBgLA5Vu+7g9mwxsZ1m4vP+H9Ipua+3vLI6KhFco1Qnnt8flkpcXYSYC9UTtql7BjPNAMR0YyXpCjpLS1fy1Yhgile5ZP4S3+lg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:15 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:23:59 -0400
Subject: [PATCH v4 01/16] mm/zsmalloc: replace PG_private with pointer
 comparison
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-1-848550f7574e@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BLAP220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 4445d94f-c001-49b0-1e03-08df12074583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	6yhzzQF71JECsu+nTD9dpwNs7PRdNk5FSFPxKsEsfUMb5CYLIKzeWBejkF+NM6KPXyZkYU08E0XDi7Wi7+Fao/HQ9d36NZVm8pFHkqf+efUqLgvTmWHVLO0KVfGetC9ejUdTRY6yMWN3lSDeBsV8mHKqhX+lLpj0UIoljSa3xyVJBn7M7qSVaMS08ZHaDLWwibYgnjPle2JzAkINXjaNJsIcFZAT1cfo/YRtl9PuOCjaIxYYbpzA0wvUnqnIPfqEnBfTDcUqQj23Wdf4IA9vs7kOzP4Y5sxTrt3mJa2bbSMm2YzhemLcDTZ57d4WSOG0LvGCn8n5SBup5WRTtCtSefu9t+Wmh06VbWUgW3ayTJ3SG9iZs5Ip5Mcq7TsJBd/QC5A+giyeXHKiWMBTdCihTE0AehVgCaUnRCH8UTyHSVxLZkEmRZa3GzKqdZqD5VYA6GSCYRI/1vjpD//iv8WDq3X3KtWRGkkJXJpoIREygSDff1SwDv/EBclHAnXgwrLL0rGW9z2/3twMIfHEAOJW4tkTe9WkLTgufImrclncJZKf8LLMvZITxgdMYXDHdgnHpp/eKZklb3N5+z3a+vEvRUrPNQEFw6vBR/Z12PciniNlsLR5ojhyBaDpjL5y5oSaVPyAa/eSVKE+NIzcKBnkPtPFjL4xqNfWHVtquRgJb3VupecS3RUUXhSnHojz3oZ/sB8v9IVVdRuRUyyH8dWItg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWxHbXFXRnMyS2NFb0ZPRFhFcXl2R0M5WHBXSzVtR2RnNUZDYklDaVNBOEFm?=
 =?utf-8?B?VC9kQzBnMG13U3QwUmphUlhvRWJsVHVCVmhFZnUrOCtLcHJ5ZXpQYnNHVm1u?=
 =?utf-8?B?bG5GMUJUbUNtMFRCUUtKY0drNk9tM2w2STdON2ZobHhSSHVGWVVRMXBVaTlU?=
 =?utf-8?B?NFlqTDlTTFpSdGdyeEYxT2xIV3NoelJ0RnZ5TzdSL2JqOXZSNTZ0SmkvMGR3?=
 =?utf-8?B?SmFtTWg0akFrY2VleVZ3QXVJMjJ3cnJPSnd4OWJZdGl2Vngyak9GMUNoMC9M?=
 =?utf-8?B?T3BlVUxFbkxIbG9BZ0FUUDBrV3R0NHNYK01heGNZUE1acVJPcnlVNWRsdVc4?=
 =?utf-8?B?WFpaTlE5L2I4OE9SUHF3YVJiNHcwTHpEcGhJa21BY0hIUTNkTW8vdlpHb29O?=
 =?utf-8?B?SzU1d2krV1N3ZE01SW95M09QclJvZE1kdVFaRGdtTlVxaUFFcENTbmZHeWtt?=
 =?utf-8?B?TDZwNGhnQ0lHeUFncVZqS3JGWTVHRE5keFlzU2JHdld6dDRXdmxqQjhPTVFj?=
 =?utf-8?B?MXY5WGRrTTNEMVhsVUcrcHNHZG5GZDg5MTIxMUlOZ2hIRGJJMFdkZ3RyQity?=
 =?utf-8?B?OEVEcmZuRzR1eXI0bFBvYVA4bnIyQ0k1ZHRjRm8zZ0xjQ3NybzlkOUI5K1JB?=
 =?utf-8?B?ME5aQjdlS2N5WENHcXNDa1ZreWpaOTJvSFdjMlFCaHpYOC9DdWttWWRYWENZ?=
 =?utf-8?B?d3U0d20wWU9nRVViUXVsaExkMng2dXl3cE1wU0lIdkdndGdCR09jTVEvcEZT?=
 =?utf-8?B?ZCtrejNCdHNZcnBMamdsem1FZzJHYUJBWVZiWjlPSkNKVndvYnIrNWFRUDBs?=
 =?utf-8?B?aEo3VDM1d0dGa3ZXR1I5S1hQQnlFRlYyTDZSOHNaM2VwdHk5eEY4UThVTjJR?=
 =?utf-8?B?THl3OVJCZDFLMm1QaG81TzBvSnhxVkt0OHhHZXFXa09iaDFnZHdqeHBVSUFr?=
 =?utf-8?B?OFlzMUdzSkpRRmxZeDhSQ3FUMWczNEM0RUgwZGFLaUhjR1IzTGVBVWdwbFFK?=
 =?utf-8?B?djkra0Q2ZjVOTFZmQ2FRakh2am5rOVBIMUgwT09HcG9yUGxsSGFoOWxCQ3Bm?=
 =?utf-8?B?My92MHJVMk5VVG5qSWtrQnA0dnQwcHZXZ2g0dldiTzZEK0NDc3lpRTVMU0RF?=
 =?utf-8?B?eDd1N2NOQWR6dmhXRFdlaTFUa0E0eWpsTjlEUkdtenBXcXZ5K24wd0g3RDli?=
 =?utf-8?B?T0M3WjM1YU02WHJQUTMvTEJNZ1dSRXlTSUtMdGMzdktBUTVUVEpPUExBTkUz?=
 =?utf-8?B?di93RWFleURrR013TmJZb1BkV0dNUHc5ajQxWWsyTW1uR0VvTW4zckVXNlRl?=
 =?utf-8?B?K3hvZ0RXUWNoSk44L25GMmRmaWJ6QWE1dHRUK0dYQmZnU2M3b2Z0Vnk2bXRE?=
 =?utf-8?B?M2hsanlWbHhRWm9HYmdHbWtFc0tycFFTdXlIRzJVQk85QnBLdkJON1RnNXht?=
 =?utf-8?B?QmtaY2ZxdmlGSkhWUVlFRnM3U2tlZ3dVT3JobkZTWHppWkFSWVpmc1ZMYXVk?=
 =?utf-8?B?ak1YTU84Z0plZGRlYW1DVXRVOXNGeXlBaDRGa1ZoT1lUZGIrNlAycWhVYzk5?=
 =?utf-8?B?ekdNdGZncEd2QXJESDcvSnJwRkpWblpsM1BXVUxOL1NBNFhpZUhqMzlkVUlW?=
 =?utf-8?B?N0hRTjVHSjBtckZPMEgxVkVKTmFnL0QzSklhWFF1ZVpjOG1GL0JYUlMyQnRR?=
 =?utf-8?B?cDNtSGR4VFpkQm1mZ0hTYytvQTAzeDhhUmR4VjhuU2NJQUczd0tONzNKbEZu?=
 =?utf-8?B?K3BEYjgwR2t3R21OOXpqK29HSlA0ZzJZQlR5N0lic0VyMGFZam5KMzVrNXdW?=
 =?utf-8?B?aTVBazF5bzFkVkVUcHlWQzNBbVV5TjRsQUt0QnFwc2JYc1VjSDEzSUgyWWNQ?=
 =?utf-8?B?T0dpVW1IdHhCOGNtWnl6TFYvVUdsSUVQaE5uem52L3dTRDlNRnlGa3ZGRTB0?=
 =?utf-8?B?T3d2VU5jYitHNmNMMGlpTDBRV0dLRFNZc0szbTk4VENVem9OWDJXS0REUk0v?=
 =?utf-8?B?ejhJS1V0SzUwL015a0hBSEw3Q3JldVg3ZGRia1BWT2RNMGx4aTh3QjRjNHRC?=
 =?utf-8?B?dWhJRzVWZ0Y3VmRRS2lQTXRGQWNqM01PQnlOeHg2dmhoOXdsUTUrc3Y1UGNn?=
 =?utf-8?B?Y2tNWXpOWG1kRTZlZ3ErcGl4aXVmUDlMWHV3TmhRRzFKY3hHQWdBMHo1N1Zm?=
 =?utf-8?B?MktqNWdzUHFNOTdKeFVSanBSSUllV1U1NENxYUY2eDNTZDNlak1zRmlwV3Jo?=
 =?utf-8?B?UklEbjQ5d3kxKzFRdVJCTmRXQ3BqcWlGQjNjOUFkazlzWEEvNXIzcVpGeHZC?=
 =?utf-8?Q?11p2b55ZOPfFyT7YsU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4445d94f-c001-49b0-1e03-08df12074583
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:15.1173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYBX3Z08IQu38SfiPWm12H/T5UYoSBVn3zWXzMBMfIlF3n+uGCaQ2mhn1UZZ8byD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 544F9120004
X-Stat-Signature: mhspw89u5rycxr5yhh3tfm1aprb3dasd
X-HE-Tag: 1789352664-693295
X-HE-Meta: U2FsdGVkX1+UE7NVNsGzP2TX5hA+ic6u89xcJWZvTrTB+3Okq8wdnIntvGkq5o86RMp+QhM8Iu9fnf28tSRBxpLTZrlOLbLag+nx6zgcKjsHC2P170IQDv3SFfa6uHXZjh6CMxYk2UrR6+ETXkJss4C9bhgX2fb1awSo20Z+ilM622Vi5zcu/9gFLUiYa3fKP8ywrS7N7p2FmCLADmKGoWNk4x9WxqzLxbBT3lz7hgKm5Vf/8IWf/cj+Hq9vlQLUzTzVuAwW821qJWuF4xhlQlVP1X6of0ZO7drk+lpvBF76eipFtfsTsxIBqxCiyw2oTX6seDXlBB0be4u0Wan7Gwd5dx7m514ywIe5ZOPe5tFOKz6VfDNv1f/LA1RJCrUqx64IYaNsQm2tOYRGzAuvZdPtsyUbdzpLgQlITOEh7C8d6i6818ZoILuj/Z9N5NcAnXh2AGfL4TZirzLvPZfE2vVl99QYuv+andutwJXh8kEvR2pLR9sQYM9D+oGNcDS2plvR3aedTv5+FogbAtWEJ9h6ew1i5ldoSOmxa26leTVuBz+jsdhtc6Bv9iC09JOUzfzETQhm5a9t6cJmwM6Jax3tUnQjkkYiOMhzxwD+uPHEI/Td7cZfisgQNImLFtb3yOIBNRfi5xbLCFzlzRl3SQ4EMrvFA3heV6MDnGWaGMzTe3Gq2xU7/aEaf2+bI7R4qf6W88aQUamkMdxF4fJKCrcVxoA1gWBD1u1JQJrH8I4X3O2cYJdudBdC7UuEaPExgb72fz5Hqxnd+HFlfQFLHFpvxIVE33Ls24QwbUYw9UPxDgGrc8jrQIX78pFBziX/ZcZyC02n0uvwzZ/DLwk54RnHQ8PIkVVXlicVpeJ6SgGzQFwUeQVsaOX9wkkuCilIvnupMKpaYgQ1HCeQPkVMwhvjiQ+jjaWFqD9dOSgBSexuqDbEvo4hEe2P9s1LHrruyKBmZRv4eeWC1FCgFtW
 bgFu+u1N
 0Z2J1AwdWC/tXWXMBzgOP4i7piWaiA+Cokw2lZBIYmlcfff7CfwY0AYCxNcm5Nsx5NvWsYS/D7wNTYdkcu7MPKeUp2dsKOQ1BIr9igLnS4vEQDm24ucvdRAxi5/QbMqeFw4WKA30ZWyhMbPz7m9SaHjj911w8nX/WXFdSSRqtriFfndGzp27VVOXHZydp/MxCmb2RS5XL8doaEQNcSAW8P+XX5T7COkaVEwKgfxMLy3aKwSN/y1ZMmW0VtMfFx5XORxWkBHdpqSd8pkamn+pdTWR/45uc1cypS6PmFaSzhaX6fOssMTrj+7IlGGHODtY0d8/qXNzvZS+NivzgsuTSRV6OD289uDn1+8XDclJs/JBy22laAqHokNuwTUlh+RtkaYz9XpMHyhUuLwx4uQhXrhD6giM8mIm/Hf9nIgX3sVr+xhi0ooeptDJmMBWkxfUoq30J0neM2vL1jGk9B7YJNinq4ZP3N6R9foJa3eSvK0ScoOhOClAFeK8xZma4CJhGtLj2RHQBW8MohzfcDkqdBlbQR1/NpaiJBCfO1RGjRgOmic/wgTaDB0PKPZdo+f6+FCOz6g22zyXU2c8cNcUHTAbNP0sd2eHfCcoBKdmpOI00/oxIDXmEtf+Z2km4UGZv2WIiU6gXv/xRdZWnpo5OUCj7x9v72vxwzXlK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc uses PG_private to indicate first zpdesc in a zspage chain. It is
equivalent to check zpdesc == zspage->first_zpdesc. Replace
is_first_zpdesc() with zpdesc == zspage->first_zpdesc in obj_allocated().

For get_first_zpdesc(), first_zpdesc is from zspage->first_zpdesc, so
replace is_first_zpdesc() with first_zpdesc->zspage == zspage, the second
requirement of a zspage chain, where all zpdescs point to the same zspage.

is_first_zpdesc(), is only used in VM_BUG_ON_PAGE(), so performance impact
should be negligible. While at it, change VM_BUG_ON() to
VM_WARN_ON_ONCE_PAGE().

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: LLM
To: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/zpdesc.h   |  2 +-
 mm/zsmalloc.c | 24 ++++++------------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548d..4fd81c2e80769 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -26,8 +26,8 @@
  * with memcg_data.
  *
  * Page flags used:
- * * PG_private identifies the first component page.
  * * PG_locked is used by page migration code.
+ * The first component page has zpdesc->zspage->first_zpdesc == zpdesc
  */
 struct zpdesc {
 	unsigned long flags;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 11be37c431718..7ef80e0da6267 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -290,11 +290,6 @@ struct zs_pool {
 	atomic_t compaction_in_progress;
 };
 
-static inline void zpdesc_set_first(struct zpdesc *zpdesc)
-{
-	SetPagePrivate(zpdesc_page(zpdesc));
-}
-
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
 {
 	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
@@ -476,11 +471,6 @@ static void record_obj(unsigned long handle, unsigned long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
 
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
-{
-	return PagePrivate(zpdesc_page(zpdesc));
-}
-
 /* Protected by class->lock */
 static inline int get_zspage_inuse(struct zspage *zspage)
 {
@@ -496,7 +486,8 @@ static struct zpdesc *get_first_zpdesc(struct zspage *zspage)
 {
 	struct zpdesc *first_zpdesc = zspage->first_zpdesc;
 
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc));
+	/* the first zpdesc must point back to this zspage */
+	VM_WARN_ON_ONCE_PAGE(first_zpdesc->zspage != zspage, zpdesc_page(first_zpdesc));
 	return first_zpdesc;
 }
 
@@ -838,7 +829,8 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 	struct zspage *zspage = get_zspage(zpdesc);
 
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		/* only first zpdesc holds the handle */
+		VM_WARN_ON_ONCE_PAGE(zspage->first_zpdesc != zpdesc, zpdesc_page(zpdesc));
 		handle = zpdesc->handle;
 	} else
 		handle = *(unsigned long *)obj;
@@ -853,9 +845,6 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
 {
-	struct page *page = zpdesc_page(zpdesc);
-
-	ClearPagePrivate(page);
 	zpdesc->zspage = NULL;
 	zpdesc->next = NULL;
 	/* PageZsmalloc is sticky until the page is freed to the buddy. */
@@ -1006,8 +995,8 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 	 * 1. all pages are linked together using zpdesc->next
 	 * 2. each sub-page point to zspage using zpdesc->zspage
 	 *
-	 * we set PG_private to identify the first zpdesc (i.e. no other zpdesc
-	 * has this flag set).
+	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
+	 * other zpdesc has this set.
 	 */
 	for (i = 0; i < nr_zpdescs; i++) {
 		zpdesc = zpdescs[i];
@@ -1015,7 +1004,6 @@ static void create_page_chain(struct size_class *class, struct zspage *zspage,
 		zpdesc->next = NULL;
 		if (i == 0) {
 			zspage->first_zpdesc = zpdesc;
-			zpdesc_set_first(zpdesc);
 			if (unlikely(class->objs_per_zspage == 1 &&
 					class->pages_per_zspage == 1))
 				SetZsHugePage(zspage);

-- 
2.53.0


