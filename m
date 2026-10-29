Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0000B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hPl7XYHJ
Received: by kanga.kvack.org (Postfix)
	id 7196C6B05B5; Wed, 28 Oct 2026 23:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0396B05B6; Wed, 28 Oct 2026 23:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606CB6B05B8; Wed, 28 Oct 2026 23:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33DEB6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:06:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97BEC140254
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:05 +0000 (UTC)
X-FDA: 85374174690.12.1C05330
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0316380002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPl7XYHJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4b2oq+C40ech5OdXcId7EI0kRc6xwtJPfUMQW1KODYw=;
	b=Y4fqshqZN19xgLoOg4edlimTDIMLFif6A+x5rYtmPylyiITxwhxg5a3psqdy6UMkDgEhaW
	BnGBwutbj1IutfhB4U6Fv7zOIedmZp6t3Jg5dkVjpmFgCDgK8/W/o5X7iyfVTSJMn1GWOe
	Ks/O03EI3WoUTsOopPKUlS0L1cWCltk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hPl7XYHJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243164;
	b=WsWcEHVbExbi3Mb3VxwwhQSOEym4hFRNMuppXFnCm/+qRspF3o8SECr3dszVzGL196AZvZ
	DSbA4B33W0Y7hkWgmC/Mpn0H6TkID+InS6CpWY5/LkBQgxYvTpk1xqBdR6RwS0LwkVFp3n
	gd9b84b2yH0U3d4f0Xn7ZoXOACJW5VM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C9CC43F94;
	Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855271F01825;
	Thu, 29 Oct 2026 03:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243163;
	bh=4b2oq+C40ech5OdXcId7EI0kRc6xwtJPfUMQW1KODYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPl7XYHJpJn7ap/pINv2UtZVTwWe/12yxeaSjN8U6hwdQuzfn4bGO5V7v7FNim7nW
	 MCN+EL08pG3FrIr+yayVaOCXyx5l2U4DQXwriPGGrJUteNkYmFOypYDPMmFHJ6OD2F
	 8UvIeAT+A07FcSfs1d00NI9odg/vVQHJl8rCrk2TUOyLAWgKcnd/0IoI8ONDlgF127
	 JdEfdRUcD4YgDL3jw1hpX5ukxf8mSCTovc7AvHUlU6HjoSkoi8ntxz0gs64Nii96vw
	 ds7zsErrHV6RWs6q/YTKDXMFWki/VvtSbAGjPyl1SYf9HMoNlPgiCcluXGWNJTvO0C
	 yL0Bqqql3mlMw==
Message-ID: <sashiko-outbox-188657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:02 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0316380002
X-Stat-Signature: rpfdp6g4a339g8cuniyhb1mkaiwkfpxf
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793243163-772638
X-HE-Meta: U2FsdGVkX1+8fUBg8iFFlRy1iZdDdKdgCgVFvPCN1DziYNpwE28U8BnKqly9L4f+lfhOsq0XFdc8OfuGMiq05MoBn/k5fmLQgBrf6hrxHljO5L+AnjRcseQFewQPrIyZNl9xwS8HdR/tyj6nZJlmUMQADmMX3SV4CvOJLmrnkJ4ZZw31xzSsYMpnHCKycuXCzWW8WBM+B8PCos+hmvfh1r/FZgV7JlBi6XmiGnUejQprLhLU55OUCF/MbrFybEIwtJTCLrXi7gh1h0qYIzux6hWS/BzuuIW3jrGP2HwkwpSP8JdeNGhsCse9ZTTcTPNdQOoFG9eBgGXbizSepqXVIG6NoP6IR5L0gvRpFkxoDgTfYpYuRD5yC/u3gNf5eEDgkzHdFFv6lWU5KXtFsLQij4pjJFG0whS8P7oDxWxT/RcfRWBAqcUDm2kNOhm8J4qnMSOmJFsdWea45FZbu2wwhP35k+vCyxR0BKAwNTEhJ3PVjOshwsjDJ0WmPS1PMMnrUpm0Odl5siAKvWuCwrhDXhChWnrIikPu3otFUwDRjMaL5M4vhZGvPh9sUzOjduKJbkOL7wTVaP43nWty7OYgfUPZjdPRVZIhqjLpFwnQ/yUSiwfr/0WJwUoaK1wHh5PW9ak63+vpgkWKHrBVJgJKM4zSSl3xR70KPaIDQqjTrkIXGPL7tAa5LxrnK059kpo1W6OmckGcDV4hAu84RbKNkE/4MWG3s6p4d4nTEqza8MJYpN9wsFXZuQQ+4sgmlD6QMDzynElCiMgcqwqm3Al8NNp+Zs42s5WhRnzuMFmnZ0GNAYGKOklUvi5DcUeI9ZsIXkgLZzkncPw3pcL5ci2kZvfRkKrwMhWhm4EYUDwOWO9MednEudSC4K7a1liu6YPeXqMjS78duEXGn5klE2jEGliWaaSCcZX4kqHy9yPFJABQYzqmBQIg06qrAV1IW+d0UfCadh/9A5E5RZEmVTm
 CDrEzysS
 vwDxMCbSNubrgjlZVONqt45U7K6SrjX990HTyHVin5KfRPGR3TazWcjKBOrIoovD2Z/NQ8dbGTDGlMzxPH/zsk//1lE+6BNfhz9Zv3ozcVsf3aPB2WYBgaO2t2Wy3iYIol7/GGoBnZBZvJLhEO3pay+YNadNzCuaAbjxQlW+e4YUxUlHT06kIU97JosXg77durj6RoMv+RFlvwj/I29JspqIS0N33Nq4HJeBU8+HSA0Vu4SVrr1RjNkc7KDc39rTsE6b0PrIIhTT3HXwwPVqDbvE9b0hLZKAoZkwGg5rcLW6bsdHjZMTYbk6Cx+I5dvxLTJ4yY7OqOTxhNWmsLPV/TPaHCUrddVQLLTEVjrJQ5QsFDML5ywO6T8ab+9O/0FaiSQSPLdssb29plsc9gex4I1lFqzA1NeQ1JxEcE/v5LvkE1Qg9LQ9pC4fuv4Jaf/D3jkzzWyt6n7wzANpfZOUd210tVQ08ClXjXgyens1b0ycI3qftCjC09MogMJuHZjtZXpWC9LKLpvcU0OQr1SJPlsKCvrUngOO0/B2ro0DkGn2a3Gpok5RgFqBDOcIvUPhtYh8K/laKEG56cBRxDLViPNBUkzvzGqg/v7clo7TVTudVvIPcAhS7pWuKp1wX6mAa0p9PERGnS2yayjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: zswap: off-by-one bitfield width for zswap_entry.length on 256=
KB pages
- [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in zsw=
ap_list_lru
--

commit c4aa889f59a75fcf871276fd68b4a4738afe132b
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the folio's NUMA node ID directly in struct zswap_entry
instead of deriving it from the slab page backing the entry, and converts
zswap_entry_cache_alloc() to use node-agnostic slab allocation. To keep the
structure size unchanged, it packs length and referenced into bitfields.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index e1d57a7d95950..19b7d60bc7d2a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -180,6 +180,7 @@ struct zswap_pool {
>   */
>  #define ZSWAP_FIRST_POOL_ID 1
>  #define ZSWAP_MAX_POOL_ID U8_MAX
> +#define ZSWAP_MAX_COMPR_LENGTH_SHIFT 18U
>  static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_=
BH);
>  static struct zswap_pool __rcu *zswap_current_pool;
> =20
> @@ -206,15 +207,19 @@ static struct shrinker *zswap_shrinker;
>   *              logic if referenced is unset. See comments in the shrink=
er
>   *              section for context.
>   * pool_idx - id of the zswap_pool that the entry's data is in.
> + * nid - NUMA node id of the page for which this is the zswap entry.
>   * handle - zsmalloc allocation handle that stores the compressed page d=
ata
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> -	unsigned int length;
> -	bool referenced;
> -	u8 pool_idx;
> +	struct {
> +		unsigned int length:ZSWAP_MAX_COMPR_LENGTH_SHIFT;
> +		bool referenced:1U;
> +		u8 pool_idx;
> +	};

[Severity: High]
Can entry->length overflow to 0 when storing an incompressible page on a
kernel with 256KB pages (PAGE_SHIFT =3D=3D 18)?

With ZSWAP_MAX_COMPR_LENGTH_SHIFT defined as 18U, the 18-bit unsigned
bitfield can only hold values up to (1U << 18) - 1, whereas PAGE_SIZE is
(1UL << 18) when PAGE_SHIFT =3D=3D 18.

When an incompressible page is stored with writeback enabled in
zswap_store_page() -> zswap_compress():

mm/zswap.c:zswap_compress() {
    ...
	if (comp_ret) {
		...
		comp_ret =3D 0;
		dlen =3D PAGE_SIZE;
		dst =3D kmap_local_folio(folio, index * PAGE_SIZE);
		mapped =3D true;
	}
	...
	entry->handle =3D handle;
	entry->length =3D dlen;
}

Assigning PAGE_SIZE to entry->length wraps the 18-bit bitfield to 0. In
zswap_store_page(), entry->length =3D=3D 0 then skips initializing entry->l=
ru and
adding it to the LRU:

mm/zswap.c:zswap_store_page() {
    ...
	if (entry->length =3D=3D PAGE_SIZE)
		atomic_long_inc(&zswap_stored_incompressible_pages);
	...
	if (entry->length) {
		INIT_LIST_HEAD(&entry->lru);
		zswap_lru_add(entry);
	}
}

Later, zswap_entry_free() unconditionally calls zswap_lru_del(entry) on the
uninitialized entry->lru list head, and __zswap_decompress() fails on swapin
because entry->length =3D=3D PAGE_SIZE is false.

Should ZSWAP_MAX_COMPR_LENGTH_SHIFT be at least 19U (and the check in
zswap_setup() be BUILD_BUG_ON(ZSWAP_MAX_COMPR_LENGTH_SHIFT <=3D PAGE_SHIFT)=
) so
that entry->length can represent PAGE_SIZE?

[ ... ]

> @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *folio, =
long index,
>  {
>  	swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
> +	int nid =3D folio_nid(folio);
> =20
>  	/* allocate entry */
> -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> +	entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		return false;
> @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
What happens during cgroup or pool reclaim in shrink_memcg() if the swapped
folio resides on a NUMA node without normal memory (for example, a
ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?

Previously, entry_to_nid() derived the node from virt_to_page(entry), which
was allocated from slab with GFP_KERNEL and therefore always resided on a
node in N_NORMAL_MEMORY.

With entry->nid now set to folio_nid(folio) in zswap_store_page(), anonymous
and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry->nid
that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() inserts
those entries into zswap_list_lru for entry->nid, but shrink_memcg() only
walks N_NORMAL_MEMORY nodes:

mm/zswap.c:shrink_memcg() {
    ...
	for_each_node_state(nid, N_NORMAL_MEMORY) {
		unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;

		shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg,
					    &shrink_memcg_cb, NULL, &nr_to_walk);
		scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
	}
}

Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY so
that entries from movable-only or highmem-only nodes can be reclaimed by
shrink_worker() and mem_cgroup_try_charge_zswap()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D5

