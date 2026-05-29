Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A6ECD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57D06B0088; Fri, 29 May 2026 14:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F646B008A; Fri, 29 May 2026 14:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D786B0092; Fri, 29 May 2026 14:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7916B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:34:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34B0D1C02EF
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:34:27 +0000 (UTC)
X-FDA: 84821307774.25.9D5A83E
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 13A574000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:34:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c4SbVtOm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24YU1NBoUybBTpcYsacpUWpYJ0m9Z4yMIofjF2AMjYQ=;
	b=UmkVea6KwN44Up57eIUY/8wlnL8PGyhcaX0PnCFNkW+EBudVXPaS7sCzed3vKCi6c395QZ
	Op3jj7UbykdfB2juD50/Do+vebRrfUUdp/0QqM0nAyAWATV9ACKKS1VCX0EgH7uF4XL+Am
	5ZK/BfLNQsN705+u0dU6UXQ4CFHzCIM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780079665; a=rsa-sha256;
	cv=pass;
	b=wst9HnvKAHQcUxRn/lWPugYagW3EHnBZJtpCu3lmn65o+blyNrixlTnxtmbS7LIZpV7mxO
	+Sh+7230gVuRgM5DcAfDO6sj2kersQSOt1vHMtT48qTBr08En9fFEN4mGPQMrWZhSBWJzZ
	uG+6w3lfZrWENxsPC4OQQX5t/KKw09A=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c4SbVtOm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef616daf6so541456f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:34:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780079663; cv=none;
        d=google.com; s=arc-20240605;
        b=O/bFgXT1dhqxJcx2m5EDikG0xDpxFmcn3gibvCV14RoVFbOTNuZiJYklot/2McBxg4
         V2ff3g3HfUVoLNRn4g/Y3XRPU+808uPTvBwvrbnsuNg+xkKPCbdeeVMhJd86DP7nQJ6H
         mXYGeTifota0xlyKGZ3yoXIYSf02uYgmmJcIP1BE16xCOhSNt9DZ7qRZuwGUnaCRlKou
         ypelW4G1Yzs6zER1Lg1OEmHhmsRDmZowt1ocO/sw+fprm7ottR9hvgKwXwabwX9SJMu1
         antUBgxzU0BznywdWle32yArnPQC6I2G2M5pXJb9ZpbaCAWBYfSxh3bGrgpoY1sVfgSn
         ROoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=24YU1NBoUybBTpcYsacpUWpYJ0m9Z4yMIofjF2AMjYQ=;
        fh=uQWzRCJRTgVc0reNr7KNDCzP3UqvgVzwgp+5gIQ0JoI=;
        b=QdZYEfyKxlFkI2ioIv6Wkc43OOCsuUnPn/ikSBsSukY2bZz+OdhdzeL+YXJLALmoIH
         H3p982cLUS2P9hUINnn6t00trLppcMha/c+vG7Yc6MYrC1ZG1kOg9IRahaMdN+MZ6W4r
         jOywNOLaKEAE09HpvDAgOf+SntwVAmR9eWytnwuHLFgO4yQFt2HWN//3STIM1Fl92VD/
         DZf3Jw52VSdtbgYiObckBiY8yN8UFhAZgs9NEfrh1HvBfmK8zLLj2RqMxL2lVjDn+DZp
         hedOfjagXWHIqZfz+QCG+4GKMnfYgW3iiVnEQMJvmZP4D2HDXWFkOCUFPzFdCqb4Dpnq
         +8zw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780079663; x=1780684463; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24YU1NBoUybBTpcYsacpUWpYJ0m9Z4yMIofjF2AMjYQ=;
        b=c4SbVtOmS5tmAiv6Xs0ZsWuJ9e+XcmPY/8bSMSE3SdkqxDBfToM2o51+mJu7oANlrE
         0geU3cLHk9I/cA25BCMBEQGF5mvjHQ11TsGFN+3fP8IeWV83g3lIE0BsAGn41kgsbc3k
         GKRDtuizkE+FsKgdJNlRRdaNA+tS+MP6NiEObdxP4Ak5SAgxB9I/cT3I9rD6xWQUFpwV
         TvPEKDmyt3qOPffgdR3XL/tIEAwjBu0KC79UzRVQFGe9eC7xK8D6k4JTsl5WsoKrmfhN
         rSczz44GcrQPiYhczIqolnz6PPKw86oIxgFP3K1ah7xhY8hdQkLC0bfK26DjMtXKJiIa
         oQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079663; x=1780684463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=24YU1NBoUybBTpcYsacpUWpYJ0m9Z4yMIofjF2AMjYQ=;
        b=lcZNso7KJBz3GbL/RWJ1t8TB6rr7WTei0bi2N+YHAqP6gt1H+cpFs0Jqt9Ld+xCzcg
         etegMN9ScZsKmXDEwntzMRi+z9zRKxfcJPf5dHIKbKMyQ4tTtVWIFh/AbLLb9Qal3Tf8
         +6Bb/j02bUswJXiCzmzYvRVhMopngxVKa87crU6ovKEC5kWgzYI/tVz1lCg7QBvOS6Wy
         Jla7+wjZeinRqkPJwl8K1Mzs51+m7dxzblvPM2GH3gRPAHAnBz4JboDizkTMunW/p8OQ
         Z66kwJx8UsLqwUUsekEFmILpK5prT+Vksc8OscCa1zMayHDeq08IZAFm8tgro2rGOEqM
         N39Q==
X-Forwarded-Encrypted: i=1; AFNElJ9RGU9o0kg1b5U/k1QsVgkVRaPFBnDS73id+dueGcrZ9wx7AdhSuhfpK0gdJyvwv6G8Wx7fw9dq2g==@kvack.org
X-Gm-Message-State: AOJu0YzKJe07fy3+fnLUNnmk6Y+CaYC1raZVbEBXOkpGqbkxjR+fvEXM
	cC6qqSOo10k/4ch3uzUKEZo1a71Zy4HY+ds7RLCueKKc2uVPkjhbXLm2XKXA2ceneYO62cls5HS
	4MhZdZBReNfYOWbwcxBAMFtXt3hWhRlQ=
X-Gm-Gg: Acq92OG3Mh9hPPwn9hFiBLn9WRmBAxSIntUIe0TwbLBbsbSDA6m0vAcOT/qX0IGTPJ8
	dIaBsqPj57kK+e1IbEJVOKWcYadO1wLwAdEElCC97Fju+AqC+rZzpFCba4LtQs+FLzvvone4EYT
	hfYiW0fTR4yIppD6Bfti1Pml6V68riCuOGQrYn53HWJtfdDcGsS7gDoDsZH7EjVLAjbfr7rQjA0
	yMZ8X8ohxvRffc24hAYvBTBvY77yM/iJTVCmgqxpYr0/Tj0HY/xlr8SPx5XAkEW8nbWxk1wsWXe
	6aQtTjqdx9XrLmAJUZIEAjlrYdEQDtjKqUUn3iQnOYPOkepV3NK0iD8RTDFi
X-Received: by 2002:a5d:6842:0:b0:43b:5672:efe with SMTP id
 ffacd0b85a97d-45ef6b0153cmr1499734f8f.9.1780079663307; Fri, 29 May 2026
 11:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
In-Reply-To: <tencent_EB78848E34DC7858C873193D67286ECD4B0A@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 11:34:10 -0700
X-Gm-Features: AVHnY4Iug6gLEMoRTeLo5UdQvkvVMFVMPi6Ej_gA1JFadUnPf0B4TOcY1sBxJ8M
Message-ID: <CAKEwX=PvcM1u1n8TTikCAaqJN=GtgfwvnXtU2wCf=Qjp6E_Zew@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/9] mm: admit large swapin by backend range in swapin_sync()
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>, 
	Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: ewg7dz8cn7zkw7kmuxdbftbz9f3atjx5
X-Rspamd-Queue-Id: 13A574000F
X-Rspam-User: 
X-HE-Tag: 1780079664-960135
X-HE-Meta: U2FsdGVkX19yeRsUv+agjwacENXCrH4DnC7N6XI2mVahjfpG0MPNU4o0hERjgYpuLd1tSZNeDCnBrkhU1lzchSKE94TtYaoFZv1cdBrVZxOBOjZQ8w//Tx+YBb9x970AypyPvs/ktB9XIurtgzfP+CjXfp5zBkYgf1P1FI/wGz0wPVij3qLxR58qd9U8vhvB/1IYFYnr13zZWqSzCOErD6TZ+dsOE9MZFE4sPJNsI/8cI3zATKGDuuIEQHNNEmBjrPf8rlIQGpOfJr23HLJYoUJiv1lS5C3p5E0IaxyZ/q47PMoSns3a5kt49YCj6rLQoVQ8kih31+0HO20V3Fyj+AxjJyflW7IntwDEuiRGYf7ihuXO/5CTexPj8rlebyQt8baJW0zYn+cpMPCuU+mi41tkZc481iAOAsUpaYFOseOSc8ihBtO2M2KLevJDo3j5KyW8rpJRvQgFoAyt7YOEpoTALPwMi8y38jkQzKbmPuDMhJWCGoErKimPHG5P8a4qXyLL2g5rh+GXMF9rs8P+jdHTTMVqV1YBTWHzwya/cpzu4spJIXZ+IYknaEvwotZfMeRcSEhb78D3klaEbDjJOv23S4Kj0e2Z80fCm44EOgHdXT+eH52E4Iv9nzG+n74QcL6v/FZD+BJsIbAtiVS/j8lBmx1KPBuCydC8B8fIPoIdgJsI9j8oBxA8VLmQPK2bq9HQ4/4uDT+UCU1JmPgNdSTeXTyGQ7V6gR9GcXSO0RoX/kf1B5VvvkMwtm+pI3x/9KXq/9PZk8vO6HOR3YYVlqDYiRx0t928t6nlYxva5bUP1YEPsVENsfVlbcHWiIMj8oeEGXvw7ATtVlhTsd8tFkCyFMwizLI4N+ZrCHr74rwQGGYpQnnrDOLNq1bNZXJwWKh8V6FLVo4ZJ/Fb+gwqa+YlTB0GjC8EqqEbDlfpcNBzpUyhc5u5MVmB5renHMdp+z9IHHdv2L82ioTnSsv
 XG9JBrQK
 tT21FrJFsxF24D5eQ4UiyZhHK1Wfs2Sn9J2IiKjYdFni0vNNZqMBgjR/Yy+FsVr45ARzvQU1ufw/SyVgd9PTPdsggMnirWtneIR6bkhnnhHpLWPhmRGNrwwNcUmJYIeihG/3xbFZkkm8b4G8VuBwu6EFXB/CRgN/VNuOr3b4Kyjbve7v4SJnjLl3pG8glw/J9fqJ4Lh6UKI6Do66Ez9bKVsw+YyLfex1hLU2NWB/VSwd+sThpEPf4a4HSQAzdjPHYqw520zNoqrkNOGNvfZsRwO8cY2/66StjdP8WGYF4zKqj29kRVQ+XyBjUJq2KT49DrYVfOw15NZtpIbVpNZQbRR1fib5SLkVlA2QE6al+YcD811H+SCFOGQ2H0mp9890WvUCB+l7LJ+jxtdZ23i490NNZtP9wyZLTdiTFl8/5CfcMNX1hr7k9dcDPL+Oe/OBWQ9rxOcB8zUOlgVpASHGvPy3nesYQ+hTtIjSmFMzQkqpHmBM33Eqitx42Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> A large swapin can only read one folio when the whole range has compatibl=
e
> backing. Mixed zswap/disk ranges must not reach large-folio IO, and zswap
> range probes are only snapshots.
>
> Filter the orders passed to swap_cache_alloc_folio() in swapin_sync().
> Uniform zeromap ranges and all-disk ranges keep the existing large swapin
> path. Fully zswap-backed ranges may be tried. Mixed zswap/disk ranges fal=
l
> back before allocation.
>
> After a large swapcache folio is installed, recheck the zswap range and
> drop the fresh folio if it became mixed. Also consume -EAGAIN from
> swap_read_folio() the same way. Both cases retry order-0, where each slot
> can resolve its current backend independently.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/memcontrol-v1.c |   8 ++-
>  mm/memory.c        |  31 ++++++++-
>  mm/swap_state.c    | 169 ++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 194 insertions(+), 14 deletions(-)
>
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 765069211567..5b11b8055c66 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -682,8 +682,8 @@ void __memcg1_swapout(struct folio *folio, struct swa=
p_cluster_info *ci)
>   * memcg1_swapin - uncharge swap slot on swapin
>   * @folio: folio being swapped in
>   *
> - * Call this function after successfully adding the charged
> - * folio to swapcache.
> + * Call this after the charged folio has been added to swapcache and the=
 caller
> + * is no longer going to drop it back to swapped-out state.
>   *
>   * Context: The folio has to be in swap cache and locked.
>   */
> @@ -721,7 +721,9 @@ void memcg1_swapin(struct folio *folio)
>         id =3D __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
>                                  nr_pages);
>         swap_cluster_unlock(ci);
> -       mem_cgroup_uncharge_swap(id, nr_pages);
> +
> +       if (id)
> +               mem_cgroup_uncharge_swap(id, nr_pages);
>  }
>  #endif
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 5a365492a9a2..d73a19692dea 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4538,6 +4538,24 @@ static inline bool should_try_to_free_swap(struct =
swap_info_struct *si,
>                 folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_page=
s(folio));
>  }
>
> +static void memcg1_swapin_retry_folio(struct folio *folio,
> +                                     struct vm_fault *vmf)
> +{
> +       if (!folio_test_large(folio) || !folio_test_swapcache(folio))
> +               return;
> +
> +       if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT) {
> +               if (!folio_trylock(folio))
> +                       return;
> +       } else {
> +               folio_lock(folio);
> +       }
> +
> +       if (folio_test_large(folio) && folio_test_swapcache(folio))
> +               memcg1_swapin(folio);
> +       folio_unlock(folio);
> +}
> +
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
>  {
>         vmf->pte =3D pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> @@ -4857,8 +4875,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>
>         swapcache =3D folio;
>         ret |=3D folio_lock_or_retry(folio, vmf);
> -       if (ret & VM_FAULT_RETRY)
> +       if (ret & VM_FAULT_RETRY) {
> +               memcg1_swapin_retry_folio(folio, vmf);
>                 goto out_release;
> +       }
>
>         page =3D folio_file_page(folio, swp_offset(entry));
>         /*
> @@ -5067,6 +5087,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> +               if (folio_test_large(swapcache))
> +                       memcg1_swapin(swapcache);
>                 folio_put_swap(swapcache, NULL);
>         } else if (!folio_test_anon(folio)) {
>                 /*
> @@ -5076,6 +5098,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> +               if (folio_test_large(folio))
> +                       memcg1_swapin(folio);
>                 folio_put_swap(folio, NULL);
>         } else {
>                 VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
> @@ -5132,8 +5156,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (vmf->pte)
>                 pte_unmap_unlock(vmf->pte, vmf->ptl);
>  out_page:
> -       if (folio_test_swapcache(folio))
> +       if (folio_test_swapcache(folio)) {
> +               if (folio_test_large(folio))
> +                       memcg1_swapin(folio);
>                 folio_free_swap(folio);
> +       }
>         folio_unlock(folio);
>  out_release:
>         folio_put(folio);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index d37097913b30..f03ad4832f16 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -21,6 +21,7 @@
>  #include <linux/migrate.h>
>  #include <linux/vmalloc.h>
>  #include <linux/huge_mm.h>
> +#include <linux/zswap.h>
>  #include <linux/shmem_fs.h>
>  #include "internal.h"
>  #include "swap_table.h"
> @@ -403,7 +404,8 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>  static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>                                         swp_entry_t targ_entry, gfp_t gfp=
,
>                                         unsigned int order, struct vm_fau=
lt *vmf,
> -                                       struct mempolicy *mpol, pgoff_t i=
lx)
> +                                       struct mempolicy *mpol, pgoff_t i=
lx,
> +                                       bool defer_memcg1_swapin)
>  {
>         int err;
>         swp_entry_t entry;
> @@ -466,7 +468,8 @@ static struct folio *__swap_cache_alloc(struct swap_c=
luster_info *ci,
>         }
>
>         /* memsw uncharges swap when folio is added to swap cache */
> -       memcg1_swapin(folio);
> +       if (!defer_memcg1_swapin || !order)
> +               memcg1_swapin(folio);
>         if (shadow)
>                 workingset_refault(folio, shadow);
>
> @@ -495,9 +498,12 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>   * Return: Returns the folio if allocation succeeded and folio is in the=
 swap
>   * cache. Returns error code if failed due to race, OOM or invalid argum=
ents.
>   */
> -struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> -                                    unsigned long orders, struct vm_faul=
t *vmf,
> -                                    struct mempolicy *mpol, pgoff_t ilx)
> +static struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry,
> +                                             gfp_t gfp, unsigned long or=
ders,
> +                                             struct vm_fault *vmf,
> +                                             struct mempolicy *mpol,
> +                                             pgoff_t ilx,
> +                                             bool defer_memcg1_swapin)
>  {
>         int order, err;
>         struct folio *ret;
> @@ -512,7 +518,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ=
_entry, gfp_t gfp,
>
>         do {
>                 ret =3D __swap_cache_alloc(ci, targ_entry, gfp, order,
> -                                        vmf, mpol, ilx);
> +                                        vmf, mpol, ilx,
> +                                        defer_memcg1_swapin);
>                 if (!IS_ERR(ret))
>                         break;
>                 err =3D PTR_ERR(ret);
> @@ -525,6 +532,124 @@ struct folio *swap_cache_alloc_folio(swp_entry_t ta=
rg_entry, gfp_t gfp,
>         return ret;
>  }
>
> +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> +                                    unsigned long orders, struct vm_faul=
t *vmf,
> +                                    struct mempolicy *mpol, pgoff_t ilx)
> +{
> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
> +                                       mpol, ilx, false);
> +}
> +
> +static struct folio *swap_cache_alloc_speculative_folio(swp_entry_t targ=
_entry,
> +                                                       gfp_t gfp,
> +                                                       unsigned long ord=
ers,
> +                                                       struct vm_fault *=
vmf,
> +                                                       struct mempolicy =
*mpol,
> +                                                       pgoff_t ilx)
> +{
> +       /*
> +        * Speculative large swapin may drop this fresh swapcache folio a=
nd
> +        * retry order-0 after backend or page-table revalidation. Keep t=
he
> +        * cgroup v1 memsw swap owner until the caller commits the folio.
> +        */
> +       return __swap_cache_alloc_folio(targ_entry, gfp, orders, vmf,
> +                                       mpol, ilx, true);
> +}
> +
> +static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages=
)
> +{
> +       unsigned int ci_start =3D swp_cluster_offset(entry);
> +       struct swap_cluster_info *ci =3D __swap_entry_to_cluster(entry);
> +       bool is_zero;
> +       unsigned int i;
> +
> +       if (ci_start + nr_pages > SWAPFILE_CLUSTER) {
> +               VM_WARN_ON_ONCE(1);
> +               return false;
> +       }
> +
> +       rcu_read_lock();
> +       if (!rcu_dereference(ci->table)) {
> +               rcu_read_unlock();
> +               return true;
> +       }
> +
> +       is_zero =3D __swap_table_test_zero(ci, ci_start);
> +       for (i =3D 1; i < nr_pages; i++) {
> +               if (is_zero !=3D __swap_table_test_zero(ci, ci_start + i)=
) {
> +                       rcu_read_unlock();
> +                       return false;
> +               }
> +       }
> +       rcu_read_unlock();
> +
> +       return true;
> +}
> +
> +static unsigned long swapin_admit_orders(swp_entry_t entry,
> +                                        unsigned long orders)
> +{
> +       unsigned long candidates =3D orders & ~BIT(0);
> +       unsigned long admitted =3D orders & BIT(0);
> +       int order;
> +
> +       if (!candidates)
> +               return orders;
> +
> +       while (candidates) {
> +               enum zswap_range_state state;
> +               unsigned int nr_pages;
> +               swp_entry_t range_entry;
> +               bool admit =3D false;
> +
> +               order =3D fls_long(candidates) - 1;
> +               if (order > MAX_PAGE_ORDER) {
> +                       candidates &=3D ~BIT(order);
> +                       continue;
> +               }
> +
> +               nr_pages =3D 1U << order;
> +               range_entry =3D swp_entry(swp_type(entry),
> +                                       round_down(swp_offset(entry), nr_=
pages));
> +               if (!swapin_zeromap_same(range_entry, nr_pages))
> +                       goto next;
> +
> +               state =3D zswap_probe_range(range_entry, nr_pages);
> +               switch (state) {
> +               case ZSWAP_RANGE_MIXED:
> +                       break;
> +               case ZSWAP_RANGE_ALL_ZSWAP:
> +               case ZSWAP_RANGE_NEVER_ENABLED:
> +               case ZSWAP_RANGE_NO_ZSWAP:
> +                       admit =3D true;
> +                       break;
> +               }
> +
> +next:
> +               if (admit)
> +                       admitted |=3D BIT(order);
> +               else
> +                       count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> +               candidates &=3D ~BIT(order);
> +       }
> +
> +       return admitted ? admitted : BIT(0);
> +}
> +
> +static bool zswap_needs_order0_retry(struct folio *folio)
> +{
> +       if (!folio_test_large(folio))
> +               return false;
> +
> +       /*
> +        * Admission sees only an advisory zswap snapshot. Recheck after =
the
> +        * large swapcache folio is installed; if the range became mixed,=
 drop
> +        * the fresh folio before IO and let order-0 handle each slot.
> +        */
> +       return zswap_probe_range(folio->swap, folio_nr_pages(folio)) =3D=
=3D
> +              ZSWAP_RANGE_MIXED;
> +}
> +
>  /*
>   * If we are the only user, then try to free up the swap cache.
>   *
> @@ -634,7 +759,8 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         return folio;
> -               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NULL=
, mpol, ilx);
> +               folio =3D swap_cache_alloc_folio(entry, gfp, BIT(0), NULL=
,
> +                                              mpol, ilx);
>         } while (PTR_ERR(folio) =3D=3D -EEXIST);
>
>         if (IS_ERR_OR_NULL(folio))
> @@ -677,18 +803,43 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t =
gfp, unsigned long orders,
>         struct folio *folio;
>         int ret;
>
> +       orders =3D swapin_admit_orders(entry, orders);
> +again:
>         do {
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         return folio;
> -               folio =3D swap_cache_alloc_folio(entry, gfp, orders, vmf,=
 mpol, ilx);
> +               folio =3D swap_cache_alloc_speculative_folio(entry, gfp, =
orders,
> +                                                          vmf, mpol, ilx=
);
>         } while (PTR_ERR(folio) =3D=3D -EEXIST);
>
>         if (IS_ERR(folio))
>                 return folio;
>
> +       if (zswap_needs_order0_retry(folio)) {
> +               count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN_FALLB=
ACK);
> +               /*
> +                * The folio is newly allocated, locked, clean and not up=
todate;
> +                * no data has been read into it. Removing it only restor=
es the
> +                * swap table entries so order-0 swapin can resolve a bac=
kend
> +                * race without attempting speculative large-folio zswapi=
n.
> +                */
> +               swap_cache_del_folio(folio);
> +               folio_unlock(folio);
> +               folio_put(folio);
> +               orders =3D BIT(0);
> +               goto again;
> +       }
> +
>         ret =3D swap_read_folio(folio, NULL);
> -       VM_WARN_ON_ONCE(ret =3D=3D -EAGAIN);
> +       if (ret =3D=3D -EAGAIN) {

Can this happen? After you add the entire swap range to swap cache,
backend is locked. Zswap writeback bails out if it fails to add the
page to swap cache.

I think you can just check (zswap_probe_range or wev) before
swap_read_folio(). If the range is still fully backed by zswap, you
are good to go. Otherwise, bail here immediately.

Then you don't need all the complexity with extending swap_read_folio
to handle mixed range errors (for now at least).

