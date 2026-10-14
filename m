Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D611CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369D66B008C; Wed, 14 Oct 2026 12:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AF56B0092; Wed, 14 Oct 2026 12:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2308D6B0095; Wed, 14 Oct 2026 12:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3D336B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:30:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E93B3A06BB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:30:53 +0000 (UTC)
X-FDA: 85321770786.08.70039EF
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf14.hostedemail.com (Postfix) with ESMTP id BEC8310000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:30:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3yIi4uE;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791995452;
	b=mbMdie0DpFPviy8YFW+PZt57KJHlbbfJZ0S/9RGl0J5Rw8y5HQ5+YxCnNu6uhyLBCOikI7
	xaLx6ta/Ven8q7rbfd3s4pZXSuJwn3KFyBYnqphCAoSNcJJEJEKGM8NK45Tb1IMtkqZGtQ
	EsE0zaG7Jh6cSE9p6+FDkiag2BKwLQk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3yIi4uE;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791995452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuTZK0aEsxrrGIjTOXTTzaYE6LzxOpR8nAqifDnEhCY=;
	b=wTk1272TWRZ/H6XMYaQD/8dVgizavftR3ELK3JkzzOeVAqVSg9v4ewEJwHvaH4FZHbjffO
	7hbBTh0TfI8KL0tV46jZPyEKj1wZrBYFzAguCKk/USUgkdvedqdgQEkfGukz9LX9T+8dlC
	pue50Hr358h1KfH6hFcv4UlAj/WqeSU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dw453SjKRb4006gix6zhYjhyw8h2zLucTTilf+CwNnE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791995450; v=1; x=1792600250;
 b=r3yIi4uErvQk3aLwnT7PwDpTB4yWB+1CYIXSUqIJm9A3Jffi86vuBrOQcxcmPc7uLrs6eqXc
 vbcxYE6ma5IXv9mISCBjIvfJluES68Y+VI2tXLF0Or5x6DAz2SZGJzkWMIyGuSqqFe0UgSM4b/c
 r0IauxsTNyMo2Li7PxRJolCI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b89656d6ed486c36;
	Wed, 14 Oct 2026 16:30:50 +0000
X-Mizu-Trace-ID: b89656d6ed486c36
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	huang.ying.caritas@gmail.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	ryan.roberts@arm.com,
	hanchuanhua@oppo.com,
	kas@kernel.org,
	kylebot@openai.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
Date: Thu, 15 Oct 2026 00:30:43 +0800
Message-ID: <20261014163043.39233-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BEC8310000E
X-Stat-Signature: hb118nkzixpxk7814591ugmikad4ycid
X-HE-Tag: 1791995451-311903
X-HE-Meta: U2FsdGVkX1/Sy8c2c6tUAls8XnBgbpjglRdEGHfZcWeIeELyr8+oxnNHA99gguVSmPZ+kX0NfMlW7IXAvsPfnm4Tof4fdBwhkdTRBglqdp1Fm12AAG1DfwH4iS00vFESPKxZrpE8GRhusLMNbVI/vRWF7s5oPlxlMcndEkkzvKD4WyZJnTSvK/yNAuXZoWjS+BHsiaAMZ6uOerhW5Hcvb590GFdICFvWBBJxaveBPDuMnERxGCEEAbiziBPCTzcQRNv1BYmMb1kjN4JpGS77BANZsoev8ElQR+uT19amyGHvM3rI45ti+abYr6AD3kt4h54tRtnj+Jq+gj2JirgAAyPaH0cGqVOwEKm8BnPQln5fsA2AKjGwbK3NvaDFi5tEPAWsoQckumbCoz/+02mFii1UWgWnLWgHgeiJadlouEmHtsxoZt088chIY0rbQ1pxeoLm7KyQKM9QoGpuHk8bpf4Ucmnb3lnGAxMdizNXjpLus+p64AJnR0qlcynjOjKbDIaGY6BckbyL69jG8jsC9qWb9WiP5wqWzIOTaMLAfsv1XMQvaBVnyCf5e3PO7sGQgBbkJ0ThE1fohJUvKDIoaB5ai7BmwLoSYXzZYw5wlQkbd63KAIWE01wBEeQ/uDoTK/cXL5eTZHkS98Y0CocbTZYKAM4FtBVikfeE/Xca8nkI/vZWYy0szedZlDJEnQjHi722HYzojuDJS8rEPDMyJEDmcgpQLcC/tCpsNgiZW9K8mT8PpLkACw4C2yi+zHs4owgX/0JRLkCiJKMPsVIUyO9ygA+OlBlh19XXbXvfPaXXXYEyIA6rKI5v5bXbv9aUyHRCH40secFv9TUa7QJ8Zd41wLBoYBm+ALkGddYUmbo5HBemXrwb2sY1ZCyXB+dL618CyZllxZ2m/hAeZz0Xw1ASiqbixaRERwsbG7oAdn2KegxPKZxLAj5oqKn11uPbiRjYNBQ3y8d9SYB69pW
 vG8NEYDr
 6pAPsKWA82lPZd+UhcHUlX5C4HM3dbQ5AfYCoLbSy2/Nhx2nBM2L0+dZKyhQL9OLgM+MNc7zB/D7qAhol7U42lh46vt/86ueRh1WSAUBaeXmzk/CwNMjCN55qs9kVWu0mBUkMkUPlWbvMUdz6K9+dYB1APv937NwEKaH90PfcGn2Pf9zfU0/SBUzua/mHw2HhDuULQmOjEpf48TMYLlRsUvXQC7xyWuq9jXMtYGVtka1ki4Hxs2DPDt72iwkppddz5PDFes7/gePx4xGnyZyA3E/GnSFX/JW76o/lFPvj/l4tb2dBFdbtZAp8vbl6dRrML9w6texBVW003qiI/4by9czav2nI/Do9hQBH3G/kiO0K43Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Oct 13, 2026 at 02:30:37PM +0200, David Hildenbrand (Arm) wrote:
>numa_rebuild_large_mapping() and do_swap_page() can be tricked into
>generating an address wraparound, crashing the kernel. All that's required
>is to map a tail page of a large folio close enough to the start/end of
>the address space to e.g., make
>
>	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
>
>to wrap around.
>
>Let's fix it by providing a better helper, folio_pte_scan_range(), that
>takes care of staying within VMA and page table boundaries while
>handling possible wraparounds.
>
>Reported-by: Kyle Zeng <kylebot@openai.com>
>Fixes: d2136d749d76 ("mm: support multi-size THP numa balancing")
>Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/memory.c | 43 +++++++++++++++++++++++++++++--------------
> 1 file changed, 29 insertions(+), 14 deletions(-)
>
>diff --git a/mm/memory.c b/mm/memory.c
>index 1f5d5f7d39cd2..a3823010aa981 100644
>--- a/mm/memory.c
>+++ b/mm/memory.c
>@@ -4933,6 +4933,27 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
> 	} while (--nr_pages);
> }
> 
>+/*
>+ * Get the address range in which a folio might be mapped, assuming its pages
>+ * are mapped consecutively and the folio page at the given idx is mapped at
>+ * the given address.
>+ */
>+static void folio_pte_scan_range(const struct folio *folio,
>+		const struct vm_area_struct *vma, unsigned long addr,
>+		unsigned long idx, unsigned long *start, unsigned long *end)
>+{
>+	/* Stay within the page table and VMA boundaries. */
>+	const unsigned long pmd_start = addr & PMD_MASK;
>+	const unsigned long pmd_end = pmd_start + PMD_SIZE;
>+	const unsigned long lower = max(pmd_start, vma->vm_start);
>+	const unsigned long upper = min(pmd_end - 1, vma->vm_end - 1) + 1;

That -1/+1 threw me for a sec ... Neat little trick!

>+	const unsigned long offset = idx << PAGE_SHIFT;
>+
>+	/* Avoid any address wraparounds. */
>+	*start = addr - min(addr - lower, offset);
>+	*end = addr + min(upper - addr, folio_size(folio) - offset);
>+}
>+
> /*
>  * We enter with either the VMA lock or the mmap_lock held (see
>  * FAULT_FLAG_VMA_LOCK), and pte mapped but not yet locked.
>@@ -5121,16 +5142,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> 	address = vmf->address;
> 	ptep = vmf->pte;
> 	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
>-		int nr = folio_nr_pages(folio);
>-		unsigned long idx = folio_page_idx(folio, page);
>-		unsigned long folio_start = address - idx * PAGE_SIZE;
>-		unsigned long folio_end = folio_start + nr * PAGE_SIZE;
>+		const int nr = folio_nr_pages(folio);
>+		const unsigned long idx = folio_page_idx(folio, page);
>+		unsigned long folio_start, folio_end;
> 		pte_t *folio_ptep;
> 		pte_t folio_pte;
> 
>-		if (unlikely(folio_start < max(address & PMD_MASK, vma->vm_start)))
>-			goto check_folio;
>-		if (unlikely(folio_end > pmd_addr_end(address, vma->vm_end)))
>+		folio_pte_scan_range(folio, vma, address, idx, &folio_start,
>+				     &folio_end);
>+		if (unlikely((folio_end - folio_start) >> PAGE_SHIFT != nr))
> 			goto check_folio;
> 
> 		folio_ptep = vmf->pte - idx;
>@@ -6280,16 +6300,11 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
> 				       struct folio *folio, pte_t fault_pte,
> 				       bool ignore_writable, bool pte_write_upgrade)
> {
>-	int nr = pte_pfn(fault_pte) - folio_pfn(folio);
>+	const unsigned long idx = pte_pfn(fault_pte) - folio_pfn(folio);
> 	unsigned long start, end, addr = vmf->address;
>-	unsigned long addr_start = addr - (nr << PAGE_SHIFT);
>-	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
> 	pte_t *start_ptep;
> 
>-	/* Stay within the VMA and within the page table. */
>-	start = max3(addr_start, pt_start, vma->vm_start);
>-	end = min3(addr_start + folio_size(folio), pt_start + PMD_SIZE,
>-		   vma->vm_end);
>+	folio_pte_scan_range(folio, vma, addr, idx, &start, &end);
> 	start_ptep = vmf->pte - ((addr - start) >> PAGE_SHIFT);
> 
> 	/* Restore all PTEs' mapping of the large folio */
>
>---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

