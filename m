Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90A5CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8EE6B0088; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A7B6B008C; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C587C6B0092; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B68166B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:03:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 711511C28D3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:44 +0000 (UTC)
X-FDA: 84867951168.16.B275247
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 540BFA001C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:03:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jck/2yFBR/kMHHFywrbQBp9bdT2uTbcTk57OZAS2ey0=;
	b=ffcYuQ8W4188Jldz89l6tu7lqxMzKdljwbgtgO9JufBkfR9e/QM0VrIGDG2N4hf1FNTPLQ
	+ywfxzFiPgMXDTz8OzX/QMU+Ts7VLkLfhj2hyynSSqYc8Kq853q7qpNzlpO86UumHgnfB1
	GMuMnm28jJoVglTtUP8Go/RMAbJXbaQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190221;
	b=eMEpLp/P6kY915SXFIzrRpZBj5D+2m4LONz3D2SpY2vLU0xB8wuitsu8KIVITpYWS44uzy
	s8THRLKZWtweMVe0S72goNAmZHg4TkVM9YPGAOyKTqFnh3OZ/ZPTuEtcHlQSri+rszs2lX
	uSdPgQbzjucD2XboUHMpecKGKGOF5RA=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gbm9l13dczJ46BB;
	Thu, 11 Jun 2026 23:03:23 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 6656540569;
	Thu, 11 Jun 2026 23:03:38 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 18:03:38 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 2/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 11 Jun 2026 15:02:42 +0000
Message-ID: <20260611150244.3454699-3-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
References: <20260611150244.3454699-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 540BFA001C
X-Stat-Signature: whjxb3ieugazn1m1qah4kg5xiptg17ks
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781190221-831273
X-HE-Meta: U2FsdGVkX1+46m/n4GluFSprWH0i8pq4tnX7snMq02DSPP3QDDHs7u0k7MLybftKvDMtHzKSp0SIty7Ak6Q+0pe6he9oJRb06RCytuOiMee3R/o9zAodwIYyU8YrLsPYqMAzYkMXcDodiQ4oelhoVXzarab0RZTKWw1yAiRGJK5dNn3Yq1vWTJDbhsQjZYx2pRVmHdxsZJOvHMhU1ggtn11b26WbVbg3Ueig8NusDIcHFUVPHpY72tNToDBw4NiNcOYtK/yS6zFSEoV9nJdP+/hlBWnovaHBPS6jafEkWiUEQeCKNwBCeTsXDlKYEg7l38+g5MfjjjZhEW7WlzYVBsrNLlgLo4yK+hXuZGI1rKu8ytjscL2clDKq1dQKu/KUbSy2XoKNXhauOJIxKyvXkBUu6TFzR9zy4dq/fLO1AcvGlZIOhpzUs9oGo3bAljupeL85/3xHZxsBXfNddK+gwLpI/nCrFpaaVCWdtl3Injf5wkIH6oIDYMyNRqeBhaYJ/ht0c4z10CiMUU5T4PQHNTcVt2dTP+O5FkfzAxFrmJ4GacU9V7uplh8m9Hsy64SODpth45lgNECtECSq3DyfBlHDbYk5HMcpIq6YjGuzNhUEVBWyXwe0UrRIevrIzL9QZMdhiUf/0dZQO6KQv8QHOfYHdTih+7oLOv4DdpxadA5IG48MHpLOHATc8VK7lGJ6nKIoZdupt3nrDeV5938/XJbpF9sE8JXb3PJ5lhj5luGGLsMGFcYWwO8Z2+z+qN4N3T/9VD2RF/7LpKucl43Uu4S+vKVNJVRY2NhVbWWQJjj1Ze5uqr4QWzFlx02P6JY2uyvhN7o8lzTQNVa8SE2PHLDHHbYFznCaOoxJiSsloAELKP7qO5/tA6G4KfiWHMBrJ8R+pVGCyy3KeXxu3N6RAUvqaZCe45r40e/D0NqCpA6KvmEgsuuEM+KDTf9mjW4yKwoR2HQKcmX3WJ+exZM
 /A3HnWfa
 njVWPWbvdcR+bxxIzKemVEeojKvpzR5KbVzLSlY5g1Hh4PempLWtXJGRvAx+R8gtiIBitCXSqaLj/xmxj3IU6rP5lVjY02Btv0kzJ5uMTOim9NarVJV0PpE5xOmRlFkrmvIqpKYJY02PKXARWI0gox4ETBkzr11HwBAq9e3/RzilKuXEIeBiMHQ85BN6HxAiZjqqyJMtERB+WtoHtvGV+mRyDepDyU1Rth8NhsT+ndw4xSz8uDP6QSDFcCV9m6Qkx0egULc9FQLv/SDze9NsoY2TqyHm7mtXUkDi7MaE5m60QHRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch introduces a new DAMON module (SAMPLE_DAMON_HUGEPAGE)
which collapses hot regions into huge pages.

SAMPLE_DAMON_HUGEPAGE operates in the virtual memory space, for a
specific task. The user is expected to supply the PID of the task
that is going to be monitored through the monitored_pid module
variable.

SAMPLE_DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
increase or decrease the aggressiveness of page collapsing. User
autotuning is also available for additional tuning aggressiveness
control.

The module also includes changes to the DAMON compilation, so that
the module can be enabled or disabled.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 samples/damon/Kconfig          |  12 ++
 samples/damon/Makefile         |   1 +
 samples/damon/hugepage.c (new) | 207 +++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+)

diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
index cbf96fd8a8bf..512f150aaabb 100644
--- a/samples/damon/Kconfig
+++ b/samples/damon/Kconfig
@@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
 
 	  If unsure, say N.
 
+config SAMPLE_DAMON_HUGEPAGE
+	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HUGEPAGE)"
+	depends on DAMON && DAMON_VADDR
+	help
+	  This module monitors a certain PID provided by the user through
+	  monitored_pid attribute. Hot regions are determined by DAMON-based
+	  sampling. Collapsing occurs according to the quota goal using total
+	  memory usage to huge page usage ratio. The ratio is set by the user
+	  through a module attribute.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/samples/damon/Makefile b/samples/damon/Makefile
index 72f68cbf422a..96bde2c44846 100644
--- a/samples/damon/Makefile
+++ b/samples/damon/Makefile
@@ -3,3 +3,4 @@
 obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
 obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
 obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
+obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= hugepage.o
diff --git a/samples/damon/hugepage.c b/samples/damon/hugepage.c
new file mode 100644
index 000000000000..2c7fd213a8db
--- /dev/null
+++ b/samples/damon/hugepage.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 HUAWEI, Inc.
+ *             https://www.huawei.com
+ *
+ * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
+ */
+
+#define pr_fmt(fmt) "damon_sample_hugepage: " fmt
+
+#include <linux/damon.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_sample_hugepage."
+
+static bool enabled __read_mostly;
+
+static unsigned long target_pid;
+module_param(target_pid, ulong, 0600);
+
+/* By default, total huge pages to system memory usage ratio set to 10% */
+static unsigned long quota_percentage_hugepage __read_mostly = 1000;
+module_param(quota_percentage_hugepage, ulong, 0600);
+
+static unsigned long quota_autotune_feedback __read_mostly;
+module_param(quota_autotune_feedback, ulong, 0600);
+
+static struct damon_ctx *ctx;
+static struct pid *target_pidp;
+
+static int damon_sample_hugepage_damon_call_fn(void *data)
+{
+	struct damon_ctx *c = data;
+	struct damon_target *t;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *r;
+		unsigned long hugepages = 0;
+
+		damon_for_each_region(r, t) {
+			if (r->nr_accesses > 0)
+				hugepages += r->ar.end - r->ar.start;
+		}
+		hugepages = hugepages / HPAGE_PMD_SIZE;
+		pr_info("hugepage: %lu\n", hugepages);
+	}
+	return 0;
+}
+
+static struct damon_call_control call_control = {
+	.fn = damon_sample_hugepage_damon_call_fn,
+	.repeat = true,
+};
+
+static int damon_sample_hugepage_start(void)
+{
+	int err;
+	struct damon_target *target;
+	struct damos *scheme;
+	struct damos_quota_goal *goal;
+
+	pr_info("start\n");
+
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return -ENOMEM;
+	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+
+	target = damon_new_target();
+	if (!target) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_add_target(ctx, target);
+	target_pidp = find_get_pid(target_pid);
+	if (!target_pidp) {
+		damon_destroy_ctx(ctx);
+		return -EINVAL;
+	}
+	target->pid = target_pidp;
+
+	scheme = damon_new_scheme(&(struct damos_access_pattern) {
+				.min_sz_region = HPAGE_PMD_SIZE,
+				.max_sz_region = ULONG_MAX,
+				.min_nr_accesses = 0,
+				.max_nr_accesses = UINT_MAX,
+				.min_age_region = 50,
+				.max_age_region = UINT_MAX},
+				DAMOS_COLLAPSE, 0,
+				&(struct damos_quota) {
+				.ms = 10,
+				.sz = 128 * 1024 * 1024,
+				.reset_interval = 1000,
+				.weight_sz = 0,
+				.weight_nr_accesses = 1,
+				.weight_age = 1,
+				.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL},
+				&(struct damos_watermarks){}, NUMA_NO_NODE);
+	if (!scheme) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damon_set_schemes(ctx, &scheme, 1);
+	goal = damos_new_quota_goal(DAMOS_QUOTA_HUGEPAGE_MEM_BP,
+				quota_percentage_hugepage);
+	if (!goal) {
+		damon_destroy_ctx(ctx);
+		return -ENOMEM;
+	}
+	damos_add_quota_goal(&scheme->quota, goal);
+
+	if (quota_autotune_feedback) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		if (!goal) {
+			damon_destroy_ctx(ctx);
+			return -ENOMEM;
+		}
+		goal->current_value = quota_autotune_feedback;
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
+	err = damon_start(&ctx, 1, true);
+	if (err) {
+		damon_destroy_ctx(ctx);
+		return err;
+	}
+
+	call_control.data = ctx;
+	err = damon_call(ctx, &call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
+}
+
+static void damon_sample_hugepage_stop(void)
+{
+	pr_info("stop\n");
+	if (ctx) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+}
+static int damon_sample_hugepage_enabled_store(const char *val,
+				const struct kernel_param *kp)
+{
+	bool is_enabled = enabled;
+	int err;
+
+	err = kstrtobool(val, &enabled);
+	if (err)
+		return err;
+
+	if (enabled == is_enabled)
+		return 0;
+
+	if (!damon_initialized())
+		return 0;
+
+	if (enabled) {
+		err = damon_sample_hugepage_start();
+		if (err)
+			enabled = false;
+		return err;
+	}
+	damon_sample_hugepage_stop();
+	return 0;
+}
+
+static const struct kernel_param_ops enabled_param_ops = {
+	.set = damon_sample_hugepage_enabled_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled,
+	"Enable or disable DAMON_HUGEPAGE (default: disabled)");
+
+static int __init damon_sample_hugepage_init(void)
+{
+	int err = 0;
+
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		pr_warn("Module not initialized\n");
+		return -ENOMEM;
+	}
+
+	if (enabled) {
+		err = damon_sample_hugepage_start();
+		if (err)
+			enabled = false;
+	}
+	return err;
+}
+
+module_init(damon_sample_hugepage_init);
-- 
2.43.0


