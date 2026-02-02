Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BEA4E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 16:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24D06B0116; Mon,  2 Feb 2026 11:24:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC386B0117; Mon,  2 Feb 2026 11:24:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3C46B0118; Mon,  2 Feb 2026 11:24:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7510C6B0116
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:24:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FE2C1401A9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:24:36 +0000 (UTC)
X-FDA: 84400039752.01.A6ABC11
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44820180007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:24:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XIamM50s;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770049473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKL7zlpb9bszn5kH73iRRmSZ7IVSPRwdwjt+6MnV+eA=;
	b=FUznwFEC85vS0KwDkwDqH8EQvkzIVuqAq/sDfD6bf/QiDoZQdhWgyl3tFE8nOfvbYb0/c+
	KdFcA6tKZnfurWEakbu6e31YtbCDNwfc0aP+ti+EB1Qrc8h7Nh0ZK5wa9mpau9nG05b4t7
	CoxLVdDowsij2L2Avyg+yMrov+N0zaw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XIamM50s;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770049473; a=rsa-sha256;
	cv=pass;
	b=RF22kipcroY40qhBfM88k9ac770NqRk8R9RCCcllNMyaruWxMfDCHGHl7vXWN0scNUlk6E
	PTAfMQbAmalCrDYkyvmleFl0PSUfjdfG1z+EzW5J8XcMj8pfVEEJtPgYpPI1dYV5B9BLT9
	877mRMPfCvH13BwistX/L8AayIXsErY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmYBr0boC2mW5j1yNrq7fPtJ/9s+i1TNf+uLY3qX+oiUGE3zzJ3mysyz0Pkuj/D/FiTNZneiGEa2SMSgwz6O8bc7KlgjmM6VpyprVXQOLSHhxvp4J+z3SM3O4cVYR1ZwVv7s7E9Q/QRcukcHyGOxZGd7ufnbf8QO2OYlYTyru1BTuwVplBsBgcIZ4UZtJy8boqgR9Fx6zU9gGlj9M9O9SqE+i7Xo9WTkhF1Rp2dnscbb0IA6PWvqKgBoQ4y8Be1b+S29CKPJ+Memii+KU3xL57RkFItoCKedv6S5jnT9Wop2IsfW2lvIQARdr4TGV9Ljj6AvXwzrVy0CqzInRc1UtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKL7zlpb9bszn5kH73iRRmSZ7IVSPRwdwjt+6MnV+eA=;
 b=tcN5vF1Yaa7hjoCzk3kE6IVAGmfn0WwPA5bcfgonqtlL8zKFRfJdZquLyxESrEU/NxcngTn9edpMim8R4MZ7IY9OzkGJfuo1tKon/kxPxtVsBY5Nxv/cg4+NMmp+wWpgh0TEOAzrppgTwwO/EPQYweOwyJexk2au2alfAMa1QfQrZaKHuTdX3PrwCAfHpajUgQbpcpXBZC+8lon6XvxqcAeoJZQ3QIbxfn1JbpDuE9UUTEXeMLw6VkZvZ+WlDo4WDXIFK+6bduPb2IQRH4IesuUb+jjd4dsSeGg1rc0INtC2U1DQd9EePYQWWAPImC8pYyon32AaAEbrO+Px85LzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKL7zlpb9bszn5kH73iRRmSZ7IVSPRwdwjt+6MnV+eA=;
 b=XIamM50sCA/GnbaFmSsTJwS8Lf0aR5J9+umrY0PHjDyuxpyXMWMsIfsbTSDQtofqyxuGW3IHL0/hfZB4veRH7o6iLORBWbQ2Ul4T3OGasfewLMup1zbbk2rPd0haodQdePtGauIU6iZOeIn38TyJVLRUy/Ps+ppYYE4+5+3LH0EGfy782g37uaPmSybzQl7sFrts8qnVk58A+Dea1Hoapg7UZM48P1DvCeQvSP0C5YQZRYrWG2LPzUUNIRNAKB3sYI2hlhvWYjsytNHqEOiBX/5+r+WY02udsQab9fJJBz1rhRHtIvH+jpG6eTD8ScWN/2DAa+oVdJ9gDPIRwLEEOQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 16:24:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 16:24:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, lorenzo.stoakes@oracle.com,
 linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Date: Mon, 02 Feb 2026 11:24:19 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3561FD10-664D-42AA-8351-DE7D8D49D42E@nvidia.com>
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:a03:333::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: 33117bdf-bb54-415d-cbf8-08de62778756
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pt+yitBpVP+yLT2iFnmf8reWmK7EHDIRG6ShaBTmF/e1cB6LOnUuJOgpKkEQ?=
 =?us-ascii?Q?frObsFa7Vn7LrnN6vYurujzodTXplWfAYfu6kqDGtZuyMRAILmb8s+oZKz91?=
 =?us-ascii?Q?aCO676Yq93Tx7yHO9yEmrpnT7S2pyfthnSCrhjhOoW+rR9ajS2BJLXmAU5rE?=
 =?us-ascii?Q?hSk/T/88wShrUuGThXw+9yxCd3lRqli+NkTyMGt8a3qZz00ekr+t3IL5E+iv?=
 =?us-ascii?Q?a3Z/dum62z2c4wqOmP9Qnb8OtwqG/A7sR22yZ+S/Axyuj6cn9pYuI4VDLlwh?=
 =?us-ascii?Q?dNBB7bL2YYS4+Mf1Nm+yFH4ruhaHa1fC2Ex1yLQqiB0WR0q2DgtOaFRofVpE?=
 =?us-ascii?Q?wOJrJEgXcFbqfSAV43r26TCNKUc5I0Sf2GA3f+3x3ArtK+LrNrcEmJtJkLob?=
 =?us-ascii?Q?fz/cBXhxDhfm4Yr+B6lWIz2/t9WgnUF7c8Jag0QSFdt4FTLtgH5+mGm7UrV9?=
 =?us-ascii?Q?DE5x2Sk8Os4t+Q++0D54dv/LfKRmpymXpRo4QAHjpWVn20H7qVTF96N1LjGi?=
 =?us-ascii?Q?dHVKrrSHaLFhUaSnyDwAcn+q0eM4ROWXn3lKqPaivHQ1poJzCFcXcI2ertKC?=
 =?us-ascii?Q?QtFae+kEUIGP8jxue/x7TwvmXgieRwTJsHI8YA2/vpPZE8m0U0sKAC2/thEx?=
 =?us-ascii?Q?QVBRfTctSEeeBkh1v+TgIUs0EqcCeye9xOF/3oxcAObANxEXq0KJxPOqhTJ1?=
 =?us-ascii?Q?8O/mp3Fwsz3gdxKYX4PyXUc5xhq8SYRkSS4a/JEfbiY5jSC40mke50q5S+22?=
 =?us-ascii?Q?EJFsS7a/V29Yj5mpE+4caGfm/oIeiqthFIp4k2tRXdf2T+IfLPQ5Mr2duHOs?=
 =?us-ascii?Q?ugzZmSa373j+8OwgqgqN72U3B43P7bq+OWvmWZuwolI7o4IYlBx0Rxu4qW6M?=
 =?us-ascii?Q?NT8j7ZgZunjZjvlmZ/rghoDNugrr0DccFnq4ThceM73B4CEooqlQOoRn5iD1?=
 =?us-ascii?Q?Rf8afGGFy634XpXK96cI8vtlvLLs050gP30Kw2ipk+oA3CvINXID5YhfNsMv?=
 =?us-ascii?Q?jICLInK497atWiJtJ78FjSd6kXba4hlIjk2K/ldEXJ8dPlZ6lenZVedGCt+O?=
 =?us-ascii?Q?j93kkJXavJAwHGw2xknM4BaiwwN+/J9+VPeMt0gF33xJh3BuYOS/svPBuz1m?=
 =?us-ascii?Q?qzUPeD96qJ80FvwC8SyBS+dUOJtrGuN7z5Qws4QkkIZLSwJ0YjMAy9aYbDEf?=
 =?us-ascii?Q?ZXWPEaKt+3qvkUmpvP8Cya8TE+DTmTiTfZnAQfaOmzvi/WHvoXjKLiQPvbGx?=
 =?us-ascii?Q?f/tMe7uvTO9QWKNGIMhUZ0e2E1/X2Ycr3h5Nm0fBOxB4V37gBLyXaT+IIH1t?=
 =?us-ascii?Q?DuxFxYtu+2chX/DeAtQ0IMHiFEBxqpCcBooIZLHEF1Ifxu4iPOoG2/TntEt2?=
 =?us-ascii?Q?kPni2DYT/Uhy2PUoEwolb0qSDXqmc6vInJK2gsGXWKmN9cG6eigtw17AEIJf?=
 =?us-ascii?Q?iPjFDsrIFMzieFsWqi1OOGzOX53JjfpLVZwTxt1ufeTlRYO9oYW+F1RqknHD?=
 =?us-ascii?Q?RoxsBF+ym/YvrIQq3oSExdFunRuhuC5OB8MM5wD0nSLEO6JSJ9VH6cMs2oLL?=
 =?us-ascii?Q?1C4IGSSlSmJnZvOw8Ls=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e8Qu6XnX79Hh8hs9Eapk3lZeYAwpOOp0fi32j0ZYQReTwecYV0uQgWjGm32v?=
 =?us-ascii?Q?9zJ4/A4vEDR25u6/dbwDv/sBi/+H4ohcGG6LsB8BGANAr0paHT2V+NPeMuUC?=
 =?us-ascii?Q?8o7B16IyzywA73QqSCTk9G9QBUQoaXfFjKNo7TgDisqhFvZJCbUQvAg82E6r?=
 =?us-ascii?Q?6bSCvqtt8qHsp3XCb1uJXcZu0HJOvjqWhu7oNervYR0AUWCVlDmKeNuLAcOF?=
 =?us-ascii?Q?vjpKPXndaUDt2KJ6VJ9lr0f8gBiY94uCapOE7e5iuCpt1KEqBCO0DyGWT3vY?=
 =?us-ascii?Q?NrbPEo9oV1xm5dIu9FW7vNLsXVZ1tNWtdQCKKOANOnSeV5F0q4na91fQfS5b?=
 =?us-ascii?Q?s10Opovrj7za8LiMnFAyyRySnf2XTguM1FdjsdEryGV/v8lCXBp0rwtrRojb?=
 =?us-ascii?Q?+MlgFqQgAaynDmaS09oamsxAkV76oiUvKkYOR9SSj+opw81eQM0526um2jE0?=
 =?us-ascii?Q?nLujEUBAJ/FFeI2hoN9BK2I/md7T+iXjCQnYKXrWaZXK3sj/OIJ2x0swYR6G?=
 =?us-ascii?Q?AYplH0houpoYzGEFvQbb/ZJ3hLa0+gc0dFeTrkmjynb+LysXg+OZvZiCNyuj?=
 =?us-ascii?Q?k+1zgmaLx0wMhWgtCFIvijriYA43Cyd7ie6YQuyZuGEiUBtJXsNjPcGxBsn5?=
 =?us-ascii?Q?9HrxVYSpMHh/YiX5303yFf1suyiYZ9nBIvjwYJ57d5pmK69q+EmDjdHnkLus?=
 =?us-ascii?Q?qh1pFjVm5/b01igDrawpeqU627BJR6Lx0C0dW5Z6cjF2eP+aBdl/231lIgET?=
 =?us-ascii?Q?ZjcihCAcwV3uwB/zon64nw3QqmnUTqTZ/TFuX6auAQoWaGudJs9fkMQtCsuQ?=
 =?us-ascii?Q?ByvqV71fvNnjnSJbu2dwSChYqmrgYgPG0bMfVLQ4cZdHZvo5RQ07J9X8myB5?=
 =?us-ascii?Q?IvAxKWh++g4YrHIKZ9xrP3eMXd3OoY1um85LNkkuaC+UJvnvkWd7oN/3DoHj?=
 =?us-ascii?Q?NSgAEMEwUxYCatIWbxN4nUAnxzUYd/BKRZ9ppPa9fchy6I5ZIrnFxa3KSfyi?=
 =?us-ascii?Q?Jtq0oYl1DYRPtS/mg3kN2om1WdjdBRzDkGzp7ctTAueYcXQyZX3jplsOYqr2?=
 =?us-ascii?Q?ox9mYEHZv4FsB+UxPEVh4VjDCEipS0o3KB7ESq53T0ChoQfVxY5ytK09qWjh?=
 =?us-ascii?Q?R49CIsY45FgHAci/nB5TMfglpHM5LMfeotg4fPj3WS4fCkZA86AaZjAoVTQE?=
 =?us-ascii?Q?JdPloTgh9GBiXmNYn4PylswwMgG/ARw4ARYy1009/LjhYsxHaWCvYEz4tBna?=
 =?us-ascii?Q?kAbj2NMsJ64aY5UkX7AlPlm84aEwNyQRUfdw24XMQxqL1xxKCgHK8QPYvVns?=
 =?us-ascii?Q?elNBS6EXPsl3ZFzYKtFO1FOTdpRKVmduDkdNBlfIWEURh3SiCJImQAt6oQNG?=
 =?us-ascii?Q?wnogVCkhKt2EOs0cckYEHKnb38qm3IPJoukPYqB3VmlAtdQCkbNMHNE/RmSU?=
 =?us-ascii?Q?hxJNW4aTzduixRVWoEbi2wBNd3VSCQ3dZrq7hkUTU4oEi2fO/W5KIAr1Bu40?=
 =?us-ascii?Q?w1IJewalKVu5oYzfLrJawzG4CxLkYQnibSWoKgdjuNXKQZDyO1U4pRyyK4JL?=
 =?us-ascii?Q?0v/3RGud4KPDxw06RbONPg4thDEy85sAYTy/wItZB3vPIsamoQEmuzdf8fPA?=
 =?us-ascii?Q?CqzJi/E5xw6tg9CgDhzv/fB7CvQBGH6yRLIAe6olzaaiWbaYdqNvOUy91QNY?=
 =?us-ascii?Q?XV4qm+TUmrjAm5QwPBNj1rOs76iWVFNIOR4Pp5PN9mjk7Hfh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33117bdf-bb54-415d-cbf8-08de62778756
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 16:24:24.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gRQ55LJzljLDShUGQYme6kVkklC1DCevyfOTSB0c7tihhZKcToQxWgr1Zt7fVcl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685
X-Rspamd-Server: rspam11
X-Stat-Signature: sqgd4w53yk7njoxm8qj8uzps5uq4t6oz
X-Rspam-User: 
X-Rspamd-Queue-Id: 44820180007
X-HE-Tag: 1770049473-950801
X-HE-Meta: U2FsdGVkX19savzC9yq5lQM52kQgLYPYIrFmwd2krF+l2F4zYg82JZtMZRszt1fxymUGWRYVouiER9sg+GYaynZDUY0lUB9PU1f4HTNBC3lGb9MTksFQ+Ez8HqDVR+IngMsqkEaNzj/9hDbW+p/5JJasba63xUew7QoCdANVOJlHrtDg8QP7zLq4Q6uaFT3b5oE/aV/UwGW1GutZ5l/mZzqdda2fbaToqu7y0apcHmmBJ4q2Uwwnke/krwFPZwu9FigQ981HK2rCqoCeD04uf0I5aQrQzrhLJM96gP8qGCYGdsr473iLDKYcObUj6LDrMf8WHn8rbmh1L34+dCLvqbKV99haNazB/lrPURw0xQ3qORRuYWnEQqzoezq7KZiZzgSa49Mg8F+zVeMF8T1uKXfrHKUuBm2ZmHE55hgdnaOruGVz5N75YmCqfCb3tuvLQv+FZtJ9q+SF+H5sXCxkRQBGNpuAWo2QEcdoBpaQ+SwuRhQ4r+7Q6MQDpPRqIkVJVmV191nnaKQpiz5d3XdSjfs05wp7Bsl3aHNioxT1iFJEDMlTRf1J9K/hLtvznGpmtZu1LmHfvbxhV3Fci1TtwfeTcBrzxx942qVounb6pDc2+mcKwqimNhzZhkNc5qwOK7E6hq8n6VNHnXsQKBDZxjzxknb0gSoiU6o7ELVMzToch3b4Ia+b/+FxnJ/yFJwwHsX2zfKz3mDFV3StjZEEk/LJcX9sDVz/jeXRxz6yyCSa0NP0+Dy74wR7fHvDxYDWds6goUo4YRn6cK+2NyJS6dcNM9pjU072G8lVTdJJnoTpLfewGD51x1h1Yx611e7TJyzlh9+P2uPEoKNFoLF1KETrjBPO4Dk90Momxwq0pTOT6BCmzc81PjbFFygrKJeaI9E0ypdJYokh8Z28fjEqrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Feb 2026, at 19:50, Usama Arif wrote:

> This is an RFC series to implement 1GB PUD-level THPs, allowing
> applications to benefit from reduced TLB pressure without requiring
> hugetlbfs. The patches are based on top of
> f9b74c13b773b7c7e4920d7bc214ea3d5f37b422 from mm-stable (6.19-rc6).

It is nice to see you are working on 1GB THP.

>
> Motivation: Why 1GB THP over hugetlbfs?
> =======================================
>
> While hugetlbfs provides 1GB huge pages today, it has significant limitations
> that make it unsuitable for many workloads:
>
> 1. Static Reservation: hugetlbfs requires pre-allocating huge pages at boot
>    or runtime, taking memory away. This requires capacity planning,
>    administrative overhead, and makes workload orchastration much much more
>    complex, especially colocating with workloads that don't use hugetlbfs.

But you are using CMA, the same allocation mechanism as hugetlb_cma. What
is the difference?

>
> 4. No Fallback: If a 1GB huge page cannot be allocated, hugetlbfs fails
>    rather than falling back to smaller pages. This makes it fragile under
>    memory pressure.

True.

>
> 4. No Splitting: hugetlbfs pages cannot be split when only partial access
>    is needed, leading to memory waste and preventing partial reclaim.

Since you have PUD THP implementation, have you run any workload on it?
How often you see a PUD THP split?

Oh, you actually ran 512MB THP on ARM64 (I saw it below), do you have
any split stats to show the necessity of THP split?

>
> 5. Memory Accounting: hugetlbfs memory is accounted separately and cannot
>    be easily shared with regular memory pools.

True.

>
> PUD THP solves these limitations by integrating 1GB pages into the existing
> THP infrastructure.

The main advantage of PUD THP over hugetlb is that it can be split and mapped
at sub-folio level. Do you have any data to support the necessity of them?
I wonder if it would be easier to just support 1GB folio in core-mm first
and we can add 1GB THP split and sub-folio mapping later. With that, we
can move hugetlb users to 1GB folio.

BTW, without split support, you can apply HVO to 1GB folio to save memory.
That is a disadvantage of PUD THP. Have you taken that into consideration?
Basically, switching from hugetlb to PUD THP, you will lose memory due
to vmemmap usage.

>
> Performance Results
> ===================
>
> Benchmark results of these patches on Intel Xeon Platinum 8321HC:
>
> Test: True Random Memory Access [1] test of 4GB memory region with pointer
> chasing workload (4M random pointer dereferences through memory):
>
> | Metric            | PUD THP (1GB) | PMD THP (2MB) | Change       |
> |-------------------|---------------|---------------|--------------|
> | Memory access     | 88 ms         | 134 ms        | 34% faster   |
> | Page fault time   | 898 ms        | 331 ms        | 2.7x slower  |
>
> Page faulting 1G pages is 2.7x slower (Allocating 1G pages is hard :)).
> For long-running workloads this will be a one-off cost, and the 34%
> improvement in access latency provides significant benefit.
>
> ARM with 64K PAGE_SZIE supports 512M PMD THPs. In meta, we have a CPU
> bound workload running on a large number of ARM servers (256G). I enabled
> the 512M THP settings to always for a 100 servers in production (didn't
> really have high expectations :)). The average memory used for the workload
> increased from 217G to 233G. The amount of memory backed by 512M pages was
> 68G! The dTLB misses went down by 26% and the PID multiplier increased input
> by 5.9% (This is a very significant improvment in workload performance).
> A significant number of these THPs were faulted in at application start when
> were present across different VMAs. Ofcourse getting these 512M pages is
> easier on ARM due to bigger PAGE_SIZE and pageblock order.
>
> I am hoping that these patches for 1G THP can be used to provide similar
> benefits for x86. I expect workloads to fault them in at start time when there
> is plenty of free memory available.
>
>
> Previous attempt by Zi Yan
> ==========================
>
> Zi Yan attempted 1G THPs [2] in kernel version 5.11. There have been
> significant changes in kernel since then, including folio conversion, mTHP
> framework, ptdesc, rmap changes, etc. I found it easier to use the current PMD
> code as reference for making 1G PUD THP work. I am hoping Zi can provide
> guidance on these patches!

I am more than happy to help you. :)

>
> Major Design Decisions
> ======================
>
> 1. No shared 1G zero page: The memory cost would be quite significant!
>
> 2. Page Table Pre-deposit Strategy
>    PMD THP deposits a single PTE page table. PUD THP deposits 512 PTE
>    page tables (one for each potential PMD entry after split).
>    We allocate a PMD page table and use its pmd_huge_pte list to store
>    the deposited PTE tables. This ensures split operations don't fail due
>    to page table allocation failures (at the cost of 2M per PUD THP)
>
> 3. Split to Base Pages
>    When a PUD THP must be split (COW, partial unmap, mprotect), we split
>    directly to base pages (262,144 PTEs). The ideal thing would be to split
>    to 2M pages and then to 4K pages if needed. However, this would require
>    significant rmap and mapcount tracking changes.
>
> 4. COW and fork handling via split
>    Copy-on-write and fork for PUD THP triggers a split to base pages, then
>    uses existing PTE-level COW infrastructure. Getting another 1G region is
>    hard and could fail. If only a 4K is written, copying 1G is a waste.
>    Probably this should only be done on CoW and not fork?
>
> 5. Migration via split
>    Split PUD to PTEs and migrate individual pages. It is going to be difficult
>    to find a 1G continguous memory to migrate to. Maybe its better to not
>    allow migration of PUDs at all? I am more tempted to not allow migration,
>    but have kept splitting in this RFC.

Without migration, PUD THP loses its flexibility and transparency. But with
its 1GB size, I also wonder what the purpose of PUD THP migration can be.
It does not create memory fragmentation, since it is the largest folio size
we have and contiguous. NUMA balancing 1GB THP seems too much work.

BTW, I posted many questions, but that does not mean I object the patchset.
I just want to understand your use case better, reduce unnecessary
code changes, and hopefully get it upstreamed this time. :)

Thank you for the work.

>
>
> Reviewers guide
> ===============
>
> Most of the code is written by adapting from PMD code. For e.g. the PUD page
> fault path is very similar to PMD. The difference is no shared zero page and
> the page table deposit strategy. I think the easiest way to review this series
> is to compare with PMD code.
>
> Test results
> ============
>
>   1..7
>   # Starting 7 tests from 1 test cases.
>   #  RUN           pud_thp.basic_allocation ...
>   # pud_thp_test.c:169:basic_allocation:PUD THP allocated (anon_fault_alloc: 0 -> 1)
>   #            OK  pud_thp.basic_allocation
>   ok 1 pud_thp.basic_allocation
>   #  RUN           pud_thp.read_write_access ...
>   #            OK  pud_thp.read_write_access
>   ok 2 pud_thp.read_write_access
>   #  RUN           pud_thp.fork_cow ...
>   # pud_thp_test.c:236:fork_cow:Fork COW completed (thp_split_pud: 0 -> 1)
>   #            OK  pud_thp.fork_cow
>   ok 3 pud_thp.fork_cow
>   #  RUN           pud_thp.partial_munmap ...
>   # pud_thp_test.c:267:partial_munmap:Partial munmap completed (thp_split_pud: 1 -> 2)
>   #            OK  pud_thp.partial_munmap
>   ok 4 pud_thp.partial_munmap
>   #  RUN           pud_thp.mprotect_split ...
>   # pud_thp_test.c:293:mprotect_split:mprotect split completed (thp_split_pud: 2 -> 3)
>   #            OK  pud_thp.mprotect_split
>   ok 5 pud_thp.mprotect_split
>   #  RUN           pud_thp.reclaim_pageout ...
>   # pud_thp_test.c:322:reclaim_pageout:Reclaim completed (thp_split_pud: 3 -> 4)
>   #            OK  pud_thp.reclaim_pageout
>   ok 6 pud_thp.reclaim_pageout
>   #  RUN           pud_thp.migration_mbind ...
>   # pud_thp_test.c:356:migration_mbind:Migration completed (thp_split_pud: 4 -> 5)
>   #            OK  pud_thp.migration_mbind
>   ok 7 pud_thp.migration_mbind
>   # PASSED: 7 / 7 tests passed.
>   # Totals: pass:7 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> [1] https://gist.github.com/uarif1/bf279b2a01a536cda945ff9f40196a26
> [2] https://lore.kernel.org/linux-mm/20210224223536.803765-1-zi.yan@sent.com/
>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
>
> Usama Arif (12):
>   mm: add PUD THP ptdesc and rmap support
>   mm/thp: add mTHP stats infrastructure for PUD THP
>   mm: thp: add PUD THP allocation and fault handling
>   mm: thp: implement PUD THP split to PTE level
>   mm: thp: add reclaim and migration support for PUD THP
>   selftests/mm: add PUD THP basic allocation test
>   selftests/mm: add PUD THP read/write access test
>   selftests/mm: add PUD THP fork COW test
>   selftests/mm: add PUD THP partial munmap test
>   selftests/mm: add PUD THP mprotect split test
>   selftests/mm: add PUD THP reclaim test
>   selftests/mm: add PUD THP migration test
>
>  include/linux/huge_mm.h                   |  60 ++-
>  include/linux/mm.h                        |  19 +
>  include/linux/mm_types.h                  |   5 +-
>  include/linux/pgtable.h                   |   8 +
>  include/linux/rmap.h                      |   7 +-
>  mm/huge_memory.c                          | 535 +++++++++++++++++++++-
>  mm/internal.h                             |   3 +
>  mm/memory.c                               |   8 +-
>  mm/migrate.c                              |  17 +
>  mm/page_vma_mapped.c                      |  35 ++
>  mm/pgtable-generic.c                      |  83 ++++
>  mm/rmap.c                                 |  96 +++-
>  mm/vmscan.c                               |   2 +
>  tools/testing/selftests/mm/Makefile       |   1 +
>  tools/testing/selftests/mm/pud_thp_test.c | 360 +++++++++++++++
>  15 files changed, 1197 insertions(+), 42 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/pud_thp_test.c
>
> -- 
> 2.47.3


Best Regards,
Yan, Zi

