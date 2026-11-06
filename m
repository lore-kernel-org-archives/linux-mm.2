Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94771606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O6uzABMp
Received: by kanga.kvack.org (Postfix)
	id 995236B05B0; Thu,  5 Nov 2026 23:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945716B05B1; Thu,  5 Nov 2026 23:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B496B05B2; Thu,  5 Nov 2026 23:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69C156B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:34:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1717160C9B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:34:49 +0000 (UTC)
X-FDA: 85403428698.25.D47391F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 294D540003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:34:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6uzABMp;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793939688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjHCkiX1DxGw4VudwKQlKUUW9/FbD3J3r+sGDh0hf68=;
	b=VYDdlybW2P+hltcC8iURbYqILVKngJAKgBaES6GwIqzt8+FMn9xBbkOC83jtr66rd/TA0h
	tX5vaj3XRlWzqEVrbSIgtz0iL7LxAu0Typ/54nN6DAyaAz58yRlVUCbAKMW6eG9ZKSSMOl
	MzLyEclDBliMH741Q+iCrQZ7v3oE02E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6uzABMp;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793939688;
	b=jKCjyU12bC/uT/q5gTlaQrhDDl9HN4SZiues4R8rXW0kN1hxV8BVXQnHEZ7USXEbKGjU1X
	/Kjti9JTMbHSPycfnNoeYZECaJSJRicDT41H60RcA8/mZq5KrOVMlzTIv/EqwW//9FjK3H
	/EdoB0Vq1nWPosiQVSqd6tueBpH8l5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AA3243C18;
	Fri,  6 Nov 2026 04:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A040A1F0089F;
	Fri,  6 Nov 2026 04:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793939687;
	bh=NjHCkiX1DxGw4VudwKQlKUUW9/FbD3J3r+sGDh0hf68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6uzABMp6UiMjcIylH36jG6CsdoKIrO/zf5uqGPmsaTPEmFWdt70dJ+u3zzF5608s
	 NrjNQSaZ39ogvHoQfwfeuVZv69MQPQpLIcydqYF8Kuj/TfHR6pFjyA6s/UNvpjsmI3
	 M9w1fPkQ4SRLy8DQnQ2fXoG3lrAjeLBeJHS2xtdfDHEgPEGMck0CaSLlez2+lAgJ0T
	 1tge/02AHPWBalD9LkhBUIpBGBKDcbSKYm1m0+xz1K1OajxbHLYFG1CcF85jFcN5ip
	 IXAKQv4kPBBY6hmdB1MxMzpxvZfxAretSQar9kNaaPGwOvlrg5AJS6bx3BsqeI/Nni
	 B+C1z90YRd1xw==
Message-ID: <sashiko-outbox-200738@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V4 3/4] arm64/mm: Use p4dp_get() for P4D accesses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anshuman Khandual" <anshuman.khandual@arm.com>, catalin.marinas@arm.com, will@kernel.org
Cc: "Ryan Roberts" <ryan.roberts@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com
In-Reply-To: <20261105043403.3326445-4-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
 <20261105043403.3326445-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 04:34:46 +0000
X-Stat-Signature: 99g7bc767jmbauxjqcspk8hhio87taii
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 294D540003
X-HE-Tag: 1793939688-5021
X-HE-Meta: U2FsdGVkX1+qfLs5yo9ZQKMZdhXRmlehZI/Yh4MX/H8vivztYaEHcvggN/burv7b0zoEUwNGl8ZrokevzO81hYDH0QfJBC64JstrAFax/l9g3KJ2DL0P+h2axIue+LxjI+fEnxzTajVY3+lciIv2m/K3/+fyq8Wtd+rSrXMWMjihPZHcvMor+sqnpBirtyA3T/FNd+AfkPxOeeDnxvIx/VpIG+kmlf+iV2gcgLodxo2A2CCmaGurVY8WEDcoaffsWPMWMnyINXb98r58QCB8+GVIzFIwx4hBeu7IKFKWBztlMS9NYoWQuy5Kw9lq0FLmxW4ypSi7dLKKpuiXbcfDzCpUDWk9kXbhByK4Hp2KBQNjdJen4V8yhUOcK1H5zWnVk8iNEhu5jBf29WIT+Dc8WlSGoqYNIE9cgm+sB20BZvQq4cHRdbRxQRw2c2GgeFWfG/v9jXsf7UY+5vnVksQPzI/YxLjJotzBFDWB/mR2ahwowao0i++Z+wTzzABscRwJEkuCHFwb01WWyQKi8rJ8WhUIc9FNuoInGQBFnZkc4CDVm8M2KOhI/OUymFuNZ74sFMKTJzHgC50RBnw2/pfwVC7nkOewppEE5QHO0KL+2FXzYrKF+3eAL6MRVKChj4IFxh7eYzXn5BqCuGapjU5WdHpSsi4zUm0st6ZJHj5SaPO6a1OTGwzaJWFDGu2VdZpQn/HRmd0/kgoPWLWxDpVUHv9mycB1LFMuHbo9KprCtuzc4MmZwNMT4WujJTOOjKQP81j5khntleLjjTF6HlLUJsuuu2jIYCpzZ3lbN+IYBiY/2iCQlI2aEU+epvzGquGpCa/YLSRWc+GZamgkE1dXLOPWh6zOwdPUi/NPffJn8rMGaoLoKyVtQHEtFslBro1q5KD4MghiIBGvInfJ7WAYQwsfrSwfrl435uqEFVEIP2BSXEQStulIJoHyp++6fDu7mH8REqM4JcGzysFyvJA
 ojCR9XfW
 K2prW6QXgFlUL3nzi5i1WVxhKRI0168CAUshr2TOWjlkODqdoIqBoYNeUsZbQ3tbkq3nsC3O4q/JcUGFYTtsaGeV11H0SnmW995bT/5dcDG84vxadD6tDBmCMZvfUov9uq0TDYXevSe9+io0iwYsjDSKOAlUN0y7hs6hqy/VdjOhbaybYrDD/Pt1HT+WyJ0YkXjTwIXXY7F7C2xH/qZFAvfq+lGixgmMbjzoZVGF7EUyMhFOkdPrGXsz3aKv2BatYgNhlEY0FYRoVQWESyFMWTImeXNTFJ29UVMjuYhVhcQYkBT9TNCfH6bH8vwEUmYiNGIozRSwcQJNcn+x6enwwUsNhCbjOukvmMSEwWpm1AzbxSYTsjEKcm4EFIBVrrfegzakTKKz7iyKVli5DxHu3oyABDb6SSbqVq4U74nyADZsxnuK7oxjZ6pzCTTNnbkK4hZrE23OI5ELKbrMEynZYGey1nJglxSh4p4Hdhqn3ACZXt+Z/wB03P3tOoF9jrOKSRlULA7Tpj/HZ4sldQAPOHlLblJed1Y1biU5vEV2sgnJmJphn0QM8/L5zQ68izhh3WElZk8UapQ1rW7xuvvpS0QjSpHzg4NOds8ERH3jbR+PW8kCEphm2HwQ2y1Y78/zN0QVtFiM7kx9HoYMOWhWe12L5ndcay5mxCqpFT4/xEzbtaoQ=
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
- [High] arm64/mm: early boot KASAN fault in out-of-line pud_offset_phys()
--

commit eaa67607aabb8af35fe6970c5442e1ab262f0286
Author: Anshuman Khandual <anshuman.khandual@arm.com>

arm64/mm: Use p4dp_get() for P4D accesses

This commit replaces READ_ONCE() with p4dp_get() for P4D accesses across
arm64/mm and moves pud_offset_phys() and pud_offset() out of
arch/arm64/include/asm/pgtable.h into arch/arm64/mm/mmu.c to avoid header
dependency cycles.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index afa15b1a8a247..5b5a85a0527d6 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c

[ ... ]

> @@ -2449,3 +2449,17 @@ bool pmdp_test_and_clear_young(struct vm_area_stru=
ct *vma, unsigned long address
>  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
>  }
>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOU=
NG */
> +
> +#if CONFIG_PGTABLE_LEVELS > 3
> +phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
> +{
> +	VM_WARN_ON_ONCE(!pgtable_l4_enabled());
> +
> +	return p4d_page_paddr(p4dp_get(p4dp)) + pud_index(addr) * sizeof(pud_t);
> +}

[Severity: High]
Does moving pud_offset_phys() out-of-line into arch/arm64/mm/mmu.c without
noinstr or __no_sanitize_address cause an early boot translation fault when
CONFIG_KASAN_GENERIC or CONFIG_KASAN_SW_TAGS is enabled with 4-level or
5-level page tables?

During early boot before start_kernel(), __primary_switched calls
kasan_early_init() in arch/arm64/mm/kasan_init.c to populate the initial
early KASAN shadow page tables:

  __primary_switched
    -> kasan_early_init()
      -> kasan_pgd_populate(..., true)
        -> kasan_p4d_populate(..., true)
          -> kasan_pud_populate(..., true)
            -> kasan_pud_offset(p4dp, addr, node, true)
              -> pud_offset_kimg(p4dp, addr)
                -> pud_offset_phys(p4dp, addr)

At that point, no KASAN shadow PTEs have been mapped yet, which is why
arch/arm64/mm/Makefile sets:

  KASAN_SANITIZE_kasan_init.o :=3D n

Previously, pud_offset_phys() was a static inline helper in
arch/arm64/include/asm/pgtable.h, so it was inlined into kasan_init.o
without KASAN instrumentation.

With pud_offset_phys() moved into arch/arm64/mm/mmu.c, which is compiled wi=
th
KASAN sanitization enabled, calling pud_offset_phys() from kasan_early_init=
()
triggers KASAN shadow memory checks on p4dp before the early shadow memory
is mapped.

Should pud_offset_phys() be marked noinstr (like set_swapper_pgd() in the
same file) or __no_sanitize_address?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105043403.3326=
445-1-anshuman.khandual@arm.com?part=3D3

