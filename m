Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200F5C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3EE6B007B; Fri, 24 Jul 2026 05:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9854E6B0088; Fri, 24 Jul 2026 05:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BC46B008A; Fri, 24 Jul 2026 05:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63D3E6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:20:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C859D402EF
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:20:42 +0000 (UTC)
X-FDA: 85023125124.24.6C50325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15A8320006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:20:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwL9r7Hh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784884841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sK+co/kJmG6YP8VnMhZtZK+n9ApW8e/do+0Igtss8NY=;
	b=SHicgd8wkL5/ftKYKZuw8Dm9a6+SsnH7qYMN+jc3TOGT2iDX4UDK5m+4TNiAOScGKRCMZl
	o1ckeZ6FgwS9/zbIs/tRoYYrBsphSMWFGqdhuUHv5S0mOq90Mro/kenAW33Nnl9lVNVlrU
	koZ1vZ3APXyNQsIQDjAbPA/dAkZSUNw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwL9r7Hh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784884841;
	b=M4uQfJyzys0lHrhQoO1JPTpwpW0MwLynbCUX1T5OX6fPJ+3ugimTs8YjvPpdjO9VgDKs+3
	BJlHs1Hnlbz5pnZg8hdaSI63W8/vb3id7w/c76k9sQbgyz0CXyIGng5nHgJZEmKJBU6/qH
	1n7Lf+I4+22Awf2ZgVgyJ63dYmWBRLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC204439C5;
	Fri, 24 Jul 2026 09:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E43A1F000E9;
	Fri, 24 Jul 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784884839;
	bh=sK+co/kJmG6YP8VnMhZtZK+n9ApW8e/do+0Igtss8NY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lwL9r7Hh7relOof30oLbXNAQGciP0LI00Mjhi1C6Yz+HE94rQfdQ6sui104q6tvyA
	 8/iNYuHx5QsBpvHGRjb2xpPUb7DNBCMkSkcLbQwRSgAs4r1mDN8HpQsduhO0wxRQOB
	 QPZDQWIj2jkjYkVfI8IKID5O5/yr+LDE0RgYfyzqpI+hkl7LFZW8blwU19kUBBW7db
	 00MfvbTPlK8tZZ8JmPHQeaX1lqfRjTNrVKT8V1MNHB4lu/p6xghOBgnsSLxXQZyEQE
	 5lsdI6kINwdr55RvMd2VGFcXMAcbeB5mtGaUPbJ8Rt1uAxbnWajJL2y6dzmFCZWCcG
	 rLPim2PrhWj6w==
Date: Fri, 24 Jul 2026 10:20:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, 
	osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v3 1/5] mm/rmap: convert page -> folio for hwpoison checks
Message-ID: <amMtRejoVMX2IV2V@lucifer>
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713050050.1017741-2-dev.jain@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15A8320006
X-Rspam-User: 
X-Stat-Signature: 1e6pmqq3c68oao9r4jxaeqg6icer67fw
X-HE-Tag: 1784884840-438778
X-HE-Meta: U2FsdGVkX19BK8GGpQ/sgJvcwyFk41iNWoIGPIxGprMHqRGIqmVUXLHCLKnl47ul9ztX7Yb0axz8jESYvx52dXdXngO+YN+ZZO2UTvxET3vGOciPh+urGFIPUwMoSwCINV8iTM+wMGrGm/xdvZeidbSa7dTYK4awt6YLFzdNUr29Kn7R7QdhiV1p82umhgr1HKIeeYOaMH3+h+HA9xJpGHTSw/nvC8pdylJujcGUQPtUtz89gI4gCWTBDGz2t4gi3nC4/fJlLazrfU82gCLv1cPQCJT6i9Bjbv5C3MbVHjDpc8PRKkVOraTDXMv+MPCYkum7qLASvvUnAKkv5c/thwNkx8Kx8UHyj1lYFne32lcRMlz1sVu4MCMInk8vmfyW0j3ZBFdAXJsztlB6vuGSxRERdrK1HKGw2kjJiktb8X7jYTCVHwosYO2fU02MIi5VCCcFos2S9dCObSeeWMa/lN5CALd9/aWQ6JbegZwIQLG0Bel0Q4lJMDHSDNLvv730q+sMFsg9Ki3oZehTCvW8xSEfu8iN5N+sq1qmQWO6Dq1bTfp6TVBMwYU/tPlCNdHO19vboxPCCkssW5SuaRHEVbSbL4vZDFCfkwtz7pxl9xmchucnNdzEX/x08MY1i7K5UiFkyCSx6EO0eCJQA0+EPbMaY3RjODVwFRKhoZAzJXgpjYXriOmUFzR2OinwL7SNYldM25c18N4Y5n+xAuKbdV0FonTTV6LSnGAB67sL8jgwlGCJVtXnmFKeNOhlje9O3MewUR+LsD99MhL7SVHeSILrHF8u9HkJGTtqn709waOGS/9RbhmqczMTwG9LfpUh/NQKEd7f5oYqnJ0rsjOAnfN/gxCHgeLh8b+ckwqYdmTX+gnvTHUnQEL79TIb6aQcDDyTMRAnEJkGKr05K5YaAs/rKC1QSasMixHjr0rxl9JFbKIT2CnAM9o3+9c8dUl/4NSMYsXKlY/aEF9dzzu
 K/2+eAv8
 vaRSklCBBlY2bnDyXLniaERiDAbAMygLRkCCJebX/t5SEtnO4T84WyITfZjKFIVZzx6nPLoSgDO0MzhjcOkRf2y6EDQw5IkSDC+5QCyyS+QYjRMU2p2EurXk+gZyh7RPcz2ktaAv4GQjPNUFU6pNg9pkfQoLq26Ne7Uf1Zm5CjMLZNimp+MUCzmrtDZhmfGxcDpl1KKSi9eH3sq0IXVgR4oHJuYbEt9XvCgSkM/Wf/fdppKvs9PY1PZ3KMrADXfa5/JS3xADDdq5+FhqsazTigcKt5QRjmS3xsovpaZgi+FtpBXwLIU4Xt84djQvmnf2XB2r6PvOpG+A+eCNY/okKr8DsFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:00:44AM +0000, Dev Jain wrote:
> try_to_unmap() receives hugetlb folios only from the hwpoison path.
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

Oops reviewed v2 by mistake. This LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/rmap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 26166a6b8cb9b..2b74668f356d6 100644
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

Thanks for converting this also!

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
> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {

As per v2 discussion, I feel this could be tightened up, maybe something like:

		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */

>  			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>  			if (folio_test_hugetlb(folio)) {
>  				hugetlb_count_sub(folio_nr_pages(folio), mm);
> --
> 2.43.0
>

Cheers, Lorenzo

