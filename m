Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F55606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFKY/8MX
Received: by kanga.kvack.org (Postfix)
	id 9D42A6B05B5; Tue, 10 Nov 2026 00:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC3E6B05BA; Tue, 10 Nov 2026 00:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA346B05BC; Tue, 10 Nov 2026 00:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 678956B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E265BA08E4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:02 +0000 (UTC)
X-FDA: 85418153604.08.4A21B3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 35A1C20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KFKY/8MX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290281;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69oLqmuGxt+NL0dKInY1lbvk0FXvpTklB51lvPKeQo4=;
	b=YN2rU14XFP1ajP9TYH4MqJ0tNihUhnQKmWACrVEIo8wtBf1WkVnAdMFBY46UituzR48kj3
	sMn2nGq6coo3Jq1dxB++WEBSp1oLy0lEqck/XsBTjo0CUJGxg4V9R4SNifGDJxQYB+mJDC
	hfXezedEeJWtYZZTfgU2kUaMWx4R4LM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KFKY/8MX";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290281;
	b=KEFy/g3ZWebh9mmA92wV36CvYL173GwDo7s8x8UKPS3hSpZ/LHXcf6yXf4vmX4vOROx7mr
	YlSQQib8KhItzsrVjN6u7NlnAieykrPViw8ShbAT1ICVMZ9WmvMh/FAad89eFR2ayQomhz
	5rjw1heE3Ho4Mw73C8uiOvhGIId/60s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E953408D1;
	Tue, 10 Nov 2026 05:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AACC1F008A1;
	Tue, 10 Nov 2026 05:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290280;
	bh=69oLqmuGxt+NL0dKInY1lbvk0FXvpTklB51lvPKeQo4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KFKY/8MXgqtTTKRHlhIfQMoVk+eoT1xCnW4fTEE9KOoiGZH4iMoDU0wtirA235sN3
	 myfdMFgauiZdyMfJ7nSmutsTy0BOwpR38l3p4pAUknwOhiFDNa1I8VkeKTxQJ8kvxy
	 lhhaPt0YHD4QD9eXxzE4RLGQfGiBIgrsffRNaPXEdxX+S8ZyUQmA/Q/uBHJ6yIBdEa
	 MzUNpstBB/pLsdCjVTchUN/103fciMxlgTPsRCxWK36iDpGsmKXwZq2VrBkH54Il1P
	 Kg6b5evc7Y9hHKzvFSkGpe0b1wauTVczuLrdanAMjyJJuVVSqVDNWC4DMkoFKBDE80
	 C0sHRm/FFPrPQ==
Message-ID: <sashiko-outbox-206360@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/19] mm: xswap support for zswap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Kunwu
 Chan" <chentao@kylinos.cn>, "Baoquan He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-2-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-2-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:57:59 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35A1C20002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: gg5zeqr8zwnkgrp4ik4p3ecs5mw4fo44
X-HE-Tag: 1794290281-595090
X-HE-Meta: U2FsdGVkX19q029NkhX5glTwO1GqCZcBDcl6hVzVthARdQRrtWOIbhe6KA6gst9d6vr3wriVubaIEY9q/eVkIumJI9llMNphh8CScTk5KyzwyPy1017+vxOYZaZYgiHMHxy686Xy5/Atq1yE8kxeII4P0NcWL1gGAMSoK1r6t78WS+oN1rNDdZnm3KwNWMppzNZtyH56gaSe531ukI5OigPfde1IxnUpYihS+lfohcIdLjBhs8CJUNBYxUocxngYicBaqK1K4fcgJV965VO9xytA83OsxaMzaXcE6XEC//u2HZVpXr+LSzc6On5Og8WioqgY1mqRVHJAp2JGwVrqbszlSFXYuVBX2xgWTewEWwQGfB1Nc//r1FS9QuaTnDkTtA7trL7KeZnbxlK0WhMTqmiqvzWeCfPvdObROM1B0OyQJGWHFQHOpGgKLhrPtzjctZYlDjk25incgxwSYugzbmM3TOA/wAcLOPRUgIp4zAj3lMo9yLoXyqFgrpuY/4s5z1sfpS9QKwhEtqgVOoeS1n53FFNML/DsCVjUKbQZnqWAwEvo6sO90UUT/1kFukHmhU1oDdonUlB0cgqSo/l9wNnAaHiBXxqSHh2kISycSzywh5uNR8a1l7oLuHGZ3seA8a/NkaKtI5Fq3Ns+m46okFyrWdT3wAk6aSjMzMQZ1zyBBPNMW2lUYIOIkJ/NPskPM+wI2tdpRIoKrK+1+rGvC/Cu9+teBa0f9U3mg8kBy1WK9aeqhbFUS1L/YtpldJU//jQlFPf6fiRP6WG8XmNyze7duhgjIjjgOFfzhmX8MgRz6ln4kgHfBDDMmehOGjc/D88IYfYC7sVve+ksQeLZNzHUoI4Hw8AAoJcQS7sSgJGQTf4c3ZIwb5eUcyVCdcGMInigfZ/nrq8E2qFlyxE0KGK8OsDsCERM3NVYRQ673iha/6earqB+JBUub08Yi5WaAFHVqG95SaX/KqPz0AD
 BJJXA2tF
 JaG9/FBh6mqsZd3ujv0YyKLQaP6DZQ1KoqDVw8mIbaIYxdx0PtK29AviN9ttdOSABLme/iMPsHDCXkai64SvRx9wL7oHUoa/Gbya3bP4i4ZljGy+LHmmKWhChPfmalOLmeL+uvC2KJCGHr0a3C9zyUDHEXijU2JHbrQ5/xdTBqeJOLBaVVbfSD5ABSvNA0jVMZxYI0lpr8iQ+yHdfuqVifRkWfKOePr3PcXvPtCVJpbypaJj6c0kOaV6eimvSP7apwpjBnhxNcs61D4g3Yaf7r85rVCsPLyWOn9JDnA4I8a7wmrluUPN/qZTe1Id1ye0H4ZBlCNsjYu5lcWfCUU06RCHnbU0FmJzvRBJMM+VbLV83sUpjYZWGiB+kbzIeYcWmXgXtMLA4LazpO/u1rKuAhTnmtYHcbVMbhoMp2lZa20sOBPRxgCfZd3zoFaKpF1lrOFtUZl6t+9EkFuFJftphVATeirkYvbomUi58IdalBiLZX76R2IDsOoHP6+8P2R2LY4PanEKbLdYNWUwPsN5z2zT4yAT9XPxuqqLvXnw0lDmkMMHBjvTahbg5Trbpt/0hsIKmxluRaWhOZKt0se/7gdOUwIxMJu1MWKGdNvuxnnYW7TzL8RgEZ6Xg3d59fyGUMRs1iHhMer4+SmInTyC66jKMmLmGv9jfcPSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/zswap: zswap_compress() stores incompressible SWP_XSWAP
  pages uncompressed
- [Medium] mm/swap_state: si shadowing and xswap neighbor readahead in
  swap_vma_readahead()
- [Medium] mm/zswap: infinite loop in shrink_worker() when
  mem_cgroup_disabled() with xswap
--

commit 5eef2108ac11c902b6d7f8f9358d479308d8aa73
Author: Chris Li <chrisl@kernel.org>

mm: xswap support for zswap

This commit adds extendable swap device (xswap) support for zswap,
keeping xswap entries only in zswap without backing storage, skipping
swap readahead and zswap LRU insertion for them, and gating zswap
writeback on active real swapfiles.

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index da65d75ceead1..4c965cf99809b 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
[ ... ]
> @@ -984,6 +988,7 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsi=
gned long *start,
>  static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gf=
p_mask,
>  		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
>  {
> +	struct swap_info_struct *si =3D __swap_entry_to_info(targ_entry);
>  	struct swap_io_ctx ctx =3D {};
>  	struct blk_plug plug;
>  	struct folio *folio;
> @@ -992,6 +997,10 @@ static struct folio *swap_vma_readahead(swp_entry_t =
targ_entry, gfp_t gfp_mask,
>  	unsigned long start, end, addr;
>  	pgoff_t ilx =3D targ_ilx;
> =20
> +	/* xswap entries live only in zswap; readahead does not help. */
> +	if (si->flags & SWP_XSWAP)
> +		goto skip;
> +
>  	win =3D swap_vma_ra_win(vmf, &start, &end);
>  	if (win =3D=3D 1)
>  		goto skip;

[Severity: Medium]
Can swap_vma_readahead() still perform readahead on neighboring SWP_XSWAP
entries when targ_entry is on a real swap device?

In the PTE loop below, neighboring entries in the VMA window may belong to
another swap device:

mm/swap_state.c:swap_vma_readahead() {
    ...
	for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
		struct swap_info_struct *si =3D NULL;
    ...
		if (swp_type(entry) !=3D swp_type(targ_entry)) {
			si =3D get_swap_device(entry);
			if (IS_ERR_OR_NULL(si))
				continue;
		}
		folio =3D swap_cache_read_folio(&ctx, entry, gfp_mask, mpol, ilx,
					      addr !=3D vmf->address);
}

When a neighboring entry is on an SWP_XSWAP device, swap_cache_read_folio()
allocates a swapcache folio and calls zswap_load(), synchronously
decompressing and erasing the xswap entry from zswap during speculative
readahead.

Also, the new outer struct swap_info_struct *si declaration is shadowed by
the inner si declaration in the for loop, triggering a -Wshadow warning.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37d217860a6b2..cef142d2ff856 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -1601,7 +1606,9 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	entry->referenced =3D true;
>  	if (entry->length) {
>  		INIT_LIST_HEAD(&entry->lru);
> -		zswap_lru_add(entry);
> +		/* No backing store: nothing to write these back to. */
> +		if (!(__swap_entry_to_info(page_swpentry)->flags & SWP_XSWAP))
> +			zswap_lru_add(entry);
>  	}
> =20
>  	return true;

[Severity: Medium]
Does zswap_compress() store incompressible SWP_XSWAP pages uncompressed at
PAGE_SIZE when cgroup zswap writeback is enabled?

mm/zswap.c:zswap_compress() {
    ...
	if (comp_ret) {
		rcu_read_lock();
		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
			rcu_read_unlock();
			goto unlock;
		}
		rcu_read_unlock();
		comp_ret =3D 0;
		dlen =3D PAGE_SIZE;
		dst =3D kmap_local_folio(folio, index * PAGE_SIZE);
		mapped =3D true;
	}
    ...
}

Storing PAGE_SIZE entries in zsmalloc exists only to preserve writeback LRU
order, but SWP_XSWAP entries are not added to zswap_list_lru and have no
backing store.  Accepting incompressible SWP_XSWAP pages wastes zswap pool
capacity and metadata on unreclaimable entries instead of failing
zswap_store() so swap_writeout() can reactivate the folio via
AOP_WRITEPAGE_ACTIVATE.  Should zswap_compress() also reject comp_ret !=3D 0
when the folio's swap device has SWP_XSWAP set?

> @@ -1671,7 +1678,7 @@ bool zswap_store(struct folio *folio)
>  	zswap_pool_put(pool);
>  put_objcg:
>  	obj_cgroup_put(objcg);
> -	if (!ret && zswap_pool_reached_full)
> +	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
>  		queue_work(shrink_wq, &zswap_shrink_work);
>  check_old:
>  	/*

[Severity: Medium]
Can shrink_worker() spin in an unbounded loop when memory cgroups are
disabled (CONFIG_MEMCG=3Dn or cgroup_disable=3Dmemory) and the zswap pool is
filled above the accept threshold by SWP_XSWAP entries?

mm/zswap.c:shrink_worker() {
    ...
	do {
    ...
		if (!memcg && !mem_cgroup_disabled()) {
			if (!attempts && ++failures =3D=3D MAX_RECLAIM_RETRIES)
				break;

			attempts =3D 0;
			goto resched;
		}

		ret =3D shrink_memcg(memcg);
		/* drop the extra reference */
		mem_cgroup_put(memcg);
    ...
		if (ret =3D=3D -ENOENT)
			goto resched;

		++attempts;

		if (ret && ++failures =3D=3D MAX_RECLAIM_RETRIES)
			break;

resched:
		cond_resched();
	} while (zswap_total_pages() > thr);
}

When both a real swapfile and an xswap device are active, zswap_store()
queues zswap_shrink_work once the pool is full.  If zswap_list_lru is empty
because the pool is occupied by SWP_XSWAP entries (which are not on the
LRU), shrink_memcg(NULL) returns -ENOENT and jumps to resched without
incrementing failures, while the !memcg termination check is skipped
because mem_cgroup_disabled() is true.  The worker then loops until
external swap frees or faults bring zswap_total_pages() below thr.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D1

