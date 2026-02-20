Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561F1C5AD4E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11276B0088; Fri, 20 Feb 2026 14:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3FF6B0089; Fri, 20 Feb 2026 14:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C1B6B008A; Fri, 20 Feb 2026 14:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84B726B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:07:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13F9B140235
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:07:18 +0000 (UTC)
X-FDA: 84465768156.16.E139AB3
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BFD220016
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:07:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E4HOKUbe;
	spf=pass (imf13.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFltgCTj6TDV6jSQm12qejvORCR7YA6nrTK7BdXV9v0=;
	b=MXb1MTSDNngkXpFqAuQwliGnDTzowCnXaO1y/o4JM4wdTEq6kxJJsLMd+7hzI8rL3mV8Ro
	gX+1QDjwQGwzfbAND4kNafnLSmGwY0SrIzj5VaIeDbTg4hE1uD6Z3yMStVCcLlzkyzbrwu
	L6JF9rRt8sal0y/6BlikvYiQDBlcHmE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771614435; a=rsa-sha256;
	cv=pass;
	b=zSPlmSaos03VlDvq5Ga6p2l4A9z0kbtB67f7JPU+R06XcNv5cBuvlCy5cN9B1+3LuB7EX/
	voj3dStYqPOb2p2OJggF8M0ILzxCBTzKsPEek8iOChwcC9KQQbNyMUE8XDdeoqvFqfoYS2
	cpuG14YDRUGiIYrlvob5nedOqw/TWSM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E4HOKUbe;
	spf=pass (imf13.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcDbtSTTFmZpuiC+xIzDkSx04tXNagQ5U/0UI70Le1x7SxkU+4R4EHbksNH+YlA9ud3Vj3amubUJ2cnDjboC7lL7qQy2tWJZSDOUX0ck5ahVAwsSvaCUD3HCoXA3ajmuBBFIh3yqWohDDaTqnOtWU9WbJ3aHqY9ZOgj1jzcsoX3DsbMrahLKidznGHJMZ6AEsmc90naRWvxDNUVbuurhd90wjIQq/87HnQCekDr2gCEZIj0vTCMu5sujm9e3z8gMegj2XihKv8SaHSwb/v7+hsLhSYjBkWGdkdXatbNCEZ4gPf/Xh09sI39ZbUR6BVZPa1hhvb5Fs6SwkmKgDgDiDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFltgCTj6TDV6jSQm12qejvORCR7YA6nrTK7BdXV9v0=;
 b=Q8Upxp4TbNdZ1pLYU+fCusqHZ6Pfw0xt15G7RnVSYl0k/Yyl14j9sOAEbaMMMPsGaYE4XDeF6FqqA24vxPQ3dF6Y55p2szrlNhPxnd7awsqxPcjqrPn4O8VgY02VLUVfT+9+xwKlxhXX3SFwFKo0DkFq/JVlAXi3oFm/CrsEczNwunBfF1vCVQVZRTcbzEnoz2YXlQ7cppBOPy5IRD26VwdCLQ2Aon8fdMmwSvJpggGH/AZcLDGvkNou3dNEsrnf2iJtOm2+OQlon/lHp9M8l5kE4azuZ6xDFm/iG9vNiEW2iKohfO3OeY6GGRMHH+7EOc6mBo7ClmB1dkbahljKnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFltgCTj6TDV6jSQm12qejvORCR7YA6nrTK7BdXV9v0=;
 b=E4HOKUbeAzpYNyvfyNfeLOzHZuVzppuMShCWvNK8izpjybpAQ5wGtqDLnHiIzVMv42pkRuGxivs9wgkV4o7j+D+8i3nVEUjWIXixxFy7/kDrtr1eXP0CM+NxZenhnH+BYKena9J+48/3LHvWdgj37YHs4/7hjzFKsvS+enRJNdnW6LOjJt+AqurJ0FKZO0mSFRZAL8Aq4EIHb0PJertNN3l8wEH/bjKah4GA3eL3TneRawUBRho556DpypIx8Cd2kaSmbSkOJR1zSdw4gra+c+RORMXFNQfH6Q48mtQH5u9HnKExDDRQHRqDNDSFAoOqdd+pl+KcoLsXXHBUGJPC2A==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 LV8PR12MB9418.namprd12.prod.outlook.com (2603:10b6:408:202::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 19:07:09 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 19:07:08 +0000
Date: Fri, 20 Feb 2026 14:07:06 -0500
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH RFC 00/12] Implementation of Dynamic Housekeeping &
 Enhanced Isolation (DHEI)
Message-ID: <20260220190706.GA2173704@joelbox2>
References: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
X-ClientProxiedBy: MN2PR19CA0058.namprd19.prod.outlook.com
 (2603:10b6:208:19b::35) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|LV8PR12MB9418:EE_
X-MS-Office365-Filtering-Correlation-Id: 15d65b31-f667-4d65-e97c-08de70b33e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MHGNhKDwCPqNUuWU1LMsnBuM09/EKwtruRkAbXB0E9fEQgBZvCE3wo4u4TPQ?=
 =?us-ascii?Q?lnGytX/6FSTqv7xO4HV2r1Yb6t72FDpLq//ZBRToBkGYvAifw+sn+hg7v/fr?=
 =?us-ascii?Q?AsVl/UcDNAqZmbJbeLyYhy6Z+wXmY5n5CnU9ZO6D0wt5YZDeHA8sVlJDbnDb?=
 =?us-ascii?Q?PI+a1Y5iWBBku8Sa7JLX9xr90NCd9YA/0YyvmuSp5dhMQGBhrOi1Piv24B1o?=
 =?us-ascii?Q?o+VRAl258F2fgxCh1qgSd1IFfNWVdH74SHsyFkRMr729uqMedY9e+xgunGGS?=
 =?us-ascii?Q?XrKAMQn50DW6MLH1CCvOaPjATA4hsXRjBUkF6hAeF7wTPfNMFsr0rpcVMZ+b?=
 =?us-ascii?Q?KIXbqUaweh+f1sk8DLbrDQFYuyfxY6flNQiPZwNPQ6Ht+9d1fPKUWYVbjbko?=
 =?us-ascii?Q?JVVgiJem2OVbGEUpxhCzzrCisbTbZ5l2evTQFeUPpsglVuB/AbGrFeL4V3Ar?=
 =?us-ascii?Q?26TZcZdygXMmtbePU9D4Ybj6ULrq0MrMaGpiwgoh+O9SjY51nVderMBtXysw?=
 =?us-ascii?Q?68vGT46NrtKx0MW2jJNmJxlmbbZd149zdekBKAymyR47Gv7n6IoD2/MPxgrx?=
 =?us-ascii?Q?mfdigKMUfEGjvhcxORNRkKxGS06+ZMs+owE1OM7OISPXmNUn1i8upehJJ0Ix?=
 =?us-ascii?Q?/AizRzzqsg2ce8hIOnBX16U6VU4F112JCd/4G5mM7onmJJttaNYnL9Kfe/4Q?=
 =?us-ascii?Q?1Fr9guO/BgH6EaI2kVpi1c9vv6RrgEUILqxW07kFnhT/YlHTzhS/c9cJ1F5q?=
 =?us-ascii?Q?b7UvW1FqWkWCfOJwJoGpYHtsgIzlAcPfAIjfM4WIoTbZzJrMlp04ylBmgrRs?=
 =?us-ascii?Q?4rYDj2quaAiP3q3h7N9n/MReovbpGsNFMxuM2EqSOMHNyq5pUSpIn5UI76oN?=
 =?us-ascii?Q?I5c5VQODhqUNUDgu/2AXBMgFQq+JtUxsKsF4BqwSjEiVrTcreKp29mm6ubEy?=
 =?us-ascii?Q?GrsCf20v1SHoE8nB/mgBBNax4QoY5l9P0Ar8nftkgablticMzNZQeZym6ZnD?=
 =?us-ascii?Q?4zujipf5iHzgQ9c002PRu+kGRrIwnAm6GfHjYkWHBD+UoMVjVEIbGX5H9IfC?=
 =?us-ascii?Q?1waMc+knhx2123qWWKzah+XQC+lEoT8Tzq7gwni4idCum7kDBhop3cpTrcZc?=
 =?us-ascii?Q?g8l6b38QDWxbpa43s28NNrX4C2ysnMplQ52m12U9BxXRDofZedgqvOiDUYzP?=
 =?us-ascii?Q?EZhuGxyWtwcaf4k2vahsAT3G/3GpAt5mQNUCm4eTR9sATOZLQLzt3XS7nXAb?=
 =?us-ascii?Q?TKiK1rlaVDL9vr5O/v4gkYPb2SJtJ3ValmoLeRGK2wK+vGpscshjlj26spoN?=
 =?us-ascii?Q?7OkaD41SPbCnyeOV/HIv01gO3mCwx6sLqvrYXeTAFh26XBekjy2j2ytDJ2jI?=
 =?us-ascii?Q?zwRAvJTM16AoIMsT8tZPynRq1K9FmZuqLXMKlNRlm2Ung4kfXvFRRiZxEgXM?=
 =?us-ascii?Q?HGnRSc37okL/ZD+EfQFekg5dCAVFC+eyAVi58oxNW7foXycU1dFHXq9atM9b?=
 =?us-ascii?Q?ItuI6cGyo5zvPAQ1Qxu+6AqEslI3Xn3fTsIbZRW6SeWNHZz7z7Qt8yeysf03?=
 =?us-ascii?Q?BpaXPAfrjoPVigA41jA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T7RN68dYT1odAfPzujS2QkbU8U4IqAeLrv2150g7R1zZCje0iuleXzBw2Hgo?=
 =?us-ascii?Q?5R03GrU9NvPs25Xqb5Ii2E9HOCrs7r8vgERR7k+qfWba22epF/wGIj8bmjHs?=
 =?us-ascii?Q?kNduDibHOYAyUrGrt02Q5921KxjDhkIw269n1EHNIN50FjQTfc2RHp5n5G4f?=
 =?us-ascii?Q?suZVL1ARe80utNxhixPRY1W+AdOKfJWbHIADLohbjODAUiVxQ/zsrpHW9ryV?=
 =?us-ascii?Q?Qh6uhSdIF5lvBFyKPpGQ8oFTFP0itdCJxnpnv6J+R8xpgpi0hF9/tZU9N4Z9?=
 =?us-ascii?Q?Wy152DX2tYDpJg9of9PVCQ7ZL8a1jcIucx76K2K1XjoG+cBj03CV6nGYgt6Z?=
 =?us-ascii?Q?z2Iw9J7MtsvJsYL6aJd/KrfLCSNxh1nvKVpfBgnuJVJTlql00axrtN4PiuFv?=
 =?us-ascii?Q?gPtO2EDDVIwHJyclAXjyCxmvwlx4YMXlUIwSknhXx0BHS5SCCMVe1kgUC1MA?=
 =?us-ascii?Q?dHxIexVmAziHm57gcXfzYIb8RpWFdJKS2fjuaGcrqNco3dVuClvV3PL47brd?=
 =?us-ascii?Q?Zu/HAW+WCtvls0opVyDC/AC8IY2VfCwedFLsFttzh/f68ovOcxl4exOQuzlT?=
 =?us-ascii?Q?Esng7qtlxdQvGtW4mhvi2/SyXg9//XiVy7x2o3u1Yvh7jRiWCRKzKYnyknS3?=
 =?us-ascii?Q?dONIipURNxvgpOLzXKHPZPP67W3hBGpV8m5jLSQdeSjDDotvRH9mcE7fKhnk?=
 =?us-ascii?Q?Sx/h4xg1h5VNebtQ538smhMODfZe/3LEzXItMkBwVCn/NfEU+ZXQDebQ542G?=
 =?us-ascii?Q?UvIn+Py5041TtXgAdYICVj0HeHXLEzEyWiEOss5yHIlCf7Hu5/dSN4PKiRHw?=
 =?us-ascii?Q?Q8QyohyFFwWGIB9rkkcY5Da5buOIVm1QPwe+c1CKa1yeMOGLVqrQ4o7TJ0o1?=
 =?us-ascii?Q?eTUYLyaLKpzAiQ5mx3n9lfsH51mpYZO/NcCG49iXLYBByWMCoP32rLihHOrh?=
 =?us-ascii?Q?5q904JUDkwdwtk+q607kCVw3sGzqkobHvCLk4voyuTHiB9tRXEo62U69zAmO?=
 =?us-ascii?Q?uSOnzSCVeMvbzGUi+f+6Vx1KWCSGeAPNJ0/0gHtZXcBFmh4+m9P+7/wz6UO5?=
 =?us-ascii?Q?mkgEr7s16LDsBrekoT7ekFRzsvInGqZ+e33ddvI6mHxj8Aq/SMk44ttjv/CT?=
 =?us-ascii?Q?97GSxgnIIIb55uofEPTztH0huoEQM/S6Y1916R0+gloeYoVeXhTqYocCxALx?=
 =?us-ascii?Q?Vc5+y3NbBXO+9qtDryYXnFk/yCaTXhI+A7k64J5LANq/UxbtrNtfTckzOhwT?=
 =?us-ascii?Q?WlAbttEDQ1RF0jG8rv0OHX6gBU0mCLc0Na/sqD86iLakRWdLWJgQ4JuqXhUn?=
 =?us-ascii?Q?of8Ol9uASERvsqox1fo/Qp9dwprHChhMdTM65idTfFHUGL7mUpUynd3jghhq?=
 =?us-ascii?Q?7j9sTt5bGx9AKEeQRWxhB4dFDdqfV/3t/i93aqT+ukHbSNiuP7bwDxwe1CIh?=
 =?us-ascii?Q?NtUqOzaTQW5VJFsW66HGHR3iZdVA8gf5wE7+/IvED0GuAGaJDLWE18TJEIoX?=
 =?us-ascii?Q?Ew42bMPLPwrA9vr7DqYVHuUt/RTHxOz//kPFwGSSvBKkmQouU5SC+C22SdQt?=
 =?us-ascii?Q?QVW8EMh2rMSO0F2t/KX3ZukFboOhX8D58QpjAZFqBIqEGduaDevj0OddUON0?=
 =?us-ascii?Q?QltjO34ZVWigY05RT5jOKib1qS7FrTo3xzEjBNvZyg9rXn8/0kYnlnFwHxsh?=
 =?us-ascii?Q?FJSNQ4NokiQJXHh0LZy17aspychMECkst//ZGvT3MUl0T5nRToAfUK3D2yzr?=
 =?us-ascii?Q?ZimKFtpdJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d65b31-f667-4d65-e97c-08de70b33e2c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 19:07:08.2359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9LD8l5Ut5n2greO66x/8xANQN/9eGX4B3c5jkJCRAOu7lg/0llz+t40HR3VGYAG9dxXqlNleKRNcyFWoGv/VsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9418
X-Rspam-User: 
X-Stat-Signature: rb5hkuhrhisrjoskphborzcwcztbyuz9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BFD220016
X-HE-Tag: 1771614434-917145
X-HE-Meta: U2FsdGVkX19zoh7Sgwk0jtVJLsX1ok02j37ZVMD4GoX9sI09fLrb0YjM1zrEO6KE8Rs+Cy3PhtpRPhdY9+xfORzmL3bJ+5XL8KDA1ETxqpDJLMC7BhxYcbr+b5QXdSOLPXD40pRyO4/1UFlXmuDlHNQEhIDrvxINOBdDWBQNnNvJp/dEKnoocELhmpxeTsD8A+uIEFM7p1yXh4XcyHZ4IBoeesG70vlrhtFGdiHZf8Im1eMqm8l/6JHx5zzO+MKHGuwCcp7NTAqNuaZ1LLOk3Agfp4fbkviAucF8e2Tz2ljeqvhJ6fwTqf74WkeV4r3nSz7sE+0OvcH6e9BHZOEM2NvzKVzR4LjrbhSOpXoMJn7dDn2VJ64Q0MZXebEPQi4ExTq02Az1wIMkZs7F4McIa0Y3w3aPn5NrLc79kcvIzaGnIOb8FndPTQ6TbLsRW7ZP7SMwRHK6hTWxPfOdOeWer++Xxa2JzcvCLTDkG8BPPWXKwmyOdAYaUdvEH19/zji6tJhElLLXi5Rsui6MSSHyNuW4sHpZF+IjMbseg0tQHMbbC/KUQm46UXJPGgF2oKhxly50i/uAUIJ7+8n4esmkqb1A55Lm3NImZIJaHguQgpvUahBeVHPkjI6aZ3UQkJqBzcYXbX9tGJvOuX87l3ZWAT+Pz4LoqcKIChCkRd3G5W3sz7GDT5s141jXnh/UnBOPIIljQ+6j5IlYxkLCZVvvjA1xzjFuWggjunrL4H0l36bSXbECbN5n/LGGEdHqgCQS2ni/1G4fcaQu3g/Koy3d64QZvVQ/f2tmZQwerH9I85u8r/zXULJkydoxn1JETRMdh35Ut1d3u+ed1L3qfZ1GisAmbZNy43Ms0WNWUJ0tRK4489XDmmsSPf438JZ6xXeTeUgQlWADkRvjZej4h5wjV2kwKBGgMVRRUWRMzJ/sO0E4VX+qzSTl3vdjUyRvZTGF39l5p4wNy7tAIeWzcq2
 x37VUqxm
 g1QJjlD66C/J70ODHP6RNkVKdegShsqtLj+dvPZJCP26wufDftuuLkVMxh6Eqw6Rjf+QigRLhJ7BX+Lv27/WxXblM3LGRCcwPq7Rp8wpBXOwqZSscqyOQVIVSJbJL2AmvzTp0OMf2PXdTRiFM/sP9NfEZH9ZaBNJZUvXSRbjuolMCb85Sna5Joysz/vQaBZTrhcK2Ju9g+VBjtnclcaa1MJ2Dsv5/0Tiq3vqlpnn0l9PMSMAvH60N9EJ66tgsFhOG6R2J2VJLm9D2ohF0C/D7WDHqqL/cdF8hThclAZwI4ALLLEaMpKtOY5N+uoUifjrS0LPpZpBDdQ4QbwVG/mFHxRernEIiU7RNrd1g6IqpeoOje+APX4O+qmd6OaKL0EwBtKQT05MbDyyHr1FjAiHVgi0kx6UPDqm7DC+QwJq9ctVncjzOqDmgvZipnLAvrZhd1ZBbva1bzgDQMCnpcLJEBV7Ly2NaEkkE34us4Z2RzjHdb3hFnncYa2FdXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 02:04:21AM -0500, Qiliang Yuan wrote:
> The Linux kernel provides mechanisms like 'isolcpus' and 'nohz_full' to
> reduce interference for latency-sensitive workloads. However, these are
> locked behind the "Reboot Wall" - they can only be configured via boot
> parameters and require a system restart to change.
> 
> *** THIS IS AN RFC ***
> This series is being submitted as an Request For Comments to discuss the
> architectural changes required to support dynamic reconfiguration of
> housekeeping boundaries. Key points for discussion:
[...]
> This series provides the necessary infrastructure for cloud-native
> orchestrators and high-frequency trading platforms to dynamically
> re-partition CPU resources without incurring the downtime of a reboot.

Could you provide more details of the usecase and hardware / CPU topology? In
which situations does a boot time isolation boundary not work? I think
knowing that will help discuss the need for this.

These systems typically have a lot of cores, and only a few of them need to
be isolated I believe (that's my usecase anyway at my day job).

thanks,

--
Joel Fernandes





> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
> Qiliang Yuan (12):
>       sched/isolation: Remove __init restriction from housekeeping cores
>       sched/isolation: Introduce reconfiguration notifier chain
>       genirq: Implement dynamic migration for Managed IRQs
>       rcu: Sync RCU housekeeping mask on notification
>       sched/core: Dynamic update housekeeping_cpumask(HK_TYPE_DOMAIN)
>       watchdog: Allow runtime toggle of hardlockup detector on CPUs
>       workqueue: Dynamic housekeeping mask update support
>       kcompactd: Add housekeeping notifier for dynamic mask update
>       sched/isolation: Separate housekeeping types and add sysfs interface
>       tick/nohz: Implement dynamic nohz_full state update
>       sched/isolation: Implement SMT sibling auto-isolation and safety check
>       sched/isolation: Bridge isolcpus and support runtime tick offload init
> 
>  include/linux/sched/isolation.h |  40 +++++--
>  include/linux/tick.h            |   2 +-
>  kernel/irq/manage.c             |  52 +++++++++
>  kernel/rcu/tree.c               |  43 +++++++
>  kernel/sched/core.c             |   5 +-
>  kernel/sched/isolation.c        | 252 ++++++++++++++++++++++++++++++++++++++--
>  kernel/sched/sched.h            |   2 +-
>  kernel/sched/topology.c         |  26 +++++
>  kernel/time/tick-sched.c        |  63 +++++++++-
>  kernel/watchdog.c               |  24 ++++
>  kernel/workqueue.c              |  39 +++++++
>  mm/compaction.c                 |  26 +++++
>  12 files changed, 547 insertions(+), 27 deletions(-)
> ---
> base-commit: 1f97d9dcf53649c41c33227b345a36902cbb08ad
> change-id: 20260206-feature-dynamic_isolcpus_dhei-ee46b6e3a477
> 
> Best regards,
> -- 
> Qiliang Yuan <realwujing@gmail.com>
> 

