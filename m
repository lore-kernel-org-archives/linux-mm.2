Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5A31098787
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CF56B0098; Fri, 20 Mar 2026 10:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE126B0132; Fri, 20 Mar 2026 10:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13986B0133; Fri, 20 Mar 2026 10:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4116B0098
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:00:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EB59140201
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:00:06 +0000 (UTC)
X-FDA: 84566600412.22.B919A08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7876940006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:00:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RIWoHSTl;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0+Yw+Ry+S992jW7ss1XRMsR04gFAwKEv4/QMaJE9gw=;
	b=Tlcmx+NGdKM7fnu5TMjIdegljOMb9rMqhyNbGfD5EXlu9dQo3Fn5BpOelKNBKbLa1rxOgx
	N6hFigirZqZLHR4u92YOGkPXn6fiVrWeoIuFJwEzm0B5vWgDNoF39YUq7phgTpJxyX0vnH
	VFhrH33UWROONP4cmxEwtN/7m2h9DnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774015204; a=rsa-sha256;
	cv=none;
	b=nDC6fXRO1ap4UBiT1oR9bbG6mC+reNoBxTxXh/N1+YH4OO0DpNQLQVIluKkmG/hWWew+SG
	ViyFe3KWoiu33eHUv8v1B3/9vAolTnDxWXIqqfyp07//4KFlzbo32JbPjN3YRNUWBm5iHl
	S0jRj9Gdy1vTD0HTxjsOagkSjnK6gdw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RIWoHSTl;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D16A36185C;
	Fri, 20 Mar 2026 14:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECACC2BCB0;
	Fri, 20 Mar 2026 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774015203;
	bh=s60f1w5E6WMH4ey5gx+hmeq9SdnSAAmyj2RTplBL7IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RIWoHSTlFFw2MFbo5M5gi+uUJisBLa0wzbG9bFC+1dQYGhbKlC8KAhrIaGWC91bmQ
	 BgL3hv5NY1PVyhlF6Hl+gsYY8FOTR/tBllaSKcxm/gO0dLSAOwF5bzqubXfCrAyksh
	 mQCb/w5A/UEmvCnsOo/utyNhPoqOEzl/XP3Y5T6YyawDcx/ipeSXMDFMkkZJ6HEYkJ
	 k4vRCLHLbgAWvuzC7LLNCHUXxE3pIAPUfkdmfjdWKHpyJ+6Da6fiaXlNruRYUqNrUa
	 ABx520hSU50L8p5zQDVgNcjHuyKsTKavZY+a3rl++PkFzKg2Ub/cTXHkOZCtug3JmD
	 y3z5+y4Rw7hew==
Date: Fri, 20 Mar 2026 13:59:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table
 call
Message-ID: <81116647-1f3c-4ce9-8aea-cbe6214f7c4d@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
 <abwr3EmhNZVwOkR3@thinkstation>
 <420f1b11-3b62-46dc-be33-58fbd5a4c8b3@lucifer.local>
 <abxwNW_kKakiYvsp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abxwNW_kKakiYvsp@thinkstation>
X-Stat-Signature: bqsg8y3jteqokpf77zs9brf6dj6sa79k
X-Rspam-User: 
X-Rspamd-Queue-Id: 7876940006
X-Rspamd-Server: rspam12
X-HE-Tag: 1774015204-368111
X-HE-Meta: U2FsdGVkX192ir50fJJNQxrVj9ld/J+rL+kTvKOo7odL9nFLnL6l7aSH55vc3/a8zJizhETmgrZzcmpG/zPsqWgWu7DSOM+kPQZ2Ui1Rzi7IO7g7RyyPUC1yrkXZhYpzBxNkhX2tD1cbELbBFU3kOfDtAQBIqiGiKvCgF/MFcWgeVTSWLnjaiUAu/6jeOSQ4W4TZRsd2H8la7/hmEB8yVjlfL490E5gOmsMCxpUn5nPXLYJGzWqeTLmPHRcD+YX8veN56IWC/HGflXZSWTii7scN+zjNzCMOwxDAUE2ocxjkGqmFYxt+V52Bq2wnkOGQTgkLYPRylQpMdV2yaeYCK5cBqp8lEo4AaETP99JVb6SiLUDqpIAIyGoCtDUyH9UpsYz73RZqDvQ4O0HNNwQ4cWDTP4KDkHMRmIZyAj2qRd0XUPkuGbF+ek4F24d/FEtCd6/3xtgOapItsH7jM8PXI4rDPLnx+ae2Er1NnPF6hsK4dxxkkJGwkXDlmPSN9jeJEhlYqtmiD+fudXJlA28wkUg1/B0etMLer6/UAtDptCCJ9ShEWuC29c19S8RqoZuX2bQVkOLPJ8SCm49nlCaViahAtYUuVbZUYBelxXbfbngiVzR0t+OSdWYEES/joXCd0g/d15VvNVtMtbZLe5mfvzD1Z2TXHBPGFaE3L/d5haVORpZstX3GfFbpg9VGS1dfljtYx8fy2N0ZRA53L5NS9O5IDVpmerGaAg1Yx3mZTkDz8PR2lyyLmGS1wUxxktRz6qWizIobQNEpY6ZK4bqEEMVM1eSLz7uL6WaYTgfSUzQKeVQHos+gZSfuiH3Zy5VUWmvynGkHQBSB8odRvEs/NzDISxOAmvBkxjakwiGugxMLJ6dYrGyteIWScOIXgahy3QT/2xnNxdFgp/rCO1616x70PfepZi9S1D1/VrDC9yfrET/Cs3taWoCm8dW7ud6cQEITNqGfiGQpfgfJBQq
 u5FyPplD
 LBtiaQThilOtuSPi7UlGLXxNaDOcaWFjWeSP3J/cvpomipmCGsQgpNHrp1RO8DbbuYvRTdknLlYsSoj6y6cVceUWCnNXobGj1ZD9En5ixCZ9q7RnKqxRvf+DQA4GhFW40aCr7n4fqA3kQJEObOMvJJSa1G7nLKHpnUs41N3zMZGQEIxverMqfsoQ8dVLcHjHrfN5vTRRSyf08pD+kmclKlPx04ol8RbvJEA7T4NHnwncERS1tweTgCTs+R0F6LGrwfqPkhWTVvZ3EzHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:56:53PM +0000, Kiryl Shutsemau wrote:
> On Thu, Mar 19, 2026 at 05:18:11PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Thu, Mar 19, 2026 at 05:03:10PM +0000, Kiryl Shutsemau wrote:
> > > On Thu, Mar 19, 2026 at 01:00:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 499c31bf8f83..c4e00c645e58 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -2431,6 +2431,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> > > >  		 pmd_t *pmd, unsigned long addr)
> > > >  {
> > > >  	struct folio *folio = NULL;
> > > > +	bool needs_deposit = false;
> > >
> > > I think 'has_deposit' is a better name here.
> >
> > That's fine, can rename.
> >
> > >
> > > And initialize it to arch_needs_pgtable_deposit().
> >
> > Yeah I considered that, but then you have to do logic like:
> >
> > has_deposit = has_deposit || <whatever>;
> >
> > Which is a bit ugly.
>
> You are overthinking it. Just do

Well I would argue you're overthinking the review comments here ;)

>
> 	if (!vma_is_dax(vma))
> 		has_deposit = true;
>
> No need in squeezing it into single line.

Well part of the point here was to avoid ugly:

	Indent
		Indent
			Indent

And that worsens the situation.

Let me think about this again on respin.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Thanks, Lorenzo

