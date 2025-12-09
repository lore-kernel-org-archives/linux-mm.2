Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861D9D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 14:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B806B0008; Tue,  9 Dec 2025 09:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813066B000A; Tue,  9 Dec 2025 09:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FBE6B000C; Tue,  9 Dec 2025 09:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CAC76B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 09:51:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16C3C8604A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:13 +0000 (UTC)
X-FDA: 84200220426.19.647B929
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id D0BBE1A000E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 14:51:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765291870; a=rsa-sha256;
	cv=none;
	b=q2L811o1P8V0qRlM+m8mC9HDxmBe9DabraZezfdNkUzZancNvTb0wxeUThm9U8wpZ2+U1G
	R8EwHv6y8QlZLAZpp+VDORVsIlm9qjI/Rsn7qNaPQ5kp2/baOqledCg692p0t9Pc21G3Fv
	ayBFCmt4YrbGhEus5ynti0fDafCSCTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765291870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldcIX5ITPqiURdjtGBCFRwuOz0YrPzqSv2kxu9sNDt8=;
	b=nrAgtu5g6gj5YjEoUvJl5Zlcgqen4Q8SMy/f5QFUVz/eSdMHIkdyQCh8brN74vgcpgd21c
	7oFuXAuGllEWoyvofvIPWe0Gf7fgX7bn/YjVhLemS3lgjueVbXecf6+g+uMzqrJW4OO4or
	tg+1ZXxUtWtZFkW++L/0GIAMsfyt2fs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 78b58918d50e11f0a38c85956e01ac42-20251209
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:51273c8c-f896-4cd2-a80e-aa0d35bdaeba,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:51273c8c-f896-4cd2-a80e-aa0d35bdaeba,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:c58a4c4b8bf8d05fc2dbc36299edc6e4,BulkI
	D:2512092250585LFYWIAV,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 78b58918d50e11f0a38c85956e01ac42-20251209
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 534318924; Tue, 09 Dec 2025 22:50:57 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [RFC PATCH 1/2] mm/damon/auto-tuning: introduce DAMON-based auto-tunning module
Date: Tue,  9 Dec 2025 22:50:25 +0800
Message-ID: <20251209145026.3263754-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251209145026.3263754-1-lienze@kylinos.cn>
References: <20251209145026.3263754-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0BBE1A000E
X-Stat-Signature: em1sc6u8yadon18q8sa7rifm6xsbkw1b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765291869-576998
X-HE-Meta: U2FsdGVkX1+g0DoSafq+TgBuTXbWiUCYyJvQmXaCNB4rwoj9zJxip7oo1Jb1CBJLKVsw9Nw19H8wlJZROdVwnTitkAZUKIm2tzIkEoy4XUs393ECrR4bl+Y5JH/9MRcMqx5DNoXmiT0pibRNO1D0uqb5YCZsi3G23DAdDtV2CCguVd7Y/wZCMWN0Mm0JqfC1ELfI/C4LpnIlH0R5+UUvFiwN6liAq9SyJTpxZFhmcjZpvgayKS2ru8MHWTNggUDBLiDdCuFwspWHBrk2mGvG57jLO9cOMyehBX4IGbfKOxvAUhGI87vnVsqPi+vOUq1HWkET6xDoHyFvDCm+NlQmdqEDaeOto4Duprgyz/8ct3VoM+qvCf5O5+S9y3QNreo7S4Whavp8hSh34PxeiwgUKx2HGKo2tc9nGb/ivQbh1elvrt05z2t8/OHeWswR9v/mLLy8bCRcBpu5uvwZanW8+dQ2ea/hKibRjATU5gQ4xQbA7JlnVxbxAYcrhHA3SEVr9ND/7dR/17dzfNIIgs58ONeINfzbL7jUV1KgTUIeccA6nUclpDdD8bLfhSIdN+RWzD/PZuQCvbnH41tgmHqwNxg+EjZqH30nP2FwlSYRIVN9M6W1XS1P9tmWeBx3tsM+XtV+SUvMLehT2+9zN3z6mNZMQa5YS8qJV50CGeCzNbQYl+qtZdECxCVOJnJKt+juJxQvh0T72tP+82f/HCQ3xsJoeNufxEPQ8au1HpAyfR9TSA9cm6wGQlExIKPFil89a2IRq1j4CxVcv4HgYGgQ6uOp5KCabBqnFnx1H10H2mvADcKGUnGpOx8nDc8BX/dg13DTfueDG1Hj7wOqb/jEehP+FD9BorEw/z1XhHX6nYJgNaBhi0kRwRk7ujM9WiUnTcVe9lh/bdPP68nbp4YY4GElFushtRJyXaH+IJaYv0GIBX6i+iaG49dvA/zTPeiDdXAgtWDOjqST2bNfZvL
 s2dbptMa
 dB5b/zjTzpVdGbF3I3ALFmzIKMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, users need to manually tune multiple parameters (e.g.,
watermarks, quotas) for different workloads when using DAMON.  This
increases the barrier to entry for ordinary users.  To reduce
configuration complexity, this patch introduces a basic framework for
DAMON auto-tuning and first implements automatic management of
watermarks.

Users only need to set a priority for monitoring targets.  The module
will then automatically calculate and set appropriate watermarks based
on system free memory.  When the set of monitoring targets changes, the
module re-evaluates and adjusts the watermarks to ensure that memory
pages of lower-priority targets remain active longer, thereby delaying
potential reclamation operations.

This implementation is the first step toward "fully DAMON automatic
tuning".  The long-term goal is to enable the system to completely and
self-adaptively optimize all key parameters after the user enables
DAMON.  Based on this framework, future patches can extend this
auto-tuning mechanism to other parameters, such as quotas and sampling
intervals.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 include/linux/damon.h  |   3 +
 mm/damon/Kconfig       |  11 ++
 mm/damon/Makefile      |   1 +
 mm/damon/auto-tuning.c | 294 +++++++++++++++++++++++++++++++++++++++++
 mm/damon/auto-tuning.h |  10 ++
 mm/damon/core.c        |  17 +++
 6 files changed, 336 insertions(+)
 create mode 100644 mm/damon/auto-tuning.c
 create mode 100644 mm/damon/auto-tuning.h

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..f37f45820e33 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -108,6 +108,9 @@ struct damon_target {
 	struct list_head regions_list;
 	struct list_head list;
 	bool obsolete;
+#ifdef CONFIG_DAMON_AUTO_TUNING
+	unsigned int priority;
+#endif
 };
 
 /**
diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 8c868f7035fc..3c3517768f80 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -12,6 +12,17 @@ config DAMON
 	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
+config DAMON_AUTO_TUNING
+	bool "Build DAMON-based auto-tuning"
+	depends on DAMON_VADDR
+	default n
+	help
+	  This option enables the DAMON-based auto-tuning module, which
+	  automates memory management optimizations by dynamically adapting
+	  to observed data access patterns.
+
+	  If unsure, say N.
+
 config DAMON_KUNIT_TEST
 	bool "Test for damon" if !KUNIT_ALL_TESTS
 	depends on DAMON && KUNIT=y
diff --git a/mm/damon/Makefile b/mm/damon/Makefile
index d8d6bf5f8bff..4be5f5bb6668 100644
--- a/mm/damon/Makefile
+++ b/mm/damon/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-y				:= core.o
+obj-$(CONFIG_DAMON_AUTO_TUNING)	+= auto-tuning.o
 obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
 obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
 obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
diff --git a/mm/damon/auto-tuning.c b/mm/damon/auto-tuning.c
new file mode 100644
index 000000000000..61384e1f4717
--- /dev/null
+++ b/mm/damon/auto-tuning.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON-based auto tuning module.
+ *
+ * Author: Enze Li <lienze@kylinos.cn>
+ * Copyright (C) 2025 KylinSoft Corporation
+ */
+
+#define pr_fmt(fmt) "damon-auto-tuning: " fmt
+
+#include <linux/damon.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+#include <linux/list_sort.h>
+
+#include "auto-tuning.h"
+
+#ifdef MODULE_PARAM_PREFIX
+#undef MODULE_PARAM_PREFIX
+#endif
+#define MODULE_PARAM_PREFIX "damon_auto_tuning."
+
+static bool init_auto_tuning;
+static int auto_targets;
+static int max_nr_targets;
+static unsigned long init_metric;
+struct damon_ctx *auto_ctx;
+
+static struct damos *damon_auto_tuning_new_scheme(void)
+{
+	struct damos_access_pattern auto_pattern = {
+		.min_sz_region = PAGE_SIZE,
+		.max_sz_region = ULONG_MAX,
+		.min_nr_accesses = 0,
+		.max_nr_accesses = 0,
+		.min_age_region = 12000000 / 100000,
+		.max_age_region = UINT_MAX,
+	};
+
+	struct damos_quota auto_quota = {
+		.ms = 10,
+		.sz = 128 * 1024 * 1024,
+		.reset_interval = 1000,
+		.weight_sz = 0,
+		.weight_nr_accesses = 0,
+		.weight_age = 1
+	};
+
+	struct damos_watermarks auto_wmarks = {
+		.metric = DAMOS_WMARK_FREE_MEM_RATE,
+		.interval = 5000000,
+		.high = 500,
+		.mid = 400,
+		.low = 200,
+	};
+
+	return damon_new_scheme(&auto_pattern, DAMOS_PAGEOUT, 0, &auto_quota,
+				&auto_wmarks, NUMA_NO_NODE);
+}
+
+static bool damon_target_filter_match(struct damon_ctx *c,
+				      struct damos_filter *filter,
+				      struct damon_target *t)
+{
+	struct damon_target *ti;
+	int target_idx = 0;
+
+	damon_for_each_target(ti, c) {
+		if (ti == t)
+			break;
+		target_idx++;
+	}
+	return target_idx == filter->target_idx;
+}
+
+static int damon_nr_targets(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	int nr_targets = 0;
+
+	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t))
+			nr_targets++;
+	}
+	return nr_targets;
+}
+
+static bool damon_targets_print_info(struct damon_ctx *c)
+{
+	int i = 0;
+	struct damos *s, *next;
+
+	damon_for_each_scheme_safe(s, next, c) {
+		pr_info("scheme%d:\n", ++i);
+		pr_info("\t wmarks {%d %ld %ld %ld %ld %d}\n",
+			s->wmarks.metric, s->wmarks.interval,
+			s->wmarks.high, s->wmarks.mid, s->wmarks.low,
+			s->wmarks.activated);
+	}
+	return true;
+}
+
+static int damon_targets_priority_max(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	int priority_max = 0;
+
+	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t))
+			if (t->priority > priority_max)
+				priority_max = t->priority;
+	}
+	pr_debug("%s max=%d\n", __func__, priority_max);
+	return priority_max;
+}
+
+static int damon_targets_priority_min(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	int priority_min = INT_MAX;
+
+	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t))
+			if (t->priority < priority_min)
+				priority_min = t->priority;
+	}
+	pr_debug("%s min=%d\n", __func__, priority_min);
+	return priority_min;
+}
+
+static bool _damon_auto_tuning_wmarks(struct damon_ctx *c, struct damos *s,
+				      struct damon_target *t)
+{
+	unsigned long adjust_priority, metric;
+	int min = damon_targets_priority_min(c);
+	int max = damon_targets_priority_max(c);
+	int nr_targets = damon_nr_targets(c);
+	int decay_factor = max_nr_targets - nr_targets;
+
+	metric = global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		 totalram_pages();
+
+	/*
+	 * We are now ready to start adjusting the watermarks based on
+	 * priority.  The goal is to set each target's watermark above the
+	 * system's high watermark (to prevent it from triggering system-wide
+	 * actions) and below its initial memory capacity, as determined by
+	 * its importance.
+	 */
+	pr_debug("%s: metric=%ld\n", __func__, metric);
+	/* TODO: Here, we need to use the system's high watermark value, and
+	 * will temporarily substitute it with 100.
+	 */
+	if (nr_targets < max_nr_targets)
+		adjust_priority = adjust_priority * decay_factor / 10;
+	adjust_priority = (t->priority - min) * (metric - 100) / (max - min) + 100;
+
+	s->wmarks.high = adjust_priority;
+	s->wmarks.mid = adjust_priority;
+	s->wmarks.low = 0;
+	return true;
+}
+
+static bool damon_auto_tuning_wmarks(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damos *s, *next;
+	struct damos_filter *f;
+
+	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t)) {
+			damon_for_each_scheme_safe(s, next, c) {
+				damos_for_each_core_filter(f, s) {
+					if (damon_target_filter_match(c, f, t)) {
+						pr_debug("%s: priority=%d(idx=%d)\n",
+							 __func__, t->priority,
+							 f->target_idx);
+						_damon_auto_tuning_wmarks(c, s, t);
+					}
+				}
+			}
+		}
+	}
+	damon_targets_print_info(c);
+	return true;
+}
+
+static bool damon_targets_auto_tuning_tick(struct damon_ctx *c,
+					   bool init_wmarks)
+{
+	int nr_targets = 0;
+	unsigned long cur_jiffies = jiffies;
+	static unsigned long last_jiffies;
+
+	if (last_jiffies != 0) {
+		if (time_is_after_jiffies(last_jiffies + 5 * HZ))
+			return false;
+	}
+
+	pr_debug("%s %ld %ld\n", __func__, cur_jiffies, last_jiffies + 5 * HZ);
+	last_jiffies = cur_jiffies;
+
+	/*
+	 * Any change in the number of targets necessitates a recalibration of
+	 * the per-task watermarks.
+	 */
+	nr_targets = damon_nr_targets(auto_ctx);
+	if (auto_targets != nr_targets) {
+		damon_auto_tuning_wmarks(auto_ctx);
+		auto_targets = nr_targets;
+	}
+
+	if (max_nr_targets < auto_targets)
+		max_nr_targets = auto_targets;
+
+	return true;
+}
+
+static bool damon_targets_auto_tuning_init(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damos *s, *next, *new_scheme;
+	struct damos_filter *new_filter;
+	int i = 0;
+
+	init_auto_tuning = true;
+	auto_ctx = c;
+
+	damon_for_each_scheme_safe(s, next, c)
+		damon_destroy_scheme(s);
+
+	damon_for_each_target(t, c) {
+		new_scheme = damon_auto_tuning_new_scheme();
+		if (!new_scheme)
+			return -ENOMEM;
+
+		new_filter = damos_new_filter(DAMOS_FILTER_TYPE_TARGET, true, true);
+		if (!new_filter)
+			return -ENOMEM;
+		new_filter->target_idx = i++;
+
+		damos_add_filter(new_scheme, new_filter);
+		damon_add_scheme(c, new_scheme);
+
+		pr_info("\t add scheme %d\n", auto_targets);
+		auto_targets++;
+	}
+
+	max_nr_targets = auto_targets;
+
+	damon_targets_print_info(c);
+	damon_auto_tuning_wmarks(c);
+	damon_targets_print_info(c);
+
+	return true;
+}
+
+static bool damon_targets_priority_enabled(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c)
+		if (t->priority > 0)
+			return true;
+	return false;
+}
+
+bool kdamond_targets_auto_tuning(struct damon_ctx *c)
+{
+	if (damon_targets_priority_enabled(c)) {
+		if (!init_auto_tuning)
+			damon_targets_auto_tuning_init(c);
+		else
+			damon_targets_auto_tuning_tick(c, false);
+	}
+	return false;
+}
+
+static int __init damon_auto_tuning_init(void)
+{
+	int err;
+
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	init_metric = global_zone_page_state(NR_FREE_PAGES) * 1000 /
+		      totalram_pages();
+	pr_info("%s init_metric=%ld\n", __func__,  init_metric);
+out:
+	return err;
+}
+
+module_init(damon_auto_tuning_init);
diff --git a/mm/damon/auto-tuning.h b/mm/damon/auto-tuning.h
new file mode 100644
index 000000000000..766bff7d1101
--- /dev/null
+++ b/mm/damon/auto-tuning.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common Code for DAMON auto-tuning
+ *
+ * Author: Enze Li <lienze@kylinos.cn>
+ * Copyright (C) 2025 KylinSoft Corporation
+ */
+
+bool kdamond_targets_auto_tuning(struct damon_ctx *c);
+
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..d81a2b42488b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -20,6 +20,10 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
+#ifdef CONFIG_DAMON_AUTO_TUNING
+#include "auto-tuning.h"
+#endif
+
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
@@ -476,6 +480,9 @@ struct damon_target *damon_new_target(void)
 	INIT_LIST_HEAD(&t->list);
 	t->obsolete = false;
 
+#ifdef CONFIG_DAMON_AUTO_TUNING
+	t->priority = 0;
+#endif
 	return t;
 }
 
@@ -2603,6 +2610,11 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 
 		kdamond_usleep(min_wait_time);
 
+		/* TODO: Adapt to the damond_call mechanism. */
+#ifdef CONFIG_DAMON_AUTO_TUNING
+		kdamond_targets_auto_tuning(ctx);
+#endif
+
 		kdamond_call(ctx, false);
 		damos_walk_cancel(ctx);
 	}
@@ -2667,6 +2679,11 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 
+		/* TODO: Adapt to the damond_call mechanism. */
+#ifdef CONFIG_DAMON_AUTO_TUNING
+		kdamond_targets_auto_tuning(ctx);
+#endif
+
 		if (kdamond_wait_activation(ctx))
 			break;
 

base-commit: cb015814f8b6eebcbb8e46e111d108892c5e6821
-- 
2.43.0


