Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9340CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B416B009B; Fri, 26 Jun 2026 04:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBF46B009D; Fri, 26 Jun 2026 04:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA196B009E; Fri, 26 Jun 2026 04:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4832C6B009B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:10:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93AA7C1A02
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:10:36 +0000 (UTC)
X-FDA: 84921342072.05.3EF957F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id D8D444000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:10:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ENjONjxk;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461434;
	b=y2mr1N03SrabIz946AHCxp/2SNdMGX7TcBypSzzs6BWcu0xpKV2NzDx+EV4g61eftAUQVQ
	WC31ehLiFWpmpM+GiwyMW7862ge5risUFRql8eLK+onx5Sj+vimTHqQ7871MlvuWO5p+O0
	4kUJUAgWLoO+U05yZFhSJDmkZKr+hYE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=48i67nzh9pxu8NTOl7eRiJOeiFO+TayVZ9b4xMQJyfc=;
	b=2UUogM85BbHe1YtQ57B5aDls3AmIPilJTdBB541L5ebmr0o1KV8WSf9SEA8tcTb8tlIfXw
	g2KtRWB0K4CL3/gsIBrz+GYFByediyGhqXj+BijnKKJDKqaKpBX5D0vWH6h0yecg+TJ82W
	a+ieil5lB3GzCscXlYl/a1L4rnHKG4k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ENjONjxk;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c81d971f9cso1623155ad.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 01:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782461434; x=1783066234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=48i67nzh9pxu8NTOl7eRiJOeiFO+TayVZ9b4xMQJyfc=;
        b=ENjONjxkfcArbkwVb9m9WiNf2yPvDnhz0VdfJj6FXLHP3HzwEkrBo8TVDIhM6gEb9K
         Tj1wZ33vullF6ge68dOYicmW+07OWOp6GEQ6UcstwjX/ZduZrSGNXT3aT1WNNH2Id8hV
         zwTPfryJR8kVc61HEDq709Sp3jzp6uydQVhbXQRmjjT30YBsLLu1TifRz7Oi8EJvGzR3
         GbkCbl3SX5tmQ1jtdHR10sln/pwrpbvNExhaxQ6BBOHyWMKHVjNeIX3pMPrCawgky2Cd
         XUAAivhbisRMXLrw98LpqxXyZ5HokawYgzEtAkkb3/tvhCnv1ThXyoQBeR4Gkr1nIyLf
         PYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782461434; x=1783066234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48i67nzh9pxu8NTOl7eRiJOeiFO+TayVZ9b4xMQJyfc=;
        b=ZrGChgd9tWP+4bwHWWTrHw3N3dX/fRIdm5MGArsfnwz26Pjc/036wXvJIz33Huz3rP
         x1Ta1APCmDRxRebp1ibzmCFGOmZKJio4/4s4NRMsTc5wgdAfixxbJCrrb81eOPEg9ot0
         mqTGQ5lMM0lfAM9gkWltsk1BSXzi3TVTweQtno/yxycL+YJUVj6DBm48xGaPjHBklRtz
         YCzllFZSZPYKgsCn5z0MHxZjpixE5QWQKp8NWqKmH/pGBuJ/T3tmqPyP0qbFPufJp1uh
         dZ8nzOPie6505ctlmRWXngw5UN67wj0QQIBS564iYa82sdreLZrnLyyugjYDkkTdHeCf
         BRrQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBPAYvtXckuoXiwfiyQvPaRP/dBM3b43kzXY3/Rf2gvEQSb2lZtIUpDDQ3Jy8Q3teryfALoJautg==@kvack.org
X-Gm-Message-State: AOJu0YxS0YiqeWEiom91DJFurYZA/ZmX/m1eIjDCKL81Ck0UTAy871YO
	5gmsBvRe6zdwLMjrRj0zdgpdmpYdQpjKDcPlXwXk9dH3mpC/HDPZgG1i
X-Gm-Gg: AfdE7clTUaQ77NYtmHm5OusJX0ntudX9Buh2s8bO/k3FHKFNN3qYQdaQWk5DV3yKynJ
	BGa6P1/bKMXDFgsrokPWzUayei+mJ8FtyGwgFZB3xR9BoA9okRp20XQJa7G5TNTB4JfW9+kE2E+
	jJsYjJBgQS8qOmbKzx6Klk8eTGuC6GzLbcDLcoVWcY/pEZlvzcG5iHosWv0zVFTUO5LyJuJ6+CA
	PyJN4cqwxgD51aQ+7AmPqDtx/UhAJ1T96TV+FzPkaSLLzZWRiHmw3Nm7G+QYxwnVmMbqfHIDZhT
	TgAuvcs/q5wymJQdj5f1/ZCPsdUoQHdZOitYXsM+R33G5J6w4zDwZAL33h1WW2PyUlgL/ht+sq/
	87EQyJgKyx+9v42dOcafAKwn9TIXhhdXVrE0veJzNvgGfjxNRB1Woy+KiARShi+TpvQmQamFxKJ
	JqeXsZEe7vZfUD+6lOGIX5sTjgZfYT/JrRWNeKQ7ofcVbMbjdHKrk=
X-Received: by 2002:a17:902:ebc6:b0:2c6:af4b:99a1 with SMTP id d9443c01a7336-2c7c3d2a805mr134249435ad.3.1782461433641;
        Fri, 26 Jun 2026 01:10:33 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9a5:e298:5467:317e:e807:794b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63cfe81sm34154045ad.55.2026.06.26.01.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 01:10:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH] mm/damon/reclaim: add 'available' memory as an optional watermarks metric
Date: Fri, 26 Jun 2026 16:10:38 +0800
Message-ID: <20260626081038.46569-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8D444000D
X-Rspam-User: 
X-Stat-Signature: j4brptu5tna94yomidqxtuzg7miypgf6
X-HE-Tag: 1782461434-624869
X-HE-Meta: U2FsdGVkX1/nO11Ys8AA8J2DeMdlKw7wmDLDlb+wGzSxCGm2m92j3C/WYBczF6LoLXVrJx+tPXJ1VS+vaagPPj1z37s+WZPCsV2YqMlaEIsJD6O+4ORDrnLxsw1xjKDeHu9pouRhDprRojrbdSadlFOM3YvztSI9q+V9aUehIZLzbsyf+RJqppvLXKaL7XDJcVik3zgQyDaJLlQ+sUCDFrTCF3cGyO2scgLtPP/EJS0vTuwbNZy4o6j46O812cSfWqiCRzZ2p45pTATSypuox+U8PY/mG6hJaX1obA+um8oBHTdHwqo75p9D50ifs9ZMHeTpWJYYGHUfpk4c9Xidaf+i2kLS6ND5X9hzl8JlTd6ysutwEx8FeUPMNKd8v0bkEEELwZ9Vj4uJvEN841m+ZwuUJfXRf00heWdO2fHxFPn7Of93CqReniHdUbpd8fenrN3KUwCkRTfoCb8Zt3tBtKPxunor12dg43DcJOAi1YPPTjk4HXN2sN7K26kI5a2UQfs1IuqLfhkTmDpk/vT8EHidW9JNWXiSug3mICEzzxpi5Q55F8IVaiFyr+mwGKeMrFfgqeIZWp2wZTCn8VY+cfU5wjJXd3nnENyK3qBcwiMyP5pVQJHBTiPheJY9OtipKq9TOGPJtvVhmHnhM5YMuvWL6AKRdtxQX7yCnJ6tlJqNMcyKQQtOiNut98xWlQ500SPScvkdixDj8YoApBYj7dKyVzkXm5wzOgzrfIDUcEmvv1LiC9ywPY2DUtO58d94JHXNojnJqW17OMVjniYraP0VwjcORZYKVFPJgMVLU/GtdUK1x63CxaZwph6gB347tKOklqPFpHAq7bAPjoGRh11O98aYENxu3GFx/T7p+C3IAg8p7Qc1T7eifujIabA6Q8ssTZwgljsVoGQI/j0rpdFl6WgShLoDX3349m2K4ZZ1QWBs6pPvMosa1/LsbEwlk2QX6iUg1jg6RC2Sotd
 mA8nO7hS
 +hJnQFRGm2Hvo6ZHtjEhScjnhfq11k/Zh/140R9X41smApnLzduVuwrv8/UmoRINvufcSsyYZNbN3MaqW45l1h3xD+4g7L/bQwDbSLiDI++MdPHM5+pM4cELZX8oUJGBaxr7+S5NKxeFm1wU+Or2T2aE0Zff29zIIUoB34XDVMzNtub5zYO9q6lMUF1KVtfIM+PuZg9VNhf/hFKwEARe80EsCqaCdokCR3AsPmsHxK44gltToCFuj5n0Qm3zAGgVfIZOUq8mD4eG2r1SNhbKFS53aQG6lYWKwEpAJ5njdCoEDEf19OL3bSXEhPboTNTk8ByocDsmybcp9kwULozKgtqkZ3h4y1GhrXMawzBYq0HSsG4RMZnzAxRt3tyloi+k4f6vQ7f82Eu3QaUCJqZaet207nOEieqipLhFH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======

Currently, DAMON's watermarks metric is calculated based on the
proportion of the system's free memory.

However, on devices like Android, the system typically maintains a very
low amount of free memory, even when the available memory is abundant.
This causes DAMON_RECLAIM to prematurely or aggressive trigger memory
reclamation, thereby increasing the risk of page refaults.

Solution
========

Introduce a new sysfs parameter 'memrate_type' to DAMON_RECLAIM. Users
can switch DAMON's watermark metric evaluation to be based on available
memory by writing 'available' to this parameter and commit the change.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 include/linux/damon.h    |  9 ++++---
 mm/damon/core.c          |  6 +++++
 mm/damon/reclaim.c       | 56 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-schemes.c |  4 +++
 4 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6f7edb3590ef..0006e3a25317 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -314,13 +314,16 @@ struct damos_quota {
 /**
  * enum damos_wmark_metric - Represents the watermark metric.
  *
- * @DAMOS_WMARK_NONE:		Ignore the watermarks of the given scheme.
- * @DAMOS_WMARK_FREE_MEM_RATE:	Free memory rate of the system in [0,1000].
- * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
+ * @DAMOS_WMARK_NONE:		    Ignore the watermarks of the given scheme.
+ * @DAMOS_WMARK_FREE_MEM_RATE:	    Free memory rate of the system in [0,1000].
+ * @DAMOS_WMARK_AVAILABLE_MEM_RATE: Available memory rate of the system in
+ *				    [0,1000].
+ * @NR_DAMOS_WMARK_METRICS:	    Total number of DAMOS watermark metrics
  */
 enum damos_wmark_metric {
 	DAMOS_WMARK_NONE,
 	DAMOS_WMARK_FREE_MEM_RATE,
+	DAMOS_WMARK_AVAILABLE_MEM_RATE,
 	NR_DAMOS_WMARK_METRICS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b0..f12d06081d70 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3300,11 +3300,17 @@ static bool kdamond_need_stop(struct damon_ctx *ctx)
 static int damos_get_wmark_metric_value(enum damos_wmark_metric metric,
 					unsigned long *metric_value)
 {
+	long available_pages;
+
 	switch (metric) {
 	case DAMOS_WMARK_FREE_MEM_RATE:
 		*metric_value = global_zone_page_state(NR_FREE_PAGES) * 1000 /
 		       totalram_pages();
 		return 0;
+	case DAMOS_WMARK_AVAILABLE_MEM_RATE:
+		available_pages = si_mem_available();
+		*metric_value = available_pages * 1000 / totalram_pages();
+		return 0;
 	default:
 		break;
 	}
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index ce4499cf4b8b..229bc68bb1ad 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -159,6 +159,17 @@ static unsigned long addr_unit __read_mostly = 1;
 static bool skip_anon __read_mostly;
 module_param(skip_anon, bool, 0600);
 
+/*
+ * Watermarks metric options.
+ *
+ * If this parameter is set as ``free``, DAMON_RECLAIM calculates the watermark
+ * metric based on the system's free memory rate. If set as ``available``, it
+ * calculates the metric based on the system's available memory rate.
+ *
+ * Default is ``free``.
+ */
+static enum damos_wmark_metric memrate_type = DAMOS_WMARK_FREE_MEM_RATE;
+
 static struct damos_stat damon_reclaim_stat;
 DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
 		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
@@ -220,6 +231,8 @@ static int damon_reclaim_apply_parameters(void)
 		goto out;
 	}
 
+	damon_reclaim_wmarks.metric = memrate_type;
+
 	attrs = damon_reclaim_mon_attrs;
 	if (autotune_monitoring_intervals) {
 		attrs.sample_interval = 5000;
@@ -376,6 +389,49 @@ module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
 MODULE_PARM_DESC(addr_unit,
 	"Scale factor for DAMON_RECLAIM to ops address conversion (default: 1)");
 
+static int damon_reclaim_memrate_type_store(const char *val,
+					    const struct kernel_param *kp)
+{
+	if (sysfs_streq(val, "free"))
+		memrate_type = DAMOS_WMARK_FREE_MEM_RATE;
+	else if (sysfs_streq(val, "available"))
+		memrate_type = DAMOS_WMARK_AVAILABLE_MEM_RATE;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int damon_reclaim_memrate_type_load(char *buffer,
+					   const struct kernel_param *kp)
+{
+	int type = READ_ONCE(memrate_type);
+	int len = 0;
+
+	if (type == DAMOS_WMARK_FREE_MEM_RATE)
+		len += sysfs_emit_at(buffer, len, "[free] ");
+	else
+		len += sysfs_emit_at(buffer, len, "free ");
+
+	if (type == DAMOS_WMARK_AVAILABLE_MEM_RATE)
+		len += sysfs_emit_at(buffer, len, "[available] ");
+	else
+		len += sysfs_emit_at(buffer, len, "available ");
+
+	len += sysfs_emit_at(buffer, len, "\n");
+
+	return len;
+}
+
+static const struct kernel_param_ops memrate_type_param_ops = {
+	.set = damon_reclaim_memrate_type_store,
+	.get = damon_reclaim_memrate_type_load,
+};
+module_param_cb(memrate_type, &memrate_type_param_ops, &memrate_type, 0600);
+MODULE_PARM_DESC(memrate_type,
+		 "Memory rate type for watermarks metric "
+		 "(free or available, default: free)");
+
 static bool damon_reclaim_enabled(void)
 {
 	if (!ctx)
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..5d6636433bd6 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1056,6 +1056,10 @@ damos_sysfs_wmark_metric_names[] = {
 		.metric = DAMOS_WMARK_FREE_MEM_RATE,
 		.name = "free_mem_rate",
 	},
+	{
+		.metric = DAMOS_WMARK_AVAILABLE_MEM_RATE,
+		.name = "available_mem_rate",
+	},
 };
 
 static ssize_t metric_show(struct kobject *kobj, struct kobj_attribute *attr,
-- 
2.54.0


