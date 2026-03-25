Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570E1103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C396F6B0095; Wed, 25 Mar 2026 07:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA006B0096; Wed, 25 Mar 2026 07:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00556B0098; Wed, 25 Mar 2026 07:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E62F6B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:37:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EF451A080D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:37:46 +0000 (UTC)
X-FDA: 84584385732.22.F6869E4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC4A680008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:37:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C4Rg9HUN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+X+ddI8g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C4Rg9HUN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+X+ddI8g;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGOiQCiQisXR76KhBKJZQggBhPWcoMLU1aMLzL81b4I=;
	b=LuTin1Mt84s8nPmC+XzEuklIq1pA7T/3xHNWg7y+LcW6mrwXQUybBVF60F7TG3VVePtxd0
	MkPRz3Uxl34cVsbZrGWUIpndgEE8LP+O/3khMAzm7C+Top0rKWLt24NeFCXAPi9n2/Esdj
	NnETqblLF5EubMUTWHTyJqQCT+pBlyo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C4Rg9HUN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+X+ddI8g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C4Rg9HUN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+X+ddI8g;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438664; a=rsa-sha256;
	cv=none;
	b=Y6+TxIpB6wtSqEj7HNs6u92W9maHxqovxsXYNw/owVhBdrxA1sSbJ69F8eVr5jfhak8k75
	ifg2iS0/gvhfunwkR2Yqu+tMKdB1qqVicne9d5Xmqr3dB//SRp0XCx4o3HWZ4aBKMNPan5
	ISoND/OVlV97OTYEwJdRhpNl44xVvhU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 220FD4D21F;
	Wed, 25 Mar 2026 11:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774438662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hGOiQCiQisXR76KhBKJZQggBhPWcoMLU1aMLzL81b4I=;
	b=C4Rg9HUNS37XMwgC1buZRhb+cZpQ+KfAKIsZ51mFhBlXSRM01/L4WBiUWJ696kDj3ALH/b
	caCS58O73Da+93fAQQy3WN0vIfz/AzxIa9dMHYlR9RaLVPSIafQaN8DXIDQc156B0Lf91G
	Tq+U8Sjf73P0znTxrJi4BN5hLgOTgKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774438662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hGOiQCiQisXR76KhBKJZQggBhPWcoMLU1aMLzL81b4I=;
	b=+X+ddI8gk6lPVHOUv0u8jJD4b89SDbcyTn/CXDXhOEbvcD7rl5CF+00kav3JbIVAQ8hFMS
	Haal6955sB83FIDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774438662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hGOiQCiQisXR76KhBKJZQggBhPWcoMLU1aMLzL81b4I=;
	b=C4Rg9HUNS37XMwgC1buZRhb+cZpQ+KfAKIsZ51mFhBlXSRM01/L4WBiUWJ696kDj3ALH/b
	caCS58O73Da+93fAQQy3WN0vIfz/AzxIa9dMHYlR9RaLVPSIafQaN8DXIDQc156B0Lf91G
	Tq+U8Sjf73P0znTxrJi4BN5hLgOTgKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774438662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hGOiQCiQisXR76KhBKJZQggBhPWcoMLU1aMLzL81b4I=;
	b=+X+ddI8gk6lPVHOUv0u8jJD4b89SDbcyTn/CXDXhOEbvcD7rl5CF+00kav3JbIVAQ8hFMS
	Haal6955sB83FIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CC8A4439C;
	Wed, 25 Mar 2026 11:37:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8bJEEwXJw2ntFAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 11:37:41 +0000
Date: Wed, 25 Mar 2026 11:37:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-ID: <dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
References: <20260324154342.156640-1-pfalcato@suse.de>
 <20260324154342.156640-3-pfalcato@suse.de>
 <fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: EC4A680008
X-Stat-Signature: pdj6zp7ouj9xc59i7bgrten796uc143p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774438663-736518
X-HE-Meta: U2FsdGVkX18oa1+V7CA+6TJBu5F7Bzz0luIIf+btbZwdtHoLyIhRJ7eD/FTTFJr4vPJuE/YqYNLoStD5TNm5qy/pEpfy7yiRaUOjOt5//uK/XJMgOUaMuwHGoqIyBJECdkIODvmpzNKXffacSHTQGGnuDTa2d2/hhJRLUXnveBAr2PJTr1MX4eHQjWdec/MPVYp2UjsfEavmVON1nFAlWTzsJ7YYWwmWuDsWu1Xt4XuN7PlEDg5qTndfAp5svaZZccWmCeawh+/GBmmCxxhQyR4ONf6kwd9VoYaIla2ojRdie5xe9GfMA2zsXr6cd/494oTRjY4Le6wyNzYlz3OtjQxZiKYN+VGQUejLmXDHiUM+pbJWfG+WnUx7p2SgPUao3k9PIIzMMMT+WdZQqVcTsB/gzjDvo73T42/H9hRVMXqOSNYXATq1sbngGi7D2IBy3POT2duLHtBF3r/cxUvGdmsZ635kOO4gdsqastiAY69G4me/i9gojn3utt0YHr6w2mbkYayUefbm5sOk71MKW4zXPWKIR5NDx97dlU0QKkvaKzWDVW1OipklbQHzlVOdGOo/PeaoRZI+4sjZ0vkcKZtqVDyQrsWk3Xan1WSdxfszgU7QFYJaEm3CA29cgVFgMYWbJ331GWQFBns10iC7CQpppYkempKHPfLztE/GftTMGycHzfOY/+k42wyoULrTEBbF3d9qCf0Llt7FgSG8Yt9lnUNBxEOQYtPvhf9djq+C6F30bi7tCA+yVoxcv3NkIdr9Uruq1DbSqWbLdF6TRc2BTyEJYNLNW8T+gjHdk+4/8VdbKXG75A/sZt154XoUcsLT4R+X79Coa9YL32qKUozNYchsdEzjBeJ/mc/3e/STm09w+5MHnxQPzK67kWAM/+NOXoKFIWyB9ub9+4oU5e+fxlazAbALN7QArjhfCnX6Zv99O5KLGdI51KbBWx35D/RwVmPOp87zC4RbMGd
 CdJrdsX3
 CNDnUvI/jDYrpKzGR7xMyqNtMax62HxsXtTkhHQScus5mDpOqOHIcnVcr0SUWCok/YllUQf6mFc3CRCHCEtqFDRJu/5s/Y7LsAElODJdWDHR62yfRQcjBIHGAKkLLkWe2SDIfvE0ylRGYDvwtlykzhGQICaYqDBPyU1lyEoHhSDkb8YGJQ/CDvsQc82RIMUPR7Jjmly4p57yQ2xorraoi/BpQ08HC2+ULa25klkRAnw+BWQ7Dda7zKL2hE1AIjoVQlbHAsJ8fHgL15EMEBf4ySE9n3jXViK04LKcLqg6D/Kzo4JOy8f2dN68QZjCcqK1fNi1U3usMWmfW4vpGYx22JlfAocxVFfOPOGfvzKFBmPtOnbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:18:42PM +0100, David Hildenbrand (Arm) wrote:
> On 3/24/26 16:43, Pedro Falcato wrote:
> > The common order-0 case is important enough to want its own branch, and
> > avoids the hairy, large loop logic that the CPU does not seem to handle
> > particularly well.
> > 
> > While at it, encourage the compiler to inline batch PTE logic and resolve
> > constant branches by adding __always_inline strategically.
> > 
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  mm/mprotect.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 2eaf862e5734..2fda26107066 100644
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
> > @@ -177,6 +177,13 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
> >  	int sub_batch_idx = 0;
> >  	int len;
> >  
> > +	/* Optimize for the common order-0 case. */
> > +	if (likely(nr_ptes == 1)) {
> > +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
> > +				       0, PageAnonExclusive(first_page), tlb);
> 
> To optimize that one, inlining prot_commit_flush_ptes() would be
> sufficient. Does inlining the other two really help? I don't think we
> can optimize out loops etc. for them?

Well, I'm getting meaningful (smaller) wins from adding those
__always_inline's. (and I also get a small win for __always_inline on
set_write_prot_commit_flush_ptes, but I didn't realize that until now).

> 
> I would have thought that specializing on nr_ptes==0 on an even higher
> level--where we call
> set_write_prot_commit_flush_ptes/prot_commit_flush_ptes() would allow
> for optimizing the loops entirely for nr_ptes==0?

That could also work, but then set_write_prot_commit_flush_ptes (holy cow
what a long name) would definitely need inlining. And might be a little uglier
overall.

This is the part where having data points other than my giga-fast-giga-powerful
zen5 could prove handy :/

-- 
Pedro

