Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DFE606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lnNc1hEk
Received: by kanga.kvack.org (Postfix)
	id 473496B0898; Thu, 22 Oct 2026 02:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449756B089A; Thu, 22 Oct 2026 02:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F516B089B; Thu, 22 Oct 2026 02:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 118F26B0898
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:19:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ADDE1A012C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:19 +0000 (UTC)
X-FDA: 85349260038.10.290C766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E09DB40007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:19:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnNc1hEk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649958;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSl5bvmXnVP4rj5OYCLaYZTBJ+b3k10OZ74YBKpXHbk=;
	b=1cM9+zOid+/4f3zKLofLNxKauMXG6XKJkHi6NohIx+7C7SIfd78koVM0rkLleH6keW63tk
	oI4jhdTaKOvYas/gLjMci/lIGk2Mqtx7QRdweopnyeJOXvCe1uBIG8opz681ANOrbLQL8s
	43JiepvaDb06da1KZoKehiHQokwOmec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnNc1hEk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649958;
	b=oewUbiym0QagGl9/kmHsxTWtmz5Cs+yRazCE2GGsJn8lKpqJM0TGlZG8hinUhXulWAiVrK
	gRrYyL1sRENUeHOFRLAepQ8Szeen6unJ8thgZNt4kpmnbNHdXrNDUo0L3iUVhhJ5mr/+EO
	fYHYJjcFOQzt3MtYpB/QdbdRtn/fhQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33E49439C8;
	Thu, 22 Oct 2026 06:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65331F000C1;
	Thu, 22 Oct 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649957;
	bh=lSl5bvmXnVP4rj5OYCLaYZTBJ+b3k10OZ74YBKpXHbk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lnNc1hEk7CCYSDE8W/lWoGqtf0NQLMNaLXi2iYaoR7kHFaoHGIqJDIpRE/phWgQgE
	 d+hSXTEVj0tcEYXwiTKr/hIJaws51u34HMXqPCw69JMT/bA+y8mjilQgaRrMFSgPlc
	 1TQZnUFbHSMK5uwNzwEH89WiZzLuOXfzYj8AYgraAfuaHhPVP3ECwrkjgUjRotOVFW
	 GYFU7IZczoGhg0yI8pmef9JOa6Gg8MTctw6+HO/vmH9M6BGhb2Pr8D3IANRHk3RXAO
	 2gl+7f/+YMn35uoD55aTMIZoPnlGwdY1upZQ9cEB8C0Nst/v8vMD2XeXhz9wLx5vBN
	 lxFjm+pLpzffw==
Message-ID: <sashiko-outbox-181079@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/12] mm, swap: enable THP swapin for vswap entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nhat Pham" <nphamcs@gmail.com>, akpm@linux-foundation.org
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, kernel-team@meta.com, linux-mm@kvack.org
In-Reply-To: <20261021060323.553433-6-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
 <20261021060323.553433-6-nphamcs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:19:14 +0000
X-Rspamd-Queue-Id: E09DB40007
X-Stat-Signature: jdusyrmysty676ce61fr9xwq7fmonb8z
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649957-317960
X-HE-Meta: U2FsdGVkX1+nLSA0yftFXJ4UaTm41jocSO/w4ltlMBwcAmR5yDOqOwAnKU3EGVV5rDd2IN3KsNPPwD2hf0vkbjGbqDD6qSAQ6vLQFp30rh8z5A/bc36sMaBpioFjUNaAjHvq6tOmeUHzn/AeH7zy5XmPUIb41NOFDSVJX2GSoYvet2vRstPrK+t5iKVN1HYap8yjCFc/CHf7FacO4xwKHYfn5EiDzwetwl4ITvA+mp474fjc2X9mNlz7l7gpeyYhKwc2eXvkRKlVbHn+8rJj4dMVytyJVGTNKY0g7ZGdJ7ZlgR4OAqlMuyJPxfKOdvqoCWoVZwvk7hOEXMmrkpxFswvTUCiOuSwAWZgq/w7b70IAIel8yG9ji96BHCInfooT40odeLmKPXpeKMwtr43X2YP95gR6/kZS6qnmv9b9CaFsrPEWsSpydnsZDw63xp8pOUNtxvtfMQyS4RoV6PXkjp0Biff4dnZfNLQSxa0avXseri1k/0f1qbMqMX1hoNXuNMwLJvJEGYKWRDXGwg7ATbMO/TsAfy7SvcMF9Gq95KQRyIgiiGcZ/M+efAEKAYn1bN3PoKSNUKqUis+1vKnJ/qrmIfgpLbqeTle91ms85wj4W/hsyi9f9ViTxXMzMcBNKOqN2kTw7blzqxfcaqkco1dH6CvNlOHP8QUcKMWkOxyQxZi0urtduEnr8kplFI1tMBqfiDJCHl2BMU/S0eXV/S16QKOCYdJRAkTryba/l7o9ZqekmBD76cfjg2TslFcJYWJieNnL4VeODJbI+RWk7jXUDO+PY7UJAtrH5gImpPpkiz0wQzfx/Y53t1i3igch5hOOT79TdYJQAXt1JhHV0udgaYZLt354swspko+8kbowgsw0V0q3LbQ+cRVzSVNbVKL0klPKvpkkuSX16btVn+fiGGzmfkYHu1ONsXZivcVbMaLthOManWH5036sPj7MM0JKEQOdDM9S0ZXWdyG
 gT64XJqH
 VtP3HBXw8EbSp6votvRtkfJ+CnEzZdX6cW2DyWhO0dKZ9vWkyiLs3rvHsCs90OB6Pi7dWKJYKy8pbMysL1gHotSIeoqat8JxTJ4O0VRNTFGAvb0RX+sJZnHH0xi7Climg30jfOf3WD+UxEbFgkx3Zs+m2bF0ZGRJ0/6QHn2TwknEY0HTe5MyEFjrDPRMvYSclnh9hQ+/uHhAHeda9i6t7ShSXbozJHAE54IszTM8N/Kmlp/lP8NxPTRpniudDIsotaRNzAvr1dKyFfoM7sWhJ0JoYwnXdLAGTSpEqNanImzlxoqS59jHdCKjTX7hffjlh9wZxZisTr9TD+rtNHlevCnD6idbljjFpYtzOlzdywAi9FlpkoqCLuiM1OkHROGh6QH9SyY8Grm7UvjWWTRJYltmeXoKBewO1a2z7pS/JpaL33OX/qfJ6dLsExgFxFBXnXmU/v67aGRi45XX0EuihVDPmuMwEtccHK1CMg+eOzpY5DpVYx4JuZ7Zy/cs0ZX1Md0okxSmAZzLRtAxTxUsJ+CTDlHlQAZXe2QCydWfUn+uuAfbBY63pnzOSVPxR+24gLk5OsYC7u/mIsVHkhqPEFUBEkw==
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
- [Critical] mm, swap: out-of-bounds BIO in __swap_cache_add_check() on swa=
pfile THP
- [High] mm, swap: infinite fault loop in do_swap_page() after vswap THP sw=
apoff
--

commit d794204e63aa444a2dbaf281107104431d6e0cb6
Author: Nhat Pham <nphamcs@gmail.com>

mm, swap: enable THP swapin for vswap entries

This commit enables swapping in large anonymous folios as a unit for vswap
entries when the batch is backed by a contiguous run of physical swap slots=
 on
a synchronous device. Batches backed by zswap or mixed backing continue to =
be
rejected so the fault path falls back to smaller orders.

> diff --git a/mm/memory.c b/mm/memory.c
> index 9f651d247eef1..430b83900ba87 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4885,9 +4885,10 @@ static unsigned long thp_swapin_suitable_orders(st=
ruct vm_fault *vmf)
>  	 * lack handling for such cases, so fallback to swapping in order-0
>  	 * folio.
>  	 *
> -	 * THP swapin for vswap is not supported yet either.
> +	 * Vswap entries are checked later, under the cluster lock in
> +	 * __swap_cache_add_check().
>  	 */
> -	if (is_vswap_entry(entry) || !zswap_never_enabled())
> +	if (!is_vswap_entry(entry) && !zswap_never_enabled())
>  		return 0;
> =20
>  	/*

[Severity: High]
Could enabling large folio swapin for vswap entries here lead to a warning =
and
an infinite page fault retry loop in do_swap_page() if swapoff (or physical
slot reclaim in a later patch in this series) runs before the folio is mapp=
ed?

When do_swap_page() -> swapin_sync() -> __swap_cache_alloc_folio() allocate=
s a
large folio in the swap cache for a vswap batch, folio->mapping is NULL, so
!folio_test_anon(folio) remains true until do_swap_page() acquires the pte
lock, validates the pte batch, and calls folio_add_new_anon_rmap().

Inside swapin_sync(), once the synchronous read from the physical swap devi=
ce
completes, swap_read_end() marks the folio uptodate and calls
folio_unlock(folio) before returning to do_swap_page(), which then re-acqui=
res
the folio lock via folio_lock_or_retry(folio, vmf).

While that large !folio_test_anon(folio) folio is unlocked in the swap cache
(or if do_swap_page() backs out on VM_FAULT_RETRY or !pte_same()), a
concurrent swapoff() on the physical swap device can run the vswap loop in
try_to_unuse() (or vswap_reclaim_phys_slot() in patch 07/12):

mm/swapfile.c:try_to_unuse()
    folio_wait_writeback(folio);
    folio_release_vswap_backing(folio);
    if (unlikely(!folio_test_uptodate(folio)))
        swap_cache_del_folio(folio);
    else
        folio_mark_dirty(folio);

Unlike non-vswap unuse_pte(), which maps the folio into page tables and sets
folio_test_anon(folio), this releases all physical swap slots for the vswap
batch and marks the large folio dirty in the swap cache while
!folio_test_anon(folio) is still true.

Because thp_swapin_suitable_orders() drops the pte lock before swapin_sync(=
),
any change to a sibling pte in the range before do_swap_page() re-acquires =
the
pte lock (such as a concurrent madvise, munmap, mprotect, or a forked child
process faulting with only part of the range mapped) causes the full-batch
check in do_swap_page() to fail, leaving nr_pages =3D 1 !=3D folio_nr_pages=
(folio):

mm/memory.c:do_swap_page()
    if (!folio_test_anon(folio) && folio_test_large(folio) &&
        nr_pages !=3D folio_nr_pages(folio)) {
        if (!WARN_ON_ONCE(folio_test_dirty(folio)))
            swap_cache_del_folio(folio);
        goto out_nomap;
    }

Because the folio was marked dirty and its physical backing was released,
WARN_ON_ONCE(folio_test_dirty(folio)) fires, swap_cache_del_folio(folio) is
skipped, and do_swap_page() jumps to out_nomap without mapping the pte.

At out_page, folio_free_swap(folio) returns false because the vswap entries
are still referenced by ptes. Neither reclaim (pageout() in mm/vmscan.c
returns PAGE_ACTIVATE when !shmem_mapping(mapping) && !folio_test_anon(foli=
o))
nor folio splitting (folio_check_splittable() in mm/huge_memory.c returns
-EBUSY when !folio->mapping && !is_anon) can evict or split this dirty
!folio_test_anon(folio) large folio, so every subsequent fault retry finds =
the
same folio via swap_cache_get_folio() and repeats goto out_nomap indefinite=
ly.

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3900975c675f7..6c8e8f49e349d 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -174,6 +174,9 @@ static int __swap_cache_add_check(struct swap_cluster=
_info *ci,
>  	unsigned int ci_off, ci_end;
>  	unsigned long old_tb;
>  	bool is_zero;
> +	struct swap_cluster_info_dynamic *ci_dyn;
> +	enum vswap_backing_type type;
> +	int ret;
> =20
>  	lockdep_assert_held(&ci->lock);
> =20
> @@ -202,11 +205,17 @@ static int __swap_cache_add_check(struct swap_clust=
er_info *ci,
>  		return 0;
> =20
>  	/*
> -	 * Reject a vswap batch so __swap_cache_alloc_folio falls back to
> -	 * order 0.
> +	 * For a vswap entry batch, reject if the backing is not THP-amenable
> +	 * (e.g. uniformly ZSWAP, or mixed). The order-fallback loop in
> +	 * __swap_cache_alloc_folio will retry with a smaller order on -EBUSY.
>  	 */
> -	if (is_vswap_entry(targ_entry))
> -		return -EBUSY;
> +	if (is_vswap_entry(targ_entry)) {
> +		ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, ci);
> +		ret =3D __vswap_check_backing(ci_dyn, round_down(ci_off, nr),
> +					    nr, &type);
> +		if (ret !=3D nr || type =3D=3D VSWAP_ZSWAP)
> +			return -EBUSY;
> +	}

[Severity: Critical]
Does __swap_cache_add_check() or __vswap_check_backing() also need to verify
that the physical backing swap device has SWP_BLKDEV set (or that the physi=
cal
slots lie within a single contiguous swap_extent) before allowing a large
folio swapin?

On swapout, cluster_alloc_swap_entry() in mm/swapfile.c rejects high-order
allocations on regular-file swapfiles where SWP_BLKDEV is not set, while
exempting vswap:

mm/swapfile.c:cluster_alloc_swap_entry()
    if (order && !(si->flags & SWP_BLKDEV) && !swap_is_vswap(si))
        return 0;

Regular-file swapfiles map swap page offsets to disk sectors through
si->swap_extent_root, which can be discontiguous at PAGE_SIZE granularity,
whereas swap_bdev_submit_read() and swap_bdev_submit_write() in mm/page_io.c
submit a single bio of size sio->len (>=3D folio_size(folio)) starting at
swap_entry_sector(sio->entry) without splitting a large folio across
swap_extent boundaries.

When vswap is backed by a fragmented regular-file swapfile on a synchronous
block device (where claim_swapfile(), setup_swap_extents(), and swapon() set
phys_si->bdev, phys_si->ops =3D &swap_bdev_ops, and SWP_SYNCHRONOUS_IO with=
out
setting SWP_BLKDEV), cluster_alloc_swap_entry() allocates contiguous high-o=
rder
virtual swap entries. When those pages are written out to phys_si at order 0
(for example, after splitting when high-order folio_alloc_phys_swap() fails=
 on
!SWP_BLKDEV, during sequential order-0 swapout, or via sequential zswap
writeback in patch 06/12), folio_alloc_phys_swap() can allocate contiguous
physical swap offsets from percpu_swap_cluster.offset[0] while
swap_bdev_can_merge() splits the order-0 write bios at swap_extent boundari=
es.

On swapin, __vswap_check_backing() in mm/vswap.h only checks that the physi=
cal
swap entry values are contiguous:

mm/vswap.h:__vswap_check_backing()
    } else if (first_type =3D=3D VSWAP_SWAPFILE &&
               vtable_to_phys(vt).val !=3D first_phys.val + i) {
        break;
    }

If [first_phys, first_phys + nr) crosses a swap_extent boundary on a
!SWP_BLKDEV swapfile, swap_bdev_submit_read() submits a single
folio_size(folio) read bio starting at swap_entry_sector(first_phys), readi=
ng
past the end of the swap_extent into adjacent filesystem blocks. In additio=
n,
if that large folio stays in the swap cache and is later written out again,
folio_realloc_swap() in mm/swapfile.c returns the existing
vswap_to_phys(vswap_entry) directly without calling folio_alloc_phys_swap(),
causing swap_bdev_submit_write() to issue a single folio_size(folio) write =
bio
across the swap_extent boundary.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060323.5534=
33-1-nphamcs@gmail.com?part=3D5

