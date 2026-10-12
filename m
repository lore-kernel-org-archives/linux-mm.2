Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8867CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0106B009E; Mon, 12 Oct 2026 08:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C709C6B009F; Mon, 12 Oct 2026 08:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD746B00A0; Mon, 12 Oct 2026 08:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95F7A6B009E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:07:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19BAD1C469B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:07:33 +0000 (UTC)
X-FDA: 85313849586.29.7CD81A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88DD880009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:07:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLcO5592;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806851;
	b=fcl+VgrlCXh0Vl5kSDprBvbVkaBV44M3WAPmQPjRTW5DilLcgbnG+abaTw6UrfYE/t/gM4
	ztHCP1jNqeIdgaMdPqqWcb1UIAcwA9WP8jFvtFrAqyINtgirXBgAT51wrS0GeXROvNCWDG
	zOxY6ACmKf3KjLOLrorLwGzWu24Pzsg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MLcO5592;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OQPr0ut11DqRv4tqIdGPLsEg2aaqnjobrfhtZ7EnVI=;
	b=3LpgyveRLmDk7o7xlGk5opoOTscPz4pPUd69D392uBnfxXScGijqN1tSJ17kfSevsEVM7d
	qLBxj37DeXRYsLrNcu0qsV3qwyL60l0zJoLmA5KgVON4hOWODvbsyPjwojZ0sw3h2UPVPg
	YdDrrzpP1qSMOlwNF8eeyy+4vh0xa/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5B0360229;
	Mon, 12 Oct 2026 12:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479031F0089B;
	Mon, 12 Oct 2026 12:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791806850;
	bh=5OQPr0ut11DqRv4tqIdGPLsEg2aaqnjobrfhtZ7EnVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MLcO5592LBj+bW5ZURBdZCsaxhSYcMr4j25Am5j8TvngwDTnNlpAoOqeeDUEyM3vP
	 9VNdGChfP8vSpA/YMNohtHSH28RS8ZnP0g975585/iIqdUZRNUUJ1kze6FADNofkTr
	 vGiBukdr9OPAdfR4l6V5qK1Yx6d+3BeXAoSGre4fMZaL09whilv0aGST7LDYdh/Rpr
	 avrAf5WxdN6OkRnMm7yJE5Jx/iPP3uqqDXkGWfhEnaCuYbcV7aRbRUmsnRxsJZ6myb
	 iIKvpsjnSV8y7Q8n75WrGPcfJg3YHhKwVqHcimHKs9iG7ulILJP2jnscPPy4ro0RUY
	 oR2HocTVFXRng==
Date: Mon, 12 Oct 2026 13:07:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <asy445BYRhcsGDE9@gremlin>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88DD880009
X-Stat-Signature: ew158qqi6z675mtdkf94719hyf19tzce
X-HE-Tag: 1791806851-79768
X-HE-Meta: U2FsdGVkX1+3QwBWdgTjRKYMwCdY4uWLTTr+tY/PVIvnJX/sH5AREGMHtv919nB+jyRQGPVumIkRmfmZqcRYkLkXQEn81324ksRmxfhpNcsoW7d1ZRY+En6PiJSx68kqRO5r+Jwh5uH/XSl3g27HLvAVAQtzBiqmMjy9WFCdquesHoj5tpTf/OaGmXH6qKOP6SpePwEcxNt6o6ElIA1Q5lx0eymnbG+YmzQQX182Jqd32yV2aiVanRpTKuSGn7MgWC4rBJ20eiNVIWaaf5DRr4UGJZTiKQZEWkRuEFIBXQxRTBTo+hYp3ctGEOz6mugPfpI8e5sH//930vIf8IiTMeVchzbxptjKbZR6XA9gPCHIpr1U3QWx776KGhmd74IJ9HWwirQ0eoAdS9rNyXHZ1ioWgknVgcFNPhgB4q7ftbPKiOsXD7exq2u/Elqu7Gh1EjvOfQQrU5Ts0jrvh9vL6xzY0VcMtmP3ewLi8yV7URKwbUx9x7dAcns+r14UubrMNhAg28IjcYKoCnRsz8lV1yPFgl/nIHIU6rWYVqpPp1MZawyTnVbm11Sz48RNpTYItJKoyEZH59zo7ArR1QWfKSRS6VcD6MHF8tKVR4wzui7+1y71HW71U2ckQcoclIhTJ/UT7x3HCvxPxxL58QipI91MDxczNVa37ond1oEhYQKSQhHre3ROCPeLP3CSSg9igR0XJOPWqWfBeM2xCzTYoyw+P+y6xeEz0HmXB7mf+xuwdXFAo5sCnQHNOYczblkVE2owfeHVGzShmYj6WDpOoZiuvKQMPD4JBPKJMLfGp2DTrqh4h37K0oc6Rx2rBkxvJ6Rt0E5uK4iMYmIPBBooH1rRiWgqVj36p2ojmk14PiTwFpVWiE4jb8eR3C4pg0hVv78JhmN2aESDqd6ufJ/DRhsmg2DIiSFKN/78AFEjbsJrCjg/y4y7H6yXOyeIu8GQNCzH+z7BxhJHiLnZ83u
 0maJe1mi
 G4lXZd8tIRD8xmvo5utgBZgVHQN81QORtSeaUBO3TLCeYA2GrQeDUnsFX4A+LZEfw04Bw2oIKAceByTdvWCOi4/2kQ2DRVR1N8Nel2hM9h4OLmNoq2BnN0x6rLleGi+br21sHhexUsWtzC5/3E3udKKT27C3kJEriWi+nNrSqnxPE9Zg1phpLgW7qX0LoKShzjlZupyX7gOr45lTBvq6a5cDy18nM4vkeaLlxHFgJynZ0iDzvkpeDunvnE+4q539grSERXTu4DoSkq8VbIU5eW+VlMMdcfw32GB2ixu4YFXuJ/mQimLHngCzQDy8faJ1eWCJN63zaFB02emo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 10:08:18PM -0400, Zi Yan wrote:
> __discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it knows
> whether the folio can be discarded, and restores it if the folio was
> redirtied or has extra references. A concurrent munmap() or
> MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
> anon_vma, so the folio stays mapped after the anon_vma is freed and a later

Yeah this seems pretty horrible, instating a page table entry under the rmap
lock is pretty gross in general, is there anywhere else where we actually
_install_ (even if 'reinstate') page table entries under the rmap lock?

I think this commit message needs to be clearer/more detailed though, I've been
sat here working this through in my head for a while.

I'm confused about the locking, which is really the key point about this change
isn't it?

unlink_anon_vmas() takes the anon rmap lock so that can't happen concurrently,
so is it _just_ the case that:

- The folio is not properly freed/unmapped and ends up with a dangling anon_vma
  pointer

In which case, nobody can actually access that folio since it's not mapped
anywhere, or is it the far more terrible case of the above and:

- set_pmd_at() in __discard_anon_folio_pmd_locked() reinstates the pmd entry
  regardless of the fact that the VMA and surrounding page tables could go away
  concurrently

?

But I'm confused here because unlink_anon_vmas() takes the anon_vma lock?

EDIT: See below, I figured out what it was.

Looking at the code:

<anon_vma lock>
[reclaim]
< PMD lock >
-> try_to_unmap_one()
    -> unmap_huge_pmd_locked()
      -> __discard_anon_folio_pmd_locked()
        [ clears PMD entry ]
	...
	[ reinstates PMD entry later ]

Concurrent munmap():

<mmap write lock, downgraded to mmap read lock later>
do_vmi_align_munmap()
  -> vms_complete_munmap_vmas()
    -> vms_clear_ptes()
      -> unmap_region()
        -> unmap_vmas() < zaps > <----- EDIT: the real issue, see below
	-> free_pgtables()
	   -> unlink_anon_vmas()
	     -> < anon_vma lock taken! >
	   ... clears down page tables (no rmap lock) ...

Is the issue actually the zapping in unmap_vmas(), which doesn't seem to be
protected by rmap lock at all, meaning that _that_ can happen with
concurrent munmap()?

So unmap_vmas() doesn't correctly populate the mmu_gather struct for the
range, meaning that the underlying page isn't freed and the refcount,
mapcount etc. are all left as they were?

MREMAP_DONTUNMAP seems a bit of a bizarre callout, but I suppose it is the
other case in which (under certain, likely, circumstances
e.g. non-partial/self-merging remap) an unlink_anon_vmas()'s call is done.

With normal mremap() that'd happen via an unmap of the original VMA.

> rmap walk uses the freed anon_vma.
>
> Using an invalidated PMD instead of a cleared one requires additional arch
> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
> shrink_folio_list()").

Again it feels like this commit message assumes a bunch of information that
isn't presented here.

Why would you need to invalidate the PMD? Is the issue actually TLB flush?
How does that get around the fact that a PMD entry can be 'reinstated'
concurrent with a zap?

Or is it that you put something not-pmd_none() there? Hmm yeah I think so.

Doesn't all this cause pmd_none_or_clear_bad() to fire too?

All-round terrible.

I've not dug into the reports in detail, but I think the commit message
should also talk about what exactly is missing from pmdp_invalidate() that
is broken here? Are some arches not doing things quite right?

OK reading the code more and it seems the _real_ issue is actually
pmd_is_huge() in zap_pmd_range() right?

It's the -> pmd_none() in general. By doing that, you are breaking a
contract with PMD leaf entries.

So you get:

zap_pmd_range()
  -> pmd_is_huge() ? [ no ]
     -> zap_huge_pmd() [ WOULD HAVE taken PMD lock that blocks against reclaim ]

So using something like pmdp_invalidate() avoids this, because it keeps the
entry huge but invalid.

But I guess not every arch does this properly somehow?

>
> Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()")
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>

With the commit message made a lot clearer and calling out the specific
locking scenarios that allow this + getting rid of the dead code:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> The proposed fix[1] requires additional arch code fixes[2]. Disable it
> first for stable fix. The function will be re-enabled along with arch code
> fixes.
>
> Link: https://lore.kernel.org/all/20261009165214.40212-2-kylebot@openai.com/ [1]
> Link: https://lore.kernel.org/all/DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com/ [2]
> ---
>  mm/rmap.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 805db93fe0428..1131b76bbbc28 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>
>  		if (!pvmw.pte) {
> -			if (folio_test_lazyfree(folio)) {
> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))

This is the only caller of unmap_huge_pmd_locked(), making that and
__discard_anon_folio_pmd_locked() dead code, shouldn't we remove all of it?

Otherwise we're leaving dead code around.


> -					goto walk_done;
> -				/*
> -				 * unmap_huge_pmd_locked has either already marked
> -				 * the folio as swap-backed or decided to retain it
> -				 * due to GUP or speculative references.
> -				 */
> -				goto walk_abort;
> -			}
> -
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
>  				 * We temporarily have to drop the PTL and
>
> ---
> base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
> change-id: 20261009-lazyfree-stable-fix-67712b2049dd
>
> Best regards,
> --
> Yan, Zi
>

--
Cheers, Lorenzo

