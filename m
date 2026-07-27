Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D21C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 05:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43726B0088; Mon, 27 Jul 2026 01:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3CE6B008A; Mon, 27 Jul 2026 01:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2F26B008C; Mon, 27 Jul 2026 01:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 661C86B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:11:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D75618063A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:11:10 +0000 (UTC)
X-FDA: 85033382700.18.2DE36F8
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf23.hostedemail.com (Postfix) with ESMTP id BFD3114000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:11:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KRbF7h3F;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785129069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYdBp+DhBEsc+ppQgxCmckzMjloNmU27Jq9bUJLeYOs=;
	b=6O+QPVSBOpaBQiqsnw0DCB97eSTM2L7I0QCYTjPSBWRSiXJtUjt9lLgnwJIPYzyp0Ll6gE
	+7s8FwZ54eenp5shVP0zcfRmEuB7cMV9MzfbYEge5WiEVJ3OVaUUg7v2xizl31D8naii6Z
	DpxN1M2sykmchhII9CXbjy9TwC1Mzko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785129069;
	b=fItoH8aXLpCoFM7PV0NfFao2CMtLdrBn9fEopoj24Dj+an19sUX5c8uqR7FXQhQxjMNsnb
	/QMpxvbAPx0LpffCzvuCMEEdyTRjL34bvtTQVOzTRksAf65ZsJ8RuO4YyEA9K+V4Y+IE97
	WpHTn2ANPLfKGvXYeGFzwnghiZczI5A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KRbF7h3F;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785129064; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=JYdBp+DhBEsc+ppQgxCmckzMjloNmU27Jq9bUJLeYOs=;
	b=KRbF7h3F1v+YaXBNcixKqm9CPgpr4RsV8buUP/AUWt57Q5X6ynF5nZt6OPhU5W0ELEaLuoL0IPC00EZW1PzDkkJcZqcu1uQDpiyZlpbT+EwY99X1g287uXiZVBi8CWbjoopvqUt8fsRVsiH2ls25WK00ABSwwnW8Cjdx40OBvU0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X7pL7p-_1785129061;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7pL7p-_1785129061 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Jul 2026 13:11:02 +0800
Message-ID: <313c4dc7-9d03-40da-b6a0-170a774010b3@linux.alibaba.com>
Date: Mon, 27 Jul 2026 13:11:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com,
 akpm@linux-foundation.org, usama.arif@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
 <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BFD3114000D
X-Stat-Signature: hyykp5uspqx6nmc55bmkm7u5cne3345e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785129066-698131
X-HE-Meta: U2FsdGVkX1+zWfzd89wFK02G7DSUjvFB621vj23PD0J4grumzc3geW7hxll5+/klOj5Ox9ANF67ipPlrOIz+64OR9a1TDp5DW4ZMgaxgej9+mvdGbtUGFOmhkLj5pGKRhGm3vSLtD02spO9RLUuAct73M6Cr136Ro6WohQQA9LzltbBMfvpVOu3xZfuF57j79pBEoxdzvM310leAJBD4DOJfhDezJ/UJtLBJ83imt7/c3lf4vCiqIDRV0zbZJaY4wppK6U/H9XFeiF2E2SveGzBCjjgg/z+79g8cztZR3OdnPVByxHrs70qUorrej+YlyYRug7RKy0e9L8BBDu7STjAh/Csxv7Fmx+qYHwZOhDNM29oGJJVDhlSsFbuqOWKsA7lVVWdiA1buxpQc9V+8A+DfKCzdeAatIo+0i4ROLABBlEUekl/H6h5An9cxbg/v8DvQBGTy+HyLdDAlS9lV9SObKKbvuYUv7FmNt/3YpuZTq0Uf24KnA0eIjFf62amVOhFADGopDQJjkzaM6sAZLpgekuhIIJak/EoPbF5yfjcQuNTCl31iEi/6E3qyKDLifjZl0zXWeT4qn1a+OYeHEu8LW3RDoYI6s9aoJ0y57DF0PsSwqH9Zx5n4E27ninRM4r25VD9XmpAOwNto2DI7OVGP9fFbJ3jCiUbUXIvAKmAK660plFwHu4Osv5mrML9rQuFqGoKO/yxgAcip1Dt9rcKtykYt4bU5z7GnpGG6ehBx8O7hQal14doyqmUtJS7q3t+A7z2zq6O1QAvuy6+NmZms29Xs8mFsnIAtei3b4/eAq7KH8vCuNJumyTX/DS+9UZRIX+Gn6QWp/kwKfIEVMwKKnYdNma886AHrtXL4kTHh1mJhthi1FiyGuZpfN+5jwyhdDt09CjsImCDMBOtCoCpUCK95Y5p/rVFOPCCixDH0hxYJcZgfJ09Bd76LAUuklTn3+9p7Vo2Q57PubR/
 Vp7pKCDD
 BTWOk40f0OJ1TsPNxb8tKFEtSBpogBpVtupkhf7SAR5/eo57tyb+ScL/EXp6IqvY/UitI3gRy73yPJWZjhhEou9/+w+/Bh5FMcencQNpf8Gk/6+ojmgjnUyZ9odJitoh+qHO4iUjuNfnm+OZ4lio/mtbh7jojX+nRcvmlZA83o+dhD2ekzKb0INKTBuMz/1FFqhFk2RXnhrhDmbFfjtBEfxeDWScdRkVZxOK4zYVQYd9HIMZExViqdgMVfEU59l0QQ/qpa0aXjTyUI5hKad9xAF4R351GyMpY6BZbtthoz8EbLkUEr97oCf5iHYcZWxmuY1bIzgAn3xykXg8fn+OQakk+eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

(Sorry for the late reply due to my vacation)

On 7/21/26 4:34 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The shmem unused huge shrinker keeps a per-superblock list of inodes whose
> tail huge folio extends beyond i_size. Since that list is not memcg aware,
> reclaim triggered by one memcg can scan inodes from the whole superblock
> and split shmem huge folios charged to unrelated memcgs.
> 
> Convert the shrink list to a memcg-aware list_lru. Queue each inode on the
> list_lru sublist matching the memcg and node of the current tail huge
> folio, so non-root memcg reclaim only walks candidates charged to the
> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
> reclaim keep global semantics.
> 
> The list_lru still tracks inodes while the actual split target is the
> current tail huge folio, so validate the folio memcg/node during scan. If
> the folio no longer matches the reclaim context or splitting cannot
> proceed, requeue the inode according to the current tail folio; if the
> inode is no longer shrinkable, drop the scan entry.
> 
> This can be tested with the shrinker debugfs interface by allocating 32
> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs shrinker
> with memcg A's cgroup id:
> 
>                 before A scan        after A scan
>    base         A=64M, B=64M         A=0,  B=0
>    patched      A=64M, B=64M         A=0,  B=64M
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   include/linux/shmem_fs.h |  12 +-
>   mm/shmem.c               | 378 +++++++++++++++++++++++++++++----------
>   2 files changed, 294 insertions(+), 96 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 5663dff53186e..aeb59901a840c 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -11,6 +11,7 @@
>   #include <linux/fs_parser.h>
>   #include <linux/userfaultfd_k.h>
>   #include <linux/bits.h>
> +#include <linux/list_lru.h>
>   
>   /* inode in-kernel data */
>   
> @@ -54,6 +55,11 @@ struct shmem_inode_info {
>   	struct dquot __rcu	*i_dquot[MAXQUOTAS];
>   #endif
>   	struct inode		vfs_inode;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	struct mem_cgroup	*shrinklist_memcg;
> +	int			shrinklist_nid;
> +#endif
>   };

Thanks. This looks better now.:) Some comments below.

>   #define SHMEM_FL_USER_VISIBLE		(FS_FL_USER_VISIBLE | FS_CASEFOLD_FL)
> @@ -83,9 +89,9 @@ struct shmem_sb_info {
>   	ino_t next_ino;		    /* The next per-sb inode number to use */
>   	ino_t __percpu *ino_batch;  /* The next per-cpu inode number to use */
>   	struct mempolicy *mpol;     /* default memory policy for mappings */
> -	spinlock_t shrinklist_lock;   /* Protects shrinklist */
> -	struct list_head shrinklist;  /* List of shinkable inodes */
> -	unsigned long shrinklist_len; /* Length of shrinklist */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	struct list_lru shrinklist; /* List of shrinkable inodes */
> +#endif
>   	struct shmem_quota_limits qlimits; /* Default quota limits */
>   	struct simple_xattr_cache xa_cache;
>   };
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 20c24d92da430..8bf6dd850f85b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -724,51 +724,242 @@ static const char *shmem_format_huge(int huge)
>   }
>   #endif
>   
> +static bool is_shmem_unused_huge_isolated(struct shmem_inode_info *info)
> +{
> +
> +	return info->shrinklist_nid == -1;
> +}
> +
> +static void set_shmem_unused_huge_isolated(struct shmem_inode_info *info)
> +{
> +	info->shrinklist_nid = -1;
> +}
> +
> +static struct mem_cgroup *shmem_get_and_clear_memcg(struct shmem_inode_info *info)
> +{
> +	struct mem_cgroup *memcg = info->shrinklist_memcg;
> +
> +	info->shrinklist_memcg = NULL;
> +
> +	return memcg;
> +}
> +
> +#ifdef CONFIG_MEMCG
> +static struct mem_cgroup *
> +shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
> +			    gfp_t gfp)
> +{
> +	struct mem_cgroup *memcg;
> +	int ret;
> +
> +	memcg = get_mem_cgroup_from_folio(folio);
> +	if (!memcg)
> +		return NULL;

It looks like we should return an error here instead of NULL? since 
callers use IS_ERR() to check the return value of this function.

> +	ret = memcg_list_lru_alloc(memcg, &sbinfo->shrinklist, gfp);
> +	if (ret) {
> +		mem_cgroup_put(memcg);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return memcg;
> +}
> +#else
> +static struct mem_cgroup *
> +shmem_unused_huge_alloc_lru(struct shmem_sb_info *sbinfo, struct folio *folio,
> +			    gfp_t gfp)
> +{
> +	return NULL;

Ditto.

> +}
> +#endif
> +
> +static void shmem_unused_huge_add(struct inode *inode, struct folio *folio,
> +				  gfp_t gfp)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> +	int nid = folio_nid(folio);
> +	struct mem_cgroup *memcg = NULL, *old_memcg = NULL;
> +
> +	memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, gfp);
> +	if (IS_ERR(memcg))
> +		return;
> +
> +	spin_lock(&info->lock);
> +	if (!list_empty(&info->shrinklist)) {
> +		/* isolated on scan list, let shrink handle it */
> +		if (is_shmem_unused_huge_isolated(info))
> +			goto unlock;
> +
> +		if (info->shrinklist_nid == nid &&
> +		    info->shrinklist_memcg == memcg)
> +			goto unlock;
> +
> +		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
> +			     info->shrinklist_nid, info->shrinklist_memcg);
> +		old_memcg = shmem_get_and_clear_memcg(info);
> +	}
> +
> +	info->shrinklist_memcg = memcg;
> +	info->shrinklist_nid = nid;
> +	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
> +	memcg = NULL;
> +unlock:
> +	spin_unlock(&info->lock);
> +	mem_cgroup_put(old_memcg);
> +	mem_cgroup_put(memcg);
> +}
> +
> +static void shmem_unused_huge_del(struct inode *inode)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> +	struct mem_cgroup *memcg = NULL;
> +
> +	spin_lock(&info->lock);
> +	if (!list_empty(&info->shrinklist)) {
> +		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
> +			     info->shrinklist_nid, info->shrinklist_memcg);
> +		memcg = shmem_get_and_clear_memcg(info);
> +	}
> +	spin_unlock(&info->lock);
> +
> +	mem_cgroup_put(memcg);
> +}
> +
> +struct shmem_unused_huge_scan {
> +	struct list_head list;
> +	struct shrink_control *sc;
> +};
> +
> +static enum lru_status shmem_unused_huge_isolate(struct list_head *item,
> +						 struct list_lru_one *lru,
> +						 void *arg)
> +{
> +	struct shmem_unused_huge_scan *scan = arg;
> +	struct shmem_inode_info *info;
> +	struct inode *inode;
> +	struct mem_cgroup *memcg = NULL;
> +
> +	info = list_entry(item, struct shmem_inode_info, shrinklist);
> +
> +	/*
> +	 * Use trylock to avoid ABBA deadlock: add/del path takes info->lock
> +	 * before the list_lru bucket lock, while here the order is reversed.
> +	 */
> +	if (!spin_trylock(&info->lock))
> +		return LRU_SKIP;
> +
> +	/* pin the inode */
> +	inode = igrab(&info->vfs_inode);
> +	/* inode is about to be evicted */
> +	if (!inode) {
> +		list_lru_isolate(lru, item);
> +		memcg = shmem_get_and_clear_memcg(info);
> +		spin_unlock(&info->lock);
> +		mem_cgroup_put(memcg);
> +		return LRU_REMOVED;
> +	}
> +
> +	list_lru_isolate(lru, item);
> +	memcg = shmem_get_and_clear_memcg(info);
> +	set_shmem_unused_huge_isolated(info);
> +	list_add_tail(&info->shrinklist, &scan->list);
> +	spin_unlock(&info->lock);
> +	mem_cgroup_put(memcg);
> +
> +	return LRU_REMOVED;
> +}
> +
> +static bool is_shmem_unused_huge_match(struct folio *folio,
> +				       struct shrink_control *sc)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	bool match;
> +
> +	/*
> +	 * Only non-root memcg reclaim needs to match the folio charge against
> +	 * sc->memcg. Skip the folio memcg check for the following cases:
> +	 * 1. shmem quota reclaim (sc == NULL)
> +	 * 2. global shrinker reclaim
> +	 * 3. root memcg reclaim
> +	 */
> +	if (!sc || !sc->memcg || mem_cgroup_is_root(sc->memcg))
> +		return true;
> +
> +	if (folio_nid(folio) != sc->nid)
> +		return false;
> +
> +	memcg = get_mem_cgroup_from_folio(folio);
> +	match = memcg == sc->memcg;
> +	mem_cgroup_put(memcg);
> +
> +	return match;
> +}
> +
> +static void shmem_unused_huge_drop(struct inode *inode)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +
> +	spin_lock(&info->lock);
> +	list_del_init(&info->shrinklist);
> +	spin_unlock(&info->lock);
> +}
> +
> +static void shmem_unused_huge_requeue(struct inode *inode, struct folio *folio)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> +	struct mem_cgroup *memcg;
> +	int nid = folio_nid(folio);
> +
> +	memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
> +	if (IS_ERR(memcg))
> +		goto drop;

You can just call shmem_unused_huge_drop(), then remove the 'goto'.

> +
> +	spin_lock(&info->lock);
> +	/* Requeue the inode to shrinklist */
> +	list_del_init(&info->shrinklist);
> +	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
> +	info->shrinklist_memcg = memcg;
> +	info->shrinklist_nid = nid;
> +	memcg = NULL;
> +	spin_unlock(&info->lock);
> +	mem_cgroup_put(memcg);

Seems you can remove the 'memcg = NULL' and 'mem_cgroup_put'.

> +	return;
> +
> +drop:
> +	shmem_unused_huge_drop(inode);
> +}
> +
>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>   		struct shrink_control *sc, unsigned long nr_to_free)
>   {
> -	LIST_HEAD(list), *pos, *next;
> +	struct shmem_unused_huge_scan scan;
>   	struct inode *inode;
>   	struct shmem_inode_info *info;
>   	struct folio *folio;
> -	unsigned long batch = sc ? sc->nr_to_scan : 128;
> +	struct list_head *pos, *next;
>   	unsigned long split = 0, freed = 0;
>   
> -	if (list_empty(&sbinfo->shrinklist))
> -		return SHRINK_STOP;
> -
> -	spin_lock(&sbinfo->shrinklist_lock);
> -	list_for_each_safe(pos, next, &sbinfo->shrinklist) {
> -		info = list_entry(pos, struct shmem_inode_info, shrinklist);
> -
> -		/* pin the inode */
> -		inode = igrab(&info->vfs_inode);
> -
> -		/* inode is about to be evicted */
> -		if (!inode) {
> -			list_del_init(&info->shrinklist);
> -			goto next;
> -		}
> -
> -		list_move(&info->shrinklist, &list);
> -next:
> -		sbinfo->shrinklist_len--;
> -		if (!--batch)
> -			break;
> -	}
> -	spin_unlock(&sbinfo->shrinklist_lock);
> +	INIT_LIST_HEAD(&scan.list);
> +	scan.sc = sc;
> +	if (sc)
> +		list_lru_shrink_walk(&sbinfo->shrinklist, sc,
> +				     shmem_unused_huge_isolate, &scan);
> +	else
> +		list_lru_walk(&sbinfo->shrinklist, shmem_unused_huge_isolate,
> +			      &scan, 128);
>   
> -	list_for_each_safe(pos, next, &list) {
> -		pgoff_t next, end;
> +	list_for_each_safe(pos, next, &scan.list) {
> +		pgoff_t folio_end, end;
>   		loff_t i_size;
>   		int ret;
>   
>   		info = list_entry(pos, struct shmem_inode_info, shrinklist);
>   		inode = &info->vfs_inode;
>   
> -		if (nr_to_free && freed >= nr_to_free)
> -			goto move_back;
> -

Why move this logic? If this fixes anything, then a separate fix patch 
would be clearer.

>   		i_size = i_size_read(inode);
>   		folio = filemap_get_entry(inode->i_mapping, i_size / PAGE_SIZE);
>   		if (!folio || xa_is_value(folio))
> @@ -781,13 +972,25 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>   		}
>   
>   		/* Check if there is anything to gain from splitting */
> -		next = folio_next_index(folio);
> +		folio_end = folio_next_index(folio);
>   		end = shmem_fallocend(inode, DIV_ROUND_UP(i_size, PAGE_SIZE));
> -		if (end <= folio->index || end >= next) {
> +		if (end <= folio->index || end >= folio_end) {
>   			folio_put(folio);
>   			goto drop;
>   		}
>   
> +		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
> +			shmem_unused_huge_requeue(inode, folio);
> +			folio_put(folio);

Maybe keeping the 'move_back' label would be clearer? since you've added 
several places to requeue the inode.

> +			goto put;
> +		}
> +
> +		if (nr_to_free && freed >= nr_to_free) {
> +			shmem_unused_huge_requeue(inode, folio);
> +			folio_put(folio);
> +			goto put;
> +		}
> +
>   		/*
>   		 * Move the inode on the list back to shrinklist if we failed
>   		 * to lock the page at this time.
> @@ -796,34 +999,33 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>   		 * reclaim path.
>   		 */
>   		if (!folio_trylock(folio)) {
> +			shmem_unused_huge_requeue(inode, folio);
> +			folio_put(folio);
> +			goto put;
> +		}
> +
> +		if (!is_shmem_unused_huge_match(folio, scan.sc)) {
> +			folio_unlock(folio);
> +			shmem_unused_huge_requeue(inode, folio);
>   			folio_put(folio);
> -			goto move_back;
> +			goto put;
>   		}
>   
>   		ret = split_folio(folio);
>   		folio_unlock(folio);
> -		folio_put(folio);
>   
>   		/* If split failed move the inode on the list back to shrinklist */
> -		if (ret)
> -			goto move_back;
> +		if (ret) {
> +			shmem_unused_huge_requeue(inode, folio);
> +			folio_put(folio);
> +			goto put;
> +		}
>   
> -		freed += next - end;
> +		freed += folio_end - end;
>   		split++;
> +		folio_put(folio);
>   drop:
> -		list_del_init(&info->shrinklist);
> -		goto put;
> -move_back:
> -		/*
> -		 * Make sure the inode is either on the global list or deleted
> -		 * from any local list before iput() since it could be deleted
> -		 * in another thread once we put the inode (then the local list
> -		 * is corrupted).
> -		 */
> -		spin_lock(&sbinfo->shrinklist_lock);
> -		list_move(&info->shrinklist, &sbinfo->shrinklist);
> -		sbinfo->shrinklist_len++;
> -		spin_unlock(&sbinfo->shrinklist_lock);
> +		shmem_unused_huge_drop(inode);
>   put:
>   		iput(inode);
>   	}
> @@ -836,7 +1038,7 @@ static long shmem_unused_huge_scan(struct super_block *sb,
>   {
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>   
> -	if (!READ_ONCE(sbinfo->shrinklist_len))
> +	if (!list_lru_shrink_count(&sbinfo->shrinklist, sc))
>   		return SHRINK_STOP;
>   
>   	return shmem_unused_huge_shrink(sbinfo, sc, 0);
> @@ -847,21 +1049,21 @@ static long shmem_unused_huge_count(struct super_block *sb,
>   {
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
>   
> -	/*
> -	 * The per-superblock shrinklist is filesystem-global and does not
> -	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> -	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> -	 * shrink_slab_memcg() to avoid queueing duplicate global work.
> -	 */
> -	if (!mem_cgroup_shrink_is_root(sc))
> -		return 0;
> -
> -	return READ_ONCE(sbinfo->shrinklist_len);
> +	return list_lru_shrink_count(&sbinfo->shrinklist, sc);
>   }
>   #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
>   
>   #define shmem_huge SHMEM_HUGE_DENY
>   
> +static void shmem_unused_huge_add(struct inode *inode, struct folio *folio,
> +				  gfp_t gfp)
> +{
> +}
> +
> +static void shmem_unused_huge_del(struct inode *inode)
> +{
> +}
> +
>   static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>   		struct shrink_control *sc, unsigned long nr_to_free)
>   {
> @@ -1417,14 +1619,7 @@ static void shmem_evict_inode(struct inode *inode)
>   		inode->i_size = 0;
>   		mapping_set_exiting(inode->i_mapping);
>   		shmem_truncate_range(inode, 0, (loff_t)-1);
> -		if (!list_empty(&info->shrinklist)) {
> -			spin_lock(&sbinfo->shrinklist_lock);
> -			if (!list_empty(&info->shrinklist)) {
> -				list_del_init(&info->shrinklist);
> -				sbinfo->shrinklist_len--;
> -			}
> -			spin_unlock(&sbinfo->shrinklist_lock);
> -		}
> +		shmem_unused_huge_del(inode);
>   		while (!list_empty(&info->swaplist)) {
>   			/* Wait while shmem_unuse() is scanning this inode... */
>   			wait_var_event(&info->stop_eviction,
> @@ -2532,28 +2727,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   
>   alloced:
>   	alloced = true;
> -	if (folio_test_large(folio) &&
> -	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
> -					folio_next_index(folio)) {
> -		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> -		struct shmem_inode_info *info = SHMEM_I(inode);
> -		/*
> -		 * Part of the large folio is beyond i_size: subject
> -		 * to shrink under memory pressure.
> -		 */
> -		spin_lock(&sbinfo->shrinklist_lock);
> -		/*
> -		 * _careful to defend against unlocked access to
> -		 * ->shrink_list in shmem_unused_huge_shrink()
> -		 */
> -		if (list_empty_careful(&info->shrinklist)) {
> -			list_add_tail(&info->shrinklist,
> -				      &sbinfo->shrinklist);
> -			sbinfo->shrinklist_len++;
> -		}
> -		spin_unlock(&sbinfo->shrinklist_lock);
> -	}

Why move this additional logic down?

>   	if (sgp == SGP_WRITE)
>   		folio_set_referenced(folio);
>   	/*
> @@ -2582,6 +2755,15 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>   		error = -EINVAL;
>   		goto unlock;
>   	}
> +
> +	if (alloced && folio_test_large(folio) &&
> +	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) < folio_next_index(folio)) {
> +		/*
> +		 * Part of the large folio is beyond i_size: subject
> +		 * to shrink under memory pressure.
> +		 */
> +		shmem_unused_huge_add(inode, folio, gfp);
> +	}
>   out:
>   	*foliop = folio;
>   	return 0;
> @@ -3058,6 +3240,10 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>   	if (info->fsflags)
>   		shmem_set_inode_flags(inode, info->fsflags, NULL);
>   	INIT_LIST_HEAD(&info->shrinklist);
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	info->shrinklist_memcg = NULL;
> +	info->shrinklist_nid = -1;
> +#endif
>   	INIT_LIST_HEAD(&info->swaplist);
>   	cache_no_acl(inode);
>   	if (sbinfo->noswap)
> @@ -4924,6 +5110,9 @@ static void shmem_put_super(struct super_block *sb)
>   #endif
>   	free_percpu(sbinfo->ino_batch);
>   	percpu_counter_destroy(&sbinfo->used_blocks);
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	list_lru_destroy(&sbinfo->shrinklist);
> +#endif
>   	mpol_put(sbinfo->mpol);
>   #ifdef CONFIG_TMPFS_XATTR
>   	simple_xattr_cache_cleanup(&sbinfo->xa_cache);
> @@ -5017,8 +5206,11 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
>   	raw_spin_lock_init(&sbinfo->stat_lock);
>   	if (percpu_counter_init(&sbinfo->used_blocks, 0, GFP_KERNEL))
>   		goto failed;
> -	spin_lock_init(&sbinfo->shrinklist_lock);
> -	INIT_LIST_HEAD(&sbinfo->shrinklist);
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (list_lru_init_memcg(&sbinfo->shrinklist, sb->s_shrink))
> +		goto failed;
> +#endif
>   
>   	sb->s_maxbytes = MAX_LFS_FILESIZE;
>   	sb->s_blocksize = PAGE_SIZE;


