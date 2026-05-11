Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACBDCD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1AD6B0088; Mon, 11 May 2026 03:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72926B008A; Mon, 11 May 2026 03:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61776B008C; Mon, 11 May 2026 03:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C84B26B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:10:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5ADA71C14C6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:10:19 +0000 (UTC)
X-FDA: 84754265358.09.8BAB0DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2160D140002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:10:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tqdcckWL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778483417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xs1ffLjF8o3r91yZOaMhPgOxfBGsTSsFhyc9Vw8Iqn0=;
	b=L5NoBZyAmBO72Zk0nVStodFUFMbTrHqqF2xB6Y3uPKd7x4kQ9+FMhg+T36eBzbS7KbY0mG
	0Dk7UtW2wBQufCLGFropix02KXOeoDdRNu55r/tJLcWFG9MfvzhdJcC4HgqThSM7th/be/
	dHatQlBLYbCgTqHuYPcohZirm9s6KNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778483417; a=rsa-sha256;
	cv=none;
	b=vmuYxMwcmdy/mRPE4ihBLIOQKQVMTFECTV76HvUZggmCxE990Fg1+TTWa/qaRxCRLZvpMG
	M30up7jtQAuzn8og/avmfRitIKi6hMVd0PogRGzREQhfx4AoaqxQrNjXoiFLdOd7TNkNHg
	TFNHwQqyP0dTMtTkzTFnctetfcWzvUM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tqdcckWL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3B5240937;
	Mon, 11 May 2026 07:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1C1C2BCF5;
	Mon, 11 May 2026 07:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778483412;
	bh=33KGsy3741FolJyEeUIRL41JotcVYvK3zvf02nj9pKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tqdcckWLNyBkFoPGI2eNV6BkL+cs32/GNCl3SJUle2o1bPALeBboDL2qgKbJDftpB
	 nou4MRCoghxD1OJTzenK0l2+e+osefS03Tbq9d7+EH2TicH06LI9OSkKaVzDMQbmz8
	 gGnAUbPB04mR19ppO8IY33P1t4MoXGgsM0lDrjvGq2jDnx+YyR+MOac4cwPvGhvFRr
	 WWWfxhrEEF9TXDOpV9L8aoULY9tZUJ5XLWiEcyBYd5qreZcTnPgHWN/crwtlaA3Hr2
	 swGgmr+yfaRMEBC8zeBjvannSqz0JeyGLnwk4iBgwsU7Zv2Zc5Or3s8EsfIpz3UH6y
	 7ag8XZbTDXMwQ==
Message-ID: <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
Date: Mon, 11 May 2026 09:10:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2160D140002
X-Rspamd-Server: rspam04
X-Stat-Signature: 1ha7zpcrmhyc8esmci5ix37bmb91xs9t
X-HE-Tag: 1778483413-417834
X-HE-Meta: U2FsdGVkX1/uOke6nXE29aMobCoWgyf51kTjAJowLNyQ+BNJvqqRO4B7dEYVOrjIUCtVb3lxA4AkKuEZGXxzxhY6H7j7fekzGxH4HRdGh/ny/n3SU6nZUAyi30Yszt286hygpbVxgFCaRjMv2I2d8f157Gjn+mw9hzNWUlyebT2CB5X6LwpYVKsNH4/X45EewRB4/VKUapIOf3lqpPKIwB2N0HUjxE/Xf9m5ztShICQrSS7OlDfAPSDDDTOHy2j9ecy8c0cZfgP/HLlKLSsL+nvnGB4df1ishIRLnYI9pGVP8A/deQAm7+IkmglWPkV6Cd8VhEa2q5/+doTXfXPfgDDjjMohBgCT+K1mEiCK3xLDLYrh28Sve6XF8++E0rxDQEsF+XEqKOewBoC38RToL3jCyrfmIoiKIMEY9FdvaQs2BS4dgP+afnLp5GA/IlAPg6QEdYOPbdksSs8WlkqDlXVkgiRwM4mEkZA4ENy+iMcTKuFXKVphMbfYw0bCerg4rjaB6iI+uj9Wm+IFNT72MOBc+pMVfdkd/tb0j9d4Cc25yjbEdEBqQKhG3jdc/Y0gJS6uDVpkcJwf19HJiBpiajMIlw+UG3mh8mH0ZPrCme85APZ06QLVJMIpDq9AGkUKE77muXgbo2tjbdtAQbZLj6PZVnpDKdVaLJX0+sFr0j0NaAowtRKbj8J7pF9WgE/Ri0lq9csiW5TRYRsRHTnj5nUpGX74EMSlA+cmVigD0b83oyxskBjNuEBId5Pl5WnhkGGiA115lyqDSJunTjRe5OryB6o2F6L9T+xP3gJ3mB5aEKNspbDUIxQzKT42d12SKzaW0hyGvSFw0Ki+3cf1CklKIsiFlGuEUQPpffyPAeI2Xo2paDNjH7vLCTLTIN0bLvANlN1Rop1Dhsvb+GCOlUXgx2fa6TDwEITHTX8OeOHbqbEjcWb0T/0mDdTfq39k3iDUpksmt4lImUL0COC
 Ys8LsfCh
 /ioP1x2h+jEgk7RTGtvVZWcD/66+eyHaaAGBI6QlZr9PkeHt165IvdpkVUbK79F++lbT9hQRzpS1HE5GmdIKFV1nL75lEvs/gUSennFiRR+o5E+WTcDvLnVfk51I3/ruwGZcMEalRX+qdq8mAljHixZyTRQF1tfo9YlOCCA8x1EwNiYHVni4wt1/EcGMygzwjYpi7Far/E5OeDVR/r5trj1ZMcM8weoo0S2/LXZvcNmXB+X/VuOnYmaCcsnPAWckwcloDQk7fRhgEVNZu7+oKnHLmw3ZzO9P/YHKDxoItAk1FbZg3kY5xTFHhzQDNtIcl/PFdYvPPBejpthDWFf3tvMrZjlxKynTtNETbu27YEzFUjH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:44, Dev Jain wrote:
> Simplify the code by refactoring the folio_test_hugetlb() branch into
> a new function.
> 
> While at it, convert BUG helpers to WARN helpers.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 117 ++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 48 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a5f067a09de0f..a98acdea0530a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,68 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>  }
>  
> +/* Returns false if unmap needs to be aborted */
> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,

I'm wondering whether we should make it clearer that this belongs to the
try_to_unmap family by calling it

	ttu_hugetlb_folio

> +		struct folio *folio, struct page_vma_mapped_walk *pvmw,
> +		struct page *page, enum ttu_flags flags, pte_t *pteval,
> +		struct mmu_notifier_range *range, bool *exit_walk)
> +{
> +	/*
> +	 * The try_to_unmap() is only passed a hugetlb page
> +	 * in the case where the hugetlb page is poisoned.
> +	 */
> +	VM_WARN_ON_PAGE(!PageHWPoison(page), page);

IIRC, we will never actually get a tail page here.

Can we avoid passing a page by checking instead whether the hugetlb folios is
marked as having a poisoned page?

See the folio_test_set_hwpoison() in hugetlb_update_hwpoison().

So you can simply use folio_test_hwpoison here instead.


> +	/*
> +	 * huge_pmd_unshare may unmap an entire PMD page.
> +	 * There is no way of knowing exactly which PMDs may
> +	 * be cached for this mm, so we must flush them all.
> +	 * start/end were already adjusted above to cover this
> +	 * range.
> +	 */
> +	flush_cache_range(vma, range->start, range->end);
> +
> +	/*
> +	 * To call huge_pmd_unshare, i_mmap_rwsem must be
> +	 * held in write mode.  Caller needs to explicitly
> +	 * do this outside rmap routines.
> +	 *
> +	 * We also must hold hugetlb vma_lock in write mode.
> +	 * Lock order dictates acquiring vma_lock BEFORE
> +	 * i_mmap_rwsem.  We can only try lock here and fail
> +	 * if unsuccessful.
> +	 */
> +	if (!folio_test_anon(folio)) {
> +		struct mmu_gather tlb;
> +
> +		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
> +		if (!hugetlb_vma_trylock_write(vma)) {
> +			*exit_walk = true;
> +			return false;
> +		}
> +
> +		tlb_gather_mmu_vma(&tlb, vma);
> +		if (huge_pmd_unshare(&tlb, vma, pvmw->address, pvmw->pte)) {
> +			hugetlb_vma_unlock_write(vma);
> +			huge_pmd_unshare_flush(&tlb, vma);
> +			tlb_finish_mmu(&tlb);
> +			/*
> +			 * The PMD table was unmapped,
> +			 * consequently unmapping the folio.
> +			 */
> +			*exit_walk = true;
> +			return true;
> +		}
> +		hugetlb_vma_unlock_write(vma);
> +		tlb_finish_mmu(&tlb);
> +	}
> +	*pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
> +	if (pte_dirty(*pteval))
> +		folio_mark_dirty(folio);
> +
> +	*exit_walk = false;
> +	return true;


Can we instead introduce some enum that tells the caller how to proceed?

I assume we have

(a) Abort walk (ret = false + page_vma_mapped_walk_done())

(b) Walk done (ret = true + page_vma_mapped_walk_done())

(c) Continue walk (call page_vma_mapped_walk())

enum ttu_walk_result {
	TTU_WALK_CONTINUE,
	TTU_WALK_ABORT,
	TTU_WALK_DONE
}

> +}
> +
>  /*
>   * @arg: enum ttu_flags will be passed to this argument
>   */
> @@ -2115,56 +2177,15 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				 PageAnonExclusive(subpage);
>  
>  		if (folio_test_hugetlb(folio)) {
> -			bool anon = folio_test_anon(folio);
> -
> -			/*
> -			 * The try_to_unmap() is only passed a hugetlb page
> -			 * in the case where the hugetlb page is poisoned.
> -			 */
> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> -			/*
> -			 * huge_pmd_unshare may unmap an entire PMD page.
> -			 * There is no way of knowing exactly which PMDs may
> -			 * be cached for this mm, so we must flush them all.
> -			 * start/end were already adjusted above to cover this
> -			 * range.
> -			 */
> -			flush_cache_range(vma, range.start, range.end);
> +			bool exit_walk;
>  
> -			/*
> -			 * To call huge_pmd_unshare, i_mmap_rwsem must be
> -			 * held in write mode.  Caller needs to explicitly
> -			 * do this outside rmap routines.
> -			 *
> -			 * We also must hold hugetlb vma_lock in write mode.
> -			 * Lock order dictates acquiring vma_lock BEFORE
> -			 * i_mmap_rwsem.  We can only try lock here and fail
> -			 * if unsuccessful.
> -			 */
> -			if (!anon) {
> -				struct mmu_gather tlb;
> -
> -				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
> -				if (!hugetlb_vma_trylock_write(vma))
> -					goto walk_abort;
> -
> -				tlb_gather_mmu_vma(&tlb, vma);
> -				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
> -					hugetlb_vma_unlock_write(vma);
> -					huge_pmd_unshare_flush(&tlb, vma);
> -					tlb_finish_mmu(&tlb);
> -					/*
> -					 * The PMD table was unmapped,
> -					 * consequently unmapping the folio.
> -					 */
> -					goto walk_done;
> -				}
> -				hugetlb_vma_unlock_write(vma);
> -				tlb_finish_mmu(&tlb);
> +			ret = unmap_hugetlb_folio(vma, folio, &pvmw, subpage,
> +						  flags, &pteval, &range,
> +						  &exit_walk);
> +			if (exit_walk) {
> +				page_vma_mapped_walk_done(&pvmw);
> +				break;

In the old walk_abort case you wouldn't set ret = false?

When returning the enum you could simply do something like

switch (ret) {
case TTU_WALK_ABORT:
	goto walk_abort;
case TTU_WALK_DONE:
	goto walk_done;
default:
	break;
}


While I like this patch, can we please just move all the hugetlb shite into this
helper function?

Essentially, get rid of hugetlb special casing in the remainder of the function.

That also makes the function name clearer (right now it's only doing a part of
hugetlb folio unmapping).

-- 
Cheers,

David

