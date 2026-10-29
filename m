Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EB27606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f4H6u6uS
Received: by kanga.kvack.org (Postfix)
	id 236D46B05C3; Wed, 28 Oct 2026 23:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E9C6B05C5; Wed, 28 Oct 2026 23:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD3A6B05C6; Wed, 28 Oct 2026 23:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9EA36B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:06:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C311120277
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:10 +0000 (UTC)
X-FDA: 85374174900.21.337F05C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD8FB40005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4H6u6uS;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243168;
	b=st8l2Cnf44ZgzPJKgJm34ok9emwamLedYaLKuz2L/UtmIRw3OQsnQwZNj4PCbaW6kkSXsy
	Tf2sthpn615RrGwFsQw7CitJdrMNd4Bp3XeThoz/33oieWMzwyRoU/kjywDmjjnGqFFB1n
	ZathsOqB0LDgdCMP0yEGEhOmj3KnMpk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4H6u6uS;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dg25BgxFGSV/7KzMd5a+B2MZP7K+5YjP4f1EapzV/AA=;
	b=tqNzC1pZriZCa6oMovY4Gk3S6opgyYVErohGe2EykMfMESg3VT8ApGzdCKUaidzkdZQ6d6
	r20oYSopbe118prCrYz4HlY2wtgCsQ2Y+yfKoUvGIsnpezwaO+kwaF4+hgIFtSEUMWGx7N
	OdLo6cNIwLg3G6UWQ4Frout8zWlsulw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EAB8601F8;
	Thu, 29 Oct 2026 03:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDF21F01825;
	Thu, 29 Oct 2026 03:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243168;
	bh=Dg25BgxFGSV/7KzMd5a+B2MZP7K+5YjP4f1EapzV/AA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f4H6u6uSKK5taYF4vmJjs5dY1/zILldoJf/dOrZyzyxeimIgn0EHHsJAPD0HhteC9
	 +xwMhC0YJTSONSwJX2irqTUopSTsqt9iUW/yWeJlAHQMqN9xU+L8FHgxWxIEwZpW37
	 ZtKS1xSjiMH7D54Z52ohcNALeZwVuX9wxWux5MsiJ6LAjEy/aeDM6HYo5l8NigfbnS
	 DcaZnLvAONdM89UG9aHKDwsPEYWv4SrqmvnevAoaLLDVFyikCujYeM+kK/57We+ojH
	 Golm4T7bpj7NiriavCAjT6y9k53Jy5YaOvjoqcINxi72W11rKzcPLzdqg5uDIpnwcM
	 A9kJm+GLIpptw==
Message-ID: <sashiko-outbox-188660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 8/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-9-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-9-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:06 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: CD8FB40005
X-Stat-Signature: yti8drysrua6dsz3re3qasszi3cp8t9m
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793243168-321177
X-HE-Meta: U2FsdGVkX1/HtFk4zvBaoCFmoDxJIkfOgpjQTOsVDuI43oAf9TY2VJMPc7PrHWa/70NgY3x0hOgAcEllxTdzixLE2giHa2pPVKnGRil3EvrEV612KcVyXRJWHvdLF/xReDcSTbJfnNk/NGthAnNjFYIiIm5DED7H+0Zms7YwwVz3iFhyh7bWuxqStLRAi+EYLkwv1vypQQgW/Y5ztUDc+valnClY9V9/hjWFT7O6TbmZjSGSpM9XeUE6IirQwSGm/wGaRY/wHFL/9hXcW/ppVhnoLU58TZsqQWGiU13CQQWmCpZ4sjYLCy2R8C8/kqwAyo2hQt7S3JJBCDrGHdyow5aAM86bm0igrpNcpHogGzOwI9EfMaaC320ypi0z05Rq/6/GG8V7klf6KCepHBGnpD31IcoT7JTY+tsmmaFepGXnHhthVCmAhfso0wAWYFq/kvLcCecQXRJygSQTBLYf5Kk1zO0MJXFz1YhdwCJVW7o8JouzNZM8mwh/e0IPfbM0ufrdahFIJ54zb59alEsVs/s6lounFGaw9UrTHP326cqnjKeydIPYkcyeGnfvu/GRTvnqkgBnuL/OOt+XPXFnBtHDOJ+gm83bY0/0OzJdzJkEHquk89msE3kxULaNdtdjKBrVOTZcA2cORozjxjBtVj6MZaaZCOL+gJh3rc3ABwItiYSFHVeO0om4PiTkrS4QvcOF1WzkGJsn+d6ynddKf7NHWESWvRnZw8fEIFMnfLQ2peEoTT9AmmfMe6P7/+8PtGndy0cwVJp0KI3DR88oZj8QRnsjuWshVxNlgPWc+MD3EO5v/vPuPBwQ5yGWo8axkj1ooSyG+U99iQYjhc8boHowXy40XHU0wRxvohc2C8Id7BI4heFkEnyDAXkH7K5b3V6/FUicm55Oq1ALNe4vfMM9zvhzifqmV8XO5meuOioFPxXwLcvizSLHNk7XXl4eUvZ4GFIGAKhLggWX0sB
 yYxuyaRs
 SsipIY0fwyaMENbg/eggUmlLXTFemnFIuQAMQABJDW638ypdfhSK3Fb9zbVsT6FL29VWMUQpJxVdDqAJW4nveCjNyMlvHlmkc+Y0dy0ZpKPHGaArJZIuMMVRaV1I2j45R/jmFwJM5UqGC4/wE1rgelQZkXH9rlkpOV0wYVyOlK2rpGa1jx+lbX9ATIcKFPixJtkGZ2xfGsrliokNa9q4NCITG1PcRmNlFAjztFyNklahyh5cghbR3UnwObd5YRvx3N+vDoPqd3wYaw6xID5omYRZ5bU0M5BDkSwsQWr3zz6uXuJQEvVqyl7wCIxkryNs/7n+JUCDNfDEU3ucxk1pgwVI5uLx5IpGeXfhbl4VqnuZSLwZApFFLIEUqJTDMgWFaRcwGvc0TjmczsyYkUN9n9UQWb0FnGpEfuGL4lBOevqpI4+ZsPrR80yzsmCDHMl6htRGlMRp30nkKK2Zx1m00aKiYY3BVFBfyFnySqM4U9FiWwK6dHVM7LPUYFY2JL3LgHwoBQgH45C1LitPImABuRmNQl1jQKNjDCuuuWg/cNSTD4kdHUlRfnfYdpHEyH2ZUe06KqMZOQCCEwDyCakrniEZ0w8b9ovI//bVCjYnluZYJbIU4qwG4+AFsTHRyGh3ciWJfsFrviTAjP0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: zswap: memcg counter corruption in zswap_account_stores()
- [High] mm: zswap: missing zs_free() of prior sub-batches when zswap_compr=
ess() fails
- [Low] mm: zswap: unused zswap_pool_get() retained with __maybe_unused
--

commit 5a1c181c752a45f404bc7cfeb7961fd6accb0903
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Refactor and optimize zswap_store_pages() batch operations.

This commit refactors zswap_store_pages() into smaller helper functions
(zswap_init_entries(), zswap_tree_stores(), and zswap_account_stores()) to
process batches of pages when storing a large folio. It also batches pool a=
nd
obj_cgroup reference counting, memcg charging, and zswap_stored_pages updat=
es
across the batch.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4476fb4aeb5fd..2831284cfc903 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -504,12 +504,18 @@ static int __must_check zswap_pool_tryget(struct zs=
wap_pool *pool)
>  }
> =20
>  /* The caller must already have a reference. */
> -static void zswap_pool_get(struct zswap_pool *pool)
> +static void __maybe_unused zswap_pool_get(struct zswap_pool *pool)
>  {
>  	percpu_ref_get(&pool->ref);
>  }

[Severity: Low]
Since the only call site in zswap_store_pages() is replaced by
zswap_pool_get_many(), zswap_pool_get() no longer has any callers in the
file. Could zswap_pool_get() be removed outright instead of marking it
__maybe_unused?

> =20
> -static void zswap_pool_put(struct zswap_pool *pool)
> +/* The caller must already have a reference. */
> +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
> +{
> +	percpu_ref_get_many(&pool->ref, nr);
> +}

[ ... ]

> @@ -1750,24 +1732,30 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,

[ ... ]

> +static inline void zswap_account_stores(struct zswap_store_context *zc,
> +					struct zswap_pool *pool,
> +					struct obj_cgroup *objcg)
> +{
> +	size_t total_batch_comp_length =3D 0;
> +	u8 i;
> +
> +	for (i =3D 0; i < zc->nr_pages; ++i) {
> +		if (unlikely(zc->entries[i]->length =3D=3D PAGE_SIZE))
>  			atomic_long_inc(&zswap_stored_incompressible_pages);
> =20
> +		total_batch_comp_length +=3D zc->entries[i]->length;
> +
>  		/*
>  		 * We finish by adding the entry to the LRU while it's already
>  		 * in xarray. This is safe because:
> @@ -1778,20 +1766,78 @@ static bool zswap_store_pages(struct zswap_store_=
context *zc,
>  		 *    The publishing order matters to prevent writeback from seeing
>  		 *    an incoherent entry.
>  		 */
> -		if (likely(entry->length))
> -			zswap_lru_add(entry);
> +		if (likely(zc->entries[i]->length))
> +			zswap_lru_add(zc->entries[i]);
>  	}
> =20
> +	/*
> +	 * The entry is successfully compressed and stored in the tree,
> +	 * and further failures will be cleaned up in zswap_store().
> +	 * For the batch, grab refs to the pool and objcg, charge zswap memory,
> +	 * and increment zswap_stored_pages by @zc->nr_pages. The opposite
> +	 * actions will be performed by zswap_entry_free() when the entry is
> +	 * removed from the tree.
> +	 */
> +	zswap_pool_get_many(pool, zc->nr_pages);
> +	if (objcg) {
> +		obj_cgroup_get_many(objcg, zc->nr_pages);
> +		obj_cgroup_charge_zswap(objcg, total_batch_comp_length);
> +	}
> +	atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> +}

[Severity: High]
Does calling obj_cgroup_charge_zswap(objcg, total_batch_comp_length) once p=
er
batch corrupt the MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP counters when
zc->nr_pages > 1?

Looking at obj_cgroup_charge_zswap() in mm/memcontrol.c, it assumes @size
represents a single page:

mm/memcontrol.c:obj_cgroup_charge_zswap() {
    ...
	rcu_read_lock();
	memcg =3D obj_cgroup_memcg(objcg);
	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
	if (size =3D=3D PAGE_SIZE)
		mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
	rcu_read_unlock();
}

When a batch of zc->nr_pages > 1 pages from a large folio is stored via
zswap_store() -> zswap_store_pages() -> zswap_account_stores(),
MEMCG_ZSWAPPED is only incremented by 1 instead of zc->nr_pages, and
MEMCG_ZSWAP_INCOMP compares the summed total_batch_comp_length against
PAGE_SIZE rather than counting individual incompressible pages.

Later, when each entry in the batch is freed via zswap_entry_free():

mm/zswap.c:zswap_entry_free() {
    ...
	if (entry->objcg) {
		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
		obj_cgroup_put(entry->objcg);
	}
    ...
}

obj_cgroup_uncharge_zswap() is called once per entry, decrementing
MEMCG_ZSWAPPED by zc->nr_pages total and decrementing MEMCG_ZSWAP_INCOMP for
each entry whose length =3D=3D PAGE_SIZE.

This causes both MEMCG_ZSWAPPED and MEMCG_ZSWAP_INCOMP to be miscounted and
underflow, which also breaks zswap_shrinker_count() where MEMCG_ZSWAPPED is
used as nr_stored to scale reclaim targets.

> +
> +/*
> + * Store multiple pages in @folio, starting from the page at index @star=
t up to
> + * the page at index @end-1.
> + */
> +static bool zswap_store_pages(struct zswap_store_context *zc,
> +			      long start,
> +			      long end,
> +			      struct zswap_pool *pool,
> +			      struct obj_cgroup *objcg)
> +{
> +	bool ret;
> +	u8 i;
> +
> +	zc->nr_pages =3D end - start;
> +	zc->folio_start =3D start;
> +
> +	VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX_BATCH_S=
IZE);
> +
> +	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
> +		return false;
> +
> +	zswap_init_entries(zc, pool, objcg);
> +
> +	/*
> +	 * Locking the comp_ctx mutex once per store batch results in better
> +	 * performance as compared to locking per compress batch.
> +	 */
> +	zc->comp_ctx =3D &raw_cpu_ptr(pool->acomp_ctx)->comp;
> +	mutex_lock(&zc->comp_ctx->areq.mutex);
> +
> +	ret =3D zswap_compress(zc);
> +
> +	mutex_unlock(&zc->comp_ctx->areq.mutex);
> +
> +	if (unlikely(!ret))
> +		goto compress_failed;
> +
> +	ret =3D zswap_tree_stores(zc);
> +
> +	if (unlikely(!ret))
> +		goto store_pages_failed;
> +
> +	zswap_account_stores(zc, pool, objcg);
> +
>  	return true;
> =20
>  store_pages_failed:
> -	for (i =3D store_fail_idx; i < zc->nr_pages; ++i)
> +	for (i =3D 0; i < zc->nr_pages; ++i)
>  		zs_free(pool->zs_pool, zc->entries[i]->handle);
> =20
>  compress_failed:
> -	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
> -				       zc->nr_pages - store_fail_idx);
> -
> +	zswap_entries_cache_free_batch(zc->entries, zc->nr_pages);
>  	return false;
>  }

[Severity: High]
Can jumping to compress_failed when zswap_compress() returns false leak the
zsmalloc handles allocated in earlier compression sub-batches?

In zswap_compress(), pages in [0, zc->nr_pages) are compressed in sub-batch=
es
of zc->nr_batch_pages (which is 1 for software compressors such as ZSTD or
LZ4 when zc->nr_pages is up to ZSWAP_MAX_BATCH_SIZE):

mm/zswap.c:zswap_compress() {
	for (batch_start =3D 0; batch_start < zc->nr_pages;
	     batch_start +=3D zc->nr_batch_pages) {
		...
		err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
				      &zc->comp_ctx->areq.wait);
		if (unlikely(err && !zc->wb_enabled))
			goto compress_error;
		...
		ret =3D zswap_update_entries(zc, batch_start);
		if (unlikely(!ret))
			return false;
	}
}

Each successful call to zswap_update_entries(zc, batch_start) allocates
zs_malloc() handles for zc->entries[batch_start .. batch_start +
zc->nr_batch_pages - 1]. If a subsequent iteration with batch_start > 0 fai=
ls
at goto compress_error (when !zc->wb_enabled and a page is incompressible) =
or
fails in zswap_update_entries() (which only frees handles in the current
sub-batch starting at batch_start):

mm/zswap.c:zswap_update_entries() {
    ...
		if (unlikely(IS_ERR_VALUE(handle))) {
			...
			for (i =3D 0; i < comp_batch_iter; ++i)
				zs_free(zc->zs_pool, zc->entries[batch_start + i]->handle);

			return false;
		}
    ...
}

zswap_compress() returns false while zc->entries[0 .. batch_start - 1]->han=
dle
still hold allocated zsmalloc objects. In zswap_store_pages(), jumping to
compress_failed then frees zc->entries back to the slab cache without calli=
ng
zs_free() on those handles.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D8

