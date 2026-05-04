Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58713CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFCB6B009E; Mon,  4 May 2026 02:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0176B009F; Mon,  4 May 2026 02:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67FD6B00A0; Mon,  4 May 2026 02:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9C16B009E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:11:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A21B1A0A53
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:11:14 +0000 (UTC)
X-FDA: 84728714868.11.3F2A1DB
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010036.outbound.protection.outlook.com [52.101.46.36])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E591C0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:11:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q6pJbpyS;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 52.101.46.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfyzHsKdrGWVxDVJC9EADDiZQnMjSh3qHCeriVzIftY=;
	b=cZkUAZlmONf3eUXogruXmIitwtMKQDge3ZttTzLgenSAqbINFY8Lusr15/58cPbonWpFbB
	ncQhkgKy2DHYa4I+3zTw+tQO6UttrvInWFLidUn878G3AxmPIGltazxddS24zrMFGrvEpu
	5ZTO/AOxQb4Ph/92q4ZwecukU8vLYOQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875071; a=rsa-sha256;
	cv=pass;
	b=NKBniL+mVr6LSdY/a0XCmwg2ea7X6IqQTIqR0egtOKzRUCxeegD/u1Ev0siR3PtRW+4K7A
	2Tp3HijiWYlJFWXwmu9fD0/HCMRUQp7RagtGgWRgIDZAPs4k6JrxHj1kwWJTOKt/yU7nSL
	+FhnD5L40upGXJb88LPl5gKiuIvxhsc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Q6pJbpyS;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 52.101.46.36 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H65BvYbBbVY0T7Ty0RHy8vCVOh8YrnkK+DRp0xfkvhK9I63AGsYFeBc4SqKNRqlH9eGAGOETEblfXWNrkHaj9oXO0YuV0FZXPYoWAMIDHJWtRcIm/EUaCkbhz4u3LQ57rL7parf+p5ROwwyTLedEJcv40nSLtQw2S+lL8RZbTseZZYotu1UxKHuaeNT1TLtWim9Hh+eQpq5N63dJ/NThIrp0CsJZLbqFzmUFblf0DWLCde0cbzRXaeFzPF7N1kGI7YM+Chb03IeW9OoXJFZwvwTSstnyc5T7uSijFeAvMPGsNuFuRXsUyDU1SiSB5vDwQmNN4sAuMq/wtJcgVsN/QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfyzHsKdrGWVxDVJC9EADDiZQnMjSh3qHCeriVzIftY=;
 b=wUUpL8olE/8wvgFaIKdC4wxDG1SuwGOAnjTd7HjTEFkMgzjyfpqmuQmJARG2u+5e+gy6gdnvkZFtU5J/7ctnY7ZOzd1YKjJHKdK39BpHUacSPzSMWrcFt0u3/LnNx4/A5OkcvtdGzBDCMpfu8sjyJ04j1jcCiyQwURlRUGV5GLxXhye+S7Bdm/LQEmjQap/CeIdRcBOULn6aexfRGiTCX4iSjrgEOTGZ+cTcWyxuhN2tLI/0DS+YOwVwo6PQIrAVBH5CreG6OTz3wdGo4Mv5346+X70xzv/I2QxwZB1sU+UQD0efKoiwrbDBkkrCTgPlg20CjN7swr9TjCV6jWrNEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfyzHsKdrGWVxDVJC9EADDiZQnMjSh3qHCeriVzIftY=;
 b=Q6pJbpyS7cCj8TWaK9LmX0OBIGalc31/t223zXHt0cBsbvkMurJftAhglHOKRMhe3IdWewz4Dw0GYpCUePswCMCBG/rZD35odN7lyZKl5ICf3oIiCl7fcEEn5235pBbE22zP/7w+u4EvRravW1wfZHyLC9q8PTHdoLBJRs/qvFY=
Received: from CH0PR08CA0018.namprd08.prod.outlook.com (2603:10b6:610:33::23)
 by BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:11:01 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::53) by CH0PR08CA0018.outlook.office365.com
 (2603:10b6:610:33::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:11:00 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:52 -0500
From: Bharata B Rao <bharata@amd.com>
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
	<shivankg@amd.com>, <donettom@linux.ibm.com>, <bharata@amd.com>
Subject: [RFC PATCH v7 7/7] x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler
Date: Mon, 4 May 2026 11:39:24 +0530
Message-ID: <20260504060924.344313-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|BY5PR12MB4227:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc26799-cb6e-4d0b-670a-08dea9a3ea29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GdDBFGIRb8UeM6X6A6VMxGtX7Wy2Jk6FL2DyEfv0SwcGgkC2aefrtut5HhiepY8gYLLeP71YUyS6xsNX8F8jVDXSQSa0JgYhXMQd+EzjQGfvlpXLFmFGyYZiUp8YqDRzCkuthhwfy4cuRwRlz6Qvt+LpUaVKZpSR25e3fHeTEbVS2acGhufN7Q5bB+oDgXHJCobX9dcIsYxVOtoR9jOLd4YG7NGpxBMadsvFzijMi+me3VEoEPWt1nA7owS1WAVB7trh7gzotVpOFRlnRSkvXw2NHfifCxEfrY0ZhrK0idcBTrNMr3JWFsGhdEoDXtgDB1yauVljgjICqYpP+4JzHA5xK5mfcHo8NW/zq/XqL4BP+1D+HEshiC9m4CW+S+rrzbzk5EN/gCOopCNu41RNGxV7d9/xFJlgTaI5Gq+6Lb89AKHpJ1mBFxNhHVQMAbLOsulX6qxdkCLZXrdAoItAh6BwDGRRFcqM/9GKkk2BOEXrqS1dwNkBLVlhqZPv7HkT6eCH/KuFcHE+EYnDOZw9/ZaXjAd0NTlYLIzo9IT+dYvbZczbwyQdeWffhp4Pt43KkRCTBV+FTZarC0XLFJi89XETfJ+9GT1tZznrnsQl792N7sD1HUA8ZWyHEY4TrxhuaWOD6QrEW6RbR8VU0GinCGWetytJgcy+OT5vlVaZaKZXHLve+FYrV1+fE3NMQ8EvJR5Oy2uOxl77RdpGvCrYmh2kkbzIHynHi7KjTPrvHU0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PIbkGhrieQU4IAoKF/F6p14FBXZWpS9q8nLfqUUekMvTjIIMpQ7/rAHulLkR6Bqp8cnuoDmP6tW06n4NXpIScglFyAzR0zc2CSHPVr6bCw8CLpSfCB2p9Uf+UJkNpDgfot8h1uW4ZTv4iN2xAmcv6Zb1L5ATup3/nBqMf5ekfhTjqyLPBGvsne9/lr3E+etp+RzI5o7Glno1zVU6Wk/n8b6UYXJQoUDbqstmZLXzum7zeJeeLzm1I7tJ0RhLEE9x/OQFWFLEGrFBBPZ2xpUORU+1FzSlyMGy4fVsBsvKFuwcVJ7Llmh5+mpwli1V57Asr0QPpuYFVqxoF1gcRGUpaDgvxoz0R9Uyl54Fo5Lm/WwoYYoa0KTDbrFZQdSOIWmXNSBilJ6XZKcl25oPUwdFZbE8+O2nQH+csz86b+hz/Xx3kAoAUJpCDfsB7SI5k32Y
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:11:00.5930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc26799-cb6e-4d0b-670a-08dea9a3ea29
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E591C0005
X-Stat-Signature: c6tza5f3t6sp7rrc14okw9wg1bz961bx
X-Rspam-User: 
X-HE-Tag: 1777875070-329234
X-HE-Meta: U2FsdGVkX18PNTpirK8VJT6yZeTiQqKAjgGNQJ1+6pEOaOVfn1CmoUysuwYyfH//A8ZqLzK9S6Drf1Eattg0MFUUXKUpLs8D6ffA1frkDRFiajCHleQFErwzS+rhUZK5MAEzqQaiU008xKwd9cqNnRky+iDXDGWy1lucAOor7C/uUrAClnKfx1V6mwnZt4cpjaMVJVLM+CENkn7Ztkx+JryluT20Z33eYDaOh/J9O2S7W43rMwBsHcwUo3HTQvQaIL147elv2EwfbjOb79j2O7erElSzWOE7soci21km/18Yqx0lA21YJljRpA9xndYNt3m6HGzPG/NHrZ3JMQpP64O6l/m7JrGaG+4OX1miggQ2oFYFSmcj/PxileUbU2kPopZhAJVxBthL+YCX/4UtGG71N5CpXHgsDJUUq/qdI+8arPX0F6wc0aJEeDVmc4JRGf0Fzwimi8cQzDyvKLsUaagm0Tp5jEi6czu7Bfd/V+R1imte8dqzGdq+JpYv3OVza6/4gyKY/iP8P69H+sHBoIJ5xZYVHgBMOq+5pHGHB688F4sWDn80+m/YWNiUKrP4of9Rm7E1YEP+m3HD56Q9Xr9L+VwT9T7TBhdPKgHJS9OHuL7gQZwcC/z8SyarsDunKu0w/VFptaQZCFXwDoBi223HXmBFOppCQU4vWekpOnJ7eY+vRuq9RXIWKAkHvqsc+7Vdi/svN159kbr/4rgTdGLH4XBBWIZO0TWMTcjkUnkkrjLFmaQWnb/KPBRW26EDTmneHau9RvGGmWiW5Rv3o4fm6YvpnZ4sVvMfLcEDQSpaBG7igJHPyofNLkWunZX2V7GCY16ZMsyPlujGjBLI5slAd2ecXbIqKYkzJVwwhlFt+oVzo+4dpMvrFiQwOOcshDgbRpyyzzkrlARcgmhya+c6ZeTyCqY9ZYbIWFL1JLGaJqRe5BNtMzIbPbe0EKVTwS0Rra7huHro+An/0xA
 fg9rfy22
 xa2jy8kYztgFtnwTuS2cNA45qpaiVbiLFQZ5hSzThUhC45UrFZmfDrhZqS08eN6qcIsAH95D/jPS4+GIzfssM8y5fWNy53E1TM3C3JuNfqm5N3fkHlkBJczKP596DtuIA9k/YRTlcMcb5fCcYivPZUHZudTp0IcTzRu7mMX7VMPfKy6NSGnONAwPnZR9Z9G7duwEJxilyA7DDSgkPzzEPjaYXAgsewAeZ9mdPyK2G74gd3cfSunPtbV/YOTIuYPJH+SIfUwdiwspMYfZs8g8o1dNuMtsVtEsNHf5LFi+JEB/DIi+PX+bgzQb7kT5E86QRFz3eD5Qh/A7YAMaf1hpPeEaSbOdWSEshNqVBk7riNg3MbuKTM93E0NKLj1lRKMaa76xczHHvxBVItn8S+Zo+aRnCiZ4ESIZ2DhdGElspMFnUdW3aogiGHkXpzcbwODeBQeiQTzKUIjbJrqx3i0eHqrcX5cBdm44OL2cLZacrEZX4UNX6gpZHyP2bB37xAo/SQwchPh+9V5ONcB+Ij+abvhhjoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) Memory Profiler feature
present in AMD Zen6 processors for memory access tracking. The
access information obtained from IBS Memory Profiler is fed to
pghot sub-system for further action using
pghot_record_access(PGHOT_HWHINTS, ...) API.

IBS Memory Profiler as page hotness source is enabled by the
new config option HWMEM_PROFILER and is also gated by the
existing pghot_src_hwhints static key set via debugfs.

More details about IBS Memory Profiler can be obtained from
the AMD document titled "AMD64 Zen6 Instruction Based Sampling (IBS)
Extensions and Features".

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/Kconfig                 |  16 ++
 arch/x86/include/asm/ibs-caps.h  |   8 +
 arch/x86/include/asm/ibs-mprof.h |  46 +++++
 arch/x86/include/asm/msr-index.h |   8 +
 arch/x86/mm/Makefile             |   1 +
 arch/x86/mm/ibs-mprof.c          | 308 +++++++++++++++++++++++++++++++
 include/linux/cpuhotplug.h       |   1 +
 include/linux/vm_event_item.h    |   6 +
 mm/Kconfig                       |   9 +
 mm/vmstat.c                      |   6 +
 10 files changed, 409 insertions(+)
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 99bb5217649a..f06c0c44ecce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1514,6 +1514,22 @@ config AMD_MEM_ENCRYPT
 	  This requires an AMD processor that supports Secure Memory
 	  Encryption (SME).
 
+config AMD_IBS_MEMPROF
+	bool "AMD IBS Memory Profiler"
+	depends on X86_64 && CPU_SUP_AMD
+	depends on PGHOT
+	select HWMEM_PROFILER
+	help
+	  Use the AMD Instruction Based Sampling (IBS) Memory Profiler
+	  facility (present on Zen6 and later AMD CPUs) to feed
+	  hardware-observed memory accesses into the pghot subsystem
+	  for hot-page detection and promotion.
+
+	  When disabled, no IBS Memory Profiler MSRs are programmed and
+	  the corresponding NMI handler is not installed.
+
+	  If unsure, say N.
+
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/x86/include/asm/ibs-caps.h b/arch/x86/include/asm/ibs-caps.h
index ddf6c512c8f9..1f6c4058a0e3 100644
--- a/arch/x86/include/asm/ibs-caps.h
+++ b/arch/x86/include/asm/ibs-caps.h
@@ -29,6 +29,7 @@
 #define IBS_CAPS_FETCHLAT		(1U<<14)
 #define IBS_CAPS_BIT63_FILTER		(1U<<15)
 #define IBS_CAPS_STRMST_RMTSOCKET	(1U<<16)
+#define IBS_CAPS_MEM_PROFILER		(1U<<18)
 #define IBS_CAPS_OPDTLBPGSIZE		(1U<<19)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
@@ -42,6 +43,13 @@
 #define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
 #define IBSCTL_LVT_OFFSET_MASK		0x0F
 
+/*
+ * IBS Memprofiler setup
+ */
+#define IBSCTL_MPROF_LVT_OFFSET_VALID	(1ULL << 24)
+#define IBSCTL_MPROF_LVT_OFFSET_SHIFT	16
+#define IBSCTL_MPROF_LVT_OFFSET_MASK	(0xFULL << IBSCTL_MPROF_LVT_OFFSET_SHIFT)
+
 /* IBS fetch bits/masks */
 #define IBS_FETCH_L3MISSONLY		      (1ULL << 59)
 #define IBS_FETCH_RAND_EN		      (1ULL << 57)
diff --git a/arch/x86/include/asm/ibs-mprof.h b/arch/x86/include/asm/ibs-mprof.h
new file mode 100644
index 000000000000..91b1ce51d667
--- /dev/null
+++ b/arch/x86/include/asm/ibs-mprof.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_MPROF_H
+#define _ASM_X86_IBS_MPROF_H
+
+/*
+ * All bits are documented here for clarity even if the current
+ * driver doesn't use all of them.
+ */
+
+/* MSR_AMD64_IBS_MPROF_DATA2 bits */
+#define IBS_MPROF_DATA2_DATASRC_MASK		0x7
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH	0xC0
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT	0x3
+#define IBS_MPROF_DATA2_DATASRC_LCL_CCX		0x1
+#define IBS_MPROF_DATA2_DATASRC_PEER_CCX_NEAR	0x2
+#define IBS_MPROF_DATA2_DATASRC_DRAM		0x3
+#define IBS_MPROF_DATA2_DATASRC_CCX_FAR		0x5
+#define IBS_MPROF_DATA2_DATASRC_EXT_MEM		0x8
+#define IBS_MPROF_DATA2_RMT_NODE		BIT_ULL(4)
+#define IBS_MPROF_DATA2_RMT_SOCKET		BIT_ULL(9)
+
+/* MSR_AMD64_IBS_MPROF_DATA3 bits */
+#define IBS_MPROF_DATA3_LDOP		BIT_ULL(0)
+#define IBS_MPROF_DATA3_STOP		BIT_ULL(1)
+#define IBS_MPROF_DATA3_DCMISS		BIT_ULL(7)
+#define IBS_MPROF_DATA3_LADDR_VALID	BIT_ULL(17)
+#define IBS_MPROF_DATA3_PADDR_VALID	BIT_ULL(18)
+#define IBS_MPROF_DATA3_L2MISS		BIT_ULL(20)
+#define IBS_MPROF_DATA3_SW_PREFETCH	BIT_ULL(21)
+
+/* MSR_AMD64_IBS_MPROF_CTL bits */
+#define IBS_MPROF_CTL_CNT_CTL		BIT_ULL(19)
+#define IBS_MPROF_CTL_VAL		BIT_ULL(18)
+#define IBS_MPROF_CTL_ENABLE		BIT_ULL(17)
+#define IBS_MPROF_CTL_L3MISSONLY	BIT_ULL(16)
+#define IBS_MPROF_CTL_MAXCNT_MASK	0x0000FFFFULL
+#define IBS_MPROF_CTL_MAXCNT_EXT_MASK	(0x7FULL << 20)	/* separate upper 7 bits */
+
+/* MSR_AMD64_IBS_MPROF_CTL2 bits */
+#define IBS_MPROF_CTL2_DISABLE		BIT_ULL(0)
+#define IBS_MPROF_CTL2_EXCLUDE_USER	BIT_ULL(1)
+#define IBS_MPROF_CTL2_EXCLUDE_KERNEL	BIT_ULL(2)
+
+#define IBS_MPROF_SAMPLE_PERIOD	10000
+
+#endif /* _ASM_X86_IBS_MPROF_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a14a0f43e04a..c44b68940f43 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1315,4 +1315,12 @@
 						* a #GP
 						*/
 
+/* AMD IBS Memory Profiler MSRs */
+#define MSR_AMD64_IBS_MPROF_CTL		0xc0010380
+#define MSR_AMD64_IBS_MPROF_CTL2	0xc0010381
+#define MSR_AMD64_IBS_MPROF_DATA2	0xc0010382
+#define MSR_AMD64_IBS_MPROF_DATA3	0xc0010383
+#define MSR_AMD64_IBS_MPROF_LINADDR	0xc0010384
+#define MSR_AMD64_IBS_MPROF_PHYADDR	0xc0010385
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3a5364853eab..050a7379d9f7 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+obj-$(CONFIG_AMD_IBS_MEMPROF)	+= ibs-mprof.o
diff --git a/arch/x86/mm/ibs-mprof.c b/arch/x86/mm/ibs-mprof.c
new file mode 100644
index 000000000000..b3d59b21c8c9
--- /dev/null
+++ b/arch/x86/mm/ibs-mprof.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt)	"amd_ibs_memprof: " fmt
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+#include <linux/mm.h>
+#include <linux/vm_event_item.h>
+#include <linux/vmstat.h>
+#include <linux/cpuhotplug.h>
+
+#include <asm/ibs-mprof.h>
+#include <asm/ibs-caps.h>
+#include <asm/nmi.h>
+#include <asm/apic.h>
+
+#define IBS_NR_SAMPLES		150	/* Percpu sample buffer size */
+
+static DEFINE_PER_CPU(bool, mprof_work_pending);
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct mprof_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct mprof_sample_pcpu {
+	struct mprof_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+static struct mprof_sample_pcpu __percpu *mprof_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to pghot sub-system.
+ */
+static DEFINE_PER_CPU(struct work_struct, mprof_work);
+static DEFINE_PER_CPU(struct irq_work, mprof_irq_work);
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static bool mprof_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct mprof_sample_pcpu *pcpu = raw_cpu_ptr(mprof_s);
+	int head = READ_ONCE(pcpu->head);
+	int tail = READ_ONCE(pcpu->tail);
+	int next = head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == tail)
+		return false;
+
+	pcpu->samples[head].pfn = pfn;
+	pcpu->samples[head].time = time;
+	pcpu->samples[head].nid = nid;
+
+	smp_store_release(&pcpu->head, next);
+	return true;
+}
+
+static bool mprof_pop_sample(struct mprof_sample *s)
+{
+	struct mprof_sample_pcpu *pcpu = raw_cpu_ptr(mprof_s);
+	int tail = READ_ONCE(pcpu->tail);
+	int head = smp_load_acquire(&pcpu->head);
+	int next = tail + 1;
+
+	if (head == tail)
+		return false;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = pcpu->samples[tail];
+
+	WRITE_ONCE(pcpu->tail, next);
+	return true;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void mprof_work_handler(struct work_struct *work)
+{
+	struct mprof_sample s;
+
+	while (mprof_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HWHINTS, s.time);
+
+	this_cpu_write(mprof_work_pending, false);
+}
+
+static void mprof_irq_handler(struct irq_work *i)
+{
+	struct work_struct *w = this_cpu_ptr(&mprof_work);
+
+	/*
+	 * FIXME: pending samples on a CPU that goes offline before the
+	 * work runs may be lost or migrated to the wrong CPU's ring;
+	 * needs a teardown-time drain.
+	 */
+	schedule_work_on(smp_processor_id(), w);
+}
+
+/*
+ * L3MissOnly + Exclude kernel RIP
+ */
+static void mprof_enable_profiling(void)
+{
+	u64 mprof_config = IBS_MPROF_CTL_CNT_CTL | IBS_MPROF_CTL_ENABLE |
+			   IBS_MPROF_CTL_L3MISSONLY;
+	unsigned int period = IBS_MPROF_SAMPLE_PERIOD;
+	u64 ctl, ctl2;
+
+	/*
+	 * Assemble bits 26:20 and 19:4 of periodic op counter in ctl.
+	 * The lower 4 bits are always 0000b.
+	 */
+	ctl = (period >> 4) & IBS_MPROF_CTL_MAXCNT_MASK;
+	ctl |= (period & IBS_MPROF_CTL_MAXCNT_EXT_MASK);
+	ctl |= mprof_config;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, ctl);
+
+	/*
+	 * Exclude samples that have bit 63 of their RIP set.
+	 */
+	ctl2 = IBS_MPROF_CTL2_EXCLUDE_KERNEL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, ctl2);
+}
+
+static void mprof_disable_profiling(u64 mem_ctl)
+{
+	mem_ctl &= ~IBS_MPROF_CTL_ENABLE;
+	mem_ctl &= ~IBS_MPROF_CTL_VAL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, IBS_MPROF_CTL2_DISABLE);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int mprof_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	u64 mem_ctl, mem_data3, mem_data2, paddr, data_src;
+	unsigned long pfn;
+	struct page *page;
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	if (!(mem_ctl & IBS_MPROF_CTL_VAL))
+		return NMI_DONE;
+
+	mprof_disable_profiling(mem_ctl);
+	count_vm_event(HWHINT_TOTAL_EVENTS);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_DATA3, mem_data3);
+	rdmsrq(MSR_AMD64_IBS_MPROF_DATA2, mem_data2);
+
+	data_src = mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK;
+	data_src |= ((mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK_HIGH) >>
+			IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT);
+
+	switch (data_src) {
+	case IBS_MPROF_DATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case IBS_MPROF_DATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_EXTMEM_ACCESSES);
+		break;
+	}
+
+	/* Is linear addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_LADDR_VALID))
+		goto handled;
+
+	/* Is phys addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_PADDR_VALID))
+		goto handled;
+	rdmsrq(MSR_AMD64_IBS_MPROF_PHYADDR, paddr);
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	/*
+	 * Use the accessing CPU's node as the migration target. On
+	 * topologies where all CPUs reside on toptier nodes (the common
+	 * case), this is the desired behaviour. Topologies that place
+	 * CPUs on lower-tier nodes are rejected later by
+	 * pghot_record_access() via the src_nid == nid early return.
+	 */
+	if (!mprof_push_sample(pfn, numa_node_id(), jiffies))
+		goto handled;
+
+	if (!this_cpu_read(mprof_work_pending)) {
+		this_cpu_write(mprof_work_pending, true);
+		irq_work_queue(this_cpu_ptr(&mprof_irq_work));
+	}
+	count_vm_event(HWHINT_USEFUL_EVENTS);
+
+handled:
+	mprof_enable_profiling();
+	return NMI_HANDLED;
+}
+
+static int get_mprof_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrq(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_MPROF_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return (val & IBSCTL_MPROF_LVT_OFFSET_MASK) >>
+		IBSCTL_MPROF_LVT_OFFSET_SHIFT;
+}
+
+static int x86_amd_ibs_mprof_startup(unsigned int cpu)
+{
+	int offset = get_mprof_lvt_offset();
+
+	if (offset < 0) {
+		pr_warn("offset not valid on cpu #%d\n", cpu);
+		return 0;
+	}
+
+	if (setup_APIC_eilvt(offset, 0, APIC_DELIVERY_MODE_NMI, 0)) {
+		pr_warn("APIC setup failed on cpu #%d\n", cpu);
+		return 0;
+	}
+
+	mprof_enable_profiling();
+	return 0;
+}
+
+static int x86_amd_ibs_mprof_teardown(unsigned int cpu)
+{
+	int offset = get_mprof_lvt_offset();
+	u64 mem_ctl;
+
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_DELIVERY_MODE_FIXED, 1);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	mprof_disable_profiling(mem_ctl);
+
+	return 0;
+}
+
+static int __init mprof_access_profiling_init(void)
+{
+	u32 mprof_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	int cpu, ret;
+
+	if (!(mprof_caps & IBS_CAPS_MEM_PROFILER)) {
+		pr_info("capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	mprof_s = alloc_percpu_gfp(struct mprof_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!mprof_s) {
+		pr_err("alloc_percpu_gfp failed\n");
+		return 0;
+	}
+
+	for_each_possible_cpu(cpu) {
+		INIT_WORK(per_cpu_ptr(&mprof_work, cpu), mprof_work_handler);
+		init_irq_work(per_cpu_ptr(&mprof_irq_work, cpu), mprof_irq_handler);
+	}
+
+	register_nmi_handler(NMI_LOCAL, mprof_overflow_handler, 0, "ibs-memprof");
+
+	ret = cpuhp_setup_state(CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING,
+				"x86/amd/ibs_mprof:starting",
+				x86_amd_ibs_mprof_startup,
+				x86_amd_ibs_mprof_teardown);
+
+	if (ret) {
+		unregister_nmi_handler(NMI_LOCAL, "ibs-memprof");
+		free_percpu(mprof_s);
+		pr_err("cpuhp_setup_state failed: %d\n", ret);
+	} else {
+		pr_info("IBS Memory Profiler setup for memory access profiling\n");
+	}
+	return 0;
+}
+
+device_initcall(mprof_access_profiling_init);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 22ba327ec227..feaa3f571726 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -150,6 +150,7 @@ enum cpuhp_state {
 	CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
 	CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+	CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING,
 	CPUHP_AP_PERF_XTENSA_STARTING,
 	CPUHP_AP_ARM_VFP_STARTING,
 	CPUHP_AP_ARM64_DEBUG_MONITORS_STARTING,
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 58d510711bd4..a9c04a9735c6 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -179,6 +179,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORDED_ACCESSES,
 		PGHOT_RECORDED_HINTFAULTS,
 		PGHOT_RECORDED_HWHINTS,
+#ifdef CONFIG_HWMEM_PROFILER
+		HWHINT_TOTAL_EVENTS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_EXTMEM_ACCESSES,
+		HWHINT_USEFUL_EVENTS,
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index cc4b5685ecd4..674cfcea7bb0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1494,6 +1494,15 @@ config PGHOT_PRECISE
 	  4 bytes per page against the default one byte per page. Preferable
 	  to enable this on systems with multiple nodes in toptier.
 
+config HWMEM_PROFILER
+	bool
+	depends on PGHOT
+	help
+	  Umbrella symbol enabled by any in-kernel driver that forwards
+	  hardware-observed memory accesses to the pghot subsystem (for
+	  example AMD_IBS_MEMPROF on x86_64). Drivers select this; users
+	  do not enable it directly.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmstat.c b/mm/vmstat.c
index da668ff05032..06e7ae06519e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1493,6 +1493,12 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
 	[I(PGHOT_RECORDED_HINTFAULTS)]		= "pghot_recorded_hintfaults",
 	[I(PGHOT_RECORDED_HWHINTS)]		= "pghot_recorded_hwhints",
+#ifdef CONFIG_HWMEM_PROFILER
+	[I(HWHINT_TOTAL_EVENTS)]		= "hwhint_total_events",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_EXTMEM_ACCESSES)]		= "hwhint_extmem_accesses",
+	[I(HWHINT_USEFUL_EVENTS)]		= "hwhint_useful_events",
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
-- 
2.34.1


