Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB960CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC698E0005; Fri, 19 Sep 2025 11:39:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4468E0002; Fri, 19 Sep 2025 11:39:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBC98E0005; Fri, 19 Sep 2025 11:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E091F8E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:39:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 927791DF818
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:39:33 +0000 (UTC)
X-FDA: 83906409426.12.D76101F
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010037.outbound.protection.outlook.com [40.93.198.37])
	by imf21.hostedemail.com (Postfix) with ESMTP id B44F81C0014
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:39:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W+VEj1zS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758296371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVbrm7mVv1n2mD5F4qZ02G2kUWK1URtIE1tShgYizjA=;
	b=AF2igk9OF8GyjbBYE20Rp4wQjNOqA5k1ALdlELcAz2Nq8Qy8uu/F8XQ46wTz9YXwCJhBlo
	kRiFF1wjJkHJuBTyevSeuoYiOri1lx0mgLjxC/TVYaJHx2dwcYwUCVfh0KPXpQ30SJxPHY
	0SGYGwCZyqHru01rwhAPAUPA9fIeS20=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758296371; a=rsa-sha256;
	cv=pass;
	b=qet9w42fM3/tGHvXKZSzZ3kDan1OGT1IOeJHs+1Iu8uUZHkXODXCyeLLM/6Z8FMmN/NHXm
	svYFiOcA7Wom8yNTDKNGUl1iYCVUBaJM3EOZZBMcIObXRxMIzAybKhWwBvqFIZw/i6ozk5
	bsMrAJljvIVQFiwjodE2y4ci6nI0NuA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W+VEj1zS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=repGRHn0oZkXdyZJFCQ4GMjZv8MUEJlpF3kPU2LKkmpjmuAFe6hjL2X15OmcdUoINdVUXXyl3j0ZZS0kVCUXN5Q6mrDv7aDPRTxSBEuulMNylZ9/eQ58cAp4ZSyg2pswQicK20TyoBaqUcTeaFc8ddXHmNTvRI5iDCPGR1mvjR2h5V9BF1G2w8Z6BzrbZAYu7msWHaAy379ASzKXEpIu2I/VChwmmx8GfNOUmu0pLUzKWEXEAmt1vZA49gfB+xQYpeTA0UWluCvSJLZziBsiIuFAk8bpZJpOnFAvHaUpqRlej5ZayVS5Wxs2Xzfl0T7BVEYyIx3Amo/c9UYKa4vWLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVbrm7mVv1n2mD5F4qZ02G2kUWK1URtIE1tShgYizjA=;
 b=VC8p3D3iKWBppXQehh67UzANVukNuKNGOA9bxXXn7ahyHSIBub2bbq2JLPkrifC85KdWA08J7obuftdjtA1S4nkkyNl/gASMVzIJcT8eXBWUtbvnrlQQCkBNgu6gXQk+qKShl2VRlukygSQ2lJYWgmo3idSICSfZzPXz+Ko4KP4jBxLkKOULcZSNu9Hrsyh7Lpyj3ElBnSsoSuPTi7HQ6lJwyolne2CG7bZ76bcK+ZexO5E/hp9Dg8kT+lakexBZwbRMCUMnTORYIUoYmMsgXbEt3rIlWYSf47BcdGdZl5Dc+VwrSa2qJMRIZG3vsG56w9JtQSEZJq1+CzS02u5PTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVbrm7mVv1n2mD5F4qZ02G2kUWK1URtIE1tShgYizjA=;
 b=W+VEj1zSKVKKtcWJGnZH4BJcuf/+5f1NB22znEkq1bheY5PWpzqQq7E44FLXbO5jBvFjwUikEM1+B70+sY4i/S5d56/wIGBAHnh1RlQdT+1HK/0+qONZQVrrmtGlvlkTC0M6enTNzDn+GAbHHzPik77d46kj2VDPAdbmNrf1xGwOzcDWuqAtKPK5CnRh2sNff1lrl8vwpihov+xklGW87eS2uKLp2+JDEaOmXxs1lDyyp4CHzFhCx1/x1p9PjTebdnW6MKUh/10R4XgJU1KPOTuQqEAynBO9UFka/fCKe4fIYm6EvXQ+kckbsPBUc2vpJzZhUUnF3msAr6QnF4CmTw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB6723.namprd12.prod.outlook.com (2603:10b6:510:1ce::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 15:39:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 15:39:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its
 variants
Date: Fri, 19 Sep 2025 11:39:23 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E62A91B2-4221-43B2-9C17-1E48AA5D5544@nvidia.com>
In-Reply-To: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 2253cb1b-5380-4c34-84b4-08ddf792b6fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l2MPTlMCES2d+Oe1XF4DzQOcPE8EXcFkwaR3vwyfH/JAfF2K6PrnzJ8dFL19?=
 =?us-ascii?Q?s6+TqXUk1f/F2B4UcyfSIE3FbfMkhzvl1tF0RuR9juNOD5bZZ/gSnpRRtuPX?=
 =?us-ascii?Q?f0EOgIHR8QlBxkg6TAxoddLvOVNn95qYXh9FJAfmE1hiTSWuD9PN8jB5+/+e?=
 =?us-ascii?Q?jfWnOedm9MfGnoPukWLgBHgqxmrJWUjVQHBhLlV40giEeCRqhA5zbakRlFjl?=
 =?us-ascii?Q?7P492QwIQt4Fk0bE1WWsyI6a1yx4gR3SKfNEhrZBrNRq87V+MGDltQ/dIm0F?=
 =?us-ascii?Q?oEStgOf3BfyyIJ4riTB2kZ1V97ZV4KtYLdao5fNN17rTh0RXsQ0nkPjmFcC8?=
 =?us-ascii?Q?xIzsnjDRpDcV1kpmZpDTAk2vyK9+wKrVZU/x2o2btTfKvCaErlfFrHKmcJ/r?=
 =?us-ascii?Q?w0Ss3LhYWWTWNPNtV2YYG3dfzN9si8cccsKRIyBemG+8y1TmyfiwmbR98377?=
 =?us-ascii?Q?8DnDHG6E/IZJQCC0kACaUwinj463ANpc19lPAKA1mLZ3IF2dJPhM9wNxle3T?=
 =?us-ascii?Q?SYO2JJrIasqpbg+tmQsfXbHYnEm0JElnZDbPT86w75bsu1pe3JBeJswsEuYe?=
 =?us-ascii?Q?7pPWp528NTZ0xR+kgxDTDZqiSLIidr5aMSBkTFcXZ+r5GrGwrk+HthKKqfhw?=
 =?us-ascii?Q?TG3yTvnk+1jZ47OlOW7Ht/wpsWS5jihu9dUdz3meY2p3aN/GYyS3giHb4BMN?=
 =?us-ascii?Q?HdARn2iiHg42B9fltjlhZNdehQQ+TnaXh516DH4jmMJ1ZRPTIzaDB7Z38D4t?=
 =?us-ascii?Q?tyemJxTgh3Eg7bEJWeS3sxlv2pl/YFlOVnPJgqJa13+ZdyitILaa1qF4uWzH?=
 =?us-ascii?Q?jeEFskBBhk5PDAfNKVxuIWrkEIo6iujXgoc/Izzid3koXxE2rEbvP8wCcgVV?=
 =?us-ascii?Q?1JCH/QjcsuAzy74TB5gxqONHKh5O7SeV0U0b5PCD07WYkcjxQIaaLZvjQPRZ?=
 =?us-ascii?Q?7m/DJGQTH6KTnuS+ebPz/TTKoccBut0GGJYKEu+306BSglOpO/pr/YGSj6Qa?=
 =?us-ascii?Q?WQIVgq68P85ZdJpkBICl8ZwJIzAhjaDsCoTNVxbMQ/i63lcczLyo1MpkkeW3?=
 =?us-ascii?Q?azyVO27KHztHMPtIXXBtjY/6Z7V9NkwByDpxHE2gs/4fLQ8OT7AyCsvipNdO?=
 =?us-ascii?Q?/9B3gw6K/d4tW0waMrlm0AgM3GmtGzpTYIo2v7ZvZNaFz9FTCLaxlkEfHQ6k?=
 =?us-ascii?Q?abC5XPxYfLFsmEEvs9rTUwVcslCMN42wMWB7HQowXXp8hC7WNTQzA42y2lHk?=
 =?us-ascii?Q?9tUMQpfmIwnY9eJQ/zd2nkFMqP9WAio77YJs2hTyJQqqs/aG8jzWDU9RhGjX?=
 =?us-ascii?Q?LMxW+M0sDZz1bFLRnFXnj68AyHYDevi51qiUY5T+qG9CmcMxP8/SIaeR54AK?=
 =?us-ascii?Q?cXlwqigTbmqeeRAcMqFgXB5BP1lNwLFIoernD8AlpJAqXCt5LxQFncjUyNMy?=
 =?us-ascii?Q?QfRXkYvAWrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PWoKcJ3ix7fGU7bF4LA22n3kNF3+nP9dQPJnM2LQFdrqIBU60g9HM2s5WTNA?=
 =?us-ascii?Q?W9jyCPaL5FvL470DffR/M0Tj3wVzXO6N6T57dTCJ035bzI+4Bwzc//BVjqOu?=
 =?us-ascii?Q?vLllbUs76+EAKd2ztje5Keq80ZtcKyIgs6FIrlFYEJAAPUZ1L4mCBoWZhk1I?=
 =?us-ascii?Q?9EWC8grPkzy1xvRxdvtFIiODoIJGwMCiP/H9iVn8Cze1gVl9v9aWuvyGmHYS?=
 =?us-ascii?Q?c3OynI52yd688heFeUqPXGzd5zQUPcDCqGQLF5aLTpoDY0OuoJ39LKavKni9?=
 =?us-ascii?Q?SoZdSlQXoRQ3KmYLiN/lFe8fAl8YbgZHgfVi1Mb8a0Q4ZKdMLtRTans83M4S?=
 =?us-ascii?Q?v5N8sx32C5Rzi1qxyEV6D3Vt7tPDnam6VLxsX525nDhobaA+Hx4VScEZdvUz?=
 =?us-ascii?Q?WK5UyMynczCX5HA/oFVuMxoH/M95F3RzAaKBqKwbE47Sr8uAq2I9XWef0lDG?=
 =?us-ascii?Q?Q8b7WfG4PlzoP6L5Stnw8F9MuJQuB8AmpoaGAMVBsrX2Ag6PeswLu35uqTYx?=
 =?us-ascii?Q?Foh9+IxnWisROUp+v8A8YmkzFS/lEPeTy6qvjWxHTYsuoXf9U0md7KI8k7Xq?=
 =?us-ascii?Q?99i6MNftrsjUqhegXKjq+MUbU1Wl0Xv44hPE6wub3EzhJb0/BCZljO1lNNRe?=
 =?us-ascii?Q?rdCAG7C990S6M6H17yyUxlTyGbMpL7nYN5sIwvNw2X/PjuxOxqK8yZhJiLm9?=
 =?us-ascii?Q?hPP4niv3S6zLVUweq/bykDLOf501XfgC4m5VWrVw0zQcTaWZ9xs7euVkoCo7?=
 =?us-ascii?Q?5fXhO7au8UDyFkj6Clrb96gCUOZBs1x4cz+T4NGU4stMbAWkxGFeczeE764t?=
 =?us-ascii?Q?ss0KrQ+r442XiwCM757AIWK6Aes4c2BG34Zt98V/pwVyRScN4IBR9oDYOUVB?=
 =?us-ascii?Q?os6UrfhJgZIx+lfgXM3dqNfJwkP8WK5uQJe4JfVzk9etg24D3HmAcyDva4KV?=
 =?us-ascii?Q?keHkN9Avwv4N70uVbwuJsnW5bj8YsioZ/0Y36Xy9sQQr3krNMMuHocSmMSVL?=
 =?us-ascii?Q?G7WrQBNmjfWyGU6nmeUn/Aq0CJ3Pesao2X1a3E17x1PzUw5jImkxUi6Ysgdb?=
 =?us-ascii?Q?VpVaw1gTtuHPHmxHZdVVvLouB/jfiZAyZpoEwnGS1ZF24/1Xwtxg/Q9env4/?=
 =?us-ascii?Q?JswAp7ipDQSJggMS5IPBiuP0/aYFqQLo2b2HejHNDvSa5JoGCH6ZWwWj1gYX?=
 =?us-ascii?Q?qiZUwuGRxkEZqXu+L3z7eqYW39GH6Hs2n7B7dyAAJXIWrL4xR/PPjf2KQXI+?=
 =?us-ascii?Q?y/z3YgnY7F8Yl55oj0kN3Vl6xi0HNyTjV6fYVNb0gTpvOD/Am+G3ufikF9Zc?=
 =?us-ascii?Q?eL+hYnF6Oi4aXuyAjBp01jjDaJwQPWXfi5Me+RKWpFQj5orCFMqYddoEJNOY?=
 =?us-ascii?Q?j6VfzffsuKrH13Lj3AwPOippZ0FeZohHXASk36OWkJxo+jjSkPCF/ici+2B/?=
 =?us-ascii?Q?7myoqtMwd5KZJFFEOaNUr4+C50RSaUljd0Y0Wttq82DdFDBymuImGqlNCExc?=
 =?us-ascii?Q?i3qAl8NjbIajvTOak1VY13/1VOTIA/++APlu/jAR/43prXfMgxggyOYdBYA+?=
 =?us-ascii?Q?96OCHPD7cKTnoblX2eLXbs6rWTJHMcFe7vWaOt1G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2253cb1b-5380-4c34-84b4-08ddf792b6fa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 15:39:26.5247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij6onDW6qRkZXlKt7doZalRzSzqmtbkH750GSZXASfDbLuFs0EdyZCrsWWpZFclR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6723
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B44F81C0014
X-Stat-Signature: sdwi5jked8crzo4udm4g3m7f7rjm4163
X-Rspam-User: 
X-HE-Tag: 1758296370-528069
X-HE-Meta: U2FsdGVkX1+2k44tQjwpd6kZ0BS7gzA07BC/QYaUhAl44t6pjnJq7kTatQjLlaOZSLQgdVmqS0ysD5XWPFutgkmcZel+ivFjlLRVF8JzwSDcgzJ540kQ/SWpvhaijrSmy91/R4Bln/lTIkSqGdmEWtIHw009HELOPj75sX1+LP1kW3XRru+fIUfoLbQmBscmHwBfCi8/+dDTdzULkXNvRjAFRH2wXFVThsNKFM3uC5QJhyYofN18V44thqmAlbdc+HUVWdycfXdm2Sxi/USDwtLe8Sy9fHCQw6dwisfqWShoOwvAr4lrDJvIvEsnX52x3mfHVzuiJePuPCis/m0Czh5qlvJk99JRBfFzM+C1Gbpo0XMB3aFnpeR0ENm01UXv3hS/kvmgOWZpIPnG5txX6U8JQBAuPZeA2zwTaMuM9IMYKDQVoeJLHZ4F7GLL1X5Ked+iImxf7wicPcImquytXnCcLGsP9QLaLZlv/DgXKPYFXMnpTVhthsw49RvVSG3ZCfYxcI5TJ5qDHtNSIW6SndtkpuGVz/XtDCk3gAAdcNODNRvdWc1pS2IIBX9PoMl4LLbKnhmdpqPocMgbtHXGzOMIE4qqwwJxYLhrVR61+/XtDj1KDhmVgFjkeiHronvh4KLR1sm3YdBWDv+bttrUXP08uqSQezFLPGgjO4k4T5le/3sy+/NLsIEozBEAanLoOY+43OfS7lofDRypO50nJ6ZQZZG6kO63ubC4U47PKMM+vACm4IYJtFe7A0QKsRitKaa4UxrzI+24wLdd1cc0QeYX6Z1oN+TT35Licu0za6RphX4T6AT0H/8TnOJ9XrtK5SHWlX5H2TvZU90ACxmqwxSrgxd3OOKZIlJ0WlofK+G3n4c2/B1970McAsaeONW+owwW4IQdlOiF3r8POCjzte+JxF/bURYEiUoT7Y0wRQbZEKfutHKYGGJNgX8t4Yg+pTW7iOEbC8V00UzVZRd
 XpmN7EVI
 nAPHhdE8AbEiKIFYWgtc/qUiAo47kwkbpbnQsHwPkxpgaNqAa1pDARyLY2WtYeuS6pZam21VgXKiJkNOwF42PtCiDe7GvabZApCyrysVFn1DKLHmdr5WwLVPHpV0gayOz64Wy2uhF+1+zjyPvJu0Y2Gu10tbjRa6fn8ofguih8QXQbSjChc3VOdVvGQL3i5FigoSPA44unF6POG305uABIpCXZkGY9MHAq0MyRkFE1wBofujMfLCb5jQnwpifTPFbJPrrbD2eYfW9ywkHuuvl4EL5a8WuAhqCk/S5e4acPJv0AC+qhanyks+2Du2WvwrUujntKPM4XTI5reQu8PEBL0zsuVmtJ+so5IZ6pg86hPW5DLj1negKu0plEIaYmIJRNRKekDe0gwOSDnKwzJ7Qqpx5YHjttwYjUUKbym0BzFQosgdsCbefLYNohodsXeA/qaAgm/+wVuKrvWTER0ZqzUkkfWRkaG3Tqb27KYuZB8IVQswc2nFFXp0zRF3pirPgeP5yFMSSQjBkF9TapHTvteQufByo2bMCP3CgKYQjOXvrgKCGKUhJLvMgVP6CyarHN6Ep
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Sep 2025, at 23:46, Qi Zheng wrote:

> From: Muchun Song <songmuchun@bytedance.com>
>
> In future memcg removal, the binding between a folio and a memcg may
> change, making the split lock within the memcg unstable when held.
>
> A new approach is required to reparent the split queue to its parent. This
> patch starts introducing a unified way to acquire the split lock for
> future work.
>
> It's a code-only refactoring with no functional changes.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h | 10 +++++
>  mm/huge_memory.c           | 89 ++++++++++++++++++++++++++------------
>  2 files changed, 71 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 16fe0306e50ea..99876af13c315 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1662,6 +1662,11 @@ int alloc_shrinker_info(struct mem_cgroup *memcg);
>  void free_shrinker_info(struct mem_cgroup *memcg);
>  void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
>  void reparent_shrinker_deferred(struct mem_cgroup *memcg);
> +
> +static inline int shrinker_id(struct shrinker *shrinker)
> +{
> +	return shrinker->id;
> +}
>  #else
>  #define mem_cgroup_sockets_enabled 0
>
> @@ -1693,6 +1698,11 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
>  				    int nid, int shrinker_id)
>  {
>  }
> +
> +static inline int shrinker_id(struct shrinker *shrinker)
> +{
> +	return -1;
> +}
>  #endif
>
>  #ifdef CONFIG_MEMCG
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 582628ddf3f33..d34516a22f5bb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1078,26 +1078,62 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
>
>  #ifdef CONFIG_MEMCG
>  static inline
> -struct deferred_split *get_deferred_split_queue(struct folio *folio)
> +struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> +					   struct deferred_split *queue)
>  {
> -	struct mem_cgroup *memcg = folio_memcg(folio);
> -	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
> -
> -	if (memcg)
> -		return &memcg->deferred_split_queue;
> -	else
> -		return &pgdat->deferred_split_queue;
> +	if (mem_cgroup_disabled())
> +		return NULL;
> +	if (&NODE_DATA(folio_nid(folio))->deferred_split_queue == queue)
> +		return NULL;
> +	return container_of(queue, struct mem_cgroup, deferred_split_queue);
>  }
>  #else
>  static inline
> -struct deferred_split *get_deferred_split_queue(struct folio *folio)
> +struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
> +					   struct deferred_split *queue)
>  {
> -	struct pglist_data *pgdat = NODE_DATA(folio_nid(folio));
> -
> -	return &pgdat->deferred_split_queue;
> +	return NULL;
>  }
>  #endif
>
> +static struct deferred_split *folio_split_queue_lock(struct folio *folio)
> +{
> +	struct mem_cgroup *memcg;
> +	struct deferred_split *queue;
> +
> +	memcg = folio_memcg(folio);
> +	queue = memcg ? &memcg->deferred_split_queue :
> +			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
> +	spin_lock(&queue->split_queue_lock);
> +
> +	return queue;
> +}
> +
> +static struct deferred_split *
> +folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
> +{
> +	struct mem_cgroup *memcg;
> +	struct deferred_split *queue;
> +
> +	memcg = folio_memcg(folio);
> +	queue = memcg ? &memcg->deferred_split_queue :
> +			&NODE_DATA(folio_nid(folio))->deferred_split_queue;
> +	spin_lock_irqsave(&queue->split_queue_lock, *flags);
> +
> +	return queue;
> +}

A helper function to get queue from a folio would get rid of duplicated
code in the two functions above. Hmm, that is the deleted
get_deferred_split_queue(). So probably retain it.

Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

