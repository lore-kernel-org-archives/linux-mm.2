Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6685DC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBDB6B0095; Wed, 19 Aug 2026 06:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A37A6B009B; Wed, 19 Aug 2026 06:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0EC6B009D; Wed, 19 Aug 2026 06:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08BF76B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:12:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E573C0509
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:12:15 +0000 (UTC)
X-FDA: 85117603830.03.682FBFB
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CA2BC0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:12:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Cz8/57cv";
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZyCbwoE/dYo3yhnqqzr9BQu/EOI+HySwzCYGc3e+CY=;
	b=tTrp6uiAowbQCUOBQ1SjTM/mPhlS3PMD89xBvHPbLmLnLFf829q0zDYEUvcGQzzqIz6YjN
	V81jWTef8tLqiI2cFx/S5VaPCXaY2NmSLrsn8j1GcIpB7kUAIh0U3VUUcfuYOf4wc4N9Mj
	2DnX7j2sKXuJJvn/R0WT7vdHdfX5B3U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Cz8/57cv";
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787134332;
	b=gHyN3Uq+VEX6uo7KCFUelB4BrPb1DRin0Lz8taxHlxcgdUYWr/uu+xbHb0xvS5p683CB1x
	Np6wLgNtzS/ZNARpUaRrC3jfF7GuuonvwGoUtRWQh79nHEt2i+Eh1BGANEllrcp+LVjbsJ
	JjBPY6s9ATAsj3lleYDLW/CqWB0JzrE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9UOPR3VqdNQVe5zByqIvc6J7eUFOw5VtzuU3+toi5KU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134327; v=1; x=1787739127;
 b=Cz8/57cvrVKqUtUFKYps+u4PLFPlv1Qf44ZNDqsjRMZWKl3Fm+fwG0KMyYypNIVy8ZxxyBLL
 jcrxT/4LCQ5D894yucX5MENvcQU17c79AuVIVlC0aGXPgMUWyK18bvlHfALkATzB6mGeOBR/aK1
 wsBlAzs2PV1aCF0vBr1994f0=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 383ad5f4fd629cc5;
	Wed, 19 Aug 2026 10:12:07 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 18:12:03 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
Message-ID: <aoWBcz4sZH1iFzn5@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
X-Stat-Signature: as1apk58q3fknqnx7g3ehqyx31gjx8t1
X-Rspamd-Queue-Id: 0CA2BC0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787134331-931831
X-HE-Meta: U2FsdGVkX1/oAmTwBVvyozE3S6aRelgsKm07BR7JPRDVP1+r4tM83DZRKATu1jQZbBKt0tFoZs8IXKwluNDPIMCsjFEb/idPa4N1hUrj9GVWKmdjeyY13O8Mg2kQ+EkEcYMVCz0rPYz1MlYMc2KvxrUuseHU2OscsibbATEgHr0tziauXwrF/xHcMIn0oAm7QYC+wiXGNdPBV0GMJYUerWgwoGxh0Qdyyhv7rD7OsfYl3jIA+UmdUKe5BkG73PyjSLw6ARwADXbfWQG6qerDebS+CHWUIbBeNb+Ic4c6wCL1YXxgtAPl9Ok4o76QBne9LEV2w4dTUvVL1G+zBI5AwOWoe5icK8A7dP/Y9GtjWdv1SpkqpC/NJoHa/gzutZct/kEe2XIjwg8L/AaLiC82lMMAYEZTCmzCOd1fjpvojKzeYFR4QHYx9IEg0a5CpPV9zb04cBadSM1QEHqDTxMdVF9M7jNqpsAeT4BeQlT63tMxg6PRWcFzYGp9MttYjamc47/OECIQ8CanayXzGc80Tfi0zauqXOY189cx4WfNroiwK35rqBWd1mFbwWJDRSOVyM62gt0AszvzFdxEMJORP3RCB6IhRIPEhn2JlFPQGU0ODzCnZBc0at+NomKcU0dNd+AickNEsL6hTRdZW6Jh3fyiJLyJYgRvKohwxSWIT3OPu8ETnju/DFxYo/nDvz5bheFlySfja1dUNIK3IvNFvuyxETfm8aSeglSv5m8AZB1q0Pnlj8RKmw0Btf1s1IlgZ0pZQrKOwu9hmHILENKyVNApJ3CFqj2eFE8HEsHKhNyRGJpdt/HvW1G68ttdB/cON2k0mp+vsr89ZRnKeymxu0cztTsRTZ8oHssyGF2OcYtPMJcO8eahD0l7l6pIILi6YUyg1DPGY62qi8aVtv+QuPoYDBxcwUFhIKKc3WimjxWu85iemXTnMiuDExbh0c5yvJBXqMOz9vNMQjl4Av1
 KdrIH5EX
 Y87mBV++WlGNwAsAh4XRx3MCVhm3IC8PZvEbQAcInjtCDu2ACaLEJw7eY8rc+IPa6Rqk3cMVH0XbSHEXdZv8cpGNAqSDTD/eceXyLnlBKoQMZDIod18nF5Cc2jSyuKagdwox+N+b1ZoVdoWJdnGKo9QsLNjYZaURneapP6wtsvlolesFFM+id6a41/aI/wUdShKk9dA1Yk0fFpgX5FQSU1fOgYDR2af5M7zR22o0X6O/x7OclqVoa1CcxeZd16nfIzJ0c9yePV7tuDVdR8bFVVzqj8BpNU2JignONY0T3tEghTXSBL+TpNYA9kV1dS48etjLRSwhL5QNlUa8CcO8dhC7e29EHtsWNliGbGPZD4hak3CPZZIcYO60eniU9RRYQ9d56ZYSOMFRqmDdqsinQMIlcSO6cqlF8+9t8uP2TYfifYC8ph2oJ+j8kTFad6vVS+bopdjgsSdurRb6D4s9/y7ZSUJBVdnELhPDZ+ibPKqnsbHi1cr0eJkxs9+pFte4azu0X/7YKCtDSetk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately, while
> folio_migrate_refs() copies the rest of the reference state. Make
> folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
> the MGLRU refs counter, in both LRU implementations, and drop the
> open-coded copy so the reference state is transferred in one place.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 16 +++++++++++++---
>  mm/migrate.c              |  4 ++--
>  2 files changed, 15 insertions(+), 5 deletions(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 93bf3fa221f8..df62daaa2ee7 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return true;
>  }
>  
> +/**
> + * folio_migrate_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *
> + * Transfer the reference state to @new during migration: the MGLRU
> + * refs count, including PG_referenced, or just PG_referenced for the
> + * active/inactive LRU.
> + */
>  static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
> -	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
> -
> -	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
> +	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
> +	folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>  #else /* !CONFIG_LRU_GEN */
>  
> @@ -401,6 +409,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  
>  static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
> +	if (folio_test_referenced(old))
> +		folio_set_referenced(new);
>  }
>  #endif /* CONFIG_LRU_GEN */
>  
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..82307332711f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -776,8 +776,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  {
>  	int cpupid;
>  
> -	if (folio_test_referenced(folio))
> -		folio_set_referenced(newfolio);
>  	if (folio_test_uptodate(folio))
>  		folio_mark_uptodate(newfolio);
>  	if (folio_test_clear_active(folio)) {
> @@ -807,7 +805,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  	if (folio_test_idle(folio))
>  		folio_set_idle(newfolio);
>  
> +	/* Copy the reference state, including PG_referenced */
>  	folio_migrate_refs(newfolio, folio);
> +
>  	/*
>  	 * Copy NUMA information to the new page, to prevent over-eager
>  	 * future migrations of this same page.
> 
> -- 
> 2.55.0
> 
> 

