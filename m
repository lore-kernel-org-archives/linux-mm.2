Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2595CD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EED6B008A; Tue, 26 May 2026 22:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFEB6B008C; Tue, 26 May 2026 22:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5E26B0092; Tue, 26 May 2026 22:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2111F6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:00:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C62191204B2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:00:18 +0000 (UTC)
X-FDA: 84811544916.09.6BC61D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2F02D20007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:00:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ovXBI6VV;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779847217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvuY7ED/S6B1eYCY5xunlzXNuzNJ8ZMZtbLxCujO8iU=;
	b=PVabRYC2wNmNkT30/qCevCyrsmBDYl3R00Y7u+YLqH0n5YNVUhxa9CyQQfrN1GFolpSrnM
	hYXIKkGzZ8SKCJZLLAKVNFRC3zUgXWsS3MahKCHC7PUBgfRDSFljOIzZC0jfbj3ZvL2eSP
	ltpUISPPjdaMERrFCLnXoQ310fdTNM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779847217; a=rsa-sha256;
	cv=none;
	b=qAPJYMIjSZpr+7EYWayZWYGOiPf4VfuXx5jUve2cCiIPABWp6Jx9AZ2qY1Q4UzSZkvvicb
	fV+DOEV0sByFWsapHFg6qeIv+lpyPdAzjYqZ8er50IRITuykZMbGgsttMUWLf+xJbQMbiW
	j36fpXvjv5z640mbWoMJNSghkgbh5nw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ovXBI6VV;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64F1660018;
	Wed, 27 May 2026 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85A41F000E9;
	Wed, 27 May 2026 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779847216;
	bh=xvuY7ED/S6B1eYCY5xunlzXNuzNJ8ZMZtbLxCujO8iU=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=ovXBI6VVp01DCukqXInAJ5U9b5ZaPuah5Y/rJ9poZDBo8K660sf9mu42NrrV0rHIt
	 9g1AnrclHCsjQREHDKAm2ev7ASj63HKDQTZCNWfcJhJmR6qvzlGkiEvWuzK2/2NI7C
	 Jt5d++MTneDar3KvXU26pcggcdq0P7DgrztCdXRQ=
Date: Tue, 26 May 2026 19:00:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Kent
 Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/alloc_tag: replace fixed-size early PFN array
 with dynamic linked list
Message-Id: <20260526190015.d4edd406962fcc3a1ee4cb53@linux-foundation.org>
In-Reply-To: <20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
References: <20260506022256.32664-1-hao.ge@linux.dev>
	<20260508171251.9bfb5e833859090d4480e222@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ebnrbsqk9tyd6as9uh5j154bp7xo8z9t
X-Rspamd-Queue-Id: 2F02D20007
X-Rspam-User: 
X-HE-Tag: 1779847217-83612
X-HE-Meta: U2FsdGVkX19u1QeNZQt789gMKneaLUbkiHoDzvsKOkJjZGxtAEQILass7IyPNB0H1JwoBboJ+Z8FPlhVAQnuad1rCFuCbJAWlBwt0id80Blg5pjw6qS/eE78mpIJFooRx51IWgU69terCIhgV1jzLJcFuWCVl1briZKuoOcQZdRV2KflC7YNuv1jdUoAlGybtfr22ZCELPFwxZZM5nyECAHnVb8Fpx6usD4Zof0rLluAIMCY3hHFQZt0QkBHCNjNCOW6qiICZ1Vk0XZPlhc33bwoZkPYcIHJO27Lfg0sZJBur3ZI2dgwqom0J3N5vOrqzIMCh8Qt6qdTqYlejOTnP5nruMxVLmt8ZkAczMJLOBkYqjVvDI1tw7HM3tAFRA2JWhMeYoNwGsrwEM4X6/0tQ5HThUILpLZqVDZAAwoXWvGkM6kWTOg3eM4ZRvdqh2hWpQLPHFbpOqmryQCyoD8vgFzskw7zZczkCoaDFQXBSY5AII/8TlWmJhUvaAnzgXjuCMQFzGG2Y0AykykJ6gJrwKRiG4j8b8IJN/CazTFEN5VucuO/bEU0lOr0nF9X1SX1OIdussCOKON+lHJuCkKEwvYzhG/nSMHQfhEHX2BCA7nrvgl/gYZ9ML4mqwKfBbNMucxoLtAXGSWLbvxym+uQA7BJMNuDGXJZpbL3iUtRysHnMp1+cVfM4lBgcpAO6DUGUxOICvdcLEwXdlngpCqMWDjWi597RDAHnif7WwYzzH0h0UOk0SNu7zzGLN7AeX/rBasHEmUBsmlIR+cYZaRIIIpAUkV3Z7lsd9/5QuSd25yJWQH3HQUZ2ckO3mH1xnqSpA8JCZ7+2MdLv9JjqUaCof3n/cP67S1A94M9WSVzICQPQVF9siGM5zBPXo9cvCsf02E21CBwSLOkDMo9CiSuG+HjlZ+93XUTZ8gSIBh8xZK59xG66wvsPChyQOMuHERTGL+jWlHc+EaMvPqmBeo
 jWkHenaR
 pJJ9OH37R+g8455z5mhTnVg44jVsLP9QDwJiiHXU71y0Xk6BoqWmlDEtJsg+L6psEIT36OWW6dkjbQrUQ78IshDndIjp8wlS9QrNrBZXWa7UeP16ei/02vlAkhgaOqlbWFwIDh10+SeOQ2zt5snk8vODtxjf4F//E7wVLaxbabzVPuHUChsalCgALfyYlSd9PBB3PhFK71QfgA/tzh2c2Q79nly8kCL0zwI5CNTJGHxbluOzZzh3wiO1GOyA3urBMiGm828J34wrcUiwO54TZAHVd2jQMxrr86Q9wEo20RKl0VCgHciMiVhnNmnF3ocitLEn/o8OLkz6mGkpGERHxEpc/T0zII7uNngu7j7YwsdHYOXCmUXAxTUMdSRg+gxozgtlj7Y9JpmSFozh+qNrJu0J9B2MQYKBb8YJVjE8nrih8/lSYHrX1DeERJZH/6knkcRUHOdrP5b1ziAQ0amizvqoMhBld5cRxbfNkwdiQlL49QnT116QiHQW76gLtlsu7MYAc3IGepWcUvQlq1fhqqZfIvkr7T8ofTNlmBNWoiPk7Yg3uQQ1dqAiau20LEpVRThnmAjHJA3KHXThAH3A4PGeQBiJRfYJg+vHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 May 2026 17:12:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  6 May 2026 10:22:56 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> 
> > Pages allocated before page_ext is available have their codetag left
> > uninitialized. Track these early PFNs and clear their codetag in
> > clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> > warnings when they are freed later.
> > 
> > Currently a fixed-size array of 8192 entries is used, with a warning if
> > the limit is exceeded. However, the number of early allocations depends
> > on the number of CPUs and can be larger than 8192.
> > 
> > Replace the fixed-size array with a dynamically allocated linked list
> > of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> > to a pfn_pool containing a next pointer, an atomic slot counter, and a
> > PFN array that fills the remainder of the page.
> > 
> > The tracking pages themselves are allocated via alloc_page(), which
> > would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> > recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> > %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> > so that the early path can skip recording allocations that carry this
> > flag.
> 
> AI review asked a couple of things.  I have a feeling we saw at least
> one of these, so probably already dealt with.
> 	https://sashiko.dev/#/patchset/20260506022256.32664-1-hao.ge@linux.dev

Please?

Also, this patch has no evidence of human review.


From: Hao Ge <hao.ge@linux.dev>
Subject: mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
Date: Wed, 6 May 2026 10:22:56 +0800

Pages allocated before page_ext is available have their codetag left
uninitialized.  Track these early PFNs and clear their codetag in
clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set" warnings
when they are freed later.

Currently a fixed-size array of 8192 entries is used, with a warning if
the limit is exceeded.  However, the number of early allocations depends
on the number of CPUs and can be larger than 8192.

Replace the fixed-size array with a dynamically allocated linked list of
pfn_pool structs.  Each node is allocated via alloc_page() and mapped to a
pfn_pool containing a next pointer, an atomic slot counter, and a PFN
array that fills the remainder of the page.

The tracking pages themselves are allocated via alloc_page(), which would
trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
indefinitely.  Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
can skip recording allocations that carry this flag.

Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    4 
 lib/alloc_tag.c           |  145 +++++++++++++++++++++++-------------
 mm/page_alloc.c           |   12 +-
 3 files changed, 102 insertions(+), 59 deletions(-)

--- a/include/linux/alloc_tag.h~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/include/linux/alloc_tag.h
@@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(u
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
--- a/lib/alloc_tag.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/lib/alloc_tag.c
@@ -767,60 +767,95 @@ static __init bool need_page_alloc_taggi
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
+			gfp_t gfp = gfp_flags & ~(__GFP_DIRECT_RECLAIM | GFP_ZONEMASK);
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
@@ -829,37 +864,45 @@ static void __init clear_early_alloc_pfn
 	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
 	synchronize_rcu();
 
-	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
-		unsigned long pfn = early_pfns[i];
+	for (pool = current_pfn_pool; pool; pool = next) {
+		int nr_pfns = atomic_read(&pool->count);
+
+		for (i = 0; i < nr_pfns; i++) {
+			unsigned long pfn = pool->pfns[i];
 
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
--- a/mm/page_alloc.c~mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list
+++ a/mm/page_alloc.c
@@ -1255,7 +1255,7 @@ void __clear_page_tag_ref(struct page *p
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline
 void __pgalloc_tag_add(struct page *page, struct task_struct *task,
-		       unsigned int nr)
+		       unsigned int nr, gfp_t gfp_flags)
 {
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
@@ -1269,17 +1269,17 @@ void __pgalloc_tag_add(struct page *page
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
@@ -1312,7 +1312,7 @@ static inline void pgalloc_tag_sub_pages
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr) {}
+				   unsigned int nr, gfp_t gfp_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
@@ -1867,7 +1867,7 @@ inline void post_alloc_hook(struct page
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order);
+	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
_


