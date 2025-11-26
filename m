Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F87D10379
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 04:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5EC6B000D; Tue, 25 Nov 2025 23:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57D8B6B0026; Tue, 25 Nov 2025 23:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445326B0027; Tue, 25 Nov 2025 23:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D95C6B000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 23:14:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC88BBA350
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:14:26 +0000 (UTC)
X-FDA: 84151441332.09.7477F92
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010049.outbound.protection.outlook.com [52.101.61.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 102BA140004
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:14:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GCD7X4WR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764130464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hewgjwhlCmQTHcuJzo7WNOCEilAQqNmmiSu4G1KFClc=;
	b=EzUjt2Mwe6CK8h67gySlmroft2eRQSsSYZXVVkgf9KFHak6pcHYoXu2N9pmai1OK3jXmbe
	hcTr5N5I/J8wEMrng/Pw0AszYHkw3pweL4kiiefyQ2l2WUgZWaa0yK1MlbxiGtoe+UgFIL
	nxt+YaS5p36/umDQDny3J/BfI6D28Mw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764130464; a=rsa-sha256;
	cv=pass;
	b=fIB6JmqEEYzDOISuXv1a6HEuUtXtEmlxyTL6UtVakaYo6NOzUyGb/ZM4kO4139rfBNCpqS
	ylRM9remxjrT+YIc85yDGk5D1UanFiTHJfoAtW+V2m+njF76MWOUOn695r/Pd5GfVSgeC9
	raDP9YHuigJO7JBxfV1HbvlcLWcIxiQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GCD7X4WR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFSEWagEE7VCejglj3Gzv7b9G5mF8Niv2f8ieV8TwFp7I5sGOe/rq2UsIQTNVJWk0ORqrbr2KKm6JZelmMe8rpub9HGHnVRVSVfUX+KYnuLls7PBn/O5xk2o6FaimzwfNxq13hE1ndbAXSvc10uAB9u2w+ci6T9/Q1y1Je6suo1f1LDXlS6q1JDcmbmsKUS2vcox61A0YMLfXi69SbRI88TLmsEabvawgjtK2OzappoJu7sTulwii6m6znbQYn/IeT07q+L9K1hS+IVhYIBKobQc9OHfziiCDbKqdYcp7SVPxm5t0rUiFHijnOjRZLNKiacL52zp0z+FEHcPR2aSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hewgjwhlCmQTHcuJzo7WNOCEilAQqNmmiSu4G1KFClc=;
 b=uCr81tpTvL0YCmlzpbgUBM2jrmV0cBDabqQk3bu6MEEYFryTsptaCAO2fY7kvY8PQYVqEtV3SKokKOBZ/JXyEFOUdiTPdVCVSQF1KjmJTZ2Ce5sHhw0YvSiPvaq49O89R/mcLbhnyQp/uGh+mZ2vsPKrX2WrO//jp/dZgDfA1pSOLgUSlxeAqIukEAgKfWCzSl1tdhYQ/Bs4yZRRTKavoENgydqJ5EBdLNzP2418n7X5+PcQ1R+a9lgtKjBB38GjOZt0s7T6GeSfJRVBKpUUj/f/URcYLmjEq7v3mKEFHkcdDOhGlaWo9cbwNTFkJDM4m4KicVEEkwcrNKkgkaHg+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hewgjwhlCmQTHcuJzo7WNOCEilAQqNmmiSu4G1KFClc=;
 b=GCD7X4WRjCNv/n7h2Vz+XqAeuPacdJawmpHPUXJbTv+03WuW37qy0W0YyfzwiEVTuc1CI4xDHJgwJ/0AuDEyd9flhpQsFpgZhIBk4aH+qhag+pnJ4nNDK+boah6a58RNLg8gUeeucZtIpxaGuWjvxpLWfUiZRZ96+QO07iNM1JpkEupE8AwFRT2JsClsYYxVWfrkIz5aVbjyq5SADaIICyRqdF5cZkDX0wvOGDtlrmnA5sMb3eApcwDfmzxCJSk/tEdAHk2axLGIpjKBwSU/fxUVfn1SBHiEUyo0fJIUAaMgWHpzyKK6SgrxDxm5TKQDvrDrJDkHaZkPhKnm+f6seQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 04:14:21 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 04:14:20 +0000
Message-ID: <e545a153-bca2-47fd-a768-dc310977de15@nvidia.com>
Date: Wed, 26 Nov 2025 15:14:15 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm/huge_memory: change folio_split_supported() to
 folio_check_splittable()
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-2-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251126035008.1919461-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0026.namprd10.prod.outlook.com
 (2603:10b6:a03:255::31) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH2PR12MB4214:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b64e13f-06e6-4432-250d-08de2ca24628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Umd3eEQyZVJNVmFXK3BCY0dLTDF6M0xleGdINlVGVyt1YkhtV2RueHRaWFNV?=
 =?utf-8?B?VUk1alAzVndza2FzbEdRRW4zY1lORkdYTE9NNnYvbWVITzcwOHJrV0Nrankr?=
 =?utf-8?B?QStSRnBLdVVWMEJYdUd6SzFpek5WenZmVTNJRVZsV1pkRzhad2FpbHY0TXRF?=
 =?utf-8?B?VXB0OVFNRUNRcUl1NXN6RlkwTXhKKzFzMVFhc2lBTW1CN1VaTG1zRUZKNHhO?=
 =?utf-8?B?c3FoU3N4UVJyZ0w1OEEzMERDV3NJNEMvSFc1UFFsQXZFVzZLQ3hFRmhHMmwv?=
 =?utf-8?B?T0pmczYrQnJocTBCTU9ZWTNNRHV0c0NqVklwaDNpVlJZbjgzMDZsbFM2T3Nn?=
 =?utf-8?B?QVU0bEpuYXZ2bkc0a2JVZEdaM3MxZE1heVVLL1piWFdtNlpocU9vVUJ2WU5l?=
 =?utf-8?B?UkJFTjZQMlhtbU9HZDNMNXhibGJwcHNwQi85YjgyUFdMREJTTDcrV2xZVWgx?=
 =?utf-8?B?V0hvUTdOdFRsL3NDWG4rSHFSTW9IRU1xd3FnK29DNHJ4RXFwYVBRS3R1cFI4?=
 =?utf-8?B?SnNRV1B0djFwSlJnZWlSS0FyUUpPUUl5YnIwTTNPTGpoaXNMbGZTTXJkMDFv?=
 =?utf-8?B?T3NvN29aQUhMeU5veFFRZGdFOS9WR0FVdmNhcFdlbTVWdTgrZGp6ZERvb013?=
 =?utf-8?B?M1J4TTZjZEdrbW8xY0R4NEpzRzlTVUtoa0l5aDg5QVVGMG5NcnQrc2ZzUFQz?=
 =?utf-8?B?NmplVUh6UmFJRzhnVmV1S1FrZ2Jmcm1ZclYrVGN1eDNMVVhRT3JRRFp4QzNo?=
 =?utf-8?B?a3pGdUV5SytkZ3lDd0UyZER4aUJkbHgzOVpQNEU0SVVOUGxyYkJhWnVPRlFR?=
 =?utf-8?B?ZnFwcU42NFRoaTVjVWl0YzVMZEd4d0FQKzlaSGdTcjAxMnVmNW0xYXlPYWc0?=
 =?utf-8?B?bzM4MFlWUy9abkN5cEJtVUZRMWs5L3g1bVNCQzQrdjVWd2dHWGpjVWpLTThP?=
 =?utf-8?B?aVM2RjBjdWhrQXV4elNnSmFxQjFyWlBtaWw0ZmFPdVA1NjdwRFRpY2pFNEJ2?=
 =?utf-8?B?cXJKcHQ4dXZ3aUIxTDNGZHByV29uYm1QMGIwRHRGNmJXWWd4dEoyRjdhNWtw?=
 =?utf-8?B?UmVPWE9Wa2FBZ0VMOTduc0Jua1NhSmtHMnhqT0Y4eVFMandBYUh6VGtOd2Yw?=
 =?utf-8?B?KzRVSkJrY25WSkZzN2g1NXVvRlNOaU9DMDUvNjlkVk96VGVQWkZmQ3FzR3lB?=
 =?utf-8?B?V1RQRGRvdFNzQXpQZS9CMXcydlN1YUVMeW9yZVA4b0dGRVk4Y0FONzBVYytE?=
 =?utf-8?B?NloxOHZXWVZ5Tk8wbzBjem5mdnVCRE5xTEUvZUtRUDNkcXNtOGZFMmlJZ2F3?=
 =?utf-8?B?OGJXcDkxOVhJVHdUdTR2aExPYjZuTURrRWM0WDZMK3ZreXpRcml2a3lnNkV0?=
 =?utf-8?B?a29IaVB1a2V6UERTY2FCdkFIbjdQZE9KOTJUTVdDT0k2elljem5ZdXAwczhN?=
 =?utf-8?B?UnFmTGh3b0RTR2VEN0ZnblVJUWJGNGx4MDdkTS9ZV082dzJpalZLWnRZUS9N?=
 =?utf-8?B?eEtEcVlnUDl0NEdNMWRWRWtYR1pSMi9TYXcva3FBc2ROUjRRQ3M0S1l6QkxR?=
 =?utf-8?B?OGlFdWRzMGpqbmVmSGRwK0ZRMmZIbUFRSDhiMERsYVFJNksxeVJlODQ3QTBq?=
 =?utf-8?B?U3hWdmFjMkJnQXpCTE9OMUJxdHpkd3dSUUEzTlFoVFJjL1JqYml2dWd2dXpK?=
 =?utf-8?B?emhDM1EvVHpmUVA4dks0QUluTk43a0ZURnBKcG5pbnVPZ0pIRTZuS0JXZXly?=
 =?utf-8?B?blRhRi9LTEc5bkZ6NkJwM2doRE5XUFBQREdIS3piWG1KbldKUlZKY2hBdnlU?=
 =?utf-8?B?a2lhUWdYMy9OMjRZME9VZ0puVEpXNVJqWkZpSjNKWmJQajFwL1IzOVFZWUxB?=
 =?utf-8?B?NXBQZC9rMExTKzRvOUdJajNjUlVpUkdsMVBtZktETDV0VkYvZmtJcWlxWWxR?=
 =?utf-8?Q?xOixkdtEv6YTXEMLz692NGGlzOSnGnzO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjlhUFF1ZHA0MUsyWHFKdjlWVU52R1FTdnMxUTdOaXEvTFhLTFp4OHNJNXh3?=
 =?utf-8?B?cWp6ek5HclNCTmk5UUVyb2dQWEVnTEsyTlI0WEdSb1pLTmFiN2tueDg1Ym5s?=
 =?utf-8?B?NStpd1hsOE5BN3Z1elFHZWF6Ti9BTE9wTGNOTFlrL0dqVWc5a1B2aTY0Q0lR?=
 =?utf-8?B?dnJBSmhIUmFRWHdOcFJhb1NyL202Rmk0QVZ6SVdNYjI5YytNQ2JDY1hRSVZR?=
 =?utf-8?B?aVBNV3YvUWJKNUM3UmRDY1R3clQ1bWdYbjNBcjRhSHc5VUZ5WkxtUHV4TVdL?=
 =?utf-8?B?WjVKYlk2N0tHTStGQzk3QkpXcTJVclplbk5pMEVsRnlOdnk1L2pZZUNwYjBi?=
 =?utf-8?B?K3hrcDYvbjVkaVlCYXM4KzVDUjVxNTcvQzkzeHNES09uUDF3ZjEwSG1OZmlt?=
 =?utf-8?B?amp2cWJWdVlhczRYNi9XTnRTdjRhRlVmeU9TdDN5b1pxd3N4eWljNjJxWjJG?=
 =?utf-8?B?SU1mWXI5cTdaUGtwOG5NaTlNM2FQa1dxeHYwMXE3cnBRTEJWUThtcEQ3VjQ0?=
 =?utf-8?B?RFlLRWhnamkwSzhuQUJVemNXY0Q2bTJxaGFlYmk2ZzZuaUdUUEhCVGxLWlZu?=
 =?utf-8?B?VjlDbFN5WGhRdzhjdDYyWWpzeW81cWpyM1dETjB3ZlFnTTk0dEh5aS9jMEVi?=
 =?utf-8?B?TTJ0T2Y0L2RWWDZTUkNDenhOSEN0dWdJUVQrb00xb2xIQVhyY0pSUHArV3Vq?=
 =?utf-8?B?Z3ZmN2JaQnhPSkFRRUN1RmV1ZE9mblVDYlh0dG01QUZ6RG9tT1VCSE9CbjVr?=
 =?utf-8?B?ajVRdXNCWFVweDA5V244MjNmUDRuK1J3R1lBTW9xbDFTa00xSHU4RktTRDI3?=
 =?utf-8?B?M0MxVHRrUzVhbnROd0ZPRWpVTk12Z0RaZmpTQlRkTVh4dzNvZW1La2NwdkxC?=
 =?utf-8?B?ZVZhNnpGa1QxdGN3VTFRRGYrMm13NFczbXp5d3ZaNktocUMzYXM5YmdicUpT?=
 =?utf-8?B?cE1QK1YrQzd5L2wyOFI3YTZ0enJPd1FHdTI1RjRuTTVwTDNLYU9wbEtkMW1U?=
 =?utf-8?B?ZFJuNU43Tis5Uk03VDBLNUhZRjl0UVFGTXkzS1d2SGhKNGVnS1hSbi9zUno3?=
 =?utf-8?B?ZGtQZVJtTExHaVFTSXkyZjNSL2hrK0lmenhkd3Axa0E5NnA3T1pYeVc4clJm?=
 =?utf-8?B?ZStCSlpuSXpKS0JXWVhRMENlb1hQRUV3Wk5ZamR1Q1dxc3ZGb1loaFJ4OHVl?=
 =?utf-8?B?VmhGMjlFN28zZWNCa2d6TGxFNFNHUDJwV3VSTXpvWmxSa3JHMXFBb2kvOERk?=
 =?utf-8?B?N2hudUxEa0RzQUUxTjZmVlJxblNzcjlZSDZEMTZvako0T1lJM2Uwa1c4U09w?=
 =?utf-8?B?UkZlUWRMR3Q3MHJacURhTy9vM3lYRTYvSjVwdWNJaXNlb29lREs5aUw0Yi9j?=
 =?utf-8?B?djRMZ3pNMFNvSGxNSnBCRG5RSm8xcmNSUFhEUWRyK1B4K29kNFlldVpxZ3py?=
 =?utf-8?B?WDdBZks2Q3BHUXAwMCtJNTR2R0RpbDlqYVg4aVFvVmtZcGtaSlEvN3MzdzNB?=
 =?utf-8?B?TFVvMlhEUDZoamlDYktxQldlOHZUZ2ZuNFhROUhsckJrMXY5QWh0VGlxR0dB?=
 =?utf-8?B?Z1M3UzJJQ2hMdFQ1MTNYczZqT0p1bDVmY0k0bWRzanVMeWVpajRQanZpL2Vy?=
 =?utf-8?B?K2RIaG1aZUxYMU9QZFNTTjJyOFZBZ2pmcjVGU01RazF3R1RPR0JhdWlWMCtE?=
 =?utf-8?B?Y3l4T05BOHFyeXJSTEVUZHZ5OXcyWTI5L1Z5YURpbERUTFNRaCt5UGt4WHp6?=
 =?utf-8?B?ZEFRT3QrOVYyM2VzSjYyalJ4M2JycUNDUE1LWnlYR1N4L1pRNWFlNTkrcjRa?=
 =?utf-8?B?L3hweFNmN2ZmZU0wd1VDMWhtQUlkelYvZC9OYlkzUVRteGVxWW1vUERDRGpG?=
 =?utf-8?B?RWV2RVdDVTNFcHZ4Zi9yQy9GSXhXN0M5TmtaRTNDNWFTdTVSaWRKNTQ2M3hG?=
 =?utf-8?B?RElrWjJ3WjdPNExiUnkzY0N5bTF6emdxcDlMa01xTEorS1JDbVg3R21mNVZu?=
 =?utf-8?B?TUNCQ3laL2RhNmRoVDZ1bGJ0RXhhZVFuNlE4NVJCeDN2bUZEVXJnSE0vVXJN?=
 =?utf-8?B?b3FVcVV3Zm5TR3pVUEwxeFR2SHJqSWV1UXlrOVFFVDhNaUtqamxtNENBZzAw?=
 =?utf-8?B?eEJ0a2VpcW5Yb05ITUNONHNVRVB1V3lYQlNNUER0ZzIvWXZYdzgzdUZYMjJa?=
 =?utf-8?Q?S6yBz/zMIsNtUErnp1k+21B+ZzH2Bf9Y/x1k+n68ODyI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b64e13f-06e6-4432-250d-08de2ca24628
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 04:14:20.7704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utS/LJCr1lhnz9ToZ35aEKsw+S0EqxdRS3xweb6K8GFg2GGVAxTk2IbKbDO5UMKA20JUJ6lTCbU+W7gg30yFiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 102BA140004
X-Stat-Signature: 4on8qd6gi7ghtx45zgy9e6abkp3f4y8p
X-HE-Tag: 1764130463-362680
X-HE-Meta: U2FsdGVkX19FKGNQvRO6bzPtUU1ICQDa0fDkdsBmFH+k31asSAAsZpOOJ61E26QPKSwFHEPcPW2N8ioX+xmiUhWBG8ZBWUHFvKDv50783hIMmSILbIb1r1yxLggTVrpHxkJ1KVjnK88hKuQXYYabYwCqhturTU5JklrnNtzuoqubmPomPiHFOr7TnNLD7ibPfhZfjWARxziI38eFCs1wYfSvnoflAOWvqdLstpTx2tAt1fo+xos9JGivBJXNXpXKTogSwIxTssONpSIAF3L6LLb3Lwa6v1P+Xk3txj405pEekg687/JZdNvsuPMqqmT1itvAzS6HqR6DHjZzId6xxaYt5626oif566hxORTt3P1YdBFHvY+CwbKoUUByruCATPpsQewNN3aTvLWe2l9ggMZB8wvAzVKFFXkDri3Tc6YT20Qwx7MSFYBv9I32kypl3/begmKsgMxnFR+wQWNgvYGlBOPAc3JllcHzzQjoNRvYKPTWxvIIFYauTn120V6rE1D5c/Uo7FSCppU0GBYDMHODr6JueiiPSnwVsMaFoSMO42nXnqHhKiLc6a/sLr43nwq8TKFskioM8DOvaeULaRxZlQ82+DPwS4fbkeIEAVdRivuh150z56pjA3C83RdHx0VKzHTZYEBGLnQEqez8iqzZ/zuGygcGX16RrxYZ5jHN8z7TkbFhUkV9Li1biHJTwqjM0mgVqwq6moLnycfSgbUcZpXXKzqVLqKexTyLfYY2F4IDlB++Z9/8SpwQRkezdDc8RzC6BKldGc+TPocYLW4+4Eo7bTvfLn3DsWK5KB+0Jz5/kq1dHsE2PD25rskS5x0h7UHWoUEmwNyk+/NZCq8oMlUiH+/QZayoNuoi22/nor/g/5I9RVc/88KG3i6kmfBPTs5xiF6WlFkEBCZRzdwWWNUjwsn9wVIO7jddRLTjn/6DlgyO954YZWSyAAC9dPY3vEDKsIm23ENMKJs
 ZOVSiXmy
 jdfRdfo2UyxSNw5ZMY2V6bVsyyoW6CBDzBvUZQIAIECnhjICsUAXP9ZDiVWJQETYzqF4+Fp5htStnyyrG3wzfONT9CxwXt6AfysVDo7BLw0/WnBVsyF35NC/Gh/6AlJ/uXUqowTwsDoQx3iuGPHyETQTG9r0PYbun3Juo/RlmYZU+AnvhAsE7xbN2VSVBFzCgOGDudYGX0NbrDS7Q9Jrpm2zQFQVW6BI1/BP8F14U/301sckNPpsetv+8Gr7gXViQCRue44EmYIK1AaCMdI7kQuQXMpDVBj3qLzzZEu2/d2iYqt7nDj4zbFzmc4olngaKHZUh9QfyeXvx7ux3WBjG7Tzi7lDatkBuZB5wX+tZhRDANB1SA/vUFZgUbcFbxz9UHdCl0OfcwYQLSN6JX0r6LNjtNuW+nfMDtckFo2QD7d7q9iFiv4AkKHmO26WRjnVWOIDRhOmh+bFl/bmHd2OSggg5qhAx+vrfd14ZVSoQjMmQW1nVE8O70XCHIfcxkom5ZuWJWHEwG3SwrqDmsaMhPJJPlwqDE03jxSJASdMc7t/UCYCHWynkoIi0j5ujc/MjIosEzv4DB5xIQ+I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 14:50, Zi Yan wrote:
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() does
> not check it. There is no issue in the current code, since
> try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
> where folio->mapping is not NULL.
> 
> To prevent future misuse, move folio->mapping NULL check (i.e., folio is
> truncated) into folio_split_supported(). Since folio->mapping NULL check
> returns -EBUSY and folio_split_supported() == false means -EINVAL, change
> folio_split_supported() return type from bool to int and return error
> numbers accordingly. Rename folio_split_supported() to
> folio_check_splittable() to match the return type change.
> 
> While at it, move is_huge_zero_folio() check and folio_test_writeback()
> check into folio_check_splittable() and add kernel-doc.
> 
> Remove all warnings inside folio_check_splittable() and give warnings
> in __folio_split() instead, so that bool warns parameter can be removed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  include/linux/huge_mm.h |  6 ++--
>  mm/huge_memory.c        | 76 +++++++++++++++++++++++------------------
>  2 files changed, 46 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1d439de1ca2c..66105a90b4c3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
> -		enum split_type split_type, bool warns);
> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> +			   enum split_type split_type);
>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>  		struct list_head *list);
>  
> @@ -407,7 +407,7 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>  static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
>  {
> -	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
> +	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
>  		return split_huge_page_to_order(&folio->page, new_order);
>  	return folio_split(folio, new_order, page, NULL);
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 041b554c7115..771df0c02a4a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3688,15 +3688,40 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	return 0;
>  }
>  
> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
> -		enum split_type split_type, bool warns)
> +/**
> + * folio_check_splittable() - check if a folio can be split to a given order
> + * @folio: folio to be split
> + * @new_order: the smallest order of the after split folios (since buddy
> + *             allocator like split generates folios with orders from @folio's
> + *             order - 1 to new_order).
> + * @split_type: uniform or non-uniform split
> + *
> + * folio_check_splittable() checks if @folio can be split to @new_order using
> + * @split_type method. The truncated folio check must come first.
> + *
> + * Context: folio must be locked.
> + *
> + * Return: 0 - @folio can be split to @new_order, otherwise an error number is
> + * returned.
> + */
> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> +			   enum split_type split_type)
>  {
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +	/*
> +	 * Folios that just got truncated cannot get split. Signal to the
> +	 * caller that there was a race.
> +	 *
> +	 * TODO: this will also currently refuse folios without a mapping in the
> +	 * swapcache (shmem or to-be-anon folios).
> +	 */
> +	if (!folio_test_anon(folio) && !folio->mapping)
> +		return -EBUSY;
> +

Nit: Shouldn't the order of check be 

if (!folio->mapping && !folio_test_anon(folio))

works better if folio->mapping is NULL


>  	if (folio_test_anon(folio)) {
>  		/* order-1 is not supported for anonymous THP. */
> -		VM_WARN_ONCE(warns && new_order == 1,
> -				"Cannot split to order-1 folio");
>  		if (new_order == 1)
> -			return false;
> +			return -EINVAL;
>  	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>  		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>  		    !mapping_large_folio_support(folio->mapping)) {
> @@ -3717,9 +3742,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>  			 * case, the mapping does not actually support large
>  			 * folios properly.
>  			 */
> -			VM_WARN_ONCE(warns,
> -				"Cannot split file folio to non-0 order");
> -			return false;
> +			return -EINVAL;
>  		}
>  	}
>  
> @@ -3732,12 +3755,16 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>  	 * here.
>  	 */
>  	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
> -		VM_WARN_ONCE(warns,
> -			"Cannot split swapcache folio to non-0 order");
> -		return false;
> +		return -EINVAL;
>  	}
>  
> -	return true;
> +	if (is_huge_zero_folio(folio))
> +		return -EINVAL;
> +
> +	if (folio_test_writeback(folio))
> +		return -EBUSY;
> +
> +	return 0;
>  }
>  
>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
> @@ -3922,7 +3949,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	int remap_flags = 0;
>  	int extra_pins, ret;
>  	pgoff_t end = 0;
> -	bool is_hzp;
>  
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> @@ -3930,31 +3956,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
>  		return -EINVAL;
>  
> -	/*
> -	 * Folios that just got truncated cannot get split. Signal to the
> -	 * caller that there was a race.
> -	 *
> -	 * TODO: this will also currently refuse shmem folios that are in the
> -	 * swapcache.
> -	 */
> -	if (!is_anon && !folio->mapping)
> -		return -EBUSY;
> -
>  	if (new_order >= old_order)
>  		return -EINVAL;
>  
> -	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
> -		return -EINVAL;
> -
> -	is_hzp = is_huge_zero_folio(folio);
> -	if (is_hzp) {
> -		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
> -		return -EBUSY;
> +	ret = folio_check_splittable(folio, new_order, split_type);
> +	if (ret) {
> +		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
> +		return ret;
>  	}
>  
> -	if (folio_test_writeback(folio))
> -		return -EBUSY;
> -
>  	if (is_anon) {
>  		/*
>  		 * The caller does not necessarily hold an mmap_lock that would

Otherwise,looks good!

Acked-by: Balbir Singh <balbirs@nvidia.com>

