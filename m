Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E60C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85386B008A; Thu,  9 Jul 2026 14:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C006B0093; Thu,  9 Jul 2026 14:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78D76B008A; Thu,  9 Jul 2026 14:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870096B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7AE71A0266
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:58 +0000 (UTC)
X-FDA: 84970019316.04.DDD6A5A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011025.outbound.protection.outlook.com [52.101.62.25])
	by imf07.hostedemail.com (Postfix) with ESMTP id E19424000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:06:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rU8B1sHr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783620416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNUKrirlN9TE/uL1cfor167R3/9KLwyIVeM/e0HxDLg=;
	b=zAEmxJMiqgM8PTCC1naR7YR4zo28KyJru+Cj4bPFNyOaEOv0BhMWOfgOM+ItahBhDjLfxl
	NZsex3ZGly7w3ZU3WsPEgoIS8cYYV9PzQCgKpG+Z1UL14/El7FCX6RZS3ucFOGVmNg+ULm
	zGnpNv6iDttODXHkM0UhSKKqeQpjwQM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rU8B1sHr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783620416;
	b=bspcThD7nU9/+n2lnyW6ly0qArA3ce7bosNl3Kwp0XVVQzOfW2vwYPpt7q+/L3Ha7bwz/P
	pKFLsX0h4hs0FBSXWP1/V0sETt2oWtaQZYLJMWra5KH7RmQvQZFwEJOuPos/z7clEsLjXU
	tw1CKhssfLFnfOUXdVU1b8820XDJiKw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naB2UGAFIzXwdMVuvSk/ICYiE08JUBzZUAGBqIYIHRXur8KuSW0VlpeAsLajVcyeGqqqlZFPPBny6iCy66KlD+82Py//R/FXBajDbBr+nWtjPAeqSZQQrB3gThtCRpweKU5lpPshYmgkvD+5zfA7+R5MGc3zUJieS2JsAV5GJTUZ03/s6xgHv2CHj37vSZFOJaBzdAEc7hQK9eitGibYKSKoVZJek1oBinohyLV7vvfic31hT8qG6uP3I/Rvkri5ayYhwv1nYWgmuMTDMwIyuSo2E/Vd8V1UcV60jU+lHe0ICmxe2ZVmWmh/TnrelSBU+FUx4mrh3Y73fWDQmYkqbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNUKrirlN9TE/uL1cfor167R3/9KLwyIVeM/e0HxDLg=;
 b=PSAbheZTtAcq//CkLUoLBrMeXGUyq0xPb38o5bbQv7pu2hy7Rwfbr5rQm0YqOJtrZgpChU8HGKi30qI9pDdm9ci2blsdoMEbzpNK7Yby+tgtNuSc0DhMqSS9SAqSjm3r86rcDP3THNuSrvwKgjqDNGWIHvb2hUuQORCw9Hnixav4wyNWATepu5U7gCEar8P9kTDNZR8JSM17iZtSi4VNDZYCVI8TtkKUtlI1eDKBwrZoVjsCA6K3xcucj6ToZCThMa40LIqlB5XDRJ9UVXf2g9jYT1RZREBC8w8w1aQWyyqEww90ULhbNZniHRWWzjSpfD08Uu8ZydFNhS0RZnPuQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNUKrirlN9TE/uL1cfor167R3/9KLwyIVeM/e0HxDLg=;
 b=rU8B1sHrZ+px7a8+s7ZQkOis8/Vn5OwpM7YREbNWf7gNpZ+eCJogHuruCUnLOHQex6OcoB0UNqfOmdrGOLCJy5OdfuXb5QirqUMcLE4LPF0Z7eMyNGwGh0UQXay8NQlw2bP2Z5zSL4S6XWKbLG3B9B5rRsp8Da0Ip6rSUcqs40vsDsc3OqJtlWHwpTx+CovmRCy4HOXMs7Cxs/Sy/NE4X1ce6kXq+1IiP3sExX+Q54ancbbe90P/Kh9qcgW8wNLr4yraIQxkjZ5LMWHDByE0QPYn30q3BsBzrmquPi+VAchnWO7hDjcvMSdPmz9mbhMZsxIwriJC4Niczyrkkj2s4w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 18:06:47 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 18:06:47 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 14:06:01 -0400
Subject: [PATCH v3 1/5] mm/percpu-km: clear page->private before free them
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-keep-subpage-private-zero-at-free-v3-1-7e4fe155f5b9@nvidia.com>
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DS1PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:8:457::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 836fb610-9b05-4d1c-0eb0-08dedde4d743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|56012099006|11063799006|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	4YMxw+d8VZyOHh0k2FNqq1RmhzazHdxJKKWA4lWZyPkc4VG9bCOjj5y40iHXnL1xlUBmkk6ZbSVwSSnMOm+3OSYMVNB1tTv9LEH/2RwvOVHVk8w7BDfDTb0VkATdLlOAGMgNziLR4hqU4JE8GKA/PmWJ+mdzP8xBUT86T8d6jeBZWQZ88Mc/u6YM3byWKbCz8lqcb89BqTSQLQx6StxRHIbMgZ2vZWbgBS32Hd8EYeCAJada7z2PDWSvgGq76PwqGzEHp2OoFkphq44oHRv5xKKEoeSj7wmigeWMJEOMEVBXlPYCYMVLbat0Y6yF/5JTInpfJN19nLv5Orgpo+upcfWGM4sQcyqbtx+tRAHzcDxk+hV/2kR+ZRoZ6Bk+6ee8NP+BOItWGAhqprD9cXL4v20rbvd4YUmH7+CemYQz7t1HqGG88ePhCG7vz64t7sj88s/1Jrw3pJhCLBi3irbdpQpY0lXtTEa0PzKeVmPColMYvrh//Ecu2c20D6JekNEYjaIV6a9VjsFK+uBX4Hi+Bml1oXaYmRTeZsezQ/ZiYPE9QwnF5ItEIgUQEwnKlvSrSS3KBRYwwY4u/bCi4nQLREHnJ/xF/iUJvMyf//PYzGDGGseoB7jrlOFHbYPu2N+eIWNljzzWLiivZ6oeD2otwUlfWGQ+Z5FHhXAsakPxXOHVOEFH2Nxtni50ynl5OVgPt4RAEIIAbP4i0Z9cj1hF3w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHZSQTlETlRqLzR3a2VGN21xMzlMUFNXa0RMaDdkZTB6THhwdWp2WW0zUERF?=
 =?utf-8?B?cEpzaVBOTDJJeVN0STdNNWxGSE1VT0VoVEtWdGMwb253dXBKVVoxNDZaZ2Iy?=
 =?utf-8?B?TlNiNE5TLytwWlJtV2ROcU52WEdxZ2Q4OVgyVjVaVEVSNEVWZklra1NPcGph?=
 =?utf-8?B?ODBjWC9icndrYjZQUDlhKzlTTUE5VC9JZE1TYjc4SEhUcjZjQUZobFJZK2NJ?=
 =?utf-8?B?cUxIWFpVUi8rMWVtc1pNaGlYSzllbG04U1JKc0lSV3h6K0hUWFBnMGEvQmlt?=
 =?utf-8?B?Q04rRU9oUlZod25KbDRCOHNBaU56RUwyMXczV0JqYVRYRlV0UDFOL3E1eXBX?=
 =?utf-8?B?R0w5UlU3NDhBc2d2VkVCdmxkSzRqOU0wajE0NmM0MzZOSTNhVkR1dnBPYVNl?=
 =?utf-8?B?ZW9BdjBuODJENWJpbHRuUEsvc3d3RlkvV21pb2hNWk5wSzJ6UDVUOE5IbnB2?=
 =?utf-8?B?UlRqR05kb1hnUEgzeDhkTGJya0dRZ1kzSUY3cG8xdWs1RGVjNm1ER3ZETDJS?=
 =?utf-8?B?RTExZDV5dGZ6S2FieWRxdVFvbExqb1c0aXBTdFZ2blZhZHVwandlMXZ4QnZy?=
 =?utf-8?B?RkhERWhQaUpoeGVFam5WQ2NXOGNaUHhXR3hlR05QZ0hLdXVIZ05Yc0VNT0VJ?=
 =?utf-8?B?dmc4WHZRZ3lQdEpyLzZ2YVFFeDFBMHdFWUdscG5sZHl1MlU0cVpLRWlseVcw?=
 =?utf-8?B?NTlrMXgrbWJudkRlMkNZYnpSUXZxZ24zMEswVGhleDd1Vi85Wm94Ty8yVzh3?=
 =?utf-8?B?TmdUR2hkWCtQSktqUWtlZEN1RDRsenl5ZFNzN2JDUHpZVGJmODFwS2VRbC95?=
 =?utf-8?B?d3B3NFNNZWFpOEZpYXQ2VHV1ditCTm1iRjRIdi83UzY4Q3pEMmVhR0g2UytY?=
 =?utf-8?B?VnZKd2c5VGVieWZ3ekd0TndOYmpHZDQvOFdxUUw0S0lMN1pNUXRUcGNoSStM?=
 =?utf-8?B?QUg1TXJLaXQwOExLSkVFSUM1QUsyWEw2NHcwam83dmlXNFA0dEM1UUMvTzB5?=
 =?utf-8?B?RG9VdGcya1JwbFM1SHZBd1U3T1dIMnZ2WFZnOWpaTnIva3BvOHB5SkxhclVV?=
 =?utf-8?B?YTJUVnNzYXU0VlpOdUQrOWxWdW9yaWJBQXcvVk1yaVpRQUVHY1RKQVBUbDZC?=
 =?utf-8?B?cEIyTjRZZ21iSGpwSW9FcGRRLzBBSGNKYkhUalZkMWhBd05ZYkh5K3ZuYjdB?=
 =?utf-8?B?QUtsbEZZR1dPSVQ0RWZCTys1dThndGoybkdKL1VDOEN3b0dqaUdUUHVVbk1T?=
 =?utf-8?B?ZVdnWGZDR3hYdGpuTmhIR24vUGpBand3a1RPdTFOaEJZeUR2VTZEM1M4RHNw?=
 =?utf-8?B?Kzd2RFI3VzFmQVlHWFc2WTFheVIrZXNydVZPQzNQb1gyR3RTZXFXRmEweFJw?=
 =?utf-8?B?U3lVM2NIV3BFeTQ1ZGluTnkzL0JLVXNaVXNEeTdVNkM5RDJhUldVZHJHRVFa?=
 =?utf-8?B?NnhSMURiaENsbElnK2VTVkdFMm51b2NvbEYzQzgwSDJXQnJzaUw5SlVWaXor?=
 =?utf-8?B?TytLVFpKcVhBVC8wNWh2OXBHbFlJSEYzK3V6R2F2ZlhCTkkza2VVM2g2Mi9E?=
 =?utf-8?B?dk1xNU12SWdkZ25lSmVBMmhMWmpQOHV2V1o1M0FneERVajRuNEZOa2s2dHFh?=
 =?utf-8?B?Tjd4WWR1bXZ0V2tzZWR5bmJUcHlqWDRweDJEMDhCeDMrbnR6RTFLM1pZM1FE?=
 =?utf-8?B?ZHQzalA0SHYrVXRMUDUrM0JURTNvOVV6QzBpZFo1Z253SzV5QXROV0NaWnp2?=
 =?utf-8?B?M1QwbHd6cW5ycFE2dDdOTngwUWtpUllTcENyTjdsaG1mT2tTZHBsVWlZa1Fq?=
 =?utf-8?B?TWFLTlcyQUtXaXRSeEppbDgvZ1lPUFZGb1FUZ2VBakptVkRJMzV3dC9ncmhJ?=
 =?utf-8?B?ZFphdWlNUkN5aEQraS9uYW1QVG5xczY0L2pRRzhRM013U0RuQWRFZUZHQkhF?=
 =?utf-8?B?MTd5WUR6NXdHRzVaOEk5L21ta0pnT1lLRm1EbFFaV2xWTFBNczAvSTBScU1j?=
 =?utf-8?B?N2NpV0RRaDZiNDUzVFJ0NmtVaWU1cllwajl4cGlkZ3o4RXNydFR4TmQ5TG9G?=
 =?utf-8?B?NnpieFhmRWVjd3EwTVhRYW4ralAzZTl1aHJreDVCU0V5dmpqRDlGVEpwRlZh?=
 =?utf-8?B?TnZSVXFFaVlYb1hQcFcrUGtNbjZqajduampQbXNob2N2SmhuQkZacXBhTlVS?=
 =?utf-8?B?bTZ4VG4vTmxIZ2haZjdPbG9pbGpRbDRYeHUwWkl6YVFhN3VlOTFRVTNyMEpB?=
 =?utf-8?B?VnMxM1JlZ1dKb2VqRWRkRzR2dVFpR3JsUi9rNk1qZWZLc0R6c28wbkJ6cTgv?=
 =?utf-8?Q?XdChXMRTYPfNIRC10i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836fb610-9b05-4d1c-0eb0-08dedde4d743
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 18:06:46.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lC6sCMlPht1LPM02PuyNWdIWeWbfJFNgORDK8kJ96xcypa5z5ieq8f1iUwKyK42
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E19424000A
X-Stat-Signature: fuccj6qao7cidcqwdx4cw9ac3yx5u586
X-HE-Tag: 1783620415-788516
X-HE-Meta: U2FsdGVkX1+L/vqdEvprZjeq40HEAgetVC6Nrpg99fhBOFbhNubk3/MJM5k/iAsiwemiLx4VhQzM5B1BsMa5N9ICMFwzO+zo6NhsC9SP++WnNY3+RK8zCyVnWlF4siptYv9F+geiXwrpKhrWBdwuKaSThzabLZBStYs7aZikKzBsVTEabPDcmwCoVQNGPZyjfneaXx/u41LzE3DLFP7Ow/69huLJuXKAG42jWom1gzMbbq53TL60atbE4mdGFZCKz8s/PGRkDBP6Ieip4QhXmotcBFyFmTqQJtI54aVg70X9rEvHZTSPUhY58NE7dMn1TugOVp3dfmIj0o6a/4fXfaLSSDitywommGDNcfyCTNdiHbdiqUvMybIvq4fgI4MOyGtS0VrXsQZe64ZWSB6Ks2XzRVoya9YxhM1jOXnjp5iBFktb0O+tp1s8JdeUSh63mCRbSZLIF8Q6H/BZhQJk5ZfDLeDUfUOboWJbKpCd/NbsNjAo22UHVj+xzGhkMYLX/5ukNQ5ZonJSmc0gsWsOVFE/L4hW+Ikxlin7vfHkyYo1bBqUVTrKSWg921xQSHr+Gm7jH+vYIinKpN97lIV2uRf0nzf0g0aI/d5ly67hcwwq6MNLN03D1gcIO6ux6drtNmpOezFlYJx1fKhpu6TMcUkOkvledb9bDaNEOqwQqistIYP0+4bscDq9g29gCM0nkaBrIJiR49plZO/bKAvMaNQb0MvGJ+nJx6e1re/V0TsFNgNv14WuEGgao91wmkAxskAbzSR6dkxSL7W77odJUw62LffPkCTB3sqtwe3jAYbDb/PhdaOaYQTQwjqGPLi35l9hO7Nit+DhyuUVtqSq9Pj1BKqT3RgN4Hb+8c5ekH71Kg7E7pUHyq8QBjNyYie7mr0ggVqjcrJ+RZOpcJ3KL+e+pEE26OIpVqqHMko/7ED/zIYxNMnBRQ1Tx1MzJqNErUaVKEeIX4rSV39BFbi
 ZYv+Sfym
 r6dFB3dQ6Dc5Jeb1LKbj1cE5XmVRR1fVoI4pK09X54p9KkfyJK8wtRgVDCxQPAU2K8q361a9PjScIyzrt2Hkdjm4mC531OIUGf1/bh7BeumNYb92RU7kBPB3r0hqDRJrLeqvZb0tNVk9EPsh2fjwgiElAYpa2/m4XY0kreQ4RTUWmyt5RaDhKAP3u6eGBDlDLw7Hb/Bv/NbZq7xUZOF/4kH8rQtDybI5azuvYZdgFnHzFFglavWWO2NIvt4LJ7NJLhmXSwI6VfjAQl2bKaH78HpRr3y9GBmBK82RhX61i9cWo6OaGahYN8vFr63iedCKgDL+hIwjxYasUhuNhLZV5ok1ZLWXjyErIDeU8YWlbsuDruLGJoK9OWeBxkcHi/b7UOXTCz92P8wi8kNtVvwZbCk9Oz6O9cUVuDad+ILSmFULou+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->private is cleared in free page path. In a subsequent commit,
tail_page->private will be checked and ensured to be zero. Clearing
percpu-km allocated pages' ->private to prevent triggering warnings later,
namely undo what we did in pcpu_create_chunk().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/percpu-km.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 4efa74a495cb6..7ffe84adadb9d 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -94,8 +94,15 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 	pcpu_stats_chunk_dealloc();
 	trace_percpu_destroy_chunk(chunk->base_addr);
 
-	if (chunk->data)
+	if (chunk->data) {
+		struct page *pages = (struct page *)chunk->data;
+		int i;
+
+		/* clear chunk info from each page before free them */
+		for (i = 0; i < nr_pages; i++)
+			pcpu_set_page_chunk(pages + i, NULL);
 		__free_pages(chunk->data, order_base_2(nr_pages));
+	}
 	pcpu_free_chunk(chunk);
 }
 

-- 
2.53.0


