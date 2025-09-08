Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE03CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1BA8E0020; Mon,  8 Sep 2025 09:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9F08E0014; Mon,  8 Sep 2025 09:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED36F8E0020; Mon,  8 Sep 2025 09:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBF6E8E0014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:44:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BF6E1D9B2B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:44:51 +0000 (UTC)
X-FDA: 83866203582.24.F156426
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3013B2000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:44:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kUKDOLHH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fYaWEvmG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757339088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnJiDkYDgF/480LBQJb710VfbXpDw8LqWwe3LgYLIX0=;
	b=4HJ1TOq00meA+qKLlk3emuh7oOWdS4349CcftQ/fFRwXkw21teKbYcUa07MuNCE83w4XHC
	1l2onfjNMP26DhyL4bogfhJohC5kOkZtsBRiJofMiIkkmssioK4UOQOq1JVmBnqSXyaeKg
	h6ZyTqMr1yKwpRjAKmGdVHbIXqmzO+Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757339088; a=rsa-sha256;
	cv=pass;
	b=x53Cyo6O6JZWi7svn3MnAReZFQVqonz+30Z+Wx769JTc/NHnbBv/2tJ5VwhGYg8eGT9nHL
	rmRNXjbUxMBMmDfwJ/aaeao+wWVjB+cFL9tCZxl17AEDxxIPV+0vuJILSwhhD9Anf5X5kx
	z1tYQm8HJBHQzhJl/y9qVP/1pQUVd8Y=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kUKDOLHH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fYaWEvmG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588D0kDG006290;
	Mon, 8 Sep 2025 13:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nnJiDkYDgF/480LBQJ
	b710VfbXpDw8LqWwe3LgYLIX0=; b=kUKDOLHHfkm39LanfBmc1KiCzFq+3YBVL4
	R+Oj9YxmuZclwU7kB4wyvOlkA794oSSrrpbVAXM+/WAC7wxixwoMaAChQxYGcpl+
	y5niV9V1ehpCbM6Sx4mQ+ju2VhrY1aVEpSxu+yXqVisuWY1Dw2j+xDlzTuug3Eqy
	eDCVsNgSWxcLLyHlQUK0Hp3cGy9csD3L7ZA313GzZtAsskmkOrJb9+o0xNHehe0S
	kO7v54xspRCN/UbbncN9JHoTkG6NcEMycRRB68NGYZGfbSX7xi7+4rXflFQ7WJW7
	0p1PO0DsHDsvKPmHcXn22A2Ir9ppJajpuN638NV7v78nMbfjnlFg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491xf8r7ke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:44:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588DC8Yf025907;
	Mon, 8 Sep 2025 13:44:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd87982-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:44:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSbipMy92BAWLdcOrguqB9zqHLVFYTDND5s5Xj89SwTNvdeOjdudziGrXcHhAhiGiJlQCLPG0YSm/vt0L8nDdiDQRu0RC540MV6YtPRgY+iwRSivvIxmOL1N9HbV8W2QSt5c8tqvE8DlxjijppDXC5CfKh963h5yqH87cL/LZFU9hU2WPvPpT6bsedfbS97S8+Ozp4sZEqEr3fWxbtZ7zXhkppTMngFdJ2En4tuX7NvLFQErFNvcaAybX2V+5mYXGgKc2VxbBWjSckujANdziWJe/a7HWrg8Kd7vYzfBA/OmuGh8b8LOZyQHZj95GkXJOsX1Kj6CP3QZf1Q3sgqdYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnJiDkYDgF/480LBQJb710VfbXpDw8LqWwe3LgYLIX0=;
 b=IXXcI4FbK71NL9MJ5WJfxBzQcpk1k57BBIBOdJRXpSjcTwbWYpFptKrTh7Jlj4rN2mIkbypxS6b3Z2WmxLebOptJqVHxRQztEMH+t5ESKLsj77OsPhO+RaZLsuoIRvzAn4l1z8KETeYfjQC8rTGLd7h8KmWiWShJXfJfYMkpGC0cU34aOol1rzXUjA6ySuI+jLLldRUXZ4rzXUX0RkoWlADZGSaFYCu5qy0lxg1pGhAQL4bhB5NolasZWEJMrS9XhaMhtj1WX62GBKuaL/LIloZyi495HuY17uYgNPpmQDRC/+4fUtop/8aix0RmdtI6EBgmuba/n/al9WG2K1AWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnJiDkYDgF/480LBQJb710VfbXpDw8LqWwe3LgYLIX0=;
 b=fYaWEvmGUOL84jVwcqgk1hDrzLTM5UaAl5viVUQ6hVeNRj6iJioKhSow77EM938wuYW1L+SUXGycZS/ah5YKlxHwc18FgM6qBGX2Qo/KCMVWMrrxc13ZvqRnj8JtXTgTZdUpZxqgEWsvYc8MK5cYfbyu0PAVFssDmvOjY4S9lXo=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 13:44:25 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 13:44:25 +0000
Date: Mon, 8 Sep 2025 14:44:22 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
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
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH 13/16] mm: update cramfs to use mmap_prepare,
 mmap_complete
Message-ID: <a2e8efd4-22a3-43c3-835d-7f3a55fb4252@lucifer.local>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <e2fb74b295b60bcb591aba5cc521cbe1b7901cd3.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908132723.GC616306@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908132723.GC616306@nvidia.com>
X-ClientProxiedBy: LO0P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: e2daaede-ed3a-4cc8-6a30-08ddeeddd2a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aEiS9wdH6kdxEWwhYqcEwU3bIOFXZf+zTGju0N/ZC/DMNHEzZJ0unQzr9jE8?=
 =?us-ascii?Q?/kLYdTbPkdl5/mQcyx02t7wi7mC/kXid2mrNKG+lo/HoiTd4mHP27L5PHnAM?=
 =?us-ascii?Q?ABYgusrR9SKTx3ujtOy4h5gbbfoiOtA5GUIaQq7dPIWrgQjj9g0YdCarDWr3?=
 =?us-ascii?Q?ChRqTyBxkiauWzlR1GlOjScmbV4HGKcEJJkEjo6NCOC6oNnqbuAi7DVDJY7q?=
 =?us-ascii?Q?Kjg+JlfVoaeJ1jGyZC9nfdhpixTLuDpfDrP5SnhrN6k1Q0cpSWHqOwYMRsDh?=
 =?us-ascii?Q?MlB3xMK4ad5UkAtDrqXNwG1FSTJtzt7Pe5Dt+3fUgv/SnffjxzUSqpvxkuP4?=
 =?us-ascii?Q?ptoZE+mrTZ7Vrvg5EVdesWGDKX/T9u8IAPMiKSf6OdLhu/kotaHgPEnRZdpY?=
 =?us-ascii?Q?pR8Q1PJrvLn39y+gUH7IFJus6uur5pADkXQxw0ZPJbyb1XgzUDHviQmC7KUb?=
 =?us-ascii?Q?GjWGi7lYaIH0NLd2FVmR4W3c1gucolq9EUIES7kgU3xrIQA/y0KJ5y3QyNHL?=
 =?us-ascii?Q?YZl2rCtQKEq+CsE98mg+v5aWi8MzlKExMBS/YNvYb3OHN98ny+sxrvz8FIiO?=
 =?us-ascii?Q?wrMSc6rrQ779AoF+/hjXS+gMeLb214zj4X8vt4ON04XiGXk6pryWLP3JgJHU?=
 =?us-ascii?Q?JfIEwMyGn5mlsBvYNEsuZVT7ZwduShEevE//DqHP3rcLQ99RgDnSQoZcZyjO?=
 =?us-ascii?Q?swy55bSezRRdSWN2CBjWPeDS6ce09ZvRrqcMeVCXcXQ6JMCGkYnKSL7DqYQI?=
 =?us-ascii?Q?eXWLGuzAxOIT8pvqBPckm4S8Jcqn8+7A1YlP1WxbiT6YGVmrda5xAHnxoZ0+?=
 =?us-ascii?Q?UGsjuvpeFssO91CpscbfhNmQ3OgQ7/sTh0iN+d0/VmKi9KhTteM7Vv0eZfgz?=
 =?us-ascii?Q?qbDUr8oHmcJhnEmff3JIcuD03HiKoDWMll9H2a9q9D5pNhvYPKjpUVMoum5F?=
 =?us-ascii?Q?LCRt8tlILK0OlT5B6PbT//mZGulb/D1C2yV0oy7qDOc8BzCHDihiETjudTOi?=
 =?us-ascii?Q?Jas0VYE7jU81OcU2X0XkRA0HVCSlZRhNIsiMlApURGLWRHGPvE7ISAT5HLpU?=
 =?us-ascii?Q?Ddyq6+zT28r4fhsKMJ/Y6jlGX+fWmUKuOcRsu70ng5zX67r/DpzfrwzpVoU3?=
 =?us-ascii?Q?oz7VuHA9VFqcpnbQD0dye9dq5IrF+d0/MLy0CM+T+f8a1Gr6uF+xH4l9izHh?=
 =?us-ascii?Q?aWV8IKsomYMO8ZjVJdqszD+fphbN2e1r5UgsbiZrXNs8RvbSuplXsVpwt0vP?=
 =?us-ascii?Q?MrKxUmivtNgb1UHTECHbdkwaj4rc+/12L4nrskGOi0U/TYv8yMOxLBNVFosn?=
 =?us-ascii?Q?jERZEllEMQ/wgt/u0vCDdNAo8Wu9t299J4Xy2UeZkI8dAsuBU7b3RGlBB9+S?=
 =?us-ascii?Q?40sBi8/F4KO1wyybMlwOF9WYEXnql/+k2RPxY6bvFXi0If4wVF/gIwmfaq3I?=
 =?us-ascii?Q?5OmskNrkuXc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f9nuvaaYSLYF5Ke1X84CPOi7ObCmaHlZihvZoLIoadngNnVFZWaiDd0ed+Bi?=
 =?us-ascii?Q?dXJL2Jpql9sfN3NoVYWTVEM5xfDIcXZDzWKMFYEWESnWN1kLRMmNG7zWstKY?=
 =?us-ascii?Q?vuP2oq0yT21+hpEQaS91mx3IqjunucyklP36ypFEwahkvdn7QqpiBsOM6eYS?=
 =?us-ascii?Q?OvS0nyv70fRbgBuzYpVa1zJ+mueafZTAKTeISl/DWzhFEhjskA2wiyMxCuyE?=
 =?us-ascii?Q?F8MBjFF78ud6Sw5pri8AL/+Z+8gKfmx74VIykGtc937PmCTQ4yj7UECK9OX2?=
 =?us-ascii?Q?Flai+pWXm4HZjquBaxWjo8LfukGVdqku79NpBrhocU7aI+uN/xkCvJC8m44i?=
 =?us-ascii?Q?EZIbcc5dluDV2FVMEKEGRi4NK4+tSoNhk+sz5dZDR2J8WA2z10fA96t+cy3K?=
 =?us-ascii?Q?id5AWhlJRWz1/zHofm8VjWS2hsWTr07eQ+AXYSNADIgaufyqEbh754id5zvR?=
 =?us-ascii?Q?ddjTQqI872CEb7tPoP/olmbqhOEwAe7qihGSAXF1tyVT78R1NFo7GGpTC6Cr?=
 =?us-ascii?Q?NtSJIyQIbBA+KsZg82T0OPHPnJSbI4v32PgcQC4K8DnMzoLGynB1SYJ0eiVx?=
 =?us-ascii?Q?Lsmd5BMnoK+aXTtCLtZulYrP+MQivQT3PNniLuyCusEW7oZpz4F6CZMWMC5D?=
 =?us-ascii?Q?3M+mN1S2JpxbVszvr02irZ2jaSnPxSzObOkdeeLonlAdKHq54GnOGQopEgZy?=
 =?us-ascii?Q?gzaL4tl5GjW0gT39Mftf20qM9gbDi3aTNZ9wB7GE9/zkzxm0SpMqrg6nGgHy?=
 =?us-ascii?Q?58WfMt2qWQwSj4zy6qLJhhoSZwue7xI5lvZqk5I8xz8THBhzkeN/h9688k1X?=
 =?us-ascii?Q?b59T3NV2dF7KjPaCnFRxy7AIfKLLJZhb9d+11uU4VtSKtaJv4ripdPf2JW0b?=
 =?us-ascii?Q?aQt6eIbuXRRkw0lqEuof7UlRVoPiQFa274fI8HhpyY8TFt/PoyPSdFC4ztdC?=
 =?us-ascii?Q?fMQQ2E7vkEj5dVTeP8R3vnh5VVlvExjb0EIqLi5MzaRgRIrluGjOQaaqK20b?=
 =?us-ascii?Q?VIltfwI3Q3M6nLXD+bFQD7b/3F5SVuWkke+RFV8InoffG6jz2cn79LP8EwS9?=
 =?us-ascii?Q?UMFuVtwVu+3TwNlvyAoWt1yBcSNAxcr809/0uXd37mnHFRk+psw9gRv9svcZ?=
 =?us-ascii?Q?miGLrQeYBq32HwTHw9XxU/rpWykHp72t9TeKj8QQrz39hbYA3/K4PFvZUZYq?=
 =?us-ascii?Q?9KDvlGNpqlBRKyZd5ewrsSMDcY0g1bpqVAhZWx0KQyS71R6v61V40GllzgRp?=
 =?us-ascii?Q?xIBLjEDpjsBVjs9fcjZ7VcmJ4UVe08bn+8RSgJpwrFM/8WoqKkHd8Sc9snnF?=
 =?us-ascii?Q?EvbGuJIUBYcWLF/bSUSpEwNZ8rSSjBSQTH2KvmvsLmO215nQhBQbLysXiVGj?=
 =?us-ascii?Q?NYi5KL4TSeUQx+tuYKCm2Os5Sjux4TSTPBzML0fDn/uC8tZ2/BvBuxFnJ8Qy?=
 =?us-ascii?Q?8cKhMGyKiH5YRK+6TkhgXeAy9eAK2oFRO7t6/gNwW24w16w3RHiJAbXsgLQg?=
 =?us-ascii?Q?X0lfHU03/t/j323VL1Cb4g6v6a4GCY7Ai5CStUyitySGd9pctyh17jxMXljS?=
 =?us-ascii?Q?qg2P6GyHVBsjb84Op+ujKCnnE7LHhmzKD+FX/xmxT4VW35prYh+eR1ceSR7M?=
 =?us-ascii?Q?XA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ddmcgpx6Xc5dYqgfnLobDTBIrjTrlTdvlPTaQUl0SolzEPX+Fx+Q4eI002Rc+GZtf38C5xLP0miJ8UU0Uy3R7njxTGsBB1t1d3hz0EmHajVYxsEQBGF1FZIpPNsGyp+QfcuMyavJtQx7WJFn6R4iPAM9OU1I22kHIoIfAiZpSJ0539cWZGOM50PYv5iilU/Reiay0HJ72jHciO0ZJRg+Z28pwSXHs6an0Ps+eK3R8uC/a7A8PjZRKylrAQdSUY+qE28YU7g2UJFzUG0LeMGzEN9H7l2Gp0k7Reu+SenD62h2xdePjPYZbSoRSc46Pq1Nn4ezrqqP6GrLYTioA2d0BN2ffBwWl1dAwReBArCUP+EXPAelLXiCqwag+y2jP7xHn570jDO2U2zin0nFYn4lCoNP+NdeOep388vfnuuye0f95cCr1EM6b3Z/igEVNTYhXnciKtdS/T5imjEOsl4eMldejRkytaLiwCm++dZ0pxDP2grAcRuuqj0avlwMbu4sJdgnfpKmL+iuK9JvGo4wm3ChQMBvGi53FU5McOBLe3hkv1GbBh5SASEgxevfFr2WGuz9hSzySSwdgIIfUwE90vSsmfM2riAmTeMvvZa4cjQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2daaede-ed3a-4cc8-6a30-08ddeeddd2a1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:44:25.3131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XUhLpK6t7JF+XUvoSakhkinNoHKoj2RQdF1O7ubqrCl+qpNn/fwvx+uVR/341wVC69L//koICLGk8dsx2BX3JGyWpyRT+vFDMMybapKWZdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080137
X-Proofpoint-ORIG-GUID: 0a0-Q5bIknb8-Ln0kpG_i6EsnP9edK_0
X-Proofpoint-GUID: 0a0-Q5bIknb8-Ln0kpG_i6EsnP9edK_0
X-Authority-Analysis: v=2.4 cv=KJFaDEFo c=1 sm=1 tr=0 ts=68beddbe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Zqo5jKUnljtqsLplMgYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDExNyBTYWx0ZWRfXxmUX4Sj8qrd0
 kR2dETGtY3z9ty1sq+o+svmN74X62w2qzCBCi3qSgBPZoGieFSjB6xBA2+2bDP06p9ndgbhH1uT
 dHW5rflEVRF5bVDFoTnm8OdOAmMs4cjw/bhs3tZB3Il21QTA8YHobXuv1aTGFe/EeUK1TyaMi1l
 qVWvfsti4c/UrFW/iK/fjO/3K+VgWATzBKvyeUhLQNQotdo216silm1WozYmg0SVK4sGgxrXPq4
 jkIu4ui8osnJ3uKNDH9twvF2Xw7uXHhXLbbBBmP4sINBUhck/61AGLTo2KvQxxPQQN65vnSH8Rg
 t42HhZnutUeB/jwoTWl5JEbrYZ1wcx8lhVrj8d2F9OIhFax0bAhV5BMRPqYcqEI3fy4KR0X9uss
 wVJoI8NvarhWDvyBy4i5n/jgENbyNw==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3013B2000C
X-Stat-Signature: 738sjadojw1o55a3ewqnz4d7bbitkkog
X-Rspam-User: 
X-HE-Tag: 1757339088-835260
X-HE-Meta: U2FsdGVkX18nrjz0waj16zSb30i5DBOQUK5aE9XMLPWn6zwJw0NaSnQlDuUFxBNxGxmsrTRKaEkXeblvpj3VLAnANmpOa6JgjqKGqge5rQxWflzhIPAY/5iS5K25jW0QCNBK2XNY4u/v4cIjzHhRE6QkLA5HfClbjGZXBgrGVokYBNSeaU93vPeESC6wjclrLAU6Q0sVaqMEA/Zvb00x5mD42w1E+y5WPtptqdNTG8a3nenUb528/xwpN8vQQ8M7E0tCXBmUCVe2gGriF23Nu+WxSjRPg9Xv/P833Xi0iISGutAaEg1o+zs/p5RsF+/Afjlb46E6WJenOwsnkhseaUdHQRJi4viRmsWEkaJhrkv5zZq4d++6bNMubIz+vKhjnBKesqNGqnjQP5U1+y9RCN8WZazlSLvHLhPexiMH5UayymmR2fv+gFTMWO5RwyoONmcy25WbgiT/ppiuReXHwZxZx/iey+gR276ZVUbUU9kA/sxUmiNWVbAX2rbKa1Znh2XC9nVDX1RKIZblqnq1gQomYXZQh2Qg8ZmPe6PiliG8TkGmXJHwv4BLGhklzbwM4I5dDgTdWXyXbQf0RDFpQpna8ovkHznw4awxrbRXXApUK02ZmYFmmSBmNMyOaoLUZGZUYKwQ/yaK8J0VE4r9cEqvEYAgsWgbrZJ2/ejScUZV8GJ/rdoeFQfpoZjYwlW7qEG67XS3B30TWQZUpSsCQ31OmNWs09JjqmgKdrWVZwwUtTLfN4NHxTHb5cdOoFOffjVIfTn8vvNV1Sv2Lzf4o4vdq2URmo8DXENPRvKy3IHVrx/u5do39vKpPxoyWUsX9W8EzP554xuk/tlZ65UsZgdEg6x3Oahnp2EA7W72KMvSXyUNHUEencfbUcZgNISnx3/hDgID11d7STnSRkY2Lggeopw0AiV22IvxHXCvIhcRFVxArEq7sEtESTKMaK8w8F8UqRJwYrAToKg8Dp2
 Wj9KOo4D
 CfmmzKwlfc4vGsWN5cn5wm1i+TACx23t10AVTCfWDpSn1aYhlzRgo8AkmkzRJ74izxdTlVXatg1isQJOvkuHx+zn6jQmIRlxNdsW0kwVvSlQaYsVbc13xoRO4z8VdG/BZBdusjOUP5Hbd5a7+Q11GTpYs2/e0VsZOib/sT9va8LUkruljZecr9SHfBYW0lW2cG7sAbe+0oJ9bjpT/Cjfgj79CMdOtVh74JeNCLRxvYEK250RcU/dj/XoTkCfXI3kSKbN1C9/Czoh7eWhpu9br81vJsYaLH/T/Rh3k53Qv+lqQ0EJLSVgV3BqZcyOnjRTcm8vrs583na16oY1nfK3P9KCytrBeFkUtSS421vw7G1sll2FxUCm/1UT2einI3NykWwNkEQ3OjkGfn3C3QYNLDdzA6x2cvRJso0ogtmr390yARqNodo1MPYktS4VfXqZdGE5sJk/3nXsgBdYichkzLocnvZwPTbH7u+T/+R1EqGCpva1OBYo6lhiO45m+D6INCpHRC0PCXd1NHC1NTCllBa+LFaLrW0Ho3jpjMOWlaVkyy4qtaYP287z/vTrwUammpEziZfQUzc6G+kMmXSQ9Fxvkf7v6+ZcOqO2pgnVvZgHBA1kYYbw6C5T4WJIuWLI6xO8Fvkw6hFYCklMkXwY/7pzFyZ+KAYuam65opOiZ93MINEVtqFSrnaVeRz6Aj8cyrBZ3AFupOWDQ4v9zCeg2VwaFNX6gqjSrW9+rZ+08iU/PpMl3QMv+ydvvp+LgOEL1xUY6RULlyuFDhS3zXpsTsDom63cvoLsEnDiYjPaD3VUUJ3iqh0KmLiq3+f5b4LYZOzCL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 10:27:23AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 12:10:44PM +0100, Lorenzo Stoakes wrote:
> > We thread the state through the mmap_context, allowing for both PFN map and
> > mixed mapped pre-population.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  fs/cramfs/inode.c | 134 +++++++++++++++++++++++++++++++---------------
> >  1 file changed, 92 insertions(+), 42 deletions(-)
> >
> > diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
> > index b002e9b734f9..11a11213304d 100644
> > --- a/fs/cramfs/inode.c
> > +++ b/fs/cramfs/inode.c
> > @@ -59,6 +59,12 @@ static const struct address_space_operations cramfs_aops;
> >
> >  static DEFINE_MUTEX(read_mutex);
> >
> > +/* How should the mapping be completed? */
> > +enum cramfs_mmap_state {
> > +	NO_PREPOPULATE,
> > +	PREPOPULATE_PFNMAP,
> > +	PREPOPULATE_MIXEDMAP,
> > +};
> >
> >  /* These macros may change in future, to provide better st_ino semantics. */
> >  #define OFFSET(x)	((x)->i_ino)
> > @@ -342,34 +348,89 @@ static bool cramfs_last_page_is_shared(struct inode *inode)
> >  	return memchr_inv(tail_data, 0, PAGE_SIZE - partial) ? true : false;
> >  }
> >
> > -static int cramfs_physmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +static int cramfs_physmem_mmap_complete(struct file *file, struct vm_area_struct *vma,
> > +					const void *context)
> >  {
> >  	struct inode *inode = file_inode(file);
> >  	struct cramfs_sb_info *sbi = CRAMFS_SB(inode->i_sb);
> > -	unsigned int pages, max_pages, offset;
> >  	unsigned long address, pgoff = vma->vm_pgoff;
> > -	char *bailout_reason;
> > -	int ret;
> > +	unsigned int pages, offset;
> > +	enum cramfs_mmap_state mmap_state = (enum cramfs_mmap_state)context;
> > +	int ret = 0;
> >
> > -	ret = generic_file_readonly_mmap(file, vma);
> > -	if (ret)
> > -		return ret;
> > +	if (mmap_state == NO_PREPOPULATE)
> > +		return 0;
>
> It would be nicer to have different ops than this, the normal op could
> just call the generic helper and then there is only the mixed map op.

Right, but I can't stop to refactor everything I change, or this effort will
take even longer.

I do have to compromise a _little_ on that as there's ~250 odd callsites to
go...

>
> Makes me wonder if putting the op in the fops was right, a
> mixed/non-mixed vm_ops would do this nicely.

I added a reviewers note just for you in 00/16 :) I guess you missed it:

	REVIEWER NOTE:
	~~~~~~~~~~~~~~

	I considered putting the complete, abort callbacks in vm_ops,
	however this won't work because then we would be unable to adjust
	helpers like ngeneric_file_mmap_prepare() (which provides vm_ops)
	to provide the correct complete, abort callbacks.

	Conceptually it also makes more sense to have these in f_op as they
	are one-off operations performed at mmap time to establish the VMA,
	rather than a property of the VMA itself.

Basically, existing generic code sets vm_ops to something already, now we'd
need to somehow also vary it on this as well or nest vm_ops? I don't think
it's workable.

I found this out because I started working on this series with the complete
callback as part of vm_ops then hit this stumbling block as a result.

>
> Jason

Cheers, Lorenzo

