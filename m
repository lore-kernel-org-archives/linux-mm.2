Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0008FC79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051386B00A3; Wed,  9 Sep 2026 13:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028C96B00A4; Wed,  9 Sep 2026 13:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8176B00A5; Wed,  9 Sep 2026 13:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAF6E6B00A3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:25:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C29E12027F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:25:41 +0000 (UTC)
X-FDA: 85194900882.20.33A051B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6DD3A20008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:25:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np2zHsZY;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pubbd2dNu1LQzdMpKfGD1I+IW+yVdlfvOm5SQzKSwOA=;
	b=Ia3PcuzLvJuKIfYguq45Hv97cQkkQaV2h/NOhUWSGNwdHVadLQK8Pz3CqhNxRVX2MrEONB
	4YKciMwNjHGA0MK6OiPoKh+f2XghSJRLphNLCOPfNyQ5r69iUnogrf+DlRWDced464R2cA
	CLvxxrO4LTAOfpZCvdNjFhuogHNjUY4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np2zHsZY;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974739;
	b=j/Hipe0/v4mnk+UotckEAJ91iwxN6GbWqFuHTVPhxljlRT7hLCS2o1YH3JXNhk8MLa5dqZ
	IgLTNFnDpVplvzYyK5yfTL6Z8qmSWd2hYP6n5GJ/9zonHgH/D68KKucdeDQOppaIir9Z2B
	udB4f073WvqXmR0//oYjM3VAPslq7Ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2AE043F2E;
	Wed,  9 Sep 2026 17:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1130C1F00893;
	Wed,  9 Sep 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974737;
	bh=Pubbd2dNu1LQzdMpKfGD1I+IW+yVdlfvOm5SQzKSwOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Np2zHsZYyQkXFsoQXHrepxlLGabd+RY/LBmPCa+qEqed8bCT4ZETBek7x/fepo2cf
	 chc0NHhTyWBOo6MGAe1MrYbgn7rNMGHB+e1UrAiQxAUHgqiXvdoqS10NF4irGfKGVI
	 OZJQwaSiCY2nNlmpzquIIfCMsl9L+cAJww6j7RQg4rEeYoATXyukmi6ZDsLquBc5uv
	 jbodWLtGPjBeZ5BJD1s91Ykdq+MH+S8UREAaZvPNBRWDpRr0ED+x0Ok8sayWFcQ6pQ
	 54ujIFeehVia5phkoxeM18mkzVx3GTUC3a4BKwkk6m7ri25RP/Lk54BM9PfdUa/6sZ
	 QZyhRCK3nIy1g==
Date: Wed, 9 Sep 2026 20:25:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 12/25] mm: kpkeys: Protect regular page tables
Message-ID: <aqGWhJjE1VUZf8_3@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
 <178877845406.3691569.12554855722197968629.b4-review@b4>
 <bdba5b54-8733-4d47-952d-e1bd958a1ead@arm.com>
 <ap-6PZqGZHhPD6u1@kernel.org>
 <00e97c75-eef1-4587-b299-ab07591a07bc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00e97c75-eef1-4587-b299-ab07591a07bc@arm.com>
X-Rspam-User: 
X-Stat-Signature: 8c7nqi15miiy8tpq8sgdqfwo8dok3jku
X-Rspamd-Queue-Id: 6DD3A20008
X-Rspamd-Server: rspam07
X-HE-Tag: 1788974739-686794
X-HE-Meta: U2FsdGVkX1+GMFuMWYd/ZELATnvACuP/8+o1poQku0+SNurU+JpX6+Hb80KxuKBCYNiacW3tMDzjPbUIDRp1l3t8l0ZZRWTZ5XyH34nNolXozGukk8CZIAGzBb6WFoQVz+ko+uQEaN0GAv6ivHSfso6Ga/TZ4efH0R1Y3B4f8PTHgPvgLvaYeyAu4qIwkVPMHyCVsdS7XcN9B1eKG3ndYITir3/Ejv/SlGiHv5OwYcqtJlpns1X9QbQKWvHvxG8kWiedvGkx5DNzG9OBff8TnSQm9bUg+gy5rWNNr8eToanggU7iLQEY2NG1rBD2iTl7QZTMcwIdlmOESPYrTIn8DhDSWb6PH6a8SN5NpUgxVCCN/FtrbleghI7n0KOxo1Ot1KMBauzArjv2UbjpHUIlhzb2raMPgJt9csESaqCfdJHuE0xFM8RFp6sGYf6yaeTkzUrIFTd3m/eksUGWqfHe9bcuoDJbQOHbvE53pxQYNrtXzUHIHGYSsVNN1UBoA33ACVijsGWN8nXY0EUpIIF+Syp2omd2ufPGc+OI47yzQNTBD2dy1SouVOGIXagWDJGDJz9EGwLbbcJjacrxt0Nnbyzwjv/Y9quoT5/g9uOi24MSA0wxLcxHGLxD19K5/FVmwLfw83o+ucVMVH6wQxB5vereLXl9QAO/8z34zL4tf/K601RJ9vPUbPifBziISnuy3U0ImEy2BQQrVQgFL4+6aFUimGFDepZ7d9kpXuH686XIUpBYcmBY//6z9m6hn6j6Z8u9t0okUi7gsAHQwvDlAd5HlxizycYaO0fMjAvn32+shkyct/O9aBMCj652+5NGXmcqGz0vThTtwG4z1mD2KnolrSrB3dXQqeK95pX61mjGXB7ExsSUDjxiCT1CXsXi63hCJF2Xl2MuM9eVniTuIwAIRXlyGRBT86XnX1LtIyu6hQjsGDoLSk0oHt7x0Gai5v6ILw8es/WIpGYGhZX
 M8SMi6uI
 P/McwSEOsDizIl7gg3Xqa7hET/94zONjEpe4em8QZyQkGimP1mEcPe6Z2ThrNrCBZEnDR5mFVhXtJn5rLodtSU01UqU3WUZJOoRUrD+4B/yhVSVxPPjglc9SoQXHQhMJS6Neqq/4HOjdylBlS1YL5jw7jj5W7LVsAmDhiRNfMyJ5AdUpEWx2wTyKKDWhbcGT6Prjbx+7bkCvKjwBzhBjqDqIkM9VIdcz50YWcidPuCgQhkISm9g0rYYGNyTXp71gDVWAa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:11:57PM +0200, Kevin Brodsky wrote:
> On 08/09/2026 09:33, Mike Rapoport wrote:
> > On Mon, Sep 07, 2026 at 05:52:32PM +0200, Kevin Brodsky wrote:
> >> On 07/09/2026 12:54, Mike Rapoport wrote:
> >>>> [...]
> >>>>
> >>>>  static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
> >>>>  {
> >>>> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> >>>> +	struct page *page;
> >>>> +
> >>>> +	if (kpkeys_hardened_pgtables_enabled())
> >>>> +		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
> >>>> +	else
> >>>> +		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> >>> Can we make it a sequence rahter than a branch?
> >>>
> >>> kpkeys_pgtable_alloc() does alloc_pages and then sets their pkeys, so I
> >>> think something like this should work:
> >>>
> >>> 	page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> >>> 	if (!page)
> >>> 		return NULL;
> >>> 	err = kpkeys_pgtable_alloc(page);
> >>> 	if (err) {
> >>> 		__free_pages(page, order);
> >>> 		return NULL;
> >>>
> >>> with if (kpkeys_hardened_pgtables_enabled()) folded into
> >>> kpkeys_pgtable_alloc().
> >> I agree this would be less ugly. In fact this is pretty much what this
> >> series did up to RFC v5 (albeit in the ctor/dtor instead of alloc/free).
> >> We could go back to this API, *but* the big issue is that it makes it
> >> impossible to use a smarter allocation strategy for protected pages.
> >> Patch 14 in RFC v6 [1] will give you an idea of what such an allocator
> >> (with support for large blocks and splitting) would look like.
> >>
> >> As discussed with David H we're first trying to land this feature
> >> without large block support (fully PTE-mapped direct map), but we do
> >> want to support large blocks eventually [2] and I would prefer the core
> >> API to be already compatible with that objective. Very happy to hear
> >> about suggestions as to how to avoid the explicit condition in
> >> pagetable_alloc() though!
> > We could unconditionally replace alloc_pages_noprof() with
> > kpkeys_pgtable_alloc() and make the latter choose the right allocator, but
> > that's not very nice either :/
> 
> Yep I also thought of that but the naming would be really misleading...
> 
> Maybe, maybe, introduce __pagetable_alloc() that is a simple static
> inline calling alloc_pages_noprof() if !CONFIG_KPKEYS_HARDENED_PGTABLES,
> and otherwise checks kpkeys_hardened_pgtables_enabled()? Less ugliness
> in pagetable_alloc() but even more further down, not sure this helps.

You are right and I can't say I have any bright ideas.
 
> - Kevin

-- 
Sincerely yours,
Mike.

