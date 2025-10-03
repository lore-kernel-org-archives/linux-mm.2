Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB22CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14B68E0006; Fri,  3 Oct 2025 13:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB1F8E0005; Fri,  3 Oct 2025 13:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D96F8E0006; Fri,  3 Oct 2025 13:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 799B48E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:11:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2654C1A08B2
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:11:40 +0000 (UTC)
X-FDA: 83957444760.03.3E9931A
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 508511C000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:11:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WyyZXfJd;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759511497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tue4ij3EAp2YCYtpZAYu+5OW/yZr0Qw4Oq62VQVnLzk=;
	b=vlaPcdMnDooHFxgUceMO+RikqciCVUTSlI/Ss85G7/Huhg8DvtiLMlYkDfLq90+cjfX3Lx
	s+z7gOCK71uF3mU21N5grJ523bNfXFbweowZ5h03oi+mj2KbvKTNy3b3weisnIHbUBsoDl
	mfpl0b0kMBb+BsETKiIAK46NMvnLEpo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759511497; a=rsa-sha256;
	cv=pass;
	b=k0NX/UYV1sXWAiUfHVTgoPmc6aCJtOx8Vhu5pxFvPAXsyLQhHgYwVhV1EpfVg184RaBoT8
	KSHcVaoViJFK4wJR1mdb2Ga2RUmUUhIJTUBfkfkKM1pCz48QGawVdTDof9YnoL+o6c9uba
	DXd8n4mtmIyH/ME1G29cmHIgzPB/jds=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WyyZXfJd;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RNKptRTBw07ZKDZ3slqyDLvuGZQ4p6ydr0j2XDKO5VLPtBwd62sE1meMwyDJbEKgPl73/RIZWfd1+LYT8mDgvZRDiOhAAfBShCW/RQvb/eQnN9cvLi8i/rAAnNF/aiz5RaF/bxXyE0p7O1FswbNSKGgmt53YRkza4yir+kUE20lBgErEo3jsayOYpO7bd11Xhcme8UxRZrPpUkBicFttYgqSE34Y+LLB9GBcj6+XQdMgiQ59RlitF38K6LdqRrtkkJFukVKsmGYmCZ9SGEhbRnfZm0y2VlG7O/kYLZU8e9GR7zX7nKT93IM871p/x83HoOpaMdLhW90OjL636jMA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tue4ij3EAp2YCYtpZAYu+5OW/yZr0Qw4Oq62VQVnLzk=;
 b=apGuTJZgKRfgmHct8MXSQ8rm+M8KDX2xH0Vvj18kmcoBbtvRTFrUKoEgk2RfIWULuk+zymazfi1dO8l7/93dD2QrPWEw1s+EI1c6BwDdub0M9jC6ZB3//dwIyBoiP1u/7CfAOkILGP+9RzG2b4BLrEGm55QCRW340EF0mwsWeElfR/Wf03LEf5vn3kCp02H2SfZnxwxhnHc3c2QxuQarxxxAk3xW8JoAWmXD8EGCmWIwTFp61garQEzJGyH1J0KdAqqDcWXWHmbVUV6MaLldwuftFI4d13qBDVto6viJsdt0cIE47iN18CZTCurOR4csZ1RqsI94JThWNjycMBfvwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tue4ij3EAp2YCYtpZAYu+5OW/yZr0Qw4Oq62VQVnLzk=;
 b=WyyZXfJda0fjeEidKvER821G5VV9fkzcri9sXxYfJJXgTU5BRWiwUuRL+apwwC9s1T0Vr4l+vF3C1ib9BCAD9R9cu313vRf6DTDaU9xoyBZaFK4NHZiItqapsHJh/89D7MA+a41FJDxNfBjlj3wGzsjh0tMDNWvbFJek5mK/14iIAlo5pbTaAbNnMgIpczutBxeknwcRXwDxi3Sh5TNnjgD3ixZo0kVUXfyn0VVgSNJKmRkC3FH1yeOwHatCWDpdzFmnulFMPE+cSkm/EYROglFs9tEkd7zD86/3u7f6vwYjVqrONEbHAyAR8veVHAz66JsuJp9IhN39aG3PEjm7Pw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8517.namprd12.prod.outlook.com (2603:10b6:208:449::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Fri, 3 Oct 2025 17:11:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 17:11:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Date: Fri, 03 Oct 2025 13:11:23 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <9DF437D8-E98B-4061-A8C7-521D89070C97@nvidia.com>
In-Reply-To: <20251002073255.14867-3-lance.yang@linux.dev>
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8517:EE_
X-MS-Office365-Filtering-Correlation-Id: 921d2add-c70d-4099-6137-08de029fe2ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hhWhjObno7Vj84jfIlOePkt8YkC5NdjlR1d49VSGWJ9t96l+dLGHf9JTL6bY?=
 =?us-ascii?Q?P/EuCPQPEzTeaM0MMFEdivIjCfllCsuKBA6UBJj/vHBVjO8pLC6WO/RyC6Qo?=
 =?us-ascii?Q?Esc8buSrQjFM5IxM4t6R0uUlyvijPC15dBQmExxPL54Jj68IvG/oSr9ygoml?=
 =?us-ascii?Q?Xk6SeSD3nSP0EJTJM35KF7haFqY2I9g78394/jERtI3I2w6LJ9VEIFoYLY4m?=
 =?us-ascii?Q?b7qsNEphhvfR/dbX/lCHy/+Q0/g90hzKCi2U3h3HvfItWp/5dTe4U2gnr/Hy?=
 =?us-ascii?Q?4x24gGAPlv9H2rCXB+6HPn7+wpYlEx2HpfJW8KhGy6o9lpdAxmc5iKDreeb/?=
 =?us-ascii?Q?6mA1bVfLVYUyICc5yLtvm6/emSIj74DybY63G4r7RE9n+fzbwwoPY2b+9iZS?=
 =?us-ascii?Q?xcOqbQsqTGhD7kojlDPHXW7M6Q1KiEg/hH5821/LvjJ4+kIt2ksqD7Gqt4XE?=
 =?us-ascii?Q?NcSJuNJoMOGDBBDedMDnNwZS3OaFWm2+VLrsdKlwM/y2UKlavjDwlV5hSQ6d?=
 =?us-ascii?Q?U0kHcPx9lTJQiK+EDYYpzly633QHrmTiqnYxBMR/S7k7uuq2bzaF2iVJUOdy?=
 =?us-ascii?Q?BKj5r6tnouyKUabgOOfB9/1A8K0LuuUl4by/2ScriV7UBK1hMdqLZ9B/+iO4?=
 =?us-ascii?Q?iQPT85kq+6r+l5p83J6ZXroev8cK+B4oA5oHjxosNNSClitXsP/j3zVaPVsP?=
 =?us-ascii?Q?RIKFe+ORhWaIPsdu9Yy9t+Fq3BaptxtC2IQsqkCyzu8Qfj63B3tGhV3N5jPb?=
 =?us-ascii?Q?0+a8L0LDJSexdjsZpq7djhsADKim8o8acox4s6leqtqNHYkk2Tyf7LHBRq+L?=
 =?us-ascii?Q?rLh8OufexWiAwqMssmFMx5vCl4TZ1QkwbG9QdvLpM1OvAXyxPHeumpKQJgM3?=
 =?us-ascii?Q?ePKWNk6FOkm+dj1L8C9JWyOnB2EH40E5CAYPSXQn5YgirCcc3cDIgdXU3bw6?=
 =?us-ascii?Q?a8qilUT+2wHNqoax5UMJkaeethmgY/Ee0m1sK3D4gFOfQFo33NUsz7t+SHr6?=
 =?us-ascii?Q?IbHRkgdFczwxfI6bcSvEjnwEHsyu5w1+xxWmsJ1DhelpmdsJO+RmOYhMLxDc?=
 =?us-ascii?Q?hmEkIGk2LrIU0H08G7I+BCeluItycJR5C21T61W99PRiCnXZwv1g2OlG/lzd?=
 =?us-ascii?Q?UcIbvXHJlQ08mR3aeWBGAG6IyB+SVb36OyEq4Nx/FP5lT45/xwixeidv7t6C?=
 =?us-ascii?Q?fjx+NHOycm/u/gYRoE1adWdHlvZhEk92bbzIUtnSnutlexDkR052L/Ka/Nzd?=
 =?us-ascii?Q?R2YA9qpCtJ4UPK7eeLNEarIWEIYSkmyU6JVP4Wxgm2z8JB2/VL/o28RXousN?=
 =?us-ascii?Q?cE0SYTbk37W7tQy/yFHGlYyhzObwS1vJhqXpo/XF8xZsofSWzUdDqVhWp+4o?=
 =?us-ascii?Q?I4DEqWCCc12anpTZFEs16umO6Ss41x4yiyo/fkQN5I7rOQ5xKnKMPW4ZZYal?=
 =?us-ascii?Q?kh+pPjhj+UBQLw5ePhJJ+t0byRZXNfaT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A8rNgRz7sisXQSQvBzSvJ4/VlIqZJgO9lq58eajkLAYj2+aqvP1A01mJ5P64?=
 =?us-ascii?Q?YlUH2PLOsPiKZjWzNoBxo5S+OCdbDRAHYh8sgD0w8uuYmU7lj/MEFv48WTRf?=
 =?us-ascii?Q?sDtFKTK3nMJ6Aseics9i6GvK0KUeXKm2Pm0yEqowlERz+7ojuvYW5p1ITzUU?=
 =?us-ascii?Q?3YYQFrdX7wdC/0a3s2uNggd+MydlSNLPJBtQ9899p9FaFEELXr/W0fyZ0m7e?=
 =?us-ascii?Q?ng6HmNSxFgTK49qd82ktVLnDv/wCWMS56EcXNGLLDUTzb8BT03Ub2ZwU0GdF?=
 =?us-ascii?Q?r9RlEUr0bcG5+kn0MDypol1w5qL7E5JcZAF0+/V8m0+bT2TOo7u9V1vH/2Xj?=
 =?us-ascii?Q?OgcN068f9MjmWO3W2UIwU5mUCcaT4WP8Fc6a4J5zDTwscqkuGqAVvwRtj1aE?=
 =?us-ascii?Q?jcGrbHCrgLPU98RZ7N767glEqKWJcNI7xoHe4MPRdZlkNZUyjsCK8lBWZe/a?=
 =?us-ascii?Q?VEzyM2BZswh4TH67FJZaijoGjyGLYEzkJdDON564rY0QBBmjjaMA3HlVnnJ4?=
 =?us-ascii?Q?jpRxRgK7Z07QITP8GdYsVcSd2ZGqrsY0NuxsrpHrK5bHecbDxZI+g8HV9u4P?=
 =?us-ascii?Q?VYUikhF0DFvnAx/LVlNM7RbZKhu9PaEPMR//KI5Nplg+vsY4ZJ86CnZnVdOb?=
 =?us-ascii?Q?jE5+h7Fwq/MJkbC7LP01riPBJkggPqEHTtYbWfMGlLFnWBm2afgSfK78erPd?=
 =?us-ascii?Q?ypp/lfYAgywOgmYETuGy1J4REGeG7zGrWSIwtdfeZdML/9txmcM7CNZzrUup?=
 =?us-ascii?Q?MWp7an6zLTLoXao/uVYVzk+m8bykb0nR4qQRvnj1/9vpHmaIrmxT794nz6MV?=
 =?us-ascii?Q?vbZJzNjCUQF7+HMtJQhuaeC4AbXQtsItnuttw9pKl4gSfdKWiIWn+ybAO1bB?=
 =?us-ascii?Q?YJPG2CGcGoRlAYQ6v0RpEwG81mlYfmEZ0Vgpz37NwTQyZtx1TUyN/LOLQ3bM?=
 =?us-ascii?Q?AbNwI6N2H93vvjDlN/qtTRB1vtW1pz2+33fRwXaCe/gH4g1b3/zxtX57x6PC?=
 =?us-ascii?Q?QbFOBHuTivpi+d9J1JPJ55q5NF5iYmKFZ32tRYLczIQYMsg/AzgO11Yflo5J?=
 =?us-ascii?Q?GK/eLPeLSewSaTaBSRhz0Y3gJgX6bjK06T4qc2Zwbfh7RB21ydhwekI0pN+K?=
 =?us-ascii?Q?AZxT5Zw05uCjSymCi5dTU1lTwJ8b42fD69f5qun59saTFoadUH58RqzRSzrs?=
 =?us-ascii?Q?s4DPUkqUSPGTER2i1SOfSTgIkWGwcMm5b4s3lmIlF2DiQ64bOyF+kG99cs35?=
 =?us-ascii?Q?LlUoGYEVmUJUA5xp7jomcSpJR0UViMLG4QogPDLBI0Tyq2CoDHmnxKZnWa8g?=
 =?us-ascii?Q?21Npt18E4rhZGTmM8LBzFdDWnf+PFH53eAL7MiBVOjJwkPKiLqjmisHeQI7t?=
 =?us-ascii?Q?XIXntHJ1RS8ZM2zsMPeGSDJ4ZSTQYfenJh4JurKbXpZW/riDFA7Tr00l7PbL?=
 =?us-ascii?Q?R9xOpsuiHVZW4o1nj2EokOyCDZyvHWOx9Z0ZeuFKG3CUeaqGHFVqAzHUE3b7?=
 =?us-ascii?Q?XFBaLIYrPYbaI7LRPd6phJUn8fhkVWNAYangn+3In8Q7c3nYY3FNV11yoha4?=
 =?us-ascii?Q?oVdu8bKmDzC8numzzRj0td12XIGMuotbf3hhNb57?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921d2add-c70d-4099-6137-08de029fe2ca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 17:11:26.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz48iQ+a2hmzfuJluTkA0nWdyC5XEJrGSdyoNjqAFmjxzjVquDPPFRArX0P/bGAi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8517
X-Rspamd-Queue-Id: 508511C000C
X-Stat-Signature: nynbkdsjbawa6iwe8uu73py3yifke6y8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759511497-477547
X-HE-Meta: U2FsdGVkX1/5zZ7VVkRJhGOLetiBxdzHe/9ARm5/4usRSfqRCTkkbbutnq+H+l7q7ve5Yrz6SHNF+xXDz2DwZWWp8lTMzt9aracDDGKJKMyP+Fis193BMeqJ9nhCWOBBjOrzoGzrLH2HzYFxuLRdnjFN2D/E7PoA1PfB7KG1r6RzsJ3dG+duXwqJvnyBZUlNGLCWUWBYODhlKTnXXObhOm3Fw8CCgT9b8fejwdbr0ZjuWewWwvza72k1cs+C7tM7lEjTf35NPxjrMoDFm/3IppysdFBPRRWOJXEBNiRFWrBrDDyCzxEGij7fXORID0Et77ggVk/cMO2h3HHTQ7egEhXKWTHf4dXTQ1LMwXjcE1ywxC7XK7cZEp/K0Avnv+aVW6XDtsIAC2FKk3UQLKMLTeampklUrksCrSk1j7T1/6r35jqdy45ay5e1nxswmA+rKxfI/19CLZZ0sbLQR5Z+7zAldhLuu/UC/XlRBfro7+XKYEmzy0z8C5qorgbcUNzy9U6TWnaPWyQztUzS7O/cDm2KsYK1cLpAozZP2l2YdqNtF8U4rHBNT9BIOwmOJYtWilXe2/xwhYoZoU0PmtwaEqQgTgAJG4tucRk5X9ZR/k0tFiF2/6xwCC9aq2HtzaKQZSf3DV1nOdRXUdRti3MD7d69DbW3J0tU3YumzCCA+V/3P52BYa5L3PN2PgUI5ZUG8gtDxYhv/HIvn0iVAcQh2eXCaWe0Rd0Rh0DOvWFPFps67JuUeWAUufHFpmWvZ+WNB8eJFcQ1dr8Fc0L+l36Cg4o4leb4EzWiqr4A+dvgIRX9dprt+7og8LjKgv7Hg9itonfnGiHw4VDUnREM9jjBelMpatzZumBf7iPam2it50mcBGr0eSjOZc+9bH/re6j3xGoySZB0w67MgM2W8yG8FjcVTAsl8/v3tqMHN9Hwtqfi8OGSMD39xc7cB2AgdUCNjOn47FohhUMWU5QrksO
 2m6WkZah
 Z+Ay7jrvNzY7sLEn/QhdfYWZX2fVru4CiRHP69Dk3UfJmaaaay1QdoTCNbkF07tSX9RvrhWpYMrIHjbJyDq65X8LTktIF4eDAiBAOt+kwWyTd+hXle/enXpbttWw5rx82UmcGWuaUAZ8r24awJxEO9LmjEad5xLQbXIR6BkxusYxnPINRQWnjlJzrcv4b0YQE7klUL2f26aCBrpfmPnNrCTIKU3n4+DP+sN0gGx/RGDqnFaS5y5jIk1m0IPzkhJFJDMq/ZZ8j4dtMDtLGS3P1nxscTpnK0ChS+pTEF2WT0tsX5yvh2IdVHaLgCaI5Sf8GsE4tz7mGOd62SQrllxO87MmQ4EyNUvUnbdf8TjmYGOgFNNtJjpc9gv6L/kcM2zjcLkAfMXL7dMiKkL93ZKn1+mKInreuPVENYnaD3qc9hRtfbKDuWhG7RrA6g6WOTH9r7/dipgTpNJ+A/w4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Oct 2025, at 3:32, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
> and __collapse_huge_page_isolate() was almost duplicated.
>
> This patch cleans things up by moving all the common PTE checking logic
> into a new shared helper, thp_collapse_check_pte().
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 167 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 104 insertions(+), 63 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 808523f92c7b..2a897cfb1d03 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -61,6 +61,12 @@ enum scan_result {
>  	SCAN_PAGE_FILLED,
>  };
>
> +enum pte_check_result {
> +	PTE_CHECK_SUCCEED,
> +	PTE_CHECK_CONTINUE,
> +	PTE_CHECK_FAIL,
> +};
> +
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>
> @@ -533,6 +539,87 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>
> +/*
> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
> + * @pte:           PTE to check
> + * @vma:           VMA the PTE belongs to
> + * @cc:            Collapse control settings
> + * @scan_swap_pte: Allow scanning of swap PTEs if true
> + * @none_or_zero:  Counter for none/zero PTEs (must be non-NULL)
> + * @unmapped:      Counter for swap PTEs (must be non-NULL if scan_swap_pte
> + *                 is true)
> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
> + *                 PTE_CHECK_FAIL return. Must be non-NULL
> + *
> + * Returns:
> + *   PTE_CHECK_SUCCEED  - Valid PTE, proceed with collapse
> + *   PTE_CHECK_CONTINUE - Skip this none/zero PTE but continue scanning
> + *   PTE_CHECK_FAIL     - Abort collapse scan
> + */
> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
> +		struct collapse_control *cc, bool scan_swap_pte,
> +		int *none_or_zero, int *unmapped, int *scan_result)
> +{
> +	VM_BUG_ON(!none_or_zero || !scan_result);
> +	VM_BUG_ON(scan_swap_pte && !unmapped);

Please use VM_WARN_ONCE_ON and just return. Or put all stats in a struct,
pass and check the struct pointer instead.


Best Regards,
Yan, Zi

