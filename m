Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F42CFA447
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7806B0027; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409686B0029; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23EF16B002B; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 099346B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:04:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CED3B12F9A8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:02 +0000 (UTC)
X-FDA: 84132212724.04.92CB592
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2EFD5A0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:04:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=OzNP0DgU;
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763672641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wJZ7CWNSc/U+A50EtWNkXCevtyNUA3g0fODzpH1Z4xk=;
	b=SypVsC/JkjDjER0WS5H7KJ9mlITQkKKcNpfyp+2JsFZbIXaZzTaFA2df5qrXaANH6k4d90
	9wZSU531mePyRYTWsTJbFsj64hNBNigo0fhXxGg44HnHo7QxXwShZpXJ+uNOf1ruvn7Ybc
	QwlcidOGjzxUiHT7V6YUp9NWS4Zcwb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763672641; a=rsa-sha256;
	cv=none;
	b=XmfKKUJwzvgaCnRbx4OxS/LLUPw2LeDQ2Yqdg+mqjpGKLkUjvGaNVXrP/qmaQJiPQc8+/T
	6p+nfqMTTICsU+nOt7Zoei5eg1mJMY8tUZlBx9cWmpoE7UAdx6OkaRQ87JatfOt7f6N5/E
	rN+Oiej8zcRyUzS6Jkxy5UrYkyG/6pY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=OzNP0DgU;
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1763672640;
	bh=wJZ7CWNSc/U+A50EtWNkXCevtyNUA3g0fODzpH1Z4xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzNP0DgUsIkV6H4+zoPjX6qyhxchfBNzs6FQA0CGvohHnT50FYg19SSUIQqMPgjgl
	 D/WM7iPIm4TDL/pcx8IakA2qNSm5zERt4PeU3aCToq51mwyWhKPZ90d4KU8VsfnuwV
	 9onGX+Q4cxZUYkpkOfLEyHx2/ssn4cBFawY0Tgobet8uSvxvwtjcJ2b6df9GQdgrR2
	 5XIgATUN2RSSePeZAW6e8ZE+2H1Z5aawlkYM6YHFP9MIYytB2PUWzVWfYNhPIaqeRD
	 ihnjzPMoGu/v3e2VcO1zsph8aqys2kvOWpvHn/5NhlqBHzV7qA75DDjUEktUKEp3LS
	 YN6wFaplNHDvQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dC9nX1VdPzPvx;
	Thu, 20 Nov 2025 16:04:00 -0500 (EST)
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
Subject: [PATCH v9 2/2] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Thu, 20 Nov 2025 16:03:54 -0500
Message-Id: <20251120210354.1233994-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2EFD5A0010
X-Stat-Signature: 7ygu6743mq4k3cxwk8rg3czgcohcr99u
X-Rspam-User: 
X-HE-Tag: 1763672640-919087
X-HE-Meta: U2FsdGVkX1+T+stUIbopzRNIXbCKI2pBOVEr8Q8Y9hIP4c1zotyBkDYH+ylwDqsHCu+ow/V8tMrM/8/ZHCdUUGjepz1E0uB3e0UcZZy5/lJd4kYJS6uCeeRCZV2KS2EKS7lwf0Dwp1XRPE0mbVWlJlIK7GNZ2w/dGRB3RoPsId6JUum6LXwgnN4IGohE55Goz0TTjblMs7sd4HUJLYA5MwSnXbOheNpqXLB0aS2AtfqzHgdKC+FsyGZpnCY+/9uzOIprZsrLwZthLHI6Kdd/Qg57Gnw+ltSIHdlr+7AJit7Ah9mDA6dcXq95fua+qZPTq8JAY3FFuLC6ov1e7iKhPf9qYlcccwNpJfGGzIWcvzrwptEZhAh8aIjwY14bLdb2S2/iSBKTh/92D5+u3rPTWHss+fgluO6npsEJ+sqrHfPE0s9syA0+YvzTjJN9QTaxhZkDEXpE/fNYUcVYXxvXgXTzNC5YW5ckBXfXHc9UvF0Pbhx/z/wvvOKCVwcsYCtGZQmkJtUpfSdZhimsefgt1wJxjoiJS5+mWWOrG4aB3snZMe+W5sIk5EhjsFK9hilyzop1xGIi7skvVTq0jIvN0WYzf98kkA7KSj2Mo7Cru7V3ysl5OLgmmS5+reteOs1/xmZlZHUyucc61BqNKzzEmIvKZxytI/R+WlE5lkiGzBRDIUY2EzCDZRv5Uy0BRYnQ+zqmxmAzSQXS+MTEmmM/TgMwpm6KvZdAL9TLywOBLF1vOkf4IhIfJDEQCfgb/gyjFt6ZdHr+u4/Ly8zKixJ4+yz/7wmz4JqXHRnex5FzO3VbIoPPxakXbZpuqFxqZnrQV9YmBZO8ZEZrVVHW/wH6VLzgIbTnY+t9ORpkz4TnUyef71Cf+3zNqU9cfw5Qfi5bLAqApvcAAVFVOShb066XbRFMwMHKk8hE+V7k7DlTPHYRw4tD91UYIdXmQGCzjtht9JK9GxX+Kp2EWYxH/+Z
 P1LvY0mK
 FyNNbaRGkT04f++psaA6lvjRXoq6a9L5N6fbNddxJ5t76GMZeum+hJ2twvYR8cx97OXGiFgWH9876TQRaFsXDEPL+SwG7Bb9lwSdyHO7c0Mvl2F4ygRwr41rwJRpcdBqFrTd0io87+Mk+IIzLUJ+58T75+MOTy9slts13tpsAV51JuXlsJ50vrpqSE6N2MH3Gv94CH8e6DoMRBWSl99ks/HARo1/fID1YBrpsycBoVeZq/wua4VIbbcVAzMivLlTf7DP4BlnWs1oU6Y5GzPRgino3m06GoPTTYKIvNe80ILyZEynwIhhpFJDR3WgmcbXgwmX+w1FApXHgnJRepdLVmgKeLwIdKclYWDQm3i5unvQPFDvP2NZiXKt2YWRpUBZRx1fM8QzL/HritBQfes0gR2Efm35nuS6mrgFbrUnrHrif0qwWFucZFBela8IjXBXuPPEVp/DhME9hzd6Gu/ZOcIXwPovl1w324lhHFt+3gLDnEvjK5HdS5BFL2cHhQ+vR5o+ISz5ZVkkdzWygZ20nQbgBLwFi6RrdUBkhMe9t1jltKgtieAHrOrf5iw+jX3/xtKjXwzR8572+/HdkjLr6ju5w10ZXHp0wZKQmh+q1yGrfbwdnXpylN5qtNt/b0Ek5bwE7L889oMJh0bVTpatsdlhsQQH/HCUdPqMRUhLnoJW7kuwm3QWX0DYfXdn/SqaLb7jpVTv/tntZQEzGBh46GDzT2t/knbIh8p4R26vqXOJBAl/sg3AWmF6QxWvsKq7Oo8d0A46t9bm+k9izHxVuycCqigtNUXgF+8KGeXW2KPUEXn5n8t2iBDjgSU5lZK4NhkvXZHjY4OFo7iFfcl4EPsvd5yMqStTzhI8P91tAkrqfnfvkROc1CE0IiNqWk78WAikg6KkL8rKFjJSNKFRHx8sZwbGgwn/SgeTuDZAqw1Ac7cXvofpsQarGXHfihxJ35GCSE3bNs349atRhB6nPcDC2eC3z
 Fy/OKSDJ
 IFJ59rXcbek8TJv3z9ldKDXy+n/MRzhoP6IKl4h4rrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use hierarchical per-cpu counters for rss tracking to fix the per-mm RSS
tracking which has become too inaccurate for OOM killer purposes on
large many-core systems.

The following rss tracking issues were noted by Sweet Tea Dorminy [1],
which lead to picking wrong tasks as OOM kill target:

  Recently, several internal services had an RSS usage regression as part of a
  kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
  read RSS statistics in a backup watchdog process to monitor and decide if
  they'd overrun their memory budget. Now, however, a representative service
  with five threads, expected to use about a hundred MB of memory, on a 250-cpu
  machine had memory usage tens of megabytes different from the expected amount
  -- this constituted a significant percentage of inaccuracy, causing the
  watchdog to act.

  This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
  into percpu_counter") [1].  Previously, the memory error was bounded by
  64*nr_threads pages, a very livable megabyte. Now, however, as a result of
  scheduler decisions moving the threads around the CPUs, the memory error could
  be as large as a gigabyte.

  This is a really tremendous inaccuracy for any few-threaded program on a
  large machine and impedes monitoring significantly. These stat counters are
  also used to make OOM killing decisions, so this additional inaccuracy could
  make a big difference in OOM situations -- either resulting in the wrong
  process being killed, or in less memory being returned from an OOM-kill than
  expected.

Here is a (possibly incomplete) list of the prior approaches that were
used or proposed, along with their downside:

1) Per-thread rss tracking: large error on many-thread processes.

2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
   increased system time in make test workloads [1]. Moreover, the
   inaccuracy increases with O(n^2) with the number of CPUs.

3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
   error is high with systems that have lots of NUMA nodes (32 times
   the number of NUMA nodes).

The approach proposed here is to replace this by the hierarchical
per-cpu counters, which bounds the inaccuracy based on the system
topology with O(N*logN).

commit 82241a83cd15 ("mm: fix the inaccurate memory statistics issue for
users") introduced get_mm_counter_sum() for precise /proc memory status
queries.  Implement it with percpu_counter_tree_precise_sum() since it
is not a fast path and precision is preferred over speed.

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

get_mm_counter_sum -> precise sum positive
---
 include/linux/mm.h          | 28 +++++++++++++++++++++++-----
 include/linux/mm_types.h    |  4 ++--
 include/trace/events/kmem.h |  2 +-
 kernel/fork.c               | 24 ++++++++++++++----------
 4 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..cd81fa8924eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2681,38 +2681,56 @@ static inline bool get_user_page_fast_only(unsigned long addr,
 {
 	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
 }
+
+static inline size_t get_rss_stat_items_size(void)
+{
+	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
+}
+
+static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct mm_struct *mm)
+{
+	unsigned long ptr = (unsigned long)mm;
+
+	ptr += offsetof(struct mm_struct, cpu_bitmap);
+	/* Skip cpu_bitmap */
+	ptr += cpumask_size();
+	/* Skip mm_cidmask */
+	ptr += mm_cid_size();
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
index 90e5790c318f..adb2f227bac7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,7 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
-#include <linux/percpu_counter.h>
+#include <linux/percpu_counter_tree.h>
 #include <linux/types.h>
 #include <linux/bitmap.h>
 
@@ -1119,7 +1119,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
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
index 3da0f08615a9..5430d63c9e2d 100644
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
@@ -583,14 +588,12 @@ static void check_mm(struct mm_struct *mm)
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
-
-		if (unlikely(x)) {
-			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
-				 mm, resident_page_types[i], x,
+		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
+			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%d Comm:%s Pid:%d\n",
+				 mm, resident_page_types[i],
+				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
 				 current->comm,
 				 task_pid_nr(current));
-		}
 	}
 
 	if (mm_pgtables_bytes(mm))
@@ -688,7 +691,7 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	percpu_counter_tree_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1083,8 +1086,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
+	if (percpu_counter_tree_init_many(mm->rss_stat, get_rss_stat_items(mm),
+					  NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
+					  GFP_KERNEL_ACCOUNT))
 		goto fail_pcpu;
 
 	mm->user_ns = get_user_ns(user_ns);
@@ -2964,7 +2968,7 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
+	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-- 
2.39.5


