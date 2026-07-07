Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CF1C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F6C6B00A1; Tue,  7 Jul 2026 16:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837826B00A2; Tue,  7 Jul 2026 16:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DA96B00A5; Tue,  7 Jul 2026 16:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9966B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:45:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A48C2120594
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:45:09 +0000 (UTC)
X-FDA: 84963160338.01.2B264E9
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012066.outbound.protection.outlook.com [40.107.200.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id C2D54140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:45:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RH9hAm3N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXL1u5/kg/AxNcKHQYIlMsLtsra6NunYjdrctcy1FZc=;
	b=UdrJ8Sj7vjyprrezu+NProdqGKm47uM5y2rxW/2WQn2bh2x3cHGPi17krOGPE1q0m35J9R
	2DIGcL02UBo4KlsAPc/gQnDy/slKa8Mgf+rhrez3NxzMdBst0GfGvu55ylK9KWmYQjrMcc
	cD8NI6dWWKoOTyTglAY3T0+WHm8a9vs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RH9hAm3N;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783457106;
	b=yV8ldSZZyT4x9z//T3epY/KMJdr31HiTdYbLfztL6OWpebU/M5mNk944fExQvXr49gRlHO
	YFoNjkTmKcS7CQpvIf3bmpijQOKPJt9sJUMT4TuyoVKHJuHXFOfw4BfsJ6A48C/B1CpyP1
	sBv/609BhQabDWnLGc6Pq4Jqy7BUCck=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n3TFRBSEFs9F4CFyQabczioQ+DNnOSny+jqEGbwpS9CadZ2SGuM4Po4B8qZdFv1j7cbxl6McA3ghFAwudvS05JT0WnQ7hnlrbx9/fglECgixvA+3+OMlNbAoqFM6SoulNC5tNZ52dmARl57UPCU/k4X4CGzaQMZUiL4qjQmAT9beDoP2134YsplyXm6FmphWLLiADEliF3S529pyGeXCy3YhSqtahRpTFy44YNGv1jrYB7W2zMRnC5xzeKYBYvvqZIqTJ51wt6xkiGl0gkONZn6RsTyarg+gh5zD0l6UpOqgwEARw01yw/9Yoars5xNEt3gc0Q1VuwAGjR2Bu2i7ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXL1u5/kg/AxNcKHQYIlMsLtsra6NunYjdrctcy1FZc=;
 b=YZ0QnbnvAZCUE0qS6UXc25enj1ud1rWjgYOxxr/AAsaJrdBBpEYOMba0QenuJ915ZPW9R3AtChHxELvPJLbULsX96YHEjWijzfxudXM0BdVXGmOvP+7QRSn+7fEAZtLy87yUhbiB7zvS/RG2h7nq9MtdvcwJBBH8L0lJs+sxw2S8PKWzPboTxKWsxCd/HJBbt3WyUmtz2+YZ4eclI25x052SzLfX11aYb2w/wVq+BC1szAKcd1i8Z34BVteUicnOdAfwgjWuy+5+2/W2AFCEpWTW0+VTvTKaTgXzplZCjElLhfSUS5cG6rTTvFMDa92BI6hjWVm5xZhbd0ySfKN2yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXL1u5/kg/AxNcKHQYIlMsLtsra6NunYjdrctcy1FZc=;
 b=RH9hAm3Nuk4mCt75aw8ja1VcEDgJgC6RWqxTq0dIn2LxHWMBIajCfS6AFFUCYy5zPW5Yj6jzYjw/ulIFdKCMZWoVULj3L26tpzQONeiKjTmAV7hdtwT+rah01Izyy39xnY2pKBF7/OhjP77Ddazh+/xj9YYTigG39u+GK48vEUC2awl5K8Kow+SPaKBJP60fDybNXClJ6cj+/MuH3gApfwfsBzI2FFgsNmpMNK4xTfrtOktqmh9hKi7gXHO073ash/H9wb/XqGdmaVuA1A32liHHShQVl30rU9tpOW3C3VyEWBBOB6JAsAqxQKUbyth+JrW+Zqj8QHf6dPQfjsEnaw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4471.namprd12.prod.outlook.com (2603:10b6:208:26f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 7 Jul
 2026 20:44:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 20:44:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 16:44:21 -0400
Message-Id: <DJSMRJ60ZX1Q.3UGPY8IDVKXW3@nvidia.com>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <apopple@nvidia.com>, <baohua@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <byungchul@sk.com>, <david@kernel.org>,
 <dev.jain@arm.com>, <gourry@gourry.net>, <jannh@google.com>,
 <joshua.hahnjy@gmail.com>, <lance.yang@linux.dev>, <liam@infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
 <matthew.brost@intel.com>, <npache@redhat.com>, <rakie.kim@sk.com>,
 <ryan.roberts@arm.com>, <vbabka@kernel.org>,
 <ying.huang@linux.alibaba.com>, <shakeel.butt@linux.dev>,
 <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 3/3] mm/huge_memory: skip device-private PMDs in
 madvise_free_huge_pmd
X-Mailer: aerc 0.21.0
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-4-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-4-usama.arif@linux.dev>
X-ClientProxiedBy: BN9PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:408:fd::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: e4d6ad32-173b-468d-7c12-08dedc689c6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|4143699003|6133799003|22082099003|18002099003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	LFtvEnXvg9COZr4leK5p3nJ02nBISeGws0GZ9zJQS3MAbr9hHCkyF/y/tM9I7VjL5Q55wtKT8E+CMcDuZhvhcs9cvMZpwJ+Xk7LjDw25kROOo/mixA1ArJFavMXgdJNCmq2paApiCziyilHfqjuJQ/bNGMAAiRXK8puLSuxP/mcVvjr7ekvjR1suS0CSeRFXQxZEdb4XKzOhdq4YX1JT0twpbWyBsJ5wP8E5s/lKIO7bwG4kDoJ9RlveAcKs58HcpdHeUAtRzBBOtpLOJkNEjS97wv0qElet840LAetBWQzQjG3Dpkf0Av4sdNXqFREgrvvYxiiSlOfVE169uITGSJ4CYzebEN9Sm3pcOc/2E++YYFs7Ldorp2TAycIKSuuBh1vkwzLxSA9loKs8BZ0bDAT8g0VZFCwKHQ7+Zw7RymkiQBhEpmNJ6yI1GnqVSYiZE4md8j5jnBdiQ404vcyhJ02/iHMje3X5vQ9TSO/rgfwrfwkXNjt9EBCpIG0dQi6YZaAEjI8NZ88mpOhdrszlmHyvxnFLzzJVADZk2JzR/9G8CW7t1Pfa3M3qvA3PWag5ZOWs01UWbxxTbn/mx3fBdj9oSWaqWkU1O2HPpl1EyKrkRGeM8fi+Hx7Xp8hPHBaFDtuD2hHwba9Umchgf/cvIJ2oOvOpOIVQKREr/G21rVYFAxm5iaAaoqAkSTPB50MVHLDLmgRFLTp0fSo8GASIOw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(4143699003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEltdjFRVjNTSGFpZTNBR0QrV2NrK3VoRnV5Y2MxaWxNRmh2UFU0QWhrYnEx?=
 =?utf-8?B?RHR0VWdhQy82WExPWVFaSDdjMWV4eWxHVm51dXp0YzNmdkpWVDZ2am5pRlVK?=
 =?utf-8?B?SGNrTDdrNG5yRzlxeGVzQnBxTnNmaVpKN1RnYjZVbUI5NElPZmZ0bDZzYTQw?=
 =?utf-8?B?TnRPa3ZBS1MwaWZ3aE1xaU1LR2VsWVhkdEhBbHN3blBkcnhtUnRIQ3M4QTN6?=
 =?utf-8?B?SXlGK0RxSEh4V3JMM0JhOUJKVDgwMGZlY1N5NEMySGlTUG83L09ZZ0prTVR6?=
 =?utf-8?B?U1M4eHd5U2xsVUI5dFhzY05zY0dha3dUZFNVb29EbVdRcnZDWU5FNVhDS0pz?=
 =?utf-8?B?U1ZHRkRmRzVEV1lZWC9ULzdRUTIzMUZqWVBpRnVXRlA4OXZMZCtrK2o3YUZB?=
 =?utf-8?B?alRMd2V3V0ZJMXdhM2hqY3J3REFnSndaUVYwbUo4aHg2cGlrZ3Q1akY0SFVh?=
 =?utf-8?B?UnpxVUdJRzBTQlBSbDdiQWxhQUNSK3puWWoveGJSVWNSdDNudm8yMDVjd2NI?=
 =?utf-8?B?bERqSFZhM2JEVjl0TG9RUi9KNE5IeWZLalg2SGNBM2J6bEM3YUUvMTlWNmFq?=
 =?utf-8?B?aVNBclJFOGRNR2ZZejVvZk11OTE0K2lQczlocGZQVkRtRjhXUWJXRFFxNVNS?=
 =?utf-8?B?TFVtWXIwZnQ2bXlTKytDNVg5S01xRU43ZHFlcnlNdm5teXQyQW5CMTNaMkJP?=
 =?utf-8?B?K2pnUmd3UTA5Y0dvZXR5RjduVk1zWjRTVXVWQnRKS0RzNklQT21IQ05yWTlC?=
 =?utf-8?B?NEhiZWlCVHFMbGpOcVZZeXlTRlVWOUxmVXI5cHB5cXcrcUFaNUpYZm9NRkg2?=
 =?utf-8?B?ajNIR0hRbFkzWFFaTkFBTzZnWVJMTEdzRWpPL053MCtQVHpVOS80VndYY2dm?=
 =?utf-8?B?cEpjYWRFUHZZYlJqaTNlYU1ZZDJiakNnWE5jNkdwUFBncDBvT0phQlVqbEJ2?=
 =?utf-8?B?a2dIUXNhTXdTMitXVFJBQ2YydzVlYWE0L0hQcExGT3FUNE9TZy9lYjVySFlR?=
 =?utf-8?B?cExxNjRGRDRpTnNrVTBDM0QvWHhJOWh6aWxGK1BOMVozM3J0ZVRmL1pGdzhV?=
 =?utf-8?B?bk9VNDJ4NG0rWnd0QTh5RUhyRDcxNG5BcDhvVW1RSldiZkZjMjI3cFN6SVBJ?=
 =?utf-8?B?UE5BWXkyV2NTeHNhSG9rd1REMnlQNThEQ2E1cUJMdk0yWndxMGdzTXRDQ2VJ?=
 =?utf-8?B?UWcvT2gySFpOYlNadnB3eE04M0V4eDBWRXRyZW1VcERuajlROFZ2L1ZIZHhK?=
 =?utf-8?B?ajlrUk8yRXIrQXNiaWhGUlR5Z2RkUXNaZ3VUWjlGOXVLUGFkWERINmtwem1E?=
 =?utf-8?B?VWUwaXNQRGJ6YldFeWFEUG9YUC9tWUt2S1JVSjlyQjJQUTJqQmNPNngraE1W?=
 =?utf-8?B?SHFTRitDcEJrYm1LS0Nab3ZRUTEzWmNxaURDTWpRaWpNdmFwQUVjZDZrekx0?=
 =?utf-8?B?akMyaUpGbUkxRGpDZmthdk5lbWREbFNobjhpZFJjai81YStyZ3NsVm15Q3A4?=
 =?utf-8?B?S2tmWmtuQmZHOVJDTUlCK2tGaWNrbWN3WEF2ZlBJc2o3TmJUSTVOQjZwZmVF?=
 =?utf-8?B?MzBjMnN1VWZYTmxCSC9LaVhJbmtHQmxWUHg3aGxzaE1IbGRUS2JuZ1NjYWJE?=
 =?utf-8?B?UHplc2E1OTVNUFdCYlBDb3NKNWVKNndmQmhIZHdEQ1B6d3B2bENJS3ZtQ1FM?=
 =?utf-8?B?MDRvcnI2c3ROaDEyb3VjT01nKyt0YWRWL3dsajNNQUt0Mm5BbUNWcm55aUFV?=
 =?utf-8?B?Y0VRTDdkMEcxU0V6enBDc1Q5ckFqQ2ZzTGdhNy9oS2YvdERmbmNtTnVua3lo?=
 =?utf-8?B?MHVRQ2lacFBBazRpRm93K2d2N1NZamxGZnVpMzFxS3hvdEdTM3QvOUJsWjd3?=
 =?utf-8?B?Z2VMR2hmczUyL1ZNTTJzb1crVTY2S3lEZnFZNUpEV0xhN1R0UGpEMFVmaTh1?=
 =?utf-8?B?MGNoNlU4NGdNdWk0MkpWUFNTdnhIMUM0ZHc2cTN3ZDZBQXphSWl4SG5hSkhG?=
 =?utf-8?B?ejNERldzN2JCMW95RU41bXlOY292Yk5KLy96NEUvWEQ3Yzk2Q08wbzZvRUJp?=
 =?utf-8?B?K0VkV3FrUzVDbXRZU1liVXVpbnRQSXJLaDB2SEtzMVpKZ25xQkJtNTRqSTk2?=
 =?utf-8?B?TXB5ditqOXFuQ2lKOUxudmFUZkliZ09lV0Y2eWRWbjFLTTVnbEU5UzBKaExY?=
 =?utf-8?B?QUNmcDBWRHF2K1RyUkZ3WndGSnhmQkxGd3FaUC8xc1dGaTZ6WjRlbjlGeHY4?=
 =?utf-8?B?ZXpTLzFoWW1DWURHZWFQWnJMRFY5YkNoWkE1VnhabU81ekxKL0tCWW9vUDJt?=
 =?utf-8?Q?SpOcuv+mX65bESzWMj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d6ad32-173b-468d-7c12-08dedc689c6c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 20:44:59.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwthVtp4LMLxdLK36aCODpkLW603ssFNzKnIgx3LvS1gw02P0KGSbBpkjdNDos2s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4471
X-Rspamd-Queue-Id: C2D54140009
X-Stat-Signature: ghgk15scrjwoeufhj6duhsnrkjctue46
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783457106-228738
X-HE-Meta: U2FsdGVkX1+dI6VZXI9tJrKm13b7SzhdX1GC01zyMI1JNoBE6u83utxhjs1So7qLen4nqH0JoC7A3sm7CrlDD37VZro4/5SnR2d3CakxNQv+Tqgs0Oho7skl6k/u1J69AO+k8xYPIDpmqaECmcBLNVSsKRnE1GxjsJ3ARC78hR0DLrct/Q2K/XvEynHIOGMo+6Yjio6RaVUo6Tv5g2H+dAF+d2WyUuN7FD7DLybAN23gL+jPsUnLabK937+vutnDdaayZmJwJzzdiZz/pn9vzL9aL94YRbvcA1onMHFCnq/oZzhbOS5zL8p/4FsAoSrNLXAQFv5rfHDM5fO8serpiQRj36/Tl7v8gH3gygoqTnr7jf67OJFvxBeKYrdQ8jiql6GzZoLMYufxmP/Sy2pH/DrVVqIXkdZ+Olyts9Un80NvDTDiUq3WS6EBdp8K7uVyRLXf3ys7hjVn8FuZ33nvwgHJ+pH9MWOF5PcBeq+m7X6Y6q7qcM/38aGywiJok0/1sauwaSyubSW2TNgmI7MJI+jObfgZuwHuCBe6Nw2UiTGaq7hf5HaMw5AUq1qhDZzxcmc4sVI+HFpdYZl4H0cPSC1BO+j2i5U6+d1CHfUmCCuq3euJ68yiO07CbD+kHOeCfcyqJXlYdLuyQ/M2Mv2wbzABPr7klYiVC6/TLPGrDVqvlu08MP7ycQRdS5FIsIgjli0GILLEKsuHHho5mT7wEsSrxpJBvRGePeDONlVLfw8ypDmg58m6HwJA1xEEivFKs5dz99hJjElE7G/EystLlWZcR3PuRQMlY1WICHqxfglA7+SwA8NwQANXVKNNLzuvWTSpyXXPqUgjxXd3J0UVNesJz8gfOZFoT/8fGhzI8JmwQmuCLJekLjvW/R14hf7z0u61TATdbtMQfO9DFew23Jmtf/I25mJntGqe909x5xCiaSjdiknPtmXCSS1Mrovf47qYo0EItY/SDmopa+p
 ncd8emVG
 tKnpy15pThoFveQVc9xxD3JRw7NWJ2KSdw2SOoIuLQO553upncupK5rfzJyQSRxAJuRlp9BLNL01AWPR6tXEt/bnsBjSmu2g+Q2WMqw0HKluO0wx+RehCfgF64XyjrqUvNNekRPoKvTR+JrrQbY41hIePqZNeEgI7o1cM+w/1SkFIzrSnPOH8NgHK7NoLfUVorU1vvEg7NKjndwu21pl+jDn6IQStoPqs5JMymu7cwA/R5Ork39I5GL2P+wicbn4Oht1X8klV6o4tbGVgG87/XH/Yz4IOJFSSJcgniaLKAowFCidVsEM1/2NFYR6HUGwLnL9HT07A01lAtneHsB4nyaCgDRZfEO7z2IEs+QeyH88nFWASwWOUmFNv47H7+mT/wD4hkxQYXchZI63Mb65n0B/p6YPCp4MNAzGcmLTQ1piQKghZIfKS/BCiqdOY7sQjIOXW91+QyqIYwPFvn7V5qNDP0OCgwlmxOK5XMq4j7WthNz3t+pc//YnzhFZ9eQLUhh32FXyC826dT1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 9:45 AM EDT, Usama Arif wrote:
> madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
> madvise_free_huge_pmd() takes pmd_trans_huge_lock().
> pmd_is_huge() returns true for a device-private PMD, so orig_pmd can
> be device-private and hit the VM_BUG_ON() on the !pmd_present() branch.
>
> Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
> migrate_vma_pages() flips the PMD to a device-private entry between the
> caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().
>
> Skip device-private PMDs after taking the lock, before the
> !pmd_present() check.
>
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to P=
MD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
LGTM. cc stable as well.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


