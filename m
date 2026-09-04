Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228ECC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE216B0096; Fri,  4 Sep 2026 12:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5CB6B0098; Fri,  4 Sep 2026 12:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC056B0099; Fri,  4 Sep 2026 12:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5718C6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:04:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9D5280116
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:54 +0000 (UTC)
X-FDA: 85176553308.30.54476DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E2746140006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQpvkg59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788537892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmmk1t0C2Y1hPKizPmgrlyI9EGo6c5QQyx4vRZ8NgY4=;
	b=BDMw4rVPEZvedVLMAho5yZsH3vRf+wn5eKwWV8b4xKDdTKWteFILLva42+tbQWdXligJFJ
	rcN1tDx/b1dPywY5VU68xGv5W2EfZ2xmGaoPp8E6P3gWgWOs9h8tuynlqvAwrf7R9tVihh
	RK44G/2HZ44ovUlBruePQ3mysgfpi2k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQpvkg59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788537892;
	b=tTR2AUE/BadryOZBSSB9C+I7KSkoWsH3Lue4YN4WCq44vOYsFZhltlgEWxrt/sNifrU1OL
	I3QKYeuvd1oBbdBPVqzAHe7yWmkSuC6ZeR6vFLIvvAB5FiMWL4udCnTal42gxbl41NsvcU
	uUV2P0X1fMTUxr2K6iZbW2pC+l349ZE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66BAB60210
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ABF1F00ADE
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788537892;
	bh=Gmmk1t0C2Y1hPKizPmgrlyI9EGo6c5QQyx4vRZ8NgY4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jQpvkg59xrZaJqQj+BYwlw06oZ5X3kZsfc3kDpSgWhZsaJNcUxCx6cX+MkxYh2Dyp
	 l/JSc8jOWtNEMwlBZ8hjQbZasEFSQP2sqx5B79sPYmew10yzO5Ta+sespMRlQAYf+0
	 cSCfUL+Z5PlqK+g95rD2QzihJB1EQIVKcYqio6B+j8LFWfseTpgF86OMJ/1X1FzYIj
	 QqHe1xYF2dMZjefgkMbj1PHtx+GaQ10Tl9eJxSKKFdQRVkEeyI2KjoSWpj/FXS232T
	 CoR321UJ3UMbQFKbJ44imBL++K4YtuwvIpspN+AHVC5Z6UKIo0sKZ8cPMw8Wnui0Us
	 e9GyOjoiLJVBQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c25b661d37dso170400666b.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:04:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBys3Gvu0of/+t+6joAYGfd6UJ8n8bovU08DUjT+eea6N2L0vJWA9uq/tu/yQVSbRQLebhsed9myaQ==@kvack.org
X-Gm-Message-State: AFuF++nIZ9mHkBQMrfIPPcZ7j28B2lUxtA7OHVKYOFT9gEzeBoZXxWWy
	q2cxefCPvHu9JI0grXtLqgi1XTn9gHm2Je268i0V+67ujCFEi0FS8o+GJEfRjmtkYZQnwiqROo6
	vFE1aPPEiPZ2ieHxzZ+WUK+cOSfDdj50=
X-Received: by 2002:a17:907:94c4:b0:c26:19e3:e984 with SMTP id
 a640c23a62f3a-c2619e3ef27mr162038966b.36.1788537890836; Fri, 04 Sep 2026
 09:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
 <22625ed4915936814f766092e9d7ac6637c5b2f4.1788528216.git.wujianyue000@gmail.com>
In-Reply-To: <22625ed4915936814f766092e9d7ac6637c5b2f4.1788528216.git.wujianyue000@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 4 Sep 2026 09:04:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMiOvhy3BZ0NjvL6Wn6e_VpVb-sZzk5bpDFuoXBHbzATA@mail.gmail.com>
X-Gm-Features: AcwNN1WjlVqWQnVgvcTJ5MoeC1gjlI_29fN_QCooc4LogG5zdxtCzAEpPETlkYQ
Message-ID: <CAO9r8zMiOvhy3BZ0NjvL6Wn6e_VpVb-sZzk5bpDFuoXBHbzATA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm/zswap: replace the zswap_pools list with an
 allocating xarray
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bswm4swnf6b31wcegd63u9aoz4bgota5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2746140006
X-Rspam-User: 
X-HE-Tag: 1788537892-308147
X-HE-Meta: U2FsdGVkX199gqzw00vBBeHzQJvWCTojKdcRB9G+PpcrjKPCnWQA9LS4rptQ/HrHhmlGNUfEsrivFr+vxoiyUEEb6aYhyG3S13ssgzNFGDiJHqdW72lywK5bBtiQHUuMIK2x++j4SFKPDFwiT1mbnSwWkQ5gzyYr7Dt8QpDhl+oxXuiW2Ma6kRc77/9RlR+0Ld3jvtrpQ9AgnIus4il0FeVFW475QqDLOp7dS9TYyjz78CKpu5I3UVDVjlx/d8L93UipmdZ1KTLBknqrOY4Lwk6rybnX8YzlzssrHQe9COO/1WdQzvf6v1akHdUB0b5TOFbQp1dD6ufs4ZYIU9n4ALapvkMrJhVz7VzHrgnv25Htq5WK1tPrJ1xytPg6suDlpRbTupofSACe2ntGp7katDaDDfDOOH8wexLy4WglaaMojrHD/R/O+i2kkhf2TJL9FHm2hOURcoNA9Yk2PEeaI/EqDVJ1ThkLFFc37MWKxFRIOXj+Ribsicv9wurklmdznpZjh0uNHoHzTsuT4byxB4176DnSgJZZuV+1TjeYmlI0XV73RqnrWXZJlCkWjy8QqQ89o3d1R5mZt2xSr0WpfyuU/q++3q8tiC6hA7yXMhAi9Vbap82lAsABoOB/GIch3uy2ojWu0CbEWc4hb02uhL1diUi+xYz01PjOQfCKHk+tqjwgrSNMvbnwh54rZ1nUQaK/uN05w+7m1OInFcOx/llrSFVjJExwNrOU6TIfWLlpl5r/QMLuWeWDf9/rr9c/o9KF5pzVGQezDi4ypWndDZwgMm6/DQPI9UbzQfcc+KxCiV6s60/cZq0IWIVHnNip79PBz7le6V1fGVC8w4zdGnhgDUS03Dyc1ArUJQn6DMWSdVw3pq4SpPc86FLuzHIwDSPIXgZbTlwrYoSOjLqAE+gBi5/qts7OyvIHkSylspcXUv2Wtn9YTN5/UAXUwoZvlEebBS2IbJ84PjrV0HM
 G3u6PGfg
 QqVy+bKyQfx0E03WZ4fwcXB7V2BdijyntjMro0nb2yQzsqnXBzymDC0ugcjc86CfjZRdLKKpcZtmIXQG5JwjjHr4aOvE440NTeKGn0RGK4xfqRpGWUdk68q74Wdxf3qLkm/32QZ68Mde4tU7I82E73HuvNmPOBvVwuk96tWXaknFj66DtqytiqmD8dazxzH+ahGSWXCykQh8w+65jsjUJMw0piAOviFWpTqqqmNFIf8f4SlSDQJ/3AkES2tVDs0AAFsb1D08NRoVkWCu4DZbdX4Qj5Aj/VwXhKSSLWCrYinBLBkgFwpCKHEOelTCsmpugl8Xnhg6nIjhTwHkqwWVWhlrpVa/4Nhf+L05E9lsuJjefv7mIICuU0UMBinheAMW+9Zc/o0NmGaBHsVZphDTZwPOzoOZ3yXt4kTFiHr24f6IHljLWZvtFOJMvqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 6:25=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com> =
wrote:
>
> Originally zswap keeps its pools on an RCU list whose head also serves
> as the current pool. Convert the pool table to an allocating xarray
> keyed by a small integer id, and track the current pool with a separate
> RCU-protected pointer.
>
> The xarray gives each pool a stable id for a later zswap_entry shrink.
> XA_FLAGS_ALLOC1 starts ids at 1, so id 0 remains reserved. The id range
> is bounded by ZSWAP_MAX_POOL_ID because the later entry field is a u8.
>
> Keep compressor switching close to the previous flow: look up an
> existing pool under xa_lock, resurrect it outside the lock if reused, or
> create a new one. zswap_pool_create() allocates the pool's id and
> publishes it into the xarray as its final step, so the create call is
> itself atomic: it either fully builds the pool and publishes it, or
> unwinds completely on failure. Publishing makes the pool live, so a
> caller that later fails (e.g. param_set_charp()) must still kill the
> pool to erase it from the xarray. Runtime compressor parameter updates
> are serialized by the module parameter lock, so no speculative loser
> path is needed.
>
> A retiring pool is erased from the xarray in __zswap_pool_empty() and
> freed via queue_rcu_work(), preserving the old RCU teardown ordering.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 87 +++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 54 insertions(+), 33 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e456e5080531..74876acfa9dc 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -34,6 +34,7 @@
>  #include <linux/writeback.h>
>  #include <linux/pagemap.h>
>  #include <linux/workqueue.h>
> +#include <linux/xarray.h>
>  #include <linux/list_lru.h>
>  #include <linux/zsmalloc.h>
>
> @@ -154,12 +155,24 @@ struct zswap_pool {
>         struct zs_pool *zs_pool;
>         struct crypto_acomp_ctx __percpu *acomp_ctx;
>         struct percpu_ref ref;
> -       struct list_head list;
>         struct rcu_work release_rwork;
>         struct hlist_node node;
> +       u8 idx;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>
> +/*
> + * Live pools keyed by id (1..ZSWAP_MAX_POOL_ID).  XA_FLAGS_ALLOC1 keeps
> + * the reserved id 0 unallocated, so looking it up never aliases a live
> + * pool.  XA_FLAGS_LOCK_BH makes the xa_lock softirq-safe: it is taken
> + * from __zswap_pool_empty(), which runs from a percpu_ref release
> + * callback in softirq context.
> + */
> +#define ZSWAP_FIRST_POOL_ID 1
> +#define ZSWAP_MAX_POOL_ID U8_MAX
> +static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_=
BH);
> +static struct zswap_pool __rcu *zswap_current_pool;
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>
> @@ -200,10 +213,6 @@ struct zswap_entry {
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>
> -/* RCU-protected iteration */
> -static LIST_HEAD(zswap_pools);
> -/* protects zswap_pools list modification */
> -static DEFINE_SPINLOCK(zswap_pools_lock);
>  /* pool counter to provide unique names to zsmalloc */
>  static atomic_t zswap_pools_count =3D ATOMIC_INIT(0);
>
> @@ -275,6 +284,7 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>         struct zswap_pool *pool;
>         char name[38]; /* 'zswap' + 32 char (max) num + \0 */
>         int ret, cpu;
> +       u32 id;
>
>         if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
>                 return NULL;
> @@ -320,12 +330,24 @@ static struct zswap_pool *zswap_pool_create(char *c=
ompressor)
>                               PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
>         if (ret)
>                 goto ref_fail;
> -       INIT_LIST_HEAD(&pool->list);
> +
> +       ret =3D xa_alloc_bh(&zswap_pools, &id, pool,
> +                         XA_LIMIT(ZSWAP_FIRST_POOL_ID, ZSWAP_MAX_POOL_ID=
),
> +                         GFP_KERNEL);
> +       if (ret) {
> +               if (ret =3D=3D -EBUSY)
> +                       pr_err("cannot allocate pool id (max %d live pool=
s)\n",
> +                              ZSWAP_MAX_POOL_ID - ZSWAP_FIRST_POOL_ID + =
1);
> +               goto xa_fail;
> +       }
> +       pool->idx =3D id;
>
>         zswap_pool_debug("created", pool);
>
>         return pool;
>
> +xa_fail:
> +       percpu_ref_exit(&pool->ref);
>  ref_fail:
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
>
> @@ -386,7 +408,7 @@ static void __zswap_pool_release(struct work_struct *=
work)
>         WARN_ON(!percpu_ref_is_zero(&pool->ref));
>         percpu_ref_exit(&pool->ref);
>
> -       /* pool is now off zswap_pools list and has no references. */
> +       /* The pool is no longer in zswap_pools and has no references. */
>         zswap_pool_destroy(pool);
>  }
>
> @@ -398,16 +420,16 @@ static void __zswap_pool_empty(struct percpu_ref *r=
ef)
>
>         pool =3D container_of(ref, typeof(*pool), ref);
>
> -       spin_lock_bh(&zswap_pools_lock);
> +       xa_lock_bh(&zswap_pools);
>
>         WARN_ON(pool =3D=3D zswap_pool_current());
>
> -       list_del_rcu(&pool->list);
> +       __xa_erase(&zswap_pools, pool->idx);
>
>         INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
>         queue_rcu_work(system_percpu_wq, &pool->release_rwork);
>
> -       spin_unlock_bh(&zswap_pools_lock);
> +       xa_unlock_bh(&zswap_pools);

Do we need to call queue_rcu_work() under the lock? I assume not. Can
we just call xa_erase_bh()?

>  }
>
>  static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
> @@ -433,7 +455,8 @@ static struct zswap_pool *__zswap_pool_current(void)
>  {
>         struct zswap_pool *pool;
>
> -       pool =3D list_first_or_null_rcu(&zswap_pools, typeof(*pool), list=
);
> +       pool =3D rcu_dereference_check(zswap_current_pool,
> +                                    lockdep_is_held(&zswap_pools.xa_lock=
));
>         WARN_ONCE(!pool && zswap_has_pool,
>                   "%s: no page storage pool!\n", __func__);
>
> @@ -442,7 +465,7 @@ static struct zswap_pool *__zswap_pool_current(void)
>
>  static struct zswap_pool *zswap_pool_current(void)
>  {
> -       assert_spin_locked(&zswap_pools_lock);
> +       lockdep_assert_held(&zswap_pools.xa_lock);
>
>         return __zswap_pool_current();
>  }
> @@ -462,14 +485,15 @@ static struct zswap_pool *zswap_pool_current_get(vo=
id)
>         return pool;
>  }
>
> -/* type and compressor must be null-terminated */
> +/* compressor must be null-terminated */
>  static struct zswap_pool *zswap_pool_find_get(char *compressor)
>  {
>         struct zswap_pool *pool;
> +       unsigned long id;
>
> -       assert_spin_locked(&zswap_pools_lock);
> +       lockdep_assert_held(&zswap_pools.xa_lock);
>
> -       list_for_each_entry_rcu(pool, &zswap_pools, list) {
> +       xa_for_each(&zswap_pools, id, pool) {
>                 if (strcmp(pool->tfm_name, compressor))
>                         continue;
>                 /* if we can't get it, it's about to be destroyed */
> @@ -495,9 +519,15 @@ unsigned long zswap_total_pages(void)
>  {
>         struct zswap_pool *pool;
>         unsigned long total =3D 0;
> +       unsigned long id;
>
> +       /*
> +        * rcu_read_lock() is required here, not just for xa_for_each(): =
it also
> +        * keeps each pool alive while it is dereferenced, since a concur=
rently
> +        * retired pool is freed via queue_rcu_work() after a grace perio=
d.
> +        */

Doesn't xa_for_each() already handle RCU locking?

>         rcu_read_lock();
> -       list_for_each_entry_rcu(pool, &zswap_pools, list)
> +       xa_for_each(&zswap_pools, id, pool)
>                 total +=3D zs_get_total_pages(pool->zs_pool);
>         rcu_read_unlock();
>
> @@ -554,20 +584,17 @@ static int zswap_compressor_param_set(const char *v=
al, const struct kernel_param
>                 return -ENOENT;
>         }
>
> -       spin_lock_bh(&zswap_pools_lock);
> -
> +       xa_lock_bh(&zswap_pools);
>         pool =3D zswap_pool_find_get(s);

This is the only caller of zswap_pool_find_get(), and since we remove
list_del_rcu() below we have no reason for holding the lock here other
than zswap_pool_find_get(). So let's move the locking inside? I am
also not really sure if we actually need to hold the lock here anymore
to begin with.

>         if (pool) {
>                 zswap_pool_debug("using existing", pool);
>                 WARN_ON(pool =3D=3D zswap_pool_current());
> -               list_del_rcu(&pool->list);
>         }
> +       xa_unlock_bh(&zswap_pools);
>
> -       spin_unlock_bh(&zswap_pools_lock);
> -
> -       if (!pool)
> +       if (!pool) {
>                 pool =3D zswap_pool_create(s);
> -       else {
> +       } else {
>                 /*
>                  * Restore the initial ref dropped by percpu_ref_kill()
>                  * when the pool was decommissioned and switch it again
> @@ -584,23 +611,17 @@ static int zswap_compressor_param_set(const char *v=
al, const struct kernel_param
>         else
>                 ret =3D -EINVAL;
>
> -       spin_lock_bh(&zswap_pools_lock);
> +       xa_lock_bh(&zswap_pools);

Do we still need to hold the lock here?

>
>         if (!ret) {
>                 put_pool =3D zswap_pool_current();
> -               list_add_rcu(&pool->list, &zswap_pools);
> +               rcu_assign_pointer(zswap_current_pool, pool);
>                 zswap_has_pool =3D true;
>         } else if (pool) {
> -               /*
> -                * Add the possibly pre-existing pool to the end of the p=
ools
> -                * list; if it's new (and empty) then it'll be removed an=
d
> -                * destroyed by the put after we drop the lock
> -                */
> -               list_add_tail_rcu(&pool->list, &zswap_pools);
>                 put_pool =3D pool;
>         }
>
> -       spin_unlock_bh(&zswap_pools_lock);
> +       xa_unlock_bh(&zswap_pools);
>
>         /*
>          * Drop the ref from either the old current pool,
> @@ -1788,7 +1809,7 @@ static int zswap_setup(void)
>         pool =3D __zswap_pool_create_fallback();
>         if (pool) {
>                 pr_info("loaded using pool %s\n", pool->tfm_name);
> -               list_add(&pool->list, &zswap_pools);
> +               rcu_assign_pointer(zswap_current_pool, pool);
>                 zswap_has_pool =3D true;
>                 static_branch_enable(&zswap_ever_enabled);
>         } else {
> --
> 2.43.0
>

