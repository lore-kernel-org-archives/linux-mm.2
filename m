Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140DCC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190306B0092; Fri,  4 Sep 2026 11:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142396B0095; Fri,  4 Sep 2026 11:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0300C6B0096; Fri,  4 Sep 2026 11:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D01546B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:39:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D32214018E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:39:00 +0000 (UTC)
X-FDA: 85176488040.25.214E3C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77717180007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:38:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ld8uObJq;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788536338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+ywn+iFJBI4u5VtxY8RaiWWlMhCJYYHLJoR+W3cfUA=;
	b=zucmReCFWnvRYL1qcMp1/ekATedWaturXwqLxNIK1yjDDYaHidWwFp9VXv1HoIsUmgMeV3
	zDZkCnhGpI97ArDJ5FTY+xEp8rMD4ORqPMFhUX4OsF1n0vRA+SNlnokAswp0RXO9BSdfuz
	gKG8hM4BjJ0XiOWuICkFnp8gM8QLgbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788536338;
	b=VC1HXZ6HlgM6XO1O3ndZ+baRVg728Ra2gIQw0aribAQJdMvZKnE+Vw2yqowT1/Vn3zwm11
	qLfwb3IlAB8+6Oke0TehJvq+od4erMFv8fTS7wy3xqRKq4/Q77yPppXTcPRocQHnV4lqTe
	EdQVQzO0/E0tX6Lab8ZuF2xKQtaWMyI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ld8uObJq;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05C7B6020A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BC61F00ACA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788536337;
	bh=6+ywn+iFJBI4u5VtxY8RaiWWlMhCJYYHLJoR+W3cfUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ld8uObJqyTgaolkmEQNwBGwdwhdqeAxH+dsgV49h07FxLg01nJJSLJLjrI+WkKhI6
	 QWJGaalPQv27t7Pl0pgCAQT05tm0w5q8WZqr7yhcXfVFZL9V1leujEEXRhBDGW9Hxy
	 vWQR7/ZCvqoxlca06/NKkDHqKWuKx4LpBxiIc4veH5/Ykmy6u7fuBEe4s0YJpS3DlC
	 2PGy82XS8lTPh3FQkvst/gtanhigCPGGXYTtuC4k7efm82wbf7gckanT/sH/eC/d7q
	 GNV2od4f/76WDOJN+D+w40GifXTYtxY32C2kCIl/HZHbPAqibfrfkoDxU6Ekv/8G8O
	 tcdJeUS52jVKw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c247f6687dcso187533566b.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:38:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9IJ+22iWRIiAdWV3WskhnYsph5/MsvEsGcEOUT0HoTaUyHivctD7EP3zqnQmTKtcuXyaF/Hc9Qg==@kvack.org
X-Gm-Message-State: AFuF++nCSf9M3e1isYVRjiEUHweFCauVgDaUps+Q/63mJUthqKW94739
	slicCCmUb4t42rjW0btOBBd3DM2bcAuZGC0UrTm5Dwe1OI7LKADmjNTVY1Tgj68W54lnhLkfWZ/
	ATPn1k8S6eeK6i4hLnDr2b2+7pUehP+o=
X-Received: by 2002:a17:906:730e:b0:c26:1648:a060 with SMTP id
 a640c23a62f3a-c261648b673mr184938466b.27.1788536336575; Fri, 04 Sep 2026
 08:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
 <5c4f72f1ffbd5f15d0b57fb1a87f73b4249ab424.1788528216.git.wujianyue000@gmail.com>
In-Reply-To: <5c4f72f1ffbd5f15d0b57fb1a87f73b4249ab424.1788528216.git.wujianyue000@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 4 Sep 2026 08:38:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP7LCRaq4e0O_gPz61d+ee6Pt=tBZXQRy4X27idB228rw@mail.gmail.com>
X-Gm-Features: AcwNN1Uq-xb74ABY9zw0rMtVudm20ky-JyPbJrRRmi6zN4PCGk90egkvsX4nMXI
Message-ID: <CAO9r8zP7LCRaq4e0O_gPz61d+ee6Pt=tBZXQRy4X27idB228rw@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] mm/zswap: reference the pool by id to shrink
 struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 77717180007
X-Stat-Signature: aaus9bwkmg3r68617mihf4yb9r3j93pe
X-HE-Tag: 1788536338-961808
X-HE-Meta: U2FsdGVkX1894tcCoxmAU+MQI/suDvdN+pA/sKLx/heAG/7t4Lr59uHZFPLi6CH7jLJdwvqTD8doYSx1B+1yc7N9GAAbW+m2WtBhuxoeOir4VlTc4x96K5WWfi1ETxQ83e0K4EURedAk48cMBvTc9Veh/hQbDyECK+bQUlfFRS6BGyeu6dR5WTWjjywMheXHo95N8Y4+0N2HJkcbCKRh+yjNYENjGd+6kZQQ/8JYCiIq9d2xJkepHTYcqn/wqkWcC1XtNpRM69rvrWM3NFW/kpc3iClDZT/fpNkCBP9bypPfbkUtDaOrvZW8jiT0AOyCs99N5pIbmyJZFNnQscFs11vYO04lFEva/0A1nwVF5mmeBNv/0qMJo2qe3pFzMYc03+7KKfrEEifgwd7ZWMUwtGYQbKv4VGIYgimh861E0QfT/o4yXORymN0J24AWEJPXoXWZ+1j1KcwFJZiKvZu3GgO2+sOKPPTpIGgLTBgmhOEAh2ykB845AMZNgVN/9nQUciVlSZYhkqchOt6ToxnPNazg1euW0RfSvwDCIt7fe85wotyR2TZYz13YpUcI59Nqvja9EP01kUV80sChAKusFO6J0WPHQeHEwdYWBEXGX5jr4C3XJ2JoKdOIHvuEignXsdT07H4JtWFrNeqT8HECkmvB7N4VhTcpS9CrhXscarIU291kozCkxp90GRtK07a8ykeJ4Q2RZ4Jfyhn4fNnhzgpqGCntgPg/TNZAG9fuiqNqFY5bc0gGRFO8OWNB/hOm8F8dc2fByPFfPJTO8uiL46rerZLze3b9ZgXfc5xMFn8RBiDfd2hUEJ/6F94SYSh/LTIliNELJRBH8h/C8ZvZ+tEl3hDAfC74yk9w3Og9QPmliJeVBFleLebo9Fk8aeyHnL6dW0hGXSxbt0zlPUcwTOU/rZyV2XQJm6cnbax4lf0FZeS6C4nPoLmiDYd1NHZ3dRqLlNnk1d65GDXelwt
 s67mou4P
 GYBkDTmup24zFYm/qsHQ1BwDH49fPZDSSN4LJVO4nHg1MSCh2Yn2tVeecHaqOTHvpY33FttqUDjV5OVx+UkVq/vj2AFnI7fm0b+YnNLLRNEiFnRtdVBP/auntLtk6tZeOhEHHdK/2DNEOc2524Jl5Ru2JzNBCNPwpPIsBu2qwu96A33yHmGv7BQXv2kKIBuxON658Jd30wk6y1dO+x2b3ySh+dm7E6iYirVV5zHfYMALo/CRZ5FrZvGR7643JOmiekNdbpBWQfJvjaojd7/RGaxRwokFdjybUaLrDnkERxrgLzxR/yWPFND7WvZ25Bx8kiwA3+NkMrGoc3SjPIOc8FnFqd8sl4xzCWTkG9XUoGyKyEgb+qY0/xT05QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 6:25=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com> =
wrote:
>
> struct zswap_entry is one allocation per stored page, so its size is
> pure overhead. It currently embeds an 8-byte pool pointer, even though
> the live pools now sit in an allocating xarray keyed by a small integer
> id that fits in a u8.
>
> Replace the per-entry pool pointer with that u8 id and resolve it
> through the xarray with xa_load(). A live entry holds a reference to its
> pool, so the id cannot be reused under it; xa_load() is lockless and
> only needs an rcu_read_lock() section, no zswap_pools_lock. A live entry
> never uses the reserved id 0, so looking up that id resolves to NULL
> and trips a WARN rather than aliasing a live pool.
>
> The u8 fits in the padding after the bool referenced field, shrinking
> the entry from 56 to 48 bytes on 64-bit. This raises objs_per_slab from
> 73 to 85 and saves about 2MiB of metadata per 1GiB of data held in
> zswap.
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 38 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 74876acfa9dc..31cf0ef43d23 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -195,7 +195,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writ=
eback
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
> - * pool - the zswap_pool the entry's data is in
> + * pool_idx - id of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> @@ -204,12 +204,27 @@ struct zswap_entry {
>         swp_entry_t swpentry;
>         unsigned int length;
>         bool referenced;
> -       struct zswap_pool *pool;
> +       u8 pool_idx;
>         unsigned long handle;
>         struct obj_cgroup *objcg;
>         struct list_head lru;
>  };
>
> +/*
> + * The pool stays alive after this returns because a stored entry holds =
a
> + * reference to its pool (taken in zswap_store_page()).
> + */
> +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> +{
> +       struct zswap_pool *pool;
> +
> +       rcu_read_lock();
> +       pool =3D xa_load(&zswap_pools, entry->pool_idx);
> +       rcu_read_unlock();

Doesn't xa_load() already call rcu_read_[un]lock()?

> +
> +       return pool;
> +}
> +
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>
> @@ -770,9 +785,13 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>   */
>  static void zswap_entry_free(struct zswap_entry *entry)
>  {
> +       struct zswap_pool *pool =3D zswap_entry_pool(entry);
> +
>         zswap_lru_del(entry);
> -       zs_free(entry->pool->zs_pool, entry->handle);
> -       zswap_pool_put(entry->pool);
> +       if (!WARN_ON_ONCE(!pool)) {
> +               zs_free(pool->zs_pool, entry->handle);
> +               zswap_pool_put(pool);
> +       }
>         if (entry->objcg) {
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>                 obj_cgroup_put(entry->objcg);
> @@ -929,12 +948,15 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
>  {
> -       struct zswap_pool *pool =3D entry->pool;
> +       struct zswap_pool *pool =3D zswap_entry_pool(entry);
>         struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 e=
ntries */
>         struct scatterlist output;
>         struct crypto_acomp_ctx *acomp_ctx;
>         int ret =3D 0, dlen;
>
> +       if (WARN_ON_ONCE(!pool))
> +               return false;
> +
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
>         zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->=
length);
> @@ -970,7 +992,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>         pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %=
u->%d)\n",
>                                                 swp_type(entry->swpentry)=
,
>                                                 swp_offset(entry->swpentr=
y),
> -                                               entry->pool->tfm_name,
> +                                               pool->tfm_name,
>                                                 entry->length, dlen);
>         return false;
>  }
> @@ -1428,6 +1450,16 @@ static bool zswap_store_page(struct page *page,
>         if (!zswap_compress(page, entry, pool))
>                 goto compress_failed;
>
> +       /*
> +        * Set pool_idx before publishing the entry: compression has
> +        * succeeded and the pool is already pinned by this store, so the=
 id is
> +        * final.  Doing it here (rather than after xa_store()) means the=
 entry
> +        * is never briefly visible with a stale pool_idx left over from =
slab
> +        * reuse, which zswap_entry_pool() would otherwise resolve to an
> +        * unrelated live pool.
> +        */
> +       entry->pool_idx =3D pool->idx;
> +
>         old =3D xa_store(swap_zswap_tree(page_swpentry),
>                        swp_offset(page_swpentry),
>                        entry, GFP_KERNEL);
> @@ -1473,7 +1505,6 @@ static bool zswap_store_page(struct page *page,
>          *    The publishing order matters to prevent writeback from seei=
ng
>          *    an incoherent entry.
>          */
> -       entry->pool =3D pool;
>         entry->swpentry =3D page_swpentry;
>         entry->objcg =3D objcg;
>         entry->referenced =3D true;
> --
> 2.43.0
>

