Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC6FC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823D66B007B; Mon, 27 Jul 2026 21:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDA76B008C; Mon, 27 Jul 2026 21:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DCE6B0093; Mon, 27 Jul 2026 21:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 281276B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:51:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82594C026B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:51:57 +0000 (UTC)
X-FDA: 85036509474.18.52D3208
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6D1314000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:51:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NRJP8x80;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785203514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h4k5FktSjeNuaqjL9f97sPGwiu3KoU8ombyBrAct9LY=;
	b=ataTw+pVilqu6j8sDBapbr4bCYTPuaz5+LZH6U7ZFUdc5AxWSurP/bvOdN2K9EcYreybAo
	4TwzbGuu3N6esaSkPnhl9rSsRKkm4gSrfJlJLNp9Sr/6iXdNL55h8xyiz8E7kaXyfK2fbW
	8Mjs3eyLMrzkuQWDystKRBlJxvHKBjs=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NRJP8x80;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785203514;
	b=62p1L+4zv+xLaMV+I2wkQepgmTQApC/kXPb+aRXUhsamy2EnKTg8ohLHVLKpjWaSBBZk4K
	cCu4SRs9uJZ0DXUmx0pKLm2+5WiW8MvGOlX4EdIUbA8oHVw9XqjnsCU0JCxIHAzdXxmiki
	4SshQrp/CgMDInzGKGCBq3cc+8mBymo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kKuzQCIv/RmJm2hfmne7ddehk0s1A4w5unUwkA/nBMwSYrlO4s0X2gEqWEB0BIg+N2IxrCrf/sm0gb+gzCjY4h41VYKgE+63fEf5sYuqo7BqpmHVY00afl6KLUZHfdkfzzpHwjAvc6bmy3WPlpepZF2qLi0zBMUgnwfSaLdpXviDgEK76rBxo8fUlgzvsRJyHYck93S2UpYXiHRqZrMRk7EiIHCXYLceeLONY1Ia1HDlGMNM9fc0KzDH5j4E7d/wKFwTgGpYIzeH87qK+uM+DBA3OSdPaGQ6hxJzIKaC1ULsQA+w4Ub+eEV0biaJAI63Im0sEplD4IVjznVRu4LLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4k5FktSjeNuaqjL9f97sPGwiu3KoU8ombyBrAct9LY=;
 b=HXh2nDF4q0B9fGdMuauY6hNmMLime8G3f58FzQ3TWBsMzavPO5s+2eR0sdMQ/0uN/NgcnV/vP6o4t1ujOeIfRatpMbYkoVHbCpADfo6nhvGvfcWZ2YQjMsfi8wbpXukThxyaDBtUt9Qkq9Y79HIcY6UhsIbeFisUZS8w4fwUja+K2rYGkf9Icr6HMshUFlMRoHJFhGHjFyBe60AVqnGLH9lx8zKlJlzjxl3EdfCsYeEisuwQKX9gSqzneakL+pKTqwkUHIMAJFOS+290jDlOHFanSja8rVxcCm421Iidc432DBldhgh6olIqRncdMJliSgK5BRS0IyN+mD3PGxEmoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4k5FktSjeNuaqjL9f97sPGwiu3KoU8ombyBrAct9LY=;
 b=NRJP8x80OnMRU+IYewfMzFUFTqIrYYVc5/nrNpqebmomNpe6kEgccN3BAE4sEC+rpCc+C/N8ru/gUGQEpwsbBcFsx7ww9KbY2x4GvIf0aMwCjT8GFKkoxh5n6I6247qk55xyKrM4PK1K3+U0I1kL+BVjG0lYRTi5XL3ot7ogw1JCkg06h11hYMuU8tYPLMoDva7JKjnh3Wg3LPj051uuR/sAZUDmghU2CjsWekmhEEvqmBbswXgY28aCh1Irwdv0xOlFYh6JabFlQ5Qc/+iVGZjLSNMWFyfCtQskP5m93Eq9L+drkDlzS5euvCtJtQyblP2OBfV6DCnVW958NaCGiA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9821.namprd12.prod.outlook.com (2603:10b6:8:270::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 01:51:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 01:51:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 27 Jul 2026 21:51:40 -0400
Subject: [PATCH RFC] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838@nvidia.com>
X-B4-Tracking: v=1; b=H4sIACsLaGoC/x3NQQrDIBBA0auEWXcgsaFKt4UeINsSZKImHRAVt
 SUQcvdKl2/z/wHFZXYF7t0B2X25cAwNw6UD86awOWTbDKIXt14KiWQtbmvSZEz8hIo14k5Fl+S
 5avI+GlRXGhajRrVICS2Uslt5/09eMD0fMJ/nDzSmQEZ5AAAA
X-Change-ID: 20260727-add-gfp_account-to-xas_split_alloc-83a1bc848b77
To: Johannes Weiner <hannes@cmpxchg.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BLAPR03CA0146.namprd03.prod.outlook.com
 (2603:10b6:208:32e::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9821:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b201d05-c7bc-4d9e-81c2-08deec4acac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mKdp92M5g4iH/sFOFPDk1lLTbdPJ/TcynzfyDcCy8T/2Xyn6zRrmWnG7eAGI+ruVEgvd3nzJ+IJhPaZn6Z+fdO0H+0808M7RmIC41ZIyNw40u5w6vm2aBKuPcbmAIZMKcl93xBrarHhL4SlHWKHU044WIivunYZDSBg+7+3Ic94tLYZNkWUrljhmauQ/ZZXbcIWdc88RpPxwYyR1G2ugOQ8m5dufoKLwN1SscLtQrO2Uob+XcJ7yjqBFuo3wLxcwZvmafM7bfYy8DXhquxdFiLNdLCGCBcy1pfKgelE5Rw6KcUnRDogC4U/kSaFgMklgXQ/PP7/8jTi1ISsKNuCv789UNXuVcrFBp6vJZVF3fSyLYPn0U7daSUE5tn8qwe9NgcWyceZb+1EpbEdFP8VEEpLCrSDsnXpYh2+rcdzFatJk76BPRXdEd6L/TQFMm9LFX9WcTFI1u8xbM/hgOWgw3xvVmaWO5qn/3KZAzHqMCVnmPGsuuOBBz7sVjM9U3G5OtP65f6xQzu6q7IOowA1Svqso4z5Z+1ZWL2yeJj7dqU6P0DMDm9wuJ3s7S4+leqoDANzf3Gyww1D8llLukzwgHNjdW54ZheUJW2EwtFFJZDLiHLTj+rmkA3HlU1p8KFC03lYQonHVN5hfaDtNjawBz3u6DpqoOjdNmNwkAia8ezs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eC9QVFNnMnBZS1Z4c0ZvSWJmUGZqTmRDVjExRXdXMnhITDFFZFVPNHcxNDdD?=
 =?utf-8?B?aEY1aXJsVU4yZkVpZnZEcVNobENuUjhiOGZ0NVMvTVRJV0R3MUFCZU9QYVd0?=
 =?utf-8?B?VzZJR3RtQ3plNjBKY2lrVm1HYWFtSXhYV29UUXY0TUJwRGwwMUpaTFpIUWlv?=
 =?utf-8?B?elJRRGE2ZDVrK0h2ZGdQYVZmM2hKLzhCQXJROERBeVNGd0U0Rk9kZkpQS1pv?=
 =?utf-8?B?MGJ6SEczeHArbndJWlJQZnhyV3NuTnUxNzI1c2dpUlEwNVhRMmtwd1lZY3JC?=
 =?utf-8?B?M2xCZCtWTll5UnVOS3pmZWY2Vi9sT3VNMHlydUliV3BjMlUyOXV5REpjcGRW?=
 =?utf-8?B?RFVERzFpUVZUYWM3YlI1VXFRV2pFMktkdDY1MnRCTndiV0htOEFkMHVnRjNW?=
 =?utf-8?B?QnVwNVVIV0tKZVAxRnZ6eFYvYUc1MGVURVFKTGFiWGx1V3AwdTg2N09JaFVh?=
 =?utf-8?B?Y0NZR3BkVzFJVFhBRlJuVXFPZkF3Qk4yZE53UFF3UW55NzhWeU4vWDlPenZN?=
 =?utf-8?B?cWpsdlBGRytMNWNaMGVqR3BySHBqQy9TMlRjR1FnYXA4Y0lnVmEyZzBJRTNu?=
 =?utf-8?B?ZitsTS9hbHp2U0IrRlNLSGx3TWIzeXJrR1AyNVB1Yzhyd0RnTnVVWjFNdlR5?=
 =?utf-8?B?clp5Q21mdWduWWZLOWFIQ3VLc0dFWUlHM2VOdEs2dEV6aFpzaE1nRkNDQnVE?=
 =?utf-8?B?SFlUVUNPYk1aelJPc1VRQmNDQmZlZ2pSd0RjSmhSWE43UUdiRG5CaVN2c3pU?=
 =?utf-8?B?M01SQytrcUR5R0pPWWVuVVc4V1FHQ3BYNTk3bitpZDcwOGpsa1V6N3BOc2Ri?=
 =?utf-8?B?L3k0K1VoQjZmYXhJZUEyOTgyNzhDc2luZWxHYzdyTkNQdXRESDZNSy9MKy8w?=
 =?utf-8?B?SStucWE2WlR1ZGpWWmsybkJPMkVsWDRDTFVLbFBSaUhvcGMyYWRHZnhKWG5G?=
 =?utf-8?B?OGh0UTR2K0crVjVFcDFCSFQxNlpCVlpUa3JsK3RYL0RTd2t2dkcvM2F4V1dE?=
 =?utf-8?B?a1lYazRRMFJtbGVYVGI2cWZJeUMxWWhRNHpqN2J1RFlXODFRQ0xTQ0RNQmYv?=
 =?utf-8?B?aWtlSDgyd1RmOHFIN1BVM0JpNkM3bDkrN244VmRsNHQyVTg3YUE5NVYxVnpz?=
 =?utf-8?B?MGt1dzV5TStQZVZHazlSNjlQbUNkUitncEpNV2hZZGxEc3lCQnNVMWZlYVBZ?=
 =?utf-8?B?UHdFV1g4OW9FN3RGNkxXeFBpdDFQaXRkRXFiRW1wcGRyRzByZ2lZRmhOTXVD?=
 =?utf-8?B?eHJ2bzZyN2JEdVZyQllyVlZUSkVnKzhKMXl2SHJkVnFuTjBVTWJFMWYxb2Z3?=
 =?utf-8?B?M2wvSXRwNWh0a2ZZUTd3NEVGeklxOVNVQ1l4UTBqOERocDRBWThVUmFtUmVs?=
 =?utf-8?B?OTdoWU1BSDl5QlNxK1Q1Y3pxemNMdXJDRXFIOVBlR0VMazYrL2ZYdURNaUJN?=
 =?utf-8?B?eHBzcFRvT2ZKOVlRb3RFQmZGV3dnQjViUDRYcXZtVG5LM2w3elhNZExhSGx6?=
 =?utf-8?B?U3JKVlluQzRsTEdhdS9DbWFFMWE2V081K1NqSGp2TUxuYVR4ZnRHQzNYL2wz?=
 =?utf-8?B?c0hCVVdsSjlocnVpcFBpTFNpZ0lzd3pHMk5BM1plRHZPSW1HYlppSDl2c2Fv?=
 =?utf-8?B?WmthRG5wRWJQVzcvVnluMGhhemtWSFdRKzBaRXNIZy9FZGdWOXZib1FxcTdT?=
 =?utf-8?B?SDJBZFlYdWVIbzRSRE95SGtUZlRUWktmamk0Q0hCUHVCMlp1alBqV0xiRnkv?=
 =?utf-8?B?UkZ0b1lubHBoTU5zTGJFTXJ3L3JhOVA4MW95YnNtYjJ4cTNscTVJa0JsN0ZD?=
 =?utf-8?B?MVdYaXhTeCtya1lDalNZMkorRGozcEQ0TmVnRTM0Z3hHZ3NvRnR3TktZTmcv?=
 =?utf-8?B?QmhCbG8rMEl4WHI3UFZEQlhVeE5ndmk0clp5RTdyYjJyeWNERFVsZDRhVFUx?=
 =?utf-8?B?RFdkOWQ5a0V5Rkk0cGJkWElub1lJZEUrTXNzNjhTZFBURzQ1N1czd2JzbzZL?=
 =?utf-8?B?Q2hMRlkzNEtjNWVWODU4ZGZQdHdlc2ZPVWdndmh1UFlLV1RveU01MVZtZXdX?=
 =?utf-8?B?TkltMDFBVXlDWURFT3h6SmxGM1lycndUc0VjczFtZkpQWmRYeEc5UUhPT1Z0?=
 =?utf-8?B?R255TUdtNEtlRGtLczkvSVBMaVNpVmlWVGF1ekl5Um5JSEJqQ0RIWU9ucU5h?=
 =?utf-8?B?ZGtDdFJWcmFEelNKR05PSDRJRFRyNE01WnpsaGV0M1ZJdkUxSFNXTCs2SkFl?=
 =?utf-8?B?NmMxNlNmTG1FUDdZNnRNd1QwYjUxUFJwMWJNTjdYRmpxUERkREsydFE2MjZ3?=
 =?utf-8?Q?Kw/QlIZlzAApXP0JCX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b201d05-c7bc-4d9e-81c2-08deec4acac5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 01:51:50.8122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ToiEESUlcEIWQ4oOsvv7SOWnyEA0TGn4gz8k0WllPuxZ1YXh/7D8N3F022thAr3S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9821
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6D1314000A
X-Stat-Signature: md8exxp341j9gjbthko4n6zy4zs4i86y
X-HE-Tag: 1785203514-573556
X-HE-Meta: U2FsdGVkX184dLvqH7PFAS9jpjpLEvwFKyiafYHfWtn81FLuhwIx8IH5utsAPEXHOCg4hqdmTqIAY3fnHKMIewWXydNrsCQpiFILUYaprDq9oqZ1U9yiZypK1W3j7TSvACt/urvH9AgItUu5FBTwo9n1Jj/JQfPpgSCAjYDjevcYKy4wC1ul3lQWIGcNz6yqmrHjaowbPEd8tcl5SOaYXBg4NXgLLUnvE+xB+z/YKPwA8KQY1AswgfxBmYlfBsswM7ItxYcN6kHN5RZZfURwP89anrOXv+yKSHf4uUycK/wh9yZydLjZ3IoSxZHHkish4Ag3EgVg8tQTdQoookH3xdsMSnvQamW1iKBi9zONltSDJuQPHhor8PaSCXnwAnISfqyiOn/dMHm8zNNyJL3dnBPlm4xzjTJ4TMl3t+ITvgpYbQLcLZrCUJo+nqf8HgRhEWZeV7gGGI2AOgIJvOpprDI88UsSw1rCDlFHhcH5v3gZUDdv2tVtlXevUNPRVyHa1ZMVzdvtR3Emqwyp2ncagR7mCs0YFntVYl0+C3DPxt6/VGGn4A9crUTUcDMNtqZoe5p/MyKEwsIYSLwPYsPv/HPf13Xtz4Xj2sETJxKBH6dXyaGs4Z4ZUat9LaKF6N4Qfgcf5GtyApRPOMXoRE5ofCa/jirLEqFFC12Ll8h1+F3Xh7r0ysw5FLJP/W9592j6ucnSxwdq3asW6KICzZitXzL7lM9EBzbr9KxnbxAREngbTAWfILQ4zf8sjOzFuE3dr3iu7P60A/tNd6csi7pP4za6JmzcL/1d2YUgmm0+NaqYwLI4VW8B25p9bHrjDUC6ernDn6rxvmPwNgsUhaLpTt16Uq/njRSnuHXL5A8saSHPE2ehsfDPWfmBdEw+jPwUWE4/mHcAxSD1M+ndZ+MfCegnYQEl1nqZyC+w2KrfhBs8QummmjtdU8KxQurIPemMatiBW68aEr40lY2y7zO
 GqOueLgl
 q3+8TIXsFBbUT58E1jjiswZ5a+08C9ZzySiZxpWFF3mA4MFblNRyDDZYXQecr3VyRPdpj+K5rcMoaA7HMvuHI/lOGfZO4l3VDmU8LfG52i0fW1YKXW2tVZR+b+jWXgJRqA+VMzjSAR8jb1miBXrJ/RKYVric1HjjB9MmE35qHBOSs5Uo7z8mfxfFhDFS/d5G6kC3D5Pf4l53FshnPu87GpITWWl/eDHwad4oKomyAdwlCrYN5QYVTUImZNTmyI3M58BOJBASBgU47ehA5QCPMcDYa/6uLgtflIZfMI5zH1CgTQxoWKKvbLfp8NM+L03RF6ZEbuYYl4xxkwFfvAbpH2xkiPoMcu6uszjb+FgNhHWY4lE9eRz4hsdqj8JXPLYFqmmcxiooncq4xyK5zOJ3BLeXMpWfuqrDgK3bEF2EVaZ5h2uda2qjop1Uw7mp2wO45/3wV+QlUTm4Z7IElmNkI/lp0vsqSUdoJ7Qd+0CMBgptmyEuxkPZWAK3giEcSuqNf4bnBHePIjslUQ0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

XArray operations that allocate xa_nodes, such as xas_nomem() and
xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
This charges the allocated memory and avoids the workingset convergence
issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
regression").

xas_split_alloc() does not have that flag. Add it when necessary.

Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Hi Johannes,

IIUC, __GFP_ACCOUNT is needed for xarray node allocation accounting when
XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
convergence regression") fixed a workingset regression with it.
xas_split_alloc() does not have it, so I imagine xa_node allocated during
folio split would cause a similar issue. I would like to get your
opinion on this.

Thanks.

This patch, if necessary, should be applied on top of the
mapping_set_update() fix[1] to avoid causing the same issue for uniform
split path.

Link: https://lore.kernel.org/all/20260725101419.3938406-1-matt@readmodwrite.com/ [1]
---
 lib/xarray.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540cf..bfe7bef80f34e 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1053,6 +1053,9 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 	if (xas->xa_shift + XA_CHUNK_SHIFT > order)
 		return;
 
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
 	do {
 		struct xa_node *node;
 

---
base-commit: 34cacd0ac7c10dc9e34e1b9f28a2b78d335cb487
change-id: 20260727-add-gfp_account-to-xas_split_alloc-83a1bc848b77

Best regards,
-- 
Yan, Zi


