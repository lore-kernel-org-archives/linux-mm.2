Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9333C606A690
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=tQ6crE2t
Received: by kanga.kvack.org (Postfix)
	id 79D5A6B05B3; Sun, 22 Nov 2026 11:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DF86B05B4; Sun, 22 Nov 2026 11:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE706B05B5; Sun, 22 Nov 2026 11:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 383706B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:42:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B25D7806C4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:42:00 +0000 (UTC)
X-FDA: 85463322000.14.811ACEA
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD85540005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:41:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=tQ6crE2t;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795365718;
	b=NWOK2/phf4v3EANLOfIX2yrM0NCgVzXZdviXTi0TKORkTYDfQNgb7efwg345E588RmMjIh
	Yi8glGu0gB+iVYKSeH8A25RdwNz349ebTxIeLGnkHtSnmtHfKXiKwA5Wb9yqj3Zrp7iGVt
	B8qwCm5gnRQnQvcsHYGtwxHGJqjckxw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795365718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7S6XFhmxf3Gf7Pqrib1ONF+kvGoPjbXrdtwDoFVe2jE=;
	b=arz6qdSdSkUl5+y8RptjX+0Dyv4VzhBdFcl7M6y5j4963a6MKwqWLu0nWWsejpfAq15Zaf
	hrfLelQGBlCNnvdyiu86A3sRkqb5tsbA+WVxw7qAg0l/uLTBu9cdBQb5DAGXzgSd+0KsTI
	YXho8diL/xOHdn1U/lAbySjzv4NFnKQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=tQ6crE2t;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9GoXIBXies6S/At6fBVZB7JR5pr9EUsGR0Q1heX7j9bkK4UpyPhxkoAG8dWtxQ6vCF7BZ1fIpRnmrxMXtHI9x5gZGFJYE76HzF0P7ZGNeLSaGay3UrIC/igzwJz4TwR+xI74mFj4zNtX8/ShXdA1rtzJ6OjRlWbdrUM3eueuQialfIKKKB6a9EfyxVCalZXjkFWVGbaAvHPDSDQ4lrhOyT1BLwCtmC/Mhcj8XwEf+thMrTCn2mBo/uHXHrhdl8FTNv053vjDNoUWzTkGpK/faoOBtEL2rIFG8tGI2qm+qTnPOSPufk1BCh7usRlYixoAU7aLoIjHxxMTtBkOVJpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7S6XFhmxf3Gf7Pqrib1ONF+kvGoPjbXrdtwDoFVe2jE=;
 b=uegs3pP080k3FK1F2m8PHWxmlHp8tXnxyBWFsGBskV7P8FOEwoRBb9R/K3GbC50DFSzGWEaXVqjvVZJTf92V8x0NLfKaYJWyctuKGlBF/+Qh0oPWdmqBiJF0N6lK/IxGTUX5tLwFBRentTHooRDA+9CcPL5/pXrGjAKQP3F2PMPeY7/i3Z86gTJ4b5hGJ7Zi+JLZFW4jCYNCloFupOHDTjHyLvTMcVgGJ/kpQsU3kekUEF3YVdFONDIrj+SJJLdOiAuKuVrDN759fMCOQSfZjLkzyQQUupUft+QhlLgtFtm/Ik8T+sdib0fDNt4ystzt3SP6ywHDzHqgOz5N16PSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7S6XFhmxf3Gf7Pqrib1ONF+kvGoPjbXrdtwDoFVe2jE=;
 b=tQ6crE2te0DyMSqxYXEv21lDACZgsNGsQblZo4/e2xXCYE/A7Uc4ErH6Txe7/yU5JOpHAEwAcaaHODlEECFBFVRsEIn4HeB/ARCvoJTYbT1ARkgwipRDHSu9CcDLgc+wNFrgb5LsyhjRoP0lA8FdxuxHvY7DXW3U3vXvYRgQuvQrxJEyBl3NXI9s3IzIXdf6UMiUjhrCU5BMCfS1PuM520Ccyolmhx2nCIYdEGuW1GT/TojV14/vcgskUaXmTn669nczGgjGhO8PVQeMKHv9PzdyQOO/08Qfbg5IrMjowxIIcnOArZ208pwwSa2VlQpBoOobaHSFKZHJoUQqMaRcJw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ5PPF6D27E3EA3.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::998) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Sun, 22 Nov
 2026 16:41:50 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 16:41:50 +0000
Date: Sun, 22 Nov 2026 11:41:48 -0500
From: Yury Norov <ynorov@nvidia.com>
To: gourry@gourry.net
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
Subject: Re: [PATCH 18/60] mm/khugepaged: base the recommended
 min_free_kbytes on common memory
Message-ID: <awMbTMt2M876rTy9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-18-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-18-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN9PR03CA0494.namprd03.prod.outlook.com
 (2603:10b6:408:130::19) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ5PPF6D27E3EA3:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eb0b944-f344-4a25-a445-08df48b781b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|7416014|10070799003|4143699003|5023799004|11063799006|56012099006|18002099003|22082099003|6133799003|10067099003|261026121527099003|261102123227099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	A1awvGV9yGDIDArKdZ9wKvRvYaJEVbu0gnwz/yKNk9hsJ72uRJY1T4eyjVdriOZB1Oc7Dav56P93wuuQsgXgyHvWxo/dTnPVwhGAA4737sjCYg2wIDuHqm3hI9C6Vhoqdwcu0fz6tul8/3JB3Qtu8MgB8jmnxTxLAaEBaZklsIvV8I1aDDGSQPrQmMbIsXX/t1oAovGi3rq0Q94l8rgb66iC4BsDvP8vSZLaoqU6jgJyMw+Hd9Ml/5eFdAQbPbW2nh4YcA4yp69C+nAU1rVNEvpPXUIR3plPG8CJTt9ujC2IJamBeug1lgmCinLBb2JNToo6+0cTZfS0DAD2EVwoM9X77KjoQ9iK4BWEcq0k4qFFhJH8CruW8/ymk327fiW/j/ol4FOjAirA7uS0mcQnNx4BIXLEqJVYfvL40DMZKoN1i7FnqW5nSO3QUp9KHRCj5H8bpqn76DvJQ69BdFQYdiQ7Vsw5gVZ2SPdnkZVZ+H4aUTMCZ7LvTX7YCSmPFVdx6C0OG8SG0Zo65hRMJo7OXTJe46FGRB3TOn9E0kjDzm2KBmTXs+i7/CXUCHWwJ9nIe7GbRVlSCg6OfgqKEmqBwbVpi1n6sr3frOMrsYHXKxznocEji+yz0M7UH8pR+Ds7KZcryvAOsQ5NqadHV/bfgOr7v8W2HS5dcwpV4SW04GE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(7416014)(10070799003)(4143699003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003)(10067099003)(261026121527099003)(261102123227099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Pvdnyt9BNcdrGLJx3vNVWlvAIKS4RXJyW8M90TbBz7yjAbmxcumcVpjJ2KT?=
 =?us-ascii?Q?FuexK9NAz5ylj4z9oIOItlW3UD6+LhcO977m7qPw9ZY4uepX6fD5FbrY33Lg?=
 =?us-ascii?Q?nXQWuGwcc6rkn7ORgMKPrV8iEBf9cX5QU3lLcW4vE0BcgVi95mpqVoRa6uvP?=
 =?us-ascii?Q?tkkWqpURD5oJ9+FajE32TB1d5NwJx7GSdZ1UlHqcaL/bOQmaU/G4+J2qzXyg?=
 =?us-ascii?Q?2DYK9r7WJ1ciWnaYOsHFGcMq6IhHtx+iG0nN8YnePVY95FfaVPymU1rNXdd2?=
 =?us-ascii?Q?o0JQamS2OVbHFRtqU9I2naTMb+N06bjLZEKyiys8Oho2Yg67qbm3XQaoakj+?=
 =?us-ascii?Q?MqNZbnZ7OPVjmOttUc88MKq/VSkPS7N56q1KJAbuh8vKQ9X3dvK0Y4f3D/6G?=
 =?us-ascii?Q?H5xuuFl4OTosQilusd0jwyprypPqwl7qv8YA4rDJpxW45+CkoNsbPi5TwCef?=
 =?us-ascii?Q?DH0byes/sLKYOHVmKBALWhzSCra5MqVoDIIpD91k9ok0x4keh3ISQ9foM849?=
 =?us-ascii?Q?0gzUZ5Pm258KfUx3ZY/OtPsWNM18ln4pSu6IMX7NoaDr/zUk8zDQ3mcTCBTh?=
 =?us-ascii?Q?wfi9ie9+3mjBKevU0TZna+KVgWlA6uu2BoiBgqkNS5CRrwmDwjfiZtKFmS8C?=
 =?us-ascii?Q?LJhpNRN1OyD43HjrisAbtSissXqmRAoyhdPNHEuRAHNYO2nhcYwuc6rSMPm8?=
 =?us-ascii?Q?VHEIjkJBsLO9mcytdsXXy6sH8R332Y19SlGaUWpszysMSdWVOuIv9YmqYHZc?=
 =?us-ascii?Q?D6XFkLdgABGUz1g2ZC6t8BMoBA0xLEdg4B5hh9cx4Y7TAD7p1Mso7/B6KFRb?=
 =?us-ascii?Q?O/AUQOs6JxPvwgF3sT0+B1Z5phJEKFyGFXRKK1RQAEC69yqs3bVZF9jcfEmO?=
 =?us-ascii?Q?DCmwLapENaNON72VDM+oetzhF1NP6aS5GF1hmSdC+RGLLM6p5bA0+rStQI7z?=
 =?us-ascii?Q?suJXz22UAX2CZN7Z3qGBJN4P2ZGZrjRSbUvCNtQE6crJFqpqedXcm2CQ7DJR?=
 =?us-ascii?Q?p+Ohg0owUc4Vxps17znT1IFquy/UrUOm1eMFPMJsrPnBlaWUKODQ4LoVKLEK?=
 =?us-ascii?Q?zoOU2oprtgB0s58ViR1IOCK+op+27yGhiafEbf8bxy3bCCeHijTflPhb0Ie5?=
 =?us-ascii?Q?hTvFu0MWhYK4GX/xGZMT0DpabVEeDh7Uv5xRt+/T7qb5VXuEq+unhyTp5AmB?=
 =?us-ascii?Q?CmJfWnQC3olJicH3qwG5zyLQmhFMdgNbDXI4nUa+bysV/zNvFn2u0odLvDIP?=
 =?us-ascii?Q?TNjMjAM/2P1JTwyugaW3lhTCGzOc3j4f0tKNT4GlsOqtWlnbKfyGlHalkZH0?=
 =?us-ascii?Q?hbrfa8xRZLfp4QjDFE+Nx7s7N833BQ16q6rv3Js+rYeO4HCiLin74o6A/ley?=
 =?us-ascii?Q?IjxzUCa6dp6Q+Ha+EpO+CKDHRMd4n/Xob6rcyiAqAAmbBPukjfeNZZVPL83s?=
 =?us-ascii?Q?efi0W2QbTO0eIppm3MMrWEIT2wD/1EVw9NGRBr7DPlRqE3PS6KBr5IOwtZj1?=
 =?us-ascii?Q?ZyPtjXXQ5erNyxMcN8J0i14iT5JURg5eNvxPsX5Dsvf5L9Cm4Ttp8JVM3YV3?=
 =?us-ascii?Q?BNoT+t+FP0hjMU7pnLU+50arPp9iVluG7bxgpLjE7SJHg32fqpr646VC9FK3?=
 =?us-ascii?Q?xIZ+g+RwtnLGLwGlIsMuNbo+evwAWd/rAxzDudfBaHcXTxYM5G6V1Afg3Gnk?=
 =?us-ascii?Q?AHPTy3vCllUgDn45FegdZCMSo3F/PjJ0LX1azaP8svqkMl8qur0Q7Cs1t9fY?=
 =?us-ascii?Q?zWdCGDZWqsl8hCwLyvV0e47PJHYYcA92sV2DhSaimx7g/wuyP3EE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb0b944-f344-4a25-a445-08df48b781b9
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 16:41:50.4667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGOqd6egrsyzOzwmwtfY4Qhu8Iemr3aJvBVprzbiGWO6kAUQ3zIW2eCH6ARwPmuLHpfzZgcc8cFGpR/9TlUZRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6D27E3EA3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD85540005
X-Stat-Signature: 5kzjbzjshmmd1dyr8afxxkejtma9z7pi
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795365717-288394
X-HE-Meta: U2FsdGVkX1/uLEPr3rD148gSiaKo1BeC+21ajnMZJ1nVvzj8Hgf7T9/POOpHoODVGOIMNC2WEpNY38mSYP/eChI57RgqHDRMsCZJd+zbHwFuVVvKKzybrW7f6NqLLEtj0/1d3izva6QcgO4Zy4plX70lEKMLZrlhk9ObdYsDxvy8Z17yfGQM9i8o6BfFsd4k8XMCkCHedtZQCzWGePRTbxbORGG1XjNrR8LgYSiYNFLpv6Et8n2CyZIRWIyfeQ5Fk1S0TK/bKcYBGn8iQtYRT9Sfgla2rgAdBEDJmBlTSxjHgMr9kMkqzouooY7Alhy2et9PD1mbhA3KyArETVCn6OZVQpiBTcYUg64tI1Kb6nUSGAYRiX16CxIkHGjBNBYcCkqXXOlybXjslqvtCX2weYrPbx8YW6imSoaQvFq20LHle5OwsEfCbZOkGvMP23p6y4z1+KYKMQo/H88dt7hi3Ud7rtWnVvB9YHJXskEsvk682EYTdNDMIpl66RHXERezaN+datuLty56kTPozmbNmL5PcFYxaOqiDm3gsTPHWXQdr6ILreFJRJfKwbjxcwEW4XQdpGaJkWoxbBujoEiJ5guwcf071aEeYBMLkVu4gOLw5i8dprHb0fNkM6FNpz89qYOV8yDvAt85D64YHnNvHO6AoMY4C9EIvnKV6vwSnY6VoyGH4vP6elLeJVjheWIvxYJ2QTIp302Y05E42QXF3mabbhBlFG1UKKb5kNBZAMAJdhwC8VpgstQzMrLZTPEWd31HNFU5uxr5bgyA/gRO4d62aETs3oGJ2I99tNRzxpawYWDDTZv1ZsgANZStLf5jOLJ2fBMSBg1OQIEB/+dBZ1zwpKqKQea2c7b6IuRnXfcqrU8Uy7AJfp0YXkjA9w62miAeP4bev4as2vIcvAgJNsMOdfAOiEJ06P59s4SoVszHvUgVB1O2ik291DjxSrKYfEG2iWIqoXCB3T9vSqh
 nOomUOyz
 I+Wnjot7O+pa9GfHbaFJ0R1dCKBvr+UOPIWBsCqblTF0c1/ggo87w/xlROC9gfDlKqcjwBeXuun9e+X5Jc8CW9Uen1Hn0glS2bo8PxMS3YacFnmZo5LUP/MgyRLIpiMGe3hjdGPusm9IgRHt5IxS280wTjmQuQTx2cgbTb4MAlw5jcNVERvQv1/BsaDPNnAS2SinqXMPTjXnGRGmsIAMznxXrnneIw9N0bpbKjh19IgOhHsatrTi2TyIEUuoqmMPmBztcWdFZCe0iqBwqO1vSd8ng4nNlvGB54UEBhzuJFpsFsXOEoJ1XCPxRQHv7W7TJVQNF92Jhurn9s7Wamf82gLQ34pMgh6PcqfQAUV5UMZNZwqTSO5kwIW9vZ60A98eE/l1FpvyRJnXjobqZwmjyttshPxSgv9S1HBPH9FH3JWi4VxyCdU0DtUn79EzWeOGawaR7BO2sZKu9qOoBgZzHRSlWzKSM7dO7aT1sSN6/heSxMSq8I5VPBhPF1a4mNY+N+ASasvAmInVzMyOYMFIsXRxbJ/2nWcRMRCPgsE5Dlo9cAwyafTefI1f8EogQ87TOpT3FbPX5EHrhR34U1m6TqkjT5c7fdDOhKNQMXipS4YlHy1WCoILnv63/FIFxSbOzXLZTrGhpvHd8zqxIDvZblZ3LJIlWp3kOWHjm+RGHR4kAYorlPYv17ZvMFC8PqctMfY95liiLy3gV2NdxgjUyl1S8QtKhjovN6YFaBa4jPYEhKNmVYyAv1q5JxL5AXHA7J7GNcpZIaVibmztYqlYXakMCFVpBXY/HiX6HLfb3zbR+/sgSnBngf2hFZK9tNGqFMopEd4MEFSGI/ZgyDQXsseOxmetuyZdY++c0lgXcZaLPEDKSIaTBZMGhZFMrdOSA9GmrqY0uo/b8K0pCB/fEAhPsHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:09:09PM -0500, Gregory Price via B4 Relay wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> set_recommended_min_free_kbytes() reserves two pageblocks per populated
> zone to help THP allocations avoid fragmentation. The reserve serves
> ordinary allocations, which use only common memory, so count only the
> zones on N_MEMORY_COMMON nodes.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/khugepaged.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2dc4245814df..a930d99f89da 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -3151,6 +3151,9 @@ void set_recommended_min_free_kbytes(void)
>  	}
>  
>  	for_each_populated_zone(zone) {
> +		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
> +			continue;

This is the 2nd time you add this check. Maybe fold it into the
for_each()? Assuming, you keep N_MEMORY meaning unchanged, that would
look like:

 #define for_each_populated_zone_state(zone, state)            \
         for (zone = (first_online_pgdat())->node_zones;       \
              zone;                                            \
              zone = next_zone(zone))                          \
                 if (!populated_zone(zone) ||                  \
                     !node_state(zone_to_nid(zone), state))    \
                         ; /* do nothing */                    \
                 else 
 
 #define for_each_populated_n_memory_zone(zone)                \
            for_each_populated_zone_state(zone, N_MEMORY)


>  		/*
>  		 * We don't need to worry about fragmentation of
>  		 * ZONE_MOVABLE since it only has movable pages.
> 
> -- 
> 2.56.1
> 

