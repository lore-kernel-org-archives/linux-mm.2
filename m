Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7A2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6306B0088; Mon, 28 Sep 2026 22:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7607A6B008A; Mon, 28 Sep 2026 22:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9A86B008C; Mon, 28 Sep 2026 22:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAA66B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:12:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 902F2A039A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:12:23 +0000 (UTC)
X-FDA: 85265175366.01.5FEB59C
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9640C140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:12:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nbSi06Xg;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790647940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rvbe69xBIpzGsOrw6VbYQRORSyH1zSp/rLtFmlWZcCQ=;
	b=5+RDB+7uQhtruof95ReEKYvLb5N05SVL+qGAA1/mlyzB8oxtGHPWElCR8ifFM8fUa5u1OD
	n/L3gP4JrB55/FMPuPe8zv/rFMSgBjuVpGRjWpCjbf8TPHbwrRzCV7LUPjBnv9tX8eCu5C
	gw3a8B7+pAfinmkViG2f1tOCuVahW20=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790647940;
	b=qM1yYZAiiT+OMB/85+my4NQ2/K38kfhpyY7A6D1wxIVM6ryiw8tc7h540vQvU0OqWCDN39
	kcpJcBcBOorOJSZHXGIhyuE8Gd8rbqG6NeJfU2EWk70/3nSEBKWLXmuDukdYPLf2gsW+3E
	Je4trBQI2SamDk96iqiITqg3xcV8GDw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nbSi06Xg;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=leeJ8nG6kj+Isq6S32I/3jiDio4VD8pSbkms/J2QD/IoX8aLjHdso07oB/5c35shMYDpTwrel4o7mU4I1FWDN1AFAmeR/3R/NWNSVOl8pcMqS6kOgC5pT9tYA8/Ofn+tXn7rhqOudPS9JUhFuMNxboeOVhrACy5P6LkekpgZv3i5dw80SaSNAGPAMLPxZtg2+iT2IQxUpebjAPr9T0CIrXgCYf8Dqe0eh0+kNpenBcJ9k3zaXNia9AT/8Ieewx7u1VGQb19YkesBEYCMdnAf9p6qVUTkQHMWowi+2t9pL8nWE5ZUz5brT9TpM4o4VOzL/uCBGqII4umw7zkax/LubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rvbe69xBIpzGsOrw6VbYQRORSyH1zSp/rLtFmlWZcCQ=;
 b=BrZGvAynJ4ponUIVOC/cXDvrF1+Etamv2w8qVqOlmhTL8aiE49f6Fr+pOZGCxpsZ8U5TWZJeYCRTF0JCQRuPP55AJVZuwoRVfyelTWQbndJxpUDeg27fFcjsLvOWUBI2Lppn2TBIn+kkt+PdquLDl+M2IX9quoD3CNvn6dG+bzbCQcY8jNjTrlvky7Kvf2JnQ3oXOrvRgEnO3TC7qBz+Li/Di6Uy5qjKJrHOPmtgB+xJpTRvLbcJxCi2zqCf+Oif/79m+P6CKx8IGZcMsnRlxfrvt6nscsBQs4/yY6DxAyUtoYbi9lMgkjHr5wnZKQfQr9weeVUnEx3FaP0LAf7nfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rvbe69xBIpzGsOrw6VbYQRORSyH1zSp/rLtFmlWZcCQ=;
 b=nbSi06XgCR12RiFIHX53tm05VV6tvR8/+VLSfACKpV0nx74Nc/5S3tSezV1wqhbi0cq7fG5akeV+5ugVQEXZx8Ie72mN77tyNZKtIUXyfDpSyG/LqGOli/zt8QYC6byGtv4stGz12SOqQoiRkvlmC5mA4TMRiAQjpdyH1OJDE8LjQT4riv3BdU3C10yuHgc7649NY12R+CP4T1Tx1zYNsnEdcUpL0LVGqJ3HBYH4wwX1QmohJ86A9KA7M9mf/oIfEsTLcjSvbAqkkynzOcQySH2+tGANArdLXGiXQ1vmHAEC4/c4SlOl4OsmwIK78JCfEw4GrAkf2wlBAgXZBE6c6Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:12:09 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:12:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:12:02 -0400
Message-Id: <DLRFPN5JH235.34HHA5QDQGSBT@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Stephen Smalley"
 <stephen.smalley.work@gmail.com>, "Jaroslav Kysela" <perex@perex.cz>,
 "Takashi Iwai" <tiwai@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Doug
 Gilbert" <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter"
 <simona@ffwll.ch>, "Helge Deller" <deller@gmx.de>, "Sebastian Reichel"
 <sre@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Arnaldo Carvalho de Melo"
 <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent Guittot"
 <vincent.guittot@linaro.org>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "David Airlie"
 <airlied@gmail.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Marc Zyngier"
 <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, "Andreas Larsson" <andreas@gaisler.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, "Xu Xin"
 <xu.xin@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 25/40] mm/vma: enforce that only kernel-owned
 mappings may set VMA_IO_BIT
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <sparclinux@vger.kernel.org>, <fuse-devel@lists.linux.dev>
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0340.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 929b79cd-7fd3-4fe7-b0ea-08df1dcf10e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	55V5jLLqnKa+bap2rTDpyXvJ3MS2KeCN1v66hI6BgDtw24iIHyBtnFcsj40HGTzEsTDv6VVOvLjR+3RKHA13ORaZjm94lG+Mm6zU/Gi5YMuUYQVpJFkYr14j9O2JEahCemsUkSAvCXrpWSlLjvgVYmWUWb2pMyw+ENNOeNu9ib40HzVvAlZ1hnYPKjBOGJmIhdSQahYFF2kBaQUuxI+GQ4Ggj6FQYrR3/VE+qJZJpfwcECIAFB4twVQa+hLHa0Ve0J3DSJT24HEHLYU4q4AkQdTVE/lEl/AIeXhgOUupKjHD9yu256BAbRce7VT6kw5gebvfaLB6PeRavLv8twn1I6OdyXfs2CsChLXJoeTSySz6laOIKou7jk9lJDIHvpn2NJ5j7FFWDYru8bNGIOYxS1D+oJOd1no8EYCKcS4FoVqOMZu8SxD6nI5W5LesieW6vo4Z8G5btadzb3CVLJi4YBw3XHQLNI+VkzVKhIJ3Kfq7hEkvvjn5jzX89cxCQekRNonJwLSUjc/eR/gZhHhBjnF7/pvLR4MhCfy5mos6X7sd77iTwY9mB+IEyGRt4oEGSOqPdlvWFtngelGgsZMcvRpKdOIJw9eZjxzu9+i3vf8mLI9h8wzHVv4jGxA0NzZEI8IofRgVaKEHJFZm2obMyU03kiQn9zErw/yXQeNHOCl8QWdt64j6Ft1G9PwSg+AhwwMh3EGQOYEH+UNFKOBvCw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmpGRzdZTUhYUEpidGovM2ltbThTWDBuQlNLbW1uZHRGTXl4Y05XRWxVcDVz?=
 =?utf-8?B?YXh6OFhPd3JhNTdtSytoMm91Yi9lVlp0NWJueS9wM3RRMW80QURYV29RUWg1?=
 =?utf-8?B?dnlVRWpVN1pMS2lkZlFOb0U1UGtzeVNkZjFUdFdXcEZTOEVGcWdzcU5zdlpv?=
 =?utf-8?B?QnJnL0JXQjBDVHVsNWt1SFB6LzZGWjlzRWdXTVYvNC9EVFJBTVlSRE9iQUJh?=
 =?utf-8?B?b3cvcWV6NTZXT2dOS1VmVUk2NHBHeE5NbGlYdithNC9VUHV4c1FMcnM3MXpX?=
 =?utf-8?B?cExGellJTFBXOU4xUlpwWkNnSTM1dzU0WkpRTytlNTQydUw2WGtTbHdJSEc4?=
 =?utf-8?B?M0dudWh6d2JMQUVKWWlZajhGMGhHZU9DWUNYckVUWG1YWDA2TFU0SEliL0RN?=
 =?utf-8?B?dERYNHEvQVJzWkNma3hSVndMVCtoc3o1MGhWdVNET3F1MGRjQUxPQmdaRmZC?=
 =?utf-8?B?Nzc5WFhkbVRkcldBdmVvZjF2T2tKVG1iRXdqWGVmdzYxaS80N0U0RWczNkpC?=
 =?utf-8?B?OWFjamVLOVBsVTNJR0U4V2lWVFRxSDJVSGZFZkhrY3BPTmRKei9YbXFuZ21L?=
 =?utf-8?B?UGx4R2VkM0sxMnZhd0RsejdGbTEzcUUxdmRyY2J3Ry9DWXc3Q2lVSHozbng3?=
 =?utf-8?B?c3hQMEJpWWdPdFpqZ3dybUxabmdOK1JQSE5UM0RyOGxRSVBwQzVneXF5UzRi?=
 =?utf-8?B?bEhJM3NMcjNiK1Evd2Y1eFNVRHQ3WnQ3c2RJNTNPZWwzM1dBTDN0RzZZQU1D?=
 =?utf-8?B?QWw2SDNwbCtsa010aEd2aVZoYnBXN1BKd3NxeW42WCtLUmFtdnRzVnkwbVlR?=
 =?utf-8?B?OWxkL1RQNlUrSTBkRTBsZ04zbG9iUy9jYTdqRjVudmg5RDlmWkhwNDRQUFlp?=
 =?utf-8?B?a2l0ZkFOdStOL1V4OVIzbDRFVFB6TWViQVc3OWRUZDducUlDMTZBZTNMcmVD?=
 =?utf-8?B?Ry90emRCTHd3NnQxZWFxelZDM2ttY2xrMklDd3M4dXJwV0Y3b2hhd0lnQnlr?=
 =?utf-8?B?bXlyOWt1NkNJZXc0VjNHLzFFT0NsQ1hwLzgwUzZKQ1VsNkk5eU5rR3F0cWRH?=
 =?utf-8?B?T3Zkc2Q4ZHh0cWhMbkwvQ3JCc0J0OWtuaTRVa1RFbnFBT1BQckJkS1FGN1ZV?=
 =?utf-8?B?QzM3Q2JSVzBzUzFJQWNZN3dOSEErZ2Q2dVl3WEk5dnBFRmxTc0RLWHFtNUZa?=
 =?utf-8?B?V01xWTI0R2hEbnp6d1RiekZGL0wwUzdkVjZ2RFVhTFU1OU5qZ1J2SXZQL05t?=
 =?utf-8?B?SzZSRzRiWWtDZ3MrL1FEVnVNUE1TZzh4UnV4a2w5R2RiQktjdmhWMEo5Y1Yz?=
 =?utf-8?B?YXoyYUQxd2J4WUo5Q0d1TUw0YVBDbUxjbEQwbEZpQStPZjVOQmZTakdTdVkw?=
 =?utf-8?B?elU2ZkZod2JERHpXek94UUJDTFZMVjF1Rnd5bVNTSUJ5bUVQRlpCamtCWkdq?=
 =?utf-8?B?bVJLbG1JS1BCS1dhQ0hMUTJNc3A5UFliOTkrWmdhMzFjbTh6OXZyMk9sa1p4?=
 =?utf-8?B?R2pyelhlU1BMZDg2VFN4SW5XbGdrWmQwOWdHV0l1ejBKS0hzK1AvMmJjRW5q?=
 =?utf-8?B?clh4cjhkb3VNdDA5T3pVNTc4dUFCUEJ2ZzZiSjlhY0pYRmF5Y1RDU1F3OVkw?=
 =?utf-8?B?VG1SdDdFTFRKU2FFL241cnhWNEFKWnRHdW15OXhaTUp2UjF0TnpiMUt4REdE?=
 =?utf-8?B?T01ETHRmdHRXcmpBcThpUE9ocFgrK2huT2N6bElBNWc2MkVEL2YvdHR1Z1M0?=
 =?utf-8?B?UXBkdTc0cVdjWEw4Sld2RHlFUkJnellpaUR5ZGUxNnIwRGJIa0RxY2pGWkFa?=
 =?utf-8?B?aGphNUFOL3c5dG1Lb0w5Y29DampLbGNIbHg4OThUY2NCRG1FTHdxaFg2OG0w?=
 =?utf-8?B?MkoyanMyY3BTVUl6dUZmcjF0MmZLNFZNSGpKY0w0NGtsVWYwOWJZbk9Xb2sy?=
 =?utf-8?B?NTE1Z2ZWZDZjMFVFdnZ5VUJmVmRyV1JDN1ErZFBwZ1E2VlJGQUYrck1WRzRa?=
 =?utf-8?B?aVROVjZRMW5mb1lWY1lZSlh3aVVzeEpWNmp3NGw2RG5oczIrS1YrUTlIYXNX?=
 =?utf-8?B?Zk9XRWt2VFVYc211ZVR4dUwzendWSkg3WWRKYkljWk5pUFNTcGxFMDd6UXE1?=
 =?utf-8?B?WmNHcVJlR1ZSYmRNWHFHdzVyeGJGQ1pRVVQyanhJUmpvUjRNb2dId1k3TDAr?=
 =?utf-8?B?T29MU2QrYTEyMWhudFFBN2FGQTd2ekZDMnJ4c2pubzBOdk9kcTBxSVFRSnJi?=
 =?utf-8?B?K3Y2QWJVRVZ4YmZHbGhFazFSdDdadkp2cEUyMmVQRUdMdzNVaENVd2hFUmxC?=
 =?utf-8?Q?nxE//RYebAqK4lZhk9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929b79cd-7fd3-4fe7-b0ea-08df1dcf10e1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:12:09.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGPiS2Ywd+V6AhZ66j60qQ5UQnjbvbizvRjnGHh57Z10grwgY/ZHiviWZgnay2r+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161
X-Rspam-User: 
X-Stat-Signature: ya7j56yj1bi3nesjap7eyf5epeicer9e
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9640C140004
X-HE-Tag: 1790647940-534052
X-HE-Meta: U2FsdGVkX18pw96xweUCflOxgzqw6J6nRPI53dZHXCDuBKsUav3CxeMEE4Nogor1RShyQ7At5guyao9nQaHsXHsee1++cm5ARXO3HPeTorr1mwaZfPCeV8aQnn8PaVrwlkMybK1ChBXfF9gZlliU8cD0p7IW2YcICCpZAoJhc+5MASF4UOS5g74zgVNRJCrOyHtu9dapnGLcLbIdDnELuM53S/Yvuw4+iN5m2Y6FR4AX58HnRwiDnmurE2iLcVThrrBpfGZ0lg2otEagXK0NgsquF4DVt6o3R/xJTJEPqmOVsGeeoIvjWp42n0jwElwHMPKRRnfwy51gCesrg6OdzyMFqVzcqr5wOVpUcRfql4iSvRvW00eSfPRTFbVfVfvoOqnK54JljAHAMWOd1zu9gQ425VP7IiEMPg2f9CvtWum3glGbfQB7jAct6D3Rv7YAtUpORTnoziE/tn5ePM4R0bK5sU6SGQeeaqeFcjyX1lRltFHBYUKgO6A1BqJI+cstfL77buBcL0JW/OKghxSa8R/IrV5FdxhP91CJy4O8hDfWO30YYC8X5IE6zKIjh0OMYvvevB0qh9fkyYTKz8Uk3Ehmkw1Jz7wm9+3LP59FNoeu/Qiib/2S9rmIlZYeuLbNkvlrM1vCUjJVb9jdoN1HKtbUEP7Py0A2AKfA3MsO58kg+qFDiGpPAY9uGaXFa+35s2siF5R8SwQQ58fCETgY5LDsNC91II7InTux7HbWZwtlfEZaT5OVcUoLZ+Mfl4tGrXiKRC1Idk5xkKgtQVmhmfxFMaj4Cy5lK01z1ZPNE/ubw/wFjI1NscWxb9Jb1tG4+XgSIRNn9EXlOdUOLwdAQFfKEM19kJ3i1zyKPto5sMJ45ryY39heibs3sNIxnXy9gs0yzpNgaO2XNBls31PRpvgsbbx/RWb+q0RLmSVrvzFN2drgf5C1n0eEb8UBKPa/olQbzCeRCPyPcKgQF9a
 2mWcnfel
 /7kpWMMX6GAKwZxDTWmyyCiLicLcCN9PiabyIRai/0BMrp5z/zRkRskYapxgAg+/wjIBFZAHtllcnu0fUfdfT7zkAxkEbNW9gjYsFI0V7DI7rtpwnTMg1d1uOeTt/MTrinRo/MuJENuxSyZCirA7AdnjSX1MIcCNG71z/FaiAXnYwqs6gB5HkvXspMYmFl8uEBX1dl3F24wiYMqmfQ3qH0qq23m6ZNhOJGPnHax2/qBO1PbD2VvQyqGKgCJykB/t4ca+qGOt9sE0LHKBoMb82xKU3Cn5DG6yp85SvyKC/H+GJRJ8NiKtLz7nelv6SNnUd4wEJ6ASUkH2zFifdvp+A6ee76bZNcklfIaeLkrzq+2plVptDGMhun+y+H6wvQlTdYHoSNDF5E41HTE6DsvymIUQRBztBi0ma9y2pH9KrhV4EOPpyUKUnmPBU3O7T+c1LjvbUsZ6D1vaxK9nEDD4P80MleCWvv2J7/1F6rmkLdyaDisjA/7WQ+2J5d9yfzKBOd1OScgH7VqooSjfKagSkoyHuSDj3+P9vxe7Nn1OF33cslvWTX3hIC5sa+VPVTxGjOY1YQiLjhZHTdd0LUrdC//qdNkn5NAwHOgEtzr8UBryH78celeMWq1c9F7sbeXxOYuclHYfDzcBQh44LsrdEG4+1NaSAHjxKgsbwwlLDkAyKWBxomzWki7yOBrbUUWXJHD3eZ/T3loi4OauPq3iKDtX94X2nDA9aNokr24rBog5oovJXz/128mUgHC1aP12QxU+3JamoP0vgB66XD6tcvGLBZLzo6Rk2XAJ0xuiQIavEj8euZF4DOn/4bZI8R8Xy8oOUtsd+yiCTkP/sVTA1aQCEczeSp+DuYwSrOKdMSYgw98A+/3Hutw2o2spW4Um+MEGB8/Y0k+PqpfQ4IBoY3RqzGpv0cfU6cAJ7+FI1Vq2JeiaAOUG1o592NCUxtLPf/P7cL7SblED1gGhr8jRYwbSrw/1S
 CaashmC6
 EZPqdGTecOT1QgO0Pz4lkFjN/XGzGpoizrq5ohkYbRCwRHe6TGE7WpwUajdIrB3qAidul43jDo65qqPb557xVLZ3lbgZGKnz0TYtEKiVXo+qc1/NE4nKbMQJ+9EBQckqHquAfoOlId5CjKJoBSBpwDN0FdrLEghQuDGyBjMiHsszyNWMVIdE0eaP+fPwVFj7AHoDG+h20nUgq+3TXEfOIMdGOF9pzY6e+Jig35YZU7ikfeDzApYDQdAVkXPTyf2qaQr1Ghf3fakZKSGLX2x/a9WIpa5fcP/ALTgccS1952zn5EdxyONiriaMJLGq6HUfkq3f/LUaWsMfOi3BH6PcZ9iC2js3Le3tsQkuJZ/inCrEKPQhYfniDmGu3y12ZFg+QiVDfEbyqleCRSaJSI/D1tSB5mAnw3hmZn4ZIEJa+5Ro4CD23IB2eCy8CzWM9LF06UBToy+QRM3m+LEkjMcbw5Co7eq54EqTMP32bhhf0rQ60h5UKFiAXdph1Gx4tDyivFAdYjZJ/E5MV1c5xERwcNt6MLfq6PE0fSS1+FYzRH3r6s2/6xlMXIOLecagddZ29oKPVFO9tD4g3FRpKVv34hupZJaN/+2J3GdY+lXFmjO4ZMqkmXk9Dz/Q0bC3TP0vdiQ0hIKj6i3zdhvOkM3R/J4/UvDErOfOCZkQHvHDCFvTdQJPhJL/uZvcr3VjGlxRvLdb4QJnLAHpvp+qhlhfa8Hpa2R888eC1mvMjYgOZW3nfhnriQ/zqrsvdYbGkWTqWgpdAlPJ5DoIx9wm9sjy9ihWfUUx6T++tlZqZU0U69uVZhJTmI7A8//zottkplS0BULbrol9pIpqj0n5/HxP3pmZMHVIOXU4kpXmU4HopQhbWo/kdWUxkKqY8m1b/NqhRSuREXGW/GuoG4gh8ilhC6wx3G/Sm8p0OodG3gpPROEx4q0sM4Sh9ULbkgOzTtBEc2zeJ9pv3jr+4ItffEh8xepqXaJcz
 mYlQHZwL
 XihItqweLX4JuR45jGLT62xYWzSjp37awpBCRE/Bbads+kl13ikZXvEXe05QCDYxe/n5uGOjb07M4ajIBRabQ9FERnE0swArLe25WzWAPpAXF0b0RRSHBuK4qW3UXVl+IC6VczTAGa5V3BbhJrIoTroCUz7QPOoosjKPTGoW3aJXEUJEghGZ8fqeGEghgdbLU7lhMMZoRFwt9XxuVRdqxUhWDBeuKghLZemkMM0Wt1ybbadfR4CJa5JqtOzW+3q/MuX5dMqjMmbxSYF9+OqTQWluNU4SY5OmKLt+wmndmEh7oROt/NE4Bo0zrzvwavButYzEQ86SP2Wa2b4qAXV8FQt6C2meZpL+AzsQm3nF5d4sKGLnpl11eDMx9eWvcR+apeKKob4A7icV7GY9yyJIEECdSxAYZCyhqe/UqXuTcgJoPuHZKp+ILIYzYQTBMjaueP0+VYJoPgtCGMhjgF6NV2/cAQhzDQce1zwnoiQFHExKP4D3jTzk1LjBU2//TWx9PidJ0Bn2ewgX2RQVzDx37+ASCL9CdVW0Sxpf9tzvhhl9CzDshdFNIPtzIcx9qLzH9nJ7biCulPGghYNBW1t83sdNgmNSH/zr6BpVHbZfsabkQzllz4dURhDYTH4cdTzq5y+8NlfLRjt3fFzTtmV/SIvzn85Q9nmUP1AoSVRi85WMT/R/XFY0qFTZpP/v6kos+Oo3oF5r9kB2eBWY6rVJvQ2nBi9GBR1F3ovwT64OE8CwMDZMcqx4Y+3H50fWeAM+WCQwoicVZTEkOJhjKrZ+T/zp2nBnpqgAX7CQJo7dYjnWSLePqgB12UezeLwp6TPKE06/pfy1e6lZBFK5AYC3YYufUt2i6o+MYFNDq9lj2DKp8Q6v7NlaYb2LZHtWuv4A++edXE5jMc0rkgCx6Dlp0HSX0ZqvksxQy+nG8C3sStawUbl0IOnwNg8Q8LkHBGPEnIrs71zuZ5SWJX2Kx/rVTtl3vWdTx
 ZpCsXx/I
 cXJK/1Sq0Akj6XYuoPBUWmjtlFFl6MRXxFf4hyjIelDlFIR1PXukqB8HY5+TDUumTdk2m2OGVQbiB+5bswlpqa9w19v7juGoZvmdJDxHryFWqzS3GZcOi6QfcAmOP+YYXzl857+JC7FNmJtsKs7hlMa7QqAafbzJxvyYFPAetKZ2xgMliYg+03GRdOjf1Qa3zGwRJX3SLSRQy7zt115erj3btuQOoecEIEuHBc/L3kgE/xvuJL9lYvsc2Q/vq3MWNrRry0De0bTTnIl+LwSE4UNoMyMGDCWUXGdSU0NQeDwovmEk6wEV24+b2LnOpExH2GcpLaU5OpEPds3nEyM/H3bSGXhB6CF8mbEY6XzttjCXsGRBoNJAD+qst/S2W9AFqBm/phLcSMyki9jzZfOb/ae/Og8OxCBZU+fyztfDuPILzYKdoROetcvYX+SDPS2HHbWyv1UAcKVgqz4PV7iQkWsKsaFSED57TFwSVOeK9Wj5nYrxN3p8kdwSJ4+cGHAzU10p7v7LM3AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as kernel-owned. The check WARNs and fails the
> mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kern=
el
> mapping.
>
> No functional change intended for in-tree code.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 1db8b218fe64..56a0cd154419 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2787,6 +2787,12 @@ static int mmap_validate_vma_flags(const vma_flags=
_t *flags)
>  		return -EINVAL;
>  #endif
> =20
> +	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {

I thought why not just using vma_flags_is_kernel_owned(), then realize
that function is still checking VMA_IO_BIT. And you convert it in the
next patch.

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


