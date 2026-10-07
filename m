Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24845CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 04:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C856B0088; Wed,  7 Oct 2026 00:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C816B008C; Wed,  7 Oct 2026 00:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FBB26B0092; Wed,  7 Oct 2026 00:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 687256B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 00:22:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1BBCA0451
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:22:56 +0000 (UTC)
X-FDA: 85294534752.07.FFB7FFE
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1ADAB40005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:22:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RlGuC9bM;
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791346975;
	b=DwWbeV8JY1rSE0QMxSskuR2sBmmgA58n7RHzuNO6tgxPtQ/GE8tEzAhgHPGLlbz9Gg3Bz8
	vbPMiOrdyp9w5DgeQXGXjBRR6RwB+uX+hNw7Otif6bEgrjRyPCBTJSrYfzzBMy3Ph+JaO2
	+ADWwoCbInucPVXUPlLMxNzhV5BtAEo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RlGuC9bM;
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791346975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2ToCfZYIjxq1dZW0uV6rIKGWPZwk3eVVZM+XUvPZcU=;
	b=KrHTPPY350oLjg1azHO+Z8DNa9PXwsSYTGuJfqKVCg2j5A24s9OzDUhbXh/MF0SuUIP29U
	Me6YBbu25y9oED6/enTZHGy5/moXZyFdgaN1AsVaCqDqDb5yW6ToFuctcfRTErM8L5CAXw
	JVd8fyux8jd0wVEK5WX+JrwxYFoulbs=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso13814595e9.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 21:22:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791346973; cv=none;
        d=google.com; s=arc-20260327;
        b=KnKMgUNW7W+o+TZ3amkzG7M08dr/iliJp2jt2sf2VD7HqNE/aBV1r54ARKZ/2PF17d
         FqUDIWQHavBkXSlDbsI+Xc1qpjl2aPrhgQRcYt0b9Ajt09MaXUComxnkRbOvduX62zMv
         8+H8QmD1+OSy932NX79RTZI+RSa+WBZPHB9sn/Fv3Lx660RYYpfGzoA9qIqkT8L5uZfR
         4zklliu0Y/uHNRnqrTTDtWC+cmCO4hFG362cLaX63m0f9q6jJ6RtKJaRwnpWbP4kq+43
         ersLDmXZNSI5pc/2wboGKkpnrab39CyBvzKfYKNfCEPxrXu26w08XtYb0MQoOCGsWHNb
         smSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i2ToCfZYIjxq1dZW0uV6rIKGWPZwk3eVVZM+XUvPZcU=;
        fh=7hA4/DtOkRXrU+dD6PZgS5g/08x4uElnFZrA1GeomiA=;
        b=X78LR4Bt78MBJzUNTPaGvb7uMVYNaiTQToAAyZDBRUSzYoF5uSEpxPepuF3Rk7IezM
         x7WIjrs2q4mXh6B4GYkZJWTSmucAzyQHuqt9gGN1FxONlFIUpxOq3bQxgH/oYRG2WxHY
         zyJj6+rDgIK6iGeg/Y4ir4j9T9Xa90D9aeAuUWfOk16nDgUNUGPhrAEhx0uMeWe8c6Io
         pSy0x94lwc70BSIwlhbhUQrAK63ob6vHlcHix/z0awbM73cX63BEV6Z1zkMTCnTCQG33
         UT2X28eFND62esiOuUTveds04fkvYFQugMwnPzUwFE7tkcGvMOIYgyklFklKZOS+TVXZ
         2uUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791346973; x=1791951773; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i2ToCfZYIjxq1dZW0uV6rIKGWPZwk3eVVZM+XUvPZcU=;
        b=RlGuC9bMXwlhuMS6vhtcTu/xnH4PSNqhbORD6bhNvJR9ajVw/eYtV31ymh5zSQy9cf
         vSQ3Kz7SYZNMtGNNt/buSDO6tsCWsvQOUsayNSzMzNNbQ7q0eDIlg97P/1EMhgUthw0x
         yvAB1zgyN4Du0Jm4Zv/sdCfRl80xu19M8shlizxjS9dnKWu9805doURE7hX9grLE9XY3
         vW2kwPgvbGbLyapOU8W5ArtWJY7MmzcNO7uB3G+zrwQP+vx6TkcnKhwjYmTeu1qZPMbK
         v0s1OP25K5wsjSxFq84wcGVgCrsvaOn3KU2HzbSYqqNsSDEzMkYgKJrVJRvfFjPfkbBF
         hGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791346973; x=1791951773;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i2ToCfZYIjxq1dZW0uV6rIKGWPZwk3eVVZM+XUvPZcU=;
        b=q6oFHE3pAMZzPldjx4PrBSLfGCU8a0v025QhTCjOPqu8mWfLecAxA35yvVCmFZ7lKp
         WV9ecCnj6jfpDroDT9f6TgZmSrRKfLd0Tt4xabx8opPaWFBuhgK9cUE+LjuRfs9jL/Gm
         SUxel5ZR8a1zQJQDjG3DnTpajL+kj4r/Hv9AYTu8ZGWQGc67kUEIpLUyqEEdTRo+Tloy
         GjSCF2OTNI+2Lssw1elbOUWRLq0ovY1c17G8flvQHmmZR/TsAR9xYnoU/fQsq5RlrYav
         8DcQyfHdNtVHOKDLB7lFV5jv+asaxRxdxJXyplxsS3HT/0d9D+t0G7n4d8hAKQB6b7o6
         gv+g==
X-Gm-Message-State: AFuF++lqJRnP00IPhLr6eoi945XIa2fJYt44Y5ku4m2h+tqHnZ2qiVzV
	RDN5H1hRWOrsmii/py52W9o81sTJbtqUGHzSc90TEr9eSeEg4szqWGIYXZ8fg3sFESun6NQ9de5
	d9iaewBp41QQ0DGD6iBQHaQLEETQkqrc=
X-Gm-Gg: AYBFou1bN3CZdWl7/WbS3voE6FuUbIp26oVFCA8z0MmhtlgPvHtoLI/TM1lwsTv3epe
	RNwUEyvfwC+oI8zM1B681gGRHUXbTqA7z2zxFASnHpD/S4j49ouR/gqCH8aVYeQZ94u79LQsDtI
	nDFg82nhbGs4XrhDSxFaLuybvgxIbCNrlS4/UGNvsOTVDeEzu9MNO3KKGysAnLmEPwN6HtytDRe
	nIqOa2J0DPuM6RXtQ3zN402352vqIz6lLyKOAhH9NygtEpGMmjnRl51YGWxQbV6LcmE/tdUqMvH
	Y5G8o290aeikx7flj+I6wWrsVogSvZDsWgmIS61NiPXQ8wp5LgWyglQ7L3KUIj9fO5U=
X-Received: by 2002:a05:600c:810c:b0:49c:cee0:f383 with SMTP id
 5b1f17b1804b1-4a18041f7b8mr10922205e9.16.1791346972978; Tue, 06 Oct 2026
 21:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-2-hebaoquan@kylinos.cn>
In-Reply-To: <20261003003136.750633-2-hebaoquan@kylinos.cn>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 7 Oct 2026 12:22:41 +0800
X-Gm-Features: AclHuK-QJ8P9oH6bW9Xc3cLmVBhwZcs9Cuj0L2U9iMoPqhfPswet6J9VLfAmFyU
Message-ID: <CAN_Opa_EqxLATXVqYoOqpCasU9MjiTEW-qw8aGbO_eY6EpKyKw@mail.gmail.com>
Subject: Re: [PATCH v4 01/14] mm: xswap support for zswap
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1ADAB40005
X-Stat-Signature: io76m5xghxwpr14ddibnhrfmenamjb4h
X-HE-Tag: 1791346974-786798
X-HE-Meta: U2FsdGVkX1/Benl/IcwuH9mTPBdWp7uc9mXrDeYRZL9q84jXxPWZmL1M4Ym2kt4+kFyR6UmfKJmnUlciWjmO+v0T5sVXdR1eGDScKMCCm68u9QNJmpVMTErKeDUSfBA8w1Eb0pbyaLNnTVyaAeGLrV4krP/q33wZxlTfcHIE20PsijNfKj8d8zKc1YAXKW1MHWKVmVRZYoqQqaE913K9bG7arPHoXOM1Zn9sxnAC4o4vkMZOQn2Ea5P/TVLOVuk9A5NqfchNp+3J/brwGoyxfdSPkRaCEG8bUq+wfQKn5FoNktcFXJgCpJ0Jrw/UAYMF65y0kX8AagQ8czowjfiQes6lq0fuwmORCbxPauFDGsMWySb6SrjHaGZ9L6v72UEIrSiI8lG/d2UF5C20N8J2Ah2tyqn9+6dq9sJFo8nT32IqE9MUEgGO4AYpX+9MTI3BUKsfsea41anKNOokUAjBaeeufawIFMgdtToYzM48sB1o4n3OJIGi9Yg4ge+LPuWgc8VdWAU7fAlnb9TAIjAllIzU2fm0jABcYsmyXz0H5BF4yO7Zelyj31qpdiL6GEVeGUHga0zdWUduqtI8MzGU7KFAF6I0CoeuI386KpELByuj19qVy41dH0QkBNmZQqlExdRSLTTWnekZS972vHPboUMp9FFDxIHLi+RK7+fNQ+u4e9RREG9gw4vexd7qQtXLQW94uwdYZ1ROnapt76kyoqP3T+VyzFWBxESbW7tHO2wliaEsryk2bToUykVDl6sDMJlu2DZr3mnC59Imb20IqTNmpcjDAHDP5XqFMFktHKyFD2CMSWfZYJ9YEtWOnOBDlaBOjRFD50gP+78p/99rLIsLtiZG18vcntg4bk4C7howYd5yTTGAtdRR6Q7SZIqo9RlIRCEcxmoQfCYkbYhZZ72Nr1xcpeoczKICnMIfjG00vQ4RehRbcBxKnnDK+qYaDIDP0Sq0ocYsTWMdf3m
 leoLbfp0
 WVgc6DXQfOAzoYdEvoZoLKQPgGiPifFDL7hJ9oxazXvwZAlZ4WRm9WwLxhGq4Pu5iWaHbMuhci4Mr3N3P9oojwZvXcKdq6G1ymWwVDDR0MtL4oDVzqOr7BBZTiQ0SVTSY0su4JmUqA2m20wCzWmTs7LTzfDbSvl9yG6czJwkBlB8LJqsGYeoolx3rg2a+Ra03edHBDKCSeZhrOzVqOW62k/LCixh1eXa51g/9pr7cd0Ze4RTT5qQipUDSn+5MbOzko2/hWYQAYP8VyKKpYrXCNmgipnO0W7QEgf7i+RmNnxe1WPI41nlYbkMSirnudwiWa16MxVnxRXgaUUTGiYtch0I3ZpnObZT0ghoHzD4zFHvHSF4fVdmd0go8aO1JO9ABS7ppQKygtBPeRzIG/YNCfUXypSo2qr/J8Pvp8yp+HGTMgCj2a+WUUx/cMPneIV9IPBZKvHsdW2E/XoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:31=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> From: Chris Li <chrisl@kernel.org>
>
> Introduce extendable swap device support - xswap.
>
> An xswap device has no backing storage and no swap data section, so
> it wastes no disk space. Creation is via a sysfs interface added in a
> later patch.
>
> Zswap writeback is gated on whether a real (non-xswap) swap device is
> active. nr_real_swapfiles counts such devices and is maintained at
> swapon/swapoff only, so the gate reflects "a device exists to write
> back to" rather than "a device currently has free slots". This keeps
> writeback working even when the real swap device is full, and avoids
> a double decrement when a full device is swapped off.
>
> An xswap entry is not added to the zswap writeback LRU: with no backing
> store there is nothing to write it back to. zswap_lru_del() tolerates
> that, since an entry that was never added is on no list.
>
> Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  include/linux/swap.h |  2 ++
>  mm/page_io.c         | 19 +++++++++++++++++++
>  mm/swap_state.c      |  9 +++++++++
>  mm/swapfile.c        | 28 ++++++++++++++++++++++++----
>  mm/zswap.c           | 11 +++++++++--
>  5 files changed, 63 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..9073d29377d8 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -201,6 +201,7 @@ enum {
>         SWP_STABLE_WRITES =3D (1 << 11),  /* no overwrite PG_writeback pa=
ges */
>         SWP_SYNCHRONOUS_IO =3D (1 << 12), /* synchronous IO is efficient =
*/
>         SWP_HIBERNATION =3D (1 << 13),    /* pinned for hibernation */
> +       SWP_XSWAP       =3D (1 << 14),    /* extendable swap device */
>                                         /* add others here before... */
>  };
>
> @@ -378,6 +379,7 @@ void free_folio_and_swap_cache(struct folio *folio);
>  void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
> +extern atomic_t nr_real_swapfiles;
>  extern long total_swap_pages;
>  extern atomic_t nr_rotate_swap;
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index c6824fcd483e..25fa9b82ed46 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -248,6 +248,15 @@ int swap_writeout(struct swap_io_ctx *ctx, struct fo=
lio *folio)
>         }
>         rcu_read_unlock();
>
> +       /*
> +        * xswap has no backing store: keep the folio.  ctx->sis is not s=
et
> +        * yet, so look the device up from the entry.
> +        */
> +       if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP=
)) {
> +               folio_mark_dirty(folio);
> +               return AOP_WRITEPAGE_ACTIVATE;
> +       }
> +
>         __swap_writeout(ctx, folio);
>         return 0;
>  out_unlock:
> @@ -486,6 +495,16 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct=
 folio *folio)
>         if (zswap_load(folio) !=3D -ENOENT)
>                 goto finish;
>
> +       if (unlikely(sis->flags & SWP_XSWAP)) {
> +               /*
> +                * An xswap entry only ever lives in zswap, so zswap_load=
()
> +                * must have found it.  Unlock and let the caller retry.
> +                */
> +               WARN_ON_ONCE(1);
> +               folio_unlock(folio);
> +               goto finish;
> +       }
> +
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>         swap_add_folio(ctx, folio, READ);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ebef568cd62e..3a4e9e447b0b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -884,6 +884,10 @@ struct folio *swap_cluster_readahead(swp_entry_t ent=
ry, gfp_t gfp_mask,
>         struct blk_plug plug;
>         swp_entry_t ra_entry;
>
> +       /* xswap entries live only in zswap; readahead does not help. */
> +       if (si->flags & SWP_XSWAP)
> +               goto skip;
> +
>         mask =3D swapin_nr_pages(offset) - 1;
>         if (!mask)
>                 goto skip;
> @@ -969,6 +973,7 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsi=
gned long *start,
>  static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gf=
p_mask,
>                 struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault=
 *vmf)
>  {
> +       struct swap_info_struct *si =3D __swap_entry_to_info(targ_entry);
>         struct swap_io_ctx ctx =3D {};
>         struct blk_plug plug;
>         struct folio *folio;
> @@ -977,6 +982,10 @@ static struct folio *swap_vma_readahead(swp_entry_t =
targ_entry, gfp_t gfp_mask,
>         unsigned long start, end, addr;
>         pgoff_t ilx =3D targ_ilx;
>
> +       /* xswap entries live only in zswap; readahead does not help. */
> +       if (si->flags & SWP_XSWAP)
> +               goto skip;
> +
>         win =3D swap_vma_ra_win(vmf, &start, &end);
>         if (win =3D=3D 1)
>                 goto skip;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e3..32c3133e1211 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> +atomic_t nr_real_swapfiles;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
> @@ -733,7 +734,8 @@ static void free_cluster(struct swap_info_struct *si,=
 struct swap_cluster_info *
>         /*
>          * If the swap is discardable, prepare discard the cluster
>          * instead of free it immediately. The cluster will be freed
> -        * after discard.
> +        * after discard.  xswap has no bdev and never sets
> +        * SWP_PAGE_DISCARD, so it always takes the free path below.
>          */
>         if ((si->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) =3D=3D
>             (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
> @@ -1216,6 +1218,9 @@ static void del_from_avail_list(struct swap_info_st=
ruct *si, bool swapoff)
>                  */
>                 lockdep_assert_held(&si->lock);
>                 si->flags &=3D ~SWP_WRITEOK;
> +               /* Count active devices, not merely those on the avail li=
st. */
> +               if (!(si->flags & SWP_XSWAP))
> +                       atomic_sub(1, &nr_real_swapfiles);
>                 atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>         } else {
>                 /*
> @@ -1273,6 +1278,8 @@ static void add_to_avail_list(struct swap_info_stru=
ct *si, bool swapon)
>         }
>
>         plist_add(&si->avail_list, &swap_avail_head);
> +       if (swapon && !(si->flags & SWP_XSWAP))
> +               atomic_add(1, &nr_real_swapfiles);
>
>  skip:
>         spin_unlock(&swap_avail_lock);
> @@ -3268,7 +3275,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>
>         destroy_swap_extents(p, p->swap_file);
>
> -       if (!(p->flags & SWP_SOLIDSTATE))
> +       if (!(p->flags & SWP_XSWAP) &&
> +           !(p->flags & SWP_SOLIDSTATE))
>                 atomic_dec(&nr_rotate_swap);
>
>         mutex_lock(&swapon_mutex);
> @@ -3378,6 +3386,19 @@ static void swap_stop(struct seq_file *swap, void =
*v)
>         mutex_unlock(&swapon_mutex);
>  }
>
> +static const char *swap_type_str(struct swap_info_struct *si)
> +{
> +       struct file *file =3D si->swap_file;
> +
> +       if (si->flags & SWP_XSWAP)
> +               return "xswap\t";
> +
> +       if (S_ISBLK(file_inode(file)->i_mode))
> +               return "partition";
> +
> +       return "file\t";
> +}
> +
>  static int swap_show(struct seq_file *swap, void *v)
>  {
>         struct swap_info_struct *si =3D v;
> @@ -3397,8 +3418,7 @@ static int swap_show(struct seq_file *swap, void *v=
)
>         len =3D seq_file_path(swap, file, " \t\n\\");
>         seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>                         len < 40 ? 40 - len : 1, " ",
> -                       S_ISBLK(file_inode(file)->i_mode) ?
> -                               "partition" : "file\t",
> +                       swap_type_str(si),
>                         bytes, bytes < 10000000 ? "\t" : "",
>                         inuse, inuse < 10000000 ? "\t" : "",
>                         si->prio);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced..7fe25f0b157c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1018,6 +1018,11 @@ static int zswap_writeback_entry(struct zswap_entr=
y *entry,
>         if (IS_ERR_OR_NULL(si))
>                 return -ENOENT;
>
> +       if (si->flags & SWP_XSWAP) {
> +               put_swap_device(si);
> +               return -EINVAL;
> +       }
> +
>         mpol =3D get_task_policy(current);
>         folio =3D __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), =
NULL, mpol,
>                                          NO_INTERLEAVE_INDEX);
> @@ -1511,7 +1516,9 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>         entry->referenced =3D true;
>         if (entry->length) {
>                 INIT_LIST_HEAD(&entry->lru);
> -               zswap_lru_add(entry);
> +               /* No backing store: nothing to write these back to. */
> +               if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XS=
WAP))
> +                       zswap_lru_add(entry);
>         }
>
>         return true;
> @@ -1581,7 +1588,7 @@ bool zswap_store(struct folio *folio)
>         zswap_pool_put(pool);
>  put_objcg:
>         obj_cgroup_put(objcg);
> -       if (!ret && zswap_pool_reached_full)
> +       if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapf=
iles))
>                 queue_work(shrink_wq, &zswap_shrink_work);
>  check_old:
>         /*
> --
> 2.54.0
>

Hi Baoquan,

I checked the xswap handling across the swap I/O, readahead, and
zswap writeback paths.

The SWP_XSWAP handling is consistent with the no-backing-store
invariant: swap_writeout() keeps the folio dirty instead of issuing
swap I/O, swap_read_folio() treats a zswap miss as an invariant
violation rather than falling back to backing-store I/O, and both
readahead paths are bypassed because there is no backing device to
read from.

The nr_real_swapfiles accounting also correctly tracks real swap
devices independently of xswap, so zswap writeback remains enabled
as long as there is a real swap device available. Excluding xswap
entries from the zswap writeback LRU is consistent with the same
invariant.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

