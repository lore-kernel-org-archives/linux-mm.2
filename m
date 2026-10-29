Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C6E606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZFP7DgJ
Received: by kanga.kvack.org (Postfix)
	id 7A18C6B05CD; Thu, 29 Oct 2026 11:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779096B05CF; Thu, 29 Oct 2026 11:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6D36B05D0; Thu, 29 Oct 2026 11:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 419AE6B05CD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:43:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C19A2A046E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:43:38 +0000 (UTC)
X-FDA: 85376083716.07.179E22B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AD10140008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:43:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZFP7DgJ;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793288617;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9yM1KLFyX8w5TxQS5Xx3fRo+u2p+eJ7n/MGLjnS3Ks=;
	b=BpBzL7PYwEhiiPVhFXYbEke1ERRzRNLA9mcH6oeTlMIFBo7x8m1qWP+WmGarrNKCjY6CC3
	Kt6hb+muCsjXijByCt4eu/+Ri9g0NyjlIbDGbvm57VFaezr9ff6JuJS87hKfzC5IAUSt2m
	ZaTvwgPH8U9AaNkE7yta1sDbh1bMTAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793288617;
	b=xtrcBLWNsrvVi59M+QzBAdnTnOiL14L9bDJO9jH+CDlCIPOtMLVX9y/AilwlDTNARtQLl6
	4Z+gXV+kenLSUcbXUM5BC7JdW7rCAoUusFdUFmkEqJw7GsnTn9+fksbihTnV90OBIxZEa4
	YzwSaftmK7HXr0vLLe9bMMFvCmL1fA0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZFP7DgJ;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63EF340E54;
	Thu, 29 Oct 2026 15:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67ED1F01816;
	Thu, 29 Oct 2026 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793288616;
	bh=c9yM1KLFyX8w5TxQS5Xx3fRo+u2p+eJ7n/MGLjnS3Ks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XZFP7DgJyf1wP9z3wsIKo7XAwlZuhsNdJ8DO83m8S3Rr8Uwqgd7nRZv212r9de3WF
	 k7PchM2YDPXBg2xq0EYpXLumlySdWXwZ3n2Sq3PZ68jS9KxUpt5MclQL/IitHXqbdF
	 5IOMYiiDj/gATMEbeLsFyFpksUA/OVw/4/m6HHFRqr37g7pov58R0O7+WJU81N1ZGc
	 5ugAvRDVk41UG1SykTqJd3TwPBHLC8WXAw+NuYjihWfn7G3TlQPtwj24uLuDbUsTgG
	 4CKk4nT+HdKnKMFgMwoMjZ5XHpNhoD/F6M/ZDyf/2itQxBQz8cd0HcJr0bdRlgmroL
	 OS72WwaBITkig==
Message-ID: <sashiko-outbox-189633@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/hugetlb: clear the hugetlb flag before leaking a
 hwpoisoned folio
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Jane
 Chu" <jane.chu@oracle.com>, linux-mm@kvack.org, tz2294@columbia.edu
In-Reply-To: <20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu>
References: <20261028-hugetlb-hwpoison-leak-v1-1-77ce56002523@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 15:43:35 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1AD10140008
X-Stat-Signature: 6ktxxx5i83w6sydqxawezx9frjp5t7mb
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793288616-584727
X-HE-Meta: U2FsdGVkX19bd9TVINl5sPjvRXHF0k4/UP/HkN8YUV1ZUYP1Yu8Zoa93GyIKg4W0kO+o82qt8o1C2cad2IgbOW/ZQfkXNzoelYx/wsi5mR7Guau4yQgUscVPt9h2TgPru0cuoqHKIOa7HfCcm6KAmg/KpQheJgOYZhTpk6yF2XL8i3S5OMXoWLYk4raruNjtWE+drlE22XIywcgHi2cmozTK7Ns0RrxdZlDO6SRHAe07ULr+VJy7C3/59RK7yLn+8WLO1711MJVepySnt582HSjpFuhVZrX4KWStFKMvNq20SotkaVjMYDURv4jCzFlGT2nTxhNRtU95wkEvGKokSbuk7ywYtMXsLwAMl3cD9d3WQtyLMFNywEFYectm8sudytAd9L8pBdac+E6h5V1RQ4kEPdnwKJmyGu0RGM2AgNVoCeZ/ARNBuwQ/Z4kVgFYAPvj1v7kwW7a9JklfeIquuk3IhEqMKFlXN/25Pbyyt/PBBIcIxjK7jFZwDkSeSOzuj1ErufInIK3gcRGzkAU6kg7hFYG9mCwXTVbQQoN5fLJuqq4DqPj2yQXnvkLBFpvElIqgeYjLlfvr/wIXnn30os+76CXHvvIGHWwjOJldDexckZLtMraeLCVkLKilYurFxv7+dmgQ6MdsXTbf+E1LkVcBeTs7CQf+xQ/7XByfzq0T7aunUQuy2H8GOnNci5su+MTDL7WCDauT8KmHvtbkEOaXlH0VyZ41r0obpfIaJWQGjr2itiQwQ0APw5i9Zi9dZdcRQDkA1Ie2eAT7ParSf3Od+5Ls2TXuq6cpuBK+iBF7QcnkAlVhFaM8cGqvT70RomXfIl2DaCqm3fzSNROomoSOkEFz0X7ppjmQTyygrUJYKxMc79whZQjYFIXHWgpkW545LqTaSiWU50kK1AL/Stoq+TU7GVssMM3RcFidTOsij5uWPMbYDizZhot1C4OOtucxCJP9qcA32vBw/jA
 mR2B4WDN
 IorpKp45THeShPR8W+qITG8iTbGlZpEQJc7izsMylTOYjKe8wFMBA8J6KcilfD7FT4XYQgJfa0oFD2UuzDebrnmS1dE9tQt35AvvZjf76ZoLQJDDEsAenyBTXkA5YFCEKkMahe1yhq4gJxdnIoE/ClqsFG1mzd1k2yY/iLxKnEizIL1XqMIkdh6bXOe9/UKYss/r2cWREU4UE96kmRI1aAbAPFoNNDEVKZLkzFuiJoBfAu7/rwPV5ZgRVi29RliFjLR+mS/BLr8LWCjh7CZKmKk1qXhuO50Wy7IePHF+s3wNPhXMuG7GXp7N6uClpDacwvRWDl0fSukEDDf56WX67OhazKSf4AqDCpaSk82saSnaDcyFRyQ8bMFNbb3puGK73UTCEda+s9tBcGX0PqFA02Az0mhTT17KoB2yy1gm9sRhIENlerjgoBrnTe471vxVM3A7HpxWwK8QfuMY7PAoLL7T1wUGxpRtQoFEaIeuBbi2wuYkFmCXaG+BcMveGQgkwcREX/z4Ro6tp36b9OblCFOMg+1+dAo+1L3FwXr/f8TgHPaEy4KRRWeUCk6m5Ny/hjBf+SDNBdOi/iwq0fyxbke9XBEZtNwajzznEae7cqHPExzrgByrLRvC1YZqSKTn4mrjEPWVGV5W5agI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm/hugetlb: add_hugetlb_folio() clears HPG_raw_hwp_unreliable =
on error
--

commit cae6d1104a254ddb073fab05f2a9308005af88fa
Author: Mani Tofigh <mt4022@columbia.edu>

mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio

This commit moves the folio_test_hugetlb_raw_hwp_unreliable() check in
__update_and_free_hugetlb_folio() to after the hugetlb flag is cleared, so
that vmemmap-optimized folios with unreliable hwpoison tracking are leaked =
as
non-hugetlb folios instead of causing dissolve paths to loop indefinitely.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a008afaedf95..4d6b7ab49502f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1472,13 +1472,6 @@ static void __update_and_free_hugetlb_folio(struct=
 hstate *h,
>  		return;
>  	}
> =20
> -	/*
> -	 * If we don't know which subpages are hwpoisoned, we can't free
> -	 * the hugepage, so it's leaked intentionally.
> -	 */
> -	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> -		return;
> -
>  	/*
>  	 * If folio is not vmemmap optimized (!clear_flag), then the folio
>  	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_=
folio
> @@ -1506,6 +1499,14 @@ static void __update_and_free_hugetlb_folio(struct=
 hstate *h,
>  		spin_unlock_irq(&hugetlb_lock);
>  	}
> =20
> +	/*
> +	 * If we don't know which subpages are hwpoisoned, we can't free
> +	 * the hugepage, so it's leaked intentionally, but only once it is
> +	 * no longer a hugetlb folio.
> +	 */
> +	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> +		return;

[Severity: Critical]
Can moving folio_test_hugetlb_raw_hwp_unreliable() below
hugetlb_vmemmap_restore_folio() cause hardware-poisoned subpages to be freed
back to the buddy allocator as healthy pages if vmemmap restoration fails?

When hugetlb_update_hwpoison() fails to allocate a raw_hwp_page struct, it
marks the folio with HPG_raw_hwp_unreliable and frees the raw_hwp_page list
without transferring PG_hwpoison to the subpages:

mm/memory-failure.c:hugetlb_update_hwpoison() {
	...
		folio_set_hugetlb_raw_hwp_unreliable(folio);
		/*
		 * Once hugetlb_raw_hwp_unreliable is set, raw_hwp_page is not
		 * used any more, so free it.
		 */
		__folio_free_raw_hwp(folio, false);
	...
}

With this change, __update_and_free_hugetlb_folio() now calls
hugetlb_vmemmap_restore_folio() on a raw_hwp_unreliable folio before checki=
ng
the flag. If hugetlb_vmemmap_restore_folio() fails to allocate vmemmap page=
s,
the error path puts the folio back on the hugetlb freelist via
add_hugetlb_folio():

mm/hugetlb.c:__update_and_free_hugetlb_folio() {
	...
	if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
		spin_lock_irq(&hugetlb_lock);
		add_hugetlb_folio(h, folio, true);
		spin_unlock_irq(&hugetlb_lock);
		return;
	}
	...
}

However, add_hugetlb_folio() zeroes folio->private and only restores
HPG_vmemmap_optimized, which clears HPG_raw_hwp_unreliable (as well as
HPG_cma):

mm/hugetlb.c:add_hugetlb_folio() {
	...
	__folio_set_hugetlb(folio);
	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
	folio->private =3D NULL;
	folio_set_hugetlb_vmemmap_optimized(folio);
	...
}

If the folio is later freed or dissolved and hugetlb_vmemmap_restore_folio()
succeeds, folio_test_hugetlb_raw_hwp_unreliable(folio) will now return fals=
e.
Wouldn't __update_and_free_hugetlb_folio() then call
folio_clear_hugetlb_hwpoison(), clearing PG_hwpoison on the head page again=
st
an empty raw_hwp_page list, and release the poisoned subpages to
free_frozen_pages() as clean pages?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028-hugetlb-hw=
poison-leak-v1-1-77ce56002523@columbia.edu?part=3D1

