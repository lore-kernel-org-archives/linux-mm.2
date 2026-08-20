Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF9BC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 14:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981C46B008C; Thu, 20 Aug 2026 10:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958D46B0092; Thu, 20 Aug 2026 10:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848966B009D; Thu, 20 Aug 2026 10:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 580F26B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:10:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C081F1A018E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:10:26 +0000 (UTC)
X-FDA: 85121832852.20.8E7A8AC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 662354000E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:10:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZCf63Tsd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IHJ1dY61;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kLKKeQP/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVr6fqqX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787235024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPfL8H5t4Gmq0gqAgbjj1M6oZS2jFOmbr+wLHGqtfgw=;
	b=5BsXyz2VgivCJPS2MycqwEZrk9VpaIqs2XtznIBGmD3DaB9TWFxXlMxm60AwsxLQBbA3lS
	R2f7L8GxJzSiFikjZZjImyCUoUBCBiAgtQ/6rwZFEj/ffjCOmndcdVEJ1mnl3ciOFkJ7Hb
	znhI79nn3fFFRwrs530H8OqVp4tzMes=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZCf63Tsd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IHJ1dY61;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="kLKKeQP/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=dVr6fqqX;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787235024;
	b=OA90xKAcwnnAIxrLA158CNMlm9xBdLhsm01c8ePDP0ilIMOCK8nhO1nhHzKhvMivLBZvXJ
	mOXk9xzf8uT7dz8oQ3wemDCpCqPhbTzKSaJvXGKoZdA4Pjya7lLMZKk2M64oP6EHrotA8z
	ubRJLsxlt1pD1vdsaK79N3Wk0uOSMo8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DCB485113;
	Thu, 20 Aug 2026 14:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787235018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPfL8H5t4Gmq0gqAgbjj1M6oZS2jFOmbr+wLHGqtfgw=;
	b=ZCf63TsdyVHNAf2dB4X4JrB+bHzaJZ7je5ioVjUtPaT+Unjp0HiitH8HM6sOXzl1orUh4E
	FpZ9z6ZHNnAmjVVLRFRvgA8HwhOMzA8xzaTVGpVyXyKXWe+uCoffGzd4wV/zyfiwzZdIh8
	9hb7FXorYSqZPofxywKH2JewEgugxX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787235018;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPfL8H5t4Gmq0gqAgbjj1M6oZS2jFOmbr+wLHGqtfgw=;
	b=IHJ1dY61ovG8ZMzXFPVJcMUS3lXLK+rV+WuWrX/bOylhXx4MIJquTXjmJkXiWOfTKsE0e8
	xaboVUcTUKe5OoBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787235014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPfL8H5t4Gmq0gqAgbjj1M6oZS2jFOmbr+wLHGqtfgw=;
	b=kLKKeQP/BFki5NpsjVTLu/V2MuypE1BDQaShVNKxGsqpvNBtsI1MujaPWPSvabi3/S2dnn
	0Lf+kneesSEniozaPKDokR8TUcJPm2z6Q2yECYz7V0K86Ki2GtgXgmn6dwXpZ0ClLz+tdV
	81o6HgF+5RoV9ZyC9iDHN0u5kUh43K0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787235014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kPfL8H5t4Gmq0gqAgbjj1M6oZS2jFOmbr+wLHGqtfgw=;
	b=dVr6fqqXIOT3UxBuHyE/DW69XqkAq612DV+QR9FsR7iKvfvwr1kjtM3ZRlixLTdwnTsLhJ
	zmrq6MSVHqwLp9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 297E0351D;
	Thu, 20 Aug 2026 14:10:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +EXYBsUKh2qRWgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 20 Aug 2026 14:10:13 +0000
Date: Thu, 20 Aug 2026 15:10:11 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, usama.arif@linux.dev, 
	hughd@google.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aocFPRgqieScf_yo@pedro-suse.lan>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan>
 <aob9PF_H6CCJMdkk@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aob9PF_H6CCJMdkk@thinkstation>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 662354000E
X-Stat-Signature: kywtr9148fczhe3iaz5xp9skwhzey9yg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787235024-910578
X-HE-Meta: U2FsdGVkX19hBUmz3k4omD31zyY7JDIWQbMupepRbq3xcOAN4s2M7XEtanhoblcDHxfDKTZOQyVZacRx6ZXYWWWJ1uXvF7VGA9sPe8G/dP566+gixCZ+I9HuzVBPuthcU++Y8iwx1C23gWH36T18noQPyyC8d2xX6HHD+3FRmYaz9Z227LieG/wFB3QYwX/eEqEkIunSaOw2V7fQTxOiLTMWfWtDFyWQoNPQerupnhZu30F1Gb2mxi/Zvc/TwLMF9lmVanxrzpLk4J0w+lOcuDC+Rx1+UsG6y8kwssk0LJKkUE9JlP+iL8gACybt73uTRm7CIZyEl2GmEUTqroAYQcCgg5vy/LyckxC+MazRfcp8qAlK1c9etWCltWSICyKTtSP+d88iOQwEuSloQm9z92IoBucW1qSlcl+Y7WCx05tWg8Sc+2nk9TyWZUO3BVzGF5HUgLwIVArTRgKGctMOQhAsvqTH1t9WRbCoGgB71P4UWj9tizrAc+NBdoTjRwnRb4Ku5ddUqkDRd3HOSEEy5fJW7dejyB6LKbXwkpKVOrp/kQgss4PstIMlXIhquvBClCE01GKPxSRuE6CnQrxGizNC6oTnOYIQbIBXGLmiCDAWxlGBQNZJpXUQgSq+dLkhYUsgNnJKVaawUrlvLuzpPa7aHTkzpUCHQN0Hcte5VkHBTfpETo1Dw6/kwllhfRGJrC58JxbvsRPXIRh6XIC4t+XE28zbfqtXWedYMXLdsIMNzcGuZA7kEIUawNgTCesEeSwZYhUC/Bx2Lmqtyskn9gdpdI69melrwKudXIXdKznk2hPeNmNJtDusqgKSfNpnKlstopdOuju9YBWtoGZcLvk/BMLmYtl8MLiUf7x8PSA5mcJpfF1BZBEyTpaHDPa2TkFFFHrKMQgyz3lGD//L4qmT24Zk3HhO85KmmqsNGMuOj2H6QhFkOVjqZgHMxbwVvFwWSMyexrwMrPznKVG
 Wf9WCpPH
 yQM1Qfj8slmaA7LV2n2z1bo95b9yYQVDku97ycKtA8FHX5gRaQsh+1Z2071f070Gbg2tK+i8sxjpM8u+MkAOViEOiw1tIMSf55q6XbR6j8ZiovKmD5+dDp5yOHJhAwzTGaLb6uf0zdRf/PkTNiAf1Vg++Yr0bpz/UdzredgFoPCr0wWlpn0cvfJTp3nmyMdyso6SYXPcalSCQINqVcEcNOH8isOcRbfh6MOX0qt4sl89FJyw4OvTpxsYKRW162XnGFBMraA6NhKsIdlZwdXYJB129w7wQj/BgL6FhuJqQsQHuiR0eZW6GcYY3CdwHpd2FpUDQucAQEkkaDu95iglrFRAOEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 02:20:26PM +0100, Kiryl Shutsemau wrote:
> On Thu, Aug 20, 2026 at 01:12:18PM +0100, Pedro Falcato wrote:
> > +CC willy
> > 
> > On Thu, Aug 20, 2026 at 02:13:37PM +0800, Lance Yang wrote:
> > > 
> > > On Wed, Aug 19, 2026 at 05:35:41PM +0100, Pedro Falcato wrote:
> > > >On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
> > > >> On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> > > >> > zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> > > >> > file case, but not the dirty bit.  The pte path does propagate it, in
> > > >> > zap_present_folio_ptes() and so does the pmd split path, in
> > > >> > __split_huge_pmd_locked().
> > > >> > 
> > > >> > For most file mappings the omission is harmless, because writing to a
> > > >> > shared file mapping goes through page_mkwrite(), which dirties the
> > > >> > folio.  tmpfs is different: it has no page_mkwrite(), and
> > > >> > vma_wants_writenotify() is false for it, so a *read* fault on a
> > > >> > MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> > > >> > do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> > > >> > stores through that mapping set only the hardware dirty bit in the pmd
> > > >> > and never call folio_mark_dirty().
> > > >> >
> > > >> > A shmem folio allocated by a fault
> > > >> > is marked uptodate but not dirty (see the clear: block in
> > > >> > shmem_get_folio_gfp()), so PG_dirty is never set at all.
> > > >> > 
> > > >> > Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> > > >> > - then loses the only record that it was written, because zap_huge_pmd()
> > > >> > drops the pmd without transferring the dirty bit.  Reclaim afterwards
> > > >> > sees a clean shmem folio: the whole swap-out block in
> > > >> > shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> > > >> > pageout() is skipped and the folio falls into __remove_mapping().
> > > >> > There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> > > >> > entry is created and __filemap_remove_folio(folio, NULL) simply empties
> > > >> > the i_pages slot.  The data is freed without ever being written to swap,
> > > >> > and the next fault on that index returns a freshly zeroed folio.
> > > >> > 
> > > >> > This is silent data loss for any process that keeps state in a
> > > >> > MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> > > >> > from one process generation to the next through /dev/shm.  It requires
> > > >> > the folio to be PMD-mapped, so it only shows up once shmem THP is
> > > >> > enabled (which is what we did in Meta fleet and started noticing crashes);
> > > >> > with THP off the pte path transfers the dirty bit correctly.
> > > >> > It also only becomes visible when swap is enabled, because with no swap
> > > >> > device shmem folios (which are on the anon LRU) are not scanned by
> > > >> > reclaim at all, so the clean folio is never dropped.
> > > >> > 
> > > >> > Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> > > >> > 2MB-backed region, write a known pattern through the resulting mapping,
> > > >> > munmap, force reclaim of the cgroup, then re-map and read back.  Without
> > > >> > this patch the region reads back as zeros and vmstat shows zswpout 0 -
> > > >> > the data was discarded rather than swapped.  With this patch the region
> > > >> > reads back correctly and the pages are swapped out as expected.  With
> > > >> > huge=never, or when the first touch is a write, the test passes either
> > > >> > way.
> > > >> 
> > > >> +Hugh.
> > > >> 
> > > >> Oopsie.
> > > >> 
> > > >> I'm confused why it took a decade to discover the bug...
> > > >> Maybe read ahead of write for shmem is too rare, I donno.
> > > >> 
> > > >> > 
> > > >> > Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> > > >> 
> > > >> This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")
> > > >> 
> > > >> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> > > >> 
> > > >> > Cc: <stable@vger.kernel.org>
> > > >> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > >> > ---
> > > >> >  mm/huge_memory.c | 2 ++
> > > >> >  1 file changed, 2 insertions(+)
> > > >> > 
> > > >> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > >> > index ced400f72d43a..afbb5974bd225 100644
> > > >> > --- a/mm/huge_memory.c
> > > >> > +++ b/mm/huge_memory.c
> > > >> > @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> > > >> >  		add_mm_counter(mm, mm_counter_file(folio),
> > > >> >  			       -HPAGE_PMD_NR);
> > > >> >  
> > > >> > +		if (is_present && pmd_dirty(pmdval))
> > > >> > +			folio_mark_dirty(folio);
> > > >> 
> > > >> Unrelated to your patch, but noticed while looking at it: we drop the rmap
> > > >> here under the pmd lock, while the TLB flush is deferred to
> > > >> tlb_finish_mmu(). The pte path handles this with
> > > >> tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
> > > >> tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
> > > >> zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.
> > > >> 
> > > >> Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
> > > >> do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
> > > >> folio_mkclean() can clean the folio while another CPU still stores through a
> > > >> stale TLB entry -- silently lost write, no PG_dirty left behind.
> > > >
> > > >Where do you see page_mkwrite being called in the same path as do_set_pmd()?
> > > >Per my understanding of the code, this Should Not Happen, and it really Should
> > > >Not Happen for many, many reasons (write amplification being the main one).
> > > 
> > > Hmm.. that happens on an initial shared write fault. For non-DAX XFS, the
> > > path starts with an empty PMD.
> > > 
> > > TL;DR
> > > 
> > > With an empty PMD and PMD-order THP allowed, __handle_mm_fault() first
> > > tries create_huge_pmd(). VM_FAULT_FALLBACK sends the fault to
> > > handle_pte_fault():
> > > 
> > > static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
> > > 		unsigned long address, unsigned int flags)
> > > {
> > > 	...
> > > 	if (pmd_none(*vmf.pmd) &&
> > > 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
> > > 		ret = create_huge_pmd(&vmf);
> > > 		if (ret & VM_FAULT_FALLBACK)
> > > 			goto fallback;
> > > 		else
> > > 			return ret;
> > > 	}
> > > 	...
> > > fallback:
> > > 	return handle_pte_fault(&vmf);
> > > }
> > > 
> > > create_huge_pmd() dispatches to the filesystem's huge_fault callback:
> > > 
> > > static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	...
> > > 	if (vma->vm_ops->huge_fault)
> > > 		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
> > > 	return VM_FAULT_FALLBACK;
> > > }
> > > 
> > > For non-DAX XFS, that callback returns VM_FAULT_FALLBACK:
> > > 
> > > static vm_fault_t
> > > xfs_filemap_huge_fault(
> > > 	struct vm_fault		*vmf,
> > > 	unsigned int		order)
> > > {
> > > 	if (!IS_DAX(file_inode(vmf->vma->vm_file)))
> > > 		return VM_FAULT_FALLBACK;
> > > 	...
> > > }
> > > 
> > > XFS installs the huge-fault, regular-fault, and page_mkwrite callbacks
> > > in the same vm_ops:
> > > 
> > > static const struct vm_operations_struct xfs_file_vm_ops = {
> > > 	.fault		= xfs_filemap_fault,
> > > 	.huge_fault	= xfs_filemap_huge_fault,
> > > 	...
> > > 	.page_mkwrite	= xfs_filemap_page_mkwrite,
> > > 	...
> > > };
> > > 
> > > On the fallback path, handle_pte_fault() leaves an empty PMD without a
> > > PTE and calls do_pte_missing():
> > > 
> > > static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> > > {
> > > 	...
> > > 	if (unlikely(pmd_none(*vmf->pmd))) {
> > > 		/*
> > > 		 * Leave __pte_alloc() until later: because vm_ops->fault may
> > > 		 * want to allocate huge page, and if we expose page table
> > > 		 * for an instant, it will be difficult to retract from
> > > 		 * concurrent faults and from rmap lookups.
> > > 		 */
> > > 		vmf->pte = NULL;
> > > 		vmf->flags &= ~FAULT_FLAG_ORIG_PTE_VALID;
> > > 	...
> > > 	}
> > > 
> > > 	if (!vmf->pte)
> > > 		return do_pte_missing(vmf);
> > > 	...
> > > }
> > > 
> > > For a file VMA, do_pte_missing() calls do_fault():
> > > 
> > > static vm_fault_t do_pte_missing(struct vm_fault *vmf)
> > > {
> > > 	if (vma_is_anonymous(vmf->vma))
> > > 		return do_anonymous_page(vmf);
> > > 	else
> > > 		return do_fault(vmf);
> > > }
> > > 
> > > do_fault() sends FAULT_FLAG_WRITE + VM_SHARED to do_shared_fault():
> > > 
> > > static vm_fault_t do_fault(struct vm_fault *vmf)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	...
> > > 	if (!vma->vm_ops->fault) {
> > > 		...
> > > 	} else if (!(vmf->flags & FAULT_FLAG_WRITE))
> > > 		ret = do_read_fault(vmf);
> > > 	else if (!(vma->vm_flags & VM_SHARED))
> > > 		ret = do_cow_fault(vmf);
> > > 	else
> > > 		ret = do_shared_fault(vmf);
> > > 	...
> > > }
> > > 
> > > do_shared_fault() first calls __do_fault():
> > > 
> > > static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	vm_fault_t ret, tmp;
> > > 	struct folio *folio;
> > > 	...
> > > 	ret = __do_fault(vmf);
> > > 	...
> > > }
> > > 
> > > __do_fault() invokes the regular fault callback:
> > > 
> > > static vm_fault_t __do_fault(struct vm_fault *vmf)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	struct folio *folio;
> > > 	vm_fault_t ret;
> > > 	...
> > > 	ret = vma->vm_ops->fault(vmf);
> > > 	...
> > > 	return ret;
> > > }
> > > 
> > > For non-DAX XFS, xfs_filemap_fault() reaches filemap_fault():
> > > 
> > > static vm_fault_t
> > > xfs_filemap_fault(
> > > 	struct vm_fault		*vmf)
> > > {
> > > 	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > > 	...
> > > 	return filemap_fault(vmf);
> > > }
> > > 
> > > Once that returns the folio, do_shared_fault() calls do_page_mkwrite()
> > > and then finish_fault():
> > > 
> > > static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	vm_fault_t ret, tmp;
> > > 	struct folio *folio;
> > > 	...
> > > 	folio = page_folio(vmf->page);
> > > 	...
> > > 	if (vma->vm_ops->page_mkwrite) {
> > > 		folio_unlock(folio);
> > > 		tmp = do_page_mkwrite(vmf, folio);
> > > 		...
> > > 	}
> > > 
> > > 	ret |= finish_fault(vmf);
> > > 	...
> > > }
> > > 
> > > do_page_mkwrite() calls the XFS callback installed above and restores
> > > the original fault flags:
> > > 
> > > static vm_fault_t do_page_mkwrite(struct vm_fault *vmf, struct folio *folio)
> > > {
> > > 	vm_fault_t ret;
> > > 	unsigned int old_flags = vmf->flags;
> > > 
> > > 	vmf->flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
> > > 	...
> > > 	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
> > > 	/* Restore original flags so that caller is not surprised */
> > > 	vmf->flags = old_flags;
> > > 	...
> > > }
> > > 
> > > So finish_fault() still sees FAULT_FLAG_WRITE. With an empty PMD, no
> > > fallback requirement, and a PMD-mappable folio, it tries do_set_pmd():
> > > 
> > > vm_fault_t finish_fault(struct vm_fault *vmf)
> > > {
> > > 	...
> > > 	if (pmd_none(*vmf->pmd)) {
> > > 		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> > > 			ret = do_set_pmd(vmf, folio, page);
> > > 			if (ret != VM_FAULT_FALLBACK)
> > > 				return ret;
> > > 		}
> > > 		...
> > > 	}
> > > 	...
> > > }
> > > 
> > > After its checks pass, do_set_pmd() takes FAULT_FLAG_WRITE from vmf and
> > > installs a dirty+writable PMD:
> > > 
> > > vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
> > > {
> > > 	struct vm_area_struct *vma = vmf->vma;
> > > 	bool write = vmf->flags & FAULT_FLAG_WRITE;
> > > 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
> > > 	pmd_t entry;
> > > 	...
> > > 	entry = folio_mk_pmd(folio, vma->vm_page_prot);
> > > 	if (write)
> > > 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> > > 	...
> > > 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
> > > 	...
> > > }
> > > 
> > > maybe_pmd_mkwrite() sets write permission for VM_WRITE:
> > > 
> > > pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
> > > {
> > > 	if (likely(vma->vm_flags & VM_WRITE))
> > > 		pmd = pmd_mkwrite(pmd, vma);
> > > 	return pmd;
> > > }
> > 
> > Thanks, this makes sense!
> > 
> > > 
> > > >Namely, see the comment in wp_huge_pmd():
> > > >	/* COW or write-notify handled on pte level: split pmd. */
> > > >
> > > >if file huge pages get mapped writable, that's a bug.
> > > 
> > > That comment is about a different path. __handle_mm_fault() calls
> > > wp_huge_pmd() only when a write/unshare fault hits an existing PMD THP
> > > which is not writable:
> > 
> > No. That is simply a bug. There's little reason you wouldn't try do un-WP
> > a huge PMD if the idea would be to do PMD granularity for write notifications.
> > It isn't, naturally, because that results in horrible write amplification.
> 
> Write notification is already folio-granular. Installing PTE instead of
> PMD changes nothing.

It does! See below.

> 
> > The fix IMO is to make it so write faults on shared mappings with page_mkwrite
> > never create a PMD.
> 
> Why? Write batching from large folios is a win.

For some context: we were discussing (off-list) the recent report that
systemd-journald had horrible write amplification, worsed quite a bit
by large folios. At the moment, there is quite a lot of write amplification,
but _only_ on mmap writes (if you look at the write(2) paths, you'll see
write_begin and write_end which tactically only dirty what you actually wrote
to, block-wise in the BHs or iomap IFS). This doesn't need to be true.

What we conjured up was the following: since WP faults always happen on PTEs,
you can simply dirty the block(s) corresponding to that particular PTE (which
naturally points to a page inside the folio, whether it is large or not, doesn't
matter). That way, you can avoid fully dirtying the folio's blocks. This is
something that ATM isn't done by any filesystem, but it really should.

Obviously this whole idea is thwarted if we keep writable shared file folios
PMD-mapped - you can't get meaningful write notifications apart from "someone
wrote to this folio", which isn't particularly useful once folios get 2M+ large.
So PMD-mapping on a shared-write fault is antithetical to getting useful,
granular write notifications to filesystems.

(I admit, I'm not sure if anyone cares about hugepages _and_ writing; I think
not, and if they do we could perhaps consider merging the PTEs back into a PMD
once the folio gets cleared, or if the whole folio is dirty, but I suspect the
details would be horribly hairy. Maybe mongodb cares.)

> 
> > I don't think it makes sense to add rmap flushing hacks
> > for PMDs, when the common case (read + write) instantly and purposefully
> > breaks down to the PTE level (such that you really aren't supposed to get
> > the above; you'll notice that as soon as the folio gets cleaned, it will
> > get broken by the next write fault, period).
> 
> If you consider delayed rmap a hack (I don't), it has to fixed on PTE
> level too.
> 
> > See the attached patch. I know willy has been working on related stuff, so
> > perhaps he might want to pick it up.
> 
> As I said the patch doesn't do what you expect it to do. PG_dirty is on
> folio and we writeback folios, not PTEs.
> 
> Also, needs_fallback is not just "no PMD": finish_fault() then forces
> nr_pages = 1, so it is 512 faults and 512 ->page_mkwrite calls per 2M folio
> instead of one.

You're 100% right :) That teaches me not to write patches on PTO :) So the
patch would need to be modified, but I think the principle still stands.

> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Pedro

