Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E9FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDA29001DE; Thu, 14 Aug 2025 17:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DFB9001D5; Thu, 14 Aug 2025 17:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A654B9001DE; Thu, 14 Aug 2025 17:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE1B9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:05:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 391C5C072B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:05:19 +0000 (UTC)
X-FDA: 83776593558.08.4893DF0
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 51A5DC000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:05:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D7KmS4eN;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755205517; a=rsa-sha256;
	cv=none;
	b=V9jbEcwy8KVf2ujtTkuHRmSHYCNh0irUZy2ZUV1klnxg/NaIqms52Pz9d27cPWRFhrTUOk
	DrmouKg2XbExD17dq7sfA1KJMwmYMpEjKiQCExzem3BfDzVsUnhOA8fKyQQYAFl1mZUj8U
	/DgqOkzb1bWtsGkRLGsU1oypZH43xOk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D7KmS4eN;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755205517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9GEbGYpAl9ZYb7PgL+hmgK6T8IXI+LOILb57JZov84=;
	b=LGpkTnRSm+BGdqI+ecawInF6OPz5yiBJRa5mW+ScntvaAWFKrpO8L0nKFaqpT5DTHRJbXT
	0XdRWm08WA5sQyjkArHTzI8HZfTfGZAaT6OrOoiQ2MDD0fjyUS+nCuxamNZ1OMfk/H9SOF
	aL7ctQUQmuR0hricnO/KX6xrB1jeAL4=
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3e56ffccadaso11054275ab.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755205516; x=1755810316; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9GEbGYpAl9ZYb7PgL+hmgK6T8IXI+LOILb57JZov84=;
        b=D7KmS4eNpFHAtfRUjfd1pruLLNPPjSivAxdWVf27QKvwwVvAG1sxEK7waPqvynYdvw
         n9Nld+r4buKY+oASyP1IfvaiPHugb1RGcjRGtXvC3I2QVE/mh4v75gRMzL955W7mCdBc
         YjamtDJKQZufHUChLge+LIDaRSsxjnD6ws/ZrAvrWkXLe6X2Nri8PL7KAiUZUa5+E1IN
         xSmsZZA8lUYwGxm1orepjuQr2kq3/strJcHcqqXCB2lyw5tzH9/OoGMq2R/prZEUUOyl
         QT29R8hhb4VsQFv9qWiE0MM9/js3GdkhPUVyP78niTRDJpyQ+ltLRiGuHIAZ66LGb998
         XV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755205516; x=1755810316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9GEbGYpAl9ZYb7PgL+hmgK6T8IXI+LOILb57JZov84=;
        b=Al/qCoBiPrgQTCLKxXDTIAJhJQTK2esp6AFy2XAL9v/Thpe/v/jGUrXFjYpf4s2VLr
         jPKxzIn7ueWsmR7+hM1YNi8TOpFpmHLzIWRCRBPjrTrp4XoDCkyyBSwCeAprb6pRJic6
         L/cuDHpd7EWF8d0VxWG5TfmdJYTW0S3bGaOCJ1f3/ecQ01YicpO2urPCsshmro7JkgkI
         SoDpva3YnD1jR6yNoz6I02WQR1ExyBpISoUgJtKV9zeGfYNz7QwxxZl8X7R/Mc1o0h/I
         xG/2725JKMBi4SIIsHnw1mJJrL2v9Yzbr3HAj7hG1o0zmcpxk/yx+C2zzpNXVpADoIqA
         Kh+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxWL8feKuk8oEYhkSUBgWFZymLJhV6Dipf17OCaQjzLLLKUmZHmyp3fb4m2gYpZY3VSnB4svDcYA==@kvack.org
X-Gm-Message-State: AOJu0YwlgrD2mFAzbeFYETg50UyFlvrO75hZKlu5GohDf+ymSWuRckU4
	LjjuBgRXP322+NnBJwO0zzq1J663fPqkIC2lOCtx4W6MMSozz3k2XXYjAPSrAaOUP80LVOvp2/O
	yG7Ay7wi1QMu2sVQJHVrDGY8tPMoNykY=
X-Gm-Gg: ASbGncsHtpzMCZjY9bOyL7/g5d9/WLQ2ywdM0gOIKmyQX7FvEfuvVWuefT6M2v6tFer
	3kUrgl7zO7ksKvEYP6v6z+2wu390alH+owkPkZNH0sMXCMiK17xcbuCJITtj1KceLLerT6XXoX4
	5wW+/uzfQpeiOEJe6Ns2SJvsCYV33VY+A1+xZ8W1BZxSa3D3x266el+AfkSDFbL3F+3MXUSbeLT
	rkmKv432IAy9VI/IzQEXho=
X-Google-Smtp-Source: AGHT+IFN9IX+OqiygWLS3bv9GReWZDPmxX4NpFt7R3ZINH4TwSo73r+HWi6y6UDi5Dxjkcl2a03+xnNp7B50B61iNks=
X-Received: by 2002:a05:6e02:1fc9:b0:3e5:4da2:93ad with SMTP id
 e9e14a558f8ab-3e5709144c7mr78477845ab.11.1755205516094; Thu, 14 Aug 2025
 14:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 14 Aug 2025 14:05:04 -0700
X-Gm-Features: Ac12FXxuV7Q0wou7hYqoXwQNo-696enIvb_DC6WEALqgMV_gXOt0FjNzFvS26IM
Message-ID: <CAKEwX=Ov2X-0EnmWDCf=mahnR57si_QUuXF7F=Eb5P2cKYZEvg@mail.gmail.com>
Subject: Re: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51A5DC000D
X-Stat-Signature: hafy76q6er8irc4uztbb3hz6s8gcpgjw
X-Rspam-User: 
X-HE-Tag: 1755205517-607752
X-HE-Meta: U2FsdGVkX1+fVSYnNu9MZHmOP3M+vJRNY40u7ahtwRNqQp6XEeHiZBQiv4ZdZAewNP2bs4NRGZkMnLCbMYkMkNnkxzHAXOm7kH+ARC6kT0rY33ceIGhOUj3hAMwEBjSco/I/KenKzGoC24sFA1NOVnVNhstQ/s3tLvufGQkzZs03ICRIahDISOEo+gvSisfXePYBy9D53/AoD5Zz0btuKUCPH7jUuFEhkrDE7J3YK/lcvVEqaKYZD8Bs44dbroOVxYfDQvfiusOzsDZq3I73gbjpugMP/Sh0bFvcyPisOo6CROMwhRyZx/KUgFLBNuNGinrgd3RAvGmASwng6/Zo97SAchFpbf6+TahJIC8HhdMEDK3tOf6aTqjn2OhZrAzXAxtEUSrsxEwMmdBiVlOko+Tim1NQsP56lXUprZprJ6npb20AEvQOaPhuGaHQ8RS/DvrBT/EqDMRZcA1YW5yGMIE9pADCw6BFMzEDeI8ZNzrH8F4MOgtlgw4fa/Vshhu2+pjZEbQIQK0rycwOSxzksoGtRVBVJs+q49xlOjoL9cZXaP4+D0dX0Y77kw7KkRESW2Di1i84FsxrikUCLTcigyZKTR/NalkeAvQv9vpMmDmrM8TNsfqXFsOTMppXOVjig9g21s9W8C5w5iiiIB3+W3amfi57kH81GSZsnt5DC41/lOSUMCgiKzp67DlXOzAZOwZkIk7STTrY/JMqtssFmBH0Cv3vNHBXi9x3Niks5YDpo7hEvSlddhmvCs8h5v9whBiAnK+BCi8TB3m8IIEW+Fh0peCcllzJffx7OqRMwdDKsWFd/52KdCnAD4+xUCXNnciO55XA93yKvTtVc00rkJs7hrh6nwL0gEGnQaI71jjCK9joHvmtERKSaEU8wTL8g/QWmE6yxQNo4JjLp4NLhLvKSJktYpJJazfkACZ3w8c/WA7YfRH8xI/LrjqjEExASlG7Hup2qRjWNqoAKHV
 GyT08Yqp
 KH4kOfJeWHbxYG5GR/FaKTxZ91Fvp0fGU9vQTamnVuYiHRW9PCB1m2m59E3EhV7Z35to2BOvlm/qzXXEtqPpXZ/ThRk0AbBdGYw6XiHtHZwmWgjL5O+JCllsczHh0iYZ6KIkG6NV343+KLSU8P5yNjWQa6BV4QyyhKMY95wZokxLCmCo+xOnhCh3ooZla8OWYhsDbpFKIwGOblFh1ucQSrdQvBbtpr42uIbTOrGSIlPsQooJTGGJWvQ6b0xNEQcDc4g5r5czueW032zv8PGYYV7BRM/pB2ZLK9sSoKwmFoNnpue7oCrrrKKlTLGRARzPdS8etLJgGA4OaWKg37eo0O3PH2g9Q1i3UZ7zDy1qrDO+pJDTQJOXx1/ru+Emg4wkBvLO2ybxMcb6b1N1RTSV0p9TFHo2nhYC024WuJu/ugfGLaXA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 9:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch modifies zswap_store() to store a batch of pages in large
> folios at a time, instead of storing one page at a time. It does this by
> calling a new procedure zswap_store_pages() with a range of
> "pool->batch_size" indices in the folio.
>
> zswap_store_pages() implements all the computes done earlier in
> zswap_store_page() for a single-page, for multiple pages in a folio,
> namely the "batch":
>
> 1) It starts by allocating all zswap entries required to store the
>    batch. New procedures, zswap_entries_cache_alloc_batch() and
>    zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>    to optimize the performance of this step.
>
> 2) Next, the entries fields are written, computes that need to be happen
>    anyway, without modifying the zswap xarray/LRU publishing order. This
>    improves latency by avoiding having the bring the entries into the
>    cache for writing in different code blocks within this procedure.
>
> 3) Next, it calls zswap_compress() to sequentially compress each page in
>    the batch.
>
> 4) Finally, it adds the batch's zswap entries to the xarray and LRU,
>    charges zswap memory and increments zswap stats.
>
> 5) The error handling and cleanup required for all failure scenarios
>    that can occur while storing a batch in zswap are consolidated to a
>    single "store_pages_failed" label in zswap_store_pages(). Here again,
>    we optimize performance by calling kmem_cache_free_bulk().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 149 insertions(+), 69 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 63a997b999537..8ca69c3f30df2 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -879,6 +879,24 @@ static void zswap_entry_cache_free(struct zswap_entr=
y *entry)
>         kmem_cache_free(zswap_entry_cache, entry);
>  }
>
> +/*
> + * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number oth=
erwise.
> + * The code for __kmem_cache_alloc_bulk() indicates that this positive n=
umber
> + * will be the @size requested, i.e., @nr_entries.
> + */
> +static __always_inline int zswap_entries_cache_alloc_batch(void **entrie=
s,
> +                                                          unsigned int n=
r_entries,
> +                                                          gfp_t gfp)
> +{
> +       return kmem_cache_alloc_bulk(zswap_entry_cache, gfp, nr_entries, =
entries);
> +}
> +
> +static __always_inline void zswap_entries_cache_free_batch(void **entrie=
s,
> +                                                          unsigned int n=
r_entries)
> +{
> +       kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
> +}
> +
>  /*
>   * Carries out the common pattern of freeing and entry's zpool allocatio=
n,
>   * freeing the entry itself, and decrementing the number of stored pages=
.
> @@ -1512,93 +1530,154 @@ static void shrink_worker(struct work_struct *w)
>  * main API
>  **********************************/
>
> -static bool zswap_store_page(struct page *page,
> -                            struct obj_cgroup *objcg,
> -                            struct zswap_pool *pool)
> +/*
> + * Store multiple pages in @folio, starting from the page at index @star=
t up to
> + * the page at index @end-1.
> + */
> +static bool zswap_store_pages(struct folio *folio,
> +                             long start,
> +                             long end,
> +                             struct obj_cgroup *objcg,
> +                             struct zswap_pool *pool,
> +                             int node_id)
>  {
> -       swp_entry_t page_swpentry =3D page_swap_entry(page);
> -       struct zswap_entry *entry, *old;
> -
> -       /* allocate entry */
> -       entry =3D zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
> -       if (!entry) {
> -               zswap_reject_kmemcache_fail++;
> -               return false;
> +       struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
> +       u8 i, store_fail_idx =3D 0, nr_pages =3D end - start;
> +
> +       if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0=
],
> +                                                     nr_pages, GFP_KERNE=
L))) {
> +               for (i =3D 0; i < nr_pages; ++i) {
> +                       entries[i] =3D zswap_entry_cache_alloc(GFP_KERNEL=
, node_id);
> +
> +                       if (unlikely(!entries[i])) {
> +                               zswap_reject_kmemcache_fail++;
> +                               /*
> +                                * While handling this error, we only nee=
d to
> +                                * call zswap_entries_cache_free_batch() =
for
> +                                * entries[0 .. i-1].
> +                                */
> +                               nr_pages =3D i;
> +                               goto store_pages_failed;
> +                       }
> +               }
>         }
>
> -       if (!zswap_compress(page, entry, pool))
> -               goto compress_failed;
> +       /*
> +        * Three sets of initializations are done to minimize bringing
> +        * @entries into the cache for writing at different parts of this
> +        * procedure, since doing so regresses performance:
> +        *
> +        * 1) Do all the writes to each entry in one code block. These
> +        *    writes need to be done anyway upon success which is more li=
kely
> +        *    than not.
> +        *
> +        * 2) Initialize the handle to an error value. This facilitates
> +        *    having a consolidated failure handling
> +        *    'goto store_pages_failed' that can inspect the value of the
> +        *    handle to determine whether zpool memory needs to be
> +        *    de-allocated.
> +        *
> +        * 3) The page_swap_entry() is obtained once and stored in the en=
try.
> +        *    Subsequent store in xarray gets the entry->swpentry instead=
 of
> +        *    calling page_swap_entry(), minimizing computes.
> +        */
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               entries[i]->handle =3D (unsigned long)ERR_PTR(-EINVAL);
> +               entries[i]->pool =3D pool;
> +               entries[i]->swpentry =3D page_swap_entry(folio_page(folio=
, start + i));
> +               entries[i]->objcg =3D objcg;
> +               entries[i]->referenced =3D true;
> +               INIT_LIST_HEAD(&entries[i]->lru);
> +       }
>
> -       old =3D xa_store(swap_zswap_tree(page_swpentry),
> -                      swp_offset(page_swpentry),
> -                      entry, GFP_KERNEL);
> -       if (xa_is_err(old)) {
> -               int err =3D xa_err(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct page *page =3D folio_page(folio, start + i);
>
> -               WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray error: %d\=
n", err);
> -               zswap_reject_alloc_fail++;
> -               goto store_failed;
> +               if (!zswap_compress(page, entries[i], pool))
> +                       goto store_pages_failed;
>         }
>
> -       /*
> -        * We may have had an existing entry that became stale when
> -        * the folio was redirtied and now the new version is being
> -        * swapped out. Get rid of the old.
> -        */
> -       if (old)
> -               zswap_entry_free(old);
> +       for (i =3D 0; i < nr_pages; ++i) {
> +               struct zswap_entry *old, *entry =3D entries[i];
>
> -       /*
> -        * The entry is successfully compressed and stored in the tree, t=
here is
> -        * no further possibility of failure. Grab refs to the pool and o=
bjcg,
> -        * charge zswap memory, and increment zswap_stored_pages.
> -        * The opposite actions will be performed by zswap_entry_free()
> -        * when the entry is removed from the tree.
> -        */
> -       zswap_pool_get(pool);
> -       if (objcg) {
> -               obj_cgroup_get(objcg);
> -               obj_cgroup_charge_zswap(objcg, entry->length);
> -       }
> -       atomic_long_inc(&zswap_stored_pages);
> +               old =3D xa_store(swap_zswap_tree(entry->swpentry),
> +                              swp_offset(entry->swpentry),
> +                              entry, GFP_KERNEL);
> +               if (unlikely(xa_is_err(old))) {
> +                       int err =3D xa_err(old);
>
> -       /*
> -        * We finish initializing the entry while it's already in xarray.
> -        * This is safe because:
> -        *
> -        * 1. Concurrent stores and invalidations are excluded by folio l=
ock.
> -        *
> -        * 2. Writeback is excluded by the entry not being on the LRU yet=
.
> -        *    The publishing order matters to prevent writeback from seei=
ng
> -        *    an incoherent entry.
> -        */
> -       entry->pool =3D pool;
> -       entry->swpentry =3D page_swpentry;
> -       entry->objcg =3D objcg;
> -       entry->referenced =3D true;
> -       if (entry->length) {
> -               INIT_LIST_HEAD(&entry->lru);
> -               zswap_lru_add(&zswap_list_lru, entry);
> +                       WARN_ONCE(err !=3D -ENOMEM, "unexpected xarray er=
ror: %d\n", err);
> +                       zswap_reject_alloc_fail++;
> +                       /*
> +                        * Entries up to this point have been stored in t=
he
> +                        * xarray. zswap_store() will erase them from the=
 xarray
> +                        * and call zswap_entry_free(). Local cleanup in
> +                        * 'store_pages_failed' only needs to happen for
> +                        * entries from [@i to @nr_pages).
> +                        */
> +                       store_fail_idx =3D i;
> +                       goto store_pages_failed;
> +               }
> +
> +               /*
> +                * We may have had an existing entry that became stale wh=
en
> +                * the folio was redirtied and now the new version is bei=
ng
> +                * swapped out. Get rid of the old.
> +                */
> +               if (unlikely(old))
> +                       zswap_entry_free(old);
> +
> +               /*
> +                * The entry is successfully compressed and stored in the=
 tree, there is
> +                * no further possibility of failure. Grab refs to the po=
ol and objcg,
> +                * charge zswap memory, and increment zswap_stored_pages.
> +                * The opposite actions will be performed by zswap_entry_=
free()
> +                * when the entry is removed from the tree.
> +                */
> +               zswap_pool_get(pool);
> +               if (objcg) {
> +                       obj_cgroup_get(objcg);
> +                       obj_cgroup_charge_zswap(objcg, entry->length);
> +               }
> +               atomic_long_inc(&zswap_stored_pages);
> +
> +               /*
> +                * We finish by adding the entry to the LRU while it's al=
ready
> +                * in xarray. This is safe because:
> +                *
> +                * 1. Concurrent stores and invalidations are excluded by=
 folio lock.
> +                *
> +                * 2. Writeback is excluded by the entry not being on the=
 LRU yet.
> +                *    The publishing order matters to prevent writeback f=
rom seeing
> +                *    an incoherent entry.
> +                */
> +               if (likely(entry->length))
> +                       zswap_lru_add(&zswap_list_lru, entry);
>         }
>
>         return true;
>
> -store_failed:
> -       zpool_free(pool->zpool, entry->handle);
> -compress_failed:
> -       zswap_entry_cache_free(entry);
> +store_pages_failed:
> +       for (i =3D store_fail_idx; i < nr_pages; ++i) {
> +               if (!IS_ERR_VALUE(entries[i]->handle))
> +                       zpool_free(pool->zpool, entries[i]->handle);
> +       }
> +       zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
> +                                      nr_pages - store_fail_idx);
> +
>         return false;
>  }
>
>  bool zswap_store(struct folio *folio)
>  {
>         long nr_pages =3D folio_nr_pages(folio);
> +       int node_id =3D folio_nid(folio);
>         swp_entry_t swp =3D folio->swap;
>         struct obj_cgroup *objcg =3D NULL;
>         struct mem_cgroup *memcg =3D NULL;
>         struct zswap_pool *pool;
>         bool ret =3D false;
> -       long index;
> +       long start, end;
>
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1632,10 +1711,11 @@ bool zswap_store(struct folio *folio)
>                 mem_cgroup_put(memcg);
>         }
>
> -       for (index =3D 0; index < nr_pages; ++index) {
> -               struct page *page =3D folio_page(folio, index);
> +       /* Store the folio in batches of @pool->batch_size pages. */
> +       for (start =3D 0; start < nr_pages; start +=3D pool->batch_size) =
{
> +               end =3D min(start + pool->batch_size, nr_pages);
>
> -               if (!zswap_store_page(page, objcg, pool))
> +               if (!zswap_store_pages(folio, start, end, objcg, pool, no=
de_id))
>                         goto put_pool;
>         }
>
> @@ -1665,9 +1745,9 @@ bool zswap_store(struct folio *folio)
>                 struct zswap_entry *entry;
>                 struct xarray *tree;
>
> -               for (index =3D 0; index < nr_pages; ++index) {
> -                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 index));
> -                       entry =3D xa_erase(tree, offset + index);
> +               for (start =3D 0; start < nr_pages; ++start) {
> +                       tree =3D swap_zswap_tree(swp_entry(type, offset +=
 start));
> +                       entry =3D xa_erase(tree, offset + start);
>                         if (entry)
>                                 zswap_entry_free(entry);
>                 }
> --
> 2.27.0
>

This patch LGTM for the most part. Lemme test the series again (I
tested an old version of this patch series), and I will give my Ack.

