Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F63CC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9E46B0092; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBE046B009E; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADC36B0092; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 542016B009B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2D6DA42FB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
X-FDA: 85166030544.18.6EDA60D
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54E2BA0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Xd5Vb38D;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjDwQHd1TIkqr3Ad7cKo//QgmO9EQnnm4D2U1FbPu7k=;
	b=q0YJmDANeZJsYO0oYvpEkm1nMN24IebldB5pjqXLI/gQxbzG6nPVgj0JDOwTDZ1qKXMVhb
	UXzuOerFIB9kUGva/lWKnkYIN25v42k/CyJUPQ/eFebQKNNcjzegaq16gs9pTDdIZGtYNe
	+gZxSUcaueMZfoF2bpfLESrpKWfuTW4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=Xd5Vb38D;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf25.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287351;
	b=pRn97InQzIrinEF3eCEwifVsKGNJ9dUWfYZECRRRub8CQTCADhrUH2m7ix8DvawpBImPAi
	bAvM+4CWoRNx3x5+nnEWDXl/Tey+VeSjKP661SmbTTjm/zT9A6PaO5SYz4YIUuKwgMFQPi
	IAzZS/v5F+HgtiWyqjg7CGSXwdm8jcc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287350;
	bh=hjDwQHd1TIkqr3Ad7cKo//QgmO9EQnnm4D2U1FbPu7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd5Vb38DOHYqf5jsTX1OBL+XUPeo0hHAoghwuBZciNUCRhXiDYAyxd6pFmlef4HVE
	 tHBMDb+HaKLbtKDPcHOVJ6k+sYFn5RqYb2ntCV1Oy+b3e3zM5MvAq1YToHABCvKdkk
	 eaMN4SxmTkSiUMfjcESTBhstBDNuUZCEX3p2S23Fq8MXLALsdrMxTtOEWyXnyObG0I
	 cL5MpnlfkRzQ6y1BGyaeuTwvFStA0la/KwaN+hFn+q/So+nPxBzUxVw6XAbe1EYc5s
	 TfoEukUdQc8yH2Gxy6D0pNdzPk1WR5DKKFcSSexlFahl6vxCc2CHz701X3ZO9Pw9kt
	 oQRT3B0hndkYw==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsL4tHhzWP6;
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
Subject: [PATCH v21 4/6] mm: reorder mm_struct flexible array to place mm_cpumask first
Date: Tue,  1 Sep 2026 14:28:49 -0400
Message-ID: <20260901182857.26690-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54E2BA0008
X-Stat-Signature: nstzuk59w4g8im14x68xk4s4oo3ei5os
X-Rspam-User: 
X-HE-Tag: 1788287351-223942
X-HE-Meta: U2FsdGVkX1+5SpXyt1Pbm0j7RIQbDIrzfxCVr/6/4YkdEa7yIBp9a1EhDxJrC4usIgNvvOupLNugN6Ou1iO0LgMVK6nhzHnz6nW942a0mQ/asaYZrN+NH2A8vdPUT2w0YlBHY/cwADdjLGd7YQ4K2stFYMAqF2LfTBAL7XhgBOpmWdgtWiNXQqcj3NLJOXSq4wBiajy+gjfgTCfWgkr+XoYJfXs+JRKodFSDivssMFheO+xMEj/cR1Kc97TMhxTJzVDdvzAn95OsfZsdXwehmAOOY7nSdL7iTOCdfci7NIhUM5BwNrHrC5muXiRgEYjDSjAYZG6nMtKGGfhOXIRYylnka4FIQvsVsWPY4E3+nivXAcVMfVe/dauyYCC73xXESk7kpsPMkF+B0hqHiG+zrlkB4wwS80bSA0dx4rQpO6+a75OApn0RxrfQwlBu8YI65KTPu1k7ABgEGttKmMOzOnR8Tqt15NG6GmNO/sr/87D/sBpsv73I9hHBtAN24tdFhU3+TYuAMcWTSsVC70YeETFjGwrPF4OgyIP5L9W0IdUGJUfMlSajd7exutEDhfND8MqseTczQefyTy2bo2vowbU5v48ZjM7bPpVf6RrE2hqAUkaBJb66crB1wMobATurE0TNzxGRwCi7UvX1WYp3YxFp+jnA2+nNJgwK2FP1uQSLZ/CFkw7+p+OKOMtad9TIMyttxYGyHd/qpeOKMjHesCSJFr5GpYySDvRsDJn2uM/pm4RcUbboJkKdSXiNJ8ZVgCxMZCNd5bk+ZRrL/fuG7Qa85fZtl8i/cgp+hnLsU6CgFORiTtKYuAE8JIPLmqarqxM2rNvur/xf6y9go3xPtqdYnz/JTTodX3CQFS2fWyHaua/mBH0r1WqHzOYLU7r/f203JwmSuhmR1DzqSbq9TXOuCgkfQkqv0pfir+t/jjnSTngQjPB/xsCxsUnhgCY/jcNDvDPFzMpTqvrJAg3
 vJmkdGVI
 ZTE964WhkmXW8orU3zeZ6GGm3EPqoXXbYsBqs7O2djcQlKbgGwoF6GGYne6pJML93d+NOHWXJq8lJTEn/PreDUfmwaszrYDymyBgw8wQRv95teu8RxO5oGgCg4zR6sOP/k7Jh+GH3eE/eDkL6CZMOMYv5h/KxigaaeP0Aa7yhhZoJokFBmEMmFo+xe1QB/BQAD2CyqCBqZoCWITXp8r8KjTZJA00J/U9XmDOIb7TTK8RJPGDOs/v3K4JCrlMX5CQjhSuK7+bbmegkdJZW5L2UUuOB3MAKmXt5A9c/5em6BuH/ng5dR79eTObxMlJMv2oe34GGoV4wFlhj9gc7wbZRHQOXMMop5+pwCykrPCCbM0lkyif1RLo06p07rvXnm+4vRienR+9MybskAgeM8re4nE0MctMCeQVnLr75xRa51sEG9BUyRGpHkcXYQHS4PaMtNwDQaHYGKXH9ZAWtTBIfLboJxM6ye3Z82QmdfZEaa8EGRFsXk+qU0l93gwxpnlaFNQsoU6WCxEKdX6emNYVo9IKya+uID44SqhycZZ08nhNNx5OSIg1/wclNPA+uZ3qMYFBLYvZkjmadfinGZuW9ABevl98QtI30hec0NiD7HjYCq5aUMyD8/XVbLyOpeV3hquSFktFS47WXcKLdVzxjv0UAnlIrLgJi3pmwrzov9fikFQxnYy5/zFUJGhM79KrYjdpqczhuqGbUs2Nyy9sKh+NNnlPFcNu4py/in6vpMAxgLT1ulBm+Zh2DUg1fGkyOw7REh0ToQWi9rGGQf8cTLU7U94kNQ/atTqr6aEDhSFiP/w6sZMFMSrIpisqYlR3RkKXH1CW1dqxUcw8DEPxt+9cPuSV8Opi+/czZp4RGSDHWAaf10F0EU80fMhhR29PvOfQ66k3pQemyxY3GpQ19kISIhzpHAD+9c/Xwron2QVpzKPk3ZG2OIWeANz/cB9BBKgTu8hatCAM2WnB52IaFLEjqp8//
 f3Sly3JU
 dFef5eH3ZZ4TWcnsTgpGWX8s46D3rc6qPHgX+vqdlL+zJs/3oZXvcLHOnoQeuQJZ3MdJJE9IarB0c19MvJV6SgMdyluwhSGgZaG1wU1gzywndDqlHrA9Zc0xZ/Rdy8TnGmp+MOdKOKyQSkdHB60GeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reorder the mm_struct flexible array layout from:

  [HPCC tree items][mm_cpumask][mm_cid]

to:

  [mm_cpumask][mm_cid][alignment padding][HPCC tree items]

The previous layout placed the HPCC tree items first, which required
mm_cpumask() to skip past them using percpu_counter_tree_items_size().
This created a boot-time initialization ordering dependency: any use of
mm_cpumask() before percpu_counter_tree_subsystem_init() would compute
the wrong pointer offset, reading from or writing to the HPCC items
region instead of the actual cpumask.

On powerpc, switch_mm_irqs_off() accesses mm_cpumask() early in boot
via VM_WARN_ON_ONCE(!cpumask_test_cpu(cpu, mm_cpumask(prev))), which
could fire spuriously or cause silent memory corruption if the HPCC
subsystem was not yet initialized.

By placing mm_cpumask first, mm_cpumask() remains a simple
&mm->flexible_array with no runtime dependency on HPCC initialization.
The HPCC tree items are accessed via get_rss_stat_items_offset(), which
skips past the cpumask and mm_cid with appropriate cacheline alignment
padding. This accessor is only used during mm_struct initialization
(percpu_counter_tree_init_many), not on context switch or other hot
paths.

Introduce the PERCPU_COUNTER_TREE_ITEMS_ALIGN() macro to handle the
SMP cacheline alignment vs !SMP no-op in a single place, used by both
the static init_mm flexible array initializer and the runtime offset
computation.

The cost is at most one cacheline (typically 64 bytes) of padding per
mm_struct between the mm_cid data and the HPCC tree items.

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
 include/linux/mm.h                  |  1 +
 include/linux/mm_types.h            | 47 +++++++++++++++++------------
 include/linux/percpu_counter_tree.h |  3 ++
 kernel/fork.c                       |  4 ++-
 4 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7dd6fdda9bc8..ffbcd18c4ecb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3453,6 +3453,7 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
 	unsigned long ptr = (unsigned long)mm;
 
 	ptr += offsetof(struct mm_struct, flexible_array);
+	ptr += get_rss_stat_items_offset();
 	return (struct percpu_counter_tree_level_item *)ptr;
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 96ad6ac20b11..b26160b85f93 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1435,11 +1435,12 @@ struct mm_struct {
 	} __randomize_layout;
 
 	/*
-	 * The rss hierarchical counter items, mm_cpumask, and mm_cid
-	 * masks need to be at the end of mm_struct, because they are
+	 * The mm_cpumask, mm_cid masks, and rss hierarchical counter
+	 * items need to be at the end of mm_struct, because they are
 	 * dynamically sized based on nr_cpu_ids.
-	 * The content of the flexible array needs to be placed in
-	 * decreasing alignment requirement order.
+	 * The HPCC counter tree items are placed last and aligned
+	 * with PERCPU_COUNTER_TREE_ITEMS_ALIGN to satisfy their
+	 * cacheline alignment requirement.
 	 */
 	char flexible_array[] __mm_struct_flexible_array_aligned;
 };
@@ -1478,25 +1479,18 @@ static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
-#define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
-{													\
-	[0 ... (PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE * NR_MM_COUNTERS) + sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
-}
-
-static inline size_t get_rss_stat_items_size(void)
-{
-	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT						\
+{										\
+	[0 ... PERCPU_COUNTER_TREE_ITEMS_ALIGN(					\
+			sizeof(cpumask_t) + MM_CID_STATIC_SIZE)			\
+	       + (PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE * NR_MM_COUNTERS)	\
+	       - 1] = 0								\
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	unsigned long ptr = (unsigned long)mm;
-
-	ptr += offsetof(struct mm_struct, flexible_array);
-	/* Skip RSS stats counters. */
-	ptr += get_rss_stat_items_size();
-	return (struct cpumask *)ptr;
+	return (struct cpumask *)&mm->flexible_array;
 }
 
 static inline void mm_init_cpumask(struct mm_struct *mm)
@@ -1593,8 +1587,6 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 	unsigned long bitmap = (unsigned long)mm;
 
 	bitmap += offsetof(struct mm_struct, flexible_array);
-	/* Skip RSS stats counters. */
-	bitmap += get_rss_stat_items_size();
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
@@ -1677,6 +1669,21 @@ static inline void mm_destroy_sched(struct mm_struct *mm) { }
 
 #endif /* CONFIG_SCHED_CACHE */
 
+static inline size_t get_rss_stat_items_size(void)
+{
+	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
+}
+
+/*
+ * Return the offset of the RSS stat HPCC items within the mm_struct
+ * flexible array. The items are placed after the cpumask and mm_cid,
+ * aligned to the cacheline boundary required by the tree level items.
+ */
+static inline size_t get_rss_stat_items_offset(void)
+{
+	return PERCPU_COUNTER_TREE_ITEMS_ALIGN(cpumask_size() + mm_cid_size());
+}
+
 struct mmu_gather;
 extern void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm);
 extern void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm);
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 828c763edd4a..3e8a820e2d1d 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -66,6 +66,8 @@ struct percpu_counter_tree_level_item {
 
 #define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	\
 	(PERCPU_COUNTER_TREE_STATIC_NR_ITEMS * sizeof(struct percpu_counter_tree_level_item))
+#define PERCPU_COUNTER_TREE_ITEMS_ALIGN(offset)	\
+	ALIGN((offset), __alignof__(struct percpu_counter_tree_level_item))
 
 struct percpu_counter_tree {
 	/* Fast-path fields. */
@@ -167,6 +169,7 @@ void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *
 #else	/* !CONFIG_SMP */
 
 #define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	0
+#define PERCPU_COUNTER_TREE_ITEMS_ALIGN(offset)	(offset)
 
 struct percpu_counter_tree_level_item;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5bad7a24d186..db398b6c5288 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3126,7 +3126,9 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
+	mm_size = sizeof(struct mm_struct) +
+		PERCPU_COUNTER_TREE_ITEMS_ALIGN(cpumask_size() + mm_cid_size()) +
+		get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
-- 
2.43.0


