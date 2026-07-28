Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9A5C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E7B6B0088; Tue, 28 Jul 2026 01:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316146B008A; Tue, 28 Jul 2026 01:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E7A6B008C; Tue, 28 Jul 2026 01:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA57A6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:59:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80438402CD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:59:54 +0000 (UTC)
X-FDA: 85037134308.06.3BB0C3E
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by imf04.hostedemail.com (Postfix) with ESMTP id 508AC40003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:59:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UE2RB8y6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785218391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WGB5yYsOa2qBSY4eP3+KD55PXR/tvSk9nhbKk2G04o=;
	b=hpBubF37ptzoxOIi6Zlwvp35T0OS/zfnqL+2y0HoKZk3LIwWAAAgUnnls3n/zy6rZRj8P3
	mXZhiP9vba0Tklel8Rz+rKMOH1M1BkFBvAQk62Egd8rkqJt30CvpkEjlKtph2vPOnVMMU3
	XgN+rrkL/Q72BKZGJ8vgsTEUNpvkquU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UE2RB8y6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785218391;
	b=zrAKuVcCQKckbuYToOcHf29IpFDget72Z5vmEhH8MM6scNZxSSh1BUiUnwcvpxRD55dYeD
	OmsGcv7bClI1rcUxlj5LV5fwXolf0uXFKpu8YcUG99BCenILTHiKxzfxqb+M4WE/B97EkZ
	WwcWD2do1xW8McAF2G7wkojBAbu1160=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9Ass+Uc2nFsV/hPRt4IhoasFAgti6VOH1RjllTIfP6UOM8gsZgIniT38FLk81jRIxWBxPM79HwdlDxAi71GyTszuCTSx2vbAGVZsLkga+y7n+0KIXklT/T7ALtzwtdPTNiU11Wd665c29H5E8WUF5VFU3DoFdnS1NXn7gQP/JcEp/LC0cW7Fu2HjS29sCwruY+bc4Vk8OXc2J3U0tmA2nyZiyVwI1sa7FPCPBrMvGruz9uriV5Y8HycRtdOzcHkGc84Yii1P9vMXcitFRLCPiSKakpdQPr9lwZoZFpQ48+LEwZZxkpgfzmSzY8yZO5f8t99Ux1kBlTQTU9NKSNf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WGB5yYsOa2qBSY4eP3+KD55PXR/tvSk9nhbKk2G04o=;
 b=dZ9oY8UVBvCB7WRKf6XBtRtLHG7EWTjvbvzcle2wzu3Ymvmi+eU6zJR22ALMnzE9/D4OIqKi/N0ptBk1hzE4kKEbGApRwOTIfVup2Hf48IgfbaTIAryhHbyP4HShCk0YMOLQbhdETRssNiBLmXoMabFLFyXjPRHeSujsSBTtM9cOj0Sx/AnCGHbt1WwzMjWqjY5CjqfXBq+d9FbxhNp4rqiRma95WWgcqz2bUQEni9hHzHzCrjozgK0/VVeJ9iV2rNoM3rhr7VyEgTB1XZEFkN8hB/I2FtRWHUSkSdbjwRunows8j+sx54XTRjfV5OMwI9xUlkZJRFGjCd1rSmc0Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5WGB5yYsOa2qBSY4eP3+KD55PXR/tvSk9nhbKk2G04o=;
 b=UE2RB8y66dQL5m9rHUhEaYk3GjHVC3CKgrnJRHlyqMWLx5p1U5D5g3yGgiq1GucaziYmnsW7FDSKFBw1514gV2LAbftWaQmp98CPdox1A2crzgds7xiX/8LCOxveBXQPSyO8CrpCF9AQbbnavr2+7+12qH+m1ny/xnNWn5BBbSA=
Received: from SJ0PR03CA0057.namprd03.prod.outlook.com (2603:10b6:a03:33e::32)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 05:59:45 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::1) by SJ0PR03CA0057.outlook.office365.com
 (2603:10b6:a03:33e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:59:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:59:45 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:59:45 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:59:44 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 28 Jul 2026 00:59:37 -0500
Message-ID: <64abacbb-e762-4705-8ba3-6b69572e2925@amd.com>
Date: Tue, 28 Jul 2026 11:29:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
 - NAS BT
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: c1c580a7-b90c-44fc-85f0-08deec6d6d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|82310400026|1800799024|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gYGVrah93m6mlzKBx/LCYrqi+ec7H1DhIwwBdepv9CStOLg7ilP5MZYLYRlpkK/WfTZ51TEJERFcWMqeM44pB7v1FnB6NxGv6w2zEINVjBhXuEgJA3/YomUV1j1gaA4O1YPCeEb6fMsFAa7RbVQ/LpnPqiJvl2FCocys/0raAfYZRkY4jy2DKNAqz8B0fr6HHHRlkEYkk2ikzANIaoKN+vDijCpUYpA0JOFwfg+dP9y0+84ZLrl+HcFwtvuRTOflshZBHBkEGgmit5Ob4yOjjHCslk4rM6d2xf37UM2etitp3aktAc/zFZm27HAjrupP0ErC/ZBwp8olIKigtzWmcTS1UJA3FUt2nKf3Qn4VLBUuqaHMe3CDPvs0dsP9lbl+8sd8o1lZaKb4pMUxVS1VDv7YXg25M3RGfXWD5NLoAdNb5MxHIMXAzm40IAzzVPbzx8OCwmgo7Bx/RneaxIZTFHBNiRN0O66JbEai6vu+LXRuKDu5QukF2DSE6wRD7vFP9tlTB7O37oSL5goLUcpcC2y6LiazWqCL8TauPlzSEq3GI9BVn5zv1BpS3yHppdGKFPY2hjkwZgM2JPj3EA7PQqdXpJCSc21qbsnvIwgXkgNlkRNMRduOo0v4R/eYsMPU4ou9upgO2BINZFlQ0U7Ys5eiy0d0RvdfdGI9N7whlwKZveCuUecEYqFVkYK8yYtAPm21K+0o/w1OdsHvnvi/Wg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(82310400026)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	b+ilIwAv++DZAlVAQlLM0x/3DqEjAUZ7K9Z2GWaIfkgMHitxG6y9p/fzGHVSE5++hlkrdRr3jQlujxa/2hy70DNJxwqrm+Xj5I1a7NKsC6PNKiMKygmQVznUh1ULpjTzLy3N/RN6/s9DfKErMSZDakNcxJlb4HfE1B1wACz94It3KAhKZ98gB2RHa5ss9T1Wqz9pZCNdLcnPZzE0VtM5RPvdhv/w9AE3UOAjdPAfEiagqotFtxCgO8AHxzY2r/QuGDlnqh0Bj56LoIBRTGpeHXgiiRIM7z+g0dNMKvWo0Or+Iz3+gheLEKBdNRyblxVnk/gAsg+qQKynXWogDwidMmvcm+dVmSPUwy/uS7wCh6s06GigKjjONbsDHSLH0Wgn55tHehYsrUUXKOEolgjpkXpsw46oAwN6v4vC7XlPrVzFkQ+de5V+oQCkzIJkihyB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:59:45.7437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c580a7-b90c-44fc-85f0-08deec6d6d12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291
X-Rspam-User: 
X-Rspamd-Queue-Id: 508AC40003
X-Rspamd-Server: rspam01
X-Stat-Signature: hc6uid5o8s7bnmbtemfj81x15sg5iffz
X-HE-Tag: 1785218391-77138
X-HE-Meta: U2FsdGVkX1+8eEWp9XGDo0QaAyEapAi61bPfnX4SiEBHL/uNmIsN3sXlrxaotpdOOA77Q2diFwxVp0tApeUCNMfldoG5Oy2R7fDgqoud0eMZDBJLNG1cuZy7liO/xjvE2Q0+N6LnNBNeCikUsgbDSMybFi2+6mDgyrWgVhyVNkhZLZQumzNpj3o4oOBuxsYaKxgUTBHlgRxB9aP4px6QrbIXIBxK0vZBEbiMCV5eVHO5kz2h8i53+YVghzfASIyd9atCtc009ieveAFpejkKpIigaumS6vx5Tj3QKTIMDAniPhhoiExO4kWqyjiUlu+DiZKPUz3pIocRqf+MxbMc8e88OEAAP2pwcI8NrVbvlEoC1DPIx1nGKG+eh6PrwozrBrA61AFUBwb1nphu1YKWRQLMUGnW51wTpcpVQEuv1y6W03us573Z2Tf4v119LuSyBcrB6/KCNqy9EFoFANprP+HSISx3pkQozYHW1bruzoNjFzEjkZ1VMwMlvJ9MHEFi4rGdLn4AxtM2cNHdzX/tB0n2zHohXRysytV0WbdG/deu0+XI4LK5VV0f6lr6cCv4Uo1FlUzcm5hgzG969MrXE5RB2BkD/hgEfphzzDb8PLhYUsThjFtyVr99vqhAc/JHox6ngf94nPzGfmV0CP7ho5MNH/cK5it8/pJ5aFN5jb++yw98pMwBYaOdNsCjhjzeFlc65IlsRAtGnPJW5jX5nRPP6sM3lRW1MCNclLD6xL2UC9jKXMPfEbgPSBngBaHnPPCzdy2+A2pHgYRbKgs+/iwy9wZplc1SdjgJtQvJhEWnO5RGJAP5uCgsheAguYwvWAddFFXaLxhnZuk+H84JCU69zwYlohnm2FvFR/UtscG9lKe+Guv5+mcCkOcT2DJ3e6i/eQk5Pl+ulj2g7BMsRT++ypOvYkDd8WZIdAkngKB4/vqmlYD9gB8c+bfRUTlPPnC9ARXaWEHFJjRnDN5
 q5ApgY0C
 s0OjTdvqI0fA3c6L4hnYsZmsGpQCPKLyUIUICEEzpPekyB53unQYQtZvuUQbBrQfErwLVpFuJCIMZ7qm0CX7xVtx60gsxlF2ahm3YSaDJOp3oqavKheO08L/N8nl2XAbuHW4xA1lGFt7CQ/jkAgWVw2M8B88EQoZDTOgOnGFt5lbMJkvhEoSsukiC9UE6tL3XpF+vUf+2MacHlneFSHkgKEHcbAPGbuzFKHvX/KpFkapeE2YepUWHI8dx3+FlS+CmDLh6xkkdwigj27imClHLne2qqtuuz+jtnlNDw/zIFL5g3cyic2IeFrkxb6m+b6iSR1nYrGNYSJ573pleabYIAdnt7fCcBc8Ra0Jgx3PBpTujzSQssgDui1MD0AWb/QiLuz6X0KwbpI7jaMOrgjzembQ3KJypTYC0usWxXnfIZ0BIWu7XD37GqhOwPzDNa+ngwt0J8CdHGWZyJ8XAvf8S3b+2+wfMyx+V4Yg3mrMRQis8I7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAS Parallel Benchmark BT (Block Tri-diagonal solver), MPI version,
Class F modified, run with 16 ranks. Compute threads are bound to node 1 via:

  /usr/bin/mpirun -np 16 /usr/bin/numactl --cpunodebind=1 \
      NPB3.4.4/NPB3.4-MPI/bin/bt.F.x

While class D uses around 24G of memory (which is too less to show the
benefit of promition), class E results in around 368G of memory which
overflows my toptier. Hence I wanted something in between these classes.
So I have  modified class F to the problem size of 768 which results in
around 160GB of memory.

System is a 3-node tiered setup: node 0 and node 1 are DRAM (CPUs),
node 2 is a CPU-less CXL lower tier (~252 GiB per node). Before the
measurement phase all provisioned memory (~161.4 GiB across ranks)
is migrated to the lower-tier CXL node 2. The ranks are then resumed
and measurement begins, so the run starts fully cold on slow memory.
This isolates the effect of hot-page promotion (node 2 -> node 1)
on a bandwidth/latency-sensitive workload.

Legend (kernel / promotion source)
----------------------------------------------------------------------
  A = base-numab0       Base kernel, NO tiering (NUMAB=0); reference
  B = base-numab2       Base kernel, tiering via NUMA Balancing
                        mode 2 (hint-fault driven promotion)
  C = pghot-hintfaults  pghot kernel, hint-fault source (NUMAB=2)
  D = pghot-hwhints     pghot kernel, HW-hint source (IBS memory
                        profiler); does NOT need NUMA Balancing

Table 1a - Runtime (lower is better)
----------------------------------------------------------------------
Metric                          A          B          C          D
----------------------------------------------------------------------
NPB Time (s)              7482.25    3306.81    3313.82    3506.55
Speedup vs A (time)          1.00       2.26       2.26       2.13

Table 1b - Throughput (higher is better)
----------------------------------------------------------------------
Metric                          A          B          C          D
----------------------------------------------------------------------
NPB Mop/s total          52305.50  118350.48  118100.13  111608.96
Mop/s ratio vs A             1.00       2.26       2.26       2.13
Mop/s ratio vs B             0.44       1.00       1.00       0.94
Peak prov. mem (GiB)       161.38     161.38     161.38     161.38

Table 2 - vmstat counter deltas (after - before measurement window)
----------------------------------------------------------------------
Counter                             A         B         C         D
----------------------------------------------------------------------
pgpromote_success                   0  42180536  42169996  39898316
pgpromote_candidate                 0         0         0         0
pgpromote_candidate_nrl             0  42180536  42169996  39899553
pgdemote_kswapd                     0         0         0         0
pgdemote_direct                     0         0         0         0
numa_pte_updates                    0  42250308  45027035         0
numa_hint_faults                    0  42182545  44119239         0
numa_pages_migrated                 0  42182543  42169996  39898316
pgmigrate_success                   0  42182543  42169996  39898316
pghot_recorded_accesses             0         0  44119239  40004334
pghot_recorded_hintfaults           0         0  44119239         0
pghot_recorded_hwhints              0         0         0 584209652
hwhint_total_events                 0         0         0 584209975
hwhint_dram_accesses                0         0         0 544195074
hwhint_extmem_accesses              0         0         0  40005074
hwhint_useful_events                0         0         0 584209652

Key observations
----------------------------------------------------------------------
Bottom line: hint-fault pghot reproduces mainline NUMAB=2 exactly,
while HW-hint pghot delivers ~94% of that performance with zero
NUMA-balancing overhead - a good trade-off where IBS is available.

