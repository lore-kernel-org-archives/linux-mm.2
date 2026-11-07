Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E6C606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fGWSR5Wr
Received: by kanga.kvack.org (Postfix)
	id 5A7836B05B2; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4506B05B3; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385516B05B4; Sat,  7 Nov 2026 02:25:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E096C6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:25:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A96840301
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:11 +0000 (UTC)
X-FDA: 85407486822.06.0C10495
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C25C4140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGWSR5Wr;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036309;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4uPbxxqopJMnZ7ErMwn2urmrgG+FVEzHE8ZgEba/UMo=;
	b=rMlFFKLnkC3njqugpvLRFODqikPEfbff7MQJ41RlsBSwEoRgVkJSF5FKeVaB3rJCKdqjQf
	pwmG884VoahbcFgGuLX6TD0JK1Mb/fTPfgp+EgOVOf1/Ltmp0HM8IJiQQ0trAWrjxac47I
	KEPwG79D02pLMZKq4laIrFe5awwib+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036309;
	b=n0U5eUDVRrQLtwopvXwSQGh4aVm/jBDElDEkB186SlOxW8ttS6mwHNA9gQq1pYvWR9OGCP
	VWAHpbi073/wLDwAu5GWX3RxmcujeW9TvQDdvyrKD5SHl2nSYQgWZAkDNwYIro6Y3KuPYb
	CtRW9KAohN8g4kk4EV0XIBgvrOx/2L8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fGWSR5Wr;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE3D060EF8;
	Sat,  7 Nov 2026 07:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6921F0089F;
	Sat,  7 Nov 2026 07:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036308;
	bh=4uPbxxqopJMnZ7ErMwn2urmrgG+FVEzHE8ZgEba/UMo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGWSR5WrTTNeAhup2qqC/jsN9AWbf3vIClbIxqBpcJZ8WheZynSa+RnAX8g3fzRxS
	 /kYZy7BQMhq5gyGVOXBjZSCRaGNG+6qmkXaySZhUxBYO6xjB8kuCSsHoPx6BWRmZfY
	 d2Ij8C985C5YwV/Mle23/SFWqR4+HSGI/7t5t92NXWaEvxIS8SeNEvWX87Ui+gCQ8H
	 8HiQDbiz8x/fkZiXVqeJbdut61xdVdZis1eUz4nAf+4ciBGgfdsNhm7uLoLYbcDX7A
	 dA9v4RRGqXc+1z0JDYtRCEUjPeudzFN30DM4PdhTISckZStCq4WGJpLYf/xmHQEYxb
	 MqcmxokqaOahQ==
Message-ID: <sashiko-outbox-202711@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:07 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: up9gn13jwt9kf7azdrbruxyo1cfc8e4z
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C25C4140006
X-Rspam-User: 
X-HE-Tag: 1794036309-961297
X-HE-Meta: U2FsdGVkX1/1ofwrRycS0t2QLeUPUA3d+GJqnyF4oEIzIEBDhrEzIDp9jkrMkEcI/QFRpZ+Ll4lpJwfBXA06vT83J7OcWmRtNUIExH4UDh96g//1O4Ck3hp4R//M/ECd9/lArStX+uxzqIfd/dHPRPWHDIK8RlYM2SbYhqSm0a5dRROZOFk5Z/mMbdXOKOHbIq1MhF9Z3w9mzuHipnes21dp5AxOevkGAOifMLu0k1SDtVgvuiJM1v9acwWT3UWwsuDdGKnwjL9RW9soYTauv0fhAFBtG5avI80L44kNKBgKMQ3ZUMovAMwD3qipApoy1D15xTWkAr9EE/j/8Wz22UUEGRE1ubWrsVtvTu5drHzxlojMzNSTW8iV3f616BdQzK2H5rneO5at3p/QvUOVGkClFaNhpbzmKJWB3/Wcc1WQx1X2ODYSV6qzxelA+tCizkhudGfvH+YDP78PW6klLLQs+8s+5iI+4/nswQGL8CqUCzXP2JmmTBLCx/FvgTKdKtK4JDiveXGszJzUlR2KlCd9L/Ky6DEA+VU9FEnvNWJ0BbrbTfnGeV/4zEGiGll9L2fhOGaI/wg+iJyeVW+xS8RRLBTGpxm5g/4T4/hF/HC4Jz2WeuE5cBtvizPN4yRX6AhKrldMyVuGOdV0DxdzyNCpcY5yZoZJAuHM6o2Fxkb+MWmuNjLAc9MP4zsLALcui5vnV+BD87sXm9WX3A8wXo95dXKqYxUmYo7/3CqB0W8LpvpwKpqK4WnIqDaF5WLz7ojcHDRFPRv4xyvCtQcNOX0TAlcjUnfK1r72kaFl3VIxmS5JAa/b650TuEX9FYrYnA3Ui5qw59q+E8UbbkfOFE5s95cvBkdA6OJhjpeo8oiOolNnINe7dr5w/XXT66frExW0JrE0PBcImTn3pyTZVcEwd/d8Mi+N+Sm/96ZZQIr38XPpVA12QFIRIzLiYiOfpYpSW5XsjeGjslKtDnv
 Xe4Pu4AC
 DUuG7OyHN5zctlLxFc0+O2hRqsbLfy9QWDmGf/kRlovLxLqh6MEKC7nBe+n+RIs6KQtLqRXqw5RBpLXdpH7pk1t4B5y3Woqhg5gHt0IQDJmgxWEGJW8D+EwTZUkbhBV83fgPbDFtkbzr42hqAk6X02PL1NBIRyr+yDHyL2S9Z+Vfthze+DV15wzHnkLo20BYcXkwo2l1yxsGfn35t7v1sEY+rAre0u1QwxM7jvkKBwUqPR199f62nFineTffOpSjQ7/+1ACUErpxPRspngOCPBZ+notwFdHs56IIC/pjUHvJHlJ9/q3NTyIVA7G+l+3M6T+J3Kdmn6tXHzRlQduOSYPney29CRiKHSm0GiHX+Ej/HPDX53aqlN9DCPr8frmBxO7BF4fMYJL4c/66+iAX8bGB6vTNAKkhhMkuWaB6EG+L67LyCKQRv32LQI2ai8CCLhtjtYNaFVlkZTZUofseDfATvHBs2vkSoK81LGsnE4hsTrhJ9gaqlYmBzGP7pS0myn+NURG769DhUR1RxeRFMkG05GO/flKRgF034HL0Hm/PTo+QEFLa00vWbjYuHcY/6/lTFLdbs43wgua/0UiTsSEsVnmKoj867kdTlNWOK6fzRTAjhylfaB95QVL9hT1InPtsY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: zswap: shrink_memcg() skips entries on nodes outside
  N_NORMAL_MEMORY
--

commit f6e1c6117279d2be409376eb57c05492fc654dea
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the swapped-out folio's NUMA node ID in struct
zswap_entry for list_lru tracking and switches zswap_entry slab allocations
to be node-agnostic.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 78cf3d16b97b0..95997172db6f6 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val,
>  * lru functions
>  **********************************/
> =20
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct zswap_entry *entry)
>  {
> -	int nid =3D entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
> =20
>  	/*
> @@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg =3D obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
[ ... ]
> @@ -1539,9 +1538,10 @@ static bool zswap_store_page(struct folio *folio, =
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
> @@ -1556,6 +1556,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
Can shrink_memcg() miss zswap_list_lru entries when a folio comes from a
node outside N_NORMAL_MEMORY?

Previously, entry_to_nid() derived the list_lru node ID from the GFP_KERNEL
slab page backing struct zswap_entry, which was guaranteed to be on a node
in N_NORMAL_MEMORY.  Now entry->nid is set to folio_nid(folio), and movable
swap-backed folios can reside on ZONE_MOVABLE-only or ZONE_HIGHMEM-only
nodes that are in N_MEMORY but not in N_NORMAL_MEMORY.  Because
shrink_memcg() only walks N_NORMAL_MEMORY nodes:

mm/zswap.c:shrink_memcg() {
    ...
	for_each_node_state(nid, N_NORMAL_MEMORY) {
		unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;

		shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg,
					    &shrink_memcg_cb, &ctl, &nr_to_walk);
		scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
	}
    ...
}

entries added under entry->nid for nodes outside N_NORMAL_MEMORY are
skipped by both per-cgroup and global pool limit reclaim, leaving them
unreclaimable by shrink_memcg() and causing premature zswap_store()
rejections once limits are reached.  Should shrink_memcg() iterate over
N_MEMORY instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D5

