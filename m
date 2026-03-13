Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65136105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 13:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B406B0088; Fri, 13 Mar 2026 09:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBD36B0089; Fri, 13 Mar 2026 09:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAB86B008A; Fri, 13 Mar 2026 09:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 699296B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:27:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5A4416019A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:27:54 +0000 (UTC)
X-FDA: 84541117668.22.CC58F7B
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8B83314001F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:27:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773408472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cimq+FMx3tedZVw0b7RyjxqmfnW1+6EJS4ERyZV+rOs=;
	b=t00i7chSfXY79LT8YR8t5aD10aFeTIlLmhFdCuoYvbwbjgtlS0uqFU5aWzHBZLcK5g9upb
	xsVUjnM80em0rViWqXc40fmAQ7qZH9LRYAmzPqANIb8HP7ZLMfmpTbyMDqDXCWfXB6X5Wj
	EuA+HQoWilm3mI3LakKCKog2I4zqrAk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773408472; a=rsa-sha256;
	cv=none;
	b=EdUfihEtLeAM4QiJ2ve0ojNQrVl06iCdPChMoq38IPSNs4521zLeyqJHEqY70pTcN8zcut
	+41+gc9h/Ythkx7/gC9B4mB3mzPQWEe5oKj3XBobV7zmvFKkzwSpi1AgL7RvKgKMtL6Pvt
	TDJIdS9y/bucPfn6RKd03F6fy4xHSCY=
Received: by mail.gandi.net (Postfix) with ESMTPSA id B6D003E959;
	Fri, 13 Mar 2026 13:27:42 +0000 (UTC)
Message-ID: <576a990b-69da-4790-93e8-f89c980d3a92@ghiti.fr>
Date: Fri, 13 Mar 2026 14:27:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
To: Donet Tom <donettom@linux.ibm.com>, akpm@linux-foundation.org
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-2-alex@ghiti.fr>
 <b2543019-5489-4968-be77-226e356b855c@linux.ibm.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <b2543019-5489-4968-be77-226e356b855c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeeljeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedtgeeuhffhveeujeetveevieekleekvdffudefleevgefgieekkefggefhtddtveenucfkphepudefkedrudelledriedrvdefkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedufeekrdduleelrdeirddvfeekpdhhvghloheplgdutddrudeguddriedtrdektdgnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpqhhiugepueeiffdttdefgfelheelpdhmohguvgepshhmthhpohhuthdpnhgspghrtghpthhtohepvdekpdhrtghpthhtohepughonhgvthhtohhmsehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegrlhgvgihghhhithhisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopegrkhhinhhosghum
 hhithgrs
 ehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
X-GND-State: clean
X-Rspamd-Queue-Id: 8B83314001F
X-Rspamd-Server: rspam07
X-Stat-Signature: n1fo6qhusn3kcs55bp4c4u134ztyfntf
X-Rspam-User: 
X-HE-Tag: 1773408472-683644
X-HE-Meta: U2FsdGVkX19JtDjltRhbPIXhmKRZ+Ch1aoZ5Zv6c/gZ2IZBHQOl0GKg0m5CCqJKvUMZheo8lw5LsolsCTWh7LgLq/rB8cWMOEMZ+8zL/99sxDj9wfSaFaOcLIRalZRaUxVghTKPhRqjMjNLuuscDnnH2u7Cp25RjciHlRn+43l9FFxHMXXSWzldH0CxJ7Aj2pelrueYv/YEJdQqjG9zBrx0r48AAPN9D2+LKPtMGXmgBYwMZ8G4Oj+TPC5+GPfIGI3eABavRnXRwLCufxAlQD5Ef0xHEJsmF0cjw7mHCiiy4X8wMvamiRTEO1geDlxbM4imK5I9Wrg7vt37xyYlLGTVxtUuM4T1iPZfOIhU5xoSAsbyW1yfeJDEewChv2FLEOVK1tnKAaAKMkM1sLFND0eYU6TBBy7PM/zX1ujFvPkGaTrdmy4ycYOfoXQf6TO3853FVe+4Z+LqJssv9kxKBoUx8Oso3U2LP99ZVe05R/T+9mc0wrm9QcS910fzUKT2240jtFNRcZE/YQ6Jw8toqFlAwgCUS+TZQeeep1qahUSqF1sCQH+cL1H8GYmrMbOB18fsC/gkNKoYOxRluTFx3ESKtRrB4SYw1QWaD+b+ePNzq/ppFOWwDimYGMEiKBZkoSVY5dYzxh8vsN4NlUn4Ohr8S3kXPuk88JhJhtNMmM0hsRsgg12WdOwQoUO0XjQpg3WUvIFxRFALcEz3hW/vIPSF6hvQxaCB3rVhk1D9k2RzBQdPgyvbtpaWKgT5LbPMA/64M8JjkEhobzADMMz56SIopUX6/veNZmbD2H8DWyr8RZyzPUtuQKG7WscOABfCdXU4sOXZpPvxhpaj10qGyxLOjWnWfdXPKiQeScCE8zGXLw8pLM7IxjdYtMaUmAuNWEWbsMV+bqUOMLJQcImGjNns7bMZh33HRImUhVBPYS6OGlEGrmonUUMMxtvoKa2TXgWaFr6yNFHFL9SJQrOS
 3YNUF6kQ
 4OXAaeK5Qs5ItHQW4I9Zr5FBqerCoNUBQxgpjvl/rLJKPFn1ex3rINghswVNc/FsT3Uv1GPR9ve/8yb9tw8s0fobxOzaVl7ZU10+FKWIGawAzbldjITci2fzFTqHb4olZKNLthOD0Byjr3eZ2nv79zQ5jSlBbb5B4wmzoqbIw2y+u4VxV7pYJuy4A79ujlnKf/LqBsAagSANI0fET8lmZsHA53ZRJlmsDCdTBl1i82msKH5PO209lPKlvypQeYB9DMA45y38vaC588RE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tom,

On 3/12/26 09:44, Donet Tom wrote:
>
> Hi Alexander
>
> On 3/11/26 4:32 PM, Alexandre Ghiti wrote:
>> Let's have all the demotion functions in this file, no functional
>> change intended.
>>
>> Suggested-by: Gregory Price <gourry@gourry.net>
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   include/linux/memory-tiers.h | 18 ++++++++
>>   mm/memory-tiers.c            | 75 +++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                  | 80 +-----------------------------------
>>   3 files changed, 94 insertions(+), 79 deletions(-)
>>
>> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
>> index 96987d9d95a8..0bf0d002939e 100644
>> --- a/include/linux/memory-tiers.h
>> +++ b/include/linux/memory-tiers.h
>> @@ -56,6 +56,9 @@ void mt_put_memory_types(struct list_head 
>> *memory_types);
>>   int next_demotion_node(int node, const nodemask_t *allowed_mask);
>>   void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
>>   bool node_is_toptier(int node);
>> +unsigned int mt_demote_folios(struct list_head *demote_folios,
>> +                  struct pglist_data *pgdat,
>> +                  struct mem_cgroup *memcg);
>>   #else
>>   static inline int next_demotion_node(int node, const nodemask_t 
>> *allowed_mask)
>>   {
>> @@ -71,6 +74,14 @@ static inline bool node_is_toptier(int node)
>>   {
>>       return true;
>>   }
>> +
>> +static inline unsigned int mt_demote_folios(struct list_head 
>> *demote_folios,
>> +                        struct pglist_data *pgdat,
>> +                        struct mem_cgroup *memcg)
>> +{
>> +    return 0;
>> +}
>> +
>>   #endif
>>     #else
>> @@ -116,6 +127,13 @@ static inline bool node_is_toptier(int node)
>>       return true;
>>   }
>>   +static inline unsigned int mt_demote_folios(struct list_head 
>> *demote_folios,
>> +                        struct pglist_data *pgdat,
>> +                        struct mem_cgroup *memcg)
>> +{
>> +    return 0;
>> +}
>> +
>>   static inline int register_mt_adistance_algorithm(struct 
>> notifier_block *nb)
>>   {
>>       return 0;
>> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
>> index 986f809376eb..afdf21738a54 100644
>> --- a/mm/memory-tiers.c
>> +++ b/mm/memory-tiers.c
>> @@ -7,6 +7,7 @@
>>   #include <linux/memory-tiers.h>
>>   #include <linux/notifier.h>
>>   #include <linux/sched/sysctl.h>
>> +#include <linux/migrate.h>
>>     #include "internal.h"
>>   @@ -373,6 +374,80 @@ int next_demotion_node(int node, const 
>> nodemask_t *allowed_mask)
>>       return find_next_best_node(node, &mask);
>>   }
>>   +static struct folio *alloc_demote_folio(struct folio *src,
>> +                    unsigned long private)
>> +{
>> +    struct folio *dst;
>> +    nodemask_t *allowed_mask;
>> +    struct migration_target_control *mtc;
>> +
>> +    mtc = (struct migration_target_control *)private;
>> +
>> +    allowed_mask = mtc->nmask;
>> +    /*
>> +     * make sure we allocate from the target node first also trying to
>> +     * demote or reclaim pages from the target node via kswapd if we 
>> are
>> +     * low on free memory on target node. If we don't do this and if
>> +     * we have free memory on the slower(lower) memtier, we would start
>> +     * allocating pages from slower(lower) memory tiers without even 
>> forcing
>> +     * a demotion of cold pages from the target memtier. This can 
>> result
>> +     * in the kernel placing hot pages in slower(lower) memory tiers.
>> +     */
>> +    mtc->nmask = NULL;
>> +    mtc->gfp_mask |= __GFP_THISNODE;
>> +    dst = alloc_migration_target(src, (unsigned long)mtc);
>> +    if (dst)
>> +        return dst;
>> +
>> +    mtc->gfp_mask &= ~__GFP_THISNODE;
>> +    mtc->nmask = allowed_mask;
>> +
>> +    return alloc_migration_target(src, (unsigned long)mtc);
>> +}
>> +
>> +unsigned int mt_demote_folios(struct list_head *demote_folios,
>
>
> Demotion will happen only when different memory tiers are present, 
> right? Since demote_folios() already implies that the folios are being 
> demoted to a lower tier, is the mt_ prefix needed in the function 
> name? I’m fine with keeping it as is, but I just wanted to clarify.


You're right, demote implies some memory tiers. But I like the mt_ 
prefix, some functions in memory-tiers.c already have this prefix so it 
adds consistency: so since you don't mind, I'll keep it :)


>
> Otherwise it LGTM
>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>


Thanks for your time!

Alex


>
>> +                  struct pglist_data *pgdat,
>> +                  struct mem_cgroup *memcg)
>> +{
>> +    int target_nid;
>> +    unsigned int nr_succeeded;
>> +    nodemask_t allowed_mask;
>> +
>> +    struct migration_target_control mtc = {
>> +        /*
>> +         * Allocate from 'node', or fail quickly and quietly.
>> +         * When this happens, 'page' will likely just be discarded
>> +         * instead of migrated.
>> +         */
>> +        .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>> +            __GFP_NOMEMALLOC | GFP_NOWAIT,
>> +        .nmask = &allowed_mask,
>> +        .reason = MR_DEMOTION,
>> +    };
>> +
>> +    if (list_empty(demote_folios))
>> +        return 0;
>> +
>> +    node_get_allowed_targets(pgdat, &allowed_mask);
>> +    mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
>> +    if (nodes_empty(allowed_mask))
>> +        return 0;
>> +
>> +    target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
>> +    if (target_nid == NUMA_NO_NODE)
>> +        /* No lower-tier nodes or nodes were hot-unplugged. */
>> +        return 0;
>> +
>> +    mtc.nid = target_nid;
>> +
>> +    /* Demotion ignores all cpuset and mempolicy settings */
>> +    migrate_pages(demote_folios, alloc_demote_folio, NULL,
>> +            (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
>> +            &nr_succeeded);
>> +
>> +    return nr_succeeded;
>> +}
>> +
>>   static void disable_all_demotion_targets(void)
>>   {
>>       struct memory_tier *memtier;
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 0fc9373e8251..5e0138b94480 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -983,84 +983,6 @@ static void folio_check_dirty_writeback(struct 
>> folio *folio,
>>           mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
>>   }
>>   -static struct folio *alloc_demote_folio(struct folio *src,
>> -        unsigned long private)
>> -{
>> -    struct folio *dst;
>> -    nodemask_t *allowed_mask;
>> -    struct migration_target_control *mtc;
>> -
>> -    mtc = (struct migration_target_control *)private;
>> -
>> -    allowed_mask = mtc->nmask;
>> -    /*
>> -     * make sure we allocate from the target node first also trying to
>> -     * demote or reclaim pages from the target node via kswapd if we 
>> are
>> -     * low on free memory on target node. If we don't do this and if
>> -     * we have free memory on the slower(lower) memtier, we would start
>> -     * allocating pages from slower(lower) memory tiers without even 
>> forcing
>> -     * a demotion of cold pages from the target memtier. This can 
>> result
>> -     * in the kernel placing hot pages in slower(lower) memory tiers.
>> -     */
>> -    mtc->nmask = NULL;
>> -    mtc->gfp_mask |= __GFP_THISNODE;
>> -    dst = alloc_migration_target(src, (unsigned long)mtc);
>> -    if (dst)
>> -        return dst;
>> -
>> -    mtc->gfp_mask &= ~__GFP_THISNODE;
>> -    mtc->nmask = allowed_mask;
>> -
>> -    return alloc_migration_target(src, (unsigned long)mtc);
>> -}
>> -
>> -/*
>> - * Take folios on @demote_folios and attempt to demote them to 
>> another node.
>> - * Folios which are not demoted are left on @demote_folios.
>> - */
>> -static unsigned int demote_folio_list(struct list_head *demote_folios,
>> -                      struct pglist_data *pgdat,
>> -                      struct mem_cgroup *memcg)
>> -{
>> -    int target_nid;
>> -    unsigned int nr_succeeded;
>> -    nodemask_t allowed_mask;
>> -
>> -    struct migration_target_control mtc = {
>> -        /*
>> -         * Allocate from 'node', or fail quickly and quietly.
>> -         * When this happens, 'page' will likely just be discarded
>> -         * instead of migrated.
>> -         */
>> -        .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>> -            __GFP_NOMEMALLOC | GFP_NOWAIT,
>> -        .nmask = &allowed_mask,
>> -        .reason = MR_DEMOTION,
>> -    };
>> -
>> -    if (list_empty(demote_folios))
>> -        return 0;
>> -
>> -    node_get_allowed_targets(pgdat, &allowed_mask);
>> -    mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
>> -    if (nodes_empty(allowed_mask))
>> -        return 0;
>> -
>> -    target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
>> -    if (target_nid == NUMA_NO_NODE)
>> -        /* No lower-tier nodes or nodes were hot-unplugged. */
>> -        return 0;
>> -
>> -    mtc.nid = target_nid;
>> -
>> -    /* Demotion ignores all cpuset and mempolicy settings */
>> -    migrate_pages(demote_folios, alloc_demote_folio, NULL,
>> -              (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
>> -              &nr_succeeded);
>> -
>> -    return nr_succeeded;
>> -}
>> -
>>   static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
>>   {
>>       if (gfp_mask & __GFP_FS)
>> @@ -1573,7 +1495,7 @@ static unsigned int shrink_folio_list(struct 
>> list_head *folio_list,
>>       /* 'folio_list' is always empty here */
>>         /* Migrate folios selected for demotion */
>> -    nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
>> +    nr_demoted = mt_demote_folios(&demote_folios, pgdat, memcg);
>>       nr_reclaimed += nr_demoted;
>>       stat->nr_demoted += nr_demoted;
>>       /* Folios that could not be demoted are still in @demote_folios */

