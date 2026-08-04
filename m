Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B635AC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56126B00E9; Tue,  4 Aug 2026 09:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04F76B00EA; Tue,  4 Aug 2026 09:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CDD56B00EB; Tue,  4 Aug 2026 09:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69DAD6B00E9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:54:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A31AFC0156
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:36:35 +0000 (UTC)
X-FDA: 85063535550.23.AB62AFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 042E340006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:36:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORP7X7FL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785846994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+aWhgjbLFPF3M3Lo6UG42o4nY0PiujohVeWyhVCd1k=;
	b=YEESwbYU+Do7IOPRu4/jRF/ZLDG6D6WZiromAYKnOozoHMU6+ld3Qi3QwhSDbWaOJaq9zw
	jBFzIrZtCKlm61D2OaGOsJIKe4qCi+JR/aEufQMHaQmlOTerRU5omaVb+fugduM95XhwnI
	NUkON5Zz9CNveXOfS4IaZMLQA0zJbS0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORP7X7FL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785846994;
	b=S9KELO7Iuq9YNBAO1Kswon+i8dyc58BcJvEt5uH1YRhNL9V9n7Epq7sLdF2gvu1ZtgqIqN
	0N7N3cv23ybhdwY4bR98R9UYwVen5O8Vvf4clOZxBy4qFt3OiBwc134X7lT50CrxcYgSZL
	rWdE7JXWbdPnpc641NQBA/H1FdtBtP4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8228A60A59;
	Tue,  4 Aug 2026 12:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B571F000E9;
	Tue,  4 Aug 2026 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785846993;
	bh=D+aWhgjbLFPF3M3Lo6UG42o4nY0PiujohVeWyhVCd1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ORP7X7FLuukUKyHZC2hu7ST64c4bBK8dth7FcFgWGlPF+MqYiPEqS/FRnFJTUzDxP
	 VLZ9wlQWn/76khNTD8oRfJmFkWuHqaqxM+nH5Lv45e0Q+zWDr3DRu66yIzzLk8tJqc
	 HDMar3TURxk8UX3VJJlGaVa5osL9+S2aplFUgueI2ab6X4nCF4/rZrBptrJDMuU7we
	 Kg55c4T/MKl7KtaHDLaTXEeFMz4BKAQl9sWd2u3OExD6HAs/RcsKWeFJBmxaewyQs2
	 TozwcPFUZsuD1bjCgbUCCZJJCs/ryLvBmeT7OvFTX3kBhZTlatnqji7kXywFzOFlfd
	 e39YHKZmeqduw==
Date: Tue, 4 Aug 2026 13:36:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
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
Message-ID: <anHb4hiTeSMoMKjB@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-2-pfalcato@suse.de>
 <anG2V7KpvIHjNyVq@lucifer>
 <anHYoPMRt8hr1l8m@pedro-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anHYoPMRt8hr1l8m@pedro-suse>
X-Stat-Signature: b7ps88yj6ocpyn9pguq49b3m5izdu1d4
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 042E340006
X-Rspam-User: 
X-HE-Tag: 1785846993-7669
X-HE-Meta: U2FsdGVkX1+TeVGQyuPPPPAi3mIP+Xc+yTz+YtTmaLdXK5/5QAQWZqDVPOeJCRrf7VP6dH2pBDrHIwKVeC6eavUtpl5qZMCLFoD8uR04d4xKzawyZh4pDpKaBTzW+2bOkVL3BeCl0pEzB0MY7aL8YVk6xPZs9NR85Z4ncfNn1KSmTvNwWf5u9QgbdZxKzJkrDkldv9s6Js2iLV42Ru8qiMjq6uTGWsEMOl4dyv+ffNejmTy5dKisrHMPEs45Y1x0PN8MVzQXS6+uyuy3+ohP/RIloGekOUgqfygdodaL7RajpSUAhPpqOmvFYtRidumC2tcXqr52442uQuKPWr7mHnisf+7NOuqBPbTL9qoqLRmdF5oZuHD1e5iaEVl7sqXfhfj02a7MDC0jyWRWo4p0fMzgu60Rs3it7cO4NtlKdGaBU57xRptQMMdr+hs+JMhfgFMduOlkFcPaYw67SgNCoA68etYGv/FfCebw1gdKOeII58V2ckJhcaWhKPl0Eix6KMzD1VJ8NOTgEx83Q3LvbjglUL6Se6+UPWeu0R/j/wWNrRJdysdob6MMqCT71nAkY8hGYjSKvQs0yEIzI139/k/68OUDbQ7WhCr+sujF0Q4l3N/Dh6bQPMB8OKXBs+HIvx3gwwYpQOwMt4TjxIZqi5r1Rj/Ifu52L/IFGZsv/oqdkoZleqikRsst2AQYdUuwGOq+hX/8ugABAUjvW//vjiK/UYoKEoNsWFOeXGNTYbN4EJeXP/y8w+kDjRgVpnlDCvI15ugD+dyfaWVPMlYujKKKSgvmZzRBi+eEYV3mDHYOeb27ypjR4+obgEo5kKlolXaQdeG4iTAjgHNuZMurOTYZf3q/tcxdd7nukPMgzM8BsIussrBPXInQwVq0VXXXxBGKI1LgAtNJe1kGItkoxhIdeNObGCLQPjw3Vqz01F/29ZHgOE1hL4R2JD+53kABXAEHYFRYBsrvZJQ/fjE
 k4FTeZqs
 sqXdw0RG+d/PS4V8K7u/RCXkTMaPGKPGv86XFl1yTBxLG3DcskDsz8jk7ebkwkeGeRTJ4jQQMw+lGSJQdcMQFcZeW7Y+tl73G8SldGp89NGPjPDzNGwuGZAyAC6Me/dcfEae7klsxLjIguDJm699Bl/L/ItglmNrzHme15PZV7H5IQkKieHKMPl0TfP61rvdenPfm1+IK4bo5oUK+8ztxvS/0ofF0bK9UOTyimygBo7ffVPzSzfRP/Pf4wf1eqrNeYV0unLcWb4QCKtpb9lV3swxkQcBE7uVAOi0G733GSESZ04XQtw/vavu+OljFlWlcOKnc6DmcU1cENGS98YSn5LPQ2pQIDlwLTinW880K5MsV1dMCkQXxOvJGKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 01:31:04PM +0100, Pedro Falcato wrote:
> On Tue, Aug 04, 2026 at 11:55:09AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 05:43:55PM +0100, Pedro Falcato wrote:
> > > None of the contpte code needs write access to the PTEs.
> >
> > This seems like a very broad statement? Is that actually true? I see a bunch of
> > ptep's that aren't const-ified, so you should explain why those couldn't be
> > converted.
>
> ACK. FTR, I think it would've been far clearer with "None of the contpte get
> code". There is of course contpte code that needs write access (e.g
> contpte_clear_full_ptes).

yeah that sounds better. Maybe just something like 'specify const for read-only
users of pte *' or similar?

>
> >
> > Also you add a new contpte_align_down() macro, you should mention that it the
> > commit message, explain why it was needed.
> >
> > In general more needed here :) it'd be ok if it was a truly trivial change that
> > was all obvious but you're changing some pte_t *'s and not others so it's
> > clearly not.
> >
> > >
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > ---
> > >  arch/arm64/include/asm/pgtable.h | 10 +++++-----
> > >  arch/arm64/mm/contpte.c          | 11 ++++++++---
> > >  2 files changed, 13 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index a2681d755358..043bc0649cee 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -378,7 +378,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
> > >  	__set_pte_complete(pte);
> > >  }
> > >
> > > -static inline pte_t __ptep_get(pte_t *ptep)
> > > +static inline pte_t __ptep_get(const pte_t *ptep)
> > >  {
> > >  	return READ_ONCE(*ptep);
> > >  }
> > > @@ -1652,8 +1652,8 @@ extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
> > >  				pte_t *ptep, pte_t pte);
> > >  extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
> > >  				pte_t *ptep, pte_t pte);
> > > -extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
> > > -extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
> > > +extern pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte);
> > > +extern pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep);
> >
> > This is (very) nitty but - not sure on the policy on extern's (Will/Catalin?) -
> > but in mm we drop them when we touch the code since you don't need them these
> > days :)
>
> *nods*. For what it's worth, this is new code that never needed extern.

Yup, this isn't a big deal anyway :)

>
> >
> > >  extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
> > >  				pte_t *ptep, pte_t pte, unsigned int nr);
> > >  extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
> > > @@ -1732,7 +1732,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> > >   */
> > >
> > >  #define ptep_get ptep_get
> > > -static inline pte_t ptep_get(pte_t *ptep)
> > > +static inline pte_t ptep_get(const pte_t *ptep)
> > >  {
> > >  	pte_t pte = __ptep_get(ptep);
> > >
> > > @@ -1743,7 +1743,7 @@ static inline pte_t ptep_get(pte_t *ptep)
> > >  }
> > >
> > >  #define ptep_get_lockless ptep_get_lockless
> > > -static inline pte_t ptep_get_lockless(pte_t *ptep)
> > > +static inline pte_t ptep_get_lockless(const pte_t *ptep)
> > >  {
> > >  	pte_t pte = __ptep_get(ptep);
> > >
> > > diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> > > index 2de12656b4d8..3a5d6937fb51 100644
> > > --- a/arch/arm64/mm/contpte.c
> > > +++ b/arch/arm64/mm/contpte.c
> > > @@ -26,6 +26,11 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
> > >  	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
> > >  }
> > >
> > > +#define contpte_align_down(ptep)                                                       \
> > > +	_Generic((ptep),                                                               \
> > > +		 const pte_t *: (const pte_t *) contpte_align_down((pte_t *) (ptep)),  \
> > > +		 pte_t *: contpte_align_down((pte_t *) ptep))
> >
> > I really hate these _Generic() helper things. So ugly. And it's a pretty horrid
> > cast now :(
>
> Me too!
>
> >
> > Was it not possible to const-ify further to just be able to constify
> > contpte_align_down itself?
> >
>
> You can't do that because some callers want a pte_t* out of align_down,
> others want a const pte_t* out of align_down, depending on the param.
>
> In A More Civilized Language(TM):
>
> template <typename T>
> T contpte_align_down(T ptr);

Now do it in rust ;)

>
> :P

Well as per below you can just avoid the whole issue with:

#define contpte_align_down(ptep) \
 	PTR_ALIGN_DOWN(ptep, sizeof(*(ptep)) * CONT_PTES)

And avoid this mess? You're ultimately calling into a macro anyway.

The generic thing Seems like a lot of hassle for an align-down, and then you're
forcing a macro and nasty casts anyway so I don't really see the downside of
just making it a macro in general?

>
> > It also seems to contradict the claim that contpte doesn't need write-access to
> > pte's since you're going to lengths to allow non-const pte_t * here.
>
> Yep, I'll admit the commit message is confusing and crap. I'll flesh it out
> here.

Thanks!

>
> >
> > You should cover off why this was necessary in the commit message as above.
> >
> > Anyway PTR_ALIGN_DOWN() is already const-safe so couldn't you anyway just
> > collapse this to:
> >
> > #define contpte_align_down(ptep) \
> > 	PTR_ALIGN_DOWN(ptep, sizeof(*(ptep)) * CONT_PTES)
> >
> > Then describe in the commit message why you need to handle both cases?
> >
> > > +
> > >  static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
> > >  					     unsigned long *end, pte_t *ptep,
> > >  					     unsigned int nr)
> > > @@ -310,7 +315,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
> > >  }
> > >  EXPORT_SYMBOL_GPL(__contpte_try_unfold);
> > >
> > > -pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
> > > +pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte)
> > >  {
> > >  	/*
> > >  	 * Gather access/dirty bits, which may be populated in any of the ptes
> > > @@ -367,7 +372,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
> > >  			pgprot_val(prot) == pgprot_val(orig_prot);
> > >  }
> > >
> > > -pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
> > > +pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep)
> > >  {
> > >  	/*
> > >  	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
> > > @@ -386,10 +391,10 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
> > >  	 * because it is not part of a contpte range.
> > >  	 */
> > >
> > > +	const pte_t *ptep;
> >
> > Nit but this is breaking the reverse xmas tree isn't it?
>
> Yep, seems like I mistakenly broke the coding style here and in the
> contpte_align_down macro above (the \ is misaligned). I'll fix it up.
>
> (I think Andrew isn't taking more material for next cycle, and while
> this should have no functional effect, it is very late and you have
> pushback, so probably no rush here...)

Yeah I assumed this was for 7.4 :) I mean the series is fine for 7.3 too AFAIC
(with feedback addressed obviously).

>
> --
> Pedro

--
Cheers, Lorenzo

