Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB99A606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYAn2zMP
Received: by kanga.kvack.org (Postfix)
	id 3FEA36B08A0; Thu, 22 Oct 2026 02:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADF56B08A2; Thu, 22 Oct 2026 02:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276E06B08A3; Thu, 22 Oct 2026 02:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0537B6B08A0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F8CC1A073C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:30 +0000 (UTC)
X-FDA: 85349260500.21.19601E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9CBD540004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYAn2zMP;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649968;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDDt5c2tWGco5eVEO28pzQoTZcipkDC1augLw2TGaJ4=;
	b=Y++d20RkFLPzJeYryZ0ah49ep5ykMXnL2uKV6EBKLCIfGaaY0F8UYqXCt5CGTnka7t2W3l
	/QxNI+xq1RxCj1j2N1MnUA80vNyTj2g4RO23rOfMdYd1euBhvh1CH6rT9vG9+pISp3ubpN
	gp8fstz6c8wPkhK1Fhd4XyzWr85svt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649968;
	b=6Hye8PVjUzhA5YLq57C+f0t+tAdSJkxaSIT061ZQw85bBBMm+KByvfDiH0DvkWArNrwHkr
	REIYrEugO37paC9k9xR1pO1QFTBGm7xFhzEijDbbQ+PdGgVmssG2KorepnwMRsso93j/Lj
	CkrAa2ym19OsdKL1hkFe8fNXL24dD68=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jYAn2zMP;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D61BB414C2;
	Thu, 22 Oct 2026 06:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13F21F000C2;
	Thu, 22 Oct 2026 06:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649967;
	bh=xDDt5c2tWGco5eVEO28pzQoTZcipkDC1augLw2TGaJ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jYAn2zMPzsBJXUZZv8q9s07Bqe0haVOuwGRWPjuYQ6zkJ8+q1agtFIejcIQS9O8iT
	 w3G1iOauq4X3yWx5kuRdM8fYXrpPtRO41dVALSFHp07JZcIj64MadkTZhuE6zcNdRW
	 UpzzlLy3kx/+rdTij8LfjBFrWYzNzaxuA58+eViFciPPNNk3SXAmLyZt+3XDa/Jchm
	 nfTPpsmUZRpM0uX9opDlhDaC6GKhrvj9LuSYgmkIGNdcJOAaNN9TghznV6N43tWgc4
	 kDCbOrDqqQqTqNDkG3B/uYMz2YYgdMWnfQXByE/8Z1Qlz3FDyOiXBCarE5ClP2CAQf
	 XYxcC9Tm4j41g==
Message-ID: <sashiko-outbox-181084@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/12] mm, swap: defer memcg_table allocation for
 physical swap clusters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021061837.1569125-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021061837.1569125-1-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:25 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CBD540004
X-Stat-Signature: u1b7cr7ws1611onxx5uozninroqfeodx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792649968-145125
X-HE-Meta: U2FsdGVkX19bN9EmqUHD110LuicHO7DBaMaQdTLaJfzczS4B8lSNteoCyj9NQoGXuAtJTNFf15PJkkQg2IwySks8xBEEtj9q2xrXMn66/HdQbdeZVPSrBo4lvC9XTp/O6sbStcPduQJcL4QLYlOZpXzLYMCVR1UX5Pg1bC5vju0sKiVMclcw5HefQBpyjLIaXjfFXHwV5vKVgkUk+rS3OTs3cVcig7lWHWPPUYrNgCDYcYnUGleqOY8kwljLEqgFrhDTGZZKorFSXThhFMpaGsUwFIpa3UMwW13/zhhBOBQ+YE2tLto2KzGrXur/Eugq2cniKRQChVfLzoQDkUYous6V+gQ6rTEbOEmrRRK5wT8hyfEFver65C7/QD3GqsxArl1suKokJcDR6CcUbCi9+StmaGUumaXU9oC0WU5Z163tfJZYah0k8wsP2E29oVnS/LO+3F83hnKNAP4bcnTOPXENfNF7KTziT0DNuQmUA3pI5Zu/XsxiLZp4/rSFsPXXkVfJFs+8OXpMoBli7kELQMa0FWCLj2oAdSp4kluBHvnYZj/HtKK5HYyNYo71XmR6w03lR9dna8JgGP+P1H/kpx462UmgJhc6OTbbNUxKdFtDs9hJdAwfkXx7vYbnJ0cSD5cP50jbp5IHQuFHJ+zCnQ7ZQu652376u+B/WCvHIcUPZwADggUNhKBTfaMVp2gQEvVe8gZNY03GI85eZE1dLMwQblsHRmtOIcaNuNbH6Kjlq5wnnWl+ss7Ud4LyJ7X6e81xVgOmx+fN1R3xcQrdhPy6HkzoswiebLlZHdIlmAsRvJc528/v47JqRdvmtrrnfjuSipD71GUFyDzDReD/uvUaH713huIHnm+xzW2XmuXcnye7r6fGNnknAr4gva7thnHvLJhjYcWIYHnw7qbVdOu4ivnvnCCx58WWeW2OseTB9k3i/9UpV9Sb886bXHS0NTtqqx/GeYJ5xSNcGrv
 2Yw2AeKf
 lp84DmnURi52ldLJYfszGQIRFXSUtq1IfMIJhyLs/42DYo8eo8edIJz++5fW8rhlgEjoH7TK43vSov0bgjGRiCyPELsUo94oyjYGQHsyEBXb0Yejrlig5L0RCr1GzpGhk1ty3RuGwwPmL9X76y79Bn018ZvGRu7NY2EizVM3M/Wy9/Zl61fQpmFhr3sS6qrMykleX/LTtG6K46paAHuAoOjqwMOoBEgctt6ws8/Ib+VR7Pe6JXPQMnnZ3xvkP5p7NlLEynjP50OWYtFpndVuVDyHW5yMZyhWS8FYdEOpTTOP5/CnfPfjapPMEJivcgWEKidoWQ5zZUoaHIEvzqnNqGQ/XZVht1WIaQS1ckG5Qm73/I9Ti8PmkidVXSlcOpCHfLEqWfimWe1infKzc5INi2r7mjLHh5jAD0huWzQZf9BN/7EnNEJosRSm/XR4oCKOwLO7Pt+ER8Jg74OfAEquYJxNE+FKqUff4BZuzJmd3lETqYWbHwuj0Nu/e8xf+Z/OzKhm5NpxbBy/9dT/Wzz6fd0OqOJ6BeXVi2CiQrWeElggXhuL0RXLEROKQDrMxkqbUr43v9UamGBYXTYOXJDkT8cwSgPcPQ1TAV4mcFUBdL1bDA4y8FRZaUB+In11yvYNMb8dHkXBHs5eIkQU=
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
- [High] mm, swap: infinite loop and cluster demotion on lazy memcg_table a=
lloc failure
- [High] mm, swap: NULL ci->table deref when lazy memcg_table alloc fails i=
n race
--

commit d992a89e7fdb8e94a85278f2c60420245b2472d5
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: defer memcg_table allocation for physical swap clusters

This patch defers allocating ci->memcg_table for physical swap clusters when
vswap is enabled until a direct-use swap slot is allocated in
alloc_swap_scan_cluster(). Clusters that only hold vswap backings skip
allocating ci->memcg_table altogether.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 12cd5caeaaf23..e95f2441fdd7c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -476,7 +476,8 @@ static void swap_cluster_free_table(struct swap_clust=
er_info *ci)
>  	swap_cluster_free_count_table(table);
>  }
> =20
> -static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t =
gfp)
> +static int swap_cluster_alloc_table(struct swap_info_struct *si,
> +				    struct swap_cluster_info *ci, gfp_t gfp)
>  {
>  	struct swap_table *table =3D NULL;
>  	struct folio *folio;
> @@ -497,7 +498,14 @@ static int swap_cluster_alloc_table(struct swap_clus=
ter_info *ci, gfp_t gfp)
>  		return -ENOMEM;
> =20
>  #ifdef CONFIG_MEMCG
> -	if (!mem_cgroup_disabled()) {
> +	/*
> +	 * A physical cluster under vswap may hold only vswap backings, which
> +	 * record their memcg on the vswap cluster's table, not this one. Such
> +	 * clusters defer memcg_table allocation until they hand out a direct-u=
se
> +	 * slot, including one for hibernation.
> +	 */
> +	if ((!vswap_is_enabled() || swap_is_vswap(si)) &&
> +	    !mem_cgroup_disabled()) {
>  		VM_WARN_ON_ONCE(ci->memcg_table);
>  		ci->memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
>  		if (!ci->memcg_table) {
> @@ -575,8 +583,8 @@ swap_cluster_populate(struct swap_info_struct *si,
>  		lockdep_assert_held(&si->global_cluster_lock);
>  	lockdep_assert_held(&ci->lock);
> =20
> -	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> -					  __GFP_NOWARN))
> +	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> +					      __GFP_NOWARN))
>  		return ci;
> =20
>  	/*
> @@ -589,8 +597,8 @@ swap_cluster_populate(struct swap_info_struct *si,
>  		spin_unlock(&si->global_cluster_lock);
>  	local_unlock(&percpu_swap_cluster.lock);
> =20
> -	ret =3D swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> -					   GFP_KERNEL);
> +	ret =3D swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> +					       GFP_KERNEL);
> =20
>  	/*
>  	 * Back to atomic context. We might have migrated to a new CPU with a

[ ... ]

> @@ -1090,7 +1098,9 @@ static bool __swap_cluster_alloc_entries(struct swa=
p_info_struct *si,
>  /* Try use a new cluster for current CPU and allocate from it. */
>  static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
>  					    struct swap_cluster_info *ci,
> -					    struct folio *folio, unsigned long offset)
> +					    struct folio *folio,
> +					    unsigned long offset,
> +					    bool *nomem)
>  {
>  	unsigned int next =3D SWAP_ENTRY_INVALID, found =3D SWAP_ENTRY_INVALID;
>  	unsigned long start =3D ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> @@ -1119,6 +1129,23 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
>  			if (!ret)
>  				continue;
>  		}
> +#ifdef CONFIG_MEMCG
> +		/*
> +		 * Lazy-allocate memcg_table on the first direct-use slot of a
> +		 * physical cluster.
> +		 */
> +		if (vswap_is_enabled() &&
> +		    (!folio || !folio_test_swapcache(folio)) &&
> +		    !mem_cgroup_disabled() && !ci->memcg_table) {
> +			ci->memcg_table =3D kzalloc_obj(*ci->memcg_table,
> +						      GFP_ATOMIC | __GFP_NOWARN);
> +			if (!ci->memcg_table) {
> +				if (nomem)
> +					*nomem =3D true;
> +				goto out;
> +			}
> +		}
> +#endif
>  		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLU=
STER))
>  			break;
>  		found =3D offset;
> @@ -1128,7 +1155,15 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
>  		break;
>  	}
>  out:
> -	relocate_cluster(si, ci);
> +	/*
> +	 * On a discard-capable device, relocating a cluster whose memcg_table
> +	 * allocation failed queues a discard for slots that were never used,
> +	 * which folio_alloc_phys_swap() reads as progress and retries on.
> +	 */
> +	if (nomem && *nomem && !ci->count)
> +		__free_cluster(si, ci);
> +	else
> +		relocate_cluster(si, ci);

[Severity: High]
Can a concurrent caller with nomem =3D=3D NULL race with swap_cluster_popul=
ate()
here and free ci->table before swap_cluster_populate() finishes isolating t=
he
cluster?

In mm/swapfile.c, when isolate_lock_cluster() isolates an empty physical
cluster from si->free_clusters and the initial atomic table allocation fail=
s,
swap_cluster_populate() drops ci->lock and percpu_swap_cluster.lock to call
swap_cluster_alloc_table() with GFP_KERNEL:

    spin_unlock(&ci->lock);
    if (!(si->flags & SWP_SOLIDSTATE))
        spin_unlock(&si->global_cluster_lock);
    local_unlock(&percpu_swap_cluster.lock);

    ret =3D swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
                                           GFP_KERNEL);

With this patch, swap_cluster_alloc_table() skips allocating ci->memcg_table
for physical clusters when vswap_is_enabled() is true, and publishes
rcu_assign_pointer(ci->table, table) while ci->lock is not held.

Before swap_cluster_populate() re-acquires ci->lock, another caller whose
cached percpu_swap_cluster.offset[order] or si->global_cluster->next[order]
still points into ci (such as swap_alloc_fast(), cluster_alloc_swap_entry(),
or swap_alloc_hibernation_slot()) can lock ci, see cluster_is_usable(ci,
order) =3D=3D true and cluster_is_empty(ci) =3D=3D true, and call
alloc_swap_scan_cluster(si, ci, folio, offset, NULL) with nomem =3D=3D NULL=
 for a
direct-use slot.

If the lazy kzalloc_obj(*ci->memcg_table, GFP_ATOMIC | __GFP_NOWARN) fails =
in
alloc_swap_scan_cluster(), it jumps to out with ci->count =3D=3D 0. Because=
 nomem
is NULL, the check (nomem && *nomem && !ci->count) is false, so it calls
relocate_cluster(si, ci) -> free_cluster(si, ci), which either frees
ci->table via __free_cluster() and moves ci back to si->free_clusters, or
queues ci on si->discard_clusters when SWP_PAGE_DISCARD is set.

When swap_cluster_populate() then re-acquires ci->lock, it only checks if
(ret) before returning ci to isolate_lock_cluster() -> alloc_swap_scan_list=
()
-> alloc_swap_scan_cluster() -> cluster_scan_range() -> __swap_table_get(),
dereferencing a NULL ci->table (or allocating from a cluster on
si->discard_clusters).

>  	swap_cluster_unlock(ci);
>  	if (swap_is_vswap(si)) {
>  		this_cpu_write(percpu_vswap_cluster.offset[order], next);
> @@ -1149,7 +1184,13 @@ static unsigned int alloc_swap_scan_list(struct sw=
ap_info_struct *si,
>  					 bool scan_all)
>  {
>  	unsigned int found =3D SWAP_ENTRY_INVALID;
> +	bool nomem =3D false;
> =20
> +	/*
> +	 * In rare cases alloc_swap_scan_cluster() can fail due to
> +	 * memcg_table allocation failure. Short-circuit to avoid looping
> +	 * over the list indefinitely.
> +	 */
>  	do {
>  		struct swap_cluster_info *ci =3D isolate_lock_cluster(si, list);
>  		unsigned long offset;
> @@ -1157,10 +1198,10 @@ static unsigned int alloc_swap_scan_list(struct s=
wap_info_struct *si,
>  		if (!ci)
>  			break;
>  		offset =3D cluster_offset(si, ci);
> -		found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
> +		found =3D alloc_swap_scan_cluster(si, ci, folio, offset, &nomem);
>  		if (found)
>  			break;
> -	} while (scan_all);
> +	} while (scan_all && !nomem);
> =20
>  	return found;
>  }

[Severity: High]
What happens in cluster_alloc_swap_entry() and swap_alloc_slow() when the
lazy GFP_ATOMIC allocation of ci->memcg_table fails under memory pressure?

Previously, swap_cluster_populate() had a lock-dropping GFP_KERNEL fallback
when allocating ci->memcg_table, and swapon pre-allocated ci->memcg_table
with GFP_KERNEL for cluster 0 and the bad/EOF clusters. Moving physical
cluster ci->memcg_table allocation into alloc_swap_scan_cluster() under
ci->lock and percpu_swap_cluster.lock with GFP_ATOMIC | __GFP_NOWARN appears
to cause several issues when that atomic allocation fails during direct
physical swap allocation:

1. For an empty cluster isolated from si->free_clusters,
swap_cluster_populate() has just allocated ci->table (potentially dropping
locks to use GFP_KERNEL), and alloc_swap_scan_cluster() immediately calls
__free_cluster(si, ci) -> swap_cluster_free_table(ci), freeing the newly
allocated ci->table via call_rcu() and returning ci to si->free_clusters.

2. For a non-empty cluster (ci->count > 0) isolated from
si->nonfull_clusters[order] (such as cluster 0, the EOF cluster, or a
partially filled vswap-backing cluster), the check (nomem && *nomem &&
!ci->count) in alloc_swap_scan_cluster() is false, so relocate_cluster(si,
ci) demotes the cluster from si->nonfull_clusters[order] to
si->frag_clusters[ci->order].

3. In alloc_swap_scan_list(), stopping on !nomem skips any remaining cluste=
rs
on si->nonfull_clusters[order] that already have ci->memcg_table allocated,
while nomem is not propagated to cluster_alloc_swap_entry(). As a result,
cluster_alloc_swap_entry() continues to si->free_clusters,
swap_reclaim_full_clusters(), and the order-0 higher-order stealing loop ov=
er
si->frag_clusters[o] and si->nonfull_clusters[o], demoting or fragmenting
higher-order clusters.

4. When cluster_alloc_swap_entry(si, folio) returns 0 to
swap_alloc_slow(folio) for an order-0 folio (!folio_test_large(folio)),
swap_alloc_slow() does not bail out:

    plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
        /* Rotate the device and switch to a new cluster */
        plist_requeue(&si->avail_list, &swap_avail_head);
        spin_unlock(&swap_avail_lock);
        if (get_swap_device_info(si)) {
            found =3D cluster_alloc_swap_entry(si, folio);
            put_swap_device(si);
            if (found)
                return swp_entry(si->type, found);
            if (folio_test_large(folio))
                return (swp_entry_t){};
        }

Because no slots were allocated, si is not full and stays on swap_avail_hea=
d.
When two or more swap devices share the same priority on swap_avail_head,
plist_requeue(&si->avail_list, &swap_avail_head) moves si after next on each
iteration, causing swap_alloc_slow() to loop indefinitely between those
devices while holding percpu_swap_cluster.lock.

Could swap_cluster_populate() or a lock-dropping fallback in the caller
handle allocating ci->memcg_table with GFP_KERNEL, and avoid demoting
clusters or looping in swap_alloc_slow() when allocation fails?

> @@ -1181,7 +1222,8 @@ static unsigned int vswap_alloc_cluster(struct swap=
_info_struct *si,

[ ... ]

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D10

