Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89E8C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14976B0098; Fri, 18 Sep 2026 08:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB366B0099; Fri, 18 Sep 2026 08:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E016F6B009B; Fri, 18 Sep 2026 08:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C30536B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:29:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18AA7406A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:29:07 +0000 (UTC)
X-FDA: 85226812734.04.D16DDD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1C20EC0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:29:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzDCnAHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789734545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HD8nHvrQrTh03hMY2yB216S/+n4XT3+0pQWuTJZk1jY=;
	b=jwlsVy9NWD8DfWkSMr6txw2TwNeZWKdQ7uuhVti5+6Wkr+wP+nP3w2KWXY5F0G7JCxCs57
	kgkFuY6pNUA1KrRR7rdJUxbBT5XfN5c5RCydIyeztf568Em46riAs6aZqbhvue/wM8douQ
	R4FseOU3+FXF/4SYe0bkC6/R0FlEoIc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789734545;
	b=1ZljbybDNkwTQ4WO9mA/YvJpw3gUt8QxBJi1O0WtWmsSJVH4KCL6bHR7K2r71WKr4jq5JV
	vJk9ZfhewBnhAsvSC9eq1+whp1VsfGceGYToGd8DxULDiLnFVzmBTTPc4Z68OoA2an1rl+
	+VBbwJBHTmJ0NXl3E8wIteOM1yz05XM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzDCnAHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B248423C9;
	Fri, 18 Sep 2026 12:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A283F1F000FF;
	Fri, 18 Sep 2026 12:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789734544;
	bh=HD8nHvrQrTh03hMY2yB216S/+n4XT3+0pQWuTJZk1jY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nzDCnAHzD7BanE/gxqCOdyViAr0TuOKS9KYK3SVwBo6avNV2/UzzBAYmNyM+j+3lK
	 tT1J28AH7wyZ8ko/uG1QSSOvPGcV1BIhy7UA3rtphTYw0gqAoWiW216O9zZa7t+ZaU
	 XnPdgxG7nIEIFvRw6QyKU35852p98FFiymVBti8YonjXOqktFP/nC9v02pWc1kxMvH
	 5Z8+32XVDWfdJeq/cvru+V6RgFDZHjyzmS87dAmA8y0e2njWzCiKSllRBp37x4QXyy
	 yACHVyd/8x4U6T4l0/92xvqlVnp0pms3OXkDNT/E9dXg6Tc2AjfbKwgamX+PMft7vb
	 IOanyIXQvXbvg==
Date: Fri, 18 Sep 2026 14:28:58 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: NeilBrown <neil@brown.name>, Chris Mason <mason@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: Re: user workers as coredumpers [Re: [PATCH 1/6] coredump: don't
 switch a dumper that has no files] table
Message-ID: <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
 <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
 <178960987412.207413.3957049392884487413@noble.neil.brown.name>
 <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1C20EC0009
X-Stat-Signature: 3e4tktow99j6i4q33zefq9bqkoxnug1p
X-HE-Tag: 1789734544-998125
X-HE-Meta: U2FsdGVkX19qTlwybmPVyo0i7ARKLMs7PyJBW7BgiM6OmJHRpIftBXicsNCSRlfK7mNPvI2WKEmlzcguEv4sm1FaZj5UpMCApPjqV7dQ65Ol/V8JQ4HjMhsJNLeXqusM6aPdzdeOC0P4r5cD5ST9ZC0SH3CCnnCN8FlM956RCQAsSir7LGMQXrhWxTfcrzDePjLtolt7bPiw9X/LstUJrAX9VcZDj1TYqVXo5ErfdtRaSc8LtXn99yCqlBGhyueQ7YRT/Xjm37oFrbkBG5IyqR2/uiFhDuJQzCXDZqx+l//nrY+Iawcvfz2nlDLzwl8pvoHQky+Y3um2ZEoRzt9QlVbp+ZWO98Y7F+fpNRhIDvp8LaAedxgdFEJinWUIv0HY8ZdMj/nDfUuTu/GNVAfigWPh1aWjCLxOQuIN4y5nmZb7+olOoE8369ky0t7ZSkVgluA/zIjlPat4l5ng2TvK/IVdZ6Vl0s3VymTUu+fgRkBYr2C9oH7jVO2gnShkeIVzDa/eTmBRLYNOOMxwbKr4bOBWx3J9aKdISiK6+xnXYNHopmxZ4j78xmxuhzPkQC1/yF0QtveexWjtMeeUo7b8OjqjQQ8YniUzp+XzyUfM2SPpnjx8ZPrbdMkRAnhkXj+dW7xwMr4d64eK04P0Ws/ZFAZIcl4MdsN3U1LXSu5AS/S6efnTVdzQbnmlSMepwAtkD2K3Xw9jKz8Xk5Ng0iERwTMh/lxoM5LMuladfDRTNF2s7KzxSSPvVB/RnNwXQz5GlMnhObTQMZrrTI5fFmurMVK41xMBGbhxFsuYn8nipaKC+TAY89yZn/pweAqhBRa/N3t1a92s/GqkllpYLoZ2C0E6XwcOYoxlpa1N+JndvZGQGUUJf/bdNmQFIPnssKJfBiKTfjIvOUb7If0c6RG8reLIAD4FFzuDX383qVZRhvmpdh4QxCFDEsrT/78H/7CvRW7lh01XFx5/nm/1eKe
 cAMk33YC
 MS8qtUjTuveRDFbD55tp7KnM/KBHcGHs6ScLPZs9WJUCLrOpHFQhrEM5kyI7E6wUdy7VrRfA1Ac2W6Z8nBjQOevWtV7y3dP4FKOkFSbR8DHkttnF/w0OyFyhR92KmC1l6QvK40IJ+rLp2IDsvO+288T3XmEiv2A1KM4SyJ4feypcoj7U1S5DuwaFEWh+bhzkYSzYoe3bdXKDlFGwMQgBNBCpq2GF4hYYfMZmRzaScGaqUyJb1zXV9HwnH7tIjQyEZUQTw7ZwwfwX8IFkGzQF3Vztb0QSB6/3/DlYluh15X+4NGIyvHoisKXeMXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 10:49:36AM +0200, Christian Brauner wrote:
> On Thu, Sep 17, 2026 at 11:51:14AM +1000, NeilBrown wrote:
> > On Thu, 17 Sep 2026, Christian Brauner wrote:
> > > > When I reproduced this one, it ended up deadlocking with the fix applied.
> > > > 
> > > > vhost worker (the dumper)          sibling thread
> > > > =========================          ==============
> > > > get_signal() -> vfs_coredump()
> > > >   coredump_close_files()
> > > >     hands sibling a new table ---> switch_files_struct()
> > > >     coredump_wait_inactive()         put_files_struct(old table)
> > > >       waits for sibling's switch       last close of the vhost fd
> > > >                                      vhost_net_release()
> > > >                                        __vhost_worker_flush(): waits
> > > > 
> > > > AI suggests making the vhost thread requeue the signal for someone more
> > > > suitable?
> > > 
> > > Afaict, this is conceptually a generic problem with letting coredump
> > > close files for any type of user worker where the worker is the dumper
> > > and the sibling thread closes the fd that causes it to be stopped and
> > > waits for it to exit. So this needs thinking and we should drop coredump
> > > closing files for now.
> > > 
> > 
> > It appears to me that there is already infrastructure in place to handle
> > the generic problem.  vhost_task has a "handle_sigkill" function which
> > cleans up on sig kill so that siblings won't keep waiting for it.
> > get_signal() detects PF_USER_WORKER tasks and lets them complete
> > normally rather than aborting them, so that handle_sigkill can be called.
> > 
> > So the problem is "simply" an ordering problem. vfs_coredump() closes
> > files before handle_sigkill can run.
> > Maybe handle_sigkill() could be passed to (a version of) get_signal(),
> > or maybe get_signal() could indicate to the PF_USER_WORKER caller that
> > vfs_coredump() still needs to be run.
> 
> Oh good, it's worse. This isn't specific to this patchset. This class of
> bugs I mentioned is reproducible on current mainline with SQPOLL:
> 
>   io-wq worker (the dumper)               SQPOLL thread
>   =========================               =============
>   io_wq_worker()                          io_sq_thread()
>     get_signal()                            io_sqd_handle_event()
>       vfs_coredump()
>         coredump_wait()
>           zap_threads()
>             zap_process(): SIGKILL ---->      get_signal(): SIGKILL, returns
>           wait_for_completion_state(        io_uring_cancel_generic(true, sqd)
>             &core_state->startup)             io_uring_clean_tctx()
>           waits for every thread to             io_wq_put_and_exit()
>           reach coredump_task_exit()              io_wq_exit_workers()
>                                                     wait_for_completion(
>                                                       &wq->worker_done)
>                                                     waits for the worker's
>                                                     io_worker_exit(), which
>                                                     runs after get_signal()

So I thought a bit about this yesterday and had some brief discussions
bout this as well. I think we should kill this whole bug class by
ensuring that PF_USER_WORKERs never participate in a coredump. So
something like:

diff --git a/kernel/signal.c b/kernel/signal.c
index ec30550951ec..e3c271cf1314 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3021,6 +3021,21 @@ bool get_signal(struct ksignal *ksig)
 		 */
 		current->flags |= PF_SIGNALED;
 
+		/*
+		 * PF_USER_WORKER threads will catch and exit on fatal signals
+		 * themselves. They have cleanup that must be performed, so we
+		 * cannot call do_exit() on their behalf. Note that ksig won't
+		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
+		 *
+		 * They must not dump core either. The dumper waits for every
+		 * other thread in the group to exit, and a sibling's exit path
+		 * may in turn wait for this worker's own exit, which only runs
+		 * after get_signal() returns: io_sq_thread() ends up in
+		 * io_wq_exit_workers() and waits there for its io-wq workers.
+		 */
+		if (current->flags & PF_USER_WORKER)
+			goto out;
+
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
 				print_fatal_signal(signr);
@@ -3036,15 +3051,6 @@ bool get_signal(struct ksignal *ksig)
 			vfs_coredump(&ksig->info);
 		}
 
-		/*
-		 * PF_USER_WORKER threads will catch and exit on fatal signals
-		 * themselves. They have cleanup that must be performed, so we
-		 * cannot call do_exit() on their behalf. Note that ksig won't
-		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
-		 */
-		if (current->flags & PF_USER_WORKER)
-			goto out;
-
 		/*
 		 * Death signals, no core dump.
 		 */

Afaict the main consequence of this is for a thread-group with a bunch
of spawned workers where the thread-group leader exits prematurely
before all workers: any worker that takes a coredump signal via ptrace()
shenanigans won't create a coredump anymore. I think that's entirely
acceptable.

