Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32767D66B9D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 19:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934326B00AD; Wed, 17 Dec 2025 14:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B5B6B00AF; Wed, 17 Dec 2025 14:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0436B00B0; Wed, 17 Dec 2025 14:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6786D6B00AD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:40:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB44DC0D2A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:40:36 +0000 (UTC)
X-FDA: 84229980072.04.3DA0E9D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C1BC140008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:40:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UWhKqK0H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766000433; a=rsa-sha256;
	cv=pass;
	b=Rz8ZKVYH/x2EEwWEtWTMfldqd6y3mypJXo8W9EOF7b2Hnv9Dsf2Y37nsmfy1nx6aEdGgfA
	1Iakba8dkuFQDYVgYCub3iVFQQZ6u2X+/jhB733zBjnkmxBMK99CMJIeZfNhJG1U8rjYxn
	/P3ApwUYk281Nh/hqWLaNwsUPseFsT0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UWhKqK0H;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766000433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEAeJ4yu0PWa9oY5fhajAoUna0ZFXavcEIjPLr9RRRc=;
	b=oBzJSPNmWTzu4SUXOeSHdBZ7Cnwc9XuEf0lltRUZDN0vKX+RETuIW6KeOGaiccbmtpDppp
	vNtauhHIaanGjTNdrZwPPSFVSJy4kyL86omDnWI25CaC2EOXejBbTpqucH0hD39As95dRn
	ymc9wbb3vr2bFHEKsp/p6pGcXVW8hkY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDfxDdRREncRD2HI5EJn3FJDRxbfOBAOItnsumzgzc9FMV223xf5kJQJgTvrriRCJkZN5yS3XD3gM8R0QEKZqLqRTg2P95mPEO8KKe7KK4quwkvDYOVHWS4JGJOdg13fMrGZuRD3KNLIKNQO3FWuELa+hS7gwsx1vlU06YkDRtSrPadA5UqF6MROVLV/3ER5eDnTkDjzgAFixwqBBTRe9D4n8QlN17HQ1R+BoTbgLsayY8BV2ddJPGr0DMcqPLCgQzr+94mXKnIXnbFXkW0EmH4JDJmJgDNCE4AaJCFQ6wEseOOzvciGnquA5MHie58d7AjIC1afTTTrIO+yatYk1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEAeJ4yu0PWa9oY5fhajAoUna0ZFXavcEIjPLr9RRRc=;
 b=gR9y89qnOQs5QnMumHvZQp0+zziSbIEc4kFLPWPYppsQlyFHhI+Aokz0ppaVXYjN5j/AIUFNT8ofusR8VaiKM0a49l4mSqCMI8pDt1eBZMBa0AJA9s/MRoO8RbsaHJ8NUDHfyOEUY6m8kzRHGk4AQ/08xWAub7HN4sauNlcaAwdH9nt1kebh8C+oLGm9sfy9ah2OL7wFunJN+9X2pj+7mAJfz4l/OV4sC3swBZ/2cxEqKf15Wuo7kkUNQSA/+3gYBlDThsBxTTHmlW9tP4LetbCJoym8rSdqWg7l+bFsl46e7cOiTl57zppNUkTacfsnkqJ3CcBl6hvDoIWFCcKTKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEAeJ4yu0PWa9oY5fhajAoUna0ZFXavcEIjPLr9RRRc=;
 b=UWhKqK0HCuzZHPi1dEURCM2484A823OeqvvpKciDBE9CHtEsYqz9Im4xZJmk8dM8JrkyvayI4Ddn8cPofGxhlB8RpE5TS5iZnh07ZftV+Ih78D7alkUPpOJOGIuXr5qfYKm37hofrw2XWvyJN4NV601LkL+YZ3XTw7PGPEyok0k7mGm9LMOBuTCNdhcozC2vNQkxl5xihDjrC9225p+MfOB2GWLcHTdbbqGf1LpiOh0aMbIg6uDNBOYDOczN7+k6CEnnpnWAsfAaiew3kRi0re4nGE5M8GfmZljpAuMQ3jRKGAt5rNfkULP05X//bSI/IAqznbYWjibsSwXlna1A9Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL4PR12MB9505.namprd12.prod.outlook.com (2603:10b6:208:591::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 19:40:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 19:40:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
Date: Wed, 17 Dec 2025 14:40:25 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2A3E14BF-22D2-484E-AAF3-29D8D918BA73@nvidia.com>
In-Reply-To: <de2e93ca-830a-4bc0-841a-1ed70ab1a61f@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-7-wangkefeng.wang@huawei.com>
 <EA31F2A7-D0BF-4A49-8F05-C2E7B73A3556@nvidia.com>
 <de2e93ca-830a-4bc0-841a-1ed70ab1a61f@huawei.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:208:236::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL4PR12MB9505:EE_
X-MS-Office365-Filtering-Correlation-Id: 95cd81d5-0e26-47d4-7799-08de3da421c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3eSU6Oduxq/SG/JRWzVQaaJH8gJa9CvgEd+GGXhWLnXACnXrkIv/ojH+aai3?=
 =?us-ascii?Q?tgUHKF5bjANV2xnXxRipjPg0biT9vyfhFwwF87Rv1CWgoV/xlIy/buM5thD0?=
 =?us-ascii?Q?Nm0lSGne9voQ94HGEI0h4973NqXL8FIf2O875caOoZoAwXTvxawVEn+w0SRa?=
 =?us-ascii?Q?imZgJFmJvURO8P8WzAU7Zz7vjFKewRkqtashsfVmrLPRj2y27DIaG7Lle16Z?=
 =?us-ascii?Q?T8Fx5xyDRpStvmi65DvtEiymb4/7SAkXD+LINIqvnzaDjzC1V2RFWaX/WD4K?=
 =?us-ascii?Q?rc6qumVvbCU83iUuJB9v+jmjeBzwa9nO8VhTSpE64eRyKHKV9XsKaYaEijQv?=
 =?us-ascii?Q?Lj+qU2qt0vqJ0LZzfvop7IRB2z9SmFZCdw67yOVnl13fz+w5Vq99Pz6keZbx?=
 =?us-ascii?Q?w8zky8sd05G6Z9/fFe0/lcxFOEvQ79kFhhjmOjRU7+/gK5IsJtPecO2G5Fo9?=
 =?us-ascii?Q?JrK+a/D0+L3kQOQZ8R+7LWRc5d2wrCU7SCIZkSOhNGgRyXwaA87fu5/BtE/C?=
 =?us-ascii?Q?W81kkEqYB7OnUhnqPs3rRvkFmrO3uEu2+O2ILA8y46T3SzrhCcNEM8efqkgf?=
 =?us-ascii?Q?1c155bCwgZTLY/oGWpEdgOH8mUD5JJb3Ngvid0jHxmE5LynVPsCa/41AR097?=
 =?us-ascii?Q?nMruCcem2zG5x0dfaSzQY0yrhg4On3mWChfMI4tJ9La5ceeLTdmfZkTUdhFh?=
 =?us-ascii?Q?zWU6BBqc+2tQY9CAhm3+0QhFn60xYPJ4yG65lnz6zDYVkO3i14YqJKv7jHEb?=
 =?us-ascii?Q?TN/v1qWAExRYWvor3MSiXmSWdVEKuW+5RKdco40jxRGxmC97KOtL/qjxNzso?=
 =?us-ascii?Q?cHOovCN9THeSuF/aheX78uQ5d5ta5eTzNp+BG6ox1hncvPkUwPJVVyUGrKal?=
 =?us-ascii?Q?jhNjEGHpFm5bm13lY2QZJedTGNmGElI+ZM6DbhYZDYFESuNx282jnwj+GiQf?=
 =?us-ascii?Q?lqyI0RtgNuqtVMnSW7A+LvQIUkbsk6NwMte4f5Jb2nV2AII1gVuWnmXZ3hRC?=
 =?us-ascii?Q?GCc12wEnoU7mHZnqaD/ZSsN/g/9w0G5KvWuRRmdKIvipe6+hCMM+Rcy6cBPu?=
 =?us-ascii?Q?sRST1DaSjAL6y2dHk9AvYcfrlIev0M2jxnyOMsTX+7bkH6mb5ctlYhBQJbFA?=
 =?us-ascii?Q?xFA3wv6xVyw0+u48nfe2sQtUoub8OgUJtaWCgsxbk3casdNvqtcLpOuMHqko?=
 =?us-ascii?Q?+4gNy57+kU2LjJgxXQVyBsFCv2BxCDl1R8WrSncAky6GDTZMp8DBN58q/Dyk?=
 =?us-ascii?Q?ytera9i13xFtoFJhjUVMOquSTgjuKa/WJ2vepn28zgMQk16pHGcUTcdT3wgx?=
 =?us-ascii?Q?8xpriti2rDFwMKG9d3fW+u1Sz/4F3EklzrYhZXwCO+jIJUiUTbLLYzVVClhp?=
 =?us-ascii?Q?0j+8YMdpYyXEpcCUt7U7kE/RLj0JooAjj58oULnSKo9poTdGG8DY+s9G9L5z?=
 =?us-ascii?Q?kzgZXVnpADy6nfAR3vAn5JmMpVyf4DLA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CqtYliMiFaMZUyczT9iYa0Aa1HWjsIPvlt6tNVyoMaDcfgw0YPMH017Dj7SM?=
 =?us-ascii?Q?C5Ulf1sTB7BHKVbDmQMRD5zg8/5NXftWTsPICoebxd9P3zUBiIDMU81z/czc?=
 =?us-ascii?Q?EdnIELmH/WWKMgpeQ8oIBqB/HTjlfqqKWGYz7xqVxnemzBwv96LAgMEx1x89?=
 =?us-ascii?Q?xTTvlGm2VIMB9XBcfClgVVWNjbZ8h9xddbx/pa74Rc2K+KXFGNw7uiNZ2t9S?=
 =?us-ascii?Q?eMp2Q7jsotG/dVPv2Bqk0xUivaMqD2zpxADX+HLwpkB+TiniL1GcxS9ONA8p?=
 =?us-ascii?Q?zwlW4oKS3geIpmJj2LxBAUFis3Yz6QBHrAZSdBDeoDUYlKUIw6/CU0NKiIqX?=
 =?us-ascii?Q?pfYznCYRpbCTb5rUD0co4+WVOhYyicnECXJYs06b3ctIn68809lMRZfDXG8i?=
 =?us-ascii?Q?jK8DV/fpPU30YQrimqTyoWYiLyfvmtFTs3Vqa1JLTOaoOUk0IHsCgCIYgvT4?=
 =?us-ascii?Q?ZEXiKKFeE8BbycnJFJIGbGupjhpH1oyhYcGyDQ1dMvCetE5daw+XhoO9kPDe?=
 =?us-ascii?Q?VR/O3qQf5BA6wU5MPtpaCJRW9nw1pEc5c2dbVfoaUgHJPGXVWRPwJZWJEviC?=
 =?us-ascii?Q?2k6K69LqnW1eHyIULWjfKOdu02W7uNZM6XuKnijQlKUdAIQbuCUGRF865QH0?=
 =?us-ascii?Q?JeD1T82kfzpFDRxOmh4Rqa92T1eyM9dT7lvUdI3hULMGky6Zri3rKuT5pqz3?=
 =?us-ascii?Q?GI0C44Pu0GeDxG14nYxJfKtx3pck4ZsRdjYRuxcWT24mftiLWPv43DfpXNDd?=
 =?us-ascii?Q?Nod+6DuwwiiRJQ8ic9Et8xRpaT98Aul07ZiAqBWcz3SjPjl0QeyH3qQg5clu?=
 =?us-ascii?Q?Sm4GecujcZbbanQQTf89PWiehQlI8sSJ3Wk5mrPA5kNU6XijOhJ8f0s/6D1G?=
 =?us-ascii?Q?yHRojh80x1GuuM9wVcS2uc3FLHyvBbiN9UuUXtFXFEzYHIb/iKaZUM29S6Ov?=
 =?us-ascii?Q?TbJlqa7sEQBTFjeX4j/l6i6mrHJrm/CSoy6OX9CnpcRaantQCqmi5r/tgALo?=
 =?us-ascii?Q?hhpgfmxEh+a7XJ3zuqFk5YDWJwl75ZCOBY3xBdGCxN3t18RApEist6Wnf9yn?=
 =?us-ascii?Q?PqrLTR6NFEmGqmkMZpQURkHn+TZamgrJxFgFONz6oMv4uwkC3YGeDYozHi5L?=
 =?us-ascii?Q?QfX+POWq9SKy0OD/cRucQlxUtydKSOs1WBkMRESvOPm60FAufgHvRk4L9rdv?=
 =?us-ascii?Q?K6N7vmbfyOZ1ft8hecdeOGMf2cX8kdU75P8XYJ5e7OT33e2JTVinzGhI8oRv?=
 =?us-ascii?Q?+2jQhrdP0OG5EIQqbKLLOCSc9dskK4o+QNADBszFd4ctlQO9VajCfd3W0osL?=
 =?us-ascii?Q?GD02muhRrL5rUSVZPmR7HrCPhGCVRiKUmTI7VPJtnpcjd9Q+5AOFr7nMfafk?=
 =?us-ascii?Q?BSSmFC0jDihmT+pxhK9WtMONRviQZNGQEXskHqTq8/3wcbRUtKH7LJmtPrUG?=
 =?us-ascii?Q?Di7qqC7ll54rGTYyAGtfjZIFb5sGyUq7EJTNIYh30lp0NEuCmJd1rQN/f88c?=
 =?us-ascii?Q?Ec/XlbwI7kpKfEnkxHwAT8AMLbl8WSmsUou/5/rWMpEuLrHWqfNZun21xwnn?=
 =?us-ascii?Q?uZe7i+RMFzAnaTrxCDNGnzp1iSr+PF4U1IH8wfd/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95cd81d5-0e26-47d4-7799-08de3da421c6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 19:40:28.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xuBsTQZILiroyqg1ZgMeJAEyQ5M+xEaSo9A/Ol/DqMC348ryDBM23lJ+fuEeShOQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9505
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C1BC140008
X-Rspamd-Server: rspam10
X-Stat-Signature: o54nmt7smig3fsz7dfxzqx1eiguxd3p6
X-HE-Tag: 1766000431-524925
X-HE-Meta: U2FsdGVkX185Mzhu6ca3hmEc9dqRHsuNAZzOHv9Fd4ol+5zyCZFOozifONtkWvFd/VCNWh0IZrhFLMisBIwddIErhPZ2MD2zJXax6qh/dOyjcaMDqqYWSwj1vq/umpmbCbKiJ9VZZOeF4lyLUyrC7Ed3gw2Kv2MSTB1s2we2Gm299f5FRYFBvqZ9E/UTw7Vu+55z6LD3FfvwCZxDKITp9EUgUoYr/5UxUgkuHBadrKa+M1NIlA14LGFwWsxsq3A+m+OlQ6jOsySyAhlBTlXOoQKFA5awjQh4lcEeQkfnvnapxdesJ8CWaoc95COYQol4N7F10bvyNlYS37WegVdaGfRXBDj+5G7lcmZ7B+Sqos0xrKVBvxscwoHmCt4vmuuwGNVTEZSdjfA88FlTsuZqsa5rHTbOvtthQQfMe4COD5IWAwyWe+N5bapxn17ugnwtlPXpYU2/+RIYyhLUdEly9EVya9DAQL3Nlz1wpt/L9+Y576YMs4ZY48zndUcSNl05lEMwbfdy2EH97E5XpFl/qhGi2ya/pNr5JAxw+DR+knRhYRpKcnUvJ/tMGcI7X1fedR7ozqNwTLmhB+RG/ktyEpM2Z6BbXmLZoYDyzZql8q/pJOcPmLycK4C/4sf2WN4yKqg5qVvmMXPxYOOtJ4frIZGKchYhflM+1jW2AFxvm5BT0apUcza3var4Lid9PMrpl3sKlWTpGoBhNlXP+vu8XI/E2PBVU8brQef/AmQUvIKDqGbM9b6ksDY55txNszhqdJLxfQhnomupjRPWhQm13IwiOo5nb7SGASkaqaUAXiVwE0uhNDQJCzvHPg3wR0HYb0qIlzBfSDnR/DJdSstXF3FN/WbJWam2ZLjcuWIwRuT+JzMCd+VwWdAfMtkdkGYTm9ctQg9i3zT7Ixp/voNlDvGfFIJD8WFIwsHtsDDk393DlEtS0Rs08KIYxEhuE8gBtbTYEFs4jHhLdpnICWn
 pfLr8oHd
 LUAzsTuU5H1F1DjHU7+ZcRPCW8HnW8nAm2tPinse9+r4EU6A50bThWOWb8O4ApnWEIKnr0N6RUddWmzrnTWS82W5nQktBodwY1hm6+QiG5W+TKsDPDUoN9gk2fHWtFTEmAxI9lR0LAspqLJZP9EQeSYH5ufyUQJDgNaTWOvHsUQ40Ql8T1tFzfFVNcDMGzPOPZmDLrVfp3ZtvhLVjiYAlI6z0mvF2VbbaF1DWGdHvHvN20DE50VTOnBRn+nbxGTUJEiqSH5EoME7vMenKlNJez5F0rqw8t7mlcbi4OdX7iU1VboZVf7FnztLN/+AMeW5h2f6vFUlPgwida5ZbhPHLmW8Gt3RBWi2+jcW0Ss/P6O70Zbq3d5aRms0gsRfus+7P1rgB+r3grdlijv//OenvIOw1HBvUghvMAqsV/yP4bFgRX2ASxYIJPiFcMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Dec 2025, at 3:09, Kefeng Wang wrote:

> On 2025/12/17 2:44, Zi Yan wrote:
>> On 16 Dec 2025, at 6:48, Kefeng Wang wrote:
>>
>>> The alloc_gigantic_folio() allocates a folio with refcount increated
>>> and then freeze it, convert to allocate a frozen folio to remove the
>>> atomic operation about folio refcount, and saving atomic operation
>>> during __update_and_free_hugetlb_folio() too.
>>>
>>> Besides, rename hugetlb_cma_{alloc,free}_folio() with frozen which
>>> make them more self-explanatory.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   mm/hugetlb.c     | 63 +++++++++++----------------------------------=
---
>>>   mm/hugetlb_cma.c |  9 +++----
>>>   mm/hugetlb_cma.h | 10 ++++----
>>>   3 files changed, 22 insertions(+), 60 deletions(-)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index ed185bbca419..7779ec838da0 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -121,16 +121,6 @@ static void hugetlb_unshare_pmds(struct vm_area_=
struct *vma,
>>>   		unsigned long start, unsigned long end, bool take_locks);
>>>   static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
>>>
>>> -static void hugetlb_free_folio(struct folio *folio)
>>> -{
>>> -	if (folio_test_hugetlb_cma(folio)) {
>>> -		hugetlb_cma_free_folio(folio);
>>> -		return;
>>> -	}
>>> -
>>> -	folio_put(folio);
>>> -}
>>> -
>>>   static inline bool subpool_is_free(struct hugepage_subpool *spool)
>>>   {
>>>   	if (spool->count)
>>> @@ -1417,51 +1407,24 @@ static struct folio *dequeue_hugetlb_folio_vm=
a(struct hstate *h,
>>>   	return NULL;
>>>   }
>>>
>>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>> -#ifdef CONFIG_CONTIG_ALLOC
>>> +#if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_=
ALLOC)
>>>   static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask=
,
>>>   		int nid, nodemask_t *nodemask)
>>>   {
>>>   	struct folio *folio;
>>> -	bool retried =3D false;
>>>
>>> -retry:
>>> -	folio =3D hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
>>> -	if (!folio) {
>>> -		struct page *page;
>>> -
>>> -		if (hugetlb_cma_exclusive_alloc())
>>> -			return NULL;
>>> -
>>> -		page =3D alloc_contig_frozen_pages(1 << order, gfp_mask, nid, node=
mask);
>>> -		if (!page)
>>> -			return NULL;
>>> -
>>> -		set_page_refcounted(page);
>>> -		folio =3D page_folio(page);
>>> -	}
>>> -
>>> -	if (folio_ref_freeze(folio, 1))
>>> +	folio =3D hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, node=
mask);
>>> +	if (folio)
>>>   		return folio;
>>
>> alloc_gigantic_folio() actually returns a frozen folio. Should it be r=
enamed
>> to alloc_frozen_gigantic_folio()?
>
> I don't change it as alloc_buddy_hugetlb_folio is not with frozen, we c=
ould change both of them if you prefer with frozen :)

Better to change both for clearer function names. Thanks.

Best Regards,
Yan, Zi

