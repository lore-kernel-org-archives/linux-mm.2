Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A658C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460136B008C; Tue,  8 Sep 2026 03:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411B46B0092; Tue,  8 Sep 2026 03:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303266B0093; Tue,  8 Sep 2026 03:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 099C16B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:33:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F719140413
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:33:34 +0000 (UTC)
X-FDA: 85189779948.14.59747C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCF4B120008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:33:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDf5yNAB;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788852813;
	b=EahwWisKDtcdH3dzbWOmMRb1SFzqTC9xnKXMy7GrlJbCzpx9WY+NxNMZh68XSN+iHgfGIy
	ZZvUsQxCOuFu+zSN+Nny9iZnjVOOlLToKWnGnUeK0OxZXv2/9mcSSZUIvNOAvbnRNxss40
	YgEa27gxuGEhPPVREh/ETqI4HvvA0RA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDf5yNAB;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788852813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XksScMTj542HVHkyB1nI14urzyZQ1NnPrwE6pFWv+JM=;
	b=76Itrn9zw5dP4BjiXlO24yJhDv6Pi5ZXXQYrTbD38fxHvscK0WT/XL3gdlaQNyqxyeBEAt
	OxI8bch9JOBjEdJlyAoMZVH21KbpytBfq4a76S3Y1jdtHXfFI7Lq13MozagZaWQ87dBZPj
	TYBEgq1WiSpjcQWSBSk1lSO4u2QdeT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D270D42B6A;
	Tue,  8 Sep 2026 07:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6E41F00A3A;
	Tue,  8 Sep 2026 07:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788852811;
	bh=XksScMTj542HVHkyB1nI14urzyZQ1NnPrwE6pFWv+JM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NDf5yNABuLUHiqeaxlPBpJIkI3TK9/rc8cWI+3xEERZ7V7seyLQhxFkrAmyfltW9A
	 YMYkHArboRJpL/my33wJQzLLWU30oaoeEJ6Ttyg6w1/hv2TEYtTysufc1I4riY7Dqe
	 1JpKsL4Pz+cuPhrKS57RxOWMoKUh9ZXCcPFodVwYvHAdhk5Vs5zfob/oRkS22YVwvE
	 9ctwQ1+AqKOVimiiWzAVqs/TQgZg2HOTktggOfpLZh3Suk6syCfNKi0yyOR3e83vSz
	 TLAmts2y/e750y5m0ukDcwHblMQiyyUtAMyxQ5Byvy5FEVfYT0tz5dLmFYwRCykPWh
	 XLK7zvj4B1Wsw==
Date: Tue, 8 Sep 2026 10:33:17 +0300
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
Message-ID: <ap-6PZqGZHhPD6u1@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
 <178877845406.3691569.12554855722197968629.b4-review@b4>
 <bdba5b54-8733-4d47-952d-e1bd958a1ead@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdba5b54-8733-4d47-952d-e1bd958a1ead@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DCF4B120008
X-Stat-Signature: 7q6mm3i1oru16if73f75n3igddr17mw1
X-HE-Tag: 1788852812-655927
X-HE-Meta: U2FsdGVkX1+Xv00JbZHKHEczgdEV691d/O9DP6mT8zCJVNCcrKhqOiENpGRI2eGlM1UdIfUI8gC1qJKWJEQsHxp9TLAGzWZim9ELoeyHMbasa/wDLIxilLkUJ0voQ1LfR0jIJCs7nlRqMKVdQElbevg1ZBc0jJBEc2mlv/u/3HQoVvx5UfBlKcbb+CZNm/x6AueNEIRpPcJw7th3pHsPcXMK3K729Jaw6dgfScOqNLqy35MXlFHJV+nT672hTNrQvWs5ZF9H1ZEFBUp3s6Tsr0w4mg4oTi0PRdRObMOzwDfFFSkDFCGeGq3wyck9EDsysYRanO8/Z4iOBQHFaMdd9rRINl2X7n9IMb8A5ES8DfSVwVkgM7bOZFJKBkqRXFqosqBzQlhn9Rwcsw4aW+zwjVU4MYICYFYi/jJ8H2vqrvz4BhHAm68n3lL6mOfxOiTk7QZRuYVBDYknpipyJs/3hN3O4NL1c7OaB2PCoAP208j2ZhkdJ9eNlenEKB3fxbVw/hJ8tGtoEVcJm3dcbqrd03fk1ZzLi4C1Ls1lDEc5/3jopKBKehzoT8sV/U/LB7zVzaPnJXIdqIrV+z+QjJgHvHZc3D8P+tMJYGsNSDizqcPqT2Pa7ce00378S+/WplWE+tNqvc8sRU77k7gINtMV28HeV2MmFX55uAQHv2y5jS9F5Ebo4Valxmux8u17lmheri8WnsvDo1VyyPsAWjJrXNS5peKJdvBlNqRVUKkTzMmDwzFCW88VAY6fboZ92uVl8TlnL/WBZixh1EHtBr03I1mlqUo6WY6WO/Kh2KLXTCR0G7DEsNfAHpjWZqN74WjNsdjLvrbaBtzaDJ+9SKf1muYPyNCfMIoHZoQkeKTGxyCCsbSI3/AvjRJAy4eXvJaJJqvReg4aUzLIVI89YvaIHAEOx7dsSBZWyO9J4WuST5MUpqc9X4EWIggaRPDhS+AxHYLLcROvIZDjtOIk/mu
 Ecil7H36
 Qb2hoDK/LMNjSajuu9dDMLWYgTSHTLXUs61Zs90yx5+6PNiC32/y8CutA/r5KQt9FobiG0zSXgW71hV8TD4NZ/lRZdxtyCG6WzdgMLjZf5aJuVdR9PbfUSDHieukNQ3iJiW0rkcaebkD27N2spRrwoNykfBd2mhp2zOCOx1QB540vwk4nFv1XO5px5ZHrBWIE0v7AvXj11wlkNeX+V5OsS0k1TlFYBNz1q/fXdtc47EcBGFo6XGtYDDEREp2QVjppfXcVkept8RcYxZTW5uUSYzVJ1Y9d3x1g//kJzZ9SDz3ovA3FZF53BEzefKQa4knLtmfiUkTpEo1gXngbipOfVUWANQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 05:52:32PM +0200, Kevin Brodsky wrote:
> On 07/09/2026 12:54, Mike Rapoport wrote:
> >> [...]
> >>
> >>  static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
> >>  {
> >> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> >> +	struct page *page;
> >> +
> >> +	if (kpkeys_hardened_pgtables_enabled())
> >> +		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
> >> +	else
> >> +		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> > Can we make it a sequence rahter than a branch?
> >
> > kpkeys_pgtable_alloc() does alloc_pages and then sets their pkeys, so I
> > think something like this should work:
> >
> > 	page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> > 	if (!page)
> > 		return NULL;
> > 	err = kpkeys_pgtable_alloc(page);
> > 	if (err) {
> > 		__free_pages(page, order);
> > 		return NULL;
> >
> > with if (kpkeys_hardened_pgtables_enabled()) folded into
> > kpkeys_pgtable_alloc().
> 
> I agree this would be less ugly. In fact this is pretty much what this
> series did up to RFC v5 (albeit in the ctor/dtor instead of alloc/free).
> We could go back to this API, *but* the big issue is that it makes it
> impossible to use a smarter allocation strategy for protected pages.
> Patch 14 in RFC v6 [1] will give you an idea of what such an allocator
> (with support for large blocks and splitting) would look like.
> 
> As discussed with David H we're first trying to land this feature
> without large block support (fully PTE-mapped direct map), but we do
> want to support large blocks eventually [2] and I would prefer the core
> API to be already compatible with that objective. Very happy to hear
> about suggestions as to how to avoid the explicit condition in
> pagetable_alloc() though!

We could unconditionally replace alloc_pages_noprof() with
kpkeys_pgtable_alloc() and make the latter choose the right allocator, but
that's not very nice either :/
 
> - Kevin
> 
> [1]
> https://lore.kernel.org/linux-hardening/20260227175518.3728055-15-kevin.brodsky@arm.com/
> [2] https://lore.kernel.org/all/aMwd7IJVECEy8mzf@willie-the-truck/

-- 
Sincerely yours,
Mike.

