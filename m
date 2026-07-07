Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8B8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B428B6B009E; Tue,  7 Jul 2026 09:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A0A6B009F; Tue,  7 Jul 2026 09:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BBE6B00A1; Tue,  7 Jul 2026 09:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2BA6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:45:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00F3E1A0441
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:17 +0000 (UTC)
X-FDA: 84962102316.10.E8D651D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1CD310000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:45:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pu+OUM9r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64Zlwh7XthYCB+Y/TXfGoXBgJ2e6mec67Wgib3RpPC8=;
	b=m94J46QB65HSDXI6GPpFXtIYMz2WuUP5D6ZjYgDQsTywszTJ/a2SwwM+Yujp2N9+QbD1cK
	7TUNNFA8mFneeuiO4TLVRoPjXSClSffLneDtY8r1i2dgLcN2cilXUGrynZmedHeLHuV5lF
	a9JE9DOpdYzyErkWHCxrd4Ul9reQfmA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pu+OUM9r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783431915;
	b=hiKfEjFW/bHfSr7QyilZyCf2bfujt8/qp5+74A7++YXEHUTRAC6RfR+a6nEbKoAMYj2Nn8
	8+yBPj+YUf24q2lufwpOjxzTaEVGh06qlx9OmEe5nIlwHgb2Z2Tb/z73f4MLnmDP4NdrZY
	Rf5cI6nKBGQcH6qkracN4plKX8PWkjI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80006403F7;
	Tue,  7 Jul 2026 13:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DDB1F000E9;
	Tue,  7 Jul 2026 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783431914;
	bh=64Zlwh7XthYCB+Y/TXfGoXBgJ2e6mec67Wgib3RpPC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pu+OUM9rG5fAkB6Zm9U4wuojbQr9NT3rGIkCZkegq0WhRTpplNn2Ddesc0vV9tVaR
	 pMUDmFY2mZBvqOFaoP0/6PqtbZEGYb/lDdPkH2ovov8wQ8EncZtQfXDqxsYw83WOUt
	 UvauRnL0yPG4MM9WK8SwE/J5Bg1YAjZ9kuO7SF4/1DLrPlPsoOFkL931lrKRf5WuZC
	 wFuK+NPZbWoo5bLytlMW1mk/zEUokob+LMybtaJHvRZYlPYWExpVMRtbzfYQ+QcEr+
	 o7NKW5tL0+zik3VccoJp+icoudiB0IPddMHEIO+P8Lbku02GF0o2EywuzA/hwU1fLf
	 +RKiLOpXzxCbQ==
Message-ID: <0e2ba302-254b-432a-b0c6-3e259068ffa9@kernel.org>
Date: Tue, 7 Jul 2026 15:45:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] mm: fix ASSERT_EXCLUSIVE_BITS by passing
 memdesc_flags_t by pointer
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260630070810.470763-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630070810.470763-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: znuwt8z4ic4fmx8nysc9dhr6mj48c8dm
X-Rspamd-Queue-Id: C1CD310000B
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783431915-598151
X-HE-Meta: U2FsdGVkX19/+awal6h+4GN87JEN1PxExYQmLqaEe4s9APvgx9+XIM32/u3nEG+PRRGKpG1aM9OD338Sw7cNiOlPNY27Sj9pioSzhKKzo+YAGqFIBLd/xswp2UAi+MhYZH4k3RX8uzi66aezvOocQOaVwmS2aQWNAKqVQ2fecLKVcV2nYh2kSlfmqivNMby9rlsEQqnfXq+TI2MVPusnBMzAJctDLWwPwnUf2ZB6Tg14AtWhQAG4T+K4vFfr84iqQ0d3EVtN+orKQEUKjLEWt/9Gc3jwH81EYLb5DYOZwpI6z6/kRuO3TnGr4pA0kKHJZ6pfICs8ilLJn9zTTiiOWHSF0Af56kIVtJi8G323a6v+z/k58p5Q6DzSIAuoehUwo5BI5n0TKOcXks5UDS43lKuMBlReZcHL8+t/P3vbwleISKkZWJ/2Ss8PLAfpxIC1aLqktX5o6f9a3Rhu9LwNuD4Zancm8yCWSbTkgbBo8bCE45wbITXLoWTBwwm8+J4G7lXvLwxEVygMHKPvYW8JALIV0OrEMGWF72GeHLqG4EpOGl1qd6sEkZeeXUNYS7QoF0Z54ZukVl3/RZJ6T2HWdYTzuksqRw4zy3sGx0REeVtEY0R6jI+B3FU36Bx9XpZ7VI/cX5vrREWCP1i4BR9TedDR8vb61gOBI2xSIoeO4TuQN1BVWTrvc3uJsA9uYlEad45LbiaBCl80+T/u29X3Hh4eiXRZuVn3ERjfIcxZTBxfwA2vCGIphbhOWcUV+HCikPCeKSUZVoCsu/3VkniEDmZrUXXkh48iU8OlXXd6gHMa+20yWbK4ONZzP3nErBL517+Oa95bkCx75KErJk7zrpuqomv05ljJTsepEX12CerMEo1bJICJ4HhUEl6je7c+4DA4qVL98iHH93dY2BgnuLbkVep+0oCvEy+W3vWBWQC8nAFRL8WR9KT6apmS9CH42nNcuoeBQd6Y5Dm98Vs
 AYT0gRDA
 WIUXLQgkGq7K4aTrAiQRuk1c7RwQuBLEdjX4s2+NKLx7kHmPLhTlEwijkmPgFa8nFrU8hhrhkUdjNqNdm9hqFOWYx7r3P879LFwr58gqDM1QhIFDHwhmYtB8fvuXF12Clga/b9lKpY9rkgmpxnGg98JwooPGKLh07N9FtDUwHiwvY2aZ+ECvyF6YpVxgu3rhKf3nxSmsSv/eXvfJps9c+rA2C3gvbRRXL1TYi4R5PM9D9Q5EdmizGgDc27907je3oQ2kgqn1IT+3zJ27GYYq+xw6d3zpmC/dPtsOWzOQfcFatIURmZZMXOzhs5TqRdz98tK3Z0LVt9M18tWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 09:08, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The race is benign: nid/zone bits are set once at page init and never
> overlap with PG_locked.  However, ASSERT_EXCLUSIVE_BITS() inside
> memdesc_nid/zonenum() was checking a by-value copy of the flags word,
> not the live page->flags, so it failed to annotate the real access.
> 
> Change memdesc_nid(), memdesc_zonenum(), memdesc_section(), and
> memdesc_is_zone_device() to take a const memdesc_flags_t * and update
> all callers to pass &page->flags / &folio->flags, so
> ASSERT_EXCLUSIVE_BITS() operates on the actual shared word.
> 
> Guard the ASSERT_EXCLUSIVE_BITS() calls in memdesc_zonenum() and
> memdesc_section() under ZONES_WIDTH != 0 / SECTIONS_WIDTH != 0 to avoid
> a zero-mask check on configs where the corresponding field is absent.
> Under CONFIG_NUMA=n, stub out page_to_nid() and folio_nid() as plain
> "return 0" instead of reading page->flags when NODES_MASK is 0 and the
> check can never fire.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> 
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v9:
> Add the SECTIONS_WIDTH check to memdesc_section.
> v8:
> According to the comments of Andrew, include kcsan-checks.h in mm.h.
> Incorporate David's patch that switch memdesc_nid(), memdesc_zonenum(),
> memdesc_section() and memdesc_is_zone_device() to take a const
> memdesc_flags_t * instead of using a per-accessor macro/call-site hack.
> Update all callers accordingly and extend the same exclusive-bits check
> to memdesc_section() and memdesc_is_zone_device(), guarded by
> SECTIONS_WIDTH != 0 / reusing ZONES_WIDTH != 0 to avoid zero-mask checks
> on configs without the corresponding field.
> v7:
> According to the comments of Sashiko, restrict the memdesc_nid() macro
> to CONFIG_NUMA, keeping a plain "return 0" static inline stub otherwise,
> and re-add a local page pointer in page_to_nid() to avoid evaluating
> PF_POISONED_CHECK(page) twice.
> v6:
> According to the comments of David, turn memdesc_nid() from a static
> inline function into a macro so ASSERT_EXCLUSIVE_BITS() can check the
> caller's page->flags/folio->flags directly.
> v5:
> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> ZONES_WIDTH != 0 (for zonenum).
> According to the comments of David, avoid calling
> PF_POISONED_CHECK(page) twice in page_to_nid().
> According to the warning of lkp, switch the CONFIG_NUMA=n
> page_to_nid()/folio_nid() stubs from macros to static inline functions.
> v4:
> According to the comments of Andrew and Sashiko, set
> page_to_nid()/folio_nid() as static inline stubs returning 0
> under CONFIG_NUMA=n.
> v3:
> According to the comments of Andrew and Sashiko, move
> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> into the page/folio call sites.
> v2:
> According to the comments of David, remove useless comments and use
> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> page_to_nid().
> 
>  include/asm-generic/memory_model.h |  2 +-
>  include/linux/mm.h                 | 42 ++++++++++++++++++++++++------
>  include/linux/mm_inline.h          |  4 +--
>  include/linux/mmzone.h             | 26 +++++++++---------
>  mm/page_alloc.c                    |  6 ++---
>  mm/slab.h                          |  2 +-
>  mm/sparse.c                        |  2 +-
>  7 files changed, 56 insertions(+), 28 deletions(-)
> 
> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
> index efa6610acbc7..f8404bc7773c 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -53,7 +53,7 @@ static inline int pfn_valid(unsigned long pfn)
>   */
>  #define __page_to_pfn(pg)					\
>  ({	const struct page *__pg = (pg);				\
> -	int __sec = memdesc_section(__pg->flags);		\
> +	int __sec = memdesc_section(&__pg->flags);		\
>  	(unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec)));	\
>  })
>  
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..60722c42a622 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -37,6 +37,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> +#include <linux/kcsan-checks.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -2286,23 +2287,45 @@ static inline int page_zone_id(struct page *page)
>  }
>  
>  #ifdef NODE_NOT_IN_PAGE_FLAGS
> -int memdesc_nid(memdesc_flags_t mdf);
> +int memdesc_nid(const memdesc_flags_t *mdf);
>  #else
> -static inline int memdesc_nid(memdesc_flags_t mdf)
> +#ifdef CONFIG_NUMA
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
>  {
> -	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
> +	ASSERT_EXCLUSIVE_BITS(mdf->f, NODES_MASK << NODES_PGSHIFT);
> +	return (mdf->f >> NODES_PGSHIFT) & NODES_MASK;
> +}
> +#else
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
> +{
> +	return 0;
>  }
>  #endif
> +#endif
> +
> +#ifdef CONFIG_NUMA
> +static inline int page_to_nid(const struct page *page)
> +{
> +	const struct page *p = PF_POISONED_CHECK(page);
>  
> +	return memdesc_nid(&p->flags);
> +}
> +
> +static inline int folio_nid(const struct folio *folio)
> +{
> +	return memdesc_nid(&folio->flags);
> +}
> +#else
>  static inline int page_to_nid(const struct page *page)
>  {
> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> +	return 0;
>  }
>  
>  static inline int folio_nid(const struct folio *folio)
>  {
> -	return memdesc_nid(folio->flags);
> +	return 0;
>  }

Why do we need two sets of helpers here as well? Shouldn't memdesc_nid() take
care of that already?

> +#endif
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  /* page access time bits needs to hold at least 4 seconds */
> @@ -2541,12 +2564,15 @@ static inline void set_page_section(struct page *page, unsigned long section)
>  	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
>  }
>  
> -static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
>  {
> -	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> +#if SECTIONS_WIDTH != 0

How can we have SECTION_IN_PAGE_FLAGS but !SECTIONS_WIDTH?

We have

#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
#define SECTION_IN_PAGE_FLAGS
#endif

And

#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
#define SECTIONS_WIDTH		SECTIONS_SHIFT
#else
...

> +	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
> +#endif
> +	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
>  #else /* !SECTION_IN_PAGE_FLAGS */
> -static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a8430a7ae054..efcddb9925ad 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -650,7 +650,7 @@ static inline bool vma_has_recency(const struct vm_area_struct *vma)
>  static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
>  {
>  	struct page *cur_page = pages[0];
> -	unsigned long section = memdesc_section(cur_page->flags);
> +	unsigned long section = memdesc_section(&cur_page->flags);
>  	size_t i;
>  
>  	for (i = 1; i < nr_pages; i++) {
> @@ -660,7 +660,7 @@ static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
>  		 * In unproblematic kernel configs, page_to_section() == 0 and
>  		 * the whole check will get optimized out.
>  		 */
> -		if (memdesc_section(cur_page->flags) != section)
> +		if (memdesc_section(&cur_page->flags) != section)
>  			break;
>  	}
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index ca2712187147..e60dad546ca6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1272,31 +1272,33 @@ static inline bool zone_is_empty(const struct zone *zone)
>  #define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
>  #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
>  
> -static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
> +static inline enum zone_type memdesc_zonenum(const memdesc_flags_t *flags)
>  {
> -	ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
> -	return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
> +#if ZONES_WIDTH != 0
> +	ASSERT_EXCLUSIVE_BITS(flags->f, ZONES_MASK << ZONES_PGSHIFT);
> +#endif
> +	return (flags->f >> ZONES_PGSHIFT) & ZONES_MASK;
>  }

Okay, ZONES_WIDTH can be 0 with "MAX_NR_ZONES < 2", and we'll always return 0.


Nothing else jumped at me.

-- 
Cheers,

David

