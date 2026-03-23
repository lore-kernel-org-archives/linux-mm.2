Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D349F4610D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73A06B008C; Mon, 23 Mar 2026 09:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24B86B0092; Mon, 23 Mar 2026 09:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61EA6B0093; Mon, 23 Mar 2026 09:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A64F26B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:26:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A3188CD25
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:26:30 +0000 (UTC)
X-FDA: 84577402140.16.500AC52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A88B718000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:26:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iuU6VXYT;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2ZwlcV0snKw7sTklAUSuJzWJ3BlnWp3hwMs3i9tdmE=;
	b=YrCE2XDyeBl9J0MECt6/Pt5gDA9bIuOOGNbPuI4NJcL8uV3fWiJkcs0HodmfRL0l+EiHSQ
	6uRBma52zOcAWwwD6/LjGSZrVERAJdXqM9bveLZYpjxRBEeMwxAz4o414rKZZBAk+HeTlU
	Ho558beO1a/lga898oL+ab3qRrJsAoE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iuU6VXYT;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774272388; a=rsa-sha256;
	cv=none;
	b=3qZVcHP6q3pUoNnGCk8ouQJoPOHS2JjtUaCbIj1ZoXjb6ZYP6XAinpCQlvGa35bCMrxQq+
	l9YvNZwVNgCZJj0v/fZk3mFs1QTfkNJjhJKBTxccDG0lqEfKawrZ8+nxOQgT3DhNRF/dIe
	pE6lUswTZc2ZXc9KCHwu6qlmq32gBe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B5ED60103;
	Mon, 23 Mar 2026 13:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2270DC4CEF7;
	Mon, 23 Mar 2026 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774272387;
	bh=BIUBdhUukoru7ramtIU4Bi2jFIe+TzDF5KP4QRFFFhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iuU6VXYTYtmma+CgDR7k5Tv+Cn15gIN0ICNpizFhE18lKLFdVvLoZugVhJTiHZmyA
	 KhKnmK8PYVYEjCxwvplOkDboewkhJivcJFxDMP83UyccjTUGCs/m3zjt6BBbP2+BaN
	 fNbx8MVpDr+fZBcn2eMPoQxvBm3EjKB1nFrEd/DXDmZKRz91bLM8VlWBouW3nTt5GT
	 jTZrnV7Uz2jK7gHvPId0QnxohqW3q3rN7DSG6/V7dDVGA2/Dt8RDWsL5TAf6CuDTYy
	 zk9ncNSwqx7HwWdynIDdToue02HRUCL5ONeEQkDdd+8LBTSNsjANGKjpeUcNEGeoUv
	 sUCDKHvLD4Bkw==
Date: Mon, 23 Mar 2026 13:26:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/15] mm/memory_hotplug: fix possible race in
 scan_movable_pages()
Message-ID: <5b489c40-bd89-4dff-9669-560b1b28ec69@lucifer.local>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
 <20260320-sparsemem_cleanups-v2-1-096addc8800d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320-sparsemem_cleanups-v2-1-096addc8800d@kernel.org>
X-Stat-Signature: tabf7bgpnmgkybsu4t37p7yrw7ibqbxz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A88B718000A
X-HE-Tag: 1774272388-124569
X-HE-Meta: U2FsdGVkX1+d98Ua5LM1GNtbgq1EwgZiGhhbKmakOd7agJLk+GF+Zr2yfr/BOOCngSVJNp3boJVZsultTkTsusKad4KTsi6xQ6dn4/zCODYiOYWNhcvBKe8jfunARSZXLFYSzOciKLSix9b5eH9R2c19Io3YB0dM6SjzPx38CSJWIAgOPwYLrTFvuKlmfN86Jj8EnOGTsepHYyvXuxIGAIr/kNZzxX+WeUSMtif7Vg2jkx2jy/9sdQfULbHv52QhN3Hg1S+LNoMk+lsPY8bIhjXJS5Lm2FCqLZq4YfiqCIhpsuH/uJQBSPWxH4yPq1I6H3e8LzNlpMNdBfK9uql98Rzt/9nbwRLgiaHBQvkYFlrix3LHrShyW/P2yuuNI/3BFWmY+M+0oLW6BOpJc57UC3ZT5XBT3yVMrY0jwSDePM3CDv7c9XRnD/Uy7Cd+q/r72MxFtcDFLM1B377+Cp+QZsMAD+0sfiUDeEyjNcijub4RnlrhEhOZdJ1wZdzVRJyNPHfx1beIsZjtpXV3Nn3FKlMLG6+CPi3AVcm/z8Tzg0ByqkwwtTgzMOekuzGgRKBHSO5ZFRfCxWAzg8J1V5f7S6PdfkpsU71wlmnnhcnboMll3a6AhpgBVWhumcOpwAg6XfuNULHiuPQjKB1nkhUlTk72NapIkyCr3sr96pdyZ5hn9rrsAaBWmYVTTHJWZWc0OwZ/AB6FSAyY6QUeyizOptzdU1GMGPb54K9rFSFs4KF+K6xPayM/opJVzH71jar6doq85z7VJDjKwUpYSpa2zXVSczQP+1pHRhmj0UZBVPf2xMMoym4QQSiQSX+Q+czoVlQ6/L83Yilf6pjtyfcD9b/ggwqxz9beAEe7Wr31gBUDr8ABseddXAMFb1zxARlLwpNrTXGrqb+T3WaEaxXT9KsauVz6VVdJrGBPaCwpXjReKxNxXii39vYaWy29rnjdhLLYrGW7Rr5EnBDsdD1
 tgATw8Kx
 3cvtUE0WFnz/kawm9s9OV6jjqPz8skHBy5ZXwEUgPIAl6Jmhw2sMu9fzIS0ooyTDxjaZLfzVWOb57ratSlNCmggtwVgZHbvyE1zLPjXQjZ/U/P8mmAe7L/9eCvjf6gM7r2FA5ROuP/onyQOGFdfzgpriNsbG/1ruOrLhrbrZFi1PS7B0pa707y2WgYx4iawpitqaiWrdspIdtf7Tk0TDqGH6vXo6JvTnnDnMUv7ljb6zvWxzRRzG4y8OWkbwCtsHF4WGoa11bNuslrHkKom8iMNLE+iM5AULhXsTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:13:33PM +0100, David Hildenbrand (Arm) wrote:
> If a hugetlb folio gets freed while we are in scan_movable_pages(),
> folio_nr_pages() could return 0, resulting in or'ing "0 - 1 = -1"
> to the PFN, resulting in PFN = -1. We're not holding any locks or
> references that would prevent that.
>
> for_each_valid_pfn() would then search for the next valid PFN, and could
> return a PFN that is outside of the range of the original requested
> range. do_migrate_page() would then try to migrate quite a big range,
> which is certainly undesirable.
>
> To fix it, simply test for valid folio_nr_pages() values. While at it,
> as PageHuge() really just does a page_folio() internally, we can just
> use folio_test_hugetlb() on the folio directly.
>
> scan_movable_pages() is expected to be fast, and we try to avoid taking
> locks or grabbing references. We cannot use folio_try_get() as that does
> not work for free hugetlb folios. We could grab the hugetlb_lock, but
> that just adds complexity.
>
> The race is unlikely to trigger in practice, so we won't be CCing
> stable.
>
> Fixes: 16540dae959d ("mm/hugetlb: mm/memory_hotplug: use a folio in scan_movable_pages()")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Logic looks right to me, though some nits below. With those accounted for:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory_hotplug.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 86d3faf50453..969cd7ddf68f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1747,6 +1747,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  	unsigned long pfn;
>
>  	for_each_valid_pfn(pfn, start, end) {
> +		unsigned long nr_pages;
>  		struct page *page;
>  		struct folio *folio;
>
> @@ -1763,9 +1764,9 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  		if (PageOffline(page) && page_count(page))
>  			return -EBUSY;
>
> -		if (!PageHuge(page))

Yeah interesting to see this is folio_test_hugetlb(page_folio(page)) :))

So this is a nice change for sure.

> -			continue;
>  		folio = page_folio(page);
> +		if (!folio_test_hugetlb(folio))
> +			continue;
>  		/*
>  		 * This test is racy as we hold no reference or lock.  The
>  		 * hugetlb page could have been free'ed and head is no longer
> @@ -1775,7 +1776,11 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
>  		 */
>  		if (folio_test_hugetlb_migratable(folio))
>  			goto found;
> -		pfn |= folio_nr_pages(folio) - 1;
> +		nr_pages = folio_nr_pages(folio);
> +		if (unlikely(nr_pages < 1 || nr_pages > MAX_FOLIO_NR_PAGES ||

NIT: since nr_pages is an unsigned long, would this be better as !nr_pages || ...?

> +			     !is_power_of_2(nr_pages)))

Could the latter two conditions ever really happen? I guess some weird tearing
or something maybe?

It would also be nice to maybe separate this out as is_valid_nr_pages() or
something, but then again, I suppose given this is a rare case of us
checking this under circumstances where the value might not be valid, maybe
not worth it.

> +			continue;
> +		pfn |= nr_pages - 1;
>  	}
>  	return -ENOENT;
>  found:
>
> --
> 2.43.0
>

Cheers, Lorenzo

