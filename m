Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBCBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FFB6B00A0; Tue, 15 Sep 2026 06:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B5E6B00A1; Tue, 15 Sep 2026 06:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E967A6B00A2; Tue, 15 Sep 2026 06:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBDCD6B00A0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEDD11403B8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:57 +0000 (UTC)
X-FDA: 85215608394.23.CB25D85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1CB5140009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbzyPScn;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NohqK+vBGRV5AB3jeYvXV60w+u0B7UHNh0tws2uLU00=;
	b=vbkET/NI/RMa3d52UTDY66QVPl0LhjTACfefbpY1R1IUvrsnmT/SD4oTB7/P7hG0Dlkn13
	sjfDa4SCCQmO6A8FOs14lAVOJrmrPLrBL0py+TFdSUzNnc9L4zwbhZmSnvDtvlbCUazh19
	yxPN8m4t1FuwOylHFS6d7/MXpV9YLdw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467776;
	b=56FltqdCP0mySFhbMWyIG5Rdoydg5YUpFUI3yyyGzaf1Mo1vt1AYEd5dL0iM/lhHeiSsKX
	zK25RZq25na+oybVPM/pgRWMjmc5hWZdlqkgij6WdLtTMc0OyJKEIHj6fYJqIjTP1NDmV/
	LL2NtIfQKc5uRte+hnl72BJ7kICl2qk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AbzyPScn;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9238602D0;
	Tue, 15 Sep 2026 10:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C811F000FF;
	Tue, 15 Sep 2026 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467775;
	bh=NohqK+vBGRV5AB3jeYvXV60w+u0B7UHNh0tws2uLU00=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AbzyPScn8nAMnhi+fskQF6J4dEpANu5vd9+2v4fNNKHC+q5rnZjIAnPN+REx7s+V0
	 xPz22EIpxiaqg7aXrL6IEg3Ft1Vk+Cms77R5ZZStul7va2lVluue7eZkH25MR53ku0
	 8yx/oenO9X44xdF98z5HPJ2mBDQq/hp4x1o915TbB0iulZGWjHLlaaXgpxS4d1V5vq
	 qJIkm5nKJi7n4/R6eYZEKF+kw655HiX5GKZZmlrIRIxy+1BYokx2lzdkYuwXan4RWd
	 4LqBRf5guYpWT9ZuCWKGzrlBJSpx7x9A3N7KE/VDcVd63r4WlZ+8Yt4Yk1hfyzhpOk
	 6k0n0Hp2I3Vyg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:21 +0200
Subject: [PATCH 6/6] io-wq: order the exit bit against worker creation task
 work
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-6-f354ca41780c@kernel.org>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1700; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MjzCX6zOhzcQjz2NOdlaMSrcmoP3nbxniZfVygaRpEs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMmIEly/4/baJRVbr8x+0all6lMovOuWlIvhstVrn
 655cTHLsqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiOR8YGV5ubfn/pDVSP20v
 20o+tvm7I6Y/rFRVtdOWdVs25WF+4mOG/ylf2xe91Mvx5C6raXq7tiEnNOfV/J+THicbvbAzTX3
 OygwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1CB5140009
X-Stat-Signature: 4i915w8dqgfss3xxqj79gf3w3sj4ud7s
X-Rspam-User: 
X-HE-Tag: 1789467775-810401
X-HE-Meta: U2FsdGVkX1/9lzat2EucovOYX4lvaFosHCxmXABCiawNYmpUUF+MMhw2p2c36Ha0o7rFjWF5RkaIbz6LTYR3xDISROjI7LdJTPlO7H7RSzNgI1/tAcvNlksHRR5neC3r7RqmzdEjNFJzO9OV8+GAm7+xGx1gCyL45YXqv7IyhfTOUSOfI6hy1TUQ514kvFyDMm/M3K+S1xICd9K/ZpwyW5CtfsOO9bkuSzhG6SqDY4Of76buQFWY6BzTg7gXQUNdybt1oYEKQiRJdBf1AyN4rz2sn1edm9oRkeoIGhUX9NDfusDOAzIwmx7jT22NxwU0NkqS1IQzGdbmnGd1KyB9f0yEpPkseRfoqGY56HiJ6QkZ7OMz2mPYcm7ojyRcymulbnUu/p91f7I+0GHYvjvI9Mvp9TEsaVqM6r7nK5vBmDw2EDlZ+z/tuCWAW8AlMW+jnYBX6rlJlHjGFJSlhPFAP3AI1WflqvHDfAb3N9tqQaFtjRdryszQ9J2WHwfZvEXsTUjXR0XmmeZpgqwZ0QPu8nyfyZBj+Y34/Xd4yhZy7nqNFr94HvuIr9Qu3DFMS+1KFVn04slH/ISM7fAE0UyFnDRKTRSzomgqLSde4FQlAleHJEhmbc+swLG3oJWxm41HyvbLNe78MFxjHtcQPGEpa8jVS3O7Vma5kG972iFJp/HhBCq4a1jygtkZnpVmc+dKD4nSfXIjBO7WMWa8DGPISlzBxOkBtyytZvDEJbOnssvQLkZYnRvq/8o2wDXhhN43ZVotIVBsHFWQDr4nMfkLmYSSoGuiji2nwkNoyPwd3DXJlT/uLrg8BNoj7dup3JzvAO4ErwXBYerOPns7csNm1BQAiQbIoQFJpUt+XBi/k8nfMpva35FBMoMuPVZ66UUu/8r1M4ZDwWjS5CQSJzM+f/DJrVtkghC92CY6oe++QhdouzF03qNLrCCSBZOe/0/wpkdv1zux2u4Qed5fWFm
 MS+so6s7
 4g12BiaVJsDu88sROrly15JF5Wak96bMyGzbn1Nz1fc8JdCT6jxFWdC2tsJouzIdhiqDeV3jXW95+cZVnElsYDYQ5x3fJe6wq0IIE74RI6qUJ69aUtq2tv1lYYOhMBNFOk9JegA+mPg7tAUzRkYZ9keYuyx+fgBqkp4FGjg0Cqml73eSrf4OlvFXIC5lHd24Pf17+bJnPg/YhofNDt1rNiLV0U+7+O+sJvnCJ2hIdCNlW4agIKQ1kJLP1Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

io_wq_exit_workers() cancels task work for queued worker creation with
task_work_cancel_match(). That has a plain load of task->task_works.

io_queue_worker_create() adds the new entry and tests IO_WQ_BIT_EXIT to
cancel it if the workqueue is already on its way out.

That must be ordered. task_work_add() has a full barrier via cmpxchg().
But io_wq_exit_start() sets the bit with set_bit() which doesn't have
any memory ordering.

So afaict, on weakly ordered architectures the exiting task may load
task_works before the store of the bit is visible. The other side tests
the bit before the store is visible as well. So the entry remains queued
with worker_refs and the exiting task waits on worker_done indefinitely.

If the task still has rings then io_uring_del_tctx_node() provides the
barrier via test_and_set_bit() in io_wq_set_exit_on_idle(). When it
has closed all rings though that barrier is gone.

Add the barrier after the set_bit().

Fixes: 71a85387546e ("io-wq: check for wq exit after adding new worker task_work")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 io_uring/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2ca223e47d41..2a980e86dd94 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1324,6 +1324,8 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 void io_wq_exit_start(struct io_wq *wq)
 {
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
+	/* Pairs with task_work_add() in io_queue_worker_create(). */
+	smp_mb__after_atomic();
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)

-- 
2.53.0


