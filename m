Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638A5CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E7B8E0007; Tue, 16 Sep 2025 13:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE5C8E0001; Tue, 16 Sep 2025 13:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EBD8E0007; Tue, 16 Sep 2025 13:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75F108E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:07:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 191E1160261
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:07:33 +0000 (UTC)
X-FDA: 83895744786.24.4410745
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013062.outbound.protection.outlook.com [40.107.201.62])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B43B12000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:07:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iqCpLcUV;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758042450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3eL/8vmCyLJqHuq1f/gqPx6EXyEwmWvOGc2PCik9Hto=;
	b=4BbzNCOAzyQTOAdMP4NlpFdCsk9JAikoK6o8LGEvLvVWQc2zApT+q9Woyvm3KRtsJwFiGA
	B9x3HfQAI0/A5BCrCJAcnzRfBxN526p9mPwfaxuBO34IE+x2P4++/9ty5FWdueFrG9vV2Y
	F/fJnfO3JJyAF3AZu0Ot/q+XRKjmZRg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iqCpLcUV;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758042450; a=rsa-sha256;
	cv=pass;
	b=NkMvl7rycjGT8HgmfLH2eCbh6rF62lOZ5IMN42zDtO3X2agXCuGHN6VdLcb5TXq34afVa2
	xsytM/sf+bibK5vQ6ixltLtPxbeVGBY/W6BOK9YZRji8LwNsq3cfcQEElgDJlFY3cbwph+
	KcxgACsosTfCw8BFnydN9s5t3fogXYY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=azhXKU5bnemmG2ImgGg7ldMYsOH1F68megKd8M78bIN4fiDCoxURUlywFaaCtcLaTCZuewzgZKIcOMTqdNKOWnfu7P0qdqL318mynqZlKw4SR9GOKwAdQj3Q2iGKsNRhxjNz6yfzixq0R4N82atcoVSqFwR0zzFAX6/DExBU/ib79l8X9BTPWgUJgxl0gfnFjn9IXwSobH0oaS9F0bJjbgzJfzDXkspj3FnZqm6Z3pgznRTfLM/nlHFJ71ZqP4y2Da1aBA81DXYXNARCnRoXF+XC1/kDfPYhui9GmnlMAhYuXMpwVum9JvxRGhK2yZd0c9zw/VLItZRYdakynkspqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eL/8vmCyLJqHuq1f/gqPx6EXyEwmWvOGc2PCik9Hto=;
 b=IxnwOVWEHyFO+FQKsSrop/pkrAndEPuxAqfarRir8YGnxmaqN8j6Br69QfDpGqILDk3d8JZOFRBTvWDRvvdwkWiMBX0w8REFAMarOWNZ/RremwHzKBeZNfv7P6WCr6Gv06fQ7veOdx7zTxTr1IkwrHxh6FQONCBHGrjQu1bEXctZbx+FrL/BvkoOx1qkR9UBhBGvP3fXDUAFjltLUKgHGCv5+Xj5eCr+1T51qpDtiWNQqLiY7BSC68ge/Sh+l7J2IItn/Ek5+7X/r9h8tsFEWy5P1amUCbX7jqCkgNdaD7bO/zrg9/1+yvn5PmWTwKASR9utapGO43PC+WjEqDfmgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eL/8vmCyLJqHuq1f/gqPx6EXyEwmWvOGc2PCik9Hto=;
 b=iqCpLcUVjwp2UJZW5UF/z0fD1uPsqvy1MjABFf3mtRzpFv/GszoQ74nIFXhspX3JeFMFSi/ynBTy7ogwIIt4zoLPTWkr+F4/Xke8bChvGfMEejkaXWiY6A8LsFHG1yGT8EaQFW6oSAktDv+6+XyKwGJkC6buIfFem1x5kFkDzfjGCU25kes3/UlYoGZPYZbiESIyT5w0BUGyRIk4Hra5jbz0QHBFRQuk15Rc6awD1YhU1bmuhzINVDc+fy5QgYKcdTvfu6JrEfkiwQ6nSQBpdjutIE1LsfijGsc0j/uuu2iGa813luwI/ARPw4tLxm+/wl0qJ/uo2sm4osgmYanCbQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SN7PR12MB7153.namprd12.prod.outlook.com (2603:10b6:806:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 16 Sep
 2025 17:07:25 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 17:07:25 +0000
Date: Tue, 16 Sep 2025 14:07:23 -0300
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
Subject: Re: [PATCH v3 06/13] mm: add remap_pfn_range_prepare(),
 remap_pfn_range_complete()
Message-ID: <20250916170723.GO1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c050219963aade148332365f8d2223f267dd89a.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: DS0PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:8:191::21) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SN7PR12MB7153:EE_
X-MS-Office365-Filtering-Correlation-Id: 60a62956-dc76-4f3d-df0b-08ddf543821d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l7+cnmkV1oyDzGtYLz/+wFoy63p5ePp1vrk/egnPrZL/jidv/MYhMy2L3Wvn?=
 =?us-ascii?Q?vYNlJok4H+irfK78LADAhYOdHYaudcbQnz95H9DrjG3HOzLtd8EyZ/v0Hv6V?=
 =?us-ascii?Q?i2lDl594ApF+r8dabafUJt6ICPrV+LIL1igX8i2FzR3RMV24TtBepR8sn4yZ?=
 =?us-ascii?Q?eCjuwMKxnU19iP3ardmlGBUArpOiRAiaA7/4wP/HqjZla7FHoudH3BE8YpQR?=
 =?us-ascii?Q?IfBtpq/LQs2Ce+VRdtZdoKnNco3XSp9USsEr/QYdC6wRYlVFYCeE7uYsSoCt?=
 =?us-ascii?Q?ZAEhGwTo+RZrUBJiINecmKIqcXQHPeEwO6f+Bxdb0IHdBeHlWTRxkvZzkW1O?=
 =?us-ascii?Q?Jtlu3asYLkj7am1IMhD/l/CBofHo1nzEd2KrghYE/hGUH0NdbOPlw5E+Pkxi?=
 =?us-ascii?Q?1La35+2+78zXzCI4GWDzqv3UwibnfWGaKfFu/lQqgRNgz5LeYnJU7mOpfQZw?=
 =?us-ascii?Q?Wk94bp2KJlpMCnYI2j/X9N4Dg2rGIb5wWS2CwAc3TJuM6wx8OYHOU35U2RdH?=
 =?us-ascii?Q?XWsnt/HJ+YRuXQsIa1vPHTxpzPPM/QTHJXLRnbsHR9C2TWp18oMwTIID/CAC?=
 =?us-ascii?Q?5ellMVMmtUoFsp4qsOEbAN+50cmniWrMByKbNwYa9CEZn/p4V4n9uoQsPTgJ?=
 =?us-ascii?Q?efzzcoP3QzeQz58mD57uKF5rJF79n1vtNTF5s4fu0BMOCHLY5kx/JlEG5nwj?=
 =?us-ascii?Q?NrGkK58W7X3ljmOy9nH90NncK70meEIiAPPX/CAHAJllrG4tkWAOs7k3R72N?=
 =?us-ascii?Q?xCbPvRXeCRAfaYgh0KtZZWMMEhBwXl4+SJOqDLe31sVm2QfSH9gNlrZZmCJJ?=
 =?us-ascii?Q?Jbsapzc5SR38ihe5VvZBKvn3KBdmBiAu7ORtjt+iXb/dIRHmrXZ6U0DX689X?=
 =?us-ascii?Q?XTe7qJHSgmm1Mb2FKMLtqSwtFnZPns97//Cj84QdBLjsnWXdO6FYUYW0ENN/?=
 =?us-ascii?Q?DVkCs0Xs37wViY6cNYY3LCqwLNtWBJIdDVLFY9ZFoUNGzsi9v3g/qZG/Ki3o?=
 =?us-ascii?Q?np1QaaPQoXRtJdmaNAo1Z+ExyYXX/4VRd4xr3Ek43mraMpFOLVWjeEFF0R5t?=
 =?us-ascii?Q?R8pnRT/lkx5KwAOU84HHwlpr4b3/PaDekIYbK4HXSlRzGRJW9OCsVJcop66u?=
 =?us-ascii?Q?U4FDtaPcW+ADr8DZQ9pXs4Ih0y6h4pnXt5qim1+5HVmCyVFsj0TvK399ui8I?=
 =?us-ascii?Q?wnpOYoQTYpGGA3TJKIGJnGqoZYThHAUQeVccTnkogy/1ng6z11+6GtS1cL/G?=
 =?us-ascii?Q?fCClj4KefQ7DMmd/Zef6TLl3BraPWhLoQxwgzMlQeqmE+f5ENoR6chHPZ1FL?=
 =?us-ascii?Q?6qjqO/xOUmd4IqJNj4+Yw1rBp0zRE+gFhe8itqD0/1lAdAA/5sXkx78KGuBW?=
 =?us-ascii?Q?kp3UQjw05ShW6MGg0xAeGWxrBqfJkNk+FB01kUDKL/x5YyL2iw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pf95q55d7TT4PcZzUEjJVqUvGv8ZK74tU7v3I1bJmV9zsdcCc4AueSTYguvJ?=
 =?us-ascii?Q?JDKJg/uioU6a0bJBkUi2E94oQNyul0zscfra4+7XJjHaJibGJfJOE6uxboOF?=
 =?us-ascii?Q?rNPkKZbLPpk3anUvOguQrRpEkdHk0tFyCCPXNd9HVE0717AbzvGV1xVnWMRD?=
 =?us-ascii?Q?VYfWv1ZBFqOfQXAgLI/dXbbOAFGtOzaj2RX1L1MpIj5dYX+i+AUmwYyAIN7G?=
 =?us-ascii?Q?QfxXzxG4M924FcB58N3PUDnHOTWpLA2mEIquBoRwZ1Zt44DuhSZQU3meDQrK?=
 =?us-ascii?Q?3U5/MEFXWx+6WR7AMUS5un5dgoTcJ+ZUGfafD3XJcTHwsbzVDzekPlpmvmji?=
 =?us-ascii?Q?nC/6o3JAUQGXPcOzrRkj0k4v+llEkS3KRP2xJiL4Y65R7/Ua8D6hX5gXjhfU?=
 =?us-ascii?Q?bzyXGUR38F5VtvISuA9No/keq3fc7rh42xSVneLkmeuc9PQ3/h2T2CfCtM5P?=
 =?us-ascii?Q?UErxlvkSfCeSb0LWEbfYXX1HPawgYkDKufo4BwCDPzXSQKMevcYgawCsLsD8?=
 =?us-ascii?Q?0Yvi+d/IsFVGgH5NNml9142iUzm0AqMIdVIfadEbuB0u5LsWEHtwOKrEK/fr?=
 =?us-ascii?Q?KmV+zyEd8gAWvDPZYWyx1TI9HkZz3+vyc4N3+0483y81YvmXL9vb1P4BqAnn?=
 =?us-ascii?Q?J3BQG5QyEqXoRoHV9bPe/G3BFTkE1fe8UBsUGcTe6/5RNIxYdGIj6X72QPAw?=
 =?us-ascii?Q?yHSdP0W6biFRCNGuBKhBQHHHS3dPP9hrAg2xWPwRP0zmlNSGZxljCq+zsFhc?=
 =?us-ascii?Q?XKxIcccDjtgKpNRa55M46EFxFbv44GtKQc05GmEYVOPMRb7vCiDNbkg51dT8?=
 =?us-ascii?Q?G3ELwdZDpYGSHBu49MjiwcPMNRVRwZO7I+P4f3t1/Gmh4n/NYz4vxX8M1/uE?=
 =?us-ascii?Q?U5TSL5AuXSaOhHit9L/kfpW4Gh60Wvn9m1xMzjnL4alVNU9nnEcOjgtDTkNL?=
 =?us-ascii?Q?ggUfXKMuvVw1ztr83pXZ4rOV/aIYDCj/VEMjbE4xpKIED5dhBJeLqxjPKbkX?=
 =?us-ascii?Q?ngwoOljFnw1JCyF4sW13NIMIt2yGUaiJdqhjhNALg8UElLucmUocO2huXzl1?=
 =?us-ascii?Q?gsGW0W3Z6gsmfRjaXUbmrvNYFpr3S1S2Okm9cgHgRGunuNP2vsbsma0sKAdg?=
 =?us-ascii?Q?35HeC59nMtvtfcXiku+p7/wjsT3bPEc7OXMH2ClPcvxSDllTxo3DREigBO/Q?=
 =?us-ascii?Q?aau5anvT2/3tJE9EK0SuL7SPWr3uWE70rJRwDjuEOotNX/oQM7mlCVYpjAJC?=
 =?us-ascii?Q?Dyl+le95spWWBr0xr57TxZmWd7D2rd/JcBQ0P4YVpjps7uSFMEu6UPE59n3T?=
 =?us-ascii?Q?y5GAKt3RKsheAEriR2E01p39odwn6FJirpG2C8IrJ7LN+fW7b5hsu8+Ug9+c?=
 =?us-ascii?Q?W4RFzLN6t2blXif2w9m4lSA4SpToxrIsDY86jD7YMolAOjf/DMAi3xTHZul+?=
 =?us-ascii?Q?LkTpmstqAhY8+K3rc9GruUHZETG7PJPmh2rFeizVtaNP3LntNOYtnDCtZiZH?=
 =?us-ascii?Q?Uct0OhuzdBqESTKmg1Z+JxfZhBAGaiRBKCgWFeueoRVzS/YkW11CbwHVff6x?=
 =?us-ascii?Q?iJXe1vzJf7b/Ah1WudvgchLHYaB956SHu3MHwhUu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60a62956-dc76-4f3d-df0b-08ddf543821d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 17:07:25.3133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJr8QN0gwFY0xjGA5sEdwPHGDXUkGbzMPuuCp4RxyHKkHtR4GL/Pqy4frz+rePnD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7153
X-Rspamd-Queue-Id: 4B43B12000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4hosqf58mh435mgseh9gs1r9jkib6xwy
X-HE-Tag: 1758042450-370001
X-HE-Meta: U2FsdGVkX18NizAKqfYzW7OuO/0C1J5Rte0hAY/EY2C6ITaTuZb4QV21PynYRXXYrWHW14spAk7SrYUkYO4tYRTEODlqirq163SEk9NPddGZ+JbxY2BmgNipvkaSzSpnhRFbhL1uYXiFmgJnUcd7PDXRny3Atq456Hf4mMYzZ4I17caI/3IM3/s8bTMDdu+W/lvfmuLRMnx8pE0jlKBEzSdqFQkInwKL5KA7RmZmR2S6auYwPt/LEQ2lNIyCHpDXCVrR87H/imO1keW1H4jM9ijqEhGmw1nCRFexhbDHK/o1jB/p7OyC8ssS/oR/7ZateLizveV/bEyZSIZL434zYFVSsWc+wjDtFt6cXuAbXlpu9Sm7lhU/1PnasxGOmWLw1Fz38i9o1p1xMTU60X1D6Cm+AijHiWDli7dp98yIx5DNwE6hUtuB+8qdBoTjso+3MTN4qNyz84hJCBF1//nUK3z9HurUprD9R/uBlnSG3tC7jVLloj8DVjo3BeOrU7KatFgm9SHGotL89zOxpd/umUriQ0fy7d5hCwWxf6bkDsDIrSLwK/0HZ+EWzXSYdJ7TYzgYxcr02+21kWxHHTDI1m+Un5dtI9ugdTchuV0xA0uFqKNJ1AwfjTeIhOrakenZ6PvVjvti3NYgmR1OMzMdQdr0+lMCOOvCInRPqlsjU9AfjA3bcFxyvGz9zlzx+hNIV3TKELVPrlP0S+qyLSTeR+T+yBqsUI7mA3ZCJIyhteR9HBIIbtVwvaeO0sA7fLey2eWt7W4ehuxeAQ6sE9Qr4uHhlFh1ftvsr/q5xPMob0xuzARUDT3lKb40P37LBbEN50GQCRnT14EoeIaLYjcBePe5idcTDM1Pzc4KTj05kVbwoZHC77LGg0JfJtzoJEoLRCzy3TDha/MNX1QwrqIrw11BnrVx2mpQJbOSfGBZizawM8oBG8NGwtr1pUcZx13N+0ZU5XmU8OlPU6lqzyZ
 BJ3xZg/u
 eFs4bKRTHYX8SPnHcIP+u+UZZrLn+NGNJEgvVXOSUd2u30ZrimRLHOqEUHtLBR3m7HPkH4KlErNSBmb39PE+6Z9j2xhgJnKu+p/bccrN407CDFjAY8f1suvVztp5jUGxJbkpeE4XqdXn0+NczF4GntJ1mP9+/hmCzJ8rFTRzSmUlHsqIvkd7kfmvndmKBEbuCT/30sq7fR+wxFZMe/ySXw5+OG5YseeOSJdk14+wWkmoz7ulH9B+ZNPgWfjh+lxiLpsjggqEKKHJJwvs8ouaaUnBNybEh4lr0JR0kDmyvelNrSxY+y5V9tHyrirx7NPlnKWmS3iXnH/YMWJDXIABLke8LYl5VLXmYsGSu1CJGFOCLE3w/0G/R5WOuj4Dj3xu+7xOavODX/fQSj8VVVWW6nKSWbyagwtJpyeESklSMoonbHPNtK9rqG+3kg+OgWIbcf1ZMj/o22Ir8WnS2ODPAqn7TepUShaUsnqLyxq1lDtbMQXAJexVqO1DjlORnzLNSRFavM7aC6gm0ROVyMXLsPBOc5oGTt6tOGmGlAtq2kbhZzfuSB2PlLG/CH3ole6+KyOWsbW+WoXftZs15joqLOmOjsbzd9l/CJCl/odrjNZYKsuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:52PM +0100, Lorenzo Stoakes wrote:
> We need the ability to split PFN remap between updating the VMA and
> performing the actual remap, in order to do away with the legacy
> f_op->mmap hook.
> 
> To do so, update the PFN remap code to provide shared logic, and also make
> remap_pfn_range_notrack() static, as its one user, io_mapping_map_user()
> was removed in commit 9a4f90e24661 ("mm: remove mm/io-mapping.c").
> 
> Then, introduce remap_pfn_range_prepare(), which accepts VMA descriptor
> and PFN parameters, and remap_pfn_range_complete() which accepts the same
> parameters as remap_pfn_rangte().
> 
> remap_pfn_range_prepare() will set the cow vma->vm_pgoff if necessary, so
> it must be supplied with a correct PFN to do so.  If the caller must hold
> locks to be able to do this, those locks should be held across the
> operation, and mmap_abort() should be provided to revoke the lock should
> an error arise.

It looks like the patches have changed to remove mmap_abort so this
paragraph can probably be dropped.

>  static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long pfn, unsigned long size, pgprot_t prot)
> +		unsigned long pfn, unsigned long size, pgprot_t prot, bool set_vma)
>  {
>  	pgd_t *pgd;
>  	unsigned long next;
> @@ -2912,32 +2931,17 @@ static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long ad
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
>  		return -EINVAL;
>  
> -	/*
> -	 * Physically remapped pages are special. Tell the
> -	 * rest of the world about it:
> -	 *   VM_IO tells people not to look at these pages
> -	 *	(accesses can have side effects).
> -	 *   VM_PFNMAP tells the core MM that the base pages are just
> -	 *	raw PFN mappings, and do not have a "struct page" associated
> -	 *	with them.
> -	 *   VM_DONTEXPAND
> -	 *      Disable vma merging and expanding with mremap().
> -	 *   VM_DONTDUMP
> -	 *      Omit vma from core dump, even when VM_IO turned off.
> -	 *
> -	 * There's a horrible special case to handle copy-on-write
> -	 * behaviour that some programs depend on. We mark the "original"
> -	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
> -	 * See vm_normal_page() for details.
> -	 */
> -	if (is_cow_mapping(vma->vm_flags)) {
> -		if (addr != vma->vm_start || end != vma->vm_end)
> -			return -EINVAL;
> -		vma->vm_pgoff = pfn;
> +	if (set_vma) {
> +		err = get_remap_pgoff(vma->vm_flags, addr, end,
> +				      vma->vm_start, vma->vm_end,
> +				      pfn, &vma->vm_pgoff);
> +		if (err)
> +			return err;
> +		vm_flags_set(vma, VM_REMAP_FLAGS);
> +	} else {
> +		VM_WARN_ON_ONCE((vma->vm_flags & VM_REMAP_FLAGS) != VM_REMAP_FLAGS);
>  	}

It looks like you can avoid the changes to add set_vma by making
remap_pfn_range_internal() only do the complete portion and giving
the legacy calls a helper to do prepare in line:

int remap_pfn_range_prepare_vma(..)
{
	int err;

	err = get_remap_pgoff(vma->vm_flags, addr, end,
			      vma->vm_start, vma->vm_end,
			      pfn, &vma->vm_pgoff);
	if (err)
		return err;
	vm_flags_set(vma, VM_REMAP_FLAGS);
	return 0;
}

int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
	    	    unsigned long pfn, unsigned long size, pgprot_t prot)
{
	int err;

	err = remap_pfn_range_prepare_vma(vma, addr, pfn, size)
	if (err)
	     return err;

	if (IS_ENABLED(__HAVE_PFNMAP_TRACKING))
		return remap_pfn_range_track(vma, addr, pfn, size, prot);
	return remap_pfn_range_notrack(vma, addr, pfn, size, prot);
}

(fix pgtable_Types.h to #define to 1 so IS_ENABLED works)

But the logic here is all fine

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

