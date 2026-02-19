Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C725E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA5C6B0088; Thu, 19 Feb 2026 02:18:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE4C6B0089; Thu, 19 Feb 2026 02:18:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4EC6B008A; Thu, 19 Feb 2026 02:18:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EDAC6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:18:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 074BA58EAC
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:18:40 +0000 (UTC)
X-FDA: 84460353600.24.C62DECE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C67FA000D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:18:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ikUA0hf/";
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771485518; a=rsa-sha256;
	cv=none;
	b=susCN3mSvA2oPjs86HaCb2W3wlWEOR2KTsXOnZYlD2HWZEDEKPF/HrZvLtpm+wu+HUFml3
	kDGUrmJf9UT+KXDiF264b5qGBaFTQaCWGhjktU1Q2Ilul1jp02spICRtJZ6BZYzBBPocih
	iJJdCpv1lqGPeBBTqmIlzpHOp3ZzsVA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ikUA0hf/";
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771485518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIN59Bfs8XU7BWdkzpcczgrh5rpl3+VaiYTbqpxF6GE=;
	b=OUwiqX016U/T0zRtJH9UAeJPVmBKqSDmQ7zI+tHiEIaozYBcleeRjan0q6QZz/FVVouhCe
	UntMQaaYmXbKtmU47gIVAtMw3/MlYswPkEMu4jpd+LneeBukFBnRuD6mVwF3ciWPz8e3On
	Z3sLR+zD9enDpvsROmjvX3+g+Fp157g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E7D344527
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C204C2BCAF
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771485517;
	bh=yI5YHEdHSXppNqEi1vOfQlOdWb/dCPKXViqBNavPZ0A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ikUA0hf/WaK5sTrTt9qL6BtZH4xnQhmIw1h7cQo7o+YFAeoiPtLhHWTtdsAZAnKV3
	 erMOaPD8GHtWGESf4qpn1ld7eup/pDX3LyY1XWisb3TyslBc4ebU0RIxeKtLDcDcu1
	 4koNFsl1XwVzABsSoaHNm2QQ+1+86JqU2gl40bSEzjHSuchwyMGYc0ZuCqyraYPWDr
	 ZVhTCaelCpamzGDZ3o2nPRxFjrYRkFkGxQlOhwpCuQf0bLK1OosITk79myR+qZUDck
	 cGnU0KasOiyK0/nqLN7cq0qTCUEM4ooHZdbd9On10w3a3p7Wa1oL9IpmQvirRR8CpR
	 I87wUWqnjWaLQ==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-794fe16d032so5657017b3.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:18:37 -0800 (PST)
X-Gm-Message-State: AOJu0Yw+VdZPF5/XHsol04RY8ygton7z7jErML2ZX9LGSV5xgXVqSxLc
	4G6R4s8uiOwgsEiSad9bkWQAil2tWaDzhzTeXsNpynpBbMCtl604Keey6IAtAinwCAAqbdz3yI4
	P/U5EYV73dkfTWcFrGe7PWcr0sgpx2Xj+fWbzaNE8Yw==
X-Received: by 2002:a05:690e:4005:b0:64a:e61f:a6f1 with SMTP id
 956f58d0204a3-64c5556248fmr3463431d50.6.1771485516210; Wed, 18 Feb 2026
 23:18:36 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-11-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-11-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:18:25 -0800
X-Gmail-Original-Message-ID: <CACePvbUWVvy68XGfRTKxG6cTSKSt5OGRy=FhO5_TYY=oCO=2FQ@mail.gmail.com>
X-Gm-Features: AZwV_Qhk6bFEH9ulAY7xmyQBsyZP277YFFryCuv7D-G4cJHhnJjODCfs37JRv3g
Message-ID: <CACePvbUWVvy68XGfRTKxG6cTSKSt5OGRy=FhO5_TYY=oCO=2FQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] mm, swap: simplify checking if a folio is swapped
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3C67FA000D
X-Stat-Signature: 86x3hsm3rje38xumzgh4h3hx3zcpy76y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771485518-884629
X-HE-Meta: U2FsdGVkX18cvrRxhAL8PzWFtUW6h249XqZfEzzkoQuI2//V5RI0vX8vhqYbS34pR1VRtMs8+aOg1qAVjlAoWrfVpXkQRWbjEheLEUvCAC16JvPPhZKwBH89R4PrADbCJmVP8xiJFJ8TXV9+t4JGwGoF14tjnwLZw4+oL4ooVux+3LlPZrmHvoXLq1bpH2gFD/Dl7t2JDJ0O+l/O/e7Mt1RG0MnuiQrdycPH9m90o2DG0ndhhjEnM4jlW0RzzzJvSE0dr2Bpr1H+mD6dv/urL0bbcc4Wl7Czz+bLe6T7CNq/oWgCDTXD6/ff9uS0HL71+7vFwJoaVmYO0l8CnMReAJsx4ky4zMhiBBul0IXKlrEKAjie9VEC0+CFPF/IY9RC7IvE1i18uCyTlvsP75Up8hq/a+12vKfWQNmsxAo3T/qp0zqNrevnWA8hzUNwoArcKav1BUjvEfZbW6Ri/WxE8ZdXS0W5PS8s+ngLjSZThAYwSXYEO+t+vBeYnIqtcSOQEMIfWOPqllRd8uKcTkH3w0Qo98zgUEdgOy/e4DOi28+9qVTmdO3TmvMejDjDA9Kza5/AoqxMsqbhMJ7GJsqlLvWVjp+ch1VoII5eqZBxjweE48O3tEaIukjvOJ8yPv1kuQ1paBIjGjLPyRZZFOKjDWbc9Dhw4ZWt0v7spvf4S4/VTAicVfgVGRmFa41czgYaJzMSALth48ZG51WBahl6hDgvDDdLnaYl3hL6yopaYCkraUC0NUymKgMZmjhtxXtMA/QLyST7+aAtnk6+4laNEaQV9W4MK9yJ9oAU9knVMxNiUt79rqU9VSlJIqCkBTWI/RiUTDFD9lkfa9Sxfspu3ndJPbmlfYwRy1NXHkQ4BM7n44MeMfNXzz+SZUAVEIUUgDRHm6RX0xyIyYEI2aVJJSEXGnkZS+F3Io22tVqWFOBLCqvBWOs/cvYpkV1YPZn8BGRS5yXCqfl1FLNPX3Y
 Dkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Clean up and simplify how we check if a folio is swapped. The helper
> already requires the folio to be in swap cache and locked. That's enough
> to pin the swap cluster from being freed, so there is no need to lock
> anything else to avoid UAF.
>
> And besides, we have cleaned up and defined the swap operation to be
> mostly folio based, and now the only place a folio will have any of its
> swap slots' count increased from 0 to 1 is folio_dup_swap, which also
> requires the folio lock. So as we are holding the folio lock here, a
> folio can't change its swap status from not swapped (all swap slots have
> a count of 0) to swapped (any slot has a swap count larger than 0).
>
> So there won't be any false negatives of this helper if we simply depend
> on the folio lock to stabilize the cluster.
>
> We are only using this helper to determine if we can and should release
> the swap cache. So false positives are completely harmless, and also
> already exist before. Depending on the timing, previously, it's also
> possible that a racing thread releases the swap count right after
> releasing the ci lock and before this helper returns. In any case, the
> worst that could happen is we leave a clean swap cache. It will still be
> reclaimed when under pressure just fine.
>
> So, in conclusion, we can simplify and make the check much simpler and
> lockless. Also, rename it to folio_maybe_swapped to reflect the design.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swap.h     |  5 ++--
>  mm/swapfile.c | 82 ++++++++++++++++++++++++++++++++---------------------=
------
>  2 files changed, 48 insertions(+), 39 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index cc410b94e91a..9728e6a944b2 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -195,12 +195,13 @@ extern int swap_retry_table_alloc(swp_entry_t entry=
, gfp_t gfp);
>   *
>   * folio_alloc_swap(): the entry point for a folio to be swapped
>   * out. It allocates swap slots and pins the slots with swap cache.
> - * The slots start with a swap count of zero.
> + * The slots start with a swap count of zero. The slots are pinned
> + * by swap cache reference which doesn't contribute to swap count.
>   *
>   * folio_dup_swap(): increases the swap count of a folio, usually
>   * during it gets unmapped and a swap entry is installed to replace
>   * it (e.g., swap entry in page table). A swap slot with swap
> - * count =3D=3D 0 should only be increasd by this helper.
> + * count =3D=3D 0 can only be increased by this helper.
>   *
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index df2b88c6c67b..dab5e726855b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1743,7 +1743,11 @@ int folio_alloc_swap(struct folio *folio)
>   * @subpage: if not NULL, only increase the swap count of this subpage.
>   *
>   * Typically called when the folio is unmapped and have its swap entry t=
o
> - * take its palce.
> + * take its place: Swap entries allocated to a folio has count =3D=3D 0 =
and pinned
> + * by swap cache. The swap cache pin doesn't increase the swap count. Th=
is
> + * helper sets the initial count =3D=3D 1 and increases the count as the=
 folio is
> + * unmapped and swap entries referencing the slots are generated to repl=
ace
> + * the folio.
>   *
>   * Context: Caller must ensure the folio is locked and in the swap cache=
.
>   * NOTE: The caller also has to ensure there is no raced call to
> @@ -1942,49 +1946,44 @@ int swp_swapcount(swp_entry_t entry)
>         return count < 0 ? 0 : count;
>  }
>
> -static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
> -                                        swp_entry_t entry, int order)
> +/*
> + * folio_maybe_swapped - Test if a folio covers any swap slot with count=
 > 0.
> + *
> + * Check if a folio is swapped. Holding the folio lock ensures the folio=
 won't
> + * go from not-swapped to swapped because the initial swap count increme=
nt can
> + * only be done by folio_dup_swap, which also locks the folio. But a con=
current
> + * decrease of swap count is possible through swap_put_entries_direct, s=
o this
> + * may return a false positive.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache=
.
> + */
> +static bool folio_maybe_swapped(struct folio *folio)
>  {
> +       swp_entry_t entry =3D folio->swap;
>         struct swap_cluster_info *ci;
> -       unsigned int nr_pages =3D 1 << order;
> -       unsigned long roffset =3D swp_offset(entry);
> -       unsigned long offset =3D round_down(roffset, nr_pages);
> -       unsigned int ci_off;
> -       int i;
> +       unsigned int ci_off, ci_end;
>         bool ret =3D false;
>
> -       ci =3D swap_cluster_lock(si, offset);
> -       if (nr_pages =3D=3D 1) {
> -               ci_off =3D roffset % SWAPFILE_CLUSTER;
> -               if (swp_tb_get_count(__swap_table_get(ci, ci_off)))
> -                       ret =3D true;
> -               goto unlock_out;
> -       }
> -       for (i =3D 0; i < nr_pages; i++) {
> -               ci_off =3D (offset + i) % SWAPFILE_CLUSTER;
> -               if (swp_tb_get_count(__swap_table_get(ci, ci_off))) {
> -                       ret =3D true;
> -                       break;
> -               }
> -       }
> -unlock_out:
> -       swap_cluster_unlock(ci);
> -       return ret;
> -}
> -
> -static bool folio_swapped(struct folio *folio)
> -{
> -       swp_entry_t entry =3D folio->swap;
> -       struct swap_info_struct *si;
> -
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
>
> -       si =3D __swap_entry_to_info(entry);
> -       if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(foli=
o)))
> -               return swap_entry_swapped(si, entry);
> +       ci =3D __swap_entry_to_cluster(entry);
> +       ci_off =3D swp_cluster_offset(entry);
> +       ci_end =3D ci_off + folio_nr_pages(folio);
> +       /*
> +        * Extra locking not needed, folio lock ensures its swap entries
> +        * won't be released, the backing data won't be gone either.
> +        */
> +       rcu_read_lock();
> +       do {
> +               if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
> +                       ret =3D true;
> +                       break;
> +               }
> +       } while (++ci_off < ci_end);
> +       rcu_read_unlock();
>
> -       return swap_page_trans_huge_swapped(si, entry, folio_order(folio)=
);
> +       return ret;
>  }
>
>  static bool folio_swapcache_freeable(struct folio *folio)
> @@ -2030,7 +2029,7 @@ bool folio_free_swap(struct folio *folio)
>  {
>         if (!folio_swapcache_freeable(folio))
>                 return false;
> -       if (folio_swapped(folio))
> +       if (folio_maybe_swapped(folio))
>                 return false;
>
>         swap_cache_del_folio(folio);
> @@ -3719,6 +3718,8 @@ void si_swapinfo(struct sysinfo *val)
>   *
>   * Context: Caller must ensure there is no race condition on the referen=
ce
>   * owner. e.g., locking the PTL of a PTE containing the entry being incr=
eased.
> + * Also the swap entry must have a count >=3D 1. Otherwise folio_dup_swa=
p should
> + * be used.
>   */
>  int swap_dup_entry_direct(swp_entry_t entry)
>  {
> @@ -3730,6 +3731,13 @@ int swap_dup_entry_direct(swp_entry_t entry)
>                 return -EINVAL;
>         }
>
> +       /*
> +        * The caller must be increasing the swap count from a direct
> +        * reference of the swap slot (e.g. a swap entry in page table).
> +        * So the swap count must be >=3D 1.
> +        */
> +       VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
> +
>         return swap_dup_entries_cluster(si, swp_offset(entry), 1);
>  }
>
>
> --
> 2.52.0
>
>

