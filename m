Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3597C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 11:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7246B00A0; Mon,  7 Sep 2026 07:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF086B00A1; Mon,  7 Sep 2026 07:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4AF6B00A2; Mon,  7 Sep 2026 07:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B307B6B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:35:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47A7A140118
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:35:08 +0000 (UTC)
X-FDA: 85186759896.22.175C1F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 51DA918000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:35:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoL4UWhC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788780906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5aTxo2FYlYW9tiHK3LWDm763oBTj6uD0aD0KefY37gA=;
	b=1egsvVVJCoUeORlIZotBuQXbmYz3Gm18ICFS0XJd7298QC4qiGwjaLPI2ZL0VNIcISBeMp
	+hZxWtiv1WKLq4XjSQRxLL4NP2RsmJOtIY5oSNaSdERysMcI5d1duK8Gm80/qeTPevlFLe
	Lxy6IeMaJlt4QCbSlZ3XJlwHYcyNsHc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoL4UWhC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788780906;
	b=h+coTkD4LFiXe1g101lyxTBqRIeRdOY5mKP77+xAji7G+VAe5yBXS5XISkFVoEHVGeTlQM
	Ebfhe9O2/KK9FDI6MzzYELNbaVkToqqnl0z3UA2rIhj9j2ugUpU444Fk9QZbu2JZ62aG/V
	HRjzNR+KVnLz5v7m3WN30HNmIc/TocA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B7CE43CCD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE071F00A3D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780905;
	bh=5aTxo2FYlYW9tiHK3LWDm763oBTj6uD0aD0KefY37gA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RoL4UWhCxevPQzydIQc1gABvy9CiqemlZee3mh27UHPMoL6S+m9xcaZ4Ar2TR9/Qs
	 nsmSF8LatiqCm95btpj8ZDmuMmuBkWclBW6dbGmP6wPuMhF6embgd5MZYRO8ubttU5
	 ZFR5nZYzp2GIjJUnRvhOFixVHpWqZ+UqamiICr1ZVlt1axvW6p3Hl65X5bNSQFVroi
	 0ZPTuMGyxHNaz9CWJhtfELlWknZY+TV72qxIuqydVH3OxRMz0WZo2hND4+yrhqUJwb
	 XW80X+f3RB9s3H7jZhfVshoqcgtwFyhAPgAC9l0SBzDYDx5t38uWlYH1FsO73VI0WO
	 dC6VsPp6Atdzg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c253425b253so486555466b.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 04:35:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByl/PxFxXabaxVBxjIiO5ar7+V/yNAhtMgZQlOUHyw6O7F9pq5AQoCvS1CzAj4qT+sL9JfMyQcUiw==@kvack.org
X-Gm-Message-State: AFuF++mG4n7TGI3IB4ILVp+a/w3PH1AIk10Omu7Eb5cp899NKyGW3JKI
	prU9gNq1ndXpetzkRqzVYLhaFPz8Q/4W8ESMgXbyCVKSbLTsS8S6pK8YPtQEAf1mwUfLANSSzaY
	hndP11eY4ic8rPVtKK0yVl5PJUC3Lryw=
X-Received: by 2002:a17:907:3f1b:b0:c26:19de:9aeb with SMTP id
 a640c23a62f3a-c2619dea7eamr684547466b.42.1788780904230; Mon, 07 Sep 2026
 04:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260905125101.2970456-1-xialonglong2025@163.com>
 <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
 <CAO9r8zPhMw=2+wyRYwbBS4As-zNbVnkcT3Y2ppqLo1AxPzaTAQ@mail.gmail.com> <b00822a4-87ce-47d7-ba63-21a7b99980af@linux.dev>
In-Reply-To: <b00822a4-87ce-47d7-ba63-21a7b99980af@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 7 Sep 2026 04:34:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMxF7tH4LkATd5pQvyvQ5KTCqKTxafsu5wQcad5tRsc1g@mail.gmail.com>
X-Gm-Features: AcwNN1XRfHUU0n7CfrToKSRmVnbEnBiwX-Ubn4BltThCp6Gae3wkg3rK8jlagwE
Message-ID: <CAO9r8zMxF7tH4LkATd5pQvyvQ5KTCqKTxafsu5wQcad5tRsc1g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool recovery
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Longlong Xia <xialonglong2025@163.com>, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>, Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gxx5r4n836aaudef1fd1dcwuxqr9549s
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 51DA918000C
X-Rspam-User: 
X-HE-Tag: 1788780906-883006
X-HE-Meta: U2FsdGVkX1+7nyYlETVVB12fzzYMNP4FiDDzdja9msry+K+lhlwApD0KloWzdERryqyiZR1JEAI0rAMSsMF0p0DZ+XGTH1ysySWGxGtJ1ygr+jvrp9r3BUeNn/g8THez9wgzd++31idq37aIZOTE1f3h+9ydOnkvHIXYVDTD0hcPwN1X67r8GtD/su4exbuFTzd+xZKYCdxCmrNKUzc3G+gZGRHWyAjGDzSAt/ik361RhK1rZn7YuYpH2MhKItCSE9d7+Lqeu2ZdsJluVAM2wJzwQW47bmLriqkxa8JETErmvaTXVdRLt7hOMUv8BU5OWk2leczXYY0TLPCEjQauS/n0p1gIbWXLxfRyyNfMMMWgQoAdzUMutFuAwhthtAnY/r8Mq5Uc8jl8X2oUBL4/xO8WxCfVSuunbSpWmvdFR6e0awnVAKkraeA/vJIq5CYNLpaHaIGUNze4fRgReeIkta26kbFFE7HZHLrQ2j4dMQzRtIY/CUb6xYvLGs5ZQakU4Yww4DN8JpI7AsVzWOzTXjdDP54g3g8whIKCH18r4sgE8oag+5k+Nf9C32f2tH/mxMhVBtG+66sCI6+GRTB6foLXgD3X4X7CkYukdFluHxv32JIroV3GD85rUy3E9vfrDoFKgHfgGVYJyjE5UHRxn2RBRpz+EV8XaiVv3mBReMDagSTxRpPej2L6y45daTdu/HG71zG5ONVNRtMurhu1BxP/9wmTOcGa8sdGTpSKS84rNh+Ctxf2/C5+db3fsVVp7dDHS+6Jm4oUQjVz+995erfZ1VOSbMlOmgn7Bo08rnKH2t7Wh8t+sYu+YhYl9CLTrTE5k+SKp2FZWUQZfe1GzEtNgN9ou2va4hZRIrtRDbgpwnTy/pryiz43R6f7N1KUWcoAtCuXufymseksdrc5bkEIynwIuViPvk1nQYJ30IkkefeNUVs3Ls3OOOqfAOqxlx/BQ9/S4v9dSyvy2dq
 DeA8HJTe
 n6NA/5IEZyMyCkvBrwBGMWW+IWeNp4yCmajJBAgk/kt0Z46Jp90B60bglZw6nfIpZUuPQBbqUFtt0FnAefcXGpvpotLgTckYs5u8dXA7/ymMp7Z05jNT3ESwKeBDbmws2+6CsY3vB+SM4eMGdZT6GGTlll4bbAfU/8BRrg3uU7BzmTY1IWYLdnRFTM7C4MgqC52kWPbUWRWEr1ltYcfcmbBbik+qPGS6bFBIQZyJDN0/hEne9v7Bav6xI0lNrGmd3b0aHs/EzSZJHX1/K9GkCOVr5l+H//exum14yz3i91o1YGwTeTvEckeStsiFn5gs/4pWpa2nBpPYtAdPk2o76MRdB+m2/lEObFqvoppZqtcpJU1c8+6dySLm9IcISe0A0r6c1egB2ZWaElJsaRvXdTdb4Auc/4RQUZ0Ot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> And thanks.  Sashiko might have found another issue in this zswap code:
> >>         https://sashiko.dev/#/patchset/20260905125101.2970456-1-xialonglong2025@163.com
> >
> > Hmm I think this might be fixed by Alexandre's patch (in Usama's
> > series): https://lore.kernel.org/linux-mm/20260818131202.494754-6-usama.arif@linux.dev/.
> >
> > Instead of always returning -EINVAL for large folios we only do so if
> > they are actually in zswap. Usama/Alexandre, assuming I got this
> > right, can I interest you in sending the zswap bits of that patch as a
> > standalone fix? :)
>
>
>
> Hello!
>
> Below is what the patch looks like in my tree now. It can be sent independently of
> the PMD swap series. Yosry if you are happy with it, will send it on the list

Would you be able to send the zswap bits only as a standalone (and
hopefully backportable) fix to the issue Sashiko surfaced?

>
> From a5b70b6d72eda15bd7a16b8fc51db1d271b08520 Mon Sep 17 00:00:00 2001
> From: Alexandre Ghiti <alexghiti@fb.com>
> Date: Wed, 22 Jul 2026 08:19:35 -0700
> Subject: [PATCH 01/19] mm: zswap: add range lookup for large-folio swapin
>
> A large folio reaches zswap_load() only when the caller expects
> the whole range to be on disk. Zswap still stores large folios as
> independent order-0 entries, so reconstructing a large folio from
> zswap entries would risk returning partially initialized data.
>
> Teach zswap_load() to scan the covered range. If no slot is in zswap,
> return -ENOENT so swap_read_folio() reads the backing device. If any
> slot is still in zswap, fail the large-folio read so the caller can
> fall back to per-page swapin.
>
> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
> are now valid requests; the error means zswap cannot safely satisfy
> the request from partial per-page compressed state, not that the
> request is unsupported. Existing callers only distinguish -ENOENT,
> so this is a semantic clarification rather than a behavioral change.
>
> Add zswap_is_present() so PMD swap-entry consumers can make the same
> range decision before attempting PMD-order swapin. For high-order swap
> cache allocations, check the zswap range after inserting the folio into
> swap cache. The insertion stabilizes the range against zswap store and
> writeback; if pre-existing per-page zswap entries are found, remove the
> folio through the existing allocation rollback path and return -EBUSY.
>
> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/zswap.h |  6 ++++++
>  mm/swap_state.c       | 29 ++++++++++++++++++++-------
>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++------------
>  3 files changed, 61 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e1..cd9efcf9dec94 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b76eb3d876fd7..103ae7ae8a4a6 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> @@ -459,16 +460,21 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>         __swap_cache_do_add_folio(ci, folio, entry);
>         spin_unlock(&ci->lock);
>
> +       /*
> +        * Once the folio is in swap cache, zswap cannot start storing or
> +        * writing back any slot in the range. Reject high-order allocations
> +        * that raced with pre-existing per-page zswap entries.
> +        */
> +       if (order && zswap_is_present(entry, nr_pages)) {
> +               err = -EBUSY;
> +               goto delete_folio;
> +       }
> +
>         if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
>                                            vmf ? vmf->vma->vm_mm : NULL, gfp)) {
> -               spin_lock(&ci->lock);
> -               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> -               spin_unlock(&ci->lock);
> -               folio_unlock(folio);
> -               /* nr_pages refs from swap cache, 1 from allocation */
> -               folio_put_refs(folio, nr_pages + 1);
> +               err = -ENOMEM;
>                 count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> -               return ERR_PTR(-ENOMEM);
> +               goto delete_folio;
>         }
>
>         if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> @@ -492,6 +498,15 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>         /* Caller will initiate read into locked new_folio */
>         folio_add_lru(folio);
>         return folio;
> +
> +delete_folio:
> +       spin_lock(&ci->lock);
> +       __swap_cache_do_del_folio(ci, folio, entry, shadow);
> +       spin_unlock(&ci->lock);
> +       folio_unlock(folio);
> +       /* nr_pages refs from swap cache, 1 from allocation */
> +       folio_put_refs(folio, nr_pages + 1);
> +       return ERR_PTR(err);
>  }
>
>  /**
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..32671dc2bf84d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1571,6 +1571,23 @@ bool zswap_store(struct folio *folio)
>         return ret;
>  }
>
> +/**
> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
> + * @entry: base swap entry of the range
> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
> + */
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +       pgoff_t offset = swp_offset(entry);
> +       struct xarray *tree = swap_zswap_tree(entry);
> +       unsigned long index = offset;
> +
> +       if (!nr || zswap_never_enabled())
> +               return false;
> +
> +       return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
> +}
> +
>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1578,13 +1595,9 @@ bool zswap_store(struct folio *folio)
>   * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
>   * of the following error codes:
>   *
> - *  -EIO: if the swapped out content was in zswap, but could not be loaded
> - *  into the page due to a decompression failure. The folio is unlocked, but
> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
> - *  will SIGBUS).
> - *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> + *  -EIO: if the swapped out content was in zswap but could not be handed
> + *  back, either because decompression failed or because a slot in a
> + *  large-folio range is unexpectedly still in zswap. The folio is unlocked,
>   *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>   *  do_swap_page() will SIGBUS).
>   *
> @@ -1605,13 +1618,20 @@ int zswap_load(struct folio *folio)
>                 return -ENOENT;
>
>         /*
> -        * Large folios should not be swapped in while zswap is being used, as
> -        * they are not properly handled. Zswap does not properly load large
> -        * folios, and a large folio may only be partially in zswap.
> +        * A large folio reaches zswap_load() only when its whole range is
> +        * expected to be on disk: PMD swap-entry consumers split before
> +        * calling into PMD-order swapin whenever any slot is still in zswap.
> +        * Confirm the range is entirely absent from zswap and return -ENOENT
> +        * so the caller reads it from disk; if a slot is unexpectedly still in
> +        * zswap, fail the read rather than return partially-initialized data.
>          */
> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
> -               folio_unlock(folio);
> -               return -EINVAL;
> +       if (folio_test_large(folio)) {
> +               if (WARN_ON_ONCE(zswap_is_present(swp,
> +                                                 folio_nr_pages(folio)))) {
> +                       folio_unlock(folio);
> +                       return -EIO;
> +               }
> +               return -ENOENT;
>         }
>
>         entry = xa_load(tree, offset);
> --
> 2.53.0-Meta
>
>

