Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24928C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A00A6B00D3; Mon, 21 Sep 2026 09:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376B06B00D5; Mon, 21 Sep 2026 09:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F126B00D7; Mon, 21 Sep 2026 09:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03FA96B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9818D80169
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:13 +0000 (UTC)
X-FDA: 85237890906.26.CBAD294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C317CC000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNKeDONj;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aaN7myk62sTfR2q3XReSX9QRDUIj2fpxzi/ZnEl5rw=;
	b=WgLnzU7zNuGKu2vl1B914sJyNcs0iuJhqcy0TdqCVu63cPb+ogHdyRdt1LfpchE1CiHtxA
	Ur0+nG4PW6g28mxmHzTnbbgjCpvS3I7k4sD92Y067WRQQSBSV4RwQ3sh5zUVkaEjIKnH7D
	0llsjkijPJG4dYL+vfOV+L/0I81qqgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998311;
	b=ENz3R8zf3D1EMKXEP/mIq0NlzL5nbKL+vud+dsy1cp08pwOxhZjS2MdbbhdGHsH8NKnh27
	XS0K4odmk1l5Aea49gE91OzewvILpA1VJFrQUXCN4N09mpNE7r0WAKLJFIqFOBFFv/Hp+Y
	MzRADqPZK2MG+Ng4bZF3qHS1+6UFneY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNKeDONj;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 00CDC438A6;
	Mon, 21 Sep 2026 13:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D771F00893;
	Mon, 21 Sep 2026 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998310;
	bh=0aaN7myk62sTfR2q3XReSX9QRDUIj2fpxzi/ZnEl5rw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mNKeDONjpAtk5e3ET+hFnG6GZU1Mzh8f+fOKeiaSlVekLuPnMEz4CZmMkTn1ycSty
	 tLKfVE0ttIlGJu00wjgh2ME30EGL4fEgpOmJcQXlKOHo/YLQxcPt23y6hwwzmh/W2y
	 5UpOqh7u5KcNxzojtSy1HNHKFRa+C6uECcARq0gVj6k2AjjCAh1Ok8zuFGM8LKIw6f
	 1xBm7/EJuB60VoXvU5DcMvKoAHALm3r/eTHwLkYsVkmYh61oGYOCRyfn260ZyuPsrY
	 qCjBbla64kBccl3VOjfJU3jzuw6bquPyX0MJwaBr/YJ7ywk2ftPLZysOc9QoCfmQ6u
	 Q1YQdfLz9GC7g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:50 +0200
Subject: [PATCH v3 01/17] coredump: hold RCU while releasing parked threads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-1-8e4adb1619e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZJZMHEJY0IpIOllGS0I2yC1Zirw7JKTlxyiP3ql65sw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLmTseC4Xplb55Vn4Xb2px9smOhqHNFkUnllxqu8x
 MUpaXydHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5tZiRYeHVWWe4Dv1bvfiv
 SuC/2O/fV3/Wua3JEXnxpu+69wc/eaYw/PfcpaluepkpXn27Gd9aqz/nriQuZbmvX8VqVNF2Trz
 nBDcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4k6y36ftouqqj7unc71qp9sdpbsfpana
X-Rspamd-Queue-Id: C317CC000C
X-HE-Tag: 1789998311-847177
X-HE-Meta: U2FsdGVkX1/viV2zOLh2T8tIOLM0Tu+yS1gic3u5wqkvmnq3OhPgwamIhauA3McwZbBQI3NGkLp3epOXEq5sxpCF4lxJ6/IqCeEJ4zAcLeg84vTjttndj/S21aBTD+9uZ3NNHOxRRCD9IzroMheRtGu5UB/ph9uy5VRcyloZXxg+kirpEnEuA5tku8SoMRcYMScVfGi8wzre2knYaiyQCxgD8vuOg+CPxOUGAFTx0FNumwY+QNVCCsj2PIATssWVl2C0825WAYHgjNjbyBxv+EvDNc8FZF1+Aa97ZB1Ohm4FV0dTYWFSx5oyNJKLt1BfK5uGIOqR6RIUOX6KPpZbJRQCd0pSZapJytrMf5Sr5J9DlAk9nBR/CircHzIwEWp2TdGqsKd4w7vxFaWaVFihyHAszb5VEFmuD0R5JCjc0TYiSFOWfJgbnHB78T4Y/LlXIKgLwloZ7GZglcB4Av1i3qlwsvobMvIcnzVVnFeNZoTbWePatO8CTe5uljWFlxAE8j2p03ZByQxxif7MYuRo/eVkLU6N/IvzuqovjvxbQMYq9ITLEVWTg7uSeda2ZPXTKYapVVmtacPLbsAwgKkt85+VGSPnm0WKxb08AUEhEQWAXMhFHevARFqLfdp9ZKLxMgJ0OFHbV+ssQGUUo7bWDkkPFQ2XrPTdvhxxd2Lu+hJQzxAGNZPvl/4YOf7keGmpew82nBUju9INzQj5KV1RVOMODt2q9kLIm0zUjO7NIWnTgcpFlKqKnrwrvPluaPHtqQyRrZygvcmHxEIdIgIixAWTRcoiD0haZIq+rkTtzXepnxo8mr5fpBgIWH9KfPIsZRDsiAuA9QfVqkzamMDsoELbmXtH13oEiEmbdrUJ31Ynvd/bisnWowSy2eZMxGXmsVZ2dOHd6SWEUoC7m+XZoQcAggRziQRJhfGfK0iszWf76a+r91WT36j8nWtKzmYglURvx/ejdAEWhIUYWgb
 Msq8HvHi
 Lvv75LMfqnCeWPhiQl32wLiJRfLvpWyEZJP7kwr8ZXdOysCz8NqWJxXhIK2HMnwoFU4rY3PvgCd1BNWT/L+CeQoMwCi1+Zp393BAudWS5MXllurYdcAKHgYN4h86H0BUoZvo14MgWsWe26for+SmtLuSK9R2Iymggx0l+I0qFsdqzLF9kuT9Xm4Jlt/6s1lvzLm3NKnXP3ofaeisOuK3khKQggIMAm/Kj3qazu0HIop+/eawfzGtbZI0l/ab16IIz0a2lsG25o9/jTeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

coredump_finish() releases the parked threads by clearing ->task in
their core_thread entry and calling wake_up_process() on each of them.
It does that without holding a reference on the task and without being
inside rcu.

But calling wake_up_process(task) without rcu here isn't safe. A parked
thread doesn't need that wakeup to leave. A spurious wakeup or a
preemption after the store is enough for the task to go away.

So if the coredump client is preempted between the store and
wake_up_process() the thread can exit and be freed in the meantime and
try_to_wake_up() takes pi_lock in freed memory.

Hold rcu across the loop.

Fixes: a94e2d408eae ("coredump: kill mm->core_done")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 16b331b686fb..6c0c597ec324 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -561,6 +561,8 @@ static void coredump_finish(enum coredump_state state)
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
 
+	/* A released thread may exit and be freed before it is woken. */
+	guard(rcu)();
 	while ((curr = next) != NULL) {
 		next = curr->next;
 		task = curr->task;
@@ -569,6 +571,7 @@ static void coredump_finish(enum coredump_state state)
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
+		/* Any wakeup now lets the thread exit, rcu keeps it alive. */
 		curr->task = NULL;
 		wake_up_process(task);
 	}

-- 
2.53.0


