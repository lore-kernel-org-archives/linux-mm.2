Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF2ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 14:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865108E000E; Wed,  5 Nov 2025 09:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C058E0003; Wed,  5 Nov 2025 09:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751D88E000E; Wed,  5 Nov 2025 09:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 668EB8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:34:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDA2A16038F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:04 +0000 (UTC)
X-FDA: 84076798008.30.A947655
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B42551A000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="crA5/Y78";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762353243; a=rsa-sha256;
	cv=none;
	b=csTQZh3E6RF9qSf5B2F9MxS6No2iHE7EIneDyusir0cIDkUbubg0Dt7kQRWVQ35i+m1+YD
	lRcM2V4T76gdNGESE+lJIljUCv12MmYbS2PQ/ThhzV48P4ancd23nYCGpoCCapxGvwo2su
	LSxaXYeZ6fojgeWNYKvSr+m8/pgFD4E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="crA5/Y78";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762353243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElYGIlkPKzTybpsHtstaGauKroEiTfyK75ipBsehUhk=;
	b=yq7NjkChvNxgjDZCKPo7a5n7nlGxXvRLC25R1dlJuBWmFSUFXOaY2SsRhiy10K8vGz/8JJ
	ldPaGh3+wpkG31nIuy3QVIBO58H46FLqaleKY+Pc4hmxopdyL+SLkLopEK5f7d8ZmzqE4f
	LdwAhQPlwda+F903wZe8LBh18jjIQwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762353242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ElYGIlkPKzTybpsHtstaGauKroEiTfyK75ipBsehUhk=;
	b=crA5/Y7813XPTpWPGLWxK0NjL4sod3bXzozae81SL542lrrIm3BhkVYBrqWXWUFJViVdzU
	X7jWlgFJJekaBkxh3qsye7oq/p91FYRX5HqrECj+2NuOagReWHHtBkCncKG+d/4ysx/9PS
	Y8a5KFK8gnXz/FgvNx4nt57zabYaSRE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-ONJ9TyxoOGyURfFJlmVhEg-1; Wed,
 05 Nov 2025 09:33:57 -0500
X-MC-Unique: ONJ9TyxoOGyURfFJlmVhEg-1
X-Mimecast-MFC-AGG-ID: ONJ9TyxoOGyURfFJlmVhEg_1762353232
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7691519560A1;
	Wed,  5 Nov 2025 14:33:48 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.124])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5DEDA180049F;
	Wed,  5 Nov 2025 14:33:28 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed,  5 Nov 2025 15:32:31 +0100 (CET)
Date: Wed, 5 Nov 2025 15:32:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
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
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <20251105143210.GA25535@redhat.com>
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
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B42551A000E
X-Stat-Signature: wh5e3bjg1xj5jntyj3uzgpo3dzox6rox
X-HE-Tag: 1762353242-449945
X-HE-Meta: U2FsdGVkX1+kQwx3ChJ62aFPcEkeY+kA9zJtgjL7oHeInQq9xTZXdFfBfZoLrLtHH1u2LNSpjg60sFtcRXGGvn9S5eKqL1elrpVqD5bg5aMMDBtw5qi/j1pzK9NUAXikCmNGyLT6QNg7XTxr9WzUgji1f7uVu43tZq9M9UAagdtu2Kw16jTR11OX0qtul6yMmOtOba/UU4noQLI1Y/5G5NrsW2BCPey+tRvWvg68a1/C/x0FGwtRHT38lf6sb4ItGBQEtDrZILWrlG7cjaynZWPgIYCPnMg8qlAOzF26eJhtqNHWtTjbt0qyRvm7c5vQGlkUp+7MpDQ2SxDF4uywSxmM2V9DBPxENkRzmT6zYzwjGTJNkoEb6HLQifVVe1KvbRknJF59hUOcsD0oIbUyqF45z73zYDNQoppHIsrfnEu3CN9EdDNHftRC1S+2GRKiTJoO8EqtwyrPPaxQ8gt48a9EnMTnuOS2Q7pdxek+LKUy/KMKV9FFov9FESZ5LdWPpb6YbPK5WF4OoudI0NK6+wOZOz+7zSJbNKT9rBu6R7xm530a1ToWpYqbOZivR3GYoQMWsen4P3z0glmMKVC8BCKJVo00yqT2NkV3LYRitsFln9KUaAoZnJKqfsEzlpd1WyqPHcOAF+GO4tlz9wmm4xtEx/s7oIfLdomFnsAf92NTSHOVRDGMGdAuO1SyP3ggiZoeBDcibbMdUHa2DCCc7kprKYFqQK0YLYwbf4YlwM5qdJh87icRPc2jSQ49LmsARJFbYKp2pms0O2dzm8Rq/PGFJX5F3esFKYoKJhFZxk6iZkYegtYBj7RWxLhazgereVvxT80bx95ldwrnUEJsCYpcBkx0mggmVrr9TZLhIBlRCWpW8amwwgAX2jswmtHRJgxNEkIVPBvobfAhGVQfRLMKh6Oz4aipIvuG9xVeuINC/cF9mr+emKTlsoFlSq9yNVh8AcT0fx/4V059WiJ
 tLa0d+aH
 jliZKo8EFIHtopnQFT8dExtR+cawfg94rq3Gh1u2kKlavJJpKT0/cle8YL8RQAU6555gmRwe3thjjyuqKYORraf1rgqH2qGcjDTZwavQOdsEJL4kLycU4Oz/+KtH+c2wJ62c7B1SwEC9Z3eG4W4jjMsY3SsrTDuYyaRCHuXOVCIecS0+HRXs/WYdV8WquqRiAu2lQkx2FlnJOmH8ACmeLcMtRI7Pml8MrV+Lkt8hZfTlchgCkxYo5WbhYgiEQl3cmadLbKY4TRVh6x6Z1fHbLWJEOOSqIxYYtRUlNcsRpwLSbyHJbyNHM8xqpqoI8UbMxRd5WgRaXZ+W790ZIRKUqbP4i/w35FCttLZe6gYLaLyRiSPBbOCiOjAP8kSGOYozkrxYUtRmzBe7UznwCVTWSV7s190zq6pKTiSFqNLMQNfvs7UByo9dulx02wL2lg6YrvCt87ME9cQNtegY8sQ6g72OUt7tscli99jZWAL8oD1O5p6ZfuUcGeWIXGwerikT8Dja4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I am still thinking about another approach, will write another email.
But let me take a closer look at your patch.

First of all, can you split it? See below.

On 08/21, Bernd Edlinger wrote:
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
> +			unsafe_execve_in_progress = true;

you can add "break" into the "if ()" block...

But this is minor. Why do we need "bool unsafe_execve_in_progress" ?
If this patch is correct, de_thread() can drop/reacquire cred_guard_mutex
unconditionally.

If you really think it makes sense, please make another patch with the
changelog.

I'd certainly prefer to avoid this boolean at least for the start. If nothing
else to catch the potential problems earlier.

> +	if (unlikely(unsafe_execve_in_progress)) {
> +		spin_unlock_irq(lock);
> +		sig->exec_bprm = bprm;
> +		mutex_unlock(&sig->cred_guard_mutex);
> +		spin_lock_irq(lock);

I don't think spin_unlock_irq() + spin_lock_irq() makes any sense...

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

OK, we need to do this before de_thread() drops cred_guard_mutex.
But imo this too should be done in a separate patch, the changelog should
explain this change.

> @@ -1361,6 +1387,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
>  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
>  		return -ERESTARTNOINTR;
>
> +	if (unlikely(current->signal->exec_bprm)) {
> +		mutex_unlock(&current->signal->cred_guard_mutex);
> +		return -ERESTARTNOINTR;
> +	}

OK, if signal->exec_bprm != NULL, then current is already killed. But
proc_pid_attr_write() and ptrace_traceme() do the same. So how about
something like

	int lock_current_cgm(void)
	{
		if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
			return -ERESTARTNOINTR;

		if (!current->signal->group_exec_task)
			return 0;

		WARN_ON(!fatal_signal_pending(current));
		mutex_unlock(&current->signal->cred_guard_mutex);
		return -ERESTARTNOINTR;
	}

?

Note that it checks ->group_exec_task, not ->exec_bprm. So this change can
come in a separate patch too, but I won't insist.

> @@ -453,6 +454,28 @@ static int ptrace_attach(struct task_struct *task, long request,
>  				return retval;
>  		}
>
> +		if (unlikely(task == task->signal->group_exec_task)) {
> +			retval = down_write_killable(&task->signal->exec_update_lock);
> +			if (retval)
> +				return retval;
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

This is the most problematic change which I can't review...

Firstly, it changes task->mm/real_cred for __ptrace_may_access() and this
looks dangerous to me.

Say, current_is_single_threaded() called by another CLONE_VM process can
miss group_exec_task and falsely return true. Probably not that bad, in
this case old_mm should go away soon, but still...

And I don't know if this can fool the users of task_cred_xxx/__task_cred
somehow.

Or. check_unsafe_exec() sets LSM_UNSAFE_PTRACE if ptrace. Is it safe to
ptrace the execing task after that? I have no idea what the security hooks
can do...

Again, can't review this part.

Oleg.


