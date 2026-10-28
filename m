Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2687606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IErl69yg
Received: by kanga.kvack.org (Postfix)
	id 217176B05B1; Wed, 28 Oct 2026 10:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C77A6B05B2; Wed, 28 Oct 2026 10:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDD16B05B3; Wed, 28 Oct 2026 10:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E22BF6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:33:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17B7E120D18
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:33:54 +0000 (UTC)
X-FDA: 85372279188.18.3F0B3B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 643171C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:33:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IErl69yg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793198032;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Eq7UPuHyN7IMflaspRCorT0sF1drqz3DPeeIrwG1bc=;
	b=rd/KVLlpvYc28D9/N3SWnT3h/e2mtV33XUVondC/xDyH/8XQsRn/6epzpHr6YYgGLy+IpL
	RAr0QKoxyUBKPKCzg8QZ92ZqSnU3p5SfV2GulWFQ380VvNZ7UM0DqZJbkk1CPP1voGa0y7
	Y5+RZeNSY1c4Aq38UuEPXqgTC0LAF18=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IErl69yg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793198032;
	b=SmIGAcMUAeZgjN2DSJ8Fn2Y4KbGSLdAnHfvvqVBUzK2XAnE2XUsFq4+G3quFFDXN+4X2N4
	ppHpGdEop1PsFGSyqRokT+9yOWNQEcYOFlGSsybOsUU5yXLwGFt9I/wHndmKF+E4/X8mFM
	anI2U80hpetlIs21U3RjhwC3+ujxPq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 693DD40BAB;
	Wed, 28 Oct 2026 14:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314601F01825;
	Wed, 28 Oct 2026 14:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793198031;
	bh=0Eq7UPuHyN7IMflaspRCorT0sF1drqz3DPeeIrwG1bc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=IErl69ygQuqYilIxzSAxFdiMfrX/NPnMSirqguYoiNvVT5Tok4E8mQdNNPc6qv3QM
	 uspJkcW+u6oXwO6f+hkAy+mSKK5cnoyL87m7VXkoIB8ucTSKybwMvlAJz4gPjHApmY
	 qQ/YwAq/T79CrxX+ziXy1EvmKVLab5MAqZd+dtQ8/s9gKp0eLXf2/Qv/72c4N+P10l
	 hzv0/fcIS5Mv2LmVgN+7Zkzo7Mx13PO4uwdlMAfdSFUXOcGiL/I9yLLD6FFyP4IijI
	 1EfDSQLcpavuvHAk96/ZgiPLeyTS54jKan/2ppvg/ACRrKH0MEMLaPgVua0m0+gkhk
	 h1FRkGmULQ++g==
Message-ID: <sashiko-outbox-187992@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for Sashiko] hugetlb: supports unmapping private
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Adam Davis" <eadavis@sina.com>, linux-mm@kvack.org
In-Reply-To: <20261028054620.275525-1-eadavis@sina.com>
References: <20261028054620.275525-1-eadavis@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 14:33:50 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 643171C0004
X-Stat-Signature: qrwf17wba38iyhqa6h1pe7q7mdhdy15h
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793198032-569576
X-HE-Meta: U2FsdGVkX1/16plGGE8hckxZ56fiZuQ2rZYA3Lj/+eQEk1fc5VDagnDcZbY4nXEh4nkwUBRW+TIg8n7iie/GAoShZZkTWVGWX5vEQjBwd/B1xi8F4dxJl44h/19wqmjzpEhOl/yITtlF+M4zGjYfRLIOnowjWLz+b2iFKOcrCbDtWM2x3Lkkeal89PTV9rjnJ9KAXvCfatrphRGIwXVKbGjSWD+tmRmvsHMH+bHBCZpIeNEq769H6C0C5IHmLgWZq0xhdSUxLKaGDHo4HUhvBQ4ig/ghX9WKTTwDBaG3JrRqNaBiC3t0a2AXBh9Q6be1Mj/GCNVOObxdWIdtvQgJMOLYE0b9ABmR2uaXvFi3qhjlxK9kMda4jg0qz3jGc6amF6/nF7F4WVsqrlDlpe3Z/sITlEUtJ6B0MK/Jr6SmVCnhjQtYLUvRfpZdgc/HIW1J3ocAiPHLcsFJGagM5a5rVU1EZgteSeBg1NoLEAGNQVvzZscaJy4rcK8ynLXmJbJUWSwjQiCAj16HT/DTppoFW7zl8YEF1nK8BHOYBL6ZgjxDkYwD2dslHelRz1sKVUJ06rLAfSbjkWj9p33hcMCbUUZpD27gUFm5pyLMoxgRjIsCzyD0FxaML2BZKfy42cR5nGSDqDVF6nFICmFpKreMj2Rx0ei+/ZlsfPaavhn3HQWpRu6O7JrdRE95b9bst7HxRpHjo96jJ2GVPtXrqFQuoF8OxJlLbH/uVL5wOAtr5nXc5MALpqXsoV68dMNnQv0c1+SHu+UUwynBkhUe1zP7Ta+559qU0WSE0tAPKMJ6fdbZkFM2I+17GE62WFUkaabbmKgTIm7QEF7BbFbDNqukFlSqQ7lOvqFd+G6OCfYIINFo0MjF8kAzuyEaU6JORNZGSIQZwdE8KsWj7eS+y8Tve3ngfu1E12SeJofrlZMl9pMvtEN7RH7PXLzDmRc3Z4UwbPSxsoCBdJF+LH7Zj8m
 4otJr8hT
 FoqMZ1RxfK+01j1GPe28HgDH3lqan8DL+MVX7ETMOTe1Gn8FfiYQfofC1H9rVPxn8xaKx9RsekOZW/vI8vJ3sYl1W4IuGwF6Rg0XYdsoC9S5/RsNnhFXAStbrmfC2KwrwO7n8aHLk44Azuogu4eMBQfMemmxLV1j53bNL4eOIYf2aXWAaJQZcM/IpqaP5o8PYITDVjEEm23tQo+IHlghH341ExQn2/7WSNBp0O2J+NUGzLIe1oAffI7LcMc4XPPGZ/qxw9OwNRsITs6JMdJ1eJDUevuJCu30Jr1bq1NDsVJDHGAe/GlBCsaH2VWHaeSWUWF8wphu7OFsQ+N85udqXK4sOeAI6yMzRjrPO9dBObi/y+5YYBOZCNzLo4gSgIBbYlLEs29zb0Or0COUfAA20FAv7jm0iIA6bPooTtlj3tjv8D7Cht1BFpNrlEKbMGQxnStyRX6IHDxbBSNjHfknL/HVCzvPSvLA+jW4mxQO8yuTF2xuO2AShLFwcn5Fl2NahbfIVga+yDKMCdeF+ezJKzVwV+U9+Qjn3jxI7k31AogemolWVbYdHPKr66D0TM4e2we0obquEGA/B5o8Gf52/qxcIFw==
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
- [Critical] hugetlbfs: use-after-free and unbalanced unlock in hugetlb_unm=
ap_file_folio()
- [Critical] hugetlbfs: unvalidated private vma use-after-free in hugetlb_u=
nmap_file_folio()
- [Critical] hugetlbfs: resv_map use-after-free on unlock in hugetlb_unmap_=
file_folio()
--

commit cc572a12212d775135723329431694314f130c15
Author: Edward Adam Davis <eadavis@sina.com>

hugetlb: supports unmapping private mappings

This commit updates hugetlb_unmap_file_folio() to take a reference on a
private mapping's resv_map instead of assuming vma->vm_private_data points
to a struct hugetlb_vma_lock when hugetlb_vma_trylock_write() fails.

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe0..37be669653835 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -381,6 +381,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
>  					struct folio *folio, pgoff_t index)
>  {
>  	struct hugetlb_vma_lock *vma_lock;
> +	struct resv_map *resv_map;
>  	unsigned long pfn =3D folio_pfn(folio);
>  	struct vm_area_struct *vma;
>  	unsigned long v_start;
> @@ -393,6 +394,7 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
>  	i_mmap_lock_write(mapping);
>  retry:
>  	vma_lock =3D NULL;
> +	resv_map =3D NULL;
>  	mapping_rmap_tree_foreach(vma, mapping, start, end - 1) {
>  		v_start =3D vma_offset_start(vma, start);
>  		v_end =3D vma_offset_end(vma, end);
> @@ -401,15 +403,21 @@ static void hugetlb_unmap_file_folio(struct hstate =
*h,
>  			continue;
> =20
>  		if (!hugetlb_vma_trylock_write(vma)) {
> -			vma_lock =3D vma->vm_private_data;
> -			/*
> -			 * If we can not get vma lock, we need to drop
> -			 * immap_sema and take locks in order.  First,
> -			 * take a ref on the vma_lock structure so that
> -			 * we can be guaranteed it will not go away when
> -			 * dropping immap_sema.
> -			 */
> -			kref_get(&vma_lock->refs);
> +			if (vma->vm_flags & VM_MAYSHARE) {
> +				vma_lock =3D vma->vm_private_data;
> +				/*
> +				 * If we can not get vma lock, we need to drop
> +				 * immap_sema and take locks in order.  First,
> +				 * take a ref on the vma_lock structure so that
> +				 * we can be guaranteed it will not go away when
> +				 * dropping immap_sema.
> +				 */
> +				kref_get(&vma_lock->refs);
> +			} else {
> +				resv_map =3D vma_resv_map(vma);
> +				kref_get(&resv_map->refs);
> +			}
> +
>  			break;
>  		}
> =20
> @@ -420,25 +428,28 @@ static void hugetlb_unmap_file_folio(struct hstate =
*h,
> =20
>  	i_mmap_unlock_write(mapping);
> =20
> -	if (vma_lock) {
> +	if (vma_lock || resv_map) {
>  		/*
>  		 * Wait on vma_lock.  We know it is still valid as we have
>  		 * a reference.  We must 'open code' vma locking as we do
>  		 * not know if vma_lock is still attached to vma.
>  		 */
> -		down_write(&vma_lock->rw_sema);
> +		hugetlb_vma_lock_write(vma);

[Severity: Critical]
Does calling hugetlb_vma_lock_write(vma) after i_mmap_unlock_write(mapping)
cause a use-after-free on vma and an unbalanced up_write(&vma_lock->rw_sema=
)?

In hugetlb_unmap_file_folio(), the caller does not hold vma->vm_mm->mmap_lo=
ck,
so vma is only stabilized while i_mmap_lock_write(mapping) is held. Taking a
reference on vma_lock->refs or resv_map->refs does not pin struct
vm_area_struct. Once i_mmap_unlock_write(mapping) drops i_mmap_rwsem, a
concurrent munmap(), exit_mmap(), or mremap() can unlink vma from
mapping->i_mmap and free it via vm_area_free(vma) before
hugetlb_vma_lock_write(vma) reads vma->vm_flags and vma->vm_private_data:

mm/hugetlb.c:hugetlb_vma_lock_write() {
	if (__vma_shareable_lock(vma)) {
		struct hugetlb_vma_lock *vma_lock =3D vma->vm_private_data;

		down_write(&vma_lock->rw_sema);
	} else if (__vma_private_lock(vma)) {
		struct resv_map *resv_map =3D vma_resv_map(vma);

		down_write(&resv_map->rw_sema);
	}
}

Furthermore, for a shared VMA (vma_lock !=3D NULL), a concurrent final unma=
p in
__hugetlb_zap_end() -> __hugetlb_vma_unlock_write_free() ->
__hugetlb_vma_unlock_write_put() clears both vma_lock->vma and
vma->vm_private_data before releasing vma_lock->rw_sema:

mm/hugetlb.c:__hugetlb_vma_unlock_write_put() {
	struct vm_area_struct *vma =3D vma_lock->vma;

	vma_lock->vma =3D NULL;
	vma->vm_private_data =3D NULL;
	up_write(&vma_lock->rw_sema);
	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
}

If vma->vm_private_data is cleared before hugetlb_vma_lock_write(vma) runs,
__vma_shareable_lock(vma) sees vma->vm_private_data =3D=3D NULL and returns=
 false
without calling down_write(&vma_lock->rw_sema) (or dereferences NULL if
vma->vm_private_data is cleared right after __vma_shareable_lock(vma) checks
it). Then hugetlb_unmap_file_folio() sees vma_lock->vma =3D=3D NULL and cal=
ls
up_write(&vma_lock->rw_sema) on a semaphore it never locked.

>  		i_mmap_lock_write(mapping);
> =20
> -		vma =3D vma_lock->vma;
> -		if (!vma) {
> -			/*
> -			 * If lock is no longer attached to vma, then just
> -			 * unlock, drop our reference and retry looking for
> -			 * other vmas.
> -			 */
> -			up_write(&vma_lock->rw_sema);
> -			kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
> -			goto retry;
> +		if (vma_lock) {
> +			vma =3D vma_lock->vma;
> +			if (!vma) {
> +				/*
> +				 * If lock is no longer attached to vma, then
> +				 * just unlock, drop our reference and retry
> +				 * looking for other vmas.
> +				 */
> +				up_write(&vma_lock->rw_sema);
> +				kref_put(&vma_lock->refs,
> +					 hugetlb_vma_lock_release);
> +				goto retry;
> +			}
>  		}
> =20
>  		/*
> @@ -451,7 +462,10 @@ static void hugetlb_unmap_file_folio(struct hstate *=
h,
>  			unmap_hugepage_range(vma, v_start, v_end, NULL,
>  					     ZAP_FLAG_DROP_MARKER);

[Severity: Critical]
When unmapping a private VMA (resv_map !=3D NULL and vma_lock =3D=3D NULL),=
 what
guarantees that vma is still valid after reacquiring i_mmap_lock_write(mapp=
ing)?

Unlike struct hugetlb_vma_lock, struct resv_map has no backpointer to vma, =
and
__hugetlb_vma_unlock_write_free() only unlocks resv_map->rw_sema:

mm/hugetlb.c:__hugetlb_vma_unlock_write_free() {
	if (__vma_shareable_lock(vma)) {
		struct hugetlb_vma_lock *vma_lock =3D vma->vm_private_data;

		__hugetlb_vma_unlock_write_put(vma_lock);
	} else if (__vma_private_lock(vma)) {
		struct resv_map *resv_map =3D vma_resv_map(vma);

		/* no free for anon vmas, but still need to unlock */
		up_write(&resv_map->rw_sema);
	}
}

While i_mmap_rwsem is dropped, a concurrent munmap(), exit_mmap(), or mrema=
p()
can finish unmapping the private VMA, unlink it from mapping->i_mmap, free =
its
page tables, and free vma (and potentially vma->vm_mm). When
hugetlb_unmap_file_folio() reacquires i_mmap_lock_write(mapping), the
if (vma_lock) check is skipped and vma is passed directly to
vma_offset_start(), vma_offset_end(), hugetlb_vma_maps_pfn(),
unmap_hugepage_range(), and hugetlb_vma_unlock_write() without checking
whether vma was unmapped and freed.

In addition, if a concurrent mremap() runs fixup_hugetlb_reservations() ->
clear_vma_resv_huge_pages(vma) under i_mmap_lock_write() before
hugetlb_unmap_file_folio() reacquires i_mmap_lock_write(mapping),
vma->vm_private_data on the old VMA is cleared to NULL while resv_map is
moved to the new VMA. The subsequent hugetlb_vma_unlock_write(vma) will see
__vma_private_lock(vma) =3D=3D false and skip up_write(&resv_map->rw_sema),
leaving resv_map->rw_sema permanently write-locked.

> =20
> -		kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
> +		if (vma_lock)
> +			kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
> +		else
> +			kref_put(&resv_map->refs, resv_map_release);
>  		hugetlb_vma_unlock_write(vma);

[Severity: Critical]
Can kref_put(&resv_map->refs, resv_map_release) free resv_map before
hugetlb_vma_unlock_write(vma) unlocks resv_map->rw_sema?

For private VMAs, hugetlb_vm_op_close() (and clear_vma_resv_huge_pages()) c=
an
drop the VMA's reference on resv_map->refs while i_mmap_rwsem was dropped,
without taking resv_map->rw_sema:

mm/hugetlb.c:hugetlb_vm_op_close() {
	...
	if (reservations) {
		kref_put(&reservations->refs, resv_map_release);
	...
}

If the VMA's reference was dropped concurrently, the reference held by
hugetlb_unmap_file_folio() is the last reference on resv_map->refs. Calling
kref_put(&resv_map->refs, resv_map_release) before
hugetlb_vma_unlock_write(vma) will free resv_map via resv_map_release() ->
kfree(resv_map), and hugetlb_vma_unlock_write(vma) will then call
up_write(&resv_map->rw_sema) on the freed resv_map.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028054620.2755=
25-1-eadavis@sina.com?part=3D1

