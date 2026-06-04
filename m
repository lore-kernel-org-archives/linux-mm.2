Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70359CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320386B0093; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313356B0096; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164E56B0095; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 092816B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:04:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2660120141
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:39 +0000 (UTC)
X-FDA: 84842551878.22.9BB0C72
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 630A62002F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:04:30 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780585470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+p0/RBuQRaBsziDgezlLtukeizs4bDB3qb+hgSN71o=;
	b=PdDBfgutWlwsFwl6Kc5LAKfeuEFOGT6SBoyCl2OvQmKclnnZJOjKDTjPXUzi7B2/KjudVT
	TAnaxGxd0n5YPfLVUxujgPCLCCWT+hFQknFNVEULr6/WTUCPi3LnqSS3OCgkuQdYjXS1fL
	zoRG6PSG0fdTot4kBrI4TQEVAk8yXp8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780585470;
	b=tQcMB8i8qJrg5cRmNdQHzDSCOW9G3swhqAWeOj3M7EdnkKYrsHYjCFsgtKg5t68gbapNV7
	UQAcckO5I8M1vhHSYH8hdDlVtaxrvG5Q9yUH2JHDutTHkheJ8/n/KcENfK/WdATKjvKY06
	aIHC6lRGEjhXFqmKb/Tj2zN02ZpALgE=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gWSX56FnjzJ468x;
	Thu,  4 Jun 2026 23:04:21 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 8E64D40569;
	Thu,  4 Jun 2026 23:04:25 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Jun 2026 18:04:25 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 2/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Thu, 4 Jun 2026 15:03:35 +0000
Message-ID: <20260604150338.501128-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
References: <20260604150338.501128-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-HE-Tag: 1780585470-851773
X-HE-Meta: U2FsdGVkX18nw4zVl2LcjBXIGDp7ccYYAbzBYLT7J+lVMr6eM6So3vwdU/oRHzQ0dN0s48Poc9/ZVxq2S99dkje4zHapc2mDVjeIaESv1qqhrxvBDeL2szPpwcAkchKrPKWhOHC29CUlPxqpLyc2ujl1LLH8WJepvHvYRu/tRD2zfp/djo0olDPMoqaaep9bl+tVry96xJy0DMejuIM+zMndbqN+tuvLLzT9NrhlMJhVl+//wBoUskWwWT4iH4LSJEaI//MBJ/cznDvFlImL66f6Q1B4haC2kl7OlpkuoznSIOreNMQWHU7B0VDSMZrh66z3qKJfyu+vQT4ER1Q/MKd1OXyXnCbGJnh4jNmxU+L4ulBEZs7LmacaMEsjMbmFhFodv2XmvX3PN3BNvvXKsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch adds a new function damon_modules_new_vaddr_ctx_target.
Since ctx_target creation for vaddr and paddr is almost
identical, the logic is extracted to a new function,
damon_modules_new_ctx_target, and vaddr and paddr functions
are left just as interfaces.

This change was suggested earlier1 and it is needed to allow
developers to create DAMON modules that use DAMON_OPS_VADDR targets.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Suggested-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/modules-common.c | 31 +++++++++++++++++++++++++++----
 mm/damon/modules-common.h |  3 +++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..9b0cc80378f8 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -10,12 +10,13 @@
 #include "modules-common.h"
 
 /*
- * Allocate, set, and return a DAMON context for the physical address space.
+ * Allocate, set, and return a DAMON context.
  * @ctxp:	Pointer to save the point to the newly created context
  * @targetp:	Pointer to save the point to the newly created target
+ * id:	DAMOS op id. It can be VADDR or PADDR
  */
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+static int _damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+				struct damon_target **targetp, enum damon_ops_id id)
 {
 	struct damon_ctx *ctx;
 	struct damon_target *target;
@@ -24,7 +25,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, id)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
@@ -40,3 +41,25 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	*targetp = target;
 	return 0;
 }
+
+/*
+ * Allocate, set, and return a DAMON context for the physical address space.
+ * @ctxp:       Pointer to save the point to the newly created context
+ * @targetp:    Pointer to save the point to the newly created target
+ */
+int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
+				struct damon_target **targetp)
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
+				struct damon_target **targetp)
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


