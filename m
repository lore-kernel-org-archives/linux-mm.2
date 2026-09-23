Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32D8C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 18:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7326B0088; Wed, 23 Sep 2026 14:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE876B008A; Wed, 23 Sep 2026 14:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3C46B0095; Wed, 23 Sep 2026 14:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 508546B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:39:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AF5F808A0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:39:10 +0000 (UTC)
X-FDA: 85245889260.05.38C1191
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C80BC0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:39:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VV7U2RDY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iUaYymco;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m0WtN9eO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uf0dXioQ;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790188748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ii8zjXOvCjg0J/8vHyFLQds1UkGP0eIpuGSI1vhp13w=;
	b=EbmrbIChY6UO6AuXTlMkf5vvip+v8Ri+RktTkbTjxQzvH55BA5lc05ePXR4lwTCiubuK0J
	pfhlBM9H/4MUWAkoHNedxu7gmaSu9eNKcgKPpgQKSdmOzGZFzbw1Odh2YQzpnnJM7KZm+9
	yv27Ha/tnv91PSOxoVD87zGOdX8UjEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790188748;
	b=JWXtgg6EBdv4+TpmmnFJJSpzkJleScnBT3glL8qbrgTEu43mBff+b2Zc1hiNs514k6vKAs
	knRhgbbSw4KRMkY+57SpuFn1Aa16XXaoSvndxjMLb13kr3ukpATlnCG87MvXVhjrN5bX3U
	BrMkklkBZoOYfA14FaDm45pOLHoQD4Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VV7U2RDY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iUaYymco;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=m0WtN9eO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Uf0dXioQ;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4988321BEB;
	Wed, 23 Sep 2026 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790188742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ii8zjXOvCjg0J/8vHyFLQds1UkGP0eIpuGSI1vhp13w=;
	b=VV7U2RDYE9fAwwu+wi5FGZL+QFvYtgIxVUy0+ci8xo2V5KPcU+rVbwevpnI51wMywOZowK
	BjDDLI5lKHPiUOUknD15tn2++SDh3TpCyO4scnWVFy30GB1NM2tvCVDQ/8uUGiDBYSOfYY
	4zZcXpoaYQCQzPeW8q5SyJZa04O3jt8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790188742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ii8zjXOvCjg0J/8vHyFLQds1UkGP0eIpuGSI1vhp13w=;
	b=iUaYymcoZLIrJmEFe6r4WODrZoTVe3fgUBcSqRg4yCweDi3oaFHUBweFJDI09+AXxR2uOq
	7j1lHD3L9azqPbBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790188738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ii8zjXOvCjg0J/8vHyFLQds1UkGP0eIpuGSI1vhp13w=;
	b=m0WtN9eO6qq03zUsVRJESmQifaCv53PIilcQSeItrlnilO9h0A+fEi8v9BuKjV9cqiPARy
	uhRvgCSceLTrsTxLNbzQy2BK4tKGas1BIbVHPAn8mLAik3IUdVI8key6Rt5Tlhbv7VrOVU
	0J1k8bd9Gu2Wz/Gx/fYDAQzUma6mO30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790188738;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ii8zjXOvCjg0J/8vHyFLQds1UkGP0eIpuGSI1vhp13w=;
	b=Uf0dXioQesj0Eoa9OYfB/swSAQKr1824vXldB0DBDuRdUH01fKxSrD9f6DL1CxOJpxQHkE
	HoSBbL9N5GUhxOAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20912134E8;
	Wed, 23 Sep 2026 18:38:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3snAN8ActGrwdQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 23 Sep 2026 18:38:57 +0000
Date: Wed, 23 Sep 2026 19:38:55 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, linux-mm@kvack.org, regressions@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm: avoid a reclaiming allocation in
 pud_free_pmd_page()
Message-ID: <arQbFrGiilXn7ABD@pedro-suse.lan>
References: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916062222.27347-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C80BC0008
X-Stat-Signature: op3wbghza5wknf7awuoia5gfnqq8p7tc
X-Rspam-User: 
X-HE-Tag: 1790188747-886909
X-HE-Meta: U2FsdGVkX1+0NI6Ryp3exgpvJFSOBnIZ1Ubdoi2OnMb3uwcGXFyTLPsHy/sntjyUNWrHojAnzweTTgT91mwjslwrCDLurMlZ/Y18kVn5TD2fSL2lxD7ykYuxgHV6mdT10EbQQ239JPnjOTx4GpSs4Op6qGEIBCh+/Pnimg6ViE0qyGhmjawbnBhMUyP8x6rAZP7/3y1B+o95kAYPzhLSnin9guL95WyuScLaQ74Kp1tPGxVVuIDf//gycO3z2mNbvOGakAahr+RkK0ThTDsjXtCjqRoPAoxrK9UY/1L2A0nKCJARC5eh9xdfQYVnsjZgX+Y44Y4v74Vosyi/5suGBCnjucA776m/WaR58gwPiYB4MipvhCIjg29CeTQLY/jMv1XFCfCYNkk/p+/WKQ4Eyd9c1RvVCAWXgrOUPQsa9ORJAC3cJOwg7BlHkX7O2YVs709tXCQI3arW3UF3LAjatuFWZ/kptnwRTxXskP+KRYJN16V2LNyPZuWOlP/1+GpiSpAXnrxkOIxNCGz8z0M3vdakMkK/Fb7Rda6ahNIH/tGelWH58EXjom/CKTpSlPhXpc3W0YNThjCeK79yKkIdxwM7IGLXihFbw3xwusISqYAb3VvFs33G5RqjPIY1H7JZT65OkT3j0K3K+8vqkJX+n77nGdKteMHhoQL1qqQeYoYurq/8GXciqWNmmJaIGIGtNZDOBNkSA/QgO8bMSRzpwnQuBOBu2WOwr8ZVqRUV2Pn0zM383rR525SrjWuXzKnuLzU+H3wB8+WaWuannSeZZsaVUQC49SKtkKBZfhShbZmHOvARCOsR2VvifscJslTzCFe0P2KGSybDg9Ud9+9n22r4nAOX1oXNRWjF0s9eM7XfcJCwpNJLv5DjG5siv4Sn8F8nGCXAOyd3m/2RH5QaiNoAPnrNkC65AJwaXHmx/ESXeynnswnYyxgSLcq9yXn3dpWZ2g9JISitfpmv0Kp
 1vmVkCg2
 ZWmAjnQoHa6l1BZa9j/9SBbzCPfZPuV/gsTy9bfM7TzBJhUoBznjMynvf/PtM2rDsxOPcoq58XbqWuPD19SzOWs+EduTB93nJM74u6p4UJaZrcTNz6wArU7NVWNRhONB6DE9GfgQ/H4SOjwlEwH8dUPQQGCihzivK1A5Q/FrEBT5rZGovVnQk9dn1DzIfpSEbEGo2dvM3+JZGTpeFqv9lXm0kbP542qctBwOslyztoJfUsi2qbOPWR9cmT06WcxB1/FWWakf6+e8ErK9GEvcNZwGRhKih8mk4q+dLa/0vg8vPVxPBzWo+jzEL7WBQKEo7kADUyMP2m3jmiY9eLxIKTawhN4U8OpRCwxMGHqaO+dKYE3JzftvNC2omniq4nogjRyqC6gsO95k8N+hEgxzdTJ/Fymwi1CJAo0lrBT2IvariaxbrPnWFs8p+3c9fgFamFn8t2080ZWNGciE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:22:22AM +0500, Mikhail Gavrilov wrote:
> On a box with a discrete GPU, lockdep reports a possible deadlock as soon
> as kswapd shrinks the TTM page pool:
> 
>   WARNING: possible circular locking dependency detected
>   7.3.0-rc3-f6e7b42bf05b+ #183 Tainted: G     U
>   ------------------------------------------------------
>   kswapd0/269 is trying to acquire lock:
>   ((init_mm).mmap_lock){++++}-{4:4}, at: change_page_attr_set_clr+0x29a/0x4a0
>   but task is already holding lock:
>   (pool_shrink_rwsem){.+.+}-{4:4}, at: ttm_pool_shrink+0xb2/0x330 [ttm]
>   Chain exists of:
>     (init_mm).mmap_lock --> fs_reclaim --> pool_shrink_rwsem
> 
> The cycle is built from three edges:
> 
>   1) pool_shrink_rwsem -> (init_mm).mmap_lock
> 
>      The TTM shrinker restores the caching attribute of every page it
>      frees, while holding pool_shrink_rwsem:
> 
>        ttm_pool_shrink()
>        -> ttm_pool_dispose_list()
>        -> ttm_pool_free_page()
>        -> set_pages_wb()
>        -> change_page_attr_set_clr()   [ init_mm mmap read lock ]
> 
>   2) fs_reclaim -> pool_shrink_rwsem
> 
>      The same shrinker, called from reclaim.
> 
>   3) (init_mm).mmap_lock -> fs_reclaim
> 
>      ioremap() installing a huge PUD mapping over an existing PMD table:
> 
>        ioremap_page_range()
>        -> vmap_range_noflush()
>        -> vmap_try_huge_pud()          [ init_mm mmap read lock ]
>        -> pud_free_pmd_page()
>        -> __get_free_page(GFP_KERNEL)  [ enters reclaim ]
> 
> Edge 3 is the one that should not exist.  Now that reclaim can acquire the
> init_mm mmap lock, that lock must not be held over an allocation which can
> enter reclaim.  This rule is stated by commit d5d8b8662e6e
> ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> and honoured inside CPA itself, where split_large_page() drops the lock
> around pagetable_alloc().  The vmap path took the same lock earlier, in
> commit 26444eb71465
> ("mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF"),
> and pud_free_pmd_page() still allocates its scratch page with GFP_KERNEL
> underneath it.  Neither commit deadlocks on its own; together they close
> the cycle.
> 
> Use GFP_NOWAIT for that page.  pud_free_pmd_page() already returns 0 when
> the allocation fails, and its only caller, vmap_try_huge_pud(), then maps
> at PMD granularity through the existing page table - exactly what it does
> when its own mmap trylock fails.  So the failure path is not new, and a
> failed allocation costs nothing but a smaller mapping.
> 
> This breaks the cycle at its source: no code holds the init_mm mmap lock
> across a reclaiming allocation any more, so no shrinker-held lock can be
> ordered against it.  The same cycle was reported from the i915 shrinker
> with &vm->mutex in place of pool_shrink_rwsem.
> 
> Link: https://lore.kernel.org/all/80993b70-352f-4069-84c7-39a04c061e98@intel.com/
> Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
> 
> #regzbot introduced: d5d8b8662e6e
> 
> Reproduced and verified on a Ryzen 9 7950X with a Radeon RX 7900 XTX
> (Navi 31, 0000:03:00.0), lockdep and KASAN enabled.
> 
> On a kernel with a TTM driver bound the report above reproduces on
> demand, no memory pressure needed:
> 
>   # cat /sys/kernel/debug/ttm/page_pool         # wc/uc rows non-zero
>   # cat /sys/kernel/debug/ttm/page_pool_shrink
> 
> The second read runs the TTM shrinker with fs_reclaim held, so the
> same cycle is reported from the reading task instead of kswapd.
> 
> Before (7.3-rc3-f6e7b42bf05b, #183): report within 105 s of boot,
> 2048 pool pages scanned.
> 
> After (same base plus this patch, #185): 1536 write-combined pages
> scanned - the order-9 row of the pool went from 3 to 0 and total
> node0 from 27650 to 26114 - no report, and /proc/lockdep_stats still
> showed debug_locks: 1 afterwards.
> 
>  arch/x86/mm/pgtable.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index cb03f5a2b243..c79587962526 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -713,7 +713,7 @@ int pmd_clear_huge(pmd_t *pmd)
>   * Context: The PUD range has been unmapped and TLB purged.
>   * Return: 1 if clearing the entry succeeded. 0 otherwise.
>   *
> - * NOTE: Callers must allow a single page allocation.
> + * NOTE: Callers must allow a single non-blocking page allocation.
>   */
>  int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>  {
> @@ -722,7 +722,13 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>  	int i;
>  
>  	pmd = pud_pgtable(*pud);
> -	pmd_sv = (pmd_t *)__get_free_page(GFP_KERNEL);
> +	/*
> +	 * The only caller, vmap_try_huge_pud(), holds the init_mm mmap read
> +	 * lock, which reclaim can take via set_memory_*().  Do not enter
> +	 * reclaim from here.  Failing is fine: the caller then keeps the
> +	 * existing PMD table instead of installing a huge PUD mapping.
> +	 */
> +	pmd_sv = (pmd_t *)__get_free_page(GFP_NOWAIT);
>  	if (!pmd_sv)
>  		return 0;

So, I'm really confuesd about this code. As in the original code. Copy-pasting
here:

        pmd_t *pmd, *pmd_sv;
        struct ptdesc *pt;
        int i;

        pmd = pud_pgtable(*pud);
        pmd_sv = (pmd_t *)__get_free_page(GFP_KERNEL);
        if (!pmd_sv)
                return 0;

We allocate a copy...

        for (i = 0; i < PTRS_PER_PMD; i++) {
                pmd_sv[i] = pmd[i];
                if (!pmd_none(pmd[i]))
                        pmd_clear(&pmd[i]);
        }

We, for some reason, save and clear the pmd.
        
        pud_clear(pud);

Then we clear the PUD entry...

        /* INVLPG to clear all paging-structure caches */
        flush_tlb_kernel_range(addr, addr + PAGE_SIZE-1);

Then we flush the TLB (and with it, translation caches).

        for (i = 0; i < PTRS_PER_PMD; i++) {
                if (!pmd_none(pmd_sv[i])) {
                        pt = page_ptdesc(pmd_page(pmd_sv[i]));
                        pagetable_dtor_free(pt);
                }
        }

        free_page((unsigned long)pmd_sv);

        pmd_free(&init_mm, pmd);

Then we free possible PTEs attached to the PMD (from our copy),
and free the PMD itself.


So, the question is: why the heck do we need a copy? PMD is still allocated
by the time we flush the TLB. Why doesn't a simple pud_clear() + flush_tlb +
free over the pmd Just Work? Am I missing something? The git log isn't
clueing me in.


All-in-all, I would much prefer not having a copy of the PMD at all. Perhaps,
if this isn't workable, then a linked list of PTEs would work. But I would rather
not have tricky logic at all.

-- 
Pedro

