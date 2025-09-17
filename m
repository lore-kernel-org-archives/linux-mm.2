Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98A5CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7DC8E000D; Wed, 17 Sep 2025 07:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF728E0001; Wed, 17 Sep 2025 07:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE108E000D; Wed, 17 Sep 2025 07:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAEBB8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:22:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC04EB9B98
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:22:49 +0000 (UTC)
X-FDA: 83898504858.28.D4A7CF7
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011068.outbound.protection.outlook.com [52.101.57.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3406180010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:22:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iev9tvad;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.57.68 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758108167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnpEPkLNx4tgAzdAqaQIJKgDVY+FGHX085UqVc9ZsUg=;
	b=ZzlHbty4lK7MD1qLQCEbf9gKzFUCQlOL/h6VcK8mOBbEYf/HU3vJyfusxQtOQRIN6BtRLv
	HSqOVZ0ljbi9MR0Ms3CT9XgVgyfRkLB8x2eiJmgurFoAyOLA3UFRzwD8UOy188x/6p7WY5
	r3KOsxbuecsbeAhur652bO6zd1G1wgc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758108167; a=rsa-sha256;
	cv=pass;
	b=N6o3cgZLJWqDSG8+h/YtozTroRsFRBj/Xupon03aFGfLRMtykeMshGPaD5IQtHGxxHSZ3m
	EDSr6fx3ztONxAnG8X7FpF7x+DaM5jre/1VG6Rsv8AbM9VLam0LsJSkGpQRop5KpYW36vm
	OrKnD++t2hXVHW/C74NXAtrAIg9EpsA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iev9tvad;
	spf=pass (imf06.hostedemail.com: domain of jgg@nvidia.com designates 52.101.57.68 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JbJDojgMGGYC5RisI3b6lHk/PIln2SSiEmhovtd/aEC1i7GQ3lyfYCwSUeQkmSvsw78OEgTUUbKl04VY7P1C7SvKRHKAAkX42hBEwkNv3ANGLd9p7QPhy1wuAT55yRIP6UmP/QhJWTLfibCdewprLwCtxaWIoWfiaCJE71Cl3bFmZ7mqX32vH3Nz2CX+unsv2SydqluWoJLR0Wlewb+W2X8TRgbpW9zB5yerkWNH5mpEJzkLW44d9rUuCurEfHbvwXBdQ9b6Zb5MT/jLfoTWkyG4qcDrmq1rRh2D0wGfl/9YdRoAuOoLdbKve25N48FG8P/YDTFndSKaDuc5p4v8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnpEPkLNx4tgAzdAqaQIJKgDVY+FGHX085UqVc9ZsUg=;
 b=tWtyAQxn/I0RfAZMAkNU4WflhSnikujni9suVBEZa7Or/m3zBW6PL+G3jOrK3DHIXx3XAY16VQRielJG+DrUUcrX5v8Z14hAjMvNApR/8tnp8OPnCPI0YQVbygPihuKwFPFwXhpf15T5MIpm+lD0viI82h7G8dCezUVnlSMZPHEMypc+EUE/c9WyC5CHBKAXo/3b6KMHoVPcGQc5aK/WwSc1DuvBfrXQHejYklAR5FKMVk4k4bVAZCs0+uTEaJIMZVKytqutzl+ScjPlSKccgOrNSM4YWrp2H2M2P2AN1TP4cYCJpQBBbVQlmiSFwvQPFlBT/pMX/hb0jicAOjSIag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnpEPkLNx4tgAzdAqaQIJKgDVY+FGHX085UqVc9ZsUg=;
 b=iev9tvad3Xef9CF94qES7qMhB8ii9h8VherLTrUhf9pk5gmKafpT7Tzh1HLfjd0F7n3Bw7ExV6YcDc9J+fCNI1ZnwVFGihWH1ujyXNB4r10yAbdiOcGRyPr/i5VAUG0jHzShWpXAqwY6L7A10sTDJloT06ar/ChjrQYKNXbIpSmDiF54Drav3ukiZjMjtw28/VLkubaZMd1/eVrqkufgfG8Y6gtfuGC1oeLFZnab0Iqu7cp+G+oLCoUJFX0svnQ88AQ00xMq6LPFHgUNGrI76GvtIvUoN4fpDmjqXbIo2GkWp7DuaMkOJP2dfzzmemVFy6WzLIB9pLVeGQkCJ/DruQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 11:22:44 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 11:22:43 +0000
Date: Wed, 17 Sep 2025 08:22:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kasan-dev@googlegroups.com, kernel test robot <lkp@intel.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH] kmsan: fix missed kmsan_handle_dma() signature conversion
Message-ID: <20250917112242.GZ1086830@nvidia.com>
References: <4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY5PR12MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 66db3745-88aa-4dd4-afa4-08ddf5dc8568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+KfuxH9UrAj4aU3KMGaubcZIrKofJMLEZJSi5PFiFyRs3oh1AmVvfqhslbUd?=
 =?us-ascii?Q?n71kpskHIwSx4i8j8cWKSQ5iauwOiWAJJfzCDukjv36W5vvX6c3XwB5QyHEf?=
 =?us-ascii?Q?K9Z813XGWB252to9X0XiozzVoSnAmVkkccK/vI1XCLOld/JPdIuanwAN9Bt3?=
 =?us-ascii?Q?XLhoD0XupQKhJVOJKHCMZcbIDWAYEVr3WSqNmA+AxrZCu+ETc4he7W+H4PNE?=
 =?us-ascii?Q?Bg+G+Ek+M9jS/52sOiPf7yBKb30TOr07Be88Kb3aN+PfNHzCislf39lGWSnB?=
 =?us-ascii?Q?4QJY2UN/cbI+HOWAta912mxKdRHaGlwDNcTrqDxcnlNSo8FR1+egzYJc5Nac?=
 =?us-ascii?Q?Ybu8pVIracjT4wUycN7dW3//4okIz96ESS+0SGVWprjQc3/A8/NzxXUJR23p?=
 =?us-ascii?Q?3sRLk1SsHI1AUIegl4/9yChsrhRXmknvVseTxKPWB1V5h01zUnM7bdeNr6al?=
 =?us-ascii?Q?TOKdywT6Ln+SlTS+zOsrZ8x8bEI+L6wRS3pjwo3aEtVXZXkIdrrYMPw5auUU?=
 =?us-ascii?Q?RjBYU9R+tHcv5A+PCvbhLlSFOb9Rl60A7YYqRIGkpYvq5CIfEDor/xFQJ9Ay?=
 =?us-ascii?Q?X15NPUyWXCQ1X4Ip2u5shKv/84sIw8T/QqD8PUjoMW0hZAvJKbt2KV9ceJrc?=
 =?us-ascii?Q?cN+G/bWxFxSWumrN5epaRLgbUelLFf9iBzU142EAvx4uFRWKOC7Ff0gN4Gu0?=
 =?us-ascii?Q?Lyzi826KUyL3lHC/kHqJ9AdsBOdghXbJ+lCip/gmDldI4zoVoHORGcJbPA9v?=
 =?us-ascii?Q?shRRRy1NRd7bi2m+UTs+rbYeHrBfAQSSTVabws5swPY2vd8m7jBUbrZ4uUy1?=
 =?us-ascii?Q?oa4Kh59/4c9w5G5Eh+1B1Xrf++EQs3CMkQSh1ZLfpeQL0SHMtN9VYiIb+KD/?=
 =?us-ascii?Q?jQXR1kDmjsda79TGSGvRpf4bmU4B61OS9wlsaQFfm8DOrUBNpUGeNEFxwsOJ?=
 =?us-ascii?Q?yodlafIhb+WbBX5dR6eySmfE0sGI+C2C9StmaInAL2mB4UEfyFJtIAVjRArP?=
 =?us-ascii?Q?MkfEKHhnHUtmAuy8gY4yV+zL2QjaGjHgm3XNUg/VrxuTGxh/Kucgyh7TKv9a?=
 =?us-ascii?Q?3fo657FQksWpeh8e+o3zhWRllSIiQ8BYfgC83ZYu0a5n2eLN0BbpemAih5Ua?=
 =?us-ascii?Q?Fpbh6PKZ//4uQ8BB1l9JR6GyKVE7Gojw7zPbZzdjS/1631m9qPC+EtaSQOIZ?=
 =?us-ascii?Q?A42BDkzBglNZT9UtAbAfajSvnx2pPEHfgGMRbnb66KKk/JAGM15f2fmaqx4/?=
 =?us-ascii?Q?TjLCRrhZmqtmHw+fteGErYBkQUEPkHCfGOJbhQOrxr/FdwvWvGZ0q+2rDaZe?=
 =?us-ascii?Q?ruaIN2NVVF2BUznUNTn9B+QJ3k42ABg3JgrC5q7I4TnTP5Fc1YRK/tNBp70G?=
 =?us-ascii?Q?ppdqNKK2ZrBiCXohHIRJEO7KwmqgrPcAhfqrJGEMkoRCbLUPBChOggkNKFkx?=
 =?us-ascii?Q?kx/fKVcFB04=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i/0hpM5yErP1oqcrBoSGIKYf3MAF6rYoKCp41CW/f9a+1EUtGI1/j8uPOZ4P?=
 =?us-ascii?Q?L2TQpIf9n4m2pBuUqs43i9IZMNMoIzrYxaQwBHsfYl4lT1cdN767qOaJc/KU?=
 =?us-ascii?Q?SHR1E0AGc6B9LTSse/nldqL2PgMFIKRCAGq/BvZgy/YiGt65JzqfAkq1UOZ2?=
 =?us-ascii?Q?LN0Zn83clo7r3qpRkiQy5IKzQoxR4raz7fOAA5lEJIy9+xtKueapAlsfzPka?=
 =?us-ascii?Q?0EBa4ihl73XnvbIg8gD+utKheKU1+XKwHhFEUm/DqP9UApjx7TEuEDiXhX70?=
 =?us-ascii?Q?SLnj/SBU1k5e3er+Lli4eQ3CRzCyDa+LHCF/x//7LJ+lxu3+EktL4e8SuxQH?=
 =?us-ascii?Q?QrClpRCtofc/DirvJshKPGBqNIuOAakWRnl/eA68tew7MespJNt9VB63ZED6?=
 =?us-ascii?Q?JJxvJbg3mwVTIXUpEZeRc8sRoC4RA8AvpaBNjTkPEgfQR0KttmRWluE4rLwB?=
 =?us-ascii?Q?OETbiwZ1L6n7QQxtXmn2DOmzNv5f/xFXwgXIdId40UP3KcOEouT0qa+Cf09T?=
 =?us-ascii?Q?810e6Stj6q/NwG8158OqtLr0DMygz3u7n8pE76IyNWWkPKaHRphKcQQjPQHe?=
 =?us-ascii?Q?6uyN4WTPB4aoLKCWYg0IAMhYkHZxh4kXX5uKHQip/l+xhxzvQNsvDql6R5BJ?=
 =?us-ascii?Q?qGOJb/nN/SMXE16IIU+WAfS6fWb0uCPFoVrzYpKcXH1BeH/U8L8pGRuMFPPm?=
 =?us-ascii?Q?vXp588UlPCvMp/IVVTQ+lz+7G5+QhHnLJAIVaNtr5RGIO8DGzvbu4YjU/LXR?=
 =?us-ascii?Q?Nf2DHioHlJ3+aqjzkvWheUqdvDp9aMr4ciiIQD0eu+CxpZsJwJ7JympBHHMF?=
 =?us-ascii?Q?zdazwZN37/jh0bBSoTsY9L55naTroZLF9V7wCWmcIqcZXlRW0tYe2rheEsYD?=
 =?us-ascii?Q?Q7QGGdm9CF+sIsOzzhU2ANikaMa8RyKSUbl66L3asWK6n7+jTi0vA1r8WW4u?=
 =?us-ascii?Q?AnyBVDGKBA7nvgIaXTc9+h7hvmd+C6XIYkHQpY9380kqG1UBq0RYxRN9Jply?=
 =?us-ascii?Q?NcirxGo0vcBziKGOkoaVed+uT43q6jaHBy3X+yXfdQvBbWLbnD6Vlb1Gr9m1?=
 =?us-ascii?Q?LvSLOMiGy0B13OHGWVDbxSURqPp4/IeLATuQW6y5Z1DXwliWmHnxlMruBfQU?=
 =?us-ascii?Q?JGv0+znTwG0YGU9fCo8bH/5R/ItTVfCwfPAaFLCQwWDHr4LFhQFvjuQ8KRVL?=
 =?us-ascii?Q?vGSOA5HFLW14CQxBJ31tO+GU+lB2qke2nVVs9U0zS2Yppjpedmj4QpjNXt48?=
 =?us-ascii?Q?88MiS+JXULUgInkj2wtPZ3IbdSaf5wQ6ntx/Z1JUXfH40kVbK1kzouIfXFAd?=
 =?us-ascii?Q?M/8NxX5+J6FVzlyp3qCYpI+dtPF+BCK9Cs2l+MKbyw0ZhW9lwoVwXInJJqhO?=
 =?us-ascii?Q?7c6jr9cCvVtg1IiNRdSh1ACPprnGFcsQ3K1vAMcBHYjKY3jxRJzWYT5y3pTq?=
 =?us-ascii?Q?0jz2oehYsOmPwO0WEQ62rdTMaRhRHFldgwcPbdjRqnoRU2kKx7/4wmoEvO85?=
 =?us-ascii?Q?ZJmq2E3TBCuiEB/a58Wi/D4HC1jfp3ifknuQI58TAWNAYwKKB5PobTMKRtGj?=
 =?us-ascii?Q?H3AO/b4hmD9tSpaoaW+qlGN4x8uWeWqsMTAuK2Es?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66db3745-88aa-4dd4-afa4-08ddf5dc8568
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 11:22:43.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2mmrn5QRrKwgXN02tbVjs7BcaqjluNoegNp0VnAi19MnWBv9AM/RWjDd3DeBCBH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6228
X-Stat-Signature: tn67d4uco7xfe15bjuhse4zxutgaoypj
X-Rspam-User: 
X-Rspamd-Queue-Id: E3406180010
X-Rspamd-Server: rspam10
X-HE-Tag: 1758108166-699650
X-HE-Meta: U2FsdGVkX1+gfslus/7nXha4aO2Ps7TpZf/2eY392BnOO18aZsxYWSPQnJyX50LU1dniFJoBztrfaExVL3tTaQJZi6ZhKMpctM744asILb2+gxJy3BtJcMHZGvg5YXZO7tL6hU+0Y8fMy2gV306RWnXDU4UIeutRKn9vdVsHrF7OB1c7TqyXBvD3M+tTUanKBY6zW6Deb3yxd9EqM0ItXMmYZS44YvTz8MOtNi8PPFwNchJuwRT7CtN+4qztFBJ+DlYqk8C7jlokBjkIze2busfpm25Reu9Ijd0JabBV+ZcTIakmrn/zLk9K/Eh8vTsurof55BxThA0BeNAOX8nTYEorv6UluqLnp5KHx6KjDMIRNoBCxFDnBBzzx05Clj7q4CG08HORK5jOOJsT+emivotJ6M/08hco19U4DQp+RY1EbxlFQbWHWFsk0ufgG0vWBHBx4QXWHttvqvA8kmH1hIPyKtpaG98fyGNnjKDMe5InvjR2VvgDrwX7rmvBeo6J8+yoTOlJ0IzRWo0Fi0byklTf1h8pR7MwsTbOJijg9QsunLGj8yfOC5rA1swdXc0gtEQqG6z4R+r+wQlVR3EIHA/V0GN57rBWGOa63dXPf2onoNbqiYi3amiVQeiFaS0i/cWtZhdSjMQBerrRFkW9X1KW4nx/JnkTv7sxh56GSf8QVisqvW39bjh/+idWnWiBHuVlIo2EFznnROtzmIAp4C32fs/hKaFUATlmp5wCqY4Y+rYmBKjAC0r0+DWwniFDKOsTb+BalS5eihuKs0V9vYDO11qLBIkF9uBlnreD3/J8xyr1wSbl1eUWEkG3q9GPs8F9g99It5Jvhr7/tYHR0odNgXlDymjoPJ/6+/BYMaaqiBNdbWNVsToR7AMAkjN2YTBDalHzqwyJFyZZ6XsdpY3jtxhwTng6g9HmTgVbZkOrUKDVmX+0wayCRck79KHDEsOWviTf6xpMn/AH9tT
 qVbyoNca
 Dpkl/NZuv+1AWPfXhhevPM1rtCFZ1dXYpaEsbrO13l102B7XBoedEdxHXRi9IjcpqMPPExBqeha7z2Dt26zmB783K/jv5Tz3TDuo/s4I6yApB4vhlipXB8qbTquAZp4t4aG7u6V2Cx7fKScpvil+gwkt3l9y9HPo6HoaB1WcOjvHe5Ftl90IwITSygITOZudoDljeB992jjEQgC8pWQtA4bYC+B2xcy58teOX0Wm2jceuSiS+b9AnUxIrJq9uIllVm4WSacCvp6QqhWlDfe7Ou6ogLrUUHHwr7/aU+8X/Sle/i1FQcDV/99NM1q0enca4rvu/YcfnxyJJtphepl40hSVub9QB0W18Mhwn/R2xAk7zf5vxojmZgICb1ZYb34YqglM3TDCC7LNko+oUrXXWVnJxNWR+7UmtQlJQ5oWd33JFnniLGIqC98oRUCoX8taZC6wzl5Pne/hUxst7SgkXcBLX1scxxVeFw7Nc4dOnMZrL+8M9Fn8IJSlNTG51SvVf95OygJBTtN7iwPGJhViIUJj693YYolcYBvwnoUydszYFVbKiA4nj/TorvdvgsAPQPxdrJslPkPZzqklIXSMlTDN2iUeGmtBsVIi/Y+fE809PuLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 09:37:36AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> kmsan_handle_dma_sg() has call to kmsan_handle_dma() function which was
> missed during conversion to physical addresses. Update that caller too
> and fix the following compilation error:
> 
> mm/kmsan/hooks.c:372:6: error: too many arguments to function call, expected 3, have 4
>   371 |                 kmsan_handle_dma(sg_page(item), item->offset, item->length,
>       |                 ~~~~~~~~~~~~~~~~
>   372 |                                  dir);
>       |                                  ^~~
> mm/kmsan/hooks.c:362:19: note: 'kmsan_handle_dma' declared here
>   362 | EXPORT_SYMBOL_GPL(kmsan_handle_dma);
> 
> Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical addresses")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202509170638.AMGNCMEE-lkp@intel.com/
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  mm/kmsan/hooks.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

