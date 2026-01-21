Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290D0C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726436B00C6; Wed, 21 Jan 2026 13:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDA76B00C9; Wed, 21 Jan 2026 13:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6226B00CC; Wed, 21 Jan 2026 13:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDE56B00C6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:21:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27DA91B0A78
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:21:58 +0000 (UTC)
X-FDA: 84356789916.17.4854BC2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 763E540007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:21:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=osO5lkFu;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769019715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIRlpFg9zFWmj92AKKa+mFEQjgM2zjxJHQwKGAW1O9w=;
	b=NiydI6t0R8pcI0bpp0WukDOic/6Lzh+NQ5eHk/7rLhZ5M9gPcLdH7JH+ZJvwg9cdgpc3uG
	XPpMelpVyGhqo0GkOK+Tbom1tQU6owDlFc9G14n3VLSyAGD0IMCl8fOr4DpmpSpXTb6h8V
	zFc79H+fsjAdtWpimBvW108hie5OJS8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=osO5lkFu;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769019715; a=rsa-sha256;
	cv=pass;
	b=inViAE6uNVm38/sT1LbuFygJBirf2tdW85Ia/36x4zXNY8HKGHIFtNaEk/oBdn0qP05K2n
	DE9RruiuvWS4VsGn6on0dlfCO67FpbX4LOejRJanGFtBRJrmzqmUgYGSJNadfDDAeFGBaU
	Z/d1f7UhlfHmDYhLDT2i+7TBZQ+wNF8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GY4OAQ+mN3p+g1azYx8erJ/zLp2zYcXjhH2pkKyH8mXTO2VonqnJFhYSfb0B8ktLj9IPHXU0oNNs1Xt24fY19Z3HY4oNSDsBlC6s5LjrM1N2v89lvDRyFoaW+Eq26wIP5848FatvCsw/EoyDk7F4h7LAEGwGfioZiDG3iRYyYhQZWPwVlQLH+ZfPPEUMDTa2TeXFzyB6WAjhcbYkjeIkExCllfU+ICZpKVVkSDsQbNXIUruaol0fYMVJZC94BSd+CMENYLRaf7W+uzu3K7BudKQWHQrNaygT1wNJNjk/xb5Y0A+A3aOnblYFq/Z3T3eIUH+BuxYtmEvhCKWuICGmwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIRlpFg9zFWmj92AKKa+mFEQjgM2zjxJHQwKGAW1O9w=;
 b=RZaO7I4seF5TaPEkKEIsgTEQdWvJPcpev/wLO3kruEszpzYX9OlEdDTnyuDyZUeb2qCBepcJIDTqidJPa7U/pKEA7Uu6PP0LOTa4ggXH3pBxOkmO4GD8u8iPmU+G5/elUs82VD2hXiwqXtGTJEAXZ+pcbubyc4l/24ozr/FsunZs/Pf7UIYiZfftTbOMWvaDN5c4tBjMYI3F0KjNt+o9p4G1uv4r1sMxQinYl50BST0B+IvFqjXXgD/nERLeo1ZloAJWZxotLRgW9PrcvCcIVftbMRBKdVxZvxAE2nsbCJZAxiz592CsjEbj/fG2UMzoFfFdcXznL4teRr7jdn1QSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIRlpFg9zFWmj92AKKa+mFEQjgM2zjxJHQwKGAW1O9w=;
 b=osO5lkFupN5/NH34bczkJ/dYCIvz8mQTqUdGiTe1kYc3+eCxU+QzC21WZUYZuj+97ux+odM5Wnswru6835S7VqoIBqaWmv0fLKcRV3uBJvtmsJWZRxnZQcZm6AAbUIdvSywZqml+/baYu3rFcj6BqRHV45TcTeGUlByeeTTr4ByvV2IE4vNurEPxYzKjQakwmg9j0NnVTUDDYevgQ0vot1NppJnlLeerAQYaNslewVnNw275mB+y5PD6sO6mF1RfJVHyDA5mhOTDo3tAwxT6etEOiXr8/b5i31Kffy+UyzxiIIiZBCLYwsig4cnKFmwsqSY8JJCEFhjS7noB4Yat7A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8359.namprd12.prod.outlook.com (2603:10b6:208:3fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Wed, 21 Jan
 2026 18:21:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 18:21:50 +0000
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
Subject: Re: [PATCHv4 13/14] mm: Remove the branch from compound_head()
Date: Wed, 21 Jan 2026 13:21:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <576136E0-440F-4727-969D-B558C862CD19@nvidia.com>
In-Reply-To: <20260121162253.2216580-14-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-14-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::49) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8359:EE_
X-MS-Office365-Filtering-Correlation-Id: 655543df-2d83-4ea3-b2ea-08de5919f226
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N4pBuSSSjlhYkux93Vc+tN27GNVsVXHlP2tkccHpvKXV5Tty7fONdmwxjPv0?=
 =?us-ascii?Q?DHv2tCSOd/WZyXYNBjC8aFIX0GhkSnkurTdyfPEatz75QPbwg4/gF4KmMt+L?=
 =?us-ascii?Q?wYeYNWnvkcthH6UT+KGj2J47R9qD/RyylpOX+mfUX/IetH3WmUrcFgcpAsfd?=
 =?us-ascii?Q?XZS1rOPWH3lUYrbfdajctQ8jayipSVvvgrYQX/hBwz4Rj9HRnR0HHlQBbm3K?=
 =?us-ascii?Q?kaDfUAdg7YIkD4BjxM/u48nhSykhU5jxuTwCY8/LVARlLixlozn9Z+SGqjv3?=
 =?us-ascii?Q?xGs7ogcbBXqnEtNGdUVdss1rn+AUFzXE4HZPCZhIsEPllpmYBvaCu5jwd+eE?=
 =?us-ascii?Q?T5QUHnQVbJPYOTTYuCaHPlTvCqtuYVMwRDkOil3jsD8vD1mdPEVuNPoK3V76?=
 =?us-ascii?Q?tm3LFMG5pXwi8bOHpMpV0wjgfjBFgdVd/Ec/RCvM6xjZ64Kq38p/A+ZO2qhS?=
 =?us-ascii?Q?U3wMDTF7DQIxqG2phakDOrWHIloInt3TjbSF3mRxm/fPzgU8AZz+W0z9ItRB?=
 =?us-ascii?Q?kZzAKcsVMEzHiI6VtvVBJLvIoY4V1dzYYT+xupy/omduOyr7ljWKqEzZEqvP?=
 =?us-ascii?Q?764fEpc3VzBkpx+B2vRS9OZay9ADZYIU/CUOXwvA/a9lKNXz5e+IpKA+ib2Y?=
 =?us-ascii?Q?2JrBRjgutx447OlfvNL+jkQGQfitxgZIRbz4zk+1FFIf6sZeYVmnnxeyR37u?=
 =?us-ascii?Q?H5QXhpRgeJi0FCUgAjtTa23aipyD+cW99X9TLz8Kwa3x2nOjdumIBJbClj/x?=
 =?us-ascii?Q?p+bJMUrmZxBb856xQMRxUvJ7fV3Skgrf4vFmj6s34XnZV5wEP9yzvI3tTgk2?=
 =?us-ascii?Q?08HaoCDHmW1gAX28N9AdJ5u3jiNXPZlhDaOCepZP1+v0NhyQe0lxErB2httv?=
 =?us-ascii?Q?Fp7Gw3qz+d38aIL9j3rRcDvC3THeczqdody9LpLQ+uLjivngtDZQyrrhZ/um?=
 =?us-ascii?Q?+p+Y4QWySN1RGBQkTS3YFJj29AQ1NRCgeCq68VnRyf0ACxtiIb8WXQMLbjSO?=
 =?us-ascii?Q?Iuf2y/E/V1btFjoZUIKhTn0p73CvLkglJt7IyGMTt18Q2R/3nBXQTnmIO2sr?=
 =?us-ascii?Q?ineItBd1rJ3OG44Tl+9fxdD3bpc/azvv1ITewlYmsPma4xqHJhIdTgzupYqh?=
 =?us-ascii?Q?1Lhx588+rG8fspIrQ1kqaDI0zNBr/J57zjC8zFHlXeBqY2OlxVKSqNxJitwr?=
 =?us-ascii?Q?Ix1PkzG/wyO+6w07mwmCcQKa8Xah8LZabO5kehE0kQr0yuL4bWyuPe5mhjcp?=
 =?us-ascii?Q?SIi5bUv2S7GJwP07zRK7ZDpSiSWSLozWjAHGzPqdphIBCdB4H1yHPRtCz0tf?=
 =?us-ascii?Q?nkcWcad0FjP7fPAEBhBrJyDLr1Zf5sDeGX01LCbi+6OXCocdaDrhALivnTHz?=
 =?us-ascii?Q?JMfiQvHMk85SjuD70izD5xUavNSSS6lDQ4od3YoBkuUz0AtJo1V8S8dRLuj1?=
 =?us-ascii?Q?9PwYQ7cIfPhS2ZDlyCxqZunNGtGmsTj7js5WLOxLuqPvhYN6tID2gA7iR9Aw?=
 =?us-ascii?Q?JSarPfceVOigWt56VZoFgBQ/+Gxopb4FBTzR5TUTstcBD9dQmJlwLQT1QOuz?=
 =?us-ascii?Q?ZRVM8zTPTwBXKAZwkeA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytHdCZtz9C0/fzso3PkKS8PDztHL4qZQWPlLRS/i9DQppfpPJ3nkxlBi3hl0?=
 =?us-ascii?Q?1jOVdgixOzV7fX1LJzNERl7sGuEn3bukCdn00u1fQkF1sPppON3pYBp1/TQU?=
 =?us-ascii?Q?hU+HBBVamBr/6pFy7DFbjuTdpWz9oqaCgrr9The6NS0JVdptUyOeN0HccX/s?=
 =?us-ascii?Q?oMhNX48JvEVja5r7+legDUkGWylUwfiJqk0amrLbCXvzLSdOMXZTUiVb5ldF?=
 =?us-ascii?Q?KlYJdcQM6k4VAevsQioFN4VtoQxTM/OAMvvvZSHKeRStKlX7BdAH7N7d/075?=
 =?us-ascii?Q?KfiYGOsAcvJ4nkFodbELVDR5zxMRC0YoPyKAoCdOnCnbV1TQ9wljpcdQA/eX?=
 =?us-ascii?Q?WUmmdywToP/2b2uJHZ8bwleGS+TmDZRCxBUV//0j5QynVoO9exKMow7YEKUc?=
 =?us-ascii?Q?FZxpD/+sWDzaZvpFOvgvIeOjSK7upwA7y8nxLKxIc7gSqUmpDRtN15QbdVA9?=
 =?us-ascii?Q?8F6Q6cXpTNDf7StknyuRcAi7PiWDRDbZNwj5vJrMcUC6WukW23bfXCjadDXW?=
 =?us-ascii?Q?dFnqek58dm3vR+GioktJQ5tqD6Entu8WOpV0zNpLTMzA2u6U7XpZaQ/2rnfo?=
 =?us-ascii?Q?6OYaeE4iT1/92CVMQONbtQsdrs4Yk+ogZRYHz4NeWeLpXEKlfB6yq0Vurm/b?=
 =?us-ascii?Q?NDVRWE5BsenBKFp3zao04QJdRXa4cB5t4japezgXtnY52J4aMJDNpNPdyuVO?=
 =?us-ascii?Q?VPNSCF+bGqMBK2nCXzSy/CjaFRMfE6qHXoB6+KOFffh9d1SHkk0DJ1gSL1/b?=
 =?us-ascii?Q?BvGXsKwQ1ZpZIgHHiGBaISL4TBAz9jLw9AG+CI8roD7N0c4TU5qK8hdE8ZvN?=
 =?us-ascii?Q?b/Lu0hExfZPWpbQESqOYWdojtatK7vET7jwPry59ZH+CmGIxvFfjVpeWsaIi?=
 =?us-ascii?Q?b8F7rRs9MOXTKb1fGbNmVuY6ftcqPc1BwPeqGKSAZPiQ4ulfKS3GWQTy8aYo?=
 =?us-ascii?Q?DBkBFnpu0TFFM01TyqOoP6bYMaRFFEqfShyw30Tx9YgL2SIIUTOmq9Gxfwf/?=
 =?us-ascii?Q?NWzSjn9PRQPpox1pFI9yGE62He79VCHYPkyZjWKu4oCLht+PYN4nqT0+PsPp?=
 =?us-ascii?Q?w0KmdD1TdQDL1d5wQlYa7O3cHhzppf0VdZ2IxCnPs7zqXGNFRu7H0KKu0qiQ?=
 =?us-ascii?Q?sBdCGT/ZH+WEKz+4nWEAwQ8TvOmT4jHK2BnLNVQv/UoZLnwDNECrwevLJfx9?=
 =?us-ascii?Q?hMikbCisywE3vkyjEUZX8HVxsNMOVAZbDy6hA1cY1/CM3a+T8JOil58G4VCq?=
 =?us-ascii?Q?TAsQ5KpOIf6eCFAFjBDAgUYPgDWKaYMumc/TcX0kMWGWf0dIwojZ6CUDvYXB?=
 =?us-ascii?Q?1RcgFV92MloTgfyeQzKzDXD6epYmJzTsCpbxVEEra/MFj0IRUU6UDJZDgXlE?=
 =?us-ascii?Q?i9kw6t0ILr5DQAOYNUQxLcD4OSLT1qKY/vPGieOy6KIJJiJ2XvC6lPEHKHe4?=
 =?us-ascii?Q?/d/uWWVLkW08aDQVfDN597pzPcpYyeiehs+BFYv8A4kQ2R7VTgzloAjgwqBh?=
 =?us-ascii?Q?0oJdu0wVC8x3GdUdBqcGaB5e5M8JIymBjdDD7gbV4/HdFEEcXvMFGQOS0pzt?=
 =?us-ascii?Q?XGihK2PYAS+PFkscJhhH/34GufsZXzRTFclC8lFoQLJgbrAy5ljC3XSICJLk?=
 =?us-ascii?Q?geGwXo8CxdVsd+YVOu9GzSEFfWLx9ITpcaEL2FedcIFE/YSJSJCqWWVYA387?=
 =?us-ascii?Q?bEC1+gLZ8nMusGBmrxd+m3w10ZIBFOkzopWYW5wS9hbjKe0UT3bEyBeGYfK+?=
 =?us-ascii?Q?Qgq/5uvwVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 655543df-2d83-4ea3-b2ea-08de5919f226
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 18:21:50.6053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdAU6HKee5+g7YlRQXG+mBTJLlTNYDyQ3lvzY2VpbUCUCYwKEfAriVK0Ewd6w3CB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8359
X-Rspamd-Server: rspam12
X-Stat-Signature: 6s7gub6xsmb7tcj46umm4ocmurcyu8hb
X-Rspamd-Queue-Id: 763E540007
X-Rspam-User: 
X-HE-Tag: 1769019714-39393
X-HE-Meta: U2FsdGVkX193DjOcCHJJOS5BctDxk/nMcfkOxqPu0bI6B0z9hmTuTEhBeNSL7dHZ+FsUTeBiSKNp9evRh8YV3//xiTlTJRFXZY1/j0C4Jdkxn8S9NpFCu9Z86/c1Y2g8cIq1JbMgK35vnLbQX6ru9zDxk4otZcdITmphb40F/f6dhrC1KBAg7n/bSd9/QRufe7FaWCXMHig3fOqicoe7y7fHa1vzLMOXvb3cPnnliLvYJYGIUWXzrEYEfkzPA3/kywYcIH9S5CeZda5NWmR7QgnPUeUHtBlherLGqtKFcj+CjsQQan2mWUzZkLk53swrnpd37tI+n0TRjvxHc3NwbbYzkPclPNFqZQ/iNcphx65LvmUupNv+7qyNv1jvGjh0nwieGNi/IPFhcgxQIxNOI/7T74RsJRBjME5de6kRLJdH+LyEOMH8tr2jzYAGVAirudxPTRknsvuJOYfaeyh5y09JQgjxyYIsmPV+0U2zykDXy8+2+PSvfBZmOEp5z+wYaDQbT700uRxMvzSzXbA4Kbye6PryqFSGm5et1yozKm+Xmm8m7XNCFAqzGD+3QAI94rCmpb1sm01h+kFT1n6GTAzAnOmUKj2KC12SoZLXOSluEU//zcvAsP+KCkSioJF49dRc8Ov2Sr2Qw41houIpq5DtDrpyxZw4UnWNiMWG3Phks0ViF/j5S/QBw58ttEjjfFBmREBGH+pqXkyDasbLei9SfkueOZ8QOIhTSb+bMMihHOFDeDllAnc8R+Kbj6KMfXa1CiGSuHMpDy0acCdMYLV75DjL3QdNE98qD0BV/hllPq1WeKU70EQvXNXVuTKUjWcYak5+sJy5tVIXli5uHtuwhddZWj4evPPm3o+KtrtOJHwDLRip7NnkBKPG4fd5NFt62PznMh9//4WQ0s3XhLiRzRW4G3vPTGC1XoYj6XpeLrFdQI7ivXUPCnGlmb6OA12YCqLfSduBa0YqvAH
 lsKObAxk
 /T63m6JDu/CzKwwBEROecAGmzg3Y4LqQcrr5Qv3aM0nToNGCGGFI6dqSGssxwrUB7XlstEYSCYXDwLwSFo/zPHcIC6vKqcxBKdypTa2ArmmfcwWrZK6PicHBnodLdxAm7vxE/7VQCGABM5XKD217YorJQSarbjYcJHmfwt8yWFDyzAmA//w5IbAM8DrOrEJbXyk5WKANU3Gw5aygRfwZWCdn7IIdzDnEqiHgE8NwJBEuxzxpXYSMI/7A/5OuF9QeElNi9zqlvk5dmClaTKlMIu305a4TcnHzLD71UThgmXxwRNYutcB/Efj5Fdv634fo/4u6XnPNWKly5L3GbdS9wnrNQK7ZkZiqAHCQ22gcezJmeqNvOTRXykeBbUHkZeQKI0efk50USL/Rr+jvDtFS5k7bzOi/yka6fbGKw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> The compound_head() function is a hot path. For example, the zap path
> calls it for every leaf page table entry.
>
> Rewrite the helper function in a branchless manner to eliminate the risk
> of CPU branch misprediction.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  include/linux/page-flags.h | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)

LGTM. And it fixed the issue in patch 10.

Reviewed-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f89702e101e8..95ac963b78af 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
>  static __always_inline unsigned long _compound_head(const struct page *page)
>  {
>  	unsigned long info = READ_ONCE(page->compound_info);
> +	unsigned long mask;
> +
> +	if (!compound_info_has_mask()) {
> +		/* Bit 0 encodes PageTail() */
> +		if (info & 1)
> +			return info - 1;
>
> -	/* Bit 0 encodes PageTail() */
> -	if (!(info & 1))
>  		return (unsigned long)page;

Here, info & 1 check now is guarded by compound_info_has_mask(), so the
issue I mentioned in Patch 10 is gone.

> -
> -	/*
> -	 * If compound_info_has_mask() is false, the rest of compound_info is
> -	 * the pointer to the head page.
> -	 */
> -	if (!compound_info_has_mask())
> -		return info - 1;
> +	}


Best Regards,
Yan, Zi

