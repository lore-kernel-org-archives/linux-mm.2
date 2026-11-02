Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75114606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JO/gGD9e
Received: by kanga.kvack.org (Postfix)
	id 92AA86B05B2; Mon,  2 Nov 2026 08:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBB26B05B3; Mon,  2 Nov 2026 08:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0D16B05B5; Mon,  2 Nov 2026 08:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 574B36B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:13:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F9FEC0CDE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:13:31 +0000 (UTC)
X-FDA: 85390220622.17.11EFE59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 766481C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:13:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JO/gGD9e";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793625209;
	b=Sey7aAU9JN0PnkWCFeFqqKKQxeFY9q3jq6wi4bNck7T0omIyXNeJ4iHkoEFnot80NKdwu4
	7gNDAz08kd/5HPbOv5PEAzh1wtq7qhhx/FhHDmjNGkpKhFMoRV0sCU+Z3FL47d4pOguIB9
	+hgs+dnzZrWhzxvHy2B1Rtwe93gaK/k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JO/gGD9e";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793625209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yvtg7UEHcDn0BhPld9BffcD6kymWDnPG5L08CfILpNQ=;
	b=FCUf1ia16fh/ogmFT7oZq9Am05oeM1zOK0W70xyY+VsbZ0y/6km351hOxMR57VoL9GQlc2
	0Bal6Aybh66eOqSTtQRYMUTXp7XsgmumTsa8bV70JHvQOvzqiI4soBL/CQE6P9QX7Z8DUQ
	HWizFUDTZf5M0ZWXNjOipFj6m1S9FPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C68C40B4F;
	Mon,  2 Nov 2026 13:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE751F00A16;
	Mon,  2 Nov 2026 13:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793625208;
	bh=Yvtg7UEHcDn0BhPld9BffcD6kymWDnPG5L08CfILpNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JO/gGD9ewHyz2SLuQSnWnv5SkRYnjW6Jlif4kKehidqN1K7Ls90VV+U9KAKZIAX7q
	 I68srTMzUM/97p9GI4YCKRv+h2VcTO1HFSKU5iLgqQH/1KhZn/bImVB8RnGEUwGkuR
	 j9ZuAHOca+gT5pcdFkG2v1PqNoqpqWzgQzUa892tURhDbsdXJ4vWvXEL9swBYlIdCm
	 ygLFkZxPMK+1eDYPrerqdItygGbXfPvJDCRnSR+bQOxzPIbDTuMSv7T0uf6cUMwaVz
	 Q3MNvnI4nJxN/nWFEqeuQGh1hU6ksvsx4fD01hsq0nNa2P59pjXg3az+vM/YmLn7gP
	 A7qEIsD2DHJ3A==
Date: Mon, 2 Nov 2026 13:13:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/mremap: fix hugetlb reservation leak on partial
 move
Message-ID: <auiJW4jzNs76F90O@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-1-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-1-c1829811aed0@toxicpanda.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 766481C0002
X-Stat-Signature: ueha8u3hkdutrxbozwd5yfrdaceipiq1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793625209-368251
X-HE-Meta: U2FsdGVkX1+UXfurNLiZmJO7ar9/WD7kWGiHY9Srq7H3TeqSYwNeVyQ12blG5bAKzcdxSxXZmDl5RHL788S/JdBcOYvcVfBl3wYzpoe0/9/DNdsaV3gt8FOFq2wQ+XdbpS5gG2Wh7r1ZGb7EwzNqR6LtapsTMhMQZB+KrNgzhxoI0GMuRtvgPJkr8OE6vcRgjSp1WVywV6kDhgazlm4Mvw8BwKtXtE4ID1nMXdWlP0dp7qXx61J7MwBeC3Yd71CJoA157FKOa+Yz5v767rqkkZEy1LJVVUuZ1g74LnTIZS6FW7i5lLenGwx/u+2axeYyF09VNAROrZtVXwXK1M2aLn1MnwpVadZ2xtg2WlUgRAONKsk+IxP4AO0n6TYeKNzvc1i4d0bW+SR1c73qtX9QAMKBZ2ZwF7jbHpWt4woKJ5FWegU5V2oS/XdzEZ9qdoHWjEs3kWlVlqGPJQ3QQTVW44c6HdoN0T8q1snBiYt9r4gQhrWSNhGNkM6IdIyR8dThMcb7r17YJVo7L1WfNvcL4nDZ65Kg3oiqxfUdKCIHgV6BpH22KE3CQDBbPKU31dTQuChoALcpXKHwbQLwSdA/GzDxxhc8QlgRfHzsSfhEm86G33dKoOmSVP7dJGWb4g6KR4PKQVWCXbrT5iLFjjmIUmdBEoNHlA2v4x7oEJt0O6vBaqL4ewBD4Ijba9K4o7QRW/nb/LzF4+02fhhlJf71VA52eJa3J+x44S0zyBIfnyOKjz7iQaJTtV51u4Va6sm3Gk5rl+ydLjhIWwNqROiX5ES/b/iCSwGIhnEZLUlcG6wTeCl60pENLscJHVF9HlRrfbkC4vk2r3XFseB3YMul1PL2gN3yGA7ZAYGqCiRfglutOcUUuxdEUTcqP8J8SXfWe2jkMB09th+Q/gqiUoLErOHG18ss1kwxZdzO1aB1+lHr3tXGI1oAcbeXe4skiTOwC2h7AOsygqPmCLcUPMD
 qUN075uX
 VO4ULuKrdPA9VUrMdASn29tKgdPcBJji9qDe6ru1q+iLUu/bMFbHqBIqF0K4hsXRg22MOeNYZJNx5qjjS9bOBMS0ORVDHUldfUlJV3GXWDnQiR+rP0Rop0+pujEofbiROGS4bdX82NWz6dczoX6WCp2bZHdB8tg+gChBWmnXcvhOH7WQIn3faL5vhQHrW3NyzWEQFnJQsQMhqv510O0ip0Zco06uGOpzEvPTZVCvh8G0gqEERJ8QtMRjwTwGZ41EJCLujtWYUEEjHw5DIKEiJ9XV+5mo3bVLjDFv2f7M33jF76NsJO+RAw6HiUvk3Lg37UpngHRSHwrlrhaNFEuUCA7lsKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:46PM +0000, Josef Bacik wrote:
> Moving a part of a private hugetlb mapping with mremap() leaks the huge
> page reservations of the parts that stay. They are not returned when the
> mapping is unmapped, when the process exits or when the pool is resized.
>
> fixup_hugetlb_reservations() takes the reservation map away from the old
> VMA while that VMA still spans its whole range, because the moved part is
> only split off by the unmap at the end of the move. hugetlb_vm_op_close()
> then finds no map in the parts that remain and returns nothing for them:
>
>     mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
>     mremap() of the second page to a new address    HugePages_Rsvd: 4
>     munmap() of all of it                           HugePages_Rsvd: 3
>
> The source is unmapped in this case, so the number of VMAs ends up where it
> did before and the check against sysctl_max_map_count stays as it is.
>
> Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
> moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
> VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA. A backport needs that
> commit, which is tagged for stable itself.

Ack, that one goes back to 5.7 in theory, this one 5.16 so all good.

>
> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Some nits below but LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mremap.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 0d06d7f37f19..cf746bafdee4 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1038,7 +1038,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
>  }
>
>  static bool __check_map_count_against_split(struct mm_struct *mm,
> -					    bool pre_split,
> +					    bool source_stays,
>  					    bool before_unmaps)
>  {
>  	const int sys_map_count = get_sysctl_max_map_count();
> @@ -1092,14 +1092,15 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
>  	 */
>  	map_count += 2;
>
> -	/* If pre-split, the -1 observed above doesn't apply. */
> -	if (pre_split)
> +	/* If the split off source stays, the -1 observed above doesn't apply. */
> +	if (source_stays)
>  		map_count++;
>
>  	return map_count <= sys_map_count;
>  }
>
> -static bool needs_pre_split(struct vma_remap_struct *vrm)
> +/* Is the source range split off its VMA, to then stay mapped? */

NIT, but slightly awkward wording. Honestly I think we can just do without a
comment here, the name self-documents, and the hugetlb 'stuff' is documented in
the comment below.

> +static bool split_source_stays(struct vma_remap_struct *vrm)
>  {
>  	/*
>  	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
> @@ -1109,11 +1110,23 @@ static bool needs_pre_split(struct vma_remap_struct *vrm)
>  		vma_test(vrm->vma, VMA_LOCKED_BIT);
>  }
>
> +static bool needs_pre_split(struct vma_remap_struct *vrm)
> +{
> +	/*
> +	 * fixup_hugetlb_reservations() takes the reservations away from the
> +	 * source VMA.  The parts of it that do not move have to keep theirs.
> +	 */

If only we could swear in comments... :)

> +	if (vma_is_hugetlb(vrm->vma))
> +		return true;
> +
> +	return split_source_stays(vrm);
> +}
> +
>  /* Do we violate the map count limit if we split VMAs when moving the VMA? */
>  static bool check_map_count_against_split(struct vma_remap_struct *vrm)
>  {
>  	return __check_map_count_against_split(current->mm,
> -		needs_pre_split(vrm), /*before_unmaps=*/false);
> +		split_source_stays(vrm), /*before_unmaps=*/false);
>  }
>
>  /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
> @@ -1162,10 +1175,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>  	if (err)
>  		return err;
>
> -	/*
> -	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
> -	 * case perform any split ahead of time for an mlock()'d VMA.
> -	 */
> +	/* Perform any split ahead of time if the source VMA has to be distinct. */

Nice reduction in comment size too :)

>  	if (needs_pre_split(vrm)) {
>  		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
>
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

