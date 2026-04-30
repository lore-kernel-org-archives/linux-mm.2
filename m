Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802A7FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C04D6B008C; Thu, 30 Apr 2026 10:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F456B0092; Thu, 30 Apr 2026 10:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884E56B0093; Thu, 30 Apr 2026 10:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 752B96B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:18:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E175A34CB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:42:01 +0000 (UTC)
X-FDA: 84715335642.22.B7EFAF3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04E81180002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:41:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777556519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAPtr73ru/3aJF204/03BagGS4iT8mYQDU2NeFNpXDw=;
	b=tJ6uFwxLTpJu20J/eUKq+xHzt8ZiztrgA3YwsufORo/7rFyJtO9/NPLINRH3g0oEf9j9dr
	jvCwoyqaCsGBEkljx1EZ40fpplBRZvnGK1q/8fN+wytrGZptZk4zallexkKIxMDF1GfgzD
	i+GS5mC9d3WphhpJuKBn1Utqxcl8Y0Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf24.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777556519; a=rsa-sha256;
	cv=none;
	b=MtW6sunJdGDaxzYh26eTVhnFM0X5YvPvtb1sKQx8pnq/E0UQlQG6htlHExziNBUysUJaLD
	QAgGqzy7le2x4QyhowkUyf51UGFLVzCX6/wvDmsDKbflYm84nysmWq4dfQPM67b+8qhnhZ
	o0Qxnr8VS94FLklRNV009UzCUFRNyFU=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g5wLz5YrxzJ46Zt;
	Thu, 30 Apr 2026 21:41:47 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0EFCF40569;
	Thu, 30 Apr 2026 21:41:55 +0800 (CST)
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
Subject: [RFC PATCH v1 3/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 30 Apr 2026 13:41:38 +0000
Message-ID: <20260430134139.2446417-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
References: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04E81180002
X-Stat-Signature: xb8qb6fr4g5xsneebagnozpy93dt6sqk
X-HE-Tag: 1777556518-92799
X-HE-Meta: U2FsdGVkX188dMOqcNdg8kFVwJI7Fpt5XNJ/WgUSlaeSY8/PRuW6uPt+6iR9zfKTX06g+afTeHjcKaHlrfiZKmm+3jKslxYeEBMmj0dRI3RxgDg7jza+QqTrkHQTa2DoENCIWPvzELMf/vtrIkEzOLnF0SDsnDyu2czbpKCvQ8ukITS2bZSoBPcksZOA7rKufwfYQHSXyNjP6ACeHIkO+3JcW9uC9DqAJ7/2C7kcXPTkA9OBtOJ+JCptrcGUrQCuS/w2JR/k2JdMO5n9KfJPW5M8IRl5cxaDRj2DbzFK/ShqpCn/5XDDmfuXv1mHIiqgs0e0lP4bfo1t6p9dX4dnzy3hjw7+hlTYtbOYoiFc8YV9S8U5nnrc25+lOx1WjHrq1GyIyKKkMRdVw+8j7um7h67NBdArsbErAe5Gmo0FqWU2h0XBkE6SV2TD5PuR81O7gK/2hII8kMYBe5N7Jx79uG4TzWOBTU/eHAUBjl7UUhnUNj7fPNZ86ENXXJHLyOb6sNDrk7cD8On7MmjOSjJbqg3qhoWFKsmYfu+m6IA6fguHNk9NpySWMUHJqPDD4LUg0wdPcBxYiwWwE2m+k65q9+hE0CMBmNn8cJOOlMVNbrevjCIR6tGDxZJUH60b3sbL22FlkvoPnnlDVWH2HzNRw3QMj9vE3MehTKL/pfG/GYkjPFuUtE36+ZrEcxow2OwAzAxBlgaEhTxGUoO7MlRkQfFy4VI1orb/XR5i004Evi8KIOWOhoUn/+3/sLpaAdKEfgmjEjQIwwmOF1+6oZD7l4vfiluGKH8Ir8JpoCz27/hC75yF8g6M0B/S0IjTsCKAdjWfVOPSj7n+0FlqhxxCnWMSfksnqbERQ/qy45m5TfDdfGQXk9U+eT4PZIfLRq14I9kLM9EtDLn4MvijNwBwDeoGGJ5QjzUUXCUruwwkrBDLVuUhBsFvu8ryUwg3DRX9G9mIAkwyW1tGpZWqkrw
 YpeHc0qP
 K0aZ6XKqujbuhXGWecweNtos3Sfkalsdmu507sVtAVgwA7KRIIv7k9fcyY6sB/xGt25ZuY91P71T+r3PWv/d1oBW9eHazjogAeIqW2Pbgz/eVii2PWpXlvjKdFWTIo3AbvxLHN1zypN9DTiQ76qeW7jDejXmb+mcvEe4M38SonTPHDjNbIfNawUGxBOPg0slRBEw6R0BRhRRis+HzINsqES9ngWKd82cfHch3/rBMEHAJkq6HtIXesreqGJYPyl+rPZn4ah8yqDsjoBgaaxZNenW4Ya7+PGCEXlM573P5kbD9deU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

This patch introduces a new DAMON module (DAMON_HUGEPAGE)
which collapses hot regions into huge pages.

DAMON_HUGEPAGE operates in the virtual memory space, for a
specific task. The user is expected to supply the PID of
the task that is going to be monitored through the
monitored_pid module variable.

DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
increase or decrease the aggressiveness of page collapsing.
User autotuning is also available for additional tuning
aggressiveness control.

The module also includes changes to the DAMON compilation,
so that the module can be enabled or disabled.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 mm/damon/Kconfig          |   7 +
 mm/damon/Makefile         |   1 +
 mm/damon/hugepage.c (new) | 341 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 349 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 34631a44cdec..b615407cc13f 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -121,4 +121,11 @@ config DAMON_STAT_ENABLED_DEFAULT
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
 	  boot or runtime using its 'enabled' parameter.
 
+config DAMON_HUGEPAGE
+	bool "Build DAMON-based collapse of hot regions (DAMON_HUGEPAGES)"
+	depends on DAMON_VADDR
+	help
+	 Collapse hot region into huge pages. Hot regions are determined by
+	 DAMON-based sampling
+
 endmenu
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index d8d6bf5f8bff..7cb55cc483f9 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
+obj-$(CONFIG_DAMON_HUGEPAGE)	+= modules-common.o hugepage.o
diff --git a/mm/damon/hugepage.c b/mm/damon/hugepage.c
new file mode 100644
index 000000000000..02729736dc56
--- /dev/null
+++ b/mm/damon/hugepage.c
@@ -0,0 +1,341 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 HUAWEI, Inc.
+ *             https://www.huawei.com
+ *
+ * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
+ */
+
+#define pr_fmt(fmt) "damon-hugepage: " fmt
+
+#include <linux/damon.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+
+#include "modules-common.h"
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_hugepage."
+
+/*
+ * Enable or disable DAMON_HUGEPAGE.
+ *
+ * You can enable DAMON_HUGEPAGE by setting the value of this parameter
+ * as ``Y``. Setting it as ``N`` disables DAMON_HUGEPAGE.
+ */
+static bool enabled __read_mostly;
+
+/*
+ * Make DAMON_HUGEPAGE reads the input parameters again, except ``enabled``.
+ *
+ * Input parameters that updated while DAMON_HUGEPAGE is running are not applied
+ * by default.  Once this parameter is set as ``Y``, DAMON_HUGEPAGE reads values
+ * of parametrs except ``enabled`` again.  Once the re-reading is done, this
+ * parameter is set as ``N``.  If invalid parameters are found while the
+ * re-reading, DAMON_HUGEPAGE will be disabled.
+ */
+static bool commit_inputs __read_mostly;
+module_param(commit_inputs, bool, 0600);
+
+/*
+ * Scale factor for DAMON_HUGEPAGE to ops address conversion.
+ *
+ * This parameter must not be set to 0.
+ */
+static unsigned long addr_unit __read_mostly = 1;
+
+static long monitored_pid;
+module_param(monitored_pid, ulong, 0600);
+
+/*
+ * Time threshold for hot memory regions identification in microseconds.
+ *
+ * If a memory region has been accessed for this or longer time,
+ * DAMON_HUGEPAGE identifies the region as hot, and collapse it into a huge
+ * page.  100 microseconds by default.
+ */
+static unsigned long min_age __read_mostly = 100000;
+module_param(min_age, ulong, 0600);
+
+static struct damos_quota damon_hugepage_quota = {
+	/* use up to 10 ms time, collapse up to 128 MiB per 1 sec by default */
+	.ms = 10,
+	.sz = 128 * 1024 * 1024,
+	.reset_interval = 1000,
+	.weight_sz = 0,
+	.weight_nr_accesses = 1,
+	.weight_age = 1
+};
+DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_hugepage_quota);
+
+
+/*
+ * Desired ratio of huge pages use vs total anonymous memory usage.
+ *
+ * While keeping the caps that set by other quotas, DAMON_HUGEPAGE automatically
+ * increases and decreases the effective level of the quota to achieve the
+ * desired ratio.
+ *
+ * 100 bp by default.
+ */
+static unsigned long quota_percentage_hugepage __read_mostly = 100;
+module_param(quota_percentage_hugepage, ulong, 0600);
+
+/*
+ * User-specifiable feedback for auto-tuning of the effective quota.
+ *
+ * While keeping the caps that set by other quotas, DAMON_HUGEPAGE automatically
+ * increases and decreases the effective level of the quota aiming receiving this
+ * feedback of value ``10,000`` from the user.  DAMON_HUGEPAGE assumes the feedback
+ * value and the quota are positively proportional.  Value zero means disabling
+ * this auto-tuning feature.
+ *
+ * Disabled by default.
+ *
+ */
+static unsigned long quota_autotune_feedback __read_mostly;
+module_param(quota_autotune_feedback, ulong, 0600);
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_HUGEPAGE is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+static int kdamond_pid __read_mostly = -1;
+module_param(kdamond_pid, int, 0400);
+
+static struct damos_stat damon_hugepage_stat;
+DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_hugepage_stat,
+		hugepage_tried_regions, hugepage_regions, quota_exceeds);
+
+static struct damon_attrs damon_hugepage_mon_attrs = {
+	.sample_interval = 5 * USEC_PER_MSEC,
+	.aggr_interval = 100 * USEC_PER_MSEC,
+	.ops_update_interval = 60 * USEC_PER_MSEC * MSEC_PER_SEC,
+	.min_nr_regions = 10,
+	.max_nr_regions = 1000,
+};
+DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_hugepage_mon_attrs);
+
+static struct damon_ctx *ctx;
+static struct damon_target *target;
+
+static struct damos *damon_hugepage_new_scheme(void)
+{
+	struct damos_access_pattern pattern = {
+		/* Find regions having PMD_SIZE or larger size */
+		.min_sz_region = PMD_SIZE,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = UINT_MAX,
+		.min_age_region = min_age /
+			damon_hugepage_mon_attrs.aggr_interval,
+		.max_age_region = UINT_MAX,
+	};
+
+	return damon_new_scheme(
+		&pattern,
+		/* synchrounous partial collapse as soon as found */
+		DAMOS_HUGEPAGE, 0,
+		/* under the quota. */
+		&damon_hugepage_quota,
+		&(struct damos_watermarks){}, NUMA_NO_NODE);
+}
+
+static int damon_hugepage_apply_parameters(void)
+{
+	struct damon_ctx *param_ctx;
+	struct damon_target *param_target;
+	struct damos *scheme;
+	struct damos_quota_goal *goal;
+	struct pid *spid;
+	int err;
+
+	err = damon_modules_new_vaddr_ctx_target(&param_ctx, &param_target);
+	if (err)
+		return err;
+
+	param_ctx->addr_unit = addr_unit;
+	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
+
+	spid = find_get_pid(monitored_pid);
+	if (!spid)
+		goto out;
+
+	param_target->pid = spid;
+
+	if (!damon_hugepage_mon_attrs.aggr_interval) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = damon_set_attrs(param_ctx, &damon_hugepage_mon_attrs);
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
+	scheme = damon_hugepage_new_scheme();
+	if (!scheme)
+		goto out;
+	damon_set_schemes(param_ctx, &scheme, 1);
+
+	goal = damos_new_quota_goal(DAMOS_QUOTA_HUGEPAGE, quota_percentage_hugepage);
+	if (!goal)
+		goto out;
+	damos_add_quota_goal(&scheme->quota, goal);
+
+	if (quota_autotune_feedback) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		if (!goal)
+			goto out;
+		goal->current_value = quota_autotune_feedback;
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
+	err = damon_commit_ctx(ctx, param_ctx);
+out:
+	damon_destroy_ctx(param_ctx);
+	return err;
+}
+
+static int damon_hugepage_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_hugepage_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_hugepage_damon_call_fn(void *arg)
+{
+	struct damon_ctx *c = arg;
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c)
+		damon_hugepage_stat = s->stat;
+
+	return damon_hugepage_handle_commit_inputs();
+}
+
+static struct damon_call_control call_control = {
+	.fn = damon_hugepage_damon_call_fn,
+	.repeat = true,
+};
+
+static int damon_hugepage_turn(bool on)
+{
+	int err;
+
+	if (!on) {
+		err = damon_stop(&ctx, 1);
+		if (!err)
+			kdamond_pid = -1;
+		return err;
+	}
+
+	err = damon_hugepage_apply_parameters();
+	if (err)
+		return err;
+
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+	kdamond_pid = damon_kdamond_pid(ctx);
+	if (kdamond_pid < 0)
+		return kdamond_pid;
+	return damon_call(ctx, &call_control);
+}
+
+static int damon_hugepage_addr_unit_store(const char *val,
+		const struct kernel_param *kp)
+{
+	unsigned long input_addr_unit;
+	int err = kstrtoul(val, 0, &input_addr_unit);
+
+	if (err)
+		return err;
+	if (!input_addr_unit)
+		return -EINVAL;
+
+	addr_unit = input_addr_unit;
+	return 0;
+}
+
+static const struct kernel_param_ops addr_unit_param_ops = {
+	.set = damon_hugepage_addr_unit_store,
+	.get = param_get_ulong,
+};
+
+module_param_cb(addr_unit, &addr_unit_param_ops, &addr_unit, 0600);
+MODULE_PARM_DESC(addr_unit,
+	"Scale factor for DAMON_HUGEPAGE to ops address conversion (default: 1)");
+
+static int damon_hugepage_enabled_store(const char *val,
+				const struct kernel_param *kp)
+{
+	bool is_enabled = enabled;
+	bool enable;
+	int err;
+
+	err = kstrtobool(val, &enable);
+	if (err)
+		return err;
+
+	if (is_enabled == enable)
+		return 0;
+
+	/* Called before init function.  The function will handle this. */
+	if (!damon_initialized())
+		goto set_param_out;
+
+	err = damon_hugepage_turn(enable);
+	if (err)
+		return err;
+
+set_param_out:
+	enabled = enable;
+	return err;
+}
+
+static const struct kernel_param_ops enabled_param_ops = {
+	.set = damon_hugepage_enabled_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+MODULE_PARM_DESC(enabled,
+	"Enable or disable DAMON_HUGEPAGES (default: disabled)");
+
+static int __init damon_hugepage_init(void)
+{
+	int err;
+
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = damon_modules_new_vaddr_ctx_target(&ctx, &target);
+	if (err)
+		goto out;
+
+	call_control.data = ctx;
+
+	/* 'enabled' has set before this function, probably via command line */
+	if (enabled)
+		err = damon_hugepage_turn(true);
+
+out:
+	if (err && enabled)
+		enabled = false;
+	return err;
+}
+
+module_init(damon_hugepage_init);
-- 
2.43.0


