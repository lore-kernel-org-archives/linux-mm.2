Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 975B5D0D14B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2DB6B0092; Wed,  7 Jan 2026 13:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61056B0093; Wed,  7 Jan 2026 13:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41D76B0095; Wed,  7 Jan 2026 13:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD1166B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:09:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BF4E13AFE2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:09:52 +0000 (UTC)
X-FDA: 84305956224.22.48FAB9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1034140008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:09:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UMMAYpU/";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767809390; a=rsa-sha256;
	cv=none;
	b=8CMtW/SIVZnTw6vb8IXBvzYIFa167eq23QNJWO3+PO7E230Ek0ScEZMHyXgI4ydc3ZZ7hh
	+Wu2Q2QJE/1Zhhr8n2QIRq31r4wMz4Uij7iPRT4Mja1AhzBIZ9R7DAES86zufP166A18QH
	9FXHd/PCIcWcyJBDXJ9BGGmT2ir50mE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="UMMAYpU/";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767809390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f22PrLbUi3Lro0fcE79fpEnUtHtVjrQaQWKf77NKVos=;
	b=3xch5CdkGDdhyg5bknlYtbTYD9jFEcsS/WZiCq3zAffbhUbcXW6C4GPYqmADvTzUIVYl4W
	bax/KxZcL43yyAWT910hbI94aSsg78BZOyu0uGeP+AWAyNtlt+NRG5z6PIS7/EpxNo82jj
	pcIwNXIoo0CMf4JF3RD6EEwGYVinl0Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E348C60018;
	Wed,  7 Jan 2026 18:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBD2C4CEF1;
	Wed,  7 Jan 2026 18:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767809389;
	bh=zULTtKsMzAyt4aSvpU93XsqGrXwJgfF1rRbt22E56lA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UMMAYpU/qfIQcdczhhy7/NHEn7WAiO10dQFjipfvRkGlCIU2rOsPvOmQ05azN/OFg
	 dL4DK1FPWR4ZW5pMeGYvO28PS88EwYg1szmleOqoozgc5Z4602tSOL2n8QzGFJ5nSc
	 ySV5weYxiqP+H0ybMSfqRROlSMmfvFrzTgzT8jVM=
Date: Wed, 7 Jan 2026 10:09:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v11 0/8] mm: folio_zero_user: clear page ranges
Message-Id: <20260107100948.a059084c9f8dd8cbaf864c57@linux-foundation.org>
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1034140008
X-Rspamd-Server: rspam10
X-Stat-Signature: w7e619rn89n6xaz6hwbb1r5nezeesh75
X-HE-Tag: 1767809390-668592
X-HE-Meta: U2FsdGVkX18iqFyzk522NWZG/iZ7aT+kBWGh50H/R1jKM67hDAxjJcGcJzMWmkRdtClnhDIjux+x5DvoMqZNWGYsabSwkN4TAT7ecCRyL2xGJuHcb2NoBeTKS1ddHDH394KggpGqQcGASDGiD14IMF0KBo3Ho+6G3jaiEYVxuBvmNA69a2hs+CMuiabiQ+W8HxxKzXUrjJpkzbL2+f0Fp/Pgg/pgEZ7jhrfeTEPFfK1gukhuP12NpEN9cvrVGrdaGYqrcrxU9RKZsP7dEmZ943Pi+/EYrsGTiXkEU1nVd5MC/gofGbZ8EAxVVrSeptsBteoLqOhQ3ukvXLiK8vTDgJHZbPe+of1mg5kE+Ys1mM3HWHQnh2XO6isFd7XSSvEQZJKM94tXz3UDPN09hjs+/eayXopUiWX/S54QLt2+2ycAer69G8V7kCSjpBbWwUIiT/rxl2XIYSToRmpRMqsAnZ54IDJphsX8nHDbSs4K/+flsjEb3zUyFpGbxWZ3cdfo+VOqT75M0HKprVAt6DxpdF25WA0n+eoqwOUbwRcYowACIeQ/qVhQrbrrZpaNfEh6U2XS4kzZLEbwQ/LEoKWNKst8s9lJgmBakB0ZSMmSqo3Y4il6rq5V1JfusuuI1wA+CJTW3l6tTOQpt/P3/Gucp7CUDez5VKIXcoekMN6cLrcixMEtiMrt8ijikcayXgk/CbDuxgWiZVp0jONQSz+K3QT9gHwk/G4GAncXHnGbR5b/ITAA2qzWK7rgoRbrBSnSZU8L+BaZGOGVuD3qAzDUqMNdDAiWPenQjBwBKUdAnlOooZper9zJ4tP9F+ETwOOLCVPmQy5v1GPrtCiEyzKgCYqP0V/amT03zVNWrpOzprOKJ9ckKBcQnn5nRm2DYieRIGWnHMi4fj83E9iC6Oti3C8FNvMgJt58SqF1okKYD0GLtlsbcSMJDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Jan 2026 23:20:01 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> Hi,
> 
> This series adds clearing of contiguous page ranges for hugepages.

Thanks, I updated mm.git to this version.

I have a new toy.  For every file which was altered in a patch series,
look up (in MAINTAINERS) all the people who have declared an interest
in that file.  Add all those people to cc for every patch.  Also add
all the people who the sender cc'ed.  For this series I ended up with
70+ cc's, which seems excessive, so I trimmed it to just your chosen
cc's.  I'm not sure what to do about this at present.

> v11:
>   - folio_zero_user(): unified the special casing of the gigantic page
>     with the hugetlb handling. Plus cleanups.
>   - highmem: unify clear_user_highpages() changes.
> 
>    (Both suggested by David Hildenbrand).
> 
>   - split patch "mm, folio_zero_user: support clearing page ranges"
>     from v10 into two separate patches:
> 
>       - patch-6 "mm: folio_zero_user: clear pages sequentially", which
>         switches to doing sequential clearing from process_huge_pages().
> 
>       - patch-7: "mm: folio_zero_user: clear page ranges", which
>         switches to clearing in batches.
> 
>   - PROCESS_PAGES_NON_PREEMPT_BATCH: define it as 32MB instead of the
>     earlier 8MB.
> 
>     (Both of these came out of a discussion with Andrew Morton.)
> 
>   (https://lore.kernel.org/lkml/20251215204922.475324-1-ankur.a.arora@oracle.com/)
> 

For those who invested time in v10, here's the overall v10->v11 diff:


 include/linux/highmem.h |   11 +++---
 include/linux/mm.h      |   13 +++----
 mm/memory.c             |   65 ++++++++++++++++----------------------
 3 files changed, 41 insertions(+), 48 deletions(-)

--- a/include/linux/highmem.h~b
+++ a/include/linux/highmem.h
@@ -205,11 +205,12 @@ static inline void invalidate_kernel_vma
  * @vaddr: the address of the user mapping
  * @page: the page
  *
- * We condition the definition of clear_user_page() on the architecture not
- * having a custom clear_user_highpage(). That's because if there is some
- * special flushing needed for clear_user_highpage() then it is likely that
- * clear_user_page() also needs some magic. And, since our only caller
- * is the generic clear_user_highpage(), not defining is not much of a loss.
+ * We condition the definition of clear_user_page() on the architecture
+ * not having a custom clear_user_highpage(). That's because if there
+ * is some special flushing needed for clear_user_highpage() then it
+ * is likely that clear_user_page() also needs some magic. And, since
+ * our only caller is the generic clear_user_highpage(), not defining
+ * is not much of a loss.
  */
 static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
 {
--- a/include/linux/mm.h~b
+++ a/include/linux/mm.h
@@ -4194,6 +4194,7 @@ static inline void clear_page_guard(stru
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_pages
 /**
  * clear_pages() - clear a page range for kernel-internal use.
  * @addr: start address
@@ -4209,12 +4210,10 @@ static inline void clear_page_guard(stru
  * instructions, might not be able to) call cond_resched() to check if
  * rescheduling is required.
  *
- * When running under preemptible models this is fine, since clear_pages(),
- * even when reduced to long-running instructions, is preemptible.
- * Under cooperatively scheduled models, however, the caller is expected to
+ * When running under preemptible models this is not a problem. Under
+ * cooperatively scheduled models, however, the caller is expected to
  * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
  */
-#ifndef clear_pages
 static inline void clear_pages(void *addr, unsigned int npages)
 {
 	do {
@@ -4233,13 +4232,13 @@ static inline void clear_pages(void *add
  * reasonable preemption latency for when this optimization is not possible
  * (ex. slow microarchitectures, memory bandwidth saturation.)
  *
- * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
- * result in worst case preemption latency of around 1ms when clearing pages.
+ * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
+ * result in worst case preemption latency of around 3ms when clearing pages.
  *
  * (See comment above clear_pages() for why preemption latency is a concern
  * here.)
  */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
+#define PROCESS_PAGES_NON_PREEMPT_BATCH		(32 << (20 - PAGE_SHIFT))
 #else /* !clear_pages */
 /*
  * The architecture does not provide a clear_pages() implementation. Assume
--- a/mm/memory.c~b
+++ a/mm/memory.c
@@ -7238,10 +7238,11 @@ static inline int process_huge_page(
 }
 
 static void clear_contig_highpages(struct page *page, unsigned long addr,
-				   unsigned int npages)
+				   unsigned int nr_pages)
 {
-	unsigned int i, count, unit;
+	unsigned int i, unit, count;
 
+	might_sleep();
 	/*
 	 * When clearing we want to operate on the largest extent possible since
 	 * that allows for extent based architecture specific optimizations.
@@ -7251,69 +7252,61 @@ static void clear_contig_highpages(struc
 	 * limit the batch size when running under non-preemptible scheduling
 	 * models.
 	 */
-	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
+	unit = preempt_model_preemptible() ? nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
 
-	for (i = 0; i < npages; i += count) {
+	for (i = 0; i < nr_pages; i += count) {
 		cond_resched();
 
-		count = min(unit, npages - i);
-		clear_user_highpages(page + i,
-				     addr + i * PAGE_SIZE, count);
+		count = min(unit, nr_pages - i);
+		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
 	}
 }
 
+/*
+ * When zeroing a folio, we want to differentiate between pages in the
+ * vicinity of the faulting address where we have spatial and temporal
+ * locality, and those far away where we don't.
+ *
+ * Use a radius of 2 for determining the local neighbourhood.
+ */
+#define FOLIO_ZERO_LOCALITY_RADIUS	2
+
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
  * @addr_hint: The address accessed by the user or the base address.
- *
- * Uses architectural support to clear page ranges.
- *
- * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
- * pages in the immediate locality of the faulting page, and its left, right
- * regions; the local neighbourhood is cleared last in order to keep cache
- * lines of the faulting region hot.
- *
- * For larger folios we assume that there is no expectation of cache locality
- * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int width = 2; /* number of pages cleared last on either side */
+	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
-	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
-		clear_contig_highpages(folio_page(folio, 0),
-				       base_addr, folio_nr_pages(folio));
-		return;
-	}
-
 	/*
-	 * Faulting page and its immediate neighbourhood. Cleared at the end to
-	 * ensure it sticks around in the cache.
+	 * Faulting page and its immediate neighbourhood. Will be cleared at the
+	 * end to keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
 
 	/* Region to the left of the fault */
 	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
 
 	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
-	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
 			    pg.end);
 
-	for (i = 0; i <= 2; i++) {
-		unsigned int npages = range_len(&r[i]);
+	for (i = 0; i < ARRAY_SIZE(r); i++) {
+		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
+		const unsigned int nr_pages = range_len(&r[i]);
 		struct page *page = folio_page(folio, r[i].start);
-		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
 
-		if (npages > 0)
-			clear_contig_highpages(page, addr, npages);
+		if (nr_pages > 0)
+			clear_contig_highpages(page, addr, nr_pages);
 	}
 }
 
_


