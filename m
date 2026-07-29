Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA771C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 19:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A5F6B0088; Wed, 29 Jul 2026 15:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B916B008A; Wed, 29 Jul 2026 15:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E0B6B008C; Wed, 29 Jul 2026 15:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 294476B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:07:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90DE314072D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:07:41 +0000 (UTC)
X-FDA: 85042748322.17.45506AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 01A634000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:07:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5L9d1+9;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785352060;
	b=Ia1yy/b5s+bHfMI5l5LC9SDjqxaxWhVmAcgNRREX1nslpbPiG19ocl5Z8YuqLKwcFZ14mh
	0hcfdrCKYyUFeZU6ttdTFMKTjHsdXMw9PLPoUpiw5XWUc97ydEtN6hlC8pdGc7A14ASgoR
	SnFRX/Ly5z7/4hVP+s776H5KTpUOFto=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k5L9d1+9;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785352060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSv0NhzAoI5n1gzPa2GHMIZDbJeYAamzCQ0Jv+g85nU=;
	b=vRPuviIOvSbCp9VDzM3KlSgw9Q9TTgIoXqZQCj8T7+phxp3R0n/0K6yIsGucRCnhWN+xjx
	7fucfFU71J5MVhn1D46ZpS+1E5s9gqbwSDJrj+Me5QoHBGC0IkrDOy4F2qqjDk+cGir3Tz
	Py9EZqtun/0UEi174hbWPjNxG14Xexk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24D0E600AB;
	Wed, 29 Jul 2026 19:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA401F00A3A;
	Wed, 29 Jul 2026 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785352058;
	bh=LSv0NhzAoI5n1gzPa2GHMIZDbJeYAamzCQ0Jv+g85nU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k5L9d1+9VqsYK6U/s/MDpqvUbwem2zy8pM5N/EPxUKy9+SaAHYrvCyumWSLGgQPWm
	 UyJM2OTCky/3e2hISfTWrnx8sk2PZB/oARPFCY6WTSPGAQQmotl/vhdDMegtueRSyd
	 Pt+NtX07YVEbfcgHWkfeDXW0M0Q6vxDxq9AWK94BL1pcDuq2uiPi2/5/waICA9Al7p
	 CsDJzyGPWSuHh9ufrQg0zwltGkisvJBkMNCH7gHL+dNZAcMfdZqcysQwyoEnGortOM
	 fwK3B8NhaGkMB8Qsz7UNa1/bctKaUsPHbX+TD+f4nj1C3lS3RwxrVNFSGabuOmKfpX
	 /PUhur6wi+Inw==
Date: Wed, 29 Jul 2026 22:07:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH 3/3] x86/mm: Fix and document DEBUG_PAGEALLOC
Message-ID: <ampPb0o0T_JdxrMx@kernel.org>
References: <20260729110807.797920433@infradead.org>
 <20260729111119.604452135@infradead.org>
 <amoKo2LoJvfndqHn@kernel.org>
 <20260729144838.GM651302@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729144838.GM651302@noisy.programming.kicks-ass.net>
X-Stat-Signature: ngz3w6pfg854buaix9n4fk1ptjz5cnch
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01A634000F
X-Rspam-User: 
X-HE-Tag: 1785352059-70480
X-HE-Meta: U2FsdGVkX181EzwNpaMke0Pim0ihjT1Gd6T1V5PtwAZj4nKQ2pkJdqrCfRXHY2lWPEcy/DqRnFxcQeXbk/hmbnWhrE4+B1dwHel8gp/lUUmjNcGPM0NIjxnBWusyZSLEWrgrWlzuJazWvlATC4YaKMDpkuYtQohAtQAimuDJPgmmApNigAuibl3BwDh8K1fL8lE/TTBzfcLCG5FDBw/XOXfNunBuMnuD7W13AhH+9AqSBi2P5SeFTmFtxUREi6s4Pv3jEO7pMPZaJktnIu2H0KuGczhu8/zl3C9exIqo1Ei2SdF5IJDRkEz7fsLxB2AzPOUepL7TB9o68xr9mdt2Fu3NZY0L0R7onxq19XA2Z3ddNDTajAk/vnWwRgIGrb4PnA1EhnFuyLXatn47ubYN6WTKUe9jXgFbSZoVKLMYCD6UaEv6h7J+WZy/WB+eiM1aViGFRL32YyniwlkdGThtKl5pe6LN/BkEXa2+48H1f+lz/Pu/5eF22WKR8djRD0twC4mi+x+21Fw0wd+0ubJVhSqPVYlI8EL0qTlr4Rm7u202bnD4zuCmvVPl3oNzc42golIxSWCcPWjFO3WS1pE8c54jbxAuK9FWrudAvuo955CxjFTa7slx0uvPVXpPJ7AgjUas0YGlDtRD9PNV0I9YPraxv0mDRHYZoQxv+SGgMyvFzhh7hntURMM8y+o4YTI5htEu4Sfp+rQtn8AfBNtI7TQFlrijkM51kLShrI4HCfz/E0+ijYDQ7kVtOjjWdzNAgwYEV3GUwDEfiha2Tvb9/lRo173idIv+1X3cbXOGRV5yaCZsEiS9hzhJF7L1C4g2QLIqmhkf4QQTnRgme9k4l/0QYXnNcyOGtigiZYQAbPwVKqjSXY6IB23R3RMf5+srFUDRU86a1MuT3ZGt1sTWCXRNqyiGDg/HExzSm5DWh+ckG4lQJEEmt/IarghMIyvJrl9B957mB1wQIwFMxOt
 mXaemFPg
 dzeso5qPSgfbiu8UqRhyPn6l5YNy56xLvk65baF2cmx98toHgw6VH2knlEXjrfsmnVsNOBGCml0nGwSzTUQHU7Dd93MFABpu1oBaa/mKqcWo17avM9dXxpEr4e2yrPFxayc3aWl6TnEoVS5DKCcU0QHAc3VC2rgY7m/VmDClkBhBiI5m7Fza23i+UFgsA7g9+YWyEuYcABPiftrv8tgkuVqXvAqm+nwzX8yBf+IWPlnPtTGpgbHKwnVTGLSlkvHxUQ2ae8sV+9ynw7dyGle6V5jSnSql9OMXMixAfXocIf1vK70yhlJ2NWVviJUbmsALyfY9YESntmxdGrfEVemndA3vxj1rr3kUq9eJP/IbFtCcyKT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 04:48:38PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 29, 2026 at 05:13:55PM +0300, Mike Rapoport wrote:
> > On Wed, Jul 29, 2026 at 01:08:10PM +0200, Peter Zijlstra wrote:
> > > It turns out that commit 5fce67641a3e ("x86/mm/pat: Don't gate
> > > cpa_lock on debug_pagealloc_enabled()") was a little too quick to
> > > remove the debug_pagealloc exception for cpa_lock.
> > > 
> > > Notably __kernel_map_pages() is used by the page-allocator from any
> > > context the page-allocator itself is used, which violates the cpa_lock
> > > rules.
> > > 
> > > Re-instate the exception, except make it specific to the
> > > __kernel_map_pages() such that any other cpa() usage is still fully
> > > serialized by cpa_lock. Also note that since cpa() should not be used
> > > on memory that isn't allocated, the page-allocator locking and cpa are
> > > infact mutually exclusive and all cpa usage in fully serialized.
> > > 
> > > Add a comment explaining this and other 'funnies' surrounding
> > > DEBUG_PAGEALLOC, including how pgd_lock is not affected and the TLB
> > > trickery.
> > > 
> > > Fixes: 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()")
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > >
> > > +	/*
> > > +	 * DEBUG_PAGEALLOC is special; it is called from any context the
> > > +	 * page-allocator is, which violates the normal cpa_lock locking
> > > +	 * rules.
> > > +	 *
> > > +	 * However, since it is part of the page-allocator, things are still
> > > +	 * properly serialized by the page-allocator locking and the fact that
> > > +	 * when a page is owned by the page-allocator, it isn't owned by
> > > +	 * anybody else. That is, you *SHOULD* not be calling cpa() on memory
> > 
> >                                      *SHOULD NOT* ?
> 
> Well yeah, d'0h.
> 
> > > +	 * that isn't allocated.
> > > +	 *
> > > +	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
> > > +	 * that the kernel mapping is 4k pages, therefore there are no large
> > > +	 * pages to split/collapse.
> > > +	 *
> > > +	 * Furthermore, the page-allocator strictly manages pages that
> > > +	 * *exist*, avoiding pgd_lock.
> > > +	 *
> > > +	 * Therefore, it is safe to not take cpa_lock.
> > > +	 */
> > > +	if (debug_pagealloc_enabled() && (cpa->flags & CPA_DEBUG_PAGEALLOC))
> > > +		lock = false;
> > > +
> > >  	while (rempages) {
> > >  		/*
> > >  		 * Store the remaining nr of pages for the large page
> > > @@ -2008,9 +2033,12 @@ static int __change_page_attr_set_clr(st
> > >  		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
> > >  			cpa->numpages = 1;
> > >  
> > > -		spin_lock(&cpa_lock);
> > > -		ret = __change_page_attr(cpa, primary);
> > > -		spin_unlock(&cpa_lock);
> > > +		if (lock) {
> > > +			guard(spinlock)(&cpa_lock);
> > > +			ret = __change_page_attr(cpa, primary);
> > > +		} else {
> > > +			ret = __change_page_attr(cpa, primary);
> > > +		}
> > 
> > This does make DEBUG_PAGEALLOC exception more explicit *here*, but OTOH the
> > spin_(un)lock(&cpa_lock) in split_large_page() becomes confusing.
> 
> So as the comment states, with DEBUG_PAGEALLOC there are no large pages,
> so you should never hit split_large_page().
> 
> It is the same as pgd_lock; that isn't guarded anywhere either, and
> works by the same reasons; DEBUG_PAGEALLOC isn't ever supposed to hit
> those paths.
> 
> > I like my version with your comments added there more as it localizes the
> > DEBUG_PAGEALLOC exception in the lock wrappers.
> 
> So I don't like removing cpa_lock entirely; it is still serializing cpa

I meant static inline cpa_lock(), not removing it entirely.
With your comment why DEBUG_PAGEALLOC is special.

> usage, even though it isn't as critical on 4k only. Having cpa behave
> significantly different for DEBUG_PAGEALLOC just seems like a very dodgy
> situation.
> 
> And again, pdg_lock is in the same spot. It all works because the code
> 'magically' never hits the pgd_lock taking paths.
> 
> > >  		if (ret)
> > >  			goto out;
> > >  
> > > @@ -2661,15 +2689,23 @@ void __kernel_map_pages(struct page *pag
> > >  	 * and hence no memory allocations during large page split.
> > >  	 */
> > 
> > I'd also return early and maybe even WARN if !debug_pagealloc_enabled(). 
> 
> The callsites be like:
> 
> 	if (debug_pagealloc_enabled_static())
> 		__kernel_map_pages();
 
Yes, but there might appear new callsites (I really hope not).
It's anyway really slow path so an extra if won't make a difference but
with it it's clearer that __kernel_map_pages() is for debug only.
 
> > >  	if (enable)
> > > -		__set_pages_p(page, numpages);
> > > +		__set_pages_p(page, numpages, CPA_DEBUG_PAGEALLOC);
> > >  	else
> > > -		__set_pages_np(page, numpages);
> > > +		__set_pages_np(page, numpages, CPA_DEBUG_PAGEALLOC);

-- 
Sincerely yours,
Mike.

