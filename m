Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD82C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BD36B0092; Thu, 24 Sep 2026 15:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB776B0093; Thu, 24 Sep 2026 15:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C566B0095; Thu, 24 Sep 2026 15:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19CEA6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:31:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1E30140207
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:31:17 +0000 (UTC)
X-FDA: 85249649394.12.AC76867
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011060.outbound.protection.outlook.com [52.101.52.60])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4AECC000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:31:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mfLhqy8Z;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790278274;
	b=7Zy9UTKeGPO7Bb26T8TBktaVRb14Gl6aghFLXFrG6zpieuqWm7T5g0W21VjzQm5RDUCXt8
	BAX0NghYhNSnS7sz0hHlg+WxStWvZ4uie7gGASpvJGX3W3/e4q4121YEBajro+hdFQ9xAY
	ccGg3ft5LdJeT+Y0773LNjGC7pXQQ6o=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mfLhqy8Z;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790278274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xa8gAjKn5oVW/QByPYuTXdPL9stOtn0VXXgIIOvgqjg=;
	b=6NOZo+sIZBQ9ZbV5Ty/j3v8dIFybYMHlXU5vzZNvCaveux6KFKRphYJQ7oUlwwx21CQUnA
	efzliK65E0KdKMBhbF9rw7B5tk+DJJhqiV+RDHSWD6Hh5smYKzkE9G/24ifBI4MfWGaJi2
	pobwjvanp7exd6YSquz8eACIGscFqG4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fg1LPy8n+6/EliKS09YGqkeWJ7f5YiMLp6PtTuq3Qzkok2YoGmCLR0anC+aShfnMwoQUpne/4kjRNX8aVthAU0T9/sQuN3fZaWUgM6xoKSTvwmtEpmNcNsdBna4sSh/MR+UYoNyK8ykd50A5h4X8nIybN5cLXnSUir6U5RROwz40U3Ll9axkKE3LzeLBFegbTlGiPm9dW2m0NwmkM1L9Ht734PFtNV6AnX0mJzPmn3yuyDp32+9nZ/2oqLwkeGdl8ddgVAAG0qMUho5bUIzYwt3KHKDa5dU4HQIlttNIxqD7GLaT9KGQWT3oTpgivx1tlGvKW0TK76JjdLTsIz6ScQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xa8gAjKn5oVW/QByPYuTXdPL9stOtn0VXXgIIOvgqjg=;
 b=YVCc5XCvKNwKllKo9cbAmGkTzUp1vbomqQhUVbD63zoNZ6QjjbS3Tb6Qg6qhNASbvIlTeFmdmKMfF2RZvf747w2FF6GuUEucW8kbsbYyq6pUX0id7pIwWebLJRqhiHR+83osV++fbVLaJMBNPnKSCf6nfCtlaxUANL9pnTBqwEauxpQ87MwMWdHrXRq8wLTP2V3kuE8TdPgM2AvFKv6QW7mDKQukhZ/WPTgjwfOTr/h7ITyorJd1Y+MoJplpOHittgNLUKISUApR6bD6wCVWhZWZe4sbcDf4cknB3XJPjdutF1fnihNcMDwlh1VKLE04PhG5h/YHl33cqfngSOD4/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xa8gAjKn5oVW/QByPYuTXdPL9stOtn0VXXgIIOvgqjg=;
 b=mfLhqy8Z8QqtD9aqIvoUYNMx+cmWyNxg4QWp2h/RWXR+RxlztonQdnBVIW2DTJRFlez34GmlKlMuxNravWiXgSA3QD/0UFODWgUenUCnLU0ttpOe3Vw48rz4uidRt/QdjQ/4T0WxrCXACi4p8RVjQZP1zMy5/06BPB/VmKBbppeeomIKPrTkG2lMFQGipaWhgHfPMAmVYM425kwCRdIuRKNOUYzewFfOVL1unh1LFIRHfpVApGVgm3pL6FJ7Sgm8TrVDP1XhZ65a6vZ52iG6l710CVFifbwTT5j1gFiN0A1WJ1qrbRRurnuxcADKfNCS5NpjRROOtZLZG5vYVkesoA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB7554.namprd12.prod.outlook.com (2603:10b6:208:43e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 19:31:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 19:31:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 15:30:53 -0400
Message-Id: <DLNSOBMBHIVC.22QI9YBL1U72E@nvidia.com>
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
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0214.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: dd4e73e5-3efe-40f6-982b-08df1a725cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|366016|10067099003|56012099006|6133799003|18002099003|22082099003|4143699003|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	H75VnqSXCI6nshucZgXvPJeyYbIoBOjqHqxzLHmSgIi7hs+ccC9NuVDzdp0Ddm6tlOP2M+PEYqy5H0R7zLQYMUMdZ3uCLRzpce6MEprOTYKRLWxfOhLANDHBwrn48h69oqBXQFawOHrZi3FowkD6hdGWsmDa+j8FNJQ28EieNcEXOo+gosUYIqXaVBJWlXRxRY4lPN5IfBbahMsjuSFWZaIaVQ8T1IISzoy1ZL8LdE8G1M7vHDaMFUw3Y18//aH7A6u+/nwZ0y5zXQEyDTmbglgQF259yBLKMfg0oyJv3LRCd+1zATgfV2BkmHgK2bIoArhaVORWFH7gMdA+3cAc6jDffi6OFySF4AffiYVBYLNQwH1KTRYhEJjXQF+UbEXyvlGHxplKwmKo7SxjrdJpxb5TTpbTes184jNIvFqnvfvXdTE8022R63l199yNNHJGU8+ABDugfnLTS8aldCj9CR4Q880ZFNK6i+bEzZf+Fq3odht33SFRkH4B9bw5BTDymC39L9Rn2uPNVLbPUwLnFrecDyzLutzPornaHFQyqCc+MQrh/iFw9yK/Sla8+M3scHnffzHUH54OUF/5Zq1JMXoykTWldYuOAmQ/jYRCdGu0iI1zGN3C/DG+eV6gQBt87sYPIomO5UC4EZbnjz062HohT0SXOcqMEr+1uCglfcHiimU5c+lb9nqEigIa9L7eKFMR/y8IEnqN0w5WbgUUNg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(366016)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2VPUVNVUCs3YlBIU1JzeThTY25LN3hBMkdOdkY0S014RTZLUWhiVnQ3aHVP?=
 =?utf-8?B?K2RkQjlKS0wwVHZGWTBQcVJ1b0U4bnZHamprWWt3U040NG1GenVweW45S3Y4?=
 =?utf-8?B?TWZTVGkwWk9ZNlVSUCtoYkw2M1V1b3dneVBMakpGanlRc0UwczlQb2ViaWxF?=
 =?utf-8?B?V25pd25zdnJsU3hlSGxFNXM0TlR6U3NxWlpGbGU1T3Z6Mk9RZ0R3R2VrZXJo?=
 =?utf-8?B?Yi9kV3EreEhKNWlDdUNnUmZKRFIxY29WZ3VxYVZKcTFFd0FaKy9NRVI1VGRS?=
 =?utf-8?B?YXJjZG03L3pLU3N0QWJTZng2cVZZV1dCQVNDZ1VkUCtndk1ZZUlXSUVBbGlt?=
 =?utf-8?B?YWpPQjlyeGFWQ01mNncrbGtHUVh2TzlKazhUL01UKzNUZDJaaHA4Uys3Rjdq?=
 =?utf-8?B?czhOOUFEenBHVlZXcVRiaUJlWnRjb0JDYnp5Q0lBUGxoaTBvL1o3dFpnSks3?=
 =?utf-8?B?Zm5DM1U1SnBudVJSa2JhZ2Z4QXFZbmxwbGl4am9CNmFEaGpYWWRBSnhpbkZu?=
 =?utf-8?B?REJBaHFvZHdsYjZyYW9WTVh3dHExSWY4bjNGTWF5b0NmcTlFZVpxSDFtZUV2?=
 =?utf-8?B?OXVkemEzSXE5R1hJNnB4elhEQk5UQkR1NHNUT0hlclRBNjBKenZzYkw5bTRi?=
 =?utf-8?B?OEpzb2hRbkUrOWRObjVhcjBjVlNGL2pVSjNQTDEvMVVqeElYelphQ2pzb0My?=
 =?utf-8?B?Y3NxUGl1RmpTRHNobmxjaFJWYTJhaFRZbnJPU3p3bTdPWGJ5RTcwcVJpb2ZK?=
 =?utf-8?B?QWpqZmQvM2pmbEE2Nmx0U0xiWUV1UnVURjFIelpQWGpkUzlQbkFOTmdsM09E?=
 =?utf-8?B?MVdpenRMaFpnK2NJanBlbE9WRVhrOWo3WTNwbUlEU2lJcTRPTTJFVVBSY3Bo?=
 =?utf-8?B?dFFIaVlGNFU2ckViZzI3OHY0ZnY0RlBQWjlzaFBVd1pIb042ZzFoWDcwS2dl?=
 =?utf-8?B?RGtQelk2YzRTQ0t5em14dzkzbmlBTGRYYndTNmVMYysvc0d5VEhRVmVibGdC?=
 =?utf-8?B?OUlmNXk1RE50dEZpQjI5WkRGSjUxY1U2SlJpUjBGc01SWFZmWTNaZlJKcDlE?=
 =?utf-8?B?UlFod3J6WUZVZ3NVNUVGTjRFTlVzM1B6VjRoM1laY1I0M3AxdXBTbHVidUdG?=
 =?utf-8?B?VDlkaGkyTWhURnNRb3ZxRkZLSStxUHpjOFpvb2RuT2Z0S2JueW0rUFA4NGpu?=
 =?utf-8?B?VUswR3BCaWpUczN2dEJJRUlib29DT29KMEZWQjUyNlVwRUFQRmhjcXpoSmdv?=
 =?utf-8?B?OWQraU5mQVFNS3VBTFU5bXREZlE2K05HM0puZVVnY2tyY1dYUVl2Y3k1YUp6?=
 =?utf-8?B?MVd0NStGamxMWGtrK0JtVkQwcXV6WjBLNjVyeDZqdzFnaVJNSHNPaHg0c2NY?=
 =?utf-8?B?ZjBYbXNFekFYTlc5STlhN0RtU1dSakdWOGpWZWw2SXFJMnF4SFVOWTdnNmdy?=
 =?utf-8?B?UDRLTWkwRHFnWGNVWXAvMnJKSnBCbHB4anU3R1pYd3Y0NHduKytZcTFkUlJN?=
 =?utf-8?B?NEtjYlppdXNsakJxZ3RWR2l4aXJsRWh5SjYrdElPUFE4NE5yTXI4Z3V1RVY1?=
 =?utf-8?B?VktjSmhTcmNpc2JkaDJwRllKRlFBVEdIclZmb0Uxa3UydGxobTd6b2JnYlkw?=
 =?utf-8?B?TWZkckxyQlgybG1uYk9EQm9vVW5SMnh4R3BVZ3BEWS9HbVBiOHlla3ZMM2Ix?=
 =?utf-8?B?eFlZVG9QWnZBdjB6OWJUOVZiQW9PY3ZYWm5kYWFTMTJuTHNBNGNTSkVrNkg1?=
 =?utf-8?B?VzArSlY5ZXFKdFdQWG1COCtaRDA2WG1MblZPUldWTWpxUWRhUC9qN1AvMCth?=
 =?utf-8?B?dW9ZYTdhK3lmZlFzNVVMSC9ncllFSUUrWU9uQktwMVU0enlJRTNRYlBOVnNw?=
 =?utf-8?B?ZmFEbEJPNWZscFVqYVd6VG9lcHdlbGJBT0ZMV2hPVFZvdU5Ic05NdWJ4eFhC?=
 =?utf-8?B?a2swQnlybjJ4WlJxODNXNkcya3RwdnNDMVM3RzlVR2xlTld2THMxNlFNM2lr?=
 =?utf-8?B?VW05WnNkeEVMWFE0RDRZS2lhU3UrNXRwa08yVFViOWxZelpGYUF1VjI5ZTJ4?=
 =?utf-8?B?SlJjaTE1RG8xRGsyVjJlejBYeHBOY0JHUmtHNkFMM0RUSWNzTURtT0ZNTm1Q?=
 =?utf-8?B?YldZYXJIT2VTOGxzSzJnRlRzZmVPRnJ2RkZ0QXdVWnR5aTlOVkZlNXlWbkJL?=
 =?utf-8?B?RTgyck8zUW05WVVjRGdjRU5QdmtoQ2FybmVNZDd5cHRNc0svemdwUGc2OWxF?=
 =?utf-8?B?Z211eVhIczB6NUxLckx6d3BRdU9tR3BFT0xxWVZ1ZjJ1WFdHSk82Qm4zd1dz?=
 =?utf-8?Q?SGwa4Xr7Tby48wmA+m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4e73e5-3efe-40f6-982b-08df1a725cfc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 19:30:59.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMmG82cICUQhHSQf1Y20zN/xZl+8uxsADN0PWTOSgERaQzs1sKW52PzuP8qTMUcP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7554
X-Rspamd-Server: rspam06
X-Stat-Signature: fia44akayfu4qp3yt6hd91qwn59wihkf
X-Rspam-User: 
X-Rspamd-Queue-Id: B4AECC000C
X-HE-Tag: 1790278274-627440
X-HE-Meta: U2FsdGVkX1/OrMsbb4gkgKKhe/9AjAWBBCUSSPPD7t3+49N+xnR4zsRhlO+fYROt1HKDkaJjhVfFWfixMYuOygW1Y3GB4B0eExv5CdIVv2MpBjXx9VJ0de2bXoUIChvvZjAb2q+Yg21LYQeiuzFl+nCXYmXsAMHhoRhsqv2JddZTWcavDagDYqGBgpmht8J4YMLvXYdwDLTSSS5fdvkcgqkPs457c2A6aaS0GA8K0+Of3iZ2MJbWfbtt+eG0ltCldhblHS3d+ZvskNIHWENrfJg6CUOwZDEprSLde4rVsFVu+90DR9fckxkXSd42Zth9f3hvOz8Ps+yB34+1cGzbdfBfCzWY3TLKwoQQ55e6DWKbraPzNnTObzKexvtt97fhgyqucyk6npbg5V6zo1BGeV49u7rG1yXff6C/055/SJAXMCtSwl9Nsr4NfbdbP26pMTePIy8My7/XUXG+V6SnyvNWQnD2PePVqig2TM2DsRO9a+6BW0OaBx+UqdDrUQEsCnSbjkWwt3254jB+YB2ukTCer8kxz33oIRclCLEgkHxrnGeYziU963dAqdGUBYR5OpNHsnhmdK567IFbFr9H2yTZa5ASrWLjh06YOof9yKLiHzyyxk7/ILIrCOPEmtpfFogyrNqM1uuCvYlI3Tim6WCxoWdKm/XBHCLtpcSUgfN68ybYUwczVjxzLF4hftjtlN5jtpcp4aD7doqJy1JBxY0Br1WOS8hBMGPbzHE14MyLnGbF2URrAVzlOdkGV69zq8e0g7OMbLH+voe91V4F7Y+iHle6WIwbp6VmT3P7PO3SjfbWlWmMYO8kqRLIwQ0QGa5T1kQJRgppPl3N50/P5Fxsr+l1Jii7OezmQ04qyjtnqj6G0LuEtUsSoL9w3GSExlCog48Q9Vz70t79XFpB/Csxz5R+yrrtU2MgKsSjpSd2KYjsVmmgkBt9jxVetZW1ZZX+8MzbnqDsPCYRo45
 eBacn7xM
 pEKv25+59YQW6AoSr4jicFUB/OGeHisCL5J2UvT7bg5w0oHdVdTrY6Y2DwAe6MazMjIxV5fd6iNhFyHRDdXv0BNuaS/lpQFqotej8u4mW61z9ZToH4RXGnsAZrsIrZMFT1526XZS41Sq7KwQf5PTTdV2eOQR1mzr3zUmtkA8Y0fLGwSdO3lK96ywjHU/AOMofpDpSa+6F/pLciwU5cdXA61ht6zS8I4makK9Dj5wS5FbO1HY6u7fDnoMa3Me2eBi61apJeR23GqMzw2I86Q34p1MTgaCyEx7A0TeC9lp/vaW4suFdfBb9RILWA15iGuGlfqCCrKPeglPIBeZaDfbyOMo3kb5bSPoPmJ0GvnuL5pmMXeOuw20tskDK1qfiQh0YOGHKeXd+8neJM7rIjSxePtyka81s93r1fIzUbzERcdsqcjyeBSlJyPeaEua5+AUbxHCbxFVCdibeUG4iqg7paf0NybFKFUdyu4tjjBqFc7weTixSC616T3trIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied b=
y
> MMAP.
>
> Also while we're here delete useless comments for mmap actions whose name=
s
> clearly indicate what they are for.
>
> Also update the userland VMA tests to reflect this change.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 2 +-
>  include/linux/mm_types.h        | 8 ++++----
>  mm/util.c                       | 8 ++++----
>  tools/testing/vma/include/dup.h | 8 ++++----
>  4 files changed, 13 insertions(+), 13 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


