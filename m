Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E314CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4C76B0088; Tue, 29 Sep 2026 05:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BA36B008A; Tue, 29 Sep 2026 05:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A29D6B0098; Tue, 29 Sep 2026 05:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEAB6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:21:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B995A1A0441
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:21:20 +0000 (UTC)
X-FDA: 85266256320.19.A87D9DC
Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id CC69C100007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:21:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H37lMM75;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790673678;
	b=cs/Z+xHBL9Q5ub6L6Gmadiajc7YL3Txqu0IJIKc0wKLx8EjBplcSvD3hnW14b26LYLQb/Q
	MCbhqbht8UeVuvpSkhrLygpDxkPcN0ds/gZQxIzazZQmcGWIU6E+E+Hda9h28tkbZO32X1
	7jOdg/c4OZGWbwpgSPNE/Qs/C0Up9t8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H37lMM75;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhqndOhozIw40kNwzku+lND3i27hg00jPoEVizKt1rI=;
	b=kN2wSQpxC8rUW+2qjFPiIV3JAi7suCsFOjfrN+TIjjvW2deKx5q+D6DvPWaVrFWQ6snXBg
	YLFIeSsr8Y5GN2QzjQihLisBoXwgG7LtPFhpIf0dU3o7oIT8G3u6dBZ3vCNIpmJiO4Y5so
	TvG4jbnUDWoOPsaMPqaub+kOaS3VdNo=
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c570a3030so354574266b.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:21:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790673677; cv=none;
        d=google.com; s=arc-20260327;
        b=XM/+voSV8WTX9j120wR0fVA+UFB29oaIC2+TPzeS86BYGJgJGD2T6g5yEZJCD7F+9O
         +WlIwQUdb11t5Ja2s931wxbRdTf+ToGNZ3LBwApmkTZWwr6H+x1MhlwLCkeIr9i90jHa
         4ecHOsY07Jyu9rye0AcaOd0p37nfY1S8jUHJ9YL93rqVQk6upIeqGRn+AwgTMIuufNJo
         f4uZU+D/Ouc0aOQjYjIchf55o18F5MPT6SNCfD6jw/MkhIR72GUa5O+WxVh8iYXxcHvp
         OilqPE/aFgYX59a10oAjT13vAsfc2r63x5oWl8ihEVfiQMb/gcvtSuS64790b4pyEl+f
         zNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GhqndOhozIw40kNwzku+lND3i27hg00jPoEVizKt1rI=;
        fh=oY7hdysDMdOL+AIMpbjByyTN5z1fOfKN3ES4/iOGGRo=;
        b=NNtwwSLL/0JVkwUwbgDabyBMJWgYlusvvuyS4AFVljPUachglwGLwowXdF5QkudPs1
         V1FRWFS3siRwf46i6yIi0/IKLsnhAhM7IMAxMn45+E3kHFMJjlEjqFvMyt51glw3ESJn
         Wykr2sTKrdrV5tQQ8tZKsLKafr8PZEtH4z2dfRYtmNTxvh2DaOdpqDktAtnGFaCCVvyd
         fAvOnczmUW6tTZdvSIq7A+/XMr0xw43KU7onPLOSiFEuFhAYKoDlVkw8Qc5bLk8XJevV
         mPgYBYrrv2Z5WA+Yqzx6kB45/z65eZ2AMTndKLhdwsy8vcA6f7/6EjgqlJ0Cs05Q0uPg
         h3Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790673677; x=1791278477; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GhqndOhozIw40kNwzku+lND3i27hg00jPoEVizKt1rI=;
        b=H37lMM75yNvCPDcAjU3uSqcKNO7/8cby8ynphmbgMlpplcLVaG+BfOmFbqZZgupKCk
         73B0bwcB91c517+qcZbA3GW3493CAncAYdbbiI3DbTTi++8KU2z6INJxTcx38e2bAw/+
         z4j0mUsBrfPMey7ZJrQ2ukDJkRK5HhzE2PXvsfbCggNrB/OcDtC4RmJ3KauHaH6AWI2x
         Hf/shEUoTExHGfQyjjENIT61zsedL5BG/q9yT4s4SSwCq4Y3F85ceVMV+NczTubUBKER
         S4rQ99nI+u3ENnAoag9joFTkizkOCFxCCOwJWzdO3YDb7vCX4pz11diI2E3I++8OAYVV
         LW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673677; x=1791278477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GhqndOhozIw40kNwzku+lND3i27hg00jPoEVizKt1rI=;
        b=dL/n5cmhOnffPM1HHkTk8Ru1OiTp6Z3l5Jo59nNZWl8v+W58FxoLCJW2oLzv802JoC
         UxioD/e32wPdUVCzjRqSyzSy9CI6OwkwhnVN+VLV2OkyNViRU7CKbt/PsIO9T1pFM4Qy
         pXfEIzJoivPX86KY2sv73n0HTaMVoxKmzDRqSzJ+9QrWZRM20lnZc+QdLiLjvYHi1DKi
         GlSZQT6LHu/O6BAshy4ycWkr6OiaW2ZQHLnT6WUyW7Wl9PLQF2L1DXv2pw3WhhKU08pz
         kZI3bneaST+7eWdxercwH1mr5jBq/hwjGLyUWEpjVHhP4I+3Uc5NYAW1qFODJ2hY5fgz
         hyLQ==
X-Forwarded-Encrypted: i=1; AKwUvByuUpBaU6nCaWkvmr/2OpSH/DIF5xgZNR88SISUnuo/L8IZcZ0w+VCs59gB6cQ4hQ7WtHi+UwU+YA==@kvack.org
X-Gm-Message-State: AFuF++mJ7P0/w6fLgRFSjzYu3SUhqwWCXAZNiaBsUmur3Z+Nou0z8m0p
	5jSp5veSwUWimXjee4SjPcW9NdTx+yE6ql5k+4X3PTFWxDVS9M2yzZaRy6OOJ/BLJEAT092ICv8
	3hfQX2hNAwYI023zKprJSk7ZqUCd2DPc=
X-Gm-Gg: AYBFou2h6KHzyEFn996W/rElDNibGNe8wOpRY8oEdZtLNU94LVjB/MkZAFaqcs+FcBs
	O7UPtg7zdj7lp3auH2gqg+wthTVjh5m1FE2qs2Lc+ns9TbR5hKDkNiK2oYz6j1P3shJsxf4xy5c
	Py63zyd+juCyLdVmC0HDyNCqizzTORoqy1u1U9BdoWKyTXjW7KmlrxVnPEfAklq7ioXA4/ixq+b
	m5hK3XJmR2aoHZmI5ImaNlXQeqSgEH21hF5haDnHr0yoX/jNGDOAnL/OBbq0cj2a0pUp7Nay/WC
	0jPqm5YhNbJfRme3qyHUTgeWhCZ/UVW6XNnRugEXDmamXTS4TRmPD5aMjLee0o8OXpf5WVkecuX
	3qWbUzK7nXvU=
X-Received: by 2002:a17:907:c80d:b0:c2b:f3d5:2090 with SMTP id
 a640c23a62f3a-c2bf3d52cd4mr701192866b.27.1790673677038; Tue, 29 Sep 2026
 02:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260924131106.1730494-1-dev.jain@arm.com> <20260924131106.1730494-2-dev.jain@arm.com>
In-Reply-To: <20260924131106.1730494-2-dev.jain@arm.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 29 Sep 2026 17:20:40 +0800
X-Gm-Features: AclHuK9lxCbTSA0mjXTjQjkfbiHSsXqGwiLHzR329M81OQsBZnsP4Ya5LuEJfD8
Message-ID: <CAMgjq7CWom3pwZa5j=gmtb57Y+1+QfAkmkLVcgKnJVsZi+Fi3w@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] mm/swapfile: add batched version of folio_dup_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, davem@davemloft.net, andreas@gaisler.com, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, pfalcato@suse.de, jgg@ziepe.ca, thuth@redhat.com, 
	sparclinux@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: yod9we1b99sk8pj1qyfo34h3nf1jxzhu
X-Rspam-User: 
X-Rspamd-Queue-Id: CC69C100007
X-HE-Tag: 1790673678-118897
X-HE-Meta: U2FsdGVkX187leXzoLYcTRmWpKGR88eqY0krlVeKOoMKqLWujRVXZEu5pK818sUg5JYp475h7FxirzaxskCp8eZRNep0kkZ+614tISVlI0pIFaV7CFEkN0dolAyzYOM6vvynQfFxfHMCnAsb/NhrnkP9aS/ysBDaHezj4hG+oRsjMjnHZ4J8TA9Z9ZShhRWDLr0EFhccii+K3jLo5ZtPog2Jxqusmr/f1ysVHSZ3ZzQYp/LEhZYIOKOUxW18PxhKZBAYf7yIePkMyCYSN1V6vuv6E6CdQblTY/fglGdDHszzsyKD1XlVx9M5fwPxy1jbNrqDWFgY4trx/vnyFQ5HtMIIlYtiiJ+Zq18Dp9BbpSXhiizJ4JVjhn0ruYQz26tpP6r0QUb1F3tF9bT9QaXnQvfiib5Gq9uNyH6QzYFojQthvLGnfPICeI8vZmOMp6TcWOUutMIUrz9ZOiipjLQvAvBuLUgW1vYFaCj+XruSugcLlEfS9JLiMhD6la5z9S3Klv+wmyU5r/+QRZaDPAiI771QMSeFHwS3enYz1UvBqAkDKmImxHIPqhcRvn1rj7BHWMt59RIFmj1T/qez/Splj/O4yKAl/Nu1OxxuwESXZTlX4lYYd/K5hUId6GRVqYe1BT3Y8zD5vwR9LHzzTOTgyH5D+jVffe2bZhibtzf01bJz1dakva1BDBtS0g9A3nDTAF0q+OHxxouN1lcKQ7HsXP0IDsybccw3SPI/BoM8Z1luUsBEU8ZpXGWqvleSlyKpGJ5pMqd5R5cGMiT3QfZTaCL1g4wtlHLAQbUKjPmkB4qONpDNFHddPCeLKBkPdUOe4ntqvtr4ZI8iUbIoD7NZsD/vjsshuDq0vHm5p8UVoduMqcPtIIvkEPH96BbhRJuK2/tIK9YavudfdiEeWkTFcAMeWCiV2wL7KEEKpPwRf9LEXZRuTh1c2oUNmzkd/1+ED9FLkruK9kfS0zKaKCe
 bcIWzCKr
 QrKJE6JPugEjV8nxiqtSWmYMBLq2fpgTqe1UisgA7gOkv1BI1bFIQM5RdttMd64eR3vZh5In0qEf+EEBcTfMJTrOADD2bw0PRbSRA7v5Y/vw01iu0t/XP3M4m3vQ/BpnC5NrWgqnZxtzIy9ITG9O3q34NRzXHs8v70TkF2+Hj029v5rjQO87G0ScA2rPQBOSivHRcgEpzxuo82GJ4R5NG/uN7e3TnLPbdAp0Uso5p6Rv3wR4S6X2UprGIs7HtNrHiohZZgo3m79Drrz5XiE2zJqLfpxXz/dITtf6/MTsTXg78HByI8tS33ODTJqCX2Au9RC7htotZSruYFq7OOicm3c4erAh7H3nQrHApfVubgh37i96fsj7y6P5IpPzouxJXP1b0KaD5dzf5bryiZGJj7TFpu/uNtpxK4HiqQX6RjqegCkjxNUZI4KR59OqeHueKMke3Xa+Y7roQp4JvVe69id6d5swqFRkpsRksclTG3olsjBAxmAkYAsMmY+fpfb5UwVN6ezr2lZqdQ5GvmJwt/wNt56ldE0mE9MP9QMa/9eq7MnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 9:15=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
> that folio_dup_swap already can handle a subset of this: nr_pages =3D=3D =
1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_dup_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 and folio_nr_pages()), and invokes folio_dup_swap() if it
> wants to operate on the entire folio.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c     |  2 +-
>  mm/shmem.c    |  2 +-
>  mm/swap.h     | 18 ++++++++++++++++--
>  mm/swapfile.c | 18 ++++++++----------
>  4 files changed, 26 insertions(+), 14 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6661bc11ce658..a70dbc8d544e1 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2150,7 +2150,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_are=
a_struct *vma,
>         swp_entry_t entry =3D folio_page_swap_entry(folio, page);
>         struct mm_struct *mm =3D vma->vm_mm;
>
> -       if (folio_dup_swap(folio, page) < 0)
> +       if (folio_dup_swap_pages(folio, page, 1) < 0)
>                 return false;
>
>         /*
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b572c60f2af85..d5bd9506ce500 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1914,7 +1914,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct =
folio *folio,
>                         spin_unlock(&shmem_swaplist_lock);
>                 }
>
> -               folio_dup_swap(folio, NULL);
> +               folio_dup_swap(folio);
>                 shmem_delete_from_page_cache(folio, swp_to_radix_entry(fo=
lio->swap));
>
>                 BUG_ON(folio_mapped(folio));
> diff --git a/mm/swap.h b/mm/swap.h
> index b3b54c28929a1..47290510de264 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -244,7 +244,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, =
gfp_t gfp);
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
>  int folio_alloc_swap(struct folio *folio);
> -int folio_dup_swap(struct folio *folio, struct page *page);
> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +               unsigned long nr_pages);
>  void folio_put_swap(struct folio *folio, struct page *page);
>
>  /* For internal use */
> @@ -368,7 +369,8 @@ static inline int folio_alloc_swap(struct folio *foli=
o)
>         return -EINVAL;
>  }
>
> -static inline int folio_dup_swap(struct folio *folio, struct page *page)
> +static inline int folio_dup_swap_pages(struct folio *folio, struct page =
*page,
> +               unsigned long nr_pages)
>  {
>         return -EINVAL;
>  }
> @@ -464,6 +466,18 @@ static inline void __swap_cache_replace_folio(struct=
 swap_cluster_info *ci,
>  }
>  #endif /* CONFIG_SWAP */
>
> +/**
> + * folio_dup_swap() - Increase swap count of all swap entries of a folio=
.
> + * @folio: folio with swap entries bound.
> + *
> + * See folio_dup_swap_pages() for more information.
> + */
> +static inline int folio_dup_swap(struct folio *folio)
> +{
> +       return folio_dup_swap_pages(folio, folio_page(folio, 0),
> +                                   folio_nr_pages(folio));
> +}
> +
>  extern const struct swap_ops swap_bdev_ops;
>
>  int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c1c5fbb3c909d..75167b8580cc0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1799,9 +1799,10 @@ int folio_alloc_swap(struct folio *folio)
>  }
>
>  /**
> - * folio_dup_swap() - Increase swap count of swap entries of a folio.
> + * folio_dup_swap_pages() - Increase swap count of swap entries of a fol=
io.
>   * @folio: folio with swap entries bounded.
> - * @page: if not NULL, only increase the swap count of this page.
> + * @page: the first page in the folio to increase the swap count for.
> + * @nr_pages: the number of pages in the folio to increase the swap coun=
t for.
>   *
>   * Typically called when the folio is unmapped and have its swap entry t=
o
>   * take its place: Swap entries allocated to a folio has count =3D=3D 0 =
and pinned
> @@ -1815,18 +1816,15 @@ int folio_alloc_swap(struct folio *folio)
>   * swap_put_entries_direct on its swap entry before this helper returns,=
 or
>   * the swap count may underflow.
>   */
> -int folio_dup_swap(struct folio *folio, struct page *page)
> +int folio_dup_swap_pages(struct folio *folio, struct page *page,
> +               unsigned long nr_pages)
>  {
> -       swp_entry_t entry =3D folio->swap;
> -       unsigned long nr_pages =3D folio_nr_pages(folio);
> +       swp_entry_t entry =3D folio_page_swap_entry(folio, page);
> +       unsigned long idx =3D folio_page_idx(folio, page);
>
>         VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -
> -       if (page) {
> -               entry =3D folio_page_swap_entry(folio, page);
> -               nr_pages =3D 1;
> -       }
> +       VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
>
>         return swap_dup_entries_cluster(swap_entry_to_info(entry),
>                                         swp_offset(entry), nr_pages);
> --
> 2.43.0

Looks good to me.

Reviewed-by: Kairui Song <kasong@tencent.com>

