Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D295C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1116B00E8; Mon, 21 Sep 2026 09:45:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378CC6B00E9; Mon, 21 Sep 2026 09:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267FF6B00EA; Mon, 21 Sep 2026 09:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD76D6B00E8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B300EA44F3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:55 +0000 (UTC)
X-FDA: 85237892670.30.155D35D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC18EC0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ug0XbjGT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPT8ADUtwA1ugCQ6bw6OiZg4E0fY+SldF60Vr0ZuxLQ=;
	b=4J+7M15Cx5++r+ezCXjRyfOxXfdYguuZAsRhce/IX2de0Ehh2dh38SbzBVB/nICr6wn5Q/
	sxqyJMe+z7A+L/uZO5vcqEx3gPPaoiZKePZMo6fZ4bf0407e216/VP4eJuY0wpCxoOJWov
	iTeruqHHQR4tne5kmrHx+6xoxt1Mes8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998354;
	b=k0liDfFRTRa/5X8LUpSMJ4bDA0iO4ONDLsoOVOckFsenv8jXCkTK1N7MDqdMfVj9mTq3G/
	MYk70CR16k6AIMUiYjbCaCSkX6JGVSX6bD1ZhOaQoAqPVOJD2cXmyPL1ctlMlcmw3Rt2WP
	wWeGS/M0yEzt1Bl4L8NqCCIiHPtNrz4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ug0XbjGT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EA4440265;
	Mon, 21 Sep 2026 13:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6261F00893;
	Mon, 21 Sep 2026 13:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998353;
	bh=mPT8ADUtwA1ugCQ6bw6OiZg4E0fY+SldF60Vr0ZuxLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ug0XbjGTbmYUSr9coKi7L+zPsvUJtshCsGuhrTUbK0kDKJr5wFYjESkyUuuLYTS2P
	 ppWztHXaekhoIiqW3BDOsW2uzs/UgX7PgFwcsNdLFt8BCtd3av0eoqH3wK6srN9Do3
	 DqvVkmYWTKhPoH3hz8bf51TDCHgQsYZt47xzR+6kMTUqyFVMPltg4+OJJ2mJDhD4hj
	 3ZnGCgAwVm5yDgn5wPzK6XMmRYonihfaBlkmihoSh6ndh8FlTMTOQXRP7wK8QKBucN
	 w5thdoufb9NwOS6FLktCivMwokg/pT2Evsub2UfTu7AXlGh2a3C5EY3ziuDIOijRE7
	 qVf1IbWe8OzvA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:02 +0200
Subject: [PATCH v3 13/17] fork: move the coredump and exec checks into
 create_io_thread()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1335; i=brauner@kernel.org;
 h=from:subject:message-id; bh=B63fTvBDfUtF/BGISUIaLDChkQm0aNRJ/uKFQUOzDOo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLkzQX9O3u1LrD/S6zk+Rj6/njbrRoG2yU8jlRUn5
 22JXyNk11HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARke+MDPcT2F/Lqy/ySJZ9
 6nI+9fXRz/5GbZu4c1lelE5Zm9H4ZR7DP1tBIbYQQYYd6+Smrf++MeuQ6mVhC1+z1HW6EcfWmh5
 9wAQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC18EC0005
X-Stat-Signature: apn9qzqeej46tbtw6jegs43dja1smc9z
X-HE-Tag: 1789998353-257879
X-HE-Meta: U2FsdGVkX1/FZVpJWVSckqLgE8wQnF6luTkU9gkiFda7cT3riWhWJXCslE68YW2AqlbECdiDc15GcVtqtVMsICLGeHdO86t2JZc3sW2jgt8XXBRs1tAuqFGl84ijWtBKUrFJV+DaZQTInXIaJWamxWKH7qQII+s+MqKMIqx2SvkOnNzo8izmWnp3XHrf0Q9vhEOkCoam2basLVM0+oWyAyGSB0W1t0T9ap9CmpjW7JONnWcEPb9omlAw3SpQkO+RN0x/ibp9ATwF8Vtl4PlSzL7S8gbCTVzeRU1VuUO6W0fclF7Sv/ky5crTdQ9KY+IkNcoLJVdgtuSUClP116/xqUcDAAHWAtgBgFb7x4JxTO9ADbqV7vps+UvecIR6w+T9olpwX71v2YQUbyPKhrxfa3VesiGuk6kdgp3vxecGo1aGkADsv2vZLAovEUm6TESO+mcDebYBg7uh16fIY6RX0VlqW7crFGd4fbYhAkL1pwPUOQ7QtnFKgCkiooUcK5aUu0GxYjEiB1weGxTT7fXsuF89LzhvE1vWvR/hnok53PSRjeyo6WYJvj3qCbgRr9MKKcwRAJfkr9+Q44ckKTX2P8pVA+I4fHs7dugjJXxr5Jk4SBB0kOnwF0G4zCqqfPKfbcB0+yjcv0imPkiUwz/u2+Hc/Hk4GyhU+aWYoaoQim4SQPIYbYQPHvrTA2Z9s97l1Gus4FywfTWr90ruuCmPaCHmtgb7s+WbwyMsKubQs1rV13eJsV0VAzCgxKK/c3Dn5Kh/qHTVkIzNmv7EwUfcByVn2lOR5Uo0cQ47SgJxEfcnQMX8U7NnszcXhJTXRcFdr+GvXPsqlFXT8ZsGCoJKCNQcspwk2Y1/Cn9944H70twOD4045c5SNNx86LhYjPA2jOumktvwtEPnWi89f32szie7GzH85abIlvS2Zaixtvcv8acBz+qI4OINDGNXNh2DupUE1dcsIMk8OdT0xkU
 qV1I4jTm
 0CmG25KVrwr/m9Giva1thcYmgvlkO2u7KCstbDL1Q5KAy/m7CCRJcs9TcA9P5AHW5Lb0SnbUuDrJi8SyVhsk1CA4h2QbVxtEL6l4+RBAMppRp8/fyj7eg6nvUp5EsZBcMxle7A3hk6lOR01sf86Amqtup1rwA5CRk5Pnei5xmZa7OYy045pUqC8jYlu9al7pJQmRZlZTludM2toEa4L1M99m/baDFg5uq6nFe6HhyvGT6dyK+ibyalyYmWp24XA4Ano0yln0pPwwWx0fCMswH+hBe9/fuKJDRCOWxCB1V18bsk9rOS1HSN3kjtYHFM81Qhast
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only a PF_USER_WORKER thread returns from get_signal() after a fatal
signal and can go on to create a thread. get_signal() sets PF_SIGNALED
before it dumps core and before it lets a PF_USER_WORKER thread return.
That flags sticks.

The exec'ing thread itself is never signaled. But it doesn't need the check
anyway as we moved cancellation of io_uring requests before de_thread().
create_io_thread() is the only way a signaled thread creates another
one. vhost_task_create() is reached from ioctls alone.

io_should_retry_thread() doesn't retry -EINTR, so io-wq callers give up
the same way they did when copy_process() refused.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0VLTyxNatFmLOK@redhat.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 50f5b3e2ca87..ede9f02bef47 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2706,6 +2706,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.user_worker	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 

-- 
2.53.0


