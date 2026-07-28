Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ABE9C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133B56B007B; Tue, 28 Jul 2026 02:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3E96B0088; Tue, 28 Jul 2026 02:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF1B6B008A; Tue, 28 Jul 2026 02:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B61226B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:11:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F44E1202D4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:11:40 +0000 (UTC)
X-FDA: 85037163960.10.95AC989
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA49A80002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:11:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QDc3HfX2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.48.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785219097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+AIk8Ny9rBVVBoVXL/wvITWGficV6GlxY9MycxvnJk=;
	b=ypHe6Vw1f95mGG60OQ1VwVoKLw/6kPsxNAQ3XNU1nqrSBmuqAF7M5uywq0zWWxQbXQZ1QF
	7ho/p4MVB7U0Rd09RXLrnRLuFgUpo9vEZFHnWQZMDzODQZMCIkfZTg/TTYs04VjcnESd5I
	Bk8Cfjovh5LWXM4Oo+ZO633k0q7V5VU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=QDc3HfX2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.48.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785219097;
	b=GG4Jt3T/yGhjU7WY28VNlibxsG+KsBNMPJr+4LsAgHZR2L7nwobiOpdErqKLhS8NLC0s0R
	O2fD/TkDPAiynMcmlEkR4biFmJVijR+M4I1h+CtfwDodsD6YXQVVuvVNrtHx3yysMwKzJI
	Dkk6Dr3aAKphK3e6AjPjykD21hM3nuU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yVCwGEeKb471RejsYK/X7XeLi2rYW/aVWhJGnbeTlrRuMr87DZfzVYvPBdxhMHG3m5VhPmo22n9r7LUIl/bc4/irfZhJA130mQNk35booRgQJhW0UXMkVGkrFBwhSKs2T3cXJLWdDEG2HIdAFgLg7XaicTn0cQRAEeuhdnj51OqsO1kgTMfmE7QnSgHOahEbAYIiAnZUPAKTd3tWEGRuKS45SurMSzemZAljjJrV0yXYqJ5LxlCwEQD+Tao5Yz19NI7EbRPTBRAZfpiQ5+peF7FmYXWEl3i4kXH+iL+qruL9BvKL+2MSBELgKzOMjXrrLFMSFRneyi8WKXoc4+R1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+AIk8Ny9rBVVBoVXL/wvITWGficV6GlxY9MycxvnJk=;
 b=AXQKcajKYDbHDBbi49wPbpr/3e36uMMwP2dCz22hefn358uYWdITXLJADFSjJ8T7OJGOXIhB10Uo86m0Kgm56dpiOuyr8UymemAF+0gjwzMFa1Tb3PFAL8A7cEJ7hI/+hjn1XDgY95Ja1HA7PecDyPgBYn2nTeeAarGRu9/0ULvwmMEOqrH/PzhmLaxrhU+IyR2LWEsCFGoCehs12SLAc6lyMyoBoPYq74qfwt6yKANt7+lapW1BElSWNhjY9kDua5IhNI7IHIsSrgJG4jlU4BN+w7ybV5XSGggjTT+cxQsoCi6xEnAAPU7RnWQffu6Ghf6O3RirZniPIXahE6K2Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+AIk8Ny9rBVVBoVXL/wvITWGficV6GlxY9MycxvnJk=;
 b=QDc3HfX2/P1EvjEMx0YYwJ4hNX1NJ/L2pK7bLk9HEW12gKSk5oCUZ78FWiSvApS12TzWq3s+b7lBeBxIHHTTE4jpNJrhOtNWiI0OJXuHdjSO4vkrsjy711DG6U+gKjYNk8Qjluq1HuLREj/W7MjOwUU6oEHA1DLBK096M+6h3Nk=
Received: from MW3PR05CA0025.namprd05.prod.outlook.com (2603:10b6:303:2b::30)
 by PH7PR12MB5877.namprd12.prod.outlook.com (2603:10b6:510:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 06:11:31 +0000
Received: from MW1PEPF00016159.namprd21.prod.outlook.com
 (2603:10b6:303:2b:cafe::82) by MW3PR05CA0025.outlook.office365.com
 (2603:10b6:303:2b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 06:11:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MW1PEPF00016159.mail.protection.outlook.com (10.167.249.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.1 via Frontend Transport; Tue, 28 Jul 2026 06:11:31 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:11:21 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:02:20 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 28 Jul 2026 01:02:13 -0500
Message-ID: <908ee24c-add2-4518-ac3b-9abc87edcb93@amd.com>
Date: Tue, 28 Jul 2026 11:32:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
 - Graph500
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF00016159:EE_|PH7PR12MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e51c8e1-5def-4129-163a-08deec6f116b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|7416014|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7lHoS7gjiLtjxIy/koX42hXaldAIoUpnToVb2umxzg48Sn/88ucAMMP9dWpJ1YfAHlRDLbMZ9tX0dcGg56sqY/1fAaRhUe7NA/KoKp8PuHqIjXmd8G7ligleM2KU23HtrvbKDycAIvpU66HJae7LcSguPK2kqkQ3QcIPNYorJ/2lZSakZ6+WGZSegVEdBu4VksDZesTf8ECPXA/UuWrjZ+oBqWhyQHvtgT4wl0RAsAjvLIUPFdDkUgs3jUgzjLg4ooWSdo71vMPiENUjsmzr8sC3axUqrl52wxNIA2q35lpeOoRMaZsTUff9ti58q77544zieaORst90q+iMA6TWFUaix1+mXg/B0qq+BixWyVv5O0WxDV0t66SaoJdAwNB7A8j/L2Dk6/imuLT8jPJZzxYPKj/aF6eiBqm0M8Kmyrc+xlqKtAIINdfoZuz//I1KM8EWLT3h3qqau5iMi3S9wS+QbvyH3e6mafDRkrES6vUUmja1cG/64S2AonM+XPRkdqATAx4uSW28e96UAXV5qWDIqmmp9kAsuaUSd2wPDYkNGeLuox108HYUCGjchKFiUVqrpN6MoizKgDC/LBEY7yj5j7FuHyZRPB1J1VJ1UdnmXlamEM6jBEV8soeoiOdYPp0s9hYPjJYQfVv/hv0xUSlwOqtHZiEfDD6PCa9YDVvC9OoeTDg1yHc6pnVVUkIWcpDxTe3GoMOAdf3rK1x4QA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CNmm7ky/RoBaruWu96bF0PdW2ldVTUHshB6crR3Bu9q/xto9WYdDYOJ/Bsgj0NkBOROcyanfWz78/NDbPqUgnzEdmI1vD/xx5bcsRqiavaXbWi+9Ga+zEz2FEdYUw7M/vzMbpvg9kR/SxroSniAF5nMhUv0VbSSH4ZoB9DkMkFyxBn7qiAmo2fiT7RFmy0qeHU/gycyyJeni3Gg6oMNAWh98dfjOsZMWX2yZZv/vZSeJioOUgvAwK+iLw+GQ83FSHkZYfe2yX32J+8J7j/lVoEVZfqqlahXTh3757TNdxzGgEOxGUXGlkeXldawvRWjSljVCOlBQHb7fXjNE7ZtVNN+R3Oai4VxHmXyRbVO2EsLz3dQwf/5jMkKHHzJUe7YPblcSKCqs7doSO4FG6RMjvnIf6d3/dochgRiX9QMVlsupGe3XuIlUWy5TJl+k+bAS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 06:11:31.0091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e51c8e1-5def-4129-163a-08deec6f116b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF00016159.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5877
X-Rspam-User: 
X-Rspamd-Queue-Id: DA49A80002
X-Rspamd-Server: rspam01
X-Stat-Signature: togctb4dxzzqx6m8hkc75d6o96zmcuaf
X-HE-Tag: 1785219096-959018
X-HE-Meta: U2FsdGVkX18E78yq5YnWKc0JtF96j4IUAbKUSf8oB6DkaVPCX9dEoLwcP2+RL6g++4QFEm85Zeb6Qy18cdKH93Gpt59sv2YOp1AHRttgKW4hIMbewxeKOoI4R+zpqQieS43GE1PQaXFT4SUWnBjAVYPgy4t5Jj3l3iUZUCufzQ31uRsD2U9rW3nh+I4RNwyAVZV9FIiTRi9aEzeCW2YHm6+vDtB1+ve99fGNk9nobLhgwPPg9gh5GLBpaQdXTBDDV7zcM4TI/XxitQTmuCUfUgBZgSqMg4baCdlatr2Eb61EPANvK79D+q3Ma37ogD2e13IifTAki6VQU53GBx+cPeU6IgSw4jzjmRQGaiAJydUeEy0LFuYRAG3kNmKDrL9k9RDGz/ok4yeqbgYn8S9QcDROhMCsmaMvqEXP34jrlWyJAkSzArO7KUyZtbF9YwbuVY01cPnmQCZ9Q55SjtLgBXD1LusDRf/BsYOy4PYrLFmSzy7Ni8GOirF7ORanv8kGCGPVPYcOPgR+Cj3OMOkuTNGkiOdvuGxM0xONTWo+07yTCRQxTBZd3cZJ7fLO4GfpHFH6s90REw2/cBn5ycualpAhLKdD/roUplHhBy2lMtQQMLBLLEX0V4+0mZ0RXEdyquvqTY2hFZNiEqIJEHyZp7UJerKqD58DPbRz0NES+/K/+Sc3lCWSTCwJ6tC0GcCOgk+ihFyyF3wDEslwOLYmBQJ3rWQvUgb9Fku3hwZULQtMMByfZ62zm/+CIiEj9Kwefe0r4+V0hsdCdVCB3FRw2AtaY5xqbvDcDwHO3UtORqLTaSRLDQ9+btPjctsj1IqOrqw9G4PnGjm9tviYs//ewg7AOL9mcGoJRllTdkzM+t8BZEgeA6VeD7F59/un05tHXKH7DZKG6pE/1wQ3XVbmDcWVRc4IbNd0R/7Yfcx1KOU4KDPq9+Ad9PMD4XU6OmAuXF33cjTmHp2+66OMe2O
 iYAMEMUh
 1GXRKalfMMpzxe+oghHXdVeZ4YTM5KfC7yxRSAY2LiRUJyfw9JOK4X3j74jZuUKPX5UekgZVC1bIu0xZDlSCZjz9c9evkGKPKN24p3+pcrz+Nq3XIbnajwme2AzgFbVzqT7pAp6naUMhIXScS62bkfGkWBqdlTkMVCcdJMVExis2BgTiT471tCCQFhicaYxku+BMmAS1bhsUllfE8BU45BgYMBlNU3ueNBE0yJyxx1gQxm0HoeUDX0rz29wHA7GRjVMCUnenclejmRRPcAKTTQAQTufKk86h5R6pshNr9q1sWSYa4cWcwU8FN4QcK73oyX35gv9OrMwEF6txxwXVxW2yyfIwtC0MNp3PSAXsbsqyJx6Srsx3WzxXsdMb4rvayDN1pAtrHCZv4BcmlnD4pVxp3ISsL/0SdcYxaJBleTke8q1YcMa8OXnk4j0Xhlni+jEIxzz7RBL06xZ/bSpSzqpUFqy9Xd37kiXWN/j1SnvKjQ3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Benchmark : Graph500 reference BFS, SCALE=28, edgefactor=16, 128 ranks
Topology  : top-tier NUMA node=1 (CPUs+DRAM), lower-tier node=2 (mem-only/CXL)

Config legend
-------------
R1 : base  kernel, no tiering        (numa_balancing=0)
R2 : base  kernel, tiering           (numa_balancing=2 / NUMAB2)
R3 : pghot kernel, hintfaults source (pghot_enabled_sources=1,
     pghot_freq_threshold=1, numa_balancing=2, promotion=on)
R4 : pghot kernel, hwhints  source   (pghot_enabled_sources=2,
     pghot_freq_threshold=1, IBS mem-profiler on, numa_balancing=0,
     promotion=off)

Column legend
-------------
hmean   : harmonic_mean_TEPS   (primary Graph500 metric)
hstddev : harmonic_stddev_TEPS
median  : median_TEPS
bfs_t   : mean BFS time (seconds)
spdup   : speedup of hmean vs R1 baseline

Table 1: Performance
--------------------
+--------+------------+----------+------------+---------+--------+
| Config |   hmean    | hstddev  |   median   |  bfs_t  | spdup  |
|        |   (TEPS)   |  (TEPS)  |   (TEPS)   |  (sec)  |        |
+--------+------------+----------+------------+---------+--------+
| R1     | 5.469e+08  | 4.55e+05 | 5.468e+08  |  7.853  | 1.00x  |
| R2     | 1.442e+09  | 8.04e+07 | 1.491e+09  |  2.979  | 2.64x  |
| R3     | 1.362e+09  | 7.92e+07 | 1.515e+09  |  3.153  | 2.49x  |
| R4     | 1.463e+09  | 1.35e+07 | 1.487e+09  |  2.935  | 2.68x  |
+--------+------------+----------+------------+---------+--------+

Table 2: Relevant kernel counters (/proc/vmstat deltas over the run)
--------------------------------------------------------------------
Values are accumulated deltas (before -> after) for the whole run.

+----------------------------+-----------+-----------+-----------+-----------+
| Counter                    |    R1     |    R2     |    R3     |    R4     |
+----------------------------+-----------+-----------+-----------+-----------+
| numa_pte_updates           |         0 |  26675234 |  28872628 |         0 |
| numa_hint_faults           |         0 |  13747383 |  15501854 |         0 |
| numa_pages_migrated        |         0 |  13747376 |  13726437 |   3683579 |
| pgpromote_success          |         0 |  13747254 |  13726437 |   3683579 |
| pghot_recorded_accesses    |         0 |         0 |  15501778 |   3682112 |
| pghot_recorded_hintfaults  |         0 |         0 |  15501854 |         0 |
| pghot_recorded_hwhints     |         0 |         0 |         0 |  24291151 |
| hwhint_total_events        |         0 |         0 |         0 |  24291198 |
| hwhint_dram_accesses       |         0 |         0 |         0 |  19588681 |
| hwhint_extmem_accesses     |         0 |         0 |         0 |   3663926 |
| pgmigrate_success          |  26840188 |  40586709 |  40570940 |  30521808 |
+----------------------------+-----------+-----------+-----------+-----------+

Key findings
------------
1. Tiering helps Graph500.
2. pghot-hintfaults is on par with base NUMAB2 tiering.
3. pghot-hwhints (R4) matches NUMAB=2 performance with zero NUMA hint
   faults.

