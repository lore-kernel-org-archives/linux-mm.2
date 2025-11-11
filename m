Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8F8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3928E001D; Tue, 11 Nov 2025 04:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA9E8E0002; Tue, 11 Nov 2025 04:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0918E001D; Tue, 11 Nov 2025 04:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 253138E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:22:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEAB288CEA
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:22:15 +0000 (UTC)
X-FDA: 84097785030.16.780724A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CC508000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:22:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Iq/i8hPW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852934; a=rsa-sha256;
	cv=none;
	b=aDKp2zGHAo+M5LNPOw7iN9+wBviULjNc3PRRrQ7XyhCAOhGk5nmwGDk5RYruRewzfH0iih
	JXzcbGM+BYrzWz/aOW5Z1oL+GL8W66ST/TQeF8sfccgzYOQ+RQ9O+AEAi/AWi9+t8nOs7O
	tXlZNO2wRtwinOpA3ZJPCZpVIQW5FZc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Iq/i8hPW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAuGXI5pmMHjdPB/JqSMc2jjA8YJhyKvnq/uvh5ITHA=;
	b=R7LloqLvOpuBkkn4wUOSPopj5zEoRiY+beVqRj+5PcTHG9B1W4Y3fRp4Sf9f/vO4HFQyLK
	L9iEazJu+ueZqSkoWvJ9DnAXMUZZthpHcPIgcUyNss2XG5JVrrxfjBpMzLy0wQcd5qX1an
	jCpjxtIrI6enVXxLn7agwEvgra/kkc0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA3B543AF1;
	Tue, 11 Nov 2025 09:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B43C19422;
	Tue, 11 Nov 2025 09:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762852932;
	bh=YKxB1Tk0c8PA5NVe6KSLcg4q1RUhiINUvY7b/ZMmRUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iq/i8hPWgHTwu435PI+UGZlLN/X3lyfBrrm+1OwNKieirVMDPmDCkCaFA5KX+Cpoo
	 jCY0uq+bKxbfSS/6qRug9ACZVWvSIG2hb05Nfywkq6thFqPc80S2JztzaJqBCtX5TK
	 6ankYgSWSaELPVPWooj+5cT1eMoRBXuIxw8R7wm0f3aC08zRAHgGqQPhTXlh+50TBr
	 zxjneSB775FAK9WKt6FxPW2yAZcqlXQ0OEYW8MPlkyO1msbbTBkJLfLsWoPQX0KMwY
	 2kPRjg5gUXXR3fF2VCX329Z0qynUJi5o5aKfiv7nNQoaN9iGP9xwUFoDOYr6HTaRw8
	 daoW/qmbnCCrQ==
Date: Tue, 11 Nov 2025 10:21:58 +0100
From: Christian Brauner <brauner@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Kees Cook <kees@kernel.org>, Andy Lutomirski <luto@amacapital.net>, 
	Will Drewry <wad@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>, 
	James Morris <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, Adrian Reber <areber@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, 
	Alexei Starovoitov <ast@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, tiozhang <tiozhang@didiglobal.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Paulo Alcantara (SUSE)" <pc@manguebit.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Frederic Weisbecker <frederic@kernel.org>, 
	YueHaibing <yuehaibing@huawei.com>, Paul Moore <paul@paul-moore.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>, 
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Dave Chinner <dchinner@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, 
	David Windsor <dwindsor@gmail.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Ard Biesheuvel <ardb@kernel.org>, "Joel Fernandes (Google)" <joel@joelfernandes.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Hans Liljestrand <ishkamiel@gmail.com>, 
	Penglei Jiang <superman.xpt@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Adrian Ratiu <adrian.ratiu@collabora.com>, Ingo Molnar <mingo@kernel.org>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <20251111-ankreiden-augen-eadcf9bbdfaa@brauner>
References: <AM8PR10MB470801D01A0CF24BC32C25E7E40E9@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AM8PR10MB470875B22B4C08BEAEC3F77FE4169@AM8PR10MB4708.EURPRD10.PROD.OUTLOOK.COM>
 <AS8P193MB1285DF698D7524EDE22ABFA1E4A1A@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251105143210.GA25535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251105143210.GA25535@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0CC508000F
X-Stat-Signature: uigm86qa7dgf3yajsdtdeaft7nzc4p85
X-Rspam-User: 
X-HE-Tag: 1762852933-440219
X-HE-Meta: U2FsdGVkX18I9RmVkmyfKAyTRflLuAzPFQcVaacCB9V9Y4jd+hHi874q3gUNkzpIPFpEGDflVIbOW1uEpylD6M/sAvJy69a49oWsVU6l42ybAZClWcs06uJt7fB7dehq2nknvOMqXGlx3iWrLaalC/M/oRKDf8mKQf/IY6qvYWbOslOWEiEsD6qHncHpOQvEOFz/sL2kkERGluyn2jJ5cvierHnDBAHYmCgZm+gcYr8QaX08riorBXxtXlaoW4HdBtLpvXFzqMshHcdKJkFm0/6SR2aIXfK6YPjlYk2OmnM43AEN4XcGozjhIxpUQhtsP6tVMZ+eyxBCzR+DGPl86WM6hVfLuvUVV+DFJ+2Ap0kzmfbGmQAFA81twzfgmDcypY6su3sdDlRAWnlirROc9oh7Lj6peg2PzCh/t4rN8nvi9MPTqLdL06BvPz0dmu6dwNH1xS0IVxzvVVuWRA8cPojClbw6CpwnRO8y6/zb1aKvzP14Ac94zyA92+rtuO9h5oP0568xz+iSVNDDp1GvsNN651ceVW49EFUbpvp2hOSrDIr7IWx0rcFG0AugkNWGxnGe3QqmJWO/6IVdzk30G8r9CqIqo1jDaaz11b441Ih7U8h3G+E5/kVeUkozKXVnNq4y1WauxFXDgdt1WdLH86VbINphtCx0m3xBq8kOhyuTIuy9wy+c4peXE8TUf5V91CH+r3z20EZPA95m3yR78GOnnpycqLyeeTWMM9iGX4mDVcZATjrMi8NbROyjb8eiKxwZV38ma2g0D7sBwuwyUM4h2AxqxuEzqN3EwhnyvF69SFtGL0XbWxl1T5aIFM+elB+lBaG+plynBuNan6+puBQJK99oM+ygp9XDJmJuworZmUQCo8VC2gdPVqwoI7U2k58gzLl73eZ6seeKCUaNtGjXJL85zOy0oast3KPcLAks96c/CkNnwPM0v+3m8l0zdXcQPXdM5mEDRznE6gQ
 VNGItiup
 uaKx0JX7R/WWhVp1LACwkmzuZd6tWfLZd3QwEcSbgpsFbOHx/3U2Ccf0TEWvnO3TLpGWhf6z9ywkKiwQPvTM2DqNq+bKq6dNku1FV/EytH2E0UBwKhXBLwLXQ0B1IzcobUVawTVtJg5dp2LqQ8uKpB6svzW2dzHNSynf+Qqd+vKvbMp5hp3ZBdSF0PTALtI+PuoqFyFQC4Ak84zR5r3c+pAKbkcjWJ8aIuZZ05BAjb6W611AzWwCpP5kvcON8GYu/3uYKtZ6yEBOsWrf/h4kN68iLToNwwg95dwKnBiIL0lhkpD0sdAe1GIUhY6CkpZz+l6wdSGamTxTRP1klUDZaNWFQocLrIKGfQwLtbfIg4yP4d0q2+TOR4dZfAcOswWpIvgQtjeCHlhNpFUQt19U8Wc9uyY371N/chnpmSLT54MfC/0qO3L5BMm7LsMjeZ1SxH5rkon4PNwHfLV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 03:32:10PM +0100, Oleg Nesterov wrote:
> I am still thinking about another approach, will write another email.
> But let me take a closer look at your patch.
> 
> First of all, can you split it? See below.
> 
> On 08/21, Bernd Edlinger wrote:
> >
> > -static int de_thread(struct task_struct *tsk)
> > +static int de_thread(struct task_struct *tsk, struct linux_binprm *bprm)
> >  {
> >  	struct signal_struct *sig = tsk->signal;
> >  	struct sighand_struct *oldsighand = tsk->sighand;
> >  	spinlock_t *lock = &oldsighand->siglock;
> > +	struct task_struct *t;
> > +	bool unsafe_execve_in_progress = false;
> >
> >  	if (thread_group_empty(tsk))
> >  		goto no_thread_group;
> > @@ -932,6 +934,19 @@ static int de_thread(struct task_struct *tsk)
> >  	if (!thread_group_leader(tsk))
> >  		sig->notify_count--;
> >
> > +	for_other_threads(tsk, t) {
> > +		if (unlikely(t->ptrace)
> > +		    && (t != tsk->group_leader || !t->exit_state))
> > +			unsafe_execve_in_progress = true;
> 
> you can add "break" into the "if ()" block...
> 
> But this is minor. Why do we need "bool unsafe_execve_in_progress" ?
> If this patch is correct, de_thread() can drop/reacquire cred_guard_mutex
> unconditionally.
> 
> If you really think it makes sense, please make another patch with the
> changelog.
> 
> I'd certainly prefer to avoid this boolean at least for the start. If nothing
> else to catch the potential problems earlier.
> 
> > +	if (unlikely(unsafe_execve_in_progress)) {
> > +		spin_unlock_irq(lock);
> > +		sig->exec_bprm = bprm;
> > +		mutex_unlock(&sig->cred_guard_mutex);
> > +		spin_lock_irq(lock);
> 
> I don't think spin_unlock_irq() + spin_lock_irq() makes any sense...
> 
> > @@ -1114,13 +1139,31 @@ int begin_new_exec(struct linux_binprm * bprm)
> >  	 */
> >  	trace_sched_prepare_exec(current, bprm);
> >
> > +	/* If the binary is not readable then enforce mm->dumpable=0 */
> > +	would_dump(bprm, bprm->file);
> > +	if (bprm->have_execfd)
> > +		would_dump(bprm, bprm->executable);
> > +
> > +	/*
> > +	 * Figure out dumpability. Note that this checking only of current
> > +	 * is wrong, but userspace depends on it. This should be testing
> > +	 * bprm->secureexec instead.
> > +	 */
> > +	if (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP ||
> > +	    is_dumpability_changed(current_cred(), bprm->cred) ||
> > +	    !(uid_eq(current_euid(), current_uid()) &&
> > +	      gid_eq(current_egid(), current_gid())))
> > +		set_dumpable(bprm->mm, suid_dumpable);
> > +	else
> > +		set_dumpable(bprm->mm, SUID_DUMP_USER);
> > +
> 
> OK, we need to do this before de_thread() drops cred_guard_mutex.
> But imo this too should be done in a separate patch, the changelog should
> explain this change.
> 
> > @@ -1361,6 +1387,11 @@ static int prepare_bprm_creds(struct linux_binprm *bprm)
> >  	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> >  		return -ERESTARTNOINTR;
> >
> > +	if (unlikely(current->signal->exec_bprm)) {
> > +		mutex_unlock(&current->signal->cred_guard_mutex);
> > +		return -ERESTARTNOINTR;
> > +	}
> 
> OK, if signal->exec_bprm != NULL, then current is already killed. But
> proc_pid_attr_write() and ptrace_traceme() do the same. So how about
> something like
> 
> 	int lock_current_cgm(void)
> 	{
> 		if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
> 			return -ERESTARTNOINTR;
> 
> 		if (!current->signal->group_exec_task)
> 			return 0;
> 
> 		WARN_ON(!fatal_signal_pending(current));
> 		mutex_unlock(&current->signal->cred_guard_mutex);
> 		return -ERESTARTNOINTR;
> 	}
> 
> ?
> 
> Note that it checks ->group_exec_task, not ->exec_bprm. So this change can
> come in a separate patch too, but I won't insist.
> 
> > @@ -453,6 +454,28 @@ static int ptrace_attach(struct task_struct *task, long request,
> >  				return retval;
> >  		}
> >
> > +		if (unlikely(task == task->signal->group_exec_task)) {
> > +			retval = down_write_killable(&task->signal->exec_update_lock);
> > +			if (retval)
> > +				return retval;
> > +
> > +			scoped_guard (task_lock, task) {
> > +				struct linux_binprm *bprm = task->signal->exec_bprm;
> > +				const struct cred __rcu *old_cred = task->real_cred;
> > +				struct mm_struct *old_mm = task->mm;
> > +
> > +				rcu_assign_pointer(task->real_cred, bprm->cred);
> > +				task->mm = bprm->mm;
> > +				retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
> > +				rcu_assign_pointer(task->real_cred, old_cred);
> > +				task->mm = old_mm;
> > +			}
> 
> This is the most problematic change which I can't review...
> 
> Firstly, it changes task->mm/real_cred for __ptrace_may_access() and this
> looks dangerous to me.

Yeah, that is not ok. This is effectively override_creds for real_cred
and that is not a pattern I want to see us establish at all! Temporary
credential overrides for the subjective credentials is already terrible
but at least we have the explicit split between real_cred and cred
expressely for that. So no, that's not an acceptable solution.

> 
> Say, current_is_single_threaded() called by another CLONE_VM process can
> miss group_exec_task and falsely return true. Probably not that bad, in
> this case old_mm should go away soon, but still...
> 
> And I don't know if this can fool the users of task_cred_xxx/__task_cred
> somehow.
> 
> Or. check_unsafe_exec() sets LSM_UNSAFE_PTRACE if ptrace. Is it safe to
> ptrace the execing task after that? I have no idea what the security hooks
> can do...
> 
> Again, can't review this part.
> 
> Oleg.
> 

