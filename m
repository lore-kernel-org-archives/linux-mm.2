Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B4FCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 03:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993EF6B0005; Mon, 18 May 2026 23:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9454E6B0088; Mon, 18 May 2026 23:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C5E6B008C; Mon, 18 May 2026 23:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6847E6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:11:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8FBDC075D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:11:04 +0000 (UTC)
X-FDA: 84782692848.16.2BFDBE3
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by imf11.hostedemail.com (Postfix) with ESMTP id 296B940005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:11:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pDoEZPlj;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779160262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXIxxYumr6PvhRn1BTnf0xVjQTYlOLSNZP2jpNUOXik=;
	b=XXE8SyzpyU7HQkGI8EhGTVRzTod9lKqOQCDY1eI1KW+VhzlavBC/3IKzSZe7c8X377PRKO
	G7wIrTS4j1n3LS+NSpp1mWLvAhngtgp6g27gReHQbSN2Bi0ABuYY6x8GDCwNfD17A2TnVO
	6dSlIlydpGfgojJ7u5G1dFgsH1GetdE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pDoEZPlj;
	spf=pass (imf11.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.15 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779160262; a=rsa-sha256;
	cv=pass;
	b=6h+wEHpfK6PHWDxf5Jv4EFJI8VrZkFJPGFxs8CUdzi2K3y9chFhH007FT8b/1LN/BiWsuK
	uN02NllS0GG3dzQh/3dQmox4nRKbR1g9Elp+Wk7Jvvy4NArVQlfu2XJXL3aGZrpKFXT+z/
	kKDhG3HAbECsVa2PdMb4BInd0eiHhkU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IBVyoNaXOO7MEy5lTICgGx+LAP3nI7qbrnQ498BXz+MVIztBXaeOlxRBpA+SVguo5EnKUEM+xKXMrTwpLkDxcB7mtHWdlQg05bl3sJdsPZCpSrE2ymnCuWqY64PTwXKJwEtAJcmziaAqQ8iWO9+dQsB+nuFsDEWr/FCcxV/vjqr7QQ1f3HVlyhAhkRdl1FH2TQfjJJka7s7vvrzkpewvmWY5xoRJWJEC2g/tDqg/hN4nCB4yHVoEpj6h3o9j12TMtsigDIz+DVIUlpRSNfIRtHreCw8TYzLGRZ5E2yKgj8AwTLb26oM/n8QUOsxJkDP8rNKO4/AvNEarV0nswxQEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MXIxxYumr6PvhRn1BTnf0xVjQTYlOLSNZP2jpNUOXik=;
 b=FFtQSz9i5SGFc6sgNShHj3sX1FyaK1p+z+BmWfQhEm671+/jlvtuiuTAI29Cv8lj+edXk/WFni7iWUynr8bvYkT8yYPr9NJoBoGNANVJxPb3C+NOQn8eCRXsFO+PqYgPbOTwXV/T4yohMt6XrosE6n0JXOGEJywPYmgGJViFfW5Yn4RHhZlBaJEd07uwdphO9W9mz6sf8BVOG8nMCUV/8V/drjvC9afbj/fvmwPrV8hjwm71fiamok1dEw9WQ00wwRmIJyPrex2TigpUf+MttVjQnDWLsQ3Vq022tnoRmr9w5avKi4OtQY4GT3ycxXTJHOP+CaQ+bRs69B8mvpHTlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MXIxxYumr6PvhRn1BTnf0xVjQTYlOLSNZP2jpNUOXik=;
 b=pDoEZPljrEo0VC5ZfTxrAGXV9t0qTbr26006we1IdNbob243efQKztNeoOIv5vid3sg7Qk/EppmATmOHCyJfvCIiSvYIixJQ4vQEct49uEvBlg6x+VnwLs+UO5zeR3kio1PFrdciSU8WkoUECAkAVDwrz4FOZlAsswaEgSM3GKLyDP9luls4U5UcEM0E7xseT5cYL2ahqXO2V8gSHYuI08GICN6q3FuR56V5g2+TA9z4y0oTr0u8C5VZi8IGnZarVWj1dww5LBszSN5tedXn1LiCcf8reh2HQHBdRJEUXbfHDlpFmNng796WwQYr4sL6B9QDyITT2L2plqhRa1i9ZA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS5PPF884E1ABEC.namprd12.prod.outlook.com (2603:10b6:f:fc00::658) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 19 May
 2026 03:09:06 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0025.023; Tue, 19 May 2026
 03:09:06 +0000
Date: Tue, 19 May 2026 13:09:02 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, arnd@arndb.de, rppt@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: use arch store helpers in zone-device template
 copies
Message-ID: <agvRC7F8X_4TnKG9@parvat>
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
 <20260515082045.63029-5-lizhe.67@bytedance.com>
 <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agpaXHqh1gJE_xcQ@nvdebian.thelocal>
X-ClientProxiedBy: MEWP282CA0121.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1d1::6) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS5PPF884E1ABEC:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f19ed18-406a-4665-f2f4-08deb553fd16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003|3023799003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	WwiVFr3iBOpRX4NBwT7E/O2FuWUdMoTiNsUhRbWU2c0y3QlzR4FE5uOpRNyrDJatDIU5eMFP6QmQ6J6q66mj5t9NKXlzsOGd1iuApjRw2XGmO7YdWaSRSMO75kiMDUNfOON8C3QLZ/XjyMP/7DRcUCMNom1RiLG+RGg6P/JEmPmP+D9O32ZevT7+yE/NcyykEoQH2BlrklkYfKpY7tP7xzicO10oUuiGZSijnMfa1KS0FVcO3e/6Sba5TcrKlIjjSEOgY3h30x0hWihPY8rmHXR+cCTGP5ZQ1cRvWEC+DlPnWv/R/ZpPdnOdLA13BobQYL5c+ZPQNt8ERh/Cuzw/pt5gGAj4plHVjOQDJjZwjgKkMexQQ253cEyujvhjYceN/k4dGhe5MyzMfGQDRPgaJxQvj3hJEUQNVlLyV0DtGtyResnPIltiMjdH2srVh+C8rCmdR9v99bnLsoJPEXKGGbJXGj1qfE9+GZj2Kg29QtuO1Tob0z6w/y4YxX+69LvzjaOXUOLhUQgKeKgxcDgJnR2PPU4KGmpV00faAwVbm5Y3YZmWm8FXxINzbSxMo9BNihpe6HrqNcx3R189BJbSNmyjtrQohHbNUhathghW2vK4Oi4iwoDLMKwfkD2jQGGtKJX/ZD9H81i41Ot68ibiKV5EtmNLZASTz5Rf6j6A56IKU9Q/ully7K2N3d/zy6+c
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003)(3023799003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ej8riG81xRL2cxGvBVIlOUtJkk6Iy/b/d7rIt3xxNepGbZydhaWflD9TgFK8?=
 =?us-ascii?Q?FcxfdsFezePfHr+Ia43htrpmPucIFgrGGWp/9x7LESm89CjyyoJfvGFcODOJ?=
 =?us-ascii?Q?kwwnpaWzN+FlFwn2TpKg7bpMLIue/WB1u1XeqhOGRwZSvf9NGGeZrrzA/xvy?=
 =?us-ascii?Q?W0RNISIUUkqIpaQX5Z0B0zUraFVO30AwxOqjEBklwS0S6TztlW1nh65gVv+U?=
 =?us-ascii?Q?OqYxMVuY0abZA9HtgwRBpClkPFNkkWBJwLL+sV9tZoj/JPRzYN7XynIFuayU?=
 =?us-ascii?Q?njz2w6XShdV9gw1MUItqUEdAkBfyeoS+d34zTdim1/CFQ9tgYgcauSTuJApQ?=
 =?us-ascii?Q?VOZeqpcuQ/UVid8uGVwWOoEBNhdc1zNREUwEqTtjdYtbbQjOUFA10Y90qR0i?=
 =?us-ascii?Q?cyA61RD8ILJaehldHEX/HpCMYdmQs1U7jq9hpjhydUVlTEYaPlqKXiOAO/Cz?=
 =?us-ascii?Q?2fRVmSWoqztW1F2B1D3yr0zbnx77Qem9UEjwaDTLEf7+O5S8/j1B2tVMEfI0?=
 =?us-ascii?Q?j5ZPwdGQzlm+bcgbcJKmTolkZ1cAjRWxiSiWpPkTCc3LT9BVPTDb4VFkbKPt?=
 =?us-ascii?Q?KD/+Uk61/k2Ipe1Z6nfkHhlA+gAj6eTiQfZDo1fPFZzhHrsvdKNWXUN0IvB0?=
 =?us-ascii?Q?TLl2sxVchYPWtzgHu0CgQdYzBmDPOvaRLjoUTwnnKdic/pW7PrIUip/gZ/AQ?=
 =?us-ascii?Q?qgcNjSyBOM/tc6yv1mJb2YxedRtAfD2jDseQRrVwNizds5n5cq0aJctI8Ndl?=
 =?us-ascii?Q?AHGG149nBC+SmBy+MJx+qrpqxP/jw5bDpcY37Loby3rNGxqU7eiF2O+jX+Va?=
 =?us-ascii?Q?a2Yw4d4PmJ7e1k1CJMSIS5/OAvM507pUJkCMVBJjC8+ktJFIJLCsnA4mViGc?=
 =?us-ascii?Q?rjTbFAaycj6EsG72hIzo+5MZVnjW2A1kBhMiow0eEJG+Msi0lcvLG4tttxGv?=
 =?us-ascii?Q?utb/UGPaFnFJOSi2BKLmDgSQM6INy88XgY7/e88BEHaLnjL1Aoguc/Aw41Tw?=
 =?us-ascii?Q?i4WLfV0uVxjP6OTTEDSOln4Rh7y5o3sUxQGdK2ilNO3ZdKdeaEyPyHCWK2VY?=
 =?us-ascii?Q?VRHDBr4mhOQNMXYUg2u2k6xSSYH8zTWPdPrq2X1l0vYfWinoYU0PkpzWv6Fm?=
 =?us-ascii?Q?PXf4u6BNHBbjCacBQt/5o8uJxj4RWfqkDRfH43nBV/zcuOPZL6cl8/kEU6w3?=
 =?us-ascii?Q?UZ5mitr2oPsPsVq9U9/1E2CMaRMEDaas/pELwqrpuIXLVP98mOUOWjK7u11N?=
 =?us-ascii?Q?YuTJrkQsljAw1NI5qhUC5f4JsiiylJ5x9UxGJ4WWWBAAWIqiQ+ezBITAQC1B?=
 =?us-ascii?Q?z90Z603LKZZAnYnXYhnsza34wRcXQf9wPGgHwSs5RUlaVGPi0LFMe5ohzsAX?=
 =?us-ascii?Q?vX/Mhu/IhkCZhCCLmrX0pjGKsM6X5mhn+1q/e3WvFiQ/UZ2LF6m8c5yb94aP?=
 =?us-ascii?Q?Fd5VEACgnub0KyJCXXv3MvqTFtsuXFqPoNn+tqJX3NQt28BXvm87TCSnr+eU?=
 =?us-ascii?Q?YqA6g6lRoW/Ff9IYRe6AOgtKRF+i0b6tyBQsxePrZ+9zW4QY7DYg5gxzGFdk?=
 =?us-ascii?Q?Y+vGpCm9bq+epzASP4eABuXntRysuhLXT2JdgsqINqIxmDe0s2HAd6JC3ED3?=
 =?us-ascii?Q?3iI8C0PDgFPo4xQAkVS4HTygur8SjESXIf8iLT7dDRqfPAoL56wjWrVg4hhh?=
 =?us-ascii?Q?kd530zzo8kcJLQb7SnPL7jODOTBX9C3Rbp42aJyU/VcNJosaux4xUz5Ab5S3?=
 =?us-ascii?Q?cmYNoFDnqQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f19ed18-406a-4665-f2f4-08deb553fd16
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 03:09:06.7233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BehxlbgLPElsuUgFn/tVC6e7YoNoxaSXXx9i4mX8JVkPG9Bl1eAoD4NcnnbK01uokUjALeVsZDGS27YWP7MllQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF884E1ABEC
X-Rspam-User: 
X-Rspamd-Queue-Id: 296B940005
X-Rspamd-Server: rspam06
X-Stat-Signature: 5jtdozf841duqmqxhhapnzjkpzg4uxeh
X-HE-Tag: 1779160261-983941
X-HE-Meta: U2FsdGVkX19dP7gbja5IMJMh5iL3P/9g5posvoCBKSM76GepjsN9sY2PaTMZ6X63QQyUKB+wqBJf88IKn26G1TMx9G/09n8y/Dbx2AD+QAEBok4akf9e7O2w04n/OryAUoRjzR+4t/MMeSfHEX7hG418bARhssgEBWE+S4PlTxopMh8b2Smyvjr80FHypN2OS9k4ufdnhVi/5F6kSnepylq3IRL408NmdgHjHm9q8/BJrVk32RQujiGre5wuX3LJxYhuIBlzTv81Ewot8puk22RGLPC900HlRlA93vWjnVI3deSjpESxJxj2ydO6/glGjEpAie4kbg8n4nf6QhsYP0DAujVMhtcFPwzeGRPQV3Pl7sxtJ/1+xuRhfR1oHNSJ8HPOXKy9t4LIiVbuVygnuFw09fHBuIDeqjAn9IGnOi5ckTuKPyrQ+8N1AsEMXsypO0Uo3+6fZPoEDbdJKUOfIQ9v2yEFtMdTdgDxkOTH3HSxCVgVYNCVkcd//DukwfoCgw1j5eItxvX0J8clcwoh3+NyyEK3uqCcRVuBvuYM88yqsH3QX/E1OnxLLkMTm2G0dmmxDRA7YxdWGr2xO+Nj1msXUEIuf7wE/pbyi8wCaAezcwaQmGL3aw0/8h1as+SkGSdj+QnSjfTPdCjlHmxpi5GEJd7ncZSQqzChOzrTwdyTR/ONFEAU+PYzniCJux1lJEpWVcoDCqBlXsX/ZZCvJPg7a+iKOeiQmmyO5EJ+mZ4Eq1DxsTzyZB3ej6VzOWOMfE5E0GgB3QCS0GHW4q3pLxJ6E9pl2OmIN8eU3kJnIOVQTeerW3/epVN/cqxBzP8c+NIVRXgYg6a6uWUj4EPknaDqaBExfFNh9vjE0oOWuXVDastjQGNFosOJNIAZ3dnNWrRhiGri0LXpsgjOutckom8RPzYwczcYfb+MNGl/UyiFxDJMGgv04kcHS5PCMRRMZ7Lojj0gnsemNCprc9p
 Cc6tSKL+
 w31/IsG15dTg+S1/weC+QFFTw8W3zUsVwWafm1zWOaQo7M2Oh8TWUSp22m7Muc86il1BrloIHV6eqo4JYTBzIlWQk2zCfiUQ4RVGQwEYlRRYl2B5zkr0TZO+7vaSwHi6n0zx0jdDmdM8LXzft5gdnVEFj2yGEaFX/Nj37vMO/oik+aEaoqD/3ywWa8ALn8OBYT9EUHH8AIZBqYjnPQwQMs6IbLbmJ1YRllUg6PTwyJ1GXMcFNIoKdl04CfBIgJ/cR6ETsnCdZ52Al3hbYb81NfRFnr9u11Q3B4RFYGFrTX88JmBVHE6GYTZ9wKmN+D75pcPwM/Wefg/RINtjPefs6ol68122VEwiyIpgIHc/CEs3Wd7vBypol6kA9smUYiFP6T/68jgi8eJboC7UUOEcq9SuU5W6IRn0ib0+lT3ZPscacsoK/DaqfNyLz+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 10:32:03AM +1000, Alistair Popple wrote:
> On 2026-05-15 at 18:20 +1000, Li Zhe <lizhe.67@bytedance.com> wrote...
> > The template-based fast path still leaves the actual copy sequence up to
> > the compiler. On x86-64 that can easily degrade back into a runtime copy
> > loop in the hot path, which leaves performance on the table.
> >
> > Introduce arch_optimize_store_u64() and arch_optimize_store_drain(),
> > with a generic fallback and an x86-64 MOVNTI/SFENCE implementation, and
> > use them in the template copy path. Also open-code the word-at-a-time
> > copy so the compiler emits fixed-offset stores for the hot path instead
> > of a runtime loop.
> >
> > On x86-64, MOVNTI is a better fit for this write-once, streaming
> > initialization pattern than normal cached stores. It reduces the
> > write-allocate traffic and cache pollution that a regular store sequence
> > would otherwise generate while filling large ranges of struct page.
> 
> The perf improvement looks good so thanks for looking at this, however open
> coding this and introducing arch-specific code layout into a generic layer is
> not the right approach. The correct solution would be to implement a memcpy
> implementation/variant that is optimised for write-once streaming operations
> that can transparently degrade to memcpy on unoptimised architectures.
> 
> A grep of the kernel sources for movnti shows there is a memcpy_flushcache()
> variant. Maybe that could work here?
> 
> > Refresh the PFN-dependent section bits and page->virtual state in the
> > reusable template before each copy, instead of patching the destination
> > page afterwards. This keeps the hot path as a fixed-offset store
> > sequence and avoids post-copy normal stores to cachelines that were
> > just written with non-temporal stores.
> > 
> > Because non-temporal stores are not ordered against later normal stores,
> > drain outstanding stores before memmap_init_compound() updates compound
> > heads and before memmap_init_zone_device() returns.
> > 
> > Disable the x86-64 override under KASAN or KMSAN so those builds keep
> > their instrumented stores through the generic fallback.
> > 
> > Tested in a VM with a 100 GB fsdax namespace device configured with
> > map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
> > server.
> > 
> > Test procedure:
> > Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
> > initialization time from the pr_debug() output of
> > memmap_init_zone_device().
> > 
> > Base(v7.1-rc3):
> >   First binding for nd_pmem driver: 1486 ms
> >   Average of subsequent rebinds: 273.52 ms
> > 
> >   First binding for dax_pmem driver: 1515 ms
> >   Average of subsequent rebinds: 313.45 ms
> > 
> > With this patch:
> >   First binding for nd_pmem driver: 1272 ms
> >   Average of subsequent rebinds: 104.59 ms
> > 
> >   First binding for dax_pmem driver: 1286 ms
> >   Average of subsequent rebinds: 116.93 ms
> > 
> 
> > This reduces the average rebind time by about 61.8% for nd_pmem and
> > 62.7% for dax_pmem.
> 
> Nice - is this the improvment from applying the whole patch series or just this
> change?
> 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  arch/x86/include/asm/struct_page_init.h | 28 ++++++++
> >  include/asm-generic/Kbuild              |  1 +
> >  include/asm-generic/struct_page_init.h  | 17 +++++
> >  mm/mm_init.c                            | 89 +++++++++++++++++++++----
> >  4 files changed, 122 insertions(+), 13 deletions(-)
> >  create mode 100644 arch/x86/include/asm/struct_page_init.h
> >  create mode 100644 include/asm-generic/struct_page_init.h
> > 
> > diff --git a/arch/x86/include/asm/struct_page_init.h b/arch/x86/include/asm/struct_page_init.h
> > new file mode 100644
> > index 000000000000..de8b4eab44de
> > --- /dev/null
> > +++ b/arch/x86/include/asm/struct_page_init.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_STRUCT_PAGE_INIT_H
> > +#define _ASM_X86_STRUCT_PAGE_INIT_H
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> > +
> > +/*
> > + * x86-64 guarantees SSE2, so MOVNTI and SFENCE are always available there.
> > + *
> > + * KASAN/KMSAN rely on compiler-instrumented stores. Keep the x86 override
> > + * disabled for those configs and fall back to plain stores instead.
> > + */
> > +#if defined(CONFIG_X86_64) && !defined(CONFIG_KASAN) && !defined(CONFIG_KMSAN)
> > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > +{
> > +	asm volatile("movnti %1, %0" : "=m"(*dst) : "r"(val));
> > +}
> > +
> > +static __always_inline void arch_optimize_store_drain(void)
> > +{
> > +	asm volatile("sfence" : : : "memory");
> > +}
> > +#else
> > +#include <asm-generic/struct_page_init.h>
> > +#endif
> > +
> > +#endif /* _ASM_X86_STRUCT_PAGE_INIT_H */
> > diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> > index 2c53a1e0b760..3a493fed6803 100644
> > --- a/include/asm-generic/Kbuild
> > +++ b/include/asm-generic/Kbuild
> > @@ -65,3 +65,4 @@ mandatory-y += vermagic.h
> >  mandatory-y += vga.h
> >  mandatory-y += video.h
> >  mandatory-y += word-at-a-time.h
> > +mandatory-y += struct_page_init.h
> > diff --git a/include/asm-generic/struct_page_init.h b/include/asm-generic/struct_page_init.h
> > new file mode 100644
> > index 000000000000..45a722103a51
> > --- /dev/null
> > +++ b/include/asm-generic/struct_page_init.h
> > @@ -0,0 +1,17 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > +#define _ASM_GENERIC_STRUCT_PAGE_INIT_H
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/types.h>
> > +
> > +static __always_inline void arch_optimize_store_u64(u64 *dst, u64 val)
> > +{
> > +	*dst = val;
> > +}
> > +
> > +static __always_inline void arch_optimize_store_drain(void)
> > +{
> > +}
> > +
> > +#endif /* _ASM_GENERIC_STRUCT_PAGE_INIT_H */
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 5a9e6ecfa894..a3211666ccd4 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -37,6 +37,7 @@
> >  #include "shuffle.h"
> >  
> >  #include <asm/setup.h>
> > +#include <asm/struct_page_init.h>
> >  
> >  #ifndef CONFIG_NUMA
> >  unsigned long max_mapnr;
> > @@ -1078,9 +1079,21 @@ static inline bool zone_device_page_init_optimization_enabled(void)
> >  	return !page_ref_tracepoint_active(page_ref_set);
> >  }
> >  
> > +/*
> > + * The fast path copies struct page with fixed-offset u64 stores instead of
> > + * a runtime loop. Keep that copy sequence in sync with the struct page
> > + * layouts supported by this build.
> > + *
> > + * The sequence below requires struct page to be u64-aligned and currently
> > + * handles layouts from 7 to 12 u64 words (56 to 96 bytes). If a future
> > + * layout falls outside that range, fail the build so the store sequence is
> > + * updated together with the layout change.
> > + */
> >  static inline void struct_page_layout_check(void)
> >  {
> >  	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
> > +	BUILD_BUG_ON(sizeof(struct page) < 56);
> > +	BUILD_BUG_ON(sizeof(struct page) > 96);
> 
> This would be uneccessary without the open-coded memcpy and is another reason to
> prefer a more generic approach.
>

Agreed, also I think this optimization should be enabled only for
production kernel configs (do not enable it if WANT_PAGE_VIRTUAL
is enabled), so that we can restrict the size to 56 bytes.

> >  }
> >  
> >  static inline void init_template_head_page(struct page *template,
> > @@ -1108,30 +1121,67 @@ static inline void init_template_tail_page(struct page *template,
> >  }
> >  
> >  /*
> > - * Initialize parts that differ from the template
> > + * 'template' is a reusable page prototype rather than a strictly immutable
> > + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> > + * the current template, but section bits and page->virtual may still depend
> > + * on the PFN. Refresh those PFN-dependent fields in the template before
> > + * copying it into @page.
> >   */
> > -static inline void generic_init_zone_device_page_finish(struct page *page,
> > -							unsigned long pfn)
> > +static inline void zone_device_page_update_template(struct page *template,
> > +						    unsigned long pfn)
> >  {
> >  #ifdef SECTION_IN_PAGE_FLAGS
> > -	set_page_section(page, pfn_to_section_nr(pfn));
> > +	set_page_section(template, pfn_to_section_nr(pfn));
> >  #endif
> >  #ifdef WANT_PAGE_VIRTUAL
> >  	if (!is_highmem_idx(ZONE_DEVICE))
> > -		set_page_address(page, __va(pfn << PAGE_SHIFT));
> > +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> >  #endif
> >  }
> >  
> >  static void init_zone_device_page_from_template(struct page *page,
> > -		unsigned long pfn, const struct page *template)
> > +		unsigned long pfn, struct page *template)
> >  {
> >  	const u64 *src = (const u64 *)template;
> >  	u64 *dst = (u64 *)page;
> > -	unsigned int i;
> >  
> > -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> > -		dst[i] = src[i];
> > -	generic_init_zone_device_page_finish(page, pfn);
> > +	/*
> > +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> > +	 * page. Update the PFN-dependent fields in place before copying it
> > +	 * to the destination page.
> > +	 */
> > +	zone_device_page_update_template(template, pfn);
> > +
> > +	/*
> > +	 * Keep the copy open-coded so the compiler emits fixed-offset stores
> > +	 * for the hot path instead of a runtime copy loop.
> > +	 */
> > +	switch (sizeof(struct page)) {
> > +	case 96:
> > +		arch_optimize_store_u64(&dst[11], src[11]);
> > +		fallthrough;
> > +	case 88:
> > +		arch_optimize_store_u64(&dst[10], src[10]);
> > +		fallthrough;
> > +	case 80:
> > +		arch_optimize_store_u64(&dst[9], src[9]);
> > +		fallthrough;
> > +	case 72:
> > +		arch_optimize_store_u64(&dst[8], src[8]);
> > +		fallthrough;
> > +	case 64:
> > +		arch_optimize_store_u64(&dst[7], src[7]);
> > +		fallthrough;
> > +	case 56:
> > +		arch_optimize_store_u64(&dst[6], src[6]);
> > +		arch_optimize_store_u64(&dst[5], src[5]);
> > +		arch_optimize_store_u64(&dst[4], src[4]);
> > +		arch_optimize_store_u64(&dst[3], src[3]);
> > +		arch_optimize_store_u64(&dst[2], src[2]);
> > +		arch_optimize_store_u64(&dst[1], src[1]);
> > +		arch_optimize_store_u64(&dst[0], src[0]);
> > +	}
> > +
> 
> I don't think unrolling the copy here is the right approach. This belongs in
> some kind of generic streaming memcpy routine.
> 

On x86 memcpy_flushcache does something similar to above, can't that be
reused?


>  - Alistair
> 
> >  	zone_device_page_init_pageblock(page, pfn);
> >  }
> >  #else
> > @@ -1201,9 +1251,10 @@ static void __ref memmap_init_compound(struct page *head,
> >  	__SetPageHead(head);
> >  
> >  	/*
> > -	 * A tail template can be reused for all tail pages in the same compound page
> > -	 * because shared state for compound tails is pre-set by prep_compound_tail().
> > -	 * The per-page page->virtual and section in flags are fixed up after copying.
> > +	 * All tails of the same compound page share the state established by
> > +	 * prep_compound_tail(). Reuse one tail template for the whole range
> > +	 * and refresh only the PFN-dependent fields in that template before
> > +	 * each copy.
> >  	 */
> >  	if (use_template)
> >  		init_template_tail_page(&template, head_pfn + 1, zone_idx, nid,
> > @@ -1269,10 +1320,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >  		if (pfns_per_compound == 1)
> >  			continue;
> >  
> > +		/*
> > +		 * Compound-head setup immediately updates head->flags, so make
> > +		 * the template copy visible before entering memmap_init_compound().
> > +		 */
> > +		if (use_template)
> > +			arch_optimize_store_drain();
> > +
> >  		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> >  				     compound_nr_pages(altmap, pgmap),
> >  				     use_template);
> >  	}
> > +	/*
> > +	 * Drain any remaining non-temporal stores before returning.
> > +	 */
> > +	if (use_template)
> > +		arch_optimize_store_drain();
> >  
> >  	pr_debug("%s initialised %lu pages in %ums\n", __func__,
> >  		nr_pages, jiffies_to_msecs(jiffies - start));
> > -- 
> > 2.20.1
> > 
> 

Balbir

