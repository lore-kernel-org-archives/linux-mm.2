Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04497C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFC906B0099; Thu, 23 Jul 2026 13:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4776B009B; Thu, 23 Jul 2026 13:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEABE6B009D; Thu, 23 Jul 2026 13:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC52E6B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:16:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E5CC160562
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:16:12 +0000 (UTC)
X-FDA: 85020694584.14.5193BE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A7E2DC0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:16:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a91Ja4pk;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPI0I1SZnTvGKpqikQwr8QSqAd3TK/AxzSKHu/nFwbM=;
	b=1Bud2j9SqwKcIURpGObxwCUtA1FlhimpX65IWfyGLVu44CrwIcYat43GwqlI5I0pWwiO5Z
	9vXFG9OYmSlJb/w7k4HGga2rba6ru+wAfIVzUdX0MC/RJYBZ6N2SOzP4uE0712FkaJ6pqj
	qKRxzji0+flyW4FAOQ+HaV53b9fYs9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784826970;
	b=jC34tNXDelBtRMyWnHLSziuXK+cyYJ+NByRgUwXXYddRPLePnIPXzVBtBfqjD4kNC154ff
	TDOhLyd8cPQTXaohW2iwHYY+jklSo2emVvCSwWitTzAWgjDn/CZkpBrMJ5kIsFo86UFZDf
	tVyKcxAqcaXBSNIIrmwFlijEPsNlusY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a91Ja4pk;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD78E41288;
	Thu, 23 Jul 2026 17:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981DC1F000E9;
	Thu, 23 Jul 2026 17:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784826969;
	bh=PPI0I1SZnTvGKpqikQwr8QSqAd3TK/AxzSKHu/nFwbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a91Ja4pkPFklSAR319qDqsm3kB/UTDdEb6q6mXYT2v0zJDeC8m0klOVfMIVWdYKsB
	 /Odo9jiAysHptRQg9KgDpdWt6UgCsAL9P3iXgJaTD4VtpTXTFSLbBjvbU4aUlQQTTC
	 tAse9zBNc+cNyYdP3BjIcyBboBU7D8G5KdudWDETco7pCQCp8sIYAgQ8t/05Pq7bwK
	 jR5p9TXRn8mRxz40fSLv+P4/irIfW8AFpMBDOJd00rRPMzOGo88nWYms5GyBk117FJ
	 uJyTZpYftzt3zIB4n+XALKGwsBalzzduTdZNIM+G7/7BYIEpGQcx1JWKJgmsgmPqC4
	 PG3Lerzt5KkCg==
Date: Thu, 23 Jul 2026 18:15:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
Message-ID: <amIzQmZ3eeYiVXo4@lucifer>
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710055915.638659-2-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A7E2DC0007
X-Stat-Signature: mznnayeoqroo8jyyoa67suufqn8sc7im
X-HE-Tag: 1784826970-80399
X-HE-Meta: U2FsdGVkX19KP+GdE/V75k24oi8aj3CA14M54EGmhByaVO8/et1nqFtmwieEPsNcnIk4Tk4WDtn2Z+PMr5CZ3IcbO66i0Z44xZiVDHDALZZsKKqGiwp0UNRKbgaIgiu8mP/ltg8Mw2FieW32ySe/grHedCxBjJJMqdNiz991ZzQZAxftIJiakcXXSWM7FIFRfirKmhOqTZW8bzwuVdC8j3Y1X3vwwukv10Kk2tVhubpPnMNTfrwrnAUu1hqbcwxkSkTSTagXXIlXeRNhdMl4z9rM6lgekgx+Wxg47U8yzahPZneqkscH7lSuO/+MkZQh50tOIr0OzW7dYl0KdMtfG//vyfjCtHOlWt6WTdbrJAV7HOy2VOffsQYB/zxLJfW01QyRZQ+cEymxW5Nv04zXLVflMeZ3H5dplTqPRlaA8coiGyUYssKYf0YBAqZ9dtvT9P0rnAbTcU1DaZaHG+8MI6q7Pip/vO7Ea2xbz+bggGmkDcbnwTBfpM0PAUJ0WkXR2KvyWfDLQz/w5uXKIT1GhxM3yww3zKWRz4ep3nlUnGObgZMzl5wBQhlaNW0fGb+ukXkbRKV0ArPbCXs4id1jvZGoTSIFdhPvM2mTlxNq96cFlpzY2JGaMNev2wRXT+R1mRh/rbQT6v35IV3JcvArBkBj5gOk0VJAFvK85xQjWy+YHRjR0KROjViLehc8vFV/VYpywDOBbctluVuquXIEA48ro6OV58pACsbre8r1YNX3P9fk2uvoXIXcYM72oGAYw0cx4HbUNNNJLloAAHJI1JUG7p4k7PPYsN8OAsRchIUqVG0p+vHGDxNv9nr3735QMvdc1ia9GX1Yp89VVma7ZC7ywqzg+Glxzs3hpX1m0q0AthDT8F9xgFX08x/eswiAksufkWkvxOnwROtxqmXjPJxttcpeG116Kg/fb63Sb8pw7MOz6k/TYCkQfBkwTrR4PoafRdFB65izZ7ozVfq
 xeMpLkVD
 aOUJ4kmrlVdn4BFp6YJQbtigCTgVUshqSGto9Zkm3PhotoT3vu7ov3ZWpe+LUf1QJxUNHEVdlLcso6TYay44wuJzZWNTQIxQMlBp2nY+JvaDrv9bB6C2mvQfnjUoUOhW8uuzHeecLAKxRtsUP4cReyyJf7vP5ilZFly6/3LnMHikXnZFpezEH7JOBkg1V/Puqm5zxdpCjNe4dTxyZLFe1DODqNZARw0kRGpOY1OJ5qdRtlAppWTMK0q1mTQxNexuuLEY3PhOnXzFuizER76+AG4wqkKf58edkcxLH53jW2/1g7RZ1AHRbuTBoXkw9LhdxounT10Wzx8mvT38CqEUH2CzsmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 05:59:10AM +0000, Dev Jain wrote:
> try_to_unmap() receives hugetlb folios only from the hwpoison path.

Horrifying :)

> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
> the head PFN, so the previous PageHWPoison(subpage) check happened to
> work for hugetlb.
>
> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
> folios before calling try_to_unmap(). Hence it is always the case that
> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
> marked with the poison bit.
>
> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
>
> No functional change intended, except that, while at it,
> convert VM_BUG_* to VM_WARN_*.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Small nit below but generally LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/rmap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9939400e77c79..dbb077f8443e3 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			bool anon = folio_test_anon(folio);
>
>  			/*
> -			 * The try_to_unmap() is only passed a hugetlb page
> -			 * in the case where the hugetlb page is poisoned.
> +			 * The try_to_unmap() is only passed a hugetlb folio
> +			 * in the case where the hugetlb folio contains a
> +			 * poisoned page.
>  			 */
> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> +			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>  			/*
>  			 * huge_pmd_unshare may unmap an entire PMD page.
>  			 * There is no way of knowing exactly which PMDs may
> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
>
> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
> +		/*
> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
> +		 * folios here for now.
> +		 */

I think probably we can drop this? It seems implied by the code (David comment
similarly I think? :)

> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>  			if (folio_test_hugetlb(folio)) {
>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
> --
> 2.43.0
>

Cheers, Lorenzo

