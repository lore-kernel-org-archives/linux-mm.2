Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E305606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jyw3f3ez
Received: by kanga.kvack.org (Postfix)
	id 09D8D6B071A; Wed, 21 Oct 2026 10:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E056B071C; Wed, 21 Oct 2026 10:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FC46B071D; Wed, 21 Oct 2026 10:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEC836B071A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:42:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FAC5C0585
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:42:58 +0000 (UTC)
X-FDA: 85346900436.18.45DD8D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E0672000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:42:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jyw3f3ez;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of morgan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=morgan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792593776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5c8dJ2C9kocOc+QpEeRoxnt4qOwYqzibxX7LQBazUY=;
	b=qrXPnESvntl4N9891I1p39J8fIaQBqy6/26ag0EFf+iML/UuWawMkOtES53xAaVn0wrh/x
	XZYoXY2EThggPwRQsfzWU/C2xqQLa2eGZqLU94XrbFiebfBf03VjzIfFj5Vmyn4NoQj8YV
	vSBZIO1F0DgMRz5q0zU6mfTacvXnh/c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jyw3f3ez;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of morgan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=morgan@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792593776;
	b=sqnMfGnibkv+OZ7Vhyyh66Pena9LiHbzzY8q2v7bi4kmBffipgVrFDpYPuqcWs6aG0r2ge
	epMQ96Zh09muXhOC3CmG6l+6DIepL3aQ93iZzHozWxBrRMFZFyFFJjOG/8xWwrQPx5wAIw
	tiX5zbJyb5ZbkD6jxUHcawXXpd5Tzlc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 720AE43EE5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BEC1F000CE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792593775;
	bh=k5c8dJ2C9kocOc+QpEeRoxnt4qOwYqzibxX7LQBazUY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Jyw3f3ezwrlndH9Givay0JCwS7MLMtJHhej3yp/lIKXu5IdUP9x8rBI5Gffmomi0U
	 LvpyoE8OrrTUkbOZJMNDPqDHgTmbGvI361y/W+YSbWBL3QAwOBjU5w4JmCHC/JmHI0
	 8qFYhjJo6lib3afvIi13uVGJy3kE6soWtYng5T4fPNtho0VoDtihqPKyjuV4WRnhHZ
	 4OTz3UaJF5t37FYMPhzVizMlMCnxNuT16ZU7K8bsawxt7VBIjBeNfo4EWmgn3aY0s0
	 Sktk0p9AevN3JYu+3ySr8wTmv2OI/SgXcGTMQQXVccDUKSFJHZoggYxczhmWHkKAF3
	 kpBjk6ReRBgaw==
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ace9e6e1a5so1133898a91.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:42:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwUqpaeFT0g8SZOaVQuTGs4vReKxvuGeDAjmoxJEKiCHkBKukWVyD9p8L8zZ9pAai/gIQB9piOzaQ==@kvack.org
X-Gm-Message-State: AFq9FYJO14TAMyUSdxJp+3EFOTGV16qe3KJpW/FQxSBfRiJGuRd0yaNi
	eSOhEDao/ySOaOAzrQwQ+XAaMqd44ZkS5CR4RXrZ80ZfV+oSNTolMqBKks3NTWiQtup9ZdwYk1j
	yjLgt4txWrJR2pme10AHNzw+/hjRiWeY=
X-Received: by 2002:a17:90b:54cb:b0:3a4:7195:ecba with SMTP id
 98e67ed59e1d1-3ad86eed516mr1070459a91.20.1792593774768; Wed, 21 Oct 2026
 07:42:54 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com> <atjN3JX7sWx9kpQ5@hallyn.com>
In-Reply-To: <atjN3JX7sWx9kpQ5@hallyn.com>
From: "Andrew G. Morgan" <morgan@kernel.org>
Date: Wed, 21 Oct 2026 07:42:43 -0700
X-Gmail-Original-Message-ID: <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
X-Gm-Features: AclHuK8VpCzFoTf-puWToWEYcZE-hCU6pEvKbog_YpObEYZx-5WzGqZswN5CxgU
Message-ID: <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>, Oleg Nesterov <oleg@redhat.com>, kees@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, paul@paul-moore.com, jmorris@namei.org, 
	shuah@kernel.org, brauner@kernel.org, alexjlzheng@tencent.com, 
	jannh@google.com, jaime.saguillo@gmail.com, elver@google.com, 
	blbllhy@gmail.com, bvanassche@acm.org, pjw@kernel.org, broonie@kernel.org, 
	debug@rivosinc.com, tglx@kernel.org, aleksey.oladko@virtuozzo.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E0672000E
X-Stat-Signature: wx4yqb6hmrzu5mibht3xz3z1hh6yqdos
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792593776-161408
X-HE-Meta: U2FsdGVkX1/9RFxACwCXEA+6RE7RKGVANHAn06nw6fi1S7LauYyERrnFWRP8Tr4Fj1unJ4mktdWLJtDZqr49Nn6DIiJb+jzZODciwVqUKBqnunuSqUxbcxdzQPo2xEwMckDWb/MEGRCT3sS/otZuaWug4cvlhr6ZTvSB/F2i6zI0BYi1OigKB9z5KEHMUwxhc/sq3E1c8+VuMUcj5jd6XlphsBqP9aNfT9SSAMeD8H5I705i37RkJpgm4JZGgya2PhuUayP19iKYTI3T4li5CGBmoxSsWZWspxmafp88ONcKcKC1QVlu+ifdInUURSxsVA06N+c3Gn9EyyC3qkPbp8iRKhmdFWT220WYlEHjFpCr4dBKYWCKbSO79CssT7Ya+5wEG2z8VUHrqMGgOAh1HICSRKwMBvPIHqEq083cZKbXv2MufobBxlKDnN/A9CjDVSXmK4FvOQrI3ytrR2KXeqov6sDcxxiF/RlA5wdglhZIR0GDG77EILL2eEwaalNp3M0WkOfF1R7nYbyvzTWJAJs/9hm8KmD+hTT3sKCrL+mpfVVzRTzVtPqT3OlbHDXAjPTFFO4HK3eDY3Dnh7EuV+BIj7tAtKTWdci4ble55jiGb0IDsb9MPEP0QRMJatgiztjHM66Xt6ZiY34EHgqoY1R3eaZl1s4NVIPxBwyoLpQlCXBnc3cMojdN/oDgO1bBolqXXFYvqC4TA2aqb/mYscvHBCqd11j4s7Y6PFH10u+caYYzIfhvwx1gLss8FLYKKguxndV/N4i/GfXiCt19Duj3InOlUjxK0ZfkZfyzopoWMthmqlL+9ISaJYkXlb4PxoEkHibimGHoq8VuD2i2SuKugo3nObLczMqMaAgQKBbezmRjmi5/tOkZyixdqeLnoCiE3oTkgBB6KzPGhu8QHw8EfmOKgsTFeWgBCdJJgB8zEzOLZDhfFC0S0Kddnv3FN2enrNryKOZ8HPPwu1p
 xg31rzY2
 ZCJVW8Rysqs1qrSWCW3hzP4WLi+6ojJgWz/IaQBhsa9Ltwrg4QGnhNghXPsF8/AMA87KH5+HZtfN6/BReA9uw7joXCfmvg9xyleVKhE1+l0CPZ+LqVckYsiDUIACEZ0kvhZiFgwEeO9at84bB4eqx5P2ld5tbP7hd8uckEb6BIj3OOFFRW74HuqNdQZX11XnQPUPwMVPiNZMhBdCad2MPb2UZ6vTxqpxatdXKOpYy+PTq8VC0jE30QwmkMQ4yWerOabAdGvMeg6T2j0hC1IknAi6c0ZVBRZCmFTyRE2h7Uvj6wT0E1Xv1SY3YEjKP1elzd1qjOeZ6JV491JrvE4tHFwBqrE9zLI3fVtC39VcQlFi2OB/edHSObtqZaI17lpIHWwyNZhyEI7OZ+pRg42qkzuHKyXiijLRwj1NRlZvq2gcPpHad7pF/LlH5QAE/aOGzEEASYlnehomD0M0LG+BCtZ1RtfK1TH3ArtxjS6siMBfVzss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are a number of situations where existing code wants to
(temporarily) affect the capabilities of a single thread, so a
subsequent fork() starts with those without affecting the parent
process as a whole. I've been wondering if this code could be
structured to allow an argument of the prctl() to indicate if the call
is "whole process" or "just this thread" scoped?

Cheers

Andrew

On Wed, Oct 21, 2026 at 7:36=E2=80=AFAM Serge E. Hallyn <serge@hallyn.com> =
wrote:
>
> On Tue, Sep 29, 2026 at 09:01:59PM +0800, Jinjie Ruan wrote:
> > PR_CAPBSET_DROP only affects the calling thread. Process-wide capabilit=
y
> > dropping requires user space to loop over every thread and every
> > capability, which is highly expensive. For instance, long-lived
> > multi-threaded processes (like gVisor's sentry) spend milliseconds
> > trimming the bounding set because the runtime has to coordinate
> > and signal every thread.
> >
> > Add PR_CAPBSET_DROP_MASK, an opt-in prctl that removes a set of
> > capabilities from the entire thread group's bounding set in a single ca=
ll.
> > The capabilities are specified via a 64-bit mask across arg2 (low 32 bi=
ts)
> > and arg3 (high 32 bits).
> >
> > The drop is recorded in a per-thread-group mask,
> > signal_struct::cap_bset_pending, under sighand->siglock. This pending d=
rop
> > is dynamically folded into the bounding set in critical paths:
> > cap_capset(), PR_CAPBSET_READ(), and cap_bprm_creds_from_file().
> > Running, concurrently created, or future threads within the group will
> > all immediately observe the drop. A forked child inherits this mask
> > in cap_bset_drop_fork() under siglock to close the race window
> > against clone().
> >
> > The operation is drop-only, so concurrent callers commute and a single
> > atomic OR is the linearization point.  It performs no per-thread alloca=
tion
> > and only the caller's replacement cred can fail, reported synchronously=
 as
> > -ENOMEM before anything changes.
> >
> > In an arm64 KVM guest, trimming 41 capabilities of a multi-threaded Go
> > process takes ~8.5-23.6ms with the per-thread PR_CAPBSET_DROP loop and
> > ~11-14us with PR_CAPBSET_DROP_MASK, independent of the thread count.
> >
> > Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>
> Interesting idea, storing it in the sighand.
>
> Oleg, do you see any issues with that part of this?
>
> Overall, this seems ok to me.  That is, I think it addresses all the
> concerns I had with the previous version.
>
> > ---
> >  fs/proc/array.c              |  3 +-
> >  include/linux/capability.h   |  5 ++
> >  include/linux/sched/signal.h |  8 ++++
> >  include/uapi/linux/prctl.h   |  1 +
> >  kernel/fork.c                |  1 +
> >  security/commoncap.c         | 91 ++++++++++++++++++++++++++++++++++--
> >  6 files changed, 105 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > index f6f75d206762..f1cde26d079c 100644
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -63,6 +63,7 @@
> >  #include <linux/tty.h>
> >  #include <linux/string.h>
> >  #include <linux/mman.h>
> > +#include <linux/capability.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/sched/numa_balancing.h>
> >  #include <linux/sched/task_stack.h>
> > @@ -318,7 +319,7 @@ static inline void task_cap(struct seq_file *m, str=
uct task_struct *p)
> >       cap_inheritable =3D cred->cap_inheritable;
> >       cap_permitted   =3D cred->cap_permitted;
> >       cap_effective   =3D cred->cap_effective;
> > -     cap_bset        =3D cred->cap_bset;
> > +     cap_bset        =3D cap_bset_effective(p, cred);
> >       cap_ambient     =3D cred->cap_ambient;
> >       rcu_read_unlock();
> >
> > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > index 7921a0b3b04a..6413c7fedb69 100644
> > --- a/include/linux/capability.h
> > +++ b/include/linux/capability.h
> > @@ -38,6 +38,7 @@ struct file;
> >  struct inode;
> >  struct dentry;
> >  struct task_struct;
> > +struct cred;
> >  struct user_namespace;
> >  struct mnt_idmap;
> >
> > @@ -197,6 +198,10 @@ bool capable_wrt_inode_uidgid(struct mnt_idmap *id=
map,
> >                             const struct inode *inode, int cap);
> >  extern bool file_ns_capable(const struct file *file, struct user_names=
pace *ns, int cap);
> >  extern bool ptracer_capable(struct task_struct *tsk, struct user_names=
pace *ns);
> > +extern kernel_cap_t cap_bset_effective(const struct task_struct *task,
> > +                                    const struct cred *cred);
> > +extern void cap_bset_drop_fork(struct task_struct *p);
> > +
> >  static inline bool perfmon_capable(void)
> >  {
> >       return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
> > diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.=
h
> > index d45a5476b97d..bda6f18b65b9 100644
> > --- a/include/linux/sched/signal.h
> > +++ b/include/linux/sched/signal.h
> > @@ -98,6 +98,14 @@ struct signal_struct {
> >       int                     quick_threads;
> >       struct list_head        thread_head;
> >
> > +     /*
> > +      * Capabilities being removed from the bounding set of every thre=
ad in
> > +      * this group by PR_CAPBSET_DROP_MASK.  Read on capability-transi=
tion
> > +      * paths without sighand->siglock, hence atomic64 (a 64-bit value=
 would
> > +      * otherwise tear on 32-bit).
> > +      */
> > +     atomic64_t              cap_bset_pending;
> > +
> >       wait_queue_head_t       wait_chldexit;  /* for wait4() */
> >
> >       /* current thread group signal load-balancing target: */
> > diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> > index b6ec6f693719..85ac71897070 100644
> > --- a/include/uapi/linux/prctl.h
> > +++ b/include/uapi/linux/prctl.h
> > @@ -70,6 +70,7 @@
> >  /* Get/set the capability bounding set (as per security/commoncap.c) *=
/
> >  #define PR_CAPBSET_READ 23
> >  #define PR_CAPBSET_DROP 24
> > +#define PR_CAPBSET_DROP_MASK 82
> >
> >  /* Get/set the process' ability to use the timestamp counter instructi=
on */
> >  #define PR_GET_TSC 25
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 5ef413368912..bf671a85d39d 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2504,6 +2504,7 @@ __latent_entropy struct task_struct *copy_process=
(
> >        * before holding sighand lock.
> >        */
> >       copy_seccomp(p);
> > +     cap_bset_drop_fork(p);
> >
> >       if (clone_flags & CLONE_NNP)
> >               task_set_no_new_privs(p);
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 3399535808fe..3bec15d43731 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -3,6 +3,7 @@
> >   */
> >
> >  #include <linux/capability.h>
> > +#include <linux/cred.h>
> >  #include <linux/audit.h>
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> > @@ -19,6 +20,7 @@
> >  #include <linux/hugetlb.h>
> >  #include <linux/mount.h>
> >  #include <linux/sched.h>
> > +#include <linux/sched/signal.h>
> >  #include <linux/prctl.h>
> >  #include <linux/securebits.h>
> >  #include <linux/user_namespace.h>
> > @@ -30,6 +32,25 @@
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/capability.h>
> >
> > +/**
> > + * Effective bounding set of @cred in @task's thread group
> > + * @task: task whose thread group's pending drop applies
> > + * @cred: credentials to read the bounding set from
> > + *
> > + * A drop recorded by PR_CAPBSET_DROP_MASK is authoritative on the thr=
ead group
> > + * and may not have been materialized into every thread's cred yet, so=
 the
> > + * effective bounding set is the cred's own set minus the group's pend=
ing drop.
> > + */
> > +kernel_cap_t cap_bset_effective(const struct task_struct *task,
> > +                             const struct cred *cred)
> > +{
> > +     kernel_cap_t pending =3D {
> > +             .val =3D atomic64_read(&task->signal->cap_bset_pending),
> > +     };
> > +
> > +     return cap_drop(cred->cap_bset, pending);
> > +}
> > +
> >  /*
> >   * If a non-root user executes a setuid-root binary in
> >   * !secure(SECURE_NOROOT) mode, then we raise capabilities.
> > @@ -284,8 +305,8 @@ int cap_capset(struct cred *new,
> >
> >       if (!cap_issubset(*inheritable,
> >                         cap_combine(old->cap_inheritable,
> > -                                   old->cap_bset)))
> >               /* no new pI capabilities outside bounding set */
> > +                                   cap_bset_effective(current, old))))
> >               return -EPERM;
> >
> >       /* verify restrictions on target's new Permitted set */
> > @@ -849,7 +870,7 @@ static void handle_privileged_root(struct linux_bin=
prm *bprm, bool has_fcap,
> >        */
> >       if (__is_eff(root_uid, new) || __is_real(root_uid, new)) {
> >               /* pP' =3D (cap_bset & ~0) | (pI & ~0) */
> > -             new->cap_permitted =3D cap_combine(old->cap_bset,
> > +             new->cap_permitted =3D cap_combine(new->cap_bset,
> >                                                old->cap_inheritable);
> >       }
> >       /*
> > @@ -925,6 +946,8 @@ int cap_bprm_creds_from_file(struct linux_binprm *b=
prm, const struct file *file)
> >       int ret;
> >       kuid_t root_uid;
> >
> > +     new->cap_bset =3D cap_bset_effective(current, new);
> > +
> >       if (WARN_ON(!cap_ambient_invariant_ok(old)))
> >               return -EPERM;
> >
> > @@ -1283,6 +1306,63 @@ static int cap_prctl_drop(unsigned long cap)
> >       return commit_creds(new);
> >  }
> >
> > +static int cap_bset_drop_process(kernel_cap_t mask)
> > +{
> > +     kernel_cap_t pending;
> > +     struct cred *new;
> > +
> > +     new =3D prepare_creds();
> > +     if (!new)
> > +             return -ENOMEM;
> > +
> > +     /*
> > +      * Record the drop before committing the caller's cred, so that a
> > +      * thread created from now on is guaranteed to observe it.  Apply=
 the
> > +      * current union, not just this call's mask, to the caller's cred=
.
> > +      */
> > +     spin_lock_irq(&current->sighand->siglock);
> > +     atomic64_or(mask.val, &current->signal->cap_bset_pending);
> > +     pending.val =3D atomic64_read(&current->signal->cap_bset_pending)=
;
> > +     spin_unlock_irq(&current->sighand->siglock);
> > +
> > +     new->cap_bset =3D cap_drop(new->cap_bset, pending);
> > +     commit_creds(new);
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * Propagate a pending process-wide bounding-set drop to @p, a task be=
ing
> > + * created by the current thread.  Threads sharing the group read
> > + * current->signal->cap_bset_pending directly; a forked child gets its=
 own
> > + * signal_struct and must carry the mask itself.  Called under
> > + * current->sighand->siglock, which serializes it with cap_bset_drop_p=
rocess().
> > + */
> > +void cap_bset_drop_fork(struct task_struct *p)
> > +{
> > +     kernel_cap_t mask =3D {
> > +             .val =3D atomic64_read(&current->signal->cap_bset_pending=
),
> > +     };
> > +
> > +     if (cap_isclear(mask) || p->signal =3D=3D current->signal)
> > +             return;
> > +
> > +     atomic64_or(mask.val, &p->signal->cap_bset_pending);
> > +}
> > +
> > +static int cap_prctl_drop_mask(unsigned long low, unsigned long high)
> > +{
> > +     kernel_cap_t mask =3D mk_kernel_cap((u32)low, (u32)high);
> > +
> > +     if (cap_isclear(mask))
> > +             return 0;
> > +
> > +     if (!ns_capable(current_user_ns(), CAP_SETPCAP))
> > +             return -EPERM;
> > +
> > +     return cap_bset_drop_process(mask);
> > +}
> > +
> >  /**
> >   * cap_task_prctl - Implement process control functions for this secur=
ity module
> >   * @option: The process control function requested
> > @@ -1308,11 +1388,16 @@ int cap_task_prctl(int option, unsigned long ar=
g2, unsigned long arg3,
> >       case PR_CAPBSET_READ:
> >               if (!cap_valid(arg2))
> >                       return -EINVAL;
> > -             return !!cap_raised(old->cap_bset, arg2);
> > +             return !!cap_raised(cap_bset_effective(current, old), arg=
2);
> >
> >       case PR_CAPBSET_DROP:
> >               return cap_prctl_drop(arg2);
> >
> > +     case PR_CAPBSET_DROP_MASK:
> > +             if (arg4 || arg5)
> > +                     return -EINVAL;
> > +             return cap_prctl_drop_mask(arg2, arg3);
> > +
> >       /*
> >        * The next four prctl's remain to assist with transitioning a
> >        * system from legacy UID=3D0 based privilege (when filesystem
> > --
> > 2.34.1

