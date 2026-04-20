Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 374BBF588DC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727746B0005; Mon, 20 Apr 2026 10:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8EE6B0088; Mon, 20 Apr 2026 10:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE616B0089; Mon, 20 Apr 2026 10:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEC56B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:16:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 556C51A096F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:16:39 +0000 (UTC)
X-FDA: 84679134918.26.EFB8A1C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 627FD40016
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:16:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JnZoIHzH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694597; a=rsa-sha256;
	cv=none;
	b=l1v0QVTW2V39Lod8Sbmk7o/6nSqJSDYursbYYZ75X95VKS1iivIGwgMdi2SDz0VhEDYlox
	nR8MMd/i72hjK2iAPNhJuEqTwMR0E5z/uikmNQ1TBQgzSmKv1QOOtGDiCIQ1rGmXtHbXR8
	LLvRo6MbQFkg0UhypCIURIaUwzfjMII=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JnZoIHzH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TTlikDogw7UwTtdhEVyGrjLzE4DL6569lusdJfrE8Uc=;
	b=pS4xUBW9sNrXPrl72l92K/VJ5UHZH2oi5JCsbYjiG7xbfRNj2+GfPtVm8vGxUKn7NhGTU/
	mpOh/LVXnHVYl3Hh0gu7L14zDj/3JByjVTarkMhecEOEG61Im/S8oM5f+5JtkKiX7fKVcI
	t38CGHEi7LJZqwViDa82i7LxDOjnH/Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776694594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TTlikDogw7UwTtdhEVyGrjLzE4DL6569lusdJfrE8Uc=;
	b=JnZoIHzHdTXwbns7zGl5mN+5vA9Ew4wQGGpJYaGtXQquxHAQDvhfQ8GCCpS73xO1Chg7mr
	AI1zMhqVgxTInrU/S5u6mTDAjp0D729871jeqOaPUWAcEAUvWLWDl/s5+IhbOBrPXOPNu+
	N4m5rYvv2y8MulxdcCLGUB3EykhgF+M=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Mon, 20 Apr 2026 22:15:34 +0800
Message-Id: <20260420141534.1009462-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 627FD40016
X-Rspamd-Server: rspam12
X-Stat-Signature: dmh3d77gfzin9y6bwipjag3ff1rab6em
X-Rspam-User: 
X-HE-Tag: 1776694597-47203
X-HE-Meta: U2FsdGVkX19h8zt2UQxaqlU9dRn/eziUzpNpWcQzQ0v1OYfeVs50xWe1eIuLTIS4phuJLQW5by9DFKXf7uhxffU7qu2T5NgL/MWkFPVe5Yh3hVSXe6Nkrjzm8HmXeHZesRdD7MqEYkiiJfdsEuN033ZTM5DmNRu+ZSbFGZy2yaU+QrqcVuqnRbtOl/6fMFKY5IETWzc00uVg4jC8J65MouCwCB0G24h21x2fHtizYRPprYX/jvBJ3rg3KLwJmigZ98NOo1sfh8wFnvtNMToyQdX5+8kNaMVHVUmEIrx7YpZYtTtIZP4BkPJ9SUg/ogTDAGzOGPAZMF9lkxp4u0mqu9iqNU5cB/gnTqFTa/gVywkweeS3+tB9ZxH8G2b+3CgD9EA4ei/PI6d+a49xcfJsMRmXquAXj2jBCN7mplVY2SFOrJT6+PsY37+S3Jk4ZctyWCSsSVqBLbycqqcAUPMNa1QV3hVTH53sDjN6hBrxHrkjwWxq96qUBdRhX5KK0XtNHWc6HE9D+lW5yGyAgprfKbfX2E0xa825qt8GOhYGB+x3UJMjo/rUuUFtt1qzTiW4lhn9q+ixmBOkDjM1NvyOBNWttnhywQLf/LBnGwoDKDoXE4zK8dFas+4VRZ/q1gsSdZBoSxDan0f3f8sHNrKcaenmlxuVAKIgWT8rZm4+4WOlo3lk1A+IuQ36UDQ3/wziop6qlULIG5/xcB7thy1LK4EqfFs1NmJt2hkjq+JrAqff7GKpZK+dR4vANCriiRupurCX3Nf3VjyAQbtmQ4DvEcM+z/OdLMeH3EZ3IOYOWRhzkIwDMxcVYz2EZAm+IPscB9pCjBkS4qBpWQMBWZ3ks8QsOhgeJwdjcvCJ3ctSUXNjFm1xy+l2gzHpo0m2BQS30sQEqDCK/Ex6mUJT2hwCB+yMhqPozPvuEwY3sNbeYyZKyAIZGYcqULEuTADAW/ddAIR6L3pXndSoseOkOJu
 PKwAVHGH
 OH4D5H/RN0QR8k3xsX/Drugc0znz8KunlGf1cemwh12OgGQ1T5CRFVTbIETIQZ5gPVByE3kXOrqeE+zQ3q7fVEbsSrgePToeGEghsz4nNeRNgIna7LajbPJdvR5Esf1krxI+WIFqy/DPs0CP3IihflWvwmXp4fYGr8UqDswTGDNxu01jJXG5nLzrB0qJA9QDWcZ9yBRDDoRkz35IB/PWd5v4XDL73o/ODrCoWhYmzB77TCZ/O7Geqp00z4A==
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
__GFP_NO_CODETAG (aliased to __GFP_NO_OBJ_EXT) and pass gfp_flags
through pgalloc_tag_add() so that the early path can skip recording
allocations that carry this flag.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/alloc_tag.h | 18 ++++++++
 lib/alloc_tag.c           | 91 ++++++++++++++++++++++++++-------------
 mm/page_alloc.c           | 27 ++++++++----
 3 files changed, 97 insertions(+), 39 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..25374e40e14b 100644
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
@@ -168,6 +185,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn);
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
 static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
+static inline bool should_record_early_pfn(gfp_t gfp_flags) { return true; }
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..6dd6c2966afd 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -766,38 +766,63 @@ static __init bool need_page_alloc_tagging(void)
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
+
+static struct early_pfn_node *early_pfn_list __initdata;
+static struct early_pfn_node *early_pfn_freelist __initdata;
+static struct page *early_pfn_pages __initdata;
 
-static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
-static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+static struct early_pfn_node *__init alloc_early_pfn_node(void)
+{
+	struct early_pfn_node *ep, *old;
+	struct page *page;
+	int i;
+
+retry:
+	old = READ_ONCE(early_pfn_freelist);
+	if (old) {
+		if (try_cmpxchg(&early_pfn_freelist, &old, old->next))
+			return old;
+		goto retry;
+	}
+
+	page = alloc_page(GFP_ATOMIC | __GFP_NO_CODETAG | __GFP_ZERO);
+	if (!page)
+		return NULL;
+
+	ep = page_address(page);
+	for (i = 0; i < NODES_PER_PAGE - 1; i++)
+		ep[i].next = &ep[i + 1];
+	ep[NODES_PER_PAGE - 1].next = NULL;
+
+	if (cmpxchg(&early_pfn_freelist, NULL, ep + 1)) {
+		__free_page(page);
+		goto retry;
+	}
+
+	page->private = (unsigned long)early_pfn_pages;
+	early_pfn_pages = page;
+
+	return ep;
+}
 
 static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
 {
-	int old_idx, new_idx;
+	struct early_pfn_node *ep = alloc_early_pfn_node();
 
-	do {
-		old_idx = atomic_read(&early_pfn_count);
-		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
-			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
-				      EARLY_ALLOC_PFN_MAX);
-			return;
-		}
-		new_idx = old_idx + 1;
-	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+	if (!ep)
+		return;
 
-	early_pfns[old_idx] = pfn;
+	ep->pfn = pfn;
+	do {
+		ep->next = READ_ONCE(early_pfn_list);
+	} while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
 }
 
 typedef void alloc_tag_add_func(unsigned long pfn);
@@ -820,7 +845,8 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
 
 static void __init clear_early_alloc_pfn_tag_refs(void)
 {
-	unsigned int i;
+	struct early_pfn_node *ep;
+	struct page *page, *next;
 
 	if (static_key_enabled(&mem_profiling_compressed))
 		return;
@@ -829,14 +855,13 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
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
@@ -861,6 +886,12 @@ static void __init clear_early_alloc_pfn_tag_refs(void)
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
index 04494bc2e46f..3033ab93fd3c 100644
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
+
+		if (task->alloc_tag)
+			alloc_tag_set_inaccurate(task->alloc_tag);
+
+		/*
+		 * page_ext is not available yet, skip if this allocation
+		 * doesn't need early PFN recording.
+		 */
+		if (unlikely(!should_record_early_pfn(gfp_flags)))
+			return;
+
 		/*
-		 * page_ext is not available yet, record the pfn so we can
-		 * clear the tag ref later when page_ext is initialized.
+		 * Record the pfn so the tag ref can be cleared later
+		 * when page_ext is initialized.
 		 */
 		alloc_tag_add_early_pfn(page_to_pfn(page));
-		if (task->alloc_tag)
-			alloc_tag_set_inaccurate(task->alloc_tag);
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


