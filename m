Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEA1C5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0846B009D; Mon, 10 Aug 2026 12:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1612A6B009E; Mon, 10 Aug 2026 12:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E5D6B009F; Mon, 10 Aug 2026 12:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1F856B009D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:28:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E4E81A0220
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:28:04 +0000 (UTC)
X-FDA: 85085891688.09.693EF61
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A97240008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:28:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BuqO6uAK;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EANdORJlqyqj5ePn4ATBwyvNejleE/hNFHl3jIiiuyo=;
	b=5EwdUvy+Qk+UWyai7t1FYAmqsFJfXn9lMdsHwqpboIKu1KR91qfF/xkl6OcSOYczFpDxSA
	RFcS8Cto0YPMspZvnmOJbo56vaIEKFOJn7o390NjDst/anUEjoGYuF1r+En4np+pA/lAKb
	b5Y3h7cJiCu27yaVL5jmYSma7liFrj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379282;
	b=2SJ0CCUjpvrkL9nTo44oyiWkQ3p2vjgFGfS+I53xo8bSkqF+UfNW+Z6kGV5U2TGOfKsi4V
	xCK+lc2VKz/oyVXY6jQK8O1jAMJtJbPDoML8YBaqRbxuuE/TG5lMpwMYvTLhQ13Qelrd0R
	/BDydonecpPA5jV3yRwqI1dAaC1BWFI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BuqO6uAK;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EANdORJlqyqj5ePn4ATBwyvNejleE/hNFHl3jIiiuyo=; b=BuqO6uAK48+UcGiJ3utN+DEA8n
	UsFiOfuSls7t4wj+LY291I5PwI7KM361FqAYM7LlSxvfna4Gh12i4UL8VkqpdBnzVpUPcSmeb8eME
	zBAKhzamnYXVqxbNdKoeYNgsvFka24ApTFXDzZb2ocWWEJdrnxYefCHDDFO2EZ8K/jg3KxDMssac8
	wOk2Unsunhg1h6R70QtRAMZcUkWwKA05AIDoTdTliz+182f16U1c33g/SBwSxFL+0Y53S6kmQXbQC
	e3/lotKxcDf2tQB5YH6+rcJiDZSD/Bmihy6w9uNyQwf7oqpSJdiqE7HgOQm/A4xH1rnWhrNDa6Q78
	K74bYrBw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtSqg-000000006jU-1WbH;
	Mon, 10 Aug 2026 12:27:38 -0400
Date: Mon, 10 Aug 2026 12:27:37 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Mason
 <clm@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 PATCH] mm/cma: don't release CMA pages still in use
Message-ID: <20260810122737.030f8452@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A97240008
X-Rspam-User: 
X-Stat-Signature: e61sjuwax4mkdb9y7icherpx8ao6c181
X-HE-Tag: 1786379281-161399
X-HE-Meta: U2FsdGVkX19/nxS02CdVYZ9MBMItNyw2v73hiPJJRQGf2HhiHWoD4AyfiI/5EtKUQikBmBnTZuFrUwbzrgu3eQxXYhv9D5ImH55gmd7yss1gmywPQHRRzRDbrMJ3Ty8ZXEx2V8SShGIDt0bgVh44tj1MbMcUjulfYhe1QD3J68mpXDJ2HkYlh0bBhJ4wOT6YLwOcfGHvJfJMcinbMp1Ydvb1FLjvnI40rPpQmycKD2zhgsily1OkdYQkwTXRbuf8+MXdPzIleOevVGXk5n3otovlDaLSn3cl8S8SlOliMzzvliIuyu6S0OPZ/0jq4FiTLdqcWH56rWZQKvLZVIvoW/QONcQgd08SGqCQ+iTbo5syU0C1rRcP2HVAHeksNoNfc0Rc04agkwuZsds/iRMizvjciWCoiE+iH06bhwyeAGVlbuWQRy1EqJk2Rln1WDQMOxzuOmdV6fIO5OyychZwQ+Bp9ztUTMLg7kmpr/ZlNbdd35UO4ATQslyt3f4/KwZo/tuGNO5x2VU54njX90ruPApZ4IkLWkvo2QGDD8/PMuH+/MFW272Zz4o0aP2HISQmISlcPM0jleROsZm3pUjUTun3QET7Ufxr4Tj+PwvIUiJcb5UYcY7R6MmRbkWpX6iJnCwNgcedDmrEkjBsekSCr4l7NnCOMICpOwtN17KS29xSzMKIH60T42EBbNvbXrCmzbHKiwEvyYOkGeetVmbh37mRRBIDn9G8I2UxwCL4qN5klCDReCzgCx4ST/DHPtzbfcC8G7q/Rmd9rX01upwJbbwrVij88ZdTLSidhYjGSvL3uxszdA2eSmv/nN8deVqmMH0RGZXzsDOIeOAzP+X7I4Vn2M7o8gBzOOpa2blVyJdS5JgXA+woj2/uULDio0TP0F9d3DPHRRq690WpFGzamNHep1oKxqVeaF3XvbLj16zlQtZs5XWQ2/9JCMtg757d0pCDkpnm0755g4CrM2o
 3QtHzGxx
 GAyz5R01cZdefpeTkY2/7zzw0+RKq6RJueDZJRkculYX7TUkMZGHBMenG92Th5iwRfbaN8EYDc3P/UNcFb1JPG/pt7gBHqQGcx/gsFoZ9OWPmS5trUWAwzPKZfAHQLwMw32er6QEcMaIDjL5KB298fY4n95JJ39ag87wep44xR/cJ96MBoS5yhLzGCuMPcR80yXKGaG3m0sqgmbc1GNTCasxpsMtgYvIm78vvnbrY/IAj5eeV9krZIa26hm5dh8PmesF6vx6nsV6YulkcBsHxfAqSxaSK5i1KQpr1RrSrT121QladfRwfB+lKZNSfh0jUe+gRy6zpiyjjTbzFlpNXvGqvmlQFiTGgME9Ji2fhl7vLmT3ZnUjVmCxF8fyeheHO/Izr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a driver calls dma_free_contiguous() before quiescing DMA, the
page still has a reference from the device. put_page_testzero() there
returns false, WARN fires, but the code proceeds to
free_contig_frozen_range() putting a live page onto buddy and clearing
the bitmap. Later cma_alloc() hands the same PFN to a new owner while
the original holder still references it.

A concurrent put_page() that drops the last reference between the
testzero loop and free_contig_frozen_range() can double-queue the page
via page->lru, corrupting buddy lists.

Fix by freeing already-frozen pages in contiguous runs, while keeping
still-referenced pages. When any live page exists, a future cma_alloc()
on this address range will fail until whoever holds the extra references
frees those pages.

This change should be safe because nothing can get reallocated while it
is still in use.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
v2:
 - don't play clever games with the CMA bitmap, the page allocator
   alone will prevent re-use of not-free-yet pages
 - v1: https://lore.kernel.org/all/20260809210608.06b5ccb9@fangorn/

 mm/cma.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a13ce4999b39..cbf8dba8f077 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -998,7 +998,6 @@ static void __cma_release_frozen(struct cma *cma, struct cma_memrange *cmr,
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
-	free_contig_frozen_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -1018,18 +1017,45 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
-	unsigned long ret = 0;
+	unsigned long skipped = 0;
 	unsigned long i, pfn;
+	unsigned long base_pfn;
+	unsigned long run_start = 0;
+	unsigned long run_len = 0;
 
 	cmr = find_cma_memrange(cma, pages, count);
 	if (!cmr)
 		return false;
 
-	pfn = page_to_pfn(pages);
-	for (i = 0; i < count; i++, pfn++)
-		ret += !put_page_testzero(pfn_to_page(pfn));
+	base_pfn = page_to_pfn(pages);
+	pfn = base_pfn;
+	for (i = 0; i < count; i++, pfn++) {
+		if (put_page_testzero(pfn_to_page(pfn))) {
+			/* Add it to the batch. */
+			if (run_len == 0)
+				run_start = pfn;
+			run_len++;
+		} else {
+			/*
+			 * This page is still in use! Free the freeable
+			 * pages encountered so far, but skip this page.
+			 */
+			if (run_len) {
+				free_contig_frozen_range(run_start, run_len);
+				run_len = 0;
+			}
+			skipped++;
+		}
+	}
+	if (run_len)
+		free_contig_frozen_range(run_start, run_len);
 
-	WARN(ret, "%lu pages are still in use!\n", ret);
+	/*
+	 * Some pages were still in use! This should not happen.
+	 * Subsequent cma_alloc() calls to the same range will fail
+	 * until whoever grabbed the extra refcounts frees the pages.
+	 */
+	WARN(skipped, "%lu pages are still in use!\n", skipped);
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
@@ -1046,6 +1072,7 @@ bool cma_release_frozen(struct cma *cma, const struct page *pages,
 	if (!cmr)
 		return false;
 
+	free_contig_frozen_range(page_to_pfn(pages), count);
 	__cma_release_frozen(cma, cmr, pages, count);
 
 	return true;
-- 
2.55.0



