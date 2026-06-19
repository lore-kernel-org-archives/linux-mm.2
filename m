Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881A6CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1566B0088; Fri, 19 Jun 2026 06:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062796B008A; Fri, 19 Jun 2026 06:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9D66B008C; Fri, 19 Jun 2026 06:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD1EE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:44:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 327421C24AC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:44:23 +0000 (UTC)
X-FDA: 84896328006.09.0DE0D0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 98F4C40009
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:44:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J6qrF8oa;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781865861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3is9oNUkO05ESVUSRNJqZRRZt4O+9EMA6drdEzl8B68=;
	b=c6ix8OgFjdlQpYfA4a5RLhZ2auNwLW8E1nw2ijmVSX8QOC4pLMeSjinWnvW9S/+LoEn5Js
	Xe65ZwdHyqfrbHVDe+xgWDdOtgTYqP1mS+EOxu/pJKdW1uKZlWqY4Hi2i0a0nhpKy2rlwG
	8C6HMdFnVC5rsHFxD4gPsTpH5LxqYHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781865861;
	b=BGKaWrl+MM/Bv5q6wAHrXCKyzj6cDmNZVC1zK1reIjTvwik4H/xIernBhhdDSNpdEeuDUH
	Sj77oT8c7Br1HcbWQGTAQblzqb55BbILhQNf2svdd5+yQCCGzo+vo0DOTrXVZQwx+LYK31
	Pm6rJq3bQI5tJnL+ttX6+ARWeaOjhJ4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J6qrF8oa;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 002BA601E1;
	Fri, 19 Jun 2026 10:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855901F000E9;
	Fri, 19 Jun 2026 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781865860;
	bh=3is9oNUkO05ESVUSRNJqZRRZt4O+9EMA6drdEzl8B68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J6qrF8oa8Ce1axqO5TBKRGUIxxnelyGPH1bxZG5sgabhh0ckucM9dtnfIFtsBE56N
	 hbmcXlxDSl1Z/fkkvWeJLWb69cLX8bxzwklqhWOzw71AF8p187TfF7szkwRlPmV/bZ
	 0l4TWFWcqZdES/1GWna+TDMVFnSB88BbxYcyGJbQfTdjonz+9H0+zfS4tqhPSqNMxz
	 XiIHo7XzMvncEA+sgwxTPmMAvTkUA8v8P0RcpbEyyRIQPBqsd+122+JV2reOC3K/8W
	 67bK6cS2ngFduL9ghXXIqZNXep2MPTHJia5m9k9/W2NtHVs1lqyaQ+AdPuVWbsrOFF
	 Y5eJ4dM57+i6w==
Date: Fri, 19 Jun 2026 11:44:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <ajUXNjRMraKb6k2n@lucifer>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616063436.20455-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98F4C40009
X-Stat-Signature: 3mog3qaj77x3htxwdaxgcgrpgp396un7
X-HE-Tag: 1781865861-289472
X-HE-Meta: U2FsdGVkX1+GXxkq6dhrbpoIEAbe7LZ2sL7ATy8+RDFAb9Kt16CxQc0wdCeb9/Lv9M8mxHogKDx13F8T6aA2xWE6liRenj5h2M9APOMb1F1agV0KhVnEXxZlYuzBip3cDm46Jc6psXXqaBi15pOdZAR8qT+r6Ft3xyGhOM6n6Z5pXJHJE1XYXRL+SvwnrLvX1y/n9tHunSOLmUSjlXQoKfve4zPAiPDfZ8LEsCiZAkmKA8euodTZUa7ivijfYkBlFNtE5pj+CiGjeKsOz6y2dKrrc/dKofy/P6KYVv+tKhuV7rLEL2EYfjRCQRXa6C7YhqUfUHiYoZTwCTMVqV0tWo63OjsnpyKK2asyicIuMtuO7CgSF4j0+Nh6CkDmxcBBQzBR6NKSOfhY1oCM3jr0HVCATlVajL50vFkW6QWLYd7gWN3y2ZfbKth2BPWoQAkfnL+VALIEPI0ZmqSDG8slCnIgXiE6tdlBJYHElvJ6xN0PhbsAluqT/GFso1O/wPbz9ABmTrqelARlpPwUaOCl/SiSzwCytUzVBxbkkEqWsQaG/w0RMGbOOclqCSLx3PvMF59EEnnzTYp9JFSy0kavSfhIkItS6CdOMu3ihFGLydx4hQG4fXFZEbFVioEAtdUaZ7ce8oWQyZMUAm97OUM0sapuP6y/UxRBVosW1Cky5QlGNhOoeXFnJOyUQujjWx/pykhDJGJ9EW5OxRJDvMMS41PEifA+B2j2KTzX0gxez/M0cvxx8nMaoKoC85vK4ZFnwHN1jgH+c+H3bMkHuvKd05xqQSuR/HN8Y70o3s+9LOyuyfdEsr5xNuV7rYVhiwiTYwwaurDRj5qI46p3t4563lORWo13/32U6mHgPFHDCnbMb3xVzig/8y9mlYZW8jzIjMTkAkVIGbMPXHT95qiZDS4e4NILG7nVYZisbCizIT7rohHGnuPXMRnbe8b5Az4CKtfVwgsBoJo1ZdQQ0Ls
 P8ZhB6r+
 QvVtnKwiXqOMsTvg55EnrgEysxh66qji+5tV/LXn7KLEu4QIBWzCOWNKuL7/yc4J1+SsySPQB+8FyACadLNW8EMtx3y76qxRipIlnY0PFmNB/Y+k0jjHM4hyz5WVVLmwT5O+uykuKjhn6H2j0BfE/D3iwwR5mnil/NFASpK+hOJhrcl2gOgBIqHxAZTpexSRY4+wYLQeHy3GTEPrq09wgxO/ntOdF1yyy2nrlyLlFRviltNyjSzAd3OYJyGqtCPVcz+mdYEDzdl18q1RKCy+lns/LD9aJINg/bWVt4lq1Tnol0ufWd3p0lLIBrC3iofcufctY+8+SS3tWlAoPjvIHrRm9yO6uuSLGDJjXCGt+uQ5BCrRos5ycgqmhNKpfCgFBha0bJyzSdnKs9ODbGoIpxIRQ5QIltl5cBY+s3j4yAaQYpM+DVQJaDdfcGaMF/2FUQ8JFtiFoflmJOg/X73L9AJSLeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc wrong email

On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
> before return the pmd entry:
>
>   * re-validate pmd entry after PTL
>   * check PVMW_MIGRATION
>   * check_pmd()
>   * handle on pte level if split under us
>
> But for device-private pmd, we just return after pmd_lock().
>
> This may return improper entry, e.g. if we are looking for a migration
> entry, device-private entry could still be returned, which leads to data
> corruption.

I don't thik this is quite clear?

How about:

	If a softleaf entry is present, the existing code simply acquires the
	PMD lock and returns success even if PVMW_MIGRATION is set (indicating a
	migration entry is sought), meaning that the caller can incorrectly
	interpret the entry as something it is not, causing data corruption.

>
> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> support device-private entries") by following the same pattern as
> pmd_trans_huge() and pmd_is_migration_entry() for device private entry.
>
> While at it, it cleanups the pmd entry handling in page_vma_mapped_walk().
>
>   * Instead of handling trans huge/migration entry/device private entry
>     in a mixed manner, we put each case into its own if condition and
>     handle with the same pattern.
>   * Also we grab PTL and make sure pmd is not changed under us after
>     above check instead of do the check with PTL hold.
>   * restart the process if pmd is changed under us

You're doing quite a bit for a fix and you're putting it all in one place.

How about do the fix as 1 patch, and then cleanups as other ones? It helps with
review too :)

It's a general rule of thumb that if you do more than one of moving, refactoring
or changing code, to do them as separate patches so a reviewer/somebody
bisecting can clearly separate each.

Also PLEASE do not add new functionality (this lock recheck) in a fixes
patch. We'll end up backporting new logic that way.

Make the fixes bit _minimal_.

I think in general Andrew prefers separate fixes patches so I'd just make the
_minimal_ change that fixes this for the backport, and the cleanup stuff as a
separate series.

>
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")

Hmm seems the device private stuff has had a rocky road of late!

I wonder if we need some more test coverage on this?

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Annoying nag: You sent to my correct email ljs@kernel.org (thanks!) but also
cc'd the incorrect one, please only send to ljs@kernel.org thanks :)

> Cc: <stable@vger.kernel.org>

Be better to just have this with the Fixes tag, Andrew adds the Cc's from the
actual cc- list anyway.

>
> ---
> v2:
>   * specify the possible error case of current code and user visible effect
>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>
> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> ---
>  mm/page_vma_mapped.c | 63 +++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 33 deletions(-)
>
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index 2ccbabfb2cc1..21635fab209c 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  		 */
>  		pmde = pmdp_get_lockless(pvmw->pmd);
>
> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
> -			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -			pmde = *pvmw->pmd;
> -			if (!pmd_present(pmde)) {
> -				softleaf_t entry;
> -
> -				if (!thp_migration_supported() ||
> -				    !(pvmw->flags & PVMW_MIGRATION))
> -					return not_found(pvmw);
> -				entry = softleaf_from_pmd(pmde);
> -
> -				if (!softleaf_is_migration(entry) ||
> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> -					return not_found(pvmw);
> -				return true;
> -			}
> -			if (likely(pmd_trans_huge(pmde))) {
> -				if (pvmw->flags & PVMW_MIGRATION)
> -					return not_found(pvmw);
> -				if (!check_pmd(pmd_pfn(pmde), pvmw))
> -					return not_found(pvmw);
> -				return true;
> -			}
> -			/* THP pmd was split under us: handle on pte level */

Don't drop critical comments like this, that's very bad.

> -			spin_unlock(pvmw->ptl);
> -			pvmw->ptl = NULL;
> -		} else if (!pmd_present(pmde)) {
> -			const softleaf_t entry = softleaf_from_pmd(pmde);
> -
> -			if (softleaf_is_device_private(entry)) {
> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> -				return true;
> -			}
> +		if (pmd_present(pmde)) {

You're not checking pmd_trans_huge() at all now? Just assuming pmd_present() ==
pmd_trans_huge()?

> +			if (!pmd_leaf(pmde))
> +				goto pte_table;

OK now assuming pmd_leaf() == pmd_trans_huge()?

You didn't mention this in the commit msg? Justificaiton please?

> +			if (pvmw->flags & PVMW_MIGRATION)
> +				return not_found(pvmw);
> +			if (!check_pmd(pmd_pfn(pmde), pvmw))
> +				return not_found(pvmw);



> +		} else if (pmd_is_migration_entry(pmde)) {
> +			softleaf_t entry = softleaf_from_pmd(pmde);
> +

Err you dropped the thp_migration_supported() check? Why?

> +			if (!(pvmw->flags & PVMW_MIGRATION))
> +				return not_found(pvmw);
> +			if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +				return not_found(pvmw);
> +		} else if (pmd_is_device_private_entry(pmde)) {
> +			softleaf_t entry = softleaf_from_pmd(pmde);
>
> +			if (pvmw->flags & PVMW_MIGRATION)
> +				return not_found(pvmw);
> +			if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> +				return not_found(pvmw);

I mean it's less awful than what was there before, but as refactoring goes,
putting a massive set of branches in the middle of a long function isn't really
the best.

Can we avoid this horrible goto by separating this out into a function?

> +		} else {

Else means what exactly? A comment would be good.

I feel like in an effort to keep all this at one level of indentation you've
created a confusing else case.

Sane thing would be to:

a. have this as a separate function
b. to do:

	if (pmd_none(pmde)) {
		...
		return ...;
	}

	if (pmd_present(pmde)) {
		...
		return ...;
	}

	softleaf = softleaf_from_pmd(pmde);

	/* softleaf stuff */

	return ...;

In this function.

That way it's _very clear_ you're doing softleaf stuff.


>  			if ((pvmw->flags & PVMW_SYNC) &&
>  			    thp_vma_suitable_order(vma, pvmw->address,
>  						   PMD_ORDER) &&

Umm... previously this was done for all softleaf entries other than
device-private, now not, and you haven't, why?



> @@ -286,6 +274,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			step_forward(pvmw, PMD_SIZE);
>  			continue;
>  		}
> +
> +		/* Double-check under PTL that the PMD didn't change. */
> +		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +		if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
> +			return true;
> +		spin_unlock(pvmw->ptl);
> +		pvmw->ptl = NULL;
> +		goto restart;

I'm not sure I really get the justification for this? seems you just added this
arbitrarily?

Again, you shouldn't be making changes like this in a fix patch.

> +pte_table:
>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>  			if (!pvmw->pte)
>  				goto restart;
> --
> 2.34.1
>

This is really hard to review like this, as above please split this up properly.

Thanks, Lorenzo

