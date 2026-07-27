Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44BEC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6F96B007B; Mon, 27 Jul 2026 16:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF446B0088; Mon, 27 Jul 2026 16:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6B96B008A; Mon, 27 Jul 2026 16:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0B46B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:18:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE3B31C0190
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:18:51 +0000 (UTC)
X-FDA: 85035670062.22.1FF0901
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0A672000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:18:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gTrwE1rb;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785183529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygkPJzP4i7m3xhcGa5HIHO57if4jnfOhcamPKPfP9O8=;
	b=QLvJT7EZbhy55gGKH/OocvibhXnvyVgX8tNPr21dOETruLf9vFQkFQqd87pl3bcVxx20ho
	kG54h1nidyDu/FQl1uEWcYML6bTBdVF8NdPBQ6P+bQlPBioJJbRVzGeDKlXFFlZaL+a9MV
	ZeTAUrdlPEnM7SnelxhC1BO7mYsYGhI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785183529;
	b=NWYn6KwGogv8pfsuJxy6w7Cmg3BXOnUA4i1D4BrU8RkjZTyUd9fbdbULweaujy7YsJKg4M
	Bwbjd70y7WHx2HllnSX2bdGe0XNHNeFmcqivQUdTZX54dxRbNiPBPzhrNB0aBVnxGWtJ5k
	mDhdquC2ki3+lD1yDSV+OdWAMoZfrA8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gTrwE1rb;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ygkPJzP4i7m3xhcGa5HIHO57if4jnfOhcamPKPfP9O8=; b=gTrwE1rbXxCizQa00mpnkHjx80
	K+e568OeDJYyEjo0oyXnc3QcqY1Mm5XSGg+SKFj+w6Yt3bSWGMUvN1JhXnZhMa6m8oBJ2PIiT0Ti/
	/xtPdRB+s37Mepcu1fdnbIwedCsQ3WlRDvxvVAr0IU+clMlh75Ut+BwtEEYBfqjmCdxWKQoF1nYik
	RmlAvEdECEzWxYbL1DcKrfXOH47GCwKOh1MdPyamERizTcUgleHlqWp5yVSa8k3X2ynJeAzeQIIDh
	OZA3/8/kDOxNX/j0TFWKP7ODgMuWYL89iClfQkOukgA2kuLhwHkYQ+gdBhtNZlFzQ/LxXiH8177vQ
	xk0uXi+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woRmf-0000000BO6a-12t3;
	Mon, 27 Jul 2026 20:18:45 +0000
Date: Mon, 27 Jul 2026 21:18:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v6 07/12] mm: Check individual hugetlb pages for poison
Message-ID: <ame9JVkltJCmSeu-@casper.infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
 <20260727181310.2671972-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-8-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0A672000A
X-Stat-Signature: g4r1cr46ociqz8ozn544oet1g8i395nf
X-HE-Tag: 1785183529-938715
X-HE-Meta: U2FsdGVkX1+w+SEjhqGtvYQLBExT1QrDIVy52dIRZYM64EQm7CER+p0yVUbVWWBNNg2Cge5jwwxwCmybdenxTr4aCp1c8DJ+V6VYeM0JDs2RHoYB3QtmkIiyWfh6ifty/jMiniPIPtP/1DY/3AiadBV7XArLxI7/XeMDYplC4WaQPlEiIgd5tlBOa/7hcL24eGsYRNBvjfv5UWbRAsXRrV62l7C9z7TNsmB3PR+oYSuoxHIwOab2e0PaqgjR80Z/b0hXS2P9JRR8HVJHjEA3QxXFjpsXIPE2NZTM4r+2nANccUMRfWU129kRYElBeWKwMxWxImOFp3JxhUmlHOoImDBteDS2g1H6ZgG7vJZTNkIkr93Ocl0t5KRyOw3ovJTIDueisyi+gPjSUoCPync7g3Huz6XfppxVSHRnyS4zNNhOVrUhcGAuV9cs95PTtkxihPjaWr1OG3AOfW1Cr2Vmqk5Khxx25g1n1VqHlWw9hXAJ75l9I2Ybzfq+6bWtMS52V2oIVp+dz8yZXCXhympaz1gQVxhWpiEMbtwOvCCBTVQPSh07vwPoixAFQsWA/qhGTTKSx3r6ZtPvSHxDOcG9oRkDvuVcgQAAipBCRwcRibF5OfHFOKeVKMS+T7yXQnlHpqZa8dgLVhT8SEd8LRvmzSuq5Pde7lcVZ5vhs83NrnGCLcVXbEX2I9CLMbeECujwnNK+vZOknvEqu3oXbyJa6jolA/OJE3jgNinOQFoUoo++DIP3NliRgt+rjW9H/K6wgBtbiFQc58U/j2MMQBqlMktVKGMIWfGWf/B4bc4UmLUJa5WNMcWaWnJOaPe7tH0pRcPnw/PyfbzRSGzeBrg7XB7d7zQ8jl4LZhO+swuGydsKThVDBRosA7pRZqthcIFqFJAyB2p9iZ1lCTAP+6qlGrMUowyK/LFUT2Oa/AS76gHcNwXda7FdY49W904u/gloE2CtFekS/Y/AOq2HmRG
 DH7vg0oS
 P5Q9IufyfGzu/AyFbYQvrj3TnJNnhv3NPbTVx4XETqbc2uWfgbl7HGMfmGAWQ7cb+5xaHmWZArvRg05qS/XkZJ4QDrLf6EadZ0OptkIecECiZd9vlyDIdkIrOCF/WOTnJVfE5ZXLs0JmhAsx6XsMNIb/yDUIorMTa1VOZpw0S8+AS0X1koed7VEuRV3HQEz4QgO21HoFbSQ/RuJSM32s6Sp9Wb1pj/0IUv60ZCZlurJbcadmtEw8AuycCzOKzMbUeJUeg9JfwPLdef9rVad7n4s7sUM+/FWjp0adWnIhmKXlZ528vzQsHFJ1i6hQl1+2/9tkh31fiXaJurthR80m5I1T8Os2JJ7DmUuOhGWnOiwrngTo6Zbo+jzQZ8hxEzH2zZjBP85l6vH9kS3aMwqtTBW+QbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [7]: [PATCH v6 07/12] mm: Check individual hugetlb pages for poison ---
> commit 576226d7d814aff0cfed4be691d0ccb82f1eb5c9
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Check individual hugetlb pages for poison
> 
> This commit modifies is_page_hwpoison() to check individual hugetlb pages
> for poison rather than returning true for the entire folio. It introduces
> hugetlb_unref_page_hwpoison() to safely evaluate the poison state using
> the hugetlb lock when the folio reference isn't held.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index e358f6a33d274..6ca7e1df7f735 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> 
> [ ... ]
> 
> > +/*
> > + * We have no reference on the folio containing this page.
> > + * The hugetlb_lock keeps hugetlb folios from being freed.
> > + */
> > +bool hugetlb_unref_page_hwpoison(const struct page *page)
> > +{
> > +	const struct folio *folio;
> > +	unsigned long flags;
> > +	bool ret;
> > +
> > +	spin_lock_irqsave(&hugetlb_lock, flags);
> > +	folio = page_folio(page);
> > +	if (!folio_test_huge_poison(folio)) {
> > +		ret = PageHWPoison(page);
> 
> This is a pre-existing issue, but does this create a TOCTOU race window with
> __update_and_free_hugetlb_folio()?
> 
> If a thread frees a poisoned hugetlb folio, it clears the PGTY_hugetlb type
> in __update_and_free_hugetlb_folio() under hugetlb_lock. After the lock is
> dropped, if another thread calls is_page_hwpoison(), it will evaluate
> folio_test_huge_poison() as false here and check PageHWPoison(page).
> 
> Since the freeing thread may not have reached folio_clear_hugetlb_hwpoison()
> to set PageHWPoison() yet, could this return false and cause an unprivileged
> or privileged PFN walker (like reading /proc/kcore) to access the page and
> trigger a Machine Check Exception?

Ohh ... Yes, look at that.

__update_and_free_hugetlb_folio() does:

        if (folio_test_hugetlb(folio)) {
                spin_lock_irq(&hugetlb_lock);
                __folio_clear_hugetlb(folio);
                spin_unlock_irq(&hugetlb_lock);
        }

        /*
         * Move HWPoison flag to each error page
         * which makes any healthy pages reusable.
         */
        if (unlikely(folio_test_has_hwpoisoned(folio)))
                folio_clear_hugetlb_hwpoison(folio);

We need to re-order these two.  I don't think we need to call
folio_clear_hugetlb_hwpoison() under the hugetlb_lock; I think the
ordering is sufficient.

Oh, I just found 5596d9e8b553.  These used to be in the other order.
Gah.  This is all horribly racy because memory-failure tries to do so
much without stabilising anything by getting a reference on the folio.

Fine, the easiest way to fix this is to put everything under the hugetlb
lock.

Also, why do we call folio_test_hugetlb()?  Obviously this is a hugetlb
folio.  Look at everything else we've done in this function.  It
made a certain amount of sense when it was introduced:

-       if (clear_dtor) {
+       if (folio_test_hugetlb(folio)) {
                spin_lock_irq(&hugetlb_lock);
                __clear_hugetlb_destructor(h, folio);
                spin_unlock_irq(&hugetlb_lock);

but now it just looks weird to me.

Oh.  Because we can clear hugetlb in remove_hugetlb_folio() unless
the hugetlb folio is HVO?  And ... similarly in other places.

OK.  So before we clear the hugetlb flag _anywhere_, we need to move the
hwpoison flag to the precise pages.  So let's do a helper function?

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a557f7fa61a4..5be981064a26 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1370,6 +1370,26 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int
 }
 #endif
 
+static void folio_try_clear_hugetlb(struct folio *folio)
+{
+	/*
+	 * We can only clear the hugetlb flag after allocating vmemmap
+	 * pages.  Otherwise, someone (memory error handling) may try to write
+	 * to tail struct pages.
+	 */
+	if (folio_test_hugetlb_vmemmap_optimized(folio))
+		return;
+
+	/*
+	 * Move HWPoison flag to each error page
+	 * which makes any healthy pages reusable.
+	 */
+	if (unlikely(folio_test_has_hwpoisoned(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
+	__folio_clear_hugetlb(folio);
+}
+
 /*
  * Remove hugetlb folio from lists.
  * If vmemmap exists for the folio, clear the hugetlb flag so that the
@@ -1402,13 +1422,7 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		h->surplus_huge_pages_node[nid]--;
 	}
 
-	/*
-	 * We can only clear the hugetlb flag after allocating vmemmap
-	 * pages.  Otherwise, someone (memory error handling) may try to write
-	 * to tail struct pages.
-	 */
-	if (!folio_test_hugetlb_vmemmap_optimized(folio))
-		__folio_clear_hugetlb(folio);
+	folio_try_clear_hugetlb(folio);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
@@ -1482,17 +1496,10 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	 */
 	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
-		__folio_clear_hugetlb(folio);
+		folio_try_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	/*
-	 * Move HWPoison flag to each error page
-	 * which makes any healthy pages reusable.
-	 */
-	if (unlikely(folio_test_has_hwpoisoned(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	if (folio_test_hugetlb_cma(folio))
 		hugetlb_cma_free_frozen_folio(folio);
@@ -1584,7 +1591,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
 			list_del(&folio->lru);
 			spin_lock_irq(&hugetlb_lock);
-			__folio_clear_hugetlb(folio);
+			folio_try_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
 			update_and_free_hugetlb_folio(h, folio, false);
 			cond_resched();
@@ -1609,7 +1616,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 			} else {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
-				__folio_clear_hugetlb(folio);
+				folio_try_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
 				update_and_free_hugetlb_folio(h, folio, false);
 				cond_resched();
@@ -1642,14 +1649,14 @@ static void update_and_free_pages_bulk(struct hstate *h,
 	 * should only be pages on the non_hvo_folios list.
 	 * Do note that the non_hvo_folios list could be empty.
 	 * Without HVO enabled, ret will be 0 and there is no need to call
-	 * __folio_clear_hugetlb as this was done previously.
+	 * folio_try_clear_hugetlb as this was done previously.
 	 */
 	VM_WARN_ON(!list_empty(folio_list));
 	VM_WARN_ON(ret < 0);
 	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, &non_hvo_folios, lru)
-			__folio_clear_hugetlb(folio);
+			folio_try_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 


