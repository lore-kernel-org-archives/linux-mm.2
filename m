Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1B0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F6E6B02A4; Tue,  1 Sep 2026 12:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8F96B02A6; Tue,  1 Sep 2026 12:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8AC6B02A7; Tue,  1 Sep 2026 12:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 017846B02A4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:13:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 802EA803DD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:13:37 +0000 (UTC)
X-FDA: 85165688874.25.FC0C870
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D6CD40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:13:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YO4vl+zP;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788279215;
	b=EzKqMudZWbZviNPYgIj8I4Jpy+SbqgNMLDIZnlclSt/hpQfWrn+9yUfaQ9+hnh32bsL3Du
	D8UqfG4E1sIzjsOZJRn5CcE5U2IrX3Tvd382h2oz7sXAzDy8kmZEX8c4zWtRvEi+WqMs8X
	r5JLjRQ9LlI7ujtYMwBw4fVyeQ5Vw8U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788279215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONke0gJOgNHGc8+HNAj15P6+4xEqz5FFd8jzahTO8SA=;
	b=gtODDbuQtuu/5mPfvNleLqDqqs7TQx9Jbx1toJ7gV6detC5janDtRV89G/b1NfaiSjrtQJ
	ryXfI9xj+NCl4qbs/SWQoRC1qc/Q9pm22vC+vNze44PIUXPlVrwKycbabJG5F/6i2YrPGx
	Cq4O6r6eypPy/M1h1FDcbFBZLvZXkaU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YO4vl+zP;
	spf=pass (imf12.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-855de2d0d4dso49467b3.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788279214; x=1788884014; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ONke0gJOgNHGc8+HNAj15P6+4xEqz5FFd8jzahTO8SA=;
        b=YO4vl+zPuRk04Y/ShOq/QpWUdbtU4in8bRmuMJCfY12EHd3S6NGz9wvhTiVwzbjQNd
         8N1HVKspQCBVq504Lk2pW9qom3K1OcOgl59W1ypGO9mDSgVvucLRnr0Iq3v0zi5SCuFm
         wJroYsKjepEEIGeJmEU/HeHuEUFbov0uhO75BjdYqMYsLPs9rvQOvvwb+dfMU4gGK0fs
         jkQdcKP49pPZ0NP8Z5wqm4H2+fOhLglpLCjXrHqaMabycV8oOxm2F+QG5SUeS3Psm3Fz
         Ii+7KrbljSq0u9/32XkiGIK7iEA46GXNx2ZNusIPi4eVeAGh1VGgIbpNIrnM0nzCH91z
         y3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788279214; x=1788884014;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ONke0gJOgNHGc8+HNAj15P6+4xEqz5FFd8jzahTO8SA=;
        b=U9ANSiREHb0YeTccI3gIWp2BLwfyWKJCX8chusGDNzOJtzKhxfTD2VVdEpRsX1OKuO
         3hgyHssvteV72/Q5ICyqZfIYB1yVui2cF3duYMsfPwRfle1T8PkSNJi/PoI09K3py24v
         cMnaHpOnBdt5kb//Ikj2Jk3gCcB85RTxepz3CRDV0aC3+TCjMlaySSrIuYGYerzymzMp
         UmKuP2QTYS6hcD8QexocioWwBqjaPjZtwnvEmFoyGKNkC2KCYk87RoX3nQjGR3lyZw1p
         H8TMrkbeOYaoc2DAky1mc9so6KtRXgx/xeCeHVaUJjZv0gsV2//+njQDvBEs5FjYs5ag
         RByg==
X-Forwarded-Encrypted: i=1; AKwUvBzm2Xv/yKGDs2OFrp4QJ9ruEFb/SkqhbxtVsgVL/WzSqYbTb6Sj3wcWgwPc5NcS3Q5tFHyby+l1vg==@kvack.org
X-Gm-Message-State: AFuF++k9e5Oognv4r3GJ5pCheRh7eqvGk7UZEf9Yybye+Dab09l7J55v
	wgzFVwJ7T341Tx96clj8HMS1cZs1vlbncXWs3whPmW+6upoWY2BY9P97HRd/DHMPM/8=
X-Gm-Gg: AYBFou0oFhYoMRU6fhJXTcQsyuRqEc0p/38W9Fj7Jy+9fGMTor9Y9l2aG8Kox2bVSC5
	EtYr6wIjraPku+q1lo+31n1SwHdE39hbyxFnPcbvIj7wsqvQkpJjHTmsbO64e1GsSNPsp9LEeVf
	l5pigpPnwccYt3Ag9Aj/StctHM6lh0f/zbdVWeK2sXsyFVj28sI08910KdMFKMkoqjS5MqYuvrb
	9K2trXfsrIpARi2ym8XPX/3b/yUMK7qr0kVpqJvEnRtZ/K/DJX6qlS83BtINFM9Gyh3Gs7mClEd
	YXhp8l5ygWhdWiJgvK8hpOUfF52zRAsOHLs9MFZNmNJmMOI25rInXo+94S6Fq8mQzulmQyRKRVL
	d00JSZrR5WhqGnyZ/ESJvq94csSjgi5sAkk8u1RWUksZOHM6gyI8NuHFNAigi8uPxmA3QYFNSTO
	SyZHJqkRVbjfMxlsCcwNmRHW+oE4DwFwRKelywBKI1i0ZZNxyoc1D+Ga3bv8DV
X-Received: by 2002:a05:690c:e15c:10b0:861:850e:dd59 with SMTP id 00721157ae682-8694c637510mr20838267b3.9.1788279214223;
        Tue, 01 Sep 2026 09:13:34 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85e66abc938sm76771227b3.37.2026.09.01.09.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:13:33 -0700 (PDT)
Date: Tue, 1 Sep 2026 12:13:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
Message-ID: <20260901161329.GI3004@cmpxchg.org>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
 <20260830114731.8322-3-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830114731.8322-3-wujianyue000@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D6CD40004
X-Stat-Signature: p6b5beheccbyp8m3fudssr8jcwfuaa84
X-HE-Tag: 1788279215-963135
X-HE-Meta: U2FsdGVkX18vjDm8R9m3ImmolZKdtQ141lmMgYPLpsy9XCqqvJa62RKbFISQqQqThjkYR9EviAoGUbxWceIH7ozi9gYJvExjT5w9tKnqPB4ruVQ5fyUeN6Qe/9UsW//VB1UrFJT7tCtqOEVF+UeEM8FOUteYgBMcqVkLJnCA0x7BO5Udr5oIZKl1lribCIRoM/L9RCI28JeeJprTBEyV9NqBrnboLy8qnAwZyfeW3P/Kd0oh7CZFD9raZd6T7Zq9zAOVcCD6a7a6op9fTHkC35gYUX54eLra9mdtrk8Y9+YvW9gRwMZmfXUok9pPjvnIyFmeLa3ad4+3Zx9fnAya3mggcfQsflFnG1u3UHQ4p5IC6VctoVILpbF+HAZltC4J60TEBOQZfUl4tjim1EqlLdkHhDVz3OBu+RLJ5Q2pbFNjX3MS2JguQJveD8ilOIRYX/FS0CRJr8XNMRy40vJiZDiv25IL8oW5sTJ0fCfsrvvjclTe4xweWR0CRkf26F6cKErhH63frlY9t5/t9L2XhGXCCcQcf2Xl6gA/C1eMt6PHG90HbuDsi9gV7/nOemMD3DQPUxV6B1VhoysKs2FpOcoCngwu0CIOLJWPYsUspZxN2bFMcga0k5BOxWK8J70BERJAI4znMnEiWd7xCqTq4obXTj+jux6ERwo2vtnhkWjWV8EDNYBvxrb7sEgBZyzxvagHYuNZVGBHbBWY1MQ/HNALakY8rDVsgM9VSPry1nilnbwQiIYkwD+Y9nBS6UxkKh505e3ccQD7vNtEc1eqSqkfJqebdeppdnzi9Bjnz6Wpwnf7cfwCt4SLqodPlORpfDuZAtgvEzXZnSxur2hQ/4TrhzoPUjcJQygO9CRwbnYhv8CHbVBXUzPLASMjrDhAiNpNBN8SXdzn2hqhVHdQNkHCx8Mhj3gDsUMSXNZllJw3BuWTBLU4Wj/GWYKLCNLMEGeyFW0sjPgR+c4IFry
 vb7M/tCd
 egZFfmWqEaeReFAPCaW3WCpWB/H6RJ9wtG6+anFJhAFwQj6r/78Pb7GuB2SJA8SLt27sQdSNC+WY8qOleA/GpqJNcaKfEWQsVnC7NCP4Zy16sxLLMabsNKhNenv8WyK7vQvKijhpqLgs4Z9V6ww3Dt+OFiy9bKrFa7wDJaz6xE9O5NpcOVbfqobQ3i0Wgjtr2xObWQFJ3y0AEsUAS4qiYjx+TcUrm0cJytI0rHxwlpZdetb2PdhoDRIfkriFOBfb4mD2NpJP+QMkQM6+pXyx9Ke3jZUPJOiFhK+l8NLOuVqMgedHw//IPzyNZPil6UAiJJy9idbj0dCFx/b6uq8rc7mUcCVGhPSh3hkV9SpV5AMp2mO6f8+Z8lcDoHIzl3owSOVKOUPy8J+Y9njBDEIjACWamz27ARFrHMbNIbULD8ebN5Y7wRFtYT4yDW8g9yIO6kdSWRHRgMr5Q7JWM6uBQgRAeqeXBuetEdkEXTvivdRe0HXXzoZhXTrYipA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 07:47:30PM +0800, Jianyue Wu wrote:
> Originally zswap holds its pools on an RCU list whose head also serves
> as the "current pool". Only a handful of pools are ever live at once,
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
> so lookup and teardown stay equivalent. A fully-constructed pool is
> stored into its slot as the last step of zswap_pool_create(), so array
> walkers only ever observe a NULL slot or a ready pool. Pool creation
> is serialized by the module-wide kernel param mutex (all built-in
> params share one lock) and otherwise only happens during
> single-threaded init, so no two creators race for a slot.
> zswap_pools_lock still serializes the store against a retiring pool
> clearing its slot in __zswap_pool_empty().
> 
> Behavior change: the fixed array bounds the number of simultaneously
> live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
> whereas the old list was unbounded. A pool is only live while it is
> the current pool or still has stored pages referencing it, and pools
> are reused across compressor switches, so 15 is far more than any real
> configuration needs. Once all slots are occupied, creating a pool for
> a 16th distinct compressor fails: zswap_pool_create() errors and
> returns NULL, and the compressor switch is rejected with -EINVAL
> rather than silently succeeding. The cap can be raised by increasing
> ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).
> 
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  mm/zswap.c | 97 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 72 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0bb30e58950a..b3b5e2887c00 100644
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
> @@ -154,12 +155,27 @@ struct zswap_pool {
>  	struct zs_pool *zs_pool;
>  	struct crypto_acomp_ctx __percpu *acomp_ctx;
>  	struct percpu_ref ref;
> -	struct list_head list;
>  	struct rcu_work release_work;
>  	struct hlist_node node;
> +	u8 idx;
>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>  
> +#define ZSWAP_MAX_POOLS 16

It's unlikely to happen, but this is a super annoying failure
mode. User would have to kill something, delete shmem/tmpfs, or
swapoff. And it's not obvious which entries are in which pool.

Wouldn't an idr make more sense?

> @@ -270,6 +283,31 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
>  	acomp_ctx->buffer = NULL;
>  }
>  
> +/*
> + * Publish a fully-constructed pool into a free array slot.  Pool creation is
> + * serialized by the module-wide kernel param mutex (all built-in params share
> + * one lock) and only otherwise happens during single-threaded init, so no two
> + * creators race for a slot.  The pool is complete before it is stored, and
> + * zswap_pools_lock still serializes this store against a concurrent retiring
> + * pool clearing its slot in __zswap_pool_empty(), so array walkers only ever
> + * observe a NULL slot or a ready pool.
> + */
> +static int zswap_pool_assign_slot(struct zswap_pool *pool)
> +{
> +	int i;
> +
> +	guard(spinlock_bh)(&zswap_pools_lock);
> +	for (i = ZSWAP_FIRST_POOL_SLOT; i < ZSWAP_MAX_POOLS; i++) {
> +		if (!rcu_access_pointer(zswap_pools[i])) {
> +			pool->idx = i;
> +			rcu_assign_pointer(zswap_pools[i], pool);
> +			return i;
> +		}
> +	}
> +
> +	return -ENOSPC;
> +}

It was kind of overdue, but with this now requiring a pool walk as
well, it would be better to factor out a find_or_create function?

Something like:

static struct zswap_pool *zswap_pool_find_or_create(char *compressor)
{
	struct zswap_pool *pool, *new_pool = NULL;
	u8 id, new_id = 0;

insert_new:
	spin_lock_bh(&zswap_pools_lock);
	idr_for_each_entry(&zswap_pools, pool, id) {
		if (pool && !strcmp(pool->tfm_name, compressor) && zswap_pool_tryget(pool)) {
			if (new_pool) {
				pool_put(new_pool);
				idr_free(&zswap_pools, new_id);
			}
			spin_unlock_bh(&zswap_pools_lock);
			return pool;
		}
	}
	if (new_pool) {
		idr_replace(&zswap_pools, new_pool, new_id);
		spin_unlock_bh(&zswap_pools_lock);
		return new_pool;
	}
	spin_unlock_bh(&zswap_pools_lock);

	new_pool = pool_alloc();
	if (!new_pool)
		...
	new_id = idr_alloc(&zswap_pools, NULL, 1, 256, GFP_KERNEL);
	if (new_id < 0)
		...
	goto insert_new;
}	

