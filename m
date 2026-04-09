Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CBC7F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CB46B008A; Thu,  9 Apr 2026 12:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014716B008C; Thu,  9 Apr 2026 12:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D2D6B0095; Thu,  9 Apr 2026 12:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D74396B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F0AEBB81D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:08 +0000 (UTC)
X-FDA: 84639486456.21.82C3F84
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id E4EB016000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gh85pBMa;
	spf=none (imf08.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h53OigJvhKi2R7WTc8tD2Nme4RfoPqZlyMjNikVjZqA=;
	b=NB2X3+T3UFcUibyIMH/PHAXrPTeOSJAAJw5gQ04SyEXrSTnSz4BVIeACaFtCTYN32bd+hi
	iSw2ZP9ONZWhIT1Hi+M65hevsLyFe328URXzi0kwMAfRJtsV918ACQshCqzq+z6qMmUaTX
	6FehYCTxc/+/qDX/dTbLuR5Ngnot2E0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gh85pBMa;
	spf=none (imf08.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750587; a=rsa-sha256;
	cv=none;
	b=N4V5Zl+RX/dSMwIMeXocmMG5UeBLWtsDo4Gr4Uve1EAfm0gPmn5fEsZWLC2q6RsBgTrayM
	Aw3eFiCJxusIJw60pxj/l2VfMsCn7c4JGYtBpkuYv6KR6CnLmywkONhs1PfCr0vXSU1l4U
	IgVj04rEi7gteYHO7LVlecBIBZx5Ew4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h53OigJvhKi2R7WTc8tD2Nme4RfoPqZlyMjNikVjZqA=; b=Gh85pBMata1NecuSQtkzPmgc8E
	y1ebnQvyYW25FfwUI17O4uZoCDE7vls4dhGt96+ueNNXPYmujBBng7gsL0iUV75VIfe8J6vn2aG6a
	ZPAfuTRRfoC17tS3PZ0HbJv1P5BeTKx+sfpGs0L3+tw7U6PGAgrkBmMo7Y4EQLOk/ZGBMAtr48oz1
	ODp7rpGFFHu/QFMmE2Rzpbo44Yj2BbVwHuodmI5KQr7Gywz1TSTAxvyE0uT06c1VVNkVDXeBeHyXX
	NVVPn66SBi1sP/VgWIzRWLYj9yti124GCrwl0cae7PB2PD5mv3sZQTBrA5TeKG2ipRUAbGSMz64gD
	Xxu+2rRw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArqO-0000000At2j-3j5h;
	Thu, 09 Apr 2026 16:03:01 +0000
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
Subject: [PATCH 1/8] block: add BIO_COMPLETE_IN_TASK for task-context completion
Date: Thu,  9 Apr 2026 18:02:14 +0200
Message-ID: <20260409160243.1008358-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: 46b1s5pw35qsjwssiua7wyt67z8ax4sw
X-Rspamd-Queue-Id: E4EB016000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775750586-417726
X-HE-Meta: U2FsdGVkX18+goYc3+v5A4lqDul0CT7QrtyokMHlPcBQXXMg+k8+yAvbOrWe9LP0aali8ZN9dR55DqEOAGhqUEgbKB3OJBeYp/H8sOk0DzU4dUntPzVk1IdOl2Tx23mSBicvU/OP0yuV/95T9iAC4EGZxHlkCGnrNt1EC2ur6XgDi44rl+gTIDqPi128e0y4SEy9Ly/nw/JZ1kRF2uOgZH9PDSC9Kuilrd1qZzEyITq4y1CxNq+rRZ3qfhne2myZkpqbWyJqEJ6CWz3J+j4OnU7G+HG5BqKpBN39kJP+6DtzQ98AhP1XzvuAOW31nrWXoAHk+DvgG6cN6mMZ8UD6Jm7wY2yuBAboam27uQgEMmWxgRE6XJ3UFKBG9B8VlHcOs3E82LFJx+tFxZSqeHdR+KydQkwp9joM72we8CrRaalczwbNwkRwsPW6VVV8y0Fc5vYZvcfgKQOg7vW1AI/K7tyQ+CqXzOXG96MVrcWaMq1Kl83PziX0zoZxg71R0VfY3n/6Uoh0GMnd6LCM9zxB/kvi3OpDrVctWqh3sWpMhbJHtq683fHN7LPhJT7T8pW8qLCze/q6LZWTSUj3UfL4cwwy7WA0BNUVFp2TRVayir7ikrps0xfX7L3mebLFIlPXWNdL557bnXSadiwEsUyrIe9D4pJSOZzjFolEvw80c/vgEIuGWHiY1HIsPo2gbsisOLiKRrdEJvoVqFcbLDf+EwcJGWWpfOFOhckT7f8xh78pOK13WnKFvgvKqIn5bFNgivEhUE5ie4kqJtLftdHWRa2sgkJspJwsEkAI2xZai0E2kxN718ezok6OaPvy0ehwKa5Em/KThmgjUCNJMQNOpOSmL5/s+sFRbCfZEziL0pUI+uHADdbFR9WRM8ma5WB30DsFuZHIxxF4ToAtIE2S6NHvWoNADO7073LNDM09tMNDAtQ6aolAwwh4fIU0z6T1nMkGRfZT/GE+dQMR8tx
 52cN1dEb
 xdHZbRrfJarmbcUZq7X6AUKOtyNuAsyUytJ70QWY9UcuabSHWIQ9JKhcSinUEUx/xuvP4ST3FprvGgZH0bPEv57NkoTSKixU5+fbx06Q//RDh4nGEVyA6b8eodbBBFTo9gIqyutE7/5ieTMqYk4e6Ocs6KDzeWBoLq3rR6LL82luesyzCRnyj32vT0pXXL7uTok6zrBn5rOAUqRadSTQOT/gfrhO3qz8mKm4TlkVkx4Pd/jUHX0AO1AsV3Q+8WFcrp2f0blvDpPWnio3IdizkgOutdy/QQJcBSRQ5xBvFpEaHKReHFvNC0Fx6o0ok+/L2hr/ufaEvfBBDU9noaj71akITHfOOCmrxwHvPurFclrTg7vERqMug7rDARJScmtQL/AV1NtYujNjLE1zpGnwmzhrG9ohpCZSdOPFYbvuglfPi6dzrOJlc43rZN3haGuZ3SB+GZPYsz8P6cJK9K95BLnlD9GpxcvfxVqtPi60uuxMMM9T/4e71/c9iQrJd1o0ODWv3899fjXWJDjZHLUs8CcyYubdGZnPdU6Bt6xrGuU94XlNxd//MRcuNSvYKwT8D5ZW6QWKHQnjhpyq/TjOOKxAm5FyI5il02ZeZ+FzW7RKyaqZn8bXcztoECB6NQsMBMrW7X0SM0NeBNAPYduhhH80q5P3Spdz1fQRaqFcE9c+4biknLhSl4GdeAhKloGrmM7tPrYS3wxszNplBoqkQ+pulsXpSFIxTECHzPxh9nU7b01s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tal Zussman <tz2294@columbia.edu>

Some bio completion handlers need to run in task context but bio_endio()
can be called from IRQ context (e.g. buffer_head writeback). Add a
BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
task-context completion of their bi_end_io callback.

When bio_endio() sees this flag and is running in non-task context, it
queues the bio to a per-cpu lockless list and schedules a delayed work
item to call bi_end_io() from task context.  The delayed work uses a
1-jiffie delay to allow batches of completions to accumulate before
processing. A CPU hotplug dead callback drains any remaining bios from
the departing CPU's batch.

This will be used to enable RWF_DONTCACHE for block devices, and could
be used for other subsystems like fscrypt that need task-context bio
completion.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 83 ++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  7 +++-
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 641ef0928d73..550eb770bfa6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -19,6 +19,7 @@
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
 #include <linux/kmemleak.h>
+#include <linux/llist.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1716,6 +1717,51 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+struct bio_complete_batch {
+	struct llist_head list;
+	struct delayed_work work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct delayed_work *dw = to_delayed_work(w);
+	struct bio_complete_batch *batch =
+		container_of(dw, struct bio_complete_batch, work);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	do {
+		node = llist_del_all(&batch->list);
+		if (!node)
+			break;
+
+		node = llist_reverse_order(node);
+		llist_for_each_entry_safe(bio, next, node, bi_llist)
+			bio->bi_end_io(bio);
+
+		if (need_resched()) {
+			if (!llist_empty(&batch->list))
+				mod_delayed_work_on(batch->cpu,
+						    bio_complete_wq,
+						    &batch->work, 0);
+			break;
+		}
+	} while (1);
+}
+
+static void bio_queue_completion(struct bio *bio)
+{
+	struct bio_complete_batch *batch = this_cpu_ptr(&bio_complete_batch);
+
+	if (llist_add(&bio->bi_llist, &batch->list))
+		mod_delayed_work_on(batch->cpu, bio_complete_wq,
+				    &batch->work, 1);
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1790,7 +1836,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		bio_queue_completion(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1976,6 +2024,24 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+/*
+ * Drain a dead CPU's deferred bio completions.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct llist_node *node;
+	struct bio *bio, *next;
+
+	node = llist_del_all(&batch->list);
+	node = llist_reverse_order(node);
+	llist_for_each_entry_safe(bio, next, node, bi_llist)
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1990,6 +2056,21 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i) {
+		struct bio_complete_batch *batch =
+			per_cpu_ptr(&bio_complete_batch, i);
+
+		init_llist_head(&batch->list);
+		INIT_DELAYED_WORK(&batch->work, bio_complete_work_fn);
+		batch->cpu = i;
+	}
+
+	bio_complete_wq = alloc_workqueue("bio_complete", WQ_MEM_RECLAIM, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
+				NULL, bio_complete_batch_cpu_dead);
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..0b55159d110d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/ktime.h>
 #include <linux/rw_hint.h>
+#include <linux/llist.h>
 
 struct bio_set;
 struct bio;
@@ -208,7 +209,10 @@ typedef unsigned int blk_qc_t;
  * stacking drivers)
  */
 struct bio {
-	struct bio		*bi_next;	/* request queue link */
+	union {
+		struct bio	*bi_next;	/* request queue link */
+		struct llist_node bi_llist;	/* deferred completion */
+	};
 	struct block_device	*bi_bdev;
 	blk_opf_t		bi_opf;		/* bottom bits REQ_OP, top bits
 						 * req_flags.
@@ -322,6 +326,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 
-- 
2.47.3


