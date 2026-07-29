Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061C8C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFAC6B0088; Tue, 28 Jul 2026 23:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41656B008A; Tue, 28 Jul 2026 23:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C094A6B008C; Tue, 28 Jul 2026 23:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 932326B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:30:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E14AA19BA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:30:05 +0000 (UTC)
X-FDA: 85040385570.22.16B02EF
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id A07BA80005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:30:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bQik5zwU;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785295803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhbXbLaVW+Q38TBhdKjf7H1d46R7yaH2q6zPCnlMtVA=;
	b=qLXK5WT3nOvHEaWqpvBIymJ+wu4FVVGUabGxSjdPF8+dPRKjy3c8YPiSnbmHYatKyYyPbo
	a0sRPf3MSWq1+s/QYDo8qLXi/Ym23xxr6WFZR6d1hMEImCE9JuIn3UMTkU3e7S30pt/IAw
	uGK0T9rb/itHz0Frt16ceCkv8f086CA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785295803;
	b=Dp81ucmZ0gCC/04TKAmUl3bi6g2Py3wpv6oQSvArl0erlHTBwVaD5oVlGAmsFs3kkHgibA
	VP6jpg9nnUNdWnu4SCwjLJHi2H1wEaXRC8iLB8ekmZQpbVpoR7aOo0LfSTxEoNtmwLhoEG
	dNxBF63wZi+ShHyQiF+2yhQU22z5kxE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bQik5zwU;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785295796; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YhbXbLaVW+Q38TBhdKjf7H1d46R7yaH2q6zPCnlMtVA=;
	b=bQik5zwU0cysg5p3E+kOKW3/VK1yAiyQbmGV+na6m15IjQAz3e0Tk8CtxCpx9zmFv+SUOCtLb+RIsbXQSMaZRKy8j01IiMXwR7v9viLKIKlNrn6QvAyEFm0rK9AEYSTu/MwBcP0XFMW+R7KuYirHVf4rgK8RGB9BY49CGGIksrw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X80oAqF_1785295793;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X80oAqF_1785295793 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Jul 2026 11:29:54 +0800
Message-ID: <c169c4ec-adc8-4991-a690-ed5bfb4796a0@linux.alibaba.com>
Date: Wed, 29 Jul 2026 11:29:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com,
 akpm@linux-foundation.org, usama.arif@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
 <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
 <313c4dc7-9d03-40da-b6a0-170a774010b3@linux.alibaba.com>
 <a0b029b7-6ab8-4886-a26e-e52cec31a8e1@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <a0b029b7-6ab8-4886-a26e-e52cec31a8e1@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A07BA80005
X-Stat-Signature: yffs4fo1gtb97izddpsutstsw1ax7i6f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785295800-748736
X-HE-Meta: U2FsdGVkX18w8HWe76Gir4GqzzGBjfUr7zBy0TqBujDJCBzujDD/4BOJZRB/+/pvAEmiTrC+zaCymkpy0IxTnQ0vDB8IXu5FrW49Mdh+RpmgyWjEweZ9I6dxYjnby4YlmSEFZr1YxkCMtEK6i14/bB1FQNffXx0Y/a+KF439/LPQdijDXhQMmFX3qoPtBy3bvE7NtVGUG6udX5P91tQzCxLa2D71dUO+O8HBwD6Kxp7FQth8R1gyetgPrZFI3EIHe8vcWG0pmT4mYLf1QQqEr4WgE8F9+xx7EYmmdjIif3xRpvlokUGju+xukkel11X/LH8iQwMQA8vFB3OUD8hgGZxc+8xcpOk3ZYzV118TLzGTMlABLpl4spbV8kVUUoR1cxAqjots8xHUrqLYVb8jRcX02TPA6sSl6oWupv96HXLhJ1GT2paUxORfzeH3G5kCPo3A7fqJCbZODeXX7VHZ04rNf87OmhXdt8LAF19NeG5zH4vXkkztlSBfWMuEN2R0vzqIwax8V0GjN5/Ir4Iv3omSCoUjb4rSRoaIY+1ySARH26RRJFYwAqxhuOY+nWu47gXwBplxKI2Bn3QbRFWcUrRajw4A0S1Lyah+GiDuanBafG2P43hmMEg70AfqWO8b763Keo+m929kV4Q2Sw1suDx3S+5pN3J+4cqWk7wJ7qIBkNzLN1H5IXc1G0pptgzn28IZdAi7sHvNjKYN0N9Z9I0Z1OVt7v5cPowJDr21fI0lvoHGzto9oUnOnGV+3lrFdBHhUUKxUFl9o0Qm16AMQTCtu0U3Gw0JeQZ1C4A0JKaIy3RlSMTIGSznCzkYqqR1QgK+VHH1kfpTR8V6yfShm2nm06dUbJJr0I5+bjAqVW2ljzyA2I06/X5fwAEQUK7+MJ1/3ggnbc/HwUgp+Q3aAmBGIklHQsRaRG8RiiS4+j/VZZ6TDSOh1VvvmulGdJvH1YO6PFTJJy4/5c6LdGR
 71hfgIU4
 FqyYxea8aVuOKtJkvI8HwPREyhzBg6RhouBjenacnhRrrvPjBbuXP6BMXTfgx7hM3WUGyybZk+mpD1u7uSR9VyXTUeLIk3BCVFSFdkLRAAdOIl2UkHlDzgueZ2KXcI8robdfRJgJWejwys3vr6agDimTO02tBgXiQpSld1AbYu8SN96/pGEuo4KHcwEpyjcLGZcKvVQULkqPbBmzwhssb95uXnN3jRqULOOjLRNjq7bYAynrhdZtyb3BlS+OBV7R258REbVQHuKp5cxAGUQOXFE6vtZgpEg69V3LjbgREQ9gMHAP6HFJXKfbRLdmuTCp71jiXg8omY7Z4wc9YoNQhBRrgEjDAUCnXQ8tD3Nt2h3ltU28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/26 3:12 PM, Qi Zheng wrote:
> Hi Baolin,
> 
> On 7/27/26 1:11 PM, Baolin Wang wrote:
>> Hi Qi,
>>
>> (Sorry for the late reply due to my vacation)
> 
> No worries, and thank you for your response!
> 
>>
>> On 7/21/26 4:34 PM, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> The shmem unused huge shrinker keeps a per-superblock list of inodes 
>>> whose
>>> tail huge folio extends beyond i_size. Since that list is not memcg 
>>> aware,
>>> reclaim triggered by one memcg can scan inodes from the whole superblock
>>> and split shmem huge folios charged to unrelated memcgs.
>>>
>>> Convert the shrink list to a memcg-aware list_lru. Queue each inode 
>>> on the
>>> list_lru sublist matching the memcg and node of the current tail huge
>>> folio, so non-root memcg reclaim only walks candidates charged to the
>>> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
>>> reclaim keep global semantics.
>>>
>>> The list_lru still tracks inodes while the actual split target is the
>>> current tail huge folio, so validate the folio memcg/node during 
>>> scan. If
>>> the folio no longer matches the reclaim context or splitting cannot
>>> proceed, requeue the inode according to the current tail folio; if the
>>> inode is no longer shrinkable, drop the scan entry.
>>>
>>> This can be tested with the shrinker debugfs interface by allocating 32
>>> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs 
>>> shrinker
>>> with memcg A's cgroup id:
>>>
>>>                 before A scan        after A scan
>>>    base         A=64M, B=64M         A=0,  B=0
>>>    patched      A=64M, B=64M         A=0,  B=64M
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>   include/linux/shmem_fs.h |  12 +-
>>>   mm/shmem.c               | 378 +++++++++++++++++++++++++++++----------
>>>   2 files changed, 294 insertions(+), 96 deletions(-)
>>>
>>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>>> index 5663dff53186e..aeb59901a840c 100644
>>> --- a/include/linux/shmem_fs.h
>>> +++ b/include/linux/shmem_fs.h
>>> @@ -11,6 +11,7 @@
>>>   #include <linux/fs_parser.h>
>>>   #include <linux/userfaultfd_k.h>
>>>   #include <linux/bits.h>
>>> +#include <linux/list_lru.h>
>>>   /* inode in-kernel data */
>>> @@ -54,6 +55,11 @@ struct shmem_inode_info {
>>>       struct dquot __rcu    *i_dquot[MAXQUOTAS];
>>>   #endif
>>>       struct inode        vfs_inode;
>>> +
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +    struct mem_cgroup    *shrinklist_memcg;
>>> +    int            shrinklist_nid;
>>> +#endif
>>>   };
>>
>> Thanks. This looks better now.:) Some comments below.
>>
>>>   #define SHMEM_FL_USER_VISIBLE        (FS_FL_USER_VISIBLE | 
>>> FS_CASEFOLD_FL)
>>> @@ -83,9 +89,9 @@ struct shmem_sb_info {
>>>       ino_t next_ino;            /* The next per-sb inode number to 
>>> use */
>>>       ino_t __percpu *ino_batch;  /* The next per-cpu inode number to 
>>> use */
>>>       struct mempolicy *mpol;     /* default memory policy for 
>>> mappings */
>>> -    spinlock_t shrinklist_lock;   /* Protects shrinklist */
>>> -    struct list_head shrinklist;  /* List of shinkable inodes */
>>> -    unsigned long shrinklist_len; /* Length of shrinklist */
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +    struct list_lru shrinklist; /* List of shrinkable inodes */
>>> +#endif
>>>       struct shmem_quota_limits qlimits; /* Default quota limits */
>>>       struct simple_xattr_cache xa_cache;
>>>   };
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 20c24d92da430..8bf6dd850f85b 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -724,51 +724,242 @@ static const char *shmem_format_huge(int huge)
>>>   }
>>>   #endif
>>> +static bool is_shmem_unused_huge_isolated(struct shmem_inode_info 
>>> *info)
>>> +{
>>> +
>>> +    return info->shrinklist_nid == -1;
>>> +}
>>> +
>>> +static void set_shmem_unused_huge_isolated(struct shmem_inode_info 
>>> *info)
>>> +{
>>> +    info->shrinklist_nid = -1;
>>> +}
>>> +
>>> +static struct mem_cgroup *shmem_get_and_clear_memcg(struct 
>>> shmem_inode_info *info)
>>> +{
>>> +    struct mem_cgroup *memcg = info->shrinklist_memcg;
>>> +
>>> +    info->shrinklist_memcg = NULL;
>>> +
>>> +    return memcg;
>>> +}
>>> +
>>> +#ifdef CONFIG_MEMCG
>>> +static struct mem_cgroup *
>>> +shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct 
>>> folio *folio,
>>> +                gfp_t gfp)
>>> +{
>>> +    struct mem_cgroup *memcg;
>>> +    int ret;
>>> +
>>> +    memcg = get_mem_cgroup_from_folio(folio);
>>> +    if (!memcg)
>>> +        return NULL;
>>
>> It looks like we should return an error here instead of NULL? since 
>> callers use IS_ERR() to check the return value of this function.
> 
> Returning NULL here is intentional - it is not an error case.
> 
> The get_mem_cgroup_from_folio() returns NULL only when
> mem_cgroup_disabled() is true. In that case the list_lru is not
> memcg-aware, so use the global (root) list:
> 
> list_lru_add() /* memcg == NULL */
> --> lock_list_lru_of_memcg()
>      --> list_lru_from_memcg_idx() /* memcg_kmem_id(NULL) == -1 */
>          --> return &lru->node[nid].lru

OK. I see. Thanks.

[snip]

>>>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info 
>>> *sbinfo,
>>>           struct shrink_control *sc, unsigned long nr_to_free)
>>>   {
>>> -    LIST_HEAD(list), *pos, *next;
>>> +    struct shmem_unused_huge_scan scan;
>>>       struct inode *inode;
>>>       struct shmem_inode_info *info;
>>>       struct folio *folio;
>>> -    unsigned long batch = sc ? sc->nr_to_scan : 128;
>>> +    struct list_head *pos, *next;
>>>       unsigned long split = 0, freed = 0;
>>> -    if (list_empty(&sbinfo->shrinklist))
>>> -        return SHRINK_STOP;
>>> -
>>> -    spin_lock(&sbinfo->shrinklist_lock);
>>> -    list_for_each_safe(pos, next, &sbinfo->shrinklist) {
>>> -        info = list_entry(pos, struct shmem_inode_info, shrinklist);
>>> -
>>> -        /* pin the inode */
>>> -        inode = igrab(&info->vfs_inode);
>>> -
>>> -        /* inode is about to be evicted */
>>> -        if (!inode) {
>>> -            list_del_init(&info->shrinklist);
>>> -            goto next;
>>> -        }
>>> -
>>> -        list_move(&info->shrinklist, &list);
>>> -next:
>>> -        sbinfo->shrinklist_len--;
>>> -        if (!--batch)
>>> -            break;
>>> -    }
>>> -    spin_unlock(&sbinfo->shrinklist_lock);
>>> +    INIT_LIST_HEAD(&scan.list);
>>> +    scan.sc = sc;
>>> +    if (sc)
>>> +        list_lru_shrink_walk(&sbinfo->shrinklist, sc,
>>> +                     shmem_unused_huge_isolate, &scan);
>>> +    else
>>> +        list_lru_walk(&sbinfo->shrinklist, shmem_unused_huge_isolate,
>>> +                  &scan, 128);
>>> -    list_for_each_safe(pos, next, &list) {
>>> -        pgoff_t next, end;
>>> +    list_for_each_safe(pos, next, &scan.list) {
>>> +        pgoff_t folio_end, end;
>>>           loff_t i_size;
>>>           int ret;
>>>           info = list_entry(pos, struct shmem_inode_info, shrinklist);
>>>           inode = &info->vfs_inode;
>>> -        if (nr_to_free && freed >= nr_to_free)
>>> -            goto move_back;
>>> -
>>
>> Why move this logic? If this fixes anything, then a separate fix patch 
>> would be clearer.
> 
> After converting the shmem huge shrinker to be memcg-aware, we need to
> acquire the folio first to determine which sublist it should be returned
> to.

OK. Now the requeue needs to acquire the folio.

>>>           i_size = i_size_read(inode);
>>>           folio = filemap_get_entry(inode->i_mapping, i_size / 
>>> PAGE_SIZE);
>>>           if (!folio || xa_is_value(folio))
>>> @@ -781,13 +972,25 @@ static unsigned long 
>>> shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>>>           }
>>>           /* Check if there is anything to gain from splitting */
>>> -        next = folio_next_index(folio);
>>> +        folio_end = folio_next_index(folio);
>>>           end = shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
>>> -        if (end <= folio->index || end >= next) {
>>> +        if (end <= folio->index || end >= folio_end) {
>>>               folio_put(folio);
>>>               goto drop;
>>>           }
>>> +        if (!is_shmem_unused_huge_match(folio, scan.sc)) {
>>> +            shmem_unused_huge_requeue(inode, folio);
>>> +            folio_put(folio);
>>
>> Maybe keeping the 'move_back' label would be clearer? since you've 
>> added several places to requeue the inode.
> 
> Agree, will do.
> 
>>
>>> +            goto put;
>>> +        }
>>> +
>>> +        if (nr_to_free && freed >= nr_to_free) {
>>> +            shmem_unused_huge_requeue(inode, folio);
>>> +            folio_put(folio);
>>> +            goto put;
>>> +        }
>>> +
>>>           /*
>>>            * Move the inode on the list back to shrinklist if we failed
>>>            * to lock the page at this time.
>>> @@ -796,34 +999,33 @@ static unsigned long 
>>> shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>>>            * reclaim path.
>>>            */
>>>           if (!folio_trylock(folio)) {
>>> +            shmem_unused_huge_requeue(inode, folio);
>>> +            folio_put(folio);
>>> +            goto put;
>>> +        }
>>> +
>>> +        if (!is_shmem_unused_huge_match(folio, scan.sc)) {
>>> +            folio_unlock(folio);
>>> +            shmem_unused_huge_requeue(inode, folio);
>>>               folio_put(folio);
>>> -            goto move_back;
>>> +            goto put;
>>>           }
>>>           ret = split_folio(folio);
>>>           folio_unlock(folio);
>>> -        folio_put(folio);
>>>           /* If split failed move the inode on the list back to 
>>> shrinklist */
>>> -        if (ret)
>>> -            goto move_back;
>>> +        if (ret) {
>>> +            shmem_unused_huge_requeue(inode, folio);
>>> +            folio_put(folio);
>>> +            goto put;
>>> +        }
>>> -        freed += next - end;
>>> +        freed += folio_end - end;
>>>           split++;
>>> +        folio_put(folio);
>>>   drop:
>>> -        list_del_init(&info->shrinklist);
>>> -        goto put;
>>> -move_back:
>>> -        /*
>>> -         * Make sure the inode is either on the global list or deleted
>>> -         * from any local list before iput() since it could be deleted
>>> -         * in another thread once we put the inode (then the local list
>>> -         * is corrupted).
>>> -         */
>>> -        spin_lock(&sbinfo->shrinklist_lock);
>>> -        list_move(&info->shrinklist, &sbinfo->shrinklist);
>>> -        sbinfo->shrinklist_len++;
>>> -        spin_unlock(&sbinfo->shrinklist_lock);
>>> +        shmem_unused_huge_drop(inode);
>>>   put:
>>>           iput(inode);
>>>       }
>>> @@ -836,7 +1038,7 @@ static long shmem_unused_huge_scan(struct 
>>> super_block *sb,
>>>   {
>>>       struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>>> -    if (!READ_ONCE(sbinfo->shrinklist_len))
>>> +    if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
>>>           return SHRINK_STOP;
>>>       return shmem_unused_huge_shrink(sbinfo, sc, 0);
>>> @@ -847,21 +1049,21 @@ static long shmem_unused_huge_count(struct 
>>> super_block *sb,
>>>   {
>>>       struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>>> -    /*
>>> -     * The per-superblock shrinklist is filesystem-global and does not
>>> -     * honour sc->memcg, so it is only meaningful on the global 
>>> (kswapd or
>>> -     * root direct reclaim) shrink path. Skip the per-memcg 
>>> iterations of
>>> -     * shrink_slab_memcg() to avoid queueing duplicate global work.
>>> -     */
>>> -    if (!mem_cgroup_shrink_is_root(sc))
>>> -        return 0;
>>> -
>>> -    return READ_ONCE(sbinfo->shrinklist_len);
>>> +    return list_lru_shrink_count(&sbinfo->shrinklist, sc);
>>>   }
>>>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
>>>   #define shmem_huge SHMEM_HUGE_DENY
>>> +static void shmem_unused_huge_add(struct inode *inode, struct folio 
>>> *folio,
>>> +                  gfp_t gfp)
>>> +{
>>> +}
>>> +
>>> +static void shmem_unused_huge_del(struct inode *inode)
>>> +{
>>> +}
>>> +
>>>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info 
>>> *sbinfo,
>>>           struct shrink_control *sc, unsigned long nr_to_free)
>>>   {
>>> @@ -1417,14 +1619,7 @@ static void shmem_evict_inode(struct inode 
>>> *inode)
>>>           inode->i_size = 0;
>>>           mapping_set_exiting(inode->i_mapping);
>>>           shmem_truncate_range(inode, 0, (loff_t)-1);
>>> -        if (!list_empty(&info->shrinklist)) {
>>> -            spin_lock(&sbinfo->shrinklist_lock);
>>> -            if (!list_empty(&info->shrinklist)) {
>>> -                list_del_init(&info->shrinklist);
>>> -                sbinfo->shrinklist_len--;
>>> -            }
>>> -            spin_unlock(&sbinfo->shrinklist_lock);
>>> -        }
>>> +        shmem_unused_huge_del(inode);
>>>           while (!list_empty(&info->swaplist)) {
>>>               /* Wait while shmem_unuse() is scanning this inode... */
>>>               wait_var_event(&info->stop_eviction,
>>> @@ -2532,28 +2727,6 @@ static int shmem_get_folio_gfp(struct inode 
>>> *inode, pgoff_t index,
>>>   alloced:
>>>       alloced = true;
>>> -    if (folio_test_large(folio) &&
>>> -        DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
>>> -                    folio_next_index(folio)) {
>>> -        struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>>> -        struct shmem_inode_info *info = SHMEM_I(inode);
>>> -        /*
>>> -         * Part of the large folio is beyond i_size: subject
>>> -         * to shrink under memory pressure.
>>> -         */
>>> -        spin_lock(&sbinfo->shrinklist_lock);
>>> -        /*
>>> -         * _careful to defend against unlocked access to
>>> -         * ->shrink_list in shmem_unused_huge_shrink()
>>> -         */
>>> -        if (list_empty_careful(&info->shrinklist)) {
>>> -            list_add_tail(&info->shrinklist,
>>> -                      &sbinfo->shrinklist);
>>> -            sbinfo->shrinklist_len++;
>>> -        }
>>> -        spin_unlock(&sbinfo->shrinklist_lock);
>>> -    }
>>
>> Why move this additional logic down?
> 
> Because under the following condition:
> 
>          if (sgp <= SGP_CACHE &&
>          ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
>          error = -EINVAL;
>          goto unlock;
>      }
> 
> we will jump to unlock and remove the folio from page cache.
> 
> With the new memcg-aware design, shmem_unused_huge_add() takes a memcg
> reference. If the folio is then removed by the error path, the inode
> sits on the shrinker list holding a stale memcg reference and pointing
> at an i_size that no longer matches the folio.
> 
> So we should ensure the inode is only queued when the folio is fully set
> up and about to be returned successfully.

Right. But I think this deserves a separate preparation patch with above 
explanation, moving the original shrinklist addition logic to after all 
checks are completed.

