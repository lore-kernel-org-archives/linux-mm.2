Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CBE9CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1D06B0098; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A2A6B0095; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3E36B009B; Fri, 22 May 2026 10:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AED56B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:56:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B813C1C1C21
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:59 +0000 (UTC)
X-FDA: 84795355638.21.A35DCCA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7D8040011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:55:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779461758; a=rsa-sha256;
	cv=none;
	b=kJCaQyL/YyfwbEGOgb7pgMsYLxUMSH/qLHgllQKr9Ah+BtseHttGtA7TMSSZJrTWO8fLkh
	QdMnxzTk7UcWBmF0t8GDwQ03NHBPka3cSYga3/KyFC26HgQN0TZ+VdLZImu6g+hvikfPE3
	ggykKosHbVBnN0K0dcU9Pz+Vbosi2tM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779461758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JRdMJmQF0dZKGH1DnXJbpc+z0y0+nSzcvugFg3jIqY=;
	b=S2SISiDw9zC4emCGU0YP38R3kuYrGvT5jeEDWZFCqLQuJJgxFXf/UE6NiE07GteofsHRAi
	E+5E53DAfSxVGzTuEyF3SS2FrarkbLCwRzx2tk4h72d4fmk1k6OAmNz6GrynTpVbKJq5fa
	5HMOuN7j/hgUXi7e+KCwjT7fIH+hA/E=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gMSxp4s2czHnGcp;
	Fri, 22 May 2026 22:55:26 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B47840575;
	Fri, 22 May 2026 22:55:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 May 2026 17:55:54 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 1/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Fri, 22 May 2026 14:55:15 +0000
Message-ID: <20260522145518.158910-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
References: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: A7D8040011
X-Rspamd-Server: rspam03
X-Stat-Signature: w7me4x8jf8qjwgwgoid4xih96wanhwsm
X-HE-Tag: 1779461757-610636
X-HE-Meta: U2FsdGVkX1+5e2Kd0j0dOrTKdmSELGhW5b1RanwfjjzSObU4+hi90rf48Mp1Sfe6N8VuNux+rnytv+VtK+d9YZYhfnwI3ay9nqEVCLpT2E13awIo1Zkn+H1CsvzrIgcl6UOE8RlKFcbkLtvsErh6i/uu//2YQ3MW4MpQM/aNL2Tvyrwb29xzrTxnRR2YsegdKqdtQa8sv/Avda5VoBNM5YS559kHIQTupoVolzws6KpVpaVS7qE5Oxhg8iBT06WjSNun3grQj/mqcjuY7hVZG0bDEylDCa7oLhhcyR5xbZNZYpKI+dqIMV7KPN6KGNorXAE7GI/gdwKoCInYZ1mfrB1kFPrbVRhvpxEQiKOhLY7evNuUKYOQZMnLD+NeY2bmMVytGbW9gxQkL+QPBqfoOPUahCqGGzpulaRsnvU8xylh1GokH3laZ3cvYF0pmnMPgGVkx5t0kP2iPBKefNxZByxG3S68Rz1Vqm01OXdUjndE9B2V5GDVL7dnBBV7U8F/awdLvZpQEZIfE1k8qt7/07MnIWNKzguUu2OsxMHLma1+5ytMuC86CqvBJxyid//PQ64f3Yr0D1PtilybMU60103Nf7Ys6//y8/Ux5T5s1+2wTOMy5a+VbFhD326kRDfQCDfnvmePYmdarIbEdoHB1Jf6Oj/bVY9r6KpniKebGmGP8up0ZznTXvZryHnjsD1EvFVwoe51T32jnulZfrH6wfJhV+F3KpUyKCBWPLenWq+JKStC44rn+MFZvGF4meTwp7ohbZxU8Ko7Ioh00Uadr+nAHWC9N20G4L82g9St0Dzf8hmjUFo2CzMQebyjgHsh7MUWxe8CBr04BjjL+YEiEf24qrVGNFA/gtSYG+fvAAOX7yACL5tDoJNMJ5Vi1QRp91hHwwxNU8XjGI51LVjRLQe66F2Bt6JdVe4cvOjdMhwLRbnciGY+gkpMbE9/fyZCaUR6F/0G7RfTMN407DJ
 P8ihFYvW
 yGlA+/sSgqcarqLukp2Up6jI4txQQm82GgqqHy7tOO3b0xlY9NKnPAixIm0W8YMKdpCYv6RTt7EyI0dHIxHa2Op+XF/vVxTEg7t3PdLLeaNUl+aaeoJB3BSZyYNf2A3as8YLON7aGB7wEWGHfyq+GvewwofNHaKqCooYYJdER/xNr4SjjXScuJsGwTIu+YNwy2GQaKPxhqCkusNGKtoqMuXCkrjYLca/xnOtp0WHtHxKwmrHg60wuja/2iEJTgVHUdCU8ThcCg4qH/n1fEG4/T3C/r/L7g51YlU6XQq7m/886zmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch adds a new function damon_modules_new_vaddr_ctx_target.
Since ctx_target creation for vaddr and paddr is almost identical, the
logic is extracted to a new function, damon_modules_new_ctx_target,
and vaddr and paddr functions are left just as interfaces.

This change was suggested earlier1 and it is needed to allow
developers to create DAMON modules that use DAMON_OPS_VADDR targets.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Suggested-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/modules-common.c | 33 +++++++++++++++++++++++++--------
 mm/damon/modules-common.h |  3 +++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..35a4a89b6caa 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -9,13 +9,8 @@
 
 #include "modules-common.h"
 
-/*
- * Allocate, set, and return a DAMON context for the physical address space.
- * @ctxp:	Pointer to save the point to the newly created context
- * @targetp:	Pointer to save the point to the newly created target
- */
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+static int _damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp, enum damon_ops_id id)
 {
 	struct damon_ctx *ctx;
 	struct damon_target *target;
@@ -24,7 +19,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, id)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
@@ -40,3 +35,25 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	*targetp = target;
 	return 0;
 }
+
+/*
+ * Allocate, set, and return a DAMON context for the physical address space.
+ * @ctxp:	Pointer to save the point to the newly created context
+ * @targetp:	Pointer to save the point to the newly created target
+ */
+int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp)
+{
+	return _damon_modules_new_ctx_target(ctxp, targetp, DAMON_OPS_PADDR);
+}
+
+/*
+ * Allocate, set, and return a DAMON context for the virtual address space.
+ * @ctxp:	Pointer to save the point to the newly created context
+ * @targetp:	Pointer to save the point to the newly created target
+ */
+int damon_modules_new_vaddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp)
+{
+	return _damon_modules_new_ctx_target(ctxp, targetp, DAMON_OPS_VADDR);
+}
diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
index f103ad556368..324b9cb4957e 100644
--- a/mm/damon/modules-common.h
+++ b/mm/damon/modules-common.h
@@ -47,3 +47,6 @@
 
 int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 		struct damon_target **targetp);
+
+int damon_modules_new_vaddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp);
-- 
2.43.0


