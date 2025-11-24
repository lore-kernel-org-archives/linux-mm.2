Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F842CFD362
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 22:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6273D6B0010; Mon, 24 Nov 2025 17:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D66E6B0022; Mon, 24 Nov 2025 17:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477D76B0023; Mon, 24 Nov 2025 17:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8106B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:14:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB8A81A058F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:14:36 +0000 (UTC)
X-FDA: 84146905752.19.EC9EA10
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	by imf07.hostedemail.com (Postfix) with ESMTP id C966840013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:14:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SZIKEBcl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764022474; a=rsa-sha256;
	cv=pass;
	b=bAiUkRl81oukWUx3UrE2p5NBYbFzvcP6oug4FcHtWF1BZYULm1htgAd1q+1Lj3zv4FG8+f
	4xtG1Z7nFH0FdMqQ24AUFrTXFOepbvOjo4xFNjS7a1f+41e4Z6PPMc23Ab4f0QceeSh0EX
	kpQQLD7FE02nlAFt7wS9cA6owGav4kQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SZIKEBcl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.19 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764022474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zX8Z9gfR9t5iDfSFji/391ATdoJJGfmw8idKu0a8Dw=;
	b=CfayxdwYoiZR1bGrBMqW26ox4QXZ7wdik6IcV0NRFaqgMpYsaubuB2awGVIMGFzl5TwKaP
	oggKSCzk8fzI8JjsRwWMUK+pysq2A6vz9EWaFTtWPAfi4V10QUIEJPwE6QbqqE4qL7Ir8R
	JcsVYahdKoup6edAnid7bJpNjNlZp6g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vhOkKWCWv1m2G/CfhaJHbjVcpvKsd6pWbOOUGI0wn9TXY2QjpI7MvTvd/JdN0Lu+UoBgFh4b2nVA4B/Aj1mrWON+rPYQdRqxIKi0l8j5x+GpP4em6SP9L7Ueny+KIKJDBUu1G1h+hkqwdRbkcmGKVee0/JoCfvpJBc+hYN0VJ9EiiV9x8pZvjXKpFoPQsOHawLREM7UvgkSsta6JqpNr3SQYhTFENks2+/zdqZ3y0NVI8EPZ9La1bH4W4Q4zrzrYaObqGTNscYpFB9yM5450+8OpZ7GXWy2KuQ0SQpxQYMEDuBn6atS/b8OO+PnDBj9R8SZxyX4aytDLcciViB3pKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zX8Z9gfR9t5iDfSFji/391ATdoJJGfmw8idKu0a8Dw=;
 b=tdB+jxQD3Ro2NL6u7AUt+ytGp6wcRe+URcClnlohkKZ6O10uHqkqvaOPxe4fsn1D7a/7MnLnDTyraPz94/J6X/7P7d4/ClyJcpHEC2lTbb8IU7JAsk0yWlbLA2czvP75wv4101RT0W75hEpVqTgiwTakDTAlbydV8gpot5LTTyYly8D8jX7t3fnwk4BHSddkZPFz8GR5JvR96hGTXTMFtZUitLSXjRqnqjBUAGW4Q68CrK0yJc3stWwlDm/UsEz6/yIhbX9U20VYwv2Vj5x36f9rsKmQGSo9pwEt391+GQuLhQNxQez1vP3rF6aDWq+jX+Qk2LXG8x4IBhdHX45WYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zX8Z9gfR9t5iDfSFji/391ATdoJJGfmw8idKu0a8Dw=;
 b=SZIKEBclYhx5mfHKDfd8Z0UZRoRZM1F7Sq/FcKWrd/BeMZlCTpRhnT4AzfXFKpRljdQm2pil40Xt5nw7NM47EjgskZjHVNsKw/Ic+3xYKC0PUVrtLycm1N7zFMcaMlbQxoLqhGX1EDoKvY8NiXFSVc+Tqr2uh9CiZ1Yyz+MAkfth10RIKpWPq0v9x1eRzSytCHasKeGGZa3CjA1a9S05NSJa9yvJh1JLLVnQ0VavFLDdke+2Z8cXgqHI7eIKKbCC2iWXgs+kMUPqm9BP5233V1eHOmiC/lwkYd8mkU3WRb295dckH2Uh6xIBbSLR1EU6CiTj5QMTzSGpXiCHyxBaMw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB7865.namprd12.prod.outlook.com (2603:10b6:a03:4cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 22:14:28 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 22:14:28 +0000
Message-ID: <51675d77-9453-43cc-bfda-f21a2edfeace@nvidia.com>
Date: Tue, 25 Nov 2025 09:14:21 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
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
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20251122025529.1562592-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:40::31) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb15002-0217-4419-ac0c-08de2ba6d568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|10070799003|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUxVeEl1aWJGY1BEVFRvSllVbllHSjdxQk1HNzYxSmptZGJFVWRaWnNOcktj?=
 =?utf-8?B?RTdWd1BHNSsvdmRsVTRhaDRxZlVYS0VaM2NRWXFJQlBIbzJ0MHk3TzU5K25N?=
 =?utf-8?B?TFp0ZmRlRVlSa3RuaW5ESHhTWS9qYjdmYzREQTNZamIrL0R2TGo5NTdqQzQz?=
 =?utf-8?B?R1JMV1lpbkE0NDI2NWFOYWU1N0Y2MjRPSEtSRTNwOTg0dTFyeXNqdStBSDhH?=
 =?utf-8?B?WVFTajU1YTZ5TE8zRkNwQVRCRkp0dTl4ZFlVejV2djRyYnhjM0hlMnl0OGtI?=
 =?utf-8?B?Mm1SNTk5cVYyY3pBSTJVbXZrcHU4VGw2REgzeE1SZmNnZitwYVRzajI1cWxL?=
 =?utf-8?B?WFB5OXRBOUg1cWhVZHkveWJydVZKRUo0MTVycVd3RHE2ZDlWNVRFNldrVWFC?=
 =?utf-8?B?ZDdQSDZPeUptRkJERjhkUmhRaGNJaUFLdE04QTRGZmIwdHY1WWUraHZwd2Ur?=
 =?utf-8?B?WmlMYnNGNFFLNzVSVG95NTlPT1gvZFUzRFlmWEo1RVFyQm9kTEx6UHJ6Ym9o?=
 =?utf-8?B?RHBQU0dEZjNocWRYaCtwZXh5MGtEQ3lmTmNaMmVpd0JGWVJXUzRkMUZYUnF2?=
 =?utf-8?B?bGtiTUk2OXFZcmcvR1VkTkZmTjgxRE4zNmxOdkRPaXFuYnY2elRzQ3pUbC84?=
 =?utf-8?B?NkltY2d2RWJ2T1lHRi9xSjFYRjJGN25Wc2FaYWM4cGlmRUljQWFyeEhCUDYy?=
 =?utf-8?B?UFlUeVkzWG9xRzRRL2FFRjYzQm5BS0FyTUxrcG5KUUlxRGlrWDBHT001U0kr?=
 =?utf-8?B?eUJQQklET0VrZWtUNEpvNEpTVE1LUG5Xdjk5djVubEYwbDBhYzFwSFFvZStE?=
 =?utf-8?B?Z1BwdnFiVGw3VkNNRUpxNWUxNHZUNFBZVTVUNldFMWtmK2FieWtLS2lEVGlT?=
 =?utf-8?B?bDNMUHhsWU94UnJnbmVCQ2ZIN1NYQks3YlVqdmJNNjJyUllGQ0JjZDd4K1JT?=
 =?utf-8?B?NmtrUmFrVGI1QUtMV3I0cUJ3MVFxQmtpdGl1Z1gxRzdhMERNbXQxRWdoU2FC?=
 =?utf-8?B?VGp2MndOQkZUSmRJa2lTK3pOTVRRSmtnT0pZd0ZXbDA4M3hHVDF4U3A3Yy9F?=
 =?utf-8?B?SWFuck9qTDZwdng4aHdOL1I2bDkxWFVPUjQvVXZRRDFvSEl6b1lhN1JxbDZR?=
 =?utf-8?B?L1l5akN0ZElmbnBKb0xlKzRrV0I0RHRES3pEQzJkTEEzcHNKb1RMd21FTmo5?=
 =?utf-8?B?TVhjVDBySlpGNlpoVEpXL09LMzdpZDducVdEWkdFWHA2Wkp5RkFMc2xBaHQx?=
 =?utf-8?B?a2l5RGhValRwRGYvNER2SW1icTFOKytIb1ZrdUs0YVpIZXlDZ21sN2ZxZkVv?=
 =?utf-8?B?ZjdQNk9mcFltOTVkUXF3eWo2bkJ3OVJEb0t6ajBOQ1RzdDduOGpnSW5JTUp2?=
 =?utf-8?B?cGZhWDRiNVI2OTZFbXgrL01jdU1HNDdJbG9LdCsyNXU5empRaFlvNzV3ZjBu?=
 =?utf-8?B?aFlJWlBLVVF1VjVKNW9vL1Y2RHNZVzJXcFFodlBFWkxTc0RUN1ExbkpwNHVR?=
 =?utf-8?B?QU1pbVFDaGhqeitzNTAvVDNmTExhUVFQTHZoVjB4SlU2TmxTejYvZWJlWllG?=
 =?utf-8?B?UFNhNXE5L1BVOVhGOU1pVVV3dGFpQmJIYjIrY3MrQXBWeUJJZzV3UWk3Uk9o?=
 =?utf-8?B?RW1Rc0pRcERLMVRSMG03dEZPaVZHZGE3UXpsTlF4V1R5eGM3ZFdnVzBGTVlG?=
 =?utf-8?B?c2FMM0orblRpZE1LZUlxSUlXMFpPYUcrRW1NVFN6VS94YnNoMzB6d2M1SGdl?=
 =?utf-8?B?KzM3VWw2bmJzRWNSWmhKOE9aN01VUjNSUlkyT1c3WURaa2ZLbFpEaVE5SlFS?=
 =?utf-8?B?czZvRThlb1JsbjZyNURVQ2xCWE8vR0J4UEllYS9MbDI0eXUxY2R5bEVlWUNN?=
 =?utf-8?B?ajVPUGNCQkpoOEZMVktySFdtS2lISVRlUG1IKzVOTzRBem5qK2IzNTlGcmxQ?=
 =?utf-8?Q?w4epKrQpZwuIoZtCXktzyfKYDMZ9wnd7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(10070799003)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWo2N3VnOWYvcVg3cE5WYmJ1MmxJdkV1eTE1ZHFIaGNZM2R2dXQ3K0JlN2E2?=
 =?utf-8?B?bnVSL0VQNllSVkFNREJCTVdMdVk4NnRrSVdESkJMSG1MdHcrTVZWcjk4SnpE?=
 =?utf-8?B?UzN4TVpEV09FZUNVckVZZHhVc1NMY0ZOTjJzZmN1VzhLbStoa09KSlRUSk5o?=
 =?utf-8?B?NmVSMTM2b25TMHlPQnEwR3luN0Y3OG1jNURIRTVVaSsvdUhPZ2hkS21IZ2RM?=
 =?utf-8?B?aGY1N1JidW94bjhhUTkrREZSTmNqaHFiMk1NSWFJVGdXK3d6OXRmT1pTVGVD?=
 =?utf-8?B?M1ZHMVJ0b2QrMGlGeVpFT1l5dHBmUmxDdDBSMUJIUVJvSEcyUzVFL2Q4emo5?=
 =?utf-8?B?TTVGVk4wTHk5ZG40b0EyRURJMG1iVitZdnAwWW1nNk9UempBVHc1Q2lPaC9u?=
 =?utf-8?B?UHQ0UjY2M1dDQVNTTGM1Y0NaNlphV1lWd3UrQXdZZVRSZVNQd0ZQbzNQdnYv?=
 =?utf-8?B?bUtVMWQ3bWRadXpQNWU2QVg0MHc3NHJFTU04VjY2eXFUbWRwdStkNW5xQTQ2?=
 =?utf-8?B?RUlBZmVjQ3NYSDJuaHRMVDZJMjg0UnhjZENRV2hUT01xQlEveW1EaVJ4NnQz?=
 =?utf-8?B?emVpT05wMlNOZDBBMXJiNkI4eUllTnlRbVJZeTZjaWdBQ0pGU3lxK2wvWVNR?=
 =?utf-8?B?UE5QNGJqdC80YWxQWUd2Q20yT3llZElJaDN6NkNTSFE1VkZYWEhBenBHOHFD?=
 =?utf-8?B?eHVIb0o0SGJ4aTl3d1RDdnE1ckRNME1LaE0vb3FCNjcvd0pnSkFkTnR4MXBT?=
 =?utf-8?B?b01xUUtKL1FveGJWMUxSZkIwcXNBSlJlSFQyN0NPaWlsa3IrbWdkbTllOGhB?=
 =?utf-8?B?azBhNERUb0RDM0ZETE11K3YzZ3lER2FuaC9URWsvcjRqN2pTZjlWNjJYakZq?=
 =?utf-8?B?bHZENDc1V0l0eU16Ymp6V0FCckhmRWUrTG9vNHllOW04NGF3Z2hTd29pQ1hw?=
 =?utf-8?B?OVFqMFppbTJqTVg0VFNvRXkzaDgyTmYrV3RkcEJFOTJjMjJJNVRjZE5QaDB3?=
 =?utf-8?B?Y2UvR3BjaGU4Y1UvTjN0YTNwRVNSdFVmSE1QVFJDaTdQWTZOZk9wdkxWbGRI?=
 =?utf-8?B?RytoV3VmOTVZK21LdHRNVCswaTJSZ0ZDSytNamp2RUVPL2ZldzM3WmxEWWJr?=
 =?utf-8?B?WkNKa1VmY3RGamY1MGpHb2FxR09EZ29UdmhkSEZZYkttYzN5SW9yOW1Kb1h5?=
 =?utf-8?B?anVLRC8yNDNLaDlrWWdvUk02bTFrRVNuM3U4Y21wVjJ1SCs5b21FT215ZXRP?=
 =?utf-8?B?NTlpVHRQU3hHTHE0MVB3U1ZUM2pCY24wWjdtUENTOFRiMFFtS3BEWGZBeW5B?=
 =?utf-8?B?TmM3WnVUdzNNa0VMeW1ZOWM2b0RUQjBaa0ZRVVV0WmxLSUtKUXRPRklKWDdi?=
 =?utf-8?B?RHk4Nk1MdExxQzQyNXE0VU9lOCtJb2pqZ2FZaEVLWEhlN1dwK081d2E3c09n?=
 =?utf-8?B?YUo1cnYzdlU5MmxtbnpJaDN1S256UGRISWJDWHR1OTVxZlBZVmxJdUI0YzhM?=
 =?utf-8?B?clJxNlh4WUlieFdZSGZiZDRDSW1UakdiOVd2UjlhVVY4YllaOXFLZkZzWnM0?=
 =?utf-8?B?NlpoQkJHUjNEalE2L21UWnY5TTlKSzlTNEY3SGhodnBTTU5ZYTM3YzlsRUJa?=
 =?utf-8?B?YTJQc2VrUTRncjFpUHVWSEZpTjZCRmQ3a0ZXdE9qNkRBaXZwRm5ML3c3Y0VC?=
 =?utf-8?B?Q3ZMQXVvNGhkNGJHNHhRWmpuZDB3aXFrQzBrendyNldyUUNsQmpSOTFRYk5C?=
 =?utf-8?B?OEpGaUplZG9uWjAyK1pvOEFiMlhMVVVyTHBTNUVJb1JRZGFaaG9xclRWU3BO?=
 =?utf-8?B?K0FXSGFiWFM0STdKTGZLRkFTZlBmMG9wbUJ3d09IdUZ6cmRyaHI3MWdoQ2Rk?=
 =?utf-8?B?QkZyL1ptZ1lvWGk1enRUdTNUSVhvTjkxR2pWYlNtVStsWEVzekdacWMzMkZp?=
 =?utf-8?B?RjhTWFludHVNOHVrSUJKTXY3SE9KMEhPaXpUYk1pb2xaTU9ZaDQ0Rnk3VnZS?=
 =?utf-8?B?UFFXUnZMWGMzYjZrQXQ3bTh6eFhOa0dzZmtzM3doMTRSbFJON25kbzA3WlNJ?=
 =?utf-8?B?U2RQVWRSL1JxcEpwSlg4b3kxSllzQk1NMW9xRmtiUnppMUxlRzd1dE12UE9H?=
 =?utf-8?B?TTJnOGJQL0dnUFRhKzk5OFlLdW9HeWw3QzVZNXRFU2VtSExXd2VtYXo0cXU1?=
 =?utf-8?Q?6MinqyZ987h2YDmkPby33NeserxMrmKKSf3+VuRqXnSL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb15002-0217-4419-ac0c-08de2ba6d568
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 22:14:27.9533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7feMcEDcbyFnSurn6D/vdg6eoDt9BM53q7s8By1679nUpo8Aho8k59w3shx0HUqDTgbhyQ8iokfBJdG8qAXbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7865
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C966840013
X-Stat-Signature: oc9mhgqdr8ntmgijbwmxo7hkuuy6wx9w
X-HE-Tag: 1764022473-458453
X-HE-Meta: U2FsdGVkX1+Mnrn3fHXS8IL30L6MneR2I1FRK+MiyijhNnjiQSk7/wkCgS2R67C/Axe/pnEBIZw6GGG4fuWppOjPglPvcf0M0xLFep7lB2Dqd9dSDEGuOu96QUgHOg/fmsMbgx3+0CWbzZcmU3BVEqM84mmZZ5IzJhWh7T7Qha+xEl3Eoul2U4B29C9t5HotMryKgROlnds1VxoUmOIwmY9ffFfs5LALaXp5fqoFsbOt+rBgBZkPdHTd9HnaTx6tTIk5pNG4+xQUcnOwZy27DoMBmsxx1b7Sj/cZ3kLsyawtxZmIGc+Ov9OjfskQ4v1U8PtSzZQBiAS7qJRvaFIE2aaCqufnE3YmDrxSk3qhibzLTMfcCD+Yo4doeDoQTpAXBzeqm6sHgxbQdK4tg3+i5GC+mOXUNsOh6AfVZ8Cl15uExCzKZEkpp438vWtABnrlXHQDmkp6Wc+6fypCboXx48DKICWb2h902ieL3Cvtfh17miD+Je5CclINXAqwfBwlVLTR+2TeY6aoM4vElLh2PT0YsnW7ROibezueunmH+9GGppGRFvzHiJ800tu8wY4Z525+af9Sj1ezc/RhQ3OHgY2pPt5Qaqa38gz2PDSDkNEC4c3Y5b7UkeBq+hv0v4fT3TgFgq4rIeLTYpr0nhc2JJ0gq9eKqzpi19fiHtvHuhmTgA4Fwa4KlRVz2hoIw10dC7ShFdb+WlHVqWpnFPce89hOMPMkSIgjzobjgTAkpAW0jMW5Hiinq881hxF3GQ6B++C8hDtDYxeR1VUIuf9XddjVFJ7+eQZ1vRkUqPQ71I5EY8cAKbqrpXQfybJken1NkO/g4koxTNIZGRcEjVvWGcUkfdaq8GeSB3aU83rvHIk/01GB0K4ys7m6SW+JFeWVxjjxH7PXTFQZx+E9AEwK4glYL4jU2HppQJt/rgaDqtZjokzdVK3jNaleLIBg5p129GvLR5zWCa6UJfJ5nU5
 c2+LD9WX
 5L6hqH7PS67jE9PJfoImNduPTfF4fDXWpI0iZD5ax4ODd0VWSc7v3tl9fmrtnBS/qQWNHKWm2GwJlg6AjgzI/P3ASAmPXy56Gf30uUq1y7yIkzut9W2FWq/lqUF+lcAvTf5pIBmzYIsYlGaK4RLxKbZHbbszcc6NM4rnH5UgTkbfWpCofJpclFyMc1nYA2rktcvS/WBLztmY4qu88Jtfm+neNxLharNjNLQRlsCjX8a/G+S1VVID+AhkBzQR/aZ6D51TeckMge0561tPzhv+tXBPtT/rrgGyLUVSM2bbeG7HTsOLEM1VM7wV7aQPPSkmntYULg31q4ZII1SNIJsuzyIydkWGctFkyDsamjSYT87y1/xEkvLse6JYn45JKN+xz1E4RIINhD7kXQxbowkv/xI51ohv55/JiNI/7W0Fg3oHETMyb2Kq/gNJ9ZblHunG2zaKQKKkWpwL6nbBG0CtssQLa9XV7ZAcuGQlYmPATQmzmLqUfYPCLTM628KkL8jmsbMIVQ31N0mWfV4IrKF2UR9cT1dSXrplJ/OYJu4FbEyuy1uAWGDM1QuQOik72R4L5rqvHe/kCI3jmfgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 13:55, Zi Yan wrote:
> can_split_folio() is just a refcount comparison, making sure only the
> split caller holds an extra pin. Open code it with
> folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
> used by folio_ref_freeze(), add folio_cache_references() to calculate it.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h |  1 -
>  mm/huge_memory.c        | 43 ++++++++++++++++-------------------------
>  mm/vmscan.c             |  3 ++-
>  3 files changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 97686fb46e30..1ecaeccf39c9 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -369,7 +369,6 @@ enum split_type {
>  	SPLIT_TYPE_NON_UNIFORM,
>  };
>  
> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order);
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c1f1055165dd..6c821c1c0ac3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>  	}
>  }
>  
> -/* Racy check whether the huge page can be split */
> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> -{
> -	int extra_pins;
> -
> -	/* Additional pins from page cache */
> -	if (folio_test_anon(folio))
> -		extra_pins = folio_test_swapcache(folio) ?
> -				folio_nr_pages(folio) : 0;
> -	else
> -		extra_pins = folio_nr_pages(folio);
> -	if (pextra_pins)
> -		*pextra_pins = extra_pins;
> -	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
> -					caller_pins;
> -}
> -
>  static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
>  {
>  	for (; nr_pages; page++, nr_pages--)
> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  	return 0;
>  }
>  
> +/* Number of folio references from the pagecache or the swapcache. */
> +static unsigned int folio_cache_references(const struct folio *folio)

folio_cache_ref_count?

> +{
> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
> +		return 0;
> +	return folio_nr_pages(folio);
> +}
> +

Does this belong to include/linux/mm.h with the other helpers?

>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>  					     struct page *split_at, struct xa_state *xas,
>  					     struct address_space *mapping, bool do_lru,
>  					     struct list_head *list, enum split_type split_type,
> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
> +					     pgoff_t end, int *nr_shmem_dropped)
>  {
>  	struct folio *end_folio = folio_next(folio);
>  	struct folio *new_folio, *next;
>  	int old_order = folio_order(folio);
>  	int ret = 0;
>  	struct deferred_split *ds_queue;
> +	int extra_pins = folio_cache_references(folio);
>  
>  	VM_WARN_ON_ONCE(!mapping && end);
>  	/* Prevent deferred_split_scan() touching ->_refcount */
> @@ -3956,7 +3948,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
>  	int remap_flags = 0;
> -	int extra_pins, ret;
> +	int ret;
>  	pgoff_t end = 0;
>  
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> @@ -4036,7 +4028,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	 * Racy check if we can split the page, before unmap_folio() will
>  	 * split PMDs
>  	 */
> -	if (!can_split_folio(folio, 1, &extra_pins)) {
> +	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
>  		ret = -EAGAIN;
>  		goto out_unlock;
>  	}
> @@ -4059,8 +4051,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	}
>  
>  	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
> -						true, list, split_type, end, &nr_shmem_dropped,
> -						extra_pins);
> +						true, list, split_type, end, &nr_shmem_dropped);
>  fail:
>  	if (mapping)
>  		xas_unlock(&xas);
> @@ -4134,20 +4125,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   */
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  {
> -	int extra_pins, ret = 0;
> +	int ret = 0;
>  
>  	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
>  
> -	if (!can_split_folio(folio, 1, &extra_pins))
> +	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
>  		return -EAGAIN;
>  
>  	local_irq_disable();
>  	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>  						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
> -						0, NULL, extra_pins);
> +						0, NULL);
>  	local_irq_enable();
>  	return ret;
>  }
> @@ -4640,7 +4631,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>  		 * can be split or not. So skip the check here.
>  		 */
>  		if (!folio_test_private(folio) &&
> -		    !can_split_folio(folio, 0, NULL))
> +		    folio_expected_ref_count(folio) != folio_ref_count(folio))
>  			goto next;
>  
>  		if (!folio_trylock(folio))
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 92980b072121..3b85652a42b9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1284,7 +1284,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  					goto keep_locked;
>  				if (folio_test_large(folio)) {
>  					/* cannot split folio, skip it */
> -					if (!can_split_folio(folio, 1, NULL))
> +					if (folio_expected_ref_count(folio) !=
> +					    folio_ref_count(folio) - 1)
>  						goto activate_locked;
>  					/*
>  					 * Split partially mapped folios right away.


Otherwise, LGTM
Acked-by: Balbir Singh <balbirs@nvidia.com>

