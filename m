Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B98AC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893B76B00E1; Tue, 14 Jul 2026 11:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C656B00E2; Tue, 14 Jul 2026 11:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784936B00E3; Tue, 14 Jul 2026 11:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8006B00E1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:21:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2BB3803B8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:01 +0000 (UTC)
X-FDA: 84987745122.20.57D22E4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78CC0C0007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:20:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dASCRtRt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xIE1j4Cr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dASCRtRt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xIE1j4Cr;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=a7/hVinJZWgDXYFMC5wuYL/sR8rt2E/mE+R03ZTJOg6L07BbJdQSMvt77OE5DnvxccZ/+g
	0K/RUr7sU4wkwDt3LF7P4pirPF4dUcmaTC9WodgmpO7p1i8dDkuguLeyBrDqc7HW+fEBZV
	skJyvC/RyQZkh0Jn+vVhrdC6grx3CVs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dASCRtRt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xIE1j4Cr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dASCRtRt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xIE1j4Cr;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042459;
	b=BDLLlcANvJU1RTzTzc+k9HFWi2sWDRk7UpH5/gQwHVCdkPs55le8zwPCu3Jzq9QbtOX+Ly
	FTVqOn/7r1rS9Vcy5g0ttrwMtRCCVx7NUW/z2NwO46h7FSoIBg4r/2ug7xMhZxts4QG+bq
	DMN27KUVIvpQtdJRXXCly6SYmnIjtzk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8AB1C3E09;
	Tue, 14 Jul 2026 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784042457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=dASCRtRtL//gOyKnlywttPlWck8xL5wEGvxxYkQp+GLBVb2rYuh+DGwUc2nRYVlZOUDPmm
	wnFOEOtHrErBl+e8ffFFpOjtMSGZci8GJ4S0j0TKuxldeSqAs5ui1yJbWv5/HCtAhWRDn9
	z6R5ubb0NJj+8sTlcOmyNdlZO9mw54o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784042457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=xIE1j4CrqNVRYt8d6Dk4AJ1wPbp4OzW9GO1U+7vd/ZbLByovfW2xse3D6P3ox9jVuQNqoO
	7bvrJ3ceM2buSsBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784042457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=dASCRtRtL//gOyKnlywttPlWck8xL5wEGvxxYkQp+GLBVb2rYuh+DGwUc2nRYVlZOUDPmm
	wnFOEOtHrErBl+e8ffFFpOjtMSGZci8GJ4S0j0TKuxldeSqAs5ui1yJbWv5/HCtAhWRDn9
	z6R5ubb0NJj+8sTlcOmyNdlZO9mw54o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784042457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kptdctJwrqYn1JC5emwU/TK/4EX/o+cOyDQJ6bNpNg8=;
	b=xIE1j4CrqNVRYt8d6Dk4AJ1wPbp4OzW9GO1U+7vd/ZbLByovfW2xse3D6P3ox9jVuQNqoO
	7bvrJ3ceM2buSsBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A0B8779AE;
	Tue, 14 Jul 2026 15:20:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZnPZHNlTVmrnUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Jul 2026 15:20:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22BE9A1319; Tue, 14 Jul 2026 17:20:57 +0200 (CEST)
Date: Tue, 14 Jul 2026 17:20:57 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
Message-ID: <7yhd7nfbeukx5ycm4tpk2mc37b6cqpiw4q4gbf3elmtbfaoftb@txp5gavwasxv>
References: <20260714101454.1202449-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Stat-Signature: kqct91xtmo1w9wcrm5nt3xcnh1eggj49
X-Rspamd-Queue-Id: 78CC0C0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784042459-105018
X-HE-Meta: U2FsdGVkX1+sjmlExdZnj79VzDYx5d5PRD9GLP36WW+08h2wBJ+IgyFcbbLB7zM4dczv3BgKM2XjiPouZvaPJYdTjIAXY9QLc77iI2BoB19cNy4AAZyaeYvm/JYXyrSqOX9M47RRjkoq45eP4R9uQ42gcQJLylaTSdIlEyvtvWMU36xttPrlzpvgD7mFFsyL5D1BQjFQd4FD4Uk7JivFemQuCes1SeB/g0IP7AGpPW+26Y2rNwekRo2rFQ1Jx0CoGfMkAAKca+Uk2YkEZFsXvaqv/8lFJyr2DxLAZxqx2gZy/jNMpNsB+G3o3gvU1JSpOQygj25fJzYLs+uVz08gSpQY235uMw584dTHdRDvSNKoLDzASuLnJAdxBHU6NtbZnm2GKME554r1Ex793Ycvg1k623Xa+HqN/Ju12VFn2tQeNq8U9C5dY2TYsZBDH2FFtTWHkeuqL79xSgTpSWkagZKD2BKU84EJIuYbqiLzhGmP8VxbFAW8236+lQZrSMjxr62EVblq/Yc2NxU/C1xsIrYKY1xKXy47rgMBMU5zEiWYexP/bXnAO8Bfar3Tw9qTG6foma4ynJvM0InCoNqLP7Dh9YfcDO5UmYbBvRv/UzOg6wf51a6HCrFVg1XposdKUkl9edVPmFE1PzLaJTA/NKYmhdePo1AG+8NS+SP8FCK1JENGBhZK6WNPjcRZg3Pz672Mb4DScqzzkPAJ5Ow8X4hzG1TqL0vOUsn+uzqZc01sQ39dUTC26cSnfm1nK1rJY9+u/I0bIS181HaNBufeLmi3mLi+djVVLVWu+EAPL5IhZDhCqKLyDxuGVw4pTP7toX4JXBTUz4/LSDa3lyoj7PalM68pEhNLA/F1jk5rda+OLy7v+8VOyGCwIdHL4cOtX36J0vQXiXtTbfQ/Ve3YTUGJZyMuk4alOTyRTAD15K3hm8k6kcNSB40ah8HNx//osgxYhkXfCgnJIR0wXTF
 eTrrukYZ
 E2hSQ65y1GMAafzEIp9SbOZs2I7yJy7RgY2bfzvuDS4pccH5w4mziJ+kbALPTxLpXv6pOxMpafsIh9KJHHaqUiUUD0Ffa34EFEx99FIwA+9im8HX1q3YxHwrCgxInQdc4sFwJ6ilASG4v/2oj04lgcbbg9MjsuW3STjbxrJgYlARDUwxO4tlpIQKxlXj0fedupq4GJKaUuogKm3MSfQ6Xdg2Yg6/2eYkxgtMIGx7YgU5LTV4Am9MuSdYM+M8jkALdGEKKiRKmtvmssEfNcuqzb/uyvMgLBpbdAH8hP7IrNpKijEt0AYEjoMa5pWe85qJ90E2JY04d1CMymxBjGg+nZNdmWV3YEcoYBt4Hjw+oe03YI2PiXK8gdmetD1dt/Rz0+Q7zYBXGrsINkOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-07-26 03:14:54, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Makes sense to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/super.c   | 11 +++++++++++
>  fs/super.c         | 19 ++-----------------
>  fs/xfs/xfs_super.c | 12 ++++++++++++
>  mm/shmem.c         | 11 +++++++++++
>  4 files changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a7d804219bec..16c24bccc897 100644
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
> @@ -2434,6 +2435,16 @@ static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_contro
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
>  
> +	/*
> +	 * The evictable extent map counter is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
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
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index eac7f9503805..f0d8251fad3b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -54,6 +54,7 @@
>  #include "scrub/rcbag_btree.h"
>  
>  #include <linux/magic.h>
> +#include <linux/memcontrol.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
>  #include <linux/fserror.h>
> @@ -1242,6 +1243,17 @@ xfs_fs_nr_cached_objects(
>  	/* Paranoia: catch incorrect calls during mount setup or teardown */
>  	if (WARN_ON_ONCE(!sb->s_fs_info))
>  		return 0;
> +
> +	/*
> +	 * The reclaimable inode count is filesystem-global and does not honour
> +	 * sc->memcg, so it is only meaningful on the global (kswapd or root
> +	 * direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
> +		return 0;
> +
>  	return xfs_reclaim_inodes_count(XFS_M(sb));
>  }
>  
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5789a0f5a346..3ba812e4f5ba 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -846,6 +846,17 @@ static long shmem_unused_huge_count(struct super_block *sb,
>  		struct shrink_control *sc)
>  {
>  	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
> +
> +	/*
> +	 * The per-superblock shrinklist is filesystem-global and does not
> +	 * honour sc->memcg, so it is only meaningful on the global (kswapd or
> +	 * root direct reclaim) shrink path. Skip the per-memcg iterations of
> +	 * shrink_slab_memcg() to avoid queueing duplicate global work and
> +	 * pinning the shrinker bit in every memcg's bitmap.
> +	 */
> +	if (sc->memcg && !mem_cgroup_is_root(sc->memcg))
> +		return 0;
> +
>  	return READ_ONCE(sbinfo->shrinklist_len);
>  }
>  #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

