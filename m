Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3D2CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 19:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787446B00B3; Fri, 29 May 2026 15:00:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E736B00B4; Fri, 29 May 2026 15:00:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674A66B00B6; Fri, 29 May 2026 15:00:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 540F86B00B3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:00:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8AD0C1457
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:00:31 +0000 (UTC)
X-FDA: 84821373462.03.E08A467
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id A43C1140029
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:00:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGKyoBT2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780081229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGQR4YysPBB/foRQIvAUmjWKvFtUy/aEBc6VLae5pA0=;
	b=fVgLf2GdSqkROYBLB+Kq+5QyemvmrgTPHz+qaQbl60B9YLtt/FBqskQSDV9ikN8cygLBt/
	8wq4UGMeE2JMXal7NU3sD9BKSaGmmfU5qIfSfmUdHDsexFo0NzoQPzN4+M4vpbSROT7GER
	yZ8UrfnSMP52+vKTIYjJbZNNupTZ+Kw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGKyoBT2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780081229; a=rsa-sha256;
	cv=pass;
	b=LZO0dweS9h0dwQ+ec7CcQqfQbEIDp8C0I1OiSMPovhBjTJGtbPbTjzI77YMWWJ2Ext6Yil
	iY3JQ4nLfhw+/ZYV+Ow0BPeM0T1a1yOCuKOoTEY/NQg2m7Ql4+1YfhDHlnNBnWgKEbUmZU
	hjFOX+AfYOiYNhSvzvXpp37upcgD328=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ebafde87cso5170592f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 12:00:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780081228; cv=none;
        d=google.com; s=arc-20240605;
        b=Jz3Md5ts0ASdIhbkRYAyvT9wU7pnoT/0m4RHAHsDVxDDLLxrxm/Rz2iNKyOaecp2bu
         hiulWfjTxFMabkLHFtM6bCkds9yIHHgIqn60NAhVfcyBY5GY0n5nlayvzL6tp/yugme4
         pwfAuivZRpibpQPTKBy5LFk2KxHxJYqaUPhp3zjQ2eBncLMeuwNks7ioqaW6mE3umtUB
         Od/bfd1ieAt6HEpAWn6c0VCMmKd1E7fL9mmbhnnJHNkCwpwFn++1qADD1tnaw98wzDdx
         yZPycdpy6a6H4hvcD92A81k4NQ62+MhGpdEuqUZPthAgbskGCl74e+xLYBGbS1vgAoCP
         Iivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aGQR4YysPBB/foRQIvAUmjWKvFtUy/aEBc6VLae5pA0=;
        fh=gCdIlauTWoc2iRLVu9gDiZzN7kg2RjrsHMm2QABMvCY=;
        b=GD5t4pur6Y1MYsNc0xOHodKNQeY6yjM1XpKhB/cBoITMvMptJAVDvGpzS6I9GsX8Jz
         EsMwehzHvD6S8Hb4S0vepKVabqrD3ONN9G6rEOjJngDWoELeRFIk81S6egu1mnGM7Nqo
         6GXyMvVHlQWfwNHZu4BhK1WGkFWHxhH7fCr2YA/di2YNR0vEJ9y8KAxDS+u4LHG4STDI
         PhmbKnhGM5MpwJ4LpxIbX6NeOBMfjeDA5182tDTo2xTBaR9aem1XMPOvyIcgvD6fvdZg
         h0QZO1i58hWttVQrc+W2TAZjGul78pfkRNMJr2HrpU4+xkBvKoq0WtLRsai85/eXN0ey
         rFIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780081228; x=1780686028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGQR4YysPBB/foRQIvAUmjWKvFtUy/aEBc6VLae5pA0=;
        b=rGKyoBT2qX1P0eIxeCOmSHCArJSn391iuYbLPPNbywsE/uVmTkS5Yypx7GMyWG//xK
         iCooT8ZWd0RdgS8DCz/9JOi94nbI5EyS0oDA6gTi0PmZNexQz9ocIzMvGUrUJNQCvGWb
         97XnKU/ldhXH7roCTUzJvuIYVHUWsLS8miFRuPVKHuUFgEPfxJjVqS/dNEIBx4AZEpE2
         Oc7yComkjq/QGuK70hzYZruyxI/raEDDEZlMHdZD8K9Aa/okQWMN6aT1SHSek5avxTE0
         viU9NpZ/BQI41HiylDD5lREMA1BN43KB8cKlFs0bzMI1hVCqsk4nn6rH0otY27vRx4RG
         Wo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780081228; x=1780686028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aGQR4YysPBB/foRQIvAUmjWKvFtUy/aEBc6VLae5pA0=;
        b=avmPbFsG1YPJFiLFdWrX8X8LsPPV+2MQWt1WTN3/0ZHI5bbMJxVw4bOw7BMLl9fmOz
         KylhnnVfSSLWk9/ArhHB+3lJZqACzy3ieJfhgtpExUZwBmVENwtUY9YBW+xbZQByjMyb
         LMQ4POTvy99bE7ZjOxz8U4CfvIHnw/CkfeUiqwzYXLa93yAB42pK9cp8b3pif4KXEWxD
         ZPSwJbvhckHYd/1IAXaCth4Lwo9SzziGTruNBjIVLNuIXqeay/KHI4Uw6TR9AmjmUVBz
         NcDlDJB83dUJejy4TxpZ/jkyexvSqyPJCDhLiPGVoln2uFoCcHmarWfo+wrutd1M/Rly
         tI1A==
X-Forwarded-Encrypted: i=1; AFNElJ9KHEjY3cP84jSa7MCrDnztFSxU4lg76Xxkwng4YcwVGfRXcZZRpUs0pCr2qglj6H9zixJIJjJwrw==@kvack.org
X-Gm-Message-State: AOJu0Yw2TQJLV1bytyKX+K5sRcQIj/Q9qAveCkSK52gbXw0KLKvFIQn3
	uIySevQpVRBQOd6+s8iY19r43Zog3hdy37scVgYCsXCsiK7jaiDvIMl7rpmPZc3EASWGHUN66vw
	1UoaAHIrVmsC6thswJXZRy/kEGV8x+EI=
X-Gm-Gg: Acq92OHnx9dCdiT1Bc1xaJgFCF1RyC6ohboHR4B7BLaTK98b/u6BUWrOn3XL7MDIB0R
	Lln77R+G0B4bDUUozCb/AWl4+zYUMv9GwLbv6lfV/XZHOfZ5TmOuTOmocFWzL4KHVH+lt35r6bn
	uu7TTUug8nawrEQBmqLc4C3LZ+/dlVLC5e9f07b5SnlhM+Mf21ThtWhrNxpA7+4YQ7Vy9vvl3sw
	wUBEWYQVOBq5bggP+IxZEIzJtwcLJlTcLDzY+s/SVxUb7cVCRz5dj4KWKBIRH5VcjuFwPVh+3AT
	JhHWtuES8OFGdDcIJ8UGQO2IlkR2BZFk9eF3LHRhN0nKbRdtrTnXoMQ4ZGEz
X-Received: by 2002:a5d:6e42:0:b0:45e:ec27:b4b0 with SMTP id
 ffacd0b85a97d-45ef6b6b9e5mr1263048f8f.18.1780081227932; Fri, 29 May 2026
 12:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_69E7033C2446FE6E922D28B82E9F59142D09@qq.com>
In-Reply-To: <tencent_69E7033C2446FE6E922D28B82E9F59142D09@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 12:00:16 -0700
X-Gm-Features: AVHnY4Lmd5EuNAmRswfTBPzH28gWST3OFE2RsUoUHLPyi7DvUKM0_DWVHRndTho
Message-ID: <CAKEwX=O_Jt3aCxocDoY1h5AY=-eOYnj_0saQ4rMbdfnLzPAFxw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/9] mm: add common locality admission for zswap
 large swapin
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
X-Stat-Signature: 7t9p9ihu47z3kyyn761iorz73iyrrft7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A43C1140029
X-HE-Tag: 1780081229-25433
X-HE-Meta: U2FsdGVkX1+OMTzeMe7A+0VjTltmPFBQGF/NuxPjOjiHU5zgMjUwa9YX3Rx4FnhXu5iW3FFFVuiXgiLNpUt6Vq/wHpslyy92HCb22NlB1DTKs2M2aXGQSX3J1fn+UXjnwkVAG2vq463SdAmsobDjWhbik3NcSwRyLZcjT5IYEBZ1EN8Gskag1oZ9o8CkGPGCkQ3kdQx2q+pihnAPxaX0ryi6dOQKJB3bpphxWHmlx18yFKCeI7oR5D92t4qj8dk/C452a4V+ODCbJNmrKETh+QzVTsMzsaOlWFvE7onQx1fuSWiMvw6rIoYi+/61UzdwujrNT8CWObfQ0C5DmCwCWZTNnu/i48Azte2maifoItBZ0xMfvYAZ9xicUnQqqdXIYRuiB8biRM3ME5P9dagFh23yiOOZbEEuMkK1is6w+qUHp1urYjPxs7e54TgNqouYmU3ev7Afcqla83gcH+vcDoZQOt3mVLgp+AGLjBh0OMNhqtKNGvhP2MvGUU5yaEPpr+0qLdt3shOiiKLPv1TiYtgYApjA7ShG1ZIypwNxcTFsxWpE/bUhienR+PbyWHNWhWb0vTnQ9DVPJ5z/RHqk7Fqi16bOTqITtFNmTluUZHaDSh2gZlLXGf7zdRwjkKrUus+tKJhhXtqv9wZvanS36hAQrvzQkfh+lzZzvJVJlYVd7rRBKn7dD+GFAJrqeTQZnal3HQgLRG47vQCecZQrd7rPx29Fha0mnDaf4QPOT6pcQZpjgYcG6MLiwJ05opleIvqK0FRkx5ZDjH2nvFBVNKlkpYONQnbAz4T1+S0ynR/jkU7S98AtK1O35UEZ2nxGPZmheNqdlMGg9KYz7aL1evvgBkOgkjsApUk5ycdayST+pm7zsI4G8J7Iw7MT6FcBGCrLvLYMgMSIqXRHFgwwnjwTOqFnVCM6dDPhV1EcIDXjqn2sIq+Ucy1zSOTGScndxRVgcGZXixEP3by59MO
 o3GY/mPy
 lMtdqRbvLcYYy0dHt0+YAQ2Rw4a6P+hVkTtJYj8aDRYxHzmqEpedF/OXnBCRURIUlbDVXjx+N6yT498olFIQZzolsBc5zd8xwEyUj1L5rogQm4fe9zqiTcTkPMxQz2Ko0/cPi9sG0LNWVFGK6QX2Y6KGfqeP0yRHIxbVb71EeSKz9cHAKLROa9X2Co8ysxb+01Cno4eFqcNsxMoXXW1769ACAtDuAQGmyfcZrJJ9hKie1YutuF/B2qv84EhubMPnQqvn+bzOwiBKjSl456Him3AgFue8CR00voiEppdFia4lLa5AgwQj/iAhhzRYPGkITkO4BHAnirsOfqzAPiw5vq8Az3irVJcqnx94eAGzZ3MXVjPC32UvxhVUgnkVfbhP53vDm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> Fully zswap-backed ranges are safe to load as a large folio only when
> the caller has a reason to expect the neighbouring slots to be useful.
> Otherwise a sparse refault can turn one 4K demand fault into a 64K
> decompression and swapcache fill.
>
> Add a common admission gate for zswap-backed large swapin. The common
> layer keeps backend checks, the 64K cap, recent-refault rejection, and
> zswap reclaim-pressure rejection. It consumes a caller-provided locality
> order mask instead of looking at anon or shmem state directly.

Can you add more documentation about these policies, both in patch
changelog and in code? I'm pretty confused by the
zswap_pool_reclaim_pressure heuristics, for e.g

>
> Callers pass no locality evidence for now, so this patch only installs
> the common policy hook. Later patches add anon and shmem producers.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/memory.c     |   2 +-
>  mm/shmem.c      |   2 +-
>  mm/swap.h       |   8 ++--
>  mm/swap_state.c | 118 ++++++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 117 insertions(+), 13 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index d73a19692dea..92a82008d583 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4849,7 +4849,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE=
,
>                                             thp_swapin_suitable_orders(vm=
f) | BIT(0),
> -                                           vmf, NULL, 0);
> +                                           0, vmf, NULL, 0);
>                 else
>                         folio =3D swapin_readahead(entry, GFP_HIGHUSER_MO=
VABLE, vmf);
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 56c23a7b15c7..fa99b48ed62b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2031,7 +2031,7 @@ static struct folio *shmem_swap_alloc_folio(struct =
inode *inode,
>
>  again:
>         mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
> -       folio =3D swapin_sync(entry, gfp, BIT(order), vmf, mpol, ilx);
> +       folio =3D swapin_sync(entry, gfp, BIT(order), 0, vmf, mpol, ilx);
>         mpol_cond_put(mpol);
>
>         if (!IS_ERR(folio))
> diff --git a/mm/swap.h b/mm/swap.h
> index ea7e1f3c4410..dd35a310d06d 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -323,9 +323,10 @@ struct folio *read_swap_cache_async(swp_entry_t entr=
y, gfp_t gfp_mask,
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>                 struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> -               struct vm_fault *vmf);
> +                       struct vm_fault *vmf);
>  struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long o=
rders,
> -                          struct vm_fault *vmf, struct mempolicy *mpol, =
pgoff_t ilx);
> +                         unsigned long locality_orders, struct vm_fault =
*vmf,
> +                         struct mempolicy *mpol, pgoff_t ilx);
>  void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
>                            unsigned long addr);
>
> @@ -418,7 +419,8 @@ static inline struct folio *swapin_readahead(swp_entr=
y_t swp, gfp_t gfp_mask,
>
>  static inline struct folio *swapin_sync(
>         swp_entry_t entry, gfp_t flag, unsigned long orders,
> -       struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
> +       unsigned long locality_orders, struct vm_fault *vmf,
> +       struct mempolicy *mpol, pgoff_t ilx)
>  {
>         return NULL;
>  }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index f03ad4832f16..5a4ca289009a 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -21,6 +21,7 @@
>  #include <linux/migrate.h>
>  #include <linux/vmalloc.h>
>  #include <linux/huge_mm.h>
> +#include <linux/sizes.h>
>  #include <linux/zswap.h>
>  #include <linux/shmem_fs.h>
>  #include "internal.h"
> @@ -556,6 +557,24 @@ static struct folio *swap_cache_alloc_speculative_fo=
lio(swp_entry_t targ_entry,
>                                         mpol, ilx, true);
>  }
>
> +/*
> + * Initial conservative cap for speculative zswap large swapin. Locality
> + * evidence is supplied by the caller or by generic VMA hints; the commo=
n
> + * swapin layer keeps backend safety and pressure decisions here.
> + */
> +#define SWAPIN_ZSWAP_MAX_SIZE                  SZ_64K
> +#if PAGE_SIZE < SWAPIN_ZSWAP_MAX_SIZE
> +#define SWAPIN_ZSWAP_MAX_ORDER                 \
> +       ilog2(SWAPIN_ZSWAP_MAX_SIZE / PAGE_SIZE)
> +#else
> +#define SWAPIN_ZSWAP_MAX_ORDER                 0
> +#endif
> +
> +struct zswap_admit_ctx {
> +       bool pressure_checked;
> +       bool reclaim_pressure;
> +};
> +
>  static bool swapin_zeromap_same(swp_entry_t entry, unsigned int nr_pages=
)
>  {
>         unsigned int ci_start =3D swp_cluster_offset(entry);
> @@ -586,11 +605,84 @@ static bool swapin_zeromap_same(swp_entry_t entry, =
unsigned int nr_pages)
>         return true;
>  }
>
> +static bool swapin_zswap_locality(struct vm_fault *vmf, unsigned int ord=
er,
> +                                 unsigned long locality_orders)
> +{
> +       struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
> +
> +       if (!order || order > MAX_PAGE_ORDER)
> +               return false;
> +
> +       if (vma && (vma->vm_flags & VM_RAND_READ))
> +               return false;

what about VM_SEQ_READ?

> +
> +       return locality_orders & BIT(order);
> +}
> +
> +static bool swapin_zswap_refaulted(swp_entry_t entry, unsigned int nr_pa=
ges)

nit: this does not seem zswap-specific. Just call it
swapin_range_refaulted or sth like that, maybe?

> +{
> +       unsigned int type =3D swp_type(entry);
> +       pgoff_t offset =3D swp_offset(entry);
> +       unsigned int i;
> +
> +       for (i =3D 0; i < nr_pages; i++) {
> +               bool workingset;
> +               void *shadow;
> +
> +               shadow =3D swap_cache_get_shadow(swp_entry(type, offset +=
 i));

This seems inefficient. Can't we just lock the swap cluster once,
check all the shadow in the range, instead of repeatedly getting then
dropping the swap cluster lock?

> +               if (!shadow)
> +                       continue;
> +               if (workingset_test_recent(shadow, false, &workingset, fa=
lse) &&
> +                   workingset)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +
> +static bool swapin_zswap_admit(swp_entry_t entry,
> +                              unsigned int order, unsigned int nr_pages,
> +                              struct vm_fault *vmf,
> +                              unsigned long locality_orders,
> +                              struct zswap_admit_ctx *ctx)
> +{
> +       if (order > SWAPIN_ZSWAP_MAX_ORDER)
> +               return false;
> +
> +       /*
> +        * Treat zswap-backed large swapin as speculative. The common lay=
er
> +        * consumes caller-provided locality orders, but does not inspect
> +        * anon-specific PTE state or shmem-specific mapping state direct=
ly.
> +        */
> +       if (!swapin_zswap_locality(vmf, order, locality_orders))
> +               return false;
> +
> +       /*
> +        * A recent workingset refault shadow in the target range means r=
eclaim
> +        * already saw churn there. Keep the refault path narrow instead =
of
> +        * speculatively decompressing neighbouring slots.
> +        */
> +       if (swapin_zswap_refaulted(entry, nr_pages))
> +               return false;

Hmm this depends. If it's just a refault coming from a speculative
read (readhead or THP (z)swpin), which is then promptly discarded,
then yeah we should backoff here. But maybe the refaulted page is
workingset one?

But yeah I guess it is better to be cautious when you are uncertain :)


> +
> +       if (!ctx->pressure_checked) {
> +               ctx->reclaim_pressure =3D zswap_pool_reclaim_pressure();
> +               ctx->pressure_checked =3D true;
> +       }

Why do we backoff if there is zswap_pool_reclaim_pressure (which only
check if the pool is full ONCE in its lifetime)? What's the rationale
here?

> +       if (ctx->reclaim_pressure)
> +               return false;
> +
> +       return true;
> +}
> +
>  static unsigned long swapin_admit_orders(swp_entry_t entry,
> -                                        unsigned long orders)
> +                                        unsigned long orders,
> +                                        struct vm_fault *vmf,
> +                                        unsigned long locality_orders)
>  {
>         unsigned long candidates =3D orders & ~BIT(0);
>         unsigned long admitted =3D orders & BIT(0);
> +       struct zswap_admit_ctx zswap_ctx =3D {};
>         int order;
>
>         if (!candidates)
> @@ -616,9 +708,14 @@ static unsigned long swapin_admit_orders(swp_entry_t=
 entry,
>
>                 state =3D zswap_probe_range(range_entry, nr_pages);
>                 switch (state) {
> +               case ZSWAP_RANGE_ALL_ZSWAP:
> +                       admit =3D swapin_zswap_admit(range_entry, order,
> +                                                  nr_pages, vmf,
> +                                                  locality_orders,
> +                                                  &zswap_ctx);
> +                       break;
>                 case ZSWAP_RANGE_MIXED:
>                         break;
> -               case ZSWAP_RANGE_ALL_ZSWAP:
>                 case ZSWAP_RANGE_NEVER_ENABLED:
>                 case ZSWAP_RANGE_NO_ZSWAP:
>                         admit =3D true;
> @@ -769,8 +866,8 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>         ret =3D swap_read_folio(folio, plug);
>         /*
>          * Swap readahead allocates order-0 folios. -EAGAIN is reserved f=
or
> -        * retryable large zswap backend races and must be handled by the
> -        * synchronous common swapin path.
> +        * retryable large zswap backend races and should never escape to=
 this
> +        * order-0 path.
>          */
>         VM_WARN_ON_ONCE(ret =3D=3D -EAGAIN);
>         if (readahead) {
> @@ -786,6 +883,7 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>   * @entry: swap entry indicating the target slot
>   * @gfp: memory allocation flags
>   * @orders: allocation orders
> + * @locality_orders: orders with caller-provided locality evidence
>   * @vmf: fault information
>   * @mpol: NUMA memory allocation policy to be applied
>   * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> @@ -794,16 +892,20 @@ static struct folio *swap_cache_read_folio(swp_entr=
y_t entry, gfp_t gfp,
>   * existing folio in the swap cache for @entry. This initiates the IO, t=
oo,
>   * if needed. @entry is rounded down if @orders allow large allocation.
>   *
> - * Context: Caller must ensure @entry is valid and pin the swap device w=
ith refcount.
> + * Context: Caller must ensure @entry is valid and pin the swap device w=
ith
> + * refcount.
>   * Return: Returns the folio on success, error code if failed.
>   */
> -struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long or=
ders,
> -                          struct vm_fault *vmf, struct mempolicy *mpol, =
pgoff_t ilx)
> +struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp,
> +                         unsigned long orders,
> +                         unsigned long locality_orders,
> +                         struct vm_fault *vmf, struct mempolicy *mpol,
> +                         pgoff_t ilx)
>  {
>         struct folio *folio;
>         int ret;
>
> -       orders =3D swapin_admit_orders(entry, orders);
> +       orders =3D swapin_admit_orders(entry, orders, vmf, locality_order=
s);
>  again:
>         do {
>                 folio =3D swap_cache_get_folio(entry);
> --
> 2.34.1
>

