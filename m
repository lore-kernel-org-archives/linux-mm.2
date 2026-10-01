Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C4FDCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB9B6B008C; Thu,  1 Oct 2026 11:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C1D6B0092; Thu,  1 Oct 2026 11:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD9B6B0093; Thu,  1 Oct 2026 11:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D78006B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:20:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1B60120483
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:20:30 +0000 (UTC)
X-FDA: 85274419020.06.6E81057
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8EA2C000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:20:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fl3LHCQB;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YYTZjhEwZJ0TssF+378TwKS+eN8c2aSblt03yjYGts=;
	b=SD/soAjPiJO8jwbF/8a6Ttb0pGSl+TVRTuIJI3wgcFJ5r49IgIpJg7XSfuhONaVwSIT3hR
	MZiS0jqrO4J1SQILu4F87zUXDR3mbMZVlPvhAnBca23eSoyu9074ffTZdcSFPXpja2PUAz
	4Q6cCv6JbRVemrD5vuWz1NyMYenTYwc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Fl3LHCQB;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790868027;
	b=auFgYCadUKMd3VjP9G95tq46CuhfHSmHK+q6i/HqMQBXmVlOVHfqa44TDkorRznyiM0gAm
	JSw/ZlDxJ89QvbRw2p16N1esZaq0KtItLL7y3tbBRc5Yv3/Z91Mjsl3/STylkQ+gNEVSJm
	kQN/d6daWcZsP1hdeoNjugpgGv+IWTA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mft82P24ROJQJ7BRJZ/lx47/m2yH8qJcgQD+Yg31FeHE3tSga1ahqlpS5ZGVJphqHX27LlNTQV6mQzbZuS+8zNUb/m5aGqGbmYhkpN7ppCiln5e/cDmm2Xc6N9qTdk5Ke9aZ1EydrfqY4u4rJaGwXxfo7Bgbb3DpH7hihkMCWC2U7s3X3Clunhb3PeEZjaGMhF9bJC8HgKhH3G0p2L6arwKfGoGfdWM49ycWM9tl0ku+UM3haGJ+vAVKt6JnpHAzdsHlc16u0DcVHUP0bcy+qMHWebBslNlcVAiEYOEKnkvFWghD8pKAWp3dnFctmSo+tE+ANcBC+mMMu4jf4E/qYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YYTZjhEwZJ0TssF+378TwKS+eN8c2aSblt03yjYGts=;
 b=N6gH5bPztY3IR2R1irbhNu8Y072VuOKTk8zViJ00l+ebyjRq5wLzdWPjl9mXGwv9clVmv9MQFFm3MmBb8ONskDM9OQnjhKyFeVdcuCoGERCtrhmIMM4QAMhX3pS6eDWGcHWw4phF45IUjCFaVos4jL0jgihq+Q+mKadbyUMavnv8hx8hOoW2/rb0bQY78nAs4EWhGKgrBrm1MfOQER9BL4zmnEb96MmEMSArOHID2D7tSlab4SGtQ413KeeOoqgysI9loBIgJeAqrsOEJCBqmbruJLM8ZxxfR2vdyUZmW066kKLYCuCOVSJY6qXFcsgRG0xxyVQD5XWGWdid7djwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YYTZjhEwZJ0TssF+378TwKS+eN8c2aSblt03yjYGts=;
 b=Fl3LHCQBWqKJbFnXWWWxejTowVjxnRbMRIwV1h1qPj1y83DQU6+iy9gATfEhSBNX18H/62tA46KkomoiXmmnp26MvoeQPcF6dxQyUn4ohLzj3gNlUmWLdHayYFIAhjTVIL9SCqx6iMPqefsIHms+t7QMzzLmQmbraQTUSJmrKvhFn4pTkLn1puMeEGP2Bvki+V3LtuYLeXYgYW0bNHYKa/qQqEKo435R7sO4UhfOWWDP+YwsX0uMLQb/lB+GANvD/cG2ufmt664tW0lHfuTEP3cZs71ZKU0SXPmCOUrGueTt4MSZ3A0WzixNbRZELmngA487Mi1/WR8oRFcYKc8kNQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA4PR12MB9835.namprd12.prod.outlook.com (2603:10b6:208:54f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Thu, 1 Oct
 2026 15:20:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 15:20:21 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Oct 2026 11:20:17 -0400
Message-Id: <DLTLQ9NOBV36.1D1MY7SZABEQP@nvidia.com>
Subject: Re: [PATCH v3 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
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
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-23-4583d8a23bca@kernel.org>
X-ClientProxiedBy: MN0PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:208:530::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA4PR12MB9835:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f6be638-2fff-4211-ba76-08df1fcf81f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|921020|4143699003|5023799004|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jaggmSVI0Yi/kMtwqe189sppnG6OCckWiwx5CBpo5r1EAvxQyk5XDECHBQE15zN2nk4wPAjnog/l7Mwd77PoH9lIeya28ZvECDZMzI3JPc/Ufd7nUX9LVCCWCUb+BP5So3/CpugHUICE9BCavKHLTrchAnP26Khn4xJWE3y5II499hOR6tRPTvwSEAnUPQPba52K+A/kWGzNimUv2s9ftW5IO/bPIz9q+wgEaXzytmgGCpMG8XjTNP2+h6PleU5qJrXzqsSCiwfvFePGh2GYtVR3seKBgVRRkQupZPCmcaElNPaQf7vhdD1VMNDRUFl3y5zQ63LKy91UIei731uv1fwdpj7FSbX7FS7Kiru/R9rkrzDmF1jRcSw0KvkSOF3Oq+ub7RLmRtgbyL5BsdUmGu2b6c2IMtUZeI2cY5KM/u+wx82GEXIMpdHLExmHriJqknnhN+S0KShDfx+2kCHM+wZKFwcgqrkCcecpLcnzTNJ+nEzEjuIfMH8GM+W8y85aVpU/QAEqRI//vTANA0Lq8IQBVjbsDQ/R7WuvG09uIE5scgKecKkEKpg0Xm9elOyCa6cJmQkynaIbPXhO8xZOWiAcGAS3NG4Gn8BT5UoDHctx/dmGpSysLcuPEucDAuDB+whFc0xvhtscRuKdAcdNNBFY/vrKlqqqk3/Y96rtzi9vNHhdg5kukM2qIQnTgw4Oo28qQsQ6L31HSwqah7EqgQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(921020)(4143699003)(5023799004)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlNwd3ZsSXFyRXNrZS9xTzBGVVhtUVZpMHVzaFhJUG04em9TVjc4Rm4wMlpn?=
 =?utf-8?B?eTNjUFVKS1JTaGlRYXorV1JtWDdkM3JFOFc5c1BuUUx1V09ZUHc0YWVTaGsv?=
 =?utf-8?B?eUVYTFg3dmhaNzBjclR3Ny9tVFZYd3JwZmpBQWU2RGN5M0FXSzRnZXlQdWxz?=
 =?utf-8?B?Y1p6MHhTWVRCbjRzdkdVNEZ0ZVpVeTJiRjA2T1dVU1hVYkl6NnBMRFpyZGl3?=
 =?utf-8?B?RFpPQXNoYURjMEFHRGhBM0lpQy9ualBrcGVIVU5KOTJOVWxDVmh1S2RmVXF0?=
 =?utf-8?B?eitYNmF5VDRtL3k5UVhrL2pBS1FLcEY3SFhaQTNqMzJGUmRjNVM4bFo5R0hG?=
 =?utf-8?B?YzRnU2c2bzZGSEs0WDRVUERRQXZkd0NTQWQyN1NEYXVUUXVOTXdQalJkWjRP?=
 =?utf-8?B?RS9RK0Rka05sTWxkNnhHWHh6Z2FsZEt3Mk9rYXl5bmNNOXhLL0tHQ2crSkRk?=
 =?utf-8?B?ZndGM0lFcFhmZG9ZTlFXYlBXeUFCN2ttL0pKWkltUUlwRHBRWnEwUlVXMFE0?=
 =?utf-8?B?V0lmMmxIbE9OcGdUSDFJZG9KNVFYd01zaURDTVhTS2dUUkJDQkRlVkhqMS93?=
 =?utf-8?B?QStLbUZBWHVldjlXSDVkU2puZEhQbzAwRWJSLytNSGw3WG5idXEwY2djcTd1?=
 =?utf-8?B?clVjZjZ3cy9PKzZ4TkZwdHVWWTFUN1p5VVRrMm0raUM3dUpFMS9rN3ByM3o4?=
 =?utf-8?B?WmtRQXc0MlB3UmlGTDF6MHQxVmZteTE1MHlaaHhlMU0rdy9XVnRrQmdnNTh2?=
 =?utf-8?B?TXU5REJ6STVIbmNrMVc5RUdyS0dqaEg4V0dIdzZ5MSsyQ05jSFREUHhqNnFu?=
 =?utf-8?B?UDNobXY0OFZFUUNPYzBzaFh0Wnl1RTBBZ3JpZnQ5WU1SeC94MEpiWmUrbWo4?=
 =?utf-8?B?eS9GeXRjeDl4WXZWSTh3Z3JrclBGU0pwSExWVHhNMnB2Nkl2WnArMS9pbnV6?=
 =?utf-8?B?UG5WTTYxWDNKR25sdFRGMXpQSXZ6K21sRjZzT1pMQmxMZzd2TDliMloxQSsv?=
 =?utf-8?B?Q0UrTnpMOTV6bWlTdEh3YUIxK0tJWFh3b1RkeDBTVFcwY2hiWHd1cTM4WTFU?=
 =?utf-8?B?WkJYK0hpbnYxTnh5RitLRFFyVmVaVnVJbUw4V25TaW9JZ3QwWjdGbjhQc3pF?=
 =?utf-8?B?ZVUrcTF6SlBoNHIvWlk3a0dUM2NqK1RhTkIzY1BmbkFLalpENGVQTktYdDMw?=
 =?utf-8?B?cDdNbEVJRXk5NW5TS0d1NzU3TEdtOWJTQ1RrWXlreUhEbStLZmhtaEtWOHhC?=
 =?utf-8?B?cUZ0UlIzRS9IcGNtcUZiNmxzNVZrT3lGcVJBUlkxZU1jSVljcmM0M0gwTG9E?=
 =?utf-8?B?S2JHU25tZVlFc3c1VzVJZXBzOUtxdnF6TUMwRjFGQ1BMK3htWlNLMzA1RG1U?=
 =?utf-8?B?S2hKMjJUZXBZM1RUbmdVakZLeE1jNThjakw0ZFRNeXUxY1VsbjVsOUNrUGIw?=
 =?utf-8?B?VlVCK1UxN211YzZBeFo4OGFuTWRzUUJDakx2WDNSNHo2djFscTNsUTlUOE5y?=
 =?utf-8?B?UjFEaXJlSGdjNzJTMGgwM0lpajNEN25ZQjhxZTFXQ3hkRWlyKzdkb05SUjFZ?=
 =?utf-8?B?MzR3aldOSTB1R3YxaWxnRXU0NGU5cSt2dzVnNG14anBPRDV6UHdFTjcwTWhM?=
 =?utf-8?B?Wnp2S2IzcUZrVWdrYU1mNDdQSmxiajBpb2E4cDBRcmdERElwVTZzTlpoaFBC?=
 =?utf-8?B?aDVDbm4yTXhHbGlRZWZBVVdMMjJsTGxxd1p2RHF6YTlmNWJsQ01CdU15NFY5?=
 =?utf-8?B?RUtNOFY5M096d2VzU1cyQlN2YUpzeldMb2JiOGZVUnFLZmF5ME9mMjd5YUpn?=
 =?utf-8?B?cnhsNElGR1MrTlNSK0xMbVRtU1RBbkpndmM1S0h0K2h6OTB3cEZoSUtUMmMw?=
 =?utf-8?B?ajVNUlVFUlNES3Rqays1ZnI1ZGVHcm00cGtCQWNxMGlyRm0wbitGa0oxa0Z0?=
 =?utf-8?B?bms1eUxGUXdQTy94VjdSYmJOM1Uxa29MR2g0VkE1aktha3l0Q2hyOE5tb0lF?=
 =?utf-8?B?YjhnMXdPVTVPa3dFSlF6NFNneDBCM1dIbmFiSDh2N1NxVXBzejRWTE00WjdF?=
 =?utf-8?B?aEtNdUV0Vk5jTVdzOE9Gdmw0dEcxU1Rac3MyOWFuQzJRNVBKU0JxSElZelR1?=
 =?utf-8?B?SUE4VEM5L2p6YTVOeFlrd24wWFUreHFJWnlseTh1YWxWSkVMYWVDOFlYb1E2?=
 =?utf-8?B?STQrOW1ZbzUvZmRZSmgwd0xqNHZ3Qm1MUFdyZStGNDZBYzBNMkRsU3dscGJK?=
 =?utf-8?B?YTNyWlRRL1pqS01HcFFQY20xd1NJQ092RVcxVFhpbEs0RXFXRFVERHpJQmdv?=
 =?utf-8?Q?IqSsC3edk8y+16vvja?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6be638-2fff-4211-ba76-08df1fcf81f1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 15:20:21.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKyEl+LchyHI+qS0cD8Tp8KYqsx2vovGmnMCqIhnqBCaRhEMrkFwMWxOOMrt6ov2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9835
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8EA2C000B
X-Rspam-User: 
X-Stat-Signature: f6sx69qebw6z5xbir7szdjywjrf648ji
X-HE-Tag: 1790868027-38003
X-HE-Meta: U2FsdGVkX19RGuma4G9CI6uz4RSgZdJwgRuOTjM4zKvPKOkq8RomvepvxJE2vjsnZ3rgmWon74Zvk3yH7q8Voamhtpg5IMW4ZmMtgKnir3xTSqNg6ALwGJt6GIq7fYkUnVyOveoMbqwY/+WF1MtZoGEsBEOF2BkhrApzW1JvFT3LyZhZ7BDjtX0ero8SBttYYhwvMd+9HPnGd7TZaMErwcgH1ZEbAxlGQOz+dkcFoi36NuFsFLjh71WEW/RAKShFSfj/Fh0Mh6lwy07GR53HROQ9ZA3XHpRUyDPk71rl03FjdWAPu5eAHCv6OV6x5HWe6CQpQtGRHztKJko8l/S3drwkCAHNL9CXaiWqMAX9ddS2SyardRkZcii8rffbPSNKCMjMS3ImjQue9ou0VyV+xqBoeIr1l0j+o6bHe495llBOiTiskRImoEjvZCQw7RK/KNo4MVftcPy3Gut/KLBmlUfDd2B2KxKQDBsqSSvwbPiKH07gSZf5P/E0cqj+LA3pET6mXRjxNwG0gYucbBRU8/5N9SIlX3fik0FbyO8hJV7f9rpwf0dhji3MyNDytHgOR7Qv8TTc34bftpzcbOfLbihmRu9mBHSduU3SxSfFkEqlH35vvI8aYzj5VHNpew44BSDHVCkdMGpBpO4JtXSCb5mpk6tGturHEkbAQEywcXj/9DM4TMt3TcVFLFZAyoRii9gwY/JpsYiUZ6tQ5NFQ/vTly3bB1bjF/02LQimrupptvpsC2wDfeNC/tyiP5268MuXBTvXE+X9DPILsEaRiuXA9uPoeBcPTmsmRNq2odvLRr970ZVSbKvShHEb4GJHxHHrGtstFkUlX2oanGMNoCAQEIY+/Sbs0jnMTe8N4cJmWujQXy6pv4f+hQdoNd0DetgNSFSKGdWTMbnEUYhMXLqIKG6sbV5bGcl0GfPGNmozm++RRgsmMDDuX02H4LohoxF+Wv+47ro9k7mYqu1V
 fgo7fQ2q
 GYQdl9FLOsOzzKOghlV3LG+dkWOF3ozulflcy+XX9O+Pnh0G+Z+d/DC9AOuy4JMYXZUL6uOJuIF8lbL7RHq+XSu52UaewoTY8q7ywaBbaknuH1oeuXKqa+8h8Aiul6nsJa+RLmWzHd33AUIpxr0+juUDC7XV65VLNX5jNV9RBQqBZjsMkTXsGVN/M0W1/MZjF3hVI1VTlwE7ILQkNsD7u7bLm8ryrnBu0XNUCQwVqHbvX+yA0Nl5arINQardHL/B/EXQxUCkSb04gOxYVAVsvQ0S2HcMRmlTMmw8vvXaRRRa6rCil3DpUnvIz9LrtQqRLeKGNnn71OPAMED2BlWxzdEaXhPWaXQdEK5xl8cMZpbKM7B0+GtcYXPBikzyz208NgQ+LL2xCY4HAHE4Aj6VbwQglQFxJYPSOLziC+TT30dhlUJHQu80V1Uegb6BnX5DuXX+Jf0/2zW+BHJGl6bZms62E2dhn3TSxArnIBXqNZjKrIyIX2QHJjVGtRZNonxzFvqXp3uevWBcus9yZ8QrLj5vmZWr2887h1rTO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
>
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
>
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
>
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
>
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
>
> Nothing relies upon this being set during the mmap operation.
>
> mmap_prepare is unaffected by this so requires no fix.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/internal.h |  9 +--------
>  mm/vma.c      | 14 ++++++++++++++
>  2 files changed, 15 insertions(+), 8 deletions(-)
>
<snip>

> +	/* If VMA flags still valid for locked mask, reinstate. */
> +	if (vma_supports_mlock(vma)) {
> +		const vma_flags_t mask =3D
> +			vma_flags_and_mask(&map->vma_flags,
> +					   VMA_LOCKED_MASK);
> +
> +		vma_set_flags_mask(vma, mask);

It took me a while to figure out vma_set_flags_mask() is an OR
operation.

> +	}
> +
>  	map->vma_flags =3D vma->flags;
> =20
>  	return 0;

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


