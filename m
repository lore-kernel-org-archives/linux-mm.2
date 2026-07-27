Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D641C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB076B009F; Mon, 27 Jul 2026 12:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197C66B00A0; Mon, 27 Jul 2026 12:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BD66B00A1; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C40446B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:33:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A2A412011D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:27 +0000 (UTC)
X-FDA: 85035102054.07.11DB5C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53F93160011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T9s//DML";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170005;
	b=zfHOg7Axnjv4O5wmcga+CrLPYQRXkdnaIFJnJI8C2RFUYCORKskAdvx+UPeiA14wsPRTcX
	xnvtbubi92EhV+L9j1da8fT3JMci3GUAl1pYJRkwjn7TBT1abiaCNGv+OMhMSygZhA/bdB
	jBTJvtY7TWExXHmMmMH/A4k+A+FcVJQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T9s//DML";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZM6fxFyd8dCb6BJMoQKO+aSWu6p8LaWIuEEO6Zj0vro=;
	b=jHlLpCZSKIMLlXwHre2wH/kQBmFBZfvMkS0ip7iIFRoYLjOrR86VjbPjwomcIPOtbxoW/2
	0sBKFjiC5ypzFW13Fpgk6uUQ7F/+5josbEoVyMZG1wCLEHQnAUEchLs/Lbj57uHpm2MNi1
	/fdjz2aNuvCsPALzi6Yhc7ks8hgJD5g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA48460A59
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825F51F00A3E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785170004;
	bh=ZM6fxFyd8dCb6BJMoQKO+aSWu6p8LaWIuEEO6Zj0vro=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=T9s//DML9pfG5FX5Se3JZLoeaPVRrohMBYlGpy3wRtO1c5fe73QR6u8Y2NCl/bD3K
	 /RYA9h+1Uwpk3w2ItuiKUG+69J0qAsJ6lXpPljAzQuvkhs+rXmtul82hNoi3y2EmRd
	 oiOUMUHH4rfr6B0JPa8V/sgKG2tepy2hK94HNERbYdpsL+1FIIPOl2G5HLk/6V6Ma6
	 HWHvsGRys0NSYDcSV+x3klM6f2m5f/2AZgTh1Cp/1mcf2aNCfU8obdK0ShdKM7ZeeS
	 QuoZXj5G6UPi915UmYH891eH1pRLHzH5bfw0Da6Rf4fy4uhvX1M9iaTVIKbl3L6d26
	 lKmloU7ky84jg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c197eaaab00so456520566b.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:33:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqbNGlcf0aZyxUd/O8oMw/0M6y1Ud/5yyln9x2jEDtw5JYMAU3F7b81cNXyNSa3rochC3DfDx67/w==@kvack.org
X-Gm-Message-State: AOJu0YwMksjHlfDQMNWkZPsxVVST2afDmk6BlfS1lYOkq73+XQxv+W1X
	gKjL5g4eHHOk5ZcyMOeD0HSX3SkYaN5nKn4uRcPM+JhnBHg/yNYo/MqThCkwsJwIWhjRTOYLOBf
	HY/KVnOhoAyVYo32VPoWhbOzLVddYPBI=
X-Received: by 2002:a17:906:f5a2:b0:c16:7097:4708 with SMTP id
 a640c23a62f3a-c1f1ed4791emr422071166b.3.1785170003408; Mon, 27 Jul 2026
 09:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
In-Reply-To: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Jul 2026 09:33:11 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM=J+NkG+qJa430Nca40wEBSBJuo6E7f_-s3iHDP32BUQ@mail.gmail.com>
X-Gm-Features: AUfX_mzFSkU2OwLOPVMWx10WUzvXFTpk7yXqeSBQp2VWHhVf9bxDHBQVL1iTwis
Message-ID: <CAO9r8zM=J+NkG+qJa430Nca40wEBSBJuo6E7f_-s3iHDP32BUQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ejjn9ud7kuwo5gb9goubt5rur4i6g3y9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 53F93160011
X-Rspam-User: 
X-HE-Tag: 1785170005-280439
X-HE-Meta: U2FsdGVkX1+qaplY7dPqCtLt0GtMmWfjCkHgxYgCjKUN/CPibpxt6vksDETLKy+xS+Ez2dI6Y+EmgxcUNXfkrbAslUr3H6zoBNvCsA1TUeeoQJiLhYCAJYiuXoVYWIsKZSU3Iv8H9lk0WOLYaUaDUDFTz61ZI+V8lXSOdiUTdwOyXwSFgvRZD81cLZNGgdyABJyVVqxvwqFt2g2udva4n3LGcKNJWnPC7htsAfAZ1DrZtRVxR8pcjQS8zYDMMIpg6MeCJMJyHq/MkMAE2g5n35MF5hmIZpFFAROBtt4E+wkfanhz/gz3iOkbhH260xiuLXH/74pRCGBhemGSjDP31CAsku6T+Ez39/mjZuA5MI1m4Aa1xwQb8kw66VbC1i+5BvLLDNEinY7bjOFXuG8JxZfYp9E1rmTJSyysawxAs5qIqM5larW0EYFJgcTfMhUyVLW3aRAeYNwCo0A7MNBt8wc7mYdR3gQBF6hgYDGph/HC6JHEdQulZ06zvQDhWDU26+IWYnaeCC7deqIeMyAgBhYaWT0PM2Kkbki7oesGQtY3rlaONVP8xXxqENBb4RzM0V6U3qgkTvypQpVLarochsqbi4oQWFS3gKZ9uauguASBJJUXyApWcUwmkjBffWDDpcDN6iQafWwBdio4TQ+oxDWi8totlKKFsj8vqNm/10yvfdD67iQlja2WluIEUZtp6SrG30DQ3VXsMEptMiQWkLgbM/pFr6YbOrKjzms4WCCvV44/u+q5DWXD8dUShRUhGmy/tMcBeNQk/Q6lwFux8pQbp3KjwTHjA1/89ZH2oNZrZ8W6HfsW9077cRbSZe7dAgHeVo7hxeauK+0uBKFXaMhMEhUhjf5doL7pegheKq8+KDdJhmD2F0Z1Mh3NXfEpPNRWXnhJaLaBMU58SYUzo0klrLIqAhGaybPw1fDvP2eHWptzY8SVM9a65rUPaRtS5BpFbqI9jZUGHEv5KV5
 S1LoDSbQ
 vEV6zFX5MbXZxAP5MIp3x60Qv+yUVcFZyZ//4WG6vIebgMn4NPsJ1v5iiZUzA9vuAmorGBX6oECQ2kpNGO14/qhD/RdrXW0cdXtuj6vmrakkq1hV1UXWtQSXY/bNYSkS2A6ib1kFeXe4Rf6k4aiU6gZ8dz96eHmM+PsSs/HvaQZ5gYqD9f6y8EYOpg13M1j+qaziaCyZ2v4qcwSZz7p+v9LgkjLel08DUppCQNbm1aeXPsByH2C0JUrT8qBAdGKUtURdqVl/iW9bo87P4vnqfZZJss/aIkW9kNCV+CyjSDfUjNg4quuGFcdPkPe6m00DBqbN+6PGIJ41rJlMDxDV2tlFPJMQzYw5IA54v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 8:18=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> Every stored page has a struct zswap_entry, so its size is a per-page cos=
t
> that scales with how many pages zswap holds.  It currently embeds an
> 8-byte pool pointer.
>
> Replace the pointer with a u16 index into an allocating xarray of pools.
> The index is allocated with the pool and remains valid while entries hold
> references to that pool.

Technically we are introducing a new limit on the number of pools, so
let's mention that. I doubt anyone actually cares, you would need to
switch the compressor 65K times at runtime to run into a problem.

>
> On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per object,
> raising objs_per_slab from 73 to 85.  This saves about 2MiB of metadata
> per 1GiB of data held in zswap.

Nice :)

>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
> This RFC proposes replacing the per-entry zswap_pool pointer with a u16
> index into an allocating xarray of pools, so struct zswap_entry shrinks
> on 64-bit.
>
> I am looking for feedback on whether the metadata saving justifies the
> extra indirection on entry decompression and freeing.

Did you try to benchmark it? I doubt the indirection would actually
show up as most use cases should have a single pool. It would be
interesting if some use cases actively switch the compressor at
runtime enough for this to be a problem.

> ---
>  mm/zswap.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4e76a4a87cdc..6c29098da8d5 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -35,6 +35,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/workqueue.h>
>  #include <linux/list_lru.h>
> +#include <linux/xarray.h>
>  #include <linux/zsmalloc.h>
>
>  #include "swap.h"
> @@ -157,9 +158,22 @@ struct zswap_pool {
>         struct list_head list;
>         struct work_struct release_work;
>         struct hlist_node node;
> +       u16 idx;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>
> +/*
> + * Entries store a u16 pool index instead of an 8-byte pool pointer.
> + * Indices are allocated here at pool creation and released at destructi=
on.
> + * Live entries pin the pool, so its index is not reused under them.
> + */
> +static DEFINE_XARRAY_ALLOC(zswap_pools_xa);
> +
> +static struct zswap_pool *zswap_pool_by_index(u16 idx)
> +{
> +       return xa_load(&zswap_pools_xa, idx);
> +}
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>
> @@ -182,7 +196,7 @@ static struct shrinker *zswap_shrinker;
>   *              writeback logic. The entry is only reclaimed by the writ=
eback
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
> - * pool - the zswap_pool the entry's data is in
> + * pool_idx - zswap_pool index, resolved via zswap_pool_by_index().

No need to document the function name here, most probably will be
stale at some point.

>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> @@ -191,12 +205,20 @@ struct zswap_entry {
>         swp_entry_t swpentry;
>         unsigned int length;
>         bool referenced;
> -       struct zswap_pool *pool;
> +       u16 pool_idx;
>         unsigned long handle;
>         struct obj_cgroup *objcg;
>         struct list_head lru;
>  };
>
> +static struct zswap_pool *zswap_entry_pool(struct zswap_entry *entry)
> +{
> +       struct zswap_pool *pool =3D zswap_pool_by_index(entry->pool_idx);

This seems like the only user of zswap_pool_by_index(), just open-code
the xa_load() here.

> +       VM_WARN_ON_ONCE(!pool);
> +       return pool;
> +}
> +
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>
> @@ -275,6 +297,7 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>         struct zswap_pool *pool;
>         char name[38]; /* 'zswap' + 32 char (max) num + \0 */
>         int ret, cpu;
> +       u32 idx;
>
>         if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
>                 return NULL;
> @@ -322,10 +345,18 @@ static struct zswap_pool *zswap_pool_create(char *c=
ompressor)
>                 goto ref_fail;
>         INIT_LIST_HEAD(&pool->list);
>
> +       ret =3D xa_alloc(&zswap_pools_xa, &idx, pool, xa_limit_16b,
> +                      GFP_KERNEL);

I would let this poke out, 80 chars is not a hard limit.

> +       if (ret)
> +               goto idx_fail;
> +       pool->idx =3D idx;
> +
>         zswap_pool_debug("created", pool);
>
>         return pool;
>
> +idx_fail:
> +       percpu_ref_exit(&pool->ref);
>  ref_fail:
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
>
> @@ -366,6 +397,8 @@ static void zswap_pool_destroy(struct zswap_pool *poo=
l)
>
>         zswap_pool_debug("destroying", pool);
>
> +       xa_erase(&zswap_pools_xa, pool->idx);
> +
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
>
>         for_each_possible_cpu(cpu)
> @@ -764,9 +797,11 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>   */
>  static void zswap_entry_free(struct zswap_entry *entry)
>  {
> +       struct zswap_pool *pool =3D zswap_entry_pool(entry);
> +
>         zswap_lru_del(&zswap_list_lru, entry);
> -       zs_free(entry->pool->zs_pool, entry->handle);
> -       zswap_pool_put(entry->pool);
> +       zs_free(pool->zs_pool, entry->handle);
> +       zswap_pool_put(pool);

Let's add a NULL check here to avoid blowing up if something goes wrong.

>         if (entry->objcg) {
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>                 obj_cgroup_put(entry->objcg);
> @@ -923,7 +958,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
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

We need a NULL check here as well.

> @@ -964,7 +999,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
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
> @@ -1457,7 +1492,7 @@ static bool zswap_store_page(struct page *page,
>          *    The publishing order matters to prevent writeback from seei=
ng
>          *    an incoherent entry.
>          */
> -       entry->pool =3D pool;
> +       entry->pool_idx =3D pool->idx;
>         entry->swpentry =3D page_swpentry;
>         entry->objcg =3D objcg;
>         entry->referenced =3D true;
>
> ---
> base-commit: c68210527d235e59afa54bc6aba6ecc532488a82
> change-id: 20260726-shrink_zswap_entry_v1-0-0-f21e34cc9214
>
> Best regards,
> --
> Jianyue Wu <wujianyue000@gmail.com>
>

