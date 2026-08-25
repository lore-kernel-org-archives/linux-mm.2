Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561CDC61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38C56B0088; Tue, 25 Aug 2026 13:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9E56B008A; Tue, 25 Aug 2026 13:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AA96B008C; Tue, 25 Aug 2026 13:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB0A96B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:16:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42FD9A0143
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:16:16 +0000 (UTC)
X-FDA: 85140445152.24.AC2005C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CF1240006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:16:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kg1OO2R3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787678174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FpU6PmaxasRUE/cNoODWB/68M0CfwjGVJ2810dgrTA=;
	b=BGwz6R6GHHJiDXIl53V4cn7WLIZWS+uF+wpi5MEDEKvnVn+XUjL1dGAXhRD/nkYPjyOl25
	6YeeZbru04U1BSKHkDwgzloVMgQacOEbbr0tVhVv7kQJ0mMFZOQrpf10SNkGrVr9uMvfIT
	zFRmGNiUyLcQmgzEVh0gIfi/6Mza19s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kg1OO2R3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787678174;
	b=hO50PEqLHFlfBxeUuo/H4SiikSYHBfiL+eVLiHrl4cJtUDM+fOkc+upakXplrn0ckPNPE+
	upGrvGy2/npAfmDoCMQGC8nd466dGBDqceQUzOkCkgXE3f4GMb0GhRO7e7sXI7YDmnx71V
	icv1/mEdvUzIA+2cnII16mIPYdqX+2I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D0474096B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489FC1F00A3F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787678173;
	bh=5FpU6PmaxasRUE/cNoODWB/68M0CfwjGVJ2810dgrTA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kg1OO2R3pd1StCd/dW9hKgZrY3KvUCPXsm8EeJUFVXP/SriLGIQ2W1K1YGf6VcaoQ
	 z1RmZKFUzpZ0X42uHIIYCuCW+5s7ua/ax6lbLXnxI3bP7z6MxCy3QDqwhP6+974V64
	 wonyg6VBuKIPZbtUCtVE7Rgsy8xEWDPpUI60Qnj7Fa87kFOzQEOQH9eLUcUMA88Cvs
	 IEelaZThak/xvl5tHCjlhUuhp3NQXzh39PTH0wYzX+zdhGRyQ//706b3vQ0T4TS5lm
	 WYFhNIkII+G+bun7U65EQB1k0RQQutFeaPOw3GyPvhaMEhwYl+ILZ5HbYQnUOHLb8W
	 9t1CN6ZYt5Nvg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c169ae1cb26so220723266b.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:16:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoEc3fUh9znop9yPYgnORARsGIXEoHOf7Y0EQq8MhSHFuTS3ZPrHQYxBukc7T0iNLudCnq0tweEUA==@kvack.org
X-Gm-Message-State: AFuF++kFLAMTQkF2lx0RxXhWmQpjYhfrQFMSjqiwpZ2JIO99njd4M9qg
	s9OPkkGD77DT1wBhkhpKNT+9rUvHLjUi6YzZ460kboE1SsHk+8VO8GWTbm+9QR2zyMVKlf8T7mv
	l8ubAQyn+4B7dIPqAMyRkqRFU3TvaJ2A=
X-Received: by 2002:a17:906:9c93:b0:c16:785:cfb6 with SMTP id
 a640c23a62f3a-c250aa9fd27mr99460566b.3.1787678172115; Tue, 25 Aug 2026
 10:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com> <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
In-Reply-To: <20260815-shrink_zswap_entry_0815_v2-v3-2-0171bd86a667@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 25 Aug 2026 10:16:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
X-Gm-Features: AcwNN1WFmeczMru_aTC3-n5xb3oUB4PfiSXiveph6_yFD4yANQ7GK6wWfR1PjZw
Message-ID: <CAO9r8zNFYM1bry0DwDRNtpnEL9yyXQ3h=1wcLbGsO1sFtGgvjg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dyusnk43madcg8wek4oxg5yyeca38qtn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CF1240006
X-Rspam-User: 
X-HE-Tag: 1787678174-672444
X-HE-Meta: U2FsdGVkX1+JdHnXT+cC9jDK6vzrHIla16CKb8IjMi/YVFHOD98prPKomLDv+J/r+DVQGcOSv7qoOLDxitX6wn3eiJrY0yjpfSvYuqV7jNov7cqIGRD8PXBHG2HRw5zZu6b1JVyofMAyr05d+bAU26WxczchBdOXP7t1KEOx4HJck/bbfLyWSnOBoSNCCoN97eUwlJS0PyOvMROHf1QKAf+KnsGd1ffzmtkO2+gzpnP16EOpUtcFXU1o1hghFP3I4iQRyXk6Zw4MFB9SgtQFNGzM0UBnEeQ9Ji2u5fw6+LHuoev4kTei53g7CyqHHnMvhax9kLI9iY0XP5+cKalKWRdJcXZMpcD5BQkRjRncoj17Fenz0hDXdb5s8zdY3gDCZsNRDN7TyrJrhDJa5nYphzC3bmesRsgT15PUm4ZvYMCDSHXiQ/BXCeDpw8YLhF/IUJ4B+8EWawfYKXBCxUEKlA4HPqQ8fAa5KWvhYyT1QasHGvikQHwwg9Ut0NqI4od3LASi7J/hII++qAsLhra5D0sM6uuJci9Wfr/ekFbFHTndOmD80XwnOrkJ7OaH+0Drqk+9sdWzKj/zEYv4O4vwUMcCInFZ8045iEE6RjR45ah9TaefIJvFoRunZTLA0XMQ5D65EzqL0PvuSz5MV/Ncl0ptYcihnSj5XYx+ANBvPL7runU7cC/lXtlDAVHcTCqmYGDqL3IWwvqA7XxVnKXkBFU0kq5xWZ7aP2hK9yk65maBCKjXp2ForC3aQnIPZEHccp9Q+qlEE4/H6xkRcSERlq0cPstDxyoMXGniGZmCU16GqRtzBV44iI3zyRKRVpjY7J+F9TLMqfDzmtaELAWffEquXCAcud0ict7/s56gkxdwua/nWHVxOw4c/sDZMXSd9fWXGZlaEKXfm//vPsDbOX+1oQ/phRu/HWte5KPTPj+LV/KQs8jgmzGFKxe2TKwFc2t5dmwDqh/iALlqfmb
 iDm2Uu82
 NE8KvbTret5kSN8RqjULXgQpBgdlLg5htc1IQ3wZ69ma4T6D9qGjlF8nFKvCTbj4zISj59lIvaSo/ufgGrnWs5Zvn6ehzpI4NstQuxi+NEkd1WdJzq1MJLJMLLpi9+ikALf8WEhN2mTevDUH3eCepbT29VFTuNXgClO6pam55Gwha25yBgj8/tqGs11gyuDhBfkakgueThUpo3HRBSDddJdmuuuj4o8GuOeKmsXovLqLQzd2HMqQkBtUMlGIRTjU2dXMCBU7PT1/xEP786vPG8jd3qohwbJYioTl3r1wwv7uE5+TzzZZR8y3aOl65o91sTC1kVplZYynXOn+GoUPDNaK5cmSwXqsM7D22w6WGmUh1Sm/kw8uRMjW55Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 11:54=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com=
> wrote:
>
> Originally zswap holds its pools on an RCU list whose head also serves
> as the "current pool".  Only a handful of pools are ever live at once,
> since a new pool is only created when the compressor is (re)set and
> pools are reused across compressor switches.
>
> Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
> has a stable slot number, and track the current pool with a separate
> rcu-protected pointer.
>
> Slot 0 is intentionally left unused (always NULL): a zeroed or
> incorrectly initialized pool index then resolves to NULL and trips a
> WARN rather than silently aliasing a live pool in another slot.
>
> The array keeps the same RCU publish/retire discipline the list had,
> so lookup and teardown stay equivalent.  A pool first reserves its
> slot with a placeholder marker and only stores the real pointer once
> it is committed as the current pool, so array walkers never observe a
> not-yet-ready pool as live.
>
> Behavior change: the fixed array bounds the number of simultaneously
> live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
> whereas the old list was unbounded.  A pool is only live while it is
> the current pool or still has stored pages referencing it, and pools
> are reused across compressor switches, so 15 is far more than any real
> configuration needs.  Once all slots are occupied, creating a pool for
> a 16th distinct compressor fails: zswap_pool_create() errors and
> returns NULL, and the compressor switch is rejected with -EINVAL
> rather than silently succeeding.  The cap can be raised by increasing
> ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 140 +++++++++++++++++++++++++++++++++++++++++++++++++------=
------
>  1 file changed, 114 insertions(+), 26 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cc4243356e21..603fdc418041 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -13,6 +13,7 @@
>
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> +#include <linux/cleanup.h>
>  #include <linux/module.h>
>  #include <linux/cpu.h>
>  #include <linux/highmem.h>
> @@ -154,13 +155,42 @@ struct zswap_pool {
>         struct zs_pool *zs_pool;
>         struct crypto_acomp_ctx __percpu *acomp_ctx;
>         struct percpu_ref ref;
> -       struct list_head list;
>         struct rcu_head rcu_head;
>         struct work_struct release_work;
>         struct hlist_node node;
> +       u8 idx;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>
> +#define ZSWAP_MAX_POOLS 16
> +/*
> + * Slot 0 is intentionally never used: it stays NULL so that a zeroed or
> + * incorrectly initialized pool->idx resolves to NULL (and trips a WARN)
> + * instead of silently aliasing a live pool in another slot.
> + */
> +#define ZSWAP_FIRST_POOL_SLOT 1
> +static struct zswap_pool __rcu *zswap_pools[ZSWAP_MAX_POOLS];
> +static_assert(ZSWAP_MAX_POOLS - 1 <=3D U8_MAX);
> +/*
> + * The current pool (NULL if none): an alias of one zswap_pools[] slot.
> + * It always holds a ref, so a pool is never retired while it is current=
.
> + */
> +static struct zswap_pool __rcu *zswap_current_pool;
> +
> +/*
> + * A slot placeholder used to reserve an index before the pool is commit=
ted.
> + * A reserving pool publishes this marker first and only stores the real
> + * pointer once it is ready to become current; walkers of zswap_pools[] =
treat
> + * a reserved slot as empty and skip it, so a not-yet-ready pool is neve=
r
> + * observed as live.
> + */
> +#define ZSWAP_SLOT_RESERVED ((struct zswap_pool *)-1UL)
> +
> +static inline bool zswap_slot_is_pool(struct zswap_pool *pool)
> +{
> +       return pool && pool !=3D ZSWAP_SLOT_RESERVED;
> +}
> +
>  /* Global LRU lists shared by all zswap pools. */
>  static struct list_lru zswap_list_lru;
>
> @@ -201,9 +231,7 @@ struct zswap_entry {
>  static struct xarray *zswap_trees[MAX_SWAPFILES];
>  static unsigned int nr_zswap_trees[MAX_SWAPFILES];
>
> -/* RCU-protected iteration */
> -static LIST_HEAD(zswap_pools);
> -/* protects zswap_pools list modification */
> +/* protects the zswap_pools array and zswap_current_pool */
>  static DEFINE_SPINLOCK(zswap_pools_lock);
>  /* pool counter to provide unique names to zsmalloc */
>  static atomic_t zswap_pools_count =3D ATOMIC_INIT(0);
> @@ -271,6 +299,40 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *=
acomp_ctx)
>         acomp_ctx->buffer =3D NULL;
>  }
>
> +static int zswap_pool_reserve_slot(struct zswap_pool *pool)
> +{
> +       int i;
> +
> +       guard(spinlock_bh)(&zswap_pools_lock);
> +       for (i =3D ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> +               if (!rcu_access_pointer(zswap_pools[i])) {
> +                       /*
> +                        * Reserve the slot with a placeholder rather tha=
n the
> +                        * pool itself: the pool is not ready to be curre=
nt yet
> +                        * and must not be observed as live by array walk=
ers.
> +                        * Set idx before publishing so readers never see=
 it
> +                        * stale.  zswap_pool_publish_slot() stores the r=
eal
> +                        * pointer once the pool is committed.
> +                        */

I think the reservation logic is self-explaining, the comment here is
not warranted. Especially the idx part, I believe we only set
pool->idx here to keep track of the reserved index, not really to do
it before publishing as publishing happens later. If anything, maybe
replace this with a smaller comment to the reader that we reserve the
slot at pool creation but only assign it when we make it the current
pool, with a small explanation of why that is needed (the actually
issue Sashiko pointed out)?


> +                       pool->idx =3D i;
> +                       rcu_assign_pointer(zswap_pools[i], ZSWAP_SLOT_RES=
ERVED);
> +                       return i;
> +               }
> +       }
> +
> +       return -ENOSPC;
> +}
> +
> +static void zswap_pool_publish_slot(struct zswap_pool *pool)
> +{
> +       assert_spin_locked(&zswap_pools_lock);

I think we can drop the assertion since we already have the lockdep
check below, especially because it uses BUG_ON().

> +
> +       if (rcu_dereference_protected(zswap_pools[pool->idx],
> +                                     lockdep_is_held(&zswap_pools_lock))=
 =3D=3D
> +           ZSWAP_SLOT_RESERVED)

Hmm let's read this into a variable first then compare it to
ZSWAP_SLOT_RESERVED instead? It's not very readable.

> +               rcu_assign_pointer(zswap_pools[pool->idx], pool);
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>         struct zswap_pool *pool;
> @@ -314,19 +376,28 @@ static struct zswap_pool *zswap_pool_create(char *c=
ompressor)
>         if (ret)
>                 goto cpuhp_add_fail;
>
> -       /* being the current pool takes 1 ref; this func expects the
> -        * caller to always add the new pool as the current pool
> +       /*
> +        * The initial ref is for the current-pool role.  On success the
> +        * caller must install this pool as the current pool.
>          */
>         ret =3D percpu_ref_init(&pool->ref, __zswap_pool_empty,
>                               PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
>         if (ret)
>                 goto ref_fail;
> -       INIT_LIST_HEAD(&pool->list);
> +
> +       ret =3D zswap_pool_reserve_slot(pool);
> +       if (ret < 0) {
> +               pr_err("cannot create more than %d pools\n",
> +                      ZSWAP_MAX_POOLS - ZSWAP_FIRST_POOL_SLOT);
> +               goto slot_fail;
> +       }
>
>         zswap_pool_debug("created", pool);
>
>         return pool;
>
> +slot_fail:
> +       percpu_ref_exit(&pool->ref);
>  ref_fail:
>         cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->no=
de);
>
> @@ -387,7 +458,7 @@ static void __zswap_pool_release(struct work_struct *=
work)
>         WARN_ON(!percpu_ref_is_zero(&pool->ref));
>         percpu_ref_exit(&pool->ref);
>
> -       /* pool is now off zswap_pools list and has no references. */
> +       /* readers drained by the grace period */
>         zswap_pool_destroy(pool);
>  }
>
> @@ -397,9 +468,9 @@ static void __zswap_pool_release_rcu(struct rcu_head =
*head)
>
>         /*
>          * The grace period has elapsed, so no RCU reader can still obser=
ve the
> -        * pool through the list it was removed from in __zswap_pool_empt=
y().
> -        * Hand off to a worker for the sleepable teardown, since this ca=
llback
> -        * runs in softirq context.
> +        * pool through the array slot cleared in __zswap_pool_empty().  =
Hand off
> +        * to a worker for the sleepable teardown, since this callback ru=
ns in
> +        * softirq context.
>          */
>         INIT_WORK(&pool->release_work, __zswap_pool_release);
>         schedule_work(&pool->release_work);
> @@ -417,7 +488,13 @@ static void __zswap_pool_empty(struct percpu_ref *re=
f)
>
>         WARN_ON(pool =3D=3D zswap_pool_current());
>
> -       list_del_rcu(&pool->list);
> +       /*
> +        * Clear the slot before retiring the pool so new readers cannot =
see
> +        * it; the call_rcu() below drains readers that already observed =
it.
> +        * The slot may still hold the ZSWAP_SLOT_RESERVED placeholder if=
 the
> +        * pool is torn down before it was ever published as current.
> +        */

I think this comment is unnecessary.

> +       rcu_assign_pointer(zswap_pools[pool->idx], NULL);
>
>         call_rcu(&pool->rcu_head, __zswap_pool_release_rcu);
>
> @@ -447,7 +524,8 @@ static struct zswap_pool *__zswap_pool_current(void)
>  {
>         struct zswap_pool *pool;
>
> -       pool =3D list_first_or_null_rcu(&zswap_pools, typeof(*pool), list=
);
> +       pool =3D rcu_dereference_check(zswap_current_pool,
> +                                    lockdep_is_held(&zswap_pools_lock));
>         WARN_ONCE(!pool && zswap_has_pool,
>                   "%s: no page storage pool!\n", __func__);
>
> @@ -480,11 +558,15 @@ static struct zswap_pool *zswap_pool_current_get(vo=
id)
>  static struct zswap_pool *zswap_pool_find_get(char *compressor)
>  {
>         struct zswap_pool *pool;
> +       int i;
>
>         assert_spin_locked(&zswap_pools_lock);

Let's drop the assertion here as well since we're adding a lockdep check be=
low.

>
> -       list_for_each_entry_rcu(pool, &zswap_pools, list) {
> -               if (strcmp(pool->tfm_name, compressor))
> +       for (i =3D ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> +               pool =3D rcu_dereference_protected(zswap_pools[i],
> +                                                lockdep_is_held(&zswap_p=
ools_lock));

I would align the second parameter with the first one if it stays
below 100 characters.

> +               if (!zswap_slot_is_pool(pool) ||
> +                   strcmp(pool->tfm_name, compressor))
>                         continue;
>                 /* if we can't get it, it's about to be destroyed */
>                 if (!zswap_pool_tryget(pool))
> @@ -509,10 +591,14 @@ unsigned long zswap_total_pages(void)
>  {
>         struct zswap_pool *pool;
>         unsigned long total =3D 0;
> +       int i;
>
>         rcu_read_lock();
> -       list_for_each_entry_rcu(pool, &zswap_pools, list)
> -               total +=3D zs_get_total_pages(pool->zs_pool);
> +       for (i =3D ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> +               pool =3D rcu_dereference(zswap_pools[i]);
> +               if (zswap_slot_is_pool(pool))
> +                       total +=3D zs_get_total_pages(pool->zs_pool);
> +       }
>         rcu_read_unlock();
>
>         return total;
> @@ -574,7 +660,6 @@ static int zswap_compressor_param_set(const char *val=
, const struct kernel_param
>         if (pool) {
>                 zswap_pool_debug("using existing", pool);
>                 WARN_ON(pool =3D=3D zswap_pool_current());
> -               list_del_rcu(&pool->list);
>         }
>
>         spin_unlock_bh(&zswap_pools_lock);
> @@ -601,16 +686,16 @@ static int zswap_compressor_param_set(const char *v=
al, const struct kernel_param
>         spin_lock_bh(&zswap_pools_lock);
>
>         if (!ret) {
> +               /*
> +                * Remember the old current, then publish the new pool in=
to its
> +                * slot before making it current: array walkers must neve=
r see
> +                * the current pool as a reserved (not-yet-ready) slot.
> +                */

This doesn't really explain why. Also, does ordering really matter
with the lock held?

>                 put_pool =3D zswap_pool_current();
> -               list_add_rcu(&pool->list, &zswap_pools);
> +               zswap_pool_publish_slot(pool);
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
> @@ -1815,7 +1900,10 @@ static int zswap_setup(void)
>         pool =3D __zswap_pool_create_fallback();
>         if (pool) {
>                 pr_info("loaded using pool %s\n", pool->tfm_name);
> -               list_add(&pool->list, &zswap_pools);
> +               spin_lock_bh(&zswap_pools_lock);
> +               zswap_pool_publish_slot(pool);
> +               rcu_assign_pointer(zswap_current_pool, pool);
> +               spin_unlock_bh(&zswap_pools_lock);

Is this a pre-existing bug, or why do we need to hold the lock here now?

>                 zswap_has_pool =3D true;
>                 static_branch_enable(&zswap_ever_enabled);
>         } else {
>
> --
> 2.43.0
>

