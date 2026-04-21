Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75196F5A8DA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 03:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883E86B0088; Mon, 20 Apr 2026 23:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834386B0089; Mon, 20 Apr 2026 23:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC256B008A; Mon, 20 Apr 2026 23:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58E6E6B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:15:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2597113C12D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:15:11 +0000 (UTC)
X-FDA: 84681096822.10.C5002E0
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C11416000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 03:15:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oD/AYqDV";
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776741309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CeJVbM2OnIQLUXn70ggs8YX5CWpOhskj/Admdwfs5cc=;
	b=ZVe7Fsy/+OnjVM8GpCdxwqoUIGru9LO/P5S9mlw7zN9wf4QgJ+uc5MnIc6x7ZmVqoDGySP
	06Cy38UvkdICU8X4bLoZQ7epqULJ/FRrhxm2pJ+dFbNPyVTLP7VoKp8+G59zlVyo+P4/yc
	Jnq12W3XE/Pe5NQunCrIQ3qbD8bTUVs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oD/AYqDV";
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776741309; a=rsa-sha256;
	cv=none;
	b=AjKlMSF+PSGe+r30DK+fBDsr2+SbZZsCn5qj4ep9bU2ErKeLm5o2TLeda3th+0n5ID51QQ
	vgPUaiy8kDaV147raj4d+BPxo3zAn7qewNQ1NG28ho68+hSkd2orezD9KdCWSYffLa/Zqc
	4A+41qU//SHEAQKYQgSrHSo5rvH6fNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776741305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CeJVbM2OnIQLUXn70ggs8YX5CWpOhskj/Admdwfs5cc=;
	b=oD/AYqDVeyHw4CD3dINI4U8xx5+T0AsrWA3adsPEaRgYPoo3MA9k9zQyZP37XnBmlherOQ
	Ia+SGyYKvaqCnSBe5AcUOI1e0XILwD4z0HO0qFJCYbOo3EoyimSqFLw7YKLrLHlCZG4144
	wvDnmFxTpm8BgvZa5W78iV5gGI0OA+k=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2] mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Tue, 21 Apr 2026 11:14:06 +0800
Message-Id: <20260421031406.1189000-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C11416000B
X-Stat-Signature: zmbkcf15e89tc1ttr76rz3mkpu5d3dz8
X-Rspam-User: 
X-HE-Tag: 1776741307-386291
X-HE-Meta: U2FsdGVkX18boGE2L0hhjzbGuFRgehnyUvpUAeuVdp0SjJAHKKVqk5ly+sP1MWP7exBgAlHYKamPl/VgVuP2kXTIP95L5sxu7XtEP0XYkE0uIvlcdF26VmB3JrxtYtRt8EDWVsXycH9mniW0EMgqxPwH9q4xAQYlAq9cpYhlO+m0Z/S39V9oiu+Xm85AUC4vh1M8C9YymX+o/ywAA87UitoxZqF5fYiQcma691Rc8suEfSYN9GrzVgR37FnismIVg5bTq0VoTICD5DCYCgM4hqBABmsY4lYBnBizT06VF2v6dO/TQSaiz3VWhPnWhfKu1rGp2q+nFmbTZ8i8g3IFF6VUFDPDcutX6TtGvOgAq4VkqZF28NA6qD83OuWiDYyOSr7XkN1yfXQjly4LzClHQ50rFwmrbGmDIk1e/kmaDJOIaGDCHPPVc4dDlwUbCjBKLv8180Wq3fsmgzFUL+daqTtHNAJAWTjQ0436sopB3m/Xq4DHVUl7gslwvHtXdWbZiKnvB9lMoI+rhRO6zWUDWJ/HApn3qEJPvmMEtQUaB0xabbSOwQl77fGVG8hBq/8U5R+4GFJjKZrPylr+3eLl6ZPnwI2kMujWhQZjZ1tbqLTS14wHCzVnelyx110faRrY+fOhkbnQFZV2vjspVRItnOpwmhcji43gZmVu9FNyJx1nlrs1D5AS1IRdC9oqm5iYiJzNdhuSg6xn1mJJ2uO3UJ9c2aCd1OnpHFhO1+A6LrTGMAlm6zW4ai6RbG2bsoHiX6kdJYABUncPePrNvQSEq14v6EwEbyMlGVLvWGkC3cWPVkBMXYi2Op/iw9oXMhtNxjFur+Pp52yPyx6GDJbVWFOkJY49rVIq+tXqSF2BFL29DSdGcwp4VMd4r9x33NVhcf+TzbhPvhl2g2WeuHn3DJmpF6VvmnjZXE4EBNG8+dgEDXlE0q8Lr+LRWcglCXhCgQ6mILdzWdQffGGE6UC
 ByveV5Ss
 2V5g+tP0aEckhlouC5Y5BWT9glxTJlAF5YJAxCPKqbaEmAJ/yQOea0ezQXCpcJ9+Lv6pC3zYFa4pXGVkkTqMkFNKqznTEV1IIRG5+2+tIrr6pR0Ir5FDJU0MtsHsD4fxzCNMg+Q08mgCwHcJyaly2JTvYQZIQHhDoc/06/ljrRri7awhWgj5b6FSMKx6rGqTXuYJTpwpkeeruPqJYmXi8F9NdYFMHOxJgdli/NcgdAMs7+WDvihHEIOhhJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages allocated before page_ext is available have their codetag left
uninitialized. Track these early PFNs and clear their codetag in
clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
warnings when they are freed later.

Currently a fixed-size array of 8192 entries is used, with a warning if
the limit is exceeded. However, the number of early allocations depends
on the number of CPUs and can be larger than 8192.

Replace the fixed-size array with a dynamically allocated linked list.
Each page is carved into early_pfn_node entries and the remainder is
kept as a freelist for subsequent allocations.

The list nodes themselves are allocated via alloc_page(), which would
trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() ->
alloc_early_pfn_node() and recurse indefinitely.  Introduce
__GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT bit) and pass
gfp_flags through pgalloc_tag_add() so that the early path can skip
recording allocations that carry this flag.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v2:
- Use cmpxchg to atomically update early_pfn_pages, preventing page leak under concurrent allocation
- Pass gfp_flags through the full call chain and use gfpflags_allow_blocking()
  to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in process context
---
 include/linux/alloc_tag.h |  22 +++++++-
 lib/alloc_tag.c           | 102 ++++++++++++++++++++++++++------------
 mm/page_alloc.c           |  29 +++++++----
 3 files changed, 108 insertions(+), 45 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..2fa695bd3c53 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 }
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+/*
+ * Skip early PFN recording for a page allocation.  Reuses the
+ * %__GFP_NO_OBJ_EXT bit.  Used by alloc_early_pfn_node() to avoid
+ * recursion when allocating pages for the early PFN tracking list
+ * itself.
+ *
+ * Callers must set the codetag to CODETAG_EMPTY (via
+ * clear_page_tag_ref()) before freeing pages allocated with this
+ * flag once page_ext becomes available, otherwise
+ * alloc_tag_sub_check() will trigger a warning.
+ */
+#define __GFP_NO_CODETAG	__GFP_NO_OBJ_EXT
+
+static inline bool should_record_early_pfn(gfp_t gfp_flags)
+{
+	return !(gfp_flags & __GFP_NO_CODETAG);
+}
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag)
 {
 	WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
@@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
 {
 	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
 }
-void alloc_tag_add_early_pfn(unsigned long pfn);
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
 #else
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
-static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
+static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
+static inline bool should_record_early_pfn(gfp_t gfp_flags) { return true; }
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..cfc68e397eba 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -766,45 +766,75 @@ static __init bool need_page_alloc_tagging(void)
  * Some pages are allocated before page_ext becomes available, leaving
  * their codetag uninitialized. Track these early PFNs so we can clear
  * their codetag refs later to avoid warnings when they are freed.
- *
- * Early allocations include:
- *   - Base allocations independent of CPU count
- *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
- *     such as trace ring buffers, scheduler per-cpu data)
- *
- * For simplicity, we fix the size to 8192.
- * If insufficient, a warning will be triggered to alert the user.
- *
- * TODO: Replace fixed-size array with dynamic allocation using
- * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
  */
-#define EARLY_ALLOC_PFN_MAX		8192
+struct early_pfn_node {
+	struct early_pfn_node	*next;
+	unsigned long		pfn;
+};
+
+#define NODES_PER_PAGE		(PAGE_SIZE / sizeof(struct early_pfn_node))
 
-static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
-static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+static struct early_pfn_node *early_pfn_list __initdata;
+static struct early_pfn_node *early_pfn_freelist __initdata;
+static struct page *early_pfn_pages __initdata;
 
-static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+static struct early_pfn_node *__init alloc_early_pfn_node(gfp_t gfp_flags)
 {
-	int old_idx, new_idx;
+	struct early_pfn_node *ep, *new;
+	struct page *page, *old_page;
+	gfp_t gfp = gfpflags_allow_blocking(gfp_flags) ? GFP_KERNEL : GFP_ATOMIC;
+	int i;
+
+retry:
+	ep = READ_ONCE(early_pfn_freelist);
+	if (ep) {
+		struct early_pfn_node *next = READ_ONCE(ep->next);
+
+		if (try_cmpxchg(&early_pfn_freelist, &ep, next))
+			return ep;
+		goto retry;
+	}
+
+	page = alloc_page(gfp | __GFP_NO_CODETAG | __GFP_ZERO);
+	if (!page)
+		return NULL;
+
+	new = page_address(page);
+	for (i = 0; i < NODES_PER_PAGE - 1; i++)
+		new[i].next = &new[i + 1];
+	new[NODES_PER_PAGE - 1].next = NULL;
+
+	if (cmpxchg(&early_pfn_freelist, NULL, new + 1)) {
+		__free_page(page);
+		goto retry;
+	}
 
 	do {
-		old_idx = atomic_read(&early_pfn_count);
-		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
-			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
-				      EARLY_ALLOC_PFN_MAX);
-			return;
-		}
-		new_idx = old_idx + 1;
-	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+		old_page = READ_ONCE(early_pfn_pages);
+		page->private = (unsigned long)old_page;
+	} while (cmpxchg(&early_pfn_pages, old_page, page) != old_page);
+
+	return new;
+}
+
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
+{
+	struct early_pfn_node *ep = alloc_early_pfn_node(gfp_flags);
 
-	early_pfns[old_idx] = pfn;
+	if (!ep)
+		return;
+
+	ep->pfn = pfn;
+	do {
+		ep->next = READ_ONCE(early_pfn_list);
+	} while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
 }
 
-typedef void alloc_tag_add_func(unsigned long pfn);
+typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn)
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
@@ -814,13 +844,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
 	rcu_read_lock();
 	alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
 	if (alloc_tag_add)
-		alloc_tag_add(pfn);
+		alloc_tag_add(pfn, gfp_flags);
 	rcu_read_unlock();
 }
 
 static void __init clear_early_alloc_pfn_tag_refs(void)
 {
-	unsigned int i;
+	struct early_pfn_node *ep;
+	struct page *page, *next;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
@@ -829,14 +860,13 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
 	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
 	synchronize_rcu();
 
-	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
-		unsigned long pfn = early_pfns[i];
+	for (ep = early_pfn_list; ep; ep = ep->next) {
 
-		if (pfn_valid(pfn)) {
-			struct page *page = pfn_to_page(pfn);
+		if (pfn_valid(ep->pfn)) {
 			union pgtag_ref_handle handle;
 			union codetag_ref ref;
 
+			page = pfn_to_page(ep->pfn);
 			if (get_page_tag_ref(page, &ref, &handle)) {
 				/*
 				 * An early-allocated page could be freed and reallocated
@@ -861,6 +891,12 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
 		}
 
 	}
+
+	for (page = early_pfn_pages; page; page = next) {
+		next = (struct page *)page->private;
+		clear_page_tag_ref(page);
+		__free_page(page);
+	}
 }
 #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 04494bc2e46f..4e2bfb3714e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline
 void __pgalloc_tag_add(struct page *page, struct task_struct *task,
-		       unsigned int nr)
+		       unsigned int nr, gfp_t gfp_flags)
 {
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
@@ -1294,21 +1294,30 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	} else {
-		/*
-		 * page_ext is not available yet, record the pfn so we can
-		 * clear the tag ref later when page_ext is initialized.
-		 */
-		alloc_tag_add_early_pfn(page_to_pfn(page));
+
 		if (task->alloc_tag)
 			alloc_tag_set_inaccurate(task->alloc_tag);
+
+		/*
+		 * page_ext is not available yet, skip if this allocation
+		 * doesn't need early PFN recording.
+		 */
+		if (unlikely(!should_record_early_pfn(gfp_flags)))
+			return;
+
+		/*
+		 * Record the pfn so the tag ref can be cleared later
+		 * when page_ext is initialized.
+		 */
+		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
 	}
 }
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr)
+				   unsigned int nr, gfp_t gfp_flags)
 {
 	if (mem_alloc_profiling_enabled())
-		__pgalloc_tag_add(page, task, nr);
+		__pgalloc_tag_add(page, task, nr, gfp_flags);
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -1341,7 +1350,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
+				   unsigned int nr, gfp_t gfp_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
@@ -1896,7 +1905,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order);
+	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-- 
2.25.1


