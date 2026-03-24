Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC52BE9A76A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089C66B0099; Tue, 24 Mar 2026 07:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066936B009B; Tue, 24 Mar 2026 07:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8BE6B009D; Tue, 24 Mar 2026 07:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9C3E6B0099
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:04:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C150BF4B2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:04:42 +0000 (UTC)
X-FDA: 84580673604.30.B0F0447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C05C8160003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:04:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPBZn2wN;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774350280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAWoWPHIFEjDsBYUP1p0YUE2fbu7X565KGOfSoasDQI=;
	b=Ubv65ePVBPeVGLauMdjzqLCw3rBYVRHnESDX8B84ZyoFpBi3WG+Bd3+L7D4u91+c7y59MM
	2nQ16MvIOZziHHRDo5P23sBtapvY4lmpwfy/9aG/u2+1FPoebpCZsn2ePrqUmB81nVZmQh
	k4rVUcIisUz8KxaKHk3Xn7FKgv+F9pw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPBZn2wN;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774350280; a=rsa-sha256;
	cv=none;
	b=Lola9jmPTXlvG9/uL2mgw3BFkzUOimkYN01/13hIVac3KbfrhTUP2h+6Sqy/6Zgk3x4hrc
	VAWKzEPokH4ZyAODLF+UUtharV802YRDwf0+c4avtv/gm02embJJ8cNx/AyvrpSd28jkuB
	6FXPEJNc24pawWCM9rDGzkz96EpITQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A33442EC;
	Tue, 24 Mar 2026 11:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C89CC19424;
	Tue, 24 Mar 2026 11:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774350279;
	bh=rnFMpHblF7tfmmg1p1erGQtnBbDTkaS+4wz6+R+ceA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SPBZn2wNQxbsfUGL75fvK0emhXc6+bHOf3S1hJvckqTJ0mtoYjlhrxTD6EOw6c2Mx
	 pmSCa8EJxcgbx7VKVqRjV2ri9wlisAufPvUU9llrEHYs5f1sW3AMVgjdca/jy7gQax
	 qUMrj4xiAxfk3rvYyIPB2aEXPQHAuPmzxWBk6TbYW2aQ4Mj+9Q0icOHZdve92gaXy8
	 5jBCHC3VHK9ND6+Q98XLE/Pm0VL5esEah9VD2Z3J5M5/dk3Hi0kq6sR3VFyMTuHg3d
	 XqBJ9UbqvdfnLN3hndBxHQb9PEm+9An5KCbv5Ky6ma1umDauyws7Au6jt5hQAVxy2c
	 7oWgDtpr6D8dw==
Date: Tue, 24 Mar 2026 11:04:33 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, Alex Williamson <alex@shazbot.org>, 
	Max Boone <mboone@akamai.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
Message-ID: <b3b78722-c265-484b-acde-3aa4bee0aac7@lucifer.local>
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C05C8160003
X-Stat-Signature: kbkub4awte5paphxcdcfp7zaaka643dm
X-Rspam-User: 
X-HE-Tag: 1774350280-525467
X-HE-Meta: U2FsdGVkX1/ykAvkWvfvSjaqJ4Wabr/AJk63uzModGDLpblG5lvlrgqhj/76Sj+VCc5JFAnk8ZRSe0Gm17HdMKiq37lgyohI0vlEmYY09JacZgnIYem1+H1UJpB3q06F7Q2WoO7zsWZVAqbJWrEtssyVz9Z+aYNHtKvkjMkaqzsRtYCDpfiDeQCZZvXsKxozhJONX2GkqTFg9ZDWfSZL21foKSqF5Pyq1Ixrao+SLRYQobA9Lus4o+8ZTNo2N55d9AmIPIjb+gGBN3c3A2vkAW0ieOUjFciaUxcfDLaYNxEM+0/BEgJvqjHTrPacnP3Mfaw0JOMYoxOuKG+8SRRhZVhiAO/CAIDRJ7jLuRZxj2jBdRepf8rAoeQGE0flEyvZziRPC8ipV0qmn9lkaAKB+yS0qeXmkECYkd3Q+CwU8TYXwE21XWVOeCXAUaTjlQiyACFb6rfhMoKXRgwTlglcBBl1JwHh0MmhNhN5Y68krAZ6McYmQGMf30dTYUqxjJapdLA7kQzhVb6ol3t4FeJJlpOpEii0NLOJ9MbvAHLNPSTdi3HNU+bWKpVGxBJKAeRRPwstisKiUt3e/TRUUzzGYOAiEgfvRLuIdcrSaOR/oJKRFkxCJDvfyleIppqOeOomtMu+/05drkZoSKPk9XabQr75LtbL9iOKtdl8scU5eX0wuBSumsNFe0g1iN904jWnv2Eg2ILdSR7B80vd1or50571HSj/4MvXxLbOoewJZYV33mJPAtsvwHvwJUewv9LsMYCFiuQpwt2Vlv3JNgbWHbojeYJ9i+UFdZtHI1gl3s15sAmmapRadauOVOUbJdS6TmIldKYchimswNxk7AV6FkAjEadZFXhLDbaCcbyvMY1zGEEifQrX5i22oKygZUUi3ivwIuolBgP6TYPOO40AC/ONvjiOWtvOhwNrfDlsL+xAlu3ByK7Z6xqok37BrGIfzjfwYOEg1KgQpO8P8nN
 H7JELPic
 hTSuS+s/gDHWMtxUnf3OhQEuUJ/DsZAdUZHcvSVGZ1dLIzD4xz2kbpvcAJ8SOHqH1MI8APfJ/XfSneKYRxGuGrar5sMKFJ+nR6GlWc8s/6bFRQjdt5uK12uHK06CdechQYlAlu9dCSNAHK0flcHBrlXbECaoMPpQXot5hGLI6lDajkwDzny/cc+IV/Guey1wsDzteJitm+yHHhqcH83bSMWTTUmXFM3FN9VQImOI8J6n3Z1p0nfWUYFcJ+G3T86Eg/9oXlfFckbyWipOg/T6/389QEduyjEJKmIx5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:20:18PM +0100, David Hildenbrand (Arm) wrote:
> follow_pfnmap_start() suffers from two problems:
>
> (1) We are not re-fetching the pmd/pud after taking the PTL
>
> Therefore, we are not properly stabilizing what the lock lock actually
> protects. If there is concurrent zapping, we would indicate to the
> caller that we found an entry, however, that entry might already have
> been invalidated, or contain a different PFN after taking the lock.
>
> Properly use pmdp_get() / pudp_get() after taking the lock.
>
> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
>
> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
>
> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
> reasonable on non-present entries. Most architectures indeed either
> perform a present check or make it work by smart use of flags.

It seems huge page split is the main user via pmd_invalidate() ->
pmd_mkinvalid().

And I guess this is the kind of thing you mean by smart use of flags, for
x86-64:

static inline int pmd_present(pmd_t pmd)
{
	/*
	 * Checking for _PAGE_PSE is needed too because
	 * split_huge_page will temporarily clear the present bit (but
	 * the _PAGE_PSE flag will remain set at all times while the
	 * _PAGE_PRESENT bit is clear).
	 */
	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
}

So you might have missing _PAGE_PRESENT but still pmd_present() returns
true, as does pmd_leaf().

Seems the same for RISC-V.

And other arches play other games with the same result :)

So we probably shouldn't actually hit any problem with this from any other
sauce, but still good to do it.

>
> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
> do that.

But pmd_present() checks for _PAGE_HUGE in pmd_present(), and if set checks
whether one of _PAGE_PRESENT, _PAGE_PROTNONE, _PAGE_PRESENT_INVALID is set,
and pmd_mkinvalid() sets _PAGE_PRESENT_INVALID (clearing _PAGE_PRESENT,
_VALID, _DIRTY, _PROTNONE) so it'd return true.

pmd_leaf() simply checks to see if _PAGE_HUGE is set which should be
retained on split so should all still have worked?

But anyway this is still worthwhile I think.

>
> Let's check pmd_present()/pud_present() before assuming "the is a
> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
> table handling code that traverses user page tables does.
>
> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
> (1) is likely more relevant than (2). It is questionable how often (1)
> would actually trigger, but let's CC stable to be sure.
>
> This was found by code inspection.
>
> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This looks correct to me, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
> Gave it a quick test in a VM with MM selftests etc, but I am not sure if
> I actually trigger the follow_pfnmap machinery.
> ---
>  mm/memory.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 219b9bf6cae0..2921d35c50ae 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6868,11 +6868,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>
>  	pudp = pud_offset(p4dp, address);
>  	pud = pudp_get(pudp);
> -	if (pud_none(pud))
> +	if (!pud_present(pud))
>  		goto out;
>  	if (pud_leaf(pud)) {
>  		lock = pud_lock(mm, pudp);
> -		if (!unlikely(pud_leaf(pud))) {
> +		pud = pudp_get(pudp);
> +
> +		if (unlikely(!pud_present(pud))) {
> +			spin_unlock(lock);
> +			goto out;
> +		} else if (unlikely(!pud_leaf(pud))) {

Tiny nit, but no need for else here. Sometimes compilers complain about
this but not sure if it such pedantry is enabled in default kernel compiler
flags :)

Obv. same for below.

>  			spin_unlock(lock);
>  			goto retry;
>  		}
> @@ -6884,9 +6889,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>
>  	pmdp = pmd_offset(pudp, address);
>  	pmd = pmdp_get_lockless(pmdp);
> +	if (!pmd_present(pmd))
> +		goto out;
>  	if (pmd_leaf(pmd)) {
>  		lock = pmd_lock(mm, pmdp);
> -		if (!unlikely(pmd_leaf(pmd))) {
> +		pmd = pmdp_get(pmdp);
> +
> +		if (unlikely(!pmd_present(pmd))) {
> +			spin_unlock(lock);
> +			goto out;
> +		} else if (unlikely(!pmd_leaf(pmd))) {
>  			spin_unlock(lock);
>  			goto retry;
>  		}
>
> ---
> base-commit: 3f4f1faa33544d0bd724e32980b6f211c3a9bc7b
> change-id: 20260323-follow_pfnmap_fix-bab73335468a
>
> Best regards,
> --
> David Hildenbrand (Arm) <david@kernel.org>
>

Cheers, Lorenzo

