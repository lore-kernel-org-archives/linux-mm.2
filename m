Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B0ECD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E329D6B009D; Sun,  7 Jun 2026 23:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09B56B009E; Sun,  7 Jun 2026 23:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FAA6B009F; Sun,  7 Jun 2026 23:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFCD86B009D
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AC624090C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:17 +0000 (UTC)
X-FDA: 84855350034.10.99DE065
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D2CE21C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbA68OU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuwEd9q0hgQ/W0hmwr4wo03yb5oe8N9Mp2bIxGqEObI=;
	b=JMJW01YYjyB6txTc41fM7KlB8PnfEdczhlIE9pWa1OwZIVn5z65udfy8PNlm8Nh/P389rD
	uo+Z6ZhG+EtjtpgNC+nFMuZdeIDBcOFrmlPjQIN3zg3xqlZb7mcmtNIeKnwBIngrRnPgJd
	Kw61FzvggKSz6fUTUpsT5dP+5ts+Ivg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbA68OU7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890195;
	b=pdnFqlk2gm0rki/odSsEajGBmfXjSA6Tq66XF6Mu8w2U8joDV4yNsX1TwNCBaYxHotpBJf
	Tib7CDtot32UmV/lkupKnKGPcaM9OXgGt7Q+WPJbkX7NG4bBPGSxKYkhF6oGtl3vL9fhOR
	sn+6mHeBRfifEjxv5h3DWy+oV6igEo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15A7343C4C;
	Mon,  8 Jun 2026 03:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0CB1F00898;
	Mon,  8 Jun 2026 03:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890195;
	bh=vuwEd9q0hgQ/W0hmwr4wo03yb5oe8N9Mp2bIxGqEObI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbA68OU7rwCZh52sRF98htb0dhiuh/KATAF4tJlKA4uL0h1y72Rwfg5n1HwT2Iatq
	 2QBs5e+7arpdsq+7Dy8/9Z3KL6bO2QOi0AtlsP02SyS6J6r5ume+CRnpXLmyLe/8LO
	 K8MiJuKAyIiZVOv9OFkM8WBUshcOEkxA55DgwKbYZ9By9NUHmYb+RJ6tavH/5UuyZh
	 bGfpofy7aTfCFCXLladRntpq0W0VQHF+oN5McMMVfsdPEdUACiYEIV1/7YO9HBunEu
	 oxXFmVx4xZ6airi8Ma5C3tnUoluJ4Ab34CdPYb8KqeKVg/ut1OTZng7rxPfURzMumA
	 ZruqfS3oUKxhg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
Date: Mon,  8 Jun 2026 11:42:45 +0800
Message-ID: <93f33cc9e5a39dddb78dcd934d0c1d04b564fb00.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jzpb8pdcc7s713ic1tmjdrwgn14dcezt
X-Rspamd-Queue-Id: D2CE21C0003
X-HE-Tag: 1780890195-753521
X-HE-Meta: U2FsdGVkX1+utnvmGdesBLtdQVkN/7gLseqOKsfCPP+6ietnGVqpE2ecjLY619C5woTCP9AfUXxqlvXY+W/wK5uwqMfERclkvhOc59x7NzcOsqOkDM5XNiXrP81RXBNGxRURvDFtF5IuopN+BBd/zwgQLeTJKEf1WKItYwPybdb0uPR9oHxT4rGSz35QQyZznpap6xrteKhdng9QwOfiNAGGDE1W4G5Fkov7ThmNuFoulWHy9k2ohcbFPq5qhqzdjj9jd8MrfKlkbwg4L1czaNV3yWq6ulgwl6MY43jvKxLirjc8FoAgVI5MCyp6RyUj8Tnn8/FiKLWvW4kaWl68B1O28bv6o/a8gO/llQGbovyjqTuY6QUk752XtEu+P3KPRMLUCJVYSTVDMCJaAOvLkJYWGp3pvyXOBst2tsZICbdtOWen6dkQLhllRPGnhX2zmWTh/TtqP4FgVhx/p/SKvFZp8CL5h56Ouj2p7LpoCpT+wSyfteM8klAKZZGlPipJivt/C0TXStfEE2xFSU34vmTcpIQyrqTse8pO+DMPPBzn7PPinHqL/3tVgzcGE8Wq+4T4mzsHRTm9BsKdzQtCGE68r8biPxRVfga8RrD8+8ndHudZ9n9MxrwsFm08pksMowB9pkglEv3KBCynzR5huX8+jjjF7qHQ4sOT5mILoYibpPHdfcoazvzxGKJRtr5TxJ+Mlxx3W43StvaBS7kefyoRpMLDLnPKR4/LI7YW+EhACVQZm2diEQtSopJ82fJgaBwJG/WZ9D/pRmh2cQHRMmzeiJpzbwOQHAoSNGoQGOltfz/rn9bff+XLFYmykdG7iwL9vHdm+0fdjHZryZxLWqK6tLBFWpFD2ATRDVUYcLMWInbPpdnIGs9yBkqwRhvk6P2rKqKgK2J30EzWWs1/V1C4V3KgxHXHGn5+xtPqAf1tbzQJ1cNk1Qkpj62bewUcK/iHYAfY45OekdJSDIG
 GIGrfFfZ
 n0SvFoPgIQxXxlQFmpoujw0VOsdvd2UprBj64bsW6eszebyRNi2RtGVqHQmuGgx6A3SAKZ48u7JNuypqbKJ2Z4mApe4cys/mWIoAQxhulI0u9JSQZblGG6FRKat/Z9tbqaKgRhwoS+02vtDLLuQUkI1Q9CpemeRdheaXVrv0lnZiSj5bAwRl6xodpta3rmZ7JwyMj/GhWB2psjUrfuzy5hOdpFrT21oAi8LHKJxv7YZkKaaRIfvt/xbtZMZK04iRMxBSPUKhGwz/WlxOWxc0GQ+PLVu1+SWVoAnf+k6PVVRRcGr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

Change this in two steps:

1) hold rcu lock and do blkg_lookup() from fast path;
2) hold queue_lock directly from slow path, and don't nest it under rcu
   lock;

Prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 57 +++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 46fc65050c38..e2896d582235 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -466,26 +466,21 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
-	unsigned long flags;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	blkg = blkg_lookup(blkcg, q);
-	if (blkg)
-		return blkg;
-
-	spin_lock_irqsave(&q->queue_lock, flags);
+	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
 		if (blkcg != &blkcg_root &&
 		    blkg != rcu_dereference(blkcg->blkg_hint))
 			rcu_assign_pointer(blkcg->blkg_hint, blkg);
-		goto found;
+		rcu_read_unlock();
+		return blkg;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
 	 * non-root blkgs have access to their parents.  Returns the closest
 	 * blkg to the intended blkg should blkg_create() fail.
@@ -513,12 +508,10 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		}
 		if (pos == blkcg)
 			break;
 	}
 
-found:
-	spin_unlock_irqrestore(&q->queue_lock, flags);
 	return blkg;
 }
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
@@ -2098,10 +2091,22 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 		return;
 	blkcg_scale_delay(blkg, now);
 	atomic64_add(delta, &blkg->delay_nsec);
 }
 
+static inline struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
+{
+retry:
+	if (blkg_tryget(blkg))
+		return blkg;
+
+	blkg = blkg->parent;
+	if (blkg)
+		goto retry;
+
+	return NULL;
+}
 /**
  * blkg_tryget_closest - try and get a blkg ref on the closet blkg
  * @bio: target bio
  * @css: target css
  *
@@ -2110,24 +2115,34 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
  * up taking a reference on or %NULL if no reference was taken.
  */
 static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 		struct cgroup_subsys_state *css)
 {
-	struct blkcg_gq *blkg, *ret_blkg = NULL;
+	struct request_queue *q = bio->bi_bdev->bd_queue;
+	struct blkcg *blkcg = css_to_blkcg(css);
+	struct blkcg_gq *blkg;
 
 	rcu_read_lock();
-	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_bdev->bd_disk);
-	while (blkg) {
-		if (blkg_tryget(blkg)) {
-			ret_blkg = blkg;
-			break;
-		}
-		blkg = blkg->parent;
-	}
+	blkg = blkg_lookup(blkcg, q);
+	if (likely(blkg))
+		blkg = blkg_lookup_tryget(blkg);
 	rcu_read_unlock();
 
-	return ret_blkg;
+	if (blkg)
+		return blkg;
+
+	/*
+	 * Fast path failed, we're probably issuing IO in this cgroup the first
+	 * time, hold lock to create new blkg.
+	 */
+	spin_lock_irq(&q->queue_lock);
+	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
+	if (blkg)
+		blkg = blkg_lookup_tryget(blkg);
+	spin_unlock_irq(&q->queue_lock);
+
+	return blkg;
 }
 
 /**
  * bio_associate_blkg_from_css - associate a bio with a specified css
  * @bio: target bio
-- 
2.51.0

