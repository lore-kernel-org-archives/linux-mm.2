Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A2F3D33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 17:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9354D6B0092; Thu,  5 Mar 2026 12:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3216B00A3; Thu,  5 Mar 2026 12:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6696B00A6; Thu,  5 Mar 2026 12:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 678786B0092
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:33:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D0411B6FBB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:33:06 +0000 (UTC)
X-FDA: 84512705172.09.B181842
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 12C7040018
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 17:33:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EFtcKv0s;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772731983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp/wRZgfQB4QDhqrCSoGnF2BkptrbPVP4GBP3vhAVoU=;
	b=XzahSHSFzFknxBeS7Y/zuJNA3vmvdoUglfPHSVGQijWaVUkL28qKaPwfTNW/VxPYUNpnCO
	oZGOcxV6EYlxUd/R+1xI383k0gWaWlrH6BljOjDx9huUrNYMJuHzCgTGVZCptsLaeb7j/h
	5kHHNeqYQeAqZSrqH3Dm18QXyF+TzRA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EFtcKv0s;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772731983; a=rsa-sha256;
	cv=pass;
	b=Z+2um7Smzn2pJt8MprZdODFfFu95p8dZvw5MDx6o7YG8MXUgpkkwe147435YpBk74CHPvP
	klOqcz8AJVCgBOig60l4Av5oNYUo4SSWw3RPUKNOhu1bf6XmImjN/Q1bv+bdMsMVChYdhd
	I/pizPxKMYJi1Dam0C4t3mvk+E8tnDs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3u+sGk8xoM2XEVtYWdtPREEkb5yCp/Qo2V5pmvzyfiUAlXfrmcldbDw93cw+LEHYFd3wZZwm26HDkfDEzwS57j1H0QU6K6DnZZsuX8TQxiXRvixQ5AIyrhtayT+z/fJnAPfgqfOv6b6LriZ2/8Q7pmkWUQJ2efAcpWYYi4bpdn7jLywn/GNYr551H5kF59M+QG/y0IvD8SxQ0bEkqiPL46uohmMpUIXV9Ljfc3voCTidGDkacvyBy9XvsIX/cju7Pp3zG8pKgsqpB1dhLEK7SJ8LuBmua1DTy4OYuAkfVwvzPf6IU9lSIXNDUBmbLclDGcdYduWo9+gZTCh1FzRZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yp/wRZgfQB4QDhqrCSoGnF2BkptrbPVP4GBP3vhAVoU=;
 b=qXhyGMa7l4weEDKosfNBZ9tvm6E/8aPbiGANToZMSjmGEnbdxNEWZMDXkr8XI1UP6gZwu/ZTRHzlhCORYfT1FCs+t7uc1/QbvP4gogKj/gdqM/eNLIuT9dugcyl9vczQcWsW7ZYHwJSOyvfgyTEr2MADTOB1rrDqIh/yyNQdYjFTYGF8q2SMrHZi6Qy4iF2B0VkuGsWA+CO6LKj4rczGCvyu1FDXGDcnDCiuOaue/EcjhyceUc24Nw7PZyOjj7HWqfzLpJlSiOpdvIwawg2eQWCLdRTrugB0RAeqj3SyZANzqSIpg8s7gVXS9MbVZHWzWgkTqIRDrdSek9F50IaxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yp/wRZgfQB4QDhqrCSoGnF2BkptrbPVP4GBP3vhAVoU=;
 b=EFtcKv0swp8+V7dVsAUfHi6+EhnI0VRh2aAqJSOVhUNPA7lVWT7w64ixHw3AKh7P1ufWUGPq1061I7byRUcKJpRNhFdvre40jOH4rOXGE1Flws6OUx/zn5p7ZxM/KmzBCZeM7pFWg6OdvDaEkkMu9YrJ2YWyWIqAnrQ1VAKSY5wxLOB1QmclM+iCvPxl8XpEavo+40sQhnCrylSNn5YXwxL0UzHee3UASfR8ZBJIgAplE9Co57pOkIDTIg/FjcwmYuqg0x0x5RKEg8WTbJ3v1ikF5SWxHCkzcC1Ed6ZXIWf6tWLHPTR9b79Dak5Y50+EnwQyS4i58MPcdpx8OCXlLA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7511.namprd12.prod.outlook.com (2603:10b6:8:139::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18; Thu, 5 Mar 2026 17:32:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.020; Thu, 5 Mar 2026
 17:32:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Balbir Singh <balbirs@nvidia.com>, Kiryl Shutsemau <kas@kernel.org>,
 matthew.brost@intel.com, npache@redhat.com, david@kernel.org,
 Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
Date: Thu, 05 Mar 2026 12:32:51 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <1EAE2E58-7A71-4B59-B1EF-3A3C753DDC1E@nvidia.com>
In-Reply-To: <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
 <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
 <FA698C89-7287-4615-BDC7-5D1F6CFB770A@nvidia.com>
 <5e59c077-9f06-4e45-86e1-ca696e6105b4@nvidia.com>
 <622eb392-8c04-473d-b42a-ecdc489799c4@linux.dev>
 <942f2df4-6fb5-415f-b7d4-87a83315890b@redhat.com>
 <f427c5f7-93d6-4eeb-bda6-5e40d42f2bba@linux.dev>
 <80683d6d-ea38-4326-af5e-e4c173bb1930@redhat.com>
 <332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linux.dev>
 <CDBCA254-3E40-4BFE-81DE-70DAC9D4222D@nvidia.com>
 <7996d5c5-24db-4ef2-b88a-1b9d33f9e976@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7511:EE_
X-MS-Office365-Filtering-Correlation-Id: a54a0f2d-0a29-4970-7ee5-08de7add3d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	uAAuEi7HE7VXXGUz9j42WYLxwoUULeGdRz/fKaP/uYrn/KuVstbdN+19eC/w0OukvyMjSpbLUhUiLIZrBPr/hbwYB7hHVXbm+CJn4gkPpqEEkbalT+TRknEAPiGxGdYg/sObDpaFgiiSGXZq37VEh7ASYAjPNACS6B6EeBG9vXMUfKcF+7axUfwyUDHzMreDj27j2f95UDg9lsGJue2M2p4CXbjdnnasLDpCNnZqkr861AYLit221/IwZq3nx2+UaPMaUkyx6DIdv86GiHCWcIoOUEO4msL1k1KwjDDvrfWUP/102t9cSQkFbUTy+RRLh4IGNYOxjS5ZyQN51l/EFV8/oVIJxwxbfQbCm63G6HO+SML1hDLs8tWtffldWOx2qXEPhA0RUhzAv1MF7Sl0gS4GaBcO9o28u5+Vn6aGapfGz+QD7Li3Umqr/nnp1EOj7yUrPcYovWM5wncgZvLD3PwoiM0NTjPPcC4q1ZchhXxiXXpo63AQWd6Fam0C5rWjCIq2vhn+oFJQ9HgluQ2HyxI8ba6+lXxa7mPef+vp8GgzLc8UWFx8KZ4CMgdtjMWooicgfx0ustFbc+8mLxa684dWGV2yoR8aSBstUrc6LWKTSP90aAC1VHddnkG/cJ/S8JkwxvfbGuBn1NXGrjd82chVLg6bsomEYJZqmZmu+pboZydVNZe9lo2xPXZNleNAV1O4GQQ8fcNavz87tGGq3XrwliDgg35PwXjRvLYnCuE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGszamd4NzRxS0ZMdlhpMUZhS1dCdDZLMGtoUCtVbW0yYmt0VXlqYXF2a2pI?=
 =?utf-8?B?SFFYSmNQc1ZNeEVWdGRQRkd3WSsvRjFmNVBERVVIYy9VdWdmRWpYR1JCSUpa?=
 =?utf-8?B?Wlh1Z0pMc2tZLzcyQzBMNEdVYWRMKzAxd2RlRnB5bStNaTAwb0l1MjNlaDFY?=
 =?utf-8?B?Z1UzK0tmK3F6MGpyMEVHbkhmd0Q4MGFtcVpUYU1YOHdPV1FEanR4anp5cXEz?=
 =?utf-8?B?S256NlpWRTVpUVFIZkV2WThVSU5PU2ZKa1NpV1ljRE1BaE00cTIwT045dEF1?=
 =?utf-8?B?U3d3QitkQks3WWs1N0RVd2owcmI2d3B3dG9kd1JzSFk2OG9GdjllZ0xpRVZy?=
 =?utf-8?B?cmZuSkpBV0Q2MmVXejJZa0laT0l0Yy9pS3R2QTE2ejBaSVp5RWtsRUhSTmtr?=
 =?utf-8?B?czFhQXRlTnUzVXlYdXFtZW90QklYUE5NNDdTc0xvSnRjdkliSDE5UVpPbjgv?=
 =?utf-8?B?YkVlM0FZalo2T2dyQWJ6Y2d6UXFwZTg4TEI0RHJ3aHB3blBkY0tUclo2RExU?=
 =?utf-8?B?S1NCT0FScXV2V1E0TE92SUZLOFZndXgzRVdraWhEY09hRDRBa2RJKzlsRmFn?=
 =?utf-8?B?UzlqQ2VaKzhjUzM2aGhPRUoyckhNZ0doYXVhTFQ3NkMvcHo3V1JvU0w2cjZY?=
 =?utf-8?B?MGJRN2VWd1I4d1dkUnFCSTZ6SE5PSEJkN3dTZnl5T1YrYzZMNEhzYTVVUENk?=
 =?utf-8?B?SFlhZkovNEh5LzJBNHQ4dEJienpGSXFzU1Y3U0RuTXpiLzJ4QmM2STFPajl1?=
 =?utf-8?B?cW04aytiMzhHeGErRnJFVXdpdUQ1dzVOZGU2cldET3Q3RStDaUdwZm5xMnFq?=
 =?utf-8?B?S2laTjhJZlg4WEhKTTd0bzJOS0ZpM3JYMzAreWxaUlI2S3h6YTRDcVJCZU9L?=
 =?utf-8?B?MzFLWGdhaTVIK0JvQW5BZ0FRTUVER29WcEFOVHlZeDRoZWVlL3FFZWxqbWhG?=
 =?utf-8?B?dnEwU2Rjcm9vTEY4aDY4Tnp4Yit4QVdzMlM2WU1IdE11a2lYTm5VUG5oa1kr?=
 =?utf-8?B?dlZMYVQyb3prazliSGE1SWlicnEyd2ZHMUVYMTJMeEptMG1OSW9YdTkzanFG?=
 =?utf-8?B?UjNmOE9QNWlzd05EejRweURaM1BpWDUrL0pkd2FwemY4ZXNJc0o4c1FPR1ht?=
 =?utf-8?B?YXQ1ZHhObytwTit2V0xMYWhMeWFwK1pRRVEvT0I3cGIyYlEvQTdVallEWFgv?=
 =?utf-8?B?QzhHTGxkWTVUSDQ4bk9ldGJJQUxaelpVZzU1NlR6aXFON3BpZzFQWngwV0xz?=
 =?utf-8?B?WFFNUzRGTGsrUFRZaExTU1ljbWd4WE1IRHM2dEJXcS9NTHVPT2tsc2JuRUd1?=
 =?utf-8?B?QlFGbVBWQkVUaWZzT1RHN2RrME9rRzNCcXNlcGRBZjZidFBuSExpb1J4S2Zx?=
 =?utf-8?B?L21hVWhzNnI0TUxBeGVTOXJzaCsxNkozeHB2VERFNTN0aGZNWmVlY2JTbk53?=
 =?utf-8?B?cWtSeDhVeFdTQ25sUElVSnRXUHhCRkhUaGkzQnM2TU1lY05ScTdKQXdDelNa?=
 =?utf-8?B?alFKbnNTSTFKWHFERUIzaXBQVVJVS1l4eDVIZjF3MU1Bby9oSnQ4WUU5M3c1?=
 =?utf-8?B?dUFWRWZwcG9YYWhFSEVZMDUvZE9BUXFUUzlZc0R0dFoxN29XMk9TM2ZFU29y?=
 =?utf-8?B?cFFKZjZyL1dpQStLNGtTajJjVGdBWFA3TDIrYks4N3JtcjF4dWtkRytiRW5j?=
 =?utf-8?B?cm9rMHJDcUxqa0d1SnJubmpKdnJKazVOQklXYnRGSm9YeDE4eDU1RStRWElz?=
 =?utf-8?B?NUZqWjBGajdJcUtKVU8xTFdsNGtaZWljcDZRQm4vc01JZEd4a0dmaWxHM2RX?=
 =?utf-8?B?WnlkUTB0ZS9GRWJLSEZrRmFUOXdPNW92eDEvZFA3bHBKL1ZkeTIvbWJLZHl6?=
 =?utf-8?B?eGR2YVcvZVA5amVqM0l1ZnZLQWxoTm5nelk1UzRJNUR3R2hLWEdXcE16dHRY?=
 =?utf-8?B?Z3dqbmVCUFJYVEljWktubXhKYk9BWjJ6T2IvS0dxYlNpc3NsZEdVS3A4VmlL?=
 =?utf-8?B?YWx4TXI5L2IxanhUSzVGY0twUDU1SUNyUGVvNlRYakVoNEJFM2pCc0VLUld6?=
 =?utf-8?B?T0phM1Q4Tm9CTE9TTTVBS0txQmRHZFUzdUdmdVVRRjZUSWdKK040dm43WGRM?=
 =?utf-8?B?aVlTTmdIMS9jUW90U01IRHlxLzRNbTBLV1M2eWJKS3p1dGI0b0NQQXNqbTY4?=
 =?utf-8?B?c3R3M1RGS1E4a0lCRHlzQk85MDN2KzRFV25XVC9ld2thUVBSMFlUWnhJd1Vh?=
 =?utf-8?B?cSt0NFBWM05CMXkycVBnVVBUeTRtYnRhOUU5cTNodEpLQUFrNGtzQklRVkFS?=
 =?utf-8?B?d1pSS1g1bGQ2TnJRNWhFQVZKVHN6VW1vTVJ4LzMvUFYrUGE5NnZlUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a54a0f2d-0a29-4970-7ee5-08de7add3d02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 17:32:56.4342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x9u5rf3jpT0a2nJb1yyfW3B96jN4wK1V7UjOJ+yNj9ILuOoK7QPdHis9F+eLIrOY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7511
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12C7040018
X-Stat-Signature: tspj4smg5i1fcirxtk1wi6hqnnq8mak7
X-Rspam-User: 
X-HE-Tag: 1772731982-507730
X-HE-Meta: U2FsdGVkX186sxyw8CDLi889irFjzOIq3wD2QuCu69WyHlVq/rreO7q0mWF84kBusUX6SWG9Gt198mIhtF1A/BbKBoGid2A3lJ3TGLrqaGnvjo/HNXGlM0kJD52RBMsG9a2zFwuhmZeHx77qIWVmFV5chDoMZjWHWMdLZqdMhPmh0YP2RQ4gaiv8ZngBq0F9G4k0c4s0NWU9QhhgUEEFkpYQz9OUvLxR+8OvsNDLp8vGFT4CYgXqboOrOAaXOvEVwBdDeOaJkvbmIe2rz7TX3TtxWxgbOvtdfmpjPmdakWe+Px/+z3y+tY5u1eg0fxiRIIkTCIxX4PUyvKXQDrrtAhDgeELGWXopvGRUADCA0dqKcTAwDrThbAJvnYNCn3BWuUgW/5L7Qavfitp/PVX3qx9biLW4LsbIfMyffHC0DHKH697CpCBFRHrFZ5ar9mggNRVkPhc+1pmqzgh1N/j44+koCB6fyJxuofIpdhnAvJ4V3FKfUyNKMZUizEy8XLWjB1NF29sf+VPLRzim40FgKWgSG2lhV12gIyyFScRKV1E0cqDUfoWjcd3ZMNOaFGQHYFY62sOVZMple+QZp1aE9fDx3MezKx/GGIAPfJq8j9FPc4L5OS9gfiCWY751LA5AuXTfVaAnULwpXHg0nqCA5RO0SZb05Pl/otI52p+mumgpLe3sl3NCPh1WRitnPN/+/7TYq/UCqdH9bSdKg0VP0oMbBJg0qc32HAmXi2KH7H3b6IFShmSzWnWOyGS4gmPsWKdaj6plVdThjzaSX9EJ7C2BKlh8yaz/mUSbBbYrXekvdNCrx+IMrU4Duf3RETe53TEEvbpFWlElum6qsKsgZeXzYrMsnnOzMhGq6acO/unMloxaAYDihZWkbKct+t95IHEjetCNO7RJE0dqTaHTbmrmwKrJrS+lF9JSbkUowiKfMYj4w9k1RcbxYXMB9hOOxu4wk7GMixkRNE5kTRA
 Aw/+gPQc
 sHeV1il8tzb5XvAP85MqwmELf5m1AKDXAxsuQBYF5KfebYgzlu9JU66zndbJTsoyiDmTW2TKpI6MJZ2OmjQ/JeZ6dJSQfKH0x8eSy1R44JhGRsoUOvjrU9cUzLu67BSZxnqf8ZNXQ3RefuUJBVFeqeYyQpS5Jns3X28rBCBNzRu/cQj1c3d3g5gzbu02gI8keNw5HQR5ALEs1F6+YJnPZx/JmnQBDNeALDipIfOE9tZJDc3xDTs5+kltKyNCVPfiq6M+nD/nPMiGBLO3LxN+Ekx5ixej0EZM6ajPOt/uJlDljLS2qU8hfLXIhbPY4RGAwNkx3/gcZO4zSR+zqJKjwxHEVKF4Out2nayXQfMzkJ8nEGIgROoSX+px98SQ28od7FYLm9nW7U7/wjG9vJJTgyQBnaUzZxILd/ck6ZXqP8CyCtN7s719MyCkOba05hNyUfF0Ws7YasRfIIiQlbXKAd4YzAtihz13KiHORHMb/wxQZeCn1vqTw31WOa8f2hr0LfNAQEZBj9gALuIBoIzXiIMEjIwY3RqzNCKcAwxlthVvnp4YPsbfHpu3SHB7hW/oHPhe73YqFitM2nsd0gNx95KqDGBQSCuvF+XZHVHrkDxrVAcW/kNAAk9hhaGXrvEJxYSaXteqfsDQSoKUtL/xaXfMTk66Ljka/kmVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Mar 2026, at 12:00, Usama Arif wrote:

> On 05/03/2026 16:39, Zi Yan wrote:
>> On 5 Mar 2026, at 11:36, Usama Arif wrote:
>>
>>> On 05/03/2026 12:09, Mika Penttil=C3=A4 wrote:
>>>> On 3/5/26 13:44, Usama Arif wrote:
>>>>
>>>>>
>>>>> On 05/03/2026 06:09, Mika Penttil=C3=A4 wrote:
>>>>>> Hi!
>>>>>>
>>>>>> On 3/5/26 01:28, Usama Arif wrote:
>>>>>>
>>>>>>> On 04/03/2026 22:09, Balbir Singh wrote:
>>>>>>>> On 3/5/26 08:54, Zi Yan wrote:
>>>>>>>>> On 4 Mar 2026, at 16:48, Balbir Singh wrote:
>>>>>>>>>
>>>>>>>>>> On 3/5/26 02:17, Zi Yan wrote:
>>>>>>>>>>> On 4 Mar 2026, at 7:01, Usama Arif wrote:
>>>>>>>>>>>
>>>>>>>>>>>> From: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>>>>
>>>>>>>>>>>> migrate_vma_split_unmapped_folio() takes an extra reference vi=
a
>>>>>>>>>>>> folio_get() before calling folio_split_unmapped().  On success=
, the
>>>>>>>>>>>> split consumes this reference: __folio_freeze_and_split_unmapp=
ed()
>>>>>>>>>>>> expects the +1 in its folio_ref_freeze() check, and distribute=
s it
>>>>>>>>>>>> across the resulting sub-folios via folio_ref_unfreeze(...+1),=
 which
>>>>>>>>>>>> are later balanced by folio_put() calls in __migrate_device_fi=
nalize().
>>>>>>>>>>>>
>>>>>>>>>>>> If folio_split_unmapped() fails (e.g., unexpected pinning retu=
rns
>>>>>>>>>>>> -EAGAIN), the function returns without calling folio_put().  T=
he extra
>>>>>>>>>>>> reference is never released.
>>>>>>>>>>>>
>>>>>>>>>>>> Add the missing folio_put() on the error path.
>>>>>>>>>>>>
>>>>>>>>>>>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting du=
ring migration")
>>>>>>>>>>>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8=
HdoJGCEqVsVxq7DhOUB=3DL4PQA@mail.gmail.com/
>>>>>>>>>>>> Reported-by: Nico Pache <npache@redhat.com>
>>>>>>>>>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>>>>>>>>>> ---
>>>>>>>>>>>>  mm/migrate_device.c | 4 +++-
>>>>>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>>>>>>>>>> index 0a8b31939640f..351ecd9065d13 100644
>>>>>>>>>>>> --- a/mm/migrate_device.c
>>>>>>>>>>>> +++ b/mm/migrate_device.c
>>>>>>>>>>>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_fol=
io(struct migrate_vma *migrate,
>>>>>>>>>>>>  	folio_get(folio);
>>>>>>>>>>>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>>>>>>>>>>>  	ret =3D folio_split_unmapped(folio, 0);
>>>>>>>>>>>> -	if (ret)
>>>>>>>>>>>> +	if (ret) {
>>>>>>>>>>>> +		folio_put(folio);
>>>>>>>>>>>>  		return ret;
>>>>>>>>>>>> +	}
>>>>>>>>>>>>  	migrate->src[idx] &=3D ~MIGRATE_PFN_COMPOUND;
>>>>>>>>>>>>  	flags =3D migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - =
1);
>>>>>>>>>>>>  	pfn =3D migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>>>>>>>>>>>> --=20
>>>>>>>>>>>> 2.47.3
>>>>>>>>>>> Add Balbir, who wrote the code, to comment on this.
>>>>>>>>>>>
>>>>>>>>>> Thanks Zi!
>>>>>>>>>>
>>>>>>>>>> Just wondering if there is a reproducer for the issue and how th=
e fix was tested?
>>>>>>>>>> I expect migrate_vma_finalize() to be called for folios, even wh=
en split failed and
>>>>>>>>>> drop the lock.
>>>>>>>>> Does migrate_vma_finalize() do folio_put() for failed-to-split fo=
lios?
>>>>>>>>> If so, how does it distinguish between split folios and failed-to=
-split folios?
>>>>>>>>> By comparing source and destination folio orders?
>>>>>>>>>
>>>>>>>> We reset the MIGRATE_PFN_MIGRATE flag for failing to migrate pfns.=
  We do a folio_put
>>>>>>>> on the src in finalize, if it is split then on all the split folio=
s as well.
>>>>>>>>
>>>>>>>>> What we see from migrate_vma_split_unmapped_folio() is that
>>>>>>>>> it adds a refcount for all input folios, but only drops a refcoun=
t
>>>>>>>>> for the split folio. Isn=E2=80=99t it cause failed-to-split folio=
s to have
>>>>>>>>> additional refcount?
>>>>>>>>>
>>>>>>> Hello!
>>>>>>>
>>>>>>> Thanks for reviewing everyone. So its very difficult to create a re=
producer I think
>>>>>>> the extra reference would need to appear after migrate_device_unmap=
() but before
>>>>>>> folio_split_unmapped() in migrate_vma_pages()? That's hard to trigg=
er reliably from
>>>>>>> userspace.
>>>>>>>
>>>>>>> The fix came about when Nico indicated there might be an issue if s=
plit_huge_pmd_address
>>>>>>> fails in my patch [1].
>>>>>>>
>>>>>>> Below is my understanding of how refcounting is working over here s=
tep by step. I
>>>>>>> might very well be wrong on this, and the refcounting is a bit all =
over the place
>>>>>>> and I might miss a reference change somewhere so would really appre=
ciate if someone
>>>>>>> can confirm this!
>>>>>>>
>>>>>>>
>>>>>>> 1. migrate_vma_collect_huge_pmd():
>>>>>>>   a) folio_get(folio) -> +1 (collect reference)
>>>>>>> 2. migrate_device_unmap():
>>>>>>>   a) folio_isolate_lru() -> +1 (isolation reference)
>>>>>>>   b) folio_put() -> -1 (drops the collect reference)
>>>>>>>
>>>>>>>
>>>>>>> Without this patch fix:
>>>>>>>
>>>>>>> 3. migrate_vma_split_unmapped_folio():
>>>>>>>   a) folio_get(folio) -> +1 (split reference)
>>>>>>>   b) folio_split_unmapped() -> fails
>>>>>>>   c) Returns error =E2=80=94 without folio_put() which is the fix
>>>>>>> 4. Caller in migrate_vma_pages(): clears MIGRATE_PFN_MIGRATE | MIGR=
ATE_PFN_COMPOUND
>>>>>>> 5. __migrate_device_finalize(): sees !(src_pfns[i] & MIGRATE_PFN_MI=
GRATE), restores the folio:
>>>>>>>   a) remove_migration_ptes(src, src) =E2=80=94 re-establishes user =
PTEs
>>>>>>>   b) folio_unlock(src)
>>>>>>>   c) folio_put(src) -> -1 (drops the isolation reference)
>>>>>>>
>>>>>>> The split reference in 3.a is never released and the folio has a pe=
rmanently elevated refcount.
>>>>>>> Unless I missed a folio_put somewhere for the refcount increase in =
folio_isolate_lru() (2.b)?
>>>>>>>
>>>>>>> Please let me know if this makes sense!
>>>>>>>
>>>>>>> [1] https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqV=
sVxq7DhOUB=3DL4PQA@mail.gmail.com/
>>>>>>>
>>>>>>>> Thanks! Yes, the patch makes sense
>>>>>>>>
>>>>>>>> Acked-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>
>>>>>>>> Balbir
>>>>>> I remember stumbling on this while ago also. The folio_get() in migr=
ate_vma_split_unmapped_folio()
>>>>>> is balanced with put_page() in __split_huge_pmd_locked() (freeze =3D=
 true), can't fail for device pages.
>>>>>> Folios at this point are unmapped but have 1 refcount from "collecti=
ng".
>>>>>> After folio_split_unmapped() the refcount(s) is still 1.
>>>>>>
>>>>>> So it seems the code is good as is? A comment though would be good f=
or the extra folio_get..
>>>>>>
>>>>> hmm I dont think the put_page() in __split_huge_pmd_locked() is there=
 to balance the folio_get() in
>>>>> migrate_vma_split_unmapped_folio(). There are other points where spli=
t_huge_pmd_locked() is called
>>>>> with freeze =3D true [1] and they don't get a reference before callin=
g split_huge_pmd.
>>>>>
>>>>> I think the folio_put() in __split_huge_pmd_locked() freeze =3D true =
case is there as migration
>>>>> entries are being installed?
>>>>>
>>>>> [1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/rmap.c#L2334
>>>>>
>>>>>
>>>> Yes normally you want to drop the reference when installing migration =
entries but in this context
>>>> you have already done the collecting for the THP folio and you want to=
 balance with the folio_get()
>>>> the put_page() to keep the refs unchanged. Is that right Balbir?
>>>>
>>>> --Mika
>>>>
>>>
>>> Hi Mika,
>>>
>>> You are right, This patch is wrong. I tried the below diff to force fol=
io_split_unmapped to return
>>> -EAGAIN. I ran tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_p=
rivate.migrate_anon_huge_err
>>> to trigger the path for folio_split_unmapped.
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 8e2746ea74adf..6df33b4990a13 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4140,6 +4140,8 @@ int folio_split_unmapped(struct folio *folio, uns=
igned int new_order)
>>>         if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio)=
 - 1)
>>>                 return -EAGAIN;
>>>
>>> +       return -EAGAIN;
>>> +
>>>         local_irq_disable();
>>>         ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &fo=
lio->page, NULL,
>>>                                                 NULL, false, NULL, SPLI=
T_TYPE_UNIFORM,
>>>
>>>
>>>
>>> I inserted a lot of traces to keep track of refcounts [1]. Without this=
 patch, I get
>>> ....
>>>        hmm-tests-129     [000] .....     1.476233: __migrate_device_pag=
es: SPLIT_UNMAPPED: folio=3Dffc536e2c4100000 refcount=3D0 AFTER error NO fo=
lio_put
>>>        hmm-tests-129     [000] .....     1.476234: __migrate_device_pag=
es: PAGES: split FAILED folio=3Dffc536e2c4100000 refcount=3D0
>>>        hmm-tests-129     [000] .....     1.476236: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffc536e2c4100000 dst=3Dffc536e2c4100000 src=3D=3D=
dst=3D1 refcount_src=3D1 mapcount_src=3D0 order_src=3D0 migrate=3D0 BEFORE =
remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.476237: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffc536e2c4100000 refcount=3D1 mapcount=3D0 AFTER =
remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.476237: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffc536e2c4100000 refcount=3D0 AFTER folio_put(src=
)
>>>
>>> i.e. refcount =3D 512, which is correct as split_huge_pmd_address was s=
uccessful. Full output is
>>> at [2].
>>>
>>> With this patch, I get:
>>>
>>> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_FILEPAGES val:-5=
11 Comm:bash Pid:63
>>> BUG: Bad rss-counter state mm:00000000cfe88d5e type:MM_ANONPAGES val:51=
1 Comm:bash Pid:63
>>> ...
>>>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pag=
es: SPLIT_UNMAPPED: folio=3Dffed210c840f0000 refcount=3D1 AFTER error folio=
_put FIX PRESENT
>>>        hmm-tests-129     [000] .....     1.468315: __migrate_device_pag=
es: PAGES: split FAILED folio=3Dffed210c840f0000 refcount=3D1
>>>        hmm-tests-129     [000] .....     1.468318: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffed210c840f0000 dst=3Dffed210c840f0000 src=3D=3D=
dst=3D1 refcount_src=3D1 mapcount_src=3D0 order_src=3D9 migrate=3D0 BEFORE =
remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.468357: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffed210c840f0000 refcount=3D513 mapcount=3D512 AF=
TER remove_migration_ptes
>>>        hmm-tests-129     [000] .....     1.468357: __migrate_device_fin=
alize: FINALIZE[0]: src=3Dffed210c840f0000 refcount=3D512 AFTER folio_put(s=
rc)
>>>
>>> refcount=3D0 means the folio would be freed which is not correct. The f=
ull output is at [3].
>>>
>>> Thank you for clearing this up!
>>
>> Thank you for doing the investigation. Can you send a patch to add a com=
ment
>> in migrate_vma_split_unmapped_folio() about this to avoid the confusion
>> in the future?
>>
>
> Yeah this was really confusing.
>
> Does something like below look good?
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf024615..a302f9d3ce921 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -910,6 +910,11 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>
>         folio_get(folio);
>         split_huge_pmd_address(migrate->vma, addr, true);
> +       /*
> +        * split_huge_pmd_address consumes the folio_get reference above.
> +        * Therefore no folio_put is needed on the folio_split_unmapped
> +        * error path.
> +        */
>         ret =3D folio_split_unmapped(folio, 0);
>         if (ret)
>                 return ret;

I do not think there is a need to explain why there is no folio_put()
below. How about below?

1. it makes sure the folio has the right ref count,
2. it explains folio_get() is for split_huge_pmd_address() instead of
   folio_split_unmapped().

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 0a8b31939640f..0b31b878210ba 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -914,8 +914,14 @@ static int migrate_vma_split_unmapped_folio(struct mig=
rate_vma *migrate,
 	unsigned long flags;
 	int ret =3D 0;

+	VM_WARN_ON_ONCE(folio_ref_count(folio) =3D=3D 1);
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze =3D true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
+=09
 	ret =3D folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;


>
>>>
>>>
>>> [1] https://gist.github.com/uarif1/65e1e816af7aa0ae38dd6ec64d62a993
>>> [2] https://gist.github.com/uarif1/79ea9500667daa4e2ef09cb5d308f041
>>> [3] https://gist.github.com/uarif1/8a35a6c65ba8b3a1c1dfe72dc30e821d
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

