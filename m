Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B7CC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6096B009D; Tue,  7 Jul 2026 11:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D646B009E; Tue,  7 Jul 2026 11:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93606B009F; Tue,  7 Jul 2026 11:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859106B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:32:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B8541A0459
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:32:00 +0000 (UTC)
X-FDA: 84962371200.01.7074DA3
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C86C1C000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:31:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mGXYGkr/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUSVuu04d1UHHCO6mD8QgOitHOC/dJhbS7YPoSCXAN4=;
	b=ZE4HRPAVuCJNGZJh30J3v9XO8wEkZ4sDM6p60La5XGzMBqbmbqPrNz2E5oNmaxClbp4Cjs
	xLYxFgwy5xP/fK94DgAp+ZaEgl80EjmN9rRFBcPglqPwK8i2Hj02L40bg9O3LvRybU8Di7
	gW7x+Z8OYE5Ogku9fLcqxUHZGLh2Fv8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="mGXYGkr/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.11 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783438317;
	b=lrb2tSndeYh76E0Dw4unZcDszJ0ujkjNd+GsIuCmsE/17fl463t1FX2PMK8hBwcrRKZc+H
	8Sa6E6ZWjD2IXeOBbrP8bfkUL+mNko/S6qVut/3ifM3CQudC0SiGNEgBIFTZ3vF6C/7zr2
	UBKcx/uXnJ5YDF+m9iBrfzZSJxJCmlU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uBaB1ZSAr84JxB6I44WZaev/HWIdNtNY98uLW+lWHtKl4KiOD6+GSTyQ8PErU/k7I92IxSgoS2i1Ew/c3svpWUY5QW59IkRRFlmJsd++m4ZYHMYlh9Q0yg8y2R56w1zRW5G6pbo+2HLbBDgZ9qKpbm1koQj3ufLddsmgq4kB+oRgxPP0Du+52UQIcjeEvtz9S0fAuuZgSPi3WOuQ8Euh6SUK4jGTNpkaB5v+1y9I8lWinDLQllPmZSRbr/otwvzPNagWcxkefaCdQcTd5NHfgpTkvd2A37EkVYd0cEek/zt0P8wGbwq9eSq5bJqSaX03xCM31G2gYTIJ/DW+KJjK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUSVuu04d1UHHCO6mD8QgOitHOC/dJhbS7YPoSCXAN4=;
 b=Dw6Iw3G+PSLoCV5+QM3CjX/hpe0/MtVtH8gE8Fk5qiiQKiLQizY83aV+p7BnhBDkJl3Wk7aJUjqkCZRwqjTyDk84LTu2AIFT6A1cnmvZiDWaM2NTQ9Vup+3jzjnBcvmw3WW1c27XpznzniaQLMnYJQ/bVt31jp3MuSjbM/QjgThnjMuoI5O6SeyQ53xx5oMyxCwQilHUf/m7a0ZQamF6zQikGtfnV6F1k4+6Z4EUVQNPi9ezPyVrAzwoSqPID1pYpUVwDBsdLPGha5dw0Nhg5TupNgxSIE9khvjptvjt4hxw9eNhkREaZL6G/XCV4w8pPmPMo06PaPe/EmJ6ofkTMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUSVuu04d1UHHCO6mD8QgOitHOC/dJhbS7YPoSCXAN4=;
 b=mGXYGkr/ZMbww+nrE3av/i346eB8nSAVHcV46oAfQYKHjx5ey1vnPcfbRXLiX+SHN2K6aQE4TOyXnYGC+qy1tVeOsWi7qViZlGqRrvXlnx1maA9JVdprKXoeHQo/sa3IY9VpiD9uFgHb7Gd+Oa+0t+bH7Rwqsy80O/GtyAV2SdwQRby9pbO1QxDRsYK+pPTQX4xqXT5UsG2TkJnB2X3n/AcUIZeUtj65JRCDMUCx9aibdKPC9vDwhCJvsD7QopNvU9Tpp1s/w33rmJfs8uA6yHoB0bRupFEVJZtdvI8Plhu7Ad6wJ5lAtzkflPOZ0tCnWA/6xJzlkBRb+V64zeoLYw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9080.namprd12.prod.outlook.com (2603:10b6:610:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 15:31:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 15:31:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 1/4] mm/page_owner: add print_mode filter
Date: Tue, 07 Jul 2026 11:31:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <117481D7-EF95-4123-BAD9-F9D24D1C94F2@nvidia.com>
In-Reply-To: <670931b2-7d9d-4e37-a410-a2e7d85cfdd4@kernel.org>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-2-zhen.ni@easystack.cn>
 <670931b2-7d9d-4e37-a410-a2e7d85cfdd4@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9080:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b50c65-5f7c-4ee4-91a7-08dedc3cde48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|56012099006|11063799006|4143699003|6133799003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info:
	qY7emXsEzqOaYdwGtFedh5s8I/AxUDo7jvyOnTGVa/Hz60j6/pvvhhHaDhe+AyY7QEyIo3sV2VkmcT2MCICZt8ccUNwua5EVTKuVbNIns1/WN5wep4YsjyY6AmSO0p6z3O+NHXfkvZ18x4Gg4DIu+9ucqDwr9JEuynOkN4lPZhW5/sqif+R+Rr0Ni6SxGKxYA7OR2L+oQydhp8iEc5Dqly9wU46BeYbHVJPnT5EAP8296wHNu88HaWTPGcFirvFjwo/60mWIWXDa/kriei8DwQi2NFDSe7V+Gm9QDD04PMFUpa69+Ewnr9diMEU1excg8urD0s3enc21C53JIgghtBq+OfsxylCPV+R0c7aHjEkIWmnlXLiTxISqryjS6YFM+XYzTgB1gilWQSTxtkC40BQV5zE57ETkKyBuzzbmVWPrTMvVucLMz+ieELz3xUWY2NV3s2XrpMGCpWnrOMvgdNF7me+nBETo6jAKyCxjs66HMv/pdog2BvrAVUnc7s2TwwhWGnzwtMugD3wWkYLtPbrVt4PzoLX0r6VS0PLNId2DYqKgfLDc2d+gh1DaYpoVVbmc26qdC2sAuHtzCDy1VrpH5RU+Wc1NdkBxj8y7ZzMujdq1nFC3eixKXsEfT9WurvFyd+lR4IASbmCWBu3M4+tKh8miI3ogezz2fwll41g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(4143699003)(6133799003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QZV1yl2QT6zpesxiRteW4t/+sZOhqEdeO1NPnHZnzxwri6lobAQsCdvzXvGR?=
 =?us-ascii?Q?Ct9ysQl5ffbloOil5o0r9ApLv60abWIObxrqlK58tZK/bB6s8fMNTEBBBhiP?=
 =?us-ascii?Q?IQvpm9/+vMARDq3f/x56/Zisj1BpK/6oBH2xRAmKHDNXmPZ3hUAHTgsRbndo?=
 =?us-ascii?Q?R774naoJalvov5+8Z5aR6UqdkqC+NbKYoqEspcsTqoxl0kSKIWd/FWdRhLUM?=
 =?us-ascii?Q?CklEgZo0hplUtofbFtoes9xG7Lqze2pG5Lk06sRrX1L/9iazMwg9ZuewAtoL?=
 =?us-ascii?Q?gVbpJLikl4IhhqCiXzbUCg/SmduCosZGeRyXYA6Kw1gxlsUO4zgi+uY8wmki?=
 =?us-ascii?Q?66I1YyC9fmt3hFK3ylFm0USCQZyfTqGdNfEyY9wg0WUHfoHJr0mq1Y8KrGzw?=
 =?us-ascii?Q?9CsmsAUSfUL4I0uFXXS0SCCayK1/8FVU86f+GDV4To1s7TQgCbUsYbn7Vo8b?=
 =?us-ascii?Q?HxyrnFEdeFbaWAe56YpiWJpiGjPrK3Ax4Wtuo1Yb5PwmzW3grbVMPJufzuSD?=
 =?us-ascii?Q?M9qnqnbh5076Iu1E1joyfdxooAnJcuDOyyvDVDw5wmvv0TBGzj4J6SdVE7+S?=
 =?us-ascii?Q?Rz/b82XhqHOtNRK9QnKPFmbKzm/4bOZME7P0WPK+sOr9UcxLFFmCYKJt5NY2?=
 =?us-ascii?Q?IyJbwzQU8CyUC5bMsxBeQX9g4zkInd00pJCf8O+0LaljTiGrtSF2yFzUu3IO?=
 =?us-ascii?Q?rQjhpaUP4rnbKFK1B0b1efz+gHGS86qiSkw3ZQ/+EcZhilgcpaynaokcjAXf?=
 =?us-ascii?Q?1zSWHPGC0vVaZQAqcQ5PbUoarnCF//3nWmHkuUDw5owaNJ+Z21L1XzPV0R+O?=
 =?us-ascii?Q?zU+SsMOl9gI5Gxl37fas+QPIzHZXKPkIjMJ+PtEohp4hobeHltbS4CJfnW1d?=
 =?us-ascii?Q?moF0dtyN/GJ/soc0ihME1fpg6Xela6QQzdftz2eJvRmNrwSF6ZTotp+N293k?=
 =?us-ascii?Q?IuZQMNZ4QPM0mtmjWCW+U/Q2B1iTwcfw1OS9hVEQPw8HM/XK60112AWXfvEP?=
 =?us-ascii?Q?Te6XRFMB1l/vU4EirzCjCds1JzoHx76FdGudCznvYAple2cHmLlu5qj2FAQO?=
 =?us-ascii?Q?gVRGiynUxWZhzGi7fe3pLXa1Vkg7WXhI9xxLwEOPJGXmJz9K6va4cRor6mJJ?=
 =?us-ascii?Q?MTLIr/36lHez84NFstIGCvj0GUOQ3ABEOH0X5Bv0/VzcL8cK6LshQyg+Pk3v?=
 =?us-ascii?Q?Gbpayl0AmALs1Aox8B5JWTkv7b2FsowLOvuzHef2bjKld0aNR9Uxy59+zMPy?=
 =?us-ascii?Q?4bEcNxFom6Si8u2dkvkrs/M76ot+BNNA4Z7X8Kh0Tsp1HMkSJnvraeLvmON6?=
 =?us-ascii?Q?CILUt/0Pmsv+dRS+VfAm4eSlWsBUw0s0gq9h77UCFCtkxJw4EplfIBPPlwiv?=
 =?us-ascii?Q?PMSm0Nfc6PHAXumlx7iXDmKONIUeFXftNbOv4fC1WGIxMNoAiWbFK65NBJK+?=
 =?us-ascii?Q?EwAVrCGx0mb2b9CzzCwMWJA3ylN6aZG0sXLucjo80/BcjjzHojA2/qfoNghm?=
 =?us-ascii?Q?kD1UZea6ppcNg8jla+RwHe7Z1o996BeDysCgqoztZeQncv3UgHR3nOxhxpVx?=
 =?us-ascii?Q?aFngatqTcfcrk689mdIkj9cQC1ILALbNDGqxeBNvapfhUnZA/s3T2IT+YowW?=
 =?us-ascii?Q?iUSA6+e1IHdN9M/bkNDGyfWpu4Vmngzo7UUQEHNbDowGjM6Eq3TWRVdFbEwf?=
 =?us-ascii?Q?Oonf7sr64xEFc3Ipvv9OWK5FdF9qfSSqNIwL9tl0xEi5Ddi/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b50c65-5f7c-4ee4-91a7-08dedc3cde48
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:31:52.0255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgLtL4qVUkMwKyby+i0hJ1tw3XQnjwkg9/0ltmge19++MKyNcgyXlyQqx2/9lio2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9080
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C86C1C000F
X-Stat-Signature: gmqhr5f3amgqa4a6ysf3hcs8brjtkg6f
X-HE-Tag: 1783438317-641653
X-HE-Meta: U2FsdGVkX1+9Ph8uQL/FxYrz2PwaEbBH+Om6K4x9ZlKvL54cpnUe6oxg6sn9lSa1UPw503vsWNjUjYw3jiin2ztLxlSMoaYvZDI45PsWEXPr3cj9jZUyt+lYAlXWRks/RjXWtRBmWPI4aPIJhcE0pVl1T9N2MYDxhbyUz3pDkqCvL9NevNHQfb+L/PZsAZczrIvYU5sd1bBY3/x/XRk8d3mm35ozCuMNeQdg50VKjucXWPr92lBwI6ccJFsLmFgpbRHoyh1nmkYVbDoPxHPNUGNCimB1qTqXSTfo6MTRYFBWubFVa/NHAPOfXPHXx8p4LnSJEPuxekOKGqzblnc4g0u474vKG8wbtinPnjkkOlNOgFv9JbQL6afi1u9qs+Gb7Mo4biymn4FfeKELQOvXCooa1LThg7GoUvYStSKhAS2emBj0eXHP2ccLNHXAqiTgWDtHlSwPYNtXAX73EO+VECW/+BRl08VVVA777RhM2jUSta+Pay7dT/tS5K5cT9N4vCM7BILevc8+xL4ZxtX714GJysl44HFrBZxtCEUUxVr3wwPdMzL/jFcqK70zuQdvI/KnRpU8Hgnl+QFQSfMO3vcZXEdjrRBsgJB/Sma8IskMDhKkTH2ybfI6vmdPzNA7BSe0tSyIC7PzWGpy4GfUrbDAbbHlA8sq+cvF0+0PqmQ7e3KkkUape/UMtO3dttPTLev+WzyuvCv6LeXFHIHBdX4qTnEMd5UphQaxgq1Sur4gOehwdBxmwreH+hmhpQOIaWLVJtCCWKQpMXlVUeqPLsid4sYCJ7l+65QNw9MtyB1my7o5NSF2DNJca5OTy9ByleFxlM5xgFMPkUoYNTYfIpWAaVoIn+bQ3a6HAmkxo+U4UVx7iCi6l6EJ2tCxpPcMudPvupdmAxpOXL+AbBTCG/2U32RpFRGcGRdVX7UMgMnCRwiKnEZbHon7l+L9ZJj507QwrKU1YpagCNKqA4n
 sRONAJkl
 00ID3NpllguH730YMqojmpJkmnzJHgClrjnaIZX6k+0VucvVM1c36QIhuw1gmfG/PmFJuv3BQswUVMPIrLl5ADxA9uYfy0sXXqZVL3H03PALRlWOTsXV1imvXJpvxvEz4KM/oQv3L+1Ur3atgxa2eLDneTYTxwPhREA1K2906XKuaYMS2XpaaBNl5dQ4FVcvVUVpIRxC/wsoKyv30/X5Pm8xXaJKDZ03U9AMR6h3zxq4DNs9Wwq2sg6ZOlpY3u6Dtrpw09qkGSigW/Mrf0wcii19EUVGz8EttrkwUo/XMp0KC8V23R+bcK9KUykD8W7fCmrzpAR/MHlgHqzy7eQxla8OPC6+z1JOsG6SVLh3G3JjMay/ZjnLdSGicmGbw+zuaP15XG0PLDX+7HvoRAwnqBTHUGdxqepYemUzoukSLsTscPNPPVcpWt30KiV7prqGEsLYHR1vm2Iu3na8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jul 2026, at 11:27, Vlastimil Babka (SUSE) wrote:

> On 7/7/26 13:54, Zhen Ni wrote:
>> Add a print_mode filter to page_owner that allows users to choose between
>> printing stack traces, stack handles, or both, providing flexibility for
>> different debugging and analysis scenarios.
>>
>> The filter provides three modes via page_owner:
>> - Writing "mode=stack" prints stack traces for each page (default)
>> - Writing "mode=handle" prints only the handle number
>> - Writing "mode=stack_handle" prints both stack traces and handles
>>
>> The default stack mode maintains backward compatibility with existing
>> usage, displaying complete stack traces for each page allocation.
>>
>> The handle mode dramatically reduces log size and improves performance by
>> showing only the handle number instead of the full stack trace. Testing
>> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
>> improves read performance by ~4.4x compared to full stack output. The
>> mapping from handles to actual stack traces can be obtained via the
>> show_stacks_handles interface.
>>
>> The stack_handle mode prints both stack traces and handles, making it
>> easier to identify pages with the same allocation pattern by comparing
>> handle numbers instead of comparing large stack traces.
>>
>> Example usage:
>>   # Using the page_owner_filter tool (recommended)
>>   ./page_owner_filter -m stack          # Print only stack traces (default)
>>   ./page_owner_filter -m handle         # Print only handles
>>   ./page_owner_filter -m stack_handle   # Print both stack and handles
>>
>> Sample output (handle mode):
>>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>   pid 1, tgid 1 (systemd), ts 123456789 ns
>>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>   handle: 17432583
>>   ...
>>
>> This implementation uses per-file-descriptor filter state stored in
>> file->private_data, allowing each opener to have independent filter
>> configuration.
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> Tested-by: Zi Yan <ziy@nvidia.com>
>
> I think in general Tested-by" can't carry from previous version due to
> (functional) changes. Andrew can remove it locally, or Zi can re-test :)

Let me do a quick retest. :)

>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


Best Regards,
Yan, Zi

