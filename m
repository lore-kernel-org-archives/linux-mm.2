Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6638DC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D756B0092; Thu,  6 Aug 2026 01:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735AE6B0093; Thu,  6 Aug 2026 01:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AD46B0095; Thu,  6 Aug 2026 01:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3449F6B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:49:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A27641A0670
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:49:48 +0000 (UTC)
X-FDA: 85069768056.01.4D5046E
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5FEAA40009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:49:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Lhl22W7r;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 40.93.194.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785995385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgxXig9jycNG5s7oVyhtVph6suIXP+/3kiuoemGe8ng=;
	b=S9sBNO3SeEosdF2JcKDAtSVrC7KsGsLSHcbL+AOmOynwQr7eiu2ruKvrP/x1IV2bbF+484
	5V1rl6+HnaNf7unjnNWufM1Y53MGcRSxgkLDU18CR3jkryRIR+BsjFpoL1dctaQ726xpes
	ky6bW8Maoz9XCoZwbyhFkdAFfQY+Hyw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Lhl22W7r;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 40.93.194.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785995385;
	b=Z4+N31zxGvSoO1z7UNxxBrU9y4i9PaozD0y5KASLJf0+c8kdHsCUcZZd5IyIehosxZjVND
	665ulXbIr2EdNqCr9uzAlzCnyXxzcnhakTYNRCC2TKVm513gvqFboOK9x+XeLt/sm07k/8
	Fq9l1gGQkLCF+ImNkQLtD9x8X1bvd9c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elsksahKynixX4z7h4TMwtWPdktGqryvoBZnPwFn7cYhPnww1ivYa8goKhivY46R4arggPWljQU0qzF8Ja0UGou/WmvoBlssUKs624cLNmPbgRgbWXk8hv6mlCsWd/4HewA2axsMWEMk1Vk78TV/Il4sDIyUzgF5Sm8Gf/DygY/SPh443FeUrcwSKR/zAn5pkmpMYnwiyZTFpl70b0FNnwOeNi21Mq5xi4jDaUIxoeZtg2sGckCEughrcZt0CeW/Ac8FY+SSfaTDp/G9anKYNsRMpnZsfW6gY6goIzsJO+wBVExQ/P7ny8BrKLE4n/5x/by/LWp+RQ6za5ysGBIa0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgxXig9jycNG5s7oVyhtVph6suIXP+/3kiuoemGe8ng=;
 b=qzc+BmPYUa34ViGKqvd7YuoUWcde/8yNPQSRBv2KKcqL6/flp5TUf6Zuo+OVpmliEsMnG7qXXyz/JbIjn8jxrW56XcBTUUaO5QDkXDXpWQ/7/D328tNKtVDwK70inTBqp4tqbWImVGuF4G1t//JfubBqg1ndO4lgTgOUPohPMNHd1cbAiqfuTJ/lyAtfIVSZe3ObJixE3UY2GWAFop+VWc22Oi8Udk/sncuZqSME5/E2SVAmytn2j6qSvQbtdh7KJOTkA3AviK9/ox8j3rhd9USSDPScDQw8CcGIoY5cfiR8Q0s8FO/QckocV4vuRj+8nWki/96M+pBnqXSp1KguCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WgxXig9jycNG5s7oVyhtVph6suIXP+/3kiuoemGe8ng=;
 b=Lhl22W7rubbtWyEn83DH/9VF6nJe8FqU3ISdf6xwvObGvDOLuMASnQXQ99yhEe5QqxFAMoVpKOWK7xu7LWXQvakK3ep/tkOK1Ofa4uG6551XWZG8WqTawjhM39+c7pYDGRvXrI7UM97LnBv2uMiJTAcGN4jQ+aTc/i1tjfb1Xgo=
Received: from MW4PR03CA0350.namprd03.prod.outlook.com (2603:10b6:303:dc::25)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Thu, 6 Aug
 2026 05:49:36 +0000
Received: from CO1PEPF000066EA.namprd05.prod.outlook.com
 (2603:10b6:303:dc:cafe::2c) by MW4PR03CA0350.outlook.office365.com
 (2603:10b6:303:dc::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.19 via Frontend Transport; Thu, 6
 Aug 2026 05:49:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000066EA.mail.protection.outlook.com (10.167.249.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Thu, 6 Aug 2026 05:49:36 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 6 Aug
 2026 00:49:35 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 6 Aug 2026 00:49:28 -0500
Message-ID: <d2a84790-16a0-488c-854a-e135feb2f65c@amd.com>
Date: Thu, 6 Aug 2026 11:19:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<david@kernel.org>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728111401.b6d674baf8e56a27c55e0c52@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EA:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 50783b3c-db5c-4de0-19c1-08def37e7f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|1800799024|82310400026|6133799003|10067099003|56012099006|5023799004|11063799006|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	kRHYLXnIwf4UW5FnCKsNR8JIAoDpZdd16Zv6Nt51tReEX9dNs7hxoqEVOmLVwQiDAYAfisQJZ10iZ/phpkt9TSi7mwolmdMOWB5oh6SB+HXFykSdL+l1HNvfGBwFSD+MidUVOCQLDNUW8S+s1u33YpGPiIKUg+mZF10gVRU2Jl6H0bpPVT7T2NZ9V6akmCcWbbNC28ZYH/ddS93mfRygGXqAhCz026xuOePi1WdKRN3f9h44MCrcLv61mhpFii0KcTWdEgeTlphUtPakHmGlSVKyrHnrlw73BX5RBoMX71MlEAAiEbKgeqJvugyPRwfBvXn6U3wzBEQik52Glv6bB8gEa4PqVmtaTw/63GpODJPz5ot+8guGM0KJ/GG4cZeKRwByaw+TI1ccEusdseRCPBieeraBl51xHLzI9ByA3Kc/pJ+SSrLoveayOoqPFaPU5k5Kq/QFs7lXF6AEugsP4VVFLT7kfqtRwCy1bdS3xEgO0gSyPhn+wNB/0AyVyoPH7S7Rf40CBNR5Lxo0XBtKrYvS5d/i6O2FWKoO+EFyDFU3YJu8gM/VpotkLjp5WEsXGfpf+hDQg2yVwH2jbv3Q8Ej+Jjf6xn+5u8RfMGwKvP92GPiOthsR+s8uLl8BTPCx8+Jg8qTF8fmVq4Rsr0ZECrpdmaIWjWlUppXbc8PLGm2NHEZK3wgmvzjicZ2PQLaWJhjziFYLSEQH/fXW8oTaiw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(1800799024)(82310400026)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7RPgTe3Awy0pWIXdXVzoMvDT6owvq2LCCuO5C0DS6ij8aAs29C2oG9rXGd+i1hi7rUgJfC4+NXygINoy0mPfOtsefThjQJNYe+AE/CAc1xTOVH3YASZ68/+rTIo+IdDlSCM3J2KfqczgO136hLQo43xJY/g6Uz7JMY+0ZEltsORMV2QHrSSVL2ZIN2B0tZCzq8Wur0gxa7QJnRH0FZyaQeb3G1gzxYkZUOpJK3aPKz154CeTDrXV1AUk7Y+YkjkDqy9SQBBRTWLxlax7mixZnTZ2rwus1Lu44sw51ru+HUlNqqF1KzlRUe9q2DniPmm1YxAKKn39Ju/Js/tHSXw+6pD2XmBFJijahlT1lNZg8o6SwYWU52y8zsylatBnZwh+rOoh5E36aHP+Ea+bm2m52Yq5zoQoacJ2r7pt73nvPjWZr9gPUlmqiOCjcqOaBdmI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 05:49:36.3310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50783b3c-db5c-4de0-19c1-08def37e7f8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FEAA40009
X-Stat-Signature: anu5hbbqg6ziiyprditi45pzx57jiakk
X-HE-Tag: 1785995385-569828
X-HE-Meta: U2FsdGVkX18yva9GXDQK3RMRZzj1B5f+CxakZpDGHHNILqtEQL6cWoYCYvdJhYX9EefNKVd1bsLpZGD9Zpmv+GpdBBezlEyp7FQi3aTXwAXhK0pHBs2dWOdlbAhL50xhtaYV0/NRp84sDFHOI8PIzWSbjlXqKLZh8x895TlhtMfy6cBvPnQFlux7nbuJnQv9aIwz6ep1+k2VgJBUor7/BrFVFFoeY7HAAvGskcEKzQIym76AvWqShyWJTBDkOGZ//xE3l0TuUZEs1VDD3zCg5CMh4IEXWfzy1TWBRqw5IDjtEcJYEbQ2TdrIqRwHD/4OBp1tSpxPv2zzocS1x+GdBqsNcl4ze3sGLAlqtrJkIT51/5Zga3lff9/OSYpuRXsHUOOw+NmbaqsLIuXhcJUHUqst0RMKBpTeB1Wh9mrAxRa7+lblZqckIeNdu4uriqujy4o7VoebN1ewzEp1xVNjPbl738+q8Ojz7MmbdxxiTYGStCaMBgXr5hlBmlHgbaAc3WQEOpLdbPpXGAL5ekzpXbGIed++m/IXYf2K1zl3+rOCz6U9S8vr5S7aXibihQB5JcEU7W+qosxHsxsjFTiTWHw8Xfy14om5DrJedVbiau2foEngJptvbPkgtnpukLlMjC5wSO53ZciIlMWnB+qy1FWAn8Y/wX73wGjSxBnPnlKjXMSMsR02KVEDLWh0rERw/MuppbIgAyDc81hIj8MddkgyO7Kxv8KiG1SQNJtNbGS9NQzcmpjN36sxs/hQzgwzQ772/tiine14VDZERXWgOmudLZXlNQq2ZltiFCVy6+DndB/ko2tWkOE0YfzRdH9aCm8uD4LoogrRit9liAIpDO47pdh/cslU/+sLWg1c2EkMvEBhvR4mXLuU3GWrjPaHZ5Yjgg5dI0rRozMC7yvuES1JNJi/gQ6ZJTV2qehtVjajzmkWl7I7ciwru7iHD5PiIj/Ej3Ymae6BxUmWGvt
 KB9fmNVa
 7LzUdINF6SYzRJdjWeH6c3uzL57kR2/8jKVARdvbzRgvloeYdWaIp1MoW+GxuszaZE6fKMKPudX+tc0dfYJCjFXeVhu2BujigfTMhA4bfnm5T6/BT52xFnOvNnzRm1/rSnoW9oRmTqy35UjkJg13ZBg1C5qC2i7jL4U/Rob9YhcgibXtJ9MKTgobsnG8CO4FPHHgWfMqmtNtfE///aa9dGIHFTV6A33TgdctZiLDMgNf48/CBEFjQeOAjHebR2/f5g/fi5HAktJzwrLJm21K44cMt/sDDw2UHWVtb33+06+mgiBZtxBw6qS59jZMta7xX04NEbgrMXSM0Gu7B1+1Ccnf1OK8nS9UC8x6jvHCsANS+1uTwz4fpEP+ajJ/l9mkOaTNEk9VUgZCKfm/djUc3YTJ/7bF75NyWiDGm0ex9n/go6oxD+WvvdsZ+IQG6764b+HlGcoe0X1JB4O6J69PDKFwWwQp3LylJScrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
>> This patchset introduces pghot, a subsystem for hot page tracking and
>> promotion.
> 
> Can DAMON be used to do this sort of thing adequately?

Hi SJ,

I started comparing hot page detection and promotion aspects of DAMON
and pghot through benchmark runs. Here is the first set of results from
pointer chase workload.

Since I wasn't very familiar with DAMON tunables and settings, I let the
AI to chose some default followed by other combinations. The test harness
is developed and run by AI. Request you to go through this and let me know
you feedback about the combinations and configurations tried here. Based on
that I can adapt the settings for the future runs.

======================================================================
DAMON vs pghot: hot-page detection and promotion, measured
(single-threaded and 64-thread workloads)
======================================================================

Summary
-------
This note compares DAMON and pghot on how well each detects a 16 GB hot set
on a slow-tier node and promotes it to the fast tier, using the same
pointer-chase workload on a 3-tier NUMA machine.  Here DAMON refers to the
in-kernel access sampling with the DAMOS migrate_hot/migrate_cold actions,
and pghot refers to per-PFN hotness tracking with the kmigrated promotion
thread.  All runs are from one uniform harness with the same metric set.

In short, pghot promotes exactly the hot set with only a couple of sysctls,
and it behaves the same way irrespective of the thread count.  DAMON can
reach a comparable steady-state accuracy, but only with workload-specific
tuning, and (to bound the fast-tier residency) only with a full
bidirectional promote-plus-demote setup.  Even then, it reaches the right
amount only after first over-promoting and then settling back down.  Two
further pitfalls are worth noting: one seemingly reasonable tuning promoted
nothing at all, and the promote-only configurations over-promote heavily.
The difference largely reflects region-granular sampling on the DAMON side
versus per-page tracking on the pghot side.

Test setup
----------
Machine  : 3 NUMA nodes.  node0,node1 = DRAM w/ CPUs, 256 GB each (top
           tier).  node2 = CPU-less slow tier, 256 GB, SLIT distance 50
           (asymmetric 255).  phys 0x8100000000..0xc100000000.
Kernels  : base  = 7.2.0-rc6 (DAMON; NUMAB tiering)
           pghot = 7.2.0-rc6 + pghot v8+
Workload : pointer chase (dependent loads, latency bound) over a 64 GB anon
           buffer; 16 GB hot subset, rest cold.
           Single-threaded: one thread chases the whole 16 GB.
           Multi-threaded: the buffer is split into 64 chunks of 1 GB, each
           thread chasing its own 256 MB hot sub-region (16 GB hot total
           across 64 CPUs).
           Timed phase = 240 s.
Placement: buffer relocated to node2 via move_pages()
           Task pinned to node0 CPUs, Target = node0.

Legend
------
lat   : mean access latency, ns/access, shown first->steady (last 25%).
conv  : time to within 10% of steady latency (s).  '-' = never / flat.
node0 : fast-tier resident of the workload at end (GB).  Hot set = 16 GB.
over  : over-promotion relative to the 16 GB hot set.
regs  : DAMON monitoring regions actually created, measured via the
        damon_aggregated tracepoint (DAMON runs only).
sample/aggr  : DAMON sampling interval / aggregation interval (Table B).
acc/reg/filt : DAMON min_nr_accesses / max_regions / YOUNG ops-filter.
thr/NB       : pghot_freq_threshold / kernel.numa_balancing.
Note  : DAMON promotion is counted in pgmigrate_success (and the scheme's
        sz_applied); pghot promotion in pgpromote_success and
        pghot_recorded_*.  So placement (numastat) and latency are used for
        the cross-mechanism comparison.  pgdemote_kswapd/pgdemote_direct are
        0 in every run (no reclaim-path demotion).

======================================================================
PART 1 - SINGLE-THREADED  (64 GB total / 16 GB hot)
======================================================================
(base-kernel baseline steady latency 278 ns; pghot-kernel baseline 295 ns)

Table A. Headline: best of each mechanism
-----------------------------------------
Mechanism                          lat        conv  node0  over
                                   (ns)       (s)   (GB)   (%)
---------------------------------  ---------  ----  -----  ----
baseline, no promotion              320->278     -    0.0     -
DAMON promote-only best (row D0)    290->133    33   22.4   +40
DAMON bidirectional     (row D5)    299->138    47   15.3    -4
pghot, hint-fault source (row P1)   166->129    16   16.0     0

Table B. DAMON tuning sweep (base kernel)
-----------------------------------------
id  sample/aggr  acc  reg      filt  lat       conv node0  over  regs
                                     (ns)      (s)  (GB)   (%)
--  -----------  ---  -------  ----  --------  ---- -----  ----  ----
D0  5ms/100ms     1     1,000  no    290->133    33  22.4   +40    12
D1  1ms/ 20ms     2   100,000  yes   311->279     -   0.0   n/a    14
D2  1ms/ 20ms     2 4,000,000  yes   325->280     -   0.0   n/a    13
D3  5ms/100ms     1   100,000  yes   298->123    85  34.4  +115    13
D4  5ms/100ms     1 4,000,000  yes   315->136    96  27.0   +69    14
D5  5ms/100ms     1   100,000  yes   299->138    47  15.3    -4    14  <-bidir

Notes on Table B:
- D0/D3/D4 show that raising max_regions does NOT reduce over-promotion; the
  over-promotion is high and varies run-to-run (+40 / +115 / +69) with no
  trend from the cap.  The measured region count stays ~12-14 in every case
  (see conclusion 3).
- D1/D2 (1 ms / 20 ms window, min_nr_accesses=2) promote nothing at all.
- D5 is bidirectional (promote + a migrate_cold demote scheme on a second
  kdamond over node0).  It ends at 15.3 GB (about the hot set) but only after
  first over-promoting and then demoting the excess.
- kdamond CPU over the 240 s run: D0 7 s, D1/D2 2 s, D3 12 s, D4 9 s, D5 10 s.

Table C. pghot hint-fault source (pghot kernel)
-----------------------------------------------
id  source (mask)         thr NB  lat       conv node0 over
                                  (ns)      (s)  (GB)  (%)
--  --------------------  --- --  --------  ---- ----- ----
P1  hint-fault (0x1)       1   2  166->129    16  16.0    0
P2  hint-fault (0x1)       2   2  388->129    85  16.0    0

vmstat deltas (pghot runs):
- P1 pgpromote_success=1,195,791 (*partial - see below).
- P2 pgpromote_success=4,194,304 (=16 GB exactly),
     pghot_recorded_hintfaults=5,307,760, numa_hint_faults=5,307,760.
* P1 (thr=1) promotes so quickly that most of it happens during the load
  phase, before the vmstat baseline snapshot, so its delta is partial;
  placement (16 GB exact) is the reliable figure.

======================================================================
PART 2 - MULTITHREADED  (64 threads, 64 GB / 16 GB hot)
======================================================================
(base-kernel baseline steady latency 251 ns; pghot-kernel baseline 282 ns)

Here latency does not track placement linearly, so it does not rank the
configs on its own: partial promotion can yield most of the latency gain,
and the two baselines differ by kernel.  The mechanism was not measured
(bandwidth and/or working-set/TLB effects are both plausible), so placement
is used as the accuracy metric.

Table D. Multithreaded results
------------------------------
id  config                  kern   lat  node0  over    regs
                                   (ns) (GB)
--  ----------------------  -----  ---  -----  -----  ------
M0  baseline                 base   251   0.0     -        -
M1  DAMON promo-only 1k      base   124  63.4  +296%     351
M2  DAMON promo-only 100k+y  base   120  61.3  +283%      52
M3  DAMON bidir 1k           base   124  31.1   +95%     588
M4  DAMON bidir 100k+y       base   136  17.1    +7%  21,101
M5  pghot hintfault thr1     pghot  129  16.0     0%       -

Notes on Table D:
- Promotion (vmstat): M1 pgmig 14.2M, M2 15.2M, M3 14.9M, M4 18.4M;
  M5 pgpromote_success 4,112,464 (pghot_recorded_hintfaults 2,490,368).
- M1/M2 promote-only over-promote to nearly the whole 64 GB buffer.  With no
  demotion, one-way promotion plus region-boundary false positives keep
  accumulating over the run.
- M3/M4 add a migrate_cold demote scheme (a second kdamond over node0).  M4
  (fine regions) ends at 17.1 GB (about the hot set) after a mid-run
  overshoot and a long settle.
- Region counts are much higher than single-threaded, likely because the 64
  per-thread hot chunks create access-rate gradients that DAMON splits on.
  M4 reached 21,101 regions and consequently used 146 s of kdamond CPU over
  the run (vs 17-25 s for M1-M3); that is still far coarser than page size
  and it still over-promotes (+7%).
- M5 behaves the same as the single-threaded pghot run (not sensitive to the
  thread count).

Table E. DAMON migration & demotion counters (all DAMON runs)
-------------------------------------------------------------
pgdemote_kswapd and pgdemote_direct are 0 in every DAMON run: DAMON's
demotion (the bidirectional migrate_cold scheme) is explicit migration,
counted in pgmigrate_success and the scheme's sz_applied, not reclaim-path
demotion.  The reclaim counters would move only under fast-tier memory
pressure (the overcommit case, left to a separate test).

run               pgmigrate_success  pgdem_kswapd  pgdem_direct  demote GB
----------------  -----------------  ------------  ------------  ---------
st-d0 (po,1k)             6,293,366             0             0          -
st-d1 (nil)                      0             0             0          -
st-d2 (nil)                      0             0             0          -
st-d3 (po,100k)          8,573,820             0             0          -
st-d4 (po,4M)            7,081,247             0             0          -
st-d5 (bidir)            8,607,955             0             0        9.6
mt-d0 (po,1k)           14,182,546             0             0          -
mt-fine (po,100k)       15,160,909             0             0          -
mt-bidir-coarse         14,889,977             0             0       13.7
mt-bidir-fine           18,356,299             0             0       26.5
(po = promote-only; demote GB = demote scheme sz_applied, bidir only.  For
 promote-only, pgmigrate_success is the promotion count; for bidir it is
 promotion + demotion combined.  E.g. mt-bidir-fine promoted 43.6 GB and
 demoted 26.5 GB to net-place 17.1 GB.)

======================================================================
Conclusions
======================================================================

1. DAMON needs considerably more, and less obvious, tuning than pghot.
   A seemingly reasonable "faster and stricter" DAMON (1 ms sample, 20 ms
   aggr, min_nr_accesses=2) promoted nothing at all (D1/D2).  This is
   consistent with the per-page reuse distance (~1 s for the single-threaded
   chase) far exceeding the 20 ms aggregation window, so few regions reach 2
   accesses within a window and DAMON treats them as cold.  Working operation
   needed a 100 ms window and min_nr_accesses=1.
   pghot worked in every configuration with numa_balancing=2 (+ optional
   pghot_freq_threshold).

2. Region sampling over-promotes; per-PFN tracking is exact.
   Single-threaded, every promote-only DAMON config over-promoted, by a
   variable amount with no trend from the region cap (D0/1k=+40%,
   D3/100k=+115%, D4/4M=+69%); pghot placed exactly 16 GB in every
   hint-fault run.  Adding a demote scheme (D5, bidirectional) brings
   single-thread DAMON to about 16 GB (15.3 GB), but it gets there by
   promoting too much and then demoting the excess.  Multithreaded,
   promote-only DAMON over-promotes to ~62-63 GB (+283-296%); only the
   bidirectional fine config bounds it near the hot set (17.1 GB, +7%).

3. Setting the region size to the page size does not close the gap in
   practice.  I measured the number of monitoring regions DAMON actually
   created, using the damon_aggregated tracepoint.  Single-threaded, DAMON
   created only about 12-15 regions in every case (max_regions = 1,000 /
   100,000 / 4,000,000), so the cap is never the binding constraint, and
   kdamond used only 2-12 s of CPU.  Multithreaded, DAMON splits more - 52 to
   588 regions for most configs, and 21,101 for the bidirectional-fine run
   (likely because the per-thread hot chunks create access-rate gradients) -
   but that is still far coarser than page size, and it cost 146 s of kdamond
   CPU while still over-promoting (+7%).  Reaching page-sized regions over the
   256 GB slow tier would need about 67 M regions (the 16 GB hot set alone
   ~4 M), i.e. around 4 GB of region structures walked by a single kdamond
   every aggregation.  DAMON does not create anywhere near that many, and the
   rising kdamond CPU (146 s at 21,101 regions versus 2-25 s otherwise) is
   consistent with the cost of pushing toward that count.

4. Using many threads helps DAMON's detection speed but not its accuracy.
   The higher access density lets DAMON detect quickly (latency converges in
   ~10-15 s vs 33-96 s single-threaded).  But promote-only still
   over-promotes to nearly the whole buffer, and bounding the residency still
   requires the bidirectional promote-plus-demote design.  Even then M4
   reaches 17.1 GB only after an overshoot and a long settle, with heavy
   churn (pgmigrate_success 18.4 M, far more than the 4 M pages of the hot
   set) and 146 s of kdamond CPU.  pghot hint-fault places exactly 16 GB with
   the same behaviour as single-threaded, i.e. it is not sensitive to the
   thread count.

Overall, pghot provides exact, prompt promotion with essentially no tuning,
at the per-page granularity that its sources give it, and it is not
sensitive to the thread count.  DAMON can approach the same steady-state
accuracy, but only with workload-specific tuning and a full bidirectional
setup; it can easily be mis-tuned into doing nothing, promote-only
over-promotes heavily, it cannot in practice be pushed down to page-sized
regions, and in the multithreaded case it reaches the right answer only after
an over-promote-and-settle transient with substantial migration churn and
kdamond CPU.

======================================================================
Methodology caveats
======================================================================
- Latency is the primary metric for this pointer-chase workload, but in the
  multithreaded case it does not track placement linearly (baselines differ
  by kernel; partial promotion can lower the latency out of proportion to
  how much was promoted).  This was not root-caused - bandwidth and/or
  working-set/TLB effects are both plausible and were not measured - so it
  must be read alongside placement (numastat).
- Over-promotion figures vary by several GB run-to-run; the conclusions are
  stable but the exact GB values are approximate.
- DAMON and pghot increment different vmstat counters; the cross-mechanism
  comparison relies on placement and latency, which are mechanism-independent.
- vmstat counters are snapshotted around the 240 s timed phase (after the
  move_pages load phase), and hence exclude the relocation migrations.
- The overcommit case (hot set larger than the fast-tier capacity, which
  would exercise demotion under pressure) is left to a separate test.

Regards,
Bharata.

