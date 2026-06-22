Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269D9CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ABB6B00A0; Mon, 22 Jun 2026 06:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D334D6B00A1; Mon, 22 Jun 2026 06:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21456B00A2; Mon, 22 Jun 2026 06:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68FF36B00A0
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:02:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC7F990594
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:02:02 +0000 (UTC)
X-FDA: 84907107684.30.933B057
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE7D9C000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:02:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bbrqUTUh;
	spf=pass (imf10.hostedemail.com: domain of 3Fgg5aggKCGMKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Fgg5aggKCGMKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYiGzvh99rMY4kNYNexhfMgzkwWFV4iojo7tWSGYnXM=;
	b=nldnhQk16ca1dgbCFKI5Kv3xj1whxpRZ2vUpMNee1QfP47MrkpHgreZIS8DCbq8qKVkRQ6
	5/WRgz7aPQrJu5m9NuhTqiDmgOgqnWgB2RV6ICDnvv4jc16RS+0DoL8EBZT4cVlXIejlua
	24jhg4iVx00EZLp1B3saMbObvck2SMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122521;
	b=VZE1XrZJb6+P/h1SiDJ3JcTIORM7d6MjjDTER2fC40zdxEgwvxQXn9l0THarHnxVBq10uy
	5+2UK55kxaSyCq79bfcD5JGgLULrYq+IR2UvH49pQ6GSA/ITbQtdXlW+lMdSCZjWp9cJF/
	Y8Y0g65PU50dZCTgrKOxbM3GWcZUL60=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bbrqUTUh;
	spf=pass (imf10.hostedemail.com: domain of 3Fgg5aggKCGMKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Fgg5aggKCGMKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so25813855e9.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122519; x=1782727319; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYiGzvh99rMY4kNYNexhfMgzkwWFV4iojo7tWSGYnXM=;
        b=bbrqUTUhLyNQf3baDzairCnsgaM5YH7WrbAQjxPmTjzy1vdgAAna1Tz9D7nmMTKeqy
         ElvDb2hQxlraVLkBvI/TQ4uMzvAPax3N8Q4yNXNeEEaHMve0JZIX3SZFv1uIceqjA5yN
         RXcrXfhR2BlqmESgygzb4hJNFeX7e+ErKgIL/dj0m9agZ3mJWbolnrC7FQCKYcf+o03V
         iV6S71vs57mofMRGPModIPYDz3yNATpzA0hovy3VfkMnsBcB/slHoeAMXXh1qfFeEeeG
         MdJ2nTKGQSVvrzK7TyGyDO5FD1Vtge95/3MLaZN7Be8tFi/gocU/Kr2IsJvIZgo8H6Gb
         /+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122519; x=1782727319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYiGzvh99rMY4kNYNexhfMgzkwWFV4iojo7tWSGYnXM=;
        b=pzHyptNxxzj1OkViNGTS1LYXEyMepEfnxfOVUF8sU5jmqZgBAbyoG0P55DcYpVMveR
         8XVql/G7GKa1niRgqmI0qh9m+S9cRdFanksKR2FY7jm3Z2WGLSbpfYWB0UXr93bwdEIW
         EV7fUDuCbSzspkYBBjWEvphkKGn58C5TEWHcSnz4BUmFY7pxVYuMr3cqbzpYaKRBnhL8
         evtcZHW0d8xwI7WGbcbzu1IrkwsHv8MjxW661mi6yv5HetZpgAbGEFfxUq9PCjP0tBCX
         PFv3ubZ0LOpaOQtnbS1lByI0SRM2PlCDhNVyPTG2RM+nnhjNnFUyecq41gthj0DUC3o4
         cppg==
X-Forwarded-Encrypted: i=1; AFNElJ/stlV7wxf22D5KHaqBgdxxwxPl3aNU7leimtDfaRqH7a11azCX+pyO9IB77H8gUqPNGpt3PBbFfg==@kvack.org
X-Gm-Message-State: AOJu0Ywdqogqsbaptq77x4JWTGfYestaS9/y/NBfhZTdY1BCrlVSRYkN
	Yrdkctx/SwvsYpWbyaakguhrI6Qcj+SVyQBwthbhw8PgwGoxkT4DCdSguNbeaZoZWPImMpWgc7E
	twTj/M+gFChSCsQ==
X-Received: from wmbf6.prod.google.com ([2002:a05:600c:5946:b0:492:4336:6b5f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a00e:b0:492:4cce:53e2 with SMTP id 5b1f17b1804b1-4924cce540emr110031025e9.3.1782122518697;
 Mon, 22 Jun 2026 03:01:58 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:40 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-13-31f31367d420@google.com>
Subject: [PATCH v2 13/13] mm: remove __GFP_NO_CODETAG
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 14arf6fwh6qqez9ruday8ztwmm3xn4uc
X-Rspamd-Queue-Id: EE7D9C000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782122520-731929
X-HE-Meta: U2FsdGVkX1+3gzs3QikeT9K8IQZW8I4r0TOvDnXhszgJh8tZiCQpQ/HmSuIElTdK0DZRSci8Y4zfiO7N7az95pFlzHF4O4hDPyXwPItpii1GcJL1zGGE3qSTF8Zbc5HwxycwGRrwPca+BpSDcFev9BvnK5Ba3JefRt3rXBP9NZyPEcIVJJiI3CYOfoDbBfTxq8Tqh20UTdy15FpTVbtQrd9KBo010jmuvop/tpUlm+Pq/Io9PRi3BIuU22SXnEd/eNo3/rBEavBCGzoNOBn77SJBvOQuDOuVwzocP14thhd/uDS0qQfdWHwq7OktxXflll7pVki5ug7PaACqSS37qT6BA9W1B1Tvb4O4PbUxzbjeRzCg6LUY1hvkl6cGrSff/y08AxYX8Bb8G01NI4xfNgwwbLCj8h6Cw+q5yzrvEOaqnrGSL+gk0f1Haws7bdd4NTkH0mkuh6gieStENswhuCKxyLodIYng3/N3TkKCH4b0PTkRQpkbgtDClSfJQ8jgsHgzBiQaGNPmQcDMPvpyDZFajPERnzrrQ+6CetdWG4AuD5vrAXJDAaCBEvm+ly5gHhVu1fah/nyEWaX4rzn0Kw4YzyWwcw2fQW0EVyxXFnUcG2BILCdxOG1W6zONmrLIR8wgk1L8Y1uRSG613QkwsFig/1w8UrcbsouwiJRmpBMXbyXybUjXPEWDrDqi1wDLrqJfqn6wP1gjPeshZd3S8VV+WCgtZKmry/WfbH1hAQc2IJjw7JOlO3RUNJbCZvNp1wnpIlLISBVEQfM2ua+CTq2VDa+c5nMJ6J6nRkeokFadRV3ENMZiAwsUi49HTdhg1ZuodCG6wgj8Bu3JnRKV005ZysnlKzXVJUvNs/ADcnukPrf2ONMNBteandUq250otfleaTd0EKqaG6reD7RH7kEyDFpPYR4Yeaq8V+SNoy8K35mhqVjMZE807GaD2/VUXofjUn6JAykvLVS4AiB
 q/F+5vEa
 D+e3oXRlput8q6H5Yuf5jth52UY8Abzf0s7cB5zUdAjGYKqRuvlrZZQpSzMGaoaSOunfhF1/04H8/GeCr2AH5o76AEufn1xxGMgQGDeR3jv5cW90kDM9kKaW8xR6d1JgjoD1LKSu+xruGew+MuHupc+5RfttINnyaf0OhN3Uq2vJaDdpKylnqem/4/L3AwVf19VYdjWmUodaICJmp1P7L1BYfbVkUyfO9xrivZlQLxrdOm6/XL3rzZa8DZxVAUXL2Mci3y6tCa7zDDVhLAoNB2EVKMFs9Ol+STOI4oZ6T07+yPjOs0x8vxNLUlqA2UVTbnpKndxADIFAjJJLhjfu3gsRqQ1ycMv2KK/II97lq99wXhps4FSJhcJiFfcuR9acJDBnAydxz4y/5yE4Vnls6QYDRB//UBayBPzhgNwBZldob2q1UgkPs2vSkoDDK+U5hs2iB3yJxyuhhJrig2II9c86DJ39lTVXT/576u9dKRC7W60zAHcfFNHU/asiknq4aiG6FcnXUJWj7MUfMOVI3+fQ9Pfw9IQoUsCln2ab6p956gNaPY8DHNuEHsrcpsZk7hHAxWbi9EWg9wW97NEdjl0DyR3M4EMgUy9uRHl6jxl+B1AwObDEUY1z5KHirkFhcf0wpuGasZ7KIuekHa7gY6oZ+cBCbpvWQQX4mjVCX3rylFzKL7P0UIbER7Q==
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

To try and keep the new ALLOC_NO_CODETAG's scope nice and narrow, don't
define it in mm/internal.h, instead just define a "reserved bit" and
then use that in places that don't care about what it means.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/alloc_tag.c       | 18 ++++++++++--------
 mm/compaction.c      |  4 ++--
 mm/internal.h        |  8 ++++++--
 mm/page_alloc.c      | 42 ++++++++++++++++++++++++------------------
 mm/page_frag_cache.c |  4 ++--
 5 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index d9be1cf5187d9..61a6cba32ff35 100644
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
@@ -785,16 +787,15 @@ struct pfn_pool {
 					 sizeof(unsigned long))
 
 /*
- * Skip early PFN recording for a page allocation.  Reuses the
- * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
- * recursion when allocating pages for the early PFN tracking list
- * itself.
+ * Skip early PFN recording for a page allocation.  Used by
+ * __alloc_tag_add_early_pfn() to avoid recursion when allocating pages for the
+ * early PFN tracking list itself.
  *
  * Codetags of the pages allocated with __GFP_NO_CODETAG should be
  * cleared (via clear_page_tag_ref()) before freeing the pages to prevent
  * alloc_tag_sub_check() from triggering a warning.
  */
-#define __GFP_NO_CODETAG		__GFP_NO_OBJ_EXT
+#define ALLOC_NO_CODETAG		__ALLOC_ALLOC_TAG
 
 static struct pfn_pool *current_pfn_pool __initdata;
 
@@ -806,7 +807,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
 	do {
 		pool = READ_ONCE(current_pfn_pool);
 		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
-			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
+			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
+							      NULL, ALLOC_NO_CODETAG);
 			struct pfn_pool *new;
 
 			if (!new_page) {
@@ -837,7 +839,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
+void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
@@ -845,7 +847,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
 		return;
 
 	/* Skip allocations for the tracking list itself to avoid recursion. */
-	if (gfp_flags & __GFP_NO_CODETAG)
+	if (alloc_flags & ALLOC_NO_CODETAG)
 		return;
 
 	rcu_read_lock();
diff --git a/mm/compaction.c b/mm/compaction.c
index b776f35ad0200..e90ebd2c54f48 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,7 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE);
+	post_alloc_hook(page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1850,7 +1850,7 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 	}
 	dst = (struct folio *)freepage;
 
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index 0847b55bfc147..a45bedb9ada5f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -684,6 +684,8 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	/* Only flags that are global to the whole allocation go here. */
+	unsigned int alloc_flags;
 };
 
 /*
@@ -907,7 +909,8 @@ static inline void init_compound_tail(struct page *tail,
 	prep_compound_tail(tail, head, order);
 }
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     unsigned int alloc_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
@@ -1481,6 +1484,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define __ALLOC_ALLOC_TAG      0x1000 /* Reserved bit for use by alloc_tag code */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
@@ -1956,7 +1960,7 @@ bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
+		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d99e4ea8307ea..d50fd9c77a2e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1246,7 +1246,7 @@ void __clear_page_tag_ref(struct page *page)
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline
 void __pgalloc_tag_add(struct page *page, struct task_struct *task,
-		       unsigned int nr, gfp_t gfp_flags)
+		       unsigned int nr, unsigned int alloc_flags)
 {
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
@@ -1260,17 +1260,17 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
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
@@ -1807,7 +1807,7 @@ static inline bool should_skip_init(gfp_t flags)
 }
 
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags)
+				gfp_t gfp_flags, unsigned int alloc_flags)
 {
 	const bool zero_tags = gfp_flags & __GFP_ZEROTAGS;
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
@@ -1858,13 +1858,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
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
@@ -4773,8 +4773,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
 	 * alloc_flags precisely. So we do that now.
+	 *
+	 * Can't just or alloc_flags if it contains WMARK bits, but those flags
+	 * shouldn't be set in ac->alloc_flags.
 	 */
-	alloc_flags = slowpath_alloc_flags(gfp_mask, order);
+	VM_WARN_ON(ac->alloc_flags & ALLOC_WMARK_MASK);
+	alloc_flags = ac->alloc_flags | slowpath_alloc_flags(gfp_mask, order);
 
 	/*
 	 * We need to recalculate the starting point for the zonelist iterator
@@ -4816,7 +4820,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
 		alloc_flags = cma_alloc_flags(gfp_mask, reserve_flags) |
-					  (alloc_flags & ALLOC_KSWAPD);
+				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
@@ -5218,7 +5222,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
@@ -5326,11 +5330,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | __ALLOC_ALLOC_TAG)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
@@ -5398,12 +5404,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
@@ -5418,14 +5424,14 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
 }
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask);
+					preferred_nid, nodemask, ALLOC_DEFAULT);
 	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
@@ -7107,7 +7113,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
 			if (!order)
 				continue;
 
@@ -7312,7 +7318,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index d2423f30577e4..d9573170e0719 100644
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


