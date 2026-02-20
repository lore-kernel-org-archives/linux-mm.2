Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAC9C531F3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 00:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16586B0005; Thu, 19 Feb 2026 19:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE1C6B0089; Thu, 19 Feb 2026 19:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0896B008A; Thu, 19 Feb 2026 19:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 790356B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:52:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED66413BE6D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:52:34 +0000 (UTC)
X-FDA: 84463009428.14.EC34072
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F5898001C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:52:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b7rBYNLw;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771548752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eq1/6VI3rqa373X13Mi1BH2INOvmwKrjiJJpMw/gYKk=;
	b=7XLhziJDvz5LiPyacn/8HTl9fmM6DWcHBWYO4WLKbOsaJ7ZIhP4uCxt0qhu46Rha88eG2h
	N6IUSkPGI0CxlVXKB6EGlNhFZ00LtkweinkavhgxQMXk6z8rI2dsTG3hb5L9G0HMFffOQH
	uYD7CV0nftiCmodTN0ym70X7zqbKiBk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771548752; a=rsa-sha256;
	cv=pass;
	b=LCezAf4iasEKMbwsrhUBvujlE0YWMZEq1qk9ZOjs3NGLq072yokf2B2YG18zvtwDORAIvc
	qIZH8tPLVKg4upqoKpw6lExpRhpBGPBR8tPwPWUbGgK1DopRO5XgJpLVez8TluL1mz4Zmy
	AstquAtkQL+nc0CS2APjTrNnp5zOnWs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b7rBYNLw;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kkSraFQpV8/dpk6xnNGx2Cg9KkhJIfaGWJzIc+VngJ9cZRWHcfFMr+0+7SB4tpgPeWc2JrTqiTddfYuhjMKBJNGacUPCcwDEf8v/G9qAar4nWWIJq5ZmHXoYihescVpdhq0MPHahuDdsQofFA7eNo2XYVdC9qEWWmidU9949fACx44YaXFNu13luk0ffbrGWTm2BFzmEmZfXv2+R2ewU3fBaFTNbXbqWKeNkjZeSqmA/CWoT7Exws60C7W8a1GiyYBSw3Mo1cuFx0D8x8aG/nLcoYQholxr2HplV9QEKiUwE01BMseYFHgn8OD1+T6wIqxFDUQtwald58xbgGax6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eq1/6VI3rqa373X13Mi1BH2INOvmwKrjiJJpMw/gYKk=;
 b=ebyKnKwsGg8gCsrERdenaq8Uoyo5EF3qNAtyTxvLVXR+oKMbvy8Hm7NtM5+pdrpvfn28WmxvXe2FxuXYe6fNZMuwqiGoRZH1R7ckNqVQqtBOISA8UUz5T3mWXljSVGd3RhNDawJwobTXkBUjo1KWzlIu3ANkxilEBejugoxW1G7PkCLYWDmC5KVWCWnuLozh/BUivS7JVspUFFJzID2WNepCxt0ECHwktAXUu0QyLZPVtMatw25BZNl3mV5B9HNESpztNAev8GqsNJk2+u5ipzxvPgA2Xd8r7wQFTgLbDskiXhz3s0AGvnS+7M/CFZWmy2QgPulQKx5utt88jKw9Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eq1/6VI3rqa373X13Mi1BH2INOvmwKrjiJJpMw/gYKk=;
 b=b7rBYNLw8DBFY9YsnZZP/B46NGCoNZ80mYJo+Lr1d/utJv9Gk8AvdfUJGo5nb7HYFGcEughflxSWPWsAn608PItmmRHVRpKhbKHxNRPBBmeiQLLU4DTutiUHKVJa/XYfALaQMhtveKULGoa4cId9lRJ5ayTcsP1HyIXRZNHMJga6gIzP4mW24lBqDfnxT8K6oPIECXmgqbuxCmp0qAuSfZnYnf7ij8PoocIjlzVSpJ3ROFIh/BM8NGd8LCGgaFTQKrvY2rjm3U2Ia7i4AWnii1fuzu0ZbrG4IO0FRlQ3Tnexi6euNlphgggChT5k0nns2JM90vqld48GCxXFnsxGgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7817.namprd12.prod.outlook.com (2603:10b6:510:279::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Fri, 20 Feb
 2026 00:52:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 00:52:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, joel@joelfernandes.org,
 kernel-team@android.com, android-mm@google.com,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 Wander Lairson Costa <wander@redhat.com>, Petr Mladek <pmladek@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/tracing: rss_stat: Ensure curr is false from kthread
 context
Date: Thu, 19 Feb 2026 19:52:21 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0B29A60C-51E4-4430-80F0-2119276E92AF@nvidia.com>
In-Reply-To: <20260219233708.1971199-1-kaleshsingh@google.com>
References: <20260219233708.1971199-1-kaleshsingh@google.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7817:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc16ed7-7813-4676-8709-08de701a5161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qTtdxywootpCpwRFJFUwpfyy2bGmhrgQjs7wGeiJEgCNMk6Y7kZuLklxQL4o?=
 =?us-ascii?Q?3RYc38cqgHOoBarfaik8nVbNXZkDPHBNg2fw6DUheacgjgF4OoqcuMI6NgMm?=
 =?us-ascii?Q?UMggoQrE+Qblv+sYVkbtjDKLmJaFabvGQNWRVK1rmtf1RJZPm+0x5tZAiLEp?=
 =?us-ascii?Q?U9MWYVB4AR9pFRLi2r4w0IGa+GVFm+LbfyRvlhh/gUcOjDJp0lEaFfjKILD7?=
 =?us-ascii?Q?Z9Hm7HP6P6VdhWDF3UGQK4xuVlwKOdZN90lOladu5VHooAVUcowUg98SvWeK?=
 =?us-ascii?Q?UMwSRsRWEW7BNfPWOSgd5gXWjeetE+g5A0+B87PPzlv2Pj+5MCz4hAXO3ksO?=
 =?us-ascii?Q?VQB+H3rxMw0lVJ3+MOBMHvxczFfQ05xurp5ZA8g/x4es4Sw59dMjP+Bhxshd?=
 =?us-ascii?Q?BcoCTkcJLwXW8Q612GHHF+Q9SnydjrCCXppT6/OGGbeiGL6VIUYpFeMvYaMD?=
 =?us-ascii?Q?yXkV1/4nyvyZD7S16pSqOM+ZUad0gxI1rVIVxpyC8eY0CscLhitLVMyjN7Z3?=
 =?us-ascii?Q?xeHebsNzzG6cokzOD6fS75BGUiP+FyIP61W3U51i3uFNLWATQhlWomQbbj1K?=
 =?us-ascii?Q?y92O6z8nxi8zWsz35pdTeVFWPishEHqzHrnY7XN1r2a9J/8/fcGilCi3WM05?=
 =?us-ascii?Q?5gidGNTNgGDxHZQ6/JMdMmEvbSTtlSbhFMby9eH4136EcrbF30ArxQxAMZD2?=
 =?us-ascii?Q?8wg38GBzrJAizIpC6pk7GqLoWQ3Tamfq4kf6w1SfovsfemlfLtUCWIeZYwOK?=
 =?us-ascii?Q?9BUFQoHOFOPcYRsLyHfW+B0FqU0HhT50CsETAtoMuDzIoBAV2mNCT3avN3mK?=
 =?us-ascii?Q?70h58FL8C8FbxBEmwNEO8avUD62hLVY6seW/uRoeFaIFrQxUUt11OV7pRjXo?=
 =?us-ascii?Q?Wef/Lvoh3u/Pt/Psk0tx3aXqadiG38DwUsJ8CROSmtMrxOiqGPuWUbyQHTzL?=
 =?us-ascii?Q?u/q9xLnO/pviwIS0m4WRKZIklbUolPl+mC8wGnOyb0vuglkMiAZOUaYWO7Jb?=
 =?us-ascii?Q?zmFtTOCfoiRcMvoSv+Xkpk+4LswkdVP5TMug1pt3iK77XhWgWzrVo4lIMm5m?=
 =?us-ascii?Q?9d6Vep0COqh+RiGj7zK72p+F+drPw8iVFPszmu1xhLEoacs6ulDNuZMVkaJF?=
 =?us-ascii?Q?VfkFjP+pwN0q6HsIqhHusC9xInEvwqdngU+nZkkmlhPgAyCT/gDTAnE6SDXZ?=
 =?us-ascii?Q?KCMOUvJKFb452OVEZHQy9Nhuw8FYoXf+cAENRAtkRcIcPeMwTM9E5folEdWh?=
 =?us-ascii?Q?MojupWzsfhY4TZJnxlq00BLeMBJ0+OIORy4QbwN472Hzzg4kxJbl0hRn8p0o?=
 =?us-ascii?Q?CVh7LhNJdwRUc3SenjdxvSQfeQLENfqbgL2amGw6kOHN7p7LMRWFoK5CQrGf?=
 =?us-ascii?Q?LFeExJ5HTZm+svKtf1FLaZ0k0casBuNNJ9w9x370CSead8+gWL3AzQ8d9HcW?=
 =?us-ascii?Q?WRmfoW1WFuiDQ/zTWqOICExY2DrSQe85Xg/B4k+nLLu1J++X0Ql7MRZc9OK5?=
 =?us-ascii?Q?Ky58x5Judw8RsyOv/EKIyhw1876wns8LgmIOFVTa5wENwtYf1OvPceOh/mdc?=
 =?us-ascii?Q?C3GWDweftwcAlgYoZcA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rPrNhCVTWSMkXzUIhwWdvvcIqIN8Pd2ELvrO8mZPHZa/lci4VZhjiebs53TZ?=
 =?us-ascii?Q?RahzG0IzQ5OuPCy0Ht3fg7n9vvl1Q/Sm7+fieRew8j7wsVtnVIqvn2iR6tBP?=
 =?us-ascii?Q?vCEUDzjbhd5Y05MwUnpMsZywlFxvKzpHvHLtmXw1Am5SCrTVaqUo/eibfb0R?=
 =?us-ascii?Q?OFG4AvT5c3kd1VwnAS0NHH3h/11sEFS38xTVYmklTkJo5chnoVrPSyG0aoN6?=
 =?us-ascii?Q?sHrbvtsUw5aRtyZBQgSazdxnrRNPJZQlOVFnNaPqJBreBsSLZmiVaDcH3ty3?=
 =?us-ascii?Q?LrgKferRjWxd8WmuGDz0wL9TDobGW1dLSgcYyZ9iWQ4vPjJHflOo1wIaG4VN?=
 =?us-ascii?Q?vmiCRNBTx7+vOSk7eMUZoyQRcor+Zle66Ahz+aTln+4iPsJHKnnnLQA6Sl4s?=
 =?us-ascii?Q?zyCeWOrykRpoj/r3Walu8GyC8RYe3FRVigomjH6CvnC+L0hvPEpf/e4oZEC+?=
 =?us-ascii?Q?S9245a/2Vk+EdmaUu8Qzk22Nk4ImMOtAHr4aX8x3zx9ZSeGTFd4A2jiz8omf?=
 =?us-ascii?Q?v9UAsSDZj/I4T5DkXvZcZJzSmyWcTbvFG7MJeJhZrb4qIEQa7pTCxulUNjEs?=
 =?us-ascii?Q?OPDvz8O/+BagkuLhq0u2dfOn7e8uG1DrkVmAGDgJwDHBRQ1KBpeileoSv7EN?=
 =?us-ascii?Q?6Z4QDxyrE8uQAtk0ZFiGl7ngCI3vbPHJocnBYU1A/SyYLIjg49g2ofP9EJdG?=
 =?us-ascii?Q?RfYep6bV00o4FkzfcHIX4jfc5NQUdKA0fmnrZhsOoqTXUtsxYnp6MTEoQT94?=
 =?us-ascii?Q?AzSe9QZ+6vDN9dTU6/aKzoWTzLfjSdV4MRYeHFSxMlv/L4cVRpWtKMQlEABm?=
 =?us-ascii?Q?7c+3K8EA9h0tWtWNLYiPeDjaIzjjmyPStp+BxeZlAzXWbR2InaKUYGsZ7219?=
 =?us-ascii?Q?uswmaoWFNLlr4sqq9aGp6FLUf5DTAltpzuZDdulewdqBjxE9XJT+KKFNLe26?=
 =?us-ascii?Q?Ul/94R5gzLHVTffXmoAB41r2BvwQWE3hPetsryw0kf/9hveiMsEFMlxRiBXf?=
 =?us-ascii?Q?HnZfCImZ+5DDnJc1mhxow/ZwKOXjFs7EH0f11Jm5G7mGvA16Et0q+exRh6me?=
 =?us-ascii?Q?gixpLo05T/FqLRi1g1mfnAtdAkhNImxgghVt7WUF/yxI/Bh2/IvCXXD05sCW?=
 =?us-ascii?Q?tsmNr78Qb/TqBiKkluRUgnrYz2wmdVLLaSV3rJa9r+77hsH1pTHhSQK38OPj?=
 =?us-ascii?Q?SoYdgj3oBz1LELvzHKnTmQiySukfOYcxjUy8b5dEqdEbNwBqJc3zw29bbiDy?=
 =?us-ascii?Q?J9HP5Nk+HlMKuccjhbg0/Csg3wwz2LZUPRwEPTRNATU/5CZalVqxSVjFy96o?=
 =?us-ascii?Q?/A1WfU0td4yQtZHL+Gca/MyRDyaJC4iHJNvQIAGHfIdmnJpt76Gu8Ck0gHhK?=
 =?us-ascii?Q?O9rcQvZrYI4nsPlrH2zZeMtehkrF4Psotw6qEEx0UUYGEOFziloOPJ/M2UIa?=
 =?us-ascii?Q?Ron4STCCPpRqZtFT/tiA4kpEjleL+gwdbITlRLx6arPt96BdUSa55B2qqjGL?=
 =?us-ascii?Q?WaIB6Lw4ycGaU2r4yCNWcvASLrrYUqoT8XiZCd5v0E2rQkaW5txDRAI8c8GQ?=
 =?us-ascii?Q?nNShqquOY3ipQ/bSedfS8YBug+xxCJCMLLlc8BQ4vJAvF79RY62UspZxzmil?=
 =?us-ascii?Q?NA2rlLjJ+kJoytyJWRfoAVQA27rvX2g2++pyAUanJQ/r+f9U740voIKTxPXR?=
 =?us-ascii?Q?m4aT6G1LBwxaPhKAhdaJ2x6pSUT643Sl4nlu8AjZ1vneaci4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc16ed7-7813-4676-8709-08de701a5161
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 00:52:27.1549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEQaL/PoqbEoRCLqhViWVOxC4xJ499OeKqhSztrCTmXw12b4Q2bXB7fLvLblHDte
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7817
X-Rspam-User: 
X-Stat-Signature: s5n4ieerqgxkx1fueywmry6199o747ai
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3F5898001C
X-HE-Tag: 1771548752-127124
X-HE-Meta: U2FsdGVkX1+wBORAGHsFlxSR/mAbyoV68GaWuUg81EmfnUrk0Npd6ePHq3TB827zZBMZ9d/MfiCHhUgymJBM2VOvJ1htRC+MpTPyl15c9C4Wv3DKeokXTU8J+9uH04Ey1NN7E2/Rh7SmQ+0cs3SmKkMDkqwHkqUJI9OOT4VyzjLvQ5bxOkAylJcET7bpb8z2SpJdC9ELUKG5K4DXNbmrO00+KrULG2HZdngGBM5xNdLfo4PF6DM/EAI0bRCcO0lltwuNqy2MPEr38E9FLtsqlemKK6sS3VLRkxkrSqveiigyLiKYO6ufJyDNzIjKMAoQUCficrf6rcWiT1BwS9vldWd/FH7LvGwOk0WzyenpR+8T8tY89ygabNHLEBrFj56ngX+5bJ6mwnB2gzgWuG4f4ZPqKiUraeYTKrbUkoB4U5h09z6LO2Eq0f2OMGZ93LY9ZmStdbKj4PpTcJDeblbJjY3AcpSpKt3fIxaB360hhiBMetaloje3bcW0+57rgpyOyE6VA9+sFf3uxCwbRlmRgdFsfQ3XBcAn0SjyIwGiKPIRR4u7jqKE7g7mHhVPVszDdTzjEgNY2Du1QIuoYcke5rBnFwFjF43Wp/8OytnjCeu7HPcnJMsX2OsRWa3KJ5+ocTYMuSNV0bnz6+xwambsIN4NojxU4M9t2nIF6FyAh0ZvsnbSqK0p7N1yrhbfQOlJhCRG0poRMZOG+p8bFIrZ1FNBfLVG9yxt0VJyhZ+JMstUNtESPBHALvOOUC+OhtHT52MHdzJSjun5nbx5yNCKmbaFZdZs1E5nq5Od/x+MO/9GcwU/j07x4eyNWH26KIF/UklbZdr5omWqr5EA8Z8m7s2YwPD6r/0XE4RrvRNtBFcojpAihEFrPC1QSoMrKXY/GTOMWg1VPKW4YouLaUUhQzcgrjYeGjU8fB0ltFy/kstpIvgsugWfl+JfbGrQA9JeNwtHSjGW/4QEL0v26ur
 W0CjKFs3
 78BX4A+sYsL49PbHyRps9aITiGJTj/WZiihTl16GROyK9EGjlPff2UenpGIwMq8pqMmE8K/QqYY9tvNdYq7zNTPs3x48ciXj4I6MgabHOzwKqq0RVpGtBRXP6q7yAuXcxUM50a+10ony9M5d1GGMas1kgE9+97QcexPQGFeeCa9szec4U+gKn9Lgl+xU2H6hdImZDt9uv/NEyVqMXB6gtdAXh2QBhPAZzO1wFdI8gojoEW/svrRYQFphOmCPyK43zzNdMoVrGe2trOgtrUT4QqvNNKi3tlNR0n4D61QibqemilZ8Xnt9Pxw2Mj0JLwPR1eOt56dkz3NL1MfO8xUqqTHzjQ2zWZkRIgPBs4ZSOFRcS6oCDpgFzkBfM621MzzZEBaYOgbjm8S4sXPxOWhYYKZgyDJYicq66sChqEFtNzv4vJnR/9vd2BxwEKOQUVz/rwJJ2Fs2YjyxqyewPrJCSxarHmHff4l08Js87iU9BxGWg0LptrkP3gUpm5UyGMGNDLF1lMDBtFkVCJ+6zE4WabP9lEI1aRJUfrmjF5UCqX9XufXAZF3WPRL4MNXRjV606Wc0XBJknxjDXsj7VTfMbpkTokxGpCfImTcHB43pVIwmA7W7ORFNP/47fyFWvN2J8S9CY7FeAe1+hcqX6cKu9G1Iwe6FNMTCjkNkQorYfiWxNK+Q1mczeQATbnfHTybDxLOt6TbfrYMlycoM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 18:36, Kalesh Singh wrote:

> The rss_stat trace event allows userspace tools, like Perfetto [1],
> to inspect per-process RSS metric changes over time.
>
> The curr field was introduced to rss_stat in commit e4dcad204d3a
> ("rss_stat: add support to detect RSS updates of external mm").
> It's intent is to  indicate whether the RSS update is for the
> mm_struct of the current execution context; and is set to false
> when operating on a remote mm_struct (e.g., via kswapd or a
> direct reclaimer).
>
> However, an issue arises when a kernel thread temporarily adopts
> a user process's mm_struct. Kernel threads do not have their own
> mm_struct and normally have current->mm set to NULL. To operate
> on user memory, they can "borrow" a memory context using
> kthread_use_mm(), which sets current->mm to the user process's mm.
>
> This can be observed, for example, in the USB Function Filesystem
> (FFS) driver. The ffs_user_copy_worker() handles AIO completions
> and uses kthread_use_mm() to copy data to a user-space buffer.
> If a page fault occurs during this copy, the fault handler executes
> in the kthread's context.
>
> At this point, current is the kthread, but current->mm points to the
> user process's mm. Since the rss_stat event (from the page fault)
> is for that same mm, the condition current->mm == mm becomes true,
> causing curr to be incorrectly set to true when the trace event is
> emitted.
>
> This is misleading because it suggests the mm belongs to the kthread,
> confusing userspace tools that track per-process RSS changes and
> corrupting their mm_id-to-process association.
>
> Fix this by ensuring curr is always false when the trace event is
> emitted from a kthread context by checking for the PF_KTHREAD flag.
>
> [1] https://perfetto.dev/
>
> Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "David Hildenbrand (Arm)" <david@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  include/trace/events/kmem.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

