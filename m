Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B717CD6E7B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9D56B0092; Fri,  5 Jun 2026 13:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480A26B0095; Fri,  5 Jun 2026 13:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3970E6B0096; Fri,  5 Jun 2026 13:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28C436B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:48:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B51D7A0283
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:48:35 +0000 (UTC)
X-FDA: 84846593790.27.C872F28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C00B620010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:48:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkmcYYzG;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmJ+4Vv5SanG71jFELjTxWcwVOj/fu6/r0NzV9M26yY=;
	b=LVT7kG5ZRGfWABu+jY1CGPcfK21DjJ71jB8VR1s3pC022JT6wyPgvggTImgrRLixVKqbYC
	boWMQbGxgVVZ6dNps7roKczAcfxjABpRjXC71C7z9ndU9rippU/+4rPAOujBGHWI1hp6NY
	8hTMjHIGBLap8azYl2wuWcJbUyWAmfk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkmcYYzG;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780681713;
	b=UDD4fNufDb6MaaQOvHL1wbP7hjQ++KTr+/CUbxnNAXmyy7aoByP2gtjGt4pFD45HiO2oun
	1KVAwoaNaYqPI6kvKMaEVt2weaSHHNKrjiRuPdElLkau4TiFj3orHwuTi4muyuBu7e0wQc
	DGshcflyPFhltjQmlrrUd6ub9MYYpMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5A5844046;
	Fri,  5 Jun 2026 17:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FAB1F00893;
	Fri,  5 Jun 2026 17:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780681712;
	bh=YmJ+4Vv5SanG71jFELjTxWcwVOj/fu6/r0NzV9M26yY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jkmcYYzGWD1lltC9KBboZ1Lk+Z7lzUvhC0L38QUnjDAgpIVdLzxM4rSkeHUSC56I6
	 LRqIgNAuJdT7yOMQbeuVCpvRJR7AcMx55vCnYU42EoM7ZO9XKIUTqf/kY7/WjVL4eV
	 +QyLpQbEPC53OPS7IbCMrtTe6Y3Q3eS5fbLP1h5gY993zsb5QSHBSFf15i1o6YVdiN
	 JunHCvLbLkpNMZ7xU4hkShwaf39/fWu+GHRiI0r07GrwEi/mE7Gj8bUFy61aILA3iG
	 0SYuJTFXPafclmUBLLVVFvrRMfeGsxoiEVXfcBqGOUVfOFf1CHLE0+M3Q8sd6DkaoV
	 SiLucUWeZQrIA==
Message-ID: <95390529-3a80-473c-9433-958db7a2dc6c@kernel.org>
Date: Fri, 5 Jun 2026 19:48:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v19 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260605161422.213817-1-npache@redhat.com>
 <20260605161422.213817-7-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605161422.213817-7-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C00B620010
X-Stat-Signature: yukkyy7wo3py1kgi97hdca9h1ie71mfq
X-Rspam-User: 
X-HE-Tag: 1780681713-589467
X-HE-Meta: U2FsdGVkX1+X3axmkqIvJpstKs45J/Qjd3SqgbrHKtut8teNxAnouuhh3/dxLg6ck3eaHc8gYCbMI3ifG+g2GJiwKXn2yprGVjsAghnyUvxgJAfmD5NCcIKfCQaGywMucvSV01thJ4DAsvaqKSHMey8HLuvaLplFDHJu40FjZMBA+NSEYu1cvUbd2QHoTeUNNbaXyXtWLmUPX5yOdHSQzwAzOi6Bjd6HM54z6xqHIHrAkUa2wfNx8QPTkqyObJFkp7oQ0jtjxzJ+s+i5UZfOCA2FRNddeOMXFaynWjlLw/f3DfUfbxtBZjV/F2DvdhlUxZuzIrLCxduEbk3HwdAnTVw6VZ3w8BBdm25eY0ty3FL5phzzvRDXOrvjbb3s9K8aLi0ilyh5blwrhg/HGtpDbPtJI3gM7pCkqh965AusTiF75ys2f3rUB/MVpK8lcdwcoSkpa46V9WMeMIH/l5zwgiNjeyCB5oYzW6SVqvfpIC7VomBFm6kse3aj5JTOax3qcjyjzB1dnQfeGxDIlshVACrB8TSr8tNYFFED2LueXVo4DNxpTt+u3Xl4FFXsethMq5A5CyO6ALsbEWM1PNEZ4/rR6gQBtOlhtdwtPkyQ70etQELMsowvPhUJKmLhaMxlknnOAz7au16Hfjqs6dJ3+F/lZRh+iBmPrro83RSerA6bWG8GQJnL4YJShwUML3w9AvUO4pyFEn2a4FL0E04In1A3JgZyVD9TXKFXEUIK2+9AaoLKBA7RzZVH05RsXKjSaBzYwELNY+eZhDo5rhOgMOH+aTuUlNPmJqh8IGD252nrC21nflG2wnt1E7qL1TZXVMhdEa2999XIaoljZOsG0DCYTjE2dwiSRhZlR62BjERnYbt+cijZ8OHeYPOPtd/6vMjjWlaeHu74HAcMTHx0dQc2y6O8FY/8L3LqvyQfX0RofK8HMcAAnRhn0ieq1/rHwBh2VBonhAUrt3IDJFE
 fIIbeGDp
 JFK06ioVnO7ifJe4UPReMamcDBouDmsOCe/2PrbSEGVhjn+KosHF1L3PdAWD0tGIL9MpjwxEtM9XMz7wQDohob+yCOhAgetBVQc2SHIF4/xD8hZcwo/B2Hk6cJEd7YvXi0mgUFA/PfCzsVCs4DT9Vfm63x65B+OpbbsYkFREa16UcAbH0l1EH8gTkBOk8JUP+wrcIpZFHK22eMeU3DCeGZl1r1E01ekLxgMu2NpNO5C1X2jJOU7elxOd7djAPWqSMDDtGurYZgoaOt7+sezIPFO1fyfkcDp8dHkM8MUuaU12/hJD0cHkGrPbBNVTIaBC+ZVZhl4JsUfIyl6T5TIIWkuWDqwvHTaWioQJnV+X4LNrNBxT53SGhI/L0Xph3c0s/pyPFIUnYIvpWVf5b+cctGU5Sy8s6pCj1o5gO1wqgY7RXGVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/5/26 18:14, Nico Pache wrote:
> Pass an order to collapse_huge_page to support collapsing anon memory to
> arbitrary orders within a PMD. order indicates what mTHP size we are
> attempting to collapse to.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
> 
> To properly establish the page table hierarchy without violating any
> expectations from certain architectures (e.g. MIPS), we must make sure to
> have the PMD reinstalled before the PTEs, and hold both PTE/PMD locks
> before calling update_mmu_cache_range() (if they are distinct locks).
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

[...]

>  	 */
>  	__folio_mark_uptodate(folio);
> -	pgtable = pmd_pgtable(_pmd);
> -
>  	spin_lock(pmd_ptl);
> -	BUG_ON(!pmd_none(*pmd));
> -	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> -	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
> +	VM_WARN_ON_ONCE(!pmd_none(*pmd));
> +	if (is_pmd_order(order)) {
> +		pgtable = pmd_pgtable(_pmd);
> +		pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
> +	} else {
> +		/*
> +		 * Some architectures (e.g. MIPS) walk the live page table in
> +		 * their implementation. update_mmu_cache_range() must be called
> +		 * with a valid page table hierarchy and the PTE lock held.
> +		 * Acquire it nested inside pmd_ptl when they are distinct locks.
> +		 */
> +		if (pte_ptl != pmd_ptl)
> +			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
> +		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> +		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
> +					  /*uffd_wp=*/ false);
> +		if (pte_ptl != pmd_ptl)
> +			spin_unlock(pte_ptl);
> +	}
>  	spin_unlock(pmd_ptl);
>  
>  	folio = NULL;
>  
>  	result = SCAN_SUCCEED;
>  out_up_write:
> +	if (anon_vma_locked)
> +		anon_vma_unlock_write(vma->anon_vma);
> +	if (pte)
> +		pte_unmap(pte);

We re-enable some page table walkers before we unmap the PTE.

We still hold the mmap lock in write mode, so nothing would currently try
reclaiming the page table concurrently.

So I guess this works right now, but we should likely rework that code later to
either revert both statements. Or maybe we can simply unmap like we did, and
simply remap before we call map_anon_folio_pte_nopf()? Remapping should not fail.

Alternatively to an unmap+remap, I think we could also unmap earlier for PMD

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6de935e76ceb..ba2a2508dda6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1378,6 +1378,8 @@ static enum scan_result collapse_huge_page(struct
mm_struct *mm, unsigned long s
        if (is_pmd_order(order)) {
                anon_vma_unlock_write(vma->anon_vma);
                anon_vma_locked = false;
+               pte_unmap(pte);
+               pte = NULL;
        }

        result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,

But this can also be handled later.

We now hold an anon_vma lock a bit longer for !pmd-collapse. But there is also
less to copy. If that bites us, we can try optimizing later.


So after another skim, I think this patch is ready for primetime. We can address
the things mentioned above later ... and any fallout can be fixed later, if any.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

