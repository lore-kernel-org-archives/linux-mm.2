Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66B8C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A365B6B0088; Fri, 25 Sep 2026 16:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E286B008A; Fri, 25 Sep 2026 16:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0FA6B008C; Fri, 25 Sep 2026 16:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 611F26B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:53:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED6811C32D1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:53:40 +0000 (UTC)
X-FDA: 85253485800.18.D119D16
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF5AAC0009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:53:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZzSTIDzG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790369618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z3QNlMDR1FRmUdzeqnmY23pm/BwEsog5iqZhTFcYeIs=;
	b=IIN7WsODFev+mLAyJp7MCf+mlWZ3G9W3Y20hZt2CY+s4OIKsNOc4H/xog7XxALd0JerYK2
	u+1lGdcQefYyGXEts+3nXU6M4jXIFTAAEEuwHkwpe1BSyNeKI67J18T16qebsL2sgeiGTX
	Mw6O1MIYRYbPea3uBnfIebwlgajDna4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZzSTIDzG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790369618;
	b=7gJcOnxHUEJ4TypoKrmYv9tu8UtFkgW2YAA1ju/RfAi9BViQcev44MFOOQvKvB6rmyVJ/n
	W167jrPM3tKHuFokTLo+EwiVKxgif7vXXxpQtQNH37OGlVI99MJEAhJCsoSg2fkSBAwTFv
	STsnuh1potSXh/PJo9Dc0Yl/63XVevA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XHmcPKZytydq3byzp23XGiu36ByaLbesktRaEDo5Oi4WTVZZ4qMw+8zmlwqc6TRhaH/DdG0UkvNabsIqOrq82rsE6egXCU1ZJxvKI+zUo3JII5PEkSfJR1Q2PeGys3b+11EtuzdBC6JHAPpV55bxp+ucI8z6YggIgPSyqJRzya2a+u/nNP3ezcEAFLnu0jlEj1GuyazlvbC9dO832TUOVE/8Kaikz5e4XF4NlpU4jmp9ZlTXJv1M3hiVriWNh9TLd92OiH3mQ1fHziCcvPJZGYLI1fgPx0ctg+8Y1b9U3+0nzegm9eGiLZkDSBGpyNX7CxpilJ6oURUsIwyX6/y3bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3QNlMDR1FRmUdzeqnmY23pm/BwEsog5iqZhTFcYeIs=;
 b=Onsnh0p7kOyakXBWehMWyunKvTnnukNKxvCAhMxSA4IZSV4UuVMq+kf2nzuZR5vShygpc2D83KGOqTu3MVxzpOdhdV3+2+JmK43Gm1dPD8A2leqnibq6OIso2/KMW3R4gzF1uOhhnZDvu3Q3WxeONJM0JFHKU6JIfqhO48Ts1tk7QF0XuzoxclomWf1W9cp0kOkee/lbVl9kwPupE5l7+nv+Yr0SKwtGaxxcKXAUWUJ9zuAS7tZTvA/32LergM8eOMEZCyuXxxyLq3gnNDMyTCkZLxKhgJdjk+84D/h9Nzjyk2AR+WFaGHDlR7PitdaIaIsCMZ6nZOZHp1cYlAXFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3QNlMDR1FRmUdzeqnmY23pm/BwEsog5iqZhTFcYeIs=;
 b=ZzSTIDzGMseX7tSAbWKQNhPfogfcKpg9vZ7q2Mg6NFoINIMLFORoo4ZXBUXxbOZ510rMGT5zVY+3M8potwGJ0dusEZOeEMcDcsyhcl6xXWIQZeif9Y2Pwin1t9aEu+50A4bAZ0Cfj2ggMKORyinDDYkzLmhiTlExCUpwCvD9VmkU0Mh6dyHGuaTB8UVxzkjqbN+IACxQFxzzhecr/m/enXtrESKShshy600arNdMZCPRfKN25DYSPRkGp2esOqtJQ8gIzLNpeyQ8GyPYsQo6suq+NIG3YG4MdW6KFQrNF7dsDbTgrcR9Adb1d0HruJvmcys2CcLQ2p7AVS1xl6o4bg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYYPR12MB8961.namprd12.prod.outlook.com (2603:10b6:930:bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 20:53:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 20:53:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Sep 2026 16:53:17 -0400
Message-Id: <DLOP1YI8FF57.1ORJL8RYO0BEW@nvidia.com>
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
Subject: Re: [PATCH v3 08/40] mm: add mmap action for discontiguous kernel
 page mapping
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-8-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQBPR01CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYYPR12MB8961:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f18d36-6b3d-4acb-0440-08df1b470a3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|921020|4143699003|6133799003|3023799007|10067099003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u13te0P/y9jcFaxYTJ7sgabnT+38hJFJAp1JbxG++Sz+h7jOgMsbP4mx73vnnJXUz4PhdQ2VYzwt1tK4zHSL/IUBqyDxkvD1R6fyVqubSIYIfseuUGjv0pb8B823U834/GeRjyNfc5ZRY8zeuWzbsmaBSNMFBDF29cwr0hmD4oT0UlNiy//bit0bvdLR8qS2pmTUQ96c5LwJ+7rkZSAITWacvmEhx4Q/YAucmbQ1tsCtZxfaF5zx1moIALH3foI4LMnJzqlNSNynHfa9sbq3JyorUj7cmWyWZqapJSCt0umvofshQaWegsjcV3RB4413GHPpanJmuldzaFNE519afFUFXJqV2KY0wWhCFHyq7R8JyEUuFnRAkddswAf+mvkHGyysz+HPuP5VGVV19C+hGMDT+Y+qhGXXqq3g7GJW/Bzp0m42jqtgdtDt6tJC+0wLYjtJdsWaK+0b2sdgGnrtgkgTtZ18ohPDQ8K9iD6p8+KmnlOJ4BQ/iiZiK+umFjX5nussUYeTwNm58ZtMWkf1RUnTg0flwqDZosOG5oS+zjysfLMYoriQodERGByJmP8tclSbqPcbj+NFz8bOzSHaYR3KF7aFKEIyGqbbdXPUyB4aMC72NmGMykMIi5AaDYHMS7+mkdKf/NmaxH09YW1KdXY0KY+5viiWtGQoxHDbqmiYQM5a9fFhmC7KLrTNza9MQTw4o6O/7Hk8B0c7sOAzDw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(921020)(4143699003)(6133799003)(3023799007)(10067099003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDBMYWRJeG5DZzZ3TEIwWGNoWUdtM29PSjNwVjhWcVZRSVluU0FGWGlCUG91?=
 =?utf-8?B?L2VzQU9EVGRaZWV5NEo2TmZXakJMZTh0K3A5MW82bWVEbGExMGgyVTdVbWRw?=
 =?utf-8?B?cXJMQmNkWFVRWTlkeXMyQ0RuUFp0T1ViWEtFNEpDQ1hiTDJ3VHdheFRraVh5?=
 =?utf-8?B?RWhLM2JFd3ArSG9kdEowZERGY2JmNGlBNG9vZFlkZE1lQUVOOCtNR3dOUlUw?=
 =?utf-8?B?UkNSTGlTSlRHWlROcytjNGNVWlJGQXR4NFJnUkNjYzBadEFEUmhvQkY0NXJM?=
 =?utf-8?B?TlVJUlMwTmlhNGpkUTJ2b04wVFpXaE8xRllZZG43bitoNTBxRGxHS2tSU29C?=
 =?utf-8?B?Vy9NY2FGdjJNWVJNUHpvakN0WW8vWVc3Wi84MUw3NW0wRkYra1JnMW51UDdU?=
 =?utf-8?B?SCtZTmhKTEgrR1ROV2RRSzNhcW5DWFFCUWVLSE4zNTdNOTRNUEcvMzA4VXVZ?=
 =?utf-8?B?bzM2UElXbndHNCtja2RDaEpUMFRzUHdzQVUvNVVvZkZJcXVCMGNLQUJwUkUx?=
 =?utf-8?B?YWlmRWFuSlByNFk5amRWWlpSZmh6VTdUZE1zVlhPRWdkZGp0N1lpaFIxbSt6?=
 =?utf-8?B?aHc3MS85RHBhT0lOaXBpY2Q5bkZHTjRYYmw1a2FMWEdxMG82WURONHJuLzFa?=
 =?utf-8?B?TVBPV243ai9maWFaQm5OeUZXMmcyUVdHNmZLL2p0RlBSSFFqWjJzV0ZIb3pw?=
 =?utf-8?B?c0hia2V4Z2NhVGlvSmNBYis4S1Y3UEVLWkhYY1pVRFVtQUNBenU5cDJuYXds?=
 =?utf-8?B?Q1FZYTFwcWdBR0lVZzAzc0ZnRGh5Q3FISmxlcGIyeElhM25PbHRPV3pKNldw?=
 =?utf-8?B?ODRBbXJxNmVUY0hJWXNDY2hHRjE1UlJ1Qmg1WlhiaE1tenQ3TzQrYnNRbUMx?=
 =?utf-8?B?aGlVelFXcGd4aDFsbi9TVkl5cHRHQ0x5Nk9BelgrVnhaTDM2ZVlnZEdQYmlr?=
 =?utf-8?B?eWw1aHpWN0cvZzJJTk1TdUNCN1BuMHBQYlRNRWtUSi9Va3NWMHdra1JuYUox?=
 =?utf-8?B?WmNRTGlkNG00T2xXZEhnSytjVEp5Ui9NRGdNd3ZtenlWMm8rbWI3aUJMblpH?=
 =?utf-8?B?MXdxd0p1dlIxVzZKWEtQbE1BT28vQTY1T05RN1JUNkk5QzVxMUUyTUVDT3BO?=
 =?utf-8?B?NnNqazR1MUZhVnpmVjdmc3RuNDJUZzE3ODBsZTk3ZHFGaytCQUxLU3FZOE4y?=
 =?utf-8?B?dEM3TzRYSVplN0pTdmxQeXJBUUlZbmdKVTREaU9WL2VRazZvMm8zTnZhRXZQ?=
 =?utf-8?B?N3RQeXY1OEpsZElMWEtEQUZLdFBGcTRYQWZGYnpaTlIzdTdwV3BLMmExdS9t?=
 =?utf-8?B?Z2RqR0VFSzNLOXAzVENndi9DVW92WjUxNmJlVXBOYWo0TVI4OWkySmdHSzNY?=
 =?utf-8?B?ZjZuTkx5VjUyQXc1ZkV1QkoyWldpTXgrSE92Zi9WVTNtMllHV08rSUZpWkth?=
 =?utf-8?B?VlZWS2xPMFdGZ01WWmdqaVpwM3RmMU0wRlgwQzFEeFBiZk1nSFFaOE14THZW?=
 =?utf-8?B?aDUrdHYwMU8yMmdjNG0wK1lDV0hoNnlFL2krR0Q5bjByUVRUUGJKbVBBTWpR?=
 =?utf-8?B?NFVtcWNRRHJXcE9WSjJlMUpCc2RTeWhnOHlGTVlCTlpUaTFLRnlHK3FZbXEx?=
 =?utf-8?B?Y2hWOEtRVWlWcnZac0I5Y1cySG44SXpnbGpTSWt4VU1VeU1FWUZ4RXMxVThC?=
 =?utf-8?B?UzBLMXZZRTBra3JIU2p3dUFBZG5VY0VZM1pNQWI2aXpock1mTTBUaTlBdVVi?=
 =?utf-8?B?am5nL1hUMFRaeU5HeDE0WmZId2JQT1ZrVjVBbnRtOTI5dG5RRVF0WHFXM25z?=
 =?utf-8?B?Q2FjWlZSWnBqT0l5bEd6QklrVFBDQzBuVUFTNnFHaDdQQnRncEY1clY4TGgx?=
 =?utf-8?B?Ly9PT0hjQ2hlR1JaZkdwQ1l5WTVwb2ZyQ0RubnBleGNzQ1lFZnRYMmtzQi9i?=
 =?utf-8?B?MTFJNlVyVHU0OU9hdmpjaFJTVFEzL3BhNTJqT0ZlbFMyK0J3cWtRbG1ZaWVR?=
 =?utf-8?B?TEVhZVlMaDQzSHNPS25CSENLSTZXemZuNGUwYk45aFBQY01YOHpVdDVWZDZz?=
 =?utf-8?B?V29nQXd1SXdMSVJ2MjZoaE1HVGNzTHVYOGdKNWVTWFpLNDJFS1dYVzZ0bWQ3?=
 =?utf-8?B?NEwwOXg5NGxaZ1JZejI5YzJ1VUFCV3U2aXdIKzNwQUhBYng5ZXhCWVpVMU5q?=
 =?utf-8?B?eG9IR2VzTG1ua0hrYnJwcFhUYTVKTGRsSWpZeEtEakgwOUJlWmxqRjVnSElO?=
 =?utf-8?B?VHc5QWZzVHd3NGo4VS9iNXhJQUYvbysxVzZNTWhEa0VPODZsdllDQWJHY2wx?=
 =?utf-8?Q?ORWxYTeYZHBeQetT25?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f18d36-6b3d-4acb-0440-08df1b470a3b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 20:53:24.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83In5Sx8WkbrAEXowdB/7E54vAx46OgpCMQXk9QJvIVc2rIQKJOnVCceLoXXnzbm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8961
X-Rspam-User: 
X-Stat-Signature: k84fimpoqqrgqjoi8mzf6a5fnygudkoz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF5AAC0009
X-HE-Tag: 1790369617-928747
X-HE-Meta: U2FsdGVkX19/mmSs1f05cNmLM+5nRrTIzXUoFg3rlX9a3XRVIfxFfKUzlxFNJTvYo7NRm7NYkU7Zk8nEmBXfLLiu8proOblbRWd/TmKmINwrfCCPG9aZ2A/k+4DkASo7nL2xE5J3+6cqUrCiHfqRnuGYjJkmefYpgbdECT5FpHuBdL9+2z2qXUSPTY2jmnE8mBmDxSMdNkjUYkRanyk9G0xEQcqcbSGDmd7dNXOq512rbZ46OBis6C8fY89XnwC3A8y4wik2jWs6k51q9V1CXPrx2w3Od8mn+aaW1ffdHcoa9PZrpKiRMJm+vRipKH9KWP0oOYd139qF3E2u+IDDqUjl0qlTnmHmKmd//hfjD8fOgjILZw//5ColonfKf64amcyW5awsFUPy5/X9MPx2r0PPOPehW52lqPDSw5MlACSmz135waSakALEdWk4KGLKzd3elny/5hdredeRKr2OCMendg4JBMa4ui8zJS3m2pGCf9IwNl0YsIKBA+1KVjcsUF5u9owcBFPiurMJY8EvzmAyc3EP4fCHUev5S7IHDhGHgqmdzJNzk1XCiQBtqOlhTp1d9yjS6FfQQUeHJ7zbvPuoHQq2+/rPLl1EOYehUnheL7zxadiFsaLhmBG5U8C5Gztw5nHw0KWkheGlTmYofSZ+WoeH8nCSpJeMtXfJ+t4+O3fcHPV46uZnjiUw5IUku9z1ATjwluFf9Ihzgpy3kn/jmRcg3OpZEaa7jMlhyyooyXuIxHwHpEKekTgtYZ9tna/Y/i/mXQby4VMxOiAfiXgmUWv9Tt1OX+l37yWmsDYvSEnQO7tFsxFZsTv/QViufwPd1D8f6GDf4BLtuDAhRO4EXOt7hLf5sFkR41lCElKmHfyNPdR60OUNtsMydeNld/TIMf+uRRFjVEwUQqTD1tA1HjSxhZgNfc1xqWHd/55YnD+YSaqagKduReKxvfhqb87/5fG3K0OTqM2B2uS
 VyxIb/V7
 Y1QFIAWdcGp3DYYRxUWUQWuWLJ0yssF9jMd81k3DY0THDSEZANWE+ap/y3pALa4WVvq1MqZ7w8iN5HnjGiIk9+uP3h8PaLr1M/1GE/TkJprKFV+DRYP4ndpGDEehZpSRbHn2HutQHbiRvyRs6PMQSEK4dTox3SmFPaPHYI+4agIWIuyyEkSK8LvY+NlwIvzaGgLsmT3Ku6ZX6awMJA3qJURV1cCObO+Cnz80VYCwx6Vva9fWbfuJtUofOz4uJDhAx8lpOE8ML2+Fa8c3W89ni/fb7mG7OftT3LXtv9u6SNS2IzBfZ9t+QZwo+YjvLyfsQzQxCYpEv7/PXjSs9JQqQGIFUe5WXTP0SG6e5wGtxT115C70l+BTUuIJt6pL/P6K/myYCgxP1vjKmHy/lZzxqLV5ZuOUO4fvJG39qggrpVOy6/z41QA4gx7W4GiG+pM+6HuqLXOnqK+cIaE7yEidVKdczskNZQFGOU9rku9OJ8AxF32yG34Gt0Wi5Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
>
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
>
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
>
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state establish=
ed
> by ops->init is released.
>
> Batches may not exceed the VMA, but may map less than its full range in
> case the driver wishes to allow the user to map an area larger than the
> available data.
>
> To use it, users invoke mmap_action_map_discontig_kernel_pages() with
> initial local private state and a set of operations.
>
> Users can then use one of the provided helper functions to perform an
> action:
>
> * discontig_kernel_map_abort() - Abort and leave the mapping as it has
>   been accumulated so far.
> * discontig_kernel_map_page() - Map a single page, or a compound page giv=
en
>   its head page.
> * discontig_kernel_map_page_range() - Maps a struct page ** array of a
>   specified count.
>
> The userland VMA tests are updated accordingly.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h              |  45 +++++++++++++++++
>  include/linux/mm_types.h        |  44 +++++++++++++++-
>  mm/internal.h                   |   3 ++
>  mm/memory.c                     | 108 ++++++++++++++++++++++++++++++++++=
++++--
>  mm/util.c                       |   7 +++
>  tools/testing/vma/include/dup.h |  11 +++-
>  6 files changed, 209 insertions(+), 9 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


