Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C08F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2CF6B0089; Mon, 13 Apr 2026 11:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D046B008A; Mon, 13 Apr 2026 11:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2831F6B0092; Mon, 13 Apr 2026 11:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2C346B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:01:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E0561A01EC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:01:35 +0000 (UTC)
X-FDA: 84653846550.13.201AA6B
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2EEB91C0014
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:01:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776092493; a=rsa-sha256;
	cv=none;
	b=KOTSMaJNlBpEH9BrtPovELnRDZNHpQMKQBTSyfe095hjB/kJJ5I1Ai12qqiMnvIsGrqonI
	uPxIiPVtnlGDa13761QNb9RId2B/woP0q59JJpmiWSEPUehe62/wQbN9HlpZOFqPmjFFIZ
	jlwNsgpZbaHeIWDC4pXvzHQrCJgMtBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776092493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Pg/tkWKg5Ww9uOXu7gfreh9h+k6GdEWLDS4LUWfNC2M=;
	b=TDmuxjFjLCZqfehyATazwPDyLTK/wI55xVpNFMTGhwrXbnWAlNbQyh+H7TmxbDByn/YiKm
	57B8wn93kYOu2S0I9hEnIksMUcUvOh+z6kEJLCnPE8LJm+YCaOqDe8mmYRsG/qTkeXEiHy
	l1WumPjzvkwz5epGZeI69dMfhZyH5OY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fvVwX3XmBzHnH2m;
	Mon, 13 Apr 2026 23:01:16 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id C09974057A;
	Mon, 13 Apr 2026 23:01:28 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 18:01:28 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 1/1] mm/damon: generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Mon, 13 Apr 2026 14:59:43 +0000
Message-ID: <20260413145943.512192-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EEB91C0014
X-Stat-Signature: dnuwq7scof7gopbs63qb55473ec51uox
X-HE-Tag: 1776092491-895991
X-HE-Meta: U2FsdGVkX188gY6fe17Wqcw8KuodmGkdrqYY3KFWCtt+Gh1niCE1i8h4LavdO99UKlIo/jOsgmWpbScylYjtQ/fQ+TZArQO1Qa4XHPE76j2+e+upJ05R3TLCQuak1f6hksJBf4m9R603cMVFJ0WGTqqfCpXhHe5dY70qdVHIhzHlAjEWaG+fIibtPVGX0mEZmF9L/p667SDuIgF3KPKlADoX5HALBz8CQArnxvkM+mmJN+lo4Gkcmxp8J4GfJv1hbxvzJ50q3qDglDP4ELWWrXF1QKRuy4KIvAmP+iAO7Gzz9drnieY6Key3+GbhL9YWLAFkibsQazAsBHCvgbmbj3akxegaZPuHpu5Zdbkd09q7QLJ94xeWlzhfOWGADT274fHOVawDFu+s5tOeI7d1HFKqFnakfhfYqWDZer2eLBsKrsq8EQPiCcBWAjcLHgERSlWPawIXlKm/UFFSsfpZ9nsbc4JHAaM5T4ce5HjXvSC4reDVOhKONvMGFECUOU1MLG9itOXzpxPez7DHA387/OvQS4/gpciir2KNSaSFhsFJcWkahsNbLsU9WDRR06W3lNqaj2iy6kvCLxN+LQTSEMrTc/wJY0guCyifa/k1lrFxJc19IRsXf8n7kLzC9GH48F6QmF9kSfGHt0IKLKue08vz7WNAdyiTqwl0iau4K4/v7heZZSgVmlK7fE0gwsCD1VG/QlFlZLi3MLYAzOHRv1OfF8fo0SdGSUwFO1g4O3DE61s2NTRQC0ar7Y4XWHMniIJNivqnwXnTu8H3lcdI58uZ2vSJdi8eavub7IALMUnneu9nAmvfhQVu5LzuM9GUutDQ82kuFbxHswzmmVjIlZxikUjPPtRwADxegIsOXmbNbwoaRDzKdkNDPeG0q/aBPUNlMgt88GWR4YT7UyLE1PN03AS5okydZ4x9lvtaBx5GTXG8GsxTwXrPJhVL+TeWuBlvm+gclfcMaEtoL7N
 dIqxg+QF
 VrVBKyriliwT+hec2QJJc+wps2uaUxAo7jBKcCFtTDUeIWabOi/G/bhcc1TCi4XHZdGW8UprBXU793CME+F4gM99wdJSKjCTo2gjb419JYGfaFBhu0fPNy93C2BEqLTN5SXoGHDsEP2S3oFmJhUs5wZUeM6nvWqYwVAGnME4Yl60UfhPpQounPIK/9+XY0oiZserZxTxF97kb9+hx0EnMGabwYzUrJvGBoaDEd/WHZaBK8GYwBL+ffGd6d8LYdpMSnyHebml7r409EvuKD7OwBnrOty/0FbJEKN8oUPtW/PlWogQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch adds a new function damon_modules_new_vaddr_ctx_target.
Since ctx_target creation for vaddr and paddr is almost identical,
the logic is extracted to a new function,
damon_modules_new_ctx_target, and vaddr and paddr functions are left
just as interfaces.

This change was suggested earlier[1] and it is needed to allow
developers to create DAMON modules that use DAMON_OPS_PADDR targets.

[1]: https://lore.kernel.org/damon/20260311005759.90440-1-sj@kernel.org/

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Suggested-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/modules-common.c | 31 +++++++++++++++++++++++++++----
 mm/damon/modules-common.h |  3 +++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..fe12d109c87b 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -10,12 +10,13 @@
 #include "modules-common.h"
 
 /*
- * Allocate, set, and return a DAMON context for the physical address space.
+ * Allocate, set, and return a DAMON context.
  * @ctxp:	Pointer to save the point to the newly created context
  * @targetp:	Pointer to save the point to the newly created target
+ * @id:	Set of operations, physical or virtual
  */
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+static int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp, enum damon_ops_id id)
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
+ * @ctxp:	Pointer to save the point to the newly created context
+ * @targetp:	Pointer to save the point to the newly created target
+ */
+int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp)
+{
+	return damon_modules_new_ctx_target(ctxp, targetp, DAMON_OPS_PADDR);
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
+	return damon_modules_new_ctx_target(ctxp, targetp, DAMON_OPS_VADDR);
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


