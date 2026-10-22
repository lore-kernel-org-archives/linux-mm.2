Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D253606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aED+FBQ8
Received: by kanga.kvack.org (Postfix)
	id 9A3746B08A2; Thu, 22 Oct 2026 02:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A1E6B08A4; Thu, 22 Oct 2026 02:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6EE6B08A5; Thu, 22 Oct 2026 02:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4890D6B08A2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC7341C40AC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:35 +0000 (UTC)
X-FDA: 85349260710.04.4163378
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25B1FC0002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aED+FBQ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649974;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRrusuJCUTaVG07etMCTRqEkRDpGcV5Aqfdtz67ggDk=;
	b=YS+ICxajmvFcAPJdiI7X+D/R9dgIYJKoQVTvsbBPTVtA1gz4L+UEYcGfNRDHBJQLSPc5A9
	3R0ZxYVyYybznnJB81KQFOvhXUwNhwPD27U/kOfCmvdrkLZ++u02ezGa/9Knht/+vC4sO1
	3PP05YdaYcRgW2WVXABxbB6qFakeK5w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aED+FBQ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649974;
	b=t2xgwkHtnkG1ZdcH+Q0P2MnDEyP0fwHfYnI4SyzIoSo2FXQ+JPDKwqkFsrpJ0fTjEex0un
	bnfdGIoyOk5SnMT3NRBSCUCKGvFrbL7vKKwnbGFHdo0Asqpz+wTGvMm66+j+czwv9IFoz8
	/1gyjOUywX4sGpRR3KrrPFg9wPDFdIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 718B942DB4;
	Thu, 22 Oct 2026 06:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499DB1F000C3;
	Thu, 22 Oct 2026 06:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649973;
	bh=LRrusuJCUTaVG07etMCTRqEkRDpGcV5Aqfdtz67ggDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aED+FBQ8T9UE7Xf9W8+Qq+E71Mr/ZZSPRqiV+E5/S7HluA/1y2fcN7j3FzaNETr82
	 tm9aIi1HfSRiC0mhUtjjuQhkWD7Hwzu7/TccHKNurL0zB6FsQoj8xexAl8ttDEuVWC
	 c5/6G7UXZlo9j1U+baVAkILmeAgsk8xzxF2jkNlip7ky2uwixRWYYUcrga+JdZs/O6
	 ePKkUHrELW0xeOBzYl8+3IfcpzfpELLZuB/vz8FYJ08U3txS238kZPzZ5QH+CnRy1j
	 WvDGLi8MjH41oQY7UYV5i88Kxe80yxcKlB6Ck45jXI9EZjkXzEOfvWJfHruijpSLTP
	 60zmkOuRVDVew==
Message-ID: <sashiko-outbox-181086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v6 12/12] mm, swap: back vswap clusters with a
 VM_SPARSE array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021061837.1569125-3-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021061837.1569125-3-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:27 +0000
X-Rspamd-Queue-Id: 25B1FC0002
X-Stat-Signature: pg9w3cyc3qx7kouohs1deugud3yaddz9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792649973-926763
X-HE-Meta: U2FsdGVkX19lux2yd6qRwbTC8GvG7CN51evwPvT/noew1vkr7qGLHuedfQjOZ2JtR8ION0CcceC0c1jNGcuaG2z1JNrtFAXmpRuzoHiE15H6WrewxqeSXyUQaSF+lSL7VspKHdmWhZacKRspfua0sSB0BRWa7Ozmi+igum3sk1ESJYVdpoQ65Vg95sn6jsljne3hiH8Z4cYU5COWLuRjS6OLz8/+H377F61LFbdwrrv8lsIy2ozf8bZQqwWQOzISWWzT+gcl1EKWbx+uCSOpVf3ImToHtNreDm1DNgoOUexJBgUQ61JhVC3HQWh4hWevMq1wXUBYYbegQpSig6OAqgDLKXDMoFRzV7ndjutVBk0Gxc9oglbRTiM4pr3qWn9tXwGjcnOXL6r6izlzjGOGWFkQNobc1mIcgkyBUbSN2wM0onTpZyriutGMZy5rVC8fV0MMiybIKkKxU4Yl85Qk/kk6MLK1z4FnGlriyZXelOo1wu0Vsc5v5QQh5TjLJ86REvkbrGnEA5cwaa9HRyut643fwbj4mzMOTZkK71RxAmm5aWnJIVnzy1tgy4StSaxzQOoM1yIfL8Qz0CDQ/2hIqXWDNYcItCATtgJFVsRlgpWjLoUJRO5Tlu7rj0sl0Hk0TYFobgOwfSvqcJS7w+YfCa8fbIr13A2tuGG+wsjEontkKBvs+r+WIMmqrnOLHmBCzIk2SdvmX6yJaYAi2+uzrK/vm47sv9MCN6MXw/Mn++PaAWtgfFS3fqHrUE0yAi6g4E72nTA0a1okXmPAEN6TvALtqmeT8e+JHtv/V8m75Z+ROrJfX/wc0rg+w8UmZch15GtNk9+QHG55N3G1kxDXBizIv6k9lRXYrUEtGOm18OsGER9bGRF+TxHXBxTdcY05SzqPV2r6lh2Kc5iZaHzayYpsG5Ew/aMbM/A+1MDG0V3loIxx5Vs+g/KfRrsNBL0BiaHaHL9NdI0KU619/Hy
 fA4UM24R
 uEv+rPRreGY5LwRPH3W9qtqZw/j1m8DTawQuJhZbvT8mxq9xw85EOwG3vyfv8EMaeVcgO1O3MlzDXZfAbfDadgXXz4hTAOtw1CdOqnk05xt2oAOZjK489qUAii1mQEl2l5SKqcNX30pUcugkpOKey3axlUaxkrwXGvotUXuStVMOTFXzwUjhVtFQ49aANr8MnVM2e1R2PKg+fDD4GmhKKelcJRMd9gs/Sdr1wW/xjbji1kJc1LFxlhz+rMDjrqOOXGZg+ufaDiQyMG9linE37g0dc2k7ks8BF2UbthgfHeeZ4mqmZH59T+0QLi91M0iFbPvskrFRJP7uAi6GR7Q585UrsXFwFz7qq+2rGz7/CSKbHiZwOEtwuWAHzRcIC0eBEBfEZ23FC8mK9/g9bwKxn06o2PW0yTIWtFo6RpHEJoxm9CDOj2l8HcW5hql+brFrAf6gfDXx2vMdivlz0RBBIok4d+DGrlVbRt824dSYGzbPB4LpRmOGObYOE6Hsblc+UBAw5bhncf5jy15GQopft67I04KkGaOrwyGakVYaToHQ4+3GHD3rMwRlzGSTKH7YADhJYv7UolKaf+y+6a+avbk87o1KgAdnvwK38rp2oJGLr9ynDjhv42vtCThQyqRIAMwD8elc9jvRX6adtHJj6M5a6Casl/XHYTdz6
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
- [High] mm: vswap_grow_clusters() publishes nr_mapped_clusters before spin=
_lock_init()
- [High] mm, swap: race on unlocked table publish in swap_cluster_populate()
--

commit f6800a3010801f9cd20edba92bfbe97989790bd2
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: back vswap clusters with a VM_SPARSE array

This commit replaces the xarray of dynamically allocated vswap cluster
structures with a VM_SPARSE vmalloc array that grows on demand a page at a
time. Emptied vswap clusters now free their tables and return to
si->free_clusters for reuse rather than being freed via RCU.

Link: https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos=
.cn/

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fe5460d15f555..4cb6586327c45 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -519,12 +550,19 @@ static int swap_cluster_alloc_table(struct swap_inf=
o_struct *si,
>  	VM_WARN_ON_ONCE(ci->zero_bitmap);
>  	ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
>  	if (!ci->zero_bitmap) {
> -		swap_cluster_free_table(ci);
> +		swap_cluster_free_table(si, ci);
>  		swap_cluster_free_count_table(table);
>  		return -ENOMEM;
>  	}
>  #endif
> =20
> +	/* The virtual table shares the swap table's lifetime. */
> +	if (swap_is_vswap(si) && vswap_cluster_alloc_vtable(ci, gfp)) {
> +		swap_cluster_free_table(si, ci);
> +		swap_cluster_free_count_table(table);
> +		return -ENOMEM;
> +	}
> +
>  	/*
>  	 * Make tables visible to cluster_is_usable() after everything is
>  	 * ready.
> @@ -575,10 +613,8 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	/*
>  	 * Only cluster isolation from the allocator does table allocation.
>  	 * Swap allocator uses percpu clusters and holds the local lock.
> -	 * vswap clusters are destroyed rather than freed to si->free_clusters.
>  	 */
> -	VM_WARN_ON_ONCE(swap_is_vswap(si));
> -	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +	swap_percpu_cluster_assert_held(si);
>  	if (!(si->flags & SWP_SOLIDSTATE))
>  		lockdep_assert_held(&si->global_cluster_lock);
>  	lockdep_assert_held(&ci->lock);
> @@ -595,7 +631,7 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	spin_unlock(&ci->lock);
>  	if (!(si->flags & SWP_SOLIDSTATE))
>  		spin_unlock(&si->global_cluster_lock);
> -	local_unlock(&percpu_swap_cluster.lock);
> +	swap_percpu_cluster_unlock(si);
> =20
>  	ret =3D swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
>  					       GFP_KERNEL);
> @@ -608,7 +644,7 @@ swap_cluster_populate(struct swap_info_struct *si,
>  	 * could happen with ignoring the percpu cluster is fragmentation,
>  	 * which is acceptable since this fallback and race is rare.
>  	 */
> -	local_lock(&percpu_swap_cluster.lock);
> +	swap_percpu_cluster_lock(si);
>  	if (!(si->flags & SWP_SOLIDSTATE))
>  		spin_lock(&si->global_cluster_lock);
>  	spin_lock(&ci->lock);

[Severity: High]
Can a concurrent fast-path allocator race with the unlocked
swap_cluster_alloc_table() call in swap_cluster_populate()?

With vswap clusters now returning to si->free_clusters in __free_cluster()
instead of being destroyed with CLUSTER_FLAG_DEAD, other CPUs (or other
orders on the same CPU) can still hold an offset into a freed cluster in
percpu_vswap_cluster.offset[order].

When cluster_alloc_swap_entry() -> alloc_swap_scan_list() ->
isolate_lock_cluster() isolates ci from si->free_clusters, it sets
ci->flags =3D CLUSTER_FLAG_NONE and calls swap_cluster_populate(). If the
initial atomic allocation fails, swap_cluster_populate() drops ci->lock and
calls swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
GFP_KERNEL), which publishes ci->virtual_table and ci->table before ci->lock
is re-acquired:

mm/swapfile.c:swap_cluster_alloc_table() {
	...
	rcu_assign_pointer(ci->table, table);
	return 0;
}

Because CLUSTER_FLAG_NONE is <=3D CLUSTER_FLAG_USABLE, an isolated cluster =
is
only prevented from passing cluster_is_usable(ci, order) by ci->table being
NULL. Once rcu_assign_pointer(ci->table, table) executes while ci->lock is
dropped, a concurrent vswap_alloc() (or swap_alloc_fast()) with a cached
offset into ci can lock ci->lock, see cluster_is_usable(ci, order) return
true, and allocate entries via alloc_swap_scan_cluster():

mm/swapfile.c:vswap_alloc() {
	if (offset !=3D SWAP_ENTRY_INVALID) {
		ci =3D swap_cluster_lock(vswap_si, offset);
		if (cluster_is_usable(ci, order)) {
			if (cluster_is_empty(ci))
				offset =3D cluster_offset(vswap_si, ci);
			alloc_swap_scan_cluster(vswap_si, ci, folio, offset,
						NULL);
		} ...
	}
}

If that fast-path allocation claims ci for a different order and relocates =
it
onto another cluster list, or if those entries are then freed so
__free_cluster() frees ci->table and ci->virtual_table back to NULL before
swap_cluster_populate() re-acquires spin_lock(&ci->lock),
swap_cluster_populate() will still see ret =3D=3D 0 and return ci to
alloc_swap_scan_list() -> alloc_swap_scan_cluster().

Could this trigger VM_WARN_ON(!cluster_is_usable(ci, order)) in
alloc_swap_scan_cluster(), corrupt cluster list and order state, or
dereference a NULL ci->table in cluster_scan_range() -> __swap_table_get()?

[ ... ]

> @@ -1206,50 +1229,146 @@ static unsigned int alloc_swap_scan_list(struct =
swap_info_struct *si,

[ ... ]

> +static int vswap_grow_clusters(struct swap_info_struct *si)
>  {

[ ... ]

> +	/*
> +	 * Publish the new clusters before they become reachable by offset.
> +	 * A zeroed page leaves them off-list with CLUSTER_FLAG_NONE, which
> +	 * is what move_cluster() expects.
> +	 */
> +	WRITE_ONCE(si->nr_mapped_clusters, first + nr);
> +	for (i =3D first; i < first + nr; i++) {
> +		ci =3D &si->cluster_info[i];
> +		spin_lock_init(&ci->lock);
> +		INIT_LIST_HEAD(&ci->list);
> +		spin_lock(&ci->lock);
> +		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
> +		spin_unlock(&ci->lock);
>  	}

[Severity: High]
What happens if swap_cluster_readahead() observes the updated
si->nr_mapped_clusters in vswap_grow_clusters() before the loop finishes
running spin_lock_init(&ci->lock) on each new cluster?

In mm/swap_state.c, swap_cluster_readahead() bounds end_offset using
READ_ONCE(si->nr_mapped_clusters) and then locks each cluster in the range
via swap_cache_read_folio() -> __swap_cache_alloc_folio() ->
__swap_cache_alloc() -> swap_cluster_lock():

mm/swap_state.c:swap_cluster_readahead() {
	...
	max =3D si->max;
	if (swap_is_vswap(si))
		max =3D min(max, READ_ONCE(si->nr_mapped_clusters) *
			       SWAPFILE_CLUSTER);
	if (end_offset >=3D max)
		end_offset =3D max - 1;

	blk_start_plug(&plug);
	for (offset =3D start_offset; offset <=3D end_offset ; offset++) {
		/* Ok, do the async read-ahead now */
		ra_entry =3D swp_entry(swp_type(entry), offset);
		folio =3D swap_cache_read_folio(&ctx, ra_entry, gfp_mask, mpol,
				ilx, offset !=3D entry_offset);
	...
}

When a readahead window spans across a cluster boundary into the newly grown
range [first, first + nr) (or after cluster first is added to
si->free_clusters while clusters first + 1 .. first + nr - 1 are still being
initialized), swap_cluster_readahead() can call spin_lock(&ci->lock) on
si->cluster_info[i] before spin_lock_init(&ci->lock) has executed, or while
spin_lock_init(&ci->lock) is concurrently resetting the lock.

Should vswap_grow_clusters() initialize the new clusters before publishing
si->nr_mapped_clusters with smp_store_release() (paired with
smp_load_acquire() in readers), or initialize spin_lock_init(&ci->lock) and
INIT_LIST_HEAD(&ci->list) for the entire batch before making the new cluste=
rs
visible?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D12

