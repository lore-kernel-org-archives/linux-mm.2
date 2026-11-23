Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7D5606A680
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f27GqoCR
Received: by kanga.kvack.org (Postfix)
	id E67116B05B8; Sun, 22 Nov 2026 23:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19946B05B9; Sun, 22 Nov 2026 23:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54896B05BA; Sun, 22 Nov 2026 23:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8EA26B05B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:08:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EB25C07DB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:58 +0000 (UTC)
X-FDA: 85465053156.07.577BEF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73DEC40004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:08:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f27GqoCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795406936;
	b=uuX1/XvPGMJ22QUrT98PVcW68NNO2p3aaoVYTL30m/gBVCwEvxd6k/HVfPU9U8j/SfD39g
	EjSWjdK/hx2EnCz65z6a3m8IxG+K6tLd1xx7dP+vgOXZAvdJFVWF99p8QUMYDHtBT/9+tq
	qaLTKLQVSAPeDZ5JY2w/huwRw4yNQQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795406936;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuqHw4Gph9RkjKQWaBLx14RfCwHsQlcWjuogypsPLII=;
	b=2c7MgfKcC4HkcPvBEOJ2Xcnbzx2fibKezqFWze50NYyKYGiY84CvwFNC9f449caHa7TbzV
	Fp+tD5G523VFJwQd/OssGhhL/rjc0qeG679Xr0UKNud1YjEjmkVvtN0DNf/c/pwC8Yj7IW
	ClHviwbELg7Zrzr3kXuk6xA5299vk/Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f27GqoCR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EF2560148;
	Mon, 23 Nov 2026 04:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005651F000C6;
	Mon, 23 Nov 2026 04:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795406935;
	bh=AuqHw4Gph9RkjKQWaBLx14RfCwHsQlcWjuogypsPLII=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f27GqoCRUvuOyIVASRTCW2ZkktYzSWd7f8Xx8EGVefjahUmDIt730ULy7uOI9tjMb
	 aOSwjyXFvdtULjlv8v1GN7jCA4WG2L+Ov4E9amMHxNEedNY2GCVx4wgd+JIp16cpYR
	 zYQzrBxlPGtkbWIAPpCO5TK46VR3jElPCrhE1e32J30AW9yZAbKq/7eU4z9gzpKNP0
	 X7ia1aI8nTrkT4nBa+tZD3JnHytXK8WijHlbv0kzFnqM0G1cFnGQoiEmd4W/Q3df/C
	 urSIMKsHFVBcBPO7pTh9/VWJiqwmffl5uN8BOFji7TyNchc1H7pMJq/ibDAOUkjbgU
	 68Y5MJCdHs1Rw==
Message-ID: <sashiko-outbox-228645@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement
 try_populate_vmemmap_pmd using AF trick
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Houghton" <jthoughton@google.com>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>, "Linu
 Cherian" <linu.cherian@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Nanyong
 Sun" <sunnanyong@huawei.com>, "Yu Zhao" <yuzhao@google.com>, "Frank van der
 Linden" <fvdl@google.com>, "David Rientjes" <rientjes@google.com>, linux-mm@kvack.org
In-Reply-To: <20261122184453.2668189-17-jthoughton@google.com>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-17-jthoughton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 04:08:54 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73DEC40004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: atzhoiwos7ueq9gzywaa8cqizb9ju8jn
X-HE-Tag: 1795406936-460210
X-HE-Meta: U2FsdGVkX1+4AvZO/gep30wf3+yWR9EeIYeTRuITHTri7UPWAVmeaiI5SB1jq/P0XMa89SDkbMq/Vb5HWzhAZe5wHQaUX/X55K9I2DgUtLKkI+KpI7/O9um4R65waYEP0Ug0IIKlcweUuuBXs2vdxqYqNUimq41xY5L6xXbrGSymSg5feCIN7185VNWo5OQKkCNjAMdSXvJ82nRCsN8fWO9E1feD5gxu0jhIsv5RXruqJ9qriNj7tf0BSMExSU67lth1yyS35A7cIQcYlTxF3WTQLblsiPMY2zMJlpq3sZs7Ad1p56XeE53ZJnTMj40+hCo+5OcmlPXKyMHEhO/wdRWTvqng7jADnDWNCFfrUrp50t6eeo8szbpWTgVVe/ASvFkb/7JB/BNUWh+aj8eYzGyo38Br8jNiXCplvRBKM2+l86tbrP4L/vbWGKTeJdBcweduRmkhX6MmaZD4k51Knu2Nt1Eb4LSIabZzF2WYWzXPSOBv4GPx5MyrQG9sZqf/0hmOfXCJ6iiEKAT6t8igEBXp9k7nczK2iMI98l1E/cDVRGrfqajAN4onjb1wDms6UzDrhMw+ojyL9N6wLwDdVO4oS9uTqTzFlVou1iMMAQKuZSLD9hrwyd3VVcdEv/21YAyp0wOUqkNrAYOZFBdIyTQA6Cus2RcSccYJdhLJRyU5poKDdsYuKuJZk39kZ30l12dVefBA2P+dGUjTT10vHm5JXVseIwxhVeFAw9Mwor6erLsUgqvPFs7dxqy6xcV2T0Hzz4VVas3d0KAgxbKZ45yvIAD4LP70YRylMzLsnh+4uvM7DRSf86bugdUDs4j+LagUw9oSUOuP1OiYPhGEvG9s96no/ZOsV8c0ijbwlrBoK2m1z1hqQ7cNxhrUtBjDGmE5mEZJ/HFQzN+RuJfnQQetro2KMMq499rziCGCctv325NY5uLI3gK8TIRwPe/40XX03SEZm5w0pgoj5Xb
 NDGpq0cr
 pC2u7JIi5rMBmQRsH20D6I5gJTGvOT31sHAq8KzC0OIjDIt+MP/R/Cu55QDNO7+YCRLUyiYudYAO5s8tVbbeVTze+iE2qh+ZASs4YqOoxG8lu3sF5/vdL3943JVdM+CsTB71pFJFRX2AI9iyhoTW+gnOOozKTIdowmbQrgSsthyw3zphejSvpN5/g5AyUaOF6zqn0VKfX85vKZZt6giQT/z6FUKlA/ULm1U/SGKDxogCHT+vPmnxILI5IJm+Pp1PP1vuTwKNVpfbUPMsEGg0KVyLXXchH5lqXk5lnWg3LOBphe+cIyeyYvgo8XGC4XcQF1kWz6OZ+zUTgiTMcnM89yj0NYn6bGCafCfCXH7yb+PYh6G/Srt0L31MMOH+zzObfrYb1hVgM/g+GSX4OseIzTpn7xfa4n3p5jLLtn1exRRV4rI2VYn0eQC+/7WkIV0bQa0TqePhmuAUKvZZpxBzzlPEBw/I3mitClwjNqnOoYoubOHyAOKBDLHu0iTvatCydsHtIkVrBQWizfPvw7IXwV3mTpnHwQ5btFOYb2MEqzIaLeWTUUm7/t1so+O+TKHaukI+w9buGpPivq184tO7/DGDU4JRXWuI4DPHshuJpgaNh4LuiIyFSXJDi4fm3Vg9JW+SVpEqFql39RXM6bBlNuEaQuj5SJ7sl9rWhN09K0D7Qdh7rIC0GgHa5csSuUj8iccpPE5xg1qpwlalJsgjUKcbaux4dCzmskXdxQiYgLGb0fLa7Rq9iQmxbgEhyhA7WGW5zAbYFmJZLJZ+k8KHv6ofO9J/K3ZapoMXrffesbQ9VpE8IvE1osm2tgaaafLunF1+Y0mxK7IlcD2CRuCOhX1VeI5GkJlRfhRY1iVsJ5Cj479eXr6+Fm5ic9Hje7FyInj88eiI5Prul8Vw9t1RYMFM4Y0pF8HQ9F8voAOXdnPBlYoiwtDd9N2jsdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] arm64/mm: over-broad TLB flush in try_populate_vmemmap_pmd()
- [Low] arm64: direct AF=3D0 block-to-table transition in
  try_populate_vmemmap_pmd()
--

commit 1319c4a7862ad5f3b810c4beca866ee98bd48fd7
Author: James Houghton <jthoughton@google.com>

arm64: Implement try_populate_vmemmap_pmd using AF trick

This commit implements try_populate_vmemmap_pmd() on arm64 to replace
in-use leaf vmemmap PMD block entries with table entries by clearing the
access flag instead of using a break-before-make sequence when BBML3 is
not supported.

> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pg=
alloc.h
> index 0263329fb7b30..7e304f01ce6d5 100644
> --- a/arch/arm64/include/asm/pgalloc.h
> +++ b/arch/arm64/include/asm/pgalloc.h
> @@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgta=
ble_t ptep)
>  static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *pm=
dp,
>  					   pte_t *pgtable)
>  {
> -	/* BBLM3 is required. Its presence has been checked. */
> -	pmd_populate_kernel(&init_mm, pmdp, pgtable);
> -	return 0;
> +	const int max_attempts =3D 16;
> +	int attempts =3D 0;
> +	pmd_t old_pmd, new_pmd;
> +
> +	if (!system_supports_bbm_through_af())
> +		return -EOPNOTSUPP;
> +
> +	if (system_supports_bbml3()) {
> +		/*
> +		 * BBML3 allows block->table transitions if the PTEs underneath
> +		 * do not conflict with existing, potentially cached
> +		 * translations.
> +		 */
> +		pmd_populate_kernel(&init_mm, pmdp, pgtable);
> +		return 0;
> +	}
> +
> +	new_pmd =3D __pmd(__phys_to_pmd_val(__pa(pgtable)) |
> +			PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
> +
> +	old_pmd =3D pmdp_get(pmdp);
> +
> +	do {
> +		if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
> +			return -EINVAL;
> +
> +		if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
> +			return -EINVAL;
> +
> +		/* We should never get a contiguous PMD here. */
> +		if (WARN_ON_ONCE(pmd_cont(old_pmd)))
> +			return -EINVAL;
> +
> +		if (pmd_young(old_pmd)) {
> +			/* __ptep_clear_young() returns the overwritten PTE */
> +			old_pmd =3D pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
> +
> +			flush_tlb_kernel_range(addr, addr + PMD_SIZE);
> +		}

[Severity: Medium]
Should this pass addr + PAGE_SIZE instead of addr + PMD_SIZE to
flush_tlb_kernel_range()?

Invalidating a single non-contiguous PMD block entry only needs one
overlapping page-granular TLB invalidation, as in
unmap_hotplug_pmd_range().  With a range of PMD_SIZE and stride of
PAGE_SIZE, pages equals PTRS_PER_PTE (MAX_DVM_OPS), so
__flush_tlb_range_limit_excess() returns true on CPUs without
FEAT_TLBIRANGE and escalates the flush to flush_tlb_all().

> +	/*
> +	 * Translations without AF cannot be cached, so we can replace
> +	 * them without BBM.
> +	 */
> +	} while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd),
> +				      pmd_val(new_pmd)) &&
> +		 ++attempts < max_attempts);

[Severity: Low]
As reported by Catalin Marinas on v1 [1], this rests on an architecture
detail the review could not confirm from the kernel source: can a CPU
walk cache or TLB retain information from a valid leaf block PMD
descriptor when AF=3D0, or is a TLB invalidation and break-before-make
sequence still required before converting a valid AF=3D0 block descriptor
into a table descriptor without BBML3?

If it can, skipping flush_tlb_kernel_range() when pmd_young(old_pmd) is
already false or directly overwriting the valid AF=3D0 block descriptor
with new_pmd leaves stale walk-cache or TLB state active while a table
entry is installed.

[1] https://lore.kernel.org/r/aoSJcAFMNJ1nPl2H@arm.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.2668=
189-1-jthoughton@google.com?part=3D16

