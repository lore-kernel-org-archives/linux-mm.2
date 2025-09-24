Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599CACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FEA98E0023; Wed, 24 Sep 2025 08:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6018E0001; Wed, 24 Sep 2025 08:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D778E0023; Wed, 24 Sep 2025 08:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 787428E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:04:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C0BFBB9CC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:04:35 +0000 (UTC)
X-FDA: 83924011710.11.E6762A3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1031E80010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:04:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hZfPQbxb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jdoZtQ9c;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDEFgeXJhOei4PwVGE5ptxybwP4fnxGr3Qsh+J+TyCM=;
	b=wUd0UWpQaST5TkNTcaLaVNP7DtCZi2UKuX3Lb9E5fYzim6CWkzyMl5Pj/QNvhrPywu+0dB
	qf80kwd0Rp6a9jryKNEk6WjnnKlzy9pBAKaP72Rkh25uZnqWWbR+/8m4InRYOnKTfXtZ0K
	SfmJZ6G1O8stRTFy3Cm7NXGni+ks0A0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hZfPQbxb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jdoZtQ9c;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758715472; a=rsa-sha256;
	cv=pass;
	b=0yT1nMFCRW6qxPkj6C9SOnpYwUYc5X9DlNwKLMXC3xwam64olW39iIzkuT/f8riL02Au48
	7b5bYr+Vo/IMTZYJc1Dpxy5i4n9n/s/I99BGdZ2yp26zrsrogT6upPdBVXhsmJqNDRzljL
	x5/zJa20aKwsVGuETl6iYgy3ZdfxrpA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58O9MrA3032003;
	Wed, 24 Sep 2025 12:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YDEFgeXJhOei4PwVGE
	5ptxybwP4fnxGr3Qsh+J+TyCM=; b=hZfPQbxbqaterf9AtjdtFu0QbsHuezsMEJ
	Ry67nQ5VOQRq2YkUYztQ/PN50jMHob318mdM46A1VGYdaG+dBFH4zYcQKX28+6iM
	IYQyCGmuJLD2UbBJF58B2Iq4w6MIo5R0mx1Rhs+6DtZoiNAgo1GmamshO66Rz6JB
	Z9XHr6uvT1Bh+D4tUr8rLx+I6t1Ocl4Cm93dDa7bhWp9O9XkGaEY6XnFjGewGHzo
	0DYIxVkN8rDDtGLZ8pxuXTk0FhfGYyINo0ak22QnmUoBdq15HZUvn4ytIlIxCv9n
	HtrwdpqyEd0LFnSoiekWxQgXr4Gld4IprONbS2haJYKXZVaHFaZg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499kvtygv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 12:04:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58OC2Cxd026702;
	Wed, 24 Sep 2025 12:04:06 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010031.outbound.protection.outlook.com [40.93.198.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jq9rwdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 12:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNNDMkH5zJDgnPJvqbetJRSa7Rik89VbN/eg+1f7bjvoh2WH/IpGUERrDuXVZEAFyH9DCljRACXi1/VSOCK0XiODkp9dtENEHGO/AkG5u4T+4/YKTKP25OoA7icfRLq4a7YHH1eNyNW1tsAptimZk7YhSBjqDQ9YVX2Lr6gARB004mxotOmYRMwCkylQgEaralH7Ak8BfyH9EXLrmccBsa974LstfZClVQJlV7gy7cqOZwCyUr0hS01JCB41fyfM43ADrDLSgWZits5vDBDsD/tfliYUDzalnaO7xfI/iPAeO6FT5aNCjyP8k0eN1VhnQM1+C5ZoOn+9+s7SaAlgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDEFgeXJhOei4PwVGE5ptxybwP4fnxGr3Qsh+J+TyCM=;
 b=XpIUNzbWwy4lnUr4pUKY0ddT96sqkKPD5nCiXUV0Ph/v8jcAN0GPGpkF2j7PYL9gcyzBaFQFjCt+nAGTvvQRSpu531BN9a4/O/cE6pu/34HSg+y7uFK63oRgkuPbzT9HUjZvlftlBXzYO91boYOf9PMDHP3H7ZGKdDgYS6kL3lwTVAdX5+yKMTSMB39YQguzNvYTGutdkF93jSZwLjkA8TLVSkVnkbA/HBJBrn5+HUVrYADRP5uHEksOTU94uQ08SbPfNKP6aVLLH9i765SLCA7g6JhRdUqPXQFO62e60f3tWYqggvqeVY1DETFDr8rsPJS2+hEWqIMHsv7v+JhlmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDEFgeXJhOei4PwVGE5ptxybwP4fnxGr3Qsh+J+TyCM=;
 b=jdoZtQ9c1wYJPsjcjpx0dW5xo/ws+Bs4bSSLIwHsdf8s65if9Syo8Cr2ossynC92G/Shv8I96Nol6ZXAaldveB66xa54+Zf2TRBEAD1oRjPKnTv9IlDOEUeUoKa26q6nNXfZRcqSUzlriJFjKQzqGQN31NAI1O7HemljZxpPbzA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4363.namprd10.prod.outlook.com (2603:10b6:5:21e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 24 Sep
 2025 12:04:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 12:04:00 +0000
Date: Wed, 24 Sep 2025 14:03:53 +0200
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>,
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 11/14] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-ID: <ff0ff4ef-bb6f-4a43-a2d8-35ab0f18dd09@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <e5532a0aff1991a1b5435dcb358b7d35abc80f3b.1758135681.git.lorenzo.stoakes@oracle.com>
 <aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
X-ClientProxiedBy: GV3PEPF00007A87.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::614) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: 012bfdb0-6dfd-4afc-7d53-08ddfb6272a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QszJoOsOc4hDiaMvwPYNMJ1RFEqLl/Mr42eQ9xmER6ijeptE6r3enDuTTcrV?=
 =?us-ascii?Q?NZgLfn5ntxyl1QRnhYGESwManQQL5kLuznwF+Qb2JEt+PcsZttSMAijWX8oU?=
 =?us-ascii?Q?El6yvW38GP/6W9iKlVG2zp4r9RKhqE7ax70TiBRsA5LDvXn2V0hXF0aGs5Bl?=
 =?us-ascii?Q?If6C6eDUr/olhZeKmH5vu/ZTQZMfMLz5j4JwWJE0D2+g27iyOP96E3rdcjjP?=
 =?us-ascii?Q?XM03SCPSGG+7VlAVx/OZFbEmyqmdJtwkSTB0++gNCYLc6xJSCemuRk+9E6oG?=
 =?us-ascii?Q?UgYJ7EIEZnR9AYZaZ8lmpUxZ2Fj9Kfx/+RUfObwJgx2dLGZbDjkPx5LWjeSG?=
 =?us-ascii?Q?GLTLXchw+4lNX545Gc8bKZ6+9CNdNZSyV7fMJAVFuJZ2dh6qIjrA4oTS5xCX?=
 =?us-ascii?Q?V1lcypzy6DYYwhgYd10XP4L36wpGDJusRnaS2DjM2TBoG8XEUZAbp7pgWv8F?=
 =?us-ascii?Q?6Az9r4/G4RlYRJBbyaPoHasy5uP8Z7YKPvb5lNaZIGSLw6pdjBwY9ealLlUE?=
 =?us-ascii?Q?t4211+UJA8OnmQqfBg15sO5dj4qPo81iz4kI/ENBFZbE9uWiJ6dT8ORj3+3N?=
 =?us-ascii?Q?wL3+VDoI0Q7U++BwNpkSeImOtfliSd2Vtyd9H9247pYJ+nSNPD6ilS5Cy910?=
 =?us-ascii?Q?qYr5Pxlorhf3nqlZlk2vWvh6B1z+Jp/EMrIwAB8B8P9LVwgXwbny55zePdQE?=
 =?us-ascii?Q?PxFRXpydCDPlo9M4zxyi/BzFFF+Lq6x9h6DofQXtMhjJnXkP88gzmMSUG5BN?=
 =?us-ascii?Q?UfsDUaNi/nuf9WPsMmqWuGqvf2BNsC/oD52lVltOueWjGV7oGGj4bid9roJN?=
 =?us-ascii?Q?5EpJ+SdnOQux7/1Rw/H8q1eLFfGhwKKzuZKC9jTKbZcoy2s365ZXzp2e3rg8?=
 =?us-ascii?Q?jElI8E7R1oJwqtgAGMKWBfyG4x6lJTxwGIzZVWV2AFnXMHw30lSOZ6iHmsPV?=
 =?us-ascii?Q?lyjtMg6ypgHhmuXfDd0cETo2qKv2R/BtXwv1RY7BN1qjPMBkxm6R3EaJrJsZ?=
 =?us-ascii?Q?iAJbsTUwyq6+JzzO9jaS5fGD/JdLVOWsNraNYUF/GADXNy9Qhfw2jaPt1WZm?=
 =?us-ascii?Q?OaKyjxq0Y01WX5Q4g0NjMP6uNZ+OuEkhwsSqYH81kjFUNa3PL0dI/uQZc6ME?=
 =?us-ascii?Q?Zlhi2iz+MBQI1CAO9MVUfyPiOQlO8kOROHmkCORXI+3SMhnc8AaZbxzPAyH2?=
 =?us-ascii?Q?tCh6UhYUfYlPg4iD9NPtzIqkg8zTnc8nDrAFpoaMd/bp801mxmlbSWYlr0cs?=
 =?us-ascii?Q?f5Bp16NRTAtzMU9yy6QzngTdO6sQBrUQWJuPLS7wzHLyE5sfJj1mK87c0m0a?=
 =?us-ascii?Q?syrgCUP2KoVSpZ36ISeGMGhioBYEh333ijqfwd39HB8HImhV5Da6Ad5PILeT?=
 =?us-ascii?Q?nLf1MF5WvfbD5NT6fYWe4iXdxDdCqDCyaMdX/Rwl7beeGWeceT9rkFxoTeVV?=
 =?us-ascii?Q?GXgwCFZIejk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UVytuLx85TL/TWFlFrHuy6Ogupl5+amiMmcfAZcJ/g+diJPSV5KqRTluuez1?=
 =?us-ascii?Q?hDUJDoRMXay3WQSeAfXUe09XzU9Eiv+fhmGMQRfAQGC0XWWRtP4xWUnxr1BL?=
 =?us-ascii?Q?VC0Vw/UsXGNBrW6wNw3/GFZBfcuR0O8RGBCr8xM6yUGTJK7VJPISDA4w4iDN?=
 =?us-ascii?Q?bfPNDuSHZT91XqdewBoeMzLQ/lz/4G0zpOMH5gWo1tUO/lOY1ujT2oKCoM7R?=
 =?us-ascii?Q?zFaL0MTdgCE0s8DDsS/50OmrUX5Z2PET559qjljLS9IQojiIxKYiR0gvHTte?=
 =?us-ascii?Q?5rzhHLyjBPnqR8giLOGWK1gIxrTS3OFurvJsNmczy4bYkIng1F7cvcJkCi8+?=
 =?us-ascii?Q?gttwltkkPv7ipox1OHjMpRv7k/hEQehaWUleISW5a8eGU3eVa7Rw+Q8L6mAl?=
 =?us-ascii?Q?J8DEqJM9TWfC6cLPFynWOv7INLfrGuB9SDTn4wzRr7fPw4YB7B9+2Suc22Np?=
 =?us-ascii?Q?kdWV/kz/zeL9hAdKJk6S2stn+eYhqYe12Kf3wx7ojhkeV7PEa8HNEe8C2To5?=
 =?us-ascii?Q?ExCVywaeavBmgRaPMypde5XB3smHh7A1PeT9HfVsiQkT7eU8H5ywtHYUcZHl?=
 =?us-ascii?Q?CKjlme8Ivlu5g4AR7NnegBrBTSeZ2ydzZlclzJiG5aoi6x2gcEzLxXEzI0XF?=
 =?us-ascii?Q?J076YM9yas+7S5NBv2+qu8DvURJKFFxqxVKOA2mgfFyk/7+pbiCacKxsLyy6?=
 =?us-ascii?Q?d0wU3GcvAlqRhPai+mGntlWfNblwurcj1qTvcY2G2ytQ6pCwsZxsoOybduI6?=
 =?us-ascii?Q?r32PLfBMgt0fS3ctgPf+0iWNYTqneHJ/Ev1szRXe1VA0OfQkmibF2sC7hDHg?=
 =?us-ascii?Q?hDc6mGSykiVdzNdUYgu7U/r/Tb5kRDyJ9y51JYEdAzObCp/BL2pYT6h7YChm?=
 =?us-ascii?Q?ElcDFYvMOcKanPOF+S1sP6pU3TV9mr+tXyowBrWBh5kGm4DbsW2WzDPanqP6?=
 =?us-ascii?Q?/WyZMQqJzmX70EBnUvAKFUR4rY3BmDYwQv/hees1Vmp0rrvJBVOtQBVCZEoJ?=
 =?us-ascii?Q?mlPOwFK3dYKKLZzuREnzZMi0pJbHeci7CpZCLLQAcdWBpKPGGKTHscPl7oCj?=
 =?us-ascii?Q?KK0lCGic0uKv1tb2YhRoKDn18o69TYy2qP59pT/lQoztQba/m7zcuk6zH/PI?=
 =?us-ascii?Q?dUwoW0NSDoqaomdDAj8mQ5Cc7WCjRxjPyhPWw3goTF3QWjf7L31My7YTGEaF?=
 =?us-ascii?Q?AWJw0OBi3GWYSwXUfhrwkrzbWTNU6hxoCfcaB4183zS9rDU4ovo1IXWhxnz1?=
 =?us-ascii?Q?0W/FHrawdTko8y3sBVLCY15rI+aPNQx8QtQIbqkJ2OJ4FerHe7qPlLtqmv8j?=
 =?us-ascii?Q?G4xdULmUvJATPq6RgtbdRRVlxQCrd+Wj2kpFSUV5P7nVvW7qPUQ6mJS9akpH?=
 =?us-ascii?Q?ks3zywSLdtWNYSgIUeD1ylXmrRsbHX/bLN9MEgDoRscdLbdkP4AFbPV4NdnG?=
 =?us-ascii?Q?mDgQ9zz1v4OYoMueNtabPreI9KjwvApCTynNv00Bd455hLqYf0hRFsGNsotY?=
 =?us-ascii?Q?H93AL43C6zo0B4KjUklCIapNZJB/E02NKSH9gjn5qDDGmgpVoqFYD45E3pQi?=
 =?us-ascii?Q?eM9x0EMhFb8N74WJhr2at/HVGDLzX6pLIH5c0PZfnwhTcaQj3tNtzyO/uf1e?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EKHGuW9m+W7S27tkv4Oi6YMqKnZSFYg/uMKHsv9u1xDPGlaLjG1NhN7+9Qvcfpn/Z/w9BM95lxaGJ8AgQ6q+V4BRcjG60bDYjp01zHjfSupep/1xn85D1V6MX6UXJ+BGntjNITrtiajiuqEG4TXIiJDfRQiqfX59S6E1GhrT3Du1H5WqP01dthKhzmozY5k+QyuxvTLDRhsol59disLtfXmjLBxNq6TXbWR60O7bGCJRjZmDVjUVpuWhxPSsIUIhTDB4hj12pHnCLy/YuMTBV6vdzh/ipqW+xESCDO2W9gk7mvwpk/R8AWNsW3+ibmfY3OqQm60C8sM3nQ8XIQqbDPGkzJqxoDVmOSiRSa3rdzhAhUH8PxfTghkODqCqdrNSVylarLbfXGmbrmUEZpi2V5PMXiQmAukUQbxAjmRc2D+jv9fS8eRhoqZOp+5z3gmHir6JvdPSXb+o+8SSyMGGpvJklseRbSbXCefZB3n4gP6MLISkxdvilAKWtM54RdU3ef/HYieeC7tZWTyeAhGVbRBSQAQlYNT35HmO3kesvfGcO+v/9JTaJvyZcEPrHdLWFO5RO0szs52x8voHOZIcmR7G2pNNp3go14G2eESBQ98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012bfdb0-6dfd-4afc-7d53-08ddfb6272a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 12:04:00.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjGcbdmX4e74LznTfUWL/+OuzNGapQMGLKATF/YK3FOan35OFf1tDRrpwPlSd7tVUGmhw6kS+E8Y+/jXFQEGQuRvagCSunrR8LA4Q3uG/K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509240104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyNSBTYWx0ZWRfXx/Yt+E66U9Ey
 YUppLrJGSmZjk0VS/d0UWTHXkqxOwXJwZVZdvf4dOT0Mc+MIQJFvEFP9F6IQ09GT0hKD7NE1hur
 ku/AFVw9NYQ2m8MFn2WZv4YMQk8FeDMXpv3a1yaRY71sZNz6Y6o8In9cE9wAM6U/jQVALrrmkX0
 /gxbj7NNqkCXN8cKD4DUracqEa5wwAh+/46heIZj47fAIADh+cl62GM7m31AYpVDNgT5xXSlzTg
 +jv3KrxRZ2AWiXCxCYcK5jJNQJ7Olf08BtrOmFo0jMfdTc0FdRZcdNgCqGO2tge1KNU4QiraoV8
 efB2t+mD2hI010fNo7FoqWXzkw8ZIlK15QyCJsP3qXbyzZ6JU8qDZ0F7xcLuPfQSFOY6inDIFt6
 2l+HnUnA
X-Authority-Analysis: v=2.4 cv=UPPdHDfy c=1 sm=1 tr=0 ts=68d3de37 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=pa9L9dGALShiNK9x7aUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: yIW8VasfJ0oYnwQaVnZHEvcEz7_JaR8u
X-Proofpoint-ORIG-GUID: yIW8VasfJ0oYnwQaVnZHEvcEz7_JaR8u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1031E80010
X-Stat-Signature: mwdfmk4uinyxzhmencbtjbkhwdkpzjmb
X-HE-Tag: 1758715471-124007
X-HE-Meta: U2FsdGVkX1/WsFz5AAZMqbab9+pnYGamFL8+fHRWbBNQ+RR2+ydKoYVsDhq83sG/bKA5jhOosiCajRS3s8u4XTTxKdgRt0g7ZrhjqekEBNNz3hfrsbvbUnp+3zd8ACoyCJoKa5uwx2/TEjtiqq3G3eHgCvnR59/XScQDJ3SsO2Vp1nt7zlFoCcuMG+j7ezTfzOMyLBmNf80vWD+gPzn2PmKXCleKD6/pRxT50w0Q2WHn/UGs/2pu20u6WR4iNWP4CUejdS8LH8mEoyQBFqDp/wENFZ6/4kkRpgwJw3+ZwdPKdVsOcn1IYjt6uliLWKpuaLDpbNZr0pn9izc4cFKqtJ4p61kjWk1jj6k0+iviqnuUk2rFKolvNDvNdu6/kg1BhE/1N8PYk8MSAVCkVDbZgMrwRRxAiROSQ6X/gGklkXDdiS70nkYKxNknmI6pytUEwxN0DXhWIENE6OzFtvb2xgbbImkYFWiw0BNklcJ+sB03Q9gp8tMJUfS7b97UksSkaSn/NInduZ2uucBsxK4PWTrSIOZVFE2qmpddIBWaCLitm0nQsB9OylCqOH9J8P8oNk7pZKlJ74T9CCJwQ6V3aFANCIjTMtDwD0hnQ0lS7DlE5LeN5viHXFwHPVIqxxPZ33gbFE0U4TSPqNfkNak+2sZnd4LvGYdnwIlQ13eMbEoYnCxkKMOSxeSczyZURiTGqCX4UMZDtHCLmN2UrOApHet3q/JERP6at335x0QOJtfzARhhvZ090/7by8aQTmrqyITpBevqbMNmTbDnDZgzXgP5D61CGxxhm074E5RwoLhkLIFhWT5DcFsdTU1/6GFHr2iQGjkuUILX+Nou3exP4mit40uLkIwpsdCvSWfiYAwxcKQNTbIAosuBOGWGANigYRU26TEIhmhqPQMOgz6BfYMLpk4GsZ601FNq/LHZ315HXZ+ViWnTnwmlXMJrKHEF1VUS3G1QXe7XlWONZY+
 xJtAAWOY
 W6kRV7ZFlEPczaWQiAuLdsCWF9MWtzGN8aJIvEmY2qA1tLK7mlIErDf+PsqtYdttEkRgXKk6T2UBrL9K/HY3xwZEzx01B7B/GwHgsxisdn6qZ9oC7NWXm5kdxO3jvdgJiOOAJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 02:17:04PM -0700, Andrew Morton wrote:
> On Tue, 23 Sep 2025 13:52:09 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
>
> > > --- a/fs/hugetlbfs/inode.c
> > > +++ b/fs/hugetlbfs/inode.c
> > > @@ -96,8 +96,15 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
> > >  #define PGOFF_LOFFT_MAX \
> > >  	(((1UL << (PAGE_SHIFT + 1)) - 1) <<  (BITS_PER_LONG - (PAGE_SHIFT + 1)))
> > >
> > > -static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> > > +static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> > >  {
> > > +	/* Unfortunate we have to reassign vma->vm_private_data. */
> > > +	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > > +}
> >
> > Hi Lorenzo,
> >
> > The following tests causes the kernel to enter a blocked state,
> > suggesting an issue related to locking order. I was able to reproduce
> > this behavior in certain test runs.
>
> Thanks.  I pulled this series out of mm.git's mm-stable branch, put it
> back into mm-unstable.

I'm at a conference right now and after that I'm on leave for a couple weeks,
returning on first week of 6.18-rc1, so I think best to delay this series for a
cycle so I can properly dig in here and determine best way forward then :)

Cheers, Lorenzo

