Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C07BCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE4B6B0092; Fri, 15 May 2026 10:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60E46B0093; Fri, 15 May 2026 10:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76326B0095; Fri, 15 May 2026 10:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9EA06B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:41:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 710791C002A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:41:26 +0000 (UTC)
X-FDA: 84769917372.11.8BFE5AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D38B880008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:41:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBkIhkRY;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778856084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAajuu8X0phXGFkze3aggIGcQON9mW6/E9hX+P3sWB0=;
	b=Swl+BmR0A5Io3/vWyrRpuGQMJJIRO3K1GFVV6gFpvuIKZqlCThVIASMcMhajFEpAft0pet
	spJhyPulxhWdtiLPLRIR+6dCCW9HIVKY0IbFiQaCKqEp2C/OEPk3PCc350gY6/Z+ZYnGVA
	fZ+O52opGN0vh1dIu6e2Dwq41VQ7EFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778856084; a=rsa-sha256;
	cv=none;
	b=IIQN37LfkBzQuIV/wxk4lvdaJvSE9VwCXL7oEd3L9lx/wpWlrV7W1GfZZXuelpbKW5t48z
	XgUNnExnhtVaXxPVWRCcESRLWegEu0RMkNbT8VVIa4jbPnrNwyYC6GcwS4G93Ly/HfwVtK
	96wUNOq7Rgd9BPaLUqAITwOAF/fuApc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qBkIhkRY;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E5356013B;
	Fri, 15 May 2026 14:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61D4C2BCB0;
	Fri, 15 May 2026 14:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778856083;
	bh=0ThaVHfcsXsrnQk3UJRVKAlaBgphjzydv6mbFbEaXxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qBkIhkRYXXHG/tx0ZX1wao6QXDEvkdtkTPNXxwBdL6C2kSyStXGj/Jz9FxdumZ7Sb
	 /G6rE4Z70+IVBG/DkMYS0rGlMThHEhaSvQLbyFHVAMrQ/0sTc+r1viUj/k8MxWqV6u
	 jvFjSAFSZbQ8/YVE3BEOYlWOl3vnLcz/BCrREXVuvDo/+VUMbYxcupo8dbMdKoj9ue
	 EKN7axKhsdYO9tc5iLq7vRAycwBYxXakrPGiWi9+KtdLH956utddFdIKSFPjduzfSK
	 bOY3wTYukcGJAnx+EBpzVe/2mLaLdESxNclvDA7B/FH7IwSjzLAIFxQblCAZfEyQX6
	 2I77Kznp9GzQg==
Date: Fri, 15 May 2026 16:41:18 +0200
From: Christian Brauner <brauner@kernel.org>
To: Minchan Kim <minchan@kernel.org>, Jann Horn <jannh@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, 
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
References: <20260511214226.937793-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260511214226.937793-1-minchan@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D38B880008
X-Stat-Signature: s1r797c3etqkobozyp4sictmf6w9g7hc
X-Rspam-User: 
X-HE-Tag: 1778856084-743079
X-HE-Meta: U2FsdGVkX19lPE9WJaJheHTZMJLsKjnIm1vgS080RQNwUNDBSiGRvjpz4CMUaD+gX3EPT+/kOwOYejr7pkkPLBY7UZnMHdcQYykR0lN9xTEa1kxLFMZBXXSGaxHTGJYeRHhElFKUWaaNZdslKf4s8d00+wMUkThoKzh7bdPYNkiGKUGdW5Zebze1kfQ1lu/y3ku25h+LAutrWOxTa0V8OeqgwaM8wfmx14hRIXFN9i/HuQ9OkFq/uSgofXgi3GGvi/RLqizVsnOyNeU9NiiVRgk1qsn5jzfyy33ekBXs6vcM10Pu2K6h0pmkkDszOlR31QL82JqwCTypbC8PNTAJgSlev1l5+luVygFSrIG3XucGxjlUBXNBnHMXtxFxk9R7imFYv3lGVvisKmvoO09kF0tpo553EwK8Qhd9pwW8nhmAW1KbzgqY+tYPCc+elKVI+YqMcg0Qu+2adBRXsUxPE75gP4qx/7dNqAAZOOyPuBh2mvbs2k1VM/lWlc7olAy6+pgBWzbE73e1hRT8h1OGnyF611gfFRZwsqGTRk/g1e4YH3lR9vapbxBTvYsWL+FzunpFgyWMN/a9C7WglQ3+Cy3ub7kylp5XgHMeGoGCDAE+T2cy9hp6h8ztrg8wpDyYYVjFJf3CZSGWUNgLvGPpkEEu0Y2ybXzYPOz8sRLTLZTsDUlnhx0yNfv/LWwsVVkht4K/gpDMlHWjch+nJKkkUogzYTRRjXVtq2f/uAtfOQMgLyVpI0S745XH0KAq3H1iCjYpTJeLGVoJkgUAZzk0nyVWMR+5Xw2Rz2G8zw1ynflhxjYGRI8Y5jFyfcFjK2fezR/URFztd2EYIxnGu+d2GlVaWsgor3sICXK+bezCT2ptz8DWGB0glkV1SBG1nCBjol3bWZoPiYXInx0AbGr6DVcKexAR8WEjmfVZKoHvTcDe75+XRWhtN1MdMlVe2PS7PScoLdgcsTDBcQakoz9
 PEs1SAx/
 d9MN48jFDrR/1QP5ACYFSntPxNzvY4kFyAY/Zh47gfKd0Jxk+cdkaCTZ+QyiFIDXaoMBbYXfE2UF2s5SxTz4wrpXU3bcgHnH7+Fbx8ltfrV+f4rGG6kS5u42cjLt0iVwv4Umkc6+jPybhKs+JdwV/AYJ4qQ4rsdvWmsO/Mqvjz6+wiOUVFo2ztLZAej7+AsMd6e7sf6v2g49CjtFCh/RxBNIu6yuVetfY3uIoTFjUnlGXLk7zXdqsgR2zNeTSQJlIjN5+KHy9elJGwgy5Elf/Y6cn4vqng4rdNUPMKkJTHv4Bg8+GDGcin6E0WWB/yix/J0/muhZ6nbadoREWH464YjkjoazfemukeICT6wQCekzYsjAILB3Y8BkLRg69KAIAVTSIGiz4kWOQ4oxDtE7XozbIhKms8CTDG6Xzecym1CpiMZgzBo4KZCW0cH05OSMyfFtuCi9MDZ4WuY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 02:42:26PM -0700, Minchan Kim wrote:
> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to invocation. This separation introduces a scheduling race window
> where the victim task may receive the signal and enter the exit path
> before the reaper can invoke process_mrelease().
> 
> When the victim enters the exit path (do_exit -> exit_mm), it clears its
> task->mm immediately. This causes process_mrelease() to fail with -ESRCH,

To be quite frank about the patch as written below: I think this is a
completely crazy api. And I really dislike it.

Right now we have clear and simple signal sending semantics for pidfds:

* thread-specific pidfd -> thread-directed signal (unless signal is thread-group scoped by default)
* thread-group pidfd -> thread-group directed signal

with specific overrides for pidfd_send_signal():

* PIDFD_SIGNAL_THREAD           -> only signal thread
* PIDFD_SIGNAL_THREAD_GROUP     -> signal thread-group
* PIDFD_SIGNAL_PROCESS_GROUP    -> signal process-group

And now this patch aims to elevate process_mrelease() to a _signal
sending function_. And the semantics are complete special sauce too.

You are effectively introducing a custom signal scope that is mm-based
and then also plumbing it into a completely unrelated function that
should have absolutely nothing to do with this.

This is such Zebroid API. I really would hate to see it land.

This came up because of the ptrace bug that was just recently discovered
and that Linus fixed yesterday. This is another instance where I think
the correct fix is to keep task->mm around until the process is reaped
and then you can throw away all of the really ugly semantic in this
patch afaict. I'd really like to see that merged as it would also clean
up the ptrace code:

https://lore.kernel.org/all/20201016024019.1882062-1-jannh@google.com

> leaving the actual address space teardown (exit_mmap) to be deferred until
> the mm's reference count drops to zero. In the field (e.g., Android),
> arbitrary reference counts (reading /proc/<pid>/cmdline, or various other
> remote VM accesses) frequently delay this teardown indefinitely,
> defeating the purpose of expedited reclamation.
> 
> In Android's LMKD scenarios, this delay keeps memory pressure high, forcing
> the system to unnecessarily kill additional innocent background apps before
> the memory from the first victim is recovered.
> 
> This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> an integrated auto-kill mode. When specified, process_mrelease() directly
> injects a SIGKILL into the target task after finding its mm.
> 
> To solve the race condition, we grab the mm reference via mmgrab() before
> sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we assume
> it will free its memory and proceed with reaping, making the logic as simple
> as reap = reap_kill || task_will_free_mem(p).
> 
> To handle shared address spaces, we deliver SIGKILL to all processes sharing
> the same address space using do_pidfd_send_signal_pidns(). This ensures the
> target pid resides inside the caller's PID namespace hierarchy prior to
> signal delivery. We iterate over all processes sharing the mm and deliver
> SIGKILL to each. If delivering the signal to any of the sharing processes
> fails, we return an error. Note that this approach may leave partial
> side-effects if some processes are killed successfully before a failure occurs.
> 
> Cc: Christian Brauner <brauner@kernel.org>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  include/linux/signal.h    |  4 +++
>  include/uapi/linux/mman.h |  4 +++
>  kernel/signal.c           | 29 ++++++++++++++++++---
>  mm/oom_kill.c             | 55 ++++++++++++++++++++++++++++++++++-----
>  4 files changed, 81 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/signal.h b/include/linux/signal.h
> index f19816832f05..bdbe6b3addec 100644
> --- a/include/linux/signal.h
> +++ b/include/linux/signal.h
> @@ -276,6 +276,8 @@ static inline int valid_signal(unsigned long sig)
>  
>  struct timespec;
>  struct pt_regs;
> +struct mm_struct;
> +struct pid;
>  enum pid_type;
>  
>  extern int next_signal(struct sigpending *pending, sigset_t *mask);
> @@ -283,6 +285,8 @@ extern int do_send_sig_info(int sig, struct kernel_siginfo *info,
>  				struct task_struct *p, enum pid_type type);
>  extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
>  			       struct task_struct *p, enum pid_type type);
> +extern int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
> +				      siginfo_t __user *info, unsigned int flags);
>  extern int send_signal_locked(int sig, struct kernel_siginfo *info,
>  			      struct task_struct *p, enum pid_type type);
>  extern int sigprocmask(int, sigset_t *, sigset_t *);
> diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> index e89d00528f2f..4266976b45ad 100644
> --- a/include/uapi/linux/mman.h
> +++ b/include/uapi/linux/mman.h
> @@ -56,4 +56,8 @@ struct cachestat {
>  	__u64 nr_recently_evicted;
>  };
>  
> +/* Flags for process_mrelease */
> +#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
> +#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
> +
>  #endif /* _UAPI_LINUX_MMAN_H */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index d65d0fe24bfb..b2dc08a9bdd3 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -4046,6 +4046,30 @@ static int do_pidfd_send_signal(struct pid *pid, int sig, enum pid_type type,
>  	return kill_pid_info_type(sig, &kinfo, pid, type);
>  }
>  
> +/**
> + * do_pidfd_send_signal_pidns - Send a signal to a process via its struct pid
> + *                              while validating PID namespace hierarchy.
> + * @pid:   the struct pid of the target process
> + * @sig:   signal to send
> + * @type:  scope of the signal (e.g. PIDTYPE_TGID)
> + * @info:  signal info payload
> + * @flags: signaling flags
> + *
> + * Verify that the target pid resides inside the caller's PID namespace
> + * hierarchy prior to signal delivery.
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type type,
> +			       siginfo_t __user *info, unsigned int flags)
> +{
> +	/* Enforce PID namespace hierarchy boundary */
> +	if (!access_pidfd_pidns(pid))
> +		return -EINVAL;
> +
> +	return do_pidfd_send_signal(pid, sig, type, info, flags);
> +}
> +
>  /**
>   * sys_pidfd_send_signal - Signal a process through a pidfd
>   * @pidfd:  file descriptor of the process
> @@ -4094,16 +4118,13 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
>  		if (IS_ERR(pid))
>  			return PTR_ERR(pid);
>  
> -		if (!access_pidfd_pidns(pid))
> -			return -EINVAL;
> -
>  		/* Infer scope from the type of pidfd. */
>  		if (fd_file(f)->f_flags & PIDFD_THREAD)
>  			type = PIDTYPE_PID;
>  		else
>  			type = PIDTYPE_TGID;
>  
> -		return do_pidfd_send_signal(pid, sig, type, info, flags);
> +		return do_pidfd_send_signal_pidns(pid, sig, type, info, flags);
>  	}
>  	}
>  
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..253aa80770f2 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -20,6 +20,7 @@
>  
>  #include <linux/oom.h>
>  #include <linux/mm.h>
> +#include <uapi/linux/mman.h>
>  #include <linux/err.h>
>  #include <linux/gfp.h>
>  #include <linux/sched.h>
> @@ -925,6 +926,39 @@ static bool task_will_free_mem(struct task_struct *task)
>  	return ret;
>  }
>  
> +/*
> + * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
> + * @victim: the targeted OOM process group leader
> + * @mm:     the virtual memory space being reaped
> + *
> + * Traverse all threads globally and signal any user processes sharing the identical
> + * mm footprints, ensuring no concurrent users pin the memory. Skips the system
> + * global init and kernel worker threads.
> + */
> +static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
> +{
> +	struct task_struct *p;
> +	bool failed = false;
> +
> +	rcu_read_lock();
> +	for_each_process(p) {
> +		if (!process_shares_mm(p, mm))
> +			continue;
> +		if (is_global_init(p)) {

You can't signal init in any shape or form any way. Why bother reporting
failure at all.

> +			failed = true;
> +			continue;
> +		}
> +		if (unlikely(p->flags & PF_KTHREAD))
> +			continue;
> +
> +		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
> +			failed = true;
> +	}
> +	rcu_read_unlock();
> +
> +	return failed ? -EBUSY : 0;

Why are you returning EBUSY? This makes no sense imho.

> +}
> +
>  static void __oom_kill_process(struct task_struct *victim, const char *message)
>  {
>  	struct task_struct *p;
> @@ -1217,9 +1251,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	unsigned int f_flags;
>  	bool reap = false;
>  	long ret = 0;
> +	bool reap_kill;
>  
> -	if (flags)
> +	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
>  		return -EINVAL;
> +	reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
>  
>  	task = pidfd_get_task(pidfd, &f_flags);
>  	if (IS_ERR(task))
> @@ -1236,19 +1272,24 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	}
>  
>  	mm = p->mm;
> -	mmgrab(mm);
>  
> -	if (task_will_free_mem(p))
> -		reap = true;
> -	else {
> +	reap = reap_kill || task_will_free_mem(p);
> +	if (!reap) {
>  		/* Error only if the work has not been done already */
>  		if (!mm_flags_test(MMF_OOM_SKIP, mm))
>  			ret = -EINVAL;
> +		task_unlock(p);
> +		goto put_task;
>  	}
> +
> +	mmgrab(mm);
>  	task_unlock(p);
>  
> -	if (!reap)
> -		goto drop_mm;
> +	if (reap_kill) {
> +		ret = kill_all_shared_mm(task, mm);
> +		if (ret)
> +			goto drop_mm;
> +	}
>  
>  	if (mmap_read_lock_killable(mm)) {
>  		ret = -EINTR;
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 
> 

