Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC02C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528696B00E9; Mon, 21 Sep 2026 09:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D92C6B00EA; Mon, 21 Sep 2026 09:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A07C6B00EB; Mon, 21 Sep 2026 09:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17AEE6B00E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7DB86A01A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:59 +0000 (UTC)
X-FDA: 85237892838.08.1C86373
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A02E0140019
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMwCvx+g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yum+7Pr6lS50dqU+FC2rpRw3i/SJGmY4AJWUq/e3VWU=;
	b=FDV3NIqrX+5cIDhcYTuZIf8Fxh9RQRBxfHKw+VczL4qN20FDxk+HEbYw2efZvIKYhmIxvQ
	FpFxsuXl9OglNq9Lh5DXb2HqSWuX86e72ksjNuXplNiiWgU4zPxafEFaUNSCdXJor+QfTJ
	RRi36yHu+UbBtAdGg3wVGpRkity0TNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998357;
	b=Hi3g8nMDrVMV2zlT6tBMmiv+9DLx8g8bXrE2BjcNqgEvKvNv2mOzgI8VLTUaMe1Fmdue4F
	1Aq+VE+ZSVRsnXW2SwzgFY9P9qoz5mv4+6LaXBTIgkV5zytKKaTOS3y81t/9yVwBLnclpo
	URyRTyd0vBMkyoEe6I6kzPmzyMQIt/U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aMwCvx+g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF45542ADF;
	Mon, 21 Sep 2026 13:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28351F00898;
	Mon, 21 Sep 2026 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998356;
	bh=Yum+7Pr6lS50dqU+FC2rpRw3i/SJGmY4AJWUq/e3VWU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aMwCvx+gn1umn2ChfLIavLhDIPn43P8WjESWGQDCfWP2m1/7n5Xj6t19wgs1stBkb
	 Gxdl+Ro6Fglgr5SxerB+KvB1Kb1mAlR7V4AnZanB0xRXQ83hOZ3yGfWy+L48koM6YX
	 QXtwmvdVce4mVd07LW4YReMwKbY+X++Aj5Oir8qaGtU0Mmidi74wsAIZYS21ryH6bc
	 BblTk5uXSs7WaCLPRzdhL3FwpAWt66FwJni3FrS078hqESMIGXFQ9djiltAZ/D1tFF
	 XeckPf1xrrWqaz10YTu65+t3OAJIQc9eFWNK2o+c4SAkX4jVOuC2J1t+t9pIA8Zqjo
	 rhEIz5g4mmWPA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:03 +0200
Subject: [PATCH v3 14/17] fork: don't create io threads once
 PF_POSTCOREDUMP is set
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-14-8e4adb1619e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3140; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zoAjWyKOyUgPqF1bbSF3AwhSePVYVar4GdEnZBsVBhQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLkbvVmXz3qNnbhOQ0KrW2qR3M7bWyNltI3WPV0SN
 SntrszpjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlsvc3IMN/ulaoL0zw+9vCG
 b0xTZa05NTd/N9ac//mDwI7AU8+fxDAy7Ll792DwfTYbzwl/78mbr+48nHPqyBfJjh3ir9e9y3t
 rwAYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A02E0140019
X-Stat-Signature: 4mgnfcs63wff9ezj69aduuqkxs8recym
X-HE-Tag: 1789998357-574123
X-HE-Meta: U2FsdGVkX1+7INZ96TfyVJ7jRmgbTae6eIURY+aTytTfNZmdz2cZu5oAT/bIB7J6+yxpoPlLwFsJYl94NbVCXKKuk33gMAGI3nUA1Xnbeql3T5f2O8ogAJpDTgv/Yjt7j3qAyMDUKrQkYELNndwAC9PLubv22JxOkqmhBwiGkc3SwNYz6R3RMx7bxrdauOiK9UM8QHqMRRca00Sgo4k0DZWjHnOTRPXM5L+Q0WCCe3Lf7gCew5OyLMGFPSi555LNvgEfMt0XNImDxkX0r70ef6VRGTPPiDNQvzKP5aIck+84gA1i0qQRzbJR6Y1winC111sNhwxwxXXn7vc7SK3aXJ9ucTsOjCcDPkXnFf4j2DRwa9eZ/wcXPCg0x/FgdOpugSUnIj92HIo5p1C1uK4mk+iLYwt36opllTuP9GufustcLnn5aE4xNlfdLU4pFgN2Uvuk7lIMxwaNC5lwvoK7/yzzE65poDrUDzIj16MeH3OmRnt5Ra4ApCffPfGW5Vwo+Lluhy0Fc9E9xgcAh5XHRchajVkkFRrVj2ocswQHItkK9GZWrnvQ4oq/Dt51wx4tTyNzJUz2evt6QxKq1eWxxBVgtZbKzYz98M9gTSpDnWgWwOaqAra4l8aIyckiXC+Ovqyma99lop1M4OfM3y+u8b1J0LJZYWTDJKjPoVHXLnyNIvuXbKo+RPbsvaFgqOwqtAnOHHOB+aRpHlnJuPsMFMF4pSVemVwUL5fR81y5LiV3CVATYHIna9gM9tqex651+UTE60G18nUOCWCHag9Gk9C2+jfGXFFPkVpYaTCDw5eY5o3q/hVH7tPMQJ+yzWJswQE0hEreTiHmgCbO6QChJIb0yYPoTtn8CvTKlTUdVK+DgZmQM99qvoE3m3u49VHpSy57FhirpzTELmGP7mK4CmjhqxGcO0Ku5UsxDWfqKLpptz9uNxAcAU1+pA3TWSu2NGwTVzYs0F3YlZeFIBB
 66P3NIoc
 H6wAXegbBT3cw6N0sERb07dbEw6qKpRWsjzJKUZTjyRxR0ka4g4PUYviDe8+Uv5+7y13bQWinLq9OQlv9F/hlBXkF7AyEiY/u++txZSds/GRaZobcSRkiyj/ITRRUrBd7L6TXBK72VJXsvsu3jK1aIQCjIeD3nZ6VlCLH5/zJC6lE0FwsWXdvdY6Mg/RVPfL0ZOZePOvdq25TMnKSXWsWGM8Yh/YT9czQsln3GbK09WWaZviB9jxTqcvpw4RIT1Ex+F1NDXTXRqCowBcSLrg1wu1gl74+8PIMIRfWaWcgS11pX5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_process() skips every thread that already has PF_POSTCOREDUMP set.
Such a thread is past synchronize_group_exit(), so a coredump can't
catch it anymore. It isn't counted in core_state->threads_remaining and
it isn't sent SIGKILL.

do_exit() sets PF_POSTCOREDUMP in synchronize_group_exit() and calls
io_uring_files_cancel() right after that. The cancellation runs task
work and a create_worker_cb() that io-wq queued before the exit creates
a new io-wq worker from there. If another thread started a coredump in
the meantime that worker joins a thread-group which is already being
dumped. zap_process() never saw it so it was never counted. But when it
exits it sees signal->core_state in synchronize_group_exit() and
decrements threads_remaining like any other thread.

So the count reaches zero one thread early and the dumper leaves
coredump_wait_inactive() while a thread it counted is still running.

The task has no fatal signal pending because zap_process() deliberately
didn't send it one, and it never went through get_signal() so it doesn't
have PF_SIGNALED either.

Refuse to create an io thread when the creator has PF_POSTCOREDUMP.
That costs nothing. io_uring_files_cancel() raises IO_WQ_BIT_EXIT
before it runs any task work, so a worker created from there only ever
gets to exit again, and io_should_retry_thread() doesn't retry -EINTR.

Clearing PF_POSTCOREDUMP for the new thread in copy_process() was the
other option. It makes the worker a thread like any other, but it only
helps while the dump hasn't started. A worker born after zap_process()
has run is invisible to it whatever its flags say and still decrements
threads_remaining on the way out. Refusing to create it covers both, and
then no task is ever born with the flag, so there is nothing to clear.

Moving io_uring_files_cancel() ahead of synchronize_group_exit() closes
the same window. It runs the cancellation, and whatever that can block
on, before the thread announces itself to the dumper. A thread that
blocks there never reaches coredump_task_exit() at all, so the dumper
ends up waiting for a thread that never parks. Refusing the creation
leaves the cancellation where it is. But it's very ugly to run io_uring
work even before we did all the generic exit work.

Fixes: 92307383082d ("coredump:  Don't perform any cleanups before dumping core")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ede9f02bef47..fd2829b0a8b6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2706,8 +2706,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.user_worker	= 1,
 	};
 
-	/* A creator past its fatal signal gets no thread. */
-	if (current->flags & PF_SIGNALED)
+	/* A creator past its fatal signal or its coredump point gets no thread. */
+	if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
 		return ERR_PTR(-EINTR);
 
 	return copy_process(NULL, 0, node, &args);

-- 
2.53.0


