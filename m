Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2612BCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF3B6B00B3; Wed, 24 Jun 2026 11:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196616B00BC; Wed, 24 Jun 2026 11:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ACFE6B00BD; Wed, 24 Jun 2026 11:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD2606B00B3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:18:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BF2F8D9AE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:18:46 +0000 (UTC)
X-FDA: 84915163452.23.8250D06
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DD2940006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:18:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NyWSt8ap;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782314324;
	b=irHlC2LRX2rGhPODwE6WZEC+3FL8dZzKGH/keThiZV2bwUjoptaf/MEeiXLAGieuWHzQwA
	NALOrodAtKgUVxfvgU07FZithCUIoZqyOlqEi6XGE4NT8qUvtI95XV+UEwumZL6mUdqolo
	/p5V9pRFOupp6Rmn/RHcH8IIBtep30g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782314324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCfveZ37ayRh458SUb8Vvs7csErWvvnNaK/RVVo+5fA=;
	b=HSyxElB7ZJYEDwuRUYfZyEvpIayd/aavSkdiCYJFCZJZZHJS3kth+btkkMI5y6/47OAD+j
	S2UIidVZev+IJlLPSAXMxhW4voyWn0UAoUguD2sRv5F+Da7z3MuiNQzlcPrJ8O1+5Y/33D
	/mPrxF45G1bMHaEG261wS4apFhCr+Y0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NyWSt8ap;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782314322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCfveZ37ayRh458SUb8Vvs7csErWvvnNaK/RVVo+5fA=;
	b=NyWSt8apc46t06T04zMNhMchtk3k4ctFbVCiL9c2mP9xyextgm4eGNBGZRMVtokC/pbQ24
	vU3kdqTh4LXr1cjm4Jsn6oIw3SoC6+9ZfRZnNtDC+QkC0X8TGfqVxfmzeu+69fJRhGzIhQ
	iIJdk2xZx2BxIFCIz9q4ErwI9vRQK1o=
Date: Wed, 24 Jun 2026 16:18:38 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <ajrHa_JGxQvCMf8t@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ajrHa_JGxQvCMf8t@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fbo6993ya1zr9eur5qxnmd4wffwb6fbp
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DD2940006
X-HE-Tag: 1782314324-8675
X-HE-Meta: U2FsdGVkX180fsDcJ6dDK7L+A6TFNp+PfWetF9uc8EIyzj6+H6KrrcSAVKjmg7UQ2HXuKKZw6qDUzyMcAxG1JOj8fWsZ9DWnrQ2dgXc5JntLv43Iu1xc+QHBi1IkhiJa3y6thmH9vWQ+t5jOZ4WuCWBoeZyMIduzlc0ca+fzr+xjntheE+l6ndogNQ8IJFjt6PkYiaroOTuLMDp/zeyF+ohiLXhd1WUD/OyS1UaA+tZCLhNEKhAVNNInX11TTueL9DG2ujmBNFisisDv/fExNG3UnAe+gMdtjGPlm2l3xnnPJEdTLCmn/nS0wSzT8YPTz+yPDLsxtoeSBTVewiCpW/cjgwR1kjAXQeIaQ3kvEPS0U0Pphz2tj13CWmvA6Bz6X6O+qWjbHWn3m+FWg+rK23lrzqm/5DJ9em5T9piKw3ry/yc2tj/CKKp37syrJ09Ykc/xYK5B1pk/EbBTFaIm/IAYPHsLsRw6nLRbPGzJe4yK3pQKHSwLrmPRIYt2NcW0wke0+OiAceovL7dkfHHzgVY0+CYVHwCqMCLtHm71ST1yd8NuSp4Pa8MsDU8cVKk1VvNyQDmakdGB9XJrsGq0Yy9FUYe+NfRTlnvg7nMhi9A7ldkzzQWWCiWSmKzwg6g1xJxmFMxdhU6arUIFtySeaMhvl6Aj7N44mfVuXIipgAlCV5wRujPqFnJV9llWvcFKW8J3VWErBScBaNEZ7cIer7N8Ul3vuH13w4VGIjwZBRDLeKD1suuWuhP9wqJkvTM8BqeTW5GUQ93sWYAtjpTERIyp2fWZcWUmS+SuDwQnWc9lLJxrAilqfS//2lHwzSx8C4mUEIeicd++kUWm8bVMkJz5DYY8nzerP1ztDBbqenM+T2uA+Yeyoiz0nFHON2EfgOwKBiIxJRsE9ckWqp/gn2/95Jz7tmQVNZJ1QxLwasLPzxFAW5iMhO9JPV7XYXLX+QjsJFjs02Mt3NM/Kl5
 LU0AF7rT
 V1ot/jk8qf7o+KnErDLs/PB64YZc/1iGutfryQ/zGErsGfDX8w3w29WH4Vp2MIiLHEk5Br9Y6GIHy2D8XZycYamZsoMK6++oSU1fDNBAO6iKJwzr5rGEgHGEblMpkTltx23YaXxiyp8fP0ZHEivh6ov3vtLOlLvInNaLpWy20/2ghkb1KfZm9GvU5VOX53g2IqhiLFn7B7jdCkJVXiKQrCHJPUJtrgm8W0iFPD1xT1pGDZYxx8LbiNaMU9jNfwT4KMHZoHMbqr35hhdNNeQzjfC0dECutt9yYyrDm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/06/2026 19:08, Shakeel Butt wrote:
> On Tue, Jun 09, 2026 at 05:30:47AM -0700, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
> 
> I see the underlying objects whose count is returned by ->nr_cached_objects()
> hook is memcg charged for shmem and xfs but not for btrfs. Do you envision
> there might be a rare scenario where we have a lot of memory charged to a memcg
> consumed by objects which ->nr_cached_objects() tracks and that memory becomes
> unreclaimable due to this patch?

Hello!

Thanks for the review.

For XFS, xfs_inode is SLAB_ACCOUNT, so a memcg can have memory charged in
XFS inodes sitting in XFS' internal reclaim state. But the current callback
does not target that memcg: xfs_fs_free_cached_objects() calls
xfs_reclaim_inodes_nr(), which walks the mount and reclaims
XFS_ICI_RECLAIM_TAG inodes without checking sc->memcg. So non-root memcg
reclaim was only getting an opportunistic mount-wide reclaim pass here; it
could reclaim the target memcg's inodes by chance, but it could just as well
reclaim inodes charged to other memcgs. This patch removes that cross-memcg
side effect, not a correct memcg-targeted reclaim path.

Those XFS inodes are still reclaimed by XFS' own reclaim worker, which is
queued when reclaimable inodes are tagged and requeues while reclaimable
inodes remain. With the default xfssyncd_centisecs value, that is about every
5 seconds. The root/global superblock shrinker path also continues to call
the XFS callbacks. This will keep the memory reclaimable.

For shmem, shrinklist_len counts inodes whose tail large folio could be                                                                                                                                                                                                                                                                                                                                               
split — splitting itself doesn't free anything; it just lets normal page                                                                                                                                                                                                                                                                                                                                              
LRU reclaim the truncated tail. The folios are on the memcg-aware LRU and                                                                                                                                                                                                                                                                                
will be aged/reclaimed there independently, so skipping the split from                                                                                                                                                                                                                                                                                   
memcg context just delays the split?

or btrfs extent maps, as you note, these objects are not memcg-charged.
> 
>>
>> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
>> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
>> whose bit is set in the per-superblock shrinker bitmap, which on a busy
>> host means hundreds of calls per reclaim pass. Each scan queues the same
>> global shrinker work item that's already kicked from the root path.
>>
>> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
>> the returned total stays positive even if a memcg's own dentry/inode LRUs
>> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
>> in the memcg bitmap, so subsequent reclaim passes from the same memcg
>> re-enter super_cache_count() and pay for the global counter walk again.
> 
> What is the main concern? Is it the amount of CPU wasted or are we over
> reclaiming or reclaiming from unrelated memcgs?
> 

The primary concern is wasted CPU. On the busy hosts where I saw this,
hundreds of memcgs all repeating that walk per reclaim pass is what made
it visible in profiles.

Another concern is misattribution. Reclaim from memcg X ends up
reclaiming another memcg Y, which could have an affect on Y and
won't provide proper isolation.

>>
>> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
>> or root). The memcg-aware dentry/inode LRUs keep being counted and
>> scanned per memcg as before; only the global fs-specific hooks are skipped.
>> The root/global shrink path still drives those hooks; only their
>> invocation from non-root memcg slab reclaim is removed.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I am fine with the stopgap but it would be nice to have proper memcg awareness
> in xfs and shmem callbacks. For btrfs, I am not sure if it makes sense to memcg
> charge btrfs_extent_map objects but at least to decision to skip memcg reclaim
> will be inside the fs callbacks i.e. nr_cached_objects.
> 

Agreed that this is the right long term approach. If the preference is to move this down to
the fs own callbacks instead of fs/super.c, I can do that in the revision as well.

