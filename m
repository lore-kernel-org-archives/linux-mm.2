Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E108C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D086B008C; Thu, 27 Aug 2026 08:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653596B0092; Thu, 27 Aug 2026 08:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5933D6B0095; Thu, 27 Aug 2026 08:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 373EB6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:12:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9346F80404
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:11:59 +0000 (UTC)
X-FDA: 85146935958.09.DC1D3AF
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C44E10000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:11:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sghyhz76;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787832717;
	b=ufdIEv/+lSxZjWRouzMTztI8LMDasjDDXxM7NImaSekeeS9d6/v8bjifTFoeQwlqghdRuN
	0PH7QttFJhtaXGqY6lDt5ZPiqKLWyEA/fxp3qK8Mr9Fi/9mMliA7zdRi+IJyNKV2TnWdoN
	7mQpjgORnU+MjI7WJVjmiJIN/dA5x7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787832717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajudW1cVrHI5Aype0yKSDVlP8hrDj5Jx8rF/kHBErJE=;
	b=hiGKvgFpi0DxuqT7jJnVK5pmUPEax7IU0noVoNSfDysMCg0aeTxgjW18Xo3qj2CFgrQU4z
	S2yd64i9kZ4s9MRO40wBDRVS0S+Cv6Oc3eW7sOCFaDc6WJS2DimrKAvHkqejgRlHCoLCkL
	ZHHvqObx3TXsYrQL3+i2y8xWkGN63G4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sghyhz76;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OmZ4HMNJEKn5n8PIiCPbESGHuRzCDj7TC5nRy66T5lU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787832716; v=1; x=1788437516;
 b=sghyhz76ZGQ1HyGNO4mpw7Wuj33xXQly/O+AM/JrD3r07379EZYipF+0lEbXN9QV1uK02byQ
 ahUMrm/rxCXIm+hlkLYX2lrCvs3Qf/qiq/ZFNm5XSXTYlSla9raOOh49GujPhLGOwfP93ABdo5m
 v5YsGQwDhgDnRBgxu8sKBNeQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a5aa79f41822b67a;
	Thu, 27 Aug 2026 12:11:55 +0000
X-Mizu-Trace-ID: a5aa79f41822b67a
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	baolin.wang@linux.alibaba.com,
	pedrodemargomes@gmail.com
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for swap entries when collapsing a mTHP
Date: Thu, 27 Aug 2026 20:11:51 +0800
Message-Id: <20260827121151.7837-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
References: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C44E10000E
X-Stat-Signature: m6st64a9hask5dpkp9csh3buun9fqodm
X-HE-Tag: 1787832717-520146
X-HE-Meta: U2FsdGVkX19zR1h0LdpKRDxTzRmDKHOf9d0I31mmJ4qgRY2UYWWVMFwL8cobYZaFsM5N1boxNQPViad6dXCQa4rv/BQwZCmJ1/L8rHU0uDewaO5UvzwwvaP8WFGk4rk6dHNgwHXfjNptL8t73cFvtT5mEft7u6B3rQOADtD/gAlneJJ+gsSfIiNqOTNpPEeeQEF8iLgojK8381u3PvaDqzUskSoIw/2j1EW/gN9xFO+yPo+zblG5Jj7YmxD9mzDBFFeg/la2PZa+H4ERr1u33vl+U+j6COJT/AicRY32erdiPZT46e05Kq1KqAo0BEfjbkNND96KTtPTqPoE0izmuwyUdC36/W/zseIo1jY6k53wyK5CNoueSiKO/atQqaMzYKo/yd1vAivt0AzvPduxQCxte0hMs9IGfIilHuLJPHSicLjaiyL27iz2cvtf9uOtaip32X6DSsmJt/b7sY81ot2clWov4qGroHpmD2dAeQAbACg982zy7eWwpKZQbkFcp0R9PO8iHaw0OYDykogT2PzjQnkHSlGuxGhtWjr5zztNOAShI4eeq3CcAoN6OzonsnlcaBKsYnYm0TDTWgqML2yA2qDWTG+ojfn8LsAzPPn8WcXwzanPgsOmwUhUZ7Q5FRahdR08RqqDU4j1YBs+DsY5/J0hOH7jiRKh3OOHYycJM0ELiVUWG0uESMAjR1GNLMh1WjtC1eyWX6515avAAxl3y0Nf6UGmi30DpGQRTBxFr9IAMON+4a66N/721WbkXvcpUS3YsjuS8bqaW8XEIxHp77DI53Z+yqEaoXHnXdvbkvBd9qkZJ9ZtEBBZwMbCEq5BaF5xJpZYAbja8wBPVGkdfCO5Mw3AriPRwqEOIK2bTzlEW0PdZYz702y48mjRDe6qF271SNboNJu9YQi48AUnQZTZeHCzouuv1sScDgqWqjfyG2xdNXV29sxE+Jb74Ni4glLsqvFKpcS/XvP
 ilVJcgMw
 zGQDicEt8JtuOAsRqctIAwASY/QZyylkE8QM/L0ggFgWmN3iNefYhcA/+Di5cHKtm3i4oNVI8DUKtSOE3PH/0pSBsGtwww1W+841kK38rzg62UFw4AXP9HdM7neUD3YPE3xVFJ/SC8r807RMVp9BicXEvNpcd5AAij0ElBRAXaxLmPHMNANn0kOAQPkuLmDrjHb5DdUMIoGiTU88IUTTpOOwr+NaMeA8Eu+seGzw0Ck52gY7sI0vDKXXoA9OxMnkGHsF/aXsC5PvB5fw0eksJzhaEG4/Azaqr7jC3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Aug 27, 2026 at 01:02:14PM +0200, David Hildenbrand (Arm) wrote:
>On 8/27/26 10:06, Baolin Wang wrote:
>> 
>> 
>> On 8/26/26 3:24 AM, Pedro Demarchi Gomes wrote:
>>> mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
>>> swap PTEs in the PMD range, even if none of those swap PTEs are
>>> actually part of the mTHP's range.
>> 
>> Are you sure? I wonder how you tested your patch? Because we never swapin PTEs
>> for mTHP collapse, see the code in __collapse_huge_page_swapin():
>
>I'm confused as well, this doesn't really make sense.

Well ... the change does remove a redundant PTE walk, IIUC ...

I think Pedro's wording is causing the confusion :)

Yeah, Baolin is right that __collapse_huge_page_swapin() never reaches
do_swap_page() for a mTHP. For an otherwise eligible lower-order
candidate, current code still calls it and walks the candidate's PTE range
when an unrelated swap PTE exists elsewhere in the same PMD :)

Assume an otherwise eligible lower-order candidate has no swap PTE, while
another subrange in the PMD has one. collapse_scan_pmd() counts unmapped
over the full PMD and passes that PMD-wide value into mthp_collapse():

static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
		struct vm_area_struct *vma, unsigned long start_addr,
		bool *lock_dropped, struct collapse_control *cc)
{
...
	int node = NUMA_NO_NODE, unmapped = 0;
...
	for (i = 0; i < HPAGE_PMD_NR; i++) {
		_pte = pte + i;
		addr = start_addr + i * PAGE_SIZE;
		pteval = ptep_get(_pte);
...
		if (pte_none_or_zero(pteval)) {
...
			continue;
		}
		if (!pte_present(pteval)) {
			if (++unmapped > max_ptes_swap) {
...
			}
...
			if (pte_swp_uffd_any(pteval)) {
				result = SCAN_PTE_UFFD;
				goto out_unmap;
			}
			continue;
		}
...
	}
	if (cc->is_khugepaged &&
		   (!referenced ||
		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
		result = SCAN_LACK_REFERENCED_PAGE;
	} else {
		result = SCAN_SUCCEED;
	}
...
	if (result == SCAN_SUCCEED) {
...
		result = mthp_collapse(mm, start_addr, referenced,
				       unmapped, cc, enabled_orders);
...
	}
...
	return result;
}

unmapped is PMD-wide above. mthp_collapse() then passes the same value to
every attempted candidate:

static enum scan_result mthp_collapse(struct mm_struct *mm,
		unsigned long address, int referenced, int unmapped,
		struct collapse_control *cc, unsigned long enabled_orders)
{
	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
...
	unsigned int order = HPAGE_PMD_ORDER;

	while (offset < HPAGE_PMD_NR) {
		nr_ptes = 1UL << order;

		if (!test_bit(order, &enabled_orders))
			goto next_order;

		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
						      offset + nr_ptes);

		/*
		 * Swap PTEs accepted during the scan are counted in @unmapped,
		 * not in the present-PTE bitmap. Account them for the PMD-order
		 * candidate.
		 */
		if (is_pmd_order(order))
			nr_occupied_ptes += unmapped;

		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
			enum scan_result ret;

			collapse_address = address + offset * PAGE_SIZE;
			ret = collapse_huge_page(mm, collapse_address, referenced,
						 unmapped, cc, order);
...
		}

next_order:
...
		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
			(enabled_orders & GENMASK(order - 1, 0))) {
			order--;
			continue;
		}
next_offset:
...
		offset += nr_ptes;
		order = max_order_from_offset(offset);
	}
...
}

Once it reaches the lower-order candidate with no swap PTE, unmapped is
still nonzero and collapse_huge_page() calls the swapin helper:

static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
		int referenced, int unmapped, struct collapse_control *cc,
		unsigned int order)
{
...
	if (unmapped) {
...
		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
						     referenced, order);
...
	}
...
}

__collapse_huge_page_swapin() only calls do_swap_page() after finding a
non-present, non-none PTE, and lower orders return before that call:

static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
		struct vm_area_struct *vma, unsigned long start_addr,
		pmd_t *pmd, int referenced, unsigned int order)
{
...
	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
	enum scan_result result;
	pte_t *pte = NULL;
	spinlock_t *ptl;

	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
...
		vmf.orig_pte = ptep_get_lockless(pte);
		if (pte_none(vmf.orig_pte) ||
		    pte_present(vmf.orig_pte))
			continue;
...
		if (!is_pmd_order(order)) {
...
			result = SCAN_EXCEED_SWAP_PTE;
			goto out;
		}

		vmf.pte = pte;
		vmf.ptl = ptl;
		ret = do_swap_page(&vmf);
...
	}
...
	result = SCAN_SUCCEED;
out:
...
	return result;
}

For the candidate above, the loop only reads its PTEs and returns
SCAN_SUCCEED. Pedro's bitmap lets mthp_collapse() determine that upfront
and skip the walk.

Emm ... as I asked before[1], any numbers showing how much the extra scan
costs?

[1] https://lore.kernel.org/lkml/20260825192433.3185880-1-pedrodemargomes@gmail.com/

Cheers, Lance

