Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18957606C9D5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 19:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=I6NUaQY8
Received: by kanga.kvack.org (Postfix)
	id 27F706B0BE2; Fri, 23 Oct 2026 15:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257BC6B0BE4; Fri, 23 Oct 2026 15:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E5B6B0BE5; Fri, 23 Oct 2026 15:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBCFA6B0BE2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:56:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F8D21201E1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:56:45 +0000 (UTC)
X-FDA: 85354948770.04.C739D0B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B0F280005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:56:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=I6NUaQY8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Biplab.Raut@amd.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=Biplab.Raut@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792785402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E/PmAGOevxAbSjkedyPr//nYgng5QwtJBiniROxgJ0Y=;
	b=IlkX39Cy9w9gat7gmr9SpoHIXqWvRtlZ93TE8zPEcbtyGH+YCFOzcW4bUfPWNRESGQPyYq
	uNH0SyOn23EBI0caSNQUCq124VidE/rGiXc4f1YzaF7hZjxgiBaPTOhYP9wOfKrbcwWyPF
	BdudCYde8t/2F7WsEYOYLFBo2xTmqKk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=I6NUaQY8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of Biplab.Raut@amd.com designates 52.101.43.42 as permitted sender) smtp.mailfrom=Biplab.Raut@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792785402;
	b=lN/FpSCSy5CjuOf6segwriLupAWM786wqNUdBJkGqtzIIP/dTRGbTOl3YB/zk+sNh24mYz
	UCZvx2/sQkIKW6otdVRfUq8wp13wYBDhgSUpuU2+GYzEX2QNfRW4yj1q9zky2HvTaPgIwy
	16ePpwQRQ5Q1s8iwYWdzu5yVmjl73pA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koSgWFpYbi3wuOK3UQgkZskK9oijPGndWbngBr/b0LM78FM9nXXoRVcO5ZNfQPYj55aLtGH4JDEnGLMkkHzXP5xpDjZo13DFQexCNydyLuuUKGeGcqqqAvZDT7ffgUtgi5GAP1V+3N7wQtVEhaowF+dHXsuz/QvzW2ClOtWBqhhabQuahhytyHebexFWFb3enfWqVJ19Tf8YVmZ4mpf2jyaFVHrC+oWSdf77KJLpmlY7aPgYAeaoqVvfjRkRjK7O8elap32SmG/8eQaU1V21rXGX+OJtswGvN59UVSvXsfh5H2vnrtfkUt3YYDD5NN54Z1cFs+pKBeLExmxSEULyVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/PmAGOevxAbSjkedyPr//nYgng5QwtJBiniROxgJ0Y=;
 b=mGwGqeJ1HEcn9iBWXB4hOkngmt7BtERim9g6oIuet00/Q/hnvjXk6rPZ19GeiZHBZiMem8wUJ60dp1f3mrIOcmq22u+owlSK9xHtAXWS4RUMD5iVekbDmYA0RQZ/rp28C7I11D/nNNsoj+Bo+Jj8CnffrEcrYjnmAFVDe1RZ1bRUaGaJYtHokznqxgR72PoCd2HdmH/7jY49kAloRRFmNlmtE9YHwKaf9/KkJ3mMFAA4JV8b+qRbccSObE7acdTNjlHbUq105+DGb9A897EaApheSIU7LKDOy44AzB3n3QFgr1Dbgnp0KVkBIyDiBeBnqOOFCigpvaYslHFlSNtiCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/PmAGOevxAbSjkedyPr//nYgng5QwtJBiniROxgJ0Y=;
 b=I6NUaQY8VWKIkSCT7mTplb/mCazqevbUsRM6dobOdLheR+jF01iZWwxGPow8Q3gYUVnWjGo6TFFhWWZ8dr6xSpNvw0I/1+xH01E2qYPyI5pJd8s4w0gk8PiZaVq46KWwYKgSJoS8KbyJ/Bz5QKOJ4wt34oPrf9izFA9yHIniLsE=
Received: from DS1P221CA0020.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:242::17) by
 DS7PR12MB6191.namprd12.prod.outlook.com (2603:10b6:8:98::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.17; Fri, 23 Oct 2026 19:56:30 +0000
Received: from DM2PEPF00003FC8.namprd04.prod.outlook.com
 (2603:10b6:8:242:cafe::f) by DS1P221CA0020.outlook.office365.com
 (2603:10b6:8:242::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.19 via Frontend Transport; Fri,
 23 Oct 2026 19:56:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DM2PEPF00003FC8.mail.protection.outlook.com (10.167.23.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Fri, 23 Oct 2026 19:56:29 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 23 Oct
 2026 14:56:28 -0500
Received: from aocl-turin-03-9e62.amd.com (10.180.168.240) by
 satlexmb08.amd.com (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53
 via Frontend Transport; Fri, 23 Oct 2026 14:56:25 -0500
From: Biplab Raut <Biplab.Raut@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <hsiangkao@linux.alibaba.com>,
	<terrelln@fb.com>, <yann.collet.73@gmail.com>, <guoxuenan@huawei.com>,
	<Biplab.Raut@amd.com>
Subject: [PATCH] lib/lz4: backport upstream fast decode loop
Date: Fri, 23 Oct 2026 19:56:17 +0000
Message-ID: <20261023195617.3468543-1-Biplab.Raut@amd.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC8:EE_|DS7PR12MB6191:EE_
X-MS-Office365-Filtering-Correlation-Id: 157da0ae-f339-4ff5-5521-08df313fbab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|6133799003|18002099003|261021123027099003|261022105027099003|261022075727099003|3023799007|261021133027099003|13003099007|10067099003|261021130227099003|11063799006|261021135927099003|5023799004|261009223027099003|261021121427099003|261022113327099003|261022115727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jdTS3NUFobrTlyMb5EtPJEo1b+FlO7aS1MRMsJkBVkG8J6KrWene8IikACDMzvERZ9tGFhTTDnrf0jdL0oPlOEs019Wd+tSLObJuVH3ucRjU558lu8ZaBofqoqS/kefu9LjdxLfZ84eyVJcNSYhzJy2SA5RlgIZFTHgnJ/mNksACHn+U/iEh/hYzXUUMqHVr4RAia0HffUZlGcHCCIZLbHHmXxRC5gUel/ppJuVZ7f0tFIKLtBxxJdQMpCEc7YxHWEAA5sLcRpH9tQ6ZUAcGCUsyBPVpjwFDxQ+z0gJTYMaTU6cIzVdNNmkmdQzkRM13z2phyEeLRFXQaHHvsIFVRiL7g6fWzJ2J4g1T8v6pneoXSyVU3vOQqmi2d2zM1ucMP3o0/PFFDleMMWZKENyelJh35Pj1Imeqomnbfgjofq1UHpp0rtMfXhwrsDw7v3+naG3iLhj/4GBJZ8asaLxhrHV929caloQqmUwls4NlGlaHIwEVz4EUxt30W4+3MZcBFhvmhEb5fLk9oHnhGBd3Y+s/oBui9BRlcGkXjAZlCC8+FxawmfPP4k3PuYetozSMY/ZMlY3DPNA/Tx+d4vN7MKtC6bimVJtXjrlvVf49uMzE31luuv24ZHxCn+FWhxRaw9PkuQeBMBqN2xLLUh4cv2fHVSnoR3WqfmXae1ZLzI6UauActhl/bX87zG3VynBYbrDEDzcjU+ZKzpGqvaSUiQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(6133799003)(18002099003)(261021123027099003)(261022105027099003)(261022075727099003)(3023799007)(261021133027099003)(13003099007)(10067099003)(261021130227099003)(11063799006)(261021135927099003)(5023799004)(261009223027099003)(261021121427099003)(261022113327099003)(261022115727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vFZJqX+k9LkrR4mtS8XKhlNxRJxDsxh//Bh+LGQMThurP8dSeWiF5W1lOwc/8HviinZYY3goSmLPGZshUOHdic8JprCnFRE0XWJz6Tq9dSUxD1qHfcmy8YvlqR9UvgnIHAcd0212oI4d7JJ6stffLAZO4SwMLandiWbyhjUaF/80mtOPr6Tm1h2DZQnPK5nmPVlqEiHq1jNSRemmUSFqola6cHjqjM/Q4A14ClkUn0CUELL8skpmDpKQnmUond2N/KJg5JhLGa3FjDWjBn5821w9GidDoIXbSWRUSKGEDcqCY7Lqvo/IzZfYB2WO9a1c932t8yJs+kjjNxnpZ6FFii3w63chKeS2rCzSOkgut0bzA+A1+/VXVJdir4G6x6d1nzpNGQq59lXshki1gtUoz++v/ay9nVHw9GtHNatYHg3PqYsJHyTGl/hCJ+6yBTST
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 19:56:29.4337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 157da0ae-f339-4ff5-5521-08df313fbab6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6191
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B0F280005
X-Stat-Signature: 7unzaqq8chigaaa5ap19ybr96g99y4pw
X-Rspam-User: 
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792785401-815093
X-HE-Meta: U2FsdGVkX1+4zjqnCrbEydo8SjNdEdgQOtZ8jP6AwEV6nhS6zhTmDfYoQQLzdLdV18r6BuWaGFNAFPAR7UpiAWidQ/xbk40F9ssZ8c26C6JERGJ7EMcto+Q0X6+FNXd6oe76DZsovcC0OxhLHDnOsv4Dc8BrJ74EAPAAVkTitBDb7ZsRMySwKN7q330s5p/oG80VIZQEqa5iUX2CJzcarlH1cdKmVKV+xBEEG5DOEwyiUrakr4lkgBa9YCjfWQJBchoBvzzdy4hOo/oC0/qxsbD+j4D5fH5YPrdYBUIX3OM5DEWOgTNg3uH8Kf5LFYJayNk3h7DI6eILcEExr7hlDhSQ5jZNGGex1AIg8DJVtLK+FRKqQluDcZBjl3kc38Hbw8GOEFYzr+A8JyHUQuMjzL0z0AXAlFCgnMz5w6Tq2jXwLqitEvJxZ7TFlGKUH5TbS0giJct6jQH4TVKlsqKcNWOAB4KCFjQlc6TE4V4W26jdcNZGw20WwuO4NuXLJPeQjkPg6ScizXu/VetnRskERz2I+yIXA+9j1YkFxWMJMeSMXNvCLxLDGZAJbOF+f49c3o4RRJ8Z9GKPi0gpPjS4MhoPpOs4zcvXSjSy1czrOsOxNUuTi6v/DUI9q5G9HYVQLMrBulR3jL+Z2DSua+Iy4dYrqIb4DA7ot1oOsaUbP6ujSXvUM4YXb6DcKH9P7MQ38XdxoHXHlu15QSHuUSO9u7KbjLG2ZI+lbV533WfAKrYC7HXv/N0LywRwJCoy2G87F2w93HhQUPG5bnBBaBgNsvsmpLvagZs/xA7AuoNViV3M/v7dgg57nv+SkM3H/1EoHaxa+LUyzUGJNnbe6Z/yREhDEXrmuWSBBiCRANpllkh1lqZInis5xeYSNPJRyW9IiiU1tSHuF5GIuXg92fRSVpqC23zof1RpRE0kl6ANwb5inuahzKdp4pYdwXIXOce6h1JSPxLDZLdKni7pALv
 yMtxIbK3
 kyyAiZ1Vl8++tVqc+zwt+lX/+/KjgC/JYkM6qXpJ0TbskZBycmR2QnwaSEhwjR+e63U/7QGHdv/jfrTQLWdi/pQv5ScHGxv2NEzMGWaVfdVLfpzN5H0nfVuKgOFUYtWiyOAscYxR9/TxIAmVJlV0VKvEdIBMyzmpuGpDbtP5ATWY0eigmKOq37/b4K15ihfnligC9BxoS0xPFh+DBGigE3+Vpc3l/N3OFv88aMXQhDmxWG3sPmvfvA/QkYBGuXrNFK7SouZI0Rmu7OKHdplrUs9luh6z8XZccTDqZcGN2/4ah54qPXbJPAfIvyavQyqyIYscBqMrWyJb5kLbbvcrvXRGUTTlp7/5Q2QjvKQLn3jZKZ/574WZ39HcEkQc+dCe9Tx9kGc3h9YWd4dpOUBHqDdbykhsuFAiW3BxkbYSBFbMTipt6AuELwuAFMN7in4jlklrgxOE/OztVB40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "S. Biplab Raut" <Biplab.Raut@amd.com>

The kernel's LZ4 decoder predates upstream's fast decode loop.  Backport
the v1.9.2 implementation into LZ4_decompress_generic().  It uses
fixed-width copies while at least 64 bytes of output headroom remain,
then hands boundary, partial-decode and dictionary cases to the safe
loop.  This also imports upstream's shared variable-length reader and
safe-loop control flow.

Enable the loop on x86 and non-clang arm64, following upstream.  Other
targets use the safe loop.  Keep the existing wrappers, exported API,
NULL-input and empty-output behavior, and in-place copies unchanged.

The loop increases .text by 9,458 bytes on the tested x86-64 build
(11,891 to 21,349 bytes, +79.5%, GCC 13.3) because FORCE_INLINE emits a
specialized decoder for each wrapper.  On a 2-socket AMD EPYC Zen 5
server running kernel 6.8, 25 paired Silesia rounds show a 5.13% median
zswap swap-in scan improvement; an isolated cold-decode test improves
by 12.88%.

Build-tested the built-in decoder, initramfs wrapper and preboot code
with x86-64 GCC; the decoder and initramfs wrapper with x86-64 Clang 18;
and normal and forced-fast-loop builds with arm64 Clang 18.  Userspace
round-trip and differential tests completed 6,899,931 checks across
safe, fast, partial, dictionary, streaming, malformed-input and corpus
cases with no failures or guard overruns.

This follows the released v1.9.2 layout from upstream's fast-loop
series.

Link: https://github.com/lz4/lz4/commit/28356e02ad6f6dac529302cedf707712c5b628fe
Link: https://github.com/lz4/lz4/pull/645
Signed-off-by: S. Biplab Raut <Biplab.Raut@amd.com>
---
 lib/lz4/lz4_decompress.c | 530 ++++++++++++++++++++++++++++++++-------
 1 file changed, 435 insertions(+), 95 deletions(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 3a2cd9acada4..bb201c9484dd 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -49,12 +49,166 @@
 #define assert(condition) ((void)0)
 #endif
 
+/* Output headroom required before the fast loop hands off to the safe loop. */
+#define FASTLOOP_SAFE_DISTANCE 64
+
+/* Shared by the offset<8 match copy in both the fast loop and the safe loop. */
+static const unsigned int inc32table[8] = {0, 1, 2, 1, 0, 4, 4, 4};
+static const int dec64table[8] = {0, 0, 0, -1, -4, 1, 2, 3};
+
+/*
+ * The fast loop is intended for out-of-order CPUs, where copying a fixed
+ * 32-byte chunk is preferable to an unpredictable branch.  The safe loop
+ * handles all cases when the fast loop is disabled.
+ */
+#ifndef LZ4_FAST_DEC_LOOP
+#if defined(__i386__) || defined(__x86_64__)
+#define LZ4_FAST_DEC_LOOP 1
+#elif defined(__aarch64__) && !defined(__clang__)
+/*
+ * On arm64, disable the fast loop for clang because it reduces performance on
+ * some Qualcomm chipsets.  See https://github.com/lz4/lz4/pull/707.
+ */
+#define LZ4_FAST_DEC_LOOP 1
+#else
+#define LZ4_FAST_DEC_LOOP 0
+#endif
+#endif
+
+#if LZ4_FAST_DEC_LOOP
+
+static FORCE_INLINE void
+LZ4_memcpy_using_offset_base(BYTE *dstPtr, const BYTE *srcPtr, BYTE *dstEnd,
+			     const size_t offset)
+{
+	if (offset < 8) {
+		dstPtr[0] = srcPtr[0];
+		dstPtr[1] = srcPtr[1];
+		dstPtr[2] = srcPtr[2];
+		dstPtr[3] = srcPtr[3];
+		srcPtr += inc32table[offset];
+		LZ4_memcpy(dstPtr + 4, srcPtr, 4);
+		srcPtr -= dec64table[offset];
+		dstPtr += 8;
+	} else {
+		LZ4_memcpy(dstPtr, srcPtr, 8);
+		dstPtr += 8;
+		srcPtr += 8;
+	}
+
+	LZ4_wildCopy(dstPtr, srcPtr, dstEnd);
+}
+
+/*
+ * Customized variant of memcpy, which can overwrite up to 32 bytes beyond
+ * dstEnd.  This version copies 2 * 16 bytes (instead of one 32-byte chunk)
+ * because it must be compatible with offsets >= 16.
+ */
+static FORCE_INLINE void
+LZ4_wildCopy32(void *dstPtr, const void *srcPtr, void *dstEnd)
+{
+	BYTE *d = (BYTE *)dstPtr;
+	const BYTE *s = (const BYTE *)srcPtr;
+	BYTE *const e = (BYTE *)dstEnd;
+
+	do {
+		LZ4_memcpy(d, s, 16);
+		LZ4_memcpy(d + 16, s + 16, 16);
+		d += 32;
+		s += 32;
+	} while (d < e);
+}
+
+/*
+ * LZ4_memcpy_using_offset() presumes :
+ * - dstEnd >= dstPtr + MINMATCH
+ * - there is at least 8 bytes available to write after dstEnd
+ */
+static FORCE_INLINE void
+LZ4_memcpy_using_offset(BYTE *dstPtr, const BYTE *srcPtr, BYTE *dstEnd,
+			const size_t offset)
+{
+	BYTE v[8];
+
+	assert(dstEnd >= dstPtr + MINMATCH);
+	LZ4_write32(dstPtr, 0);   /* silence an msan warning when offset == 0 */
+
+	switch (offset) {
+	case 1:
+		memset(v, *srcPtr, 8);
+		break;
+	case 2:
+		LZ4_memcpy(v, srcPtr, 2);
+		LZ4_memcpy(&v[2], srcPtr, 2);
+		LZ4_memcpy(&v[4], v, 4);
+		break;
+	case 4:
+		LZ4_memcpy(v, srcPtr, 4);
+		LZ4_memcpy(&v[4], srcPtr, 4);
+		break;
+	default:
+		LZ4_memcpy_using_offset_base(dstPtr, srcPtr, dstEnd, offset);
+		return;
+	}
+
+	LZ4_memcpy(dstPtr, v, 8);
+	dstPtr += 8;
+	while (dstPtr < dstEnd) {
+		LZ4_memcpy(dstPtr, v, 8);
+		dstPtr += 8;
+	}
+}
+#endif /* LZ4_FAST_DEC_LOOP */
+
+/*
+ * Read the variable-length literal or match length (LZ4 "LSIC" code).
+ *
+ * loop_check    - check ip >= lencheck in the body of the loop.
+ * initial_check - check ip >= lencheck before the loop starts.
+ * error (output) - set to loop_error / initial_error on a bounds violation;
+ *                  must be ok (0) on entry.
+ *
+ * This is the shared length reader introduced upstream together with the fast
+ * loop; it is used by both the fast loop and the safe loop below.
+ */
+/* Error codes for read_variable_length() (kernel uses a named enum, not a typedef) */
+enum variable_length_error { loop_error = -2, initial_error = -1, ok = 0 };
+
+static FORCE_INLINE unsigned int
+read_variable_length(const BYTE **ip, const BYTE *lencheck,
+		     int loop_check, int initial_check,
+		     enum variable_length_error *error)
+{
+	unsigned int length = 0;
+	unsigned int s;
+
+	if (initial_check && unlikely((*ip) >= lencheck)) {
+		/* overflow detection */
+		*error = initial_error;
+		return length;
+	}
+
+	do {
+		s = **ip;
+		(*ip)++;
+		length += s;
+		if (loop_check && unlikely((*ip) >= lencheck)) {
+			/* overflow detection */
+			*error = loop_error;
+			return length;
+		}
+	} while (s == 255);
+
+	return length;
+}
+
 /*
  * LZ4_decompress_generic() :
- * This generic decompression function covers all use cases.
- * It shall be instantiated several times, using different sets of directives.
- * Note that it is important for performance that this function really get inlined,
- * in order to remove useless branches during compilation optimization.
+ * Covers all use cases.  The wrappers below call it with fixed flag values, so
+ * keeping it FORCE_INLINE lets the compiler fold them into constants and drop
+ * the dead branches, giving each wrapper its own trimmed-down copy.  A
+ * branch-light fast loop copies 32-byte chunks until the output nears the end,
+ * where the safe loop takes over; endOnInput selects safe vs legacy fast.
  */
 static FORCE_INLINE int LZ4_decompress_generic(
 	 const char * const src,
@@ -87,8 +241,6 @@ static FORCE_INLINE int LZ4_decompress_generic(
 	BYTE *cpy;
 
 	const BYTE * const dictEnd = (const BYTE *)dictStart + dictSize;
-	static const unsigned int inc32table[8] = {0, 1, 2, 1, 0, 4, 4, 4};
-	static const int dec64table[8] = {0, 0, 0, -1, -4, 1, 2, 3};
 
 	const int safeDecode = (endOnInput == endOnInputSize);
 	const int checkOffset = ((safeDecode) && (dictSize < (int)(64 * KB)));
@@ -99,6 +251,11 @@ static FORCE_INLINE int LZ4_decompress_generic(
 	const BYTE *const shortoend = oend -
 		(endOnInput ? 14 : 8) /*maxLL*/ - 18 /*maxML*/;
 
+	const BYTE *match;
+	size_t offset;
+	unsigned int token;
+	size_t length;
+
 	DEBUGLOG(5, "%s (srcSize:%i, dstSize:%i)", __func__,
 		 srcSize, outputSize);
 
@@ -116,15 +273,200 @@ static FORCE_INLINE int LZ4_decompress_generic(
 	if ((endOnInput) && unlikely(srcSize == 0))
 		return -1;
 
-	/* Main Loop : decode sequences */
+#if LZ4_FAST_DEC_LOOP
+	if ((oend - op) < FASTLOOP_SAFE_DISTANCE)
+		goto safe_decode;
+
+	/* Fast loop : decode sequences as long as output < oend-FASTLOOP_SAFE_DISTANCE */
 	while (1) {
-		size_t length;
-		const BYTE *match;
-		size_t offset;
+		/* Main fastloop assertion: We can always wildcopy FASTLOOP_SAFE_DISTANCE */
+		assert(oend - op >= FASTLOOP_SAFE_DISTANCE);
+		if (endOnInput)
+			assert(ip < iend);
+
+		token = *ip++;
+		length = token >> ML_BITS;	/* literal length */
 
-		/* get literal length */
-		unsigned int const token = *ip++;
-		length = token>>ML_BITS;
+		/* decode literal length */
+		if (length == RUN_MASK) {
+			enum variable_length_error error = ok;
+
+			length += read_variable_length(&ip, iend - RUN_MASK,
+					(int)endOnInput, (int)endOnInput, &error);
+			if (error == initial_error)
+				goto _output_error;
+			if ((safeDecode) && unlikely((uptrval)(op) +
+						length < (uptrval)(op))) {
+				/* overflow detection */
+				goto _output_error;
+			}
+			if ((safeDecode) && unlikely((uptrval)(ip) +
+						length < (uptrval)(ip))) {
+				/* overflow detection */
+				goto _output_error;
+			}
+
+			/* copy literals */
+			cpy = op + length;
+			LZ4_STATIC_ASSERT(MFLIMIT >= WILDCOPYLENGTH);
+			if (endOnInput) {	/* LZ4_decompress_safe() */
+				if ((cpy > oend - 32) ||
+				    (ip + length > iend - 32))
+					goto safe_literal_copy;
+				LZ4_wildCopy32(op, ip, cpy);
+			} else {	/* LZ4_decompress_fast() */
+				/*
+				 * LZ4_decompress_fast() cannot copy more than 8
+				 * bytes at a time : it doesn't know the input
+				 * length, and relies on end-of-block properties.
+				 */
+				if (cpy > oend - 8)
+					goto safe_literal_copy;
+				LZ4_wildCopy(op, ip, cpy);
+			}
+			ip += length;
+			op = cpy;
+		} else {
+			cpy = op + length;
+			if (endOnInput) {	/* LZ4_decompress_safe() */
+				/*
+				 * We don't need to check oend, since we check it
+				 * once for each loop below.
+				 */
+				if (ip > iend - (16 + 1/*max lit + offset + nextToken*/))
+					goto safe_literal_copy;
+				/*
+				 * Literals can only be <= 14, but hope compilers
+				 * optimize better when copying by a register size.
+				 */
+				LZ4_memcpy(op, ip, 16);
+			} else {	/* LZ4_decompress_fast() */
+				LZ4_memcpy(op, ip, 8);
+				if (length > 8)
+					LZ4_memcpy(op + 8, ip + 8, 8);
+			}
+			ip += length;
+			op = cpy;
+		}
+
+		/* get offset */
+		offset = LZ4_readLE16(ip);
+		ip += 2;
+		match = op - offset;
+		assert(match <= op);
+
+		/* get matchlength */
+		length = token & ML_MASK;
+
+		if (length == ML_MASK) {
+			enum variable_length_error error = ok;
+
+			if ((checkOffset) &&
+			    (unlikely(match + dictSize < lowPrefix))) {
+				/* Error : offset outside buffers */
+				goto _output_error;
+			}
+			length += read_variable_length(&ip,
+					iend - LASTLITERALS + 1,
+					(int)endOnInput, 0, &error);
+			if (error != ok)
+				goto _output_error;
+			if ((safeDecode) && unlikely((uptrval)(op) +
+						length < (uptrval)op)) {
+				/* overflow detection */
+				goto _output_error;
+			}
+			length += MINMATCH;
+			if (op + length >= oend - FASTLOOP_SAFE_DISTANCE)
+				goto safe_match_copy;
+		} else {
+			length += MINMATCH;
+			if (op + length >= oend - FASTLOOP_SAFE_DISTANCE)
+				goto safe_match_copy;
+
+			/* Fastpath check: skip LZ4_wildCopy32 when true */
+			if ((dict == withPrefix64k) || (match >= lowPrefix)) {
+				if (offset >= 8) {
+					assert(match >= lowPrefix);
+					assert(match <= op);
+					assert(op + 18 <= oend);
+
+					LZ4_memcpy(op, match, 8);
+					LZ4_memcpy(op + 8, match + 8, 8);
+					LZ4_memcpy(op + 16, match + 16, 2);
+					op += length;
+					continue;
+				}
+			}
+		}
+
+		if ((checkOffset) && (unlikely(match + dictSize < lowPrefix))) {
+			/* Error : offset outside buffers */
+			goto _output_error;
+		}
+		/* match starting within external dictionary */
+		if ((dict == usingExtDict) && (match < lowPrefix)) {
+			if (unlikely(op + length > oend - LASTLITERALS)) {
+				if (partialDecoding) {
+					/* reach end of buffer */
+					length = min(length, (size_t)(oend - op));
+				} else {
+					/* end-of-block condition violated */
+					goto _output_error;
+				}
+			}
+
+			if (length <= (size_t)(lowPrefix - match)) {
+				/*
+				 * match fits entirely within external
+				 * dictionary : just copy
+				 */
+				memmove(op, dictEnd - (lowPrefix - match),
+					length);
+				op += length;
+			} else {
+				/*
+				 * match stretches into both external
+				 * dictionary and current block
+				 */
+				size_t const copySize = (size_t)(lowPrefix - match);
+				size_t const restSize = length - copySize;
+
+				LZ4_memcpy(op, dictEnd - copySize, copySize);
+				op += copySize;
+				if (restSize > (size_t)(op - lowPrefix)) {
+					/* overlap copy */
+					BYTE * const endOfMatch = op + restSize;
+					const BYTE *copyFrom = lowPrefix;
+
+					while (op < endOfMatch)
+						*op++ = *copyFrom++;
+				} else {
+					LZ4_memcpy(op, lowPrefix, restSize);
+					op += restSize;
+				}
+			}
+			continue;
+		}
+
+		/* copy match within block */
+		cpy = op + length;
+
+		assert((op <= oend) && (oend - op >= 32));
+		if (unlikely(offset < 16))
+			LZ4_memcpy_using_offset(op, match, cpy, offset);
+		else
+			LZ4_wildCopy32(op, match, cpy);
+
+		op = cpy;	/* wildcopy correction */
+	}
+safe_decode:
+#endif
+
+	/* Safe loop: decode the remaining sequences near the end of the output. */
+	while (1) {
+		token = *ip++;
+		length = token >> ML_BITS;	/* literal length */
 
 		/* ip < iend before the increment */
 		assert(!endOnInput || ip <= iend);
@@ -189,28 +531,19 @@ static FORCE_INLINE int LZ4_decompress_generic(
 
 		/* decode literal length */
 		if (length == RUN_MASK) {
-			unsigned int s;
+			enum variable_length_error error = ok;
 
-			if (unlikely(endOnInput ? ip >= iend - RUN_MASK : 0)) {
-				/* overflow detection */
+			length += read_variable_length(&ip, iend - RUN_MASK,
+					(int)endOnInput, (int)endOnInput, &error);
+			if (error == initial_error)
 				goto _output_error;
-			}
-			do {
-				s = *ip++;
-				length += s;
-			} while (likely(endOnInput
-				? ip < iend - RUN_MASK
-				: 1) & (s == 255));
-
-			if ((safeDecode)
-			    && unlikely((uptrval)(op) +
-					length < (uptrval)(op))) {
+			if ((safeDecode) && unlikely((uptrval)(op) +
+						length < (uptrval)(op))) {
 				/* overflow detection */
 				goto _output_error;
 			}
-			if ((safeDecode)
-			    && unlikely((uptrval)(ip) +
-					length < (uptrval)(ip))) {
+			if ((safeDecode) && unlikely((uptrval)(ip) +
+						length < (uptrval)(ip))) {
 				/* overflow detection */
 				goto _output_error;
 			}
@@ -218,48 +551,66 @@ static FORCE_INLINE int LZ4_decompress_generic(
 
 		/* copy literals */
 		cpy = op + length;
+#if LZ4_FAST_DEC_LOOP
+safe_literal_copy:
+#endif
 		LZ4_STATIC_ASSERT(MFLIMIT >= WILDCOPYLENGTH);
 
 		if (((endOnInput) && ((cpy > oend - MFLIMIT)
 			|| (ip + length > iend - (2 + 1 + LASTLITERALS))))
 			|| ((!endOnInput) && (cpy > oend - WILDCOPYLENGTH))) {
+			/*
+			 * We've either hit the input parsing restriction or the
+			 * output parsing restriction.  In either case the next
+			 * (and last) sequence must be a run of literals.
+			 */
 			if (partialDecoding) {
+				/*
+				 * Since we are partial decoding we may be in this
+				 * block because of the output parsing
+				 * restriction, which is not valid since the
+				 * output buffer is allowed to be undersized.
+				 */
+				assert(endOnInput);
+				/*
+				 * If we're in this block because of the input
+				 * parsing condition, then we must be on the last
+				 * sequence (or invalid), so we must check that we
+				 * exactly consume the input.
+				 */
+				if ((ip + length > iend - (2 + 1 + LASTLITERALS)) &&
+				    (ip + length != iend)) {
+					goto _output_error;
+				}
+				assert(ip + length <= iend);
+				/*
+				 * We are finishing in the middle of a literals
+				 * segment.  Break after the copy.
+				 */
 				if (cpy > oend) {
-					/*
-					 * Partial decoding :
-					 * stop in the middle of literal segment
-					 */
 					cpy = oend;
-					length = oend - op;
-				}
-				if ((endOnInput)
-					&& (ip + length > iend)) {
-					/*
-					 * Error :
-					 * read attempt beyond
-					 * end of input buffer
-					 */
-					goto _output_error;
+					assert(op <= oend);
+					length = (size_t)(oend - op);
 				}
+				assert(ip + length <= iend);
 			} else {
-				if ((!endOnInput)
-					&& (cpy != oend)) {
-					/*
-					 * Error :
-					 * block decoding must
-					 * stop exactly there
-					 */
+				/*
+				 * We must be on the last sequence (or invalid)
+				 * because of the parsing limitations so check
+				 * that we exactly regenerate the original size
+				 * (must be exact when !endOnInput).
+				 */
+				if ((!endOnInput) && (cpy != oend))
 					goto _output_error;
-				}
-				if ((endOnInput)
-					&& ((ip + length != iend)
-					|| (cpy > oend))) {
-					/*
-					 * Error :
-					 * input must be consumed
-					 */
+				/*
+				 * We must be on the last sequence (or invalid)
+				 * because of the parsing limitations so check
+				 * that we exactly consume the input and don't
+				 * overrun the output buffer.
+				 */
+				if ((endOnInput) &&
+				    ((ip + length != iend) || (cpy > oend)))
 					goto _output_error;
-				}
 			}
 
 			/*
@@ -270,12 +621,13 @@ static FORCE_INLINE int LZ4_decompress_generic(
 			ip += length;
 			op += length;
 
-			/* Necessarily EOF when !partialDecoding.
+			/*
+			 * Necessarily EOF when !partialDecoding.
 			 * When partialDecoding, it is EOF if we've either
-			 * filled the output buffer or
-			 * can't proceed with reading an offset for following match.
+			 * filled the output buffer or hit the input parsing
+			 * restriction.
 			 */
-			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
+			if (!partialDecoding || (cpy == oend) || (ip == iend))
 				break;
 		} else {
 			/* may overwrite up to WILDCOPYLENGTH beyond cpy */
@@ -293,38 +645,16 @@ static FORCE_INLINE int LZ4_decompress_generic(
 		length = token & ML_MASK;
 
 _copy_match:
-		if ((checkOffset) && (unlikely(match + dictSize < lowPrefix))) {
-			/* Error : offset outside buffers */
-			goto _output_error;
-		}
-
-		/* costs ~1%; silence an msan warning when offset == 0 */
-		/*
-		 * note : when partialDecoding, there is no guarantee that
-		 * at least 4 bytes remain available in output buffer
-		 */
-		if (!partialDecoding) {
-			assert(oend > op);
-			assert(oend - op >= 4);
-
-			LZ4_write32(op, (U32)offset);
-		}
-
 		if (length == ML_MASK) {
-			unsigned int s;
+			enum variable_length_error error = ok;
 
-			do {
-				s = *ip++;
-
-				if ((endOnInput) && (ip > iend - LASTLITERALS))
-					goto _output_error;
-
-				length += s;
-			} while (s == 255);
-
-			if ((safeDecode)
-				&& unlikely(
-					(uptrval)(op) + length < (uptrval)op)) {
+			length += read_variable_length(&ip,
+					iend - LASTLITERALS + 1,
+					(int)endOnInput, 0, &error);
+			if (error != ok)
+				goto _output_error;
+			if ((safeDecode) && unlikely((uptrval)(op) +
+						length < (uptrval)op)) {
 				/* overflow detection */
 				goto _output_error;
 			}
@@ -332,6 +662,14 @@ static FORCE_INLINE int LZ4_decompress_generic(
 
 		length += MINMATCH;
 
+#if LZ4_FAST_DEC_LOOP
+safe_match_copy:
+#endif
+		if ((checkOffset) && (unlikely(match + dictSize < lowPrefix))) {
+			/* Error : offset outside buffers */
+			goto _output_error;
+		}
+
 		/* match starting within external dictionary */
 		if ((dict == usingExtDict) && (match < lowPrefix)) {
 			if (unlikely(op + length > oend - LASTLITERALS)) {
@@ -373,13 +711,14 @@ static FORCE_INLINE int LZ4_decompress_generic(
 			}
 			continue;
 		}
+		assert(match >= lowPrefix);
 
 		/* copy match within block */
 		cpy = op + length;
 
 		/*
 		 * partialDecoding :
-		 * may not respect endBlock parsing restrictions
+		 * may end anywhere within the block
 		 */
 		assert(op <= oend);
 		if (partialDecoding &&
@@ -402,6 +741,7 @@ static FORCE_INLINE int LZ4_decompress_generic(
 		}
 
 		if (unlikely(offset < 8)) {
+			LZ4_write32(op, 0); /* silence msan warning when offset == 0 */
 			op[0] = match[0];
 			op[1] = match[1];
 			op[2] = match[2];

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.43.0


