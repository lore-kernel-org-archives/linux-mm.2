Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44942606A31B
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xp0pwalR
Received: by kanga.kvack.org (Postfix)
	id 5A52D6B0B80; Fri, 23 Oct 2026 22:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F4A6B0B83; Fri, 23 Oct 2026 22:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA816B0B85; Fri, 23 Oct 2026 22:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2123C6B0B80
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:31:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95780A781D
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:31:37 +0000 (UTC)
X-FDA: 85355943834.14.140B7D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E04D7180006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:31:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp0pwalR;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792809096;
	b=gfcVr33zdIbkz1MipclLJAjTl918A3oSVxMNOITY2C2XU++YDqaz9wrwGSpcM7wRwi2q2r
	yH+R/svnRmb2edg2nbrDjqjO4WwDcgedAzGEf9Ea5ZfQ2TsHZYLfMff/X7oa7LkFYLaYWi
	iOuh4MIIoHILaLvjMDxN9EoinxRRwzg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp0pwalR;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792809096;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYKVkkzsleB4XgO7/jFAc83Gj5L6kG3Yn16ZKmSQ8uQ=;
	b=gw7Rj4Lmha447NjAdK3QISuYnzy2qA5vcrXqK9k/UCGC2lrnuV+zlU4MDvpI571UikYynP
	/cKk3py4rapswY4aOveDqbR3qX0VbkC9v/xnwqZN0OMEeKw/pusHwZh8oorUhtjsF12j/v
	IxwbxP38zqj3zOVvnxTSwX+eqv6D/6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B02E040406;
	Sat, 24 Oct 2026 02:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC301F01825;
	Sat, 24 Oct 2026 02:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809094;
	bh=iYKVkkzsleB4XgO7/jFAc83Gj5L6kG3Yn16ZKmSQ8uQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Xp0pwalR7B9s+h5fQMPI7cU4ykxaegPpjG36rWqZYteBeM6i+ElnYVVEgnVRqmFme
	 SCzCrLS3v+2fK3APshl0qtsxK/N2nhmzCLKNKNiq2Jzq7/Nc3dxAvS5/KCPstJB5Yk
	 lVWjjijc708zioTNNkF/jCofbFbNEMHYIxU8GTalyPSHKTEdp3aPdTcxygui9agWzb
	 aq6HDaZr44tc2xwXY+fZaRQGwRc+TbZjtHCnri0VmJAO4Br1T2weHfYY/BrfhUCabR
	 DMUjRraqjRuMKj/l2v7hbFR4cUzjOJoaSjJQNZnDLokJj5M2E/tETVpDmbbXANf5eK
	 PX4UbQ+Ly7rxA==
Message-ID: <sashiko-outbox-183514@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is
 set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luiz Capitulino" <luizcap@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Jakub
 Matena" <matenajakub@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261023023106.515365-1-luizcap@redhat.com>
References: <20261023023106.515365-1-luizcap@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 02:31:33 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: E04D7180006
X-Stat-Signature: ejffed86i4wizxmsxsx7jryrc7unuwbq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792809095-969066
X-HE-Meta: U2FsdGVkX1/BOzZsv7NQF72uxx+E9LzMSWRtCBKkVGIlnN/O1Z4V17A1X23b0wXeBh2o9Okd/8rDpQtdp44Dmyy1w7qVaWe5coD0q03O0IBWpHn9LLsId+TAl0vRUbmmt00Q1ain8F5CxoxVqmSTzhnWyru8Enqid67APf/ChvLU5tp+cJvFWkXVucrHrb5J/KNmoUlCZmRr9zw0m5sdudNxBYH98IRR3zaeTYs/sDCfdv6giqYgmRV6XLm2XRpv/hNBFZszHMwiGPXF2JOi7Oy1NhSNoFE7lAWlc/pyPKcrN/f9W2AlqbvzKBODAC/0NesVb7sWomO/UAGb4XADPC1XYyhH74SK7yRKXvirWNwlb0n1P58u1gt8i552emasQpGUipQaKVatC+oeZJRtE/fI0uzzt+j2wdU9BBYcamiXn+b85s5iTxvMib2U5pknC1JaHvofwvK+U5Wwj2pqLUqXd1G+ocCSwPyldI3d2v5lLD3Hk0XrH3ldkA40IKdRgw/jo1ZLEra6OMTuMjnFovSOZ6XRulCx/W0nT7YBuu0SwlCFBwYPi5SZEBtmNStwfo93AJ9Zwguh6dGlfZps7IPP2DCO4+3TxWGL272ORG/hYcY2erkZSzzHPhxtSyWR/7kj5E47z4Ppa1M8zBo+bcUsHB/olOPb0lzFJIaloPW4oceDqdVv4+2Q0Sm8aQPpqGuEIuXSWBD8W8FCHv9HidrgpJrBypZJttPauz5eNUQ48ee/KcKmty/noRMsYPMtxOhyrFgVFz3KOe3+mxheyds7YGzMNOwbLspse13QGtIO+m67t2H3UzzOZ9pWqJMsfKfaXV/uAuuZjtYBWvXu2uzdJwrnU7HNjyAYwcUssmJ4NXb7FN84pEKa7Kh57qx+TtAh/ZzXuSMGkZ0PJMCyNDRJaTf3KvUo3MxHGubvc5ehNt9LKU8tZ9B/xlO3XuB4sdm/P7E3O7QxQxhqztF
 ed4aHNT7
 AESrJfmvFGg4ZXO5F6nHN9ElImU6UPstWvxDkeQhlN752UsOEzEn/R282QnYCJEWB8oksp/AoN0u5dFxwPLnJ4KxF8HwevukcRrU76TNT6Ug1OQNBjCJyaRmPX+GCV7Y/9wDX15kt5MrKkvLFQdcW6ZKJMAFl93bUigTeCA7Z7cgfrDGw09ryOOV23H+rglrw+53+3Pzcquk7JxIWEfva4KK8qmiJG6xo8AdxBvKNl7vCLy2mGLjxdl2fuXkkSAzqQ9SG24s7M3xHEn/9iTjLq0T0xw5BogValJhEu9518rBnhIBf7NH2rXn1EcE+PQKCyHif3sDY4f2fSYC1IpwV6R3Obz0H6FnelxhhBWnlfgMHlQa0/dJ554BSf/WcFzd0ZGd4by9CT+2LuCkZvCHIvmeqPtF2nBa+TVyKReewk84fQ4WwovkPYOOUkaAy6IEy5H2STCYt35AlhL93OarYkaNrFQWbYSfNf+niVOe/BqVO9TmCJ9/9NCwFBcJsIMADhR7bg4rbJuv0BTx8EL+QDJTbQpxBpVdqIC2FBlcfUq0E0F8GJdUIw6ZJyZm6xs3NKXNHJDPBfH23+AcxTdS4hUc0raq+1m4k27g4gDFr/l32iPx0HYA51zNaTD12aYeildb2
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
- [High] mm: vma_merge_new_range() merges VM_MIXEDMAP VMAs in mmap() and mr=
emap()
- [Medium] mm: vma: can_merge_vma() breaks test_vma_merge_special_flags() f=
or VM_MIXEDMAP
--

commit b9b12caabde38874f12fe6aa692b1dcf956d3f4a
Author: Luiz Capitulino <luizcap@redhat.com>

mremap() fails VMA expansion when VM_MIXEDMAP is set

This patch allows vma_merge_new_range() to merge VM_MIXEDMAP VMAs while
updating can_merge_remove_vma() to reject removing VM_MIXEDMAP VMAs so
that in-place VMA expansion during mremap() can succeed.

> diff --git a/mm/vma.c b/mm/vma.c
> index f56317ee82471..12ba8e247b477 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -851,9 +851,15 @@ static int commit_merge(struct vma_merge_struct *vmg)
>  	return 0;
>  }
> =20
> -/* We can only remove VMAs when merging if they do not have a close hook=
. */
>  static bool can_merge_remove_vma(struct vm_area_struct *vma)
>  {
> +	if (vma_flags_test(&vma->flags, VMA_MIXEDMAP_BIT))
> +		return false;
> +
> +	/*
> +	 * We can only remove VMAs when merging if they do not have a
> +	 * close hook.
> +	 */
>  	return !vma->vm_ops || !vma->vm_ops->close;
>  }
> =20
> @@ -1093,6 +1099,20 @@ static __must_check struct vm_area_struct *vma_mer=
ge_existing_range(
>  	return NULL;
>  }
> =20
> +static bool can_merge_vma(const struct vma_merge_struct *vmg)
> +{
> +	/* VMAs without prev/next are unmergeable */
> +	if (!vmg->prev && !vmg->next)
> +		return false;
> +
> +	/* We can't merge VMA_IO, VMA_DONTEXPAND or VMA_PFNMAP */
> +	if (vma_flags_test_any(&vmg->vma_flags, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
> +			       VMA_PFNMAP_BIT))
> +		return false;
> +
> +	return true;
> +}

[Severity: High]
Does omitting VMA_MIXEDMAP_BIT from can_merge_vma() cause unintended merges
of distinct VM_MIXEDMAP VMAs during mmap() and mremap() moves?

In vma_merge_new_range(), can_merge_remove_vma(next) is only checked when
both can_merge_left and can_merge_right are true, and even then it only
reduces a 3-way merge to a 2-way merge into prev:

mm/vma.c:vma_merge_new_range() {
	...
	if (can_merge_right) {
		vmg->end =3D next->vm_end;
		vmg->target =3D next;
	}

	if (can_merge_left) {
		vmg->start =3D prev->vm_start;
		vmg->target =3D prev;
		...
		if (can_merge_right && !can_merge_remove_vma(next))
			vmg->end =3D end;
	...
}

Because vma_merge_new_range() is called by __mmap_region() and copy_vma() in
addition to vma_merge_extend(), allowing VMA_MIXEDMAP_BIT here affects two
other paths:

1. In __mmap_region(), when a driver's f_op->mmap_prepare callback sets
VMA_MIXEDMAP_BIT (for example via mmap_action_map_kernel_pages() ->
call_mmap_prepare() -> mmap_action_prepare() -> map_kernel_pages_prepare())
adjacent to a compatible existing VMA, vma_merge_new_range() will now expand
prev or next instead of returning NULL:

mm/vma.c:__mmap_region() {
	...
	if (map.prev || map.next) {
		VMG_MMAP_STATE(vmg, &map, /* vma =3D */ NULL);

		vma =3D vma_merge_new_range(&vmg);
	}

	if (!vma) {
		error =3D __mmap_new_vma(&map, &vma, &desc.action);
		if (error)
			goto unacct_error;
		allocated_new =3D true;
	}

	if (have_mmap_prepare && !map_is_anon(&map) && allocated_new)
		set_vma_user_defined_fields(vma, &map);

	__mmap_complete(&map, vma);

	if (have_mmap_prepare && allocated_new) {
		error =3D mmap_action_complete(vma, &desc.action,
					     /*is_compat=3D*/false);
	...
}

When vma_merge_new_range() returns a merged VMA, allocated_new remains
false, skipping both set_vma_user_defined_fields() and
mmap_action_complete() (which skips map_kernel_pages_complete() and
call_vma_mapped()).

2. When moving a VM_MIXEDMAP VMA via mremap() with MREMAP_MAYMOVE or
MREMAP_FIXED adjacent to another compatible VM_MIXEDMAP VMA, move_vma() ->
copy_vma_and_data() -> copy_vma() calls vma_merge_copied_range() ->
vma_merge_new_range(). The moved range is merged into the adjacent VMA
without checking can_merge_remove_vma(vmg->copied_from) and without calling
vm_ops->open() in copy_vma(), after which move_vma() calls
unmap_source_vma() -> do_vmi_munmap() and invokes vm_ops->close() on the
source VMA.

Also, since vma_merge_existing_range() still rejects all VMA_SPECIAL_FLAGS
upfront, is the VMA_MIXEDMAP_BIT check in can_merge_remove_vma() ever
reachable from vma_merge_existing_range()?

> +
>  /*
>   * vma_merge_new_range - Attempt to merge a new VMA into address space
>   *
> @@ -1152,9 +1172,7 @@ struct vm_area_struct *vma_merge_new_range(struct v=
ma_merge_struct *vmg)
> =20
>  	vmg->state =3D VMA_MERGE_NOMERGE;
> =20
> -	/* Special VMAs are unmergeable, also if no prev/next. */
> -	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
> -	    (!prev && !next))
> +	if (!can_merge_vma(vmg))
>  		return NULL;

[Severity: Medium]
Does this change cause test_vma_merge_special_flags() in
tools/testing/vma/tests/merge.c to fail on the VMA_MIXEDMAP_BIT iteration?

In test_vma_merge_special_flags(), the loop tests each flag in
special_flags[] (including VMA_MIXEDMAP_BIT) against merge_new() ->
vma_merge_new_range() when adjacent to vma_left:

tools/testing/vma/tests/merge.c:test_vma_merge_special_flags() {
	...
	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
	for (i =3D 0; i < ARRAY_SIZE(special_flags); i++) {
		vma_flag_t special_flag =3D special_flags[i];
		vma_flags_t flags =3D vma_flags;

		vma_flags_set(&flags, special_flag);
		vma_left->flags =3D flags;
		vmg.vma_flags =3D flags;
		vma =3D merge_new(&vmg);
		ASSERT_EQ(vma, NULL);
		ASSERT_EQ(vmg.state, VMA_MERGE_NOMERGE);
	}
	...
}

Because can_merge_vma() allows VMA_MIXEDMAP_BIT and vmg.prev is vma_left
with matching flags and pgoff, can_vma_merge_left() and vma_expand()
succeed, returning vma_left with VMA_MERGE_SUCCESS and tripping the
assertions.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023023106.5153=
65-1-luizcap@redhat.com?part=3D1

