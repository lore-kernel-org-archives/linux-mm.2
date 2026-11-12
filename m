Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968C2606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ku73Bd5y
Received: by kanga.kvack.org (Postfix)
	id BC93A6B05BA; Thu, 12 Nov 2026 06:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1A06B05BB; Thu, 12 Nov 2026 06:44:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93C96B05BC; Thu, 12 Nov 2026 06:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5456B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:44:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16EE840547
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:44:48 +0000 (UTC)
X-FDA: 85426285056.09.47D242A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 758B1A0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:44:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ku73Bd5y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29DfDf92HJiDUL83I37Z0UvfOScd+vQEdrJlJIoDRwA=;
	b=aP9S+aRfENtsINJ0iWvxRl5dhyuu7X70e+ARE0pGb9ByCQkyepFVVfzM81UgFNTnWGwukP
	EVlegfsqJ5h5BAbOB+fDpDbW0li24Qj33KAiuJSbWS7HZ2RAIkNQ3XM2VRPayWQjzkO7Ey
	6OiqhX5UsoVeV7LldmRZwHS5z5uKtFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483886;
	b=r9m/brb2DPfxI7AvmXAclQblWxRN0CCGdDn6HQLvwF8302lC73SG84izfKc+0j0KVg3YO/
	jV8cir4l+Hp/iJhIw/EXSktpXmhKsuG8XyzSASJmsM4+GPg+1nM7evP1xBO31jHYG8IU9y
	9gn70+cDovPJE/vBhmjzpw5Nu+nijIs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ku73Bd5y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFF4665775;
	Thu, 12 Nov 2026 11:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B0C1F00A05;
	Thu, 12 Nov 2026 11:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794483885;
	bh=29DfDf92HJiDUL83I37Z0UvfOScd+vQEdrJlJIoDRwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ku73Bd5yVw8b1EmirbB6jleUqSys9iYOVVK9yks/a5tGtyTHMJ0+fEGxF36zS0ytP
	 5EpOVVxk15XxPb/5DZS6vYUkekBPm8w6U5948DFvNmm1vf4EpMwk1mORPS7MHUWRLH
	 aKO93vIOStl3yHd146oBCCWPAdjvrKJg9/XlFy/Ab5+889DP/EIGy1J0E32/fZJpfu
	 RTJH8/jbs2rDwlbUmROAZqWeVx4/st8JltKaOOCATmPu7rG77dd9k2XA1WGPJPY/Zg
	 AKW9nE3UIc8YmGe+QVT3hnANsqYuVp3CS9r7ERYD8Gc9Np4g3yk+y02FZJCeCffOas
	 6iJFhsZyXnoSQ==
Date: Thu, 12 Nov 2026 11:44:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
Message-ID: <avWmiBbDYmy8MKiu@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
X-Stat-Signature: o96fge4mnf9rwqaytxfutkbbfxn8r355
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 758B1A0002
X-HE-Tag: 1794483886-14165
X-HE-Meta: U2FsdGVkX1/Nir7gZWhooI2qWGPlGuwfyKfwEbNsv+OUTHcHiFzVP/fkp7WSfp42NAXYcRPZ3q6x+9ksnmkb8PomQFs7t/8lxhKlJZDgGdFZxizPN9ZTpMk+ibegrnz4HuVvmSF3mhMb4rL47UYc+qKPJaSr5EM9pNHS7OvxpmeN2zaHtjO++KR7bl6GCIrmKzrkfqxIex17QCFRYaIJHY2k1q43UKZegvtPO54nxQmkVl6Sg/VRnRHa+dYfIbEJpnOJ+bpKmxZjyn/tduHRe5D33VsDlsGN712fBk3bGUGgvcWRNvstPc9GA4rOctE4dKSBHMRpw997zt0AoAV7PVnPpKAM13E2MMDOs8ZKb6F7Xe/yQ6Rr3GnfgC4VUfZWrtrJOl/P+XUbvmNH2PYQY5GMr/F3LP1lartjwodwAxHY61m04IkwmqlAIjOu2HbvxowCRjFDg4aoQFI1cdlBtoeneJhhLKbnutIpp62vbj3EJ/YfYwpUS9dQfZ1VcBpTLgN/fwDZFN2Pwi5RfoAsIGTla8iRRI+9UldlLYHb6I3Av+bfleMPl6eOkH41iq4C26zlOeBVK2r8qmWEmOgo/YutJxB4bxGaMgjIh4KHiUjw2jEa/fN2RGptsLmbTQccFWUmpFP1+o3r9GAzGq7qPLYij8GC22u25vN1oHMNLFD4Zcuj/BsYpMYUMxqAdIXOsQn+lJmmCBHPf/c20jzvFV8CXnmB7IjH52J83gUX5YFW1ige62bY2eHGQsF/3Y/5Dl5nRaOLLEV9HRhWm5Yq8+iaNt+0W43xDeBvC34nkMeSnqWB6MRw+LmVC3fLJynTJMfGQhsVE4dJYKWEkRNw9uUNmaH9HA3TqS0geLYKcuMpvPzu7d5P1XRzR0nMMFk+BMNUSPccmGeo8bYoAykjwOXimn0SxMrpjH/Pdf/EygLYHXLJNbEiU1hLxqEf6rVErlvmhsyJyicJO1YOfL/
 t0uItXgn
 xTRDMA9tetaReyHeZbdSF/D4R4DipgCug0YjQPco2I4dJ3nh/BCMxlQv9h4k1TF7EZNvan9wXf9qj0b8wBFjdsYLPisiqL7bcHmD+/2WXsqUpnwQNFddydMNvXdPkyF0VQIf3i2WGwQ3vYYl1eG7p84eive136zCG9GRYB1TF42ZYLb4u8TvJX+o8WVcFzyjU/sojuQ8NeWvKZbzKdk6PRClaz4eZYLDElfZ1+P1Obmf8Qc+n8Qzn5sZwGgkAPevl9lx14qhC72/mAaCri7GPlAqqRdOEBr8/FomJl1lKt0G25+cqtCZ6buCj8c6qoljtqO2umfINi2KNnG9q/FPVgqQHDuLbdEBquzgo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:15PM -0500, Tal Zussman wrote:
> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
> registered with userfaultfd: mremap_userfaultfd_prep() drops the context
> from it once the move succeeded. The uffd-wp bits, uffd-wp markers, and
> RWP PAGE_NONE entries in the new VMA must be cleared as well.
>
> However, move_ptes(), move_huge_pmd(), and move_huge_pte() clear them
> from each entry while moving it, before we know whether the move will
> succeed. If a page table allocation fails halfway through, mremap()
> moves the entries back into the old VMA, which is still registered,
> without their uffd state.
>
> Writes to a WP range are then no longer reported, and an RWP range
> becomes accessible without a fault. Nothing restores the protection
> afterwards. This requires a page table allocation to fail in the middle
> of mremap(), so it is rare.
>
> The uffd state must only be cleared once the move can no longer fail. To
> fix it, leave the entries alone during the move and clear the uffd state
> of the new VMA in mremap_userfaultfd_prep(), right before dropping the
> context, using userfaultfd_clear_ptes() like unregistering does. A
> failed move then puts the entries back as they were.
>
> This adds a second walk over the page tables of the new VMA, for VMAs
> registered for WP or RWP without UFFD_FEATURE_EVENT_REMAP.
>
> Like unregistering, userfaultfd_clear_ptes() also asks for the PTEs to
> be made writable again where that is safe (MM_CP_TRY_CHANGE_WRITABLE).
> The old code only cleared the uffd bit and left the PTE read-only. For
> private anonymous memory this saves the minor fault on the first write
> to each page that was protected.
>
> However, this adds spurious minor faults on shmem and hugetlb. When
> resolving, change_protection() rewrites every present entry in the range
> with vma->vm_page_prot, so a page that was writable and not protected is
> made read-only, and its first write after mremap() faults.
> UFFDIO_UNREGISTER and UFFDIO_WRITEPROTECT already behave this way and
> lead to the same spurious faults. This needs to be fixed in
> change_protection() and will be done in a separate change.
>
> The entries no longer need per-entry handling during the move, so drop
> uffd_supports_page_table_move(). Where the old and new addresses are
> suitably aligned, move_normal_pmd() and move_normal_pud() can move whole
> page tables of these VMAs again.
>
> clear_uffd_wp_pmd() has no users left, so remove it.

This reads a little schloppy, I wonder if it coudl be cut down a bit?

>
> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

This LGTM and is secretly a cleanup which I love :) So:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 25 -------------------------
>  mm/hugetlb.c     | 27 +--------------------------
>  mm/mremap.c      | 46 +---------------------------------------------
>  mm/userfaultfd.c |  1 +
>  4 files changed, 3 insertions(+), 96 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 09176b290f76..468a49041b95 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2616,18 +2616,6 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
>  	return pmd;
>  }
>
> -static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
> -{
> -	if (pmd_none(pmd))
> -		return pmd;
> -	if (pmd_present(pmd))
> -		pmd = pmd_clear_uffd(pmd);
> -	else
> -		pmd = pmd_swp_clear_uffd(pmd);
> -
> -	return pmd;
> -}
> -
>  bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>  		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
>  {
> @@ -2663,19 +2651,6 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
>  			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
>  		}
>  		pmd = move_soft_dirty_pmd(pmd);
> -		if (vma_has_uffd_without_event_remap(vma)) {
> -			/*
> -			 * See __copy_present_ptes(): normalise the RWP marker
> -			 * so the destination starts accessible instead of
> -			 * taking a numa-hinting fault on first access. Only the
> -			 * marker (protnone + uffd) needs it; leave other present
> -			 * PMDs in the VMA untouched.
> -			 */
> -			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
> -			    pmd_uffd(pmd))
> -				pmd = pmd_modify(pmd, vma->vm_page_prot);
> -			pmd = clear_uffd_wp_pmd(pmd);
> -		}
>  		set_pmd_at(mm, new_addr, new_pmd, pmd);
>  		if (force_flush)
>  			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb2de24affdc..97bd29925476 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5168,7 +5168,6 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>  			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
>  			  unsigned long sz)
>  {
> -	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
>  	struct hstate *h = hstate_vma(vma);
>  	struct mm_struct *mm = vma->vm_mm;
>  	spinlock_t *src_ptl, *dst_ptl;
> @@ -5179,31 +5178,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
>  	double_pt_lock(dst_ptl, src_ptl);
>
>  	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
> -
> -	if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte)) {
> -		huge_pte_clear(mm, new_addr, dst_pte, sz);
> -	} else {
> -		if (need_clear_uffd_wp) {
> -			if (pte_present(pte)) {
> -				/*
> -				 * See __copy_present_ptes(): normalise the RWP
> -				 * marker so the destination starts accessible
> -				 * instead of taking a numa-hinting fault on
> -				 * first access. Only the marker (protnone + uffd)
> -				 * needs it; leave other present PTEs untouched.
> -				 */
> -				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
> -					pte = huge_pte_modify(pte, vma->vm_page_prot);
> -					pte = arch_make_huge_pte(pte, huge_page_shift(h),
> -								 vma->vm_flags);
> -				}
> -				pte = huge_pte_clear_uffd(pte);
> -			} else {
> -				pte = pte_swp_clear_uffd(pte);
> -			}
> -		}
> -		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
> -	}
> +	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
>
>  	double_pt_unlock(dst_ptl, src_ptl);
>  }
> diff --git a/mm/mremap.c b/mm/mremap.c
> index fff0465f5e06..4564416a6994 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -198,7 +198,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
>  {
>  	struct vm_area_struct *vma = pmc->old;
> -	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *old_ptep, *new_ptep;
>  	pte_t old_pte, pte;
> @@ -290,27 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
>  		pte = move_pte(pte, old_addr, new_addr);
>  		pte = move_soft_dirty_pte(pte);
> -
> -		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
> -			pte_clear(mm, new_addr, new_ptep);
> -		else {
> -			if (need_clear_uffd_wp) {
> -				if (pte_present(pte)) {
> -					/*
> -					 * See __copy_present_ptes(): normalise
> -					 * RWP PTEs so the destination starts
> -					 * accessible instead of taking a
> -					 * numa-hinting fault on first access.
> -					 */
> -					if (userfaultfd_rwp(vma) && pte_uffd(pte))
> -						pte = pte_modify(pte, vma->vm_page_prot);
> -					pte = pte_clear_uffd(pte);
> -				} else {
> -					pte = pte_swp_clear_uffd(pte);
> -				}
> -			}
> -			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
> -		}
> +		set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
>  	}
>
>  	lazy_mmu_mode_disable();
> @@ -334,25 +313,6 @@ static inline bool arch_supports_page_table_move(void)
>  }
>  #endif
>
> -static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
> -{
> -	/*
> -	 * If we are moving a VMA that has uffd-wp registered but with
> -	 * remap events disabled (new VMA will not be registered with uffd), we
> -	 * need to ensure that the uffd-wp state is cleared from all pgtables.
> -	 * This means recursing into lower page tables in move_page_tables().
> -	 *
> -	 * We might get called with VMAs reversed when recovering from a
> -	 * failed page table move. In that case, the
> -	 * "old"-but-actually-"originally new" VMA during recovery will not have
> -	 * a uffd context. Recursing into lower page tables during the original
> -	 * move but not during the recovery move will cause trouble, because we
> -	 * run into already-existing page tables. So check both VMAs.
> -	 */
> -	return !vma_has_uffd_without_event_remap(pmc->old) &&
> -	       !vma_has_uffd_without_event_remap(pmc->new);
> -}
> -
>  #ifdef CONFIG_HAVE_MOVE_PMD
>  static bool move_normal_pmd(struct pagetable_move_control *pmc,
>  			pmd_t *old_pmd, pmd_t *new_pmd)
> @@ -365,8 +325,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
>
>  	if (!arch_supports_page_table_move())
>  		return false;
> -	if (!uffd_supports_page_table_move(pmc))
> -		return false;
>  	/*
>  	 * The destination pmd shouldn't be established, free_pgtables()
>  	 * should have released it.
> @@ -434,8 +392,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
>
>  	if (!arch_supports_page_table_move())
>  		return false;
> -	if (!uffd_supports_page_table_move(pmc))
> -		return false;
>  	/*
>  	 * The destination pud shouldn't be established, free_pgtables()
>  	 * should have released it.
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index ad9d243dc64b..bf42fabb5afd 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
>  		up_write(&ctx->map_changing_lock);
>  	} else {
>  		/* Drop uffd context if remap feature not enabled */
> +		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
>  		userfaultfd_reset_ctx(vma);
>  	}
>  }
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

