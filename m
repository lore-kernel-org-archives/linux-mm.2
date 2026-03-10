Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE21BFD4F05
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0226B00A0; Tue, 10 Mar 2026 12:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336516B00A1; Tue, 10 Mar 2026 12:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1058B6B00A3; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC8F36B00A1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1C1F8A8E8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:40 +0000 (UTC)
X-FDA: 84530679240.05.16E1686
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id B825BC000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7s/8dO0IBbFGVFY52YJWBDxGNegYTFxW9CtA++XdlKs=;
	b=fLp++kF/OpeZUzbUkmZXpr2XxGdLLxa57YhZNoHid/WdIP/9MyJyXZzPBoBDy1qc0AIlQN
	Bp/2KyW3syscFJKCKJGDQZrmW/5KZO5klR2O/2DxmkGoafjh/s0CoqI3ZR2VJt8NGL7QKl
	eD3nqzlEcSQeCn9zbRUn/hmSg4J2crI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159939; a=rsa-sha256;
	cv=none;
	b=3zA7QjX3pbYSqKaXnNNouaCJSnf5bjRLf8mCls5Uv1hXePrnqVCIWt4RMkRK+52m/ZwBQS
	6ElQO5mxztu/G3hJ4lEtnA89yrMEvyMsS6rdtouSOCU1/YxWU3BLh7fCDX1dViLah7Mtve
	avROhz3xyTBGk0PGvh9bR6bAxqFe8XA=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fVfNd1dkxzJ467N;
	Wed, 11 Mar 2026 00:24:49 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F59840086;
	Wed, 11 Mar 2026 00:25:34 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 19:25:33 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 1/4] mm/damon: Generic context creation for modules
Date: Tue, 10 Mar 2026 16:24:17 +0000
Message-ID: <20260310162420.4180562-2-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
References: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: f3od9m8xqj15cgc5yh99hwp8wjuegift
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B825BC000D
X-HE-Tag: 1773159938-124284
X-HE-Meta: U2FsdGVkX1/ADgSEm6gLvNrNaxJyFQ+3KNDrNt/VFLA124LMD6yX/SJdIs3pXgXfGWvyjJm9vrBes9/TS+jL4olDU4JNnsFHQ4i5mUuh0wyMtvYJdFnlBz3S0nOdO/opESM1PDuCf+wFvj96Kl9KgZVAJJpF5f6Mz5lLlI2M15j50ut1Dv737T+xqUt9GI1OXDZ/asbRDr5kUgE9i45h8bFGHR06DkrbFbApau8mC0L+wuxv43em0hbLRMhlWnQNX3iElU1SbMxRK7+a0gHTQvlMT6tD6C/8IDFizm+P4MmCT0GicvqAgzBpKy1mI80w2ZA1lazLt7MTaj3S8h8+yG3pXKogQQ4IWgmqPFx8LCAwPVWnrqbEkSr7nllvfuwiSTS1BwunBScLUncVLYBYgGd+tp5fVwNzGdFMb3K164wmW8ZLBhm6nrRkDjGFnFitH6mdut48jpE6gY/5ZIjcvRDaBbB/5bpUuuQTYA7kBWcdHuqaYlBVLzRE5bPBW2jmbg3xm0MLqYWzLPPg4tWWdGIPFfETbsls48uqV8474+W1iG211oWIL9/Y9s7IZ+rGWdOEG4c0pqthJBibADD/mRwEU2GTGfjmb9Iv+vLDQu1ACurSmnQ1KeMwNdQCo3MtKJ/mR1xBI5PA9FU4UEEfdfYO4FLNBE9MT2tbwmQTEWiFg4L6APrDeT7kYNlVzr68zAxbk72E5jRhpVGfKV8lrgtOYa5iGryeEw5tAgJ9PTeEjxzkIABXe/TpQeCWLs/vTR8EKkzQIZ4Ob3eLvWA90O6b2OqPI0dwTAmxWipWMUDvmEnOd/f7T1IP74OMgjlgVSDzQZKhsdVjoDw1oi3fA5j5waIVudWTNKzL9uS+UjZSCOP5/kPerU/Jj96v85qpgHuhlF4Ls2Xiz2IPYUfgz0ax6HInlrYu3M4LTIhLM7JUDqQfr3HU+2GXwNzBdU+HpmgC8FU6XfGj5UH1cqg
 QOjQun/m
 hpjHizIyPs3dSRhGkKRIdR+TUiUalFCaQBB4z4ytCl2YbIbNMg//+H5vy2A3abctD02VvysBEPTWQlzch0bKP78Wnq3axB4S1g9jlAQBP4h//aneXrlql5UsObXnW/BkiR5jeDCY/DnqUrS5TRp0nJDN+WR/s9X1Zdaf28IiNSaHDluOZ5mZfcguu325JBOGmsRRrxdl/8K2Qm6zVuvQ60s3ujdnnTBV3qbJJqGpCQGFm/USQ217XQcBlx5LeJx33tmtA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

It is more elegant to have a generic version of new context creation
which receives the mode as a parameter.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 mm/damon/lru_sort.c       | 5 +++--
 mm/damon/modules-common.c | 6 +++---
 mm/damon/modules-common.h | 4 ++--
 mm/damon/reclaim.c        | 5 +++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7bc5c0b2aea3..143ee0b21da6 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -287,7 +287,8 @@ static int damon_lru_sort_apply_parameters(void)
 	unsigned int hot_thres, cold_thres;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
+				DAMON_OPS_PADDR);
 	if (err)
 		return err;
 
@@ -479,7 +480,7 @@ static int __init damon_lru_sort_init(void)
 		err = -ENOMEM;
 		goto out;
 	}
-	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
 	if (err)
 		goto out;
 
diff --git a/mm/damon/modules-common.c b/mm/damon/modules-common.c
index 86d58f8c4f63..ae50b2fa3a86 100644
--- a/mm/damon/modules-common.c
+++ b/mm/damon/modules-common.c
@@ -14,8 +14,8 @@
  * @ctxp:	Pointer to save the point to the newly created context
  * @targetp:	Pointer to save the point to the newly created target
  */
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp)
+int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp, enum damon_ops_id mode)
 {
 	struct damon_ctx *ctx;
 	struct damon_target *target;
@@ -24,7 +24,7 @@ int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+	if (damon_select_ops(ctx, mode)) {
 		damon_destroy_ctx(ctx);
 		return -EINVAL;
 	}
diff --git a/mm/damon/modules-common.h b/mm/damon/modules-common.h
index f103ad556368..379b49c6a617 100644
--- a/mm/damon/modules-common.h
+++ b/mm/damon/modules-common.h
@@ -45,5 +45,5 @@
 	module_param_named(nr_##qt_exceed_name, stat.qt_exceeds, ulong,	\
 			0400);
 
-int damon_modules_new_paddr_ctx_target(struct damon_ctx **ctxp,
-		struct damon_target **targetp);
+int damon_modules_new_ctx_target(struct damon_ctx **ctxp,
+		struct damon_target **targetp, enum damon_ops_id mode);
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 43d76f5bed44..24786a58683a 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -197,7 +197,8 @@ static int damon_reclaim_apply_parameters(void)
 	struct damos_filter *filter;
 	int err;
 
-	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
+	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
+				DAMON_OPS_PADDR);
 	if (err)
 		return err;
 
@@ -381,7 +382,7 @@ static int __init damon_reclaim_init(void)
 		err = -ENOMEM;
 		goto out;
 	}
-	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	err = damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_PADDR);
 	if (err)
 		goto out;
 
-- 
2.43.0


