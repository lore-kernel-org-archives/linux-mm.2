Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2E62606A337
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gSVuiFaW
Received: by kanga.kvack.org (Postfix)
	id 9F3386B05B4; Mon, 23 Nov 2026 07:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955966B05B5; Mon, 23 Nov 2026 07:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE2E6B05B6; Mon, 23 Nov 2026 07:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B066B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:49:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DADB31C42C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:06 +0000 (UTC)
X-FDA: 85466363892.27.F8D101D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 46FAB140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSVuiFaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795438145;
	b=BkojEUk5ZtbojrK02UGL69DzpVWb0Xy6xr6guyivYLOqE9SokbvUSX9qBmyWpF3G5u0Z4K
	TGuBly/KKga13YbpqBupPXlhzGbNWgPpB714eGFlvK0y0BGQ4qh+IMABIaexCz1Vh+Jf36
	XhbyoP/hBzhCiK74dxLcGjI8sXsor1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795438145;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnR/HtVQ3ceUuwdOQEq43zu84XQJC/5vmpXAH2WxiXM=;
	b=EHlRuI9cOa2GwQ2wOoJzPwpBaeO4BNpUsUXi7dDHPv6orA0tvAOfBvA6bk4HbJ50jQY/yI
	N4qII6C3KejsSE8T++m0SpvKFOXiBPQeB65rYCX+dKHdj42pe9+mnYr/hOFcqZ+J8375Ba
	1woVUJdlyOG+iz1hxbWOR7BlNafhFVc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSVuiFaW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA2A061CC9;
	Mon, 23 Nov 2026 12:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B851F000D3;
	Mon, 23 Nov 2026 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795438144;
	bh=rnR/HtVQ3ceUuwdOQEq43zu84XQJC/5vmpXAH2WxiXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gSVuiFaWHN1fSpQcvQEqZUahTDgAeNq04N3cz/sDQMO9Z3dSWN2muujfYIiHEWmlC
	 a1TELuyfPOsYbJPBgyrOhxWqzg6RXdv9ydkKch/ANq95zPNwk8FJWaXkEPpk7lBJtB
	 wdR+ScuQgX3k35P5mMHkMW1Aj1p0iLwHDUOTgGoMS3YtHDirAZ0mg6dpBioHwigbK+
	 xSEVb6S/2RrQ7vDoXeq1CclkAiqxhHS+FzuhWYX5DLQDfyOTwjazd08DXt/W+EbXQ5
	 0nYqjJhrb7nntFZ9FffVyDZeghYZxDPX5sKcE5X4xbDALzBogAzgFj9KG9QGWTva9F
	 9wpL7/BpZZxAA==
Message-ID: <sashiko-outbox-229263@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 13/14] mm, swap: do not give an xswap slot to a
 cgroup that cannot zswap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, corbet@lwn.net, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261122124814.3489077-4-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
 <20261122124814.3489077-4-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 12:49:03 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 46FAB140003
X-Stat-Signature: 9g3xdqsob4co5zthxjr7t1c1i8zzm4ss
X-HE-Tag: 1795438145-159740
X-HE-Meta: U2FsdGVkX1+E12yWl6hNCCV/P+RRsqcCWICxXKBpOfPUJvH1Tk7ylag6pdKVq2F1V6J4FnLh8IwJl9q+uYg2cW/4NTb83SBV2lPGoWqzhqtDUqzi7jZLcMLZzLhIzkh+mchxGji/GrWk/iw9odkknS5G0fWhhDISWgD9ldLI2CvLo+Ch5s5Wzc3BwJMqpsku3hG2hBJXXIX7XfnLmQtapeRKeCtUuK4MnlAUk1FiI1lBj6pKhW4NclkWATBrIA1s5VXpNxNpR7zipldFvN5hxgvBojhY8Kgr0ccZt1CzixvjSOZFhkDvtjz31cfzq2zPOu1+vLFZeeY1WlJmGkE6DT9QDJF2AuwUIXji1oi8lWheBYhEjsFj1pIOcHQGRozJqnx3736U2PoCLOJma48+4pJVrGghZpModjFHexocYzINlwN3zkQUSmvPNvNvp5VksH8ld6A3zhZT7GP9OKeH2oaLBYwjaycKVjZRbnEwouaRidIISa3pvoedXAQ1GuDItf3AMriH2YRB6WsDZ3kK3rN9qb16L/B46DERfdzRHdfvhlWjwUww9RGYdxEKtjxaJnidMwe67JQz+8rRtQ9XDWzpoeKqiPyvZq/gpl0CrdIFZMt+tpO1VMXGpklBzt4IaDcp5K7ewkU+lkI1AersHZm6VBhgZ8NyIGcOaDl/qLJgceDruvVrOfJknL904q31FPESIEDrlxwTqWOnCQToHzDNGBx6/OvzsuRHCfOjVkm7hIbPonbQx7RccpzbG9DRQGoljvKij70pUmn6klj7dC4enHAAtNSEZ76gO9mFAEXqM6deCkH/MXnvRVELXdfhZu2ZCh0VtP6CGHb5JYN2b5r3s404a2Z5PLHiKo7ltJBKL4fwMK7u4sv7SiqDNQ8hYwRIH8RouovHu9/49laEW6dAJLwV5PFjCe/2QIhxMl0dICXwBy8sbB9GhRNxwhfWCcBcB6b0yBA4QKZ9Krx
 yFlIqm92
 L8bqeFscOCNgy/LNrt22H4In6vwp+MqG5m0bDmRQooWCxyW1YqgVwL6n3pJz2v0dAodf1de/XA7guJ8qXjUrys9olMIc8K56ZvOxcniMQpwnEDBBYaCdmjEOI0Ozdcdr6xgtH0WXiOpYprnF9P6LWtKwWWS5YR0R2QENjWnlMC57KFZ6Bjf864cgY0SAUUAvFrHeAhBqQYs9Zmls5CkIMkRpcvx5WNNtB97a+3ZR6EiV6Ut0YAvtDxE50imWni0zaD56RamPMHgxZH6WktVe3U01rQSqsLHmZgMG/l3JoJJa+QAENL6hmpPmjseB+QBjgO1iVMUmERGvQFhzxyRE4yVwy9gjEb009oRFGKz2yHrk4ml3+rFlUcoq7pK5jNidhCEHZTIZQWB17tde6vyx8swBDqrCg1m/pTe7g4KmwbVc6cvVYdmjF2120cPQUMbf0O7hpC+66s4t3c8RR74kbbl7B7eUgvVD5UhWQ2HgmLCtNOe3J6ocTGjVXk5j9v1bUlqdj4jxKolGs4umA+11hDTX/FZjGMndpNTsItACrt7eapB7BgI+72qSktYOlhwz2qVaJhhLqb2ULxwJNopb/RrWdtcn5NaKzPm/6Uz8+QbWDe6rK++BnpwRXiIuM45f8xJclcVSw+U/sOMEW3HIt7WPfXCtQ4nAfoDZoLMXRhDGp5TImZflnBrYfuZz8Z9QqhmdwxGXruUENhz6kAIahYLYhdDLmoO5qhuNMaBnVjwMUOXM7sC8x99cq1cpLwlASqJ5Nn2TmsJSv0RDXS0G77v+lBMCHvbVgAi1QeAqkPWo/Ucy7tOSqHrpbFCwIsR2IeVs1gTCMT1v89YNKdNk1GzfX4E8TdxWt69OXpBez9G1geCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm, swap: percpu_swap_cluster priority inversion in
  swap_alloc_fast()
- [Medium] mm, swap: futile global lock contention in folio_alloc_swap()
  without real swap
--

commit 0b727ee132b797f75c4ddc0bee4e1bc176587e37
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: do not give an xswap slot to a cgroup that cannot zswap

This commit skips xswap devices during swap slot allocation when the
folio's cgroup cannot accept another zswap page according to
obj_cgroup_may_zswap().

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 462efeef887a8..90f17edce1d04 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -1612,7 +1618,7 @@ static bool get_swap_device_info(struct swap_info_s=
truct *si)
>   * Fast path try to get swap entries with specified order from current
>   * CPU's swap entry pool (a cluster).
>   */
> -static bool swap_alloc_fast(struct folio *folio)
> +static bool swap_alloc_fast(struct folio *folio, bool may_zswap)
>  {
>  	unsigned int order =3D folio_order(folio);
>  	struct swap_cluster_info *ci;
> @@ -1628,6 +1634,11 @@ static bool swap_alloc_fast(struct folio *folio)
>  	if (!si || !offset || !get_swap_device_info(si))
>  		return false;
> =20
> +	if (!may_zswap && (si->flags & SWP_XSWAP)) {
> +		put_swap_device(si);
> +		return false;
> +	}
> +
>  	ci =3D swap_cluster_lock(si, offset);
>  	if (cluster_is_usable(ci, order)) {
>  		if (cluster_is_empty(ci))
> @@ -1642,13 +1653,19 @@ static bool swap_alloc_fast(struct folio *folio)
>  }
> =20
>  /* Rotate the device and switch to a new cluster */
> -static void swap_alloc_slow(struct folio *folio)
> +static void swap_alloc_slow(struct folio *folio, bool may_zswap)
>  {
>  	struct swap_info_struct *si, *next;
> =20
>  	spin_lock(&swap_avail_lock);
>  start_over:
>  	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> +		/*
> +		 * Do not rotate a skipped device: the walk follows the
> +		 * rotation and would spin forever.
> +		 */
> +		if (!may_zswap && (si->flags & SWP_XSWAP))
> +			continue;
>  		/* Rotate the device and switch to a new cluster */
>  		plist_requeue(&si->avail_list, &swap_avail_head);
>  		spin_unlock(&swap_avail_lock);

[Severity: Medium]
Can a !may_zswap allocation overwrite percpu_swap_cluster.si[order] and
route later zswap-eligible folios on the same CPU to a lower-priority
physical swap device?

When may_zswap is false, swap_alloc_fast() rejects the cached xswap
device and swap_alloc_slow() falls back to a physical swap device.  If
that physical device has SWP_SOLIDSTATE set, cluster_alloc_swap_entry()
-> alloc_swap_scan_cluster() installs it into percpu_swap_cluster:

mm/swapfile.c:alloc_swap_scan_cluster() {
	...
	if (si->flags & SWP_SOLIDSTATE) {
		this_cpu_write(percpu_swap_cluster.offset[order], next);
		this_cpu_write(percpu_swap_cluster.si[order], si);
	} else {
	...
}

Because swap_alloc_fast() only rejects SWP_XSWAP when !may_zswap,
subsequent folios with may_zswap =3D=3D true on that CPU will allocate up to
the remaining SWAPFILE_CLUSTER - 1 slots from the lower-priority physical
swap device even while higher-priority xswap space is available.

[ ... ]

> @@ -1987,10 +2015,21 @@ int folio_alloc_swap(struct folio *folio)
>  {
>  	unsigned int order =3D folio_order(folio);
>  	unsigned int size =3D 1 << order;
> +	bool may_zswap =3D true;
> +	bool zswap_checked =3D false;
> =20
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> =20
> +	/*
> +	 * A folio zswap will not take must not get an xswap slot; without
> +	 * a device to route away from, skip the lookup.
> +	 */
> +	if (atomic_read(&nr_xswap_files)) {
> +		may_zswap =3D folio_may_zswap(folio);
> +		zswap_checked =3D true;
> +	}
> +
>  	if (order) {
>  		/*
>  		 * Reject large allocation when THP_SWAP is disabled. Check below
> @@ -2011,8 +2050,8 @@ int folio_alloc_swap(struct folio *folio)
> =20
>  again:
>  	local_lock(&percpu_swap_cluster.lock);
> -	if (!swap_alloc_fast(folio))
> -		swap_alloc_slow(folio);
> +	if (!swap_alloc_fast(folio, may_zswap))
> +		swap_alloc_slow(folio, may_zswap);
>  	local_unlock(&percpu_swap_cluster.lock);
> =20
>  	if (!order && unlikely(!folio_test_swapcache(folio))) {
> @@ -2020,6 +2059,20 @@ int folio_alloc_swap(struct folio *folio)
>  			goto again;
>  	}
> =20
> +	/*
> +	 * The gate was skipped when there was no device; one may have
> +	 * appeared since, so ask the slot itself.
> +	 */
> +	if (unlikely(!zswap_checked && folio_test_swapcache(folio) &&
> +		     (__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP))) {
> +		zswap_checked =3D true;
> +		may_zswap =3D folio_may_zswap(folio);
> +		if (!may_zswap) {
> +			swap_cache_del_folio(folio);
> +			goto again;
> +		}
> +	}
> +
>  	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
>  	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
>  		swap_cache_del_folio(folio);
> @@ -2037,6 +2090,13 @@ int folio_alloc_swap(struct folio *folio)
>  	if (mem_cgroup_get_folio_swap_margin(folio) <=3D 0)
>  		return -ENOMEM;
> =20
> +	/*
> +	 * Only xswap devices exist and the folio cannot use them; splitting
> +	 * cannot help.
> +	 */
> +	if (!may_zswap && !atomic_read(&nr_real_swapfiles))
> +		return -ENOMEM;
> +
>  	return order ? -E2BIG : -ENOMEM;
>  }

[Severity: Medium]
Should folio_alloc_swap() skip the allocation loop when !may_zswap &&
!atomic_read(&nr_real_swapfiles)?

When a cgroup has reached memory.zswap.max on an xswap-only system,
checking this condition only under failed: causes every reclaimed folio
to acquire percpu_swap_cluster.lock, take the global swap_avail_lock in
swap_alloc_slow(), and for order-0 folios take the global swap_lock in
swap_sync_discard() even though no usable swap device exists.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122123918.3486=
916-1-baoquan.he@linux.dev?part=3D13

