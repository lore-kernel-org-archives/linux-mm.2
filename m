Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09EB3C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A6B6B008A; Wed, 14 Oct 2026 16:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A622E6B0099; Wed, 14 Oct 2026 16:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A216B009B; Wed, 14 Oct 2026 16:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66BBB6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:35:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F25E816039D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:35:08 +0000 (UTC)
X-FDA: 85322386296.12.CD4D326
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010003.outbound.protection.outlook.com [52.101.46.3])
	by imf26.hostedemail.com (Postfix) with ESMTP id ECA54140007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:35:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gWVNQILF;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792010106;
	b=uOOnPq2AlM9yQj7skloQzLTVaTo57f33cYNsA8X0htLpPFLgl6kbmZ4yWLoOpIMxOqwR43
	P49xS3vRncSjuTBzG8DjvQr6Bp6dPxqmCCHANX6gJ4pb+UcBwWDmGVsxW0pUTDNwGe7u9i
	jwnYIVT1i0hwQwHz+yITVaZBvnBo4XM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gWVNQILF;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792010106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Fn+T4t70U3+FTaJEoLizrkBkKjb2GSDSp4wQ8au4Yk=;
	b=fpLYJXhemETtcy7JfpetRFxlNdYkpay4YY6s2fdPysgN2sEgaTBT1UpJ66GTixI7hH/FF+
	Qe/hNBm7wXDGwUdO0ZUrAtmIc2Phfci8ltduLdRMV+238j0mKls/pwmZRlk0ltRvWNxyvX
	L+5OcQIFadrxpyuTP+IufRYG0HvFxWU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WJHyw1o6hflM9mk1wkEYOuk849gERaw4Re/yyuq5JGJYrTyx3RI4xRPtyjzs4upyPzx0H2bT1Evq4x8dOOom4Xq9KtYOJhlGeZuWudzyeSWMbhKd9fmyisQ9XT+Y/SHWnvOBCNVTGalTlplYsSqgA+NEv9pjFhVqQPLSTaOqK8WSFulD2x+maBeTjfoFrzJii7FMtyFGsnoAh/i6E//W5h51lETj2AUiLaBFp8yH7/JdsP9pHmyGQJBMjt/30b8Jon8Yv/WTTkcLdWh5zwHVThy72QBSIkharWZXt0B3hEmMvVmLgzo+7o11QGusGV5oebhg6/ohnF/lba47PF0GDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Fn+T4t70U3+FTaJEoLizrkBkKjb2GSDSp4wQ8au4Yk=;
 b=inl0xAEXINRz17hFQbnvTXr5x97R0eIYjzWPDMQRJtg9CKQY/lCwa3MIyb2BOsFHJ1/7NS5E2VK+agipE/PzV0Sf/1gChHrO5FwrvMW3b8uGnm0H8NxhTckKXT/qdSF23krvXtQViULpbUAPfQ8cssxx/HF02yAUQsDZdy0HAr7He0/O1LnVJ18bQRBjs1mxBJbmqeLa8zQ4M+vxgGrg2fYvlx2cok+QQLrMgr15bMpGlFYEuEjohfXdzp6846g4/9e4HIOWL2I/Ra7+cqdpIHIkpc3O/DdjuM8M6u1Ja4fpJy0qEiWPsgqNfjRMykmFzWbhhma+wsJmNTu4GL08qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Fn+T4t70U3+FTaJEoLizrkBkKjb2GSDSp4wQ8au4Yk=;
 b=gWVNQILFLVdxoA5YnkpyoE/qxYknOGdzBnzyvT42mSxfIniROdFYUrI9i3sQecqlyE8+4RLz3dfcAuSzcLha031vmk5lcotRKH95yLiE49qPzYr8lkxo9M8SEIMDWRE9YMkE8F7qyIgIJ7gQ4jA1zbVmxdatjyzrvMnNvbaokxtKVwKdIAvN6ix5QnITtAkikzFpzerpQQtddcMKSNYoIQ4PFWjiOauTy0Io2AJqjY11acNqI3bp9x4FmOZzLvL+a9+5tDKv38NvGSt9dNOaNVfyjK2YFt19kvwYHfmF1LbKNDSq4gcY70IndGSKRnFZFKEZpA5h6JrdsK+pnCB5WQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Wed, 14 Oct
 2026 20:35:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Wed, 14 Oct 2026
 20:35:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Date: Wed, 14 Oct 2026 16:34:56 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <DA36D13E-4E84-4F1F-A44B-B78A440BD80F@nvidia.com>
In-Reply-To: <20261014140859.1006967-1-noren@nvidia.com>
References: <20261014140859.1006967-1-noren@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: SA0PR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:806:d0::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9723:EE_
X-MS-Office365-Filtering-Correlation-Id: d0742dfe-0f42-4149-0d3e-08df2a329eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|6133799003|10067099003|18002099003|22082099003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	G7YnuYiQwVfOunu6MVFEkrvIeWZTD3/OR5sLuaMggvjD01EYX2ZKOawjSZNWzqH00d2pSTkhrHjL1khmhCdzdd7DmwpfaAOZaj2qsF6PPwgWqKZBdbs6HDMn1xeAF72J6nFYbu2vilKJDZwFZjUVu6ykbuhCE4u2vSWf9NA4X+SSFJnx7oTzzRTm2fJC+XMieSrllHL3jcnmycDKzvfofTmbLh+oC6ZJ8cl85pXtsbRAteeQrMEbkD2fCCQpDehdI/YLcX78IZ5HMMJHZvizpmyRerXy1eMyu76yMynvOqhd/K7qj81tSMARO6LcHcMLvJGgyKUZHgus/pXOG1ijhh0s+eGj35y03XulZlrK7sF3+SJA1mA4iNXZWtBUJkZ3Tcw8gsQ2+AZhZmWfEpf8bbfHFlXgjS5yT8x909Ntb5PumGdypSxEjXmO80MZFCURyG/6Ivgkglc8CpAZ1J3AuEyeJTmreX++3cKZxepqCgKe4UrOdbBg4s0XLWdxOpKw3uyzjDHZTaGoqN8DRG2eJu9OmQ7rBIIS0n3wtD+JEwFkPvvyV+izRkcpKLHYG89DB6fAes4yc390XVPWk+4lXLwytc16BB0KhvulcOmwyXzptseMSK956nZjscB9t/LBJ2XVqmCqaCEgnTB2lqvVlnL9g/sZFaoSPVF2NL5VYKs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LHiRH8xTWSKMYBvCc/oKtgmeBYKXHBJPnBd2oBv1vkRHNZJOe3ybIdnBXzi6?=
 =?us-ascii?Q?7vNcLfKIoic7SjvY2bKMuXEktG+y7TuSIqVfKvNB0K9duPx2xPJ1LLkab7uB?=
 =?us-ascii?Q?Iqby07QfSY59ObhGICKoTWPogSWLSzVAKi9icUkdzifa0BXjSluuecgXl+fv?=
 =?us-ascii?Q?vMZ55lTzAivOM+UUhqUKGChZB9K3NVxEmI/ji+O+AFQoPU0W49eCuukphiFT?=
 =?us-ascii?Q?xyCSfkyjHvTRrHqYTWnzyVUbUlrbMaGWPo4m1nENhNOn63OKc82c3TEok1Ue?=
 =?us-ascii?Q?fPTjGpouxsqKPATRc3J6JdQikMbEKPw4QjNUo1hIhEyTwq4f6LQHMVmIrjUw?=
 =?us-ascii?Q?jvrrFwEqqd3vmQGNXuhxMN/8toLgGLXFxrKNFUlNYRLab9bkJw4cH2RBsh3g?=
 =?us-ascii?Q?qhBMjCkBwQaM1e3KV3Rxj4V+6KgGjcLAsgCYoxHmHDjxeBtzNSCDtBvRIETd?=
 =?us-ascii?Q?5gyrrMXCDkQiQQBfcGDCG93SxwevwH/AopOa5uYmsgpdK/18m8JrMqQZjtjK?=
 =?us-ascii?Q?pcpm0EZ+3sgNHEvEos2kSzcUZZiJqAlG2uOpyJh63nFjEEKvvCEj7H9q99Kn?=
 =?us-ascii?Q?I3VjMALOR1gXR7xwUZF0qHqmoRpD9nRFndYE3wLaJW6+Be8ihiVM3+jpjVGV?=
 =?us-ascii?Q?8n1Yqg/pweOQhrDbZeECQyIZ22Vp6YI3oRcF96uIyUGyF3WLTS4feRYyDSes?=
 =?us-ascii?Q?iYYGtLv4oFH3WjBbnMaaLANArtti3uQ8p7dogQ83/pKJw8bRno5C8qWEdaD+?=
 =?us-ascii?Q?kHgQqhefL9qL64+heZTDUvYb7kJOSmQP3LlNoQJhBlLwXE1ND+zGpwwEfKql?=
 =?us-ascii?Q?WlFP6qDGOnOEp6d7E49iRQVUv61uy+aSVMmFMG2GPAb5p9l/WSXkUpIR908H?=
 =?us-ascii?Q?P3uIVxcyDjxzBKqV7ZZIkhMwti/m5A+RGYDWFfVnHigNm3t8oGBT/FbwViix?=
 =?us-ascii?Q?EE/mtllfxc5kpNZyLX3qOpNFEjwVNwr9+wr8hv8WV/IAfjyaMGAg7Us0+Yvw?=
 =?us-ascii?Q?lmR4nzJuyHgPWyq6p5+ypJatbz2kNA07XEjC7T14rFzz9mb3dqAaHcNKmHAT?=
 =?us-ascii?Q?R/zM822kJlGtEB13aVjPYR+wo7qwa5MGnReHCEzQcfqEM1xZ6AopVKCOi3vL?=
 =?us-ascii?Q?USsHwaiiQGwWfKUi/o+i0NPMcxDaIJvcs0zZ6rfXbxpBhPDiHX+fJ+n0hv7D?=
 =?us-ascii?Q?fjacxeYBKpvLG+rMgjLFh/riA4wexoLmsYwXV5jNv9Bm2mEc7nyYXhW4xWIZ?=
 =?us-ascii?Q?JVtm/ujE2iKNJCuef+hZqTFZ3PWUn7ZIZaR/KPcTF9JYg1PnJMw6oRS1DOjr?=
 =?us-ascii?Q?u5/ubcEYQTKXFlUxOigiPCIsDfFyS7Sfu4Lt665D68TnPX5buzXFMdgMpzuh?=
 =?us-ascii?Q?NDyvI9rrBzdyXwTm4r/Ft+Gbx5EVPm2ddkn/mPHpLye3HmbMUslAR2wDnEdP?=
 =?us-ascii?Q?5d0PTK4tEUMka2CB7KfK5Au3lQtVtJyX1a6Pewj/lrXk2nT9MiBucm2DOqWz?=
 =?us-ascii?Q?KtQDBPhZL01kC9Mfby+36yNCoa0yWYGlPmR9FW3UXeAHJp7KqL9fMImOpI8Z?=
 =?us-ascii?Q?Lr0JSQyU7GWBsWgG0WytT/LfyFBzlFOFBDGueEaEi/43INZk1QilMCWcccKo?=
 =?us-ascii?Q?S03ZafZ/PBL0XBKc/o8Ws90meJeXKjcmOSGHX1e3P0VoqB/p1kZ+nbbU2Ul3?=
 =?us-ascii?Q?+TN0FfNxKmZU0MIudDab0ycVvmJHHtuoQFtI1zeykDZro4wi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0742dfe-0f42-4149-0d3e-08df2a329eb7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 20:35:01.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Il0gHHonPeYwwooKpwhFu5og4uduNTvIs6IOyn19cbRWrOcrXqFB8UyfUNs7yIEf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECA54140007
X-Rspam-User: 
X-Stat-Signature: 8t7qy9o1qmgxzk8ji77qpy5j7wxkhx8g
X-HE-Tag: 1792010105-982830
X-HE-Meta: U2FsdGVkX1/wZRLGXe6YJZKMO+DemXelJ4LbJ/d6wfDgj0A9FQdgjftPhfC889ETl0/GrWHgCwN6yOsSvMyRX8azwdb5sCDl9Db8sfxH0zfghNK2WtmtmyYGUOXzkmBmhehlB5AD8SDLQbLhHS0en7hKLXSMRCcRPpmJfRk5fwAp8+aLKunRMIIP3bgipUfzTTWzPNGG8+F26x9yK5ypaD2ENm2W4/YL9Tu/KeRs5esq68kKJKRQMO8ElGrBaKYCudJ12hyARA882UArkCR0h3zBpVTf1XHkeKzA8UMZENkQTcXoSqWb6gzE5w+GjfZrf/9glW5SlK7Cq/odbh7FCuVC4X8OSQFOk2D2gLSjIMe0tlHWUpfmSgHQEPPEya3BOQimuULTj1WjVs5JafBSfkQoCQzqmV7pmUoySA3AXGjX74oML+srd3Y9waUnXqybyfFukGGr0cWgTIF0buLzQPt0lxD8fjEHe2595vwwcxR8Q7ua8iaKnh6jgvPEq08IQX/ie1QkWwP7tGrzCYn18EU+XpWMrxrcuQIBK6sl9dfr3Dm9O1gXTKJ/8tPdCNgpjNhLATJiYftVDRhw5B5v5IwSJF4bZlIZfDpLbtIWb3DBT6uDHivXra3vY8NajyJb5Qume1uFsunAIUlSa+znHoA+ghtMTxjLnonQcysPFdnIVgDtmmG5edaLVOY07U/ttAT/Gr4xhf1uRkWqklUaxyGySCdZQ5L3MXDgmKs4KzHQsilvwDojJ3WCVbKN1vZ/zoTcVW1l9xbZlxfcsAmBNAIxxoqeDlJD8/dQCw8Lf+feDyrnW5QQOExF8lXAs6zjIjiE8gXY7TaQRKp1TV9M1QpXzXwTmlIyakg4+XcpVHI7UhwBjLWAf7o5NmmEgxrJ85pszu3zqcTKBtNTBTQyFLMroHk/U+6ChRb9g5JBYxksPCBlZSh1sOVDIMEKdhcGdAWP5Yf8647L0td+2Nn
 bD7wqIli
 153chdYO7w+cZM1N8G5Pu7ySAo8e/xc5OzBzIGGaKIVPgvNXjOWrqFnRFpc4SOMjEhEksLahOVceVRR4yHB6YMr7ud61iJnCoUiMEbx58ZgT5b55QdDAkebR+ZSeIW/EZfiOX6XOTcv3zUnvx8U94Qa06XMhN7/RSK+GysRzOAuee4bT9gWykVOHtWC89/krKAfa1cLWwxHsJ+2TPExmuixXYE5Uvfp8hPiTSHJ18CbiTatMxnuoUrfWohhFbMRP10SYdGrfrTwVvu/Wv+TdB61SooYJt9Hpg+xr1CEShN4ND4FAaNgDKVbKHY6bGCAsb5JBkbuUYdqnds1ImkNKkZoyfpTP10XYu7nbsNQ/Coc0e8eOJmfuCsbB7tysuP9W+jiyVN5y9HJ0svtwc5694fD1jR2YJ1QMQlUeZNzEfLHxA3bMOQhYBALmGDZJVCn/2v8kPlQh2NE8P7opb/jV0yzOXJFkpgCStAYK1wgsVDIHd3lqoNA673rZwhg5G7lhInFEzVmRryDIzpZ1DlAKQuitvkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Oct 2026, at 10:08, Nimrod Oren wrote:

> min_free_kbytes is recalculated on memory hotplug and on THP sysfs
> writes. The new value comes from calculate_min_free_kbytes() or, while
> THP is enabled, from set_recommended_min_free_kbytes(). A value written=

> to the vm.min_free_kbytes sysctl is replaced whenever the new value is
> higher, so a lower value does not stick. This matters most when THP is
> enabled on configurations with large pageblocks, where the new value
> can be excessive [1].
>
> Stop recalculating min_free_kbytes once a value has been written to the=

> sysctl. Systems where the sysctl is never written keep the current
> behavior.
>
> Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.co=
m/ [1]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@ke=
rnel.org/
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 7 +++++++
>  mm/khugepaged.c                         | 7 +------
>  mm/page_alloc.c                         | 6 +-----
>  3 files changed, 9 insertions(+), 11 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

