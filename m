Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314DEC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 12:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DCB6B0095; Thu, 20 Aug 2026 08:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E5F6B009B; Thu, 20 Aug 2026 08:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CDA6B009D; Thu, 20 Aug 2026 08:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB0B6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:12:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 638C24013B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:12:33 +0000 (UTC)
X-FDA: 85121535786.22.06F7D22
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3248810000D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:12:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wR1J2NXn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jlJ51zsd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z1ZkbN9I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eDIJUVK0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787227951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFwdVqKwmHD/ih3Nqk9KcAgQVCsZzihKUnNM5VjKHG0=;
	b=IzOTOPOm7ZmYOzwl4Rqtr4ra/xMMdD6KIFnSdklPnDzVaV5VwDE+kHsL2joiKNes9jMQkc
	f4YDvoBR5HlZ2teCeyzMGdnSFIw97XSG3U3wg5sLZ/5ky/yoDGYJzdYZcQlPIusz6u9TcW
	T2PShdLlDgVR1eKR1HIsLSkdTx58FkA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wR1J2NXn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jlJ51zsd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z1ZkbN9I;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eDIJUVK0;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787227951;
	b=ghGnpUQD9zp6yrN6dDC1Y0QfLsU5I3QKcK+iFAbfwMpIP1S1rtSbZnvJkHTtjx9cNtFAed
	zu+h5t9xXVHCGEefB5WqRgnD376KGAnQizpQ/KWV/gZVA1TjRyQtz508xpRCwvfCx/tU6F
	CFlPyd5szmOg5XT4dDt9rpMDjvSNVX0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83489834CE;
	Thu, 20 Aug 2026 12:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787227945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFwdVqKwmHD/ih3Nqk9KcAgQVCsZzihKUnNM5VjKHG0=;
	b=wR1J2NXnC5JfzfOs++vPcl9nAHIldJq+3heozi4oTth+7f7NnU+pEO3X8JFUF30+i8lkfn
	K5m0urc5yoetmEUQWrnQeuqDBN3GcZL2ZV4HvS2dQs12IJXOlsWJ6gAGJaVPcPh10dicus
	DFugyz1OCt3FNOhsJ3l9ErBDQu880z8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787227945;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFwdVqKwmHD/ih3Nqk9KcAgQVCsZzihKUnNM5VjKHG0=;
	b=jlJ51zsdGloBRoa40TyoQTOrnjl4PbXn4nhaatVd7rM09rooPI9T7VB3bbMRbA8xu3FmTd
	i92NDYZHNvNZ0lCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787227941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFwdVqKwmHD/ih3Nqk9KcAgQVCsZzihKUnNM5VjKHG0=;
	b=z1ZkbN9I/uzN6onF/IEV0Rl2EMS7YPj2H3Z4G+F8Svd/ItaU2dDmYMjbTO9risYKeoLSmk
	QFU4jK2laqdnS1zjF5SKhN870Hv2SLMkaGGOm7foE5sfjRk+UMaWPCGR2q8Xljjwg1WOPQ
	06Yt3e1/3+wdpz4DlfGiqeWEpsVuvjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787227941;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFwdVqKwmHD/ih3Nqk9KcAgQVCsZzihKUnNM5VjKHG0=;
	b=eDIJUVK0Bh3izMrCkAXlmb4evW2tr2nkNroxNaY2P80aNutrarU2eRx1CIdWUG4eaPrQcZ
	jwFdRaarPWXEtnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 172A427A8;
	Thu, 20 Aug 2026 12:12:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JqUZAiTvhmqpZAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 20 Aug 2026 12:12:20 +0000
Date: Thu, 20 Aug 2026 13:12:18 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: kas@kernel.org, usama.arif@linux.dev, hughd@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aobp2CtWZBlw4w7E@pedro-suse.lan>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xqewysoglul6w752"
Content-Disposition: inline
In-Reply-To: <20260820061337.24669-1-lance.yang@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 3248810000D
X-Rspamd-Server: rspam07
X-Stat-Signature: tnzu8qryrui5me4mhejx75iap8cgiw85
X-HE-Tag: 1787227951-883240
X-HE-Meta: U2FsdGVkX18hxl3I8fa0BJYJ1DMXMC6HXsue7jjVxwbj97HV1lFckP6PKhkwzmLNf4feslCB18bnKyNev9Y38UoleTIxlMmi5eIX7dQkgInX69UkZCbUwIjKFCyQHgEmJYdAHLdDR/rVwjiXXFWdW4s+n0MpH2Jo5+2fAwMkLVVUE+AfKcpiQ7fw3kj2Keg3YjhQC72kTWsV3kJogag05k13+w1qIp49bmac/n5wL22YGcbync67cgRklmJI7UUVno8FNHTrObwOEwqveTtFXz5fhRyyfez4EyAWEu7pwCOleDb9KLVoXuEiBFZw7G2QXFAStfU6mQOofCQ7TbsEseSViNVfR6PTeOrXrQNFrrBFlQUd1T07VWuw5J/nR5K7GVOrRiNxsjDkafP0jEVVJmSohe1ZJmRN5w/0zhuUk5MwZMmZyuJ1eIEa5mIP0B0Zhnnv4nUoSHBHcAHvYKfaj7lgGGic4Qg6/cCgu5uu3IyX4qBpyiZHRPy9jkGHdQ7E4PrZKElfnLcl5mULORR/u0DsGUZcg+kyCEsYsPmpADygFoUvWL0C5qI3Pf4PCCwyMGjXIln/A2FN5a7gxYfnV9QdBWSTwOdZUX+MLhewNq6dJTHITVFSQzl29KExR3iE8SDbsstA0hP026ZfIJK9RHnXMSxnSMI+BsY/HdNNykIVPTkBibRlfUK5IZHsMdeAAPJCeYnIudSthK3tpwkEXhNx1ojI7+B8EZPX3Z1hPycuXpntiIqBfHvp/lf+mI0MeI/xohUhhYwoQsM9RAiqYKuymDysL+nTSd+h+n/l0kDpYHHa0RW+pc7XXbOmE7KOsQJioMcOYyXtMIYT+An+n9Wx0fpQYQWWsa7y7wBKa6mzuhd5bCkv8bh69AK0VAq5UdDLKJU6EXIvEybWIriLXRrvmKxgr7pxtmGfkFyfC27pSBr6GaR0cahWVH+wAFdmiF6J26RPBhBjS3MuwHM
 cwb/0MUS
 h0D8gsDLWA5R4lAL+QN63rNuhSYCUG6G733E1vwQBNffnfVj5UgpeA9cZ39KxV+p5SPVAQ7NJjGAzsusFTYsQV3puHdy+SRnAUb0kzyo2VpmTTXPVCzD/kxCt07lW+uhJ776JNtZPtRb4b9CI28mFmyjtiQ8r7otiP5Aq6cV1utD/9tRmMJ+lWl2Vfll+TtbfCo8OYXrBavOrj9YG/m5OXebDtBjDX7xfuBg11A1gIqxLgpvHvupfKH+hZ9INpLJjQ8mkuQuuvah3mWQg+xNofheueFjMmd4fSWI0gPc35QSL0OxQHRO8k6QUR588mMmc6dkpQWeeDEchsee8qOz2A/1sWI0zhkuJLPwLdUXMczPQKqCj6hOQzAF+7LRuLHqON66WEWkp9Lcn7Z7wRuA+CGyhhw8X9E1TjUsCHFFktLwv7+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xqewysoglul6w752
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+CC willy

On Thu, Aug 20, 2026 at 02:13:37PM +0800, Lance Yang wrote:
> 
> On Wed, Aug 19, 2026 at 05:35:41PM +0100, Pedro Falcato wrote:
> >On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
> >> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> >> > zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> >> > file case, but not the dirty bit.  The pte path does propagate it, in
> >> > zap_present_folio_ptes() and so does the pmd split path, in
> >> > __split_huge_pmd_locked().
> >> > 
> >> > For most file mappings the omission is harmless, because writing to a
> >> > shared file mapping goes through page_mkwrite(), which dirties the
> >> > folio.  tmpfs is different: it has no page_mkwrite(), and
> >> > vma_wants_writenotify() is false for it, so a *read* fault on a
> >> > MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> >> > do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> >> > stores through that mapping set only the hardware dirty bit in the pmd
> >> > and never call folio_mark_dirty().
> >> >
> >> > A shmem folio allocated by a fault
> >> > is marked uptodate but not dirty (see the clear: block in
> >> > shmem_get_folio_gfp()), so PG_dirty is never set at all.
> >> > 
> >> > Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> >> > - then loses the only record that it was written, because zap_huge_pmd()
> >> > drops the pmd without transferring the dirty bit.  Reclaim afterwards
> >> > sees a clean shmem folio: the whole swap-out block in
> >> > shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> >> > pageout() is skipped and the folio falls into __remove_mapping().
> >> > There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> >> > entry is created and __filemap_remove_folio(folio, NULL) simply empties
> >> > the i_pages slot.  The data is freed without ever being written to swap,
> >> > and the next fault on that index returns a freshly zeroed folio.
> >> > 
> >> > This is silent data loss for any process that keeps state in a
> >> > MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> >> > from one process generation to the next through /dev/shm.  It requires
> >> > the folio to be PMD-mapped, so it only shows up once shmem THP is
> >> > enabled (which is what we did in Meta fleet and started noticing crashes);
> >> > with THP off the pte path transfers the dirty bit correctly.
> >> > It also only becomes visible when swap is enabled, because with no swap
> >> > device shmem folios (which are on the anon LRU) are not scanned by
> >> > reclaim at all, so the clean folio is never dropped.
> >> > 
> >> > Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> >> > 2MB-backed region, write a known pattern through the resulting mapping,
> >> > munmap, force reclaim of the cgroup, then re-map and read back.  Without
> >> > this patch the region reads back as zeros and vmstat shows zswpout 0 -
> >> > the data was discarded rather than swapped.  With this patch the region
> >> > reads back correctly and the pages are swapped out as expected.  With
> >> > huge=never, or when the first touch is a write, the test passes either
> >> > way.
> >> 
> >> +Hugh.
> >> 
> >> Oopsie.
> >> 
> >> I'm confused why it took a decade to discover the bug...
> >> Maybe read ahead of write for shmem is too rare, I donno.
> >> 
> >> > 
> >> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> >> 
> >> This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
> >> 
> >> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> >> 
> >> > Cc: <stable@vger.kernel.org>
> >> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >> > ---
> >> >  mm/huge_memory.c | 2 ++
> >> >  1 file changed, 2 insertions(+)
> >> > 
> >> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> > index ced400f72d43a..afbb5974bd225 100644
> >> > --- a/mm/huge_memory.c
> >> > +++ b/mm/huge_memory.c
> >> > @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> >> >  		add_mm_counter(mm, mm_counter_file(folio),
> >> >  			       -HPAGE_PMD_NR);
> >> >  
> >> > +		if (is_present && pmd_dirty(pmdval))
> >> > +			folio_mark_dirty(folio);
> >> 
> >> Unrelated to your patch, but noticed while looking at it: we drop the rmap
> >> here under the pmd lock, while the TLB flush is deferred to
> >> tlb_finish_mmu(). The pte path handles this with
> >> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
> >> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
> >> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
> >> 
> >> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
> >> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
> >> folio_mkclean() can clean the folio while another CPU still stores through a
> >> stale TLB entry -- silently lost write, no PG_dirty left behind.
> >
> >Where do you see page_mkwrite being called in the same path as do_set_pmd()?
> >Per my understanding of the code, this Should Not Happen, and it really Should
> >Not Happen for many, many reasons (write amplification being the main one).
> 
> Hmm.. that happens on an initial shared write fault. For non-DAX XFS, the
> path starts with an empty PMD.
> 
> TL;DR
> 
> With an empty PMD and PMD-order THP allowed, __handle_mm_fault() first
> tries create_huge_pmd(). VM_FAULT_FALLBACK sends the fault to
> handle_pte_fault():
> 
> static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
> 		unsigned long address, unsigned int flags)
> {
> 	...
> 	if (pmd_none(*vmf.pmd) &&
> 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
> 		ret = create_huge_pmd(&vmf);
> 		if (ret & VM_FAULT_FALLBACK)
> 			goto fallback;
> 		else
> 			return ret;
> 	}
> 	...
> fallback:
> 	return handle_pte_fault(&vmf);
> }
> 
> create_huge_pmd() dispatches to the filesystem's huge_fault callback:
> 
> static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	...
> 	if (vma->vm_ops->huge_fault)
> 		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
> 	return VM_FAULT_FALLBACK;
> }
> 
> For non-DAX XFS, that callback returns VM_FAULT_FALLBACK:
> 
> static vm_fault_t
> xfs_filemap_huge_fault(
> 	struct vm_fault		*vmf,
> 	unsigned int		order)
> {
> 	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> 		return VM_FAULT_FALLBACK;
> 	...
> }
> 
> XFS installs the huge-fault, regular-fault, and page_mkwrite callbacks
> in the same vm_ops:
> 
> static const struct vm_operations_struct xfs_file_vm_ops = {
> 	.fault		= xfs_filemap_fault,
> 	.huge_fault	= xfs_filemap_huge_fault,
> 	...
> 	.page_mkwrite	= xfs_filemap_page_mkwrite,
> 	...
> };
> 
> On the fallback path, handle_pte_fault() leaves an empty PMD without a
> PTE and calls do_pte_missing():
> 
> static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> {
> 	...
> 	if (unlikely(pmd_none(*vmf->pmd))) {
> 		/*
> 		 * Leave __pte_alloc() until later: because vm_ops->fault may
> 		 * want to allocate huge page, and if we expose page table
> 		 * for an instant, it will be difficult to retract from
> 		 * concurrent faults and from rmap lookups.
> 		 */
> 		vmf->pte = NULL;
> 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
> 	...
> 	}
> 
> 	if (!vmf->pte)
> 		return do_pte_missing(vmf);
> 	...
> }
> 
> For a file VMA, do_pte_missing() calls do_fault():
> 
> static vm_fault_t do_pte_missing(struct vm_fault *vmf)
> {
> 	if (vma_is_anonymous(vmf->vma))
> 		return do_anonymous_page(vmf);
> 	else
> 		return do_fault(vmf);
> }
> 
> do_fault() sends FAULT_FLAG_WRITE + VM_SHARED to do_shared_fault():
> 
> static vm_fault_t do_fault(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	...
> 	if (!vma->vm_ops->fault) {
> 		...
> 	} else if (!(vmf->flags & FAULT_FLAG_WRITE))
> 		ret = do_read_fault(vmf);
> 	else if (!(vma->vm_flags & VM_SHARED))
> 		ret = do_cow_fault(vmf);
> 	else
> 		ret = do_shared_fault(vmf);
> 	...
> }
> 
> do_shared_fault() first calls __do_fault():
> 
> static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	vm_fault_t ret, tmp;
> 	struct folio *folio;
> 	...
> 	ret = __do_fault(vmf);
> 	...
> }
> 
> __do_fault() invokes the regular fault callback:
> 
> static vm_fault_t __do_fault(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	struct folio *folio;
> 	vm_fault_t ret;
> 	...
> 	ret = vma->vm_ops->fault(vmf);
> 	...
> 	return ret;
> }
> 
> For non-DAX XFS, xfs_filemap_fault() reaches filemap_fault():
> 
> static vm_fault_t
> xfs_filemap_fault(
> 	struct vm_fault		*vmf)
> {
> 	struct inode		*inode = file_inode(vmf->vma->vm_file);
> 	...
> 	return filemap_fault(vmf);
> }
> 
> Once that returns the folio, do_shared_fault() calls do_page_mkwrite()
> and then finish_fault():
> 
> static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	vm_fault_t ret, tmp;
> 	struct folio *folio;
> 	...
> 	folio = page_folio(vmf->page);
> 	...
> 	if (vma->vm_ops->page_mkwrite) {
> 		folio_unlock(folio);
> 		tmp = do_page_mkwrite(vmf, folio);
> 		...
> 	}
> 
> 	ret |= finish_fault(vmf);
> 	...
> }
> 
> do_page_mkwrite() calls the XFS callback installed above and restores
> the original fault flags:
> 
> static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
> {
> 	vm_fault_t ret;
> 	unsigned int old_flags = vmf->flags;
> 
> 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> 	...
> 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
> 	/* Restore original flags so that caller is not surprised */
> 	vmf->flags = old_flags;
> 	...
> }
> 
> So finish_fault() still sees FAULT_FLAG_WRITE. With an empty PMD, no
> fallback requirement, and a PMD-mappable folio, it tries do_set_pmd():
> 
> vm_fault_t finish_fault(struct vm_fault *vmf)
> {
> 	...
> 	if (pmd_none(*vmf->pmd)) {
> 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> 			ret = do_set_pmd(vmf, folio, page);
> 			if (ret != VM_FAULT_FALLBACK)
> 				return ret;
> 		}
> 		...
> 	}
> 	...
> }
> 
> After its checks pass, do_set_pmd() takes FAULT_FLAG_WRITE from vmf and
> installs a dirty+writable PMD:
> 
> vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	bool write = vmf->flags & FAULT_FLAG_WRITE;
> 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
> 	pmd_t entry;
> 	...
> 	entry = folio_mk_pmd(folio, vma->vm_page_prot);
> 	if (write)
> 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> 	...
> 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
> 	...
> }
> 
> maybe_pmd_mkwrite() sets write permission for VM_WRITE:
> 
> pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
> {
> 	if (likely(vma->vm_flags & VM_WRITE))
> 		pmd = pmd_mkwrite(pmd, vma);
> 	return pmd;
> }

Thanks, this makes sense!

> 
> >Namely, see the comment in wp_huge_pmd():
> >	/* COW or write-notify handled on pte level: split pmd. */
> >
> >if file huge pages get mapped writable, that's a bug.
> 
> That comment is about a different path. __handle_mm_fault() calls
> wp_huge_pmd() only when a write/unshare fault hits an existing PMD THP
> which is not writable:

No. That is simply a bug. There's little reason you wouldn't try do un-WP
a huge PMD if the idea would be to do PMD granularity for write notifications.
It isn't, naturally, because that results in horrible write amplification.

The fix IMO is to make it so write faults on shared mappings with page_mkwrite
never create a PMD. I don't think it makes sense to add rmap flushing hacks
for PMDs, when the common case (read + write) instantly and purposefully
breaks down to the PTE level (such that you really aren't supposed to get
the above; you'll notice that as soon as the folio gets cleaned, it will
get broken by the next write fault, period).

See the attached patch. I know willy has been working on related stuff, so
perhaps he might want to pick it up.


-- 
Pedro

--xqewysoglul6w752
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-always-fallback-to-PTE-mappings-for-shared-write-.patch"

From b2f3fee7f1cc285e6a1fa79e77c58a88a51197b0 Mon Sep 17 00:00:00 2001
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 20 Aug 2026 13:07:20 +0100
Subject: [PATCH] mm: always fallback to PTE mappings for shared write faults

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index b4be57b590ce..d37f8a0f8355 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5778,6 +5778,16 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		 */
 		needs_fallback = !shmem_mapping(mapping) &&
 			file_end < folio_next_index(folio);
+
+		if (vma->vm_flags & VM_SHARED && vma->vm_ops->page_mkwrite &&
+		    vmf->flags & FAULT_FLAG_WRITE) {
+			/*
+			 * Filesystems that want write notification want as
+			 * much granular of a mapping as possible. Don't
+			 * install writable THPs for those.
+			 */
+			needs_fallback = true;
+		}
 	}
 
 	if (pmd_none(*vmf->pmd)) {
-- 
2.55.0


--xqewysoglul6w752--

