Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B3CCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B628E0007; Tue,  9 Sep 2025 15:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DEC68E0001; Tue,  9 Sep 2025 15:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3DC8E0007; Tue,  9 Sep 2025 15:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62BFE8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:08:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FB5FC0710
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:08:42 +0000 (UTC)
X-FDA: 83870648484.28.CDACD67
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4EBA1100003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:08:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+zubrbC;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757444919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzQsRrPkKzM68yJUGIjEBDYdHdBBVaJwEzRe6ZnHZqY=;
	b=ZzG8F7fChMiiOAQ9DuveU8nL0okJdX9BOtYdWqrgqAZOcJepEbZfRp2N091U9V7uyGuWb2
	efSitg0fXjuq4/bqk9pnm4YF1lOZxI5uFbNuWpmdQ2GjWLxt3N9QD6h5pDYtZSBXdD8KNQ
	0UvnZZH3tTozPCMjLbpaDeIoONCW7oc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=m+zubrbC;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.92.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757444919; a=rsa-sha256;
	cv=pass;
	b=7F1nT/cAQct4YAtBoU146+dydymJogHa2qdMfgzawlKYrCnqminPUKMpiOLJLOfcR4FX/N
	GceCuGPqYfqDQ5y3tuoqcLOIJuaAuJ/B7mjFTPY9xJAvIiTg5KybLB7nn3olTBWeZXMcLM
	P/646mg/3lb6P43jvek+R2Ft3h2Mrxs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxiT1kmxdaNZtekyLtIEyjEneLsQF+vEx5zweT7MoZWlJOkmy4rS1+348w3NbJF8Ffr0Gcx+tI0LUVmPM3NlyIrVXiLWHQiRnhCArFXGzgCAkpxT1f+dn2l4T3r+1m8o0rdH2gj5pTULXD5Iwr1j+HkOS0tts4d8ksB+rNc8RvlR5VBB11j98VUBzL0K/C8s7hgY625O8xR6yO2zFsSsQ29dc8+o5TbwUK1y1rFe25617LCVNy0XalaOoY8O4jDvLT6qIQdor/D3fx/zUozW5ZtGJNsV6TgK6mjLfkZtiv/LSas+N5AgZy32RH9266LTJ3CMRzDTL/pnPu1b8Bmd1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzQsRrPkKzM68yJUGIjEBDYdHdBBVaJwEzRe6ZnHZqY=;
 b=HCf5gGU3fBNQX237MFuxYMMVnr+es0WZ34yV9aHM5f1K4P9O9GLC30fCdNaUiyLBBooYZIDnxfp2luklSyCb9HA/NjwlNRvHJHZEYxJCR8rLVzsivYU3l2mUeYYqLlCdc7h64Cq1NmUTy7hGSbyXNhHwoyYHH0xefgB9cJYXqKo4ntGpXvDoJIF+q8hPB4QpGTXfVgR/XJcSbJY9rrNUDU2mCnnqyDc0A0IpNSHE/xYVPRi8qMZAvPzXXqYTRaWqm5TIKsYfKEK6NR02rQaHiGCCw+9spdcZJdGjMtfpucEsQJ2KPaNz4ov5RDZy91Qb80oDd17pMuPQIAWLcONSCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzQsRrPkKzM68yJUGIjEBDYdHdBBVaJwEzRe6ZnHZqY=;
 b=m+zubrbCC5aF+d7Kcbt0oqxieMKR95zFD2aTIkqZMlomrJbFaJ0kAqAIB3DuKMlooKcYEksLuNegFhrDXNRUj20I8SllRGbDc5zTjrEdeedd3YdNja2cQ5Ba0tP+UwVNlABUaw1a9dZbRra6McjCuCuktVCJ1atLr+OVwNzZebfS+AJPfNglgpdWVLKm8rT9VoqMIi4uzqeuManzHYuo0g+td1ZWLkM24D/Uo8spt6744y4I68JUaQV1dGmOi7rYN+WkH6QG5UbMUK2junNzUm/u8P9dN8urm9Jhg04/+ZfBVPCjF8ORX303QG+kmGYUNy8TklMkIsfH7DakBDDwMA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6438.namprd12.prod.outlook.com (2603:10b6:8:ca::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 19:08:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:08:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
 jane.chu@oracle.com, Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
Date: Tue, 09 Sep 2025 15:08:32 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B41EB8CB-3337-45B3-B952-70359AAFF2D7@nvidia.com>
In-Reply-To: <aMB4KhOX7IeFXaOZ@casper.infradead.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
 <aMB4KhOX7IeFXaOZ@casper.infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d16b76-fbbd-45bb-2fcc-08ddefd446ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xpSDUPaBY/ueyMaUnPjwglSVoHdHyRC9z3T8H1CEbXFW/3uNoy8/V7KG8gPh?=
 =?us-ascii?Q?SiufBPhacQUsLnYrL9iRqIqfYQyV8TnaNH7fuMW/I2zDbfJfvzcNSrm7r2+f?=
 =?us-ascii?Q?5XqA+QQmwg3scUTp4BeL/oTcrcoyyxFSNDHzNRH622mMNM6yi2H5/MQLIXq8?=
 =?us-ascii?Q?z88mePjo9KcuJ+EqACwYeFp1ooMjOJi61Str9+LqyI+a+bUFT5mdTYE4K6S3?=
 =?us-ascii?Q?kab4SDNA26Zi4VMipgnSSpov3c5JcQUjzK4nBgi1UOry2+OpzRkLxTOKglEq?=
 =?us-ascii?Q?giYN3xcJAGtP4+a3bEYXH2CsYq/H4IDIIFhopH8Jhh9yN3js7WvR1Dx4SAu7?=
 =?us-ascii?Q?zOcIEl8g+lBmBxPQrhtd/ClzO41C0PFnLuZiRoFsSZzcepe7aoLiHHPYFyGn?=
 =?us-ascii?Q?um7Nd6Ld2Uk8bi1GohNDbbN58MKP5FLLZDIOkhpumJi4kFaYd0GXy8xvp97v?=
 =?us-ascii?Q?IWRFK/fHYn5fj4Xs5/hbZkshbazyn9LiGlmljdTV8qzQesmHqh/pk0nPnJp7?=
 =?us-ascii?Q?5+EUfdvHskTmGKnPYsW9sm1EBEjdZj7+4wL0RNPfSHBnMwggLSfwF9aJw6XN?=
 =?us-ascii?Q?COHEk4wzr3Jc4RuvxtZVWG9pB6Mi0IPDSs9sg/HYd9fAL42BQtIQ675QFww/?=
 =?us-ascii?Q?dj2TaXWA88YbH9tRp8Xyi4/vr8V80JOBSYuWcDPhjvYebQqbcsz0Kkkx4TEV?=
 =?us-ascii?Q?s77LQQcM1/JWWSC3GLihVd58q65albmOdYbKS42Mei3IlNUVRmfs6W3IoxPP?=
 =?us-ascii?Q?3YBJbU08H3v32YYJKQtUncjP15RHYb26cfk9Hd9TmpThcksJ08R89TMnjLtS?=
 =?us-ascii?Q?Z65cDcZptszmQunVaqlGeliK6jYd0Y3HEYwkknUflAlzCsZ7KQyXCc1g40YH?=
 =?us-ascii?Q?OFmEQNqVkjF2uAWRbHtxbQGZOXuXqaN+Rn9HvpCBLSrKD7KzE4Y3KRbHfyZi?=
 =?us-ascii?Q?DOTIL7Pe9nRJeIczYTogprysfFT55NHHNF4IKFZZ2V+gk8NHQInxYKDAzVwb?=
 =?us-ascii?Q?uww2Yal88et0a6rgvn0EzmVS/0Y6ERd0haKG1LRtgJLElBQtdu/jxTXBBzmX?=
 =?us-ascii?Q?CC3K+VzEUg9RgC/SHitOlr8sMnRr2qnuMs3h60BE2KAK79VLvs7mSTevz0ty?=
 =?us-ascii?Q?JZ76sdtx5jaO92INs9F6ByndKWrDdZKbOUcwpY8TjE81trAhRL/AG2/oV4Eu?=
 =?us-ascii?Q?GtjWh3Htz5fOwo3cgGz+i5Csg6S3XKBd2Ik0L0d0k3jS11QXmNU3XYEp8FVr?=
 =?us-ascii?Q?5GuH+E9RItJvgORMKWI/lkoq8UFj2rsegRwxbNMwLfuc5uA/Y590PPqeBIZI?=
 =?us-ascii?Q?y1g4EpTgd4iCwDbzGjnrKIB1HeLUXLjHIf8ZZUREzIgavffTOhutNZ20bdUd?=
 =?us-ascii?Q?mGbvjYhT9hwATupffXHrOyKQDwpfND5gaCYsq8Pt0ZsbFlPme2zUSukLBuDU?=
 =?us-ascii?Q?CvOwDUC+CTw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F3337A6Puyc/TqhzZ9legjb5yNdiTQ98TJ+iY2zY3C9KnTE/004XNheCYIbD?=
 =?us-ascii?Q?fJLk/sjCmGaHlD7pqAyDJe0kkl1hb5Y8cHJwbZHSDyLgYcU0V1OFtk2RpLt9?=
 =?us-ascii?Q?n24xcyCGFNc7ccHFlQ+Wl8Fg+14oCxBiaDID4Ks3ibnGuzDvY+KSH910m3zP?=
 =?us-ascii?Q?UF3r5jXUJq9ZHGg5Lg0Jgp1lPpKAbbljDV5DgvmUefJx7ciEugDgdHnPotfE?=
 =?us-ascii?Q?EGgiOXdr43o1EWEyMdK9KJkCKHmJUJ0PYhuWIN8XxeHbmjimsbXGQziRUnoy?=
 =?us-ascii?Q?Vm1hciymiOz4LSXKxw07FbwrzZrSN+tQEhL26NurmoszqbmzsBybFJ1IrzeJ?=
 =?us-ascii?Q?0qwBy5BoVDtZEAFYro2EISv952jM8LzAV7NWP9KuynWwmvdwLn5nwVwKi0fy?=
 =?us-ascii?Q?utIqMadSaZqjE/doZnclv22J/mZBY9oxPw6vmu2nT7Jt2Asvfeza+s7H1ism?=
 =?us-ascii?Q?S9jLDL4DV9hsFB62QhzCZTwHuyrtRWSZoaAQd41wv6ai5FRdwwcq2mugFOXK?=
 =?us-ascii?Q?MusUQHsUKhcfRXRV8TAK7fi8c+UZPKJ6uzWD6tYNzvi1V9dMV0HdqlUpCyQk?=
 =?us-ascii?Q?SAZa6jl+3BlrGydrpwpgorN41tPOJzPebhwMbhsFYUqQfrRBmuzaGptPnJFM?=
 =?us-ascii?Q?9DUB5YTWmOPeaRe1NWIOLfhvMItF7FMN3zJ+D/2BJ2jnQG03/u/0jCkX/OdT?=
 =?us-ascii?Q?KuhT51+ptT2tysrEU2pjRqavCBs8pVHmGOLcLPSWydJD9rrDjYN5qLLo6Lhr?=
 =?us-ascii?Q?dnxZ+fZnB4DgHQjWUMiByZU0pH354MAAU9ggVOmOKeCSWHz05ZjD1IcJ2Erz?=
 =?us-ascii?Q?JWGm+5Nn6ags0hw6EugAYd0rZXi3k50aEOJYOcHTH4r4qJXrSdllbxvwxXQO?=
 =?us-ascii?Q?IElOdUFi30HLTsXbM2Hdxtjgo5bCZL99imYs/TR+XogcrzaiWgtts7UZdVXO?=
 =?us-ascii?Q?KK2I2jfPT3xxKtkpUy3jyjuvWWzM3O0VDNwxhM+obf0I+pkvZI+Dlq7HYJ6/?=
 =?us-ascii?Q?XNUzeEVnF+sVpFRM8VIsm3mVsb3ew3n4SgznX5Fvxn6f6BnhDy7JkH9Ter6P?=
 =?us-ascii?Q?wk3UuSGdosL1n3/7zilhwQxncG/5cHJjg/IQM8HODXJpO19Y4BLyH6JlivvX?=
 =?us-ascii?Q?VtQFi7CYbo6H0nXSsOSCtazo/pSng4J4ShTOh5delHpmLdJo5nGJ3g4+lLqr?=
 =?us-ascii?Q?f1skgJE6MsZ0L4SaCJ1hXyGSGUWLW3uahNN66H+Br45EGKSrIkWSyu1MAVjf?=
 =?us-ascii?Q?KV1QY5fbEs/VqA48Yk2P8FURMxxqFQnQ7UOPogDQYU8Uf83nQm9j1MeCuDf/?=
 =?us-ascii?Q?nGQgBeDBfcZGI/UQbdjPtfZDSW+mLQ8H4yprHKwz+qsn9vZZbf8HRt3Frl+j?=
 =?us-ascii?Q?TjRT9hrH5z2ZLrYGHZ0gW9xMha/XSfzWxw8aNmFx2/5iAhdhusB1G71k012/?=
 =?us-ascii?Q?nxBvrnwQEkzkP00pzvhsle8lWuFbXxZFOOTmWMuJNUo5lvklBcHdRWTQ3nTu?=
 =?us-ascii?Q?ZybTrM8f8RAsUt/5IgFyIx3QDNFGWfSJGBUZ+uH/kr9d21h8ieQO8Q58mPfI?=
 =?us-ascii?Q?h4J4NXTgdeJ16/wcX3KiDjFhneVRxv79RlX8ogNK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d16b76-fbbd-45bb-2fcc-08ddefd446ca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:08:35.7639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKbc4yg7qN4rQ5i8hk/gtgUeF/Y7VSjQIWFOx2O5lsVX7dYztIn4muxRavCHiF2j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6438
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4EBA1100003
X-Stat-Signature: bndzhc7cy7udof4kdy44jy3119pd7opn
X-HE-Tag: 1757444919-157937
X-HE-Meta: U2FsdGVkX1+uSwdv+NO5/fqvXD+ICefmbxS0JZwBNxeZXTt07yWd/eRbwb9oVJwB5MHW+GjVClTA3AxhqSmP428gCoMxmeguVxNGZGW17vjx9LB/TXi039BCPpSZPaFvPTYb4HZbkbJUdu+x5CzMghg4U5RDFXKJsHdkHNhAj4EcMi/W6t4ib1j6TO9kXUYpTWYYDHaCxaj++5jJUPpoJX1Te6dd7O7D4bLc/YTACQZekLIHTOVu5KdbbHHUsFpcV0gpTt1Vw4UiLAe6yer7XdMzfLTNQ3u1SzrP0HWM/i4sB7w6N4d12kGDNYq+kW/uvrJIJ3Sobg8i+TrSAl7dUNmm/o7yenOsS/ILrFkFLNR5DdjsL4a4hMWoDuRP9pY7AFPZfhoJsPKluDVc5JfOOucZVnd67e7jybhm+n1bdvyIPRhcswsLZ8djd8stIb2qUEDuItke1uvXEjQE3VX+QA6IKeK/olMmZVIL27k+lpKXynBUWeHrqLyVExyJoUfTiOPLuTC1l3wCQf4guaqUa2gqtl3sELdmEY5EMrJBHufNC36nIf2Bhw4+nt6nMW5XZfH6E4seG4IrPV7J2CcBY8utV2UHv3Tw20xASQc+70RRPOGp2hfz/UgO8DCkyvaHSZplQ1CT/w+Kq6d7UYcrWfDZwO0HWzr/4CzrAvXM8eq/BqbD9aaOqQuJflrjjC9nQvdFplZ6hXcvxHix07vDwbkPmGu9JQfZz01U5ZjUi6LzzZvqH7lxZqna4Z3spWjvOQRWPuj2fy2SssMbWbWZ79tYhpmSYRp+XhSen1IB9T3QuifWwxYSz/BocG4ySuBUFSpsf4j6rpaOslyo9QAnhZuBx7taqz7PzKoCtwYIbAoI4ZCNG0T83DezVkIcTbg7upSuOJ7VQD6+GFscX07BRb/F3bo9oH5qFfFlTDhw4rsDUPBzz3xNAwTzOsvwrMguelN/cULcJByErT7KcCr
 S5qvo2Kj
 S0PIHLOUHMnXhXG58azpR9Bl9pBtOumsCSDmHhMf8h2f78GRQnuy/sGTFjQXN2Yj7HXTv8DwvrdwiKYy30YiQNWXYy8sJY6hTRB93Y7B/auaWOGMkWF95jXgH98fzE4EI+ohPVLHmj4kJO8BSceh12MEHeN+iWOplD6+HILhhU04pDNYHfy3h6y/Nrjfz8qWW0fpQYKMucxmdvuqJhDo/3/USF9bOdw8XvOzAQ++43Mskz1Lh+cCf8y+ETtcYTgqRkgrj5+SUvAH3HmPcxKaQ6e9gx8qbQnXBd7v0Boxi95pW/miOcWA96r9UEE5F/1D9d7rn+ZNpNt1MMiG1ammpG9xcvflfrNkB5hQI13Q8WVYhfVq80OpVUlxXWGQi/mw2uhbSazBF/v2U4eUPqwwbbfh2vBjUhm8BoKi6aXIGsdSSdpMVh1sVCPlfm7Mkuog+hOI09fjYFB6NqHCEdHJQOiYhTbBMe9x27n8sjECXOQbEP6zSK6762L4ZHQMW9/9Z2B5h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Sep 2025, at 14:55, Matthew Wilcox wrote:

> On Tue, Sep 02, 2025 at 08:48:17PM +0800, Kefeng Wang wrote:
>> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
>> allocate a frozen compound pages by alloc_contig_range(), also
>> provide alloc_contig_frozen_pages() to allocate pages without
>> incrementing their refcount, which may be beneficial to some
>> users (eg hugetlb).
>
> No, this is not the way to do it.  We're moving towards a future where
> pages don't have refcounts (their owning structs eg folios may have a
> refcount, but struct page does not have a refcount).  So work towards
> that; if you need to keep compatibility with some users, then by all
> means keep alloc_contig_range_noprof() as a wrapper that calls
> alloc_contig_range_frozen_noprof() and then calls set_page_refcounted()=

> if alloc_contig_range_frozen_noprof() does not return NULL.  But I'd
> be looking to see if alloc_contig_range_noprof() can always return a
> non-refcounted page.

Something like:

struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_=
mask,
		int nid, nodemask_t *nodemask)
{
	struct page *page =3D __alloc_frozen_contig_pages_noprof(...);
	=

	// just added page =3D=3D NULL check
	if (!page)
		return NULL;

	if (gfp_mask & __GFP_COMP)
		set_page_refcounted(page);
	else {
		unsigned long i;

		for (i =3D 0; i < nr_pages; i++)
			set_page_refcounted(page + i);
	}
	return page;
}

as I suggested in another email[1] (of course I forgot to check page =3D=3D=
 NULL).

And other TODOs:

1. remove set_page_refcounted() in split_free_pages();
2. a new split_frozen_page() to do split_page() work without
   set_page_refcounted() and split_page() can just call it;
3. a new free_frozen_contig_range() and free_contig_range()
   calls it.


[1] https://lore.kernel.org/linux-mm/298B40E0-8EA5-4667-86EF-22F88B832839=
@nvidia.com/

Best Regards,
Yan, Zi

