Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E5BC624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3B16B008A; Mon, 31 Aug 2026 22:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0659F6B008C; Mon, 31 Aug 2026 22:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDD56B0098; Mon, 31 Aug 2026 22:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB3B16B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:21:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 196251401CB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:47 +0000 (UTC)
X-FDA: 85163592654.10.B860C70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 496631C0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:21:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=upJeo5zI;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWr57L9oQWg5Rjw3gYY7rn/3MsiJaWLvKVzqZAGClQk=;
	b=CpktsBeaRQYxlZ9+Wh8tuu/PpHwM2mCwd+OXPTJBW7h9wjFmoA0qtTBeH5webqOef0geIH
	+d4dKrXf5QI/LRE3ySs7K9Nz7HX8vgjkuXjlYcKqdwcaahzQJ4G4sGAacm2Kwzr7TGroMz
	AmwSWhsqjmsLBDzZLonQcy/mU8r/7k0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788229305;
	b=XZ/JxpTvyZSCRvPq9wAPcqLde2ut8cvoqqU9lRXMXRYN+23dGZ055V/iEGfV7QTUHxiA89
	H6fSoQ/A7nPd2wjZl/Tu/Ycy4rnwUZBwTGwMUjMXfwijPH8X090mcHWKSmDRVlxHN6mwwd
	fN+6DnJHh9RaRJFdF75OwwA3XyMDS04=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=upJeo5zI;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25C06406BE;
	Tue,  1 Sep 2026 02:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF76C1F000E9;
	Tue,  1 Sep 2026 02:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788229304;
	bh=nWr57L9oQWg5Rjw3gYY7rn/3MsiJaWLvKVzqZAGClQk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=upJeo5zIxIAvCAPdVQuUdyj7fypAMNl4Dqyc84799yqVN2YblxJrWX3iJA7YGyTDr
	 oP4icuiCT+8aUOck8bF09Hxcodyczxkpdy8liaw97r+ZQjE+JO0bwMiHe3fW/CREsl
	 lAPKhrnw/2DCBHAr3zsUs/pN2up5ujeCSasvyrL0=
Date: Mon, 31 Aug 2026 19:21:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
Message-Id: <20260831192143.84da447c4fa2afb60757afa4@linux-foundation.org>
In-Reply-To: <c1ad6e39-3b21-413c-ad02-f90cfc4102f9@linux.dev>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
	<3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
	<20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
	<eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
	<20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
	<c1ad6e39-3b21-413c-ad02-f90cfc4102f9@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: agz17uib3cmxq7kuebs7c44k7k3p4867
X-Rspamd-Queue-Id: 496631C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788229305-147107
X-HE-Meta: U2FsdGVkX19hf7usk2dL50LCzxvah9NdPbHkqyDLNyTPQTuBu9qLpL2c5lHoxzAxMfk+aWq7VI1BCJAEd1sCpCa40F0xEaZPoKXeiH7vn/CAdcWAswasZjyImQQfliBy+lwMZIg4pDYpkSClfhf/MzPRG37xUNqfsaVnQ8qlCGP8b7ZAes3+dd1UK5JXrdfOocidQCPrEGa6BQBViYWnSnClrjPjR8KlyGq5mRMsklTPlyNOF1QnpxteauaZNtbpuJQatvT5DaoUBUqjG+P6hzo84v/2k/y8DKJXNIN9arPnj48oyr2R0Yx+L4UGT3fQyAjLUwcZomv2eOJeTGw3ZhOKktAxIhvVHAsA8al3yHxUOt3sKBRzWinoJk3RyAnbpn+5WLC5+HrWPMSdLtMiITV8O4f6+Wp+KwEM3dL9S02xl9jvi/HKa7rW1U74eRVrScdmUJ9TfwffguAYRmnWfMKyOGJ7r+gCin+wRBCV1VQIVJ5/Ev+50e03XSEr/ZvwU3Y5hVflWMaKTOZ34wUAnVxMJtQ26vLt6520necLlCrP9tnZP8IUMqqi5OGlB9fItQnamcAMY9kGP/tCvGzz4znb+Bu15Ph4We+UEoRB+3Y5qzJmMiT9ohzTmT66pRUA4nwFCOdA8adWyANU+t24igmTew4LOUHnLip7J/MBYPY7zrL+1JCOWgjJ08ODx+ly/ETBuQB+gFhlDRSibUZVFoBfMeVo04jSRlOVM3J8lBs5cnSwlRMD0bb+p5eT05lst9xsRZarFuIYHnM5J0n6V7Cotor4xyPs66MgpysO+yq0XW9f+kks32crhPnmnkwvdYTujNffREPSAue4lD85ekJ0ZmnbqeuPvCGIqAq3cR5rw7JbfCdPx0gh04TULxPGXm6fUPUBH4q93epCCy7z69h97aKPnZHoj5tztw2PimDNfpILJMYfeeDMsF5gIqxS2Mlvx3jBEuqdxERTDal
 3z35AaR5
 e+3am2czL5a5k/+amb6w9XsXU32Qp9l3PMeFyUWm2vuf5lv30ht7DnyYuGKeqoa3ewSqvwlIwth9pYe5irrzLrkcd8VGfkhghxbcFmxX5By12x5X6x+w5IhnkkNoCk33AHaB37tZ1Xo5pb76W6MSQCEZJNA5NpcXrmcD09wetny2OSBIbBQM7YWpdzEIorWIPRlX8eHiZxlpllT7zRK2sUYx0IE0122b7J8/w8LxqHO7KDHHjj9YfrVKSwbTPRo45GeBrBSUkwrOgKys+z+rDPvZN7ZOZJwsMCCFifXShJmY+fBtA0i71/PPYZb9A88lZrRUp56WegroMgQsdHv9hAg37A/RnR++ea3su7sQD4wMZ3oRoMLhHE9dkqSpqvA5d7TZ167I7Uwy55WjWUjVJeF8riaHZ8HaWMYprkV8Yk0Aq9UlRAaYkHb+Bo2i6B57/8ua70Y/oODfUirIeSR3gTL4AM4fUvuBy7fRKRT6FMm1QNWyRxmQAhViPeoEvT8Am41me8lX+OnFuLnWcy5fcVmb/Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 10:28:00 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> > OK, please add this info to this patch's changelog.  Please also decide
> > whether a cc:stable should be added and if so, ensure the changelog
> > makes clear why we're recommending a backport.
> > 
> > As part of this, let's expand on "XFS will also run into issues".
> 
> How about this instead:
> 
> ---
> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> individual filesystems") was meant to drop the blanket memcg gate in
> fs/super.c and let each ->nr_cached_objects() implementation decide
> for itself whether it is meaningful in per-memcg reclaim. However,
> when that patch was applied the removal of super_fs_objects_eligible()
> and its two call sites in super_cache_scan() / super_cache_count() was
> lost, so the helper is still gating every ->nr_cached_objects() hook
> and 0ef8faff490be is effectively a no-op.
> 
> Consequences of the leftover gate:
> 
>    - XFS's inode-reclaim hook, which is intentionally driven from
>      per-memcg contexts to free memcg-charged slab, is still
>      short-circuited in fs/super.c — exactly the regression from
>      commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
>      nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
>      written to undo. Memcg-charged XFS inode slab therefore keeps
>      piling up under per-memcg pressure until global reclaim kicks in.
> 
>    - Any future ->nr_cached_objects()/->free_cached_objects() that
>      grows memcg awareness is likewise blocked before it can run, so
>      filesystems cannot opt in to per-memcg reclaim on their own —
>      defeating the whole point of pushing the gating decision down
>      into the callbacks.
> 
> Drop the leftover helper and its call sites so the intent of
> 0ef8faff490be actually takes effect.
> 
> Fixes: 0ef8faff490be ("fs: push nr_cached_objects memcg gating into 
> individual filesystems")
> Cc: stable@vger.kernel.org
> ---
> 
> Can you fix up the commit message directly on your end? Let me know if
> you prefer me to spin a v5 instead.

Thanks.  I pasted this in and turned your [1/4] into a standalone patch
for mm-hotfixes, with a cc:stable.

The remaining three patches I turned into a separate series for the
next merge window.

This particular patch has no evidence of reviewer input yet?


From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: fs: fix missed removal of super_fs_objects_eligible()
Date: Mon, 17 Aug 2026 17:03:25 +0800

Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
individual filesystems") was meant to drop the blanket memcg gate in
fs/super.c and let each ->nr_cached_objects() implementation decide for
itself whether it is meaningful in per-memcg reclaim.  However, when
that patch was applied the removal of super_fs_objects_eligible() and
its two call sites in super_cache_scan() / super_cache_count() was
lost, so the helper is still gating every ->nr_cached_objects() hook
and 0ef8faff490be is effectively a no-op.

Consequences of the leftover gate:

   - XFS's inode-reclaim hook, which is intentionally driven from
     per-memcg contexts to free memcg-charged slab, is still
     short-circuited in fs/super.c  exactly the regression from
     commit 0baad6f9b997 ("fs/super: skip non-memcg-aware
     nr_cached_objects in memcg slab shrink") that 0ef8faff490be was
     written to undo. Memcg-charged XFS inode slab therefore keeps
     piling up under per-memcg pressure until global reclaim kicks in.

   - Any future ->nr_cached_objects()/->free_cached_objects() that
     grows memcg awareness is likewise blocked before it can run, so
     filesystems cannot opt in to per-memcg reclaim on their own 
     defeating the whole point of pushing the gating decision down
     into the callbacks.

Drop the leftover helper and its call sites so the intent of
0ef8faff490be actually takes effect.

Link: https://lore.kernel.org/cover.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/ [0]
Fixes: 0ef8faff490b ("fs: push nr_cached_objects memcg gating into individual filesystems")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/fs/super.c~fs-fix-missed-removal-of-super_fs_objects_eligible
+++ a/fs/super.c
@@ -172,19 +172,6 @@ static void super_wake(struct super_bloc
 }
 
 /*
- * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
- * operate on filesystem-global state and ignore sc->memcg. Driving them
- * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
- * per-cpu counters and queueing duplicate work: the actual reclaim happens on
- * the global path (kswapd or root direct reclaim) regardless. Restrict them
- * to that path.
- */
-static inline bool super_fs_objects_eligible(struct shrink_control *sc)
-{
-	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
-}
-
-/*
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
@@ -213,7 +200,7 @@ static unsigned long super_cache_scan(st
 	if (!super_trylock_shared(sb))
 		return SHRINK_STOP;
 
-	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
+	if (sb->s_op->nr_cached_objects)
 		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
@@ -274,8 +261,7 @@ static unsigned long super_cache_count(s
 		return 0;
 	smp_rmb();
 
-	if (sb->s_op && sb->s_op->nr_cached_objects &&
-	    super_fs_objects_eligible(sc))
+	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb, sc);
 
 	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
_


