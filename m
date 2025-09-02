Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6631CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 05:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B728E0008; Tue,  2 Sep 2025 01:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2FE8E0001; Tue,  2 Sep 2025 01:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F94C8E0008; Tue,  2 Sep 2025 01:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0068A8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:14:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB0AA1DEFB6
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:14:41 +0000 (UTC)
X-FDA: 83843145162.26.43C7BDE
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	by imf25.hostedemail.com (Postfix) with ESMTP id 359DAA0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:14:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ct8li36A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756790079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCF7kpp39I2cTSws0r4Ejm4JuSWAc4RhFQxU/G8GOIE=;
	b=xZ2COav982KTEn2qN6yFz1c7tiY77vld0uQleTYmRBJGZmPVaibmuptQ+Lc8kFD3m3Bo/3
	1TJMN76DDZPNFd16miyg0VThMP9YrfrjtdVeL2gQvnccfS+XhFm9OQ76/do6V94SBpO9Ft
	9nT/c6GEZDlw/wVB3fRbrWhboepx/wM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ct8li36A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 40.107.236.89 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756790079; a=rsa-sha256;
	cv=pass;
	b=ksncSQ4BwlcNJBmBrYMPr1GLar1rEvs/P/EoJW4SWv3bGEcTPkAVdeRI6OyWdZ8mgWJatQ
	/22tzVIZaMzNBgGibj9xL3GlIXIbaaL9yN3OBX5TzZqFs9VfxYRUhHo53Suv/EvXYNmVTd
	I6+M2rPQNc1c8TBFMDOHno5OsQNj6rw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Auh5WPSRaSOwFTwNiH7iYCeADfilIZNbAthXwJOqbHsUo97UBGCKjVpell/wXJkMGEPFK3GtLT/3ymBCe5o4EhtRe0IKdEh23yUEGivziP/LfUBBq28nxHSkn57/9miOeaFe/NRHMygZt6r++9dmO+PqnkiZUrGKs3Zk3OtWHsLaf/UAna9+kRZdaYIH856xMqiIVN4ZxSxsKg9TTZ84llsq4v572cdBNeiqmkMBiGULWKRphCX4NYnMvDPaHmBG8aMoiLa9nW/2hOyRKfOpN7e4cp/8O3+aeou8kNjnaTqxPC310DolxZduAYIHTRFhPOuaZWULA04l1438C4ICLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCF7kpp39I2cTSws0r4Ejm4JuSWAc4RhFQxU/G8GOIE=;
 b=DLcLyLrBc7DRYC6rVML1KoR05m9+JbeH0BOb6ax/qhNfjWTDDdZ7phKqgyggJQNy6tqhGi1tALBEMQCBpg0lD+z+DOdwvjP1I/1Jhe10f0ed/un9pXc43xllfQgCmaVkS8zWk1zg4H9d+T1Y2aEYsX0TMezyYLlYrzUeaGI2+L/UER4afSNFRg9a6MvzZOvjiFPAQB+o3L/UrAYVWJy/vf9fW2igYHlsop5vtYUBI04NtfZwzptm1DjRrUn0sA+tGeWsiKDk2AA/bVT+2LpPh3P/bcX6UrvQg+uGCtRL6ufpXVCYq60sOCZHLG7/8hZIlFDwyWJfPlTQGd5HRPsDzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCF7kpp39I2cTSws0r4Ejm4JuSWAc4RhFQxU/G8GOIE=;
 b=ct8li36ArrCkOIJXkjah1wervtgghDapMH3yHO3DGB+S4OvN7GQuMOc8occcXFjAqRwqkfpy1I77rUwrnySZXkhNOoaeo55w5CgBM40WUU8bt/blmyVeQKfj5ll6RSIRvsPlRxW+t8H0ofA79IX7jl0o9mlEBN2pPFnVaPNTYyCw35R+AsCm1fEMisZxku3CzNO6fuavNXpvxYpvineKe66LHuOJs0qx+rRIvW8h/oanFRUD8ZKYl8BcDYn5O0/8tXNjtfd4xkIg0P9NEluLiNmkl6G1+eImZRw5CHV/nBIFFJ0IF0HyvZ2yz0iIwo20SWAB8kP6IoIvoSyzy+xT7w==
Received: from CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9)
 by LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 05:14:36 +0000
Received: from CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6]) by CY8PR12MB7705.namprd12.prod.outlook.com
 ([fe80::4b06:5351:3db4:95f6%7]) with mapi id 15.20.9009.017; Tue, 2 Sep 2025
 05:14:36 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH 2/2] mm/memremap: Remove unused get_dev_pagemap() parameter
Date: Tue,  2 Sep 2025 15:14:21 +1000
Message-ID: <20250902051421.162498-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250902051421.162498-1-apopple@nvidia.com>
References: <20250902051421.162498-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0180.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::29) To CY8PR12MB7705.namprd12.prod.outlook.com
 (2603:10b6:930:84::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7705:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: f87658a4-0751-40c7-3acf-08dde9df9c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ovKpY/tXUzX1XP8KZteecikUX/90Nj3aNcOMKwNdyq05CXV5r2eqTQ0OgxXP?=
 =?us-ascii?Q?8mb0JDptlhZPx8nPq22w9NLdWzH9cKu8KkYsJZVDGYAN98uw/03iSoakD1vz?=
 =?us-ascii?Q?z92bdIgxoYHI28cqh6P8plhp9TOXYvSWlVv6senYfZp1i87cYszkkbzbft9G?=
 =?us-ascii?Q?swk2NCJpBQCl9iHeW8JgAv70dAkySmwNK7/+SC4YiCxiEKLOAMw//cZtuY4+?=
 =?us-ascii?Q?WzZxEsIMpbToTUhaS3R3x1Hy8aOwxj2uTQiHa206uo704VDD24+opL1nbJad?=
 =?us-ascii?Q?dtWoaeWg1Zb4GjyqEytSndbWsFfLzT8OF6Vr/lTIhnwTw5GPX0EuSgZpaq4p?=
 =?us-ascii?Q?7JB77m/rPBHaoXgdpd7xBTT4IPXtT5yV37fCaclfNqLjdpy/khhxpW0SRS5y?=
 =?us-ascii?Q?8q3MnxUIc0jvC3RmI/jw3gmB1mfOXe5tdGCi+Oy2xrZfU4v9ELnkU+3J2uzV?=
 =?us-ascii?Q?tsvIKNwzJviTPfu1jHIxxbIslznSCMCtbnKfWBZSttbSNQ3F5Y2PJ9SnOjN4?=
 =?us-ascii?Q?ZMfw4+gCWzsmNSX/UlAEB7YDwriX3Oqzqgk7Q1wwwP0JSM6Zc0uBDu2xcDIT?=
 =?us-ascii?Q?oN6cQz9/k/868dskJYIi/SjFjDHLmjH57TCSedmrpfzgGiOHi/P5VvElK8Nz?=
 =?us-ascii?Q?0zodxFR/tTJ3jSHD6HOCJvcz6038ttlM98HvYDEZl9oVt78Wo3LUzeanNoOC?=
 =?us-ascii?Q?MaAl35PZnTevXZc73zU0q/sPts7HbJW/XuYfcAs/+vVbKJubMZp+PCkR/Ji5?=
 =?us-ascii?Q?7EO/OEQkwnEEwGrSTqwldrfd4//YLOBPIzPx4W0Bbhudve6P2aPIdnwtJdq6?=
 =?us-ascii?Q?jElE98MgiwTiiudeKwwkZI6pVl2cfJ21IB0h3cijtDaiv7Rc5Yrd8czGXOVS?=
 =?us-ascii?Q?KJ5fDctl0wa17VHEqVtgJzeT3fnWCY6aoMCcuo71qGpZO/viN4SVRbe9Vz6A?=
 =?us-ascii?Q?NQv9O/JpU4qcXZqhHTfsUifeW6UKqdyMdhbMP1XSIgPRfpagBEn4oAIeCmr5?=
 =?us-ascii?Q?pAqKG11hrabZA1FT0gfwgorQn8DP0SDyh3tp/xyBgGpXk7COCd6mo2NIqdJ3?=
 =?us-ascii?Q?QfR2x+9MRIl/PWrPRI0kOyAqPOOn2dlNm9AX7scPcROp2L0TqJBW6Zx9lK4L?=
 =?us-ascii?Q?2Rv1ofqz9g8c2Ay+pqBlxrMAR1BS6bRoXHjXdOT/Rei4jlLRMdF2aEjngifN?=
 =?us-ascii?Q?3Q/mC897vNrmN/xIgKhV2EHkJuDahIl27p6/JX3qNNd6s7rUy981XXMX6YYU?=
 =?us-ascii?Q?3GqDwloczXKqF6pWm9R+aVqtATDvSgYQyh6lGsymnJgrMxctKPwYZArpJkQg?=
 =?us-ascii?Q?44DdFP5hJF8d9Lgm8jg3PZ+Of4iUIAtqDd3SsOcR9HPab5b+2OuN7VEEpGz1?=
 =?us-ascii?Q?ZM797d1InR5MsdHKgjyglbcQOS1fwxXCCiK1mcTpAtjhd/AujTrv/vGTC5lH?=
 =?us-ascii?Q?SaV/uIIUFy8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7705.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rBFh9eUvuzZergQoUxPP+KYQeDvtGPxDrb2iFCYZdItk5lSHAt7Blj0r2y3o?=
 =?us-ascii?Q?3QScHoH+W/qcrxoKvp80eyjSBC5hJ27Y09S4KKPtzE30zCsOd7os+GlPtYoh?=
 =?us-ascii?Q?epQfkK+5ZPmcsU4nITDJPCSz1/QZzhJffKCqRXfW1Wx2rH6qLuIGYLgSqqKo?=
 =?us-ascii?Q?b4RocASZg5HC1b3/miQ6zLa2Zo5bgzI40g03iNWY1FUj0lkzHOOZu5s29k5Z?=
 =?us-ascii?Q?8Hcm+UiJ93n9OE7+hppG/jKi3MNUsZfluHs+E9K5S91negIwlKIPUyg5bbSp?=
 =?us-ascii?Q?VWNT/pfQF/WDix+AStGkjUdOuxM62MUK5E/9dN5hpQZpSpgkUEhNO6030fGv?=
 =?us-ascii?Q?9arMY2QT7cwamifkcQbSqYjXLTqiML8+HrO4erZuBiDCUaI1zWriioGWeYxB?=
 =?us-ascii?Q?7T7HER1KKhUlXCvEvzp4HLa6EVfSSj9kkG9bVlx4vAWei5Q7XfSwO0ubBVDS?=
 =?us-ascii?Q?+j4PEkjL9Fhfc3ka8THW0J2N7vEzv2bHbTuej3a20G0OZByenqPVQfUeiQtb?=
 =?us-ascii?Q?bbQYW7PIsvKcE96BkWk8W5ODmt2sRMn7gXIJJvRsnxy79W/+RfYOc8YCukvU?=
 =?us-ascii?Q?rFnEnw1KBAjpgT41TClz2JjPRjsRlZZYoEQzyhJnvgiwQ77ylDhYiSHE60Bc?=
 =?us-ascii?Q?zJx5Oxp6x6rwhzGsNLozpP3YeOGjr7UMjZzNVsBtvRVVLE8+1sALEBiZEPS0?=
 =?us-ascii?Q?B7z3N3Nlh9zrphthA95GLth34DTSlOKaENIAiB1Ysn2kqFF1322NuJ/P+IMk?=
 =?us-ascii?Q?ZpZmgxlKPds+H0tgA0zYfNjyXuh2+X1k9yNR9Yrbn41XTugs2hQqY73KFSo7?=
 =?us-ascii?Q?9KNXyNRVduh2TthRs8piwj7guoHg3OlIWvHgZpA/vpF6BOMGb5LgvW4ftAD8?=
 =?us-ascii?Q?+g/QSX8hd8Js/uahcgeVAihFtBpoOn/g6xB3jwu70NROXRX7GmwoqnyL9Lnx?=
 =?us-ascii?Q?62xeGuN/ZHOlitg4VI3O3cEnSC+o7CYBO3He1lau4vH7FCd7zS9ccJ2R4Gt+?=
 =?us-ascii?Q?+MG5HjQXSoKepvcMSeGwnEmdWFnV+d9pdRKF2gwzTKpQ+PdfBn72aX4lJQo/?=
 =?us-ascii?Q?9J92h3Nhg1c1CSYnz75A7cv5gGXdf7BThPV/04Rhbl6wDqHNIa/82U3ssh0A?=
 =?us-ascii?Q?SAHZo+R5Z5qNwEFRdJvOuFvPecTU2Jruh9CIKn1Vbn1Os+SYKXWt41Khkc0X?=
 =?us-ascii?Q?kqs84YgggO6ywmCiffbt61RRjWjWfy58Pqdsg07L80Tuwhlo6pS5JE3W+yZi?=
 =?us-ascii?Q?eJ8uFtdyz67yi53bY4mklnXv07V4VqIxaud5IYka3XxisEH87BPZfUD7Kv7p?=
 =?us-ascii?Q?5NNlkZX7RJD/uRAZTHL77taQYYXInk/uuuxLmucpAi9nHAPOZ8rcJsvKSJTA?=
 =?us-ascii?Q?NO9JQ1FkjXdRhkzhuzZW2Bx+VEY8Ha2qMwlENNmAaxVV9/x+EoXpaHrfeEv7?=
 =?us-ascii?Q?HS57CMCsZYMHw6BKUVVzJEnRT7/X5StUc/Zq2ieBVGySA1ZxOXU3ds/kVETx?=
 =?us-ascii?Q?lTjZ1E7N9KejF7ReE91kWJRpDpiCMGVIoy4EWqc4lUNgDcrEV5uoQK6MS2h3?=
 =?us-ascii?Q?GxPiktxv91w5HbDLCnT2VUznMYbZk7mqtDXanizg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87658a4-0751-40c7-3acf-08dde9df9c3c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7705.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 05:14:36.7676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uudbv06vQtpw2AucAVNK1XMnFqk/x4QWAYl2pTBP6UF2P8fSMjKiLmg6Un7HYO32XbV7p6z5wvCC3UZWNWSiFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 359DAA0009
X-Stat-Signature: bqxrfwjhot53ten4g8fotua7x6ocxcff
X-Rspam-User: 
X-HE-Tag: 1756790079-451784
X-HE-Meta: U2FsdGVkX19bVxrWnY7I+Cyzz6Mkv6+b+akkQi05XD3DQ4eTheDEaaTVQIntJ3JE+LU3YiYwIqFQdgPJXrPJTE77XduFIT4R4Jx0UENkipmOakvbW9nFyH5E94uXbysMzQzzJ5wd551gTWalxvRd+IpvnxyG5m30BgnwskBX1SSqeK8xiBJCgS+4MnS7gECWRXD7vDevpFR6IK3mPVWjhAOVMHsNGgpr+dLlmfP+VpRvJTZg5RzXpn1y95CV3Ry6FTkqpm5vlmxjl6UPW1QPKHnxkSre7BktLP3Pu7iOyGcSoE++iZFayUlvdERKnWZj1pCR88rMDyCfC/zn5NQ7RDbr5nM+VXLoDI9BukTBXyvAONFTWFuIhVYi6MChGV84E8+6pPr12bq3tx2oC5bbL2epDw7fPFLMbfzdsDt4zwfow43XFyUQrkv76XW0wWf71BV03KmEkK/ApvXT0HOF61dmfdiMBYlNXxo6M3ne8+8ePaW3Y5NmlRFbvpkYlQ/b0Idtvi1+XeXe5oG+pFRdHF4QJ2fWlBGBbfz+irEFcj/cUwkUh6LELwhg60ROTuD0VoftSNSJNye4zGArrzPa2zkmZdI2upLaR9QXNci1Re4EGwnlMMhEzVFTsipRw7/7SbkBqBggaoqsWfcK883NvmLGyRVQfLwZ6vBX35sSDegKpFN+fdhjDLdgvyWanc0o6JGH5OE/J0A5FbeDLYxotGImeinGQz/61izV0EXv+iiRHO9dm8iunBw0vO6CGMSRYrmpdtqOyDZuIwAj9Q+oSKqHw5Q5CnraZI0kUMRkpd3B9tPrREDhnOqzOJ5lhhboVVpb8J9fYHCYlQWG2ZZ3EW+pWVJA7RlFaKU5tiiacGuu1Ve3PqShEap0Fafj7aldnyIsNrsKWyLmUXf7PvKDGSa5INWbjokestmF0fM6yxgbWwqj9+/E+KhWzsMeNNBDu+IXMVOilXjjmAGkyTL
 bGJuxMsg
 OHjl3oy0B+UKszdDQ64hMb6hQ0y6pHJCFUWbtjp2e9hgUHwg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP no longer uses get_dev_pagemap(). As it was the only user of the
get_dev_pagemap() pgmap caching feature it can be removed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/memremap.h |  6 ++----
 mm/memory_hotplug.c      |  2 +-
 mm/memremap.c            | 22 ++++------------------
 3 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4aa151914eabb..5cfc2ae6c98bd 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -204,8 +204,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap);
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
@@ -227,8 +226,7 @@ static inline void devm_memunmap_pages(struct device *dev,
 {
 }
 
-static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
 	return NULL;
 }
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f15af712bc34..14e98c89f5b4d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	 * the section may be 'offline' but 'valid'. Only
 	 * get_dev_pagemap() can determine sub-section online status.
 	 */
-	pgmap = get_dev_pagemap(pfn, NULL);
+	pgmap = get_dev_pagemap(pfn);
 	put_dev_pagemap(pgmap);
 
 	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd8..3b4717cf3a6b2 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -153,14 +153,14 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 				"altmap not supported for multiple ranges\n"))
 		return -EINVAL;
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
 		return -ENOMEM;
 	}
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -394,26 +394,12 @@ EXPORT_SYMBOL_GPL(devm_memunmap_pages);
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
- * @pgmap: optional known pgmap that already has a reference
- *
- * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
- * is non-NULL but does not cover @pfn the reference to it will be released.
  */
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
+	struct dev_pagemap *pgmap;
 	resource_size_t phys = PFN_PHYS(pfn);
 
-	/*
-	 * In the cached case we're already holding a live reference.
-	 */
-	if (pgmap) {
-		if (phys >= pgmap->range.start && phys <= pgmap->range.end)
-			return pgmap;
-		put_dev_pagemap(pgmap);
-	}
-
-	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
 	if (pgmap && !percpu_ref_tryget_live_rcu(&pgmap->ref))
-- 
2.47.2


