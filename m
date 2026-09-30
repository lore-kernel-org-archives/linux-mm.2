Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B97CA5FAD
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026106B008C; Tue, 29 Sep 2026 22:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18166B0092; Tue, 29 Sep 2026 22:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8B26B0093; Tue, 29 Sep 2026 22:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8B86B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:42:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3788A140673
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:42:18 +0000 (UTC)
X-FDA: 85268879556.27.ED3F0B5
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C80CA0002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:42:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OrEAaZ1B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790736135;
	b=rU3pHqFZTRof3Hd72A9tA2iKkdEpNgiMUHmH51YU9YNNCw+bUQrQ/HzoksL3RsOqgjhcnZ
	w8Gf2jINxyrNgtAmb4+Oc8fXfJv5nqWpSKR3Wgvwl2ctVgyO1D/mcRvyxLUJt5N4qyDgXy
	vbVgC7jIgjNuoy7aEORLGls6u4WV6hE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OrEAaZ1B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790736135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+BiEqcYJWjwvFrts5cTJ13CyXfWxmFWki6OqmZ4Yyk=;
	b=TFsyCKFFSO4S88hlG/FZTelWUVB7gvC7FB6raGaiFtw2e13Kn2CofE0cFyaRM5oFQ75j16
	IsCgCl3Ehc+GD9luW7J7t2uv3D4Eo4ye6xACXJnABIz4dibLzh9iR86yLYdZTlqG+VhNl8
	q6Hma/Wv1mTkFkiYX4foZQPehljp4kU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FtQr6YoSz25cK+etyqfOKLxPKxLtbAOz4SjSCY045+U9aoFgi8BcMssJI7ro7nFpRy8Fdm79WOXP9F07xz26DyR7nuoD69CjzL1T1F5wi+LkHsvspoLs+9DcbDcYfeLQmmlwWyaeqoFcNiyePg0usPhcI9M0tD5tRwStp5dynEUHIpqmXMZxqx2oiRISm5ERnfqjq6b6bz6iVycH9NfLxxs1dxCCacgSvqaW4o/UwJ5WSRV1u5TlMwK+wSNj7phy3jFUK8SSNcv7oHZ4rhTk0Z+ogSWwBVEKcltdfxyKo1zQPUBTxXtNwg/ovsu/688wj5wtT3YrO5V1O4m+Eix8uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+BiEqcYJWjwvFrts5cTJ13CyXfWxmFWki6OqmZ4Yyk=;
 b=roBGLqJqDxwPTrzG+Lsjqxp9BQCWuy0qY9U0DD54OG3nIHAA0QtkL3xxwhI9Jq1yTiW7ac13kRGyea7IR4KQZalciaeItg8Vytc/iIeYH2HYDLYNCV87zkTtsiu4J5X5dkNoKWf3m9e93SXkuyKAwdxxzDNkDduB0AsNwFdV/svzG7AcKhlThEkwuj4VchlyCYeOEzsiHnLjPvZQtvl1Kc+MSRabJeChQ3qVbudMvh5oMaKnKLvVNJSViSfyKe9SMwPAxVHGxqu+gUTfCjkjk3tVnpUvbPUctAr8OYhxvh9Vqg618HrWBQk4bZjVntxMpZE+BrIzQDAumoKf2XJTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+BiEqcYJWjwvFrts5cTJ13CyXfWxmFWki6OqmZ4Yyk=;
 b=OrEAaZ1BqnLlM/K8+aW0a/A8kb2FLvp/GZt/M+nCSFe3f6hnw+o8zc4yfQfTbwxxtTdc1UefCDr5WKPm1DmVnlxof1bCByBXGfRG3Jkx30HGjG9I7aWaFyowf7BcjAguNl2qnxSIKipCufbiI4qbUnbEZz9osIfKUW+8lbpApYiighm0Ox4nQYGuvGNijE9aebJfQtwCE1zZqIpG/XQ7KvWY0aO3ZH9QYqY+D93KuFEzh1vvfAOgo71dOVti7S5mUyiQHR4EcBmmGDGNa/VzIzDP/stsQRrM8UaD6h4UbiWEuEMVw/7yETwvRizQilU+r9zYYQBY8tiAFFN8TM6Lqg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7930.namprd12.prod.outlook.com (2603:10b6:510:283::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 02:42:07 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 02:42:07 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 29 Sep 2026 22:42:00 -0400
Message-Id: <DLSAZ4ZQY8Q3.3OKOCCOQAFVCC@nvidia.com>
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
Subject: Re: [PATCH v3 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-34-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0280.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb26b6e-b031-4302-30e5-08df1e9c6b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FKdjrhUigjp/mj4l00p6dNSaGADCbUQjUeU9NxoCtL4FESOJDJm5XsA/nJ0ATd/8JJRZb7FYlHM5U2gO3873lgC04i+amKyyNEaizz4tWKXviQI862kGicGpRVSkC4XvLInpSj5I2sxh36fqEwh29klfG0y6BtqoyTmiJs/qWjgH1GhJK8y+6EBQfqGzkANuztJcJtmuVhCI4wtK0Zrze84zTj3mBHustzuxtTeuuFT9ME/93iuO5oZirUfCkKKF7uUJSzvm+3cLutyummxZjPPUs0Q+ZIP3VrUUEKhgHWxYx3WcjpJ3qwMGDX4y2Ky8z2XJbScKc6hrkXk8iJoStOkzCWd6b+XzKWHSwclz3enPiPjZD5FK7EAe0Fka2dlRYz0P6vgrYxTFiFTmTjUOxxNUkGCEVToiG6tMSfmL3rGTLaMXxtEsIu1zm6/kBxE+SIRTnsI0XGEgkfKEFj6nlU71G4+1x9+CyuHlJXZIw95dbISg0SOhR/RNWSGn3TnOiDDFlpZZQu9FyObU4w7AxInswKQefRRXcwSAPw+n0uToCyKOaR1xBQ30LTe4zD2S0FhDxLlQEYA8sKfmhBZQAE3ZbFt2E09wkQhHgBoKGUAeU9a1BnrP0x87lh78CeVKI52rozNqUfdY9sLZqfYLztIU7tQvT5y/5HGvS1n6rGiOoRlTmWf4Dr1mVc656fCSTLZc1G1aJETb55tGWJ0AIw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjRydXM2UVcrL01qa3h3Zlo3TWFaeFJlenpzSlZLbjYwQmJqY0gxcGQ5cnBm?=
 =?utf-8?B?ZE5wTkw2VithY2FXRE9aTTdvQ1JiVFNudnlCRjJSNXJlcURtRmN3U1crMU10?=
 =?utf-8?B?RWVKMW4zTlh1UkF0MnBEaW1QVjBGbDI1U2VjQ2g4bWpHajcyT0pWVzV4RlFM?=
 =?utf-8?B?eHppOFg3OVpQR0M4U1l2L0pCaHg0V0pMTmVmOXdHZnBVdU4yQWZyVWN5eWZD?=
 =?utf-8?B?RjZlTEIydDVTL21MTHRIRlIyajlpTHpYOVlVcVVzdzRnT2NSZUVvV3FmTW1O?=
 =?utf-8?B?b1NpaG9qM0ZvWG5mdXJ4ODdQeEovSk9rblhJeGs5V1FtU2x2a1VMdTBLYW9M?=
 =?utf-8?B?UVRNcklEMENPUWpPcmR2eW4vRkZpQnpDbEFNMzVaSUF0b2Zya1BiV2pxZk8w?=
 =?utf-8?B?MEZ4YUtnUzB4aEZiRFFaeXB4VmNiMnRnN08zWnN6aFRrZ2wwT1NWMS9TNElM?=
 =?utf-8?B?M1dCSFdCRkNWd0hXWitmOGR0eVZhUnZRWDBpWmFSL0tabTJyNWJDVWdrVitV?=
 =?utf-8?B?Y0xGUFBPQ29RVHNhVVVlRStkTUxEbTFEbVYwRzVjeURwU0dZbmkyMllvRm15?=
 =?utf-8?B?b2F4TVRoODZJMjBBOGovODRudEl2NDdJeW1wWFd1ckhWRkRQeW5WdFkxVytG?=
 =?utf-8?B?T2JOZEJnMUl3V2FmeUVucDl6MU55Q0RKdHdNaUZFU2F4M1FxenJTdzlJRnA3?=
 =?utf-8?B?Y1hPM2dWV1ZNQUViUi9tUkV3OEowQW00TTZtaDNlZHd1SFJ4UXp3Q0Z0dGt2?=
 =?utf-8?B?M25LSUNYenUwNTJKRDViRzRYQ3gwWUxLMXBKa0FDbFVKM2hHOVMwWERCc3M4?=
 =?utf-8?B?M2lMMENsUk5WaWNPMGFWby93aHYxZkV5NUd0OHlLUUllWkhURnBZdmgzLzVH?=
 =?utf-8?B?b2FORFd4RjZFL1VlN2FTSHNCMXMrN0lpZG8zOVhLalZ2ZUxpL2JmUVJSNG8w?=
 =?utf-8?B?ejkxME5URjdYbGVscElvNmd5L1B6NWJhRVlBc0FwZUF4b1VjUS9iMFhXd1Mz?=
 =?utf-8?B?cW9zaTlGWUMycW8zNmhUd3pHSWFJQWZPNHJiQ1I1Qi9jdzFSbmdWNTUrYW5m?=
 =?utf-8?B?NmZJUUFWaTRJK2VFSUtJRWVKYnBFRGhCWjRKNVZKQk9DTlV5VUdzWkJHdkxk?=
 =?utf-8?B?Yjd5ZE9QNTA3SEZLVzBLUTJ2cy9mc1VERzE3M3RHRkFhN0hsRkNhd0FXSnpu?=
 =?utf-8?B?WlUzbXhjZXdnMW8xUkkxQUtkeTdXSXhPNmJvdXpUVStOai9KcE5HaXVqbjZj?=
 =?utf-8?B?blMvN1ZHdUc0WW1RaCs5MWVtTWdjajhkZldoQkV0d2ZKY29rY2hOU24zakZo?=
 =?utf-8?B?Q3JNT1l1NmRrNG9oVDFtWHd0USt5Y01WOFFmK3F0S1dndDFPSmVDNGJROEY4?=
 =?utf-8?B?UktLMGY3TER6eDBGd0o3dmwwYnc4U0lSMU42STlXM3VEajdwUGNEZDlnSjhJ?=
 =?utf-8?B?VWdQYis0UnJORERSRE52MGJYVVpHNWlWK2wrL2MzQ21heFlGbXhRWjNKek1G?=
 =?utf-8?B?TG1VSWtRcHVneHliZmZBQjBPTlZnclgvYmpXYSs0QmlXUnlST1dhODQxYUpI?=
 =?utf-8?B?ejc0R0JvN3MyUWxEL2l2K2dieGNmTTh2QlEzRjk2QU5GOEJiYkF6WFJMcVpp?=
 =?utf-8?B?R0E1clpCemFJVHNKWURIamlEdzVVMnFxV01PcDQ2azlGOWtjVUxScnRvbGhB?=
 =?utf-8?B?WVVjZHhxc2hnUmRZNjVaN0RTNTJWVXE4WGR5N0xMSnlDQlRCckZUOHp4Tytz?=
 =?utf-8?B?bnRRcDl4aGNEMlhlYWpncGk4RldMR3VjUHlSbWpPOTVhNjUxb2xqd1Q3NlFL?=
 =?utf-8?B?UlBJYyt0aERWL3kyclJkem9kdlhqRk0yejcrc3hiK2NCS3ZkTk5jWEV1WXNn?=
 =?utf-8?B?SXJEOG9Fa21iK1BxT3NsUm9JNDRmZ1lJSkl4bkJxR245YkFhMXVLYmJvOGl2?=
 =?utf-8?B?dXk1T3U5YVp3VU1sZi9DRGFYc3FVbzdrMUJZTXFVbzFJRUYxZytnODlYUjhy?=
 =?utf-8?B?cnVGWnR3bDYwV0UrWEg2cXhZb0EydGlFSzFqUmc3c25rVHhTNnUyNkdkeW5F?=
 =?utf-8?B?cXpQTzZrajlkY1E1bGVLSWp0eEpWREVGTTV4UVd4OE5qT0VTQkNzRnpZNjNv?=
 =?utf-8?B?QWRYQkdFemcyVkdwM0VKZEMzaVU3b3czZWlDQVE3RnRVUzhZMG4yQlIxRTdM?=
 =?utf-8?B?QzdHSFRuOTVHS1doaERQa1c1bVV1UDNrUzJYUnpIOGRyRGxrZDRDMTZDV2hw?=
 =?utf-8?B?TFF6RmlHTC9yczBPemVsNXN0Q2RINVArNUlYTHJ2U0tmSUdzZ3N1MHJmUUpj?=
 =?utf-8?Q?d799MV+pP2HZVfsgzG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb26b6e-b031-4302-30e5-08df1e9c6b25
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 02:42:07.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPzcFbRknJXG+K0vzcHYWrwlsklx2uZNMDavAZ2xb5nOck9YW7oSxG/c83m7ASbk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7930
X-Rspamd-Server: rspam06
X-Stat-Signature: 9t88q6p51g19xx7qojnzx8dhqfscrrb9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C80CA0002
X-HE-Tag: 1790736135-630979
X-HE-Meta: U2FsdGVkX1/zmF7U3wy6nRuPefIDqokjVBIzQE3yInL1wVlE17kGPNrn4YyHwryGI4fuG0H1nZsLZj1oWeEzLn3Ega46tBqBFZDJ+iVFuMZAYAzn931B4nZH5d9Q0UEy7gA34hh0jXchypOvf51cjKXRtUxWtdafjr7LMvDDCVb2wiujbbIUQh+p+46ST79XC9LdrVZBkeWyHZoJGaZeMCYBaoiss3cmGu5Hy2jdDUznyXYyXOO6tFcpNy1qmjM8PBjvSFnDNDW/hMbb53M3+xz5DVja6K++TyxUGbOddnF4+ekQZaPAUGhTdJA/9+AJ6C1cmmhKmTURuVh1Wl6g5UmP4oIklp3NElmyt7h9tDj97Dq+DhbPQnvCUlwjNdg2fUSI4WSsMQJkc4fwq+20tzitvNml5tT18AXXqjr3dPm5sIQb2LQ4vC38SpsBG+0R9zBP2RiJKYQKmk9tN1mN+cWCllrWKKYMpgHUm/X32xZV0Ruj5+UuTJVjiVvmvoSMuSrhtQwEvg+RI2M0S+CG3MQmbZ25DJIv+Ju8cU4l+Rrcp4gGfd5LmH6Xq0ZXAmxU8cy5dmBNckvdDmh5vmND4+VHNpJolpmp5EkoHht08yyuoCvUlicvAHv/X/aSK5MS6TPQ1ZS6nsiOapRGaImp6FZnSH06J6BHbKo2AMs5YqbrUFqunZ6oYV6hB+kXEpm+TGtD/oLjYXJUZWiRC/SuSsEVF3bIrxs2mElFm7o4yMwUXlyM+ZJs61hHJFF57PEopYu7GXV5K/rPSFJVwcHdX/7t7GRZ4XM3cN6xAib7uLXHOpBD+uDjAeZPDCT+o9S4h9DFflLcX+FBXenc6MPrD1wYz0hZmXMPkQd7eQlQT/Pu6fhbm5KrqbFcQgE0yMgmCIpFp/ZmroA8I5kG9jt5mF2/H5Gsk0llBgdXTVuKau7ndtVewhZMiChjWkQalwNMnwGj5EtiGRzhHi/KT4J
 CqQ+yIQB
 plXjBDgX4uJ1DHauxrKPzxmx4eWl+TpnfPJCx9x58zwsMRJaf+hpdE5IpqHy9GLpyLCiHwsFGvm6Nyx/UdzYDbQkjsCmptV5QHz7thojjnQECFLdsDEPrdVcwGSkcQZyoHd0VffyQscRAMjHJkhO9pahAONb4t1yxDDxJrPTFha4EiSKGXJ+ofTGLSGyGuxEy+iorTdbWVif/JYFz1uQT1TYBrdWLVMvEEX/lcrLPzSf1sFSxleDi7lSpJZ6a1MWLmHy2HsZ8Q6JbRql1EOF4h0KeX6RleVHsUc/bbYfFdtjkniOq1Th9PuD/YZ3tI66mhgy06VeRJojdIDABt3b8wywleeejEaCozhh2KVMBZwcLiAnnvD81HodR8HPiKBENYT9yIqPDM7APi7ql9iIj0bu3Qpoxm4jrZf+OaT/j/WaK9mMbHzqVxGHDvkvEkp/ShYEsMxvriAHEqnCG69X9IuIbKlpJxmLKwC6EELGUIqo8UPlhZRxkv75ptLzmhSqR2pzo+dbxzpfZXJfvFMOjJ3nqManMSN9xEQzyYquwfXOrS3AeO7RL+KkwGk0d7MEmwsfZqPIn7wmbW/CTwnExtKZ0VmWa9CJ1PfzddUVSBMkmbIkn/FN8fElcnX42yGWPkirli3rle19TYMuisp+EPmRC51Mg3hGvcwL3nn4QcjAaFwPDbnjflNyPi4EDJBF1+Iv8YTkFmPcly94YuXYLoQ+y7LV/DhTYD1lMvbmOG/6IhWWn5xaqlwUfr9EUzw9Cf7HFP4VHQs+bVPP10f+xyHIpp3pRYMnEWo/bj0RbdAnaU3JoHtoyt+UWIQRFHhm+K+2h7i3O1I0EfgGKONkZtcK1VyLDSCLg1ucttR3XnfHW8cwk6wg0+BtHtcjbtVWFVMKAon8VCttsEFW1a/2GhJ55F7eLzgdBPhSncqrchdjdmamfXZ8pqezlsKTRtDYu9TZktX0jYm1N1tavSmzPWYNaCnLu
 kJTMoOjm
 yTwGwYIkhV7cGXLX3lx9lZzgRLIxeZFzDNFcrK4JMcClBhoaJcGP8d4Z7gfreWShv5iogI8rzddOAdGTlfJzYZmcH3f/aEQ4P7fKP/gnWicIHQJm76lawSZ5K2n20lhr8tZyGt9vyj5bVbujb7EztxgVKNAU/vK35LD3zAr2WwnaiWZMaLaTnJIKhWLvKx3xdOfE87xESV1D79TOWqWn1buc94CB1YZCxBxxnEe+9MHZ+B/gzt2ZKwzBCDyBwF8wCbkYJcskuQ18IgBrzsv7W5FU8G/d2GeqHdTXjj+vICJI5madhae0bbuI32Q1YHxGXi4fkfcie4cI1wrSqTqbLu1pI/yZzr7V4IBNo8gUdRRH0r7WXmZu8xfkdJUB/3HPqVDdkiV7J7pFQh2o2FnszQfLKxLqnFpFkoIqJcYl9TS+vPe2wlp4RNb/4GieMxtoyXOi3VB+ng/KrGwBpZ1td2WbHP0xyaixenPCkFGcgqekrHdRk2AeA/kQxJEpE2JVcevAJnKmHQEVLju5rHwLGCN9qDs5FKdBAUgHHkHQn1Ylbw5DnhCy3TXjz+/+PirJjH43o/VxylfRWZ5Jh9ZV3Dxjzwwz+eF6hvVmzazF2lvpc4hpSJYUgq8yjlqTGOnykjES5Hpl/ufqam9hN9B0tDKwe8eFJ8JdsyKP2H1YcxMP/dPJR2T8gha/M6xJw8o5mwPa7sOc/E/I49b3s6GTwok+YuENT+Gjsyud0lAdRf5ULARwdZK242zInsS3FogZcd1RvZ7TKbmc2HKEwpkudEugdSruwyFZo1FbIi+o21oYkZwYte3pMF6YHPRUVqGVJm2UdCAYlECy2QUFONgRmaqRsrO1wE52L64JJ2C0MPoYvb7ZoJN1LNbydy/4/9xpmih7eUUsfhGWxc+LPK33ssEyH1qC4hUvvc5v1OF3+fYJoaDxBsi3QAytBcL/iqVadvfSFq6PGNMZg27VHoFUhippoh8Tk
 dfL8IEzS
 dNvtgHLAYcYLG5qPfATfQuWci/eNpQKCNKfrZCcomgdKEEPKQijdddDb+OSaQ4JPgUj0tsgm+hz7iuwqjD++1CzKrzFQZUHTzFjPH2PH5pO98CYS3zjrLKG+2+Ka36t9h6ddSMx+eiX/YW69AvEARAWYORA1F9t0OQERhLQ+fUEXFQrM0BSbmgvEsbQl32fCewHa6apFX0KmCLYQyTy2YWeacPODxLwO9uokxXmLbzscAedu+8yooI41lGHUqLiNJGT4ywRL1cG4P0uKsgnDaLoCLEufGQBHO2kP/D5nnGDVRJo9m9AB13I5h8yJRy31EOsyOgBotSeAZRV5slYf1N8n4FthrK5AQO6IIYOR0hKM69j1YyYJSHCu5u1IwkYKsEbt/NXSyQR5OFzxdzFmCoH07RDL+K25MIjiCT+cjXIjuIvUzXfjo+puSFeVPgmOPFrDMvKjr41QsJ2swPdZH405cfFF+NgcFBw53zY1vEPFQATp9kwzY3uujzTQuHEP/jM6hf7/k+EQpGX5TPo8F24WnyqbejEeoB2DwHoPVLsUoJD+wxt4/YU+H2VZFHCeq8995Wv3LebGfR4TVh/NEx9MSM+BnmxPIUdP+71LOpm9V9HtT+GPp1zUPgqvkrrETMgWeCqYLH1HcCiTF5VUgS4UO0nAb8RMMnsYXVRzxHyZvHBvPOHfKxXBV/IEfG5vnbC5uxJXLZbN180iABf2qSrNqi0oYs7poz6/AOK+Hr7+QzmX3kPexBG0yj5lYfTcWYYliDxD1C7dJiJRN+9cDNGFk2SbXkyR+JO7yeXKW5QNO2oA1gk3eMPjUILkq3VUyJ8BpxHhuzjclpPHw/LVhz5FuZH8DHDqpc1wgGFRjVttZ+lWZIbPBRUfxLvEE7NAWkP9uTOOj7pBHdz+zQc+2f8GSdoJ3GUzNT/fBWuY3ASLiknekTxkg+PTaPypoNajA5d2qDCBaclxvpTg/Vg0yiMrNQrE9
 BABHp3Ax
 7M5x1s3Gmb2UuS3yExBD2qJGnvZg76N92W2iJ3FoAdii48j+Ly2hbU7bf3cGyF9YdQsIXtXOCqowzt2x9LGHrVSr4gPJkielXfSMIVMI/WlEHIEWxt97hCIgc6QVpEkxFfO0rUUajXtTydptB8FTlV6nQwTT+3zkEdtsb9oybz2412s3GsJHYmN63B9bnukTFKOeBIBJxuotJZ+N1Dr6q9c2mRAOOBJ+mexEiFxoaOMIO2fCXY9CAU1X0TD2TqKKnw88Vs7nqQRkWERGCouvXSqrZVzNiiR/5ucpyi53dXJmI59o/LoDz85JNFvxGf/iDHWutyOOLY5QMQxdN6zIrBF+LQxz1R8lhbU70H9wjnigg+mtk1rkhNjfGsvTMID+sJdX1g5gUuMUEwVNQDOprVxrfUgkGqXyCB4dz7KUEPZSbWOuIwbdKkoPHlUxIRGJRv7DdLVP1wM/Gx2vag8ibXKkqBRTk8FVBrcEPUZCDA5uzXCuZVkKF2zvKS7AYj9C9zItmA0ffwAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
> mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
>
> This is precisely a test for a kernel-owned or fixed mapping.
>
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
>
> vma_supports_mlock() and ksm_compatible() also explicitly bail on droppab=
le
> mappings - detecting kernel-owned, fixed or droppable mappings is handled
> by vma_is_persistent(), so in these cases use this predicate.
>
> should_skip_vma() tests for locked, kernel-owned or fixed memory (having
> already excluded hugetlb mappings) so simply test for those there.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h | 4 +---
>  mm/ksm.c      | 4 +---
>  mm/vmscan.c   | 3 ++-
>  3 files changed, 4 insertions(+), 7 deletions(-)
>

<snip>

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 12ed3388ee41..09ff20c3df5b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3477,7 +3477,8 @@ static int should_skip_vma(unsigned long start, uns=
igned long end, struct mm_wal
>  	if (!vma_has_recency(vma))
>  		return true;
> =20
> -	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
> +	if (vma_test(vma, VMA_LOCKED_BIT) || vma_is_kernel_owned(vma) ||

At this point, mmap_lock is held, there is no mlock WIP, so
VMA_LOCKED_BIT is enough.

> +	    vma_is_fixed_mapping(vma))
>  		return true;
> =20
>  	if (vma =3D=3D get_gate_vma(vma->vm_mm))

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


