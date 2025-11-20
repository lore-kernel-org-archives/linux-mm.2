Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6197CF64A6
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 03:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F28E6B0012; Wed, 19 Nov 2025 22:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAC96B0022; Wed, 19 Nov 2025 22:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192B16B002F; Wed, 19 Nov 2025 22:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0993B6B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:00:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CE5013B95E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:00:54 +0000 (UTC)
X-FDA: 84129483228.22.F95432D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	by imf27.hostedemail.com (Postfix) with ESMTP id 35A1440003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:00:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c5wP4J3A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763607651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/TQyLrGMse9jOX6VZuks7kS53jD2zF4Ciaxf4G2Q78=;
	b=sD1tODhzMLuppqWDR5F9CVdhGNHxvLwu+TA+soHhYmyamXbGMI8J7Iy2HJ7kq5J2J+zjMO
	szv68WnWpIdPKlFPnMGTsmGjQpaVkhGiKIb28Hd8gSKluAX2J0W11Pjex7UnRL9gNkIQ61
	JfDMtko5swvR3t8uoKC563aGkz/J9H4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c5wP4J3A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.64 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763607651; a=rsa-sha256;
	cv=pass;
	b=flkbryeMYNiA2ZOxWt1000nSxoFyllQZvFZyAQfsk2ZABQyOWqXAbaMqFsGRwhHroI3ZuP
	YodFfYZQOYprcvlXnI4feJKUxVzcNbdtkam/fZbbJiGF5JXLvD08pagXSIo5zaIp/QGyKP
	TQqsu/Xg0+pU6t3Wv7Qm89dcPVjJwQE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJdzTvG4aXKhzoC4tmdW8r3gLhfqKicn5XDuglL7eFa7Z4RhOdw0911qsTIv79/ylUoWi2O00zWxqLMQ/mangsy71MpxOPkvCkt7o8kt03czij59JOFq/KRjLjBe8uAqtwnLdFn3JL6T4+Yzx56g9uwRzhpyu8PCPH/gWnBflHdZK/RLnVSo3dS9v34yVcG+66cb3vf4yTmk59jv2ulqhY5CJNaEYm7Y5kxW2uQYisdasnb90K67xlDyJ3Zk0U/z3+jxOulawOnVPfYIfisktJo478D/XibVa8JgRdM8G31+sT/CpN8+XX4lXYI+OcGfEXYMmqHwXCnSaIzLfUR7YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/TQyLrGMse9jOX6VZuks7kS53jD2zF4Ciaxf4G2Q78=;
 b=SQncaf6tCSspgl1qVIqGHeFd9kokgXPnW5oD7yix+lNPZt8V6VJqPLwDfCoCg7NjV892mV3i6SD2/Xb0RTLTtQdHvpX33wvbLAYHkSzM4uGV/tftIxaVjO8binaVYJwXhhFrxQzVPsDLUmSPwDBIMkGSGSPOUUDFhZRKRUvnUquboEaPYtcPnSING6QYlBgXuRcgA04rofzw8iZcWEuSQiEU14ANxJ6yOEz/aFJ7Gm/mHJ2cg2Y0IKXIJfZM+GR/bVaM6CVjBcaIdoZ6Sxwfqx3biQFOIPAPTLTbuWrTZIWEhhY+aWQY+3cdAuJoZ0zuLpujPDo+F4IK7Jl47gauPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W/TQyLrGMse9jOX6VZuks7kS53jD2zF4Ciaxf4G2Q78=;
 b=c5wP4J3A3uAYoNMikAnsqcGNOUIiV4jz0YYvmdpLLdYBD15AP9qTDMBZ7fj1TjqUBN2HrYbAOZb4uTTRRLOkpEh7i0/YKGfqztuRZtD9MIds1saVnEhv3oFUXqVkIgW7EjaajFJCO9qUVSVceAFJPtcfSefKE+RcKVDG3Ab2tsjVgEm8NWJRpielfXSaNGiwNTU0in9NIYMCNfQ0yOUoCPkYsi99lpBf7MxaLJPlt44JjxagBstwO+stbsj0TFfHfoVJCLVWd/Ox9a1XiKm0WBRT9zCToPdGC3r2Y/LAqacMyTPykqOohnuuNzWKnigE4PwXJjAo0Kmw0I8rWYAdiA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 03:00:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 03:00:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
Date: Wed, 19 Nov 2025 22:00:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <EF42E7E6-B677-4D78-AFD3-1BA9D6F24F3D@nvidia.com>
In-Reply-To: <20251120004735.52z7r4xmogw7mbsj@master>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
 <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
 <20251120004735.52z7r4xmogw7mbsj@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d1cc97f-ad32-453f-0714-08de27e10120
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rNEhVECy4iE1cvz0qBTrXTuOXFnMLgfNO/7TSmXW4Oa/FAOFvWhSOTWqIUXN?=
 =?us-ascii?Q?jcLLZ1wFblWSdwVe2UxFKqS0ZQUNod3HFzI0fgLxNHmidAl3FaJ9hKpPUShd?=
 =?us-ascii?Q?9QjTdWdX9oiudcGadjH6P0SG2Y09bufG3toJj2pjsI5uE9dwebf5Rrb98mKQ?=
 =?us-ascii?Q?JirYuoFJOdmZYQ2mdNfHoBvhL5uBQp9+FvUmrCcAXuKw9QaBv0mhJCgla8MR?=
 =?us-ascii?Q?GuJZoGmXGXvuLvMf7jQXYPlgHUkXm770BMrmedT5oCcmVhfe/RMWn//SDyB8?=
 =?us-ascii?Q?EWWVlbdOxbCYhrehZJw639HUtpEuvQhCYyzJnj5p78XEhjpkMEPTCHLGVP1/?=
 =?us-ascii?Q?6hqoOXSrbt85CExqyigf/uk2I1IRb+7lkEEJJTQqMN2KsVAbahrefoUJraMD?=
 =?us-ascii?Q?K/fHrmc/34SkBByiDdA1fSV6xQLGoGsaMMhNyRTtys2xD78ceNmE/Bcifu5e?=
 =?us-ascii?Q?KuC7zEuhOkJPVn7i0pfjQfnmIy5e5f6R3O+EqvC+2ANBJDsB6ntMQmsEpFFK?=
 =?us-ascii?Q?UHRX/fWVJPUyrup3DeF9QPd9IllQluUo6w3g0ga857Oi1nYPToQw4DKcanhz?=
 =?us-ascii?Q?d6pS57uKHp+2PiMOYWGXZPE7N0yOR1Adgzv2x0/IizF5BiEJkLjfPhkv7sOZ?=
 =?us-ascii?Q?nMlHpBHpD1MzQhu3DbFvAv92Q7WOUA+JqnFpclQuHA7RSYf2PybUlsA0pZZt?=
 =?us-ascii?Q?jSGAh81waBbKTx7+Qb344JHXi3Jz0+eIgjkd7pAtrM9lvz96CkvipPw5N/eN?=
 =?us-ascii?Q?8GFAEdFecXmIi/PkrwG8rMSjKv3yfHHPEgfVXKUVE8tXXOoqEXIs6e6D3RKF?=
 =?us-ascii?Q?uG0ixM+OyWpQNlq6EAHLveRPUc1tBcSRbtvHN99Zvz5U+sPLt+LAbOzR+D1Y?=
 =?us-ascii?Q?q5qdjx2WLssjj6vYiLdg3JXgjf6Xik2/yW5i2gz5TwSQDnM3hFVoK7huATXa?=
 =?us-ascii?Q?rWJChf5uCpSJsQMK/UXbMooL+vnbO/3BKAm64lXkUD5gW5/8Dh85Dw4olHVH?=
 =?us-ascii?Q?6hf22t/s1IVF511daXlzlUik13lFDVgwtO50myox8Lg71ybzWC9+DxdF4hyJ?=
 =?us-ascii?Q?HzpwX6Qzuk8ZwIi5EMoW7xR4xl3MeaXTmdMxKyGnQqYbq0FZvDsFjGULmtF9?=
 =?us-ascii?Q?6K4WlfXZPAYzLU7qJPETQLPWpYVstFrxeNITZ4xFgnhvnYZfinlaURCKhuiv?=
 =?us-ascii?Q?rM/s16t+P2/Q9e2zZRKr4kfyKPn30mIPF0EsCv3KZ+P+wyuGWg3hcQ6QPHRY?=
 =?us-ascii?Q?C+jluQME8ZdQAiWDmPEDkCcAKEm+3ry0WefdtPlUzD4ljQo76jAmc7YNv02h?=
 =?us-ascii?Q?kbp2kpp6Fw/yYv7GTTnfd8clXsG3GW/hHRlKzpvvLiIU5pVVdpndprJ/wkkD?=
 =?us-ascii?Q?lAy0Jv+BB8YbDkGyj8nkQWrv/rGesf6ooKAOYYAwXK8azi0STRhAKHVZus5u?=
 =?us-ascii?Q?xu6thmy7zh/qAbuemEgdtvSuLaWrZ5Ws?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NGtDHxFg6MdCH//gxt43/nXXpAdxOhHeq5WmmcnFuPCR17lPm7lhl2Tjbfis?=
 =?us-ascii?Q?peqiVgx6BbfjTIRNT4nTHdm98f1IdbjzuPf3LqQSmiDfqHjqkwb/z5l9a64K?=
 =?us-ascii?Q?XSOc32xOGc98cxrYmjB0577XYg+piB4qU1KkFAZDe3iHs1x2pJ9LbGtOhy9+?=
 =?us-ascii?Q?ON9Hlk4JvLgX4x3Dmlkq15pL0fjg89Ossz7nUF7sdqYUKTwS/v3/R517gA/+?=
 =?us-ascii?Q?zoAgTgGsf0A03SEIjYdyS93EK+JW6gzvNMwjARB3VhjWC3xKLNwdaY6o2kbC?=
 =?us-ascii?Q?Qb/RBMeASJLMmjso8Q8HqvcksRaabAx7PRDfHieyYBfAq2EgT/0hL5pGHSWc?=
 =?us-ascii?Q?VpDLiJJmDlz+1EFgSt9F42+DiSwsEGJMxwKi0P7Ws9UKBwitGc/DUKcU13Ot?=
 =?us-ascii?Q?CSHJG3RjkKQLe6Y83ziq5HIWSNBsQkYYEclFiNgsK1xvtN6B1pL1utxoaHMr?=
 =?us-ascii?Q?NrG8Y+zByzK9gZdaMn54hzMEvPVqW80H8cCPR/D/h0I4KzE3CX47gMQ/A4Ta?=
 =?us-ascii?Q?35qSimxQcClNDkmWCi1GAGufgYBwU84IQqPKLPUquuTfFiJBLwG7vyu1oV6p?=
 =?us-ascii?Q?lb8b6Lyem77a+xVrR/rrJAQd2GOh8ilOv9uSbSo76IKduFKXOIGjdfvNAVa7?=
 =?us-ascii?Q?b1d59imeDFAMth5pwIdNV+mcmbrF7/lzk/ui6nAmvxfEs15nEcp82P7liRXJ?=
 =?us-ascii?Q?LHiQJsMNYOImvdtb7XUvHHJNT2+GMoaXkXIxyq29a6aHL6zzXaS4j73mIYeY?=
 =?us-ascii?Q?2SYkPxbIJpQiLXjaCGp8cMd7SutxGcq4LuIVdUuk9cysoFWgCaMn/I7Yyky5?=
 =?us-ascii?Q?kaKy0ZXYK67hSbGoz/QloGDzdRux5lG0Fm8rDM3n7FxvG9DcUamAZ9Wuf4RT?=
 =?us-ascii?Q?ostzeoWWzCVf+PzYaDQjYZb2WeeW9DWkZ6ltjw3hioKip+7CvjCwWseH1fV3?=
 =?us-ascii?Q?wSh7MLzoW/VW5sEsb0tSiYgHyKFphjvm+aN6xKvhZJ5P0cCcocqzxzWAXFfA?=
 =?us-ascii?Q?IpiSgNxsEIUNgx0uyfAXfVLmjL7yHz6bMNTH3u1NicDtADNyPGh8RYhLDz6z?=
 =?us-ascii?Q?pK399Aw5cGDsml61Y1SqGmsbm7jOOUsjBw2DluuM6Q2EfflOYr8hFTZWjlve?=
 =?us-ascii?Q?P9ZCwJb4suqrPbzWTPw9N8BFhe8suyhdfpNKA0l9lgZnEllaPR1x5G7ulePF?=
 =?us-ascii?Q?wDnoL/JTsrD9TSgAZKGwzzewutdzsrnvqERRZmA/W3IXwDG5baMTWOZctJmv?=
 =?us-ascii?Q?DAtqU0qe61C/e7Jm2RmxX73pXz5lS3yeMS8GTf/S6xfpJJaUec402On4r3RL?=
 =?us-ascii?Q?YUKSpr0z4qMoBIuIhV5vj3MnvFmNV1j13ItE9S4jjvVNONtqoxi6qrHBTUrk?=
 =?us-ascii?Q?jT7iE8NZkNIQ5tsm/e9lv5YmzPpR4LchOYDegFt+0CzZbsPIk+GmktPDthY+?=
 =?us-ascii?Q?y4hFPh8dAxsw7/Zd5rp9nnPi3RrqRB3dofi+gOgUCgJpqm62Cgnh5pL2eA9/?=
 =?us-ascii?Q?4PJ9WJrvd0go3SMb+vBOZpBl5WKS+Kd5kbBfhkgCCGDJrAk1wCnbKPT3lKRD?=
 =?us-ascii?Q?ydpqfZXWEz236VMOLt7mR2Lx0lEFWPihNkbil2Xq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1cc97f-ad32-453f-0714-08de27e10120
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 03:00:47.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTvSdEP5PCeJptPXOWa9KhiOKSJomCUXaWLRdN+Og1ZpCI1uw2gLEhgi3Kp+3ICD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35A1440003
X-Stat-Signature: 4wwnfiskc4hcickiu97r1nbsqhur89hu
X-Rspam-User: 
X-HE-Tag: 1763607650-359661
X-HE-Meta: U2FsdGVkX18+7B2NWg+i5AzaVLNV9Zr5rpBKvDjpuEgpRFkEiMJlJxfmQS+VLscNKNa4/JETOCDmKd+PvqTt++pj9EZHvwvM+wax1ZD6uf7BddnkMebLjoIRLro15PrXUheliXAfqyJundl6SWfHFnXE8y+F+KW9WbfSVLIYY/RJjdI5WjTSqK8N4/vuVjlygjXbMBGhl5Sy9mjihdxA7cpyTcmElhyT7vYfw3wyJolKWHAbQzzPUop9Pz+ifFsJJy6In1t4OwbcedE34N8I63t1iL+DdzvTWPRMGP7GK9DqpeqrHELtB86aJPBsToFLj67AisTh/64Q0MyCDLx1ACjYMScODZjOiI+EsgcqiRX5eOp01aIBP+N6KI4HSMOr/0VII6PRjXBN2yF5GM5nW9UYCa5gfQEE2r28iVSbhQoGyrHR+G09Kzw9ei9H1h8SP2fpQOgjlQi7U/9fC7QD1+eA4Na1oP4WraX2ZXX4Zv5Hs+pplUG348cX9a2VYfNQyc1pQLfwutYSYtCRbN88T0EK/7a1umuRsBlkBJKUVVe3neBKKn0cmIuptvrVDESfv1amA8Xw2DfvGwDxY/jbiGLb6gzc0+DgF+EYGHqxxBODOhYoQwxudcHv+ALLIELqXlCiWXJxDDqatVmj6M+iH2xPorJGBxVYYmQaWpZJt7EUcowlaAx2UHwBcDYe8e5YApoMkMXQFFUxEkmg9WCNQmmId9nq1zmYqQcDrICHb0rLfe6j8eRhm1REUh04uZ7QqTKso09tk5w3f5Bll+l7pMpEFdLgt/6+SSWtThHUEj2iGq6QAc8wnrdWaoq4FHVk7xhVWxDFYAn0dBgd8Z27whtR+1mOyZsx2+Vqcj/cmtHmTyA9d/kmGPd1Nzaol6UvkV7zWZ4unvF/V4XCN0+YycyOepIqy5S9ljh+DWTU9f3JP4qt/CVDp2zuXbmye6/FQxA6DJDqVNatnNmULlx
 8zsvYzRU
 qGG0FbZN8N8ee/s9ui68hdbodE9olqQrj5Fygul9H1v28LINbcTUyHIswU4bUE+BU5Mb86sZIpSa9+xz/tf7DmX2uy3LTNu+5MoKr+W+KIkEfABPW5kIqg49GJaONx6p5l5ulQEEhdYAP5t4BA67UifJDX5Xv1Z4OKWiJn3FjreTpEpoxKQQOSrwXVCTUTrEiLBp+Yk5Xc4XN2hn+hTIvFDiPVWFuRwp3DFfWlNpr8iiWfBJ4z7G/4+EK18UZng+RT8G3UM/nfPCE2qf2IcUqeskbwguL9lf7fvnIlIIlGqT5AgdZ8GNOs6ve12xwyHPZsCL4LoseCLiQ47ZG0HMSqZDCzOJgMeDcu7vV2jSoevnMYAskPh7uG3KPn4etUbLCfFRRwAkVOqottXTrQP2/9yc9rVZb11YzgT6+TTnKD+wb+ZNo2ECCx51sql51QEXEmI5tpapvk1gIsGiRoTOZ2SokgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 19:47, Wei Yang wrote:

> On Wed, Nov 19, 2025 at 03:46:14PM +0100, David Hildenbrand (Red Hat) w=
rote:
>> On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>>>>> Given folio_test_swapcache() might have false positives,
>>>>> I assume we'd need a
>>>>>
>>>>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>>>>
>>>>> To detect large large shmem folios in the swapcache in all cases he=
re.
>>>>>
>>>>> Something like the following would hopefully do:
>>>>>
>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>> index 2f2a521e5d683..57aab66bedbea 100644
>>>>> --- a/mm/huge_memory.c
>>>>> +++ b/mm/huge_memory.c
>>>>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct fol=
io *folio, int new_order,
>>>>>           return ret;
>>>>>    }
>>>>>    +static bool folio_test_shmem_swapcache(struct folio *folio)
>>>>> +{
>>>>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>>>>> +       /* These folios do not have folio->mapping set. */
>>>>> +       return folio_test_swapbacked(folio) && folio_test_swapcache=
(folio);
>>>>> +}
>>>>> +
>>>>>    bool non_uniform_split_supported(struct folio *folio, unsigned i=
nt new_order,
>>>>>                   bool warns)
>>>>>    {
>>>>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio=
 *folio, unsigned int new_order,
>>>>>                                   "Cannot split to order-1 folio");=

>>>>>                   if (new_order =3D=3D 1)
>>>>>                           return false;
>>>>> +       } else if (folio_test_shmem_swapcache(folio)) {
>>>>> +               /* TODO: support shmem folios that are in the swapc=
ache. */
>>>>> +               return false;
>>>>
>>>> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>>>> Can s390_wiggle_split_folio() such folios?
>>>
>>> [noting that s390_wiggle_split_folio() was just one caller where I ne=
w
>>> the return value differs. I suspect there might be more.]
>>>
>>> I am still not clear on that one.
>>>
>>> s390x obtains the folio while walking the page tables. In case it get=
s
>>> -EBUSY it simply retries to obtain the folio from the page tables.
>>>
>>> So assuming there was concurrent truncation and we returned -EBUSY, i=
t
>>> would just retry walking the page tables (trigger a fault to map a
>>> folio) and retry with that one.
>>>
>>> I would assume that the shmem folio in the swapcache could never have=

>>> worked before, and that there is no way to make progress really.
>>>
>>> In other words: do we know how we can end up with a shmem folio that =
is
>>> in the swapcache and does not have folio->mapping set?
>>>
>>> Could that think still be mapped into the page tables? (I hope not, b=
ut
>>> right now I am confused how that can happen )
>>>
>>
>> Ah, my memory comes back.
>>
>> vmscan triggers shmem_writeout() after unmapping the folio and after m=
aking sure that there are no unexpected folio references.
>>
>> shmem_writeout() will do the shmem_delete_from_page_cache() where we s=
et folio->mapping =3D NULL.
>>
>> So anything walking the page tables (like s390x) could never find it.
>>
>>
>> Such shmem folios really cannot get split right now until we either re=
claimed them (-> freed) or until shmem_swapin_folio() re-obtained them fr=
om the swapcache to re-add them to the swapcache through shmem_add_to_pag=
e_cache().
>>
>> So maybe we can just make our life easy and just keep returning -EBUSY=
 for this scenario for the time being?
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2f2a521e5d683..5ce86882b2727 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>>        if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lo=
ck_at))
>>                return -EINVAL;
>> +       /*
>> +        * Folios that just got truncated cannot get split. Signal to =
the
>> +        * caller that there was a race.
>> +        *
>> +        * TODO: this will also currently refuse shmem folios that are=
 in
>> +        * the swapcache.
>> +        */
>> +       if (!is_anon && !folio->mapping)
>> +               return -EBUSY;
>> +
>>        if (new_order >=3D folio_order(folio))
>>                return -EINVAL;
>> @@ -3659,17 +3669,7 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>>                gfp_t gfp;
>>                mapping =3D folio->mapping;
>> -
>> -               /* Truncated ? */
>> -               /*
>> -                * TODO: add support for large shmem folio in swap cac=
he.
>> -                * When shmem is in swap cache, mapping is NULL and
>> -                * folio_test_swapcache() is true.
>> -                */
>> -               if (!mapping) {
>> -                       ret =3D -EBUSY;
>> -                       goto out;
>> -               }
>> +               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>>                min_order =3D mapping_min_folio_order(folio->mapping);
>>                if (new_order < min_order) {
>>
>
> One more thing come up my mind.
>
> Current folio_split_supported() is used in try_folio_split_to_order().
>
> Here are related commits:
>
> [1] commit 7460b470a131f985a70302a322617121efdd7caa
>     Author: Zi Yan <ziy@nvidia.com>
>     Date:   Fri Mar 7 12:40:00 2025 -0500
>
>         mm/truncate: use folio_split() in truncate operation
>
> [2] commit 77008e1b2ef73249bceb078a321a3ff6bc087afb
>     Author: Zi Yan <ziy@nvidia.com>
>     Date:   Thu Oct 16 21:36:30 2025 -0400
>
>         mm/huge_memory: do not change split_huge_page*() target order s=
ilently
>
> [1] looks fine, because before calling folio_split_supported(),
> min_order_for_split() would return negative if !folio->mapping.
>
> But [2] moves min_order_for_split() from try_folio_split_to_order() to =
it
> caller.
>
> Currently it looks good, but not sure it will leave potential misuse.

I am sending patches to handle it. Thank you for spotting it.
Best Regards,
Yan, Zi

