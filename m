Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC99AC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4206B009E; Tue, 22 Sep 2026 10:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5316B009F; Tue, 22 Sep 2026 10:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA726B00A0; Tue, 22 Sep 2026 10:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61CAD6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:33:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9BF8160514
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:33:42 +0000 (UTC)
X-FDA: 85241641884.29.095E16D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28553A000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:33:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BX9biEl1;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790087621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX+z6NYoCWxNBGYU99ktnwwcCSe7GjbZgEJXo4djVCo=;
	b=iBweqjIS4dk61vA7KA7Y/3zj5xo8lcjFQ9vA6QHbUuOMQZtXf1ZR+JrDIJOLxCCYY4u400
	DuWSDtFFef93kanDM626vkgEHmWJtWqNqei7ij3szZdT9GpP6Jl5kCHOUhjEEKVnSk+dxL
	bYRvYuLm0h5hIJoTwctweTy3n3/weNI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BX9biEl1;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790087621;
	b=6Jg0GA/AjJ0oRSjUzLGvKa3p3vkIcsCHDfFbzjon/blFYo5FjDznbW/GfDXDtt47ZnJ4vn
	ku6IQNniUvgN+ZgV29kq4qowxJjPKjsbcMgJ8iN6TPwwFV4PNv+H2q3QlRvIxF/2/RBpUu
	3un+6ZEmQM9ad6uxioCmgZzZst9kCuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC805400A3;
	Tue, 22 Sep 2026 14:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21801F000FF;
	Tue, 22 Sep 2026 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790087619;
	bh=SX+z6NYoCWxNBGYU99ktnwwcCSe7GjbZgEJXo4djVCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BX9biEl1MsiHmxiw5g0mwtlxHsMXdJJs7EENd2SKzhScStDGRDti4g9OlEPHw93Ix
	 WrdBXYIVZUqDh6y4UhXrfQJaSXbUEpfMnPklbBRUI1kUaQ1OdGdIlQYaP2uiE+3K/Q
	 nKulIl1srUyP7Zg6uugHpCEHgsh/dd2RDn7SpBdeuYDN1LcvJOUErXq/QdFuLo1U0u
	 gl8yNWwEUhgFlk0Zulfl6iAqDpS/Fq7n2j0bDp/NkyUJlS51yQmFLsyFl9jefnguHS
	 EmvE0IyhrPe6y8vqHqStNyadWtZ5Im7mY8iygqft8AHxZD+n/7cmuJT8b+lXXeuztX
	 A6umjl156o2jA==
Date: Tue, 22 Sep 2026 16:33:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 02/17] signal: only SIGKILL and the freezers interrupt
 a coredumping task
Message-ID: <20260922-bibliothek-fakten-vielzahl-78613362e349@brauner>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org>
 <arJ6zZuI59BJnXpl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <arJ6zZuI59BJnXpl@redhat.com>
X-Stat-Signature: s1x9t3pyrao8daefaiphwi44z5j9duu4
X-Rspamd-Queue-Id: 28553A000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790087621-321177
X-HE-Meta: U2FsdGVkX1/hQ0GNSdS+3wY3NPqNR7yHcog+MOdD0OoAIazeXbhm0EcZJatC33L6SbP+goyqwIvq+CUpDg9+E5lneXHW3hvnkx4M1EdXS/t3stM83UeQMIERXeXPn7Eb2GJKnd4MfjLE489k5XNgcZ/CzgOvQ9LZe0ifjui+zdPjGX6ELxmSd+z7BlgdKWKH0vIBjf1T7qpB4pFCSzjNtVQ0cSSfRYZY5TzFiXy1Kn1xsSMp9p1LV9ulgPGsCfyJtmPZ9vJv6kZ1NFKqWtgvfrCE9+u8vJLhR6ehjAzmSRIWFov82XA0lY3Grv7Fez+ty7yrjMehjDscaCH1+s+K2cSXvsS/v441RssFeyH4vSvw3jJ11Pvgr/xZ86Gabpf8Kw5nulo8ttx81ExfNMJk6LA48QwwrDa0GAZVv7XiSybnXK06nqWcUv/sJqggrM040Vh7j5wA6UFckMPtFe6BLMbdXQdPFLvXxEoq7/ANjFk/nStjYFHIA05fo0X2TY8GW6XeXatWk4Vntx//bxxKGdZwNLfyGEFPFpzmQyBVlXIQwO/xbHWRDoHXfHEDb+goskF08RXdjRcWkDyKxZHEhOmCbqqX9XMbycJtUPBOpylQbMTmVl6VHGW5EDDHdcCnO004qNOyVOPhXJrycGskNgc7HZ2MiYKKoPjiZ3HtlhNiPo9KcxQO+7SezK1Z6lTW3SJvWDFIzNsDVtjyl+STTQLQGb0Vc6AfwcA59rLOQQQbO7jOfZdyeuidjOpoI7EWsbRwWPjMZuNOYQ/aByw7g2TFExFEugTL2xL5dBMxkeGSOXDPHvBl9LfS/yfk+Whj2IATFAIIJvJ5SDEOTuYf88m8hvwvVh4kvycmvvhXm+/CEPjxBjWiSFyCDk3KDGcTIajfm2Hjg76wzee6uG6TNFiEoUh91eaoAhZ30+RtHqpvYy4WpwilAs1Dcxt0+J+sHgPl0cKra1S6Lf/fgyJ
 X0bPOR24
 5PjWMsYoI6s3tAbVLU2MStWcDV8adkL0IZRvaN7nhRFCZlR1iLUOsHT6OR089YyxgHz3Z94IA+uPIm9IBqCb6QaSnSSACW0P3vUlpDW0L0nvaVpbyBD34jEXDYfjiKv2vLHJcYvG9s31Yx5RGNfsG2DjOw5BK13SwKH6tiiBVdiq3lSk8g4EmgRiVPmaEPYoAQmrbEgv8LcQtLyzQlMqQOVtfKUn8T2GzTYMicWx+4QdlpurnSJ9ZExhYEdHtcuNguvGU1naG6m9CLVmYWdxkRUTzkUOjf+T2KH7GlcGNkqBFfVQsWA0D8KoOxU5qIbG3wlG6hVshXvethOP8Rv0H2VPkXSXAvMoJKXeddoO1996B32WN4EKZsffKqydgBad7DHPOuOjtgDUciKPNqrYirjmw1K5HVVA3SDKSrsMAsUsHRo61vx3TX/YLUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 02:55:41PM +0200, Oleg Nesterov wrote:
> On 09/21, Christian Brauner wrote:
> >
> > For quite a while now coredump has allowed either SIGKILL or freezing to
> > interrupt an ongoing coredump. Since we seem to like it complicated
> > "freezing" can mean a lot of things:
> >
> > (1) Power Management induced freezing
> > (2) cgroup v1 freezer controller induced freezing
> > (3) cgroup v2 freezer controller induced freezing
> 
> All of them do signal_wake_up() which sets TIF_SIGPENDING
> However, zap_threads() clears this flag.
> 
> With the recent changes including your PF_NO_NOTIFY_SIGNAL and
> 05/17 "signal: don't retarget shared signals in a dying thread group",
> what else can make signal_pending() true? Apart from SIGKILL.
> 
> So perhaps we can simply do _something_ like
> 
> 	--- x/fs/coredump.c
> 	+++ x/fs/coredump.c
> 	@@ -508,7 +508,8 @@ static int zap_threads(struct task_struc
> 		int nr = -EAGAIN;
> 	 
> 		spin_lock_irq(&tsk->sighand->siglock);
> 	-	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task) {
> 	+	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task
> 	+	    && !freezing(tsk) && !(tsk->jobctl & JOBCTL_TRAP_FREEZE)) {
> 			/* Allow SIGKILL, see prepare_signal() */
> 			signal->core_state = core_state;
> 			nr = zap_process(signal, exit_code);
> 	@@ -583,7 +584,7 @@ static bool dump_interrupted(void)
> 		 * but then we need to teach dump_write() to restart and clear
> 		 * TIF_SIGPENDING.
> 		 */
> 	-	return fatal_signal_pending(current) || freezing(current);
> 	+	return signal_pending(current);
> 	 }
> 	 
> 	 static void wait_for_dump_helpers(struct file *file)
> 
> ?
> 
> At first glance the change in dump_interrupted() makes sense anyway.
> For example, dumping to pipe can't tolerate signal_pendin() == true.
> 
> What do you think?

Yes. Here's what I have in the tree.

Subject: [PATCH v4 02/17] signal: only SIGKILL and the freezers interrupt a
 coredumping task

For quite a while now coredump has allowed either SIGKILL or freezing to
interrupt an ongoing coredump. Since we seem to like it complicated
"freezing" can mean a lot of things:

(1) Power Management induced freezing
(2) cgroup v1 freezer controller induced freezing
(3) cgroup v2 freezer controller induced freezing

So (1) and (2) are handled by checking freezing() but (3) isn't.
(3) uses cgroup_freeze_task() which sets JOBCTL_TRAP_FREEZE and calls
signal_wake_up() on every task in the cgroup. The trap isn't handled by
the coredump code.

Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/arJ6zZuI59BJnXpl@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v4:
- Gate the dump in zap_threads() on freezing() and JOBCTL_TRAP_FREEZE and
  let dump_interrupted() test the flag, as suggested by Oleg.
- Drop the signal_pending() hook and coredump_signal_pending().
- Blame the cgroup v2 freezer commit as well.
- Link to v3: https://patch.msgid.link/20260921-work-coredump-fixes-v3-2-8e4adb1619e6@kernel.org

 fs/coredump.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index d88a65e37ee1..af09a4660341 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -508,7 +508,9 @@ static int zap_threads(struct task_struct *tsk,
 	int nr = -EAGAIN;
 
 	spin_lock_irq(&tsk->sighand->siglock);
-	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task) {
+	/* A freeze requested before the dump would be lost with TIF_SIGPENDING. */
+	if (!(signal->flags & SIGNAL_GROUP_EXIT) && !signal->group_exec_task &&
+	    !freezing(tsk) && !(tsk->jobctl & JOBCTL_TRAP_FREEZE)) {
 		/* Allow SIGKILL, see prepare_signal() */
 		signal->core_state = core_state;
 		nr = zap_process(signal, exit_code);
@@ -580,13 +582,8 @@ static void coredump_finish(bool core_dumped)
 
 static bool dump_interrupted(void)
 {
-	/*
-	 * SIGKILL or freezing() interrupt the coredumping. Perhaps we
-	 * can do try_to_freeze() and check __fatal_signal_pending(),
-	 * but then we need to teach dump_write() to restart and clear
-	 * TIF_SIGPENDING.
-	 */
-	return fatal_signal_pending(current) || freezing(current);
+	/* Only SIGKILL and the freezers set it after zap_threads(). */
+	return task_sigpending(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)
-- 
2.53.0


