Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4E27CF34C0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110CD6B00AB; Wed, 19 Nov 2025 09:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8A56B00C5; Wed, 19 Nov 2025 09:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A5D6B00C6; Wed, 19 Nov 2025 09:48:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD4C36B00AB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:48:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0C991A0521
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:48:34 +0000 (UTC)
X-FDA: 84127637748.11.13DE664
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010034.outbound.protection.outlook.com [52.101.85.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id D303E40015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:48:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="uUmZ/7Hk";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Ba7Yr1yPyjK7RTM4WZR9otz4K/AgDz1iztfn8ZUONc=;
	b=J4cTpu3MfN2z+jbch13yDeSNsrQZXWfL2MuaTF4uJhAfKimFS1ynF1AQEa+KFCHgt7RKFG
	2ZVtZ1LWEwaLLOpTa/2op3e2TEpDZPYEvYSugDl3dvVL21XRogA+sBCF4EkW/tllXuMoQa
	1Zxnl4QFkGjPSOQVtmNlHzSzZNkZc70=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="uUmZ/7Hk";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763563712; a=rsa-sha256;
	cv=pass;
	b=VFAY5s4nTN4r5ISuXb1T8v0XU6CKM2UcLJ/wYM2NOpTeZod460PXfrrf2lP27ZcAiFeZ76
	Ofr2fghsUN6Bte5HyGO41Utj92OvnPbWeSS4qeQLsk4nzvZl1NYqfBsx3Q8qJSCN39Mmmy
	qZ9YsvfLBbx1lsgkHn2BdOhjmnsoNJ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bIaB9GnRxNL41QZs074ky5w8FN2/+Y8VkG8hyidF+g8QE8t7sNQ5tgCGJ5+xuirQWts1kwtYPqUBAJQ0n3tiJPv8Db9yXSLlVzLSVQLg2zBuqVu98Olk74byDn3ciSeMg0Twsv6ICnbccWNL+roGQDwFRytYu+g8ESZHtn5qK0fU4smwvTQME2Gugb2zlePr5I3v2HqzPahp7Blnt1s+Gqg31U2VfMM8hk4XQM8QF5H6FOEOhcwBKz/0CaHDvRzH15HdX0eAdn1DHxkAaMj85rz9lXs9A6shas7T5Emq4iuZ1XtTEZH46BvXhRStt7whXFEgtf2TYqlzGli9nNmYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ba7Yr1yPyjK7RTM4WZR9otz4K/AgDz1iztfn8ZUONc=;
 b=Vq6DkNYIDrCtrMUF+iEQlhWGUQkeXoTkiAmx5qe6ssIUzTKjySSBzO8H5x+mUtfLuRhvHopgxUR6X8DPElOnCqL+rEX2to5bctbO2xqNOnmUA65fUkwkb3QF5xemrcPsrwZ0QLyccoj8eXiZv/8SSMI1deIOTaAk18cDCt9XaWLTgZaVfd3rpM6K7EynVi3CBI/DMLf3shJVie/OPxuj/3LfBVcSixCaNmc4YgEhFWRf3JA3vn4FFZ8vq6BTEDJBRS21YBO5wcnU6C6aSfc8CQkvDefR0v0uol5XoBlz9pVusv8Y0NnqNhhpw2+ClN1JxZ/MhhBeTEFOCFaj/K0/1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ba7Yr1yPyjK7RTM4WZR9otz4K/AgDz1iztfn8ZUONc=;
 b=uUmZ/7HkkIEVHodWlahqZ8rCwKlni1q9TyG/5O9iKQaudDl+xMVCf5IjoHJ3e9k/3ZK+QmsQK8zcB03v8jDB95poDnmtKP6xLwT+BrFP+L4VMyoHErK3FtJVmiIwYklfKSsKfkZkI4kU6agPWaeqHFU2XuW2NozNonzxRpVUWaBJhNokkvJm6gsAZi4om8bzR0w5ExzIz64VH8p2MiN3EUvv5Jys9fns+j/gInZX6D7CmLvtZFA8s25CBrqXwiWy9nFz89A0TGyybt7rRDEhbI3FL9GkYvlkSOdNkqzk34VGhN9k8XwbTixAkwG6enYbL+wmpHlOU0PDIZUw3UzhFw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 14:48:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 14:48:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
Date: Wed, 19 Nov 2025 09:48:24 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9C8CDE11-44B2-4C55-897B-A4F3FD695EB5@nvidia.com>
In-Reply-To: <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
 <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:335::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 4085649c-df81-4b94-22bb-08de277ab254
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?34FsVBP2JzE5S0jqGS5r+C/FpiR6NmWobdIgoE26iBeM3m1WK4U+6flO2Y5A?=
 =?us-ascii?Q?SggpUXdQfNIz7KolAxICjjNYgXuoEXFCD2SYSszQxcXDWaOsyY6mK51DUI93?=
 =?us-ascii?Q?Uc20MCYM0h+jA2zog07aQmgFNg/PzCGzLLWjfkZgk1stVWG3wImgw/7hyPy2?=
 =?us-ascii?Q?mfbGqmecpYFGBu0a7GWWPceYsj936PDsz9nQMcKe4Y82ez6QDtMU4wUWWXxQ?=
 =?us-ascii?Q?wpUGYprns6/J9/7WxOf2fcEqZVe97mP+XdEyZ22qVi9Ntj3pZZ0BsCy7byYK?=
 =?us-ascii?Q?qc+PHHlku9Hn7eiqdxGMnfu5aJNM/lGhDG47LZtkprh93qDx2wpSLOu1qx3W?=
 =?us-ascii?Q?u0l3gWj3LAkTtgWujJXDQ+KvxZYKh5MNbmywxWBtu+J6dUI1nYKIwFxz2JkM?=
 =?us-ascii?Q?hqNPiQDhhivNnp3lk3nlfxpYBU1KnbnTqA3Hp2bVNKNy9t6HIoQRims2SCl0?=
 =?us-ascii?Q?wpcwl/jaVlirbX6FoDw3pYlZr4BUlUhCs+CxTY21/DSmf8+JDoaF9ZkYIBDj?=
 =?us-ascii?Q?Dd+YRo+7NuDQo1LDsCDCeYbYHhH/EKXB2zWCeiYmjLVzQX6PLHUal2AWjbwU?=
 =?us-ascii?Q?qD+F6tL/GYaHbxlmeH90FIQY8wih4vQMqJrZY8jW/L5Z7puX0F554Bk69sxP?=
 =?us-ascii?Q?34P/zLUJzM63mVGpP6IHlQNhGy7g7iDLhZ+W+mf/EPh3xQU/K13RULcNs/0L?=
 =?us-ascii?Q?9D2mB7csATrZME62D8gbg9tGlySBV9oYEAio4d1ElDJPrL1RHGWqi8FO/fsL?=
 =?us-ascii?Q?u6wan/lTi/8eIlNjIrSR1St0EZiQclUsSg6XDnzpjrwTPQRPP9QP+ZE1JfxN?=
 =?us-ascii?Q?g8vPBnRRorisy0QodFM8V82ybeq/2HdsO7KILX/ELVsRY8aKOLJnSB4+TLbP?=
 =?us-ascii?Q?OhIv6XOq2U+BBNZsZogLFrRhKDzM9xiNLhI51zYpQomgyB2eq+VFv6RekGLo?=
 =?us-ascii?Q?GPv869J0IFm4LE+ZJvGceu5Ya3M7B0342XSpWXQGpjiZzJKKegJy3biHyh1Q?=
 =?us-ascii?Q?m2XAvoczIgeR2nJZjEwAg1rPPmG+Udpg1zsuzjOQSJmpSEUuEWn3YG3S/cnb?=
 =?us-ascii?Q?MQZKmnnXaDZrrqM3W5azdzKyvRP/ObJsuQ8oF5qTEOR0/pseYbSSwmJujnIJ?=
 =?us-ascii?Q?FlUU00LUdJ3WW7cs5WtBrIXU3Ut4Jgv+l2Qj2xFgYBRtJIbkKgMUD3VL7LEP?=
 =?us-ascii?Q?XVm5gdbmugcq4/4fz2VJpIMwEBLG7wzEXpCipKQSrZ9zH0yJi5YPYfot37n1?=
 =?us-ascii?Q?+OdP81mhZ5ct9JantTcMaVjJGRa41mFidvMdBI+ffBvUBBDefH6IcWOaqnvj?=
 =?us-ascii?Q?wz9exnBwxbuNTkU2Y3HJYhriMGge/cS8TkBmALh8OKXu800wlKSNZ2rAK6PU?=
 =?us-ascii?Q?XWODrgl2h4ebTaVPqRDNOkEAcExUAvgW/pL2pyXXG7KREMdGnHh5rN8QA1//?=
 =?us-ascii?Q?f9VCjozmjwQsQiIgO1c1zMJDIOddmhJ6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YzlDpTryRjXqk/MauJi0JsdElSeDVM0nbxskmnYG8smZ8f+g4bDHE4AJNQoo?=
 =?us-ascii?Q?3HM9Kpxn4NMuo7bnmD08KF4mz6hTvptLiTU+2mpYrObxtjBeAPh9MtXSb7cv?=
 =?us-ascii?Q?g3ATbZP43RDSOwR4WnSzY207jFq3JGk9o+WnkNmmPtKtV8oCrWAfsJYSd9+u?=
 =?us-ascii?Q?vRsbb3iZSwA3FA5P1yPiKLnTxFkL5T3DxpfVEUY5JUQvTd41QXFLiHAxoKZa?=
 =?us-ascii?Q?+ynpKJN7s5DjDNP1z5vdCtMXLhotOusWpT9vE/vBgiUMVSweWqHsnjk14rkq?=
 =?us-ascii?Q?OFO4ZxXoxbwaIRruMvoE8TJcbuGOWFeEtoQk2+s/tj5JvnedsZH3R7r/NGXF?=
 =?us-ascii?Q?2nN37fTVW75azS5dAdy5R/DLMKSCO8Jy5o30dY8fPELFQGXnsg4gvmIJM4T1?=
 =?us-ascii?Q?7FEN2RsauPGsd805v7N2xmu9/Lx2hezQDOkfwN6Xddee+CMupbtKcFv2luxB?=
 =?us-ascii?Q?QGJa3uJi7rI/LhSpvBCzuZU5pKiy/6cHG8vkNtRVvQIGPNvYzGXxXJ8zsNJ/?=
 =?us-ascii?Q?UVByDnhSiO8ma1Mskrs06TwDDSgivMyG6HWkoicE8qQ/Ln0P7eJFTkQo3TnS?=
 =?us-ascii?Q?gRQoHE/PFvu/kLAOt814dbOY8f03prfmYMA6e36pGgEU7+g+EaD4P49cJAUK?=
 =?us-ascii?Q?D4oKyaHNfAIB9try0OgI6YNvzA8obh72gFo+tjW6ZEAm3Nse5/0QSv9bNFZ9?=
 =?us-ascii?Q?Oh1rl/u2bA6fYdsrtYxgdejhbWfMccueyrqa2yEUfPylYxg8rx7dRDT52tDI?=
 =?us-ascii?Q?2N7/x/dsqFTB+GXRrKDqm6w2jJGPkLfGyx+IrJxPa9i0Ynzac6acYdUuNVEp?=
 =?us-ascii?Q?azu2uhx+wY+ulTWh/o9Y8m9O+puLoEBx/87AA1WZlJQTjv4YKjzAAQ/bgaO8?=
 =?us-ascii?Q?kxbHMGxAQXxSvfVPvHPRA0B4PyRmJSYRGG8BmdmuskvtBa6NTJGB67SHvraE?=
 =?us-ascii?Q?/9MYmUWlCry4POuZ0aEPD1usNI4vzwg5SuspjdES8vs0hTJ1bmYs4pTexPAc?=
 =?us-ascii?Q?vYUw5H8eElp4TxwTGWrQRVe6gBJgGKRmZGIcmnfq3GmsN79EvrR2/pStwBYw?=
 =?us-ascii?Q?RmsZaTS2fpGub1u5UkW9bEIz9tM6ljseQ3Vo9i0TRsCfU41No3hxNFKfIdFh?=
 =?us-ascii?Q?TEFdH8y6gLFYG27FJWrc3PCFeyOMjybnFIrRTDBq7VWCnpV7DaEV7EWKgNxe?=
 =?us-ascii?Q?EMSwcgtGdhMSUZiyVPcBTPJVfTvn4oNdxbqumUoVWSisbaAaf75TGopn5W5M?=
 =?us-ascii?Q?64P4877c+pWqqsdFyqwEEWqF7Nr7gLkmmbXgwS2K/EywX62poamttJjTzYfF?=
 =?us-ascii?Q?OCxjaEEt62XnlNsi1bv+vn4CLwSohqj0nkbGe1tCIuAGozFo6ONbMr4IXPys?=
 =?us-ascii?Q?TPtXphkNvACN6HewFu1wwOM1qFgxt+T2hTry8FKI2j/wvCmFw1abDOvU/IdP?=
 =?us-ascii?Q?7JevmojE55t3fkM4TXAO36FmnOmRRKAAmtEPlRSZf0jJrO/kEbKaAKgKbX+W?=
 =?us-ascii?Q?5WyJQFlVGt8UC0e11Of9cm40vy/aB2pPlFGIbHBlKToAJB8PJlwruyxDQdB4?=
 =?us-ascii?Q?iqHTidq8yk59PGZXhyyEuAHX8Z4tILmG72QTH/ZH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4085649c-df81-4b94-22bb-08de277ab254
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 14:48:26.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fun/m+14Ix8A0bx/thl/ppGcwb36pOsn56CkVqA3cVevhrJmouQ1dDPBX9n5Sc8l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D303E40015
X-Stat-Signature: 65zrbtz8un4hp4n7ftji7fwiacknyww7
X-Rspam-User: 
X-HE-Tag: 1763563711-392086
X-HE-Meta: U2FsdGVkX19CAB+uze3aIhIXPh8X8i/rdc/nV4yh6HmOlxJccObNaAk4os/+bCG4i3B53kVi6X/UySqhqFcejyclfITY9EwhOQbuO2vPPPt/6P3u9OUpzYZaHexSCaAXhhDkIdvgx2JsY/9jJ+HkXxzUzNE4RXywmPAV6YqKL0O16d6SrTW5WRs9ZTAyHaqh1YXDjeCQKjc6zopDwMZZgp0YGpfSbJcxZ/LwWIAkoLYON96b/mKaTZuPOpC34zSrxtxOr8LhWk0cPjKPNS3keR591TRlx3f8P/CqkZRsDXBEIorcyaP5QRGU0WoDqVoZv/6jMazMF1rGMMqU5uwiAgJsD3RPV4HQ7lffBqyPi41ll5O8+dbFx9P/jbb1qP3PGdq6uz3z6uZrksJFAmuvU74jHrTOptLQbZWKXjjBAik/d/F2XjojEsMZvMhX0W1sY9DGPn/SdKAR/XXfLNyuRmY1ZFPJtrOPvjnep4UhhQvzc/kUwcpB5zjr9CrmlByCLOxCj9qZo5nOvp/IP8xqhYXwvyOG5LQI0ExTjnhigBNevdPLPfIpHDlRa/YE0VpkatCJh7s5UCX7H7x3NqFEB4dcnqm7WsKQVRYkPNgc+gSyvsCB/grxgtwUgEZhalZNEhn2SwMpGZQjD14Ztfw4t2UgvkJ1hKp4BKwXxbXidpuUk7DiMLmksVLQcEYh8BeSlig6tV0GQlT548VtmVRFeugZd59FB+QeNvDp+nP6l0ePc0SNtSrs3Yj72uPegQVmQUlPDemPKGoeDj6BKQw2iVsqnNLF2rQOv6/PX+ZQ/JdWZaxNxJX1a2DizG3WMBrk253p/9xoQnbYrAx67cuL1FQ+ySNT7ckaChf65B3MuO/AuehKqJ20RGFG+XjFz4Laj+s7Epc//Tv6ft64LZobpbiIIf2pI8tOt2l9IrzA+pH2waM5zGuJFrIWZuqiWfIPPg02BO4FjhVGZwSrMvN
 OTUySHAq
 V7oWMw5h73BvZqzYq+C7zxhBbIZ8O+J1i53KZntACjlwjB4iJWmij7o+Kmiyq10KRFPK0H/hdkaOI8HvWGT8ktZqxkFaZLS5EiuWK8Gf6fGFx+sUDls1oZTNsp0e1O9pWBCt5QBifYb4X5NEc6r07cuxEULE4MaljlF/BgmWN2Dd708qRmcEhJjxrn7gVErdTfUfhr3tZPIJ4QNAx7efMM2YL1lYwT0ecPO6Dt4nfpDp6y5ZS/dsz5e4XkNeqZvdgbdi+39UrsM4q6vGY5b2WeQXPWK3SootmshFKjQd5edespA6vguzW9VNdd878TAyjCD+HdX1wePWFNCBJ+GF59/y0bKQGFbiI8tla7BBOljnA2BVGuzqGOynize7lDNzePLn6p+a4opO8rsT1SEqOfYqmFemnynuZl5Pof2WpV2CE411rvV0vdbs6IK4QKYlBuI8MkHhEOyMhzEzex51D6hHMK/HM8hPTYO0hPvsDrInQudE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 9:46, David Hildenbrand (Red Hat) wrote:

> On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>>>> Given folio_test_swapcache() might have false positives,
>>>> I assume we'd need a
>>>>
>>>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>>>
>>>> To detect large large shmem folios in the swapcache in all cases her=
e.
>>>>
>>>> Something like the following would hopefully do:
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 2f2a521e5d683..57aab66bedbea 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct foli=
o *folio, int new_order,
>>>>           return ret;
>>>>    }
>>>>    +static bool folio_test_shmem_swapcache(struct folio *folio)
>>>> +{
>>>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>>>> +       /* These folios do not have folio->mapping set. */
>>>> +       return folio_test_swapbacked(folio) && folio_test_swapcache(=
folio);
>>>> +}
>>>> +
>>>>    bool non_uniform_split_supported(struct folio *folio, unsigned in=
t new_order,
>>>>                   bool warns)
>>>>    {
>>>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio =
*folio, unsigned int new_order,
>>>>                                   "Cannot split to order-1 folio");
>>>>                   if (new_order =3D=3D 1)
>>>>                           return false;
>>>> +       } else if (folio_test_shmem_swapcache(folio)) {
>>>> +               /* TODO: support shmem folios that are in the swapca=
che. */
>>>> +               return false;
>>>
>>> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>>> Can s390_wiggle_split_folio() such folios?
>>
>> [noting that s390_wiggle_split_folio() was just one caller where I new=

>> the return value differs. I suspect there might be more.]
>>
>> I am still not clear on that one.
>>
>> s390x obtains the folio while walking the page tables. In case it gets=

>> -EBUSY it simply retries to obtain the folio from the page tables.
>>
>> So assuming there was concurrent truncation and we returned -EBUSY, it=

>> would just retry walking the page tables (trigger a fault to map a
>> folio) and retry with that one.
>>
>> I would assume that the shmem folio in the swapcache could never have
>> worked before, and that there is no way to make progress really.
>>
>> In other words: do we know how we can end up with a shmem folio that i=
s
>> in the swapcache and does not have folio->mapping set?
>>
>> Could that think still be mapped into the page tables? (I hope not, bu=
t
>> right now I am confused how that can happen )
>>
>
> Ah, my memory comes back.
>
> vmscan triggers shmem_writeout() after unmapping the folio and after ma=
king sure that there are no unexpected folio references.
>
> shmem_writeout() will do the shmem_delete_from_page_cache() where we se=
t folio->mapping =3D NULL.
>
> So anything walking the page tables (like s390x) could never find it.
>
>
> Such shmem folios really cannot get split right now until we either rec=
laimed them (-> freed) or until shmem_swapin_folio() re-obtained them fro=
m the swapcache to re-add them to the swapcache through shmem_add_to_page=
_cache().
>
> So maybe we can just make our life easy and just keep returning -EBUSY =
for this scenario for the time being?

Exactly, also an easy backport.

>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2f2a521e5d683..5ce86882b2727 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *folio, un=
signed int new_order,
>         if (folio !=3D page_folio(split_at) || folio !=3D page_folio(lo=
ck_at))
>                 return -EINVAL;
>  +       /*
> +        * Folios that just got truncated cannot get split. Signal to t=
he
> +        * caller that there was a race.
> +        *
> +        * TODO: this will also currently refuse shmem folios that are =
in
> +        * the swapcache.
> +        */
> +       if (!is_anon && !folio->mapping)
> +               return -EBUSY;
> +
>         if (new_order >=3D folio_order(folio))
>                 return -EINVAL;
>  @@ -3659,17 +3669,7 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>                 gfp_t gfp;
>                  mapping =3D folio->mapping;
> -
> -               /* Truncated ? */
> -               /*
> -                * TODO: add support for large shmem folio in swap cach=
e.
> -                * When shmem is in swap cache, mapping is NULL and
> -                * folio_test_swapcache() is true.
> -                */
> -               if (!mapping) {
> -                       ret =3D -EBUSY;
> -                       goto out;
> -               }
> +               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
>                  min_order =3D mapping_min_folio_order(folio->mapping);=

>                 if (new_order < min_order) {
>
>
> -- =

> Cheers
>
> David


Best Regards,
Yan, Zi

