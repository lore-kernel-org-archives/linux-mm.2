Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2943ECD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 565F36B0005; Mon, 18 May 2026 18:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512FF6B0088; Mon, 18 May 2026 18:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429676B008C; Mon, 18 May 2026 18:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2126B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:37:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1DCAA091D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:37:58 +0000 (UTC)
X-FDA: 84782004636.29.FD249FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6320100007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:37:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ElMKWvtl;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779143877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEV4TDJUhMiAdDZHSwwT8rqxjCYJIbJx53+LjEeC5Jo=;
	b=zd6GNwDWd/y/exJ2nTArL3YzbaL3UIv8n7aCLXzdKOeDA502ZnJAIP5SbK+mHHkkNYvgFD
	F2xaMC1m0agCDUU9l5YxgvMyHih3qMOA+XDoQuYFg08POQVdPZY0Z8oGfGi5aSwBirTGV2
	yTqWqRf/ycJNDD+OkYNESj3dn8FYsUI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ElMKWvtl;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779143877; a=rsa-sha256;
	cv=none;
	b=YvWVOifax3Bia6gcvWO4JhZLUBFVyu2zvIC5r2bz7c+w8fvs7+GqVSvi0oO0pvzfDnAfrH
	WnnNlAMf+3cAS/rMJiN113clDDvcTM06VsUmunM8R+g12dQRU4DpRU0pXUi3MgOo8BVJiP
	MxzDC5E/lyNumI1pgZU72uaFyEJ/qbU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6AC544305;
	Mon, 18 May 2026 22:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C557C2BCB7;
	Mon, 18 May 2026 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779143875;
	bh=IxSNiaISllfVtHvt5Gju2AVT30PdTibnWQufK4CoGNo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ElMKWvtlrYQVJHpqzMtMAQe5BB0aDbgakLhbNKiIyRp+ZoSFA5LC/W42SQzbsdETT
	 OmDX5NorKwzWKT8bVZAiQtWaobbmaFYPkT8wwhHPXcLoip4jmRvhVZc7yJwwDhUgXj
	 Ja7AQEGXYBZ/tFp5h0XvLVPV12vfHioppD/9AuOk=
Date: Mon, 18 May 2026 15:37:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Deepanshu Kartikey
 <kartikey406@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
Message-Id: <20260518153755.f3248bc3725d5b745a6696f9@linux-foundation.org>
In-Reply-To: <aglotu9HOXmwMM35@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
	<abld-ilvMEZ7VgMw@redhat.com>
	<20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
	<abmmnjgxrrGLKn2D@redhat.com>
	<5acfea15-f2f7-4498-86e1-a383e17adad0@I-love.SAKURA.ne.jp>
	<aglotu9HOXmwMM35@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6320100007
X-Stat-Signature: cy6h3gokyaa54fa5iue3wz9hk7ndu81x
X-HE-Tag: 1779143876-88457
X-HE-Meta: U2FsdGVkX19h5Wq9yeXxufd3hFzlS2KU0sS4zoDBEhPgGivXoGnopODCL2evqZNlPgJGN7k2YjJkG/PJslkFDEQTm12UEros9LcwmYggH5VsARTtzdwNTwS7/bd2Ps0+jerukb7YUp9jv8WQIDHONnHNxNPYjMNukLDFZwXftCOjRANnkQlXL5vgTKmsifSdAdZsx6yrsMWG8tY9uXR/t8TkY51kWa8FhiyMdpaCiE4Ce0fh+Owwj2YOclLT0RtgSfmKVwDUkANJRhb11y2dE0QkzsgsJuJmxLJAFR/KZdUzEUxPyCnnjvh1VExJscA9RnScaycb+ot79iD544a9jOSh8POx8Vj1Pa99oRiFsq3Mi7L0WVH7WvisDZSnC6ujRWqvm8ZhLYXPzv14K9vdAMZbukuOq6tZMMfeqPwjqkrApWJUsFxSpng3jbzEkEY521iyAEAzoIzSHTFVw0s12sLTC/xoU+Gu9d8UmqAePbBpknxQ1lm9v0174RXxyfYfV/ZNQf9tH/r0em5R1yawxRI3fqB+aV2uPrnQ80UfURCh7TptX5LhD3ZQPiMyElo5aTvEIvn0Kjb2Ou8BePQ4haXgVznrRb751rhKt2U8ZAy5FSNmBBw/oXXiHDUIRgJzlgQTdWN9YdKwAZZV6uQhad7/rGPREsJiLIr1raKHrk0QLDtFWkXjfzL+p3T29OTJJR1FB8C4dgz8WTWVbbZhCRScWzJ3McZemwve800WPyy7Pe763bsy9okBKLwfI7x3UbLDHPbpigR4yZU1PxOhrAGt1m/wzQqE/P/RffPJOlBT8yvw38cWj25M3olXffuwx0Rhd86uvUeXN07kp/xKB9hvWBhzz/DiupWddgQFcgda0uPPjyqdEPdmkoAqhLu9PSBu8a9iBsveOueHuuOSAXSxfJ2BW8UkcU08tS8MDDLsRmrqM+G3efna2GXfjkmWCNW+xoCMDfrLfogKl/m
 2VmkbALB
 sMrLRoKswkhVb4snngeIISS/ZuNuhGaBUIcTossNONmcs2We5T78fMLU8OYZFnBdEDFDy1iJq1oF242HHZXX5K56eqAO1ArfbJu3QzX5uigRz+5wXRw8++zZsUhwKBGaGnscSoTT7Cnx+KAfELefiUtEcjrw/gKckNPQiGOlt1mUsH/YcOoMZOBDLUvf93tOwaJb8Kg0GsJViNe9ILNHstm9SWin54GSkJZfz3rZVVy01TvZeTcERkgq7p+hd2ED0dke4kFHqVpV+fHAMCyHlJ1RKSB8FXEAUg8N8r17V0aQOC1wLaZS5mnq0hfA8AP4xuQ9RgFGcVRZJk/CYzFUDu2/flOAXp/SdjtfxxVwKnngfeT2gXs0Iuy6l4Y8qxh+M2vxeneViXSICzWyPd9qan4CcUvPTLDDoTextb+a/WlGaK9YKpJHI3b5k03JnM+Q9gc7W0nmJ2kKvVNYoTL3AwHFp4KEVU6wh6f4CAiqFur0KFoXjidkNGiZtbSBR+6U5PpIK8GCXDw+esBrf3SCWM8EVYmAEXm9wmYVq80vMfRgCeBGeMK/pusA5Et7mttunUupPtFKHZNdH2cRFNeqSD0Gwb7g8S9L5nGtjndkP83Csy+WEjPKxKwOSpvECKoNAXXtiMH5eQAg9U2yal3BJmv6JqUHFK+TfHS6n/+mK4allZRve96/r/xmf8yzpG2RAFpRSx2KsRehTF8ZKvAqBpkiQhJ7b4RaGHzlTWwDXjgaCtUbrGDrtOjbrKJLWU2iFuVd1pt/JqOLJGiL/UfpxQ6vIe1dKB/ijqSFAuR1WfPvqVa+FSyS99hmjMvAxfMBxEPzL3ztUysChheozExTcOUiIYAQ2BrloQ6VC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 09:05:26 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/17, Tetsuo Handa wrote:
> >
> > On 2026/03/18 4:08, Oleg Nesterov wrote:
> > > On 03/17, Andrew Morton wrote:
> > >>
> > >> On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> > >>
> > >>> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> > >>> argument of do_notify_parent() must always be valid or we have a bug.
> >
> > No activity for two months. When is the fix expected to land to upstream?
> > This bug allows a local unprivileged user to crash panic_on_warn=1 systems
> > by running below program, and therefore should be fixed before Linux 7.1 is
> > released.
> 
> This patch depends on
> 
> 	[PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
> 	https://lore.kernel.org/all/20260316151956.563558-1-kartikey406@gmail.com/
> 
> but it was merged without the patch above.
> 
> Andrew, that patch is still in mm tree,
> 
> 	kernel-fork-validate-exit_signal-in-kernel_clone.patch
> 
> could you merge it as well?

Thanks, I moved the below out of the 7.2-rc1 queue and into the 7.1-rcX
queue.

Should this have cc:stable?


From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: kernel/fork: validate exit_signal in kernel_clone()
Date: Mon, 16 Mar 2026 20:49:56 +0530

When a child process exits, it sends exit_signal to its parent via
do_notify_parent().  The clone() syscall constructs exit_signal as:

(lower_32_bits(clone_flags) & CSIGNAL)

CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
valid_signal() only accepts signals up to _NSIG (64 on x86_64).  A
non-zero non-valid exit_signal acts the same as exit_signal == 0: the
parent process is not signaled when the child terminates.

The syzkaller reproducer triggers this by calling clone() with flags=0x80,
resulting in exit_signal = (0x80 & CSIGNAL) = 128, which exceeds _NSIG and
is not a valid signal.

The v1 of this patch added the check only in the clone() syscall handler,
which is incomplete.  kernel_clone() has other callers such as
sys_ia32_clone() which would remain unprotected.  Move the check to
kernel_clone() to cover all callers.

Since the valid_signal() check is now in kernel_clone() and covers all
callers including clone3(), the same check in copy_clone_args_from_user()
becomes redundant and is removed.  The higher 32bits check for clone3() is
kept as it is clone3() specific.

Note that this is a user-visible change: previously, passing an invalid
exit_signal to clone() was silently accepted.  The man page for clone()
does not document any defined behavior for invalid exit_signal values, so
rejecting them with -EINVAL is the correct behavior.  It is unlikely that
any sane application relies on passing an invalid exit_signal.

[oleg@redhat.com: the comment above kernel_clone() should be updated]
  Link: https://lore.kernel.org/abwvgU17W8wuW2-J@redhat.com
Link: https://lore.kernel.org/20260316151956.563558-1-kartikey406@gmail.com
Fixes: 3f2c788a1314 ("fork: prevent accidental access to clone3 features")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbe6b99feefc3a0842de
Tested-by: syzbot+bbe6b99feefc3a0842de@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20260307064202.353405-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260316104536.558108-1-kartikey406@gmail.com/T/ [v2]
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-kernel_clone
+++ a/kernel/fork.c
@@ -2664,8 +2664,6 @@ struct task_struct *create_io_thread(int
  *
  * It copies the process, and if successful kick-starts
  * it and waits for it to finish using the VM if required.
- *
- * args->exit_signal is expected to be checked for sanity by the caller.
  */
 pid_t kernel_clone(struct kernel_clone_args *args)
 {
@@ -2700,6 +2698,9 @@ pid_t kernel_clone(struct kernel_clone_a
 	    (args->pidfd == args->parent_tid))
 		return -EINVAL;
 
+	if (!valid_signal(args->exit_signal))
+		return -EINVAL;
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2898,11 +2899,9 @@ static noinline int copy_clone_args_from
 		return -EINVAL;
 
 	/*
-	 * Verify that higher 32bits of exit_signal are unset and that
-	 * it is a valid signal
+	 * Verify that higher 32bits of exit_signal are unset
 	 */
-	if (unlikely((args.exit_signal & ~((u64)CSIGNAL)) ||
-		     !valid_signal(args.exit_signal)))
+	if (unlikely(args.exit_signal & ~((u64)CSIGNAL)))
 		return -EINVAL;
 
 	if ((args.flags & CLONE_INTO_CGROUP) &&
_


