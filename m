Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DDF1C5DF74
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 14:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEEE6B0356; Sun, 16 Aug 2026 10:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396BF6B0357; Sun, 16 Aug 2026 10:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC996B0358; Sun, 16 Aug 2026 10:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2BE36B0356
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:22:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778DA1C179B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:22:49 +0000 (UTC)
X-FDA: 85107348858.28.B5A6960
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A315010000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:22:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfuW5+n2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786890167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m31MQUkSQS2jVChso5vZVbxBylBeL+g3s9FxURuBxhg=;
	b=Qu5QJOcoQQ3Pzb8t4EzoEjeYX2JTHYuO8K0CpafAp2YAjTbkRyARicH4vAU3jdtaiEHwC+
	uXoIWeI6jlUV1d4g54qz4BO1MoAPpTLMfPWMSGobMgBGeMccnn3n7CHdb/tTiCoCS4JloN
	zMkSkJnMJlnLY85R2WRGF3xITEqkKts=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfuW5+n2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786890167;
	b=VJA8Iav5f0brECahehDx4jAZ+eb4VFblTUj5QlQj4PfnklUazpzl8GVA2tX4K0y/js2ljb
	D+PkNjH++AAX1+3UQmgFwBNTDEz6u68oDNh+W8Sp9MT2ur45HdZ1CKu9ku1cCI/iIlfm42
	SmJD180fYwdQQBJ7F0/wzHBdNAUqUaA=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso32797935ad.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890166; x=1787494966; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m31MQUkSQS2jVChso5vZVbxBylBeL+g3s9FxURuBxhg=;
        b=dfuW5+n2NcwTjS+qRi6dkfe/tL8iW2QPKcrdDr6Yw7xqOpCS0CI5gWGaQFhezE4pVP
         jq28kHx+V8ILN4sF1oQALucHXCQktbXqHGpA9xqaFUpp05xX7s1H7NebsE3dn0ua9ax2
         uEit/Jzg8sxvUqTk/llrFJluLz7EkrUmoSTiUCnf0bxnc8VqkqvevnRHAMqiX2vzqI2K
         4VeLGhmWx/bVCR2Q7IQFh8/ssLSAIHFHHc6v7lKHFpL0CzL9c2J+otI2lipfKduMGoTM
         HNkuOjewlHqFqybMUARcKVEoEmi0/xGtRcMz2+hDkag/IV8404r4mpwnx7ix+TxEinR/
         cTxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890166; x=1787494966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m31MQUkSQS2jVChso5vZVbxBylBeL+g3s9FxURuBxhg=;
        b=Y1OhiI69amC3LmNHVZlRElqh8Ydox9kUrnra43Yre/V9wy2fQiYqKcyxAJRVyVRrbZ
         S4ju2WrQrqAPNJjBjVpGZUu0XcICioyhdtfgiZJm2FOEO4XQoi0QvLzb0j91ggjxxpCU
         xYY8dOf9wnrh1BomILnDwH+7IY7zEAxFqSA2ufwT2IRIovOX2qhMAusBG0wP0bDuaJGk
         +0yInJIkKw1ceaqqiZa9qaVlZbwfclFnRmfQPBFrWt/q8HygIZR1q0OpPdkxhPZ12vaL
         iubjyd2GZ53jlLVTCvxstuhEiLztAK/5hjfjDlcK6tSxmzIDRr2YTJESxNHwEuoyHKZb
         0joA==
X-Forwarded-Encrypted: i=1; AHgh+RqKc8EWA2ZX5LWmtHjDNJG+g79nkP7jSqAhaN154PPx1Vrj0aFcZmwJEo9XmO1HtQ9XjWsck4DVcA==@kvack.org
X-Gm-Message-State: AOJu0Yx1529v76E1LpNRd7OG681TKUPG55M5OMSuvQdWXzduHw0pHcCF
	pCANxFdBUIn+9PN53U2vruswgUPhDDZNA2qFBxieOeqafNWy+8dqSEGW
X-Gm-Gg: AR+sD13sDRQbSBcWW400bqZziz0Kh6cGFeDt5a03JxoHMWsc+aGHka7P4P00WmteLmS
	JJEY1h7E6U5hdTXciIQSMqP1HA9GKbDoQpPfNk0kyV6i/kKEtEC0ksTs7jia8fl9N9b1vI0ge+E
	f0puGEWXbe7ku7JpxWMF4lmGafNVOcc/BisVJSfZuSBI0HCDr6V/e+mr2WjnWXosvV2Py0ze+bb
	0t6odsowZj8EHvKCEpg8wuF9ZIq8uni3z6FN8BvvfAv9mujUqWxThi4gnZZhk5voJWYavNAJolV
	wOcxoDXuASjpIZdlMBk/t2RQ1GHCT7TpOs9Ga1co2d/JGjz3s4tw6tl3Od39MxeLXl96Xy2m/oW
	PonzjCn5dVqBntMajTy7q+3wXwE1Hb2sE6OJ6MWy3rLIvT/VoU6aKKfPAjzJxLe3+86HYrkcKaR
	XzCqdzqOem2ilL90+YKDLoi7/5DGdNbU8w1LY3PsM3SMZI2vt1Ze2oiplJEU2wtgZuc6NbbUlHl
	4FTS3Q=
X-Received: by 2002:a17:902:e80b:b0:2c9:fb11:1bf4 with SMTP id d9443c01a7336-2d3b08825e1mr196775075ad.7.1786890166204;
        Sun, 16 Aug 2026 07:22:46 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebc8199sm26102365ad.74.2026.08.16.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:22:44 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: will@kernel.org,
	mark.rutland@arm.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [RFC PATCH 1/4] mm/damon/perf: introduce AUX backend interface and Kconfig
Date: Sun, 16 Aug 2026 22:22:18 +0800
Message-ID: <20260816142222.689624-2-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260816142222.689624-1-kunwu.chan@linux.dev>
References: <20260816142222.689624-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A315010000C
X-Rspamd-Server: rspam07
X-Stat-Signature: ped98qbatsnhy95o97bj4k8ser66m6dc
X-HE-Tag: 1786890167-428205
X-HE-Meta: U2FsdGVkX18zsRxkJ2qu2WphBRkNwP4TYXZYspzufvbaoSMZSLUkXK6cjuX4X9UtmxjqQxy318gqeywhKO1izvX9/vPAjuqWl3o5HlbtmXhYuEwfLwYeF3ecZsFgg7GSRIQtKs7Nlone5N9D4KTtrox2IZVWGYFR2YgwaZEigkIn+0JJls9fuCzPS6wBgbjrwlVuACk+b4OrRdmXuW1VbW6af20tBIl3s9Bs+OeJKT51e58+zxR0kV8+sedRvxQ+CmzIQ3/iSKsDHOngm+7NEcT3hDdsIbsnvsQNK4eFFwYyZpRR4+m4waVbBusHAAl+Y5fycfWAvNY4Cha0KbvZ7xKXYB9THVH3SRVNU98LnatZBHZyZIpE80d0BiAeG4FQNRRF76Pycoldv1kLip6eBjz5lw5HohSa7xElWHIRbCyTyeSvOVXJqItjaGggaY1IWdktq8lXd2hW2uS0pJPBz+c8CWEcJWuYZjwPYjyyH5TKuV97kcRzMzp/RuYS1cOOR9qHJTy4j1aGLomLoGH4zR8xYp+30BEtLU6XZbCSHHJqAR6KBWAqPHnXD9rvjzK4E1zkDW9SZ0Lc/i/rkQdiUsS4jOc3l1M99m5TE+PQAfWxkrvmL3SDjOwTiZDmlL5lSuAyQKowlH2WXuODrPQOeiDGQyzT+wfm28wyQtFxOg3vJLdV3QjnyS2CyqLttDj+M7mq6/kjobXJ1Hg3uQfzknxHLvhDcEaj5CFa0Xv5+TxYKlmba6DIuy8wF4XeLx9BBOZxbQvIkK9i76f+E+CsR5M7Cp/AGjRHD4m1zHUK8HDe43jiBCg400aRh4hKB+YsQzonVt8GDpQbJzKijLkOIIQsvXhbe3bA9KQcm8pjc3LeP6CXfF0URLTFCClaPnlUZ0ctEt9Oc0DbUN3y2LKDkNYIBNYnOLrDMZFMbDgm7V1Jr4guiKU8xIC2GU9Dao5y2wMQKGwh0ZhFucNFsdR
 aCOdZwHz
 rZMtraN+q/9qdxoKMEzLVM3AcEQvRIbTZTTcvD6tvVA5s9KemDlJQzjS3dCOdmGEJv+kZbWo66pWTbbO/YaCIyxUIHjjYP/1rdLaV2lmspfeY7NrTyYQBee4X8DA3v+f2FRxPhWVG5UGGhczcJmYA+tKU6tTmMBATeAj/wHgD3GA2kdQUTiIdsqCzvjOqmkfYXTaeMdqDHRAMLppXSGAuOgzmQ6g+FiCDdfzceMexyggMOpBfC6XXojL7m8Bv/mXYJimxPhHbNfhGwqV3ExJitcmtj/4lnh2099j8ky00j353tKUo3RO30X6Lu0/Xr2SInrcNEcS97Zy19SI7lT8KU/6Jgl7xbSoCv+rje62l3wSfH+uZ7o1HjV5ERbvUwJNUa2ZIxmv7Y21WIMze5M2phWPC3CYF42pXFLgdnGmyQImjztE1bX84cC7CmVNhohqgRn8XaPbwVUSKUzm/opsnlZDgI4fK2DORz2G93t1X618WtbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

Add the backend operations used by AUX trace-buffer PMUs, backend state
to damon_perf_event, and stubs for configurations without AUX support.

Add CONFIG_DAMON_PERF_AUX for the ARM SPE transport and a separate
CONFIG_DAMON_PERF_SPE_KUNIT_TEST option.  The current transport requires
ARM SPE to be built into the kernel; it remains independent of the
optional observability counters and tracepoints.

Co-developed-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 include/linux/damon.h       |  5 +++
 mm/damon/Kconfig            | 28 +++++++++++++++
 mm/damon/perf/aux_backend.h | 72 +++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)
 create mode 100644 mm/damon/perf/aux_backend.h

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c191c065b0e4..a27c5f6c459b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -8,6 +8,7 @@
 #ifndef _DAMON_H_
 #define _DAMON_H_
 
+#include <linux/cpumask.h>
 #include <linux/math64.h>
 #include <linux/memcontrol.h>
 #include <linux/mutex.h>
@@ -127,6 +128,7 @@ struct damon_target {
 enum damon_report_source {
 	DAMON_REPORT_SRC_PERF_OVERFLOW = 0,  /* overflow_handler (IBS, PEBS) */
 	DAMON_REPORT_SRC_PAGE_FAULT,         /* damon_report_page_fault() */
+	DAMON_REPORT_SRC_PERF_AUX,           /* AUX trace-buffer backend */
 };
 
 /**
@@ -538,6 +540,7 @@ struct damos_filter {
 struct damon_ctx;
 struct damon_target_lookup;
 struct damos;
+struct damon_perf_backend_ops;
 
 /**
  * struct damos_walk_control - Control damos_walk().
@@ -1056,6 +1059,8 @@ struct damon_perf_event_attr {
 struct damon_perf_event {
 	struct damon_perf_event_attr attr;
 	void *priv;
+	const struct damon_perf_backend_ops *ops;
+	cpumask_t aux_cpumask;
 	struct list_head list;
 	struct hlist_node hlist_node;
 	bool init_complete;
diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 9fac286df124..e9fb62ec186f 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -149,4 +149,32 @@ config DAMON_PERF_OBSERVE
 
 	  If unsure, say N.
 
+
+config DAMON_PERF_AUX
+	bool "DAMON AUX trace-buffer backend support"
+	depends on DAMON
+	depends on PERF_EVENTS
+	depends on ARM_SPE_PMU=y
+	default n
+	help
+	  Enable the functional AUX trace-buffer transport for DAMON perf
+	  events.  This provides backend selection and drain scheduling for
+	  ARM SPE, which does not deliver samples through an overflow
+	  callback.  ARM SPE must be built into the kernel.
+
+	  This transport is independent of CONFIG_DAMON_PERF_OBSERVE.
+
+	  If unsure, say N.
+
+config DAMON_PERF_SPE_KUNIT_TEST
+	bool "Test the DAMON perf SPE parser" if !KUNIT_ALL_TESTS
+	depends on DAMON_PERF_AUX && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Test the ARM SPE parser with byte-exact packet streams.  The cases
+	  cover valid records, truncation, alignment, error resynchronization
+	  and consumed-length accounting.  Results can be exposed through
+	  debugfs when CONFIG_KUNIT_DEBUGFS is enabled.
+
+	  If unsure, say N.
 endmenu
diff --git a/mm/damon/perf/aux_backend.h b/mm/damon/perf/aux_backend.h
new file mode 100644
index 000000000000..70e6ac6771bc
--- /dev/null
+++ b/mm/damon/perf/aux_backend.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _DAMON_PERF_AUX_BACKEND_H
+#define _DAMON_PERF_AUX_BACKEND_H
+
+#include <linux/bits.h>
+#include <linux/errno.h>
+#include <linux/perf_event.h>
+#include <linux/types.h>
+
+struct damon_ctx;
+struct damon_perf_event;
+
+/**
+ * struct damon_perf_backend_ops - PMU-specific AUX backend operations
+ * @name: Human-readable backend name.
+ * @flags: Bitmask of DAMON_PERF_BACKEND_* flags.
+ * @match_pmu: Return true when this backend claims @perf_event.
+ * @init: Allocate per-event, per-CPU resources.
+ * @cleanup: Release resources initialized for one CPU.
+ * @arm: Prepare the AUX producer before perf_event_enable().
+ * @disarm: Quiesce backend state after perf_event_disable().
+ * @drain: Parse pending AUX data into DAMON access reports.
+ *
+ * All callbacks run in process context.  The caller serializes resource
+ * lifetime against CPU hotplug and invokes @drain only for CPUs recorded
+ * in damon_perf_event::aux_cpumask.
+ */
+struct damon_perf_backend_ops {
+	const char *name;
+	u32 flags;
+	bool (*match_pmu)(struct perf_event *perf_event);
+	int (*init)(struct damon_perf_event *event, int cpu,
+		    struct perf_event *perf_event);
+	void (*cleanup)(struct damon_perf_event *event, int cpu);
+	int (*arm)(struct damon_perf_event *event, int cpu);
+	void (*disarm)(struct damon_perf_event *event, int cpu);
+	unsigned int (*drain)(struct damon_perf_event *event, int cpu);
+};
+
+#define DAMON_PERF_BACKEND_AUX	BIT(0)
+
+#ifdef CONFIG_DAMON_PERF_AUX
+void damon_perf_aux_drain(struct damon_ctx *ctx);
+int damon_perf_aux_register_backend(const struct damon_perf_backend_ops *ops);
+const struct damon_perf_backend_ops *
+damon_perf_aux_find_backend(struct perf_event *perf_event);
+void damon_perf_aux_select(struct damon_perf_event *event,
+			   struct perf_event *perf_event);
+#else
+static inline void damon_perf_aux_drain(struct damon_ctx *ctx)
+{
+}
+
+static inline int
+damon_perf_aux_register_backend(const struct damon_perf_backend_ops *ops)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline const struct damon_perf_backend_ops *
+damon_perf_aux_find_backend(struct perf_event *perf_event)
+{
+	return NULL;
+}
+
+static inline void damon_perf_aux_select(struct damon_perf_event *event,
+					 struct perf_event *perf_event)
+{
+}
+#endif
+
+#endif /* _DAMON_PERF_AUX_BACKEND_H */
-- 
2.43.0


