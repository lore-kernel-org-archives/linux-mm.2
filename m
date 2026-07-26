Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE59AC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231DC6B00A9; Sun, 26 Jul 2026 18:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209386B00AA; Sun, 26 Jul 2026 18:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146496B00AB; Sun, 26 Jul 2026 18:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD0056B00A9
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4729D805B6
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:51 +0000 (UTC)
X-FDA: 85032356262.16.328D968
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id A061680005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZvlyT8EW;
	spf=pass (imf30.hostedemail.com: domain of 39IhmaggKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=39IhmaggKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXPhImrBERPbppuQB021OFH7MVznckDFLoOQIpa5uHc=;
	b=VOODgcX04j040lz1nX6pK5ywncg3D2XFWLIDXkTqVta5j9XPcdYjAV+6VCuxA0BsofXoP8
	vYVP+y4f+4HNkSVUt8sZSYRq8lNhDAwrQIQLZpMj5jaStiNvpmEiliJoVYyQozc8J1tb+h
	Y3DJB0QrjHKFs7qX3zobjJ9BdfxGJbg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZvlyT8EW;
	spf=pass (imf30.hostedemail.com: domain of 39IhmaggKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=39IhmaggKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104629;
	b=L/tKYl9sfw8jsDA0p2OEAFKGHc70h1HoY6EEywTBJEyU77QrsNOn2JBw8f1NHfyBNwoUyS
	M9KOovv+xUYqCAwyfPbGjzn+WTnvsTF0b6WzrSuHiqqzBZ695/esXmtjTMaS97sL9r2/3r
	edsz3rxA94Inqe38sGynzgBINaO7wsM=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49564d4b849so7992535e9.3
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104628; x=1785709428; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WXPhImrBERPbppuQB021OFH7MVznckDFLoOQIpa5uHc=;
        b=ZvlyT8EWJ3nvuOEo1/h0rcAAl7QIiUA0FR/RR3WW3ou7b9/MWrV3xW8A4nMCK4TOST
         zhZ/zkqDoqbhzS5qoW+T4HY1urICq4f5xi5TJOrhFv3qlCaQfBzC7SfGIzWgQ4qviVFA
         RIki+gLBHs2o428Z3ucXOLu02OJ9r8vMhr4GuMLA29ERmqWIUVMykWVS9lSySdt8gmse
         7zMqmnhaCQmR3QmyiY0rYY36oi0Xn0DN3bxJl3KLu7gRVQGQLPCKgtfkE4hfojCFdUNK
         xpzi6Hk2zNjuEigiIRtFwMiIaTHXR3QPwwZI4t6J0EcQwYegJHjVlNnPnFDqv+Nn1Euk
         xSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104628; x=1785709428;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WXPhImrBERPbppuQB021OFH7MVznckDFLoOQIpa5uHc=;
        b=c/UCPlMhl6L1HPFx/NIZ0qEgA+ZO8eZzkP9PR1bTK7aNFGRTEIxvlGng5ydCw3PteF
         1qZqbWAdA2LdbKnmgeBRs2ku/sr1G0mING2LNCQAZC4ymX6LckUBsCzJkxd5oJvQcaB5
         trMtLhBIEmpRXAgIkrxhr5XlE3ku95DE+6W4g3KXuT9oFoH6hYJEvif0mTF+75c8D/xX
         jz1Drweyo9nE7JRh9Lhu117Qa15Rd5kD79y/M+s+VWDsRLzOd19KTOBDGs5wmJ0gHEGb
         mOBdoFEU++kZImmUj8MlO+mziySFUJOdQn7jqUHJ4Ds3+e4hEPA2qZUddcMW/B2XA4Ub
         4Okg==
X-Gm-Message-State: AOJu0YxUvDLWtoByWI7+6zgnga19el54Wxv91sQPMXVFrFJJEWvNkYXF
	b5s2buiSFPJYvqgJ6s/fqI4YCGCgj8o2+i6bncnoonKJJYNSsECR9uqLVsSjYSgL7jBjDoJmTR2
	y8KOgp/CSuMrv8w==
X-Received: from wmdd24.prod.google.com ([2002:a05:600c:a218:b0:495:46dc:fbb2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1382:b0:492:7142:f46e with SMTP id 5b1f17b1804b1-496b56f0f59mr68861155e9.2.1785104628082;
 Sun, 26 Jul 2026 15:23:48 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:51 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-18-6f5729aa9832@google.com>
Subject: [PATCH v3 18/26] mm/page_alloc: separate pcplists by freetype flags
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A061680005
X-Stat-Signature: kare3fcbe3bt55ezxsu4dyyxbe9tsfz5
X-HE-Tag: 1785104629-82675
X-HE-Meta: U2FsdGVkX191hOlqZPBdEBk/JW0vQCFM18mfF43BSSGP6xompilKSwhoqCm21d0BZBsihpdtxwI2kUxuWyhCfXZAZG0uJw3muuLGrEkRLf9ywv4VDxSC+/Q7aU4snQZupnpvoUTOdE8gahnswyiWuLUUjP8BoSgFV3ie0m7Ld6W8PEneWpNZ8N17nedkoqwCy6jPS+vIeB3SaMj2j2Apa4AGF01CUagC4OtrpTr0b7xU0q8tA6sn+lEfqRBN2fS3d6na7WCLuHiuIahM1LCXD1/l8uOJXzQP/9iqYYZA4VM0m3u491vb71a422tBBqCnlCz6BNelb7sdIAvj3xPbGbNsx5JGmYrnTqyQfzZiMIy0yrVZqDYae61oe5jarpX62BHGHsJvJwvdQxcBoKC9llCh+UZ20Ks0gMWK5qqfNuxEIxRjoSncxKaMvyEhvYtUjyW8RMzFxJJxfEtLh5PlBW2cdChigM4jtZrxAqA4P+srvJHurV9G9PDPKhDgoiFkk9fJHK/n5Bgr6l2CDVVXM34ENL9u31h5qSvFSFI/4Ln0y2jQM9SKv33wjgMvDzdcGn0EOZjvD9HH9eYH6ziEs2Y1Kl9SpGnRoXr8nW/xgc94MJAjU/sskkAs+SgPfKlYX8JOPQhNe/HzspopYSj6Ty4vcbCIhUh1ZZm+9mpfdQVx3y3TJ5A6rzHt5EZtCgKP26g0N0VlUCDrDEnVcSbEa6Kz1M5JG+MH2qkYA1hCbLyKsxlqKlAXof10HViheJdsEJQrGZA1gmsEi+2SqZnkF166GrPR4I8G0KZ3hP8XQnDqwAGUxgQlwNcB6o1ixHwTovVXfuvxnKUOweLyAObhGnL3xcotTPgTRj1TlfMrsruuW3+OMT4gnsvElOyWLdgxrzUiED3K2pnPfmQzku9rqSNBXYpTyzq1xIifkz7A4NgEZs2h3tnucXPMjONDHFAH949ytgerW19oHa+nko3
 aymiN3PT
 HhMpQfw+jl7PSZXr4fbIn7Jf4ad3vRR77aOFbQn0eqkh9X/TXlSO9tPv7j1SINMuBXYlj9uITw2dvCNuOKqe7D1c5NxDEmJi6FnUmFzYlP63ZDptqp57sTrNrKbzKMn2YmwgZybVTsfhft+vZy2Fn0dNWKx4Vx5Gynk+RldJZKAiYlLZVybqwblBURxjuwnJAGRUcjzCWhFhGJuCYTdUTrcyg51iDsYPef0fEUyNxU22Mm6B/+5ejF5AUxanVTJMjItxSjV8J1wB22zgzv2WbNS1HvvpJ88ESylue9YCzULDdTZSGXvQFf8ftgR9L3YHJnNZBUgci9bsjHI7nJ0LOqqU5nlGFIt0bhTerWw732sQN1Mj3DlZrFZaxkEO28DLvkiftkjyzILu7sxY83pukgW1LKC2ePMv9ZEnXBovrg/gEvLoytpcgNQOEDpO+bfNV3eN/FxuvBT9iJPeQuoa5FdE4q2EdqfDoOLXw1dev7OPLx+egUDz9pP84fmsIIM7TagROjVLaVepx3Vf0ImYFv39PV6LCNlqBfzbQr9OBoJ6mI5MAE2xokV1PkN5ekG4yYZOmPL3rKGFY+f5C+bgKPIXUsbSvwqM9fGeDgrYzolLu9/BrBuva8EC5mNCnZOudn33qGJCkPVogAvX/vmjICtf3YTyWxV8IyIx0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The normal freelists are already separated by this flag, so now update
the pcplists accordingly. This follows the most "obvious" design where
ALLOC_UNMAPPED is supported at arbitrary orders.

If necessary, it would be possible to avoid the proliferation of
pcplists by restricting orders that can be allocated from them with this
FREETYPE_UNMAPPED.

On the other hand, there's currently no usecase for movable/reclaimable
unmapped memory, and constraining the migratetype doesn't have any
tricky plumbing implications. So, take advantage of that and assume that
FREETYPE_UNMAPPED implies MIGRATE_UNMOVABLE.

Overall, this just takes the existing space of pindices and tacks
another bank on the end. For !THP this is just 4 more lists, with THP
there is a single additional list for hugepages.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h | 11 ++++++++++-
 mm/page_alloc.c        | 37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 78455285dda7c..2533a228f71fd 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -789,8 +789,17 @@ enum zone_watermarks {
 #else
 #define NR_PCP_THP 0
 #endif
+/*
+ * FREETYPE_UNMAPPED can currently only be used with MIGRATE_UNMOVABLE, so for
+ * those there's no need to encode the migratetype in the pindex.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define NR_UNMAPPED_PCP_LISTS (PAGE_ALLOC_COSTLY_ORDER + 1 + !!NR_PCP_THP)
+#else
+#define NR_UNMAPPED_PCP_LISTS 0
+#endif
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
-#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP + NR_UNMAPPED_PCP_LISTS)
 
 /*
  * Flags used in pcp->flags field.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 33b7d354e1e03..30ba61c20209c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -690,8 +690,25 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(int migratetype, int order)
+static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
+	int migratetype = free_to_migratetype(freetype);
+
+	VM_BUG_ON(migratetype >= MIGRATE_PCPTYPES);
+	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER &&
+		(!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) || order != HPAGE_PMD_ORDER));
+
+	/* FREETYPE_UNMAPPED currently always means MIGRATE_UNMOVABLE. */
+	if (freetype_flags(freetype) & FREETYPE_UNMAPPED) {
+		int order_offset = order;
+
+		VM_BUG_ON(migratetype != MIGRATE_UNMOVABLE);
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			order_offset = PAGE_ALLOC_COSTLY_ORDER + 1;
+
+		return NR_LOWORDER_PCP_LISTS + NR_PCP_THP + order_offset;
+	}
+
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
@@ -704,8 +721,18 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 
 static inline int pindex_to_order(unsigned int pindex)
 {
-	int order = pindex / MIGRATE_PCPTYPES;
+	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
+	int order;
 
+	if (pindex >= unmapped_base) {
+		order = pindex - unmapped_base;
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    order > PAGE_ALLOC_COSTLY_ORDER)
+			return HPAGE_PMD_ORDER;
+		return order;
+	}
+
+	order = pindex / MIGRATE_PCPTYPES;
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
@@ -3007,7 +3034,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(free_to_migratetype(freetype), order);
+	pindex = order_to_pindex(freetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -3545,7 +3572,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	list = &pcp->lists[order_to_pindex(freetype, order)];
 	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp);
 	if (page) {
@@ -5428,7 +5455,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
+	pcp_list = &pcp->lists[order_to_pindex(ac.freetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */

-- 
2.54.0


