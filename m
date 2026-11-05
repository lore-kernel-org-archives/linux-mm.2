Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD3A606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=L5mHv++v
Received: by kanga.kvack.org (Postfix)
	id 2FFBB6B05B0; Thu,  5 Nov 2026 09:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7266B05B1; Thu,  5 Nov 2026 09:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7216B05B2; Thu,  5 Nov 2026 09:19:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7A836B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:19:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F31A1A0A6A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:19:58 +0000 (UTC)
X-FDA: 85401274476.15.7DD0B1D
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023093.outbound.protection.outlook.com [40.107.159.93])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F2ECA000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:19:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=L5mHv++v;
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.159.93 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793888395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcqapZK4HikxcI6gUSn63l3r0+uMxP4pSS7qzcwvrgc=;
	b=AYJCaLENp549JyW+PMYQd8h5csTVhEjEdCjakDfwi4y3ua/11Wj3KwnS9/aCWIZWVEzbJ5
	FoIOi6W45+BwOnP6cdphID3uoT9sUSg5dURk+Z52vivSqn1TgcNNmbSwIUZb6uiJKi+x1J
	EsxMASNqUB/sB+ZmYmzbytO4XMn+tjI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793888395;
	b=jpzsbRWV27XS2MV0HPstUyEpySOiVElgg/jmmEqNSEH5G+NR5axk/Peywvu/IfmeK/Vhb+
	DyR1PVFX7Mg9LG/RHZXsBoPi1bX/TWrsWM6JHB33TQ3ZzA/9MDAitQF/dy729e4Ye4KK//
	blxcp5Ps7JdJhBiILqCUXhztKYqEnp4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=L5mHv++v;
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 40.107.159.93 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AQ43JB8HXBOi1oNitutTLBzPgSLHEX38J2R+I6YIUjRSnSdm5JeCwU6eU4b/3P/63uu+IWeUat+J+Yb0VE2Ut7J5I7eIck1pMlKOda551IW77nTbraqhjsifI9VD0Xf/OBT0sOi+nfAZvCed41XiXt2ALbdjBc/7QWvJdX1mS2e70sXb31WELi2LUXYMkIqJGAKmts88ClwWMCDeASZMRN1kNWCk+ZtZ40MSNWYMM4wBQmdUt+MBKsOaU17LlaaJPN4VQpbcYEQsHtykC0YxoWk7WI4OA6LohnEk4oG0iWcYOV3Kg1ak2hYSQILKGuUaQ7gelZvXS6Sh7GfC583TmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcqapZK4HikxcI6gUSn63l3r0+uMxP4pSS7qzcwvrgc=;
 b=WK+VTcbbedcRUThve3JZx5pGHGydWChRrGh5WHC3lR9hk65DLmBQUfdoX1OxPqvLSWp8JNObuo/EF37vgIKaivKvy8jprh8QarXtQ0uRiW4MG2Llvb4q1qHihkJ/PNl8Ur+j49yAQmb9euvxbRXZNstnt6UmpPZefYwGhbUUfFXmCCopNIIbWM6gTi97A3Z0xEaygrtmZzmW8mgoO2vOegkpCZEITS/SbyJPautCYTurQLUwwRKs20H60u5+jcRuT24nDTFlr3PwhjrreDcnKLv3QcQ9P3ZXwsG7EHAjDrBZC1PzrBLBi6o23A7KonvtkBEctlzHqCazbuoK8zFiNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcqapZK4HikxcI6gUSn63l3r0+uMxP4pSS7qzcwvrgc=;
 b=L5mHv++v4pI1hJ/DVKCCA8V+N1broE4hlzHpBVwG0IfHv9KQgKg98oUhk6etRdDFcBkRh6KfRV7IVs3MLmnWT4rmGsktd/NgCbPkP81Usy34e5KPqXxr6VcGla5ZJUO09XWPTjH2HyfrVcgYKelfsvgjvijaqawOmHgWgPJOArfDdQt5J8R2dZ559BzFjO/LW6T78Sgmj1V12dfNtWwv/44EaYbgS7SmHaegShCJVM9hjogmY1TVwJI5OoZQ//HMIuqdSovYXoWWw48WSU06Se+EIrsRSRt5kKMSe9LqmF2UdgoUPgwkQ4n9ttiFtSEqFVEbJF7BNld8WFtczx9K4w==
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by CPHPR08MB665563.eurprd08.prod.outlook.com (2603:10a6:380:107::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 14:19:50 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 14:19:50 +0000
Message-ID: <cfd786eb-4ae5-4dcc-a9f2-3eb4b7e7962c@virtuozzo.com>
Date: Thu, 5 Nov 2026 15:19:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: take a reference on a folio PUD
 copied by fork
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
 <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-1-8bd88551f9be@virtuozzo.com>
 <26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <26862633-c3d1-4b82-8ca2-346cb78570d7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::6) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|CPHPR08MB665563:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a638dd7-04eb-4f81-3449-08df3b47da40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|261022075727099003|4143699003|56012099006|261021121427099003|261026121527099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4mbVQP7szRDhTgt8QcFu8P7I1EWzjN8KQd0o3W5qre0yyz96y6Jm7uke0wRTAH0k9HOhJUx/GV9KDU2F+nIsoUDSnQFNQIhDVcUZX+VDPGNuSGVXZWhhbJrZHAe0cJwwXQC81HBMdYOinoUgCVZsfUM2kmvMEy+sbPBOTjkKklakhNV2furrpNuL+rDzSPLTM9L5n8nFamiQuwlTi8aHNwZNTpWmh0pWeQUtVi+GcIh9xJh/Na6tnoaD++3fL75fiZTwlHBRrV0aCuzr7Yd0MnPOcTdElnYnjqMR2tUEhlkLUDWHo9h1f20GFip4wtJTsX1U9EtW1ybfX1VFdPmP7yW7gi/T6cEH/pzqOdt7EHvsScLr/Bv0nQjo/CAGU4mkUPN3mrPUZae+Zgt2nufbtssGtargKGIvpWaBbHRmFVdxVM9CJqg5T/gDM+WeWL/uIH8yWZmAkbWCBbewPibKID6K7429LnLdA39jK5v7QdQcBA3pzLGD578imYk3ZyKvYcPD8E8bB6FI0VF5eXHgX1Rm/q9xrzNGgie9tdrDs3FhLvtygpLsBS4UYjG00Wn7rPaqm2qwOepZjua3E6B7UkAcGaz8ggRaGFlGP59/PGiZ5kW1OSGHRwUTTcQsGc84LhMpoCbfKzg6vX5UKQHjKAhRuGBdAnUQqok16sEPDko=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(261022075727099003)(4143699003)(56012099006)(261021121427099003)(261026121527099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTJQOWxKYWx4TVNhd0s1U3lERUU3ZjJsUCtTbkk1VWFIUWRXSXZSaURjeWNs?=
 =?utf-8?B?V3plWkhCb0p3ZTIyMmE3NTF5SktDODJpMEFkQjQzdGtvNlYzMTZaVnZaK3FX?=
 =?utf-8?B?ZklrNTdTNUhXKzlzOEE5Z2txcGFMalFFWk50ejJBaGFhSFhBL3A2M3ZvYXh1?=
 =?utf-8?B?Nk8yYnNPRlVrb016SFcrdHhheG1JUDFuc1BwbzE5S1VuUk5TWjdXZW52Y05O?=
 =?utf-8?B?eVZWd2pVSjZLV2VHcXpxVzRYKy81Z2V6VEo4Rk1Gc0xsNjFGZmd4b1F3d1Q5?=
 =?utf-8?B?SUJVUVBMN2pqYk9WTDFiZ3JnQjBaalJoZTQ2UVFrQUdUSlFhQm1IUHc2S2tL?=
 =?utf-8?B?MkM1ZCtzUFhGaFZrMjE1bk1zNi9zWVQ1MHRHOTR0OUFGN1ROMlMzbTdkSU82?=
 =?utf-8?B?K2ZYVERPREdXN1FpZEowZnZLNlBiK0hCZ2hkU0krNVRiUCsrM3BtbEFRWWVE?=
 =?utf-8?B?VW8zTW1TaVZwUnExbm5KRW5ycTBHUEVOd3V6aGh4OS9UVG9LN0dRc2IyeXpC?=
 =?utf-8?B?d24xbWxIS1JJK2xOZXJIa08zUDVnd1M1VVE3YnMzdDVsUWNibm1aMnF1eTJr?=
 =?utf-8?B?WVNkQnNwVmtTUjFicWltaUdVY2tYQ1NlWXdTMHdHcHB3ZENvMVJONWFWYlp3?=
 =?utf-8?B?NXlWMUp1dlRVaVNKNURpUFE2OVJrUnAwU0t6d1ZzeWJMMHMwR2tBVE5SSnE5?=
 =?utf-8?B?VTByeUx5NlFoZzk4VzBhdVNWaDZzMFBrQXpJWGpHL2xuTjJMTFJwOTZOSTFH?=
 =?utf-8?B?azJrdSttb2JVdHlDNEFHRGJmZE5mK0dhMFM4WTZ0RER6VlZrVFQ5aWlVZCtu?=
 =?utf-8?B?NEJqUmhSRjVyYjROQjdzaFkxTDhyYjd4UVZJVzZNSUFudU9MUC84ejRxc1JH?=
 =?utf-8?B?c2VCci9kYTNhcnZ2Q3BBUDV0MENMUEcwS0p2cjVSeXF1cTVIRzU1RldKa2tZ?=
 =?utf-8?B?TmtXMXNYNEd4V0oybnhZaHllaGJhYnhpencwR3N4UjlPZThQS2ZZc2dmTTVB?=
 =?utf-8?B?WVdLSnlNaW9ZeDIxN2tzd1lpTTUwTDVqSVpxeENHMWJuVlgzOGozRm41c2w0?=
 =?utf-8?B?NnN0MU02eUx2eld3dHNKL3NVNnVwN2FSTTkrbmdKYVc1dHhwQTI4aDBMQXcr?=
 =?utf-8?B?ZTI2bEhocXpFY0RoQm9KUWMyQy90TDdLSm4ySlF4RXhsb01yNzVBYitRYzlk?=
 =?utf-8?B?TzJmVHYrcGFqby9vUFdjMWFqQVpMT3pic3pSa0QrZWtLU0JEWjY3cXpBNHUr?=
 =?utf-8?B?c3FmT2lGd0FxWFptNnRrbHhoUjYzeTFlNGZiekxBc014OHBrMk1VTlNBS280?=
 =?utf-8?B?KzBOc2Y4Uy94T3FEanRyT3lkQjhYaDRzc25iTFd1WjIwUFE2dDZTUGUwUjJt?=
 =?utf-8?B?ZHFJeHR3dkZveko3T2tUZHRDOTBDeE9HWklWVTRNWTRzOXJ2OFcxS3ZGRTFq?=
 =?utf-8?B?YTBmOUZjUUlCek5WMEV4eURlb01mSFNUVGdWWk50NHFqd2J2bitKdVErcUJt?=
 =?utf-8?B?cEQzdmhXV0xIZFZueklWMkU0VnZGL01CZlhaVEVGaWlVMXVMQ3BJWlpmWEJS?=
 =?utf-8?B?eXg0U2laa28zVzNxRXlwSnpTYVF6NERGRWhXZTBKeVROdHY5NWE0dEVMdjIw?=
 =?utf-8?B?MkRmWk4rd0lDYk11RkkyZzQ0bEFydXdCa1B6clAzUm5HTkhuRFFhNDBxZUs3?=
 =?utf-8?B?VFZ3SFBhSHRiOWMvbXpESjkyeElXVS9oYXhWMTRQUzhFM3hsQmUxM3JzMVpz?=
 =?utf-8?B?alR2cDBJOXJKekpQSklpZnhKbENXTHVoTk9GQmxLLyt4MU5OaWZVUmQwVzZN?=
 =?utf-8?B?R1Rzb2NDN3RsMFdLL2J3cnB3RXF6R09SOVFERHVwNllyRlpocmRmNmRHUTBE?=
 =?utf-8?B?VUNTNVFvZG1xdkZtanZMTEtsQ08ycFNTb1JGb2hWQVMwZDgvZHhFcGR0VWhY?=
 =?utf-8?B?aVErYjY0aVljVUlQQ2s1NEM5WGZjMFMvbDMxejlhNURNcG52R0o1cWoxN2NX?=
 =?utf-8?B?bXlYRk9zUTBoNlZTNis1QkFleTNEMHVOM2cxV3RyS3BXUnBrN3MrcVZmUUNV?=
 =?utf-8?B?N3lZMktydC82d1JkSUFoSXlDQXJBMXRiaU1KdDNLOW52MU5QSHh2OUdSR004?=
 =?utf-8?B?VGZQYjJVdnNwSS82ZXBGWDYyei91N3pKSXJDQU8zQlRYbnVxM2pkR0Z0VEpj?=
 =?utf-8?B?TmJZMG1velhDYzEyem9WUUM0V1ZORUYyK1dhZllZNlR6RWJKcVRML0JPY2do?=
 =?utf-8?B?ZzlOa3o5bm5HWTNqMFRJZzdMeHdKdlVheHBhYlZ1d1cwckc1MVBYRzFTa0Zp?=
 =?utf-8?B?WnhmSVJoZG93UzZUMUZDb0hTK2M2eDRHaWluWGhwR2xoaEQ3QU12dz09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a638dd7-04eb-4f81-3449-08df3b47da40
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 14:19:50.1535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYODJbz8DWmpT6cGWkxXhZKnrkVu0i9DP5xd39hoz7zTB/NiovprwcZC9tLVvWKQOrot1j1zDABrIq58asOaAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CPHPR08MB665563
X-Rspamd-Server: rspam06
X-Stat-Signature: ofckgymxcw5z7og7sb9fap6gfnsb11a1
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7F2ECA000E
X-Rspam-User: 
X-HE-Tag: 1793888395-331357
X-HE-Meta: U2FsdGVkX184cNABnUi9S6ex3pVFtEUEZ8k4tkqjtkFebFMQ3s6aIzXRXVRuiZNGY+03wNrWHg/vuxgH01MNvadmBCAau/26+fAOmkz64Bq3rsY+uMWnKPh3W4QSaRQrwikH2u+HBNaA1Z6amyV91U7gNgY7t1nknznGhGaSMBZig/S1G+NCpy64tc156QBxSXsrQ2q11i/J60JByQwdG5oOEO19gwhwdf/v66TMvYZgxZtT8SAWaAwvs4xl1npeNatv3fCOzD2JQupR1+rj7geTF1nCBQBZ793pEfoHYW9sD4PT9jFOnD9BH1/4rv90i77X0C15fTPexX+HxhGBV/SoBZ/fbDE8bTtlOqpYxeZOtJLJdVXziQJpW/PobBacm2kFyXok6FUMxg53cQJp36O5pbgC3l6woVIWOSjG2d3mlZcSUj4mEqvvtS5KMs37SwYawuKQWER7Q4viUHYQo8roxK44e0HENOAuoM8IYeuO5ODpFAgH1IvKtP4ve/Z8f3GzcLS3t+w4jGJRFPiUihrNVWrsq8O5yq8vlNgi30yaLJEMyG+Qm46q2FD/sdPlq8biIZW0guriBFowU0BdxPrHRqDg1Gk6FucLuNOSg4nWLZnW4zK/Dw8XDMoVPgJ7fYe5aizcGqDxxEIJcByb/tPmDE4F0d9EpTav8mXGlJ4+E13WawPt4/MoBKYibQWhkglGfpNQpDI2jUyNX6dBLHsldCfyr6uJnEeKltc0z+udD1ejZfZYYeHLS5uiy0PwrLdP0if2jI+oTVk3uO4r1KlVUoGervbqfer18LdXnQkF6EQY37l3A+fLnzVM2aPK+G0bOlViXYG7EcbpWwqwwQZhT7aSDsL6b6BTQbuL+v+jzSJTHjKGiiRjf5MujgVfkf4GE6JFLr3TJyySSxVvC4nmfZ8wp2vYo3xjqV3Ka1G3SuI3Ms4SbG4P1x/VoDH2/+wUTSulSqSN/dywEBw
 xLdNrZax
 WIXg3WJ5yo8WXZKXU5chEHcRUHkQzA2tc8mf1rX7Mvy6RICk+I6stRTEEGudlSdfYmbuPgJ3qOc1xOe1+PZqHW8kQUmu7S4Gw9tnPr9OJ4A+jZ/0NEKTpbOcRvCQHtlDegN+FnCxIk0xpe0EJGU9L94PWKXzvITKgEWzi3CcRCUinEi2BF0hSBaxf8BQrO10SrgxcQvAkEQNdnKlm823edx3FYFgtSC+XonAP6M3U6I2Qs/kvf3ULILde4Fuugag/1p25ZzinLeS0yhmIm//TwwMWGjaBQsvUbUftEuRIx2L72K4FCFPphlMWBjOY9v9/Hp1YW7V9uaqXSnn1ZBX1MXZH+haz1KfSWWv3kbuVeviedGUTwYB9DBhVjZD1Y3FTIwU0JM1e8mC4UNGRC7kyffsYZYhKq0Gc0LaTHZJE9/ITOd2QExlCQbZGD0MKE1kzoMygDf97QnkUj0kYNaclD+zbz4c2eRLMR66S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Introducing folio_dup_file_rmap_pud() is better. But please see how I move
> the comment and how passing mm+vma to the helper is not really reasonable.

Thanks, agreed on both. v2 will pass only the VMAs, with the mms taken
from them as in your patch, drop src_mm from copy_pud_range() and move
the TODO next to the rmap duplication. folio_dup_file_rmap_pud() stays.

Could v2 then replace your 01/36, so you can drop it from your series?
I'd add your Suggested-by; if you prefer Co-developed-by with your
Signed-off-by from the patch above, I'll use that instead.

--
Best regards,
Konstantin Khorenko


