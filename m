Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0618CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9268E0007; Tue, 16 Sep 2025 12:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580F38E0001; Tue, 16 Sep 2025 12:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448B48E0007; Tue, 16 Sep 2025 12:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3217F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:42:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA1C31DD768
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:42:41 +0000 (UTC)
X-FDA: 83895682122.17.8842E7D
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2572DA0011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:42:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KYR5s9rN;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758040959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5KqOnXqPOMSfIQFsq0XS4880CpWNHNyboO2Dq/ZbBAM=;
	b=WAz/i9ZfDmKXm+L1CBFUeS1yoBQz9seLC7qHgQFT9jRIJNs4Pr8yicGiqcjNRBB9C5lcUU
	GCEwdN7/cjy6Njth9HlzprJ4IRtUKh4fLdErfwgvL98artARqTvYGRQNYubIOSqLcvXkJD
	sv0wNu0vm/BnfLPkNagwxzbdV2wjTP0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758040959; a=rsa-sha256;
	cv=pass;
	b=Lc40vxMfEUtwf3WBIk8ueZsDHPwZ8saEacjMAzne2mQetBIseiLC58sC5L3ThDfrGPFA1m
	dFicEQcHfPcwWyxEawaOJ4LMPSMCEFeSoXPE1FswnFzKxySAad5Q6ngTNeH9j7ddrRQc/Y
	C/38WHPa0Zu167bDh+5iD29rWrBJwEk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KYR5s9rN;
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2n5dOzrM86zyEcyCLmjnRLDKofZQ9K8KlEUTKMlYD+epqj3uI0ytVz03hgEnDyj1ryrEhGBQoE7BLDZ7QMqAdr15WJ2D1YajkigxhLq5p29qFRGWqZhy88LikZfn74zwPx5YtEgcyQ4UEIKl1cSJHTNGc8ON4IPDUBwI9E4UFGSszMSh2C4o+pAbCIU7LtZrGVBI+cUqRJGgPt8kSKofGrE2P5ww35uqOmz5jhUytIsPlYoO34Zx3THQ/1yGIMc5Fwi9OxmfNuFUsw7kPZbhsFwmk7vkGmVoZd60I+8z4AJpHjcdqEOwHubozlwl5IA6ZxOUU33TdBj6Y8me5VUUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KqOnXqPOMSfIQFsq0XS4880CpWNHNyboO2Dq/ZbBAM=;
 b=W1ai+o/r0sIYXJ7R2sugxO8ipE3NS85sV2gbxmSxDNpvOy+7EyaC6ICDREDBvhSrMOSt6GS2YO/ohUCqtPByjHb/n8dyRJdt9EAiEy1uga7xRs3QJ1l2p2283aj49tONNmUiKoRRwTbjuNuIntOb5xEkJ3Piz+YVx7Roz/uH/6WdQl65+4O70wIun1tfA+UEXAPnn5XywgnpGPsG71ydU5UJy0/JgoB52Izxmp03ZbO4GdF6YtymnUOdXp14m4neX5wAfi10KXate0NxWCZgUKHff+kWcSvW7wPuFUj8vwbpeEJZpaOrZ3Yy1yjz8wmddtjQXL/YGj+eKLPGhaSKfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KqOnXqPOMSfIQFsq0XS4880CpWNHNyboO2Dq/ZbBAM=;
 b=KYR5s9rNMdpzKOqNn6pdEUgDcOnI+cM5LBo4eyCE+pKgjyhfR0tV/pNErUkGG/wJj98dhTu+g65QAs8jxOBRSTritWDyUPcgt3xuN7ylBG85MLmwDVlFdxLAQwAL7ixXUVtM939h3zktlHpt+VN/LyEOTA60TXTYAOKGywGJkeE3Ol1hkgjdzzv6k6P9ZdvyjlnTKrCEEBMMbFKAVH1zZSjkITPT18HlQdRNcjPgr4uEUp83W7D5ZmkQh7zMpXa7oinneXm9KK+LOamRULUlN2gJjuyyP2XfLpXWxLLQZQDH3GLcsAETSctgZX7jX2yMt9E4uWR+MnXrkGF/qHxPLg==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB5595.namprd12.prod.outlook.com (2603:10b6:510:135::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 16:42:28 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:42:28 +0000
Date: Tue, 16 Sep 2025 13:42:26 -0300
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
Subject: Re: [PATCH v3 01/13] mm/shmem: update shmem to use mmap_prepare
Message-ID: <20250916164226.GJ1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <cfefa4bad911f09d7accea74a605c49326be16d9.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfefa4bad911f09d7accea74a605c49326be16d9.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SJ0PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::24) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB5595:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a7a71c3-c75e-4ed6-582a-08ddf54005fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sd9HXtsSlL2q2iqz6tdA6IdfRyxLl9LC6bhDPzFsJZYBByVHdzKGuxc33skn?=
 =?us-ascii?Q?N3MDtde+VUhXvbZrnh3ySCtZ4Z7as7G5S49fBq32eJA0gKLK9GJfNNuV1Le/?=
 =?us-ascii?Q?Uz0H5krl+XdKEZkJYTMt6W032f8TOejir0+BYg/TjcGElFd7GTtloIjGF2qb?=
 =?us-ascii?Q?/tVx3f8oRSU2wM5XhxFW9Yp2uKGyYAxothr75yAaD0cYOD5tQ49cxyjZC3Am?=
 =?us-ascii?Q?Da5rzO2O4duwYBY9L6bK+G2u2SDBSbpitQ9szx76SMTyichn0JjqGIYo4nHz?=
 =?us-ascii?Q?Z1hBWSGhw/H35WnpCafgv75lBEsDxuRDgdFn9+zWeTNbmLLG5B01bm1Ykviq?=
 =?us-ascii?Q?/om3Do4TDrifPrvypuI1Lk0pnnL2ghRsGvXHcVvxuepKDBEf8wsnz48NNnAZ?=
 =?us-ascii?Q?e+8YrlryYIcLqiP33t8Aetpi6DAqEXsp+U0nSFXuFoDNADPmc3HNrhhL0viF?=
 =?us-ascii?Q?P607ELh0VMbxD8fJnBuLieIl/0yc8a1UyOBCohUcz6pbx70NFd9y67yST4kc?=
 =?us-ascii?Q?D4U8QFaIEWUt3ptZF+guT/iXFEFDQveDkiDmV3rkvKvLD40gY9xoISMHpcWY?=
 =?us-ascii?Q?olg5sjsVzCkT7DaVumkjOwTgO8g0Vk5Nr7xCSoBIibgZncdvlpN3Bt13S0n7?=
 =?us-ascii?Q?86mBWv+GzWfRTk8U/+3MRiM4vLgfSGdz59p3zEhDyylN926UiSwTNEoKFfbN?=
 =?us-ascii?Q?2BIaRXDCNJB9/eQxk+UY3AEwvK2EtXo+sj6Qa1TUV8YK61G2orgNjaMOlHt9?=
 =?us-ascii?Q?iFDadk5g072nBUkUGhfPyGIiNoOWOZ/uvJfS1//Ucz1XBekdzpPPVzdOtKE0?=
 =?us-ascii?Q?51lD3kTRi3GvWVTX6CYj2iMlL2j8JZwp5Z30P3PQoRkfPP+WzDrCo9dov8F7?=
 =?us-ascii?Q?qIe8eJsqnbnpAKFNylMVf2aJXZAI3KShG4KzjHj7vcB5T52tziH50F1LbBEP?=
 =?us-ascii?Q?UbZX6NzPrxF6mfOoGFaVVqMO5+H3Zny8fr1YrxjDDbZH7mMDmwGHS7t10lJw?=
 =?us-ascii?Q?/AYSOxmjv2sZeslSYn6ex1nYc9qQ03YVN9tO4BxG7RLDerqRqS3NhfByoBNl?=
 =?us-ascii?Q?f8qa8b2Wdq7LCg/QW/P6ngmxGni9EhzI2X9Na6tAQSvZavdRKe3dZWK6wcMc?=
 =?us-ascii?Q?DjCSx/dtqZgN358Ge8qeIReU0QOK+q5X0Z/B/s39k/ixQ6HeNHUrnG7pesFn?=
 =?us-ascii?Q?C34NNb3FPuR90Vnd4gUEWV162KgQn8IegTuXBEVMgAcusgq9+QNcb5dDZMHM?=
 =?us-ascii?Q?rOpZSl86NtE8iNaVWh0+AiDCg12zChA9kQnz2UOtkXISjrxfcRiCYkJ194kN?=
 =?us-ascii?Q?I2M6YL0LjBd8oUCGDnprdV+Gbl0BgAukywog5hR4m1l9Dg7yTVhn82JQQgyj?=
 =?us-ascii?Q?UnUAC1KfahgH8aome3Dmp8cDZIyiTURyUq99zdMwinqCMkrpzENTHYz6HkGB?=
 =?us-ascii?Q?EwfjScWUjoY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KCdByN0QhiLb5OlrdFihIkThYGoggvanKwgwW6C/AEeZA9JI4fe+kyWXV0tc?=
 =?us-ascii?Q?CQwgjDNbrRKdEfCExBYQYlx/AZGuC0skyFsJJjy/v9uFIp9bjhDT1HMMvwdL?=
 =?us-ascii?Q?n5/8RZDqoG3yW7n+mqEHj8WVaW8eg4ccpB//E9f6ip9m3txTKPP0AvrVRRX1?=
 =?us-ascii?Q?E3kvrf3Q8Qt6QrS2M02BO3fPFFAGLzqdf8tLP/Pf8cI1Eyl0KT9GyaJH0cdU?=
 =?us-ascii?Q?4Tq/otLFdWAwZcsa4MG7Dc6tHBSBuWah6YdYJuvuOo1RKHG5lagQ0VBWRJzy?=
 =?us-ascii?Q?izO15eskMZYHl4x2YMRghaHg8bh/9JpOgVaG7ho1Yikbe8VcaJVNvEQuDEDP?=
 =?us-ascii?Q?zFlP9fy4IaUVoPN3DaPvWQnByu92G1p5jfDHAU9UEbry1EAf65uq9MG0LzXC?=
 =?us-ascii?Q?sAgkO9c1d4HoILXkNWyJ10tO/3uWFzh3ikFNQ/UDOTexbFeSrL3dBBzakS1F?=
 =?us-ascii?Q?b5v/B5I1zk78e7sRBWrJAF+PGF7+jlnGxKq2koP0TG9UfRgGuRx7ihNXcu9T?=
 =?us-ascii?Q?+PL/q8gGfOCkrgUyZuyYHVE/wiLUOwwqaFf4beBEVE/raXCpY+62X+iD1Qx8?=
 =?us-ascii?Q?ghRaGVqctyEv8mQL5f01Ur/gdjYQDQdh+oXhAiNtTEnYaQFtcT7aIc0DjZ1h?=
 =?us-ascii?Q?GIiGS6pjU9MaXF1PMzeYNjvmur3roceK9LamwFlu3mDGya++nHiom7rubG/y?=
 =?us-ascii?Q?YErLy0heoFZh+mCzY9coLvCuzFzpW9+JNcrW+FaTtONTms8kubxNdhXoUSOf?=
 =?us-ascii?Q?cBs0kfGakMCtUAH0gGb2ujM4uwE0y9dnSi9xpdogO7AWeYMigncHmgbSWUJV?=
 =?us-ascii?Q?ESsNII7IC25JMEvJ9caJp30RzeNwT9G6TToODuwXQ+3v2szrk+fwJJMNg4Xe?=
 =?us-ascii?Q?/ixL+q3z/slu0ZKBZDaKNuFb/oZe8NW+4AVlQoVmxGynjPt4f8BkBisrDbyM?=
 =?us-ascii?Q?3fQzjJfTCYtB9sQ6+JJvqwbMJvBgE1UEz2H0F7NKrMuPHxTyPUTtUcNxrNRb?=
 =?us-ascii?Q?/rHgU+qrscgSCOYmvhjTTDoEvi0LpAxxvUR9xSuZAiB94VrIp33AkW7Pdg9r?=
 =?us-ascii?Q?s7skCHxIQYdM9/mgoZ03IPIvPaWGogksUKgM6CeV77xbLoVGJmPcVbiRBxFv?=
 =?us-ascii?Q?mafm4mvz9T5KZ/dxfMjxfp0e+akAgNa+xsZsCfulFWvcnmN/0M0Aq0/xH9En?=
 =?us-ascii?Q?CfFOcHgD991cK2ZWGSxmA5iPPHknsxkmNsjMG3GzpOf6e1MJfIotfYbTcRHR?=
 =?us-ascii?Q?JUfbhgwf3TZRUiXttt1Xf7GWf+rCKTgRkM13f5osarsnW0mdyLDbhmBG8uhn?=
 =?us-ascii?Q?5PWGSADPLywiFADwdB/3kvH2OcGxNzcpd7dsGzkpVLgtpVD1sCq8BjmSLfu8?=
 =?us-ascii?Q?asiq+y7YMnWJnWBTbO2lNQMD9twkDIEmlN3NB6tVO459qKDURPfCWb2tQqb4?=
 =?us-ascii?Q?7xeU1aP20577e4+hOJ46LcteMUGEPwgXJ3AGWb2f2jR3ZTo9ixnJi7bicuaK?=
 =?us-ascii?Q?RRQI4WKC4vIIGJNuKDxPx8aeTTk8oJKwxRCJywH/alt+n8GwCFQ5RE8k7We5?=
 =?us-ascii?Q?btTXXd6kHZ6MGurS5gXx0ci0q6fOduOYcr5DovbT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7a71c3-c75e-4ed6-582a-08ddf54005fc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:42:28.5660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +m68z2J+2A1ECjQmSxhoqHS3Tot4XUstM8P4PX2h0vZRSZH8DRgZgHixl2Qsk65C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5595
X-Stat-Signature: uagpurmsce7ry6g8jfqnyom1y671xuck
X-Rspam-User: 
X-Rspamd-Queue-Id: 2572DA0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758040958-466623
X-HE-Meta: U2FsdGVkX1+zCozKnxkbCPJb/zSs6ee64ZkMGiJTEezhiDigcYDCbqLQJjLJD/ZvNj2xSC8vcYg+BWovhr6+IgJ33JgQjKYSyVoNlukU2siXmA4kASGaR8Mu5EkARPm0WzAxuHLXyozqGLD3O3c5rkqWikPTNNuaPYMPRShVUmgMcXRnF4LPGTKGzGMOWhEN+mbo6RFFonp7N2xOiNOsr1q55AgUnYvRSJQ5Be/kbARxo0Z6asd5D6XhFt+hWxdi3nvIMRXaEqUHpW8cfKAlVMO0lA7Fo1nV0WLUDxr0fBWvLh48O1gD11cN8sAd1D/bYnQpnwOemkps1eTtDIqtZ1nroLEUWG609nhQz5HwNaKn87u9mefvoc0XlKixOLho8MC89w9V7jD51Hlkn3ekX3X0bEyAUpIeo4n58/1LtkuzFoWt5YRdrL4dwNiNBNSqKMZZiWW1M+jmkN2Rz1WDtx+ozrinxhnezzTvv3uVuKIbg/fA+eUnNEkAi+FdlxbqkNzLpKdzu2N5Xma/WUmxm/fP3KJNOF7PD/Vt43mV+8EFLEUICKiwwTYtsJQDeajvD7qmpgtAt+r2GmnpvyiG4b626mLqLNJzGTXce1wDaGdo7iN2odalygtCtn1B+I/u4+m0suBTL+RX7lftoq++Rh6trvZ5ZdD0PPFY99XGihFLuUrG+P/LlBTRgFv2EDnFQvN/3aUSQYcRmKwUYdksIb8p9fqhbpHSHgdsa27K0q5APIO8dxm8ttXLAmIDupkYYKi2N+vWAhwfpW0Y9l7hOHFoiQTzQ/MDJA9wO5jsvpWJ1OBdKOf3rheaCXaeHYX/MKUUuXKuCLDX5BiYkJTnHvxMXGub0+jdi9WBn1yAFe8MzBP+U4GDAdtYO8lX4PlS15JYNB0oE8VcRYX4GFk/jj3zlrxkwutVLIXSKiHqlxSAQsQtdS1+G8BUwdXPzjN1mLvVQarlmRjXbyfXUKi
 zyDp6iQj
 rXYDa+yaecEfF/5mS5xQVQQM4HsDCc7+mrPXH+Z9AjH7KsziDMuNwS7mF3UyIIqIVYBQx5ZQABnwceTSOUrz7Mj9MUCltslVkw1hiCIlzBBlQaucEwlkKTQwhNy2qxl2fByFMV3hlQXnW9xys5BmVQPuAmxiZNddx+IGdDBFXAxoQ+qs9kojDLnqiLSvtMHgTVFgNm/mbKyqWsBAb0GNAL8bl6Bo6EDQfBljUewNfkeUhnG1Cpb1gsKTr3zaayMwmmG52aNFsS4YmHIGm+v2thFvRxHjurHiCImYA7g8viB9Dw/PP6i5MYycXaW7DJZNvYqXRpSPXAaf8QmYdxNqpj8ad9AP0rilP0Zttw3RsmUvDegYcrrjV72FxhU4AZzm6FUDFLpcJjoLgtFUBzHdZrjkzOJdOdPGLa4qWj5eUKp2LR7svsLqj2omwAJkKk/dMYlqMlCrhYIpG9ZAvObnMfYSNB0jMaI9KlcG5dabeRu2IyH5OEF/2zF6rBx+zsSjxMd5ibaXuExlz1/92bxNJDXjF8HZahFNwZa0R/nv1hZDV2hVJFPGveMCXFZTXVVPgt/aJHihZXxRWFxDdRr9V9qiuXHtlC99EmiS38B1hxeZG4ioXw6N8j1rR6MqA89PUXofZpoVHLcrC9LQVt2iBk1K8e7fc3al/DdG3FjBneiCZ9ZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:47PM +0100, Lorenzo Stoakes wrote:
> This simply assigns the vm_ops so is easily updated - do so.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  mm/shmem.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

