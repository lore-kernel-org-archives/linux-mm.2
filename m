Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C559D19500
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22D16B0005; Mon, 26 Jan 2026 11:09:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA116B0099; Mon, 26 Jan 2026 11:09:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987326B009B; Mon, 26 Jan 2026 11:09:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 808F76B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:09:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 523C5D36BD
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:09:57 +0000 (UTC)
X-FDA: 84374601234.25.E22C55E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2DB5A0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:09:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gZZ0tgpA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KenEpQuU;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3M45g7zRyD6a4t//qkGcew5L8ApkAR4Ncu2qpPcffZo=;
	b=inSOnQqRdnXPIgjRgvGpu928PkfoLFRoIMoTE6do397b9L4PvPDZPnaYrB/2Lue6V7mHF+
	O6EqnyKldiLdDly5fqYrIb3TFnR3cZd82oC8GYkNteOYR3121o8BZpGUwZtBCyQazg9cUU
	oiM9b4cBcQJMtmmcIOmWqlj2K0FWirI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gZZ0tgpA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KenEpQuU;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769443793; a=rsa-sha256;
	cv=pass;
	b=Pkj6fuPJI3Q2ZKKNhob79TVqnMHpx4sJ+i7Kcc2N6wDJ+eVML8X5ga1n7XZv1Nn8Mth8TO
	mQ8A0nC13k5Tqu7p89Lpmcchjs4Upxwp3pAXpJ+R1I3M6cpUCqnzQTZblwzZN0grHwgHGv
	Nw0aoCEaCL0RDHbycp94Q0cpF1NZdM4=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q0jVQa124527;
	Mon, 26 Jan 2026 16:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3M45g7zRyD6a4t//qk
	Gcew5L8ApkAR4Ncu2qpPcffZo=; b=gZZ0tgpA56xeUzccposBa8ccQRFJruQCZW
	pn0a47xxB4DMAd6VH9q0iJzB4Avv1eCO3apL2cbSFxTDJtascbKJhME7igqoal/f
	mjSp/D2eYiUSasbLru53Hp+mUEsC25uJNBO49o5kEAXYvyc6E8k7EGUvpBzGJkFf
	jyBjPrz6SHJ0qOzVvCd0gZd5LbdDIPnUVUYe+/wuiHTO30Ef5XwCgjKTWTjwsAoU
	mvKG/YagdC0ovTfPf+j8W+EV7C+TgciBQ8Nb1EICgqikITNF0UEVj6L10CWmG82q
	0udU86/XosTf/5s95MXQfWNgZO7QdiJSmQZiVPYSwXmsO3oUwfAw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09j6b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 16:09:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QFEQx0035109;
	Mon, 26 Jan 2026 16:09:36 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh8483b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 16:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+Nr4WiYausjVYlNP5NI91FM9smlPJt7rIGLxRvnxs3PZeU1rfj3QmuoOFGnN/XGzXjre3SJ9NvFEbywCflukLcAIl8t2bJzRGo6AGANURgzz/JoW8IvuPQutKWOjSrn2yNIBZ4QKSv1AYWdWEdVG27A53e0cSG3Jjq0F9Ect0PrEFjQDF2HTaqKWjy86bbpng6ZVrCSEhvEjp2jc4JSJm4i7fSakuQI1EIpPc5/U9ng890ycG4/KwG7ShJuPs1IDpYsMLzjINuw3Dva6v+H4/hZN1Mk4pVqgfibt1erPGlitCu+gqem3fJ+yI/jBc9jYeaAtdRFqrcAr+s0EAWBvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M45g7zRyD6a4t//qkGcew5L8ApkAR4Ncu2qpPcffZo=;
 b=QmgoyJS4bBPXC/puAavwprgEwS8hfEr3FvOvXUcVUO4rhVEheDeJs0dE+jDltB7jN7eCB3WhWJT6MvubljAHwaxbOc75yCT8LGGy9RGfaXgi5eWWn2DYcWexqIQV3x8XOcJw3JeeG8ICUmxhxBVOdL/Du5gOXeNjJvUb9hkKKASuY+XuvQ/AhE/dQbi8s4jaGB5WRtFxuv+x36lXKYOJojFmBi08js5TblkZVjD9zCfXxX/7GwR02ZUvmAhbMfZLW80JTRvB+5sajTlWSKLkJYTGuR1Vn1THmirIriWR5tl7qylLHWbV8jl8aR69mOlWvo8NbOSr44KvV20hqPlIsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3M45g7zRyD6a4t//qkGcew5L8ApkAR4Ncu2qpPcffZo=;
 b=KenEpQuUSE5HxARgN1iZ1AVhn8ga18yUQw2JlIWiF+MmXuQ+pqJRJO8wN0Y1C68SI6UMhJ+gISKnLrc4MwpMCpvVkcAYycVEqztPMlHapZkw1z/VKWLkzK7pXYeimJ4hFyNM8pQ149z/7v9IV/XJqlRBzGh5AxzV/6YcyRDsEYk=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by SA2PR10MB4521.namprd10.prod.outlook.com (2603:10b6:806:117::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 16:09:25 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Mon, 26 Jan 2026
 16:09:26 +0000
Date: Mon, 26 Jan 2026 16:09:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
Message-ID: <c09f2c10-516c-43b9-81a6-cc77e5f78ba8@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
 <ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
X-ClientProxiedBy: LO4P123CA0041.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|SA2PR10MB4521:EE_
X-MS-Office365-Filtering-Correlation-Id: f232f212-27d9-40f5-a8d2-08de5cf54800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fZUWUGSMDo3p9fdQWNyS3B1keBBpl6SA3wUhEtyFBsnMc0rdpGNFYu8yiQnU?=
 =?us-ascii?Q?Y+OwcjyqJaFPXd278fN4Wqd1AhjxPb8LJSBjGh608kMeLoYFZ80Pbp/Oi/VE?=
 =?us-ascii?Q?TdMR1+zcKuzfXTqsrX1teQK53bf9L1PYHxbUEvQBr6yHleMixkbXY0clzjGT?=
 =?us-ascii?Q?erOpLUSpRIc+5nxrtBcP1doy5ZpdUD/W/k72lPzwrNT4n43tV5P2nOyTaj8H?=
 =?us-ascii?Q?kypQEMhYjtgbpBVPPcG7LgkTgiAO5xCTjUh2HM/4Laq94SVR+cf9uwfLOE55?=
 =?us-ascii?Q?4OzWOLse06ssQMTc8rHxyC6JPo3nx66yxckWmEHaVNip+4Zn+DpwiXwLUFFL?=
 =?us-ascii?Q?/HVKzWWMbsHWsILbtW1ZKC2svjpFTdHL/gKTo5G2SUkdhyGdVRLPEiNhkJg5?=
 =?us-ascii?Q?ijdzWu7/gqznqwQhitCQii4yVxVnCxI3ZAH4OB1584QRCeT++joHidy6gita?=
 =?us-ascii?Q?OnPK3QZCwAeV6g6HkUPV8zVDPMV9kvMwCXUf3CM7zu6VaiKkt/P4k8d6LHmv?=
 =?us-ascii?Q?l44YhQiQ/6iTQfzLd0GLDzVe0crnfHyhNPGRTY/xXfGBSttRQqTN5wOxibii?=
 =?us-ascii?Q?w66kj9wOMiidvhWpIyK4Vzhz6CM4Hslhwrj5JviuO/iyN3ePjPcuQUVQ7MAz?=
 =?us-ascii?Q?SclQieoxaaPoQZVNjxlMcwKgsxPJIj5ABwTxW2zLfBTWw925ypF6ejJzzeW5?=
 =?us-ascii?Q?4la6yCSVkoKOhDntbDeQod3Rb39Si4/yVCAhSopC4iHwIT47/XgB9amUclZd?=
 =?us-ascii?Q?u44mg9rDwAFiAr8tBOq5BKwb1MlKx3pBAfdK93SOb2rkDxAp6nTfA7ihbZQh?=
 =?us-ascii?Q?M9V5dwrWSHL6r7uCHE0XpeJWq2+r4zEZKjLRvhxlMItyw4idm5kMb2QPNlho?=
 =?us-ascii?Q?31gK2iuRVPbxMtxnW0vv47d8MYsLQXZ/gQboBh1uFHGFRiq55wyX5jdhWg3U?=
 =?us-ascii?Q?l+mopV7nrc25PcNMCoa1eYKSYICHGNA3Sp9sp+jxFZs8+WpT429K9zv04xPQ?=
 =?us-ascii?Q?FHX3Xr8+3s1qLghjORX6WMcHjHvobzZI13qSkTcixmhE9yzCsRyQ/jN1blUb?=
 =?us-ascii?Q?ZqRBMVdjR/N+VLKcepKgAk2YnozCZrTghrAFKUDNm4B20WuIdQsW9wQPAHfs?=
 =?us-ascii?Q?8M9H3lrcrPYd16Q7SMImdxGA6U/yMaoF7ocl1BsaWVCLm7n+w8TEV44wHPTe?=
 =?us-ascii?Q?cfGzrYvrZUgaQ6dvnfAodvgXYFvcaQOB0L1AjOdDz66irPS/BNp8fd7SuD2R?=
 =?us-ascii?Q?8dnBMxX0zDbnz/2f7QciZmLE0w19lyzD8I3w/0KhvLcXtwGr6aiF/U4Gj1x7?=
 =?us-ascii?Q?4gNl8iA+4N6ByJakg3NJsHqEHkCCR5xnoZnu2DaCOXbVWxrC2bhgsNIpp0ov?=
 =?us-ascii?Q?+0hf6xYEKUz2gxqtgNhCD5K2F5qRiZ5ioNq+xuWtBB5F9C4iBSyKurSTjIvk?=
 =?us-ascii?Q?ITm2KPu3HWTBluwEWtIcoDWCUccAGZHFwbM/8yXpp3AREJ3FodornaXKDfbq?=
 =?us-ascii?Q?Z3y3fLmsgJJL9iThAdmrLVO12PxdsMZI/eCLYXunJY1t1UpF653OL/HWB9n6?=
 =?us-ascii?Q?wrw95/R/lCzmd7lmEAk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xiesOG/AD4hsfBM5/TP4WNGm3TbMpu6Cxe5c6yYkQnprh6psZ0eg7JQs18Em?=
 =?us-ascii?Q?7mccRG0DA9tH0ZzzOQCGCNHEAwNLNW+GgS47LQRgtg9Singuw2LarvL2ohX8?=
 =?us-ascii?Q?YnKf8Kx1iNuUNL+qoH7ureks1B6YNrGSJu15hZgSNT/t/YcRIXYQFIn4qgp7?=
 =?us-ascii?Q?YLy9FyWKwKpCRzZ+dLEHOJSFP/al2T2p7JI2QzMb8hNtIrG81u21hGL8st0j?=
 =?us-ascii?Q?StoPmwL4T7IIGvXn6p94035FSg1NkzyzgaCiQ0P4Yq7RDhck2mct6JBzFjrI?=
 =?us-ascii?Q?crrE2gOAHJfnI7imoDekMgrK5OqYtAVlpedXy5gjsBO/Fopp4r86i+YcvPD5?=
 =?us-ascii?Q?p3IDuNOXZbcte4v93JoC0y3MJpz24ulp+M9RukF79FlCWnjr2RtAi+TaEQ4/?=
 =?us-ascii?Q?e3g2sbYfDJHcOByu5mwRwx2JlB4iBFD7aK7pU1WSHOA1kjb+GLxfS7OKTuLh?=
 =?us-ascii?Q?SFRLUfl/rBPfVTgLjCziP9uNXXrOHxtwOUKrB/lXkhS60XZc+4vzuVdrDu5C?=
 =?us-ascii?Q?oG0E2UOhDUcF6yhYkwzx1bboItH0BGKNchG9WfO0BNdNJWTTS+VzH+XSVwn8?=
 =?us-ascii?Q?LN14pbNe4F1MLmCDzM/D/s/ZyfiNAOpHZCmgdUGyZaDqA/uiZCpzJpfdSqoO?=
 =?us-ascii?Q?FhEgHaqEljSZpbbzPMv8KiX2ZkJelM66PzdTV+IGq7WMs78GtbxycsSP91Gb?=
 =?us-ascii?Q?jD2ENSZwTmtMZWOJcIGIn7rZKP0u22DH0P3d7LPJ9Xk9ollDKV6XD+YGdSZC?=
 =?us-ascii?Q?ZBjO+eKE0ppd9RperpDWhSp2lVWtYaDHtEGPy1stYO5aJ3/qbdYkXoa4dPTK?=
 =?us-ascii?Q?dvDqplUZoBsT1rnGg+kpD8crBK33/yBD/vqqjQyfg5R0vx1px5qwgNFnpOuU?=
 =?us-ascii?Q?YK4X9lynN7XeOuVByWnGiOWgwQnKRc9rD4k2E7dQ8Upk/2V1qeu5nP/HOUBl?=
 =?us-ascii?Q?gge2USn6HrwDwy0huBtb3hREZKy3nBWh/1hglziQLjEDrU6p4KjfrTt4TqA0?=
 =?us-ascii?Q?iFPbpj75RfDZ0EQP5bnNJ61PILZmG/aXJMZ7SagEJvFgJcE+Iztv2B0DW30E?=
 =?us-ascii?Q?L18uf6ZNhutTXBTRBMbtSoCReolzibeF8Xy70U/FAdcsksfW3Gp2fgacb2bB?=
 =?us-ascii?Q?mMd5jZMpP/7mO+ZEMcvPRLV7RqKB6Rax+A11YN2TIyy5t4c8obE8LORI4M0A?=
 =?us-ascii?Q?WvYfwuh2t4BDPnlbbUXWmHzIvu++LJ+qOekXVD2D38mGqTl0TItEt250Jaib?=
 =?us-ascii?Q?O5Eo9HFq3r0528Q6XGsDEOjzUIsKbZ8CL/lGFT71exGcKBr9ElAijmx6WGxF?=
 =?us-ascii?Q?EVhKliIvX/HVzRoPp/Gzm3lOBguYTG0TEVj+M/dyNQywpnK5an/oP3USWpCd?=
 =?us-ascii?Q?Xx0n5Dorw32WDK63ON6v9g4Jt9m+LvhOvHNVdz/DnxKS6oKyMnWg8IKc4wWz?=
 =?us-ascii?Q?Xl/x/pCz0prh4TopZvLf1ouMGUvaxB5NvdWhev26q9+oBDDcgQcBHUl5BDmB?=
 =?us-ascii?Q?/U/vFY5LtPfLUu7eLEVzGtGgnRVE8FF71M+82jVqDzbSDSijQUaDdK8ym4Xw?=
 =?us-ascii?Q?AkVp0UKudpPh863Z1vu7JggQNlDfkW6CkgQrnSqeSgqQ5Kn5uTlm51ogJ0EQ?=
 =?us-ascii?Q?pN2atHxOhV/Wte6vOoTRhqNDnJsgJnwDHQnalmOCUjuyxD8z9kV/MqEAXQO+?=
 =?us-ascii?Q?SYyYn+z9cHYFS3tBE0YKDNTl5q+TnTkTyOlxQB/iQDYzzpxOjnCUJNP3EGlL?=
 =?us-ascii?Q?ycxwtcFpWHK4M5VwzR/B9OGnAka7mrU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MBHa9e9inqOKcl4C2YSc5BivnvRd2hWzCmG6NqToQK+3Jr3PcFUFWEoNgOoxG89BAkdESwzWg4vO0mMG1cI0e+K4pPXqATt+8kKjUAKZsVjsA3KuqdpW7U4XPTMcSa+xRFmpPJYuZxoBtxEf6n3li2N1DKBj0ICsOTv46URP5PX1x6BFTKdAhMcHyWo6t1uHjRcCyWPUFZLiMozynGghhQzaOMm6yBtWj+jrCc7HUNLBXa6ohxNggfZ0gufDAgpJHQfKzWLGfDqZo01rXWhlm9QYYKrXGwxhRxucQKk5HOGYuz3p/ByRmruMVRI5d4OnGuMDQDevLFiPYQUJ29J99lUSvvjI+j+H++6xK0FDMasdNfCyNdyudjDgBzkIQEhAXclQx69dQJOdnxpkXH25OZa3MnnA+cocfJ1hQkAf6WgV8NfJojgLxEcyQ5OgWY5p4VydEtz7M53QwwPxjG5g4KHhYN8VrngYz3FlpWCYpFxcpgh8YBs8YNQaT9nUWwTwRrYIkNz3wLP3+l4buikxmSKStLj2hv5ubGmY8dmTGA48rHYczuGoI0nPFH1Lqa3v48/MFdze/n+8Cwuj9A/nJj1Au0SHxEYl0jFcAeL/ZuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f232f212-27d9-40f5-a8d2-08de5cf54800
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 16:09:26.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ci8B0Sr9By2TLPXBQiu/SHNkyGXXF31+lG64YCtGcBXius6qGMuD598cutX2UhKRYuV763Bg9zSkFHSOyCDD5yI/FiEUR0xQnOjLvCqqyLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4521
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_03,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260136
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDEzOCBTYWx0ZWRfX2pCyOCba6vXf
 DlBQtP+EpzB61upu4oGuEL2+3mIxMorO6N5U+dFVbrevKl4WGHAdGVKYhZBD/3+dwHRQUbbudBP
 AzPiNkobe2SP86Hc1ba9sMtY8IKHNaQKfp0QfT2gnc4wyIp4M+sXZQWeCZf/ypRDrdz3aDYsAyb
 KmKitJMbln3HOuXpy1i/Cf9AcE0KPGnNYdxHQnBUHbaU18Px654qVoWkghp3ihTxEGm92neeo1A
 Gx6++Sr4e5ESvE7ko+tr2IjwdN0ThUqO8QeSS5roDS8XfTNoXhWuCUW90l1tZm5n15vdToEiNnL
 j5ja/6Y0eWXqcrRXScieT93syRTmMiBrsACeyOOh61qA1SLE/R67ehjS/BgmGN5S3GAbLGl3SfN
 GtrvPvFFO+jN6nBjZZwlSx7wjt9ldeHeq+/xQRSoVpM74oDoYaBX75R/j8PNPAcyD2q68Ao6HVI
 cfjKugkc2rWxsghH1tw==
X-Proofpoint-ORIG-GUID: TSP6gzCtyjtxLJckJhXgqVzJaYdMef7f
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=697791c3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=WdQaoyJ2WEYmHkFR7kUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: TSP6gzCtyjtxLJckJhXgqVzJaYdMef7f
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2DB5A0007
X-Stat-Signature: io6csjacxr6sau6oqoonas5dukjx6ca3
X-Rspam-User: 
X-HE-Tag: 1769443793-807851
X-HE-Meta: U2FsdGVkX1+plNOJjUU+fK/fLE4GzwQLMuIFFiH8w1hpSUjdhqJE/McpIEjH0N58Znvojx+6h7faCzTD+YCXBnk6mklIrLTh/Bj4P5S6qCR9PaTQs7iei2wcnQ8RLwtTJZ5s2ix532tYu9Btm8IQy6QwdYu0FjjB/K3T94EPWxv/PEGHLUreuG6130uVbL0109F/EnPZGrEijuF3ITblBXTxBQH1nnxDqcu2LffRTzhjdnRk+lmj6CXsrxo1howwzYdOvt2nDG8mpZ/sDj/O8WqU++jJXfUlvWmMkuJDG/D/HNJpykUrihC7WtDeK0we3IpNBSjVpa2b41y13veAM5tjEfyB/a0FfXIbMvJHG2XxfaRSNIM6v6quzyg+UL6o1Ng30dQ1Jqxhn7mmMXNBiTfyS5k4Ns9vs6lrObHZanoPVa7mZ2Bddw1RWoc+5B27+rVw6oCVX8UDFbEM3Nq0k7ysibrXociT1amUgLrVxsr1TM9oLtjW83wNXHWXigY3ROzHjIiKLGjCKYIVZOtuExhYyig7JiMIrrw+B2IfOtYghduGvzGYAaQYQYSMUtHsjQr8hzmWSNqsy3WH7gmb+wiGdGXY5GzqHwt808xDcvlcgzTxIdYp8qKlvAjspen8FZ356Pkao0URE+5ryYgaeOwr5ThF3xzBqDIXRS8FN24FS8LKbwwXCZCZqrm1XNhqPe1KwjZ40KN7adwODkWTiQleLHQtpxz6s0YdIxOQgQSIy50KfrBzpvOzjSJXGJ2urlz90IxIBaHh2pGqlG/0V3TXbye13f4jbeqS1d/u1jHyjwlO5hMznYi7yq2+ze62DgZoz/yTtdjVsJoKOuf9Djbs13eFtvw450jFOKreVWIOyeHGx5NfSaNMCYfu7RlybqYZnuV+qvrNX0tl2daQTIV8355EIbv7QmPnzsLyyrjMmxqxcrb96DohB9zEL5qgJu0CEfvGKAWgjDsbqOf
 +6OJoHn3
 IcB0rdlP2A/ve9+tCy6WiFBuUVRmUPk3nklxIb/7m7x/yV3n9yqT/7my7itvyKw9jSFdrSBGwE5d+VFAXu50mcELVa69zZU00emoVOGMWRo64KY8hVBJ+VZXxaoBEMXTaU4DVsj0ZrkKnqIeCxMhJV5XOf2iE6CFdEeWcKE+mSxxgo55HRFNCbjruSPEsERuGw1JVzGRmxpjQX9CVUmSr9mvxJdMiMZQAiwviNiDlwgLQu3BJJJpYLnUSJDsRJZcavrsTsRGY8A3wRgu5Gl4wm/iAfmVWy0QYLny1geUyi7Gv+wEA7xNeneHgOvq5i56nanf1o9Dc2zV+gTcLOQ7r+AM0k91hDUsTrUafLp6FxLc2rLAWjDIBslUA17PqVfo0SQs8sqVGdZIOGdPiDZaEOWeOmQzVv4z/kB7SDxE5IV4ryyQaC19JLPVpuXQp8JkPF6Ml3XgUv0ylLH/Z6DcrHayRL9uanoUSZI20k2s2SydKepKxHKbbhEwwZE3QIpRGOULM3ycNSbdhYfu/uQ9goJ8hJOT0f4fW1fFXcYL/ESnfYDlAvDZqSJ5tN2kbZAxkyQ0jQ1+uZWcLqYImzhyo7XmqOukAOmYEVfNaVl/rOFzUImeLEejsDm3T+a/2jUwjU5jMl/B7uJuM3veURGQ56o6cmMVOxYVj83bsWHEoJVJ9ajGSg7maiB/Y8BTTAgod78vk0Sk4uhiBlzlrdKGlsEFSDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - could we change the commit message to:

-->

It is confusing to have __vma_start_exclude_readers() return 0, 1 or an
error (but only when waiting for readers in TASK_KILLABLE state), and
having the return value be stored in a stack variable called 'locked' is
further confusion.

More generally, we are doing a lot of rather finnicky things during the
acquisition of a state in which readers are excluded and moving out of this
state, including tracking whether we are detached or not or whether an
error occurred.

We are implementing logic in __vma_start_exclude_readers() that effectively
acts as if 'if one caller calls us do X, if another then do Y', which is
very confusing from a control flow perspective.

Introducing the shared helper object state helps us avoid this, as we can
now handle the 'an error arose but we're detached' condition correctly in
both callers - a warning if not detaching, and treating the situation as if
no error arose in the case of a VMA detaching.

This also acts to help document what's going on and allows us to add some
more logical debug asserts.

Also update vma_mark_detached() to add a guard clause for the likely
'already detached' state (given we hold the mmap write lock), and add a
comment about ephemeral VMA read lock reference count increments to clarify
why we are entering/exiting an exclusive locked state here.

Finally, separate vma_mark_detached() into its fast-path component and make
it inline, then place the slow path for excluding readers in mmap_lock.c.

No functional change intended.

<--

Please as per Vlasta's comments below? Thanks!

Also could you sed the patch with:

s/__vma_exit_exclusive_locked/__vma_end_exclude_readers/
s/__vma_[enter, exit]_exclusive_locked/__vma_[start, end]_exclude_readers/

As per Vlasta's comments below?

As I have clearly forgotten to do this bit myself... doh!

Also at the bottom there is one small correction to a comment there too.

If it's too much of a pain I can sort out a fix-patch.

Thanks!

On Mon, Jan 26, 2026 at 12:16:07PM +0100, Vlastimil Babka wrote:
> On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
>
> It's now __vma_start_exclude_readers()
>
> > error (but only when waiting for readers in TASK_KILLABLE state), and
> > having the return value be stored in a stack variable called 'locked' is
> > further confusion.
> >
> > More generally, we are doing a lock of rather finnicky things during the
>
> 				 ^ lot?
>
> > acquisition of a state in which readers are excluded and moving out of this
> > state, including tracking whether we are detached or not or whether an
> > error occurred.
> >
> > We are implementing logic in __vma_enter_exclusive_locked() that
>
> again __vma_start_exclude_readers()
>
> > effectively acts as if 'if one caller calls us do X, if another then do Y',
> > which is very confusing from a control flow perspective.
> >
> > Introducing the shared helper object state helps us avoid this, as we can
> > now handle the 'an error arose but we're detached' condition correctly in
> > both callers - a warning if not detaching, and treating the situation as if
> > no error arose in the case of a VMA detaching.
> >
> > This also acts to help document what's going on and allows us to add some
> > more logical debug asserts.
> >
> > Also update vma_mark_detached() to add a guard clause for the likely
> > 'already detached' state (given we hold the mmap write lock), and add a
> > comment about ephemeral VMA read lock reference count increments to clarify
> > why we are entering/exiting an exclusive locked state here.
> >
> > Finally, separate vma_mark_detached() into its fast-path component and make
> > it inline, then place the slow path for excluding readers in mmap_lock.c.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> Great improvement, thanks.

Thanks! I will refrain from saying thanks on all of your tags without nits
btw to save the noise ;)

Addressed nits above/below with kind plea to Andrew to fix up my typos :)

Cheers, Lorenzo

>
> Just some more nits wrt naming.
>
> > ---
> >  include/linux/mm_types.h  |  14 ++--
> >  include/linux/mmap_lock.h |  23 +++++-
> >  mm/mmap_lock.c            | 152 +++++++++++++++++++++-----------------
> >  3 files changed, 112 insertions(+), 77 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 12281a1128c9..ca47a5d3d71e 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1011,15 +1011,15 @@ struct vm_area_struct {
> >  	 * decrementing it again.
> >  	 *
> >  	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > -	 * __vma_exit_locked() completion which will decrement the reference
> > -	 * count to zero. IMPORTANT - at this stage no further readers can
> > -	 * increment the reference count. It can only be reduced.
> > +	 * __vma_exit_exclusive_locked() completion which will decrement the
>
> __vma_end_exclude_readers()
>
> > +	 * reference count to zero. IMPORTANT - at this stage no further readers
> > +	 * can increment the reference count. It can only be reduced.
> >  	 *
> >  	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
> > -	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
> > -	 * thread is detaching a VMA and is waiting on a single spurious reader
> > -	 * in order to decrement the reference count. IMPORTANT - as above, no
> > -	 * further readers can increment the reference count.
> > +	 * an attached VMA and has yet to invoke __vma_exit_exclusive_locked(),
>
> __vma_end_exclude_readers()
>
> (also strictly speaking, these would belong to the previous patch, but not
> worth the trouble moving)
>
> > +	 * OR a thread is detaching a VMA and is waiting on a single spurious
> > +	 * reader in order to decrement the reference count. IMPORTANT - as
> > +	 * above, no further readers can increment the reference count.
> >  	 *
> >  	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
> >  	 * write-locking or detaching a VMA is waiting on readers to
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index d6df6aad3e24..678f90080fa6 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -358,7 +358,28 @@ static inline void vma_mark_attached(struct vm_area_struct *vma)
> >  	refcount_set_release(&vma->vm_refcnt, 1);
> >  }
> >
> > -void vma_mark_detached(struct vm_area_struct *vma);
> > +void __vma_exclude_readers_for_detach(struct vm_area_struct *vma);
> > +
> > +static inline void vma_mark_detached(struct vm_area_struct *vma)
> > +{
> > +	vma_assert_write_locked(vma);
> > +	vma_assert_attached(vma);
> > +
> > +	/*
> > +	 * The VMA still being attached (refcnt > 0) - is unlikely, because the
> > +	 * vma has been already write-locked and readers can increment vm_refcnt
> > +	 * only temporarily before they check vm_lock_seq, realize the vma is
> > +	 * locked and drop back the vm_refcnt. That is a narrow window for
> > +	 * observing a raised vm_refcnt.
> > +	 *
> > +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> > +	 * details of possible refcnt values.
> > +	 */
> > +	if (likely(!__vma_refcount_put_return(vma)))
> > +		return;
> > +
> > +	__vma_exclude_readers_for_detach(vma);
> > +}
> >
> >  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >  					  unsigned long address);
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 72f15f606093..b523a3fe110c 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -46,20 +46,38 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #ifdef CONFIG_MMU
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
>
> __vma_[start,end]_exclude_readers
>
> > +struct vma_exclude_readers_state {
> > +	/* Input parameters. */
> > +	struct vm_area_struct *vma;
> > +	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> > +	bool detaching;
> > +
> > +	/* Output parameters. */
> > +	bool detached;
> > +	bool exclusive; /* Are we exclusively locked? */
> > +};
> > +
> >  /*
> >   * Now that all readers have been evicted, mark the VMA as being out of the
> >   * 'exclude readers' state.
> > - *
> > - * Returns true if the VMA is now detached, otherwise false.
> >   */
> > -static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
> > +static void __vma_end_exclude_readers(struct vma_exclude_readers_state *ves)
> >  {
> > -	bool detached;
> > +	struct vm_area_struct *vma = ves->vma;
> >
> > -	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > -					 &vma->vm_refcnt);
> > +	VM_WARN_ON_ONCE(ves->detached);
> > +
> > +	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> > +					      &vma->vm_refcnt);
> >  	__vma_lockdep_release_exclusive(vma);
> > -	return detached;
> > +}
> > +
> > +static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
> > +{
> > +	const unsigned int tgt = ves->detaching ? 0 : 1;
> > +
> > +	return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
> >  }
> >
> >  /*
> > @@ -69,32 +87,29 @@ static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
> >   * Note that this function pairs with vma_refcount_put() which will wake up this
> >   * thread when it detects that the last reader has released its lock.
> >   *
> > - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
> > - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
> > - * is permitted to kill it.
> > + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
> > + * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
> > + * signal is permitted to kill it.
> >   *
> > - * The function will return 0 immediately if the VMA is detached, or wait for
> > - * readers and return 1 once they have all exited, leaving the VMA exclusively
> > - * locked.
> > + * The function sets the ves->exclusive parameter to true if readers were
> > + * excluded, or false if the VMA was detached or an error arose on wait.
> >   *
> > - * If the function returns 1, the caller is required to invoke
> > - * __vma_end_exclude_readers() once the exclusive state is no longer required.
> > + * If the function indicates an exclusive lock was acquired via ves->exclusive
> > + * the caller is required to invoke __vma_end_exclude_readers() once the
> > + * exclusive state is no longer required.
> >   *
> > - * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
> > - * may also return -EINTR to indicate a fatal signal was received while waiting.
> > + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
> > + * function may also return -EINTR to indicate a fatal signal was received while
> > + * waiting.
>
> It says "may also return..." but now doesn't say anywhere that otherwise
> it's always 0.

Ack. Andrew could you append ' Otherwise, the function returns 0' to the
final paragraph above? Thanks!

>
> >   */
> > -static int __vma_start_exclude_readers(struct vm_area_struct *vma,
> > -		bool detaching, int state)
> > +static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)

