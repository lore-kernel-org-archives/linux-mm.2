Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC04C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF426B00A6; Mon,  7 Sep 2026 06:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5E16B00A7; Mon,  7 Sep 2026 06:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2406B00A9; Mon,  7 Sep 2026 06:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFA76B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:54:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2BC21A00E8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:43 +0000 (UTC)
X-FDA: 85186658046.23.05618F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1F84F40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:54:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuDnVB4p;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778482;
	b=IAYp8PJF8aN9KYRYX33dOrxoEBnuNAJk2ICKcUI8KtBwQZ9IMjRB6nqK+/23CxdcuRMV3E
	1peRRMyD563BItyxrypUgf9lSTu2ghN8w66mVy+EKKwJYWMycLsloVvr5pC4JZE3n65YQ7
	ESTbbUk6Yp05kRYZXZwmr5UGSKhP6Cg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2kDcdHJk5/m7Tnc5mfqUNhIec3+WIpM8khGzPGZk/Q=;
	b=g7rN95W6hn66hkjxmwBnpzDnbJ1VWvZRiG84M2NazulpB8++GtjYCMSglvJbSJXdbhE52s
	9iZShS1aEd5kbnxLrTGa8nnABK8jxC0J8YruzOnAuY3VInJIwq7g+u8Y8wYQkHEPHyXC3P
	T5OOAFAwrDdkbJ72JzlcTAz7+kL4aX4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuDnVB4p;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 676FA40DF5;
	Mon,  7 Sep 2026 10:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB01F00A3D;
	Mon,  7 Sep 2026 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788778481;
	bh=K2kDcdHJk5/m7Tnc5mfqUNhIec3+WIpM8khGzPGZk/Q=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SuDnVB4pyaKW01eUV/KfJVUgIhnfB3WyusYNcy3W+8WtmRXzuoXab8fluZqnpmpRW
	 73G5CItlhRtFrjBNUQSyUvtqkaXBgXfm+ux/m/wAORo4XZNTbisvJHBuQVNbt4AUxS
	 oD18aVTA2acfzFejjWvF+Tf42dINdkDsmL6SlQ4sgs30ldcF3bfCrbTZ4mfD2gxOjB
	 /tg/8Az6VP3WiwfjKW6Z2Pf/GsnAAzDjcbP4VFSNTJNgAglnC0fs4Am2Z2c7NpDxsw
	 Ub0oq2wnrrTCVy8ssp/49vxsv2gSTyZWKEEiQY40d1YNoq5wHf2rqlacXAOSScyyFF
	 mydrx0HiHzFNw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RFC v9 12/25] mm: kpkeys: Protect regular page tables
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
In-Reply-To: <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-12-743ad31b2c8f@arm.com>
Date: Mon, 07 Sep 2026 13:54:14 +0300
Message-Id: <178877845406.3691569.12554855722197968629.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F84F40006
X-Stat-Signature: y5zgqp8cicakwshtes53utrk5kg9bugp
X-HE-Tag: 1788778481-58082
X-HE-Meta: U2FsdGVkX1+lQ0SXr7RSSQLBN6YghLqjbo0zwxn3l71UskB+YoJZ+WD1jH0OQ9G2hktsLpMa/khSO1MiHYqI7T2+m38Q2MzdhRt3hyto/+nTwu5rVo3krNZNbt2r35wU9RDic347lR7qbFM7a1A+rBYmgSV6Q86z5nYIj6Hgtmo0ItJs7nGojfvU6HZXZWt1QK67GUKKeZCNjS+pGTU5wC8F7NEug9jEVzCwYDvt0vrjL5vSRaAlmE/xtP/E5Em+sX8x5A3cbn6s4mFD/tbEg5Y6xN2JS/n8KT55hi11a5JCGVlbUUtgntxIxTTfpvtkHf0HlK6jARTKbyxRLGLj8l2N26WcwO77Ku189032IETQRgJgS/TO3SzcIm12jCyi24O0aG+DvYQ8N13gO+f4ShlAoDQ8DmjQ0WDTnYav6dYJZHa3viQu6L9ragHYG307Bn/Fk3abmmblaZsxFq448wO58E4yS5lfKPHn61rtFzErreuP+qHKgafS5Fgnh+7Ix1ojO4uojVO0AeyHfsMCy3TwZk4wSxxuu5ePyyRqD2r1908D3wx1oICQZ9SuZBDYax0kvelS9uHOp7z63YN3JJl3aDMMW+WfcrFe5JjDFlJVzc2jrC+NjfBOjM870rgsxMWuJmU0iXCkL/SfVDQfgG62ao+ytQVYabrShd1QuFzX1pxbXiiyUlgKspg3QQu9lpsypJjpTdRl8FT8YFI6WGdNRvgkz1o7FUUwBbDqbNwxm3VhJDH8vKwwPxElNF0WDXEaec/TEF0C2ho7CQMZXNjtsMQmt6BE4Gme6IB2Gmx5F8Fda2d2UfCkdwEN56v9O0KZPcZqC9t4X112h6caEE4ugB2MZPBHc6uhCIg2YAW9eEg7LJuLaAKCQPGg7tghfJg10ZicmrG2p84E0ibHWLYhEIqC/1evNmbsI5MuN7eLElB7BilNznd0JsikAm/FoVEdeZZmpdgMa82yhNz
 WdUQBkOg
 pKH/ifgUaJEeaD4x8uaaM0ip+0hppM5Qh9cNyB/0JGa5aw0HZbz/qsEfO+Xos4b4XkZnL8Etbx9LmdDH5857nD+bFAM2R3/cjjkNB73jslCxB7GEiKFlMpPc7PLor8O2THevK5583MdNly8l4qbPOKy6iuNh5w+R/NZ5GKCkowsFG3ZFbcnj0j/0DeuymIddnIK/jQdpWhGe6pKapwcEMAO+gKUp8rw/+rUGY+bg/OnrvpMyIix+hy3WLkD5xbgdnH/tpnKG/CjEU76ZffdpL3dtKsYDNbikPs9bvBFk4BspLTGHR07wHCsZ4W0XtInJntkRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

> If the kpkeys_hardened_pgtables feature is enabled, page table pages
> (PTPs) should be protected by modifying the linear mapping to map
> them with a privileged pkey (KPKEYS_PKEY_PGTABLES). This patch
> introduces a new page allocator for that purpose:
> 
> * kpkeys_pgtable_alloc() allocates a new PTP and sets the linear
>   mapping to KPKEYS_PKEY_PGTABLES for that page
> 
> * kpkeys_pgtable_free() frees such a PTP and restores the linear
>   mapping to the default pkey
> 
> This interface is then hooked into pagetable_alloc() and
> pagetable_free(), protecting all page tables created once the buddy
> allocator is available. Early page tables are allocated in other
> ways and will be protected in subsequent patches.
> 
> This implementation of kpkeys_pgtable_{alloc,free}() is minimal and
> relies on the linear map being fully PTE-mapped - otherwise
> calling set_memory_pkey() on a single page may result in splitting a
> block mapping, which in turn requires allocating a new PTP. A more
> elaborate implementation could be added later to handle this
> situation.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>
> diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
> index 23ae4ed512f52..288c8853eed60 100644
> --- a/include/linux/kpkeys.h
> +++ b/include/linux/kpkeys.h
> @@ -116,6 +116,9 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
>  	return arch_supports_kpkeys_early();
>  }
>  
> +struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order);
> +void kpkeys_pgtable_free(struct page *page, unsigned int order);
> +
>  /*
>   * Should be called from mem_init(): as soon as the buddy allocator becomes
>   * available and before any call to pagetable_alloc().
> @@ -134,6 +137,13 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
>  	return false;
>  }
>  
> +static inline struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
> +{
> +	return NULL;
> +}
> +
> +static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
> +
>  static inline void kpkeys_hardened_pgtables_init(void) {}
>  
>  #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbddb..eea3131786b35 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <linux/kpkeys.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -3682,7 +3683,12 @@ static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
>   */
>  static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
> -	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
> +	struct page *page;
> +
> +	if (kpkeys_hardened_pgtables_enabled())
> +		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
> +	else
> +		page = alloc_pages_noprof(gfp | __GFP_COMP, order);

Can we make it a sequence rahter than a branch?

kpkeys_pgtable_alloc() does alloc_pages and then sets their pkeys, so I
think something like this should work:

	page = alloc_pages_noprof(gfp | __GFP_COMP, order);
	if (!page)
		return NULL;
	err = kpkeys_pgtable_alloc(page);
	if (err) {
		__free_pages(page, order);
		return NULL;

with if (kpkeys_hardened_pgtables_enabled()) folded into
kpkeys_pgtable_alloc().

>  
>  	return page_ptdesc(page);
>  }
> @@ -3691,8 +3697,12 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
>  static inline void __pagetable_free(struct ptdesc *pt)
>  {
>  	struct page *page = ptdesc_page(pt);
> +	unsigned int order = compound_order(page);
>  
> -	__free_pages(page, compound_order(page));
> +	if (kpkeys_hardened_pgtables_enabled())
> +		kpkeys_pgtable_free(page, order);
> +	else
> +		__free_pages(page, order);

And the same logic seem to apply here.

-- 
Sincerely yours,
Mike.


