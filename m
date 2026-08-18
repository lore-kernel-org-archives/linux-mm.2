Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE091C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039DB6B0594; Tue, 18 Aug 2026 14:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C896B0664; Tue, 18 Aug 2026 14:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D7D6B06E1; Tue, 18 Aug 2026 14:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE5546B0594
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:28:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DE911C06C3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:28:39 +0000 (UTC)
X-FDA: 85115225958.07.96C2C18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CAC940003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:28:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeHIwqYk;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L8XS/M8UIugRp9h76f20f/MXfnL3N+htoo+qe2xUNM=;
	b=2IAU36ZoqETtrXmOX++vID6WWJAZhwloB1i62ojIcEskhYwlsqZAGuzkcagpP3NalX8tF1
	naJZ2JUdlfIXxCtIULTdO7ZXboqJJbUH8f+k2VayYUUNVuaXbtCq+iXFeUdjINWY4sWle3
	98kjjGGKWQWeXrPJXsJQg36oL1BjL98=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeHIwqYk;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077717;
	b=S/Kh+PL1XjKybpgh1XumVw9kDFm7e5YPfBh4+A5tnvDOQnI8FBUGlYFKR/PVdzTHjquDPL
	H3VH+Lhs42RaHHAa0ObNuKcCEw8VYMW3rEqiBSTnXGQQIMszwy0yEAGJkfW3Hrr6ilsh97
	buiXyVlO+HkCb+1iCH8jO8RU6TFm1yE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57DF9601DE;
	Tue, 18 Aug 2026 18:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA981F000E9;
	Tue, 18 Aug 2026 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077716;
	bh=3L8XS/M8UIugRp9h76f20f/MXfnL3N+htoo+qe2xUNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oeHIwqYky9kKrqi3hUu0ofGI0att8GT5xTFvPoodQ5V2wQFEBaemfZ9xg66dQfYC8
	 NZDtrJ1ZdKJhO8UFlg4vN0tSnfKIT8AgLFR2qAqg4HdxiEgwmwrr4Uvm0QirFASGrC
	 K/VKTANzc/tks5GNslS96WzYTsB+9kpdaoQe234qEKtxUnBzaW+PAj1eH1W2AvMcJL
	 fhlkjv7ag4YXjPi54KQ9VnaHcwWifj6AbmksmLMM3a6UIOWIMoMfWn5I55dFuPzqQJ
	 KjdcDu1M3Blpncs9GF0TkCcEMQksFYEQG07QSqWvBWe2nRtaiXQx+gJBDsbS4A0EXB
	 nprPySEWklNFA==
Date: Tue, 18 Aug 2026 18:28:33 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
Subject: Re: [PATCH v6 05/12] mm: zswap: add range lookup for large-folio
 swapin
Message-ID: <aoSd8iovG5QKc6mT@google.com>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-6-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818131202.494754-6-usama.arif@linux.dev>
X-Stat-Signature: t5dh596kurum8kchnwo6k4d51jejp113
X-Rspamd-Queue-Id: 8CAC940003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787077717-625120
X-HE-Meta: U2FsdGVkX18lemxec1PKUPZ6UQESgNpky5g8ztFyF27Av8TvO7tdf/scHok5OSlMZyD8ChTIxbn7GmT7JT3F/GMnWBC+IV5SlDIFWk4qsVNc6JdCwnlFh1lZG8ciTwBiunAXKIXIHlK/nnFFNJUEAYv3YCWcdJW0S2VOTjEJCUZApv4OTTRReupxlcEXN8iaEH8zwEPFumb9DULIaTNVjbKhrm+QqVweJJGzRobc4CkcAeoedyNvB6Q+OA2fmMmzikXYH4z0IB2WfsReKuXFXLXy5plIrZ4uf2DoL+B8tI3/Uzkp9YJL4HrqhXKvf7nov9iRkvssaPGac10ox1vvWekrnFgkxQm67hZZcyz4DhUrP6qmEOlqUan6fHdQS7nY1WQcEkflui83CV7c3sDxXXm3W0pVXNA0IzB42mmvuMtRArO8+LZpy0hgBkurvcN7YerykAZm+JZ012CPFQFw8Lsc/3Id3aMpMbL1H4eqVIrL4+CjsusDCWRROjCOHgvRDE/tUcH4mtEhXKo7nNrE674dlz3+q6hw701nhXKIf5DP8Ni0VJJSQT5pmnblteGlScXQw030ZBma4J/YIL41GKZxtm3H/nLSKhMlBSt+HdmmrE4bMCapSZHrJdKanBST88q2Ngv2CvgEedlUT9N6adWWTVU7zwXY5P5g0xKZUJfHXaHv63wMEbdKT9wI7LDaxl4v9Tlfe0E1TDA7pHWujqmHK59QAZBbzBhJDDUrnR9w9GxvQjS6DZmuUohn3YJ0nAuOX7VrcTHgo3L70CZhiV+j68L7tTmh7kv4Uh9ooUtFJ0LTOqCFTQ9HKkNry0Ag9pbFeWuB0OQlr0NgBQLlIEzdBxXOEclfKYzUwQJc6+Tm0qfOvkN1oYOpVe4kIP6cZRX3yfxY0ciqzZHAqG/WY1f6S6JAyQcGEEW8DKqZkY7Yyi9Cc9bl9wKYLjRFizkf5EHXNiiyxgmTLbjW+YH
 NxOvxavq
 g9BneL5yNvvM1KIF7/f7o5cF4ikjmcLtBQ9CRswReD1M2EPyL6r56dt3uT8YLs1SVe/zxo3QFDaPQcl0ACKdafgbDK+QnDg6v8Sh/G7Njj4aSE6E4Fh0hFBouw3IymxP3VK14iUvAeMg2Q50NklNkKCFsAc+Nsb3vd8msUlSyQR+pdzNh5fVrye9QqAi0S9Otk6lQNShVKVoIeaVjkpMw+N5uRaf5Or/JJtg6VL/UI/YrUqv+UQ3/xvs9eMsvfs57OwAQDj0AUcKKfaPjGWNmMCjuOxmXzwRFSTG2WhdNDvvaQm3Al2PlSXDCOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 06:09:46AM -0700, Usama Arif wrote:
> From: Alexandre Ghiti <alexghiti@fb.com>
> 
> A large folio reaches zswap_load() only when the caller expects
> the whole range to be on disk. Zswap still stores large folios as
> independent order-0 entries, so reconstructing a large folio from
> zswap entries would risk returning partially initialized data.
> 
> Teach zswap_load() to scan the covered range. If no slot is in zswap,
> return -ENOENT so swap_read_folio() reads the backing device. If any
> slot is still in zswap, fail the large-folio read so the caller can
> fall back to per-page swapin.
> 
> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
> are now valid requests; the error means zswap cannot safely satisfy
> the request from partial per-page compressed state, not that the
> request is unsupported. Existing callers only distinguish -ENOENT,
> so this is a semantic clarification rather than a behavioral change.
> 
> Add zswap_is_present() so PMD swap-entry consumers can make the same
> range decision before attempting PMD-order swapin. Also use it from
> __swap_cache_add_check() for multi-page insertions while holding the
> swap cluster lock. That check runs before folio allocation and again
> immediately before swap-cache insertion, closing the race with zswap
> writeback and rejecting mixed zswap/disk backing with -EBUSY.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/zswap.h |  6 ++++++
>  mm/swap_state.c       | 10 ++++++++++
>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++------------
>  3 files changed, 49 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e1..cd9efcf9dec94 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>  #else
>  
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>  	return true;
>  }
>  
> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +	return false;
> +}
> +
>  #endif
>  
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b76eb3d876fd7..15e200d6966b9 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> @@ -191,6 +192,15 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
>  	if (nr == 1)
>  		return 0;
>  
> +	/*
> +	 * The cluster lock serializes swap-cache insertion with zswap
> +	 * writeback. Reject mixed zswap/disk backing before allocating a
> +	 * large folio and recheck it before adding the folio to swap cache.
> +	 */
> +	if (zswap_is_present(swp_entry(swp_type(targ_entry),
> +				       round_down(swp_offset(targ_entry), nr)), nr))


Sorry I didn't catch it in the discussion in v5, but I think it's
actually clearer to do have this check in __swap_cache_alloc() as you
initially suggested, but not necessarily under the lock.

I don't think the cluster lock is relevant per se, but rather the actual
swap cache allocation. Once you allocate the folio in the swapcache,
you cannot race with zswap store or writeback. I think the comment here
is a bit misleading in that regard. Especially that it mentions
writeback, but I think the real risk is racing with zswap store?

The check here is performed twice, once before allocating the folio and
once after. I think the one before allocating the folio is not really
useful, as we don't actually allocate the swapcache entry so nothing
actually prevents a zswap store/writeback from happening right after
releasing the lock.

We already have a failure path in __swap_cache_alloc() after allocating
the folio and dropping the lock. Can we use the same path to check if
zswap is present?

Maybe something along these lines (completely untested):

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8ccd03c39a407..ce00a2311c5fd 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -415,6 +415,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
        swp_entry_t entry;
        struct folio *folio;
        void *shadow = NULL;
+       bool large_in_zswap;
        unsigned short memcg_id;
        unsigned long address, nr_pages = 1UL << order;
        struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
@@ -459,7 +460,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
        __swap_cache_do_add_folio(ci, folio, entry);
        spin_unlock(&ci->lock);

-       if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
+       /*
+        * Check if any part of the folio is in zswap after stabilizing the swap
+        * cache entry to avoid races with zswap store/writeback. Reject
+        * high-order entries that are partially or fully in zswap, as it is not
+        * supported.
+        */
+       large_in_zswap = order && zswap_is_present(entry, nr_pages);
+
+       if (large_in_zswap ||
+           mem_cgroup_swapin_charge_folio(folio, memcg_id,
                                           vmf ? vmf->vma->vm_mm : NULL, gfp)) {
                spin_lock(&ci->lock);
                __swap_cache_do_del_folio(ci, folio, entry, shadow);


> +		return -EBUSY;
> +
>  	is_zero = __swap_table_test_zero(ci, ci_off);
>  	ci_off = round_down(ci_off, nr);
>  	ci_end = ci_off + nr;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..32671dc2bf84d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1571,6 +1571,23 @@ bool zswap_store(struct folio *folio)
>  	return ret;
>  }
>  
> +/**
> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
> + * @entry: base swap entry of the range
> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
> + */
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +	pgoff_t offset = swp_offset(entry);
> +	struct xarray *tree = swap_zswap_tree(entry);
> +	unsigned long index = offset;
> +
> +	if (!nr || zswap_never_enabled())
> +		return false;
> +
> +	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
> +}
> +
>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1578,13 +1595,9 @@ bool zswap_store(struct folio *folio)
>   * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
>   * of the following error codes:
>   *
> - *  -EIO: if the swapped out content was in zswap, but could not be loaded
> - *  into the page due to a decompression failure. The folio is unlocked, but
> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
> - *  will SIGBUS).
> - *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> + *  -EIO: if the swapped out content was in zswap but could not be handed
> + *  back, either because decompression failed or because a slot in a
> + *  large-folio range is unexpectedly still in zswap. The folio is unlocked,
>   *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>   *  do_swap_page() will SIGBUS).
>   *
> @@ -1605,13 +1618,20 @@ int zswap_load(struct folio *folio)
>  		return -ENOENT;
>  
>  	/*
> -	 * Large folios should not be swapped in while zswap is being used, as
> -	 * they are not properly handled. Zswap does not properly load large
> -	 * folios, and a large folio may only be partially in zswap.
> +	 * A large folio reaches zswap_load() only when its whole range is
> +	 * expected to be on disk: PMD swap-entry consumers split before
> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
> +	 * zswap, fail the read rather than return partially-initialized data.
>  	 */
> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
> -		folio_unlock(folio);
> -		return -EINVAL;
> +	if (folio_test_large(folio)) {
> +		if (WARN_ON_ONCE(zswap_is_present(swp,
> +						  folio_nr_pages(folio)))) {
> +			folio_unlock(folio);
> +			return -EIO;
> +		}
> +		return -ENOENT;
>  	}
>  
>  	entry = xa_load(tree, offset);
> -- 
> 2.53.0-Meta
> 

