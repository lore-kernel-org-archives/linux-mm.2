Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0527CCCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C1C6B00A6; Fri, 16 Oct 2026 10:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CED6B00A7; Fri, 16 Oct 2026 10:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AE26B00A9; Fri, 16 Oct 2026 10:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11536B00A6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:43:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52CEC1604C3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:43:04 +0000 (UTC)
X-FDA: 85328756688.17.1F0DD32
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 503841C000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:43:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iAD7ZIVI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJtgmZrmor3FIwfdZIg6Zf/PH5vjzxmpZb34dCGZXac=;
	b=HLe+ugp9lXwV4kvKfK1c3Xo97K4MZjnxHcMbCpGSGctHQKcc89GCHuCPnbWmOEc0JqQifx
	Z9cLZvY3bCPRVEyyfEjqSYAzPCa2Qk0uQ/J1K+juL8Cpdaf6vQ36K/Hr99LpY47W9tJFGW
	hxpY3kwrSkU++p9gQ3yjBu0o82YRGhM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iAD7ZIVI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792161782;
	b=vhRmTOSyWpVF9ZZBVrAYNYAgezt7Sj/+KMIK+tsKGLfwSrj8+Er0TnRrQDn34BL1BPYdVU
	3UQsIqZcm5zzRzmqZWi6scEAj+eazrIGK63aA3d6Q9M8cdC1oYCaSs87HUJ8md0H8k9AT1
	bQr9APv/19SFYah0VFr9z/Zu9+aAbhA=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-673504236d7so8603d50.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:43:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792161781; cv=none;
        d=google.com; s=arc-20260327;
        b=QC6RYz39cF2wuhOfZvU0qudYK003VOf/N3YRgk/Vr9lSCNvY6b16ZpvWrgZ63Xun91
         5hNrsYSYQ8ijIF96mu/zZHcyfLW6BJyrlRCi8yX//UQbPiupHQy0vw6vzxaSbzBbuuhp
         JzOgZYAAxM3Yq2F0dytkESL8mx9DvT7CK17DTAIcCwzKaORdUyICrYelm+I9rg9W7iaf
         CxSfkSZTSol2s69w/04ZUUgPjFS1v76TwXXD7zu2JzubRJVcS3m7lkuHwko3Fwa57vF0
         r+rlphOqpfNO2ZXRkywmvcJ/inZXArLMXvA6NqLnibKGB9FM+QyRFHUFotoCJOSxlFhx
         jw0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=nJtgmZrmor3FIwfdZIg6Zf/PH5vjzxmpZb34dCGZXac=;
        fh=YaskPFwzSsNm4vrOsoSx8+VMjxF33zBbTvnXGsIKL0w=;
        b=Uy+kYnXmeoxV439e+WtuvMPMoK9lnOfEepapF2B16TNf62qHXKjPdTWSaf3CqAey/M
         NcgHdZsLbT23omTl6csnPIRvdF4sSdfOaAnZj+6w6+0kcsuH/dg5hE7GAIHZXB4edS+m
         U0worwlOwIurrZpIMbAQkSZ09BVhd0xOuN2fdL/I+ly5vsuQ1qwqrUiHrtsqEXjQPPsZ
         SlR1PL8gQTywPhqhu7fCuWU3g2bv0rTNkYUyStCfwaO/JxfNXOMf8z93oInQObXLRD/c
         yUN3e7FOenq7gxX4dPJC6N56bkgkXB4lXEqxv+0nfVNMWb59uYRr1yHivQJdcJK011OW
         FxZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161781; x=1792766581; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJtgmZrmor3FIwfdZIg6Zf/PH5vjzxmpZb34dCGZXac=;
        b=iAD7ZIVIMbKhbNZ8Y56xfXmuY1K6+LCRoHTQad89ck+Nrg3C9EUiWSAyUkSTG/z0TW
         13p+l2ARqS2QjRxdYch3nL+Nh4aKH59OvMtcoXH60GrTLFqd1+ngG/WQRpQT4YBwqjGM
         20l7It0D5xHJkmvVT7vo9SeHS06RLlCYochOJVBvSWL9xJXzQxCOG3bhI8kY+gU9m/vd
         ghYedNaUC915g+hz8sZPCUZe2hf0sfwEVjZlOnHVXZyHt/Q3LHHWw6TFPY20P+mo/Suq
         OgjUkhz4J4qgdsu0oWkBWlRhJ99NWLzTbRXvVwCHt2mRDkm8oSoW2daZNselgYHpx7wQ
         ZBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161781; x=1792766581;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJtgmZrmor3FIwfdZIg6Zf/PH5vjzxmpZb34dCGZXac=;
        b=KZ2HAt/DPjNYBG8f8JHp890LBv7SAYMlxpaOU9Fdt3syOEQSG1dnCnsBVYHs1VxnlG
         UQyjDDB8UbAKJcqDEmo0s2DwUG1rKJJrQB8ltwhlMSdxbyX2CIe1GZHgG7p4gDixpL+7
         48/IIqcNKu81k1i2683gp9klWb31ou1G8sU7PeXUduf5tkDCyGLGRfnu5Pd3yHDCfXkl
         2rkG65nUkkf/NIYcmyOzWuktMGLyHjz29sC8l2zsTHxkOaNnA7eCHSAQlZJh1ubKWG2Y
         8AT8EfvE93HIVSA0NOzcASOSBF9FVz3MtiVl+P8aw1RO/McIn3iSVpPpSusStGFNjxK0
         +wdA==
X-Forwarded-Encrypted: i=1; AKwUvBzvYl1ktgaZ6Xkv8tQr1O2PASvczJF14K7K93qELO4rNMqqZ0fI9VskXusYhitYFBuKCDBJYXEkew==@kvack.org
X-Gm-Message-State: AFq9FYLDghfqUg/knTKWX3W9B2mC0SYzRuU2jZh3FdLMv1R1HiHWq6ft
	SG+XWMB+WwSFHtJoprGE7vHO8ci1dVfXpMnMs0Hxj+FDsSpc6zbiww3NzeW2ob9dtSpAErEOaBv
	RdtW7jlGWMI9zgkXmzYzx7+ibfr49tOw=
X-Gm-Gg: AYBFou0HxTRlSWeTBLxS+bFYN6h4bDBpXMp7gaxM4e0a3MqWfdkQsLLYsxAi+OZoK11
	XJQYKzFJNdjC4u4fLt3bi3WpVSschu21gkpkgZd+c3Wx663T+8dQ4XCv01SQgfddPeOMl8ubyJr
	CITHY06fswtlCe25PQTleKdP8vYQcFpmeZK+BYxlBayVyQGM5/OL+sF5Wq1ahhK1Cwu1vRyj9f3
	HpSSk184UtC2EQ/y9azu/jsqSJhy1wkrrO5j0VPCiUsOubBFx1/3AWfABTTjqyUHfxKQ9aYr3FR
	v4x/kqn1ekYfIQu9ZeHZGa2U27J/tZzeVkI8llbjI+LsCgJ67Tab9w==
X-Received: by 2002:a53:ac86:0:b0:679:bf13:c02c with SMTP id
 956f58d0204a3-679bf13cd2cmr835137d50.0.1792161781303; Fri, 16 Oct 2026
 07:43:01 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 16 Oct 2026 09:42:59 -0500
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Fri, 16 Oct 2026 09:42:59 -0500
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261010133751.46807-1-songmuchun@bytedance.com>
References: <20261010133751.46807-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Date: Fri, 16 Oct 2026 09:42:59 -0500
X-Gm-Features: AclHuK8b5Saw62oROYWx_NReQFrlF0sxRRr84kcTA0PC8A8ZSdrqwWS_5T0zMZs
Message-ID: <CAPAsAGyDqG0_JPB3c-4bY9jwdQ7eTxGJT0Ce-NowKiJ44T3LsA@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix runtime shadow page table synchronization
To: Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Dan Williams <djbw@kernel.org>, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, muchun.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 503841C000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: fcqstnc1edumz5uymetfk66zudb5wpwd
X-HE-Tag: 1792161782-731088
X-HE-Meta: U2FsdGVkX1+Un5CM5IPZv2R7Ab/G2gpsMw6cgn0/JlmbmOWe1B7j6vlhnY0gwjda5pUojgyrERk8U+cYFp3rpaceNGIujAVtWvUuORYUmxRLhPMUo1UvvNH/A5G2Ss3An6AoCHluO4wUU8Fa7x1LDb6N99qqugtTP8hZvLmdlWrz8LwR4AlMPCY7mAbQnwV7+blhd8+AoN16Q0NL8Ygw9J6/kPpGYNyS8J1s8wxzB7+6rX1FiPMFei1GBUrHkZTVwSgnpZF9+7yejEwvPGJg5TtnpXspvbpbfjOl7xA6gXuoorkqqw+j0v5haFBGgZGSn57cf1Ssq8PoEHti+jYe/9b6k/wtIAYMOuFQLKKQwDcz1LDDXze5kk7U3M/HE3Vtlbq5/tL7kGUU6a5ZDC6PuBzCvCGsJ4Hb2a5So+yoHqjEh4+TFc2ks9B5HlxP5Oe0Gfy+5kQBiKfyfxuEpa4lIRkiBEk9wiKVEm1p3+MOJjHyfF2h4tzntp0TOwapG/wT4HK+loyDZrErWmpOj/QPapDupqzdDbLvdbVamTkqK6P2Aq6Id18pAJhpLHeBh6L0QbYLaFqaQ5IkvuzGm3Gx4i0Qk9Gap0twTD4YlNv4gHlQrslY3mP8f7DpRKB2RN0MvRnHsQq2QgGJCrmBzcILTVPmjlXQhsynZnetKuRWNHDe7a59ChhSFeziJxzBuhQPEKzr1fiSN9l8AYbyigYk4VP2R7GL8Xkzm4+aFN0ZYJw8q2VbDrQUz9C160AAflKzgRN3USypyCwtIq12tODY6ibRMpWRUYpUp4TGD85vtjeAd39LNlg8hirURnhfYGKIzFqyD6HZ+1zPKre/1y4yVK9c3FeObDGbBN2Xd1+AOx3wOcZBfu48c2otoI369QKbhSyAzrXLPyCYn8hiz4WPDX2kcd4LJAEFa/nvN8uZCvpbAm5ymT5Aejuyha1Xb69MuVHehaw+FTormx9I3S5
 AchoUeA3
 PggGL22ycHnkkz1T30yMKc3pxyjFYZuIcg5zK/ZkKFh+ClnXu5rnelhM8kfWMoQoEByv1ByImwH3LG23QH/fRha48VgeT7scpKt3RFB44Uilp45PHq/a86YByIM5vZjdPEhw6irPC/Ko1xbDNQUo7d43lApcBVCN5XeOjN59mOsjvisNjUXV64ygR9YGn1BYReGYU+dNvYHuRxzvK1JY2moR82GvxgjwpRpyH3frysinhCqoyByBNPPMXpMlXz8A8/Nq6y3g6IY3K6z8ZYhvDzG+NfLQ6708bBIGCtOO1U8owUba4ZWiICkMyuuogpaQ/o1WIJXi+6SxQGCtiZxopnPKRF6uVLBzSYczk78811hjWbonoCvbd9WAmS70c/jK4Rueo9PwxDlyi6Bso9/cWG5QmveFB9YmmBx0m8gNDRLZ3yzw036deaY7IhYluK1QiMV6f9vdzPL62sEEUcArI6CvtGgTS/RUehu4wL2vpKZVrFzl7mCN32PapTDKKKcQxNLRmJsPoFlnGnL8+ceNpu9W3dEMfI0qqk8+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song <songmuchun@bytedance.com> writes:

> kasan_populate_early_shadow() is also used after slab becomes available
> to install shadow mappings for hot-added memory. When this path
> allocates a new P4D or PUD table, p4d_alloc() and pud_alloc() publish it
> only in init_mm.
>
> On x86-64, runtime kernel mappings that add a top-level entry must call
> arch_sync_kernel_mappings() so existing process page tables can see it.
> Without this synchronization, the KASAN shadow mapping can remain
> unreachable and fault when the hot-added memory is accessed.
>

Did you actually hit this crash or it's just LLM's/code inspection finding?

> Add p4d_alloc_kernel() and pud_alloc_kernel() to perform the required
> synchronization, and use them for runtime KASAN shadow population.
>
> Once copied, a top-level entry remains in other process page tables.
> Clearing only init_mm and freeing its target table during teardown would
> leave stale pointers behind. Retain these shared levels instead. On x86,
> this keeps PUD tables with four-level paging and P4D tables with
> five-level paging, while lower-level tables can still be freed.
>
> Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  include/linux/mm.h | 24 ++++++++++++++++++++++++
>  mm/kasan/init.c    | 10 ++++++++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5cca90fc1df6..5453d3e42780 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3855,6 +3855,18 @@ static inline p4d_t *p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
>  		NULL : p4d_offset(pgd, address);
>  }
>
> +static inline p4d_t *p4d_alloc_kernel(pgd_t *pgd, unsigned long address)
> +{
> +	if (unlikely(pgd_none(*pgd))) {
> +		if (__p4d_alloc(&init_mm, pgd, address))
> +			return NULL;
> +		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
> +			arch_sync_kernel_mappings(address, address);
> +	}
> +
> +	return p4d_offset(pgd, address);
> +}
> +
>  static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
>  		unsigned long address)
>  {
> @@ -3862,6 +3874,18 @@ static inline pud_t *pud_alloc(struct mm_struct *mm, p4d_t *p4d,
>  		NULL : pud_offset(p4d, address);
>  }
>
> +static inline pud_t *pud_alloc_kernel(p4d_t *p4d, unsigned long address)
> +{
> +	if (unlikely(p4d_none(*p4d))) {
> +		if (__pud_alloc(&init_mm, p4d, address))
> +			return NULL;
> +		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
> +			arch_sync_kernel_mappings(address, address);
> +	}
> +
> +	return pud_offset(p4d, address);
> +}
> +
>  static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
>  {
>  	return (unlikely(pud_none(*pud)) && __pmd_alloc(mm, pud, address))?
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index 66a883887987..93a74a1fcdec 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -206,7 +206,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
>  			pud_t *p;
>
>  			if (slab_is_available()) {
> -				p = pud_alloc(&init_mm, p4d, addr);
> +				p = pud_alloc_kernel(p4d, addr);

I think it would be better to reuse pud_alloc_track() here.
Pass a pgtbl_mod_mask through zero_p4d/pud/pmd_populate(), and call
arch_sync_kernel_mappings()
only once at the end of kasan_populate_early_shadow()

>  				if (!p)
>  					return -ENOMEM;
>  			} else {
> @@ -268,7 +268,7 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
>  		if (pgd_none(*pgd)) {
>
>  			if (slab_is_available()) {
> -				if (!p4d_alloc(&init_mm, pgd, addr))
> +				if (!p4d_alloc_kernel(pgd, addr))

Ditto

>  					return -ENOMEM;
>  			} else {
>  				pgd_populate_kernel(addr, pgd,
> @@ -322,6 +322,9 @@ static void kasan_free_pud(pud_t *pud_start, p4d_t *p4d)
>  			return;
>  	}
>
> +	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
> +		return;
> +

With 4-level paging the PUD table is now kept here after it has been
synced to every pgd. A later kasan_add_zero_shadow() call can overwrite
it in init_mm only. This might cause a problem, because the aligned
shortcuts in kasan_populate_early_shadow() and zero_p4d_populate()
don't check whether the entry is already populated:

mm/kasan/init.c:kasan_populate_early_shadow() {
    ...
                if (IS_ALIGNED(addr, PGDIR_SIZE) && end - addr >= PGDIR_SIZE) {
            ...
                        p4d_populate_kernel(addr, p4d,
                                        lm_alias(kasan_early_shadow_pud));
    ...
}

So sequence of kasan_add_zero_shadow(), kasan_remove_zero_shadow(),
kasan_add_zero_shadow(), arch_sync_kernel_mappings()
might trigger the BUG_ON() in sync_global_pgds_l4():

arch/x86/mm/init_64.c:sync_global_pgds_l4() {
    ...
                        if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
                                BUG_ON(p4d_pgtable(*p4d)
                                       != p4d_pgtable(*p4d_ref));
    ...
}

Perhaps the aligned populate paths should skip an entry that is
already populated.

>  	pud_free(&init_mm, pud_start);
>  	p4d_clear(p4d);
>  }

