Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 148A6CD6E43
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 22:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEB546B0005; Thu, 28 May 2026 18:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BD46B0088; Thu, 28 May 2026 18:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AE06B008A; Thu, 28 May 2026 18:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B64DF6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:59:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CB7D1A09D2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:59:06 +0000 (UTC)
X-FDA: 84818345892.28.ED1E189
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C96E1C0008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:59:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UqMdGkQP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780009143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/o/Ulf0dt3Aez4JIOWbWJorSc0XZbdL+wK3ba0WHBk=;
	b=WWVrPR90Jw1pwvqeq2hVguJNSdfCdDNwvV1+kfiT5AVhObpv1oC/NyIdv9YlgZDwaq9GZG
	RuN1ltbTht751U4JZk1Mj9xa/9qB4pcsyA1rN/sFCho/fvMuNMusmS9xusMj1dxLZSikhA
	cbl06MCAfC9CLnmOfF+la9T5apiGKQU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UqMdGkQP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.62 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780009143; a=rsa-sha256;
	cv=pass;
	b=vXTSX6T0cdPDP90LRKOb4k4FIlnNwMFGPZBI590gXGZwYUIRffu9KgFQ5uWjOgEE1ED2Nv
	pSdpSCIsyotxx89QYH8jbPUqSWBwTjwtdxep84Yvq1npvejhBtcXozeWaQGTvujLx39Gou
	HBnCLBtW1MEm+6UYKeAlPd9+mZiKHFE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E6RL5mF4KAVSGnPbzH+i0w1SyRAWnGzbybzCLJZTQ0VGM3nwjuq4gY9T/DGvMvTfNgbnVnz/+mUS3U9rAKkvVPkd7NKZvyjMi2y9rbCdB9aDVaggZv0nDv+VZFT/uTvkIcjlkF+aVpjDfZCUhZOVkkN1E/mvL9fZ75GFUCYKXxG2ZHEeEv/jMr/A2zKA/+RK3wGbOVQiZ7nTBDvnvKObXQmS1TO4chdwoEdKPQbSxXqzrsgip2MK1VFvIHAJPJQABzMbC9s7U135wl9Le7aWXXJnErFQCMsFWsuFi1dA5uf0TV4U4hLcTVW3AhZXggei/l18/ta+jlVAj195KgaxaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/o/Ulf0dt3Aez4JIOWbWJorSc0XZbdL+wK3ba0WHBk=;
 b=CqeesTtf8ggmM7Ukk3mHFj9D3vQx0ztiXJMKHFBXBfOO0g/Qc+wYmADHu+4kkZ3jPkb9Y+gLQ11eoXyEk6/jdxSZDkNqLnIbd7OtIwRRWO1EvBdZFOgHqbzOSFYo/6srd7U9PDRe8HEH0a/oGHcRp1rB06E/Q3U6ks2PzhaAfr1fOJbeG+VFGaMIkOxQeelvBy5XhxlBTa0zUMCquK357ra4em1cU+XFU/qv231xXOHj/xlI2mFx7675J6CAqQU0KeTJOGiJCF7KWK1iMcLPDkHiYEjRkmEGUYOEZIibGJ995ppRByYCy8kTCbMPGkL9oFWxvFrnZeAjO1WLlFcp1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/o/Ulf0dt3Aez4JIOWbWJorSc0XZbdL+wK3ba0WHBk=;
 b=UqMdGkQPamGW8W7v15pb3Gkadz9NE3sb7hM2Prs/8u3qceaxWQKtpv4kQPhLz6lNyfVBgnPnEVkeiJWGLdeimQrolLq3tM0iXGoeIDRyZCBtUAjf1hIHJZNRxy7vQybidGzRPoH6PXGUhsEkAzdkzX9c0+wOE+fTqjsb4Nwgdx5yV8+PhO+XHHlx4D4Rb1GV60W42Zc29jtdPWK4EMJKgALYBWhWwRaKCiXSYC797HcwwWJG13d6uPYT40GmgVGufs5YOy+fB2icRyTtIgm2WlK8jKWJYSYKj1t7eTXJyBRwCd47F37MLNGv3NznducN+KwOiL8p4BNmigvIfIrxjQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ5PPF1C7838BF6.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Thu, 28 May
 2026 22:58:54 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 22:58:53 +0000
Date: Fri, 29 May 2026 08:58:48 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] lib/test_hmm: fix memory leak in
 dmirror_migrate_to_system()
Message-ID: <ahjIiKyRx1OoCTBz@parvat>
References: <20260528011336.20797-1-hao.ge@linux.dev>
 <ahfA6THt-gK9ieSf@nvdebian.thelocal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahfA6THt-gK9ieSf@nvdebian.thelocal>
X-ClientProxiedBy: ME3P282CA0054.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:5::23) To MW4PR12MB7286.namprd12.prod.outlook.com
 (2603:10b6:303:22f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ5PPF1C7838BF6:EE_
X-MS-Office365-Filtering-Correlation-Id: e8fc7886-1693-4d5d-8146-08debd0cb037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	et9BSvsCtgjToHGDnioNh1dcnOethwrtERWJ0vx9vD8KFgsqVFhNbf+YkNFaYKSC/RWHrZDDd+UY8/+FaApM21BrtSqVBfpf2tOFklq3HXeYyY9DdAvL6vydUeAd4InfHa1JKhvmQ2D4W5x8VXwdh6ctfBdj5Yw2fFRJ6MycbrZZL2srZR/kfOSJBsx8544kW5Q/pEN9ksOes5489OQqMdoSmXUvWtBBaiumN6yp1vzjWU3z6c944c7VGxBzx54X95N1Gb35nEVzdmut7bo1A+qUGuLllb02HTpNowT+oF51nUu/P+o7z0/naym3f3M4lpV+nL4KfHmt/C9MukL5ImcQfNPjzOgbFAMVMUwkViQrGRMScmX1IgeXIJMLD8TEjPGJdjDsbs3A8ee3L7m1vaEQpo1YBMq5b8FGE9j1VSiEwNcKFdjbywIbSRV/fNDV/MmTiwgM2CfyP52EBVRFqFI7tJ10amQNTfwEz5L+t5vBgfEB+hqL4EGS6zagAIeOqonQtRJZsy2HQ8qoM4vbP9ZQAB+SosMFn5001dyEHpluP/kun5AjfOOgcrgMMupWlVWcO+yPwv9POLHy5/VUdCtQ3EvWBAbAw8YU+vnr9M7Wk2WiPedIBvH4Pys0vK/HnrAsBtylAdqDvolgJncaA93iKhJYIs/dvo2FtUCUM+pEUBsOloDIjyMmwPxBJaaQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9cOnhKb7q/e26hZsdLUifyBD4QSPQfApIBpdmA5M7CgjCqAmafgKjuATjtBJ?=
 =?us-ascii?Q?9C8WLouJVcuYcPdPVul9JMK5wHehTOaASzVkkdJEyQolm7wat3wGRT/L/NJJ?=
 =?us-ascii?Q?uWGGhjgaWUAeb/tyP3uYAmC6j5HBKXReDlAxhY2uH3cK/VuOdhqULPB9YFMW?=
 =?us-ascii?Q?BDyW9r+lbaHvvdHjQlBtzE9iIZQ97dkzftNcLFhyAULgo/cMRBdtxvlvPLVa?=
 =?us-ascii?Q?E1P9Zu5q0ztzJ2aMxjSsZyZcOWha5Mf/25CziLJh9guAwOl2Zro4LTJUX4v0?=
 =?us-ascii?Q?yJPV7hPwfkY5jFiVTXt9I/ck4O0BVaF5gAnJDQUpb5iui+88fXWWfdShu0te?=
 =?us-ascii?Q?WaVIVvnqrckpREJobt0nECQ134m7+T3Uqa/E0Uixsg09/S9sA6tmrUR2zi7X?=
 =?us-ascii?Q?nGMVcG3WOgYHWbERY7nvjNTeK9D0FmbZEXDbZC8xeBcUq2HzSARFgOXwAEPn?=
 =?us-ascii?Q?3T+vb6gTk732Vy2sqEHZn/8XpeBDMwY1t2SreHZEKOzmD6wpzgg9KwtG7LkD?=
 =?us-ascii?Q?6HCxtrS2hBAm9H00+7apyhPmned1yBMYVoBOru9veAZjCrRbvu6hQ1Ku1Gmn?=
 =?us-ascii?Q?PDGUAoF9V55Wdh2kKnzZImTbPdw9JXOCKz6URmvQjSOYStQG7R0ftfR8JPpz?=
 =?us-ascii?Q?l+ZkRmaO6OoeUDQxJTN8TIn2pvsaBUPtWwPSWWQKw5sVztEiryeb9MHXxjnn?=
 =?us-ascii?Q?fgCLG2EVPrCAlvnZKVSuht1RX5YJ0EBa1ys8W76+s5FYseIOZJu1xzhWjbOW?=
 =?us-ascii?Q?+xAD42BaxCXAY4NlI9IfjOayktTG1lw7M8T1dFacxnvHafwAPEYxDQSMpK6k?=
 =?us-ascii?Q?+pNdOQ9CcCuxLALp/Z5MYAq+fCBhmSxlI4wSogYojdLn65TODz+85IK8tAnS?=
 =?us-ascii?Q?Ngp+VuFg1GGJ7z1y+D3r3jo9w/I1DcEtNvpRmi8/lGBS/6v8nsphuaFyET8o?=
 =?us-ascii?Q?IbIt9hzZ/Z64TNJ+69IfNsud4wqONNxw6sBAYXBS2Jru7FSkvzuBuGGb3Ull?=
 =?us-ascii?Q?ae4hVw0JNvM7hyVCJqwWJhUBkpzdj/2BEuiKIP4mCLlAmuwR3YtBYepdUiyU?=
 =?us-ascii?Q?bgpHHohb7otcrlvxaS86ZmsdnP0lbgz0SwVGPxepFci3RXpYsCSBPAneHCAI?=
 =?us-ascii?Q?6cA8W6z0wwHOl1dXDL9R7ZRpFoQ6igEqzxLBmX1GVjIpeCobk/weNJxwssiP?=
 =?us-ascii?Q?INnKHoUPd+V52MJjPVFYSr19eaXtHSjOwU7z7kuP+3/uMboz3740ftbebXG6?=
 =?us-ascii?Q?0/P5dQvdwdRNRReuf1/9vNzN+H17OMNkpuLFQe8oDDWH6/ywvxJlyw4htC6J?=
 =?us-ascii?Q?hqmTfHW5TscEg+ECgEqwan9u/HsYCa2XZfj03hEhjxeC2BROhhw5aM3pDoyh?=
 =?us-ascii?Q?H84r6clcm9HWH2gz+52ci8AHaXLPVhJjYQFzGgWHaqpXV33oUjYKIIzADAaC?=
 =?us-ascii?Q?JU4pQEtXVdfqynx/HfjZrhMxdW4WKePYDQVGpBHXwFwz1fvIV0DBFn7pvMXA?=
 =?us-ascii?Q?nsmcDJlfAff7ATi0OYoweMd76nCh5RkbARDiEV5xHMfhyJ+Y94wahmnp3XFu?=
 =?us-ascii?Q?GWOzFXHvX94ikemXMKp0CF+5R3pGHBS3LRbujSFO5Np2yi8SrhUXzCwWNwJ6?=
 =?us-ascii?Q?rGYzQXgtdrhE32fLrVwGg7sv5bxDNuDQRBcYct8zg+OG+YB8PkFLSDExn4fu?=
 =?us-ascii?Q?q9BOzAiYHC/hPDE9VwIYzdWHzw2W5tk6yrtcAnAAQiNoERHfydkkPz1BkUq0?=
 =?us-ascii?Q?uPvB66b5PQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8fc7886-1693-4d5d-8146-08debd0cb037
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7286.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 22:58:53.6962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fr2eExuz1AxJMQUCXu295gqveKp5pHC+dS1miAYeEuN900aNgMcSwPR8co5Ggq4KZGTUQI1nuTRKNwDpYJ07Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1C7838BF6
X-Stat-Signature: jnkab6y3o7niuhr5gdfy6w4mxap9j9ep
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C96E1C0008
X-HE-Tag: 1780009143-45349
X-HE-Meta: U2FsdGVkX19KXlWzIwzGzNfive0qreu+tL/4D9kuB2NdvdeQSlR5sK5KdaJkLE6CfbGZ8hWbt3jibJ4sd3Tcq/RFJxtQ1pftXpsvPMmulAvOXNWKzhyW0xLv3MQhHVeKvruwIi/BPwLnEWGjV03k4QsN2m5m02RjXH2/MbitnegmCtQa9kjB3LBgmHBzBOgS3zXkI03zjRXeOMtzeGEjRL2vFxij+fjTZrVFuDM/G2KRAOS2gAGbjlEJBVAMm1UjhNgfUJQXaX74hOrZ/xi7BWQ8uvtTmCmoVsjI/tTjyiHzEg9uISlfMnfn7U2bYr2JJwARQ/dj0DTt+bh0GX933j+3i4N32qUdQEE1aUvXBsRCZ1w+FcEhec0wzkzAQsK7nXHwVtj5z6CAU1T9Iz/K57LGTdUvLSIM/A50/5di+57XH3OwbnyTjc53pdkyxubVp2uIdb20RO7c0n2yXzSt6vGD7/Tkf+kE7cOLyi66xX9MY9FRB6jTaqICn/AyrwJ/vtEmUDEPOdOOtgrsStFu4j8LW4XkQ/gIDSZt7ZwD/MoK0ze+uenG/24gZza9/JRLUqljzkO5qX5VNdzQnpJ0/REEoE+T34BSavDud8+rh4OpSlseihVfUfY1Go7Knu7dmDuoDawl2QK9D4nLcjEcKdo9qKjvSFPxaAoTgdLMlYOeJQBU93v/xOsU73GEiDCdExHH3RAXXPf88sAH9/zlDoJ8bgF0oak5WB/fZ1C9MgVrepmSwRPeHgu8CvtCZr2I02NBejLd/M7r9yOAOtsIFkCYhsHpQecPB/CuTTRFs5IertLXu0sEc8QwmTOD8pPOw5Ac7vsefiqR8YcbXv8ti8ERbhh5UPZdrD8Hepa/sOfV0bCV5r7EOpZFMXP7r+6Yq239oDjhd/st5IHTx1d0DWG4UDlvV32GWiPPhW9+kEwZKdho+deN/l8vzFtpAvwZKymUNNbuJ8FGLCchOtE
 eyl8AunS
 gQ2mv2D4AT98hQQjoH4FpoM+cvXk3uV8fHJEUUvbsziGQDsVQ1X7sGgvzuiFSIbcbZKWz0+TwZx107PP4grKRJMcN3bfq5kJp9DQCeM5S31d8Tg27ImYJCppVSetpQAcBX1gndsY3HYBt1SkGqi2r48s2GsXDvnISmvEA1TIzbPkt/X4pqmLlLBf/BXwAnjr2DZ7YWi+clonhUoDsoRYLRD6w1Q2+DKnHkDas1kLOLs3Bo/IwsXvoXaoTvD1jN0mJrd7tIqxtqdTXK8ilCwLQWgYoiCI3dNUxNRMSJT/KlI1SUJDfeXNVgKWKHAopj9jE2jRORj2KiqlTGEP3JLWlm/Cs6ZmJbAU9MXqOP6ehYdQOZBUo+aCZzQa45i6VMALcjRWkm8UAMHZ7tkNTq8lKH7+8vkLiGUMxHnPzxEgFO8ex3Fz3zLe9FFGTWMupyQJCpDlZ+sXA4PAGTXVipJCeAO85egUhnPz/f/EKqr5aPTttuQT5gPhjXEoLbykIalTHmaL8Vyk6OqJu8t+8swtCleJPyDhjtA7L/lD+3th5vD0KBw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 02:13:42PM +1000, Alistair Popple wrote:
> On 2026-05-28 at 11:13 +1000, Hao Ge <hao.ge@linux.dev> wrote...
> > Move the kvcalloc() calls after the early return checks to avoid
> > leaking src_pfns and dst_pfns when end < start or mmget_not_zero()
> > fails.
> 
> Thanks.
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>

Thanks, might be late but

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

> 
> > Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> > Sashiko report: https://sashiko.dev/#/patchset/20260513082525.154036-1-hao.ge@linux.dev
> > 
> > It looks like the other issue reported by Sashiko (dmirror_devmem_fault()
> > leaking args.src/args.dst on migrate_vma_setup() failure) may have already
> > been addressed in mm-new by 84808b0e9f75 ("lib/test_hmm: fix error path in
> > dmirror_devmem_fault()").
> > ---
> >  lib/test_hmm.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> > index 213504915737..0c02871b97ba 100644
> > --- a/lib/test_hmm.c
> > +++ b/lib/test_hmm.c
> > @@ -1111,9 +1111,6 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
> >  	unsigned long *src_pfns;
> >  	unsigned long *dst_pfns;
> >  
> > -	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
> > -	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
> > -
> >  	start = cmd->addr;
> >  	end = start + size;
> >  	if (end < start)
> > @@ -1123,6 +1120,9 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
> >  	if (!mmget_not_zero(mm))
> >  		return -EINVAL;
> >  
> > +	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
> > +	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
> > +
> >  	cmd->cpages = 0;
> >  	mmap_read_lock(mm);
> >  	for (addr = start; addr < end; addr = next) {
> > -- 
> > 2.25.1
> > 
> > 

