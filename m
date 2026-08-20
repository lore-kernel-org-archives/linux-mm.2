Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61FA7C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814D86B009B; Thu, 20 Aug 2026 09:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED1F6B00A5; Thu, 20 Aug 2026 09:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7025B6B00A6; Thu, 20 Aug 2026 09:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B08E6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:20:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD457A1248
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:20:39 +0000 (UTC)
X-FDA: 85121707398.21.2CA54E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D7D4840010
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:20:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjfXghPu;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787232038;
	b=d3FR6VLbGBPiqvC6XF65pVzId6zY9cPzAcHIIWfB8f9ledtzWneI9duADthbBDxsKXztVo
	lojzEI/rDpaoQLGsZo4w8XkwJsVrCUALGkF084SAaX7T94wN5TbD7MnFSWTOctzjq9hlJP
	cWA2vsNnuPPthgXDkWUE297TFAYsBZE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fjfXghPu;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787232038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXgjaUyH4SAbaEvw8EOTdGJq1korcmZz///mec1zjC4=;
	b=y6PCXcGtskeE3ieg7zMV4Sdw3R3w2ER8fr9mwr6ttHdoyNyAinz7i0sXx9sdqiDMhVcuBE
	lCoGr0bt9IhQcKNSPwPNJQw1hvvrlxsq1VIQv38/HIppmUEWtLLIHOkz2uzcPS/5iW17C3
	MdPEhZs76xViX4K7jItj3YhG0jPI0Ew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9741841709;
	Thu, 20 Aug 2026 13:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19531F000E9;
	Thu, 20 Aug 2026 13:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787232036;
	bh=oXgjaUyH4SAbaEvw8EOTdGJq1korcmZz///mec1zjC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fjfXghPuYDKZnUQKG5ZGMZxyHIl/hnRq50QedVuOxz3ZHDwAMdWQuD+1SSTJCDUU/
	 OaT9VF2BonB9zBjLwTi1HBtUsDo0D5skAsxhdm0PYquIZej7RJwIVf6NJxW71RVzkG
	 XWXjkxFQKRNk8bZSQ3TB5+WCdtucaVqNsp41OGADwrhRnVh0/izloGhSzeGGf2Yy//
	 gZ0yKC3uAkwiQM4aq1UzC8GmZlzceuJIYhVNTq+HUqnJnvIRwxbForYJST4zX4aNUw
	 NwMJq/+Hcfk5QiS7nQ12Oy8CKwv17iDKNn+UaKV1xWr9UQ/9cYvjYk/ZUb7tVJIAe+
	 c/hNS/hBnsmpQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 34FB41980052;
	Thu, 20 Aug 2026 09:20:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 20 Aug 2026 09:20:33 -0400
X-ME-Sender: <xms:HP-GamH-e7Cb4Jyoe_-0-0tLiI15uqU79aUbC5QGCRyL6fTLiDvnLw>
    <xme:HP-Gas_eYVeqCSvtuDI_X_ZaZGP3Qq6ziJ8HV4h1kwzF_IOJ1ejDkBJG_DJDokXXk
    _KpqFnKIWjOfNInSyuu6_8iiivZVmhMBT1XBS1EAOtLOu4zdOo2mEnL>
X-ME-Received: <xmr:HP-GaoONhUGac0vYqYgXMUmi2cIe83O-u2pxCut2Xw8TQPjZtSuQIl9M3kM>
X-ME-Proxy-Cause: dmFkZTFVEhnD9IyDtNMpCvBGobiWZhpIfRKx95I8pl2hWqFiJH48fkv3PyG9zsMLxu0z0V
    yGDa+3wmVts4jxxlef7KWiyHAduKCqnYfrPxlEGXPFCTtMaRv8m2HSBHdmc6D91J3Ag3Tq
    hA5UCO3PMOcZzPXxobJKX5QghQO1CEZKMBh+R7ZCxB6rsvqr/ZmLBCLTYBHH52mUxFI6LP
    MBj9Z+PzvNT2bjthYDqUwFBQq96qv77xu6Or1xnIVJNigDXcpzhhJDEnzP97QjsvSRAyE/
    GtIM5/BHAbWdoN8hbHKMtw2JK5fyYHtxprqks4cUPgZ3QBezfGquBZcT+hdLDxIurzEpii
    u2LjOBaPrTSnj7pFlgzqS9DmHsteBV7ua1FKFro7RjAEBVaosu7sAclj4LEVhvvuPVPtrz
    9nU4vaPK+VHOkazRiV5yeZl+xCavWTO6mZawH7m9rV/jTD+Ce9scgKn/B4wrnFdyCEgOHL
    RDVGYVZyKp5gvPTLvi9TOpq/Th91qlOB+QUWfvpES8voJ1WvkQFRnFMLZNhIAhnFJOe0Ti
    t4wAuhBuGZoLWEmOt95JvaxwX3npGV7fjWdFV2aV9aibZ2WHRZY/o8TrD2lPxgETHmNwpE
    mQQJssMCMTfH8oRaz2/4cehQllLbPqQjerfn5YfeUs9rIOt5gwBH0TR7GSVA
X-ME-Proxy: <xmx:HP-GaozNFED3Viok70M6rP-FARhT1r3Kmjl3fLA-qlwsEi6D-F1uFw>
    <xmx:HP-GaqtJWrKbY01m0fdbOlnNzLAIhZx83YiZdTfS8mMB1AR6Lj6AXA>
    <xmx:HP-GatGK-l5_6KJOe402av9tpcwGBnIEEEFyoSaUOZgocCNWZMfWfg>
    <xmx:HP-GarWmhxd4mohRMi_Rh9cffaAlYmAQYCGzSZ53EcX9QdCiSL8_qg>
    <xmx:HP-Gao2sQUADnV8PpV2PFsfO7YaYkiwbcdyJeitWMX7pJYwN94MNq8_D>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 09:20:27 -0400 (EDT)
Date: Thu, 20 Aug 2026 14:20:26 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lance Yang <lance.yang@linux.dev>, usama.arif@linux.dev, 
	hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aob9PF_H6CCJMdkk@thinkstation>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aobp2CtWZBlw4w7E@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7D4840010
X-Stat-Signature: ew1we4onwodg7ghnwpnhstixwaiuf8bo
X-HE-Tag: 1787232037-466786
X-HE-Meta: U2FsdGVkX1/+557+feG05MgE8hcP2u0PeaZCfDaVcV+RgKolSWe0O8Obaca6dqkiRFyt7HoWU551Ui12MA/cG9WxfIYzRNLGryuyvWsPEgOKZCLqdlYNOUaSEAl9Atsd/7ixT7FQhrgPVjIOw+y2miDv+Z2qjlQOJo6U/uRlXyVKEM1zrn4Iu5ctT9XGV3ZqR3ZIMZD4t1tJccbXch2XBcFokcJQo/wH6A7a6E1PMOLI4krDcCVaZ5Oa4zxwYOeL7CLvvYB5eKU2gSzZvTQyWFk6n8q4iYSyZ+g8uNQ5ieg6Z7m/ES1orbu1Iw1ISFR2sTW3U8OQDXf/efMYaI3OT6GR4es9vwPuXJfBjERD7/tRUjH1f9y1CxlbscMYF+nJIwnbrWWKe7wtIDDfyBMythYIm79SA+d8P7fdUpg7YCjJ4+Mzp3HDdvPuMPwVqkH5cwjuvqNti7CW/qbS/Ejt+nto0Sgx+wgE2816n8L+NQ5jZgQbSrQvZEI0l216koIqFsysRGuG3cXqZUJeJsTsKF5Wds2ejtx6EIJOYmE7KxFdJaez0SqRWn6CGdHcf7s05EeKp6gLhhd/SSIHwK4h37HJBRqUnBlS/iKP8IbdWcoqEqwstFghif+F2I+hiahQsDWc/gy/M4PXTZI7E1cwYEYy3ClvhswO/2l3K9g0jvbfxXYkJOxTL8TXb8Bt+C/QTbpFGYHfD0tbVVsUcPpP28ct/LZSVweLrvw03hyk/ZtI0PkYiCs1JKz581oi412xK5ASVinwEEtXE5sjPNcnsV3xa68JBFZFEP3QS0G+VgG5ZmsmJYruvOChFdKVC8Q/EJMd2TXDa/ThvT+97iTvS9NinP6k0zkwuppAeSZKqYxsZY5CxxlvvF7kiPWTjo5dz81eT3Gy/SyHqmIbHXv6Y49fdzFm2qdA7+3ctPaYTjslVvTFWIOLUBtT8XUqRdRIEXTD6YuPIeAT2hEz8q2
 m1/Xx42J
 PExsp7m1rE8flhn71LpYbEjQADF/LPP0authfayyEwdEN6SajziG9Oco1HxIyrieSiTJfOqjWt1uonrUG4xu46vx1+D/TaoSfj84Uy8vfz1OF0MxotI6mzfYCwNPWYZL8Yk+8TRVkRg60Kdk6Fib3Y8cK5wdu8C+cuGjovu0KOtlpsirHZOQOMxpFTEmhAjB+7mYWiUeizXKOkEyrFnCWamyoIT/qOgaEKhmy0PzUhyAFKySM2XaF00bCrQi/REE7JfY2cg/AohaRxbKh2WVcrVX8IgN1tqUZTGwEdRpcnhMgP2J4dgJ03oKYKD9p2+falciJICNrzFSRLfa+mlRTM4x1XoDycIRPEOiJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 01:12:18PM +0100, Pedro Falcato wrote:
> +CC willy
> 
> On Thu, Aug 20, 2026 at 02:13:37PM +0800, Lance Yang wrote:
> > 
> > On Wed, Aug 19, 2026 at 05:35:41PM +0100, Pedro Falcato wrote:
> > >On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
> > >> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> > >> > zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> > >> > file case, but not the dirty bit.  The pte path does propagate it, in
> > >> > zap_present_folio_ptes() and so does the pmd split path, in
> > >> > __split_huge_pmd_locked().
> > >> > 
> > >> > For most file mappings the omission is harmless, because writing to a
> > >> > shared file mapping goes through page_mkwrite(), which dirties the
> > >> > folio.  tmpfs is different: it has no page_mkwrite(), and
> > >> > vma_wants_writenotify() is false for it, so a *read* fault on a
> > >> > MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> > >> > do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> > >> > stores through that mapping set only the hardware dirty bit in the pmd
> > >> > and never call folio_mark_dirty().
> > >> >
> > >> > A shmem folio allocated by a fault
> > >> > is marked uptodate but not dirty (see the clear: block in
> > >> > shmem_get_folio_gfp()), so PG_dirty is never set at all.
> > >> > 
> > >> > Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> > >> > - then loses the only record that it was written, because zap_huge_pmd()
> > >> > drops the pmd without transferring the dirty bit.  Reclaim afterwards
> > >> > sees a clean shmem folio: the whole swap-out block in
> > >> > shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> > >> > pageout() is skipped and the folio falls into __remove_mapping().
> > >> > There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> > >> > entry is created and __filemap_remove_folio(folio, NULL) simply empties
> > >> > the i_pages slot.  The data is freed without ever being written to swap,
> > >> > and the next fault on that index returns a freshly zeroed folio.
> > >> > 
> > >> > This is silent data loss for any process that keeps state in a
> > >> > MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> > >> > from one process generation to the next through /dev/shm.  It requires
> > >> > the folio to be PMD-mapped, so it only shows up once shmem THP is
> > >> > enabled (which is what we did in Meta fleet and started noticing crashes);
> > >> > with THP off the pte path transfers the dirty bit correctly.
> > >> > It also only becomes visible when swap is enabled, because with no swap
> > >> > device shmem folios (which are on the anon LRU) are not scanned by
> > >> > reclaim at all, so the clean folio is never dropped.
> > >> > 
> > >> > Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> > >> > 2MB-backed region, write a known pattern through the resulting mapping,
> > >> > munmap, force reclaim of the cgroup, then re-map and read back.  Without
> > >> > this patch the region reads back as zeros and vmstat shows zswpout 0 -
> > >> > the data was discarded rather than swapped.  With this patch the region
> > >> > reads back correctly and the pages are swapped out as expected.  With
> > >> > huge=never, or when the first touch is a write, the test passes either
> > >> > way.
> > >> 
> > >> +Hugh.
> > >> 
> > >> Oopsie.
> > >> 
> > >> I'm confused why it took a decade to discover the bug...
> > >> Maybe read ahead of write for shmem is too rare, I donno.
> > >> 
> > >> > 
> > >> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> > >> 
> > >> This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
> > >> 
> > >> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> > >> 
> > >> > Cc: <stable@vger.kernel.org>
> > >> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > >> > ---
> > >> >  mm/huge_memory.c | 2 ++
> > >> >  1 file changed, 2 insertions(+)
> > >> > 
> > >> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > >> > index ced400f72d43a..afbb5974bd225 100644
> > >> > --- a/mm/huge_memory.c
> > >> > +++ b/mm/huge_memory.c
> > >> > @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> > >> >  		add_mm_counter(mm, mm_counter_file(folio),
> > >> >  			       -HPAGE_PMD_NR);
> > >> >  
> > >> > +		if (is_present && pmd_dirty(pmdval))
> > >> > +			folio_mark_dirty(folio);
> > >> 
> > >> Unrelated to your patch, but noticed while looking at it: we drop the rmap
> > >> here under the pmd lock, while the TLB flush is deferred to
> > >> tlb_finish_mmu(). The pte path handles this with
> > >> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
> > >> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
> > >> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
> > >> 
> > >> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
> > >> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
> > >> folio_mkclean() can clean the folio while another CPU still stores through a
> > >> stale TLB entry -- silently lost write, no PG_dirty left behind.
> > >
> > >Where do you see page_mkwrite being called in the same path as do_set_pmd()?
> > >Per my understanding of the code, this Should Not Happen, and it really Should
> > >Not Happen for many, many reasons (write amplification being the main one).
> > 
> > Hmm.. that happens on an initial shared write fault. For non-DAX XFS, the
> > path starts with an empty PMD.
> > 
> > TL;DR
> > 
> > With an empty PMD and PMD-order THP allowed, __handle_mm_fault() first
> > tries create_huge_pmd(). VM_FAULT_FALLBACK sends the fault to
> > handle_pte_fault():
> > 
> > static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
> > 		unsigned long address, unsigned int flags)
> > {
> > 	...
> > 	if (pmd_none(*vmf.pmd) &&
> > 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
> > 		ret = create_huge_pmd(&vmf);
> > 		if (ret & VM_FAULT_FALLBACK)
> > 			goto fallback;
> > 		else
> > 			return ret;
> > 	}
> > 	...
> > fallback:
> > 	return handle_pte_fault(&vmf);
> > }
> > 
> > create_huge_pmd() dispatches to the filesystem's huge_fault callback:
> > 
> > static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	...
> > 	if (vma->vm_ops->huge_fault)
> > 		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
> > 	return VM_FAULT_FALLBACK;
> > }
> > 
> > For non-DAX XFS, that callback returns VM_FAULT_FALLBACK:
> > 
> > static vm_fault_t
> > xfs_filemap_huge_fault(
> > 	struct vm_fault		*vmf,
> > 	unsigned int		order)
> > {
> > 	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> > 		return VM_FAULT_FALLBACK;
> > 	...
> > }
> > 
> > XFS installs the huge-fault, regular-fault, and page_mkwrite callbacks
> > in the same vm_ops:
> > 
> > static const struct vm_operations_struct xfs_file_vm_ops = {
> > 	.fault		= xfs_filemap_fault,
> > 	.huge_fault	= xfs_filemap_huge_fault,
> > 	...
> > 	.page_mkwrite	= xfs_filemap_page_mkwrite,
> > 	...
> > };
> > 
> > On the fallback path, handle_pte_fault() leaves an empty PMD without a
> > PTE and calls do_pte_missing():
> > 
> > static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> > {
> > 	...
> > 	if (unlikely(pmd_none(*vmf->pmd))) {
> > 		/*
> > 		 * Leave __pte_alloc() until later: because vm_ops->fault may
> > 		 * want to allocate huge page, and if we expose page table
> > 		 * for an instant, it will be difficult to retract from
> > 		 * concurrent faults and from rmap lookups.
> > 		 */
> > 		vmf->pte = NULL;
> > 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
> > 	...
> > 	}
> > 
> > 	if (!vmf->pte)
> > 		return do_pte_missing(vmf);
> > 	...
> > }
> > 
> > For a file VMA, do_pte_missing() calls do_fault():
> > 
> > static vm_fault_t do_pte_missing(struct vm_fault *vmf)
> > {
> > 	if (vma_is_anonymous(vmf->vma))
> > 		return do_anonymous_page(vmf);
> > 	else
> > 		return do_fault(vmf);
> > }
> > 
> > do_fault() sends FAULT_FLAG_WRITE + VM_SHARED to do_shared_fault():
> > 
> > static vm_fault_t do_fault(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	...
> > 	if (!vma->vm_ops->fault) {
> > 		...
> > 	} else if (!(vmf->flags & FAULT_FLAG_WRITE))
> > 		ret = do_read_fault(vmf);
> > 	else if (!(vma->vm_flags & VM_SHARED))
> > 		ret = do_cow_fault(vmf);
> > 	else
> > 		ret = do_shared_fault(vmf);
> > 	...
> > }
> > 
> > do_shared_fault() first calls __do_fault():
> > 
> > static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	vm_fault_t ret, tmp;
> > 	struct folio *folio;
> > 	...
> > 	ret = __do_fault(vmf);
> > 	...
> > }
> > 
> > __do_fault() invokes the regular fault callback:
> > 
> > static vm_fault_t __do_fault(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	struct folio *folio;
> > 	vm_fault_t ret;
> > 	...
> > 	ret = vma->vm_ops->fault(vmf);
> > 	...
> > 	return ret;
> > }
> > 
> > For non-DAX XFS, xfs_filemap_fault() reaches filemap_fault():
> > 
> > static vm_fault_t
> > xfs_filemap_fault(
> > 	struct vm_fault		*vmf)
> > {
> > 	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > 	...
> > 	return filemap_fault(vmf);
> > }
> > 
> > Once that returns the folio, do_shared_fault() calls do_page_mkwrite()
> > and then finish_fault():
> > 
> > static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	vm_fault_t ret, tmp;
> > 	struct folio *folio;
> > 	...
> > 	folio = page_folio(vmf->page);
> > 	...
> > 	if (vma->vm_ops->page_mkwrite) {
> > 		folio_unlock(folio);
> > 		tmp = do_page_mkwrite(vmf, folio);
> > 		...
> > 	}
> > 
> > 	ret |= finish_fault(vmf);
> > 	...
> > }
> > 
> > do_page_mkwrite() calls the XFS callback installed above and restores
> > the original fault flags:
> > 
> > static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
> > {
> > 	vm_fault_t ret;
> > 	unsigned int old_flags = vmf->flags;
> > 
> > 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> > 	...
> > 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
> > 	/* Restore original flags so that caller is not surprised */
> > 	vmf->flags = old_flags;
> > 	...
> > }
> > 
> > So finish_fault() still sees FAULT_FLAG_WRITE. With an empty PMD, no
> > fallback requirement, and a PMD-mappable folio, it tries do_set_pmd():
> > 
> > vm_fault_t finish_fault(struct vm_fault *vmf)
> > {
> > 	...
> > 	if (pmd_none(*vmf->pmd)) {
> > 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> > 			ret = do_set_pmd(vmf, folio, page);
> > 			if (ret != VM_FAULT_FALLBACK)
> > 				return ret;
> > 		}
> > 		...
> > 	}
> > 	...
> > }
> > 
> > After its checks pass, do_set_pmd() takes FAULT_FLAG_WRITE from vmf and
> > installs a dirty+writable PMD:
> > 
> > vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
> > {
> > 	struct vm_area_struct *vma = vmf->vma;
> > 	bool write = vmf->flags & FAULT_FLAG_WRITE;
> > 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
> > 	pmd_t entry;
> > 	...
> > 	entry = folio_mk_pmd(folio, vma->vm_page_prot);
> > 	if (write)
> > 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> > 	...
> > 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
> > 	...
> > }
> > 
> > maybe_pmd_mkwrite() sets write permission for VM_WRITE:
> > 
> > pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
> > {
> > 	if (likely(vma->vm_flags & VM_WRITE))
> > 		pmd = pmd_mkwrite(pmd, vma);
> > 	return pmd;
> > }
> 
> Thanks, this makes sense!
> 
> > 
> > >Namely, see the comment in wp_huge_pmd():
> > >	/* COW or write-notify handled on pte level: split pmd. */
> > >
> > >if file huge pages get mapped writable, that's a bug.
> > 
> > That comment is about a different path. __handle_mm_fault() calls
> > wp_huge_pmd() only when a write/unshare fault hits an existing PMD THP
> > which is not writable:
> 
> No. That is simply a bug. There's little reason you wouldn't try do un-WP
> a huge PMD if the idea would be to do PMD granularity for write notifications.
> It isn't, naturally, because that results in horrible write amplification.

Write notification is already folio-granular. Installing PTE instead of
PMD changes nothing.

> The fix IMO is to make it so write faults on shared mappings with page_mkwrite
> never create a PMD.

Why? Write batching from large folios is a win.

> I don't think it makes sense to add rmap flushing hacks
> for PMDs, when the common case (read + write) instantly and purposefully
> breaks down to the PTE level (such that you really aren't supposed to get
> the above; you'll notice that as soon as the folio gets cleaned, it will
> get broken by the next write fault, period).

If you consider delayed rmap a hack (I don't), it has to fixed on PTE
level too.

> See the attached patch. I know willy has been working on related stuff, so
> perhaps he might want to pick it up.

As I said the patch doesn't do what you expect it to do. PG_dirty is on
folio and we writeback folios, not PTEs.

Also, needs_fallback is not just "no PMD": finish_fault() then forces
nr_pages = 1, so it is 512 faults and 512 ->page_mkwrite calls per 2M folio
instead of one.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

