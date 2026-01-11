Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADC8D25031
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC356B0092; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50356B0095; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8966B0093; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F66E6B0092
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:51:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BB6F13C5AB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:51:16 +0000 (UTC)
X-FDA: 84320726952.02.60D2EF6
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id A7AFD140002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:51:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lT6x8Vok;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768161074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Eb1gb6rvz6OV1woaUXBjvGSCB+OU/GBfNfCaTfNrdA=;
	b=dcI2lXbLGwVs7X9Vuo16XXrpd32uXdRbAq0BIhJNUI9HPbMqBem3czYuCBJ5czX6nH1qlk
	lwJmcioYX+CJH/T8MHGexHlx+nRjxRnOVIDhwkY6Bths5J1yCl2ufmLA8b+Ziocbjb70za
	Z/TTPLCgvFjNBOrF02Oe1JuIzBBUfIA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lT6x8Vok;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768161074; a=rsa-sha256;
	cv=none;
	b=oDUcXYWoT2Nh8/og2u1tDwkjlgsX9mhgVlYWUTX2ozJdlZ/KoUIzkSr6j9wtVrjrZ8RSqy
	ZtstvTZaHmUZT/McKn7s22j/Fstu6MTj5cfnmDW+2dJCDALfm18OeCsZm6VEe+Tz4OC2aZ
	p9Afb8qT625APQaesL5Gfs9Ghe32rqk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768161073;
	bh=8Eb1gb6rvz6OV1woaUXBjvGSCB+OU/GBfNfCaTfNrdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT6x8VokHoarYv57oAg0vpkGGtzux4eOIc3zT3ZZz1RCpvebmoIKhv2lhKBRCJSm6
	 ulrQlt7hMn/DjsQTcSTctn0EbMc3zb/kuD0im72iHd08LkG7bUWuWnj2LvcND1ccq8
	 zB+YphqjQxQF9spJ6HxTvhjqelZqF5/HsaFwg5LXkxFEaeQQyXVEUpZii4fToJS1Yl
	 XzlNb8gO+RUogd3jYeP9tLe38MjfI0q7dugJ4UlN2Utfb5WbkMvR9yjpy5pmIYpBTE
	 8jc5/3TKRbJhu2uJ468In625xVfBbXmSv9/BBgWfkqxh9tjELMxkem0na+U7mZtGhp
	 9dnT63khQ/OvQ==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dq5jY5Zq7zlML;
	Sun, 11 Jan 2026 14:51:13 -0500 (EST)
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
Subject: [PATCH v13 2/3] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Sun, 11 Jan 2026 14:49:57 -0500
Message-Id: <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ymhnm86u3mx6sni9577497wpkwhjygj
X-Rspamd-Queue-Id: A7AFD140002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768161074-214077
X-HE-Meta: U2FsdGVkX1++cjGjvK+5sRof6MhFT4JVE01FKwQlezix87yPJaqBoZdN62PzqQlLU/FkfJ/iBzKpd7bSlgu2RRBkQs9vsUiQgjQMvCTGuk2NDjO0g09JPcDq7p2ebfwm2+gHMls4okWHqPGX+wL7F9v0u+JmeOhTffCwT95xEsbgT0FYZci9W5EZHAKBxKpBzKqFW0+//iEHMiHo8FcWtiLTk8sI80E4ZwZCL0DpXizkYcYtqCpwL/QiURwrAd+4S1vsdZd0rfGzowosCEvEBajZzpt5OJ9a6lcuVtqzM1m6ORqbaC7IpTNcXrp4Ll48NkyidJe2LtymimDzK1IUejk0z7qjwly7xuFLkpf/Xd/YttzCGcaRj/uJ9FpVtwnVj7tZu7ZXCyukWqbJzd0jcvptauyk8oT3tLntQZBOq0+icHDRQ+y2HbvJWPE+DRH0X+CArZOinmwrPTLSThnbzg4EJUISicAiAlJQMSnEYmNjtR+2/15PZimjpO5kX+6eEEbgqvkiznxhX9GFnL0q2MigEREzYIMJpt85qgk/Yy0cEHXnQ0127Is+9x5jpSG3FWxeZfo0zY+AD9V1jDhJkB3AbmQp6+p7luERcx9JOe6EJPPL44DJKjOyY79kf0FW3oBRRMiXPFnVhO31xv3A0YblxsE9BPxiPmgSvBg4azlNuqe635nP4Ij73PkcWoQwjmSHoMRv5tss+ZH+QEl8PptirDPvQL87kuHUgpDh969jhO3Wm5edlI9FztXDXtSoUyniRAg1PkJaOJKoMneD3blaX2tz1Rm2dfYJsUuXqfDX8KNVfhzW7bl3sUW4u/3ejG4wOKOuxYHJnIc+n7qmWTdHHe9G8DB5Fc5AwpNZojJ2DGNaCxRcTzhNGwXhgL80gASgEVDZdA4uKxnYHJsJSeHupZe6ob2dZbF1x8c8E08mb3eYI0uoonRyXyvug7nSL2QsgbdiP9vGG8OvKnH
 Fx29B3Tk
 Zj5B/yia3GOenwsK10JJs5rkUmdaX4jU9LubL00j4VBm+8WQQcHCzb1QQIAqo9wOg9zT1CUC9cZhRRaeTvNlu4/oQeUfE4caexXywfE66j6JjK65C3pqfJAamFlcq2NF9WhWEvumGwWC7QGcIMtQOgKcRuHnD8Rwa0KTkmMTal0OJRhd94uXhnEbOKupQBT+b7w0zm/mindfsJR5ar2iqxramB4BnMV/K6CHYEbCpuzCC0/HZSf6ygFP3gXjuO/+hhLgAFDDovI6jGhb26PuPkB9T0IxTI3xyd28sAHyqDkINBgknFONZpXdKF+Bl8NaAa+XssMYwSGwGf9K4c0GCutKDFdYVvdLAdkxUdrog6Sa0CJ/HRqghnHvGb7bGXdYURnsrYx9BxAqnvU8NKrwfL+/gP+pliGjPb0LqtnSoHH28W/Jno4Dj546cxV7EC5HARKInDVowsTGBYzkiZez+0vLYvWF3ugdio/7Y5yxk38nw58d7AiUJemIboxJvvXuzafqp1g7a5sf/ebOjcWf5THFZgPWra0llc4674GwRI1elLDWHQWaX6LQf74ASCR3Bakf0Cj4isu0N4UVJ6hCv/0ZEE8SZ64ZsKC/xjxcsGQ7d6f77t8B1uR3LGaVVxaYDv9+5nRXE96vGuoT4uohTwEe0OtAZpvW2mmq+4FVBIOdtlDnDnss2ChAqjabipxmms4Y9fkNe2oCZn7rgv6PDhKjW42gItmO13HjNGE2aIFZqoG3h+DogC7rXwausk63NqAAcg3IZ23ZGpvHPk7F8eAEiOz1DhW9IYQ9hI+YiIRRoLL7q27FNqCI8f2xU1XLq34i3U0y3Um3gs2BvUJzjgzOhHpn6jSFJk75mULGhtyMXAHY2g92CL5U2MnOTsI6iNrD6e5WykEflA0G8cTbIAUNdJSxaZpc2MddrBqoMnG2Ct+PTWZlTOsd7UAfeBeJ8GOQ2A9BOIgMwxBG7TqQ2s7uafasB
 zIeDrrR7
 smwLZN10z1twuVHG58ZcXaZp8UtT0v/U96V9zBbWnexX3baKnTZ3wP/qXLfmC5TKS5heqbh5BOIJRaZ23hO0C8mhkCSAl4uASL8IUiA4TJQ=
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
 kernel/fork.c               | 24 ++++++++++--------
 4 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..6d938b3e3709 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2843,38 +2843,47 @@ static inline bool get_user_page_fast_only(unsigned long addr,
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
index b1f3915d5f8e..949ac019a7b1 100644
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


