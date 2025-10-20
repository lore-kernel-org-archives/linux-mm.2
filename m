Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82980CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 00:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4AE78E0005; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852728E0009; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E00C8E0008; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2818E0005
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5A134818E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:03 +0000 (UTC)
X-FDA: 84016577526.17.292D47B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 360B3A0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 00:17:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u3IZxZof
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760919422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ei07tRCM+AHUPWDR/dd3eg4DKS0PPHhz9cQIXO1h0Ek=;
	b=59tUvlqwbmZDKYiJkA/k1RLqACJTDSE7sEDHcD3p3TGkb7YW5b96TuqD8jzia30Xy0EK5Q
	UKB0zksXHjvzS+qgtdAP+apcHFVdFdYbZWx4PduFSkusvJHo4O4wJavDjCBgvULW9rXhJu
	mCEzXzaGi/qRFX79ukbagRgx1xm3hCQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u3IZxZof;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760919422; a=rsa-sha256;
	cv=none;
	b=dtku70Cr6KOopB4aJjmn8Uy/MsB03o3IRlT25Duq7JxeGJkgEyc1TvaBmt/U7KXdIq99VL
	xgQrkM1ala9mLGQJSYe0kvld8l5TB/qFs4amEOtTcLkKdUe5tdEcyKpNOCp2+mM/+Afvfy
	fkIaAAO+jEdsCPjKQ5v5Y44cx3MUA9g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ei07tRCM+AHUPWDR/dd3eg4DKS0PPHhz9cQIXO1h0Ek=; b=u3IZxZof/u6PDqnLQyjNUbAes8
	GdxWroRujnwwkJFIlpViMIBuvGxMNMuz72Waw4di7Uqg98HoJ8TMHbg1jXcYuhjitrPco7zL+JC3P
	sL8bzHax/pq3qVRE+QKSa1BRr9lkfdaOTg437sTlMfznibHg1Vv2VnLOyaIpk+qcZBH6liqERcnlo
	6vbHbsaPu+aSxPWkTtMj3+wf+YocWjVXOSKiPwbNEJs1D26YwYTAMDTgq9buxFPdvR6BD8K4YLwov
	5q6QkYPLzNaPgznj168MBC5xzCjJzvn+dqlj0Ho1PNI1/2it82f+56qa8p/BL/ZI2mu9IfyuAp6Dz
	TS8n3GQw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAda7-00000008tDZ-3bMk;
	Mon, 20 Oct 2025 00:17:00 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [RFC PATCH 6/7] mm: Add alloc_pages_memdesc family of APIs
Date: Mon, 20 Oct 2025 01:16:41 +0100
Message-ID: <20251020001652.2116669-7-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020001652.2116669-1-willy@infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 360B3A0009
X-Stat-Signature: sz8kooffybc67zdnpfx8u9oxtx4tr3pf
X-Rspam-User: 
X-HE-Tag: 1760919421-501153
X-HE-Meta: U2FsdGVkX19p+5GUQO67wpQqMlw0FLfKCizvb3yjV7ketPK1zKNO3ZBgUcGTz2S27GCFth2E8KPHpLofk7Hw/exx9kjz41jNKP/cpT4THuLon77xoAOBJlQGpAcvegOWMJMmLevvcnO/hJWMxlo5d/rh0MwXF2ZFQpA9kjGiKbDX1ivWC3ZcxZI29p0PB2T6JYEJsl7o9/da/mrPJd7cJSMjIuCRHCuJpXMgPNa3KYuy26x2jdXVrqKpOEI2BFPMEHIWgTBalZwjWocRqlK7jHiWG7DInZwakvBKypqPehHaLacE0H5ac21SrQEwqPXWzw7HTlZtaQv+Ocj1O8wIHKLz/iza3mFVddm07lDP+ZLpPq+KTgkJNtNVmjMpLX2m7gpyJPx6B3eyhQn7fwZJu3BQsdGRtrPKAOjrr6qm3WHoc/GTyFLJhdWRyPacclDcfoKvAwnArArcDYui17qHeL+LNAaQyPjV3ka6Alhv3akBr/Ubd5hvp7MVS4cR8ZKTPsC2f7VqqgfXr8taSJ7zuYvxowRV+zbRlXmin7zziKFgidtz31T4vcLkStkz3ErwMLvMFLKmUJ90TIeucqRUtVz0iuiEsACYaeXR7sp0tIbEK+q8aA7gvjm5Ibj6uWmXbSiYxLmYqEgCXRDgqKFxTK539DFHkuEML6Zpgx5CK9X7JaxvZRLIOq6noO9oF8fLIMVcJYIa/gNrqHbn27D+3/onLuAd1OXuUOdyBn3jMFCgPAvMCU50glqWsKlNCjqukkUHObbSikjTn9iiodpdSPJjKzB2v+oRe5kH40nUxEPS2QH/ZTZWbdq2BgbA71u72QarZ4Bq2bbtTKbSjaDqj5Jo7JdfjF75FFqXzf4OAk+1GnOvtZFJf7uHhnGeVEQFH3G0YK19dikzyheF92zh3Evw3aqWJFd5Jh/13jFTyDBwtk73dByfWAz0mHk/v2cr/VLvzeLZHv9ohK2jYM8
 tFmsn05+
 IVTusooG2xzPQFMd60FAITh48LKAYul6hcL+kCokcbmv49NYKqTyq8MRdKUkT1kCHx+kjZpAEkbHsUNoxL4jMmf5ZE4fVqWkPo9MpsQrGHPf2gxoXshbiTqJGfdD+EdURugfApnQmEcDnYLnC8UbdImrtFfyJKouGtH+qBziv45golVl8aG8OOHECqM56yLZMRwpnXV7JZAmovt3L7oMKfPlHJL1mzGzvYiyiTOb5XCOXUnD8HwfxLAOq/nzzRcceW5D+GEPSU+q/nYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the alloc_frozen_pages implementations into alloc_pages_memdesc
and add wrappers to keep the frozen pages users working.

This hasn't been widely tested; I bet the build bots will find something
I missed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/gfp.h      | 13 +++++++++++++
 include/linux/mm_types.h | 25 +++++++++++++++++++++++++
 mm/internal.h            | 13 ++++++++++---
 mm/mempolicy.c           | 28 ++++++++++++++++------------
 mm/page_alloc.c          | 12 +++++++++---
 5 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0ceb4e09306c..6e13e0b829f8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -225,6 +225,10 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct page *__alloc_pages_memdesc_noprof(gfp_t gfp, unsigned int order,
+		memdesc_t memdesc, int preferred_nid, nodemask_t *nodemask);
+#define __alloc_pages_memdesc(...)		alloc_hooks(__alloc_pages_memdesc_noprof(__VA_ARGS__))
+
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
 		nodemask_t *nodemask);
 #define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
@@ -315,6 +319,8 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 
 #ifdef CONFIG_NUMA
 struct page *alloc_pages_noprof(gfp_t gfp, unsigned int order);
+struct page *alloc_pages_memdesc_noprof(gfp_t gfp, unsigned int order,
+		memdesc_t memdesc);
 struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order);
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *mpol, pgoff_t ilx, int nid);
@@ -325,6 +331,12 @@ static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order
 {
 	return alloc_pages_node_noprof(numa_node_id(), gfp_mask, order);
 }
+static inline struct page *alloc_pages_memdesc_noprof(gfp_t gfp,
+		unsigned int order, memdesc_t memdesc)
+{
+	return __alloc_pages_memdesc_noprof(gfp, order, memdesc,
+			numa_node_id(), NULL);
+}
 static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
 {
 	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
@@ -339,6 +351,7 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
 #endif
 
 #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
+#define alloc_pages_memdesc(...)		alloc_hooks(alloc_pages_memdesc_noprof(__VA_ARGS__))
 #define folio_alloc(...)			alloc_hooks(folio_alloc_noprof(__VA_ARGS__))
 #define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
 #define vma_alloc_folio(...)			alloc_hooks(vma_alloc_folio_noprof(__VA_ARGS__))
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..f5d9e0afe0fa 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -38,6 +38,30 @@ typedef struct {
 	unsigned long f;
 } memdesc_flags_t;
 
+/**
+ * typedef memdesc_t - A typed memory descriptor.
+ *
+ * The bottom few bits of this encoded pointer determine the type
+ * of the memdesc.
+ */
+typedef struct {
+	unsigned long v;
+} memdesc_t;
+
+#define MEMDESC_TYPE_PAGE_TABLE		15
+
+static inline memdesc_t memdesc_create(void *p, unsigned long type)
+{
+	VM_BUG_ON((unsigned long)p & 15);
+	VM_BUG_ON(type > 15);
+	return (memdesc_t) { .v = type | (unsigned long)p };
+}
+
+static inline unsigned long memdesc_type(memdesc_t memdesc)
+{
+	return memdesc.v & 15;
+}
+
 /*
  * Each physical page in the system has a struct page associated with
  * it to keep track of whatever it is we are using the page for at the
@@ -126,6 +150,7 @@ struct page {
 		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
+			memdesc_t memdesc;	/* All pages, not just tail */
 		};
 		struct {	/* ZONE_DEVICE pages */
 			/*
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..15d64601289b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -824,15 +824,22 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
-struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+static inline struct page *__alloc_frozen_pages_noprof(gfp_t gfp,
+		unsigned int order, int nid, nodemask_t *mask)
+{
+	return __alloc_pages_memdesc_noprof(gfp, order,
+			memdesc_create(NULL, 0), nid, mask);
+}
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 #ifdef CONFIG_NUMA
-struct page *alloc_frozen_pages_noprof(gfp_t, unsigned int order);
+static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
+{
+	return alloc_pages_memdesc_noprof(gfp, order, memdesc_create(NULL, 0));
+}
 #else
 static inline struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order)
 {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..866d6609a758 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2338,7 +2338,7 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+		memdesc_t memdesc, int nid, nodemask_t *nodemask)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2351,9 +2351,11 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	 */
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask);
+	page = __alloc_pages_memdesc_noprof(preferred_gfp, order, memdesc,
+			nid, nodemask);
 	if (!page)
-		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL);
+		page = __alloc_pages_memdesc_noprof(gfp, order, memdesc,
+				nid, NULL);
 
 	return page;
 }
@@ -2362,6 +2364,7 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
  * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
  * @order: Order of the page allocation.
+ * @memdesc: Memory descriptor.
  * @pol: Pointer to the NUMA mempolicy.
  * @ilx: Index for interleave mempolicy (also distinguishes alloc_pages()).
  * @nid: Preferred node (usually numa_node_id() but @mpol may override it).
@@ -2369,7 +2372,7 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
  * Return: The page on success or NULL if allocation fails.
  */
 static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
-		struct mempolicy *pol, pgoff_t ilx, int nid)
+		memdesc_t memdesc, struct mempolicy *pol, pgoff_t ilx, int nid)
 {
 	nodemask_t *nodemask;
 	struct page *page;
@@ -2377,7 +2380,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, memdesc, nid, nodemask);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2399,9 +2402,9 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 * First, try to allocate THP only on local node, but
 			 * don't reclaim unnecessarily, just compact.
 			 */
-			page = __alloc_frozen_pages_noprof(
+			page = __alloc_pages_memdesc_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL);
+				memdesc, nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2413,7 +2416,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	page = __alloc_pages_memdesc_noprof(gfp, order, memdesc, nid, nodemask);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2432,8 +2435,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *pol, pgoff_t ilx, int nid)
 {
-	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
-			ilx, nid);
+	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order,
+			memdesc_create(NULL, 0), pol, ilx, nid);
 	if (!page)
 		return NULL;
 
@@ -2473,7 +2476,8 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 }
 EXPORT_SYMBOL(vma_alloc_folio_noprof);
 
-struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
+struct page *alloc_pages_memdesc_noprof(gfp_t gfp, unsigned order,
+		memdesc_t memdesc)
 {
 	struct mempolicy *pol = &default_policy;
 
@@ -2484,7 +2488,7 @@ struct page *alloc_frozen_pages_noprof(gfp_t gfp, unsigned order)
 	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
 		pol = get_task_policy(current);
 
-	return alloc_pages_mpol(gfp, order, pol, NO_INTERLEAVE_INDEX,
+	return alloc_pages_mpol(gfp, order, memdesc, pol, NO_INTERLEAVE_INDEX,
 				       numa_node_id());
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..c1451ca0acc1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5144,8 +5144,8 @@ EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
-		int preferred_nid, nodemask_t *nodemask)
+struct page *__alloc_pages_memdesc_noprof(gfp_t gfp, unsigned int order,
+		memdesc_t memdesc, int preferred_nid, nodemask_t *nodemask)
 {
 	struct page *page;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
@@ -5205,9 +5205,15 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	trace_mm_page_alloc(page, order, alloc_gfp, ac.migratetype);
 	kmsan_alloc_page(page, order, alloc_gfp);
 
+	if (page && memdesc.v) {
+		unsigned long i, max = 1UL << order;
+
+		for (i = 0; i < max; i++)
+			page->memdesc = memdesc;
+	}
 	return page;
 }
-EXPORT_SYMBOL(__alloc_frozen_pages_noprof);
+EXPORT_SYMBOL(__alloc_pages_memdesc_noprof);
 
 struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask)
-- 
2.47.2


