Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907A4C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 02:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF156B008C; Fri, 25 Sep 2026 22:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F5A6B0092; Fri, 25 Sep 2026 22:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1476B0093; Fri, 25 Sep 2026 22:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10C4D6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:07:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C2A7C079B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:07:58 +0000 (UTC)
X-FDA: 85254277836.19.467F694
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010051.outbound.protection.outlook.com [52.101.56.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE18B140002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:07:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VfXVp6Qn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790388475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTkq4eBHcqxwTjqso7JND2boV5E9CK+kC2Czy7GR0LM=;
	b=nohl+YCypcDUzG+x0YXbbOgm3kAn1zElxCS69Ft73G7vHSnfMH9qXw9B3YZb6U5eoNXBGY
	phIorGOH/Ra5pjuvlCHRcmXpntioz3dEdUWLXqv9EJaXQYAl6anOaCXbIzvdp0vd6r9hM+
	rOHu5U1tf8PxLtADJkYhQq0OLUC+LNY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VfXVp6Qn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790388475;
	b=HCFdMuDQhwQ9gQ127Eg0f0dwFhAP6vtvQ/eljN58Jb1tQV1LhQO0YBLhOwqbhlNnPzxARI
	rAvdDYITo/Kc+9xaw4UufPj2W+LuHHdeFo7gl+4V37p/e0vwIEJEp4JpVIXWr5se7aOacN
	nh/vtIWzen3lKWfa7sw7SSHpAfQhdVA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oi07CiyUN4WkiHfYYNkNaP5NnQNRd93uL1yMKrDHvV+wKVXOJfe2piqRQTqhF+kbDhGVUqahaR7TQDaFTPXdFhEFsUgLqqRJXkTBKhb2TwBJyXkb0xUyCHIhpR/KHHnjC88abM3XlrLeGthGEFz6n1/W/tEz2kE3XicVm29Ov4srGeBgtr0h2IsUo16+1aTfEzV0e1LhJjOWUfkvVGTAr7WpGVMWJJqBBHlVW3pNN0VYgKMx7wnnsYL7lZbUZZRgHS5uYOn1W6Qk/KaRZ/TSTCCUIuq3d5IpqIxfis4asqqshY06lx2eUUsPib7HCKu8vvYkRcnj9BLCP+9/Ov9VVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTkq4eBHcqxwTjqso7JND2boV5E9CK+kC2Czy7GR0LM=;
 b=LbonY5lBTWV/20ve0XBP9lkUctnBnctg21mPPgkRJWKBxb8LFY2xauBBQe5TfocvyeBfcFCzXCI0xEu9psHS/3bpjuJjsykTEqlZwsgBMr1/UChWf9QPsq0/mHMiN1nfazdkOCJ9NI32mB4OMF63nRd6Obgr7TatfgpVsfleBVn9615+4YJ6WpvX9lXgku0B8MPpRnZCn/BCqz7rxTCmnZSGVOfAxsDAUyUd44YBuCYkkLXyE3K/hd+4Wn0IkUiayODN8q4brhgH0gzBoPZ6UwINnPtKZG9GPm/D6p4nZg0Co/TzyWOcTKYXKwFE2zQisVG7QOCRMZMeN6Vmn5VCSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTkq4eBHcqxwTjqso7JND2boV5E9CK+kC2Czy7GR0LM=;
 b=VfXVp6QnUhJZAUxp130oeCfjOTXdtvgFnF1aofWM/bf0wDaKY2l3TqCuwrXk3sOZ1EwAJe2ucSV45yGt0ozyod/bKGfXZtbx/YyRBa2jwZEPbWJmJu3hQqoA8g18T6cIC8y0PO1z49X9F/GuOHJjrmLJO1MQQsox549p+VzeRE8Tq50cHQlnBCcIfhhzvcqFdosr2ThhM+VlAYNkcB30hzvjTCygRYLLbNTNX69z1i0RIXUV4Z/1pBiJXOX3XMPd5cI66zyYtsBtqkJfgaQmtvXTtU7bAxSR3pgWwgKWLzWude6Us5YBahmIFcvI0AhAtH1gi5uTgeX0/JDUz7602g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB504719.namprd12.prod.outlook.com (2603:10b6:8:4ec::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.22; Sat, 26 Sep
 2026 02:07:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 02:07:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 22:07:36 -0400
Message-Id: <DLOVQMACWLZ5.1WFOTGRG8ZG92@nvidia.com>
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
Subject: Re: [PATCH v3 16/40] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if kernel-owned
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BN9PR03CA0053.namprd03.prod.outlook.com
 (2603:10b6:408:fb::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB504719:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b0d669e-e538-4760-ca84-08df1b72f1f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|10067099003|11063799006|56012099006|22082099003|18002099003|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	U20ke2FEct5lnirr8nHPV2xPdFFLDatHzv157KPXp0jJGykYpuWfr8HMqlIKmnh1EOvo7z2Lse8WWRYcTm4xN8+3XvLxbt3PoKrUkmgHE5CQMwh9J4j2EnKbIjnBorOJTgrNtxYw/4teFFeAWO8quyn0jdqqnbjdSgQHewruRq6pGEV8oj6/1RqP1XZfxvYI6PtYqoNweQHOgLHpBgRwdsNV2qDh8/Wp+i0Zct4rP/b0WlFJkdMMNOwNtFpv4aON9l1qcTheVetJ6mTjQHMV3KtryIJTpUvD611z3awLkVxMORZw+vrZKAXeRWhH74Lr70PuO8V9JYvGHBEh5d3X3JbhAkPPT9KlFkQI+5piUZIl+ZkXBdQt/lQ2qr0oO5d897zXH3ViIGpShAuE+Lwie4KCqzEwM53AR0Wkpc5UvqKA6mJ50zf5xgs4ydp84QLNdW8lcsxb6zASB5fyVce2HmQNDd+Pd0eGYjyIPWupv2yUB+E2YjHmo12kg9W9ZCg2gW9wQKUh4OKaZQYufdGstIPZU7lAbZz/U+7Hw25SjWU5zYps+hiOSYmfeyBqnRa0qyXfEC4cWOrXNrH1w8V3Xg88WjRrtGl6CtdSZLUVlAdCOQTJvIS/wwx356uz2m5lMsgO1/CKmpFd9MqzYDRrzDOxnr67lbmNtMlbrZfoNh8XWqh0rqIkkZkgowyDEbXsIJqOavU2paJsTH3RjI23vw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmtnajZyUFBLaTFwR1RlZVI1SnR0WkNwMmgwVkViWGZuZHlQQnR6SVZPYnp5?=
 =?utf-8?B?MERGOHNBbGpjdkYva3hrMFNhYXd4UU1manZubERkbHlwcFJhckhjbUlEK0x5?=
 =?utf-8?B?alpDWCtzdmsyd29qKzRHbWM1MTRPemZDOVpXV2E3VDBLWi9XaGRSb3BkZkVG?=
 =?utf-8?B?TWRBbGdHcWVWRytBUkE5QTl4cVRKVEVpUjdkbnd2VUNuOTNaUkp0QXVaY0Yr?=
 =?utf-8?B?WDgrK1VxNndqUExkSG9KMk1TTXN5dmRGaHlrL3dlMEVaQ2liRHRoY2MwdlVQ?=
 =?utf-8?B?NTZoV0FwcTBtSlFBZ0xpNDdpVFdVbFRZbmgzNkdTTGNoMUpoMnU0ZjJ5RVd3?=
 =?utf-8?B?L3BmbzdYM2Vnb2Iza1pQQWNqc3JwV0ZqVXl6cG12WlVQOGU0N0xMejJzK3l3?=
 =?utf-8?B?YWgzQzJmNXQ1c0ZsSG9KZ3RLZ25TY0lMVkpwZG9wUjMrSkY2d0owZ1ZDOTh6?=
 =?utf-8?B?cDBpK0o0M2QrSDMrbjFianhRM0tmb0JzRjdzODd3Vmx5MUh0Z2ZjbzVYOGUr?=
 =?utf-8?B?cS9VbE1MYVhybW9GU2VId1Zld3pBem9hZ0FCc2tXSVBZamczQ0dsR3FwMGNu?=
 =?utf-8?B?YWM2VHp4VFQ2UHFBK2hISStBZHExV2NIZVhKTy8wdVVPMGlmdGVROWk0SXhT?=
 =?utf-8?B?RUdvd0xRdEJjM096emVJZm5NUmcxNFdhU2RWQzl2K2w0dkZXYUxycTdPbHhR?=
 =?utf-8?B?UTEzbzlTQjNrM3o5YUZ3L05RRmRaRjN1MXd0aTRVQTJWeDRyZDIwUEczS1RD?=
 =?utf-8?B?cjJod3NjQjZJRXl2RXJQRnk3ZlNhZGlJcTVaWHZCUHR4eTZNQitCSk96U3N1?=
 =?utf-8?B?RXhQNnpRbHNBSWZ4NGI3RndxU2txQWRSc1VZT2o4ckcweit2UjNNeGhiNitZ?=
 =?utf-8?B?NmU4c1A2cFVVYXNpdy9sSk10c1RENGJzL2I2OWtIZEJmWlBYeWRvQ0ZPci9u?=
 =?utf-8?B?T0ZuWVZsUWZzZXBUTDVhR1RTNTNaa1YvUzJPMHh4RHNNQ1lDQUlIY0RTdzhs?=
 =?utf-8?B?NmVLbmJzdHlnN0l2L1lmVGxZSGlGSHoweUJzNlhHM3J3V1ovOGJnYzFhNXhv?=
 =?utf-8?B?NDFhMEY0QzNESUVpTzNBY1IySHdjNUNIVVIxa3RCMWgzOTY3TEl5QkNRMnhD?=
 =?utf-8?B?SkNGRVhjUEtvMStFUElucGphelRvM1oydHhudHg5ZHJWMWticXI0UEJOSTA3?=
 =?utf-8?B?YU9JOGxLYit3ZEdNc0V6dEcvOTR3OVR0akp6S2NtSnQxRU1QNmNISlZ4QlR1?=
 =?utf-8?B?UDd2eHVTbldnb1pjL1llWU82MWRYSURhRWJUSS91ekU5TUxZRk8ycm9KTnJs?=
 =?utf-8?B?SEc1T0U2YzIzWEdDNDZxTFR2MGh5NlZMS1Raa0dvb1hhQVFvaGhpUU9Oc0h0?=
 =?utf-8?B?bi9ONGswajBQSnlDV0EvUFFyUVg5YnlGVitrb1dyUnkweDk0ZGtWc3Y4b3dH?=
 =?utf-8?B?alE5dHBUU0c0Zlc2aFc3OUFGdVNrRk5ibUhBQ1NqYUpPL0wzMmcrVi9NUFdh?=
 =?utf-8?B?dVVUWjZnckQzcndidEFicy9HYnN4ekorR1RsdXc0VGlnMVZXc0szRFBXRnU3?=
 =?utf-8?B?cTZPcGhGeFJRVWlhemcxVm0xT2FUYi8xZERham5ZVldvd1E4UXVnTzVEbzRl?=
 =?utf-8?B?NG1lcWhNYzdhVUI1TDdRZWd3TW9pdkoyOGNERUE3Y210ajBMYkhlRnV2R2NJ?=
 =?utf-8?B?T1IvR3hpemRJRjQ2OGhHcTRyTFhFRHM3bmhReVpHQVJPWmJ4Qk8wTWhjTHAy?=
 =?utf-8?B?dTJHOGxTUE5SVFNQNFZkZDVXc3lHWEpxL2lhaTZrbTkrS0hCVXoybG5tL1JH?=
 =?utf-8?B?TFg5VG9acitxYlhoWGoxVUc4aDRBcC9hRFFWRVp0WHlpVzRIT2Q5YVJsQU44?=
 =?utf-8?B?Tk9LNkNHaDVHTmExUGwrdTlnNDI4YTQ4eDVkcmNBQTR1WUtrM25TZ2tKWUNv?=
 =?utf-8?B?TTFEdFRuY3UwRExOb0RTSDVuQ0Q4dit5ZnNHdFh5clh2a3U4cVFUZTdCeVIw?=
 =?utf-8?B?OEpNZmM2dkZISzVlaDFicEFUQ1FYTU5NUlFNdmJkUkVXdkJ4MXhDUGRETzYx?=
 =?utf-8?B?bDVEQysvTzBmQkNqMzV5WGNkM3lsS3ljK1Y0aUdDQ1pIVVdBYzQ1dUo2L1dQ?=
 =?utf-8?B?ZVo3NlA5SFRMOWtDYmJtckwrYWl4REM0OTFQRzVjenVLczdPOGRpNUFHRnh4?=
 =?utf-8?B?NnFnQmJJbXhyWFF6NERMQWFBRjQ5dk1zUm9ETXg2cit1ejRPVjgyUEp6bzRp?=
 =?utf-8?B?RGt6ZXV5eXRiZzhxbzB1KzFYcTR2Ry8vWUpzcUVZN1VGZDg1RnpMTDdzeFN4?=
 =?utf-8?Q?GmOh2k0mOxmUylDjHI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b0d669e-e538-4760-ca84-08df1b72f1f3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 02:07:41.0639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAuLETM+wQCdkvZhI2SYx1C4HUCUVY8sKefe/w1KE/b/I9MkSgKleu4Rk5NcCrBd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB504719
X-Stat-Signature: yta4ijphjbia3j4ce6ym37jqamfzpdgf
X-Rspamd-Queue-Id: BE18B140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790388475-760529
X-HE-Meta: U2FsdGVkX1/S1mbwaMdFqCuTCpeuQSD1TegFJJm6pv2UjeH+66MU2Ebe4wRyDCnZUNwi4aQ0gbZs9iOsyGFg3rTqQSki5ExwkwgQRm9NQv2xnzg8qJSt+QLHLS5scOuQR+AfbDfq9IIeFzN/hTinyXuKblN39ZhsqrGk9p3ca2zJKhW3/rIhUN7+SZSMAU2XCznZrzC4lq39oTi9gVtKnmAJxeUVEzFJWVdXvnBLydX8uu2m1XDMOxs5wNmZqmQ1W2DQ6dfkI4HqjekgZEG8ScyfaQyc28EcEy1nTMgNTRHl7k379fnTDYmzAK+8/y7dgPgvbqyyr4i82ye+Zd0xgd4pfiCtOJvVDBKznm8QUDTkJL/R4n3yyExXk4ggrJARb4gh5sSH2dTsZCrxtMPdjl7rsdjfuLJjnsN1rMbLaLaOHEFDeqEaEi4bTNe9mXMXfQiy46Dt/3nJCpmgr+jLgdCzCkJcdzJYi/LKpSUZleTJ9iA7rAsVT0zH7dM8raDi8R2S95n3zTi4NaXFwSoK0GjE0gr6vqrbHHCJ0GB0yW/VXgw6xmbcdcRwW897SHbr46QiBxk/5So9X2NpuJYgqC2D4jH6koqpOQS+ubEXAKnvyrcXnh/eEHNrghnCPn1mBmSKO5Rwa39yYErA6hejwghrahClvwceCW8h0LQkZsbnRAOskmyQACoOBMcGS1mF0ntsfnozhbxE5Mi0VR7ryrBePhKHY6hyJiqRawurkVfPY+H7Uba0i+FPb3d1OQed8yLWIhNWLciV73IZ2Pp2mSFHM9zcGrZLz7WLFLdReuhIeXnwX+AxhixkBHR6qqtWt8LiDnLWZmqZKfegKhVYtv8d1jkY7pdr7FuvLlmuKrTP63uWaO8kDidkXflOhaviVz1Pf/iPjoFcQ5XuiGE2OOM3cZUQAGUhxnDCPB+unY3wcFtwMfaijW4Y40xJ12Fx/l2D59aDaXMXWKYOKX2
 MyN+prL9
 9b9Y0MmG+5sfbkXaUjCJ4UzMDj4ktdxlVurAcUb2bbVlXz0AKWqSmudYM80vqyVDlNXxIP5TMq9HYQCbl82z8p87XJCmoP7OVPpRV0Z2vBLYTKWnQisEOEFhhfpV6z8WyWyEvakVcyVWAVlycJXNdww0U9fcOCIS7lIV2Z7rTl2kLqT9jk3uL5ZDFF6oqpCqQzwhWn11QrAgq0hnUt/R3q/MH/P3pBu8qAUaSeSINf+UNjGGkFNaLIy1YpAjbioKjddADAB5la3QvO15zE8AVd64Z6JcANCjQ+OZzFILzD3YqO15cZnkt8mvoE11LpNHdta61cmqwTXiJDlElZg0dEwFPujsP5L/CROMc2tYp5dT8AVbltMlg2rcVYcjv3/3kjEl5JyUDViPHE/Par85iMSMGZeaMQbtzfgrus6Vh9Q5CzM9cannEKkXgM74qAO2uik0AwkjPocjalKrqR8M2VqkGwp8B1QZUwff4mx6iijRgROkBQ0LLkcD21Nbuw5RqXbDO9YvBn4iSiceVa9TY/zrennxIpN+4c9Q/5ElvhM0yw0/z1Vju364NWF9kRCblFui79JTyj5L+UxSNaSlIEmRDF1PYEzchdj/JSe5fMAp4s5rziZ0Grh1Hm/cJdX11qYX+A/9BKbDb2xyuqsifFgCm7Cg2UXpJ01NrYAau6dScdnDvPlPOzHlIwCuP0TWTfrRRHW+szw+kQ4C4YR3yJF6B8wG8Iu1rmYP4sEnlD358t6hMxS94jx+TYBW1CXiAMmfrYfG7Epkg+dBdidbg6Y+Kp+si8bLk9/lT+1L94wa1WWAd0y9v3UMlqug7a5NYH0XQ1lHKeDg5/iImd6zRmtlE7Gvv2LJ3/9G4E8d1vSdEZuRP06c3S7B9XrkV8v2/QQ+A+rg9l2xx3Gh9gxsReljkRIW/INXWLjf658wuXOsmu3+maZkouKc6mt5viVQTnBAvF1vpfQgw324NEiK/pdgKYJBj
 tyvYUeo4
 4GIMF93vnjInVJVgLT/7+0eEd1mf56aPYYOrAE7d8QCnpDxUzBVPwVDofckUKyd92ATUCNTm2RX64uQzuafm68EBLtkcuoEcszZ3RKZvfgnR64tyuFMxr3/UcK/hlGqSzF56mg+gk878HRv252WdnEMRubif1SSZm2gCwL/zTIi6d8cLL6D/MytjijDZSR0QX/q9Mez6LBypSHSQ9kuCTVPksuBsvNJ27nTb/h1Z2uNkRDnOg2BRY71ba6eF64OpvWaLl8J0XeEaEz4YdCz8rhpqGjMDZLhvqhQVdUc4x5tzf1IvNs0swVoyzfKjo+omMKFP0TYZngwMJmfIxmYHG3b54Ni6yVZyEEzrRxaRk85iWJCWuI8yxIfQkVSPYfZA58fSvsXnJuvTWgDZtjUFCpKPwx0pSKJvWQysO1PoBBS5VZb1QzoesQ3bSw+dnLMYvzC1gKibUrY+YSQ52E1/WrAJsRcWAkilwI7+b2q/QTz4oO3aCWFT3M9RccnYcUTMnr90vzWOWO09qoYzGhdcoVk1/7s6edGXGSpevwqkR6e6zM9y3MjKPTJQ91b9zEIezYPjdIH0CsaI7+7GpK6X1hCkj7tEfKpIVB7mzw+VFORzTxwXfoHDseKXMQPhrp0aCdZH2mXArTJn7y9X63Qsb43rdauXPucGiyeZagaSXTGT+yUREsN9o92tWSmOr7z7mUV5qL6aMiWjyhDCm2pCrwZGiOtFcHL1qb1asDUgxNluXwaIymunvs5oUfD8sj+TyZu2AKzyE3sJKKApPfB3nZ2Dzg7sGBxAENUTQCYZy9MYStLMYXgNeOEnEzF01/zn0qbwyBnDo4L3K2FL2BRYgZfTXuInRxTa65gf5lXYwoIYUEW0uWDaWDyzZJ8altk1J06qmwpNJDs9gqIb3/NSsmPMTee92LHroma53zeDdwYMATHM8BkzJFp2qndxeXyq9lq4ZreutorOzo4MkgOR8TpWngm0d
 tedQVMJ/
 1st6CJOLrSuRM8kJmXfm3kCT43qJuZJvW6CfcgecQDXwGXNTJseEfj1pWsE6t3t/VPU1XlvhP2WLAZa0s52fky2ycByJZxfJyYuWEMWhrO/cXmaRbq22neH+JR7bvz3g0XBzEBl05Nhq7Zl4NzJlh3V+VIrPE2NgdVg+/7V1RcDd7i0inP3fNi50N9oMmdtLrG+x0sS8SvKwPtEKaLJNopSwY9YSRKAgmjaJmMdg3Mb8YtnlZ9sHT67EecPIJnLCF/NwiyquZGPbSOtn7c62fN+JlOuPRmqkMHyRue7REmYJK38M6jIq0EIUUpnde8Ovu4semVsyAGFOW4iAjDBf13pzwYQEp5hRxE11KVmtO7IY3bOD7iRvnEznvtbelxNUujX/tswLTHpI6yT/m2s3qfwv2KCbit0ki1FzVBKEOI6B7VnEDbHzLzpArpn68JQyf1d+Bd4MhtgeLYMlHAZw504UCh8pCkm23+xeOugN3N74h91f3Z8dEwMonIdYAxEMaoaRvoMb9Auj+D2PW0brbYw4MTVr+4emRDcaJCdL2ixie1AG87ElnOaDHffaJuwYUC9dEh3Rf5u8Rb4Z4A0t6j+EGAlqRf6bSQMkAMVkUJirCKOmXaWl2+as7obmMaVj9vLwzAqzCTN6wwkhasJ/VYVtQRAUQzCvGtWjSvU6eU5HvUikMHu+cqysAH6KZ4qFc5LJ069qEvn1pzB+G5fafk0uaVZwb2XVOhxSlMAR4+WUrUWPx4L6BsofkSdZB6nz4jzBp9Bj/Vp/RoXfcWgrVBm237HgJg8i6ec9JMVrMog9GQW0DmwNAAS3UUgC/caFq0lbicO4b3/ioo/QxqcdV1ozU+1SuykUSMf6mjzaby0wZRbqRaI7wBGOYFoDQm66CCnCq30YnGPnCjgdjmIvp55/x1koKOGxl57XVwnTeVL5EVBGUBkZQ9uQldtckeDnS4OkZ4bB5LF894SgXS1ilO8OQNMxq
 eAMRayAo
 m7slDLuN/DL3GQmgsSLevPlhBO6C39L6H3RIzyVgzZ6+o1886N9kyFY/SkfZT0zP2nyc04Iox5tZDycPZ8dZLP4m4rpm2qLHr4Ftklzb0f2n8eAfsqx04opfYI8Vfi0IsCXbt7Wq3SwxQ3Ob+D6Wp8hYVCrrXYblMt7y4Pgn4qag7mfQmJGW7w40zzsTyp9m1FTXlB94TLsLsGRYsRVX2daXgmzA/aTEITcBFxqKKWliyiFGLVORzUHTQCdwV2mWYsnfSRfKWmoyTXtlZtVvjoNcwQA/zj7YVJqSOKNnmkrjb56k98XQktrLpdKuIGFmF3Bjs9T/pLesgy4cz+ZYKJegPXVJJoCxJihH8B8Io6oKV7iqDsabXOg9jI6rpVDYJBn2WfsRhjb6BsRISpfGoNkFpzGWUME8Oh+iSBY+VlkZ3En/U46jPJ/Y7HHCFefcQhar1TbUjplcNC7o6xn5/EM69hBXuUMfo28MZmVZ2RED4/bADihvPn7PyoRkxHh9x927H6v80Gyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is i=
f
> the underlying file is itself read-only.
>
> This means that mprotect() cannot mark a shared mapping of a read-only fi=
le
> as read/write, as doing so would violate the read only attribute, and
> permit writes.
>
> In general, we do not want file systems to be able to do this for
> read/write files.
>
> Doing so would violate fundamental user expectation of file attributes an=
d
> likely break userspace.
>
> However, drivers pose a tricky problem here - the /dev/xxx file may be
> read/write but provide access to a resource which is fundamentally
> read-only.
>
> Therefore we must allow drivers to be able to clear VMA_MAYWRITE_BIT.
>
> To achieve both of these things, restrict this ability to kernel-owned
> mappings as identified by vma_flags_is_kernel_owned().
>
> This constrains this ability to drivers which own the mapping's contents,
> whether memory-mapped I/O, kernel-allocated pages, or ordinary pages they
> map themselves, and so define its semantics.
>
> Every in-tree mmap hook which clears VMA_MAYWRITE_BIT, some twenty sites
> across drivers, filesystems and bpf, establishes a kernel-owned mapping,
> with usbmon and the ALSA PCM status page converted earlier in this series
> to do so.
>
> Note that drivers may, if they do not gate on VMA_SHARED_BIT, be able to
> disable MAP_PRIVATE-file-backed mapping CoW semantics.
>
> This is perhaps not always intended, but we retain this capacity to
> maintain existing behaviour.
>
> As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
> mappings, no functional change is intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 5 +++++
>  1 file changed, 5 insertions(+)
>

Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


