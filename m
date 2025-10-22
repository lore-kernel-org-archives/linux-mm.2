Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF67CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D694D8E000C; Wed, 22 Oct 2025 16:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40B88E0002; Wed, 22 Oct 2025 16:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FB88E000C; Wed, 22 Oct 2025 16:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B19298E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:40:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 613851A095A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:40:35 +0000 (UTC)
X-FDA: 84026918430.30.8E75B2E
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6CFEC100006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:40:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RDmf0iYy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761165632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeA8WRlLAMCSG+Ic1aw4kchBVy7LmsMOVk9kFWGAM+w=;
	b=F/yXon0LOGGswpAK5IVbO/APAG1HWnOs1fJM46OL/MBEjsc8DoXaNtJK34Y/mrecUNxeWv
	INe8SAKULvq5iXVt2bLa2i3ufkRx+Y6ZbkqpA1bIr9jBuN6eq6JNRasGy8VmmmgBU6+FlA
	S1QOJziW8zVqBtXRs+on/DXTqPBSjbM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RDmf0iYy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761165632; a=rsa-sha256;
	cv=pass;
	b=WVgUSfrPnUlphDTsnXHu+JIpbWWYkDVRzfHqu34qQWSWBw7kR4oFWhYskSOeyzxoGxeLCN
	zPcNGzZcR8r6i7CPMmFJKvK+siEtUc6ZIibQv1kWMZ+i1boXwFiVm70XRytKOMO+NIg0gJ
	IUfrTx2L4bfskrOFYQOEA9vGuOwSLfs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KCks62JuehAddOVggOExeklxCLfdWUc32hGcZ1a9RErG5Zj3SOiWtdzPX1BUbaRkjIrK3yhezuGRUhjV7ggvSTkyR/ru7cguB+UVLVQaK/xJiRM9xL/0BnARZkt4izhfzXhsbaLPFl5JBA9MQqhZ2l0ZVPaEsMLw3ygZ/v7xSVxbC72Mz+wrKhtLtboF4hU1Md4CdZGDWHbKgduLXlAuFfDhmZqV/Guy/4epYz1rq3fFvU6rb5ZPJss3VovFsPR9OcyCrT9Ycndqckbx2VaRj2/dvBvP2842iWFLfF4/GFFPX2rM0NiPI0ASMsVdEmdKDMdT9P8Q+gNjCBIfawXOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeA8WRlLAMCSG+Ic1aw4kchBVy7LmsMOVk9kFWGAM+w=;
 b=CmH58IXsaurIlX840AoZ+PGkcHhKTmCO3XvTtvFzjptO0ildqswOr+qX6fDog/CTz0UpD0+/pdBdpTzq5RH/ctlimtfNLR2lwHLHqYAAFDv9HqBbAtDeRLCyjGfrz9TBPE+O8k/7q0dQ0tgFoCoZKy7mcG8nC5md7Hlv/uGhKaF9AO9ZkoOwshkEWVjn7L8LRtCaQd3Fm/dmNNt91h4xxMEX/Rn2j5F+035o1czq6YoLim5Di/cbzqKk3iu2s5ueN/c4tg+pGyok7zniOjGRbLi0TulAo5LlFgeW5wJ3TH/pSzDXTU+VQdCmh+ci2QP+aMZiSe02oupAQblwZw7UEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeA8WRlLAMCSG+Ic1aw4kchBVy7LmsMOVk9kFWGAM+w=;
 b=RDmf0iYyfEzHnlEEsw87CeQ+8sSzyH+u+ugoNE/6hfNer4ZUdao10JjL0wsNsz2hRihhQl3/SZWhAQ1YTozWeDi7QKBI/C9c8eFtu6zdAa7xIkGo3NXbFUQiuUTDLiXd6XN7tXveURWKHdlrzB9/v6Lh+Rf8gWNKmnjjoQFrbVfHUH2xLJIpMQnKbUvd+nod+brigKE3/xN+RRhX2Kg2qcLaoHygqtVuxG28Oc0TH+mtky1bkYXIryIh4p+J3H+4aEUnhKNIks7Dur6Ss13KKid8LATx8X2bFlWmQyG0VSaWsRGRRmQowSlz8v3v/kbXvKJcCkZ/OGLHGiiLsqT/cg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4407.namprd12.prod.outlook.com (2603:10b6:208:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Wed, 22 Oct
 2025 20:40:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:40:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 1/4] mm/huge_memory: preserve PG_has_hwpoisoned if a
 folio is split to >0 order
Date: Wed, 22 Oct 2025 16:40:26 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8416106F-EA1E-4995-BAC2-7EE9FEB4D0C3@nvidia.com>
In-Reply-To: <3dfb5722-f81f-4712-af9a-9ea074fb792d@redhat.com>
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-2-ziy@nvidia.com>
 <d3d05898-5530-4990-9d61-8268bd483765@redhat.com>
 <5BB612B6-3A9C-4CC4-AAAC-107E4DC6670E@nvidia.com>
 <3dfb5722-f81f-4712-af9a-9ea074fb792d@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0017.namprd02.prod.outlook.com
 (2603:10b6:208:530::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 74285721-2bb9-4e2b-26bf-08de11ab3c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F/HzjadUbIEnhZ0T7gEIF872+i8G242LKHfIAORY/XpoHdfaqGLhxiZ31HGH?=
 =?us-ascii?Q?1xeRhXB3xjXy+dYiqP8q+OSHvX7NtRQPrTGQuyKzYmfXJb5o5Baf8zW1km9t?=
 =?us-ascii?Q?OeNGxGDcBW1QsArunxnkfUBKv+jBa5fBY1AzCVBWsGulV0JvdsQ+99Vxs5Er?=
 =?us-ascii?Q?TFDv/JzCUPB1gJYoIgAVYihfkhN8ijJOIeDgwf9fgcLU6d8qGeAJk8jYYy30?=
 =?us-ascii?Q?I353vVClMMALpdXYhQi5GlWvLmPJihorkCkmvC4dFwusC9U/YChTx++bTJEh?=
 =?us-ascii?Q?2j4rkvFPey7Y6ZyRVUX2nNPYJMCpz+HQrOAHGZVjikQUrzz5Ll5kHxhaPaLt?=
 =?us-ascii?Q?qfaxECM5CQeZltUQUb609/Awt50Ai+gVBEbc7Koo4rmQs80VKlS8Y6pJXZzE?=
 =?us-ascii?Q?MPFlb3WMccVlO30jHTK/A0e7mWEklm174ADgGcsGXnA/SpwoeDy0v0XnID5+?=
 =?us-ascii?Q?N8BhF8ZfpQcCbYJKriBqjarAsTtlIfFwxGPojnKYflFGLnpdIw070hMjanIz?=
 =?us-ascii?Q?jJ2/63AdebWNEfdbEbaPwNqNIdy+XmTn/i1OmwMUmTkL4j1FyUvmtjmUkO7L?=
 =?us-ascii?Q?jb9HHNyb0mF2ApK9sT8f+PjlVpPZjYnlEPJC5+jdFt/cJREuRv1+D3cok5k7?=
 =?us-ascii?Q?7+npEkIm9ryivVW8D6fNWq0JZuaH7VEttZBpvZHooThZJHHZ8TIL4kmXM/VE?=
 =?us-ascii?Q?F5NdfuQNfB0XszNk9eYppiSpBlNw8pAp5rtX3M9kvsBJt0g2gANS+yPGwjuz?=
 =?us-ascii?Q?nEbWxphUyxc3q1w8qMlQhq/qQ1YZge4iNCYBNNDDolLceRIGVMAhJQdLf3fH?=
 =?us-ascii?Q?ciX2pOsvqj1ru0deg3MKLGUDmaACXszodQDwKP9ly3ar1Cr7lyaTInpaq+db?=
 =?us-ascii?Q?X5s8f4lpbptnA6pHHlRUlCoxrC5qCkeGqZNf7FVzT0nKGP6Nuv0P8BrtF+LD?=
 =?us-ascii?Q?1+gzpGMWbTXIRWC4qgqeMk7L7t4tsVOUYGKSjGfVYXSwMlKqvgvqXt1ZUqM1?=
 =?us-ascii?Q?FIu7mzTekzEfjp8/dUTaA51DfbBQXIu5p923lVBiBLEl2qP0NfbooSXekkdW?=
 =?us-ascii?Q?r0BPxSpD2nqLXudljfCGt8rq1GI+FbI1pSXndMsHsCsN87yZxihjWSysojw0?=
 =?us-ascii?Q?iXqbZEnd3ec3r4Zq5GGEEehiAR8DUmM8/4rhF3VDsmwTTFBXqYwMC25Y6eQI?=
 =?us-ascii?Q?m6/P6tZb0evw0M647+/Xk4lxHp43bcW98zR2KOMyhn5NVe1vyXutmMTa2Wdo?=
 =?us-ascii?Q?CAN6Je63ZMV30M0G14y1e3JB+T82y1QcqWQEVx5vYNa9F30FbRWGM+KEHZeD?=
 =?us-ascii?Q?tmTeyMvu4Mlbj6J6qn08vyPoaxde/blA0PgssEUwwjUK8q1b1GS/CH2qbfI6?=
 =?us-ascii?Q?XiPIQaXvhHXEEcB3EZYhETZiQsk2VQux40CPhrx+houmvs8wSdPf1tiMGZt6?=
 =?us-ascii?Q?bsWYD8d/1C/9o/Odsm4WSEDyiVmNwBqW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2UKDjnft6B8irUXPtnwDh+4oT77GmuOtUC88bCn+206jHIAe9S59L/x3EDUo?=
 =?us-ascii?Q?6Ba+8bRBg9sfEBBElCkihsOBTDOdxIxkjJxtqslb2I583sXvA5TwjMcq1adY?=
 =?us-ascii?Q?cCpVxYwFGgWO6zARWdAR59kaPoxOBIglxTyIlAD5JDaxai++Y1yrjCVkkAf+?=
 =?us-ascii?Q?l4bKOmIsMzPQbu4r6BKBUSQCVpBd6n+GDTq9xTjMc9TVWaTU/gMu5HalLh5R?=
 =?us-ascii?Q?317td6S4cDidkPcjm3jLAzZYhqLCxL1PRkJ4sb5CJ7t96HqFygE4QdWwCs51?=
 =?us-ascii?Q?Lyd+MVzZm2RqxPYf1ke7f1YsgUPSLSvTrC+IEF98fOvxGQIfzOFnLQpBaL5u?=
 =?us-ascii?Q?nNqqBZalBT2vNJSJazOFZDwKNY6H7cr30BdMHWVFsI7MngnjjRgI8aBksUy0?=
 =?us-ascii?Q?mZQG1vUuf2bpjeJ4HhX17ttLKoAXYUXqXCMI8uZSp0N8XF5SHUcDmn2qRS0g?=
 =?us-ascii?Q?wlIlBXUuDXv/Dn5SE/Gv3OQ2s1DYIU4GnCiGyZOI0CXT1OnFpmIz2jI+Ab4g?=
 =?us-ascii?Q?1rxTbHdbwolQ6RImJdF29GoSaQ8FbK03x1kYfCeatFcdK6d0KbxDwMwaMjOE?=
 =?us-ascii?Q?vXIvcaFuQiaGRfqsDFPymeOvTrlaD8TrnafKHe+0RIYl0FFX14feuo/WICQ5?=
 =?us-ascii?Q?Qnd+jV/gYEd53nvTG22qQLFT0Z7qAsxgGsQGHLBiSTUHAw+zoLtqOXIMsowq?=
 =?us-ascii?Q?y5SksvsBgGkjvFl1hPemo4enr/GULvqHco2BvZ5kvWZMtd34IBuUNUEpHPsJ?=
 =?us-ascii?Q?G+YeQdu3vybDHB2sEC4iBwE0MLuNsuCZWSB9CNL1Y0MbKz1ecIXG5JJxLgtd?=
 =?us-ascii?Q?A4vfwgj7K5Bxvrr0InXJ/IumgaoN1mtql1RoToT/yXAisD4e4m8/ScAYNk0A?=
 =?us-ascii?Q?Y7a31PxNjYSMP4M//GcNk6S0JC8u0KVm9kEFmxO0GOQCv7Uxq6IcvFXcZdGr?=
 =?us-ascii?Q?bQ1SqbDVzdaI04m96yWrAIeFB6o+4W1AXM5YxvghgGkJvpKOUKhF0UKjtJt9?=
 =?us-ascii?Q?Ti4QUHEg/1JAsd037UWRzGeuxDW61mSf2azf7XuepsYkOFa8/ny/m0H0UTEx?=
 =?us-ascii?Q?eOsgFOWQlvtZSCcs526HMay3fXqD96CNbhabijRNsLum881epOVMzmCYNTod?=
 =?us-ascii?Q?9SUs4kDeDVy3xeEzn+OpbSgskwQ4sq3r8Vai9D+IqqTMvAbaPKyEPjwHFBpY?=
 =?us-ascii?Q?poxr7HnUlWOMBBp9zoVHTyL4a/dPhXcLbvUdUhXO1t8HAr3ocNV2l1zUbwrr?=
 =?us-ascii?Q?ZouVngcMbJSNZ+CpxAgUojA173bHwCHViOTzDheaQ05TpNsa9WwVx0LhGzko?=
 =?us-ascii?Q?KTbROelLf66MyZsy+3xGK4yu2/zKBvcmQs848VPatqdKiB8mjqKBugrcL3h8?=
 =?us-ascii?Q?F31tCvCLb+c8QLadep7/OVVVZf6JX8kl/16FwQyJXQvjlXn+A4hnFwox2FSB?=
 =?us-ascii?Q?FgziGqrfj2mxwu/HCGYEAZKVxSMrMFPROGs+qohRc3S1thwSqM7VeFyyx+sU?=
 =?us-ascii?Q?4WAL+1/K7gE1aw2iFYWvyFVHrunKSf/Mmy8VUjZf5D0cEjWm0aturF1SlaKC?=
 =?us-ascii?Q?vZkHP31WQNIkv7/dwNF3HjlIAuYMOEWu3qzpVfwX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74285721-2bb9-4e2b-26bf-08de11ab3c96
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:40:28.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qnsjwHP8zQr7FZo8EeWI31xVeiIdsSLXIkzJA8pKlbHGXdptD9xRZ5Bgk+L4fJv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4407
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CFEC100006
X-Rspamd-Server: rspam03
X-Stat-Signature: z97ij1t6fn1tngt6nz9973ja7yiu6n9z
X-HE-Tag: 1761165632-210354
X-HE-Meta: U2FsdGVkX181Q/p98Vur+ITN322+dlf0HPNJepnxP/BpwvOPAelPQ23agcAf62Q+YTeUWYeZV93PL34tkYDEHveX0eIBy1Wf0sabp4V5zFM3+4zdqMvBlJEsvRrrx9nYliunpX6g6LTMCHjvmV1ue2RnVBuntCMoRhBNNkIcCJ2yXqhcnWMzLukiuP1nJzmixzbmHXNQuh+2M1GSkZlIhDqCbx3ZW5gV+8Tii1iXomsK5Z+QJR7MFuw244gQZwD+c7R4p9mECYusdZ6LLX70GWvUi4UoMC0+J3bJ+mdVTheLXdqGpy3kQ3F+WTzTu47u6ikDi9WVtKEJO/honmFa+fEIZHKW5XjEm5Gx4A0HFbjpztgO2ROu2s5ADDUFV2FSrFHB+QzZR9VcIP+zs9NnjFTNgYo38JMjNUcE1cCTU5QQbq7op27yYzic1EQJMANzcsJmD5iymtY0mI4Z24euahhZFREmBEnPmzR3a59A7l5+eSPKEEwk13BEBGZAwrV7LACoZ5JNXetYNQetkp2cWjkskCGdcAjOWaXLlSBRymZCp1qTTkDl6fh0lSqGxWrfwKtEQubDS7/UTYHXCTkRIo7Qhhnut9IPLCVpsCHBQq3e/suI+7Fgudj4OV5223p8dOlS15YvY8zFjtbgbZwr/jLvv37iRXAhdyeHeU7pIk2wUznNhPp6jMJgnL0yBNwEpteGq2k9DTGfocDHTMvSnNNy8L8FptBg3zm6hNsEwKuXbANZKb3CGiIikNTxMOdoBFMBkgyUqI0cVydF3SxSYpkC9DkE3fbMtssehG9VdcuFoOKGsTrpR9R7Y/j3DQxF31/x4AnKW6VIV4R0OMOdPdtIloBo5ViWS+YOXQZBmWoaIUxAxXurEKYIBUhBAgCI5th2QiQFQ8nqMOxI1+x/pcdfHe3698g+eEN0UEPOmzZVuEdAzVjKv4Dl9oW7krCbGta8w9PP28nH1EyHuTM
 Bg35U//5
 otV9yO0+/ezFVV35/EefELVrXXf3Egz/u34r1AaAjrVvxJE7xyBtB2SoQX2vSE8LIpze4aVKYOEvwNqkPqUbXWACEdxhcacRkr+d6VDY6+8Iq9Dpa+1/medeGt1tqRM+M00UGheKU7p6LaqNzBdXB5d5eeDjYZQKjXjMkEuxstVcf3d1kM7he4ztjhW2BULvWdwGifbV7NsgHRnS1ldBEZ4RJ/OWpIi/C1CFiSyzAtM+PQDR5NyiC1nAcVecb8EfpNJq+jv0snf0zrH85ez4WoeUopRB93W8nbiS5Qe0RI5wZBSCHD4g4Wb+UBgXZuJFQ7j4theMBMOrdjkFx7EGvZDriC598teuzXoWJBxTTTSqRy29spS7/Xc2R160O4iLpifmapnTWLnWDNz0YmNlHp1zQv6GMw4ZHkVmoC30Ix+k/8I/oTg0kFowew3rH8oFWcuMWZHSm3vuvxCrvXtUcumtzFI2YNv1DMf3+xUNcZkXLOY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Oct 2025, at 16:34, David Hildenbrand wrote:

> On 22.10.25 22:27, Zi Yan wrote:
>> On 22 Oct 2025, at 16:09, David Hildenbrand wrote:
>>
>>> On 22.10.25 05:35, Zi Yan wrote:
>>>> folio split clears PG_has_hwpoisoned, but the flag should be preserv=
ed in
>>>> after-split folios containing pages with PG_hwpoisoned flag if the f=
olio is
>>>> split to >0 order folios. Scan all pages in a to-be-split folio to
>>>> determine which after-split folios need the flag.
>>>>
>>>> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisone=
d to
>>>> avoid the scan and set it on all after-split folios, but resulting f=
alse
>>>> positive has undesirable negative impact. To remove false positive, =
caller
>>>> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() n=
eeds to
>>>> do the scan. That might be causing a hassle for current and future c=
allers
>>>> and more costly than doing the scan in the split code. More details =
are
>>>> discussed in [1].
>>>>
>>>> It is OK that current implementation does not do this, because memor=
y
>>>> failure code always tries to split to order-0 folios and if a folio =
cannot
>>>> be split to order-0, memory failure code either gives warnings or th=
e split
>>>> is not performed.
>>>>
>>>
>>> We're losing PG_has_hwpoisoned for large folios, so likely this shoul=
d be
>>> a stable fix for splitting anything to an order > 0 ?
>>
>> I was the borderline on this, because:
>>
>> 1. before the hotfix, which prevents silently bumping target split ord=
er,
>>     memory failure would give a warning when a folio is split to >0 or=
der
>>     folios. The warning is masking this issue.
>> 2. after the hotfix, folios with PG_has_hwpoisoned will not be split
>>     to >0 order folios since memory failure always wants to split a fo=
lio
>>     to order 0 and a folio containing LBS folios will not be split, th=
us
>>     without losing PG_has_hwpoisoned.
>>
>
> I was rather wondering about something like
>
> a) memory failure wants to split to some order (order-0?) but fails the=
 split (e.g., raised reference). hwpoison is set.
>
> b) Later, something else (truncation?) wants to split to order > 0 and =
loses the hwpoison bit.
>
> Would that be possible?

Yeah, that is possible after commit 7460b470a131 ("mm/truncate: use folio=
_split()
in truncate operation") when truncation splits a folio to >0 order folios=
=2E

>
>>
>> I will add
>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order page=
s")
>> and cc stable in the next version.
>
> That would be better I think. But then you have to pull this patch out =
as well from this series, gah :)

Yep, let me tell this horrible story in the cover letter.

--
Best Regards,
Yan, Zi

