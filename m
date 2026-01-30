Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0F9D73EB7
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760896B008C; Thu, 29 Jan 2026 22:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7170C6B0092; Thu, 29 Jan 2026 22:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5016B0093; Thu, 29 Jan 2026 22:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE9E6B008C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:53:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E42021B1420
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:53:51 +0000 (UTC)
X-FDA: 84387261462.11.69B32FA
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011019.outbound.protection.outlook.com [52.101.52.19])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33FD31C0004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:53:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QDkCUEWM;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769745229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi6a0fURhrPurifYpDQgewVQSbIOADWal2Rw1rBiNCE=;
	b=RlM8vHN5ZXXyhS9kztkmvd59527BXdj0O1eteclT21r1u6cMX8MDGW3U7FFXs8uTB2IOur
	uZAHqFwH7Uuq+qOXG6jyZNf/DmJehg5zZxtJfdmXIl9INU2atrh3Jgq9HZLUjJ4k9mtgPo
	JE47hb2fZdMESvBQSy2Gtqdkg7u2jVM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QDkCUEWM;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769745229; a=rsa-sha256;
	cv=pass;
	b=SfvMdKD4KjbRxQmNX7wxbLn8WkzlcgEFlkAcG9NCcG1IbwrCYFjNSo+xhciKek8/Wyb+HQ
	AKS6FbutghCDa1Wql1aAnyrxVhoPLetEGyjiObGLLtLgnPisaGnE0cxBFfpbHQIizBgco8
	EZHbDywVGPN1cHNFfAhSY7r/NVQtvHA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=so8dx4jnoP+DBMNQ2DId/7nFCgzVYqheySm0GOTsnCEMYBQrtybyj33SOuKmp6axJMuEc+sDDGRfY2eu7+6NFzEbwep9wZ/ihODXXQGJVSKU/4QM50dGB8kbVp1pC1DwpsadSwTRMLmkKfAodkkXgRY4zhXNwNGsoJPD7SR62dQTaepDNLoct5kS2arhUBKeF65B5NEvkfxlNgRwWj6QgIWH+TXF06UfId7GLu8AhqoTO1RFGgOXD+B758dnpilKgMCkVxFxbBwgDnrBLN2chRzB0dZ8IGClxZtysisNZ0UW6Jz8h+ba222GrNCVpUG0wp5tttcvsat+jOn9t06IsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qi6a0fURhrPurifYpDQgewVQSbIOADWal2Rw1rBiNCE=;
 b=e6Wa6eHGfefqj1W+wOWayioNJ/AkdNSNmIHnrd2F2+0uGRjnOWiHk2XzNMxIQHnNiOgbigW1o37oh6KJVhj+7E5K4Hf0/ppA6U/w1K2i6hfMA2p5dfPXP9dF1ze8G9sKG7TQT0RlaY4GGrccIL3TeQ8J0h+tqyYxKBQ+uJDtBeL/K/nU0xaoPU4w9dTQMPJS72fr63IazyEuq2CW0AW/BfMGUaAs/bdOGVYRSR5Qpc4kgnVb1/cFrbMGukuXN0sR6PIZILg/V5AxxXbEjuMsxISbkzQ+tnRLpbp6dvV7vpbwffEnixwkWOJB8tOo+VPQfIGzFdqCflWP7ScisEnBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qi6a0fURhrPurifYpDQgewVQSbIOADWal2Rw1rBiNCE=;
 b=QDkCUEWMU4/iQxMHT1u6cFgbvZasCTLrXLl0us9mKAR72Xov0sE0eo/05vYZx2EslfaybtG/pCeteZzRZqpfJNrHa24K9RHr7exNAuh4ITguXSiHbBlf3pAuPr6SxILyuxsEFfXYZ8wJqKdNunBZWVUh+WPF3XukU/OrEgafar9dN5MNoUxOVx3xgHz6wU0IYsKx9Ai7Ka1hpj3dFbkAlk1uCXCemo9wCJaKzZX3TEtIWUE5HlwJdWr20nrz5JDp7tmCH02BEvZqtJY+Dl5s6uhAP7kzP0vKHLhPcA1lbEj8NRYiZP9VJz5zHvUDrNkMFqzPbWePsoTbGa0YAEDaAA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list handling
Date: Thu, 29 Jan 2026 22:48:16 -0500
Message-ID: <20260130034818.472804-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:23a::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: adea936f-b09c-400b-4e5b-08de5fb2f112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HEzxbo7AFjHt/H/Hkz4TMmYQeM9cVqtbpwUJ3jfnu0jWqYoRYRnfPCqMJgHT?=
 =?us-ascii?Q?C8rvcXiwehybzyENxnwbbTBp4NLIfgVy69GDEXwE/CiMbPWTRic1At1MMyJJ?=
 =?us-ascii?Q?Ah8T5/eXHL2mO84vlntobC53u4Vm42yKVbCEAprfZToh3EHpoewc3zCmZ1sB?=
 =?us-ascii?Q?uR9ZjrfL9e7DxwvheTyMttnbwyR9Do33tK1SUoEGCKWNM6BgHWklK1OaegDO?=
 =?us-ascii?Q?bPyhaqIc9BZFWMjQXmtNtMVnib17EKfWlh836AKfonEBBhAYfWQwQ86eNWIb?=
 =?us-ascii?Q?bA4lt3EOoJvehIGlMTBWqslat1R1gTqQ7DI00+vC3wkG+BINhID2OUaqrwhk?=
 =?us-ascii?Q?hJf/ssHSuSfwXZ721P0Xo69L+2y9gfmhkG15uf9TRQe8LDXy2uC6dmG8lmSE?=
 =?us-ascii?Q?n5J0ya693yAoY4Xe7g10yR3yZzrCCEzOax/N+hFyJOmA3RDlZLLTWcUlVFWY?=
 =?us-ascii?Q?Q1kF7vMGxJh/ne+Awp3dmuhjxpKMvud/5/nP41GQyLcCYwAm7JpvM5PuvKGe?=
 =?us-ascii?Q?hwQVe6uC79yvA0fLIYI6X4vv3Y8uRkJtRm4VuXWgVc6kf8E7EMYXCaBHKOt/?=
 =?us-ascii?Q?HVAaYkE3KSsPHA6jDh9wF8AxLhm1prQlszuG45t1Ow2F2kpfSVfE6qv4Idsg?=
 =?us-ascii?Q?0hj0jVkBsqm2xNPxviBOzpwKgch7H0pj6YJ4cNiFdKBrFsM7N+vn0qnlsWFa?=
 =?us-ascii?Q?I8GR702DoPG3CjQY+8UFJPbroljnp0nAjAe7NyVLKFsp6VT5tESQ6HHbozyb?=
 =?us-ascii?Q?sWuB1Qodx8zEvSvWgyOcUpupBYVvTCBFZU60Zcx96XZk9fpQoUQBqOee0398?=
 =?us-ascii?Q?cIo2wHCpjWrHVwL5mJf40sd9atfnJAcHyJMzjrW6iKaSfetd/8YDJfVBZckT?=
 =?us-ascii?Q?z1G1y4tGzvRP2B4WvV2UVOLGv5PhE8V2MO/y7VERf8O6StPdwML7jSbuIryS?=
 =?us-ascii?Q?1F/QpQDKF5Zq2JYDm0mjJ74yUVQSte6JOlAt654ZKaKOJKoxva8x3px57GQ3?=
 =?us-ascii?Q?dFfbOddVomlrg9GzTK0bwCkE09Js8KoiiKKdk+NAedYOlswytduf5pZpb+Zb?=
 =?us-ascii?Q?0WP1K9RRLTwihlEM4hC8Jqdxove1vZcPf7PRIm+Q87Xs2vUEEx6Ye4nWm9Rr?=
 =?us-ascii?Q?MOaVFJuUb/3xMJT0PuFJ+btQ4L/2R0Hq1mil/9z9j8vs/vann1mPmANUzNKD?=
 =?us-ascii?Q?i3JwUt+3qYQWLRb6Q2izRiV2/f1z86SG0Yl2oZ1pMU3l2IoJpRIkjcv0rwXC?=
 =?us-ascii?Q?RkeRcx3wG58tK7FSCMOd5YmGjt4qqMFSO6Bc+VS4DYQabtppONdwahqEfO0p?=
 =?us-ascii?Q?FZiiwdJsJmOpTIQiw3odg05+KPq45auqMWZ88Lpd6jsk0ycHwMkiFXi+mvxZ?=
 =?us-ascii?Q?u5d4fCLfOAYncKp6OUKIB1minuM+U+uH8rSpELnYQix1ji1ruTbqYNVl1525?=
 =?us-ascii?Q?Q3ucX/BW2n4tuETTwObwtUWLtRE4R9UVzhTiVBtvXyC5CWPjKLGSF0HiihrH?=
 =?us-ascii?Q?SdzOUAE80OqKdRdd+ZcOAv2lhBLFCXFnlu5Hb2m/dNbDHHz6uNn04y4cXzNb?=
 =?us-ascii?Q?D0RUwgZKDyiOvqRzf1I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sdQHu7zbgwQzFRo48cD3gyx0ScqGHI+IFl6aaZPMCow1OyBa6fEQZAhNOlAc?=
 =?us-ascii?Q?8vtT9D60zvD+Wyxjl1n8RnYjhjdQAGxEqS4vmqqb7hq609UuqpXmEiHKxIGY?=
 =?us-ascii?Q?XOgdEN//Xs3s7tHb3IDoWkhxm9qjbN6ORUVpCIPjEY8DHIOz41nayE5EHL90?=
 =?us-ascii?Q?bbo349cPypJTAcMfJjE4adpoPeg8C+Zy8IRbAAcKN617SHGYbgV78Ca2BDk6?=
 =?us-ascii?Q?+VciEuxWAg1hCUukao6zTNWS81pzGFrUqwpo/qf+6ZKsis+t8oW/5cC2EHuA?=
 =?us-ascii?Q?KkmD4IWmpI6VosM4IDP7xz9EyI5m4OBtxU/8Jt/T7W8r+GNgL/yDJ9umy8NR?=
 =?us-ascii?Q?/jEC5mIQpKknLPpMIJuuT6Wgwb/iAgMCDJfcm0QTwdxpJQa+A5CYwk4stWs6?=
 =?us-ascii?Q?AWmsbHSdXilVmJgC2mw0j8HNj2pDhefEEsGuhzYqU+6Gx5ZH54xL93+4s13n?=
 =?us-ascii?Q?Jw1dZiHu2m53vbXVfj0oRk1cOlF2jlBsc12pXU7G2faT1sVoMeqHaeWFnepY?=
 =?us-ascii?Q?9HC4Lu2ngxi8CX+PxXkVDUGB9Il6RWQ7v2LSKcIKwIB5wR3kDB8ZAMHF//uu?=
 =?us-ascii?Q?2zrjOtIGemIzbwcOURGPJEoAY9oZqtDV1q/7ydELWR/ifwYxWnYgZLM2iTZ+?=
 =?us-ascii?Q?AYg3e201sGRyuQCB9050SpxmdxI0FYMw3J57tN1+bSOE/cOyF6ju+JgUe/Xp?=
 =?us-ascii?Q?2zvhlF24wIDRhSfVcxKcBgfjOwCYqgtbsYoE3Gxiz+t77M+1dJQUjjegBcod?=
 =?us-ascii?Q?WW3lGFDPQPenlMunuruKQwlE0wLYLzwk9zkty/2jNZulOL6GAC7LWyoXa4kc?=
 =?us-ascii?Q?0e86NZpl9kOZr5eMwsTiNNzC8UdfhnWoXJOdGhi2/01yQaOC41Va/hFG6Ky0?=
 =?us-ascii?Q?uU8nPyNmoNltZW12me1GR6Ed2dvC41gG/t+umQtvUJbcC1A8y2HO4y33l/2f?=
 =?us-ascii?Q?6gn1y6wq5vUaN1HiW2zpd/Lm+0IJHpKGGL+tqVjZZkgNcYm4NuE0nJuS7nnb?=
 =?us-ascii?Q?eZZNwSR6CXqhvSIBRfJGhRBt9vKnDY12gr6SNsQUqEql9lnexQpuXP2BOG6Q?=
 =?us-ascii?Q?6OY2Ago5pfcE2e7mPpjG9LAri2UCcNO4VBXpf6jjSjBLqWpBUzj6CwP5at4m?=
 =?us-ascii?Q?ctUcmcywSDG8U8gwwxRXhO2KO+E5BWETlGwXcu892HDfat2ego/daRKEyh4Q?=
 =?us-ascii?Q?7yW52toTKVxRjt1bR1TvPzX4Hnzs5gKizXnIWEhw4lwRP/o8b14QQvC20LoG?=
 =?us-ascii?Q?DwfFXUUMssQJe+sHds9kz8pjGVRu8kXJANyXVzazfCC0K0jRNvj/G2+5S8i1?=
 =?us-ascii?Q?RlXqxZOvtrZZubXpiIeNYtjZPbjVEPq2Ri/X/W8pZCKCJGYrvLNx0jtzw4qb?=
 =?us-ascii?Q?zhwEAvunQCtTyNbgxE1X57cSLRRYvR2xOZOwmmWCv/kjq2pO+rsLDygxmfOa?=
 =?us-ascii?Q?CDLcXi9DZ1QAT+cdqyWtfWZfK3mPcG/czCfOVnjh1B884O2ZXSn8qlH48aR7?=
 =?us-ascii?Q?MUNxAEO1RucHTEn0JrkqLy5uPuECvJkJ/6s+AV1YMu9essOXsOyFuSB43oKl?=
 =?us-ascii?Q?q6I6QaKBvIZIwJmr5R+7Gh4VAZcVLTVvgKTbOwwnpqrcNER7EgTH+a/GB4hK?=
 =?us-ascii?Q?tExpdHueB1ozAnlLzfXcs8G6jkA5TZ0GZqnT9lKiwHEq0GtEpG3PJUApQMdJ?=
 =?us-ascii?Q?lfCJnQjDM3C50ss+O6bGYC7E15TvmGyUkui/MADLLBt0Pbiq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adea936f-b09c-400b-4e5b-08de5fb2f112
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:08.8202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FzJb7LOXCWxVIHWfTNeb/mdBIZ/jDw7vI/XMUYtzoB9g9rUixq+wQRd8cpQ7k36
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Stat-Signature: o5tnho6i355pd39jaddbwmnqwcjfb4r3
X-Rspamd-Queue-Id: 33FD31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769745229-45097
X-HE-Meta: U2FsdGVkX1/aEyy68cF9rN2s6ZwrFtQaNxHoWMVPCKulhOF20YiAoUUJrbWJluHPe8clS4K5n2fBdpE8uQxvVqd/tkRmttJuLRGmPuxG5d2XrKfazLLsO5fVSTfJJjC+A3lLdrSnBmRrQQ634TDT7ffkPsPK70NSLa2iwoGd250fHLgiKxRm3gcls/XYCH/5qULDDeYfqfowYdXaS1EDGS8LSs+2ovocTvSYdqqIpSsKGeqer0KqQQL0duAS4MLOeJnew5En7s0KLyYt7a/A5nFHoimpn+usuIF5nlRoW5MkpKlZJchq52Hy9b/s4tIkoteMmbM4qEvOrUveNR6MHy8T4cLLsqUAGKn/bcBR+X87rFCkMOrZwASmc6qEf5JRbC29134yrG9KLxk+LfuATi0qbElC2AYSNv4SttnLYZBYPzdIMKlbMnEu92G2+o0qiqMW/NOUb11W/cBcYJMnDIZMZvibrJqonL2ZW+CWkIW9dMh1gpBNAYXQHfVxoTF0B2WMJG1hPV+0NbUGILKvTWAXrqL+2gZtKKE4903eGVohzGL5PNboHLQVuDIy+GMg/WzytKtw1OD0dVgljW7RJU8vrsIP4Wb7/wzBMC31sYpdzUW4JwdfKXc1WkaFy2ERq3Odv+XqqxaiiSYSWPR040+/6egOoGaetvXVehbHlX7yS7qEFUVAccAXT2MIqJeOGbPAx9f5P9jC04fG8cnKj4RiVKB2Zo0mplRK4rWmMtGp5XWvDkDNgF7wH8XNbIUmVbdnXRUQag7Unw7G48xrLcfmY5GFhBOTPLHhHbwQHh+H+QezgpNSMj22VylAeJcayux2Ih9bgHttjmZNAJLecTlf7RA8aifvgXEcwX6a7X2//AGeFWvgCZv7CYjVfealzGfDuuSvJ4ARXuhFgsN9DjAU4cEYNggBEhfAJGL9TK+vL2oyzCgVGIUYPhPV6hTiulk539Br0fvL8cf6J6n
 sVwiOGeM
 5ZAt+nD61K6/J2GVQLSGZJwiAVIMnsez4BkdydOy/0LLJYGMpR0LLuOTeT5A8CuzxTLDNIeVlcSY2BQQ16YlqK/VVXQHvRxmOvFZew6xZ6DICEv6tMy2uuXemEVSrCaO5OK1oE0mqBXX/kiKCD5aIT5GxWNXrRVP0tG+6wlfXaBQJqvnWrSUcG7ZUw1Qei/Ww8IkaqcfyvLJ3FKe1vG2Kq5KDYuvQKUNvgyagV9iO/q/DFufEHMF7PnMiWVmhjI+N7B/wpqQ+XCtvUmIuiW46MqABiAeD1GWcY4L0KHSCGgFjInIXSlaBT/SHAkbGEo+85wG0ITbcK7o7eoQszFg/AOVxcMYUa13LAcfqZMRSb0eGJ5eXEK6YmPvbIZiBSdO/q+fLeqTMcxcrxSYME3jyebZ/OBxiLgTshsEnPaYWjUMUFtHP9MvckRLN0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit f708f6970cc9 ("mm/hugetlb: fix kernel NULL pointer dereference when
migrating hugetlb folio") fixed a NULL pointer dereference when
folio_undo_large_rmappable(), now folio_unqueue_deferred_list(), is used on
hugetlb to clear deferred_list. It cleared large_rmappable flag on hugetlb.
hugetlb is rmappable, thus clearing large_rmappable flag looks misleading.
Instead, reject hugetlb in folio_unqueue_deferred_list() to avoid the
issue.

This prepares for code separation of compound page and folio in a follow-up
commit.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/hugetlb.c     | 6 +++---
 mm/hugetlb_cma.c | 2 +-
 mm/internal.h    | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6e855a32de3d..7466c7bf41a1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1422,8 +1422,8 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 	if (hugetlb_cma_exclusive_alloc())
 		return NULL;
 
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
+	folio = page_rmappable_folio(alloc_contig_frozen_pages(1 << order, gfp_mask,
+							  nid, nodemask));
 	return folio;
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
@@ -1859,7 +1859,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
 
-	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
+	folio = page_rmappable_folio(__alloc_frozen_pages(gfp_mask, order, nid, nmask));
 
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f83ae4998990..4245b5dda4dc 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -51,7 +51,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	if (!page)
 		return NULL;
 
-	folio = page_folio(page);
+	folio = page_rmappable_folio(page);
 	folio_set_hugetlb_cma(folio);
 	return folio;
 }
diff --git a/mm/internal.h b/mm/internal.h
index d67e8bb75734..8bb22fb9a0e1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -835,7 +835,8 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 bool __folio_unqueue_deferred_split(struct folio *folio);
 static inline bool folio_unqueue_deferred_split(struct folio *folio)
 {
-	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
+	if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio) ||
+	    folio_test_hugetlb(folio))
 		return false;
 
 	/*
-- 
2.51.0


