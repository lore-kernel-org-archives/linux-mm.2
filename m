Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717F0CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01BD8E000F; Fri,  3 Oct 2025 12:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8FD8E0005; Fri,  3 Oct 2025 12:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC7EF8E000F; Fri,  3 Oct 2025 12:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9A6A8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:58:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 479CFC0879
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:58:28 +0000 (UTC)
X-FDA: 83957411496.25.1F79969
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by imf06.hostedemail.com (Postfix) with ESMTP id 594AC180007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:58:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nq0Oy7pZ;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759510705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNwT9+pNKTfWDYpCwtg0RValqH9poJ8843BSPz0QMUc=;
	b=1YTvmf4x/ZpiKNVC447EMSWl20w9Se0y8JLDvuJjoVyDKbfcAI7ETHIiv8QxGrEFnBl2Ye
	dvuElXBBiAEdtRl2/sfBQpTko1og/sxPS555kn5yjrU/UeszpXNUVa+GNCdR6DZMCY6hju
	sYYEVwaoX8FKKmXpQHbxI+dOtMs4gSU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759510705; a=rsa-sha256;
	cv=pass;
	b=c/JrvWOsiXq+DJpmfuZ5AxTqioWKw66wFKEbbzYshQK8lWIY0ENSlE5nHVzHvtO7zsXG2v
	SnAcMEm41WhGyazv2tD0O7y1svBQ8uWiBAvd6ksJcGDbA7ttJxKy8lBuXQ4UO0sgZVA7wS
	Fqee3QwmckGS1HEvjfQ5QJHrH4WrRjg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nq0Oy7pZ;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eA+AtthfcHNQd8XUmUPoe9R1hLAzdy+1t1M0D13yCOQj3oBusSObfj4luXxcT9aLkN9VhMvh/t0941F6Hbbnr10AWGY6/uiVe1MaxbwtdJXS9WQjw3VwzfxwFb+VMwgjX7F/+h1ewit5mf28LAqv5wbODUm6my3c8iaABAFuvenEPztEgSbVIqoFGCMtAD5NrfqKxFBQP0MDzyNC7qe83PKPBbiAqlFYTkWV02gmiXIjSIhpPO0r6XR4wBpwSuWRuQjFG0VMTVmMKKPF2XL+WZPnm7Pt0FQ1St7wOBmXRULB01yPn/hgQxwJ6s2EVBWPGgNzUktJZfuP/14e8d/0LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNwT9+pNKTfWDYpCwtg0RValqH9poJ8843BSPz0QMUc=;
 b=o7lKHAP92jAthQtq15+pxsw2lrVFzopRrRuk98ZXSlC+JK7+OJd4juRsque2URxnMDJQsq95oVEU0bxtPevHRDgl2eEk6ouLyF2EHtkWu313eexTdnlgYDKhbyYbxvEyXV9wGuiPjBb3h76eomTA0kmq+eRgr4IRDZxngr3KfX7k8xeUsW+Vm6rIz3dpukuGqoNLTOEZ29ciX3SiP1U1IED9fVZHNP4AypEX57l1PLBPJEY0cDbrq6lZrim+z25plLPlyOhmNYjayH3QMR5zccT0OiLZGOxH6h9ZfTT6Sbmo1cNdkGFEMCqD68jLCl/2AAsSa19QyIP/LL/RUJTXkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNwT9+pNKTfWDYpCwtg0RValqH9poJ8843BSPz0QMUc=;
 b=nq0Oy7pZmw71oO2LIUCAlRXmFhlT4wrBJophRmiZ2n9OVKfnLns3uR72d98ipDgSclYvlwNb8i837vEiGPzaqvkUC3iDraE5TKR2NRa1nzmAd/bwE4ScYPEL5U4e3FPE+wW48KS/YFv3ezfE0DXKsVTXM1JyP8ziALxEFB3tRsHzdQNjaCV/PMWHYEaI0ipe1BQeVVC1him/mFE4+Xlong3i7W1dVmUOR+eqeoZ5t7cAVUhPmjR8+gLSRji1fuJtOBeJiuO1YtLsyQjqiObXi8BqQ3KhNO7jn1LzEiPjpEWAONIkAku6TTYsrxeXpYwQXMAi0FsrIV5PJm6Q/0y20g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8965.namprd12.prod.outlook.com (2603:10b6:806:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 16:58:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 16:58:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg
 offline
Date: Fri, 03 Oct 2025 12:58:13 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <F5C96305-4C4C-4718-8E7E-D2549B60B172@nvidia.com>
In-Reply-To: <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:408:f6::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: f9750949-1642-4fc6-f07b-08de029e0ca4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nOqWwlj23+HaYf8DppIRWv8avxmpx07tbKKWvh97aBG3LDSLO7Sypq0NXQpQ?=
 =?us-ascii?Q?XD5A1iL2FRwH44Sohh5LE1EYYAHgIG9mYQmXdva4230rNxLIr4+zLwW0pR26?=
 =?us-ascii?Q?0INdOO38H4ruicHe1GuRLy39gnSO9nU2X1GezY2p89M18rp/HfxVzVGYMzRi?=
 =?us-ascii?Q?fGy9lcWNcZXj2xy+UXa9T5G3vm3ZIqcH0En7RY7qFhwdm/x0pwNVhXQq42V9?=
 =?us-ascii?Q?X5JkuyLDyxlex2HTvXLp1t+BHX9v6tV/ylc2ZTYoHiT883UjYMjwkyb6Eo7B?=
 =?us-ascii?Q?6hlhMXlcSHXbYdCYzHfxNytsOjS12bvxMt83sHxFZwRvJaALxIptncMxqVIB?=
 =?us-ascii?Q?CO2WRGsu+n8nA9t9r2H7Fu8OkSS3QgOrAHD6GqdPAtO7p+LRS5jal8t3uGsP?=
 =?us-ascii?Q?xiFjXjDYMT/wYjCnRcd1noz6KMHzmLHcsjZafgfrrTQq2b/R4d0mAYOmuVci?=
 =?us-ascii?Q?4NLdR8p54qtvm+lF97vtaQR6QpJKSy49I4kdcx8RHt5PyGQmkJtrQy4a7dkT?=
 =?us-ascii?Q?iwRvRaaIIRt9NnDi/Ki/s/NbDVieW1xMDPxIibXOAdyeThb1wXSXUIrRnBdo?=
 =?us-ascii?Q?Idw7SFWEI5n4Ng0lVFM8c/doVBIs3RdXqywzYXKudvLoS4aQC2orSxsXjW9R?=
 =?us-ascii?Q?O5FuuqLcPudomnkp76PmSGFrjqNuhYkdSgjatHMsNF7JchSSG0YtjOalgndz?=
 =?us-ascii?Q?5GfJUx5udYV5//LV1v0bETu+N9zRHzdM9MYK1/25iOzar6WWHIBtTlbkIL7R?=
 =?us-ascii?Q?XiQENRxW5sfd++mo9qmKq2Q3qJYk2820k2cokY3ouyz4cJuxROsC2ejEdDEa?=
 =?us-ascii?Q?p3EoyR8Oba3zArUcHdlIMAtYCVxGVaThKjou5W8HSDwJu+cQmxBlBroWj0fK?=
 =?us-ascii?Q?YL8+pjlPJmfvX9MeERsGQr5OpJfTxm+xo6eKKFCUjnEe6npB5qSinvByjk7o?=
 =?us-ascii?Q?jAyJU92pPxkuTTuJKi0cNhZpZnUAsipuafoMRypSweWbtvAQ65CSEogeVh3G?=
 =?us-ascii?Q?jKBeuaPjyoiLQ7QQftgBquKUOK9TsEBU+JUu9Fz/kplnHcoO+i8hGy6necDT?=
 =?us-ascii?Q?JtuThgDsx2hdHYNHT0VpXk15xNSVOOf63YL2TNI1mvR2I8UtC4vuoEHEXQnK?=
 =?us-ascii?Q?1VF2VR71yFqfZur3Pq7E0bWqjY7VfuQWaJKv3ixgF3U34amtD2ejed+d3cqa?=
 =?us-ascii?Q?KtYWoc3s2powxRiABkAHMZusqdVT6QG3F2Titfe6CaQNE02y6qD12FICV385?=
 =?us-ascii?Q?/SL0B2kVD1dpV5jb0p5na7orsHNdCiIx7YBA4N7J9Ih46DVaRXXgCIAC8j4C?=
 =?us-ascii?Q?1ltmD2pe3eMy6iT/J2AGfQfaTK7rz/GSPp5GXzxXko5GwwUhWyWKcXGRzfSk?=
 =?us-ascii?Q?L5R9+JXN7YKbHuC9CD/9bub7FfscTBDjM9hIB0633kHHN3ooRKnzZGaIbYI+?=
 =?us-ascii?Q?67gfmrebI6m5hRlDZKewEXhcs3rWkFhF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0G6r3+j9prG3LHtFHGEZo5XUefy8WbwUFZBu7c594xB63ysxoRJUNmSZtR1G?=
 =?us-ascii?Q?4JCvGxdw6rLomzpk5Pzrt7LGLoZXXXilY2SJcevdw82pQNStoVSlpwb7sO1F?=
 =?us-ascii?Q?YtCiPrroibuYRpzMk2oWX4GqI9zT0wchZ7UcqthhgR6f5CmYWVUKUI8Ug2jS?=
 =?us-ascii?Q?aWpz5UgrzdnDJg7kQ86bWQZA4R4JL/J6J8Gq9bvbGBK40K3aH82Gw7e5HKOj?=
 =?us-ascii?Q?FeeNrn4ykAXbaJwIIsqKd3oiHWXS0LEDRQlYFGN+l8gWQ9rBTyjDDTCAu+d2?=
 =?us-ascii?Q?G4SpIPOOZkvfCvbzoyOBAeEEGkgZiF1zYF76Uj3rIzNtd1dVWoSb7uK8kOrl?=
 =?us-ascii?Q?HI1AtqZJRpCiFJy9S5JqmqAZt2a/siekI2FK4tl0pWRXflis8pR/I0XSCTki?=
 =?us-ascii?Q?3wHJROV9km0b1yVP7b8evRzOV5ntVsqna4MN38gZj07PNP4/0geAXYNnLLXy?=
 =?us-ascii?Q?Y7NTcuiRqNIZXUwtzaJoKmbYYaH+pDdAxbWWoUD+X5k38+fJyZb/qOojP8Ei?=
 =?us-ascii?Q?fi0KgF0d3dZdVNiYGr+UXC5+aEAA0hli2axsTu7uIyi5NkQUxVCv7QrLhyP6?=
 =?us-ascii?Q?agO/zELn0k5anPtFlZCBO8gShQ1K73BL0YbOMec1pF05J5v267Mx/Ytpduhr?=
 =?us-ascii?Q?pVkiMbS27vYGYJaqN3YDLDsl/Emez3AJqgAK9ooLaENCRObbyzuQQhh1Q0qE?=
 =?us-ascii?Q?A/wtmaN4VIZseeYthi2ziw6dpTLd1oBLRrucaX3KvwtzTSWF1E7v91cFIyVl?=
 =?us-ascii?Q?g+BVoag4ABlOY8Nks+BdO8aIqe/0u7j+cVo7uyRKPo8VfzHrcb1ALJeg5FCW?=
 =?us-ascii?Q?B7sTu1Kj1HQG/q2eg8M5SK5RYi4pCS0kOSzys80l7LJ4OGv8AOZ6S6jHKXOC?=
 =?us-ascii?Q?yum7UgX1p3Owq8crmf5EB5+Z6x7RCqHEKoLUMMe4rUDnAuWUBbd48X2EbP7c?=
 =?us-ascii?Q?Ra8OR20B+rst2EXmlLsA7QfnBWSvu7kgQ1Qi4po+XDfM6tekuXPty3CN/suO?=
 =?us-ascii?Q?i5daNPsreBUiyuUpHxGd8WDqStgxBy90DDY//3YIovFy+J2OWmw0L6k9g/vF?=
 =?us-ascii?Q?E36Udj982l+YLPSH7EiXb7fqd836EhNkrRh6tOQVb/8ENaJ0TRZT6hNrkrl4?=
 =?us-ascii?Q?JDr/4+QeKvJeGk8+Ta44cGU7YiAmyArMCjzmIZSuohK+cAvPO+jMkMz3mFK3?=
 =?us-ascii?Q?Vsw6HQAvARk6s6fZCqcz3Ob44BJsPAEyRtPeGPYty/v1tsa2Us1/svqu9ArF?=
 =?us-ascii?Q?VhqnC3Zh0z7u+l1EFmrnNNwrPLtlzcs8WizoACvBEUeLSHgUvrB7FnBVCoJw?=
 =?us-ascii?Q?28gNa19AKg0wpm05hS/YtsytLMwDRfs7gl/yLR+Ogkvk+lQYfaNNztk6I98w?=
 =?us-ascii?Q?kEUeRWIZHvNS6gQNKX5ZYg9V/9M6HYkI8rrr0x1DOMqjT8mENHxIHwBkXVhi?=
 =?us-ascii?Q?Sg24wQhlzPrWghri02XT5N4LkAL3uGe1zvVvjPoSGX3aJUiivEztZ79Ca01s?=
 =?us-ascii?Q?HdpbkwsHUR3eVgD/frdop/YM1c4F0nlonSjpoeB+4Jb2BggvERc3yNpSvuX7?=
 =?us-ascii?Q?dxJWgnKb1xsy1vfaHDoeaXgeQA1mom3RtsZYsuIE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9750949-1642-4fc6-f07b-08de029e0ca4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 16:58:17.5099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/pPwH4ZCPE4m+tEHh/CeXyN9qW0HPfXYwyYr2xSMhcZMyzm9PIqRoS/XkqoKW58
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8965
X-Rspamd-Queue-Id: 594AC180007
X-Stat-Signature: j7syt4qt37djy6ibai3ws3caarh7ocir
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759510705-801187
X-HE-Meta: U2FsdGVkX1/x/9HD4hSmxe96Olg+e/Kr9/tVNB38fu1WlvoDfTT2lFLvpoeL5LcIMJdHBVwXKf8SlQc9RSy5RetOlWcjn9OvmodSaOPZcjtyePgIrhO95MYticqFAkyQJgrZ/boU5wd5vB13DnwwGHSvnkp+vIYa7P5hm/VAFP1FXnYhWRhYuiFtZZH1dl3dpt4Wp6fYq+q5WDO/yWCOUUD6cq2IR3POPlIaOrl9dlQd0LLaYeS7YE4ku19eceoZ2ovpQjTo+oG3sIvlI4Ggdj25Omo9erAO16ZXt5t0m2yuuGief10EPrG1a/a3miLrAKB/0sJ9Dcta6q32cHhs/aC74T/864D15JnmqnYb9dErdfYH8g2CT42GO0bkDysOZBDf3Dq6Db//eHrOZQbUuKPUqXuzUfI3YnjFPhWssgnUMZabKcDGP7UvhA6xOziCNt+nb+JF5B5d/ZZGizgS8Y5Cqc8Xs+y6p/4d0DiDmtTfOrof8A27kUc7P7d2uOCJCU3e7bnvOTyo9s1e6t6QNR8vh5afprswcnDCLd9C/eYpd53rS7g3U6ew5yq9MycMGdExPXNUuUH/H2Cw1QxQ6tRbrrC9WreEkyQ/W8bTzvx6bRmvy/KLrxwkyNU627KSSt4PSRSXcZlusqc2hAgsMzq1jt3UW7fnIxRKDNMK57sKtTCAvlctnwgCk1YtZSwW0EHQ1Kw5LphyHJhWy1PUqstHGq+3tLyEVEHqFqYnpoy/RcIu6VZh01wP3pcLItfyvQ8/AgYj0KWxgebd4IBSDKstxQ+nsog4q+7TQFjkRohtd3dUBE2FAl2RAfWex7bBLFW3+PhGFjAMA07tvDrgdjJ2RtE9kkssQKi+sO55J2RiPHIrZ/WOxyZARH7Vj6vfEfG+Z/EPTq0QPd4BJjxD288rDCYhi0KC6kk+/2RiiY2TtQDBi+N3QOy+TtsmOg8vlOJDmR1FyzfF7CrAmue
 3zyTISXT
 iknjLgXVESbxLt/UaK8HtUWrbD8Cu9F5Kjl9i3w7sLG01GlcmojmnmLqeCwQvNlPXU2chiEDSmEvG66DZjjSrSZtCzl3D+xrADOeK1MKdn09cyQ2aas9l7CKrrgCpZh+vlbfbGiEQ5LO9xBjn2VBpD74BJtV/gufPIJHGJxiOY8cvUf73UTP4AEeVIuMkMqRZQswYcybapfOxcv1FhA9SxkF29ZmtvjBb6EackjSaFILWSKFH756V8Vs9ED+AYdv9BjiXOb58fhoba6GhGlYFDwVtaK5wItK8oyv15UOx84NgwxUXcbqmMWxfstvUUyqtTmgx3SqgOfwVYqA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Oct 2025, at 12:53, Qi Zheng wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Similar to list_lru, the split queue is relatively independent and does
> not need to be reparented along with objcg and LRU folios (holding
> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
> to reparent the split queue separately when memcg is offine.
>
> This is also a preparation for reparenting LRU folios.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/huge_mm.h |  4 +++
>  mm/huge_memory.c        | 54 +++++++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c         |  1 +
>  3 files changed, 59 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

