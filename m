Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F387C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930326B0088; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B07A6B009F; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC846B0099; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40B866B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3ECBA04FE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
X-FDA: 85166030544.07.095C217
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3127FC000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BDAjNixh;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287351;
	b=cQnen5sfPkMjvs6SYX9LocKnsLzngkn9vKAuPSbII+HqdcrEI3r1/X5mNA/MVqk3C5tL0C
	pBvXIhR5OwtEd5Ys1uRRt0Px47gnF3ieGgSvguezI8g2REX2/llmtIa9AAmdltQXmR4QPW
	WXAO4gAxmxce30R+0xO8VwMCFXbweTs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BDAjNixh;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5XjUMcgmvN6EiMKr1kiGvv/bXDNdn2svG6c9pEzr3Y=;
	b=RCnijMjgS9lV9YFh4vhw3NJxc4PsaIZu/v4CxYONRPxfPIpVInCRk61R8IdcCMdafw9Da2
	q/Xu7Rii3eDwd6bqz+CHdvEZNpbXTNapCSvuej4Y66DMdV/jXfJFNTxg0odpUXSOexXBdq
	tkPed1pEPbm4QOUgi6y4D/SLwdA9X6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287350;
	bh=Q5XjUMcgmvN6EiMKr1kiGvv/bXDNdn2svG6c9pEzr3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDAjNixhhGB/QDTdAlXYl3RBqh4Qiw9LHrQoftps8vO27L58OItNhF1wb7nGp5ngX
	 avI40BoLMnBSg83sY7/tVU/UmntcDm2Xl148FHvq4ddLwQff8jjCopkMn8hvq0xeki
	 2HnSTu0dv9MLDwd49kOlOGjO0P2coH8DfD8RBR+1Pdhk3g6UOnnFUUcyEvAiyR7fUT
	 fbPW9nxAMfAjIYWu0ehV8fEKhvjrVhxSEM7OEfgPWT+Hr63CqWikCUFvs6T4aLmYFS
	 Ft5rnDwsSuUkMXQzZntV2D/YQQItn9B+6WJsoVHlPDff43W70Jc36Slnsa4ua4EbSW
	 Gl9g8Q1akdDog==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsL3m6FzVRL;
	Tue, 01 Sep 2026 14:29:10 -0400 (EDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v21 3/6] mm: improve RSS counter approximation accuracy for proc interfaces
Date: Tue,  1 Sep 2026 14:28:48 -0400
Message-ID: <20260901182857.26690-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: z9cmh3xsicf3zo8csou1efoy9dow3tdo
X-Rspamd-Queue-Id: 3127FC000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788287351-810757
X-HE-Meta: U2FsdGVkX18CcFprLeRbubvyoehMdraVH+Mt6Z6BJFbi5God9y/httuvDxmLhykMitPC1hOTC9aEJ8bjctS3LhDM8K17YY6TZ1MN538AqFwBHdneosq91gcqa5x9N6Up3OPOAtcl7Whtod3huLNUnKK4vGWVEWuchSDkchbkfHnGhCLUhXQHBuOF6vogL/sH/4+rU4lJLRoET3AqfpWZ0nOQ2bbd39zcL1siMaeZo5KJpOqbCzFu6eWL+Lcsz7M48RE7zJmuSYvGy/llGH63Rm3BbFK3z2eWS9xJ4GBpRRRk/pyxqtuE44CkkWdo4KlcjBwYqT6ceeW2bmEfKpaVOrWw2ufuXWSEnV7xSMKBWkBdfNdrtZzMRe3hR5nW2MnTfknoeJ6NxdacOFI/uNl0d3sIL9w2/aixsaRRGjXjRUMu7SYVQ4h2KjaJeULxtFKVxo8pGXi5BgM6SrDLftyhzQl8x126eT/0h2FiMkUZ//90G/ZWtlZqeRo/zBKkh9TCm0eHNwV7aIlvR9eyRu4USxqWq2B79A7bZVktnopU5StTlqeTZduaLXB0lYquz7n/rj+rskyQc8p1zFwokHJ+QR1s30TimP3I9sK+hzVJnnrgwCujZIL4Vdiey3F4u12hPFY1zKWdfCCB8D1haiSlSMUzbUVEaJLbPk7LAaAndWtJTPbao0idfRFx++NvV/iooydZ+LmLAAklz7xI7u1KzUU4iEreIpj/oyCp7GJ8bQBEELpTcvtuWchCFH2H0g+fxtR5xVLXlcex8DlB+I1i4sSXoump2pSMSv3SMznAt1yyQqsO+vx5eK2jzP+dXFuo9pBuZAa1+6GfgDb41K9umd6KPjymkAaPVYPhWwFUwQVwUCe1ZxZxr5JyWasrv3al+p1p1Xz97OPojQE3mXUxl+ycIFIZ0oqmAKt996BSm2jeyOcpsByrE0lrFiW7rSF4+SsMmo2tjandXztyy1L
 c7nVoFxu
 XAMnQ6mY3MX09hwEFtek+VA84/BfV0r8bzAnE8yoHid0/mZQ9uaOrLoHrHceN+laNa7Qf36W4nL1VSc9rzgnEHTSooH1I3AU5bsDb8AO1q7bHGYhSQQZml/5igo+BENZv1x0h2A/mkjWhifYXXG+3f776A+qm8Rtuclptj2C2Qc8IogY01ZJYEfq4hvW5HfkspsJnefT0ziGRiHj2zJdjIeDObxUk3OXOL9xL1dayiwu4StOmRyAR98fnBkEOoP0wZx+UJVcI3L4MDeZ5RMSRnaaeQs9oXBn/ftUfaoDkctGF/bAAGGGqkg/MYIEsHSquigXFnZtNAwPOfSLTv0kBpnQGbA8QaXKTZungTyv/01GnhxdlIK7ZDKv9v8VqTFdVlqMXzve+PZ7zD4x1gWsUXtTRHAM57HyDZe3dAqtMWvkGXM5SzjJyalyl/5nIhb8OTNbEIEKeJl4k2XbVmV40g4A26DlfPJNPFthbO3KIkYHPqKTdwFn0TGZ6NOKfcxnzI3AGF8oDyuwss3Szzv/go5RI8Nals44LYdU/4RRA8p+/s0zXAtG6EafOibLRU6N2tIBI9i0YItPQPUYF5fpiJ3q19EQBnKZgTxtxyj+HTOx+ueQMQ0ywyKxEdB36pSoWhJDdDc7+XI5Fe4vk05y2byLSLjxaRXi0EG31e95CA3U+gh+k/Yl9/5YFSWZBByz5xVUdxzvVQE51AiqUYDkqdm2Vb3mDMXlRo1dUboD5DfnOSsYOfxK/UPjzr6pPK5kY6iBTAR1PEx/KjlBAWctDdtsT7ZlT2Pk7dwrWrOYlQbvxcDcENlrGjCLI7mOgC3UVka0N43UfBYbOZEhesKXXXoVAUL/5OEzBLqlqVXMKkR8P14tIRGv3YTgdLdUzYhtaaPELxf2LruRLOCPWc39E8bX9Ygir/STMVVVq43K2LxxnX6qITdwRuvRIxvoNvRvnM1E3qyx4LXc5mhAxR9eVt0pc2VCc
 +7i5CDUI
 dFSPhAW5OcO2kJeglRsdQSaFr7J9aFvManQlpS6TnZuOblDHlEFmHFgM+rNBzZVjE4tRQitKuzMfxLyErffnJY4oSG1r9c25
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use hierarchical per-cpu counters for RSS tracking to improve the accuracy
of per-mm RSS sum approximation on large many-core systems [1].  This
improves the accuracy of the RSS values returned by proc interfaces.

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
counters is done by keeping both implementations wired up in parallel, and
running a single-process, single-threaded program which hops randomly
across CPUs in the system, calling mmap(2) and munmap(2) on random CPUs,
keeping track of an array of allocated mappings, randomly choosing entries
to either map or unmap.

get_mm_counter() is instrumented to compare the upstream counter
approximation to the precise value, and print the delta when going over a
given threshold.  The delta of the hierarchical counter approximation to
the precise value is also printed for comparison.

After a few minutes running this test, the upstream implementation counter
approximation reaches a 1GB delta from the precise value, compared to 80MB
delta with the hierarchical counter.  The hierarchical counter provides a
guaranteed maximum approximation inaccuracy of 192MB on that hardware
topology.

* Fast path implementation comparison

The new inline percpu_counter_tree_add() uses a this_cpu_add_return() for
the fast path (under a certain allocation size threshold).  Above that, it
calls a slow path which "trickles up" the carry to upper level counters
with atomic_add_return.

In comparison, the upstream counters implementation calls
percpu_counter_add_batch which uses this_cpu_try_cmpxchg() on the fast
path, and does a raw_spin_lock_irqsave above a certain threshold.

The hierarchical implementation is therefore expected to have less
contention on mid-sized allocations than the upstream counters because the
atomic counters tracking those bits are only shared across nearby CPUs.
In comparison, the upstream counters immediately use a global spinlock
when reaching the threshold.

* Benchmarks

Using will-it-scale page_fault1 benchmarks to compare the upstream
counters to the hierarchical counters.  This is done with hyperthreading
disabled.  The speedup is within the standard deviation of the upstream
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

In the proposed implementation, the per-cpu counters are allocated within
per-cpu data structures, so they end up using:

  nr_possible_cpus * sizeof(unsigned long)

This is in addition to the tree items.  The size of those items is defined
by the per_nr_cpu_order_config table "nr_items" field.  Each item is
aligned on cacheline size (typically 64 bytes) to minimize false sharing.

Here is the footprint for a few nr_cpu_ids on a 64-bit arch:

nr_cpu_ids   percpu counters (bytes)     nr_items       items size (bytes)     total (bytes)
    2               16                     1                 64                    80
    4               32                     3                192                   224
    8               64                     7                448                   512
   64               512                   21               1344                  1856
  128              1024                   21               1344                  2368
  256              2048                   37               2368                  4416
  512              4096                   73               4672                  8768

Compared to this, the upstream percpu counters use a 32-bit integer
per-cpu (4 bytes), and accumulate within a 64-bit global value.

So there is an extra memory footprint added by the current hpcc
implementation, but if it's an issue we have various options to consider
to reduce its footprint.

Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Link: https://lkml.kernel.org/r/20260227153730.1556542-4-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 include/linux/mm.h          | 19 ++++++++++----
 include/linux/mm_types.h    | 50 +++++++++++++++++++++++++++----------
 include/trace/events/kmem.h |  2 +-
 kernel/fork.c               | 22 +++++++++-------
 4 files changed, 65 insertions(+), 28 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..7dd6fdda9bc8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3447,38 +3447,47 @@ static inline bool get_user_page_fast_only(unsigned long addr,
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
index dff5fd1c1b06..96ad6ac20b11 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,7 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
-#include <linux/percpu_counter.h>
+#include <linux/percpu_counter_tree.h>
 #include <linux/types.h>
 #include <linux/futex_types.h>
 #include <linux/rseq_types.h>
@@ -1170,6 +1170,19 @@ typedef struct {
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
@@ -1312,7 +1325,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
@@ -1422,10 +1435,13 @@ struct mm_struct {
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
@@ -1464,22 +1480,28 @@ extern struct mm_struct init_mm;
 
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
@@ -1571,6 +1593,8 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 	unsigned long bitmap = (unsigned long)mm;
 
 	bitmap += offsetof(struct mm_struct, flexible_array);
+	/* Skip RSS stats counters. */
+	bitmap += get_rss_stat_items_size();
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..290ccb9fd25d 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -448,7 +448,7 @@ TRACE_EVENT(rss_stat,
 		 */
 		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
-		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
+		__entry->size = (percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);
 	),
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 416758c8a3d4..5bad7a24d186 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -137,6 +137,11 @@
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
@@ -633,14 +638,12 @@ static void check_mm(struct mm_struct *mm)
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
@@ -738,7 +741,7 @@ void __mmdrop(struct mm_struct *mm)
 	check_mm(mm);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	percpu_counter_tree_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1144,8 +1147,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	if (mm_alloc_sched(mm))
 		goto fail_sched;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
+	if (percpu_counter_tree_init_many(mm->rss_stat, get_rss_stat_items(mm),
+					  NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
+					  GFP_KERNEL_ACCOUNT))
 		goto fail_pcpu;
 
 	lru_gen_init_mm(mm);
@@ -3122,7 +3126,7 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
+	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-- 
2.43.0


