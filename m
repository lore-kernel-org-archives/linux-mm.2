Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA24BC5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92FD6B008C; Mon, 24 Aug 2026 08:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A836B0095; Mon, 24 Aug 2026 08:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D592E6B0096; Mon, 24 Aug 2026 08:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABD256B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:25:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40F38A0108
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:25:53 +0000 (UTC)
X-FDA: 85136084586.24.0DED6B7
Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	by imf01.hostedemail.com (Postfix) with ESMTP id 300EE40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w60RRd2O;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7xuqD1+ZFrPFKlRYdX1h143k6jR1mQfy+UYTXqYIo8=;
	b=YoLvQnOp0oY8n434pZ0QDMMYH1rPy44drASH9Ma0GjlRzhyDT2HtSzfqB5IoC0r3kL1w3k
	2SBMGNSD1VRpWBhIQq9Fy4MNWhR2yfxvMS5bZJfaEeT/97HmfVj/yTrxOtkcwbn7Ixk4uf
	HASrlGo9hDbSWoLK6+8/dQnf3xIVdY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574351;
	b=Ioq6Ek38sq/jYHMy4nc6zgl+CJAqMtpG11bQKOXeucpgGW8R+j8YONY8brHHcHPJpJEoIG
	OQsudnnjJ94oI9B/Zh+fm/ObJ55AQufnbwH5llLxfWVrylh0fwOhY9T6Sdna2BU+QGrKDv
	iM+WAn/0X87S/gXoZpzO0zscrkxVSfk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w60RRd2O;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.86 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=u0fy0HfeCh5tClgSDXdZezoo/TQsu0IR16Lc03KZk9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787574349; v=1; x=1788179149;
 b=w60RRd2OBZIZ/6871lNX/aYwdjwRltY2Qmwk2GhfEyAOsZlhIj7xUurpkEMy8hvmtQ16//2q
 fhbdZs+9z4dviOllmPc7P1GTMXILf5n4Bn9AV4c4zsh97aN2zl+ytLIJ9ThD4O4Hzkzp7I5VvWG
 Hta6Q9koXfFw4MlOwuBSfPko=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 31cc02fec83eb9b7;
	Mon, 24 Aug 2026 12:25:49 +0000
X-Mizu-Trace-ID: 31cc02fec83eb9b7
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce list_lock contention
Date: Mon, 24 Aug 2026 20:25:10 +0800
Message-ID: <20260824122513.3829-2-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824122513.3829-1-hao.li@linux.dev>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8tykppg7w5iqbjib3anbqsd4m88499yh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 300EE40008
X-HE-Tag: 1787574350-324560
X-HE-Meta: U2FsdGVkX18n2z7/6dUdKhUC1YuDzesg+NiEiP/MtiH1K+jwAqK+NTI5LgkJGIlU2qIm8Tvrs5w57gC5hC6u4RW1bjdofMPfnCkHCtMPH6+05LJ6FkxFmZP2YPUtnWJ30KBRak0h0EzhOOIWU1e2/FB+5GcwuiWaMhQaSA03LoLiwujdakyZlOEGtHs9hG4CAfCUjPuHrm9pud64q/9DaEVS0NXsHGQPZaw0UCMxNs9CqsGE8jAqAPYubJeqIcN0mYRyynb1Lqin+bgdTedKV9XU1v9S+gPcjQJEkF7fCDlD5QhUBzYbyqp1DE20GnfVwPQdEJbV4x7u5BtH/uhs87CF71i7cJu8ztNFYZO6K3m/QGBolYH7MVCSlMe1ozJ99N0FwzEjrp+Ua10KIOQ8OSnrobgGMxtDuqkI8ypvoSB8O5MnTyCpfseXny1a7TrFO9BPxe8SeMZA1Fz68ZNdhBuGZffnTHOEbmZ5Qk3PJrhVa1JJbS4zlvsVdO31VuOYi8kf760LYU6ZIjHMdkZVgCm6RTkR/pzTkrBvAGjGuwdTtLBEvd0cc7asA2jSkko7MafL0ZqY940/KSL0GjiP1jH9BDsdzcydU9XHwQMQVPnL7UALtry4H/+NrkeRFK2eD+t29a2bNpJ+ngxZXVUIxA3wWhH+wJUSN0jee072m7DXqAaNuuAboNr33HFxqTCIkJNwLJRntn5WK/Xb0i5r7zDdHUErrb3DvanAiV/Y4eX0XLRe+XeYd1LrmLPI2RhMozAKJPI0feTjkakA8scVAmvaROlXJtBSoVyptvo/R7/fvcYNYIpqNJbGDTGOSsADi1/enW0n8lo7S/vb3e1vqe1Oe07Uz/FGyHZyiPiIol9eLOB1fmVdD3tUolmvvDdpzoiXCW458BnQR36/cGOV7FEvU/J3LPxnmEI+qy/5zdK3/Pden9i/QW3PvJfz+nC0fWSeon8ysVxFOlgxUSE
 LFKacNJT
 I0xqaXOW3xBVtc5QhsFwLZoiT2/nksOa0X2/E0GNxCob4dwd3H0yqTSmIToqu23S9VYLvrwPFVO7D1kRpZaf+uWPH2hltFwfAML8WVEMjQK04a3gUd42Zr+MlqONCxV2ie2M6HLpWLyR4RLXRWDjPnf/Q2kSoaoGkYHtnbRdwtHawm8hmLLqNNmF+l/9E+FW2JGURfmfoKlYs5Bj+9KMI5mBXYyjlfKcC9ImaAigXo/l8OjhcGoX0WrsEkRi3UdOIqkEKYCmNQtAvC7zT/VpSX8V2wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a mechanism called parking to mitigate lock contention in the
free slowpath.

In the free slowpath, when __slab_free() transitions a full slab into a
partial/empty slab through a free operation, it must acquire the list
lock to add these newly freed partial/empty slabs to the partial list.

Why must partial and empty slabs converted from full slabs be added to
the partial list? Because only by doing so can the sheaf refill or alloc
slowpath see these partial slabs and allocate from them. Therefore, the
list insertion must be performed, which requires acquiring the lock and
leads to heavy lock contention under high concurrency.

Analysis of profiling data from the will-it-scale mmap1 benchmark shows
that full -> partial transitions account for a large proportion, second
only to partial -> partial.

With extra instrumentation added to __slab_free(), the following data
was collected for the maple_node cache (in counts):

  partial->partial    843017414
  full->partial       550719384
  partial->empty      17459564
  full->empty         2

Since the fundamental purpose of __slab_free() is to make newly freed
partial/empty slabs visible to the sheaf refill or alloc slowpath, these
slabs can be temporarily stored in a staging area in a lockless manner
instead of making the free slowpath contend for the lock. The sheaf
refill or alloc slowpath then checks this staging area first when
allocating objects. This achieves the goal of making these slabs visible
to the sheaf refill or alloc slowpath while allowing the free slowpath
to operate locklessly. This process is called "parking".

Parking occurs in only one case: when __slab_free() encounters a full ->
partial/empty transition and the trylock fails. In this case,
__slab_free() attaches the slab to an llist locklessly, instead of
waiting for the lock unnecessarily.

Conversely, the process of moving these parked slabs from the llist back
to the partial list is called "unpark". Unpark occurs in four cases:

1. Sheaf refill or alloc slowpath: This is the core case. The sheaf
   refill or alloc slowpath must see the parked slabs, so the first
   thing done after acquiring the lock in the sheaf refill or alloc
   slowpath is unpark.
2. Cache shrinking: shrinking also needs to see slabs in the parked
   state.
3. Cache destruction: kmem_cache_destroy() must also see parked slabs,
   which is obvious, otherwise memory would leak.
4. delayed_work (see corner case b below)

Why is this scheme correct? Because paths entering the sheaf refill or
alloc slowpath can see both slabs on the partial list and slabs on the
parked llist, while allocation paths that do not enter the sheaf refill
or alloc slowpath would not check the partial list in the first place
and naturally do not need to care about parked slabs. Therefore, whether
an allocation takes the sheaf refill or the alloc slowpath or not, slabs
on the parked llist and slabs on the partial list make no difference to
the allocator. This visibility equivalence is the core of the scheme.
This analysis also shows that the scheme does not affect the utilization
of partial slabs or lead to increased fragmentation.

Corner cases to handle:
a. Parked slabs may become completely empty. Therefore, unpark must also
   check min_partial and free excess empty slabs instead of adding them
   back to the partial list.

b. In rare cases, the system may go idle immediately after slabs are
   parked, and the sheaf refill or alloc slowpath may never run
   again. These parked slabs would then remain in the llist until the
   next sheaf refill or alloc slowpath performs an unpark. To
   solve this problem, add a delayed_work named unpark_work to add
   parked slabs back to the partial list when no other path unparks
   them.

On will-it-scale mmap1 with 192 processes, throughput increases from
29237910 to 35585663 (+21.7%). native_queued_spin_lock_slowpath drops
from 44% to 30% of cycles and __slab_free() disappears from the lock
profile. alloc_slab,free_slab drop by 52%, and park_slab equals
unpark_slab exactly, confirming no parked slabs are left stranded.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 275 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 247 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e20375307770..27a78d63f537 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -49,6 +49,7 @@
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
+#include <linux/llist.h>
 #include <linux/debugfs.h>
 #include <trace/events/kmem.h>
 
@@ -122,6 +123,8 @@
  *   (Note that the total number of slabs is an atomic value that may be
  *   modified without taking the list lock).
  *
+ *   Slabs may be pushed to node->parked_slabs without acquiring list_lock.
+ *
  *   The list_lock is a centralized lock and thus we avoid taking it as
  *   much as possible. As long as SLUB does not have to handle partial
  *   slabs, operations can continue without any centralized lock.
@@ -368,6 +371,9 @@ enum stat_item {
 	FREE_SLOWPATH,		/* Free to a slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
 	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
+	PARK_SLAB,		/* Slabs parked onto the llist by free slowpath */
+	UNPARK_SLAB,		/* Slabs unparked from the llist */
+	UNPARK_EVENT,		/* Unpark events */
 	ALLOC_SLAB,		/* New slab acquired from page allocator */
 	ALLOC_NODE_MISMATCH,	/* Requested node different from cpu sheaf */
 	FREE_SLAB,		/* Slab freed to the page allocator */
@@ -462,6 +468,14 @@ struct kmem_cache_node {
 	atomic_long_t total_objects;
 	struct list_head full;
 #endif
+	/*
+	 * If neither sheaf refill nor the alloc slowpath performs the unpark,
+	 * unpark_work_fn takes care of it.
+	 */
+	struct delayed_work unpark_work;
+
+	/* Used to link parked slabs */
+	struct llist_head parked_slabs ____cacheline_aligned_in_smp;
 };
 
 static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
@@ -509,6 +523,12 @@ static nodemask_t slab_barn_nodes;
  */
 static struct workqueue_struct *flushwq;
 
+/*
+ * Ceiling on how long slabs stay parked when no sheaf refill or alloc
+ * slowpath unparks them.
+ */
+#define UNPARK_DELAY	(HZ)
+
 struct slub_flush_work {
 	struct work_struct work;
 	struct kmem_cache *s;
@@ -3623,6 +3643,122 @@ static inline void remove_partial(struct kmem_cache_node *n,
 	clear_node_partial_state(n, slab);
 }
 
+/*
+ * A slab parked on n->parked_slabs is not on partial list, so its slab_list is
+ * free and we reuse it as the llist_node.
+ */
+static inline struct llist_node *slab_to_parked_llnode(struct slab *slab)
+{
+	return (struct llist_node *)&slab->slab_list;
+}
+
+static inline struct slab *parked_llnode_to_slab(struct llist_node *node)
+{
+	return container_of((struct list_head *)node, struct slab, slab_list);
+}
+
+/*
+ * Move slabs parked on n->parked_slabs to n->partial. Called with the
+ * list_lock held, by the paths that consume the partial list, on behalf of the
+ * cpus that could not get the lock when parking.
+ *
+ * If @discard is not NULL, put empty slabs beyond min_partial on @discard, the
+ * caller should call discard_slab() after dropping the lock.  Callers that may
+ * not free pages in their context should pass NULL.
+ */
+static void unpark_slabs(struct kmem_cache *s, struct kmem_cache_node *n,
+			 struct list_head *discard)
+{
+	struct llist_node *pos, *next;
+	unsigned long added = 0, discarded = 0;
+	unsigned long headroom = 0;
+	LIST_HEAD(to_add);
+
+	slab_lockdep_assert_held(&n->list_lock);
+
+	pos = llist_del_all(&n->parked_slabs);
+	if (likely(!pos))
+		return;
+
+	/*
+	 * Calculate how many more slabs the partial list wants before it has
+	 * reached min_partial.
+	 */
+	if (s->min_partial > n->nr_partial)
+		headroom = s->min_partial - n->nr_partial;
+
+	for (; pos; pos = next) {
+		struct slab *slab = parked_llnode_to_slab(pos);
+		struct freelist_counters flc;
+
+		/*
+		 * Back up the pointer, because the list_add_tail() below
+		 * overwrites the llist linkage.
+		 */
+		next = pos->next;
+
+		if (discard) {
+			flc.counters = data_race(READ_ONCE(slab->counters));
+			if (!flc.inuse && added >= headroom) {
+				list_add_tail(&slab->slab_list, discard);
+				discarded++;
+				continue;
+			}
+		}
+
+		slab_set_node_partial(slab);
+		list_add_tail(&slab->slab_list, &to_add);
+		added++;
+	}
+
+	n->nr_partial += added;
+	list_splice_tail(&to_add, &n->partial);
+
+	stat_add(s, FREE_ADD_PARTIAL, added);
+	stat_add(s, UNPARK_SLAB, added + discarded);
+	if (unlikely(discarded))
+		stat_add(s, FREE_SLAB, discarded);
+	stat(s, UNPARK_EVENT);
+}
+
+/*
+ * Parked slabs are normally unparked by sheaf refill or the alloc slowpath, but
+ * when the system experiences a heavy burst of frees, abruptly goes idle,
+ * and neither sheaf refill nor the alloc slowpath is reached,
+ * some parked slabs may be left stranded in the parked llist. This function
+ * serves as a last-resort fallback.
+ * This work is scheduled by the llist_add() that makes the parked llist non-empty.
+ */
+static void unpark_work_fn(struct work_struct *work)
+{
+	struct kmem_cache_node *n = container_of(to_delayed_work(work),
+						 struct kmem_cache_node,
+						 unpark_work);
+	struct llist_node *first;
+	struct kmem_cache *s;
+	struct slab *slab, *t;
+	unsigned long flags;
+	LIST_HEAD(discard);
+
+	if (likely(llist_empty(&n->parked_slabs)))
+		return;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	first = READ_ONCE(n->parked_slabs.first);
+	if (unlikely(!first)) {
+		spin_unlock_irqrestore(&n->list_lock, flags);
+		return;
+	}
+	s = parked_llnode_to_slab(first)->slab_cache;
+
+	unpark_slabs(s, n, &discard);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	list_for_each_entry_safe(slab, t, &discard, slab_list)
+		discard_slab(s, slab);
+}
+
 /*
  * Called only for kmem_cache_debug() caches instead of remove_partial(), with a
  * slab from the n->partial list. Remove only a single object from the slab, do
@@ -3818,9 +3954,13 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 	struct slab *first = NULL, *last = NULL;
 	unsigned int total_free = 0;
 	unsigned long flags;
+	LIST_HEAD(discard);
 
-	/* Racy check to avoid taking the lock unnecessarily. */
-	if (!n || data_race(!n->nr_partial))
+	/*
+	 * Racy check to avoid taking the lock unnecessarily.
+	 * The parked_slabs llist must also be accounted for.
+	 */
+	if (!n || (!data_race(n->nr_partial) && llist_empty(&n->parked_slabs)))
 		return false;
 
 	INIT_LIST_HEAD(&pc->slabs);
@@ -3830,6 +3970,9 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return false;
 
+	/* If there are parked slabs, move them to the partial list first. */
+	unpark_slabs(s, n, allow_spin ? &discard : NULL);
+
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 		struct freelist_counters flc;
 		unsigned int slab_free;
@@ -3874,6 +4017,10 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 				    &last->slab_list);
 
 	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	list_for_each_entry_safe(slab, slab2, &discard, slab_list)
+		discard_slab(s, slab);
+
 	return total_free > 0;
 }
 
@@ -3885,23 +4032,29 @@ static void *get_from_partial_node(struct kmem_cache *s,
 				   gfp_t gfp_flags,
 				   const struct slab_alloc_context *ac)
 {
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	struct slab *slab, *slab2;
 	unsigned long flags;
 	void *object = NULL;
+	LIST_HEAD(discard);
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
 	 * just allocate an empty slab. If we mistakenly try to get a
 	 * partial slab and there is none available then get_from_partial()
-	 * will return NULL.
+	 * will return NULL. Also take the parked_slabs llist into account.
 	 */
-	if (!n || !n->nr_partial)
+	if (!n || (!data_race(n->nr_partial) && llist_empty(&n->parked_slabs)))
 		return NULL;
 
-	if (alloc_flags_allow_spinning(ac->alloc_flags))
+	if (allow_spin)
 		spin_lock_irqsave(&n->list_lock, flags);
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
+
+	/* If there are parked slabs, move them to the partial list first. */
+	unpark_slabs(s, n, allow_spin ? &discard : NULL);
+
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 
 		struct freelist_counters old, new;
@@ -3939,6 +4092,10 @@ static void *get_from_partial_node(struct kmem_cache *s,
 		break;
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
+
+	list_for_each_entry_safe(slab, slab2, &discard, slab_list)
+		discard_slab(s, slab);
+
 	return object;
 }
 
@@ -3994,8 +4151,13 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
 
 			n = get_node(s, zone_to_nid(zone));
 
+			/*
+			 * Parked slabs make the node worth visiting even if
+			 * nr_partial looks low.
+			 */
 			if (n && cpuset_zone_allowed(zone, gfp_flags) &&
-					n->nr_partial > s->min_partial) {
+					(n->nr_partial > s->min_partial ||
+					 !llist_empty(&n->parked_slabs))) {
 
 				void *object = get_from_partial_node(s, n,
 								gfp_flags, ac);
@@ -5719,7 +5881,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	bool was_full;
+	bool was_full, park = false;
 	struct freelist_counters old, new;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
@@ -5731,10 +5893,11 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	}
 
 	do {
-		if (unlikely(n)) {
+		if (unlikely(n && !park))
 			spin_unlock_irqrestore(&n->list_lock, flags);
-			n = NULL;
-		}
+
+		park = false;
+		n = NULL;
 
 		old.freelist = slab->freelist;
 		old.counters = slab->counters;
@@ -5749,9 +5912,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 
 		/*
 		 * partial->partial: the slab was on the node partial list and
-		 * stays there, so we need no list handling and no list_lock.
+		 * will still stay there, so we need no list handling and no
+		 * list_lock.
 		 *
-		 * Note that continue in a do-while goes on to evaluate the
+		 * Note that "continue;" in a do-while goes on to evaluate the
 		 * condition below, so we do perform the freelist update.
 		 */
 		if (!was_full && new.inuse)
@@ -5762,20 +5926,46 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		 * or added to (due to not being full anymore) the partial
 		 * list.
 		 *
-		 * Speculatively acquire list_lock before calling cmpxchg(), as
-		 * performing cmpxchg() prior to lock acquisition races with
-		 * concurrent paths, such as the shrinker.
+		 * For the full -> partial/empty transition, use
+		 * spin_trylock_irqsave() and the parking mechanism to reduce
+		 * lock contention.
 		 *
-		 * If the cmpxchg does not succeed then we will drop the
-		 * list_lock and retry.
+		 * If the cmpxchg does not succeed then we will retry.
 		 */
 		n = get_node(s, slab_nid(slab));
-		spin_lock_irqsave(&n->list_lock, flags);
+
+		if (!was_full) {
+			/*
+			 * partial->empty: speculatively acquire list_lock
+			 * prior to cmpxchg(), as performing cmpxchg() before
+			 * lock acquisition races with concurrent operations
+			 * (e.g., the shrinker).
+			 */
+			spin_lock_irqsave(&n->list_lock, flags);
+		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+			/*
+			 * full->partial/empty: the slab is full, so it is on
+			 * no list; if the list_lock is contended, then we
+			 * park the slab without waiting for the lock.
+			 */
+			park = true;
+		}
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
 
-	if (likely(!n)) {
-		/* partial->partial: we didn't take the list_lock */
+	/* partial->partial: we didn't take the list_lock. */
+	if (likely(!n))
+		return;
+
+	/*
+	 * Park the slab. If this park makes the parked llist non-empty,
+	 * then schedule unpark_work.
+	 */
+	if (unlikely(park)) {
+		if (llist_add(slab_to_parked_llnode(slab), &n->parked_slabs))
+			queue_delayed_work(flushwq, &n->unpark_work,
+					   UNPARK_DELAY);
+		stat(s, PARK_SLAB);
 		return;
 	}
 
@@ -5783,22 +5973,30 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 
 	if (!was_full && !on_node_partial) {
 		/*
-		 * partial->empty, offlist: a bulk refill has taken the slab
-		 * off the partial list and will put it back, so its list
-		 * handling is not ours to do.
+		 * partial->empty, offlist: the slab has been taken off the
+		 * partial list by a bulk refill, or parked during its full ->
+		 * partial/empty transition. It will be put back by other paths,
+		 * so this slab's list handling is not ours to do.
 		 */
 		spin_unlock_irqrestore(&n->list_lock, flags);
 		return;
 	}
 
-	/* full/partial->empty, exceed: we have enough partial slabs already */
-	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
+	/*
+	 * full/partial->empty, exceed: we have enough partial slabs already.
+	 *
+	 * Parked slabs are also counted as partial slabs. We don't
+	 * keep an exact count of parked slabs, so we treat any parked
+	 * slab as roughly exceeding.
+	 */
+	if (unlikely(!new.inuse && (n->nr_partial >= s->min_partial ||
+				    !llist_empty(&n->parked_slabs)))) {
 		/* partial->empty, onlist, exceed */
 		if (likely(!was_full)) {
 			remove_partial(n, slab);
 			stat(s, FREE_REMOVE_PARTIAL);
 		}
-		/* full->empty, exceed: it is on no list to remove from */
+		/* else full->empty, exceed: it is on no list to remove from */
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
 		stat(s, FREE_SLAB);
@@ -5818,7 +6016,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		add_partial(n, slab, ADD_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
-	/* partial->empty, onlist, not exceed: it stays where it is */
+	/* else partial->empty, onlist, not exceed: it stays on partial list */
 
 	spin_unlock_irqrestore(&n->list_lock, flags);
 }
@@ -7360,8 +7558,13 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 
 			n = get_node(s, zone_to_nid(zone));
 
+			/*
+			 * Parked slabs make the node worth trying
+			 * even if nr_partial looks low.
+			 */
 			if (!n || !cpuset_zone_allowed(zone, gfp) ||
-					n->nr_partial <= s->min_partial)
+					(n->nr_partial <= s->min_partial &&
+					 llist_empty(&n->parked_slabs)))
 				continue;
 
 			r = __refill_objects_node(s, p, gfp, min, max, n,
@@ -7682,6 +7885,8 @@ init_kmem_cache_node(struct kmem_cache_node *n)
 	n->nr_partial = 0;
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
+	init_llist_head(&n->parked_slabs);
+	INIT_DELAYED_WORK(&n->unpark_work, unpark_work_fn);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
 	atomic_long_set(&n->total_objects, 0);
@@ -7815,6 +8020,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 	}
 
 	for_each_kmem_cache_node(s, node, n) {
+		cancel_delayed_work_sync(&n->unpark_work);
 		s->per_node[node].node = NULL;
 		kmem_cache_free(kmem_cache_node, n);
 	}
@@ -8115,6 +8321,10 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 
 	BUG_ON(irqs_disabled());
 	spin_lock_irq(&n->list_lock);
+
+	/* Unpark slabs so the walk can find them. */
+	unpark_slabs(s, n, NULL);
+
 	list_for_each_entry_safe(slab, h, &n->partial, slab_list) {
 		if (!slab->inuse) {
 			remove_partial(n, slab);
@@ -8386,6 +8596,9 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 
 		spin_lock_irqsave(&n->list_lock, flags);
 
+		/* Parked slabs are shrink candidates as well. */
+		unpark_slabs(s, n, NULL);
+
 		/*
 		 * Build lists of slabs to discard or promote.
 		 *
@@ -9525,6 +9738,9 @@ STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
+STAT_ATTR(PARK_SLAB, park_slab);
+STAT_ATTR(UNPARK_SLAB, unpark_slab);
+STAT_ATTR(UNPARK_EVENT, unpark_event);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
 STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
 STAT_ATTR(FREE_SLAB, free_slab);
@@ -9613,6 +9829,9 @@ static const struct attribute *const slab_attrs[] = {
 	&free_slowpath_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
+	&park_slab_attr.attr,
+	&unpark_slab_attr.attr,
+	&unpark_event_attr.attr,
 	&alloc_slab_attr.attr,
 	&alloc_node_mismatch_attr.attr,
 	&free_slab_attr.attr,
-- 
2.55.0


