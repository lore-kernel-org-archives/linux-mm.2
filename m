Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6948F606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ga22zn7Z
Received: by kanga.kvack.org (Postfix)
	id 5F0046B05B2; Thu,  5 Nov 2026 23:34:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5FC6B05B1; Thu,  5 Nov 2026 23:34:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449746B05B1; Thu,  5 Nov 2026 23:34:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 250836B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:34:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B10EB14056F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:34:50 +0000 (UTC)
X-FDA: 85403428740.15.F776E28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E5541C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:34:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ga22zn7Z;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793939689;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUkEJyWxlEUAd6dHqpQRBgzc0viOzPmb9/EGQLN/UcU=;
	b=b9pXTbFcMDGt+U3q7/9ANOzEB13nnwDBuPFr7ahC1EDaJ1ftaG0qFLT4QylSDjsm+kRNqO
	v8e5DIy/X36U3dAGkkMkxi6T4ZdKZfPY4jbkHXS0TMgcJDTGcaK0gBrBX0aJOX62KgyfIe
	ukRBCogLg1PVYdVEwg7LJBPqKD5UvjM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ga22zn7Z;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793939689;
	b=1jeAqFLxyaodnqlgeOeJyMxoFU2ujI1utJOM+PjV1dhKVqIa0teWRhKUZHEYt7UuG2/qRy
	7Q58RTr1x44djtW608bb7lnzlPFIxaov9GA+liSDM/b+tAGh47qzC8J3drUZVZK7YkyVqp
	stkCG0CX6f19CWKNoDX4T2YKz+GAMOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9689C605DA;
	Fri,  6 Nov 2026 04:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C091F0089F;
	Fri,  6 Nov 2026 04:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793939688;
	bh=CUkEJyWxlEUAd6dHqpQRBgzc0viOzPmb9/EGQLN/UcU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ga22zn7Znw2giwTWdZhF7ERP6ahnkXPahTQV30EGlt63rtJdEvi2AmaroAHKYFW3D
	 AQKKLZeFMp7rGwGqhQxHeSde2OHEbrURkNw+yM+wdegu60hyTLDHh3sgSr/paQ00dW
	 xlM5v53gRcBNgUjN+R3OTk/VzfmUAlH+ZJL4qKvPLKIEtEW3AixFRAowFKf2/uHtkq
	 4CuzPuSYx/2azw9fOuQsz5qjIulruGo6suk1Qfy6OTF/87YfLw83vkVTVR3Kd4qYFd
	 SpNemZ8zeuzhrt7W5z0IGUoN88j1phJRIrPgxUs57AIsjA2GDifSbp0VUX11OLQR+B
	 KSaktEDJ0R83Q==
Message-ID: <sashiko-outbox-200739@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V4 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anshuman Khandual" <anshuman.khandual@arm.com>, catalin.marinas@arm.com, will@kernel.org
Cc: "Ryan Roberts" <ryan.roberts@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com
In-Reply-To: <20261105043403.3326445-5-anshuman.khandual@arm.com>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
 <20261105043403.3326445-5-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 04:34:47 +0000
X-Stat-Signature: fouzouccj3ea5eg3qynqy65mrbcypmey
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1E5541C0005
X-HE-Tag: 1793939688-962331
X-HE-Meta: U2FsdGVkX18QEIeM1xEWul0WXujI6G+QdLr4A5GjKzpotCYgDY7SUnfOY3NLvItYV44PcRJXvIKd6geArd57crIpWiLtKT5xPM8+opfQJHIsm/KULRNBeZlZLRqnq/1bIAQNbooU0wVI12xODNZIJVlztcvVWofWgd+leprsW82YLFIFnoajO2WBz28YjQyccKjz7LyvVxP050BYHAgZLXats9sMKn35wybGLClCrIjObW1V1y0P4rOaf6TNFPLIOb0pLC02Okv4AHHfwNbDB8Kqy8aZQumr8B3Y9wKi9oHJXoVtqeBL9VxIS5ReqrRFO4ZG29XEcdHyfCseC6ceiOjQnLJYpqraISIJ5uEXzl3jMEj6NnazaiKQDNJ4q/4pKD5Rj67Tu57FJnt6LWp6LtB40wIpi6DQW37yiaHzj1eJQWle34iEOKvZHzPQb/zNIsdqLJasSwXKbSRs9fEulaH45RUgAa5Kd7QYt2I8kijGqF8LC4dMOwiTq3LH+GKtiFKL8VbhZTrz9GNb6KTmE34myB6I7fWVtS1UQENNp0b+4RUiELYqn3WrX8pFFqdFq/hQNjp9699VUkmPd0D4RW6+B1y4wbhWpYKfToJU9b+CvbIfKpwwbq4JWppn8++KArEW8Hp7WXkB1u8JdlsJnyXJwnWveNrOn1BNI7qOGyQgniiI6tAQHEMwDCJVkVLdXzqdRe+LFhoKi1hyzT1zpMmEZjXCWD74f4L3QwCvENyCZiUc3MQ0H4ltDSfGS+ZwZKgmROc+zSYT+fYxP404NPZiEjM9hcYMaGuRnlKQTaEH0/gMjQWbeheQg3Y0H2CD1mCB1vSGhrTWCAaQbLZw1JQqIoGiBmvTtW3kq/XMjuEmNCTuEZtV/WdTR8IWCqtne8vRN0EBKlo521VGylaK12JW6Un7BX9/A8zUPnj/Hhxp+oBv5rqbYn9oi/9A2H46Yx6uyWVwYL8/IXBQHNY
 2Ls5rjXq
 4qFEynD21uNQHRiouPS50Lb0vG366xtufPjA8pe0x35qmLtrXQ9SqnbFB7eb46RWK3T0GOiDWFuaAbMBKDeSlRl2ZKwulJNf4hADm94LlOrdwgSedIGd3kjqSoD3QBXOHsWmBuBssbce2NPcdlystSYKuUOFiM3vK8XMkTKSsc/D45A6asle+LRN613KaiqlSzY3wIst001wm25Q/diuxuseqh+gUQPceJWrGxjzQ+sLxCksl4LKK4ChBwdadwEayG3mnUgQfR9NNvNw/6xztA8dpvs7G5hox3LJZNijibKdPSu/YMOcxhkhx1hiBZsTnC55XiZYofbibyGym03gyGKuFp65XvVTq4lNsu/lrCgOl9sd+WNDplx+rDGFLp2N2QegK7URnymexoWkGG+7JwyQWSpthHIM4quHZJ4FtoIzXzDjESwseO6hMvPNinUyf7JzLSWN+svpQtEpc+ity+yPKnPavBswBlrGoDWRlJbKT3qLtrWgokmLRqJhQYvW+BDmM7KmoGT+dY2J+p80Q5sqmU9Tx/ZJcTehtIyxxVCKHQ/WQhjs9wqF1X6zR07KyF0SGsoEa/+hTDLbors2XidHQ7on1GlmnfGPkDiQor1CrXKyLVYN/OP9XRT8s0Ql2gTgdBEAtkZdQld8GZAGcNnVTxyTIpxzFy2uwUeuH54kKYnM=
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
- [High] arm64/mm: KASAN fault in p4d_offset_phys() during kasan_early_init=
()
--

commit e9bf68a7a555b3c58c2a0a8736f337dde8136ab9
Author: Anshuman Khandual <anshuman.khandual@arm.com>

arm64/mm: Use pgdp_get() for PGD accesses

This commit replaces READ_ONCE() with pgdp_get() for PGD accesses and moves
p4d_offset() and p4d_offset_phys() from arch/arm64/include/asm/pgtable.h
into arch/arm64/mm/mmu.c to avoid header include dependencies.

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 5b5a85a0527d6..11015e1deb32f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
[ ... ]
> @@ -2463,3 +2463,17 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
>  	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
>  }
>  #endif /* CONFIG_PGTABLE_LEVELS > 3 */
> +
> +#if CONFIG_PGTABLE_LEVELS > 4
> +phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
> +{
> +	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
> +
> +	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
> +}

[Severity: High]
Does moving p4d_offset_phys() (and pud_offset_phys() in the preceding patch)
out-of-line into arch/arm64/mm/mmu.c cause a translation fault during early
boot when KASAN is enabled with 5-level (or 4-level) page tables?

During early boot, __primary_switched calls kasan_early_init() before the
KASAN shadow region is mapped. Because any KASAN shadow check will fault
until kasan_early_init() finishes populating the early shadow page tables,
arch/arm64/mm/Makefile disables KASAN sanitization for kasan_init.o:

    KASAN_SANITIZE_kasan_init.o :=3D n

and set_swapper_pgd() in arch/arm64/mm/mmu.c is marked noinstr for the same
reason.

When kasan_early_init() populates the shadow page tables, it calls into
p4d_offset_phys() and pud_offset_phys():

    kasan_early_init()
      kasan_pgd_populate(..., early=3Dtrue)
        kasan_p4d_populate(..., early=3Dtrue)
          kasan_p4d_offset(..., early=3Dtrue)
            p4d_offset_kimg()
              p4d_offset_phys()
          kasan_pud_populate(..., early=3Dtrue)
            kasan_pud_offset(..., early=3Dtrue)
              pud_offset_kimg()
                pud_offset_phys()

Previously, p4d_offset_phys() and pud_offset_phys() were static inline
functions in arch/arm64/include/asm/pgtable.h, so calls from kasan_init.c
were inlined into kasan_init.o and compiled without KASAN instrumentation.

Now that both functions live in arch/arm64/mm/mmu.c, which is KASAN-sanitiz=
ed,
the compiler emits KASAN shadow checks for their memory accesses (such as
pgdp_get(pgdp), p4dp_get(p4dp), and vabits_actual) before the early shadow
memory is mapped.

Should p4d_offset_phys() and pud_offset_phys() be marked noinstr or
__no_sanitize_address?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105043403.3326=
445-1-anshuman.khandual@arm.com?part=3D4

