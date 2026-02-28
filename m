Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E351048925
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 01:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EE96B0005; Fri, 27 Feb 2026 20:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C526B0088; Fri, 27 Feb 2026 20:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDAB6B0089; Fri, 27 Feb 2026 20:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2EC6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:13:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 039B2BBC73
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:13:20 +0000 (UTC)
X-FDA: 84492092202.02.DE72E47
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43CBFC0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:13:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j0y3vQzh;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772241198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu4MrCy/Hj8ZNkpktcYu61yH8f4Y20W08DnyvEKdG3Y=;
	b=G33x1mgEhtb0tJH8gB1uIvKu78PKtPQ1IIZLobJGh6bMwZyvOCY9i83a+sE/IVrhaVUzOe
	NHYXXEAxaT/kjVu13eCVt15VF6c1FwNAbRqF1RR6ha7SuPoBKAQHfhSSzOmLbXT7QQtsB5
	blpp4x/ZAvkx1ZXTFhuWhnPr4MfqCNA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772241198; a=rsa-sha256;
	cv=pass;
	b=qPnE/u3lVI6VegvRenTj8TyFP0cWKQZMV05yHjlEkvS0A+QNnvMZdzy//tJWtOGGmBAely
	YVNbtELK2Bp5Q71qvswN0PxsfYXNmuWTtIxO6nZQFVo4rPL0bHJtviL55W1CcNRjCuOs/x
	JYKTKHIyEjn8wWYaXOdxIPIxJjU0FfQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=j0y3vQzh;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d46r0n90wAzHLO6/Hf4b3YsDPLETe3lDzPTJ9Hf0DmWDR4uYxSy+AoBq0ZgJikJNcwZDfJ9Fx3VDHckDnYi6NVk2In43NFXzciEuc6adL3N0t9U94rg46uaf8z2weqRUEaorOeQE0Cdr4GYpu6ReSFMri4TlrtHglyeuQmaZh88ES4NchhePEJ8mib7/Mdi7jYdpgUfkiUo2/x3ZnLkqqcDxMuQ3kwCVPUhIpWvtFwxSts0EKkHGdYP0wh9rumJYg1AacaUgKgbX7kyBeUteUergDucfZmshyUIZMP63yPOyR3c2lcdDAAZ+hKGWvbMJ/RDmLyO3FF8gKKJXBifVLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mu4MrCy/Hj8ZNkpktcYu61yH8f4Y20W08DnyvEKdG3Y=;
 b=UuhOmi7aGxaFOQaMxTCwnP5pHwtk5QluK3cRm+oXHaGT962jQ77weYe7TuD6b5OUSk8wd01Fuc6oYARhaVJ60iRW8Zl76MkwOqJKRs9T/EVlNv8/aaM8D8YBS0ioDtqFtZ3ldiVS2PXcHRQIGO10A8NmMSXOjznKqdtO8sgXIeieD8/oAGfVJUUDht6Ig30ix4KO+vkiWoiV7NlpEZPkqBBSxNjE7wmvXCZg/Tm7g6bqzGhBJdSyU8Ubbik26MhYEE0nzeH2SV10JWCGoZyj7mbtnhuk5bsH3duHc2HX6MbxAO10cN9XPkV5wIc/iILtUCaTJHbFAkXbbamd4N2BPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu4MrCy/Hj8ZNkpktcYu61yH8f4Y20W08DnyvEKdG3Y=;
 b=j0y3vQzhda7qHYz8JvqB274p+6jmXNGGujh6ZoirlX418ONotYLfRQu+ySdfpDpnBuHPeJ6K8ybePuyhccY7PGW6MI6MeuVeAUYesRROtztRQb4GDwabqbWk8V4Xe5uShb0dBydv3s+wCc80laEvZuxZARZyziwaPU28JendiLcBwELExVtbmnPPHN5ICUenq0I1vA59gHFFsWGpEoiBjjrYaQ1+5lEDopVpyTfok41hWqlQoXlFm5p28RWt0WmpxE4Gg78ja/9qbVrpKY/9hp5SmXfy+ANMSnSIevxp5ZyN5AGXtCQ045wMVJEcghyGB01k+6b1vuKiDSR8aq6jMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7326.namprd12.prod.outlook.com (2603:10b6:510:216::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.11; Sat, 28 Feb 2026 01:13:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Sat, 28 Feb 2026
 01:13:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Oscar Salvador <osalvador@suse.de>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 1/5] mm: introduce zone lock wrappers
Date: Fri, 27 Feb 2026 20:13:06 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E2E9A337-5174-4C58-9CA1-F60CC193B32C@nvidia.com>
In-Reply-To: <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f7fca3-517c-4058-bc0b-08de76668b17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	yzPyqamXrmapaAaRLpdVd+/cPq3nfRe2GpXrhYxOOYF951SVFK3HvvjXoaHAWOazBrE0+drnv70HI2YnjPmkTxRT3oqhd8nEKhqeIH2mivMIcvNjnX5J28n2DOiSyJbM/QtqiF6B7fKVm13iMziF69KMGJvu4BICn9U3E9jL4YT7u4/rUgPdYKXLu7YAdldm/DXepczrnbll+AOJE7nbD/q5C2PgM9aP3MWko5qm9hu4CnRAMTub/vyaklOUTCjPNIvIPXpmy7k8F41BEZ/YNpils97jToYet408/OB4AE2RTtAb1I8x39JCSFcQM9Qrj53AgjOQILVfII7BQrI4s5A39sFCRo3WxNrAQplN+yaUWHWlN5KdtyRXrwkwo/Mj4ts5ZePFM1cm9Bf0NnA+c0s8gb2rhc6tpG60VnGCd4GJvvX6GX3WupOP+q4P/1fDwwrvO3YB5ZTwYf29jMPLuPdSeYxrayj5oHQ1j5UKrr3N0mXd45IWSu6QLcO3r82FObGllrSPgzj9IOW6TvUx1BQqrYbp6N/MgbEfNfh5vw9uzo25ZVYZBTVX1zfq3FsnYkLPz2qcuIpoMlZwttmwL9oDdpvfJYcarDZUdAow26RMIyFyn85j2mpMslM3oFSPk7bi/E0V3M0cjTeYf/y30m/pBFLFiUjkOGfbtQQC2zHsoRR64TJUgPwTuMpx55Pk9/uqYb82gImnf5NCSwcIDTxNn6F4N7K9pJaEIXqx/HI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?quVnE8/OfGZZwdzIi1T9BzM6g9GfSfFdSMtQSUYFRU+VMLTzg8AuH0ZeLzXP?=
 =?us-ascii?Q?4VV762XLdBLCisS/0UwbeMcAUuGCKTp9bJUH3OMa3XBmCArQKJnpRtur8jtc?=
 =?us-ascii?Q?npyGoHUByYp5Jcl1kv9Ufdb8M36K0frpT4tKNZW3coFXzHZFG0B8nIuwzqZ6?=
 =?us-ascii?Q?LGTZzpDoFU/uD/waH1/RB6lTPxugmVNGdbCUul9a2JlM35oh9Tv46CcK36ZG?=
 =?us-ascii?Q?DXgE94h73nfoq7wrLmuk0q7PRaIBFcY4HOENvrQU5FTpvgrMfrE1R1M+lgpo?=
 =?us-ascii?Q?xwmr0Nvu+DBdjYSMMPQLrdUBnXihfhw9oWTPzRmTxjx7JpICEgxBufWcYvxE?=
 =?us-ascii?Q?TKW1byqZyvyZE0fxVWdOrw6shz+LSv0D+55M0ndDZj0/gVZ37CwL/YUuqbHJ?=
 =?us-ascii?Q?+H/C1GXJdryqq3yoeOphhivBpXyLWlydf/IojB0M8bdCAob3XhmA5IKDwQcw?=
 =?us-ascii?Q?lDFwjoLBhY2kjEBm9Ny3k+wsP7sK6HA5RGnusFDQkqyPGMHUPX9flyICrVaF?=
 =?us-ascii?Q?sxYwdZUq4YNuF+vKqPeUCIQFqiIkNAa71Xg3fxUBAYm88Pg/0HOkJKOhXNa3?=
 =?us-ascii?Q?EUxl0sZfK6LelD9R2qy7jRBsMEl+CSOk0aZodKqfwCVy+yI6VWcKFGQmp/Yx?=
 =?us-ascii?Q?t66u9lRS/tMxrd4+vb4JwkDRssLzZQ2JUaYCCxkfkMGWdEATY3qS9rNXRN9u?=
 =?us-ascii?Q?JIyLEmwvL79lFR906Gn0QaZ1uqkA71sJfJ6uiPeCCfGPau10sJuIHM2RhEcg?=
 =?us-ascii?Q?0lWn3ihn+hP8NuJOFZkg0r82cKqwszivD6HsSCA6od8wesIrOyMSpWc0oHoP?=
 =?us-ascii?Q?DyyIC+THGo9lEg0SU8lNySc41dHc7Hfcw7vYgTaYCdEnlOl+A/gwyoUtl4XY?=
 =?us-ascii?Q?lbB7Y8xm8sLoy4VjxaicCZQB00mm9PA3v2Fwmz7Ci1qhLhgMYUt//K606Kj5?=
 =?us-ascii?Q?bnfvwFt1YmQHN/A4/Sxc9COeRQM0wB8Ioo1HmdgRT9zZlN7FApELpiCU+AoX?=
 =?us-ascii?Q?J1nreCkyiRmVLV82hGd5Q+Y5cPAldjl6/1a9yMJZB9lhHkuH7p+ySoZyOFFr?=
 =?us-ascii?Q?gFM51oChlph+q6FbeE8c7wByHxpDO4c/u2jcTmNTK7pd0+c7D3yYAPRErYd9?=
 =?us-ascii?Q?4H4FDbmm8pd8M2CK0i7xppd0qeN0Jtx9xQR16bF4zLwgr4/ue1P7U/Quu2MS?=
 =?us-ascii?Q?7s3siVvyYhnK98aEAn3ivLGsTrvfz9XGReZm5Y4Dw02pMU5cAlYD4FCA1tKN?=
 =?us-ascii?Q?/Pl++BmTy//3qbkj5LUIkmBa+7zwheP7UNNysPxJfseKDikljlN7qcWIb6A1?=
 =?us-ascii?Q?bBIGZsfvZN5zmG6Au6TCitnYzevoDVAK56nXPLAQMC2vUlC1Cw7A/bDMLS3c?=
 =?us-ascii?Q?fcOchBK8KuZkFF4eYkUMbdZi3VYM2d4rA92NtZFcoKLNr7pG2c4jWFOtPFGQ?=
 =?us-ascii?Q?pNXYc1FNelCh/pnMMGfR/YozR44qxS8f5HwHjDjRLCyLdLLl8n7s9AQw8n9b?=
 =?us-ascii?Q?UDwskhN3ujAXGlnQrxsMN9WcmgY4QS3YI9Y8qX93CQeo8pHWZvQMCIKg1hho?=
 =?us-ascii?Q?4FF4/zYhXKBXWR61iWDF+1U7s8hqAOqF8FWV/fbsp9xeVWY/1CdA0YtMkyxk?=
 =?us-ascii?Q?JWB5jNnkwI8bHC8ZD3MUBuTdolyZzSZ+gvmhA54XNVUc9MiWmiF2hRd65LIU?=
 =?us-ascii?Q?adV4YuKRByrhuGhTgSL83MqUym0hLC/AJUyXYINajr1lgztO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f7fca3-517c-4058-bc0b-08de76668b17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 01:13:12.6368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1WljCQ0xUD6AK9oCPvwjOKjycpSyjhpKeuWCHXO9MhgDwMtR+kf01WyiAdK4xt4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7326
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43CBFC0002
X-Stat-Signature: d9foj8e8ziz6xii3t19gsnase57fdq8n
X-HE-Tag: 1772241198-373905
X-HE-Meta: U2FsdGVkX1+YEzjlQ05dUObHmf0y/GFtSSlBxZcsavJ4vukBQ+ai0rHPWIj0/o1P/fs/8WI4We7uMPpyBjAWLn4rbYjr5e54TDxYOcY0YoaZC6p+9Q1ECUgau5BU2enmUBMEmhd3XbYchH7Ukawv7psSm9bsUrnIfwlIEqEt/EGP7W4RURWBLPuCZGwVB0YErwMfeBPFrfNslzstgjQZBjKvJSheoymjZ2LnujZ3QaaAbbzke7fWfNoC//hcq9PabHxm8Y8fL7eSFDRgTXSskxfhJLd20GjY+9B8KVq5A9zua1/KFQtp0K0NW7ll4eixFBWuThh4wgpipUrPV57rCXUzFU8XoexZOtaFKgl18sEVTyAoATlEkOnabLg2cC9f43dlDK2EF5t8l9SYOVKb4VxnEiy7E0XzJk4YdSR2TCit6ryJaulTh74Dd60ZRxEl478TT0m5sx08ehiVufO/emjkywnsMruhByAx7UKwR+PgsQviobOfX2b45f+ACY2vbSDDR0vOAm9qayRRHnQvHXPw2F/VV80JvBiFlL24Q5XK42yYi6wB9EIDOFgBclqAR79s4or/nzJPCQfOoEUuCtwaegKZPirKL7WiZtWA7Qv16yVoDhQPtzKXTFS+qiT8T7hB9wi2r43Kmk3AQNcMnIoR9bsZHQOdRDeXRafWn8kZgClnIshuzj3m6AaFsf/hchNawcHP2yu9XLyr88mx7GaDZEHO+VhqSZGJKlfYFzpOATYcbRyzdNCz7dY+WwWW89nwaH8AjAlC5vaN73R0RhESVuPYZ1SF9Iv09qlWH510OYj/HO8ZmZrdS9OVE7ZRIb/ioJMII3MsZUKxRVYjyC+Iqeuzx8VAwZ+skvsGY6pneXJCPY/3snF8RUczW1aGkkbLPLC1Iyn3XI84z2iCN/jdjbqV+W/Vdhfi1xkGZe7czfS2O3BBT7aH3PuTl6PlG+1Jq5dLIhCeL38iYR7
 VG1Q0AIG
 LWAa9M0PtiE9PZ5CmUZItE8c1lceho4sXYm0oazyntBNMuN46U8wg3D/fYM3pJ7Jjq1lyjbF6qY9vXAsUkJyHQapBdonfErPC1CIn4wCmorPVcSNxiBSAn1Wqy1IURndhLP7y6RpAbTPknlOUhyREKowwAAO1qwTnN4YMdJYepREHbR62H4vOXgrLFdMXmKAxcQWrR8ciEeOLAa2CTAOBbHNRB63I9nOvuqFVbVvQL7bNkWEprrGwICmTA/zN59zrcbxFNMEIkvwmlOVevSB88D9oOK3dcgYLJZXUU3lKbP/IkI8ByioEdoS2FcB/vT90JN54OJFsH6iywmram94euf56OXwKABSLEMH15AM7TuzMnP2Rqv4z7RVE9tXISft3jo443JSRuiPS4hiOttTmJ4DItQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Feb 2026, at 11:00, Dmitry Ilvokhin wrote:

> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
>
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
>
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  MAINTAINERS                 |  1 +
>  include/linux/mmzone_lock.h | 38 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 include/linux/mmzone_lock.h
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

