Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936A6CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003C48E0017; Tue, 16 Sep 2025 14:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7028E0001; Tue, 16 Sep 2025 14:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D704F8E0017; Tue, 16 Sep 2025 14:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C40038E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:09:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 886CA1DDB25
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:09:04 +0000 (UTC)
X-FDA: 83895899808.11.04EABE0
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	by imf01.hostedemail.com (Postfix) with ESMTP id E313340003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:09:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XcLrphLJ;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.57.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJbs56PiGkpOK5+9sKNM0bbDf5X9UPIzyxQBTUs+5vQ=;
	b=LyAvNJgn+sHHs6N6BrBmtdSuvdog2TCAdpaK1ZZ4IkX5gybqziSrLbG6+XghVGdj2Zya5W
	pM1N8BHLLOQu1iMGr3uigsrDBjrzdfj2I3n8mPGyDUUHHnvIwpgeZpqD3Ia1RlPSU8pZ86
	HhkdwjFHGUPp2n15lnPG4cblj903cNY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XcLrphLJ;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 52.101.57.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758046142; a=rsa-sha256;
	cv=pass;
	b=T1LJ9R0VrEZF5IBEOUOaahTL7dbdCZPvV9DZXcblS1O6uLlsUlK/KDBuGVG+eQDRd4ZBfU
	T/Hd9Aj3yIoJJizFjECtU8D0L/xq5v1LkzJIvI+lkAnW2uDdb0K2aVmFqk4prd2jsFRZUw
	b0Kmu6eJ7wDUQH6EGTrAK6bOHRkFpIg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tflhO0OiPrmJ8aMsBbcPA0WTkLVCrmPIzg70jmrggAOc7ixsXN1H79Zby6C6caajXXxydrZUwFsi2G3ZlbYT2/fCcdxuzJlqN/9Ar09pLlGBAWR4xflig4AWlVj9nn8B3c3wakU6M7/IczQB4DQrYxxoMn+DqENUQRix1iAUyMS87zA0LhnZJlXTiBM654Xme5WADjG10jVtDdfecsTdK/lGfc4syQMMz+GNTiLwk3wdOVKDnMQ1BEczAa+0ZGdn3ZWHdC/KudPQXkv/EvpcTgKQO1t5CAH0N7dCz43z0ndxRjLXtYBnluFuY6cASubpXf23GTVVlSyEhYxO+7BXWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJbs56PiGkpOK5+9sKNM0bbDf5X9UPIzyxQBTUs+5vQ=;
 b=nemgzA1Il3kTAcy2Vcd7NRN3eUxlzamFAdNOh4MyFQ7IaMNirETb3Bp8CKCDA5ywv2je/7pcmR5caoKDQWpustMnK/9gRKQp/xnZUG0kTnLk7MiqFK/Ab7cMkUTB+hknku0SZL4RrZBVH6AYktqTQ77fHwWcmx2dxNEumd8awlublT8K94xga0BPLZlWaOjr+yqilz7qSGhm6woH0cKtmv3wyOk+BclfNilwvzvfLrxKtHmhRExlhHSEI657goo0o0hpYJljRFjnw+wzGCztQgTTyvief1TeoRbxWiGNc6ztsysDG7MgmY6yBjQrcgZuoCyXW3a3gwoW+ZzdW8ofXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJbs56PiGkpOK5+9sKNM0bbDf5X9UPIzyxQBTUs+5vQ=;
 b=XcLrphLJvoJqU3u99yzvV6gYUw37wEDxumTEWB4J4xqaj6nJwxWd/Gzx2kWelpyVjVuosmgTzJgpDrrT+hcNuGDPyzdoWqwXHDN1Odt/Yb8EbutaL/2JfiG1MqKRMSH3XPwtvbUPNXE2PAbooOfUD6Ur9QFQs6Iaj3NA8DGQQqWT7MYSATAFrsw6djG8jaSBR0KWnR97z2zDyD+ixAuIV/fArxsaZnITb/MyF1/zkCREwF8rK4BWnSOFyTLzLCEdHcNHCFtUhqOp04mju50NO6qeAQTGTvp5ybAEvkv2pKYdk40WO6HnyXx840JelwZRLOW0Br7l8PyKTZUXzqccHA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CY5PR12MB6084.namprd12.prod.outlook.com (2603:10b6:930:28::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 18:08:56 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 18:08:56 +0000
Date: Tue, 16 Sep 2025 15:08:54 -0300
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
Subject: Re: [PATCH v3 08/13] mm: add ability to take further action in
 vm_area_desc
Message-ID: <20250916180854.GV1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <9171f81e64fcb94243703aa9a7da822b5f2ff302.1758031792.git.lorenzo.stoakes@oracle.com>
 <20250916172836.GQ1086830@nvidia.com>
 <1d78a0f4-5057-4c68-94d0-6e07cedf3ae7@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d78a0f4-5057-4c68-94d0-6e07cedf3ae7@lucifer.local>
X-ClientProxiedBy: SA9P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::29) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CY5PR12MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 9843905b-7372-4f4d-b237-08ddf54c1a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zqe+j0H1PrmLyeCv47EBElzx653DxjCOGJmwCdrFPwi+DieR4O6tT3K+e2yl?=
 =?us-ascii?Q?whIJUVhK8ngLNfnGreVGUj4ZRyve5EIuBQEfMm/FXCNc78NF2HDsY+B8MRGK?=
 =?us-ascii?Q?pU5GzlmvvTFjGZ5A24d/Y8cItddSR/zHjJ20vVCbNzNQHRC9F1kr209KBgw5?=
 =?us-ascii?Q?8V5WlMU7w8cZl3UFpmkWHWh3490Wu3AC1L/ek9rpjgGot7Qox7/qDNLKr+rv?=
 =?us-ascii?Q?hZi6tcfRx77n1QpIM+laOAj0B45gHK5sgbZ232so/AOQZkGy3DYvxuvDoeW7?=
 =?us-ascii?Q?LyM42S3XRKHUIEV4QiVo5hYagbrPoEMbvFfGw2f5r3rx6Kps0K/jCeS2zHkj?=
 =?us-ascii?Q?qy3OA5oI/7PX0fiYoeo5ZA53aL3q6RWUcq8qQ7r/huwXOSaMCrWxUMcj8reV?=
 =?us-ascii?Q?9WFTe7ne0Lb71dKPjYDjoGv7ByOlEeFMGwjLs8eCohXdn9tb3LM/63XjdjY0?=
 =?us-ascii?Q?PEgnk6XYEouMgaC0j8JWJd9dOYf5XRxMBFmcIPw3e3JFGC5dkEIeLa30tH71?=
 =?us-ascii?Q?b9HffoQdA2qucrE/JgFSbw+0hgfx3FG32vaTu8CNMcTxY0HHS4XYMtIwXsg9?=
 =?us-ascii?Q?auYBp1gV53qIQl2lq3VKA3CCRhhfibvKQ8Fp+U5BhvYC7z0birQrFBCRJp4Z?=
 =?us-ascii?Q?AUgYNVnzsGbqStVLtvLcQAyMyFGcVstr1cfk+YqC3U1iXBtis9knEtIijVdt?=
 =?us-ascii?Q?MHsm/vD3MAR8uTQhSLJSMi4uxx2n4Y5GqmCqqA9swl8nAm/qfRbV/KzkzcOM?=
 =?us-ascii?Q?5LT4sjpudWdUMBCaJvIvfvTtZ5VivnpdCQAf1WhVSeGtMnAe1sGSQcMuI6Gr?=
 =?us-ascii?Q?qNVwz7fvNG4gvsYIu13pDU9qoESHyeirP+IiZ0A/qwstv1KaqvUYCnueyhgB?=
 =?us-ascii?Q?rVXoDMoI1fczBLs6OY0LmDBeV0XpG0NPsFr1sHcJ5gPj9mD9T8JRWMoP2c30?=
 =?us-ascii?Q?5qredbfvVNs05QToAaF1t2RzWKdAf+/5beuwG5Q75CpbuWcGY1KkHL0P9sZX?=
 =?us-ascii?Q?OHqEAxaTQWO5xUmNzxQ8KPKw53JhUo7tBtDByXjkx37SzRWbZAzkF3Tspu38?=
 =?us-ascii?Q?fnXVy/G58B1da2xcVVTlRrbHbPh/GJXAYZBsMjEa1Rv07GHHpJ5rs87kVWhm?=
 =?us-ascii?Q?fKO1bQyDnuv1rOnddPdfYzPnUWMFuliclrjd+7GHkYQxNLWdAW+WRZFOZj6J?=
 =?us-ascii?Q?goz/+d934SqE0XgRO0S2pfp/zhTFJGAjacROszevUblf2SQr7LAhbHfBbgw0?=
 =?us-ascii?Q?Xosb6DVh2N0uf02tgJtryQ/75G5hCS9LJeKXcE0zW0ZfwFikw60lb9djXegp?=
 =?us-ascii?Q?LL0xucJj1AgzHThQr72J/+pRO4OIF5SpRDAvGNzLGivYqTk5BcZMz/1hUBlj?=
 =?us-ascii?Q?+WriPK+eisSdaR2yOu3q7rAttEFvHdlSj84oC6UuYYlxcw2Yxi14M6Nqf894?=
 =?us-ascii?Q?pDeM8tONyWs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XZ0gQ+81uXsTH+88XZfaiYuL20GFILyHIwsfJxNPdVRiF+q21D2kIJbbsbUR?=
 =?us-ascii?Q?PzuYH1xP2EIhYuvpPXHcoWx62OpNKYNpAwjOP9K8Y+/Yd90caD/MSsIXaX6E?=
 =?us-ascii?Q?SuY6F7J+3LTFgOeYwZlhE3TKgul7wj62zJzYDZ1+hvEbyESeH2WjsVLfUdeC?=
 =?us-ascii?Q?Ab28n97axgwA0+KKDT0qCdFypXoq19ZhO6LUFCAjofgE2izjysfkE8LQA/6s?=
 =?us-ascii?Q?4B4wC7eOpt2pyhwyZnbiSrR7tFnJ/UY8v7EK209l5UP1s0Q0eBnHhG3l5gWU?=
 =?us-ascii?Q?/u9bFGiqwgXySN3AoIEOjRehCD7VWWTwC17GI/iRAut5eDfCm58CWplKy5i0?=
 =?us-ascii?Q?xyi90oh6eqsqXZQ6NCG/EDerGL1Fo4W0LywRjUMoFR9OezWdLxnA5Pt9LFxt?=
 =?us-ascii?Q?yK3d1dymFglnZKvtY1xXTBQcmXXM9gwL/GVYQkm8NOs0AVKKGcFLdpEbHqq+?=
 =?us-ascii?Q?BzwBGpI7S/9acS0l7KMZ54SwhWojPA+r7rnP/YqsovPtUfBxsB3jQaTJvzDw?=
 =?us-ascii?Q?zEATzfmgcbhQvGAjAY8wIpSeLfNYFe6Xd8yGLUl7sSkEnFDbD2AZBf/jRGne?=
 =?us-ascii?Q?m0CmZylELKwajIMRw+XJNW9OfhyhlJu+9d2LvHHuHBKoszr8d9dMKjWmn6Gr?=
 =?us-ascii?Q?GoREwWumZVtFcdptpXaj04qWpniqRs1Ux5z7zP6iFfcdbhb3g5L6ODEpkmI+?=
 =?us-ascii?Q?5iJjYzoGIxsY8uEfSb8Glj22XMnOfv2J+dwv6rpwZm8gvMVpLpO/SxD1/TTE?=
 =?us-ascii?Q?jtI5RlzwN+9cDZVNg1bMbhSgt76xfEljCdJKHc8XKvsDo9LZa6m2R1D/ZN6+?=
 =?us-ascii?Q?zn2rLC8RfeQDo5fwydVTTYYe96ka8t53P02XI7J2W0nYOsxxIajnRd8Uky3s?=
 =?us-ascii?Q?BmClM14Dq8IfK+nZiqGykT4/6rYv/2kvhX0q/SDQNAc9ewnWw7tstTnfh+KS?=
 =?us-ascii?Q?vsRhPgDnHLXhYpBhqqOnPVy8pt+cz0lisOAglGCZ414hStOuqa2Pq+Tvia3g?=
 =?us-ascii?Q?paYM6w5FzAGQh6l/Ufw0faZTk7nTHaNcOqIs3KobpNmGlQP0Ej1Bo+tTE+CC?=
 =?us-ascii?Q?/jdjhh92edF5VhOcRsPKf1fYktWhYrwfRfUJSqfhOAln/A613B5hfh/FmUSr?=
 =?us-ascii?Q?XqXNCEAjJWHnFHhysRrr0XZJHnRym+vNpw7g3n9xE6lYStRqSUP+1aLe2i6X?=
 =?us-ascii?Q?VcG791t0EeMN3ZzXJJT2X8Q+bKO5gnwFKPB4bUNRxiCQPjckcts+WKlsebfU?=
 =?us-ascii?Q?yFv3VlHMjkIvF3IrqtQNFkCAg6+6iS1O3yV/sH/r8Te+d88DRL9ZIhV8PZBb?=
 =?us-ascii?Q?YF4lRdJWaaCPeHMWz1V7IaPGh4Ch8KgWr8IRs/Tr6LtQF6Vb3R1rW3B5YADP?=
 =?us-ascii?Q?XXrfcH3LjVUDMnJxGQ9PhlcEp+8M0uHrYQfCkN7y5Nt3StVcE7XeLnqO7aWX?=
 =?us-ascii?Q?yZ2tHJnfU9mO4NXJDNcWmJwli7aZQG1ZAo625boTpcxcae0MshyRsCLgtKix?=
 =?us-ascii?Q?2nw7tMNf2tYEy3KTXiSvqE4nY7uDGZo7YdtlHX+RX8MwGlNE/m6rU+Civ/eP?=
 =?us-ascii?Q?RZkUS6rwPK95wMh9v7GvTR98YpjYY8n2xyb63StH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9843905b-7372-4f4d-b237-08ddf54c1a6d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 18:08:56.7902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jD+g3iGDATEgOBQQcWfdrD3y7mCza8LbxSbt8VmMnU3JV0SnRV5GemxzZ5370arD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6084
X-Rspamd-Queue-Id: E313340003
X-Stat-Signature: kzqtqs14hqrkk3at1qar8xwwmyn9e7y5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758046141-732626
X-HE-Meta: U2FsdGVkX18iYAhN1r8GwbIZH5q7d9dKazllUirLVY1RGPAZb+PxsbvJ7KGHkCAlx9BLbpj0l+qJTnWIX9m9aTS1PLuaH1kgFMYE9nxLECh38V1WmvEEKdAGvUpITfiC3zWehacH+Fn8PcszkxuPTukLhOsiBf8wZmX8mE2lB50fK/cBmkpU4UI7V4hUkGCuuaqsezqHuGr50i0c1TPRKnH6R9kOIuL6dqvvP/pQEDShuWzNciNpz2trNWAyW8+a/gzMmmrZ3HPvXUJl6qIxpQD7prWAjEn9/oWSDDcoI/uTFHqDGZ7Ckl/6U7GoJFXx/raeXPqOrLKg7KMyB5HxLW+KJ7XnYDLywURHdfrNi2FYpvRzQWR4UNjtXBDYXdKeLYm5MLxADu+a8R8D8YiFEKp9OMnZFtwyMLF1Bz3x2vFaA6kNUY6/Q+Oe+Lcpjx9um8JLu0whwyZ4bN4kwwCWBCwhvnJ6wR7G+mnXUCDs2KllQZ0zTMx8HJUP6FdWMfZ1MR2Esnh7nrbaoclH5A4RgZRZ6IlIvVEri/wStPS7c/6SvuTdYSf6QIQUiAA1I6r6CwURWUlZ0C6LKaX6FKiDLOfWGZd6bxJWL/Z0Urz9EYN2rB8QhbbhqFokGR3WRWxihCTNBTudoinX3R5TZ43p+zUjtB6KevsEbFuQ17/1AqdajtW3fgkPxNWot7pMUBxF85cLwIEQIVDrnvz3OxTRXG9URfFbHydLXlrU6PLq9psfDSVpvYDFdNll3mriUJ0bUvUkHvIQb/LUfHV+VWZ3R6UwBjjTHFtqVz5+/xDKg25a7nezY5SdC8aV28ohfqgW5sYNJNTVk2PFHJpItM2af2y+mzg9vhfl/hK68RySG80M39s9HHbr8qMou7ROKoSg/ifRS32SQe+JWKDn5Ga5IPtNpZXVdfNYoRxbKhHexmBRLJIkGk8jJiiWNo3pbD6l++QP+aXBNxFYUu5ETOL
 QkkATtLL
 R/2Mo8It7WIW62B/bNC5ClKL2TjNVNRg/HHGVHsrT/NNDtd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 06:57:56PM +0100, Lorenzo Stoakes wrote:
> > > +	/*
> > > +	 * If an error occurs, unmap the VMA altogether and return an error. We
> > > +	 * only clear the newly allocated VMA, since this function is only
> > > +	 * invoked if we do NOT merge, so we only clean up the VMA we created.
> > > +	 */
> > > +	if (err) {
> > > +		const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > > +
> > > +		do_munmap(current->mm, vma->vm_start, len, NULL);
> > > +
> > > +		if (action->error_hook) {
> > > +			/* We may want to filter the error. */
> > > +			err = action->error_hook(err);
> > > +
> > > +			/* The caller should not clear the error. */
> > > +			VM_WARN_ON_ONCE(!err);
> > > +		}
> > > +		return err;
> > > +	}
> > Also seems like this cleanup wants to be in a function that is not
> > protected by #ifdef nommu since the code is identical on both branches.
> 
> Not sure which cleanup you mean, this is new code :)

I mean the code I quoted right abouve that cleans up the VMA on
error.. It is always the same finishing sequence, there is no nommu
dependency in it.

Just put it all in some "finish mmap complete" function and call it in
both mmu and nommu versions.

Jason


