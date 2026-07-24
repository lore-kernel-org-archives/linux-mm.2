Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B757C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABD06B009F; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC11F6B00A2; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C076B009F; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7AE6B00A1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B363EC01CF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:20 +0000 (UTC)
X-FDA: 85025115000.15.0F17DC4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id F3BAB140004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OJksZob7;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932219;
	b=lDmSaj8Sk8WAr0EHN9tOSARvUpds67YskoGPl22xVkKpEKZPEQgU17MaGS4sfWAqwq2GG+
	Qa7F5qcOg4CRtyHW21Vf59Nq83PLS5sSLKETcTWHnL827cXXbFeom+nYfvyBiXTX8ScaAf
	kDP21sKZGq3N+9oLOPROX4oDVoz35nw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OJksZob7;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nMsMXQjXiyA5qAYl7QT0yp1WELxZnCfyNHaXsTe27c=;
	b=joIfqwxI7CUhTcIV+K/furi2PlqlGSaQrakP35SdFwooCSkRDqKWjM5FwH6RiGB8+DGygv
	+qmzINqzTF8K7qh+RrVLV//5/6jw5uIFtqc4AEdPaIKjixOfwstx5+3xgyP0kBiuEk3vxe
	hI/KZQRTFa9TOyCon85wmnwb57yb52o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/nMsMXQjXiyA5qAYl7QT0yp1WELxZnCfyNHaXsTe27c=; b=OJksZob72/FPZ/ELTbhArp8gh9
	7UMXiNlaPpudxMXOBVJMUrfH+0aQhfhpbgKO5m3p6KJ+qYxLMuUeykJu14bVfe/Ju1UpbMLNT/Qpa
	JEKIKeIgeB81zgqkDkbdQOIqNwsfs0Zq4gmvITvR+9M8DH0FZS0HrBtO6PampJ6y2eQJDWsY38kvo
	86CVxhLsA43csRlQ5zd8+eqyGIFWYVas87aTFTGQLAk4aPUxHkl2g91w/AJAY2uR0AN9gJyEcv0LZ
	Cqb0CMQqR4pl5ZjnUMPZSUfOZZSZ9ajq7qGIf5+2+h2c+Zqygt7/PaQ83o9STEM9CcLRVBnuztl5e
	23N8lVDA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-28o2;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 11/12] mm/gup: batch contiguous PTE-mapped large folios in follow_page_mask()
Date: Fri, 24 Jul 2026 18:29:33 -0400
Message-ID: <20260724222934.1463812-12-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xpet9pa58pcxdzbebm19z1mcn9f46khw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3BAB140004
X-Rspam-User: 
X-HE-Tag: 1784932218-752431
X-HE-Meta: U2FsdGVkX196NCM/l35caTRz0t+b77bNSc3VUH3sPpBIBMFlQoxxMhJuqkqZK8jgGUqMSoRTlGfG7xYJ7eQMVDvUJZ5mjZWSA3ZlPGRrI6xgrkZ74JZ++wNMWLP2LUeQei8gOTYTP8FAPCfcP3U/GISp4Z/9bjKHYvmeL7vIIeshboDV5nnVQU17jimxLBA1y3KGNlyjbVEOUSWRGwttEPoeOoiGPvkEw99JVpNns+IDd6Rp3iuY+QNmGqfjetg/IT5dwIda6eikMWeW3LkHdys9UyezzYuHrRNlHqmLanBgkEyg3L6Lgc1FgwaaU/WoDkdxHw3ch5rDRiow57e9Hhb7zYRXGfWLeUnislSC0kj6Morc0OeaGs7D0TyeA008lGivEZVhFq2OOv3MIaAu49DQEBBHqmUfu8HPRSzGFR8h1GT0Ur/kFLc9HNuGKlaQi0A/oB/5zQOV86DW+v1X6B8eBa6nSC8pEIXbpoZYCpwTBSthleE5/NdAP/3sVXIyXL9baGWiNgfk739WeFSEYEEB2thlELbK/f2Hxj9027Ov6HugIhRNQqUO64msOXmIFmlYRN+rxFzF5fGYjpegTNdvizIV4kYNl9h96C2dQGQmY9J1SPfX2ZDYSPOyI9hgV0RlIvg8kCC9pkMWsS6j1tr6IOUku6SMjsKd5vFbH7KZxA2nk4TWUGFCosMW3SKwKeazwV+6VWi+cpy3H2yaMHtamZ30yN4kPyfvjE+JwLsznqkAya+Is75TUz7Vy8FH1PHA1EUBHLQi/1b+kMaj4hzMs0lw5rOUIPyUd2f64s29mdg6tsVzmmOSvm3WxZfLeR0eyU3QZdNHzk5ojJ9ZcLimAMFp9Lw+U2IZKYXRfjOoWJw1aEaNeO20MdGMah9ffIO51mguYWNs4q7sOQZCnoCStrbvbT8WRvXp7I7SZkR79rzpuYz0EoazdY12wo4GKZWduwi7MQ8J5Da36px
 V0zx3zKR
 /8GJkMPvuXbh5Lnm7au5NHFQqkd8siwkk6DnNW/wTn/ETC+QD7qCAH6j2SXdmILpcQJekXY8DYx/H1R7cNjKg6WJ+CruWRdgkwvZ80A4/yXseVbZNGC6lhx3FpekpR4E6Aj7eZ8eBIadLVjbZ8GsGf2iKMHYlAGeb/vo4/lAqHwv0MyDTmftxNqSREIbSj25+dn+zi5cxuO8Hm798fyiTSR99DHdISLDlnTJMJYHTJnQ8QxbQnzetMwisVZGT4Yr+K5Q0/yXOwS4G7hqNwKziEebLWrZg6d3C+q2HVH0eR5t97uli/HT85yMoa94IdKG7R6JK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() returns one page per call for a PTE-mapped large folio,
so __get_user_pages() re-walks the page tables for every page of an mTHP
even though the folio maps a contiguous run. The huge PMD and PUD paths
already return the whole mapping in one step.

Report the contiguous run for the PTE case too. follow_pte_batch() uses
folio_pte_batch_flags() to count consecutive present PTEs that map
consecutive pages of the same folio with a uniform write bit, bounded by
the page table, @end, the VMA, and the folio itself.

Keep the per-PTE guarantees that follow_page_pte() makes for the head page.
folio_pte_batch_flags() with FPB_RESPECT_WRITE stops the run at a change in
the write bit, so the whole run matches the head.

A writable run is safe for any access: a writable anon page is exclusive,
so gup_must_unshare() cannot fire, and FOLL_WRITE is satisfied.

A read-only run is batched only for a plain read, since FOLL_WRITE would
need a COW fault per page and FOLL_PIN would need a per-page
gup_must_unshare() check.

Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, the slow
pin_user_pages() path) on a 256 MB MADV_HUGEPAGE anonymous region in a
4 CPU VM, median get time over 16 iterations. Each folio size was confirmed
through the per-size anon_fault_alloc counters (4096 folios for 64 kB, 128
for 2 MB):

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  64 kB mTHP            3140 us      412 us   (7.6x)
  2 MB THP (control)      78 us       76 us
  4 kB base (control)   3010 us     3042 us

The PMD-mapped 2 MB THP already returns the whole mapping in one step, so
it stays fast and unchanged. The 4 kB baseline shows the per-page walk cost
that the 64 kB case paid before this change; only the PTE-mapped large
folio case improves.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index 96b00ddf7e04..4910c93ba003 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -805,6 +805,43 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+/*
+ * Count the pages, starting at @address and bounded by @end, that a PTE-mapped
+ * large @folio maps contiguously and that can be returned together with the
+ * page at @address: consecutive present PTEs mapping consecutive pages of
+ * @folio with a uniform write bit, within this VMA and a single page table.
+ * Returns at least 1.
+ *
+ * gup_must_unshare() and the write-fault check are per PTE. A writable run is
+ * always safe: a writable anon page is exclusive, and FOLL_WRITE is satisfied.
+ * A read-only run is only safe for a plain read; FOLL_WRITE would need a COW
+ * fault per page and FOLL_PIN would need a per-page gup_must_unshare() check,
+ * so those fall back to a single page.
+ */
+static unsigned long follow_pte_batch(struct vm_area_struct *vma,
+		unsigned long address, unsigned long end, struct folio *folio,
+		struct page *page, pte_t *ptep, pte_t pte, unsigned int flags)
+{
+	pte_t batch_pte = pte;
+	unsigned long max;
+
+	if (!pte_write(pte) && (flags & (FOLL_WRITE | FOLL_PIN)))
+		return 1;
+
+	/*
+	 * folio_pte_batch_flags() scans forward from @ptep, so the run must
+	 * stay within this page table: bound it by the PMD as well as @end and
+	 * the VMA, since a large folio can be PTE-mapped across a PMD boundary.
+	 */
+	max = min((pmd_addr_end(address, end) - address) >> PAGE_SHIFT,
+		  (vma->vm_end - address) >> PAGE_SHIFT);
+	if (max <= 1)
+		return 1;
+
+	return folio_pte_batch_flags(folio, vma, ptep, &batch_pte, max,
+				     FPB_RESPECT_WRITE);
+}
+
 static struct page *follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end, pmd_t *pmd,
 		unsigned int flags, unsigned long *nr_pages)
@@ -893,6 +930,14 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		folio_mark_accessed(folio);
 	}
 
+	/*
+	 * A PTE-mapped large folio can be handed back as a contiguous batch,
+	 * so the caller advances over the whole run in one step instead of
+	 * walking the page tables for every page.
+	 */
+	if (folio_test_large(folio))
+		*nr_pages = follow_pte_batch(vma, address, end, folio, page,
+					     ptep, pte, flags);
 out:
 	pte_unmap_unlock(ptep, ptl);
 	return page;
-- 
2.53.0-Meta


