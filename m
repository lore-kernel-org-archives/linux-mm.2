Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2115760A261B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CmAX2rVy
Received: by kanga.kvack.org (Postfix)
	id 331426B05B6; Tue, 17 Nov 2026 04:43:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 308B06B05B7; Tue, 17 Nov 2026 04:43:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E696B05B8; Tue, 17 Nov 2026 04:43:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D73506B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63F741A0381
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:43:54 +0000 (UTC)
X-FDA: 85444124388.28.4E4D417
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 939B31A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:43:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CmAX2rVy;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908632;
	b=5JqPaPjGwuwLbEZ1s/SIsaQZdGNTmlhuSvgpay/XZb6urcoVfjmYl2rc1yF5wORtlW3liO
	pp6MdvVeOaGgyBmqttQ1meqb+jGj5I7m/S2yqR5ME8AnQzCB0WjgIG/fadN/WZoHB2fITO
	SBoPflO9KxvVfMCy1tDzB5dLG3fSQoc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CmAX2rVy;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8Uuy//B8VLhVUEAfNen2OqeBRsqmMAJ6ktOCeoG89w=;
	b=AkSj9DuLLlhkntpFmhmHMYaNoDY93zHeIWP8TSa0QKSxDesU9V41C0/7EyO2IKWzshN8wk
	SiJStEfHrt0DmBce9g7VkdNf4mUJ3cL75KD9C7XbR/cSsw4KjQj33vsaapv++L4tkIA3Sx
	tSf7pAE0rEHpTMWtd+vWMCPAIxoAAsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEA264074E;
	Tue, 17 Nov 2026 09:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB931F01819;
	Tue, 17 Nov 2026 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794908631;
	bh=U8Uuy//B8VLhVUEAfNen2OqeBRsqmMAJ6ktOCeoG89w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CmAX2rVyN+dOqJ+NLX4LjVjwKCXCFMSaLbnZ8h1DpHG3wM0ioWSiviVFsIXYifxt+
	 8ANiBw6z296xRRNmUI0ToOpH1ne8GxIXmR4KLvbq/EQW4ykJPj+p6WZFASCClLs1o3
	 ndkIrgA6/jOVyznXW+C0SZ196uf+VlZFxxRuH0TbXXTdVUEmzk0d8m1i14utDslwNI
	 ZneMfO99B2ELp4e6MtULSOIeeRDYu2wTijkM5La2vPbVzxp8DHNLq+Q5N0xJXsZHQX
	 r3vwzKJdg8/qUgQjiyt2FGnvpTwWfKyasBQ8xIHnzzrFvTA57v92bFkKFJoE5VfD8x
	 BPXNNKXde286A==
Message-ID: <558f6c84-84d6-4029-8199-46d4e07c8c0a@kernel.org>
Date: Tue, 17 Nov 2026 10:43:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
 fvdl@google.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <cover.1794907279.git.zhengqi.arch@bytedance.com>
 <295af6601ce79f2c2b3dc4352a3279f0e6ac513e.1794907279.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <295af6601ce79f2c2b3dc4352a3279f0e6ac513e.1794907279.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 939B31A0004
X-Stat-Signature: u1yj1y8d1fgf8k1bwa34be486x7dzo8u
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794908632-86440
X-HE-Meta: U2FsdGVkX1/E1qKrrMYz8MdIZeZ1FK/2vrSY1R4+T2dQWgV5BIoyyTkahaO9hx/ZxFqNKeiAQw0PbPFiDNC3MnVvaL3PjIN90agHgdSVEU1N4x6jhbSNIhmwfizLaQhhUJjh5RdbG9/aK1X4Wu3I8Z5GqD7DgJAqXZlCTrkCu7z1Ssw/jmP5ljAdnss8pM6wZQVPfiEdIHkgjhvOs9kl8qBTnfz1JAWXdhW4BwaJOqooNFo5VCsOdkkgoJ4oKvPqPc0PQEZX0I+NPGl6o6NGR+5+JI9skdKsEHz8/5VRnoU1aoudcwtYYAcvCECix/gNiww9JwP7Taw70q6zkLOj5Nulc7wDjOw+Zhdhq+v183xanWfKcDA5KZLbcrrxs1rhzhYjgO9rFabptfV5fPyiMvNfIWGJEFKe1FUceVe5ISnKws7vSljwpZNOAA1qoN2cSVkTqBXqH5zEjoh+6OJd2WWBlYKqOSC/Y5bqwVsKLRdGJHMYrQ/WH3W1rvjxFlAHBxGvBFq6G5+8hY5G+O30PwGgpZ/B59OwruBhgFbR8kBMNzz2arUBYbJCuEjpfA/6r+xKt4J7apcKfEghrybkPOwSeQrmpT4nUFG9i+nGsPZ5GkuPzzBGd4nXtpPIWCMEunidIucAERHOfrKzP5mBbs+LH219W1eUmqC1v4BO1fX86HuZu7cmlFEo8or7PKBALVVbvZjl/30xgTQZbixxThrR+KC5SkizFmJ2p4pi+v1K+qA8YUjUMCNYhbuKdrbMN4lrtIDbsJ9CfB48S6RlLzU0fDMBSi2hNTrC6q1B1iZhUTMv8Tm0Z6HNXbEYULNTKuGPJJU6EUGFj1LvtHKddbbPOKDSPy27QIl953zt+Ol+gXRsWiLP3IPWVKJBefZZQ1T4VTe62YOOosJlwDjUAG3Le2z+FCwN004DIT0Poaa88ugZZ483u6j87nAT6eJp3QvEB1Cbv1+lZPk6xen
 5K+fL3RT
 j7p6HQ59wZmZdWqVcMslKrcPS1KKPCyYvXAIWuAPdhetPZtEvJTT1HrTIQfU3IQxmG1Am0xCy2fCM8QCg1oyOyQyWHvLzJt0V5juxsRo5VrspsdcJ8UyHhJUI2vz4+RuM7Lj7ZKtD6xQdZIjn15uWt3KJDDlyeBhztQ9iJIPZpvA3RTW3lofQqK8cPZ7Go+yCtMAhlWkpeQSaoyEGJ1USw6yzOGEc/46RXF2Z3npLSpeEehG8OZJ1Zmx88bbW3Pk6uV+DO1YbIZywlJarVlcLS3to+YOxdl4Bx38+1Wyld5CwYm9r5fy+0yRoF5sLQ5aZ0IUY92nKsamBdKM0tchLcAlWvCB5c7BDtyI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 10:33, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Long-term pinning rejects HugeTLB folios explicitly allocated from CMA,
> causing unnecessary migration or pinning failures. These folios already
> own their CMA memory and do not need to be migrated out for future CMA
> allocations.
> 
> Add cma_folio_is_longterm_pinnable() to recognize these allocations
> through HPG_cma. Allow them to be pinned even in ZONE_MOVABLE, since
> memory blocks overlapping boot-time CMA areas cannot be offlined. Ordinary
> movable allocations that borrow CMA memory remain unpinnable.
> 
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Cc: stable@vger.kernel.org
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Reviewed-by: Frank van der Linden <fvdl@google.com>
> ---
>  include/linux/cma.h |  3 +++
>  include/linux/mm.h  |  9 ++++++---
>  mm/cma.c            | 11 +++++++++++
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1a..d829fd0355bae 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -21,6 +21,9 @@
>  #define CMA_MIN_ALIGNMENT_BYTES (PAGE_SIZE * CMA_MIN_ALIGNMENT_PAGES)
>  
>  struct cma;
> +struct folio;
> +
> +bool cma_folio_is_longterm_pinnable(struct folio *folio);
>  
>  extern unsigned long totalcma_pages;
>  extern phys_addr_t cma_get_base(const struct cma *cma);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index daf5c5b567ebc..e71aae8001831 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -38,6 +38,7 @@
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kcsan-checks.h>
> +#include <linux/cma.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -3015,15 +3016,18 @@ static inline bool is_zero_folio(const struct folio *folio)
>  	return is_zero_page(&folio->page);
>  }
>  
> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>  #ifdef CONFIG_MIGRATION
> +/*
> + * MIGRATE_CMA and ZONE_MOVABLE folios cannot normally be long-term pinned.
> + * CMA may allow pinning folios explicitly allocated from its areas.
> + */
>  static inline bool folio_is_longterm_pinnable(struct folio *folio)
>  {
>  #ifdef CONFIG_CMA
>  	int mt = folio_migratetype(folio);
>  
>  	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
> -		return false;
> +		return cma_folio_is_longterm_pinnable(folio);
>  #endif
>  	/* The zero page can be "pinned" but gets special handling. */
>  	if (is_zero_folio(folio))
> @@ -3042,7 +3046,6 @@ static inline bool folio_is_longterm_pinnable(struct folio *folio)
>  
>  	/* Otherwise, non-movable zone folios can be pinned. */
>  	return !folio_is_zone_movable(folio);
> -
>  }
>  #else
>  static inline bool folio_is_longterm_pinnable(struct folio *folio)
> diff --git a/mm/cma.c b/mm/cma.c
> index 9ec1d1fd5dff5..fea5d1015319d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -29,6 +29,7 @@
>  #include <linux/highmem.h>
>  #include <linux/io.h>
>  #include <linux/kmemleak.h>
> +#include <linux/hugetlb.h>
>  #include <trace/events/cma.h>
>  
>  #include "internal.h"
> @@ -38,6 +39,16 @@
>  struct cma cma_areas[MAX_CMA_AREAS];
>  unsigned int cma_area_count;
>  
> +bool cma_folio_is_longterm_pinnable(struct folio *folio)
> +{
> +	/*
> +	 * Explicitly allocated CMA folios own their CMA memory and can be
> +	 * pinned even in ZONE_MOVABLE, as CMA memory cannot be offlined.
> +	 * For now, only HugeTLB tracks these allocations with a folio flag.
> +	 */
> +	return folio_test_hugetlb(folio) && folio_test_hugetlb_cma(folio);
> +}
> +
>  phys_addr_t cma_get_base(const struct cma *cma)
>  {
>  	WARN_ON_ONCE(cma->nranges != 1);

Thanks.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

This can go through Andrew's tree with the other hugetlb stuff.

-- 
Cheers,

David

