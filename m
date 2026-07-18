Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34E9C44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 02:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCCCD6B00A2; Fri, 17 Jul 2026 22:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D516B00A4; Fri, 17 Jul 2026 22:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45486B00A5; Fri, 17 Jul 2026 22:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3386B00A2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:35:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA32116031D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:35:19 +0000 (UTC)
X-FDA: 85000330758.18.A6309A1
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15B08100009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:35:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VmEzgSzH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784342117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AeFu5sBQmQSXqUnd/3Cv7y5GXkIJYQ+BkRPMq4hzY70=;
	b=q4+v77euHW93o6Inl4++5DBvPdNQlzimCWyfgsJfiZTfUxfXC1f2IYg3R47+LzXKZD7lJ8
	4Gqe6zIAc1fUt6XohTWDvxeAATQOb7w+Xd4Yyo6ejTavTIYz6VrLdbmQL60FXT2Fdy9jef
	qQ0i0QPp0VhUdw/BVdx5daGLOcAHXOE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VmEzgSzH;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784342117;
	b=gyP8YnFTRbenSRAyGvEjzi6uRs+uPOqg9yeOSAlKXdR+Z+UEYyuEi0bu9TpjOrvPEzB6+F
	TNUiBLGW0zetV2K0GZas/zBrvyh8VhJRrHyuTjS7xdqttXw/TwDLkZD0WjAPxhzvWP0eNi
	xxuklxfASPCNKcOBrWXhkMVh/xl1a6Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9yp3pExYJdGz+YrWjDjwFSJNAYge8h5HvTfIOWZsvpT/iGjf4X9SxKHDqR4NcsZ3vR+NinYMW8sxeWGpEQ8v9aona6YYlvQCzIUKipfNVl3nXVnKJYZhKO5ywAQixkmTtR2ovbHeNhOLC2rKFPIDJePF5hk2WtrAvhAOFaCI1BKlBscX7lcwH8GVgOzYszsGAEfEDa+B+KHUJcP8VB/O4+yqiJ4P/G0nOguPq1UUx1mE+xk89TI586WQ4GAZp+CpQjubNAZzcwCpZLBrGxTQEAw6t6HigFhYtJgVwfkt8fmkXoD4XK/pOF2eFyNyaSaPNhwDAYdZK1qLwJLN4o57w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeFu5sBQmQSXqUnd/3Cv7y5GXkIJYQ+BkRPMq4hzY70=;
 b=UW5/MXLh+/3Y/G8lEquIkNkGnI37qy+ee8SXcDHi0bOJFXZ5oIgnbct6ZFbaFNIERwno66aDuFGrAiikddFK6GeBuou/4jcnhrCqpXRdBptVONPUJ7OBnaB0o3eGG6aTmsPL78evLJBCGofG5oJ032TrVwaKupBcOS2ErmBMbxvsxro80LhTiVR7RdIx2aX+qjTmzl6JSBv4TxNqqKbRvtVEU/0U9QIjcesSLNhF+Mp9oW2J0BT9I6GBLtJNO7rBEIN0KzenRg8PktMp8NseebEbgszBPjQjmkIGWhvEP1SIfwfyDvT+MSajj1Ui0aiTz+FywCqipGDp6LIddXWbqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeFu5sBQmQSXqUnd/3Cv7y5GXkIJYQ+BkRPMq4hzY70=;
 b=VmEzgSzHGsbB4FBM+m6hJA2FqeN97uQo1BZi0AzcaUvRAHblhI8tRxVj1xj3zZGXBRWLS512YMcfaUSWaW37gcP9YqYbP5euarO0CvFJWEG30E6aPGbWBF15rcCjQG+A5cxzHhkjiO91qsAPsKMg+W8Y+KXE6N03Zvb0O4r4TzSaTakBQz4kEuJ2Yyd/KF2fHCj1/AikVqQS1qqcr+qGQPk1SgFWkrm4Tx8xhIsktK4r8Efe8TRJPDoUa4+cvCWLY8IUi6oNRvl/xA0rq8H7oEUU0mVnDLAFUUszj5Sgw+NxgRploHg5dqfT81c/L50yyu7vGlrL7QB8ox2B9rojBA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Sat, 18 Jul
 2026 02:35:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.012; Sat, 18 Jul 2026
 02:35:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Jul 2026 22:35:08 -0400
Message-Id: <DK1CHKBTKQ3N.PL946LKTX7G3@nvidia.com>
Subject: Re: [PATCH v2 04/33] mm: introduce and use vma_end_pgoff()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <damon@lists.linux.dev>, <iommu@lists.linux.dev>,
 <kasan-dev@googlegroups.com>, <linux-sgx@vger.kernel.org>,
 <etnaviv@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>, "Russell King"
 <linux+etnaviv@armlinux.org.uk>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Rik van Riel"
 <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Pedro Falcato"
 <pfalcato@suse.de>, "Russell King" <linux@armlinux.org.uk>, "Dinh Nguyen"
 <dinguyen@kernel.org>, "Simon Schuster"
 <schuster.simon@siemens-energy.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Helge Deller" <deller@gmx.de>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Dan Williams"
 <djbw@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Oleg Nesterov" <oleg@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim"
 <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <npache@redhat.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>,
 "Barry Song" <baohua@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>,
 "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>, "SJ
 Park" <sj@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Peter Xu" <peterx@redhat.com>, "Kees
 Cook" <kees@kernel.org>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Alexander Potapenko" <glider@google.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Jarkko Sakkinen"
 <jarkko@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>,
 <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ian Abbott"
 <abbotti@mev.co.uk>, "H Hartley Sweeten" <hsweeten@visionengravers.com>,
 "Lucas Stach" <l.stach@pengutronix.de>, "Christian Gmeiner"
 <christian.gmeiner@gmail.com>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Patrik Jakobsson"
 <patrik.r.jakobsson@gmail.com>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "Rob Clark"
 <robin.clark@oss.qualcomm.com>, "Dmitry Baryshkov" <lumag@kernel.org>,
 "Abhinav Kumar" <abhinav.kumar@linux.dev>, "Jessica Zhang"
 <jesszhan0024@gmail.com>, "Sean Paul" <sean@poorly.run>, "Marijn Suijten"
 <marijn.suijten@somainline.org>, "Tomi Valkeinen"
 <tomi.valkeinen@ideasonboard.com>, "Thierry Reding"
 <thierry.reding@kernel.org>, "Mikko Perttunen" <mperttunen@nvidia.com>,
 "Jonathan Hunter" <jonathanh@nvidia.com>, "Christian Koenig"
 <christian.koenig@amd.com>, "Huang Rui" <ray.huang@amd.com>, "Matthew Auld"
 <matthew.auld@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Yishai Hadas"
 <yishaih@nvidia.com>, "Shameer Kolothum" <skolothumtho@nvidia.com>, "Kevin
 Tian" <kevin.tian@intel.com>, "Ankit Agrawal" <ankita@nvidia.com>, "Alex
 Williamson" <alex@shazbot.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Usama Arif"
 <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org>
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da3150e-287b-4b90-9db1-08dee47530f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|10067099003|11063799006|56012099006|4143699003|921020|6133799003;
X-Microsoft-Antispam-Message-Info:
	V3tg/4ByvCrgQ3BlDt3WVh34aW4aIkzouxijtoaEXeJtYpdaWUg2HUAQP/zEbewonoH9VDDtGbdkWBh8XKXjRurMwqFMN1Qe6BQ1774MyRkGNUGl5YlGOP0mumI4CbKigKUkMwDhfQ5FgE79INgFpiKQsn6n/8VUMHtVUNsYRQHM+ECyhllsdDxPyclByT9zAtBbGY8OcPvMy9jayXc5yCVW0yeH/Akkb7LFXcT0P3rEqGCASdFIba9p452e8l4Yeku4Gv3QGjHvEpyAIppAOK35T7v6u6j4s5c5+pQjWXyft1NoGz6XXNIxR3WLnxI+CnUY1OQGxmeRlO7AYk7zMIh6ZM24c/3AyAZGsd1QBeYpf3Z6vAjrCQF3r0PMGe3L1ugB1sgveCucJGLWSjH+oamMBwwpjL983GFW83fxf4aw0Vk5mNgO0HlxUld3KCezcTW1EQJCzJRJYnA5aThsbr5OoSgBKc1L+56hRXUsjK+MgQKKpsf+6bK9CLia+3esPPoyBtaLyoMF86MEXSCVG6SiY0eQqtyVYvotSVg7u+p/Kqr5imzz8k8ytcZG+TlRlgqdZt/Fnz7SN4SsHiwx/Bw+dfxIoW3aChcH+OThmsVpqROUS9je/fD/mfZmUp72dIipEqTX77+FOLJURs7F+Q7jZGysaqI2VmhQYSKcQV5QtKjCrHjzAqtk/JwXB7rpQj2tq8NToHNhF8FYtow8VA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006)(4143699003)(921020)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHBGUThOazN3azN1TnVvRERqcTRvdGhUbE5JVTNBd2k2TWtSOU02YWYvZ0xn?=
 =?utf-8?B?TmMzNzlNS0tGYU5sZ1I0ZVNCdUxESFVIY3h4UExVOVRkWWZHbkZ6a1NBSUE1?=
 =?utf-8?B?V2VHSWhWN3FkdmE3dXVNSHl5d1htYzY5eWwrdUgxRmpFYTZqSTJOamNXNWlH?=
 =?utf-8?B?UVJFcWJLOWdXTjJ4OXFyL0djK1NVd21LOEZ1aVBXL2xGQ2dTb1A0OHJOL00x?=
 =?utf-8?B?Qm8wNlhsNXdUamw3dE1NUVBtdVhvZUFzNmZ5b05CM1JKcVNKbWRneHI2dlVj?=
 =?utf-8?B?d2J1enVmdEluTkZoTWJNcmVrOGFOOWV5SGtGR2pSZ2JHemE4U1pXejdmOHVC?=
 =?utf-8?B?UEtLc3JmQ1RtYmZSRDBLWEFXRzBacENwMmNXemRBOUVuSXhsRkhSQzIvWVRU?=
 =?utf-8?B?Vi9MZ1NmekFZNjlSeFlsU3UwSXRsN2RoMG0xNVJQbTBXZ2NGUXNSdjdBUElP?=
 =?utf-8?B?VnQ1ektRMWErWk11bnBzMStITWIrZ1AxMFNTdFJXMFUraFZ3Nys0ZVlFcnlm?=
 =?utf-8?B?VVVzb3hkQ0E0by9jUURDMHNTaWxqZlJ4TUQrMlFBTGR2SXFXeGRrVm5XS2x3?=
 =?utf-8?B?RUdvYU1qZEJhRzNmZlRpV1cxRWFwa25pN3pwdXZHZS91WTRveWpkTzZ1bTVE?=
 =?utf-8?B?WWNtTi8vSmhkK3l6M2ZjNGZFMWFhclJFWG5tUDBqNkpFSlR0WHRFa29peDY0?=
 =?utf-8?B?VzY0eWlqZ0xKbmhtUzJ0L1pNVWZuWXFrZmFxV2ZqeDVMYW9MalluWnpiakNy?=
 =?utf-8?B?NUNPK3JlNmY1OS9LZFdPYk02REFqMUt6c2VhelFtL2lRenpheW9vdGVJdGdJ?=
 =?utf-8?B?enVESlNmZUNmTlpta0VGc3VhTURoRkVVZWU5N243eWw0aWs1MjZrSlU0Zm4v?=
 =?utf-8?B?dzlCS2hRdVd5ekkwMkNQZll6T0d4UWtFUkVIdTh5WjY5SVphaG5ZSnd5UWM5?=
 =?utf-8?B?aGFCeUtReGFkQzdaYTQ3TGFjR2FTQ2hHQzl0MDZDY3VNQ1EvUUx2Nit6Z21i?=
 =?utf-8?B?SnBnOGxuVDA3bmdGdFhUY1c5c3hzU2ZLRVNaUVJWV3BnN2YwNjVNamJxSXYv?=
 =?utf-8?B?dERhblBTVEg4dXFPdjh2MWpXb1oyeVd3bnhRQjFUS08zYWl4Vng0Nldsd2x6?=
 =?utf-8?B?czE0Tjg1YTdMV29naGlUd3RjeDdkZmJoQkpBVURJTzkzSE9KM25kem5DYi9B?=
 =?utf-8?B?MFpLVzNSV0tuU0VaYmVTaENVbmJuNi9JdERHWGFxZUNjOG1YVnNxWGR5ZXY2?=
 =?utf-8?B?YmFiaUczZklPZ3BoQkh1S25yMlhIeDRJTjE2ZHgrYkxjVDRGZmJOTkZwV2Vv?=
 =?utf-8?B?c3JGR29kcmJGZDhlcW1lUTZoZzduVGJmZ0tJaWUwWHozZmhJa2x1TXhWMVN4?=
 =?utf-8?B?anBhUU1PSkdFampUbHRkU1Z3cUVQdkl6ZVowam5nOVI5QlFGa3o3SFpEWUtW?=
 =?utf-8?B?MGhMK0J0RmxtMVdvc3VTQ0NnZWt0NkpvaFVrMURrNnFxdUJRSjRlMmlaNlFW?=
 =?utf-8?B?UnYxekdOWS8zSHN5Y0JTVTdJTUNKVDBYRnVuQWtQa2ZlYlhESXppMnArN21V?=
 =?utf-8?B?QlJvd2xWT3YzZDFNdUZmMEsxeVl1WDNCU0Q1TXgweVpCUm0xWUVFZldhZW9G?=
 =?utf-8?B?SnpueHJoK1hkTGVGSWJtZFMxZlR1SDZkMThBUkxqcmJwWTcrTE95QTF0OHp0?=
 =?utf-8?B?OWVEN1RLYzNaTGdoQWNzRGk5YWpwT2ZlN0IyRjcxZ2tBcnRTb2IwVGQyZk5N?=
 =?utf-8?B?OTdsU2psQjB2YmJhbDdCMHJzREp3Ny9HY3JtMHlES0puNTY5MXJqQS8yK2tT?=
 =?utf-8?B?K2s0WWdwNnFQOHdKWGVlZUhNTi8rRUFKYzhMTXV4a2VnT0lhRUp4VG5ISEYv?=
 =?utf-8?B?RThMZ3R6eU9wTjNPa0RaTVdpcGRMc1VhNHZ6T1FSV2FtRFBFSTJsK2ZPSm1Z?=
 =?utf-8?B?b1FjcWxuL3F3eUYxbzMwcS9OYWRvcmo0OG14NjVHdmpnVXUwbVRKdFFIU05p?=
 =?utf-8?B?aGhaK2hHMHliN0FtWTlzS2EvL29NUmtwVzhSdWlsUkFvRXFnWW9Tb212dDc4?=
 =?utf-8?B?WmMrY1k4RFd1KzY5QjdIQjl3aU9rRnlNMUVKckZPZmNDVUZTcVBNUmpYKzM3?=
 =?utf-8?B?aE5nclNaaFBtZjlqVGRWN0JUR3lpWTJCZVZiWGJtdEdkUi9nNXh1R0FkeEJt?=
 =?utf-8?B?VmMvZU11MW5PNXFDSTRKK1ZEUG85MFFtZUVnYlJJM0pRdmduU1QrdUlwazE1?=
 =?utf-8?B?aGdCZVRMYlR6VzZ0U1lvSStJOVRjUW5WaUlZMHNHQ1FkY1VKRmt3ZTJyZHZN?=
 =?utf-8?Q?eYyg4gSI8Cw+V9ONyC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da3150e-287b-4b90-9db1-08dee47530f5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 02:35:11.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwoTtXSKZkGjDC+Kz18Q7/kxYHVfmk8nt1n4X7DpJu0o/rxUfzBsIFyVOsi/gZeo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 15B08100009
X-Stat-Signature: imqphjwzmand4hdh9mcap6dp4381yc4t
X-Rspam-User: 
X-HE-Tag: 1784342116-422346
X-HE-Meta: U2FsdGVkX1+FOINwqzb/sKQP6zvn2RBBVikWpyZzluFWf0nHDw/sFtuUIRZ0HZmj3bQdKROP0xBXHPDjgRec06+TFYWkFryo3dC/CujaQgGLSMJ91/LeODSN6riPl5QF/81idCBTc+W8ydphL7Clx4+kpIkze7gPH1R7ltHXdafXxzWYrW/+RglCYVIJXtKJSIMclBja3KewMRi7nnpL6jE/ywNJjHAGNg+b9PJM1pHGQU1GjtZL9gpS/JLvHiT5rMiSCPrPmBdJbAQ8a2W5qlrXLoscZnwO0X6srM6ryP/fxXpf57kjunHf+6g/ZK+aIPpwbqP/DoPGVspxl5gEMaBN6X8PmPb0GsG8vQvqfC6aSO4K3doZX+UVr7H/9XjYkH6vL+vCGXPtYUuvrK1EiHKL5OhorK0ktvG9w5n2wd7nM3Vne+RTXfAhWWrfiyZ4x2Tmnuks1HYhKFGpiZmG6ZqbnAH+ieKjJQPN893NCNntlKoZTGOkIkjadVJmNPyBQvb6h5HXj6cwYxrUIIHzKsVyyiPVxmEkfwBX0uSbAHruMMiKzWhArwmsKK1BPCH8i6pyfHbESLxQ2yGJpnferxtR+yuYsVWAszk2gXlMkUbrmrL21cy3VDgwHtAqfc+DNPeC+BSdxJ2taDvQnbgs2V7UGKMfFnAcsAQgTF1tVQWZ7gFqzKpe2Sp5v/koQu3Y0C0IyQvYV0DQ6vAYEgGSkeaSyOkQm3OR1EjU4WgJrhPR+W4bJLWRBm130Iev0ijJIxo+IGSI5PN34cGUqN/3Bw202QGSjENawjjlCIk0rD6dPLHvzFDeG37KiIXAslSKGSWzL3e5lxO5KeFdABxlvC70hgIgNQHhuKPSSDlMpf1oz+imOlXkqhVfdyIZO84gvUZDQQ/lrr822DIrh1BuHHWl8rtiLBWL6Xz9L/9IfT+7KMQr9MtJPnD3NYMghVuaqG4lEZzeA6U/RBbukQK
 3ye4DsO+
 +l8Ogr0sJWSEu08u4HgxP65m9tdtqShAOPeJXlTwTTuNEamgLF3mMYbGXwE4HhZ4NHDVuLyOfyfZt/9UGwB1zWYHS7A0f9V4Kkx1Sivec3ZT2WGKZX3ttZakmAat80xFFRmwYDcuIQD3ivcXNj4GiLLD/e1dMnMTDl/7qZNqZZldIPEpX01brdSjxnBfKHC0I+vQ3cS4+Mf9AnSxQTYeCJ4A+ZuwMJePHdDtII9PJQL9WfdlR9kJCGesK604/7QZUaS+Inis+C0ure6RRZEsb/sdP9VXrMEIJABpGUtYhHhCp1w4BlcUpW8vGgvDABJa8Ns5AF6ckC0Nls8RUGA5+Sx72pZa8797gEeEXv1R0NrJJv9MvtD54s3bZViA5VOZ3nS/a56TrRYYIjIwNxJiHNZU5z8kVUPZ68quLV5aYziAEI648u7t0lNZkonT7RVdM1EkOw5Ihbu2kLjsuVTN6tnE8A7P3bXdY0fBeGna+PE11kNSuSDXiIRqEmoRVimO9+C/d/ApRHv5Dyrn3IfVkZ1m3J6dfg8dnsecX70oLwz3a0u1sThlNge5mQR9hwY/tPxbN8knNwgBp4qwg/OOA/3DGDODmKowFhTyo2i4NpnJkOjBHba+GeRXWR0fhs4MlqbBpgEm/zu3TNhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 10, 2026 at 4:16 PM EDT, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
>
> However, code often wishes to span a page offset range, which requires th=
e
> exclusive end of this range.
>
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use thi=
s
> function.
>
> Also update the VMA userland tests to reflect the change.
>
> No functional change intended.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  include/linux/mm.h              | 19 ++++++++++++++++++-
>  tools/testing/vma/include/dup.h |  5 +++++
>  2 files changed, 23 insertions(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


