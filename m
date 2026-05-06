Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30AFCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 20:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC1B6B0088; Wed,  6 May 2026 16:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75556B008A; Wed,  6 May 2026 16:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CF96B008C; Wed,  6 May 2026 16:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA99D6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 16:27:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 534B11A02E2
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:27:58 +0000 (UTC)
X-FDA: 84738131436.01.9C3E75B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 869BC2000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:27:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRbXCIA0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778099276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKP6+VzNHaOpukwGg0klBay9jvLxIzw8Cp/J6McSoPw=;
	b=IpcffJLiOBjqK0nKREd4rO/zkw02qz9DRuh0qSdgOTC2k4HHrZL+UNXQadaSwjODlGtLC+
	LCLuZ0JgjamIqcd4Ton28/qZcARAUrbvv263y4i19znwe6dNq8pZJ/0ecaySTS1gx8sapn
	+vlGweP6ArFZCCmgxIdGYd49S2lXZnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778099276; a=rsa-sha256;
	cv=none;
	b=tbLMPM3oI92VMn2JjUti9sHD9WeOCkSRmL6HBUklf0D28FEDG8rupLEDd7n8iNY/+quDyd
	VvyER6oZ8sNIGn1j0Q0xX9rdUbQ6RRgtozjTKVRnlbTyT5JN7WOA+MCgalqSrIT5JTMTBI
	lQc7yWXiof8oGpzJhzI8EZAC1uvHNyw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRbXCIA0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C3E9A6024D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6594EC2BCF5
	for <linux-mm@kvack.org>; Wed,  6 May 2026 20:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778099275;
	bh=DQ/GYFWZIdp0vZtEXllXmvETj2d8V/i4gDbdMfU2MAE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZRbXCIA0y2OWBmYaAongkV33KdWzNcuS61C3sL7FT0VnVZPzLfD8NfROtsCQyQZrK
	 YuwJGDbKA3qqqorV4PR1U6mn+I21LNCYd1mZWHA5p0lQ+4accO3Un8TDmFAAuIqvIt
	 mUrAOUge8YuxGBwP2/zN3Rlx6dV8OcRR7oRFu9eYBbGsIq9NQtFuiVHnQTt1JgAMpn
	 V4+TtRUvhSGCyg6b27w0VUV3WfIhjCPDdvoRJLCEM6Bvt/TrwhtgGwDk3jvt2RedXy
	 SM4d2JzzXu9WK4gVFtqEIZmncUpAxpo3fG4gJifP2bPC8cWKJOVOo2tDoIwmQC3Ezc
	 kK2k/5WG9BDMQ==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64eb84d1e37so47158d50.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 13:27:55 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywzk0oT0xOW5pMXPUWzyG6BKSLjVrQyDptlNPE2MXga7qYdUmqC
	NpmvaKLjwqWwHTvseV9P6+vsDKCRdyncITQpbiHEifWn7ibQzVrH02yK2k0fH6zE4d9lEGbSWgl
	F8vVdrFMCVTC2csXaw7ysTuX62UGSNGtrqGisXjQ2dQ==
X-Received: by 2002:a53:cf08:0:b0:651:c782:6a8 with SMTP id
 956f58d0204a3-65c798f12abmr3970676d50.15.1778099274560; Wed, 06 May 2026
 13:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 22:27:43 +0200
X-Gmail-Original-Message-ID: <CACePvbUWutuq+zX4YryP7zBcF3Sjga8UcFJrjMqzY4J28knA9Q@mail.gmail.com>
X-Gm-Features: AVHnY4IiKtw5_qY9TjdTv1GUvnGvWqZEt-448MvyrWzCjntp8ivLnxelLIVM74M
Message-ID: <CACePvbUWutuq+zX4YryP7zBcF3Sjga8UcFJrjMqzY4J28knA9Q@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] mm, swap: add support for stable large
 allocation in swap cache directly
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 869BC2000D
X-Stat-Signature: phh15wsb9x4q4c9yk6g9hwnji7cegr9y
X-Rspam-User: 
X-HE-Tag: 1778099276-983909
X-HE-Meta: U2FsdGVkX19CVQQA4uaBvSFU1Glr8lTZYn7VvQPf/B+cD/kIBzCk6W4csqw0w1i1/1ecAD40eco8TaHqSOqDJzzbZtnJpSfiyuorRw8DvaIgGYeykXTwNyGlbzFM9SZgieZtxOdNnDI+9gKwEma6TD0RIFyE8w9ilH7Qs2y/MH1wHBnxmSa/DvLMWoFdda8qw/MNp5tDlKyo27s4CiFqe0a1rWMpGHWy0GO/PtF6PdA3qYadLiYg8miAhtd+ANOUfB2BW25p1EEHpq/0Li2mXbCsRuX/sSU+Y5Awm+fWxhsaKmz860MPZFDHio2UxzQvJ0zOKvHCYyT89Cwj+N106vjS4kjxomE+BXAjWA2FvSbXW6L+uq4UAsM8lzDHSLZdISbRIl281WBhsoRA7Rihc+STBHXMTIFhXE9nQeDh79mZVL0gdThrErq8V7bTMIolTzHmB+odTmYH1zEFLykHILrTD9m9iUTHcLcN92SvZYvjaMe7zUgQD7rgziAdexUe1YS3eDF6airAXxmyx6HziGWZd2Vsm37nnooF7VIOtp2VvN/VE1xIPm4w6A2DRH62/jEvU+r5j4SvBiswAoZ1IB5ELiNcZKlUZCs1duHg9/UizXg9YiXeEXaaTK3E0bUCph6OMhJ0PZOm5RzkfvpAJ/5n20pvIkDrxJDqUP0Sus4EI5DSi8yverbc6K9DYHt2eO/OYCiDDklGeSieFd/jMa0ohPEHnvHWccB8LJh1zFw/xgJVI1LlSNWxybYUieVPWQgropvW4ctPuGMgzAbP7ALEVoM2sQ2FyCQkeJs4Pa7jOJ2fyRM9Da19a3r6xlqtpqY8UZWhqc50D7OuTnwfF/148OIK0WUGMzIQryVmc561C8vAoM5T8SzDDT84xCZ20RWGCDSj6CKPKkxxxMFvao2TW0UoW0AFzBXKFTozjQG0Rb4zdfLxSRcjRGAfFapxCeKYBeC5Y2dXK8iO9L8
 MQZT3RS5
 Zkc942PBX3//UPZOYvSZJUpi7D4E4CRHhqAoIGO56XHdduiqvZVYhIIvYcdLrEtfh+djgR81TRSPV2W6xVfTnM4UcAU6ENxrDkle2CAX8iUQ6N641aCXPMTU3vL7MPa05qToDe7qyJPyEoiak5OalhEiWq7beagBCseu2H7n3zSsKfycVJkKVaC82d9Vv4v6bzo3pMsrpokgWqpVsH1CTHIZlIzTJxLc+7Y6zWT203x1MOkUhoI7xkmVKaXfSR5JydvfWObWmjMnsarweDvL2zpliOXjxyAtfP6E1aKSfQJWKbxscqmk7CSEd7Hu72K9pApCFzoonnaXUq5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To make it possible to allocate large folios directly in swap cache,
> provide a new infrastructure helper to handle the swap cache status
> check, allocation, and order fallback in the swap cache layer
>
> The new helper replaces the existing swap_cache_alloc_folio. Based on
> this, all the separate swap folio allocation that is being done by anon
> / shmem before is converted to use this helper directly, unifying folio
> allocation for anon, shmem, and readahead.
>
> This slightly consolidates how allocation is synchronized, making it
> more stable and less prone to errors. The slot-count and cache-conflict
> check is now always performed with the cluster lock held before
> allocation, and repeated under the same lock right before cache
> insertion. This double check produces a stable result compared to the
> previous anon and shmem mTHP allocation implementation,  avoids the
> false-negative conflict checks that the lockless path can return =E2=80=
=94 large
> allocations no longer have to be unwound because the range turned out to
> be occupied =E2=80=94 and aborts early for already-freed slots, which hel=
ps
> ordinary swapin and especially readahead, with only a marginal increase
> in cluster-lock contention (the lock is very lightly contended and stays
> local in the first place). Hence, callers of swap_cache_alloc_folio() no
> longer need to check the swap slot count or swap cache status
> themselves.
>
> And now whoever first successfully allocates a folio in the swap cache
> will be the one who charges it and performs the swap-in. The race window
> of swapping is also reduced since the loop is much more compact.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Overall looks good. There seems to be some typo on the expression of
orders below.

> ---
>  mm/swap.h       |   3 +-
>  mm/swap_state.c | 222 +++++++++++++++++++++++++++++++++++++++++---------=
------
>  mm/zswap.c      |   2 +-
>  3 files changed, 165 insertions(+), 62 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index ad8b17a93758..6774af10a943 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -280,7 +280,8 @@ bool swap_cache_has_folio(swp_entry_t entry);
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
> -struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
> +struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp=
_mask,
> +                                    unsigned long orders, struct vm_faul=
t *vmf,
>                                      struct mempolicy *mpol, pgoff_t ilx)=
;
>  /* Below helpers require the caller to lock and pass in the swap cluster=
. */
>  void __swap_cache_add_folio(struct swap_cluster_info *ci,
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3da285a891b2..f5c77f348bbd 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -139,10 +139,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>
>  /**
>   * __swap_cache_add_check - Check if a range is suitable for adding a fo=
lio.
> - * @ci: The locked swap cluster.
> - * @ci_off: Range start offset.
> - * @nr: Number of slots to check.
> - * @shadow: Returns the shadow value if one exists in the range.
> + * @ci: The locked swap cluster
> + * @targ_entry: The target swap entry to check, will be rounded down by =
@nr
> + * @nr: Number of slots to check, must be a power of 2
> + * @shadowp: Returns the shadow value if one exists in the range.
>   *
>   * Check if all slots covered by given range have a swap count >=3D 1.
>   * Retrieves the shadow if there is one.
> @@ -150,22 +150,38 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>   * Context: Caller must lock the cluster.
>   */
>  static int __swap_cache_add_check(struct swap_cluster_info *ci,
> -                                 unsigned int ci_off, unsigned int nr,
> -                                 void **shadow)
> +                                 swp_entry_t targ_entry,
> +                                 unsigned long nr, void **shadowp)
>  {
> -       unsigned int ci_end =3D ci_off + nr;
> +       unsigned int ci_off, ci_end;
>         unsigned long old_tb;
>
> +       /*
> +        * If the target slot is not swapped out, return
> +        * -EEXIST or -ENOENT. If the batch is not suitable, could be a
> +        * race with concurrent free or cache add, return -EBUSY.
> +        */
>         if (unlikely(!ci->table))
>                 return -ENOENT;
> +       ci_off =3D swp_cluster_offset(targ_entry);
> +       old_tb =3D __swap_table_get(ci, ci_off);
> +       if (swp_tb_is_folio(old_tb))
> +               return -EEXIST;
> +       if (!__swp_tb_get_count(old_tb))
> +               return -ENOENT;
> +       if (swp_tb_is_shadow(old_tb) && shadowp)
> +               *shadowp =3D swp_tb_to_shadow(old_tb);
> +
> +       if (nr =3D=3D 1)
> +               return 0;
> +
> +       ci_off =3D round_down(ci_off, nr);
> +       ci_end =3D ci_off + nr;
>         do {
>                 old_tb =3D __swap_table_get(ci, ci_off);
> -               if (unlikely(swp_tb_is_folio(old_tb)))
> -                       return -EEXIST;
> -               if (unlikely(!__swp_tb_get_count(old_tb)))
> -                       return -ENOENT;
> -               if (swp_tb_is_shadow(old_tb))
> -                       *shadow =3D swp_tb_to_shadow(old_tb);
> +               if (unlikely(swp_tb_is_folio(old_tb) ||
> +                            !__swp_tb_get_count(old_tb)))
> +                       return -EBUSY;
>         } while (++ci_off < ci_end);
>
>         return 0;
> @@ -244,7 +260,7 @@ static int swap_cache_add_folio(struct folio *folio, =
swp_entry_t entry,
>         si =3D __swap_entry_to_info(entry);
>         ci =3D swap_cluster_lock(si, swp_offset(entry));
>         ci_off =3D swp_cluster_offset(entry);
> -       err =3D __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
> +       err =3D __swap_cache_add_check(ci, entry, nr_pages, &shadow);
>         if (err) {
>                 swap_cluster_unlock(ci);
>                 return err;
> @@ -399,6 +415,137 @@ void __swap_cache_replace_folio(struct swap_cluster=
_info *ci,
>         }
>  }
>
> +/*
> + * Try to allocate a folio of given order in the swap cache.
> + *
> + * This helper resolves the potential races of swap allocation
> + * and prepares a folio to be used for swap IO. May return following
> + * value:
> + *
> + * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
> + *                   caller should shrink the order and retry
> + * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the ca=
ller
> + *                    should abort or try to use the cached folio instea=
d
> + */
> +static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> +                                       swp_entry_t targ_entry, gfp_t gfp=
,
> +                                       unsigned int order, struct vm_fau=
lt *vmf,
> +                                       struct mempolicy *mpol, pgoff_t i=
lx)
> +{
> +       int err;
> +       swp_entry_t entry;
> +       struct folio *folio;
> +       void *shadow =3D NULL;
> +       unsigned long address, nr_pages =3D 1 << order;
> +       struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
> +
> +       entry.val =3D round_down(targ_entry.val, nr_pages);
> +
> +       /* Check if the slot and range are available, skip allocation if =
not */
> +       spin_lock(&ci->lock);
> +       err =3D __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
> +       spin_unlock(&ci->lock);
> +       if (unlikely(err))
> +               return ERR_PTR(err);
> +
> +       /*
> +        * Limit THP gfp. The limitation is a no-op for typical
> +        * GFP_HIGHUSER_MOVABLE but matters for shmem.
> +        */
> +       if (order)
> +               gfp =3D thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
> +
> +       if (mpol || !vmf) {
> +               folio =3D folio_alloc_mpol(gfp, order, mpol, ilx, numa_no=
de_id());
> +       } else {
> +               address =3D round_down(vmf->address, PAGE_SIZE << order);
> +               folio =3D vma_alloc_folio(gfp, order, vmf->vma, address);
> +       }
> +       if (unlikely(!folio))
> +               return ERR_PTR(-ENOMEM);
> +
> +       /* Double check the range is still not in conflict */
> +       spin_lock(&ci->lock);
> +       err =3D __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow)=
;
> +       if (unlikely(err)) {
> +               spin_unlock(&ci->lock);
> +               folio_put(folio);
> +               return ERR_PTR(err);
> +       }
> +
> +       __folio_set_locked(folio);
> +       __folio_set_swapbacked(folio);
> +       __swap_cache_do_add_folio(ci, folio, entry);
> +       spin_unlock(&ci->lock);
> +
> +       if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm :=
 NULL,
> +                                          gfp, entry)) {
> +               spin_lock(&ci->lock);
> +               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> +               spin_unlock(&ci->lock);
> +               folio_unlock(folio);
> +               /* nr_pages refs from swap cache, 1 from allocation */
> +               folio_put_refs(folio, nr_pages + 1);
> +               count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       /* For memsw accounting, swap is uncharged when folio is added to=
 swap cache */
> +       memcg1_swapin(entry, 1 << order);
> +       if (shadow)
> +               workingset_refault(folio, shadow);
> +
> +       node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
> +       lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
> +
> +       /* Caller will initiate read into locked new_folio */
> +       folio_add_lru(folio);
> +       return folio;
> +}
> +
> +/**
> + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap =
cache.
> + * @targ_entry: swap entry indicating the target slot
> + * @gfp: memory allocation flags
> + * @orders: allocation orders
> + * @vmf: fault information
> + * @mpol: NUMA memory allocation policy to be applied
> + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> + *
> + * Allocate a folio in the swap cache for one swap slot, typically befor=
e
> + * doing IO (e.g. swap in or zswap writeback). The swap slot indicated b=
y
> + * @targ_entry must have a non-zero swap count (swapped out).
> + *
> + * Context: Caller must protect the swap device with reference count or =
locks.
> + * Return: Returns the folio if allocation succeeded and folio is added =
to
> + * swap cache. Returns error code if allocation failed due to race.
> + */
> +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
> +                                    unsigned long orders, struct vm_faul=
t *vmf,
> +                                    struct mempolicy *mpol, pgoff_t ilx)
> +{
> +       int order, err;
> +       struct folio *ret;
> +       struct swap_cluster_info *ci;
> +
> +       /* Always allow order 0 so swap won't fail under pressure. */
> +       order =3D orders ? highest_order(orders |=3D BIT(0)) : 0;

I can't understand this line. You seem to have put an order variable
assignment in an expression which feels odd to me. I assume you mean
"orders | BIT(0)".

BTW, can you write this as:

order =3D highest_order(orders | BIT(0));

Because when orders is zero, highest_order(BIT(0)) should be 0 as well.

Chris

> +       ci =3D __swap_entry_to_cluster(targ_entry);
> +       for (;;) {
> +               ret =3D __swap_cache_alloc(ci, targ_entry, gfp, order,
> +                                        vmf, mpol, ilx);
> +               if (!IS_ERR(ret))
> +                       break;
> +               err =3D PTR_ERR(ret);
> +               if (!order || (err && err !=3D -EBUSY && err !=3D -ENOMEM=
))
> +                       break;
> +               count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
> +               order =3D next_order(&orders, order);
> +       }
> +
> +       return ret;
> +}
> +
>  /*
>   * If we are the only user, then try to free up the swap cache.
>   *
> @@ -542,51 +689,10 @@ static int __swap_cache_prepare_and_add(swp_entry_t=
 entry,
>         return ret;
>  }
>
> -/**
> - * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap =
cache.
> - * @entry: the swapped out swap entry to be binded to the folio.
> - * @gfp_mask: memory allocation flags
> - * @mpol: NUMA memory allocation policy to be applied
> - * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> - *
> - * Allocate a folio in the swap cache for one swap slot, typically befor=
e
> - * doing IO (e.g. swap in or zswap writeback). The swap slot indicated b=
y
> - * @entry must have a non-zero swap count (swapped out).
> - * Currently only supports order 0.
> - *
> - * Context: Caller must protect the swap device with reference count or =
locks.
> - * Return: Returns the folio if allocation succeeded and folio is added =
to
> - * swap cache. Returns error code if allocation failed due to race.
> - */
> -struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
> -                                    struct mempolicy *mpol, pgoff_t ilx)
> -{
> -       int ret;
> -       struct folio *folio;
> -
> -       /* Allocate a new folio to be added into the swap cache. */
> -       folio =3D folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id()=
);
> -       if (!folio)
> -               return ERR_PTR(-ENOMEM);
> -
> -       /*
> -        * Try to add the new folio to the swap cache. It returns
> -        * -EEXIST if the entry is already cached.
> -        */
> -       ret =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask, fals=
e);
> -       if (ret) {
> -               folio_put(folio);
> -               return ERR_PTR(ret);
> -       }
> -
> -       return folio;
> -}
> -
>  static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
>                                            struct mempolicy *mpol, pgoff_=
t ilx,
>                                            struct swap_iocb **plug, bool =
readahead)
>  {
> -       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct folio *folio;
>
>         /* Check the swap cache again for readahead path. */
> @@ -594,16 +700,12 @@ static struct folio *swap_cache_read_folio(swp_entr=
y_t entry, gfp_t gfp,
>         if (folio)
>                 return folio;
>
> -       /* Skip allocation for unused and bad swap slot for readahead. */
> -       if (!swap_entry_swapped(si, entry))
> -               return NULL;
> -
>         do {
>                 folio =3D swap_cache_get_folio(entry);
>                 if (folio)
>                         return folio;
>
> -               folio =3D swap_cache_alloc_folio(entry, gfp, mpol, ilx);
> +               folio =3D swap_cache_alloc_folio(entry, gfp, 0, NULL, mpo=
l, ilx);
>         } while (IS_ERR(folio) && PTR_ERR(folio) =3D=3D -EEXIST);
>
>         if (IS_ERR_OR_NULL(folio))
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e27f6e96f003..4fcd95eb24cb 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1000,7 +1000,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>                 return -EEXIST;
>
>         mpol =3D get_task_policy(current);
> -       folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
> +       folio =3D swap_cache_alloc_folio(swpentry, GFP_KERNEL, 0, NULL, m=
pol,
>                                        NO_INTERLEAVE_INDEX);
>         put_swap_device(si);
>
>
> --
> 2.53.0
>
>

