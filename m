Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971C8C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 07:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC036B007B; Tue, 28 Jul 2026 03:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E046B0088; Tue, 28 Jul 2026 03:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D086B008A; Tue, 28 Jul 2026 03:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB3C26B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:12:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17EF0A02CD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:12:20 +0000 (UTC)
X-FDA: 85037316840.29.9A995C7
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA8BF100002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:12:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1vH0nf+;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785222738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKDOz+gmYJj1Y57aa5p2+INLQFXTqdIgYoZwl108+LA=;
	b=UtL4IIEkk6gzMntUEeDUu2fxIKtFsoJdJRLYrSII1B1CX78boSya5CKNq36qCQG+39YbLp
	oBcxNLEmPTg7R3KLmQoUdRPJdyzwbfNHWfziMceyjWtqCe0MbeBeGgiHcNDrMTJCVoaLiL
	BiHgBLxtNzWzLEj/ECeQ5d5Rs+o20kI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z1vH0nf+;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785222738;
	b=P5ZrRJqo5XDfBUExZJ3EB3Z68Hw5MIP6hS0OyYgEFhApQtrbHMziZZUd2B+TmX9IP8wCAg
	jbUl2nzx6nj0kF6nZh2fSDiswlZEIkihd02GUUjPqxBcY8GCyMJntBMWd/6kdc1txeqAVX
	eTDX7VkkldlzSlNBSwKo5FyO/fG9wJU=
Message-ID: <a0b029b7-6ab8-4886-a26e-e52cec31a8e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785222735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fKDOz+gmYJj1Y57aa5p2+INLQFXTqdIgYoZwl108+LA=;
	b=Z1vH0nf+sLz9GriSDH70L+F+aihnZSz7u75H3B1ja8QTXpQoBnSIkyFztcaOcA3ibNF8hI
	rYtKg7h+qtVbWhVAkFPAc3A6i5wCISK8e2rXty8T3R9hiyZO5LwrAMeD/yMquYoFAysy7l
	2Qdii2AKWECDOzqIqByFNtH/MGNOfuY=
Date: Tue, 28 Jul 2026 15:12:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
To: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com,
 akpm@linux-foundation.org, usama.arif@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
 <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
 <313c4dc7-9d03-40da-b6a0-170a774010b3@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <313c4dc7-9d03-40da-b6a0-170a774010b3@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA8BF100002
X-Stat-Signature: brkotoaf5e7q6nqqjnpgzwusimiowrnp
X-HE-Tag: 1785222737-65550
X-HE-Meta: U2FsdGVkX18eMSnz7rqeETXPr5nnKfshFSytiO8Kg6gOCjJR7nESOVlrUGrGv5DD/7ymil3nnKKIesaM8DimG1GM91BObgYhBL99nKwqhvz7gI8Vg4+FM0p2igpT90wrv22epIDxtjRm8sbueTq1/3Is77mcH1XxnZTgzsrTe1Zgp5O8JrwyJyANF+8WPaG2efcESO0xu6vyPO3N/C4WbVhntAiwBuHC04WiBRnd3/UnjZb+QQ84CoHMzv5MUpOosJ9ZCEooT1zxrwlBWyoo5khxAYyXDN7yFQ4ONiFyJ5O/Urgg6AQyyz3bG3z/VVPA/J8Vk4F80Tj8S5n/qdYk5TiygxJY9vz0qIjfQAbX4KIL0KcrPlMNN2N7p9tXrLtv6cwIJEo2SGBAdu5IAqWHScJotpfomAF3ltOFGtAiQUrjRGDbQndiMDwo9Ra7zTxLBkMvUO7x+9wjVHZwUUYI0m21lynzeWwg7OEnYCCQmt8gNLUGpZ+bo2ra/OiLqyXnW7EzbE7WvBG791xue0K3iOE62nqmivNO3nVLeV35DY7IGGWgCpUPFz9bCh1O7Yfzm7x1YTWRGWUimFzDzUNAxulGc7HFBKvB/WcxcpoqnSs6Sll3ZXGpcEjr+C7of1kqoU7DldEDt/Di8ZRjt25J+kfXiObQvu87N6XpC6a3k+uXVqSIQ8ojMe6YRttCQZZYRGqkufUNrZYcPZi+iPBYkDoHwEtMbQ7k4ogmknCdI3OdEartrBaZvg/1eJzlB2ko3zpFq7eX5vRVACmD4jbN1KRVz4x7ZAPFld5i6SEq35K2PVrQNbooM3E2NVZW2mpPxhfsxRMPMagR1RW4bgyL808huVWnyJN94GTb8IaOcIYZYXfiEg1le6lUZaxFPxjwhrHBt/GeUJEO0NyRaxAgakMmc+bhf/Gp8zjGzGl/s7J9ggjJepEeQa/vGR/ndnvvkg5BcO2witDJjgv/7OS
 NyII0jg3
 +zApAKmGjdDsmVmkxVLhrPyKn1w5L/uLfl1YhTLH5z7hYHghfnTSE6IKec71UHuFmtUT1r2rCC5qwF7BZPilAwEgAcLzXbSVthWZ+MLICrD73qU+1+KO325Grm4FsBm7cw293FDNZZXCX2/tQAvLMmz3/vyQeZ5WMX4LiNURZeS8y60QxPGbOrd52Hg+FATWP8ghV0IxmaMrOP6kj9r6OmV6nuztpfvWuDhLXhTQFkSyXQTR9uQl+V9flV7yVCzhBfdv/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 7/27/26 1:11 PM, Baolin Wang wrote:
> Hi Qi,
> 
> (Sorry for the late reply due to my vacation)

No worries, and thank you for your response!

> 
> On 7/21/26 4:34 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The shmem unused huge shrinker keeps a per-superblock list of inodes 
>> whose
>> tail huge folio extends beyond i_size. Since that list is not memcg 
>> aware,
>> reclaim triggered by one memcg can scan inodes from the whole superblock
>> and split shmem huge folios charged to unrelated memcgs.
>>
>> Convert the shrink list to a memcg-aware list_lru. Queue each inode on 
>> the
>> list_lru sublist matching the memcg and node of the current tail huge
>> folio, so non-root memcg reclaim only walks candidates charged to the
>> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
>> reclaim keep global semantics.
>>
>> The list_lru still tracks inodes while the actual split target is the
>> current tail huge folio, so validate the folio memcg/node during scan. If
>> the folio no longer matches the reclaim context or splitting cannot
>> proceed, requeue the inode according to the current tail folio; if the
>> inode is no longer shrinkable, drop the scan entry.
>>
>> This can be tested with the shrinker debugfs interface by allocating 32
>> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs 
>> shrinker
>> with memcg A's cgroup id:
>>
>>                 before A scan        after A scan
>>    base         A=64M, B=64M         A=0,  B=0
>>    patched      A=64M, B=64M         A=0,  B=64M
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/shmem_fs.h |  12 +-
>>   mm/shmem.c               | 378 +++++++++++++++++++++++++++++----------
>>   2 files changed, 294 insertions(+), 96 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index 5663dff53186e..aeb59901a840c 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -11,6 +11,7 @@
>>   #include <linux/fs_parser.h>
>>   #include <linux/userfaultfd_k.h>
>>   #include <linux/bits.h>
>> +#include <linux/list_lru.h>
>>   /* inode in-kernel data */
>> @@ -54,6 +55,11 @@ struct shmem_inode_info {
>>       struct dquot __rcu    *i_dquot[MAXQUOTAS];
>>   #endif
>>       struct inode        vfs_inode;
>> +
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +    struct mem_cgroup    *shrinklist_memcg;
>> +    int            shrinklist_nid;
>> +#endif
>>   };
> 
> Thanks. This looks better now.:) Some comments below.
> 
>>   #define SHMEM_FL_USER_VISIBLE        (FS_FL_USER_VISIBLE | 
>> FS_CASEFOLD_FL)
>> @@ -83,9 +89,9 @@ struct shmem_sb_info {
>>       ino_t next_ino;            /* The next per-sb inode number to 
>> use */
>>       ino_t __percpu *ino_batch;  /* The next per-cpu inode number to 
>> use */
>>       struct mempolicy *mpol;     /* default memory policy for 
>> mappings */
>> -    spinlock_t shrinklist_lock;   /* Protects shrinklist */
>> -    struct list_head shrinklist;  /* List of shinkable inodes */
>> -    unsigned long shrinklist_len; /* Length of shrinklist */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +    struct list_lru shrinklist; /* List of shrinkable inodes */
>> +#endif
>>       struct shmem_quota_limits qlimits; /* Default quota limits */
>>       struct simple_xattr_cache xa_cache;
>>   };
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 20c24d92da430..8bf6dd850f85b 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -724,51 +724,242 @@ static const char *shmem_format_huge(int huge)
>>   }
>>   #endif
>> +static bool is_shmem_unused_huge_isolated(struct shmem_inode_info *info)
>> +{
>> +
>> +    return info->shrinklist_nid == -1;
>> +}
>> +
>> +static void set_shmem_unused_huge_isolated(struct shmem_inode_info 
>> *info)
>> +{
>> +    info->shrinklist_nid = -1;
>> +}
>> +
>> +static struct mem_cgroup *shmem_get_and_clear_memcg(struct 
>> shmem_inode_info *info)
>> +{
>> +    struct mem_cgroup *memcg = info->shrinklist_memcg;
>> +
>> +    info->shrinklist_memcg = NULL;
>> +
>> +    return memcg;
>> +}
>> +
>> +#ifdef CONFIG_MEMCG
>> +static struct mem_cgroup *
>> +shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct 
>> folio *folio,
>> +                gfp_t gfp)
>> +{
>> +    struct mem_cgroup *memcg;
>> +    int ret;
>> +
>> +    memcg = get_mem_cgroup_from_folio(folio);
>> +    if (!memcg)
>> +        return NULL;
> 
> It looks like we should return an error here instead of NULL? since 
> callers use IS_ERR() to check the return value of this function.

Returning NULL here is intentional - it is not an error case.

The get_mem_cgroup_from_folio() returns NULL only when
mem_cgroup_disabled() is true. In that case the list_lru is not
memcg-aware, so use the global (root) list:

list_lru_add() /* memcg == NULL */
--> lock_list_lru_of_memcg()
     --> list_lru_from_memcg_idx() /* memcg_kmem_id(NULL) == -1 */
         --> return &lru->node[nid].lru

> 
>> +    ret = memcg_list_lru_alloc(memcg, &sbinfo->shrinklist, gfp);
>> +    if (ret) {
>> +        mem_cgroup_put(memcg);
>> +        return ERR_PTR(ret);
>> +    }
>> +
>> +    return memcg;
>> +}
>> +#else
>> +static struct mem_cgroup *
>> +shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct 
>> folio *folio,
>> +                gfp_t gfp)
>> +{
>> +    return NULL;
> 
> Ditto.

Similarly, we use the global list by returning NULL when CONFIG_MEMCG is
disabled.

> 
>> +}
>> +#endif
>> +
>> +static void shmem_unused_huge_add(struct inode *inode, struct folio 
>> *folio,
>> +                  gfp_t gfp)
>> +{
>> +    struct shmem_inode_info *info = SHMEM_I(inode);
>> +    struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>> +    int nid = folio_nid(folio);
>> +    struct mem_cgroup *memcg = NULL, *old_memcg = NULL;
>> +
>> +    memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, gfp);
>> +    if (IS_ERR(memcg))
>> +        return;
>> +
>> +    spin_lock(&info->lock);
>> +    if (!list_empty(&info->shrinklist)) {
>> +        /* isolated on scan list, let shrink handle it */
>> +        if (is_shmem_unused_huge_isolated(info))
>> +            goto unlock;
>> +
>> +        if (info->shrinklist_nid == nid &&
>> +            info->shrinklist_memcg == memcg)
>> +            goto unlock;
>> +
>> +        list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
>> +                 info->shrinklist_nid, info->shrinklist_memcg);
>> +        old_memcg = shmem_get_and_clear_memcg(info);
>> +    }
>> +
>> +    info->shrinklist_memcg = memcg;
>> +    info->shrinklist_nid = nid;
>> +    list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
>> +    memcg = NULL;
>> +unlock:
>> +    spin_unlock(&info->lock);
>> +    mem_cgroup_put(old_memcg);
>> +    mem_cgroup_put(memcg);
>> +}
>> +
>> +static void shmem_unused_huge_del(struct inode *inode)
>> +{
>> +    struct shmem_inode_info *info = SHMEM_I(inode);
>> +    struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>> +    struct mem_cgroup *memcg = NULL;
>> +
>> +    spin_lock(&info->lock);
>> +    if (!list_empty(&info->shrinklist)) {
>> +        list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
>> +                 info->shrinklist_nid, info->shrinklist_memcg);
>> +        memcg = shmem_get_and_clear_memcg(info);
>> +    }
>> +    spin_unlock(&info->lock);
>> +
>> +    mem_cgroup_put(memcg);
>> +}
>> +
>> +struct shmem_unused_huge_scan {
>> +    struct list_head list;
>> +    struct shrink_control *sc;
>> +};
>> +
>> +static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
>> +                         struct list_lru_one *lru,
>> +                         void *arg)
>> +{
>> +    struct shmem_unused_huge_scan *scan = arg;
>> +    struct shmem_inode_info *info;
>> +    struct inode *inode;
>> +    struct mem_cgroup *memcg = NULL;
>> +
>> +    info = list_entry(item, struct shmem_inode_info, shrinklist);
>> +
>> +    /*
>> +     * Use trylock to avoid ABBA deadlock: add/del path takes info->lock
>> +     * before the list_lru bucket lock, while here the order is 
>> reversed.
>> +     */
>> +    if (!spin_trylock(&info->lock))
>> +        return LRU_SKIP;
>> +
>> +    /* pin the inode */
>> +    inode = igrab(&info->vfs_inode);
>> +    /* inode is about to be evicted */
>> +    if (!inode) {
>> +        list_lru_isolate(lru, item);
>> +        memcg = shmem_get_and_clear_memcg(info);
>> +        spin_unlock(&info->lock);
>> +        mem_cgroup_put(memcg);
>> +        return LRU_REMOVED;
>> +    }
>> +
>> +    list_lru_isolate(lru, item);
>> +    memcg = shmem_get_and_clear_memcg(info);
>> +    set_shmem_unused_huge_isolated(info);
>> +    list_add_tail(&info->shrinklist, &scan->list);
>> +    spin_unlock(&info->lock);
>> +    mem_cgroup_put(memcg);
>> +
>> +    return LRU_REMOVED;
>> +}
>> +
>> +static bool is_shmem_unused_huge_match(struct folio *folio,
>> +                       struct shrink_control *sc)
>> +{
>> +    struct mem_cgroup *memcg = NULL;
>> +    bool match;
>> +
>> +    /*
>> +     * Only non-root memcg reclaim needs to match the folio charge 
>> against
>> +     * sc->memcg. Skip the folio memcg check for the following cases:
>> +     * 1. shmem quota reclaim (sc == NULL)
>> +     * 2. global shrinker reclaim
>> +     * 3. root memcg reclaim
>> +     */
>> +    if (!sc || !sc->memcg || mem_cgroup_is_root(sc->memcg))
>> +        return true;
>> +
>> +    if (folio_nid(folio) != sc->nid)
>> +        return false;
>> +
>> +    memcg = get_mem_cgroup_from_folio(folio);
>> +    match = memcg == sc->memcg;
>> +    mem_cgroup_put(memcg);
>> +
>> +    return match;
>> +}
>> +
>> +static void shmem_unused_huge_drop(struct inode *inode)
>> +{
>> +    struct shmem_inode_info *info = SHMEM_I(inode);
>> +
>> +    spin_lock(&info->lock);
>> +    list_del_init(&info->shrinklist);
>> +    spin_unlock(&info->lock);
>> +}
>> +
>> +static void shmem_unused_huge_requeue(struct inode *inode, struct 
>> folio *folio)
>> +{
>> +    struct shmem_inode_info *info = SHMEM_I(inode);
>> +    struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>> +    struct mem_cgroup *memcg;
>> +    int nid = folio_nid(folio);
>> +
>> +    memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
>> +    if (IS_ERR(memcg))
>> +        goto drop;
> 
> You can just call shmem_unused_huge_drop(), then remove the 'goto'.

OK, will do.

> 
>> +
>> +    spin_lock(&info->lock);
>> +    /* Requeue the inode to shrinklist */
>> +    list_del_init(&info->shrinklist);
>> +    list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
>> +    info->shrinklist_memcg = memcg;
>> +    info->shrinklist_nid = nid;
>> +    memcg = NULL;
>> +    spin_unlock(&info->lock);
>> +    mem_cgroup_put(memcg);
> 
> Seems you can remove the 'memcg = NULL' and 'mem_cgroup_put'.

Indeed, will remove.

> 
>> +    return;
>> +
>> +drop:
>> +    shmem_unused_huge_drop(inode);
>> +}
>> +
>>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info 
>> *sbinfo,
>>           struct shrink_control *sc, unsigned long nr_to_free)
>>   {
>> -    LIST_HEAD(list), *pos, *next;
>> +    struct shmem_unused_huge_scan scan;
>>       struct inode *inode;
>>       struct shmem_inode_info *info;
>>       struct folio *folio;
>> -    unsigned long batch = sc ? sc->nr_to_scan : 128;
>> +    struct list_head *pos, *next;
>>       unsigned long split = 0, freed = 0;
>> -    if (list_empty(&sbinfo->shrinklist))
>> -        return SHRINK_STOP;
>> -
>> -    spin_lock(&sbinfo->shrinklist_lock);
>> -    list_for_each_safe(pos, next, &sbinfo->shrinklist) {
>> -        info = list_entry(pos, struct shmem_inode_info, shrinklist);
>> -
>> -        /* pin the inode */
>> -        inode = igrab(&info->vfs_inode);
>> -
>> -        /* inode is about to be evicted */
>> -        if (!inode) {
>> -            list_del_init(&info->shrinklist);
>> -            goto next;
>> -        }
>> -
>> -        list_move(&info->shrinklist, &list);
>> -next:
>> -        sbinfo->shrinklist_len--;
>> -        if (!--batch)
>> -            break;
>> -    }
>> -    spin_unlock(&sbinfo->shrinklist_lock);
>> +    INIT_LIST_HEAD(&scan.list);
>> +    scan.sc = sc;
>> +    if (sc)
>> +        list_lru_shrink_walk(&sbinfo->shrinklist, sc,
>> +                     shmem_unused_huge_isolate, &scan);
>> +    else
>> +        list_lru_walk(&sbinfo->shrinklist, shmem_unused_huge_isolate,
>> +                  &scan, 128);
>> -    list_for_each_safe(pos, next, &list) {
>> -        pgoff_t next, end;
>> +    list_for_each_safe(pos, next, &scan.list) {
>> +        pgoff_t folio_end, end;
>>           loff_t i_size;
>>           int ret;
>>           info = list_entry(pos, struct shmem_inode_info, shrinklist);
>>           inode = &info->vfs_inode;
>> -        if (nr_to_free && freed >= nr_to_free)
>> -            goto move_back;
>> -
> 
> Why move this logic? If this fixes anything, then a separate fix patch 
> would be clearer.

After converting the shmem huge shrinker to be memcg-aware, we need to
acquire the folio first to determine which sublist it should be returned
to.

> 
>>           i_size = i_size_read(inode);
>>           folio = filemap_get_entry(inode->i_mapping, i_size / 
>> PAGE_SIZE);
>>           if (!folio || xa_is_value(folio))
>> @@ -781,13 +972,25 @@ static unsigned long 
>> shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>>           }
>>           /* Check if there is anything to gain from splitting */
>> -        next = folio_next_index(folio);
>> +        folio_end = folio_next_index(folio);
>>           end = shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
>> -        if (end <= folio->index || end >= next) {
>> +        if (end <= folio->index || end >= folio_end) {
>>               folio_put(folio);
>>               goto drop;
>>           }
>> +        if (!is_shmem_unused_huge_match(folio, scan.sc)) {
>> +            shmem_unused_huge_requeue(inode, folio);
>> +            folio_put(folio);
> 
> Maybe keeping the 'move_back' label would be clearer? since you've added 
> several places to requeue the inode.

Agree, will do.

> 
>> +            goto put;
>> +        }
>> +
>> +        if (nr_to_free && freed >= nr_to_free) {
>> +            shmem_unused_huge_requeue(inode, folio);
>> +            folio_put(folio);
>> +            goto put;
>> +        }
>> +
>>           /*
>>            * Move the inode on the list back to shrinklist if we failed
>>            * to lock the page at this time.
>> @@ -796,34 +999,33 @@ static unsigned long 
>> shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>>            * reclaim path.
>>            */
>>           if (!folio_trylock(folio)) {
>> +            shmem_unused_huge_requeue(inode, folio);
>> +            folio_put(folio);
>> +            goto put;
>> +        }
>> +
>> +        if (!is_shmem_unused_huge_match(folio, scan.sc)) {
>> +            folio_unlock(folio);
>> +            shmem_unused_huge_requeue(inode, folio);
>>               folio_put(folio);
>> -            goto move_back;
>> +            goto put;
>>           }
>>           ret = split_folio(folio);
>>           folio_unlock(folio);
>> -        folio_put(folio);
>>           /* If split failed move the inode on the list back to 
>> shrinklist */
>> -        if (ret)
>> -            goto move_back;
>> +        if (ret) {
>> +            shmem_unused_huge_requeue(inode, folio);
>> +            folio_put(folio);
>> +            goto put;
>> +        }
>> -        freed += next - end;
>> +        freed += folio_end - end;
>>           split++;
>> +        folio_put(folio);
>>   drop:
>> -        list_del_init(&info->shrinklist);
>> -        goto put;
>> -move_back:
>> -        /*
>> -         * Make sure the inode is either on the global list or deleted
>> -         * from any local list before iput() since it could be deleted
>> -         * in another thread once we put the inode (then the local list
>> -         * is corrupted).
>> -         */
>> -        spin_lock(&sbinfo->shrinklist_lock);
>> -        list_move(&info->shrinklist, &sbinfo->shrinklist);
>> -        sbinfo->shrinklist_len++;
>> -        spin_unlock(&sbinfo->shrinklist_lock);
>> +        shmem_unused_huge_drop(inode);
>>   put:
>>           iput(inode);
>>       }
>> @@ -836,7 +1038,7 @@ static long shmem_unused_huge_scan(struct 
>> super_block *sb,
>>   {
>>       struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>> -    if (!READ_ONCE(sbinfo->shrinklist_len))
>> +    if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
>>           return SHRINK_STOP;
>>       return shmem_unused_huge_shrink(sbinfo, sc, 0);
>> @@ -847,21 +1049,21 @@ static long shmem_unused_huge_count(struct 
>> super_block *sb,
>>   {
>>       struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>> -    /*
>> -     * The per-superblock shrinklist is filesystem-global and does not
>> -     * honour sc->memcg, so it is only meaningful on the global 
>> (kswapd or
>> -     * root direct reclaim) shrink path. Skip the per-memcg 
>> iterations of
>> -     * shrink_slab_memcg() to avoid queueing duplicate global work.
>> -     */
>> -    if (!mem_cgroup_shrink_is_root(sc))
>> -        return 0;
>> -
>> -    return READ_ONCE(sbinfo->shrinklist_len);
>> +    return list_lru_shrink_count(&sbinfo->shrinklist, sc);
>>   }
>>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
>>   #define shmem_huge SHMEM_HUGE_DENY
>> +static void shmem_unused_huge_add(struct inode *inode, struct folio 
>> *folio,
>> +                  gfp_t gfp)
>> +{
>> +}
>> +
>> +static void shmem_unused_huge_del(struct inode *inode)
>> +{
>> +}
>> +
>>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info 
>> *sbinfo,
>>           struct shrink_control *sc, unsigned long nr_to_free)
>>   {
>> @@ -1417,14 +1619,7 @@ static void shmem_evict_inode(struct inode *inode)
>>           inode->i_size = 0;
>>           mapping_set_exiting(inode->i_mapping);
>>           shmem_truncate_range(inode, 0, (loff_t)-1);
>> -        if (!list_empty(&info->shrinklist)) {
>> -            spin_lock(&sbinfo->shrinklist_lock);
>> -            if (!list_empty(&info->shrinklist)) {
>> -                list_del_init(&info->shrinklist);
>> -                sbinfo->shrinklist_len--;
>> -            }
>> -            spin_unlock(&sbinfo->shrinklist_lock);
>> -        }
>> +        shmem_unused_huge_del(inode);
>>           while (!list_empty(&info->swaplist)) {
>>               /* Wait while shmem_unuse() is scanning this inode... */
>>               wait_var_event(&info->stop_eviction,
>> @@ -2532,28 +2727,6 @@ static int shmem_get_folio_gfp(struct inode 
>> *inode, pgoff_t index,
>>   alloced:
>>       alloced = true;
>> -    if (folio_test_large(folio) &&
>> -        DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
>> -                    folio_next_index(folio)) {
>> -        struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>> -        struct shmem_inode_info *info = SHMEM_I(inode);
>> -        /*
>> -         * Part of the large folio is beyond i_size: subject
>> -         * to shrink under memory pressure.
>> -         */
>> -        spin_lock(&sbinfo->shrinklist_lock);
>> -        /*
>> -         * _careful to defend against unlocked access to
>> -         * ->shrink_list in shmem_unused_huge_shrink()
>> -         */
>> -        if (list_empty_careful(&info->shrinklist)) {
>> -            list_add_tail(&info->shrinklist,
>> -                      &sbinfo->shrinklist);
>> -            sbinfo->shrinklist_len++;
>> -        }
>> -        spin_unlock(&sbinfo->shrinklist_lock);
>> -    }
> 
> Why move this additional logic down?

Because under the following condition:

         if (sgp <= SGP_CACHE &&
	    ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
		error = -EINVAL;
		goto unlock;
	}

we will jump to unlock and remove the folio from page cache.

With the new memcg-aware design, shmem_unused_huge_add() takes a memcg
reference. If the folio is then removed by the error path, the inode
sits on the shrinker list holding a stale memcg reference and pointing
at an i_size that no longer matches the folio.

So we should ensure the inode is only queued when the folio is fully set
up and about to be returned successfully.

Thanks,
Qi



