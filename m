Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0CEFF887E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 02:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2156B0088; Wed, 29 Apr 2026 22:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B638A6B008A; Wed, 29 Apr 2026 22:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79646B008C; Wed, 29 Apr 2026 22:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94F7D6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:03:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C91BC16F4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:03:32 +0000 (UTC)
X-FDA: 84713575464.19.975F9E4
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A15420005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:03:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+5b6ZCO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777514610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jBjOhy4vbPk+zkFBeD0N8/BCuvoOkuEh9pEeJPxFitc=;
	b=xqic+DpI8Y7+p3SePxeQvxv4korXGoTfpMJd1DGSx5BT5v7axlawbNSshYa3GB6hiYQgI/
	lDxUufO51o+7q4U9ZMz56hejbGELc6aGstUrZjrvijC0ovgdCvooC945RicgatZvmhLp9a
	VxpiOYMd2lvPtwk4dnLb8mukrndiETM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777514610; a=rsa-sha256;
	cv=none;
	b=R6Cwi5Ro91KYbcazZ30c6h0ob68hwmokPbu2CBpPFbisKbz3Ziu2AUIP1PUfKeraA2F9OM
	jDLfEJNinaBQ2IQ/1edFo3GWAttYwZCgDtGOYU8+22UpkKptTmHBVx4qSTrndY0G4Rk3xS
	VXWi+v5nENrPkEju0NY/h+HM1jzRtUk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a+5b6ZCO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777514604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jBjOhy4vbPk+zkFBeD0N8/BCuvoOkuEh9pEeJPxFitc=;
	b=a+5b6ZCONotkeRd5Oc8HyceFbLAAuGJT/p6PXBkU/7+zFIJqQndKCOcjOSORc4XG/gu0iq
	tD2676B7YUUtKzxM6fPqVITaTKjVDd+H5Gik8qudZjd/Pj+LzQCMoga4hx14KrarhJvAEA
	TFFJJhTb7rzW8Gl2Bh/bMMghsQLKZbg=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4] mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Thu, 30 Apr 2026 10:02:26 +0800
Message-Id: <20260430020226.34116-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A15420005
X-Stat-Signature: nezda8e1y7nrci7zqqniyodf3hzyeqc5
X-Rspam-User: 
X-HE-Tag: 1777514608-468377
X-HE-Meta: U2FsdGVkX1/ztdtTFgCi7G3R0W6MextrrZTUfU3lJxvQs07mh8XymJ+tUJ/iqoON52rkkTQl93B4XRK52knciDmZBr/EDKC8MVwglGXHvwHN8ZQ7Ej0QDa8uwwjsZtzQF3jYIEl9LiqpU7gSzW0NoF4larKKwk0qvqa4yfOScrlXghtL1H0EBg0X8HqB1ijqSSHd1a+WXmKrNLmu2gdmylo9d5le60ivUquv0yJT6jjzbiYbf78sTDWYlO34foCMxQBbQxZcAIH9VbWEruhQx90mZ9jea0rOjLUv0im/A0hH3CtssYa0C1HqYchu22LXdYZYZuCdmjjJ/eUZAgmyzMvBFyOz9xm/cWNxdLPJVi/cVsEfQ+KDTJed9ZY/CmC9X50JbLe/RDduVsh511nj5IrI1q9DYRH4Btumv0S1Z5lABdfljQbjCiEihn8JXi6OJUbn8vUnDtpNHLcu3Mq3R0Sef0Wqthl4QSGCDTi7IZOke+IQxvUAEcxwddJpXTl3Bo8K20MAamsm3C0RQVNVL+7Q6NcNZZmx6Io/wPgyIcsj1wkanphyPWV7TJVCyfSJzgF1yBUfj9vH3wygNPj+5HsAlqQfSecAfuESjRfTWWZrqYK9rId6CVGJMXHJBWmhAEUaP99NJHNITobOEQtqiD+cDVzB1spYkrxZkxzGOb3tayRbvgWqjhb+6TSTAffzcRw2EwOOrQFi3v/ZH2eDSr6ZNjpwhPwMT9JiPbFWvUFdd+iA275gseAQrHbUagdRS7xVlMVzNOIYbSeEFXnCf6LqQ5mlyD99cmF9vA3YpMy865IaidD4ZCsh5VSHYfhSe2wJ/vjNH/wswMk+JzyUZtluZCMoWJtRwhl8Izfg3ojrIFJZWSFnVpmjCgKMO7vKjpThXfDe439eBMZxsjMYVodvcoDJi3Us4Q7ZpV/W1Ge1vhyhvOXUfNKiy1zvlU9uLharF167dHzzXyvef8A
 Pm79ffqT
 QtXx+OlfuES8cVagPv0HVCQpRkW3ClT/m6LhH7iyihnUShZF2Ob8PmuAPaVOgPubYq5oSIRO8GFd8ujVgZiKu5u85FeyyK5Fo792zGgfAa83k2Kg+O/hgrLhhK/nm9muAAly/4VH/siXTQB3C1Ui/LJpbq/opugeioPM1RbU6h8TdKqwdZ/Zw10BfF2kH0CJ/FlwP/2clg+KZ5PzUXdZ+X531GMsEx5Z5dpIdWZxvhkukHOwOlmmy3y6T7Vnif/snKs+CQkdKKNf8p9w=
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

Replace the fixed-size array with a dynamically allocated linked list
of pfn_pool structs. Each node is allocated via alloc_page() and mapped
to a pfn_pool containing a next pointer, an atomic slot counter, and a
PFN array that fills the remainder of the page.

The tracking pages themselves are allocated via alloc_page(), which
would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
%__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
so that the early path can skip recording allocations that carry this
flag.

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v4:
- Use struct pfn_pool with named fields (next, atomic_t count, pfns[]) mapped
  onto the page body, replacing the page->lru/page->private approach
  (suggested by Suren Baghdasaryan)

v3:
- Simplify linked list: use page->lru for chaining and page->private as
  slot counter, removing the early_pfn_node struct and freelist (suggested
  by Suren Baghdasaryan)
- Pass gfp_flags through alloc_tag_add_early_pfn() but strip
  __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
  because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock().

v2:
- Use cmpxchg to atomically update early_pfn_pages, preventing page leak under concurrent allocation
- Pass gfp_flags through the full call chain and use gfpflags_allow_blocking()
  to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in process context
---
 include/linux/alloc_tag.h |   4 +-
 lib/alloc_tag.c           | 145 ++++++++++++++++++++++++--------------
 mm/page_alloc.c           |  12 ++--
 3 files changed, 101 insertions(+), 60 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..068ba2e77c5d 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
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
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..117f14e7654b 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -767,60 +767,95 @@ static __init bool need_page_alloc_tagging(void)
  * their codetag uninitialized. Track these early PFNs so we can clear
  * their codetag refs later to avoid warnings when they are freed.
  *
- * Early allocations include:
- *   - Base allocations independent of CPU count
- *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
- *     such as trace ring buffers, scheduler per-cpu data)
- *
- * For simplicity, we fix the size to 8192.
- * If insufficient, a warning will be triggered to alert the user.
+ * Each page is cast to a pfn_pool: the first few bytes hold metadata
+ * (next pointer and slot count), the remainder stores PFNs.
+ */
+struct pfn_pool {
+	struct pfn_pool *next;
+	atomic_t count;
+	unsigned long pfns[];
+};
+
+#define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
+					 sizeof(unsigned long))
+
+/*
+ * Skip early PFN recording for a page allocation.  Reuses the
+ * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
+ * recursion when allocating pages for the early PFN tracking list
+ * itself.
  *
- * TODO: Replace fixed-size array with dynamic allocation using
- * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
+ * Codetags of the pages allocated with __GFP_NO_CODETAG should be
+ * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
+ * alloc_tag_sub_check() from triggering a warning.
  */
-#define EARLY_ALLOC_PFN_MAX		8192
+#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
 
-static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
-static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+static struct pfn_pool *current_pfn_pool __initdata;
 
-static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
-	int old_idx, new_idx;
+	struct pfn_pool *pool;
+	int idx;
 
 	do {
-		old_idx = atomic_read(&early_pfn_count);
-		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
-			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
-				      EARLY_ALLOC_PFN_MAX);
-			return;
+		pool = READ_ONCE(current_pfn_pool);
+		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
+			gfp_t gfp = gfp_flags & ~__GFP_DIRECT_RECLAIM;
+			struct page *new_page = alloc_page(gfp | __GFP_NO_CODETAG);
+			struct pfn_pool *new;
+
+			if (!new_page) {
+				pr_warn_once("early PFN tracking page allocation failed\n");
+				return;
+			}
+			new = page_address(new_page);
+			new->next = pool;
+			atomic_set(&new->count, 0);
+			if (cmpxchg(&current_pfn_pool, pool, new) != pool) {
+				clear_page_tag_ref(new_page);
+				__free_page(new_page);
+				continue;
+			}
+			pool = new;
 		}
-		new_idx = old_idx + 1;
-	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+		idx = atomic_read(&pool->count);
+		if (idx >= PFN_POOL_SIZE)
+			continue;
+		if (atomic_cmpxchg(&pool->count, idx, idx + 1) == idx)
+			break;
+	} while (1);
 
-	early_pfns[old_idx] = pfn;
+	pool->pfns[idx] = pfn;
 }
 
-typedef void alloc_tag_add_func(unsigned long pfn);
+typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn)
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
 
+	/* Skip allocations for the tracking list itself to avoid recursion. */
+	if (gfp_flags & __GFP_NO_CODETAG)
+		return;
+
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
+	struct pfn_pool *pool, *next;
+	struct page *page;
+	int i;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
@@ -829,37 +864,43 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
 	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
 	synchronize_rcu();
 
-	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
-		unsigned long pfn = early_pfns[i];
-
-		if (pfn_valid(pfn)) {
-			struct page *page = pfn_to_page(pfn);
-			union pgtag_ref_handle handle;
-			union codetag_ref ref;
-
-			if (get_page_tag_ref(page, &ref, &handle)) {
-				/*
-				 * An early-allocated page could be freed and reallocated
-				 * after its page_ext is initialized but before we clear it.
-				 * In that case, it already has a valid tag set.
-				 * We should not overwrite that valid tag with CODETAG_EMPTY.
-				 *
-				 * Note: there is still a small race window between checking
-				 * ref.ct and calling set_codetag_empty(). We accept this
-				 * race as it's unlikely and the extra complexity of atomic
-				 * cmpxchg is not worth it for this debug-only code path.
-				 */
-				if (ref.ct) {
+	for (pool = current_pfn_pool; pool; pool = next) {
+		for (i = 0; i < atomic_read(&pool->count); i++) {
+			unsigned long pfn = pool->pfns[i];
+
+			if (pfn_valid(pfn)) {
+				union pgtag_ref_handle handle;
+				union codetag_ref ref;
+
+				if (get_page_tag_ref(pfn_to_page(pfn), &ref, &handle)) {
+					/*
+					 * An early-allocated page could be freed and reallocated
+					 * after its page_ext is initialized but before we clear it.
+					 * In that case, it already has a valid tag set.
+					 * We should not overwrite that valid tag
+					 * with CODETAG_EMPTY.
+					 *
+					 * Note: there is still a small race window between checking
+					 * ref.ct and calling set_codetag_empty(). We accept this
+					 * race as it's unlikely and the extra complexity of atomic
+					 * cmpxchg is not worth it for this debug-only code path.
+					 */
+					if (ref.ct) {
+						put_page_tag_ref(handle);
+						continue;
+					}
+
+					set_codetag_empty(&ref);
+					update_page_tag_ref(handle, &ref);
 					put_page_tag_ref(handle);
-					continue;
 				}
-
-				set_codetag_empty(&ref);
-				update_page_tag_ref(handle, &ref);
-				put_page_tag_ref(handle);
 			}
 		}
 
+		next = pool->next;
+		page = virt_to_page(pool);
+		clear_page_tag_ref(page);
+		__free_page(page);
 	}
 }
 #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 04494bc2e46f..819d44ffd470 100644
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
@@ -1298,17 +1298,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 		 * page_ext is not available yet, record the pfn so we can
 		 * clear the tag ref later when page_ext is initialized.
 		 */
-		alloc_tag_add_early_pfn(page_to_pfn(page));
+		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
 		if (task->alloc_tag)
 			alloc_tag_set_inaccurate(task->alloc_tag);
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
@@ -1341,7 +1341,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
+				   unsigned int nr, gfp_t gfp_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
@@ -1896,7 +1896,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order);
+	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-- 
2.25.1


