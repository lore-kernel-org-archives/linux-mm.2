Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AACCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D036B008A; Mon, 11 May 2026 03:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DF76B008C; Mon, 11 May 2026 03:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C342C6B0092; Mon, 11 May 2026 03:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0A326B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:17:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BD1FC22B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:17:34 +0000 (UTC)
X-FDA: 84754283628.21.CB6F242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77ED11A0011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:17:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRtc6Wve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778483852; a=rsa-sha256;
	cv=none;
	b=1dvcQmzSVm4nsGF7z1T8ZvGmAwTVayb5DXKeLqugLnK2xJ3dMaQQF+oPcKpFAg0DHrLm0W
	F6rsz5y0WgB+vZaUWu7ulinl7HNkzdDPPyOT4ecVgCiV+qvxzhUN0/G9KioO9rGVmifpGo
	kE+BYcJkvXB6XxpWh31JV3pZQ3Hd4Gc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pRtc6Wve;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778483852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1XoXGCUIhvgIeQ43wZc9HAFzicUT1c7Ym6ZxZJtVug=;
	b=hOjSlMd6gf6RVUJlcjSKgeWe5zjOjgUy7Gc2HWJ03jaUvE+SvQK3LiWliwVGnYNPkdeRB2
	cGwFNae5iuMynI4I9wXbnAcUSRCSxQh5crxcvbb/R7fT/7ibOp43S5WEfvwxzulLM+Odo7
	OOnsJf1frK76jnsLloeE7Fx2blu6HVk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75B544040B;
	Mon, 11 May 2026 07:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BB6C2BCB0;
	Mon, 11 May 2026 07:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778483851;
	bh=LkpLtBg7oCb43ClpBPUq4iq9i0Tn++YKd0G4AX2wqqg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pRtc6WveBLKgmpEpXQlwQ+gEzXNOv+ajONlpwi+nkmOlVJUoC5ECxOupiLcnpWqhs
	 n3iIJbuMtuWIimGSuvnO4rLTxn8AgPTAb3n1LpR0/5ROvcQECPylEEb0dNjvidOfwi
	 pfzNs0XhViQaQHvYKMKE4mz+M+eIY8ngqM470wieRlTTwDi0nYYPWwn7IWAFRcmfMk
	 u/Bn6EQGYr6KWvcmwIW9ulyhhJ+GhtGO3S9im9/+UYILdDYvK/UHSJezRzcQkE8LDm
	 eaOwj62qOJwSvjyDo4EwFmIXRuO/b6nosl/vSIS+PbrMPIpdKwsi1hL3P7PpksKosJ
	 TGuQCiOyz7ccA==
Message-ID: <cff99673-ba36-41d0-add1-e2738f95bc4a@kernel.org>
Date: Mon, 11 May 2026 09:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse for
 sub-PMD MADV_COLLAPSE
To: Wandun Chen <chenwandun1@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
References: <20260511065701.799006-1-chenwandun@lixiang.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511065701.799006-1-chenwandun@lixiang.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t8po55ku6no9bmrr5pj9qbnsu1xchpfr
X-Rspam-User: 
X-Rspamd-Queue-Id: 77ED11A0011
X-Rspamd-Server: rspam07
X-HE-Tag: 1778483852-980912
X-HE-Meta: U2FsdGVkX1+fPwFUF9ITtIy4VzCVuSYK0mXE1q9XadLiKmn9Tn5TaCxD7yx5qTaRFiXSCd2x44qmURsklvgwMBneBKZqCMVB1x7H1snTX1HNHdIyjeydSevWf8ikSexkwfNJuqbUaSjbc3uV1aXn/mgQcnIndVlNihhg18Bp9a3EGpjLjGvg5JfemU0TyTPH5Q7uB6tE6LAICH0+yhWjr70y/NurtSQB7HSAAtfzVPUY2B5s1Gnxt1zN91pyGMfscRvtc1yDHA7yIrmM7UF/NUlYTpvYE8phfYbzPEW/VZSc/QCUU5W6rmpZOlpPUzUy65zbQUupO6J3RBZxm5r0YpdeXa7TEgMvRRiwOrWQep/+GpJmg7AHfJiGbKI1J+JNoql6oef/1FTKZT5yk1tURNlrLwKgd5m30kKxQq9GajkQiFpq/am+TJbk8wcf8DLE/ZZEGiXKO9c6WrtwFJGGelF1IpCdYPuraMkclX/I5OO+c0xQ5PNHEvVvEZH1GnxEstdA+DzN20rbbYMzvx06V4NGE30XRzpS+lUo2YMjZNsI7MjkiPff+4g0SPhaaav9TqlAfZCmAAexBE9eoFWpW03UTLvD23x5byzsuWguk8/5HNRNjpdvlfaawIxpnLxqTVdQX5Hchx4znYWWD7gZTuhjfLVd7sCuHZxBjZsc21LZl3DYZE3v4oos5nEAAElPxt4AkIVpzM0VA8uZ+m887Z5z7PzGuzX/lnfW+aUhjkbo41ltDBlAPC4PPuSwHfRF+j0AQwLlpNFoAf0Jhxt5u3/T7hxALU9gh5GnxZijudW50acUY3xxm00n6zmUzS5RMOqE2tPGZvJmMZGISPaJzOjnLYA5HaSqwHSsHD5qGSLXLMC1VED1Sy9lypXRrugR1QcHFXzBTOIUw1qHSqBnCv76Bri+Y4CdF4601dBMF6cFLWWW/s2N/e62aye1YQhnw3o/ljsb1UBF2fYAXAf
 HsL/plQs
 0zij2wnBBcYtrem+EQVBtrFtj4AYDjh2pFqcE28MAhWSo+XIC2tNBe7hjyffb/C3idcwlTyW7dcVV9FmOV4ItgPj1R8E7zvtTwa5xFgVKtuxVW1zd0+HgCVVgMuFavkke0qZ9h2j4IXJkNu0Cui/Q0jgxoBbSeQ3Qn5FgYlACjek40tqqrprCFbNQDKH7lAY8l+0K18s7/2yqnrps1EPBuijaoLSxAJAWtsBf3wT0xTdjFjmjkcFkqYmTchTFUrHArqYHdlp7UhYg2My5Azk2QjhhmKQzDrKnsWf97nq3IlGhbBOXPhc61QwITuw9Ki033UYAoRnO9TXD6i/C2aNc0JNvpUCQA+nuXzVbjkupue6u2mo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 08:57, Wandun Chen wrote:
> From: Chen Wandun <chenwandun@lixiang.com>
> 
> madvise_collapse() computes the THP-aligned window:
> 
>     hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
>     hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */
> 
> The following case will cause hstart > hend, and result in underflow
> in the return statement, avoid it by returning -EINVAL early when
> hstart > hend.
> 
>     madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

Ok, so providing a PMD-aligned address as start will result in 0 and a
non-aligned address will result in -EINVAL.

Didn't Lorenzo agree that just returning 0 in both cases would be clearer? But I
might have misunderstood it.

That would also make the code easier ...

> 
> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
> unnecessary when hstart == hend, so skip these operations by
> returning early too.
> 
> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>
> 
> ---
> v1 --> v2:
> - Rebase and resolve code conflict.
> - Return -EINVAL when hstart > hend, suggested by Lorenzo.
> - Drop Fixes tag, suggested by David and Lorenzo.
> - Updated commit message to be more explicit, suggested by Lorenzo.
> ---
>  mm/khugepaged.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 28a843f30b32..36baab17f098 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2837,6 +2837,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>  		return -EINVAL;
>  
> +	hstart = ALIGN(start, HPAGE_PMD_SIZE);
> +	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
> +
> +	if (hstart > hend)
> +		return -EINVAL;
> +
> +	if (hstart == hend)
> +		return 0;
> +

... as it would simply be:

/* Nothing to collapse. */
if (hstart >= hend)
	return 0;
@Lorenzo, or do we want to keep the (questionable : ) ) existing behavior?

-- 
Cheers,

David

