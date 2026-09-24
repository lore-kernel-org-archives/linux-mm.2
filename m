Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39044C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF4E6B008C; Thu, 24 Sep 2026 15:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A00E6B0092; Thu, 24 Sep 2026 15:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21AFE6B0093; Thu, 24 Sep 2026 15:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E478C6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:30:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FDF9A04D8
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:30:22 +0000 (UTC)
X-FDA: 85249647084.26.A3B6B28
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78B33180007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:30:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QmmUqpFn;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790278219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkIwKyxjGt1B1REIVI/rXEFCNLkFocEHiIdPxtjyLkU=;
	b=h9HneLB+6+Xusjp6swwsyHErpL+XVwFFvTb/WNntvXsp1veOEx7BHr0QNrPIBy58ZRRqeo
	JFYwxNAWbel2y/DSUlPNWvAwY37D2gKz6VML/ky10eWNVUtUeHophcWWTD9vPqFIy+Vt/u
	3hJnlO50fDf7RLxMnzrIo5K5IrgM7k4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790278219;
	b=LZfeSpteOMWm9VZcrdrpmTGI68h3bloF6HdsyURq+/AuH43l17AMZTiuHt7jPNg19fgddK
	UYWAOkZ8uekr/yeuHOEtWIr6gOqLLVH4+xU4DVUvff4IKxhBX/dwd5UAEZU4lCRef0y37T
	/uIdVOOYAQk57ZaPYeJ/Hau6sDjjKd4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QmmUqpFn;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuhnL9d9eALCj59nD+9czyQ56faESfrhLm5v2ouaRJiIqmpBQ3xUPczhluHNBs/ukYVw4Kv9WOGiuSQ2Fdphc1K2MyeoHbIpSjHMPRzb5jVZ6pQkNxvl9Kl2Dw8tWWyNYSOg4NNPWeAfGtdaGN941PhJDosEdhZjk7p0HxnguSA8aOeHohX6gOrGFW6FhAICXd1lHCpc9eZ9DICEmOX2MXBTiPss0PHq15uF7QbqoyftZcG2nU37xWR4d2Usk1CkU++GevcYfaoN5Db612tXJHbmVPA0NjDSSTccm6+jQ+dn6AJ8sVcqzvYXG5Jyj2bryx49esReX9oSIP44iBnlGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkIwKyxjGt1B1REIVI/rXEFCNLkFocEHiIdPxtjyLkU=;
 b=Wai5vKJ0p8scVHTj+NnSrB3WJaWVXRZQf1qR37ck2rU+IMxlQhOGWJUIfZ4ZDx/0Oe3LCvO0A2XFzF1QSgDo1dzF/Imjd97vudfjtK3m6+s0vEx98yf6IzJAmid6FSyJ1s+9Rqo5YcMHi97KHqZX3zdmu4AV5fVIqa66xG+g+txga+h8IkDl2pcL55lJKV5JJP0P63bdLDOt1eW0ClGtsuVcpJ3wLtb7ce6ZHLY5aBhZGOOTv+OaoVJlyoSvzgSLr0ebv4NZ0GjViT9auWUH2lOYZUMoTVwqeKa4Ztsj6CQLet8gZMr2SfNkJf4lz+HTmpuUmQtDg8xhPb+GHsUmlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkIwKyxjGt1B1REIVI/rXEFCNLkFocEHiIdPxtjyLkU=;
 b=QmmUqpFnfunhyqNh+RespZSeSKCrXfX6zUNB/nSnDvdAN+LP94xaV4TxAO4JWGvtoPvzNwH724NuP8lbNxSENFIXHk/UvubpAVtO33iRiE1/s+98Fael8hkVhaIoJzCjMv3DVx7qV6y2agAODNAGXSxUKbUVO82h9iUd65BAJ89oS8TORf/yhSQeQ3mPrf2nQd3zh3aCPYWt6ofxPjtKX7/OHyZe5FgcvClbaHTUee33MFlEXVbUCDHx5c1XAEamBBzSxttmI4kpQUM24ZCbuZyNx/HGCUaEZlvu02JZDd/zr1VO660W985IPJggiPdkdqNVCDxq9XtQ7NFkqAEGWw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ5PPF4D350AC80.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::993) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 19:30:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 19:30:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 15:30:07 -0400
Message-Id: <DLNSNQP7L4FM.1JZQ0GS9300H9@nvidia.com>
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
Subject: Re: [PATCH v3 06/40] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-6-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BN9PR03CA0381.namprd03.prod.outlook.com
 (2603:10b6:408:f7::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ5PPF4D350AC80:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b272aff-50df-431c-c325-08df1a724075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|22082099003|18002099003|921020|56012099006|11063799006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	qcFoJ8TrzrzuzEDh3+Lmgn5ctD9luf+ysfpXMPiQCon/Csfk66pTbFVlTP2wNbLJdFkANjgOLef+YYo3A6h7zpfwhVRxObMobP+BQeYrCeyOFMQD8WXgF7xSKAcUZIrKyj+dpkqddYUeM9ogmgnkepxPiNAdcNMd+Fgl88oDb8KA/19vwi/0IyvVfanixeK9epVGeOg6een6JzFQk2rCTd1zR+XJMqyQ3swwNCJLINxzaPOR/nLHfqZbhxdju9AwqEgzqTa+J1pP8IoGwRG0IwiTwIOCGt04PG68tgTRqJNg2QTH9JHwSqo0aMBDWe1TQ/6tbbqSEuBhwO8QmoJfXPIH8PgITEkxnZBxR9JpaMoWXULbD7VbzdDrn5sET2thmaM1anTAabq+2nA8ILNCfhI3bmlpm/W20qt8pKsUTfr7EsNRTc2q798JNOBjQlRuJQBzc0SnkLdfyhe/lOC5ZglTGD7dgoF1FEKmjkQzNnOhfCbfiRfYxeBsBlddQfuzNioj9Xok+AL9QrU+25iQWfZyP8SI3oXW9sw4pjYizb+Q9HYh8Q8L6kf8u6OA+Dgng4xydCGjUVIvaCMW/ctQTPr/WgDbBQJcd7IKW/LO9G/tTZyw359VP46O1o9kHvV9bColA5Gw2dEjNtUVP0WDRefylPUD0oAx9ju+b+bVb3bpbCJ2RrF8WFcOiEnLIyuHTfjVc64dVD3h/O8jb6f65g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHhxZzF1M1M0aDdnYmpBS2pUSkZVWU5XSEVIL2J5dkNYa0x3Qmt5a1JsOEZy?=
 =?utf-8?B?U3p2aWhFNGt6T3hGZFhTK3ZVUkw4NHk4T3hneWpXTytrVDBhYW5wNFNWdndP?=
 =?utf-8?B?Um1QVEJOdjEraUZmSS95MVllK0UxanZLZ0E1V0hpTkordythYzUzL2V6L0xI?=
 =?utf-8?B?QUtpUVRUQm0yOEtNNy9CTVJaTktnZitIRHN0dTl5ZjV0dmNKSTRCbC9hTzBx?=
 =?utf-8?B?d01xYTJoV3RtZzhVSnRDNFMxN0hySHY5S2FDRnpmSFpFWCtzS2MrSEkvTm5G?=
 =?utf-8?B?NWhRRmlSanNoMm04MTU4cTBsMEVpY1g5S05uU1Fta2RuY0tMOTBPZWRyeUlo?=
 =?utf-8?B?SjJMQ0JpWjBHUkwwUFk4RXhhYXR2VllqTFc5d3pGSWZUaWlacG1FSjQxY2xJ?=
 =?utf-8?B?RkJYUkZ3VzFMT0EySmszVHhFa1pnQS82VzhNTzVTak4rVkg5b0tNQkRvZE1r?=
 =?utf-8?B?YmF3dVlTeHdPaVA0eExtRENHdFBHQU5IN1BZcTNJZUEwM3lCMVdxam1wUXVH?=
 =?utf-8?B?ZFlVeE1TQ1ZSR0kydjgrbmdYZUNFcWtxazBwbUdRcGJ1V052aUErMTcvTzdy?=
 =?utf-8?B?WGNsTkhXTWM1cTJyQXcvMzMvV1NaMXpQcWlseG8xN2szVDVxcm9CTGtJZUhN?=
 =?utf-8?B?MmovcFN6Q001allmMDhiWHZBeE0wN0VZbm1BYWFucTJVbExWVDFCbnBYWGZa?=
 =?utf-8?B?VjJML2V1NUNjWVp4aStCUnYrb3MzcksxalVhemJMK3M4MTJEdmp2czlzVVVv?=
 =?utf-8?B?eDVwVTFyVVdlTEdXOXNPYXNIcTBGbmJtZEErSmNHdFFpUjkwZGxFWmVoQ014?=
 =?utf-8?B?Tlc4ZXFQZjZnUk9KUDVqam96bkNneXREK29MRlNDajkySE1lekN4V0RwT0pN?=
 =?utf-8?B?cVN0SlJDa2NKc0ZlMnE5a2VXZFNRcW9nS2tocUlvN2lKM0dGclpsVEk5SHRx?=
 =?utf-8?B?UFVoK29aR2J3MGtjeU5Kd25RSGdKaklQRlAvbjNuWnI3RkViQUNybzdXTHEv?=
 =?utf-8?B?YnVvRE9td3NGbzJnanRzbk1ScTMwVmxLSmZEUGF3QksrTmJRL2swamdVNVhu?=
 =?utf-8?B?eEE5NWY1QituQ3RyZEg4RzFzOXB4cjlNRXU0K2xuVmtjS29BSERpOExCSzZS?=
 =?utf-8?B?eWxTZGwxYy9wNDRmN0ZwcUxoZVIzaGllV1ozZzlTS2poWlZNellGUG90WDFj?=
 =?utf-8?B?THoycU1Wczg2R0Rub1BEcS9sQkI5MXg3MGUyem1TeWlaUWh4MTBzUW1ZMWE3?=
 =?utf-8?B?SFZJc01kZGZkY21teDZrcisxR0x4NzE2eEh1aDlCQmhwdFQwN0dxb2xFWlQ3?=
 =?utf-8?B?dGFqd3B0TEVVelQrcnFYTmpNODkxWmpqdHZxVDFFVEpyU3lDZDk1VjcvSlFk?=
 =?utf-8?B?TjJaWDNlUzdzVnREVFJlSE5oNHFxV0ludUU1ZHJLeEd2TnlJR1R5RWZxUktG?=
 =?utf-8?B?TXlJUkhaT05zNmJob0R2M2ZobUo3QzRaVGljeWhiNmVvMmlWYnhlYUdqS0pN?=
 =?utf-8?B?UWh0bmxmR2s1T2hGaUhqdVhKOFpmTFJHYXEzYXc2dTUxdFFxaXVVQytwaEEv?=
 =?utf-8?B?cS9ud2ZrTEFHckhwSXAxZDJ3WFFFOS9MUGxjd1RJVWViSFU0VkFHSExIRXZG?=
 =?utf-8?B?T1BHbXRYbGcrYnM2UUZUY2ZIcW9JU25jNEc1ZGxwMmc0ZzAvelN5UWw5VWxB?=
 =?utf-8?B?dERxWnF2ZUF0MHYzdjhOa0twNXBrcllEZHRWQ2kxV0o2QThJdnlLaDlxbjBz?=
 =?utf-8?B?QndyMWxyRnRia2hCbzBPTkl0SjY3M2h2bnVCRUZaLzZQTEdrUFJUZ0hnbjRl?=
 =?utf-8?B?blY0SitMZnN6Q3JxMitOcmJ4eFF6QmlkNlRJNUxGOTlWbW5GSWRoVTR4UXdF?=
 =?utf-8?B?ckdDd21jRmVJUG1xL0MxSGkyRE5vVldFdkFKUkFMczhVZURnR004OGZ0ZlJn?=
 =?utf-8?B?SVZQdzhwTlhwYlNCTHYwaXFsN1BmenJLc2ErdUpHcytoWnRhVzZkQlBrT3px?=
 =?utf-8?B?N0kxOHFYWnVmTWx3aHZUR1BvRkExSy9HckJxMUVEblV1WVNkTWFHQ1Y2S2Vr?=
 =?utf-8?B?VytNSnc4dXMvcE1GZkd5cm1nYzN6WkdpUW9Db2l1VFRIR2RnLzJqc0JpQVNW?=
 =?utf-8?B?Vm13ajBQamk5dGFmaTFybHpuWSs4eDhvTEJac1dvODFuSXBURXh2cEZUeWZK?=
 =?utf-8?B?bE9uS2lYTHcyaTd4U3FSNE94R01WNy8xZXlEaVJYZ2x0MmZRcHpQOStPREds?=
 =?utf-8?B?dURtSmJvUHk1ZDV0bjNwZjBPNHJMd1ZsRlBRV2dvbXYyejlKa3lEUHM4czFo?=
 =?utf-8?Q?1VykPtvsPKA3+tK+5g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b272aff-50df-431c-c325-08df1a724075
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 19:30:12.1248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CRUQ2KrvOYig6kIu5tJe+o4lUkO5VaAyULfaj4Rd4LC/Y7np4A5Ae+Vj+fX3Qamm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF4D350AC80
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78B33180007
X-Stat-Signature: 98e4qx1r4jayit9gh874mesi51h7y16i
X-Rspam-User: 
X-HE-Tag: 1790278219-480430
X-HE-Meta: U2FsdGVkX1+IzkcvTK+z+beXhAPk76OSLKcEkUURRgSjhZSLbgZDitF1JDj2/o8ybS55x2YlVETPizjNSPSvTH9p7rgl8R9BlRz3T9xFbfqEK6svjAjmer9VFhjqP+/L7AoixJiRxBJSsaKh189zJpHBDOaq43SJ7WtTNAftvJsECf0iOnXlbCt1TTXq25uxzgsYcROnLEt5+WGNgiEASNJTXInFtpLUdFfInh6RfCD3rtKqmaV4woNNlemvsXI3cFMHitVmHRDAi9pI/UM7xAw349GS94+7E136NZc34+kJEKzwPO1myy2OiCeu/U9QuEPORLc0xOHB2V2DwYYKhitEx3DB+3tEq+cZ6IfSaNFXwoIgAN7n1MTTwTvpoopyQ7O0oAN/xAm6d5tPIaujS3sR0/BMijuUKJzsFhgmBc80NVjxCpjXZm7ELZ0sU7WFeI9+dERsFQaN0nfir2e4qHmV1VXpXhCpghXlB3AuR/O98lB4S7R7PxxeiJ+2BYLqcviXxfl+DQ3EbQtG+LBjdmYBvM2cibDiVzMhWKTtX0BfVO1uYhEWH2YRT9TCwcJEivLHbmLS+LWehkDGSOiPmiJOhcU6NwBcyvTR9CBZwb+lbEhaacXzT7sgmL7IB5qrHNtVO5x/iFEjMd6ir8Gu0WLlCnIaOnhCM93w7nIBsdxHvkETht0J1+Mm5FSq9Upkf20C0NOFJZVfyFin5TLKczoIwcB265YAZHkdnCABCRGYMzm1xsUd3oJZZyNphJ8on5kcdj3zeHU6lrfIKCEoSgZxnx68XI8opXPn4zSgltuvrMjeVuEPM429ljpJW9cFQSOiGVVsJZoENm08fvrDvj5SF0l6vrh/j/t5uIIT5k83AORKgHA+tYaGZKI83q0gE/dRp/DAE1THCAhdxLFi7c94Xhh6r9tl4qNBUmNUaVtAdGYnPxAOqY5AlVX32Vhs3vMdksqllN0DYM3uUW5
 k0+xxJW1
 XEtgZhaOAA1rcq58ZwrPTAXI2ES70qRRN+iHq1FYApHpv3hoF2JME4jzd2U+8DEy0opkGuYJcBO7jVoydDMx227k8NDdxqdVhuW+DSwpSlpaaAxAjcfRQ0i4DNUAcbcBB+yMx4K0D0/E/5vmoUJnWd5Gc2uNwyrGUq7PGR7Hv3ZfOBY9hMa6klV+y1ddV/g82F1cQFY4QZ4dDx24zGignNfJmW8VX6r9KeVLd36j5L8hjyHsTpjhjR9KXxNXyh+B9CW2o/sP5WpnAdt+CxJx+XatQzA+ls3ccSnXrfsnukvkgYnrQxmnQgLSpQ/SB0KGqPdLkf+y2moON7f2b0dCf7/6F21gDg1qR0sfEGgMd9ruHNDVbj6eS3Wl5e7gI7rq0OFl2WBY+28CLfCnPVdWZgOXUSqngSnz11sDoSQuzjcN8xgx5q1AVVClFDIrAKiHxzmr+FnLw/ZRiTVHDN2Y/TRZvgusdxOGyQzNvDhSzpkcNkfVpSDUVnrMlUdHenP3LsLa0/YKSLX5E8uves/YFXe8YodVleTP0Wcvm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> There's no reason to export the symbols for these functions which are onl=
y
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h | 3 ---
>  mm/internal.h      | 3 +++
>  mm/memory.c        | 2 --
>  3 files changed, 3 insertions(+), 5 deletions(-)
>

Makse sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


