Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B3EFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8716B0088; Mon, 27 Apr 2026 18:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9D76B008A; Mon, 27 Apr 2026 18:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF366B008C; Mon, 27 Apr 2026 18:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6CE6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:52:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1DBA12036F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:52:47 +0000 (UTC)
X-FDA: 84705837174.10.7B304BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E55D540002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:52:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQHuAQyk;
	spf=pass (imf12.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777330366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Gvje+eEtyz9vb5dEuXg2cIwnq8XyDNbzzuL18WTmew=;
	b=0BwxO93ZAm6ZKKqDV5lD9vlSaMHQQZBVFpnrk8Lv9YfKU/6LSue5ygWwJtvHtIsVnmv8Sg
	BE+jaPhMagD46t3JCW3S3T7c0kpU0pS3OBWxzmHgdG/lLSFlsRbok8a5X635R3uV4AJV83
	Rg5wDL9pqcjUMJ2iBLKJAbMubM+7KKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777330366; a=rsa-sha256;
	cv=none;
	b=E0r6xB2KoiDnwKlBMzTRD43N+u4R3YJIKxzDXVeIROdJJTm/HHbzBSck+8y/G35mJvACGH
	ygRNF4uEMAMdwbfYhW8PhfEF80t++dHoCrrZysfHOpvZFtwXuqRhyOBkBdgjd5ZneejJuz
	v8QhwE6qG5R4lm/zSVu2LXOvNq9GfLs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQHuAQyk;
	spf=pass (imf12.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 874124055C;
	Mon, 27 Apr 2026 22:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBF1C19425;
	Mon, 27 Apr 2026 22:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777330364;
	bh=naILOOeceSH7gxGqzl9s9OfI8mPKDP5hLrbE9sgbdqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vQHuAQykeFe6C0ai+ixhiAb4LvOC1ZVCpjNX8WMjxR9PF6w0/xLPSqb/YemocAlAn
	 XrH5ES4JiKpw9BuyKiK8DYf5CBFuoeAnmvkAlPAffMXSDPGIWpmq4Bs00lRBCoiU/J
	 QYgAANxb6f2ht+6XTxtDOOeJ20H2CZE2Li6DCu3lHjqSPg/q/xtSofS9iPtL8JFsuI
	 +qWk0Pa4m7ln4qMUu9q0X8lQC/5AWr+TG99oxfURjJG6gKrFHsAIr3K5C2shi0BPsl
	 FgcobMMzEdPvXPKVGA/K46+64l/8k8LjtLTyYmRWQRg4+qEJaQy1xupfiCVjBR1xWY
	 97N0AtmnGhj5Q==
Date: Mon, 27 Apr 2026 15:52:42 -0700
From: Minchan Kim <minchan@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <ae_oul_xgD5Kgnqi@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <CAJuCfpFK+qatN_vHArEKOYe+LRHQG0e3inJrzVdz-mABi-BSTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFK+qatN_vHArEKOYe+LRHQG0e3inJrzVdz-mABi-BSTg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E55D540002
X-Rspam-User: 
X-Stat-Signature: f3fb9oo7b594dfnutuy83arzw5bz9ams
X-HE-Tag: 1777330365-312569
X-HE-Meta: U2FsdGVkX1+xTjsKsiOA9PPSGfF2wO3A46G0lRiWCSfn970WU5LMyfUPtpLvEqU3s3+GtypIU95ZpKIMANrKNGGD6Frxpjpl9EIMWUsopFi814Tc7lHzI1Ol+YIb2ZReV1hEZJpIdN6p1BDELpl9ML80pojh+zXD5BqTke3UL5mFE61/30pYF/Xs4Ld8ZG1e71DkpQYLphON/1kILtL2f6oBYORH8DoRoNdOBt8isQom1Yc4vQZPYi0rzRZtIN5BOlKdcC3d4DErf8zQIppZq+0mm3jC34+EZO+o8ZADoOfl6dnNlaQLuXeGFx184AnO084ZwK6NAFBjisdqzO5xOpzOj20dBp1ZYCb0cYWiy65dYMt7d7/R5DSXDj5iC7pTFu2DXwm/XgK2sJgXdEa5OZ272U7aSqHQi0om0VxP+rwaX4wD5CfxKkJ8os42i6hjayOxLfgC1lwCP0UGDY4zW/LaVr9Wr+DCQi/xjw1J2H01Ih3n2WP6wOb94Z3jG204L3lI2N3F+/JerGTtz3eLDHRQ+6qHQXXp+A9mpVs0VLtIRU9aKAZ1NIvpLvPEKOMbbPiLIQTmkUBDXY8M9n2Zxd7qDIPylMCW/KJ86faYiXdpzBGLDqy5TF3J9iLBlXeIM8f6O0+lU+aMh2OdjFavH4QqT9nepQogleLpKHSjVtXbAeQwRKSJaixZX7hPxZeTnDe04BzAB8Wkn3KXnC5yyOidUXW7pkPVD88jgifIpajFrdUQop0SeQ40A4ljgWvr7D6+Jknil9xLPn+TaADEItYgEQmdnC0rkX2tsrTcBWd0jWBgzyydOJI7ubPp8ps2v+AtpM80BL0oZ0CQa0CxvvAGqcf5eXBueGN6ZjQsSCTiGtSpN/xQ9WLDmGA41PoamdiPpbV710Jcq0BCL+SAlw9CgmVzLZ1Z3BVP7sLhqzd9p1wfhQOMG1hvKfsMdzk05fkNBiJyjVHwNyL+upy
 83nWRq+D
 /89RvXpUU8og7ylvuz94/FuHJvi1tdVX5GCVqa3UT1kUCyKl5BlO7iBH6v3zOxb+CldXN4eUjuAQwmehYBpTtv9ts79kU2Fx8BeWZC986TQup0BTsQkYGdUK2de4vVeDHZJuM3rnfErB1ZP3radccyONIeaIMJldjGe2BM9CyjPu7pDRFASKbGrwh75kIZdekn2FfOtq+dTr7+Ifm9sjzfS51z6Kb1g9r4nOrYKCK5127SIiUx3SUEVnH703IstEAoiW29y4IUOiSRW5dLo2rN6SikBjbvNFkH+J6fJtSumoxffG41fY+ptpcbDD0629nJMhwjnoBZluUSq0XR7Fap/G/D31dJmfpB3E2o+JK6/zalJErizPS9Yc+IJp+m4MQGzQ6infupwlseVZ2Vp8GZQyiZ723uwGOJQ8A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 01:34:37PM -0700, Suren Baghdasaryan wrote:
> On Tue, Apr 21, 2026 at 4:03 PM Minchan Kim <minchan@kernel.org> wrote:
> >
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to the call. This separation introduces a scheduling race window
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> >
> > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > leaving the actual address space teardown (exit_mmap) to be deferred until
> > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > VM accesses) frequently delay this teardown indefinitely, defeating the
> > purpose of expedited reclamation.
> >
> > This delay keeps memory pressure high, forcing the system to unnecessarily
> > kill additional innocent background apps before the memory from the first
> > victim is recovered.
> >
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > an integrated auto-kill mode. When specified, process_mrelease() directly
> > injects a SIGKILL into the target task.
> >
> > To solve the race condition deterministically, we grab the mm reference
> > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > victim from calling exit_mmap() in its own exit path. This ensures that
> > the memory is reclaimed synchronously and deterministically by the reaper
> > in the context of process_mrelease(), avoiding delays caused by
> > non-deterministic scheduling of the victim task.
> >
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  include/uapi/linux/mman.h |  4 +++
> >  mm/oom_kill.c             | 56 +++++++++++++++++++++++++++------------
> >  2 files changed, 43 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> > index e89d00528f2f..4266976b45ad 100644
> > --- a/include/uapi/linux/mman.h
> > +++ b/include/uapi/linux/mman.h
> > @@ -56,4 +56,8 @@ struct cachestat {
> >         __u64 nr_recently_evicted;
> >  };
> >
> > +/* Flags for process_mrelease */
> > +#define PROCESS_MRELEASE_REAP_KILL     (1 << 0)
> > +#define PROCESS_MRELEASE_VALID_FLAGS   (PROCESS_MRELEASE_REAP_KILL)
> > +
> >  #endif /* _UAPI_LINUX_MMAN_H */
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 5c6c95c169ee..730ba0d19b53 100644
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
> > @@ -850,7 +851,7 @@ bool oom_killer_disable(signed long timeout)
> >         return true;
> >  }
> >
> > -static inline bool __task_will_free_mem(struct task_struct *task)
> > +static inline bool __task_will_free_mem(struct task_struct *task, bool ignore_exit)
> >  {
> >         struct signal_struct *sig = task->signal;
> >
> > @@ -862,6 +863,9 @@ static inline bool __task_will_free_mem(struct task_struct *task)
> >         if (sig->core_state)
> >                 return false;
> >
> > +       if (ignore_exit)
> > +               return true;
> > +
> >         if (sig->flags & SIGNAL_GROUP_EXIT)
> >                 return true;
> >
> > @@ -878,7 +882,7 @@ static inline bool __task_will_free_mem(struct task_struct *task)
> >   * Caller has to make sure that task->mm is stable (hold task_lock or
> >   * it operates on the current).
> >   */
> > -static bool task_will_free_mem(struct task_struct *task)
> > +static bool task_will_free_mem(struct task_struct *task, bool ignore_exit)
> >  {
> >         struct mm_struct *mm = task->mm;
> >         struct task_struct *p;
> > @@ -892,7 +896,7 @@ static bool task_will_free_mem(struct task_struct *task)
> >         if (!mm)
> >                 return false;
> >
> > -       if (!__task_will_free_mem(task))
> > +       if (!__task_will_free_mem(task, ignore_exit))
> >                 return false;
> >
> >         /*
> > @@ -916,7 +920,7 @@ static bool task_will_free_mem(struct task_struct *task)
> >                         continue;
> >                 if (same_thread_group(task, p))
> >                         continue;
> > -               ret = __task_will_free_mem(p);
> > +               ret = __task_will_free_mem(p, false);
> >                 if (!ret)
> >                         break;
> >         }
> > @@ -1034,7 +1038,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
> >          * so it can die quickly
> >          */
> >         task_lock(victim);
> > -       if (task_will_free_mem(victim)) {
> > +       if (task_will_free_mem(victim, false)) {
> >                 mark_oom_victim(victim);
> >                 queue_oom_reaper(victim);
> >                 task_unlock(victim);
> > @@ -1135,7 +1139,7 @@ bool out_of_memory(struct oom_control *oc)
> >          * select it.  The goal is to allow it to allocate so that it may
> >          * quickly exit and free its memory.
> >          */
> > -       if (task_will_free_mem(current)) {
> > +       if (task_will_free_mem(current, false)) {
> >                 mark_oom_victim(current);
> >                 queue_oom_reaper(current);
> >                 return true;
> > @@ -1217,8 +1221,9 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >         unsigned int f_flags;
> >         bool reap = false;
> >         long ret = 0;
> > +       bool reap_kill;
> >
> > -       if (flags)
> > +       if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
> >                 return -EINVAL;
> >
> >         task = pidfd_get_task(pidfd, &f_flags);
> > @@ -1236,19 +1241,33 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >         }
> >
> >         mm = p->mm;
> > -       mmgrab(mm);
> >
> > -       if (task_will_free_mem(p))
> > -               reap = true;
> > -       else {
> > -               /* Error only if the work has not been done already */
> > -               if (!mm_flags_test(MMF_OOM_SKIP, mm))
> > +       reap_kill = !!(flags & PROCESS_MRELEASE_REAP_KILL);
> > +       reap = task_will_free_mem(p, reap_kill);
> > +       if (!reap) {
> > +               if (reap_kill || !mm_flags_test(MMF_OOM_SKIP, mm))
> >                         ret = -EINVAL;
> > +
> > +               task_unlock(p);
> > +               goto put_task;
> >         }
> > -       task_unlock(p);
> >
> > -       if (!reap)
> > -               goto drop_mm;
> > +       if (reap_kill) {
> > +               /*
> > +                * We use mmget() instead of mmgrab() to keep mm_users > 0,
> > +                * preventing the victim from calling exit_mmap() in its
> > +                * own exit path. This ensures that the memory is reclaimed
> > +                * synchronously and deterministically by the reaper.
> > +                */
> > +               mmget(mm);
> 
> I don't quite understand why you need to mmget() and prevent the
> victim from calling exit_mmap() here. As long as we successfully
> mmgrab'ed the mm, we can safely proceed with mmap locking and doing
> __oom_reap_task_mm(). Victim can execute exit_mmap() in parallel with
> __oom_reap_task_mm(). In fact that's even desirable! I remember a
> recent patch that used mas_for_each_rev() in __oom_reap_task_mm() to
> reclaim memory in reverse order so that exit_mmap() and
> __oom_reap_task_mm() can start from opposite ends of the address space
> and converge in the middle, working concurrently.

Good information. Will change it in next respin.

