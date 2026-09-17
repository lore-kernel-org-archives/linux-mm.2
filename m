Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750C0C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18A56B00A3; Thu, 17 Sep 2026 05:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC73A6B00A5; Thu, 17 Sep 2026 05:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE816B00A4; Thu, 17 Sep 2026 05:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A567B6B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:18:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D892B1C0AAC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:04 +0000 (UTC)
X-FDA: 85222702488.13.53CC8F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0BE572000A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtWatflM;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwwG9dEkssApKuUMYk1+Umj3gb1TMW62tCAHaD7Xzp8=;
	b=hr95HrDloMpXZcBpjy3ETdHU0+49ZtSkFdwctqKkyfNzdOx+q/e7KOcjZYVjSUIrIuBzCH
	bq2ojNqNOnmIE6xdf2NbFgihs593JT+wA93mKNk6L0OiIqn0jkHx90cHEQKp1o5N5r1LGi
	V4cQmbrZ73+8ULJ8MSPBQm9jRSRUfzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636683;
	b=K/OPTNHbTOh1QonhnyOdLCQ4b2XqlsP9TCsucFvz7v36WO2e+9D3Of6UaxyiUelBMxiOR6
	xIhGAV1EXSY5rAU3F14zDqVbJEAMOuiioCCd1xpE0ZoToZkVvADv3OGDL1vBJ9sQ+ZVd58
	iJh7RIjKEGN1QIOOFInbFu1i2TydlDI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtWatflM;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9250860233;
	Thu, 17 Sep 2026 09:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9531F00893;
	Thu, 17 Sep 2026 09:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636682;
	bh=hwwG9dEkssApKuUMYk1+Umj3gb1TMW62tCAHaD7Xzp8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QtWatflMw9JiFnRUXdSAc7swvK4m4NId/J7Z624S4xfFaNesuZMGlGsXtHYU2w4+s
	 rYlZlMcCrn7JUPaTQrDVdNgVyzlhMzi3J+g22RarfHlFPwpiMTHl0tT2B7HOJ0ag0W
	 Ks0Cz7FzJwV6cSTEpsWIuzkvfKJpKWoT0+jslfXUfe9P6SB+oEoEFFsTt19Pmcofqh
	 OZKkoB9KWaZ1jUUXlYNPDy4L6EozDmVfI+KCZE8BCUDKRJBjWNuwnde+XppfBqrdx6
	 qFItvM2FBlBxHHyzlSpTmRszC3RvBm8UIb1JitSeh0WiccX1N2H6EmDRrwrmU9RTlU
	 MXcf8yyfIDgNw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:32 +0200
Subject: [PATCH v2 5/7] io-wq: order the exit bit against worker creation
 task work
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-5-f3787fcda051@kernel.org>
References: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
In-Reply-To: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1743; i=brauner@kernel.org;
 h=from:subject:message-id; bh=te/fE1/4OvwEnuyl6ZC8l75gKxQO4sF0WSk/gVTYDMg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mDy36CneMHryFdy5z1fKNrdVJl99bXqkuaK/lKml
 SxbH6U/7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIVQTD/1K++zll+1wELhcX
 1NXdKa+WKOjdvmHbsR6H+JdTF/6on8/I0LxY6FLR3SMWT1K3FhksVGD89EgnPilY9+8RN5ecBxv
 NuAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BE572000A
X-Stat-Signature: jxxig47mo85af7tdhsikhbxtoa5x6e8k
X-Rspam-User: 
X-HE-Tag: 1789636682-643207
X-HE-Meta: U2FsdGVkX1/tYJ5O+ECxjLGlTf5uv0ijvpt2KPHR64ZfgsWAaADDa23HIhqcSDWuv30R6dVRzJAUvfKhXPVsXgKu1Sfcs454IMA6/qI5uVEoOCJrcKb+mFTtMfPxBXo5OY82ntHUblqaj/ZVtLeYVVcQmJS11wQc2225IazLEeBju6fHLfvnxQ1CDu0R11A8V1vZsVdhdV2GKk3uHrOlmdpXnprOgkPYfq5zpwsJ91IXckCqf0l21GxOeeIKDw/Co9MIqXpzmq1wMO30FYaQIhOiOTwpvCQimDGbj7jy4SLBR3729VZlN9vE1f26k8GZ+9ygcy/oiE+4khRn6b1y18+Y7+DDNMdtrvUS6IgklsNuCZL6En7Iafesr4iz/gKTJYg5MYDZK5asklRSR3q6Fk4LdQEQ3p2kiz0U6EDBESRWKRKwvzBoMWJy2ypQYDLj9D5gzljGSTpPmHdEe6Wq7HN+Y85mOyJmOjLoX/8yqWpHfXEksXkJoZd78Ucm0y44ztKdD2n74dCJSJc0GvLATPrIamZx+OYVb5o/fzuI4uzjrxiNnGxg+0TfHwEb4noI/XwzTCxwYuc1ps5eWFvr6dzPwEFw9JksHqwT4Iqw5w/mwKas4bUC/aKBYhztdycTLmXBeNooBvV/84tJJcS2qvjb7E9DG9P3t8gbsbAv0XDH09uVrldfc6AcfYwTadx4vtcMer9ZybJ8pI5zJheqWvYHWmPYV+4pOB0Urmu8svRs6oFUGewM8JYkHPA9bbpqQTfZUZ6kBB0+bZwyZYBfG1DY4Nye2ME7T/v7Xfdc8mJfiIRH53ZNEHFjm+nhJDV+N6BzltgqGkUNxsO/D22b/qsjSwEdEIiDt5/t9tfjq7V7nRQ9p2ypElYLwPY4+NqBAdbfeiAIoLzcFYnPy2cKFLC9mzybI6yBVpuKzzdA/JG68vMPt0OqLvF6vURNMgnpKaM7EqdH0waFwgttZiF
 Uaw+ae4D
 SBg11DnikiQ8fuojpk9aPvyTgMFIyUFVFKC3c+FxuBizDtdM8r6B3sVqn2UI5GdzbgIR7b1Nvur2tif06ssblCCmYZG5dftLA3KZuqYP9rckXBBntYsDhgFCncvugU/TRTSaiXAKxy372LTsX1ZfNLQRLu5QTIvT8Lm/wqhejWV8OMVaBTdNG3N1edSdrFpszeU+CZn3wPVhubqxIJZm23a3hxRdi/Tfa0NXE3LJcINOCVfVAqHf5bN7ozg==
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


