Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA33E606A884
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n73BoZfW
Received: by kanga.kvack.org (Postfix)
	id DAD4E6B05B0; Thu, 12 Nov 2026 06:52:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E5C6B05B3; Thu, 12 Nov 2026 06:52:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D4D6B05B6; Thu, 12 Nov 2026 06:52:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91A286B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:52:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2963A140573
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:52:59 +0000 (UTC)
X-FDA: 85426305678.15.3F525EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75609160007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:52:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n73BoZfW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwn/H1ULONfD3r8MGUfyFZepAjOONqSHtVOfwqC7R44=;
	b=RgSBhybI0Q0KHQK7yh4IsYNqxu4E0gIOpxmWFOBoehpXRq12atpE/gc/10CbpPLRhsKoSY
	uHWRS6WtFPwAgo70AO/Sr8c2ne5MtT8qpwkoM9x9wnvVd5D7U8na6hq17uuQcb/JqhLBfh
	ZiLDzvb6rMsB1RLZxIKibO2XnATYXXw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n73BoZfW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484377;
	b=XslDIbnUmm/EowkchNpvUV26+yYqm+Sdu6NAPdZv6TOL9psaffBN0SKLO5qNXri13UQd00
	Ru9OY1I+cd0l00LlVlegFqk91FOq7B+9wzF31o6Oibv95qRTMnxp+jwjrn+Ivn1v3U+Phw
	qFatIVzPm6yWeptLs+wTtnjoDgo6nyg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A98B446A6C;
	Thu, 12 Nov 2026 11:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AFC1F00A06;
	Thu, 12 Nov 2026 11:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484376;
	bh=mwn/H1ULONfD3r8MGUfyFZepAjOONqSHtVOfwqC7R44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n73BoZfWq97QkN/EzmbuARqlOgkw571PAQbg9exHKtPkxPfLWofEF3xx49ExQI0+5
	 NP7AVrlK+9cNoWfkzTQe8yBsYysMxwPj7QUvfullML+BTgnwt+niwBFJ4djUkPZJhj
	 u6DmKuJ63HSV8sLPOkQLGdgtwRQ6RQpEjkwL8WSFEcC5i1lk/REmtDn0ONN8B0fZFp
	 KWkLDbCPyrj8njpmsNXUwgIiAnGNXbD/W3krNa+IIu6u5Jasv+5pY51IpfMF9/2E1L
	 EJxh+zfJfG5qrKbAwulb0FfxElREfauArGku1EH6kDQbGoA0jT0iwqZaeqUalrXJE5
	 nEFAmwZULpIuQ==
Date: Thu, 12 Nov 2026 11:52:46 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a
 hardware-poisoned subpage
Message-ID: <avWn47ADwJwP3DWz@gremlin>
References: <avRqaatdOUunxrcZ@gremlin>
 <20261111183917.1093166-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111183917.1093166-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 75609160007
X-Stat-Signature: 674x1dxkk4beg8ceasmo1heq1z748sx4
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794484377-355397
X-HE-Meta: U2FsdGVkX1/a3mCgbpYaRiSpqupz8PnsovBY26uZ5/ZvKRPekHVJUzXYQWUtRd1tdhPVQ5BoJKivH1Q4QwopcXt1F8d4jisoPyeKBGrqooIt/ATg+758Uag5RVHNaD4EreNWEGr7WI6aYW1EzgIF14R0j1P1pfBBjvPhDj9EXZO7fZGFh3TMVTeKWd/+k83b4hkLzStE2HTZmO5WqGN/T4EQecJE7G/8ZmJw9Hl/uAkaYU5X8CpaSq+2b+nfKWzxxIoxNM+4YJZq9l3nEW7K49kbkC5fuNaulREMTzQjZ2FJo1cAeeSC2IiW3bb8e+PgnHN7OdJ87VoEkcSXfF3nHonVx/DROGiW5HxLfRFl+K5KYdcbFbkPhauud8RpU+5c/l/RTkgMIu+XH52BB4+TqmPImuoAvULqbdo/6L0W36WJsTR1j2+EAUo3jH0cgsk3+gtm3vqOgEDgdiCvb2dBtlIf0RIJvXDWnnAIF8dF7uQqZe2gHJoC+Xwe0FvvMjB49eoQGx3e4X/eYAYXRF0fJp2BFplTGEqPgwysuU7KsyoMOEAew6vlkDIvTQidxSuu/1HXBfknZonwz+1WfVduw00qmWtrkQ8CFWJ2Pym38mryUh9Y4TDb8ixB4XfV9XZHHucdDgn2hrQ3qrRGUtakta8ME2TpoK45vAzJ9H6gaz9djGyN4iiGs1mYjA1Q/nvQEyueZRkUYizENL+njGbpkbUghQv9nYmHfFPUMGKrZNTFl+eArT8yBtIMCzTO4X3kA4DCYESey5ThBG5cTmRFhEVTqmu9GRnUCYyAwUE7Otu0yzkboU6MMx0EKPLHYUaNIh7Psut+wSVb8VVrILoLI8sZN41DHarbaCdRMNS+t/0r52+ZArahPV4TQTEfn1KjEPhCpPAe4cgGnycrz0bvn6CT1eIEfiOP4ItfyBFuLp6VPOZLuViCwjVVZneHujIlrv01YXbFW/50mg3JUNZ
 3PePg35u
 8BjAIjgCJozYYDICaGSoHwAGtIrgJ7Uanvwpfs83GjNaCK7AseBbJsOOkuiFAOHnxrp7d+7p+DQYutJEaohsTXpXPQI3TRWL0o1j7yFGTNl88GL/b5pfCOE4vs6nS5JZs1+YArTEBVTuW99oC43m4PIB8k6GQp3ekK3IJwUl8LzcDRUT2U8WN870g3EyP1nNzWfcruPR4DOLuLTFSUk9rFOnLaBZ+P66k11+Y2v4KAO705S0gTlGWORQu237cFgSqik08NsHUru/iepfUCxJr/qBaPfGnpXlh+pLLjR0W/XqJIbHM4zpnwggLjHlLOlt6sDUggOSKUPZYvJvV/iH/OqNYvb23MRrlCoIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:39:17AM -0800, Usama Arif wrote:
> On Wed, 11 Nov 2026 13:18:36 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > On Wed, Nov 11, 2026 at 03:38:29AM -0800, Usama Arif wrote:
> > > do_swap_page() checks PageHWPoison() on the faulting page, but the
> > > large-folio batching path then maps the rest of the folio without looking
> > > at the other subpages. A poisoned subpage that is not the one being
> > > faulted gets mapped anyway, and the fault that would have reported it
> > > never happens.
> > >
> > > Skip batching for such a folio and let each page take its own fault,
> > > where the existing check catches it.
> > >
> > > Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
> > > memory_failure() sets PageHWPoison() on the subpage first and only sets
> > > the folio flag much later, and the bail-outs in between - for example
> > > get_hwpoison_page() losing a page lifecycle race - return with the
> > > subpage marked and the folio flag never set.
> > >
> > > Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > ---
> > >  mm/internal.h | 15 +++++++++++++++
> > >  mm/memory.c   |  4 ++++
> > >  2 files changed, 19 insertions(+)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index cd3675c044e0a..e61c02f4019b0 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -28,6 +28,21 @@ struct folio_batch;
> > >  int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> > >  		void *buf, int len, unsigned int gup_flags);
> > >
> > > +/*
> > > + * Check every page of the folio for HWPoison, rather than relying on the
> > > + * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
> > > + */
> > > +static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
> > > +{
> > > +	long nr = folio_nr_pages(folio);
> > > +	long i;
> > > +
> > > +	for (i = 0; i < nr; i++)
> > > +		if (PageHWPoison(folio_page(folio, i)))
> > > +			return true;
> > > +	return false;
> > > +}
> > > +
> > >  /* mm/workingset.c */
> > >  bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> > >  			    bool flush);
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index d477a4f986bc8..4b7d456332200 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
> > >  			goto check_folio;
> > >
> > > +		/* Let a poisoned subpage take its own fault. */
> > > +		if (folio_has_any_hwpoisoned_page(folio))
> > > +			goto check_folio;
> > > +
>
> Hello Lorenzo,
>
> Thanks for the reviews!
>
> >
> > Hm, isn't scanning every single page in the folio potentially quite costly
> > here?  I thought the point of batching was to improve performance overall?
>
> Swapping in requires checking every subpage, so there would be a cost.
> I guess trading it off for correctness :(

(we don't say subpage apparently :)

Yeah but the cost is now paid by literally everybody...

And...

>
> >
> > It seems broken to have stuff potentially interact with hwpoison but then
> > to only set the folio-level flag much later?
> >
>
> PG_has_hwpoisoned lives in the second page, so memory_failure() only
> sets it once it holds a folio reference, otherwise it could race with a
> THP split. If get_hwpoison_page() can't get a reference,
> memory_failure() gives up with only the subpage marked. The comment
> above folio_set_has_hwpoisoned() in memory_failure() says that is fine:
>
>   Don't need care about the above error handling paths for
>   get_hwpoison_page() since they handle either free page
>   or unhandlable page.
>
> But a large folio that is briefly off the LRU, e.g. isolated by
> reclaim, takes those paths too and can still be mapped afterwards.

...now you're narrowing this cost to literally a vague edge case.

Can we not just do the scan _only in this case_?

>
> > Also why are we swapping out folios containing hwpoison pages? Shouldn't we
> > migrate away from the hwpoison? :) (I'm not really familiar with the hw
> > poison stuff)
> >
> >
>
> The error hits a folio that is already in the swap
> cache, e.g. while reclaim has it off the LRU to write it out, and
> get_hwpoison_page() fails for any folio that is off the LRU. Normally
> memory_failure() would split the folio and isolate the bad page (for
> an uncorrected error there is nothing to migrate; that is soft
> offline). Here it does neither, and the folio stays in the swap cache
> with only the subpage marked.

Yeah this just seems like the swapcache code being broken in general.

>
> While looking at this I also noticed that the fallback drops a freshly
> read (not yet anon) folio from the swap cache and frees it with the
> poisoned page in it. We should actually actually also check folio_test_anon()
> before checking folio_has_any_hwpoisoned_page().

Ugh lord, how much crap is handled improperly re: hw poisoning. Such a mess...

--
Cheers, Lorenzo

