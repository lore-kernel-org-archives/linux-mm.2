Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B92BC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E6B6B00DD; Mon, 21 Sep 2026 09:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107306B00DF; Mon, 21 Sep 2026 09:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CD06B00E1; Mon, 21 Sep 2026 09:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D613F6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E6091C0F81
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:24 +0000 (UTC)
X-FDA: 85237891368.10.347C1B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8F4A5180019
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nc/OMmgd";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noSJaKaApwlaS+y/XuQ2BeJGsLJq4q/TgrRJwetkGmU=;
	b=vDnHdFXiiXQKY2oOazTUz+OecLoNXZUWTFlsjshWJs7zI9xjb7qlqs53l66c6DSOpcnhOV
	F3lJiRa7EFTROMlN7hGCnMtkTFg4d6MEUG217RPTDvlKGKp/AOdif5aBrJYjQ4XS9KScrG
	4Qo92Hb2MAGyXJtBLUoNHIfrbceuP98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998322;
	b=mmujFR1CZkedGsDHT15ABCmeFN4tzAU0ALqjFC7n/9FhMeEocTFmnrmJnjbdheeBbtpIBe
	iVwEtU2xhp6WdorEurqHcwKkVdpQG7fPMWtgt4i2A+FB+Z9g7yOe3Wx2ZvgJ1qCULa/ij1
	9aGXxrR7iSgtU56mT/2r75oyrLwyT9g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Nc/OMmgd";
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1A1243A23;
	Mon, 21 Sep 2026 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980F81F0089A;
	Mon, 21 Sep 2026 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998321;
	bh=noSJaKaApwlaS+y/XuQ2BeJGsLJq4q/TgrRJwetkGmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nc/OMmgden9Sch3xPcq/Wfepqx+lMcRh1nuCXA+s9LMLaVFSV0phw7q8Zj6y7OU4L
	 2WbojhpIW3mZ0pq2DERzhAdb6SFlujeGUbZGx24FVE9ffsxkrg0fxK/C5JcDQ/OrTx
	 qMwm3hJKuOUCStf87mu11kfTKwRMpjybHFFWwk5UyOIgG6iQozyegxl+kjMXNOji3X
	 zF3MVcCgkuiWZb1Uywq3wpuksX+ImSv3wxCGYrFUPG8iIee4CcyS/79j67gIpttSbV
	 IivPci76szJLZSCEow7zDddBANUG7uNjKY4dIabC/qBHISBY7FgNf2bQfQ1u4VU5Kp
	 YjGIcYnvhWWlg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:53 +0200
Subject: [PATCH v3 04/17] io-wq: order the exit bit against worker creation
 task work
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-4-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1786; i=brauner@kernel.org;
 h=from:subject:message-id; bh=I9adUaO6/vXVSqyRv9Gsx8nEfE1O6rVs+YV8BhcfEiY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLkz983aprOS14L4z3Xc9c88/XbC/L3cqw2aPQJTV
 O06lU+adZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkxz5GhsnTPmz+ZxKvmcjL
 lLt6XdO+Fx8jH11xVzxzK4F99V49X2uG/+4ZlRoRKXNOWKYs/KASJ/p9ewEL35H5TDt4ngbfydh
 3mh8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F4A5180019
X-Stat-Signature: k4rqzqiuyaca3u94nckefwtatqcxp9za
X-Rspam-User: 
X-HE-Tag: 1789998322-785215
X-HE-Meta: U2FsdGVkX18Z0VnIhaJEag9we/Pxz6eENNEAFwzGeZS3nxR5zp7zuMQWDD9OfKQFkjQVdEYviEx2qaTY4TU4x7yb6mtIinxPHMJwCh18gZ/ve00VbgZUhsjIhEyTc1xgkNAdjlo7e9gDm7meiiZe4Fty40NrxsT3rAq3uhbu8H+3lJLu9hmM067FzH6rKUfxeRz9dC39HkiNfGUwiLAUivg9tHLptjZ/qG7PB+gpAtbS9QedG3mXGiOdCu5ksNHsgx9MhvwErFUJ/YykK3VVuWTH0ZTF13LMwI46qDvOeQ07PQ2HYmAl/ViQA2dhuMwVxDQ72i7v28KBl7OFxdKw9JCj9cZdVIBadO/b2lv4T2H/p4P/T0GNCOlou9SuHopjA9ecaeTzOB9jBlsxd/x3xc6qLVw9n4RUPp3FKVzseHrrfuzTnj4EkSfOqy0kpacH76N5Y5yKyxZTqadqR9Og2xRAzFraj/kNLCfiZNg99YLjjxgFoR6MLsr4oI1xzpu2OPNi5Y9PnE07Y/LtsPYzTTY077hQkYzCufcocBGJ2Qlg6oyKX39JcG4cLFC7p7r5DEyLppNYIagaxdZyUb2+vEdqq79W5wUf0fNxqhRKYBeeFwLjanuwSG7mIwjV3JS8sV2peAZhNJxuvbTWQXLsB9rxrLkRYd2cg1PKCfOf4DFQpBmQ1j3AbJIGh6v1EvDbB2e2lv861dTK4aehMDnAo7xHFZkMu/KDuCq3+jcdmFuQv61q8R0sWkINZV2Cabk0Psd3oM19Qdat0jL/l5qkl87QQChe7Hn15mkdCL6gda1XUypYsIIk6Pfw5ZGJhzpOYcIVPsu/l6WPqSyiZTngPyOOAkKj615fMRaZyYFGGaqrvQpmgSYaZbK0gSecwX45IaVHfEQJlcng5sWlFZIu4JdlbPQAxACwmNQg52XldLHF24tZJPSODxVAB2JrVtPQzNNkc2aXNTMhLcT2+us
 HlF9fz/6
 VSSZw3LmkxlbPthUUIOdARjRBBJ3TPMfz4Vt01lbqlU9KxomVBZ1SMT/64wt0UOJQ6MceAsstF9gvLQ0Zu6eJCxtBrbk6pyTqyVq5E4ryBciHXw3fT+Az7MBXAdqX0zfdB2KOBVzGpcNis/HFSfzqnRMmunDVlBPs5fndQauxDWbRmMoZcEGqDR7PkjkJ35uK95XxSi/nJU39IxEuFan/eSPFhXtbMGcvMJ/mFftRb6nVMd5oAVvJxeSHiM9KtGexh8S2ojhwpXz2ngg=
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
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Oleg Nesterov <oleg@redhat.com>
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


