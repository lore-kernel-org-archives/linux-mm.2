Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B009D30CC1
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077DB6B008C; Tue, 13 Jan 2026 15:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018106B0089; Tue, 13 Jan 2026 15:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69DD6B0093; Tue, 13 Jan 2026 15:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFD96B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:04:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DA4016023A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:38 +0000 (UTC)
X-FDA: 84328018236.06.DFFD9D7
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id B109E40016
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=sKnlJx49;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768334676; a=rsa-sha256;
	cv=none;
	b=bf80iY0PjJpNdiOx5Vgz/q3f/RHam8UYQQW/rusHb+FsZGS/CG5C+vFPnEAg38s/yy7iK8
	OC/u1xIfnN1z5upKkjdQXqkmEmTLNmgGjf3Ifyag5dvKPhwey1poMCGvokgpEOeJgddOBb
	dp15lK4L/2K38A7z30B/OgxjGamZG+Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=sKnlJx49;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSg1BQcWHQjMwHYNX9LoejcfmG0qt+Fs7irhh9YXjRw=;
	b=cFdwV8serOTc0XSjm+c/4lxsK6ByJfnYISpsW917JiojIdDHafVW8gatgI5IPZzfAEx7DQ
	FJeE8jUo3vCdS2SztVFumJVrT1wCKVihk+dnYBDpffwd4yb846WVJmbW1arubo4Dsu/J4c
	Q5vBDsNC+otV8wMjlMd5EsPYmsV+Isc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768334676;
	bh=MSg1BQcWHQjMwHYNX9LoejcfmG0qt+Fs7irhh9YXjRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKnlJx49wW864+icb3W3fjDpJQfz1xtLffoUH2d9khGbgC4A+dTvXLbkbSksNRd+6
	 cO13JUZncyLHzmdcxo/In46hnKP+0y2kQsPLxGojjky1PAUnXegmqZ0tFjO5jEbIVB
	 KWhAJtoNOUgos3tHvMk/tN1DPydEXIUtPR99ZECBOfCyex/5W0kM+RuwmvwMdmzoQz
	 L4L7tFtzp1gjsozw8YUy46x2UiRDISqYfHTPVd/9XqJeSkvxd05WaDzEQ7/deBRQSh
	 +OoZOHZ6cK5rwUFyDMsJv3WGIBNSkECKu8H/drM6WDXCtfWMIhiDSYuZrWpq/ojXSe
	 oITM4eHHRbagA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drKw406pjzlrk;
	Tue, 13 Jan 2026 15:04:36 -0500 (EST)
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
Subject: [PATCH v15 2/3] mm: Use hierarchical per-cpu counters for RSS tracking
Date: Tue, 13 Jan 2026 15:04:27 -0500
Message-Id: <20260113200428.30614-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260113200428.30614-1-mathieu.desnoyers@efficios.com>
References: <20260113200428.30614-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B109E40016
X-Stat-Signature: t771ywc9ad5iwfnp7pr77m1rk4jztpii
X-Rspam-User: 
X-HE-Tag: 1768334676-907246
X-HE-Meta: U2FsdGVkX19rjF4bKW+Meq6g3ykWBx9e1/YaWVxGWeb7d7wwgAxh9GBcC6IydGWLY/oa81GzCyhYJJbB+PvNTidwwb7lKjh+WSWKslCuQKWoMKBuuPgmPc1b1WXgwkEQRu2xrMU3tYylkD4K/KZ8eS6ncXcWakowhOoWdE2e9ph0KeBHxqqwF3gDYKse7TZtq7aD4m7wlNuJaVyJDy4hwik1jprLmZvNmbDjK1yjk0jY62xxwOZ410Sa27PwWRJltU1+bFl0PKwjQwzeKlO7u1K6G3S06fsl4pShNyMXRhnjWWuo/SENPCcWiyt8Rl2o5OfezM2CQAqwgHx7+EenSA7VuHzNwNo1dSUawWZnaojWAthpggYSEqO001BF6mYKzNdC423snOqTA8pnVfuTXf8PUoBVAOxp7tLgHOsRKCXPP2fFtg0GFkKRoh0uGGgR910MBeOWoh6ZXLjdQpg6kBbOIlwaw2QsjBenL96vT6ZfeEavTdpXBzSK8EVDDOmO1lLwLWBNnfAt0V8tR0Rp8PwW2IjgL6E0QZA6DncOg0vXfS9l7OC+Eejgk5cjSU8fzjW8TLXApOA1gdl2/wyvCybMmnyhmm95VTOIJUHMIN11LRLPm+5TOw32tQWuIvW6h2RvYt6OmO3vbBS/uKF5lsHweuPrbJqV4Sxy39IjfiQOzr/LE7P4xs9LHZ+w48liodG5nF2zFAJyGIvKK5CENPDTZpgtqQgMI56o8S0WNtJO5ACbZ/eJrxZt2ym1DqHEE6yps8fHvUA3TdGpHOwAqF78VOcTONF2yEH2qDnj9iz9ucv0/dO8dJj6uFHVOw1Pmrk8yL4JV7txENv/xf1hPHVFEtreIu5xRiP4xkSjLLSVcZZQeCQAXixeMKRzs7MHNhE0FUHSCK0L/TN8PY7fBfT2jenN04iq4aeE7vPfYbX5dZfGsuYVB7S0ImTX9fIh7pPA/Jw2lWT9mMP5+ub
 6LIm9F56
 lRnkWq8XzeFtb0dEWqU4w55zconOrqnbMu5sflH16hhu16KU8BjY+vmPraXGk868/FkYliqgLLWGEihAksJkT6o/h84E38XqeLimNM4zAiNdrQDvLu6fTY91yuBUh/dYKK79Awcf74SUCp9PG1p643B5bwM+J+aUx+l4p6UWOjmi9MUX6VqE2YKXxoYWISapFsfBee3fVlmLb8r/qYQt+gz13zwqqOTAZ9at0l2XtzIARwAUrZFMHQOCdxqOzP58sDTDKzHyvEYcNMkOzTDUM/E338svuK0hSaSeHEtLf7XhC+GEgHStU6LnIsO+fQjG+MrwCz0LxMp5x4e8anHLBV48fn6lPEIaxo3qEWJXlrhdJ3IZcPB2Mi8JL74t2gX/3RUTQj2sc9WMTLll4LPAgnaE+RbxhnlAiujRGTxrDEcP1xNBHVh7k42eM18gFa2CuVsYAxUGaY7gVlsgCqV6ucoS+4J7Oi4KwEFTzP2QGZ1ZiFcVrv5JUgvv3OUZVnbiRvYT07SR6V9o33cSIBlxgDSTb/1ETJsNQwJdTJD/mzt7vhqYVwnC7GYQ95xC1T1V2lcM80PwvrTVUopXeqoFXKjceVRM9mvwGm0PtalCQAGF0L2ZejG7zm++GVeDzB25McgUwYG2dBt+w1vxQNTqWVqO9reShWmI+iXHf6xGzkgA0WuDajm0Em2027QWFSSEMGbUvsUrsZ/Xbrx9xxFgi9hx/qRIBeshrcN/wnJsDFx3mw82N/OYgaKml/Ig14aoe3i44V7EOayN5BEA1LcmbD+4IB1ySWOwhEAFgtpC27La68JzaTl4x/vvt32mL3tuHc3/L2vaJxde7NbQ3IcHWzxFqGnFnYUniWwbm9sq4M2/J9YUu1SsIs1wXPBDKQWFpJZ4HAc9NWnrDuY+Hfnh2BUbv0zlii0VT8VqFbM+w47oVl9yX3gnlX9T6HsAUJe9BaGJfnwQgdYWEZmZ1CuY13SzDVIxa
 KffkG7tv
 Xw/Tg0LevTRlHSiNsi18siKoStjH5fFb/8Q6HRMjnIah/36ZV95oFijNcSOLVX9afHDj/OPTgBXvDcC3d4VD9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use hierarchical per-cpu counters for RSS tracking to keep a precise
tracking of per-mm RSS while reducing the RSS counter sums calculation
overhead on large many-core systems.

This is a preparation step to introduce a 2-pass OOM killer task
selection which leverages the approximation and accuracy ranges to
quickly eliminate tasks which are outside of the range of the current
selection.

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
   adds overhead (and thus increases OOM killer latency) on large
   many-core systems running many processes.

The approach proposed here is to replace the per-cpu counters by the
hierarchical per-cpu counters, which bounds the inaccuracy based on the
system topology with O(N*logN).

* Testing results:

Test hardware: 2 sockets AMD EPYC 9654 96-Core Processor (384 logical CPUs total)

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

[ This patch depends on the following patch:
  "mm: Fix OOM killer and proc stats inaccuracy on large many-core systems" ]

Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
Link: https://lore.kernel.org/lkml/20250704150226.47980-1-mathieu.desnoyers@efficios.com/
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

Revert "fixup"

This reverts commit 46f29b72bfaaab4c6ee5a1ac8d29543b230fa293.
---
 include/linux/mm.h          | 17 ++++++++++---
 include/linux/mm_types.h    | 50 +++++++++++++++++++++++++++----------
 include/trace/events/kmem.h |  2 +-
 kernel/fork.c               | 22 +++++++++-------
 4 files changed, 64 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d096bb3593ba..0763934df8d5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2843,33 +2843,42 @@ static inline bool get_user_page_fast_only(unsigned long addr,
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
index 9f861ceabe61..c3e8f0ce3112 100644
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
@@ -1070,6 +1070,19 @@ typedef struct {
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
@@ -1215,7 +1228,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
@@ -1326,10 +1339,13 @@ struct mm_struct {
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
@@ -1368,22 +1384,28 @@ extern struct mm_struct init_mm;
 
 #define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
 {													\
-	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE - 1] = 0	\
+	[0 ... PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE + sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
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
@@ -1475,6 +1497,8 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
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
index b1f3915d5f8e..8b56d81af734 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -133,6 +133,11 @@
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
@@ -626,14 +631,12 @@ static void check_mm(struct mm_struct *mm)
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
@@ -731,7 +734,7 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	percpu_counter_tree_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1123,8 +1126,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
+	if (percpu_counter_tree_init_many(mm->rss_stat, get_rss_stat_items(mm),
+					  NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
+					  GFP_KERNEL_ACCOUNT))
 		goto fail_pcpu;
 
 	mm->user_ns = get_user_ns(user_ns);
@@ -3006,7 +3010,7 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
+	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-- 
2.39.5


