Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD82CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF128E001A; Mon,  8 Sep 2025 09:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A966B8E000E; Mon,  8 Sep 2025 09:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E378E001A; Mon,  8 Sep 2025 09:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFBF8E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:32:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29B4456345
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:32:32 +0000 (UTC)
X-FDA: 83866172544.14.A242943
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E21C1C0018
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:32:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=umqPj4zc;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757338349; a=rsa-sha256;
	cv=pass;
	b=wgIWxRLd3+C1z/Iv1k7saOzMRFQ5ZTkJiJO/k9zIvzXzzp8lH09vsrxEMCu7si+UcnNz+d
	LSUMK4iuVvkhxDKEMH5U4UxRPXTOKztq1+zw5sqSPIO9JWv9I4RAAaQExL6xkrUuJSII0W
	ZuTBREMe9SHQ8oapuLcuPS6QP4yDFAA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=umqPj4zc;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.59 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757338349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBi1FVpshr0fT1WbsHlc8+T7+Ir3NcjHPqPXVABKwoY=;
	b=yl/IwDyBXJ6+2CUHJC9WkVMMdCTXaap6n67iVXveue8Fx2V7qWxcacIVk1l8LOLtIgRD//
	SdO68KDJ4O7F/yD4MZxtNSSp4jyZ4HkAtF26UnHI+W6zrIMyBBvGAfTwQIzosLtIJslO84
	3PTi9IdzlCXDBE3DFRGLAj3GZO8vn1g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSXEQZKwYEaZ3VNJhatwgR9CFxZONQKMTzr4Gfrxi5W4nAjP68t2LsTlLjODpP9yj28sXZgQml9BxIZHJjcx2JkkUU5N7lpF897Hu2zeDVaWMRvE9NY8p0x6fcd6eYZUeFFD5uYkNBYWH+e2207yff4spZiw1rOgrFZEHIs/XAGfQ/M0vDtFmqcbPlhnUiDyKr3UXMBjeMy9B09Vzr6U4YMUlmbmqE0TqDxZr/EITCcRwKdrr5wsfO+YKxeofhPMDdJS/EE9VjJGeN5tZvlzoJkpMUgQJjivksuKpLJZbbocY4oySpFe4uyusq5qsJOrYPiEd+R0MSzYiR7KB7GAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBi1FVpshr0fT1WbsHlc8+T7+Ir3NcjHPqPXVABKwoY=;
 b=M3EjhyWj/LxvVISsAf6on0H8ARUb2Le+3CX7C9h0rp3oVNcEzEtmyjckM9fTEnWdA2qrL3Ryg2O13F+YZIvfAcvWTzM7MUz1IMNQk1OEBEXSrphymQc6L9fBtSJe15hIsnUOc9CGUYhVJ5PxVbY4jbxhvJMznULILRn+xFqlYmcGh4EA+XfB0XZucadb1BjdlozKX5tfOePkuJi/ZIZKm8wCKscS3apJDzdz2blXbUz1V7GLiE5gp2drCBdCNg6KtDMqTkiuFw+cPBcgw7jDa1zyzxzxz5tGhC66TpFiLi+lW10yqbM6XJRgZWAnVuCi82nvR/qhb4za6YSA/HR7qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBi1FVpshr0fT1WbsHlc8+T7+Ir3NcjHPqPXVABKwoY=;
 b=umqPj4zcwH8q9hq4oSJovDWDjGeaUBPJJ65UEzkyUgh0W8p5w6MrnaYa1Ms8Ie9gT5lAVkvf+QkEjsMH39NeNbhEScfU0MvdKn3+e3NPkg3IeYJ8c33jawkuckcGxUp1f/qmjOzvMfj1LQv6x+6wPfCuvHbFJf6IIvA5n4UoIZS5jAXmj68iGbqSEMpLIfXBM6cU83XyMClkDSvkBtpjpR7s5KvBzRJ2yXuhhKdqeHidxcFevMmgZ5Ldm8u9Z/Y3wMh2eQgDkuVXe7+TjPzlhpWt1AIGk5qvc00yg1QgBPm7n4oWosH4CcTfu/lwjk/HV2jZt5yIhSEU/j8NQt30iA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH1PPFC8B3B7859.namprd12.prod.outlook.com (2603:10b6:61f:fc00::622) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.30; Mon, 8 Sep
 2025 13:32:26 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Mon, 8 Sep 2025
 13:32:26 +0000
Date: Mon, 8 Sep 2025 10:32:24 -0300
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
	kasan-dev@googlegroups.com
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
Message-ID: <20250908133224.GE616306@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
 <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
X-ClientProxiedBy: MN0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:52f::27) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH1PPFC8B3B7859:EE_
X-MS-Office365-Filtering-Correlation-Id: 1296e94b-a083-4b54-6cf9-08ddeedc263b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pbGdCwQtUkBy1XWPzFEuCSxAdxGU6ymWkpWa7puKYk2lOQtfEGnVj4mOqyw7?=
 =?us-ascii?Q?DEqvv2249Hq4je6j1kic8/cnMwIAKU2b5AivI4NrculouXZX1S86JLng5w02?=
 =?us-ascii?Q?kHdwq6wM/064mWbKGrrXoyk9oXIj8xKBbacL0DNha0AfzfZa7hsesPwQeGTS?=
 =?us-ascii?Q?6WcCq4GQnXFDhYxVEpW5+cGzmbubab5QvWyQgFS24glDaS/uDV0yQ1Skwluk?=
 =?us-ascii?Q?DqPnKt29dedTeFwNNjg2Uu+yT6GbAhcJ6HIr5R0myY6bQa6BordVNcrtA5OL?=
 =?us-ascii?Q?67CELdskAAgtr7NJDew/NZfyk7ZNq9x6DokZzUx5KrlN8Hc4bM33Oqm0lwgY?=
 =?us-ascii?Q?JKiZYsPn6CjV7A/d3qnW18+JuJdk3fk3i3BSuapnJLkeuW86CzNSEtVMUq6T?=
 =?us-ascii?Q?nBvQtf+pJce7jriOfxgnFxj0JrCrLHCfjhDeTm2znZI3eSFKAz1gdlECdgav?=
 =?us-ascii?Q?DYJ51dZmSxe1xVaoTDTj+fWV+GqZkoYBAhAmQ6mdluQinPmm10paDnXCxYbT?=
 =?us-ascii?Q?k/RohGAQ6fwv43R14TUAO3nI4IeELSjssnPI98Noswq19gB8o6//y6n8oIBv?=
 =?us-ascii?Q?sowz3Hlz7DT4UNNNMU1TTWv28y8utuTrFPsNAngfngZxZAHG+IOrm8kFpiPP?=
 =?us-ascii?Q?MQXG5kHJo3o3BF4S2kxbJ3wYZW1FMJGuuyURQ6NBZOvG41GAC1plt7FdH+eQ?=
 =?us-ascii?Q?pdUQZRrABthEG3NvMQ57P0siy+3JfYY1za3GmnMkcwt5jVTyHyNkX3vowlsX?=
 =?us-ascii?Q?eJKyMoIDZHPGpIt+PdQ8l02VdzK8XYMaksDsLqLdDIE7OD92OyDqBA1tRzDA?=
 =?us-ascii?Q?FjUEf3tVIGHXbMqf8nJNpdOkNcKF2m2OhgfJgfo3yHW9n4j3blo+E0ayXL/S?=
 =?us-ascii?Q?QjYwjKegDLrnoiU0ue7XoZCmQYsxkZ9YfjkFWkjJMq4DfnrgErYVEd2BC8cX?=
 =?us-ascii?Q?Xt+h1HLDeGDhLsUVsyq5YzfhVy4wuNFjsZtcGJelqcaP/AsJqNPpLFMHc1Z2?=
 =?us-ascii?Q?S4q6VvwDDrTehOa9ujxtAu2XB4qnQHa+2x85fclPZGA3p6ZarfGqre1lQem7?=
 =?us-ascii?Q?7KAOP9QVhbLnmjf8Z3LEW0HVh1QWgWHPAQTZ6lhHJyKhq1Xri2Opp8gszD0w?=
 =?us-ascii?Q?rUQw5yIbabLeJ9wyabgtv6Q6hVZYq8MToiEcn4IIr1N5LdxV2z1OwKZLZbBD?=
 =?us-ascii?Q?O9TfFXuA7H7uPFlHEAS4aqHUh8p6K9E8W7CDcbMFf4KBsqw5c7MTdZQkj2xn?=
 =?us-ascii?Q?ZLzBiQNihUg/ITMDoxldx7p0GaE5tNzAFhyYBfmr/f2ee7R9C1MT79Nl4t2D?=
 =?us-ascii?Q?6AivkHWeMQSO47JExnn0e04RBG9PWA85cznHo6hnnxb4Pz08cbmWRVksrC7a?=
 =?us-ascii?Q?JIzs7eEjJ1RM0+7gjCgdexmWWSx20z8+tNsQk7fvUvKy8BDZ7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cWluRfwjDRHkIbbSj/V4gzAvYEhm+rAPYVuK3KKOz+XhVc4jmgXAf0f2JhVW?=
 =?us-ascii?Q?3RtZG70f1N2c7PeMoSdlLtd8ggMtwbUA1MSDbTH+l4TrbUJ9Psk/T0nYP0rW?=
 =?us-ascii?Q?q+6NXhgSF4X5lYsfYNxrx4eDgZzHno14eN2tYg2GtcgMGbHS/lHL+sndpmy4?=
 =?us-ascii?Q?lW5vJZKnR8ULPwehbnfbUYHv1bUAUQicLbwQBxom6pbsDDRueMWV5EvZGcWC?=
 =?us-ascii?Q?Ca+xhyTK9U/stsJ5YUxZKHLAUekqwqp+WgG6mIjgnes+HXhkhv77aGtwMLiH?=
 =?us-ascii?Q?57Z2BkSvgQfbgtBjfZfFhE03HrwEPOVWrm2mzfO6wwRAumTujtQDxVaSvJF4?=
 =?us-ascii?Q?vGJA1S4gOuQK8WirrV3agNkSAuPta1C0QJOrtykiiB98m3hcTPXURnSW/3XF?=
 =?us-ascii?Q?Si0mrXTcAzQPoWj5iW30Ps62qOwZaie9fYyr9eEhVPHJfdcp80SEZBVlWyFr?=
 =?us-ascii?Q?4KSaeN9ltcNCrXl7XlgY2gMcmZZczYz7cCMFsFcYTzxpG2C8YONAw97vvVMi?=
 =?us-ascii?Q?WIEsrnVaCuYyvYTYOmQJqTZTdz3EDCYheiRkePmBpxE26h+b6Kq9xDnom3lT?=
 =?us-ascii?Q?hAU83w+Z4tiKJeymfhYnG+8BKpsmrYP4ogJMaZXWnhov4BJ0heS3V1XEEZJR?=
 =?us-ascii?Q?KFaWZXXx8r9QfruNFjArWZoBjuQEzfBtkWI872ymCnZoUPNZiI4rDjsm9NDz?=
 =?us-ascii?Q?mwIFqgm7z1mA+mZshBeVSd1vqvoOSyE86lk3VoBuINCOFuxtXLQWP8EqC0Rp?=
 =?us-ascii?Q?H+zL8GExBgc44sliX47Wjg8DDONQA0yB/l7HtT4O0DfBQKBmTXBFkxlKve95?=
 =?us-ascii?Q?dtp+0YVmBitZCDeuLsTdzR+67dEBZKRSGxRtW/7ZeBSk4LixF/3QEG9lB9Jm?=
 =?us-ascii?Q?Fb0sDzdduJIaSMEovZyq650G83cw8vba5BIiMXmCXCtYrDH4kDCQmJ7gAM79?=
 =?us-ascii?Q?yza0MF1DtNYK11cFgBDkStPmqjM7UlB89nc8xYtVecZEAak9EUitury93mRY?=
 =?us-ascii?Q?6xFXnHpnoXYqSd5wfZsYeRQNEJdQVPmIVzigF/uy2E4m2vlF5gT02ogsvZ5a?=
 =?us-ascii?Q?OjCUJc1Fb1oe3dzHuKA6bq2kkPAG8Tx2SlZ9C0pAuOrMGBshLZsb1sPmNiQX?=
 =?us-ascii?Q?qYTd0jwSWKHWOLijtLKxWpDACtXLPZYyUTzsIxukBwvEWIGbJt7ycFWKfu4O?=
 =?us-ascii?Q?8haVm00CFRdSXl5p5qlm6RkmDsSsv0r3T4yuuBxW5RMqtJ8nPULXpeimqUUq?=
 =?us-ascii?Q?AXVpjLEzkym0v5s0iHmfntLflk9tlNhJpQ/71W5TwtCHnGKdBV95CaVZLOHV?=
 =?us-ascii?Q?Bu9H0w0Y2VhjXk0QbDsfRwPQ1BVdZ1p3RyYworn/zuJvopPG8JXwOuNwG6nD?=
 =?us-ascii?Q?WZS6sniA83otjD8a4iyKq4f/0Uv6CLVqhEAEm0+kWri8PIExjxyB8R6Wa9qb?=
 =?us-ascii?Q?ZOP1NngUt1coAKwmQOcjri18j82Jq0uiU/FF15gmgg/6RCwH2ET1IKklkU/9?=
 =?us-ascii?Q?HRgMt20T0Ernl/NmX+olEjTyWxIKzreWbYum7KyYb5kI3C9dN+gi6D7jI8fy?=
 =?us-ascii?Q?DcZJvHJA20Z5dMwV/fY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1296e94b-a083-4b54-6cf9-08ddeedc263b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:32:26.0123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YdG2Z9wJsLcOm97NeNGzP0EsYJQ7Sg+4VCbYQF4vWiX9t8lrZw4zZKBGT3790aW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFC8B3B7859
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E21C1C0018
X-Stat-Signature: rbfo7trz1ye4rodjrt7wh3rohoqe6zny
X-Rspam-User: 
X-HE-Tag: 1757338349-69161
X-HE-Meta: U2FsdGVkX1+cJvJgt2lVg03Z3OWMwfTZ2sQYfHza7WO6lhZP9Yv8vEW3s6+7VvDAlbnFmp9xk3JfwdS3395MOfQzU7Qcf+3pEPK2YTYlgHbczaBdT4xj6qPYg0/KXhW6KVb8kV5FnBLZbzxNcD3uHET2R9P56LmQOEEYC0wKcELDLX99eUzRCCI1B14dl6zzSohdcNgHXq566NsFF1jgbNLdKEfttghnZkd3x6Rd97GngfB0EU7tvV2RDQaOLdrtqmV5TSIdvPbV5jGxbpfEv0IC33QUf70psXpKbjflES/xZw3zdk5VVMgZ0Wv/ihhApJjvzt5Gjx7lJt1l3z7BGgsE4mwBAYB/F7JsUjXLxUWkdmxTpczs0/jWksJY8LfThbh0uScdX+hy8cmOmnv53ZRGdfwCTiVc03XwW76c98FekmJfmYX+9b/MyKpIo9FxdQ9tibrtc9L3weN0nGLqfeL+GW10JNHYGvAkL7XVs1eXF0T+/JZ+RPDNYR4S5lYuW06j2KQDr53VPgF7ipY1hzcnkNEuZRlZmiRiNyv/11ruR8XIJNuQdLDOtgu+qlFT2yhaHdZYNVjTcdQE80XkwNi9j1tbaAcOwFOPKBbX5WoWNwtXKR0W6Jtq90d3Z7Q2FrFF6gaNVSlO+XxUFIAKW5dv45lzZ1PVhpBHsWwFsj+6TJZo8ANovWqzh8TBbLt1n9C/bFzsOKr9qAkPN11Ygqf97vsEHp7msWO7ATrcq49BYmcZICux7DJfFXl7HuU9kziMqo0L0vXPL3j33ug4eyFAn6Rr+SVkBOh6Otp5IV1XEnffsbS1vdsyz3OSx41JjQmFnvy47zWt1NbpU1kLcEa66z/INONV8l2PZRbEeCBZGa3HrdSP+fq9fjVI16P3hGTyChS+J0Z5BdsE0fIMjt8i7JaHb0K1lpbvOi0c1uInFFq5u7YK3c8gCYOAlvvTm6MmArps6c6HiopJEIm
 QfTZP/dP
 rTg7eU+4Sr18bBig74bJOuuUvo5nlrW0TNmz+Kpb6qU/Fn1MPYkQeRgdZLZT+h5KPkl0tsJiyrOR0MpF6h+vjXUuQ/bhTt604bfW/OglZXzVaQiEYS/iVxJpf27rnL1Ip1O2wcqAZxih5dy1QanbKHC6qJM9shic6nOGt9QPDviOaMZtVC4HKI+ltgDlUGjR4WFjkQWHnyXtuXXpTzzF5Bjk69IaFE0fehrG6QimWAK5WA7DRnBswXcSF/twHkGPNRwxLLjH9RHkuDkp4a/qdHSBZczYuhNLh8olH9jJNX7NsRdEQ3TB8Bb0MD1AS0tSpnC0Sfop0kcYGOFnBOSteY/Wtxl7txA3XAE87mpT/Xk7Ua3DRepTBsZSNORG+I2dij/Vg0mBGNNs4RTLzEFCiPW5er/pylsWgDaSWRYpqvisBzTjQlQ/HAPbtkWiMeFNlcmqhoPnKnT38EGsYJwWB3T7gaGL59LqEwspLtRFGSWyYjsWU44aEB2lf3pqGWzFbvI8cj1/C5I+sDPI3+GdXRA4f3JyKPMnzM9ah93sZO66ui1nPZwoqONgBheljmxnxhzmF4GAUo7cMOm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 02:12:00PM +0100, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 09:51:01AM -0300, Jason Gunthorpe wrote:
> > On Mon, Sep 08, 2025 at 12:10:34PM +0100, Lorenzo Stoakes wrote:
> > >  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
> > >  {
> > > -	const unsigned long len = desc->end - desc->start;
> > > +	const unsigned long len = vma_desc_size(desc);
> > >
> > >  	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
> > >  		return -EINVAL;
> >
> > I wonder if we should have some helper for this shared check too, it
> > is a bit tricky with the two flags. Forced-shared checks are pretty
> > common.
> 
> Sure can add.
> 
> >
> > vma_desc_must_be_shared(desc) ?
> 
> Maybe _could_be_shared()?

It is not could, it is must. 

Perhaps

!vma_desc_cowable()

Is what many drivers are really trying to assert.

Jason

