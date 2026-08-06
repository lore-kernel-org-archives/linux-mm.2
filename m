Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0115C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76726B0088; Thu,  6 Aug 2026 03:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00396B0092; Thu,  6 Aug 2026 03:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1CE6B0093; Thu,  6 Aug 2026 03:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 997A26B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24F231606AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:34:45 +0000 (UTC)
X-FDA: 85070032530.28.EBED13E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8715714000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:34:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRtWObil;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786001683;
	b=6A8RqBGZNo6502AD8joFpUsJq09p2bp34JESn9noQ3zRVoWUYT1zSSBZclsRGc/Gk8iPdU
	IxqP2URb8rROarn6fM3nXwzBlkOZCuYsOXQ4dIaQr+W81ZuOF0uc5IfpDW1xm83YHz7bSf
	Pq4+OL/u2WvE+Vk1doTyoLJTRUuCVm0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gRtWObil;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786001683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3wUW9A5onn8mXoBrGXcecd/b5GN4A+lRTgjr2p0JTI=;
	b=BtTwmkVPfxJ+AQWnuygIzh1Xwr7+gRuWMOpXeVvH/fBeNkBXb5jY07hlqMyCGZ0u5RS5FZ
	qh41X7ndAB6MswnwyuxCe5GoB1/FLQVDsQbTaVjKf0tQ5P8aoCPJTiEoPK/pGzAAplmbxq
	lt5t5i+Pe9YcU4ZKSmWjzvAlBsVzehw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A43C60A9D;
	Thu,  6 Aug 2026 07:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9D1F000E9;
	Thu,  6 Aug 2026 07:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786001682;
	bh=y3wUW9A5onn8mXoBrGXcecd/b5GN4A+lRTgjr2p0JTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRtWObilZ/zqY2xNJFCFGkSOxfW+x1vY1mLHvaVfFn3nCz/YO+ctLWfNTTs4szgnu
	 yTVCVopxmFl5NcnYpG991e8Bt2Ezz8pE1lZATTWxE8x5kpf0Cga4wRPeWCS7E5HqWv
	 XYFKlbUMhZXVnLOpWi/i+ZQVJSvS2hDlXe0DDN6dURjWleKZWV49tMZzt2Af3x0wCx
	 girzSHfnN2fGQM3POEWVr+brhoQK6GI2hxA4PAd23gY3P1IVF+HqesJZch2/8pByI2
	 /EHEMqZTbBwqX/8U8p+wI2vggLbJGqS41xPiSDTkTcAYl1PUWUd+oug/OamioWoiLi
	 FVdw8NszJIKKQ==
Date: Thu, 6 Aug 2026 08:34:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 10/15] mm/gup: add fast-GUP specific lockless PTE
 helpers
Message-ID: <anQ2bW3JxraT6PFY@lucifer>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
 <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>
X-Rspamd-Queue-Id: 8715714000B
X-Stat-Signature: bgmk36r1ek941ttc44xtirfsjdzmqddt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786001683-305935
X-HE-Meta: U2FsdGVkX1+Z9zNANs/DJyvWEHPhCh2PH/LCbfE5QPMbIkU8uF4DZx8K/xHx9YYRlnbERmL0uYyORtFovticQKgJ902EE1pgzdmUohqQpJj91OMSHUV0O2po2pSvsj6mB6T7/5q8UZkYxs7VPCFTh9TlBPCcNngNu1B2B84r4nAXaISD81xobxNuPhaw9GTHAxYi6kVzK1s8NpOJ6qxVtVXzqTB2RAdbI8PNI0ytW3qz8pZ+gqUYmuNDO6teZj+LKa1nemR6msM+MVG+UA1ES+BPIcqyo1Iewwpni2ITFZt8fHOO3RSszqBXrNPOxzGeWdIsZpAmo/GpP1dUehe/TEO5WLe9KWuLNC5rySwmiVCpb6XgULvibBksshY5dCrBEh4lPr/KaBiO4eRiUQDwFlCu8TJDRYSB+ZuNY8+p5zkYNUQwb85Y9k4ZL1u0pOgRfCyKopZqSYVBENXfRYRofpAIpLJNsyG/vAwea0zuxfjz9Y1t+LhG5f9LBk7FVJ7iE3UuHGx1mJvA5vIGekjCX+Uz58CR//zLKi7KI9yzu1F50/bFgJ+a9hD+q1/YKU6F/H5kCh9kIVs1uaQFzZTsT6661lLvaitACEliH6mHx90/6KwKrLdEHYha1ksH4bmTNj/oYoMBnXllVHKAApSNoAZPWb5VpBlLkK2Hz5y643o3TgUjJV2zJ9Q8YUdpfcyxMnUvhLFYkCeD603xkFlZiElTKLcjw+eCEsHtCdxXnTcWnrpbAXnXqSwy0OY0/cfsb5Krmvo47ap0PXRhKAqg3JtAE/g0ZG878TkMn1DgCqZuI+2qJi+k4fEHO2NV9V+SBLeeQq+GQ/sRxz/vqEEu7c8kQAKMAIAqkIkwBVHKA8sIA1RlehRKwCYMpLyU9LM3JDW1d7Ty9U45nfz9ej7Z6rWPWVxCeHE/LDl1bndLCNAgjdmNqMgJJApvVMeM6j4f6YuPnladItQ5aaGqIHX
 a3cdE5fi
 nY8T+nOXIRQJ2cGdH0Z+RZJy/JZNjcN6kkQYaURuz6DnoeuCxB5XSK43kNkP9yWw2f8CmmUf0uiPy8d8f4UYghbpGJNAe/LwO3yT3kM3N2HJJbQZN5vyduM6cw7SMTKHoA1agNdz5pj4WI2jSe0JjBM0vOLiUwIbKViUFev5erI5rlpcnR4UK/HRtEkq6qlx3H7cBvDY3Pr6n8FdpMzKPZATjXdBe7h1DdGdzXRDzCA1s91vpwSDZyYlicGU+Dnb//tkrdd6alzCAlIvGWwJqGqg/0PMOV3UO0lSKQcNwvxmgbCnM3J1/eb92BqwCfMotcS+eKscThSIpHSJ5LUk5RtpTlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc literally everybody you failed to contact...!

Why on earth are you doing sending a series like this which changes core mm,
non-RFC and at v2 to boot, without bothering to Cc relevant people?

I am also very confused as to why you are sending an ostensible RISC-V series
then changing how core mm works to fit it, that's not how that works.

And if you're seeking to change core mm send it as an RFC!

On Thu, Jul 16, 2026 at 08:41:45PM +0800, Yunhui Cui wrote:
> fast-GUP snapshots a PTE without holding the PTL, pins the page, and
> then revalidates that the PTE did not change. Keep both reads under the
> same lockless PTE semantics by defaulting the fast-GUP revalidation to
> ptep_get_lockless().

Why?...

>
> Introduce fast-GUP specific PTE snapshot and revalidation helpers. The
> default implementation preserves the existing ptep_get_lockless()
> semantics, while allowing architectures to override the helpers when the
> public lockless getter provides extra semantics that fast-GUP does not
> consume.
>
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> ---
>  include/linux/pgtable.h | 18 ++++++++++++++++++
>  mm/gup.c                |  6 ++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index da14328093a86..62943fcbf7046 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -813,6 +813,24 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
>  }
>  #endif
>

Of course, no comments, helpful!

> +#ifndef gup_ptep_get_lockless
> +static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)

rawp? This is terrible naming.

And 'gup_ptep_get_lockless()' is worse. What on earth is this function meant to
do? And why is 'gup lockless' considered different from lockless?

And you return the value twice, because of course you do. Why? Who knows.

> +{
> +	pte_t pte = ptep_get_lockless(ptep);
> +
> +	*rawp = pte;
> +
> +	return pte;
> +}
> +#endif
> +
> +#ifndef gup_ptep_revalidate
> +static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
> +{
> +	return pte_val(raw_pte) == pte_val(ptep_get_lockless(ptep));
> +}

Again this naming is utterly terrible and I'm at a loss as to why on earth
you're doing this?

We don't need to abstract equality checks?

> +#endif
> +
>  #ifndef pmdp_get_lockless
>  static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>  {
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b0..72fb147193e55 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2842,10 +2842,12 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  	if (!ptep)
>  		return 0;
>  	do {
> -		pte_t pte = ptep_get_lockless(ptep);
> +		pte_t raw_pte, pte;

What on earth is a 'raw' PTE?

>  		struct page *page;
>  		struct folio *folio;
>
> +		pte = gup_ptep_get_lockless(ptep, &raw_pte);
> +
>  		/*
>  		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
>  		 * pte_access_permitted() better should reject these pages
> @@ -2871,7 +2873,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  			goto pte_unmap;
>
>  		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> -		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
> +		    unlikely(!gup_ptep_revalidate(ptep, raw_pte))) {

Why do we need to refadctor a comparison between a local variable and a lockless
get?

I'm just so confused by what on earth this patch is meant to be or why it's here...

>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
>  		}
> --
> 2.39.5
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--
Cheers, Lorenzo

