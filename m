Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B01EF54AAC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363796B0005; Tue, 24 Mar 2026 09:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314616B0088; Tue, 24 Mar 2026 09:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229F06B0092; Tue, 24 Mar 2026 09:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11FF26B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:06:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EE061A1C01
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:06:13 +0000 (UTC)
X-FDA: 84580979826.30.0181A6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7047E20018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:06:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNYKshda;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774357571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PclSF+e5m3HOI/77X/kKCcELDI+BncV1vcd5P5GvAx4=;
	b=eUkg1r1jhylPkki8q4MauW+o5rRAPYjFmyudygoGCVf+jkoG2+/mdwL/7UJx4e64Ha2tC4
	75rxgvl+slsQdUe5mpuugtJT7Gd4Sx+FTOs5QxB+9wOeI8SE3lHbEfmUYPuW0HxwT7ZT+Q
	d04QYMtH8nqPvT3CtsIja6FXsLj0aKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774357571; a=rsa-sha256;
	cv=none;
	b=nUDLQ7xGP5VShJbM3c89YwszSbEfnfQ2RhUUNMJpMeIiO7FBzsXZnNpuNQ9RzRQG/WbZdL
	n/DHoBdwpFchqdPPxHI3HsVF9UKtkIgABU0t1HpknMnRL7g6I+5neojjpdbkp6KYn8WoT0
	3RB2GloDHQ2TQkQQP9GpAHNVBiNkSXc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNYKshda;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B54E6013E;
	Tue, 24 Mar 2026 13:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A834C19424;
	Tue, 24 Mar 2026 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774357570;
	bh=8rcDyIN+xZZA1K+s4yT22XlRva6FHC9pay+S/RPhlFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HNYKshdaujlpEtGHRAtBqhXsY7aOrmrWGQYTcL9os8Ursdw25aQt3PQ/eI4LMIexF
	 4Wi2AXrlo8oRqIuqMb6uNLDS65KMGaWBSi9Miqcwxj0EtouNnxEm3qCnhA8oqc0DX8
	 WP84lR5B7GbjdP/VkDuT63LwSYH3VLKkyPK/ILUz9x9QmyaCSnqbXKnU1R3KUIsbha
	 t0crLSoIAScUivK/IGeRMM3eYJzH+/uLJyb2BTDPvXJ8SsA+Fk6wcaExXFT5djpue6
	 134Chwad+ilrXP3ZG0WH2lfW45g+wL+FtsrAwIqpkLZzZXHNuIRCJjXdE9LfMJmaTL
	 8vW+Of+IUlRLw==
Date: Tue, 24 Mar 2026 13:06:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, Alex Williamson <alex@shazbot.org>, 
	Max Boone <mboone@akamai.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
Message-ID: <132009fb-70d4-4e3e-98a9-fcc230dd282e@lucifer.local>
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
 <b3b78722-c265-484b-acde-3aa4bee0aac7@lucifer.local>
 <43cc2290-10b6-4db3-bfc0-169adb8201b7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43cc2290-10b6-4db3-bfc0-169adb8201b7@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: no1i4hy98kqo5soyh6msuuqx15gmomwq
X-Rspamd-Queue-Id: 7047E20018
X-Rspam-User: 
X-HE-Tag: 1774357571-714412
X-HE-Meta: U2FsdGVkX18yCYReDTW/vvjftqtDpGRpEsznHC46eQ7LcnSxGgqY6Pr75ym9Kl8HfVJsQbL9qWwsd4DWygHNGhcp9YdOyi6d1mZcxKteRwOZbJbK6w2gr/rnF6rhdQ8D/ME4kRFKY7Rqqike4ZGuu7rkuiKGHXElxNAOJ9gFearWPF48LW9TowZ5a+3Gs7GGevKUF9PwyXlSaz9kAJ4mU2Ry7BVZDGMCxmxV7lNgxzH5aOcjAA2LRbdhk9xdbo6ZqSaEflWOp9IWj4PN2GesZa1gHY5uIonwYSb6rM1Su+XFPIyt1zWbHLumJTBHuMJkFP3el1oLvV3mJyqATEARRfdjnd436mUdB0NwjgQ4sjvguPpNcswkbUs6YNEk/GtHuixSJar4OH29vlogzuHO5tr/MlgZCTA4w+vMqzKc8iXa4GDpkPSyWyVA9gaHeQPeq4ps+Fx71W1zt7quZUV9LJ2ORTnpu72FPm33WpyyGk4gWP44CX0V9ekYhSUKMIHTtT9mnrQgRBKEprIB8UKzCRD3wzuc1MpECdqQPgl1oKRnusZCcJMbFUwDrWKCBWSiCFIYiQ6LoAXHZ12o2U0L1k5aj6pxt/OM9ZhFXgeLW/oy0fexK8zMY9z7XhQaWxtIX0514eQXo1hmrv4YPKotRw+5Mdwubv8nRkz7Wghn9F5CNVeVnzmP3MDNlhTvEPm8ZXHkQX/sJhDF/JAyBZ5o2EoNVnR7jXz5Pl98UVoKAraLaCrratOzjayLurPZwXQFyHxSCcJLApaETRGStEpF6hN1MiwseVsEGlj4JCScebcvhY5nZU1hs30btQJ7HnCpBoz0DtWbRiwWk7X5beE7RGAm4p0k17+qGlB+4vHHurjQhycN8Kpo1c/4huap2lX0nfgrwQjv87X17Q0bUun366Uw9AoTPH2KUsuFRbUBRSFtztHgV2PWPJHHJRKG7qe6GpZGQvmnn01GWhw1Mh9
 iObJyA1d
 eEcOaQRD1cvYse4GIwARiutc695usbXj/mQko0Ts6PU6fIBoDW/aquLWxB9vrpik5QEH/NX9Wx5P9d8GoFVt4ch3hBD0bC7pWiOzrqPYa3oiLPnqTlACPIwqdvWnnI65/Q7dNnJFEB9FPT6AdEfOENajLoMo4bCE31ZX2iWFa6O2u5G1y4CKpG5O2t7hud7g/ntBdJbh3DnQ/SPwbF+0JVug2C2Is7rP6+zAj97zepxkqWTLGLvgsMxUYTMJsFgMDZeREUC8fmymf+X/vquAdDZPWORv1d2rUtr7K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:46:20PM +0100, David Hildenbrand (Arm) wrote:
> On 3/24/26 12:04, Lorenzo Stoakes (Oracle) wrote:
> > On Mon, Mar 23, 2026 at 09:20:18PM +0100, David Hildenbrand (Arm) wrote:
> >> follow_pfnmap_start() suffers from two problems:
> >>
> >> (1) We are not re-fetching the pmd/pud after taking the PTL
> >>
> >> Therefore, we are not properly stabilizing what the lock lock actually
> >> protects. If there is concurrent zapping, we would indicate to the
> >> caller that we found an entry, however, that entry might already have
> >> been invalidated, or contain a different PFN after taking the lock.
> >>
> >> Properly use pmdp_get() / pudp_get() after taking the lock.
> >>
> >> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
> >>
> >> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
> >>
> >> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
> >> reasonable on non-present entries. Most architectures indeed either
> >> perform a present check or make it work by smart use of flags.
> >
> > It seems huge page split is the main user via pmd_invalidate() ->
> > pmd_mkinvalid().
> >
> > And I guess this is the kind of thing you mean by smart use of flags, for
> > x86-64:
>
> Exactly.
>
> [...]
>
> >
> >>
> >> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
> >> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
> >> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
> >> do that.
> >
> > But pmd_present() checks for _PAGE_HUGE in pmd_present(), and if set checks
> > whether one of _PAGE_PRESENT, _PAGE_PROTNONE, _PAGE_PRESENT_INVALID is set,
> > and pmd_mkinvalid() sets _PAGE_PRESENT_INVALID (clearing _PAGE_PRESENT,
> > _VALID, _DIRTY, _PROTNONE) so it'd return true.
>
> pmd_present() will correctly indicate "not present" for, say, a softleaf
> migration entry.
>
> However, pmd_leaf() will indicate "leaf" for a softleaf migration entry.

Right yeah that's true. By definition softleaves are non-present. But as they
are leaves, you'd expect pXX_leaf() to return true.

>
> So not checking pmd_present() will actually treat non-present migration
> entries as present leafs in this function, which is wrong in the context
> of this function.
>
> We're walking present entries where things like pmd_pfn(pmd) etc make sense.

Ack, makes sense, thanks!

>
> >
> > pmd_leaf() simply checks to see if _PAGE_HUGE is set which should be
> > retained on split so should all still have worked?
> >
> > But anyway this is still worthwhile I think.
> >
> >>
> >> Let's check pmd_present()/pud_present() before assuming "the is a
> >> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
> >> table handling code that traverses user page tables does.
> >>
> >> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
> >> (1) is likely more relevant than (2). It is questionable how often (1)
> >> would actually trigger, but let's CC stable to be sure.
> >>
> >> This was found by code inspection.
> >>
> >> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > This looks correct to me, so:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Thanks!
>
> >
> >> ---
> >> Gave it a quick test in a VM with MM selftests etc, but I am not sure if
> >> I actually trigger the follow_pfnmap machinery.
> >> ---
> >>  mm/memory.c | 18 +++++++++++++++---
> >>  1 file changed, 15 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 219b9bf6cae0..2921d35c50ae 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -6868,11 +6868,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
> >>
> >>  	pudp = pud_offset(p4dp, address);
> >>  	pud = pudp_get(pudp);
> >> -	if (pud_none(pud))
> >> +	if (!pud_present(pud))
> >>  		goto out;
> >>  	if (pud_leaf(pud)) {
> >>  		lock = pud_lock(mm, pudp);
> >> -		if (!unlikely(pud_leaf(pud))) {
> >> +		pud = pudp_get(pudp);
> >> +
> >> +		if (unlikely(!pud_present(pud))) {
> >> +			spin_unlock(lock);
> >> +			goto out;
> >> +		} else if (unlikely(!pud_leaf(pud))) {
> >
> > Tiny nit, but no need for else here. Sometimes compilers complain about
> > this but not sure if it such pedantry is enabled in default kernel compiler
> > flags :)
>
> You mean
>
> if (unlikely(!pud_present(pud))) {
> 	spin_unlock(lock);
> 	goto out;
> }
> if (...) {
>
> ?
>
> That just creates an additional LOC without any benefit IMHO. And we use
> it all over the place :)

Yeah I think the argument is you don't want to imply that it could somehow _not_
be else. But I think it's the compiler being a wee bit pendatic... :)

>
> In fact, I will beat any C compiler with the C standard that complains
> about that ;)

Haha, I'd like to see that!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

