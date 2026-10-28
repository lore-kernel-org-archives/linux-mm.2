Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF75D606A335
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AhlLDiFI
Received: by kanga.kvack.org (Postfix)
	id EAB7E6B05B3; Wed, 28 Oct 2026 13:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C2C6B05B4; Wed, 28 Oct 2026 13:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B9E6B05B5; Wed, 28 Oct 2026 13:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8EDB6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:31:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37CE680197
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:31:24 +0000 (UTC)
X-FDA: 85372726488.26.547AF79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7600414000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:31:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhlLDiFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793208682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Wv1Ce+t2S47ph1w9Qr3I7nBBPQL5V5g695UfZnQjPw=;
	b=7wzvc2L1kY3rYOq9WiUAdNsx4fcrId7LrB7leS1uKjMD6pk30MTvyYkR1fLhudqqXmxAlE
	1k0klUSPbJBG/b5uhR1gjJ2NBd+8m1I4Nmpc6RnFLjZcSEDijz+1Zl+6TaaZ6I0ppaOCR/
	FXaJDJqyvZsDUGMD5mVGSTVo9u3voJo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhlLDiFI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793208682;
	b=jd4kLjYnwwOdGBZKhxwivbMWCsyZsPVHV9xAMopx507mZ1LGgS/PSZkhyQVB0zV0U5MGK7
	gMFNFq4R96goJSkTEae53o6uahDK5DF5lqLSigTVl6aBLgjgDbCsehBPU1HjipNr3OY4uT
	w+V8/IwOC13kDonHTgJYw0zRvkcVgqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E15342BA0;
	Wed, 28 Oct 2026 17:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88411F01828;
	Wed, 28 Oct 2026 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793208681;
	bh=6Wv1Ce+t2S47ph1w9Qr3I7nBBPQL5V5g695UfZnQjPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AhlLDiFIXPc8aLePFfARC+YJzMBwyUdhHfLLST+BEfCt1cS+eNSrsxALAeg+W9emf
	 UJ/ZMckx6sPGWU+4aL4M8xDdLcKpz5h+COWw3bR5a1+d6YA7BIjq62AINGsRfxvWZm
	 TIdCiEbiZ8oBKVlvhw8FroffvSiAZsRF6cF8eOuTjDjQnBuPs3bkTcJPDykdrrlqDW
	 Mpnx+FB8dElSlD1Hmv16qOG7TpXrO4ZM96RVCw62mkszp9i9KnlQgfSjHoNIIXFci5
	 E+VcGsIZ8BwU86BbA1bOTWZ6k9MSt9yiTeHAfazRTrcJ9xPwyEIGoFwTbCFhK4+Cv/
	 rfzzdVECSwOyw==
Message-ID: <sashiko-outbox-188236@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] mm: allow freezing i_pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, =?utf-8?b?TWF0?=
 =?utf-8?b?dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20261027173031.763213-3-pratyush@kernel.org>
References: <20261027173031.763213-1-pratyush@kernel.org>
 <20261027173031.763213-3-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 17:31:19 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7600414000B
X-Stat-Signature: ekd94ou744mfpgzbnf1u5eknpogsu4eq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793208682-689091
X-HE-Meta: U2FsdGVkX19ZZ7MX8AUj+bwAp7ddVhD5iZWwzDtbBVCI3CmeKwfApHRU9OL9Yk7EUt9tF/FiWZAB/vvzE9BFYz/KdAalAFH4ZJWf/JYHwQRlUvPdHoQ4RjaJrLwMpsF7cIGsTOV0PlAYvkgF7IcXaOCcsNJRfobZ/JelJgdLyXeFuhs+9aEUckQXWih8M6V8yd3+wMnzAi9gycqLP4UymY1l773idyzXUHg+/d6/eaXbtvO1xfpVMFuGiWpZd3/ubq8fSP0Os5fmqmUFjRk7cU/MIeodPEBMtdOGyViQjupMFOYKurs89FaDlWiuvbQKt5IRKgXNLvtC+M/P5mdSW7sRWbhH54U2MqqEltqQScw5XrTxmuIRPjVIJP/Dlj26mu0+9JU1m9lyroQHQWTKQsUzTIP70KujJ01/bKNpPncmA/Nj5QeFGeOfaYg7oXbUKqzT60iXXeUWsMjtiL8dzA3qtI+oKaWjnCLh4Ea0Y179OW1PwCFc/OFV6tXo6h2LJ9A9S5nIyNy1XSf2+PU97j2vc5InBzOI1ryu3OHeFiZh+bQYRbfhPRC+VuJ+tWJudF8I6Ogs1lWAgqy1oCHCJjOW/c2/KL9YjauB9QW5DFrISkfi7yVh03H5wQKYdbN6N1zE23DcfT0xWOUqiSi+oKG4iCk8V9/+V9WEytT0XC7zQ4/S/Uk81klxafjwYNJj4zBE6SNydzsO5fuxH/Ft14l6xRAIulVqHFzz2t91kbrx7rX/T3tC7eV++rkKh0XSZwVUdUF27A2/q+Rao20seCwYbFwrqLHqIiIWvY7JAbTqszRCige0jEiTkS6jCLZcxH128RIDtZrSvXRk/NqY0UsSkFXu6hkZXwtvf3F8+BhF+6pbBYg5AKHZt/k6+H9/msSDgPvsjcOpZ2eYC0MJqvuovSz+m8dboUt7KXpX8i9f3zyY8n+zn6WFyDjNP4OAVLofI2XX0A7RghWwm5F
 9kuZDv/T
 hWdz0v4MTgTPr+A6Jd9Ik2+MCDwflu9kE93h29W8Ddcx5a5+7gJoCOdmjjSuWbD7K3PryocpCBON97/gSXHcEOJvucIo7EF+csRfhlKk7DFSlKr6NFYX/X1HQvhIBEnn65fNzMNUqY6VlC2Zcv5F9V3IpGSpXX1QCfpJHFqsbADKqW8/EcE1wf4eXteME8qkbQ20YZkV4eHeNu0kTLKnKzShTR4z7DKDNmEyZT3EdckMur9dKdmlc0a+OQwVcJclpmBLwMbJCm3/Caze9e8jkWSbh58VoSlUWwhb+CVcnx+D3LDCBS22nSl1rC6tRKznd2NYeYiQb5trYkx5aeO4sWKPdSQ1z1w7Kj5cqZs5eqas0W5onF5ZwocLC60Y2FOtdNv0y8377d+PFLfQeuRvxg59WSD9vfEjyNs3IpCbF0ErM2fEIxe7x/LFFkYLmQQ0RNm2EKbkV0WHfRWWG+ht+1uQK036mB9wSSHy6ve4nPB+AnH8OAdjalQx/4+C3/gc4INjuw91Ibnwh1vw1gWpsK4eSTPy43V1oE6JCwr+zLHR8+lhXo2Ni587IAJs2b678I1w5GyxsqWye4vp/LZP35cf+Fa00C2wkY3svlF15RzmFwjRGGFlGVXbwCPLHjrpc/IbG1XGL57gSpeRGhGB9AKXgpEXhaFfq6/8yhPpdDmFE3GoNW8m9RxnElCFakQWndsC9gsAVh+tBL+U3c5zRriJ/iQ5uZ+j8Y3n2y73OqIZWd+iAuEIpzBB79g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] mm: shmem: race between shmem_writeout() and mapping_set_froze=
n()
- [High] mm: filemap_fault() returns VM_FAULT_OOM on -EBUSY from __filemap_=
get_folio()
- [High] mm: truncate: unlocked mapping_frozen() check and infinite loop on=
 -EBUSY
- [High] mm: shmem: unhandled -EBUSY in shmem_unuse_swap_entries() on froze=
n mapping
- [Medium] mm: race between mapping_set_frozen() and filemap_remove_folio()=
 rollback
--

commit 22b54347e6ef0325973e1e89c921cfa0dc0a8784
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm: allow freezing i_pages

This commit introduces the AS_FROZEN address_space flag to prevent
additions, removals, replacements, splits, and collapses in mapping->i_pages
while a file's page cache is serialized for live update. Core page cache,
truncation, reclaim, migration, shmem, and THP paths check mapping_frozen()
and reject changes with -EBUSY or warnings.

[ ... ]

> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c6..d040c69177f79 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -138,6 +138,7 @@ static void page_cache_delete(struct address_space *m=
apping,
>  	nr =3D folio_nr_pages(folio);
> =20
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> +	VM_WARN_ON_ONCE_FOLIO(mapping_frozen(mapping), folio);

[Severity: Medium]
Can an in-progress page cache insertion race with mapping_set_frozen() and
trigger this warning during error rollback?

Several paths insert a folio into mapping->i_pages under
xa_lock_irq(&mapping->i_pages), drop the lock, and then call
filemap_remove_folio() -> __filemap_remove_folio() -> page_cache_delete() if
a subsequent step fails, without holding inode_lock:

1. In mm/shmem.c, shmem_get_folio_gfp() -> shmem_alloc_and_add_folio() calls
shmem_add_to_page_cache() before shmem_inode_acct_blocks() and before the
post-insertion i_size check:

    error =3D shmem_add_to_page_cache(folio, mapping, index, NULL, gfp);
    if (error)
        goto unlock;

    error =3D shmem_inode_acct_blocks(inode, pages);
    if (error) {
        ...
        error =3D shmem_inode_acct_blocks(inode, pages);
        if (error) {
            filemap_remove_folio(folio);
            goto unlock;
        }
    }

and in shmem_get_folio_gfp():

    /* Perhaps the file has been truncated since we checked */
    if (sgp <=3D SGP_CACHE &&
        ((loff_t)index << PAGE_SHIFT) >=3D i_size_read(inode)) {
        error =3D -EINVAL;
        goto unlock;
    }
    ...
unlock:
    if (alloced)
        filemap_remove_folio(folio);

If a fault checks index < i_size before a concurrent ftruncate() shrinks the
file, and mapping_set_frozen() runs after shmem_add_to_page_cache() succeeds
(where memfd_luo_preserve_folios() only scans up to the new i_size), the
rollback calls filemap_remove_folio() on the frozen mapping.

2. In mm/userfaultfd.c, __mfill_atomic_pte() adds the folio to i_pages via
ops->filemap_add() (shmem_mfill_filemap_add()) and then calls
mfill_atomic_install_pte():

    if (ops->filemap_add) {
        ret =3D ops->filemap_add(folio, state->vma, state->dst_addr);
        if (ret)
            goto err_folio_put;
    }

    ret =3D mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
                       &folio->page, flags);
    if (ret)
        goto err_filemap_remove;

    return 0;

err_filemap_remove:
    if (ops->filemap_remove)
        ops->filemap_remove(folio, state->vma);

If mapping_set_frozen() runs before mfill_atomic_install_pte() fails (for
example with -EEXIST or via mfill_file_over_size()),
shmem_mfill_filemap_remove() calls filemap_remove_folio() on the frozen
mapping.

3. In mm/readahead.c, read_pages() inserts folios into mapping->i_pages
before calling aops->readahead(), and removes any unprocessed folios with
filemap_remove_folio().

How should these post-insertion rollback paths synchronize with
mapping_set_frozen()?

[ ... ]

> @@ -873,6 +876,10 @@ noinline int __filemap_add_folio(struct address_spac=
e *mapping,
>  		void *entry, *old =3D NULL;
> =20
>  		xas_lock_irq(&xas);
> +		if (unlikely(mapping_frozen(mapping))) {
> +			xas_set_err(&xas, -EBUSY);
> +			goto unlock;
> +		}
>  		xas_for_each_conflict(&xas, entry) {
>  			old =3D entry;
>  			if (!xa_is_value(entry)) {

[Severity: High]
How does filemap_fault() in mm/filemap.c handle -EBUSY when
__filemap_add_folio() rejects adding a folio to a frozen mapping?

When __filemap_add_folio() returns -EBUSY, it propagates through
filemap_add_folio() and __filemap_get_folio_mpol() as ERR_PTR(-EBUSY).
However, in mm/filemap.c, filemap_fault() treats any error from
__filemap_get_folio() as -ENOMEM and returns VM_FAULT_OOM:

    folio =3D __filemap_get_folio(mapping, index,
                      FGP_CREAT|FGP_FOR_MMAP,
                      vmf->gfp_mask);
    if (IS_ERR(folio)) {
        if (fpin)
            goto out_retry;
        filemap_invalidate_unlock_shared(mapping);
        return VM_FAULT_OOM;
    }

When a page fault hits an unpopulated index within i_size on a frozen
mapping using filemap_fault(), returning VM_FAULT_OOM to the architecture
page fault handler triggers pagefault_out_of_memory() and retries the fault
in an infinite loop (or triggers a memcg OOM kill) instead of returning
VM_FAULT_SIGBUS.

Should filemap_fault() convert PTR_ERR(folio) via vmf_error(PTR_ERR(folio))
here instead of unconditionally returning VM_FAULT_OOM?

[ ... ]

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 13e0786436cda..6507b4246c8af 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

[ ... ]

> @@ -1822,6 +1830,10 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct=
 folio *folio,
>  	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
>  		goto redirty;
> =20
> +	/* Swapping out would replace the folio in a frozen mapping. */
> +	if (mapping_frozen(mapping))
> +		goto redirty;
> +
>  	if (!total_swap_pages)
>  		goto redirty;

[Severity: Critical]
Is this lockless mapping_frozen(mapping) check in shmem_writeout() racy
against mapping_set_frozen()?

Page reclaim (shrink_folio_list() -> pageout() -> shmem_writeout()) runs
with only the folio lock held (for instance, on a folio allocated beyond
i_size with FALLOC_FL_KEEP_SIZE, which shmem_fallocate() marks dirty and
memfd_luo_preserve_folios() does not pin).

After shmem_writeout() checks mapping_frozen(mapping) without holding
xa_lock_irq(&mapping->i_pages), it zeroes any !uptodate folio, allocates sw=
ap
via folio_alloc_swap(), and updates accounting in shmem_recalc_inode() befo=
re
calling shmem_delete_from_page_cache():

    xa_lock_irq(&mapping->i_pages);
    error =3D shmem_replace_entry(mapping, folio->index, folio, radswap);
    folio->mapping =3D NULL;
    mapping->nrpages -=3D nr;
    shmem_update_stats(folio, -nr);
    xa_unlock_irq(&mapping->i_pages);

If mapping_set_frozen(mapping) runs on another CPU between the unlocked che=
ck
in shmem_writeout() and shmem_delete_from_page_cache(),
shmem_delete_from_page_cache() replaces the folio in mapping->i_pages with a
swap entry after the mapping was frozen.

Even worse, if swap_writeout() then returns AOP_WRITEPAGE_ACTIVATE without
writing the folio (for example, when zswap_store() fails and
!mem_cgroup_zswap_writeback_enabled()), shmem_writeout() attempts to put the
folio back into the page cache:

    error =3D shmem_add_to_page_cache(folio, mapping, index,
            swp_to_radix_entry(folio->swap),
            __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
    /* Swap entry might be erased by racing shmem_free_swap() */
    if (!error) {
        shmem_recalc_inode(inode, 0, -nr_pages);
        folio_put_swap(folio, NULL);
    }
    ...
    swap_cache_del_folio(folio);
    goto redirty;

Because AS_FROZEN is now set, shmem_add_to_page_cache() fails with -EBUSY,
so shmem_writeout() skips folio_put_swap() and calls
swap_cache_del_folio(folio), discarding the dirty unwritten folio from the
swap cache while leaving the unwritten swap entry in mapping->i_pages.

Should shmem_delete_from_page_cache() check mapping_frozen(mapping) under
xa_lock_irq(&mapping->i_pages) and abort the swap-out if the mapping has
been frozen?

> @@ -2483,6 +2495,13 @@ static int shmem_swapin_folio(struct inode *inode,=
 pgoff_t index,
>  	if (softleaf_is_poison_marker(index_entry))
>  		return -EIO;
> =20
> +	/*
> +	 * Swapping in would change the i_pages of a frozen mapping. A frozen
> +	 * mapping should not have swap entries in the first place.
> +	 */
> +	if (unlikely(mapping_frozen(mapping)))
> +		return -EBUSY;
> +
>  	si =3D get_swap_device(index_entry);
>  	order =3D shmem_confirm_swap(mapping, index, index_entry);
>  	if (IS_ERR_OR_NULL(si)) {

[Severity: High]
What happens during swapoff in shmem_unuse_inode() if a frozen shmem mapping
still contains swap entries (for example, from pages fallocated with
FALLOC_FL_KEEP_SIZE beyond i_size that were swapped out before the mapping
was frozen, or via the shmem_writeout() race above)?

In mm/shmem.c, shmem_unuse_inode() loops over swap entries calling
shmem_unuse_swap_entries():

    do {
        folio_batch_init(&fbatch);
        if (!shmem_find_swap_entries(mapping, start, &fbatch,
                         indices, type)) {
            ret =3D 0;
            break;
        }

        ret =3D shmem_unuse_swap_entries(inode, &fbatch, indices);
        if (ret < 0)
            break;

        if (signal_pending(current)) {
            ret =3D -ERESTARTSYS;
            break;
        }
        start =3D indices[folio_batch_count(&fbatch) - 1];
    } while (true);

And shmem_unuse_swap_entries() ignores all errors from shmem_swapin_folio()
other than -ENOMEM:

    error =3D shmem_swapin_folio(inode, indices[i], &folio, SGP_CACHE,
                    mapping_gfp_mask(mapping), NULL, NULL);
    if (error =3D=3D 0) {
        folio_unlock(folio);
        folio_put(folio);
        ret++;
    }
    if (error =3D=3D -ENOMEM)
        break;
    error =3D 0;

When shmem_swapin_folio() returns -EBUSY on a frozen mapping without
removing the swap entry, shmem_unuse_swap_entries() resets error =3D 0 and
returns a non-negative value. shmem_unuse_inode() then sets
start =3D indices[folio_batch_count(&fbatch) - 1], and the next
shmem_find_swap_entries() call (which scans inclusively from start) finds t=
he
same swap entry again, spinning forever in the kernel.

Should shmem_unuse_swap_entries() also propagate -EBUSY (or should
shmem_unuse_inode() bail out when mapping_frozen(mapping) is set)?

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 733d2713a875a..6512f460a28e9 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -171,6 +171,8 @@ int truncate_inode_folio(struct address_space *mappin=
g, struct folio *folio)
>  {
>  	if (folio->mapping !=3D mapping)
>  		return -EIO;
> +	if (mapping_frozen(mapping))
> +		return -EBUSY;
> =20
>  	truncate_cleanup_folio(folio);
>  	filemap_remove_folio(folio);

[Severity: High]
Could this unlocked mapping_frozen(mapping) check in truncate_inode_folio()
both race with mapping_set_frozen() and cause an infinite loop in truncation
callers?

First, callers like memory_failure() -> truncate_error_folio() ->
generic_error_remove_folio() -> truncate_inode_folio() only hold the folio
lock, not filesystem locks. Because mapping_frozen(mapping) is checked
before acquiring xa_lock_irq(&mapping->i_pages) in filemap_remove_folio(),
mapping_set_frozen() can run while truncate_cleanup_folio() is executing,
causing filemap_remove_folio() -> __filemap_remove_folio() ->
page_cache_delete() to hit VM_WARN_ON_ONCE_FOLIO(mapping_frozen(mapping),
folio) and delete the folio from the frozen mapping.

Second, the commit message notes that racing mapping_set_frozen() with
truncation causes truncation to fail mid-way, but in mm/truncate.c, the
second loop of truncate_inode_pages_range() ignores the return value of
truncate_inode_folio():

    while (index < end) {
        cond_resched();
        if (!find_get_entries(mapping, &index, end - 1, &fbatch,
                indices)) {
            /* If all gone from start onwards, we're done */
            if (index =3D=3D start)
                break;
            /* Otherwise restart to make sure all gone */
            index =3D start;
            continue;
        }
        ...
            truncate_inode_folio(mapping, folio);
            folio_unlock(folio);
        }
        truncate_folio_batch_exceptionals(mapping, &fbatch, indices);
        folio_batch_release(&fbatch);
    }

And in mm/shmem.c, shmem_undo_range() has the same restart loop when
truncating (end =3D=3D -1):

        if (!find_get_entries(mapping, &index, end - 1, &fbatch,
                indices)) {
            /* If all gone or hole-punch or unfalloc, we're done */
            if (index =3D=3D start || end !=3D -1)
                break;
            /* But if truncating, restart to make sure all gone */
            index =3D start;
            continue;
        }
        ...
                if (!folio_test_large(folio)) {
                    truncate_inode_folio(mapping, folio);

If AS_FROZEN is set after truncate_inode_pages_range() or shmem_undo_range()
passes its initial entry check, truncate_inode_folio() returns -EBUSY (and
truncate_inode_partial_folio() fails to split large folios with -EBUSY)
without removing the folios, while find_get_entries() advances index past
start. When find_get_entries() reaches the end of the range and returns 0
with index !=3D start, both loops reset index =3D start and retry forever.

Should truncate_inode_folio() verify mapping_frozen(mapping) under
xa_lock_irq(&mapping->i_pages), and should the retry loops in
truncate_inode_pages_range() and shmem_undo_range() abort if the mapping
becomes frozen?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027173031.7632=
13-1-pratyush@kernel.org?part=3D2

