Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D326CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 12:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F1E80041; Mon, 27 Oct 2025 08:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9098000A; Mon, 27 Oct 2025 08:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B728080041; Mon, 27 Oct 2025 08:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4C48000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:07:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B9BE1405C3
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:07:23 +0000 (UTC)
X-FDA: 84043769166.03.91BE100
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43DFC40004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:07:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hb6PTjvS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761566841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2s7I9GGNFgDr0lnQJQktZOYPEn4uNejSSlno1ll/NY=;
	b=X5ul18IpAEElzvxsqeqI6NRoE9u08alxu4O1SeUyT0TBUsdRFg2lvxUgWy8fvjm7a9NZQu
	SWe655O2+6wudoqX6FEB1+fxud/nvBBt9lKi6Qe17tdvl39vj6xW3jMu42Z30J4+x76F5F
	7aFVQ2GAfPDRZ20Ya/6iqcKLhgBXyns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761566841; a=rsa-sha256;
	cv=none;
	b=ZW1cY0Cv1NK7Ci0g7RZ7VHko4cBlr7s1bkYFHuExR2CO32gXnuIiAQqaA5hxufoFlc60Ux
	0Kbt/I6MKZsRoD9SlLS2wM2yXvKKAAr0iwHfPOhtt8fJIGj2XbIejSUo/phVMTKVEnA49w
	hZ4TMRLarbALNct7QkhbbzWDTTOgeKQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hb6PTjvS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b2s7I9GGNFgDr0lnQJQktZOYPEn4uNejSSlno1ll/NY=; b=hb6PTjvSbMA9+G4lC2NiF1ZBDT
	Biypbx9f4KRwKfRjvvbTeuCBlL/6UI+l7PXTUHa6HorJDZATV9WLcs1AdTwW2T9NLGQhTBXsQ9lWE
	vebcdTT5Va4Tpvbu6hBXh08MYgxmALoDt0txgWBcgRo4eutibhhhk64u/VpxKYfmHIvP25H/Tde3R
	ZW2KLw2olrWKhcaf4Mdp2j6kb3KXABl1K/oASwrdPiOratiNJEHTA/h6QVerWdAfTRIzvN8OBAgyT
	kUq/p2AUh6a7Gdjj4abD6xS52EX/+Wg1LM3dOBh8CErHcKBx6xGaFpqHAHpGmstGdpVZiBG9ouyHI
	rBIQRbjg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDM01-00000000V71-0Wvw;
	Mon, 27 Oct 2025 12:06:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D27E6300220; Mon, 27 Oct 2025 13:06:57 +0100 (CET)
Date: Mon, 27 Oct 2025 13:06:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <20251027120657.GW4067720@noisy.programming.kicks-ass.net>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Rspamd-Server: rspam01
X-Stat-Signature: ohro5jq8m11qbfawesmxf3zryu5br6su
X-Rspam-User: 
X-Rspamd-Queue-Id: 43DFC40004
X-HE-Tag: 1761566840-962158
X-HE-Meta: U2FsdGVkX1/WS+74AEPTnAaPEhmtcD3yxcC3MhC/25kBbM2OeBqfIFbz7k8ecat17I2Logf4t9TYN2XzgjYr3PBmMa61nerREgxNsooa54RPFvxf/QEwVDyA5qqdmgNCU61oa8kn9+eelE69EGqo/tPRxNVeBtNhN8oyeQryJ1m7Q26Ts33C3z5wPh8Vsyo0aLmPPlnq9wRIa7uHbcqEk0AXX1yMeu982fr4J98L++1p4IXGQ93kqR/PDQYcbEXwiCKzykTRiGxHZIF4QfbCvx/i5R71ax7+5OovBhQpDA8Mi2EWxhy0mYaC3lQpBCVlL11lumStkMA7fuBW6MZIyVv2tRz5MKphlNWrEy4gV0mTKYbShd4ln435+Bpj5C6yKgzbBaMWigJrvxaYIODIQ4kF2Rx3TVRWv6g55+7pZiErXDR78IBdGNvAl2xC27uLnS8t2y8G8d5kowfWTD2a3hIA55q5UMleLOzHbsGrMMwbqq5regb7RlAScuG+Kvx0eUPjfDh1um/nIrbGKs6mBY5FXa4eTF9NEIXCD3d6IMfxnsZXgq6uCqSqc5z0hdvU5E0Eg2iYfeBYXw9vsddQO1MottnR/ObmISxPybfYoHSg/dXUrAAGCBL04foSR7hjELAgqgd257ddjOh94n/Ew+YTAvs3ng78OpGbB/YX1UqicHRhMW/J/ynWMEwtYv/wsa8IrMJOxljt1R1yZ6gVuOP6UOxdL98N1Ym3H9bC/EGo6RIc7O6RnRhUIMxVeEchYxrh8K0i7SfZeZNz8oWuv+anDsNRrPem5MA93g1Tj4dcX6CkdGP9wemWRLAWOSpeMsMJIN4mRxze4dA6nYXSHAyrFJhxIqgpyQeFkY6oIBc8y8uBvyK9QWUseHEmxFEpdwoVK/QETCVYKO/9Ny/UcwIdaodNaFjqRFvMuP/+UTRNqPnVTejLGBOQJjA6ZGCFvC8oieKHMUPLewHbLL1
 kt00WoUH
 MBMbyc4NgIlL52Qo10ozBf4fn4APRx6N33bLff0OX9TGmKCC4jKzBFpZ5SJcxvc8rXvKuriZ4M2QiIUPxdYE1+CydBqbj+1V84yv/ApZAsxqCj7Ajfl1i11tV35MrMu3SHYu89Eam/xjMm2pwaBgGqKbgb+6yJUkxT+sxNoHc4SorJMGX31DNSrtk3Aqy+P/NHtzPf9O8Vrk8kd9oypxSCA0hpo+l1Q7yROnI8nTBN/7/zNtjsFLTpLU8IndpQzaKWIHzwOfOsTax5avQI3UdD0Ldr0Bl7BlvjtCIYP7/ONVVM0ddFYedwKUX/pSQCKz5iSYVK/Tbf/fBreh4Zfq6IqIf0nhxMFQzSfczyKw1639Q4l0g0+c7bK2+gDq+2Zy+DjnrKkHp8UOb09dg9BnF8HXEqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 07:34:58PM +0200, Bernd Edlinger wrote:

> The solution is to detect this situation and allow
> ptrace_attach to continue by temporarily releasing the
> cred_guard_mutex, while de_thread() is still waiting for
> traced zombies to be eventually released by the tracer.
> In the case of the thread group leader we only have to wait
> for the thread to become a zombie, which may also need
> co-operation from the tracer due to PTRACE_O_TRACEEXIT.
> 
> When a tracer wants to ptrace_attach a task that already
> is in execve, we simply retry the ptrace_may_access
> check while temporarily installing the new credentials
> and dumpability which are about to be used after execve
> completes.  If the ptrace_attach happens on a thread that
> is a sibling-thread of the thread doing execve, it is
> sufficient to check against the old credentials, as this
> thread will be waited for, before the new credentials are
> installed.
> 
> Other threads die quickly since the cred_guard_mutex is
> released, but a deadly signal is already pending.  In case
> the mutex_lock_killable misses the signal, the non-zero
> current->signal->exec_bprm makes sure they release the
> mutex immediately and return with -ERESTARTNOINTR.



> diff --git a/fs/exec.c b/fs/exec.c
> index 2a1e5e4042a1..31c6ceaa5f69 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -905,11 +905,13 @@ static int exec_mmap(struct mm_struct *mm)
>  	return 0;
>  }
>  
> -static int de_thread(struct task_struct *tsk)
> +static int de_thread(struct task_struct *tsk, struct linux_binprm *bprm)
>  {
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
>  	spinlock_t *lock = &oldsighand->siglock;
> +	struct task_struct *t;
> +	bool unsafe_execve_in_progress = false;
>  
>  	if (thread_group_empty(tsk))
>  		goto no_thread_group;
> @@ -932,6 +934,19 @@ static int de_thread(struct task_struct *tsk)
>  	if (!thread_group_leader(tsk))
>  		sig->notify_count--;
>  
> +	for_other_threads(tsk, t) {
> +		if (unlikely(t->ptrace)
> +		    && (t != tsk->group_leader || !t->exit_state))

&& goes at the end of the previous line

> +			unsafe_execve_in_progress = true;
> +	}
> +
> +	if (unlikely(unsafe_execve_in_progress)) {
> +		spin_unlock_irq(lock);
> +		sig->exec_bprm = bprm;
> +		mutex_unlock(&sig->cred_guard_mutex);
> +		spin_lock_irq(lock);

I'm not clear why we need to drop and re-acquire siglock here.

And I would like a very large comment here explaining why it is safe to
drop cred_guard_mutex here.

> +	}
> +
>  	while (sig->notify_count) {
>  		__set_current_state(TASK_KILLABLE);
>  		spin_unlock_irq(lock);
> @@ -1021,6 +1036,11 @@ static int de_thread(struct task_struct *tsk)
>  		release_task(leader);
>  	}
>  
> +	if (unlikely(unsafe_execve_in_progress)) {
> +		mutex_lock(&sig->cred_guard_mutex);
> +		sig->exec_bprm = NULL;
> +	}
> +
>  	sig->group_exec_task = NULL;
>  	sig->notify_count = 0;
>  
> @@ -1032,6 +1052,11 @@ static int de_thread(struct task_struct *tsk)
>  	return 0;
>  
>  killed:
> +	if (unlikely(unsafe_execve_in_progress)) {
> +		mutex_lock(&sig->cred_guard_mutex);
> +		sig->exec_bprm = NULL;
> +	}
> +
>  	/* protects against exit_notify() and __exit_signal() */
>  	read_lock(&tasklist_lock);
>  	sig->group_exec_task = NULL;
> @@ -1114,13 +1139,31 @@ int begin_new_exec(struct linux_binprm * bprm)
>  	 */
>  	trace_sched_prepare_exec(current, bprm);
>  
> +	/* If the binary is not readable then enforce mm->dumpable=0 */
> +	would_dump(bprm, bprm->file);
> +	if (bprm->have_execfd)
> +		would_dump(bprm, bprm->executable);
> +
> +	/*
> +	 * Figure out dumpability. Note that this checking only of current
> +	 * is wrong, but userspace depends on it. This should be testing
> +	 * bprm->secureexec instead.
> +	 */
> +	if (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP ||
> +	    is_dumpability_changed(current_cred(), bprm->cred) ||
> +	    !(uid_eq(current_euid(), current_uid()) &&
> +	      gid_eq(current_egid(), current_gid())))
> +		set_dumpable(bprm->mm, suid_dumpable);
> +	else
> +		set_dumpable(bprm->mm, SUID_DUMP_USER);
> +

I feel like moving this dumpable stuff around could be a separate patch.
Which can explain how that is correct and why it is needed and all that.

>  	/*
>  	 * Ensure all future errors are fatal.
>  	 */
>  	bprm->point_of_no_return = true;
>  
>  	/* Make this the only thread in the thread group */
> -	retval = de_thread(me);
> +	retval = de_thread(me, bprm);
>  	if (retval)
>  		goto out;
>  	/* see the comment in check_unsafe_exec() */
> @@ -1144,11 +1187,6 @@ int begin_new_exec(struct linux_binprm * bprm)
>  	if (retval)
>  		goto out;
>  
> -	/* If the binary is not readable then enforce mm->dumpable=0 */
> -	would_dump(bprm, bprm->file);
> -	if (bprm->have_execfd)
> -		would_dump(bprm, bprm->executable);
> -
>  	/*
>  	 * Release all of the old mmap stuff
>  	 */
> @@ -1210,18 +1248,6 @@ int begin_new_exec(struct linux_binprm * bprm)
>  
>  	me->sas_ss_sp = me->sas_ss_size = 0;
>  
> -	/*
> -	 * Figure out dumpability. Note that this checking only of current
> -	 * is wrong, but userspace depends on it. This should be testing
> -	 * bprm->secureexec instead.
> -	 */
> -	if (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP ||
> -	    !(uid_eq(current_euid(), current_uid()) &&
> -	      gid_eq(current_egid(), current_gid())))
> -		set_dumpable(current->mm, suid_dumpable);
> -	else
> -		set_dumpable(current->mm, SUID_DUMP_USER);
> -
>  	perf_event_exec();
>  
>  	/*
> @@ -1361,6 +1387,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>  		return -ERESTARTNOINTR;
>  
> +	if (unlikely(current->signal->exec_bprm)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}

#1

> +
>  	bprm->cred = prepare_exec_creds();
>  	if (likely(bprm->cred))
>  		return 0;
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 62d35631ba8c..e5bcf812cee0 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2838,6 +2838,12 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
>  	if (rv < 0)
>  		goto out_free;
>  

Comment explaining why this needs checking goes here.

> +	if (unlikely(current->signal->exec_bprm)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		rv = -ERESTARTNOINTR;
> +		goto out_free;
> +	}
> +
>  	rv = security_setprocattr(PROC_I(inode)->op.lsmid,
>  				  file->f_path.dentry->d_name.name, page,
>  				  count);
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index a102a10f833f..fb0361911489 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -153,6 +153,7 @@ extern const struct cred *get_task_cred(struct task_struct *);
>  extern struct cred *cred_alloc_blank(void);
>  extern struct cred *prepare_creds(void);
>  extern struct cred *prepare_exec_creds(void);
> +extern bool is_dumpability_changed(const struct cred *, const struct cred *);
>  extern int commit_creds(struct cred *);
>  extern void abort_creds(struct cred *);
>  extern struct cred *prepare_kernel_cred(struct task_struct *);
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 1ef1edbaaf79..3c47d8b55863 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -237,9 +237,27 @@ struct signal_struct {
>  	struct mm_struct *oom_mm;	/* recorded mm when the thread group got
>  					 * killed by the oom killer */
>  
> +	struct linux_binprm *exec_bprm;	/* Used to check ptrace_may_access
> +					 * against new credentials while
> +					 * de_thread is waiting for other
> +					 * traced threads to terminate.
> +					 * Set while de_thread is executing.
> +					 * The cred_guard_mutex is released
> +					 * after de_thread() has called
> +					 * zap_other_threads(), therefore
> +					 * a fatal signal is guaranteed to be
> +					 * already pending in the unlikely
> +					 * event, that
> +					 * current->signal->exec_bprm happens
> +					 * to be non-zero after the
> +					 * cred_guard_mutex was acquired.
> +					 */
> +
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
>  					 * (notably. ptrace)
> +					 * Held while execve runs, except when
> +					 * a sibling thread is being traced.
>  					 * Deprecated do not use in new code.
>  					 * Use exec_update_lock instead.
>  					 */
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 9676965c0981..0b2822c762df 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -375,6 +375,30 @@ static bool cred_cap_issubset(const struct cred *set, const struct cred *subset)
>  	return false;
>  }
>  
> +/**
> + * is_dumpability_changed - Will changing creds affect dumpability?
> + * @old: The old credentials.
> + * @new: The new credentials.
> + *
> + * If the @new credentials have no elevated privileges compared to the
> + * @old credentials, the task may remain dumpable.  Otherwise we have
> + * to mark the task as undumpable to avoid information leaks from higher
> + * to lower privilege domains.
> + *
> + * Return: True if the task will become undumpable.
> + */
> +bool is_dumpability_changed(const struct cred *old, const struct cred *new)
> +{
> +	if (!uid_eq(old->euid, new->euid) ||
> +	    !gid_eq(old->egid, new->egid) ||
> +	    !uid_eq(old->fsuid, new->fsuid) ||
> +	    !gid_eq(old->fsgid, new->fsgid) ||
> +	    !cred_cap_issubset(old, new))
> +		return true;
> +
> +	return false;
> +}
> +
>  /**
>   * commit_creds - Install new credentials upon the current task
>   * @new: The credentials to be assigned
> @@ -403,11 +427,7 @@ int commit_creds(struct cred *new)
>  	get_cred(new); /* we will require a ref for the subj creds too */
>  
>  	/* dumpability changes */
> -	if (!uid_eq(old->euid, new->euid) ||
> -	    !gid_eq(old->egid, new->egid) ||
> -	    !uid_eq(old->fsuid, new->fsuid) ||
> -	    !gid_eq(old->fsgid, new->fsgid) ||
> -	    !cred_cap_issubset(old, new)) {
> +	if (is_dumpability_changed(old, new)) {
>  		if (task->mm)
>  			set_dumpable(task->mm, suid_dumpable);
>  		task->pdeath_signal = 0;
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 75a84efad40f..230298817dbf 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -20,6 +20,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/ptrace.h>
>  #include <linux/security.h>
> +#include <linux/binfmts.h>
>  #include <linux/signal.h>
>  #include <linux/uio.h>
>  #include <linux/audit.h>
> @@ -453,6 +454,28 @@ static int ptrace_attach(struct task_struct *task, long request,
>  				return retval;
>  		}
>  
> +		if (unlikely(task == task->signal->group_exec_task)) {
> +			retval = down_write_killable(&task->signal->exec_update_lock);
> +			if (retval)
> +				return retval;

This could be written like:

			ACQUIRE(rwsem_write_kill, guard)(&task->signal->exec_update_lock);
			retval = ACQUIRE_ERR(rwsem_write_kill, guard);
			if (retval)
				return retval;

> +
> +			scoped_guard (task_lock, task) {
> +				struct linux_binprm *bprm = task->signal->exec_bprm;
> +				const struct cred __rcu *old_cred = task->real_cred;
> +				struct mm_struct *old_mm = task->mm;
> +
> +				rcu_assign_pointer(task->real_cred, bprm->cred);
> +				task->mm = bprm->mm;
> +				retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
> +				rcu_assign_pointer(task->real_cred, old_cred);
> +				task->mm = old_mm;
> +			}
> +
> +			up_write(&task->signal->exec_update_lock);

And then this goes away ^

> +			if (retval)
> +				return retval;
> +		}
> +
>  		scoped_guard (write_lock_irq, &tasklist_lock) {
>  			if (unlikely(task->exit_state))
>  				return -EPERM;
> @@ -488,6 +511,14 @@ static int ptrace_traceme(void)
>  {
>  	int ret = -EPERM;
>  

This needs comments.

> +	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> +		return -ERESTARTNOINTR;
> +
> +	if (unlikely(current->signal->exec_bprm)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}

#2

> +
>  	write_lock_irq(&tasklist_lock);
>  	/* Are we already being traced? */
>  	if (!current->ptrace) {
> @@ -503,6 +534,7 @@ static int ptrace_traceme(void)
>  		}
>  	}
>  	write_unlock_irq(&tasklist_lock);
> +	mutex_unlock(&current->signal->cred_guard_mutex);
>  
>  	return ret;
>  }
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 41aa761c7738..d61fc275235a 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1994,9 +1994,15 @@ static long seccomp_set_mode_filter(unsigned int flags,
>  	 * Make sure we cannot change seccomp or nnp state via TSYNC
>  	 * while another thread is in the middle of calling exec.
>  	 */
> -	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> -	    mutex_lock_killable(&current->signal->cred_guard_mutex))
> -		goto out_put_fd;
> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC) {
> +		if (mutex_lock_killable(&current->signal->cred_guard_mutex))
> +			goto out_put_fd;
> +
> +		if (unlikely(current->signal->exec_bprm)) {
> +			mutex_unlock(&current->signal->cred_guard_mutex);
> +			goto out_put_fd;
> +		}

#3, and after typing this same pattern 3 times, you didn't think it
needed a helper function ?

> +	}
>  
>  	spin_lock_irq(&current->sighand->siglock);
>  

