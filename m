Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98BEFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF276B0098; Tue, 28 Apr 2026 11:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5B86B0099; Tue, 28 Apr 2026 11:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC446B009B; Tue, 28 Apr 2026 11:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 379B96B0098
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:54:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C80D81B95F9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:54:27 +0000 (UTC)
X-FDA: 84708411774.24.0FE74FF
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id B16B618000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RJDWg4Xq;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nljV61LSXhzqhBC1urFr4hQnCE/si+5O1JBTyx/owO8=;
	b=UUDpN8rn+lTtPokjMAVLGy9HZKR34T1N/7fGFyNNch2t0/N3fBFo7bXah7K46Iqxr7eXkj
	BS99EOARpt2yexPVMzHY8z2kPu+2UGPq7rJYuuBoTBc9mwgpF/AlwqpkNYqXpqj4MkJKBh
	ncNROEsCFxSoVySNKGECdllmEC0fgKw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RJDWg4Xq;
	spf=pass (imf16.hostedemail.com: domain of shivankg@amd.com designates 40.107.201.3 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777391664; a=rsa-sha256;
	cv=pass;
	b=JAQbLz7rRjlDKe/yfhcOlXt+CCuukZzaTBGV+q62hb5dlvWWP/YaON3otDwSkGtMT3q+vA
	cpiczQK9KfjuO96/7ezo+MVsbJlAaN0N3DlxIvFy5akPvVoNPe1oZyb5rUwsrLMquRFc0/
	CGIotyXLa2o9kHfxLCaQLJ11Zl5wUQM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tk2N2YPRRJkeyLINY0Dgw+YRVDCnH0oZi5J9Ul6QhsYTjl+GPeNw2HCDiNa755+kNausuR3MM7+BH7LQTzfRtRXU9JMpH/ULCjl3OCQMeQr3nXQA/D4YETBYfrTPssP3hMKNWdns2+1JkknN5GKQrcg3PjwO3bc4L75EgVLMRP5QqBbbd0wLNq6wOxDjefNA79n+4alt9vpa99ODj6zihxUCX3BStVWR5Bzm2xABxSwn/eefjfvtSKg4BiITWyLqwjUP2deZqhjXurJ87ll6jp8bc6BbiNpPJKqqFVZOewgQhDtrsypa5VyEvlPWez6rdSPwr8rnS8CmXJBlJDISKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nljV61LSXhzqhBC1urFr4hQnCE/si+5O1JBTyx/owO8=;
 b=mlcBbRRCnWaH+AzveqUGMyev+PCfjzwu15Ek+JYC+stwfq0sSdyN0aYPc2u01pyFYl5UEyuIRS2C5S6H32+ACY7f06CDRwVl+nGxyOodY+UHVuywvQJIguuqBcvWLtVgTFUIOWJ2g706xwitSXJaNtwRXplQkMIncdGbDcIDjzFZRAoBgO+D9NCNCXafcGpCF6SSHSLEjTP2eRZ/zRvxNu0G5hfNjjKY0wkdhFYZ5jsoITRJavGpAk5WB0rHh6DUiNqMAzCKOXfJWhHps6f+KiJZnzxWHIGWQVHdjuFpua3HC0SlPWNs0BzR/JrJrPUzDxAonj99uZ5z5j1hYWDPRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nljV61LSXhzqhBC1urFr4hQnCE/si+5O1JBTyx/owO8=;
 b=RJDWg4Xqs2jAUTs5to12Fhb+8wnOHduzJMusemPjtLYmQCuLvtBL4KRndvt79/ABt3Vt8Eg2/BPVZTgUaVJlixQ327B78Cp41aIx144QbYL5dIylZolwH5hnEH9BtTtjaw891ct+1YD5v92YBxvYPjmGX+bYDRmfGEMIC6K9SNk=
Received: from BL1PR13CA0071.namprd13.prod.outlook.com (2603:10b6:208:2b8::16)
 by CH3PR12MB7715.namprd12.prod.outlook.com (2603:10b6:610:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 15:54:10 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::ec) by BL1PR13CA0071.outlook.office365.com
 (2603:10b6:208:2b8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Tue,
 28 Apr 2026 15:54:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Tue, 28 Apr 2026 15:54:09 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Apr
 2026 10:53:56 -0500
From: Shivank Garg <shivankg@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <kinseyho@google.com>, <weixugc@google.com>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <dave@stgolabs.net>, <Jonathan.Cameron@huawei.com>,
	<rkodsara@amd.com>, <vkoul@kernel.org>, <bharata@amd.com>, <sj@kernel.org>,
	<rientjes@google.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<dave.hansen@intel.com>, <hannes@cmpxchg.org>, <jhubbard@nvidia.com>,
	<peterx@redhat.com>, <riel@surriel.com>, <shakeel.butt@linux.dev>,
	<stalexan@redhat.com>, <tj@kernel.org>, <nifan.cxl@gmail.com>,
	<jic23@kernel.org>, <aneesh.kumar@kernel.org>, <nathan.lynch@amd.com>,
	<Frank.li@nxp.com>, <djbw@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Shivank Garg <shivankg@amd.com>, Mike Day
	<michael.day@amd.com>
Subject: [PATCH 5/7] mm/migrate: add copy offload registration infrastructure
Date: Tue, 28 Apr 2026 15:50:47 +0000
Message-ID: <20260428155043.39251-12-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428155043.39251-2-shivankg@amd.com>
References: <20260428155043.39251-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|CH3PR12MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e449f8-45ac-431d-565c-08dea53e62f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|82310400026|36860700016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XH6ktHeLnbIFMXhfQn36RfXHuma+Xr7Mf59sdHcUlKE4XvKV6ZJY+vYE7ZgF9Bal6jl/Nu08IjX+4AHAaeFgQn6zmSoUtynBMHgEmgPfLgnJjzYOYInOoiDC481DQABG7OuvJFgxJx9WaP7FZjAnKcvHgcSdKogqMFbVF/jYgUZXQA3BZZZOCUdM9uJzuKONeuqgQasYuOFK2aRvPehWDREVK1dz6fqkGgrRiA9OVVkkeBdVkSkyr6OZ21qKbFyixRugpS+/CD6YUhnhdD+Li2C/EQKz4bWlQ6MMN56cwI8lOVTXEhQ1/qnMEEQJ08pyxEhlE5MklaS4RqaxTiFJ6+SrW/CcJt+PZ8rXUJeZLrIjPV4dh/mVAz71DNBeRUXjQM8EbWQt2Ns7A/6X5EXDFddcJJnOAYl5YvZn8aUUcbyUVNLXDKsbdJemj7L/MI2dZayKyD/YMd/4JNpiE/8+GkzN1sW31pRaMzhtbBKzPg/NbJDwbSFCMC4L7Hd2jrekOpr8VjM5VSsvHjtppLadwahne+qxECVk3RAZzJL9OcvGbbjtm+Ih8Cf8BtDyw3w6ADII82QKp+plCPjDCjENPdGB5cBB+Hr9o4yGs4zH1mIhZjZWB24i9pfG0WJ2Cu77D5T5LvWA0We4rRcti9zswD7QAvR6LrqFICWebENl53etw6u7rhV5VizdfO6itj4lGtloRwTxb+f0NWWsBkcC23WiAePfFFoqKjZKs4IfqvP+61Q7o7g+LcyHku7ahesd6qg2JXAhCYVfWK/MempoEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(82310400026)(36860700016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qZZDn8hzIxRrMr6Jzp7YyBRcFOi0STRPK8HPTUVamIFOQkkqYxnHI9e0+v92FMrn4vx8hi5YNrVi5PDZjxCrkDH4/UXcpilBiEWkNJTOh6eUpZez3s1OpLggrfj0VquPTH8CDgyKzTdk8JyWqLpF4Q6xxkT1+DI77ehtqHpIyr9gfeamPbO+tFXqqoWZ2ri+CzMzdAkpmiqmlPZpXwXnMHhbPgvT/q9y8i5WXLkvKx+gDva7J/k5mcEpR/I8e/N/6bSPEcrf/uB3fFGs81YOa5Qxu47dy1TAdd7zIzmPrrWkShbAvroIEwI87DhMmSiuOqcJX3mJ1EgJ87YBsSC/fmK8yHYZZpZzJOlLtRKBR/ggkxncH71qhUAS0ThjfOsG9GgE7VuQTNcVnl4Jm3VMcgGZqDzBO8fYT36s1XMq64IgVZivNhMo2Zbm7O2fr+fs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 15:54:09.9422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e449f8-45ac-431d-565c-08dea53e62f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7715
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B16B618000C
X-Stat-Signature: motu7tn3paj9nte6n5b8id9gak6gb5hh
X-HE-Tag: 1777391664-538653
X-HE-Meta: U2FsdGVkX195pUemtTVyT9cpP0WMLuGRW6oFsct5ib305dxCQf2hsOxlTv5n2nVetvFor/gEgkxLd+cJ4Ml1eRbG/kvXgY8UDt+nPnjSkMgJiWhy6oWEqVQ4VoqlGr0NXBmLisupeqP7l2CmSeV+AZCyV/SW+ozZr9QSFkXEBow/7a3wjmgZPGs9vVgXMImxH4DTesV11bee4qZAeIwatZxlxAtM39++0NtMiToYqTwhsHLH34KMyAVjuotjrHBhe8ntZBVSmHjaT0JHKoVWYbV8ckfWsY7WSCGMbB9RQ2/NBBxzv4dzrs9/AXUwMWh1rwJnaZU/OpltMBACiFltmZ1ARoDE4SVzA3snTd4ZXTOm4zQkyt5EU84KRutpazFeYUMJSNiLVVrd3noH4yvB7wtLyiLfbGZ/pbbIgtkVJBSrb8r3NxfprXypCpFSX+E0cmfSO1JDLJYnyJOWtAqnFpRUEHBNHNZ9xsyeifCnMuzubUAAHgY2J4rqdSjq0gsWIayHjpsjXGfSQuSA4t7JjnZsR+B9phXWg21RZEWbzuSwClh2CJ5kCo0Xv2kERv3ZiZiIT5uEQRH9YHYtcuPx13gMYLL2ajjCj0f4elNmoK9pXyb1Pd5FwxEdbaZiiN+0OGRdOva/0yR+UWNWcULGULNZH9ZuWlp30JVfZC5bowDPrXPvcxSr2Bp/nqJv1Qz8NRAVdF4cb0eiD73m+gVJl1oteYKgkeG9ijdP+tdGLSc7zrEEEN4DHx7M4TfljPqArT91SkjSEmi02hhdN1MnLSwnjlD0tx8NTorRTG2QQyUG/b3L1MISoHEmlwmqMHxwmJYB8x9dkwRble7QLznnHPHH+fV6kF9b7DcC6BaoZ2WF4rrHHu3PCrZ614jUun9OLx19vMFoTaRmMg9/5nwyRoh2v0FkN6k3ylP0TrUizId//dtA8yq/6+tL2r6W1bR2a/40oY7wvvYCiwa7Lf6
 PsA4k5/P
 jU/gsEZzJPDaLfde56WFXchlHA7w32/QfNhOYHtPH21dgB5aMMGV2a1jgcti9WzoIHIb15htblvXRCgSb6QiG8N60Dw7+YJ17VTXR0bif5CHyTB4UEn3RAUaXuvxN5BNV1/JjwYjK8yPTD91ZK9s/CmdHTNrvLJ7nQuo7v9hia+VZdHNLOydjEIXXXDynyk4mLd94QMe9uAQTRz9gLsm8jiPqINPEkTWeYTuwT0358f8F9omVGfm6zBBIJ9WX2TzEy+FVnD27OHb/QjP1/h8jDly1ja082wGCCbTIlFUsaGh14nGRhGV1FC4eEaL4X8U0uJrYBbrcfmmAF8x9OTbR8FYJCILBQTbehl896XejdQCRy+YJ2IIpShPeNE7AiOkqK/8NqlsctNd/f9Gt8pCSnYQr2UCnKAiotax83W/1jKnnInPsncwl1I1vSQUytnVFea9vi1uZC0hQGkEjKFo9G2ZFLlX2MJlgfaEougckecW7zaoSlpJOjkOyLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a registration interface that lets a single offload provider
(DMA, multi-threaded CPU copy, etc) take over the batch folio copy
performed by migrate_pages_batch().

The provider fills in a struct migrator with an offload_copy()
callback and calls migrate_offload_register(). Registration patches
the migrate_offload_copy() static_call and flips the
migrate_offload_enabled static branch. The migrate_offload_unregister()
reverts both.

Whether a migration reason is batch-copy eligible is decided by the
core in migrate_offload_do_batch(). A migrator may decline a particular
batch (e.g. when nr_batch is too small to amortize setup) by returning
-EOPNOTSUPP, and the move phase falls back to per-folio CPU copy.

Only one migrator can be active at a time. A second registration
returns -EBUSY, and only the active migrator can unregister itself.
The static_call dispatch is protected by SRCU so that the
synchronize_srcu() in unregister waits for all in-flight copy before
the module reference is dropped.

Co-developed-by: Mike Day <michael.day@amd.com>
Signed-off-by: Mike Day <michael.day@amd.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/migrate_copy_offload.h | 44 +++++++++++++
 mm/Kconfig                           |  6 ++
 mm/Makefile                          |  1 +
 mm/migrate.c                         | 57 +++++++++++++++--
 mm/migrate_copy_offload.c            | 94 ++++++++++++++++++++++++++++
 5 files changed, 198 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/migrate_copy_offload.h
 create mode 100644 mm/migrate_copy_offload.c

diff --git a/include/linux/migrate_copy_offload.h b/include/linux/migrate_copy_offload.h
new file mode 100644
index 000000000000..d68b10a84743
--- /dev/null
+++ b/include/linux/migrate_copy_offload.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MIGRATE_COPY_OFFLOAD_H
+#define _LINUX_MIGRATE_COPY_OFFLOAD_H
+
+#include <linux/errno.h>
+#include <linux/jump_label.h>
+#include <linux/srcu.h>
+#include <linux/types.h>
+
+struct list_head;
+struct module;
+
+#define MIGRATOR_NAME_LEN 32
+
+/**
+ * struct migrator - batch-copy provider for page migration.
+ * @name: name of the provider.
+ * @offload_copy: copy @folio_cnt folios from @src_list to @dst_list.
+ *
+ *	The migrator may inspect @folio_cnt to decide whether the batch
+ * 	is worth offloading, e.g. skip when the batch is too small to
+ * 	amortize setup cost. If returns error, the core falls back to CPU copy.
+ *
+ * @owner: module providing the migrator.
+ */
+struct migrator {
+	char name[MIGRATOR_NAME_LEN];
+	int (*offload_copy)(struct list_head *dst_list,
+			    struct list_head *src_list,
+			    unsigned int folio_cnt);
+	struct module *owner;
+};
+
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+extern struct static_key_false migrate_offload_enabled;
+extern struct srcu_struct migrate_offload_srcu;
+int migrate_offload_register(struct migrator *m);
+int migrate_offload_unregister(struct migrator *m);
+#else
+static inline int migrate_offload_register(struct migrator *m) { return -EOPNOTSUPP; }
+static inline int migrate_offload_unregister(struct migrator *m) { return -EOPNOTSUPP; }
+#endif
+
+#endif /* _LINUX_MIGRATE_COPY_OFFLOAD_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index e8bf1e9e6ad9..325d79619680 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -647,6 +647,12 @@ config MIGRATION
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
 
+# Page-migration batch-copy offload infrastructure.
+# Selected by migrator drivers (e.g. CONFIG_DCBM_DMA).
+config MIGRATION_COPY_OFFLOAD
+	bool
+	depends on MIGRATION
+
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..db1ac8097089 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
 obj-$(CONFIG_MIGRATION) += migrate.o
+obj-$(CONFIG_MIGRATION_COPY_OFFLOAD) += migrate_copy_offload.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
diff --git a/mm/migrate.c b/mm/migrate.c
index 6c2f1cb66f96..9af070f9a1f2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -44,6 +44,8 @@
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
 #include <linux/jump_label.h>
+#include <linux/static_call.h>
+#include <linux/migrate_copy_offload.h>
 
 #include <asm/tlbflush.h>
 
@@ -54,6 +56,51 @@
 
 DEFINE_STATIC_KEY_FALSE(migrate_offload_enabled);
 
+#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
+DEFINE_SRCU(migrate_offload_srcu);
+DEFINE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
+
+static bool migrate_offload_do_batch(int reason)
+{
+	if (!static_branch_unlikely(&migrate_offload_enabled))
+		return false;
+
+	switch (reason) {
+	case MR_COMPACTION:
+	case MR_SYSCALL:
+	case MR_DEMOTION:
+	case MR_NUMA_MISPLACED:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int migrate_offload_batch_copy(struct list_head *dst_batch,
+				      struct list_head *src_batch,
+				      unsigned int nr_batch)
+{
+	int idx, rc;
+
+	idx = srcu_read_lock(&migrate_offload_srcu);
+	rc = static_call(migrate_offload_copy)(dst_batch, src_batch, nr_batch);
+	srcu_read_unlock(&migrate_offload_srcu, idx);
+	return rc;
+}
+#else
+static bool migrate_offload_do_batch(int reason)
+{
+	return false;
+}
+
+static int migrate_offload_batch_copy(struct list_head *dst_batch,
+				      struct list_head *src_batch,
+				      unsigned int nr_batch)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 static const struct movable_operations *offline_movable_ops;
 static const struct movable_operations *zsmalloc_movable_ops;
 
@@ -1833,7 +1880,7 @@ static int migrate_pages_batch(struct list_head *from,
 	struct folio *folio, *folio2, *dst = NULL;
 	int rc, rc_saved = 0, nr_pages;
 	unsigned int nr_batch = 0;
-	bool batch_copied = false;
+	bool do_batch = false, batch_copied = false;
 	LIST_HEAD(unmap_batch);
 	LIST_HEAD(dst_batch);
 	LIST_HEAD(unmap_single);
@@ -1843,6 +1890,8 @@ static int migrate_pages_batch(struct list_head *from,
 	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
 			!list_empty(from) && !list_is_singular(from));
 
+	do_batch = migrate_offload_do_batch(reason);
+
 	for (pass = 0; pass < nr_pass && retry; pass++) {
 		retry = 0;
 		thp_retry = 0;
@@ -1984,8 +2033,7 @@ static int migrate_pages_batch(struct list_head *from,
 				nr_retry_pages += nr_pages;
 				break;
 			case 0:
-				if (static_branch_unlikely(&migrate_offload_enabled) &&
-				    folio_supports_batch_copy(folio)) {
+				if (do_batch && folio_supports_batch_copy(folio)) {
 					list_move_tail(&folio->lru, &unmap_batch);
 					list_add_tail(&dst->lru, &dst_batch);
 					nr_batch++;
@@ -2017,7 +2065,8 @@ static int migrate_pages_batch(struct list_head *from,
 
 	/* Batch-copy eligible folios before the move phase */
 	if (!list_empty(&unmap_batch)) {
-		rc = folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
+		rc = migrate_offload_batch_copy(&dst_batch, &unmap_batch,
+						nr_batch);
 		batch_copied = (rc == 0);
 	}
 
diff --git a/mm/migrate_copy_offload.c b/mm/migrate_copy_offload.c
new file mode 100644
index 000000000000..6f837c725239
--- /dev/null
+++ b/mm/migrate_copy_offload.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/jump_label.h>
+#include <linux/module.h>
+#include <linux/srcu.h>
+#include <linux/migrate.h>
+#include <linux/migrate_copy_offload.h>
+#include <linux/static_call.h>
+
+static DEFINE_MUTEX(migrator_mutex);
+static struct migrator *active_migrator;
+
+DECLARE_STATIC_CALL(migrate_offload_copy, folios_mc_copy);
+
+/**
+ * migrate_offload_register - register a batch-copy provider for page migration.
+ * @m: migrator to install.
+ *
+ * Only one provider can be active at a time, returns -EBUSY if another migrator
+ * is already registered.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_register(struct migrator *m)
+{
+	int ret = 0;
+
+	if (!m || !m->offload_copy || !m->owner)
+		return -EINVAL;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	if (!try_module_get(m->owner)) {
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	static_call_update(migrate_offload_copy, m->offload_copy);
+	active_migrator = m;
+	static_branch_enable(&migrate_offload_enabled);
+
+unlock:
+	mutex_unlock(&migrator_mutex);
+
+	if (ret)
+		pr_err("migrate_offload: %s: failed to register (%d)\n",
+		       m->name, ret);
+	else
+		pr_info("migrate_offload: enabled by %s\n", m->name);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_register);
+
+/**
+ * migrate_offload_unregister - unregister the active batch-copy provider.
+ * @m: migrator to remove (must be the currently active one).
+ *
+ * Reverts static_call targets and waits for SRCU grace period so that
+ * no in-flight migration is still calling the driver functions before
+ * releasing the module.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int migrate_offload_unregister(struct migrator *m)
+{
+	struct module *owner;
+
+	mutex_lock(&migrator_mutex);
+	if (active_migrator != m) {
+		mutex_unlock(&migrator_mutex);
+		return -EINVAL;
+	}
+
+	/*
+	 * Disable the static branch first so new migrate_pages_batch calls
+	 * won't enter the batch copy path.
+	 */
+	static_branch_disable(&migrate_offload_enabled);
+	static_call_update(migrate_offload_copy, folios_mc_copy);
+	owner = active_migrator->owner;
+	active_migrator = NULL;
+	mutex_unlock(&migrator_mutex);
+
+	/* Wait for all in-flight callers to finish before module_put(). */
+	synchronize_srcu(&migrate_offload_srcu);
+	module_put(owner);
+
+	pr_info("migrate_offload: disabled by %s\n", m->name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(migrate_offload_unregister);
-- 
2.43.0


