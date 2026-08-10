Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED50C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B026B0098; Mon, 10 Aug 2026 06:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3086B0099; Mon, 10 Aug 2026 06:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F9C6B009B; Mon, 10 Aug 2026 06:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC7596B0098
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:20:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7341040555
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:20:05 +0000 (UTC)
X-FDA: 85084964370.22.571F60E
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B2C21C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:20:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGXDlnyO;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786357203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kxNcoz88gUTv2RyDdUD2oJ4g9y+1zQ1kNSN4EE2fzA=;
	b=hrT7e06ozSvyDifRumOa8mReEo4Jnf5bkZjLYZt+9l2N2k131Cw1mOrgkGh580UR1qC/ft
	9F6xT9GnTNqZUm+LTo3/7japr+CplqWrKxZsfB0+iyp/QhuWA8YOkzHec/5UZOsR+OFQgy
	jwrI+sl2p83msMxWQ7+l+1jD+f91BFo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fGXDlnyO;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786357203;
	b=L8OZX/GKZCnOH3x7wEIbO8qGGRfMFENRRtGjTC6oIY945oP7XQ7C9UwDfjjilBiH0/X1pq
	0qF/CwSBAMGlQ6B7ty6QyzpsTmvkoF6ejUo28qOcgpIIJyZzUQl/oi4li2WTxhAUWHhMJb
	7t3c2+RO8tMXqGJFDd8AuoLEJnnaPpw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786357201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2kxNcoz88gUTv2RyDdUD2oJ4g9y+1zQ1kNSN4EE2fzA=;
	b=fGXDlnyOZW78tBnMnlQ1tn0gaqx7mSxN8jnpxd3X5ZBs5A+AHB+T0i5Ka2ATUkpwOgnsv1
	KMqRp0Augsx1/HsaVXbYVEtsd6TD99UKyuJ+3mT8utVuks9GQoMS+0WK8+l44Y4crMrbtQ
	xIGnFQ0O2uyU8LD3THLBVtNK7IeoZsw=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@fromorbit.com,
	dgc@kernel.org,
	qi.zheng@linux.dev,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	cgroups@vger.kernel.org,
	clm@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	kernel-team@meta.com
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into individual filesystems
Date: Mon, 10 Aug 2026 03:19:52 -0700
Message-ID: <20260810101954.822260-1-usama.arif@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B2C21C0007
X-Stat-Signature: rqo9hqdc51mkrhaea1sdhmot4u7sc7z7
X-HE-Tag: 1786357203-390185
X-HE-Meta: U2FsdGVkX18m7xnWEtsXcN6lClNPumyVBoeL4N4tm/532swdY1VdCyU0KqWWYitc0zNumPSUdZsHujP2XWYhYpw0/J/ox9OxI9z8T9j1EvVMH+8SCEjg8+fxnEV9RGnQvRNLTKLHy3kxNK26lck8TD/bv5uSrRh2dnO7NyFzwfKoMDXn/ggnJBeN90cspoMXuVL8AGyQRLU8V1cKcDmyrgbmbAA8pIp3imxMOEhKrsUOYjxKTCkpMnxOCNFXVbmUakzEeh4ldQmFsZdl6L4cMnDR0jmxEpx+9v2Cx86afBA2UBeZR/CxPDXhV9AvC9zEdyVhTuarrIvot7xP4YX5wn4UetKnMS1O9Rhaq2YHXbpoeM7omn7l+8kiKy/+FAjXRVHT4giHOYr8lodDYok3oxliGJeJJI1ZO1kBhmxwE97zL7YvK+Vy1GXNBpm5HPutzzrgyvRUl9+qdvC6oQ49vHBVx2YoJjzqprMK8/+PYsr2S3YYXkun/0oblLIha+JyYpkvI+sq2XCe+dKMQOST/S3QU1e/vh+lIeXJPgUXx0vyX8tO/SuUj3iU+z9hxNRRKTbLxBD7vYoiJejYtfFmW50gIg/s20SW7ZUmgTHzYWSZwubEx9JW3w+6l7OQ70SK4zASsk7xtu46bI0wAQYUl901Gz924oiYebN1/dUcHAycrYut5nZF2F0Lt9PEP2UAWVqjmfDIkROagh+bsvpLCgYIwbsfPin8eHvjtDMc8BW+ItHAZYVicvXyT3rTdovX5wJLQgq91cDwdoIUO8aMPi5GczljGR4OOObipKGYDK3iIC2gjsjV1GIIy2ergc5M+HZNCkvuFW8gZV2qPafu7R0neRNvAzrJjUyAxYYNEXQDmxdt+pbBhvZ46nt5qg5PG3wpIXFgx9qESm+BpacI0fOzDMGMwbMnv3pHBYhLYo3gg31Krmod4FPCl3RqIUhWCHc104fnQsWaLx34u4G
 DCKuqR+t
 05kG7rHT8QuZz0Si2rx+RwoZfJIwY5R1Qde5okhaRUJF7wsS3lhwGeNugO+KfG20GfXSPl8gCzZD2wTQ3V/ghQYowKcV/zj8mvVd39Fd+uqNafgK+dgiqOpJ4scSITI2LO1bPgoXhxS0OTMYTjjioSDRdP36UkSgBsiqpNsksnKNxcIxYuBF3pF6bqU4DM3eqOpGgzgxsIt7L0mWsG5aLzH3VWcKEKCPLw03IUp4eYxyLZfYR6yJQR1nCfajTFFeeUIZnBAt8EJCh4JUswQV0AnyFEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 03:35:16 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skipped every
> ->nr_cached_objects() hook whenever the shrinker was invoked for a
> non-root memcg, on the assumption that none of them honour sc->memcg.
> 
> That assumption is wrong for XFS, whose inode-reclaim hook is
> intentionally driven from per-memcg contexts to free memcg-charged
> slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
> short-circuits that path.
> 
> Push the check down into the callbacks whose counters really are
> irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
> shmem_unused_huge_count() - and drop the fs/super.c gate. Each
> filesystem can now lift the restriction independently if its counter
> later grows memcg awareness, without touching fs/super.c.
> 
> Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
> callbacks don't open-code "sc->memcg is NULL or root".
> 
> Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Do not gate xfs_fs_nr_cached_objects(); XFS's inode reclaim is
>   intentionally driven from per-memcg contexts to free memcg-charged
>   slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>   filesystem callbacks don't open-code "sc->memcg is NULL or root".
>   (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---
>  fs/btrfs/super.c           | 10 ++++++++++
>  fs/super.c                 | 19 ++-----------------
>  include/linux/memcontrol.h | 21 +++++++++++++++++++++
>  mm/shmem.c                 | 10 ++++++++++
>  4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..cc4537435399 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -22,6 +22,7 @@
>  #include <linux/namei.h>
>  #include <linux/miscdevice.h>
>  #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>  #include <linux/slab.h>
>  #include <linux/ratelimit.h>
>  #include <linux/crc32c.h>
> @@ -2434,6 +2435,15 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
>  
> +	/*
> +	 * The evictable extent map counter is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work.
> +	 */
> +	if (!mem_cgroup_shrink_is_root(sc))
> +		return 0;
> +
>  	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>  
>  	return nr;
> diff --git a/fs/super.c b/fs/super.c
> index d2d04a6f4f84..a8fd61136aaf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,7 +24,6 @@
>  #include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/blkdev.h>
> -#include <linux/memcontrol.h>
>  #include <linux/mount.h>
>  #include <linux/security.h>
>  #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>  	wake_up_var(&sb->s_flags);
>  }
>  
> -/*
> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
> - * operate on filesystem-global state and ignore sc->memcg. Driving them
> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
> - * to that path.
> - */
> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
> -{
> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
> -}
> -
>  /*
>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>   * drop the last active reference to the superblock from within the shrinker.
> @@ -212,7 +198,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (!super_trylock_shared(sb))
>  		return SHRINK_STOP;
>  
> -	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
> +	if (sb->s_op->nr_cached_objects)
>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
> @@ -273,8 +259,7 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  		return 0;
>  	smp_rmb();
>  
> -	if (sb->s_op && sb->s_op->nr_cached_objects &&
> -	    super_fs_objects_eligible(sc))
> +	if (sb->s_op && sb->s_op->nr_cached_objects)
>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);

Hi Christian,


It looks like the changes in fs/super.c didnt make it into the patch that was
merged in vfs.fixes [1]. Just wanted to check how we could correct this?
Should Qi (or I) send a followup patch?

Thanks,
Usama

[1] https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=vfs.fixes&id=0ef8faff490be6aa1a1e5dfcb0c8492689e91c0f 

