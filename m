Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA29C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9056B0092; Thu, 30 Jul 2026 04:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8925E6B0093; Thu, 30 Jul 2026 04:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8206B0095; Thu, 30 Jul 2026 04:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53F8F6B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:58:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57FD5C08D5
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:58:47 +0000 (UTC)
X-FDA: 85044842694.14.9CBE9D1
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E94E100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:58:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myBJjWXk;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785401925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFhMzfQqyefJXEYJAjFh+5rGJKRIhpAgY51DG4j2Pi0=;
	b=PVT7kf1d2x34Q6ZeMgtHViu9WocjW7dskl9EbjCsewgVJAoZXDM+sxah3WZliUHe6uGf/G
	pfGiL4GgsXcjS/NN6m+neg2N262plUaPyHw1QQw61hAIbe7Pw/jj+p0lYPX1aXbeEGuAuM
	GxuwlgwCN7nkny+ERuqJUV7cAfsuv1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785401925;
	b=guP5Y1cGMcC9T+njhZN05Voze7ofc7LsSr4NWyKMivnnrYxy2+44fEImi8BOSZcJxgymoI
	R48K0I7clThVMn1GM57QRS6TFZnRZM3/lHl0ITmMA5i37J5xt9YofVP9EZr110xzKn1Jzp
	XNy5D13PERJzfGgpx81dzCGtveF/FR0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myBJjWXk;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <9c7efd5f-f8d3-4926-acb4-34c326ffb1c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785401920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AFhMzfQqyefJXEYJAjFh+5rGJKRIhpAgY51DG4j2Pi0=;
	b=myBJjWXkQnmr9W3gwI1XddrkrmhyZuAF6cALo5kfamQOvLGiTcGR6mEJjcBsosQO5yyInI
	NBoyPGLMi6D7XYrlxORwUWUA4OGdgieRuwzm3yMz9sK3z/RFzmF3GdVb34DaR8pJVGgw43
	2Wymy3dvUCJadYLPDxBg0KzYiKxOPhg=
Date: Thu, 30 Jul 2026 16:58:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
 dgc@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 cgroups@vger.kernel.org, clm@fb.com, dsterba@suse.com, hannes@cmpxchg.org,
 hughd@google.com, jack@suse.cz, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
References: <20260715103516.2410175-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4E94E100006
X-Stat-Signature: dg5xxenkchex7gcoh1cq6jbnttt6cg6h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785401923-722322
X-HE-Meta: U2FsdGVkX1+jIOUqbdrqsUkrEvdIYdFKKe4NljJeYfUfw/BgR1olxlSMUQovjEwFqaPuo8H1Omqst1JTMkK6Sv+54QivBNUcX+L+tyapSkz/mFURnodOa9mI0gkbnwkVzM82GqQiFW/V8gp1GSqvJJ6HPHahWotdWz/Wno2/vOrvfBTnwKYVixgsdOaMY9zNbUQojfz3a5vG/+e1B/R5Bk6yLm7Ty3VRZAcEWmoK4yyy1y5zx599YI2stm6EjtrNrJCYNrFxD58mVptOMkleXJGMPUaeMUetK6wmuBdj7UMB9AXyCbyhlJQSxXqKg/A7lyDWxEDRf3zi/w1oJeEnsoK/yZ2I14JBeIYh9WMjFlmO88OTFAKgeqqFccb2KWbh6T7hZTxu/zA8gw9Qdh/a2LJ22+vLHXQdz41GniOvEfmgp8i5CgSJORMdCYqKvKvWjNzWx62RYanqc8oBPZj6OnxwH1x0LrrfW0y3Ynu9362pTkDjksPKmDjnID+YSyVjvyCLrnW1hXWJIFjdSwww1oxZRKUvPzrNoJBU5n17YoTd5lfuM9eWOodWGv53TmtzMAznXAGZn/ptfcqT8+PyfYXTHXPa7tofclYmWmtv06ymUsBh/Go0SL8KgH616yvQVPvs4rUx4vc0uzFpKjxs3ko1eWf2InRh5e66OBh9araf55n8eWPQxCPxvVxi11miKmCitnYT/4S2dpgz4I/0cjR0cITYXD9CK+KSai8Dzwy3HZG+lIMkZndQ866DmsWEMgCp13VeA8YP2pjO+XVTFQDNrjH17zSmaicE151JnMDtmCxxRxrb0Pq5szwTfwqjJc4jTgoYMC8sRQjBYFg/Q0Sl3ShB9CsIVMPQfTfytZ8CCvHaoTBYiM87qpAn9beUxt+KTvFdm6zpESoCe+RBFqRaJvRyJL6dCfugZQzuq1Oz2NKURRKD7xbx2yo/yW06VG3Wa8FA3eQFhqe3IZR
 ezOPtrMc
 ppjeBkaUmV1ULd9R9MS6+TRI24UOO9z6LZnH6bbhSRy2eKDR4tDpPZtkh7CHhPiAG9hQvnV8txFJiC2uhVwbhFuMGtbymRbvf6jIHmRuNvQBjXkrybUZ6U5+/MnCc8SRwI+cd2jn4DOoz76P/LVgxqDrB6raXUddtqbgub5GQW+sGowfsDFRx8FVnuCV5CWBtk6WuoquTuVdIIFyJQvz/IhmYISH5W4aDsyic4T1gArMG9YdpNsljpEn4563JNVGt883l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/15/26 6:35 PM, Usama Arif wrote:
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
>    intentionally driven from per-memcg contexts to free memcg-charged
>    slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>    filesystem callbacks don't open-code "sc->memcg is NULL or root".
>    (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---
>   fs/btrfs/super.c           | 10 ++++++++++
>   fs/super.c                 | 19 ++-----------------
>   include/linux/memcontrol.h | 21 +++++++++++++++++++++
>   mm/shmem.c                 | 10 ++++++++++
>   4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..cc4537435399 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -22,6 +22,7 @@
>   #include <linux/namei.h>
>   #include <linux/miscdevice.h>
>   #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>   #include <linux/slab.h>
>   #include <linux/ratelimit.h>
>   #include <linux/crc32c.h>
> @@ -2434,6 +2435,15 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>   	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>   	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
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
>   	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
>   
>   	return nr;
> diff --git a/fs/super.c b/fs/super.c
> index d2d04a6f4f84..a8fd61136aaf 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -24,7 +24,6 @@
>   #include <linux/export.h>
>   #include <linux/slab.h>
>   #include <linux/blkdev.h>
> -#include <linux/memcontrol.h>
>   #include <linux/mount.h>
>   #include <linux/security.h>
>   #include <linux/writeback.h>		/* for the emergency remount stuff */
> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>   	wake_up_var(&sb->s_flags);
>   }
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

Hi Christian, it looks like you missed this when pushing. The commit
0ef8faff490be (next-20260729) doesn't include this part of the code.

Thanks,
Qi


