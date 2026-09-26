Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE42C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 02:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F08D6B008A; Fri, 25 Sep 2026 22:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E556B008C; Fri, 25 Sep 2026 22:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DF36B0092; Fri, 25 Sep 2026 22:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 440F06B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:30:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C679CC07A3
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:30:30 +0000 (UTC)
X-FDA: 85254334620.10.1216A14
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id DAE8E140007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:30:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jhyp1dXd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790389828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQMimtvf09yHV27pRM3QAJhff16w1Cd9pOcXbZNVfZ0=;
	b=aeonpmX877NB9S13BGm8cRAAzl4OQN/0tLhgo0DvVD1GAaPvnaPu19uMyTYuBi9m98nXLW
	uicFPH6YhHrSGANvPYZjcNZT2L4qjbOhuH5vugiEnH5BRcipyqd1ARtkx9L8+BXq5VWx/c
	ImbJGZqCDyXCrK0Ztb1efFXgWE0E7CI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Jhyp1dXd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790389828;
	b=A/NaAIOzTYl0oni2wz1EPVbERVpk2uS6gRLlPOiouY+XdCsqXLIoaWMYU2FyGsJKvfwvQ/
	YCu07LnQ+zLfZaWBeECxkdqkrgOZ7qtohpQKs+GxmuNZAY+uwf5V3dHyI9o6G3Zfr/2gn2
	912h4jp89bt97VZTPprbcd802gGAfYI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGt+/rGefaZMuWMA5TLfFlwpc/JuU7A8aX1qxvmvQ3UqMFlQJVm1XDrY9Pcr8Y5ZKk6TdVnsdNE/EklatQY8obKNbNjw9iIt5RwBGOdrT7V53dUHMrtHItSegcD/1hSjYzlQYmbpr9YxoSjWZkaiibcNir347pkoB9QpcEN7HXMIts3SfkoDOARt+imm7QAio7f5UB8bVpkLjL5dknuwhdO+VSeDkA99QogxxaGIaz4xnvMoTDu9M/S21bKi0M3W5kWx7QH3Qa/QKIqm4c0bEw188byJ0H/QNDM47M8N4qC1nuezxQFuyjM358X7ynW0yWbDvrZaunc9rf3Z/mKCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQMimtvf09yHV27pRM3QAJhff16w1Cd9pOcXbZNVfZ0=;
 b=ypj4dpgsiNu/i7tTLJzyvv/pipRpmPiVIwETnar17yFfkLM+jeM9+xPjPYSSM+8bjiBF8h/XO/VEiL36NtBg5gc5XghuVai1RtEZrSTyjWK5ahQA96DI65iSOzNfoESwSlUYjL3zaRDS4r1QK4TECTfHUWhsEGflZFpjND2lAh6HcPEYTlnOqNXHJaqZd5DVYBCckIJRmpOoOdiPHyjKux5H7du7LfgY1M2bdQRUIKTE68vg8/3AwXOXnYuma0s4PHeqYjW0Lxl51b/zzxbXtS4ApR0rePKyeEffyI3KnbJAAijJP9nPplH898ADSInBE+1WN/QGw78KOdatN47CYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQMimtvf09yHV27pRM3QAJhff16w1Cd9pOcXbZNVfZ0=;
 b=Jhyp1dXd0M1VuO/UfCjUw5NuvpMNCOmvbiIwuwrppoASf2Jx85KK5TQmMftiJhMWj3hN1uq/+vJQeK54+ejiMm6V3MB8Vas0ZCOuj/Q6iUebBy6cCITtlKrS+LYimWr2PHsDJ+zhDoStXrJ0hEbcSjfbECJgHtXLQvT4ANHyr6cj5gao4s/Ic12V2Nksc00BlsYLQC+jMpSNYr4Js7hHFOIcAK3DojmNzamkCJhtT2QzcSv0d1FgpOte/Nf9PwxMju68GYUJj2XBYBKNSChYsWm7HWi6+sT9S63PIYLBVRCIJgXjc0OB5hjyRNwedF7BJFo4KyeRvWqDBmjuEFpgzg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB8255.namprd12.prod.outlook.com (2603:10b6:208:404::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Sat, 26 Sep
 2026 02:30:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Sat, 26 Sep 2026
 02:30:18 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 22:30:11 -0400
Message-Id: <DLOW7WTRQY8J.RZ0XDZWZIMS5@nvidia.com>
Subject: Re: [PATCH v3 21/40] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-21-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-21-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0244.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB8255:EE_
X-MS-Office365-Filtering-Correlation-Id: 138fddc9-a7bf-4081-49c6-08df1b761ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	yjqVnX4u7QVMeoGtLZtilVpLpigFGWHuQ2n8R3oTV5gTh+k4sSvcwvhdBdE4FcBYxlT2GGAjngmQGd//PFhv3HshkFRhbMu46G4Tz9arATj0zyb58k/UEXPNtvtqsjfstROxgIbGfZ6qrYZP8w8qXK/mtEmIm83b2o1KS8VnTVVHfn7+EN80YuDipniFrgp18nqs/mEksiGRiRsUqiueQoCoP6DPmwPSHHj5h0lhVhOJAyTzLaYTwHAKibRZVbbk2y7Q6MrMxOUdyvkhWTK9LQ+4WUK5XH+lpAJ1cn32OdoWD2nUfYd6VAYOzH8JlWT5dbP6LnjtuvzeCC31wbS4tpbVQI4WJXUpihedWGYaAs9L4X6ZTvKwb1gnqqFSBjAaOAkEx0zvJsniEAq2263YFusu21vdWStkZB/DOlmKaQx8C5sp1MjZXBLqMhSzVa2x5/kYq4Ta8FQChTEU1aUQ3SLkAyLI0ncmqfsMb4sypZZsd3ybc1V4jNTeINEV/KGTlYlJW7L2ntQc6RxOp8UT1bLXmAmHrb5R+GyRMiSv7+FZwSXABHYxUeeklKDy/4MTX06dj4hCTYxsWMVvpjrBk569iH1+qmWOxgXN54d93bmfLMybGnrrI4buvelUaq0Uc3rzeUx0kHVTq/P+2E3JxTyinyEyXZMDdxRDjbHXuosTIOQnPcRDqcBrOZozt7IRP52P5Dy5RhXVJiR0h4SvgQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzhkM0k5SklGaXJtUU9UZzArUk0xeUR3K2Y3U29yNmE2bjZnZVZlbk8vdkx0?=
 =?utf-8?B?QXQ0ZnRQRWFIa2JoTnJSazBERHVFUWpRQ1I4K002bXFBUUZhdFpyREVmZStB?=
 =?utf-8?B?T0gzcmhhaVRWM1Y5TTJybHBndmRNcFo0Y0c0SDVoenpaWkY5U2ZGdElqQzBj?=
 =?utf-8?B?dUZHRkU0eVVndnhhY1lDc0NaMnRSUVNoODFvMktybi9LUmJ0M1pEalVaQlJo?=
 =?utf-8?B?SDI5L0YreHBkL1ZqY29Ba2hqbll3QnpQdXBxVTMreVF6VmJLeXRKL0Q1V3dZ?=
 =?utf-8?B?SHNrajh2UUI4R1ZnR1d3Mm5aOGxaT1hzSXdEMTJ4UHRQU3kyMUxzOXNtaVJC?=
 =?utf-8?B?ZDkxY2ZIcXVIVjJ5THZwQmo2eStkT0hQU1htZlRqdmlaelZ2cU9IYnRuOVVV?=
 =?utf-8?B?YXJJSDc1YktqS2JTYWxqRmVvZFlLdXZNN2cvbVNybEJTK3Vib3B1M2VxK0FY?=
 =?utf-8?B?aG5tS01XVytpTEdtaUVlYVREcDZsTnZkLzJpUTUvdVpPd0phL1UvWlZhYUJ5?=
 =?utf-8?B?R2NneHBMU2ZtUjNnRm95Y3RMQTBCOUlnTTR0SmF3eWVZU0tpU1JJbVdOWmgx?=
 =?utf-8?B?aEQwNGhvVi9PNllGbzdEZi9qM2M4M1dRdEFmcnFpNEQ4ZWtSTWptc3BMbXU2?=
 =?utf-8?B?SmRNUi9ZT3dMOHB3dlF0dGkxbmhIRmZvRUg3WjRZTEUzWU12Y2d5dzY1dk1K?=
 =?utf-8?B?TFZ6N1lBUWxHODZFNWFhUUpEcWZRbmc4bnlLZ25PMm9mYWQ4anplWHpqVm1j?=
 =?utf-8?B?V01SVEx1ZnE2VFY4dVg1ODJYT3ZKdHZtdjg5MU95bG1XYjFwUHRBUmI3eUhp?=
 =?utf-8?B?WG5tSG15K0k4cnNMUGVOaVQwSnhLd3lFWXhtYytOeDZ3a0NQY2hIbzZxaVUx?=
 =?utf-8?B?NDVKWk9reDU0ZEN0c01IZmxzR0YzNGVhN1NndG1KRzMzTkVXNDhyRkRkUG9a?=
 =?utf-8?B?WElzSWVONjVLYWprT25WK3FJYjRMNE5YanFURUFvWDBabnQrUStwczU0TjJS?=
 =?utf-8?B?eTlCQmhycDNvMlVveERiaW9aL2JCMDROUDhtSmRzOUgzRHNhMm1GWTR1OEtJ?=
 =?utf-8?B?cmcvcGx0YWdSLzU1dDV3WGpocW5ha250dXRyZ29ramVKS2xTaEZQd2x0Q3Zj?=
 =?utf-8?B?SlVZLzJyOWF6bU9QajFxYkFKZHhYK2ZnempmYU5zWEtuMktWbytCMGFXR2lk?=
 =?utf-8?B?b0wva256ZDlIYXY3M29yL3V5RTZzc2hUV0FYZ3hpVUdURExNZVJ1c2VJN3Ir?=
 =?utf-8?B?UHFJbjgwZ2tmeHBadXNYWnVIUVFib1VldHdyTm1ON21CNmw1djZrakl1Zk01?=
 =?utf-8?B?TnF1NVRua0RJZFlBVFBjcGhKaDFrUU9mSml3Y2F2Q2g5VUlxYUtRTWliVCt0?=
 =?utf-8?B?SVF2MUlreDljZ3B6WlVVMFNqRWdmdC8wYXRNYlZSRys4Vm8xZVAxQWUvSzZN?=
 =?utf-8?B?SEttR0tEOEFDYUc0NkplVGpub0FIZk84ZUVnQXVTNGZFZWJPcU5hbG5Xbi8w?=
 =?utf-8?B?b0FNTEpaSFM3ejhoYlE1V2hxQms2NGRvRWVqUk4wQUNxZTdtQnJTVEl5Qlp2?=
 =?utf-8?B?VUhHK2Fkbmc1V1lJNlVXS05QVzdlVHllblZTeFpTODJudHBKcmtYSUhuTEJw?=
 =?utf-8?B?NzlPRjJMNkJ6eUQwV3F6eVFLUXZqWEZoM2pWTTBVWW9xaHBQSHZvT2o5NFdi?=
 =?utf-8?B?N3hCS202dzhFVVJDZUQ2NnlzMWxUTDd5V3ZHUFphZnBEMlpLNDVCeFVMU1JT?=
 =?utf-8?B?Q3FHVzlOSW1mcTcwODVqSXNMNWoyd2hYSmFWdVVtWXpCNEI4ZzdjVC9odDJa?=
 =?utf-8?B?c2tqNW9XRjY4UWJHelgwdmZyUEJJL2RubEZHTmc2RnlPUjNiOFhYVGhIOVJJ?=
 =?utf-8?B?R1lTUlk0eUxJLzNJZ2JRYSs4Q1NwU1pLUUZob005VDFRZ2c2YjQ4QVlxU3RP?=
 =?utf-8?B?Y01DRU9ITXllNzgraXZkbStsWWZGTTdXdWgxMk9NRy8zTHc1QUFLcW15c2Zq?=
 =?utf-8?B?U2JBSzZPNjVjTFF2cnJzSnhaU3hySlNSUWtKeVg3M3EydU5WdHNjOEdNVXA3?=
 =?utf-8?B?QzZTOE1hT3RDbVRvdWg4ei9sYTljSkFzZE51S2JvN2syVGVPOFhPNTZyWVlQ?=
 =?utf-8?B?OFo1R3N3RWNUVlhlKzRxdGRjZWNGYXFRSWF6T0lHd1c2MHF2ZzI5R2ErVTJD?=
 =?utf-8?B?LzB2MElydjR6c09XZ2g1TzRzTERTR1ExR3VQeGNndU1MTmdrOHQ4WmVQdDJx?=
 =?utf-8?B?NlJBWlhUYWZKSW9qcDRLWFVYSit3MlhHWHF3bkxxRVYwelhzMUNEVGVtNG14?=
 =?utf-8?Q?unUmaXGZA1/PSmHZb0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138fddc9-a7bf-4081-49c6-08df1b761ace
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2026 02:30:18.0846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COb42g68OUl+u5Cs4xToYuDg9UqVuTh90oapNXsS4S4BMaLi2HZXpCMHLeL1bQQI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8255
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAE8E140007
X-Stat-Signature: 57rmqryzso91up147ahnduypy97bmd6k
X-HE-Tag: 1790389827-841267
X-HE-Meta: U2FsdGVkX19udNAFmhwmjdG7o8DyohuFYX6jJZ3OJtySHQ6GKYGwprBeFKav/fUyEVUfxtYMyCMvQuXgOUdf+SU4myDm0IG9/AefziE/hTU9UK0GNUe8ProyMK49MQwdVdRisn72FVFk0LRVvgV4rMQHihWs+x9y4W01PUgnZKpVSfzsaB8qD2QX3CAe+HOpWd5lON1xIvuP4kry0N1V/meiodLX37leRPGX6OANqKKEz0jnXrT4sud5A5BXwkrajz/qGXeUjRO61j26CTSSKQG5ElGE8X6BuNz7WfXAuWt3VEztPhLoCb/aXjxW7PjTILVZK66+6ohO9BXVN9Mj2Ko0Wrjx1iG9eSASkezmW1To0CwDzRL+19kvKegNOU6prSNi7y7zkxNKNFVg9IphxgD23IJr1Uni1OyDo1lKZoTFeb3e46NHgVs18jj2Pyz2ia+ZUl+VJ1kjcu/1g2Ahr2rl8Bw8HICaDJ4QRVd86zyXwkpFyMPGVHxx4XTe6ClirNnznYjV7tRBlDc9KVFgRBFjgk4Ki20eYvKHe+o5M6lVeTN/zNZjjZhVSxkDdoXgU7+OKPbkAgAl49vWY2AIbRTV6w+cMO1K2KKe5+aQRpLxbiirifONQBJM66Qpr/fRTz6gr9L0QqCXQY4sHB9bm5dzUShxVHPsgYvhNwSNnRCC3vQPutIOIxkO5hQt1DFpHUJEXAmuEhcW9BRHc8LDtNWVVjGgDM+SEI53G8Pq+JXtSULQ2HwCTAZ0zeespOrTa3f2VNTyZeNGYawTxXFnWUs55oD9vpi39ehuRV38qXIrxt1JRD6NKzJ77x04fC0Q3XerjJsUZD0+OD0QOFy6ZqHj/7r59Koeg+yDyegVZAnUO3map1+7YTZDQqyIPKHDuiO+ML1lRayFQoMnuRuMO3k0GWEwqHSy3Beqhevv9NIo+6ZUZZeeBPLra84WD9twjRlmcDUXzvjNBl0KAq0
 neG5E5aU
 KDtbmWaJ2B0wK/ZVmL2zZ3Bo1zgUYe/2g2V7M76K103mE1F1EftoMNIGZFT+hn+tmT+g5NM4iDyMKZFpm+qTMnK9dcAGd39o0GNCp/z7qQJPx+zOIJQbxatBIzChBXFbL7NT64sQeaFCo6xxj3apCd4Xq8D/doEjUTLhS7bkNOSM3kjVHNWDBOqrAnfWdtS3LozzoJiA8jsAUOfE48sJB2M/Tg/cOgJ/pXzffh3tKF0y42JhhVB3ci0Ac6WIgtaGryAIsiJkyBnS/oTY8ggopgK6K5Ld0GxGmeoKLFCSZvxL9S6D3eg7tVyV9iw4rUQ+kioHvbwtpG1yfevwbHezQCTVgD1Ht5IqyXP3iO8wQVpc8Iuxdh1/60drAVLwL5kH0hPIUvjc/u8B1mM89SgFAVHskw3lf6TwDE+LOqCgTWVhSatmcHxHww977y6SEKjkjj5RqpKSaYogBkLvxtqDTlaFzRk15fYqfk1+Uubot2U2jeUEdsxzymgl6K3vtzhG1nfIj+cTo+qVUvLZoID/OXNsoahJZVoZsmQIrmcDo0ml6RRBaKnd7rOJWaxA2M/lMxp/AXbOTet+n3dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/gup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


