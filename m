Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAAEFEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87FC6B0098; Fri, 27 Feb 2026 10:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69896B0099; Fri, 27 Feb 2026 10:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56CD6B009B; Fri, 27 Feb 2026 10:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2D986B0098
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:37:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 642ED1C1AA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:37:40 +0000 (UTC)
X-FDA: 84490641480.29.4F05382
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02BC9180002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:37:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=MXUCIiyP;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772206658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmfVmQUIgVOP4YZbv5nxdlKmacwPVz64vyWmdSTcFZY=;
	b=fmm3/hsfub4Ldwhw2cwYPGwrEuXYI+DIKgZdBkQa9FIhr3fkr6gWzmnUqxqlSIpMbnCU2S
	gJjWW8zeh0/aogjV17dghkIO5ceegdYEPx4BxT1mGl0nQrq0Sgbt8wbqrpywjVZwlmuDKB
	AdB61ru2OE+R1X/VzYV6RDxEi3Ve2CY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=MXUCIiyP;
	spf=pass (imf24.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772206658; a=rsa-sha256;
	cv=none;
	b=BXC4StNVyKCtuy/+CH/Ur0916Ea0ONlt0UP9rGhGjHv267SqLwx5mHlwDUP+PW0fj7VZKL
	KCJtLwvvvseVRFiJR1OoVNykC5uvpVQZilvZiLKfq3mAEw/Ekhq2e4rT8jmw9jAkAby+cU
	oSPqOmA7Mwv/sdgK5XlgO3aa2Mgd1Nk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1772206657;
	bh=SmfVmQUIgVOP4YZbv5nxdlKmacwPVz64vyWmdSTcFZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXUCIiyPoWisT908Yyp3Nw8aCgi9MMqhdMdKFEoP4x564VqjIrDj/InWJ42Y1SSSh
	 4lg5sJhFOWzh1xsxywKjoqh/XRPaJ7ZBoYxVfuQm2ye7dvl0bYANs9N0sa+gRP03Vm
	 AZTobx9qkx5uBLLii45WOOJ5PhbFt9kc8nv7045wguVAI+9uQXgfqvDgbfT8qPV4V8
	 wrT8tlr283xxsJ7rEzpYdbbSQfzS8j0HbvuqlGrQNWicyHZBgraSK6UsPw1kftaJsD
	 WBZJQLu0e24qLe9qr3GLZz3G1fyynRjOX42zlSfkqTEXSdZw+I9+nZn1akpiHNvfOA
	 XI9yJpslZCEXg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fMssF1ZH6zKM2;
	Fri, 27 Feb 2026 10:37:37 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v18 3/3] mm: Improve RSS counter approximation accuracy for proc interfaces
Date: Fri, 27 Feb 2026 10:37:30 -0500
Message-Id: <20260227153730.1556542-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260227153730.1556542-1-mathieu.desnoyers@efficios.com>
References: <20260227153730.1556542-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 02BC9180002
X-Stat-Signature: jmjxfgpwh3cyonhj1cfc759qm7q45cid
X-Rspam-User: 
X-HE-Tag: 1772206657-115636
X-HE-Meta: U2FsdGVkX1/riAsAbtslgYwqcOYeow8IMg37D4bh2b6vKGwfU7g4S5CsNpV69QIudbecFMTx5niqxV6o8uc9iTjlKVzKaEX6eJJZaugfq/mhqFWhpK0YBUsKf7J1kKNxr8gwzjdjoNaV/Dm/Syxgj40klVJNU2qHGKDLQJtO+DT0BVaexF8+91dMwzKPj+1xujeyeeFCt0k4b7/FZu2pJiWploCTq5TbAnFB+X0GblQ1oX6Fw5XfUah3aRXq4ISR5WwWPmoqV8BBWDisWe2wBxQxGE1dik7Bqv1QOeB8+4P1X3MAhObfqv9CG227+JiJgkWlj+Q85NcfYjQItQ+6f2rKHHJiKSdyJD0xhW09QYD/lFoSAcUjkyNK/jnPf6+hhmO92tHMkk+HKq2KhBvs413L2urPPZTMad0qC9VF6ym+/L14e9KhEZTpP/E2ePIPJ+soQ54ivibb5ingrJWf3T0cRqNSE1GL3WhHaJZwsV/EkUaA01f1qvWszVJDd8m23tgNC7eLIcoOXOCtIuixyWljOQomF8f+TwapD6Z2FTd8XuxZbO9PzR0nirOIueAt9hxQH+C9aqkChOg8evc894eSrfK/hjqSELSlaLsUOkrCPmfbsfH3OQZfiv87xhkzAKtfbebFlNlv3FU38V1thuD4FHNAwv4YhFZF+AmdZHjpgU3km9cdPUkqdz9u/+JCo4XpF+fn7qQ96/8fLIuMGxLjCvT+aErl8DrJv0EVYR87/shkQGWpEra2k7+ul6oJBLEnvS/JU4bC2y6+lj6M+lhc49EKlIuC5yltgrsfB82nMqemdidd98S39JUkrZ4jsCT+4wJAg1QiVbLZMCrpbBL5yO2mf4dcVtAQTapfKkF0HAwSp7oICnKoiCv06aqQ29RpDJZZuEbRtn1hyujK6kQ+AmSoGcRGrP5366HVUyyrg/2PxSGa8vPZMoKumaqceVJ7aCzgFJaM0oFBQWO
 N0V42y8T
 anRqo6Fmun0dxw9jgM0cQ8XznfpFCPtfal+NBsVnsQLv13IITY6IKotXIWODT8Zd/dvJvXpvDAfKaQAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use hierarchical per-cpu counters for RSS tracking to improve the
accuracy of per-mm RSS sum approximation on large many-core systems [1].
This improves the accuracy of the RSS values returned by proc
interfaces.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

4) Use a percise per-cpu counter sum for each counter value query:
   Requires iteration on each possible CPUs for each sum, which
   adds overhead on large many-core systems running many processes.

The approach proposed here is to replace the per-cpu counters by the
hierarchical per-cpu counters, which bounds the inaccuracy based on the
system topology with O(N*logN).

* Testing results:

Test hardware: 2 sockets AMD EPYC 9654 96-Core Processor (384 logical CPUs total)

Methodology:

Comparing the current upstream implementation with the hierarchical
counters is done by keeping both implementations wired up in parallel,
and running a single-process, single-threaded program which hops
randomly across CPUs in the system, calling mmap(2) and munmap(2) on
random CPUs, keeping track of an array of allocated mappings, randomly
choosing entries to either map or unmap.

get_mm_counter() is instrumented to compare the upstream counter
approximation to the precise value, and print the delta when going over
a given threshold. The delta of the hierarchical counter approximation
to the precise value is also printed for comparison.

After a few minutes running this test, the upstream implementation
counter approximation reaches a 1GB delta from the
precise value, compared to 80MB delta with the hierarchical counter.
The hierarchical counter provides a guaranteed maximum approximation
inaccuracy of 192MB on that hardware topology.

* Fast path implementation comparison

The new inline percpu_counter_tree_add() uses a this_cpu_add_return()
for the fast path (under a certain allocation size threshold).  Above
that, it calls a slow path which "trickles up" the carry to upper level
counters with atomic_add_return.

In comparison, the upstream counters implementation calls
percpu_counter_add_batch which uses this_cpu_try_cmpxchg() on the fast
path, and does a raw_spin_lock_irqsave above a certain threshold.

The hierarchical implementation is therefore expected to have less
contention on mid-sized allocations than the upstream counters because
the atomic counters tracking those bits are only shared across nearby
CPUs. In comparison, the upstream counters immediately use a global
spinlock when reaching the threshold.

* Benchmarks

Using will-it-scale page_fault1 benchmarks to compare the upstream
counters to the hierarchical counters. This is done with hyperthreading
disabled. The speedup is within the standard deviation of the upstream
runs, so the overhead is not significant.

                                          upstream   hierarchical    speedup
page_fault1_processes -s 100 -t 1           614783         615558      +0.1%
page_fault1_threads -s 100 -t 1             612788         612447      -0.1%
page_fault1_processes -s 100 -t 96        37994977       37932035      -0.2%
page_fault1_threads -s 100 -t 96           2484130        2504860      +0.8%
page_fault1_processes -s 100 -t 192       71262917       71118830      -0.2%
page_fault1_threads -s 100 -t 192          2446437        2469296      +0.1%

* Memory Use

The most important parts in terms of memory use are the per-cpu counters
and the tree items which propagate the carry.

In the proposed implementation, the per-cpu counters are allocated
within per-cpu data structures, so they end up using:

  nr_possible_cpus * sizeof(unsigned long)

This is in addition to the tree items. The size of those items is
defined by the per_nr_cpu_order_config table "nr_items" field.
Each item is aligned on cacheline size (typically 64 bytes) to minimize
false sharing.

Here is the footprint for a few nr_cpu_ids on a 64-bit arch:

nr_cpu_ids   percpu counters (bytes)     nr_items       items size (bytes)     total (bytes)
    2               16                     1                 64                    80
    4               32                     3                192                   224
    8               64                     7                448                   512
   64               512                   21               1344                  1856
  128              1024                   21               1344                  2368
  256              2048                   37               2368                  4416
  512              4096                   73               4672                  8768

Compared to this, the upstream percpu counters use a 32-bit integer per-cpu
(4 bytes), and accumulate within a 64-bit global value.

So there is an extra memory footprint added by the current hpcc
implementation, but if it's an issue we have various options to consider
to reduce its footprint.

Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
Changes since v17:
- MM_STRUCT_FLEXIBLE_ARRAY_INIT needs to multiply PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE
  by NR_MM_COUNTERS. Fix an out-of-bound on bootup on configurations
  where nr_cpu_ids is close to NR_CPUS.

Changes since v16:
- Remove references to 2-pass OOM killer algorithm.

Changes since v15:
- Update the commit message to explain that this change is an
  improvement to the accuracy of proc interfaces approximated RSS
  values, and a preparation step for reducing OOM killer latency.
- Rebase on v2 of "mm: Fix OOM killer and proc stats inaccuracy on
  large many-core systems".

Changes since v14:
- This change becomes the preparation for reducing the OOM killer latency.

Changes since v13:
- Change check_mm print format from %d to %ld.

Changes since v10:
- Rebase on top of mm_struct static init fixes.
- Change the alignment of mm_struct flexible array to the alignment of
  the rss counters items (which are cacheline aligned on SMP).
- Move the rss counters items to first position within the flexible
  array at the end of the mm_struct to place content in decreasing
  alignment requirement order.

Changes since v8:
- Use percpu_counter_tree_init_many and
  percpu_counter_tree_destroy_many APIs.
- Remove percpu tree items allocation. Extend mm_struct size to include
  rss items. Those are handled through the new helpers
  get_rss_stat_items() and get_rss_stat_items_size() and passed
  as parameter to percpu_counter_tree_init_many().

Changes since v7:
- Use precise sum positive API to handle a scenario where an unlucky
  precise sum iteration would observe negative counter values due to
  concurrent updates.

Changes since v6:
- Rebased on v6.18-rc3.
- Implement get_mm_counter_sum as percpu_counter_tree_precise_sum for
  /proc virtual files memory state queries.

Changes since v5:
- Use percpu_counter_tree_approximate_sum_positive.

Change since v4:
- get_mm_counter needs to return 0 or a positive value.
---
 include/linux/mm.h          | 19 ++++++++++----
 include/linux/mm_types.h    | 50 +++++++++++++++++++++++++++----------
 include/trace/events/kmem.h |  2 +-
 kernel/fork.c               | 22 +++++++++-------
 4 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..94f54a40b480 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3057,38 +3057,47 @@ static inline bool get_user_page_fast_only(unsigned long addr,
 {
 	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
 }
+
+static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct mm_struct *mm)
+{
+	unsigned long ptr = (unsigned long)mm;
+
+	ptr += offsetof(struct mm_struct, flexible_array);
+	return (struct percpu_counter_tree_level_item *)ptr;
+}
+
 /*
  * per-process(per-mm_struct) statistics.
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
 }
 
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_sum_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	percpu_counter_add(&mm->rss_stat[member], value);
+	percpu_counter_tree_add(&mm->rss_stat[member], value);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void inc_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_inc(&mm->rss_stat[member]);
+	percpu_counter_tree_add(&mm->rss_stat[member], 1);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_dec(&mm->rss_stat[member]);
+	percpu_counter_tree_add(&mm->rss_stat[member], -1);
 
 	mm_trace_rss_stat(mm, member);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c8db9d69a826..1a808d78245d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,7 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
-#include <linux/percpu_counter.h>
+#include <linux/percpu_counter_tree.h>
 #include <linux/types.h>
 #include <linux/rseq_types.h>
 #include <linux/bitmap.h>
@@ -1118,6 +1118,19 @@ typedef struct {
 	DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
 } __private mm_flags_t;
 
+/*
+ * The alignment of the mm_struct flexible array is based on the largest
+ * alignment of its content:
+ * __alignof__(struct percpu_counter_tree_level_item) provides a
+ * cacheline aligned alignment on SMP systems, else alignment on
+ * unsigned long on UP systems.
+ */
+#ifdef CONFIG_SMP
+# define __mm_struct_flexible_array_aligned	__aligned(__alignof__(struct percpu_counter_tree_level_item))
+#else
+# define __mm_struct_flexible_array_aligned	__aligned(__alignof__(unsigned long))
+#endif
+
 struct kioctx_table;
 struct iommu_mm_data;
 struct mm_struct {
@@ -1263,7 +1276,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
@@ -1374,10 +1387,13 @@ struct mm_struct {
 	} __randomize_layout;
 
 	/*
-	 * The mm_cpumask needs to be at the end of mm_struct, because it
-	 * is dynamically sized based on nr_cpu_ids.
+	 * The rss hierarchical counter items, mm_cpumask, and mm_cid
+	 * masks need to be at the end of mm_struct, because they are
+	 * dynamically sized based on nr_cpu_ids.
+	 * The content of the flexible array needs to be placed in
+	 * decreasing alignment requirement order.
 	 */
-	char flexible_array[] __aligned(__alignof__(unsigned long));
+	char flexible_array[] __mm_struct_flexible_array_aligned;
 };
 
 /* Copy value to the first system word of mm flags, non-atomically. */
@@ -1416,22 +1432,28 @@ extern struct mm_struct init_mm;
 
 #define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
 {													\
-	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
+	[0 ... (PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE * NR_MM_COUNTERS) + sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
 }
 
-/* Pointer magic because the dynamic array size confuses some compilers. */
-static inline void mm_init_cpumask(struct mm_struct *mm)
+static inline size_t get_rss_stat_items_size(void)
 {
-	unsigned long cpu_bitmap = (unsigned long)mm;
-
-	cpu_bitmap += offsetof(struct mm_struct, flexible_array);
-	cpumask_clear((struct cpumask *)cpu_bitmap);
+	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	return (struct cpumask *)&mm->flexible_array;
+	unsigned long ptr = (unsigned long)mm;
+
+	ptr += offsetof(struct mm_struct, flexible_array);
+	/* Skip RSS stats counters. */
+	ptr += get_rss_stat_items_size();
+	return (struct cpumask *)ptr;
+}
+
+static inline void mm_init_cpumask(struct mm_struct *mm)
+{
+	cpumask_clear((struct cpumask *)mm_cpumask(mm));
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -1523,6 +1545,8 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 	unsigned long bitmap = (unsigned long)mm;
 
 	bitmap += offsetof(struct mm_struct, flexible_array);
+	/* Skip RSS stats counters. */
+	bitmap += get_rss_stat_items_size();
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 7f93e754da5c..91c81c44f884 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -442,7 +442,7 @@ TRACE_EVENT(rss_stat,
 		__entry->mm_id = mm_ptr_to_hash(mm);
 		__entry->curr = !!(current->mm == mm);
 		__entry->member = member;
-		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
+		__entry->size = (percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);
 	),
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..bb0c2613a560 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -134,6 +134,11 @@
  */
 #define MAX_THREADS FUTEX_TID_MASK
 
+/*
+ * Batch size of rss stat approximation
+ */
+#define RSS_STAT_BATCH_SIZE	32
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -627,14 +632,12 @@ static void check_mm(struct mm_struct *mm)
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
-
-		if (unlikely(x)) {
+		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
-				 mm, resident_page_types[i], x,
+				 mm, resident_page_types[i],
+				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
 				 current->comm,
 				 task_pid_nr(current));
-		}
 	}
 
 	if (mm_pgtables_bytes(mm))
@@ -732,7 +735,7 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	percpu_counter_tree_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1124,8 +1127,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
+	if (percpu_counter_tree_init_many(mm->rss_stat, get_rss_stat_items(mm),
+					  NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
+					  GFP_KERNEL_ACCOUNT))
 		goto fail_pcpu;
 
 	mm->user_ns = get_user_ns(user_ns);
@@ -3009,7 +3013,7 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
+	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-- 
2.39.5


