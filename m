Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F51C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53FC6B00EE; Mon, 21 Sep 2026 09:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B5E6B00EF; Mon, 21 Sep 2026 09:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40FA6B00F0; Mon, 21 Sep 2026 09:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 858D76B00EE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 154B3A4468
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:06 +0000 (UTC)
X-FDA: 85237893132.25.E924A2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 562B02000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aj1MZ6b0;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998364;
	b=tk44N7Q0wDEroSxi2mCkr/Hh00T8feRJ1Ml6PGmGd8SIS1+zllt3UN+ef2hrsupD3vr3Ba
	EPb20uyKl0/vvmR+O3GTsT3o9XXGiPmAYDQhLu2ir03sxD5dzNkKcAsg6TumjcxARZV2nJ
	YpNVsDWtUkXoHefaRoSp9x3jDeJ/zPI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aj1MZ6b0;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK+vFPcoNOWpEsInXI2i4g3mZjN5dJruLtFC6744UCg=;
	b=7HVqFvMscR7le1xn0TYhY5/pCMfbG5zNgB8U0gM7i/NyW8cj/kFVC0SlJkJOAT4kg59S+Q
	X/O9g8vJGCguZsMVEA6c8zKuTo5ubQcprL2yFMShGChdEde+Xi9r9i08dsX34drGxR3JPN
	6t3NIsGi2HXf5btGL/Impk2SFz3rl3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECDBE600D1;
	Mon, 21 Sep 2026 13:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC801F00893;
	Mon, 21 Sep 2026 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998363;
	bh=XK+vFPcoNOWpEsInXI2i4g3mZjN5dJruLtFC6744UCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Aj1MZ6b0DckcbN8ZWhMcy3sQmM5nKsMEjWSoa3mKzl4IzTTdqYMEkUXOnPbs/V8z1
	 Mx4jZ9zAiATVYJt5FPaI8JLIJKQrvVpq0b+xhEky4JsfoHwxRqlljaIeQYJlALdHJy
	 4gXFul/htFtIbwAHHvJ7UFvWrIEfQwsVShk8nfiSPeJTeyzDDh2P/QlvKGFh9Fg9ys
	 ho6lcgL2qG881lUJPTANEunTFLV+Mi6Z+65BhopjaMu7+eyZY4ncZAu/A8vkwRE017
	 Jdsab31+dou4Pm1UlIjSVp5JFnPRrUoXRpUiIkO2yuS/6kDm+mP4AdzUBBPFat3VVz
	 sLGUqsBTeskMA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:05 +0200
Subject: [PATCH v3 16/17] signal: enforce the user worker signal mask in
 __set_task_blocked()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-16-8e4adb1619e6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2674; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N9+t6kg9G5schzNoEgToZQtBo5+eN+aMw/ZqCZtP+xs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLm7ceqfa/vOperqasXWKHp+9/O/vtt16TmBg9pyW
 /pKTn9h7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIUQnD/xy1itCSJL+A5vvr
 bc6IHL/CpDexIOn7wa2JkpYVJu8LNjH801vYraC/epZrb8Lti8vr70eH/N73ct8GxiZ2sbvaHq3
 X+AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 562B02000A
X-Stat-Signature: 7tkytysa1afwr4cczj4rbixawn9wcweg
X-Rspam-User: 
X-HE-Tag: 1789998364-88014
X-HE-Meta: U2FsdGVkX18jtWEIAZAYFlRuT1EWFQO7znUuznrHp9FcyvjMIyZRkZ5eNW1UwmADZlKLi5qP091+w/uZTpR5/6Q+P6F0TN4QNYE2SnQAaM53MiwsFG621a8gkGKiO7Cih3B4jc6qc7lwcTh2L9Yl0wEjipDXvuh7DMJjmJIYlpsonVWz3mjEl9U6NAVnakOTBdiVJB2TaEGWUTVRif7XgX2BdSR9nAxae0v+KV7MdBv1+TXSTXSmHWkdTx0D6HBEmnVNwk35iUuo8F0w/MBUVKZFPJRcR2eDwJ57Kn7xql+j7LnikMLbBqiHvijXe3ByjPYNN44WSp4Zi7xghFo23j4VQcSG2Buh1acpBU5Ou8LEtoi7zm/AGgT9iOkqnTS7t+D1EqwWUgS76K1z6BkfHdJg3W0gT2lZqlfyCyoLJOBaEtEZElucNiOM1dBOPzdEuhs9Ik9mZlSv+nsMo2xTjffMo0mOvf5A8iesrGaEMl0PjEF+C/v44X+Ph4a/vDu/aAnslDG01oO84nKutjg6azMrvLEMVYC38KOFh8ySWGKnltBzfuSu9zqFpdDpalj8J/MmXYledIeo72pvakSzepYnqPaOLUo1hbMa470LuqLqFgAYFZKqbYrubGHDkXHmb0loxuw/Ke4wvGxtGPeDAr1VH2cMOdCWRzv7eEkcX4AuKkCDWpwKaEXESb1ti9qaWpPUEmGtLTetA6o+313NI/PeAeIi8PrE8PyGe6itKyKflKM6M+nX+qYVC9uLzADJSuEMiQjLHcb8aN4am7pe7Qj5Kr++MVP5wLiLVL6CBwNTeHPHac9vRkOd+k2A4GoTTY9rkEv+p07XmOWJ68AN9RWKNoeAnns0uvEbqkLi88Td6t7RGWtR3UnUbwm1fwb70Foa8VTNd2e4iMJDGoS0ap0gkt9oVPKHDk/hDpjPQjaOO31u9lXL094hpRZnJdozbXzZgZmkKM3fY1hyy8d
 0fxk0Cah
 pYtw6YxOz6BnKAkBWKa/PVkx7DFdJMSRT7++l7NGTPe0zGG55kZ3XvOwcwajFieYwTMI9fl9Q0BpQN39Gh+v2G1/0DLPL6YOv/HsdD5ossy6s3eOQ/b2vZshu89vc4rAsNOvUJ37TZdQpcyuc2QjkWMFa1a3FSGaAdBpPqoULW/CcmHqkuaTjftrFBD6TqKW0xS/Lo0x1oFSvSCbVaareuCekdCROLCEQZsx+/g5AjAErgsVP7STSi4bTDBPil3UTKEY042T8q+GKatEzA3ztQm6CRKXt2loPDZ9WYlLaVYwJ2wSWrSjcjZqKow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

User workers block every signal except for SIGKILL and SIGSTOP in
copy_process(). So complete_signal() never picks a thread that blocks
the signal and get_signal() never dequeues such a thread. Net effect is
that user workers only exit on SIGKILL or stop on SIGSTOP.

Before we fixed it a tracer could unblock a signal. For example, by
unblocking SIGHUP a installing a handler complete_signal() could end up
picking a user worker for a process-directed SIGHUP. Which effectively
means the handler never runs.

After blocking PTRACE_SETSIGMASK what remains is the in-kernel
sigprocmask() and force_sig_info_to_task() changes.

The in-kernel sigprocmask() users block more signals for a critical
section and restore the saved mask afterwards. cifs used to do that in
__smb_send_rqst() and ocfs2 in ocfs2_block_signals(). Both were
reachable from an io-wq worker. Both only add SIGKILL and SIGSTOP to the
user workers's and then put the fork-time mask back.

force_sig_info_to_task() unblocks a signal so a target can't hide from
the signal. A synchronous signal forced onto a user worker is accepted
currently so let's leave that alone.

Make it a rule that a user worker's signal mask can never drop below
the copy_process() deafult. SIGKILL and SIGSTOP have the same rule in
the other direction. rt_sigprocmask(), set_current_blocked() and
PTRACE_SETSIGMASK strip them from whatever mask userspace asks for.

Do the same for user worker mask in __set_task_blocked(). Add the
fork-time mask back into the new set for a user worker and warn if that
changed anything. Warn when a caller unblocks a signal for a user worker.

No functional changes.

Link: https://lore.kernel.org/r/aq_4fY6GVtK47Njq@redhat.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/signal.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index c3bad983dd37..137002445b0d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3212,6 +3212,16 @@ long do_no_restart_syscall(struct restart_block *param)
 
 static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 {
+	sigset_t floor, floored;
+
+	/* A user worker never unblocks anything but SIGKILL and SIGSTOP. */
+	if (unlikely(tsk->flags & PF_USER_WORKER)) {
+		siginitsetinv(&floor, SIG_KERNEL_ONLY_MASK);
+		sigorsets(&floored, newset, &floor);
+		WARN_ON_ONCE(!sigequalsets(&floored, newset));
+		newset = &floored;
+	}
+
 	if (task_sigpending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
 		/* A set of now blocked but previously unblocked signals. */

-- 
2.53.0


