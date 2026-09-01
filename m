Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C71C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC946B0175; Tue,  1 Sep 2026 09:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59CF16B0176; Tue,  1 Sep 2026 09:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C4E6B0177; Tue,  1 Sep 2026 09:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3046B0175
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:10:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 831B24031F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:10:41 +0000 (UTC)
X-FDA: 85165227882.18.D240889
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BFEB100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:10:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hT/d7wG1";
	spf=pass (imf14.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CS6TAB/bDfKrIMRJ1Cd4TjasF33S/34CI8IaymPnMnA=;
	b=ezdHCKP0/MEdDNDsswK+JUoTzQPQYdlNOaNidjK/tDpTIi4BTdjTO6wADeB1fQlbD0lytW
	YK7HQldmfwRfbKlJwNDrjVNKBCDaiFTMWGL9G6s7/LlUHTE3r8+j+wLJ8VLorJ9c9FiK08
	7Z4XjiBl08/d0t8fJ7sWOBxlAQEpRAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268239;
	b=ye4Mi1kZtVXf8PAIRrFQz8JS/3+HPbxNM9Jgon/9vh64K5SlfU6ZbSuBKMq5w4/ysDhrhm
	joMSL7WYwo/OmBJHGkRbp66gd9Awmf/4g/TNqf62jfnlbUkeUF2J8Mj0MucBp7LXx5Tk4l
	BnDf0RiXNVaIXF19/e+KML35RF+87yM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="hT/d7wG1";
	spf=pass (imf14.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc1cbb64a1fso4645283a12.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 06:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788268238; x=1788873038; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CS6TAB/bDfKrIMRJ1Cd4TjasF33S/34CI8IaymPnMnA=;
        b=hT/d7wG1lp4xiFhm67LKeQkxFsA3itK+CoBIw3xNHhQvOPn/pa8aGVp7Hs6XWysvRj
         bEl7Qj/hCbaCY/tKOINtSIWGVd2zTs9xXuAcgkKVj6DkFcaMI+lY3vTBhOdn/RXyg4lo
         8dl9L4cLNYVbqJgJLAvzZMVJ/X+V2BlOwNBjonFesu+ksPu5W5jStJULW5toeroRLUyu
         KPsg12rhpguziRIPC0xw61yXU6Fy3VYqIwUb0i61EgFwgTFtli9nfoIMOuMkImYrL1ra
         7C4aJYb8eOl+651k6zwx6z7BRjju0o+S3lrp0AxcF5WD2f2V6VQ0z65i3qmHLB3uux9w
         JwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788268238; x=1788873038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CS6TAB/bDfKrIMRJ1Cd4TjasF33S/34CI8IaymPnMnA=;
        b=PYD4ozmnIX35C645WwoC0H6AKL6IIo+01aKyx91Zxd4NlK8/GAFoyE4WGJT8QnuMHF
         q8KSiyFMkjMRP3tBpPBBTGRWX9HNjvEZPc4kpFWDjkxc4xZPNt29qq994gmeuTgaCd2Q
         280r7BHU32KrcAmLc+5WycySaXxSpJ/34JFzx48IG3sX0WQWnDZTuoFvxm1EgvDn6OEp
         FH9edGEkeb2YRA/Yh1HVlV7HBUDtQafHyO2Ao9Tq4rBVHEgOw1YxMam6RmrOLAHA05Bu
         nj4S3YLxY7dR1RGD7Nq9bzuTl7yBnwZRQ7+LAYGMf5l4aEFCXcykyuHkle4amFwbhV4K
         QdtA==
X-Gm-Message-State: AFuF++kK4zNIqCqqG1UZkrivaskJ/Y9OawgMrSJ2KjYvhjf4ZNiLOtz5
	Nm3Mx48veQxIoBJ9NReH/9ONYIyOpErzIr3dsMUCsSapLFrCVMYCQ5Y8f+mNwk3jIxOjXrtyjTC
	5JFgiQW4=
X-Gm-Gg: AYBFou3RgSQiEmKvFQdW6vCWzwtNaio9kvN5naWvi0UpipT74kdS2+LdXHL6scq1KI7
	dRyFtlAxmijzIRNyI8/C7u0KsrSttZzceoWDVFZtEpJNj4O+5+Wd9qCKiyzTNtX+C2nxlehbYS6
	xm2v5PLvIbEBAbcZjlEhrZxzIgZwh8EfyM3dIzG3QAJ9Yc56CGSlo3edRJEhBHLVxqElHyl7AkJ
	uzT17DOnlc/QC4VjACXY0RuCAEyfm3wF741SVZp+/PK0+CePv+NydJFz219hadOPasiDlvaL9Qh
	DeJ0Or5yK3N0hVnowrQh1Y4rNdkKJUuQLW1PLRYvE1rLvP67AjObM5kjZe4yNMY0YUVW+ucKwDy
	WABGqzqHBALVzmghrVeibKa+FPb63Repw9AT0jE+6uWUEz24TlDnDX+3C/gesMnOPzlyc+JaVGo
	SgWkmGLMw0dexYRogaXYRRpd1SZdIPwNAppqow4wl8ICL0GCOKBuL3KbeR6Y3p4Ac2vQ==
X-Received: by 2002:a17:90b:3c83:b0:398:9bd5:490b with SMTP id 98e67ed59e1d1-3989bd54c84mr38553882a91.18.1788268231587;
        Tue, 01 Sep 2026 06:10:31 -0700 (PDT)
Received: from localhost ([106.38.226.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bcf7ca7sm6520279a91.4.2026.09.01.06.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 06:10:31 -0700 (PDT)
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
Subject: [PATCH] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Tue,  1 Sep 2026 21:10:28 +0800
Message-Id: <20260901131028.1120284-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BFEB100004
X-Stat-Signature: zhq9emojtxuh7eibxa3r76d55y831cus
X-HE-Tag: 1788268238-588176
X-HE-Meta: U2FsdGVkX1+QC41q2D8G8SBXnj8Xm53UuW0SsId0k8SKA5ngNZC19Z2mRvJsiA99FdzLrdEtcbet/Aetbs3HfrpIL/GzjVqxakO/ACeGut/imIq0wzqaZwpuSW5ogNldUk/dncGFD9iZavegvjs7DqxC1+2Qf6t+vtqZZLwY1oxL70cv3RS7qWy2HS00Zz7zUQIjHhZHugXYSQPCrlTMUBuScbkzhq5PUwjntdIjnFhiLbmgJYmEB/LX8VCmGrJ8TaWlEtk1H/HxgIrya0XnCDCMGFCEToNPxu1JPZo8P5Hw1FQW9ij3h6ihCv6Ix8HtSkyQRICkWGAwasUyZSRe2nifkopsLF3K9zV1Ts40NZPLznZX62lQfToNgA0GCGCaFl3j+8D0Rr8V60LypbeT5gGjsNbJub6XMViICSYFKnOrWqckd1q083qPFPN3O5V299yec2W06eFltp9+BhQYMc89MkUOLIF0y1412fW2eff5r+aXNOR1Q8AJM6wF+Cv9pGxJ5LWLjkZekh5h6VjdyANbkjy4GZiJwQTI9nru7ml2auFKdjqIm6nWekL7M2pEHh2JuuqYx15iV5AfpAUoBI71+9dfcSRQcgSfQdlwlpxnzo7xV9PktHVGKEElccYNsXy2n31bCUXYuZxBomfJxsfh5l0SxfS67X9qy7yw5nwKBEtHw4Jqv36VYJD4kIZEtb3YZ/WTbYGQtqziW0+2SfFG7o/HahapUGnQr/YeBflb5iacHe+PrUjRJ5Zs8LddLTD9BpJaykDczgA0axl9o/Z5OPxCCpkCzG4E7KR9zFivUfU9qXv/TDk4hXorBSMF1bE0sikQURM7iDxGXyiSPWwhSu28kcYOI7z3B9OeKvCEE8xTwJRd0sh9k953u/y0dV1nl+bc9Za2LlhwcoOZXOWdb0cKZJLV53oP7nOTCRAxIbIds22ntHiIJwloxVBEzZmtnFToCQ4d4r2J6eu
 CMYQgj87
 m7JcPgNUMw2rWwX/lFl5y8TjEG7yRvMnEiLSYTpLNLt107FX8ZQXJ+sq/nZQ8AeXZm+S0Yur+YzJJ7nvClMkEIo5P15/hg9F9o9VKyICaJwkYK5c8cIf5lp0rL8zF8IbhOldBDr8UUUSU7ttOsKXcUvcmgnCAIl57P/ZXueMrbsZkALqZ0jo+VVduPlalC84uAYrO3i/2Qb3D6lnXI4BVyxUK4j0w/LRRsm+BLBZqvOb23DkgzhXvjsLfoAPZXhl4mEh98mCYjCDWNXkBx8xMmEow2foAbvNb0rm6osIDlX09yM2taFH9q1hNo7f5hZY956KYKOeCqyAFip/+0YQhPyZ2gsOS6A8YBsUr/ZMhPkhze1Y=
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
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..5d7320f76c06 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,11 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5


