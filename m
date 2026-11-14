Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C12B606A335
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jit11Agc
Received: by kanga.kvack.org (Postfix)
	id 47EFE6B05B1; Fri, 13 Nov 2026 19:49:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428026B05B2; Fri, 13 Nov 2026 19:49:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364FE6B05B4; Fri, 13 Nov 2026 19:49:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1705C6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:49:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97516A0277
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:49:35 +0000 (UTC)
X-FDA: 85431891510.13.5FBDB5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E07A34000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:49:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jit11Agc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794617374;
	b=tjHzgpVtCgf/Z7ZUwvL5L5G2mOds2VUHxCQVYYecP6wChltqYsJhvkPX05KZTwQKGSHTxn
	rtpQnU5T+UzBfJosj4motd/762prg8fdx8UQaaMdUpO5tIaHSXHyhcWnIgInATJb0CtNG8
	rCbFbFq3/NNy02MYQ31MuckceuD8Mks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794617374;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+dL/vx0YREKXe/mmst7t7qjWF6dJz1HPiap+qgB9Tc=;
	b=oiNbfDZzdDOq+/LT9yZdvhtC7VK4zbJbV1+kTxHkU08eouyEH/Q4aub03hssUqxyAXljGE
	iuMh4oRDiJsHsmkWxWrsY9ryoBJBdvHLAW9JAxs9C8pbZGhc9Rem4gBFs8YfBB+Llr40dk
	qeHttKmHm+/O8RH3P7YX7TquHgHC1Bc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jit11Agc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C21C9436E2;
	Sat, 14 Nov 2026 00:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22B21F000C4;
	Sat, 14 Nov 2026 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794617372;
	bh=5+dL/vx0YREKXe/mmst7t7qjWF6dJz1HPiap+qgB9Tc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jit11AgcD/PICaMOQ6zjYrUiiyztC61kmwqm48OTwjt/hIwKigOL4ofXeHtrKyexA
	 VEgHOAhhmfT+AbuvesPbbljCRo/D721W4U+lC0GsMSBz1G8g7AzDLKUme7HnPcBv3x
	 mlFv0K29ocqK9Tru2rBHgT31uotXa7fHVX1M3d/n882AU/uxJwlIJVyA33hljXnrw8
	 6ZF6q7fgSe58Leck8Ekd5tiOb/8B4r9viwH4MWhExMURPcvJmH9Ms0dso5/rZmvIOr
	 6rsXPEaz628xSDtOPcYS0OGkHSXRw9NNKlNIQB/cBZUdhuhuxEUnEjK2E6b8tpvCFR
	 HT4ivUn8+ZewQ==
Message-ID: <sashiko-outbox-213953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node
 counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Joanne Koong" <joannelkoong@gmail.com>, akpm@linux-foundation.org, david@kernel.org
Cc: yosry@kernel.org, mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org, linux-mm@kvack.org, damon@lists.linux.dev, tj@kernel.org
In-Reply-To: <20261114002822.1043378-3-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
 <20261114002822.1043378-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 00:49:31 +0000
X-Rspamd-Queue-Id: E07A34000A
X-Rspamd-Server: rspam12
X-Stat-Signature: kppk64qyh8ztycgzcdzromfr39jan9q6
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794617373-766407
X-HE-Meta: U2FsdGVkX18DgpGW2j+R+5P91HJzlVL92LAvehh4GOdcVVDlcjYj4kfFk8Xqlljdjor9nHY6ilGEC02ZVDl+o9cFqHHU8Yu4rgLpXkGYeKfPPk8RpmXLxkX/Ics0q0LdB4wRSLCYbPfdoP/N065gzAfO5pgK4M8UP9HeQpReyg4aSBGzVnK+foGAsDEhvPdYBs3iDnEd61ZZhvIKBtgqeO6ZlNyHcDd8SDKNjDDEMF+7ANh+0sGAy3dJxrybMccnarNhKLbxsxlU1ZWFoZeje6RyEGxxlRiBDEwbfmaV6eqKL4DFZ41DJT1Q4JAPxWzr3CC8NRK5kQPdbxSUI/qZc8EVEQ5Lqe/y6e3gkhC49zAuemjRv3oR+mNH3aYxkOUGQFnS+nBNAvcrPLUCv5V1T9kuMrDWRE1Vk0z6I421hhpd+wY/yoomRrj1kM4B+Tvrn62LQGah8832+rKbTZM1E3k0bkOZhM7F515NF8eUb42kWH6btcrvqTU/iAC7W0JGgCx8JxKc5ODPiBxZB/yJQC8BUydfGIcTBlwpKtSuqQ99J3wp9dd32qOdqsVMZWP4IL6V2xp6/I5BVEHcaXmSibXHlsUgifbBdVNdwMVO3OSstcJBD6BFYPM0lj1FZrKo6ZlT5BqZ5o6DvOgJsNHjBJNiPzZhDABssdLL7VLGl2ByJPlzQKND3GfnqkyXMf+xrp2W5MrxStFK3YGZekvqOeKMLuBmaq5dTEn4g3ViV1RxbphGhaKWeFKU/bD4IaXBe111LCc/TWj6S+cmcHrjWu5qicrb8pPlofN74zGuo7/3wNct84vCTSXiK5iuBFzJtnGjVWvnf7MrlNFLqjpp2s54vQKJ0qeVRVtN41IkMjLOK5FXJBia2galZLtfDlGadx2soGQWXoJBBnGVJIq6tbv6wK5B6wBTxFNDCAi9jG2DUIZD6YpevGs9vA3X1hl7M0WROCGRnxt3TbZrkRC
 6Px8aYRp
 HlF/4kpR7BTn0szxguOUBkYedxvteuoDwCaMnVoT/zwoxUpNngU2zqEL6mQHB3kTLFR1HcreHvpi95pzdc/CnbR9WHBgILYfdKcUqK5YmL1gb8RCEpq8V/3WVZ7ImrsP5sjGDCVS+8HGBiN/TvVRnMFz0pzQ+XMloORLVXBZ/n3zj18SX0/kGMj0RouI7SnK9ikctO3u8QXS1YNcy9QB/H9PHXp8E+/apm7jh/Ns2FMykfMuI2rkQSdSFWuQ/jL1rsy/mtNzoqHXLkX6K3bhGtxxuq6wCp7N1QLGGfs92MNrkID5FGeEnVDP7IAIiWj7zn7ZkbOXmDcS5LCpmHOjQXdicdi0/arO+KcRMRBKdNgVUTl0W98tjl/5bdJKhm+oquJdFH91NhuqIpzFQA4i3ScIWdekanOguZ1x0cggviAD6OJgl5RtiVf76Kh1yl5EhhUnurflEANZVPJfnfPK2p2vw4zHV+xNjn3XeWGOZexcYFoBiv2GqyZHkcfwAU56wIlmOPH8+TnUyj8pLDcnBXqW6LsllOnn3O7AJRyj8pKlvnSRPWHSGlV6vNjbuUfByf6ehlk0hFh2IbcN8PyPxC7kJyFDtUr+4sM2LvfkD7utIwcwUrCC/7FRkwERrVki5kFtxw1lol58LbClxjcbTnAoXKNH7xGuGOeqZA1pdSXGai6OzqZDOPLhAMtG0EAI2W1YLKWSVfPbiF8DcmRkc736vP17Br/9RgXB4Z6tNU4nBbu4RE4b4ZltWYA==
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
- [Medium] mm: memcg: missing NR_VMSCAN_WRITE and folio stats in
  lruvec_use_node_stat()
--

commit 95f274e85e4bf7a42c96a69c0a4509c8d43a4417
Author: Joanne Koong <joannelkoong@gmail.com>

mm: memcg: read root lruvec stats from the node counters

This commit makes lruvec_page_state() and lruvec_page_state_monotonic() read
the node counter directly for the root memcg on stats whose node counter
equals the root memcg's hierarchical value.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf397..196c0382181b1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -504,13 +504,67 @@ struct lruvec_stats {
>  	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
>  };
> =20
> +/*
> + * Whether to read the node counter for @idx instead of @lruvec's rstat =
value.
> + * This is only done for the root memcg for stats where every update also
> + * updates a memcg's stats, so the root memcg's hierarchical value equal=
s the
> + * node counter. The node counter is preferred since it is always up to =
date,
> + * and avoids an rstat flush which for the root memcg flushes every cgro=
up in
> + * the system.
> + */
> +static bool lruvec_use_node_stat(const struct lruvec *lruvec,
> +				 enum node_stat_item idx)
> +{
> +	if (!mem_cgroup_is_root(lruvec_memcg(lruvec)))
> +		return false;
> +
> +	switch (idx) {
> +	case NR_INACTIVE_ANON:
> +	case NR_ACTIVE_ANON:
> +	case NR_INACTIVE_FILE:
> +	case NR_ACTIVE_FILE:
> +	case NR_UNEVICTABLE:
> +	case WORKINGSET_REFAULT_ANON:
> +	case WORKINGSET_REFAULT_FILE:
> +	case WORKINGSET_ACTIVATE_ANON:
> +	case WORKINGSET_ACTIVATE_FILE:
> +	case WORKINGSET_RESTORE_ANON:
> +	case WORKINGSET_RESTORE_FILE:
> +#ifdef CONFIG_NUMA_BALANCING
> +	case PGPROMOTE_SUCCESS:
> +#endif

[Severity: Medium]
Should lruvec_use_node_stat() also include NR_VMSCAN_WRITE, NR_SWAPCACHE, a=
nd
the other charged-folio stats between WORKINGSET_RESTORE_FILE and
PGPROMOTE_SUCCESS in memcg_node_stat_items[]?

The switch statement drops the entire contiguous block from
WORKINGSET_NODERECLAIM through NR_SWAPCACHE rather than only the kernel
memory items (WORKINGSET_NODERECLAIM and NR_VMALLOC..NR_SECONDARY_PAGETABLE=
):

mm/memcontrol.c:memcg_node_stat_items[] {
    ...
	WORKINGSET_RESTORE_FILE,
	WORKINGSET_NODERECLAIM,
	NR_ANON_MAPPED,
	NR_FILE_MAPPED,
	NR_FILE_PAGES,
	NR_FILE_DIRTY,
	NR_WRITEBACK,
	NR_SHMEM,
	NR_SHMEM_THPS,
	NR_FILE_THPS,
	NR_ANON_THPS,
	NR_VMSCAN_WRITE,
	NR_VMALLOC,
	NR_KERNEL_STACK_KB,
	NR_PAGETABLE,
	NR_SECONDARY_PAGETABLE,
#ifdef CONFIG_SWAP
	NR_SWAPCACHE,
#endif
#ifdef CONFIG_NUMA_BALANCING
	PGPROMOTE_SUCCESS,
#endif
    ...
}

In prepare_scan_control() (the only caller of lruvec_page_state_monotonic()=
),
anon IO cost is computed as WORKINGSET_RESTORE_ANON + NR_VMSCAN_WRITE.
Because NR_VMSCAN_WRITE is only updated via lruvec_stat_mod_folio() in
pageout() and is omitted here, root-lruvec reclaim mixes live node counters
for PGROTATE_ANON and WORKINGSET_RESTORE_ANON with the rstat counter for
NR_VMSCAN_WRITE.  Similarly, reclaimable_anon_is_low() on root_mem_cgroup
compares live node counters for NR_INACTIVE_ANON + NR_ACTIVE_ANON against t=
he
unflushed rstat counter for NR_SWAPCACHE.

NR_ANON_MAPPED, NR_ANON_THPS, NR_SHMEM, NR_SHMEM_THPS, NR_FILE_THPS, and
NR_FILE_DIRTY are also only updated on charged folios, whereas NR_FILE_PAGES
(updated via node_stat_mod_folio() for swapcache), NR_WRITEBACK (updated via
node_stat_mod_folio() for NFS unstable writes), and NR_FILE_MAPPED (updated
for uncharged pages in vm_insert_page()) can exceed the root memcg's rstat
value and would need to be noted as exceptions if excluded.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114002822.1043=
378-1-joannelkoong@gmail.com?part=3D2

