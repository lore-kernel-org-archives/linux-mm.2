Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF14C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774BA6B008C; Thu, 27 Aug 2026 04:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725146B0092; Thu, 27 Aug 2026 04:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A9B6B0095; Thu, 27 Aug 2026 04:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46EF36B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:06:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B59154036E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:06:21 +0000 (UTC)
X-FDA: 85146316962.02.C63BBEF
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF85D20005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:06:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lXI6gs4g;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787817979;
	b=8FYSiv5kTBIzgxucwtyC3/R6B5st8pWMrpEmb7PvY9qgGOrrsdUGQ9G0rkytTnpj2bM153
	KY2ebzSUpAyC9pDa33WwBZLAOrGlPcJZ7jmD9MCuWokBjENC8MEXEMIuWeZdB8QpGm/Z7y
	dxZZXpskVZtJqN/nQSLE0oU95CiOQ0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787817979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vItm6oSJ85xwVAuuaGxmtPSRnxGXaOONFh+Bcy0mTMo=;
	b=IZo7mh6d0a3bpkT5F1DPJ58T702cZZpjaNBw1z8U6IVKwSMYxHen9aa9R+2K8ricRb9PCq
	gx1Y6GnOKb6crzOtpN20cA0IHFLPGLlSOnHdtnuhC3uEFpUGYGP3GXnW4d+OZ2crt9y/d+
	9evLiL3kuHP+Kx4ND+6QXJdeDlFYRw4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lXI6gs4g;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787817974; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=vItm6oSJ85xwVAuuaGxmtPSRnxGXaOONFh+Bcy0mTMo=;
	b=lXI6gs4gkSQVar4xsssdx2xwdfNaouskLY/1L9RTyT/XguRkdXVWhCf25GyYginoIY/DU8SncoiW886uWDECaP5GU9Uk32p9ZCovhRgI60AEm+3vjtcHoAfmLbEPUbWNRIE7K+4YYC4cB9dsVrHM5oxPHi2pXdFsdoRae8HDL8w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X9izibF_1787817972;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9izibF_1787817972 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 16:06:13 +0800
Message-ID: <1ec4ef97-47e4-48af-a8c8-4e50faf781f0@linux.alibaba.com>
Date: Thu, 27 Aug 2026 16:06:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260825192433.3185880-1-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF85D20005
X-Stat-Signature: 4ka8zpwyec9ban3gxrft61jfgiz1pwsa
X-HE-Tag: 1787817976-239164
X-HE-Meta: U2FsdGVkX18xhfCnvfirZQfQFXMIuXR69W5yV8CI2kaGbVnvTQhQ08oGlXxSLT4CymoLdqq5Pk32zLWSy6BtU4RtEakBL5AlcQmIMvv9kzimnUUlQcjB8iUAmDrpASUpNW1khd2sIkdCYdvnHXHK8YaIMSK3UyEuyLUpAITrk+Z8jbRHZ2Lm5wPsvbB1Tq1ISqnIqKltHa4GhKgMe9ktVV9HaaMBS0Lr78iFBJqWht8DBIrfIZApAzXFoiOT7zByB3bQHewKUw0hC5qqndSm2g+jX0yj8LxeLrXLUeQF1bz8lG9stJS5WwxodFHp5S/8Rppuu6OvQXMHUsTTP3vDR+b0ZvV/dLX2Q2/WtA6x36WarUgT4Iz/N4qfguX2akSvYY9nLEtmP3qYj8eppyGq4ZG/FDRPFMVjBsbJFpGtvliOaoBa3+a6q3Xyu34q6cpCzYMR8XYE347+Xtncdb200ldabGo3onLRgr20H4RZrnMLBInc6QAjSr5aOWesAtm7dZpcLmXyire6IhnEon0LIUBx6mmd8rntAOs7rCEQ4WK4WWSpAkWS4R10gwChRWVie97iTZnV7SKd5DyyLxJBdeW8q6E459D8lQKK4YViK6Lybw4AsDRadcyclvsE8yepZsZHFgq+oEDvaBhDws4TOuHqtSBwqDF78GstivV6jutgbxkT9mI6Xvivn4ixqABz1BWM69P67Gx1gjTWkcapEv00/daa2yx0r16mr9L3M1UBooJuYCXhN6rrquElePiEzPMgenYKRHvL/ZcZpdbD9LG9vde/iuoggzF7fvgMcf1FJoWJ+LsY5kVwOuWykidrjhrMOlFJC7tzPVg3BvNJbxLvkMldT0i5BpvWyLC7kUTxMnmJgBpEgXnRQIbA3evWkveDsF81wBUxUovWiZtdyY3iNNrLg6NtiG772wJBbQrXy+0aFPxcCGNyC0yl9ePXnDnGr78HBgPCjQi8xQq
 Yn6n6ign
 47CcQfYUgtBYpQ+EhKh4ecDwugURV6pEpmqCrxS/P61WFIMhpcKIBWf9BgNOyqfcIFP83eNzCnwhZEmob0v3uGWZd88QnUbV5JAG0RRMMm42FERwAcumDnJvSl1yFcW9gRjXS5fPHZ+ypNrdJfe7iIGFwn7jEbRoIT7L5kQSFtHHp2O7vRCXrHKLznb4lZpz2Di7e5vCd3TD4k9a8TrFZmTTwMY4B91Bvv336XuUU/VinzRvT78kuyw3BuYr2xF2xXpxBkm8PzYEka/AeH6UYEsnTnv470Djy0ymr5/wtIkQ/14d+M4Iwt9rILOKC5b9G85fJIumBUZAUUlOi/HesBJhZ8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 3:24 AM, Pedro Demarchi Gomes wrote:
> mthp_collapse() tries to swap in PTEs when collapsing a mTHP if there are any
> swap PTEs in the PMD range, even if none of those swap PTEs are
> actually part of the mTHP's range.

Are you sure? I wonder how you tested your patch? Because we never 
swapin PTEs for mTHP collapse, see the code in 
__collapse_huge_page_swapin():

/*
  * TODO: Support swapin without leading to further mTHP
  * collapses. Currently bringing in new pages via swapin may
  * cause a future higher order collapse on a rescan of the same
  * range.
  */
if (!is_pmd_order(order)) {
	count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
	pte_unmap(pte);
	mmap_read_unlock(mm);
	result = SCAN_EXCEED_SWAP_PTE;
	goto out;
}

> 
> Track swap PTEs in cc->mthp_unmapped_ptes so that mthp_collapse() can
> tell whether the mTHP's own range contains a swap PTE, and skip the
> swapin check when it doesn't.
> 
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/khugepaged.c | 29 +++++++++++++++++++----------
>   1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 11ff98d55c76..38596172f7dc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -117,6 +117,9 @@ struct collapse_control {
>   
>   	/* Each bit represents a single occupied (!none/zero) page. */
>   	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> +
> +	/* Each bit represents a single not present and not none/zero pte. */
> +	DECLARE_BITMAP(mthp_unmapped_ptes, MAX_PTRS_PER_PTE);
>   };
>   
>   /**
> @@ -634,6 +637,7 @@ static void collapse_control_init_scan(struct collapse_control *cc)
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
>   	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> +	bitmap_zero(cc->mthp_unmapped_ptes, MAX_PTRS_PER_PTE);
>   }
>   
>   static void release_pte_folio(struct folio *folio)
> @@ -1291,7 +1295,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>    * Note that the VMA must be rechecked after grabbing the mmap_lock again.
>    */
>   static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
> -		int referenced, int unmapped, struct collapse_control *cc,
> +		int referenced, bool swapin, struct collapse_control *cc,
>   		unsigned int order)
>   {
>   	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
> @@ -1330,7 +1334,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>   		goto out_nolock;
>   	}
>   
> -	if (unmapped) {
> +	if (swapin) {
>   		/*
>   		 * __collapse_huge_page_swapin() will return with mmap_lock
>   		 * released when it fails. So we jump out_nolock directly in
> @@ -1502,10 +1506,10 @@ static unsigned int max_order_from_offset(unsigned int offset)
>    * mTHP.
>    */
>   static enum scan_result mthp_collapse(struct mm_struct *mm,
> -		unsigned long address, int referenced, int unmapped,
> +		unsigned long address, int referenced,
>   		struct collapse_control *cc, unsigned long enabled_orders)
>   {
> -	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> +	unsigned int nr_occupied_ptes, nr_unmapped_ptes, nr_ptes, max_ptes_none;
>   	enum scan_result last_result = SCAN_FAIL;
>   	int collapsed = 0;
>   	bool alloc_failed = false;
> @@ -1522,21 +1526,25 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>   		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>   		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>   						      offset + nr_ptes);
> +		nr_unmapped_ptes = bitmap_weight_from(cc->mthp_unmapped_ptes, offset,
> +						      offset + nr_ptes);
> +
>   
>   		/*
> -		 * Swap PTEs accepted during the scan are counted in @unmapped,
> -		 * not in the present-PTE bitmap. Account them for the PMD-order
> -		 * candidate.
> +		 * Swap PTEs accepted during the scan are counted in
> +		 * nr_unmapped_ptes, not in the present-PTE bitmap. Account
> +		 * them for the PMD-order candidate.
>   		 */
>   		if (is_pmd_order(order))
> -			nr_occupied_ptes += unmapped;
> +			nr_occupied_ptes += nr_unmapped_ptes;
>   
>   		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>   			enum scan_result ret;
> +			bool swapin = nr_unmapped_ptes > 0;
>   
>   			collapse_address = address + offset * PAGE_SIZE;
>   			ret = collapse_huge_page(mm, collapse_address, referenced,
> -						 unmapped, cc, order);
> +						 swapin, cc, order);
>   
>   			switch (ret) {
>   			/* Cases where we continue to next collapse candidate */
> @@ -1667,6 +1675,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   			continue;
>   		}
>   		if (!pte_present(pteval)) {
> +			__set_bit(i, cc->mthp_unmapped_ptes);
>   			if (++unmapped > max_ptes_swap) {
>   				result = SCAN_EXCEED_SWAP_PTE;
>   				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
> @@ -1785,7 +1794,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   		/* collapse_huge_page() expects the lock to be dropped before calling */
>   		mmap_read_unlock(mm);
>   		result = mthp_collapse(mm, start_addr, referenced,
> -				       unmapped, cc, enabled_orders);
> +				       cc, enabled_orders);
>   		/* mmap_lock was released above, set lock_dropped */
>   		*lock_dropped = true;
>   	}


