Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4445CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5DED6B0096; Tue, 15 Sep 2026 06:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C988A6B0098; Tue, 15 Sep 2026 06:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A676B0099; Tue, 15 Sep 2026 06:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8378C6B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A964A0396
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:46 +0000 (UTC)
X-FDA: 85215607932.24.D2B9DB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3C31418000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMY7TSfw;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBKg7LMufS9h1DDpU8LEKELjTVcUgWSpF559w+ek458=;
	b=WpEh4Bj+HE19zoGLAMM+YHRGwhr7ewvWu9crdWOeK2WFEsqIu+58dAH8Cc2Pqd03bBK+hO
	/96D2EFGCwLWgWS5Db0GvQV+w2djEb8FHkNEsMEFGixqJXtJAPea6rmXj7C/FjeK+yH4vE
	Him4//AZxLXrHRRvLRMjCWazEKC+MpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467764;
	b=6U0SB1j++2bQzdKOM/IuRnfTmeesrgvvR+Lrp3UsbNl0I9X+HjEICq68xbVasEunH+FASv
	BOt3h/jzhqg+mNr00C6QNXbEsBEW0wbygjbXBiLOsECQ5ln10Zr0qIPkyCzWKtRW0JJ8GD
	L/SnDiQa1ZZjil759uwipI+FutaHgbM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZMY7TSfw;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58E4A436DE;
	Tue, 15 Sep 2026 10:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58D11F000FF;
	Tue, 15 Sep 2026 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467763;
	bh=PBKg7LMufS9h1DDpU8LEKELjTVcUgWSpF559w+ek458=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZMY7TSfwxPX6+XSJWE5fNaiAdImONMSHR4JKIBL9dbXG4+Tvc2LMW3F5zDJ0MfGfX
	 VNrNXXwcg0lSAO5YKig0GrnNBoUgFnfaZhimWL6gIdSUMXt5T9GKPPrAYsSJ8pb0NH
	 6IPKGwzqetVi9M530y+Y84bK0ov21BxOT/RkB1Ni6fH15COtBeGCwvyWXlHcJOFcAH
	 9N9eLKQztQ2SWOlE70fhb8sCMygtpKZZoKg0O0GWHSTrEJBLdYGUfzWqi0bQffkEp9
	 DKMB6H7x+QWAstvZU6S/cHAQ8mLzNcKngyxtNCWZicirDj1MYUP+vF5eNBV/1yXyU1
	 UuYev70ct89ZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:17 +0200
Subject: [PATCH 2/6] fork: refuse new threads while a coredump is in
 progress
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-2-f354ca41780c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2194; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0nhmnE3MPCAqDO8OmaNk6DjHrGuxEq925OsDr2QuZ50=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMkQXnC5/zjzWkZfr9+1i9cEmr1+rpId8bt23f9ww
 T0Nc2v3d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkaiwjw7du/ydccQujotYe
 sZgb4pfA1GlaYnxNeV3ihw6z2H+CTQx/5QJPevocMbnNssx55u/KzBxdQ9kbIXOrvzAvjZcyujO
 DAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e5k8htjo3u8dps7eazi6ek99j4j84cwn
X-Rspamd-Queue-Id: 3C31418000D
X-HE-Tag: 1789467764-157506
X-HE-Meta: U2FsdGVkX19mWHxuukcWU3Gp0m9SuVQE7Nih8RGe1HVtGFi1+r6Uv+o9/yGiCKKUJa4aU6dRsGOECigHB5G13qe0jbhdRLaZixEX23j/qBQndNx7gN8I06JA2Aebdf9x7nyjES0MQPFLpdll0ywoO+nSRZ8905YgGf5kjbTKf41vltu/avf4y6K37xdIsZxgsgCVIkOI7oyfrvBwcAl9L2QwmlDCeX0Oo7LRfeXtqwI3jKxCUMLm+L22Ybwet1IaWCSAqRNdtf9IlLrTIHlCv9rR/wIXKz0Q0/aaQK2jCaBmnXyulREKE6Fc1MoxsratdgYqXEGomjngRJNyo3aI4w6Qtb6UhRZZ9YG7/FzKfD9+oHduH7Se86RHVaeiAW2rSZv5D7lmCRgYNHzkYYcjpvc91Iy7o/bnAyR5Ip5a4DjeeFUReLttE05stivJA1NjN0VwhCyrXqJMkQfEFkuoJB/tSVmpgELYaFBQiwwHxta4nqXv2UGntkPJQl+IgHHsYUj4acbfKf8iGNCVBfi3Z2yoKM9I+RI3ytclGp7aaKp99ouRbk3VI4vqqOSeh6tBMqFTauklT16ua80emHcPWkwjDnzCleLy2dWrMZizbDd8tnI1LveEAaoybz8Nx80JbbNKtjPMyVZNAhSjBHTTf7Oe30UFl9arO1A+EleIQ0iG1BGJ/TyfBhKWMGfL58JxgaIMVMTmB4MGxLmTfFHHdYCePBD2IMTp70CeLOgPGuapS9DaQCG++8NvU7bF/4nkYaC59mJ+d/WEcXfnIEePlZhQOPOYwU1ZUZLGxHR/QRJrrGB25H4xlJMcHWzb6+X3YHcU7YBYtEKpS3/D1JRT6f5WZhTV+uK3PchQAasVW5pkgjNw0g14kB0dgi5TZk9YHCpa/7S76mdW1qGcSGB5xowJ73VPuuBTsicr4RTJ1lHKdBrKmCcwZAxraa7qAcilOxjRkADU653DaB4e+dk
 DI6mssPm
 w1PHZc5ffJKPLnHKMSsFwESMw0XPnot2NSTtC/nfY96/Jh9tjXe6RXDe05QQ/VEeFFznwifS1mymjoBnJhY/9gBh82+gJ5ltPvZZdjM3P8DYcuU585PrfhRSNxJwnNn4IWxg7zkt8/e8bZJFtYgWiUzYJza47Svm+nwhZ7jFz7X9YIHcNOoB1B/68bhf9qPuVrbDc+9RtXm6eC+j04xUhlULWqGWo7aMgOdPis54pGgp/XqnYfBUdaBHeYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Say a SQPOLL thread is a member of a thread-group that coredumps.
The coredump code uses zap_process() and sends SIGKILL. The SQPOLL
thread uses io_sqd_handle_event() and calls get_signal(). It removes
SIGKILL from the pending set and returns. The SQPOLL thread breaks out
of the loop and drains its own task work.

Any pending io_req_task_submit() with REQ_F_FORCE_ASYNC creates a new
worker when no other worker is free. So it ends up calling
create_io_thread() from a thread whose fatal signal is gone. That means
copy_process() allows the creation. It's also possible for an exiting
io-wq worker to push new work onto the SQPOLL thread.

zap_threads() counts the number of coredumping threads. The coredump
client waits in coredump_wait_inactive() untill all threads in the
thread-group are parked. The new thread that was created via SQPOLL
exits immediately since it got PF_SIGNALED from the parent. The problem
is that it sees signal->core_state, links itself onto core_state->tasks
and decrements "threads_remaining".

But zap_process() never actually counted the new thread. So the count
goes to zero too early. So either the coredump misses the thread or it
dumps a thread that is still alive.

Close that gap and refuse creating a thread while signal->core_state is
set. Both sides protect it via siglock so copy_process() and
zap_processes() are sure to see each otehr.

Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 10be4a0ecb3f..bd97fc7b885b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2491,8 +2491,8 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_core_free;
 	}
 
-	/* Let kill terminate clone/fork in the middle */
-	if (fatal_signal_pending(current)) {
+	/* Let kill or a coredump in progress terminate clone/fork */
+	if (fatal_signal_pending(current) || current->signal->core_state) {
 		retval = -EINTR;
 		goto bad_fork_core_free;
 	}

-- 
2.53.0


