Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB328CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B856B008A; Mon, 12 Oct 2026 23:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC266B009F; Mon, 12 Oct 2026 23:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBC36B00A0; Mon, 12 Oct 2026 23:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72E0F6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:20:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03CBC80536
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:20:27 +0000 (UTC)
X-FDA: 85316150136.23.79F18E2
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id E973A40005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:20:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="r2SbfN/3";
	spf=pass (imf07.hostedemail.com: domain of Biplab.Raut@amd.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=Biplab.Raut@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GRkZK/iuuE3UsBvYNdMfTVUxrvDGE4KD74DhvJNy7nw=;
	b=jknAzL98GrzP4sN7xi+hglB8J4qCONB9tlKWgpLzw3R1r0QDpW6Ldvj3ORyJ3xzUpjee1y
	j1Vm5hs0sNuxYA1cq+v60hGhODoyEayWnlKPNFsAdP12RYyVa/bGC6HR5hjAeQrFYcM/4G
	HiTYBEOC7th6x9JYMuqqv7g/uhvQIbY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791861625;
	b=tdycHqhm6xOTWCYC0zcr90xdosvJ/BcvWot1RH+9n78cVIB+mJ0PutHZSajMKfdCIKiK5m
	9W7MijNYqJQ8GbKhADa5ZiZKlmM7G06K+OQjgwRn+ce3KwUjwEIdZlUiHdvj8ap57e1ubq
	CyMMdUpGL46DazCDGwIpyD5+wmfFujY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="r2SbfN/3";
	spf=pass (imf07.hostedemail.com: domain of Biplab.Raut@amd.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=Biplab.Raut@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boxKiCoNoOJ/LBxMLLP+Ih07FqReN/Fo1OxYjJ5OLuutIdiVsICB/LqmSMKQEAPmOHITadYnnyJauwx+IPbu1R2lcNHe5iLncym0FU882/9MV0cs9ZdoD9q9v+Q7GKROnHMOssiMz2TkhBRNzHFWt6mSo+vIJLwfAQzo1PLBdlOqfCk7TgXD9CKwlzt50DABNKsP2LqAGxJl+ieYZtsZE/yxrwQL5aQ67Cjv4zHyI3jRnn7Xk85JmWrDnKZZdaoQN+UdNhpzQkEz/dOOH1/VHf3XBb3Lg8GpHe1FPq2WupU8FFPXwHGSnrA7vFGl/j4oKl3djTWItIUdTkudEbA7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRkZK/iuuE3UsBvYNdMfTVUxrvDGE4KD74DhvJNy7nw=;
 b=aJIMU7EbXuQqrwXzFIBkc5VpWYCFmAdDeZdFnWb1Eo15USogjBXAQNfyf08LvX0pkKaUkNiUwY7ig9oPEs+SIM3tKZeEgeHToc28ywDoeUQvZ3ueXk318BuXtgTDOAA5wLWW1o5TiO+Z3V/miaMe8D9MBdDG/AQQlmy2HhTil6Rf0z2UVPiVKi5MUiMEB+qDtCU5cXhIqy/15OhdxpujSCet/z/7rjGhhS5d2jt6/pTYkuCkagF1xAwtjl2fvs16BD9n2YOqBd1g2/pykmWof6V/W4auggpfRr+2x0cIIiVnyfRbFDVT5oNrTbtsPK7L1TXXoLX0D6MJahkCv7L1kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRkZK/iuuE3UsBvYNdMfTVUxrvDGE4KD74DhvJNy7nw=;
 b=r2SbfN/3ezRrkJ2pyV6GM7cEYQlMQJPYynMB08FjJr03KGOKqHkGxiFztuh33hV8qx687327XkJkpMUv6/f6SzCbByvEVsZUSEcUr5XJx+4sIVn5b7letbWplf3QPXdFHjLg8mCjaqxq7H3Muun5q6Cs/es6vLxc//DBEHpjJbg=
Received: from SA9P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::15)
 by SJ5PPF2CD49510F.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 03:20:20 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::79) by SA9P221CA0010.outlook.office365.com
 (2603:10b6:806:25::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Tue,
 13 Oct 2026 03:20:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Tue, 13 Oct 2026 03:20:19 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 12 Oct
 2026 22:20:13 -0500
Received: from aocl-turin-03-9e62.amd.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53
 via Frontend Transport; Mon, 12 Oct 2026 22:20:10 -0500
From: Biplab Raut <Biplab.Raut@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <hsiangkao@linux.alibaba.com>,
	<terrelln@fb.com>, <yann.collet.73@gmail.com>, <guoxuenan@huawei.com>,
	<Biplab.Raut@amd.com>
Subject: [PATCH] lib/lz4: add software-pipelined prefetch to decode fast loop
Date: Tue, 13 Oct 2026 03:20:10 +0000
Message-ID: <20261013032010.2453893-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|SJ5PPF2CD49510F:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d1aeae8-73be-49f1-71b1-08df28d8e8b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|11063799006|5023799004|56012099006|261009223027099003|10067099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	hgRXCfJUx8nB2w+M2oNQgF/bp+IIiFtNfrrH0UxLsrQSKJbra3sYlmojz/zAJQIwQH7ehd3QCZGRq/kNo4m6yZrSQ53xa+P43wTuJw66QrdMCg0guHfpcqVLuN2Ld9LxA5Ir9Cfu+4dOrAymODUW6LNIzNKVYAWH2UOBz3oV+6sL15c+BBXZyJGD2dm9ZlEi3oH4TbwswVl340WSwWW7xgQ/Blk+69OoNuNnF4NEYqYoXmyq+5z745MMrmc1RfhFy9cgRtE+s9Aq1CXG9TkU88hxMU2+CtYlkkZV0hxIxiGlU2UJ4cJK5G1QtxJqQfrboN+wA4cPv9ban8ZXNmaEI04espSjhM93+9wJl6eJ1Em4K2bwEUKfV0pEulMLDTm967N9tE2zFtn7DeGxL6qHev8uQpn1MPex+JCDugFTaO17HSNvHLnbBJC1bj4QhKqQXLcxJRdFXxd/yRKYHkseSLOURgryQQjCaABgBrlHQGkG7/YLcIYjxzSPc2IygwbUIdFmMNd7gCQvEQRun73/kbj17qPOTaJJ/+yrcMGgPcsAe8MdmglYjCuliXGKfSUcezxCskEqJoagTe5O5PsWTk27P3XhNYFmW4dtr7FVO1n8dRrf+GRJcQyA8xasYQK+gpi3J4awfh040xEVtRiZw9r6vGurg97jmrzzlukU4CS3lrJ9vmTCZ2IOjNlO11nHEQ9H0WKket71A0QIdyveLw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(11063799006)(5023799004)(56012099006)(261009223027099003)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1PFOC/eqLdZ5EOAAeG25sHZfoYABd6kz31Eua9xdjARu3r/Q7piKiU5uy/6avhjHcatwZvqPjNl57fGqZNIoZ9BvdRzBEEAmIBdTIZtVqhZkTNTUPKrcPI311EWbvQeUCkyyjaxRltES92TnFETm6ijnZvc570wR6pWbwJYocsntKDuNAC6lgcL+sBAvHWFoYfCJp8/3e9tTyArqnVHXKt4KtIpQeT6oZMwOWrc7O46hQWpF/WwNiJzYE6vLlu+4/zboXcGlJ/Q0Qa/4wzvrrecuIJYm9WuBHZZL3mSR4mbNujNRoc1JYImFjFsDzEBGZ1Yvog7p0eF+Zs11N56veT+rdPO/Q7tfUdt/9fX1onXIrgKVSnj54/ayx0PL09NMe/ZKw5Lm0iFoRAIlVQrBb4QlrTcB9fhGBVf1hhuh3H74d06Tz8CCXgkz0r5WuIWW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 03:20:19.1681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1aeae8-73be-49f1-71b1-08df28d8e8b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2CD49510F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E973A40005
X-Stat-Signature: u1e399ukgk4yabd5qgy9tjdhna5qxje3
X-HE-Tag: 1791861624-554708
X-HE-Meta: U2FsdGVkX1+UUNGRAkU33B80yrhDV5K6JwZrLrskz8tWt8EbcJcIpSl+bGNlpn+QiGK1nGmcCkglSdKHWWA/gm83NAE8yrTOlCnfgqAnjiLqJr90ENCixL/wuT4g0nzq1oNojUNQNYA6k5NLDxWzqAEgJb19P9YjubG7d2XdVEJbfEaFSixMMUg3T11Y8ZW8/SBrwOfidfZDVBWMszTNbUaPP2wTSnbBsmxypiUwTgvyPOyG+Dpin8HADR8o3EIArfyijSOUdWnTnz+GcuVHSwMLoaOSkcxmKiYP0+mPQ6sp1fvfT58/U8bUnPqRj2XKzGWQNw9bdi2JPkX7kd6IokSJhWsdFS0+QlhPrhb7QZCMIawxUfpkNlIBm+CtnJL7AcxHcaJBRgZTsKDwcrC0754oxvy2t5KLKvdfs6iD6BGzwqrub4mb5mvWZeFPOxAR13WXoyngoSPo5OEMyaLztb5tlbrAmnPX+1Z4NfKivPdoB6r+VKJccE/ee/Z6wRZ1yaQ+YbvkxvJO96muxuKd8IryDhqPRxkjO2tAeptHXBCtJJm60guR0hVcKc78axK0y61uUy0zK9u9JspKFPVVV77crZrp6SygsiiP2s8rlJ1Ov8xp9B7EDtdabFwpD9ZxLpfpyK/bhEB5ZNpi2cp4PMqs2SyZuym8HEcdlHnors4a8LUqRC18U1kTxCbfc1XzKZeRRQ25PpvpwePiPk6lFQeP6uTWf3K72qXuqp+OGBMMixjeIBoRhpZzGU0wazGGBRNpT5cMhpgnIwk8RHFtpKcMJ29MXDJbKKHNlGxUV9JnJwpFlFuSElBBSR1+LA5e2IeBfiEu5SMO63kw+TKjKNJ1jMotxhl8vJsTJ+PNi34akFjG+budVuJjb4wgEU0MxjIXmqZfDykEUjyV/wVq0UKiJWqpvhQvLfEHhAAI1BKJvHpvSxxbeYBicwrRifpg1LXD1oaK3Qso1mHzHlJ
 MtQO+SKp
 HMc1GCdJ+hu4sRQYSz4ZDEXEMU5Raf4jigVmEhyF0NKWydrLrKHuZEXN3d+QNOEgvQMRWkIQi7V2YezUYVt+dmwjIfmTMdxOsFglZTiU5uXMTYY614XY9BGKmljkcIO0SFIXLic9fpfX1TQ5vKocRk/kPODFqLUA/wuhoS4rVdx63PsKhqnbocgaOtgqw0OAIRMxkFncDVEy7tm0nOdam2GNwX5L5GtDFRGxT27xTIcrq7DkyfrQoA1l4LVuetwjCwR2Z7/WAh95SGI2OBHu/pRUJ47TVEaxaKfbvFIQ7RQ4ekYhv2jGNoQ1H4ORNGrp13xU08fCgOKz9zblp12D9QB+88IkkODQEa1WPpzLooRsrb4R92n0uOWuSv7FhWZUO/tzzYBx/bJ4J1Zoe8DnaNMzrvL5w72MZxo4kdMxn7IuSz1y/JDDyVLG+vqYNH9Wqx9ZWSFCGDCWHxhxDlQbTkb7FhSpnr9HMSUgrgOgkE91qlf9iet4o6EedRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "S. Biplab Raut" <Biplab.Raut@amd.com>

LZ4 decompression of cold 4 KiB pages (the zswap/zram hot path) stalls
on cache misses because the input stream (compressed) and output buffer
(uncompressed page) are not resident in L1/L2. Insert read-ahead and
write-intent prefetch hints at the top of the decode loop in
LZ4_decompress_generic() to overlap memory latency with decode work.

The prefetch distances (96 B read, 128 B write) are tuned for the
page-at-a-time workload where both buffers fit in L1d. Prefetch is
architecturally a no-op hint on all Linux-supported architectures;
it never faults, never changes correctness, and compiles to nothing
on targets without hardware prefetch.

Measured on AMD EPYC 9755 (Turin, 2S×128C), Ubuntu 24.04, kernel
6.8.0-90-generic, real zswap path (cgroup-constrained MADV_PAGEOUT +
full scan-back), Silesia corpus, 15 paired rounds:

  Kernel LZ4 median scan:  1.0994 s
  Patched  median scan:    1.0472 s
  Median paired speedup:   5.09%  (range 4.19%–6.99%)
  Patched was faster in all 15 rounds.

Signed-off-by: S. Biplab Raut <Biplab.Raut@amd.com>
---
 lib/lz4/lz4_decompress.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 3a2cd9acada4..efbbde7ae58d 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/prefetch.h>
 #include <linux/unaligned.h>
 
 /*-*****************************
@@ -122,6 +123,26 @@ static FORCE_INLINE int LZ4_decompress_generic(
 		const BYTE *match;
 		size_t offset;
 
+		/*
+		 * Software-pipelined prefetch hints.  On the zswap/zram
+		 * hot path, both the compressed input and the output page
+		 * are cold (just faulted in or freshly allocated).  Prime
+		 * the L1d for the next loop iteration so that the actual
+		 * loads/stores hit warm cache lines.
+		 *
+		 * Distances are tuned for 4 KiB page-at-a-time workloads:
+		 *   96 B read-ahead on ip  ~  6 tokens ahead
+		 *  128 B write-intent on op ~ 2 long-literal copies ahead
+		 *  192 B deeper read-ahead  ~  covers the match-copy tail
+		 *
+		 * prefetch() / prefetchw() are architecture-portable hints
+		 * that compile to NOP on targets without HW prefetch.  They
+		 * never fault, even past buffer boundaries.
+		 */
+		prefetch(ip + 96);
+		prefetchw(op + 128);
+		prefetch(ip + 192);
+
 		/* get literal length */
 		unsigned int const token = *ip++;
 		length = token>>ML_BITS;
-- 
2.43.0


