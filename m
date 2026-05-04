Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58013CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A43F6B008C; Mon,  4 May 2026 02:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92DA36B0092; Mon,  4 May 2026 02:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F64A6B0093; Mon,  4 May 2026 02:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68EC06B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 039AC1A0A3B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:21 +0000 (UTC)
X-FDA: 84728712684.21.3C3D70F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id E5D6180005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3YrOVRG2;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.194.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuP6eHNGW13vhdeIzbrmzG4xZNW/gBXT3DNV0u2vbOg=;
	b=6xTQLFS9bGkiNdvIo8LxLPNJyes94O3cKtXKJKsJJaK0pQZorp2vzkb+E+WgjM8M5+3Il6
	F1MjWKWElqOBEakZFuN88/2kytEiBwR6BByucqRlkK/FeSXRtCY/0aenar7FjW/bD2u9NW
	LJsFVNghrSVTQ5m7HK8AsfNpRY/T260=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875019; a=rsa-sha256;
	cv=pass;
	b=JSIXDpzl0/gCeQKxzQtBkXbVwtwmH7WaacFC8sfc9RzhaEMyX9UKvR4XpSQ5BKhJt/kh+v
	d9/dF24sMwvm0E4s/vr3n7ri6+S3P5yaQnpsnBQEcbBLSYcvsq4Tuq4N7DoMg4mtQIAJed
	FNjfSA2ur3TmpF58w0e3sFZPUrXyMNo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3YrOVRG2;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 40.93.194.1 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URsaHr7fMnADFOh95TVD/jg1MiWtV4xPJSvM3oOc1OoUdlG+W8MNf8jb4dErduEssoCLklICE/ztr2nqj290RgK+RUXU5h3GAz+pduzeFcoHlqhjWHhg+p0fIObfoiNzfqrrux9dItwP4//h0/7OsmvU2fn1JiL/SI97xmhDtUG4kJwEBpELnjFJTTzYaOPtuZKdEq9HNQ78Q3s4PX7Ic86sp1Qh4HGG7XsS2laaB3ia0n6Nj8o64qsBXFPzm/aRlp+mI3w2DxErc4uc2988+7JVvwWmBBjg0Wjd130yTzl257vvSigIBaUe78EJydjdVncgztc/95hsgalwIFtMfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuP6eHNGW13vhdeIzbrmzG4xZNW/gBXT3DNV0u2vbOg=;
 b=elm0x50h++DFD+mf/yqN13N/Ixg4GCSgx3LWXhLw3cRmqk4MN01tm4K16QcF+E2+zPt6iBTaiDXbTCjJmyPcYXtPVhy9Sh3G1jfOqpYVoCs4OJJef+hm+vn+0SnMWm7e71sj7y1W1xtiNlJPZGGYDmTEOwYAOIZ4w0Z+viPgVMe84Ld50Z1L25ipzyEdLQicwag7IKvnheWC/8DmF9Dk01v/QyRTIG79LNh2en3uFgseE7oVghUZKUfP/pvVV7UHyJw+vimO55mA6XNbyTRbh5ycNj82ETriC8gSnbDpSX/5iwApHR6/nDjf8alEkVFTxBh7uf3k+xUAFk/4PzbeFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuP6eHNGW13vhdeIzbrmzG4xZNW/gBXT3DNV0u2vbOg=;
 b=3YrOVRG2qEqbOk0/ueHsThwLq4MpdwBcZOD691AJ4m2aZnTfYFO0cKyftyZ3410//b+A3L+Ev759jix1NkpyBPcnepJ6sx05OKTe9BBUNgOQ7wfSoXuMcbbRWXvfrQ3WtckMfQ6OqDThEVm8JRrxXW2im8aIYalsNV6FtK7OGfY=
Received: from CH0PR07CA0016.namprd07.prod.outlook.com (2603:10b6:610:32::21)
 by DS0PR12MB6535.namprd12.prod.outlook.com (2603:10b6:8:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:10:09 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::1f) by CH0PR07CA0016.outlook.office365.com
 (2603:10b6:610:32::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:08 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:00 -0500
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
Subject: [PATCH v7 1/7] mm: migrate: Allow misplaced migration without VMA
Date: Mon, 4 May 2026 11:39:18 +0530
Message-ID: <20260504060924.344313-2-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|DS0PR12MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 600d5ac1-310d-40b1-c57e-08dea9a3cb59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4o4gflH2pAYamJoZ0nFbHNBNaMlywdtrV0CRJge/tX3F0p7TzCiNgZFSALaNCIXpjwh3ggpxglKTiy99aEsqxXrTIlb0Ce8xx/rEu2/PdJuNud2FqQSAQtxoqfnvaPOv2LFljSZ+2DFhT4ELRbp//jzwHPm1t2xRQgri22CQUFpauI7OigVCO7wULy7xi3EhX4qOyRE93O/UeWNWewaZmdJkz5Dsmnq8h1+7FjZmoRbo4n7otBBchhiqM88kEFIggecZdUZSNd6i+iKr4mKHA5wh9TyznJ+9kNdK/4y1rmsbFvQV5yTWj9G26U0FaphqYs3SG1gHXFcklz1iGqOgREaac2QRvQorsDImbZWED7SaAKGuihBdL9TdcHrclr22XGEgjkzVmuKo2GAE+XXglSwhdXA0LhflUmQ1qILuwrGqUgxyV56TFm38rM3kfQfpii34Dj+dAtsz7nBhhN391npaGKSAy6BMCPuMZN2qQNPznVPGPjtv1/31rCJJNh/M7ilJUc4XREhjcO4rROIUbPzn5biKBNUywtiEh0A8VPRcVX7NcdhET7ZJfBhk1nmY7n1+j3FcZoNAMI7KulU0mKo4Hv0EgSL0GUvQJp2aXG/3B+pGfPi+Y6/vycXkBvyMhqvmAf4GZPfGlwmwCdq6L2lR12dWVJdfWCIObeFO1ALCk1lXZJPPsw2Ccb0Lal2/6uPZyjqKfTKQ8GJeOl75wNMD0Ot4sZXhNa7dhHvwtbc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CneetJYJoRCx/G2YLrq0li3qmYJCRvPlYvj9WeiRjFdBMro9mYDQ20RngNcwZ6CmmuAe4XMnXJAMYlnMxCgNglIz4bHvaTgPTO+e8lkDjqzPhWB7s0GDJqYFKDTYZL7C+BckPmGswC7rocddnINbbOgiNR89+s3drKZS6q13iWnbZvu/9AoxtDT1Z1cEbwN87z496kOTzscvbAZYiYKhjpV0OCKdy6dt9dZLM2NGLnYYASJZPyxPpv1UVZlzmNl4SrEENFDv64jCebvxf5fu3EWt99lUZiabp9AqD5Bi3NgdKcC+ROSb1CtA0BqCtMbJxN/LOt67f7jZBRrZBZreMdBS9wocgq1TtNOohy+fRvhtsRdMxkTDbGVqAEuwD0T8oeEaSusvLhpZ5IUEzsIai6AEFBsxPgC8yiP6ZjC4yJzPLDJOfB2r/TvcWjl0AYff
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:08.8997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 600d5ac1-310d-40b1-c57e-08dea9a3cb59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6535
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5D6180005
X-Stat-Signature: f9kknps8nf1gdeknojn65y319jquwauh
X-Rspam-User: 
X-HE-Tag: 1777875018-964949
X-HE-Meta: U2FsdGVkX19T5UWQMhmYXLPUSfSHasVhKp2DxcVWzpyGloifKCtXklAISAWB+KkDEqrZr2zCgotmDQtZ47Y0JlCQfVSuGXLYDksnwMcutgQxUkj26gfwQYT4VMQYpFBBvhWSsHQbqNaLRXJINU8Pe1a8XzsFPW4ODQCKU6yWMLPq1UsDtgR7Rn+V+/wBO7iHWy1gKkUNkuv04jOTU+NGLNTg6bfHJIRsgoIReOQk1og2Da8bjliQZwjqIjSbyMcHoS7ipNaNaGkMGuI+wfa0y4GL48UsXjUCvOZNUbTd1wesFPfc67w8U6x5HyiaIKG0Agw8j9qn5XolJbwZVEkM8lDDkCSkbGRQ1MygxlTAJu5KbXg3U/kTElQWftfPu5/TtiNniPsBc9xBKqXHN7ZxwC9F87pbBQcf980v+b5xZS1RKyLBYGLoPfEqrOaYnEQ0xGkFojILogTguS68hCNATjj9n+CY8qt8JfT33Mkd2PC5ramgpHtFyeaVNmaAhvBnNnm8yTOaEBqOj51hFyZ6N9CQFl2dTv8KyQX9oFkri0ByK+QwPn//ErR3/owFiCyvXpqOPBbo02wM0JbK/7GMMEqOGuhsLnb44CH3sv1ShLPcq/EAmVHqSp1RyWRZiyl2KBgRYqDD2cFeex8wT2snQRT71R3ivobBy4ViC4IQnbNolVawcYMry9AFzLpuJTvEfCptvBDdMhR2u5oq3PvNPFMBlRBZjwo8OIt2b79jdgKPW7/F43ZF4x0M85UlYN1p6g9LgAo25U8e+hriDOLBaRGyt6Z3EiAXrnPABORIvNt4ORegO9q2AY/Y2T25qVZ/epbkv0ebjfTtfR9q76T6iL7ito79ZqxAfpGZun0wI/EM1dAf8AHNzlYih/W+SYPpMnwMadwcQ9ayk2uf+k2vvT1PTvOPXf1o8H+9FKqg+qMgZagLc0ZDeZmu8ohHTSn+E9xbaRdlb0qE2zBSTOi
 PqvsyhrD
 QaAfmqweMdPtPEuNW6TnFqUJPgqz/UWrwBIc7ldjeSGxsU5ZoPwECPqo1+44d6SO5C3LZxjRIorv01xdrkMuPlv7AypPBqGjmxwqSXLGLcQt5k/VQ7/mOVKYIPkzLJ93tz/ag1pHIElYhdjRBk32wTD875SRlU8/25dbMe+hI6PRcGPdnC8Aa2LzGBHU+S4fIAw4WkV2ixb2nEO4MuHazXJfmJNeW8TQolwKie3NZNx9oO1VJEeyY9VfmLv1rFB23ZxF/gmAE9XTt5+6VxJBkh5t3paBqgpVLcosa4sJRcUBFZlGvXva2BwVpr1n5KLyOC+u2FTOOchE3kXtNYbmGA0N7pSwky4htpSCXaUlDmMA78qzSEiKVED4fwue9OZYLQBtiInuvxcAbP8ir5w5yFoZO8GvmQ/91zITI5vctlXQLsIM98OxuJRX3zC+meCmC3CibdJ1eDHMC/PX6XGq/z3wfE1djEIbVkA//jP84MpH9bzsaES3ObW8eWBKAlb0JKPyqgtkDujihDLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that,
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Therefore, when VMA == NULL, migrate_misplaced_folio_prepare()
does not require the caller to hold the PTL.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8a64291ab5b4..eb21a02fade0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2671,7 +2671,12 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
+ *
+ * When called with a NULL vma (e.g., kernel thread initiated migration),
+ * migrate_misplaced_folio_prepare() will allow shared executable folios
+ * to be migrated.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2688,7 +2693,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1


