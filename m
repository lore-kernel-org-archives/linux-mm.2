Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E92CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 20:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8CC8E0052; Wed,  8 Oct 2025 16:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267CA8E0002; Wed,  8 Oct 2025 16:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157CE8E0052; Wed,  8 Oct 2025 16:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02B608E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 16:59:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A672911AC8F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:59:53 +0000 (UTC)
X-FDA: 83976163866.15.A7C34D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8A48160013
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:59:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9kSZwg9;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759957191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wpYBzFdNUy7Yl2Lu8Dzrz5oaZLBU2NmFMCRV/02RaM=;
	b=tGeyu1NrjT+TNdojD3KJp0fIUsd0FsdbqnN5mtl1GKn+efhla2sYFamDuM49hShkVWH7PP
	GwkPtQummzwwtmpEKBH6lV7ws2kk0TE5hI37sU3bVWddBUHDC2fHywwiPK1km6YgLlUVp/
	hU4nTHLMpKfihsDw4xpzZKmqzo5C+5I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V9kSZwg9;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759957191; a=rsa-sha256;
	cv=none;
	b=vz4XylIMIlmTYa2sPlit+3hmDUypqJviciHtS7ZkBx6QHPEl5YRFMFVAVIE2EoTvuU27D/
	mokK9R1w0Iwgyn4wEILk7YI60bqrHW0aXsfAs5WpAp1ututy/B0bxC4YE/7Wp2qRydffKu
	V9O+CdsIiv6VnHZ0LJMPnfuRlzuAnaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B37B845549
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93296C4CEF4
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 20:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759957190;
	bh=eUqCLx3itxMEwtReJ0MfCq6If7yIzpbBzgg6uk08zrU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V9kSZwg9yQlkKFj2D52uI+fwafGD07n+yKH3NhTJFgoXSHRwu7GGLbezH9b1+VL1w
	 H+pDtxXRCCQNgCuurynceA81p550Im3P4qBqah5+4v5jDwH14kfR4/VrSZqSxwjZO6
	 l0f/Ii4mXyga+T9yP0tV0qnWvD6fE4b/zOoH+m4QXdEOOG5IkV4k/xNTQVRTSlsXRR
	 cqvvoPVvVNjSjDxcZI7XnnsPOfbwVq/atbhKUxdLbl9TiJZqZRGg7RdrszD0/VjHgE
	 wYspemEBm342MmNS+raj7p3B8keUdMoeQvdxCRRY14I0+jHu8o8p6saiEJDmgUb2OQ
	 1JvGsRZtmnW/g==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6361a421b67so388587d50.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 13:59:50 -0700 (PDT)
X-Gm-Message-State: AOJu0YzUvtN1LnZdr6GVBN2mIcYxqE03H3qQwo/gBdn4Lp2hv/1g5lVH
	i/mDoaxhzoS98iRf1V2DCOMnm46G5IlGP0ucyA3Xp5ARZF6vnxzc8ucYlSz8ijlCrwSPuGZ3f+K
	ousZX0u7GtCNRwMFJb7DagMqAVcuO1why7Np1KJrMvA==
X-Google-Smtp-Source: AGHT+IENfMLmi+x/bpMSbJWEZ+uKHClAL8tDN6VRNwU0GfnLGeFCj2Ji7sf8qlTzCMA0o7poF6JRLsow7KuubJT8xOM=
X-Received: by 2002:a53:cec2:0:b0:62a:b545:54b6 with SMTP id
 956f58d0204a3-63ccb8f2f76mr3700146d50.35.1759957189849; Wed, 08 Oct 2025
 13:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Oct 2025 13:59:38 -0700
X-Gmail-Original-Message-ID: <CACePvbV=5A-=eqh8Fq+pmNSZ7fPq03SmUw8at-pN_N+8vFSpXQ@mail.gmail.com>
X-Gm-Features: AS18NWCbUb_oLy12b0rJSYPGGNJHkxb5YMYEOs8q-6mh6rFyluLkQuXK1GMBb1s
Message-ID: <CACePvbV=5A-=eqh8Fq+pmNSZ7fPq03SmUw8at-pN_N+8vFSpXQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8A48160013
X-Stat-Signature: pfbmci9sy8brwim1gwq3t9k3q7hr9ie6
X-Rspam-User: 
X-HE-Tag: 1759957191-29018
X-HE-Meta: U2FsdGVkX186HCLot55JRwRqdAh8CVbZVYUlbzvWuMTxyxA3oBiCMZ6WoMYRG0M10rDCvV/eNmB/mIYPiXoAs+3uPo7xI5yMoB1LPr+4TtJs6FuSxBa/NpayytYDW8N55whxm6iww09zyPuM9tzN3nx2eood7tXeThU0nUNW5L/SfV6DQbv5kxKaOTHGH+b+8d1iCxeSS0VcUf3k0Rra/Avpujq8UjhStSuVbqXfIoL5PrqlPxtMoOLoEgzzPHcGUVFW61sz27KWpjJlnrvsFvEtvZafNCYWOxTte9Hvqbig2S5B/Y8YA+TLbsQKds6EWuibMauJXm0UZL9N2vtLnaUX2ZLP/8vzQFgBAEVBYo8ZcoRLsmU9dmLOt5Bz52inPaakXrJTpD22JntcuT0BtfzInLr7akb+qKOfjF/d+aNvkXBgDr9smT0UvbTF9otCuEDE0w5NVig5ZEZvC6EupuQTz7d+1UDnrH/b/bijolD9r1TXG1ydRIdZ1yqihMwRb9Pz0X4Muv4OIASOMMqo87k1wO9310gaoxuZKQ6Mrg0l9ORYI5NQo+JpTJeSW4AGa7QiUsdfuKJXBX+1TlolkbvImp5YzoUoAcJU1KS1TOVqWyLkoPWl1ctUcZoizpk7xpPYIw0KEEjXUIDJ+jXL7mpCN44fBpt5P6FoexNXAkIzATlFs0hajknhgQI6nY7n0B4LYTZyT0W/7W9d1XTuoieEJ//umj+ERNQDJCSINrVHuNMginEtpsgpdDFqZGW3RUXb3QyZU1mC9zUP5pwin82W5w072W9xOAciezARf8IkQfe11OQeBm8Po7B6nNHPZELQWrycE3GxOu1heU5wTWOYMNrnYPrrnpz0yKoL2JvssBW32IsECrxjq5x6ypwFVYi3oVa4sPPmlTll2YRqySQVoOxeg+M+Q4KPU4fH1IrnyVBDYkXVAI9vM1CDnlHksOdjDacgWVhnTDYRpaN
 hl5M5AuS
 ij9heXemf5072KY8x1lz3oT8xcUqPjThjO+pcfixjdYdDguRPXVbDN94mptUklERxnoFFoqKC02mAsBjLkiEuhN5V5k5UEl1T6HrelORudD35wF0xM3M6TaWW6SeNODwhT/c8UzkHSKd24nq/qHuig/JfPx3+ReKw+n4pI8txwXymFIw0Dj3OUO5VHfjl5sPXWZ+NcOompqJ5u07oSpGAYen5ErsDrdDYSsqqFRaNOb3ukhgM+c7irvAGl0YcqrIDnz1d7U56GRTFWEDKHXhBFHYVvMpMsG3P3DwtXU0Ggb6NTQpbDeh+iYpv7fs0Zzb4xN7jl47LRPJ1JHt8lHcb1aazPQZWu4HYx4KZ7cDPWhGuo3wuufLWMUom9odu7gnODivFzj9VY5eFTpc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Mon, Oct 6, 2025 at 1:03=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap=
:
> use the swap table for the swap cache and switch API"). Before that
> commit the GFP parameter is already almost identical for all callers, so
> nothing changed by that commit. Swap table just moved the GFP to lower
> layer and make it more defined and changes depend on atomic or sleep
> allocation.
>
> Now this parameter is no longer used, just remove it. No behavior
> change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h | 4 ++--
>  mm/shmem.c           | 2 +-
>  mm/swapfile.c        | 2 +-
>  mm/vmscan.c          | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index e818fbade1e2..a4b264817735 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(void)
>  }
>
>  extern void si_swapinfo(struct sysinfo *);
> -int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
> +int folio_alloc_swap(struct folio *folio);
>  bool folio_free_swap(struct folio *folio);
>  void put_swap_folio(struct folio *folio, swp_entry_t entry);
>  extern swp_entry_t get_swap_page_of_type(int);
> @@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entry_t entry)
>         return 0;
>  }
>
> -static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
> +static inline int folio_alloc_swap(struct folio *folio)
>  {
>         return -EINVAL;
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 45f51745ad88..63092cc0b141 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1617,7 +1617,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> -       if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __GF=
P_NOWARN)) {
> +       if (!folio_alloc_swap(folio)) {
>                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
>                 int error;
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 732e07c70ce9..534b21aeef5a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
>   * Context: Caller needs to hold the folio lock.
>   * Return: Whether the folio was added to the swap cache.
>   */
> -int folio_alloc_swap(struct folio *folio, gfp_t gfp)
> +int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index aadbee50a851..c99f7d6d5dd9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1296,7 +1296,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>                                             split_folio_to_list(folio, fo=
lio_list))
>                                                 goto activate_locked;
>                                 }
> -                               if (folio_alloc_swap(folio, __GFP_HIGH | =
__GFP_NOWARN)) {
> +                               if (folio_alloc_swap(folio)) {
>                                         int __maybe_unused order =3D foli=
o_order(folio);
>
>                                         if (!folio_test_large(folio))
> @@ -1312,7 +1312,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>                                         }
>  #endif
>                                         count_mthp_stat(order, MTHP_STAT_=
SWPOUT_FALLBACK);
> -                                       if (folio_alloc_swap(folio, __GFP=
_HIGH | __GFP_NOWARN))
> +                                       if (folio_alloc_swap(folio))
>                                                 goto activate_locked_spli=
t;
>                                 }
>                                 /*
>
> --
> 2.51.0
>

