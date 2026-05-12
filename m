Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209BFCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4646B0095; Tue, 12 May 2026 03:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8555B6B009E; Tue, 12 May 2026 03:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B416B009F; Tue, 12 May 2026 03:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 652CE6B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:49:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A68E1C02DF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:37 +0000 (UTC)
X-FDA: 84757993194.08.228464D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C3971C0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:49:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mfSEVn5G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3jtsCagoKCKcYPJOHYKfJJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--richardycc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jtsCagoKCKcYPJOHYKfJJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--richardycc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572175; a=rsa-sha256;
	cv=none;
	b=VLQnZDszi+uxAzwQYJiqWIrl84/m2qpEQoTPgmFBGKZtSBpR24F4iuDBXZ+PsB1r58i1TQ
	R06ZNXiwmbWjxwnD5h8w+qzl4Nm3YO9UapKybHxEK/eYUUItDIr/oimSv3fl9aymdrPY9r
	HhF162zJQokl+t6R0sl9kYM8f8qqgVc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mfSEVn5G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3jtsCagoKCKcYPJOHYKfJJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--richardycc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jtsCagoKCKcYPJOHYKfJJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--richardycc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UR6rLERhiUgj6UCn2Pmol6DViHNRfs8NhBRMn+AmWuM=;
	b=JbD4fOLrKXUwGLI79Ah2xGp0afbZV4zRCXyElJeZS9kjsA7810qGH0AGWL8JJvsl7XZji2
	5p2wRPa4c/IEqmSxTk2pCx9pNSbDJ/5CqiR75AaAuegPRMy9cr5QjB/z5by5O3wZPfSsR8
	pSkn2t7Wy63DlLq09XJPY8gghgWV4Is=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ba6ca20ceeso57995785ad.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 00:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778572174; x=1779176974; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UR6rLERhiUgj6UCn2Pmol6DViHNRfs8NhBRMn+AmWuM=;
        b=mfSEVn5GxccdAsXCVJULaY8X2Jltmef2OdsQiK6oKJ+iSltd86fXSHt7OpGE+QFPko
         BiH903CPel991c0kg46gK7A+o7EiAWWujH7d4s7EpeUnCj3cSA77CJwBP6i+ArQ3uFOG
         2K3efvNkVKk2Ax8cJqSNKzCre/9FvbkJOg4yopIw94JVNHWMHN3vDNzkSFC4CWbf7XZ+
         Wz1uyjO6Vv1u9k7ftR1O0jcgZVB+u5wIiC2Io7khk23hmLtFqqG6eK3vnaqYvEyY3bWQ
         G7IqUcQbh6qmxudnq/WA2dBm70x1Tj+L/sXE3VBSunLXupXfSbh8OAbMel5l5fucilzJ
         t/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778572174; x=1779176974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UR6rLERhiUgj6UCn2Pmol6DViHNRfs8NhBRMn+AmWuM=;
        b=B0h1aouhoWb0Ywf+iByk8GtcdigGRMdnSU20zlMJaWd8evJH+r28bPd3tatttBh5ff
         zaYtSLB1aVWe8zUJTOjjXxNQYSvHbB2V7JrHkeAchgc9JdC5G2KxDcgxuixteh9sXbCL
         bQ1JbS89QvP+IEs8NMW0k/mFs6hDEepgPRSWk7LwBqNB1Cs6PDoc8tqWD1t8ej9AfluL
         ZLhWoXVBP+P0NPUB2KyK1ZVGbtJm2shXHIjeor8rlqY/lXSDQbLk3SRQ/RYf7FoOggJR
         N+5WpeJV+PU+9bbbXCgtjspapz9JuHd8YeQO5zDXI8TtWKuDshkXCeLTXI9Jh+6mKm7c
         xmnA==
X-Forwarded-Encrypted: i=1; AFNElJ83WNM3UQLd0xiMvxG4/CGMm/m4Vk+iuraDJeemX8ipcdBw1wnHCvQltx1Xj3I06beX/fK9v+ZYdg==@kvack.org
X-Gm-Message-State: AOJu0YyagnVoJ1TSCCNN5zpnGf1uIheSIZWOvbw9Zm/ahmOFLU5zwkJr
	o7e3ZfEyZHHDb+4OCIScICzUOLGbVz60kHxd8tN1O9tpSU9GJbXNCjiTyQkCNSm7SIisF3Y4F2s
	kSgBuMb360oGB/4cYIaFC
X-Received: from plhu11.prod.google.com ([2002:a17:903:124b:b0:2ba:792a:18a7])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:287:b0:2ae:803e:6c12 with SMTP id d9443c01a7336-2bd010f4ccfmr21818475ad.6.1778572174022;
 Tue, 12 May 2026 00:49:34 -0700 (PDT)
Date: Tue, 12 May 2026 07:49:18 +0000
In-Reply-To: <af6ZT9oR7GGmMFSC@google.com>
Mime-Version: 1.0
References: <af6ZT9oR7GGmMFSC@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512074918.2606208-1-richardycc@google.com>
Subject: [PATCH v3] zram: fix use-after-free in zram_writeback_endio
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hatfoi1iibaqcwe6o5ct1gn1m78ebeg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C3971C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778572175-851404
X-HE-Meta: U2FsdGVkX18IpzMlVcYOIdrKRk67O/g5BBZheShmFr6b2Sl33icBQleGMQ4OIki5T+7s8cx/ncVk4RTDHT7Wj/kXlQxZ/nJur5fvirrSN3IoM310doAR8N7HSF2EtX+BoFxl7cdH15SXRVDa3mEY7VIqZhJDYWZN35cdDQLugs1OBpbsbCYECvhZKLFBh+m+xJ6Zgd7UXAC1+Defc1FysMY0Hd39o6g1bkifWU/TpXUFXehycOswpSb/oUtbpZOZZWLcG91ui8+Xht5wlqzimFAzjIgx77SrURpyMVTxztZT07sASKxNvUNON/EE00L6wru3eJXnwvC1GZ/43HAsUfAyKNHEPK0UQcoVSBB234a70QI06dKvLD5nqQSNi9ldcxNo+8RnCrnrVNYcgrU0Poq0CeG8q1Y1IR4NKXIpgwzV/IQL5rTj1iARZ0mmOic7NkgBBZvITt8ZHDKSpRSV7jHfbYPX7DUkn7sEq4N3PzxRrAIMBHQxpdOJYKK/UJXPy+BI0ddf7BpzOEJ7r/1of0Jm5+0wTtFldLp0KaqOC0cBye2x5PJTpZj9HeC8hwcXao0mOIRt+Z4/bmdleh6jompKyyrXnmA4iZU9ZyMZl8m1w9Kp5CkWTn4gZP0Iz0bxqUHHxsyGQ83w4Kb9VlntqywB6VwXT46pro/OR1YydwR6Ml6LastKy5u6Y6pzGpwqwj2NlTjwI6faPrq1xpQS5WWXaZcQAPDrXcqp956C6XCHfCcfBDmtZxx/9bpClaOo+mF0qya0Mo0jl98CBtIxPTS/r90lmIqKCIq7edwv+sUbS73qK5yCvduc6NzjRkkzacRtLhBGSJ5UAk73Jcc3K5TeD5vMhJDQcBYhQRtS8sLR0dwR+zBMOzKXLHa847nuq0grybYNo+KT1uTW+S1eVkYpzkNuoOz8P4z3BLQ5aLmqNRU+jRNK/KkOytTwNSFbECjobcjYB/W1uufCvi3
 7ick+PBY
 LyaXlnD2cU6PTgVCjderBO7sFB8oqsGvsFOb5gqjDCg6fqsWn9ULvha8ROAVhLM8MAoJLG1PUiSuNyGFeb5bsecJNkk2edbzkro9S/vRZMBTeBqe2UH2533gUcYxGz/FcdQvv5R7mk1bSPAdeO6Amj4IBglv+1oR/axFj4u0EZb7XaTwv7nD3GH+ivNwHkoR7QxXYekr1ocUpImwZCbUSyOde+C7pvhKK5Bp374JJYj8dRKWtbwgxgdHug3bm50iSZ27xiGQkIlcHKswhhTm0CK1UTh9B+Y08Fu2sYABTB6pjpy/o2spwtus0xjy4Vrbmr2gXwGFGhNDu8YzcMiHLurzFIvco9CYGuLVus1m+KqL+4loNN3voAr0/NC/zTr8U0rWlKVTAWUc/pQvO4dFn7yKswWvd+XUaTWl0nkMwzQdYR2iNmgkDtutrb7n+PZIf0SA/7b42s7TgxRQkgGAZ+TpceIVVm36LcZmPaTmfOWNv2ggowtxofOaAyP4q6u6bafr/1xB8ytgMPIBY6dXUIZI3CNkYNsqZFjHf6cs4Uki2z5RKDj7KX1vcThFBydc2tb5F40Ya0t/jxJxo42WHmMBwSuM1wpRimSj4VVDJtDRdTwiasqNLnncwB3Dtq5AsvTT11PGQ7xwq0Ax8TtJLN49HMgotPwXHOTqh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A crash was observed in zram_writeback_endio due to a NULL pointer
dereference in wake_up. The root cause is a race condition between the
bio completion handler (zram_writeback_endio) and the writeback task.

In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
releasing wb_ctl->done_lock. This creates a race window where the
writeback task can see num_inflight become 0, return, and free wb_ctl
before zram_writeback_endio calls wake_up().

CPU 0 (zram_writeback_endio)     CPU 1 (writeback_store)
============================     ============================
                                 zram_writeback_slots
                                   zram_submit_wb_request
                                   zram_submit_wb_request
                                   wait_event(wb_ctl->done_wait)
spin_lock(&wb_ctl->done_lock);
list_add(&req->entry, &wb_ctl->done_reqs);
spin_unlock(&wb_ctl->done_lock);
wake_up(&wb_ctl->done_wait);
                                   zram_complete_done_reqs
spin_lock(&wb_ctl->done_lock);
list_add(&req->entry, &wb_ctl->done_reqs);
spin_unlock(&wb_ctl->done_lock);
                                   while (num_inflight) > 0)
                                     spin_lock(&wb_ctl->done_lock);
                                     list_del(&req->entry);
                                     spin_unlock(&wb_ctl->done_lock);
                                     // num_inflight becomes 0
                                     atomic_dec(num_inflight);

                                 // Leave zram_writeback_slots
                                 // Free wb_ctl
                                 release_wb_ctl(wb_ctl);
// UAF crash!
wake_up(&wb_ctl->done_wait);

This patch fixes this race by using RCU. By protecting wb_ctl with
rcu_read_lock() in zram_writeback_endio and using kfree_rcu() to free
it, we ensure that wb_ctl remains valid during the execution of
zram_writeback_endio.

Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
Cc: stable@vger.kernel.org
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Richard Chang <richardycc@google.com>
---
V2: use RCU to manage the wb_ctl lifetime
V3: add stable tag

 drivers/block/zram/zram_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..07111455eecf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
 #include <linux/kernel_read_file.h>
+#include <linux/rcupdate.h>
 
 #include "zram_drv.h"
 
@@ -504,6 +505,7 @@ struct zram_wb_ctl {
 	wait_queue_head_t done_wait;
 	spinlock_t done_lock;
 	atomic_t num_inflight;
+	struct rcu_head rcu;
 };
 
 struct zram_wb_req {
@@ -847,7 +849,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 		release_wb_req(req);
 	}
 
-	kfree(wb_ctl);
+	kfree_rcu(wb_ctl, rcu);
 }
 
 static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
@@ -964,11 +966,13 @@ static void zram_writeback_endio(struct bio *bio)
 	struct zram_wb_ctl *wb_ctl = bio->bi_private;
 	unsigned long flags;
 
+	rcu_read_lock();
 	spin_lock_irqsave(&wb_ctl->done_lock, flags);
 	list_add(&req->entry, &wb_ctl->done_reqs);
 	spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
 
 	wake_up(&wb_ctl->done_wait);
+	rcu_read_unlock();
 }
 
 static void zram_submit_wb_request(struct zram *zram,
-- 
2.54.0.563.g4f69b47b94-goog


