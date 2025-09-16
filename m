Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5FD4CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D67E8E000C; Tue, 16 Sep 2025 12:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387778E0001; Tue, 16 Sep 2025 12:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228658E000C; Tue, 16 Sep 2025 12:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE508E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:43:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0AAE1DD597
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:43:47 +0000 (UTC)
X-FDA: 83895684894.04.8715BB2
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1C7751C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:43:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S4G9XcaO;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.52 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758041025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usxY/R9IoVuCaLUlcSqu7NzNmwDdBVlmd87OcSfDKnU=;
	b=fwxFnDSZvz5rqJREeyjZy+IexRxLyCVE2Kz1cWySoGod+NC5w46LIug69GnDXxGQ4CTkJe
	5PRYyX0JlF4k1Tu3y/vXF5ekkNxOBqKyn7pw6g1+txX9Y9iHAWdfXhjJEdU2gIMQnOLnas
	xIJNbj1yOotYCKyPJ9CwwgVN3uTnSbQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758041025; a=rsa-sha256;
	cv=pass;
	b=VvI+h5zqMnTZKf11AIOFLU1o7D6MOpb0frO3ihkA8JhtWIY11K1XROmWHCAy+K6H1YvhoC
	QUnZz4dwVFYHpq0Xl6/PbJFtaDrXWLo0Tr4AZNpOSsIXIZoRAg8eejz19DH4188jmZaiip
	0jiUdaPS5FXyU2Vjo+8wMCRodBKlmfY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=S4G9XcaO;
	spf=pass (imf21.hostedemail.com: domain of jgg@nvidia.com designates 40.107.209.52 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ftth4/29a7JDcEeiqqP3YvGHyTczTbv+KEAxbuz3bghVmriRK00TusxT2WNvQxQUNALFZG1qYn67uMua40pLVNX6OJ+Sgn5MI41DJyMrMieZHqLe6TwRBIaRv723XX9NEq3y+5kOFupyX8ejnCcH7OlpFnGa7LxI31alhN+NoM91si7cbuXbnh1R+/4GD/Zn3ImR7xbFjiW69ugKd2IoTqP4aZ8CAbGJyJY/xnnWfkmwic0DfXBINdxapvLQKCyVD7yg3m19U6PQDhq3aHy+02CB3PoEKChAkpqH0pUE2dD/6hwX6bdVw9CPzSTBeSqi81mxuz8G00QtPRL0cGGpXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usxY/R9IoVuCaLUlcSqu7NzNmwDdBVlmd87OcSfDKnU=;
 b=vblExU8+R1wudsYWAwvIf31VKvAu7epRAyErO8qwTi/lsYrWYEkKEVsSPLz/TYEPHnNabLkmYjbImhsqmDcgfPEM/EeXyKOLyQSOCT2uGxyF6OtGJGlwcfM3rz4fkBQCswUKmiIkJ66C4uUZn17keqqCYY471SRoD9aRuQERaGwsQZzCQuHIiXbdc5KMpBEe75iqL98luCfud258tzLbQqa5DMrdnu3ttg0Urn07vcv3eJgP9AQmQVEsiatZ8ZEV/QyctpNKFQMOda1hPD4e6aqV3UfQkPcH2/jbD29Hul/7KCZsZrmE1FB3tjLmduJ0Wh9HVi/JXfpZ/NhVDvCidw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usxY/R9IoVuCaLUlcSqu7NzNmwDdBVlmd87OcSfDKnU=;
 b=S4G9XcaOxIgnXWkpPLj0cJVsKgX06SZCpW2XMTpxUMZVFyY/TnoXBrb9gucJlUZCUTo3esvS0itCJAyHv0GvR9KOu/ED+Jnx6mJAL8JJnZqNpTg+BkGepgc/Ac9ebUnXi20r8cg+cfs5XD8SJgEPRK3YJ+17KU2VAvROahvvCTBxsQdX9zefb6b7sR58weGwRJ4tXu/ytFyhyNulajzI/vhke+zJrtp/kvahtQLRkQQSMFV3B9v0X3L4lFi+khOUCo1Y4igTUjfX7oIbyJXT71SP29H1cqZMWAZdcVHFSA3bWKllEIamJ9XFMDiGtuN2fx0aI2LKQCA7XTjxjA33Sw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Tue, 16 Sep
 2025 16:43:41 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:43:40 +0000
Date: Tue, 16 Sep 2025 13:43:39 -0300
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
Subject: Re: [PATCH v3 02/13] device/dax: update devdax to use mmap_prepare
Message-ID: <20250916164339.GK1086830@nvidia.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
 <bfd55a49b89ebbdf2266d77c1f8df9339a99b97a.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfd55a49b89ebbdf2266d77c1f8df9339a99b97a.1758031792.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: BYAPR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:40::29) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ab686af-c530-47c7-cdce-08ddf540310b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UGluIaMn1roO8kS1EOFzKjzllrGTqNtjKJx96SEchbPuSv+AtZun/VdZM544?=
 =?us-ascii?Q?cgu4ZY9F/svVvdAbDlFh59e7npgo2nSRqwkybIsFJmGhkV2T7JvUPCjQ6Fw1?=
 =?us-ascii?Q?ikW+vsbqdkD1I0j93Z1Meyx6UasKR2dI1rz9nE8pQFJIv/a4gXvvclrXgNdc?=
 =?us-ascii?Q?jFg8kl9UnXHaydb16c00f8rB2vMzQ9RvZj6YzNDkqkVPfqohZf7H1RUha9Hi?=
 =?us-ascii?Q?uWjbe4Lmf4DnyCOT3C1uWVpY4hwqS0kr2jy5a3l7v8hW76o5EhpNvH70+NbT?=
 =?us-ascii?Q?EAyYYXN5yuwtEQ44BktqXq1VaN8mqRN1k/6bjQHxQGNV9NWJ3sMINRzbwDca?=
 =?us-ascii?Q?kc6zr8FFmcDWvxLeF7/ewvo+Yk1xfsjjivOWzwZ7te00uA4jE7am1HGTLolR?=
 =?us-ascii?Q?lr+yjqQK4YGfrUHLoiiErdUbGuc7dZXgPN2ajO9InuOE/1bpldkRKS3hzaIf?=
 =?us-ascii?Q?D6pFF3AyUbaFtvf++XiAZclV3iwovr8C6s1xMoIuUnVAUmtzapFQ8emBNCM9?=
 =?us-ascii?Q?ouuM40ep/53CHf5jkRIVObebRKMPYR+AmjgxaLpvrBSumXJAHq52klIPx4hU?=
 =?us-ascii?Q?rerYMHJb+Pkx7zX2Ul5WUzpErh0HRY82utcaTEkj5Xow5MkeQrKKjJdftylO?=
 =?us-ascii?Q?VU0lCe/ioJvJRnrnAiTaqs8N0DoXLuHUiX+9APNN4V34EkuYCrVpsxd/tlm2?=
 =?us-ascii?Q?V97hPPW2HYqQbBXsqXReo+NBRI3HVBXA+NHJOV5WXPsH0gg5zuCO1MG2HE+p?=
 =?us-ascii?Q?xijAWNGwfz+1QfbPNlLsWy06uQzTg89WAMSTO8v0SERoyJgYyhCM2LClbU+S?=
 =?us-ascii?Q?ceTfFBc8gMZumbJRS8odYT/cS3XaB913EOS+1DgkBAIXnTlgAN/TY4votKYf?=
 =?us-ascii?Q?AgZdbbz9PXpLvaqKA7191bbbMkL+VU96BsRkK2yJvJnJGlgDQxvQ+UJQmB8z?=
 =?us-ascii?Q?VyvvWnXTXsOxfLQ73e1p8QNM+HGjKIxAm5UtrBaTMnMwTFFbkPUiv8hroqyD?=
 =?us-ascii?Q?xaMwr1QY7+DKtQhb539xtj5qH2tr9UJRYfvhilXFUFEAW601mqyf2kby5B6X?=
 =?us-ascii?Q?E+PytkdyFMGEhN5DgDfvcnZzCOVWFH+zLwDScSO2KRmITmngErRMlfPYNDp7?=
 =?us-ascii?Q?TjkCib6XZnBY+vA1WIaR6WfoM13Pz0d3yVgWxu9gMiA9zdmGYZTTDivDn/zF?=
 =?us-ascii?Q?4iMZv5+nrVv8woWnwQzX6gh9m1QF3zmEr/9FLpj1ZqLc3r+1+HCM8ufsgg9z?=
 =?us-ascii?Q?hystYcPYivMw52bGupmncvLhVH/6YIXthijEwyxJxxJTUnMZ62qfp1/2cb5X?=
 =?us-ascii?Q?dR9R3s5WzRsSdf2oi1vg+Bs+MM87O8/NpiU0+l+WQ9kjLPvtIml9yRu2j0uE?=
 =?us-ascii?Q?ifEtwUy99QAZi4YOFElZ/FPwalgYpi4BeBGcSOYV0cwy7sCV4xBpFnKI2isB?=
 =?us-ascii?Q?RsnsNAt+lCY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hdbBWQFOj3hx68F5NsFguxGdZyCDMHCWRUovaDtuKA6aAfxrUk1+x+ou5kZN?=
 =?us-ascii?Q?lsUpIO3ubPxX6coomqijwWngVpJ0oYRaRQFEBH+RwpJq7Nw6r/ctM5cXavjD?=
 =?us-ascii?Q?IM27x3Ncqd5M+4vEzqZfl+xYYZco6x74c1doFJxa4kU/cWfKntr5Z+WN3zpw?=
 =?us-ascii?Q?VqMIi/cauFJ33kYczr/PH2T6SPPClp1aZ2W0+m0rTB2ac93n+Iew5kt+FzHO?=
 =?us-ascii?Q?+2mI3FOzD9WBApEcKfuAlZv5qWHBhSjLhGvqiCm5m/q4Usd4Y9IGWU4pSI1E?=
 =?us-ascii?Q?kGZJcLUFU3THlI0MyMol+YCVes7d5juiHLeR0Fm1Lrt5pHwwqJLPdBe5WfwZ?=
 =?us-ascii?Q?1bDLTMhaukJEg3Nz/sxUIvQa9kEBc56bpWRi/EVE9jDPXAtSL5TutLyfay8l?=
 =?us-ascii?Q?AomxI8Qyaeu+bfh7mNxKaAC2Gzuh10D/p/Q86JAiaSAMS/YaS9Ah1iiVmiFr?=
 =?us-ascii?Q?zkWZlM/VWTXwB3RCyOPvOrhsdoEYYvbwQ8kHi4I2z89bBrECzn+9wm89vfOn?=
 =?us-ascii?Q?DL5UlpDEFgq05hu/vxX/VyN0HiJC8PsMB9bIF30NNKDWrhDGKFNEhdS8dMD1?=
 =?us-ascii?Q?SZEEyfArsoD+cF/K2fxCarbM+qUP0kilYhI9WG2sOFVAA/qbmcV8iBOkHfTF?=
 =?us-ascii?Q?6ov+jRQpdzopCOR05T6qm5GqXrQBEwiAFJciLuvsUSkN74m4pvQVukAcz/AR?=
 =?us-ascii?Q?Il8N3wYX5OVVxGhP0T7J38WR50jnrYaQurouSovMhtSmUAZ9cNAqfSm0BI6r?=
 =?us-ascii?Q?QTdlr2HXqgJ5V/DAcTtx+2o+QLUPybmMO/t7eUWvyfiPySw++Unw+6PqrLLU?=
 =?us-ascii?Q?DxcFExkFyOImYnf7fG8h43dqM2EOCqhiN9IC1waNmWQOm5p/ZxNG3KleqF9z?=
 =?us-ascii?Q?A/LQa4FrQRy9ZDtezROYMq8ZrRauenmLG+hMruKHTG8z5UjbJfPPyQCeAG5B?=
 =?us-ascii?Q?+Dc/mAlBDYHFbRsT2axT+qtKsVE5mdAdMTxpXgpRW/BgQ2W3rcfBHyKCZ7/e?=
 =?us-ascii?Q?U7wojseLi7z/nKKjvWQqDwcaM1lvPlPF7ekBLYMapS8H9+p5cOrYebodEsxi?=
 =?us-ascii?Q?pCCLWUBy5CqyE1e2ugggNp3xhiv574nDerozUlmsjYEmxoZeINpYjx4pn27J?=
 =?us-ascii?Q?T1nTEWIeIup4KAxsiyImrQxfVewi+7blLJ5lHv2qHDXYUuQ+60yVZ7j1eFdB?=
 =?us-ascii?Q?rn0gXLxBVsrfoAh2uHrIrJTHNWJXWsOcthgw2avc4eoySGL+hIBN9RIhddcb?=
 =?us-ascii?Q?iLqazghcDvz5/5jPAJNOZuYkHOZJDP9fUSShT+mOf1FQYhMGOilYK3KAqZDI?=
 =?us-ascii?Q?/H2fRMkmsZRhohoJBPRPtgnPd0fW+aH/7wZmV/HQwoaIK/ddtWrhnXF/NsZ+?=
 =?us-ascii?Q?8oNhicYhAqCZLI0fyw12rfRwACmJ2xN7LPpZ99FJZGrzLd2pe36diTA1P34+?=
 =?us-ascii?Q?02J/kEJz2mF3MpCa+K2ulvmKRWgOd0Vs8if5pQPapBtmYeds4o/cNOHAkegr?=
 =?us-ascii?Q?cttW2wJBCgtutPRR7fMPF67bKLKubMcfnKw9dIv2p9kPFLmcnzFRZuV+XCaf?=
 =?us-ascii?Q?PQg1vplmxlbNG5xwUhsLuFEvoYK0wQ/mC6hhz1xD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab686af-c530-47c7-cdce-08ddf540310b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:43:40.7498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bokguXZbVGlLUUAbJhMpWJWC1WOdQHqQinZUArf4K68juWQ4bpx5gKV9yRZlAlni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257
X-Rspamd-Queue-Id: 1C7751C0008
X-Stat-Signature: 5ckfzrndgccgzkhdozzoakwurtuztuy8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758041024-600221
X-HE-Meta: U2FsdGVkX18lZEtgngWvy+XxFdDKCT7KJ6sEhW1H5TJMdSYq7ukH6RBxlhRp2ZDPC71AaSdlLxPKUEwUi8YZp1+GPIxiJC55dMDsnutLMW7+Fvnc/BTRSEVkpifYiA3eYoKm0IPH5ZSxduT2X6scpPniCPUmNldbt4tPNjs6p7MKHue+CpFblyzYIqwRewbEOJ0tpfB+DSmDIb+I+ybuMDY+3LB9cw4G8hxkesNHSFN+1+NmG4wYnUPWI+G3TpXPCz+Gwl+Cv768Hg5V2w7PJ1Gsh2Zub5XUgrhTTNQXWY0F4EV1X2+vnwLe74tBHyAmEa+hFiSyUYGRRrm4xG1fMfUxOqvKSpv71ecEd86H+J0zjS+HZI79MlmpOxnjKCtp+VbzY93OYwhdqOa6FaEpopsHdzNWfElXzbNgGwuz723S5quqw5aNuZKSUXegWpX5gO9gGssy05hU9mpV87+6CBDfChlBehVhui60YklFehmHFfqpakR35yEoEQ2aQtuerqZecaNBOrrcVRFF/lbx3w22kAEDVHDh+3xI2LTqyxiI0rvt5XwWChhi5Z+ds9H/t7K1f2MaSrS5EZJxNPVL67gcJJXum5ots/Dk4zUN17+/YRSRKJD8/hJeBFCiG+G1fgF8TpnooZAXomDrZxo5qMzi/SiJizSIopXSa8SBPy7amZTHLyErbowZCt6wyromdQxMupdtdeStjYtLPShJPQIceAgv+GHWv1MLmNcnCIFgc+xsQO1uBWgRwjXZxtNlP9JOj3dMMeCHXNNagaNv3dOnyprJf0oYJjJyfXvDW6k8THMWayd8LoLxflFrnmB6VSozF+VMXMy55UnphPk3l0Uq+fEwxpU59INz2zaTjmqJLyoq2ljDDJ3EaeESjVFAwWzBlwHV/u428Cs86mc2kr5BfVr64mGIR2L9RwZgedcA9XNcD5FHp9m0OfZ8N78GMwXVKBU4MHFpokjDp6D
 /NlmNaAi
 rzeu5o3jsOUN5KJG0xdBTfTOyFmmtcq113zrCNxewcz08kAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 03:11:48PM +0100, Lorenzo Stoakes wrote:
> The devdax driver does nothing special in its f_op->mmap hook, so
> straightforwardly update it to use the mmap_prepare hook instead.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/dax/device.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

