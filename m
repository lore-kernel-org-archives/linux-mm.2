Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497DEFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 13:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A9F6B0088; Thu, 30 Apr 2026 09:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AEA6B008A; Thu, 30 Apr 2026 09:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8407A6B008C; Thu, 30 Apr 2026 09:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1066B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:58:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A32BE1BAFDB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:42:01 +0000 (UTC)
X-FDA: 84715335642.14.15FF0CE
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8516840006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:41:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EEkNapgeFb2yLIUPcU6qU9c2nzNi7lZy4yQG8yBu2/A=;
	b=MG3u3I7rM3qXVOois1P43bR2WX3bfUkJMeI0sHNPNcY0NM13QyJgX2MnANcsCNK+Qp+P6I
	G5bhRjWr23+nrKrbHGBKgquCSTxPitqNv2OOgN1LbFWoyCx9b3mSd8Pck6ESYijr9VShdP
	LpA7vbQUmC4eR0HMF8M/ryoxZ3+H4C4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556519; a=rsa-sha256;
	cv=none;
	b=mtqJx+vdwSV7xd/mGXaX6BRqodfoXXbea+AYQlfGqdHnyaB9Ow7kve1KLNqfhRB4NNNgES
	bXLQGCIUMLBDUkqowpASkjB63uv2hBoy3zxkC/7WQ559VeUEI07cWemZApFjn4n5LQ5esC
	uYtoZO2inMh1hf502w6zvELABnZhHNw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g5wLz4LN2zJ46Zq;
	Thu, 30 Apr 2026 21:41:47 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D939140569;
	Thu, 30 Apr 2026 21:41:54 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Apr 2026 16:41:54 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v1 1/4] mm/damon: Generalize ctx_target creation for damon_ops_id and add vaddr support
Date: Thu, 30 Apr 2026 13:41:36 +0000
Message-ID: <20260430134139.2446417-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
References: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8516840006
X-Stat-Signature: dgzc11z1nsxxtmkcsnrjqgtmezr17efy
X-Rspam-User: 
X-HE-Tag: 1777556519-178554
X-HE-Meta: U2FsdGVkX185vg36mNOY+y4I/RHz8moKOdegD6Jgwjn43iMoKkV+JjX2+fR3ANA7T7jQqejBTJOOKzyE948kVR/7a8+Fy8L7bj39aCj3uCcCynBv1omdXyMt4lo2MeDMTq9/6B3ppqQVyQQI7Aj6YwEM2lnqCZcDd54+nKg949N+cWpcZRHgxpZuoGNGnHkj+HKIsMxc4vub3vO8sYIed5hGPcHPD3bF5liCMdr9FWM7HSD4+ZtlAj39IbaX4cfeqzgDnrjidBUqr81Ud/vkLbVYly8NR5DfivAvvRHCtK9WDblYAptvoiHsdZj37U3DCAdiSZDv3mXE07JLMGB4xOnP8pWMI1vwui0QU7O26NBrr2j1BGFnT7EGJNXfdBLAXkoXAv87/TuHTRAlNOOFtknU88Y1Y7hYswjfsSJxwxftuo+6Z+gj6rXsagNoamF8TGwSiDjEJtWRXII6jFeyMuuGaoRuRrKREyQvVdJR4wyB1x0GKAYWh6SyUc0CyZKnVVdFb6LidNra0R6omzKZN8y4NTkmvLckNyxEfJBvYYCVJM1fTW1G3XSGG+C3wlJavzfMh+PGAVsU3nP6NxMCxH9WxwTLuTtZ37XI2ODExee3dv5mgqSCPBSwmd7H+gpdUrte4pMcjYcWzOnAbuI8jl/ngm8igjQ2EskVPtW7kfyQVXVKaj5rBBtlA0TYraGtA4vRs1T4gzgMemqiz/ZHiTZAjhjtAFvti8fuViluFGES1ghECZ/+q0w4nJn+ko2chhnZl19huuWf+7emw4heWmvvKRay9l+nK+mhZ8OsKHzLLlBgcjXi7Jwyay8NLlKHZWMfx7TnOBkbIpXwnPRPvL15pKMRDU1E+xFtfZwWqDJuRGLqOLDjLRre9GhAW4UNNOLpZ4Vny6nOUccE85GU4qZxLm1GeB26ZlKB01DldWNrjrKbeW7PtvhaDNVcRt5yp1bmLVpG3DxX7Uz0hGr
 wSagEPT+
 /yDWdVq6IiikUi7cbMc5ElI42tvU3tCny4LN5Xtws9tA2749xOPtnXBZX12BY0KxhYFT6vKEJVNTdxrGP0a2XQ6VVRrCPvUrobz8o5ttIvR0WWfM2Us9Ngyver3ZQeKaDRAJuO8AuZvWXQaLnK/5jx+cID7U/1vJeg6irZITiUapUPAdMeUpoO88v+caAm15F6cCl5lnmmPY4W3kIeLAfFXkxeiizF/nISZhYwd6gOEgoM07ZUJc0QD2XVechoGRp8UqlqC33HFQ3GpPYwRtjBVVTZS2YhYxzRBr4X9If6E/Iapc0BImiv+pwNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch adds a new function damon_modules_new_vaddr_ctx_target.
Since ctx_target creation for vaddr and  paddr is almost identical,
the logic is extracted to a new function,
damon_modules_new_ctx_target, and vaddr and paddr functions are
left just as interfaces.

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


