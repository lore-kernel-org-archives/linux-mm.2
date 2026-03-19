Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48BB1091910
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E34C6B0584; Thu, 19 Mar 2026 15:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DA76B0585; Thu, 19 Mar 2026 15:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DC6B0586; Thu, 19 Mar 2026 15:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D74F16B0584
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:14:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FCF08C256
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:14:46 +0000 (UTC)
X-FDA: 84563764572.10.A1DA2D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B828080013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:14:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4lEG9Hi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773947684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/6DOLTLf0ykSR1CeMK41IlKDjMp7SyuVNk0fposR/s=;
	b=eyEOPtvXhUGE1UPa1UqJsKcy7BCsKUtgRO2igyBdNH37Yuuva4n6SbNJXWqBiJi/r3rHMc
	AhnQnzI4sixz/xMkDEZxm3CnqtBcyBvb69B9dgkCmPuz6SBcwly6YL4dNp92gU4c1fVUyl
	uJnMlXam+O7ciwxr/QWY2AeHClnWTjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773947684; a=rsa-sha256;
	cv=none;
	b=CmBJRhScD9N545tI3g8fZP6f793XJXlhBqqaEp6XHWwL1FuPRxxmAduNZYoUVVGXCPYOTl
	YOtEchvaRQFkLQ/fh9hazFmRFr2eR7Yr+P1nxufuHMpN41y0OGPwXwXYJxcfWKgjtWPLkN
	lnDBeZ/i9+dgL+LmSyyrx0gy0oEp0E0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4lEG9Hi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 217FC60097;
	Thu, 19 Mar 2026 19:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADE4C19424;
	Thu, 19 Mar 2026 19:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773947683;
	bh=OpPTg9PC2934nO+rGnVV+BGXgg8E4AJFITlFrIDoVYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4lEG9Hi3E79QfelHKN3E8hSvPgsLMj2Ng9gibkvmKypZ3ky3wIcqTYvOlaR7j+XK
	 9nAXfnuXonTwNjl/T3cQjv/Q5AlF3M4vkVHqvtfH3X4WYOZZdD8zJi1ttCRtf91W1v
	 CwGwZf5snYvKeZ2U1iXxjWhQwhY9jjueTj4Fwj+/7CNdXMvYRfu9SxMHoAuWZUPbqE
	 4+SZmJlEYG23ej/jGbVXf/spKQCr1IaqNOn6Nm1JeJ2qMWbE4IOvOAK443NftM6FIQ
	 /+MZLKrYliOaHS4YODkXcjE7gGhl4SdMHzqHEXJnSNWwBp+i+sPmoNkopMEkzMyPJG
	 vUElRO/XyCIhA==
Date: Thu, 19 Mar 2026 19:14:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319183108.1105090-4-pfalcato@suse.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B828080013
X-Stat-Signature: x8h9dbhtnxuozuhyg3p987sk3y1g3scg
X-Rspam-User: 
X-HE-Tag: 1773947684-888864
X-HE-Meta: U2FsdGVkX1+Yakt8xWZTvt1ZYuVGeltyMkcpcMMj2y3Nkkam5zZZeiRTmPwwVfkNhwiAHe953mzYSY+y5BuDFjD/dP9uOLKdT3dgjpjrThODwsCs49U7Gw82R+Ep989L1qmhw2mA1KsT1xSG4WexzKUYOuvMtYe02znlbdrDy3YFX7dxCs/8X1NuH4WE93b+0jmQLvL6jBNPmZNJbNpdzye8U9wBPNG/nL9/3uDS6DAsOkomcvvJrbUlUMg4HRNO21gmVruU5WBSiNnf9yWFbYszFAcy8OBg08KLIqY9D6BCSxubh/G0kmr1D8LaM+QA6y2+2PuP2X2mqgf4Ft+KoidJN+L9OAJSmk6+iptdQqTX+XKGH+Bjz+y7yFsMNA89swyzwPaVIFobbbHCTU07jPrbo84R+Z6sDwF54S4XcJEcvMG5ULNh3S6lrYjKgZZMmkYZOKM364kZiRR9/vWiVom78WGDuPFnC0orYT28LZiOPI2/XHCWOv74gmWsvoSjKIVUjCe2/9ZTTTrj/2ffyi4mzUZhZllcnvcVhX8qXlyp3WeJJ+Sze32PcUZbYdErtlXC3sA0XNK2gGBsB9clHKd10fNtBj+y3fRuc5OOHzCrReZYtviCm0V8ENBelosze73SV67usRf3QysVeXu59BLgDVK0tZKFFKfz4EVG3u2B5d/8ZuxK5zDjSUx8MqafP8lVSTZWyG7RDlVqC7D3Pt7jfMWu+1iDP/K3Rj82Y9+Uqe1f0QxyqN3WGGGp8ua3d0g/AZY4YsxU6xfhdB0FmAs2vW9UR3hIhEYa1YwKzdSl0XfFqhKkYJ3dUncN9n+cfNJVhTU05670jr2fS1ZYwD/72NkLOGS0o3cdLcwluj5Z4HdtsBAddo0CzHUROb6JfidWMHY3q4T+CVTuRFgbXFML81Pcv5IbSChDv1h+vTxmbbMVRnXLIDL7V+hJ/RmgymiVMdHHYDO/Ee7pjyd
 bp1hoWJu
 peb3nuQweEgcXKnXy2+BSK+Pg2UT4eAUkjyuPrEVOuXuNnYn8wLhGsJ+KzRdMIcw3TOlHv5pLORr92aSH3kGZSVg4fIvxciU/8/hOB6uVotir4RcxnfXDiljVVd0f+8c+BUafwqs0UZCbz59pgjdXZjYO3FMpXM0T3Nw8AdbbELUY++df1H1dWsPDcpXz/0OGK7nXErSFXGv0DosAGKrgna7cu5QG5wl+YRZyDqmlxwhuETcVtfOTkw0kk8TYoPG3/5Ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:31:07PM +0000, Pedro Falcato wrote:
> Hoist some previous, important to be inlined checks to the main loop
> and noinline the entirety of folio_pte_batch_flags(). The loop itself is
> quite large and whether it is inlined or not should not matter, as we
> are ideally dealing with larger orders.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 8d4fa38a8a26..aa845f5bf14d 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -103,16 +103,9 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return can_change_shared_pte_writable(vma, pte);
>  }
>
> -static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> +static noinline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,

Hmm I'm iffy about noinline-ing a 1 line function now?

And now yu're noinlining something that contains an inline (but not guaranteed
to be function, it's a bit strange overall?

>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>  {
> -	/* No underlying folio, so cannot batch */
> -	if (!folio)
> -		return 1;
> -
> -	if (!folio_test_large(folio))
> -		return 1;
> -
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr_ptes, flags);
>  }
>
> @@ -333,7 +326,12 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				continue;
>  			}
>

^^^ up here is a mprotect_folio_pte_batch() invocation for the prot_numa case,
which now won't be doing:

	if (!folio)
		return 1;

	if (!folio_test_large(folio))
		return 1;

At all, so isn't that potentially a pessimisation in itself?


> -			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> +			/* No underlying folio (or not large), so cannot batch */
> +			if (likely(!folio || !folio_test_large(folio)))

We actually sure of this likely()? Is there data to support it? Am not a fan of
using likely()/unlikey() without something to back it.

> +				nr_ptes = 1;
> +			else
> +				nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> +					  max_nr_ptes, flags);

It's also pretty gross to throw this out into a massive function.

>
>  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
>  			ptent = pte_modify(oldpte, newprot);
> --
> 2.53.0
>

This is all seems VERY delicate, and subject to somebody else coming along and
breaking it/causing some of these noinline/__always_inline invocations to make
things far worse.

I also reserve the right to seriously rework this pile of crap software.

I'd rather we try to find less fragile ways to optimise!

Maybe there's some steps that are bigger wins than others?

Thanks, Lorenzo

