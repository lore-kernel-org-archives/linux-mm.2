Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E7CE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972CB6B0089; Thu, 19 Feb 2026 02:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91CE36B008A; Thu, 19 Feb 2026 02:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8430A6B008C; Thu, 19 Feb 2026 02:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 709AC6B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:19:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2B48140468
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:19:38 +0000 (UTC)
X-FDA: 84460356036.21.F25A667
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28477140009
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:19:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRva4Rai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771485577; a=rsa-sha256;
	cv=none;
	b=d2/EsmMQoKzlGZV7sfoAMAxqEDzR5qaVRq+mnMh53zPCWCkC0cgPZQ0Go56F9k32N6y7Es
	gPKaeFL/k6xLPgeVjkNoZ+o1fLzdoi6npHw+OV17C5/U2ivwKrHmfw5RtGIRcNLAJ7hCsD
	iHZ2uASxCwdRXTtmtA++TF3g0+hajDg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PRva4Rai;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771485577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euVub2spsPYXplq1wMHPfr10FSdB3/H94TZdvACdrdI=;
	b=aWtrTQBH7Rr2r1tscI5q9d4rURd9Mce1eaMbpXH6cQPnnycnSyKmv2XsQlgsJvzABFi05H
	OD1eGwiDyT0o2eT1krqbA51UX2JYFxmd5l6IckhYujyITPcsRBUIlyc6C9i0ZPIh1KDD4Z
	v/ZFOPa1yp4QYUYMg8u+h370zbqS25M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DB8E6014C
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4C1C4AF0B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771485576;
	bh=SJMMwBLf7vRhZkOWHMBsNhcFy0+himckCdGenIwRclc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PRva4Rai7BDrZLkgOVmEo4atz6ZVm9lJGWZZmLF4UmPXFXnRpTiMkxRRlN07mqFi2
	 8hk1Ar3pf7IFqoWaOLPTa1SnOCEMv+Dg84sm4e/tag+wH07+aXVRRgX6QJF1ibARIw
	 qkkeW+VrGB2UzKvA2TPeSXmAwKOFRBtb0O4ro7Ujh4WYW7R/QragR9O8oQcpIny7xY
	 ptaNgk+XKic9s4Bkea8pt1WvMWsfSQjsbmSUFGDkIgRd965MsqmzzHwdPtclo+leJ7
	 v2GzcMu9Qaa7u1q2kNie3ynQqYo4w/9ZZTW95O2rvIPRLeQF/QZlqrX1lhfzzCBNU/
	 drZfFH690GcJQ==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-790b7b3e594so6286407b3.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:19:36 -0800 (PST)
X-Gm-Message-State: AOJu0YxlvvbjUG/yZotSqatDSCD4YzJtzDHBB600/2iZSR9wTmpMcsFh
	JnPrUH4uqMIteMiZ/9du3fFM+dijguhWrHUt7fF2s1GnbN1dOSlBgj/yPHoCQaTLj6UYZzX2yvm
	dfAcgTL8eMjH1Ccbd63F5WjDNgr1h6ZRLWJRy8iocfg==
X-Received: by 2002:a05:690e:14c9:b0:64c:2114:16fb with SMTP id
 956f58d0204a3-64c211417efmr14227956d50.47.1771485575261; Wed, 18 Feb 2026
 23:19:35 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-12-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-12-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:19:23 -0800
X-Gmail-Original-Message-ID: <CACePvbU5B3+KEy+Xf1AeKR47QxDWoimM18bp0fZE1s8etLBkwg@mail.gmail.com>
X-Gm-Features: AZwV_QjE161qrcxACUSsld5F1tIROGbcNIKW9kil2jWWKXZEn1QgV7RLVX1rwxM
Message-ID: <CACePvbU5B3+KEy+Xf1AeKR47QxDWoimM18bp0fZE1s8etLBkwg@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] mm, swap: no need to clear the shadow explicitly
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mazbiqqimdqqubu947s5o5xwc74eocs1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28477140009
X-HE-Tag: 1771485576-451913
X-HE-Meta: U2FsdGVkX1/X+73pvYlcHQMEt86kcSEfi4uBX+ay7PSGu8QZk4QMLZqKbo/a/dJPJSnu71ioLQJNvBmvm1+7SfDSR6z9wzDQTaZN7WNLTzSHxQtsRyl3a2RdwnlDsu5Y3XzxU/iCyd3Msb3ZxUm1WKjSUFh2dW9FeOfEzwL8ANEYBR5wgu6gbDjAVbySFmHmSrj4BXeHtLwYcXxkhLMcszyPvJ1Lse4FgD1YCkAli27ZA+ck0agFl6jOnz2Vupw6/jvcu2kNvCLb8/dwu0aZKqu47MUgzBIJUz2ECG7ODSGHL6c0yG3jvRtvklujKqH5k/6GiMUox/wVPVojxkDfiD24IBewfsztLgJiAVoRRX3mwlu0iVQ0tdPm/P4NHglEKWiPISuG+zrc7eSfKIrGHDB+hfLZIV7yMmgvpqbhCjIMG79hnwu6rog0K2KIPzmLHYVrhSPMF/fn+0fg7yr7FFuLTmyFxH5Il+eNe5ON5eHjavvSx4MltIp3nw2k07ASKwbtROMp0M0PNJYMV+9ekdJPvrWBDOcem4LvEJJ7HAeM/yFuLYR2z3ibqZtTyvpCtdnIp3jTVpNLtuNvLLVKcPXnEdt1kCdiFwvMOS3h6nm07Tpxw9Ezca/1i+Jy6o0e6XmW3u8qXsKyfFM7jofdcs1RnQm4vC3L49REBpBOsUv6KtgEVW+c80fQFN1DW4sppQWR4KyVPvlF0dKH4ikJU9sb5iagZGTBO1BQsd+qR6pFWl/UF/voS28g+emiYWut3fqkdz01zo/jobURGr4HAIQJg24hwZVhVqipluXILKkRAIgMJn/x7sTLbRS7PEgWYC2YCeb0n13Q2x8FyaiyNyULkO7Q44zLEtwczne9p+0spe21xmMq4fEdhtL17sj2LAHzM7Q76so2/W6/a72idp7hv3EAPuGwaO4OyrtbYhoEfhGaY3hyu3TN5gODAHvVirRW/4mxwgemXosHBdd
 M+bm5Bsu
 fdETq/LiUXLh31JkvJi+t7LykMIvvqEYn7wM9tY24nAuk4RexRFjmBC3r32YADGpc4zk06AkaskKjOFXj1qiEcxElh7s2n7hU+CAheYs3adrXxsgrRpx3NMMujkCxqyV5WH8bIPEWPp/IBO91aizur5zEQMaiMN4ZffspFtRikoMwe8ngDu348WW7Hw0E2m5xXPtjppJs+whyXdPj3X7Ne1javRurhVlwG72uD/PSOWjuUuNGflFmlBu5L5r8Hf4X3yvFN6XCRJM/RwBgCFWLu0N+XkowzPpgylgRX16h1I/JnqZQJWFypamlJShOdJHzLG7TD10W9yGgycVJfKcMgKT2FStMNWMXz94ugSHpRDQdaeQ=
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
> Since we no longer bypass the swap cache, every swap-in will clear the
> swap shadow by inserting the folio into the swap table. The only place
> we may seem to need to free the swap shadow is when the swap slots are
> freed directly without a folio (swap_put_entries_direct). But with the
> swap table, that is not needed either. Freeing a slot in the swap table
> will set the table entry to NULL, which erases the shadow just fine.
>
> So just delete all explicit shadow clearing, it's no longer needed.
> Also, rearrange the freeing.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swap.h       |  1 -
>  mm/swap_state.c | 21 ---------------------
>  mm/swapfile.c   |  2 --
>  3 files changed, 24 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 9728e6a944b2..a77016f2423b 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_cluster_info =
*ci,
>                             struct folio *folio, swp_entry_t entry, void =
*shadow);
>  void __swap_cache_replace_folio(struct swap_cluster_info *ci,
>                                 struct folio *old, struct folio *new);
> -void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
>
>  void show_swap_cache_info(void);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index e7618ffe6d70..32d9d877bda8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct swap_cluster_=
info *ci,
>         }
>  }
>
> -/**
> - * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache=
.
> - * @entry: The starting index entry.
> - * @nr_ents: How many slots need to be cleared.
> - *
> - * Context: Caller must ensure the range is valid, all in one single clu=
ster,
> - * not occupied by any folio, and lock the cluster.
> - */
> -void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
> -{
> -       struct swap_cluster_info *ci =3D __swap_entry_to_cluster(entry);
> -       unsigned int ci_off =3D swp_cluster_offset(entry), ci_end;
> -       unsigned long old;
> -
> -       ci_end =3D ci_off + nr_ents;
> -       do {
> -               old =3D __swap_table_xchg(ci, ci_off, null_to_swp_tb());
> -               WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old=
));
> -       } while (++ci_off < ci_end);
> -}
> -
>  /*
>   * If we are the only user, then try to free up the swap cache.
>   *
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index dab5e726855b..802efa37b33f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap_info_struc=
t *si,
>  static void swap_range_free(struct swap_info_struct *si, unsigned long o=
ffset,
>                             unsigned int nr_entries)
>  {
> -       unsigned long begin =3D offset;
>         unsigned long end =3D offset + nr_entries - 1;
>         void (*swap_slot_free_notify)(struct block_device *, unsigned lon=
g);
>         unsigned int i;
> @@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_info_struct=
 *si, unsigned long offset,
>                         swap_slot_free_notify(si->bdev, offset);
>                 offset++;
>         }
> -       __swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries)=
;
>
>         /*
>          * Make sure that try_to_unuse() observes si->inuse_pages reachin=
g 0
>
> --
> 2.52.0
>
>

