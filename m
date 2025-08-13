Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB640C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217558E01AE; Tue, 12 Aug 2025 23:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1D28E01AD; Tue, 12 Aug 2025 23:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8AF8E01AE; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0AAC8E01AD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7D6B1DB52B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:42 +0000 (UTC)
X-FDA: 83770362564.01.49D4D1F
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56A07140009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OBE1hvg1Cl34Iv4to1jswOCIl9QBO3y3HYi/ztK292M=;
	b=YXDQZE19tRQ9XTAWrf4fRC7QSdJCfh0c7TlX9+55WKbkDWF6TDcG/E5cdcMZ4n6Q9EiZNw
	Jhz1edrwV/ymxJR6McHyItMrui8DGTbYxcD4fpKtx8fhpm2dS5loVauvLEziwcr/8OKEj3
	joPEr4XyhzGXsQQwYkXVJz1ugADtP3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057161; a=rsa-sha256;
	cv=none;
	b=fcxWL5LQsq8NQJn5DTS+a+dI//SJCklSOQCBP+X9pbf9s+HcQZrR2tuGwCCEjHHFTtuWUq
	+5I5kbN3mL5xXW+MKQ5cbr+joVBkea/4Yo094W4B2bDQe0QYLoQO1TFUtk5smveCdF6Zpz
	HSCF28T+NQp2/fNcYg+Y35NL4MmfGns=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c1vWv5tP6z1R902;
	Wed, 13 Aug 2025 11:49:47 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id AB8D114027A;
	Wed, 13 Aug 2025 11:52:37 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:36 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 11/16] mm/damon: add addr_unit for DAMON_RECLAIM and LRU_SORT
Date: Wed, 13 Aug 2025 13:07:01 +0800
Message-ID: <20250813050706.1564229-12-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56A07140009
X-Stat-Signature: g9iqtqsqy6ixsjohdtz7ws91e5dkarai
X-HE-Tag: 1755057159-504027
X-HE-Meta: U2FsdGVkX1/yoNNXW4UlJQFa6eJb7MoLPACRjV+lvqO95AyDEwrU1p5JDhyfS1CqpIWVziwrsEZZaIt+Ra9kxFbhvv7rpDXCMwkpAYdOA8IGuf6vpiW2CBUfAA0Pebt+3jLp7tNyYuxUFA/QxvxaKfpKjtOLl7GTkor75YgfmVike6S1gCnMufmeAkd//nXT/KzuelWUV2cXj5bPc9UwAL9yOS5yjUJlnqaBZxV7fMuA3GUFIfPGxt7oU6O1UfR6a/KOR/niDEQmKwhnNqQkpxiyonRxLDORPCTgFAXc88t9XM8knVl4mi04lunygzG7pEFrIRr/Bb8jG380D+YhfIMUZoYJvloNs07ETiPY2AKKQEcyBp17JQWjevphwCMd5b4JtIvFjKdQwYiMj3Yk9ZILHWyZ54LmhtmfKB9y9shwDzLJjUgOS0fuBzMdRYfBVCUua4DQPIBUFi/YSkG7yUCgLxDgFUJGoMwXOL1CQGBR77BXZV9EOw5AB9Rhe/rfzr70Xnm3gs/KYq5rbhW49RXqu4uWGEZvmolZ93gRMmh8U3l8Dg3TfCZ7S88j3HxDXfIb5CSYnnkN2gy6ZyDc0iu595M9582//fzOwk59STy1axqDqD3kqTTKki/k67FyVcjpZalURvAHll9/KCLf2m0GKsgI3IZckkqImVyZn7Ih9dKG70CmGqu6iSMGDYl6AYScNLtPiD5v8ZCz8UqU4Zna18Nxearw08mNl2Z3jmdgTgSjfdrrw0GgOVK5gtWlsOgLcvJDMXPyeDHvTaaBgFtiNMJ+wglMXLwxF5q4umifkNF7Oma5zrDShzOuTjXFA3H/DTwq/3edgHTpSBHg1Yfn6ps+W1SubKSrobcNyT1nqIl8HnpmLgwUFpdUivCm6VNLnbUMh3aiJF1GwPLipXZaxM+XVV9VooSUfj5TvsgQybWeBz5yEJE9n9WZlwZ6pdN7y1IZYyBDQD3Bqo0
 wbPTSdVt
 7KpEjQoXV0PKZeECxjIHBn727DHHGwh00ZythCOLsxFvmNEraDujYe/YIn9XhPssPY7Up/P3DBaXGlSv9skTnMvDrO70yGjKEXqwkYy9UggPJ2fOBiSgiqmWsybQY3Q8x3xL7GICBUOCqLDEG4X/y2LTYlypFJoGWu3RcnVN0426sUtHDx74NHx6NlbYInzHBdklnsNxnkicgKP3k9eg0Y9DNRzTyxmZq+mdD/9mCAuCBZeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In module DAMON_RECLAIM and DAMON_LRU_SORT, the damon_ctx is
independent of the core, necessitating dedicated addr_unit
integration for these features.
Additionally, if the input monitor_region_start and monitor_region_end
are both 0 while addr_unit is set to a non-zero valuethe default
system RAM range should be divided by addr_unit.

Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 include/linux/damon.h     |  4 +++-
 mm/damon/core.c           | 14 ++++++++++----
 mm/damon/lru_sort.c       | 16 +++++++++++++---
 mm/damon/modules-common.c |  5 ++++-
 mm/damon/modules-common.h |  2 +-
 mm/damon/reclaim.c        | 16 +++++++++++++---
 mm/damon/stat.c           |  2 +-
 7 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b85c6c669cd0..1b7b4cf1a3c5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -942,7 +942,9 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end);
+						unsigned long *start,
+						unsigned long *end,
+						unsigned long addr_unit);
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1a8d3009d606..803c30f64b94 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2714,6 +2714,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @addr_unit:	Scale factor for core to ops address conversion.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds the biggest
@@ -2724,16 +2725,21 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end)
+						unsigned long *start,
+						unsigned long *end,
+						unsigned long addr_unit)
 {
 	struct damon_addr_range addr_range;
 
 	if (*start > *end)
 		return -EINVAL;
 
-	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end))
-		return -EINVAL;
+	if (!*start && !*end) {
+		if (!damon_find_biggest_system_ram(start, end) || !addr_unit)
+			return -EINVAL;
+		*start /= addr_unit;
+		*end /= addr_unit;
+	}
 
 	addr_range.start = *start;
 	addr_range.end = *end;
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 151a9de5ad8b..8107d08c5e4b 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -111,6 +111,14 @@ module_param(monitor_region_start, ulong, 0600);
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
 
+/*
+ * Scale factor for DAMON_LRU_SORT to ops address conversion.
+ *
+ * This parameter is used to convert to the actual physical address.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+module_param(addr_unit, ulong, 0600);
+
 /*
  * PID of the DAMON thread
  *
@@ -194,7 +202,8 @@ static int damon_lru_sort_apply_parameters(void)
 	unsigned int hot_thres, cold_thres;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target,
+			addr_unit);
 	if (err)
 		return err;
 
@@ -221,7 +230,8 @@ static int damon_lru_sort_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					addr_unit);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
@@ -323,7 +333,7 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_lru_sort_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err = damon_modules_new_paddr_ctx_target(&ctx, &target, 1);
 
 	if (err)
 		goto out;
diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..613b7cc99368 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -13,9 +13,10 @@
  * Allocate, set, and return a DAMON context for the physical address space.
  * @ctxp:	Pointer to save the point to the newly created context
  * @targetp:	Pointer to save the point to the newly created target
+ * @addr_unit:	Scale factor for modules to ops address conversion.
  */
 int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+		struct damon_target **targetp, unsigned long addr_unit)
 {
 	struct damon_ctx *ctx;
 	struct damon_target *target;
@@ -24,6 +25,8 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->addr_unit = addr_unit;
+
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
index f103ad556368..c7048a449321 100644
--- a/mm/damon/modules-common.h
+++ b/mm/damon/modules-common.h
@@ -46,4 +46,4 @@
 			0400);
 
 int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp);
+		struct damon_target **targetp, unsigned long addr_unit);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 3c71b4596676..0e11b121d693 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -128,6 +128,14 @@ module_param(monitor_region_start, ulong, 0600);
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
 
+/*
+ * Scale factor for DAMON_RECLAIM to ops address conversion.
+ *
+ * This parameter is used to convert to the actual physical address.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+module_param(addr_unit, ulong, 0600);
+
 /*
  * Skip anonymous pages reclamation.
  *
@@ -190,7 +198,8 @@ static int damon_reclaim_apply_parameters(void)
 	struct damos_filter *filter;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target,
+			addr_unit);
 	if (err)
 		return err;
 
@@ -229,7 +238,8 @@ static int damon_reclaim_apply_parameters(void)
 
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
-					&monitor_region_end);
+					&monitor_region_end,
+					addr_unit);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
@@ -327,7 +337,7 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_reclaim_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err = damon_modules_new_paddr_ctx_target(&ctx, &target, 1);
 
 	if (err)
 		goto out;
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 87bcd8866d4b..ae7377e7409f 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
+	if (damon_set_region_biggest_system_ram_default(target, &start, &end, ctx->addr_unit))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.34.1


