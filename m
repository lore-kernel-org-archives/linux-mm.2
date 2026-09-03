Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7059AC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 19:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD2F6B0088; Thu,  3 Sep 2026 15:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA51B6B008A; Thu,  3 Sep 2026 15:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBCF86B008C; Thu,  3 Sep 2026 15:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A288F6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:34:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1393DC0674
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:34:31 +0000 (UTC)
X-FDA: 85173452742.24.CC01820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE9BF4000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:34:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Gbka91Sk;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788464069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEe0Xe4BGpisjWutg3Hd6ntpHOx/Gjz8x6DaZwu6w6I=;
	b=abKpqvkKp1o0CRGhYoQRkLBOpg8+pd+ng5op4bHlAopyZU/m7vWbhQaEIx6drS8ROtDHS3
	f1y7afGukQ8G74jBcbQU2J8kkKs3dyjRcIaedCyF94DoqnVT/s8RPcA0czZj5Vi32nHH2k
	kMD4Sq2amW9xjo0p9iy8Dz9aJ3DqV6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788464069;
	b=nPnTATjMCLmzccRJ5U0pNM+ZDltPy83n3Bnyly+G3ZRslHxYQvWL2ztf9PPXTPe1mo7PAU
	kVSqtylctNKi0EGVYd7uh1eYNpgInzgcvPs+dTgmmDW0G7jk8rUTnEo2Dt9HivFYUasVhS
	6KNDDN2HPidYQy2yO2Kk+pUYTjoILaY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Gbka91Sk;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23E546057A;
	Thu,  3 Sep 2026 19:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7616D1F00A3D;
	Thu,  3 Sep 2026 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788464067;
	bh=cEe0Xe4BGpisjWutg3Hd6ntpHOx/Gjz8x6DaZwu6w6I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Gbka91Sk8dHFzSVk+rS7sdjg/NU835GPWh8k5QJ1FOTqyrifht+DmIEQz7ZV98V+R
	 ZMyk+C44h1OmLiDxoEVLz7TBeY6QV6/heypUssRvfn7Fpqp+Lp/LwaYRpcc+60tjOP
	 jVq4CP/4n/HFTbW+75H5vG6rE8TqPeXSRjR6/e58=
Date: Thu, 3 Sep 2026 12:34:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, axboe@kernel.dk, tj@kernel.org, jack@suse.cz
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-Id: <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
In-Reply-To: <20260903083303.2769873-1-sunjunchao@bytedance.com>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE9BF4000E
X-Stat-Signature: sgnq468kwin16xdx8yea5k61wkzsugec
X-HE-Tag: 1788464068-484495
X-HE-Meta: U2FsdGVkX1+x2aolC3D8tBBPMAq/6CU6jwgMr27eTxbLwDf0NVLBJ3xpW9b7T6c5a8zBFTssj/dB4lWiEsYN973Ar7YorHJRlLue0ofBCpilIhpcInedF72zQSS/P0ZbLnW2ywxF1oeJcRWoLFBQzOLjCoLfoCxRGLFGMNlrsVBS70O1gcwDBvnXcoH2HsWcU9CBwtmRFQxmlp6Z30OsjWoIg71FQgzD7RdSIN8w2t4dK2hz1prGT83hcRRpYNg9t2kpk9DNUYy0JKafYlzBmr/BoEli5nEslT7c/1WdLaP82d9U2Z/GvS6vjyILPNDa1izvijT6KGtAiSy/dCalqaepAw72BYK0w5MM8JtSuSOklrQG3MlzxZTOHQCoUYIEmUMDF7dmstSt+SZj+Nlic0DFn/1c6ZEt0ncjuhpQc5qEoPhpoAjPJ+Z4uxoPaFHbAIRZE3lnEzaSLZG02mZ1YOHO176cKjONS+hZhroSffyxqQm/b4Kygc1ErJXOjX6ZP2vjKk/RuX7qAxlDlxezdWf+cdYTFrsIu5w4nuZzQYdUua7TV4h9y6w0RiOzimrP4QH5wPdU6VLp0trjpKamRXFZVrw5yU0OAf0whuFn1p6kcSjM0AeML80ZiGBmj5+mzfKNIWIgQ0nUU7l7rG586Uy/J7jfkFyyXoMl5s9sMOn0v+fCgTAx1QZp7uEMsHA7Or1FKYpylFcCDo4T16LXCSZL7RRvOHC94UZCN0yazKFjtfkv9MTl0/zzIBHCF39S0MlU4YuocZ2JcbwnjJbd1LD5i4R8eNfm5P99yAMGkdZTfI96loDZs0U8N/P6kAITA3a4Wq8VnKh1vMWwOa3oZT/YvSfHHX85Xp6/CJ7/YsXFDgIqcYf0jNe7Fms1Y0OyEjS6Kp4UnZ0xSX/UlNrJbWbmICuEsAbgsF2eJZzUyyk3hbrFu0wSliI0gkr7lhFwakMGv1smTC041aBZJKT
 P+onsoLd
 bScMFzTWDrJqx1kmIFOBgxlpYZSvygpnlLYpOL93x8GtOzuPGCyBRqkbMwzjdFWm8mUGUoC1xyAF1c6Vrq3Vue2yaNE0CX5DG8UKXBlsToO+0FKcyo0/8x6tHwA/3UdSxGe33nKwfkQyqxczdo0k7kNLHpN8YutTA+/pcbU/dk7n/fFOGiAGJvhuvSEOQDYHezY/ozMWHJpNi4pWq1bzuR77MwMZr/CWduuILdV4vRQUdKh2WwUpDGoAPwo7RLTdhUj9DyN8pacUDfX8rK3XpvR9J0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Foreign dirty flushing handles cases where a dirtied folio's memcg and
> the memcg owning its inode wb differ.
> 
> wbc_detach_inode() notes that "concurrent write sharing of an inode is
> expected to be very rare". This expectation does not hold for bdev inodes.
> A bdev inode and mapping are shared by buffered users of the block device,
> while the inode has a single wb owner. On ext4, buffer-cache folios used
> by metadata and journal I/O can therefore be charged to different memcgs
> while sharing the same mapping. Normal bdev activity can thus produce
> frequent folio/wb ownership mismatches.
> 
> This was reproduced on cgroup v2 with the memory and I/O controllers
> enabled, using ext4 on a loop device. jbd2 repeatedly generated
> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
> When one of those memcgs entered dirty throttling, the resulting record led
> to a flush_foreign event and queued writeback with reason=foreign_flush for
> the bdev inode's root wb.
> 
> Skip foreign dirty tracking when the folio mapping's host inode is on the
> blockdev pseudo superblock. This prevents bdev-originated records from
> triggering later foreign flushes.
> 
> The tradeoff is that dirty throttling in the folio's memcg no longer uses
> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
> folios remain subject to normal writeback. This is preferable because a
> single bdev wb owner does not identify which cgroup is responsible for a
> mapping shared by buffered bdev users. Flushing it can write back data
> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
> foreign dirty tracking for non-bdev inodes remain unchanged.

When fixing something, please always describe the userspace-visible
runtime effects.

I'm thinking probably "unnecessary I/O"?  If so, has this been
quantified/measured?  If not, can the effects be guessed about?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
>  	u64 oldest_at = now;
>  	int oldest = -1;
>  	int i;
> +	struct address_space *mapping = folio_mapping(folio);
> +	struct inode *bdev_inode = mapping ? mapping->host : NULL;
> +
> +	/*
> +	 * Bdev inodes are usually shared by many memcgs so foreign
> +	 * tracking leads to frequent flushes which is counterproductive.
> +	 */
> +	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> +		return;
>  
>  	trace_track_foreign_dirty(folio, wb);
>  
> -- 
> 2.39.5

