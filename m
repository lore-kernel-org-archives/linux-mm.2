Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9ACACCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106F38E00A1; Fri, 17 Oct 2025 10:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8178E003B; Fri, 17 Oct 2025 10:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B9A8E00A1; Fri, 17 Oct 2025 10:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D21F68E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:29:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 842BE1A01D8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:29:22 +0000 (UTC)
X-FDA: 84007838964.05.2467CDC
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011002.outbound.protection.outlook.com [40.107.208.2])
	by imf02.hostedemail.com (Postfix) with ESMTP id 96CC98000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:29:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gGmFTTrV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760711359; a=rsa-sha256;
	cv=pass;
	b=k9aci+jBKKemoFcIOWmW0/ts3dOBdc6vAlC9S/YDUIiwLcuHNpIQRCcooZag+M/Id+b49o
	Jo4+iNecWmQpHD7IagHzhU9LNgylvUjeIKwcA2H1VC95DhpeBRXEOUGmHcohRbNjdcAa+F
	+yceYrnellUjkFPoHyEBzNh/o6HxjPU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gGmFTTrV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760711359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oc5ppFd66xM9MpFYXZEGAU1XOyVI/XfaLF89qRmNi68=;
	b=Wk42tW5tuTj2dE4rrySlu6s0EfSPV3mwJB/6jHEkNQ2WzewyJr0yGVBC4ckodDdPsoFF6a
	abkZG9c0yRJKRQPaGNvz+KSbuOyf3X6ez58daxQJ0CpnJBiDejjCzLT3z15mGuLRqWred1
	mTnI7QgaPAm9Wcs74daFXZGbyUlD/TU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/Z9Ajei8IjCIqZKnkJCIfy1Ttjvhzj8Gxh0KPIqa9Acn5hPh/PBCs4O1ZK+xjkK+RzCR7D681QM17iC5E3cpgnsM6HiCuOomI5rqx0HgYKXLiR1wZ1VMqfj3GjvWeVj85x1D+swL/YuVx4cDEZUPAdRL/SAb/3hfiEOM6GbuYgE4xihQxxL5VVQLdPJTUsRT6OCqoNXsyz37gcOnaTzGkN+CI4EkFe0o+D+Gx82WeBg08Z49yzEVVNyoTYy4upfTtazRwineYUJnSTJ07as2DD8fCLZDEez9QhD4cxayPqd9LA1w+Q+U6MYMA+I1U2eoZnW+XX9wAVvaps3LTNwqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oc5ppFd66xM9MpFYXZEGAU1XOyVI/XfaLF89qRmNi68=;
 b=IefCa8wahAgIznVmvDB1CIYBgYgCk+n6J21nY/LDrjNTMFptVkHZ9f9aqU1GInKVmgsqv18KZDnuy41NKDr7PFgpbfnNk/5l1OBMc6SQVfY0s9FvbErpW0ZwICmS2HGbV30MVc8FPX3Dft47XY5ayZu8eEPwBfVcPF68BscU1i7TeP8J0t448OVbt4okxWu3hCym6CDgsIGPA4cWmwz/5MoAGXSeZvZwOJy/zy1OCz3vLu5/xNMjwDITZfxnmKGndULZhm4dsJQdNl2XtCdohdXKtMY+0XLatROcONClaC84DF1pbUTXyXhU+kCJmNUSNrqW3ix4SmR8rM1HkL6VUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oc5ppFd66xM9MpFYXZEGAU1XOyVI/XfaLF89qRmNi68=;
 b=gGmFTTrVIavWkNpYxgnUY3fxNMaCpNRwoZzBd2pePdbn2kvxpxsuyNDQZ/4F9lg53i/ZC4FRF3Z8a4eFXLUc6kqVNO3CXOYB5tddABiyDX5D5xfCzOkkFK0DM7icQKszeMxBTvNKxt9R7FxBBSdot0qmDofGveaa58PLNHlog/NkbEFsJI/zLUJ6+wKNkhRqBo+IsaIc02aUCtR4n153+B+W+pBauW8m80RErc2Mr6WBwdBA5YaakZHoS6svP4TqkUApLdcr5eRbYlwoTOVWBeXtO6H2XkMM2M/++GOCNEfVgNEU2k6RRn0zy4jm/dLTRtOebRRBqN+dwY1+g1Le6Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB9466.namprd12.prod.outlook.com (2603:10b6:208:595::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 17 Oct
 2025 14:29:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 17 Oct 2025
 14:29:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, <akpm@linux-foundation.org>,
 <david@redhat.com>, <baolin.wang@linux.alibaba.com>,
 <Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <linux-mm@kvack.org>
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Fri, 17 Oct 2025 10:29:07 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <BCCABCCC-34F3-48FD-B394-E378B87990DE@nvidia.com>
In-Reply-To: <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0342.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB9466:EE_
X-MS-Office365-Filtering-Correlation-Id: dd200ac5-74ac-4172-24d2-08de0d898947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wLj+5u3xijgwsfLdtBF2UiT+tefbDYnKqYkxnZ4o3ngL5BUMvQFUEiC2/C6d?=
 =?us-ascii?Q?CWkBQFC+NDSYWhDXKOBewVeSHBcT0B4ppRVMGLNmHGq3YCKcKzwgwdMRtPYs?=
 =?us-ascii?Q?v13/39mmyZZkRTFBbl2OcV1mfb1gOHgMh2nigovNMrYhW6TkO4iuYLgWPSgd?=
 =?us-ascii?Q?qJJBkesFNRNKrE+vR1RFw0FsH4DP7biNWxnvhJzkTQCgM24PYsREYkpn0ZR0?=
 =?us-ascii?Q?d+Y+AJnQ6JwlFDGzw2EpaVS/u+tTxAy8T8GzTidjdn9VdKDuFkF0wqVbcAza?=
 =?us-ascii?Q?I1g/kD4vgcdE/e2GtQc7V63w1CndBBbB0xzVc783wAOV3xdJa7xFzwsy4DmW?=
 =?us-ascii?Q?Uz+MKyA8wAU/EfWwoNRPojD15t/uifpvhk2Qc2WHFtbRSMnuyFMf8lk4Shs4?=
 =?us-ascii?Q?Om0IpjTXAk3YPlKDhtsV4f2ei1NluyE8a0V7xMWUZhohm1SGQ1I6O2ov09to?=
 =?us-ascii?Q?REA76rkwKQdPPMkXcmINhVqwgGn7DEmT0dWVOrCRESZVKvezeI01hsHj6lIo?=
 =?us-ascii?Q?RkP2TarXSG3ERnjckgLUx2RbqWIJofX+NtueiKKf6aqc/LULAWJOq/IrfYag?=
 =?us-ascii?Q?w+uF/8qHvaP1cgUUajN7l+U+zYYrZCsmmuhPWz1XdLkglFsbrplmucJm0f40?=
 =?us-ascii?Q?n2SIrkjyB40O92FGi2ncpkatQu4FopEQdp0ZMDCIxDt19V+v7jVxN44ex2PL?=
 =?us-ascii?Q?r26sr3BmjnHdkC+uwanRVDqI5pI/7VqnaFAs2xq4zLqYij7qeLpe7ZtUO6ym?=
 =?us-ascii?Q?PyyDrg80jcsRUgDgJ1DFMnhbrR0QmEx6RbgQNhUVG+CUZkji1wP3PENo6J1E?=
 =?us-ascii?Q?kjb02SzFYZ7bfUNlGJvgDGQ9ij1fcNVu2APKJoCM8+XxGGjjahXvqI7rLMkG?=
 =?us-ascii?Q?x7EikI4K9M8rYega/ve/pfpXWay4T1tS6Z/t9sBXt40vKwflOOz/4b69L0nh?=
 =?us-ascii?Q?nxwyrUT+C8xLPyapbShfPcyWl+RreV+7MgvETeo9pybGOLcMs7hg5kVtpjik?=
 =?us-ascii?Q?H8a1J0ZoIyJtofcGAEFP+Thc3RhYlHP1OgK76f13GKR5PTS4rkmZLhCx+Xly?=
 =?us-ascii?Q?YCeaPNMBV5gYxYo865czeI0fCPBhXbdhevIY9nC62IQ4L1wQGAi58AT1b1ys?=
 =?us-ascii?Q?zKVVAAzV46YTi5gaZhb/a+lpcxYtw+7T4rPHmF3J3SuIJlwRLXkyLWnx2zg8?=
 =?us-ascii?Q?yjNX81Z5LPZdf1dA796nU8dBszvGGrWISplY3NZY81IxDfCzxaQkW7NSZ7tD?=
 =?us-ascii?Q?ED8btLj83T2JXvZvWY/LCi4E/m5tCoGEIu94EZSQfl9YxXOSGCsj0wBlpt49?=
 =?us-ascii?Q?IAmXqgbZljg+5iTkxu8qkRJsDrv+qLSp/E8S+TlwxzCjczzr+gu4jJVLuSFB?=
 =?us-ascii?Q?VWLY1uu5lqyCg1Rdcfa6w08A6WY40KoWG5h8QR4HyYRycNSTro6V/SxTdvtG?=
 =?us-ascii?Q?pS7IL7BxYQ3SH+Rrk3elfxbmbWh+Uvz5WCsrae6pJ9JJZ5qbOypgOg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Uie4AjplgN/25H7iy95XgjnUeDpO1fBBmYAd5tdlBHEFv7FvaNz2so1tMpZX?=
 =?us-ascii?Q?4cwF4r1qzeK9+au5f/Yz2KMXkyFVgXgldR2JLGLgXPmTMYx0M8ctAYwR3bpu?=
 =?us-ascii?Q?36rEsvzkkx3x8CKHlR+taE3k7KOA5GWMShOhq4HKVhy5+YTiqKKDtiivT0rS?=
 =?us-ascii?Q?UkHSdOYglIM9z5dcRGXlk0d0dzucCfRQL/A+h+bDCnwKl0ZyBfzFx+hNkkc3?=
 =?us-ascii?Q?yFs4dqJ0nU/CEHF+FADPmy+IKNQm6DuB9SJHXKGg6WVPIeM0tQzaExWRVQJB?=
 =?us-ascii?Q?HXNB8k1s+ljbR0VdL9VjBTDUoatVS9wwhKtcsFA0IaBLZhdTa2+P3PFRw46H?=
 =?us-ascii?Q?fwQS1muEZSEHi8qaCaPUhVCfjJTBvjlRKjB1gBruAHrXE00kVFQI50qScYxG?=
 =?us-ascii?Q?pfaqfzqcf86Fx+lt/6wwqixLsqZWvXraobaVvavJ5sJqj2Ck0KEjZFosIHg7?=
 =?us-ascii?Q?0X452ZxUGvvogsKeseC9UgYGb2yMHOkUB6g8n/EdqjeCD3040DMDtattRxDp?=
 =?us-ascii?Q?vKzSDPgGx7IyDXTFxV6L2Yaqt1zIODGb62biA35uH47lgmOwSoSlq66gyzGt?=
 =?us-ascii?Q?Aj9VokfhF9jTe0lJ1AaQhpf9hWyObNM0JOIY1x/jEeJQqHNqf3XlL0j2sif8?=
 =?us-ascii?Q?gJ4uxD8LShJrD037iVTr7UhaIKiLT7L1oQ8JpZ86hhB1FMgo+/9t4rL9gzsV?=
 =?us-ascii?Q?cRdAVLbvaIxjtp/5q/LzysFC2Ih246tusTCY28Qi8c+nFe4IpjFS+iIx3R+F?=
 =?us-ascii?Q?q5aLCKSrIV4gi95WYTTOOeSI+/8Bre7lqxV1soLQST83YP09GHbI11K5MKqW?=
 =?us-ascii?Q?vtBE2z9Rrl7iWPMpDYeckE4JoX8QaOD8JI/R1/Omsqz+WycZ7Uw+GjzZ3PkJ?=
 =?us-ascii?Q?0YDSYsvKKHJx8XwRiIzPBmznGbzLmfwbjwpHcFGhST0/KkuXyKDnecpj2aYI?=
 =?us-ascii?Q?qld2HZanrFIOik0eTu+pXiKZR8LEpq6o/mKPmENGjBPEkVY/HUxDmmAEYFWE?=
 =?us-ascii?Q?jaGwNnJ6v8ms4hCBcfyhnk1/7szdn31ZA+Vl2jzkflm2VB4Imqd/xPg30otg?=
 =?us-ascii?Q?glAJP0qp2bkqWNGv5bCdO3Ub15kH6xpZFH2KD4lUF1mGloT+RHc+X0+xivOo?=
 =?us-ascii?Q?9I5r0+uzhijQIw41KbDlCggPz3S97ghWATy3xY9VFYjFMAvCxuE/YLjgRXZY?=
 =?us-ascii?Q?3hdS1F3J/3HmbIyBlUBg3OOBYeqjjCLt1TK9C9PkjPT/kkUEr7ZXS1yUuAq1?=
 =?us-ascii?Q?Vp2gT3MKmeH/Oa9QhKkNWpRqW+AtXGjkhTMyhWXq/xvw76+yWgR3JG8gYM7t?=
 =?us-ascii?Q?2zKsvnd9yAGIKSUyxHkE92pU78OyXP4oqxqTDFxlkoI5Z9jV7MUjggcq5XBz?=
 =?us-ascii?Q?gITwsizctmWT9eV7fcDIuEFv7x5+sjcgsS37PyOhcCXRThvQ9Ss2NI9xXCQK?=
 =?us-ascii?Q?VhYzpWASY2uZJUCW3jA5CZNgrhfcAwHztbw6Q/ho/BEreUCCMGRYrNctUa2T?=
 =?us-ascii?Q?UqDqaDW9LaKE5awPrseS2LDDor4+zHhYHr0vLWCiDzF7Nkr4HdhAbAeRc8dS?=
 =?us-ascii?Q?mrWUbR+zIkLJyy+iWUX+anNDjKuSp62ueejuVcqo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd200ac5-74ac-4172-24d2-08de0d898947
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 14:29:09.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/RX5DF5gpwxumyZZlRRLIjKDMK2NmRfHJGYtxVWCn/RMxEL84XdmMsdDyxgrAjs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9466
X-Stat-Signature: mf78k6n8zsjp5titx79yt4k3ch5kwmr4
X-Rspamd-Queue-Id: 96CC98000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760711359-147593
X-HE-Meta: U2FsdGVkX19hs9wtBztGyq6XDR/rAtpH//YfdYDioXgRWgc7/ctl9UCkef7dfV/gj9L3MwScFn/OXEmCGEYUjnqK38FvihGZqhnPDkEDjPPh6tV5mOPV92EDq447kgwZjp/vPhwE2SLqXa9UJalzBJ3QvQQ5i3YkKclbaNPXSZAqgUhKMkecl4/Ld3vjF1f9y3JqoWIl0gLc+cxwvlJHaiQsDbalh6WidXwtSmzGv4FTr41XiXnKLFmEMKB9igKoR3mOSz4h7HykmQ7brNfKydnJgjGem+QoadhdYjD62YKOmVVpjfuw2CoTfMGuE0zQzVVMmfetkmQuueOi86h/iLsgl9p8S7D5sTeCcUqw+b2IHFbCZVHKpDgdVDMbz4A3/wOn5Z0rxpX0Qg9Gbjx+y+eU+C9ezVc4BAE0nFGkKpJcH+q66KsDh90DWoDij+b2viSjTC38TKmA5x2tohilMbxNLG4MaxBo8gBU2m2jwJqxxDgMFtGqZFRVQF2k6Z1ewNFp44LuHhJ/y+Bw8Y3ulTLT29bHdM/tL3qdrc7dHMnspF+pUGd5/tCpZxVXwK0sgj5frFV1OIpkQ023oP9aHZHYHPYliuc+CPKLBTDm9pnBfRgWe38qbn3tJ9VxWjuyziNQzTpemqbJVbhGHpfFZc6v6V+S6p2WBiFfCm+npXdiJu6n0YuMGk1lG/j/7XJKufaMsEbTWoBrOkGOVa8HmoVxQRcASzk7YChPVVbJczDXSbpwOGSI9SFgCZJkbPwlssIYDebq7AvnO6+LPJpvAvTQ4/dvlIsHXTuK/2qAUt9bA/JyhGeQt9gFNFA6GgcSxnTedpaZCEOmrohBM0oZk+aScsXhv2ibtmtYfUaNw1PvXrc3D5xtRobV2QdBsj6JIp1DKHkbZu7ieP6RSh6wiCWtUnOKRiIDAIj+D1NFVTSJaoYSChkbsPcnrDxhC2sdAYEkIB6rISTT/AcLTDL
 uB/ur4i6
 WTDdT73SKWOkwPYLrZpmT4ySaNK02CpKZcR0XPOBtetkeZ8A/8VZKv5X+IsGuD8UeLp6oRHi+V0S3pxH2Az8FbphHGzXjdSMhNmeHdnz2z+bJ2tEk9P3xkIfh7E7llE7dCnahdpqYT5aeZGGk0PHkbsOZiqoFAQbZ0xzS5OyaQPuwq11zs6jpfsvz7ejDnpUbTjQRnJRMCukUtrI3zTOSdYyakBPCPNdj3uo7k8PKRdV0+iTdvpsKGQK0vNvOFpPfr6qTjaGzxS/VlX0yrfKzV2AYNmMCWAiCeFmZNslUcmbAUUbhH6BdqUAOMLCh/JPFiyIgjYvqRA0rMeWPXfqg02vfq1FU5NAqHDgrZiOrZSYZb4JR8wnZsPMuD77FcINxhkhMwjgtq+ktWZgg6DCNIr/z35tdzM2v/SUJBr9WHbY4f7Z/kpsk7SDvVHfkV2FBqLHTmH1RI/Be8OUmtCw7aWLCmFxZSpf6ND3E5BROO7CNWFxLDsZcYM2uU5NnX0vOCLi5Gr5alI/KjiuK9klU3GA5kogXA4Z2xF7cIpTMAev6P1wmAegrr8SsH9QHL5aZeKmj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Oct 2025, at 10:26, Zi Yan wrote:

> On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
>
>> On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>>> Existing __split_unmapped_folio() code splits the given folio and upd=
ate
>>> stats, but it is complicated to understand.
>>>
>>> After simplification, __split_unmapped_folio() directly calculate and=

>>> update the folio statistics upon a successful split:
>>>
>>> * All resulting folios are @split_order.
>>>
>>> * The number of new folios are calculated directly from @old_order
>>>   and @split_order.
>>>
>>> * The folio for the next split is identified as the one containing
>>>   @split_at.
>>>
>>> * An xas_try_split() error is returned directly without worrying
>>>   about stats updates.
>>
>> You seem to be doing two things at once, a big refactoring where you m=
ove stuff
>> about AND changing functionality.
>
> No function change is done in this patchset. The wording might be
> confusing here, it should be read like:
>
> After simplification, __split_unmapped_folio() directly calculate and
> update the folio statistics upon a successful split, so An xas_try_spli=
t()
> error is returned directly without worrying about stats updates.
>
> David suggested a change[1] to make it clear:
> Stats fixup is no longer needed for an xas_try_split() error,
> since we now update the stats only after a successful split.
>
>
> [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1=
b4@redhat.com/
>
>>
>> Can we split this out please? It makes review so much harder.
>
> I asked Wei to use a single patch for this change, since the original
> code was complicated due to the initial implementation. After my
> recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
> can be simplified like Wei did here.
>
>
>
> [1] https://lore.kernel.org/all/20250718023000.4044406-7-ziy@nvidia.com=
/
>
>>
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>>
>>> ---
>>> v2:
>>>   * merge patch 2-5
>>>   * retain start_order
>>>   * new_folios -> nr_new_folios
>>>   * add a comment at the end of the loop
>>> ---
>>>  mm/huge_memory.c | 66 ++++++++++++++--------------------------------=
--
>>>  1 file changed, 19 insertions(+), 47 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 4b2d5a7e5c8e..68e851f5fcb2 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>>  		struct address_space *mapping, bool uniform_split)
>>>  {
>>>  	bool is_anon =3D folio_test_anon(folio);
>>> -	int order =3D folio_order(folio);
>>> -	int start_order =3D uniform_split ? new_order : order - 1;
>>> -	bool stop_split =3D false;
>>> -	struct folio *next;
>>> +	int old_order =3D folio_order(folio);
>>> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>>>  	int split_order;
>>> -	int ret =3D 0;
>>> -
>>> -	if (is_anon)
>>> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>>
>>>  	folio_clear_has_hwpoisoned(folio);
>>>
>>> @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  	 * folio is split to new_order directly.
>>>  	 */
>>>  	for (split_order =3D start_order;
>>> -	     split_order >=3D new_order && !stop_split;
>>> +	     split_order >=3D new_order;
>>>  	     split_order--) {
>>> -		struct folio *end_folio =3D folio_next(folio);
>>> -		int old_order =3D folio_order(folio);
>>> -		struct folio *new_folio;
>>> +		int nr_new_folios =3D 1UL << (old_order - split_order);
>>>
>>>  		/* order-1 anonymous folio is not supported */
>>>  		if (is_anon && split_order =3D=3D 1)
>>>  			continue;
>>> -		if (uniform_split && split_order !=3D new_order)
>>> -			continue;
>>>
>>>  		if (mapping) {
>>>  			/*
>>> @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>  			else {
>>>  				xas_set_order(xas, folio->index, split_order);
>>>  				xas_try_split(xas, folio, old_order);
>>> -				if (xas_error(xas)) {
>>> -					ret =3D xas_error(xas);
>>> -					stop_split =3D true;
>>> -				}
>>> +				if (xas_error(xas))
>>> +					return xas_error(xas);
>>>  			}
>>>  		}
>>>
>>> -		if (!stop_split) {
>>> -			folio_split_memcg_refs(folio, old_order, split_order);
>>> -			split_page_owner(&folio->page, old_order, split_order);
>>> -			pgalloc_tag_split(folio, old_order, split_order);
>>> +		folio_split_memcg_refs(folio, old_order, split_order);
>>> +		split_page_owner(&folio->page, old_order, split_order);
>>> +		pgalloc_tag_split(folio, old_order, split_order);
>>> +		__split_folio_to_order(folio, old_order, split_order);
>>>
>>> -			__split_folio_to_order(folio, old_order, split_order);
>>> +		if (is_anon) {
>>> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>>  		}
>>>
>>>  		/*
>>> -		 * Iterate through after-split folios and update folio stats.
>>> -		 * But in buddy allocator like split, the folio
>>> -		 * containing the specified page is skipped until its order
>>> -		 * is new_order, since the folio will be worked on in next
>>> -		 * iteration.
>>> +		 * For uniform split, we have finished the job.
>>
>> Finsihed what job? This is unclear.
>>
>>> +		 * For non-uniform split, we assign folio to the one the one
>>
>> 'To the one the one' you're duplicating that, and I have no idea what =
'the one'
>> means?
>>
>>> +		 * containing @split_at and assign @old_order to @split_order.
>>
>> Now you're just describing code, and why are you making it kdoc-like i=
n a
>> non-kdoc comment?
>>
>> I mean you're now unconditionally assigning folio to page_folio(split_=
at) and
>> reassigning split-order to old_order so you really need to be clearer =
about what
>> you mean here, given there is no e.g.:
>>
>> if (is uniform split)
>> 	break;
>>
>> Something simpler would probably work better here.

Maybe, when uniform_split is true, for loop will only be done once,
since start_order =3D=3D new_order. This break is almost a no op.

>>
>>>  		 */
>>> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D =
next) {
>>> -			next =3D folio_next(new_folio);
>>> -			/*
>>> -			 * for buddy allocator like split, new_folio containing
>>> -			 * @split_at page could be split again, thus do not
>>> -			 * change stats yet. Wait until new_folio's order is
>>> -			 * @new_order or stop_split is set to true by the above
>>> -			 * xas_split() failure.
>>> -			 */
>>> -			if (new_folio =3D=3D page_folio(split_at)) {
>>> -				folio =3D new_folio;
>>> -				if (split_order !=3D new_order && !stop_split)
>>> -					continue;
>>> -			}
>>> -			if (is_anon)
>>> -				mod_mthp_stat(folio_order(new_folio),
>>> -					      MTHP_STAT_NR_ANON, 1);
>>> -		}
>>> +		folio =3D page_folio(split_at);
>>> +		old_order =3D split_order;
>>>  	}
>>>
>>> -	return ret;
>>> +	return 0;
>>>  }
>>>
>>>  bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>>> --
>>> 2.34.1
>>>
>>>
>
>
> --
> Best Regards,
> Yan, Zi


--
Best Regards,
Yan, Zi

