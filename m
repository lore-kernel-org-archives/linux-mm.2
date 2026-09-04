Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40DCC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5D36B009B; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96A26B009D; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC296B00A0; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13C96B009B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20FE0A37E3
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:40 +0000 (UTC)
X-FDA: 85176560280.10.FE674E7
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73F5A1A000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lp9uu06z;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjDwQHd1TIkqr3Ad7cKo//QgmO9EQnnm4D2U1FbPu7k=;
	b=kXYQtW43Y2yp0Q4oBPrCXNUScVVHKk1u3nQf3ekC0AGpdmAbBe65soGPBFZoOkr6NIBrpo
	c3fFv6NMqXk8qgPyVyHijD3XU8LBS6haHjAw3t7JIYODob8rjdmYMNX50LfjiYxuxulVDU
	4+fuOB903rSBxuL+GtHQgILtNC9TQPk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=lp9uu06z;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538058;
	b=am9B665dtiBwpcCUgQcLfDGB66/fu5nlmZiCyo+S09C08PwwlzahVyXdxgBe6VmhNrjTmR
	B3mP4KxdUpam2FykN/lW2z0nhd+JoRPkXvxwGjMA0hjZ9z7XX9cXO5I+Wttwut+9AoAQ9Q
	ZmX8KAL4eGiomXStfCgrthkaSg/rQLQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538057;
	bh=hjDwQHd1TIkqr3Ad7cKo//QgmO9EQnnm4D2U1FbPu7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp9uu06zNPQl7khWMI1vssh/2dU1Ru/wZAZAUeCHuPfV7QBZkjo9/UElf5Q85z9+N
	 qK9uSEPNd25d4bfkFlQPtjB9whU1NFhNgN0GGgI3y4mM6aAxIWHc0M4uivqu4ivxuX
	 uBfY8e19VjWNXqsRO3un3IoAiKfu4FwnbL8NoK4lNCXZGqpP+RZwUhYct+psqbnrkC
	 6bOilv2IVEERA4lEhML4qr8xAxkrKif90thNkbJOTJARFBsuWiAlcatrqLZfm3JP53
	 rmUOG8CEP5PCmnYyt9BCHTBUA0xj9WfltXwXb/Pu3+z39kXsqndZJ1hFShSNAxxjfh
	 OfT8AUlIRqi4Q==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zd5whLzWjm;
	Fri, 04 Sep 2026 12:07:37 -0400 (EDT)
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
Subject: [PATCH v22 04/10] mm: reorder mm_struct flexible array to place mm_cpumask first
Date: Fri,  4 Sep 2026 12:07:16 -0400
Message-ID: <20260904160734.23445-5-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fqr31ybsuz7hksbaojm91hf348mer6sx
X-Rspamd-Queue-Id: 73F5A1A000E
X-HE-Tag: 1788538058-860828
X-HE-Meta: U2FsdGVkX19kiKm6kpdyNJYX7R2xTATyDP2hOIHg3+EDFkzAu0fNjGfoKDfZP9vk5EkUV42czDilB1NGOeXo4W9Kv2QsfK+9gk3hI71HxiXDajIJsS1kLCcKr3fstIWely8J3I0/Cax+I/mFLR1ejwW+ntD/A8JPDnv6Iw3eLq7vbsWrO1HTxkfN2HEtmeARoXPT5JEObpaMUKztqmRmiQ3VMGrPt2josbROz+xgJrYx310tvqHMYELy2YuKL+ZgXjCLix5Hfj7tLZrkijJRTMhuEq1JBjqW82EdlqD56V/b7bUKgyMDkV2kRE/FW70RZKafcqLc7TbV2qS9fkddzWYuCFQm5TvwVCT/Vl3nssiTD/yD9odlmKUksbuURmHbZLLjRMMTPOAjWYZzoxGM9PzGoBOijpBSnVAhdF4J0WMPrGLMzyt24AdfA6Llp0Dr1UhK8Lqq5Z4NLpviuqpyRNF7ZCV42URw4gxA7jRo0g1fB1VgLe99dMSLP/Sb8Kge8MErjccM9JRJGACNNaelRC7NdyjrTLVa2W8ZfByFK4SvC+qtJg/doB8Cbh/wW3u+qIb6f2EVeJ+JRXOP4mUiWJ7HOkxDNZBvtE/ERdp4xOqh4ffYz3gJYYsPZcT2o5PW9RKuTheLYuhhdizQfV9zwVFY5csxhMjCEBWluhH7Kt/OawEDxPjq0VKYxrSmuM385O6JrxIWR4NuZucGI/M/NlT86ls1qTU1hjz8SzYle8mKAi7FZRCsCwW2kVsx8Qr76/amaZdAEuPziQHkT87gi9EnJGH4p4A9ROIdu0yZ0ylGqBc+A9FZxqppdv08XbZmaJGctBSGOgm9yO0DwveWjbig/qP9JPwkWZ2TejhE2CuuytHggSFvSYIoWHJS0fL5fHJpQlLqHLuytXyhP9eZP76T5bgXRssABCiC7lyuoH7Fv7UVOWJBJU0u8rdIIj5S9R9xJxzDpiDMY4Sq7Dg
 cowa/00h
 IjZtKVzRuYwD7ve59AHBi8xHjz03Z8QcRclFHoB/9cigRVxN/sy35apw4KslhmLT9xiXIPnBytkMUzCjMSCYCqUZ8pWI41Q91M5EQ5sVihXWymAwNqi50OsaxYw3Df3eSMpZpIMvtjnPDKGmK//Cuc/1AfzyUYvWuqDecgyPxmzI+jt6DVLJZJsmIDPjtFfSqPej5wGMIiyvALpZORDr6sRe92VE3BkDTkcf+1I4tM2MaBmRnL8C5MeDHGpl66Bf2dRwzuW/2sOmdx+WftM90iwQhspZug0A6GNolQMc8pOLEdFpyxlokiehReYDsvqTtJxjasFswiFMonzGxudT/ufSFHOnwq06h4e0AnK5tR2sEqU3Hyrcp3kBu74TOdcEcBQRHz/HHM0Ep0ePD+j/KZdFNnHOdUdFpTxccpehA8sh/Y6M7sUwRBknuDgZPGC8MJOrCVDJR8DAanhNXfjukPQ2pqE5sZ8dZaoi9IMXrwM16xIYzLijXZvTBogyT7DHq3bmN3o1Qu8UAfQROUxOwduukpNYR5HM0gUm4M3Ti0eu1hAl2pcTzJ4SCo2zUi+6P+YGGE6mOyOYlUKmT7cThPDvhZOFMNWyZVjzpkrIh1Tti56y4xXN6nk+J4bc0Bc/w/H53Xe9GrGhpNvwcNn4iV8v6NbwuRpV49o3tVJmHfS+KLFIqn+rB68/QOoWX1u4nm1Dg4vnGsyIZ1IGNreEZKcngMSBunzx4x0GMkCxfhw2MrDefgWNLx2Xyh+bk1YedkQi1o9VaMDIXMRIcUVhw+4SrwnbKNUk+YQZZljml9226R9g1+E0DwbwX26jgObQxSsKN7CCvOTGmbKXGReRYZltMlQXDcYqCsCzcJSUHd7n+wH2ESEV/My9KXwB61QkQU7I8xRoZkomiC6TsQY07UD5ZXckaYH7aYHTujBcF0+hFmo/qnE2DaruTxw0msgEo1r6vr18m1W+W4dHNra27FiLE2PiP
 /bTyZx/y
 vkgefp7krsJCKrBoEaUSzNDDyFVx5ws2Adb4YP9AalVPJu1g4fk82vxIP+x4Z6DwRjXgnSjHnchzMID6HkHR6gRRJY7IIO8dTWIhGhf1OjPnPb9BfU3gwt5eNwKYzBzrwAVibdJXlKuX8B8yFHJ0bA==
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


