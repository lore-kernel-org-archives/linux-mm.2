Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF66FCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384076B00A3; Sun,  7 Jun 2026 23:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334DA6B00A4; Sun,  7 Jun 2026 23:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271E46B00A5; Sun,  7 Jun 2026 23:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 155576B00A3
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF17592677
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:35 +0000 (UTC)
X-FDA: 84855350790.13.D022CD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 28A8840003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/hy1WWM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AonplpX8sMcYxl+OvnPIJmvLE6nh3WkDiHtVVORseZY=;
	b=VvlkQaBLzEtSjKLGivRWRFjg61T7VZPlQF1w0/sH1BJLVRkt/bjTTgt/amV3DpDoZVHbSm
	xChd7gGh7RHBOxkJonPqo7fk9TLntUJ/gbRuxihmSIClz6TM14Ybt0IDC4Sk+wue5x7d1f
	hg7YwuC9HRQVTLYmZfQl3u/Gnoxwpag=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/hy1WWM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890214;
	b=qYqNyhwfM/daxXoqtSaKISQztg/8eNtqJ80OFz6U2VdD8bmPNqbEnWXEM+Ax0w0H88tfN3
	uZQyA/4vqAnYz9CfMNdIIZN1r7+FlhpWmKxYA6ZX9CgixiZuqrJHXu0NxqwDMY6JGjz9cq
	IhC5ddQBFQa/KiGUl0IDkwR93KxNR4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 807F040248;
	Mon,  8 Jun 2026 03:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FB51F00898;
	Mon,  8 Jun 2026 03:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890213;
	bh=AonplpX8sMcYxl+OvnPIJmvLE6nh3WkDiHtVVORseZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/hy1WWM0CXwiJZsze4Z95np3aJq6uUHdKzNYSVT8eFfJc8A8LFQpseaCtzOdOpAb
	 UE3j53LDXK6ypjGYSIdIPUdfqOMczpANEUCyukcBALvGj1Rv64qZTEfXBixfsMm7Yi
	 u8J+/5ib6E24hQ/VCBMxIZ6mseDM5o6Rinb3revCHCGp93zLytyucnuMiwzg16L81n
	 19aTzKCP0MxwTu9WN0iPjTe6QgC4TqCUhKVea7Cj2PeWPAKWZ2A8l2UyiQ+j3k4iX7
	 ezLRGxkEFmVWu7ajqdqTqn6E9agBUPjnj4s2qGA0uxFvxTFfkwLS6mur1TLoA8CFz5
	 V8mrh/8dkQdNQ==
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
Subject: [PATCH 8/8] block, bfq: don't grab queue_lock to initialize bfq
Date: Mon,  8 Jun 2026 11:42:49 +0800
Message-ID: <1965073ea20f33114a8d903816b986e483b9bb34.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28A8840003
X-Stat-Signature: fomhi89y9sro5kp6jxjfp4k4qbmt9thg
X-Rspam-User: 
X-HE-Tag: 1780890214-472729
X-HE-Meta: U2FsdGVkX1/BLKo9Q9Y/M8ICToEj6OJirvsB0oBK5dsNBjoXILhRCuaifSonvMoinu5tthSHKBkjHd9/oBEXjDnlyuzU4WvXT5R9k9MkGT0cNDZIxrqYP02APaj7iopCs/VgJNiVmJrqLqOjpCUpLK3tGTTk1e7VOjogRIGf/Wi41Q2vGFhfs4KTXWYm4eTwUjdg+GiwqznPdd+cBK3PkeuG+mo+E8bOsihR89J+4jPOWB7tV51K75Y3JsGxM8OdgOHIfqFZsgoytcxZTPNdFLgXSP4G+Xx8vXU0GEfgQ/o7ig/jyXuBW3MSuJ9b5SyH3ejgaSaHixBWhxqSi7pVYzkB2WWNos4II1al6Zrre6EvOR79e0us7Emubb3wR+F63J8ZSw0PhF9VR//7PLNrimWNptZFHRaaQKa5pJvfvqnhYpgll3JPL3FXJQkp/ZDuCSiwfux9Y+DCMOM8t3cKvZ9rUwrU65ElkeSXFE7G4Ui6lXRDTaAwzJQbxN54LmjmjRwrHexUeW1lXdYaMrtTxYefe5pnib4Poiuh7kmIJJeWm1ONgq5mUJST+TAydKC1j3lEVOc7MEY2UoqmfNQwhboEjds69fnpOcNkA5viOMsvZ9cWx3Mz+CqkcymuQ8MJbsT7hFX67G6xLJ2KEWMJV0Hlxu5o5H5asPhkWGixtfuINSxBRzOvglWjlblwIcl/LhegONwmmECwRIySqwT/MGBSI2JfK9+p7LTBuT/T/Bwn3ulVwLD5jmfXwErCUkLjeWFcy1MypPeRqe1cxlToHL9CQBMCEwmOLGkzKHHvwKtL7XH/jS6FT56e8j7AuoAr9w4MgXj2UgX8T1RDytD0UkaEajkckUL31tuCIsjBVm8gkGFjw8oyDOPwqI0zrqjbIO4f3oHZXYZbZ4U5ERPvUKjec9pnfhuMzSa7IADtKMqr5YarfMQ44lRJA/LTfQbKa439wwW1Y1FU7hpCp+u
 Uxx4p5iC
 NYXQVoHDVRiBymw68HrSAaYQBNBnl1EPd0Hq0CKboRBMsJ3iTYTQEjYRpS53RpNi+KHVqgXF4ynnbGBcvMdNtdq6SXGp+0bU8XffowIKVFfM5ttZDPKMTLSsZQf2cCgcR7MMYu9EBGZYEewDNoXameqowJKpbehCBaa6Vs9YpBpn7IZ4AklMwVetcEsMEW8O7wxXXkFnc6iDSaUahyD55nULP6ASXiP3OHFstK45/CFWL9la34QOhq7MkttcEfUkCD0bpL6TDZxwQKFtU697tiRWRuUB+8rtoyhjeIqNn3ED2674=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

The request_queue is frozen and quiesced while the elevator init_sched()
method runs, so queue_lock is not needed for BFQ cgroup initialization.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-iosched.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 42ccfd0c6140..5cabee2d4e7c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7207,14 +7207,11 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 	bfqd = kzalloc_node(sizeof(*bfqd), GFP_KERNEL, q->node);
 	if (!bfqd)
 		return -ENOMEM;
 
 	eq->elevator_data = bfqd;
-
-	spin_lock_irq(&q->queue_lock);
 	q->elevator = eq;
-	spin_unlock_irq(&q->queue_lock);
 
 	/*
 	 * Our fallback bfqq if bfq_find_alloc_queue() runs into OOM issues.
 	 * Grab a permanent reference to it, so that the normal code flow
 	 * will not attempt to free it.
@@ -7243,11 +7240,10 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 	bfqd->num_actuators = 1;
 	/*
 	 * If the disk supports multiple actuators, copy independent
 	 * access ranges from the request queue structure.
 	 */
-	spin_lock_irq(&q->queue_lock);
 	if (ia_ranges) {
 		/*
 		 * Check if the disk ia_ranges size exceeds the current bfq
 		 * actuator limit.
 		 */
@@ -7269,11 +7265,10 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 	/* Otherwise use single-actuator dev info */
 	if (bfqd->num_actuators == 1) {
 		bfqd->sector[0] = 0;
 		bfqd->nr_sectors[0] = get_capacity(q->disk);
 	}
-	spin_unlock_irq(&q->queue_lock);
 
 	INIT_LIST_HEAD(&bfqd->dispatch);
 
 	hrtimer_setup(&bfqd->idle_slice_timer, bfq_idle_slice_timer, CLOCK_MONOTONIC,
 		      HRTIMER_MODE_REL);
-- 
2.51.0

