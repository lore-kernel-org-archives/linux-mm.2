Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A671EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557206B0088; Tue, 30 Dec 2025 21:57:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8ED6B0089; Tue, 30 Dec 2025 21:57:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC0F6B008A; Tue, 30 Dec 2025 21:57:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFAF6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:57:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B24EB8BA09
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:57:17 +0000 (UTC)
X-FDA: 84278254914.27.10CFB48
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id C41E71C0003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:57:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="App//InB";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767149835; a=rsa-sha256;
	cv=pass;
	b=HXf/pYfb3Jrkrby2WsLgMP68+uKqsu+nPdQKbOzwRtGYjXZ+09eR86mhffeuz0HLj9/bsa
	E2pYL+OIT/U1nse+5y80/nur2W4oTTv22prYb6h2J8vKz4sH/0MNNJx3w4fkrYyMGj5vEX
	Si9Uh0t9T53UeVa8/LD3n10FvD229vA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="App//InB";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767149835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmPpGEzgjoedlO1XcwL+9LIsQ6iMN3tfW7RXn/nyGiU=;
	b=AzmRUE0VK1S+H6Rk4T1NflmnUL6qD25xl5wg9TK+odiSZ1C7aMFQmGj9pzsBvSRC5/t1tl
	6cfqVeqEK0gOWlL7vP+ffkuOZlOBKkBPHoITqYVb5G/LrvX5tj4BHtldFiR9aEnx3ufCWc
	a8IMGMR1Yi1cf0hXBzMlLVCrNWSKqB0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vv7iaWPGfSgFu8NWi7IlySZc4WfMGlWPIf418VpRrdNz1FGD9sd3dU4dlPsWaz2CTjfek+NBQIXL0xQjBNBtj3YqEsaRgBYrMH6rgQW6oPaD5cXQWFEyqhXRi6REtWU0SIL4r0mweUcmPggAMDZKYAzu7nC7QytYzN97L6m5HkVHKYsgZ/rxxJmv95a9PFAy+REFu7eTmvcwnTjtSqFye6BspEYDRysA1Jn2/A1tu63tLhZTKfgKcsMPe/USzKyMdjm2tGsgoct5vRsu/D7I30HhqcR9o/RWjBB1MftmiNNidCqO6hTA6eZGCpyea6I9zS6/JWYz8mvCNu5OLeDm3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmPpGEzgjoedlO1XcwL+9LIsQ6iMN3tfW7RXn/nyGiU=;
 b=SaaHBIYodJPHH3UYS4vF5/Bv0Q0XlibOXYZL+MvP0wuYef6dO0bdWX3+gIWsFi0StBKEWRi7OOJ1A3XlU0cFNWfA/L0KuKe9ATU0hmq8TuU0GMXl12Sr2VJG9qSOnQKa5J3l3Pzegr4Ls0vYH5B6jpTiXL9sBxTL1K/pG3yU/eqmBVL8/BQycLCXp5N1rCElnywjIndeM95P43qCWVD9vjBVfHjEXfu6UQwTAyKc0udyTjn68poDYc78q7qtBirgyH2uC9a+MEgSWLuT1XjWANfFNfFU7CNIF+M6UDylg297ASo3I8FwdXzDfe1ysOVsLKH/86Kb42VB21SgPy9jpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmPpGEzgjoedlO1XcwL+9LIsQ6iMN3tfW7RXn/nyGiU=;
 b=App//InBgLdGgbYM+xuqW2eZ3K84Qupx6WU/XX3qRCSi7WJY/VecalhVZNlhhL+f2KjyiVn/gQpZaS25/G74MTQ7sUKada9veaFdIF2/AWkIDa4eb5JIgiy0UZHquLE3t8rfcRc32wmqSrkRaXb+Ai3PjSccHqL8pNITsh0ZV3ah4i/Hgc/EQHWCQnYYp4Nd8Y2SsfN6ENiusZovgWRO3b3hLffpcr8MMnJ3PAegjThwr8PgHLbr11rcXfqagg0WCU/pAGaAUcfTr8iRvHj0OtFaJyijqb9pnMSO6DsDRRXMQN5YTaDpDeUPYjhsaRgrrojvuN7AsDX+C8axjxlQZA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 02:57:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 02:57:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 4/6] mm: page_alloc: add
 alloc_contig_frozen_{range,pages}()
Date: Tue, 30 Dec 2025 21:57:09 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <5F527591-EA6B-43A3-ABBB-A18F0204F65D@nvidia.com>
In-Reply-To: <20251230072422.265265-5-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-5-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0084.namprd02.prod.outlook.com
 (2603:10b6:208:51::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b394e4-8738-4ccb-01d0-08de48184b5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a7+nMEzCTMAIrAPgnauf9SqsL5vnJ8IzOdRxwJOcPrMeDhpMmauh1ttlZjrg?=
 =?us-ascii?Q?Kg0C42ip8PP4gBwhL2aaWkPXo4ZHZ5Fqac3WTaXVAzvFmiNwjQJzFfPqE/Kg?=
 =?us-ascii?Q?n64VKJDMEkXSL/e6VahtogpEARRYLE6cSJmEAZSWFEPYEESZ5UxLT4ROwWNn?=
 =?us-ascii?Q?BbQCK4YZLC5uyK5KLTHgBbMgYeILF1jmvDPIp3jKyMoLcf4kxtytPEMhhDJV?=
 =?us-ascii?Q?Q0WZ8qmYppGjsTIVb9p/S7XxldePTZvox/VxkMqLGM2lohK9HX8CzZpzilKb?=
 =?us-ascii?Q?pinfksllhc3ddYi/tfbPFIlnWqZoZ4NxUWnNx1mNyRX/aHGfdDVGL+tmLYqb?=
 =?us-ascii?Q?abbHfRr7qth3sn1sW7iUVAKMtcEY6zvGifnTiIK3WgFeK/Dg/vAQjaYYiUQG?=
 =?us-ascii?Q?Ob7lKyFob5HQEX/a8aD6ULFwsvfi27P6fiCJHewhyM/RLVgCJdmhHGg7KDo4?=
 =?us-ascii?Q?kZXl38atPmdhObNKJSLBwTj5yHM8PZZpaU2oji/Te7410HgoaoOWNjJJzzoY?=
 =?us-ascii?Q?2Cxo9ldCH1kJlTra1gfipqSB6EQ/HAi0WLseEy/srwWamwg4rWgAsDMgOcQF?=
 =?us-ascii?Q?rsM6yGXeFmdRmpFosWfzDqucdHnVlan5QZXOLFGD0lf16DXnpLOSy5omjtqW?=
 =?us-ascii?Q?EVop70WuF1bMki5XniMVQRWmYV5Wi3rxSOQxg7A7PaoBaHL2iOjQE5++dOq+?=
 =?us-ascii?Q?E9D3urS4fyHmG6wdZM/QBQ5ysWuk5Tcwgzya5WaTj0zKyEpEQjzD8Rm6h8SO?=
 =?us-ascii?Q?A/uZG1nsIKEmprk5Y/QGHjC+4HyyH0zPLtbz/C0luY3fzFeuF9ojGWKa3jss?=
 =?us-ascii?Q?CcNmXX/Q1mDKP+ojUbgE/ay4InfeEYHVfI4pmAt216B2C+h9Hp1zbh1VRye3?=
 =?us-ascii?Q?6EkShrKlFCOkOLQjErUL38U2Sx32/LlmPCyLZzOwF4FRo7Mq9EIV4TUx/sY9?=
 =?us-ascii?Q?yXBI3uovuOZqw4IGuOMmTRZxovH45MCh/YDjTM2Gn2QWxbJEptbVvSvHzo7v?=
 =?us-ascii?Q?bkoaDS/qbYSStSE4+jBxzTHuQybalm0Pn2hwcEJ/X8WdZiHuDJAVfdyEex8C?=
 =?us-ascii?Q?xBfQQL529E91YoBUsXrYAQZhczRYUqRO2oCb+E+C3XrslYSsyt8c16pxwuVJ?=
 =?us-ascii?Q?2+6kFkCRTpbEAhJVuMkoA4jNc3ZX5jl8qGReJKWEdw/z4omN8ZcBbrmSF/hZ?=
 =?us-ascii?Q?VSoeNWXtsOpuandMWgfXWX5r7G4qRLPfWsoUgBtRMsPr2IZPNxSsodQ0WRs4?=
 =?us-ascii?Q?MJ0RSh8PUYzR7OGGCByI+5s4HeJFklkvRTTNLkH/nWaTtCOGoNuQXaKGmZ4u?=
 =?us-ascii?Q?DJ2wZs0XbqndITFGEmIldyL9PJlxblGMyRJnaSy19IVpp9pzvZysUeUydCLH?=
 =?us-ascii?Q?Klbfttx/nK6IwMLg2/+iCoTvK1CuHK26oBDJEx6KZ6vp0zjKEKhXqaItcqSp?=
 =?us-ascii?Q?VdJnkrwO09Ax9VF6ZXZejFjwAY5Um02l?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sc9N4yA/hia5iz3gld9v1UYIzZZvHEm5wA0cyNwJrluaNEYlA938yslsf/f9?=
 =?us-ascii?Q?eZ27d3yTNEbxFePpuaiKNhLmvcPr1XdCSP/v116exWZrdQWelpDWRDkVPtQi?=
 =?us-ascii?Q?9ixsn1GhCjKyuVHzTMtV79voj2X7g5WesnFBkkekC9rv7m8CO8QBvNtIaj+3?=
 =?us-ascii?Q?Vr1yivX/WM7eqYTCMatrErLEftY+jLLZSAj/an6qM4qZ54wgm1U6+vKSQGwE?=
 =?us-ascii?Q?whzqMxYK3M66eIpXDd4k5AJF68Udr7uagkIy12m0umD9/rk6tBYMPaHOv0FO?=
 =?us-ascii?Q?Y9aUfS6xy8xctCircy4j9a5/EtbOqn/ePkOSNCfePNfHXU4ZDab4nd70p1y0?=
 =?us-ascii?Q?NViAYYneVat3PCb1vwaHAOMsJ6vM7/btefOwraLDAGeNTtO0sOspWQygi8xg?=
 =?us-ascii?Q?w6y1gRRsXhGB8VD9CtwxgI6t1nSFeKFkcBTLPO8hLeKIR4Ow1oRIRLH+J6Mq?=
 =?us-ascii?Q?GFyRGDZL3CC+8nSyuoYiWTyc9r7OjjsHAqkJ/uNwdsZAJHKdMdIY659wlyGM?=
 =?us-ascii?Q?UVHDnMHggdpGMxxA+jJ9eVNbYqIONezU3+IKpFRsDLEWlkbhJTq9PfGzuyiO?=
 =?us-ascii?Q?mx2ZXW91SxLfHQCfSK30hnAUBX4GjfbJuOoHjXzq6CIrGPHlTkZhpz+IE1Qr?=
 =?us-ascii?Q?LJyIVmAPvgj7uFqackunCg1ldeQNC7RoygK5lMynlZtakIYj7SUiN6hjI0I0?=
 =?us-ascii?Q?B2gZ5hN04xxkyYCo4nJkxNi80UX8kQ2XogVaFIIf/aJKECA1Q/9im5ZsGCQx?=
 =?us-ascii?Q?DOBCcvqALX0q7SuzzXhzYQsdKcUeDcB7VVAbF6xNnQ58QzHSNEfQxgdSltc3?=
 =?us-ascii?Q?ZaN1ls1uzHGkpvebLEJeeUEo8X7jD5ow/I2WWfYn5VBTuh4t/4ElpjItL5/x?=
 =?us-ascii?Q?B0IG0MgXap6KawAT5c3aMehMr6aNZJcNj6znVfG2u+1mD6L0g4pxO06oZrpV?=
 =?us-ascii?Q?0C0uqbN0zuGs46lwGZvkVD8pZxXUKB9elr38y6wWbV9Kq5yMznfMe/IjNHug?=
 =?us-ascii?Q?f6unpUtpKXvsMFMMVzdJarHTL5DpV4uEsBy4Yr2hsvC+nDNEGXlU3ZYKFfVx?=
 =?us-ascii?Q?ru+k3ZjLDHr7AutGleS0tskpAbGMdMia+EmvHjAtVmzEnf55nEiZjgDc61sG?=
 =?us-ascii?Q?hzPGQ+fgsbEVZE96m6ThUAmtyV9881FU+3B1PVseLhREATary/KRKYML3dOg?=
 =?us-ascii?Q?U5qnjhKsbfXEmSSPnnVKytSUDxkKlGvAQvlHq4kt35K+In8NqypKElniHB5I?=
 =?us-ascii?Q?JWpjEaVMCEBg/47eoSbb8tRHW+E2QtkD29xe+bV/cN5YWA+J35XdahSYjuzo?=
 =?us-ascii?Q?IgIuQBki7pr9ipwTpiXwz7HFRO9SQ8hbQsLAmwHhwCLrd974nn+ut09m/SPW?=
 =?us-ascii?Q?D8w4fysH/2GsamZxeF0G4PqJZwxxnElP6dgQw5zHnadEzGmUeRPU1aji/eH9?=
 =?us-ascii?Q?xoahWn7m89Z6ERdNoljF5NPcCbnup+/CuOy+E9mCZHpp2JmXDPSzH+egnXcU?=
 =?us-ascii?Q?S7vwYR6r/fKfXlEkttQIko0NTFjBee6XNfO+QYWGX6GCreIMwgC0qgK3+aXa?=
 =?us-ascii?Q?DtMRFxfaO0lw2ktto4nPmuuAHS3IyyTChNnETn1hhyHNjRsLFFAB6GpeMGzd?=
 =?us-ascii?Q?fs4QnQmJbXtJnOs5FrXjdKJomZ7EUbA8vdF9Af4urND0Ax9j3c/OPJ6hjfWb?=
 =?us-ascii?Q?Cy+o3L11DXkQ0Ia9Z7MX0uJjlDaAF3wdIqinuKsyENGGpMJL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b394e4-8738-4ccb-01d0-08de48184b5d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 02:57:11.4780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSP/lI6D/S2Rlt1G7l78ouHINXuSyMmWfCvHrjTHo4WtPYavwgHMWPqge2yIp0WC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Rspam-User: 
X-Rspamd-Queue-Id: C41E71C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: w5hs9uuobo1eej5qraihxcwdkj1irde7
X-HE-Tag: 1767149834-80491
X-HE-Meta: U2FsdGVkX19Jju0rJNnZemtbG+xOTgyxdh98HD/nhtDB47GOb7ZT8zezBjaHuxn01NITD3i2dNFGrqMOT09kMuRvrw8T53Kk5LhZHRluvLzs8A+brDG1YBlrOTGlIYUee0147qvsyaepZAl0vlj6ZVgbKKskijMu1IrBP7mP2wiD/6AkggcYY/EFPOFVxG42fstDkWj+tOi1zyX18p9tURoZlDbAm0YrLUeKGJ1NiWERhDl2MePXlWyhAF3qnx5Z+y55R/7jxoGlOQAc0Gbj7gS8WQVirGkw8pWmadZgfaMTK4jVuZEErzsydRJKTKuHuzBVP8P8eNbZsxjWx3U3jGeZcVtr0rvA/b01SwHNQwwCEnODklnVsJD3Hlt6VcsO9es3DTp/WChtGDvK1rVCjQEqwX0fiWLMPJx+dpTSCqdMc+KMP0R+PVcCLUauTIWFOIERFkZANekh0+yiSjewcKihnTT8eG7mOp5ElOAlxayv7uxFoCAPDgsKS8LYuBgUP3xhFvPLOppP67UChWX6yrPCZGVPYeZWu/A4uUcg0LoZ9w1XGH41eD8BcduHLmhr9OiRClbEUZurl5T2VsHtypS7fZeOD1oReK+OfwIWPu+Pfv/gGdO8Be0kY21Dy49qnLeHwFeWcvA5ZY1wsHgZy/jRW2D6Nvt1WZGyJ9AOW0MmsfblHzaYEe7j1eUnfjIYPNF8nga5LsaVAADwJ6vrM/T/qYMU4JCf5QEvcA15hHTHupoe0D43LdzY04Re94ECH78vM60C2UsTQKTb0qrszWxy0VYqjCktE9DwFdvtou2F09bGQGvE890En0Op6vlz8tnh/7tC7HYqb0JOjwcznunNcK/7uCQx6DlISMWg+YmRAwjkkZ85uMnXG3JajC+KVHEkfyAhcfILdIRs9A60L0dWTWW4KaPesHy4JZlxcmQJZgudqGOzQM1F8VJbouz6Kgp3vyOvt9YGOPyoQcw
 jqSSPdu8
 uMocYtLo3x4YmDhYUIx8mmgVxoC3zXWTjCg4LNlYDCw0FkcLNoNn2QnuX2wlG/8VYIcVnauikeaF4SjsGbhth9Id9Pl6aBsTPTcZSba8JLEPrhKs85EY4vYjIv52L1lAThUvwHp6AjvacUlSt3e9TrYVzgIqa0pg6TtyvOYZ0aaIWNHshXeUb+Dhhw6MI/zJPf5uDL8cASyfU2jUxEoB6aI27a7yv9kGwo+JxUXAWzWj81ZxNVQF7GhVUnIoLcvkRc/dEZh65kd+oshT9ZbOF0qQJYR/IQfHhGpgxVEJDN1W3F41oTJlB4SiVtyNYW3mjkfrq/Ua9svNij1aXUwyxkifTuaBuAFMkFcjcp0ofJ4OMG3/6APb1s2LGH1gv8AcQjfERntUv9fxXdZqL6IU5lof6BA39fxnkOMVa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Dec 2025, at 2:24, Kefeng Wang wrote:

> In order to allocate given range of pages or allocate compound
> pages without incrementing their refcount, adding two new helper
> alloc_contig_frozen_{range,pages}() which may be beneficial
> to some users (eg hugetlb).
>
> The new alloc_contig_{range,pages} only take !__GFP_COMP gfp now,
> and the free_contig_range() is refactored to only free non-compound
> pages, the only caller to free compound pages in cma_free_folio() is
> changed accordingly, and the free_contig_frozen_range() is provided
> to match the alloc_contig_frozen_range(), which is used to free
> frozen pages.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/gfp.h |  52 +++++--------
>  mm/cma.c            |   9 ++-
>  mm/hugetlb.c        |   9 ++-
>  mm/internal.h       |  13 ++++
>  mm/page_alloc.c     | 186 ++++++++++++++++++++++++++++++++------------
>  5 files changed, 184 insertions(+), 85 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

