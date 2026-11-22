Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C8C606A693
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NHvteN96
Received: by kanga.kvack.org (Postfix)
	id 4E95B6B00EF; Sun, 22 Nov 2026 11:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1216B05B0; Sun, 22 Nov 2026 11:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A186B05B6; Sun, 22 Nov 2026 11:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17DDF6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:48:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8B311606EA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:47:58 +0000 (UTC)
X-FDA: 85463337036.30.DA1CC43
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2C94A0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:47:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=NHvteN96;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.31 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795366076;
	b=Orb55Ei1f+UL+7OQ0wE+qZTYyQDPYzFwluEgxWklDzQVg6IC0QJs/+fjXk7xhA+0cAo2d8
	o606QbdA1QY4DxS5uMdmKwTC69dDmcHUEktYZhFevarg1VeOTWAfr8cxKjAQOQCIgFHKc9
	uIWDpYCrQ8B0xo1YbqwVX/weAqmb9Oo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795366076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JATS/rNWdcvhmGzK9ANEDAbcukOMpu3tVj/EWIuICWo=;
	b=Ovvy0xBuW79LWtMP+mQGBpXfrLVCbdM+6HRya+6v4Mr3LTNuy3KMHZA4LeX2dVrbtQzlm5
	HTUvr6g7cfnFrca/hTcVmNEPrq442embUvedTM1xRO8fQ2hWcTSBm0zdNJq/Tyxm96MHF7
	2fTm5J4dMp5OItyhNzaHV+rMnmqH3vc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=NHvteN96;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.31 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDeCJdITcEIKFadnzY9oI70AmgQ1O2qZTyxaDAtFx7xgYOn9oceyXGhqfJhqB06UuATtU1FZttoybrRYCTuHhx69U6SDQPlOtU3iXRD4DdA8VgLLwAQS1vEgpsuybuBvDiaz2uYp6I0leKj4TQNSV9r5zEMNLbVamoX5EWru4LrIGC6+2Hw3z8HJr2WExbs2W3gohwTyXuruWSrU9NiCP3N0noj6lXOA1KMWWxkAEPx+U96mwZA1md4yk7rLEPQDsNkEqxBjEE1InHBY9/H+wboKzzhi5zTa53wYZYYPrIVD4JhNW/9R85Q1mLNAkkSl5MDcFtNBBbBEaMI+Vh5AEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JATS/rNWdcvhmGzK9ANEDAbcukOMpu3tVj/EWIuICWo=;
 b=tCvPwZqVLOYcVZiSWEOpsr+LEAQ9XCtKPk10IL4gDgDDh6yEV7sG7LCj4CGpPPKk9MmlOpw+T60Es4acKzqjNWU4EQWQQ1RhiWlJ8f7iO3oFiJbVtOy2W2a2/oS2kpkjf4DUIomes2Ggstxg4nEpiBepbvwrYBMQsp1NandR9DOgVubYvgWk8UpHXyv91sfKpmbOqnCEyQx1el/LZnO3xFMdWEAlJynZc51Yw4JHgBknqFCev+XiGE5mZOgqqt4OKzzC8yyGUO78X6AqMkq239kvtI4hLG/M0UhqCcDFpQhJBuEdxfLdqoiybEcPppaYfHymagyOtIINwb5sSQln1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JATS/rNWdcvhmGzK9ANEDAbcukOMpu3tVj/EWIuICWo=;
 b=NHvteN96GqE4F5Jx69Kfk0JxoQx7aOJqTEjWKB+k7lipNrHQVgwa/mowVB2CE9nhz6j5Lzwz3v3m5NA8PHA1XSEoDxSAb74gI2ExYAwUp0a0R6EECu6tipxsf98kvSs/pj7rmfS1N7PwOJc5CAMKgMHRKm5MUoSh7yBrQvEiSMhCd2XsQCnhbezzupmtuC4QcL+JMKPKDWrjRf9qiLEAfi25veb5VudDnyLxvogM1HmpL0Ge+ZKKwNa475e3eZswPoRhwpbjQZm1su9WAd4wv8XeSfLxtZnx9DFHtRj1xqL2Q3yppsLJZ9TcCv0BXONroEp0SVzKRxiBTn5kaT8GDw==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by SJ5PPF6D27E3EA3.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::998) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Sun, 22 Nov
 2026 16:47:47 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%4]) with mapi id 15.21.0639.012; Sun, 22 Nov 2026
 16:47:47 +0000
Date: Sun, 22 Nov 2026 11:47:45 -0500
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
Subject: Re: [PATCH 23/60] mm/damon: restrict DAMON-native folio operations
 to common memory
Message-ID: <awMcsTqyCgQ0dISw@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-23-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-private_nodes_v6-v1-23-74f5f9a115c2@gourry.net>
X-ClientProxiedBy: BN0PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:408:e7::23) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|SJ5PPF6D27E3EA3:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d6c601-21aa-49bb-a9ae-08df48b85630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|7416014|10070799003|4143699003|11063799006|56012099006|18002099003|22082099003|6133799003|10067099003|261021123027099003|261102123227099003|261009223027099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	pttyvZrrYA7D4hAdv7PDsflu6Uh6VmXoU3y2OtFAJmFlM8cifYkMj3e7x9ST23KXiCyG1i8STL/Gc/miT2q7nN2BG3UI8qJz+zvGasSaducR77EwZtbjVCR9qW/4c6DillNCrSxYHFW1+amy6DNVWa+1W6mNXl+7iHyWzh4guW0+eu+ifeyFlERU3Vxisg1LiC7SOmNCUYyppvdX7gJZX3/KYSY/N0gGrq9B7U1AopPUjh0mbnwyZL/7w4fjOIQZG7KEMeseEVMQs209jZx34Orl2QUurwoxz1e/qHg/EgHF61TyldoSPEYQTQi2cmYkoN2oqVm9Nz0ZAjTX5Kia5yFwmNXVZPsJ8bKtTsCioBxdHggrUY8HgtHlYDKOEDfjL3s+8O8FU6NrtcLJ/ZjqhRpAEboiL1P+oIDIY/hDVYmXE5nNQ5D6vTm2QSFAMq4xo9ZBG/ZpH7E+n/vkBCYZe7DibUFAPNVJkKiyfssTr4lYNkVa0tMZvDKPUGE+UlYKXdkY5iSAnRglwaYhdB1lsDWtsRD3sva+l+VRS+3kR9xjxV46hLNqI0Pc8RHsX687nR2ebaJv0Q9Uli8xEu1s2Qi8gcp8wqCxu+N7rJhTHGkoo29el+JhMtfcHxk5y4iutfY4LAHnEiA+8Cp8zlXS+1G3ODe6wDtYr7ka2XLHWMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(7416014)(10070799003)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(6133799003)(10067099003)(261021123027099003)(261102123227099003)(261009223027099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QjdoUo1T00asCqtnXElVzkrVImSL9el03xviw6xq11+EwgfI/I2drFxWr2RT?=
 =?us-ascii?Q?baxGGcGpWg3kLEBbOftTJ7VpuZSZGCo0sn99NGLO/B2dSdZMohm3zNtOvmTz?=
 =?us-ascii?Q?G+Kqf9hCW/syX5jqGQL6rHiPCPyQkxpfWhCo/ErzNlHT63i+WKks7Q+ZYd+1?=
 =?us-ascii?Q?V9sieSpd/4GS7vJuZYWGPaUVCNQK6FvWAouIfh5niJZoFB+ifHR3fvrsnRoq?=
 =?us-ascii?Q?imqicWxBezT6XL8Y/QLsUeqWDjBk8soHB/dKGyRzuU9eU1B02MbKM2yTlYrd?=
 =?us-ascii?Q?6yykvfEzHpMdO45UTiTMh28awrN2RYWbwvOlhNS8W8cCR7Ced4pn54w2co+i?=
 =?us-ascii?Q?9tM6/NK6PDY5LhKec4EZeDrQRHIFn1cp9N7tetif61XLbeSJ9TP57AizrSGA?=
 =?us-ascii?Q?i5LfpsCE62TrnioYJkjgPk7OxbXMO63dVqQJyfX8tmgYZ+G9GrzBPNJMQao5?=
 =?us-ascii?Q?NZoQNeVxjcuUl42vU4nfzthMt+sIJV345LYKAjun5z+4af3kKCn9orydLQhg?=
 =?us-ascii?Q?gZ9Kp3N19Gsw/EWJ9j1n+bnIDI8dz0QB7ch2fd/4Zqvj1BdzPWxQ8SNOcuMJ?=
 =?us-ascii?Q?beRQoiGDOl2ZPa2n146+P8ghcOPyeT9xSuIBZO9ivwVF4zoTu44XxGNM82mH?=
 =?us-ascii?Q?U1SjK67jwgFbAoao4SiZC90lMY2mI70n/JNzuZNYtCQitzM6uPf5ZHW7486j?=
 =?us-ascii?Q?/M2n3CgDVKWfaBbYucBTxBNHZeaXmdePKl5w7wAZCn7FA/YyAMNFM6BP0/RV?=
 =?us-ascii?Q?6JTNvL//UZzHVU2elYDvNv62Gt5iepMRH21sbygMOVPIcVwTDH+kXuayVugJ?=
 =?us-ascii?Q?YJ++aifc8xoHje5tyXWliIV1qeZ/cWH/nMHxaEXBH/R82njpCeXHiuS312kW?=
 =?us-ascii?Q?JUlVEXZbv8ZrQVuUunIx9y8FTfwTMrS3YcH+Xf04UvmTq6qRglN6qlM2a6xt?=
 =?us-ascii?Q?TaR1KvfCS0xKdt0mgqvmg9sNXiJK9G3RVvPVH0sTm6OITzj7J/tkfoYs8RNw?=
 =?us-ascii?Q?VeRPcd5dzT7IWifoxTECcVo6R/58PZmGskttf1irgqBPWJDXKlJLu7tYxE5G?=
 =?us-ascii?Q?xwP4ynlysDFbIa4zFb2EsObzWf1nbIrSkvIOK8b6VZUc4GnaAcFyar/n00mT?=
 =?us-ascii?Q?tao90rRFiquIK4DX02/A3O8mDCYejx1M/1SS0ZHm+ygnBBzNTlCcdSTAccRv?=
 =?us-ascii?Q?m4w5nZ0FTbN1Sd/nyCIOnntSwTFdwOKyXIAJ/90/e4fmkR4et3VDMfd1ZJYR?=
 =?us-ascii?Q?YBfrrgw9yor1KWwH2OZEdzisad0IxDvd1Y/G3h89yIZSUO/leWKW89Ax9Q1o?=
 =?us-ascii?Q?vhejkCribBnP+ehHs5YWbvRVmQL7oTtqptLiYwHezsDrUm2WsJAGRytGCGN/?=
 =?us-ascii?Q?AWxsL72oKQ8MD+yOR5+AcXLEJMT5qWAj57V/aSbVuSK095FLfHvgM0/N0pgH?=
 =?us-ascii?Q?u6bqKwO8TgklAGGU5wwX3kBZEJ3lNlDwfI8KjouzYfI3iy8NFStOo9J3clfc?=
 =?us-ascii?Q?S1F0UrFyEMepBSc+h0dW/nT/eRtLboGdw4V7cFW6HR89B3MbHT3MJq8R54C9?=
 =?us-ascii?Q?YkynPk4QhWAL21OiUHB1Bcf172WaJb0PD4pXOPBcEJ5O+T7p0FyZE5QxsIlj?=
 =?us-ascii?Q?GIqr2Z0iIp2bQz+zKPXzC7oSWc8DuSZyqf/GmLyONgm/OCWukRJzO5fCC+Ij?=
 =?us-ascii?Q?8b67FI1um10g2xuoTblCPwcBOm1Hr92FXtb+F/MOFPikzPwAyAZ5exLsd3y4?=
 =?us-ascii?Q?P5utbCJKhbvu777p+E0BOnCiLuHw2kO5mf3H2uisNshlY/BsHMQ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d6c601-21aa-49bb-a9ae-08df48b85630
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 16:47:47.0757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+1VWZU7dM6sKOJYqHO9c+hsyEoiWzlaDXATHgydhHUhlmlPbaVIckNCrUWY+l99eKJI1Qzvn/kkfDGvS5d4zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF6D27E3EA3
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2C94A0007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: dd7iynn6q9jys5fdzt7bbwfokjrwdeos
X-HE-Tag: 1795366075-997306
X-HE-Meta: U2FsdGVkX18GwK+xypYkHTCusO8/R7+rI0zQDoP8u+RAlL7XynzSqkZ42fgDiQGuejbA6wl1svfNAOzgcCiQhPwLUpHe0MULUmgTWkYdmGP4U+8HB/mtaCqTA1uuKinsNhctkGKJUn9qzJ7sqvry5JXDFfLkJv6b/JKu3D25W369UTS2fWul6ILvhg1ZTdJPs42H6zaZ1NbG0BU2ynE1UchweB380to+0EkYZlspChXd3OnwWwpusI6yxZid350r7gRWaifJKa79+OrtRhLdb3e2rpweGuXDjhmbc3FoKHlG+0WvdwF5T1aofhymCjxEJaapjoV5boVynVZvzyrpYa3tSa3zc7M1Rst0/FZYICACOYQio+SwNxjsnUtF12cPcq10exAtwbAqJ106IJJlMGmMx8cQHRYI6ZUnp81cu20BHQIB//xME/DfbWzuuWxI6Ep5p8STYBVJsTntYYXOdOBtkfpnxnNOFHkG5YvaP5BJ7qiQ1GSA08UFCHmxSfiiC2LIiYFhF0vL0JkpSuY3Jh4AqlsgkmYmz1FSTE5FPo7H9+AKzVDhLhNC77sr6HIwlRd13C+2Zrjv7bnrSlTA7p8rHYJZPcWIlgEJToUnIZKrhQnM+2l/cFwuXCBgHjhJ1WWNms3vOTXGZwYoAHVxLq8wbkPPUy/mBPRW69rE24gOJLahD5d7kc4VgBUvZq+fZKOOd8R6wh+qSQks19JZMrUe9fo+POOuVMHiz0vqmH5RTmGvAUZhudVFsoVyJW4wUhe9LsJWjN6YDpovAOEgO21SNgp9eC/4v173HadPv9hn5LAbKiGAvrRpZaP7AWnSiWjZZO58sNw7VctndMyxI3OsKKHZ+3mFWUtwsKc+nXlGwsbbMgkI2aN86CtK7YZ2mixcugIVNGECEJsVRRAKOS0sjxAP5mIUR3RM0Kg67RiGWEPbPw1Yk/gbowxqHoyCgiHqS2voTidL/KAx2q1
 iXnAPvAc
 Yl2S5iRwtwwaM4taD9CBTea9HvG0WVOsyKFMBEsf+MO5e2fxkFdBwVonATxwD+zs3qVcd6078WIrj2QmWcIkbMoCL5ETcm643PnG8PHDEYjVN+Q9Za3WljwFiYT0IajZItUaHX5uSYcbU8iH5r8O1UGRrlQPMfw1COpWL7+Wr0np7j3EsoJQrS1PoCfQS+SOe4py+2oqQQLY2+Ac6fFujqlbFsh3jdbLltAjWbSKBweDHZmpxlFGv5Hlq2UU/+dULVdekU7zUbGDeKv5tE6CaAFTsKIQQixKlWeaMPbPXk54kEW2FUwMSIjhmhGMxdG1FAKlwiJIyCrdJNRy5jI6X+4cGKnezP71tJ6GXrzmYhBc112/lnNJg+V4xg3kG5YcfNKOVk1F9KpVYi3R6ylCtpDPT4DDxYRDKdMvctGSrLlwk0CzTxX0aF5U/SQSpKQQZKnS8mI8WJswd2zAKbxu7nsL62EyCfyzTjns6YJnnoxylSF3CyuJ0/cpNOX9QFTWMAW96PEcOGJfECcoJubUTAyfcdumg5sTo6LZrmDOsjjL/TlkWy9qotshy8ih8mHF3v9W7Tg5ap8m8772iwF6rwD9/PZJT6A4Y64IEiZIAE7c7FXleTGNaIQnj+nrvL6s3h3zY5TIsFFOcsxtUXKJGHid27UiWpkxiCCrbB8Oq/mayy/TLXSh/HYlUOSK1Sh0bqaweTTB+PG02fIjdMa/Vv+XhLaIHRzNQWIEuuwYldiwbjPOOUsS3QZy8Lm6r5d+PU1sTH6FUVEVRz5ErY1ID0FKOy5jYRl9ZxSU4+au7rSxunMaDJduMg8DMp4yZTu374eskTTqgiQ3fGuvfnPPumHt8iXHwa7gkzKSLQ3wMzLW8F2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:09:14PM -0500, Gregory Price via B4 Relay wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> DAMON acquires folios to age them, check their accesses, and apply LRU
> operations and migration. Treat these as general-purpose MM services
> and restrict them to N_MEMORY_COMMON.
> 
> Memory outside N_MEMORY_COMMON can still hold ordinary LRU folios, so
> it would pass the checks that keep ZONE_DEVICE memory out of these
> operations.
> 
> Treat these folios like ZONE_DEVICE memory.
> 
> DAMON cannot acquire such a folio, so it never ages one and virtual
> address monitoring reports it as accessed, and DAMOS cannot isolate
> one for migration.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/damon/ops-common.c | 5 +++--
>  mm/damon/vaddr.c      | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 15cabc79613b..57201a0c5e3a 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -17,8 +17,9 @@
>  
>  static bool damon_folio_acceptable(struct folio *folio, bool monitor)
>  {
> -	return folio_test_lru(folio) ||
> -		(monitor && folio_test_hugetlb(folio));
> +	return folio_is_common_memory(folio) &&
> +		(folio_test_lru(folio) ||
> +		 (monitor && folio_test_hugetlb(folio)));

Can you minimize the diff? That would also improve on readability IMO:

        if (!folio_is_common_memory())
                return false;

	return folio_test_lru(folio) ||
		(monitor && folio_test_hugetlb(folio));
>  }
>  
>  /*
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 1e65e7651cd9..338876559140 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -830,7 +830,7 @@ static void damos_va_migrate_dests_add(struct folio *folio,
>  	if (folio_nid(folio) == nid)
>  		return;
>  
> -	if (!folio_isolate_lru(folio))
> +	if (!folio_is_common_memory(folio) || !folio_isolate_lru(folio))
>  		return;
>  	node_stat_add_folio(folio, NR_ISOLATED_ANON +
>  			folio_is_file_lru(folio));
> 
> -- 
> 2.56.1
> 

