Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF71CC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 04:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F7E6B0005; Wed, 15 Jul 2026 00:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0036B0088; Wed, 15 Jul 2026 00:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6426B008C; Wed, 15 Jul 2026 00:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63EE46B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:32:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5EAAA05CF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:32:26 +0000 (UTC)
X-FDA: 84989739492.08.E38D010
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC02B100004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:32:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DazQEg7h;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784089945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJb00IhM4AP9SQyu/uM8pi/lNywYn049J8+hhjcsJ20=;
	b=3NgLZ/6qCWuOp3TOUymEwpdVmAY/lagmlNqvZkshf+eThVkvaPvval5JGBvgLdESqj7K1h
	F5YylJuHWGQ/3K2VtT5NQi1IRwYwC7MTGsRexJjGuOjaPa0wnFd4BkK/KTieJU0KCuoS4X
	1VS3cM8PhMyHZMY2HfVH5/ZNnvBBYH8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DazQEg7h;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784089945;
	b=uRv0VhG4l8Pac0HPHtSysAw71DLTvSNMHfGzs/mhshNV+9yMvU5hdBReIrwem7RKkK4k4f
	1ifzHDU8NFyQQ4JlXvJkVqVO5RaouhcWBzjxadWCvVvG1U3PYa9iOd8iymfu4X6Ry3p5Pd
	m4hv05rdsvn77KWqPe0Nxejo65w2LME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28492600BB;
	Wed, 15 Jul 2026 04:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55B61F000E9;
	Wed, 15 Jul 2026 04:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784089943;
	bh=gJb00IhM4AP9SQyu/uM8pi/lNywYn049J8+hhjcsJ20=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DazQEg7h5SLtFuAzos91uz6fXTBxBU4y/9fMfNWCFSv1Hy3rHXw2c/pPjuVoWqT5I
	 gnriYzJYQS4Ln0YWiMG5BrtP1O/vjwlH+ZYabPJuSp2pq9poh7onsgM3Tg9vkVyfQ1
	 xyd6/GYCnLXktkQdxKaxAFhLqtnnSGIcLNNfuuzk=
Date: Tue, 14 Jul 2026 21:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] mm: shmem: make unused huge shrinker memcg aware
Message-Id: <20260714213223.9a03d78f4aba252c512e01b9@linux-foundation.org>
In-Reply-To: <20260714031918.308-1-qi.zheng@linux.dev>
References: <20260714031918.308-1-qi.zheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC02B100004
X-Stat-Signature: m954zraqmme6qbwhatcgycf5hz1ybymj
X-HE-Tag: 1784089944-692155
X-HE-Meta: U2FsdGVkX19KZXnI+cpUaisnqdpthuVSacOKFqAVMwBSA5nHI08p7ybjtLx4TRQIa29JZmfE8ZzrKX0DrwtavCDfrfWh9s9DN8WkuGceR4oQhaxlLaSmWZRCTEqyB+5ZESM+ZZRx2glLPeLdpNZHNyft9cIiunvX1UNl855btU9VqY3wu5oHlQ2LJ3DVBkRYb4PZRhqTYjNNq26+03QaUXdQU2TtlSTwBL1R37eyNyMPTDc+Qht6Om1L2G8tTRruK182dYxvgx9Hoaz28pIfDGZ/SRrgH5Va+W52wlmxHQhUnKTR7eVBIzW35y3UqQhP8sLLYau+XDvD/pcTlO+RmiLqlCxDd5B/pE0b9sbaeA812KYRdh1YbEmafigl5qPzYkSFtaEJWWmhQFHcT4ZKdJh5AtxDzoOt+ugIhBvq9U2rHHDYA1GpNszs3VqFSTZrejTCmFGrMXRjZqRptzGvoSdhzCeu7KMduz0+5El3fWusWlg5Nk9GtgCo0CtmGCNU3nJRXdSlilvqHJZ3lsbPUs19Z9mVs1/bTin3YQ+hfvnDfNkimoyMuG5IoEFFuypHPH1Mw4H3mLA9sSNNEo2lO5dEyr0NzuUZJYAUcf60g3rLgo4WHQ/pRXwWHo3HrfukyHX3sKrsc9afIHJHvSYmCev+zdo6MNZuzKF823y53+q/SUgqY7w3y9lP58iORXt4N14xHe2a00FDkxtsPTvGve6tDKg1VNYhJCE2bTDXvVOrk7iAydrDyFAOoz4XadlKgKHGpED4WuQHvLVH/3FBvfajKQDNugki5rdGZvBb8IhngpqHZ2iUSmnFpj1ybAbp09PwhWNSVXqKszup52VMkns3S57OqPSt4dav06462vAGE8nrXcdwegMabTIbxdvln6blXHuyzxdkHNOOZoVdppty0efv3vTr0kvDdks+Tnn/Kjit9/DKYU5moom5O3vuSRtCJab9hUKjDyAUJVK
 d/upVgqD
 XWFyKL2br2nmQTS7cPTDRuYa4TeRGr3ch69GT8eyys749Iv3IjjZ1LgQ4HOI+YKFV7s3nQLGVCYM/onjCl+4/R2dRCkz/cN1hVq22LZCcfhD+tzIynEwNpZintZeBZ4D7WfUoAIzbmiircD48rIl9AKMu5qway5bir9GQ+cxtQk5lNrtB2oa32AWd0Mh4ZQzo7hoEOoSgYw6x/Y3hCU7V5c6jWizuzdhRPboA20Kg+gHPqyR2yPDkcJur7k1dyKQCMRip9gavhSvWrEavihgoNStU/4sjJb+FbOUWxhUcvhBu1o1gHFUbe91dheheWYvK1CtAqBobctxowCO7S0QMWQecEWo6JaLgHbLP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 11:19:18 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

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
>                before A scan        after A scan
>   base         A=64M, B=64M         A=0,  B=0
>   patched      A=64M, B=64M         A=0,  B=64M

Sashiko said a thing:
	https://sashiko.dev/#/patchset/20260714031918.308-1-qi.zheng@linux.dev

> This patch is based on next-20260701 because it doesn't include this patch:
> 
> https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/
>
> Later on, Usama will consider moving this restriction down into the fs callback.

I'm not understanding.  Was Usama's above patch ever included in
anything?

> -	unsigned long shrinklist_len; /* Length of shrinklist */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	struct list_lru shrinklist; /* List of shrinkable inodes */
> +#endif
>  	struct shmem_quota_limits qlimits; /* Default quota limits */
>  	struct simple_xattr_cache xa_cache;
>  };
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b06c1ae2f50c3..a17150e6107c6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -724,50 +724,252 @@ static const char *shmem_format_huge(int huge)
>  }
>  #endif
>  
> +static inline struct mem_cgroup *shmem_get_and_clear_memcg(struct shmem_inode_info *info)
> +{
> +	struct mem_cgroup *memcg = info->shrinklist_memcg;
> +
> +	info->shrinklist_memcg = NULL;
> +	info->shrinklist_nid = -1;
> +
> +	return memcg;
> +}

Explicit inlining shouldn't be needed - gcc will figure it out.

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
> +		if (info->shrinklist_nid == nid &&
> +		    info->shrinklist_memcg == memcg)
> +			goto unlock;
> +
> +		list_lru_del(&sbinfo->shrinklist, &info->shrinklist,
> +			     info->shrinklist_nid, info->shrinklist_memcg);
> +		old_memcg = shmem_get_and_clear_memcg(info);
> +	}
> +
> +	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
> +	info->shrinklist_memcg = memcg;
> +	info->shrinklist_nid = nid;

Totally pointless style thing: it's nice to fully initialize the object
before adding it to the list.

> +	memcg = NULL;
> +unlock:
> +	spin_unlock(&info->lock);
> +	mem_cgroup_put(old_memcg);
> +	mem_cgroup_put(memcg);
> +}
>
> ..,
>
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
> +	if (!spin_trylock(&info->lock))
> +		return LRU_SKIP;

Why the trylock?  Please add comment explaining its use.


> +	if (info->shrinklist_isolated) {
> +		spin_unlock(&info->lock);
> +		return LRU_SKIP;
> +	}
> +
> +	inode = igrab(&info->vfs_inode);
> +	if (!inode) {
> +		/*
> +		 * This inode is being evicted, just drop its stale active LRU
> +		 * entry.
> +		 */
> +		list_lru_isolate(lru, item);
> +		memcg = shmem_get_and_clear_memcg(info);
> +		spin_unlock(&info->lock);
> +		mem_cgroup_put(memcg);
> +		return LRU_REMOVED;
> +	}
> +
> +	info->shrinklist_isolated = true;
> +	list_lru_isolate(lru, item);
> +	memcg = shmem_get_and_clear_memcg(info);
> +	list_add_tail(&info->shrinklist_scan, &scan->list);
> +	spin_unlock(&info->lock);
> +	mem_cgroup_put(memcg);
> +
> +	return LRU_REMOVED;
> +}
> +
> +static bool is_shmem_unused_huge_readded(struct inode *inode)
> +{
> +	struct shmem_inode_info *info = SHMEM_I(inode);
> +	bool readded;
> +
> +	spin_lock(&info->lock);
> +	readded = info->shrinklist_isolated && !list_empty(&info->shrinklist);
> +	spin_unlock(&info->lock);
> +
> +	return readded;
> +}

The return value is out of date as soon as the lock is dropped?  A
comment explaining why this is OK would be helpful.

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
>
> ...
>

Generally speaking, the code seems a bit thin on comments explaining
why functions exist, why the code is doing a partucular thing, etc.


