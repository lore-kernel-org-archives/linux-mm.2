Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F0FC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA396B008A; Fri, 18 Sep 2026 09:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B22E6B0092; Fri, 18 Sep 2026 09:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF546B0093; Fri, 18 Sep 2026 09:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B34C6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:33:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFFF1A06B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:33:39 +0000 (UTC)
X-FDA: 85226975358.21.3A67BA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5216AA000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:33:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nre12zSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789738418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GakW/jyw2WKm8P0r1Hyy2EtB+8kZHDDr5ILgeIU3TTo=;
	b=0petcmqzg5o5hXeEE6kxisJsqistwf4Db7MRAyKHb4Eb0wPNPI9P117sGVvu1/7PG3xUbG
	CtE99+yvEN1boKt2kUemRqkdh0OLp5Qc8xv+gz6hBZBNonhJIdcyZOY2bYsY3dSyjEOelX
	l+vn4wA64n0H9W8oPIHZ8r742muxvWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789738418;
	b=HUR2kio1km8k1e48YUtYIfYLf4HRqH9oIoa4ZjfkDedlhKkmkogtXoHfUBE2+BLrrSTHhq
	cib8smOlt8Y+ahH2rYRM9tLt69iRJzXT56hU116FHCnt6H5zZi7K7NUtmk0uncNUH41Cub
	tW/QBlkDIEnjLmYSiwbOCKKgmRgv4F8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nre12zSF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2A8C6053B;
	Fri, 18 Sep 2026 13:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D51F000FF;
	Fri, 18 Sep 2026 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789738416;
	bh=GakW/jyw2WKm8P0r1Hyy2EtB+8kZHDDr5ILgeIU3TTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nre12zSFEZj6AxBe4+WVzUlkMcdC+/awKkJWcu+08/s5KVpZ3J0/I19rSO0Dpsafl
	 ZiXQNy6Ia581usrFlSG/RKreyXMclax++76kj7xJOGL+OfJYei734waXZhxpOwNoAH
	 XcL50O+4XXiXhghO0jlpVJOBVW6Jh8rEaqqvZQw2WWrBnZeMk205/TG1KIA4Bcwzar
	 eUFJ8QO/hMtQc5133iFVrO2WmE23d7ApV/YNGhMsCwUFhaz/uqXr6PZAdCpZjDVvma
	 fNcUc6FRiR/ot/W9YlZubSS6JqSNtohexiwpcavpsKEkicIzYpHUuSUwh++PX1XQ5z
	 AFmF8wASYPzFQ==
Date: Fri, 18 Sep 2026 15:33:31 +0200
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: NeilBrown <neil@brown.name>, Chris Mason <mason@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, io-uring@vger.kernel.org
Subject: Re: user workers as coredumpers [Re: [PATCH 1/6] coredump: don't
 switch a dumper that has no files] table
Message-ID: <20260918-gliederung-schematisch-innehalten-7ab359d08bf7@brauner>
References: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
 <20260916194837.3732307-1-mason@kernel.org>
 <20260917-staunen-sparsam-infusion-83238c68d21f@brauner>
 <178960987412.207413.3957049392884487413@noble.neil.brown.name>
 <20260917-zahnpasta-aufweichen-flackern-1182320f5c81@brauner>
 <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918-tonart-umgeladen-gesponnen-519fca5172bd@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5216AA000C
X-Stat-Signature: knfj6xtf71cq9k5sq7hruwhfsxixeewe
X-HE-Tag: 1789738418-903694
X-HE-Meta: U2FsdGVkX1/l/hh0ryANaplFRKxvTqfvwPLBLcrDu/tq+J7EIdfJbM9o1Pc7ZAy9DCL2JHbfoCVyxV9CLkmmQrmn4aR8usFjmkgt4xLnhTFpklx7zCwzK4Lqu/szJSkygqZZrM6BxvV+ezzrroLV3vfER8aopnwuuP+/ecZi0+ycB1gfwobuJ0416795aYtPCTjqmFS8A14rSmq2QvuyGiFq69A6okYA6oNqV4kqn548i1y6ngDNAzxdkvr9Ls6CM3YDED0fOPShWrd1fMpnQeVAODVlTgIgeyIZUsvThsHpXwH5ACx5TMG/hTf0Qr+lhAg6rgv8JUUKNSwlsYK3eihHdUkcmDpzM4+gH8/KzL9snCjBqAVQ2E/vMNcp9ugNEDkasjU40CbWgbQnwM3G3kYyDH3edQlovIVaDztmzcsK0EmuP1f3KPcSUAR2F/z3Ua4Dn8ND28kCdRwe5CuW0fzA0nPU4oI3RPoFodBHb/+Xeu9zDtDY5cmpSYsI44/6EFrJ1UQLpHB2a7XkLqPyg6UUXch2/CyLFcuZp5WLMky2Ats7kqSAuIZEe7XX6D88fy1Suyv26dkCHzge65Cq+bGkNTZhrFP1hi4ThhRcb1GT34UkGCn02Qsa3lwwgZ/XkvASAyEgIdxR+Vw+FtBpSjS57FX74EOlyu5XZdxGiDl+rs+Nnb4SVs/D7PbcaxsoDlDp91z5zd66eQUYKMZoNLG1jTR8rFhey+bbOgPRacz0Z/Fe7ohJzGBuvg65XJnX6qVgGqiKNfJn7jB4GPaIMecROVpf1HgAJX5PCccAEfryuwQOtIKx1GQ2/8jVT7mTGVG6hD4Hh4yZwKumY9T+IAwR8sk7anTAmVLC87sTO7dlCHlp1mRG+4NGEn/wAhk1Aa1nyT+H3nbMDtVmxc/vaL/qw5dMwd8b8d/M5YD7vILw0XNlgAGdUOZ4ldQmzIoq88h+A46W6lNN7BpEmjc
 YSkGmeVK
 1ilsu7WDZa/hEXsCX7/PzjmXIAsKlvv0C1qvgWQWrEU6MGwbvRg2WjNR6r134WgAg2ul8EnNtBdcLnlnuijrhES1esh61GZTL3bXBvSRwzYVTTV1f4kig5LtZOw+Xlq0vNqJqnuzpFPd5O6FNA5Jb5Zr6pj2WITRscvYMI0s9I8S7sSLA47d1LdNy1rQrEyFLpKlwE7hqklNwtekPVKiJcvZ6hneaR1BJdftTKg870XUxozG6chFsRRcQlx8f8JQOnBQkqqr2Y42Jk4nr5D4nOvyaicHmi4S2fzTI8lDu8y+mwF+NRA6eG73IJzh69wboI1Lw2jSLbFl6ml4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:28:58PM +0200, Christian Brauner wrote:
> On Thu, Sep 17, 2026 at 10:49:36AM +0200, Christian Brauner wrote:
> > On Thu, Sep 17, 2026 at 11:51:14AM +1000, NeilBrown wrote:
> > > On Thu, 17 Sep 2026, Christian Brauner wrote:
> > > > > When I reproduced this one, it ended up deadlocking with the fix applied.
> > > > > 
> > > > > vhost worker (the dumper)          sibling thread
> > > > > =========================          ==============
> > > > > get_signal() -> vfs_coredump()
> > > > >   coredump_close_files()
> > > > >     hands sibling a new table ---> switch_files_struct()
> > > > >     coredump_wait_inactive()         put_files_struct(old table)
> > > > >       waits for sibling's switch       last close of the vhost fd
> > > > >                                      vhost_net_release()
> > > > >                                        __vhost_worker_flush(): waits
> > > > > 
> > > > > AI suggests making the vhost thread requeue the signal for someone more
> > > > > suitable?
> > > > 
> > > > Afaict, this is conceptually a generic problem with letting coredump
> > > > close files for any type of user worker where the worker is the dumper
> > > > and the sibling thread closes the fd that causes it to be stopped and
> > > > waits for it to exit. So this needs thinking and we should drop coredump
> > > > closing files for now.
> > > > 
> > > 
> > > It appears to me that there is already infrastructure in place to handle
> > > the generic problem.  vhost_task has a "handle_sigkill" function which
> > > cleans up on sig kill so that siblings won't keep waiting for it.
> > > get_signal() detects PF_USER_WORKER tasks and lets them complete
> > > normally rather than aborting them, so that handle_sigkill can be called.
> > > 
> > > So the problem is "simply" an ordering problem. vfs_coredump() closes
> > > files before handle_sigkill can run.
> > > Maybe handle_sigkill() could be passed to (a version of) get_signal(),
> > > or maybe get_signal() could indicate to the PF_USER_WORKER caller that
> > > vfs_coredump() still needs to be run.
> > 
> > Oh good, it's worse. This isn't specific to this patchset. This class of
> > bugs I mentioned is reproducible on current mainline with SQPOLL:
> > 
> >   io-wq worker (the dumper)               SQPOLL thread
> >   =========================               =============
> >   io_wq_worker()                          io_sq_thread()
> >     get_signal()                            io_sqd_handle_event()
> >       vfs_coredump()
> >         coredump_wait()
> >           zap_threads()
> >             zap_process(): SIGKILL ---->      get_signal(): SIGKILL, returns
> >           wait_for_completion_state(        io_uring_cancel_generic(true, sqd)
> >             &core_state->startup)             io_uring_clean_tctx()
> >           waits for every thread to             io_wq_put_and_exit()
> >           reach coredump_task_exit()              io_wq_exit_workers()
> >                                                     wait_for_completion(
> >                                                       &wq->worker_done)
> >                                                     waits for the worker's
> >                                                     io_worker_exit(), which
> >                                                     runs after get_signal()
> 
> So I thought a bit about this yesterday and had some brief discussions
> bout this as well. I think we should kill this whole bug class by
> ensuring that PF_USER_WORKERs never participate in a coredump. So
> something like:
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index ec30550951ec..e3c271cf1314 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3021,6 +3021,21 @@ bool get_signal(struct ksignal *ksig)
>  		 */
>  		current->flags |= PF_SIGNALED;
>  
> +		/*
> +		 * PF_USER_WORKER threads will catch and exit on fatal signals
> +		 * themselves. They have cleanup that must be performed, so we
> +		 * cannot call do_exit() on their behalf. Note that ksig won't
> +		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
> +		 *
> +		 * They must not dump core either. The dumper waits for every
> +		 * other thread in the group to exit, and a sibling's exit path
> +		 * may in turn wait for this worker's own exit, which only runs
> +		 * after get_signal() returns: io_sq_thread() ends up in
> +		 * io_wq_exit_workers() and waits there for its io-wq workers.
> +		 */
> +		if (current->flags & PF_USER_WORKER)
> +			goto out;
> +
>  		if (sig_kernel_coredump(signr)) {
>  			if (print_fatal_signals)
>  				print_fatal_signal(signr);
> @@ -3036,15 +3051,6 @@ bool get_signal(struct ksignal *ksig)
>  			vfs_coredump(&ksig->info);
>  		}
>  
> -		/*
> -		 * PF_USER_WORKER threads will catch and exit on fatal signals
> -		 * themselves. They have cleanup that must be performed, so we
> -		 * cannot call do_exit() on their behalf. Note that ksig won't
> -		 * be properly initialized, PF_USER_WORKER's shouldn't use it.
> -		 */
> -		if (current->flags & PF_USER_WORKER)
> -			goto out;
> -
>  		/*
>  		 * Death signals, no core dump.
>  		 */
> 
> Afaict the main consequence of this is for a thread-group with a bunch
> of spawned workers where the thread-group leader exits prematurely
> before all workers: any worker that takes a coredump signal via ptrace()
> shenanigans won't create a coredump anymore. I think that's entirely
> acceptable.

So to put some details on it after some research:

io-wq workers die with their owner's exit() and vhost workers with the
files table. But SQPOLL threads don't necessarily. So if a premature
thread-group leader exits then an SQPOLL thread can be left. The SQPOLL
thread pins the fdtable through CLOSE_FILES, the fdtable pins the io
ring, the rings pins the thread.

So here's how the behavior would change with my proposed patch:

|                case                |                           mainline                           |  PF_USER_WORKERS don't dump             
|────────────────────────────────────|──────────────────────────────────────────────────────────────|───────────────────────────────
| leader gone, no signal             | zombie leader + iou-sqp, not reapable, lingers until SIGKILL | same                          
|────────────────────────────────────|──────────────────────────────────────────────────────────────|───────────────────────────────
| leader gone, SIGSEGV into iou-sqp  | killed by signal 11, core written                            | exited with status 0, no core 
|────────────────────────────────────|──────────────────────────────────────────────────────────────|───────────────────────────────
| leader gone, SIGTERM into iou-sqp  | exited with status 0                                         | exited with status 0          
|────────────────────────────────────|──────────────────────────────────────────────────────────────|───────────────────────────────
| leader alive, SIGSEGV into iou-sqp | whole group killed by 11, core written                       | process survives, worker gone 
|────────────────────────────────────|──────────────────────────────────────────────────────────────|───────────────────────────────

Please note that only ptrace() can be used to inject a coredump signal
into such SQPOLL threads.

TL;DR: with PF_USER_WORKERS not being eligible from writing coredumps
any coredump signal sent to them is ignored. They just exit.

The alternative to this is akin to what Neil proposed where the coredump
signal is retargeted towards a non-PF_USER_WORKER thread.

One should note that PF_USER_WORKERs very much intentionally blog
everything apart from SIGKILL and SIGSTOP so being able to change their
signal mask via ptrace() is questionable in the first place.

In fact, the more I think about it I keep thinking we should do both:

(1) PF_USER_WORKERs can't become a dumper
(2) ptrace() should not be able to alter the signal mask for a PF_USER_WORKER

