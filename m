Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C458ECCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254BC8E0087; Mon, 13 Oct 2025 16:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2054B8E0036; Mon, 13 Oct 2025 16:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE0A8E0087; Mon, 13 Oct 2025 16:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EADDE8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC96BC060F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:36 +0000 (UTC)
X-FDA: 83994246672.14.3223F72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A33B100015
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOcgefUb;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MDhmNjrH/ApFrXrP814IcRBr/P0WKwEANNyt3qUOrh8=;
	b=yqgZEGOeN+1gAVgO0YyJ0rB/+jfn+HQR+QS/dZGhNCa0tOABeuFJ9UwZcpB9r7e3nnG9hm
	cj7ncIEAWFfPltrrCLq2YOdraurMH09kHI6nayRRIST4Oa7eAR/Rmr9UnCIZv4cufq9z58
	/bP+xxgP8p8JB1f1J59mn+TbXIEpRX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387735; a=rsa-sha256;
	cv=none;
	b=7MEZ5odF6Sk44VQSba3q8yhD6xIEBIo2n2muerOqlADXvS/3gu9Qar+ssteJcpPTFQ0o9G
	tMb7XGsp+0VccbXINXYT9U+62BJ/oCoTPmx/vXLqIXVUCcE8b5UfChPxVnQU/zHUMWfUIv
	0uoea1gx1Ltw6f5xZqBnDfS6BzowGMU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOcgefUb;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F84F44836;
	Mon, 13 Oct 2025 20:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE283C4CEE7;
	Mon, 13 Oct 2025 20:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387734;
	bh=PsMKH0OPMca3EhEEuIU354JdvA7f16B4eqaq2LuoXwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOcgefUbdM8KZZtxNCa5o0JhMH9FSXBLb7n4WPeOsF2XgdoK83GOUM6roqgwxi6fg
	 lmeI43Wlh9lqJhfgRWkv5kPv0yv8NZJhMRURGFHNTE1N+A2btbuj7S4UK4KPSD//lj
	 N94VL2GZrzRWuYxj7iP5IBsWSKOSinM80+mfqjqim1clnFbPeZF40wiaeoKIbqL6ks
	 GkQ1KbgSilayV8mjiTJNiHaQM3lR8PnlIFvRB73rfRxrAg9FKRdXQDU4Z8S2AHPsRu
	 TGDBiyljEp+s5CxXNwhR3i9ANDzt9nGvwUi4s5urUMUyWglryJ/ELSPTbcf4kHT8IX
	 +SFKeeSMNX4fw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 28/33] kthread: Honour kthreads preferred affinity after cpuset changes
Date: Mon, 13 Oct 2025 22:31:41 +0200
Message-ID: <20251013203146.10162-29-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 6pq5jpwtj8yb9rwnzumsyiz47rh5ar3x
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A33B100015
X-HE-Tag: 1760387734-103409
X-HE-Meta: U2FsdGVkX18FWv8ENPa8HE1uejJFAiElxTdbP/xB067WBqmfKK2rmcF+kGFli6FFlsr9Jox8E2UvYMMEtxB+C3oLLrBxPgT7HojyaqyIe3QHgUM/Gn4jhyE5L2sxWNzMohyyZpDwtYZbq1ayam9FN3SlbkJHXxJyx/YitALFUU1gpGgCNVJQXQRo2QB2pm3IMqpQTHap3h1vHFaxbUu4TJ6jm1G4ONGfxYxwBalFIER2SzueUYhO7WYn9jpL5IExZ2kTJVs0dVht6YprHy1sWm5TbalWHWBGro4mWU3Im80Jd+t3qKRbzgcFWjPUYsPBkbLxOASXHcWWU8PZCTPHx+gz0IX2kcBxqgDCfkEzdL0N2tfhfZmQeT1/eRljcqwvAoX8RO25k2eSWrOvmZxcURXKoRfApMNBl4bRgT/6MIgDVgmjnWALvsdokoZ3UHvlhsrscpYmBbLwjxH9WSzaaji8ECft3jBtSW1ocuqFpGs/HOCVMpgNWW6ww8zZtDEsB3A/ThOj8wIx2B0hwYEBJgWOJL4tBMuNidPLvSm5P1P8/lb8NkSbmgqITfNAHSs3mztKDAA2MVF0qBSzfA340SAG+1NLaAO7D7EHZoXxc5JUWGEUunpUqUpkgZkh2O8hw8PvDaptLTBQdFBBrltRBWkQgyeClaTHtjRFyzMctrxKL42o1gn1nmjK8/ocivxbOyIzEVHhc8urRBKHRwY9JAxA6vI3qDZ3U6QOuNeGMfws30ZoAmUEGE7XwCobw8exaQorva8RP8EHSfqdOb0T+YHB8yNZ3+RYXm8PjBOv3E+t3xhn76R51nrmxKRtW7j3FpdO7Eqgm9WJooEGU8L2kMAnklkwQ5Z1LZJx2URrLFVTqfPbzjBElPeMx4DVMuI0e5jMiBnQZWGKD/qnZvRP3fluJG+txL8x/18fbld7jKyRJQXPo/74PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cpuset isolated partitions get updated, unbound kthreads get
indifferently affine to all non isolated CPUs, regardless of their
individual affinity preferences.

For example kswapd is a per-node kthread that prefers to be affine to
the node it refers to. Whenever an isolated partition is created,
updated or deleted, kswapd's node affinity is going to be broken if any
CPU in the related node is not isolated because kswapd will be affine
globally.

Fix this with letting the consolidated kthread managed affinity code do
the affinity update on behalf of cpuset.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/kthread.h  |  1 +
 kernel/cgroup/cpuset.c   |  5 ++---
 kernel/kthread.c         | 38 +++++++++++++++++++++++++++++---------
 kernel/sched/isolation.c |  2 ++
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 8d27403888ce..c92c1149ee6e 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -100,6 +100,7 @@ void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
 void kthread_exit(long result) __noreturn;
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
+int kthreads_update_housekeeping(void);
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 817c07a7a1b4..bc3f18ead7c8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1182,11 +1182,10 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 		if (top_cs) {
 			/*
+			 * PF_KTHREAD tasks are handled by housekeeping.
 			 * PF_NO_SETAFFINITY tasks are ignored.
-			 * All per cpu kthreads should have PF_NO_SETAFFINITY
-			 * flag set, see kthread_set_per_cpu().
 			 */
-			if (task->flags & PF_NO_SETAFFINITY)
+			if (task->flags & (PF_KTHREAD | PF_NO_SETAFFINITY))
 				continue;
 			cpumask_andnot(new_cpus, possible_mask, subpartitions_cpus);
 		} else {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 8d0c8c4c7e46..4d3cc04e5e8b 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -896,14 +896,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 }
 EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
-/*
- * Re-affine kthreads according to their preferences
- * and the newly online CPU. The CPU down part is handled
- * by select_fallback_rq() which default re-affines to
- * housekeepers from other nodes in case the preferred
- * affinity doesn't apply anymore.
- */
-static int kthreads_online_cpu(unsigned int cpu)
+static int kthreads_update_affinity(bool force)
 {
 	cpumask_var_t affinity;
 	struct kthread *k;
@@ -926,7 +919,7 @@ static int kthreads_online_cpu(unsigned int cpu)
 			continue;
 		}
 
-		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
+		if (force || k->preferred_affinity || k->node != NUMA_NO_NODE) {
 			kthread_fetch_affinity(k, affinity);
 			set_cpus_allowed_ptr(k->task, affinity);
 		}
@@ -937,6 +930,33 @@ static int kthreads_online_cpu(unsigned int cpu)
 	return ret;
 }
 
+/**
+ * kthreads_update_housekeeping - Update kthreads affinity on cpuset change
+ *
+ * When cpuset changes a partition type to/from "isolated" or updates related
+ * cpumasks, propagate the housekeeping cpumask change to preferred kthreads
+ * affinity.
+ *
+ * Returns 0 if successful, -ENOMEM if temporary mask couldn't
+ * be allocated or -EINVAL in case of internal error.
+ */
+int kthreads_update_housekeeping(void)
+{
+	return kthreads_update_affinity(true);
+}
+
+/*
+ * Re-affine kthreads according to their preferences
+ * and the newly online CPU. The CPU down part is handled
+ * by select_fallback_rq() which default re-affines to
+ * housekeepers from other nodes in case the preferred
+ * affinity doesn't apply anymore.
+ */
+static int kthreads_online_cpu(unsigned int cpu)
+{
+	return kthreads_update_affinity(false);
+}
+
 static int kthreads_init(void)
 {
 	return cpuhp_setup_state(CPUHP_AP_KTHREADS_ONLINE, "kthreads:online",
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 691f045ab758..93de1304e6d4 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -150,6 +150,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
+	WARN_ON_ONCE(err < 0);
+	err = kthreads_update_housekeeping();
 
 	kfree(old);
 
-- 
2.51.0


