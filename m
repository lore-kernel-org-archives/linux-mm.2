Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4312DC61DD3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7776B0096; Thu, 27 Aug 2026 23:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF196B0098; Thu, 27 Aug 2026 23:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5596B0099; Thu, 27 Aug 2026 23:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 046866B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:24:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B6FA1C1BFC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:24:21 +0000 (UTC)
X-FDA: 85149235122.08.EF2836B
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id C4E18140004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:24:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ysef4wUn;
	spf=pass (imf09.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787887459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2ZzKk07tFRa0Ja9M4tPFlTar0tTPuv50YYhh41aYzE=;
	b=avc0iQ9M5FEE6Mp/ZZ1Ut1T5f+mMh0TOXrchZmfBomhWKEDRiveLLWubOWIxD1E1ST/UWp
	OSC6G8U5LBEsk60xXa62CQ+pPbnzoFphOICngJiuQB/WjteUuRZoMiAOgkwrRL1Hhh5PCx
	ZLSkaKcdRhezG3Do2SRDA4UIn6or4XU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787887459;
	b=bn8nGY+YtaTW+7z5qNOI21ipCOhzDPsxMa1Q8KoDh184tj6XI/LR5zPaXX4520DeLGej07
	uN6x4gtV17k5+QtfFuTxuhIKgneV8fnEH8gy8cx51bwaveErn+mIr2oJ+XyHIxBMxAu2Kj
	LQTtGZE110Q9IjnW21+AzDACQmR2KMs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ysef4wUn;
	spf=pass (imf09.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.222.52 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-97cb310ae18so368304241.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787887459; x=1788492259; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g2ZzKk07tFRa0Ja9M4tPFlTar0tTPuv50YYhh41aYzE=;
        b=Ysef4wUninuBfyQDkrgigUsWx9zJXte8rUik5J+Fxlj7LhTC1rIM64bCXaejwmp1ch
         zkRhlaAbBHvU6w8EcofEWTgfqfukx8m+T6YYPiiedjNwkVKjUIbJ2t2vetXkrHA48c5a
         bWBjpEYrJbdRGWNSKeN+vRQS4ooeYPKX26t/mEQARU8P47DlT0tSM7daFED/heTwnz14
         A5tWiUdop8CCV1AsAFCoYEX+obJ9limYs1DNNUYooe6CGxwSTwOB2ElI8tCQhy8bhF4U
         goV1TVaGvZ6WlXbVVMaQ+IdXOYis6lOFvpULZJpOyFdRyF95HpPyEnCUUH4s6q9sQN9V
         dLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787887459; x=1788492259;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g2ZzKk07tFRa0Ja9M4tPFlTar0tTPuv50YYhh41aYzE=;
        b=dto/hk1/An3rtJ8FpJazBgwkidST4DNXOdLPyunnApgvX/+evVj0KZ3G2B3RpRX0d2
         EFC8ALQpFDfIjRy4bjAJZYZJt4e6p/bF5Me4TjLTy8u0pUnvYjTEyNjYPGYK7jdCHxsO
         Cp/vQzhK5pJ9OYTtm6J6M4be6olZPV0dIcNOEmatfr/RCzLMwlNgaQLGkRlEvOji5tJ/
         zSpirTd04O3eUP+M3f/UBMTC24U8izlxfwSlCnBd4xYnYN4sBHsYfp4EllydQCmXsImY
         rHFCuuazxdqCn5eb7Ss2KduMO8wOc8KSawvDLfVbnuI5EzMce2kyyrO9xaxly/Vkg16W
         UeVg==
X-Forwarded-Encrypted: i=1; AHgh+RpeK0QsaJsKGVwrbpNK3UXh34Fi55Ez1wxzPsPQd6pXWJH9WScr2HQByIztz1IQhBg+o8irO5U3SQ==@kvack.org
X-Gm-Message-State: AFuF++n5H8UG3Yn1ArTLRM5bTOhGXVO4rDC7+b+rlCR4hf64aVKJOCg6
	o6ay+jGrvC3aiXUDMnUTG/IH/anx214UcN/qxsUcInEhVHvlppmk0L6J
X-Gm-Gg: AR+sD12MR0M54ZDp/sK8F6K2N6JNXu3bfAgON2sduYdLRZ8148ROwFUVavy/cfakTAQ
	mlER1S44TmgqnqD59zLc7ZES7X6GzV0F43q84x8wgXS54TA/EoseyJCnlDvyRIEP5KnwUpn4ROi
	6xBtmIcGwKB7VJK6Rgzx+YYOBHwjWjAO8D6M+wvcO62elktuWFZgT3WYbPcVLzl2eZpSa/zAjkg
	YRgi5Kz8+KYvPfqQDDESg8bz3DNzWYyT2I44lWNdeCW6XHWVLqIZo4rrOQpwG8LuaWvJuR1jMvF
	oaxssHnsu2snD4rEJQyg2SaMjLfPE5MnjsgjOp3OX8bPSNAqunmlS4myPxvaR+o6kTVbNv6POLW
	j8i0vjersTx+XG6Ir+uBWlCwzj/5jAVEmq1bdAxSS4UfZwd6twFLjL20bC6mNPVEXzngUAgEzCP
	3u2y/r010+Ln9768qWSDn01/PDSXXJ+M2U84DUfW+fuZlY0sLbjrH3KLDIkTU86VaTZ7Vb9LqYs
	BXl3hxBeMoECh2mb/es19XoT0cki4X8z0tbNophYb1+mQ==
X-Received: by 2002:a05:6102:2253:b0:783:c17c:e7de with SMTP id ada2fe7eead31-7841d55ca7bmr2144879137.9.1787887458822;
        Thu, 27 Aug 2026 20:24:18 -0700 (PDT)
Received: from ryzoh.168.0.127 ([2804:14c:5fc8:811e:f302:2f37:278a:ffdf])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97e84a55284sm214637241.4.2026.08.27.20.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 20:24:17 -0700 (PDT)
Date: Fri, 28 Aug 2026 00:24:11 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
Message-ID: <fle5rdjgidxkdvb45oymjftgy3itbsbmthtmugb77honamcwni@mslpfsykumqe>
References: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
 <20260827121151.7837-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260827121151.7837-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4E18140004
X-Stat-Signature: hwwfb9de9be1gx6rtentfy53tdy4fnic
X-HE-Tag: 1787887459-49991
X-HE-Meta: U2FsdGVkX19rOEjwQoWj6ORaR8Nk0cxTKbfFQj8j+PBz6QbeEevs9tPDNtnO4GaYcm3WcZETlfz/bhBG5y4Cp0i6kPYi1saWxmWqpWx7Z70I8EioB1yJ2qfhOXrySJ2afQOk4SivVAEGRWZ6YCsRCpBUNPH24OvW+L8qnzbvodPEwZB6YsUGaLVQCwABFpQazHYlN1RbiOLRE7tyYfs5A/E/GO8QU03WxOEfnDjjnvPuFxUYJQKxWUdMHp9PsI9uylUwKcNAGCD1yEEuu7Rf+BMLRzd5KeSuQrfZoUmbUzyd/C299DPzMk5qh2g3+PbBvk8Gp6hz7cy4Y/SS/9SpPD+FkER8x3qeMTYejXORWp6mnYl4djavr6YKuIi8YAUf3UnCCSixmIdk1TqrjZQ4OBEHXhuu5kOfK0vIZMHpINmnl8nnso8lC8KtpPBkfK5pti0I0KryLNhHnEWF8DXY9jQJqOQyNZvAZsEoE/DFooa3877K/Up2mCuZ1wWHkzYLM0zxixvPrJannBTVddeYYBwupEuh+oB8HrQI5DV0QSELWgkk5P0kEGCiNOq2en1Mq5ZzK8K4qy8lUG5W/8/bHnpbdxSY6IASmNvshq/2guKg6VWidRg0yYqsR8xmgIlPfAhc894ogoEkeg99YaRg4soT4Ny3YlxPctxTR0b5/OBZNc/kLoXYTx2kFFYyC+Rn2Ow94+83GDwk5i76DkGzG7l1SDpilzm6m2i9lPoNVjMpW2J754V2cEcfOpklPdoSr2gaus5Hy5yOliJXF30RvX/s+gYj3Iw0XXHVIWrwH77vz3kGcM6dt19g+jbmjFlgja2Ou+AKHB/hi0EUaE2Tmp2Md7EOPgmLJPQ6OSidvLbJ3nC6fxKuVNYZ6drKtQJ1QXH6ozPZ71rievDV0PvUfNfWDp6LRSVd5yssOpJRrfOY93eJ6cHJvrGN8QQny4fr4uFCPZG9sFO+aYNGSW8
 3WzjJYN8
 K7Aezms/r6X4vQmpBB5X8jZk7YXcbhjSaSiRYq/c29YNsNgm+hFBmZvc7XL429eMOTLrTtRNrpHy1B1mYOEuyM3I/4GgbQxBJHGGdOJFn/lHbhGuukzIESHjhhi7/HXzXK+RIh9/4K1lbo8kXss4+d3g1yuEUCG5WgPC1aT2Vlaq+EfC79MOq6PRBIbDAk7Fm11CWAnPZX3EZUdC6KFqkvOSFB0bSos28qxkyI1QZPcQ9ii4KpmRuIWqFkekFvdJ/fFYhHFzHq9bfrW/2UOoaFecVTV1WbT9Emo+s1MZCWPm2ZufpLZslQKucNs+QucqhY4a6EayWMf7QFWhMbPGysasxwJ5p7hCzpMgpO2XSbuGhmLP/BEPawVj4gPZKS4XjIirTBGEvUOPzbr3Bl36uQJ0K7Ot0UvvXW/gRktqys9WnJLIIWI0kcl2fHQ7sBWQTVoD9D9WKd6zTQBQwAdWMelJ1EOjdm7LFcu+2AHnA+wl+c3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:11:51PM +0800, Lance Yang wrote:
>
> On Thu, Aug 27, 2026 at 01:02:14PM +0200, David Hildenbrand (Arm) wrote:
> >On 8/27/26 10:06, Baolin Wang wrote:
> >>
> >>
> >> On 8/26/26 3:24 AM, Pedro Demarchi Gomes wrote:
> >>> mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
> >>> swap PTEs in the PMD range, even if none of those swap PTEs are
> >>> actually part of the mTHP's range.
> >>
> >> Are you sure? I wonder how you tested your patch? Because we never swapin PTEs
> >> for mTHP collapse, see the code in __collapse_huge_page_swapin():
> >
> >I'm confused as well, this doesn't really make sense.
>
> Well ... the change does remove a redundant PTE walk, IIUC ...
>
> I think Pedro's wording is causing the confusion :)

Sorry for the confusion. My patch description was not clear enough.
Thanks for taking the time to clarify the intent of the patch and explain the
code path in more detail.

>
> Yeah, Baolin is right that __collapse_huge_page_swapin() never reaches
> do_swap_page() for a mTHP. For an otherwise eligible lower-order
> candidate, current code still calls it and walks the candidate's PTE range
> when an unrelated swap PTE exists elsewhere in the same PMD :)
>
> Assume an otherwise eligible lower-order candidate has no swap PTE, while
> another subrange in the PMD has one. collapse_scan_pmd() counts unmapped
> over the full PMD and passes that PMD-wide value into mthp_collapse():
>
> static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		bool *lock_dropped, struct collapse_control *cc)
> {
> ...
> 	int node = NUMA_NO_NODE, unmapped = 0;
> ...
> 	for (i = 0; i < HPAGE_PMD_NR; i++) {
> 		_pte = pte + i;
> 		addr = start_addr + i * PAGE_SIZE;
> 		pteval = ptep_get(_pte);
> ...
> 		if (pte_none_or_zero(pteval)) {
> ...
> 			continue;
> 		}
> 		if (!pte_present(pteval)) {
> 			if (++unmapped > max_ptes_swap) {
> ...
> 			}
> ...
> 			if (pte_swp_uffd_any(pteval)) {
> 				result = SCAN_PTE_UFFD;
> 				goto out_unmap;
> 			}
> 			continue;
> 		}
> ...
> 	}
> 	if (cc->is_khugepaged &&
> 		   (!referenced ||
> 		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
> 		result = SCAN_LACK_REFERENCED_PAGE;
> 	} else {
> 		result = SCAN_SUCCEED;
> 	}
> ...
> 	if (result == SCAN_SUCCEED) {
> ...
> 		result = mthp_collapse(mm, start_addr, referenced,
> 				       unmapped, cc, enabled_orders);
> ...
> 	}
> ...
> 	return result;
> }
>
> unmapped is PMD-wide above. mthp_collapse() then passes the same value to
> every attempted candidate:
>
> static enum scan_result mthp_collapse(struct mm_struct *mm,
> 		unsigned long address, int referenced, int unmapped,
> 		struct collapse_control *cc, unsigned long enabled_orders)
> {
> 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> ...
> 	unsigned int order = HPAGE_PMD_ORDER;
>
> 	while (offset < HPAGE_PMD_NR) {
> 		nr_ptes = 1UL << order;
>
> 		if (!test_bit(order, &enabled_orders))
> 			goto next_order;
>
> 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
> 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
> 						      offset + nr_ptes);
>
> 		/*
> 		 * Swap PTEs accepted during the scan are counted in @unmapped,
> 		 * not in the present-PTE bitmap. Account them for the PMD-order
> 		 * candidate.
> 		 */
> 		if (is_pmd_order(order))
> 			nr_occupied_ptes += unmapped;
>
> 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> 			enum scan_result ret;
>
> 			collapse_address = address + offset * PAGE_SIZE;
> 			ret = collapse_huge_page(mm, collapse_address, referenced,
> 						 unmapped, cc, order);
> ...
> 		}
>
> next_order:
> ...
> 		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> 			(enabled_orders & GENMASK(order - 1, 0))) {
> 			order--;
> 			continue;
> 		}
> next_offset:
> ...
> 		offset += nr_ptes;
> 		order = max_order_from_offset(offset);
> 	}
> ...
> }
>
> Once it reaches the lower-order candidate with no swap PTE, unmapped is
> still nonzero and collapse_huge_page() calls the swapin helper:
>
> static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> 		int referenced, int unmapped, struct collapse_control *cc,
> 		unsigned int order)
> {
> ...
> 	if (unmapped) {
> ...
> 		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
> 						     referenced, order);
> ...
> 	}
> ...
> }
>
> __collapse_huge_page_swapin() only calls do_swap_page() after finding a
> non-present, non-none PTE, and lower orders return before that call:
>
> static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		pmd_t *pmd, int referenced, unsigned int order)
> {
> ...
> 	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
> 	enum scan_result result;
> 	pte_t *pte = NULL;
> 	spinlock_t *ptl;
>
> 	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
> ...
> 		vmf.orig_pte = ptep_get_lockless(pte);
> 		if (pte_none(vmf.orig_pte) ||
> 		    pte_present(vmf.orig_pte))
> 			continue;
> ...
> 		if (!is_pmd_order(order)) {
> ...
> 			result = SCAN_EXCEED_SWAP_PTE;
> 			goto out;
> 		}
>
> 		vmf.pte = pte;
> 		vmf.ptl = ptl;
> 		ret = do_swap_page(&vmf);
> ...
> 	}
> ...
> 	result = SCAN_SUCCEED;
> out:
> ...
> 	return result;
> }
>
> For the candidate above, the loop only reads its PTEs and returns
> SCAN_SUCCEED. Pedro's bitmap lets mthp_collapse() determine that upfront
> and skip the walk.
>
> Emm ... as I asked before[1], any numbers showing how much the extra scan
> costs?

I tested this on my machine with a 2 MB PMD size. In my measurements, removing
the extra PTE walk did not show a significant reduction in the overall scan
time. Maybe for machines with a bigger PMD size this can make a difference.

>
> [1] https://lore.kernel.org/lkml/20260825192433.3185880-1-pedrodemargomes@gmail.com/
>
> Cheers, Lance
>

