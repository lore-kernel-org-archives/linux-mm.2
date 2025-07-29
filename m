Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B92AC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:40:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195C66B009D; Tue, 29 Jul 2025 05:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E786B00A4; Tue, 29 Jul 2025 05:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EAE6B00A5; Tue, 29 Jul 2025 05:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E45BB6B009D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:40:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7671113BFA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:40:28 +0000 (UTC)
X-FDA: 83716806936.22.8434DA9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39D9DC000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:40:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdlMzfhU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="N/7raRWY";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753782025; a=rsa-sha256;
	cv=pass;
	b=XGEsNEHDlAHNvFIXoVWQUMTv/cfRbEQUanNo1608or3sm84Vx1DQmINDl0fOlz6ilpZ8g0
	SnNMZJ8EZym2PPqgcKlsmL7wv7Gk3oVl9tgzTZKeCRkDwXAHVezjWkAZ72TmEkRSGSpbkm
	D+uAgeEIasqqSyL+aN9GPpRypH4DcUs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdlMzfhU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="N/7raRWY";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753782025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeyHgETC0Q6G4Y4EcOeJmRkBO8PrNB4d313GVOTa5s0=;
	b=DAjWsC916QKH1diLyXXdpogra8kB01kekHK+bfmiKrcgOoGY0VHXF+dNQs594tGhNwpFd9
	vdgJFImCozRsLcSAR5AvqNuRRqTDJ7AWaxEnr89ErrkKGGCzqs1Km525TFhtnx6824ekqk
	49EeznaFKthzRA950QEKhUXBXAQCWm0=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T7g4eV019295;
	Tue, 29 Jul 2025 09:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EeyHgETC0Q6G4Y4EcO
	eJmRkBO8PrNB4d313GVOTa5s0=; b=WdlMzfhU6eRvlDV4/B5OLVl5dSDTZIIhu5
	1wIjHgc+fI04AD//Hhud7rzH5YOxGfMl8LuA49IZX6cBymb57+LTyi6YFH0m3TlM
	4iy5bs3bV6MQ+IsWRgDGkQDO90LbRGDsGWdpGgcsVHHm8irhnwnYJBjbd+c211fj
	AOhlaDQwWk65P9AY8GmyWkmlT+pWCOWahbVQwU7ef/RqPuo7qfUKTiopeiDJCcif
	yutcNjyD1bcaTDqIhXJz2N7RHQjnd1xCzq5rk2HCK7prci621/qtFtDupQAAEu2J
	a1QmlIIthEJsvw3j+l+QQ7quKAU9D+ss0Z/2gvFvs4Tv/Ej2mkKw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wy6uh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 09:40:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T8g1Xd003188;
	Tue, 29 Jul 2025 09:40:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf9q6pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 09:40:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rh07clnSovZ9X/G2CKuc7aO+aHoYMQ7+pk2BZ5KUwecagIcPr1YXPv2cEXWAmVjFDoxwm1aNRW1jmcWHd623MuXrzV4TJqrApB4hd1MzGPICCoqtgqCNgyTjLw1E0Bga2RvRPBZ9mV6ZVJ716AKmzFL5RRGQaj7/uUyNjqBTJHwJhWCg3yHAJ6UHyPe5NgaCCnMJY/jshK4XCfliHk2AVyHF5Kl48imJ0RHg5ouzgTaRj8sVYIk74MQBMUFFPVKmid4rvJrU63R+vxMw1mYUoJgdMpe+D5ODLmcwtkzWGEc+C3cCi7lirvqwPPEaZyzHdE/GZLSHtdgH7TG69MP3rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeyHgETC0Q6G4Y4EcOeJmRkBO8PrNB4d313GVOTa5s0=;
 b=lQuf85BD7bOYgJJzoFK2JWQf4PMZjWw6g9hBqqUsy+7ynPBinvq0t5K1m3cFXP48OIUf8EwHh4gTT1mVmzS2gTmr3Y51vkXnC9mBk/PYPX92msHJsLxrys/096tOvgaNR468cu2ala4oxtDV8oGc6bTERDO8uIP8jKHtsA1Az92EfgjSgJsumNeiOBzPU0pZeqgKnO/lV6TJtqtb9E2d0kb2SQLm5ROBoLXmsN1mjCoar3C0zwf5u5vhSAV2+fC4fUvDn3q4ncsydATT7721Mhoi6vDiHhmrADMfVSm/B7MjaZsiuDTEHGympGFzWBZuCYO7KjwW2+zbOdhN4hngmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeyHgETC0Q6G4Y4EcOeJmRkBO8PrNB4d313GVOTa5s0=;
 b=N/7raRWYQ1pyrE/UlSz/hveHshzr6JU8KvWJ7QWcXVAB8zDb0HdDZM+dtqZ1sxm6Ax+GF5EFdQqpvqOJ6jMOuZWbRCY7XYbLTNpljHzRIcEOHsXMqym44RJeezZNy7HPtlN8QUabSwZ4TTBNhBSsuo+XjYERmWswhW7wS8UMeiM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4632.namprd10.prod.outlook.com (2603:10b6:510:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 09:40:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Tue, 29 Jul 2025
 09:40:14 +0000
Date: Tue, 29 Jul 2025 10:40:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Jann Horn <jannh@google.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Pedro Falcato <pfalcato@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, damon@lists.linux.dev,
        kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v2 5/7] mm/memory: implement MM_CP_DAMON
Message-ID: <5acc6af3-91da-4dd3-834c-e8923e5d3320@lucifer.local>
References: <804015e3-78f7-47d8-b887-434f0f7edf8a@lucifer.local>
 <20250729030632.1829-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729030632.1829-1-sj@kernel.org>
X-ClientProxiedBy: MM0P280CA0070.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::29) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f625ab-1ff8-463c-2b13-08ddce83eb68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NpDxGxNx8s/3l2SoaaI0FymVGlIM+ALG+Ot2UASjmG27hbtPnghXZZZqwXik?=
 =?us-ascii?Q?bKmRQX34VsNEX6+GKQw7v+wxb9QC9jgQJyCaTOPrMaFbeCTflRZJZhbhF3MR?=
 =?us-ascii?Q?0+t6GD5msLVvwcoN1Gw6uu/sVqzXC2BekTgHLqfc5jmx6VmCroQOUAse1AVE?=
 =?us-ascii?Q?nEJ72hWtBmjyYJCM8pAEPMQ9eE1xXgK/6KBg6iIemV1jRy2jQUX64VIhhQRt?=
 =?us-ascii?Q?WI7+GZpcc3kg3ZpRtnjVx4e0vlDsYYwAZUFN4yXbfIpI6KjjHItyO4Emm1rj?=
 =?us-ascii?Q?llk3KxQmxMsKutH2bhL41VIMi9/7By+5pMwawQxdEC9bxncVy7Bn3BeTEI98?=
 =?us-ascii?Q?f8W271X8ni2mqI3L4wIxR9NwJ4vfP6+4b2nFbpBR31VS7/3v52TvYkKRYY0C?=
 =?us-ascii?Q?YlLNe4BTnp3eCL8IwkfUK4MFlxOPkg4HHc437ZiltYxK1u4vGD7JtwhAcifn?=
 =?us-ascii?Q?WM7TDs7NNENY/hvduZF64N7MOmyaPfHPGjHOAQNmzfSuBtQrbgwrVXsTZNSc?=
 =?us-ascii?Q?bRRcjhmqE8aEeU10iUtZO6WMYEA6MKDMRNJa1kA1226owO8zKpcoBbQS6RDI?=
 =?us-ascii?Q?KFhykIhKPi3GajSCfuTckPmfu0ALLSr5vUPtu3lLd1Hi1rDfTH3xEep71TVz?=
 =?us-ascii?Q?7K1Lsg2/hJuUCIAGTHjiheIZWjzfNgfh8zvW0Q+HWN7T/WCSMGNjFWEtAr+Z?=
 =?us-ascii?Q?i9tAWnDUNoWq1djeMmjsgfzg7NG6CtSIBYvG1ZMNm4PTHeJOwXNTWXCPgrPN?=
 =?us-ascii?Q?LLOyvw4vfQQiJCL0988IbHf7csJIdC4IAIXu9hi5IO3FmpvwgTF6nJig94Ok?=
 =?us-ascii?Q?5TrZ6ewhd9Bg1n59EGDuu7ZmAENLxB3vAN4l9KErkuP1iWtWWwldx7/yatl/?=
 =?us-ascii?Q?m6aysJ9dDwCQpA5jsgnfcG5dbCHRn/0my3fQLmzDZR04QTYtoIFs3vJ5zcfV?=
 =?us-ascii?Q?MxY8YGD9UYAId9xmGOWvVNj+NBOr9coCWCHmVJXI2swLpH+yVEbwRMradQub?=
 =?us-ascii?Q?noW5H/my9zTgv0tFCXPd1iCGvghuW3GibrXWibACtTCTcApf6vdSrHLAGRx4?=
 =?us-ascii?Q?DKbadw/PF/K1b/xV14qTPUJd26uh1JW4xoF/ycucj9MmpvEW1wqCLPuiTaKF?=
 =?us-ascii?Q?vfWgObBsNidFcfQ8RprcgVDxIzSFnk9nYueVozBKq8NlOoyfjyMJ49sULVIO?=
 =?us-ascii?Q?JaL744ANQHg9qbDuXAiTH7SUdIzKmiYuH6UBcgx/3THyMa3chOTDz4TbFCvi?=
 =?us-ascii?Q?ZhOPl57s6zS4dOy0DstFLOV9ibmrUwvuowQwKJHPEs30ZyHxmlyPE2Hhdnf0?=
 =?us-ascii?Q?awnkP6v59qOBS9TLPlblInZ0j29KgGCHPVck20+TRV+TFZEL7kJfKSsoEefr?=
 =?us-ascii?Q?irTPxP5pqoti+thiSvy6sdhxMr0XH8mZ4MLJ1Km902acCw7MVt91SfcbSfUT?=
 =?us-ascii?Q?zRsv+649+SI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DO39zIBLUUnzLhJdaBEo030CQsNS+SOZgrmBPyQRGW2WoeKDgJv/g59WBxMO?=
 =?us-ascii?Q?VCDZomhSLAOS5icRVLI5qyuo1S0G/UMhlXJSRsoSqG+eM4pzYCrlT9Sh9pMx?=
 =?us-ascii?Q?UYczMg+p6cFCxw1juSEuMNkrGJwISezN72xVJ1yOWlk8uZl7U3Ku9bLbPxju?=
 =?us-ascii?Q?5lkMHy1th0pFbrdBpIEPxJOY5yvPZsw0tNkgEiuMCSH6PlQu1sc0FzD5sw2S?=
 =?us-ascii?Q?AQbUPdpLtoL7QF4mVv2ktgDsXsGMVxUlpMtN3XAM67A7/k9wCyV0jJ8kujOU?=
 =?us-ascii?Q?RUJ9ZdxfCKFIrnmoIt0W+2CGXumAhHmuFOKCwAy9C985TYvm2yo4oYRvZMfm?=
 =?us-ascii?Q?v216ts8znor8yXkrfAy5pQ3K/TT/O7YrbhX+jGvBSnD4Lp/mKcjsF/COTQ1a?=
 =?us-ascii?Q?F9x0ZnyRBfk6SeW2iYbGzIHhjcc/2AyUlx/U3gfG1pbAcW8S8JjGT0Rd1T3R?=
 =?us-ascii?Q?wL8uTqnYwSPAWDQhyQGrAtnFLRW/zwJ+h0obsrvDvUTB3fMGJ8ki+xpT3vHj?=
 =?us-ascii?Q?uBzadixry94tryEdgR9lnzMrjGWzML8xyh5+pwSVVEBDMRUxHLQp/ejcgno9?=
 =?us-ascii?Q?6h/Nc38znLbitCmIfVx0shKUJTbU2Qyc66meb5CkxK6soMejaRRTTU7WOUf0?=
 =?us-ascii?Q?r4PEOkvjFZ0AxXVaz0PuC0oRsBs/OIHZWlaXfemb4Rkn+S0Bpbl7XVNEJI3k?=
 =?us-ascii?Q?+RTbju8xSJv2L8LdTNl1ZwnU3gRGnJnDmE/ZL4iFwRpiLzdw3I4jx9tr7smB?=
 =?us-ascii?Q?FwkFc2veFUqCOe7jQngsY81lfUWVvuvxGNPrN75wxwEAVtinWtT8iVYp9v1q?=
 =?us-ascii?Q?uSzh0oBsdk2qfdLpY9rVqmo1xmDcRDw4WpbRFk5zKI0hAM3OOdSGL6G/1iV3?=
 =?us-ascii?Q?D2n8qhRyYEac6n+62l/ld/rKp9Y+LZzezFTcULnuRqoC5fj/QEqlFVu7DN3i?=
 =?us-ascii?Q?Kz4ua+l7CAUmGP69csv39BH8aBmZHteTRS2LWIjzZwuJB5twZvy4XJQVgpuw?=
 =?us-ascii?Q?ev+2991l4SvM3HFSnBjJB/rIDBai/bkCCU5V1m8R52YZQPFGFhLusZr1dDCO?=
 =?us-ascii?Q?JfBZY0poCzpqpEDh6L147j2msjPdHO0Oa7WGjRsPJRO9CWTlzsy8cWMkXLrv?=
 =?us-ascii?Q?W+KgSU+p+eM7BI6f+7aeZVSAxCX5VOIX1CQKEYeLZAiXtb21ztb7s2K1ow6e?=
 =?us-ascii?Q?9NJc0YYi8IW1b05Cy8mpa5mSB7e/3nPxyetHWSAGGHofU8b1p4/REfV491TM?=
 =?us-ascii?Q?0B7nMCnYjIOif+XkTmBzdp0n/1fHKA59b60rd7nQgoMn6urbL2KlVtIYnEDt?=
 =?us-ascii?Q?XbLC/JOVgyWSL2NNI68LpbXTauXhMk+CnRGczqgCgHcjfJcUbiHZebL7lNSE?=
 =?us-ascii?Q?xdBQCK5lI78Y1qtdS6a5THAFfZZRywFm52lFnJcsoZwvSUfNJcn0pcxh4DNH?=
 =?us-ascii?Q?0qM9azVYGuldUm1aRYL3ts4INNjcpAYJlo3q7cxzqO+Sn7Pj9+SrA6D5X0jl?=
 =?us-ascii?Q?LOs0KOBIH/HE+7rwFOKDTbMB3TXz8My7PwnXX5pXtsn9GmYc2OOh9a/1aMsg?=
 =?us-ascii?Q?D+FudVjAMo1qun7WstcxWW3GFEnrn/fn3+jp0u52RuyxxEn2jN7tMssn2dNw?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	21r7S+cATjTMlCFSyr78Zt1QR7n31YB7TimLgcpTpptMwRs7R7S1AABTDWq7j2S8u7udiQ/VYg/17inTdqfsQwZJTbX/mkkuF+Gy3Aa+shGx6IY7yhIxGV79Nf8LQXMvuD1SdA2ygS9jU5wDNS+XcAMWNAzXiM8wvqr4CsUrfc/7sfSUX4yRnHFPD0ClrmiK4OyXV3vOOM211czeeD9puUvvu9OH36KraKXK6Co555LiVG3U5s013mvsFLLHfmV03nZXoyQOc1xpwBVZtw/kpYYDkRBd9B4dvzLCV2I+J7NWvQio6c10cK8tA4pXIeQKIZ9At0qxPcuxekgm1c/ViDTIaB9JU2D87hYAsESVzzIIzVI+id2HlspbHHWQ+kpYVUqGoSCDC02yjxbiQkNmYkHd341+AgC64ZDN0CJK9vdK18gddBiIr0Qvu4l5gt7rjW4NzJU/EFABjciZw0e3eLvO5ES6t5dV0GbTmCJl8HRi2yhi4sQu18HqWw+IEudNoIbRWMv6DtpuAB6UP9/oBzC8uB8jlQ+IEd9W6gRuksOsZ/b8VzslsBphFvXJW+5jx9KuMaAhGjAb2DikHIaVj8WPIVFWlAxj4ey3bDljfAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f625ab-1ff8-463c-2b13-08ddce83eb68
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 09:40:14.2807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: awoVzropgm9r+L11yh9TT71wMtu3/vkpc6n5fy344FPTYjTeIuzpv1h0lbqaaEG5a5aA8qccohaNskgEhNAwbwZxhIUSoQ5yjQ4KcCraDX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4632
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_02,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507290075
X-Authority-Analysis: v=2.4 cv=X+lSKHTe c=1 sm=1 tr=0 ts=68889701 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=8F-zHv54P7vgx9dLVQEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: YOIkyssnE8pSpIiTKHeuBanrKKLh-g9T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDA3NCBTYWx0ZWRfX57fhSbAumTJ/
 JPIJMw3SfhUQO17zRc7ydj137GswarTpOzghDhRC1DfTFWjt/cJ9GFQxFYkcOWV2mpyZHWA+KJm
 avOkTRuMMO23LWz8hOyi3nBTY9oPHrZ3LYg2N2KBWGT9qP3L19tQr8Faem78v71N7MQuLgN37mq
 q6WimpJV6hwWRu7yG/TuQHghtI7MIaAaBXXFHoqG1SvyN6N6LvnkOIdcVkKMFibG18TIAfWRVvf
 DslZMW9dhz802EZYXoKgYCUD70dh8wd15He8g+vyC/iefq0wg7yrSV9DsBurvFz5P4QY0tkUcSr
 6/JUtPC/kHTYVQZT3CUa66seENFULkL/i+Dc5RNdHD8Sg14fJPpQjkfpaQW9AjFDyHRrE3fQm+w
 HYmctH/R1gGDEyN58dhNzRjEL2+AYoLjN03E2X3mYTiKtWnzzfNKc9u+8fPrds40oBAYsiVv
X-Proofpoint-ORIG-GUID: YOIkyssnE8pSpIiTKHeuBanrKKLh-g9T
X-Rspamd-Queue-Id: 39D9DC000B
X-Stat-Signature: 89n1ctwxwft1spbz8wkkyeh5p4aeafit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753782025-987898
X-HE-Meta: U2FsdGVkX1+gyH8soKJQs7mUF4hR8n/CCXdpn7ziBLe01Ozuk32/AKaFX0/F3MPFG8gvP6EfrNXFQmuDaG29gW0WKx+Ryjs9l5UjL37Y11TdwsY+E3jtOgvDdTN+a7+Ww0jqsRgJ7F9pG2txU8y0lov+zb1FTkIUn+KgSxLub6K/Tl1tKgrONovBNioWShyNV+Ey3VxMqyf1b0lr/iaK2A35JyLGZqCTb6gKeFIy9iIO1jYilc4LtTXQ8izCRJn8FufbaViflWhCy1MGyO78Yv+/s9w7vpcxCyF+cq90Ot2pBIyM/KNrL5klE04/ViNWpvgwwKakPj4VfmauJ3NRXfg8ryQY9aVyNlH4x/dTD/uwgTvvcxSC3Pjsu0SJfwWubx+8TF1pIIClohY1qNSaageiTTfUqgO+u/Y3SKaDMNL0fmm0rg37cD6MEhia0z5i9k8YLAa4gmqvBUiadMglXAudCyuWk5gkqcJbMCuGuTKIYudDq3qcCrZJbzk86bBig6ZQG/4HI1P7hH3l2/3VVFH9dlRrF9YL1nch/50E0+1i0ohjK9w9OLPj2Lg+nju4M6mk0FfuuhUEYWVxyvrKCqJStvO0wlsiRCqQ3+Ke+pPGKitotbfjT7QgcUkaCv+VTE4YDP0FXPclVVMMN0/opyGY2OT8ze8ZMNXZqtAps5DaOqKIkBkP2FMnXYIdo3qTsdVDP3TJCLT0TOFNeZ8yIo7X3bWZJwRKUlqJRy0dQrRiAGw46CefnLlX14B8qPHVYvwmW7+42Pl0+KIXXnPyvPcPaKwgLFhB/Aw0TYSl1PQe1+cgvZbQeVBXtpOJlhxZBJ8I95Mv6nvY8lTsxqvTTkvY2m86BnQrfJUOFvJFCgEMyEGvdViu0cT/KHDUxji9cwOOQ/PF6Zk0puwpNRkonBatdNzTysao/lrBgkQx63H/ogXyPqp2gpw1LUOh621ZnA5s4tSPS+4ehT956Qi
 vIR+yANf
 YIe+32JbnKmlMlgwU9Xx8MDZ1C1fBM8APPqqBoyh1hgVKRICWUSfDPeeH2H2JzSFozDPsfyMgFvn4t5rvcYgGW4Ys+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 08:06:32PM -0700, SeongJae Park wrote:
> On Mon, 28 Jul 2025 06:19:35 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Sun, Jul 27, 2025 at 01:18:11PM -0700, SeongJae Park wrote:
> > > DAMON is using Accessed bits of page table entries as the major source
> > > of the access information.  It lacks some additional information such as
> > > which CPU was making the access.  Page faults could be another source of
> > > information for such additional information.
> > >
> > > Implement another change_protection() flag for such use case, namely
> > > MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
> > > To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
> > > protection, pass the faults to DAMON only when NUMA_BALANCING is
> > > disabled.
> > >
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> >
> > This seems to not be an upstreamable series right now unless I'm missing
> > something.
> >
> > Firstly, you're making a change in behaviour even when CONFIG_DAMON is not
> > specified, and Linus already told you we can't have that default-on.
> >
> > I'm very very much not happy with us doing something for 'damon'
> > unconditionaly when !CONFIG_DAMON on the assumption that an acessible
> > mapping has PROT_NONE set.
> >
> > This change makes me nervous in general ANYWAY as you are now changing core
> > mm and introducing a new faulting mechanism specifically for DAMON.
> >
> > And we are assuming that NUMA balancing being disabled is not racey in a
> > way that will cause things to break.
> >
> > I really also dislike the idea of an _implicit_ assumption that we are good
> > to use the NUMA balancing faulting mechanism to 'tack on' DAMON stuff.
> >
> > Is it really all that useful to provide a method that requires NUMA
> > balancing to be diabled?
> >
> > Finally, you're making it so DAMON can mprotect() something to use the
> > DAMON/NUMA balancing fault handler, which doesn't appaer to check to see if
> > NUMA balacing is disabled, but anyway it could be re-enabled?
> >
> > And then now DAMON is making stuff fault as NUMA balancing faults
> > incorrectly?
> >
> > This just seems broken.
> >
> > Unless there's really good justification I'm really not inclined for us to
> > merge this as-is right now unfortunately.
>
> Thank you for review and comments, Lorenzo.  I fundamentally agree all your
> points.  I don't aim to merge this as-is.  Actually this patch series is more
> like POC, but apparently I was rushing.  I will try to adjust your concerns in
> the next version.

Thanks.

I do wonder whether we really can have a whole new faulting mechanism just for
DAMON. Because if in future, we wanted to change how this worked, we'd be
constrained, and it is a very specific user.

The issue is you need the PTE to be restored to its previous state, just like
NUMA balancing.

And I really really do not like this 'oh if you turn it off you can use it for
DAMON' thing, it's just really odd and asking for trouble.

I think the only _workable_ version of this would be to convert the numa
handling to a generic 'fault then restore' type mechanism that could be hooked
in to by either NUMA or DAMON.

But really I think you'd _need_ to not have significantly different behaviour
between the two and _not_ constrain this to being only when NUMA balancing is
disabled.

But then you'd need to know _this_ PTE is for NUMA balancing vs. another is for
this stuff.

I'm not really sure there is an upstreamable version of this, but it'd need to
be made generic like that if there were.

I think it might be worth taking some time to examine whether a version of this
that can be sensibly generic (which could have hooks for things) is _possible_
before sending a v2.

> >
> > Also are we 100% sure that there's no races here? When we disable numa
> > balancing do we correctly ensure that absolutely no racing NUMA balancing
> > faults can happen whatsever at this juncture?
>
> Enabling CONFIG_DAMON will not automatically invoke change_protection() with
> MM_CP_DAMON.  Such invocations will be made only if the user disables NUMA
> balancing and run DAMON in the reporting mode.
>
> So there can be two racy cases.
>
> If the user enables NUMA balancing and then disables it after a while, page
> faults for MM_CP_PROT_NUMA can be handled by DAMON.  That could look odd, but
> there should be no real problem in practice.  DAMON's fault handling will
> cleanup the PAGE_NONE protection like NUMA balancing, and DAMON has no problem
> at receiving such additional reports from MM_CP_PROT_NUMA-caused faults.  DAMON
> may show a few more than expected accesses, but that's no problem for DAMON.
>
> Similarly, if the user starts DAMON in the report mode, stops DAMON, and then
> enables NUMA balancing, faults for MM_CP_DAMON that installed while DAMON was
> running in the report mode can be handled by NUMA balancing.  This should also
> not make real problems in practice in my opinion.  NUMA balancing could see
> more accesses and migrate pages little bit more than expected, but that should
> be just for a moment.

I'm really concerned about these.

We're now introducing unexpected behaviour based on a race and allowing faults
to be mis-handled.

I'm maybe not as confident as you are that everything will 'just work' and it
seems like we're asking for obscure bugs in the future.

> > You really have to be 100% certain you're not going to wrongly handle NUMA
> > page faults this way, on a potentially non-CONFIG_DAMON kernel to boot.
>
> I will ensure that never happens on CONFIG_DAMON disabled kernels, in the next
> version.

Well, in the above you say that you can't help but do that when a race occurs?

>
> >
> > Keep in mind fault handling is verrrry racey (purposefully) and can be done
> > under VMA read lock alone (and that's only very loosely a lock!).
> >
> > This is just, yeah, concerning.
>
> Thank you for the caution.  DAMON's fault handling code only saves the
> information in its internal ring buffer.  It doesn't touch vmas.  So I think
> there should be no such problems.  I will add the clarification on the next
> version.

Right, I'm just saying that this all being super racey between NUMA
enabled/disabled seems pretty unavoidable, but we covered above.

> >
> > Secondly, somebody can disable/enable NUMA balancing, and thus you are now
> > allowing this function to, when somebody specifies 'DAMON', get NUMA
> > balancing fault handling??
> >
> > If you don't bother checking whether NUMA balancing is disabled when you
> > set it, then boom - you've broken the faulting mechanism, but even if you
> > _do_, somebody can just switch it on again...
>
> As I explained on the two racy cases aboe, faults that caused by DAMON or NUMA
> balancing can be handled by the other's handling code, but only for a limited
> time under the user's controls.  But to my understanding that should not cause
> real problems in the practice, and users wouldn't be suggested to operate the
> system in such a way.  I will add more documents and cautions about that in the
> next version.

I really don't think a version of the code that results in the wrong handler
being used is upstreamable, sorry.

I've not dug into the nitty gritty details on what would happen in both cases,
but even if it were 100% fine _now_, this is _exactly_ the kind of thing that
results in horrible hard-to-debug issues later, should something change.

Implicitly 'just having to know' that we might be in the wrong fault handler
seems like asking for trouble, and the RoI on an optional profiling tool (this
is not to take away from DAMON which is a _great_ utility, I'm saying it's
simply not part of the _core_) isn't there.

