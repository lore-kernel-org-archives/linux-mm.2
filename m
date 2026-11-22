Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0FC606A688
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cr8yLoOX
Received: by kanga.kvack.org (Postfix)
	id 69F4F6B05B1; Sun, 22 Nov 2026 10:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F2D6B05B2; Sun, 22 Nov 2026 10:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8CB6B05B3; Sun, 22 Nov 2026 10:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2548F6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:32:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5961406F8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:32:24 +0000 (UTC)
X-FDA: 85463146608.24.FB6DEFE
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	by imf18.hostedemail.com (Postfix) with ESMTP id D54BF1C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:32:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=cr8yLoOX;
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.62 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795361542;
	b=sQAEQoGEvlxyvMsHwAMIOcdyZHMGoNUMuAz1TDrx4N7l5Ob2EPs05SI8ZFX96GzC8lEEh6
	JzJhjRk6hL/3VSS/tkUaXeB28PyGFIZck3oDTkKEYVzwUJPq83ANbyIvt7hVUBDtjnbsjJ
	+rL90pnxF7NP5nXK3oA5hZucSW+t3Fw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795361542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
	b=WpHEcTqfQ1MH6mi0N9bQ6VROJrcxDn6TTbpMn0Xa+XLzKeqAQ/uniA8UYI0NA3GfbGZ++h
	mbJ0IPxJQfmxGldKRvZuRQ4JkyEWJmHnDmRFIadgu1Ao4qa/ysh1JbomnXComUKS2lrWYf
	GF4EBKmAaoKKfMsu0Nh2Wjex2NCG1fo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=cr8yLoOX;
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.62 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EHDbKitQys4tuIJDtOY5hUPO4Aj3x5WFLIkuQAlApmE2Q4b3YqB9ZH0lsXrMWpNWZv4NiqHhOCcsrGr1WeDorLAYdBe1EzhEuzo2hwf3RVevCgsz1wlZEVWlQABbgcVrtJ8r1wQqeHnlPLJd2OdiWxyCZjL9Go+lUtuOSoVTC0G5YC0SI4AJiCrgdjAPFdMQHWKwcwbNF9OnQ5yHFjl2oO8pdHHQMvJl7Ia5UdOGppFcn48kN6aHfWbXqupCUbc1C7Fv8api71Og+633PRFwVKA1tguNsATBHjC3/Jq9NMFwtyQX7ElH6E9N1POgmukkKV0hqNphXQmGmk0auArSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
 b=G5n5JBi3HZk5TpGj4hj4HR3PdWpu1EqeSUnhBqlDdM8kTUi8QzX+4jKpS5z3HihfW7cgxr9rTFIcU/mtuF7qo8JX4b5ixE3Y796dIzL/qDhx3kXMeZHAltsyrGLj4c/1zvnrE2YhlSjtq9bDac67FJJi1D0XOakMJdgW87uYiH2xI3NAvHVuTZpZnMABCBW/QcUyisX6Tko9D2YkmOt3rOk2oWeLUiSpJZY/LWNCCGy+XABBr6SAiD8/gz+eVZgL496UwaGRxc9KVynJchUZ6Tu/tZMIR5hYe5X6v4Hh9MZzuWijV4SRMj8oNUq5A/Dt+/niX22GJOel+IJ81JH/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhMslJCGDuB5xV6P/V/CS6QxivMchvG1o2S2D3SeU7Y=;
 b=cr8yLoOXqwaA1c+Xblj201hZ1aXiuuG6UWySgT+ibVPblnFFwvfbrVnxM7sGd3KkhRmA2335SaSiM8fZqoNrGRi2RbSq/mgJHcohbQinfFYLUSw6O2nnFuWCqXKi8ZTDrSJLjpTIwmTLeeXEt3xlYsnRA9PfhT2aQyHh2pjEInlpjG1OQhcURJAY26uUDk94yMcwxH9cHtKmDxRRVRXiurMMIfz34Ge7WZvlu4M9eBLogajqQTY9a1QHUrmdfgVKr3OLxPARno8sqbFL3EjM7/qRiuhvjoB8FqpCZKWwBzJIqxACXORlL9mu+pndzSpz3bgdplgOAMfYw18VkOyLxw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by CH3PR12MB9284.namprd12.prod.outlook.com (2603:10b6:610:1c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 15:32:07 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 15:32:07 +0000
Date: Sun, 22 Nov 2026 10:32:05 -0500
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
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
Message-ID: <awMK9V6TbU9Xtzn9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN9PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:408:f6::11) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|CH3PR12MB9284:EE_
X-MS-Office365-Filtering-Correlation-Id: c6485a54-1825-442f-628f-08df48adc424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|10070799003|1800799024|7416014|376014|10067099003|56012099006|11063799006|4143699003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	LadQk4uEsSebAaX36T2UMlD0k4aavvFJnGPyxq+sADDdoHz7h1S6cTm+9lwN2JuY+RhbZsAgBtH6HMrwaEs/1qoNwhCMXCD2HnT3piotu6CJhWi/zGa/x2kT3WvqgBYvrCRtXMV5byjJlFSa1Jfz2Z8Es8KqjJ/gP6DZ2VArDv3yVj5pPa+ZBvrppiFRCswwB+ZHiGKW9YWzBKGuNP+swVrsTET4lfSO/bT6JGwcEJAk4oAymrrQuP4kHwUsgRG0ONuqW69rZz34qgY2VzJiBrdY0IloGE1UIWWnNTM49Lemtc0UUlQ1LWF+KQtBZLWotV+9HucWijaFAQeLEouCDhaBiHWDCbkPaIYs1ijCLrdLfbpQWCHOIeZDVBboKpLNdpwAH5yTbh9XuDiHQjnOa52O8UH8hVIkGKvO4rmzHkJ4zuxhAeJV5BVjZs1dnRrbf+Zr2yALfauusWyHdhBvzh8mpkvQhguRY1p1v7/SaRa0p2DHBXmd805eyd7d+XI/367SUORKBEhSqopdRKVQQ+s3kmJ5FGjbepuputL8d/8bDEKKf4r1mwN+speML64l5Uja4AhFfhfUX2fQ9bcmlGAVrQbpl3yTTwZajpRZ59PJG/gbGGmT9vfmPokHenri9636b4Tgb3WBRlCk3okioAUGEdJsQCDwDgsbtAGC2bA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(10070799003)(1800799024)(7416014)(376014)(10067099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0878Rh0OU0ASRuFo6sTdoF3SxBqX7ikevLQHYzhknEeGzOQ2B2i3oyhkWmcB?=
 =?us-ascii?Q?vdC0RV17nq5Ut/rsXr2QZcjCnVcWfnPDwx4CE/S/3ITrkFrSxtRIVb57b5TE?=
 =?us-ascii?Q?12ScIl2aqKaC61hbvkut8h1CScZIOXaKEOSAPZQlVJeBESw1+J54nNhRYJpj?=
 =?us-ascii?Q?q+N7YQPfjLLtxxFDpFRzb7RZaMPPwn+ImCVVh3yYk0zz1skuph4r4OrNDGtl?=
 =?us-ascii?Q?qkoqiahw6e2odkS6anbXxrt2Om8f/9pUD9dTILttqGt9LbpROxJ2/A+rs8qB?=
 =?us-ascii?Q?skcevIIA70HVfuwop8HFzHVfAmhOJh4uX008ShwOtG0uBJHCj0LkE1B75U4A?=
 =?us-ascii?Q?ebER04WVfRArUCB8JwqdTJcNJXiX9d1MAOsYaEIbQts0iZodjls9ft6wDHFH?=
 =?us-ascii?Q?r6P+wOoklKSj/vKZOZpZu8J9O6dY9tbmeo5yYfLC2K4WRf53iCXXF23bfd+9?=
 =?us-ascii?Q?tIFtYp/soKOKQydkgswzkr+ZfFk5L8KWagu2ysOvEfxlM3ztcxZDMt9wPV/a?=
 =?us-ascii?Q?kD1BPzvOZDDVr8SZPmJ3hEMWqLo5Hwe/zE+iBtxu2MWiZs7YFKFntevkZ/A9?=
 =?us-ascii?Q?p7RCcL9+gTx8Y3GetF7l+gaEZUFd3mgEyTRwUdkMKMy1AXmt7471f8TFYrAE?=
 =?us-ascii?Q?ppqEIDUMRaQinZdGh1ahBy2iFSvmNh5qX064NaVJo2nh3I66QQmSzAVKzYHC?=
 =?us-ascii?Q?h1h2//nE+Ngekq3CW/h9KEsqk+iIvzl5cLCZ42JTQsbpDBnI72HIChThNP8q?=
 =?us-ascii?Q?7rczyuAAqbWQo/bNvfd3slvoGpWdsjtQBfjyXmHha7ZSsdmPnqhO70FlNKLo?=
 =?us-ascii?Q?DxPExNWZL3O7MPko9uFk2GpM8EsiD/kdfJtC1ofMNInyivne/bbGTSmeeiif?=
 =?us-ascii?Q?6Gg7r5MtxZ8tjLyV0WuNqgoEHbohtKw+hpHTortmoZmsTVnhcjvbg7Lm9HL/?=
 =?us-ascii?Q?dFVu0Pdgj+HSAbUj6Y9zY1DBu0lAdO16r94YDlXyd4TiPnHhK3QOMiMNJZuO?=
 =?us-ascii?Q?icAU7Udp7fOt7HjE2sFh1hVsMbLTRoANkXvwWs6QKFecXZO7DSJ3eT490eHY?=
 =?us-ascii?Q?QDnjQ5uCNL+Ao8ZIXN1qwATdl6d4j6vswBAHClf5u5W1wcyA2dCm7+/mXrDe?=
 =?us-ascii?Q?8l4RUOVPDgu3N28TZqS83YQ27xcjHf2Yb+ijh2PMGCtZpD+WX6XdNwP/1Dve?=
 =?us-ascii?Q?JgXMO5RnzA8CcoCenR6pxc06iEAxz71/MjWF3b0oXzaMKWDblsxxvi0qL6wk?=
 =?us-ascii?Q?suYN7jZCmtP8qRBLGWqXe53Ug4Cib3eRbS/Ta4K5zjwgSbKzRZM6axMETgM2?=
 =?us-ascii?Q?cPDKiMuak1fpXPue32bB10pQn7QbxG8x4LKK3mUC011F2mau0n0MMV2OehIN?=
 =?us-ascii?Q?pal+m9ZylTSgCp9ICXUOUiMgAjacNp1DuAL5iwETjyo7fiCsC/qbCN9T/wpV?=
 =?us-ascii?Q?g1qHrtgXxOuaHmAXoVHC4sSB7hGeNfd0gDvODHF17K0jBEWnNdqzAEO/5ZWO?=
 =?us-ascii?Q?PguKAGxJWxeP2VTmK69UWOvI7hIWQQSbh6PAjuWtGlMY/JQy/91+7SGAHJnf?=
 =?us-ascii?Q?vjvkTx0LQVwjsvvg2B5FKpNt+c9DmlMgWm79kZ/gKUY3O+/EdnWTD1Pgp4Gq?=
 =?us-ascii?Q?pjLJ4vb+cGoeqVvNk+Eg72QSgLlZSW0TCWAeyVkAxZnoExgRM3QCTiOyGXdo?=
 =?us-ascii?Q?jYlbLkU89rqfHTdlofrWERfbLIhveKByfPLzZ3P/Og8PCd8Y5LTrHWML7ZH1?=
 =?us-ascii?Q?F2/DTg4BcCxL1MBVmHECkDpT6XYb12pDshSJ+5onFzgnC8b4MOgR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6485a54-1825-442f-628f-08df48adc424
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 15:32:07.0533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rew2IPNPi3eMjUW2rOx/D54VR1hE34BYSZEp/L4/4gyRLjUNdp187rMrRSfQ73nncADw0FzzNhR/N3gz2QevhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9284
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D54BF1C0005
X-Stat-Signature: wnxf9pn7j47hueonmisgpygjxr17oqpx
X-Rspam-User:
X-HE-Tag: 1795361541-724081
X-HE-Meta: U2FsdGVkX1/QwQXPPoyUnFIloqWPjThDQqhEVVzZNqkeMnWtOORtF2LhEYkdjO7/BolH0TniqXwWQM2cz992zWfFqTrR1avAwSrxhTlllMYIg00Pn1lgrEDInubFsKWsVxTW6u3/d/c3d09iId7eUcv+opLJb4+sTSB5XdvgLeZO9REvpxF1V0oYyFTBrRneUwCgVUzXbuZxwLqhEq+6sv7XxWKcpWCin66BL6WV/PtYi4eGUYi7yP4fsNNAS9E1ujKErbhVeUABhOJV165kIG29H0/cFCa2blNHLCAGKaZZ+q7s7Sy2kRle9V/y2H1J3XpcMwUa4BpmW2kpmsfZbeEBjdYNzBQ8gcGoNy3doKeW58aUKOn8pP4b7ITq88Wzq/ya8IByefBleths7+um8xNItQ2y3dGEaykAPOdjavqqDZfxPRGyYOKTm5HWzqB0+p7GbOoIKDzdnpCtGOuke1DlkMdL9FKzvh5Vtl/mzzyKYSjaaCqkhKEb9j4vf5CpQ6jAA1HowWq3bK2M/ZsXDiljMoNRC2XAK8Cg8ltwJwZC+Q6IY//mX3DL8oJrLibOKtn70W2sQFnK3BvbBgVq8562eeUF4wLC/E5iOvSAEHYSEEv38TMyqRwLagE4OKn0WMhCUsxxArGqBVc52K6t5yjBJyW4sX7IWKWt6iPbto64b5xnlpU0vwqD9wtKLzWQeAfVnYFqzgUFtoL/aFSgchWT47zSCB1ZCaClkuiZLD8v6qJHMI7tnK9Bg9n3k6zxJoqoNpsoQoyq3dvRVezYP3H81wdA/+aMtV+2G042lS4l5nQnWz14Ds8ceS7ErZvdnCZQmk6vVOV4Qm02yuMqw7tilRvB/E/oesgfW6pi1b/0JtuBBUAbl5FdxRcGUAH4CvkxuupYwvOCA8KufKV3QIR/bcw9L8SABvkj/VPhgsjfRx9PeSTd2ZJgiY9ddIKB98kARPEMJpzsqEO0/L7
 CFRrSQs/
 7yrzLPohVVOOrgZbsLNGvhxN431VgxmoJspnYuPHvanwmLFMKnv/q//itf2kl9AUKMRLV3DfdAL6QN0zIOTCDe2xvA8yBka9UuabweRIhdbxltKNwdD/m1qvenF6whQxc4R7lblYREyq+r9Up5HsnLkg902HOdP1JjX8iK2QX6qXaYcofnGYxzEA1EfERpbDIo/PUDqQICmLCZ06j0b85SbUrZCPYwtO3ySxVDglArZQyZRcOUwSmh9em3eHt9V7iOParkiHCA6BhBIT9HrS8vWv/TMo6M7RbJCOoqzevf0/OBQg2IH+84nmExsKje4x0CgpAgOxpkE3J76k/KpNxJnGpCWMD1uZQ1osNY9Rp1KcpAddvOk/dSZ6GYlXc2QFp/zQgdCbpqxPzrkGhSyS3ITVHFwFHBjDUGxXuFqAVerjaWoSe5eMhU+dt4lGMaDU+XF0XIiRdif7wdmDmPjmul4T4eYTAuJ5qtR430knOcgtoLjUkltjpP69rKJR4ZQDL4sWiSIoordK6u1dr8kOdZFMwFSqMwGKv4rpsrEQ8MGVzGAD/2DDmtklI+bFNfc1dse35VIYmaacR67Fcik7KMlXkSMSuM8UH/HqBkTgM9oFMD+Ir+4IiCZub/aDy7OOA2CK0ehMzzMMBhTpDtIBfmS2P8NaMlKYOiVDrdjYVr86M5T+FTQEi4cXEBYyKk5eI1BnQ8bJvTVBvgSomJvMVmhJQXtB1WM9GSi3aClNMHqOYhwgjUIQMytbFye35LyELQz7sAFgmRNpT1et8RCyTg6dYF4ZKD6ejkaKWdoV3Dy2TDjkEJFIR1Y1mSx3W2ocP+1tsjcEA30mv1Z8jop1oKPxbrzNGQS08d+ibuLME2VcJpjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Add first_node_state() and next_node_state(), so callers can walk any
> node state the way first_memory_node and next_memory_node walk N_MEMORY.
> 
> Add for_each_node_mask_state(), which iterates a nodemask intersected
> with a node state using the bitmap intersection helpers, without a
> temporary nodemask.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/nodemask.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 607373bd83ee..90bdcffa42ea 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -411,6 +411,11 @@ enum node_states {
>  
>  extern nodemask_t node_states[NR_NODE_STATES];
>  
> +/* Iterate the nodes in a mask that also belong to the specified state. */
> +#define for_each_node_mask_state(node, mask, state)			\

for_each_node_state_and? We've got for_each_node(), and we've got
for_each_node_state(), so let's figure out consistent naming.

Did you check the codebase for exsisting candidates for this helper?

> +	for_each_and_bit(node, nodes_addr(mask),			\
> +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> +

Please use nr_node_ids instead of MAX_NUMNODES.

>  #if MAX_NUMNODES > 1
>  static __always_inline int node_state(int node, enum node_states state)
>  {
> @@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(__node, __state) \
>  	for_each_node_mask((__node), node_states[__state])
>  
> +#define first_node_state(state)	first_node(node_states[state])
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return next_node(nid, node_states[state]);
> +}

At least the following {first,next}_{online,memory}_node must be
switched to the new helpers. Can you check through the rest of the
kernel to make sure all candidates of the proposed helpers are
converted?

>  #define first_online_node	first_node(node_states[N_ONLINE])
>  #define first_memory_node	first_node(node_states[N_MEMORY])
>  static __always_inline unsigned int next_online_node(int nid)
> @@ -481,6 +492,12 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(node, __state) \
>  	for ( (node) = 0; (node) == 0; (node) = 1)
>  
> +#define first_node_state(state)	0
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return MAX_NUMNODES;
> +}
> +
>  #define first_online_node	0
>  #define first_memory_node	0
>  #define next_online_node(nid)	(MAX_NUMNODES)
> 
> -- 
> 2.56.1
> 

