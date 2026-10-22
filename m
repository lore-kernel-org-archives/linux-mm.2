Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA1A4606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NyHkXQDF
Received: by kanga.kvack.org (Postfix)
	id EF93D6B089A; Thu, 22 Oct 2026 02:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0AB6B089C; Thu, 22 Oct 2026 02:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6E56B089D; Thu, 22 Oct 2026 02:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC6D66B089A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 499E6120758
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:22 +0000 (UTC)
X-FDA: 85349260164.29.EB6D730
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 11B4220006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NyHkXQDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649960;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stYkR8e3kd4cCGoUCDMmM0KPjrz1zBXkeewuqWpFBKU=;
	b=w77mLjzhyded7m3jYuH5B134s8e88V3wMG+5co7pvdmtdhig/lTgislzepNNVTR1+AI4W6
	sLk3WjNB5d2wYHN1hrXxYyQl14aM8hTUNcVBEcOfgxI6v5rukhWB7NLrjus7lmp7Og5vcY
	YBNpcr0u73Yp8ioZG9W+E/uBGf4GzuM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NyHkXQDF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649960;
	b=UJ1PwS4bgyBikJcr4Un42Ix2oNHdJA+a5h2KVVDSu/w+CPlQcDdnIopJ3mGDbZlLcWe9tV
	ymvxPwr8GjYWeGICp3JQ97AocQ19x0TyfG5ITHPFi0cxFKQJSiazVpYtyInBAcoALksl/w
	8GHrYPRrO9QmZvyaaok6kelQ7xWLYN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 013C940570;
	Thu, 22 Oct 2026 06:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C391F000C1;
	Thu, 22 Oct 2026 06:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649959;
	bh=stYkR8e3kd4cCGoUCDMmM0KPjrz1zBXkeewuqWpFBKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NyHkXQDF/X5/AhXuNNl7yNs3yyoqO0x0KTAWQjy1Fpi+AirZrtlhqp82UMQkj0WSL
	 YriySY5akZ14rCFdPcYhXUZlkDHmReZUEXt6Br9oXypI6c9PKU57NEjAIDYJuuXh3U
	 EoEj0UkrvsmtX6lU4NYpNKWsA/CjIJw5+SUSkXX5Qp9l2e7UL7nQJUdmeB3nSo2Z5g
	 saeFUA/3xo5bWaT1dPVD6o2iouXi69KDmAjWuQ10v6P/KTzcJUviWJuj/Nu+6EDOBf
	 HFrfKtyUzwT5dHUgMVYz/tG5Nh/AwsSGWUK3TgPgmYynccgI1TQWYMo1Ix2bmrsFrQ
	 s3zWJlnAc2jGA==
Message-ID: <sashiko-outbox-181080@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/12] mm, swap: write back vswap zswap entries to
 physical swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021060323.553433-7-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021060323.553433-7-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:17 +0000
X-Rspamd-Queue-Id: 11B4220006
X-Stat-Signature: dk5x1ncqy6ajwznga84h1s7ic991ygxn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649960-727491
X-HE-Meta: U2FsdGVkX1+tP85Y8jowiKlmk6rgAx6ZdlBTe/n+SrNfMVTW1EjOPwzmqAi0+97NETn49SVxR7zWaeei1qUVYWZqM+DPbzHKoUkcv0oKehcHDRnTuwmotc7d+ScIrHm6+v1iTRhH6pH8kB2vZFd8WTzO9ahYl9/THtabq0xJceENXTXghQkiM5tV7VX6vHZkM/bG//hrhV/iSmutxYoS4KxTyYwAfyCL+u4Q+nqqciAAWdM8HWbWSyo15B8SQ+yDFBSyRK0ELB2nUFX556yxvRM3qQOGeNljAnTU3o852BQ86aPbaH2ZwpTN6tWPpM+GIg1AnDhCBRCUfbwuPyhvdNgNN3te4xhMpeRYdPndF6Wk5KMigcWcEsna8OI0s57ZHCHRkAOSPOyqcvyQ3UwmaANycABrU8E76YXi1lplZIw6eDCcylpsPZKDm8iDIALD2iU22TsLu4UgzHLhQuAaBeDUsFWybovIsGp5y/MDZtb+SPM9x/KxJGnDNuKexMviySWIpBotmHrtbNTd85oVftIx3FjmHns/H0krCDgBn5urYNXftno3OEkTMCsifdd48qk4B9ZEBI8/T2JLkVYkFVbxCmP/p8I620rMKyecTgkbRTqTc8Li4nKplCvDNgKnGRC13pNWFHghOKSQ2+xp/90ibl3qXV/V2Z5Lv/e7wRO4+9iDkvG9lMVHbVuPm9SLnnr8Z3LCzg4DtnaNUmdZCl/F+I4YZkZL9GXLmCYZs2Cb7dRlkYjFcv1HI9snGSqxQ1TnbNr6xUxtOSPAd7T2T4N7YsgrKtDEWd04wTY8jZtgxl60h7Ij2EJcCxwhnsKSQsy+TQ8rvToGvHU53Xa6nTUCT46EEhR7TkHyQt11uUOx8y0dRiydX0kZ2Cq2lfA1xKcKBc7s38mJpotWoX7V890Pw2BiG+hl2sNX9gXkpOxs6AHclEt8/rXiVvn9o8SAz1Ss5xQyQ4CbxlnJBLq
 uVzg0Oby
 UasDzLIFnKC8Q7tc5FDB5lErJtZHQFrDrdlzLjF9vKQP5QTEXwV4O3CTt07gNv2uWIL28TAkyrP0mKwMDWDIbdvHLjoxMH04M6a7lTNE7QcLWzOaC+bPJWNnhkktVgYEgVh5R3eHmPWM88Iy106UZFwy1ATHoAbn+5wbqq+Ngq4tJwH1dqUi7H25sHEC1MWzCGVI84KnoxylrOeNwOHphz/aif81Lqyluez0VbHpbcTxyQuCsyxfQY3e5RwXsv/4wDRa9Bx45A8qpttF1IhytQjU17gmCKscQZHDo/srkAyehJcnBmgJQ6pALcPkFPH/LqPz4Xzhzjj4/Qo3uJACAL6YODGT/PTP6lN2EZ8B5bj2Q1aKpV78aLdL+rX78iLq84OL7X+e9qVE87S0ZiIl5pbiEK0vcFdOTRLw8F+zGAkCzRJolnqCY3aCL09bWiTWWzEbE5HStBAoPp0BCNS/24bgFMLmnnX68kdXcRoHQG5JNlAm70KfF9W+OTAlI1xC9E0j9KIvFZWg1a7bd0PcZUnW7uZQMOD/6rAApBMzhX+uO5DzX7UgXzUMeMOUj2ZHxoR57yEZgq1qv4jJJWpfstR4zNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: zswap: corrupted swap accounting and shadow on vswap writeba=
ck failure
--

commit 790470c2c322c0c4b7b975b139e54f69bf472f15
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: write back vswap zswap entries to physical swap

This commit adds support for writing back zswap-backed vswap entries to
physical swap by allocating physical swap slots on demand during writeback.
It also updates the zswap shrinker to only skip vswap entries when no
physical swap space is available.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 1b91dba992aba..fd0c2f126b570 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1076,12 +1076,13 @@ static bool zswap_decompress(struct zswap_entry *=
entry, struct folio *folio)
>  static int zswap_writeback_entry(struct zswap_entry *entry,
>  				 swp_entry_t swpentry)
>  {
> -	struct xarray *tree;
>  	pgoff_t offset =3D swp_offset(swpentry);
>  	struct folio *folio;
>  	struct mempolicy *mpol;
>  	struct swap_info_struct *si;
>  	struct swap_io_ctx ctx =3D {};
> +	swp_entry_t phys =3D {};
> +	bool is_vswap;
>  	int ret =3D 0;
> =20
>  	/* try to allocate swap cache folio */
> @@ -1089,12 +1090,7 @@ static int zswap_writeback_entry(struct zswap_entr=
y *entry,
>  	if (IS_ERR_OR_NULL(si))
>  		return -ENOENT;
> =20
> -	/* Vswap entries have no physical backing to write to. */
> -	if (swap_is_vswap(si)) {
> -		put_swap_device(si);
> -		return -EINVAL;
> -	}
> -
> +	is_vswap =3D swap_is_vswap(si);
>  	mpol =3D get_task_policy(current);
>  	folio =3D __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, =
mpol,
>  					 NO_INTERLEAVE_INDEX);
> @@ -1115,24 +1111,44 @@ static int zswap_writeback_entry(struct zswap_ent=
ry *entry,
>  	/*
>  	 * folio is locked, and the swapcache is now secured against
>  	 * concurrent swapping to and from the slot, and concurrent
> -	 * swapoff so we can safely dereference the zswap tree here.
> +	 * swapoff so we can safely dereference the zswap tree (or vswap
> +	 * vtable) here.
>  	 * Verify that the swap entry hasn't been invalidated and recycled
>  	 * behind our backs, to avoid overwriting a new swap folio with
>  	 * old compressed data. Only when this is successful can the entry
>  	 * be dereferenced.
>  	 */
> -	tree =3D swap_zswap_tree(swpentry);
> -	if (entry !=3D xa_load(tree, offset)) {
> +	if (entry !=3D zswap_entry_load(swpentry)) {
>  		ret =3D -ENOMEM;
>  		goto err;
>  	}
> =20
> +	if (is_vswap) {
> +		/*
> +		 * Allocate physical backing before decompress so a failure
> +		 * wastes no work.
> +		 */
> +		phys =3D folio_realloc_swap(folio);
> +		if (!phys.val) {
> +			ret =3D -ENOMEM;
> +			goto err;
> +		}
> +	}

[Severity: Medium]
What happens to the swap_table shadow and cgroup v1 swap accounting when
folio_realloc_swap() fails here and jumps to err?

Earlier in zswap_writeback_entry(), __swap_cache_alloc_folio() calls
__swap_cache_alloc(), which consumes the existing workingset shadow and
memcg_id from the cluster, replaces the swap_table slot with the folio, and
runs memcg1_swapin() and workingset_refault():

mm/swap_state.c:__swap_cache_alloc() {
	...
	ci =3D swap_cluster_lock(si, offset);
	if (ci)
		err =3D __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_=
id);
	...
	__swap_cache_do_add_folio(ci, folio, entry);
	swap_cluster_unlock(ci);
	...
	/* memsw uncharges swap when folio is added to swap cache */
	memcg1_swapin(folio);
	if (shadow)
		workingset_refault(folio, shadow);
	...
}

Under cgroup v1 (do_memsw_account()), memcg1_swapin() clears the slot's
memcg_table entry, uncharges memcg->memsw, and decrements MEMCG_SWAP and
MEMCG_VSWAP.

When folio_realloc_swap() returns !phys.val (for example, if physical swap
space or cgroup swap margin runs out mid-shrink), the error path in
zswap_writeback_entry() cleans up via swap_cache_del_folio() and folio_put(=
):

err:
	swap_cache_del_folio(folio);
	folio_unlock(folio);
	folio_put(folio);

Because swap_cache_del_folio() calls __swap_cache_del_folio(ci, folio, entr=
y,
NULL, false):

1. Passing NULL for shadow overwrites the swap_table slot with an empty
   shadow, losing the workingset eviction shadow for the entry that remains
   swapped out in zswap.
2. Passing false for swapout skips __memcg1_swapout(folio, ci), so when
   folio_put() frees the folio, __mem_cgroup_uncharge() uncharges
   memcg->memsw a second time while leaving ci->memcg_table cleared to 0
   and MEMCG_SWAP / MEMCG_VSWAP decremented for the still-live swap entry.
   A subsequent writeback attempt on that entry will see memcg_id =3D=3D 0 =
and
   mm =3D=3D NULL in mem_cgroup_swapin_charge_folio().

In addition, zswap_writeback_entry() returns -ENOMEM when !phys.val, which
shrink_memcg_cb() treats as LRU_RETRY:

mm/zswap.c:shrink_memcg_cb() {
	...
	writeback_result =3D zswap_writeback_entry(entry, swpentry);

	if (writeback_result) {
		zswap_reject_reclaim_fail++;
		ret =3D LRU_RETRY;
	...
}

If physical swap fills up during a shrink pass, won't the shrinker continue
scanning the rest of its budget (SWAP_CLUSTER_MAX per node in shrink_memcg()
or sc->nr_to_scan in zswap_shrinker_scan()), clearing entry->referenced on
referenced entries and repeating the __swap_cache_alloc_folio() and
swap_cache_del_folio() cycle on every unreferenced vswap entry?

[ ... ]

>
> --=20
> 2.51.0

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D6

