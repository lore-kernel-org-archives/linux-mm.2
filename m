Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33621CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 14:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CE56B008C; Tue,  2 Jun 2026 10:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D696B0092; Tue,  2 Jun 2026 10:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442D86B0093; Tue,  2 Jun 2026 10:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A2E6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:46:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF372A091E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:46:42 +0000 (UTC)
X-FDA: 84835249044.29.FB9027E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CACE1C000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:46:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM1g+JEX;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780411601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NFd70hWGL8P5zEehk7GPp+B6cZq/FHBhT/mSt5ArDw=;
	b=mD9199muemNFcn3t/LouDm/Lin5QUXSSzmvxQnLPh9K7fSGXGCvJs7Fu2kGdUGXea8w7Cy
	Y90RaIKPioZ7sxwGePkQ4AbKycU8DThEH2+Qc+RYso6+tVonSv1HEmYkfxjmuHJf4a059A
	/nrqrnej0Svc12tcyhI4u3ebM1Imef8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mM1g+JEX;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780411601;
	b=fSmB11VpOFBfkBObbVHn2atDQDngVm2owfk/95hEm0d02rcmdmJ6dU5Y9GDmB0Q8PgjpGB
	Pv0Kro4/rUpeDm8vS6WA90ZhYxvxnnPQyz+mwh6NnFcD3h04wT4LnJvbEPh0guvnjFfAY8
	fBapDASMcJOm5rFbYplkRRzsj5JoEw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B039E6008A;
	Tue,  2 Jun 2026 14:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3811F00893;
	Tue,  2 Jun 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780411600;
	bh=4NFd70hWGL8P5zEehk7GPp+B6cZq/FHBhT/mSt5ArDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mM1g+JEXbWh/t59o/u4O+aWUWSA2HDFoJg1p2byPHhxS/579iO/AQguWyMy9rgWw3
	 GAbrtIjzEw56ZYFRk6rXc9IVIK+2G1UtX8+ICCujPIHbKOcGccNYDwd8bDct6tHwyQ
	 RFFWwOGRn8YkjljKH2HbwXvhLhQuK7ngENeBSos+e/F0MGOtueJji71Zu1YMS71HiV
	 NKFndrSaeiL9msFB56weG0VNs/tHWybudHZut6ZOOxGrILBaHsSjhKZq/MZzDJTKYT
	 cRnXo5pZwp5JXjwrlNFfBSbLduf+hrV4qETakfA6m00qZFNRgpvdtKCQnTLjUPQiGS
	 OA+BymabXUfRA==
Date: Tue, 2 Jun 2026 17:46:31 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v3 19/19] mm/mm_init: Fold __init_page_from_nid() into
 __init_deferred_page()
Message-ID: <ah7sx7eh1JQctWYO@kernel.org>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-20-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602101039.1867613-20-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 4CACE1C000B
X-Stat-Signature: xkw14jfy6xtc6yds39mxdg1kjs8gimxa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780411601-885448
X-HE-Meta: U2FsdGVkX18z9Y7IhMMQcKAnMmxiRZQl3sEwaNcW38kHNn7liYhUdYVWPSQVEXjUGqZzJrk9wnmnzpvcgLuyK4adsh2nOVhn8bttyk7x7QFJdYblIGhZOijfwQSIA12OvRmCDovx5RvxdqGgPuz/HytmhACyHm5m6asB3OdeH3/whzV4XZcHhaUSYtaqYU/odHEIOR1nzas+FC4XQLpVFnPAZkbkFutAnCz77cTn0Jin3QCzJnD6s9F5tp82kask+vR2HS80Tc8ALy0X55TURQqDh90WqFf7l77tAe6+ihSiN6Mo4FxB7in6DQlfXmCL7RpVeZBVZ8bqrvlWvecKsNPoyKdpCA9/6ncQFow5VbD2jNdLDVl2f1nM2/DUwMdreiMZVrGmxKIiXRDSD8n5MUo2+zOk30OJkr9lvKp1f3YjhcSCLvs7ahdn/7nXZlm73s+MgOCGtcEK2wrP6ryRCF9R75ibjzT1zr2SESV6x/b/jd6dMtirU4+srZZu2hpdTtYpmfnp6WfowZrneeq5UsxrohIT9r7iPK6JSKJlRzwF0OlwuTE6qRK/Tg4MSa8SxFLW+6UV+LeNhDbamRu59XPwOFlsOrUBpGMSXksZYMJRV14kpoCDOxJwLNlvp53IXgnKoKi9U3SemueIF1EKXBZ1sN8UQoeUP4ZKf7KXEGwRmVF6LkiNrsqbU2hZbMBwt2NfKsijo5JEJX5JcPIB+xT9Qt/j3Id2qsZ5iAoAsQywUegsPqOOsqMlRrjM4rSAPnAFypu4BmjjQS1AoRrxaAh75omwcTkoaURalNgVWnFnML/wSZJQcEOgWTnRhGnRLkdPVNmZuzDazdKEatIuwVsHIoh/dRIlBdGqlxFcgCxk0s+8OkELKx1n9cW+eD5m2UvIT83heJLRZf//9wJIZ8Jfwh9Mn1HOmh88Vx7MLdQ2cXW4JOdbdzW/YDwUzvXdI8ePfitfikdHGdjj/15
 jlzRM39q
 GP8M+O42oTWvnWgTX9owkaNuaF8Kcz/PLM6DfgRBLxZTxE6R2R/jTX2Zg0q/nHGkmRpCNU0PjwAqX6pt++vieAS7ERCJ6gi7dtF0cwvCzRIjo3E0giIYw++D4YbezywBahPvPolqyFYjnX+wJNwCKTuo75F1+g64zm3SfTXuZIT+LvSwgeZ+TyonvNA3NLJT/9S8yrcgpaACqz7ZcjzKwHVBvBbFxlgA7Uf8YbGLqwrXCfXnTx7ER886M9LzNhszxIDe7rV/eCx2PiDfVqLfVXbCuSI8EdhqTZpwASzQ9yYvf8Z9nrVVavYKcSUZz6r3HMO4OZZXKVfZi2vs4GrX19RXItSTePeGyC9ElmhUeyQuTsNlfnR8Yyacw/UM4GohOgglsdtGoPmra0zuJGReo+CVq8+522l8NrEpMs+lZlo2Ps0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 06:10:39PM +0800, Muchun Song wrote:
> __init_page_from_nid() no longer has external users and is only used
> locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.
> 
> Fold it into its sole caller __init_deferred_page() and remove the
> separate helper declaration.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2->v3:
> - fold __init_page_from_nid() into __init_deferred_page() since it
>   only has a single caller (suggested by Mike Rapoport)
> ---
>  mm/internal.h |  1 -
>  mm/mm_init.c  | 44 ++++++++++++++++++--------------------------
>  2 files changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 8497673d0ac3..b33fc87e4555 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1760,7 +1760,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
>  
>  void __meminit __init_single_page(struct page *page, unsigned long pfn,
>  				unsigned long zone, int nid);
> -void __meminit __init_page_from_nid(unsigned long pfn, int nid);
>  
>  /* shrinker related functions */
>  unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 41b83dd18c01..f1bbf3b9a321 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -688,31 +688,6 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
>  }
>  #endif
>  
> -/*
> - * Initialize a reserved page unconditionally, finding its zone first.
> - */
> -void __meminit __init_page_from_nid(unsigned long pfn, int nid)
> -{
> -	pg_data_t *pgdat;
> -	int zid;
> -
> -	pgdat = NODE_DATA(nid);
> -
> -	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> -		struct zone *zone = &pgdat->node_zones[zid];
> -
> -		if (zone_spans_pfn(zone, pfn))
> -			break;
> -	}
> -	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
> -
> -	if (pageblock_aligned(pfn)) {
> -		enum migratetype mt =
> -			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
> -		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
> -	}
> -}
> -
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
>  {
> @@ -771,10 +746,27 @@ defer_init(int nid, unsigned long pfn, unsigned long end_pfn)
>  
>  static void __meminit __init_deferred_page(unsigned long pfn, int nid)
>  {
> +	pg_data_t *pgdat;
> +	int zid;
> +
>  	if (early_page_initialised(pfn, nid))
>  		return;
>  
> -	__init_page_from_nid(pfn, nid);
> +	pgdat = NODE_DATA(nid);

Nit: we can initialize pgdat at declaration line, other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


> +
> +	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> +		struct zone *zone = &pgdat->node_zones[zid];
> +
> +		if (zone_spans_pfn(zone, pfn))
> +			break;
> +	}
> +	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
> +
> +	if (pageblock_aligned(pfn)) {
> +		enum migratetype mt =
> +			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
> +		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
> +	}
>  }
>  #else
>  static inline void pgdat_set_deferred_range(pg_data_t *pgdat) {}
> -- 
> 2.54.0
> 
> 

-- 
Sincerely yours,
Mike.

