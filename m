Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD3AEC44503
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471606B00F9; Mon, 29 Jun 2026 09:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB696B00FA; Mon, 29 Jun 2026 09:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225FF6B00FB; Mon, 29 Jun 2026 09:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D45F86B00F9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4735DA06D4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:39 +0000 (UTC)
X-FDA: 84932989638.29.22B57DE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 94C7DC000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ok0OyMd6;
	spf=pass (imf28.hostedemail.com: domain of 3Q29CaggKCIQriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Q29CaggKCIQriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738757;
	b=YZlgLCQpAbFoODplskX7vH5zpQCw3xOq0vx6SGJpENKBK3xJXaH5WEBDiJH4QH6uiGSK8/
	3+4R4rN9VvS3zxhotFmSfPb7QGkTCHC7T5Glo3e4roYCkIq1mUFe+ZScSP9hiNQ0T3EIsT
	PC8deljMcPlucLsfTDjgkkUSUO21lRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdj9C/B8eHaGvKbpCd9yiXjpao1QqOLZ74XGYE6JkIY=;
	b=gR9Cv4ljM3JafqYSRpNCFNybc8mvMBuWpV/fDQ1RHWxS68kkOsRuNzsyYZHosF64bNa8hV
	OqsgxzUROaBR4Wlz6pxOXpMF5VIH1Gs8efxMR8Nv6Zd0R0S3i11/d28A3Fuq8SIbxIHSg0
	nPnHlT07NFSkqZwAN//Fr52IbBE7Idw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ok0OyMd6;
	spf=pass (imf28.hostedemail.com: domain of 3Q29CaggKCIQriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Q29CaggKCIQriksuivjowwotm.kwutqv25-uus3iks.wzo@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b0fe9659so8092415e9.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738756; x=1783343556; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jdj9C/B8eHaGvKbpCd9yiXjpao1QqOLZ74XGYE6JkIY=;
        b=Ok0OyMd6KnxlgWCTlHXNLgOd1H/2h1H2Zrrk3tjkoMIwHbzrMga7rmLKPPyjIX6oXj
         xECJ2yMvOONQCKAt7hWILn42WWkywN4fS++vq4aNnmOXAfG9set06lTslt2IrMsp7cQt
         1tbIA25K1YWcYXx5idsM883HRtgfD8Eh1vypgTjeKrS5GDS0p4uEIxJMs9XmXA0JPMCj
         Gvnij5JzZyiWyZkvV/JaWlPqjREmK8XZ1dHplGURW73HCCX0v0KTeQE4FEKgOId/Q/Lx
         ks7Yu2rWYXhaW8AZ7YUS4DOt4IkhSu2bJwphpAhkSq2djyep+KRA2lAC0GhH3ya+Z0lr
         W0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738756; x=1783343556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdj9C/B8eHaGvKbpCd9yiXjpao1QqOLZ74XGYE6JkIY=;
        b=emUlhr1MXJtZn25YpzVyYlQHKU+0FF8LrtEnVzZmi/1MwTznopQZ9UwpHm+tj+en1l
         6B2UcRVzQH8ATbM5WlZZS8Sng1tBpHUQAr4QAM4WLya+4UTKCbAn/zIZMfVrVrSQL5xW
         J7lM/PH8kVO7y2oZlYz30bDhAIKQTgDDX6bXgMV3eDuUDUamb+Ns/uvAgmouELR+oNMi
         7EvGzjuFnqpPJYNc72TdkHGR+H/JIKbEGfk8YwAxqpwZZ3pAgFEPa/J+uTD8efgMmhXN
         2X0iU3Ah0D/EGm1MIute5IvErrmGqU7U/sMUDH46sbtIqaqWTX5OFLzxtKGoox6KoaID
         GdGg==
X-Forwarded-Encrypted: i=1; AFNElJ8XIyJT+wLfqMkULWDsKCavTEeAZRHxUi9k40ugEMaqQVBMjoKpOvTXEikzisNsGTfnuPLhlatc7g==@kvack.org
X-Gm-Message-State: AOJu0YzdSk1xJUs5Qc+OGl2FWGEGijDj+ERiVKINiNwHOR4NM+MUeCIP
	m86JLWfqVT4IY2dsSMhjrx3Xk54t55f3TNuTYhTa7bWofjnGkfvqsMxPOIXbX0xcdbYV0wZf5jF
	DfzPoRcfSbKHfjQ==
X-Received: from wmnj20.prod.google.com ([2002:a05:600c:754:b0:493:b691:8628])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8711:b0:493:b549:3bf1 with SMTP id 5b1f17b1804b1-493b5493ff2mr24542445e9.12.1782738755265;
 Mon, 29 Jun 2026 06:12:35 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:04 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-15-57bef0eadbc2@google.com>
Subject: [PATCH v3 15/16] mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94C7DC000C
X-Stat-Signature: zdstntyrmn1q59pjzusb577kni3yzqef
X-HE-Tag: 1782738757-712278
X-HE-Meta: U2FsdGVkX1/rBx+Ly6Y/focJjWHbGv4H/3mQhHlI2tGhhDnSAEH/cn/ZPbpZM1Ly3QwUsD7oR0rZtX05EX5fg/JBr26P32WtPqEpkvUK6r7AKGFB1PcLVTeOmZHJVYJqd0E17qIQ+X77MnyaSZ/Pym2KDii6BUxefuSb/raRF8yeTNSzzad7gOqDQ7i525ryUKggWehqz+z8oI9fLE6v/Xewd/srp4BMbDx96xdZlmvfDFR4YLzQsFufK1eEUIfIvH4LaeMRezfX+FFnJjY0vo1lQpUgVOUlkvVZVx22NgKQVx2kz1Q+5eFo2yI8eyhzi3i7F6kXY3737lTIlCw/aPtAPi9pOGwugh83UaICZLunbGVPdmMHc2vbYNZq6E4c+iFvIPNM2dZ/QDQraNBBD3FALtKKZFkbhVOEOeff0QElvbHVqeqN0ZsRzqg9KIco01cEY1ukjnTaf7njbvGz0K4hDQvgTj49tbG1Tvm6DLDd8+/JegH79KQebSIQ1VimeGsHVWoeFAgSdpoEUa/Ns7/ILVvRNQn4liRXz+Kht4kbBgNBvZ1/0cSwMISkfPp91mCbSSSfLP5PYEsIkWFiJwYCyu+1uvLyxcfV47OlZDgwExHGX6R4Fr8zPoo7EoykbwAiMEvdeSgdvQZ1fOpMp5j207rCHFaojr93yfXJptE7wbWNAtOEZ9Epz5jxhLZ0IQ/uOLWYbNHA1LBAbZO8XcScEqzgpdJX2Vu/x6M+M1c5UxYlm/3nK8P5+AjQ05z6RJTEkQ5E8KI4Bn4aXgdoOm2I6+U0GzNdTGyvmcQmRe+pjHnNo0ogY3vBvhjZdbytEEKLCuFaEajCsOzGyZTYr4ahTVekHVdVdZT3wm5DtAvqqXK1VvhuNm5eS+hCPmRkP29/aFPauSwzDxkoYuIxRCdMFLqmxlLN4B9sTdCX1mBQGrPHp4GumfilZgbmlVhVmhIWvTi4tIwLHqQeW1b
 L9mShpVP
 /xGgPS8DRE2nZQf/9TMLPYxqIhQunfMk8vi+e5n6XCIPcdTw75nHYvYSy0Mlb66NRyUSLGt9N7lOHk2CKdu0oecvuQr4hb2vhG+Kq2tXTfzetpAnL+zMEiz/9bzC0uRMvh0WMQc8YMExxT0glA4xFCaJD5rjptVxNFoiM7zP8FT31NFMAclY6zartzGm0RYsito5AJ8weFd1h7n9sNySxLoMzzkGNq/e/UJKTeLS2/dCu8rSS7exWQdiCzhy8PormbBgnZbwl2uwANFv5M3FSLH4+UEPZwvlYbcocDykDrGRwccmHbamXDY/lscA4qLA8N8lKaArxC063mHMm4g00NtXQ+/TqeJyUZUsva9+Rju60o6+NYEpEunPoCAA1GPhSQGLeZkcAg8nA0POc2wwZ3f/BX5VS9KQqxyakCY8VDi7SxBH/+EOljm6oJ8nNcWv0jYL147mLXjCGWYglC/pncMZps0DnhdnD/ioRfkQau1w8Q8HVKcbaqmYtRRUXDjZevJy1xevnhdPp0NrO3VAWpVnQtBUKLaNzpvpB1TBLupxzzPCV5csmdIi89K0B3RdqEqktkWLAAiJdCPf8gP1ie/tbf+DitfSNotcACgEEgxp5J4z/3HfJH/eqnejYKYg65PYhgSJiFRwsBqb342IYPV/q1PPSYw6G/I36MGONzz47YEPCfa813IHaow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that alloc_pages has an entrypoint that allows passing alloc_flags,
we can take advantage of this to start removing GFP flags that are only
used for mm-internal stuff.

This requires also plumbing the alloc_flags into some more of the
allocator code, in particular __alloc_pages[_noprof]() gets an
alloc_flags arg to go along with its callees, and we now need to pass
those flags deeper into the allocator so they can reach the alloc_tag
code.

No functional change intended.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/alloc_tag.c       | 22 ++++++----------------
 mm/compaction.c      |  4 ++--
 mm/internal.h        |  1 -
 mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
 mm/page_alloc.h      | 17 +++++++++++++++--
 mm/page_frag_cache.c |  4 ++--
 6 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index d9be1cf5187d9..a32a94e759b94 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -15,6 +15,8 @@
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
+#include "internal.h"
+
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
 #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
@@ -783,19 +785,6 @@ struct pfn_pool {
 
 #define PFN_POOL_SIZE			((PAGE_SIZE - offsetof(struct pfn_pool, pfns)) / \
 					 sizeof(unsigned long))
-
-/*
- * Skip early PFN recording for a page allocation.  Reuses the
- * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
- * recursion when allocating pages for the early PFN tracking list
- * itself.
- *
- * Codetags of the pages allocated with __GFP_NO_CODETAG should be
- * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
- * alloc_tag_sub_check() from triggering a warning.
- */
-#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
-
 static struct pfn_pool *current_pfn_pool __initdata;
 
 static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
@@ -806,7 +795,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
 	do {
 		pool = READ_ONCE(current_pfn_pool);
 		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
-			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
+			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
+							      NULL, ALLOC_NO_CODETAG);
 			struct pfn_pool *new;
 
 			if (!new_page) {
@@ -837,7 +827,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
+void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
@@ -845,7 +835,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 		return;
 
 	/* Skip allocations for the tracking list itself to avoid recursion. */
-	if (gfp_flags & __GFP_NO_CODETAG)
+	if (alloc_flags & ALLOC_NO_CODETAG)
 		return;
 
 	rcu_read_lock();
diff --git a/mm/compaction.c b/mm/compaction.c
index 7d80735502d9a..4b2318fad4eb5 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -83,7 +83,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE);
+	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1851,7 +1851,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	}
 	dst = (struct folio *)freepage;
 
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index c22284f04fc9e..369c656c63fa8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1237,7 +1237,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 enum ttu_flags;
 struct tlbflush_unmap_batch;
 
-
 /*
  * only for MM internal work items which do not depend on
  * any allocations or locks which might depend on allocations
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 026f33f217036..803b32e5a5e47 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1249,7 +1249,7 @@ void __clear_page_tag_ref(struct page *page)
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline
 void __pgalloc_tag_add(struct page *page, struct task_struct *task,
-		       unsigned int nr, gfp_t gfp_flags)
+		       unsigned int nr, unsigned int alloc_flags)
 {
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
@@ -1263,17 +1263,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 		 * page_ext is not available yet, record the pfn so we can
 		 * clear the tag ref later when page_ext is initialized.
 		 */
-		alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
+		alloc_tag_add_early_pfn(page_to_pfn(page), alloc_flags);
 		if (task->alloc_tag)
 			alloc_tag_set_inaccurate(task->alloc_tag);
 	}
 }
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr, gfp_t gfp_flags)
+				   unsigned int nr, unsigned int alloc_flags)
 {
 	if (mem_alloc_profiling_enabled())
-		__pgalloc_tag_add(page, task, nr, gfp_flags);
+		__pgalloc_tag_add(page, task, nr, alloc_flags);
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -1810,7 +1810,7 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, unsigned int alloc_flags)
 {
 	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
@@ -1861,13 +1861,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
-	pgalloc_tag_add(page, current, 1 << order, gfp_flags);
+	pgalloc_tag_add(page, current, 1 << order, alloc_flags);
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 							unsigned int alloc_flags)
 {
-	post_alloc_hook(page, order, gfp_flags);
+	post_alloc_hook(page, order, gfp_flags, alloc_flags);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
@@ -4791,8 +4791,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
+	 *
+	 * Can't just or alloc_flags if it contains WMARK bits, but those flags
+	 * shouldn't be set in ac->alloc_flags.
 	 */
-	alloc_flags = alloc_flags_slowpath(gfp_mask, order);
+	VM_WARN_ON(ac->alloc_flags & ALLOC_WMARK_MASK);
+	alloc_flags = ac->alloc_flags | alloc_flags_slowpath(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -4834,7 +4838,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
 		alloc_flags = alloc_flags_cma(gfp_mask, reserve_flags) |
-					  (alloc_flags & ALLOC_KSWAPD);
+				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -5236,7 +5240,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
@@ -5344,11 +5348,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = { };
+	struct alloc_context ac = {
+		.alloc_flags = alloc_flags,
+	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
 
 	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~ALLOC_NOLOCK))
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
@@ -5417,12 +5423,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page;
 
 	page = __alloc_frozen_pages_noprof(gfp, order, preferred_nid, nodemask,
-					   ALLOC_DEFAULT);
+					   alloc_flags);
 	if (page)
 		set_page_refcounted(page);
 	return page;
@@ -5436,7 +5442,7 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
 }
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
@@ -5444,7 +5450,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 		nodemask_t *nodemask)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask);
+					preferred_nid, nodemask, ALLOC_DEFAULT);
 	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
@@ -7126,7 +7132,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
 			if (!order)
 				continue;
 
@@ -7331,7 +7337,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 2058cbdca56e7..2614bff6795b0 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -49,6 +49,16 @@
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+/*
+ * Skip early PFN recording for a page allocation.  Used by
+ * __alloc_tag_add_early_pfn() to avoid recursion when allocating pages for the
+ * early PFN tracking list itself.
+ *
+ * Codetags of the pages allocated with __GFP_NO_CODETAG should be
+ * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
+ * alloc_tag_sub_check() from triggering a warning.
+ */
+#define ALLOC_NO_CODETAG       0x1000
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
@@ -84,6 +94,8 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	/* Only flags that are global to the whole allocation go here. */
+	unsigned int alloc_flags;
 };
 
 /*
@@ -214,7 +226,8 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     unsigned int alloc_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
@@ -245,7 +258,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 void free_frozen_pages_nolock(struct page *page, unsigned int order);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
 extern void zone_pcp_reset(struct zone *zone);
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index a1077cef3a791..e63efe78b7d4b 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -57,10 +57,10 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
 	gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
 		   __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
 	page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
-			     numa_mem_id(), NULL);
+			     numa_mem_id(), NULL, ALLOC_DEFAULT);
 #endif
 	if (unlikely(!page)) {
-		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL);
+		page = __alloc_pages(gfp, 0, numa_mem_id(), NULL, ALLOC_DEFAULT);
 		order = 0;
 	}
 

-- 
2.54.0


