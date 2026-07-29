Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2690C54F54
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDDF6B0088; Tue, 28 Jul 2026 23:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E926B008A; Tue, 28 Jul 2026 23:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE71A6B008C; Tue, 28 Jul 2026 23:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B87276B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:04:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24B40805B8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:22 +0000 (UTC)
X-FDA: 85040320764.05.D0F891E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E42540006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RFU3thUo;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785294260;
	b=uyw+5tpdsXXhiJwPKnPB/do/H+maHYH5Wopthx8aKI5ogFhRNP7mp9cLqpQpImSy5GeQwa
	Jtcgx4ZJo0Qmz0Ra3Weh/zFWQQSxlI6djTEc9AvNQWzpgL6TFIxy9ZWeScScO1EujBjUJt
	92uJGpUIb+IXuGFf/LbSwBo/bacQWPU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RFU3thUo;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785294260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnyZ3/KMScOYQcPa4OKDfGbFIWpXwbci2L/UQ0Ba9X4=;
	b=aBoOgwNBBY5QpUgJKQN4LSJb1L8fZYTjn3cPIzUf08TvSXfBr2HsGblnYuyga5ly407l+R
	a7FVZTmINKv00kaEhGM1xBTB+vfSSNAw5utZMOTcJ0QLXqeDPtMHMutgFUDU6wMNqEuNHD
	fhU45SR7PyJ6t7xjUL3Eont/LDTKQXQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KnyZ3/KMScOYQcPa4OKDfGbFIWpXwbci2L/UQ0Ba9X4=; b=RFU3thUox8OPxfRaw4rafE+geG
	r4IbINqK20PV/x0Yb/7+bLu2sQ5qAQkD7wspOO8ujPCLJ85Xnd+uVhurusWPhTKHwjvXyTif5ZOS9
	z9ghiwJJBYYraehOLNsnEkxrU8RK7SJKlHVHjcU4RpI29W/CuS+jqYXx6XnXhnVWUrmrr42MO1k9K
	NEHW3+V8ALMQOTgGF3IdRrcaTo3ROQqqG4tG1P5Ap2VNUT6Eg7h/nbpxMUNx3v8DgAhCmUx/RXI9r
	rvaMhk/tq1ZkIO7obMb4ihiYvgLbBhD0iUhwjN1lGLuG3d/y1pg4rKM0m7rDd7iPpPEhpVvLFBEID
	YcAbsbxg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wouZ2-000000004ml-0TuW;
	Tue, 28 Jul 2026 23:02:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
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
	kernel-team@meta.com
Subject: [PATCH 2/2] mm/gup: batch contiguous PTE-mapped large folios in follow_page_mask()
Date: Tue, 28 Jul 2026 23:02:34 -0400
Message-ID: <20260729030234.2063885-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260729030234.2063885-1-riel@surriel.com>
References: <20260729030234.2063885-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oy5561box7okqhm6xikz3qj7q37z4tqp
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E42540006
X-Rspam-User: 
X-HE-Tag: 1785294260-336003
X-HE-Meta: U2FsdGVkX199LweDyTahEtAry90GTPM6dTsiNN9F6dRX7xu3IO/V7HPQYKzE1s69bDMWFKEpOnlC1UVwNZGynCggJxR17ltZToSuUxzIjtmhH+My50ivZ6lT44GjKq9wfN+AjwbjBP7ctinsD0sF3G/6S8sD0Hkb8e+2wDy+bZLIStbyyUQXxmbwpglEzlA+XvA1REeWobGJEL8OXR2nNPKyvz+WgY7wvs3J+aJXDjjIECHdhuIFz1cEupBcjs4BuW0U+wlfGITTO9FqprNE4VDUhVQiMErQQcs59TJUaq9au4QqB7t2JMO+Sv1e2hkIWAV5C4bZGoR3O28Ror3wSdcGf5gYg2aT6D98+fmYDXoTpQpjEk/t1r7II6R2hylgQD/olrgxzhANaKRkNyohrFqllzuDMYbMWSJtfuDG1NvtUnawrBVk5EpXzXRseP7eXVa3+AGsYrao6yKzFp7KPZIFhoW82mes5cUdit/UaD7IJHyVEt6+eT6vW7PReKVf6L4AP5Zj+aV29KBFpyBUZKKBRamVUtvKA1rhJpXCgIfYK4pAHUMJtHxx7K9Hc7ghEynbu7ZlkvMGd0w0QEAjSOHRbxPP+DwZ1wDL0AO04p8KhFwS7gY38/0p6v6dgnTQb2b1DgQY5WqPRJQ2cSW9wc1Q8Z2aKF2VaX9on7tyiW6MlILG1s+7uWnO8x2lWFE40UWm+2AS7OjWUpItDhFXevt6k7yndT63+NxDcbZnFz0yhjzpwt7VNpONu/4j61PMnBmnw64KcdxPAA9r5ezhV4v8kQm0Cnr87IblViyGbwgqAw6tofceNA0M9lAb+ZxKjG3OMxZPUKUgCCCxJJsnSi3r4Y4D7clqba9ygpDHfZ8doRgEuT5euGuvPaQomEgJ/CqgwKm8O8gePYj5rfvhLhJBrcvDcSSiTzA9VPTp9oVhZmBXGWsofUH9USbZDVfc3s2gLJupmc4rha12/yK
 QkSqRrLh
 sK25rp8SuwkjpNTqnW2OXXUCPubi37Qa/XuAVUxg1JdrIm9zNRlaR8uasQdjyU+dicRPf/u2Xfy8JMVLbDr1z16s+ZRpXJt06eVJFtgmWO2X+o/LyLcjfCREBL7/Onl7HcTagb+ASD5V8wdYaPzoR0anQcsjO5TDVCqZsbSJPCdIR7eZfxzeoyfUF86iXPN8kujc5rVEf1oOxyTjkEcqADFABCm/17w1sWwzQvj4ynAHHcCTiKimAb7bt61zt4tSJhgLogUC6Ir6GUhXI56+MUfMA1/WUSX+Y2X4IK6mGg9t3daDV2d34LVzEUNOH32oDQ+fh
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
index 3437cd3407d5..8c6ad1ee7ccc 100644
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


