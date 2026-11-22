Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9480A606A327
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 21:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O1bwyTfE
Received: by kanga.kvack.org (Postfix)
	id 666926B00EF; Sun, 22 Nov 2026 16:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1646B05B0; Sun, 22 Nov 2026 16:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469706B05B1; Sun, 22 Nov 2026 16:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 083BF6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:12:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DCD8120734
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:12:37 +0000 (UTC)
X-FDA: 85464003954.27.1BEEF02
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010050.outbound.protection.outlook.com [40.93.198.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 85BCD40008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:12:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=O1bwyTfE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.50 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795381954;
	b=xkAPQaQ3VxKh70wfILfSjeVNMce5lRGiqtrp1wV/ZACCmqp8BZUclJ66xGEuXCoHY7xLHv
	lKlXW5Oa/sM3++URQXOrVT5gGqHP8vu3q32CoxPdqhg1y8LLqncKFTeTR5z0ZWQ5fP0oMK
	7oW8aioGqq/H6/HzuL6vo1DdZH9ayMg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795381954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dXpHbsCwZA0kvg/byCaQokRceHG2Kc5PP29z/ePbVg=;
	b=1Ev17geGru7KVR2b/HdwfKhnkanjENxzetmolCleM8FzNTQsJn/mGZmvYP5uj1BaqzhI8b
	JS6tF0qLT3vF6DDTB8myVVjpJtq0yxBiMoe8pVtxe95V4ybNWpwoovMmgm2R1Lz1PyqU25
	n4iL54+yU5NmXSVentFTnomkYVxprWI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=O1bwyTfE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.198.50 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lVuUeonjHJzX6hy1X1OcEVKH5ThoVKGNM5hQ2elvE1J6E4pPVR2sBt+7ugzx6Lwv3rQznykdvwcPpVmIyMT/mk4w/3lp6Bo5k+BMatvv178J3+7HKfO/JVSsHaUk3WoYbnA0SuGCs0bQNHXlNmZRep6AnmXTZC2E6vq6SUlFdoeUCN4hKZRftg44dNiyjVrgCJaVNiIx3u3KV4rcT/e8ZNaEWGRLPEOoUi/PIICXcyQYDfaeISzRhIgnk5QJJFCrn7Fi7IVWnxBiku1Z85F2qMYxy5gadKLOrcK+4QRzXXXPcMfBjN93AF1W2Y+sZ2mp/l7QEEzKuND5LvWxUfKigA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dXpHbsCwZA0kvg/byCaQokRceHG2Kc5PP29z/ePbVg=;
 b=s7SMN4UGTc/84Gkl+JYcxgmfLa0MNKNRd63uBDqe9vjm0O25E06+Fczg18ppOy62KJA0pV5Vqjt3WSp2eZByjAiOJOwTXXU8bAAmeuJt3XZ0rbeceQxpnCzcQ4ZcxRPu4diZOI8Rz/jI+68slfBFaLjdcioevX0bzPJM+TsxngHQhtEkEfbkZXyb+XDx1dOTvzv0L3Ccsk+s045jpHStW+7bceFTDicDpc69qOTNI2wBwYVHWS8IQPQBFaGZ05e73my8qrTivTHQwbD3JgB5dcjZPFEISlA0LbEHQRuf7wslMsyofHlwExEjUL6W0z39S2KvpqhJ7QPFeCngKtH7ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dXpHbsCwZA0kvg/byCaQokRceHG2Kc5PP29z/ePbVg=;
 b=O1bwyTfEdzUXQzowi6rkQG4HrlTtI7bRNuCjNpexC6Bud8xSGzc0M4Vc9jrWjtgVjwBOg9UMYL07ZurxFo4aydVheJvabD8YOrNg7gDsjF8bhSu1GE3CoE0lkdVI+XMlsUoRktaRzBo9I4q/07K/V2R3xEzSldG2Ffv9Kk+mPto3eOmhKtEP20kh/DCqRgS7JixrPNd5RzvzdSNcAweNuxTKKeGyihVo8g0UPqIcXaPz/yWK874R/v5UzNvxCeE4dQokrz2kHaXvWhCVfKnsAILjXpdeI9pMYQ+tHAnkCWOmkbltLe3q4t8zxzYafIRLNNo4D2hS9lfENxt5q+oiTA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SADPR12MB140239.namprd12.prod.outlook.com (2603:10b6:802:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Sun, 22 Nov
 2026 21:12:30 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 21:12:29 +0000
Date: Sun, 22 Nov 2026 16:12:28 -0500
From: Yury Norov <ynorov@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Michal Hocko <mhocko@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev,
	damon@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/60] Private NUMA nodes
Message-ID: <awNavE8dAGr-amfQ@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
 <179537469194.412063.13456998694958645706.b4-reply@b4>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179537469194.412063.13456998694958645706.b4-reply@b4>
X-ClientProxiedBy: BN9PR03CA0970.namprd03.prod.outlook.com
 (2603:10b6:408:109::15) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SADPR12MB140239:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c70776f-1524-4c64-40c7-08df48dd5123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|7416014|376014|366016|1800799024|10067099003|4143699003|5023799004|11063799006|56012099006|261009223027099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9gCBtPNnzfkQsU5GjDnnYwSa2mDQD6GUGZUsKRsNEliR2IwFOgSUumiZRHIA6ta/8RvHQ7Cwir/qFe6Dmx9x/gdyj/Zu7SGSR5AWOhCbAdUVEXtADDCZDYafbrurBJktxi6cQCQLhaHNrfMYvTsBysm35HvRpxkyYHnFuM6886ElkbnuFLTNxW+3qCkFhOmE4rU4mSqonJ6voprNobIkAfjwAfjMp/2WFmtLBBrhj1NuZmdyjWi5r/zmC0dpueyQbQdIiCiCvcINIcsHFd6FCwPJFDxzl7XSAZo2M6mo56P50E+1e2cCWxBj5+bu8WcrZ55UzmCL8csipY4xuRNRo0C2UV+r6mIwRgyDWSTOwjJxmSrQU5LKjS4EtyMQDLJUtkURzg6JK/we6lKUwpLpW7WUJ46nsIUI0ISwfiBke5BqiFuBDfubVVQgOKllXozGsxwmodhkYDvitHhwMaM6YyMLP+giHj65QeYWdXny6N6WSER08IVIjcsScnCLXtix+0JJAQtzRI80bCxGrccZIcWUH1VALB1drlC238PAXcYA25tJRVBKx42EWGYopqv3QnwYkHOAX4IxjI0SjsTfrKpL7koQKAmaxqOewYwTAZvaFgfLahVaaMffmjXcn7uX09ggR6QreKk286Aj8tUfmIkbMy4nY4cz9IhY2JzIKfA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFFvVWphL1o4a28rQTBvRC82bWRXWXBUZkgvcG1BVEZmaFpCbGVpd1lIOFpZ?=
 =?utf-8?B?dUgzcERHYlVxQ2RaZHJaY0Z2ODl5RXdxbTJwNHhtRlUvWlZheDdMeUFmNWVu?=
 =?utf-8?B?VHlCR3l0T2swemZPUE1QQW1ub0pJaktZTWtSNE00SUlHd1kzbTJ5N0kxTkJY?=
 =?utf-8?B?VUlPOUltcUxHV2dJcXgyKzNxSy91R2VZUG9xNnRGYkRNZktwcmsrYUpTbjdy?=
 =?utf-8?B?Nk8rUFhaZitVdzBvS0gyRnpxOW5EUVFCbVZjUk9oSUpqWnJ5Z3BORFNML1dj?=
 =?utf-8?B?NzVpaGFHQStMbk54TWxSMGVZSmRxOVhxWDhOUGh3V1o2cnhGUGN6Z1BJcWFL?=
 =?utf-8?B?dkF3WGVkUkNkQ3ZpeVdTYmJtQUlnRjNhYk5RZUw0WkJrd2pidTBPQ1AvQ0lj?=
 =?utf-8?B?bjhuVWVoQzBxemk5UHF3R0ViUjFIaU40TWNXTUNIWnBFZVJyWDlNR2wyMXVy?=
 =?utf-8?B?S3VyU0Q3cVlFbmpGQkxvUFNKTEhUd2QxRFlPUEU2ZUpkWGNVbmNnN2lOY1JK?=
 =?utf-8?B?YWRpU0RVNXM1aGVLL0RKS0FaTVFWL3FtQmxxYU9Db0JNMjI3RzJJcDlyR1E0?=
 =?utf-8?B?MnY4ZmRWL2RIS2RGWDBwdG8vQ0N5RzhJbFlFM29QdnprRUNhOWhFYjgwVjhG?=
 =?utf-8?B?VnRydUVDR2FXNCs1OXZSWjh3WEd5TGFCdzNPdWpuSjR1Ym1NRWZERm1PV3c2?=
 =?utf-8?B?cUFmbjRORk05Q2JJc29MTzN0QkdoUVBBdE1tQVZpMXdRRXhGNStzMnZlaGRz?=
 =?utf-8?B?eisraHNnWWdPa1I3MDIrSVB2S3FZYzNLT1pWRnBZVlYwMUVlQmxUUURxU1c0?=
 =?utf-8?B?WmpEZWh4OVF2V0JXS3BVSEFyZTNKZnRXSy9DT0V4TTlQREFIdUFCNHpuejBE?=
 =?utf-8?B?anc4WUZDVytEVFAydmR2VWF4dGhRU3ViWkwyaUREZWJERmR0QVhla25HVVNR?=
 =?utf-8?B?dHdXcjNmR2dKRGxGWWZ6SHVaSEZubHhtZitBbGNqQmQxSlY2Tlg4M1ZxM1hr?=
 =?utf-8?B?cy9BZU1CTndhc09ZVkNLbGFJcmF2YmVuakU4ckRrdG9TUm9OZTlHamNNVlgw?=
 =?utf-8?B?Q1VCWVRXazJxVU4yZFNDbm9XWHhraE1Pd0tkKy9sMWJBeXRVQXRJckV0NTVE?=
 =?utf-8?B?T0VONVl0NWl5N2JLRmY2czdqOGhid1VRZXFURkNMZ3B3TXhsbVlMdmhTMDNw?=
 =?utf-8?B?ZEQ5WkVqOWwxY3ZSVktyS1JVNGdRbzZqYjdISEcyZjhiYmpkTTF5Z2Y5RmR6?=
 =?utf-8?B?bUc1Yk5HaU4wa0RHbk8rN0dqNStOZlI0a0Ric01KV0F0QmNWdXROK2ZvN1l3?=
 =?utf-8?B?ZVRscWtxdDFZS2gweHRIMTkzbXFzcTRiV011RDNYdGNsN2dwclhjdjE5dEQz?=
 =?utf-8?B?MzBWd0w1bHc2UnJmNUI5QTY4NUI5bXlMT2NNeW56TVJRVm5wQW9KbXJhZ2wz?=
 =?utf-8?B?SUxEYzZRNE1XcDdBN3JFZkNTT3dmTnV1NDVvTUdFeVExaE9ETGpSQjVGTmRI?=
 =?utf-8?B?Ty8vZFB0OC9NbnFVK2FTTnc5aVEvQk80VmVKNGx6QmdlR3lrY1RSSEQ0Y002?=
 =?utf-8?B?RStzVTdYOXRIQnJXaFdadnJxQ3ZKc2JlWjhLRnZJcm1ldU5sRkp6VnJIVlJX?=
 =?utf-8?B?NlNnOGNIcThKdUgzUmJvUkNGbFhxVTRhaEdiVzBBZnA0YVNsL0IrUkQ5bXlB?=
 =?utf-8?B?R3JQWDBRUEk3U05oMFVkdWtuVnhZbHhQalpIS1doQnVpZzk5SlQ3eGhvSXho?=
 =?utf-8?B?VmFpRHZ5Qmg3cTFMSHYwUUdzL0NybTczM0hzZXRnbEtXU25DMktOWER0Mzkw?=
 =?utf-8?B?TTkwd29tOUl4eVQxbjdLN1E2bVdRSDYrR01GNU9sVG1Wcm5nSFFCODNNeG14?=
 =?utf-8?B?YlltUWdIditucC9kajJVUFRmMUdlSFFoaFJoZU9QWTdkeStCZHlMczFwaU1n?=
 =?utf-8?B?YUxRZE5EL2pjcHh2ai9uelo3KzJTUWpDS2Y2bjBKZEx3a2ZzV3dTS3JEWGJx?=
 =?utf-8?B?YW5pYmtmU2ZsalJjVlJmQXVKdy9vWTZ5Vmh5SGIyVm9aMklvOEVoOG5mMmR0?=
 =?utf-8?B?UXkwb2V2RkpUTVhNbmxYMUo4d1hHWE9XRmU1V1p0L0xzZDBib2ppa0owekRo?=
 =?utf-8?B?NUhuelJ3ejJVSTFTUlpHNlhiQVUzRkFWajZISjZlL2YwNmxnclN1SThxc1ZF?=
 =?utf-8?B?eXVpWXBZWHVwNWY0dDkvL2FoKzZBcVpqbThsbVZiTC8yQ2FhS0JFZ0NsNFJZ?=
 =?utf-8?B?SXVwZisza1IzMXBOWDhTaG1kTGQwem5iZWw5Tll2MU5mMkRuUlZCTHo4bnNp?=
 =?utf-8?B?M0prejdPK3RDM0IrTXdVb2FwbjlaWEdLanVxUjEwQUwvR3Z5YVhQc1ZhQ1ZO?=
 =?utf-8?Q?fyrFrjyuGOLLwaJtiv2LkhY3yhs/kdPf4iyM4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c70776f-1524-4c64-40c7-08df48dd5123
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 21:12:29.8862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PI6Nz4kQxZ8iurdT0IkaBNBC+ca8r7TxNtVBgEkOwekPnVnnLgiqU1SUv41bgvIBZknHXYGfMvCvHet+EoWVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SADPR12MB140239
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 85BCD40008
X-Stat-Signature: q8wt6pjm8b1rg3mtw96wun3nyfgcck8i
X-HE-Tag: 1795381954-547384
X-HE-Meta: U2FsdGVkX1/65vyfcDRckJJYZMGhgOIU+x/Hw3tUDg8kvJUgn4pXtN3dYNekQG2rEtSrzHJao5YLBawxoIyK84U4pINki6vOG88v46LEYSj9fu5H1n7zR0EoZBJ5jzueilPigpkKMr1g1s+PXj0Y7ECZPssd16LT5MXZnNaylApPFaOQsoX+oDVBJdC0eB7WNC6f0aL20mmwH/Rfwc/Ph78hY7aKmpJPme2qmxVQwo4L/fXIuaKAyQOac7tjyz+GvwC3OJMQiR251cHNwb15Hqkikiuj4UCQgyeE2t939kWLcEkahhXtE8RD4BhGRuz3U1JOIYbYV1ZrCN8+HVLT2TGMn3jftqvCHJMt4KnlSjb+6pgwwoHL6189KuQXDh/aVcCtUg4rqaNsds7oBLcarBH02sq7LBKvaMs4p2ZiaLjk9g3yGObzcJ5yGY5oXAlfGd+vsLiZ9sYXhPAgOkEMxdQTtzn770ekF8+/yFRj04g0ko0ldZAZyHtd9J841PDQXVw0E0bFrwy8uZYzVhvMlS5KPp5dy0H4mgwYMGjpmgqoNCaZEbeH0N9KgztPYnapeDhUeTFCcW3a561CKsg40McFiCwz/o1NRcS8BbLv8hgOl72uYGAidsLf2+lQCNLJQYA5rTp8YbJFp0wLUOrPXgjrreR/2XExNqDLR9SbGPVUTTOsp7n6m2J7ortfbXikgJ/Skpx9Q8KPN5NZuR5tT8qjPOG9XZ/ut5INlX2L4HpOVQf+aoV6BDWV/20fMZuE51L/pqFcdP4M0ipIdBrPxQFYZbe2U+EpxvMY5IonSoQaXMZlQc93lm9TIGqigXsa3DV/99NjYX1kXH8UXssu6YeppiUM6beHWlR5uMLILF8dAo4MgBfyfOKlln7oEWSE/JKyH7QVo+Y2r3meAf2u9nl+M3Q99sz2LvC/l2LYBm2JWcrkuHxZeExqZRPohV//ZGcruOpTzHNadj7YMUw
 4wZsuFGT
 CCsoGQG6yQv5w0mwaP4gKJ6nCKGKA7zLwN8RNPNXD9oKMGCyy9FNGfHi/nm1xyJBgAKmlERoMWlnJqyGZv9/kCkdofrQynEW+07W1+grq+FBcIri9Om8nJeuTN/EDwmjjvJsB4ms7CxWEa5yVS0Q2MgZQFadIGPNL/ZsTNVyjtCogDPSQJuQrtAcmP+PoEEA3pwYkJ2JmAs8soMK1/o77OgFPflABtSjYhAbaIh0m9M+YITE0QOQVGx6mD33y22NjjKoBneYj/fAlHVG4/j1LHRspXGuKNnt4WqhzrdGtdIuc7NVWF32XVG4jMMKTmSSa9ztjkSXQ/vUDdhFr8nJ6ZEHfaGcbTnc59Z4kjSNgTjFx1PEo5t2ATumG6eT4S9N1+0egG8EndbprgazIfP49/lgGoGr7Eud/14jEA00hU3u9C2OfUIR/ddUGP8nZKx11qF4jCtrdkLdKEVuRYZPSYEa7MGXnN+/SSi+dAaIBj3yXNQNCA3kmviiImxLIPtmvOBVgJjxL98gWQC4pdbLKPsbcBvwNoIb463TGFxozY5CIPtLhL2UOANY2+24ExNwehK46Jq7I4Xh8olj5EUcsSRTPuLStmojyZOzK5cpQSKAhmenQoBkvnVqW+4vc0ze/STsZPz9Ychb9vcF0PYG7dzlXdFCf4ShmRRKFqFOW3pJHeAp6iiNmtzy5gBvX4nQgmThAUDlAiSlskQPEsxaHVlHXdbrQYJC/YoFEFrFaGIqeL63htkwEbAe//Ss63AZmVyioDCFHSmwsoIhTFDcJIB0j4f1Htg5EZz5RVB8vhF+U03rbXVmxq9U5C5RDP9U0jSKPjQsMRn8o2TCFq7H9wdcecQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 02:11:31PM -0500, Gregory Price (Meta) wrote:
> On 2026-11-22 11:51 -0500, Yury Norov wrote:
> > On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > > This is v6 of the Private NUMA node series. The series falls into four
> > > parts, each building on the one before:
> > > 
> > >    1-18  mm: introduce N_MEMORY_COMMON
> > 
> > I walked through this part, mostly. It looks like you can substantially
> > decrease the patch count if you keep N_MEMORY meaning unchanged, and
> > add another type, like N_MEMORY_NOALLOC.
> > 
> 
> I don't see how this would reduce the patch count substatially, you
> still need to convert existing N_MEMORY users and need to differentiate
> between general purpose memory nodes and private memory nodes.

Please check this quick attempt with my codex. The patch count is reduced
to 52:

https://github.com/norov/linux/tree/private-nodes-v6-n-memory-folded

The brief summary for dropped/simplified patches is:

02    ->   dropped - State helpers: no publication/clearing helpers needed.
06–11 ->   dropped - Migration, tiers, DAMON, scheduler, stack locality:
           existing N_MEMORY checks already select ordinary memory.
14–15 ->   dropped - Hash distribution, kswapd recovery: existing N_MEMORY
           counts remain correct.
03 -> 02 - Common-memory state: documentation only; no new state or sysfs
           attribute.
05 -> 04 - Interleave/tmpfs policies: only the three-line weighted-interleave
           hotplug filter remains.
12 -> 05 - Reclaim: only hotplug kswapd gating remains; iterator conversion
           moves to the reclaim-state patch.
13 -> 06 - Compaction: only system-wide/proactive filtering and hotplug
           kcompactd gating remain.
16 -> 07 - OOM constraints: only capacity-summing intersections remain.
27 -> 18 - Private-memory state: expands to 16 files; topology/accounting
           users must include both memory sets.
31 -> 22 - Cpuset handling: requires ordinary memory while preserving
           allowed private nodes in the returned mask.
44 -> 36,
46 -> 38,
50 -> 42 - Service states: direct updates at boot,
           online, and offline sites replace shared helpers, increasing
           duplication.

The new N_MEMORY_NOALLOC patch is not split intentionally. If you do it, it
would probably turn into 4 individual patches.

The more important thing is that N_MEMORY and the proposed N_MEMORY_NOALLOC
is a disjoint, contrary to N_MEMORY and N_MEMORY_COMMON.
 
> And N_MEMORY_NOALLOC is not a good name.

Sure, I'm not attached to any particular name. Although,
N_MEMORY_COMMON nothing better to me. It answers the question
'what for this thing' even worse.

Thanks,
Yury

