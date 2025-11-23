Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF11CFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 23:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBEC6B000E; Sun, 23 Nov 2025 18:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3AA6B0011; Sun, 23 Nov 2025 18:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2066B0012; Sun, 23 Nov 2025 18:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 222156B000E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:09:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA35F1401CA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:09:50 +0000 (UTC)
X-FDA: 84143416140.26.B32555A
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCCE7A0013
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 23:09:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uqYSEsyC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 52.101.52.28 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763939388; a=rsa-sha256;
	cv=pass;
	b=5l1UxGpzfZLjIhI7wW+lmwbnOuQdTE9QAZIH0ojDf+LEYUMmASvz/votNiTSp7TW37r8dF
	GyVDzbDV4AybfnqwqWsgNegMk7jml9bNcTz713SsI7jPgRbUFK13wZsnrjC8BYUuMZ8wQO
	UpGa3PO+IqtGcPPBc26teAZUJaw9DeA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uqYSEsyC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 52.101.52.28 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763939388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5A1qpW2XzGCuzqf6WgpG0xC1gUnaMstS3VyXPt6boo=;
	b=Yuz8k0jWNWKNeC5CU8CPsybRZPPFDop585qXDh/7hHibaa8inS+zc3JiAr/9UHIzZVTGmC
	AuACzK98Ev13nPM0WyEOetw0xI+rKFOUqEa9VGbjwWFJmxy+3Zf++TF6ewtxNdpQkOdMK3
	meGR+xrDESc8zITFzAeR+pTgTD0Y/dU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPEniEux2SR9THIP6z5jF0fC7aJyS/+mqP18jhWpKDZGQkzTBHLC9CLzJB+cmS4uCs4AjLPBMx1/u7wy6aqk1JjceySQF1lv5AGVjXNuPLjSH50pLe0uw+bd4dIWQ3YiK5LoUmU32BUMh/nEgadgdiFORApuJI2Qwfb64U+aYlEqGnEuloItAYyvz/zJRUZwZNHAlX8R/39lmzQvWaoTo80aZDilKmpkUvp1MyIOVap+HIyBjdu6hKhU7gvtIF1IB7lcH1hHumfnqH2Qk9aMBRcg9v3hpOEN1AP+zYRGDa2A5puUc3Lq5bUoba23StRYBuAhxHMeeuca2xgTp9nU9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5A1qpW2XzGCuzqf6WgpG0xC1gUnaMstS3VyXPt6boo=;
 b=tOBF5OM5n9YPLeFWW0UEX+9LyIvS+ZzxEAQ4E9PhZB3ViK/UznAscu22aFTFRZwljqARjgxwVn2UWD2riXeqXZqLw4h6eJ6j7sa99dFG6PxCTl5A81/uAXuRWbNf0/o8TppyCWbaZry9hJ2qH/1W2jucGbwmEqb+TMinKGFhzSGKf+lSkxBfiFbhkmuMH4tvWjq8EHMwo+A8nXvnKcEolRM/xanIRL9XNS/o7kHDt93/2Ad9CQJxUrfuJGtidT5RRVpIc3fstRVUzlYLW/KSRItc5N65aufnIryd/XvzM46IIsaYvfDx2yf2wllHNKV89rKOgg35fSt7DoD/S2FzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5A1qpW2XzGCuzqf6WgpG0xC1gUnaMstS3VyXPt6boo=;
 b=uqYSEsyCPtdpkmJMVH8Jm9Yf0sJ8jMMMTTTaCMc/n1DUZ1UTpPB9yqYGL5vAmciBjm12meYr6h0e6B1lIJc5o/8AedkOTljpPMVovyx6U7+Zuwsom/9Z/OTJ9k3f6hrBv4rc3L20NK5zhctNg8CM2LvQhMbWgRFhO+JUbKpm74qJnzHGnClm7AOKhbRpn412NNa9u9aVUmZwle88Xl9yjQ7LELlYBDOQ2Rp3d98eh+MWJgx/zU+dTfd1i6vC5XPEGbEDcPGB6LziDpJBi9SLObQsmUY0fIHJSeNuYpIGp5MN5A27D6dlTYsEnim+bmYMpNzDRlAaQz+rNqBHpLctaw==
Received: from IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sun, 23 Nov
 2025 23:09:43 +0000
Received: from IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7]) by IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7%6]) with mapi id 15.20.9343.016; Sun, 23 Nov 2025
 23:09:43 +0000
Date: Mon, 24 Nov 2025 10:09:37 +1100
From: Alistair Popple <apopple@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com, 
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com, jackmanb@google.com, 
	cl@gentwo.org, harry.yoo@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, zhengqi.arch@bytedance.com, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	fabio.m.de.francesco@linux.intel.com, rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com, 
	brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com, 
	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <c5enwlaui37lm4uxlsjbuhesy6hfwwqbxzzs77zn7kmsceojv3@f6tquznpmizu>
References: <20251112192936.2574429-1-gourry@gourry.net>
 <aktv2ivkrvtrox6nvcpxsnq6sagxnmj4yymelgkst6pazzpogo@aexnxfcklg75>
 <aSDUl7kU73LJR78g@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSDUl7kU73LJR78g@gourry-fedora-PF4VCD3F>
X-ClientProxiedBy: SY5P300CA0089.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::26) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB7723:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 77d7cf29-871e-4643-39ce-08de2ae56265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iORcL3r4SYCpVXyAIO+dXAWVkz8qzIogXcJanMZONS8QLrDkwsibT78ShPpF?=
 =?us-ascii?Q?m2aJc1/7a3nqGoD+6hDVdXuPvSOvulEO41y+hPDGZYdtr7ukkjH0VSjtsGPB?=
 =?us-ascii?Q?v1TNt/2T2KuUy+eYI51roM1v0EVyaoXReSFcz4zqI0l5C6ozNzjU0jLemMmZ?=
 =?us-ascii?Q?syPpqixcU2HegrOoZVFmXftYlnJPC+xZytHnskwRpJeIPdgVMXejkQfT2kBZ?=
 =?us-ascii?Q?UdRvuCo+OJQb6lVdirsUFHKkZkaTEL2vJ/JLJ8tOpxEO2/suz2z5sxrfkj0E?=
 =?us-ascii?Q?LaOBSebvNND/3okAOs9T4v0GZjA15g0SOq4E2SBoK434cKA7z9GnJFRKccrg?=
 =?us-ascii?Q?sya3O4p/ykjsUQ8iQnzibYIh3x5U8aPFLMYZ9LephaoTcleE5hgT+bjr3ELY?=
 =?us-ascii?Q?ahuStpmGkVkYve8suOEHaLjw6xqfaj+Nh+/H2DevK+J1c1mRWOVGs7eX9sXX?=
 =?us-ascii?Q?agLkq/erHSiDn07VeNqPYCp8R0bg04nqX3uEptn6uu5KTuX60wnY4SkedGHz?=
 =?us-ascii?Q?9Dw9aDa95UkRh3dKi9tXTLNw0u3GUyPWNtnne8QIfc5ICBtQAuQbVTalDEyf?=
 =?us-ascii?Q?1T04Lz+lBFrmS4Cg2iw2c50yzDOfJVveBVufw3hMf7gy1rwouui0yj0coLvk?=
 =?us-ascii?Q?0IlZxyM7uh+s2+yyaO/KJoZnTwXFH1/jLW+BPos9+0Apl8u6VFpNZ4nlLB68?=
 =?us-ascii?Q?zU+hJ9ik6RL6TVTm08bjJnygA2gh5JSlyxf70/1mP/3OVnp5DIX1GI6yAgu4?=
 =?us-ascii?Q?cWA3w5vzyxgJOOfeIVBCvhSAiivjRzHqX0UJ6U5P1rLT9Ohvp1k1HEuDj5eX?=
 =?us-ascii?Q?Q4+ODByAgEem/lzMP93k8xhTuzoyendmQ+ZfL4zYsmolOOU4z7+lPYrrs1d/?=
 =?us-ascii?Q?Dn9pdeXI7J1sVr5RD8w2lT3i5qJoL1zFkL2iTwqhJO3Jk3NWDPPg5PHh0Xka?=
 =?us-ascii?Q?mFUN/xe1CH6+9L/NxuyTUwki6ubelo/CrBMtM8TnYCGqHmXsCGHJ5NjJX9gY?=
 =?us-ascii?Q?c/uZzqjXF2cJs1lSqJJLOwaCvJ8A2xuM9NLd4bFRAqHctheJJdJ8gSrjFmrl?=
 =?us-ascii?Q?Q8Y6apvJOJuVeKiLQJ8D8DfuUHsqlsf44AEdeDSghbmc7nnRFXDB9vtf0yAu?=
 =?us-ascii?Q?DfxgMD4lJhHX9GGxu+owtrq0z0mh4HLEf+INcoDjEeEfxXtd3aZysWk99CHe?=
 =?us-ascii?Q?nPZlebEy96Fz79NXSwtVKEVNDW5xAso4TxhakMZnkt7IQv4N8E2xRcdJReH5?=
 =?us-ascii?Q?l9kv+KFr6qhh1GkQg+x33+UoCLypUU382Ua5do6Qqk4GWr3CuJqnhhkpTxXF?=
 =?us-ascii?Q?gevCRhb4ZcEYws+9Nm1E8w51/jBD+A9JfKsaG+05fnRjvfwED0p/NrUqQ/S4?=
 =?us-ascii?Q?pXds4zIlHyfpkStsRQmruaZfnPfturVhbovQJrc8tb2SiyVdDUnVrm0DELjy?=
 =?us-ascii?Q?y79GeGGKL3a0lkvgNf3W7b2NahOp7sOV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7723.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HE0Nkp4kCwacWzH/mWmywXOwvFeQQ56N1ens4/0bA+5zS8E2XWZ21gvYTAKC?=
 =?us-ascii?Q?xJmdUO6eYoMzeXluYFVzYuupRh/cAajleXeM9keBhBmDBl8s++u9X0YIYRov?=
 =?us-ascii?Q?Jdgk1G2dQbjOYv/C/zLGrPO0jeA/TKFGE1moX7noHJn7oIw4x4NO2qQ1x/pg?=
 =?us-ascii?Q?evNRhxZ1Zw2ohLayFu4W/GCgiaZyPP+/hyoQWbjUqSEstz4KMotZIz34+Tt6?=
 =?us-ascii?Q?nRpVtdK4ycA0FPZKGxYqVkIsVMTIFAxxQ/cKGHsIfn9wcoilS7HQH1/ut9IB?=
 =?us-ascii?Q?GEmyFNfhUK0TvkH3B/LsXvT1Bjqfw6skyXQ1Sowx5sPEJmrqgVaBPP4k/hzG?=
 =?us-ascii?Q?rDHp4hb30Hzj/KDX2nOJTdF4JVZlDsoHJqUBSEx6RzQaLr09weInRSgKRrf2?=
 =?us-ascii?Q?Q5pTQleaN4eh731IIN79551whPNFifah/8VqKUWmwWsT6LD+7JthB38EsLQr?=
 =?us-ascii?Q?fknnuQuYlwl4N2r8GpPj5nsv4R9uvo9V2ejVSqsRAtP2gBiV0akUfjbEDKjj?=
 =?us-ascii?Q?jSYakuwJ/CCcssOSCYVPrMdTbQS9Po0rXKjTwMWIz5ll0GVRHV41hUOt9fVC?=
 =?us-ascii?Q?CUOf8naLnDBBPQqRv5lIoUyVAwcwyljnjPRTLozIwIOkrUCzQcT1Hhfs5UTX?=
 =?us-ascii?Q?AETuWd1gulXdm8myub8jaapGJhDAKXYQVLMYC/Ng7DrPfMkJbGo4tluhHM8L?=
 =?us-ascii?Q?Sm1HkgJTGLGPVMC1j7MzpnpzsuB6i4y5zX0WIu4yGe7wk9CCmXC8mjAVnzF2?=
 =?us-ascii?Q?eY3teshaHf3/rIep2EOi7IRNJmIKOUo+dgWlRkq7MOGb4BS3uXD2Rt18SfXK?=
 =?us-ascii?Q?693GdgAayk4TjTdR1BTPinmoOU7FpTPcYHPaesh26iMKKHw1euJPoGFunYEX?=
 =?us-ascii?Q?WrQ97wpCOshnL3Ms0qiMczrRDAsrx5ZnYovPMTqyD6tRlBpJPa52ksDhMSYh?=
 =?us-ascii?Q?XzaPk5kL89HyKHqdPeMULDu+vmSGEB9arCO1wtc0xmEn2rTgRvup/SyGLhYF?=
 =?us-ascii?Q?3x9oY+QAEb+FNNbodAD0gu78v7L6lU5o14mcXi7Vtz0ltrAbSFqbaAhIfyy9?=
 =?us-ascii?Q?BNS7XB00DlQrZez/soy5a6tszsT0YW6NPiJmpLlm3JCG4zzNtBN3KYsNmDkO?=
 =?us-ascii?Q?ny+CS9Z5AXaICuePLFL/GQu+Qa/AP7qTNxMAfuidspC++Fe1E5aAcW2QUGOQ?=
 =?us-ascii?Q?XCwNdeS22BtBPEqhfg3nYRMSjAUtW1S5wzw/JLMtfOXCKGFElAu1e7XcRgJb?=
 =?us-ascii?Q?DA8i8RNmec7rTEN3s2to5TmP3Kx881jwmtVLKbpW070ae2crRTyxj+w1sW67?=
 =?us-ascii?Q?9bisjt8+6w3x5ZAcqwBii6p2w+cwMy7xjDfxJfVJ4Z1lLMx9vZQ+MGom2IU8?=
 =?us-ascii?Q?NASpy417OuaWmlTr+YK53xYSBLkVVgBiNAcDP7vzbW11BLWitKm56f2uKMW2?=
 =?us-ascii?Q?m371F8TiMbzjcD49lMOrKYZ69FNaAbvwnCd2dzpcFXXERTtbc02gQEBXtqxU?=
 =?us-ascii?Q?bEBpPDje/zI9BmQD2s0b6zXsZWQzMToAyoKAX1d9XV1qk/aTOMsKENjL2sov?=
 =?us-ascii?Q?fIChchNkraCOHK+jJIlWazUdoGXPX0EttcjBAhA6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d7cf29-871e-4643-39ce-08de2ae56265
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2025 23:09:43.5093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZ071WoQEJxyGb1/I/d6TqSksSJzXfg1oiSOvdEIDolZiWXOFBuDqDCJmczEfcOjSMXDsbyiBMhObydPjSYsNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CCCE7A0013
X-Stat-Signature: rpnuu17jhrzp7r6ykzhrbnhfipc4u87w
X-HE-Tag: 1763939387-14628
X-HE-Meta: U2FsdGVkX19z4SGGtKLlxgwCdywWzAA6VIqxmC5Y/Nhgq+VqWY+Lfp970JNzvCH8qXENSyYjkpCXnQG2hYnAv1+riOsVPIo7qIcjNZA2CxeWRc5Qc3o3wgBlcJCLvxKwbiqRbzMkHVRT17r4srUPi3VfpkSNFH4TxhtbsCgefDjkQCqGsJngFvZfTQAsSBUipMLP1NuRlq1VsivjtmdSvflNAlK2Gm2rhBMlhb6U2QTweLq3z1HlgpTTAflg/lfSHB9Dxwswl+SecS2Aqo+T+xrGWzPE/nMNC2r+t5BE0fyJG0WR7FLNZNi1s0i5GGLnNglUu8iou0Ib3T5xKAmbEfPYILL9/5h5+nigi0o5v2R9NhRUDrdtZx645/mEHuasqASaVILw7c5411Z188mRRlpiPSaZdGPgXNSVpRcbchMFLu2tTbhNEiLZtRmtVKKb50O+8AAdVPTctQ31T8kMHa1FwMeXHzZ9Bt8jTTvLxO/IWEiMMDqhh++alU7erKFQg19YgrXtdPpP9g7CTdmy7hY/wWXUjZdBK4LOrT7lntqIQ4/98/hIKEeZ7jeKhbg4RdCL+kFmJKdaReJmogWVXp9p9NjczNS29CzmS3qN0NNCX/OjzFcqX5aj+q+pJQRS2z6TzuhkADJkS7bzxvR7nyAtUHhl60K/6gdJTnVIA21PV+w2I9m8yGM6pz0/lliAVTf/+1GPJfidAn+nTDW5onB524+D6xdBX/9YjP9uJG5V+4MZVINwD19yT3uD8WzXW9juNvFnwfKLThnXTcyVw7XAYwEJK9/UQVivJKeJmpKc3ZZSxrTKBoeICKBuGhJeAn/FwYK3DdueXN8P4ojqQT+4ep50hzFu9M4nWCoGwj3NwuEIQNF5X5dmmHr0nvy7FP7gs1NgI/pRazh00Ht9SaXtSY3yRIoIlkYz8vMBA/NA0mWtdQVZDlnMEoLLt4AJuvWMDBGLLJWDjxLfzV6
 lczuAmGF
 9F922W7uyM7LJ1VtT9cAfn1BJ0FW9q89dZY2vFbV7tMpPGEguO/zkqfcfE4DRMLyKBNo3aEHwdyXYfCtDnP48idizT70/szl5EGKwqt+VQa8mY7PAaazFuVjEQ1kIWV5GxvW1TRW9HmxFWo2nGizCNcu5hD1oN4C0L6KeL5W1Te0gDOKJ8+Frd0NYvyH8w0NGNukZpsKPBAG+E54Aee8HVq/BXD+2a4KOcrXelH8kmYxaNAbKmEY64sIMrKAPCYXYYhiPgCbj9MtwtNYnSPKbwbCsdTawSyW1yZU0HK+BtBSYiVsq0IVzo5sRS8o7fqJMWVYeFd/x8i4MDcKMgMbm0RuNNReOcX31ooqjlhWyVyY37JEZOXsXkT33p/NS25c657oAfTsxLGhvPz270OH8gyyHM3IE1SiwvrdvfQl76u3yq14z5VbbCt6joDVdZJlw1SIIrhSg918WxeHZggSwYpetBEpAbJs7piJ8nyZ1requV55ep081zjk2XOxsc7cp02wi8VznRHblpwNooRnCc9x9mIvU3Q3iOFjA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-22 at 08:07 +1100, Gregory Price <gourry@gourry.net> wrote...
> On Tue, Nov 18, 2025 at 06:02:02PM +1100, Alistair Popple wrote:
> > 
> > I'm interested in the contrast with zone_device, and in particular why
> > device_coherent memory doesn't end up being a good fit for this.
> > 
> > > - Why mempolicy.c and cpusets as-is are insufficient
> > > - SPM types seeking this form of interface (Accelerator, Compression)
> > 
> > I'm sure you can guess my interest is in GPUs which also have memory some people
> > consider should only be used for specific purposes :-) Currently our coherent
> > GPUs online this as a normal NUMA noode, for which we have also generally
> > found mempolicy, cpusets, etc. inadequate as well, so it will be interesting to
> > hear what short comings you have been running into (I'm less familiar with the
> > Compression cases you talk about here though).
> > 
> 
> after some thought, talks, and doc readings it seems like the
> zone_device setups don't allow the CPU to map the devmem into page
> tables, and instead depends on migrate_device logic (unless the docs are
> out of sync with the code these days).  That's at least what's described
> in hmm and migrate_device.  

There are multiple types here (DEVICE_PRIVATE and DEVICE_COHERENT). The former
is mostly irrelevant for this discussion but I'm including the descriptions here
for completeness. You are correct in saying that the only way either of these
currently get mapped into the page tables is via explicit migration of memory
to ZONE_DEVICE by a driver. There is also a corner case for first touch handling
which allows drivers to establish mappings to zero pages on a device if the page
hasn't been populated previously on the CPU.

These pages can, in some sense at least, be mapped on the CPU. DEVICE_COHERENT
pages are mapped normally (ie. CPU can access these directly) where as
DEVICE_PRIVATE pages are mapped using special swap entries so drivers can
emulate coherence by migrating pages back. This is used by devices without
coherent interconnects (ie. PCIe) where as the former could be used by eg. CXL.

> Assuming this is out of date and ZONE_DEVICE memory is mappable into
> page tables, assuming you want sparse allocation, ZONE_DEVICE seems to
> suggest you at least have to re-implement the buddy logic (which isn't
> that tall of an ask).

That's basically what happens - GPU drivers need memory allocation and therefore
re-implement some form of memory allocator. Agree that just being able to
reuse the buddy logic probably isn't that compelling though and isn't really of
interest (hence some of my original questions on what this is about).

> But I could imagine an (overly simplistic) pattern with SPM Nodes:
> 
> fd = open("/dev/gpu_mem", ...)
> buf = mmap(fd, ...)
> buf[0] 
>    1) driver takes the fault
>    2) driver calls alloc_page(..., gpu_node, GFP_SPM_NODE)
>    3) driver manages any special page table masks
>       Like marking pages RO/RW to manage ownership.

Of course as an aside this needs to match the CPU PTEs logic (this what
hmm_range_fault() is primarily used for).

>    4) driver sends the gpu the (mapping_id, pfn, index) information
>       so that gpu can map the region in its page tables.

On coherent systems this often just uses HW address translation services
(ATS), although I think the specific implementation of how page-tables are
mirrored/shared is orthogonal to this.

>    5) since the memory is cache coherent, gpu and cpu are free to
>       operate directly on the pages without any additional magic
>       (except typical concurrency controls).

This is roughly how things work with DEVICE_PRIVATE/COHERENT memory today,
except in the case of DEVICE_PRIVATE in step (5) above. In that case the page is
mapped as a non-present special swap entry that triggers a driver callback due
to the lack of cache coherence.

> Driver doesn't have to do much in the way of allocationg management.
> 
> This is probably less compelling since you don't want general purposes
> services like reclaim, migration, compaction, tiering - etc.  

On at least some of our systems I'm told we do want this, hence my interest
here. Currently we have systems not using DEVICE_COHERENT and instead just
onlining everything as normal system managed memory in order to get reclaim
and tiering. Of course then people complain that it's managed as normal system
memory and non-GPU related things (ie. page-cache) end up in what's viewed as
special purpose memory.

> The value is clearly that you get to manage GPU memory like any other
> memory, but without worry that other parts of the system will touch it.
> 
> I'm much more focused on the "I have memory that is otherwise general
> purpose, and wants services like reclaim and compaction, but I want
> strong controls over how things can land there in the first place".

So maybe there is some overlap here - what I have is memoy that we want managed
much like normal memory but with strong controls over what it can be used for
(ie. just for tasks utilising the processing element on the accelerator).

 - Alistair

> ~Gregory
> 

