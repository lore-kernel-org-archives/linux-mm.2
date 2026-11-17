Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9494606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcoPXT8n
Received: by kanga.kvack.org (Postfix)
	id E9BA56B05B2; Tue, 17 Nov 2026 15:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25686B05B3; Tue, 17 Nov 2026 15:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECAF6B05B4; Tue, 17 Nov 2026 15:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A53616B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:32:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DBA9804BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:32:34 +0000 (UTC)
X-FDA: 85445759028.18.CF29CB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B0EC180002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:32:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcoPXT8n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of morgan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=morgan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794947552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqaQtI2fC8lfSjdxuGSUaDwM6PKhC5J5LIM8z3yhrrU=;
	b=7g1UPI6HrX3xkFGpphZU6S+ZWTimj/zLrQoCFfPBZhuu+UAVNphwVCUEINsFhKO4tMruCX
	y/rZGcMIlEMqc2ap3ymuc34tcDqVvRGt+I0gP+DW5hVnDvzuAlUSa5gYt5WpMJ9amOU/Ua
	dFFhA0sxlERd1Mp2TGD+kOH34kjP3mI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794947552;
	b=sM3dbjbGmR9GPExr0WghvXRMu8h7vximvqHWKW196glYQHeBrnwSXqVT0yXgoHyTsZdQf6
	lgPJY9i7atggjboCiijbfzgHVccX2zXx1prjK/l9SoIqfMq0b9Mab6CEkLD2ABzr1G9d+Q
	BLOBZtzG+Tq6CQ4iSDP+5dUaOcD48aw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcoPXT8n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of morgan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=morgan@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6176445E1A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E811F000CB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794947551;
	bh=GqaQtI2fC8lfSjdxuGSUaDwM6PKhC5J5LIM8z3yhrrU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZcoPXT8nwFxGDqRwaatf0vEWZVuABrrI7ojuWjaIc2SCdEfo6nHeN62IH+qPhdNSw
	 OnZNj/a+kEZ+7Q45bgug2/1kE6SvBmhrPalYIWz49NV48SqjMSRNyBJqLh6Un5qTUP
	 VznUNBj2Sr128zJIvwUjgUEFBGkt2H3tH4YfSHy9sD4NOTW5vMqfogSUAVA7L2HPTW
	 F/3BIDRlr0qdUIIfTSkBA4kjxdSlRFCtUZKTp07qylOYRt+aLCfdC1anAlCRH2bYx8
	 H4GMaFF9lqhtGYTv9WaoXpnsunp6eCvJWGpBtL8rY222o/ta2E30kJIuyjEK2vBiZY
	 wWqlfAlqno08Q==
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb1199bfd8so150911a12.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:32:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFq8IUqtJegPQVzYYGP9R8C/maLCRyQ3+rRVPQAmapLfelwrWq33n7mP0cTX3bhVPNz5VMuM44F3w==@kvack.org
X-Gm-Message-State: APuU4Z/Syt+OdgbJSNfhmOWmQpap+JKPCJosTGSsiqz+LP12FmQ1XiwM
	VihyDWKKtPllpojpW6eHuAlNA63fIuOHSt/9DwoRKRY88R8jGaOzVSLLXc8VnP3rpzhE+klPzJX
	VSbyIRTeEaW1f8rGybaNIt5HAzDH9vnI=
X-Received: by 2002:a17:90b:2805:b0:3b0:aaed:48d0 with SMTP id
 98e67ed59e1d1-3b3d07a23a3mr543066a91.37.1794947550414; Tue, 17 Nov 2026
 12:32:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com> <atjN3JX7sWx9kpQ5@hallyn.com>
 <CACmP8ULW+COA17s6_UUKhQrJaviWmnUCjfite43Y0FgPN30-AQ@mail.gmail.com>
 <avHfxe++P4WLUQxf@hallyn.com> <80ff9aea-3a5c-4c92-b713-99c249564008@huawei.com>
In-Reply-To: <80ff9aea-3a5c-4c92-b713-99c249564008@huawei.com>
From: "Andrew G. Morgan" <morgan@kernel.org>
Date: Tue, 17 Nov 2026 12:32:17 -0800
X-Gmail-Original-Message-ID: <CACmP8UK=b4Hkivzf77BJ-S_CR94+AgpNs_EfQ4i=CHL3+=0Y6Q@mail.gmail.com>
X-Gm-Features: AclHuK_avYa_dJFxm6ZoqFYvunKpf_7Vv8MTzbp35jYWl588q9LTbO3-Gb4byKQ
Message-ID: <CACmP8UK=b4Hkivzf77BJ-S_CR94+AgpNs_EfQ4i=CHL3+=0Y6Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>, kees@kernel.org, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2B0EC180002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i8d9rzhj4gb3xtfu4zi9hyg5dg1xh4kp
X-Rspam-User: 
X-HE-Tag: 1794947552-15201
X-HE-Meta: U2FsdGVkX19k08ChCX6Tz2yS6Aom9YIJNx1WLfJrT7zCLPk1MNDGSzW4DTKs8PI9wtHlAb4Q14z7KopM614Dd2Onl4l8kKwWLsarrrSIGezioYQoRTzPNDtk7MeNxnMTusY72w/xhqi8beleFddbHx6nObnwRwRCcHYnroA7FEsInS/o1ZfXuYp3wcIxWBmufRKiRwdHODuHcazD7BRY1kNUjv4r+o88U6D6Vu9BMVC0WxPGtIBFXAf4LqKw0nRxLcnQTA4R071knFfeUVZDXtBBpuZ/RFmIVPKvsWafbGJZsAykqq240ZAbW6YPsqobcCoSbx2/RS4SBadTxKcd92zz9NGK/Ut/lfHLv6OCO8lVn8cakZ+vRR3rdT7uxMbG8vDfefckylJKT/kYPrWH/S7Wzjnsm/0NMK68nmObENthJUzo2ZHYkWnOUWkhfknhbsVZy6xeZCH2M7FJzu+0p+Jqw3VyQrtevZzPhlfrQA+rK4C5q4JE4oqzRtpWZUeKd0SfYK+4oDP7beA9ycTDh8hxmr0j1Ng0yoBUdfwp5ahdDw7sfUdb39SKEWdeNz83hwGRhm9j59g50SmJC/qNedWNV1LAwIwXCbxwB4C1sNiH4FeeFxlh1uWw7hHuEN5Wq87M6IuV+SIIiIt+3yNAvQhuFtoqTAaUYHfSdgRum7fCd0ZaA1oAk5L6vhMgum6cn1SV0nHBkIgOpqC9qQjt9yln7LgR599jlrHSI90htrEUasGhJ3BI/8FGlEhh80vntLPO/tJEkPHU5MO4l8zfI91Y9w8YenOXIduX5u3YscpwNNqVz1WEcc5ZVSuC87yfOXIKuHLnsdYyrbI9wjK5bTNwK3PNa90POHKLAJeehd/+qXBSzRIynIgQN/bjnWgUjQ6v2NLGBcQ3LaI01MAFhIL1OQSg7qPKiHtPC8A/+zsTdRo3DjNsXht7nbwyM1yUBYF4lLYRl3EpgrCOH2Q
 KJNNH3fD
 BA1hELGcLwMptMKeWGyn8ubHsDyfTtULw86vVC47XdA+U/0CV8L4A+srog4ePEnwOjWU3ebu3+RbpzhVRC3k7CD3cck5S4PR1+E00Ur7wLBgpH8/tOavp73Y8O6Kll3u3vSejG5X9U05052jl+kEyDlEsfa9CqNhxqNoVtD7ltTQFadlG98TJrvYbFUO5WKXmmVEPTNZmXFqWGUUyDjfkgLGd+CIVGqFVmUzFbWuE522J6hlU8gmgYHivGPFxnyuhDCS+1/dL8+buoa+TSi3jkc+NumKfv8+PMO1pntG280hi+g6hzD3iO2WoW0G3JTO+GnOKmo3u2M3poGQuSrlsBBysQXgl4i3IYe7yJTIZ00QAnMl7CZvMRbWv9cUL2oqGSNvvNhW/lgMscQa3axUR9+qwgPPGD+QMGnNzfejrPhw2RrXiDvv9dVfqOJr0f0XKU7JU3uZ5v6H9/OgEFep5GmwlqF7yBEJw6xN5iNbzyTjw0lE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LGTM but reflecting on the likely lack of further expansion for that
new argument, I would have likely gone with different
prctl(PR_CAPBSET_*,...) values for the two scopes of operation.

Cheers

Andrew

On Mon, Nov 16, 2026 at 10:39=E2=80=AFPM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:
>
>
>
> =E5=9C=A8 2026/11/9 22:59, Serge E. Hallyn =E5=86=99=E9=81=93:
> > Hi Jinjie,
> >
> > how do you feel about adding something like a thread | process flag?
>
> Hi Serge, Andrew,
>
> Sorry for replying so late.
>
> I think this sounds good for me, similar to seccomp's
> SECCOMP_FILTER_FLAG_TSYNC: by default only the calling thread's bounding
> set is trimmed (so a later fork() inherits it while the rest of the
> process is untouched), and PR_CAPBSET_DROP_PROCESS applies it to the
> whole thread group.
>
> Is it similar to the following code?
>
>
> #define PR_CAPBSET_DROP_MASK          <n>
> #define PR_CAPBSET_DROP_THREAD         0
> #define PR_CAPBSET_DROP_PROCESS        1
>
> User space use as below:
>
>         prctl(PR_CAPBSET_DROP_MASK, lo, hi, PR_CAPBSET_DROP_THREAD, 0);
>         prctl(PR_CAPBSET_DROP_MASK, lo, hi, PR_CAPBSET_DROP_PROCESS, 0);
>
> # cap_task_prctl()
> case PR_CAPBSET_DROP_MASK:
>         switch (arg4) {
>         case PR_CAPBSET_DROP_THREAD:
>                 return cap_prctl_drop_mask(arg2, arg3, false);
>
>         case PR_CAPBSET_DROP_PROCESS:
>                 return cap_prctl_drop_mask(arg2, arg3, true);
>
>         default:
>                 return -EINVAL;
>         }
>
> static int cap_bset_drop_thread(kernel_cap_t mask)
> {
>         struct cred *new =3D prepare_creds();
>
>         if (!new)
>                 return -ENOMEM;
>
>         new->cap_bset =3D cap_drop(new->cap_bset, mask);
>         return commit_creds(new);
> }
>
> Best regards,
> Jinjie
>
> >
> > On Wed, Oct 21, 2026 at 07:42:43AM -0700, Andrew G. Morgan wrote:
> >> There are a number of situations where existing code wants to
> >> (temporarily) affect the capabilities of a single thread, so a
> >> subsequent fork() starts with those without affecting the parent
> >> process as a whole. I've been wondering if this code could be
> >> structured to allow an argument of the prctl() to indicate if the call
> >> is "whole process" or "just this thread" scoped?
> >>
> >> Cheers
> >>
> >> Andrew
> >>
> >> On Wed, Oct 21, 2026 at 7:36=E2=80=AFAM Serge E. Hallyn <serge@hallyn.=
com> wrote:
> >>>
> >>> On Tue, Sep 29, 2026 at 09:01:59PM +0800, Jinjie Ruan wrote:
> >>>> PR_CAPBSET_DROP only affects the calling thread. Process-wide capabi=
lity
> >>>> dropping requires user space to loop over every thread and every
> >>>> capability, which is highly expensive. For instance, long-lived
> >>>> multi-threaded processes (like gVisor's sentry) spend milliseconds
> >>>> trimming the bounding set because the runtime has to coordinate
> >>>> and signal every thread.
> >>>>
> >>>> Add PR_CAPBSET_DROP_MASK, an opt-in prctl that removes a set of
> >>>> capabilities from the entire thread group's bounding set in a single=
 call.
> >>>> The capabilities are specified via a 64-bit mask across arg2 (low 32=
 bits)
> >>>> and arg3 (high 32 bits).
> >>>>
> >>>> The drop is recorded in a per-thread-group mask,
> >>>> signal_struct::cap_bset_pending, under sighand->siglock. This pendin=
g drop
> >>>> is dynamically folded into the bounding set in critical paths:
> >>>> cap_capset(), PR_CAPBSET_READ(), and cap_bprm_creds_from_file().
> >>>> Running, concurrently created, or future threads within the group wi=
ll
> >>>> all immediately observe the drop. A forked child inherits this mask
> >>>> in cap_bset_drop_fork() under siglock to close the race window
> >>>> against clone().
> >>>>
> >>>> The operation is drop-only, so concurrent callers commute and a sing=
le
> >>>> atomic OR is the linearization point.  It performs no per-thread all=
ocation
> >>>> and only the caller's replacement cred can fail, reported synchronou=
sly as
> >>>> -ENOMEM before anything changes.
> >>>>
> >>>> In an arm64 KVM guest, trimming 41 capabilities of a multi-threaded =
Go
> >>>> process takes ~8.5-23.6ms with the per-thread PR_CAPBSET_DROP loop a=
nd
> >>>> ~11-14us with PR_CAPBSET_DROP_MASK, independent of the thread count.
> >>>>
> >>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> >>>
> >>> Interesting idea, storing it in the sighand.
> >>>
> >>> Oleg, do you see any issues with that part of this?
> >>>
> >>> Overall, this seems ok to me.  That is, I think it addresses all the
> >>> concerns I had with the previous version.
> >>>
> >>>> ---
> >>>>  fs/proc/array.c              |  3 +-
> >>>>  include/linux/capability.h   |  5 ++
> >>>>  include/linux/sched/signal.h |  8 ++++
> >>>>  include/uapi/linux/prctl.h   |  1 +
> >>>>  kernel/fork.c                |  1 +
> >>>>  security/commoncap.c         | 91 +++++++++++++++++++++++++++++++++=
+--
> >>>>  6 files changed, 105 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/fs/proc/array.c b/fs/proc/array.c
> >>>> index f6f75d206762..f1cde26d079c 100644
> >>>> --- a/fs/proc/array.c
> >>>> +++ b/fs/proc/array.c
> >>>> @@ -63,6 +63,7 @@
> >>>>  #include <linux/tty.h>
> >>>>  #include <linux/string.h>
> >>>>  #include <linux/mman.h>
> >>>> +#include <linux/capability.h>
> >>>>  #include <linux/sched/mm.h>
> >>>>  #include <linux/sched/numa_balancing.h>
> >>>>  #include <linux/sched/task_stack.h>
> >>>> @@ -318,7 +319,7 @@ static inline void task_cap(struct seq_file *m, =
struct task_struct *p)
> >>>>       cap_inheritable =3D cred->cap_inheritable;
> >>>>       cap_permitted   =3D cred->cap_permitted;
> >>>>       cap_effective   =3D cred->cap_effective;
> >>>> -     cap_bset        =3D cred->cap_bset;
> >>>> +     cap_bset        =3D cap_bset_effective(p, cred);
> >>>>       cap_ambient     =3D cred->cap_ambient;
> >>>>       rcu_read_unlock();
> >>>>
> >>>> diff --git a/include/linux/capability.h b/include/linux/capability.h
> >>>> index 7921a0b3b04a..6413c7fedb69 100644
> >>>> --- a/include/linux/capability.h
> >>>> +++ b/include/linux/capability.h
> >>>> @@ -38,6 +38,7 @@ struct file;
> >>>>  struct inode;
> >>>>  struct dentry;
> >>>>  struct task_struct;
> >>>> +struct cred;
> >>>>  struct user_namespace;
> >>>>  struct mnt_idmap;
> >>>>
> >>>> @@ -197,6 +198,10 @@ bool capable_wrt_inode_uidgid(struct mnt_idmap =
*idmap,
> >>>>                             const struct inode *inode, int cap);
> >>>>  extern bool file_ns_capable(const struct file *file, struct user_na=
mespace *ns, int cap);
> >>>>  extern bool ptracer_capable(struct task_struct *tsk, struct user_na=
mespace *ns);
> >>>> +extern kernel_cap_t cap_bset_effective(const struct task_struct *ta=
sk,
> >>>> +                                    const struct cred *cred);
> >>>> +extern void cap_bset_drop_fork(struct task_struct *p);
> >>>> +
> >>>>  static inline bool perfmon_capable(void)
> >>>>  {
> >>>>       return capable(CAP_PERFMON) || capable(CAP_SYS_ADMIN);
> >>>> diff --git a/include/linux/sched/signal.h b/include/linux/sched/sign=
al.h
> >>>> index d45a5476b97d..bda6f18b65b9 100644
> >>>> --- a/include/linux/sched/signal.h
> >>>> +++ b/include/linux/sched/signal.h
> >>>> @@ -98,6 +98,14 @@ struct signal_struct {
> >>>>       int                     quick_threads;
> >>>>       struct list_head        thread_head;
> >>>>
> >>>> +     /*
> >>>> +      * Capabilities being removed from the bounding set of every t=
hread in
> >>>> +      * this group by PR_CAPBSET_DROP_MASK.  Read on capability-tra=
nsition
> >>>> +      * paths without sighand->siglock, hence atomic64 (a 64-bit va=
lue would
> >>>> +      * otherwise tear on 32-bit).
> >>>> +      */
> >>>> +     atomic64_t              cap_bset_pending;
> >>>> +
> >>>>       wait_queue_head_t       wait_chldexit;  /* for wait4() */
> >>>>
> >>>>       /* current thread group signal load-balancing target: */
> >>>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> >>>> index b6ec6f693719..85ac71897070 100644
> >>>> --- a/include/uapi/linux/prctl.h
> >>>> +++ b/include/uapi/linux/prctl.h
> >>>> @@ -70,6 +70,7 @@
> >>>>  /* Get/set the capability bounding set (as per security/commoncap.c=
) */
> >>>>  #define PR_CAPBSET_READ 23
> >>>>  #define PR_CAPBSET_DROP 24
> >>>> +#define PR_CAPBSET_DROP_MASK 82
> >>>>
> >>>>  /* Get/set the process' ability to use the timestamp counter instru=
ction */
> >>>>  #define PR_GET_TSC 25
> >>>> diff --git a/kernel/fork.c b/kernel/fork.c
> >>>> index 5ef413368912..bf671a85d39d 100644
> >>>> --- a/kernel/fork.c
> >>>> +++ b/kernel/fork.c
> >>>> @@ -2504,6 +2504,7 @@ __latent_entropy struct task_struct *copy_proc=
ess(
> >>>>        * before holding sighand lock.
> >>>>        */
> >>>>       copy_seccomp(p);
> >>>> +     cap_bset_drop_fork(p);
> >>>>
> >>>>       if (clone_flags & CLONE_NNP)
> >>>>               task_set_no_new_privs(p);
> >>>> diff --git a/security/commoncap.c b/security/commoncap.c
> >>>> index 3399535808fe..3bec15d43731 100644
> >>>> --- a/security/commoncap.c
> >>>> +++ b/security/commoncap.c
> >>>> @@ -3,6 +3,7 @@
> >>>>   */
> >>>>
> >>>>  #include <linux/capability.h>
> >>>> +#include <linux/cred.h>
> >>>>  #include <linux/audit.h>
> >>>>  #include <linux/init.h>
> >>>>  #include <linux/kernel.h>
> >>>> @@ -19,6 +20,7 @@
> >>>>  #include <linux/hugetlb.h>
> >>>>  #include <linux/mount.h>
> >>>>  #include <linux/sched.h>
> >>>> +#include <linux/sched/signal.h>
> >>>>  #include <linux/prctl.h>
> >>>>  #include <linux/securebits.h>
> >>>>  #include <linux/user_namespace.h>
> >>>> @@ -30,6 +32,25 @@
> >>>>  #define CREATE_TRACE_POINTS
> >>>>  #include <trace/events/capability.h>
> >>>>
> >>>> +/**
> >>>> + * Effective bounding set of @cred in @task's thread group
> >>>> + * @task: task whose thread group's pending drop applies
> >>>> + * @cred: credentials to read the bounding set from
> >>>> + *
> >>>> + * A drop recorded by PR_CAPBSET_DROP_MASK is authoritative on the =
thread group
> >>>> + * and may not have been materialized into every thread's cred yet,=
 so the
> >>>> + * effective bounding set is the cred's own set minus the group's p=
ending drop.
> >>>> + */
> >>>> +kernel_cap_t cap_bset_effective(const struct task_struct *task,
> >>>> +                             const struct cred *cred)
> >>>> +{
> >>>> +     kernel_cap_t pending =3D {
> >>>> +             .val =3D atomic64_read(&task->signal->cap_bset_pending=
),
> >>>> +     };
> >>>> +
> >>>> +     return cap_drop(cred->cap_bset, pending);
> >>>> +}
> >>>> +
> >>>>  /*
> >>>>   * If a non-root user executes a setuid-root binary in
> >>>>   * !secure(SECURE_NOROOT) mode, then we raise capabilities.
> >>>> @@ -284,8 +305,8 @@ int cap_capset(struct cred *new,
> >>>>
> >>>>       if (!cap_issubset(*inheritable,
> >>>>                         cap_combine(old->cap_inheritable,
> >>>> -                                   old->cap_bset)))
> >>>>               /* no new pI capabilities outside bounding set */
> >>>> +                                   cap_bset_effective(current, old)=
)))
> >>>>               return -EPERM;
> >>>>
> >>>>       /* verify restrictions on target's new Permitted set */
> >>>> @@ -849,7 +870,7 @@ static void handle_privileged_root(struct linux_=
binprm *bprm, bool has_fcap,
> >>>>        */
> >>>>       if (__is_eff(root_uid, new) || __is_real(root_uid, new)) {
> >>>>               /* pP' =3D (cap_bset & ~0) | (pI & ~0) */
> >>>> -             new->cap_permitted =3D cap_combine(old->cap_bset,
> >>>> +             new->cap_permitted =3D cap_combine(new->cap_bset,
> >>>>                                                old->cap_inheritable)=
;
> >>>>       }
> >>>>       /*
> >>>> @@ -925,6 +946,8 @@ int cap_bprm_creds_from_file(struct linux_binprm=
 *bprm, const struct file *file)
> >>>>       int ret;
> >>>>       kuid_t root_uid;
> >>>>
> >>>> +     new->cap_bset =3D cap_bset_effective(current, new);
> >>>> +
> >>>>       if (WARN_ON(!cap_ambient_invariant_ok(old)))
> >>>>               return -EPERM;
> >>>>
> >>>> @@ -1283,6 +1306,63 @@ static int cap_prctl_drop(unsigned long cap)
> >>>>       return commit_creds(new);
> >>>>  }
> >>>>
> >>>> +static int cap_bset_drop_process(kernel_cap_t mask)
> >>>> +{
> >>>> +     kernel_cap_t pending;
> >>>> +     struct cred *new;
> >>>> +
> >>>> +     new =3D prepare_creds();
> >>>> +     if (!new)
> >>>> +             return -ENOMEM;
> >>>> +
> >>>> +     /*
> >>>> +      * Record the drop before committing the caller's cred, so tha=
t a
> >>>> +      * thread created from now on is guaranteed to observe it.  Ap=
ply the
> >>>> +      * current union, not just this call's mask, to the caller's c=
red.
> >>>> +      */
> >>>> +     spin_lock_irq(&current->sighand->siglock);
> >>>> +     atomic64_or(mask.val, &current->signal->cap_bset_pending);
> >>>> +     pending.val =3D atomic64_read(&current->signal->cap_bset_pendi=
ng);
> >>>> +     spin_unlock_irq(&current->sighand->siglock);
> >>>> +
> >>>> +     new->cap_bset =3D cap_drop(new->cap_bset, pending);
> >>>> +     commit_creds(new);
> >>>> +
> >>>> +     return 0;
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * Propagate a pending process-wide bounding-set drop to @p, a task=
 being
> >>>> + * created by the current thread.  Threads sharing the group read
> >>>> + * current->signal->cap_bset_pending directly; a forked child gets =
its own
> >>>> + * signal_struct and must carry the mask itself.  Called under
> >>>> + * current->sighand->siglock, which serializes it with cap_bset_dro=
p_process().
> >>>> + */
> >>>> +void cap_bset_drop_fork(struct task_struct *p)
> >>>> +{
> >>>> +     kernel_cap_t mask =3D {
> >>>> +             .val =3D atomic64_read(&current->signal->cap_bset_pend=
ing),
> >>>> +     };
> >>>> +
> >>>> +     if (cap_isclear(mask) || p->signal =3D=3D current->signal)
> >>>> +             return;
> >>>> +
> >>>> +     atomic64_or(mask.val, &p->signal->cap_bset_pending);
> >>>> +}
> >>>> +
> >>>> +static int cap_prctl_drop_mask(unsigned long low, unsigned long hig=
h)
> >>>> +{
> >>>> +     kernel_cap_t mask =3D mk_kernel_cap((u32)low, (u32)high);
> >>>> +
> >>>> +     if (cap_isclear(mask))
> >>>> +             return 0;
> >>>> +
> >>>> +     if (!ns_capable(current_user_ns(), CAP_SETPCAP))
> >>>> +             return -EPERM;
> >>>> +
> >>>> +     return cap_bset_drop_process(mask);
> >>>> +}
> >>>> +
> >>>>  /**
> >>>>   * cap_task_prctl - Implement process control functions for this se=
curity module
> >>>>   * @option: The process control function requested
> >>>> @@ -1308,11 +1388,16 @@ int cap_task_prctl(int option, unsigned long=
 arg2, unsigned long arg3,
> >>>>       case PR_CAPBSET_READ:
> >>>>               if (!cap_valid(arg2))
> >>>>                       return -EINVAL;
> >>>> -             return !!cap_raised(old->cap_bset, arg2);
> >>>> +             return !!cap_raised(cap_bset_effective(current, old), =
arg2);
> >>>>
> >>>>       case PR_CAPBSET_DROP:
> >>>>               return cap_prctl_drop(arg2);
> >>>>
> >>>> +     case PR_CAPBSET_DROP_MASK:
> >>>> +             if (arg4 || arg5)
> >>>> +                     return -EINVAL;
> >>>> +             return cap_prctl_drop_mask(arg2, arg3);
> >>>> +
> >>>>       /*
> >>>>        * The next four prctl's remain to assist with transitioning a
> >>>>        * system from legacy UID=3D0 based privilege (when filesystem
> >>>> --
> >>>> 2.34.1
>

