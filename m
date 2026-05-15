Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46142CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 20:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E396B0005; Fri, 15 May 2026 16:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EC96B008A; Fri, 15 May 2026 16:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DB36B008C; Fri, 15 May 2026 16:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE4C6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:52:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C76808BAD4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:52:44 +0000 (UTC)
X-FDA: 84770853048.06.2EA65DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 368CB40007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:52:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpmVlAMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778878363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Djv4e6Xplu1PyepsLj7qbZUGQoR+TpAURn03wVW+vhY=;
	b=Qek1H3DXrXEAmuCdhngPkVZdJgf7lTo93kNdZQDg4oX9KxKt/Wt+V0xmATdYHMYMTuDqqf
	AgogtysagSl62zh+/TMlotnC2YyZhYPhf/8DOS6j3pi/vLW5H2kzV4eVuD6lDCIQQaoV6v
	TOV3B9ESHIBeYTwQyR0BnpUEUq4Wvs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778878363; a=rsa-sha256;
	cv=none;
	b=mHDJnyYHxOgNuXKduZpttsVmTiimsYR/F3eBwXBC6pgDHgDRXvxy5N+rcCF00BhVVAGzoE
	R51rd9b6B/MvS4GmuABSnDOIOJpZZLGI3av6l5RRI5i6aryiKmJROov6CIMN7tAcjcRAzb
	XEAN19I2tQMV9FQGiwNgSOv8gT2VrMM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpmVlAMQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8191F601DF;
	Fri, 15 May 2026 20:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9FEC2BCB0;
	Fri, 15 May 2026 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778878362;
	bh=k2L1X5wmfaJTfYccSe1oeRjdS8+g4LrLFB3drvRjVAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SpmVlAMQsenNFryEZGvkmUsYvajcCxB+UXSgXy7PomyUJAmaxY2qvcQpNuQGNBuo+
	 rKvvWnkzc0qtUC6cZFTH6wULPH0+xpBt8UUUeN4Z8Tf/E46x1ZuN9cNz1yBMlJowTQ
	 yia5uzJvauumibe0UxMyy3VwfVcONTffh4sTBTe03ZW/2smt7kmEM6mdHIkRq+TCaS
	 bbTi459OKk41infK3HC50SQmQPqpkXTW9GShLNPxJ9p+u0SaetHekAT4daUwNI86qK
	 BkyrEar0LDJp2i7SoQ8IUE0XIAi4rWYiK6Chrk9rAj7xenkVhHUwMdN5nY5SRfWoWT
	 O38nq5eEfYWcw==
Date: Fri, 15 May 2026 13:52:40 -0700
From: Minchan Kim <minchan@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <ageHmE1QIzK4R3nO@google.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
X-Rspam-User: 
X-Rspamd-Queue-Id: 368CB40007
X-Rspamd-Server: rspam04
X-Stat-Signature: gikixquxdbwdaj54qgg3dwgxzkmmjgp5
X-HE-Tag: 1778878363-153916
X-HE-Meta: U2FsdGVkX18aty5cMVIThJXVb6sSW/nRLOAkkoAqzyQxt0Ls9RiUBEyS19QpDlWSmyImhvPySw4ZCX1MhpuTbipLH1QiDPxu3CANc5uZYK4i/akUMCbbcTTS44kd+rVHBNa7mths/qntNlT+pAgcbG9NRSkVBfEDBbs8bzlB0emtDhuaglz1mC9xkjI3Nrjn5zNH2I/jSYrl89aVqxtdPbcjYpxkTw1EYYXG3RNkquyZ5iYcrJl2pO55gSiowkr8q2wfNOBKimUSPecgXJWapkxhNZqwdQ9V1qMPVLZjud7oA6FGv/TgQRLirPBZZFXm0RxUqHp802kHmNw+Lc3oPMuqTcQ65XR08nFQ6SHTgDh0EZloLcbw0UE9mlfHJt5oFOk+1gQsq36NNyAf4X1T2WOvx8sq4BIAgS2g0wBo9MurCFDzS3Z2LjVAc9MFDy5aPKW1SnkiPue+jzFhmk5HH5rXVBEfwY3UjsVU31L0K6o4wwXTwCI7sX+ghVICvnLDAHSHBA4Yx7aCszOCF4Fd6iyxz6rZru2W3MQrb1QKb1RQtqAzfNZySIfOPOBlxaJz/MujBddBIcpaZMBzSuvQm+4SfNdOAuJjhyXQJ3n2cGRLzsHd/Le87hSfwZA4zpx2iE+5byhsJHA40uoAS6+izgay/HBPfwkV1+fscbW3vn2e7gGGxQUMxmHB4YhKVLLdAEFoxn7AJjHXfRDBqo2Uqy1Tiz4rhN1dwWF065T02bMgW4zg0ZQAer66u+ghKmr/FK1liXfj3p1oj8q+97SKfJcwx0ccu7vL4JOqkwX5NwRscp4bRYD+n3vePFsWcAVEI5a2rhistp8fBiZ5sDOZ6ac9zIWijEEmJtFEPwcwK+miNuKHQDX4z6elv1RHFZjH+Z/apJDfsSruiz5p/Oe5j9dXODnjpCXW4IaYqjax6bkiRvS8Z4DRGA1mIrgOKIcSHj3RX4taMUaNrHEKDcD
 nNZhnvmC
 76/r7eyoPsXLqV+hJccPu2OSYeVvcLl4mfD+A7RujWVwJFeQVMPDATaU3ZQdVC7wseAMSuxomN1ayf+uPk2sLSwTkzLnnsrjVmIwNXIoR8T+gyOmTfh9OFfHeSOOzpx/W94+JwVWx6Webz8d0HU2b3ruS9n9zrIbkTfOglgc+QEmU97vXzreBoHSQJt9rxCe81MT/DgNPKnk3k4bm3BOPjT6xLGOy0UG+wLACRKuEyV3l5Ig+om7W2rkmkhrBwsMIn5B3FxShRI9Mw2Rf1a3xFcwqlnai1pr5cEeHZZthOJo4GiSW95BJrRIqgZWDJHoEqiX9BWd29wzs5Knft7EOiJDGOViYixGN3ChJEQEEmajUN9Uy1ZXxbI4M4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 04:41:18PM +0200, Christian Brauner wrote:
> On Mon, May 11, 2026 at 02:42:26PM -0700, Minchan Kim wrote:
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to invocation. This separation introduces a scheduling race window
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> > 
> > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> 
> To be quite frank about the patch as written below: I think this is a
> completely crazy api. And I really dislike it.
> 
> Right now we have clear and simple signal sending semantics for pidfds:
> 
> * thread-specific pidfd -> thread-directed signal (unless signal is thread-group scoped by default)
> * thread-group pidfd -> thread-group directed signal
> 
> with specific overrides for pidfd_send_signal():
> 
> * PIDFD_SIGNAL_THREAD           -> only signal thread
> * PIDFD_SIGNAL_THREAD_GROUP     -> signal thread-group
> * PIDFD_SIGNAL_PROCESS_GROUP    -> signal process-group
> 
> And now this patch aims to elevate process_mrelease() to a _signal
> sending function_. And the semantics are complete special sauce too.
> 
> You are effectively introducing a custom signal scope that is mm-based
> and then also plumbing it into a completely unrelated function that
> should have absolutely nothing to do with this.
> 
> This is such Zebroid API. I really would hate to see it land.
> 
> This came up because of the ptrace bug that was just recently discovered
> and that Linus fixed yesterday. This is another instance where I think
> the correct fix is to keep task->mm around until the process is reaped
> and then you can throw away all of the really ugly semantic in this
> patch afaict. I'd really like to see that merged as it would also clean
> up the ptrace code:
> 
> https://lore.kernel.org/all/20201016024019.1882062-1-jannh@google.com

Thank you for pointing this out. I completely agree.

The only reason for adding PROCESS_MRELEASE_REAP_KILL and its complex signaling
was to work around task->mm being cleared early in exit_mm(), which causes
process_mrelease() to fail with -ESRCH.

If Jann's patch to keep task->mm around is merged, this race naturally vanishes.
Userspace can reliably send SIGKILL and call the normal process_mrelease()
with the exit_mm

I would be thrilled to see Jann's patch merged. It allows us to drop this
complex REAP_KILL patch entirely while still fully resolving the expedited
reclaim issue.

> 
> > leaving the actual address space teardown (exit_mmap) to be deferred until
> > the mm's reference count drops to zero. In the field (e.g., Android),
> > arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> > remote VM accesses) frequently delay this teardown indefinitely,
> > defeating the purpose of expedited reclamation.
> > 
> > In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
> > the system to unnecessarily kill additional innocent background apps before
> > the memory from the first victim is recovered.
> > 
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > an integrated auto-kill mode. When specified, process_mrelease() directly
> > injects a SIGKILL into the target task after finding its mm.
> > 
> > To solve the race condition, we grab the mm reference via mmgrab() before
> > sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
> > it will free its memory and proceed with reaping, making the logic as simple
> > as reap = reap_kill || task_will_free_mem(p).
> > 
> > To handle shared address spaces, we deliver SIGKILL to all processes sharing
> > the same address space using do_pidfd_send_signal_pidns(). This ensures the
> > target pid resides inside the caller's PID namespace hierarchy prior to
> > signal delivery. We iterate over all processes sharing the mm and deliver
> > SIGKILL to each. If delivering the signal to any of the sharing processes
> > fails, we return an error. Note that this approach may leave partial
> > side-effects if some processes are killed successfully before a failure occurs.
> > 
> > Cc: Christian Brauner <brauner@kernel.org>
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  include/linux/signal.h    |  4 +++
> >  include/uapi/linux/mman.h |  4 +++
> >  kernel/signal.c           | 29 ++++++++++++++++++---
> >  mm/oom_kill.c             | 55 ++++++++++++++++++++++++++++++++++-----
> >  4 files changed, 81 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/signal.h b/include/linux/signal.h
> > index f19816832f05..bdbe6b3addec 100644
> > --- a/include/linux/signal.h
> > +++ b/include/linux/signal.h
> > @@ -276,6 +276,8 @@ static inline int valid_signal(unsigned long sig)
> >  
> >  struct timespec;
> >  struct pt_regs;
> > +struct mm_struct;
> > +struct pid;
> >  enum pid_type;
> >  
> >  extern int next_signal(struct sigpending *pending, sigset_t *mask);
> > @@ -283,6 +285,8 @@ extern int do_send_sig_info(int sig, struct kernel_siginfo *info,
> >  				struct task_struct *p, enum pid_type type);
> >  extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
> >  			       struct task_struct *p, enum pid_type type);
> > +extern int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
> > +				      siginfo_t __user *info, unsigned int flags);
> >  extern int send_signal_locked(int sig, struct kernel_siginfo *info,
> >  			      struct task_struct *p, enum pid_type type);
> >  extern int sigprocmask(int, sigset_t *, sigset_t *);
> > diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> > index e89d00528f2f..4266976b45ad 100644
> > --- a/include/uapi/linux/mman.h
> > +++ b/include/uapi/linux/mman.h
> > @@ -56,4 +56,8 @@ struct cachestat {
> >  	__u64 nr_recently_evicted;
> >  };
> >  
> > +/* Flags for process_mrelease */
> > +#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
> > +#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
> > +
> >  #endif /* _UAPI_LINUX_MMAN_H */
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index d65d0fe24bfb..b2dc08a9bdd3 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -4046,6 +4046,30 @@ static int do_pidfd_send_signal(struct pid *pid, int sig, enum pid_type type,
> >  	return kill_pid_info_type(sig, &kinfo, pid, type);
> >  }
> >  
> > +/**
> > + * do_pidfd_send_signal_pidns - Send a signal to a process via its struct pid
> > + *                              while validating PID namespace hierarchy.
> > + * @pid:   the struct pid of the target process
> > + * @sig:   signal to send
> > + * @type:  scope of the signal (e.g. PIDTYPE_TGID)
> > + * @info:  signal info payload
> > + * @flags: signaling flags
> > + *
> > + * Verify that the target pid resides inside the caller's PID namespace
> > + * hierarchy prior to signal delivery.
> > + *
> > + * Return: 0 on success, negative errno on failure.
> > + */
> > +int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
> > +			       siginfo_t __user *info, unsigned int flags)
> > +{
> > +	/* Enforce PID namespace hierarchy boundary */
> > +	if (!access_pidfd_pidns(pid))
> > +		return -EINVAL;
> > +
> > +	return do_pidfd_send_signal(pid, sig, type, info, flags);
> > +}
> > +
> >  /**
> >   * sys_pidfd_send_signal - Signal a process through a pidfd
> >   * @pidfd:  file descriptor of the process
> > @@ -4094,16 +4118,13 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
> >  		if (IS_ERR(pid))
> >  			return PTR_ERR(pid);
> >  
> > -		if (!access_pidfd_pidns(pid))
> > -			return -EINVAL;
> > -
> >  		/* Infer scope from the type of pidfd. */
> >  		if (fd_file(f)->f_flags & PIDFD_THREAD)
> >  			type = PIDTYPE_PID;
> >  		else
> >  			type = PIDTYPE_TGID;
> >  
> > -		return do_pidfd_send_signal(pid, sig, type, info, flags);
> > +		return do_pidfd_send_signal_pidns(pid, sig, type, info, flags);
> >  	}
> >  	}
> >  
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 5c6c95c169ee..253aa80770f2 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -20,6 +20,7 @@
> >  
> >  #include <linux/oom.h>
> >  #include <linux/mm.h>
> > +#include <uapi/linux/mman.h>
> >  #include <linux/err.h>
> >  #include <linux/gfp.h>
> >  #include <linux/sched.h>
> > @@ -925,6 +926,39 @@ static bool task_will_free_mem(struct task_struct *task)
> >  	return ret;
> >  }
> >  
> > +/*
> > + * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
> > + * @victim: the targeted OOM process group leader
> > + * @mm:     the virtual memory space being reaped
> > + *
> > + * Traverse all threads globally and signal any user processes sharing the identical
> > + * mm footprints, ensuring no concurrent users pin the memory. Skips the system
> > + * global init and kernel worker threads.
> > + */
> > +static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
> > +{
> > +	struct task_struct *p;
> > +	bool failed = false;
> > +
> > +	rcu_read_lock();
> > +	for_each_process(p) {
> > +		if (!process_shares_mm(p, mm))
> > +			continue;
> > +		if (is_global_init(p)) {
> 
> You can't signal init in any shape or form any way. Why bother reporting
> failure at all.
> 
> > +			failed = true;
> > +			continue;
> > +		}
> > +		if (unlikely(p->flags & PF_KTHREAD))
> > +			continue;
> > +
> > +		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
> > +			failed = true;
> > +	}
> > +	rcu_read_unlock();
> > +
> > +	return failed ? -EBUSY : 0;
> 
> Why are you returning EBUSY? This makes no sense imho.
> 
> > +}
> > +
> >  static void __oom_kill_process(struct task_struct *victim, const char *message)
> >  {
> >  	struct task_struct *p;
> > @@ -1217,9 +1251,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	unsigned int f_flags;
> >  	bool reap = false;
> >  	long ret = 0;
> > +	bool reap_kill;
> >  
> > -	if (flags)
> > +	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
> >  		return -EINVAL;
> > +	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
> >  
> >  	task = pidfd_get_task(pidfd, &f_flags);
> >  	if (IS_ERR(task))
> > @@ -1236,19 +1272,24 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	}
> >  
> >  	mm = p->mm;
> > -	mmgrab(mm);
> >  
> > -	if (task_will_free_mem(p))
> > -		reap = true;
> > -	else {
> > +	reap = reap_kill || task_will_free_mem(p);
> > +	if (!reap) {
> >  		/* Error only if the work has not been done already */
> >  		if (!mm_flags_test(MMF_OOM_SKIP, mm))
> >  			ret = -EINVAL;
> > +		task_unlock(p);
> > +		goto put_task;
> >  	}
> > +
> > +	mmgrab(mm);
> >  	task_unlock(p);
> >  
> > -	if (!reap)
> > -		goto drop_mm;
> > +	if (reap_kill) {
> > +		ret = kill_all_shared_mm(task, mm);
> > +		if (ret)
> > +			goto drop_mm;
> > +	}
> >  
> >  	if (mmap_read_lock_killable(mm)) {
> >  		ret = -EINTR;
> > -- 
> > 2.54.0.563.g4f69b47b94-goog
> > 
> > 

