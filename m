Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB52CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF49E6B0022; Mon,  8 Sep 2025 11:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC806B0026; Mon,  8 Sep 2025 11:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB2E8E0001; Mon,  8 Sep 2025 11:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD616B0022
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:33:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3564A13940F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:33:54 +0000 (UTC)
X-FDA: 83866478388.15.F8D8AAE
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7935C160005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:33:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Et3lA6Eh;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cl8F1qd2eBFExcsp+ZyEpNuRqUubzW5u4nbEAXt8sPM=;
	b=OkUzM3OVyPtp4/SJD7FAI6cxw5SQQWC64m5wSdDJlNmQANk8TRY5Dw4yTeKIuCT5bj30kp
	YnX1R6ixSexifSiJssP+0eEAa5Skk88ZqcVcyExcDzwhsWgGUdccJ+HEQw4yKvkzvcxvLj
	BajAjUw15G2OEYLZkP3Qvisq5iXzdHY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757345631; a=rsa-sha256;
	cv=pass;
	b=dG0wcLflFKoCU2a+VyeXKRnixr06v3d9mNrdKHzSnXRtBFayH+oIq8wCwVtoHtOOMDdykA
	NYlquy3p87BwricrFkEtBWd6DuVIYYOIz8+a6tS6p1BGTE9Z1Ot93LCN0C4W2k4K1ngzI4
	IZ7ESzvWH1u/yX/akuP7ovggVaCoqc4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Et3lA6Eh;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvGqU+BlIi6TgiOfXrZA5qvBdkOrGjc+tEuk04zdBm6nBG18ws7Vk6ktUzD4pEk41s+wTcOE3LnF4jtXaagCFqARU1/hsexW+mXxqfCcCvPqaW7Y+9MARQzKnYJzQ8RTAyZwmy/7g6xvOB0opgnYhqStScEif4lfbj2zKZvO7g8fbH7/L07C3YePVfenhj08VPS7tDvBbKumKXt4z1zQ74xJ5oXsJfhIR1V9lUKqr1wV+IN5CPNfcBFU7t7gnr/A6eB2aAJcvx9YKx5P1EvIaMM7aUOgxLyfo8UcpgWA/Hw/TOpVU61RvAqtCil5ikPS6lGlgme5Kb8whm6jKTansA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cl8F1qd2eBFExcsp+ZyEpNuRqUubzW5u4nbEAXt8sPM=;
 b=IALElEGBCngR87plE1ERFwvhGhqhx6x51tLSYuKqbzVBCl+5g2XZn/6pZgf0963zZW82KMgRLBRzLjsKGgZMEi8d9OexP0HZpNg++c2jhZN7jeAaFdfF4my9ahS31Mt6OFcwk/F3Md9qEgQFSNflH2EkpllR83tXp0q+wGY7IRNE2+13J6eGf9BChW6XR9dBT286vuNf5KIo1RIc7z/aQgqIgQhxpr4RThBIpo0n7KtRiB+1SFoT9VyJ+xbQhHEFyso/Y8tMb2uVb+kMUXRbFQ/pkwY9x4OdJokx69NsJY2ZEv0ClUCWKC8vLherNZ0DwAbeAemX/6XsJti2z5yzjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cl8F1qd2eBFExcsp+ZyEpNuRqUubzW5u4nbEAXt8sPM=;
 b=Et3lA6EhhJqml5sP4xflmPTB1PwGGkEEJqJ/OpdKo9p4Mnh8woel8O+VqEqvu/yXE0Tqo8XkngBszYSA+uw+VHroMg5xNFtUxDcPuhY/ou0mLH9Z/wnhhh5GKmEHp9ZgAAkiA/qVbbIqfX/yunSNcTq/6G1IYNDrXraoe6+R9FBKBlMiKboUM5jdh04Z3xwDbVLASBEARTnmihugVOZfx+qFAUXQ4IihwvlMWp89P9CMpPAyjD0F6gLwqzMuBAfpceXW/thLTOO0yMKZ0o9S2eAGp1wiDTqsU82Bmsl5OhhLJKFWzhPIIFqIdmTozp5cPQHDEZBfqGWR1z7Tvs+Jig==
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by DS0PR12MB9037.namprd12.prod.outlook.com (2603:10b6:8:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:33:45 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 15:33:45 +0000
Date: Mon, 8 Sep 2025 12:33:42 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20250908153342.GA789684@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
 <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <20250908151637.GM616306@nvidia.com>
 <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
X-ClientProxiedBy: YT3PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::24) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|DS0PR12MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: 62293ab1-18b2-4527-71e4-08ddeeed1846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OfexwaZ1qAXecR/I9MLGdg+4q3gY2zPAE7wUIBRgqoVULJIOAJdVY8yZjeM+?=
 =?us-ascii?Q?jyrER12D3LiUfbmGsRezeWFo06VZG+uCEdBegdcrFDsUxkS7N0C2gUBXadIw?=
 =?us-ascii?Q?FOnRnNaTph6Ygk5sFDh9Kqmc/hzSTTea8+918uwfYznUZZ5sHjGOnjkJLYV3?=
 =?us-ascii?Q?D7XDYE2hV+FXdal/j84uVw1ApcWHVIz4x2pP1p8Q4AEEw860HmGK/H4u4RHM?=
 =?us-ascii?Q?AvOQkl61kadumqVLe8nClFL3Mnj+UE3e5T+taODMixBLuwpUhB1c1QK2+YsD?=
 =?us-ascii?Q?JB/abcEQnAjJVY+gCZFgMHjYj37X+NG18UzY+4XX0XdX71KcB/NIt32eQNMw?=
 =?us-ascii?Q?3fCjo0xHzriCSYq0lYd9h8BamGLM/tSN3onTW0PxkiCpiBH8eo3Wm7DlxTMZ?=
 =?us-ascii?Q?CbVbDOfOrO5U8HH4zJeIzlPClmQMJLhvlFCbGtaTiSkav3gMSeS1k9AQ0PHZ?=
 =?us-ascii?Q?mSNUSWrR0UAmhVPJOg0onuMHlscG9X5sl7//sG7t6DEdSS4UKQU+Lzf15F7X?=
 =?us-ascii?Q?8o6OoZFc5exe+tv/dlOdb4dNaVRVEb+uOEeQw1gazyHwbk4A8OELrIeYxqYb?=
 =?us-ascii?Q?C3y7le/+QeTWCEzCD2msSVBrcXK8Jajv4bBAHeTykQmJmjVtuXmoDlOWcraK?=
 =?us-ascii?Q?DPE8fTnH8S4jQ5kZ/WqiyNfGuIuRonaAJA+N7dRVDfTA/MiZGaY5PQa61ySZ?=
 =?us-ascii?Q?P13eTuPjGhdiiUpR5vwet73M5zBD79KPNlbqTNuU1FP1/zIGQFc8a5c+qHcO?=
 =?us-ascii?Q?K1NbgHbi1B4SEwhKxTPZNMrV9czp1+BS6gJg9mpWsXoATuOH0ppRwAGAwcs+?=
 =?us-ascii?Q?/g0XgzDZdk8cHszF+jFLFv8u7MSYsWvmf8X0gIehj5/UxjFJMeoHEfsMyqR7?=
 =?us-ascii?Q?fjoKl1XqHrW3cQCIh1JJ/SjO33s5XxrMGfVNFXbJvefYdgAOvoMgizIQTwbv?=
 =?us-ascii?Q?yIFaW+/y0luabjAU5dzdgT4rndx8/DA+MEJTCFX2A70Z5vSqRMIQXzqWwsGl?=
 =?us-ascii?Q?/3nbp8eQQ9MbsCrpmUlt3Moq0j8Lp10o0OPnIEcmNkmNzMWT4DbAgoBpGIJJ?=
 =?us-ascii?Q?OO8OFY1zfLe+voh5cBUYnC2EITxj9DN+W32i9GL04CDh9aCFbrAlGL4Em2da?=
 =?us-ascii?Q?ByBcHKVsgvoeMIn+BwqiWArZwomllVXQZ60PA7rbc71oL33GAKUXJVElLQxx?=
 =?us-ascii?Q?KTExEgybB94AhbXfkExbTKvrTj5/0Y3fZIv/oMzR6VMS9vyNlUSNLRcCqvA6?=
 =?us-ascii?Q?pADpHHN+04pwULc7dGjGI8yLZVSxDNTsikprHE2MKjpw/eNqqRvYx8Kn3re+?=
 =?us-ascii?Q?8Qp260pkoOSAqzFhqzapbAnEYE2l8gZCiGDpOlwLkNh6GDvgcq+DUVKhVrcN?=
 =?us-ascii?Q?43iwktF0Di8pKMuxhrpjDds9ruST7YJKYo36dxo3KTYw5M4+16bMDQFQgP6X?=
 =?us-ascii?Q?s9QFP+fm9XU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NWYPb0XDGZP9lV/DXB4iYGnO5mF72swH0ERSUad4Do8YqCu/hcDyn7OY6JNf?=
 =?us-ascii?Q?6gEAQmDowMY/HDpKuvEFLxhRIFWbDDSsFlmn/HAHjSqMd3E0IfiWfAWQN9yC?=
 =?us-ascii?Q?CMN57SnFTFoM1mCtvMJk09S0MV4fho1EgML4X88DvvysExcb/YTUBrBHR5wr?=
 =?us-ascii?Q?3Uk9+mBEtqpodHZzUxXjIhKFOiaC0xZsQoOxq6XfB6dIJBqQ5Jem8BZslr98?=
 =?us-ascii?Q?YkwnNWeBtlEUc6tOYjyKIZEgKixneimM/7WjGd3BF1AE4aGzx1NhQabBsKSH?=
 =?us-ascii?Q?9zmLSM33X5mj0wspSEjqoW7ZSCtm+KcGR7f8mvFj6ACArXctZCFHlHhBQeoh?=
 =?us-ascii?Q?3krknZ15OKhxYQLotsZIIDVENbmauzrrF3R6Wj0oyD32CwiwhBxZdxTcDeYW?=
 =?us-ascii?Q?y97glatPlqS7ndsHKC8Sa1L0XlLekVahLX9YboPesWQ303KDHqtWSOWaWO00?=
 =?us-ascii?Q?xBOkcPVdXiGrd3E7eHRcLvGjzSLZukuEvwLE6zkQEcQ3GyFdr+0Vmjq8HwYO?=
 =?us-ascii?Q?KqZisxViIjiBLrASS+sTGTBJQGS54KdjkppGQEBWgEf+77kRSkA296hmOZUR?=
 =?us-ascii?Q?uZuNhpErA+8wxE5bwv1eTVVIrGQUkXgDVsz5f5NDwIDEYhqqPkU4UgWxaNiq?=
 =?us-ascii?Q?xvpyyTGo+VUXJKmaBkjxi/pYh8butaPuC0YvLD1pX1QgBr3GDWsapgyRV+1n?=
 =?us-ascii?Q?Ls0/rI/GxPJT/xidBA2ZfaQnSHGNSEoH7+vO3v8ve89PeXRzhg+Lsywk7iN1?=
 =?us-ascii?Q?wqRmcH2FNctSvXhOS19HEYMK47uNooG0UmC5r1XdZ9KsoT8fU8ONkOmQtGfA?=
 =?us-ascii?Q?wHSo0mHRh8y11oCnbTqTJ+VD5roayv40Rh6AMMd0pXMFJwZIW8moMaidbqTO?=
 =?us-ascii?Q?I8Ft/Cj1Hq2zG4k0yW2P3bFXctXcB1swqwyyH2wTqN6ZxJyaywk/BlBZGLYT?=
 =?us-ascii?Q?Q1NVme2eovr91f3zaJOH9SWX2bBJKcuwft982p7JCtmzVDGA9wsOO4adx0Hh?=
 =?us-ascii?Q?Liz4hDFUnjZuwWEwzwZD0MukqeJI6WZEYnrSpz6UdT5gXy0U15XmVWW4TB8x?=
 =?us-ascii?Q?f8yhnMoJ27Ed9Px64RK9pyehnXXjtxUGPq5qArUj/czhAl8MBzvFXojwSdlg?=
 =?us-ascii?Q?xVViCk1Yco3OeTST/ude6F7jXaOiLXjFn7UpKSo42UoGvKD49EhFCs4BXuDk?=
 =?us-ascii?Q?jhX0o0Jwu4NqybM6HKJENAZGiEXOBhfaYcDFvbjJ/kdIJSgx+kT+MZgWKk94?=
 =?us-ascii?Q?TbfjMDIhIlJE3DRFWs4Ae+p94ZCjjv3BFMCGUFHYQjl4a+h7p9mUyUly++/4?=
 =?us-ascii?Q?ZfKqZ7duFQHPitp4OHDsRW2YupmSYGqgLcE2tJ/iT/wZlbNc2LNM0Iq8hJPQ?=
 =?us-ascii?Q?DVtro54lMO0mRNnuC9dU97AU1yxkKTdXr/ASYx4MmHHrEnXxn+5p0AGfeO+n?=
 =?us-ascii?Q?sm4JJD2PNPXxu081S1KLgKUSRb/qAUS3hpTQ5zJp1HYojUdoD8TmyCPW7/6D?=
 =?us-ascii?Q?VetFcj7CVUkoySXFF4dSeQIyT0ybif5TMOVms9EGZ+g9E8sLpzWNqM4af0jf?=
 =?us-ascii?Q?HHeBEckKoI7EOAvRG1w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62293ab1-18b2-4527-71e4-08ddeeed1846
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:33:44.7583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/yAki0ZFGGvcHRFOXm2BAGkF8f5EtB04iNvaJOcWQD16qm11k1FiOzD1sppt2QH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9037
X-Stat-Signature: 3t1orsra93nqijwo5mebw7yycragnio3
X-Rspam-User: 
X-Rspamd-Queue-Id: 7935C160005
X-Rspamd-Server: rspam10
X-HE-Tag: 1757345631-860180
X-HE-Meta: U2FsdGVkX1/xGSlC58bIMg9NX3mK7QfWGOOL1prqSnzuAMW10cgxZh1PGDUTXb/9G+5A4kG2NKe9mw/aGL1KFrTA1XdAeA8KC+mZRhF9KDaIMlkz8qE2Yqy6Etcxuyyl8OJIr8bu5RCCSQKyzcHWtUWFAVwHnhmkq4EGSjM3W1/TDACTrZevNM5jXQYIwxPAqs4d0JFE3OnAMfNlTNngLT/SsNUnf0WWhcqtvqIyLXQyfH/JSSUfMcy1O8/6MjRBDRO7p63Ok+q7xsL56rsHuYjDBipTUSJGzx6cgzN44ydO4jJaG8CWWjBAoffimN1GjxJ+kzBpLDgejxYkJREeKnfs4jU+86v2ir20v9oVr2X9zoLQIElwCcS2mgfjRw0s1DxlysAkQM+D3NNZODvitfxq0EsNPiCTZVST4i0n/nWAWrnNYQtwC2eaB1ouh4yVfnPLGH0H0Ni1J9gcjeEpKV/g480j4NyeMBlx+5bdGBKjal0rh1MjhWKSECUsEL+rN7lIe37qN4K4hi87vh2Ra/j+AP9qyp8kn1PxVxyOi2jreHNlwYl9grd7EJW3caJibo7nt/zL57cN28r7aYslocyNJBhNtniJ6HAuHfrhE+JjZFF+M3MDNl/uzGI0wixRxBGaDL9osadqq1mCEMWMH5uxqc7nxvl4k9LgNwk/hfEkCQ5/3Im3Sg3ORcjItM1eZoKOSSU+0T8IGOoefEQKdcW3H/Vb8rWV/j0N//uBtFDIL7KVCH9TwQYAhZTSY93eNkehYQdX8BBqnBhj20T4w7fO1DWtYN96HXOQFblIFbeal2Z5ytwtA9ku9Uip+6pCT+OPy/4wrpQtp8ufa+vGDsgBZBW02YjIvcAodZ+TT98TldyqLgh6+mWDXSn2CXDYCPUrVPwXnOYv709+TLYfeSQ9k39bMWXT+VUxlWF5rW43dTEH485H/5e6+z6AqxcMlLOEpS+uxshWyKEt/F0
 lIi6dvOC
 94kyKGMFbhP1D3viQ3dzDD+z/OENQrEam0yXQdKoxKLN9MFa8kNzCvYfYh4Tv7iPRp1aO7FhG9ZMBdBql6QYJBt0rexUaBKJVTuLXUtojO4SVddsivyYM8KYYJ1+3GBOIvu2dPdu250t7fproVt3WXHcD+yAaxAF4wUPRfmTKeXBE302+F66+MzxkfGBGh//UAfEbubOwdmol6QzYo5pJED3wfIEB2P3/QJzTX2DVkvOU1CeZ9orTIfO1LEiCJ/clAnzxIhJxu5m36HABfzIzByLipEO/0T1Nq7rl+u8R0e7ayF8R9g3MwaiDlHfExBDJOjm1fRnQAt+uB4mkzCYO+/gd3fEQZvAGKox+mPD+MedRMrGMO5CMAdz4DhFXPfnOywdrqLQxscRUaUdymSkkxE8eY1vFoko/AVep2w4chwz9zjWghtQbhwRYr9lxLPiCA+9kd4m1iqVqHBRd9zrI8QRJjgkMwZYXJtiqgXKbNZpv1JXGSa2siEf9Jaq4/c6MlLH9m51IBqcSsroSXZaQc/9QaCAQG16TrzfEtGhvcymmyxZDy9yqh6RceEUjJaZSml/SjktcL7rRyLMYM0ufVCjpYoD64D+XSiBU6IZZTTTpsiaOUDbiWbGYQBfQrJpuu+vQXMgH2bu7dNRXDdqZWIww6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 05:24:23PM +0200, David Hildenbrand wrote:
> > 
> > > I think we need to be cautious of scope here :) I don't want to
> > > accidentally break things this way.
> > 
> > IMHO it is worth doing when you get into more driver places it is far
> > more obvious why the VM_SHARED is being checked.
> > 
> > > OK I think a sensible way forward - How about I add desc_is_cowable() or
> > > vma_desc_cowable() and only set this if I'm confident it's correct?
> > 
> > I'm thinking to call it vma_desc_never_cowable() as that is much much
> > clear what the purpose is.
> 
> Secretmem wants no private mappings. So we should check exactly that, not
> whether we might have a cow mapping.

secretmem is checking shared for a different reason than many other places..

Jason

