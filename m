Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACBCE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 12:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327036B0088; Thu, 19 Feb 2026 07:15:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D53A6B0089; Thu, 19 Feb 2026 07:15:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C5D6B008A; Thu, 19 Feb 2026 07:15:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0486D6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:15:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71C131C199
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:15:16 +0000 (UTC)
X-FDA: 84461101032.19.A15220F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C1B040014
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:15:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lVSZXCFC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TSDvSAHV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mPeuNfQl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O051G0Ew;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771503313; a=rsa-sha256;
	cv=none;
	b=2eKG4F7Jn5GTrZEK8KuhIIWtisuC3YaaX7+ocP2aEmCbahWxbsXrRSGO2oNd93yrmGU8cn
	QYu6bSGPZktV9wh+xgpBvphO2sCNx7FEfbyps6/L1mUn93lkQNEIJ5FO7sHqvZ6dapMpBJ
	rmQZKExE7gGX/SvUNsMuJOlOFcL9tno=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lVSZXCFC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TSDvSAHV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mPeuNfQl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O051G0Ew;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771503313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRigAImyjDZChEnrcuB3IZZMiALE3/N4AR5Xw/jYMRk=;
	b=3grkmiT09hhGFkVR5JRzPjC2V/7SYGu7dyHPOaKvHhU4FeFJxl0Az6l+QuDzwziQTyG1/G
	n2v98DTz+A3GuFQQJTwVr5iFq99+i1NFQX/R7UM1GerYn7iChHUnGmuatK1dyutjdTeZ0x
	XzRY5kHUngb81JaBzCMjbqlAr3bmmjE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EB6815BCC9;
	Thu, 19 Feb 2026 12:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771503312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRigAImyjDZChEnrcuB3IZZMiALE3/N4AR5Xw/jYMRk=;
	b=lVSZXCFCtnmMIt0yuktS+NKNFxY+VTXYK+mayGAjpWx0shi+Sf1iDMz86Nu4/9i0rImjdm
	6f1Z36jI/WSFOHbSvIWRn8d9jkq40hgsm/9aI0q9SRufHik1nT0h9+c4inrEAsnIbNKlL+
	5auB1zOXP2bXx2p0J/XEHP1dlJbk26Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771503312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRigAImyjDZChEnrcuB3IZZMiALE3/N4AR5Xw/jYMRk=;
	b=TSDvSAHVtw0qT+kKJ7Ja5O1UNoiWQpApZWF7B32NOCpbaCWe0XF3xHNZvsTe8Is3rToMa6
	Bmdm5IlPx1PJa9Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771503311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRigAImyjDZChEnrcuB3IZZMiALE3/N4AR5Xw/jYMRk=;
	b=mPeuNfQl4e2oK7i8aPwz1BTgLBhf6QKQ8t1+ExGyoTU4t5Htc+oF/KuykNhFsAMKL3zVyp
	U7PCKAsxe3T59fK6lhy7FSNF0Sosd4oQyJJBYpRsTKw83O69f4o2QOBTvSqUjxeOpSbmIn
	68QT4b5E8EU85ewA8v+HUJtZFc60jtU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771503311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zRigAImyjDZChEnrcuB3IZZMiALE3/N4AR5Xw/jYMRk=;
	b=O051G0EwOWndd5ES1ttxEF1x6LD6JStl637dc3FoOKkZLoTtWeSlVpq0zZVu2zNQfaTy36
	7DaQaYSKanLoZgCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E05733EA65;
	Thu, 19 Feb 2026 12:15:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HDh8M87+lmmkYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Feb 2026 12:15:10 +0000
Date: Thu, 19 Feb 2026 12:15:09 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	surenb@google.com, jhladky@redhat.com, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <r2b2cjuqicmrw3zdwruacpelulhjhfdawrtbgzph5vsf6h5omj@dhrga7p62hju>
References: <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
 <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
 <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
X-Rspamd-Action: no action
X-Stat-Signature: dzyue7o7fiwd43hzaj1n1fo38o8ekzbw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C1B040014
X-HE-Tag: 1771503313-416876
X-HE-Meta: U2FsdGVkX1/TGC0bEKWG7R6Z7feZYKR5VdDF42s1+suixzImSotRWq23vFyaClI4QGM9STvZOaXvCRZ9JUbcXOKaIAq+3hmuMZJfcyS8B8vciPhXLrWrTldX7v+QMU53Bbjbpb0QCrP7lQTWL8oWwDvKjH6R2NG2SxllMFhChi+Rr73f4NQJaQqpf7VReGagPlNJgEm5psSbTg+/4M1EMrseH6K8iEVjhEcPmbpRuk5dxedmFi8VsUwmYmUBhFOw63psvbsOYEIjb0vNgYnb3MZmPEIrLId7fwoSGfTXJQjY8O0zTW7zD/ttuwpaL7in/vIuV86c2F0aQ6tU0loQph+NHZmkBwVAP5BmLUycHEgNeVkYMOylNiGorFRRQcd1A9b9SGfp3vAGOTzuup5p+s0HKbeQqfzaXY5Adu3eOOslHAardqvxP+SFeHB+EU0ma28dEgQEYvHOB4DoWbMI7ThI4kEZDteBMCI86rWI2lMbfFP8MFQ+6pJX7GlC+m5z5KVNBBEvV0o5sI5yl+GEVU1Di82VyZgA8hRunC4L8/La7LPsoq5mYrJFLOHCX3kn+ALVHKgMKICuNU+O1XZvyvcCz/XVrV23UHbP9fLXeyldYYLkJNpgnmcP9f/FiK8Lfn50GVHGnO1eOi7lVUKckd43hod3ljQK34NSxBjIDSe7HyK918qxHn5MbOysvVHSgiR9ADoEu5UOURmVfzhw0zkxws3rfTxytg1MBO6+h6y7693kBSeI79UONKwXFuP/xj0FSV5Dv5wR4vtacCcGE71ZSkQ8lTs6VKGjSB4svJfdA/QUewXl/urrTSlM5QP9UzkJp6RHs8PLLkc4Ha+9btFQyCD4wJ+k5bEBTZ0+ZSnUg0u1tNJBvUtPxyQ172Um/duf5P2FaZEBciN5KucRNXLuL9vJdj4sFm/YY4HcOIupWCtTamQptMW7FUGR7ICb7FuLUvSeQaiIINEFBXn
 erxtGaaD
 FUewD0ZOt8iECMbH5GQYKIsn3BkS5llhwMj3qlnMvTkpFT51Ci3AdwUrl9xzeIUHxVHMTx45x8ShQUQ8HOdB44NO7hV4AN4F6LM522bO8TKVdvtC60qxvQJ7LYi1Tf/kCoY+lr31ZePq+S5jFokXQgXFBsgmsHnL3bK03wFD/zkNn44Ri30DG56omLWVRHpNKvI/LuOgygkisOTfw25EAZeaTJ3QUmr2vDqXpQj1hEGAcJFGdOKLlLf3wikRstnmFY0ES/DsQeQArlKvkrHZEYF+sZXzVd56qhENL4v9cbwsVyKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 01:24:28PM +0100, David Hildenbrand (Arm) wrote:
> On 2/18/26 12:58, Pedro Falcato wrote:
> > On Wed, Feb 18, 2026 at 11:46:29AM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/18/26 11:38, Dev Jain wrote:
> > > > 
> > > > 
> > > > There are two things at play here:
> > > > 
> > > > 1. All arches are expected to benefit from pte batching on large folios, because
> > > > of doing similar operations together in one shot. For code paths except mprotect
> > > > and mremap, that benefit is far more clear due to:
> > > > 
> > > > a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
> > > >      Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.
> > > > 
> > > > b) vm_normal_folio was already being invoked. So, all in all the only new overhead
> > > >      we introduce is of folio_pte_batch(_flags). In fact, since we already have the
> > > >      folio, I recall that we even just special case the large folio case, out from
> > > >      the small folio case. Thus 4K folio processing will have no overhead.
> > > > 
> > > > 2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
> > > > across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
> > > > it becomes critical to batch on arm64.
> > > > 
> > > > 
> > > > 
> > > > Nice.
> > > > 
> > > > 
> > > > I dunno, need other opinions.
> > > 
> > > Let's repeat my question: what, besides the micro-benchmark in some cases
> > > with all small-folios, are we trying to optimize here. No hand waving
> > > (Androids does this or that) please.
> > 
> > I don't understand what you're looking for. an mprotect-based workload? those
> > obviously don't really exist, apart from something like a JIT engine cranking
> > out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
> > usage of mprotect that our DB friends like to use sometimes (discussed in
> > $OTHER_CONTEXTS), though those are generally hugepages.
> > 
> 
> Anything besides a homemade micro-benchmark that highlights why we should
> care about this exact fast and repeated sequence of events.
> 
> I'm surprise that such a "large regression" does not show up in any other
> non-home-made benchmark that people/bots are running. That's really what I
> am questioning.

I don't know, perhaps there isn't a will-it-scale test for this. That's
alright. Even the standard will-it-scale and stress-ng tests people use
to detect regressions usually have glaring problems and are insanely
microbenchey.

> 
> Having that said, I'm all for optimizing it if there is a real problem
> there.
> 
> > I don't see how this can justify large performance regressions in a system
> > call, for something every-architecture-not-named-arm64 does not have.
> Take a look at the reported performance improvements on AMD with large
> folios.

Sure, but pte-mapped 2M folios is almost a worst-case (why not a PMD at that
point...)

> 
> The issue really is that small folios don't perform well, on any
> architecture. But to detect large vs. small folios we need the ... folio.
> 
> So once we optimize for small folios (== don't try to detect large folios)
> we'll degrade large folios.

I suspect it's not that huge of a deal. Worst case you can always provide a
software PTE_CONT bit that would e.g be set when mapping a large folio. Or
perhaps "if this pte has a PFN, and the next pte has PFN + 1, then we're
probably in a large folio, thus do the proper batching stuff". I think that
could satisfy everyone. There are heuristics we can use, and perhaps
pte_batch_hint() does not need to be that simple and useless in the !arm64
case then. I'll try to look into a cromulent solution for everyone.

(shower thought: do we always get wins when batching large folios, or do these
need to be of a significant order to get wins?)

But personally I would err on the side of small folios, like we did for mremap()
a few months back.

> 
> 
> For fork() and unmap() we were able to avoid most of the performance
> regressions for small folios by special-casing the implementation on two
> variants: nr_pages == 1 (incl. small folios) vs. nr_pages != 1 (large
> folios).
> 
> We cannot avoid the vm_normal_folio(). Maybe the function-call overhead
> could be avoided by providing an inlined variant -- if that is the real
> problem.
> 
> But likely it's also just access to the folio when we really don't need it
> in some cases.

/me shrieks at the thought of the extra cacheline accesses in the glorious
memdesc future :)

-- 
Pedro

