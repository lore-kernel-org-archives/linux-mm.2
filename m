Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FDFACF45A0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEEA6B0099; Mon, 12 Jan 2026 11:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2C06B009D; Mon, 12 Jan 2026 11:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A53A6B009F; Mon, 12 Jan 2026 11:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE886B0099
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:37:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDD2A160735
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:37:04 +0000 (UTC)
X-FDA: 84323866368.24.7B46C82
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	by imf10.hostedemail.com (Postfix) with ESMTP id 184AAC0002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:37:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H0JJVPj/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768235822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnvf++3BDe7VlZ7usYh/mv1ODorwveUhf0u3jYl7+ow=;
	b=6IuqwcqYZxr5O5Cz/CMlWIuQ+1K+O0TcnsIo84v3i2q6fd7U7yf+krmbSE4xfIOzAffjiA
	53sQ0t3r73Pw7Iy5kVlDogZZ+a/1QaY04WfKRwyO3HnBVswHKks4x/8VkmXKlH0GS5yKrX
	chZJuhTJl88Plb3O7HaTmK1wpjY6VLI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="H0JJVPj/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768235822; a=rsa-sha256;
	cv=pass;
	b=TJbaMXMfWNykYyERnAC9/kP4cxO2gC2uY51hh4zekR+S4HguEvTwR+Cg78wQT47VoLss8t
	g8LHFxwGNAvC79CkVafKxUnX9GOEAZnxNIgPLzlsizl+3RJ2gjsKPROkqpWHrn0gGShsvT
	uhm6YoSxTub2O/JyGUsc4AiCfShxuCM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jPTr0EtzMl5Vb/Dz2NOeM9ZPr76xAVXmVi0hEVJ9JRRcLczYYZR79fCBdzVgtf3HZvkEaY5nzQFeilxzJ5iR7l/lD8BV/iwV4x2lxGOi4p/6fhq4nCCNpq3RqrWyazf//Vxg5cZAbVCpTlJWUNwU7ec0wmglYuEjGJaKtl4TU3gWbha8u+cUcvRQ2ajmmc0SrBEoeZ01poZiFo5diPYCjLCBrXDm8LrrDfn0JvlLdwuRNlxKNEOriv/PK87JpuJSK+T+rBiHB2iK6VKC4DsjYR8OY5p67wGOBUl3RLkxwfR3580MTbsF52X5S/hHeXmP5CmmMP5my3QsAfCHEMMKxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnvf++3BDe7VlZ7usYh/mv1ODorwveUhf0u3jYl7+ow=;
 b=hbfb3oa5llaVp5lR9uTOXSnmGs3SRQXxYmDZdtdDUTar7Titog9NLXq8njg6kpDRxcKmdkuvpJzJ1osBrekhPHStSIZ/aOchvK7/QBbj+ANg/w1gsxslkrMTSuyd0uzq+GOjLI30B/O89W7kn6mBM1IOQWbLcpghQRi06v3jBy1gVsuWO5+rWxE8ZJGi+4zoJwl8tiOxAvTwgXTZ8wWsBnU5Yvdq6N3yGrV6aQQm9Ri77bTO9Dds4C2CvxHPhYI9TOmyj9Esg1n65v3l5Qe4YRGH+x3SYO4YYRIi89isAo2x76Slrs25GvIR7J8b6DjIV2X+uYOsmOJV3Gt7PVLG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnvf++3BDe7VlZ7usYh/mv1ODorwveUhf0u3jYl7+ow=;
 b=H0JJVPj/RCk2brp41a3VHZH0QcueQqSey+QaQOBxmOQZa4Stm5AqoYNQBHIu4ISDkJpKpQDAVsfkzoZGiS+E5ZSbWkh8+e1rCrlhVwM3wMjjWRZbqD5WuvMww2v6pGAbEELrRIDpja0y+gjW/4fZ0FzD9FzrhnZYF01e7uF4wt1b8DUMaAEveVU5ML9g/q6sWeUFbDPwbm8Ek8XLAwar1wEXDUIf5pzOQW4hiOD8m8oDaZe2cnmv7mTmMe9mPGMgcOoWlpb1b/TNJqO45pP1ExGKwmWZHOsUjteaNaU2AYUcSbVuI3vrbl1ih/yhpMiBR4ugr/tmARNaf+G+nBM0MQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 16:36:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 16:36:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/5] mm: page_isolation: introduce page_is_unmovable()
Date: Mon, 12 Jan 2026 11:36:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <15563974-3A58-4325-9B40-14F58A408587@nvidia.com>
In-Reply-To: <20260112150954.1802953-2-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: bc834e12-8c1d-4e01-ee41-08de51f8caf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JJAkhth/lyP6ccqvC7r6F3eEYF+kZMRxBNHdT4CyRwj9CflCh2qxkr9TvcEJ?=
 =?us-ascii?Q?MmU0f9Jn+MZ+5lQrlhR3P4VLePW2KeOMRnUNQ3n230wkg7iEv9OeS8mCYtEQ?=
 =?us-ascii?Q?tlVkiZYhZ4Tl1DOILcTTdPuzCajPH3B1tW/4AopXalMuT9fHQqkNSjNEPJgq?=
 =?us-ascii?Q?1/VKFAPaBojyEFEPwQF7zaR9KzmudwsAvditd1gQna9xlRnl4l4wzLfJ8K1j?=
 =?us-ascii?Q?goPPc30DdelpDIufDVBYWW7c2cNX1CzsMITXjgCAfZYgP9SEPnjEphzttq6R?=
 =?us-ascii?Q?GA7A/EkyRhB1dlb6Eecew8QwIcvjo0uJ/qqKgT1TKHeyAFidKCrXKkknVD6i?=
 =?us-ascii?Q?ZFb1IXbFoeJwu9k8ozeHJb6+2eckRrFKuPahXytjwX579HM/Ma6AoFnQ3HJV?=
 =?us-ascii?Q?g/g44fCxr7fMefS+ItGKK/mHvNlek2xTuUpdtX7XSszXcePznerXID4/xgjm?=
 =?us-ascii?Q?s2VIAu5uhJIMEMX+m0IDp+3Er7Ip34W6xlz4tTUDuIp7CkCa4HL56WEaLrk5?=
 =?us-ascii?Q?70UdTmW+O1gs++xNWOcglyEuWAjtAsDg+1nzwRDBn2VEYKY7NUYvhvHjxL+u?=
 =?us-ascii?Q?7sdckp6Lm9WAKiCMnAUET+CouAkIGNdVWO33vLq9Filt04y2mfiYoXvmInu8?=
 =?us-ascii?Q?DnKdphA2wegdzUVRLKO8hTb6HE6IFsviImLXTTj44Exus9Xg7VSlt+smsQND?=
 =?us-ascii?Q?uaD7ggFQOOvmNii04EJEttwzkAW5AbuC54pg3x+GQQjgXkaisFbEu+xwKpcN?=
 =?us-ascii?Q?QMX5Rwp1mlHFx3Nxy+IRR6N911unIvzUhRIJVanAg/sNc0Q+dILlAYgVXrgD?=
 =?us-ascii?Q?GdE+NTUJgRs61wAQvD/wz8603Jb/nVJt0rHYBJOjFIA3Ct5xzo9Q+6ByOS0O?=
 =?us-ascii?Q?CbwC8s6G+vqpZtqKWWbgM4jVbX/dGunlMUpCALZ/lM9GRTolLGNVBq3ID3RD?=
 =?us-ascii?Q?q60Q+yHUxCGo+03726qFHXL+4qnl2k1AQKQ8CWDUsrJ2ithFFeED8LWMcYhh?=
 =?us-ascii?Q?ZhCpVSTv8ebwIsH0UZyKs2Sxs8uRChg3ZQegOcTs/7v/8HczGzQOeEFdRs9E?=
 =?us-ascii?Q?f8YROlUMSsuVILsEmZx6YTn0IvdOZ0gcjEtqSTkILOcIAKwX30gdOSgbl1ld?=
 =?us-ascii?Q?y12SuqVnP3H3Ur7d+KJG/Qhw+N60aGcIyfuCWvwvpdPHROROF2PKtpeNwBYQ?=
 =?us-ascii?Q?nYAGuI3w1rQU5UcU2ATMGnr0nddnTTLfEIGz1rWUOMFzIRl7qSx0vQSrEcHJ?=
 =?us-ascii?Q?hwZhIqBEt1rNdjirVyn0em27IcBBm2lIYqD8QvqgXRjnp+QSd3swtCBqLgx0?=
 =?us-ascii?Q?LQqADDo5lW6yBi3oxWNjlJ3EytXSX07wr+ekETt17h5dQCrHfftbmBEt7tlh?=
 =?us-ascii?Q?/XgLf+q/9LdE9euAgHQw74D7QiWEnvMqZWvEEcSJ/ASRpUMSMlUzhPDdpx9Q?=
 =?us-ascii?Q?gDmQrsKpfEndByrUkJe1KrOTLWffQXu2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/4dW+n5Isg0yu9dMEADmMgPOfMUPRLVn+YepcbzXl/D/jiaXsX/6Bff2+c/O?=
 =?us-ascii?Q?7cN4Gz0oIFKklyrowoNORbUqAbdmbsw71bH5cjhukUArzcLi2h7a1a6mO1+G?=
 =?us-ascii?Q?4RPQvv39zCz7vhvHpnOvRUgRCEuomHItzXmwT8+K7yPVU+OhC6XJ9zu5/TO3?=
 =?us-ascii?Q?kMiuOfDeDnU8Ra6c5+arftxTD2ZbclPUTGfBTGe4L163vQ4fyBPN8f6bsqBL?=
 =?us-ascii?Q?UwPdluwtRwI+9tJF+Z0cK3IxLV0QuIfaJ2ugPwPwqpmXB5MLrXVOwJE+DDld?=
 =?us-ascii?Q?Kffi7m1cGCBfJE9gEg4ksbSSXTSuXNZOPSNV50NvWcA7pUBellaZWCxFtgtX?=
 =?us-ascii?Q?lN/XmCGAaJfbPqupnJ4vnsBnOcjJx3+lC1I4Xl2puhcI76RHZqFkmIjsmmfq?=
 =?us-ascii?Q?phpB7onvK56kafK+xCKishjs3QhAyRrB121fxhOX30+nEhsRIUOnvA/6av5Z?=
 =?us-ascii?Q?JLToOZMeoi13UtckQ7Xpsxed1OZRx5bA/6pnNvNEPx9MszzDMeX0BlL/cQCv?=
 =?us-ascii?Q?IDD0bxeb7d0jCOg9HzrvYxOYosu+T32ZLnYC79p+9dGqrLJ4+noU+DTcFLfA?=
 =?us-ascii?Q?h9frLzm68MIorC62i9ucPln3cUH/8Zr8N4b+LXWyCTWtZ9vx4VzniYNx+P04?=
 =?us-ascii?Q?BfQlxLzw9BQkQKcNBgfpHpMhqVQAag03ABlrhO4XBEWtSz2CZRkshipbcO9J?=
 =?us-ascii?Q?sGJ5NB0ZJHzQJKRSbaK9ysqbHTrE5ZSyk8kHjm7SYYy/FMYfM4WztO5CfcNe?=
 =?us-ascii?Q?Vs6OwS2L/x1ypX9SDZMrIZEdaUE2xIhSB7+y7AobX2n+/H//Tw5YV99eBXPb?=
 =?us-ascii?Q?VbJBiZzvPEra9w2ZAnOU1giytVju6bjPksuga+2Cn17bYzDpsNJA9yCtx29M?=
 =?us-ascii?Q?3c75rByVetPJNG2v4lbbdMdyCmDXZSuyKqcvKucVPYk2XHJfYmzUHpPzy5lr?=
 =?us-ascii?Q?A6LBB1A9YnV6hGu40IxROm6PxVuhk6qG3Ht6Ot9fF6qUA7mzB1PaXf62rlC3?=
 =?us-ascii?Q?GKol6lWVJrAnskw3pjfo/5TnDYDaMvH0SXnRn/S4lVkYcp9gYMBntBbBsdWi?=
 =?us-ascii?Q?0KJ14oQvQnU82vEhnU74kI9Nvr2JTFYQkp9f9eLe+rx8acYHaUeDlXX9teiu?=
 =?us-ascii?Q?rzpnnkT+3G3uSEG9oD0FH6cL7InEdVoyn8rXJe/uNH/7eYiqAD67pbCeIpxv?=
 =?us-ascii?Q?rCwoNILgO98B7496NJEv+Jx64US699e//Cpn2EBFvJn+NeN6z5LbT/PmCPRK?=
 =?us-ascii?Q?CHo8JyRbdsOeezCQCsEJOolkqYRaDh/nozz5YXqg1GT8f/g6XJwGT/TrAAgo?=
 =?us-ascii?Q?oaZgCvyBiEQsYOsHC2OTwo9ptxBPawzj/PPTRLD1omTp2pIEdXs46BHbaYOf?=
 =?us-ascii?Q?+CzQCfJ6940nO01gMhdgrgl1ob8/uXzh6rA+HVjHLtCNvxK7JiZCismnOOol?=
 =?us-ascii?Q?bggRf3ZSTmtGJ5reESO8B7p2t9B6goXylLhbK4V9mk5q0mWFLRXElc1P5GgZ?=
 =?us-ascii?Q?echPABWBhy2S0smOc+Lt/iaGtchBXq44O6sDGbOOfXcRIWZ0quyzIPQpsvxT?=
 =?us-ascii?Q?Uym8PlN5aFJSG/Zs9DsS2nl5kdOcqKkqqesuqS4awUqoE1hoVACAIiqAGx/b?=
 =?us-ascii?Q?UVAT3YSaC244V6Uex3WLjrtt0XaB7b7yBojo1k2oS3i2SHsbLwr4XCb7Fvxn?=
 =?us-ascii?Q?kt+AB/rQMonamkCXAdLCwytFZ4HJWqyZV4Qf3Po+sKON+0SI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc834e12-8c1d-4e01-ee41-08de51f8caf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 16:36:53.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZFygzTi81uOkb8JKB9eJIY6Y6Ldy1L8X0tj7tZEMoBiryhDJ/KDx0Fz5qWVgCWR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409
X-Rspam-User: 
X-Stat-Signature: op1eai6otnrjtf1itdec5dzyiinhyy7o
X-Rspamd-Queue-Id: 184AAC0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768235821-49638
X-HE-Meta: U2FsdGVkX18/aPSLI84wnZr/shmHcDJKfnvIAxnBnK9eOah8eUXZ3dA13j3kpDJOnbGLdtcSNeYNooMCDnRVLRL5da9/ToJ85mMQbcGIemosC/BOlw5kO3lb2/Y3HFFtozOWd84BCLAW+uJXMVsLf8GVdbR+/tuQ+N7/1o18L5sqakEWNipPhP3jsBObP5fOwtRdEKwM7ZH73XidwYawpuKT6jmVsDHzFHtNUasLKtXdnN4C/4aPTqg1NuR92qLxWzJCgYk7mFgwSVwx4EugtEGu9jYTDrreeXge9HSnToKuCDlQb2sRvu/QFC2NJ7l52ybjV47cA2fYqF8EVuFg2PjEXwVQy0IuaGytRmvqF+I7evrN6VhuGdlz+40DgZ4Dx8i5tjb64mFv5baMauo2AVIubNlOVP+c0JCjSjTHYgMWyfIGwt9L1BsUSOD4Z34zQ65m3TuWH95HGFKzEobRrRmrZwNsJmUIiW0J35+5cDzmrs52iAscPnLxSk9JhpK1AKGRxG/NakNovv9wI+LPIbta7HBErHJo981lxWmEi1GksLPvAWEqucgJtC9q/h+iTzxj/rQJu7GNNiTZTS3gV4RtyvQxT8RmyFYp20Ukd2qPKdYXF3k7Rkk4I/0ZXroSEny6vV+ExOLvLO8OjTOaV1r3tv7jlwu0JMImwOpLgBhJcWHCpcghU54UvGDgPb8CDCl3s7U/QspQLxrBucNcNwgqV6iW3F6FqzJTICjtOs3+CwFkQP7yRFTQ2DUrMvspz/kuGLWXcwP90Db+yAzW+0iONSUyj6hSDrc5wyaCfGUzI4+PWg33BZ3+s/WHuqy+dtUkmNAMssxK0DtaQauFCh6xNTcc02bfWyLLCHiTVHim/q7q58xtEK/5pJ3RI59frDLJtbAFajpoUlnYzCng/I/cPT8HF1xaaxcuBloKG/AD05NkPpLRzZYpg8VGqwZYk/Qaw6glKBYk2/5QIfU
 694jBVcW
 n262KFo0/XwzirWRzc7p801/1SbP0H/MofE4MJYwitONsd2+P9006xKwcYppo4xMkUaPuzXEFPUhY/kqmRhDuIxi5VYAJd+5eeUpHCC4zEBe1py1VLkD8YKBm6QYKEM3deS45qpX9tkuevXDMUSn9FmBY9yLB9JxImNlgr+ymHCybAbWZR/ufh1Edcey5Ab4KxrPC5+cZ6UIBlEzuUtWeKB+vPymJ6RB8EAzTzqnwJ7Pa2MMrlhAOgBg24uLI4XSP7zs9xx/TrP7dpMKk7Ul7wWs53QdPTB/ETAjbNe8DZTlqiJLWXG81mIYz68l7bgdrFxy0dLmhpDSTo82KtAF+f7gp9ATCqPpGED1w7QUoJR6FV8A2/LBEqmygYY2le7Mtaoq4AlRXspsZuTfbSvxBdaldhZM9bM0WTIchltF50Kg1JjFoouNvnOXJuZQAGo4RldNI9BXRoTloGtENvYENEf5rFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jan 2026, at 10:09, Kefeng Wang wrote:

> Factor out the check if a page is unmovable into a new helper,
> and will be reused in the following patch.
>
> No functional change intended, the minor changes are as follows,
> 1) Avoid unnecessary calls by checking CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> 2) Directly call PageCompound since PageTransCompound may be dropped
> 3) Using folio_test_hugetlb()
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/page-isolation.h |   2 +
>  mm/page_isolation.c            | 187 +++++++++++++++++----------------
>  2 files changed, 101 insertions(+), 88 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

