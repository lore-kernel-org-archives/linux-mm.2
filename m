Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A175CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971E08E000F; Tue, 23 Sep 2025 12:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9223F8E0001; Tue, 23 Sep 2025 12:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810CB8E000F; Tue, 23 Sep 2025 12:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717C08E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:11:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EAF1140559
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:11:46 +0000 (UTC)
X-FDA: 83921005812.22.518D3D0
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	by imf17.hostedemail.com (Postfix) with ESMTP id 74DA840004
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:11:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ShxwmXjz;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758643903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1oPFxGJO3q4PF7pWQqu2dzwIgWKYdDMV4fhDyR24M8=;
	b=2cNKelozyxtq+gZiA9yP/Jc66O+TGwP36QtBqob0Wq7YP/IVvHqTlLFa/UQkSJAg9KBXcI
	myQFzPnGNzHqZr0p50EEgHMCQyGOcHshW/E2uHZQj42WxgqCVfzxwwquHa5/laCEpWkJmI
	rNIMh5t0rJTudjIPEOcZBIEgWz1haoY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ShxwmXjz;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758643903; a=rsa-sha256;
	cv=pass;
	b=l7t3WV51NhBRde3PW6qCUk4sK1n0wW3pwhNyh3phbvrkdTXefZpCcY1ftc/bwF3NJNBiIy
	RzcL21lcZsTcLOPFpm/JDAQNOku569PWaBnlRQRNOc62VgENMENkiHCBB2xtQcKpAS7e51
	TF0tDnc3XQgBwlI/IIlPLm1yaY7MPRs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DtzOjwwOD5tyghAaQ9LXybaIu6tstbbmLBNkj7uHtgvm3oIFN5UJJikwf3o5zxk6Xjy+PODnvO5pAv11nE6bSDtPGexJfnGYGrqphZydIhHgZ1NsdwH9Wcj+RSgqRYoKkF4imt17iN3od8jgrhGbGvLSGOKFb2syC/uvHvdS5GmRhxfrCBslzR5yvK519AQAALkWtIQfVKXXrOUXcxF5B+9kw5Juh3sGQMozfEar/LjUb1BDLYJ0JzgWPP4GOAbEppKFpuHTyLuOgvlnJ2MHkDL2pFczjfOCHEhqTi9mgP0mpwt8+lMfwDst+NHtFeIorsbxmaI1Pw3HLiFxe+gBNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1oPFxGJO3q4PF7pWQqu2dzwIgWKYdDMV4fhDyR24M8=;
 b=Fa8dHh+9rAaPjTr+yUZe383jI1oQvgm17fjHemcCWRmURO5/IY1aniZuC3US6QTZZlR0qgo1nt2RNdgfE+0Zu25a4wPVw6VlS6hUyTuL6XuhnWmex4IsbR9SPnqCV74f+S5RbNmYbFM3qmEErd8lXmCVJYkNamipj7Pnn1doR9jJcTgZYQhoANxVju4oW1fQOEA4SD2qP401pT4h27p0dCY+xaXHft/uomuJFb1m/0opcLtJ/LVGEaJIEzzwCcaThLX9I4dnOHo5FlgKsSCmHiUlvPCZLtPPtS92QreTnVoXAAOMVj86UTIv4DDJ/dT/cRdq7I1JarOhUP2hrLgiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1oPFxGJO3q4PF7pWQqu2dzwIgWKYdDMV4fhDyR24M8=;
 b=ShxwmXjzQ3uOvVwFtaYiIGGArh1iwa4zq02T9xerkqIn9kblSpEDnQ/Oc/thTxlbAOCmuevpqvJSwj+wn+khIGCRhRdZbzWDZSHbzZCQXWk1c2V+R6du/P8+bgrF7Ner7TLDXxxoXnOQJ3lk7XQ5E9kySsYFWpO227j2HtwEHnnI6X0DBqEMrzKs1uk46ljhz3amjcP/OY+pykmP3amTZAmdBgWvUjTLScbDI+++X+tn/ilwQGJSF1hdZW5T8kTsl1XHpKd4RlSIIYxUVF4v7xVC2pp1wJHHCEcE0ozSmkxO+LuhGvOTSEHO3utsvpGR1hqXmRE7beXSYQ3uwrUBqA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8256.namprd12.prod.outlook.com (2603:10b6:208:407::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 16:11:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:11:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/khugepaged: use start_addr/addr for better reading
Date: Tue, 23 Sep 2025 12:11:37 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <30FB9C5F-F45D-4EFE-920C-05961D28D6E6@nvidia.com>
In-Reply-To: <20250922140938.27343-1-richard.weiyang@gmail.com>
References: <20250922140938.27343-1-richard.weiyang@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0022.namprd19.prod.outlook.com
 (2603:10b6:208:178::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8256:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d3a53f-c01c-41d0-e672-08ddfabbe101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QMFq5PTYjwZe9xpBAtQ/+XMyAPE1zldr/lZ9j8ac74KhITsuhf9qFNjAoZ0D?=
 =?us-ascii?Q?6RX9nlsPY64a7xwWMVF9F8cllPaz9FYjiFfTskiPBgiOl4pFJs7uWaj12oe+?=
 =?us-ascii?Q?AYRgBCAb0yQIPm4AaZPsxlqoHM90UTzwmaZyeor0SB0g5BPzEYgnqFEJyc29?=
 =?us-ascii?Q?sXWxBSR35+gdWfqheFBGhXsp/hoav/k9RD7Ers3CixEh1VkLylHgOPXpP3ib?=
 =?us-ascii?Q?oOB2Y+Il+6yXvPC9gwSrdJm268SJL+fizziBnAV778+7QYI98aDjM3sh3ewK?=
 =?us-ascii?Q?cq9dTWPhYue9A/+cbAevaCGiUI0AL4Q1FvEUPqwNPuJ5Zs2peXdS+ISTYS9I?=
 =?us-ascii?Q?EatIu7gcQtQs9290AnsvTJuQ71DgbodGqFXv82PjYl4jGvTWuByPGpk7YtYq?=
 =?us-ascii?Q?HZEFkfpy9LzX9b8KCfDbvkxpU9y8e5qaYCYGkczbtRQBiK0zdenLrw6T8zYv?=
 =?us-ascii?Q?AY1XJU1pGZoSDixkgGXR/cmJdsi7Zk4olxSArCfPujQvNzV2NadiuXPVnc1w?=
 =?us-ascii?Q?BIdxV2+rGuKNVjHhKZaK2MqYHxFsLR1pU3mL8fe6xC2outfbUQjLmRM2czAo?=
 =?us-ascii?Q?9yuQUzC0uoTemLcDTU/A3IjQemS+P/wZHbo0PK/1L6IM1HNRVDzoX5nCOjkT?=
 =?us-ascii?Q?CSvWB34cI7zC6q91VPP0yKtPQxmJbVLmlxui9L5SPfeDxroQmE9I2+l9ZSPr?=
 =?us-ascii?Q?b/G2e9IvW+b3HAiR08bH/Q0PTM74cFEHfsgrBn580S88AYVkEjobb9Ly5pDR?=
 =?us-ascii?Q?HYOnmyroejF9pQTFiKvcMzt6Rj3DvM3Q930pWJwTE9F1IHKLd6Ff3iiaKkRb?=
 =?us-ascii?Q?7kiqvdjn4Mn/P5e0uw6gPKfYgEHjqRg264c5Im4BVkFYpvOulQ2zLoqjGO97?=
 =?us-ascii?Q?+z/okSQvYRuhRTLxq+uJEKOUQaKo4hqBBjNTamPMTj77Rsc3tkJlbtfoo89J?=
 =?us-ascii?Q?2C0fvKs7VZFF8+W1bp2aAdfsfsvsOr1VKIxoMSicH3i0dl57KmqrGG+Gm5ui?=
 =?us-ascii?Q?3OF+nITZZa/WhtbvRMQYZvCiYQgPU9lYiAFp2ERDTi0firUQdN+xtrg8L4On?=
 =?us-ascii?Q?n/ayMfKqfjXtvobyprJ3tVcioF4Z3vCUsh3yb9RWMAuEXJvdtFX3EDLo+1EL?=
 =?us-ascii?Q?CtqihpSwPfTVTNXDKNb/pfGZlQ8veKvoDZ7OeOMgc3K5csT2eI0B2eLE7pJq?=
 =?us-ascii?Q?H1CiUgwf/VZ959LYgQYS/IJM3wFZp/l/EaWv1knhrzagE2XBg8OBbIS/8qPX?=
 =?us-ascii?Q?hS4zWya6shygDTOpschdYWYuYRc3nBmmhXnCMIHhsP4/KVXm06BIGpmpLng6?=
 =?us-ascii?Q?q2XT18H2KOFi7fY/BnH4Ta9W6j5apeiII7puzvSaC7KIYYQDZTBvNHhUmtvp?=
 =?us-ascii?Q?jPiqlr/pOnHcXlpZqiCYVnd/wJTRuVPO7UaX4k+HFZtVzQdci9Z5m9XVvwbg?=
 =?us-ascii?Q?ltRH0J/2k0s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?14Clrmu+khONEiLRC4rXGlPifp5mWLe5AHePgtBkQ7ueEHUcEw72Ze9uHaEl?=
 =?us-ascii?Q?mEs517sVaCTFpFSCFMtCktWyq72WNnjqgi4RYSnRyXLE4WACCSSjC3zLTr7y?=
 =?us-ascii?Q?nftAtGiWdCo3eSVcAyvnMSA4ZeLKlpdBItnjtGJ8SWpKEWYNrGNT+G3flTlq?=
 =?us-ascii?Q?Q4PH5djhNg1JTrOP0ghr8Z91ciT83pqAYYA0B8MhKBiEsboO6TX13zKNOS5d?=
 =?us-ascii?Q?jAb5n35aGGh7yjka7Thl2IW7THJ3PNfHF6lnrsaZCVxgDeardp3Wl9bWsyyC?=
 =?us-ascii?Q?8bSBh6CtLX3cXvHB8++0Wz200EigT6Yhmufw/6TkwkI/PZvdtIq9K47Tigyx?=
 =?us-ascii?Q?hRUuNbop4pz6Wic9s/KkUVf7Zb51iel825D0LtveFvdKp5HCzctTb1JXdmUQ?=
 =?us-ascii?Q?FFWAuYTw31KluHPmYJGLARacgZZGMYpEVgWawuMRr8yMkzwToYHiqrS4Pnwz?=
 =?us-ascii?Q?ljcHFoL/GZnd3qbBCBBYY7kA2lyWIKoASGJnWrp7LEKB+3riU8xBFqTn+WYN?=
 =?us-ascii?Q?7S43YCVlfknsXNLJ+XZSqu+lm5EJVypMojeMyM9oIrv5pDJ8BmiQmPnrpIQj?=
 =?us-ascii?Q?uEGO3RBKisMv0cRf/LV1RaD6DEojKN5AM2Lo5T5Q91ncSkpzpxSZPXNS1i9x?=
 =?us-ascii?Q?VwOUHEvbv+n32t1QLVeSOtPmencF4mOiyHinQTHIjOoHmJE3P0cd2sBz5tYd?=
 =?us-ascii?Q?b2Ks63eYCxVVt8gwJiqVpSrVEzu+1yqtjXH4ds2e+Jm6mNLZzR525MLGkcu9?=
 =?us-ascii?Q?2nve/ixhHrsFRjBgBe4GoA6/DH6bjL8Y/s1PtX7Od8EDo9ll9xdxEuhT4pIf?=
 =?us-ascii?Q?ZobfdYEH+cr13Dy6oAzDsXUz9pDxYIF6x7uSiIVqYZHzoHR0KAoBtZOpkjQ+?=
 =?us-ascii?Q?RvhpDhbHlss4LrKHtV//nsWRRpRtueeDY8h0hZkkrYM5NdrIV3UR+AD17oJX?=
 =?us-ascii?Q?l2Vj/d8mrrq17VqFE00fsPNjGUATCltDQEJ39i1jh6tDNQxb+ZyFJ5j2WBVs?=
 =?us-ascii?Q?D+PuDMxlEw0d8pgxHY7/Zi1MUdwvvuTHMh33EuFf36Z+36UthBRJ9cEFVA94?=
 =?us-ascii?Q?TVj4aC9flnI3GkQOPMtuEiiPDqt/yIXEivf9gf+g53o2o42hTegawSKhen/0?=
 =?us-ascii?Q?JeqD2fcPxmUaKYTQIZPEc27HMhVQRG8waFuHvY9oGHkvxtD82gJhz3BLpQOP?=
 =?us-ascii?Q?tLucB+2MZDu5UyUyaf/PvuW0zOSrAc/V+o+fWSljCYnfNQaAABLjbERJdUIf?=
 =?us-ascii?Q?PbsvIiQcQYL+Ik94eutVtZnglArTjCWDq7VaOKP6iowUwjcsUHs4gcr+f0J2?=
 =?us-ascii?Q?ZbIzNTDKFf+9zucSSKUVsLnICd/1fofQrhOWr7TejNGN4xTpknkeqcUif8NL?=
 =?us-ascii?Q?1EWpg7gUgEYZXap0oOPWvQgISyMwYF2QF6VRvOiA3E8C+UXOrL/eE3k6klmD?=
 =?us-ascii?Q?5JzmBNwgRIe00SyAZF8/utN5mE09QgKS6AvLMeft8HFjZ+l3ssdqKjYlorsU?=
 =?us-ascii?Q?7HAKi7+EQq2g7L2mJjOvKY7M/JeXQ5uQ5RsJSDacTX2D1VcK8Jyx3JwmzgBn?=
 =?us-ascii?Q?Sx2mAIMCd8Vf2zQUO26SHY2JiB/jGqaVHKb8GH09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d3a53f-c01c-41d0-e672-08ddfabbe101
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:11:39.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wOw+ECg6iQ0fInyPo9zLbmbdLs5YrBpkchvZlKvzfhleL7umVBYiWXviqmK/f8U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8256
X-Rspamd-Queue-Id: 74DA840004
X-Stat-Signature: ojupbqyt6eia8kw7mcne7cqtekfryi97
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758643903-563775
X-HE-Meta: U2FsdGVkX19+TTaM1D8bs+DWoPYae/YUpiB14bZvo9MU7qB4CWFjNPNEi9N04NHvxPm8IIO+V/hLjq7YiZT8ZLfum8WJMLHuPXHvkrkTiIaukPuzUYuQy8l77+2+lrcCPwF9yQzWsNPnIWKPnBADiBHDJAFHULZaT9X0/GTVkJ8UfUPoOslWFmU3Uy2oaVPTG4c9cBeIlX1/J1F6x8XtrS5jn2jVDbEUsdLTVx+y3ZRhIRzF6akOlOqDaDEwA6/6RHNiohhRRc9Rw09yddt3z+F+I1auUAKUm7pe4lg4zICS6ZZwkoTTPZ0nvgJf6+0zT3SNvB0ye31aB69RoQ4Hw4T3t59/vr5mWrGOiPwf7OZKboBu0GO0SukF9mg2NKIfgTottVX0/KJs4gj1lKq00bAdpP0a0Mm9PNOXPZfBDSFuX3zbqLfM4Qh7OVoVZZejqtgG/kCoUrFTy/2gz5UngvBn7d7xhPuHj4iPxRmAvIeP4f94WrqLjK2AUe5B215HWMcsRYhd7pvl331Dyal7bXZv2/weG2Tb1ZYale8qR5mIKLAV64rykyc2dZ0+INkRNbH0OjzsUcj8lO53oSXn4Up7g+O/Q2JdbRB35sFaqvqiXuxUXxXnQMmRSTEwvTN0TYxtN2ptIT1FXdcdoPMCkO5CR//YJMVR9g4vvARaVj4/9YJmm+ETj4nA7Pl39Vfe5aaaNZ/azXGZnjPGmJ59cRWzB5mZxlqEjSgo4DZwcL7NplzZO2KUvZ3DaZOeeYYHEN6Wn2fE9tjuJI8rWq7ZfXRJtGBGi77qtaf+O6YorI3KVm8rT+Mpogf1Kj6FNrnTlMlEzTiTzFGtCUBVG0kHSTKo6cgBfz1fW0IRsbe/X1rhWUath+3MdNATj8ntIVjUf2xgdtK5fuVuA1cYZwVuqOnEO2JxQFewAPr8idPRvWigOKEhiJjD0ytF87WuvmEas4cZ0Rg6QdA65F//YmG
 0keSQcJM
 /LnOdbB6+3WXwGqGS1goYT8DWY087HYbf9H6iQCw9qrLzR5ReUCKzeKw/VjnlT9uxQolHtnDvjW+SdwI5qdVfuuHwikkCJrq35b406a94d1u4Llt245poGyH4/uCJtL2kw8uWmJs40RsStKEAHp4AN3/pCjBLP91Hr6bN9tbrCFHquIOjmbnKwFO9f7v3N/0cqQdA7n3vZg15K2Pc58ZWUxdyoeNWJZV/vzagNwXop5E7juw1491GxIWQhv9sEZdHcXQzNiUeoQ4QsbZgmgkLzeNds5eAtko4fufyFBCmkWwsRNGYZdsghYQK1kIahle24ErTxXWGVCLaGtHsAA3gzb4ZnAGB7a/Pqo11lXAsk7Vq4VQ6kFwGvn41biTCR+1YVrwECmIWV8qB7j6hyKhxqVqoMdxQiAulvun63jT13AJZL5w0vDa+fyX+ICWtKSbkLRspnMEnCB9xB7ViI4GD1STHAD2QU0F703tJa1sQ19FazqUGI4oay8A2Frg6Kw+UTcWdwjvu6bCq3A/T3A4iFd6iHO8xNCx2bqHHJj7R+CERQG/PNUMpejaYgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Sep 2025, at 10:09, Wei Yang wrote:

> When collapse a pmd, there are two address in use:
>
>   * address points to the start of pmd
>   * address points to each individual page
>
> Current naming is not easy to distinguish these two and error prone.
>
> Considering the plan to collapse mTHP, name the first one to start_addr
> and second one to addr for better reading and consistency.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
>
> ---
> v2: use start_addr/addr instead
> ---
>  mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

