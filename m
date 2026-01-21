Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDB3C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732606B00A3; Wed, 21 Jan 2026 11:29:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC656B00B1; Wed, 21 Jan 2026 11:29:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A856B00B2; Wed, 21 Jan 2026 11:29:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45FA66B00A3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:29:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14BA0140769
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:29:52 +0000 (UTC)
X-FDA: 84356507424.20.9CEAD5D
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E1401A0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:29:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="tKB/Fneg";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pU1YqUe9f8EIGbcbqq7X23bD7pzpD1hqONAo+cPhigk=;
	b=W1YH2c3W4S7MnedUud8jRZnWTAQqHtgzn+0sycoxqk1/MKK0fxbdgpZYeBW6/vFIh0oEW5
	UmyXAV1h9kzFR4H/8Qpzhp+P+oaF0bfYLYhv3nGJZWqSFJsOUfxswIHX6G1CZc21/hL+Ys
	A3PkUI12H8mJSKbS/QagrPLFGU9sFpM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="tKB/Fneg";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769012989; a=rsa-sha256;
	cv=pass;
	b=zeWOxFEja/cQlIoYj3AK+HfmvsKGGDRCIwWPC71vyM++OMby+HzmHWR/Wk44ORcyupA2EW
	DeYWzkzNMobtXChhxpDqpndLD+UxgGEPM1ExDH1344JfJV9XOhqf1VpvSrIeDfcvje0XsZ
	wSNCnaGOWM65ZrNZhn3j5uqJr7UZ8NE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPxkNlxq9tWMPC1VJjBIxpPGfwGjm+YFlgEBrizw3KRPmNzVuIjUNQXau2PNnD46SwecTXZ3Cxsx1LWDChKibt1ZfwIPNDiK6RwnjRipfx4PIoGaCz9Fy+SdTFRrSilsg9sAkD8uuimXN1jVnqU31FzaDu0CbkyEWvWAWi1X9ZZx7BfOIY6yoQH3wLRVPpfufH8qK99NesrMCfiL7TrvNdI0Fa2Ldm4c/xwxEuVdFKp/mrisr0tSQVwssy8/2uPLgV1l/Vlo0WXnhWxxtyrSjdkYe0DdyqzXhEdQQ0hveUeaCYSgGITYpbeSbECsELWXFlSiHhTZA0x9Xt+HCDLZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pU1YqUe9f8EIGbcbqq7X23bD7pzpD1hqONAo+cPhigk=;
 b=H0QRg/65taHhuPfWig1cXCt6kGBAIKAQa2Vz7mVTRfWrPSuktVQUlKYx+Ek7YL2NMbes6ErXWqSFFDxp/5vAzRe2fEHtMjddfGX2DpXaGmjzfJRrXzSfPe5Rgi2q4deKACIJuRekqCjC2NWWga5jNmQ2WLDs8WhSD6YG9MdbcvfN822jGAItDhIA9A45jpR+8TGq2bEtiYM+Q8QTx/J3nMl5E+xsJmdzX/Aouf93SwDDy0xwzw+Rhc3LJTa5L6gE4BBYR4G9s4KEJ0yc3t8tfzz4y8i1weqfBUadzwlHH5SAjdbhwiheyfeAcM78aV7NBQn8U1b5S1UsWHsG6HIofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU1YqUe9f8EIGbcbqq7X23bD7pzpD1hqONAo+cPhigk=;
 b=tKB/FnegmjmmDWgPGEXlqrfP1YKdluoQeRcEoBZQE1MXRu6jxDTwytZHa/a0//WAzWZWeRYtSLcy1hq9cEPxZYdtHeVShTYlBErt3W5+a8+7/yGfbh3dz65LvTad9Y/ou8dwmLOLgngLL9n1W51wVIYvklx2vwKc+QkxbfHRfUogTdprSbsLomW2roey8tTzjmAvRP2pDxNUVscXOFqfXkc/msNXrZDhdo8vlgQb0wkKel/zRwy7kgYVDfs6I3U3LDGH4kE/7pjHsW2xVU01bw9E/bsgsHk8FUsMbzJRbJK8yMFGyMI/eeNFkgK83Cc2PObT7uqoQcrGHxaDK7mQDw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7180.namprd12.prod.outlook.com (2603:10b6:806:2a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 16:29:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:29:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 01/14] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Wed, 21 Jan 2026 11:29:39 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <8324F33B-FC2F-4AA4-B492-9C8300BD9219@nvidia.com>
In-Reply-To: <20260121162253.2216580-2-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-2-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:a03:338::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7180:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba7538f-4e75-4456-486a-08de590a49be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RMJp+s0gzYTl8AFmzgp5ip+FOPo5DDsl8hZ3UtYgpmgkzDW/qdeDeLCsUaVJ?=
 =?us-ascii?Q?gv8x16qGpxq3b5r3hJptvB648ZXxAy91QnleVlfFDgkvPJy069zaSVttgZbL?=
 =?us-ascii?Q?cFcn3TSM8/YfjvxsO85IxlmW3esA4OhdsiyNjQ+7LkyJj0ujBIfRG+5uE6zT?=
 =?us-ascii?Q?wDUT83sUb7z2oeuZz3YrypQ3Aq6YYilefXVOqX7CwgrAUgSdzGEa2zGzuZ1t?=
 =?us-ascii?Q?FISm2709cVSeL/EBlp04T+VALfkRwQVKZoi0Te6UU1v6ZhXT1xCPU/iv6aYv?=
 =?us-ascii?Q?hHAb3oOSPDL7oMbWmvfFR5EC9gL9NvoUbzfCu4z/AwbR+J0ylKif4Qd17epU?=
 =?us-ascii?Q?5PgpQLr4ULT8KPTYMnOSWCeP0ylgnj3GiAb95l2rYI6N359fxER68htnyjrq?=
 =?us-ascii?Q?ys4fPN46pjUtFD2pBJli4E/DSaZ5ftWZkhHnE1L23ExB7i08/7DGpIIkq9L7?=
 =?us-ascii?Q?FyVVaYaGNyxY52jRjyM5FX3j4AKerlF7/bi8gGLBvzJq+bHCOmA+5Xng7w84?=
 =?us-ascii?Q?Nuhi4bEuE8k9L0t99gZmsrmghf8fI5LQEs2t5amidSXau4BWd14F6fjEH7Mh?=
 =?us-ascii?Q?UUAkea3eDvylLFsKE49rPQs7De3LgNMwv45a9U7ViALDxlF6VqxxOLku0Sku?=
 =?us-ascii?Q?qkc6E0peSY8dYIhHkk21tW0SoXZgyjJhoCGz+VLuhOd5LIZC65Z1SNPA8sHN?=
 =?us-ascii?Q?aTwOh+Y8rR7nzdxbU4bV7D4IW+DzQ5qt7aG7txlJs937BQG/5NWa7akquK8Q?=
 =?us-ascii?Q?xWCA3hqGeFsPAnmKj1u8+czRl4YuLbIEcLi74jn6KZZwPXG+sMO5Nhrqgd2U?=
 =?us-ascii?Q?Q/YlyvdZsGbJrXSDVfXz5hOFJn/U7w40DtdwuXY30Bx/BvtGK+pEKtdMMxvU?=
 =?us-ascii?Q?kYZHefAJATE8H8fEN9Lmru6M/c1p/PLXIROU5Onb4XZM2oYxNHotpJkNL3Ml?=
 =?us-ascii?Q?nzt2YU70yzi4Td6eNLePsV2uAYbVxQpi6RCTs7q2Oq92r9/SFFDGdEqb9OFG?=
 =?us-ascii?Q?tGQY+JoKaDest45O5Doeiv8aqJa9mx0OokN8dYtYXUUfsmx+GNzTy4IikFYb?=
 =?us-ascii?Q?Cfyb56QDdAvF6+dmvQCR4JTBdc9vv3bUndVTjKnlNT61gLFBCnC1Gl60Yx63?=
 =?us-ascii?Q?EWVcari/nR4qufvHOivottNZ0G2qNFz/80F+4ko0iZIIXR2xeOW23svvsDiN?=
 =?us-ascii?Q?ByYRtLF6rx/CCbUTv8/Hmq0o1iC+S1a1Fd0qk6jXmaD4KNBlLwRAWTAnvtBQ?=
 =?us-ascii?Q?+UqDZ2nxFfFZkQqGCk7Je9fFy/RhrzC3F1mphKOGNd4E5vLz8So+T+L0Vn3l?=
 =?us-ascii?Q?u1riz25yW6m5t/yOJ6U67LGezPMbn5TAOkcHOBMU2CvMXS9HT7ytFWKEN+TH?=
 =?us-ascii?Q?jIKS5Hg7J4T9aL02dibsH8fVSf7dmXFc1yG+WG2bPww4GVzjs7M3gGAyDR/b?=
 =?us-ascii?Q?K1i3HW8d2qdDWygivhZeHsTyXnYsq+3LooWfAHjOlvSqaAsC8S1iPBWc7NXh?=
 =?us-ascii?Q?EZLmB61or2k6kqSBPZVENNIMZ5WbOgcRtxurkhMkntNKKw6yg6fS/7HZU8Ss?=
 =?us-ascii?Q?T2Zy48egh3HDgiZ/e48=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kqIRldUB6L3n46cMUpUv7TGLCv2qwxwIcMZWkl1GFXan7qx4WmfXCN6YwUMP?=
 =?us-ascii?Q?oUG37aTWgrIYKgj+8VPbcwsNJmctKJ69OLWQcp0YZKA6paUQqOsT4uN67Tsv?=
 =?us-ascii?Q?xjJFJZ/dtlbxbw1E7h5KceLZzJ7BplxziYEGA7mEfH8GmUrIBmj7kH+m2ntJ?=
 =?us-ascii?Q?EXHC2empdibT3E9IlCHb9telzLh5odyLGfav1ggsjuykoOfx7KZnnsW4C/Kq?=
 =?us-ascii?Q?6fvEM1ut50hRM7vZnLl1oH/z5JstTU5ScP8TScrf73tkpg9fsin5d8nbg1XG?=
 =?us-ascii?Q?E/CWJgW4y8qnYEnUhyKGAb3lHlCk4KeMvesb+qQ9Go9BenX8KmZvkiZXrDbA?=
 =?us-ascii?Q?AIEh3bXWCtObI7r6wM6zlYLmlI2WmXgr9p40lUTf9B3XuFMWcg1/Cw8JfwQW?=
 =?us-ascii?Q?7Lfn02S9F4JYrlGKcen59KUvQ0NxJLbIN5ovmwZRNCqB4NG2ss6P5xmkEs6a?=
 =?us-ascii?Q?DgXbVhsFX9Ru321TtLJG05+8nAd4/HlVEJlY7qXRLcjeLNu0yVpy3tvE7YoG?=
 =?us-ascii?Q?mWXFxcYRLizpO/LyKtQgj1PsAs6azkyVN5plK4KsnR8LRI/XPJa9o6MBa3bm?=
 =?us-ascii?Q?ZbUesuqWRhBy8wU7MydiU58GQyx+dsx+ELG91PGOtADbedKhaT+AGJzJ5R2d?=
 =?us-ascii?Q?/C6ov190032DytbeCPqGbkl507Se8iI4owafEHwB4/kE7SkVWx8iRZiQixPJ?=
 =?us-ascii?Q?ID3iyylZObdvkTQEXK+IvyDM2hQGUeWr7rMG/CWJZ6VeVG65qsiLnnfadN0V?=
 =?us-ascii?Q?VlOouEdBxxwYdvqKo/86DvqrBIRRMBM/ZULNoUjDAP2wNFsFCDa+NqX8b+g0?=
 =?us-ascii?Q?uoE2qJ21t+vFcaj9/F3GKMuJxbJyMegEAtakuMJ/MOMCAvhmdJF+GADQL6Wx?=
 =?us-ascii?Q?1GzEtk+Lt9ZSpHkkCVih/KF779JatrVvhWwqa8+BCBtu3vZpnwTBwBU6Xle/?=
 =?us-ascii?Q?lQB7bbTcTB4oY06tEYh4usOy+5prdD8Uq6k9N7pFM4EDpalkWr8zGg5ShLav?=
 =?us-ascii?Q?pSKIO9/g5aYoqXYOJ4Jm88vTHsurbO9eFmVH6L0q57aeJxsu8t/p/txGttl/?=
 =?us-ascii?Q?pylYDDLnR/c/MBTjRBIVvchez28VmiDzzcP5prf0l/yGuld6Hl15ijbWuOjo?=
 =?us-ascii?Q?yP7iVQ4z7ytX8fSxuEYTsdik/61KTXWw+dyiyoUfs362damZTNVQxMMszz5a?=
 =?us-ascii?Q?A//DtsFo3/rMBAZUT0oJ45xMrOk11L5norOmxBO21tAJXvjziKw0CyK5XyPm?=
 =?us-ascii?Q?ypEKWuUTOpX63/vLt0h+1pOjPD9zmqdAceqMrfkxsqXhRo4AobQSJU72Ywe5?=
 =?us-ascii?Q?jUTMEY/mu6Ass01xIyVhDRJpzZU4paD11Ysw99mG7C+TmpwEaOfMcv8PwzER?=
 =?us-ascii?Q?730RJPqagHg1Uu7uObAzAmDnPjvFmEkQSwPQzFbF2T72RhxM8u8BK2Dc3V4S?=
 =?us-ascii?Q?N5hVXTmXEbnGV+hAzJACOXLSF1J4d6BcmPXJq8TGuErOwaPcIqs7Y8Jegp2E?=
 =?us-ascii?Q?HIEy5XcvXKxxO44wnP82aMjl3IJqQkJLyra3PlYSXD9x48WEJ1iCYb9Qmd6d?=
 =?us-ascii?Q?ApOUT2VDLtllF3xj1rxAov6KIqJNve7OlttkKM1342s8DA6AsXjZTCeTIx50?=
 =?us-ascii?Q?gwYd8VUpp5P3kMCFbqaYrUj3kA7/aSj8cdxgzjnbCEi0ewO0ovCyOihT3W/H?=
 =?us-ascii?Q?jslT0feMY7Z0jYCQPhf4T2cXq2R5cYDaLB7EY5mgoeucuJFi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba7538f-4e75-4456-486a-08de590a49be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:29:45.6070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lf/I9aS2/ibDT5BusJfcOSd2FcmRNLaI9Q+6N0alz2AXYMRoeK8tiq2q3wq3LeBm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7180
X-Rspamd-Queue-Id: 5E1401A0009
X-Stat-Signature: obnzexf8s77gtjudzzf9566isqearm6s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1769012989-200590
X-HE-Meta: U2FsdGVkX1+YN1aqZE5VCUpCYLoINbzsoDqXzambAIUmV0iBqabLAwnCd8YfjiLiLy67XtjA3JPl+9T/O5XTKi7q+AdSklDvNDKyg64MUva1OxCdyy8/DADOX3L9U4Y/5E6+F3E1AOSMDec7+PnlqfxAgBErf7iqYEj8xcyIUOws6ptr/W0AgsqywIaAMftUaYpbVzfv9Q/Avlrq6kOyfdW6GH11CARxkmOfbmfQjJqZhrECxNAMkZ1BTrs59ayZbwzyxoTECVMOUhX6f9QQCx5p2pvBrEBBrBUrPp/XQ8VxVqJGKUU8Xs2G+oJ4m285603F6xmvL+OFBZYpbJ0TVeXXi5BY92DDe6EOx/Bh8UAPy5pTHV4PJKyWmiRFh5P95jwrN7JPH6DThFL564pEjOPihs+Vlge1n8yIt9Gt1QxkN7jEDZ2NWp6uajUAHXALCLA7C1K6aIVfQppOmtSZFh62/6CJAokb0yfb50EwWJlBNEqWh3oLBeoSJIgDRc5yXmlNwW85RThFHuyTRnmGTlpD9o2NN7GpyGryBvJJV/HMAmzGkyjuTpweCq0bRYLF4A36GNtlMB1ZjEeyTC28x454FU7J0CQqh7Xax/qsn63rQ1FAXRDy+81XmZIqUs4e7HVO1WRShXvzkHLPqDIRU5VnpJS9Pl8RP7mR4WCO6A/9FsSdgLzlUSDLIixyEMIIeSk82qrKIZa836zfB3Sg+tQzbrUlOdfr1ywoFL6mJsJWtxXqtr8hD1Dvcy7dmNKW/crPtUF8eIaK9SwdA6iKJUljNo+dsdndjpDjUHXnVHah1MCQuor8CDfbjWkcJ8kKM+K1a3P44xMUfj+T/njYUONTCO59oOktaMpijZz1/kqQoIETbT3Pco+rSZPMHBP0mkMEgOF9LnDSem46H8vwl+peIsWtxhMRIQgH9FmTZGpjM3UTz+/dTgG+60Eo++8Snyevy1610DVGmerDYEY
 QQoJJt5W
 3onPvuDVGlUUv4AQ9uo1WEox06ISONOU3sSzPuQa9/GGCVeMDKnkLSy+/mYohd+vyEHOjXRDJL7sLkxDiKdWYCgyIaNFxP0wPkwhYjR/ySFtc0ugJ2oEiYDl2b+Yw0X1G2v3NUYV0MwyHNF4xVZxhhva1ceX+DjaYhTdIbdTRuAOEJ4IqOOAAcaz8g8m79IJVDzvr3G8BMWm+U5e79RhvL5jj6fVzz+SnTGwg8eZxBIlfKhAhHfAxxJImoYhCvr+aUzuImGCBkk4gCYdMW3mI32wGZ25y+q/HepvS1dDqsKhKXztZBSHjdrJ1B+PMgkGZEJPXJBglcU3QaWB2B9+QSv7P0vjieB7QCSfL0F5XNTytOpx2/j1S+ZfJDFTdiINcuvFo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.
>
> This is preparation for adding the vmemmap_tails array to struct
> pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  include/linux/mm.h     | 31 -------------------------------
>  include/linux/mmzone.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 31 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

