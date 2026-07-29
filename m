Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430E3C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B5E6B00B6; Wed, 29 Jul 2026 10:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4536B00B8; Wed, 29 Jul 2026 10:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208BB6B00B9; Wed, 29 Jul 2026 10:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D69376B00B6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:59:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2A2D80626
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:53:27 +0000 (UTC)
X-FDA: 85041049254.16.FC55411
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02EF780002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:53:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYeZ4k5F;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785311606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if8Zk9xieVg2voDmGs3/JUmsXlUPxyydhFDKKJ14DNc=;
	b=IK82OUFe064rlG8r1ZuHpVkfDROiINB9/YLJ5fB468+IJb7qIbtxMbYoONWPlcum8UE3cq
	cO07NbsLUyBa4ilS7R2SBRrLuVorCyouxAhSYrWz0hUEAnSVpKNVw6mdNJeMYEQ/Cn0xn3
	2M+wczIAmKNfU12JPCrae6veyBDaa+U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYeZ4k5F;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785311606;
	b=KRBuww8sandjESnOZUKf+9oWPxVorknTMcDLslY4G3pczCkxPa0nrgjMhK1Rs3WimwIrLX
	4csUfc6c/tGvW9RAHHb0pToJRQDCEd+HcG9jTCIQWAgA6XZlfuvMCCH7KJlV7UDhGGLKCh
	WL6P8d2Zyr/UQtD6gwT27XsbTcrMpQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3BDE406BA;
	Wed, 29 Jul 2026 07:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7033F1F000E9;
	Wed, 29 Jul 2026 07:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785311604;
	bh=if8Zk9xieVg2voDmGs3/JUmsXlUPxyydhFDKKJ14DNc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XYeZ4k5F0iiyUnGMLRieyN9TNxf7L+B9eilv/77i87sr12EgXMigreKAOZc4bUi/d
	 PX/uqNHDt6X36Y9FYNvKipPYdspOqL4s0ztPcvWZx/jyifuvOhtqIEB+WGvgTWq22D
	 QdvpBCQgKxza2CC7ldUObYUIJJUNUzIm12sZr9NJgRRq2z1FWB+TnFQ+seAencgezE
	 oPbc9+8yfHjHTgTj5i0m+8Xo3+bipgC7P21+J2tSPagbecyYxKsgePXRUc1qGFL2Fa
	 oOBUPD0BwjCDLx8rNu9kTxdE/2Cme7ZWYwdBlYlUEdDHyd0mb6Qf0gGjcJqdCtdoZI
	 2Ea4JE0c5ahog==
Message-ID: <db3d2c65-31f2-4430-bef4-4dae76135eed@kernel.org>
Date: Wed, 29 Jul 2026 09:53:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/gup: batch contiguous PTE-mapped large folios in
 follow_page_mask()
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
 <20260729030234.2063885-3-riel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260729030234.2063885-3-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02EF780002
X-Stat-Signature: xcjx4k3a6ubsrtmit56dieb5as8x3zix
X-HE-Tag: 1785311605-305250
X-HE-Meta: U2FsdGVkX19P+QYXx2l5oALnY/l1taAbkHcXz1nED9SSd59CEQAnGezNzqiaIXGuhf2u6tb8MmYN9ehDp9sawwYMDDZPEV5Z5bInRQDbWom3ADeM7zNG/0YvPnxig+8qz+ZbBiLibIVuzte3pZs6QmY+x5tO4/zMMAWk+HHRUXMPli0W+F4NW6tKH6rmOPHC2N916mzJE8+aJg7v/8i4A73a2FXbpp82IB7GudQiI4qpxUg27LQBA3cUrZ3tCFCr/oPmvPmRJXiTQ3cZDYl9vHsyYkdnjovAxtXEblSAm/3IyMyH/4RJnT+9P57HyyzEHHAlm38gWB7JA+55qE6yidVr99Mx0rfc2zZDyxGvjBuP2I9Es9rz3khR8kpmGWLio2iK3xGo+rIDqYqaYKjdkH5FDibu3pBTP16853mWwLLzGBn8Uvr6xtjUQVgkT+qdxKOHwEXJmW3onqV7ExldtzLTUD5WGNlfl+NrmURhNjrZQNFS6Ij/5TLufA8sNh3B5Xbhj4s+6Wp8I6biZCfIEE30itAV6haxk4x+W8B3zWn1WF+B9y8O2+27pQ6sKc622/lCgYX3o30X33chbdLS1sb1H1uWUfkSeg6z17zR75gpK77DF3fe5mywUSBTCiTpMMw0zvtoBK8WmIylc57bfZqYY97z8NHxDbdMmMEpPwweEdMUvWwgDIufeWA5H910uKO0ILxISFo8bhB4ep6z8sz51IRFcMZ+l+xznGQ2YDOM/snRX/mgNIMeusjzvvu4KNDFuKlo3L6R+hUh5o/YX7XRcYXPGR+EvnFk1uWgrvhYtV1douWRNhz5E9hBbxzflyevTAOY4WGOAB+VQgvR7wkGGkEK4T5fBokLzsg8pz4ux3X4/m8yUBT56meaR7biqIV+7fE+aNKi+iyiRegWkoXSHV+fUL5/TTHepXciRm8dq11DpiHP5J/OPuhHv3vSPFKAY7mJDyaew3C1OUR
 LdS7cZJv
 fz3vvRu9mjUWBAqiKLVL3d3hUUZCi403OJ9vVSkm427Cok26PwlftPhylLZBdtDqPafjsmh1aZ11A1tKXFwNTQ6hGMhOJzH+tzTToprfb6kWHTZIbIuklKhoVY5maG7IdaDeLtQZhHAWp3gl/CGdt88cThREAJZ4uBpZYsZr29gNuRa6Dni56DDgc6lEvUsDQie8/dhCjxLL5WS1QEnE7oHK34ApWxyhV5sUUWBvQsKBnJ1QSg4cez+5eganw0rPLbL1sUidjXWGXZhPvAIq4jbVmCvfVEOclm/p3CBU+SUdgvMe6tdAK8F7YrT5aGo6zZs583PgWca0OtYhKDnkgek93EHzyCfr2NljtVqT7qYzO1oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 05:02, Rik van Riel wrote:
> follow_page_mask() returns one page per call for a PTE-mapped large folio,
> so __get_user_pages() re-walks the page tables for every page of an mTHP
> even though the folio maps a contiguous run. The huge PMD and PUD paths
> already return the whole mapping in one step.
> 
> Report the contiguous run for the PTE case too. follow_pte_batch() uses
> folio_pte_batch_flags() to count consecutive present PTEs that map
> consecutive pages of the same folio with a uniform write bit, bounded by
> the page table, @end, the VMA, and the folio itself.
> 
> Keep the per-PTE guarantees that follow_page_pte() makes for the head page.
> folio_pte_batch_flags() with FPB_RESPECT_WRITE stops the run at a change in
> the write bit, so the whole run matches the head.
> 
> A writable run is safe for any access: a writable anon page is exclusive,
> so gup_must_unshare() cannot fire, and FOLL_WRITE is satisfied.
> 
> A read-only run is batched only for a plain read, since FOLL_WRITE would
> need a COW fault per page and FOLL_PIN would need a per-page
> gup_must_unshare() check.
> 
> Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, the slow
> pin_user_pages() path) on a 256 MB MADV_HUGEPAGE anonymous region in a
> 4 CPU VM, median get time over 16 iterations. Each folio size was confirmed
> through the per-size anon_fault_alloc counters (4096 folios for 64 kB, 128
> for 2 MB):
> 
>   gup_test -L -m 256 -n 65536 -r 16 -t
>                         before      after
>   64 kB mTHP            3140 us      412 us   (7.6x)
>   2 MB THP (control)      78 us       76 us
>   4 kB base (control)   3010 us     3042 us
> 
> The PMD-mapped 2 MB THP already returns the whole mapping in one step, so
> it stays fast and unchanged. The 4 kB baseline shows the per-page walk cost
> that the 64 kB case paid before this change; only the PTE-mapped large
> folio case improves.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 3437cd3407d5..8c6ad1ee7ccc 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -805,6 +805,43 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
>  	return !userfaultfd_pte_wp(vma, pte);
>  }
>  
> +/*
> + * Count the pages, starting at @address and bounded by @end, that a PTE-mapped
> + * large @folio maps contiguously and that can be returned together with the
> + * page at @address: consecutive present PTEs mapping consecutive pages of
> + * @folio with a uniform write bit, within this VMA and a single page table.
> + * Returns at least 1.
> + *
> + * gup_must_unshare() and the write-fault check are per PTE. A writable run is
> + * always safe: a writable anon page is exclusive, and FOLL_WRITE is satisfied.
> + * A read-only run is only safe for a plain read; FOLL_WRITE would need a COW
> + * fault per page and FOLL_PIN would need a per-page gup_must_unshare() check,
> + * so those fall back to a single page.
> + */

Drop all of these comments and rather comment in the function on the important
bits. For example, the gup_must_unshare() logic belongs above the relevant code
below. If we cannot easily sort it out.

> +static unsigned long follow_pte_batch(struct vm_area_struct *vma,
> +		unsigned long address, unsigned long end, struct folio *folio,
> +		struct page *page, pte_t *ptep, pte_t pte, unsigned int flags)

Why pass the "page" when it is not even used?

Maybe it should be used? :)

In mm/mprotect.c we do have a page_anon_exclusive_batch() helper already that
would do the right thing. See below.

> +{
> +	pte_t batch_pte = pte;
> +	unsigned long max;
> +
> +	if (!pte_write(pte) && (flags & (FOLL_WRITE | FOLL_PIN)))
> +		return 1;

This is really only required for anonymous folios, though.

So likely you could instead just do after the folio_pte_batch_flags() a

nr = folio_pte_batch_flags() ...
if (nr == 1 || !folio_test_anon(folio) || pte_write(pte))
	return nr;
/* Careful with gup_must_unshare(). */
return page_anon_exclusive_batch(0, nr, page, PageAnonExclusive(page));
	

I'll note that the page_anon_exclusive_batch() helper is rather ugly, maybe
you'd just want a nicer one local to this function. It's pretty small in the
end, so you might also just open code a simple loop over PageAnonExclusive().

> +
> +	/*
> +	 * folio_pte_batch_flags() scans forward from @ptep, so the run must
> +	 * stay within this page table: bound it by the PMD as well as @end and
> +	 * the VMA, since a large folio can be PTE-mapped across a PMD boundary.
> +	 */
> +	max = min((pmd_addr_end(address, end) - address) >> PAGE_SHIFT,
> +		  (vma->vm_end - address) >> PAGE_SHIFT);
> +	if (max <= 1)
> +		return 1;
> +
> +	return folio_pte_batch_flags(folio, vma, ptep, &batch_pte, max,
> +				     FPB_RESPECT_WRITE);
> +}
> +
>  static struct page *follow_page_pte(struct vm_area_struct *vma,
>  		unsigned long address, unsigned long end, pmd_t *pmd,
>  		unsigned int flags, unsigned long *nr_pages)
> @@ -893,6 +930,14 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
>  		folio_mark_accessed(folio);
>  	}
>  
> +	/*
> +	 * A PTE-mapped large folio can be handed back as a contiguous batch,
> +	 * so the caller advances over the whole run in one step instead of
> +	 * walking the page tables for every page.
> +	 */

That comment can be dropped, the code is self-explaining.

> +	if (folio_test_large(folio))
> +		*nr_pages = follow_pte_batch(vma, address, end, folio, page,
> +					     ptep, pte, flags);
>  out:
>  	pte_unmap_unlock(ptep, ptl);
>  	return page;

Thanks for working on this!

-- 
Cheers,

David

