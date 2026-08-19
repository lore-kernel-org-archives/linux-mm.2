Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401C8C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31626B0092; Wed, 19 Aug 2026 05:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2376B0098; Wed, 19 Aug 2026 05:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7906B009B; Wed, 19 Aug 2026 05:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93EE46B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:03:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E769BA04BB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:03:15 +0000 (UTC)
X-FDA: 85117429950.29.73144C8
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C0E518000E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:03:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VN3rR5hI;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787130193;
	b=sscQKbpZOOEAV/KV42BqRbcT44ZOaihc+5qUjo+ZG/akKaX/xxhnBkDwFQtVVph/GhXmPK
	6MJZJFMMWcWW0/miP4X4pueKvkEZPM9zsXd7W0Qf4CZtQchHUegyjmqbVWWZI4v6XcV3j0
	Y0IBVV97Uf/Z27zD3324+Ii6ULpdubI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VN3rR5hI;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787130193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mD/Cl50XWzys0id4X5RVAR1gGagtP2IYMFAaW4ejKq4=;
	b=DOcbLqFcQLaKaFUVOPDYr2+WRwZI8H9lyBY0RBisK9AqGKhb9ciA4NsTZ9Xp66rgkHSD/M
	L7yb470v6bKSB2is1X6vgLDstbJ262k3aLVUaivMMvVdZTdN0cT/OzE+OwO1qHbDLXzXSC
	Y8TmGK196VsgUVvdg18Zs3S9fDVlwa4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787130187; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mD/Cl50XWzys0id4X5RVAR1gGagtP2IYMFAaW4ejKq4=;
	b=VN3rR5hIe2U2m+praqeDru6HfciQ+HdGqhDfWO/Rm+dz4aC7fACGfbM60HJzEOSiaQdGBpMexIJyglKmNxgGkkUDQsqrC7cRCdiQ3V7lF+8bjFwQRAij/RRTzdsKqN/X6UW+TecwEDkLndibAornQEYXBywSjn0J/4OXImofnVs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9GF3bp_1787130184;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GF3bp_1787130184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:03:05 +0800
Message-ID: <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:03:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C0E518000E
X-Stat-Signature: zuq7djs5m4fgzg5rbt6n3bj68cr3ojb5
X-HE-Tag: 1787130191-429799
X-HE-Meta: U2FsdGVkX19BMH88lmlNLysH2h6SgZzkXFK3kvxfmaohGPP5tY9+UGiVdhiwuObmH4JmTLAAnDGe7DhloRoh3rD1rY1Zz0l/8PWxPu/SFzYIhtRwqUaKbk8u2jhie+rzoE5DV5z+JE6kDlGEErZZwQdbD9cdr0JH064Kt0uBpKSzGW64DbPnMsGhmkZtwyFjUEjCqJWiVxcY9httpN9kvQD0s5QSxDlo9FYcKzSvGey1RpIt+fE4JT3c7takdAvRXbYM96sWf+20SWCGrD3c+SDm8M6i/QEvoy2+4wd+3KKU1zhg81vUyZpGfp7SIabX5dmoi1YxnPRFgWdbiNwaWIxo2SEYclR1zUO2XITNJt+49fKSLayczku+4jC+1MZ9sy5OAKD8HAE5fRRBBUUMu0CGI98CmkAW7gUbyt+3zqMJQJTHIo6YBH5w7ZHx82rk8gW0d97Ryd+w8TdXbvlpq2xeuCDEwq63Mdqtn5TaL5MOYH89ODdkhemZY8BIRkt41FOBO2kazC7qBsFx8/3UDi0DD2pyfm9NQfGH+dCU5d/sfioAiPR2+xk6euLE1RpuXrEMphic434qpm0GJsvvRK/qCMAXsd1FQind+Hv8nkgpO4DD2JmhD42Ka9KlytQeQk83Sdxosk+yyWNLhc+CRS+MQBkGQp9VIL6r+Lfe9vjCLgbPEfRnJtEr4B2chcn+Bp0MpuYvVu3LQ7VawIJXYnd57OdmA7udPNQGfUK+Xb8//0rq1oATODl+jQ9T3GWxMsBhrTgEC5oNto/lIydBZzI9GDlsPzmSpnUB/yu7Pm3bpNAehIJD17oCmnCIjyPmXDS8rKmuu/ZfbxkzV8WxHtWPlagqPLNSmK5sNj/7VD1MvIcv+MaLIXT8yBPOtzy2+UdlXhnujOCcEZw32B0AkXw9vz33P+MI92Bv+AF43BFAgHg4W4X7Z0Ghbxp3pNE1EoZXy28oTb0/ERCzThq
 Yw2N3rdK
 UE2Bjy/Bo3XVafjlvX8lLrtsNPB2dsoKXGk+Y1Y38QMqRbM580xuaSx1hhgSBrSyzKeKuft+JLCrIJ64X0I//zsT3ogPrWDp9yjzYa/He4KDNXikLSUkMNCfyIq9vDd9hea2jn1OK4pUi+ucFXyAr0SvobzL96W+KewtyQryDWsnN195xADINJJHzAkVw25aoRn2ImZTUnpDGEZw5hQQ0eQH/daBghfwxPKKeQKyU45T+QPiYm7OhR7dG2r96s923VawHqaEBkUYrbvWADMKhOaGYsPnsNG5LO9VZQbpGDAEXO4mWo6pSPXyvPI+xQxT/gaUymIHBuyQu0MO2iD2qDLzdqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting folio's refs and gen info, make the code easier to debug and
> understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Thanks for the cleanups. One comment below.

>   include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
>   include/linux/mmzone.h    |  2 ++
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++----------------
>   4 files changed, 117 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..93bf3fa221f8 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,43 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
> + * flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +	gen -= 1;
> +	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);
> +	return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and LRU_GEN_MAX, inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX || gen < 0);
> +	BUILD_BUG_ON((LRU_GEN_MAX + 1) != MAX_NR_GENS);
> +
> +	*flags &= ~LRU_GEN_MASK;
> +	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
> +}
>   
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
>   	if (!(flags & BIT(PG_referenced)))
>   		return 0;
>   	/*
> @@ -155,18 +188,47 @@ static inline int folio_lru_refs(const struct folio *folio)
>   	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>   }
>   
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
> +{
> +	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
> +
> +	*flags &= ~LRU_REFS_FLAGS;
> +	if (!refs)
> +		return;
> +	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
> +}
> +
> +static inline int folio_lru_refs(const struct folio *folio)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +
> +	do {
> +		new_flags = old_flags;
> +		lru_refs_set_flags(&new_flags, refs);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}
>   
> -	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>   }
>   
>   static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
>   {
>   	unsigned long max_seq = lruvec->lrugen.max_seq;
>   
> -	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX);
>   
>   	/* see the comment on MIN_NR_GENS */
>   	return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1);
> @@ -270,7 +332,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> -	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> +	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
>   
>   	lru_gen_update_size(lruvec, folio, -1, gen);
>   	/* for folio_rotate_reclaimable() */
> @@ -295,7 +357,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   	/* for folio_migrate_flags() */
>   	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> -	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
>   	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>   
>   	lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +401,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>   {
> -
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..32d9354a754f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -496,7 +496,9 @@ enum lruvec_flags {
>   #ifndef __GENERATING_BOUNDS_H
>   
>   #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
> +#define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)

There are still many places using MAX_NR_GENS to compare gen counters, 
so I'm concerned that introducing a new macro would make the use of the 
max gen counter even more confusing.

