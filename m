Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BA1CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FE48E0003; Tue,  9 Sep 2025 07:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2679C8E0001; Tue,  9 Sep 2025 07:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A49F8E0003; Tue,  9 Sep 2025 07:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07C5D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:39:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DACC1A04A6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:39:09 +0000 (UTC)
X-FDA: 83869515618.17.358D636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09493180011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:39:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/NzefE9";
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757417948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSHM1uPWR8fy7VAmc9jztm03jndbJ33KDubuQGilYCY=;
	b=0hsQkxXLL/zt707QWyjBtZfBXEXzdauxHA1AyelRrttCAS0KBxQ/9SS6ATtdeT77tT7pWI
	f+IaRBdjmXGHdSi52wwvPUSgRzEbVwYeDdNsiAz2Q9CvR4Sai0XpbRYb6eHp6ngJm++rjh
	wLk4rhcvhIYXVYzc33lgaefPvWNairg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757417948; a=rsa-sha256;
	cv=none;
	b=lt4uH3dyy/gA0ynhQf4vCUhpZPATDuhiVzpWHw4YPz8AwIcCkkkzrcJj28D5jYb6HNERCe
	7O7EoEM88wpISkaSrVlfkD+wQbQxXNpmFJtKs3OUU/qW3LYidAdAFqzwAWj7MiLwlKqj9B
	ji/NrIuaDFGRE3zqJ9yArOwJ+M0BalU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/NzefE9";
	spf=pass (imf24.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3186660202;
	Tue,  9 Sep 2025 11:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B603C4CEFA;
	Tue,  9 Sep 2025 11:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757417946;
	bh=MnMaEWlz/QtlQ28E4FkGCUPQB5UpUKYT1xidLfF37Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F/NzefE9MfgofUX6bK5rf8bsHeScQYaogVbPE3TFEw+YIDa/B6zwvzkQ0HVMkEyEP
	 Ar7uvJTFGYYOjWWIZMOVeGVzNRf0jC02t0kNvY+hW9TLuvYfpscRl2yFNvZSwjRsBA
	 FvTdKbsBz0jqP+TQi299CfYV+nqXNsSLupy2D6mzdcTFDXSHv4RK2F1ZZ+xKN7SqJp
	 nW2qj7JHliBKNEhg8hXb5MXfZYRBHLu8t9OmsM+d5aB736S1xJ9LrYL9+IjPT6kpBz
	 zt9GZOO7RUn3Rlit6szXoCzqS4WgcIiUJAjlV5rGa40FnC0zwFOLqd5NqCwHSXhfWH
	 ZmRGBd9s9yAVA==
Date: Tue, 9 Sep 2025 12:39:00 +0100
From: Will Deacon <will@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Keir Fraser <keirf@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
	Vlastimil Babka <vbabka@suse.cz>, Ge Yang <yangge1116@126.com>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
Message-ID: <aMAR1A1CidQrIFEW@willie-the-truck>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck>
 <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <aLGVsXpyUx9-ZRIl@willie-the-truck>
 <7ce169c2-09b7-39e3-d00b-ba1db6dd258c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ce169c2-09b7-39e3-d00b-ba1db6dd258c@google.com>
X-Stat-Signature: 5x8nwi8hk99dcgkfx4173ncgkr8htuwd
X-Rspamd-Queue-Id: 09493180011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757417947-899838
X-HE-Meta: U2FsdGVkX1/00pEi97umkz8d8uqOMTJ9IilWJN2HvZCKBm3rH8peHjNvB8KrFNetWQ42LdlmvxHCLe9j+Z0ilfHaQRRG3KopaHxM+XOT//Z5tJc770oBMvBkc6xyCTvlFPW3nX/pVWL/x///3zKWknPkwRHX+gDdfND4jHQyWApfd8ji83Ar0YaSmV90UkZNNTu5pTk9FgkZdh4IfViUzlXcBW3kdMPL5eSPQz3zQzyb/Vs81Wcpyj8VHAsXiJzFR+ETCGk7WyoNBnvgIgRnplRfHmlOC8ZfKnKKSvKXbxZE4G2vVHNDLSuyfmx1HCM8K1ptjrFCaQ1gzoSBK3l2jYK0ufg3ciR99m39c19SpOfdHV8NPCYG8mfghl81+RMNR263HvXMV2k4YX7cUjYqp7yijwRwZzHfb6WCaoK85WBVp8Zl/cg1hjJYMj1TpOarib/j2qWqq4doXlqmV1JdVQ7MgLaehTUFHpzFbQQV/E9zNorSFQcn/0KAurLr/1OKXkmtPqgtpcrimEmiDRIdcAc2+NGsooUOj9+Yf4wTMrzdS4//1e1EnqWrF1filWBMv9ukJdQEmAx+Tuh6MgSCGObQ1H3hQx+7cJDJ3PtcZ1vrpBPM91SUaPmJFgm0o/D0UBo/TrHSnq20ru+dzogyj02wOweLg4GhB4bR883hnz6UyWC9B+wtTb2azn70PMPvqffrHKkGPqUjSPDt2KrBIWwJeYCCQ6/pOSHzmp/E1GHe+wwhlEgzbbs3BILhPX6f1UdcbZyQMBSsTrPUYJh8XBItSP495h88stHeXN1Aa8TftJd5EvMr3p84/zrUJVHRgv/2uaNzXv/+7apiX8V9PFvM6XGGu/GUh6uMgv9U425yVP0RaYhq2vF3kjQNo5h0GCDAu//XvOk7rB3OyhRIieDQad/NMTjXw0AhuSX5AUBALVuaJkzjVH+l7hCUBSXrKqTc+ePdym3mM3KBY3F
 UDSTSmRr
 XA9+ZoVSHmifB0vva1tmMZhz+EQtirorYbmdE93hRpKxWMEIIge/SDR5q5v+dooDoKaNHbwY+dwvrf6QDsUtURM7Bv30OuZ9DnttsPejn7fKt6EJP193fpsZ5+Pl25IfD8xxpKlrcjRPHr+DvKq83S+frOW9ldx0CgQQn1qEBLLJlGX5FUlcgXIN2OvBK09F1F/FoxD3zUKQaAgHZtP59ImrxZUblXTGj/IFb+5SgOnDLZPM0TxTE7zml0NWliqUJfxfXrP438MIhK4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:46:52AM -0700, Hugh Dickins wrote:
> On Fri, 29 Aug 2025, Will Deacon wrote:
> > On Thu, Aug 28, 2025 at 01:47:14AM -0700, Hugh Dickins wrote:
> > > diff --git a/mm/gup.c b/mm/gup.c
> > > index adffe663594d..9f7c87f504a9 100644
> > > --- a/mm/gup.c
> > > +++ b/mm/gup.c
> > > @@ -2291,6 +2291,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> > >  	struct folio *folio;
> > >  	long i = 0;
> > >  
> > > +	lru_add_drain();
> > > +
> > >  	for (folio = pofs_get_folio(pofs, i); folio;
> > >  	     folio = pofs_next_folio(folio, pofs, &i)) {
> > >  
> > > @@ -2307,7 +2309,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> > >  			continue;
> > >  		}
> > >  
> > > -		if (!folio_test_lru(folio) && drain_allow) {
> > > +		if (drain_allow && folio_ref_count(folio) !=
> > > +				   folio_expected_ref_count(folio) + 1) {
> > >  			lru_add_drain_all();
> > 
> > How does this synchronise with the folio being added to the mlock batch
> > on another CPU?
> > 
> > need_mlock_drain(), which is what I think lru_add_drain_all() ends up
> > using to figure out which CPU batches to process, just looks at the
> > 'nr' field in the batch and I can't see anything in mlock_folio() to
> > ensure any ordering between adding the folio to the batch and
> > incrementing its refcount.
> > 
> > Then again, my hack to use folio_test_mlocked() would have a similar
> > issue because the flag is set (albeit with barrier semantics) before
> > adding the folio to the batch, meaning the drain could miss the folio.
> > 
> > I guess there's some higher-level synchronisation making this all work,
> > but it would be good to understand that as I can't see that
> > collect_longterm_unpinnable_folios() can rely on much other than the pin.
> 
> No such strict synchronization: you've been misled if people have told
> you that this pinning migration stuff is deterministically successful:
> it's best effort - or will others on the Cc disagree?
> 
> Just as there's no synchronization between the calculation inside
> folio_expected_ref_count() and the reading of folio's refcount.
> 
> It wouldn't make sense for this unpinnable collection to anguish over
> such synchronization, when a moment later the migration is liable to
> fail (on occasion) for other transient reasons.  All ending up reported
> as -ENOMEM apparently? that looks unhelpful.

I see this was tangentially discussed with David on the patches you sent
and I agree that it's a distinct issue from what we're solving here,
however, -ENOMEM is a particularly problematic way to report transient
errors with migration due to a race. For KVM, the -ENOMEM will bubble
back up to userspace and the VMM is likely to destroy the VM altogether
whereas -EAGAIN would return back to the guest and retry the faulting
instruction.

Will

