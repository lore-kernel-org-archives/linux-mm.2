Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF90C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4216B008A; Wed,  8 Jul 2026 04:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC066B00A2; Wed,  8 Jul 2026 04:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B7C6B00AB; Wed,  8 Jul 2026 04:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5296B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:04:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C853AC408E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:04:55 +0000 (UTC)
X-FDA: 84964873350.08.E6A8B06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02C7C16000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:04:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4QGuiEW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+KcHVGfx4TQ7GeqLxiyIT2kRa9bqeUsL1z7l7Z/8gQ=;
	b=evg0HVSjfCGRmUbxpZZp04hmkRBCj5kbDhomJWKipWVvOME5AHY4INPEL/YxrMAvxtA9HB
	medJPF97Dsjjchsz90+aAH0BoGrOtZ71060e15r2Z+Wkv8sKogw4G1N+ZXj8sae4+4lav7
	eCi9XVSTZvHavPKTyHwh6EgSTW4ct9A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4QGuiEW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497894;
	b=tNRyVAJJPm8qymOnUHUOYdQKKTK1iYy4g7GkQimBfmZRyDtVdtFhNm39tbsbEgwCsLfZjf
	pj/GM9ddhh2SrNgBI+t+lrpyvBmMOnk/mEgPacpvl+wA/5U7PQu547K03RxuQD/8/qVbZb
	J75vqXMVLhWMIQ2vnhCfK8apgGEeCXY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41A8243D6E;
	Wed,  8 Jul 2026 08:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A225D1F000E9;
	Wed,  8 Jul 2026 08:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497893;
	bh=i+KcHVGfx4TQ7GeqLxiyIT2kRa9bqeUsL1z7l7Z/8gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D4QGuiEWjdQ6+wVyqz6pkTXQZi/Pa0pp9z+DKm8Wyzl96jzEvp6Bx+oU2fhETUKWE
	 sMl1hY7yJetN3a3voHlhb04YYYWs/9ZVcP34zze1TcD9pXj7fhBOz/9kiFLcAis7F9
	 ByN+y8fvGHxWXLelMsK3weZIjpa/qmgGpvdYG4yJA3nxA40qPkzhMGxOzVk/TY78rA
	 k+85/G9LbNrLs9ITl1cWuEEKZlnVxC3fATDmQIgM1B2w/3eFTRxmerNPGHpW1o1Tj7
	 89/jOn/87GsoDN/17st5/u7/hh702+2G/v1XNZnvk7oA4Fr0MK4e6d1eGPG2sBa+GW
	 fv4kLCADplgxQ==
Message-ID: <73c67890-0048-40ff-9314-81944a8dfdb8@kernel.org>
Date: Wed, 8 Jul 2026 10:04:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10] mm: fix ASSERT_EXCLUSIVE_BITS by passing
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
References: <20260708021525.627503-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708021525.627503-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 02C7C16000E
X-Stat-Signature: zz7z6z739p9qp3m1uq4t9yxnigasxdxn
X-HE-Tag: 1783497893-876113
X-HE-Meta: U2FsdGVkX1/Uoifu8uRv0pJu94oVm26mfbD/PWJe6Eli0Q64hX+SHLF9lqHpfHCsaOBfSBnQCwyE/nYKivjSKFRfGdQy3Hl4mZfPi2T5JETuU4ICzHSIOH7p3lCywFfc6MwYxvYtnq0tKcM2K0NF5hJoJDlFAAJqleSeD+wnyMCXn8pOWPBv744NjC7BwK2QfC3pf0uX0uWu+xhZkvwSfx+6NxCPp3Bsyh9OoYkvjxkH/vghp+pBxRbDtI9zuparIOKbWdOZ4EiREvsUBrz7IWcQ8Lr1CMNZ6wcv7nt9UkA+vvXeL1gKWgzMkTIW18da74wiNs+T/AplRX/KFqbijNRJWpc7o2pAUGC7MaIhS+y7x9po+HVMdq/EMQdbKFTFC8x30Ju01u+y6zlEOtaWQsibMuxGdgcA1BromGtbNoLAL8X7VcE1Tm0GAZpmIEE1I+tiMcF0yksmWLKpVhjtsUbfYQXqCXqswRsYxHmyOpBNVJiubkxQ/umByvsV0/1//N3BEhO9MPvEp8EmegTib6QXJ/wGT723ypSCB54g5V28bHmYJp3LbXBsTNA3oXyhA/9IWmo8LqSOBE6YEG+UeQgMGimAnIi6omx+mgB8g2uyWmUMdtSyko39RlY0eBr4qmxGFBj2bMwJ1irZ8NEFctWADfLmObO0Eno2Jluc75X1+lvB0IWpu58nWF8jmcHz3iM3glsRtJUpxbWTZmwnaS0jwsS/nIqQdazOHP062SmnUSp6s40bG8qCkGFpx8I28joaEsZP8JCUucXFie91JHS9SXIbtdrJrGdp6BLAffv1sVAJBfyMxX9o8GVidmSZe8mp/YEKd9yf465v2v49RGTe2COKSQtLVyz5U4pvOMuMXz3IhVQH50Wq19byIXXI+dNJmodlEGDc1WYCCGAD680AYFJCoQFLZaCXp/rc2pLVtcxORbnmVhXG3L5SQM7jh+A1aUyDjYrTrxCXcI4
 JEgSLhCd
 O9lA8JpfB2LbVTib8UGKUMDBqmosi3/88Y4WU4ttR3OV7xOoszquyApJdDmTiIZSnTo57fE6RNJ/2wmz8rsUTRE9EC9t/oIzG1WxKaWJjCWqVuGhrYWH7+tmYH+FjB33L3aV6uiiJt94VUvbOlDM3CMInzMGsR9gM6Sh0G8Ls8GgKZSVc3hQ6AASjCwZBHzb5+GV9hUjYVXqWVBz2q/YMFcIUfbZg0vgzre99GvCGpfVYWYy/6kqAgVr7kyOf80GdpwahHk0UfQAtkpw8H7SPDZoYMK+QliyUVHnDKn4+FUqefu3JE06/OHxHucD5kEUna1ojVONWy47t+a0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 04:15, Hui Zhu wrote:
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
> Guard the ASSERT_EXCLUSIVE_BITS() call in memdesc_zonenum() under
> ZONES_WIDTH != 0 to avoid a zero-mask check on configs where the zone
> field is absent.  memdesc_section() needs no such guard, since
> SECTIONS_WIDTH is never 0 wherever SECTION_IN_PAGE_FLAGS is defined.
> Under CONFIG_NUMA=n, memdesc_nid() itself is stubbed to "return 0"
> instead of reading page->flags, since NODES_MASK is 0 and the check
> can never fire; page_to_nid()/folio_nid() now just call memdesc_nid()
> unconditionally and rely on that stub, instead of duplicating the
> CONFIG_NUMA split at each call site.
> 
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
> Changelog:
> v10:
> According to the comments of David, drop the redundant CONFIG_NUMA split
> in page_to_nid()/folio_nid() and remove the SECTIONS_WIDTH != 0 guard
> around ASSERT_EXCLUSIVE_BITS() in memdesc_section().
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
>  include/linux/mm.h                 | 28 ++++++++++++++++++++--------
>  include/linux/mm_inline.h          |  4 ++--
>  include/linux/mmzone.h             | 26 ++++++++++++++------------
>  mm/page_alloc.c                    |  6 +++---
>  mm/slab.h                          |  2 +-
>  mm/sparse.c                        |  2 +-
>  7 files changed, 42 insertions(+), 28 deletions(-)
> 
> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
> index fd74de50b054..c6b4eafaf4cb 100644
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
> index 2101e5205fc0..01683d50b3cd 100644
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
> @@ -2286,22 +2287,32 @@ static inline int page_zone_id(struct page *page)
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
>  }
> +#else
> +static inline int memdesc_nid(const memdesc_flags_t *mdf)
> +{
> +	return 0;
> +}
> +#endif
>  #endif
>  
>  static inline int page_to_nid(const struct page *page)
>  {
> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> +	const struct page *p = PF_POISONED_CHECK(page);
> +
> +	return memdesc_nid(&p->flags);
>  }

Nit: Why not keep it as

return memdesc_nid(&(PF_POISONED_CHECK(page)->flags));

Apart from that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

