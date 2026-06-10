Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D968CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD876B008C; Wed, 10 Jun 2026 16:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84FB6B0092; Wed, 10 Jun 2026 16:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A742C6B0093; Wed, 10 Jun 2026 16:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 940CD6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:36:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C30316452A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:36:29 +0000 (UTC)
X-FDA: 84865160898.03.26F5E86
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DCFE2000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:36:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VRmQtOdC;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781123786;
	b=C4gYbPliot29OjcyAEi4TuOxrX+WlOYiKir8R1SPRrA5sNwawL9gT8lNXnIOTKC6deb3dd
	luFM2yzaGdACS39f9l3fiuK1mmkXI+4Vmyvi/+t6C/bcHAHNAp5ApcZYx3ZirmidTzdp1F
	rbG+x1Xdl+B2atme3dVArs5VKjC3r4A=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VRmQtOdC;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781123786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5rbbrakfJ733LcIqCs08hLoqz6RdsMYH898Am/2d9A=;
	b=H6JiLk0+OYr/r9CGffpf06sRCFoy9KpIv1lrlglc3ftyI5nguGGBrnIzeyz02SIpmPfC9b
	C6Jjhyf2D2CVFMYGqeXS0yWOFWSqnDlVT3zy/u4oBSqR8X2Cc1JXkE8gHI7vPiQ69C5+6p
	6ydb/UJDllabkNZF1+ZC38DxMWpF34o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gk+6TCUiUiFL7xtV6/XOmqvx8Sdnb7s5mT6KzFikBwKFbXJpF9LojYD9yaXPLTmDc6WRvTH51hnmUGKZcC/uUqDAlaTJUBWHiXpx83NshaDZIEFFUJLOpz/BNRA+reRQqYBY7mnVcG903oiWOH0PcKKDbwXiZtAJkPBtMIX/ttsIWd35FdNlXTqkSQTAVebzeqqObKxKBxBe37yY9Qlm/82fJ3fMAqNbgkJiHF5EX3hgv4OCwTZ1qQLo6Z43nPc7+tE4H9U9AkqOEdpxhOTKqiyspQ1CWDL+1oYxR0ge2HU5uj5LVTiiJXHHFG4A2/YNmKG52eJx9Dx8nBeq5o/j0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5rbbrakfJ733LcIqCs08hLoqz6RdsMYH898Am/2d9A=;
 b=Ex+GOjlO4xVF9X5AzsUAwsK7zSI5GBe3xhv1D5X7eok3IApvfsWWjSVSEJMW6RLkDHnzz0iqK9d4/tuRX+bCT8AR6M7DWQbaEZVhpg07A0Lf+N6rhSHye1lJusAbZfRXKZLI9vmM1c2qZiJyj5OlSakN2JUgxhXHmT7AlHtyZBWp99qvEtHp7l/nNnEvNwlp1w33vTjpc31zOC04fyQRtDdxH0whzW9MIfylDEcawEiu+UoKwF/0GeiHDfGOemP3wm9QJ9HM+hWHAQro2w1vFh+kak/HDd9mUdKDpCJBA8mhUHapaQqiSrLFTF8nGOoZQSr6M418eJ9IDJxW9IE0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5rbbrakfJ733LcIqCs08hLoqz6RdsMYH898Am/2d9A=;
 b=VRmQtOdCtlBBNbcEiPgqE4LGQhT6ksqxx1kl3GEAV+xRAWrX656hbjevzbgeDgjPHqnQjHa8B5BAgeHhnqoOOJx+psOKUi7OGs9EvgUe3rM5FvsGyhK+7KQ42d11FlSuj4e6kbEHe6ElwmWVQlaHtBhq+zI+QCLO9gUwU3uR1hDX0NzTt7GP0IM+KCyq1rB2Gsi1ZxLE+I0HYU2YpeobgckX7a+B+nkMf2fONar/0OIBJr0J2KccREQx7qq9f+bKwtoxD7rD/IMbOO81/y6qO49nAw/EJdNjTAMnqaDdaaWBECfpIEH/Qz0HaSeoyYrw4Ok0N8Ow1Uk5z3Soi2iZVA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB9015.namprd12.prod.outlook.com (2603:10b6:930:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.12; Wed, 10 Jun 2026 20:36:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 20:36:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 16:36:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4E038FF7-876C-41F2-B65B-40D6FEABF0E4@nvidia.com>
In-Reply-To: <20260610133002.4ded8d8cdc8e23e434fedf1a@linux-foundation.org>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <20260610133002.4ded8d8cdc8e23e434fedf1a@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0926.namprd03.prod.outlook.com
 (2603:10b6:408:107::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB9015:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea46039-6633-49fd-d9b4-08dec72fea9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|7416014|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	B57Lq7Fb2zVpwXJM9JeHnW5ZvKxkh5ZOwhYweK1eNNHBNwvSmi7L/Mwdli/OQrECVuxaVw/+eZoWIpOriFlb1vG/dtk1r+bC8okk4E/yvv0yxxBs8Gkac6fRYxdRX+mwMP++O+AP9N6oRD88EKADjZH+Sl5HsTkJZTxI8UBiOh5B9UZgXyxPX+MttkbgT62lhu3e0kc5mLWdSj7VI7uedmJUckuoSzGwHCR0YBebTPmthkwADkmrIJcMoJ+YMSF9mivy8dD4H++Gfr+8QC21egnCGOUrP1caoRLImlHBH8hOxLhbvSXrqxY0cK7JoJ73nmwI+nn6yo3OdcrRcnm8hr1bEtdSwj3T5Kp2sXEJFBmqsDPCUmqzJhP7gl5HhqCYLlRs02/9E2fToRAV0NLrdIO7BVOk2rd905ZK91pxODKjcm+tkk9SuW5bG8uHieEbPPl21VpLv/thxvWusCowkICiq+nDvGsuow/jGDHk8YxNZQe6B6R9n351gzHfRBCg46LDlGdqvdl986fI2c30/VIp+yR96/leh3CQxJG8jAQsaLaYOScNi7u38Hy3aDGKINzcCdSws6nyDnoIbwSxg+wRjaLMrgkT4awc2L1osNP/lJSHfBOD+JqJozODQlh8ZS5MZeQfGNvunpXhBb5M64Uuc3xSNsSMvdIKikRZGpwG+ab9jYiObiLx/91SGhxF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?77RnT3vgCXaVMj6RbY2v/H9mBElt5WArQt1M92dY2izfCC6QgkQxfrk+7T3E?=
 =?us-ascii?Q?x8GIuKGKMcOCBBcZCaeOJThtyY2zd+LSFHX+xqUulCEGqWZqCBWWTzQBY+2D?=
 =?us-ascii?Q?iG3gmCFpVXkw6vpucZf6jp5X1zMTfFTaFZGkujHVj6oPmK41OlArgC/jYZpR?=
 =?us-ascii?Q?OiXrOznIK/jHRBn06As+c5EaTQGtJ86fTZlaSfj4vpx9JTetiDDCN0VriCP5?=
 =?us-ascii?Q?LB+HSQZKppBwetlLRkJG8403ttGsyq5HKRQqzVFpTcaKS/DcMfuIXLBgLO+e?=
 =?us-ascii?Q?FC8FZFE3fB5OXUGgfDjdSfZbIQGvtAkeh4PlIymXgXBGbSFGBU/0mlSXzh6l?=
 =?us-ascii?Q?cqI414kQxOzr8FVXfuHAQkS66MY+EaKaAYTOfxAT7ExvpvkFTFQ6ui8pvHZ+?=
 =?us-ascii?Q?dKPTh5RrCF2bLDksEsrD7EoFmzq0gPdpzGD3UEMP+QRX6V7NJE1jojbKnnkx?=
 =?us-ascii?Q?iAUgsF3qSQM8anY3HNeiYbbSjNDohrSs9oXHj/jOBO2OHDXHzSGVeEAOQVdj?=
 =?us-ascii?Q?uaj0yABMOPeQqKgr6At9J9DwxDGyFeJaUp4S1xjoE7kN1e7RhwlpJkPvy5//?=
 =?us-ascii?Q?xn0/HsmdrW5S7i+hGB4eWPvkGI3b5kO/eYdBxKsIx4sP5ECoMTjqp4YC/8oM?=
 =?us-ascii?Q?MFXYf81pQhwkT03VVNTSor7ivvrIMWW14T+a01sjgvBMjsOBYWH2pjv+Rs29?=
 =?us-ascii?Q?vgO0FBLzHGMZPPsOhtsmZlLf4laUIbFtYyZ3LgxptWc+DiOrZcKazwRZ4SeZ?=
 =?us-ascii?Q?Zlxq75djmeunNBB/mf+QsS1s8SNpuv8t/D7BA+L/lwqbeqbGGft0qTMq0tex?=
 =?us-ascii?Q?Mo8pisp0hyjmKUifPTDlNZstgWGXak1k36iwEqlG/V5BMNzgzfS+37wdjPYZ?=
 =?us-ascii?Q?DUWhXL+j5iZNcki/hYRlUXGinmhc5uDp9e8eVlF2PBAJXMB+gplbAy1WsXRN?=
 =?us-ascii?Q?rAQAA4ougto4386vQS7Xrvu4xQ7G8s6oe9BSYWFaWvb5hpsFUux07FskSi1l?=
 =?us-ascii?Q?ozx/T41Mk7J0qK/pIWv37fbMpIkzaKov7VEdfiiJVI4oz5S6UmY1ZjpBPLDa?=
 =?us-ascii?Q?PABVRu6SDDEuuv4U7SEFoJImHgysSsoPa7IqA31HaqWvgykeet1x7U/+mkdp?=
 =?us-ascii?Q?AQBsQiX0n5Sf9T2lQ3l0ykEItCECO5s66ayi7LR9AS0h6yqAd+pSjkw9K+iu?=
 =?us-ascii?Q?h6ni79DYfVbAe6QnnuD+TQRvux2G2ipgRDbAVp8Wkb1axtBF8Sfg1Qqwc2oB?=
 =?us-ascii?Q?6VQAFXWUwAsWQVnjp43RvbBqBsh1I6n0++NqIa40akXQUJRZTVMBKvqB41jx?=
 =?us-ascii?Q?3PNAZ1TT5jcV1g/XxEGvs2JqVZtBnj37n7TkTjtzjdjl7sxIQY3FivKiJf65?=
 =?us-ascii?Q?W93NKvLrwnXfYieMNWuehgQhBBhhQkSWgJ6oHUxsHErElOs4jWR8ig1zyp3f?=
 =?us-ascii?Q?s2GWrx5DP3uyNil6uJWdMcnvZ1OikYQl7XluFC/CCoIZsnZNH59HrJDjsrfp?=
 =?us-ascii?Q?S0esVpCTbuemtiEfsKFrqhLxFeNOPZghzWVm8Yk/RQCDQQJbxZ4PBTPZGiO5?=
 =?us-ascii?Q?/gZc8QgGrOw7A9mu6equTFuwHGYZfvrToOlKKT3MgxQGweqkTp+BEhgL2qdD?=
 =?us-ascii?Q?ooa5+xuHta4A+1mjcD8SyxaG/tD1P/iCVeu5SEEwVSLtZg2ebtGNV9ztvCSZ?=
 =?us-ascii?Q?0fxnsboBEE0mBGwceByMExvrmFlGzE3qAaB2VzcWAAh+VgJr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea46039-6633-49fd-d9b4-08dec72fea9d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 20:36:14.8392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5y9Lh9JH7oYen0nm4e1aRHH7BzJ3DmZSEn++VtdrVtUeWdQ61GZP/ToDVi9DVc7Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9015
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DCFE2000C
X-Rspam-User: 
X-Stat-Signature: zeydnh4rn5f5dcrufe9znt1wtf8dznam
X-HE-Tag: 1781123786-894046
X-HE-Meta: U2FsdGVkX1+Q3eGtMRWzPVKg9A5uBGdMdjWwDaYujlKr7+Bf4AbfUnCmGNePvD5JQOaQRxGSHrRwJOCZVBfMlHA4ZMbmbdwK3eboFD+uz/3ihl9evhJl+1DdPAs0624NOKvAXiLZHHrl30CdOV9Uhcodp4PZpZMvBhCgva3neYR9AxPjEqXrGifOdrUq3ftw3IF+MZY6bH1ywlB+P5FInZ4SePouC6OjjmPWs14lveMYymxc6LJwdZ0H3j/bTDGY2gPVuQF2WmHr7eaBj2OHVxasoSdMgjnrZVC6lzP1iWEDmGpk8LzTOMUG0Ep6ygQCaY2NUmCJoHVZYrl6sVJ3EyHdUqGU5+gZbBG+CArKiichSIw6zQXrjTjsR+3A3feUSvb2tmVYQlY+mvoIu1mK4MhqIfNUku37XW8hZGUDiEAT234Nj86GxOgRBsFjf5lQh5xTyXXMjfxuFmu9v9ptSdQVyuXGmijtEuAgI4Yx8E6mn5yPLmQtgzchzEnwQvfTpL4kIZPeJGG/nCHFcCZ/oesP01rJaz2z69Arf5HbntW3/Yz8jB9L2bJRiKjiZZzLOZJ6G9SK/elUlOWEftIbkmI1RGJ7W0z/JuAqLvTrBQVOTzZNV1+4NjIF4j9ZDZM34bm9UlY0swjfvdIU4SrzzM43PljJRLePKvELoCiVvZ+aKw8uvm+lbFFO0cKnCGGmYRI4Y+DybQrqFKWEFPq21bqMzfV8aeO2FnxOML8+yEPrjI8AR9F8gUY2ImsBcOTPHYWq4r380aC03Jk1Pw7pG7YlSYRgaoKI3n2DIxQByBQ2q6KwRXyCyXkNMSzSbLLur9ylAFD9xd0pa8ZBuBtZ9/Zvt9hDgkQ2K7mmDbJud0dkneisUvsyiINN5JB9XZ0IhEJQveGqTN0F206t8EMGvKgFB08Z7F0yr4UYWAV9qcGvz1JDaBOLoClGh6uc1fy5srmi9uDmamtvF+87hlJ
 ejwVrx+8
 fmuxS4t+C9wRceaUHugs0zHm9cFXuyBKgjaDVy7DIPjSMVHXpZMVvBw3mFYN5286f/rav4FWkrOWHTdvqlXPvlcRZKDQe3CCcE1Betj8fdnAplEeu+IFrvV1gKuV3nwothQTGCqmHr6BEGV7lwEaQH0YlKmsUYUyOBEWgQufZKP3SNhoOqRlgFV87x343zo9eJ0Sti+ECoTadqweCLz5nHB0e7IXBC2S2twRUz/DLDfGD5+eeNFaRTnRctQF8u2WV6e25T/zJT+VXxmaefdweLSZ/PfsM7Ru1o4c2pxwVTzPcxJwWznq3eJxUaUuow2HyrkDNKTiW86tOyO87sMSHNMsEtK1dmF9db2FBUdVltM6Y5YzGyF+hcw/Lb52XJQf2vmNk0OyVNSIDCsvuLesezkjDj/wauNgZiDPWyqu5PhKFbStVsIYbDqL6EL8SvI/57tAgYjKA+XH73gZ+MZ3ov1F3RtH4RBWzKFEluB5Vbff0EDVj7cTbWuZOkWAAJ+GulhYYWq5iDEGtS8rUBbN6dMW85A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 16:30, Andrew Morton wrote:

> On Wed, 10 Jun 2026 20:05:35 +0800 "zhaoyang.huang" <zhaoyang.huang@uni=
soc.com> wrote:
>
>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>
>> The kernel panics are keeping to be reported especially when the f2fs
>> partition get almost full. By investigation, we find that the reason i=
s
>> one f2fs page got freed to buddy without being deleted from LRU and th=
e
>> root cause is the race happened in [2] which is enrolled by this commi=
t.
>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: re=
move
>> non-uptodate folio from the page cache in move_data_block").
>>
>> There are 3 race processes in this scenario, please find below for the=
ir
>> main activities. However, by further investigation over the code, I
>> think there is a common race window for the truncated folios between
>> split_folio_to_order and folio_isolate_lru, where the folios lost the
>> refcount on page cache and remains the transient one of the split
>> caller, under which the folio could enter free path and compete with t=
he
>> isolation process. This commit would like to suggest to have the folio=
s
>> beyond EOF stay out of LRU.
>>
>> Truncate:
>> The changed code in move_data_block() lets the GC path evict the tail-=
end
>> folio from the page cache through folio_end_dropbehind().  Once
>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
>> page-cache references for all pages in the folio are dropped.  The fol=
io
>> is then kept alive only by temporary external references, which allows=
 a
>> later split to operate on a folio whose subpages are no longer protect=
ed
>> by page-cache references.
>>
>> Split:
>> After the page-cache references are gone, split_folio_to_order() can
>> split the big folio into individual pages and put the resulting subpag=
es
>> back on the LRU.  For tail pages beyond EOF, split removes them from t=
he
>> page cache and drops their page-cache references.  A tail page can the=
n
>> remain on the LRU with PG_lru set while holding only the split caller'=
s
>> temporary reference.  When free_folio_and_swap_cache() drops that fina=
l
>> reference, the page enters the final folio_put() release path.
>>
>> Isolate:
>> In parallel, folio_isolate_lru() can observe the same tail page with a=

>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its =
own
>> reference.  If this races with the final folio_put() from the split pa=
th,
>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio()=
=2E
>> The page is then freed back to the allocator while its lru links are
>> still present in the LRU list.  A later LRU operation on a neighboring=

>> page detects the stale link and reports list corruption.
>
> Thanks.  Sashiko AI review might have found some problems with folio
> flags:
>
> 	https://sashiko.dev/#/patchset/20260610120535.2370844-1-zhaoyang.huang=
@unisoc.com

Claude also raised the same concern when I was reasoning about this issue=
=2E

At least for now, my conclusion is that the race between folio_split()
and folio_isolate_lru() should not cause the issue and something else
is wrong.

Best Regards,
Yan, Zi

