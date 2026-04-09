Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E981F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73B66B00A0; Thu,  9 Apr 2026 12:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD336B00A2; Thu,  9 Apr 2026 12:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBCB6B00A0; Thu,  9 Apr 2026 12:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6923E6B009E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:04:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A0FF5AD32
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:04:14 +0000 (UTC)
X-FDA: 84639489228.20.ADF8B5E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 646A1120012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:04:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nIzszVk5;
	spf=none (imf29.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qe5mnGzEB/wWBOUGDmubvFkmhKAHTYP67dtOsLhdgJI=;
	b=I7KwgF0h5onSVzLwLSNu/qBj40BI5/ft7hDsZdafswJbEd6GdvhLWgmQOEMftsnBHQqoVX
	qfmM7DaeTYOvItv6jaw92o1R3g18kmGwolbTQAc9osnXAQQOhpjJQpW6qeq1E+4P4T0TIp
	fQbONMAoHiYH19zrPe/Kk1ufk5p05zI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nIzszVk5;
	spf=none (imf29.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750652; a=rsa-sha256;
	cv=none;
	b=xTEe055sLPVrtRAI4Li55g3smXIwou39Hn00mD0FR2y5sFizOzCdK40Rge4d0FaJAh3tyo
	ek/Gy+UTyAtobIfvcGc2t1DceC2vcrrZFSerjwW5jNKwyg5pUIM2Hsxg4nteSq/VPSj4w8
	dJgsw4M+bmauAhl83tKHETZT17WTl9M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qe5mnGzEB/wWBOUGDmubvFkmhKAHTYP67dtOsLhdgJI=; b=nIzszVk5F/SLjplG6aMsYgl9n8
	coxGaRbHTbaQHQ81UFEVQMA8CaN/uuOWbPLlgU5Sw5BfWk4MNBbgKG2DJNXhvJAlwOqQ1eaZ2r4si
	jW0Hh7ufGU7cZBohm0ayLl2aYPLfAFxsUOSzIhTVu6YnkvQ73VNgB+gLr5tS86C985EzbGZ4Ka5C/
	YAov2SC0M4mFWZha1SkPprrz6kK7vc4GQavDpHnKoKJZd15YJfoy8sU97IW/6DSJPmwErm+wPn2/j
	q7PnDzsP4c8aw0EmXP3/PveiQOxOHBkYGfQ6pPH+V8MAnsneZccORuYJ8iJQB4/TwfOCIskH4qdHg
	vygsLNGQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArrS-0000000At8n-1mov;
	Thu, 09 Apr 2026 16:04:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion support
Date: Thu,  9 Apr 2026 18:02:21 +0200
Message-ID: <20260409160243.1008358-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: jqypewwhhdbj8ykze7y51a5ustx8ahm9
X-Rspamd-Queue-Id: 646A1120012
X-Rspamd-Server: rspam09
X-HE-Tag: 1775750652-863668
X-HE-Meta: U2FsdGVkX18OH3JBdkKJeOSLgsQOgm6z2qcN67PXh6KN68nmq4nDYOCox3qOnlr2h7M6kqqZXuodsbvxOZyLr6h0ZqnUPvJ2kEmA6ElPOcUhSGnqY59RxNqjehjYC7W6xvJaCtDhGoi6cgH/xB8Dg6PIbFQ/6/qPmPZJMJzMmcc/Aj65Sw4LzEdoTTd5ICQuHIRrAq2Md+BmJGW0Sb5TaVN0WOiGW9L8dJB0iU5PiIIQom8RHzYsm3SUNToHsQsIUolxQlwKiPTWXzKyGh5HPweGBPKBJJzdsWbxzzpnQSp6qREVqTIYSTYoHzKR7v1kCzKBxggqN5y6lV0Dll/wxVdNMl/n4d1okmZ23IEA4XAaUKW/RhlOYnHXehw6Xa8D2YWgLqsfxAq/58V72ly2XPU0k5M1QuW9XXGXIFbGphVfq5cBROVc1E0IoBlhJTarU33rU0VDMSAKusjQ29D4EfWnwD/LNFd/LpvgqqSRXNdtm9Lx91O8k8oD82A6dmejwA9DWUADAxcfCc3DbDT62ihaOnpqtZcasLD4umSJsXJNzhsFi9NVGfsjWdzSscLs45zSOE8ZO+QcF7aO5u1DPkj6gFr9bXAUrA3yzLz00aF5k8J4OEb/pzybOw56+3AR7jSMJUcJVbgW5aGpaGkcxhofIJgTkAG7nvM+Pt8q3G7PJvBVyHb3+kgZfTPZ2i8KvkrUtrBbKOperyU3WNwZGW0rYTTYvLhdyQ4THT5+q3xJMNY6OuvcH2mUI0bMPdWhHDLBlqDfYJXzpvErDnxgare2RS8KykhUaj2jR3MlUV0WHmATT7Yr7l6OUmqQxcDIaanGjyH4PYIp6dw43EFZLEAJnfXbaO9BSv0TzoGFx2zNB/vkyBVJghkWTnbuLt9kl9FpAZKpurnsvQAW75GxdW8nQltX1eAWsZRT3hdWytjAciGdpkZ0WTEGj1LrP5IjAoASW3ZIg9c0ydur3o0
 ltXxIsem
 c89sHYgoNfgV+QBTqDVojKqE3KexRcOC0EcO7i87t49onyrucCl3kY+kJMQNvLbDeKZqV4ne81daMzGyBq/4xvnSxwtDUNko3SzjDWnPpBVEj+5JRG+bBoq3kl2yFHUrGDD2o3PtOP6l4y/JGfENm6vzk9PlGwu/P3pxkOjZaEAwEYUxmUg5/v+2zA9+6mS7S2P38yMX9iMXHDNsQhHFpKK8urEKN94V4WKabRvn+8RoBgGLaNikDxzAF2mbzhO+Y6WfMAp8Flt4nzaxE4afXkhJ2kxXDnkugQK+6VgZdnX3zzPM6gHwSzSSR6kjQX9w94GTFuJVfAl13cEpOyA+jUmR8cyy2q3XzG1WDocWwAtm968E6G7jTdxdEESGb2IV1aqT3zI9QP16wBoebnWpMZEPf8egV9yxJKbDA03mblmZUrMQ/QsStH69blzIEeyGut8+37CuY+WUW11FB7PzlhPngN/OCoAC82vIFA7eGysMOb3rA+9FLFsxUiSFL3HnA3TREYqyLkpHQ5mCjk3ZTKwaaNQ0yrt3bAfU2NUdTfrN5pWe1kQFKMMBOvm9DjFFXfXQp3Yz36e5QEoRpiftsP7nYgWht6RJOhq1tg4DdAfFWhL2n9o0zrkQrNbiLXLjm87n1wbZEDNwSOdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
option") explains why workqueue aren't great for low-latency completion
handling.  Switch to a per-cpu kthread to handle it instead.  This code
is based on the erofs code in the above commit, but further simplified
by directly using a kthread instead of a kthread_work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 117 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 52 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 88d191455762..6a993fb129a0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,7 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
-#include <linux/llist.h>
+#include <linux/freezer.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1718,51 +1718,83 @@ void bio_check_pages_dirty(struct bio *bio)
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
 struct bio_complete_batch {
-	struct llist_head list;
-	struct delayed_work work;
-	int cpu;
+	spinlock_t lock;
+	struct bio_list bios;
+	struct task_struct *worker;
 };
 
 static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
-static struct workqueue_struct *bio_complete_wq;
 
-static void bio_complete_work_fn(struct work_struct *w)
+static bool bio_try_complete_batch(struct bio_complete_batch *batch)
 {
-	struct delayed_work *dw = to_delayed_work(w);
-	struct bio_complete_batch *batch =
-		container_of(dw, struct bio_complete_batch, work);
-	struct llist_node *node;
-	struct bio *bio, *next;
+	struct bio_list bios;
+	unsigned long flags;
+	struct bio *bio;
 
-	do {
-		node = llist_del_all(&batch->list);
-		if (!node)
-			break;
+	spin_lock_irqsave(&batch->lock, flags);
+	bios = batch->bios;
+	bio_list_init(&batch->bios);
+	spin_unlock_irqrestore(&batch->lock, flags);
 
-		node = llist_reverse_order(node);
-		llist_for_each_entry_safe(bio, next, node, bi_llist)
-			bio->bi_end_io(bio);
+	if (bio_list_empty(&bios))
+		return false;
 
-		if (need_resched()) {
-			if (!llist_empty(&batch->list))
-				mod_delayed_work_on(batch->cpu,
-						    bio_complete_wq,
-						    &batch->work, 0);
-			break;
-		}
-	} while (1);
+	__set_current_state(TASK_RUNNING);
+	while ((bio = bio_list_pop(&bios)))
+		bio->bi_end_io(bio);
+	return true;
+}
+
+static int bio_complete_thread(void *private)
+{
+	struct bio_complete_batch *batch = private;
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (!bio_try_complete_batch(batch))
+			schedule();
+	}
+
+	return 0;
 }
 
 void __bio_complete_in_task(struct bio *bio)
 {
-	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+	bool wake;
+
+	get_cpu();
+	batch = this_cpu_ptr(&bio_complete_batch);
+	spin_lock_irqsave(&batch->lock, flags);
+	wake = bio_list_empty(&batch->bios);
+	bio_list_add(&batch->bios, bio);
+	spin_unlock_irqrestore(&batch->lock, flags);
+	put_cpu();
 
-	if (llist_add(&bio->bi_llist, &batch->list))
-		mod_delayed_work_on(batch->cpu, bio_complete_wq,
-				    &batch->work, 1);
+	if (wake)
+		wake_up_process(batch->worker);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);
 
+static void __init bio_complete_batch_init(int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct task_struct *worker;
+
+	worker = kthread_create_on_cpu(bio_complete_thread,
+			per_cpu_ptr(&bio_complete_batch, cpu),
+			cpu, "bio_worker/%u");
+	if (IS_ERR(worker))
+		panic("bio: can't create kthread_work");
+	sched_set_fifo_low(worker);
+
+	spin_lock_init(&batch->lock);
+	bio_list_init(&batch->bios);
+	batch->worker = worker;
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -2028,16 +2060,7 @@ EXPORT_SYMBOL(bioset_init);
  */
 static int bio_complete_batch_cpu_dead(unsigned int cpu)
 {
-	struct bio_complete_batch *batch =
-		per_cpu_ptr(&bio_complete_batch, cpu);
-	struct llist_node *node;
-	struct bio *bio, *next;
-
-	node = llist_del_all(&batch->list);
-	node = llist_reverse_order(node);
-	llist_for_each_entry_safe(bio, next, node, bi_llist)
-		bio->bi_end_io(bio);
-
+	bio_try_complete_batch(per_cpu_ptr(&bio_complete_batch, cpu));
 	return 0;
 }
 
@@ -2055,18 +2078,8 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
-	for_each_possible_cpu(i) {
-		struct bio_complete_batch *batch =
-			per_cpu_ptr(&bio_complete_batch, i);
-
-		init_llist_head(&batch->list);
-		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
-		batch->cpu = i;
-	}
-
-	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
-	if (!bio_complete_wq)
-		panic("bio: can't allocate bio_complete workqueue\n");
+	for_each_possible_cpu(i)
+		bio_complete_batch_init(i);
 
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
 				NULL, bio_complete_batch_cpu_dead);
-- 
2.47.3


