Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117B9C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C526B0088; Thu,  3 Sep 2026 16:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D9A6B008A; Thu,  3 Sep 2026 16:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4F36B008C; Thu,  3 Sep 2026 16:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC15D6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:29:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 534A3120301
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:29:25 +0000 (UTC)
X-FDA: 85173591090.25.533FDB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BC97C80003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:29:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If3TwaPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=345y6CZtFGlCHyHHMSkZRxvx0a17X3ZelXVrjUdMfG4=;
	b=t0oYizrIJzdgQn9xK49rLN9MF9eh/rGnPVkU3M9+nIjZKpRDkuOrml1ni5FZZZhVdWAj+U
	arSqi0CKjKKrle+b6tIWgm14SQtRMXJ84HbHqTe/zCuYvOWrgyWrCvzJBG8E/2vp6oANTR
	SsH1496TOyvSy6ZE8h+vTW6PuWBhuTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467363;
	b=3hDOjw5dlGETSTKbyhD0cXa6aACVU1p2MrV4ZkOwDiD7TpRf8yAG5E96ehhECa1IM+BACZ
	ueRL/ODWiCMjMzSyJ3qftQecO3Evth6P4kCd4zzoCGxZNtDTmBv9YOPjOJqO52Y5DJ90v+
	Evqf38zmUo0xeCVjRoO3t0yjns4/LJs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If3TwaPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D05360219;
	Thu,  3 Sep 2026 20:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF851F000E9;
	Thu,  3 Sep 2026 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788467363;
	bh=345y6CZtFGlCHyHHMSkZRxvx0a17X3ZelXVrjUdMfG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=If3TwaPD9N+4ZsolxPiDB2fhxUQI6avIDBpLH82GsRUPq/oSiQb3PiZfiDAsu8ROe
	 xcR/ich1UxcK74iPqSqKppXn4jdQUbkS39GbeGw8wuECH9n1VXBewTmqFYTJWucv9P
	 zkL1oIND43X8oL3VGYP9duQmWjtYgbPH0IukaamsG7iS3IPpG1rBsiA8Wia9vkrCkL
	 kDTk07r1fHOI1wxYiUjAENnSMTTmiH+UtkES1gwEm2U2fEtKzpLwJme6N8GwwqXO/r
	 44Ujc7LKT0wPhr62YaqK4517WmaSogOQHilQjmXMd5wRtyxvYBmxcE4Y6k1VBsOfhy
	 46CSoLbTG5HmQ==
Date: Thu, 3 Sep 2026 10:29:22 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk,
	jack@suse.cz
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for
 bdev inodes
Message-ID: <apnYouiUINQR-98e@slm.duckdns.org>
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903083303.2769873-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC97C80003
X-Stat-Signature: ym9yzyghdtwscztqzroi9dw54ytg4dgs
X-Rspam-User: 
X-HE-Tag: 1788467363-657801
X-HE-Meta: U2FsdGVkX19Y+4r6R8N+w+aNNCP4L+ckRSs0Jkw8LNOZz3ru2fSowWlUQv2bPPI1Pimo3eftwvaC4naFSrn7+AucpL1GlBYTrmJdRYsQWJDRRUQPaCq15rcSirem0w51NCq9xKGvFp5CNWyd+t+nL+zrNojzkk8XXVSadU9itGNlWRtctdLQCdUDrhmDFB3MTreQ0/oKzVxZl0wsGmBdIZBLWuToTnS3o2bMNU/jfQi+2lv/IlsYgl+GZf7A6Y8YrqB89mfFWDGE2+Jq3pFKeCWcckL0Gxa/dzxodfm2rdYCLheAbzJ7a+n5o/1F8iAzk0+pGABrpjdPlcOq7xwDsMGZ4GB9ajKAikdqquVNPldNsmfuIDGTU6Edj0YsI20FPUVdhyNaP8Ye1GTU7hq1kLgL6O3upvfK/S4pZJcyqVkLMVzIi2q79/1kr2Xy//YezEkzr9WH4zef7/OvRFQVPbGXDO+errspAanaP9WLmatut/MyBjJlruH8CeK59w2ZOYc41tW39QLyCw/qHX+tw6OS0vei/3rwXu/gJ2oQ/9muMk7HKl6/h74aIMLRXuV71BolJp+kE4fSa/4CP3nNR3WTInTxjgD3eZJPxFwE7db4Fqoc3J5Z7wxi2DLESPElO3NcP9U4SWyIssST4e+jjIn/KFrqYiKwxuJxtWFWZg6dVCZNBzGY7IwA2P/SWhn81dJK47pp32eMIU8GQRdLQ+ZxfGAidqwV4amYhp1qrT6VdYr8kIRyLMxeKPihYHA6frefr9ZC/tp70otix6UO/pvC2sVVf1IFJqwAfr0RA2m3reUy3BedkuE+yRcjSupUkZP/tAWyEMeLfiwK04MG0HsHmyr5f2QhhOp4zvEGjE8LsgOzCF7JwHdHEG3PGDvwljPjcvXHU5QpmX4Kj6M6Lt02GrysBSuR2gq8zK5G516/PcM/YNNvjWuEwn38E/UEWFpD+BHm1Psnwutnatd
 ZFo/AkBk
 jNCMxj9U0XgTU7VLOTmctVBrqs9DUkZPfAbA78Dbl45pysIGUv8tAYp16KNB8J96a1fSH0EbkuIraMWFQk0ZUNeDISTBPOPfmFII92KJSvcuw9cSMEE8VuFilM+Qx1EekIclLxUol5Asv95YI4u3aBWz8JnBZ/X7iwlQuxmMG+QHqrlTvLYFHu+15pDRU/B+LrfAhmb55uc8QGTWVaHSISjnUgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Sep 03, 2026 at 04:33:03PM +0800, Julian Sun wrote:
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

Was this reproduced from an actual workload with adverse effects? If so, can
you please explain the workload and effects with concrete details?

> Skip foreign dirty tracking when the folio mapping's host inode is on the
> blockdev pseudo superblock. This prevents bdev-originated records from
> triggering later foreign flushes.

If you do this, tho, that means now cgroups that accumulated a lot of
metadata writes on ext4 and crunched for memory don't have a way to relieve
the pressure outside of periodic or other lucky flushes. ie. I have a hard
time judging whether this is net plus or not without learning more about how
this patch came to be.

Thanks.

-- 
tejun

