Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5102FCA5FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 15:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C98D6B0088; Wed, 30 Sep 2026 11:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A676B008A; Wed, 30 Sep 2026 11:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AE26B008C; Wed, 30 Sep 2026 11:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7D276B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:28:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51610A0101
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:28:26 +0000 (UTC)
X-FDA: 85270810212.22.7CA7441
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82E4214000E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:28:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D1N0qPH6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790782103;
	b=jhagEZ59fMd2+QEE5TR3/SAqBZM9wW9Vk1f+vtNH3erwRl8UHbcP1VFuOwgIfnSdVFmIZ0
	DDItLQ1bD2upL7IEJq04PU1a1IOeu8wiVSSlbuof5T9AJyUHS39PzdLHNNipA+kf/pbjxN
	E/r0KrKY9rl48+yhwwZHl4+1iPMZVhU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D1N0qPH6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790782103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8w1jBnA80+jx0tcZGoqUFaJ5onaLQirx/OFTHfw1Is=;
	b=tGNsYNeza6BQhLkS94tHbCn18SOhBlZ8fEFEhkF5o5JgtMd7gpXfs9FHq/xmCPuBxyiu/+
	KuEo8/W3cowAN6/Pms904v1vhjqxTmRaLJREof0d21nbH9OtQ2qn2caGNp95ZrPEx/9TkT
	y3LR1FuU75DZta1XCIw8Qd2SMZ1B0lc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s8uTyHY6ca0S0gFpYdWeYhmt2qrfVim81f/ez5gEyTG7rnWCcA8/efKeY19pYTwnxwABRHXRKolDwQi2UhO6Qz7e2tw2LtkJhsBVye4eWtkujwDZZ27NbV2cskWBD4nzj1Dd3LmiOn4W3u3obhqoFQUlgEbfAT/rGvrdzux+FUcMcTWhIntHiV95U798sZ0k9HBVZ5bIWiu68czDL62rHBAnmeLn4IK07kBZs/ig5ErqAxPLXbvEKipxMPC6OIyzO6xtuBjjFcSmzsvMHjYPfjA5yanrW4EaKx+lblQaKX1kfhoTPznH15l3TzT35GNhWLmss4FkNHGG6SvIvUG8mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8w1jBnA80+jx0tcZGoqUFaJ5onaLQirx/OFTHfw1Is=;
 b=JtWj3321OWFasox9ZMgOhmSAZPBdcjqPps/So50HJ7tSj2RIaFzWfVwmg056K6Itl7SlkJcHCMMvQbbJTMO79OGYAlUlJuGtRtdVkL6sMFAexi7rnPCZHLYdW5ylCqSCWp9Tbtmwyu09O7a/B+uMNCtRv6iEaMwjKiTLORhoRLOqV/0Taa1tt9sChnpupDPn3t2atSyDikEKWBFyLPz6ExmCk3P8/RraolNwzkaYCWDAWdQNlhDsDztRxk7p+U8gIFWQke2ge3GUrf5TMVmjVdk8i+weC5bxjqn4edtnPcOmAcvjaRYdEw7K/USJ6WkTMuC5RDb/DfHvcDWyW50Ymw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8w1jBnA80+jx0tcZGoqUFaJ5onaLQirx/OFTHfw1Is=;
 b=D1N0qPH6GDpjju4aIZpuxd1dhaa2+ullhx2NmCdQEzl3PVKYtQiHUacX80CpSDdjg0S1R5ugLiFraR2ypmUMTxGd3LzzhmR/rTewwQlyA92Mi3NJk3EQlxFcyrFGanZDy1OGzsQAUD7urm32U1uSNCKFWM7dEF8VvyJRYcckG81trDtDoXM+IP/gyS2UIZcfmNG4Lwk6NQHtbSLnUzilm8CMps9VuTI1+77XdaqWXsdqZUz2hwiQ3NL+9v2iT0+9kWqOl5A7DD0o3HbuAv6X5Y5zR2uE1C2tjPAIc1EOJrtUqptRVP22RCCLNS8C4ohXmhwm7eqoEgGQhlD+OCe9zQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.26; Wed, 30 Sep 2026 15:27:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 15:27:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev,
 kasan-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 1/9] mm: introduce hw_pte_t for PTE table storage
Date: Wed, 30 Sep 2026 11:27:53 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <51D02557-E9CC-4806-917E-279C6E66AF1A@nvidia.com>
In-Reply-To: <20260922-pte0-v3-1-5670b8cb9059@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
 <20260922-pte0-v3-1-5670b8cb9059@arm.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: d214dff4-b381-4957-d09d-08df1f07674d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|4143699003|11063799006|56012099006|10063799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NTMS7w3pkwbdyX8kXLQQPd6bmp7vgxhsw8wWUgoxv0BrTrWoioXQwXj9y2sXwxqK/qp94qzNdh/w34dJBNSvbrkk9mQbv2eUPT1dCR5tZ1ctxQM8bgU8kBHD7llfqbs2uDuPa0FCmoZMt4aJnvieWCKHKxci7qcqJAuMjkWfrFU8R5RZ0Pp+gWd6vaVst+KGOu7iQzlS6ZiiLCyEHCFhE5UTWJFFq6SPOOfeik7Z0B1OXZ2zH9V2SuK02wJNgjSYLbszkIqi50F10i5CEUJ3ZGuCkyo3DM/MwDsQAmHM8Bp6vKunIh4HqtMQOnv7zekcp+FzN5RAzsi0FWBm5ZLmamnACbJ3ID8Uhc2HbeBvXNONVsFjYpykdaOuaDLwRN1/WB3MpYmtTWpOhyqq8LIb7VFs6nvId/Ccql4GAZZPIAqWvI0kj6zudAav0tOCf5ocPxPGvqv0srNHGzljQMohQkc5knSeLiz0T7I3twibdB+LZUKnkqS4g6gZxOLx8jHHOrM7CcIMBFvSVOy124A+psloR+Sir++O4fteJpkRLIH2eo2XV3ANbGLdqlMLl7bvZevXSVQuXGwtEFUG0PQnGs49YCqwB44rR9hCbCcjSPAnPCpAXVR+pJ987rdeYw2WIN+jnl6TeeNBBReTpntyPBD6DV97FUla1GcpMqCM9h8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(4143699003)(11063799006)(56012099006)(10063799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MXu4eQniVxMuLf/9bfDbC7QY5S/GZmk+BEhdZPsCpb2Fwvz+snepEPRv42qo?=
 =?us-ascii?Q?J+fGc6zIpN2r69MH3j1NbAw+66SPKNJSbZWhUSOYSaWDRf4WysG/w2mdz+cN?=
 =?us-ascii?Q?vp3KKbYKM8MhsCZWkFB42OashkTTgzj6OZ6vq7YylqGondij1VlWCYNmcP8S?=
 =?us-ascii?Q?6CXUVF1CZY8gLz31yQcOyjXSX5r+5W5adH8GV43S5daPLgy1FP1pch3Vqrlf?=
 =?us-ascii?Q?LydlKNFlFcd6CQvLAmRZRg5f+x5EGG7YhPBj+3BMbN4LI/lNWXYIpqiHqL7j?=
 =?us-ascii?Q?oXhMMivi1j3CAIyHtKjnBqsGsncsD9Df+DEDyitdDfZE5i1G5UrNPgcatcz/?=
 =?us-ascii?Q?mOfTjD8IZ8ZR2rMuwlWGM7cKyWdpZ5SlTiRxY5CJuWwlCSWlWhK7Mn9edgn9?=
 =?us-ascii?Q?Abtswnt7rCImfHaCNvjLM8bxzr2VL0lWfaOQoi0ZkND6Uxjx80xWYDeDdcLy?=
 =?us-ascii?Q?E2M4AQSakyvohHmvNmzUGfYvmOf5UofkU4avmkfn0FAKO3HBNZ84eu6/qB0/?=
 =?us-ascii?Q?BZkh42wfg4Tpp5AzexqE0YlzTTYdsEhTlxyMDpY0dY/493VkD3G3VmmenLvc?=
 =?us-ascii?Q?rOsNrznL3Ai/WSC9dPAJ2ZVp4YFIfEewJtaYthUYeM1mHNwkHM57C3jhqJZE?=
 =?us-ascii?Q?oE/mixWkz2wHs5AScj9awqrTKdoG+D2+UP55curGBCATRmTl/m7GNbhLI8DD?=
 =?us-ascii?Q?/LpUx+iBAnEP2/sP4eK6DpVctibX9lPiiKkUQDwfqPwHb4HWHRBFrm7hyvbb?=
 =?us-ascii?Q?1q0FRxmMe40oskj/VcMiMnLOYQolAHPLNrau928odO+HIqfP4yZRqOG4dD0h?=
 =?us-ascii?Q?PwtkEzoBxPv+ezIzGXMVj6vnzZHj9k+INQcrtqClIA1ORalRBd8jzvtlji5b?=
 =?us-ascii?Q?/2qlXjfsInReKmjefmVeIOG1K/qzZ5l/6e/Lwvopa6VTFuL+SrhYv9N/Yoc5?=
 =?us-ascii?Q?j8+pg/TPURR8FqRiO5nzmXCWudtk9pQowrK1N1/noRFW++Oxh5J6KEGxWoBg?=
 =?us-ascii?Q?bPvscNfCLhlUpVRhJ/HlU6qHXIHRVZT2ops9BEj/kj5gQGfI4gKjYUo8q2wm?=
 =?us-ascii?Q?EnQA7IeJ2rTYpUTpOztbqVoqKIAugvcp5LpMgIaQJgYyR90PdeQk8rB206pU?=
 =?us-ascii?Q?OEevidn/mt07l+4qXT8oBb9a22pTAX5Oz0iY9j1ManvQYZpzc2pC2r3XI/7w?=
 =?us-ascii?Q?yFS4ZzYI7p519xaiDGAOAL210+5azfqWPKAg6FPBqpqqUj4RH+MzvfU0VjFl?=
 =?us-ascii?Q?OmpY5RRcLDE94Cy1REYNVkR0ntXfbZovloDW2XYuRh1PRBAplbFbVz1CF6j5?=
 =?us-ascii?Q?HNbo0gHXo8t5IB4239rfrJjNIMAv2hWLBuATBn9RDSclotP3/WVbOlTrrAcA?=
 =?us-ascii?Q?alpY8++184I9GbRwPtp9oFf7AqX1so53T0aej11fWXSkDCa1pQAAGqrwk30V?=
 =?us-ascii?Q?IMeN5jH8ijdgbAThHaaerWzyh9CUxr0uM5fjHYLb6lohDLNnl+7gCzQlXXVU?=
 =?us-ascii?Q?kknZDCREfrCBcTH4jTRN6YVj+UUrdNs44QUakpZEqj9lZJvG3tCBCjQ5tiLa?=
 =?us-ascii?Q?YWv8bBtBYiNnp4zT2e28zycu04Xl/sgRPaac3E0Vo5JfjdtnbDUBYehX0WWg?=
 =?us-ascii?Q?lEcYH+QxwZlpE3cj0tzisjeSTXu2N+jw3p9Iel/2Fl9/zZx2i9uYQxMkEDjn?=
 =?us-ascii?Q?GS3vsX2AB2EzWefPjnuPPbP5XqaqtZOHwLXLZGiQl5NHkVEOqH+nMbTsJp/E?=
 =?us-ascii?Q?7DP2WO6Skg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d214dff4-b381-4957-d09d-08df1f07674d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 15:27:56.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLttr6nZbAZEgLwiA1BQTWtmyJC4gk3s+HBEIV2F7pIcz4C++d3nVT6aZtPTmkRN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724
X-Rspamd-Server: rspam06
X-Stat-Signature: k7d6uy6f9iftt3seawudazngfnbw9ghr
X-Rspam-User: 
X-Rspamd-Queue-Id: 82E4214000E
X-HE-Tag: 1790782103-276275
X-HE-Meta: U2FsdGVkX19ewzw5G8wEMFjzGgRDlHZ+iXswysYdL2uQL2GjbDR4tseYfdR1clZ9+tUAWOoAfC2p/ldACfQ42EVR3sD7DtX2Gxg4CB7NfpP1Be80pdmzguYR+lKK6NPXTIpdEwqvCOhg/1ItBwE0AxVdf2UmmrsjzAfF74g/Fvsdt0Ig426OVWKA59qo+4TRUYzy6jaI6NkxCtis1JxdwDLIdxg1vm6nx0FFl4/uoWK+3BUIFQFWyq5g6G/sDrnM9yzrY8Cd7xsqopkwto5ufvZ2tmNbFpkSnT+Iw2np8qBIniyG5Ad/TK2r4x1Il3qKKO46VsPErP1pxBTh8ZgdPoSCsEVVTJ3PjQp/ksvsmApNq5xhVb7Ti/v7RgaeYy+C/NoNy+diJXdom83JQMsAiunauH+SDpJzPli0wcAsoLE4KhZAJWCBQAPYN4vfSWZYfqqzvStBMoAYPlqBiKeE8KmY6mPO6ka0lavyx1iUVQKLZDavIHOKjeYoL1w2KVtP2gdS82URGkuQQ56ePDzkhodsy5R2jcV/lO2ZZm7Xv7lX3kGquVB7gaUlKviUQtAB3mD+4T8DwwOIdKJEY1gNoWunkBq5N+C2FJVVqYiWO0cYeAtQfIBqMOJ6g3NB+37ShKSe1RSTR9duEy910DIEYa9zW1kAxY4x33too9tzIi4o7Q8S/lSaIWjXE/XfZo7HHIj/xfZFlOH4AgnspAAYFZWguCH/x9etNld0iOj9Q27kovgwQJh37Qrm0CykWlpdlXY6gmjuy8QlQR/JZlSOWnjgOguslsMcopZPzGlPK/SiwDcfcbrozPokDv0lJhlkiy/1s4txKPMSz+5SdA62sLbjIT3f0Xn7UGna+zKSawD2T0ZaGqjA0Y/GSv4IW03Dm3M6KWwga3iqaymtbB1Mp47CO9frNyCRSAHPO9n7tY0xT7ZDeqXQjeq9Qzfoh0heSrzixHUwPj1ZNUG678+
 Bcc7Upym
 owx51n9+aFQzgJsC0jKAwqzydDKwGxrnVQ2/xG3mJN39nwLriGJBasMHlUr8yrjchaB88MBAoEfL0O+fhi3Z73iSe4FBM1nuCCncBsIw90kl+S7gSy58hWAIaBgbTiPWKAQk60gu/QbAd7B1+mEjj2o3nJS9rU+WM5wB4PSgO1duX2jZsfNWrg4AiVApUhS4sRqKXvuJdNcTYelkBBzRScN4rlT2OIZRLwKYs2UbqzZGWdWdjg5g7iVWyt86yXZgZVrmXkojfxUB2gKBT37jGoU+W/7/TSawfLFIPPKDw8zx0d5iqK1CagrJ4PnRyJqF61Bk/0IkJQIwfDhV04xaQvQqv/XcCsfmBalB+ZSgPIXGsNhUL6OkrmJ4d8phUiiXjLfMMOgDECDpVLDlv7z+daGSLhkPpfHU7DgQRhptvDN7NqVdDnsyj5TlCZy2AfUYUlriiueAA4rjW9wU4w0uZm87lT+cyX4KPyQBRGgrJQkDcwfoB5h04ufgU+90Ydh4FuS0nSLbutv9KTgHBKvvO1LXnUpImcRNHE6eTSlJ9KSe7EdN/s4PL2lZEpiQtefTiZhVt9t5PAY31HulYxeup1VgqBdXwviS0kFyQjdDEzb2vqH0BsOvlIrHrJ79TApEj0rlae8/9u+sl5HcZ0NoonkhAavm3ELWsNLmRcZkjZCtqcCJ0JdTV71NxI/TaKJ5E+uk/SCtWPalRliIVjY9QYrYI133+FEr6TgHAiCKJhVeMK6gFh5FS+/rb/kh71HvIwUYh2PcQxCRivNAM6/VuiR4rjAZkEx+r15e4fgJh34wQLA9kFzFZuqfYiJ01xA/vuXCKf19LBvO+2dzGt1dGDFZ+9wGs2s8jByz4ddhVu+5RmaatKJinOiTR/Y6/PnVoQRMdXmlPKr4Iepk21YbohqXx/I+gY192eLvGEaYKxtRV6+U3aN1/pASUCriwDAwmoKmKF4tBCbCwbFK+iPumjaaUD3Tp
 l9zqBtGe
 7ZugaTW3fWLWeDkun4PjlxY6Qb+XvBMBYkzs1NwLvCm5PZ3Y7rYaskI+RIQBLU4UeAENLAXDjRnSjI28pS0BBo75vE3Da6m8Y/7Oxnk02j5J13sNDCtPlRkdPOIMYPi6Ub84GKKnoAmIUrLRdLcHkB1OYec88pFkx7yah8D90kThps8cKW9nuVdJMvCdWKhkMou79hOD7y6yqkRV/0DUAbPDFskwVQQi4VGqbKamI4ywrhgR5gAtkTnUa8u1UsJrYOFdIc//XTY02hpt39kN7eBAcGnT1dhyMdl/1vTaXoveQcgCLiKq8BiXrvppKWp5USLla07nltPZ76yyTTpQjrzO3jBh2m3wLbIRGsX+kCUWaVzoeXLTZJrZdfodDKRyNksM0aOK9jOo9zn3JnvCYWEhC+vfhjR4mC3YJDI4u0iHYINp8afckzS0GgJc6zVNDfA/DNE8J2XVx9yZiuOfNciYLsFEwt2nka9XVQgZ9dYvHdhDfsLYesVOoxrcP8LahVeZr8saDvEhp7oAkjdlooFDsHjiT7BMiA12O62AeqRpeR8DzrsAWfrxWsQvqXFzLtr8w0G8cHtS60G3o+KwSL5W3IVkh7Cw2AZEZV0h1r41IetIa1CzMi/tt+QiO4uAeF8/Kvgi3/SO0DcF7yI3XigAZP+nps/ZfnZnWS4f46C+pMFZaKUp2qm+oTefx1bCxCL94kiuzFU+HyoQhY3JWSGzR/xDMA2eaJoq5VluDjrdBdlvDFW/fUO9TzqyWgxRYH8n4+87HHul6E6DfnCQMBDnx/25tk/ySxcq0wTN+J61lC4mbdwGbLOy7uo9E911JhCgJmKQq+ngxpsLCJkxxtaqOSfl5helqFV/QdwyzIfo4nObuMGQVKdf9QGuWqh34qGQFgrZHAJhkQ1ceQ1LwBrTMgvmcmgAukw6SjjDGiHBYwMlrdFPe4g/t2NfGk/hG66n63lJkJW4ZZ5TpiSD7Tw39swGN
 Q2dE0Y2x
 umyHVvc+d32K+e2yrnFbFK7AWB5fCTj/HfSI+TRo5BaFv3OA+WwvF7zY2RsjI4g9YTZyk8uKoUZooBgL7g5Y2jAkTC0Zq3bKO1BjF7Zq2ilSYJSO0bx0TMSGdfh7gVqzbs6iLXgXY1cjhWb1kFkAbgVVjL3BKddoOHwfoMjWwT0+ZjRqHrLGusZ78Jp7giXpulGfFBp63FJ7M+yl8eEcuFHjeAI7HCB6/PAlJeuV8uU/qcobd7Pn44aW0TnQd9N3jd8vkpycAT/kMGNCZQcXko1YEnisThvLuq/abg5a1pLEj+JyfIxNyeRCoHIx++paEnTOWetOyLJ3NInLPia18zCTNz9ASgJXI8FjylHmlHY79P6DqBSncZvj7c7IChJeqj3b+J0xhnEX4mYmZxubDmvWeD2PL1xVaOGqxhLrkPl44Y2NOJUzARR2lQTbli2s0q17d4oSHP3mxZqrwvXiImUI7T0gBPJz37ouQi+C23IPzh0z53AsbrksDgF+MFi+jUhnbqrtk9Z5jsO8seazZhNLfgI/Y8BKpa7FhZOcTFY4RLSesrd5Sy42j1PZkNJU6fvHDp02/NzKjk8HN/vE1I9Ks1meSFr7MlmuXaRz/YOXhY6HF31Nn+jeTxHHvpHmaaSN2RnLxOJGD2BBeNcXVFCnwGxFuT4p9/RvpRBxjTpez+vOEjr3Jq8N8Vjv8mTdBOAdG/ELBNHeuvJtbdTo3+wa/v6MGhuzB2rDXVEfUPE1KbcjhSIvF09BN/dmo0GL3J135kQKDF/a4FbPDMtJN7fZIl9tjbkd9CGPi7uk8EK1MlKrGROOJvPc70Cej+OfZrf/sCo6u/Eg6WyL2idisW0cbkIwslwH4R+Xo+FV/UMcsrPCtmk9v+mbklDpPOgnsWgliyuhhNH6xXiQ81iPpP354wvGKbub4VqYJIFZhzOt9Y3mGOW/gtndZGFpukmVJZMoUAN6wzeazUbd+oub/YZbvOI/t
 StIyiXFO
 5g44YRvHAExMFa83gaE/b8RhB20vOJc52Fx/8SxLuOWIf4q4MIkCtvOPB5pRPIZksqkrmQZiQIiwYAiQM125PHltS8zbjfOe+llQ4avnuqrbgcRsQ49QQuGl0UhvqCm6nVGR1uTsSl39iE2tYuASujqNF2ue+pV/ywEhsuTFtr8DfrwBSfDPYe1rrlOwZsrUm7eb46b83CJBKFHIZ7xbGdzVOV54MauckTcmlFNQ1WV4UvHsSuN5qG9lxtLFu26ft6FKZWAtgadxM3hnU5ulsXYr2ri0T0fsmYOMx1BY7510ZXkRxAa4Az8DCGKHccsXQRlbCbmD7IRqmcVkshWxYBchjbZlttT49L9BBx8GbZyQBiCCC1JCtteQRBp5cNE+L5pWM3WAX4eOjrW8Yo7mSfOGi83xPGiV36ltejeUg/nIgT/A/GOvK1fPDaiB8Ky0/Yret9wGYPVahUjp4X0GFTWo1vfIZb9FEHkUDjQyz8J3Q4z1wWmbs3UY9nLEQv+prD3kSS+q4bohlpbvfgZIiL5Qp7txluMXvZtKKmT91ne9WFodA56jPzhV+7JFi7afaPfu4o5C20lAmEHH2/vKQz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Sep 2026, at 13:12, Muhammad Usama Anjum wrote:

> pte_t is used both for software PTE values and for entries stored in a PTE
> table, so pte_t * does not distinguish a pointer to a software PTE
> value from a pointer to table storage.
>
> Introduce hw_pte_t as the generic name for a PTE table element. Define it
> as a macro alias of pte_t by default. When an architecture selects
> ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
> This preserves the representation while allowing converted architectures
> to enforce the distinction at compile time.
>
> Name the generic wrapper structure __hw_pte_t so architectures can
> forward-declare it when pgtable_t must be defined before the generic
> hw_pte_t typedef is visible. This avoids header-order dependencies.
>
> Keep the C type definitions behind an __ASSEMBLY__ check because
> architecture assembly sources can include this header indirectly. Include
> asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
> they previously obtained from that header.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Name the generic wrapper structure __hw_pte_t so architectures can
>   forward-declare it, and explain why this is required.
> - Use software PTE value terminology.
>
> Changes since RFC v1:
> - Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
> - Exclude the C type definitions from assembly sources.
> - Update the description for the new opt-in model.
> ---
>  MAINTAINERS                   |  1 +
>  include/linux/pgtable_types.h | 17 +++++++++++++++++
>  mm/Kconfig                    |  3 +++
>  3 files changed, 21 insertions(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

