Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79994F43848
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33AB66B0092; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3164A6B0095; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1645D6B0093; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85366B008C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B47AAB9C00
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:33 +0000 (UTC)
X-FDA: 84661371186.06.2190D2D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id B73B81C000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf20.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zyv3ymqc5YZkH4cazJw1RDFwVaHLsF5idlSy/bPzDNc=;
	b=3IMrueDWl8HdLNYOUmNSdbimoOesbtYpPIb9hqL5n3VFG/w6LWkgIB2Suc48znErSyjU94
	gBWnYihMIXAYrVkkKjSpqWtUwPuUO2Lf21kbbgVl+5A1jHiG0dpG9eZ/Ul/WrFK89JmTUz
	mBFvenyDQzT37dwlmHwRcoxPxNzz1yM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271652; a=rsa-sha256;
	cv=none;
	b=ATGincBEtNqNFHbuJBjKnNlca5UjycuclGTwut5Pwq8XqM9JIhUEIX83etr1T0syAVaKBp
	bIWO8VApQWmJNWnKIL9vw1qwGV9KtU8nEP7Q2kfo/MeKVEYAFdi+T9RuGUhG9P4plG4sOA
	q/OmBcKawSniQtbMnTccnuHe/47MVbM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf20.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9L3YfJzJ46Dq;
	Thu, 16 Apr 2026 00:46:46 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id DC7F440569;
	Thu, 16 Apr 2026 00:47:29 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:29 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 4/7] hq-spinlock: add hq-spinlock tunables and debug statistics
Date: Thu, 16 Apr 2026 00:44:56 +0800
Message-ID: <20260415164459.2904963-5-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: gnrip3otg7xdcz5a34g3ugr4pfdcj1y9
X-Rspam-User: 
X-Rspamd-Queue-Id: B73B81C000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776271651-632602
X-HE-Meta: U2FsdGVkX1+3pIM3am+lXB7qejo0VsxSRDOUOs+HS1uCkVPFZK8TqbYD/naD7VJx2m1GCtwm7dA/cLPFB+q5CWQCMYAp9K5e/PItL5CR4oPWw/B9B8UYb7q2MXcoPQbm3e/WOgMHMStulRyir1leUM4VbFveOVEMJX8+LMCi1HivGV9N3ngcICgFBvX0RqSKiwdnb8mJD8pD5KAKw4SaFth9rLB25VNC3AxOtI8Lz2RanV4LZUvbFfHVSE+XIPUWT9bFF0Z4ADtoIzf5qHGokcJ5fFbFvXPWw+CWtQNOeBrPM+tamU0yQIjHfBR6Hk/vEfIYvLt9TztAfzE3m2UlRmR7Ej31w505SRNCoUpjTvfr6w4giSl2lVGNz51ziSRfjSRtSy8J15zy/imhEi0OoBFbxkO50El1S1B8XTFc0e3MAcJ7NbGWauyicLXFnPHRUZtJfQHHG+j7awtJ7EJnmmiJpxZRIRVZHzjeYhFOqMVNSubJ5rNHlkpjbpeSrBAkcjCGsTCe6lpzhda0mwsOMmlBhS5rxhXl8wE3pLtrtScl38wKUMgg5ZhmjMb8IrPFCS1yGEt3y1SE8V/p7fo6DpqNnFI6Anj3yABqq42bx103N1KgNdZ8rKAFx/pTZZO05o7jy9KAsNuRp2dE95Dc+1fRBEEXsSX4L6LVmUnvIInGEd/EKJ2T/MyoipznLUifjFRNNd0/x2a3lwYJNp3JbWuV1mNi2pz62EcZ3TU9mK6WINdTRBgcKh8hAjxaxMeOUUd1sdE9gBOHEopcAy/L5ucvfBvNoZGykEpvGeO7b6UuJSfjNtdTGRzZxbtKGiwwuYSq43zqgULbSke+MQO1R889G8YZlzVxdiZOnNpa3VUCUZtKfUU6gdLDEnb81osvebHCJ/N8HaRrwa6S+eH/lT3/FlXzUE6veoaDzLjEcLfy0CNMrmFAxvmyeNNEvzlOM3hVmlwnpt7AckCqykS
 60vIVj41
 TNodjnuTSiStOUvvsE4F3s1k/yrw824RvJ2ru3g731m3fnGNRlCIyVSzLCr/oFzYObAjvHlPA5i1SGX6BPUSlUzwzFWB/C4Rj1VYM1vyWFc1QvMMJqLb89LfQWt8Jomy1fobJMOvAXylyIVR44R7bEpgupkDHaMZ4lFk4X+crVaPgRiPhaKmoJgcZFIKnV/wiO5vMvYlMuG+/XvAclKB1CS7taIWrPafwWIvsKaUcnoI/7pYfrOiuJU4IR77sSNcutzl2Wdf1XAcE1T+6F7Ng6Nv12lmV72qUHWKiDt/PZrIALsUCvacTqnNfq+cMXJ6lWKhe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HQ slowpath and contention-based mode switching depend on several
parameters that affect when NUMA-aware mode becomes active and how long
local handoff can continue. Expose these parameters through procfs so
that the behaviour can be inspected and tuned without rebuilding the
kernel.

Also add debug statistics that make it possible to observe HQ lock
activation, handoff behaviour, and mode switching decisions during
testing and evaluation.

These controls are intended to simplify validation and analysis of HQ
lock behaviour on different systems and workloads.

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 kernel/locking/hqlock_core.h |   5 ++
 kernel/locking/hqlock_meta.h |  16 ++++
 kernel/locking/hqlock_proc.h | 164 +++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+)
 create mode 100644 kernel/locking/hqlock_proc.h

diff --git a/kernel/locking/hqlock_core.h b/kernel/locking/hqlock_core.h
index e2ba09d758..b7681915b4 100644
--- a/kernel/locking/hqlock_core.h
+++ b/kernel/locking/hqlock_core.h
@@ -530,6 +530,11 @@ static __always_inline void low_contention_mcs_lock_handoff(struct mcs_spinlock
 	if (next != prev && likely(general_handoffs + 1 != max_u16))
 		general_handoffs++;
 
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+	if (READ_ONCE(max_general_handoffs) < general_handoffs)
+		WRITE_ONCE(max_general_handoffs, general_handoffs);
+#endif
+
 	qnext->general_handoffs = general_handoffs;
 	qnext->remote_handoffs = qnode->remote_handoffs;
 	qnext->prev_general_handoffs = qnode->prev_general_handoffs;
diff --git a/kernel/locking/hqlock_meta.h b/kernel/locking/hqlock_meta.h
index 561d5a5fd0..1c69df536b 100644
--- a/kernel/locking/hqlock_meta.h
+++ b/kernel/locking/hqlock_meta.h
@@ -124,6 +124,12 @@ static inline enum meta_status grab_lock_meta(struct qspinlock *lock, u32 lock_i
 	}
 
 	*seq = seq_counter;
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+	int current_used = atomic_inc_return_relaxed(&cur_buckets_in_use);
+
+	if (READ_ONCE(max_buckets_in_use) < current_used)
+		WRITE_ONCE(max_buckets_in_use, current_used);
+#endif
 	return META_GRABBED;
 }
 
@@ -252,6 +258,9 @@ hqlock_mode_t setup_lock_mode(struct qspinlock *lock, u16 lock_id, u32 *meta_seq
 		 */
 		if (status == META_GRABBED && mode != LOCK_MODE_HQLOCK) {
 			smp_store_release(&meta_pool[lock_id].lock_ptr, NULL);
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+			atomic_dec(&cur_buckets_in_use);
+#endif
 		}
 	} while (mode == LOCK_NO_MODE);
 
@@ -307,8 +316,15 @@ static inline void release_lock_meta(struct qspinlock *lock,
 			goto do_rollback;
 	}
 
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+	atomic_dec(&cur_buckets_in_use);
+#endif
+
 	if (qnode->remote_handoffs < hqlock_remote_handoffs_keep_numa) {
 		upd_val |= _Q_LOCK_MODE_QSPINLOCK_VAL;
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+		atomic_inc(&transitions_from_hq_to_qspinlock);
+#endif
 	}
 
 	/*
diff --git a/kernel/locking/hqlock_proc.h b/kernel/locking/hqlock_proc.h
new file mode 100644
index 0000000000..ea68635851
--- /dev/null
+++ b/kernel/locking/hqlock_proc.h
@@ -0,0 +1,164 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _GEN_HQ_SPINLOCK_SLOWPATH
+#error "Do not include this file!"
+#endif
+
+#include <linux/sysctl.h>
+
+/*
+ * Local handoffs threshold to maintain global fairness,
+ * perform remote handoff if it's reached
+ */
+unsigned long hqlock_fairness_threshold = 1000;
+
+/*
+ * Minimal amount of handoffs in LOCK_MODE_QSPINLOCK
+ * to enable NUMA-awareness
+ */
+unsigned long hqlock_general_handoffs_turn_numa = 50;
+
+/*
+ * Minimal amount of remote handoffs in LOCK_MODE_QSPINLOCK
+ * to enable NUMA-awareness.
+ *
+ * counter is increased if local handoffs >= hqlock_local_handoffs_to_increase_remotes
+ */
+unsigned long hqlock_remote_handoffs_turn_numa = 2;
+
+/*
+ * How many remote handoffs are needed
+ * to keep NUMA-awareness on
+ */
+unsigned long hqlock_remote_handoffs_keep_numa = 1;
+
+/*
+ * How many local handoffs are needed
+ * to increase remote handoffs counter.
+ *
+ * That is needed to avoid using LOCK_MODE_HQLOCK mode
+ * with 1-2 threads from several NUMA nodes,
+ * in this case HQlock will give more overhead then benefit
+ */
+unsigned long hqlock_local_handoffs_to_increase_remotes = 2;
+
+unsigned long hqlock_probability_of_force_stay_numa = 5000;
+
+static unsigned long long_zero;
+static unsigned long long_max = LONG_MAX;
+static unsigned long long_hundred_percent = 10000;
+
+static const struct ctl_table hqlock_settings[] = {
+	{
+		.procname		= "hqlock_fairness_threshold",
+		.data			= &hqlock_fairness_threshold,
+		.maxlen			= sizeof(hqlock_fairness_threshold),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax
+	},
+	{
+		.procname		= "hqlock_general_handoffs_turn_numa",
+		.data			= &hqlock_general_handoffs_turn_numa,
+		.maxlen			= sizeof(hqlock_general_handoffs_turn_numa),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &long_zero,
+		.extra2		= &long_max,
+	},
+	{
+		.procname		= "hqlock_probability_of_force_stay_numa",
+		.data			= &hqlock_probability_of_force_stay_numa,
+		.maxlen			= sizeof(hqlock_probability_of_force_stay_numa),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &long_zero,
+		.extra2		= &long_hundred_percent,
+	},
+	{
+		.procname		= "hqlock_remote_handoffs_turn_numa",
+		.data			= &hqlock_remote_handoffs_turn_numa,
+		.maxlen			= sizeof(hqlock_remote_handoffs_turn_numa),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &long_zero,
+		.extra2		= &long_max,
+	},
+	{
+		.procname		= "hqlock_remote_handoffs_keep_numa",
+		.data			= &hqlock_remote_handoffs_keep_numa,
+		.maxlen			= sizeof(hqlock_remote_handoffs_keep_numa),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &long_zero,
+		.extra2		= &long_max,
+	},
+	{
+		.procname		= "hqlock_local_handoffs_to_increase_remotes",
+		.data			= &hqlock_local_handoffs_to_increase_remotes,
+		.maxlen			= sizeof(hqlock_local_handoffs_to_increase_remotes),
+		.mode			= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &long_zero,
+		.extra2		= &long_max,
+	},
+};
+static int __init init_numa_spinlock_sysctl(void)
+{
+	if (!register_sysctl("kernel", hqlock_settings))
+		return -EINVAL;
+	return 0;
+}
+core_initcall(init_numa_spinlock_sysctl);
+
+
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+static int max_buckets_in_use;
+static int max_general_handoffs;
+static atomic_t cur_buckets_in_use = ATOMIC_INIT(0);
+
+static atomic_t transitions_from_qspinlock_to_hq = ATOMIC_INIT(0);
+static atomic_t transitions_from_hq_to_qspinlock = ATOMIC_INIT(0);
+
+
+static int print_hqlock_stats(struct seq_file *file, void *v)
+{
+	seq_printf(file, "Max dynamic metada in use after previous print: %d\n",
+		   READ_ONCE(max_buckets_in_use));
+	WRITE_ONCE(max_buckets_in_use, 0);
+
+	seq_printf(file, "Currently in use: %d\n",
+		   atomic_read(&cur_buckets_in_use));
+
+	seq_printf(file, "Max MCS handoffs after previous print: %d\n",
+		   READ_ONCE(max_general_handoffs));
+	WRITE_ONCE(max_general_handoffs, 0);
+
+	seq_printf(file, "Transitions from qspinlock to HQ mode after previous print: %d\n",
+		   atomic_xchg_relaxed(&transitions_from_qspinlock_to_hq, 0));
+
+	seq_printf(file, "Transitions from HQ to qspinlock mode after previous print: %d\n",
+		   atomic_xchg_relaxed(&transitions_from_hq_to_qspinlock, 0));
+
+	return 0;
+}
+
+
+static int stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, print_hqlock_stats, NULL);
+}
+
+static const struct proc_ops stats_ops = {
+	.proc_open  = stats_open,
+	.proc_read  = seq_read,
+	.proc_lseek = seq_lseek,
+};
+
+static int __init stats_init(void)
+{
+	proc_create("hqlock_stats", 0444, NULL, &stats_ops);
+	return 0;
+}
+
+core_initcall(stats_init);
+
+#endif // HQSPINLOCKS_DEBUG
-- 
2.34.1


