Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E3EEC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC3D6B0089; Mon, 23 Mar 2026 05:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C45C6B008A; Mon, 23 Mar 2026 05:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAA16B008C; Mon, 23 Mar 2026 05:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEB76B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:51:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED70613BFC3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:56 +0000 (UTC)
X-FDA: 84576861432.11.4589865
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id C81CF40008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:51:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZGX6S6Bx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.48.7 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIcjakd4JDTQOgrx3Q7lwrKhTaLitnBcqdfcfsLenks=;
	b=a1uCDoyxOc1ljzb9UPqtw/8GgT9ihOWY+F6ol2PJR29rFHqKUI75XxHGR2FFH41pL7Kh8O
	CL2GeB/74+xuxxwRHm8phpAC9XW0gn4spxVjSmIARwfbc9e2YEX23ne6AiJUwu3/sunTxy
	RAeuOhfYrgbWisdJbI936pj/KhckaC8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZGX6S6Bx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf12.hostedemail.com: domain of bharata@amd.com designates 52.101.48.7 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259514; a=rsa-sha256;
	cv=pass;
	b=w4Fe7ugni9dX/TANbnGE77JVLcw7IXWMA4JLo6V7NwZvttA2YDZIeIZR57gk071a7fOiEU
	ThHyQEj9ZEEGdePDl2TIMy/0r26FYmeFcwlaXizS7wu8UxMoRLZNJwJoE5+HnIGYx/ssVm
	zZRtaDU4Pdsbo4NhlQrAOq4V9p95vRM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cV5Hda47gfi3fJhNp8BVJlxy+WPdEv8QO3r9fJrff4sZHsRsG/RXb4jFBnIJYLiF/TfpcESYSEujI7VcRKGyBfS0TPwRhghTh5bbTI/wn7om7sBu9UrK+gzE1oKktaQ8euJoGop+5k6IMHqtOfyz8yfToY5y9J9/BDxwIDr2tgkLkYC+TyXc2AB0t3orDt/8AuAGw5BDo13TEm32hAYlQyw7an1cv4BsJqkTNHXJbLYRs6FllBlakXtI92l2FQXXb+EdnWuEFzq9/kCw7dwGnA04esKNDYuMPIdDBuAzV69ZHVOn+QaJIrsDMF0lVNIAeK0Gby2lO9bugIaeAQgJyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIcjakd4JDTQOgrx3Q7lwrKhTaLitnBcqdfcfsLenks=;
 b=KMrfVBhDbZEdW/hc5aT9HkN9/0QNpWySq3+OqUga6O82mLYzow4a3xkuK6o75k/vYcvtzOR0qjhOz6YBb1NUrft/nIjjnk5PVS9c373q70NPi3yhLTdqmN1jsn1VV3i+2Cm2W6G3QimfvZJ0dDk55qFeRGaXPvWueu6GxAb+V8URVJQ2a4THdxJCw/VKvAbpUj8I253JCrYxlt/13FawTshiThp6HrCxq2SLL/exHDESBFaQiCcNwNWOb018Ra1K8+4vFISzRlV77rZH3MwYnpcj58sIpYswqAnt3zHfV+WvdQibwV83q3GkLzaqPr6+n9ppFblGDwFC3K7zWu0GyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIcjakd4JDTQOgrx3Q7lwrKhTaLitnBcqdfcfsLenks=;
 b=ZGX6S6BxzQznT62jmvvVpWMAnHlWoQI5kVOc8zHJczalWvH4KsTLz/HeLuFBUqLt/OWwbF28aY+3WNZr0gjE6Qf45xDxC6T207Z9a0rYsE8CKCkxUBn6dwgskSPOcxXhxdlsuP73hu8mnLO2rWg34+Wbrd/uqbrQ00eAMOBzxDA=
Received: from CH0P221CA0039.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::21)
 by IA4PR12MB9761.namprd12.prod.outlook.com (2603:10b6:208:550::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:51:49 +0000
Received: from CH2PEPF0000009A.namprd02.prod.outlook.com
 (2603:10b6:610:11d:cafe::3b) by CH0P221CA0039.outlook.office365.com
 (2603:10b6:610:11d::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:51:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009A.mail.protection.outlook.com (10.167.244.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:51:48 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:51:41 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <bharata@amd.com>
Subject: [RFC PATCH v6 2/5] mm: migrate: Add migrate_misplaced_folios_batch()
Date: Mon, 23 Mar 2026 15:21:01 +0530
Message-ID: <20260323095104.238982-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009A:EE_|IA4PR12MB9761:EE_
X-MS-Office365-Filtering-Correlation-Id: 94bf9251-7dbd-44e2-fce8-08de88c1cd5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9LD7FEsQBe1u2+fp4qBx36QBS4rYMOR08vROi2Hu8c375pqNG12UPihXd4N8EqM6936KIBF2X6yg84+CDVIA2ItnAsRMNBXZPfjCyxhv0oW4mvpr78kJq3BkfPu3dq258zTc4RdOMhMO704tQ2Uhg34nz8bvbrcZrflqbbNwMF+t9E1iQ+90dj6+qa3S96E9os6iMF48/zybzArZdvZ3N5kgUrBsxYFXx2tODpmgvkNhcbkyjD7gNX/N/6TT8mNR8Yrms6mLZLMa+pxxHz7hU4gpTLt9M6mXzBh8grWo1VJJ0z4CjQuJfwbU59/C46bOzjgUKA0TyeOEFeIuGHLOaaauxQKyvkfwBGxYfiBcLJL4lVPuBFKA0F7i2iuv9bs0XxqbjAtEUC1NCxFg+2FSj88qoS8i0/LOy+5lB8RWFCo4MuKi2E3TbG0HCsNffxZ7ZJEof//NuduJPZyaBEC65J2dnhQDlbsijaT64q/swpYTgon8utWXqH5fN33DuMRfiJq5xtRWC263xSKUhfxDsY8Bv1CESf/ZqHs294Poje8ssg3RaiIIgM7sl4YlI7Fdpm/pJDJxgXDP6YSwPu16FdC2A+8p+NvaO2YLPuZMBn1QiJ3weThH1VVvef4Ak9HB5WXqmJJ82ocNTEbhr7513MOCY8qL4ar19MjeD1Y4LCB4FnwwUt6o0mKE4LuoOA/CI76DPLU1+qpM33ECwg4RogVwyxvJPhNXFlRGd6JQCzIeWDdUdsi9UW5CkYcKuu95L8zG57QbDcvchW97HpGKxg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	a9APMK6EB36du1JOR1gkV/XkwnG9HCtuzyPa5QyOH6dfDHM84Rp9Nov5YUwm2t/OTlznpojmXhLoFbPEdy5P2GTFf2P9Lew/6RGFJSZvM9JmI/8s/tiw87YpGSGcNlri7+EBSLBse+UJKmChR+G7Plk9ON0ym241v4rb4Kb2WVqHh99OcUxw+ivMGuoQNnGNBDH7bHrglmUV5otesWGyJHDJg8uZDIsL7gvoUPjHO9pikpDdvCr0qXEAfmkcwJFt0238f3vhiT68tnGqJuqFPYOZ87ZYYMUEfNPhZz6eR2uN8W+eMGa9nb0B/y/GAO0J4MXRiiqzOCiPwIHQFIcQ0Va4mq4Q5stpqEGIJ8DreNWAV/1MoDSuQQETW+mtBUXtBposF5zx5Ip5fD4KuVQ0ckKZbfiEo8OKR1rKaz3FvYHztsSy3V9IAvTlTJs6tdJZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:51:48.8266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94bf9251-7dbd-44e2-fce8-08de88c1cd5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9761
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C81CF40008
X-Stat-Signature: 47tis5i1ifzq45ahsik468rcfpdou6nj
X-Rspam-User: 
X-HE-Tag: 1774259513-929134
X-HE-Meta: U2FsdGVkX1+UkK86TeDCSR4V/e1+r+8KKVr6hZHZstIqPntbWcvthhupNKlcizj5Mzo4XZrGisI+P41vV/82OcCT4NAK3ROvcFhLjIgIYl98QJY2F/o2/adO2p2Ji4WlQahu3iupAdWVcPsalLXi6uV//tzvB6X9EewAylKdjVIvhl2q2typfLWGLfsNKZDYu6siidhkQ4W//F7skW3/HtoIeMp/s+N+m/5WgHUxVAexfgXttjDPPbkpwW4QiC3lQA/XG7sxwzZdKLgfCnqc85A8OhgZuSrkgfAvlfkJueE9psxqb3vNo7EAWIIF0a14mwR5o+Awd7JrAb7/hHHbWneH76J99s0Qn+KZMmRBRmydj2hxT/xEVXBb+yMOca2w4lp0Gfp/SNDZ6qIrQS7TlcQhV4clQau/NkftylY+K0RZRpkHEDkeWZMSpxjZJedSAPgFcum+SZiEst+jEfbSWSfWdbfbuLPf350UeTRLIdTx8KJMUJNZTHLdUgwXZwHEAIL4ly2bSGR7n9nqTUT1UkHYV3CwxYxZWsmVxiuoVcVjuD4nhAO4+KeUYgigfBhYYIP3FME9PPmuVBgPMAq5gE8v0uf3j6Qqj3Ne7LaDOjiadWneHdpQ3J96r2cqwgvvwcaHi1DgQyCyvyGxFMST4FFd6UtkfxhCYakE2IaWhrim+biNlQQX4IePIMKULu4Lr/YRTgp0PuIgepu4DPEo5eBVuWauLCJeW+bAUHN4UK4R2sa0WbjQCgNHKrCsDauGjjIcJLRnRTPm0NnwLftueWZ9I4OjFzR2Lb0Mz0l86wgDaZSZW9ajo8aqZshjZPcFN2upZTJXNPkUV5NxDo1Gv1mu2GXvaKEbHAkSr3hhIF5IAUlH7EW1HWt59g3D2dVZzyeEEXPYYu8Y10qOf+1LhsqwKg2SIr61gHO3xPUPUlU5yEtCF71/uRET1e+TNzmf3HgTJbXaSQjODnbIQtX
 DlcF80bV
 DZSIcZ31SZmiJMdWXfiPRImodPoLt7ZL1B4lMawbED+5iUqiXyzI+CQ7xAFfAxkaq9k5qJKiCzfM6DUhInAxOXGqPCIoLSL2ZwlMvgkscvNN4klDllXIUTcqzpEbLFpytrtwecYfpY8HhxtBcbabChRCg7M3YUu+tPfMgw5n5H0l995SRQR/5veKnOHiT4q952HCdW1IOuERkyw8ii3hVXs1gvki2RUKNYk5Fa2peIPhyN6qZKqu0TXeRlsWybx4dr2xhmCufjThh9khZA47tj2lQZ4X0Nfx1lup4rOvjLczaaFhJez+k+xUHqgCG8q8mFQtp3nLzU4Ggk/aQxGQLXRFNR0AGsppapOGKmiGqnxsGLE1VIPhn2iaF8viY2L0v0D1Ta39O7xdJqgpVYGjaDh8wRfIgU9Tv1xspICPqhFcncEifv7RSj295fpG+UC5T83LB4jgYqZXSVGMNoS9jFDbR7YIFY5dVcKOmZIxpv6T4XSrxQ+4gVWiLY2sUwhWj2cEr2m5vXUFC9ZZKqWnFd+69Pk8va/WRPAzg7XfshZB9LcjhUL8yS1X1fivkEm2n6lhw16brFYkDcJ8uqf8YMKcsV+1PjGtvrm8UbW+Wubutf+F94K3K2SsuWbzZ3OwsqEggQoV9cYmonQHxaNRFNLOFFOlCWMj/F/Co
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

Tiered memory systems often require migrating multiple folios at once.
Currently, migrate_misplaced_folio() handles only one folio per call,
which is inefficient for batch operations. This patch introduces
migrate_misplaced_folios_batch(), a batch variant that leverages
migrate_pages() internally for improved performance.

The caller must isolate folios beforehand using
migrate_misplaced_folio_prepare(). On return, the folio list will be
empty regardless of success or failure.

This function will be used by pghot kmigrated thread.

Signed-off-by: Gregory Price <gourry@gourry.net>
[Rewrote commit description]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/migrate.h |  6 ++++++
 mm/migrate.c            | 48 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d5af2b7f577b..5c1e2691cec2 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -111,6 +111,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node);
 #else
 static inline int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -121,6 +122,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 {
 	return -EAGAIN; /* can't migrate now */
 }
+static inline int migrate_misplaced_folios_batch(struct list_head *folio_list,
+						 int node)
+{
+	return -EAGAIN; /* can't migrate now */
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_MIGRATION
diff --git a/mm/migrate.c b/mm/migrate.c
index a15184950e65..94daec0f49ef 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2751,5 +2751,53 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	BUG_ON(!list_empty(&migratepages));
 	return nr_remaining ? -EAGAIN : 0;
 }
+
+/**
+ * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
+ * Attempts to migrate a folio list to the specified destination.
+ * @folio_list: Isolated list of folios to be batch-migrated.
+ * @node: The NUMA node ID to where the folios should be migrated.
+ *
+ * Caller is expected to have isolated the folios by calling
+ * migrate_misplaced_folio_prepare(), which will result in an
+ * elevated reference count on the folio. All the isolated folios
+ * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
+ * stat can be attributed correctly to the memcg.
+ *
+ * This function will un-isolate the folios, drop the elevated reference
+ * and remove them from the list before returning. This is called
+ * only for batched promotion of hot pages from lower tier nodes.
+ *
+ * Return: 0 on success and -EAGAIN on failure or partial migration.
+ *         On return, @folio_list will be empty regardless of success/failure.
+ */
+int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
+{
+	pg_data_t *pgdat = NODE_DATA(node);
+	struct mem_cgroup *memcg = NULL;
+	unsigned int nr_succeeded = 0;
+	int nr_remaining;
+
+	if (!list_empty(folio_list)) {
+		struct folio *first = list_first_entry(folio_list, struct folio, lru);
+		memcg = get_mem_cgroup_from_folio(first);
+	}
+
+	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
+				     NULL, node, MIGRATE_ASYNC,
+				     MR_NUMA_MISPLACED, &nr_succeeded);
+	if (nr_remaining)
+		putback_movable_pages(folio_list);
+
+	if (nr_succeeded) {
+		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
+		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
+		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+	}
+
+	mem_cgroup_put(memcg);
+	WARN_ON(!list_empty(folio_list));
+	return nr_remaining ? -EAGAIN : 0;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 #endif /* CONFIG_NUMA */
-- 
2.34.1


