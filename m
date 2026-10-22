Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3098606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJx1ezJe
Received: by kanga.kvack.org (Postfix)
	id D4C166B089E; Thu, 22 Oct 2026 02:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23A46B08A0; Thu, 22 Oct 2026 02:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39A56B08A1; Thu, 22 Oct 2026 02:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08746B089E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9809AA83BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:27 +0000 (UTC)
X-FDA: 85349260374.21.F787DDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E4B8040003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJx1ezJe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649966;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRlAEAWzxFVgMWIuR/lCToZqqyKqdgYYKOQdpFsy6mA=;
	b=bHw9lU6B9vVORJWjFPS3P/+YVVpX0uepUgYVxItJaUGiyhi3JkdxACuSEIKbjPon6gbVw8
	714JOhXR3Rt8K6K6ypkSUnaQj0pTGNDWxuZ/Lf/cnXHBImMU0ideiAw6wpemKoz4oaHq7m
	QCIistOlH600tO0YHoCLLqCzATBO5wY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJx1ezJe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649966;
	b=HkZ7q1y2i8Mqxfe+rxpGx55FNzOoEnbo5xtRbUqMDcwb+2zmfJKHqpy8nmUmOdU5zmP7H6
	tPTS1NixQlB5mdA9kxtW+yqujUn+oK0cK8pEnFI+J1H3EUzaFlQfoH6SBTIH/BuzV6o5I8
	lErmSA5Lo3awSrzqF2MnchW1VEOFPyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 433A64060E;
	Thu, 22 Oct 2026 06:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2248C1F000C2;
	Thu, 22 Oct 2026 06:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649965;
	bh=uRlAEAWzxFVgMWIuR/lCToZqqyKqdgYYKOQdpFsy6mA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NJx1ezJepF8emQraP0Rl1fOjBh7MxW+QAcKl9G3HoeO70nB+qeqYhYuApkcwGVsaU
	 wuvRGv9FD77n470XVadnoc7cm5DRYNO8qcV+GvrxY26Qw6kyp19neJpZGdbNoqAEz2
	 KcxtV/14cTjSZxfBUE9VofmXuZ4xXDolrEaSEquvpjDGaoM32VlP8+rE2YofBjdY5i
	 6JdKC1HKufe6HJEZ2Y3RwNNiFuBnRY/nK48V4YoiaMy3kiVmCeRYJHwm15McUjnL9p
	 BdhC2AflAf698GEMrct4rb1T1qCnBvs3d6vbDQCintOpUVsH/hmUFHt6CjnM3zABk9
	 EJ2kMlerj38MQ==
Message-ID: <sashiko-outbox-181082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/12] mm, swap: only charge physical swap entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021060323.553433-9-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021060323.553433-9-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:22 +0000
X-Rspamd-Queue-Id: E4B8040003
X-Rspam-User: 
X-Stat-Signature: q41sdybhwweypjsf411wyn8qcd3fk3yw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792649965-795511
X-HE-Meta: U2FsdGVkX1+T6oAXi9DFiUtG9fQAbjmGNDlsRrA1rkbvhYd1MYdqH3Pkv6j9GetTw4Ohr1A83zlrBoI8+IFvcpM9efPTdWcNrkG0uArzzkUTAv5VRJtE+XURKG+Tze2AjLiKI23ZNydNyBrNDvBB9kmzf0UE/lgO0HX8iSZ3Qscbgez3pRgachYydactNA1oM2S7702GlgVov9wlxR8pEXNQX3GjcVEohiO/70N0bFLIHsLqbaDCVvahA+RQakhOBn3Qzwzfe9OD1VPAzHYxqIQgfwVKxYkS1RQ4D5T+bAegOuwrkj5jkGGrAO1Y/TTC3synZ+vzQe+4LvdV8WDrigSeHWMr9xYof8OcR+rguew4SkzhoWoJ0C4AzbgaNNB0N2bjS49Jipf3wgHGcS3gmq8wOjkRAKsPiUhG5dQ1PzIb5WdLV60qJGD6M1uROgI9iw/N/CcIoQUHL2ONjnj4mm8SeQyVqhU+FXozuGXCe1sRPO/KoCXCFjRE5sit5kKj/Sp1o79NnNAdHW0RNchUMScs0V3TjMkoyH6yDV92MZzdtQR/Y7rRFKUMgulR61Z/9OALBZ34RX+LrVL+3U/4JIVbPsv2gRc2fATPDs/BRR791MC5M35swAvzlWWa0e+1mklaqd2iN+cL1DH/5ZgkaCyMU4qJHXds+C3MxiIopUtHN19tuYSE1ThnSo0/q19j7yJd2X+Ybfm5bhplflCFN/2nOTAOwne1xdpR/Yuxh4d79LMP0Co9C8kxelcwyKXyRl/vUxpaz1npdZMAAjhBd8C/biTnSZ8D+V0G5iRsQCLfYvcHg3vzE7vHdvGyXBVrziRLFUM9F9dYggnLAcppDeKPiwRQeqXQCyNj0wHFhYSWTGG5P3edGwy8Ez6ZlVfTHeKYaDH/jrvbDd7j0EEUqEUG7Y7eHVBt0b8dzK1O0z7zqJwg1vm7UKFUpG12SXFt3b9QjG/4qc5QYNoJUNR
 danf4zH5
 UpbuwMzuddLRQPUK6Lfq/ubRNlF2RzFLovpZvW4RC9kNdZG8S87C/6/U8bMaW+AerU2oOXSSqjYuWWWHK7zrBa62MEwrocNZ0Ulm4FFMbhqRf1/cxYUQn57H9yjACWpW2asVcyie3GUhQYmUXx60jFcEoBInJcuOgJGt9flGaoF1TnKK6rwFyapoTYftBc2ovqu0rfyB84rPFFJPqEyxTA9vWkoC4gQPtDwC4Eiit6IQ8kKoE05WX6Rglhr8KRryNUbc6CJaSveTmP8TMsf0htJwC85c0sR7y4EV+h70QZrULW5Ardvzfpb8j0iz/fjCa/98bM/x9NVxfG4pxYpOFsLonl9zArTjAqPpY7XFJF/ZRkX8wkmoZMAqCtGzVBh3vr8VSxDn0uN8PVbSB+cRlYWldNl+Ix753+ltXxbuyDQmUUPKxbvwlKRf8HO5u+7QPNH1vr+puVvlfWph+eq7hqh0a89+Rr0kj3I9T96BvgdKA3uJ93THotHJcZeXPnBX8zhG3MvtWwUgExD23a8KjClIPAkgdoFq8VIVzOTMlTOm58eu2FHt9+JdhylMZ1Oh7nynK5kd77ZMJobJaDxdr9G5kLJCzRZDNIp5B/UXmOpj9F38=
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
- [Medium] mm, swap: folio_realloc_swap() allocates physical swap before ch=
arging memcg
- [Medium] mm: memcontrol-v1: __memcg1_swapout() omits physical vswap from =
MEMCG_SWAP
--

commit c922e31fae8f71fd3ae6707b90202f40d4d0babb
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: only charge physical swap entries

This commit changes swap memcg accounting so that virtual swap entries are
charged against a memcg's swap counter only when physical swap backing is
allocated rather than when the virtual swap entry is first allocated. It al=
so
splits the swap memcg helpers into separate get, record, charge, uncharge,
and put operations.

> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentati=
on/admin-guide/cgroup-v1/memory.rst
> index 7d2a44af52c93..2a67356d25a0d 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -553,7 +553,7 @@ memory.stat file includes following statistics:
>      pgpgout         # of uncharging events to the memory cgroup. The unc=
harging
>                      event happens each time a page is unaccounted from t=
he
>                      cgroup.
> -    swap            # of bytes of swap usage
> +    swap            # of bytes of physical swap usage
>      swapcached      # of bytes of swap cached in memory
>      dirty           # of bytes that are waiting to get written back to t=
he disk.
>      writeback       # of bytes of file/anon cache that are queued for sy=
ncing to

[ ... ]

> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index b7f2868885071..4e4946728db5a 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -15,6 +15,7 @@
>  #include "internal.h"
>  #include "swap.h"
>  #include "swap_table.h"
> +#include "vswap.h"
>  #include "memcontrol-v1.h"
> =20
>  /* for OOM */
> @@ -299,7 +300,8 @@ void __memcg1_swapout(struct folio *folio, struct swa=
p_cluster_info *ci)
>  	 */
>  	nr_entries =3D folio_nr_pages(folio);
>  	private_id =3D mem_cgroup_private_id_get(memcg, nr_entries);
> -	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> +	if (!is_vswap_entry(folio->swap))
> +		mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
> =20
>  	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, priv=
ate_id);

[Severity: Medium]
Documentation/admin-guide/cgroup-v1/memory.rst is updated above to describe
the swap counter in memory.stat as bytes of physical swap usage.

On cgroup v1 (where do_memsw_account() is true) with vswap and zswap enable=
d,
mem_cgroup_may_zswap() returns true when !cgroup_subsys_on_dfl(memory_cgrp_=
subsys),
so folio_may_vswap() returns true and folio_alloc_swap() allocates virtual
swap entries via vswap_alloc() where is_vswap_entry(folio->swap) is true.

When a vswap folio acquires physical swapfile backing via
folio_realloc_swap() -- either in swap_writeout() when zswap_store() rejects
the folio or in zswap_writeback_entry() when zswap writes an entry back to
disk -- folio->swap remains a virtual swap entry while the physical slot is
recorded in the cluster's virtual_table:

  folio_realloc_swap()
    __vtable_set(ci_dyn, voff + i, vtable_mk_phys(pe));

In folio_realloc_swap(), __mem_cgroup_swap_charge() returns 0 early because
do_memsw_account() is true (and memcg_id in ci->memcg_table is 0 while the
folio is still in the swap cache on cgroup v1).

When writeback completes and the folio is removed from the swap cache via
__swap_cache_del_folio() -> __memcg1_swapout(), __memcg1_swapout() checks
!is_vswap_entry(folio->swap) (and the subsequent commit "mm, swap: add vmst=
at
and memcg counters for vswap" branches on is_vswap_entry(folio->swap) betwe=
en
the vswap and swap counters) and skips incrementing the swap state counter
even when the vswap entry is backed by physical swap. Likewise,
__mem_cgroup_swap_uncharge() and __mem_cgroup_swap_put() never decrement the
swap state counter for vswap entries on cgroup v1.

Does this cause swap and total_swap in cgroup v1 memory.stat to remain at 0
for all vswap-allocated pages backed by physical swap slots?

[ ... ]

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 640e38a55497e..341077fee23be 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -2297,18 +2353,33 @@ swp_entry_t folio_realloc_swap(struct folio *foli=
o)
>  	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  	VM_WARN_ON(!is_vswap_entry(vswap_entry));
> =20
> -	phys_entry =3D vswap_to_phys(vswap_entry);
> -	if (phys_entry.val)
> -		return phys_entry;
> +	voff =3D swp_cluster_offset(vswap_entry);
> +	ci =3D __swap_entry_to_cluster(vswap_entry);
> +	ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, ci);
> +
> +	spin_lock(&ci->lock);
> +	vt =3D __vtable_get(ci_dyn, voff);
> +	if (vtable_type(vt) =3D=3D VSWAP_SWAPFILE) {
> +		spin_unlock(&ci->lock);
> +		return vtable_to_phys(vt);
> +	}
> +	memcg_id =3D __swap_cgroup_get(ci, voff);
> +	spin_unlock(&ci->lock);
> =20
>  	phys_entry =3D folio_alloc_phys_swap(folio);
> -	if (!phys_entry.val)
> +	if (!phys_entry.val) {
> +		mem_cgroup_swap_fail(memcg_id);
>  		return (swp_entry_t){};
> +	}
> =20
> -	voff =3D swp_cluster_offset(vswap_entry);
> +	if (mem_cgroup_swap_charge(memcg_id, nr)) {
> +		__swap_cluster_free_phys_backing(__swap_entry_to_info(phys_entry),
> +						 __swap_entry_to_cluster(phys_entry),
> +						 swp_cluster_offset(phys_entry),
> +						 nr);
> +		return (swp_entry_t){};
> +	}

[Severity: Medium]
With vswap and zswap enabled, a cgroup with memory.swap.max set to 0 (or at
its physical swap limit) can reclaim anonymous pages via:

  mem_cgroup_can_swap()
  shrink_folio_list()
    folio_alloc_swap()

which allocates a vswap entry without charging memcg->swap. When zswap_stor=
e()
subsequently fails in swap_writeout() (for example, when the global zswap p=
ool
is full or memory.zswap.max is reached), swap_writeout() calls
folio_realloc_swap(folio). Similarly, zswap_writeback_entry() calls
folio_realloc_swap(folio) if a cgroup reaches memory.swap.max during a
writeback walk.

In folio_realloc_swap(), memcg_id and nr are already known before calling
folio_alloc_phys_swap(folio), yet physical swap is allocated before
mem_cgroup_swap_charge(memcg_id, nr) is checked. When
mem_cgroup_swap_charge() fails, __swap_cluster_free_phys_backing() frees the
newly allocated physical slot(s):

  __swap_cluster_free_phys_backing()
    pci->count -=3D nr_pages;
    ...
    __swap_cluster_finish_free()
      if (!ci->count)
        free_cluster(si, ci);

Whenever folio_alloc_phys_swap() isolated a fresh empty cluster from
si->free_clusters (which cluster_alloc_swap_entry() prefers on discard-enab=
led
swap devices), pci->count drops from nr back to 0 and free_cluster() is
called. On discard-enabled swap devices, free_cluster() marks the entire
cluster for discard and schedules discard_work; on non-discard devices,
__free_cluster() frees pci->table via call_rcu(). In both cases,
percpu_swap_cluster becomes unusable (!cluster_is_usable()) for the next pa=
ge,
forcing every subsequent rejected page into swap_alloc_slow() to populate a=
nd
immediately tear down or discard another free cluster.

Could folio_realloc_swap() charge the memcg via
mem_cgroup_swap_charge(memcg_id, nr) before calling folio_alloc_phys_swap(),
and uncharge if physical swap allocation fails, so physical swap clusters a=
re
not allocated and immediately destroyed when the cgroup is at memory.swap.m=
ax?

[ ... ]

([c922e31fae8f ("mm, swap: only charge physical swap entries")](https://git=
.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3Dc922e3=
1fae8f71fd3ae6707b90202f40d4d0babb))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D8

