Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672F5CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 12:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2FB18E0008; Mon, 20 Oct 2025 08:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFAB8E0005; Mon, 20 Oct 2025 08:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE338E0008; Mon, 20 Oct 2025 08:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 863548E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:59:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37D7D840A1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:59:05 +0000 (UTC)
X-FDA: 84018497850.26.1302F4D
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by imf18.hostedemail.com (Postfix) with ESMTP id 606511C000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:59:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kIsml1s2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760965142; a=rsa-sha256;
	cv=pass;
	b=E1lakDzkx0gHkrwLQtS4bUcC0G1P26J6708CMN92/LJVkKHDXXcQ77F3+nR7qV81JZUIdv
	2KPn3w4RVsICgRirjGL6q/HxCNTBqNjLJqpIfjvgLaUgHPfiyFjLeJVelwjP2a71dFaq/H
	fV1oGBlZopdaRwyxS9RW2owpYgnISfA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kIsml1s2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rf0UBcLbZFSmoF8U8kOnAf6CfMA+jmgLMu6dYhb8bTo=;
	b=HDgNah8gZEa4ZR9QFZywk+GaLVSvCLFEg0WplxDSRjqsdhkxZ2iN9MZ9HEKk3T8qPlqZX8
	EI7f8exo3tDGRwmBh1iGwA2DiqV9ZgD2OuJnCrKzA2foGV8hKWNMHKlJmkwvaQjhZmVgOu
	odDERBKqoNG67kt22KkJf0gXI6XOxw4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ao2fiHnH4UIpu4SLrieABxvUirU+9fSeQMuF9vW8dwaTNgnMatwqid3fFDp9IH4CVbW5xQYjjDIMvBNFbv/lp63voVyP59emByyLPYyctc371tHtSwCwobkFMY2NYL7DEZIqEClJ5TceQlppdsV3c8Vi2aNsvTA4M7M7o2/g7pGLcXttWwX6GZtOthNZuRPAYoSLhnEhSpy1gA85u/CAzVobcr7HIuux+sVWkgSRGg7QUvYMPxYzP4uV7L+hCZ7yYgA/4RxTMSBTxJKiANtf/rV2LjIeRNrHo9VfILclDhug5tWPDDFExK4OWHPfTJBlHwjd35F7YanHg75dBtf2vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rf0UBcLbZFSmoF8U8kOnAf6CfMA+jmgLMu6dYhb8bTo=;
 b=m9zGx9loLYjptsa/2bI1FqefEX8lqhgwna8el9QinR+SYQAyxhrqtmCTpvNpG6cctR6aWfcghDsOVqGFYutWWybOHtKkd09oduZ16nM8ygWu2dSRfDhdvRBIuGeXBq6aB5QQs9IZ5LnpNBCZBngEcdqAa3SVcKECnNoPrr1lCX5ZzxG7wJK+7j7zNFTkarR7zAB+baBzUJwLTs34LJFFRSJQpHMXIDbBStfw5vJV5WTkS3gvhtcK6lxYwSeR7YWcMu7rh61bF/qZ98nvdWmZbprb/W7H2pQ9CoaskpGBXJs7bHKyWn1VXPGJFuN2OA9KRM0R7sqZHphUgpGMluB1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rf0UBcLbZFSmoF8U8kOnAf6CfMA+jmgLMu6dYhb8bTo=;
 b=kIsml1s2tnxG5wNrKa8SjYI0m1ahsKcjxZLrUKyyX8HoFNGZoty9TekR/OsNCkY0Ek6X3xP2AR0XoMoY8bi1fHRZnrbtkLGkad+IEmRQWRF47v6RbcIhxVRygkj9V/y3OVAG4e/Cwd7bzPYjn2MTakXfINszCsnj0MglGDvolCfb8aJvsrCfH1I0iv4Te79KH+cUk172avQmaiCDUTcrcdxdB9BBD/2Ml3KJ7Ymiik31FRZhwySvlW05TIpr7PBXw7MIo0KjltpRcLdcxdiCj3p9ei/EwPd68E5IfHXv8WRWU4b6PIwkS6hSDu1zu11Q5PgH8ovrLQ7lHMi+pRL3aA==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH7PR12MB7140.namprd12.prod.outlook.com (2603:10b6:510:200::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Mon, 20 Oct
 2025 12:58:57 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 12:58:57 +0000
Date: Mon, 20 Oct 2025 09:58:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <20251020125854.GL316284@nvidia.com>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
 <aPYqliGwJTcZznSX@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPYqliGwJTcZznSX@infradead.org>
X-ClientProxiedBy: SJ0PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::7) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH7PR12MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: e45e0766-45b0-4e88-f356-08de0fd86e30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B5wkBlO7PP6mnXabWyoiam5nRETb0OiwpQ/PuFye6UsEqL+/PwfIJEG82sga?=
 =?us-ascii?Q?WBTWOZHHnWXfjRqTJTy87zHwgO83QHW0pkz23TlKzwKX/4Wq1eX4TjPUVGn3?=
 =?us-ascii?Q?J2zQIch3eWVrGuEu6z0UaZT9Jv45sE2WiaysuxHs+29JnvRe6C1mzPeeeHep?=
 =?us-ascii?Q?bxtmCzh8VJxW41yGyotzWoJXUNEVSQh9oIjHEjufOtuUCh0sKNwaX6vyivVq?=
 =?us-ascii?Q?HxdlqbV1Loka9QAIJiF0FyNRjDAwA+V7UdDzFSjqaMVfqkddb6XatQmkpYe7?=
 =?us-ascii?Q?+Rp+qAna/B6yJ36qXOpqKJIMMx6ws/ijVIU7K35wKDyMDOmDraz5r9XrCfjF?=
 =?us-ascii?Q?ir71rTIX7Ss0eyXuZ8Tx8G42YQDhaydk3I2oX92lb4PPVKXGz8tAh7oFbbI9?=
 =?us-ascii?Q?ZilRin+xkeLk2khOUgA+1ajSh987HTgr2cbHYbtD51YFzrSdJmFkbqDxTq4n?=
 =?us-ascii?Q?gB0M/aaJuxnykLsSipQhHVGZ+/YUYu5w3DdXy6KjF1MA3jZ0e8hfGf/YnO7l?=
 =?us-ascii?Q?b2hqKrxS8fvhA27i86d5Mm2a9QhOY0JVgghXH4Mp8JK0P9kp6eoLC7pQloKT?=
 =?us-ascii?Q?1b9H7kjLkPXpkgmQWk0uAGpDDOMwhSRmEHsfP1R0mUP+gllcyA+z/6N8eOQD?=
 =?us-ascii?Q?1I0QZxhKu0ARA4QVMLNtBcFQRT2N/aqmta2pKWZrnfkaBScJcGCUV6qmkIh4?=
 =?us-ascii?Q?DJpD4lhzRGpPaHdXx3FzO/keDiO3E3MmswQVttBN9RiNSFPOP7Z4xxGuEd0q?=
 =?us-ascii?Q?in7QLlN9/6O3zZj97s8pbuHJaIdhYyl1xsoC3YQFPZOEhQiniAlYIwHKHKBZ?=
 =?us-ascii?Q?3uLHKUi9QHfU+JjhF/iyPkxsa5z/u0TAfU3/rPKv+TL5LDgytB9CmapUe+Bv?=
 =?us-ascii?Q?Om+M6X3oSDHV9D2ktj6ZSCGnCQR2iWLyhYerR/qy9DaH5tc+JCBWyl2FL67F?=
 =?us-ascii?Q?sEFaunrn7vsw8NaKPFwJsU5j1g6YE6qRTOYCXMlzMiFMGx3C1prhxvxq04eg?=
 =?us-ascii?Q?AnoFbAst2B+L34la0IqFuvreqOYRz/jJx1fTp811DuJ9Bv1hFgbkKS3qo3u/?=
 =?us-ascii?Q?dG2qX2z298fIBmAjSLrV8fXakX2WOEIzmxehA0TjS8txSuUZjJdaR4iCa3tI?=
 =?us-ascii?Q?Lyf8A+72i09DNZnQWsGtpQsROSalMDWWImYeg+Ag6ucRukQ+YxgSM+rZRv+s?=
 =?us-ascii?Q?19MFv+qXAnz20sbEn/y7E6sdr1l9HnWl5X4aW0ydkdrY9ZC9usJFoPu7gr8U?=
 =?us-ascii?Q?v/G+EhW3flqSDqdPRtODGfsm+mRZeEafeRg0NERbGTzhU/EKu3/g5/PQvnIR?=
 =?us-ascii?Q?44wtFm5D7sBSWCfHuMaGpB2kJOXGD2XtCtC4yCtUQ9mGoRBXrirKaO2SzlB8?=
 =?us-ascii?Q?lsI0F/v+d4ukYl7bhaf5qUbRgp0tl1H39g6bHyFVZa3Vy3QyFiWHVa4qDhB5?=
 =?us-ascii?Q?tBchmWcXVDnPYbWKf0zuh5HHwPzhYOmvLscfcaKj7tnaiG2ksGWhAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oFzvBE+Thzn7tqre6tph9VAenXbQCsV2nQ3MJqZ+8t/QQBKipvMzEs5ILnhH?=
 =?us-ascii?Q?x0fgJDB5QZYBe3es4HNs1Iptu1X6bi6rfaBoeDIjGfi/Tbs7n+SWsDUisjMn?=
 =?us-ascii?Q?ZfcCNQwHEJN/raUbFMNQbyDEST5G7s7yUi+Muy/Lvzi/D5TpqULTLNiw7gz3?=
 =?us-ascii?Q?SWpOv6dbn/xsFtO3rwtFqocA4kdAjxcpS5GNyggmg3D2R0jclK0cjey8MA3s?=
 =?us-ascii?Q?C2jXRLfxnaREly2Pu+n4Dxpu6rmvRW/7QrVS1LEZgxJu+l0iJGsuZpgp5JZE?=
 =?us-ascii?Q?DM08ZclX6miqgRgPArM0YGRbfFrU3SA2Tj18dM306/PXJOkh789x4RQ189dQ?=
 =?us-ascii?Q?/LC2weYBYSlbjATK4vbUxyO2e9tZRqngwxVU8d8oy93qzOyd3l1AQcqroWSb?=
 =?us-ascii?Q?YX3+x5iC/a/4W5w9Af4g6McDRPPRAN6WtKsVX/IVyg+8fhKJ9x1/BsRQmhTo?=
 =?us-ascii?Q?kY1tc2HtcAjyTKNvmSfW29jmiEq0nB9wmO2r2iisTfG9M+n76JEMXctdX2mg?=
 =?us-ascii?Q?TaNNwxaOcTfzZhxnSR5i0NMwNuP/9Jx+kbWyGC+n83WVKMZfR5ag8GN94G3n?=
 =?us-ascii?Q?I18F2LxN2dk8DWhoiGy5+1Rc3mipgo0E2yL/EDibEUB5KEWrqIb302PHfkBk?=
 =?us-ascii?Q?QK/i7npSr27sWvW4BxVhz888ihg94bBUS7qvvk185oBh2S4JSdwcPSwRnF9x?=
 =?us-ascii?Q?sSIYJlRbWkjlO++2GIXSkmC936oykEbMD98hNdAIhK1rPuCqj/TcpJ/oPux0?=
 =?us-ascii?Q?7SihnxpQGbb0HkqGwaVCSemhYpmGGnsN0fPYKj0CZGJZpBegLSejFFg/MP2/?=
 =?us-ascii?Q?rAqQ91aQAgt8J+TBVLXhvjlu0TAFEnddq/tyrZz9JffeLxACArHOijHps/i+?=
 =?us-ascii?Q?cvsRzZx3eq5uiM6ybbs6nlKKk+s0QlsFOCNauaLztP6GLy8E/pidffFJ6jFp?=
 =?us-ascii?Q?1LNJ/sEB3NeZFc/xw4CiL6qvWH/BjDzDnuvPzLhjtobxVm14TvWjfyTDapZ4?=
 =?us-ascii?Q?/hstubZ/dY9l8mS8nA7yLENSxS1jsRF/X0uBQ8CXjkVm7hAF2yqqaFr8S5vi?=
 =?us-ascii?Q?igy0kydpfF7XrBETmjSWsJepKW6ytqX8FvQXJOY8S8rafW2i4SWyBwOix6hN?=
 =?us-ascii?Q?fHOZ7jT5YVel/z4mL4BrODEhS+Rl7iwbN6+EnqHTnI3RkJMDOjJWG69N/DZJ?=
 =?us-ascii?Q?Pr2KT2jFQMMhfZS3n4HORGB+8ia9u+yusIkAo8ppl/EnSGITf5UzoQ+btLbx?=
 =?us-ascii?Q?lmPyy6Kz8gVidA5KjsinXRPufxcd2ZIuKdA3L67hbAZGIyHzFx5cDFo5js3R?=
 =?us-ascii?Q?oS0zzVAmwgWJ74pYX333pgfd0esQnqeCd5Tj8ifXWW7esDlEcxDwrhg2MkeQ?=
 =?us-ascii?Q?0S2oYQmtRBMfu9WtEkCNQfyr4g4z0HMnHdNJfEwyR0ZdMRepb/5/OLEBQfSz?=
 =?us-ascii?Q?YqZoJxfSFkxp5itn37VQGIMwnCKeJdvutE1Ugm+zxtcgmma426eR8VVCVoe3?=
 =?us-ascii?Q?pqFhBzjrGKkNT4E7/frrv5i5Ch4AyQIQGI2nOeVA7wQFJlEsSfJsiybR7bJL?=
 =?us-ascii?Q?Cg9+wH0Al0hyp9RSYPTX9mzsTHCpn5HgHBEWnh5E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45e0766-45b0-4e88-f356-08de0fd86e30
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 12:58:57.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6IvifmM36NWUvw3j2l0HU8F/2j6c6tOsNhOyk3ml+UB0qvEngjpM9b/gAeDrRr1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7140
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 606511C000A
X-Stat-Signature: 4f546bqhtmeb46ggtfmj5f3e6pgh93y6
X-HE-Tag: 1760965142-516350
X-HE-Meta: U2FsdGVkX1/gksqTcBENqwO5oc9CdbF+7CW5Hh4gELlkbuRCLadhLaYKZ5Dfk9EDMTnzNGbekQotjELaw4bqGe1OmnA85kzR6sDyZwVOGaR7V4oJJ5o3yY3fPJOJmq8EN5PxLLsxHT3vlUwQKXg9M2wrXGRatXCeji83eJ2oKNtfAoZG5YKFqPyHo9XQs5DBdBL1TYoFkMcrAD22J08HwzVHwpf4UrJn7QmlBNl4wdVmt94gOpSYJE95Kmbpuhwh58XDkMF6PH6VDrIhWaUPXt89+VuLMaPAZWOMZi9q5OPicG9wuNG5JbA2NOoLUcHh7nqsk3rkFujo7ogxg0v69KQkcfjTskYfNUZsW3mJgcbwQ+/iPRD9aRQVJ2sVmUPXbcUtzEjomtXnjdt2LzRBYwaflX3XWHGRs4WxvfgnQHFl8wa9Gj+y49s/N4DAQ6tYjqsRbYz/+1dAgAz62PXN8tOZWGG5/NFwXPrJ8VH9Th5DKCWqUAWo37vpHfI7r9GtqUW2/kxzhMgjEwwMg9JRQp/6dkmW/hk/VHPJ354Xa9p+NA/9n5CJqdYCtdkQPZ411FFot3TzRx9K54mTc1VNZ1To07gCiWNx3CCTypdQlCrNTylHpLwa9w37i+SAl9jJgtnL7HDicNijSYhPgPYDjikSE4DKX+/aeTSTsYnkCn7S/E5rg8pJYzcvYotCva5PhDhMm0IIQ0nDicndbN1YX1KuNJ+RJ71bjlPAYhw+G5ZR+WGJSdtzUnsExuZNPQSgNZELWTwy1eelo4/4+F3RGSDVloMBYy7gECxD1d3CgzI5gByRNKpbnLk6sai6uJzkwzJPmahhW77hjlSBDRt7lEVzRfq5sAtbqDaINo19CIL/h1qsfSzA3yPIUfk3HSNjpaXvcgQkWFv+bgPBLVkQ/t1ueDuKSLJQHZMGwqnJTDZI86WE2WzXGxJt6ha6/7OHj6mQiYV+qMlq/LZTb84
 YuVIOCs9
 /hMlJDt1rU0pOj+5VTNjAMCQAnHmsPoLy9LNcgOG24BOqC9blHL2aVL9QtNmxnUJm2smLwoJD1nwnU9YkUKMQEOB0dxIB8IAk+oiRK+vlMtOuT1zdffuXwTIOvNtRURG+GsE9S1dWnQVGGXFuh4Nsb3KvDO74exRsRarWFN7Xd31qsLpfjgz2sDnm4oJQkiGYV84Wn/BN3c2imBRjOYCn0BqG+nzDWT1o4DreIlk2EsChgBVMWZUJjnixCeRZFOqUnvI8vnx+paUof8hay/FTwcyJ6ynAalYX3o4BQjn3y/hQB4m+JpZMw5SXRR64F/hUhhjOPhQa6nGksNisZ57GysLvpkMdN5hXpprFBvgGSRGJjrS8r0GIgwYPwNiJtiaZPR5Eid2BKlef2GNsMbmBT8vi7NTjqBNv9WTwHhWmOrdttly486bo9SzfjLPs+vtrV7l/Ki4cLewuOyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:27:02AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 17, 2025 at 08:53:20AM -0300, Jason Gunthorpe wrote:
> > On Thu, Oct 16, 2025 at 11:30:06PM -0700, Christoph Hellwig wrote:
> > > On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> > > > The DMA API now has a new flow, and has gained phys_addr_t support, so
> > > > it no longer needs struct pages to perform P2P mapping.
> > > 
> > > That's news to me.  All the pci_p2pdma_map_state machinery is still
> > > based on pgmaps and thus pages.
> > 
> > We had this discussion already three months ago:
> > 
> > https://lore.kernel.org/all/20250729131502.GJ36037@nvidia.com/
> > 
> > These couple patches make the core pci_p2pdma_map_state machinery work
> > on struct p2pdma_provider, and pgmap is just one way to get a
> > p2pdma_provider *
> > 
> > The struct page paths through pgmap go page->pgmap->mem to get
> > p2pdma_provider.
> > 
> > The non-struct page paths just have a p2pdma_provider * without a
> > pgmap. In this series VFIO uses
> > 
> > +	*provider = pcim_p2pdma_provider(pdev, bar);
> > 
> > To get the provider for a specific BAR.
> 
> And what protects that life time?  I've not seen anyone actually
> building the proper lifetime management.  And if someone did the patches
> need to clearly point to that.

It is this series!

The above API gives a lifetime that is driver bound. The calling
driver must ensure it stops using provider and stops doing DMA with it
before remove() completes.

This VFIO series does that through the move_notify callchain I showed
in the previous email. This callchain is always triggered before
remove() of the VFIO PCI driver is completed.

> > I think I've answered this three times now - for DMABUF the DMABUF
> > invalidation scheme is used to control the lifetime and no DMA mapping
> > outlives the provider, and the provider doesn't outlive the driver.
> 
> How?

I explained it in detail in the message you are repling to. If
something is not clear can you please be more specific??

Is it the mmap in VFIO perhaps that is causing these questions?

VFIO uses a PFNMAP VMA, so you can't pin_user_page() it. It uses
unmap_mapping_range() during its remove() path to get rid of the VMA
PTEs.

The DMA activity doesn't use the mmap *at all*. It isn't like NVMe
which relies on the ZONE_DEVICE pages and VMAs to link drivers
togther.

Instead the DMABUF FD is used to pass the MMIO pages between VFIO and
another driver. DMABUF has a built in invalidation mechanism that VFIO
triggers before remove(). The invalidation removes access from the
other driver.

This is different than NVMe which has no invalidation. NVMe does
unmap_mapping_range() on the VMA and waits for all the short lived
pgmap references to clear. We don't need anything like that because
DMABUF invalidation is synchronous.

The full picture for VFIO is something like:

[startup]
  MMIO is acquired from the pci_resource
  p2p_providers are setup

[runtime]
  MMIO is mapped into PFNMAP VMAs
  MMIO is linked to a DMABUF FD
  DMABUF FD gets DMA mapped using the p2p_provider

[unplug]
  unmap_mapping_range() is called so all VMAs are emptied out and the
  fault handler prevents new PTEs 
    ** No access to the MMIO through VMAs is possible**

  vfio_pci_dma_buf_cleanup() is called which prevents new DMABUF
  mappings from starting, and does dma_buf_move_notify() on all the
  open DMABUF FDs to invalidate other drivers. Other drivers stop
  doing DMA and we need to free the IOVA from the IOMMU/etc.
    ** No DMA access from other drivers is possible now**

  Any still open DMABUF FD will fail inside VFIO immediately due to
  the priv->revoked checks.
    **No code touches the p2p_provider anymore**

  The p2p_provider is destroyed by devm.

> > Obviously you cannot use the new p2provider mechanism without some
> > kind of protection against use after hot unplug, but it doesn't have
> > to be struct page based.
> 
> And how does this interact with everyone else expecting pgmap based
> lifetime management.

They continue to use pgmap and nothing changes for them.

The pgmap path always waited until nothing was using the pgmap and
thus provider before allowing device driver remove() to complete.

The refactoring doesn't change the lifecycle model, it just provides
entry points to access the driver bound lifetime model directly
instead of being forced to use pgmap.

Leon, can you add some remarks to the comments about what the rules
are to call pcim_p2pdma_provider() ?

Jason

