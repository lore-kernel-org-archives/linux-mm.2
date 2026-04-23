Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4066AF99351
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 08:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807146B0005; Thu, 23 Apr 2026 04:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7906B008A; Thu, 23 Apr 2026 04:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD596B008C; Thu, 23 Apr 2026 04:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3466B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:39:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8305A03F5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:39:04 +0000 (UTC)
X-FDA: 84689170608.29.A914A87
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3934716000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:39:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7voICcS;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776933543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VD0W+tCYZmHWC9HJnyoCOcXw/2dXEeLu7QPWcZVXPyw=;
	b=NTr/5A6GBIUOg+o9vXAE4ESA9VFVj8mBMJyELKRfphBjgL5UezrP6RQUaqSYfPb3ihvGd0
	mTrpGFzEBzq7QPld5noUzboOFcbRxm5gBzCLuYdR+k5PwhulNIyv1vHZBn7cWBXMCQtuJX
	er+LOUUyJ63A0xLhDjFaeW2syKAY85I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776933543; a=rsa-sha256;
	cv=none;
	b=lT9t7OCY8ggLBTeTQh9fopV8Yom/QuE7htU+3dit/qAv6m9hSjvaoi7oBm+EMMFHsOFvxe
	oJCM4WBMpx8hbLEvNILbIOhgTtDz1vNXZD3Cufn/NvqCuxFfb098xrwMYmWprblUdQJJ3l
	2NPrBK0btj05xJv7J67AlslWmcfkTo0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R7voICcS;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776933541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VD0W+tCYZmHWC9HJnyoCOcXw/2dXEeLu7QPWcZVXPyw=;
	b=R7voICcSziXE7s3YFImlsU0PG7tT+d795NPpl7UoybcuacO3fhnZjlx3F1CpuhStcRVAik
	yYh9Wx1mo5BqTGt+uYgqfsQjU3MVXBMH2Lk4fkAhlb8nb0kiH/QDA/fuby0EK+P5c+DD1P
	8zt3TUj/dAZMraNNkY9ycPbbS/CWm/4=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Thu, 23 Apr 2026 16:37:56 +0800
Message-Id: <20260423083756.157902-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3934716000B
X-Rspamd-Server: rspam07
X-Stat-Signature: g5z9fjhpih8ezm61zn1t4ry45o56diby
X-Rspam-User: 
X-HE-Tag: 1776933542-949812
X-HE-Meta: U2FsdGVkX19yV37DrRAnLZE+uCS/HlwPYjg3ml2BBgqdbkhcgu+76i9KjAjivHohSzKdhXl74YBxyvYzgXkEKKV/oAvzlRHNcuPRpyqPXBpogXNY7TSG8SpbgIfzNxfPKTrnf2K8JXBKaDtd0FdKyG5AB2hwfDhVNp0NqKX7bWwfy0HcISITbrDc+l04tqR70aalHQuSIVDfhG1vRU7MIAbuVS70jqX7Fsd66yhmlLn5puq2se8smqIlMpBgteejXwjmsKWBH6llZZi51M+6rrlpl7kBOa2a/DLCu/oIHihTp1hOrzaTzDVs8Lh9B//NkIxMvmMZoX2vcfgluaF8rPUxiMvEhcRb9yB+QnRvlQewMo/YdMjBwyVOikknRjijzncmsIwBdG+x1lMwCR1H/kawfGa/vtSbMeE9A60S0ygFl84NuMLGGaxKriGCJwiJz8AWJxn0w5KJDOpzjesPOnRxyAbDng90jKMGbhfiGOPYzaXFevMxuZpkSFK09SdS+7gVEu1xQYCpoSIevg/VEfLWpbLQMEbaSD+0RbxWz+lE8OuFzlP9kLIHefU7Tizk3QgfzVjUtpGSFO7A1vrM6mBCfs4SSyrhpRFSjqNmjVknJHaTzVqPyjiRz39p7qjgVhy7G8Fi2Agg2riBZM1eqRh3rrS9omK608qTAuEaHGm3ShHXZJUJqbOLO4/bm54o2UtCAWXXGf767/u1mR97UeVfAwCGDANvn3HqZdDJXeyYFzN9AxKHkaahxr1Ugd07jjd5qXeFnqfYFaELNwjbv0KlWQyWOMo9fN0IOUY1AKHWnzbT2ECy1y38Za/gmscYWXi70vD/T+sbESp1Jklw/G7OHYnfT0fqRb5hKVIaXFyIGoTwSzr3iJi/lgwz78S+Eb+erM+IBZDSV6MsnCi8BwMpmNn6LM2sd7ozxwEwk8P4biIp7O2rSgpcNxzbFdgcyw8ourTxU8P33vdZb99
 K0JBevnr
 MWC1XWL6iSMfzBQP0ssF1Yj1V5BJPdEB81I1P5qsJ85/el8ZJFzni5zmmgERdWgiebRXKmoLZTKrJwHLJAGSuK0H5hK654N9Hd9oXrAbYv80RurgKhUXMc/AM9/T6zSeBYLAMGusLxXBcNiQtaS2V5oxAwTKQt5e7M8UDR07dGaUmsN4XV3F626O1Hade2xUWB90IeUm5BPKsfIw=
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
of pages. Each page stores PFNs in its page body and uses page->lru
to link to the next page, with page->private tracking the number of
used slots.

The list pages themselves are allocated via alloc_page(), which would
trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
can skip recording allocations that carry this flag.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
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
 include/linux/alloc_tag.h |  22 ++++++-
 lib/alloc_tag.c           | 118 +++++++++++++++++++++-----------------
 mm/page_alloc.c           |  23 ++++----
 3 files changed, 97 insertions(+), 66 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..ce9b478033bf 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 }
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+/*
+ * Skip early PFN recording for a page allocation.  Reuses the
+ * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
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
+static inline bool should_record_early_pfn(gfp_t gfp_flags) { return false; }
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..a00dc5a867e4 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(void)
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
+#define EARLY_PFNS_PER_PAGE		(PAGE_SIZE / sizeof(unsigned long))
 
-static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
-static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+static struct page *early_pfn_current __initdata;
 
-static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
-	int old_idx, new_idx;
+	struct page *page;
+	unsigned long idx;
 
 	do {
-		old_idx = atomic_read(&early_pfn_count);
-		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
-			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
-				      EARLY_ALLOC_PFN_MAX);
-			return;
+		page = READ_ONCE(early_pfn_current);
+		if (!page || READ_ONCE(page->private) >= EARLY_PFNS_PER_PAGE) {
+			gfp_t gfp = gfp_flags & ~__GFP_DIRECT_RECLAIM;
+			struct page *new = alloc_page(gfp | __GFP_NO_CODETAG);
+
+			if (!new) {
+				pr_warn_once("early PFN tracking page allocation failed\n");
+				return;
+			}
+			new->lru.next = (struct list_head *)page;
+			if (cmpxchg(&early_pfn_current, page, new) != page) {
+				__free_page(new);
+				continue;
+			}
+			page = new;
 		}
-		new_idx = old_idx + 1;
-	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+		idx = READ_ONCE(page->private);
+		if (idx >= EARLY_PFNS_PER_PAGE)
+			continue;
+		if (cmpxchg(&page->private, idx, idx + 1) != idx)
+			continue;
+		break;
+	} while (1);
 
-	early_pfns[old_idx] = pfn;
+	((unsigned long *)page_address(page))[idx] = pfn;
 }
 
-typedef void alloc_tag_add_func(unsigned long pfn);
+typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn)
+void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
@@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
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
+	struct page *page, *next;
+	unsigned long i;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
@@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
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
+	for (page = early_pfn_current; page; page = next) {
+		for (i = 0; i < page->private; i++) {
+			unsigned long pfn = ((unsigned long *)page_address(page))[i];
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
 
+		next = (struct page *)page->lru.next;
+		clear_page_tag_ref(page);
+		__free_page(page);
 	}
 }
 #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 04494bc2e46f..5b7b234967a5 100644
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
@@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
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
+		 * page_ext is not available yet, record the pfn so the
+		 * tag ref can be cleared later when page_ext is initialized.
+		 */
+		if (should_record_early_pfn(gfp_flags))
+			alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
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
@@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
+				   unsigned int nr, gfp_t gfp_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
@@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order);
+	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-- 
2.25.1


