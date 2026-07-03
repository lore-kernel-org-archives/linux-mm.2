Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF726C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDE46B00CC; Fri,  3 Jul 2026 08:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0746B00CD; Fri,  3 Jul 2026 08:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FCF6B00CE; Fri,  3 Jul 2026 08:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90E0D6B00CC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 172AF40522
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:42 +0000 (UTC)
X-FDA: 84947404164.13.0B9DFDE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48A9518000C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qrQ15HxQ;
	spf=pass (imf16.hostedemail.com: domain of 35qtHaggKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35qtHaggKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081960;
	b=ypFnlTJEP6hA8ELwGXiiDebWZC0056SvOMhm98DUpSc+fETKmBYK4/dS3EzSC4PXFPSwHn
	VLCn5Igreayw/XNkwLY1tMaJe68aEthUIy3EP03TRgYS0s6zZjROKxnp6XChHrQYVlqpmC
	qNFOSO/IT5J0kzq103cih906l+KR2I0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMYsxeGFadwK078jgs1Rv7thCDNA/CDq4IBR1WhL5xQ=;
	b=iQHr3cSTQ5ERwS6IsF/gOm49s9kFm9VqKqcS9tdXcM1KFpsciROycWAS3p9q4Det/A987G
	505EaYyU/uQu1ZuMy+GV3vKEnlwGTY6w+4c8jzAJq4szLCQkoVamNFU64HQISRq+difm60
	PhFFblo053YAWMYFvIhdHr7l2BdL32Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qrQ15HxQ;
	spf=pass (imf16.hostedemail.com: domain of 35qtHaggKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35qtHaggKCLUeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b54823bdso10674565e9.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081959; x=1783686759; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMYsxeGFadwK078jgs1Rv7thCDNA/CDq4IBR1WhL5xQ=;
        b=qrQ15HxQ6k1umLX4s0kBXIBhSDbZYGtCXkhNP+wq1/QOLn+XkN2lfgSKmsk46pCKBe
         PI+0QfTOUMBoScY7hxy51GYqKe56pSfPWwofJ5vQMgQNgRTR4vjc/BBAHKOrD9+RE4p2
         xm4I38u/oYqcgFC3tVZhT6psbrcYSPLLVRrnGQCbNY2SlB50/l7ZI0dn5OsN670GHRCh
         zgKMPbs0EurF0Pd4rmsU0HRWj49j2rDwLKnRPUGn6KyQFCtX9a16YH//fjecwioB+GrL
         WYvxhiekhWuWO7Mdrj1FBcD5JOdFehnC7D29V+lefYFNYZSr5PgQ1V/iBsyv7ZTcZK3A
         ExgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081959; x=1783686759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMYsxeGFadwK078jgs1Rv7thCDNA/CDq4IBR1WhL5xQ=;
        b=s5xkg9NEy9tvK7vM7NvIg9Io5nd+ebO/rH6ImFBSC2piK2dNs9SYuRMYBRhStN9Y69
         8azKjDt7Bm/S+I+cgySnHCCwHG9dOIjr3CoL5gHLPHooq1yiW3PYF+2kvpkpNRVo5R5z
         v0CSB04/m1+lbsj83IhG/UukI+G32xdSco09yBRrymUL1WORHeZg5uH+vyIyk/DQuTW6
         dfl67Ogy5bFBL7w5Bdpz2yFCwOY4gK4BZymKIItaCeVQgkwzAU1Ghpmu5jXtWnLg+yJw
         LPaxOvczwq4WE2G41wYAipG3prtoj6wT6v0Y2WBKdsSUlRodSXak2q4IqxuuU15lsqny
         Bkmg==
X-Forwarded-Encrypted: i=1; AFNElJ+R26rRlbC06QXYXsyVna+prhiA+PXxxQ24qRhuFBDsuN3z6Iq2/zMTKHVVB1Ewjz5c3N68p+lwbw==@kvack.org
X-Gm-Message-State: AOJu0Yx+chdEAjMmkZF4r4lQwro5102bNoWcKZFRt9njN/Gn/DfUVBO9
	x69w4RimAPc5qHP7VqyDojcNhY2F6Z349p8rgv9hnUo365iklG/Fccmd3FOr2AD1JZ+ydO4W059
	BKwL/ZaVPUjQ80Q==
X-Received: from wmpv21.prod.google.com ([2002:a05:600c:4d95:b0:48a:6051:b5af])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4690:b0:493:bee0:4360 with SMTP id 5b1f17b1804b1-493c9b6c137mr54871205e9.17.1783081958309;
 Fri, 03 Jul 2026 05:32:38 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:55 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-15-c87b714e19d3@google.com>
Subject: [PATCH v5 15/18] mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG
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
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48A9518000C
X-Stat-Signature: ah6b8nna5aozqc7tu43ko61cs4chs8hg
X-HE-Tag: 1783081960-247629
X-HE-Meta: U2FsdGVkX1+jtQTk5eXcikxmZnejCinxHdpPPQ4dnOqd/kD4BwBxlt4tSLSsqFnikC+hV1ce2aR2ZV9x0TStsVEg2THiUMqNJ8q9E+LNjKiqN5q302mZdTYENS2FsbLbn701R58O0z3Rtk1n4XhcMmMtEFwLVDa2rDDjWACkehhgEc5sOTyXabRteqGAZjFGxg+gUBXDmjMnwpIYJIH8DRlBeGckMxMy2WHzhMVZUFfQHXCs+KsRsknLkPPEE0x2nRRdc4q/cNXzX0VGltQUnP97pw3iZcO+2MIdw4FplanmIQpx1twUMyo8hOTObs3Srv1p+Dk/HbIfMpFISbYepAgtVZ050WJAu4m/bywzqR0SOe8d5yhFASnBYi7xJdGraAAOUZJLo26PeHKxn1gCvVz55gpJq+WZRRML2CyAxrAeVnmJiUV5Ai4V1J7apl0LOVSiu7ptMJTCvLbMVPSdd04CXAR3TGQPYAJIZjtITlWOIpxJjPUdVe5Adx1RVqnASTJRKAeaYzlgrMRgrzZNUa0T/8ZPeLbnjNsLIdmrZESoF1BO4teuBKKs4v7BJ9GDS3iZ1zudTWdtiHsgexSHWFfQvF40CYuulEEwKzaD6Y8QtD4uwMVXPIak8HbQigHIO+hLLWeK84MRMTY0uQym/WoDKlLBRCVgx64an5v0LusfmLqYT6KM0bPJN3s/H6ZpP3jJso1rHKeiYejN09Forw2j7DFUaX/cRpx3aZrXafymNgBnAm2VR4QL00LtWK/WzC+Z27qE1ewGk4orDTsv8MGVFgn2vgo/Di8y9p6l9Y+xvg94VjjuKDdHpTvNDHO1whLLsEMTb+acTtjR3wu25AsSbMEtfLDupPfXrmpKnO5a5vDbcfzyKkEMfMljU8QRhWV0bdVX0HQHqgAGWADV2rPEuiF/wSTL31w7MTHgCfD15h5skWV1aXW+4E5kP4f/unSfzDhBtqyGR/t9e88
 5OgeLFk5
 uMLfLtqqLJq4IVv4zE//u4jHpixKpUjvgEtBERMTNv8v1wvLlNCysF+jKhkiKkVY7Jts2ic/c3RoCHwryDGqSqKpmuxG/BMBaYX1yFxJs3s4DpAuTHNPUwW43bCoPqP9oU48nVWO5xwEmqaPTgl8zKS2Zw8kLE8EASc2NWNhSHsEnBNIKGbUwc58u6pYQPwkKr3szvujTuptlaPK4yMVBhdeY26FeZ1qd067um+YOofiM9YErJizGM05XF35J42WURn1mNVSxlzehAUx2+6BNK4I4Co8lmyGJXdowdK88sRbvBxPmWXYyWx/Lpx5kWX0Pf2GVPyE3O7tGpH/JGUZp84UAWNNw8mfDVgWQQDvPoDx5qbo+deRyCJ4KdjY45ktQVMQfryz9bqAWrpt9dxLpJC243gPfq5ZUq2wSvFVJQbh0jARO56LLpMnc2OIMVwIeM9Xj+4bUeqOTyHXJ9sV5bsqrhUZDKwCdGVj1YvhCO0lWGKqaql4n1dTUn9aFbp90msxjoS5pVsuwEXYlmwTd5MvrIzRpCkwWrYSNvwT0qn9v5VmqBZrHbx/PREfvbJqC+lH8Y5d96P5QUPv4zahSUW6+6+Tm9vKmrHvEQupyTY8gP5VQJJZvhDPH8pqI5Z3Oqwovn9iSJawVkrtS+jJCtoI4N1WB9tdLYsfw/tjR1OEi+Jq2HDdnpOJ3dfxFefV3sxAN0fFXuqX+LuA=
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

While moving the flag definition into page_alloc.h, also update the
comment per Hao's suggestion.

No functional change intended.

Link: https://lore.kernel.org/all/b4916118-3537-4e19-8bc8-1d103dd0d225@linux.dev/
Tested-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Hao Ge <hao.ge@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/alloc_tag.h |  4 ++--
 mm/alloc_tag.c            | 23 +++++++--------------
 mm/compaction.c           |  4 ++--
 mm/page_alloc.c           | 52 +++++++++++++++++++++++++++--------------------
 mm/page_alloc.h           | 14 +++++++++++--
 mm/page_frag_cache.c      |  4 ++--
 6 files changed, 55 insertions(+), 46 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 068ba2e77c5d6..fcf90e6b24204 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
 {
 	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
 }
-void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
+void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags);
 #else
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
-static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags) {}
+static inline void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags) {}
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index d9be1cf5187d9..cf65e9992fda3 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -15,6 +15,9 @@
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
+#include "internal.h"
+#include "page_alloc.h"
+
 #define ALLOCINFO_FILE_NAME		"allocinfo"
 #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
 #define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
@@ -783,19 +786,6 @@ struct pfn_pool {
 
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
@@ -806,7 +796,8 @@ static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
 	do {
 		pool = READ_ONCE(current_pfn_pool);
 		if (!pool || atomic_read(&pool->count) >= PFN_POOL_SIZE) {
-			struct page *new_page = alloc_page(__GFP_HIGH | __GFP_NO_CODETAG);
+			struct page *new_page = __alloc_pages(__GFP_HIGH, 0, numa_mem_id(),
+							      NULL, ALLOC_NO_CODETAG);
 			struct pfn_pool *new;
 
 			if (!new_page) {
@@ -837,7 +828,7 @@ typedef void alloc_tag_add_func(unsigned long pfn);
 static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
 	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
 
-void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
+void alloc_tag_add_early_pfn(unsigned long pfn, unsigned int alloc_flags)
 {
 	alloc_tag_add_func *alloc_tag_add;
 
@@ -845,7 +836,7 @@ void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
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
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f68b2b138a2e8..cfaf16244f56d 100644
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
@@ -1306,7 +1306,7 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void pgalloc_tag_add(struct page *page, struct task_struct *task,
-				   unsigned int nr, gfp_t gfp_flags) {}
+				   unsigned int nr, unsigned int alloc_flags) {}
 static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {}
 static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr) {}
 
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
@@ -4078,7 +4078,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 */
 	page = get_page_from_freelist((gfp_mask | __GFP_HARDWALL) &
 				      ~__GFP_DIRECT_RECLAIM, order,
-				      ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
+				      ac->alloc_flags|ALLOC_WMARK_HIGH|ALLOC_CPUSET, ac);
 	if (page)
 		goto out;
 
@@ -4124,7 +4124,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 		 */
 		if (gfp_mask & __GFP_NOFAIL)
 			page = __alloc_pages_cpuset_fallback(gfp_mask, order,
-					ALLOC_NO_WATERMARKS, ac);
+					ac->alloc_flags|ALLOC_NO_WATERMARKS, ac);
 	}
 out:
 	mutex_unlock(&oom_lock);
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
@@ -5003,6 +5007,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * we always retry
 	 */
 	if (unlikely(nofail)) {
+		unsigned int alloc_flags = ac->alloc_flags | ALLOC_MIN_RESERVE;
+
 		/*
 		 * Lacking direct_reclaim we can't do anything to reclaim memory,
 		 * we disregard these unreasonable nofail requests and still
@@ -5018,7 +5024,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		 * could deplete whole memory reserves which would just make
 		 * the situation worse.
 		 */
-		page = __alloc_pages_cpuset_fallback(gfp_mask, order, ALLOC_MIN_RESERVE, ac);
+		page = __alloc_pages_cpuset_fallback(gfp_mask, order, alloc_flags, ac);
 		if (page)
 			goto got_pg;
 
@@ -5236,7 +5242,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
@@ -5344,11 +5350,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
@@ -5421,12 +5429,12 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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
@@ -5440,7 +5448,7 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);
 }
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
@@ -5448,7 +5456,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_
 		nodemask_t *nodemask)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask);
+					preferred_nid, nodemask, ALLOC_DEFAULT);
 	return page_rmappable_folio(page);
 }
 EXPORT_SYMBOL(__folio_alloc_noprof);
@@ -7130,7 +7138,7 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask);
+			post_alloc_hook(page, order, gfp_mask, ALLOC_DEFAULT);
 			if (!order)
 				continue;
 
@@ -7335,7 +7343,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0);
+		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index aa0c1481f7ca3..b9259deddb59d 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -49,6 +49,13 @@
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+/*
+ * Avoid alloc_tag recursion for internal allocations.
+ *
+ * Callers must clear_page_tag_ref() before freeing to avoid warnings from
+ * alloc_tag_sub_check().
+ */
+#define ALLOC_NO_CODETAG       0x1000
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
@@ -84,6 +91,8 @@ struct alloc_context {
 	 */
 	enum zone_type highest_zoneidx;
 	bool spread_dirty_pages;
+	/* Only flags that are global to the whole allocation go here. */
+	unsigned int alloc_flags;
 };
 
 /*
@@ -214,7 +223,8 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 extern void __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context);
 
-void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
+void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
+		     unsigned int alloc_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
@@ -245,7 +255,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
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


