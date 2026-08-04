Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF490C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CECE26B00D8; Tue,  4 Aug 2026 15:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EA36B00DA; Tue,  4 Aug 2026 15:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BFA6B00DF; Tue,  4 Aug 2026 15:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6936B00D8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:23:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 250741C0823
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:23:14 +0000 (UTC)
X-FDA: 85064560308.09.CFD71AB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id EEE678000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:23:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0aDHau6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pGC0mHI0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gvPlR+Hd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9l91suue;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKD7xlXfwFoEwiwqHEV4Td7lXumlOXqIMagnoJLqgFA=;
	b=V3YzfBnDvmhs3JBvWyvdegDewr+MtVFhREzTBY6oux0dymcfLUe4BFpZCpp2EIYF4uwePC
	+HIO/lHaw0YaLGsi3GojooL9XHMAQGg8EJquJohUxd+d0WIZYCioQtahnrH307bpl8INO8
	Uc9e7rzrTbvbJYOvVgGvgipqkl1Wg04=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0aDHau6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pGC0mHI0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gvPlR+Hd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9l91suue;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871392;
	b=VPIJ/oRIhZULgoh1o8M4I4ifNj3Pjq6pDxNw0RWRABoPPGoOr9qMOCQ9MYOENtcHM4obGV
	unUL36pktO48aiPYJ2k+VwcS22vzTVX9PRM/aI2Ofxgh3+OEV/S2v9wNB3rt95l5Ynye52
	IuujkUZbMDtoWl3wucOTlYexC2ytZlI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 33AE63E7F;
	Tue,  4 Aug 2026 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785871386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BKD7xlXfwFoEwiwqHEV4Td7lXumlOXqIMagnoJLqgFA=;
	b=G0aDHau6+dIF0VH9t1gS8zo/PAE5MUYtI5NFSJa+igRMyfvazx08234PtrB5zhMSqvolUc
	ZRlNH6FMUsNtxJXHp9b423eoHcwb3mWs+HOhqhgA88b0NnBuOftLs9/PFg4+xpFZ3z5suZ
	3Vh14YFjPbLSry6q8o8XstVCgShvlKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785871386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BKD7xlXfwFoEwiwqHEV4Td7lXumlOXqIMagnoJLqgFA=;
	b=pGC0mHI08b9pOWsQTxcNzgcuiKSFwx/kGcb0oreTd5YmdjxJwS/tXPSu07A9mzE5Xx4M8S
	UOfeAimDR6/I+FBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785871382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BKD7xlXfwFoEwiwqHEV4Td7lXumlOXqIMagnoJLqgFA=;
	b=gvPlR+HddGLYBkCQFYlBjwm/5NDohTMacQIo4zdQY5wDSAMNKeIX6GQeE55WveZfb7EOlc
	h9ckoqyZ4MS0TeimEz1GyDiXqUswKlvAOpzQpzZ5vCOqLMRuye6vK7qyKAfuzSnUaoBAn5
	7kl2EZYltPAucG9K3qTn0uxRYtxiIaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785871382;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BKD7xlXfwFoEwiwqHEV4Td7lXumlOXqIMagnoJLqgFA=;
	b=9l91suueSJ/aZk3c7geSquvAlMvZDmI4qlaZrtRMZmI3pJWfN07iE4Cw/pIS9pT1bNtGWT
	cnVYkK+8J3MjuDCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F36F779BB;
	Tue,  4 Aug 2026 19:23:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GVRHCBQ8cmofZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 04 Aug 2026 19:23:00 +0000
Date: Tue, 4 Aug 2026 20:22:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] mm: constify the pte_offset_map_ro_nolock()
 return value
Message-ID: <anI6BEyTJFzQY-N9@pedro-suse.lan>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-7-pfalcato@suse.de>
 <anHJ48Glq8EdHatd@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHJ48Glq8EdHatd@lucifer>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 7pgkc5576p5s87wf9qy8t3urhdaoqusf
X-Rspamd-Queue-Id: EEE678000E
X-HE-Tag: 1785871391-111981
X-HE-Meta: U2FsdGVkX1+o//UzpK4YxzTW7wRs+VTprWRTzzSNxFzXaMqGa7RvZ1NjIMTVZzUjaV3ooFFChiI7lzyq7mcjflx918D9jcK7JmfqpJm9ILmqjxwIXjSoZzsS0xX+W3BAOMDet4lAEBWam5lGpwWJPB+LIpr0J4/22EUszyQ12FLW/LkXwayOSa1YHLGnfbs1cq5GhqIaOJK33gkYAXzDsCyz65M6I8Brvr75xJ+4yDnTaQ6BUj6vzDvLzpTSQ/FdILcmTG0qRhkNhF9XaAIUs32ULxMllMyFCt3RrA/J2r1iBH8Qtuz2a9G9J8cn53lIqMuNHdEuAJN6B5Y/QuQ4TKldfpZR/CEKv462sBHfMkxFom/h6MKnJ2qyHCEXL2OZEmz0Xg8NDZ4dqvgnCHc3GSQWmTKPbZybHGoQgMs3u5TzZXqTNkHoLrrKV5/8yrPgeyCwGIhRVwwB4PMEJbMcZu8l/t2JWAF90Op6/OUEiEDp0JIkJ65poa+SQamU3DPd6QpxE3aiibIZ1hVO1ifLDfMkKnS0GTGUAcIqCWAX6EsG04bQkReP3us5z47timMz2gqL/A86HiWifxPpWaKN/EmJX23/d7Yqf74XVzLZwgcCywMfYqfMBJMFMCtyBIGuLgEclZ1DwqeY0Cj7ffA4E64u/vRHNofdY1O31koNMNJJMNzw7zGhyVQIkdFTrYTxeRTj2Hzbz9mh2bn8IE38C/wzYndOMqfWOe0QNdnd2UL2IbcVJqkht6j50V5bbLBtqcwsppO30Amq8H19/k2o/oj04ctthmmLuuBFepZEPXSMUp8gnkpLK9rMCWm/SlUBY4UtKgqBNn7e7AQa3JBTRnOvFCn8amx464nAZnNwAKG/HeTF1GhVJ+ZUOM566XxJMSvv21RiiJVbpe86YRO5E9hohkKLBJrf6oA2g0BqwEEika6sE+mWt5THMPcUtEj0f2HXz4IyDBtfUF13QzR
 Y/BEITiU
 Fs4blY29yF3ewpti6Ma7LqtqA50oT2u8R+CRHeIzX//t1z3WrYDdx8Fk8ZhFiBmbIKu2F4A24/CMYkEIk/TTmMoAWVikZ6CaBQ9qZKg6rZQO95ZTzWlyl9TAJQSzBEioIDosjyvD1woQY60Y4wcskB9HBnlgAQbUNbOhzbXsP7qQcIYbMxPWc7Md/x5TxrOf9vL9zyXP/nFaDTFeW7dXaC2wT8N/i5kz7SmXESAvwD2W3WmRExStO4lDzk1SPjWzJuFogsESNnL2Pj4M2sYJtVX5ugxpWPlX3J7IMFwMvzlyuJ2SzlkfJ/IJ8XrC/w+3EwGRjIqSI8rqGSlItD2rtaCYm8OEVdGB3M0KqTbbzSqTyemJwmrJRZvZ71U9kPYIoooCjppkbD4hjEnAZROGXKC3fQ8J7NlXli+g+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 12:22:19PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 05:44:00PM +0100, Pedro Falcato wrote:
> > Constify the pte_t * retval from pte_offset_map_ro_nolock(), for which it is
> > already pledged that accesses must be read-only. With it, convert the three
> > treewide users to use const pte_t *.
> >
> > khugepaged passes the result right down to fault code (do_swap_page()). This
> > leads to a complicated set of conditions that, in order to be correct, must
> > not install anything into *vmf->pte. This is not trivial to work around in
> > fault code, and as such just trivially cast to non-const pte_t* in the
> > meantime.
> >
> > The other users are far more trivial and the conversion is equally
> > trivially simple.
> 
> Ah finally more words! :)

:)

> 
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> With comment updated as below and nits addressed, LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  arch/powerpc/mm/pgtable.c | 2 +-
> >  include/linux/mm.h        | 4 ++--
> >  include/linux/pgtable.h   | 2 +-
> >  mm/filemap.c              | 2 +-
> >  mm/khugepaged.c           | 2 +-
> >  mm/pgtable-generic.c      | 4 ++--
> >  6 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
> > index a9be337be3e4..e29db41b6043 100644
> > --- a/arch/powerpc/mm/pgtable.c
> > +++ b/arch/powerpc/mm/pgtable.c
> > @@ -390,7 +390,7 @@ void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
> >  	p4d_t *p4d;
> >  	pud_t *pud;
> >  	pmd_t *pmd;
> > -	pte_t *pte;
> > +	const pte_t *pte;
> >  	spinlock_t *ptl;
> >
> >  	if (mm == &init_mm)
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 7fabe6c66b4b..acf5a5e31d34 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3885,8 +3885,8 @@ static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
> >  pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
> >  			   unsigned long addr, spinlock_t **ptlp);
> >
> > -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> > -				unsigned long addr, spinlock_t **ptlp);
> > +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> > +				      unsigned long addr, spinlock_t **ptlp);
> >  pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
> >  				unsigned long addr, pmd_t *pmdvalp,
> >  				spinlock_t **ptlp);
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index dc418553e57a..dd51e722c535 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -112,7 +112,7 @@ static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
> >  {
> >  	return pte_offset_kernel(pmd, address);
> >  }
> > -static inline void pte_unmap(pte_t *pte)
> > +static inline void pte_unmap(const pte_t *pte)
> 
> I was going to question this based on whether the contract holds for
> CONFIG_HIGHPTE but actually:
> 
> #define pte_unmap(pte)	do {	\
> 	kunmap_local((pte));	\
> 	rcu_read_unlock();	\
> } while (0)
> 
> #define kunmap_local(__addr)					\
> do {								\
> 	BUILD_BUG_ON(__same_type((__addr), struct page *));	\
> 	__kunmap_local(__addr);					\
> } while (0)
> 
> static inline void __kunmap_local(const void *vaddr) <-- const!
> {
> 	kunmap_local_indexed(vaddr);
> }
> 
> So nice (CONFIG_HIGHPTE is going to go away at some point though, right? I
> hope... :)
> 
> 
> >  {
> >  	rcu_read_unlock();
> >  }
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 6afec636881f..af5d3fcd1b05 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3490,7 +3490,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	vm_fault_t ret = 0;
> > -	pte_t *ptep;
> > +	const pte_t *ptep;
> >
> >  	/*
> >  	 * We might have COW'ed a pagecache folio and might now have an mlocked
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b237f6e7662a..09efac93a8c6 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1170,7 +1170,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
> >  			 * Here the ptl is only used to check pte_same() in
> >  			 * do_swap_page(), so readonly version is enough.
> >  			 */
> > -			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
> > +			pte = (pte_t *) pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
> 
> Hmm yeah this is nasty, but you explain why in the commit message. Could you
> extend the comment to explain it?

Yep, I'll do it.

> 
> >  			if (!pte) {
> >  				mmap_read_unlock(mm);
> >  				result = SCAN_NO_PTE_TABLE;
> > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > index b91b1a98029c..2cfc6e608ef4 100644
> > --- a/mm/pgtable-generic.c
> > +++ b/mm/pgtable-generic.c
> > @@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
> >  	return NULL;
> >  }
> >
> > -pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> > -				unsigned long addr, spinlock_t **ptlp)
> > +const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
> 
> Can pmd be const too?

I was going to say "yes but then pmdp_get() also needs to be constfified" but
actually no, it can't:

pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp) {
        if (unlikely(pmd_bad(pmdval))) {
                pmd_clear_bad(pmd);
                goto nomap;
        }
}

so PTE mapping actually needs to write to the pmdp if the pmd looks bad.
Tricky stuff :)

-- 
Pedro

