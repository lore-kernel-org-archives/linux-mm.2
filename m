Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A44D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BF56B009B; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6666B0096; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F316B00A4; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71AAC6B0096
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 348BB160110
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.15.EEF481B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 594D42000B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uIeicvqc;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4O95Yl5s9/wxYDLNk10/lpMX9to528i2PgDiiXFfe4=;
	b=3+N5mwNEmmFZmxCM8G600OP2L4fMzc53CW4sBVWh4305I1s2KLnJdXZHPtDhzChSa21tJZ
	kZwsI1clo9YKvjW1uMOk+PB24YOdDerAMeHWoC6fyxU0eqPUUexIQG6jArXXfGcAFTgfmh
	GqX/9v85enuQ8DWgBEEPC5gLT445mq4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=uIeicvqc;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=T/yPB3cd2zoNfhl1ZY0QRwfKPz92RpXuCPRBxQtxJXlGmran4Gj0oodgoxeng241HbLAeJ
	cu/+zu9mzlbTVcPq4eysxYY/G3Qo1SS+H1qRHJmvwfJ10RIIE7s4NTGCYDisVkWvm94jw8
	8sOJeKb3iUVdgA2FjL1wS1iM84Hu14Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C4O95Yl5s9/wxYDLNk10/lpMX9to528i2PgDiiXFfe4=; b=uIeicvqcAdjQez8e5XGTZuq3uz
	6pS0Ua/0N3dsxZ2P0OYuhho5eQYhm8j5ts0/CncmYHbn2ywGNTTy5KC3FHlhWVGZn2wyYThkjwQQ0
	cE0FyzqFQ2kKz1tX0H6hqCLWfhEb0ON24pcs/3/u/pkkck/NsFbbQl/3HMm01OEdHVC7dlv5T46Qb
	nR1lUjs3EuFSE1COSZX0yzMLd/O8jVHjHoFsVjoX/6y5oBwuyQWrixRMI2puUEPJv46OI20VFefKP
	3zW/jVVbFNBDQlVmIihiNwNBe/IGLJldpZ27pFYSW9GvdZhX3I8upLGg45KAl59J/3Psr+vg0vJ3M
	Z2X0m9Ww==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085Zh-4B9a;
	Sat, 10 Jan 2026 04:02:19 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/15] turn bh_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:08 +0000
Message-ID: <20260110040217.1927971-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h7yzdurmier8o4gdtpp7z9wbb3ixz87k
X-Rspamd-Queue-Id: 594D42000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768017660-246161
X-HE-Meta: U2FsdGVkX1//tIVjMsPlQh8BUp+Ga7duRkdK7qjl7glE+IBW5fxPwD2DsZgvX7ugFQEmNpTGjRtiUdSK8IZehlhtnhIl5r5+OwIhVLTHFy+iTydeGKUmqNdzH8T9zOk5qqux9hobbaerPpYwUPFePjHQd5aetUlg0YVIGUkkiNAXY2oQAEgYBAZRZoxEnouKKMdMGT2Ly/4YxGM4l7Im4XOnxBfqtioiN9Flv1hq7PtSF7ytEGgIFwIvw6LhvB3IwNdqny70eH8kJLaSUTMeQrjVfrT7UusMmLH9tkINDKHOW7KTPJCO8uEckw+y2CPuHebcK7uyuWMt7gLvmwbowC7cEUQLSOfI2g8bSD5cwacFZUIZcoyeJEoBK7ZiKI1fJMxLqc/2sp7S7Vf/mBusSyrcEZJIIUr5eVxIzn423fg1DQrcgejwmEXA3i/rR8KRkcPifUJs+pdEqITynw8/I7+ZEYEByPY3R8Dtu9TkWaGopgyZXiZetdLYdILdsdTN1iJHXqfsil8pqMWEC2ajZLYaiWJOhJrr/iD2VsLA1sgJun1KGTuuH9SxzE3S4oR2BmxzdcWVzArs+z3vHtE2SArAW5uGX0K6sS20a6LKbN39OGuD+MoFj7pwgMHLXX2POzrt1WK25zOyAyMy2aaarWQpJYlyfyOHB9rFqQMoL/jdGgiue+8lf0hZ5Nmw6o1XMkCQNLNo0XSqxX5vmmHjvM8DGJZQ8vDGpOrj00MrEZEQh894DqyfpRyYiTt76hsusBHvkLm3Ba/xzWXGP7EQICZkENqxCBNlG/IXvdZxj2ToStcOwdiVh+S7z1/C6aR7EeKliWzE/XT1SwgS0qjRyBmgetuMpHIH6afuhBVh+HLHOGorzVafGH7F5HGhkNlkZONTqkDoCiUm/AcMidiKIclnLTjwfYoEfPfrIMoij+z+dWyGqOqFbmkT+bj4I0XlIqLUHHCX+vSZSmta7Eq
 /rMDaxdf
 RtqNijToOQrCe5aAKhfPNvjV3ohN9xb/VFySnCCH3aSgUiUNGAVZ3E/4y5plQOLs1m7SpmCDcAqSGEvczwOQ3Rmju/fBf7WVtnh6PaG4xPlP7s2cT9W9nsu7Q0d40NlxJadw1//8YhBzZCKkJG2+cCO/F0lJZCl7F+i6utNGMwsFLUgsh/5dpW84aYR06bMvsGmaJZanL3sQdT0ZR4q5575kUutRRi6G8GIUw62HWAOHtU3q8H0B5hyTry9sGk7BL5U9boqgSfrmV2bSL8HIYl8WKafrC08SOzzTrN6tpawpqsV0XED1qUeCDYZsa3h8ddmQTAGViEQANLO7xpjxT/ez2KwXeorezxLtW/qGmAhXbhRUDZEIdZB++2Uje01vK5yFYy2KBqZR5H7Gj7Hlo7Cu6qm2v60jBo1K+B9AOxup9LpBnsFL2R1GoYHSkOonkxiARQFnOOruQm8nzweqysA/aNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 838c0c571022..c8ec1b440880 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -50,6 +50,7 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/sched/isolation.h>
+#include <linux/slab-static.h>
 
 #include "internal.h"
 
@@ -2990,7 +2991,8 @@ EXPORT_SYMBOL(try_to_free_buffers);
 /*
  * Buffer-head allocation
  */
-static struct kmem_cache *bh_cachep __ro_after_init;
+static struct kmem_cache_opaque bh_cache;
+#define bh_cachep to_kmem_cache(&bh_cache)
 
 /*
  * Once the number of bh's in the machine exceeds this level, we start
@@ -3149,7 +3151,7 @@ void __init buffer_init(void)
 	unsigned long nrpages;
 	int ret;
 
-	bh_cachep = KMEM_CACHE(buffer_head,
+	KMEM_CACHE_SETUP(bh_cachep, buffer_head,
 				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
-- 
2.47.3


