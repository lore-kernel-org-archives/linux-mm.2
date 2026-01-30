Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA14D73EB8
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38296B0092; Thu, 29 Jan 2026 22:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03146B0093; Thu, 29 Jan 2026 22:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAEB6B0095; Thu, 29 Jan 2026 22:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3C86B0092
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:55:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 469448BA46
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:06 +0000 (UTC)
X-FDA: 84387264612.15.A40C53D
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012066.outbound.protection.outlook.com [52.101.48.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F54D80002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lICcBcOe;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769745303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4QaHhwuZyYRo1vThHw7667LfULyy3R1hHQFyr1poY4=;
	b=qSuKk0T6ZuWAFSkIAO45dT+LdW2vWoQ1wPLA993D/WarV217GjBC2Ugw1YUHfeC6W6ZwlW
	5IOgqREPWOQRQCSgnPnvKSrCg8Ofjr0hLYgGZTTQNME4qgyCsUVsAZ0Rku7Sr7ZApV6JhH
	XCNh4VVrbl68F0hz7SON8Hds+AlRcfE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lICcBcOe;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769745303; a=rsa-sha256;
	cv=pass;
	b=t5tv+b/OY8tQ6uC4ES+vMX0g56P1M+CAmEzh7BSQLLf6DibWzQxXEJolZ29FmvKT2VdCRi
	q8A0umIxF1YoVN5BUTjkRb50st2YBBh5CsRQr1DV80wKCUXZCJBsWqBiC9b53iiMxot00U
	vybQvjmXV2sUNSybs0tx9wQuS2vly0c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eqJLu1Kc22TjYs/aMSuCOdAc1XPj377P/iV4sukd1th/dR9WsVQRbpu5CVrhe7tE0WBAIgDrFRVimvojLQpAQTBO9inmUq/1Oi/KxxGUB10fJRlRon3KF8FVEF+Y1aDVfpK5Fa6Uzui9955bz3kPFG+DsDS7PpcUV4j6PyXxaLF58LzvY1sGKiV1mAIzRaejXJIYr71w5R6a8jCjiLYzzNMF5jt3vVk/A5kkd/yo2RVzRHTxL1WLNK+9hNXbXFWg8Y/j4tD4ZQcI3qaXpa/T7AOnLuBSy/n1o1crCGasu45e0xkid9GvgQrFz+GxzOFlIoGApe/x1KqkadyMhJL82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4QaHhwuZyYRo1vThHw7667LfULyy3R1hHQFyr1poY4=;
 b=BGaEdL5ym9N/MzYoHk14BBCocqS2Je8V/+iFot3X//NdfOL7f52YzlPsrv8tlR0qs49tsmtVk+/WfEeq6H+/W5R1FKkLq9Z6anXuDY2PMqbCTggIJaHwNAjHu47wWo3xWudql8xcxgAD1GV+8We2gzzxbSoMhgswQwT2yaBYsdqj1Ep6VP5Rc/cT+7WK8H6BSkGiaq1SbxX4BNu1VJEcj5PVQmIpIo7Gk3KHd7x6rgIwDjMwl7fW0VAyILfrBY2rAhlZiVhdrBMi6t7itx5EHUsDJoRTYd40rSdAtSJ5OEcYk8G/bFTkhNS9YgDe5ovLngIC4X8sRJFCKSzObLyw8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4QaHhwuZyYRo1vThHw7667LfULyy3R1hHQFyr1poY4=;
 b=lICcBcOemomcqLMmFEH/1BS81DHKwFNR9OwIcVYVEaqv5Cktnh1PVPZ3Wny8m60WybK/21Ef/KXcS7CKWb96W0vq2hpVIq4UW47ReP7hvcNG6Hpn2FvMzAxY6VYJhc7u1/lknMYHnhC7JEO90SmR09qiHr/QLyARzEV3R/DY7O+tom6YrFwIQCKQTVrcYLnJO7uHak3F+RTYp6Agk5gJZM95m4ArybPhfQ94jklfoVlo73PIJXZ74TPQNLlZjcftOAuWCXgAbUTcovT9ec7cwtMMlZeCh7UagYSKXHqZhpDy4QJnCYhB+X1C/H6tWIZH93VMycNfRhBucW8Z2r2guw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:10 +0000
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
Subject: [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_order()
Date: Thu, 29 Jan 2026 22:48:17 -0500
Message-ID: <20260130034818.472804-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
References: <20260130034818.472804-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:23a::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: 350d25a9-9552-4671-971a-08de5fb2f1cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7uuWkCaBnMw+jYhgVPLkT8jkd7fJOaNHXTSNXrcqDbcERIdqQ08Q/+FKEpwR?=
 =?us-ascii?Q?Id+e1bsFwdNg5mguOSRssXMWEgVRC8PutAE+C4sszkLu5pePU04CAHJ6jzZg?=
 =?us-ascii?Q?gymXFiL6XNxDeTx7NrthwVA0t3yncuSDgIxGlMmI/ycU0fUEAwtjOzUCcnmx?=
 =?us-ascii?Q?ttyIxTolYoD/uxs1La6KUhOvmi4NdnLNqvsjExwsgL3hEzC4cEflipi40aI7?=
 =?us-ascii?Q?Piymlt2vGCopme2GYZZfWB2EqJ7KYi3bVRof9Q7XyWd5hYoUkWHHXzj8e3Dn?=
 =?us-ascii?Q?B79bhj5Y+wR9l1HuMruLo7G4CceF7hRHNt8XICPecl96AtWNvtJdRBAX5N3/?=
 =?us-ascii?Q?NV4oU9Obh+kloDeICq2QtYy3557mzWC40C4RM6fsc+TWME+DYyP7xKH+3CVQ?=
 =?us-ascii?Q?ndryw9/Ls+AK0nNuDoVFNp5X7uMoKjbRcfHVyoTVcO3HrtlH8dwQcb3C5slj?=
 =?us-ascii?Q?5FE8TfASfxIu57NC3OwPTWowCvsaye2hODmbUEarMdQUVpBaMbQC06/O6frJ?=
 =?us-ascii?Q?kvqQgQ7xK2dcEy/gdr4rwGCruXQsNQnYNSHuPDZpcgvWr5N05YtPRO2T6U/M?=
 =?us-ascii?Q?6CZyf1MBgM8PoLH6dxDF2QudihhDIdQ0bKgzdZfaB8IsuZtRj5UbM9/QNn2b?=
 =?us-ascii?Q?4NbEDN3Xnj7Gj7oPlKW/1Wtvcb1ivRenXROL7KiIQMqTQwciwP6Ubn92coc5?=
 =?us-ascii?Q?A0d+3jeMbIBH0456BR+stIdgqNxYYxRqVALL1U7TAxhF2/kYMil0hPoJ3gXs?=
 =?us-ascii?Q?1cgMyU4WnqZmsv8tUG1SUrMSJEz6MCHNlk5+x73nUnxOZ0SpAMba+Xu5YCW+?=
 =?us-ascii?Q?5uysKrKzuBpmiuVaeQ9ykogpjwkDVO6bC8GynS7mVJGjIxbuwt/oOsJxzyo5?=
 =?us-ascii?Q?UTczziM7d86VcSJl7K8dJBxP/EZ7+sa8SfHjUsvmkrHCOz5XQ20emF5ah+tS?=
 =?us-ascii?Q?FjXNQ4pHuSd1DZK7rf6+XT6s8zmzHkyidJOuY4LyOUyrVFCPFop7hR4efs3B?=
 =?us-ascii?Q?V+h7ig2nSM90olGqef1nSxol1EALA598c+m5LOjtoe+rBr1iYqken7Nledb1?=
 =?us-ascii?Q?E6B4gKWNeOSsmX7ZwODuQNiiTfjjd/EYbetSnNjKjYDgjpB9GUOHbWzzbtXE?=
 =?us-ascii?Q?VPB6L00nmXC9FJZqKRqCuk1Vo0lyj5eQR9islnDg2wEEzBldQISv6rtes40e?=
 =?us-ascii?Q?1WQUCeoXQnFP76nTjrMHUzO27Xsp/pvWJIfOoqc8Hs/EpplSTdbaACEXc6CB?=
 =?us-ascii?Q?Sy+YA2JS3IH0L5q21UuHEqcORHu4iIdggPBCuiT7ogo88/xnX9FZ2A7SDl4m?=
 =?us-ascii?Q?Zbs4k4ctEM2U1Y7bEy1G27QgFTOstCo2P7oJKDzGFRdYZYFeV+LDhhLymQSj?=
 =?us-ascii?Q?Vho8/lAHtP36Vo4XKo4eBMAX+r/zrM8FW1ALjs+S0HPvPJujzKXbt29Dj5IG?=
 =?us-ascii?Q?KaNGoolsWtZjWN6AN9uXIJ804JYw4jboCB3r9p4E2PbS+MC5MeFS2IsGS7Ro?=
 =?us-ascii?Q?sw0cmIx412F9knKHyK/97WHmLcjQFtVIT7EUhrkcp8zGIUQkYcbmi13f7bwj?=
 =?us-ascii?Q?TeU4Z33ZwuCRryExxCk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?auiubOjtTr/3pnRg02l/mFFzeqZkV03T41CApq9/USKBAsb8I5LFt/0kxQSD?=
 =?us-ascii?Q?a3mxq56EAW28p5ANP7xOKIpnf/MJS/AwIO5xzf7xY9EkWh+uPStfsbcuT+Xe?=
 =?us-ascii?Q?2w5wayIVFdiG79q7zWm5nZSPFovw0M1UJuLgHO8XmfnX84DbTwiv2qmxoHCL?=
 =?us-ascii?Q?kurzcRf3gM18kcTGsvD8MrwrMyfSNKZtMJz3WJJ37p05WKb1A1Yn8KC1NtsT?=
 =?us-ascii?Q?PaS5D6VSqvohBA38T2wLYvagUW7xIczS7H6TplhryRAvSh0hPYWs2C5UwIXd?=
 =?us-ascii?Q?ApOFGbKOK750g48L5A9ocaJIvl8dLzBUNdCtnyEJZchjFACQ4PgCO13FJT/b?=
 =?us-ascii?Q?Ev6o4e74J5oOC5C4OWPmEE0PHYlS5SAXMN+01SIPklZepkxulldxlOEbytr/?=
 =?us-ascii?Q?Zr20BDnYft3TUYE+44mLZfY5Q52yc2m9SAY9qIjKB7mPYkUJFOd251f+tmdr?=
 =?us-ascii?Q?lbIZz0Dqjbh+0N7LCOYEUk+W7le1IR/ow3o0Jng8t0OfElWFB/Nh7S3HN8Le?=
 =?us-ascii?Q?itzSacIlPL1eMwlMuyElTRB0FnMJ6eG30ARGfZWzFq9M72VRDTQjCqDF6zGP?=
 =?us-ascii?Q?l9Xq3F6uYEXut1Bj0ECpzptM82FWce+MlsSGkapwT7kiBSnc15pUbdTMwjIS?=
 =?us-ascii?Q?4xy4+VYNetoDIUsYfx/96E4WVSX5iQrrNi64RKkH4fEVyhPv7KG9IaZBrIt+?=
 =?us-ascii?Q?J+pl0KuPpkoiZtHDKGqf7AfSZukvs1d1Bcu3jQQqTJkZBoffqY/5bU1bSLfC?=
 =?us-ascii?Q?3e6nwUvGG36A0oTdTPvbnFSuDPLtShNBjCEM85pTe/SDLE5t3qqeYKvLQdK0?=
 =?us-ascii?Q?eauC990w3rXFu2RsG1ftuFt3TNthc3foaMvCJh0TOTsxArGZhd4e2pgpqBbi?=
 =?us-ascii?Q?MHASjI2akhqV4JrH8rbUJdxgQFJ8FhnR/GvDh869fmJYR7IEeD6ucdgR2VlO?=
 =?us-ascii?Q?dGkwQxMjVNdiknBx8xMu+mTrs12CDXChcZnbgYzU8rL/rSvyZvV7I+KYYd40?=
 =?us-ascii?Q?EjbDr+bawqhFiC3dsb8OHNFSLY/tux9fvLORakJJPmcuJ6ZlQMg3N0nTukFa?=
 =?us-ascii?Q?BL7hfP3xFdMHGNQeksarpzg+0ykLQKWa9R2z1C4kYhD1PvopN5J5pJ2iM4LS?=
 =?us-ascii?Q?5/qVVYvLIVRvhoBnpNOl/WdhYwNoAb4Pd5eJnYK6eSlOF118AURC72FUV8ig?=
 =?us-ascii?Q?f7kNiHkYkn8km4iGwROce3RhMQ+bqToPhHKjpXK1uNxx+30yFakIi0ijPRTd?=
 =?us-ascii?Q?sg6kJ7AgF3murqWxV1jDzXNTKSY9Edlbzl18g8u4bmWWrvZdMT6masLGM7RS?=
 =?us-ascii?Q?8aBKke8vIiXDesKrNiPTCFLPaaq4AUHuLQkZfK7lzf0i3cGcvMZpAsKHqAD0?=
 =?us-ascii?Q?nf3VTP/mLRSSg5+maHTDWDX2FH5gEcOixfd72H+XqSUK7PI3NusN5orhrqik?=
 =?us-ascii?Q?VZkl+kIWiFNoAJinEeGeRNOjBzYuvmNBAEuaJa1/AMGA0Xq4+lPnJqp/hbI9?=
 =?us-ascii?Q?6kAWPG76ck5ERM9Mm2cq3t9rAhBaJzRMXAczC+PnVFiV5XQJTQbNPKVGOJKh?=
 =?us-ascii?Q?Qug9vOavL7xbG8AHPPsAgPd61uH57/dAwTwcxZVtOxwQayTtA9HUc9gfCWxq?=
 =?us-ascii?Q?wTEE07Wengsesg8MR5WLh4dCIpk0gaLucISJ0XCMjbBI6DZrcY7u46Nmevgu?=
 =?us-ascii?Q?kRjiwoWXst2/v5+P/pCnLDQhfwwUtHfH64xZV4dS3GO/9cgy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350d25a9-9552-4671-971a-08de5fb2f1cb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:10.0046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZBH98EMAkhUzQDRZp4LmKiv2MSTSYR0i+SeupccTzcOcBL5dd+SgUdJfPglkijW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F54D80002
X-Stat-Signature: pnzp5cpdxmow3s47kmzdwa3cp768zzk8
X-Rspam-User: 
X-HE-Tag: 1769745303-375693
X-HE-Meta: U2FsdGVkX1/yLKyHtWT4+AgBWUbztJot7KF8mWtO5Ew0GDU9UnQ0EVAHPGKHeMHKux0bg8YAefsa5nDvbK4ZdXNbL4mphXjH4tN6oaLWKRxagZMg4ZCvv/iiahnac+h0GuXm7uGTzVx8Am+Haeb2gd9mU6pEB9J9NmgJzAbYD92rwRE+FdmGnxalIiCIYnY88qfpjPN9bTvRY3MwWC+EUkekY8RF9PMd46i7aIPDcIXvz2c6q3ruYCXLgw1SbXjmlqVtEtMruOF38xe5/VHEEv32AQoDCl5OHrTvoDFdaAmA8dl1F8QCVS6CzOmFBrq4m6zLX5SfGo+6CVje9oqBsjgslNM2scQ98sedvQvXfrdNxdGYLbIjXcjld0oFJTuEl24TuTFh9U3MjtrKOv1vE7fbM0Jx5dyMRTSSK9By6dLaXEahWgtUCpbMIUAPxvqEsrGv8baKrdj/c+5Hf0AUljclph8x1gMfQT4qnrSc4T7b/1Xm4b+YqK6nRrx72PeBc9GhfsYZ97V27azxb7bP/Vjq0m/D/tWuJlE2dz4uan5Sspv2Hyarigv1a2CScrODj5tYbaWM44kEduy2m18zpsjjOH3Ngh62agKZqE7YFw6AO0kXTyR6hnJnflGzfDAzTZuItD6qqNYQhbph4cX/ZKUn8KS6Sy/tn6K8hkID3vUi+5nn9HPx3X3GezFnVJWe7St3zws9MXoT+2F185dCz2D5+zV/6tP/bTVojKVjvJmf4Xl89gyRAtdbgoJQmptuUjIkghR9huxFcoWZ72js5Oh4Qypy9UnHVy8BWklC0e9U3wEetMJBorXmKtqLm29IgiRASHc547k1k8z89FxdUTqzH87cO7AObXIzEsS6fB1i8x3oR2RRrw557qyBU/Tge4zQOdhTRsNEok/5p79N1gNgB4G9xB8eCK2dmr+f0812HELqD1yiUnlW76qJokj/raDO0M6FpNxJwscPOJ8
 AYuxH7Gg
 64olkfRjCmjJHa52iVbCVRHrgPOFNk4tja9VdztT66cndvqyg1mrt8t7YoJoOwyXUrACTnokgENPukrma/hEbpe7GFj5NX5QHPrlXYJjHm+CZ2qC1epi/xoEg79Z9xr8jxW8v+voF0S705x2C5tPb6SJFJng93I4TenN9l6ty1TFIkNYpvqgIc+ALlJH5CXr1xKvkDIKBw6EyL0EZpvM1Xvme4tp4HaDL+h4xPqjjzdRp1G+B2pzP7oBzaIawkvkRQg0COi5X0LNec5mPzKSdsi5EHtYqjq5BB2jh4SKfACyzyvHz5wWtaKFiWBxFnR8UIkPpC8uFZPiMP2aocZZOhVEhgP3Wcu+6kDAEG33YJuzLvKDFVcaRtDc0A+F7S0X76wE4LQ4kaAVsDOqPDa0XRhiQAcGWM8m0KS1T+QJfh898ZePXZSEo81kvhU7/NeyhGo+FdGx+CtaiG8Bg3PBsL7/krg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A compound page is not a folio. Using struct folio in compound_nr() and
compound_order() is misleading. Use struct page and refer to the right
subpage of a compound page to set compound page order. compound_nr() is
calculated using compound_order() instead of reading folio->_nr_pages.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/mm.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..f1c54d9f4620 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1428,11 +1428,9 @@ static inline unsigned long folio_large_nr_pages(const struct folio *folio)
  */
 static inline unsigned int compound_order(const struct page *page)
 {
-	const struct folio *folio = (struct folio *)page;
-
-	if (!test_bit(PG_head, &folio->flags.f))
+	if (!test_bit(PG_head, &page->flags.f))
 		return 0;
-	return folio_large_order(folio);
+	return page[1].flags.f & 0xffUL;
 }
 
 /**
@@ -2514,11 +2512,9 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
  */
 static inline unsigned long compound_nr(const struct page *page)
 {
-	const struct folio *folio = (struct folio *)page;
-
-	if (!test_bit(PG_head, &folio->flags.f))
+	if (!test_bit(PG_head, &page->flags.f))
 		return 1;
-	return folio_large_nr_pages(folio);
+	return 1 << compound_order(page);
 }
 
 /**
-- 
2.51.0


