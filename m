Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5529CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17038E0078; Wed, 17 Sep 2025 17:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC78B8E006B; Wed, 17 Sep 2025 17:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F4D8E0078; Wed, 17 Sep 2025 17:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C435B8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:19:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9276411AB7F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:19:53 +0000 (UTC)
X-FDA: 83900009466.24.C8190E3
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	by imf29.hostedemail.com (Postfix) with ESMTP id C65D012000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:19:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hK+Q6egU;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivO8ZyXjhrVFUoG23WcAc0qIXAzKjaT+w+I3vSe6Xts=;
	b=rQ02lKN8u74ScxqCAMTqp5mL+zl2MF5nwCae7jTa5CMDRPkbG2soLDjlvMAvj2xU3Ab9d4
	D962wGocW5t28UZ0KXsBAdWQJs1JXO+Zm7o9vdrY+0lCqQmz0+HKhCFUeBuVx4/MCfpiQv
	8w4vAUEjPdPTVU7rmdNF8ZGT0hav5aw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hK+Q6egU;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.62 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758143990; a=rsa-sha256;
	cv=pass;
	b=jMgLf+EI3hQUBj3pZj+NR0RG2cUm5GKmLODXeWY9bOe7xZnJ1SkOwMrJ90Caxr5Aziz5Z8
	PBbQzIyhX1/pSn9j1FERvfsZMnUaoDm7/uF/MwjM9AMnKf0Bu/64HP0dUxCHue37RJx3wb
	/mUhvCxHyZDbbt9Gmh6fiinxxbGZiVg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbucwQ6p156jMPx3ciQbekiQrvQ+Z+dL3RrcmkhzT5c87F3RYgQFUZkt3hCP0FOYPqwBxitOVd6ipdZZdJhPQq+Dr1YLVHAdkei7f/oBbXWRLQ7uidK0A/baDUcTlp6e0GwktHIBCzO2ZTq5Oz6k4LU4Ds2Zv77M+PNbQxW21g0He//8s+jXgMYXAEb/O0IZ31mfGmho9A5ltIykU+va4QBx4lRcMjkFuqDRtC6YKlQUlPFdxPXoMzvxjxyvtyLZpCJYPCwwmhh/KZYCwAc/LFGtXawqtF8bKGIJqQb5iZ2vX7QqLoxUMP5PuUNW/VYgbLVK3iSUoirsFS0MOBUXeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ivO8ZyXjhrVFUoG23WcAc0qIXAzKjaT+w+I3vSe6Xts=;
 b=qdwk1DA90F4WE72J1gmkHq+NggjzZJjHWFSiuBUDqTEZgxKSTlYreoyc8eVITSlYLkBONMUB6nnYn+sCj01IH4M26ItbQ4p1/dhQdyV0KLMaCsllwpGiOjRk7zyWkY6+5zALtMVwvBojMfgfLiCoAOgSLJPFmrQJcKj6VjUBu9b5qLkrvqCubN0bli63djto+OiWtSsFG5q9jbsGobLvp6XYNQQY6g9ZlcTF7KV3wQfOJj8e2XEVEjTMVLw3MVNMsYw1yZUUEsnbJ9fEfeLhC4dgTUWn+BSs/ZXdFe5bwKrJvm/FcapByTBl+9vALiI309df1kZWLmHTWuyUFJvv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivO8ZyXjhrVFUoG23WcAc0qIXAzKjaT+w+I3vSe6Xts=;
 b=hK+Q6egUpXcQxj8k/004GSxfuZZWqeymleabMpEZHw3FTOWN0YshQrI6Rkxg8xxDW4EAOtJmjh1k5A48NhEfI4btDPDRM/nO91a0tpPTk7C78vGcEJ15Btd5Q0rInzlvNkYBIeTw//Ln8er7xTNVezIuNf7z/udrGja8AHOn7TU1sKJsR/Snwy6PMsKi2DmjTrA06U2piswwt3TvZW7qiRQtDQ+W6JpMAGOQtC/lFYuW/jVQlUmBXyJD2bgbwYyu46+erWMBIqfOF0P888MgZrPrTwTS9KN1H9CXM0cVO44ZqEUUccqSWiOSWH1hHx+pwNamL0vUkoGBssnBowC5Vw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB6376.namprd12.prod.outlook.com (2603:10b6:8:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 21:19:47 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 21:19:47 +0000
Date: Wed, 17 Sep 2025 18:19:44 -0300
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
Subject: Re: [PATCH v4 07/14] mm: abstract io_remap_pfn_range() based on PFN
Message-ID: <20250917211944.GF1391379@nvidia.com>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <4f01f4d82300444dee4af4f8d1333e52db402a45.1758135681.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f01f4d82300444dee4af4f8d1333e52db402a45.1758135681.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: YT4P288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::14) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB6376:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b50d17-26a3-4523-d1c6-08ddf62fed5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3B62/4ihQZDq1ff4P2NXaoccNNc+T1/KAEbkQqiDonPA57KVi7o44OWkS1CO?=
 =?us-ascii?Q?j5BoSQlmPHwWkl5sdmIPU1vVK3VXGf+1nYihDXg+x/u5W3mEub8TtuP3Myof?=
 =?us-ascii?Q?+xZIb64ySSfijB2/P9MLDfJPVhmMrF50czGfLo+nE0jFaif3ZmxiPCsRiGu6?=
 =?us-ascii?Q?SFN3mj7uyuYw+fyhNeg/D3aI98ZDLWPHVml7u0jO67x7YrIj1SY6tcCXeTeg?=
 =?us-ascii?Q?x25bvbRcdI6yK/nFXXhpGOEx/xKpqQx6Z/yt2V0cygE9OJot30w0tUEkItaN?=
 =?us-ascii?Q?pXFUnMg4RBLuMziJBupO+aBPIZzryiGBA/mEm9en7Q2DKC8R4plvax9iZ4KX?=
 =?us-ascii?Q?eSCPC5530EnG94k9/ibLeeXlzYlxCt/fDtN6BzpEU60fBGefhLcwWjXvYRgw?=
 =?us-ascii?Q?pyS4OzEl2X5uc+izZ9YbnHYv15kYPuL8qIMGOmBgiBETJz//MWbGJmOP/jia?=
 =?us-ascii?Q?lrOXbQX9u4aDdvYtjn0JApWB2HcDj5vRN2+aN2ffHtqUPeShwK7qsYpu/WrQ?=
 =?us-ascii?Q?wktj+rxBbAjTC/7ilyzCz2MElz/kvrjPxFjWtdrhQEiwfUIgRF1gEK4Z5Zrc?=
 =?us-ascii?Q?yP1oDLRC5rZct60udQvWMTFa+Ut02KHQeuuqs7eHhLFGewOHYz/+wDvTrVD4?=
 =?us-ascii?Q?NPJ8bu7EOfmKV3jxr9JkQA3oFCa08bm+WzeAkH0b+abB/RghvpNh2Y6ncWf6?=
 =?us-ascii?Q?o1E8sqVtC51Uz5uxHw9QVvW6x7fnQXQEBn9rRUp9lxsxM5PF6CAOygJoQAgZ?=
 =?us-ascii?Q?UqA0ZfcANHQLFuEs3ZyPn7ejpak/3/EW73AY8YCdJBPoImu0/D/LYPK50lH+?=
 =?us-ascii?Q?MsAJyVu633hpoH0UK4ISxgGh1jcVofsqz1ouQjp66VJsMMtkDUH7nKfxTWaw?=
 =?us-ascii?Q?v30OGwfa/BPYrVTSLu5HPcsK4CzaE1f/HKZpMVej7yuG6dN2zlPeBx0AShW1?=
 =?us-ascii?Q?jMzt1Zeqn6PcS0WP6LDfS2ysDbk0ERCXOBasxrVeQuhVcWkdcvDfvc0mvVtM?=
 =?us-ascii?Q?Ik+TW8VglaYw0KvWsViWt49H+58/tgiSDgGwK3CnNKXlNfNJ06r9f3rCrRv2?=
 =?us-ascii?Q?/hiEODIIlZkU5yofdyldhiBM41SGkUhGvdarxmLqIhBk91BN3z+Gobs1BmFM?=
 =?us-ascii?Q?Mc8vy/avgyiiP44YtPjgWOVLk97sRBLelJTlGoec5s3Y7+1JSHXzNbL19zUs?=
 =?us-ascii?Q?llTxu4SoVhyKFrxNEmREkspnK9IpNgWhaYm4OG5Ysfw/HjYytDhi65uZY1TR?=
 =?us-ascii?Q?fD9WKBL7Ai9OjMh8hOFoHftQoot6ZNVXnBNvU5j1wxQvxDPbtrLHEMso//0s?=
 =?us-ascii?Q?ElnFbQIR9MW0C8NuSsAfXg7paoum++0mYU2Bz07hV+MhxE6x4ZeSzh4IF8Ow?=
 =?us-ascii?Q?B5bKIzj41TIo4Yc2djzeSBdCu31YC/NyKmqMy6lXg3IIvE7j9OrNSvE+m8NL?=
 =?us-ascii?Q?cy7m7QvLYok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9dMK/p8Iu3s4Mgo7x6wA1TXLb1LDsq+0FSHiETRztPu4/gpLwh+kwy/Ro5Cd?=
 =?us-ascii?Q?X/bdEH28eZ9evw6fCCHtRz5HhVxYlF5AEpHD69apOhhyVSl0nFPHV9gy7GhI?=
 =?us-ascii?Q?rX4YbZqGpoEhfHGpiMXQ/NZRLTKGTJQz3lg27oKYgg5bcIruBLQHR+OxSrSK?=
 =?us-ascii?Q?PDHBQWDup4GlHaE90RULRAmmOq9CdEbU/CAdFY2UcsYO7vpSIh8sGrT3wXdi?=
 =?us-ascii?Q?VnBGTvpPEmOaZe4/qI/d+/VrvbmL5BbpUgF3XVv+Cx61TfLzBpxfS29MSQBg?=
 =?us-ascii?Q?aQ++MoAWyGE/QSD62OEqb2hsDHhX2EQIl4dMyvWMv+25C81eEYIMzZ9QyJVC?=
 =?us-ascii?Q?UPLajGKD/41qnGtpWojF3TYLSmyqGMUq8E4sXsVrjhvJGzNWR/XaJrN0FXYV?=
 =?us-ascii?Q?FneaBeZN4GkQtT6iz8ipEtc1q2muS7TprxgxHPxxPOf2a81uYkh8TExJASaf?=
 =?us-ascii?Q?I5Tkw3YHYfkWlnTNwh7dCQ1fNFeYOmrVXTZwrSFpX94TU38+EzBHwHMehlyb?=
 =?us-ascii?Q?w/BMFpfJNkaQPX1N198OH9yRroDSF9jePxulfgCK+U3MmwwkW9a08xC3Pi/v?=
 =?us-ascii?Q?gvaOiyQsSY2g9douepvybNT6wYwP7i40VEc2Td+PaqwINa9Sjf4L6OJ1wclp?=
 =?us-ascii?Q?DV5YQwQdn2OSvK4rZ2/e3EOIODyluEv4gjJ4Gq6dNbf6G5A4BZ6GOIlHv1nK?=
 =?us-ascii?Q?huQtlS8JuXZWhDlystrFuYp6dZKe8rInhCtzYuz8K2xtOJiNAWHA+bwpgjfU?=
 =?us-ascii?Q?3jODfCRL4+6dr9DfJ0vAMmyDikU1/J1sulJGdty2bCj4gs4KK1IG4Dh/C08a?=
 =?us-ascii?Q?8HiGoWngEKPOMK6La6EYO2FT9dKgb5afl3VBER5DX6oj9rIXMN3gVaCOdcHU?=
 =?us-ascii?Q?WxJTm+PAItO2gaDrZfpiuC9Q2n5Pj6SR6XI6RQ2EXG3I/ryUHN6pr2bxPtVB?=
 =?us-ascii?Q?cdF/4tWtzDttzCr+I2G8ubQc+wbRAgybexyq2XbmmjalxTuAoPwZgzSiN9qw?=
 =?us-ascii?Q?6JWFGYpu4Cj+huB3GXnShTsrQlIuUe54S0IhxeiIa91ykw5VKVpRW2u+oo+Z?=
 =?us-ascii?Q?zg3iEfrFLL7Jd9HL53tSpDi1vBbl6UC1QYYLwc/G1YnqYvhsT+Up21pGSMsl?=
 =?us-ascii?Q?GGH07A/X5qKTqgBgUesE8Mw5/H8EDtYc5hrqaimztD7/ccMZDsgFUhcPAbfh?=
 =?us-ascii?Q?CyZHcxiI31hRq1ZQQMX1oE24o6Vk4gLoIGjZWD/5JyfD5c/MAY09LYf2tMt3?=
 =?us-ascii?Q?5X6F7UQFChEhZRd96cUUMc7y9SrjHvHrXnlmPemMcOcCEschlpltk6QUlB50?=
 =?us-ascii?Q?y71FKiWeOE60EPHhReDKmt2IvaHoCQEw1VuzkRxmDB2GaXp0Rg8dxBIwyPTy?=
 =?us-ascii?Q?B55SKxF7MTyO6T/j5RgyNcmRYfCta+9NvgEaBSD1uw9bkQE/H3QJGLf9YdOq?=
 =?us-ascii?Q?b9uNObtzlNCeqaRhK8DZuYYM2SZtloOJNWqk/VeobeFHOmlQp3y+0ne/7tLX?=
 =?us-ascii?Q?7WBGeyx4sc4Y9J9CFAyFlGZE5zSCDyI21Og0PvNpfbhsRV8g50dlAMP/VjxN?=
 =?us-ascii?Q?UPD2EzBNVVFzSoIVnaY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b50d17-26a3-4523-d1c6-08ddf62fed5b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 21:19:46.6773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: be+TFSjYy8XT9dattliDuHoDgNRD7xE6VoLABPr4kF6WWTDDB1QK2yDPO6sFeLHc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6376
X-Rspamd-Queue-Id: C65D012000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: c46mpbhqi9hk8ffybgnxyeood4ei9usy
X-HE-Tag: 1758143990-476776
X-HE-Meta: U2FsdGVkX1+Rsk/bocwdoDd6pmwo0cVd1cEJZnopg/08FrNHC+vmJmCF2FgKFQV88DhzG6vX5t4jcHjYgVSmNyKp5vWjA3CCRhT+lIOwAtCO0crF961dOoHvCfTH2tgjz/h1/iMdzI4bvT148d8DCiyI9So2BhUFNrvfEyRyWxXHMQBIwBe00hUnwxrEFsiHd6vbvJiy9z/Ou2BFMKiLnDoDs6E4ANjOwUFv7ThmUQhmdldZrXrfcqKHrvlj30LlckkfTUkPYKxLJO6MsiUB+IbWSgUPopEEi3Mei/HHQZrp70siXX09nsbIc+oiV90kucRZuezsNT/Z+pM28tIN/At+GUabRJKwyXolbY2x3iA2JpH2yvn+Ie5Z/HgFLuJfZauFmL+voCPazuT45T4krsluPxe66hKOa94cjQdTBCIyNi/T+HQeoPzQ/KdldrBws1CUUaEQvz/cX2Iw3d6wP+X/2bBBLG3lS5wUbqeRnIVBIhKkZkf8XWClR9Pa9AlLMkV6MxQAj5rMzTypg7fE2sMrqnX9pRT5amFzlHfiUlB0PeMODY07Iha92vtB7c0HFrke6N7/zKzTIVs3nckoIM9kX1Z96N9A9LRyKONfH+5TT0ACZAUX4rq7bM3W1l2MUu8Ch613VxKsllCeVnPyOkNgJ1aokAVFfxxmE/iwA38YfKfjHedYOeegHUt7TOIlHkxb26nWJHaI6SBjdb25/EpOaUGW8hPytLi/Pn95mXTe+EWKeTVkXEWyz5htiL8qppnS4yuEeTjV8bUb186EumpaZRgIkaZEk/gT4HzHVGquMKBJ3HeQniOgAryp9QNFWaCIcqYpOMaM+VICsk7Jlz8z9Bas96q5H2BJSV103eWV+EtCZjy7xZxv1q4rFeqz8gRmByeiG1rLZHaRlINqVmOvs1iT5fUdFj2DTNnXBHk4OcGBOUn9K0Qv0mejKcQAPVEZ8J8T2FHK7qmtsEH
 2giMuTsL
 NVecFJa9tJssuU0dAA1s6EhHvnd2BYVM7IP4BVxMdnf7uyemktkpvit3pSJJmixtvcJCyBDSgX09G/Ki+cSeEfT8Jo0F3Rr/mAPq0Q8aM0USNISY9l4tTekbyYEY5kydSYlQrskkhmDgC1GvUWe4GZcfHOKDF2Es1kYuSHcXvtS9NrsfyEuV+QNNWP4cGyWQnY4w/6wM70aKJLdQ6PMO2YYiy6QIkcknSCEaC0B8XBsajw98ZNZIu+Ca6K9UEEhQnncMM4du6nok7HMPMDAnDEvX77/g8pmxpwSAwUKnq807vjiVQOtwhWZ97sQ8MyJPOL3OLZoxvzfFa8d7Uj50WfM3m9Ku3YeEHK4292Rg8zwdpB5q2jUI3nXrPiRXgnb7xdPrs8Al0nQcse3UDAtKjwBwYl24AhqoIgzrWwv6GC/AsVMoEKyH7sDLY71gNAomlusIJl6HBSwEp7+o3/PTeoYJlEpjfRR7ijioi5JvoyWqqPprZa43webO9RbsFFrYGlMgWoDnezaVsnAt3Tp6PGXdrMnukftRXWzYtLLmHK8wlI28ZHLPHT5tluTvCB/sJDRmd887pvccVFSj+THy6QWVuXV+1g2W8jXxb/JORpY60/WUcScehKugLIwwutDHdFS0T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 08:11:09PM +0100, Lorenzo Stoakes wrote:

> -#define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
> -	remap_pfn_range(vma, vaddr, pfn, size, prot)
> +#define io_remap_pfn_range_pfn(pfn, size) (pfn)

??

Just delete it? Looks like cargo cult cruft, see below about
pgprot_decrypted().

> +#ifdef io_remap_pfn_range_pfn
> +static inline unsigned long io_remap_pfn_range_prot(pgprot_t prot)
> +{
> +	/* We do not decrypt if arch customises PFN. */
> +	return prot;

pgprot_decrypted() is a NOP on all the arches that use this override,
please drop this.

Soon future work will require something more complicated to compute if
pgprot_decrypted() should be called so this unused stuff isn't going
to hold up.

Otherwise looks good to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

