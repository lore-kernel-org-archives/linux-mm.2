Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E53FD38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD836B008A; Wed, 14 Jan 2026 12:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B766B008C; Wed, 14 Jan 2026 12:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605906B0092; Wed, 14 Jan 2026 12:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDB46B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22BA1C1F99
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:33 +0000 (UTC)
X-FDA: 84331238586.13.40DDF31
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011043.outbound.protection.outlook.com [40.107.208.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7934940012
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g8mgZCQ8;
	spf=pass (imf01.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.43 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZgACuKl9vE4tSYzYVccCS84u8QEBci4DZNnybR1/rA=;
	b=SWhc05FKDo0Gd8aI4bEDUOzLNa3fu4YoYvJQDRfHvebJNys6InmVFMepF0VR1/ebwxSQl0
	goQmp612wpD+ghsY8NeJTSXhazfkuKJvg278PgfTxwjFACGvRErwBTMsSqxrgYpFK8qcCR
	hRgFK55dQQAxHxTO82Wlj/CbkJMfQQg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g8mgZCQ8;
	spf=pass (imf01.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.43 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411350; a=rsa-sha256;
	cv=pass;
	b=BtuD/yGXfFpJMeW0Y/WtAIOTmC4FysnHvatCPRiCYsUf1TC0jRCRnXGNKSU2NWlY71U6ug
	roKNoduNgsqXlLidVnrc3ND3Cy3xOiUcRvkoXKhi4b6iBBhg+L5ppjC04iFuH/NAzEa6+E
	YnBREuPl2d53C9vNbST4EHpIeR8edZg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M6LYlHqO5m6zhaIxImaz1MUnJLtAIy1D3Y9WDNzu7MzsP7mxkbUO5Kfptykqg3N0ItkSxeJhUDNNjbK3Vcs3eJoukuZ6zYZY9tkTWU+Ak1A+OCZd8LDhvP8hk0ApssTEOYcUfd2AQaap/Mo3r5JRKZrL4IhJhhXKDOmsLRPvQp0629BgkN6aub0uN7cGaQmGP+1859S3rucGhohaOpSWymubXSV15pwXOksUE9C1DY1fz8s0PR/VQD1r6Lb69eyyre2pW8wfaxrT6f4Nducopjq6vtmBK65X/zmlgxqYwEOGT4FaU+YtRS+gimYscwpRn5wm+EYoax8KGc+P8FbjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZgACuKl9vE4tSYzYVccCS84u8QEBci4DZNnybR1/rA=;
 b=T96rghRUXd8OvaESE4NehIMl1CToVli9KP1UOynF/O85Rew7dxMC00P0AcaBlOsCe53F/VadSwK4qCVCw68OGWa5eNm1xWd33/dxuPwaztdsEF3PMdqwkN+Y3TiE4dD0idJ9Rqq/ARKWST7Fy/8GD2CljN25lwY6ToIEi9oGUM34u9H+CxY6BfLF6AxgmHHp2/KPWJaVlwoyOhoQrVE0ySUSofWw2EAwuXkJy8B9+Pa8la2pBoge2G/uYbKyl5fqAZIKMm/0rgpVUZBdZjRoRt50o10HD68xeXB94j/dddjBb65yvLYnPVJ3NJ4Ix44tlUJKs/hkvDESz29gvarUsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZgACuKl9vE4tSYzYVccCS84u8QEBci4DZNnybR1/rA=;
 b=g8mgZCQ8863Vc36n0vMtYiqJsPrprLx47F83p1+WoNaTC+2uXAZdMOznyd51tBW07NoGNUuRRS6BT5TgoV0/Mk30w+nmZiomU6bERwiKjPWS4g/dJUjnOVncwm9dn0+TtMWiw6J+YBWwA9jdGRc92UjFPbU4y+Y78RxYPs7oZgY7GlGyP016iMmCgN7p3JIg3z2PevCN3dZ3qDREhft8Ewzd4+GMwEZfipbU6JNRFbsdDA3LYCw4SgANyOSbPMNBZdkszm3KBoi2YPNgXQ1rL4xRwMDnODHCnTJ/Esp8QC+MlVwFWnYjJZPcO0TEzw9CA7FYgUQhyj4CtHetRe+BXg==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by SJ5PPFDDE56F72B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 17:22:24 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 17:22:24 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] mm: use nodes_and() return value to simplify client code
Date: Wed, 14 Jan 2026 12:22:14 -0500
Message-ID: <20260114172217.861204-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114172217.861204-1-ynorov@nvidia.com>
References: <20260114172217.861204-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR03CA0047.namprd03.prod.outlook.com
 (2603:10b6:408:e7::22) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|SJ5PPFDDE56F72B:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9333be-7ecf-4d25-5751-08de53917bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IOWIZDGa5NTkZdzz9u8ccr+Yj4ByXhmLAJKxWuK6EJVppSE4mQgS6NlttLkB?=
 =?us-ascii?Q?hUQn+Gmoxtdkeh5tlm2TUg3IItDEwpX+rHTC+nrmJAilY/9aCsystjg1k3T7?=
 =?us-ascii?Q?APkkzhEJlekRM6RpcWmrXVY1Hb9Ja86Z+2OGJ1y0FXfbjYlHlUUOpeyMfMA1?=
 =?us-ascii?Q?eESMbRh32UEUc2B0P7FxXdWNYNSU70i0D6sz4dNFb9KXAhcMwHMurE2C6P/G?=
 =?us-ascii?Q?zyNTe38A1Ba16yNPr9F3NTfRJBCFcxk14pwfJb0WJpTWJaFTSqFikQBK4DuI?=
 =?us-ascii?Q?DgBA8HKA7JV/0yi2QBxvFtGc/GqiMSPk9o3n5YVSw0QwA0TzszsQ1q5OSTDv?=
 =?us-ascii?Q?bzt3e9GrbSlu/sEwNHzCzHMsTvocANcViUg0A4Zh7NcMmumNIySzy0VaDtRZ?=
 =?us-ascii?Q?D294NEYeaebLB5d9JwQbgP7WEnEZuVe9wO/VrgPFMUJ9/4yFIIMCFCwRKTaL?=
 =?us-ascii?Q?LGZYugohMxDcV9gNUHrHePZTVsh3kWdtwaQlFH9lXZEsDqs/7dgF6Uy+HsXE?=
 =?us-ascii?Q?GsfkKHw/GRMakjHy7UVMsniS4WtRiT9vteSspqp0o8FK5LJpfuPM7CMLSQ/B?=
 =?us-ascii?Q?SiZEJJA9v1hYRDFRiHDUFRJ7RKqqQo+PLOGwWXLgU5Q5Rcqh7MZTccCZccf+?=
 =?us-ascii?Q?mLG8Y1Nx9KIVIgbAE+SLY3ggmPJWYxht5W9CH052aa712dVpZAmWfAeUOWWr?=
 =?us-ascii?Q?UEwx3ssIf/0Mxg4a1LFmyccyQa2SGGS2L9GCVQ5cH2jpmkf/D5IgZxeP9peU?=
 =?us-ascii?Q?KAQ8mva1xjT2+xINLRLogmp12CjdTSX7Ypg3uIffAZrepLD73QgWDFhFV+Jq?=
 =?us-ascii?Q?og0R1MB92dr0tIatkrlXwnKsanQUY3s5xCaZK/rMbMjjypeioVV5EhAi1AG6?=
 =?us-ascii?Q?VZLYO3Roo0nQSP30t/dOQos2vDvh7us/QhWJTsp6UJ/dNoFGZASDep9l046C?=
 =?us-ascii?Q?ibv/wGJISJ2e3ykye/A8UPdGhdvkuCSUyyAHvz3u+5Sbf6d/1/R956TnEwLs?=
 =?us-ascii?Q?N86zxinvaTYcwd+8lRbtMb2Fs08vPmTFji5yoVkCYvJ/t+kkcezPBTMz9mcE?=
 =?us-ascii?Q?tixcRhxISdhGslrDL4YoCH3zbv9iXBn3UBBzSFK72j1R+EqVXweZdW91ZScv?=
 =?us-ascii?Q?yVjIVvtCHzHgLCGftU+KA00eeli3i9Yy2pFeF/BTER1WRk92JhZfUAm1mzj+?=
 =?us-ascii?Q?XXHwLcR1b/YWE+wYZRN47WUVhnrGellgTUDoNnK/qgr5e6aS7iJD4a+RyPI1?=
 =?us-ascii?Q?PYreZ4ssBFe3l2bpGZjrA1ANMAg7r7wO5WDwEeIu0R7TEtUMdFvCnJLufigA?=
 =?us-ascii?Q?itG4SqdXJ2O3+xcS4NZ2KcQm4A1nWJAMmj0Elf6BGoECq0jELK+BptxwHtwV?=
 =?us-ascii?Q?Uwd3p8wzf2XQ+3+yhWkVT53F8rI8pOdC9tIwFpfzfgVcoZjE9oFzhByxCjBb?=
 =?us-ascii?Q?dm32OXHS3J7Rt27ejIj0D4apZ8eS15L8rwtdEW1Th5goJX4ApdWsObL3jSNw?=
 =?us-ascii?Q?YB9hDsalVorsr9vB3PVUYUf/9bxqWthJ8TEfWEAWgXw2AZTYSXvFS9uG/7VW?=
 =?us-ascii?Q?3nh+0+LfXOUwHhdn/TmEK/u5ga2mRxW1EgBAC0XEInrdbWBtXGOTUkbWjW/c?=
 =?us-ascii?Q?Hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vB/7NwnyNaXnkl638OUzAH2SQcePaIymGpFX2bcKYrBttTtQeSNEkwGSRFKp?=
 =?us-ascii?Q?3OhqSJH0rI0QSeIUtpqH60+wCNuNDyt7jULIeNCWx3kUdHjA4UC6PF2oScm2?=
 =?us-ascii?Q?Rgn7UyLXvSvyLy+9xh1rSTNFzikUD/GFHgXOWyLGjGaUFE4vmPVOKjREl4Fy?=
 =?us-ascii?Q?CM7kXdJu2alVCrBi3BdwHmbz4YSpux4YsjcLtCdtWD6dZtGR1vSLPUgNQCri?=
 =?us-ascii?Q?K3IFj165JK1q0M3eQd5pXgiLnUewQ+ckgF7cS4W1HWEDmIkTlyvyz+AqHKcF?=
 =?us-ascii?Q?+WVB3IpeBD4fcb/qK/MpYK10uZkAddTmIJFB731EbL2P3MXeVX7HG7KNKftl?=
 =?us-ascii?Q?fNPVxqI1r9Hbfn7/JW2L1ckJYTIOIQeZDcHA+GByeBN6pMEv7moSDhrlZwBT?=
 =?us-ascii?Q?1SaGTmQUnzOWeAo7Vvc2U++UwNhdvZoSkuYg6YYvlzuQR0glQ3F5TD11GAOb?=
 =?us-ascii?Q?waDO0uUEVwcAC9hrCVd8czT/WAhk3DQHzMhf0q1fy/PbkrEV34Z3NWXKXRTa?=
 =?us-ascii?Q?CJOmIzneRhZ1dWRO90LG+X77/wqxvDNvA20xacPL6wJHwtjRns5YcJ/aum6W?=
 =?us-ascii?Q?Wl2R2Edm9Kq4R7lf3mb2PARuoNWU3hd+5ksDYqG1XeDFxVY2LQhpJ7GNauG9?=
 =?us-ascii?Q?RD2bq6IQuTD9+wA7WPlfpvXnfIPmxU3mVqqKyC4ikrxWkPQj95NeUeZniDAV?=
 =?us-ascii?Q?Q1rFTurcbxJTkPjBmmBj/I6BmP2vQ0LqxSv9Zwjg+obS2pwidrUyw6JZHCe3?=
 =?us-ascii?Q?Bm8wg+mNT5o6vidjnj0GiajVdCb9yRey5EFnYNUr4J16htvXNlqxylNa5bCx?=
 =?us-ascii?Q?od3g33p/oWee9Gacne47aMh17AsncqXKjGExDnTRrD5kw6bdc7Iy0bMXp+KL?=
 =?us-ascii?Q?BWVSuRNIDBZQCGpHC017LrggtZHUMc4ZLHYTpeLMxwOA6gYgTFwNmspmp5w5?=
 =?us-ascii?Q?4odXkDIv/EzMbLMO/6KagQ8wCr6+9fxHMk3XE6XRlX4GUB6gkR/wfXRew68y?=
 =?us-ascii?Q?GVJ8yuG+WMVurmWqGpykrNCGkPR3k5lRMkDIW0YPqoQYrQBUQpitKX7l77mr?=
 =?us-ascii?Q?zZuMhrEhWYf1Y070pkx4xsXNCI8iGPIjgOxB6uKsvYn1ElnuuQ0ePqI/AaPZ?=
 =?us-ascii?Q?P8OwFgcOMK7OzN7PIqqPPQJcfkLtXMcayzD9Kfbgj0TIeQLq9Y467fr4vjWy?=
 =?us-ascii?Q?ttNQam7Pne0jjeX+jEUBaHb+llwd47ancSvQmYNFa118S+KHX704jubj28Ch?=
 =?us-ascii?Q?oiXrbwZxGMgknNRLpIeFH7Y5B0g+r9OD6DKmSvkd13dYkOkp5lm/ttNXSl5n?=
 =?us-ascii?Q?KL+DxDMJ42lkAJs9NTabRbyjQJRqcpgq6CS+9DpYnmx+d4iAHIgr+ISfQYlN?=
 =?us-ascii?Q?1eRWzTy8ApZhxDTlvp2I+d5YKWSVZtiL9jh+9tBmsl1/e0UWB60zNyymhLBW?=
 =?us-ascii?Q?PivLAylu6sqaMOmJrQl2pMvagc6E1yqvA4y+UCOrlFojCdBMcrQppdJI8G4V?=
 =?us-ascii?Q?fpZ3jkSpr+NDdvKZSb3b//ZTt7r2867Fd4YdomVVeI5w+bOL+uGDzPFTXEEj?=
 =?us-ascii?Q?0+nueJL4tjOmw9LZI/buJA+pZ5rhR7Mi8Wrq+M7+PSB/3zcSEqHtjy/1ALLP?=
 =?us-ascii?Q?g9MndRUsWwMC6NpltuOdTgIcdythWQsRIrYswIElvGQZpXpIoTyakfL5Qs4S?=
 =?us-ascii?Q?hfLRZ/rVthgttnpv5nF1I0SIGf0sNLfekxv95/67A4nhj1Esp+zRa1ho9Oin?=
 =?us-ascii?Q?K0AvneW0nJwdJvc5NCI74ADmO7LcMoThH4eLhwWQfwThL5SbKjhJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9333be-7ecf-4d25-5751-08de53917bb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 17:22:24.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xyl0a6ysaNi6OVVLf17vriIZyjtARqyA7Ye8q04P6FkiEFRl57iN1CaeAycMbIzGxYFXFqTbMILrfmZjj1Uwkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDDE56F72B
X-Rspamd-Queue-Id: 7934940012
X-Stat-Signature: nqt5hn1jmrrc6iszdsb6nadrsay3w1mn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768411350-80493
X-HE-Meta: U2FsdGVkX18DDkrhHqbNm1BCSEL49Hhrokfolhh8VPqzF0h/Ev03AJHWU09ubdbRlEst7JAn6DNPeNFb4Y91x/jJgd05CdEKfMwQlZ7UorySSe5gKpBOc6PD2mQcsNfpqz74byyg/b++kmPrtrQwXiglbaXzUpYqvbxZLLor+O0HMsrUvBTtOKoeGeLY2TVT9BjihlusKYx5Ur9Bf2MlAy3VNxLG6mL+gz+pM5R3kQbgebeBC895BPN65FaIGMK1Zql/tBO0sTTeeGvKPk9tFsTRYQBiB74F6l37DnciwjhNAJiFb/tPbYTOIjDFBzrcR9//sg9moreDXUXIccQzPonpK0H1i7J7GK88OBNhQ9tBIDc4mYt5cOsSSzftTuDKEUAAGT4eTa901gbSHdoBW7YPYkbi1j+iiRWg9lvLbdQkwX7ANz9XrTiDeLZno8fLilbpRFqjnGg64C+Un/19I6fp7sgjJGoNzgteZqBh3tDh+8cDU/W0Oz/8NeQreLR3ci7jc/Egpz6IMC/Sjez5syR3PaShH+ItMDjxbWJSo1gdMPwdDMbwYADyPJobgCFlLHR4+pwSPM+4Jgfdkf6sio2JnIUMX2aTuSh5DSE4NnciN3INtPMwdEfbIhb76N1WO6dMeIvJt/LYEKb2U0e883W3uYvgNEozINRgpgkRocqej75+qhrIkbe+KSz4Qlhg3XcboGbJp/QOHMzLVZOSVkho0v4jqJ6pCfDYgbNBu+UpkfCq+gYJMay4P4GVtyLeMn1MBBownY6w2pSWArJhM9bob3yhv6aYk6q9qQiSMbOEj5CEuLHIXvs96xdjyS8CwRHGfIdElsAmEn8GN5xHminWex4Zpei9rZwEQvLYkvZ19t/6phIquErfMg6YbteDEcRPCookEs72PIhb7p//okMmLPFMOBTcQnZHAPmgfFJpdGBeBeXXyW2mJE2GYi/ab+OO2w1MoSBG/cYyngm
 n7ZLI97E
 PzrPrtcP6EFH/dryU/xPNXZ+Mkt8Ru1hSfjLN6j+7lrxgLX3CQJRxFxK4FEbIm4PYEO4q1njKDuj8W1oSSt82W1HDc0ZsodGuOV0urUe1b70B8wpYp68vQ6HQuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

establish_demotion_targets() and kernel_migrate_pages() call
node_empty() immediately after calling nodes_and(). Now that
nodes_and() return false if nodemask is empty, drop the latter.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 mm/memory-tiers.c | 3 +--
 mm/mempolicy.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..2cbef49a587d 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -475,8 +475,7 @@ static void establish_demotion_targets(void)
 	 */
 	list_for_each_entry_reverse(memtier, &memory_tiers, list) {
 		tier_nodes = get_memtier_nodemask(memtier);
-		nodes_and(tier_nodes, node_states[N_CPU], tier_nodes);
-		if (!nodes_empty(tier_nodes)) {
+		if (nodes_and(tier_nodes, node_states[N_CPU], tier_nodes)) {
 			/*
 			 * abstract distance below the max value of this memtier
 			 * is considered toptier.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..92a0bf7619a2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1909,8 +1909,7 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 
 	task_nodes = cpuset_mems_allowed(current);
-	nodes_and(*new, *new, task_nodes);
-	if (nodes_empty(*new))
+	if (!nodes_and(*new, *new, task_nodes))
 		goto out_put;
 
 	err = security_task_movememory(task);
-- 
2.43.0


