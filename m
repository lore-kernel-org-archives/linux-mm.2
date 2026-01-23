Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A179D6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB6E6B038A; Thu, 22 Jan 2026 23:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874A36B0390; Thu, 22 Jan 2026 23:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781FD6B0392; Thu, 22 Jan 2026 23:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 655496B0390
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:15:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D298141D7D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:46:39 +0000 (UTC)
X-FDA: 84361539318.03.484420F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7505A40005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:46:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2GSasFj;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769132797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlAd1btw9DdbASDM3PEcxa69BJrR+1RC5A8LiO9yh7I=;
	b=TGEIV7RpeqwT76GRuXfEM1Q3ZxGcub2MNheUx/QT3JaeTAkvhtTQVbJ7ZjMxPQ0o/sxkjD
	alB2Mv8zzX1ZHKa/uF2Rcex6FA84JorbQBZ3bzVIdP1+m7MGr4hnVI3d7SbG3Rq2uaAek9
	pweI606/ekADKCkPgg97prY6CgVgv9s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s2GSasFj;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769132797; a=rsa-sha256;
	cv=none;
	b=lZk5kYho8r6IdIO/Ly6mFQ9kEXgLdWZyHexBsx/SjzJLqq5flc4jo7fYkMW2sGodZWodI4
	yp/fksjfWhUrPGHbGCG57WUlMQw9zGgY9udY3DjAQwuS7mKzn+a/WYULcGirSJWi8G2cc8
	9QSP5kwIcWNdV3WJFmgKn1BfC/IeN/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A97360148
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF845C2BC9E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769132795;
	bh=3n1kN6yU3UzQT4Lma3/YbJ3jqKYjPnr9GLpUMco4Z24=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s2GSasFjjZyZzFb3bGk9vTxEuOFrBf9WHE7QBAjFxLVnkRR7oM5WejxLeaTbmV6Af
	 XPLyT7Bqc6A6bBoJ8/crxLPZTn5WCTdh6UTqpYuvG5iUKsts/MbGIf8EciSoHKvcwt
	 +kGxdc2+xudUfklPLXPoeKghG5WpM3mnXgA187/ufETiPIDgLVxw20iqFrF8HvFpO1
	 4xjgkMi3TdslFbNQsfM9NJ+n48lZhyz8jiuYQD7GnLWMvmbfKn/jj1iVhmcp+S5j30
	 d17CcM9fLnKchNhg8qTiE98D4YX2kGfF94h1WEZ8L9XDrlmqI6Pjqk8YZBGUkPzhqm
	 ttFdOBZ2O061w==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-79407df9391so18195557b3.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:46:35 -0800 (PST)
X-Gm-Message-State: AOJu0YwdmhCKne+izoq+vt7c/WdZ+zoXdV5cP6eAJAXxrZyZl/60F5cI
	uIdzcp7NWH1EvWUubHa4nxwzMcndMgrFU0M7VbaPbx6c4RFLmM9a6weQkAZdRL2VxDq34NDFfz/
	R3R5amrO2bf340ViZFEnTYaILfJIY2UxhufsA63fWtw==
X-Received: by 2002:a05:690c:fc2:b0:794:2fed:5370 with SMTP id
 00721157ae682-794398bbae2mr13533937b3.4.1769132794957; Thu, 22 Jan 2026
 17:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
In-Reply-To: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 22 Jan 2026 17:46:24 -0800
X-Gmail-Original-Message-ID: <CACePvbVG0OubuZfT0+kY77BjrePQsopdFVTyuorMm_eE=chmiQ@mail.gmail.com>
X-Gm-Features: AZwV_QgOZRgtcLiF7s7TDclkawC0lZhk5ppCm7mmTLXyBp7ktzXk191M10WUAMc
Message-ID: <CACePvbVG0OubuZfT0+kY77BjrePQsopdFVTyuorMm_eE=chmiQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry split
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: b61mruk71fdb5jqamoqd9qq3rq1yj4it
X-Rspamd-Queue-Id: 7505A40005
X-Rspam-User: 
X-HE-Tag: 1769132797-535202
X-HE-Meta: U2FsdGVkX1/9mkyucB/Dhm5EHV6jU1QtY1LOLlCRWQhLZ99J7S7C0S4Tn3vPlxQ401LIBcplVWi0blOi6cxzRNz0NSma4NPmhnsD9QAXV2G6VwMwkYUcE3FReHLj+hHVSwbHZYbHEHr4DmZiMOLRkMEflWRlBhmVYlLwWLn9qXhDqwTgbB7XFyudTf44C8EXLzIdsx4IFw6H3kxQWiPj4kkHtybkl7eWAUKcmrvoiim3/vEyZjOGbgAjEfhsSXEJ+qvzzRrHG3TOq4bJZsEFGY86NhKElVUjWgWBiLjEkWYJFpp94kByPVd9caIdWYHXVtb6JA7oiEarI4Bw63mHDuTuXrGOASmE8638Ikn+Iqd3AWVKCVjKye9JnAjNVuWzajYDAcQpQytXZ+dWSRdNXrZHpztIwAGj4zadxGFVhZsiBJ+WXj2tdEsjgPnXjuimStpFACc8EbwFYDqNLsvrfy/U2ZUJXsHEOxLZ0B7l4MO1Pp3FToXR3hTI7SDu/bFp5ITpTv5OmzQXMuVdAZXmgByY7CbhETPzoE5/unLCroZHW2EVIml1Q16/Y40fXK7ZWZPUY17qXX/q/FLLL+GdgquLUraCH6CxqB69o2S4qMNYcy8mGeKrR/slQQMtc9Iroq5VzP87xJDIbD6AyG/V2dqbw4KK1lcNCF7CqQqSMW1SB0+xRkfRcMfVUDPFb1zPNTGHtvODMDVpQu6yMdZUGuKwc+ou1GPIqAWUe9CZt3wmp1nF8o+IASHCV0kpGm6iA48CO5/G4e1l3v/os/EO/om3QcmujxyEkc1f1yFSNmUAJgszpOWW+MiYYUJIRu/18qnAR1S3NqRjP/vtBXKP9yOKGvB34u3I/AURAomFf/sw6H1+6h0P0iXKfn8Nf4rwCuZlni1S6I/EpAsH8bGJq0wdaNljVJCLCV/mvdKfAGem1stKiT5Sk8eFuXNPZiyJa/2EG54NU5j4gLRn0qb
 DAgPEx9S
 UTj5/Joh2iSCFVCAjaLgRPu57oWt8Y+1z8O13gEdhl//WGAdMl7cTEaaK4hZiIlg6hy0g89bw5yK7sje8qULZVbLjbCnw+XzlCHPmViY6HM5Odq5gVUlRIpOMjgDHR8OyKGmVqQ/DoXYXpycDkNxr2i22DLBDoDS9Dh77OtydZaUHhF3hdup5arolWgCh15Zx5/47cmAKNP9hP5LKC33kMT4WDIPtcaLC8YsBgt7qExa0UNuRTl0Y3tfscEidMyfElq6JUy+BIY+a3axdW3HHU/3ozzJFo5HKTHiwNvJYyzLLvQJ3Hmdl78fbGEL+9YMcBqywBnOr8l3JiA4Uc7euozqzEchxJqFFah1U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 8:11=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> The helper for shmem swap freeing is not handling the order of swap
> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry, but
> it gets the entry order before that using xa_get_order without lock
> protection, and it may get an outdated order value if the entry is split
> or changed in other ways after the xa_get_order and before the
> xa_cmpxchg_irq.
>
> And besides, the order could grow and be larger than expected, and cause
> truncation to erase data beyond the end border. For example, if the
> target entry and following entries are swapped in or freed, then a large
> folio was added in place and swapped out, using the same entry, the
> xa_cmpxchg_irq will still succeed, it's very unlikely to happen though.
>
> To fix that, open code the Xarray cmpxchg and put the order retrieval
> and value checking in the same critical section. Also, ensure the order
> won't exceed the end border, skip it if the entry goes across the
> border.
>
> Skipping large swap entries crosses the end border is safe here.
> Shmem truncate iterates the range twice, in the first iteration,
> find_lock_entries already filtered such entries, and shmem will
> swapin the entries that cross the end border and partially truncate the
> folio (split the folio or at least zero part of it). So in the second
> loop here, if we see a swap entry that crosses the end order, it must
> at least have its content erased already.
>
> I observed random swapoff hangs and kernel panics when stress testing
> ZSWAP with shmem. After applying this patch, all problems are gone.
>
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

For the record the two stage retry loop in shmem_undo_range() is not
easy for me to follow. Thanks for the fix.

Chris

> ---
> Changes in v3:
> - Rebased on top of mainline.
> - Fix nr_pages calculation [ Baolin Wang ]
> - Link to v2: https://lore.kernel.org/r/20260119-shmem-swap-fix-v2-1-034c=
946fd393@tencent.com
>
> Changes in v2:
> - Fix a potential retry loop issue and improvement to code style thanks
>   to Baoling Wang. I didn't split the change into two patches because a
>   separate patch doesn't stand well as a fix.
> - Link to v1: https://lore.kernel.org/r/20260112-shmem-swap-fix-v1-1-0f34=
7f4f6952@tencent.com
> ---
>  mm/shmem.c | 45 ++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..6c3485d24d66 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -962,17 +962,29 @@ static void shmem_delete_from_page_cache(struct fol=
io *folio, void *radswap)
>   * being freed).
>   */
>  static long shmem_free_swap(struct address_space *mapping,
> -                           pgoff_t index, void *radswap)
> +                           pgoff_t index, pgoff_t end, void *radswap)
>  {
> -       int order =3D xa_get_order(&mapping->i_pages, index);
> -       void *old;
> +       XA_STATE(xas, &mapping->i_pages, index);
> +       unsigned int nr_pages =3D 0;
> +       pgoff_t base;
> +       void *entry;
>
> -       old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0=
);
> -       if (old !=3D radswap)
> -               return 0;
> -       free_swap_and_cache_nr(radix_to_swp_entry(radswap), 1 << order);
> +       xas_lock_irq(&xas);
> +       entry =3D xas_load(&xas);
> +       if (entry =3D=3D radswap) {
> +               nr_pages =3D 1 << xas_get_order(&xas);
> +               base =3D round_down(xas.xa_index, nr_pages);
> +               if (base < index || base + nr_pages - 1 > end)
> +                       nr_pages =3D 0;
> +               else
> +                       xas_store(&xas, NULL);
> +       }
> +       xas_unlock_irq(&xas);
> +
> +       if (nr_pages)
> +               free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pa=
ges);
>
> -       return 1 << order;
> +       return nr_pages;
>  }
>
>  /*
> @@ -1124,8 +1136,8 @@ static void shmem_undo_range(struct inode *inode, l=
off_t lstart, uoff_t lend,
>                         if (xa_is_value(folio)) {
>                                 if (unfalloc)
>                                         continue;
> -                               nr_swaps_freed +=3D shmem_free_swap(mappi=
ng,
> -                                                       indices[i], folio=
);
> +                               nr_swaps_freed +=3D shmem_free_swap(mappi=
ng, indices[i],
> +                                                                 end - 1=
, folio);
>                                 continue;
>                         }
>
> @@ -1191,12 +1203,23 @@ static void shmem_undo_range(struct inode *inode,=
 loff_t lstart, uoff_t lend,
>                         folio =3D fbatch.folios[i];
>
>                         if (xa_is_value(folio)) {
> +                               int order;
>                                 long swaps_freed;
>
>                                 if (unfalloc)
>                                         continue;
> -                               swaps_freed =3D shmem_free_swap(mapping, =
indices[i], folio);
> +                               swaps_freed =3D shmem_free_swap(mapping, =
indices[i],
> +                                                             end - 1, fo=
lio);
>                                 if (!swaps_freed) {
> +                                       /*
> +                                        * If found a large swap entry cr=
oss the end border,
> +                                        * skip it as the truncate_inode_=
partial_folio above
> +                                        * should have at least zerod its=
 content once.
> +                                        */
> +                                       order =3D shmem_confirm_swap(mapp=
ing, indices[i],
> +                                                                  radix_=
to_swp_entry(folio));
> +                                       if (order > 0 && indices[i] + (1 =
<< order) > end)
> +                                               continue;
>                                         /* Swap was replaced by page: ret=
ry */
>                                         index =3D indices[i];
>                                         break;
>
> ---
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> change-id: 20260111-shmem-swap-fix-8d0e20a14b5d
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>

