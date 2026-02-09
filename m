Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3696E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207116B00C0; Mon,  9 Feb 2026 14:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4A76B00C1; Mon,  9 Feb 2026 14:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BD96B00C2; Mon,  9 Feb 2026 14:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E82616B00C0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:42:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 917381B2856
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:42:45 +0000 (UTC)
X-FDA: 84425940690.12.86CE605
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9863D140004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:42:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hKkC9yBW;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770666162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qXTg91rdsejCAH5kPCX2hk58FjkkjMiJ951b8aHQHU=;
	b=Dr2K+NYMIGdQs3x84WPJSbaRLB0EUbkYIUGYCkr2wHr9aZjXyoIHxwB4JOsomemyEl3Mdu
	0fj1QJ6ZBnrQ9u8OQwnH53O16DxgOATE1t/xHJQS1qdomvEVK/iflOR5kRpAhE7yQOlPc0
	wSARxZr6lABGh40BptLPIN4lG7vppZg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hKkC9yBW;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770666162; a=rsa-sha256;
	cv=pass;
	b=Pg9fQH6xs9mIR2WYdnA64yuq5OrC63Bl+svdfbV+JQYbKCPaoGwpT+jgS3HfgLvtVO5xLI
	43GTvT9spvE02/RMUpzMxYYkjdIIRHKl/b+9whx7CY/oY0xIWS28aSw/m30uJ8LIrS85pA
	DGfdiZAGPIQWl05zHt0lR+0bpepA5dY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICTjjuIbVIu/ppeF++mWyCEhoX3/hsqpxasJZw4qNIdDdtaVSGlvY/piumxpV5JTbMFedmJde/s22P5XGUj/JhUeUTBmoLfjT1TElB3R6/jTJtTly5BCvcKN/6wcciHYiXTSzpvT44c5HeFJ+HwT5BRLoJPCZ9PnBR/RpgnWmlkiu3IZBv4JaWnzWeb37PkjBPCLUdn9f0jeb0DylQPea5O0QvuMIRq085Ix5qeOaDwikheBO2PIiZT2lbURph0XKHmyk8o7ZGTLGnaX1YCPn/xXdN/WfidrV190KsFAyO3RyHjf4Ss/9JpN8FOO//vW54wIiGhuIinwo48f3JUqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qXTg91rdsejCAH5kPCX2hk58FjkkjMiJ951b8aHQHU=;
 b=aRq7kmmyvBdW4vwSbxcz+Xl7k7rn694p8U/Odbqn6U0jVNzibmlB5Lgb9frEoYVmC/lhvXlwHQlcvBuq8kwkA0I0KzKB+4B2jLzEw7iMuNKWiLyK3zjiHpA/Us0eI438qKLzHr5UkGhliYh3OnFxO0Sw5WBjBoWOAuTNZJJ2bw/fI6Sce6wWdpklK38THZb4T3pxTiNAHxIkXxxYzkgKw4w9/lfMr8avtFaagD4HgG+NFzLXZ9/j6FafhKCiEVzK0pRZrhHP/DojRrMLFSmL7+gzrd+eZ2yX2Cj2FS1O1u+nqQgIJrZzEIrQDjjQN9erjfY/HxOPK2PERm6g+D6CQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/qXTg91rdsejCAH5kPCX2hk58FjkkjMiJ951b8aHQHU=;
 b=hKkC9yBWvr+tTDTWRW2Wkj1zuCIn7EtcmU0HHKZ1HZvvJsJr3EtueQc5AO+bGW+/5DuwScmJHbapYBzgNljqHrLYPUAC5GLEsSbMyiRW5XqduxapxcQXC5BzTSABWzm3winHvqUyF1bMbDm1//9uHM+pDVONmo3w2T/80KBuMvCQ3Dou1DGhAjufnPLL0oAs/zXM8xO/FIQUBElqQJUQocQ5J8SL8G9p5CwGf/pfnlYKylDRD1SB3Bs28OQpc0qPPLeJWALHQ5xfowsi/gbAn9v5VK+RMa0/vOZadMTx/Ex4/TMAVnD6ZhHZmhvMxGVZlp85pJHO0A6KlFfUcG2XAw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9642.namprd12.prod.outlook.com (2603:10b6:408:295::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.12; Mon, 9 Feb 2026 19:42:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 19:42:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Mon, 09 Feb 2026 14:42:28 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <72534BCC-2581-4BFA-B3BC-2CC6FF1B1E7A@nvidia.com>
In-Reply-To: <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
 <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
 <3E055DAD-647A-456B-9230-4DD2574D4E8E@nvidia.com>
 <4a759288-baf9-4fe6-9d16-034edf6615f0@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9642:EE_
X-MS-Office365-Filtering-Correlation-Id: d66b8352-1121-4b44-c2ee-08de68135f9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TIpqGa2Ju1FuhCVGYkiJfbTS2TTcw42piriYyVw3Dxo+/Bbr2KqeuOqRntxa?=
 =?us-ascii?Q?EPziBtifFOS70TuM9FlaPojN48ySJVHIJoB653X2hlReSIIikS7YnzGTVyGK?=
 =?us-ascii?Q?YDyjz7JsFPxGLsCw6rijlFAcxnV19YNmPgxT5PPFJlT+w6mXQenkR1RycRwM?=
 =?us-ascii?Q?7o7Mxcig1Akg1NKPInC417zB5GDyuZhtuCudRvyLTyCq4Z7FBnp8yE0sktrp?=
 =?us-ascii?Q?cGu6PgJ3xIOUpE7oFrocMSJ3Q9DOYeoAIsebGWFlz6/DpvnNDjikwkJWSrla?=
 =?us-ascii?Q?PGCPXm44fxHxtsS794MEd1Zges657jk57URR33NW28do3W3W5DDdpFH8JpqI?=
 =?us-ascii?Q?68dr6llS6W31cXWrlCKww7Qtdck5QPGOA1Q+UDHl4F1IXmZMckFQzvKGCWVP?=
 =?us-ascii?Q?Lpt5AbdCj+pSLUGZ6MClntJwWl7Xtc4h63ptbcQMeEGRo/b6fX4o6r7n+9CA?=
 =?us-ascii?Q?2IdDiv+TJJaiuklE2eNEL9fO6iqU+n/P5/Gpce99BGKzP4wMF50x5hyctOde?=
 =?us-ascii?Q?23RI+71V5JSK7EUy/F2LCvzrMjNxzQmjNFY4rTlvVascvCOdQdAsPsDwSFnB?=
 =?us-ascii?Q?lT9+ySZecLBiQkc/eJu/lfHWC7yTy6R9HekcBvTu/xWLnFblRnSjzB/FZpc1?=
 =?us-ascii?Q?Bl8K0LsK2txk1hg0AoGdQ84ct2+dk83bB/JDR1E79qvKyGjwLqdW6xuZ+nub?=
 =?us-ascii?Q?utOTKxkjyH4MOukmUOurW8GrUMTKOssisjn/EIk8HioRxIdbn7MWWzc88JnK?=
 =?us-ascii?Q?3qDejiIFqiZiF8JCrfaElU+pbrzOg0L+xbluJdnXwGcVRy8mCPeiKGVUCZ5I?=
 =?us-ascii?Q?Pcdo1vTnVPFHOViVvNX0FEGSqKgjuBD2vBB1hipeK2huzu2/2rp6zNGgnnFQ?=
 =?us-ascii?Q?vuBGI8Gfu96+tLq0qLZYkS0x3L5P1v6qRPUyxHRH7e0hpvsWZxyKmJH54W8k?=
 =?us-ascii?Q?f7qlfbhOd7Xc81ru5GX21lN8Xnt6+r8Ii4Oba9AptqG7KycVAliqsA5kyLgt?=
 =?us-ascii?Q?Q8p/YyxUpMvsQkwiHK8zIqPpvzXukvMXuyoFHwtgQreGh/kfe0Rtvz/9C/Lf?=
 =?us-ascii?Q?h7xWidTBf7qthQrRf/7nCzi/bplzajppZpEo8Z9+4KZU6zxaCZeEVzs2FoLN?=
 =?us-ascii?Q?3/u+vm+lwqmkrt+BYvUxN07WAhoSAibgRqj2V9pujDIWfTTSWt1OtCfBWdTX?=
 =?us-ascii?Q?KRGEsWzntLGhSmaNghZepSTWLsJOnn8ST95jBYTIqSZw9/y8f/YUgdAq+0YL?=
 =?us-ascii?Q?9MWIdH0z6S4MXzsVupAEht7JONMI4BqmlioBUy0iZqU/zF06ZWm5lfIHMbMd?=
 =?us-ascii?Q?9j1n5Yw9Xm7Fw+pqxalBGHaF12wTM9VOcgh3kCs9m2egLVccnyCTweKKOxG+?=
 =?us-ascii?Q?QtiERJUu5+ragOuRgSyVM+YHfkOdNg5Keze0TlGdIl9DrS9ScoybsMOANXag?=
 =?us-ascii?Q?9Jz3y/xoHZpsZpkSXrjxes8Itgwv95FC1nD2B1/ZhYEVP5o3oW76M4Lergp4?=
 =?us-ascii?Q?Ihp/hiaIyRY26zMzPyxRDKQoUGv2QEn0urXLgpoDQgpCkfH45u6zWoSfqDRB?=
 =?us-ascii?Q?KJPb1vXvwM1GZ8jZFrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vN7XFEUEFs/Q1yW6gtsCpR98QKsgeWLieCMuUg3vRt9BL/oxHC1xG7mqJT5g?=
 =?us-ascii?Q?y/Fkxwe7Ie5h5E2UyoU7neepwV2LL5nbRnUMPre2TiSbjr98hkd9nEjWJWCR?=
 =?us-ascii?Q?XgkZ3b4n9O48sNphqVEdRtIuf8N+54N8ewIVpqp6q0oq9zkpZfXe59yiLMMV?=
 =?us-ascii?Q?RvicyEBXHYlLKwgVXGPBlfYN0x2dc1ERpcI1J4EXR2EJtob6oIMR4uuug3kh?=
 =?us-ascii?Q?G/xrm1QCR4y9aJowUiyZuS7FJTM7uhgBmQpZeXmMeq8aXCj0WRh69T1QtNqC?=
 =?us-ascii?Q?UJSeWIvqJABv/+GEW89hVLMFwardThrTkfIgcTRrYlscZ7/FmFEkqqiwOfzJ?=
 =?us-ascii?Q?qd6yADGVgWsopj3VDSgfHFucnIPMPWnKgZEL85T//jJ8x3qrao2cN0ddHTSt?=
 =?us-ascii?Q?1kwRl0FErdw6sdidbSKgzkpgae1huB+4sQ448gxWPkEBRslLlEtSVS9YJFU3?=
 =?us-ascii?Q?SOgQ5xb3aZmhGgXK7CYddg5ZL3Jt+dWsl54JWlloYjT40cgd8rnMwnoM4/Vt?=
 =?us-ascii?Q?2LPhloQj16k9C473kPiWjzxARN6Sq3s21/SX274iaY4WI1HKy9pW5tC+nAeq?=
 =?us-ascii?Q?C2I7/m+QMy55zC/aLUrh7oyxVzksG6a3Epo9NE7AukNwrWXcDHl968e7JB+e?=
 =?us-ascii?Q?SQpOmSJVaLOl2frL1TmvIEbT4ix6dzV++FI2i/cRgOg75amm9c5aiP2pUoIt?=
 =?us-ascii?Q?E+mRCsNBC+6ZY9QSLp4/YxNInsgF8E15ikrQM2b1cKHT89POYV/CcGgGo87d?=
 =?us-ascii?Q?enxcuAc69C1yjLWPgHDrcYboZE5asAAiVGCH793rxKQ7fEp3opJC4q2vEh6v?=
 =?us-ascii?Q?QHsUf9jDrEPFbivcnpLZ3HVH2Iv45fmDgmjvYwmIv7Gmk3OdJ97Cgh9BVieR?=
 =?us-ascii?Q?Rkyh/8zuoKKJT38Ui5XlrNJ/Qm4XmB+M/Gu0DKjB8lkTivilNXcxmGYEm0WU?=
 =?us-ascii?Q?W5bpbjt9sVDUEaJyulC1+lb4TdSqYswLq7CgOd+rWiYA5GgmgdXe3uU0UnFE?=
 =?us-ascii?Q?PSDVLgMxkDgDxjzx7lfs8ATHVjXQIPu/1i2/JC+BiNJFuKM28IEMq+D45Pxh?=
 =?us-ascii?Q?e2NM6V8p/NobdhULdM8j2vqZJhPkZmUzZUKYhAWijYwvQTgUWLAXqrMGydMR?=
 =?us-ascii?Q?LAiV1vOCsF7IYwYq/HqX0cNNmkkbkeIhAdn/MsG5A4H+L1PuAluJqf7eDUUP?=
 =?us-ascii?Q?CgBLzmbvHv0sFKiFxDvBksKdAb9WIGIPz3KNp0+z9gRqaikMHFURi15HTgqi?=
 =?us-ascii?Q?/33X5WCe1I0uwVZv6UP1ubgcnBJ4Xd9if7eZ3cDMV7zD7dL6cbBJaQzC8h3h?=
 =?us-ascii?Q?FkuK460rvwcQui0Tu/rhwEZVwDS08Xn3s+XsHaV6jmMOi5CGlln1aiTcZeFj?=
 =?us-ascii?Q?WFOZCirq6WG7bOH3roTdtZJnxRkwKX7RfLFbpuLB3fGd60Rw2cUTDDYGSP9r?=
 =?us-ascii?Q?DpWkZ1zxes76IfMTvG8582avW6VYx6OBQ5qGnhf218sF5TrdSh3BeC/gKvp6?=
 =?us-ascii?Q?fb5C6Tdh6QUwFZv0KKrogOTqy3fopuyWW42rVp+VPSJdqpUYwdww6emQCCHN?=
 =?us-ascii?Q?Htf0NnnI6JEBgNXWBWahZSsCcqjfewwE7C3i57fVl8TDq8QH0WFXheZoHjad?=
 =?us-ascii?Q?ZzuTpJUGtPwmRMYoxt6wZIfX0q4bpzL80OktzonX+aryhXWFGHpuVxek/HCx?=
 =?us-ascii?Q?Ogzf29kC8bKtwyxYHMsvAkk2PAzxjMYsduo421spmRYjbS6i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66b8352-1121-4b44-c2ee-08de68135f9a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 19:42:35.2184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyT0Mza6ilUTiZusrpKDVDVzCAjIQI3qkXd0j9d4SsF26n8zkzhrYEr7S6hTLZm9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9642
X-Rspam-User: 
X-Rspamd-Queue-Id: 9863D140004
X-Rspamd-Server: rspam07
X-Stat-Signature: dn3aqx3mdxdqof9iwge6hsodb9xexfp1
X-HE-Tag: 1770666162-971476
X-HE-Meta: U2FsdGVkX199d0FSs5XDP0hGXEIEzfRyF1py/mt8JKFGY0KUeE94LXfH+T2vck9Bm45UEd+UAQyini6H9llFWv0PEmEhy63gWP1Gc8Gzp4g6kfwikW0th/2Q7ZGcvgndcwO/xg0viBlsH5372nMiyDPLF1fNx72hrR49DyB9UvU9aVGemrljHVSlWBmk5lJ1AWXrCoaFPVe6vTHiPvVWX3jW4LwHNyCLhh5KXJPxl4CeSPkHrXr8mI42asFHgjyCz0lPlB1q29PVsh1p5+TyqhyWyxxftPlx3rElxeK8b5E6JlbIfGSSWZljqSV/Gctyu4DTS8+0e4a0ttx3knbNVQgVFcr1m7vBasxcGVXJv/59GXFxa9spimVXHTGMgaSvqBlbC4j4bLrusoDwCaS3OfadUwj6auD+zoyhQkbCB7ZuZetABbUDjEOkV76BrwZ7pJIPO63kkFrCd1JYHWBENJbUkGIYjuyXdkfrG4smm4lP8ve8GusDyzPxrE6Ppvtg7qrl+/y02d6bdG6WOxQVKoG5xO9QT+4MBWFvs12YKOQ1IGauSzGo0OMKxMJtuJx92HxJ9KJdPI4ZYGp7MXV+PKL0PEbJyshgMrTQYLmaS63PjRJXuLTXmSRzubD9sb1eWbebYfPH7UPe8KRIAabztAknlNvFx3lhPLKjpx7Lbq1pWYQWmD2sBKJ9dwM9Vu16eJIZLXm/HcSaZVlTJb0uJKJ7Zeb7hSgwGSWrWw4gM9qRKE+2t6CQH+VcI5wjHho0GLkXpn/BTyyUixFMxNSVl+NVGoJRpeOSC1A8TB9h5/6pPkKBJpC4gCxDPlu6UrYG3nVVmJEqp/pl9uQHL5IP4CNeiWNOMUMAEG0L9KHyP0HJSzm71WQO5tXSXlUzfPOdW2ql/YgRrsSF2Z3+7cUWsMG2iByLMBuqxZzCB5+oNkVNrlaaMtWHkx12fg5p1Jsz1k3LdyG7hZiIb5wrOjb
 ee3wA7e3
 qLKgIHifSbI7D+LpY/Voa0GCY5NxjNTYpAF2Y2n1NhE4I6PuJMRtkD2HaiSrwVS5n45Dw5GK3ZfCpjlE0oRpy3NSaXeDjTpY6mFBACmKMCyS4n5hTDxUkaKi5yfhn6vO9zUM3DlxYeU1g6OZS1pj6qoN0QU7ZbxdsmN2oW0k0IWcvibgBfg86CJ6Xe2tDIkVgZnZgOupGRuC8DlUs1hFqIwVPbuUMnSKLj7loyD5IskGuoHeuU8wD9DJyBJ6l1e36kvDCY4CQQzYaSCjy2656xbrIUwxTemP3glInu2PpzveBK2ktB3tgx0WNk/SXZnng2gF+AVQmHNNkCctnheOSgWYvMAQaibRTNGF7NJCxis+XMhMCUeDiZTWwBvodXjuZRxZiCRS2ab7WcgGsEOvYseouqC9IUP++ORQPMRk2wCMj4ySn6+qNsouix8wX61oiP+PO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Feb 2026, at 14:39, David Hildenbrand (Arm) wrote:

> On 2/9/26 18:44, Zi Yan wrote:
>> On 9 Feb 2026, at 12:36, David Hildenbrand (Arm) wrote:
>>
>>> On 2/9/26 17:33, Zi Yan wrote:
>>>>
>>>>
>>>> I agree. Silently fixing non zero ->private just moves the work/responsibility
>>>> from users to core mm. They could do better. :)
>>>>
>>>> We can have a patch or multiple patches to fix users do not zero ->private
>>>> when freeing a page and add the patch below.
>>>
>>> Do we know roughly which ones don't zero it out?
>>
>> So far based on [1], I found:
>>
>> 1. shmem_swapin_folio() in mm/shmem.c does not zero ->swap.val (overlapping
>> with private);
>> 2. __free_slab() in mm/slub.c does not zero ->inuse, ->objects, ->frozen
>> (overlapping with private).
>>
>> Mikhail found ttm_pool_unmap_and_free() in drivers/gpu/drm/ttm/ttm_pool.c
>> does not zero ->private, which stores page order.
>>
>
> Looks doable then :) Should we take v3 as a quick fix to backport then?

Sounds good to me.

Best Regards,
Yan, Zi

