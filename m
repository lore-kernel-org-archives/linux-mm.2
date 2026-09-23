Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93746C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437A96B008A; Wed, 23 Sep 2026 12:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7E06B008C; Wed, 23 Sep 2026 12:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE756B0092; Wed, 23 Sep 2026 12:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEB0B6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:44:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C623B120834
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:44:08 +0000 (UTC)
X-FDA: 85245599376.13.4D83F32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BE7B40006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:44:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aVfroUQH;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790181847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoOOTxuoQ6EZdspGU37DbBh74bllbiSJrPb5SoDh0CQ=;
	b=3O2Ax7RY7DsUZlrVFpxkehdJxrHHRII6aLCuaiRlUUOALVYHgx+AYzIZQ0+ykJfnnNhQd/
	KFns1A4B96UyYcPnH3eRGd4x3mmvthnIuPn5LbMfGtSEm8AdAcj1d0Z2edzbvmiwDx+8Ly
	5z5XXG0rt4D7kvqxGw029xQwT7KSyE4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aVfroUQH;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790181847;
	b=anYAZGJoQvuvPYgFqZPbfGa5/DQ91ciXZp/ivLGgQziTGtEDCBQG0qZ0iYZmtq6KndD5bo
	pbPkkRBy5iroYKD5VWIIpzi3uWCfJGnpnEOzQ5ftP8Mvyhn23Vf++Tz7b57wl6ap9zUgD/
	ExXzwkrwRZf/zIy65vv29ocbj9sPH6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2224B438B6;
	Wed, 23 Sep 2026 16:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B491F000FF;
	Wed, 23 Sep 2026 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790181846;
	bh=OoOOTxuoQ6EZdspGU37DbBh74bllbiSJrPb5SoDh0CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aVfroUQHOic+0dG0LtM4us94aUGmqKHasYKAZgcYJrcxPjPbj5PP5puWmbXv5Lm42
	 bS+BGz9yKlGjxIJm0id71spz1+rpkhp+PxPuCNaCeDAgzf87xT/KSjJJVcSfAE/pUI
	 HjV76sMIkOY63g05fjx/v73QViQR19pqGlwq981+F+TLl4u7fuB/C0Vw5Nt7oH1Ase
	 GPvWMA44C1MyxkRN3nfJs3XI6FKVEErJZ3j+029Wf68CH3vAWVIxFQwos99gUm5fHi
	 xf/StU/KeKQnZWOAwI0SycRR/t4do0Umk9NjI775dI42NX7pgIw6wG/i5hPFMhcqIq
	 d2mGoCF1AbkZA==
Date: Wed, 23 Sep 2026 17:43:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 05/10] mm/madvise: factor huge-PMD folio processing
Message-ID: <arP4Igew3iL9qVKW@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-6-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922235830.2350770-6-gourry@gourry.net>
X-Stat-Signature: p1htcabc4bm6bu7up3gupxrmpjqxhigo
X-Rspamd-Queue-Id: 2BE7B40006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790181847-926582
X-HE-Meta: U2FsdGVkX1+NBBukdA+fMcfYR0fV17Zkw5Kt4Pta2xFW1aOBaGeQnrQUoDb9gYQRJN+Cm5bGMrZDwD6p3UsWQqXNNyzTVzc0pTkEMNzNxTR2yy0EUXA39JdNOSi7NU76IQrDibAnHYQA/RemguAaPz6IJZNOZgb3wcfFum+XjsAy1cG76AqO6Oza3UPqqJqWlT63qPRWxMrH8EsSm49bY8+MUD9E1UFQ7aeYI58/Y7CokDM5xqW7aCakkrMezKooHuKuLXK4+nJnPFZG7IZEFJSy7lauVHDhQvx5CUY9ONSSbmR6c2aVsmydC1WsU8xLGdaTcIALDS1FEovWfM/gHrM4Qv9PMuOT3GEVcE5bhvdQyOWNvbE5PFWUW4JE3yAm6ZnZR/x5HYoeqcsW78JqoqRF3KK9sR9ej7BfIscxgFhdY65ZbtGdwIyikuYg7p9Dj9T6SvupDZNg+XpL1/oN5NJvQHj4GiP74ajGQYkV7OhGB8QaShlYnfqUEjjLR9sgRV54w3CllDnP8T84GPSVwBl7NoHvH3mqjcZuYKaOAyQ70qkE7MPZoRojqBP4WE357PJBFFwM55WowGOFOImaF/vMMitt3DuOj9N5UxzYWUxlCbyr3HJYJspH4vfv/1on50NHodF8omtByFxps+Q9jeEVexyPK5QbDVnuHcqcyGq4CKOAuy9ofqSxjv9bvVwWJHjE5udGbx8ALOzXChuwoIF3GgS97swgmyIW+QOsi7DurugPPEWVD7VXknBdk5iWapZic1ehSm9jsSX8D3mwDkbqaCQxyWbjOl4/8ogz2nV1xNPyzog27lMQ+xUb490miAD0G9Hly5sbcC8LLp7LKujfe20dhSP7/MveZWgYfvcsg6KUyyniiwvLRC4wzTdeWkTbwvjZWwWHmyoJdwqkdjk8xVdz9MeYB0BaOXqQID1v1UJtZOwNpehPG4oqmfbibD1ZeFfwz75cwKZbHwt
 kYrLDjST
 XvO8S+38thwWxLtDrc04T8bDuQ8nWMWu8lruGdI89nA/wQk0tL671Ycd0YjAvInN1NbNz6XZaatepCoM9DMuXS6FCpEYFCgLw2r1f5GRT7z8t+X5yc+ldeMqr4mlJweUOrPFbfXAm1+uJ0RfFNPrm/NP1zlR5pfN54+urYPSmX18i4LA2hECoFqj3EE98XMmeMWDxHxFHQz+XqlomMJo/AXLvuQTTety39bfn09JInjrEakdWvEUuEVytBmFs04ofZ1c+JMhHJSEe0fQ861Vni96iqAHasZOrg+5kgzu1H17Zcxqw+C72x5nwtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58:25PM -0400, Gregory Price wrote:
> The huge-PMD branch combines PMD validation and lock ownership with folio
> filtering, splitting, aging and isolation.
>
> Move the folio-specific work into a helper called with the PMD lock held.
> Return a locked and referenced folio only when the caller must drop the PMD
> lock and split it.
>
> No functional change intended.
>
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/madvise.c | 70 ++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b31b877c2c130..6b518f7f73651 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -394,6 +394,49 @@ static bool madvise_lru_folio_is_filtered(struct folio *folio,
>  	       (pageout_anon_only && !folio_test_anon(folio));
>  }
>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static void madvise_cold_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> +		pmd_t *pmd, unsigned long addr, pmd_t orig_pmd)
> +{
> +	if (!pmd_young(orig_pmd))
> +		return;
> +
> +	pmdp_invalidate(vma, addr, pmd);
> +	orig_pmd = pmd_mkold(orig_pmd);
> +	set_pmd_at(tlb->mm, addr, pmd, orig_pmd);
> +	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> +}
> +
> +/* Return a locked, referenced folio only when it must be split. */

I find it really weird that when it:

a. succeeds
b. mapped folio is missing/invalid/filtered

In both cases it returns NULL.

And it's also weirdly returning a folio in a kind of failure case, or it's
more like a defer-to-the-rest-of-the-code case I suppose.

I wonder if the split could be done as part of the function?

Then maybe have it return bool and document that true means it's fully
processed (invalid folio cases, success case), false means that it's been
split and the rest of the code should continue.

Awkward one actually.

> +static struct folio *
> +madvise_lru_huge_pmd_locked(pmd_t *pmd, pmd_t orig_pmd,
> +		unsigned long addr, unsigned long next, struct mm_walk *walk,
> +		struct list_head *folio_list, bool pageout_anon_only)
> +{
> +	const struct madvise_walk_private *private = walk->private;
> +	struct vm_area_struct *vma = walk->vma;
> +	struct folio *folio;
> +
> +	folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> +	if (!folio || folio_is_zone_device(folio))
> +		return NULL;
> +	if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
> +		return NULL;
> +
> +	if (next - addr != HPAGE_PMD_SIZE) {

NIT: Maybe could define above as:

	const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;

And then make this:

	if (!spans_pmd)

?

> +		if (!folio_trylock(folio))
> +			return NULL;
> +		folio_get(folio);
> +		return folio;
> +	}
> +
> +	if (!private->pageout)
> +		madvise_cold_pmd(private->tlb, vma, pmd, addr, orig_pmd);
> +	madvise_lru_folio(folio, private->pageout, folio_list);
> +	return NULL;
> +}
> +#endif
> +
>  static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		unsigned long end, struct mm_walk *walk)
>  {
> @@ -431,22 +474,11 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  			goto huge_unlock;
>  		}
>
> -		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> -		if (!folio)
> -			goto huge_unlock;
> -
> -		if (folio_is_zone_device(folio))
> -			goto huge_unlock;
> -
> -		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
> -			goto huge_unlock;
> -
> -		if (next - addr != HPAGE_PMD_SIZE) {
> +		folio = madvise_lru_huge_pmd_locked(pmd, orig_pmd, addr, next,
> +				walk, &folio_list, pageout_anon_only);
> +		if (folio) {
>  			int err;
>
> -			if (!folio_trylock(folio))
> -				goto huge_unlock;
> -			folio_get(folio);
>  			spin_unlock(ptl);
>  			err = split_folio(folio);
>  			folio_unlock(folio);
> @@ -455,16 +487,6 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
>  				goto regular_folio;
>  			return 0;
>  		}
> -
> -		if (!pageout && pmd_young(orig_pmd)) {
> -			pmdp_invalidate(vma, addr, pmd);
> -			orig_pmd = pmd_mkold(orig_pmd);
> -
> -			set_pmd_at(mm, addr, pmd, orig_pmd);
> -			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> -		}
> -
> -		madvise_lru_folio(folio, pageout, &folio_list);
>  huge_unlock:
>  		spin_unlock(ptl);
>  		if (pageout)
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

