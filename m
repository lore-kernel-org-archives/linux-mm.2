Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E77606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7UpAH40
Received: by kanga.kvack.org (Postfix)
	id 6E0096B05B4; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FA86B05B2; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CBC6B05B3; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35C496B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC97A1C43AC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:23:58 +0000 (UTC)
X-FDA: 85383594156.27.9E1D86D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 022DDC0003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:23:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7UpAH40;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793467437;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTbuZ4TlLn66aZx0G/udEraZkm4xGHJpWVoloZHMvnI=;
	b=E8l1xly8JiG/RrAXV6I9k9wuCzbvIHydQYDIJNS+W7OFO0yotP8jKMIvS2yjhJ/PJWrWSQ
	R3kBqyY5BWlDPXqENpvdswHtoyVd19mpxoMzuMLjLuwa7FVS0/VsOe6kVi91CQC19ixdiZ
	zAaBR5UmxKLnhKUkqPHcZLGiFydsN18=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7UpAH40;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793467437;
	b=xiUG8fg/dPRMfMzOD0UHiIuEpJ81gFO3V5bzpKr56zcDoUodWAsUyV+kk2818c7yFkGpKE
	a5ltEQcExA3U4gfQqqSEDVgwxfCvYB9Jhrc0HIsgq4O5ikfzT2oa9PpjM0CZMUl1CQiYqm
	1cNoH33KZfbtQYY82XczoH2zou83rSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5181543B5F;
	Sat, 31 Oct 2026 17:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF771F000C1;
	Sat, 31 Oct 2026 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793467436;
	bh=dTbuZ4TlLn66aZx0G/udEraZkm4xGHJpWVoloZHMvnI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R7UpAH40aS6ilIzBZClH5ocHIfKGKoK8Urz1v8TTnBHpWhNyQHiApmBnnJ2OhQrEa
	 X6PJ1pjAiLE254e1WY4R7v5xDONzcDXMxp/gry7+ZKh5MIirvrhkAvqfxGwKDnebBK
	 KwHS0A+UryQMWLcfyKX3w7qAZa1QSR01QuM6+BJjhSbol2TBZCgrVkdDN1c/QVR3Do
	 YGLUbSuY/oMSappTncDbyW0F4rDqIoPq2xWmqf3L8Fb4iP1HQ6diAkHoFWY09PQEsS
	 hHijXxqSuffNMJqgZtZf3RIX7o4oMdOmb4c8HoIAFkS27LeDYuS3xf+nyZ8dIQcCLu
	 /EXcm2VdTPy2w==
Message-ID: <sashiko-outbox-192064@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH stable 6.1] mm: move 'mmap_min_addr' logic from callers
 into vm_unmapped_area()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Florian Fainelli" <florian.fainelli@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com, "Linus Torvalds" <torvalds@linux-foundation.org>, "Liam
 R . Howlett" <Liam.Howlett@oracle.com>, "Russell King" <linux@armlinux.org.uk>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Sasha Levin" <sashal@kernel.org>
In-Reply-To: <20261030172216.368052-4-florian.fainelli@broadcom.com>
References: <20261030172216.368052-1-florian.fainelli@broadcom.com>
 <20261030172216.368052-4-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 17:23:55 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 022DDC0003
X-Stat-Signature: a415zx1um5p1b9druf6fwek766xhodbn
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793467436-404027
X-HE-Meta: U2FsdGVkX19cEkDIQlYuGKQ8awTDL5rV2wo7UNsPo9VjzFX/r/oHy2MGDdQc+3zXLxF5YpRv9Vbwk7gJpQMhevNgSzY+6t40fqxppuKytdMfUWlisoY67NrkJLfEvXUNuQkenLURvGOYsNAQFKLiyP2o8nPafCMUoFbjw7QX1oyFy75/L2+NJoXMinkpgvWN0UrijhbVNE2eKBFEqcdaRanF1DiK/R57Edw3GW9cSjm9F+4GS6YB320/Z2t+WSPcjr2cjNhDSO+L9QAidoPnRTPSHT/WqBwO3izSXQfFSjNazsuAZ5Sw0PeIgNWwRD4/stv1rriyHuSbQf3Ve0jkaD4uWrpKeRByrRjR3VS2RTYBOVF9KSmGymZl/twk60ShRwnRz+u/KaaHES6PbzwVn8WJ3Jsf808hFJK4t16x+NVdnXd2XZTB29DTwVDWmy8ssLVsjs5TUsvLxCyRN8BOgMd5tTA4BfWpJPjnkby0Q/ZwXg5Zvcbi6E/duFEYTA3lCGQyw1PXuAhZ8aBY1LW6io57d+GISSq4xFUHdc0XC0UiyXXBDAh+ecVntMvvxBIe9gXEN6eVZwvj5RuUCkLAdnWGmt13iQNvKgGVN1ayZRzKxfU6SFGwM7DlKI1kifQf4SUWgA5yACBXLlhKOIL/HIAaf3lv3URjHxw5vVSRC4w+22ImrUsg6Z/1R65yRD8i0m7Hg77airPNGB67e36JAHo7YTo34XX0sPiIVfAxDxLjE5zfAGMfZ8MFdWejue+p7UvUkuvfq8c/MKNTzDHOeXeLOJJIk9xAPg35LHxsLpwKkQZMFcQ69E9EVN7FknAorOuY2YHq4lr2pUt4HeFLIUJQLrcXYpbgFJr1F77JvaZoD1Wze8vVb3Pd44wN9xcIOwZoBnz/rAPYMLfnsC4fKTuOyq7m8usNc9ShgQCetmxGsFs8OiRxxwti3VEJFmQVvr1OJ0O01UBjbslir2B
 G8YJ6Sq5
 nEFgS+s29c2EY0O53HXxNGExYNiMcLZLl/rl4ECO5KK8yrtT8e6eoArHlWCzFr/oO3kF/QaQESXp7sy67/PzTOVjveq9HuUJ9PFRKcC7KEPTToh/EAAnrIkF/DSMdmntFSiD0foBRnLYzentO3hb5/e4ggGhdXNBzYQgNL2/bf7kuJrOJ9d7+vxfz8nG6quUheof/kt/6ORch3pZo1JQy9JZaDv33dbAGLd8tqs/Wel2Mj3nkLw0NiwlxSIi11LMB49tf6Y1By0vgd0ssZK9T7okR8mUN/rGbngzQo0Ika68o2rzz4eYpq5i/S73C5Blgo7EtsLbJ7toLoGFh+CnuTBCty2KJs2oMmyj8YDy6o3vNXWymF9pKkWDs34512rzfsVsagLeBTKtk85UTsEfP9QIBx5/8l9GRf8sVkozl8makQOKtfHA2XamzWk8kyWwV9gEOlGgeDJPmTlQyNd5hB2DhGsqDDxf4vIR5Xrt5XBSeXgde8MzYbm+JHwg4LlDnewOk4uMt18XrlXfGnmylHu0GctLLuLh/0vrzDNyioonn/mn6Xb8ZV1qsNa8kpz005HC/8Za+ti1hfyIjqHghYAu4QyCCZoA9o+uCbTqzFHrWZIofwut3qVUJHC3hy30ZtJ50LFodtsBFwd9gPOsVTnhiRtZf1C+4cGXZPsj71xUUVM4c66MJWnjKYWpghgK69GImkTPwDssCJ1JoEHvmnR+mwXLtKoJLepIkxRdopjdvqQ1xBMrOO+yGhL+XLVJGz1A6a+hdtPRuhheRj8prkVxI297PzfabLtCj5l5DZznb/IMT+ABOZ60rUQ==
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
- [Medium] mm: unaligned return from unmapped_area() when mmap_min_addr is =
unaligned
--

commit dd218bb48a347d4efd5770f53b201eae3a9f2336
Author: Linus Torvalds <torvalds@linux-foundation.org>

mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()

This commit moves the mmap_min_addr lower-bound clamping out of individual
get_unmapped_area() callers and into unmapped_area() and
unmapped_area_topdown().

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracl=
e.com

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 1eb86aba7de56..17ec4d40edc11 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1598,7 +1598,8 @@ static inline int accountable_mapping(struct file *=
file, vm_flags_t vm_flags)
>   */
>  static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
>  {
> -	unsigned long length, gap, low_limit;
> +	unsigned long length, gap;
> +	unsigned long low_limit, high_limit;
>  	struct vm_area_struct *tmp;
> =20
>  	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
> @@ -1609,8 +1610,11 @@ static unsigned long unmapped_area(struct vm_unmap=
ped_area_info *info)
>  		return -ENOMEM;
> =20
>  	low_limit =3D info->low_limit;
> +	if (low_limit < mmap_min_addr)
> +		low_limit =3D mmap_min_addr;
> +	high_limit =3D info->high_limit;
>  retry:
> -	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
> +	if (mas_empty_area(&mas, low_limit, high_limit - 1, length))
>  		return -ENOMEM;
> =20
>  	gap =3D mas.index;
> @@ -1646,7 +1650,8 @@ static unsigned long unmapped_area(struct vm_unmapp=
ed_area_info *info)
>   */
>  static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info =
*info)
>  {
> -	unsigned long length, gap, high_limit, gap_end;
> +	unsigned long length, gap, gap_end;
> +	unsigned long low_limit, high_limit;
>  	struct vm_area_struct *tmp;
> =20
>  	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
> @@ -1655,10 +1660,12 @@ static unsigned long unmapped_area_topdown(struct=
 vm_unmapped_area_info *info)
>  	if (length < info->length)
>  		return -ENOMEM;
> =20
> +	low_limit =3D info->low_limit;
> +	if (low_limit < mmap_min_addr)
> +		low_limit =3D mmap_min_addr;

[Severity: Medium]
Can unmapped_area() return a non-page-aligned address when mmap_min_addr is
not a multiple of PAGE_SIZE?

In security/min_addr.c, mmap_min_addr_handler() updates dac_mmap_min_addr a=
nd
mmap_min_addr via proc_doulongvec_minmax() without enforcing page alignment,
which is why round_hint_to_min() in mm/mmap.c aligns it:

mm/mmap.c:round_hint_to_min() {
	if (((void *)hint !=3D NULL) &&
	    (hint < mmap_min_addr))
		return PAGE_ALIGN(mmap_min_addr);
	return hint;
}

When a caller invokes vm_unmapped_area() with info->low_limit < mmap_min_ad=
dr
and mmap_min_addr is not page-aligned, unmapped_area() sets low_limit to the
unaligned mmap_min_addr. If no VMA covers low_limit, mas_empty_area() sets
mas.index to low_limit, and unmapped_area() computes:

	gap =3D mas.index;
	gap +=3D (info->align_offset - gap) & info->align_mask;

Because info->align_mask is 0 for normal mappings and has its low PAGE_SHIFT
bits masked off via PAGE_MASK for colour-aligned and hugetlb mappings, the
non-zero page offset bits of gap are never cleared (and when info->align_ma=
sk
is non-zero, borrowing from the unaligned low bits during
info->align_offset - gap also corrupts the upper alignment bits).

This causes get_unmapped_area() to reject the returned address with -EINVAL:

mm/mmap.c:get_unmapped_area() {
	...
	if (offset_in_page(addr))
		return -EINVAL;
}

and triggers VM_BUG_ON(addr !=3D -ENOMEM) in callers such as
hugetlb_get_unmapped_area_bottomup() and sparc64 arch_get_unmapped_area()
that check offset_in_page(addr) or addr & ~PAGE_MASK for errors.

Should unmapped_area() and unmapped_area_topdown() clamp low_limit to
PAGE_ALIGN(mmap_min_addr) instead of raw mmap_min_addr?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030172216.3680=
52-4-florian.fainelli@broadcom.com?part=3D1

