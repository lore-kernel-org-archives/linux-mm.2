Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D822CCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81566801A7; Tue, 28 Oct 2025 14:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED3680199; Tue, 28 Oct 2025 14:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6681D801A7; Tue, 28 Oct 2025 14:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D49F80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:10:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF32212AC41
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:10:31 +0000 (UTC)
X-FDA: 84048313062.19.3E8E024
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 629B4140012
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:10:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=po1rIMMJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W+18pqLH;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761675028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGuNKa+58lXrKhPnENNAjO7M9LmcZgLg1FqZI6atYrw=;
	b=hXfaQvJ+2mdWm2CJuViPgEy7anwd0EU07qhJ9wLyEbFA6oavd/Rsk1h0jf/yLrpGnFmbTV
	rkqAeExRXMAnSatQyom/M9a7KQTERsVUMXt6hqG/QhVGAd3NSiE+o8BObJ6CPF3kjRdXbI
	dY/YT8BsD9O1fXLejXR10DswVcri2og=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=po1rIMMJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W+18pqLH;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761675028; a=rsa-sha256;
	cv=pass;
	b=JbfERfvaFJGJBpsXCCMlN3LcxHqHH9CSGxOjD4ADehTX8WzW+TE2/ixuTplMDxn0x/R3kN
	4sH/0Ihj4hzaGhE+5gkOyNlmSwiSiXtOLswt2zceux5W1FzePqGL5rxOjSNyMBkTDf0Uu8
	MRnEmcsUCnaKTI6nquUs6CAFL/p8NYQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHJIX6024430;
	Tue, 28 Oct 2025 18:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mGuNKa+58lXrKhPnEN
	NAjO7M9LmcZgLg1FqZI6atYrw=; b=po1rIMMJ9uj4Qy/gbotxFWTrNpzrjDMejA
	3OyPCJDMq88ZP3o+tp3NQlk/frjFVJzYVqoMwNibu+r+j4AsrmjbIFq6iU7c+xMZ
	atwDgRWESmlUlVP1VXd4fMTptKpxgsYZK9HxMOJBuiSDo7XFWJA0H3wr04CHT9Y1
	IaVydL+GpJOTL61OZznBd8gLhYE33tRuV/SIaXI3SrO6N77NoIpH4yv++6KCu65Y
	h6GtFpyUj4yuxdhplT72FAffVxL2AqK9qPxJiD4gpJv7xpbgI3Oi+aojqluePvyc
	a5YfxKOCYQygxIDZNX+G9DE/3Y6SDVLldzDCfs0mY9DsezB3EuKw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a2357mary-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 18:10:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHADwD024898;
	Tue, 28 Oct 2025 18:10:05 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08t9mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 18:10:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqsMU1p8BTmLcnjk+59ddKec7uhx1NPkzmbvPtdrhoXbZuBXwKVwkVOFVqXeU+o90IyVkEH5mH6tmdOVShv4y3uoWIbnM14NBV95UDbUqoaSxdnGzl+BeG/V1rAMF88aRrwka0OPhNaAWC7lZ14zFVTFXiYX+otd2TV/YLrKcuGdh2MvLfCpOtON7YWIeFCsd8y2FMrbCy0b3DFtszdhUR80tz7x5jXV0zBW84xEXZax/wC8AhDn8yztqvaEzbrRowncXc0uTVLp7u2XbZmlLvEJNQgoSiu7Kw/hKI5z9W54BIlQxI0piW0m0SS1QJgKjMBUlo6fdrF4fYxX+RyA/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGuNKa+58lXrKhPnENNAjO7M9LmcZgLg1FqZI6atYrw=;
 b=wJo7560RezTHev6SSf+mCImScMMb6zegQGDnd+AG0VFEHat55Z1WAZP1hgPCgGcfu6qhUKDK3OHjsQk54AKJt1D/UgEz4OONF7PDAjnIctGZ1cZGrUhfF9h2UvnD4/zOeGdnSjow+r9OnEYwdvQ/LsDLObsxdDlNmRIpHCoFPwt7Pb2x3360O7PTKN/zqMIlBYMIXdWY2PZm9Tt8FKhrJyWhGR7LBh45vYDDfDla04diYYXkDxtDjjyly1IcuFwDWq/FQdyOama47/xFthtiDsw0MTiLV+XT0Gnig4ooCfjTLrOPWBVT/r75DH8Wa3FoqxITQk1FsquIqCsOpqaYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGuNKa+58lXrKhPnENNAjO7M9LmcZgLg1FqZI6atYrw=;
 b=W+18pqLHGt9NZIy7cn3dnof0V9qlQzdlOMcNyrhSHxjiEWO06aIjbeLX34NFYbpWrlE/o4WEMvp90k1Aqp2ET3An3MPxua3PlxAHnRJ1t2JB4iFBm/UOsdACFpn590ZsefhjpzmD3QJ5d4ALYwsKVQgiKyWXrUeJ7uPk161zdXg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7419.namprd10.prod.outlook.com (2603:10b6:208:449::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 18:10:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 18:10:01 +0000
Date: Tue, 28 Oct 2025 18:09:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <64b9a6cd-d2e4-4142-bf41-abe80bf1f61a@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
 <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
 <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a89e74-1533-4a83-8d0f-3f4821750e25@redhat.com>
X-ClientProxiedBy: LO2P123CA0088.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7419:EE_
X-MS-Office365-Filtering-Correlation-Id: a1a20c4b-6eb6-4b52-2206-08de164d363e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sCHmSVFFIOrVJKem7JKCMicvFQKX3Qn9ArghQu+P63+5yMclZeQ2Lp14sMxU?=
 =?us-ascii?Q?hqONY5+F6izzEDCFdo8SxbO/9PjnhCylObJmPUL+hWjbs2ZqTlWP54nXyKBm?=
 =?us-ascii?Q?ZVHNXr2rEdAtRHe31E1XTXLF4ChT1X6zuKrhpKuy16AO+HXgRZ8eOSzejLtr?=
 =?us-ascii?Q?53MD5qie7JqceNCy2Z5DgdkPBi2vBnF6HdGZNRP6s4jqfI3x2pyzbO38+Y+T?=
 =?us-ascii?Q?2EaAO5B5h9Z75O41grl+GebMTh6UPgWcFvtWg+8cDiRTvRLVn3vqqBxJYICC?=
 =?us-ascii?Q?Nqc+w5gSwWA4bzhC90nxV+cJ/kLWYYKN0T0Av+HrJJ8XzMoOC1IQDdCCsUsO?=
 =?us-ascii?Q?C9nOMaZqIsdvVe7mJ39YLtBOSERJw/YMbFA/GfRJF0o4G3GErnSBD/eTrcYm?=
 =?us-ascii?Q?UYKub0YA6Aprnc+VTdp8+wvTS3jpkiNslPp65fJWaw/Darr7cXIPZ8kKI5OW?=
 =?us-ascii?Q?djhcKnH/Swyojia+315CM0hJuS5NHzbAQpjYxyoqqzewYmTp29wenjZjG2Q8?=
 =?us-ascii?Q?KLmITThewOrJI4XeGD5BAQYufPQjeU6S6vL20QvPzny5nrPko2Plnmci1MKU?=
 =?us-ascii?Q?UW9l7FT2K2Bsgl+eUxj3OORZx16LBOfhNB9kMl9QPCvF6Yc56KwmcDtM7stq?=
 =?us-ascii?Q?wQjz0IB3o5bjXNXdSiVKg7eWjMCXmSFuTUlvUHspVrI2SgkrLNjMqzoeHIto?=
 =?us-ascii?Q?U2Kt/1HpisoEfdlI10Z4vOHKwg3qRTOt56ez7CTxkogOGfBfDiLUbpO6NR1y?=
 =?us-ascii?Q?iULgxRWXav5tX/lXlNe2yMuhyw2qWSCpWtO8Uxs3/qT529KI+xbxiEX3LW5a?=
 =?us-ascii?Q?gF9UC3fR6oLlkuNh0duRW2iakJpMNBKC9jXKm7FNk9yl22Ip26drsE5yZPP5?=
 =?us-ascii?Q?AxjAXTStXEsy6f8V7eoEMDa3+sF8PR2ye7SOlYEHOpz8RdhRHcFN/vUtdZuM?=
 =?us-ascii?Q?w9F/2+Q7P5DEOfBc80Ey19Yey77AkEDPJEgZuqqOiFsfO9mKJCB4js307Zpz?=
 =?us-ascii?Q?I/jsrgc1zvSVQIzaSs3TdBmkFETAvWhl9YJXIP6BdYaBx+lOWxMQ1P4S0BBT?=
 =?us-ascii?Q?AVxAIERdOe98soESOSDdtMcG+4m3xT15359U9G+enQGZeXgyOGUmP5BJIUL3?=
 =?us-ascii?Q?F4wAjAhw83RXBfhxREEPqEJ4qgbjAXYv6w4eqHBEoTPQoiIJunXENR8nJHOV?=
 =?us-ascii?Q?vy2OIcVOhVSj5dybdTtaLGaDtpeDR5MbPDQ2zDjLk0le34hWslRJo6wJ1JwI?=
 =?us-ascii?Q?4GbRfSS5EZLS2FfD4rIDFxqQW3YbM3Q0kEnDTlgX4vUgvkgMbgBhwS1i2/KZ?=
 =?us-ascii?Q?ZvisDTB8xN7Cpp6Gb5IyighemrMjZjlgxCq/mG8mskLSLh9KWCaQzWCV4UcW?=
 =?us-ascii?Q?Q1n9LrhyA8XiDvEbezz1inHXJSQR2ceahAynDrhGmeT+KVo2qRuMQVIQFLsY?=
 =?us-ascii?Q?j6iMvu5LOfX/SyISliOIiwHauLJicFsv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jF68wXW9zd33nlGdzHhNd1m77fbKUmkabb5p+e4N4m2G7kWTifvcz9s4OJuK?=
 =?us-ascii?Q?9mFh1mgy6L8LoOFAc18QVDHIyp1bzUc3xZ9GWt5Dk6l2DfLH/SgpraNdYo4d?=
 =?us-ascii?Q?Fvxmm3RpMfJ93WE245PgUU17b5z9/TFTh+twTDWayHZlE3TrNH7VTPcfvfCR?=
 =?us-ascii?Q?Re67brQVzsFZ97Hcy7j3ONDkv/svJjAAbtT9866JG6w7thxSfLm2pQ9cD3yw?=
 =?us-ascii?Q?Stld7ygE9GX3+qZHR5JTkzs+N9fHrlRnDO4DTvpgfiJlLal7nbNq27iv7uHP?=
 =?us-ascii?Q?RSDYu9C0FHw4wvbWBcbXiqccs6KP4rpOzIk+PXVF22c7mhLg9uc1JwaW2Pbu?=
 =?us-ascii?Q?O/tWgNX0NY//OnEaMUNzwYf+kGn1bJoxNGBAuS8pDjuPRzChTQrFgJ7RAht+?=
 =?us-ascii?Q?Rke5BJsXx3KxFqxe8h7UQBsFx+i7DUG5LanHvD01UeBHNhOYeN0tvjh/9HnC?=
 =?us-ascii?Q?egANkxyVZWNVmhSU0nO+JIWqAptks3hwMNoh96t7JA4HX7noQAYBQZdPkWNz?=
 =?us-ascii?Q?sQgA1rnwlZuSq+UY1bHpwv1j4RCL4I587+TIPzZ43Cq+lhc75Is9nt4AkSP+?=
 =?us-ascii?Q?T+XyJfyaFr8fzZXotaC8zgm5Ed2ThkBVxgHS00soy/zB+pRX+a/DXZubpD9P?=
 =?us-ascii?Q?kEHmdX+NKYztYbEI0TFE8wHdeGuComcz6mHEPZOGcFt2aQVBcmzejXW/Q3hz?=
 =?us-ascii?Q?qt1kQ+RsPAkA3FOHYl00bd8ljmejwWPKbakDGiDJamTWnMg8ExXeGQr6EX8h?=
 =?us-ascii?Q?ErMGwwmM67+8RNCMgSIbdW/K+anGzXQ7CPSP0HcObHpjhabAi+CylAZX0ph6?=
 =?us-ascii?Q?3Ba56z5uzL3I/HasVJiWGwvOP1RTWN6d1MQg9dIdmBYHillVDpmEutxBtYTR?=
 =?us-ascii?Q?+h4ER59K2mrjB58QQKO561T0QpYVSrSwOOSRNx4iX69ZEtdBPbdub2jhZ918?=
 =?us-ascii?Q?lr1+0+qA+tPgDizvgmY/NFcIIuvw+Yz1px363PgjCzQaAjOIa0AuPMc4EgdZ?=
 =?us-ascii?Q?Mrjk79ymIfN73VujeA47VWSY3AOfpT55YwK53P//OqAS2sZWMJ3VotGOK/jd?=
 =?us-ascii?Q?g2wPWMAFkHBKLhYbI7Miab83UC28Sks4bavtsVaIsaw+gTmQRR6BMYevk44G?=
 =?us-ascii?Q?I9p21AG3BGIXJQtd1xKQDFhizWr00ttQ1oD4pnVm+UPhV5DxdgADkiPeCLbf?=
 =?us-ascii?Q?RZ6RyhboVW+l+wi7E2Npk7Ngzpmymfb8fbtWatQrcFaYcQ69aoUXrsYLCzG5?=
 =?us-ascii?Q?HgqiYqH4FLSYchjYJ+zkhH1/lvG9/GtPg6yPVmDj8zw/N67icsrQf3tnTDZo?=
 =?us-ascii?Q?3dFsdCa8YdQBviAXEfZYN4XwkZ1mSCQP0BmcFLMKSy+1YLE2Q1U0zGToUXrf?=
 =?us-ascii?Q?bkhtMUaf1hqYnFVbdigTDQxn+ZpbAOwhYKTqGeNQKFufLj0ZvWHwCjIA+n10?=
 =?us-ascii?Q?AWZ5E/9j+cvuqvKCGzi0v4b/xidkZKQTC1o/YaWf7aW6jerRzISVcjo07vy0?=
 =?us-ascii?Q?m5TF6EDYnD802aFofcnz048OT1rwLZjMW2FdHLKbLMcnPCQi0P6Kaa0euXZb?=
 =?us-ascii?Q?lMxMQtpf0+M6E9/aiTVxTKau1OjvxQOEFWelIPECrO5JqTB+TbBmlGbC8Rl1?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CztabWy788GLb7yNPYwT2vazDcI19xqS/N4lje2NDLSUETGW+NDJFbn8jCQTQxQvm3lNEcoEXPSnPCzMe/QY4zcbF+sEbCOSvjmPACqMw/O2WPmn/Lt6Uf1ilcB5xT03k/VdDe86arkKX666Zb9QEIW4eQQf/YBB+kwb17rFLxPpfkQc0SWdY5QeJgT/RzzaCnPFZNPiTRqsNgUzMSQN+BeqeAES+XQB6/UMA48mUZY8xsJonQ1RI06APTEPAYzbqMWDdVIaJ9s6NSsIFKMxIR4kctULVtidOMwPcNHU3eoCxaFxgR6Por7v7woiBD55qgPRUtVQTEskLzXE3F+AcQXoM76ccNfcPSNDAka+X1n6NrEWow7y8Ahcq97lE5ksnk9/5oHkfg/JwIbvCg/tv5hmMzOUwdyY9AN0fx5nR/EQK5BW+0jIec16Dcgz+XU9bOQg7aN9/f2ri5MLiTg+q1VCcsFsCjHX/ws2u39uxcotbR7P/jShpwtcPZIC5d1b+vLqnDjArWhfZtollkzG6CGvVMWcHvQePcd2ovokhdf/ZjaHH8T8E/I7rW3gi9tfdgGcr6kPhGeEJOZGlg12riJAEP8zWie3ku4qqeUhKdA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a20c4b-6eb6-4b52-2206-08de164d363e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 18:10:01.2211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UtNu1y8XkYp8x2e1oIHFH1V7cTe7HPqhuZO7Jb9A3/PcPk9ECfa9g+gz28vVYu4hOLZqm4PUP7yypNHg5c1K5N6EKZFRw8FD8TExdBYABw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7419
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280153
X-Authority-Analysis: v=2.4 cv=Bt2QAIX5 c=1 sm=1 tr=0 ts=690106fe b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6KHKJ0ObjGoddhxPausA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Zg3-fJZEMqfKRF7KnPgU_IIMXE8vOFlF
X-Proofpoint-ORIG-GUID: Zg3-fJZEMqfKRF7KnPgU_IIMXE8vOFlF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1NCBTYWx0ZWRfX202y507JsW5Q
 VMt7UIrjFpuExQT7QMviFrugJQIGGNVjeckb1EqPTyqhH5zQseJFbZ8E/4NsyDfsbX/5UhtXS0j
 3LPjKQwFDBl76P+Amxtu2GsdsXWH56CpduDxI5vnZPaeF0/3lg3xgQ2VbL69LATWlLakIbAYjDi
 z+vya84lmYd4VlxZIjUKNAldR4bDNkE1AYph1zLs3X6LNY/BjxXRdR8woJyJykuO6YONUsIBrst
 uocpR4O5yMFdxPsmUIs6Kg7h5PSMzCRso1+tse5mpz22gqbC9q7u8/MAKMwQeA1O4b7rsRoYYJK
 DpL42rWVqHdQMf8VMfG6LVpkinrhvsGH3EpSmBl+/iqTgVf2MDAuQIFT/VbI81jOFG8HMaehPvZ
 xPZMInEGnEwuPAYZmSPyxeYTx7xCWg==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 629B4140012
X-Stat-Signature: in99fmkr8sij9r3gw4o5mc4etyzoognu
X-Rspam-User: 
X-HE-Tag: 1761675028-332536
X-HE-Meta: U2FsdGVkX1+VpmAQLdZ0Pu2fCEbaHGNuLgQ5eoZV+r6wRoSE13rtx7RgofZzHNSwqf9Q4iohLA50kWXwfYDA8VkcUmnc7jR45IyCcrz5A3wXMZRjpWFKCBKdwRnQOBkTQdsztdm3WRyxaNjpK1jbPfoc3glfLwM4oVapaNh0XTdB80dLjJbrvrzHXJ+gBiqhsuf14WjBbVsSikZuBXgxsxLAHCoA8szPQIiUm8Lm3GL3VhLGHAw/UUQVM/PjZxTYNNm31NZfw7s4sCVsNeyUAXv/rU3aT2a+5HQIFMz8ZPacl2MVrQ/4PzvS0pCED9W6thp0DejO2TR3DVu9m1sAasaTUWs2h+WkQsxIR4JZnQM2wk8O4IaVu5oFCjkjcAnfU3T/PfVlhaTrCy/GvwHPfFRXctwzxk8q6uahdqmM2ovBxhs0XF+uZh1XCZWoC58wBFznLpPh5UBxlDxPxm67ZXmMesZSF1b+A6vrS4FmVsAuUhrmLyFJ5eR8chHuXIsR+xTum+HDLN9aA0u0kET3pmCap+q99INx6qFUtOc2g+6qWRbN1kIUhIDmVr9uGMZhKBZ4QaJnBZibFZZFmjLk+58j+W0kCmHJDCFID22ATekqWxMEg4RI0UZvynL86LcVceXzup3Ao/JlKWF4oztkU+p5seqtJOgSdRCXzuTapaTZAWKz/b8BsDOOVJOzNnNXtMSKjB/WYDD7fc2eGdFnWNKNMJJVD6OP41dZpYU4AV3jgDL/OFLW2ThxPLPW1uWeyMKtIIGkk28Ig3gjT0aMSEADp/3JdnyK02yHxVVWgsOfRFCUrHyuqHO3hj9FwcAreKZJcVFHXBWpUNVjgQJVkjUpG4B5aNCPZ+GA8P3DLthZ/baI8esWBqtuPI4tvJD6jeC+bbetqQIsXvcyCv7aLv4NNByiUbI5oEPMFQjWrru1U8zyhikbAokBQsecm5bflPXqAe165kI9Lohv2oj
 ZONwIvPN
 KWcXUtvlrSfA+Ka1alWUcbHkplldXyyr1B7Gey1eackpdyH/vOfZ7vbdKxPTXngUw8v1to7V1dAmX+qOXycgMO0uzaXjv0y6BsyP21OZPdLHdqoxaG9H3g/Z8AGVefNfltwzTTUgD/+0zmr7YLLm9eCntfRsy/+IVN00hhMWKynSyfH2I4Ntms+wuB2mASVEt8h25/O0rORFkUedGZdKUs81Dc/b9ruV1NfFibQ8jTDvnecaoKV0DeCtPdgTZfGaICEkVCNcI6T+XbgMtxaqCpbXD5Rha3TDB9TIBbdub+sgbKm8BKlfhVCltklyoPY4J6E5poROIXrNEgM5nHpd+jkKaTVLC/XrrfUEupIgoRyhcXydp6v7gmCI/rUXcugH/QLsWogJTmjQQjO+psg6UdurOywizO1fCFEmavzV6PvLUp3Va1eqi8SMRI0ETQG/ENfkHL1+Afc6m5tFV9cynBO/hWWXx7OnDbUWt4wBNwgvG+QAtZ5Nx+PUzF7B1PnP30jRb/3rewL5T6xky5b/gg15Pw5ANEOUTkXobThun89TJH8B5Q94VMzunCaMv2IR5oAN0PDsyHxrK29+gZDY0i3tpVgaXHCTd4oYbzS2ABeDXT64GSVoXRI2SE0DZgwEe1dFDWEehYlFaGhnYXsT6WV3EK9lvFmPVHgWeOblp+WVJL/KMhMdI0m40Gdc+/eJhPj7MWgp7HYaOICGoxZwv6pOMvpR0vPurQTS0k6uOSftU97Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(It'd be good if we could keep all the 'solutions' in one thread as I made a
detailed reply there and now all that will get lost across two threads but
*sigh* never mind. Insert rant about email development here.)

On Tue, Oct 28, 2025 at 06:56:10PM +0100, David Hildenbrand wrote:
> [...]
>
> >
> > > towards David's earlier simplified approach:
> > > 	max_ptes_none == 511 -> collapse mTHP always
> > > 	max_ptes_none != 511 -> collapse mTHP only if all PTEs are non-none/zero
> >
> > Pretty sure David's suggestion was that max_ptes_none would literally get set to
> > 511 if you specified 511, or 0 if you specified anything else.
>
> We had multiple incarnations of this approach, but the first one really was:
>
> max_ptes_none == 511 -> collapse mTHP always

But won't 511 mean we just 'creep' to maximum collapse again? Does that solve
anything?

> max_ptes_none == 0 -> collapse mTHP only if all non-none/zero
>
> And for the intermediate values
>
> (1) pr_warn() when mTHPs are enabled, stating that mTHP collapse is not
> supported yet with other values

It feels a bit much to issue a kernel warning every time somebody twiddles that
value, and it's kind of against user expectation a bit.

But maybe it's the least worst way of communicating things. It's still
absolutely gross.

> (2) treat it like max_ptes_none == 0 or (maybe better?) just disable mTHP
> collapse

Yeah disabling mTHP collapse for these values seems sane, but it also seems that
we should be capping for this to work correctly no?

Also I think all this probably violates requirements of users who want to have
different behaviour for mTHP and PMD THP.

The default is 511 so we're in creep territory even with the damn default :)

>
>
> I still like that approach because it let's us defer solving the creep
> problem later and doesn't add a silent capping.

I mean it seems you're more or less saying allow creep. Which I'm kind of ok
with for a first pass thing, and defer it for later.

>
> Using intermediate max_ptes_none values are really only reasonable with the
> deferred shrinker today. And that one does not support mTHP even with this
> series, so it's future work either way.

Right, that's a nice fact to be aware of.

>
> --
> Cheers
>
> David / dhildenb
>

Thanks, Lorenzo

