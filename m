Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FA3606A33F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.a=rsa-sha256 header.s=mail header.b=q1OyiUGq
Received: by kanga.kvack.org (Postfix)
	id ECE846B05BE; Mon,  9 Nov 2026 09:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EE16B05BF; Mon,  9 Nov 2026 09:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6E026B05C0; Mon,  9 Nov 2026 09:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A68CE6B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F09C1C3D4B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:59:21 +0000 (UTC)
X-FDA: 85415888922.28.A5FBDE2
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C23F180003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:59:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=q1OyiUGq;
	spf=pass (imf06.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794236359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLWQCWm7FEmRwx6ajIqRnfAU6VYPetVnsES1gVHGnlY=;
	b=oJDC44iRjXFQl7/duuwJtia9dIoZ9QfXftDHeW9/JZ9KFa9/o4TMnLw9HpjrOrRHZHzJq4
	DknzDN9kxUlt/5TkDWBHO7E++upCScoYWTAiNJlgPELttIvf1bS1iX74vNjRijEt95f7Mg
	XVsl1gEYeKFDj22E2RwXOSd0tSd97LI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794236359;
	b=cdOs+jkt0AI4rI6sM9v7d5SubTVjVVLnWutqE5DIavZhLX+p6a+nbC0OM90lbGznfudD5R
	U2DK6Ly2EcjyYpclDwqpNZEi9NxlaGbw4pW0UHt6MJyNpaoxWEr6q78ngCr65U2FXSaxp0
	8vl6BxT9ZW/vtvNNPWGtwJavm1qagWE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=q1OyiUGq;
	spf=pass (imf06.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com;
	dmarc=pass (policy=reject) header.from=hallyn.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1794236357; bh=TPElvw9G0st03bsrdM5rcoMnhwGQa/bsB6ZYXpB9etM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q1OyiUGq+cxjOM6yO5+HcKdUHwMsY4R+KCZMxOUnD943+UUNkuMujKp8hLF9RWmo+
	 m81Pc/mhKrPSlap7Tvm6+8JijvC7djKhyadkFeHxZGQy8VDSwTNNSBj+nqhFEX41ks
	 ktDgCR6Gkx+OwltVtoBsWMYTZ8boGaWFbvytE1MrLVxWUP0TB05QCfudw5B12wZRc3
	 b2KcdOxPdOUHuXQKcn9K6eQ1iwe6AbcAN86VkeTFsDSBKphvsCWL2w/9CSdutYXKvQ
	 ZqMAOb78+0riUPc8TWoE38bLAyT2xsmvR4weuwDYToDlSOCpZ32gvst4K8ZM325Ivk
	 acPGAfU0dkhFQ==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id DD5011E61; Mon,  9 Nov 2026 08:59:17 -0600 (CST)
Date: Mon, 9 Nov 2026 08:59:17 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>, Oleg Nesterov <oleg@redhat.com>,
	kees@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, paul@paul-moore.com,
	jmorris@namei.org, shuah@kernel.org, brauner@kernel.org,
	alexjlzheng@tencent.com, jannh@google.com, jaime.saguillo@gmail.com,
	elver@google.com, blbllhy@gmail.com, bvanassche@acm.org,
	pjw@kernel.org, broonie@kernel.org, debug@rivosinc.com,
	tglx@kernel.org, aleksey.oladko@virtuozzo.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
Message-ID: <avHfxe++P4WLUQxf@hallyn.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com>
 <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 9jm43h6pyruw6u5zucb3a6eokfqgwps1
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2C23F180003
X-Rspam-User: 
X-HE-Tag: 1794236359-577520
X-HE-Meta: U2FsdGVkX19al91+oHtOfdRRKJ7VUqSBNLfPgXDimo31DWZutxCk/3PArLplEpfsSXV3CKhx/azpvyqx/ROE31ODb9m3mrVvqNpxjUG98ix+p6LhK76bFA7SIbUI2Mg+eVvMr9Iosh/MHYrZkkn5IoWWoXyzqwxL4h6CJRQKtQT5Ebg0p/Gn/2h+HDlLqWAqcz6iNvhw7oolv9m583b1+4gw1p9IuQ+QMBcOjSwSwWvc+pNy28gvb4RADPev0rs9zJgVoqunLf0tCyfpHEguYVlTVQdUa8OF3vKDnrDk6qJCP8bHqVw+CwicD8YTK4v/EiJPzgyHHne6IFbEoNvy1CH5MfTWWgQs7WjdkwbHQ3fJ6FVNAKu/0egSCwMyxHVeFJVb463muOCK7Cp/uX6hWy94BUfAQ3a/OHg5PMQaEKZo19tjz2z4IcXxnThYw4st+UVmZOLNZrdyGzF6HMA8CQd0xdAoDnckph1gRW+bXHyKIY7/p2tBlc9UsKPQBif9ayOpZW4s1CX0aCs4x8m3EIYzXM84WvzH3HvuINhjb2a64mNSl2RnUPl4cYv8XnexJW4hEpKlTzJjbo2P2NtuXzqU/GM7xbAXwhxEQrFDKr2HwPkamyq4y9Xv6KkuJrR7ALHAFBwVwUPP6dZuD9A/QioX5aSBMdc+CrYfgGrYe4kEHycNOMu4MaU/JW3OyZhWPM8J4VYAd5K+SzTkpvfaFFFFuLD9lovy4cBzb411DvKrhgVvo9k09zudVb1PyALXzjELADIxXWPoQ7fAapBqQKeyFzHNFwikgTxmoh5zHMS1CThtKIuo1om329tEvP7gSLLTIQWSjy0LgE4fBC5u73Qwf/Jb7QtcuZ41P5nqqoBCwludwRarYxP2M/cqN2McA34n6yOw02TCO1ce11RnAkoFqUQyBk/iRXvDL3m2vrEUhFzgi6IWWyW1X65NTJjuJlFAgBFuxUVQvyXBgB2
 Cg1qeti0
 m4gwYM+L0V2LrTI7MYuGgB8zdAkZyuL9+I/7HD1D0X+Ah/ZctS7WEsnKiSB2DnN3OAJbFQVvLYGBh5cqDDvSz4ZaK/QRhjuuzkCcBIJB6PEoZl/0ePlxqrFAoJfdbBQVjYd4d8SPvTIPcHOp4pov/OFU74wR4yNp8nctcRWcv8rK5yosRTPqspbghiuUlbsymlfSq4Jjv4GzoheCIdC6mY0x23x6x5aCiHGrraKtg26tooiXMV0BjXgHFRLYrH/531ukUOlIOjKTsDX0uxAZDNsqYRwPvm/wkD1NQopW7DcHI5wlnRfqQlBl4A3EkvPRz6q2gEBUNzw4jZAaggbJK2bNYdwvUHpPWtduRTrEzXg2lL2gFN0UPfhIJcLUbz6UfT9k0S8PVOYqkHnwjcJa8gMHg0pV4TPKSJoUlwLeVTwYErNo5TepvY4yIxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jinjie,

how do you feel about adding something like a thread | process flag?

On Wed, Oct 21, 2026 at 07:42:43AM -0700, Andrew G. Morgan wrote:
> There are a number of situations where existing code wants to
> (temporarily) affect the capabilities of a single thread, so a
> subsequent fork() starts with those without affecting the parent
> process as a whole. I've been wondering if this code could be
> structured to allow an argument of the prctl() to indicate if the call
> is "whole process" or "just this thread" scoped?
> 
> Cheers
> 
> Andrew
> 
> On Wed, Oct 21, 2026 at 7:36 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> > On Tue, Sep 29, 2026 at 09:01:59PM +0800, Jinjie Ruan wrote:
> > > PR_CAPBSET_DROP only affects the calling thread. Process-wide capability
> > > dropping requires user space to loop over every thread and every
> > > capability, which is highly expensive. For instance, long-lived
> > > multi-threaded processes (like gVisor's sentry) spend milliseconds
> > > trimming the bounding set because the runtime has to coordinate
> > > and signal every thread.
> > >
> > > Add PR_CAPBSET_DROP_MASK, an opt-in prctl that removes a set of
> > > capabilities from the entire thread group's bounding set in a single call.
> > > The capabilities are specified via a 64-bit mask across arg2 (low 32 bits)
> > > and arg3 (high 32 bits).
> > >
> > > The drop is recorded in a per-thread-group mask,
> > > signal_struct::cap_bset_pending, under sighand->siglock. This pending drop
> > > is dynamically folded into the bounding set in critical paths:
> > > cap_capset(), PR_CAPBSET_READ(), and cap_bprm_creds_from_file().
> > > Running, concurrently created, or future threads within the group will
> > > all immediately observe the drop. A forked child inherits this mask
> > > in cap_bset_drop_fork() under siglock to close the race window
> > > against clone().
> > >
> > > The operation is drop-only, so concurrent callers commute and a single
> > > atomic OR is the linearization point.  It performs no per-thread allocation
> > > and only the caller's replacement cred can fail, reported synchronously as
> > > -ENOMEM before anything changes.
> > >
> > > In an arm64 KVM guest, trimming 41 capabilities of a multi-threaded Go
> > > process takes ~8.5-23.6ms with the per-thread PR_CAPBSET_DROP loop and
> > > ~11-14us with PR_CAPBSET_DROP_MASK, independent of the thread count.
> > >
> > > Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> >
> > Interesting idea, storing it in the sighand.
> >
> > Oleg, do you see any issues with that part of this?
> >
> > Overall, this seems ok to me.  That is, I think it addresses all the
> > concerns I had with the previous version.
> >
> > > ---
> > >  fs/proc/array.c              |  3 +-
> > >  include/linux/capability.h   |  5 ++
> > >  include/linux/sched/signal.h |  8 ++++
> > >  include/uapi/linux/prctl.h   |  1 +
> > >  kernel/fork.c                |  1 +
> > >  security/commoncap.c         | 91 ++++++++++++++++++++++++++++++++++--
> > >  6 files changed, 105 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > > index f6f75d206762..f1cde26d079c 100644
> > > --- a/fs/proc/array.c
> > > +++ b/fs/proc/array.c
> > > @@ -63,6 +63,7 @@
> > >  #include <linux/tty.h>
> > >  #include <linux/string.h>
> > >  #include <linux/mman.h>
> > > +#include <linux/capability.h>
> > >  #include <linux/sched/mm.h>
> > >  #include <linux/sched/numa_balancing.h>
> > >  #include <linux/sched/task_stack.h>
> > > @@ -318,7 +319,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
> > >       cap_inheritable = cred->cap_inheritable;
> > >       cap_permitted   = cred->cap_permitted;
> > >       cap_effective   = cred->cap_effective;
> > > -     cap_bset        = cred->cap_bset;
> > > +     cap_bset        = cap_bset_effective(p, cred);
> > >       cap_ambient     = cred->cap_ambient;
> > >       rcu_read_unlock();
> > >
> > > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > > index 7921a0b3b04a..6413c7fedb69 100644
> > > --- a/include/linux/capability.h
> > > +++ b/include/linux/capability.h
> > > @@ -38,6 +38,7 @@ struct file;
> > >  struct inode;
> > >  struct dentry;
> > >  struct task_struct;
> > > +struct cred;
> > >  struct user_namespace;
> > >  struct mnt_idmap;
> > >
> > > @@ -197,6 +198,10 @@ bool capable_wrt_inode_uidgid(struct mnt_idmap *idmap,
> > >                             const struct inode *inode, int cap);
> > >  extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
> > >  extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
> > > +extern kernel_cap_t cap_bset_effective(const struct task_struct *task,
> > > +                                    const struct cred *cred);
> > > +extern void cap_bset_drop_fork(struct task_struct *p);
> > > +
> > >  static inline bool perfmon_capable(void)
> > >  {
> > >       return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
> > > diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> > > index d45a5476b97d..bda6f18b65b9 100644
> > > --- a/include/linux/sched/signal.h
> > > +++ b/include/linux/sched/signal.h
> > > @@ -98,6 +98,14 @@ struct signal_struct {
> > >       int                     quick_threads;
> > >       struct list_head        thread_head;
> > >
> > > +     /*
> > > +      * Capabilities being removed from the bounding set of every thread in
> > > +      * this group by PR_CAPBSET_DROP_MASK.  Read on capability-transition
> > > +      * paths without sighand->siglock, hence atomic64 (a 64-bit value would
> > > +      * otherwise tear on 32-bit).
> > > +      */
> > > +     atomic64_t              cap_bset_pending;
> > > +
> > >       wait_queue_head_t       wait_chldexit;  /* for wait4() */
> > >
> > >       /* current thread group signal load-balancing target: */
> > > diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> > > index b6ec6f693719..85ac71897070 100644
> > > --- a/include/uapi/linux/prctl.h
> > > +++ b/include/uapi/linux/prctl.h
> > > @@ -70,6 +70,7 @@
> > >  /* Get/set the capability bounding set (as per security/commoncap.c) */
> > >  #define PR_CAPBSET_READ 23
> > >  #define PR_CAPBSET_DROP 24
> > > +#define PR_CAPBSET_DROP_MASK 82
> > >
> > >  /* Get/set the process' ability to use the timestamp counter instruction */
> > >  #define PR_GET_TSC 25
> > > diff --git a/kernel/fork.c b/kernel/fork.c
> > > index 5ef413368912..bf671a85d39d 100644
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -2504,6 +2504,7 @@ __latent_entropy struct task_struct *copy_process(
> > >        * before holding sighand lock.
> > >        */
> > >       copy_seccomp(p);
> > > +     cap_bset_drop_fork(p);
> > >
> > >       if (clone_flags & CLONE_NNP)
> > >               task_set_no_new_privs(p);
> > > diff --git a/security/commoncap.c b/security/commoncap.c
> > > index 3399535808fe..3bec15d43731 100644
> > > --- a/security/commoncap.c
> > > +++ b/security/commoncap.c
> > > @@ -3,6 +3,7 @@
> > >   */
> > >
> > >  #include <linux/capability.h>
> > > +#include <linux/cred.h>
> > >  #include <linux/audit.h>
> > >  #include <linux/init.h>
> > >  #include <linux/kernel.h>
> > > @@ -19,6 +20,7 @@
> > >  #include <linux/hugetlb.h>
> > >  #include <linux/mount.h>
> > >  #include <linux/sched.h>
> > > +#include <linux/sched/signal.h>
> > >  #include <linux/prctl.h>
> > >  #include <linux/securebits.h>
> > >  #include <linux/user_namespace.h>
> > > @@ -30,6 +32,25 @@
> > >  #define CREATE_TRACE_POINTS
> > >  #include <trace/events/capability.h>
> > >
> > > +/**
> > > + * Effective bounding set of @cred in @task's thread group
> > > + * @task: task whose thread group's pending drop applies
> > > + * @cred: credentials to read the bounding set from
> > > + *
> > > + * A drop recorded by PR_CAPBSET_DROP_MASK is authoritative on the thread group
> > > + * and may not have been materialized into every thread's cred yet, so the
> > > + * effective bounding set is the cred's own set minus the group's pending drop.
> > > + */
> > > +kernel_cap_t cap_bset_effective(const struct task_struct *task,
> > > +                             const struct cred *cred)
> > > +{
> > > +     kernel_cap_t pending = {
> > > +             .val = atomic64_read(&task->signal->cap_bset_pending),
> > > +     };
> > > +
> > > +     return cap_drop(cred->cap_bset, pending);
> > > +}
> > > +
> > >  /*
> > >   * If a non-root user executes a setuid-root binary in
> > >   * !secure(SECURE_NOROOT) mode, then we raise capabilities.
> > > @@ -284,8 +305,8 @@ int cap_capset(struct cred *new,
> > >
> > >       if (!cap_issubset(*inheritable,
> > >                         cap_combine(old->cap_inheritable,
> > > -                                   old->cap_bset)))
> > >               /* no new pI capabilities outside bounding set */
> > > +                                   cap_bset_effective(current, old))))
> > >               return -EPERM;
> > >
> > >       /* verify restrictions on target's new Permitted set */
> > > @@ -849,7 +870,7 @@ static void handle_privileged_root(struct linux_binprm *bprm, bool has_fcap,
> > >        */
> > >       if (__is_eff(root_uid, new) || __is_real(root_uid, new)) {
> > >               /* pP' = (cap_bset & ~0) | (pI & ~0) */
> > > -             new->cap_permitted = cap_combine(old->cap_bset,
> > > +             new->cap_permitted = cap_combine(new->cap_bset,
> > >                                                old->cap_inheritable);
> > >       }
> > >       /*
> > > @@ -925,6 +946,8 @@ int cap_bprm_creds_from_file(struct linux_binprm *bprm, const struct file *file)
> > >       int ret;
> > >       kuid_t root_uid;
> > >
> > > +     new->cap_bset = cap_bset_effective(current, new);
> > > +
> > >       if (WARN_ON(!cap_ambient_invariant_ok(old)))
> > >               return -EPERM;
> > >
> > > @@ -1283,6 +1306,63 @@ static int cap_prctl_drop(unsigned long cap)
> > >       return commit_creds(new);
> > >  }
> > >
> > > +static int cap_bset_drop_process(kernel_cap_t mask)
> > > +{
> > > +     kernel_cap_t pending;
> > > +     struct cred *new;
> > > +
> > > +     new = prepare_creds();
> > > +     if (!new)
> > > +             return -ENOMEM;
> > > +
> > > +     /*
> > > +      * Record the drop before committing the caller's cred, so that a
> > > +      * thread created from now on is guaranteed to observe it.  Apply the
> > > +      * current union, not just this call's mask, to the caller's cred.
> > > +      */
> > > +     spin_lock_irq(&current->sighand->siglock);
> > > +     atomic64_or(mask.val, &current->signal->cap_bset_pending);
> > > +     pending.val = atomic64_read(&current->signal->cap_bset_pending);
> > > +     spin_unlock_irq(&current->sighand->siglock);
> > > +
> > > +     new->cap_bset = cap_drop(new->cap_bset, pending);
> > > +     commit_creds(new);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +/*
> > > + * Propagate a pending process-wide bounding-set drop to @p, a task being
> > > + * created by the current thread.  Threads sharing the group read
> > > + * current->signal->cap_bset_pending directly; a forked child gets its own
> > > + * signal_struct and must carry the mask itself.  Called under
> > > + * current->sighand->siglock, which serializes it with cap_bset_drop_process().
> > > + */
> > > +void cap_bset_drop_fork(struct task_struct *p)
> > > +{
> > > +     kernel_cap_t mask = {
> > > +             .val = atomic64_read(&current->signal->cap_bset_pending),
> > > +     };
> > > +
> > > +     if (cap_isclear(mask) || p->signal == current->signal)
> > > +             return;
> > > +
> > > +     atomic64_or(mask.val, &p->signal->cap_bset_pending);
> > > +}
> > > +
> > > +static int cap_prctl_drop_mask(unsigned long low, unsigned long high)
> > > +{
> > > +     kernel_cap_t mask = mk_kernel_cap((u32)low, (u32)high);
> > > +
> > > +     if (cap_isclear(mask))
> > > +             return 0;
> > > +
> > > +     if (!ns_capable(current_user_ns(), CAP_SETPCAP))
> > > +             return -EPERM;
> > > +
> > > +     return cap_bset_drop_process(mask);
> > > +}
> > > +
> > >  /**
> > >   * cap_task_prctl - Implement process control functions for this security module
> > >   * @option: The process control function requested
> > > @@ -1308,11 +1388,16 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> > >       case PR_CAPBSET_READ:
> > >               if (!cap_valid(arg2))
> > >                       return -EINVAL;
> > > -             return !!cap_raised(old->cap_bset, arg2);
> > > +             return !!cap_raised(cap_bset_effective(current, old), arg2);
> > >
> > >       case PR_CAPBSET_DROP:
> > >               return cap_prctl_drop(arg2);
> > >
> > > +     case PR_CAPBSET_DROP_MASK:
> > > +             if (arg4 || arg5)
> > > +                     return -EINVAL;
> > > +             return cap_prctl_drop_mask(arg2, arg3);
> > > +
> > >       /*
> > >        * The next four prctl's remain to assist with transitioning a
> > >        * system from legacy UID=0 based privilege (when filesystem
> > > --
> > > 2.34.1

