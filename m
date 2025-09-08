Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF54CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6728E0010; Mon,  8 Sep 2025 09:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665A08E0005; Mon,  8 Sep 2025 09:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506A58E0010; Mon,  8 Sep 2025 09:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35B288E0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:24:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2312140178
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:24:56 +0000 (UTC)
X-FDA: 83866153392.22.14B7C2B
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 02BD04000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:24:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=row4tRFN;
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.107.101.47 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757337894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZOK3gvmwqWnhlifB3wIuA1W24Pi0oLtgZexkL4geK4=;
	b=VssKuG1jNHmamAqTZ4oAl72ZA/bKpa7LCp2kxPD+jxMlCXjGDq1/ZR9YOB7XgsjPKoBcLU
	6vg98OWSV6Qt++jtVVZiDa5UadXH/MpaBjYMmMY+plHM0OrM0mKPfA0oSGdlvm80Xk3G2g
	9Eqq2tolI1AkIxwPx2m87w/35/mFmQI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=row4tRFN;
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.107.101.47 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757337894; a=rsa-sha256;
	cv=pass;
	b=Q7hR6/fKMnHw8iY+fpyVumHv8T8cB8vsDrr1qsvH1cJT1DHVRfWs+tMe1oCCvbcu0rYf8h
	2/RU+jPwdlYIKA5HYKCMDqQoSZNw2Dvden1uNavowqdD0AD2eB+yaq8J+/x7rOCmRNSG4n
	joX2mJUv6FDFSzM+29JWVRrwAiW/iqU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JOH61RydzvcaeM9rI6ARSluHueDIcJYly5FkcVwknIA0GOEzgf7aLZ1S1L0ksavB2qpniAL+1t4WMHDT523Z6YWLL/6XwGJJYbsYB1HGuktd08MPLbrItI6kI39YIqFle8ruvHukWT/ZqW6MzZd4Tg/Vy8cPFDgz8gKZ7GQLGQsjjGtsK9VsZih0XOalpNs02RXxVYhhJhEVVTpd38HSN5SI6/+UDmMSO/OG9IcUPf3GdQjPm4K/PPCZJS0bATWHqp6u855ou6zwjFTt4jpLViH7k82AYqgm0knBAiV4U9CDJa+nkqKp14FHAtEzh8HBbaM6Y3aUgNlenSbpZTdcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZOK3gvmwqWnhlifB3wIuA1W24Pi0oLtgZexkL4geK4=;
 b=UWsvj69Ou1aQsVHBOCWobjFCQsIbob7DE6vin7+stpZ9kxgOd9jk8OWg1DcOhhO9+KA6Dt+hUkTsdpTV4rjgYr+7HDeQSkUU5vY6ZsYN0Dh8lJsx1OR1rChOZlGJNZkTvJXNLHoCcYCxzj7AJsmL51aLkbJcoRaJaZfb/b482xilsRLw2dQqyQtkjlD+hAg5RV4MTN3oLbLuXoTlIOKfDYLBQPVOIVFwWwcJb69N+r50p5hXKSCzCqRObDGRycT5rubpC/U08v9wnga95pLKsq2uil/ycxprWZLn8Mb4Nsrci+aMLpnWYEWS3n//iDPa8YKuXZIDIHc2FpEYdhDzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZOK3gvmwqWnhlifB3wIuA1W24Pi0oLtgZexkL4geK4=;
 b=row4tRFNJSv24bpH+I7NxMZnSY2k1N3u8JurLzW5Bn8edCLvf7s5Cd7N703DydlFbNaBOPLTN3PWrKzEB26vpBMoW0NY1Kc4l7GEVi3q8AiutVxWGwLlWxuf98MMGyA732dKMAuN/A3rIBc7Qn2M6MZygkcg72aAN5MR7+UI3KRirSLJx2ExGKIYvbvPJTvkHJOh49vk3cNrNNSW9IPwqGvIAd4hLWWUuKfvpeVtigiBOEWRu5y4Cw/Vm+AEJgGcQFnq0NLYRNQf9jjfZl+xWznnxq7Jfp/+G+MkH7JUtCx0aAUweC/IOkdSy2hk+cdfy6+FPI1R6JLbXGj2+jSwJw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB6882.namprd12.prod.outlook.com (2603:10b6:510:1b8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 13:24:49 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Mon, 8 Sep 2025
 13:24:49 +0000
Date: Mon, 8 Sep 2025 10:24:47 -0300
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
Subject: Re: [PATCH 12/16] mm: update resctl to use mmap_prepare,
 mmap_complete, mmap_abort
Message-ID: <20250908132447.GB616306@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: YT3PR01CA0051.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::22) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: fce15a36-c8f7-47ad-070f-08ddeedb15fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oPZKHxJAGK769bWS22UMAkhJgHN+y1pyccrY5DKaBgzbI+GTnsUTjrPDKTr0?=
 =?us-ascii?Q?/jUvCN9otRyNkju7bqaQ4jf+F3Is6FCSLNW3vYjDBWsmGw0f9XCCpQojTKvP?=
 =?us-ascii?Q?DhUnZZ7iwSfXl1neyNh4oQMk566NOApRdt1MIOmJCXKyJfmyVFeyf6bZcb5f?=
 =?us-ascii?Q?t4E+GHNMYdmPKNQ2/7CeypAObAzcqIUyQnA1ek9iO890CWKHO5qYakuMBqtX?=
 =?us-ascii?Q?kTeiFHxQnANTkksp6zXRbdYhz9vVSQgb6sVl8xofitzsx/zGG9aCO5b81GRF?=
 =?us-ascii?Q?aNFQugSrq1C/M+XdDjjStlk8BbvjXv8qeeDrawSWsS1sCouGCsFSc/XpOe6y?=
 =?us-ascii?Q?qgwHKpTkdxIeHcanFZMaeO9cKYp2tWmpUcSqHvCUWs8CmknSvtbV0XLdkTFA?=
 =?us-ascii?Q?4IwreVkBpTjE2LnC/KZg8FnDQPhHOO12wh0vwWRQ2Q+aWp3T0gF6Fo13YnqY?=
 =?us-ascii?Q?6oYVycx5haILgxaF7tPUVNW0AuvQjU8cHnAJHi6DkZceYPKzjIODHieRGoSd?=
 =?us-ascii?Q?9L3x91YtjOYTpjWPSFyRbuNN4aD8TpumAqPCjALVtCuB6S+KGKyAvxNNvET2?=
 =?us-ascii?Q?v7nEp2g2U1HxFbWMz2WJIhmNshtUrSsnHTLHFT6V7E+S8f9+IxTDuqFRjpzu?=
 =?us-ascii?Q?uaNKSD/+E45AXk+YPheLuzuiFeiE84AKasXTR2OfbJ2zyC2ymNkVhHt3jIaJ?=
 =?us-ascii?Q?yc9rYeCfcss7Y/k5k2FcPp/6FmdaAkXU1Kg0eNYDMLvJWUo28EJym/Z8Itol?=
 =?us-ascii?Q?z6AVfBBdv2HP8CdXaaUJlclM239HI9Q5cltDH+oVOLOAdy2rqoBSIowvmTpD?=
 =?us-ascii?Q?hBwA6XxWhI8bn81bkqQ/CXJ7VCdnsJ3QLnll0SnJ3IlDtj/Nn0ijnmwuR0bn?=
 =?us-ascii?Q?QdKmLVwis61AbqK6DbmGovnWgBErbnIr6LoXMwDB4/KUGmDXXVmmO9ER9hbE?=
 =?us-ascii?Q?P5lzjBxcAzhrEBkgiy7RIBgPJE+ThKmbSyDtIT+Kr+Oa8TSUbbcOLgeAzfdS?=
 =?us-ascii?Q?Pd+N2dg0+iZKIo+o8SSED28PVj9BHP1ZGdg22cCnwT6/fiwtN9S5ApDXpREB?=
 =?us-ascii?Q?3WUjUc2ac4uoxkU6r12c2YeKFOVGC82s2g5ofT62f33FEUo5e4XOwkDVyj9D?=
 =?us-ascii?Q?NWs9eFimI09RFWZfJRgg43hvsENUFtZFiWXsZ5nDjspedtIHB0QhOEM77u/c?=
 =?us-ascii?Q?e7rseGb/1WyJgTZOEiDDBq4k9W5QiDigp/Cx8JRhbORHsTYhTvO9qDloS1kY?=
 =?us-ascii?Q?gyNShAiTKqq91OQw3ov1m408RjUuDO3ptzYSk3ahCXdR552kcPn2uV4Cl1zF?=
 =?us-ascii?Q?viOSUVSf/lnC3JpT6jMpriWtAYcU/Cak9YlDyqBorbmz/dikSfv0Z+cL14KV?=
 =?us-ascii?Q?FFyBXsqVNEuE2C+9IClTPrq8c88/j4AYNgn9Yw75D1tGU1mguENXOfYnGYtp?=
 =?us-ascii?Q?c2Zi7ZPThVs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hPOq5cGXa+8xF8pPAdL8AjcCIuuYLm6eAWDqVUglAWxmInkUTP4CbqTTG6AP?=
 =?us-ascii?Q?tWAsFiNd+CauxIp7XOzYRtbGK/YQvIz7wkOgCsjtG/N4Wap1yJ2cFdZCtRCH?=
 =?us-ascii?Q?VEg9hoHHnjQ9BK5INxkTZ6L7AmCkCD2TAXqdiplRZvFMJpZXx8OCKey5jREc?=
 =?us-ascii?Q?XLgDd31Cf3jN1DAlMoESwp3ZilMyMz9wmg8e89pmFbruL5YLhO0kFhfon1v3?=
 =?us-ascii?Q?vuVJjogrFPWK98yWSy5m80ZyayWD7b0BNHG4xH/2qJxMf4auyEkFyDdQuT08?=
 =?us-ascii?Q?PbRA6YpqFpLFbTim+Eyc/FPiex+Vyx+X6Y6FqLLWxcBO6hZmxrGtto2jfGlx?=
 =?us-ascii?Q?nb6AaJh5mlOSoyIbO690aAgBgR6xP/Gqyfd2EHD0vID3/74xQyDu8NxpxSQT?=
 =?us-ascii?Q?2LaluNmUfsIBAnOeoz0NvvJo5+WRdBTBByahq8P0Y3MvyOsNTSAM4yj3zeqL?=
 =?us-ascii?Q?HC54qhteagR9gZwkpOH0zFRKi2WCc1pmxO7ag6HDknarrvuudNJlc5Tooc3q?=
 =?us-ascii?Q?IU53+m1RjKFfzCBY+FfobHz91gqVxdo0W5umG0mHeQkVxPYo43/F120rOw4N?=
 =?us-ascii?Q?jIuyr+84CXXR2PAa3+jdu/cBwG0JA7ecl6Fm49CbKevyeK8YXUe29E3XtHIf?=
 =?us-ascii?Q?iTspGTpbPB8gpTw37o6El3sxoWX19/oEbVhgXBhlS2EmAtlG3mUgXWC2eF0J?=
 =?us-ascii?Q?bHCh5sIG4wo8ba+/pP7vFQ3c4kRwTrsaFnoMRjaakWTTiKy1PL3XY8X1PuUX?=
 =?us-ascii?Q?+xdLy4E4kvu528Lz1Mhezv4kcnDWfv+Nxyz+zxyjGwWdDJ+ngzHdV1wTpJb5?=
 =?us-ascii?Q?jFhljU6fqNBsfrTlgnqXTyHA7FcVgBrWRxsRMaw+EkmbQPh9pUxNQZt6C8ot?=
 =?us-ascii?Q?bh3DU+w5a0cVhVnKiYu/vgsRWPJVVxG+1uo67gh+JQPkknsFtHJJXrqrsvu2?=
 =?us-ascii?Q?XXZis+v+mWMHdrcax264rFbnTYXBWQ+nooZuCpiIRpniwT35M3Z4fY5TODuC?=
 =?us-ascii?Q?x5Xukox04dmVx7QUgmUJUfBwUEcZSWWKdxbItmiVo+IprLQrCuMndgOSInKx?=
 =?us-ascii?Q?xiYmSRSk8MxsYY37C+TTzAquKnZNzg5xnRmf564O7O4B83d7gny4KiMTZXo6?=
 =?us-ascii?Q?mjNoo7pG94ONF11cTLFyUcSLxLPCQokO0b4Z2+2vCU6j1UPJGpoglP9ot8tY?=
 =?us-ascii?Q?KYjFDWpJxKxc1a4p9go3MWsTUiEPiQc0N3LV3Z3+Ixg2BQhySAVz83Msssay?=
 =?us-ascii?Q?6S4BWAkDp/HOZPDANNPImoH6A9+97tZtawL+kfbOqlIKFntWbjRA7uBQ0YI4?=
 =?us-ascii?Q?pUiCKYRhmTgnfNfn/A4cKLfokscj+apNv1xZUT26zP3HtZLWTK35biGeYdj8?=
 =?us-ascii?Q?i4ONxBNLwzkoiJCr2hVuFW+StXWryJs/UJ3SUHHxb+jWDofjpE48NKKYKnQ/?=
 =?us-ascii?Q?Fe5BhyXNjBajebb49R8IuOZhM+odthwjSHUqpu8X7jl5Sy3PJTXV8pqozZCM?=
 =?us-ascii?Q?4XsBwsAjdPttBcGVUNMDy+DB92HBSOhL6HUgrmUvsc+cIDtNM8Skms1h/X1d?=
 =?us-ascii?Q?4BsdQ/K0M2AV60Dvaxg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce15a36-c8f7-47ad-070f-08ddeedb15fe
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:24:49.3190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUX61/utz8GYeLqVs/Ti+CneK+qRE7en9MGLKTzmGxSu1WYpxtyqb0UgjHj7TOs+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6882
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02BD04000A
X-Stat-Signature: n1rejoejtp7wt7pixqq55ohmprix5smi
X-Rspam-User: 
X-HE-Tag: 1757337893-521923
X-HE-Meta: U2FsdGVkX19gfDrZ5ntXSYK6ITqjmJKohdCIO+1K6RMbFkFq2TJDKS/1t4PP/kIeiZRwxZicSEkUmF5ADv3JTM6UJd7KNYnYOKQoHj/NJEZF1XhwQ06h6w86lO7a9qNyHzAUQlsf+imRoaLDoZv+TvjDuS7xswqbyNJzGWbYESFVZksX1Y9MryZ42lzBOqxpSTcYoM8hc34LUyy3rNE3mXfgzfpf6rtFsen5CLLZmbOERqNtODPXvGjS3RLHDrY6QyRKFaIO+2oybSyNE7sK1zsu837pMdE0UQ8VsXehDJKgRg5+v2gGE4Y1EWYMWnPgNtE6sEL3ELQIB4dCkloy0enOUMYoEo44NDnRPkSmTipahBh6oUDWRmoy0XhmOmD9jAXJCwGecg8loczoYV442HWzlHI0HsojuB5klcZjcgM2eyb544RRExBAKgkgI9QWB6clNn7DnMwdw67rAkHUGTFF0x+QRL7HDgGMTa18b+N0oER1VrNi3YqPeQ2HgpUHiyztLT321cQc6xznTWQ187es6+/JLP1qEvXbpbxc69Pa5UCsd3zSjX7kJS5khyd358sklg4Iljt5VsPr2a9PAYCDBqVJiF+L/FK+1KcW1O6uZWigl/rCsEZVntafSJJ6PvddHUf1JbNKzNVojIlAa+xxMEiRhD0+t/nSmpDM4P5+E2gYppkkvdRzdkPv4On48EdSINTEQzNxQ2O6GIf+67BV1XrZuPbKS+nNSIHkg3vYccOZIQ+s0udgCt4Op0ziy3YMYvpF4k9XvGAjjL9LJPcE1phNfnhxvCLy4N4NijF1RWeCD+aoVgVSou/KiThNI5r+QlAnXKVSYZw1/K2vWcsGhGfQaXDWMy9RRzU4cb4LYT13q0ioiJPE4SLc67s6/EPwwtBfc4MakH8avzootpjlYGjCNexXcQaUnL+0yUhcj4Mxr1SNK5X2xLWYx1ddR0QIsQT6BHuxo1M2hxm
 CSEgdIVs
 Wckd4RLXPydxNprPzT/UN12y4xjxxPfY5OAHsZmZen1XL1OKc56OVh/R1dVZDhAwoV/oSmTu+ZFmcOVzgH798lfZ/lJ80GegvcR3wNZNegyGLT5Bu7P/EtEjweCMa93pCoJwqcXx3izlC2GEBrIfzmP408rho8BxtyP/ledNV6RM6dnGH0tomqWpmE3SlacEeByBKAXmJKq7fN1sRQtqIywJ5ergiYkLg++wtYJ62GKq3+5TXrcjVx0xbMVCXhOG9EEY3uw69eSOqtqV9QqbtCWII/Wn1KbNauzxpbDWtmW75xiaZqSN3mboQvyjMTv3nbL/t6koAuHYSsm+2Sf+w20+UVeKvvmDsfLZmMhIZ1w0w4nARbnUgpi66u3GTWJrIPkCHASKqv5vorXPVJavZsWzTMCpZHj5XKTykiKgu6lGJIxMT6l/ejQ3zZujYfKVw4n+crwM0of6RbbX7niWLtJPZESJZgYRVLymNjkssZxwmUG3RzX3Y5+mzJMrP7/tSeH3sLU6K4c4oH31QnJs/HEKlLpScaMsMbIaja4feGOCtkg9dvgbZp2iL688kprpfJ7NYZ71iOYPGRS14/xBjVlqSoNJQW+bfEoW7/pdpPBjCr6I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 12:10:43PM +0100, Lorenzo Stoakes wrote:
> resctl uses remap_pfn_range(), but holds a mutex over the
> operation. Therefore, establish the mutex in mmap_prepare(), release it in
> mmap_complete() and release it in mmap_abort() should the operation fail.

The mutex can't do anything relative to remap_pfn, no reason to hold it.

> @@ -1053,15 +1087,11 @@ static int pseudo_lock_dev_mmap(struct file *filp, struct vm_area_struct *vma)
>  		return -ENOSPC;
>  	}
>  
> -	memset(plr->kmem + off, 0, vsize);
> +	/* No CoW allowed so don't need to specify pfn. */
> +	remap_pfn_range_prepare(desc, 0);

This would be a good place to make a more generic helper..

 ret = remap_pfn_no_cow(desc, phys);

And it can consistently check for !shared internally.

Store phys in the desc and use common code to trigger the PTE population
during complete.

Jason

