Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF7B8CCF9FE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 14:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4588E00DF; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D518E00B2; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44788E00DF; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A21898E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:42:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 658EE16047F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:42:44 +0000 (UTC)
X-FDA: 84058675848.04.C3132EC
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id B5C41C0002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:42:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=o9I0mIXB;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761921762; a=rsa-sha256;
	cv=none;
	b=Zg9CNqrNlE/g5ggtLdFkmQzBXbE3NV2B2ZibBOGflIIUAIuNRVjo3y7afrtzy9G6/QcJZP
	MWFTJBpZXeoH99FdYUrJDtJukR5dlk2Xp093m0uCW0xg2C7y+hJ9wYZnsr99chzZNW8j61
	vzRCooAATjy+BtaeRS3AGv+rRrp/kI8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=o9I0mIXB;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761921762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qApuJyu4QGoKVJ2zHmgikkLddBCT3UrPtJ79qMUUETk=;
	b=jnM7pU2DFqHN7eDMHmNNHHjlofXSIJyLE1zJ3VJ0iDZtrjKLOD58vunHO3lS4XsZ61i+6w
	9VEw8lld37/l1Wy4qS1RraKlf5PnqACYoyhdkCk4ra7zACksnimx6ysheBkP+o0gAs0kO2
	Q0HpgryVJ5rCtzbfNKUPfT8ZliSgGaU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1761921762;
	bh=qApuJyu4QGoKVJ2zHmgikkLddBCT3UrPtJ79qMUUETk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9I0mIXBqRFknaIkfu1blNmJkATK18dekoZ0Rb3+TRz0vSwu8raZgPO17cT7NldR0
	 /0uNZ28GdkndFyHrE7dB27C8OOF3dxzFzklql4oR2/+HcFAtWv0d/iiXIYDu4YEAVK
	 XkvI6hRVU2TLApO/JgIiB57EOpCJZ6gqJBy92PXkenJkwO/g3Y96KUIMnoUZwXKJ4t
	 ZiPC/AT2I2QAGq625z01c6vIV6M8U0mapZvmEt1d4MLezoDNLRQiXT8puAL9uLrxZf
	 9Zar/vLRVb0+yZSJaF0TfAdBLpcRcKC8Q9ammNH+BTDCk1GKlH6ofIovK7HwKLdxso
	 ho+HTz/60XHVg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4cykGp0HSgzHZw;
	Fri, 31 Oct 2025 10:42:42 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mateusz Guzik <mjguzik@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sweet Tea Dorminy <sweettea@google.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large many-core systems
Date: Fri, 31 Oct 2025 10:42:32 -0400
Message-Id: <20251031144232.15284-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251031144232.15284-1-mathieu.desnoyers@efficios.com>
References: <20251031144232.15284-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: myug8fct3ok8rfrnq4836fjf9m4t6y86
X-Rspamd-Queue-Id: B5C41C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761921762-437902
X-HE-Meta: U2FsdGVkX1/dSw3uYUNhD9xU/e2ZZNmrv2OKWBg7yMNn8dd6PqEQKOeF/CzUVN18h7YKsgNfHqTVokhajRmUrmBfSnFyEto6rYOgvdq+Tr6AEJtQefJE7aap+D/cnaa0PKhkAoAmunU03EdHzDTfLCz1gfDNS2BU8b200LhvgJ0I0DAO/YKBM9LyK71QfUPpLcKF5ALj5DvCc8/s8lx99UxwwWotFU01bdOhLPmfQMNikVG9k/Za8lxu19xqwqKnMSFmPyUAMEFgKEnPiLzHrNgywr1JSK96kJFrEUXbw/97XBwl3L+hZGZmXlqUikJi1wJ+luvGx9JmVi8a7pQShjOKlyt40urp8T2N9w19afYhFEqKWmuZUSDXYRcmiWVhsTp6tVcCol9SrJiRJqmcXB5pd3qyTSubzDfaCYIwemkDBZMgANpt5/rj7SWO6bsqLJrRbNN9bDLZLZA/vrDFAWlzh+Tiyl7uBlwXC9QmiSAb9UqSwupo4oNpVXzXxcxNe/RwRqAgcmGVO1IOjpncfwKqDp65kXz+gS01FPocGTDE0aOjob59kBkbQdQU4WcdZOX5P6Jh/v7e3P23hneLJlvegI7NswrIMNQJmQ0krt9Qic2+FcEstU13DYHqHSu4yBUgOahvtVZVID/7YeF45ntFuLuhCCTh8W9906pI/1f3CwmutThSKVPYmMrMLvCFK0jNHEpuz43AEf9FQZFoDX3atoAqCHvSFh63iCUaUQYayeUbREHbYUBKj5nyEq7UNLZNWYhu42zFcK/dk1XWF6DtNB8arwefBtEhXfSc9KzE/bcJ0GbN2YCkjbDrc8VwvGvX7jsXtWiwlx9hWktguzMfbeR3Mhecey3o6uQntEJEEP2q4SVGcbIxSX/vctV+fYSDd0ppKAUmRhecsP8V1cn4K/hwAcCcYuTWIDjxrMVY19votqYji0TgTTwFxdEtk/U91YkAPVek5maMY/b
 zWNIYmzB
 f7e/hhZ/wItLP92USip9OiLAwzOYOKllnlmsN1gzbRz8R/jKTIO/eItd+ZwsXOQU37RwtKrXUj/Skj25HuwSIebl+sB0lWu7+m2AvOUvyKKt6givBjvpY9BpL/0KZYiABH1gRjC2OPlQfovSt5nPzNX7JylJzj9d8GJl5tlfDKvHDVpIlkQlj9nKHn9t5r4xn+UhZUsJWgUFF7cIPXEJ6gfjmrN4Z/Ih0OkD/vDl047lM5TTRrcC4C3Reivo0kjU3z5q57pyEMvoyCyBfC8kGVwL5x12BNw67xcztLsEtrgLu+gVFzv6KLacw6PMyKaJr7LaY7nXEUursqUaqn64LMloE6a56ROsl27Sw5WNZsRUADvweID8R/R9/Wi2MjAOXielAN+KV4YvMDUdp0l2Q1qHoScvBK+YjTkj3bTUcpr5/hzV/98Jq7ZHZR8x/rq+Vv4R8BLFl6rEEh3DM+2zrdwGOXCI/ix33zPPTK86hSVLGYi87wP8lLdkg9of9G2Ip3Hn+m+k/ONYOUJv/TXiv9NUgp/kGaZ21C/jyeA6/Qn8A91AE36TfIfsHskQWmnoe6EEoydexFJBvqk+zgLBBzZihnokwRl6+XExykCnu1cbJhYv0EFN6QY/3evM31OsbZrU/Crm/sKETRHGG3RxN/Y+JlPxU8NHHpbtq8ydK5nlqe8yi3AZD3fzHPkHhyiOy0XKqVCFU5io6JWyWh4JmDWo5NcHLFIqs98O3duIKF8dNt/J2IQvKyYTUkzSVRQGiPHOKY5627tNWiVwtH9DIBCg6sDtSVVkdfDbCsU/1xRW2rBm7wGQAJHPgzcwqfM/jg78Z5Z1DGJHKuHVPuh/z1gRs6XRpCtWfQW7sqjMm9zrAchqY14MOZiKLGw3T1KyIKNpmf10CdsaXfmdwU61CXtHIY14TN6ID8ukh/OcJjpWe6Vh2FLnGAmo0uby1C5B7Vx7QKXNcHeNEWM4LKhFpANMeodjo
 nvP05AO8
 rPFJd5SM0pdSsmDGl8dJKR0g2I9waU0nIH+6fl4TQktR80xb327nZhz1veuhXFRIEwLKr9uLwHDVGDgtw3IS7TSrm7Q2SDcUUMI4RkgD8LmGLuR3LZresg==
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

  This was a result of f1a7941243c1 ("mm: convert mm's rss stats into
  percpu_counter") [1].  Previously, the memory error was bounded by
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

commit 82241a83cd15 ("Baolin Wang <baolin.wang@linux.alibaba.com>")
introduced get_mm_counter_sum() for precise /proc memory status queries.
Implement it with percpu_counter_tree_precise_sum() since it is not a
fast path and precision is preferred over speed.

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
Cc: Sweet Tea Dorminy <sweettea@google.com>
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
Changes since v6:
- Rebased on v6.18-rc3.
- Implement get_mm_counter_sum as percpu_counter_tree_precise_sum for
  /proc virtual files memory state queries.

Changes since v5:
- Use percpu_counter_tree_approximate_sum_positive.

Change since v4:
- get_mm_counter needs to return 0 or a positive value.
---
 include/linux/mm.h          | 10 +++++-----
 include/linux/mm_types.h    |  4 ++--
 include/trace/events/kmem.h |  2 +-
 kernel/fork.c               | 32 +++++++++++++++++++++-----------
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..4f8f3118cfd3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2679,33 +2679,33 @@ static inline bool get_user_page_fast_only(unsigned long addr,
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
 }
 
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_sum_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_precise_sum(&mm->rss_stat[member]);
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
index 3da0f08615a9..e3dd00809cf3 100644
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
@@ -673,6 +676,8 @@ static void cleanup_lazy_tlbs(struct mm_struct *mm)
  */
 void __mmdrop(struct mm_struct *mm)
 {
+	int i;
+
 	BUG_ON(mm == &init_mm);
 	WARN_ON_ONCE(mm == current->mm);
 
@@ -688,8 +693,8 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
-
+	for (i = 0; i < NR_MM_COUNTERS; i++)
+		percpu_counter_tree_destroy(&mm->rss_stat[i]);
 	free_mm(mm);
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
@@ -1030,6 +1035,8 @@ static void mmap_init_lock(struct mm_struct *mm)
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	struct user_namespace *user_ns)
 {
+	int i;
+
 	mt_init_flags(&mm->mm_mt, MM_MT_FLAGS);
 	mt_set_external_lock(&mm->mm_mt, &mm->mmap_lock);
 	atomic_set(&mm->mm_users, 1);
@@ -1083,15 +1090,18 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
-		goto fail_pcpu;
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
+		if (percpu_counter_tree_init(&mm->rss_stat[i], RSS_STAT_BATCH_SIZE, GFP_KERNEL_ACCOUNT))
+			goto fail_pcpu;
+	}
 
 	mm->user_ns = get_user_ns(user_ns);
 	lru_gen_init_mm(mm);
 	return mm;
 
 fail_pcpu:
+	for (i--; i >= 0; i--)
+		percpu_counter_tree_destroy(&mm->rss_stat[i]);
 	mm_destroy_cid(mm);
 fail_cid:
 	destroy_context(mm);
-- 
2.39.5


