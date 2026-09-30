Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707D6CA5FA5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C6E6B008C; Tue, 29 Sep 2026 22:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBAF6B0092; Tue, 29 Sep 2026 22:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2566C6B0093; Tue, 29 Sep 2026 22:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF77E6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:28:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 654A912068D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:28:42 +0000 (UTC)
X-FDA: 85268845284.20.ACFA298
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf11.hostedemail.com (Postfix) with ESMTP id 995E140006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:28:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CfBs5ZFt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790735319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sVbp2kcMkSlx0mi4FxUvHPJKOhydIST8UdYgOnjXeg=;
	b=L1q/13v4ekQ+1n73Q3tknMUlK8Yrok8IAPE9EEedAYz3bC3ayM1NU7Bd1tPrQozFYCDQ2S
	4W75x6dOaJHOPDd0KlConLiqgJ3IyMiMsTqfrHV+s7zWHE6tCWdBVi2iwweaMDdJk7g2Q9
	U5Rlk6m3RFd88FV/fs0tQWQ1tU44qQk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CfBs5ZFt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790735319;
	b=LtbC+v7z1HVDqEEwYrrCPWkC3LeUMWaknj0btHkr/5CrQhVNhbMGrYB4u6wWQQprUnCRBV
	S8zNi8O8BBuOWRag5MVGKA7EKoQKVH3Rb9wQn6sC4l/HaDEbcIhZ/wQQw/YcP3AJigeAR0
	XJdZtUJ5RzaRh1kjpZwiWqz4Zj0h0+I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qU1JOU2omdcID0DKEWU5j9T6rGEhCxmdrFYGAFd8tSrX12QBFcp9CZCfXFhXeDmJGq7JQE4eacsYa+6KJMvwOPDlIT5O+u06WXb2zRYl++JnS7KLfefOVUDJ5VC0WLeiLLFvlWIaMWkEvMuNIHf5uBpH9gnufZIndLVunNfPJEe6lHSqC4Tep0zHiDFk0BOeIDwBZsWZipDWdNHJMU/4j+vxizXQgPcDNsVnKotp0C2OGQjFuv/nCR+yja6NsClPslYq4iRorOwB3u/tqd6zBktirDcsJsKxhin1RqYSdL0R04Oy4P+IvneYSWsl8VIjRq4SIcr/tZKPwW2PGJq4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sVbp2kcMkSlx0mi4FxUvHPJKOhydIST8UdYgOnjXeg=;
 b=KRZdr0xKARVdca1YlGu7PI+3oAbOek0qe1f65t2ZPD664uEs4tHhQNOH+dWbsllBZK55L6WLZQNCDWUxxxC0LPLLp2SGo7AwBqJ3WO87StGpWE4hQDaw2GGUlSIa5scz2tWHVrUMKSHv6JiVIoXcrSVgJIHFR13HQ+IyF8SzBY7BBLeNDAv7quNwXigexUdwhwfpnV27SbC9+VR+vMX2WI9a6Xiiv6yr0+I3CLnmhZOUwZS2ieEJH2/i1i0M9zcatx78WMIUs2keQoivnE1eIukLgFJUM/SMwaYdIVtEmqZBzJToet98DvfOPhGWqlDZaPE1ct5hpKWGn/cFoOUHJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sVbp2kcMkSlx0mi4FxUvHPJKOhydIST8UdYgOnjXeg=;
 b=CfBs5ZFteQQk0AO9ymUIYDgjD+WEEvikZYtEZVzPBALXDEQPvgbQAdLf6WHQ14SIwobT8VH9P3npMuP9zALTMm6GbZeIDfEqCqVoBY2jiR/2fOiFVY8Q48i4HecIBM1KqepNgq2XIJ6SFS4FItOPmRAH99kln+xVXCjLPS3ax1DxXyV887FuS82vbXR8/45/Vd4zQe0kWD+FguM2WmQU9yWwiGG5EjVSZzWOK5ujJ84vUTR2K5EthCrsmahNsi04MRfPXklp9RYAJfFo0JSVliBXpMw2hrsz60379vsS3tYTeGXMMAP7J14xxs1UOi3y+spgC6QOz8F+tqMX3lHRgg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPF2EB7CF87B.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 02:28:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:28:13 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:28:06 -0400
Message-Id: <DLSAOHUUMWPI.G9KTXPYJ13SE@nvidia.com>
Subject: Re: [PATCH v3 33/40] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
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
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-33-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-33-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPF2EB7CF87B:EE_
X-MS-Office365-Filtering-Correlation-Id: bd9379ec-ac7f-4064-b53f-08df1e9a7a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|11063799006|10067099003|921020|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	ZRNB9Oq5L8cpd+d50Q1QS5qId1MfOu4DBmccupFlpdcQkg9fFhVudMH1KxsaJrAY6aPBvxVtZvr45o1Pc8kDKGzkCw6qEXkshWw32Fys+fp631DuF2aYD78+Tj3CqLZgBz5HVv5zpPyuJoez4Oucc/moTKBMMIwHzvWWF7IDTzJFxEm4UbFNEG0v5sMnu1TlH5C/PEdMNNFCWgzoWNEYNw7PQZzHya0VvbpERwg+RObCpweVjuVchn2k3Rp37rZmPIB1WtMqw1KV0vaYkrdm4X0oB1dTO7i1bCv67kGVQFvuRi3ntPpQJ8USxHSfBgJVnqOM6AGNppHpWzeUyzl/YpNvHs8CnQc7VKdPGu2bWBzYh0LHFPGs0jtnX1c7AnqvY08uRsMGw8cKnqf7ZdnmzS8Y1vzm4bytSAwlfiNKPytKyrClssEv0AoV2bXF3m/cm9nW6MH0BwiE5ssQ3V14051SQvCzVYnSWlDR1XN9eg5hOPXw3IeJO6WnfChTWwU7mKGSrfy8cpzDHaVcC3plR/5Y/QAzFs9ZB2HWnkebthcQmm/RHFEmJiKSDeuEE/vq64k/L8/tXLKGPqbDmWeQg6FaqAnvGD7Aih0Rw+iwFpnfnGXvoRCUtn30uDtBdT6oSPKN1eEFw3f2BF+fZxS+kJRe+x3JLsCNU3qUbOfuQcAfYW75TVqEKKI3RVseYic+LimzjDscWa9KGb1LLF1T9A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(11063799006)(10067099003)(921020)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YndNSzJhNkQveGt4a0JsbjVYY3IvTW0zK2VDcVZJZWFMZ3RsM0VhM2drSGQ2?=
 =?utf-8?B?YmxCNGVPa3ZWaU11UzFZdFhmZXMxUklRb29EWHVZcXVqVGFyOVdYYVc5NVRj?=
 =?utf-8?B?UlNaenFjYW1LSm9lbjB0eEN2ZTQ1c2FOdTJUeUZ2WDkvRXVURThDM3NQMUV1?=
 =?utf-8?B?RzRVV2lpWHlYd2UrbWRkYUtlOW53Rmw3RXR1cjJZVGFUd2NFQlFQNjdPRU5t?=
 =?utf-8?B?dzB3YU1DU3BiOEEwaFpvR09oUjFqdHBHRThYVVM4SjhaNldNNkh3UG1vcnFi?=
 =?utf-8?B?QzNsOGM3eXJWa1V2WlhDcGFqWDkvNHJiSm5BRjJoV3RXb0NPWktUTlgrVVFY?=
 =?utf-8?B?N1ArOFBJMGpYOFord0JGbk15cGcvMDNVdHpCRzV5bWxGWmRma2hzOGQrUzUy?=
 =?utf-8?B?UnZ5ZXlDbWhVVlhOK3VybUZZNjhWMzNpS0tDRHMvVFNRVFhDNU9SSVNhZmd6?=
 =?utf-8?B?RkFvalZrOTNBRkpYamgzTnZwV0dncE1MbUFlUTU2RCsvRzV5VjNubTVGbXNZ?=
 =?utf-8?B?alR6QVNpcFhFTkhTSkxORmlsUHBQR1N2VGhIK3hZeHdpRGNWUm44K3N2MDhk?=
 =?utf-8?B?WENSOGg4NUl6YTVuMUR0RkJ1OFIzczAzcmlrUzg4c1ZxTElNSkZvV083a3FD?=
 =?utf-8?B?WVBua3c2QzZFcEx1ZVY2d2RGaU1tTzdXNzB6clVXNVM2Q1htdUE3M2I5Sk1w?=
 =?utf-8?B?MjRnZXJxaUFCNWZhSzRaSHZ0WmhkaXRmQStLU3luNFFhcHp4ZXlhMDZIRU5Z?=
 =?utf-8?B?ZitEY1Uwa2pMSnMwUkYyTTh0MmhpOXlLSTRISWw2K2grUFVrUVdHRmdNZDRO?=
 =?utf-8?B?azVSUlVMS0UxQU82SEFzNWlqaU84U2ZqLzJza2JWbkpneHVVZENEd2Y2RHR1?=
 =?utf-8?B?TEZZeU55U0FyYk9jbnJ4UnQ4MU5xZWdRNyt2TmpaWGg2M0syMFZYbU0zYmNH?=
 =?utf-8?B?UTNPRnE0Z2xGOU5LYm1kM0NwUTVvQUo3bmJPSFA4YXg2eWloK3dLakU0UmRW?=
 =?utf-8?B?US9OSzR2a3VPV1piOXVGSlJTdC9IMFkvak9xeTIrWUdKYnplSzZDS2k5V1Z5?=
 =?utf-8?B?dDduOUF1QmVMQ2NRS3Z1RXd0eHRCZ2lCeGpEVzhZZTEzM0hxbjV5Y0JORzB6?=
 =?utf-8?B?UGNQUksrUDY2ZXd6ZnAxVW9ab3hZTnQ4MjBpRzJpakhHZjNwMDFDSmRuRnFJ?=
 =?utf-8?B?M28vTGFvK0RKekRDWllzMVdpNVhvcUk1S1NLRk5WaWVkMjdmcUZZZXI4SXQw?=
 =?utf-8?B?Ti8rVkhoL1NWdksrQlladHFaTDlGekR5akNxMUt6ZGdkTDJpYnRuM3pZaFRZ?=
 =?utf-8?B?R2ozbjZaL0c5MXljVFZWNkhjeFZDYzlreFZhOU9aODR1MkIwQmVWTTl3MStT?=
 =?utf-8?B?ZFk3VGI2dFpkTUNLVUN2UHVTaDlPZ21RZVMySUVzTEwrMHQybVQ1SkhBcUNp?=
 =?utf-8?B?UzZnZy80QlNFeEpGMWkxV2JWRWEyYUMyVjcvb1g3Z092Zlh1dEVzK05KSi9Z?=
 =?utf-8?B?NXJtRUVFaFhuY0d5K0lPSUIzQnhvMFlIRWRqZDZBQmo1MXdyQkRHT1F5U3VX?=
 =?utf-8?B?b2xZMVNmL3NQZVpqM1hLYzhjMlNBTEdkT3c4VTJ1TzVzM1ZLK1VwdGRvakxa?=
 =?utf-8?B?TlB2aml6NHVIaUk4VDZMWDkwamErVTA3QXdkejdQTCtQbUtwQU1NYm13STZp?=
 =?utf-8?B?SDlXZjBISFhsTkpXRi9qd1JmYncrVTVBZVhSZldPbW1ZM2dsSXlLRVQ0ZjE5?=
 =?utf-8?B?R3cxajkwQlRmbUdscTlBNUorcHEvRUYvb1N0bEZuMHBZMFdFZmRJRWY3RmY0?=
 =?utf-8?B?SzNKYVhkSnpWb2h2WHRPTE1iK3pxSEdSSm1NVGt6cjBISXFxclRvdjQ1eUN5?=
 =?utf-8?B?enptN1ZZUERBbnpTcjFqV25OTkVYVVc1T096TytUbE9oeFhzbGZsejlORDFW?=
 =?utf-8?B?WDVxUGUzYUVWUnNpSjJPblpyMjJuWGNoUUxTelpaRGIwcFE0V1ZBa3ZGRUlh?=
 =?utf-8?B?aU5nWkRGWG12VklzWEtjYmpmdldjL1VQUFV4VGFhUTA2ZjJZdmNNcXBRQU5m?=
 =?utf-8?B?NndSMXRpQUY0OFZnMkYxWHR3WUlPRTg3ZytRZmFjY20zQnpucnA4TkhvTkpm?=
 =?utf-8?B?NVZYMGd1bS8ySGJsMkduZ2pGTFQyTmcyOXlGK0x4N2VMREtZU3pyOEZwckJF?=
 =?utf-8?B?c2d3K0NYRjgwdGxWSzBzVERvRU1UMmFlZ010alovUHVIWXJlR1FvQzJkYi9E?=
 =?utf-8?B?bkR6dE4wNW5xOXU5UjVkeXFoNjBUOGdmazkxeUJieHhVeTBkYmV2UGp1TnVU?=
 =?utf-8?Q?RM4RLzUlCkMRGiF4Z/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9379ec-ac7f-4064-b53f-08df1e9a7a1b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:28:13.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dr2K6I335YDIhmgwb8bQ9CrG8NiTyZzeJD/twKJs3IO7TOGGeCxpSdTafZWYaFu4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF2EB7CF87B
X-Stat-Signature: j7s35refmubxtacpsideuau8raqy9hqa
X-Rspamd-Queue-Id: 995E140006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790735319-393412
X-HE-Meta: U2FsdGVkX18EEEkmhZ0S5p1YPQ7ciBJkfCDLNVooBiUshNP8kqeMIBHU9RE4WIDx3QEu+EClgPkhyzfUtv7FYiEqG+qEYf7RsdBq/MLGDMv8TkwKQ1d5eXGvwHgCq9znzvEeaLW4xfBnzvFvRBYl15mR78Cwkubp9S3FR7xzvSptB4H7feJ9dpnKKIAeD+pcXV6jPBTy+9J+VmMO+HT5u3gESPofTzfTfKpFlzyWNnV4D93gZbzgjZAfO9pimwiEJuQEMnwRJ77f240pKW+IachPmhIucXzj8uqiEF8EXeyD/m9ZrZIEQ8UDw+crftlEt18blG4ukMS6LxPQgWwwiKHq1WKiMpcBMYaHVPuQLW3qYWt9LWAmATInHLB9zAn9qR+w7WIBlX1vS7d4pVjRPnwtf8GuB/ns8VrrByOrRiDteekqyuxSLOoZzF4rTq7+N6hUtHrvg8TsbqGLb0CGpXBtM2RaLJtdlBabaWHORwRzc7cFME2iBuzE8iG+EF4NzKw3YwnKCTZcMfA/tcxfVh4TKZHFgjAuphbCB7ZqMmO8p4ErXs5WZKvaUTtYi1UhcAdPHy6o3Uizh3peW1FSVP7p1pn22n/uZjcF62Vw2GdoW7AcOL7sfI+qKchQkkdiJwJm82uqmc3w/LQYo6KEB+yLHS27dz9zCk08NUi1pbnjQnRmsayW9vQoNfJ/X8Ztub7rmubQqKWJJv2FhtQp412lX2sPoP28CYP00EMt+NAoPES4bHn0gkusWfI1c1gs4QT8oj9g/giZG43qhcpWN0r2ec2HzHbE5DrkEtsNlk49THTxgT+Si/JXloUDzU/UzofPm1w5cNLLdU3XnCmV8PrKsjFz5DakqjHsPL0mVch2lShFB6BFyA6kHvblRR47K0kA8gK8+5y0zDW1VTEW2KTY0GPx4DC/6WQB9LSDGUfKnsJKTnD3wA+iV1OA75jeNT3zZ5vN9HLeEbtftv4
 K3FzXF5s
 vCKpIpDoO+wB8+S3mmkjHc8P6A18PU4fOIQR0b1ri1NEig0Cgc+7TGgYtIMC+1TSC3vkPLdHHGgpHFPrUjgv0rsVhhHULPhJ9++8fe8kC22y68t4SCGTQYjeLOokwYZqOzV8iL4DFtYjKiqXINiGdVpGkzwy77+y1HqK4CjCTop9b5/jIYoeB6X0QY2MvksZSBXs1UKP/1qCpPqPlPT0bMdYou8E3xKB+C6T5rG7r83I2y8T+5vyNQw10HLCYRp0g1Gt8x+PkmNJjtL19vNOR79lJtKfQ495IRgaXpPXjrygGNrhxY23eN1Q1Dv3uCg70gsqgUFd6ifUIqIe20wZfrfrluaa1qbSMarvIGhTZY7Qt/aTwXedIM+D6iQshtfv6VK5ku2qox3nAliKcmN8o0/Xtz8R46Ep89DlaeQWxmp9hpeft+CdGEbptMa2o7OklZcZzMbaO7YGncLPttau5zvAxjCrgd2Y+KPrr+wnU9/tHfAfIViqMn8ciqUKeY5VkZKZDc9DNi8ttBTHSlJuy0Z+nTTTVrawTtJZH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
> VMA_IO_BIT.
>
> Now the invariant is established that only kernel-owned mappings can set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
>
> The rest is equivalent to testing for a kernel-owned or fixed mapping,
> i.e. exactly the same check as whether the VMA is permitted to be merged.
>
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
>
> Express the same thing differently - if we wouldn't be allowed to merge i=
t,
> then we aren't allowed to manipulate CoW behaviour on fork.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/madvise.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


