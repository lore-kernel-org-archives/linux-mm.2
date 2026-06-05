Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675FFCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DFB6B0005; Fri,  5 Jun 2026 14:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF0B6B0088; Fri,  5 Jun 2026 14:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914D16B008C; Fri,  5 Jun 2026 14:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 81BF76B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:15:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5080E1A0245
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:15:39 +0000 (UTC)
X-FDA: 84846661998.11.216F360
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 92301100012
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:15:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WPs0Z/Oj";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780683337;
	b=jCK+RAf/5OkKrR3nDOqTeq+dA+Ivs6z8c22OVoiz9INf1CXXBuLCFh48YbG8TosR+Z+WS1
	sdYjY0O9CGoJhC6o8STcLCbNAO4TU0n1woNucmYS4ZoDwiaC0lvIAJGCB/oy2PtOYplfi1
	0qS2w/Lg+SwcbtHlw2PxIHtyPsSWn9Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WPs0Z/Oj";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780683337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reeAFoaFN+CcGwhazrbMB4doZ8QUZrono+SMRJCmxq4=;
	b=8FB3eUsLhoz3CPSf9VG6PYsfPSQv9SrvUaK6bjMnJOGzVYkn7jHYtsu6Yk0Cub4vQQiwSS
	EEbWRekaKsPs4CJeTMhtukmiMXpnf4cMgPRJN6rjgs1xevZr6x9pnhYFuyJmP1XHSN+ERF
	hdNcaloA4QJXRnK0jaUc9htNDRHenDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC1BA601DD;
	Fri,  5 Jun 2026 18:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FA71F00893;
	Fri,  5 Jun 2026 18:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780683336;
	bh=reeAFoaFN+CcGwhazrbMB4doZ8QUZrono+SMRJCmxq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WPs0Z/OjVHZLjqP6hNhuyanUv7GJ5SEtlBUVtbQu6bVhaiqKvCUIcR7tBr+PRPxS5
	 Zo7NUDhX2vZubZ5fIXOKAg7MlxnlPrg443U7H8kngrWNWMPC+HfNlry25RKXxLH66d
	 jppbwogIn0jn1YS5vFuk+Cm+KNAl20X4dUZcbxcph2vRe/J6my9mqIZmQFtgDAGLfC
	 GdFjC6m9tdw/t2STwogh9W9QR+5hq84UuYwCgQ1vfs4WxHuUe5hfN6STzhqhGb1OFb
	 TYRyz16RQ5buQbFEuba0FsGKPanpGD5jYsutLbw3f5LKGiEAUAjVu3VJqbH6PIdB25
	 +a7/RHLTsvMwQ==
Date: Fri, 5 Jun 2026 19:15:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiMNT7fBUkZS1EJK@lucifer>
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-7-npache@redhat.com>
 <95390529-3a80-473c-9433-958db7a2dc6c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95390529-3a80-473c-9433-958db7a2dc6c@kernel.org>
X-Rspamd-Queue-Id: 92301100012
X-Stat-Signature: d3tcodfwzm5qnbjnb8icjdtnqrwywngi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780683337-581255
X-HE-Meta: U2FsdGVkX1/NIG9WHaY8uP8+7yhCSrTR8Z8cW7YIf69G3aZ+LNH0XWm2p3mqckwjqn+PsybCdySSyIFFBlG/I1dhr/9zRb/1DG961GOs1EjL4toEzjDyjtL+MmE5tZb1Qhk+nKmPnxXgP9+1JiA1swheljVxBio5rvPskWBmBQwndwsUCJOLfdlzEecANkTZX1eZk4HxDllmf0JtI3wb2k4chkRaKwPMlR2R0O4P2qMDvm2HJnvBj3LlNoOGljpAuEeZPJwf3t+PpUDvUhqHpbKicXe/gWv3f03R5PQmAJXCB515cs3CL99Cx+9jfhGbq1emnNvchuL05nG2nRRCtMdmMBGyAGKuFhDBlyN25+93guab9qHrOQ/Ie3rXLh76T+v9UtYSlDLMe46oWu/WCvXn2FM4J50yT0Q6hwEGd+ETXTK2zx9eTUgvVftNzaPm35N1fgCIvwowyI8weFIAwbmRc2pO3PDAqVJ3n0lCwHH3upcy6V1dR1Mrlm/3qKQLbZ55qE5G0uVEiMSYIeq/Y3pQzHnhjfKsBPEeAIvqbVC9NtkbwTQkh2OcIKaigOcoYg0HAoewT6LDffTs8bSc59V1l1+UkO42b5nGH+vd0C+UkB7/zRC0g6WJNSgDrME8188dxq6+D8cO2ArQEJl/3PpTApUfpy8I5AdOOuQgA9ovAyp+5K0OfLEdxlQ5d8vCixppCOq2XyV2Er8danbCevU6SgI9us1pr6VPqqlM8IwEKP4LVyicUp+9XKFkBF6bUpCXY8SjDqefQkyx5mxEzknsk9mX4R6qp43SLMTR7oRd2vRLWIr29tk78rDK9fWOq8VwnUouWHgcDDxVTIzY7i5KL8b+h7UCPftHvB2HFh5/dRGZsdMvEOk0bubKE8vu6VqFCKCbECCltaa7Nzo2fQ+A7pRUCCXcWQa5jqCNWhQixmXmwLcLwQ3ala6gxn6+MVrAGPuqa/zkPa00V5I
 1Wo0jyhe
 rmCzX7zr3LSdSZ9D1//SiirPdxB+RSigywSKXAwChJNYC88h6tSwiK25jZXLk+EbC+A5/e2eeQxVqLUWIupw67uD4f2AGyoTKjdds3DtcueCVt+AbcMl9maoriS6Ym2KFwfD2KWQ0/fnqOAeMV/v+26URNK+UkWoZebQhxjI3PljJh/RHjeVXSRZYWBbyUOM0lyioMZJAZdkDaJpFiN6EWPnVNa79tQfmpWydqp09h+SEVF52N4V9zl49U7od+NPkK3OgYdtJp0MZL3zeY5m6htUSFxiuclMdNNG2WwQH7wAEa1ZUk4gfZ8NIadRktLx7/j0JHFzaOeG67zFjHtgLpaNh90gC7IjGdSyFZ+IAl+rNkt0Yn7hzhU+fTVxLkGUCj0+uTGbSnkTQP5KD1zKEAVzyipLgRj+semrK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 07:48:17PM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 18:14, Nico Pache wrote:
> > Pass an order to collapse_huge_page to support collapsing anon memory to
> > arbitrary orders within a PMD. order indicates what mTHP size we are
> > attempting to collapse to.
> >
> > For non-PMD collapse we must leave the anon VMA write locked until after
> > we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> > the mTHP case this is not true, and we must keep the lock to prevent
> > access/changes to the page tables. This can happen if the rmap walkers hit
> > a pmd_none while the PMD entry is currently unavailable due to being
> > temporarily removed during the collapse phase.
> >
> > To properly establish the page table hierarchy without violating any
> > expectations from certain architectures (e.g. MIPS), we must make sure to
> > have the PMD reinstalled before the PTEs, and hold both PTE/PMD locks
> > before calling update_mmu_cache_range() (if they are distinct locks).
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
>
> [...]
>
> >  	 */
> >  	__folio_mark_uptodate(folio);
> > -	pgtable = pmd_pgtable(_pmd);
> > -
> >  	spin_lock(pmd_ptl);
> > -	BUG_ON(!pmd_none(*pmd));
> > -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> > +	VM_WARN_ON_ONCE(!pmd_none(*pmd));
> > +	if (is_pmd_order(order)) {
> > +		pgtable = pmd_pgtable(_pmd);
> > +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> > +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> > +	} else {
> > +		/*
> > +		 * Some architectures (e.g. MIPS) walk the live page table in
> > +		 * their implementation. update_mmu_cache_range() must be called
> > +		 * with a valid page table hierarchy and the PTE lock held.
> > +		 * Acquire it nested inside pmd_ptl when they are distinct locks.
> > +		 */
> > +		if (pte_ptl != pmd_ptl)
> > +			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
> > +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> > +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
> > +					  /*uffd_wp=*/ false);
> > +		if (pte_ptl != pmd_ptl)
> > +			spin_unlock(pte_ptl);
> > +	}
> >  	spin_unlock(pmd_ptl);
> >
> >  	folio = NULL;
> >
> >  	result = SCAN_SUCCEED;
> >  out_up_write:
> > +	if (anon_vma_locked)
> > +		anon_vma_unlock_write(vma->anon_vma);
> > +	if (pte)
> > +		pte_unmap(pte);
>
> We re-enable some page table walkers before we unmap the PTE.
>
> We still hold the mmap lock in write mode, so nothing would currently try
> reclaiming the page table concurrently.

Reclaim uses rmap walkers though?

Oh you mean as in page table teardown, we're safe from higher level page table
teardown, but we're not safe from zap PTE page table teardown, as
CONFIG_PT_RECLAIM makes this possible on zap now.

That is RCU safe, so the unmap would keep us safe here, but now we could lose
the PTE page table.

But, only MADV_DONTNEED sets reclaim_pt = true, and that holds the VMA read lock
so we're safe.

And anyway:

MADV_DONTNEED - VMA read lock (we hold VMA write lock)
zap_vma_for_reaping() - mmap read lock
process teardown, munmap - mmap read lock
fault - vma/mmap read lock

So the vma/mmap locks save us from those.

So rmap-wise, only the i_mmap walkers remain (truncate, hole punch, et al. and
also hugetlbfs truncate/hole-punch which does its own nonsense too), but none of
those allow for reclaim_pt to happen in any case.

So yeah we're safe but we should what, reorder these 2 statements?

But yes I agree that can be a follow-up, nothing's broken AFAICT.

>
> So I guess this works right now, but we should likely rework that code later to
> either revert both statements. Or maybe we can simply unmap like we did, and
> simply remap before we call map_anon_folio_pte_nopf()? Remapping should not fail.
>
> Alternatively to an unmap+remap, I think we could also unmap earlier for PMD
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6de935e76ceb..ba2a2508dda6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1378,6 +1378,8 @@ static enum scan_result collapse_huge_page(struct
> mm_struct *mm, unsigned long s
>         if (is_pmd_order(order)) {
>                 anon_vma_unlock_write(vma->anon_vma);
>                 anon_vma_locked = false;
> +               pte_unmap(pte);
> +               pte = NULL;
>         }
>
>         result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
>
> But this can also be handled later.

Yup I mean it'd be nicer to do it in one place if we can (+ impact of holding
RCU lock longer not an issue), but all this code needs rewokr anyway.

>
> We now hold an anon_vma lock a bit longer for !pmd-collapse. But there is also
> less to copy. If that bites us, we can try optimizing later.

Yeah I do worry about holding these locks longer. But we'll see.

>
>
> So after another skim, I think this patch is ready for primetime. We can address
> the things mentioned above later ... and any fallout can be fixed later, if any.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Yes, also from my side - after a git range-diff and looking into above, LGTM,
so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Now to go look at the core algo patch :)

>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

