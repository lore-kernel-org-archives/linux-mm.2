Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0323BFD4F05
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215846B009D; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E556B00A1; Tue, 10 Mar 2026 12:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28C16B009E; Tue, 10 Mar 2026 12:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DECFA6B009B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:25:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8815F13A024
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:39 +0000 (UTC)
X-FDA: 84530679198.14.829E261
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 720F640004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:25:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773159938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yJOdLwZw0G8ZVmaT/9cUosGHSzT26Y5hGxn5uwPShbc=;
	b=nqVSgxWHLxH+zOMIR5pezmEbK4U8KVRVDggfxOUNHc8dwADlCqQf2bfo/XWzXFEiZtcdf1
	WG++8+4YgLWfjrfMFLq6RMZCBV09hIyK4OAYbv4Y8UIQe9ueX7oCbub008Dy17zh2GWOQ5
	PD1Sczfo6S2Xp5i5Q4vQDISP/jeDXf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773159938; a=rsa-sha256;
	cv=none;
	b=yEy3PxYwzA0O+7KnwwdFdfUVd7XvMiVe743U/faEqN9sOdD6hZRmiIkRhvtt6dEjn0LFP/
	AqxrGnVW7tQTpGcl0az3WsXPC3ToeKAsy1qNcS1sbpkRYEQQxx6QgqbHeRhvpINEjENUo4
	g6uVObPH7OhJqikwEPLQaRzyqDo/nEA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fVfPN1VnpzHnGjq;
	Wed, 11 Mar 2026 00:25:28 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 385B940086;
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
Subject: [RFC PATCH v2 3/4] mm/damon: New module with hot application detection
Date: Tue, 10 Mar 2026 16:24:19 +0000
Message-ID: <20260310162420.4180562-4-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
References: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 720F640004
X-Stat-Signature: zrqnz59pq5ghh9or6jjstifm5k13smhp
X-HE-Tag: 1773159937-213668
X-HE-Meta: U2FsdGVkX1/lYHsRjNLA/6bGkpx7ZL0K/7mLuvsqx+vrDEt7i0g9UYULtElkwHa7gPg1MjYwN0xlPvsQ32S4EWLnP/xwjZOstSSlCh3/hpGHQmcSN+1ZUY8q5BWGi6W5C7BMGBrUqIVNF8x2XpafDF3DGXsxa3Nni3Leq4YRDr+cL/aH9egGPibMBDzrI49h0VhhTy2LUgeAG1eBtGYslY5o9ZejXS2y9mviT//dWhYd+oeXEJeEsxPLVkjmYQPjJZm78BxFEh3oCg6TyQ+quGySa1pLCKIIfwnrWMazR/bV96TRGAJxNzF0sk6hJVoKan1MFqshJmIV2h9k32hcHY4j2bb7+kWtuAu9hkkQBM3TxqWoTqWgr+JyqLiriWKBAlZbsDEByNDtvPI47ilQhA3ixx8e5/Bk21fPBFzdsJy4J14ZiMSsYf963d3xDCfl6mWtZrvP+XUMT4Xuw4quwxjeabUfbkKuSHxtRjpW8FCWYIDeb1aO7RkhWbe5hhbuBaASBE+4MSPFFt/hbFch/ovUTzK+CH1fIz1XfmPDIVVY6SLHIYEbOCdu/0JdlbK7952KAzeE72aSlo/BdWKOI8w95rVPzapoiO9WNSGogyIg/wm56NkCTh/pRnyCzVsvDNw3L8b6wkMZjS4DNpg+AfJSiaHL1Sa/PA72f/MPaEJNbuUWscCU8DJ70pK3888DX3AypUmUy4+nEiMreplDPY1ht0wCwvxSaeyod/jX/k1+kmS+RlwPFN8nfByTJFu0l9JoW7dH1L4P8XboPszL17zGlxBHzaqvEaQELFwEbgCevQmHMeE3FSKZBXokRRnxizlo3zcoCceMV3aLMqfJrIJFyOXLcqMXqMCrI2IS+xzsiEwrtUih5inDv5iXVDKgx5zFzJNSO9nzrQakv28c+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

1. It first launches a new kthread called damon_dynamic. This thread
will behave as a supervisor, launching new kdamond threads for all
the processes we want to montiored. The tasks are sorted
by utime delta. For the top N tasks, a new kdamond thread will be
launched. Applications which turn cold will have their kdamond
stopped.

The processes are supplied by the monitored_pids parameter. When the
module is enabled, it will go through all the monitored_pids, start
the supervisor and a new kdamond thread for each of the tasks. This
tasks can be modified and applied using the commit_input parameters.
In that case, we will stop any kdamond thread for tasks that are not
going to be monitored anymore, and start a new kdamond thread for each
new task to be monitored. For tasks that were monitored before and are
still monitored after commiting a new monitored_pids list, kdamond
threads are left intact.

2. Initially we don't know the min_access for each of the task. We
want to find the highest min_access when collapses start happening.
For that we have an initial threashold of 90, which we will lower
until a collpase occurs.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
---
 mm/damon/Kconfig          |   7 +
 mm/damon/Makefile         |   1 +
 mm/damon/hugepage.c (new) | 441 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 449 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fc..2355aacb6d12 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -110,4 +110,11 @@ config DAMON_STAT_ENABLED_DEFAULT
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
 	  boot or runtime using its 'enabled' parameter.
 
+config DAMON_HOT_HUGEPAGE
+	bool "Build DAMON-based collapse of hot regions (DAMON_HOT_HUGEPAGES)"
+	depends on DAMON_VADDR
+	help
+	 Collapse hot region into huge pages. Hot regions are determined by
+	 DAMON-based sampling
+
 endmenu
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index d8d6bf5f8bff..ac3afbc81cc7 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
 obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
 obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
 obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
+obj-$(CONFIG_DAMON_HOT_HUGEPAGE)	+= modules-common.o hugepage.o
diff --git a/mm/damon/hugepage.c b/mm/damon/hugepage.c
new file mode 100644
index 000000000000..ccd31c48d391
--- /dev/null
+++ b/mm/damon/hugepage.c
@@ -0,0 +1,441 @@
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
+#define MAX_MONITORED_PIDS 100
+#define HIGHEST_MIN_ACCESS 90
+#define HIGH_ACC_THRESHOLD 50
+#define MID_ACC_THRESHOLD 15
+#define LOW_ACC_THRESHOLD 2
+
+static struct task_struct *monitor_thread;
+
+struct mutex enable_disable_lock;
+
+/*
+ * Enable or disable DAMON_HUGEPAGE.
+ *
+ * You can enable DAMON_HUGEPAGE by setting the value of this parameter
+ * as ``Y``. Setting it as ``N`` disables DAMON_HOT_HUGEPAGE.  Note that
+ * DAMON_HOT_HUGEPAGE could do no real monitoring and reclamation due to the
+ * watermarks-based activation condition.  Refer to below descriptions for the
+ * watermarks parameter for this.
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
+ * DAMON_HUGEPAGE monitoring period in microseconds.
+ * 5000000 = 5s
+ */
+static unsigned long monitor_period __read_mostly = 5000000;
+module_param(monitor_period, ulong, 0600);
+
+static long monitored_pids[MAX_MONITORED_PIDS];
+static int num_monitored_pids;
+module_param_array(monitored_pids, long, &num_monitored_pids, 0600);
+
+static struct damos_quota damon_hugepage_quota = {
+	/* use up to 10 ms time, reclaim up to 128 MiB per 1 sec by default */
+	.ms = 10,
+	.sz = 0,
+	.reset_interval = 1000,
+	/* Within the quota, page out older regions first. */
+	.weight_sz = 0,
+	.weight_nr_accesses = 0,
+	.weight_age = 1
+};
+DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_hugepage_quota);
+
+static struct damos_watermarks damon_hugepage_wmarks = {
+	.metric = DAMOS_WMARK_FREE_MEM_RATE,
+	.interval = 5000000, /* 5 seconds */
+	.high = 900, /* 90 percent */
+	.mid = 800, /* 80 percent */
+	.low = 50, /* 5 percent */
+};
+DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_hugepage_wmarks);
+
+static struct damon_attrs damon_hugepage_mon_attrs = {
+	.sample_interval = 5000, /* 5 ms */
+	.aggr_interval = 100000, /* 100 ms */
+	.ops_update_interval = 0,
+	.min_nr_regions = 10,
+	.max_nr_regions = 1000,
+};
+DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_hugepage_mon_attrs);
+
+struct hugepage_task {
+	struct damon_ctx *ctx;
+	int pid;
+	struct damon_target *target;
+	struct damon_call_control call_control;
+	struct list_head list;
+};
+
+static struct damos *damon_hugepage_new_scheme(int min_access,
+						   enum damos_action action)
+{
+	struct damos_access_pattern pattern = {
+		/* Find regions having PAGE_SIZE or larger size */
+		.min_sz_region = PMD_SIZE,
+		.max_sz_region = ULONG_MAX,
+		/* and not accessed at all */
+		.min_nr_accesses = min_access,
+		.max_nr_accesses = 100,
+		/* for min_age or more micro-seconds */
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
+
+	return damon_new_scheme(
+		&pattern,
+		/* synchrounous partial collapse as soon as found */
+		action, 0,
+		/* under the quota. */
+		&damon_hugepage_quota,
+		/* (De)activate this according to the watermarks. */
+		&damon_hugepage_wmarks, NUMA_NO_NODE);
+}
+
+static int damon_hugepage_apply_parameters(
+				struct hugepage_task *monitored_task,
+				int min_access,
+				enum damos_action action)
+{
+	struct damos *scheme;
+	struct damon_ctx *param_ctx;
+	struct damon_target *param_target;
+	struct damos_filter *filter;
+	int err;
+	struct pid *spid;
+
+	err = damon_modules_new_ctx_target(&param_ctx, &param_target,
+					   DAMON_OPS_VADDR);
+	if (err)
+		return err;
+
+	spid = find_get_pid(monitored_task->pid);
+	if (!spid)
+		return err;
+
+	param_target->pid = spid;
+
+	err = damon_set_attrs(param_ctx, &damon_hugepage_mon_attrs);
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
+	scheme = damon_hugepage_new_scheme(min_access, action);
+	if (!scheme)
+		goto out;
+
+	damon_set_schemes(param_ctx, &scheme, 1);
+
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true, false);
+	if (!filter)
+		goto out;
+	damos_add_filter(scheme, filter);
+
+	err = damon_commit_ctx(monitored_task->ctx, param_ctx);
+out:
+	damon_destroy_ctx(param_ctx);
+	return err;
+}
+
+static int damon_hugepage_damon_call_fn(void *arg)
+{
+	struct hugepage_task *monitored_task = arg;
+	struct damon_ctx *ctx = monitored_task->ctx;
+	struct damos *scheme;
+	int err = 0;
+	int min_access;
+	struct damos_stat stat;
+
+	damon_for_each_scheme(scheme, ctx)
+		stat = scheme->stat;
+	scheme = list_first_entry(&ctx->schemes, struct damos, list);
+
+	if (ctx->passed_sample_intervals < scheme->next_apply_sis)
+		return err;
+
+	if (stat.nr_applied)
+		return err;
+
+	min_access = scheme->pattern.min_nr_accesses;
+
+	if (min_access > HIGH_ACC_THRESHOLD) {
+		min_access = min_access - 10;
+		err = damon_hugepage_apply_parameters(
+			monitored_task, min_access, DAMOS_COLLAPSE);
+	} else if (min_access > MID_ACC_THRESHOLD) {
+		min_access = min_access - 5;
+		err = damon_hugepage_apply_parameters(
+			monitored_task, min_access, DAMOS_COLLAPSE);
+	} else if (min_access > LOW_ACC_THRESHOLD) {
+		min_access = min_access - 1;
+		err = damon_hugepage_apply_parameters(
+			monitored_task, min_access, DAMOS_COLLAPSE);
+	}
+	return err;
+}
+
+static int damon_hugepage_init_task(struct hugepage_task *monitored_task)
+{
+	int err = 0;
+	struct damon_ctx *ctx = monitored_task->ctx;
+	struct damon_target *target = monitored_task->target;
+	struct pid *spid;
+
+	if (!ctx || !target)
+		damon_modules_new_ctx_target(&ctx, &target, DAMON_OPS_VADDR);
+
+	if (damon_is_running(ctx))
+		return 0;
+
+	spid = find_get_pid(monitored_task->pid);
+	if (!spid)
+		return err;
+
+	target->pid = spid;
+
+	monitored_task->call_control.fn = damon_hugepage_damon_call_fn;
+	monitored_task->call_control.repeat = true;
+	monitored_task->call_control.data = monitored_task;
+
+	struct damos *scheme = damon_hugepage_new_scheme(
+			HIGHEST_MIN_ACCESS, DAMOS_COLLAPSE);
+	if (!scheme)
+		return -ENOMEM;
+
+	damon_set_schemes(ctx, &scheme, 1);
+
+	monitored_task->ctx = ctx;
+	err = damon_start(&monitored_task->ctx, 1, false);
+	if (err)
+		return err;
+
+	return damon_call(monitored_task->ctx, &monitored_task->call_control);
+}
+
+static int add_monitored_task(int pid, struct list_head *task_monitor)
+{
+	struct hugepage_task *new_hugepage_task;
+	int err;
+
+	new_hugepage_task = kzalloc_obj(*new_hugepage_task);
+	if (!new_hugepage_task)
+		return -ENOMEM;
+
+	new_hugepage_task->pid = pid;
+	INIT_LIST_HEAD(&new_hugepage_task->list);
+	err = damon_hugepage_init_task(new_hugepage_task);
+	if (err)
+		return err;
+	list_add(&new_hugepage_task->list, task_monitor);
+	return 0;
+}
+
+static int damon_hugepage_handle_commit_inputs(
+		struct list_head *monitored_tasks)
+{
+	int i = 0;
+	int err = 0;
+	bool found;
+	struct hugepage_task *monitored_task, *tmp;
+
+	if (!commit_inputs)
+		return 0;
+
+	while (i < MAX_MONITORED_PIDS) {
+		if (!monitored_pids[i])
+			break;
+
+		found = false;
+
+		rcu_read_lock();
+		if (!find_vpid(monitored_pids[i])) {
+			rcu_read_unlock();
+			continue;
+		}
+
+		rcu_read_unlock();
+
+		list_for_each_entry_safe(monitored_task, tmp, monitored_tasks, list) {
+			if (monitored_task->pid == monitored_pids[i]) {
+				list_move(&monitored_task->list, monitored_tasks);
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			err = add_monitored_task(monitored_pids[i], monitored_tasks);
+			/* Skip failed tasks */
+			if (err)
+				continue;
+		}
+		i++;
+	}
+
+	i = 0;
+	list_for_each_entry_safe(monitored_task, tmp, monitored_tasks, list) {
+		i++;
+		if (i <= num_monitored_pids)
+			continue;
+
+		err = damon_stop(&monitored_task->ctx, 1);
+		damon_destroy_ctx(monitored_task->ctx);
+		list_del(&monitored_task->list);
+		kfree(monitored_task);
+	}
+
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_manager_monitor_thread(void *data)
+{
+	int err = 0;
+	int i;
+	struct hugepage_task *entry, *tmp;
+
+	LIST_HEAD(monitored_tasks);
+
+	for (i = 0; i < MAX_MONITORED_PIDS; i++) {
+		if (!monitored_pids[i])
+			break;
+
+		rcu_read_lock();
+		if (!find_vpid(monitored_pids[i])) {
+			rcu_read_unlock();
+			continue;
+		}
+		rcu_read_unlock();
+
+		add_monitored_task(monitored_pids[i], &monitored_tasks);
+	}
+
+
+	while (!kthread_should_stop()) {
+		schedule_timeout_idle(usecs_to_jiffies(monitor_period));
+		err = damon_hugepage_handle_commit_inputs(&monitored_tasks);
+		if (err)
+			break;
+	}
+
+	list_for_each_entry_safe(entry, tmp, &monitored_tasks, list) {
+		err = damon_stop(&entry->ctx, 1);
+		damon_destroy_ctx(entry->ctx);
+	}
+
+	for (int i = 0; i < MAX_MONITORED_PIDS;) {
+		monitored_pids[i] = 0;
+		i++;
+	}
+	return err;
+}
+
+static int damon_hugepage_start_monitor_thread(void)
+{
+	num_monitored_pids = 0;
+	monitor_thread = kthread_create(damon_manager_monitor_thread, NULL,
+				 "damon_dynamic");
+
+	if (IS_ERR(monitor_thread))
+		return PTR_ERR(monitor_thread);
+
+	wake_up_process(monitor_thread);
+	return 0;
+}
+
+static int damon_hugepage_turn(bool on)
+{
+	int err = 0;
+
+	mutex_lock(&enable_disable_lock);
+	if (!on) {
+		if (monitor_thread) {
+			kthread_stop(monitor_thread);
+			monitor_thread = NULL;
+		}
+		goto out;
+	}
+	err = damon_hugepage_start_monitor_thread();
+out:
+	mutex_unlock(&enable_disable_lock);
+	return err;
+}
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
+	err = damon_hugepage_turn(enable);
+	if (err)
+		return err;
+
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
+	"Enable or disable DAMON_DYNAMIC_HUGEPAGES (default: disabled)");
+
+static int __init damon_hugepage_init(void)
+{
+	int err;
+
+	/* 'enabled' has set before this function, probably via command line */
+	if (enabled)
+		err = damon_hugepage_turn(true);
+
+	if (err && enabled)
+		enabled = false;
+	return err;
+}
+
+module_init(damon_hugepage_init);
-- 
2.43.0


