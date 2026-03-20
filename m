Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B90108B8E3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4A46B0092; Fri, 20 Mar 2026 05:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AF36B0093; Fri, 20 Mar 2026 05:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0FA6B0095; Fri, 20 Mar 2026 05:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B80E76B0092
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:59:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53EA785C9F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:59:36 +0000 (UTC)
X-FDA: 84565994352.24.16E63CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4E7BE100002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:59:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SsR6G5uB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Rs84h2As;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SsR6G5uB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Rs84h2As;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LP3LRsyKh4/3ZsQytNQi/vsqocYBAThckRXzY0JSaY=;
	b=SAwtOr7ttzxXy7ehVx1VrpuBMK15EoMlHJBJcQwz24SJIicNwUYOECImnlKZkx5tX9PUsk
	7oYR4SKZ+yM2ep0ztenCSlzF4rcum0cZAB6owBU+HDjwm9g02mtH9/WWQCiiZ4oPiInv+P
	CieGm14O/4FiQXaIuhUwWahTZ/bdq9k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SsR6G5uB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Rs84h2As;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SsR6G5uB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Rs84h2As;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000774; a=rsa-sha256;
	cv=none;
	b=SL4JH3HtnaS44+9luhvHt1gQ8qEWpMi23W+9BbR7lotL/Ls3FNtv6I7mkGoYCZr2pIQi1G
	2oE1nhCco0OlufNB0Pl8TW8hQkPDyRQ0Pagbgtz2cChNRDZmGbNFItfUx6KA4jcS4KaL59
	GB4ZmuANjJq7TgDY4udLqirf3WhLvZo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 915E45BD87;
	Fri, 20 Mar 2026 09:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774000772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LP3LRsyKh4/3ZsQytNQi/vsqocYBAThckRXzY0JSaY=;
	b=SsR6G5uBmPm7fcvqX8Edvzdne/qHdip0qeyIGcarfkeUdYoqI/pYEkFnRGlYVnCAoObCWu
	ppThKZyTixc0lQ9EAyTidnJkXitb0WD0CeAf4FJgnzFc1Y/AL4CIur/L/6OMxGsP4NEB+2
	A23wAz7/+BsiK1pU1KiVuAadl/f+ztA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774000772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LP3LRsyKh4/3ZsQytNQi/vsqocYBAThckRXzY0JSaY=;
	b=Rs84h2AstRvOuPevirGCoxZhsCYu367kwqhZ6fmeWwh7kYOV13p5hbEYIO0sYuQDDxd4mr
	la57xDRMxPr0NSCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774000772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LP3LRsyKh4/3ZsQytNQi/vsqocYBAThckRXzY0JSaY=;
	b=SsR6G5uBmPm7fcvqX8Edvzdne/qHdip0qeyIGcarfkeUdYoqI/pYEkFnRGlYVnCAoObCWu
	ppThKZyTixc0lQ9EAyTidnJkXitb0WD0CeAf4FJgnzFc1Y/AL4CIur/L/6OMxGsP4NEB+2
	A23wAz7/+BsiK1pU1KiVuAadl/f+ztA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774000772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LP3LRsyKh4/3ZsQytNQi/vsqocYBAThckRXzY0JSaY=;
	b=Rs84h2AstRvOuPevirGCoxZhsCYu367kwqhZ6fmeWwh7kYOV13p5hbEYIO0sYuQDDxd4mr
	la57xDRMxPr0NSCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8BA54273B;
	Fri, 20 Mar 2026 09:59:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C0NkLYMavWmuIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Mar 2026 09:59:31 +0000
Date: Fri, 20 Mar 2026 09:59:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
Message-ID: <hmme2zpc4klftq56t7cfuvrzrp2k4t22g264fs3zloohuwelqe@ubrzpz37qlvm>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-2-pfalcato@suse.de>
 <9943a6ad-9c85-439c-ad9e-39a694a29147@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9943a6ad-9c85-439c-ad9e-39a694a29147@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E7BE100002
X-Stat-Signature: yk3yniyzcxg3eaz4mk6z9zdrfw4a6jp4
X-Rspam-User: 
X-HE-Tag: 1774000774-228748
X-HE-Meta: U2FsdGVkX1/XGsAmknVGJ05LkLcFNva84VTphdgUq8ot9GbprozYBN5Flsdit9ptrvksEtYAZ+vL6xnyHs39H70dkWktpqfwXvooFAICo7lHT97cDUMyaE/q+MwOD05mWIFrEYO72O45DRdlpc8jEXplBSSu7XVJrN9CQVbaAAQJADekXJwZjaFRsGS9+Ssn3v7jHmZ7PXo31PtH7sOWEn7jV02uILJsuyX9s7Z0cDgW15PpAEgJgVDGNLEEtvqmujqIuqVHlebOsWVIZAsvb091ylDVfg2u282EdsQ7crRTyQQPJBJP0xS2cfWBeHNje3lyMWWt92agL7R5NEFmBHiD+Sn85JGMAxx7FRz5xPgO1D5etawHZ98q4pXIN69tfcqwpfueZqt5n+iv+RlyZaE0Nf/tsb2C1HSmSjBoahMNvg1MUVPcFn0WRlEe4vD5/9sdoQ1CWdCEMXbsHflrwXVHjQdRdi1tjWEsJmuMG1puZoUWL5cV0vdW3pToZODXgQpWvzFs1TvzBpQYEkChCzt2/PuzquanJZwGh4no9cqoe9vufnbGScu9BLL1/kISFp1CrbNdraIX9BPaeWCfBNwDi3TF4DaqF6xmMFhfbcD89xu5JJlBp/NJx5Q7wOihRNCICXBWVxDrWulDec/k8lc48SCw01Uyjt8L6/6ls3T/kgihNQoHub9mVEcDYfUCh5thx8Y+VldbcW5fK72x3jDlVLtm5OmAlguI5VHHIZWjr/fpwiTyEQFwRGcLwZn8gWDIPAuDmbCNNkEZZqfaE81flGR70ADXcfbeX6zgsF+KBbJRv9XDq69vu5HFLJLlkrtx8VSW5LI1nrXnSzoFIAztSGq486FtQ/w2XrlSqFz3MPSWFRY4DpVwKayq6JxtDSO/15W2gpqPwaT5HJuhJJVeY/v6R6XqEIstVl/reyU+1KZd2xBxMWsA0iOkV/d/1a6wiZaWzwAy2unGiP7
 8+SMuhR7
 ATE8JUlILesd9F5HuaV0fUv8GLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:28:47PM +0100, David Hildenbrand (Arm) wrote:
> On 3/19/26 19:31, Pedro Falcato wrote:
> > Encourage the compiler to inline batch PTE logic and resolve constant
> > branches by adding __always_inline strategically.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  mm/mprotect.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 9681f055b9fc..1bd0d4aa07c2 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> >  	return can_change_shared_pte_writable(vma, pte);
> >  }
> >  
> > -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> > +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> >  				    pte_t pte, int max_nr_ptes, fpb_t flags)
> >  {
> >  	/* No underlying folio, so cannot batch */
> > @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> >  }
> >  
> >  /* Set nr_ptes number of ptes, starting from idx */
> > -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
> > -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
> > -		int idx, bool set_write, struct mmu_gather *tlb)
> > +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
> > +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
> > +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
> >  {
> >  	/*
> >  	 * Advance the position in the batch by idx; note that if idx > 0,
> > @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
> >   * pte of the batch. Therefore, we must individually check all pages and
> >   * retrieve sub-batches.
> >   */
> > -static void commit_anon_folio_batch(struct vm_area_struct *vma,
> > +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
> >  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
> >  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
> >  {
> 
> From my micro-optimization work on zapping and fork, I learned that
> these batching functions are best optimized for order-0 page by
> explicitly calling them from the code with "nr_ptes == 1" and then
> force-inlining them. nr_ptes and all loops will essentially be optimized
> out.
> 
> With no such explicit constants, is there really a real benefit to be
> had here?

Per my measurements, I could measure a real speedup here. Of course things
may heavily depend on the microarchitecture you use. I want to note that
these three functions are part of the hot loop and thus we definitely want
them inlined. Particularly if we start special-casing stuff. You can cut
down _a lot_ of code if you simply tell it "yeah don't bother you're looking
at 1 pte only".

Of course a lot of this is just codegen fengshui but I tried sticking to
good fundamentals and inlining things that matter, while noinlining
things that aren't frequent. As-is the compiler seems to make poor
inlining decisions on its own (and basically every static function is
inlined, except e.g prot_commit_flush_ptes, FOR SOME REASON).

-- 
Pedro

