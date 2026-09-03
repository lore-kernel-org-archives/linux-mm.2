Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B9EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A706B0092; Thu,  3 Sep 2026 04:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31C66B009B; Thu,  3 Sep 2026 04:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975096B0092; Thu,  3 Sep 2026 04:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75B636B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:33:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 042B5120469
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:10 +0000 (UTC)
X-FDA: 85171786182.12.9FE1352
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8905140008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:33:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e3uJME5T;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788424389;
	b=BM8g8wrx0GFQgoIYhJDu1OkyUUrfJDpsbHMqv5PeW/+p/NY5dDIOsSyphuAgaffjYl5YfG
	LionWXfzmcF2soJtVSAEXzszY61n5EDet3/9aUiTWok0K41BbC194N9bB4wZYgtf6A6QMP
	AOfCMDmYbfGu9D2uxLLGUdm8YhFoZ/s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e3uJME5T;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788424389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BaXToYLkp4W1X8Rn05QhvduOjOn9yVBdgHfyyN+fIII=;
	b=4sa3TjgRTbzVkeCyiraipgnSov06yZcZyLWzTOx1Gsp+1GTmCIjfVSrK92koeId8VNux57
	wsbJaTap3aKOfe66woyeg6pGXswhDvhBTNq5s+Y9+LI7n/RBLD8Pu2d21M2HaMn9c3/g4v
	l8/KMAJxmxoahRLxNTxo/sIW/5fj7Vk=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d6efd73032so6751615ad.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 01:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788424387; x=1789029187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BaXToYLkp4W1X8Rn05QhvduOjOn9yVBdgHfyyN+fIII=;
        b=e3uJME5T5JgRnf2912GomtQRdgLA6y+0nsxoOXASBhQP373Emk0q2G3boU+cec4gQt
         C3xnFYtHN01Nty6Sq57cV85EnefhV9K8eXT/ilcNlFoYxCWD8+6lUwj9xHHBty/x6xyv
         qsknyPlK3+2BWqSVXoFqukPHh6Vk1/iN59f3GtxpqDiXXXwGpNdrwhYsElesu56cNeL0
         rkQQ6EmfJoZbIHUbAnKwTKQN2FiRX6w227rVADUEocRX2Eu1MwkPSxUcTMUKKaICgbl4
         tRaIFhn/yuC8GKbr1dEMUteNMjHP/K+XSK1XqPFMFUGoYd5Pb6GTPbgTXbSuSyMm0WF5
         oqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424387; x=1789029187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BaXToYLkp4W1X8Rn05QhvduOjOn9yVBdgHfyyN+fIII=;
        b=CEVFAqgD8BjhVkcyjsHzCw2bydMIsP9bTmTLSuFAj44QmoDWaUJc2mCEB3aAt7v+zK
         JwfA3u0ymtjTsmLLJ15h4KJGSmhIZ9kz/+/IFcg/vlxYEEf7RtSgSy2m6EsD0Za26R3p
         LSIhn4/gPx0LJj04vwc7CemYuNuN4UDlaNDSkrK6y/FchiCJyg9J3vyroNASrKKIblJe
         VaX7MrW6xA/HBmr50zpQquD4YVjkuu4eI3tWoJVxUE8IvSWxFhfVjjULJQMrbECWiC/c
         g5u/xbY8y7BespHPB7EISLEfKmr1lEdVRz7YTvQ33Mv9N16BHJAERrogkCuPyAe5GX3S
         61dw==
X-Gm-Message-State: AFuF++lHIpGLrSkD5EiGobi2WxR+A4bf2TPYF1zqZUWIJVCEomn3xStq
	zbMG+08KwVfKMKvqICJ4y4S+xwr1bnEK/FpLnu7dHEvWwxFW4m1Ftld/ujV8f/6SIAoqpT7MiI0
	9V5+OEVA=
X-Gm-Gg: AYBFou0A0tV7OL5hy3RHKSkUZJZXzWOXvhWxI55BhE8600VDbetkyfEnAyYjlQXn3G/
	ykYPGsZ3r0KWr/XBbu//R18zZUQEsofjiDVifLDyUV75nUNMr33JZa1iZQPXe+yLe5MGj3U9IoY
	PMTnvKWvfxZswRKVrF4wvAsgNOkO1zUxmePkDOGc65WBGBwRg4n+GiK/GWLct9sRP5QDO8J4NxJ
	p1QST6khlu1z5tNRI2lVdS6phr5l6LXzRNDVX3+IYzizrC/+sc8paQKiWDSrWirX9hQJE9jVe/D
	Qc6uGp7/Qkla57hqGNRNbo/BptI49M2Q7TnhTQKP52KAs6J/7qcy4fWcFd70eiLnJ4S3tnpK3gc
	ouEV7PFpXZUM8K7aXuqg9TJ9n0cxJsXuep9GD6hpkQAx/nyEcxO1rSLSrgFYaT1PUAvbLI0KG/D
	3sMKipcXfiTp5ubCgaxw5ULumQU4FY2vwLLmFtPM5jCPnXb4WdD1Ee5OYgsLNvHg==
X-Received: by 2002:a17:90a:d60e:b0:384:927f:3db9 with SMTP id 98e67ed59e1d1-39b131c0c34mr1941697a91.1.1788424386961;
        Thu, 03 Sep 2026 01:33:06 -0700 (PDT)
Received: from localhost ([106.38.226.3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ce4221sm4590357a91.14.2026.09.03.01.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:33:06 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	tj@kernel.org,
	jack@suse.cz
Subject: [PATCH v2] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Thu,  3 Sep 2026 16:33:03 +0800
Message-Id: <20260903083303.2769873-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8905140008
X-Stat-Signature: wzjyahfw9tpbajurhfs81krugi1d1ceq
X-HE-Tag: 1788424388-258465
X-HE-Meta: U2FsdGVkX19Q7b3nsW9WLjJqSjtqxXgQo91B8AaCWN0B0TJcOQGBvimzDYI9gjHYqnKpuJRM8hdSZ74rGRWyocWzRUEITDWArY9c3kQBdGpwhABdjIZVmxvAmW6jZMaYJ+WqHrAQq26CrxFo+pMWnimknu5uGk/1UX5q0SZJWdFpfOJGJQSHciDn2/rgKQD1IvZtXjmNBh0xkAY7sV94l0+g1wYP6tsappDTi4Ei1k1CQynap401sCWs44vBk+q8asVKobHFPnd0ob8e1cMDczy0mooFjJBLYOBMULzf1QRjZDPfXsNz8rR1Un4Wk45vii8HfK6eNuxPzrzQWijrK7Xk4T7WU9cAdY7ulEvP1txiMHTOYgQzhE/Lz4n2qnDPhsufdMhI8erifhA5q7hLeUnIxhDPAxnaqI5+Qy9PQsUrXugPtnNxltq273vRp23oFuvmsEWYVLi/is+OdsRBK0/g1fzxm4s4gJmAeY0b5okSdTY1l1p1g6wsZeX4iAgyU5Z5EJkP1Rwdt2IGEMo6YCICsDOP8qSp9Xfple0KUXOPiH0N7TPLr1maB6BEmvQdbktkI5+g2gLjdhJ1i/tWrLqMcafeToEFBhHMwnjBkRMJf67Z4Ve8eLDSJ0J9TTfBHrQXHdzRhha1P1dnxNCtOHXTNu4awE+cdV2vzNjcAG/ous7BAFSPbLFzX11b8520YvX7xpRQ9pisMnfbG+MKe/cT2mCenW6WHbZIo9TjMS1FXJlUQwWFXJTX2ResdxOxqVFBOox1e9e83KBhqhB/ybeUs8FDjX70qDr0X0Cqtec+/OObhZ+eiGGAsmfoH0uzPzur1qkkJ+69SGlV5eaxWNLE51F61D+0YVkbZpv1f6TIsg8QdejzaunlRw+kJnXZah5HV4yJu4ysFJB5Am/N1z3Df0tI4VMM7RMrN/2CMah0QhIXsPQqbofa7aoUnX2YSFDCWpOG996oF401+Wm
 lvb+zzSr
 1sRLtKzMcfJX+5awNrrp33va0k9glS2dya/luK1qU/+V1Pu8UVT05Yj1iq3XqWii4uIpaqZBNeIrNIAHZbn++I4CelpChh916Hm/loiKAKXpyF3Jj91kDW4RSCS+dfcG/9LR1hVMYDCl5kl5nP0yL1L8Nrxnw/AJNf987nY9JkTi67KWRtHwIv1YB3hMbo3R76Qe8ldJDyzr6e3bqxPTEtETu7+m5WsE4tYwlGzkVogQRJ9DQojh8GotgjF4h91/cyqb1mJoK+BlHKrMT72lqSvqXGXjfzhf8usVDpQgMKrlgm0SDH/fU7MJClujslQ8SS2jVEMuEeyP/srZbkcuwQaVNW0Sl0IkwR3uThAZrU6Cd9iM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Foreign dirty flushing handles cases where a dirtied folio's memcg and
the memcg owning its inode wb differ.

wbc_detach_inode() notes that "concurrent write sharing of an inode is
expected to be very rare". This expectation does not hold for bdev inodes.
A bdev inode and mapping are shared by buffered users of the block device,
while the inode has a single wb owner. On ext4, buffer-cache folios used
by metadata and journal I/O can therefore be charged to different memcgs
while sharing the same mapping. Normal bdev activity can thus produce
frequent folio/wb ownership mismatches.

This was reproduced on cgroup v2 with the memory and I/O controllers
enabled, using ext4 on a loop device. jbd2 repeatedly generated
track_foreign_dirty events for bdev folios charged to unrelated memcgs.
When one of those memcgs entered dirty throttling, the resulting record led
to a flush_foreign event and queued writeback with reason=foreign_flush for
the bdev inode's root wb.

Skip foreign dirty tracking when the folio mapping's host inode is on the
blockdev pseudo superblock. This prevents bdev-originated records from
triggering later foreign flushes.

The tradeoff is that dirty throttling in the folio's memcg no longer uses
bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
folios remain subject to normal writeback. This is preferable because a
single bdev wb owner does not identify which cgroup is responsible for a
mapping shared by buffered bdev users. Flushing it can write back data
unrelated to the throttled memcg. Dirty accounting, normal writeback, and
foreign dirty tracking for non-bdev inodes remain unchanged.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..6e8f7ff7d44a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	/*
+	 * Bdev inodes are usually shared by many memcgs so foreign
+	 * tracking leads to frequent flushes which is counterproductive.
+	 */
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5


