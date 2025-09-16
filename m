Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89565CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2278E000C; Tue, 16 Sep 2025 13:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79298E0001; Tue, 16 Sep 2025 13:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68938E000C; Tue, 16 Sep 2025 13:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7E288E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:30:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D10A1A02BC
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:30:44 +0000 (UTC)
X-FDA: 83895803208.28.0476F61
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6C8880014
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:30:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fLXHGS37;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758043841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGvF3uE0NRf5Vl3qX8UIfBj6yWhD93uUo5GAySOaYOI=;
	b=z1+oXYfqlWBwzh+sWeGlE8uS3DSzzwK3O4ikjHUKufSj/z3MmMYr7oB3qbWbbZTfcoIYX7
	02xtArCFRucQMTFlRlVdmfJT6rAJHYEPnJUAHkgu7c2l08EohtenS3g5g8qZiodVL9xeN/
	6vz4I/sIWjGizy9utg+1p2aWEns/pyk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758043841; a=rsa-sha256;
	cv=pass;
	b=ThV1zVTMyrs4JTZwBS2MmzdgnxcZ/2gE9bFPBAPYjDL64Q/hq1Lw5VB2ktIZdQhtyrnoiP
	CB8SH0tktsZApjFuhtwL4ycGLOzu+DRaJ6DKr2l+yp5jgcuwZMtH0RgnesoD94Y/GP14R9
	MOxCP0VlydV8aqGPdnchmi2o9rTDddc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fLXHGS37;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKswpc5RsVybVYjeG/ENteaOmkKEU4LhNjeImbfDiUo6dg7rktJsZhm8XhhPWgXOJnP4dkjpFtrhICm77oYeWSmW6+4taBZfcZctoo4kmxj2v+0AEymY/yKXl/WwMmMFb1Y1ISWx87N+1s5mSuAjxJNYc3G7lQ74mE+Om3C0jySceQ5DF6UyEudnVbERt56LyGaN+b1/7DbzeTVP9RiFc4GHSG+jBHDBcRjMGTyBLdgdjmlWfprUzN3+sSTmnOWXulXVxdF7QYggusm9pnZb2gPtVFiLyPTJOoHryBMXUXJIbe9TcSY2f0isS31HGmBilqodoqwOjZGFea0ZpcpQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGvF3uE0NRf5Vl3qX8UIfBj6yWhD93uUo5GAySOaYOI=;
 b=f7Wu/9WIldYlPZUH7KedSfDxplETFyqWEUlyX31LACcM3b1BMldZuDbTZ6gg23QMZhp9Eg6rTkj0oCzojgQuaBn/cy9rg0luovbhOaxcVdhwpgwhHhehgPUyRo0rIpmrl4my76JzdZ+ZcWaGV8AgIvO1QQYO/leqOtMO85kT4WHKKAd8+35QiF29QJlP4gCrDfDP9rf+CY8gynTZ70W0mxnnL4LtSPSo2CNjuxyvtSKCD+lzoYoyog0Jseu2O0VMCu3J+wGti8SzDqTAzxWLZuMRXKjBouYqB7jj5Iyc9QbpAsw6N0yowTvhRGNOYhOhp/B/k2v4EaOqxuYKBZr4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGvF3uE0NRf5Vl3qX8UIfBj6yWhD93uUo5GAySOaYOI=;
 b=fLXHGS37uUJlq6zK0mx5U6ii7aipCJQuFXnvnRhL2qcquwGW+ImEbCV3RDk5U6uxqgKJu1uMm3L0Dihc9ra21VcBieM94CEBHGCAhDwXW/tkVqjoYpQ5rG8ZjszAWVCsmkufAhZonVk/VOYKiAd/jhuX8wNYpr+Qo7MCFS6nrNOTmXUm7XcxcHysLfZ5DBGtpotnyH44UDdjxck1EnC/bWOklhVH6vujD8Cax/K3DL8pEWyxf6rGJv/kxOZnAJCGIVazGXhLUykSxCYNlwLTzyz/bj3M15h8TPozul1oOU3lAGyJNET8SPIZFSWymjH617OnyWHJ2+8yKf4SheNtwA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY8PR12MB7268.namprd12.prod.outlook.com (2603:10b6:930:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 17:30:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 17:30:36 +0000
Date: Tue, 16 Sep 2025 14:30:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	ntfs3@lists.linux.dev, kexec@lists.infradead.org,
	kasan-dev@googlegroups.com, iommu@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v3 10/13] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-ID: <20250916173034.GR1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <8b191ab11c02ada286f19150e5ec3d8eae4fe7e7.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b191ab11c02ada286f19150e5ec3d8eae4fe7e7.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SA1P222CA0054.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::29) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY8PR12MB7268:EE_
X-MS-Office365-Filtering-Correlation-Id: b32c7160-bdfd-4eb6-cca8-08ddf546bf05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q8+hBhREbfIvmN6GWbtwSSzQjwRq8vhs+psMzzmJ4wR/j4NRyiDVbcSSRS/x?=
 =?us-ascii?Q?OBfOiK1AGP6kgKi+QnPlfA794E023NQItp7hJFteWhxlS7GrtDAAaFKCESUZ?=
 =?us-ascii?Q?F9s5ozVOE37sknBowV8ZjBHB9ERrXJG/jxGlhGs08bOknqXAHM/mDCCJG5o8?=
 =?us-ascii?Q?49aNKSiCzCJZ8HzSPiuwhdkmT0Rbo2Q9jYHR0fx1YObFyR5G8UxS+SI16YNm?=
 =?us-ascii?Q?xifAqr7yfKYhCGZwgYeFzMTY+prOpdAJWDu4sho62pxUATy6JTV1yG66uxUy?=
 =?us-ascii?Q?aOoQqGVK6uHZ6O2HBtQ9s+feEvUC85eR76vFDflYGIgQbU9R/H/nADLiSzGC?=
 =?us-ascii?Q?8tr4SvzwRVKNL1+3p8q9EagXzWiIITv7nP155lGIAr3bQ8ecsnvC4vQZqrWb?=
 =?us-ascii?Q?T7Y0876bJChAaCzJvkHdVuMAYKp3j02g1Tb3Nc/wgFOSfiO6u/ZOqDmwxh9U?=
 =?us-ascii?Q?RiRX7ek99cpRMt8tZ5dfI1e9CdeYl2pqNVfpK8AEhOIqbk4H3EnU4vI7dfVt?=
 =?us-ascii?Q?XiucRg2iGLUbiVgTcXCtxOahm5OxeBlopmSY1DBjZi4yUFkptNX5vhkXnpiF?=
 =?us-ascii?Q?0PdFcrejz4oPkUzy7UMF2wS3djHDyVUBKnuCckPwstIFC2qqsMNlilYhXjJa?=
 =?us-ascii?Q?lf6u62s0ftZmCLM5bA8amC+xRhT6Bz2qRymMFJpe8xw7bkeZ6/kJQj4uN9xc?=
 =?us-ascii?Q?bWGnJSL5KMPRGGF17B/80jR5Y92rdGga+J0DWY5yfLdIImuoNlD026wAKTIc?=
 =?us-ascii?Q?lQMdy7AwwqbWtGnoRWkbodHSCiKiK55OBV/lOxVSrRmrDuVh9JkQua5JKtAo?=
 =?us-ascii?Q?x5mG2ZRvHVmm9XTxA2/xwH7GJ/XvYRMzq1o56acW+zvQZRNpIKQ91IFip/G8?=
 =?us-ascii?Q?+TpYdowkDj2pE0FxFyb/8MwpzaloPpEVmCxwE2/Ac+eLzbwwfWaeqMeOlS0R?=
 =?us-ascii?Q?t6kjtrV42pK0TjabwAs5/iEXOS/epRdQj2G20Jr4K9i7E4OgFTgHDXpgX2x6?=
 =?us-ascii?Q?Hu1nldUAdubV/jK17G/MiMGoylU4SMuq2UIW1Ai4LK6OwgI7xFv7zmG/WTdZ?=
 =?us-ascii?Q?rQVIGqpYF5GKBhZ3Pv/dfyBEdlyNPmzQ8ZHbfSEzuxQAOjmznoAO2l3ihnWY?=
 =?us-ascii?Q?eB2A99ZxhLPwxlWjTwQYRgyMYAAX+nLcdyfoFwPYG+C4PmVmC0uiSJCRjjgf?=
 =?us-ascii?Q?YU4wan4nxD24WKhoU+4uIctHM8x/rUq/fjJIoncdKQVOUFR21qBzl+sunbXT?=
 =?us-ascii?Q?wrP4DI5D78c0bX1cNGrhcGQgHazlRjyCSyTfMphO5klD5A4Uh3RuwxjVV6gQ?=
 =?us-ascii?Q?Bw9MtyWzUPVtkThYTFHguiY4iWpqVo5SVtwzS2pQwdrmBW40nan01nyr+sZT?=
 =?us-ascii?Q?73BX79nZF73tRzfPZXnnsbZRPxoa2WZVYTXMrlzTqZ3rG2LqRA8QCVWsbOKo?=
 =?us-ascii?Q?GGMhLQdNPMI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RAO2f3WyaavOY8WChuTXc8BZ6vsgv9gmkj1XEJQedvqYLuY0jr0C1b/URUlp?=
 =?us-ascii?Q?wPpBqb9Ja5QmzoqNHRB8SVP1SkRcI8DX3OJIFA9+vKVF64Xe2xzIy1NJpTRv?=
 =?us-ascii?Q?fL7GO6OYuU5VxYS9m1nGYNd9T1OGsSnkC16qh8MQxlomdD2D+5SRLHsTk8bN?=
 =?us-ascii?Q?4kwy+KNiNfBYQSkPdksdr31hTLY0PVO1BNvInnO9Yqdesq8y5oGwD54lt4fn?=
 =?us-ascii?Q?0MOvN3/cgbPbcSEYaNRirwG6itSvyo8ly4MG1F5aVmqk+BmNDppFQKgi6DE/?=
 =?us-ascii?Q?gShCidgiIbLShUdJMl9QsOm8m27GQ4yg/hwJyb3RHI1KKEiUGrDlmjGNuhWT?=
 =?us-ascii?Q?BV7CRLZizAH8wUkvgztBhVQT2M7YWvMxvB2x+0eQn6su42/symigDw55WNuc?=
 =?us-ascii?Q?UNqXvNYDLvaHlPEMFCFuCdGL2J5vpb//v8nhNCSK7ObwvfuMbR4lmc3lfeHo?=
 =?us-ascii?Q?g6W4P13+h3VhIenV5xlYJsCSosvaKI5dzfldfKVGWRTe6jmIovoKxjmijSOQ?=
 =?us-ascii?Q?BqQIYaTRd9dBsUyYPgyOhGIium5NLjUs4zGjPVxg9q7y9OypgyVFm/VIGgJD?=
 =?us-ascii?Q?6+sGM+keXlgQmslVExAKKsvmW1dBWdEgCCMuPU4zFeCT8RiDYB/yAVWU7mA9?=
 =?us-ascii?Q?0jpWY4Xg3zPDM9Uu77GOU+j4Xp4KGC+kNR4qVj66xgdmgFzRXGSftEl44Ykh?=
 =?us-ascii?Q?jwLsYN4yNeQRsd8hkmS8IfAvQm8riCN1pVOHp20m5dD3Px2dE3WEKqf5kISD?=
 =?us-ascii?Q?cMJsbrQv8LKqRvc+4tKhfxe9tdc2zFpNJxnvBoEj+hjIwzbt1IQ4gyQTzhnc?=
 =?us-ascii?Q?7x80WhGTKgmIbdFcTEHIMDIWcpv8GWTCXAsZiD0c+X638sQLyvEHcD46Muyp?=
 =?us-ascii?Q?iOkFnBuURt1qMiKbkdnCnNHdJPFyBebmxItcvPe9Ha29mqZg2VQPk2GlxTap?=
 =?us-ascii?Q?bA1RPZiLHAG4httGalu55LwWIjGW5U7fB+P5aAOyigrYE0PJjZvK/PteG16z?=
 =?us-ascii?Q?NvJ4TaNQDVo1hu7AVwpUDZH8Z4qt6V0MFBfzj5LJtLsxH4ccrkFW3wQxRLOn?=
 =?us-ascii?Q?Z0FS2kEEftLcwFsRKdIH9V/FDlbSZXvXNqTnn2OTDK2ZxO+wbUmhxS+OlHLF?=
 =?us-ascii?Q?pG0kF251FdCNRRwlCPRhUlUZ9KSm23Con9nmckpIVTGTsoqQrfKxY4oxVA4Q?=
 =?us-ascii?Q?wpQscqsC/LBOOvrFZ8QC5tK1gxDZCeyDZ7rI15xW71nFvvwTLJQowzHMBmH4?=
 =?us-ascii?Q?m8aR4Zs7KbPImUtSgix1q/C6ZAA3LEiuQj5TbV/Y3vpF+hbO1tXPg33mM7E9?=
 =?us-ascii?Q?ci72VQfgZYiBwVKYrztwsWpDRF/zpzJefMT6hOEeD0cz6pRMg2h7/waVrSCC?=
 =?us-ascii?Q?TQTttrWgJuvlPPn2Q6A9ISeMoK3wWj5PbV+T4QZr4dG5LRXK5nsRKYy6MDq2?=
 =?us-ascii?Q?y0yxr6Y8cYXjTfKRphOuY72U+aFa4mQ+uBZbIxjw0/QX99Tx8citbqUXiHAA?=
 =?us-ascii?Q?2hIQo4S3015TNaznwkTK+ByYJntEhycl9gK17tRs8K5wCGYbWdc2yZ5Xg0wG?=
 =?us-ascii?Q?l5gISEiJAovQl5tk/9FBHjAcYuckSW1Bh+g4rohm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32c7160-bdfd-4eb6-cca8-08ddf546bf05
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 17:30:36.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twzIP5pGgX2QiNLXmr6VCgqSrfRueGWZk21rWBja7VVqi7GmuKAS03ltWPfAnW7A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7268
X-Stat-Signature: p1zmbnnpr59ydhat6wif1jod8t3888tg
X-Rspamd-Queue-Id: C6C8880014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758043841-551210
X-HE-Meta: U2FsdGVkX19HfIwfGxgnqO6z9/hFz2oWDChLVxoxmTTR3oPL1fLUOOf/8Vla9LBUSJ6HlsYBwC37Cw4/ODgKdr4kt1bJJ/GdoeB7xSTtm93myj1SojQQdfzrR6XMn+cBTP5VEGAOokchWEX3N//ytW7N1coscTsmOrPPzY2wmel8rA5b4BbRyq3z4yMTZEI1v4yuF5jfz/eLRHSQO07h5MXdaemVN+bsYZmEOLSr1Dv662hJmah8BxzrgFcaH16gyGCgcKvScdaKcwPfryPAMDx50Xizj6AcFo+rMEv4izaQ6Fcz3oM8Su1aujchBlLh9GKYvvbKCxHjx5mtdEltVHvWhywCeRWBrvS8LMpUUJZA3w//2JMDpBequrT6bG/0WLu9vtQFeCIwrdAKpDf/xlM3uW3/qJ4X10jv1xTDhz2c0X0bokWfhsKTrAuiWClqOAiyDE4nRB2pcEKxOAOHhPy1M60fEdQ7cCuOn94KwL+6J6XsN6VyZyQB41dnyvbyYd9DgfL5oYYXHTASive++D+HLT1e9QClf+B4AsWmFobheQviDJwXr7oLMV2ekpd+katlEVmcp1Zs6fHmeE1dQCIgSYjT/Sw3E7412zKAPuDV4n/QIe+xbyq0wQ33BctziHsv+FIJ6pI5PPaWl1BqJQdmMPx7iNXgcnxdO66DLb+Pr0F0r9Pd/91ceAddl22pauxN2RDJdghoGs11RSpUO7awgKQvLVLhrMo1Fml+pj6pc7FeKeDfoRf7icR0XLVEm6nWV6LarUV5768FyJMqEFjqoxXIZeoywxOrYHpeL5meW+o3IJZUTL55QW0eMnLNDJbZvXcPCFM31n2a2vQBM1X1NbtnHuo020atjunZI0cGIeNgjhsmpelcjZc+QixSr4ziQY7sTEOgh/nAlSiUjSuIgnxJ9ccvryOSxXnEAFygHUbw2KaMhC6gH6CKEcOSQv7J4nVIlHN/oThSBQr
 beTRl5pT
 RDtgAXnk0Sd2aHvHWldOe+0lynz3kIUv7OQ8Bp5Zc3V8Z1d0e5cfFoediVwr++w+G8MIilup2T0aM+e6RN0/X0GZ/1I3dJibCt//kp3+Fc04kOEDrEMeAuGB8sPMUuN/Jfep1CaR9Vjb+yUTEkNbpWhjEH7i7iGdtfy+x2gzMzcB7ip+gMHC4bbs3zzDiK3gkaK6LLymEu9ll9dDaum0i5ciquVlij5R4irupm324Yc3CwKtGdGxbvJMiBrUtcYNJl8+CvAYpeAoZR4sD98nEf0qh2olSD1EHihE52oAYJylyC8CtOsAMRbPa1zw/4FrkhXfhyz+3IxKl176sVuIvkxit1Cz1e5HpMrJ6liKdJR4Tl2N+Q1yiY2oODepd89q6Ux1tU/KJRZoCIggKGlS30waQZLeLlIOYdKUPV24yGZkqOJob0WhoFGxPEK4ST2kCw0TGblXAi9SJkYgRf+DOEVwv7CqdEr6TtNAqhF+LrItIjtVNPoidvXeJoM74MHX3Pq6DFVnaC8Y61RtilLwPXI9MCJh2F/WMLzLoz9Z6hrmhOrekxvm4Ut4f8uM/aEFO4gS67t6+/yO283yFNpkGgsBa75BBpcC3yKaI+dUNpUAnlztwfmT4GmmFh0SD7UgNRvvb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:56PM +0100, Lorenzo Stoakes wrote:
> Since we can now perform actions after the VMA is established via
> mmap_prepare, use desc->action_success_hook to set up the hugetlb lock
> once the VMA is setup.
> 
> We also make changes throughout hugetlbfs to make this possible.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  fs/hugetlbfs/inode.c           | 36 ++++++++++------
>  include/linux/hugetlb.h        |  9 +++-
>  include/linux/hugetlb_inline.h | 15 ++++---
>  mm/hugetlb.c                   | 77 ++++++++++++++++++++--------------
>  4 files changed, 85 insertions(+), 52 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

