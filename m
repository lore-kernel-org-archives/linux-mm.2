Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF333606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eyNw6Z1R
Received: by kanga.kvack.org (Postfix)
	id CD5F36B0896; Thu, 22 Oct 2026 02:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C390C6B0898; Thu, 22 Oct 2026 02:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E076B0899; Thu, 22 Oct 2026 02:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A10F6B0896
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00B5BA074C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:16 +0000 (UTC)
X-FDA: 85349259954.29.5AF9908
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 520FC140003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyNw6Z1R;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649955;
	b=sIU66n0SBVK1u6RROJS+sPwvJ7lZInuQHKTY4A0Oh57UrwsQPDeIuVToQLdy7C7PRkFE2A
	MMMei1H1TesCV0/pAKVGYs2i30gqo2W0J00jqJ9mAZeNn9MDpN+zid+o+vKZpw85gvIg/I
	IOPcnXA4KFjNrod1DhmFXfDK2jSq91w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyNw6Z1R;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649955;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHs3TBeATc7b//FhxkEt2/WCzVeeunZzhAQkOmMU8po=;
	b=UsmN4p87GxuYleqq00lYDTd4+uDZ5daa/wZvPBdiqirc2unzPwBFDMr34xdIZTuSKZa1UF
	2fGmOzrliEw+KlJ6hobUR1YVfv61U+BEna7cr4tE0Gu27zN0ve1lH4w5RTvB4ET7JjhqXT
	QtsaHsdQXrx8/+iI82nC0S7fi3fufds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72E4440BF2;
	Thu, 22 Oct 2026 06:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342DE1F000C1;
	Thu, 22 Oct 2026 06:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649954;
	bh=QHs3TBeATc7b//FhxkEt2/WCzVeeunZzhAQkOmMU8po=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eyNw6Z1RmBHG1MSh/ULjQnLS2aBGT84BS4dDyy0TgXQ5iWTQrJrlX9ncAto044aeZ
	 EuvTY6V26P19vkTQTux3hG5+CVOsBqs5T/VjAWQ1ES30pVEnlEXCxVj02ppksGR3az
	 RBGh3lE5ISpLx7kuxI96fxMIaaK5U6fy5xQqrPNHPciAW7aIVpFuuiESN+n7C84ayx
	 E7vXw5oFHURReCHHWMuVWp1MQOnDXYciT2s34PsezSDTwxA1r0P5DPNn0cryjFJxKv
	 tPaxNVTPRQOfNPNrl/8C+6ZBesq7tSeTihPP1HSuVLhLKfNJUvGsOkJZKsWKaKLVLv
	 sGxgMJvKWSOyw==
Message-ID: <sashiko-outbox-181078@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/12] mm, swap: support physical swap as a vswap
 backend
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021060323.553433-5-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021060323.553433-5-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:11 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 520FC140003
X-Stat-Signature: jpb91gsa7oog7kgrmfbie17rrmizsfn8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792649955-891509
X-HE-Meta: U2FsdGVkX18MMcWMExbgIORxPyWCWRQTkdYGtj4OFkNlU/F2VVwtTy+Y68bIdBGCbG5m9UXQsT38ZCvDOWTaW36UdmblW67xD6urBKmLAsfMCx1xiOsFwA+NM7oYl8y229QPVLMLOEjVpEqrlxlpDg92dkuInQknO1Di2hTxu4C+Lu+bknNWW6XDf4o/SbFa3djfsi7o7TatMTp8YM+uteGFZUrQIUR+a8QA1td6ThFvPczdnUMriiAtuHd1h//BXFmwSBgoInTTg2YmYu2tGXJCs7uBlxisNv9nc29G0lFDYSqq5PLYG4yYG3YHseJ6S09yJhiTKTgQqiSYEqXFbJ/gaTaCOVd1J/BiuW+wva4vA7nJcm1jMCR3L92ho0DH74bA9WYoFbxDny2mGczL0ZQuCiJTfrhOjcgNz8ajKSEIjS1JQAtk+bTP8RaV+BFDl8oPCO2OMILhEf/nIlkk9ICfNCjFOu+ju/X6BOw39Ec9As68TNrWwPLcTqjGNgUAuwWkr8HYOJlbIWgx4hpG8+0svd8hRHG971igoZ1LXSkgyylVVCNmgAhOXbA1OLswND8zD/XS3QnThJuLgEfv/tHV8RKMkcfVBhmsXjVVmKmFfxch/O5Ahc9HNTRG00O4tGkzaupbcexrx7hNeSfrQvC22hKLfwoiUK74NUHrFe+jOKmKjGCbx3fGJMJQ2WxjA4+khkYEb93picLCSKa8zkXz7Cv0GpPKJUCECbKrhMrEfcZpeYkZSv/60neSebhh2mFKjrYoK7vgoKwHYF/mtFbI25pUkwTZAExSAFINcr9a1NpkxZUN1zsjhoNEB4rtv5mlgXQPwlp8vgvYm+F3a+T7an7f2hl6aBr8d/yQDn9rNdvZIRk/ayOeacjevNmFoWMF7Dh2BDeRsCVwu+/5SXukH9FPHQu3jAV2/ro4upzFY3Vp3Szb+3vMD7vdg6DQCwBdhc5vGGMarT7gX3b
 f0NvQv0c
 FHmzrlg0ZMpzQr2FkZqX/1qwVESyGaMAjvj2jqElV0lQnC41J94RiG9bbHZ+9iDcJVKNVXKl09gEi44S3kCoWDNJWW29Byy6Lj3lt98wP4SqyJ/y/yeeQZSnrcgbfKZ1FPnpV1na8lp8ypntyB9SUmcfdUOVGZEPMp5IUVFu/s2CdCZkJDUwwkoAgmzxu2MPJhS5kv9g7sPIPu43xEusNCIEumtHNeLItaDYYjWqgHbw7V9EmGsG490aGm57A1AUfpS6rlh6FSQi6xKwMXXqHONoM+g+rKbBVbzYPGUhBkGBXURmLq8Z4daLD639+RZ+D9KiRGniMzpI4hUZTympKdvmWzhwpUada9ll/KNY7cVOJQZrSaIOZKmVmPYleBvZeiEQC/k5eHxzolEN4UHu6YIx8Vi8YfKMD1vaECEhT/9FYx441nDGYi2+zYm38GK2XH+nU/Fewth8bFbbZ82IV3C1xTYb3igzNouwsmY40Aa3Jt1Lace+BitJd6CQN9TD6HA02GlBlhXhYZEppZe/t+KPy0wd4KJFU3IKQsupQrN/dZRshY+UYf8qvIeDR3lxD+09mtcTMt2rfs0Kx0mzqfkn/Mg==
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
- [High] mm: try_to_unuse() dirties unmapped vswap folios rejected by pageo=
ut()
- [High] mm: try_to_unuse() leaks vswap folios and slots when swap count is=
 zero
- [High] mm: large vswap folios declined by zswap fail swapout without spli=
tting
--

commit f1735375be4432e3cb8facdcc6b588e080aeb34c
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: support physical swap as a vswap backend

This commit adds physical swapfile support as a backend for virtual swap
entries when zswap declines a folio during swap_writeout(), tracking the
reverse mapping via vswap-tagged swap_table entries on the physical cluster.
During swapoff, try_to_unuse() reads vswap-backed physical slots into the
swap cache and releases their physical backing slots before walking process
and shmem mappings.

> diff --git a/mm/page_io.c b/mm/page_io.c
> index 61bb5c6e97595..ed8c037e4aa08 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -209,6 +209,7 @@ static void swap_zeromap_folio_clear(struct folio *fo=
lio)
>   */
>  int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  {
> +	swp_entry_t phys =3D folio->swap;
>  	int ret =3D 0;
> =20
>  	if (folio_free_swap(folio))

[ ... ]

> @@ -257,13 +264,21 @@ int swap_writeout(struct swap_io_ctx *ctx, struct f=
olio *folio)
>  	}
>  	rcu_read_unlock();
> =20
> -	/* A vswap folio has no physical slot to write to. */
>  	if (is_vswap_entry(folio->swap)) {
> +		phys =3D folio_realloc_swap(folio);
> +		if (!phys.val) {
> +			folio_mark_dirty(folio);
> +			return AOP_WRITEPAGE_ACTIVATE;
> +		}
> +	}

[Severity: High]
What happens here when a large folio (order > 0) with a virtual swap entry
is declined by zswap_store() and the underlying physical swap cannot satisfy
a high-order allocation?

During reclaim in shrink_folio_list() or shmem_writeout(), folio_alloc_swap=
()
allocates from vswap_si via vswap_alloc() -> cluster_alloc_swap_entry():

mm/swapfile.c:cluster_alloc_swap_entry() {
	if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
		return 0;
}

Because swap_is_vswap(vswap_si) is true, vswap_alloc() succeeds for order >=
 0
folios even when the physical swap devices are regular swapfiles without
SWP_BLKDEV or have fragmented high-order clusters. As a result,
folio_alloc_swap() returns 0 instead of -E2BIG, bypassing the
split_folio_to_list() fallback in both shrink_folio_list() and
shmem_writeout().

Later in swap_writeout(), if zswap_store() declines the large folio,
folio_realloc_swap() -> folio_alloc_phys_swap() attempts to allocate a
contiguous physical swap range of folio_order(folio), which always fails on
non-SWP_BLKDEV swapfiles and fails when high-order physical clusters are
unavailable. swap_writeout() then marks the folio dirty and returns
AOP_WRITEPAGE_ACTIVATE without splitting it.

On subsequent reclaim passes, an anonymous large folio is already in the sw=
ap
cache with PTEs referencing its vswap slots, so shrink_folio_list() skips t=
he
!folio_test_swapcache(folio) block where split_folio_to_list() is called:

mm/vmscan.c:shrink_folio_list() {
	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
			!folio_test_swapcache(folio)) {
		...
		ret =3D folio_alloc_swap(folio);
		if (ret) {
			...
			if (split_folio_to_list(folio, folio_list))
				goto activate_locked;
}

For a large shmem folio, shmem_writeout() removes the unsplit folio from the
swap cache on AOP_WRITEPAGE_ACTIVATE without reaching its -E2BIG split path,
repeating the same vswap_alloc() success and folio_realloc_swap() failure on
every pass.

Can this cause large vswap folios declined by zswap to never split or swap
out?

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 69fac2d905a4f..be66ac79313ce 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -3087,19 +3287,95 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
> =20
>  static int try_to_unuse(unsigned int type)
>  {
> +	struct mempolicy *mpol =3D get_task_policy(current);
>  	struct mm_struct *prev_mm;
>  	struct mm_struct *mm;
>  	struct list_head *p;
>  	int retval =3D 0;
>  	struct swap_info_struct *si =3D swap_info[type];
>  	struct folio *folio;
> -	swp_entry_t entry;
> -	unsigned int i;
> +	struct swap_io_ctx ctx;
> +	swp_entry_t entry, vswap_entry, phys;
> +	unsigned long swp_tb;
> +	unsigned int i, j;
> =20
>  	if (!swap_usage_in_pages(si))
>  		goto success;
> =20
>  retry:
> +	/*
> +	 * Free vswap-backing slots (Vswap-tagged) first. Walk physical
> +	 * clusters, read the vswap entry from the rmap, ensure the data
> +	 * is in the swap cache, and transition PHYS to FOLIO. Freeing the
> +	 * physical backing is enough, so no page table walk is needed.
> +	 */
> +	i =3D 0;
> +	while (vswap_is_enabled() &&
> +	       swap_usage_in_pages(si) &&
> +	       !signal_pending(current) &&
> +	       (i =3D find_next_to_unuse(si, i)) !=3D 0) {
> +		swp_tb =3D swap_table_lookup(swp_entry(si->type, i));
> +		if (!swp_tb_is_vswap(swp_tb))
> +			continue;
> +
> +		vswap_entry =3D swp_tb_vswap_to_swp_entry(swp_tb);
> +
> +		folio =3D swap_cache_get_folio(vswap_entry);
> +		if (!folio) {
> +			folio =3D __swap_cache_alloc_folio(vswap_entry,
> +							 GFP_HIGHUSER_MOVABLE,
> +							 BIT(0), NULL, mpol,
> +							 NO_INTERLEAVE_INDEX);
> +			if (IS_ERR(folio)) {
> +				if (PTR_ERR(folio) =3D=3D -ENOMEM)
> +					return -ENOMEM;
> +				continue;
> +			}
> +			folio_add_lru(folio);
> +			ctx =3D (struct swap_io_ctx){};
> +			swap_read_folio(&ctx, folio);
> +			swap_read_submit(&ctx);
> +		}
> +		folio_lock(folio);
> +
> +		if (!folio_matches_swap_entry(folio, vswap_entry)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			continue;
> +		}
> +
> +		/*
> +		 * Re-validate under folio lock: rmap holds folio->swap + j
> +		 * for some j in [0, nr_pages). Check folio->swap still maps
> +		 * to the contiguous physical run that includes our slot i.
> +		 */
> +		j =3D vswap_entry.val - folio->swap.val;
> +		phys =3D vswap_to_phys(folio->swap);
> +		if (!phys.val || swp_type(phys) !=3D type ||
> +		    swp_offset(phys) + j !=3D i) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			continue;
> +		}
> +
> +		folio_wait_writeback(folio);
> +		folio_release_vswap_backing(folio);
> +		/*
> +		 * Drop a folio whose read failed rather than dirtying
> +		 * uninitialised memory; the next fault finds no backing and
> +		 * gets SIGBUS.
> +		 */
> +		if (unlikely(!folio_test_uptodate(folio)))
> +			swap_cache_del_folio(folio);
> +		else
> +			folio_mark_dirty(folio);

[Severity: High]
Can pageout() ever write out the unmapped swap-cache folios allocated and
dirtied by this pre-pass?

When __swap_cache_alloc_folio() -> __swap_cache_alloc() allocates a fresh
swap-cache folio here, it sets PG_swapbacked and PG_swapcache, but leaves
folio->mapping as NULL because try_to_unuse() does not map the folio into a
VMA via folio_add_new_anon_rmap(). Shmem folios in the swap cache also have
folio->mapping set to NULL. As a result, folio_test_anon(folio) is false.

When shrink_folio_list() later scans one of these dirty swap-cache folios on
 the LRU, folio_mapping(folio) returns &swap_space and shrink_folio_list()
calls pageout():

mm/vmscan.c:pageout() {
	if (folio_ref_count(folio) !=3D 1 + folio_nr_pages(folio) || !mapping)
		return PAGE_KEEP;
	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
		return PAGE_ACTIVATE;
	if (!folio_clear_dirty_for_io(folio))
		return PAGE_CLEAN;
}

Because mapping is &swap_space (!shmem_mapping(mapping)) and
folio_test_anon(folio) is false, pageout() unconditionally returns
PAGE_ACTIVATE before reaching swap_writeout(). Wouldn't this prevent reclaim
from ever writing these dirtied vswap folios out to zswap or another swap
device until they are faulted in?

> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}

[Severity: High]
Does this pre-pass leak the folio, its vswap slot, and its memcg swap charge
if the vswap entry's swap count is 0 (or drops to 0 concurrently)?

There are two ways the vswap entry can have swap_count =3D=3D 0 when reachi=
ng
folio_release_vswap_backing(folio):

1. While try_to_unuse() holds the folio lock (during swap_read_folio() IO or
   before folio_unlock()), the owning process exits or zaps the swap PTE via
   zap_nonpresent_ptes() -> free_swap_and_cache_nr() ->
   swap_put_entries_cluster(). That path decrements the vswap slot's swap
   count to 0 and calls __try_to_reclaim_swap(), which fails folio_trylock()
   and bails out expecting the folio lock holder to clean up.

2. A prior read fault in do_swap_page() mapped the folio, decremented the
   vswap entry's swap count to 0 via folio_put_swap(), and left the folio in
   the swap cache because should_try_to_free_swap() saw
   folio_phys_swap_backed(folio) =3D=3D true.

After folio_release_vswap_backing(folio) frees the physical slot,
folio_phys_swap_backed(folio) becomes false, and try_to_unuse() marks the
folio dirty without calling folio_free_swap(folio) (unlike the post-pass at
the end of try_to_unuse()).

In the first case, the unlocked folio is unmapped, has folio->mapping =3D=
=3D NULL
(!folio_test_anon(folio)), has swap_count =3D=3D 0, and is no longer physic=
ally
backed. pageout() rejects it with PAGE_ACTIVATE before reaching
swap_writeout() -> folio_free_swap(), and the activate_locked path in
shrink_folio_list() also skips folio_free_swap() because
folio_phys_swap_backed(folio) is now false:

mm/vmscan.c:shrink_folio_list() {
activate_locked:
	/* Not a candidate for swapping, so reclaim swap space. */
	if (folio_test_swapcache(folio) &&
	    ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio)) ||
	     folio_test_mlocked(folio)))
		folio_free_swap(folio);
}

Should try_to_unuse() check or call folio_free_swap(folio) when releasing t=
he
vswap backing here?

> =20
> +	if (!swap_usage_in_pages(si))
> +		goto success;
> +
>  	retval =3D shmem_unuse(type);

[ ... ]

=E5=AE=8C=E7=BE=8E (Wait: oops, don't write any extra text after the report=
! Let's make sure the final output has only the report and ends with a blan=
k line.)
Let's review the whole text and output it cleanly.commit f1735375be4432e3cb=
8facdcc6b588e080aeb34c
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: support physical swap as a vswap backend

This commit adds physical swapfile support as a backend for virtual swap
entries when zswap declines a folio during swap_writeout(), tracking the
reverse mapping via vswap-tagged swap_table entries on the physical cluster.
During swapoff, try_to_unuse() reads vswap-backed physical slots into the
swap cache and releases their physical backing slots before walking process
and shmem mappings.

> diff --git a/mm/page_io.c b/mm/page_io.c
> index 61bb5c6e97595..ed8c037e4aa08 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -209,6 +209,7 @@ static void swap_zeromap_folio_clear(struct folio *fo=
lio)
>   */
>  int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  {
> +	swp_entry_t phys =3D folio->swap;
>  	int ret =3D 0;
> =20
>  	if (folio_free_swap(folio))

[ ... ]

> @@ -257,13 +264,21 @@ int swap_writeout(struct swap_io_ctx *ctx, struct f=
olio *folio)
>  	}
>  	rcu_read_unlock();
> =20
> -	/* A vswap folio has no physical slot to write to. */
>  	if (is_vswap_entry(folio->swap)) {
> +		phys =3D folio_realloc_swap(folio);
> +		if (!phys.val) {
> +			folio_mark_dirty(folio);
> +			return AOP_WRITEPAGE_ACTIVATE;
> +		}
> +	}

[Severity: High]
What happens here when a large folio (order > 0) with a virtual swap entry
is declined by zswap_store() and the underlying physical swap cannot satisfy
a high-order allocation?

During reclaim in shrink_folio_list() or shmem_writeout(), folio_alloc_swap=
()
allocates from vswap_si via vswap_alloc() -> cluster_alloc_swap_entry():

mm/swapfile.c:cluster_alloc_swap_entry() {
	if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
		return 0;
}

Because swap_is_vswap(vswap_si) is true, vswap_alloc() succeeds for order >=
 0
folios even when the physical swap devices are regular swapfiles without
SWP_BLKDEV or have fragmented high-order clusters. As a result,
folio_alloc_swap() returns 0 instead of -E2BIG, bypassing the
split_folio_to_list() fallback in both shrink_folio_list() and
shmem_writeout().

Later in swap_writeout(), if zswap_store() declines the large folio,
folio_realloc_swap() -> folio_alloc_phys_swap() attempts to allocate a
contiguous physical swap range of folio_order(folio), which always fails on
non-SWP_BLKDEV swapfiles and fails when high-order physical clusters are
unavailable. swap_writeout() then marks the folio dirty and returns
AOP_WRITEPAGE_ACTIVATE without splitting it.

On subsequent reclaim passes, an anonymous large folio is already in the sw=
ap
cache with PTEs referencing its vswap slots, so shrink_folio_list() skips t=
he
!folio_test_swapcache(folio) block where split_folio_to_list() is called:

mm/vmscan.c:shrink_folio_list() {
	if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
			!folio_test_swapcache(folio)) {
		...
		ret =3D folio_alloc_swap(folio);
		if (ret) {
			...
			if (split_folio_to_list(folio, folio_list))
				goto activate_locked;
}

For a large shmem folio, shmem_writeout() removes the unsplit folio from the
swap cache on AOP_WRITEPAGE_ACTIVATE without reaching its -E2BIG split path,
repeating the same vswap_alloc() success and folio_realloc_swap() failure on
every pass.

Can this cause large vswap folios declined by zswap to never split or swap
out?

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 69fac2d905a4f..be66ac79313ce 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -3087,19 +3287,95 @@ static unsigned int find_next_to_unuse(struct swa=
p_info_struct *si,
> =20
>  static int try_to_unuse(unsigned int type)
>  {
> +	struct mempolicy *mpol =3D get_task_policy(current);
>  	struct mm_struct *prev_mm;
>  	struct mm_struct *mm;
>  	struct list_head *p;
>  	int retval =3D 0;
>  	struct swap_info_struct *si =3D swap_info[type];
>  	struct folio *folio;
> -	swp_entry_t entry;
> -	unsigned int i;
> +	struct swap_io_ctx ctx;
> +	swp_entry_t entry, vswap_entry, phys;
> +	unsigned long swp_tb;
> +	unsigned int i, j;
> =20
>  	if (!swap_usage_in_pages(si))
>  		goto success;
> =20
>  retry:
> +	/*
> +	 * Free vswap-backing slots (Vswap-tagged) first. Walk physical
> +	 * clusters, read the vswap entry from the rmap, ensure the data
> +	 * is in the swap cache, and transition PHYS to FOLIO. Freeing the
> +	 * physical backing is enough, so no page table walk is needed.
> +	 */
> +	i =3D 0;
> +	while (vswap_is_enabled() &&
> +	       swap_usage_in_pages(si) &&
> +	       !signal_pending(current) &&
> +	       (i =3D find_next_to_unuse(si, i)) !=3D 0) {
> +		swp_tb =3D swap_table_lookup(swp_entry(si->type, i));
> +		if (!swp_tb_is_vswap(swp_tb))
> +			continue;
> +
> +		vswap_entry =3D swp_tb_vswap_to_swp_entry(swp_tb);
> +
> +		folio =3D swap_cache_get_folio(vswap_entry);
> +		if (!folio) {
> +			folio =3D __swap_cache_alloc_folio(vswap_entry,
> +							 GFP_HIGHUSER_MOVABLE,
> +							 BIT(0), NULL, mpol,
> +							 NO_INTERLEAVE_INDEX);
> +			if (IS_ERR(folio)) {
> +				if (PTR_ERR(folio) =3D=3D -ENOMEM)
> +					return -ENOMEM;
> +				continue;
> +			}
> +			folio_add_lru(folio);
> +			ctx =3D (struct swap_io_ctx){};
> +			swap_read_folio(&ctx, folio);
> +			swap_read_submit(&ctx);
> +		}
> +		folio_lock(folio);
> +
> +		if (!folio_matches_swap_entry(folio, vswap_entry)) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			continue;
> +		}
> +
> +		/*
> +		 * Re-validate under folio lock: rmap holds folio->swap + j
> +		 * for some j in [0, nr_pages). Check folio->swap still maps
> +		 * to the contiguous physical run that includes our slot i.
> +		 */
> +		j =3D vswap_entry.val - folio->swap.val;
> +		phys =3D vswap_to_phys(folio->swap);
> +		if (!phys.val || swp_type(phys) !=3D type ||
> +		    swp_offset(phys) + j !=3D i) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			continue;
> +		}
> +
> +		folio_wait_writeback(folio);
> +		folio_release_vswap_backing(folio);
> +		/*
> +		 * Drop a folio whose read failed rather than dirtying
> +		 * uninitialised memory; the next fault finds no backing and
> +		 * gets SIGBUS.
> +		 */
> +		if (unlikely(!folio_test_uptodate(folio)))
> +			swap_cache_del_folio(folio);
> +		else
> +			folio_mark_dirty(folio);

[Severity: High]
Can pageout() ever write out the unmapped swap-cache folios allocated and
dirtied by this pre-pass?

When __swap_cache_alloc_folio() -> __swap_cache_alloc() allocates a fresh
swap-cache folio here, it sets PG_swapbacked and PG_swapcache, but leaves
folio->mapping as NULL because try_to_unuse() does not map the folio into a
VMA via folio_add_new_anon_rmap(). Shmem folios in the swap cache also have
folio->mapping set to NULL. As a result, folio_test_anon(folio) is false.

When shrink_folio_list() later scans one of these dirty swap-cache folios on
the LRU, folio_mapping(folio) returns &swap_space and shrink_folio_list()
calls pageout():

mm/vmscan.c:pageout() {
	if (folio_ref_count(folio) !=3D 1 + folio_nr_pages(folio) || !mapping)
		return PAGE_KEEP;
	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
		return PAGE_ACTIVATE;
	if (!folio_clear_dirty_for_io(folio))
		return PAGE_CLEAN;
}

Because mapping is &swap_space (!shmem_mapping(mapping)) and
folio_test_anon(folio) is false, pageout() unconditionally returns
PAGE_ACTIVATE before reaching swap_writeout(). Wouldn't this prevent reclaim
from ever writing these dirtied vswap folios out to zswap or another swap
device until they are faulted in?

> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}

[Severity: High]
Does this pre-pass leak the folio, its vswap slot, and its memcg swap charge
if the vswap entry's swap count is 0 (or drops to 0 concurrently)?

There are two ways the vswap entry can have swap_count =3D=3D 0 when reachi=
ng
folio_release_vswap_backing(folio):

1. While try_to_unuse() holds the folio lock (during swap_read_folio() IO or
   before folio_unlock()), the owning process exits or zaps the swap PTE via
   zap_nonpresent_ptes() -> free_swap_and_cache_nr() ->
   swap_put_entries_cluster(). That path decrements the vswap slot's swap
   count to 0 and calls __try_to_reclaim_swap(), which fails folio_trylock()
   and bails out expecting the folio lock holder to clean up.

2. A prior read fault in do_swap_page() mapped the folio, decremented the
   vswap entry's swap count to 0 via folio_put_swap(), and left the folio in
   the swap cache because should_try_to_free_swap() saw
   folio_phys_swap_backed(folio) =3D=3D true.

After folio_release_vswap_backing(folio) frees the physical slot,
folio_phys_swap_backed(folio) becomes false, and try_to_unuse() marks the
folio dirty without calling folio_free_swap(folio) (unlike the post-pass at
the end of try_to_unuse()).

In the first case, the unlocked folio is unmapped, has folio->mapping =3D=
=3D NULL
(!folio_test_anon(folio)), has swap_count =3D=3D 0, and is no longer physic=
ally
backed. pageout() rejects it with PAGE_ACTIVATE before reaching
swap_writeout() -> folio_free_swap(), and the activate_locked path in
shrink_folio_list() also skips folio_free_swap() because
folio_phys_swap_backed(folio) is now false:

mm/vmscan.c:shrink_folio_list() {
activate_locked:
	/* Not a candidate for swapping, so reclaim swap space. */
	if (folio_test_swapcache(folio) &&
	    ((mem_cgroup_swap_full(folio) && folio_phys_swap_backed(folio)) ||
	     folio_test_mlocked(folio)))
		folio_free_swap(folio);
}

Should try_to_unuse() check or call folio_free_swap(folio) when releasing t=
he
vswap backing here?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D4

