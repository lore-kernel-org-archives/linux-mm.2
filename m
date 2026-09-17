Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82041C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8EF6B009D; Thu, 17 Sep 2026 05:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0E16B0093; Thu, 17 Sep 2026 05:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474966B009D; Thu, 17 Sep 2026 05:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB916B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:17:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 718441A02A0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:51 +0000 (UTC)
X-FDA: 85222701942.22.1256CCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AE08EA0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mH9JQpLF;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636669;
	b=Qz0jkOjbTlZCPgnDWzPmw9tbHahADew/GS7os5Tk6KBRoTlHOvAH1c9MYR1D6vuIjNElCU
	0WyGEaTHKWsWdsc9QyB4Ji/BfZ2QvWhAT7ICUWaD4jgWT2nDAPqq8t9zT4QttwFRqKPEiL
	HlWxnKQQ5nB+5xdGbx908FrKcS7o2Mw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mH9JQpLF;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPB1oCaQg9LjyGJ/5+CjlUgVcO/m+4cCdFm+eGUyeHw=;
	b=stDFhcgPd4jeWgwWZJr0xr4kNz0SFJEPVQ74RG7v3eQMNpmozUHoqMrhtRSxnMgBCiDYfe
	/Q5wsely+CEjYYR5FNcfymoOhkBlEXHcfU7vu/zK2GdouZ+yTbXeW31XV7jtgPvFRgpzyb
	UYiL8b3bhfNxR2Nm2iOQ/Etc8v1iOW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30BAE600D4;
	Thu, 17 Sep 2026 09:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBB1F00893;
	Thu, 17 Sep 2026 09:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636668;
	bh=EPB1oCaQg9LjyGJ/5+CjlUgVcO/m+4cCdFm+eGUyeHw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mH9JQpLFoVE/3Fx/BiHYhQZrcIlVEnaz12k3lAb7jS8XsHmuPJH9Rr5oBz95d2uMn
	 DRE2eMpDvecXvDEwA0nzLpEJzfgrZsqheiXaWLJNEA1/AETUL2n1OldYykGidL0MwS
	 A+jeuwC40Yut6xOHXRj36G7x4PDUTqGHgUfrQuSQ4vFRwba7UeU2gyOuVnZm967urp
	 Jh73Kby9cXfYIvObI3u0l+a5BNpXfsex0sCAWGV0+23BzhHvBq+n7bDp6IkncRpN6E
	 SXVvqYvuCMAOywpOVlm5qpJeJdLN7F8FXYqJgA9GUvgKNeVtYl9DvfICHKfM6seZhE
	 4ntW/RUrWCDvA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 17 Sep 2026 11:17:28 +0200
Subject: [PATCH v2 1/7] fork: refuse new threads while a coredump or an
 exec is in progress
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-work-coredump-fixes-v2-1-f3787fcda051@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3020; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pBR6wf6bmu0Jm0F8OERiga+ILWUwBiuisWeTmCb8FHM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mDCcHq5woIPv34tD9h13q+wK1lJ79S+2hnuJnlKX
 bzr7FsyO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDaEi1MAJiKwiZFhQ+Dl31bqu96+VY21
 vskapfa0VlJRYUbps80Pd9rfeTaXlZHh+ncGJRvz3yybfwqYhCy4KDdb9GTluVAL9bq2SwcurfV
 mBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE08EA0005
X-Stat-Signature: dfr4ohmtb671fabsxjtib38tpxx7oxpg
X-HE-Tag: 1789636669-940415
X-HE-Meta: U2FsdGVkX18MdOR10nYSzRP4ZWM2h7jTfeW+MCirX7vcTAOpDZPP/x1x2/5EBzqx2rAXlPRFPFdqsjXACfLOOLfoKpRDTLbedbipVy2ZVzxUbdUhEz/uwwcRsPzyXqf1ODxi1tTAObpwB1yDYBJhNKx26DprZpTDSzeUzKeRlZ3SwNlJiqx1NkWQkLSWICY/mxZ7CWJslNvFbKJ9gL+2qQKnDAHt6WbgxtuzROuhcuy/wrNzzUEhfGJESHrLaKkC3Ac2PsjdvvthRxNOck2cbF8jQ+T6SOaYZYgDnaFol13pkadAsFY6kXSATfpvc8DTYqBZE+Ggpsh0ketLzAVtsJeuLx+PasQL1Me+Ag3San105Gbq6Jkit8+9DJwFGp0BjARE+ikQsrd8a1uxnl47dvKXpUqa/b/U0CvifkZEC8BJbpu20HDD20mhFBlLPm2aYsVyKu38S4XDf6YDXhdzJuTQyv7VYd5s888Rnx/EGEyQ1T4dy3SDw6SFXmh7UpjbRN1VShPpA3pshzrtpVlTYExOMXFTivT5GdnEcK0xzecJHQxMBjPbbLJOcAaGLAqjJGu/VCKb9tl8yhwiogkOsFDeyXzhXAhVdp5sOt9ACAvQ8UO0bYzRQhAQUWo8EvZe64zxdhyc8Bf3dmOlmycMayLoDCd8tSZX2iYzhnY/mYHpu4x8uwFS4w74aofrPH5JD/iqsQuDxMGU5IdDAb91H7/o9EkWGLAqbrqOH03ljlpCJ2RJ9DB71L/jG5x4cc6KHRYASr16k3i81fYEZ8kBy/knhJqXhC/1kZ1UVqtmSJgeGboIECzFPK5TFrrvHoRNR7GjpPP3KvwIltE5huGGXp4biUG9VP6H4wBuFEJ0dxAHwdelv8B23G2HHqg4jx19BRzrk7mjbPsQrBdomt3aDEFT3W/cixBIuYcRXWBpSxwBnDrc48LThkS8LEoPdJquHCMiuQdd5CLhC3gENHC
 j4o9h7D6
 cYhrV6EQiZ6Yn1R9I/aldLQmPTGT34j+FO0Sr3nJ5tYVwzb5BOwAauX7qauWAXu4+vHAKOAuM8NMqMEaKmlktINIgm5cvkYnxUTCx6duVL34z/+FcewYaFs46PGJj6HJO03EKkaC/tiqbp9SSHyrEvHUU3wkICxGK1vYPtqdl30nSBkYH0ox9JOemh3EWD7ZxwLvn01r5lmZhWCDp47WSdqZCOa8hRwgF7EfG7Ci/koIVSPyBcLCr8qWvuA==
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
client waits in coredump_wait_inactive() until all threads in the
thread-group are parked. The new thread exits right away because the
workqueue is going down. It inherited PF_SIGNALED from its creator so
it links itself onto core_state->tasks in coredump_task_exit(). The
problem is that it then decrements "threads_remaining" even though
zap_process() never actually counted the new thread. So the count goes
to zero too early. So either the coredump misses the thread or it dumps
a thread that is still alive.

The same race exists during exec. de_thread() zaps the other threads
the same way and counts them in signal->notify_count, and a zapped user
worker that has already dequeued its SIGKILL can still clone while
de_thread() waits for that count. And once de_thread() has cleared
signal->group_exec_task the exec'ing thread itself runs task work in
io_uring_task_cancel() and a pending create_worker_cb() creates a
thread after the group was made single-threaded.

Close all of that in copy_process(). Refuse to create a thread while:

(1) SIGNAL_GROUP_EXIT is set (set together with core_state by zap_process()
(2) signal->group_exec_task is set
(3) while current is in execve

Conditions (1) and (2) are handled with siglock help which means
copy_process() and zap_process() synchronize on it. create_io_thread()
treats the failure as a failed task creation and doesn't retry.

Fixes: 3bfe6106693b ("io-wq: fork worker threads from original task")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/fork.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 10be4a0ecb3f..6cd167a2b27b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2491,8 +2491,10 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_core_free;
 	}
 
-	/* Let kill terminate clone/fork in the middle */
-	if (fatal_signal_pending(current)) {
+	/* Let kill or a group exit, exec or coredump abort clone/fork */
+	if (fatal_signal_pending(current) ||
+	    (current->signal->flags & SIGNAL_GROUP_EXIT) ||
+	    current->signal->group_exec_task || current->in_execve) {
 		retval = -EINTR;
 		goto bad_fork_core_free;
 	}

-- 
2.53.0


