Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B706BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F3A6B0093; Tue,  4 Aug 2026 09:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6626B0096; Tue,  4 Aug 2026 09:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE61E6B0098; Tue,  4 Aug 2026 09:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9911E6B0093
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:49:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 822E3C0161
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:31:21 +0000 (UTC)
X-FDA: 85063522362.05.D9865CD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 606B7A000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:31:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=INOo8Pi7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KjTIjm4l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="OiI/ovxm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CyvccDZ4;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846679;
	b=ojQGW2GzFSvKcqKVwMlGCNT4lia2VeZ1lPJaBwZvNgAq5hqaeAEVPmuC2hlf9xB/n9mFf6
	LFqrndJs7TqHdGVTdygaJyv0dVWm47x4/bByowtvLlnA7hha3tB4W//7RWjCEy6NoT5FcS
	fJQpPhl79IQJLCJfbcS+N1aJXfctQWY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=INOo8Pi7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KjTIjm4l;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="OiI/ovxm";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CyvccDZ4;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLBRymNfVFWu6X+j8MY/IjaNlkgGacJIUxb7cW/jNJA=;
	b=XUY7afJ/lmOCuAfDx3v7hnn3nyo7ZdHUx+ZiTcFGjKev7aJgeulYCpXo48GI+WD8mvo039
	78uwlt47eGO3vPilgEIyAuZsS4B8QdpIhcdH49xlxzpR4xKrJsEChvsfQSZDDwYteF5nJC
	z37snAY9lSnzVaJKFPZ5ewtTc9uEpG0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 87484401B;
	Tue,  4 Aug 2026 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785846672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLBRymNfVFWu6X+j8MY/IjaNlkgGacJIUxb7cW/jNJA=;
	b=INOo8Pi7o9J+7NSiyKnmooZGGAiILIdyyA1IZW74eJ87AIS2aj6S4rUaa+NiSs6KzgmFsw
	2JhHsbVViOWZyumrkj31kKfmjn2zwRKVzAh0sycNKCdWVIKOYsOLKzulB+Pd8s9wpKz5Ds
	/RipcHhlu+wP6kCMrF6i8hRG8gtDCEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785846672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLBRymNfVFWu6X+j8MY/IjaNlkgGacJIUxb7cW/jNJA=;
	b=KjTIjm4l5Yb84upwgVb0oa05ddJforSKET8NJH6vs3hU0/bVfWoTA2jTORjsa73/BYUAsI
	D23B0UWuq+XgDFCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785846668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLBRymNfVFWu6X+j8MY/IjaNlkgGacJIUxb7cW/jNJA=;
	b=OiI/ovxml9BYqkGH3dllP2tLNwyqszuu9FeiJi6uw5gBrMvbDNbRAnsnbq9gZ9n7yFSoPF
	dsO74IWril+tl3szzYarowGo2sA3abzXFIMQ5QZNViflqLOCn6KrZFt+d1fxfgnuGMRWxF
	heMPgxCD0tK7Il4B3g3eW4zcclBh8VA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785846668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CLBRymNfVFWu6X+j8MY/IjaNlkgGacJIUxb7cW/jNJA=;
	b=CyvccDZ4aue95TSNHIZm7CxNGL3IYi/oPQ49q1miOPXmZZ925WrLiI675v2w/ko4+3de5x
	eEOo9/GqHjsYsRDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0183779BB;
	Tue,  4 Aug 2026 12:31:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uBDfJ4rbcWpOTgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 04 Aug 2026 12:31:06 +0000
Date: Tue, 4 Aug 2026 13:31:04 +0100
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
Subject: Re: [PATCH v2 1/6] mm/arm64: constify pte_get*() and contpte get
 logic
Message-ID: <anHYoPMRt8hr1l8m@pedro-suse>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-2-pfalcato@suse.de>
 <anG2V7KpvIHjNyVq@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anG2V7KpvIHjNyVq@lucifer>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 606B7A000E
X-Stat-Signature: 6udwwhojgp18h6zzuk991bu3rwqt5eut
X-Rspam-User: 
X-HE-Tag: 1785846679-923508
X-HE-Meta: U2FsdGVkX1/M+tJxbldEHX8XSvZcH4oBdipCW5/Qk0VKx+5PURwi9nFMEk59bO9wHXbQK/lQxhN94iXruRE0ePcuOqPGV9ZGLWhpVXa3rew0f1LOpPWjsaiJay+SPMvGmQk+Ae2bGmR7onxSxdfghI9tj+RBTQYnkdnPBbnpiZTFu7oGCubO3Pu2kEpT/srMOyucn7hB2MNLjX1I16q5eB7wZ1VbLTVJpuZYwuFomvI8zYYo+QCrZCHw6Mb5cDlEDIVwY5QHRjqoE+aY2pMoKO65rZ88RKQ+eoBl2b4e0HRCoRArPI5oRqtxlY5fR83XDo+NC/3tnfgn3roDFKQExRVB55LrekMAUBuinWKUQIwIIV4Ln4SND/6gaBKAqymRIGVZwJ89yJNiM919E7117euWP93GRSZ9FKB3/kWQLWNHvlh7BcJp9+CRV15BwfB6wJtQVaoe0kbqxX4EIKZh2dwufGGhbfIJDx0Q2I/WVrBsumOrKjOiq9xM0dmpfSbCLd2jbXcItuCo90EgYvfApOcTDDORPgMXH2Rvr0huZMJXbdmpGCRqksmuJd1/QQNqMK9Ka3vTgrRYMQYhg9fbuhchadXVQ1VIANuUW9BbOktSbv+e58+9OEu9kQTavKUM001NcvH3I0h6K95v6VLTmFFI5PrQz/MYnqnG7yoxKBGIK3uwfTaPbArQQsLe7fpICgWhy7xYfCr7dWUjjwU/3OvjqZgXYliLyRBTpUPWVk3RFiyNjth8Nsbj6RdDNF0Q5/+0qhfPo6feh2fdN1MkLx01DFBtGD5kDaDSLKrISHxSmGxUBV1wyqQ65Hw4S3dX62RTcastsyI19tDJTODmoYBb7aMFKqV2ocMHqH9eCc6aoSwCa9Ozkzz5ZX+jN94dl5bF2n9P8KbZmK4rN67n8LloKnyhXlvVIKylWQJANh2GgkFu0dl8H7PVRvNqTF/lx50pX0HCTuzvBD9g/W5
 fGgAIy4n
 7NHsPq/fSIlhqzscPT8AUlFVx8XL9pmqhgQ5G+olhbmYaC/p6UBCzD28F5KNUIiB9Q6fY8vJKec47S0fjo8hOn1gD4nVmqIrbk3YtQbTRXR1za90MOgMwRxS3ZoEA7uMNDpLh7BkgYozxPtL86or8WJTe3PPRwhMxrsJTwoL2YtQbSdlIEQb+ctO6dKT821gg/n2uqT7mtje7VpCdjoZJFLsJTz53HDhOJI5US/fCvRQq84+G3kCPoCqr+QoRpDxjHNeTSFyR32i70gKZJIxn+4KM0DCX0emX06ge/T9tbnNKVXomoDsqxcsGJh17Q3eoQaNneBOvyZPteFU3WhsV4P7hBDzA1QsooN4GAbfEy9J6ywrEkePV5vG4VaOzr7L6fQM8Rw0NEq9luZCBUb0IJPuby6aGxkbKCtr1wChkJ/aFR0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:55:09AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 05:43:55PM +0100, Pedro Falcato wrote:
> > None of the contpte code needs write access to the PTEs.
> 
> This seems like a very broad statement? Is that actually true? I see a bunch of
> ptep's that aren't const-ified, so you should explain why those couldn't be
> converted.

ACK. FTR, I think it would've been far clearer with "None of the contpte get
code". There is of course contpte code that needs write access (e.g
contpte_clear_full_ptes).

> 
> Also you add a new contpte_align_down() macro, you should mention that it the
> commit message, explain why it was needed.
> 
> In general more needed here :) it'd be ok if it was a truly trivial change that
> was all obvious but you're changing some pte_t *'s and not others so it's
> clearly not.
> 
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> >  arch/arm64/include/asm/pgtable.h | 10 +++++-----
> >  arch/arm64/mm/contpte.c          | 11 ++++++++---
> >  2 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index a2681d755358..043bc0649cee 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -378,7 +378,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
> >  	__set_pte_complete(pte);
> >  }
> >
> > -static inline pte_t __ptep_get(pte_t *ptep)
> > +static inline pte_t __ptep_get(const pte_t *ptep)
> >  {
> >  	return READ_ONCE(*ptep);
> >  }
> > @@ -1652,8 +1652,8 @@ extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
> >  				pte_t *ptep, pte_t pte);
> >  extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
> >  				pte_t *ptep, pte_t pte);
> > -extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
> > -extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
> > +extern pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte);
> > +extern pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep);
> 
> This is (very) nitty but - not sure on the policy on extern's (Will/Catalin?) -
> but in mm we drop them when we touch the code since you don't need them these
> days :)

*nods*. For what it's worth, this is new code that never needed extern.

> 
> >  extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
> >  				pte_t *ptep, pte_t pte, unsigned int nr);
> >  extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
> > @@ -1732,7 +1732,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> >   */
> >
> >  #define ptep_get ptep_get
> > -static inline pte_t ptep_get(pte_t *ptep)
> > +static inline pte_t ptep_get(const pte_t *ptep)
> >  {
> >  	pte_t pte = __ptep_get(ptep);
> >
> > @@ -1743,7 +1743,7 @@ static inline pte_t ptep_get(pte_t *ptep)
> >  }
> >
> >  #define ptep_get_lockless ptep_get_lockless
> > -static inline pte_t ptep_get_lockless(pte_t *ptep)
> > +static inline pte_t ptep_get_lockless(const pte_t *ptep)
> >  {
> >  	pte_t pte = __ptep_get(ptep);
> >
> > diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> > index 2de12656b4d8..3a5d6937fb51 100644
> > --- a/arch/arm64/mm/contpte.c
> > +++ b/arch/arm64/mm/contpte.c
> > @@ -26,6 +26,11 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
> >  	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
> >  }
> >
> > +#define contpte_align_down(ptep)                                                       \
> > +	_Generic((ptep),                                                               \
> > +		 const pte_t *: (const pte_t *) contpte_align_down((pte_t *) (ptep)),  \
> > +		 pte_t *: contpte_align_down((pte_t *) ptep))
> 
> I really hate these _Generic() helper things. So ugly. And it's a pretty horrid
> cast now :(

Me too!

> 
> Was it not possible to const-ify further to just be able to constify
> contpte_align_down itself?
> 

You can't do that because some callers want a pte_t* out of align_down,
others want a const pte_t* out of align_down, depending on the param.

In A More Civilized Language(TM):

template <typename T>
T contpte_align_down(T ptr);

:P

> It also seems to contradict the claim that contpte doesn't need write-access to
> pte's since you're going to lengths to allow non-const pte_t * here.

Yep, I'll admit the commit message is confusing and crap. I'll flesh it out
here.

> 
> You should cover off why this was necessary in the commit message as above.
> 
> Anyway PTR_ALIGN_DOWN() is already const-safe so couldn't you anyway just
> collapse this to:
> 
> #define contpte_align_down(ptep) \
> 	PTR_ALIGN_DOWN(ptep, sizeof(*(ptep)) * CONT_PTES)
> 
> Then describe in the commit message why you need to handle both cases?
> 
> > +
> >  static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
> >  					     unsigned long *end, pte_t *ptep,
> >  					     unsigned int nr)
> > @@ -310,7 +315,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
> >  }
> >  EXPORT_SYMBOL_GPL(__contpte_try_unfold);
> >
> > -pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
> > +pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte)
> >  {
> >  	/*
> >  	 * Gather access/dirty bits, which may be populated in any of the ptes
> > @@ -367,7 +372,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
> >  			pgprot_val(prot) == pgprot_val(orig_prot);
> >  }
> >
> > -pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
> > +pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep)
> >  {
> >  	/*
> >  	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
> > @@ -386,10 +391,10 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
> >  	 * because it is not part of a contpte range.
> >  	 */
> >
> > +	const pte_t *ptep;
> 
> Nit but this is breaking the reverse xmas tree isn't it?

Yep, seems like I mistakenly broke the coding style here and in the
contpte_align_down macro above (the \ is misaligned). I'll fix it up.

(I think Andrew isn't taking more material for next cycle, and while
this should have no functional effect, it is very late and you have
pushback, so probably no rush here...)

-- 
Pedro

