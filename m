Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C7FC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266726B0088; Thu, 24 Sep 2026 15:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216F46B008A; Thu, 24 Sep 2026 15:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8E66B0092; Thu, 24 Sep 2026 15:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD46F6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:28:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C9231C2B2D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:28:53 +0000 (UTC)
X-FDA: 85249643346.26.33AC864
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C36B14000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:28:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h+WaXW9a;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790278130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BanIIEJzpCiYkyUQdKsWNp/eZgx6p5TAqP8UPbXSTJI=;
	b=kOfIQ/qI9dzvGlIOwPNRg2YpeY8kaNA+2nh3v0jzhyshq1yUAkniEAYFXPS7SqCN+CyYfs
	xLWqoOn/7UpGLamHbHzOykh0SsZQ6qsnn7NsTchmJeoxgvZVPd8/9SdzQ4A90xsjHkwlux
	6qljcH/nGpAYiAZaGQfzgVbXZWEYBjE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790278130;
	b=4Pq/LjhUAx45GSIWyKNqpKMiGGE+ZD1iZ5QFTDqiDT/EWXmvu5J9Q8cauWOXcctUnri1wy
	iZ1xUXJrGYD7avfCKGrvQIr9DJ26GwKUa+4AtW2CHk/NsMAb9QcVonJf7vsKrw/8Z9WHYr
	mDOl+GEH7q75adHx90KiAWX/vKZNMGc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h+WaXW9a;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjqlYp28LVRA1tlUe3pHgpcNtzuPmx8HtsSywXuC1NR+ZPFwniUWW/Qm6rQ/0M1T1eyUdRFAEd4TyZEpMXDUX7oVci/J5WN6Cw6jdc4Km+3FjnffxDISj1anGv3tyCEFbWi3iQ94ERo2TKcB00sXxNtAAppYz7pQl2AvHD6W0v1/3VY4YgaFKWzPXc/sUX6GdocahoDGUm4NVoIj2jDau0bhEWnGdHSXeqrsDD2efPXHZMYirzrezZz5WwoBs0FR4uwgkqaW0X7/o4ZxqvD0bdTihipeMxYRvC6blZuLRzqyL5LmaZ50M78kgpyUxYWBVhCaE+jOzUgVi+2LyYoAFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BanIIEJzpCiYkyUQdKsWNp/eZgx6p5TAqP8UPbXSTJI=;
 b=rCFzHE3rtPzAT2pO1Yzb9+YdowGNLOBxmdKJPzpJJD6IKidCRMPbK6PZ5z+9cR6oX80fc+pwQqpVp+/eq+ZB42PvjsF8PINhz7Du6dO0YUlCqhqlcnEkvTCS5xTpWWanNb0KwI52t2gy1ku88ZlP+2M2Jrl56poHrdtNj0QSfpYYi0L9rGr7lwvmJxHIlLMSJtZauH5fd9UtKE3Zfbyic7qOxEQy4hdX+D8pxQW+MvxMMuIZAXVzPKMz0V3olxlw5tQLOaDe8x7j5j8uvyAf3uXAEEOGfuasWqy20pO8VyzVZlkInH3nII0+fPo4my/16ebvh+svHH1agIxvTcPt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BanIIEJzpCiYkyUQdKsWNp/eZgx6p5TAqP8UPbXSTJI=;
 b=h+WaXW9a+e0rH30DQ/pbEOlAmWReoVVlftVQhSSoR6JAI1e31yewFWsS7UzhNHrs2EmzGy9pOm2lhENGwGL6RqDTm9f17Dmynq4tP/FUIBl9bVFO5Q+XoSJpo7K/7/gz91QJUyA+BsUl5C7rCN55SM91p92IindNt/y2Q4+wt1pTuNYE/tsg2Rn+oCpYKMt7EU64qYRMl2JbBYI5Z/V2mSWsn7YE/pItFbhaoStic+h56FdNtzyDKeKG+AQO7zIWw2AX01TLa6MGmGsWcjNJRdKUGLCTmIENy4/ZXwgyKRJwxws3F+BFlSczhH30reLmIDQEg+aEtEuZm4i8g1+xwQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF4D350AC80.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::993) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 19:28:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 19:28:16 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 15:28:10 -0400
Message-Id: <DLNSM8R8JS9A.1850RMXAG9NSR@nvidia.com>
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
Subject: Re: [PATCH v3 05/40] mm/vma: ensure mmap_prepare doesn't set
 actions on a mergeable vma
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-5-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0171.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF4D350AC80:EE_
X-MS-Office365-Filtering-Correlation-Id: 81cafa58-af46-454b-9d3b-08df1a71fb9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|921020|56012099006|5023799004|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Ax/xivLGah5Be3D2je1u4kNuIHeKMWbPC8BT9QSSH+82ViHzGTE6r/CWbSFnTw48A101tMVCkTNv/MuXOijbtgoiIzzL1HtzYb/MR4RoYfbXgZ/cB4yb1+rrIDzSnHw/b4WJ1HBHrl/h/ZOaA3Ya4iD5C39QAI9/foOXNKtx12hE9xh97iC2WisOmfoDxHYZetWYVPpM17b9r9RdikF5duFcJuI0Pktc8PQVjeEWLcUTE4MvZU31TEX8yB+V4NLARZ1WgT7FtYoI4z/jcu4FnA9ZCTNrHDGrtlqpDKDa2B7wtYtyIC0xezTlb+st76fncctMnR1NIGRhoTwbha1UzcwvzyfbuXeKyB/tTyrPA+q8O66+1qofEtxIhP4gtCaMr6+Bs+Jp7H1w5vZ78O0OX/zKt5/Ca+HnC1qpQsG+13PRmHe5VuulxrdRKY/9CzlmUwso94qTs2MwxDLK3lc9LZdDbDNFEqQ3A9KHk+UGFHfUuK7qxyOTaqGg3lCG3oaG17gTGLEqHOUvOVpahMvPnFMAY4e2AJc2euiwFraL9hbmisCcu/7LbbZsCjcqODvjrDRzGHXV8PE2abhyv9nwWX8ZeeP5EcEQWtREreZf2/CT4T4+hai04IzuKrL09qfgdLDiERLGkF115Qle7LEfJKzJN+jvdPALyhuFWvkxDqA7nrT65scA85BQ6HmjsjrGyNw4/QqgwBTQIvCu/Q2ZPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(921020)(56012099006)(5023799004)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFJRa3hZU2JUMFpLQTd3N3EwaUFualBZakRQazRkMDNNN0ptazg1eENRZWtJ?=
 =?utf-8?B?T2M0dTAzUDM4a1pPbEVqaHJxU0ZYOTBjYk1mS0p4VXU1QytOMjNwcGwrMmd1?=
 =?utf-8?B?ZFR4R1lYSytvZFU2U2pKOE1sT2k0eHNONWhqTElQTDFyQXNRaGgyeGwyOXo0?=
 =?utf-8?B?cUhwWmdHdWVvOVUvUHc2TzUyZGJIejVmTHJPMm8wR2dXRDJpV0Y0SWlxSzB5?=
 =?utf-8?B?Vy9vVU1uU2hWOTk0MDdjSzBScW94RVVldnREY3lNcEN5RnViU2FQdUpVYTFH?=
 =?utf-8?B?L2xaVnhnaWt3SE5wMFFIQlRnb0lMOEp5cVVqYXJoSkNIcmNmTVhMSWM0TG8y?=
 =?utf-8?B?QkpGdFh6MWg2dG5hOVA0MSsxQzBSVGZXbHI4RTdCZDA2am9kKy9wVG53WUpu?=
 =?utf-8?B?dkU0Qk1WcUlzcUoraURKOHg1RHJnczl2SXhwK2Q3enRBTkY1b3Q5V3lac1VP?=
 =?utf-8?B?OFJmZktVbmc0NUt3ZEppSFY1cmM2Um9YajAyM2c0dzdSTzVybjN2Z0tadkRG?=
 =?utf-8?B?ZXppQndsSkRDbWpzMzhweFNQN2xXc1F4ZjBNUXJNZ1lCUjM1Z3BSdTE0TzVm?=
 =?utf-8?B?NGZQQTNjTWpxdkx1b0JxYlhYbHdjOHBrMGhCQndBNUlIbGNVY2plWTRCMWpW?=
 =?utf-8?B?VzI4R2RPdlNTQVpmWjR1U0R5NlZnVThpUTYrUitvSlBnRTBKREZjcHkvSGNr?=
 =?utf-8?B?UDhKV3BNWVFnWUp0SjJkZjhZaDhKSzRlUS84V3hSWHVDcHNnd3NsTXgwSUdu?=
 =?utf-8?B?N2FlNmVsbnZoQVN2cmplNmViQ3dJRWxGOGNaRnpYekYreUNzdnpVQmdrTWhV?=
 =?utf-8?B?bTdycHlZaDVjcGZ5eEpFaUJhNlUwVk8zVmRLclpQbXR4c1VBeWpXOFVBS2xy?=
 =?utf-8?B?cDZOcnJTT3VET3cxck9JdmRjNjUrUTdXU2gyN28rZDBnVnBpN3dhQ0R2MXlJ?=
 =?utf-8?B?UUhRcWhvVlFDamJhcE1JbW5CY3ZSVURDamgzSFJCL3NtU1QxSHBSa2Y1Q2Vn?=
 =?utf-8?B?b2FEWHF0bFFIdEMzSUdHMjZuMGREeTFncHpicXNicDV3aVJGQzA4aU9RVHho?=
 =?utf-8?B?dFVwVGFETnlmaWIvNFVuQUhHUU1UV3RYYjNiQ0NYSWFzUDFnbWZqdVlWR2Ro?=
 =?utf-8?B?bDZGakRqd0k1R0I5bDl0UDBxS3A3VHVHSkhrYzkvQkNMRVZyMGIwOUlIaUph?=
 =?utf-8?B?OExMVlV2bU1OM1ZaS2d2dGxDaVVQbzNRVysvK29nYXF6ZDZrczUwZzJObDFv?=
 =?utf-8?B?czZnMVE3QnN6NjZtdGx6T2hCZVg5UFhIOG5pWU50NWFTbHpTenhFdzJmKzhP?=
 =?utf-8?B?QjNYM082Rk9zRmxtd29IblBYODFVU3p1VytabzV3OWxrL04vUWV0RUlteTZl?=
 =?utf-8?B?d3VVcXNCN3NldHhyRzJjSGF1UktycTJaY1FUNDRXVkdiUzZGYmUwOXV5a0hF?=
 =?utf-8?B?REwzdHR1Y3lTbjdpK2pKdDVuc1RETnpKWmx2Tkc5a2tsbklUNFpiR3IzcmxT?=
 =?utf-8?B?emVKdXFMaWJpcTNLbU4wbmYrMVJiU21ab3JVZkdFL0FRb3doOFB3SjVESTdI?=
 =?utf-8?B?a2JuM3NEYnNDcWVvMUxiUDc0NFpzVmtrbnRYZ0s4UnN5eGRIczhrQmxqL2ll?=
 =?utf-8?B?enNWMGVSQzN6Y2R0bTlUR0lSaWpDYUxWWXZFNG9HRXhnejlVTGJPaElRYWs5?=
 =?utf-8?B?eUhnV1JpY2FNbVdXT2VzSVcyZ2Jpc3hJTDZwRmVlUURqSWFZK3ZHdFBlTzl3?=
 =?utf-8?B?aFFNK2xxenNOQlJ1VzJsTDlpZUkrNWJjNGlPZWdwWDlWVUNzUXYrbDllZjUr?=
 =?utf-8?B?K2hCSlpHMTk1bU9IT0R4MVV6OEZYL3dmL2ZhbUFxUmR2RFVEa2IrNVVmcFgx?=
 =?utf-8?B?WGQ1WjFmY2l1SzUwdHdCNGFOS1ZjUXNVVDgxZGZtWG42WHJhTXR0a3JtYmFr?=
 =?utf-8?B?eFFPd2RXdnZhei9TNkRQMi8wR2FLS1U4SGZVeTFpdmYrK2ZYVWEyYkZlWlBw?=
 =?utf-8?B?eUFUUEZmdXRWa241Vm0vTkhnMG9WMEg1bENyc1Nha1N5bDJRQWRzOGx1a3RG?=
 =?utf-8?B?bjNEZ0hUOEFzdC9LZTdrWkpUcEF3b3lqdGRhUzZnZXZuZVVHaERKc09OSXQ1?=
 =?utf-8?B?SjdJRzM5dG1RRlh5N0RDSGs5QkYwczF5UWs0VXhPQzNUVXhrQWQvaEMvT3lq?=
 =?utf-8?B?T0trck9hVkxlWndDN2FSQU1pZGFYOXBVMGVJdzBWSFo1cEhwOEJvaVNNVFVk?=
 =?utf-8?B?N0xjK2JKUS9tN1ZtaVJhMnR3ckFYUE43MmVZVjVTUnpXMUZLMy9veFNVWk1J?=
 =?utf-8?Q?mnhPx5KyssRyBx3roV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81cafa58-af46-454b-9d3b-08df1a71fb9d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 19:28:16.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZiW9MVdMq6VFSl8GT1lYphVqy9SethyWUgkCOI3oIPh50dtSXfkTKjmN2rT8UU8a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D350AC80
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5C36B14000B
X-Stat-Signature: 9z9uf6c56h7n6ssqdeogun3fu4gp5f5n
X-Rspam-User: 
X-HE-Tag: 1790278130-459057
X-HE-Meta: U2FsdGVkX1+nh7/7N8SXoiizcKR4DmHG6FmJ1c2PRgPmwAJ4cuxJHzAyzX/pJJb8YAbJYFcwSnkmzxKozibvp2LbM/oXKpe0zZyvcuCYBhg/vmNPqvuKkVcr5STbh51/04icoIjAmCin0MK2bsaqHGG7CF6wcl//GJuJDJadfKhTa/6ScEAW2r1er6lCG4spvEIXpJ6YBjz3K6l8pdl/hnswAQ5FqpbetEx0/cnurCY+J27xrdz1MUetKRO8xeGTdor2WqiLPEi5/+rGAv5ZKGctW4R4hlpxIUZ7dy/fA6FR9KDj2DOs316QqZreWqOw7AqTClYtEUKlJFs75Vt9g0Py5/vLtGZiz7Um2gri/YGTnegxyB8MU5lx2QnjW2TxOBIMQZOKn33DtWTeEd69mQpgDaEzkicSt1xq+m7tMAtq431mdkuxUAN3m3kREY5PFXGy7JXDcnehZui0Uq2t4w1vOa8My8GADDUxRFtXs74yAqhfdA6s+rlaVHacZ17Y39flHtXm4iZCNq8Bn9QJerVg+9fwfhNQMAozci7BvPngYj/v9jUc1sNo+Y+rhi9ppSmYsXeUKVhh+O1PvS1lQ0Xr9iUTKyvI9KummgcwCb4l7jm6JgjtC2cHdUi5suTRdDtAdgyHoejdvuUj4Cz3EI3cFwN9Xhm4cSFltpMTIIWdG3bCiM+iTvrsEjUz6c0dinSqcynGpJ1Hm6PMOXHzxgm7aeX7Jf9zUnaMXUO1JNcQUMBpnj0FLKJQIH0n1tMvVPWaWog8lA4m0OAheBkl1qjx3p10i/vAlfbJjQQozbN1TI8aGUZGU8lJztNcIeiPeEit3nCtvSa1wi/lhOHVKtVSYIw6HccPZzq1OGtznzJ4FhgjZBLfIOq8wxFNQ0XEX9J+OEawwgkOYVeTNu1QIlNG7buJ7Bu4Jg0YDXPZerKcXUd8gBYjL/RfZ0P9fVRyGgetxymdgRpoVnCltLb
 Q2dFdNDU
 jBAfI9/bEl2ChA8U6v0uLaR1/ZWrmxJTfDoIQfo5ud5e5B5J+4xcOSJKgpB6/ipYpatyZ4q8zceDuuP+NZb4M48tV13M1K19MqPdhc+asMJZWyalj4gnbzmudbL+EhN1PNeFDY4ZBaUEAKluTOrC63yxL6LxKV0DRmhPKN3hfCa3bBNlfRLeVTm20Ey6ibQ77jsPPfuWRCyCfPcooppirm4xWwLuHt5l8Ocpdb4EHDh968DvRg0hb4NSaj9a4/CkZBfFFPOwviqoWu8VcLcMhKkJvow2OJS8eP1vGNwnVN7Lr0ioGA/GFi+CHCT4tsxwak66e32iHAhASR4eSoN16l1EopHYH754VXMm2irlBV+BWDM2gByffWS7fqUsZoUnMmNsKsS8haFyDVUxdHCgQhFlxntb4d8W9Tq9gfpIzo1TgylMtQmsgKIIv9J/p47gvpmTZz4TCAj1V90bzsgDMNF27FcI/gkZryL0U37ARgU0uVWT2giRYclCjXrJKfCcRCoPwrZ2gw6V7QDqsV+IVaqrbKHKEcQro+PQN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> When a user requests an mmap_action be performed in mmap_prepare, this
> involves populating the VMA range with data.
>
> However, if the VMA is mergeable, it might then mistakenly be merged with
> another VMA without having populated the range.
>
> Every mmap action currently available sets VMA flags such that the VMA
> cannot be merged.
>
> However, to ensure that no future mmap action falls foul of this, assert
> that this is the case upon mmap_prepare validation.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index d6ed10cefc8f..62f2ce1ad5a1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2809,6 +2809,15 @@ static int mmap_validate(unsigned long prev_start,=
 unsigned long prev_end,
>  int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
>  			  const struct vm_area_desc *desc)
>  {
> +	/*
> +	 * It is not valid to execute mmap actions for VMAs which can be merged=
,

Is it better to say "for VMAs ... after mmap_action_prepare()"? When I
first read this, I wonder why the check is done after
mmap_action_prepare(), which does some work based on action.type. Then,
I realize mmap_action_prepare() changes desc->vma_flags and affect its
mergeablitiy.

> +	 * as any such merge would leave portions of the mapping incorrectly
> +	 * unmapped.
> +	 */
> +	if (vma_flags_can_merge(&desc->vma_flags) &&
> +	    WARN_ON_ONCE(desc->action.type !=3D MMAP_NOTHING))
> +		return -EINVAL;
> +
>  	return mmap_validate(prev_desc->start, prev_desc->end,
>  			     desc->start, desc->end,
>  			     &prev_desc->vma_flags, &desc->vma_flags);


Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


