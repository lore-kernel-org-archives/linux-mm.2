Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2EE606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GQ4jeqmY
Received: by kanga.kvack.org (Postfix)
	id 7D7146B05B8; Sun, 22 Nov 2026 10:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787A86B05BF; Sun, 22 Nov 2026 10:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BE66B05C1; Sun, 22 Nov 2026 10:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6C36B05B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:52:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA4FBC0723
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:52:40 +0000 (UTC)
X-FDA: 85463197680.26.F31947C
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012058.outbound.protection.outlook.com [52.101.48.58])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB6F2180003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:52:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=GQ4jeqmY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.58 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795362758;
	b=mmGiAeEy30SwbXbaxQeTmaoNeYXUtxsFuRaZvfYWeF2LvVEB/m97KkvvSZhqPNFfulsIz5
	CIRtNnk34Un7GkhoVH0oXjr3teXMwMAY08Iq/XYN9tj+Wls0UnKULLD6eZDythDZDxkz9l
	OyWUUWdcy9mzY+S9Vk9G0p8QMW7vAYY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9YFLvPtEP7+As2LJpBoRt/6VCOK5mCPQerzknG8tuA=;
	b=EFwSyH8PQnmDH8WoNdNpyAra8Po9abSqzMMPc7QPjDvkOaw3FdHfYhVCx+nq0/S9XVEFtg
	mQ4f1mtC9noRpYOpmt8XBGCDyLTTURjnOd+PnFZpGcRQkM4dAFhzo4MseBJ7ngWpFUqf7A
	QmdscsApZ9bb6+wfO+6SXVKbpsMK5iE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=GQ4jeqmY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.48.58 as permitted sender) smtp.mailfrom=ynorov@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKmjqpZnP540VtUpLJ5a7Xl96nPY/36nHPXjcmMzFJWQsBpmz5iAcd2NvxC3zQ3NLZOdU8aUTHlrOj91mjYTT4vpNFweNW+XkEBFDWlnSTwZTeN4d7BefWjTPEzIcOp25cdlqUKzds5hPGsj0ajrG96piRuK+pgtFDgv+UovAY4qjOQd1VoqE63l6diUSOb+QHmqa6so2YhAnJ6OTlx6/wpIdodoFHJkX5YASm+dyBt6/8Vy7GumZVnxXFkEsDUHn0aDJ2BHkvdaM9BozarqT1Sd4nooXXlh6JifVan17p7hEO9UAYyqfrps3wQF1WbS6f+qnnMNCWhBXc4j3XFClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9YFLvPtEP7+As2LJpBoRt/6VCOK5mCPQerzknG8tuA=;
 b=yrNWrx0vuUVzmtyVVYhX+dd/qxm+/utrBKRtKmJwscFqgO9qrS/3+se1YVPjfKNfV9gKoZGnk2UvR7LuojtdlZf3mIt/ie7fr8/0zX547k2LeiN/cRue8dsie5SaXfvK267qSFbosFpYRJoJdrDEmhiRgr7/1F3Joz/EcuXyHAwiiH81rCUbbfdnROeXmyCWfOnHXuCeV2/dDiSOVmhSfKGKgXJbpzJAZmSplT55UKtShrL9i7e2JhM5tFLvbV/o2UstlOif8vIDf67wyKeAtSDskpH3c6KlwfuOIwiDajxlTyO85CR2z/zFY6e9iCvNx+4FJ+7KCx2h6pJIOFloig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9YFLvPtEP7+As2LJpBoRt/6VCOK5mCPQerzknG8tuA=;
 b=GQ4jeqmYkr2HW6KOJkjyO8XYHD8TCbj594j0sK3MG4C9UfeIQTLRcxz5YR+HkRvLkU3XdB6BJOmqCIDKN9kvqpQQ/jM3t2xyAJZJGwnORN6A8iR761BchMyeBJq0JcA0wMeZNXsO4G6dTS4AP4tnvgqq5+PKsT1Lcv8T4cx3bFVV+YhyH3fwvUnKCR7SJz3RyKM9nIExoKNa6phE4yVuumXjqfU+x19UWyAb78MHD7JVSnC5hDNtxriVRKyFR0OmeRGOw4vmyFqaLWUROA2NTArzwTtqFHVp23bSsuJGKVPqDrbnbp3oonqteTmaEOuTxUo1V9C/Mx7aDQWDUdkcvA==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by CY5PR12MB6405.namprd12.prod.outlook.com (2603:10b6:930:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 15:52:28 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 15:52:28 +0000
Date: Sun, 22 Nov 2026 10:52:27 -0500
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
Subject: Re: [PATCH 03/60] mm: introduce the common-memory node state
Message-ID: <awMPu7QHXwDttkAm@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-3-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-3-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN1PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:408:e0::21) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|CY5PR12MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: ee45a4ef-3965-4da3-2a25-08df48b09c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|7416014|376014|366016|1800799024|10067099003|4143699003|5023799004|11063799006|56012099006|261009223027099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102130727099003|261102123227099003|261026121527099003|261026140227099003|261028144727099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	FtXrIX/VGzhthzOxloaQ9zy/aGTksgHeg7cmTfw/2zbHZh+Q45SySkVj6C4MoEzsoApW4JqqHMj3sxbPo0uusxQBvq40JVila2nHNM0QfViNNVyiailRjhSzMQKdiNwkHzwIEIB7LsJu1mg9xffw9dbq9Y6qiR9pO/9esor6sskxAHQhsCh4tskFtLm22oAWvVzriJYJjCKyM9Eppo+Y3FY8jlAFo7JupF02VTIBteUtbriqp6yrtkZylkxn5rQEmTntUYZnJyrtGsNDxvuOhtstR4tqmvW5bBdqumdedtGkzntGD9i+/q00iaiTwZd9+ztG1zMxjHgsSHkA788bUiDh0q5FlA92vHNajNAuiK9xjr4DR+5QaOavZ4mpRowMnlmGpr0sZjFhxE/4li69AAgdAjg1R6fBdm81zep+KmE58MS5+HOCIc3g252AjfKlkHzKme4izIQOBFlISiYTKD7Npc5MwRLusev/mL8TiueTlAhp3n7YMnBrxwGK1aRR4ABnxn6kkKktH+shvPFtUMIL1nJQBL3be07xPFYY8JbF2S/OOkZ7QXZ9f5Nc2zzMXp4QJ427vOFidBVCTMkf03anwdBCOslxd26Hm5KYtCEISExD2Bs/s+5SfCKLx0A+x+EO6B2VmindB7mB7+UiTIQ4NUlZWcw36h7BLsCGIds=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(7416014)(376014)(366016)(1800799024)(10067099003)(4143699003)(5023799004)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102130727099003)(261102123227099003)(261026121527099003)(261026140227099003)(261028144727099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+X95DYF/TJVZoHEW+qeOiLoqBOm4RGgcIafFgqcD9DHWKN33JPu9Rn4dH3uJ?=
 =?us-ascii?Q?kSrfLVAvsoQO1zklEBhadZ8SWeDzmHrZb8hhR3LFtXFRqBpcgT0cJE6tK3Gn?=
 =?us-ascii?Q?bxPSDcUwMwlY7+w2b+G7eAQyFNg7sWd3YvQR2eblcCevDd8WXC5n7UbY82yf?=
 =?us-ascii?Q?0Sa602bDajHpHSPUi20l+TGQzBUvOSK7pw5ySaOYDXCjf0bATUjURlhFcDNe?=
 =?us-ascii?Q?/LkYDZ8D31yE7ckP5YgGhO5h7JiNxoI766godyXg54KW2hHHDsQT0ZFcRZUW?=
 =?us-ascii?Q?v8UcaU1igj0Vu/dIfGbCAwdoFItC1HveaugQWfUdEdqL9Yw6BZG0ATFoBYwf?=
 =?us-ascii?Q?cVFLNp1yHGNgJVuIc3p+j2F/0E3VzwFq+8sG/kS2kuUl+gzwnABrOZZicGNX?=
 =?us-ascii?Q?7YEwFn3D9+Vg0agZ1Fd7Z9tUrvnxv242oLYc0heJqfO8A0ipGQnmXbEtIW11?=
 =?us-ascii?Q?XgZnvLo1RROkTIb7rQcFr4lI5lZedoq7hKmmFZJC29BR4U52ZaIbr42AIUzG?=
 =?us-ascii?Q?oCFWSqgngACbo4wUrPnlzuZnXI1MpUW+105ORodFVutdXRITPUpOSTkfj47x?=
 =?us-ascii?Q?gh7125O5PXa84YEBesac7tiVUiPUeUbYBkQhvskZgWjG3rWukESl7Ta85LGO?=
 =?us-ascii?Q?t+VITpMSQHUO7qyHq1pt7bm42VV8tU+6be/aPVoICurwvj5KYbGCSievlI65?=
 =?us-ascii?Q?uvlHL1XsSzSy+db3HVrGqpINFiJIQFG9FQ3LsvGhA9455gEABknJ+NBdKybW?=
 =?us-ascii?Q?FpTc2gryWYkRAKQ6h9p84YN4G/sdFLxfui4r5y8u69EiL0wfzkZ51ye5uPSD?=
 =?us-ascii?Q?oFDp0uutjIws0ZNjvpBSPyA+lzizT+pnxA1uOT2gtfne1cem3Mja8mjAr3cL?=
 =?us-ascii?Q?5Vv+FMrQuLuO6h568dQeXsR8tvqWoLX0GO07gA4c+enYES5u9FZTan7W85Jt?=
 =?us-ascii?Q?aSYjkw8yE4MQ0iJqe4BtcIJdbB3mNqrSvQsTmObtYxod5ECPNOyVA0k36zTp?=
 =?us-ascii?Q?J+ET86nT56gPsJFHrVG223qmcRvHjaVQ0r7L0MLEfLpNWK10coKCq9t0frYq?=
 =?us-ascii?Q?88+/Mtv024VlQnTngGz/bvg0w32SCmPR59GE8UQInHdU9fwJQcDUXgGtQb0l?=
 =?us-ascii?Q?RWVfbtdz9xBabmr2/MvL9ROWso/ngRjWhGsSnDDJ5W8fcUUfIrNRvl09XcIV?=
 =?us-ascii?Q?p9+t0r7Z/5DhcNkYKLOamRlqRE+BSWHNrcOuvkwdlVPXBnu+EoaqKltWA6fG?=
 =?us-ascii?Q?gzYe2e71B435Pq9e0cnti95LArPDsnD+Q0TV1hTeTlkdBBIF6sllFpz1qWYJ?=
 =?us-ascii?Q?CDH1ZvZLeIdQEUKWXIb74ZdZjdwicapv45tTDIzN6uVHXoNM9esl9qbsUIc1?=
 =?us-ascii?Q?VN1oVbdUigHqKWBCV5VcAjTie/wHEPYuIAUbZ7YqY554r6CJEELCdctgF+WX?=
 =?us-ascii?Q?KFH5kCZx6Kw/byWXSwZv9cEUvUYl3h44f+FTpcR4ViK/8Ioy7xy9e4ob7Zle?=
 =?us-ascii?Q?fz7hMM/8WDuiIysh6c7ureuwGJiTheeu1u/7KK2giDuTvZ6v8O6kIQcNHmpF?=
 =?us-ascii?Q?nHUbYPuWPFPW2BSVnhUBz5Vem5NIY8ljJuUWaVTcy12kU7m67nhcaclKWDuR?=
 =?us-ascii?Q?uOYX0MHxXH4VHZPIT1+LuP/L+2ZFH1nz1iWzu1aJLzLorv/Yf1Po/5NxJa9I?=
 =?us-ascii?Q?dH6brhUaiGtJkm6k7l7qnf7WCnK+SiOOPpp2pnW2cxGZKpSC1pJ5pQ2bfya/?=
 =?us-ascii?Q?MKH5WVGPdfAjvQ7jtsCrYSQjgxN8HboGhLWsr2OLzNgQnx5f/ATo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee45a4ef-3965-4da3-2a25-08df48b09c3b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 15:52:28.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r361ilZngkzFk/T/bjyQ6Rlz8LLQl8NtsmX9EncSd4rY4PyqoS3Z7coe4gq4vG8LL/3caXNPFMGREoG51SLoiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6405
X-Stat-Signature: y5oqm9oqw47c3dbr4ed86u9m1dcoon84
X-Rspamd-Queue-Id: CB6F2180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795362757-776718
X-HE-Meta: U2FsdGVkX19A8n7HE+agQ22blovlRXcLqYafkFeJRJsqhvRzFrhVgyh0eao/4vhGYP77UJCZpRyzB9IE2CrIS9UaQBZOEzPqP6OTJDXDrk841vNbIzBxgg8VCVZmzZGQ+giG2w3KbR06zU8Ej00bZ+R49orC5kBsOrPNu7+xodMV8EhWIsn8tZuHHHlgNc68+AI5iYLaDYatebX49+qgXMWJCYuynKFU15gGWmCEetfaUFI7M53NCl9CzHZ+s5M9NqAenQE7MM/XXesAOU+vFSREPoxpOUlEvMxPoFzfCu4uAFhsyetqBw8fs/kx/kxcAbwg3BM+fQoTxbZR3CkELJKfmNgjr2jk67IK5b0aoWSBZDI4N1Ex4im2eoTYrHYqIfVghX3rVIyDBIPOcT+2/FKCfHWYqPbwEUnj6YAi8SHzL6REaEhjA/kyowW5020Xd+buglMPdY7PWGOCYHaRPEGuKEuwsGD7I/Li+aegQEvM6+YDjW4MQV8m1UIBWm7aW36FFNfXrxJ/+aEPZWd8nMz3LMEKbV+hu0YZnsXPGzlyUcI9XvM38xRsEOpNr8gHbg2Qtxn4ccjxb+Nafw8x0Tm6mvkUsiqYaLBzvp0Jg8a4/+z4jOUVKuS++mOtmRSFO7HtW2O0XFy1yI9/GIplKDwi16r6CfVQVDSA1lIpud6T8YL/BuyL6ZchPJlVJv71h3i6UfCJb93Kk/LRdYaWavd0DAbL3c596LxX6CJOuD9pHWzYAP7g1Zio3GS9lV1/FiMSvSJVxFYQYRchjNvXBvGXeZsDSHvYrc05pbJ13iMAg1LOHkTjiS8Y8THNUkU3iA45QUqGIKnfQgGq4Fq5+8JTd5noWkyCXvLkGpb/283dqTyUVp6dV1v8qZ89usw5GMTZJinzSxS6p65u5OI4/D7j+xfq4kgL9K1omxFACmkYeiM8cJlyYwQQCllaVJnU+QYyMYsMbTbAx5tuXG1
 U68PK5Wc
 K1SJHtitCNc5RGvQVVgrbksOMP9rFFWdUoHJnBujHqMIf1nK/uiTaMW0lOl4YmTRzS3pU4aAdD/5Ixoj9Ul5Qe121UV+wEqOSajWBhlx+NYVT84DLd+KQSHvYxiy8qSSj5l3/fFPJumcmazPL9SsSuycW4mqa8KBZ7zl9/6bcYWb/CtI+0C1PLFfGMkYYYs8qk1XYhKoa9rs5zbNiiX22Ovi0JWRLMa/83hCymvrZZvwiUYUX0OgmJqq3UQB7TR1F3A3+o2YBzJgdDaHkTjBqqNEYbOhFINTJwLh3i+SnI2EAdhj+tjFLida7J5zGvqxpIyTkYvtljbYX6UIuZy/+uHk7mULuO+w8ueHlZABJwkz++HhZEJIkLHCc5+MYe2YmQXu6vkdy0ZJgaE82dHcgYXj82sYV3h3j55nt3+wgwxs1M5GGaJjjKCUQDyTftdjxln5lw8YbM0OOtn4ckoz337L7JQlzcrVs2f1SFgYXaOli63/BXGSUwERSVo8RV4lJEZI0V+aNNceqWwPy7oz0oJ7N73c98IJDmBYbNxILUK5cD3q5m9tvvo9gxpv+L6tAvTsQPX1kcPPpNpaVHNCCwL8Lp1Hrc0TacQ6+U7jjzp2P9OlI5W60BolxcuR7OFAx/h/T9DX1qRQjA9d8KnDWolrj80I7EHSxm7pGqvytC44eLgWl09b1RH9HKvxUfmDWZcqNnmAkU15RpG1SI4AJSX8K2d2jQJWXYS707JTiQon6drLIbYvaefGCx5FrtS2fXuMRIUInGMsRQnYImfp0TNr9NjjvpADUDBfYVaJATdThsui5k7UyQbZLc9tp8Qg/qXOX50Tu9vZ7mBIgz45Buz045h1GQzRooImx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:08:54PM -0500, Gregory Price via B4 Relay wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> N_MEMORY is overloaded with two meanings:
>   1) a node has memory.
>   2) a node's memory is reachable via ordinary allocation or
>      an arbitrary MM service may use that memory.
> 
> Allow N_MEMORY to mean #1, and introduce N_MEMORY_COMMON to mean #2.
> 
> N_MEMORY_COMMON nodes contain "common memory" capable of being managed
> arbitrarily by the kernel MM based solely on zone membership. Following
> commits convert relevant N_MEMORY users to N_MEMORY_COMMON.

The COMMON wording is too vague, I think...

Maybe keep N_MEMORY as it is (i.e. #2 meaning), and introduce
N_MEMORY_NOALLOC or NOZONE, or similar? That way you don't have to
convert the users. You'll need no node_{set,clear}_memory_state at
all with this approach.
 
> Expose the state via `has_common_memory` so userspace can identify
> the memory available to ordinary allocations and common MM services.
> 
> Add has_memory to the docs while we're here.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  Documentation/ABI/stable/sysfs-devices-node | 17 +++++++++++++++++
>  Documentation/mm/physical_memory.rst        |  8 +++++++-
>  drivers/base/node.c                         |  2 ++
>  include/linux/nodemask.h                    |  9 ++++++++-
>  mm/page_alloc.c                             |  3 +++
>  5 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
> index 2d0e023f22a7..0a2cf3088233 100644
> --- a/Documentation/ABI/stable/sysfs-devices-node
> +++ b/Documentation/ABI/stable/sysfs-devices-node
> @@ -10,6 +10,15 @@ Contact:	Linux Memory Management list <linux-mm@kvack.org>
>  Description:
>  		Nodes that are online.
>  
> +What:		/sys/devices/system/node/has_memory
> +Date:		December 2012
> +Contact:	Linux Memory Management list <linux-mm@kvack.org>
> +Description:
> +		Nodes that have memory.
> +
> +		This memory may or may not be reachable via standard
> +		allocations, see has_common_memory for details.
> +
>  What:		/sys/devices/system/node/has_normal_memory
>  Date:		October 2002
>  Contact:	Linux Memory Management list <linux-mm@kvack.org>
> @@ -29,6 +38,14 @@ Description:
>  		Nodes that have regular or high memory.
>  		Depends on CONFIG_HIGHMEM.
>  
> +What:		/sys/devices/system/node/has_common_memory
> +Date:		November 2026
> +Contact:	Linux Memory Management list <linux-mm@kvack.org>
> +Description:
> +		Nodes whose memory ordinary allocations may use without
> +		requesting the node explicitly, and that kernel memory
> +		management services manage.
> +
>  What:		/sys/devices/system/node/nodeX
>  Date:		October 2002
>  Contact:	Linux Memory Management list <linux-mm@kvack.org>
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index 2e67e8b23a99..86a7d6080535 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -168,7 +168,12 @@ nodes with particular properties as defined by ``enum node_states``:
>    The node has regular or high memory. When ``CONFIG_HIGHMEM`` is disabled
>    aliased to ``N_NORMAL_MEMORY``.
>  ``N_MEMORY``
> -  The node has memory(regular, high, movable)
> +  The node has online memory (regular, high, movable).  This is a topology and
> +  accounting state. Presence in this mask does not mean ordinary allocations
> +  can use the node's memory. See ``N_MEMORY_COMMON``.
> +``N_MEMORY_COMMON``
> +  Ordinary allocations and memory management services may use the node's
> +  memory.
>  ``N_CPU``
>    The node has one or more CPUs
>  ``N_GENERIC_INITIATOR``
> @@ -184,6 +189,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
>    node_states[N_NORMAL_MEMORY]
>    node_states[N_HIGH_MEMORY]
>    node_states[N_MEMORY]
> +  node_states[N_MEMORY_COMMON]
>    node_states[N_CPU]
>  
>  For various operations possible with nodemasks please refer to
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index dcdc8626627a..cc6696d1390f 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -965,6 +965,7 @@ static struct node_attr node_state_attr[] = {
>  	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
>  #endif
>  	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
> +	[N_MEMORY_COMMON] = _NODE_ATTR(has_common_memory, N_MEMORY_COMMON),
>  	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
>  	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
>  					   N_GENERIC_INITIATOR),
> @@ -978,6 +979,7 @@ static struct attribute *node_state_attrs[] = {
>  	&node_state_attr[N_HIGH_MEMORY].attr.attr,
>  #endif
>  	&node_state_attr[N_MEMORY].attr.attr,
> +	&node_state_attr[N_MEMORY_COMMON].attr.attr,
>  	&node_state_attr[N_CPU].attr.attr,
>  	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
>  	NULL
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 90bdcffa42ea..c3b984105bd1 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -398,7 +398,14 @@ enum node_states {
>  #else
>  	N_HIGH_MEMORY = N_NORMAL_MEMORY,
>  #endif
> -	N_MEMORY,		/* The node has memory(regular, high, movable) */
> +	/*
> +	 * N_MEMORY indicates online memory exists on the node - it is used
> +	 * to manage per-node meta-data and topology decisions.
> +	 * N_MEMORY_COMMON indicates whether the node can satisfy arbitrary
> +	 * allocations and whether a service should manage that node's folios.
> +	 */
> +	N_MEMORY,		/* the node has memory */
> +	N_MEMORY_COMMON,	/* common pool (fallback zonelist) */
>  	N_CPU,		/* The node has one or more cpus */
>  	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
>  	NR_NODE_STATES
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 88d507f93b1a..ddb04b72a160 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -203,6 +203,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
>  	[N_HIGH_MEMORY] = { { [0] = 1UL } },
>  #endif
>  	[N_MEMORY] = { { [0] = 1UL } },
> +	[N_MEMORY_COMMON] = { { [0] = 1UL } },
>  	[N_CPU] = { { [0] = 1UL } },
>  #endif	/* NUMA */
>  };
> @@ -211,10 +212,12 @@ EXPORT_SYMBOL(node_states);
>  void __meminit node_set_memory_state(int nid)
>  {
>  	node_set_state(nid, N_MEMORY);
> +	node_set_state(nid, N_MEMORY_COMMON);
>  }
>  
>  void __meminit node_clear_memory_state(int nid)
>  {
> +	node_clear_state(nid, N_MEMORY_COMMON);
>  	node_clear_state(nid, N_MEMORY);
>  }
>  
> 
> -- 
> 2.56.1
> 

