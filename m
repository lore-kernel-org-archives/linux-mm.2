Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54120C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 07:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5E06B008A; Wed, 29 Jul 2026 03:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6D96B008C; Wed, 29 Jul 2026 03:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295856B0092; Wed, 29 Jul 2026 03:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014096B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:16:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7784514060C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:16:27 +0000 (UTC)
X-FDA: 85040956014.10.2BC93FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9576BA0006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:16:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpq5sEtB;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785309385;
	b=vEty5Fn+k+SqJFVrdVH2NzryNilkXIJvwdQPyOxPerog79vvD4Y5l7PTarDgqTekMb8ay7
	KreOIDK7clH2fN69BBDgniVAyodad6LO76kkqq8KHJVBFa+bQ/Zy9Xe0oi38wPV1lSra2C
	kinFwoGF0Fl7vGK+SNYxdYee2pZBJFs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpq5sEtB;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785309385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ABcNusa8siGBOJmqBrYLqV7YdnVY2NOtKftmEGdfV8=;
	b=OJ/wn+upI/tUM08kgxJzqsYo8websCe8gAi/b0x4aZ3aPNyOD6SCf8TXY8CkxFmqXD3G37
	/0jtFOdfpCaqS+d8TioKjbBLo8xtdp+lxB4TFIU5WUGHXQEJJOPTSauI96714FPSRPBYRb
	RGPFTNlGeM7rdyvP0+auvA5Gflynj2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C652843AE7;
	Wed, 29 Jul 2026 07:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1073D1F000E9;
	Wed, 29 Jul 2026 07:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785309384;
	bh=1ABcNusa8siGBOJmqBrYLqV7YdnVY2NOtKftmEGdfV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jpq5sEtB8EcgM44xcpdALd4ZIjwgixS31253acszH1PbJxvY5xm7VfEcqS+6dvbcE
	 Xg7v3jhCKZhNU/LDYAGgwuW6AUN1pXXFI33vYMr4cudu3HlgC29E+yIEX6KHKXM8Ar
	 RAbyzT4MVG8rMZVTfE8pNL+5yyAyH7vGAQsTsTtyUr1kA9pyrNxbB8LrrjgArDbdPV
	 g8n6gA8KwAeeKMJE2/A4lFsB9G7A2At92c1+Qfn+WSDrpMAhSe66IBTyxicgXyDVx/
	 yVbWMoZKsMT2Jq/Rt6svqn10QXBvluITSac5bgU7PLrMPnVAROpVBuIkftnxxu9Hzr
	 brIul6Z4heFrQ==
Message-ID: <a3411350-d4c7-47c7-9ed8-b36748815660@kernel.org>
Date: Wed, 29 Jul 2026 09:16:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/gup: pass an end address to follow_page_mask() and
 return a page count
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com
References: <20260729030234.2063885-1-riel@surriel.com>
 <20260729030234.2063885-2-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729030234.2063885-2-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qdhqw6ebo3c83qhcqjunf3nr3t3kr8r7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9576BA0006
X-Rspam-User: 
X-HE-Tag: 1785309385-471931
X-HE-Meta: U2FsdGVkX1+72s0fM8pbwRoT4yTITJaFMSapZsYirzBzX1iKFWJdoDMgiGb0DR5r0xh1uEKCCpvT81jiQJbXr8E/dcbTLk+Z1wvTQMOhZnvfFEvW9y3SR0Cdm2Bm7zBbd7Eny4GX/Wz7FOXbDtB4Vq/BqBqBBT294Tsiwa1VOqxWAiNlHzxjvitmdxV6PoSi65Km7jAj1dtaoN5kZo+Q/WJYA8SMXlqhxFWmdqthekQoTrtPVs8M6mcFgpA2xYQNlKqwjtRzib3sS+JEprbie03UEcHiXmHPyqc29gBNKEWUOTOkEJO9Pz+Rsh+0xkm5Mm/e9Pj8qEh34UvXufBUcxIepwR+rSmuUXR9mikHV6UQaNvl9qGqVsDwckPvix0R2y2X3y4mO1KKUl6M697if4FtcnLUnxYG78OMbbBUAmk3HxLtY3S18jM/jMmUuSXZOd4xak0kkgEGUXJSfGiiiPTXoz1w1hn+sgwap7ybRZ2MI/JK+6zop9MnfQW9yPABs7EF0eA3MrUoHPg9r+ocBvV2ALjzBE/vC7wfZZVuSxeS2za+ppt7cR1zgBsAGzvL675UsOFGXWFH6qcn07410YrOCNEIKYTrS0PngtcwZyTujunPpZ3fcDZDDbfcuhY/Oe50jrbGTvwiLvPpSk3hm11GXGLW/Z4mf5debMvtmYaClCpxrW52B0MNabkQXrtWyy5DYxg2s5WS+inX0sQ5nV4/jkJVVURWIB1Q9ShIvN7NJpi+sIDRFjBMehNHgohOjROcZwm3QUiVMqXocPlBWTDhVrEwWNmUQVSODf1nNwo1rBMMIypqwAQff4+DHL4XiEHiBv1Uc9lQVM6q385Ra9rzqAdsUr22jErb1J3GQAM7GFns4NydPvtSHOOt+VyvpfjSWjH3vrQm3zmKNLdUfBkwrf/P49upKHCqj0qebUukYnjE58f2v0spoMlCFjbEHWFmiFnQpda46zDWi7o
 ONgtpi5H
 WgvEt8DbeNe7iRdIurlbcMM8/LRIz8txlNfJG4eYJWta3r5ImKQ7sjlOL05BX1L99xqsgPAfI7F0yqOQNvFG+h4jEJLL/HP2qDzLydB0yMf7tNLsL0LRo6GYUywxutwjc4cf/KpINImPDx6pzsxNeg1qPOz8P9YstN4iVN/6cZ+z6PKVeoaUZ8ZS9NV41MJSxMNQpKkeGddCfR1xSuZzZ8DzKJObiAr6J1z5TptRzCf3+vb5Yrs3WxVAr3DxnXo49UL1kmsJaLbrvMXj5slNcA6Yttjs56qvy2Q2cvpUnXCfEe5YtcpiMTEqN8TEQF9VWPbmHMQpeKl1IeXq+d/Y0FPATwhXOhSw5XRoPd/xdnsmh4SdPlg4sMS6kEObNZsnW0+oFGEThg+zkDWtEiXWtckXnjmDpXeLP3EpEiMtHyqMB/SFTwmT1ST/u5hGzoxyRTtHZHF7HQPzmoFdd/sN58DK9w3dyjNDjtEPp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 05:02, Rik van Riel wrote:
> follow_page_mask() reports how many pages the returned page covers with a
> page_mask: a bitmask of the enclosing naturally-aligned huge page. Callers
> turn that into a stride, which assumes the run is a power-of-two block
> aligned to its own size.
> 
> That form cannot describe an arbitrary contiguous run, which a later patch
> needs to batch PTE-mapped large folios.
> 
> Replace the page_mask output with nr_pages, the number of contiguous pages
> the returned page covers starting at @address, and add an @end argument
> bounding how far the walk looks, so a small request does not scan an entire
> large folio.
> 
> The huge PMD and PUD paths report the same stride as before, now as a count
> clamped to @end. __get_user_pages() uses the count directly.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>


This patch moves us closer towards the GUP-fast path, however, that is about to
change:

	https://lore.kernel.org/all/20260219050250.266876166@ruivo.org/

With that in mind, I guess in the future we want to have:

static long follow_page_mask(struct vm_area_struct *vma,
		unsigned long address, unsigned long end,
		unsigned int flags, struct page **pages)

or even better, now that follow_page() no longer exists, in light of gup_fast():


static long gup_slow(struct vm_area_struct *vma,
		unsigned long address, unsigned long end,
		unsigned int flags, struct page **pages)

Returning the number of pinned pages.


In particular, such an interface would allows us to process multiple
ptes/pmds/... in one go, without having to restart the page table walk all the
time for each non-batchable folio.

And make gup_slow make look more like gup_fast.

I think that's one of the suboptimal things that we inherited from the legacy
follow_page() interface I ripped out a while ago.

... and get rid of that nasty "if (page_increm > 1) {" handling outside of
follow_page_mask().


I'm ok with doing this patch here first, because what I describe is a much
bigger rework.

But being able to pin many pages in one page table walk sounds like another
excellent optimization opportunity, which would even reduce the batching benefit
you see today with patch #2 by simply making PTE processing easier.


I think I can find someone to work on this.

> ---
>  mm/gup.c | 94 +++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 52 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b..3437cd3407d5 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -647,8 +647,9 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
>  }
>  
>  static struct page *follow_huge_pud(struct vm_area_struct *vma,
> -				    unsigned long addr, pud_t *pudp,
> -				    int flags, unsigned long *page_mask)
> +				    unsigned long addr, unsigned long end,
> +				    pud_t *pudp, int flags,
> +				    unsigned long *nr_pages)

While at it, please convert this end the other instances to two-tab indent on
the second+ line.

[...]

>  /**
>   * follow_page_mask - look up a page descriptor from a user-virtual address
>   * @vma: vm_area_struct mapping @address
>   * @address: virtual address to look up
> + * @end: virtual address at which to stop batching contiguous pages
>   * @flags: flags modifying lookup behaviour
> - * @page_mask: a pointer to output page_mask
> + * @nr_pages: output; number of contiguous pages the caller can read
>   *
>   * @flags can have FOLL_ flags set, defined in <linux/mm.h>
>   *
> @@ -998,15 +1007,17 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>   * trigger a fault with FAULT_FLAG_UNSHARE set. Note that unsharing is only
>   * relevant with FOLL_PIN and !FOLL_WRITE.
>   *
> - * On output, @page_mask is set according to the size of the page.
> + * On output, @nr_pages holds how many contiguous pages the folio that includes
> + * the returned page has mapped into this process, so the caller can advance
> + * over a large folio in one step.
>   *
>   * Return: the mapped (struct page *), %NULL if no mapping exists, or
>   * an error pointer if there is a mapping to something not represented
>   * by a page descriptor (see also vm_normal_page()).
>   */
>  static struct page *follow_page_mask(struct vm_area_struct *vma,
> -			      unsigned long address, unsigned int flags,
> -			      unsigned long *page_mask)
> +			      unsigned long address, unsigned long end,
> +			      unsigned int flags, unsigned long *nr_pages)
>  {
>  	pgd_t *pgd;
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -1014,13 +1025,13 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
>  
>  	vma_pgtable_walk_begin(vma);
>  
> -	*page_mask = 0;
> +	*nr_pages = 1;
>  	pgd = pgd_offset(mm, address);
>  
>  	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
>  		page = no_page_table(vma, flags, address);
>  	else
> -		page = follow_p4d_mask(vma, address, pgd, flags, page_mask);
> +		page = follow_p4d_mask(vma, address, end, pgd, flags, nr_pages);
>  
>  	vma_pgtable_walk_end(vma);
>  
> @@ -1358,7 +1369,6 @@ static long __get_user_pages(struct mm_struct *mm,
>  {
>  	long ret = 0, i = 0;
>  	struct vm_area_struct *vma = NULL;
> -	unsigned long page_mask = 0;
>  
>  	if (!nr_pages)
>  		return 0;
> @@ -1373,7 +1383,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  
>  	do {
>  		struct page *page;
> -		unsigned int page_increm;
> +		unsigned long page_increm;
>  
>  		/* first iteration or cross vma bound */
>  		if (!vma || start >= vma->vm_end) {
> @@ -1400,7 +1410,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  						pages ? &page : NULL);
>  				if (ret)
>  					goto out;
> -				page_mask = 0;
> +				page_increm = 1;
>  				goto next_page;
>  			}

God is this (existing) page_increm handling a hacked-on mess :)

-- 
Cheers,

David

