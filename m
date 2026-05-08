Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E76CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8804A6B0123; Fri,  8 May 2026 04:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831896B0124; Fri,  8 May 2026 04:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747576B0125; Fri,  8 May 2026 04:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 632CC6B0123
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:50:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08B481C0660
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:50:49 +0000 (UTC)
X-FDA: 84743632218.06.A6F42B1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3827F180005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:50:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OZcMsru1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 35aP9aQoKCHopgafYpbwaaemmejc.amkjglsv-kkitYai.mpe@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=35aP9aQoKCHopgafYpbwaaemmejc.amkjglsv-kkitYai.mpe@flex--richardycc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778230247; a=rsa-sha256;
	cv=none;
	b=Xhi9rTOEqGl1ln1/ERSEfvxyOaYSs95VFRAFEgL1q92oldHksc3WUxi11DF13L0IkvngKO
	rSgKM3OIZ9ccnEmKpAeAECzCeGnwCYl4BrECsuKtMeVPvC91r09PeQ4T4Xda6lige0I8nQ
	X7cXsY5AiS3qmuQBJ/FBilyixXxMD5s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OZcMsru1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 35aP9aQoKCHopgafYpbwaaemmejc.amkjglsv-kkitYai.mpe@flex--richardycc.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=35aP9aQoKCHopgafYpbwaaemmejc.amkjglsv-kkitYai.mpe@flex--richardycc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778230247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGFRFy1WoEV55J2RPFTdCgdsXVvquGiPRRD2auMcPnE=;
	b=MiAsun4RaEZ3kY6MA3ueSN4Nv9aQt7EHWldRayCw91/O8cs4V+Gd3ta2RBTM2mSo9bihlv
	ifYI9ggzM5WAEvRPyxNLmRdgkIQGGrVuEYKtBipVjOxozv68P7MUJ8tfM8/OzHvT6QfJw0
	V0fBP2bicCDSg52GAttfiWfpan2ftW8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c8252a49ffcso2179865a12.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 01:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778230246; x=1778835046; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EGFRFy1WoEV55J2RPFTdCgdsXVvquGiPRRD2auMcPnE=;
        b=OZcMsru1fi8yVRMHmbR1aVV6eT9fFw8I46oejn4+gUNIf/9m+UBOpKUP7JMJV1KcR4
         KygGMrLOhO7+5VgFdHAEKvHP/kHHFYop1Pl1xHAS23HK3mslbE5PNRD0/yl5HAN0p3j5
         42c7QBcYoh3YMtTbC7KogNqNy/YNQa2iir2kLjFoV5aFtrzRBo3BVPImtntDcqSPE6ZP
         sjtrA9Jt12tntzRrE37uTVp2J9t8SFVmgILuqzCK3Zoiss/gr8ipmKBa6K2g2WHA38yg
         kU3LOgnW8tOvrFxQwwXliPcGarDyqyBLzfpe59X2DsPzIon9WV0O2aAwSL0zEn3tLmHv
         KOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778230246; x=1778835046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EGFRFy1WoEV55J2RPFTdCgdsXVvquGiPRRD2auMcPnE=;
        b=H3D3f5QlU4DzsWr2bFm5Jkf07F1x8O+HqJvT4ch+M9D1hjj5S61PkG0e0HGgaw+C73
         CS0L9BhpwCB+C2jYD1MgVpxNxV5joiy30NGnlGc6taaP0vD9GZj8j7l2gXmPw57rxeNl
         fVMjmPhku8CTfp6iizdUABBurAy+NzWL8WBh4Rt84qP7Y6AkOT9lRQ5D/2FDk49OapH0
         USwhdwENB2zdgr/zOXGazwIA8a9OC1EsN6H8WHc+eMJXbd4Eki3qKZexRJ14gKQgsk3f
         l9CaaesZAfXcLQ+UErUZ6xdp2WSvMOPY/1QQikEr3Mlkh9vxQc4dP6of98ZMIyh2xy46
         AetA==
X-Forwarded-Encrypted: i=1; AFNElJ/M8dIV3CexsaRDcZuOvuhebcgp10rOFbMS/kXnkDpSfjH5aMEbTfe4GLtITcT60hUiNfKC0QUzEQ==@kvack.org
X-Gm-Message-State: AOJu0YwyQJBlR6wzJgD/kX7VWpCeDkSKBbmgcLiu3xgSeh08NIS70xka
	T/VOZ20yWu9qF+me4ES8wiBfVQPi5LRiWaMVL+Sy6R9xwctvX83vGb1ucQ6oRofj4PBJV/kMiih
	BSEFPr2TpEETg3+F8hU2W
X-Received: from pgww20.prod.google.com ([2002:a05:6a02:2c94:b0:c76:5ef4:ec3])
 (user=richardycc job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d91:b0:3a8:236a:7df2 with SMTP id adf61e73a8af0-3aa5abc86a4mr12929465637.44.1778230245628;
 Fri, 08 May 2026 01:50:45 -0700 (PDT)
Date: Fri,  8 May 2026 08:49:33 +0000
In-Reply-To: <af1BNwmyHK6aU_uT@google.com>
Mime-Version: 1.0
References: <af1BNwmyHK6aU_uT@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260508084933.3730661-1-richardycc@google.com>
Subject: [PATCH v2] zram: fix use-after-free in zram_writeback_endio
From: Richard Chang <richardycc@google.com>
To: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Richard Chang <richardycc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k1chsfrmjyyzc3g1gec9qubtdeyi779s
X-Rspam-User: 
X-Rspamd-Queue-Id: 3827F180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778230247-718465
X-HE-Meta: U2FsdGVkX1/Nk47kdd7QEPh3ICLnahKGdJgirrOmnf6C208xWudGw/mZmOGRG8MpUiHtoUnJFUUZ9wDhndJSPB+f4LtsaiK9WAMxzuFUu4+0+kob1+oma6vRejyNmyozL1EmFTm4nAQr8i5I2jHVC+MPSMLlz8lEYh6DyLCb5tBsBp/FokAaGXK0nA2wp3QdgiK+fEhN7uNqZsIVpU1J7nA/olL5xQ40agWOF9Bu8AVfO/PieiCaX1bsGdYiwPUqN6vzV1tz1iSeY4CjKSXNJgSnxoLYe/mnjteo8LcRkjGoO03K2jyF9vmHHhKEXFNCTyf4/t8ALBXoF3zuMP/nhKDP9IhjhtPzNxeJVN2sPrmcF4co92rviTxDIE/93kYDRSvcO1FNBFjlqBrPD5zZ/dNxGkazRtwnSlM/d0RDZhbMRi+txnoKcLeTbMgPqelDJT0eUQlcrmdoits3GGUkDfeJpJcVTxORuePsVISVKuWKQACl4sZLf8X6kYK6RU1zWDkhYj7+IfSVmlbfBO9tpeZvKEvmS29HinO5xFYuPywSiBvBynmpagV2RXF7Jtprviob6gxm7xwA5TM2cKWsjJXp0KGdLHxXWy+Vmos/2yoPCa0RBbmuAclE/Sf1mmQ3AvCt5ltSLZEePQ21Fla2Fty4i8MV7BNhJbZxBQ7aie5x3NREBU+XDVnySh2KC+dBdXciYgv+lq1JgE54CIdV5Qdsm4JDytuWROWIDRnENQN/2DdUYSTAQn7o61vB8umq5I0YzqboAMtQhVCHu4eZuMxjW0F1NlB1NY8OG4rQ8RMHBe/yVU45HeZPXesFt0WGtBHhV88Q9IA/3gIjhDcgrm8rW5ACsqRiZeFmXTn5NP4nIjgByAzABhOtCujnCoi4BOAPtJpfr9ec052UZsfGTOImqHio6Ks5RXcT3WNvIwzoGql9xwlZ9IDb1kHvqV1E1FcGp6T/zycMfubSc6M
 yJOlOBNQ
 SneqMfsICkIAqScc+cNTmw+RmxNf+pZc2k+eSbwBzjUGr09lsuIM6+7Gm5MOiSUnooXdwsSgF5eVGd8RE5+QUaCWKR1/b2N9FDkMLyGBmDSQYa5NgNoaUotVtAISkTLqAdGg9RpfUb0beNuJLp8WhwMWEhmOB9xnHD+q5mOaAng+lnu3T2FZzJ5/OB8Lh4i3HX8qdhzVOHIdyc9GnFYYYY7cRaddUyeQQKp6/J5HF0F6M8bos2EXWWh4phCdCAQ2WdUUi3bj/Bak1bxj9um/O72rCjXBCw8my1ARTHsmtIFKsp+A0KppAzwf9DNsWEPL/SNUqbOGXOQEGIZycKIzbBQivNw4BfFmDbEcCBeIVUF4zxWw2CH09uprRJY1ZbWJkDpZQmKynxip8D6CsYfgUhEebQ1qpTms7ayIQ+RUlPNjeiRO5DcvLTXnrPjlm0l7FQ0jf5G5i9NRWYul6/C3Tt+AGfl7maljkrd0M94l9ognYqGQDgok/9vRvHNjwKep3se/soMQ0pkUDqRALeuYdCnSb9cdK4D3VekbiAEc9r/cWo1Xb0ARppsZ9K/yOPoDv20gtvj6dL2XZjl9zRfOvO+yFnSx9ctusSVvxg7cqNnWCKqpefNOn+3MNAWATXyDa0ZOA/GqC+b7yHRsbDhRB4KEM2Q2+OP6zHaxu
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
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Richard Chang <richardycc@google.com>
---
V1 -> V2: use RCU to manage the wb_ctl lifetime

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


