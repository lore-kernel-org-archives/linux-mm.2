Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BE7CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C516B00C8; Fri, 29 May 2026 14:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D5C6B00CF; Fri, 29 May 2026 14:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C6A6B00D0; Fri, 29 May 2026 14:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 635366B00C8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:25:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE2731C0DE8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:25:49 +0000 (UTC)
X-FDA: 84821286018.24.520C105
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id C4B252000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:25:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecEURisF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780079147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/7VoLmlkelTnjhAVM+WgpRo6OCkYvMP+6JN8/8y21k=;
	b=0Fj3dJD0/RE2yJsiMte4sxPQY9AxM0XXYrYZYXnDm7kbT/jsCkYogs51Giptsy+TohAmRP
	nkcBAGE4LJmwH+lrRBQPXbeK7+LYIQzNtm5C+a4Ru0HYrg/QAX1SQrIenkXjDf4r9zO+Hf
	YFQSSw2RqPqy3Q5sF1gX3Zhyju7gX9Y=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ecEURisF;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780079147; a=rsa-sha256;
	cv=pass;
	b=XEHiiiN3YYcACnW8kOvKAzfI6f6ZLa7lT/ZRebZtCWryRfgKT3/81BA90UbSvyHLV6JUIF
	ui2cG6MVeeKFT9BB96mNtbN1jNBvej3fC+Z9XtxHVYHD6JfHQpNXGnxd3yvtRGojXRrewD
	uBv0RwVWKxhMogW7Y+H9bCPQStQzj30=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so84742875e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780079146; cv=none;
        d=google.com; s=arc-20240605;
        b=bgDNBJIZjtHHs+3nM3oknhWMk5Or5Vsro7Y0RTPmV5N8lsAMMvA8KQklt1dhXCx1nv
         F6jpKSBw/nrcT3UzouZ+jQKf+Mq2/5GosLDUVPNkhn6IC7zQODRsSFbaxV16/NMrJVKP
         haujSAeLoleSTG8OsuarR9hRRQpKxiND8/jzWg0P8cr0hwL9JL5IOtRlIUit0SV684jC
         3CxWYFId+9NHm5TCVXWA4LpGoHmFC28y8oQdMrNezby9otQisSAZUGZg/HhLDVv84I8l
         fHqStbHEOMozvvA6posXe6dWH5Fm6Gb4ZyD3s9Kw2O5a0SGhPu26Ypr1zHsqe8D3hDp8
         PhBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n/7VoLmlkelTnjhAVM+WgpRo6OCkYvMP+6JN8/8y21k=;
        fh=1h+2o/ckBsiGpHfFKnAzaImliHkdoPNc4/HoBEN7ekE=;
        b=IbNA6XlqNrgC07muF2D2upTqUhnCr2DZrB4K69TIlEjXPr4Wk3c1ATf13yshislJkE
         RYaPO3QgEMYThlutkSolfWXZw+iWNABeEGJB28fZuvu19JpxLSoVqqXILhgz0QFs1wr9
         UDLkXrv5tYtLr54XRFOdRXGp7Y8TzHIG4FFLzctP8zbQOfKxRsYhbEbC7TTM7GwPVw7E
         GFKRKMtY53VcMlOZYBcVJBBPxxu7DHL6gb+Ad/gXAhiRpe33ljMk3ivZ4gnzkUltuG8f
         gnw13kBIHgQjIhrjo3hmNrAI11Q34SQV8Mv86T0d0m0Qb8v1jS251iJmccHm3qCq1xuu
         QEsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780079146; x=1780683946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/7VoLmlkelTnjhAVM+WgpRo6OCkYvMP+6JN8/8y21k=;
        b=ecEURisFQHcQfkqf8Dgd71LqlR4ZZCKMJHa3ArxsOSKwTGjDYFD5hqVZO6QPL/K0W/
         lgBGLCgOEiVUkohiYv7DZtzo3XBywzs4iGLpRcxzswNVRX32MpUjNC88QJXNepOIs5sF
         nnOp+VrmyIA70wPy0veXvoQkOOhTwR7YkjeJkp+cR4rw1D+JD3p1RlgYxXC/y8hK8Q+E
         vuw9K6f75ub5TMAUW4DUT2YmpLUhwgvpib+cCeLUhjVFz+dHf3scmOc+D07gahsTJCUr
         ANnxzNesgfCe/aVMrNQHUroz6uNlIukub5GHMVr1IHpuF6fNYlQi3v8tCPg6UQLJWJdB
         5akA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780079146; x=1780683946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n/7VoLmlkelTnjhAVM+WgpRo6OCkYvMP+6JN8/8y21k=;
        b=M6pxdWmXc5SZwa0ps8pdJMXQHAGTrDKVbNy4cSC+6sXLz+NR6j4kMjFqGEm09ebLP0
         HSFznnW75vgvXzrnfqkOo+/y6T/YqpdPiLPXDCaiuE1z6eOFMP6xGJSDgh21Flv+JCpM
         we1O4XVaKQxrJfo4bS4GHs3Eipjrb89rIuhxEOWFh1MBhyOsU5KkrtEMDle0o1MePQoD
         XAy4/vnDLyMHiJtwBkCcYhe2ZQkG3nQsNDR2zx16Ts0j4KPhbAUCqP9axo76GY4Xl1bY
         /11SqXsmmRTFjyCxq50v4EHFgqU3Zju2svkvw9gsXIRdR8+S5McWK/OJe2jCKGy3Rmw7
         PscA==
X-Forwarded-Encrypted: i=1; AFNElJ+2q/MB3GhPu+Qe4xqmfRTahtu+7wH0W4qmZuX3oTSb0LWf06r4cPYMKyf2ptwc/BizRzanLU4WdQ==@kvack.org
X-Gm-Message-State: AOJu0YyTuhRA4AHRKOhujKnSeh335PhRl8nC7L+6ccIQdSF60uR7teyV
	1mnvRkSTzDW84iq5J8HA+mBIyf+RaHbBXWoc9onPGd9E5XH68qog+jIi6c2DFv3fIjx9HGZiplE
	1RJT8UEIcRp9YalkyOmw88ROVr/BKyA0=
X-Gm-Gg: Acq92OEOjkCj+kGn+IefEETWLb3GfIa63bwLtLdAoRmwDXxntSYIRHZ6puR1jT63Nsc
	ggqWL7jb7zS5J/UP1gUh3XvwCZuytaVzTgzzRJhbm/0KjTcN63YFOdaHsonX4RzgY5DHrtdblzX
	uR5+E7iwgWvvn/eVJ2D8wIkTrIUaVwZMfPnXViBsNgvdxg2QxCXAl+xg/rD+dj9x7vmaratEzUI
	6arq1hFYEQVbWmCHlvf8pOK9ecdG1vn1J+0UKaHRfGchSPAFunL7Cb3eMMiWA1pj14306UtEJl1
	tsvoZV8PGk+I1BYRXYbHuQAD6EL2uzt5U9Xfcw3u1fvQGVtn9A==
X-Received: by 2002:a05:600c:c092:b0:489:1ba8:5bf0 with SMTP id
 5b1f17b1804b1-490a2959113mr10743195e9.21.1780079145975; Fri, 29 May 2026
 11:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com> <tencent_7D186EDC2C9AB9009F9915C1E68F3CF44609@qq.com>
In-Reply-To: <tencent_7D186EDC2C9AB9009F9915C1E68F3CF44609@qq.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 11:25:34 -0700
X-Gm-Features: AVHnY4Kp-sEPE-FFUF6bBOJrz20u3PpASZs17QhUX4WKimDdvMA9ZEAzM1igyBk
Message-ID: <CAKEwX=Or6forBoArv1b=MZuhOuF+MTuLLZWPKgUmkBVaoBoYSQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/9] mm/zswap: support fully zswap-backed large
 folio loads
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
X-Stat-Signature: unsj7ia8hae9rmhy1wncw6u481fsc3e6
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4B252000C
X-Rspam-User: 
X-HE-Tag: 1780079147-354638
X-HE-Meta: U2FsdGVkX18XIPBt53dp0d9sQSYFJ+l1firt9TItlzXhVGkGZVMr3vC49UR1/CHew7iuRgcZAuQPKHqGq8FPRLWgj7xSmONJjXtl8fFNFKLLKTV95mgNQdIT9d7a8txaEJvzY50YYXnTeYx+YhJwXgD+hQnMjiuDSPcFsxhmVmZ7WiV9rb02N4TVVOok4UBYQT417Q56ukgEV8AfRwIRB8XzKNYZKYptJq+ZXKy6jFopkubdN6ZG7pt31q3zd5/L19ExSFdT50EBj1rEp8OzTyh+HkHHA0ftG31L1pWjxrUtzUeXVZdk9dbDatw8YZ2uBd7I7PlaQTvpTXFhz8CcUmopDrfBXlRTgP56+aprs2wEYOh4CckvtKyNXM/W/+BhLhbUBZDmjwhkra1JuiQLzNZxPPAye1uuCiyeCU2+20u2d6cLrEC7Z+5+BGQmKs10V4XEealGeC5rKVsXNuJxQoeaWxBS9rRWYmDpswTS8JPCGvabVzMyyHQsADbQExzUR4IKiFck8XOjuiRkwfyCOQci4R5ZrK1UeMzCeY74kprOUHPo3siT8VY612zEFh/kH6cF1FfCicEj0ljps7dTEh13P6rwAP4tEOJ2oKYqz3cwmfyO3+ieLy5QD672SzwOP1HNRxQ8sBDq+N/fYmD//tAVtEmgkyixR9ztNbQQS1pxdJZfKTouo0ouvKRPrjTOl/jtp6QWNi5NP7dYdwkL/5zhnkM411WqYc3TNJgv+tnKxBFu+q7RK4E3q0vIhmzGpxmZLm0090bzl/m3T+gdYFpkfaBsz8dAfegdp2JzuJZw4YUgVOgwi4s40+D1dgpbvYU4q9+lqg7pjUC3LYJ5qj0VVke0V2/sX+nEGCBdHSMtZml5HF4c58ne4zwWEn6/bmmTghijaQeecmXEy7c11unl9uwzR4vYlI7TMfbYlTB45Z0yjS86sXefoqXwSXtqwJ+75Xp/Dhi9dAJtydi
 RP3n8qae
 V+f3vmJkLmlrcO+q2rxUuC2UQQuPq9lJebb/YhvBfsXq2zWNoibQ9+G4BzDeNTynbDG1SAI2T5oDptgdFDmHtshe2vaFsN0ew0vnse53qhWM4vc3rjWG68pAAURcMeomvMfQ5wGfO80lTZGfjhqDkDdBIwadeiPy52xYxgOQfbtWIeWOAecLUxidyi3Lq+47VwUNGY56S46rYIjinp1ZVq8RFunLC2KfWsPZDqIzTZxN7c/XXwgrIF0vZheSnz7nu9KLARzHJArL6u7/PZjdNThJzJ88UPOwu5bwdSdSvdROChLNC4lLPajxJBVLQvmiHSBowS6nBWjrYrLReNzzDN/OFHGIxT451Tlto8NRPuHqDl0x7fiBYxMCWrBXGljF4z4GFquvqK001KPKmE8zgQza1RCDinrd8Y2VISgwMcYhEGk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 5:19=E2=80=AFAM fujunjie <fujunjie1@qq.com> wrote:
>
> zswap currently refuses large swapcache folios. That is correct for mixed
> backend ranges, but it also prevents the common swapin path from loading =
a
> range that is still fully backed by zswap.
>
> Teach zswap_load() to fill a locked large swapcache folio by decompressin=
g
> each base-page entry into the matching folio offset, then flushing the
> folio once. A missing entry after zswap data has been seen is reported as
> -EAGAIN so the caller can drop the speculative large folio and retry
> order-0.
>
> The large load keeps the zswap entries in place. It is a clean speculativ=
e
> fill: until the swap slots are freed, zswap remains the backing copy if
> reclaim drops the large folio before PTEs are installed.
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/zswap.c | 105 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 87 insertions(+), 18 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index da5297f7bd69..94ba112a2982 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -15,6 +15,8 @@
>
>  #include <linux/module.h>
>  #include <linux/cpu.h>
> +#include <linux/mm.h>
> +#include <linux/huge_mm.h>
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> @@ -934,7 +936,8 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>         return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
>  }
>
> -static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
> +static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio,
> +                            unsigned int page_idx, bool flush_dcache)
>  {
>         struct zswap_pool *pool =3D entry->pool;
>         struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 e=
ntries */
> @@ -952,14 +955,15 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>
>                 WARN_ON_ONCE(input->length !=3D PAGE_SIZE);
>
> -               dst =3D kmap_local_folio(folio, 0);
> +               dst =3D kmap_local_folio(folio, page_idx * PAGE_SIZE);
>                 memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
>                 dlen =3D PAGE_SIZE;
>                 kunmap_local(dst);
> -               flush_dcache_folio(folio);
> +               if (flush_dcache)
> +                       flush_dcache_folio(folio);
>         } else {
>                 sg_init_table(&output, 1);
> -               sg_set_folio(&output, folio, PAGE_SIZE, 0);
> +               sg_set_folio(&output, folio, PAGE_SIZE, page_idx * PAGE_S=
IZE);
>                 acomp_request_set_params(acomp_ctx->req, input, &output,
>                                          entry->length, PAGE_SIZE);
>                 ret =3D crypto_acomp_decompress(acomp_ctx->req);
> @@ -1042,7 +1046,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>                 goto out;
>         }
>
> -       if (!zswap_decompress(entry, folio)) {
> +       if (!zswap_decompress(entry, folio, 0, true)) {
>                 ret =3D -EIO;
>                 goto out;
>         }
> @@ -1615,10 +1619,9 @@ enum zswap_range_state zswap_probe_range(swp_entry=
_t swp,
>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_=
page()
>   *  will SIGBUS).
>   *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belon=
gs
> - *  to a large folio, which is not supported by zswap. The folio is unlo=
cked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EAGAIN: if the swapped out content belongs to a large folio, but th=
e
> + *  range is mixed or raced with writeback. The folio remains locked so =
the
> + *  caller can drop the large swapcache folio and retry order-0.
>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio rema=
ins
>   *  locked on return.
> @@ -1626,9 +1629,12 @@ enum zswap_range_state zswap_probe_range(swp_entry=
_t swp,
>  int zswap_load(struct folio *folio)
>  {
>         swp_entry_t swp =3D folio->swap;
> +       unsigned int nr_pages =3D folio_nr_pages(folio);
> +       unsigned int type =3D swp_type(swp);
>         pgoff_t offset =3D swp_offset(swp);
> -       struct xarray *tree =3D swap_zswap_tree(swp);
> +       struct xarray *tree;
>         struct zswap_entry *entry;
> +       unsigned int i;
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1636,21 +1642,84 @@ int zswap_load(struct folio *folio)
>         if (zswap_never_enabled())
>                 return -ENOENT;
>
> -       /*
> -        * Large folios should not be swapped in while zswap is being use=
d, as
> -        * they are not properly handled. Zswap does not properly load la=
rge
> -        * folios, and a large folio may only be partially in zswap.
> -        */
> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
> +       if (folio_test_large(folio)) {
> +               struct obj_cgroup *first_objcg =3D NULL;
> +               bool same_objcg =3D true;
> +               bool saw_zswap =3D false;
> +               bool saw_non_zswap =3D false;
> +
> +               /*
> +                * The locked large swapcache folio now covers the range =
and
> +                * conflicts with zswap writeback's order-0 swapcache all=
ocation.
> +                * If the range is mixed or an entry disappears, retry or=
der-0.
> +                */
> +               for (i =3D 0; i < nr_pages; i++) {
> +                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 i));
> +                       entry =3D xa_load(tree, offset + i);
> +                       if (!entry) {
> +                               if (saw_zswap)
> +                                       return -EAGAIN;
> +                               saw_non_zswap =3D true;
> +                               continue;
> +                       }

Can we use xas_load API here instead of traversing down the tree again
and again?

> +                       if (saw_non_zswap)
> +                               return -EAGAIN;
> +
> +                       if (!saw_zswap)
> +                               first_objcg =3D entry->objcg;
> +                       else if (entry->objcg !=3D first_objcg)
> +                               same_objcg =3D false;

Can we get different objcg at this point?

> +                       saw_zswap =3D true;
> +               }
> +               if (!saw_zswap)
> +                       return -ENOENT;
> +
> +               for (i =3D 0; i < nr_pages; i++) {
> +                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 i));
> +                       entry =3D xa_load(tree, offset + i);
> +                       if (!entry)
> +                               return -EAGAIN;
> +
> +                       if (!zswap_decompress(entry, folio, i, false)) {
> +                               folio_unlock(folio);
> +                               return -EIO;
> +                       }
> +               }
> +
> +               flush_dcache_folio(folio);
> +               /*
> +                * Keep zswap entries until swap slots are freed. This is=
 a clean
> +                * speculative fill; zswap remains the backing copy if re=
claim
> +                * drops the large folio before PTEs are installed.
> +                */
> +               folio_mark_uptodate(folio);
> +               count_vm_events(ZSWPIN, nr_pages);
> +               count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
> +
> +               if (same_objcg) {
> +                       if (first_objcg)
> +                               count_objcg_events(first_objcg, ZSWPIN, n=
r_pages);
> +               } else {
> +                       for (i =3D 0; i < nr_pages; i++) {
> +                               tree =3D swap_zswap_tree(swp_entry(type, =
offset + i));
> +                               entry =3D xa_load(tree, offset + i);
> +                               if (WARN_ON_ONCE(!entry))
> +                                       continue;
> +                               if (entry->objcg)
> +                                       count_objcg_events(entry->objcg, =
ZSWPIN, 1);

xas_load() here too?


> +                       }
> +               }
> +
>                 folio_unlock(folio);
> -               return -EINVAL;
> +               return 0;
>         }

>
> +       tree =3D swap_zswap_tree(swp);
>         entry =3D xa_load(tree, offset);
>         if (!entry)
>                 return -ENOENT;
>
> -       if (!zswap_decompress(entry, folio)) {
> +       if (!zswap_decompress(entry, folio, 0, true)) {
>                 folio_unlock(folio);
>                 return -EIO;
>         }

I wonder how much of these two paths (order 0 and larger order) can be
unified...

> --
> 2.34.1
>

