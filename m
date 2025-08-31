Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1076CA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 01:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E206B000C; Sat, 30 Aug 2025 21:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDE46B000D; Sat, 30 Aug 2025 21:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95E06B000E; Sat, 30 Aug 2025 21:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 951C46B000C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 21:28:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 060931602FF
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:28:33 +0000 (UTC)
X-FDA: 83835317706.10.89AD14A
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2BC4C80003
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:28:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sx/gYQ6K";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756603710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOk+tc4ZgYmXbdPorxYEpMvPKdkjaoQodWLcGnZEOXM=;
	b=jHDllvp9fChQjPyqtpBEWoPik2HOQcX/t34VEhK99KySeZyMgrjfImUkJ+HTvb7e8ubbA4
	BqJXVgOwpNlpZEDTg0o3jAs8oq7R1n0h6yIl08vppEStrCKwi1UmwOIjhzTANXBkvYSuH9
	a1a68tPp2M2CW/lW0/xcxR7Sp/qt13c=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="sx/gYQ6K";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756603710; a=rsa-sha256;
	cv=pass;
	b=B4c0ahT931Mx9epsxg03eeNmYRgc8A18hEAyQfKyM8ItmMTyRYMvmXc5v2AdQ99KsijZ4s
	4ix2ymoMt/ye0vIH9BDJnA3HVbd6KkXBtIX2HId+c+VPR74UkpxycYXKwMc4xye0QGUWdQ
	S/ESwiMrJQDETbJGtLEmGwMVXvph5Bg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cu7R6kBeOSV3Pv1PeloQMN5Kf1vVRNT3F7W6VJ6o0epr3CNDSxodjUebpn/r/oA9vgfY7UQs415WlwQ61UFM8+K+zaFRnW+TBIHSJZZRBcuKZhgWGKacKAeWZmCD9NgyI7SpN9f05K0HAAQaD1WWR7vWYHpvvk0SiTXApfJuC3ad4T9qrRh5Wx5qnZHIv32Ob79O1ozdiJhgNiCq4gIL6lisBCUalIIbP9ITG/nQ5qJK5MxcuZ4MEmZd6uTrEcwNFQHhvN2oCV8LhEzN5z60zMUxEJA5IF8E/hceb1chBlQIXnODKRlJMQDX6WI0VEuLEXa53eNM0IjHmbCS6pMIXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOk+tc4ZgYmXbdPorxYEpMvPKdkjaoQodWLcGnZEOXM=;
 b=TYIERnuUCdsR5USatg7sPVswiLj9JrDbsvEyViSfJTbvl3wQi0Cdw/xvLsatU1Vfpwhsx4BVvRUpLq/t+r03ey+/2kIDlvD63t353HgY25r8lQj1VL89DqkNAOXf1EZdokCZj1abbYyPCwcVBR8dylUG2/duV2Fb7ls6Sok2dQTFbO8IDFwmDLAu6bMjECpOi/oE1VwwMH/ylRzFPPfhoxjY5jHCjXI8Z5tjp7K/+mgB7qCcV7jgXVxjXaVpKJDeRmcv8GdnGhOPA1zHMdKENvFxD5N6JdfODuZs/9i6SvNKoL4hycPj3lbhL2KL25Fvo3hoVnfbCFVu10NRYhZwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOk+tc4ZgYmXbdPorxYEpMvPKdkjaoQodWLcGnZEOXM=;
 b=sx/gYQ6K2YtWKSsGKVjkVx6uLs88kNgvPV/Ac0wYQA0B7vW5eQ2pcM9DKua4ESHfwNx3eAQvHYCrtl2lCW9q6yyhWS0/LA/N24bWyMdJu9ft4VeOwI6p7A81cSs4EmkZOTs9F7/TnIj/heKIi4PpaRsChaVPZ6SAn7hq9YOsL+M9b5mv9gzODPXsWbvPZa2gDAorYhY60QnAjjWJLFnNNuwIAVYShoWjSyx2wraer9GNJP53kgbEeb8xV90J6jcHEVpIAk3KkP/fCmPFy0h7p1cQMj6hAUHj181PzoQfdKUoVCsbxhGAb95NgbuIRrcE5DGt+w43KBoUfWjBwij+mQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPF3C36BFCB5.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Sun, 31 Aug
 2025 01:28:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Sun, 31 Aug 2025
 01:28:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Date: Sat, 30 Aug 2025 21:28:24 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <837DD3CD-DEB8-4255-9E38-6006D652B02E@nvidia.com>
In-Reply-To: <20250830012505.v4qoihdqi22na3v2@master>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
 <20250830012505.v4qoihdqi22na3v2@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR19CA0068.namprd19.prod.outlook.com
 (2603:10b6:208:19b::45) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPF3C36BFCB5:EE_
X-MS-Office365-Filtering-Correlation-Id: c0bbd733-fc17-46f2-f210-08dde82dae7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7h8B0MB8MJRxvteLACKRIBTgRkJc7zDqdFEh+6BvfkqAeAiDSuAcUwoOPWle?=
 =?us-ascii?Q?sJGervy0USJgNVLHkqPciF83FBTEvpfhA/ef7Atw1hAU8NaKMCmmueWU751f?=
 =?us-ascii?Q?BjvLRYCrpQSoMJjA8iLSxgfv/5Osp6euNbnYPSZhOWFVjG50SOBEqYQVOR4Y?=
 =?us-ascii?Q?MFVqZUfReEhCZyXOJg6J96Hi4gkEKgKCLIzFI8ZCcMS+cKiKuQz+6MdvDGbl?=
 =?us-ascii?Q?oV3SNq79seTEsN2/3+zGK74v8OplePXCAr/r+2QgbuE+NXkKuoXfw1fkjWFO?=
 =?us-ascii?Q?GZGNxsUDQLlmiuuWIJs1Sovb70RM8TF1HnxQmou1Jcdk6HjH86Fjl4CdmftD?=
 =?us-ascii?Q?um6hU6cn9iiEFdzhBOtfTuGbcitT0LBd2o5tNycI9sEAhMHywRgfol+RPsvA?=
 =?us-ascii?Q?hadb+Ywc/wZDfkjNLfNGABbIvnzwVNAwx8LmVP94cWOuWkDG0vWfFLuPQZBq?=
 =?us-ascii?Q?MuWv0hJv2COOdNUPsDGb2ZU6OZBjQ/03ZvqNVyzdCjnw8BDGNMCnfPYdWttz?=
 =?us-ascii?Q?lw+wXlGI6m9rnl0+D3geM5PZadbpZrJ16hf5nO53ZIDxFQyAx8DT3G5nwfb2?=
 =?us-ascii?Q?sqXQgjBZ8zlmT+Q7komYmg63g2+ddyrpNiUDEVbOSSAM8IuL0kLO3GWtWu2v?=
 =?us-ascii?Q?ZoVMG7Y2i3VLOkQeNUlgmCKw7mF9WY9oLY21IXrcnKEqd2k01fKR2UvwE1Mw?=
 =?us-ascii?Q?59IjlEZ9cCPPyqiw6OdnicJua4mn7RSVu5gWJXDGydX6pjXPQrglIoEoGzGB?=
 =?us-ascii?Q?uw9b9JG/5wldFpCto7o2jlEzJsPoxTtWUzm2xjzhEpaEWtPOufATlxcKJzv0?=
 =?us-ascii?Q?alRU5R8AV57pHfW5ryMxZhwIBTV0cHDuO4NozOQMGEiQGfxLNT4nowmhrB9L?=
 =?us-ascii?Q?DQe4e7Tlj/lizdMPrZSSLVqhwV0n3TxT0wIy9tr6aicOZUBzyxwIpljbitwS?=
 =?us-ascii?Q?9ezTv2gGXBMNNRSMPie6AOhOvoDsk4VR/hMtopo46xh+XAaQKNA+qHZj4HBb?=
 =?us-ascii?Q?fbd4jzLrO/njfNZ3P8ZRxjmZ0tK+wM0o9Zdx+7gEpdU7za64TZPbIG7QHEPy?=
 =?us-ascii?Q?ZzrflZtcJrRXbMmjJIqlOh2Rfy7/xQr6P9AJopwkWUpsGCMIcSMWh7IsAe2Z?=
 =?us-ascii?Q?0H7eO+xar8pC/IqDRPPfZsDZOZwqMTqkU0/CScYkBUDCjTJ+EcnBm1BT775P?=
 =?us-ascii?Q?/WSWFnZ8jxuSVtUiCsj9v0gvcRIEN6C7aPZ41rKj6k6k5hkoKdKfFOFWDR/H?=
 =?us-ascii?Q?0Zi55K892oDmJEQ9kxBy4hgUtvdSUCq4OvEk/hEzsN3hRlrA7UrQVa4kTZ9A?=
 =?us-ascii?Q?oHH0GGkSn2vTQnqOY+xFMJ8es64chM1yjtE/O4CqPQrjy7rLumH+DKchVvTI?=
 =?us-ascii?Q?pANyq9LRB4jMc2GursCa2PhSdEukE7x9l4y+DONkVYBXe++PMcsIwt6gXMAw?=
 =?us-ascii?Q?GBgSLg6fbBg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kj4dSQAf4Vlq5OCGe1099Uywth2FIIiOL8N2xmehauyFn0yfAqVXkrEZWFMM?=
 =?us-ascii?Q?YMs5kVD39IwtvDcUHY/+vs6EZwYEmXlAO4VcvQv7bEVfOAtVY5tM4aFr6G58?=
 =?us-ascii?Q?7tnEo4QEgsV2tZh9hSHPUU47gcn7ChbRl6DC00ZWeXBZrUjIxlZo2RuZuKbi?=
 =?us-ascii?Q?wP/BUCH9eYN1Cbz1dFnlJyslJI4oQDtv8blSLyYimSGNOn7TaAkVvGs4PYyX?=
 =?us-ascii?Q?Pqosd43upDtSTbrJCaor5zAxhquT4IWwTmRrjM09aGbSHzOTReBY2lZ+CLcx?=
 =?us-ascii?Q?H/27TM8m5v6bTReVskjiMD+6z0dTbnayT7nneGGGEqieqSStnnf/LTuFn4xw?=
 =?us-ascii?Q?45DD8HU8fZkTvtDiXdhO2lB6+z5nzDc2MlbcxHnXr+xSpF2ANTaOqYA44/1r?=
 =?us-ascii?Q?dh9/YVAx8QzPMuHCiuzFKGDy2AmPnMO2fqeG6R86CY4ZOUUpUDPsSYR2uNh7?=
 =?us-ascii?Q?aVsrqgPAdhqOYE1Luijks0HIWiLbjgLUPH9Wl9J9kQKiDAUFjS/ny0Dw2gvc?=
 =?us-ascii?Q?Xxdb06cnhtF+f6dVga/T4zHRuTPto9OlVnUbcOcy2Upnzl9OZRZ3CIRdUvnS?=
 =?us-ascii?Q?9+9YXxwuSsRgFUnmljRVK09uxzFWizjUcdfBgi5CDFBtjGkQMdYPy5CYAeIp?=
 =?us-ascii?Q?maYmZ3DhfazQGTq6uZTvrx2eEskqLI1R/whj4/2ghipnKyZs9a4wps9t5B6Z?=
 =?us-ascii?Q?tTdsdZCGZ/vL1BSbmJFZ1CsyadTgaCWU1RvCuLUtp3qcYz07J/CwbklHR/EA?=
 =?us-ascii?Q?b07IMvrRr0jREv8xdtdxfFu85GiwlInEPA+7jerEbIKvUYNSv+dPpBcT+IKM?=
 =?us-ascii?Q?KkCvHqgwzUPvX/XKMKLxS5RJNMnt/Ph3o8ksj7CYHTVcn++Rq3d5g7p77CNw?=
 =?us-ascii?Q?V0t1bNyH2NWIdv3UEmRdRPGRuXUj+cfLGEAXBacyWg4/CE/igcqPVnidyKjv?=
 =?us-ascii?Q?DQG42LWHI0f59Yo6XNcKaJxtNMzz015o9tpvzXESAC/xARN3WVOsNgYCdE1Y?=
 =?us-ascii?Q?MpmtT+T2dbN6T8YH7dyF9lGTu5qDlub+IxGKf7qR18xJl9sg4uVDzldSzDS+?=
 =?us-ascii?Q?sHps5AtNTiFUVYuiuoV9dku2IFpSlBN6/Jd4SiuxIBTKRNKJNyFOl+JaWxJn?=
 =?us-ascii?Q?TpW057QdK/dYZzZyIoNVftCzT9sO6ybr9f70ZnOxee4mQO0MPbrg+FkSgh/+?=
 =?us-ascii?Q?yYPNfcKoayoY2wXPveNGy2fiPH6HoAMGAkOXlFJ1hyKqxf11+NWXfOPS3IwG?=
 =?us-ascii?Q?HtjamxKABYIk+dxweIPjzPTGiuUt8WZfu8ntl4UCNmgtNUKheH389rzFV2kc?=
 =?us-ascii?Q?odGYVlfQq+/TYb0fff1Vo4L7FM9c3SZzTwfHu9Zrbp2quV2agm93hBqwuTqB?=
 =?us-ascii?Q?7/4gRlG/87Dq7G32Jit45lk6Mu4IEH6f9NnOdcaL1SelvWuwKbOlcP6QErko?=
 =?us-ascii?Q?NXFBdUMiHAOjmEq33ckhLbwLkCatybwb/lKvFtpqW3jlTezoiBkqjCELuYD0?=
 =?us-ascii?Q?owFGnQbEFjxdLNd1R8V4kM3/QqvxKui2MlYofw2QVk9QmjbIJW/1XTbvW+ra?=
 =?us-ascii?Q?wJU/eUELqu7pFScrKglH3jvvcQeR0klUuGOXj2eh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bbd733-fc17-46f2-f210-08dde82dae7d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2025 01:28:25.6489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiQqMlFtR92m7lweKQLgpWGAzwgQSes/eIjpFqqLzAEstNvNCtIbopTBD5lzkDWZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF3C36BFCB5
X-Stat-Signature: 466bo1ykjs4kn76ouhozs51abenbcnza
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BC4C80003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756603709-625250
X-HE-Meta: U2FsdGVkX18u61OtBOD5+X5isZSIp15J6BTgRqFl04d4OvPuhoRtkTMGac8m6gRCJMijGoKEAryyJCSlc4Ai4Kft/FREpWSOW3L81lnw6vY7hGZDKk2OhIULpf9kHOUo8S15g3/Tk7IyXTpYUfjk7YRz+yGs6TzUs2XFMPK9W9mI8Cr3gStXuoVZ9ejJi5abxCe06D8k6y8AIr6N3uhd2wBKKcuzGvninUixhaa87SWxTAoYMoZtcfAeUWZ8soLyBOpZImL0c37ww2pRQfsd/8RIbJk60u0uHR02AhscLSUN4e6hOdhplMkJrb+YZJM0iqRMUvIkC/Ye4727V3L+aZU+zfkjNqauuA2uvisDbuokLKhzob61k4iOAELEGJq1vbw0+0RenHCalFu/KBJfL9wcTA9MRrJErKMrh6ADgw67KWtVXaQvBUhhmoF9DUCAK+qnaPVMK/yGKWsXTrME4xNYNR76bBiTBXmb+lMU2MIEZF7wjMfBk7A9UOSCAi7woVA+TF6WeJVLOpxE4mIwaz3Gb+jPNT4sCYuIBznI10fwTgv1WZTMnLwigz+7nBJgnTYM2yLJj8SIxzkAAZobg2Iet0Kmu5wX0qtwas/9IGsgpwzRY4ba2A/tZBxtT4YROiF6wa/oNWAQ4to6Dig6XPTX59NKPBVapyNVRmfC47qmCyeQa+Aqx/OuGxf3Zdgoh+kutuUbTvPGUArr01TdKnGzdvJGYsuuqj3um+i3hNEMqR5n/8V2hShQXa74jpzW69ZBWr2benMbfkUPrN0eGZFPc1Qk/i48Sb8NfphkGDMq6mlgO4ioZnkiIXmVz1DtNLf5knw1qxboPpGD/yEwc4nMemSaR0Xg1Y/BWjVdIQo81/tSvS2YT06AGEEQBviB25aLYTijRL2JDHfqviXxKStd/DQ5KhRcuNr9TvneKYhqbJlbeRPCq++FA5j/qDK68NG+XzJ0RyAErKol+kA
 IwtRGMuf
 6pR7uvHREmEgip02cn934Cq+j7idVEpwvSHcKTjHjidPmxyK76l+b66KGCVYJy/zq0X1aRKyM3TqRSiohXKA16pJlpvCkPb3/dPW+laTmnD2cKjAPpLwbg3rvSFSL07FpASl+JAKm7XTs33MUH8PbzjfU9W/PpMg77MC4pVmRP5ep7VEzBEIHkMRIwoDZeL1sv7XczmQ9R/FWdYAojV+T9wtgFqIawLHlSn9cI7+IuKFOeTEDReekyEeOyvUOi3jEPEmDSTMos9J8bxOxFerniqqSTIW56tzqYypOforu9kD35S5tspgx6H0erpIAXUzUw3LMcz0t35e2ajxHL2W8JP0wPDATEgdbqJzYSSmi3EjUrcu4n6ZQB2DH1bWWLcon+iJhcCFQ72GSnxUdgohSg86KAywckj1cjTqyca5ENUAxXnIzmh9p1Z6ZQr5OEjDEogwfGozZYdGnPSTpht5lOMVGwELwk5yDbXdhJuv1q0ujbNeRpcmHIK+D9E4hbgy3vc/rRv181XOT0EPK9XUJLf76qw1SmaXaBJWaOOM0i6l84GcwFSeZLCnxCg3Bfzqev/01uHKJTRycWjqwFQhGQShgAsxHA9APKkobbw8bDwzX87qsp141/21mIJzF/ldUGcylLYKFlQtWKcVzE5H/xGC5lKrRp9E/oNErTk3F/0EgqJ9ox3s9UcC2Gy/fC/oPca/m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Aug 2025, at 21:25, Wei Yang wrote:

> On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
>> On 28 Aug 2025, at 5:16, Wei Yang wrote:
>>
>>> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
>>> buddy. While if the order is less than start_pfn aligned order, we wo=
uld
>>> get the same pfn and do the same check again.
>>>
>>> Iterate from start_pfn aligned order to reduce duplicated work.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: David Hildenbrand <david@redhat.com>
>>>
>>> ---
>>> I build this and run, but not sure how fully test this.
>>> ---
>>>  mm/page_alloc.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 27ea4c7acd15..7f2dfd30106f 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -2033,7 +2033,7 @@ static int move_freepages_block(struct zone *zo=
ne, struct page *page,
>>>  /* Look for a buddy that straddles start_pfn */
>>>  static unsigned long find_large_buddy(unsigned long start_pfn)
>>>  {
>>> -	int order =3D 0;
>>> +	int order =3D start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>>>  	struct page *page;
>>>  	unsigned long pfn =3D start_pfn;
>>
>
> Hi, Zi Yan
>
> Thanks for the review.
>
>> I think it is right, but the code is very subtle and hard to understan=
d
>> after the change. It is better to add comment to explain it.
>
> One thing I want to point out is in __move_freepages_block_isolate(),
> find_large_buddy() is always given a pageblock aligned start_pfn. This =
means
> if start_pfn is not a free page, it would always try 10 times until giv=
e up.

find_large_buddy() is used to deal with free pages, so start_pfn is likel=
y
to be a free page.

>
>>
>> Paste the code below for more context:
>>
>>        while (!PageBuddy(page =3D pfn_to_page(pfn))) {
>>                /* Nothing found */
>>                if (++order > MAX_PAGE_ORDER)
>>                        return start_pfn;
>>                pfn &=3D ~0UL << order;
>>        }
>>
>>
>>
>> The code tries to find a PageBuddy starting from start_pfn starting fr=
om
>> order=3D0. When entering the while loop, it means PageBuddy cannot be =
order-0
>> and ++order increases the order by 1. Your change fast forwards the pr=
ocess
>> based on start_pfn. If start_pfn is not an order-0 page, based on firs=
t
>> set bit in start_pfn and how buddy page is chosen, the next possible P=
ageBuddy
>> order can only be __ffs(start_pfn) + 1. Your code starts order at __ff=
s(start_pfn)
>> and it works because "if (++order > MAX_PAGE_ORDER)" increases order
>> to __ffs(start_pfn) + 1.
>>
>> Can you add a comment on your "int order =3D ..."? Something like:
>>
>> If start_pfn is not an order-0 PageBuddy, next PageBuddy containing st=
art_pfn
>> has minimal order of __ffs(start_pfn) + 1. Fastforward order to __ffs(=
start_pfn)
>> to remove unnecessary work in the while below.
>
> Sure, I would add a comment above the assignment.
>
> But in my mind, we are not farst forward order, but start check from or=
der of
> __ffs(start_pfn).

Sure.

>
>
> How about: (not good at commento)
>
> 	/*
> 	 * We start find large buddy from start_pfn order, since a

It is unclear what start_pfn order means.

> 	 * !PageBuddy() means all lower order page is !PageBuddy().
> 	 */

Here you assume start_pfn is not PageBuddy() already, but it
can be an order-0 PageBuddy(). That is why my comment explicitly
excluded the case to begin with.

How about?

If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start=
_pfn
has minimal order of __ffs(start_pfn) + 1. Start checking the order with
__ffs(start_pfn). If start_pfn is order-0, the starting order does not ma=
tter.

>
>>
>> Feel free to reword the above.
>>
>> With the added comment, feel free to add Reviewed-by: Zi Yan <ziy@nvid=
ia.com>
>>
>>
>> BTW, I also notice that when start_pfn is an order-0 PageBuddy, the
>> "if (pfn + (1 << buddy_order(page)) > start_pfn)" check below would be=
 true
>> even if there is no buddy straddles start_pfn, although "return pfn"
>> gives the same results as "return start_pfn" (no straddle). The origin=
al
>> code before the addition of find_large_buddy() (commit fd919a85cd55 ("=
mm:
>> page_isolation: prepare for hygienic freelists")) checks start_pfn =3D=
=3D pfn
>> before the straddle check, so the correct code should check start_pfn =
=3D=3D pfn
>> and return early. But since current code is functionally equivalent.
>> Maybe adding a comment about it would be sufficient. Something like:
>
> The comment above this function says "a buddy that straddles start_pfn"=
, this
> looks good to me. An order-0 page that start from start_pfn also means
> straddle start_pfn.
>
> This may differ from original logic, but seems not wrong.

Straddle means a buddy page has start_pfn in the middle and the caller
in __move_freepages_block_isolate() needs to split the buddy page.

>
>>
>> When the found buddy order is 0, the check would give false positive,
>> but the returned result is still correct, since pfn is the same as sta=
rt_pfn.
>>
>
> I prefer not adding this.

No strong opinion about it.


--
Best Regards,
Yan, Zi

