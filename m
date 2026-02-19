Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DCBEE9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D846B0088; Thu, 19 Feb 2026 02:02:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5266B0089; Thu, 19 Feb 2026 02:02:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE9D6B008A; Thu, 19 Feb 2026 02:02:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7026B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:02:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4354814044D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:02:43 +0000 (UTC)
X-FDA: 84460313406.25.248160F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B36A80007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:02:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AKeFNv+6;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771484561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuQosr4TgB/PUVD6V+tNo7ICLqtXrv5lwo4YpTuZOYI=;
	b=TGSQ7NL1/Adl2qWaPsuhVCZyMjD0GWqdQxIAM1Y4gyE5gZuIjbZNQ5MohjntrHodaTaKRs
	CJ6exYZATeJJh0WxNBOMPqRiSKWbRHlyio3Za8IRqgydevv/OBkmHZZH6gY3nuhU5suYM4
	JyqXJw9FpVMcNYkssQybfIsEZCs4KkE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AKeFNv+6;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771484561; a=rsa-sha256;
	cv=none;
	b=4GP0J8M2bo4yKjQIHSNInDmZpTL499gmt0D3lCfpUywjBa+A473ZTlr1+1f+rECPG1SmCM
	olYcjx7xEhWTP0MMLaykcuUUeLcclo3Xmo3B1Jz46/LaZQBiV4aK8lOCjhYaTTEU9KOI70
	wZVhxPVxWZvCTCk0WPYsG0gLloZZ2vU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3DA56132E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD36C2BC9E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771484560;
	bh=eqs+0c/EoFy6UyIVlFWGEygOh/GgvLZPONQFV/NGMCw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AKeFNv+65YcP5X+HvHcAvFHIaTQvzrzjyJZNP0ksMuPyRf4WCUvg6Ss9rcZXdVE3+
	 uvMMI64HjXqsibLKU267zT8gP32CnoK7wnIozYT0ZDMSKrImE+tpkhevrNtplXHDkn
	 QYxLUt4v3rNCzgAoXdsO7uRYP/jxwQNy06IFicLu5tKypM2Hj/G/myYrhCs67dDdPs
	 vzd5IeHpMYTvOYY8qnJH2AZcqr1A44PUVAcRBq4VaVdWAzBYspSB+aUrE+L9UvjK15
	 W03me9VYOpeLL6VoneMTwHGVpkHcOeIKyqD1IhuVewXznok6nwwCuOW7sr0/MLHP40
	 pELCaRo+/k3tQ==
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ae222d87dso589420d50.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:02:40 -0800 (PST)
X-Gm-Message-State: AOJu0Yyjnec4jb1qjRuYyUuQrUiRVbvwqmnj0KdrM7ATUrEofBmi3GBn
	WRuXzlpuiuZHLAFl6J5J9oS/qfzu8LPF67MXNTKxr8Va7F9bVYXzhiQkvWr8iJPpAMDWfrZd5F9
	abTv/lfJ/nf4MkP/5EXpiN5FXJXfGsOUHvRBYOlxeOw==
X-Received: by 2002:a05:690e:d5c:b0:64a:d65f:6aea with SMTP id
 956f58d0204a3-64c556adf66mr3301369d50.46.1771484559414; Wed, 18 Feb 2026
 23:02:39 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-8-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-8-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:02:28 -0800
X-Gmail-Original-Message-ID: <CACePvbWdfrqQAhyL8YgrP_6+twiJaZNztxw+-cM5-Os=4Vdoww@mail.gmail.com>
X-Gm-Features: AZwV_Qgt2cbSkkWJp6j6S_EaH_sqK47kNeWsCs7m3OD8XFcrBhd93B_MvHeTdxE
Message-ID: <CACePvbWdfrqQAhyL8YgrP_6+twiJaZNztxw+-cM5-Os=4Vdoww@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] mm, swap: simplify swap table sanity range check
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B36A80007
X-Stat-Signature: xwucxhth3psj4wqizrjhfggrw4hhkrps
X-HE-Tag: 1771484561-305781
X-HE-Meta: U2FsdGVkX1+A8j5Z8KTQDbH2QKrf+cvgZgTt71MeDHEibUh9ihDJnsaz6KTOHGA1JuZ+gpQJs1bABsg4AQ0uuEJJx7oc3605XYPxZIzthk9pYFoBkU+ybl+22Zf4Ct8AyHF/00bniJpbBBlQxx6wd2Jwiza9Fa2c5Wu0c8SLY4lvYTcnjfm/mM+tWNI5a0K9ks33PmIP/59UTbU8uA2ZmIgjNE4Btn0xsgGAdBE9FUDfgdl2txgOGZnwfMa2G/3g7zQPLjCDTj30pccGp7Sn65on6OpuQtWSnpB6EQHvcPRnq/msUMMXU8gj7FeKxdtNlvwXTSrCE0+FhV5MdnmmLokzWT7c9qrvTmE/1FGaUrI9M1MvcMfePlCtfKqgsrukZ+FiPPCRs+Uo6OggWtfek3Re+d/GVsEWY8wgFE56D4pLVs+LIXlzdKj3gcG48EU1/9rWB8ULQCufD6M2ooKBGcX0Et6PF3iDAD8ECFJpMaQLtTjGZG0B2voDPPEgcusrGaxVszjVUa2cGzoZaiPfAeRMf/+OtQ1ZhPDfZcnN94N99sf6mPQ3715XdeBLdrZkV6Tc/Nb9/8+2R03TVdSG6Cub0x1Qt1RZVmlp5z6qed6U4yNOgiBccpSzmGK9pFDE+KVxVG1HhQvhFizn5H6WIvdisXXvXfgKgG1uBqMW2dUM2tEDhTzD/yuNx/p9CppOL52uPDDMoQ1b0XfJFHmHWODquGEY3B/voQro1VJIr1T3gPijN/cZamIPUTpPuI4uS1hBxGWglhT8+1sskcffTh3idcbhil5zzZLcUllbQfemh6G34Vc7XTZfUQmJy7kuGMpjy7ONCPcyRQQglpbjxKk1w9V7CoCq1EEj5LAvbGltLBg2fdkO9mwUZcil0q5D8lBPuCyRINyQmJYfABhV32X1KQwD9VB52m3RGIDAfH1puFTV1/tvEfiZ383Uoh/FIE8bDD99+ng1aNdwV86
 fM2TkTnn
 JG40W4cIz3Jm+LGMm5pHacqOM8ZqCpFxCBct3YannUoCq6hOqZaG69M/f3sWSzZCEpP7U8/ebKbR4Rbz7g7x9eQrKBE9QWKaScwEjUiIGwCYGAaFiAk38TSAX3vmgZ4zvEgHGOdQDIZHH40gdPZ4o/abLmhlEvl4UzO6hyA+PcGOwZoIH3xqfGKv9GqvMKIkQxhtFT3jA5pySaJeec2vnqbglBC7ymDi9fe4TukeXioU5dSGq9TAnnIXQSSXt+YXSpxAdHC9NvvRV2Fhe2dYojHuX3BntzIiUNlXsJPjPIeBSs6Mp8OVEuLd5+Ik3/GY2MMjNK5/N5vUwUpw=
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
> The newly introduced helper, which checks bad slots and emptiness of a
> cluster, can cover the older sanity check just fine, with a more
> rigorous condition check. So merge them.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 35 +++++++++--------------------------
>  1 file changed, 9 insertions(+), 26 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 18bacf16cd26..9057fb3e4eed 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -459,9 +459,11 @@ static void swap_table_free(struct swap_table *table=
)
>   * One special case is that bad slots can't be freed, so check the numbe=
r of
>   * bad slots for swapoff, and non-swapoff path must never free bad slots=
.
>   */
> -static void swap_cluster_assert_empty(struct swap_cluster_info *ci, bool=
 swapoff)
> +static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
> +                                     unsigned int ci_off, unsigned int n=
r,
> +                                     bool swapoff)
>  {
> -       unsigned int ci_off =3D 0, ci_end =3D SWAPFILE_CLUSTER;
> +       unsigned int ci_end =3D ci_off + nr;
>         unsigned long swp_tb;
>         int bad_slots =3D 0;
>
> @@ -588,7 +590,7 @@ static void swap_cluster_schedule_discard(struct swap=
_info_struct *si,
>
>  static void __free_cluster(struct swap_info_struct *si, struct swap_clus=
ter_info *ci)
>  {
> -       swap_cluster_assert_empty(ci, false);
> +       swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
>         swap_cluster_free_table(ci);
>         move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>         ci->order =3D 0;
> @@ -898,26 +900,6 @@ static bool cluster_scan_range(struct swap_info_stru=
ct *si,
>         return true;
>  }
>
> -/*
> - * Currently, the swap table is not used for count tracking, just
> - * do a sanity check here to ensure nothing leaked, so the swap
> - * table should be empty upon freeing.
> - */
> -static void swap_cluster_assert_table_empty(struct swap_cluster_info *ci=
,
> -                               unsigned int start, unsigned int nr)
> -{
> -       unsigned int ci_off =3D start % SWAPFILE_CLUSTER;
> -       unsigned int ci_end =3D ci_off + nr;
> -       unsigned long swp_tb;
> -
> -       if (IS_ENABLED(CONFIG_DEBUG_VM)) {
> -               do {
> -                       swp_tb =3D __swap_table_get(ci, ci_off);
> -                       VM_WARN_ON_ONCE(!swp_tb_is_null(swp_tb));
> -               } while (++ci_off < ci_end);
> -       }
> -}
> -
>  static bool cluster_alloc_range(struct swap_info_struct *si,
>                                 struct swap_cluster_info *ci,
>                                 struct folio *folio,
> @@ -943,13 +925,14 @@ static bool cluster_alloc_range(struct swap_info_st=
ruct *si,
>         if (likely(folio)) {
>                 order =3D folio_order(folio);
>                 nr_pages =3D 1 << order;
> +               swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, =
nr_pages, false);
>                 __swap_cache_add_folio(ci, folio, swp_entry(si->type, off=
set));
>         } else if (IS_ENABLED(CONFIG_HIBERNATION)) {
>                 order =3D 0;
>                 nr_pages =3D 1;
>                 WARN_ON_ONCE(si->swap_map[offset]);
>                 si->swap_map[offset] =3D 1;
> -               swap_cluster_assert_table_empty(ci, offset, 1);
> +               swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, =
1, false);
>         } else {
>                 /* Allocation without folio is only possible with hiberna=
tion */
>                 WARN_ON_ONCE(1);
> @@ -1768,7 +1751,7 @@ void swap_entries_free(struct swap_info_struct *si,
>
>         mem_cgroup_uncharge_swap(entry, nr_pages);
>         swap_range_free(si, offset, nr_pages);
> -       swap_cluster_assert_table_empty(ci, offset, nr_pages);
> +       swap_cluster_assert_empty(ci, offset % SWAPFILE_CLUSTER, nr_pages=
, false);
>
>         if (!ci->count)
>                 free_cluster(si, ci);
> @@ -2780,7 +2763,7 @@ static void free_swap_cluster_info(struct swap_clus=
ter_info *cluster_info,
>                 /* Cluster with bad marks count will have a remaining tab=
le */
>                 spin_lock(&ci->lock);
>                 if (rcu_dereference_protected(ci->table, true)) {
> -                       swap_cluster_assert_empty(ci, true);
> +                       swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER=
, true);
>                         swap_cluster_free_table(ci);
>                 }
>                 spin_unlock(&ci->lock);
>
> --
> 2.52.0
>
>

