Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCB8C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22376B008A; Mon,  3 Aug 2026 10:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2336B0092; Mon,  3 Aug 2026 10:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7C56B0093; Mon,  3 Aug 2026 10:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF4596B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:47:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A6F116073C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:47:42 +0000 (UTC)
X-FDA: 85060237164.04.688F942
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C152140005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:47:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhfvJWU4;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785768460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0EAKf8A0GnBdHePkQ6maEdXl/7QvO18LuwY19Dez60=;
	b=Wo75EozI0z+TvbygDEKLOY8107gWPI/6lE/BViRk3SlwhcKNQodQDxCdmsSJEMyLk0Xjro
	7F/I1fXksezfuj/JJNCOB9JBhTSuymgdvK2NsZJ8C6+vUvmhf+zSHQzlSJKyHlVms13UwC
	7qriRJIFyHAFudDBCethIfAzr4YgRxw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nhfvJWU4;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785768460;
	b=hssVdf+qP2wfjar2pTbcCUkv6RGhKFUvzKJEL+l7atpSXKB35Fu5RcMonlr4AG/kgC8VVp
	3CIUKwBtNzpR8XkZ8K0DvkAPA2eDyF4HAiXGnvg/KRScqnY0L65wL3iJQRTH20CUBnW4b0
	jYymceu+VwtRZ7iKou2lIQoYuXgELVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D548407B5;
	Mon,  3 Aug 2026 14:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C871F00A3E;
	Mon,  3 Aug 2026 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785768459;
	bh=c0EAKf8A0GnBdHePkQ6maEdXl/7QvO18LuwY19Dez60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nhfvJWU4aQxawKfpm5J7RklUcx9M21dt/pMTGDEaSSwV48U4YQlHqyHOPo/gxBbHO
	 NGLIx8qLNt+AE/hLO8Qk1JlI9zYJM5a9WbADVTEJtNEQlUJFt6w5ymrwOO4agYMHqU
	 1hxXMdTQn97AZhTHV/rCnJ5AXjsumYUxVoLAGyUpgKOfsgjSSBHg75f0VR0+bG08pZ
	 2pUE/vd6SjLY6FQnmBoO9TdXtIxHtLeOWqyf8DX1ZaEkugMKdIbKUOixNKqvJ0gC5a
	 3GfqSolRK0K1yODMwIk4z52THrG1Z1jcvlQaeIl5G8o/iuH+6JHetHLA+xkGgMzidw
	 ydW+ZZjR4y6+Q==
Date: Mon, 3 Aug 2026 15:47:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, kernel-team@meta.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/gup: batch contiguous pages in follow_page_mask()
Message-ID: <anCoXcrTjQu9SPhu@lucifer>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C152140005
X-Rspamd-Server: rspam01
X-Stat-Signature: 6c8ddg3nzoq9gzouro1bdjjohwwc338c
X-HE-Tag: 1785768460-661745
X-HE-Meta: U2FsdGVkX1/lWEjUD9Sj9ZRli+g3rkxQiDEfk563dvbLK3HdutltF9KblOjeBn1DGrEUQ+VKhi3EgtWdRhz/i6mmB51pV7akvtJ3eIxPbfGZeuou2CwPvAVicdgSIrZwqDE+Z3HSygbtPD2StsTo9St+ZjbC2f8zXMuY8DHELgUAtq3AiDBsbUPnWYI8x6zA2p3qJEaBTf9hYeU94nyqPPfVvZmXaMn7Vm4ViSgVQH2zoqQw72TZfxf4+uTLnH5dGXfyO/XokXpfKo3rjqWOmlxF1EuSdl+j/5lWjNql9IgLK8tKC58YqMJhqEYJF7h9IsPvPxLewIudrWcEAUzrPi2aFvvz2jtbQv/mlR1OR88AU2qXTU2/Bc0q7B2WWm/7SZuzvlWn1SkBMRRCBDQ1bblAUE60ArNHSaQCgV1nRVCTeMbQ42eQ9kK9bfbq6K9kWLweFRQ+rgvfcH3vGAM3soGa5kcIoy2d8UbBEb6vtW7RTWHSumksQZyN55DPF62x01bxsZlNsgwty9MZvQ9ZVxV3GId/PaajzGG6Xdn5bLt7/HNpnpp9ouQGyUBgbY83TA8ix/i8k3a1BxKbAMr1GxYquw3uPTJSt8tGYWBqPbqwrv+PgyU5FbwqPZzVshX2/w3l5stnqGL92sltRQJ1MVQorHenz7dhTqpSF1bIL0YPIPI9gFaxA5IaYdJr73m1Cko5ESxsD6TPUrPF93dYsqrWq+UKQF11RuB9a1fx4Uu7PeghRR2n/4eE7ApXqLoj0IMk64csxrsGmoGf0Xis3ZUHGuEUO+rvjmF0x2XP1TDgGYzFx0mnd7nngeknknlgUblac/7gBcnn3S2D8bq5UallkqJiydb2yywppLYe3+hDEgqdiqCxRgo8xUrRVsL4MeSk/BHkSRMcKU2JWN1G2xB+FxhtCx8hxC+M+PungljZLNs4crKVwvyh+9bAzEYcjsPDWh4wHrWDC+p99DR
 37g/vMQl
 7oNEHK4ey9Dj60O8eR+xjqEdj1Nt9CyDBZmwbVRDTzRp2kgIbmUcb3is9v+Sll93KU37hdk6vZxqesWDEjMWMil4xL08QWzCCVtbC89wjTcX8pwcwEkiYG4ga6hdzPVdmA5AxnIEOLGIiFh18+tapX77fSxxa1ujOWSypMu/SgcPoJ8z08Bp5IW23OzJOUnujbW7I8Ak1rvCsezxfslZ8XRmnvblS+42s2Hh61XcWZ/tw0e68DzsfxKHlIqbROTWuqJz4wM89JQ9yZv/VGf0BvwtnZEIHPLerj1ySyG0KU8JLTIWST2U4lEdnfwTlsLXcwjc0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Why was this un-RFC'd? The only review the RFC received was 'please don't send
unfiltered AI slop'? :)

On Fri, Jul 31, 2026 at 11:15:35PM -0400, Rik van Riel wrote:
> follow_page_mask() walks the page tables one page at a time, even when
> the caller asked for a whole run of contiguous pages. Every page of a
> large folio re-enters the pmd/pud/pte walk and re-takes the page table
> lock.
>
> This series changes follow_page_mask() to return a page count and a
> new @end argument bounding how many pages remain, instead of a single
> struct page, so a walker can hand back more than one page per call.
>
> Patch 1 converts the follow_page_mask()/follow_p4d_mask()/
> follow_pud_mask()/follow_pmd_mask()/follow_page_pte() call chain to
> return a long instead of a struct page pointer or ERR_PTR(), with no
> functional change: every path still handles exactly one page.
>
> Patch 2 is pure code motion, splitting the "commit to a resolved page"
> tail of follow_page_pte() into its own follow_page_pte_commit(), no
> functional change.
>
> Patch 3 adds gup_fill_pages(), a small helper that fills pages[] and
> flushes caches for a run of subpages, and converts the three existing
> per-page call sites to use it with nr == 1, no functional change.
>
> Patch 4 has follow_huge_pud()/follow_huge_pmd() report the huge page's
> real subpage count instead of a separate *page_mask output, and
> retires *page_mask and __get_user_pages()'s dead second
> try_grab_folio() call and subpage loop.
>
> It also defers gup_fill_pages() past the pud/pmd unlock, so a 1 GB
> PUD-mapped folio doesn't hold that lock for a full array fill and
> cache flush.
>
> Patch 5 adds follow_pte_batch() and has follow_page_pte() call it once
> per contiguous same-folio run instead of once per page, so a
> PTE-mapped mTHP no longer restarts the walk and re-takes the PTE lock
> per subpage.
>
> This is the only patch that changes the number of page table walks or
> lock acquisitions.
>
> Benchmarked with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, pin_user_pages
> + FOLL_LONGTERM, 256 MB region, median of 16 runs, folio formation
> verified via the per-size anon_fault_alloc counter):
>
>                        before      after
>   4 kB base pages      2721 us     1198 us   (2.3x)
>   64 kB mTHP           2929 us      201 us  (14.6x)
>   2 MB THP               73 us       69 us   (flat)
>
> The 4 kB result comes entirely from patch 5 merging two separate
> try_grab_folio() calls and lock acquisitions into one; folio size and
> PTE batching play no part in it.
>
> 64 kB mTHP adds the walk-restart avoidance on top. 2 MB THP is
> unaffected, since follow_huge_pmd() already handled it in one call.
>
> Patch 4's lock-hold-time change is a scalability argument, not a
> measured one -- it is not visible in this single-threaded benchmark.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
>
> Rik van Riel (5):
>   mm/gup: convert follow_page_mask() to return a long
>   mm/gup: split follow_page_pte_commit() out of follow_page_pte()
>   mm/gup: add gup_fill_pages() and use it
>   mm/gup: return a huge page's full count from follow_page_mask()
>   mm/gup: walk multiple PTEs per follow_page_pte() call
>
>  mm/gup.c | 532 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 322 insertions(+), 210 deletions(-)
>

No link to https://lore.kernel.org/all/20260730035350.1fc95dd8@fangorn/ or
change log to indicate that this is the un-RFC'd version of that (or indicating
why you un-RFC'd it)?

> base-commit: fc02acf6ac0c
> --
> 2.53.0-Meta

--
Cheers, Lorenzo

