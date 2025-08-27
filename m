Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD09ECA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDCA8E0126; Wed, 27 Aug 2025 03:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295248E0105; Wed, 27 Aug 2025 03:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB248E0126; Wed, 27 Aug 2025 03:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 097CA8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:04:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE96F1604A8
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:07 +0000 (UTC)
X-FDA: 83821648134.29.1ED2C0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD89040007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVG+ybQ9;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756278246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSThdWAT/nGAXZF67VC/+d+YRcvjTybQi2meKMsrIsE=;
	b=Kn/UWAnhUUPFVJM0c1A44shVXcbS+hHLkxcAXz0HHk3sWOrL7d04DJLwPLm2oCsOLrxs2i
	StsNa4XZz4f25cXB3djvCk37MnBWxXo5qfrkU+M4xw/M1LQENPa5hCkC7p+w9m3+YIjYQi
	WBrKGcXPIhCgb+h6TlCz3snRcg9D2EE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVG+ybQ9;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756278246; a=rsa-sha256;
	cv=none;
	b=5Y3qjTPCavZ3bEgKvCOg8jSuOvokqyt+/i+hMpeUpUM4KP452U4YZy0wuhA7EtvZhkXh2e
	csCMu+wAwENX0LvChBY0YkK20I/H1iFRENyq5cNB2vVTO1Zu6akZlOz6aifAjg12Gzn3nD
	7LGMsvFTauDQBfnUd4rvmjpWVerox/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EE0E444E3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37242C16AAE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756278244;
	bh=H5CZ2tzbkSmKe4NS8/T4DKNGORhGlbgAW543kjz/iq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PVG+ybQ97gAPd4LFhIR+G+kvrjKv5810J1QRkFAKGzZgz1DE7OJii/r2BNoPZGfUu
	 7N9Rm8U6y7iLF+KFMZT5TwrDWYOZEq3cgR3462BUv3UG3WRUhbEwC7Jadl69YN3LLs
	 kflnravkk/zUwRDIpr/5sJLyXhOBTquduWLT8LPWOgASvRLLKrIzFyCFU6NSLZq8Xa
	 PJDhiH2B1vblu+tcNjydq4Yj3XPxCXuTTxlansUWkNVhPO2Zh4fN3o9vpxOtkTMf6r
	 Y+J9WF2+6Br5+Z9/jmaKNovnECLjWNbjetoIS3APzDc0scdpfDAEbQFez1PiBiy6oY
	 kC8HlH4aMlTOQ==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b72f7f606so6085e9.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:04:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YyzbnwyCIGoaHNsa9lZuGj8z8AOgBfx4iVH87t2ylb3tjtVZ6hQ
	ZtdlpvEvBStAp+hzGgUcapH97UXo2IDpFbPr+6Esm3IE1cjkaXXPhKN7zrKYUJc25PFAC5JmrKF
	TtLjtFB5x4h7JCx5boVSptv/IIObHwSrcWGwvnweq
X-Google-Smtp-Source: AGHT+IGBj0S1YqcNqOkhVcoHPopUd0x4JO1ktWGHJxrJEhQxDs2ayKTTjYgC0+ca8SME3350p2Zfcb964yCWaq4vMqc=
X-Received: by 2002:a05:600c:793:b0:442:feea:622d with SMTP id
 5b1f17b1804b1-45b669691bcmr1716945e9.1.1756278242844; Wed, 27 Aug 2025
 00:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 27 Aug 2025 00:03:51 -0700
X-Gmail-Original-Message-ID: <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
X-Gm-Features: Ac12FXy8dmeBtEZtyu95HnMDsR5nhtEyMNmwLO0U59Mi-B1KEbZy2QkKBB2jnbM
Message-ID: <CAF8kJuO0efOE-os=qi=i5jT1YWxspHYc=Ti1KN=uKgyFpWTRbA@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD89040007
X-Stat-Signature: 8jdskkijg5t614crshjjeych81m68waa
X-Rspam-User: 
X-HE-Tag: 1756278245-739941
X-HE-Meta: U2FsdGVkX1+0UVgBa4fkXImmAiCRp/HLHfMdVM5YvTggc8693FwkiEAnvqyHOftw21cT3QyFhbPJocs31lclkhUjG1LhSh8fIvBLc/OTjwjcfiQrg9aXXUjha35qQixI/IbdMeGDd2zzinHurIRhjpR6Vdd0MtHK2NA29WzooD0/MEGz3WzNYhSyVuUPnAmjmIxp4HN4y1E0a0d7AsWYSvASsWGu8/NdYJnL59gkvSHNY32s6xCxJs4HaIJV9yXqIwkItbRTZgZNlROVn4nrPbsATmMGiyBoOTtk+M/dzGIIUfUSCIkhfOoR2OBA/CLUBeRy+KFM6p4fQmkpU6QH7mse7F3Ef0IQrQ4Q0TtHoZDZ1Gc7TfUhEZZvepDQMJx5hopiPUi1I88O/EWICX1kPY6Ul9QYfn8JTJbTO1a2tSSSQUywy2JPkN4lGJ1KDEZSGw9Cxaqgc4PFuQAc/dQwGs8bWi4phFMhI8N7jrik4xyBUl9t/750PnbpP8sLj41hvZ7brbMUVLAgHXmfBMTgtL7elb9C7dlbCEMcxDH/DISBwn5VW7LOwfnWHhnZM27P2qPYapOs23BxeE6F7lW6xdPRHWcZn0frzvaLnnrjmz7vlpyL4ecVXrgogT0Fj2paXYMPDGiYfw2MhNG3rLwNK7uvCiG2a0B7ASg9akg/ww7IO16OiVycsKoR2nImdnW1+2PquMEiILD39QN205Npr4LBuhPoGAejLLzomPbEfiFqodOdP178DgZdThwnf7PVe8OTRK50mf+tg2AoUN7pV7wzN9B5LsI9izouAPylNYNDZ/P/Lizifqu05bt8d6zZyUB6xV0UAzZr1zAbx1iiA9V8h28xKnWK7zDYHU8X+dWKCeDuX+CFVxxLRqCcpOUysvY8dTPk5nVY/AWvgeBE9RsjXfTYWmb+ddfCoUUKOwk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:

> diff --git a/mm/shmem.c b/mm/shmem.c
> index e9d0d2784cd5..b4d39f2a1e0a 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                         count_vm_event(PGMAJFAULT);
>                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
>                 }
> -       } else {
> -               swap_update_readahead(folio, NULL, 0);

Also this update readahead move to later might have a similar problem.
All the bail out in the move will lose the readahead status update.
The readahead deed is already done. Missing the status update seems
incorrect.


>         }
>
>         if (order > folio_order(folio)) {
> @@ -2431,6 +2429,8 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>                 error =3D -EIO;
>                 goto failed;
>         }
> +       if (!skip_swapcache)
> +               swap_update_readahead(folio, NULL, 0);
>         folio_wait_writeback(folio);
>         nr_pages =3D folio_nr_pages(folio);


>
> diff --git a/mm/swap.h b/mm/swap.h
> index efb6d7ff9f30..bb2adbfd64a9 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -52,6 +52,29 @@ static inline pgoff_t swap_cache_index(swp_entry_t ent=
ry)
>         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
>  }
>
> +/**
> + * folio_contains_swap - Does this folio contain this swap entry?
> + * @folio: The folio.
> + * @entry: The swap entry to check against.
> + *
> + * Swap version of folio_contains()
> + *
> + * Context: The caller should have the folio locked to ensure
> + * nothing will move it out of the swap cache.
> + * Return: true or false.
> + */
> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t =
entry)
> +{
> +       pgoff_t offset =3D swp_offset(entry);
> +
> +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +       if (unlikely(!folio_test_swapcache(folio)))
> +               return false;
> +       if (unlikely(swp_type(entry) !=3D swp_type(folio->swap)))
> +               return false;
> +       return offset - swp_offset(folio->swap) < folio_nr_pages(folio);
> +}
> +
>  void show_swap_cache_info(void);
>  void *get_shadow_from_swap_cache(swp_entry_t entry);
>  int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> @@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
>         return 0;
>  }
>
> +static inline bool folio_contains_swap(struct folio *folio, swp_entry_t =
entry)
> +{
> +       return false;
> +}
> +
>  static inline void show_swap_cache_info(void)
>  {
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ff9eb761a103..be0d96494dc1 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -70,10 +70,12 @@ void show_swap_cache_info(void)
>  }
>
>  /*
> - * Lookup a swap entry in the swap cache. A found folio will be returned
> - * unlocked and with its refcount incremented.
> + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
>   *
> - * Caller must lock the swap device or hold a reference to keep it valid=
.
> + * A found folio will be returned unlocked and with its refcount increas=
ed.
> + *
> + * Context: Caller must ensure @entry is valid and pin the swap device, =
also
Is the "pin" the same as  "lock the swap device or hold a reference"?
Not sure why you changed that comment to "pin".

It seems to me that you want to add the comment for the return value check.
Is that it?

> + * check the returned folio after locking it (e.g. folio_swap_contains).
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_t en=
try, gfp_t gfp_mask,
>         for (;;) {
>                 int err;
>
> -               /* Check the swap cache in case the folio is already ther=
e */
> +               /*
> +                * Check the swap cache first, if a cached folio is found=
,
> +                * return it unlocked. The caller will lock and check it.
> +                */
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         goto got_folio;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4b8ab2cb49ca..12f2580ebe8d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>          * Offset could point to the middle of a large folio, or folio
>          * may no longer point to the expected offset before it's locked.
>          */
> -       entry =3D folio->swap;
> -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry) +=
 nr_pages) {
> +       if (!folio_contains_swap(folio, entry)) {
>                 folio_unlock(folio);
>                 folio_put(folio);
>                 goto again;
>         }
> +       entry =3D folio->swap;

Can you also check this as well? The "goto again" will have entries
not assigned compared to previously.
Too late for me to think straight now if that will cause a problem.

To be continued.

Chris

