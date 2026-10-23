Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB98606A324
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=J5kBX/r4
Received: by kanga.kvack.org (Postfix)
	id 1C26C6B0AF6; Fri, 23 Oct 2026 02:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135096B0AF8; Fri, 23 Oct 2026 02:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023846B0AF9; Fri, 23 Oct 2026 02:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFE9E6B0AF6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:35:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CA35140363
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:35:46 +0000 (UTC)
X-FDA: 85352930292.19.C8AE8B1
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2FED40002
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:35:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J5kBX/r4";
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737344;
	b=5AFlr5WRB2qodLAFg7K4xk03NIZKzjg8JldLJujGTV32RpXlp3sWSTtLqwnOaNl/+A7J+9
	OoWnrgTUAWbSG/4B/wYxQzNL3IHDtb4A4edSB0AVJM5eF6JvAfsTvy2ItTpXRYdJZBFTDj
	mCHiU5sZv0fCXxOsDMCUERdHt+s9fiM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J5kBX/r4";
	spf=pass (imf11.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7Uc7KLujk3CY+SPJTo1fA6oz5Z7g3SGHtp1atdmdyk=;
	b=uFGx+GEuOnOs6XoCjFyT8E15LrEfZY14o/sHxOcW42TSVRaJsLfH+kYuPsghy4Lk2nkaF+
	5tv7NLtwwIAu65jDjktAxxGKVCClgoaYvB/XJ9ZEQ87kCH8h2zdtWPy0IIBj+IktZniaVX
	pG5R4OuAr2wdOaPdm6kqmQI4ePZYA4k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L+/w4l1UaI8JhzbDpxHi/t0Cn5jVCxDZQ2Ylg930CxU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792737341; v=1; x=1793342141;
 b=J5kBX/r4DfX3CaH7m8Ta/UEEfgR86CNL+T14QJi2gTgT72+IgNYcfhTkG/oD646EqHyUGEBO
 qs3lSWf7byhNkp1+EwFRAf4KW/orzsYBNSYhc4FP3yGmdgxYe7UlMl6hgAgLpfO2kQBrRbPTLAJ
 KNnaAMolnOUYynhvlhUViJQs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bb2e9cd96eec740b;
	Fri, 23 Oct 2026 06:35:37 +0000
X-Mizu-Trace-ID: bb2e9cd96eec740b
X-Migadu-Flow: FLOW_OUT
Message-ID: <b37a33e2-7dfb-4401-847e-919f0bd61271@linux.dev>
Date: Fri, 23 Oct 2026 14:35:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm: hugetlb: track CMA reservations by pool
To: Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <29b35f7221c30f1dfa320a933f6095f37b612a37.1792651104.git.zhengqi.arch@bytedance.com>
 <b5745b31-adec-4158-bba4-2c21dbfe2566@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <b5745b31-adec-4158-bba4-2c21dbfe2566@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A2FED40002
X-Stat-Signature: t8ewrmiqrzgbu41jm3po51no8m6ihxxo
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792737343-791301
X-HE-Meta: U2FsdGVkX19MiDSL6MI+NyuYfTouM/y84fHNg/2UOCFbG3t2Vc6fZnWmvgxthB/nsYJf/QOWdCXgZOCOVOuZkvjdD44Msu5f6BpVarSW/E3RSiQn5vqZjB5e4l7nYs4Dvcja3hU0WIVPfABVRMwxdu3E1+EvPmuVy6pW8cWxkhA4p/5FeHZ04Lpr/RHNjH7HvxUAltgni+6/u4MXzDKfhWzPl+f66gq/orkXKqe+EeR3pzXe4J7awFGk7j4MUOSPrI0IAIIDJJcuUWUvCSrT99bwNPdU/P66Q/xutKZl6TqQ2ZiLHZRxFx2u1+mYolUevEt9sn9VM2OMxvDupqObDCUQOJa1rONAlMD3Wi4m2sPc72RODFsYozCykXRZ6GZ/LN5lULJ8BMZFjTCQi1FmA4iV7Z30y55CZEpZlwMidgl7E7GT15OMgYJzTWtLxzcfvKG4GY0RySlymJJPHI4in/2lH3M5kFDdGDf9oMnimYESucw+bbZp1IWPnnrVmTToXcBUvtapd9Fvfpiq16b7Gya0ptckOsJlufQxmSNNjlIEjbDGHg08Cl8Lwlw3w01rIrntITFGvmYHtbqpdINEeKoZi5IZOQmtQJMtsYmnKUA+v+jC4DdpsQa5N7UIjW5Wm6Mzg/rdbY12Bi4/5pzPkFjglmw7HafkpLH0iAsyFEY6b50fxovX1+U+cyqG43Ta3JNKuobqzCED80w9HeAbvb2c5QcSTRshA3leF/OIG5ExVcCF7SGGSKT7IQL6CzB+Bs5YMwId+Gz1T2NeLo+c2yCgzrrGGs4xfae4AxyVhnjT//ncReBMMx2wgVBL+F51FwZIVUfwoyexlDzn/LwNGXNGhEw0xDolb7wZQfZqnewi33e3nBMw2v9G5wdEaQApu92JJPOy4NPuvoHkh5vUeC5ZOd3s1PJrE2ZNVNMu6mkOGKWsb1/hyUuz6niEboXXFmm3Egn8U1pre16AbJY
 9+L2faX2
 WpL9PA56RGj9d5xDX2elQMVTIGJQRfqbUWfWGxGjamxX0ltKW+OjpZuUAk36/mY1hDeqBetn+3FlsRZgLbHsXE0VSjfFGMaquZXohRvad/ZaUJgxB2y2XrHO45m9pLFbCNEI/pX5SyYeh8RpptLSyiBmDxFzbdGCGg8jUlmH6eE8UDZZqAT6kWoSwcmxcwF3i16ajZTPFjqCvJhNJkPTD7NNCRKiNoP65zPs3pn6KxKl3mrBHQ0cZg8+upbjm+K6KPDM1fhdP4wCM8cq9n0xjMdm0hyOldYqvkBHDkI2OTsftP15xxOB75EgKyHgmpp/deuwUMRNRqnw5yF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

On 10/22/26 7:21 PM, Muchun Song wrote:
> 
> 
> On 2026/10/22 15:31, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Introduce fixed default and PMD pool slots in preparation for PMD-sized
>> HugeTLB CMA support. Continue accepting only the architecture's existing
>> CMA page size and keep all gigantic sizes sharing the default pool.
>> PMD-sized pool support will be added in a subsequent patch.
>>
>> Select the pool for allocation, CMA-only checks and boot-time accounting.
>> Release folios through the CMA area that owns their physical memory,
>> including after demotion.
>>
>> Record each pool's successfully reserved capacity and remove
>> hugetlb_cma_validate_params(), since the per-pool CMA-only check handles
>> missing or empty reservations.
>>
>> Assisted-by: LLM
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/hugetlb.c     |   6 +-
>>   mm/hugetlb_cma.c | 154 ++++++++++++++++++++++++++++++++---------------
>>   mm/hugetlb_cma.h |  11 ++--
>>   3 files changed, 112 insertions(+), 59 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index b37d7d0db7fc9..6b08074d11f52 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1368,7 +1368,7 @@ static struct folio 
>> *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>>       if (folio)
>>           return folio;
>> -    if (hugetlb_cma_exclusive_alloc())
>> +    if (hugetlb_cma_exclusive_alloc(order))
>>           return NULL;
>>       folio = (struct folio *)alloc_contig_frozen_pages(1 << order, 
>> gfp_mask,
>> @@ -3635,7 +3635,7 @@ static void __init 
>> hugetlb_hstate_alloc_pages(struct hstate *h)
>>        * Skip gigantic hugepages allocation if early CMA
>>        * reservations are not available.
>>        */
>> -    if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
>> +    if (hstate_is_gigantic(h) && hugetlb_cma_size(h) &&
>>           !hugetlb_early_cma(h)) {
>>           pr_warn_once("hugetlb_cma is enabled, skip boot time 
>> allocation\n");
>>           return;
>> @@ -4338,8 +4338,6 @@ static __init void hugetlb_parse_params(void)
>>           hcp->setup(hcp->val);
>>       }
>> -
>> -    hugetlb_cma_validate_params();
>>   }
>>   /*
>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
>> index 4f27eb242dc3b..c279c3f548705 100644
>> --- a/mm/hugetlb_cma.c
>> +++ b/mm/hugetlb_cma.c
>> @@ -19,6 +19,7 @@
>>   struct hugetlb_cma_pool {
>>       struct cma *cma[MAX_NUMNODES];
>>       unsigned long size;
>> +    unsigned int order;
>>   };
>>   struct hugetlb_cma_config {
>> @@ -27,14 +28,34 @@ struct hugetlb_cma_config {
>>       unsigned int percent_in_node[MAX_NUMNODES];
>>   };
>> -static struct hugetlb_cma_pool hugetlb_cma __ro_after_init;
>> -static struct hugetlb_cma_config hugetlb_cma_config __initdata;
>> +enum {
>> +    HUGETLB_CMA_DEFAULT,
>> +    HUGETLB_CMA_PMD,
>> +    HUGETLB_CMA_POOLS,
>> +};
> 
> Since there are exactly two pool roles, could we make that explicit with
> a typed enum, for example:
> 
>        enum hugetlb_cma_pool_id {
>              HUGETLB_CMA_POOL_DEFAULT,
>              HUGETLB_CMA_POOL_PMD,
>              HUGETLB_CMA_NR_POOLS,
>        };
> 
> and name the array hugetlb_cma_pools[]?

Make sense, will do.

> 
>> +
>> +static struct hugetlb_cma_pool hugetlb_cma[HUGETLB_CMA_POOLS] 
>> __ro_after_init;
>> +static struct hugetlb_cma_config 
>> hugetlb_cma_config[HUGETLB_CMA_POOLS] __initdata;
>>   static bool hugetlb_cma_only __ro_after_init;
>>   static char hugetlb_cma_cmdline[COMMAND_LINE_SIZE] __initdata;
>>   static unsigned int hugetlb_cma_cmdline_len __initdata;
>> +static struct hugetlb_cma_pool *hugetlb_cma_pool(unsigned int order)
> 
> How about order_to_cma_pool()?

will do.

> 
>> +{
>> +    struct hugetlb_cma_pool *pmd_pool = &hugetlb_cma[HUGETLB_CMA_PMD];
>> +
>> +    if (order == PMD_SHIFT - PAGE_SHIFT && pmd_pool->size)
> 
> PMD_ORDER is better.

OK.

> 
> There's another question here: why does PMD-based page allocation
> need to check the pool->size, but gigantic pages don't?

The PMD size pool needs to be checked here. The check for gigantic pool,
is deferred to the caller.

> 
>> +        return pmd_pool;
>> +
>> +    /* Preserve the default pool's use by gigantic sizes. */
>> +    if (order_is_gigantic(order))
>> +        return &hugetlb_cma[HUGETLB_CMA_DEFAULT];
> 
> If we also check size for gigantic pages here, would the code be simpler
> that way for callers?

Yes, will do.

> 
>> +
>> +    return NULL;
>> +}
>> +
>>   #ifdef CONFIG_NUMA
>>   static phys_addr_t __init memblock_node_memory_size(int nid)
>>   {
>> @@ -56,10 +77,16 @@ static phys_addr_t __init 
>> memblock_node_memory_size(int nid)
>>   void hugetlb_cma_free_frozen_folio(struct folio *folio)
>>   {
>> -    struct hugetlb_cma_pool *pool = &hugetlb_cma;
>> +    unsigned int i;
>> +    int nid = folio_nid(folio);
>> +    unsigned long nr_pages = folio_nr_pages(folio);
>> +
> 
> Please add a short comment here explaining why all pools must be searched:
> after demotion, the folio order does not identify the CMA pool that 
> originally
> owns the physical range.

How about the following comment:

      /*
       * Demotion can change the folio order, so search all pools for the
       * CMA area that owns the physical range.
       */

Thanks,
Qi

> 
> Thanks,
> Muchun
> 
>> +    for (i = 0; i < HUGETLB_CMA_POOLS; i++) {
>> +        if (cma_release_frozen(hugetlb_cma[i].cma[nid], &folio->page, 
>> nr_pages))
>> +            return;
>> +    }
>> -    WARN_ON_ONCE(!cma_release_frozen(pool->cma[folio_nid(folio)],
>> -                     &folio->page, folio_nr_pages(folio)));
>> +    WARN_ON_ONCE(1);
>>   }
>>   struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>> @@ -70,9 +97,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
>> order, gfp_t gfp_mask,
>>       struct page *page = NULL;
>>       const nodemask_t *nmask;
>>       unsigned int cpuset_mems_cookie;
>> -    struct hugetlb_cma_pool *pool = &hugetlb_cma;
>> +    struct hugetlb_cma_pool *pool = hugetlb_cma_pool(order);
>> -    if (!pool->size)
>> +    if (!pool || !pool->size)
>>           return NULL;
>>   retry_cpuset:
>> @@ -111,7 +138,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int 
>> order, gfp_t gfp_mask,
>>   void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, 
>> bool node_exact)
>>   {
>> -    struct hugetlb_cma_pool *pool = &hugetlb_cma;
>> +    struct hugetlb_cma_pool *pool = 
>> hugetlb_cma_pool(huge_page_order(h));
>>       struct cma *cma;
>>       void *m;
>>       int node;
>> @@ -135,15 +162,16 @@ void * __init hugetlb_cma_alloc_bootmem(struct 
>> hstate *h, int nid, bool node_exa
>>   static int __init hugetlb_cma_parse(char *p)
>>   {
>> -    struct hugetlb_cma_pool *pool = &hugetlb_cma;
>> -    struct hugetlb_cma_config *config = &hugetlb_cma_config;
>> +    struct hugetlb_cma_pool *pool;
>> +    struct hugetlb_cma_config *config;
>> +    unsigned int order = hugetlb_cma[HUGETLB_CMA_DEFAULT].order;
>> +    unsigned int i;
>>       int nid, count = 0;
>>       unsigned long tmp;
>>       char *s = p;
>>       char *suffix = strchr(p, '@');
>>       if (suffix) {
>> -        unsigned int order = arch_hugetlb_cma_order();
>>           unsigned long long page_size;
>>           char *end;
>> @@ -159,6 +187,22 @@ static int __init hugetlb_cma_parse(char *p)
>>           }
>>       }
>> +    if (!order) {
>> +        pr_warn("hugetlb_cma: the option isn't supported by current 
>> arch\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    for (i = 0; i < HUGETLB_CMA_POOLS; i++) {
>> +        if (hugetlb_cma[i].order == order)
>> +            break;
>> +    }
>> +
>> +    if (i == HUGETLB_CMA_POOLS)
>> +        return -EINVAL;
>> +
>> +    pool = &hugetlb_cma[i];
>> +    config = &hugetlb_cma_config[i];
>> +
>>       while (*s) {
>>           if (sscanf(s, "%lu%n", &tmp, &count) != 1)
>>               break;
>> @@ -256,20 +300,14 @@ unsigned int __weak arch_hugetlb_cma_order(void)
>>       return 0;
>>   }
>> -void __init hugetlb_cma_reserve(void)
>> +static void __init hugetlb_cma_reserve_pool(struct hugetlb_cma_pool 
>> *pool,
>> +                        struct hugetlb_cma_config *config)
>>   {
>> -    struct hugetlb_cma_pool *pool = &hugetlb_cma;
>> -    struct hugetlb_cma_config *config = &hugetlb_cma_config;
>> -    unsigned long size, reserved, per_node, order, gigantic_page_size;
>> +    unsigned long size, reserved, per_node, hugepage_size;
>> +    unsigned int order = pool->order;
>>       bool node_specific_cma_alloc = false;
>>       bool has_node_specific_param = false;
>>       int nid;
>> -    char *p;
>> -
>> -    for (p = hugetlb_cma_cmdline;
>> -         p < hugetlb_cma_cmdline + hugetlb_cma_cmdline_len;
>> -         p += strlen(p) + 1)
>> -        hugetlb_cma_parse(p);
>>       for (nid = 0; nid < MAX_NUMNODES; nid++) {
>>           if (config->size_in_node[nid] || config- 
>> >percent_in_node[nid]) {
>> @@ -301,12 +339,6 @@ void __init hugetlb_cma_reserve(void)
>>       if (!pool->size)
>>           return;
>> -    order = arch_hugetlb_cma_order();
>> -    if (!order) {
>> -        pr_warn("hugetlb_cma: the option isn't supported by current 
>> arch\n");
>> -        return;
>> -    }
>> -
>>       /*
>>        * HugeTLB CMA reservation is required for gigantic
>>        * huge pages which could not be allocated via the
>> @@ -314,12 +346,12 @@ void __init hugetlb_cma_reserve(void)
>>        * breaking this assumption.
>>        */
>>       VM_WARN_ON(order <= MAX_PAGE_ORDER);
>> -    gigantic_page_size = PAGE_SIZE << order;
>> +    hugepage_size = PAGE_SIZE << order;
>>       if (config->percent) {
>>           unsigned long orig_size = pool->size;
>> -        pool->size = ALIGN_DOWN(pool->size, PAGE_SIZE << order);
>> +        pool->size = ALIGN_DOWN(pool->size, hugepage_size);
>>           if (orig_size && !pool->size)
>>               pr_warn("hugetlb_cma: reservation size rounded down to 0 
>> from %lu MiB (%u%%)\n",
>>                   orig_size / SZ_1M, config->percent);
>> @@ -331,7 +363,7 @@ void __init hugetlb_cma_reserve(void)
>>                   config->size_in_node[nid] =
>>                       ALIGN_DOWN(config->size_in_node[nid],
>> -                           PAGE_SIZE << order);
>> +                           hugepage_size);
>>                   if (orig_size && !config->size_in_node[nid])
>>                       pr_warn("hugetlb_cma: reservation size rounded 
>> down to 0 from %lu MiB (%u%%) on node %d\n",
>>                           orig_size / SZ_1M,
>> @@ -351,9 +383,9 @@ void __init hugetlb_cma_reserve(void)
>>           if (!node_isset(nid, hugetlb_bootmem_nodes)) {
>>               pr_warn("hugetlb_cma: invalid node %d specified\n", nid);
>> -        } else if (!IS_ALIGNED(size, gigantic_page_size)) {
>> +        } else if (!IS_ALIGNED(size, hugepage_size)) {
>>               pr_warn("hugetlb_cma: cma area of node %d must be a 
>> multiple of %lu MiB\n",
>> -                nid, gigantic_page_size / SZ_1M);
>> +                nid, hugepage_size / SZ_1M);
>>           } else {
>>               node_specific_cma_alloc = true;
>>               continue;
>> @@ -367,9 +399,9 @@ void __init hugetlb_cma_reserve(void)
>>       if (!pool->size)
>>           return;
>> -    if (!IS_ALIGNED(pool->size, gigantic_page_size)) {
>> +    if (!IS_ALIGNED(pool->size, hugepage_size)) {
>>           pr_warn("hugetlb_cma: cma area must be a multiple of %lu 
>> MiB\n",
>> -            gigantic_page_size / SZ_1M);
>> +            hugepage_size / SZ_1M);
>>           pool->size = 0;
>>           return;
>>       }
>> @@ -381,7 +413,7 @@ void __init hugetlb_cma_reserve(void)
>>            */
>>           per_node = DIV_ROUND_UP(pool->size,
>>                       nodes_weight(hugetlb_bootmem_nodes));
>> -        per_node = round_up(per_node, gigantic_page_size);
>> +        per_node = round_up(per_node, hugepage_size);
>>           if (config->percent)
>>               pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu 
>> MiB per node\n",
>>                   pool->size / SZ_1M, config->percent,
>> @@ -411,7 +443,7 @@ void __init hugetlb_cma_reserve(void)
>>            * may be returned to CMA allocator in the case of
>>            * huge page demotion.
>>            */
>> -        res = cma_declare_contiguous_multi(size, gigantic_page_size,
>> +        res = cma_declare_contiguous_multi(size, hugepage_size,
>>                       HUGETLB_PAGE_ORDER, name,
>>                       &pool->cma[nid], nid);
>>           if (res || !cma_validate_zones(pool->cma[nid])) {
>> @@ -434,28 +466,50 @@ void __init hugetlb_cma_reserve(void)
>>               break;
>>       }
>> -    if (!reserved)
>> -        /*
>> -         * pool->size is used to determine if allocations from
>> -         * cma are possible.  Set to zero if no cma regions are set up.
>> -         */
>> -        pool->size = 0;
>> +    /* Only successfully reserved areas enable CMA allocation for 
>> this size. */
>> +    pool->size = reserved;
>> +}
>> +
>> +void __init hugetlb_cma_reserve(void)
>> +{
>> +    unsigned int i;
>> +    char *p;
>> +
>> +    hugetlb_cma[HUGETLB_CMA_DEFAULT].order = arch_hugetlb_cma_order();
>> +    hugetlb_cma[HUGETLB_CMA_PMD].order = PMD_SHIFT - PAGE_SHIFT;
>> +
>> +    for (p = hugetlb_cma_cmdline;
>> +         p < hugetlb_cma_cmdline + hugetlb_cma_cmdline_len;
>> +         p += strlen(p) + 1)
>> +        hugetlb_cma_parse(p);
>> +
>> +    for (i = 0; i < HUGETLB_CMA_POOLS; i++)
>> +        hugetlb_cma_reserve_pool(&hugetlb_cma[i], 
>> &hugetlb_cma_config[i]);
>>   }
>> -bool hugetlb_cma_exclusive_alloc(void)
>> +bool hugetlb_cma_exclusive_alloc(unsigned int order)
>>   {
>> -    return hugetlb_cma_only;
>> +    struct hugetlb_cma_pool *pool = hugetlb_cma_pool(order);
>> +
>> +    return hugetlb_cma_only && pool && pool->size;
>>   }
>> -unsigned long __init hugetlb_cma_total_size(void)
>> +unsigned long __init hugetlb_cma_size(struct hstate *h)
>>   {
>> -    return hugetlb_cma.size;
>> +    struct hugetlb_cma_pool *pool = 
>> hugetlb_cma_pool(huge_page_order(h));
>> +
>> +    return pool ? pool->size : 0;
>>   }
>> -void __init hugetlb_cma_validate_params(void)
>> +unsigned long __init hugetlb_cma_total_size(void)
>>   {
>> -    if (!hugetlb_cma.size)
>> -        hugetlb_cma_only = false;
>> +    unsigned long size = 0;
>> +    unsigned int i;
>> +
>> +    for (i = 0; i < HUGETLB_CMA_POOLS; i++)
>> +        size += hugetlb_cma[i].size;
>> +
>> +    return size;
>>   }
>>   bool __init hugetlb_early_cma(struct hstate *h)
>> @@ -463,5 +517,5 @@ bool __init hugetlb_early_cma(struct hstate *h)
>>       if (arch_has_huge_bootmem_alloc())
>>           return false;
>> -    return hstate_is_gigantic(h) && hugetlb_cma_only;
>> +    return hstate_is_gigantic(h) && 
>> hugetlb_cma_exclusive_alloc(huge_page_order(h));
>>   }
>> diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
>> index 730b2b4965b64..3d829258f6728 100644
>> --- a/mm/hugetlb_cma.h
>> +++ b/mm/hugetlb_cma.h
>> @@ -9,9 +9,9 @@ void hugetlb_cma_free_frozen_folio(struct folio *folio);
>>   struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>>                         int nid, nodemask_t *nodemask);
>>   void *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool 
>> node_exact);
>> -bool hugetlb_cma_exclusive_alloc(void);
>> +bool hugetlb_cma_exclusive_alloc(unsigned int order);
>> +unsigned long hugetlb_cma_size(struct hstate *h);
>>   unsigned long hugetlb_cma_total_size(void);
>> -void hugetlb_cma_validate_params(void);
>>   bool hugetlb_early_cma(struct hstate *h);
>>   #else
>>   static inline void hugetlb_cma_free_frozen_folio(struct folio *folio)
>> @@ -30,18 +30,19 @@ static inline void 
>> *hugetlb_cma_alloc_bootmem(struct hstate *h, int nid,
>>       return NULL;
>>   }
>> -static inline bool hugetlb_cma_exclusive_alloc(void)
>> +static inline bool hugetlb_cma_exclusive_alloc(unsigned int order)
>>   {
>>       return false;
>>   }
>> -static inline unsigned long hugetlb_cma_total_size(void)
>> +static inline unsigned long hugetlb_cma_size(struct hstate *h)
>>   {
>>       return 0;
>>   }
>> -static inline void hugetlb_cma_validate_params(void)
>> +static inline unsigned long hugetlb_cma_total_size(void)
>>   {
>> +    return 0;
>>   }
>>   static inline bool hugetlb_early_cma(struct hstate *h)
> 


