Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4CDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C33A6B0088; Tue,  1 Sep 2026 16:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874656B008A; Tue,  1 Sep 2026 16:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE3C6B008C; Tue,  1 Sep 2026 16:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40B5F6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:02:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88C664053A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:02:13 +0000 (UTC)
X-FDA: 85166264946.10.8C9FC08
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011053.outbound.protection.outlook.com [52.101.52.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id A085C140013
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:02:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HwFRAdtj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788292930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LUPwFus1GvRDU1+nlO5bBaF9pkltj4MUgQS9rq/O1s=;
	b=Im/sKKALYTu8aFOcA9+/uMiNcfNqj/LIKLZT4K8PwCG6/39oTWyT8tyyCeJecE4DXeGDw+
	iVpF4ZwmdATEaK3bP+gs+cTn5tIvJ30+TbQiiKrcEURJ5SkN7jvk9ZBf6Q7BFv+ptFAdNb
	v78b8abdlgpjhCiWmW0Zd+c40EaHDEI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HwFRAdtj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.53 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788292930;
	b=wgiyudVbYDxJEFoN64DuEjkDyAIZjLEOC3hn4E2X8NbcwZF+fAr8TagoZEJWFibbj7unsG
	3KlMECF8r3zuT4LbV4crFFl4RxKv+3eyK0zoFTmDsViWoq8TF0s3BjxlZDymrj7bGVqnIs
	KXTe9hePNgHgsLnKG1s4d3ZeMSR1+Cs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dGmkAqlLTXtj+0r/Dmn13+xXDDQO3W03Kb7EzNQoN+jsypIDclgQT6oPDLVNNodQHrxSC6YbfrFeS+er2liHAV/Ug60dWh8RTfQ+/NtVNWfJw+TBA0Np2ykEFr6BkbX5M5d/dBADZTnG2v66vqyJ3oKIYTNb6Gi80ufw3cDHYblyus7JIU074jDFejz9dLl7Dd3f8/N4J7RVKQ7p+hBPnUdngq6K9FY8ze5pqyE4S4KKfHk1x0YnEdwMs39s0JD+unZJCsToHfQ2P5tsT0fPPbfu+LK0iPgNHprqUVeWEHk7gaRryyBYEDZjqWZjckeRl0FL+URFx5bM8ynJO5pnXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LUPwFus1GvRDU1+nlO5bBaF9pkltj4MUgQS9rq/O1s=;
 b=Hc1GyZGyaHQ/CdjM1d/ol46IkTEM5Nr1EoiX+9JJo40psXWl8imDJLB6FqtDeUTriVo/T8LIYOTCAq9xgrGmZJALO8adX3pl5mwj6n1TdDSUFPVuJCUaHrq0b84fY1BivcOYD9PdT41/qx2rDPR0z+GZX+hxiv8SJlHLvqG5AEvrnHII8CVFNI8iG7vSnQbw1RIog3bpBGc2CX3HDBALvimKlHak64NilcZtirOXibwDBYd05oeYgmTwlVII+73Ec84otcPPZuDaoIFckUATs84C5ZgWNUCtwxoZ6Q+5+3lzkR2y2CC8RQvg1EzTuohKvdJVgwk/a7PQ/nNyonudIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LUPwFus1GvRDU1+nlO5bBaF9pkltj4MUgQS9rq/O1s=;
 b=HwFRAdtjljbfc/uFKGh1Wz5Fb3ueGSY/H/ZRnVkEyQMjvlJS6v+JuBMXgkm7CR8YL+dHUiiSm0DZC22+WPHedC7276i/ejUky9bMVXyisxo/qBn62VY+MbYQqiyWqLylpMbb9G2DqKxbT9y8Cnv1adQa0IDKI4w6H8NQn4UMiHy8CxXG7NvACy7IjHofAuUaUcwDIVI66Vq1gHX06ySmZDzZqFGKgCj3NsFRo/dWO8n+wC2ve5YSJCmPmFX1eun6LwghRNjkeWC6yROFBCWV5QiNGnv/3/YYLjOAGbhI2k6wCkI2UoGylhkeW6xKQbyUaeITg93vY5ibsH9HLtZaSw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7692.namprd12.prod.outlook.com (2603:10b6:610:145::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 20:02:02 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 20:02:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Date: Tue, 01 Sep 2026 16:01:59 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <F67B6AED-04CF-4A55-AE31-D09039A1D106@nvidia.com>
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
References: <20260901190123.3511535-1-noren@nvidia.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH3P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7692:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ece55b-550e-40a3-6e01-08df0863e375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|13003099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	+KWmxR1z4LcDoLC/wH6VDAkacT0ycoz30mhIqsorrhIGbn6foU3DQugKWzJyTWbPaPCd7M/+YiByViEtMXga+5nyNZ17rw3UizTlYQWVdLlIYp7bhY9pM2b7iNai3mYzXc6m0z3MVrWZfrnkc0caOTI95BP/zrSa08QvdF72zR5u9GuAqBawsTXHcfRXP8j4x6qt05jKaXZhyuFdYhRIg4aSPkUmJyYg+DaeZYSAnAfVWPjZ90m5+Ew9QAgkLb51o0LJNPpgX9np2ZLF559ex8YOaLeMETEMKB6Gw+eHXpE3BJR0yFDJeUPQCwlnGO3pam1T+u9K09qvrz6vvUOR5H9gj/pyQyNYSeBQQD4R+M9nSbsSbNTb+EifgnJ6AStZSmGqGR4VJB9dLeQu3nYywnNsFLyG07YUBqdg9Jilq8ZYGtLQgLRs4z6sj6/Yu8RgO+vUP6FWE7B5QAxWrZvmYimoxZ9F52Yp8NdB4Tqmxl8uTISaKNbPbjgYYhSWrGYl5yEY4+n6xhJLRMiYHuIfZH25SFB+FXpikcx5ckDoek4fYOxhCCbf6fSfbFJVGP8B5rSqaXz5EEHk3an8P3z6V3twPdHxLpKI8DLL5UPuJWw+Kof91C9uUOzYr8EIsZMUNnFFrvDA2ib0dZu0jfKhifOH746RzUNECV9sNylAbu8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(13003099007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rPK5/PgL02uvRKgnA6xFxB5dY4HN/AH27d48fmK4zUMd+THMRgOfc72H/+aG?=
 =?us-ascii?Q?gWpLWmmtBcppnV8ymh5Zn36bAtAtR2HjPXdrXJoYdxQEtSxZXIVpixaubtB8?=
 =?us-ascii?Q?E8MG4g3CnNBDyCayl1oOEabbJJxr4QLxBZOgOUF7wzn1m2BZ5ZzC0ehILKd/?=
 =?us-ascii?Q?xi/rY4j+DRYPzmMAI6jh/g6M3jI6m1E9cqPNAPdG5ENY7PSEw8o6S9zNEX4y?=
 =?us-ascii?Q?UrIN+H2uvW3nR1RS7Ft8iyldXDkGpmBRougpbD6pAnUi11HvQWtGlUUBZ1t2?=
 =?us-ascii?Q?H/OF0Zzn9pgOL1A4wswKBiUTUrBxBy9zzLP6rraPk5vgq0BCguJpNa5TEd4H?=
 =?us-ascii?Q?0w0zfsIs2nWS6uOx2B9DlCh81RBQn3TPq/wT8kdCTO/IaKxwuDcL6YH3VU+3?=
 =?us-ascii?Q?wUK1HhcTMMIIE4QT9bxW4+fnlYnxxJGwpLDBFIpBRuknM3iVOsYpLfKY2AsH?=
 =?us-ascii?Q?vZyqmXbvk9xxNXCuRoqWmMPUvbwaNlX/3KUSXHZavU6Wu2SVno2Nh1Uvxe6M?=
 =?us-ascii?Q?c5hXOzDOKwNx1e3RLxdf+D1DsPI2HRHunLbQCglWlqgsQHfSEhwc5WtL0zzL?=
 =?us-ascii?Q?YW8r8pDZ38X2pG9L5fo9IjEm3g9Nz/NhZUW6vEOQo2QMjvRchjqJL6H0THn/?=
 =?us-ascii?Q?0CmuqXbfjl4B8G0z649jY22b/kLXP0jxK0C22X4UL7wdo9mDnIl35XkI13lc?=
 =?us-ascii?Q?uOASNTrJ4mSlcr3/xiAhuITTYa4AoINfpulN4Gz4Rwx4/EWViOd+uu4B67Kq?=
 =?us-ascii?Q?ViGSXPoZftQidhq886ecuM45FXpXTcIBBusVp2WMt1CfQ7v49wGZpqxs8CNw?=
 =?us-ascii?Q?0AA+zX81Fx2BRwVjDXp5UcMEt8/NB8hMkxaMo2GARMWkVke1YCfOHsP/FisF?=
 =?us-ascii?Q?eNpDIeccuPcBHF2SbNknjZZCXrYOqqJHtLxfRNFqChiONHML//IcrO2GxUDl?=
 =?us-ascii?Q?ZPr4FqE8LByqqcw7cljh1bXtISNMlMQH7fUhbFOnngYMII4k4EGmXuXZV6EM?=
 =?us-ascii?Q?vkNblarlkSYjFmh5w4HN08uHI0zy+wpefA9QsjqM9/beOu6+RousVZWQB+gF?=
 =?us-ascii?Q?Jf0VXLSzMnOwgD0GTVhFYzL4OMmo+7M7dDjDZyYNd8fl4dye1K48rWK9VjAm?=
 =?us-ascii?Q?PC7K9C3t5G8D4Xa4oaCEj7T2Hoo8LTdZKfDPGXXAhzb/YzG2xaDyJT4dEWte?=
 =?us-ascii?Q?2j/blOO69dR5RXX9EjwVCxaHnoWMPQ74TstnZrf0ztB+12l7/aSzxzGAbJ6m?=
 =?us-ascii?Q?UR0BSD1/Zg9XlmlEW7Ms/HdrJlkwMJfD6LNCRdfyPoyIBKeBE283L9E4NkqK?=
 =?us-ascii?Q?qJtDMoG2bb3vDHk1P6EvStyJi4QXDKNe6qvrj3jB6D4bbqbEmUbS2/EfIj+n?=
 =?us-ascii?Q?uhXx4pr7AkbCKwHu+yb7Oq48CkjqppndcDqcFPI+UsTtyruiVqgHOYDzba0N?=
 =?us-ascii?Q?vLEvAT6gctinQZWhNQLgLNe/qVKkfW81HE1Fvz56JgDvhJ6r0J9lYfR3xXux?=
 =?us-ascii?Q?Ojfb1/+YI7ItI1STqhk9cE9S2+bPUP1V5Ake3R/+w3WjRLVAxFUJ1Rq5eRh3?=
 =?us-ascii?Q?K8LroN2gPyqb6oXyNWIw/MLiy2guhHzsHCZwq6/PHHgSPYDPzGvyO4s13+NC?=
 =?us-ascii?Q?Zq8121wiYwwhcB8r1yUc71xSlSMwKJ1bPm/J319+sqch0PyMVhSm4yzK5wz4?=
 =?us-ascii?Q?h6Z8XSJuG05qxHwpyJAFxGCwfq+nj/K6Euua/WfquXirPFRN+y+2gNBKpPNA?=
 =?us-ascii?Q?kv77HWXlXg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ece55b-550e-40a3-6e01-08df0863e375
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 20:02:02.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzQi4YI3MMP50RXAMeVivKqDbOjEnoFuko5QayCbCLndmfCVDZd02zfcif4PH3UH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7692
X-Stat-Signature: r5yh7ky9hhpjqdjrxcfyn6eoekbxwbfx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A085C140013
X-Rspam-User: 
X-HE-Tag: 1788292930-713044
X-HE-Meta: U2FsdGVkX19IS/LEoPraNBxZeR3dikJXtbJyw3o3PZHnTZAMCv5GQa7a2KrtnprIKC7V6Cu50cCrFVBsg+HUpI6A8w8tLquRUZeCnDh/64y5En36AjJf4Ri2gbjSko2WhX2mpcqSAF3ZV2u/4nvv91XATY5HtpzHvDIq3o3RZBTZ8sTlepC/wXrGDFgVDa6NJDgIbEx32+VMgVw7cFspTJojAFSnom1ii2csZu4Oi4G3mkBuuZzdk5ryp9P6zihqARamcddAjpLZQkNsLEqpp86sj5imlDYWQkR7tM/YyHGt6Elo+YWExxAU063hpccahv2/FbC2N0yaGh/POgy9+z6Tt0dSv3U8KqVJX8zESTErLiAcFhr1ye277AIQ6I8+Da8fj3VuSb483RL6aK8CTABHwnBROX83qnCh/8P23SG3XqfNjUmUdJnbg560NbhB1YAnnq0cLUk6Qe64IM8J6u92svQCzPr4/XEEll4u0UsH/5XZzPax6cTWIhciPaiVJUmqUmEqmX2RG8wLgT4V+UtK46Pf/8BFqbzfe6wjT3X0P5aj8WkZMcrEXrtIwSsAoHQIIVO7/D+dZjhuaOyYk6nJUcOcuGcOUL6NAAOvqpK3UcY9WOOrt/zaGM/wKd5dvbckk2lS80zFiIslNCwyamaqZ/ly4XQJPU1pX9NyXuBpk3yM9Yw8Vb7uMrK7NG4nR+Ipu6jmhrO+Yoik6gr8PWD1pttpKRHnk59yRuUP1DW/DND7cpJGyAyZyhfT7XOUGzO+rWjp9iUALagw3wXiZar+r1n68MLB8Lqir2KiLB7bGfGKwJ9fCStKxLSgae2OxVcfulKG+IZdgiGFdYK/xL0djssBf5aGL3c43ifm+H6aL3yBT+cwy25yltCtOa4r2wt8k6Hlp2L9twj8UCx2AqKuLSxTN9n/2nXzUT0tVsN+CIUfO+gdOyXgvc+a7R46ufJG2nwPp0Cz75PUr6E
 JBBhgW+Z
 IOMQDzcvdQ8+QH/93kVpvbhec0esZAK81iTkZucmK7f/Lr1pv4SjcWQElIvYa4zFsNm3msPs+D1vGwaOBavDVYSvkok9e9nHFZ6d7dRyKxPmD39YVAgN6O3b5MJgzL/eWdc8dYEIl7QRliXqaqRZjd0SCiWe6AE/20Zhgq6tKvakVrsbeiWRnKsZfiIP6n+1O/SfVfBVkvuAcq2TKgY4JJ3FUDZdheUOl1/ATv2B81LYMPdnu2w2nMEHrIzmB1Q6gG1ID/xw96ARoSRbRZq/XhKcEATDyj0ZQ2qUDWElY9/ki302LuacC1RDIH5gTj/FO+qfUiEXdcWOmGpNKvd1AJkUNOt3r6eTbBjWpxGydo6Px23SC4xV4da8NFKdcXjSmBSw57lAyHD8CDHLiblBiTXsADtmqqbY4S73yw77pHLySTTqm2PomB9lm3zmD8l2qkHXN71FFy/tgOoEoaLYbX215E6CV7fYp47CJuPIsTUnfEOUMbjm/AnhQJQJ5OxiYCaACBVG9ndygK70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Sep 2026, at 15:01, Nimrod Oren wrote:

> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
>
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
>
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>
> Even with that cap, min_free_kbytes can reach excessive levels.
>
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
>
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
>
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> ---
> v3:
> * Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
>   increase as suggested by Michal.
> * Remove all associated recalculation paths.
> * Make min_free_kbytes, user_min_free_kbytes,
>   calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
> * Drop the now-unused declarations and khugepaged's page_alloc.h include.
> * Drop the obsolete v2 documentation addition.
>
> v2:
> * Use a named constant for the cap.
> * Drop explicit linux/sizes.h include.
> * Update min_free_kbytes documentation.
> https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
>
> v1:
> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
>
> RFC v1:
> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> ---
>  include/linux/khugepaged.h |  5 ----
>  mm/huge_memory.c           | 14 ---------
>  mm/internal.h              |  8 -----
>  mm/khugepaged.c            | 60 --------------------------------------
>  mm/page_alloc.c            | 11 +++----
>  mm/page_alloc.h            |  2 --
>  mm/shmem.c                 |  7 -----
>  7 files changed, 4 insertions(+), 103 deletions(-)
>

The stats look nice. Like you said in the commit message, user can still
have the old behavior by increasing vm.min_free_kbytes. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

