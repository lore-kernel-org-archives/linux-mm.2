Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACDDC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178C76B0005; Wed, 21 Jan 2026 11:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163CC6B0088; Wed, 21 Jan 2026 11:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BF16B0089; Wed, 21 Jan 2026 11:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5E0F6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:32:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE58B8C4F4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:32:24 +0000 (UTC)
X-FDA: 84356513808.28.17E3EFC
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010061.outbound.protection.outlook.com [52.101.56.61])
	by imf04.hostedemail.com (Postfix) with ESMTP id 037F640015
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:32:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N32GGgvd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769013142; a=rsa-sha256;
	cv=pass;
	b=AykcQunfBsX5RX6LvQ38NFd2NWlNis4ii6vHR5C7anSkya2tbSIMGaeyl1u4cD+ms+LApW
	NfhTd9cUFWRPP82Oi6mZ+sb8Vgzio/DxTPfT0zzMLLSGTKfYhhKIuNqO8CMAqWieUImRps
	9LshvzYXJAeG2X5ut8HaGgHUendT5iY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N32GGgvd;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769013142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQP6Pt04OdEFCZeOmadEs7h9Asd89GQEeruUVHScB9E=;
	b=un4lo5Lm4Gq3UoSgm34kCEubE6bIKnPweAjtvgy1HKm2zeQHzIRXju0ZPVZffzYft4SZ2I
	qH2ql5kJoDwaECI3uA7UPAUtA03uTvtoVQ1zc2SDJ8LiuSFW1fQjvf1kbFFig5E1skcG3a
	NXrCsEHx8mmGf3y1oVPs7Rlw9KmuhXY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NYH3S3iS1/M20DA0W7ZgTQPn1Qh2hWm22WkWBMw3F66HwzU8y/tfXsKSpKkN4B6GEsvYRkeJ0z8JC3u3VGRivJDzceaZRcsSlDBzU+/MALhgSNt0psNV1U/ZaSUXYwkWpAiJhS4THaok+q5g+jccQFAKh/02lb9EakyWZQhsw8x/OXOqmMfyIw6VY1XNwbeFU3InrDDe+++HYCxLBtcEWZAKG4/WmkFEXcPUcG6p5azgRsgmUX+xd4dGvcpn4a/IRIpMO3Sa3CJLFaU/JHkHAwfIaZHk4S0eT9h6t3z+pIjmPpX/S+JcgjvZ9dlyukKMNtwJUR2b1keaZmvLwRC/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQP6Pt04OdEFCZeOmadEs7h9Asd89GQEeruUVHScB9E=;
 b=BfjLJx5m0NKw6aOAcCFpVLAMq+TG30fBsCrU5Tc17/L4PUzDHd6YsxFjCT95urzmFAixc1d7mifN6BIj9a1M9boOg8k+ZXSRYZCqroNH13E0XRYmcueYCgYWPYPs23VHRADM9lL5GWi+eRWHC+ajIeCZp9cdLwX1QSGeHBR8Cr44rDQpsgjp6gEWK/CVNA5786bh/Qr2pVgTOxusB11BxHtHWeoxIWda0CAVMnrVCljfmnYjPNboGbcVAiaBApXB3Z4+SbVAIJxQIW2K2/+i9SC1iZs5MvVqzAG/hyKMf4gtJcIgEf6OlwJ5GfuAXGS5PtcGGYShIlJJLBZmFGOxrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQP6Pt04OdEFCZeOmadEs7h9Asd89GQEeruUVHScB9E=;
 b=N32GGgvdDgum1kyS8Hr0POdcqurCD5QSI1HM6SROZvbDoqt3fJC7BsGtrV6ewpjVCO0T1w+kRQP2KvgSrEWvWHgY2zpCCQLmhiWA0EMXd1o3jDpHKvgXVZzRBWbX3z6i27MaKsCoUAA7wWoiyHMmQHJ7UQImnOzb2BdvCFhqvMLfqXGsOxLnjkJeWeFzZjSlMukPeiPtqIgdr6SjDOiLSu33Nmx7EMe5egXUB3pPgpsiMdOfGl9DN2fDIoxXMOljfDVL8Z0y76o4+jBOV/iVdxDI3AIMXY5PsNUb8Li2vCv4Upa4Aqs6Lp4RlzeeFahcK0Xqgzvy+9j65c0bDUywjg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7180.namprd12.prod.outlook.com (2603:10b6:806:2a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 16:32:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:32:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 02/14] mm: Change the interface of prep_compound_tail()
Date: Wed, 21 Jan 2026 11:32:12 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D842AD70-03DC-48C6-8807-4A004B98A012@nvidia.com>
In-Reply-To: <20260121162253.2216580-3-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-3-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7180:EE_
X-MS-Office365-Filtering-Correlation-Id: 42069c82-ae48-4a54-fa03-08de590aa477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7fYYTtwA1YAQuh+prQM+qwgpAWwVSKbhXW9OigC4qMjIhVOMvGWN3XmEVUKx?=
 =?us-ascii?Q?jQ4ka8dlmM54G5XmsFNR01qjMflbdW4++OAiuQn0WIAA4tAMu3dV05y1Jpza?=
 =?us-ascii?Q?O9e7l6MxtjB/LEzCw0DXvHWRB1x9D78rUdDrKmQ9bdGYis5ri9VcjVkiVwdI?=
 =?us-ascii?Q?RrrBbQ1avDB3zmIXA9dRVd1JiCitv59TiDn+f0akRWw9SWSkN45Ycc1nuGnU?=
 =?us-ascii?Q?G+FR0e3fwzwlE4Uo6ggJPeW+Bc6IBNBFoS54dr+h0F4Z0Sd/TReFEwbRTT5K?=
 =?us-ascii?Q?Ecn00gxJDKu+xLER1KfrCHKppzyUzitGJlLNZRR5nZKvhMZ0Cu82wHO0843t?=
 =?us-ascii?Q?lgdZhy3niXzwzYquNypBOdLttxxTjuGIgV0hqWHUPBQX7zl0K/ZROEGFabjP?=
 =?us-ascii?Q?Wz3agm8lENiEYW9766jQMoxKpFgL2GrEYuexF3JFthQgkCPPJpX6V9gjxPcB?=
 =?us-ascii?Q?EfqBbqaXRMXwCQ+gNWc2Rzba62fuvfyujRDFgd8adkYJfd+uBIXhjsigGxNA?=
 =?us-ascii?Q?L7/SEUnBW6UyhuOQVVQN7zJS1kBvEGOJsrFjBGyI+83pEnxGXBMFTuBMsf2o?=
 =?us-ascii?Q?v3HPN6VbJRcZu9RbdUGlllqU7CNDpwEw1FJzB618KRqAjY4QgqyRPg0+oGh6?=
 =?us-ascii?Q?B8LvoVZsmBLVPvouDD4Do/0KqZNdHg9VMGf/wShNsrpcfF1/IQO1jOq4Wv8D?=
 =?us-ascii?Q?/st40nZB0sJZsohMNqNwfHEpuhT8koqEaOYY3m9g09Y9DdLh2/ksG2tkYghP?=
 =?us-ascii?Q?pEQ5WBXzc6x/mza4npVJDnMscLuPSaRe11Fo7cxgcdQny9j0bRMhlARR47x+?=
 =?us-ascii?Q?SquAsD47Rv6C0Ws34XJyocisUpIR1QgWmL6bDrfgfdR3gPTyVbCpgOzYOf+x?=
 =?us-ascii?Q?FrN1NFrI3FXhg7rcu89EH/LnQgzX4bFQrX7Ah8H0dEggUUX9htd2sXjaVvvF?=
 =?us-ascii?Q?3ZG+h2hIFrTVpEBErE2WNdphGXGkthrmZePdp9Dx9CNNX4zgy/ajSceDRnnC?=
 =?us-ascii?Q?5QUAxQ6UgBh0p5qLjleRKAYYgjRgKtJPaxdAuW9ByNsrUuEYL9BNhjNWxOGW?=
 =?us-ascii?Q?EztGLEvXnepMNM5QQQejBQUpd69EGlam2IKLSqPZmH7CMd/mkzzNC9zTSkSw?=
 =?us-ascii?Q?xSwhbTz9Snj+PyLQzJWysklrqROnjZWkQ2Ekff+4XU8nyT2Yb03uzMElCA4c?=
 =?us-ascii?Q?HzsYlP2paJxnFob0AbANewxs2x0Fe1kJHAyA6fwT+n/Qm0fQefqYbEUskB6a?=
 =?us-ascii?Q?BOdRVAO6mgBUjn+UABON4v8hvrdcB3YCeU7uaKd8JH8TzO2LB+gmjfHdA5DK?=
 =?us-ascii?Q?OnLlIX5UQZdRElzhok8Sd8u6/cxS9ib6/u/W1ncUGeLpnQ2ItN1h3WNNfqPi?=
 =?us-ascii?Q?bIoFIIHIdoIz1C5JaLxKUJVu4gZFSmlsXkWP8rhXa5WaE+RkHWBP6kypNub+?=
 =?us-ascii?Q?BcNeYfMACBWlVGrZT4a+ieccxRWD1VaDI8DL1nRTlxwcq3SQ7E52JvW50xZo?=
 =?us-ascii?Q?jTUfymSS+r5Ka+za7j1iOwEiZLhZgyBNTryQYQI2I99FDaajWNNNm6pxbe2e?=
 =?us-ascii?Q?zSO4TckjMFdjlLJe3cM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O6Jnu3iMq92IffXBDgn3ueC+1bflkTFXdvgF+YC3VhhXsr1UIDUqtKBxJIL9?=
 =?us-ascii?Q?zLVdlE3cTBICiyqHo7KMW3/N/YaDyCJBF/KIiHe19zi/+cTBKfcC+vTl1MsP?=
 =?us-ascii?Q?fmPYWBkWHCdmjTjphXPmJbZ/d6ffkFNhX57aWGvCiQK3ZfOA+4ex9UiV3esC?=
 =?us-ascii?Q?nGd1jAoUTgadlWkZi6RW028AmZ+jVXq1BDZHkRzuyhG/7Ti2mo2Z6ZE0Q5+M?=
 =?us-ascii?Q?Q3rymf6jUNnok1wycIvAS2v1ktwyLB7hNdepW8V+QynsPV1/5maW7E9iCepk?=
 =?us-ascii?Q?w/1hboZBD9kInBZp8v702+UK/cb1DngKxt88zFmFLS8tq1+i7jDpHODLWrjd?=
 =?us-ascii?Q?fXiNHlP8aSRE0gyTfxgWtKmc6UFCJBnNVMEZLJZhXoB1hWr9oCH8uwHE39SX?=
 =?us-ascii?Q?OegYMAHq4dsRbHieqyDyhaA9kWGDarxRtnjEdEQVx+peOPjWvRuKBRfDYRkZ?=
 =?us-ascii?Q?tlIbgp3BxWdWHWrGFMUgu4K9IEDAB3RPdIRq1jB7c1ArFshZzn/xYMqkL5EF?=
 =?us-ascii?Q?xfrYRpWlN5BI1HABh4xBdA8KsS5RDpXIAjzc2LdFVR138ruuDXNouQOxjfuX?=
 =?us-ascii?Q?RvjbVD2H/p3TJXN5mq2WOIPl/OP7in5gsKhmj18HZ0ttGpsvBveOa0C1h1+E?=
 =?us-ascii?Q?kVzVC5mi2XfJAgfyUgdcdRjMyp1mjCZsorC0i79nqq08SoMA2eDNCTpQ//O0?=
 =?us-ascii?Q?T+QB3O8+A2h4e4b6i8lAeiNgZvJD9E6L4/IZSQTdLmzNlqrjHjZLiq0UzMeC?=
 =?us-ascii?Q?Ei9aGBE5BJNZbdIHHSZ03ieVKBdsuAlO2HVMZFeor0HsnqFbN7gdk0jcOWUL?=
 =?us-ascii?Q?Ex8ZUwmIZGoD/96YIdUt0ZgicQvuOFR4gHLVtKAW8BaNjSR+Vk8zIs+iKDrN?=
 =?us-ascii?Q?2DeA1/TyiU1c6HRFCxwKhsyJn1kLlz6foVnU+kkFiBu8/6VqhexheQvoexWq?=
 =?us-ascii?Q?P37YesyijXuRPqM8FGb82lyeq4RNZKg2aTWnhcFb0aqNy94fRPLbItys+4Cy?=
 =?us-ascii?Q?Csa0Amiu8FunvN9bnK8CO6eRAlQQ6mybCBs+sEoP/a6p4WIGw2Wimk4ydk8o?=
 =?us-ascii?Q?zF9LFN3mvpvIzbzGaSYCHf8laa9ASHu4GqHF7c/Q4W/HJfhdutYoEoiBw7kY?=
 =?us-ascii?Q?tyoyjgL3huzg5l4pNEWx6055yFriOKO5okjT+SWt5LBoRzui4dldcCY5YtE1?=
 =?us-ascii?Q?cDnNGq9PeRI1iyL6BfUXgFJ9s+y0C+PhjQ+XegZvMrGH1F3iwXhEYeJTfdOc?=
 =?us-ascii?Q?zXiv5MSdbBV9acB53xiY6/hLOS14nLgPhrkDOnJ3wZR3rr+BGQfRuSBb8VV7?=
 =?us-ascii?Q?lzFaE9Odcji5IYCaf4sWRw5FMylsBaN08cTmHDFK5YzF3kR6bFwLP4KDqe7X?=
 =?us-ascii?Q?EY1Gv/WK7P4W5vr6LZyE0FBN+vZAh5xiMBdiKwYL7oHuuo3Gl5pnoA2yg61h?=
 =?us-ascii?Q?LJK7kQM5JNX7l9b7DVfH3iw9mr5Gohz/oJSnC2gdgJm3qRcAMCTxhmYS6k8j?=
 =?us-ascii?Q?9DTyJtqDTcJ2pDqokIjDmqs/7Oz8fvUJXkhelCVmemDm8jUL83Wph8WHr6Yx?=
 =?us-ascii?Q?hK5gS01J3UkDNeb88xVMvV/k2oqmX1srCcW9E8O/wfRSL5WfdK57foBIZ9nn?=
 =?us-ascii?Q?uJgC7/LromvLiKCmK79xocSH4FUf8dfHvnoLrbc0Wtq6Hw/KUhdDAXyGAoS+?=
 =?us-ascii?Q?1nJLkHWdd/7ZikNgfHHxA7XthGebzRDx2hY1AS80wXi4GCwJI7EQUYreV4Vo?=
 =?us-ascii?Q?Ub83bGrPgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42069c82-ae48-4a54-fa03-08de590aa477
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:32:17.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBxMH1uHkWvs8ntzyAqWfCWolryOcz4ORTeR8Fzl+BO5JHiAufitpbCXipJDgMvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7180
X-Stat-Signature: 47y1uoxyudrkqqfdh81zfezqtu1o7n6w
X-Rspamd-Queue-Id: 037F640015
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1769013141-680808
X-HE-Meta: U2FsdGVkX1/fIICpCSg4T7q9pWWtdi9l0XSzuIi0DywfkyqOGTyz5dXRlJZb01v9rdq0zugTgczAu51Do9J3MISRsmqOy373LRjLaOUEzAIxzaBEnKCTstJaY00h37LkfQMBBcmaQsPkOEKsvzQTHi2Jomk1J+aqAPce5BqbaLCmDVfupQ+Auw0rNJYhdZwgfzBPf/vLeM52ei63YXRP34zVVr1sTkm4HD8gOLqPTyI2jZQzhsdtuy9LoHdmG90WRmGX0iTsjp946kLVwMBxroAyHb9CW3ntg0aLyrWBveRihpm19VAEv6f7mZym/HMqemJPV7l8JXB/TQ2PBVtp0WDozCxgFODFBBYM6BYUXhTWBg0US/ZbEkI8kwLJgkWxxxD1mIQ+jmGoLSd0SdLXZ0RZ/t6kBSQ+HkB5bbqA6sD8xT+Xd1WZPUtKDiT/XcdsoozkEEnq6sekGdk+guGJhwiN8yM+uSV8B6Yg7IhxkuxZCezEiY8sCOKIaPxQnFK//HDcZpvB46ifoL98kiLfiQRPm3BqW1DLNKouDri7u+NT9Vy1wWb8/yWTWVtInsCuhfajf6WKAGPB6UJpJIenWx7PLHDvT9Mk0JP5ZBzbG7kc/DbVTvR5R2LKUJdQVDqid4p7I0zUZ06FWTEQ442B+73OeZMSdmkZMiXg4C7KpLhk5VZPe1IcddoJBwLoj8x1TIP8jm/9rxo48tUo+0ksYqj73E0XrA3pILVxkmTicuSmRD2U3J9pjVNc0NZJF6Ez3j2CrTawhpcDoZBfIl0+tM6icPyK1kmbsii5GHmbhx2I9J2zLZfws6axKCkuUiE9O9WdZ0N9NnFliyz2Hhl3ll31bS1bv00PG2W95u/GjTWq5/V+HAEPdtlI5b6fx627aN4+W5+b9+A4DWD1FgD4a1Z4s6XRbYMz/P3FUSO7TJPUdpPz7Ct+gYyqfFJS43ExfF0ZO8vGmWo+tlRrl0P
 BaL2bm8j
 NbdVI2LlV4kAt8ip7vv6D2yJvTEfIDZbhy9keXgkJERQT9SQ68U+9wGq5U3biBDa45MnWGcv3svguIhm+CG4mgIm+4O4UHp3HeEQs5gqFZigvdLkgyH7FjB7MM2R7QOQKCZOFLmyKvpSwZMSLSCjUuXn756e0Cf0pItMvnfZ8rCwRS7Dzl7gfgBZ8DCG3mKBWmfvD5UkPOKu4AyD5QiPH9nHi+HG25XZ4rG9Bh9mLhFcSk4VkZUvHNb9NtdPEemEnU1YIPDl2tpVp0a1ml0d0T9ZSCqwb33afIxaYdo9B1IEFa/+UuONZvU7ZBGTF8Q0udHSoaVG0+q24ts4yMiMvWCAJaPWwnH7evQ0hXKY15BgCqXgoUIDRbEYi2LMykLTkBzyL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
>
> This is a preparation for changing how the head position is encoded in
> the tail page.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  include/linux/page-flags.h |  4 +++-
>  mm/hugetlb.c               |  8 +++++---
>  mm/internal.h              | 12 ++++++------
>  mm/mm_init.c               |  2 +-
>  mm/page_alloc.c            |  2 +-
>  5 files changed, 16 insertions(+), 12 deletions(-)
>
Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

