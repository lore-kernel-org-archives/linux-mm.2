Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1814ACA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986AA8E0006; Mon, 18 Aug 2025 10:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E5F8E0005; Mon, 18 Aug 2025 10:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B738E0006; Mon, 18 Aug 2025 10:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78ED68E0005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:14:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 407D8140947
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:14:47 +0000 (UTC)
X-FDA: 83790074214.04.B1594D5
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 94AA8C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:14:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Wo2LBDKo;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755526485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0KDcaQckRNVD7uVm5oBI5to/z/QU4SSE7UwT0X9iP58=;
	b=7Xba/PKQwdOpWJM+3E8S6jQIlirJbHXhExNuVLwiwvm/+hcgmokdC1+A9e0mHVUmCy6Bwe
	jGVn5HVbNOj6dh9MbI34Qoehyo19YkTVbT2Dru+hxaplkVQm2aiPm7sU9W00OWU831aN6t
	PNxApFpJs0zgx6WQOX2nk8GT8yk1rHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Wo2LBDKo;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755526485; a=rsa-sha256;
	cv=none;
	b=XPrCFDXlXWkKJmTLhQ9WBrH6NqknYoKbbSH3gqfwgcgMU40tx3qnpFa596qrdmPuinYzYb
	zR9i1B3LwT8GKg+mJNFm3ve+6Y/VSvNv9xuTuWLCP8ibVNF09ZQJ01b2hX5c9HSnQVifxd
	r/GvlZPfp85ZSnSp6qOxDo30YeKtKtc=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=0KDcaQckRNVD7uVm5oBI5to/z/QU4SSE7UwT0X9iP58=;
	b=Wo2LBDKoRhnkvpImPuqQ3y02DWr7L3JnTKWtIBNPXH0agc2j9WjNDtpn+7US51TGA1llC750n
	8NjtVRVKiV3od6i03faQY49Kgp0CDG4ohDifbFgoGRU55pYFFTn950B2+ERMiXXA1/wshcDJ7ux
	5OYEdfXALoVMTExuynmxXgs=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4c5F8N1n65zYl1Gj;
	Mon, 18 Aug 2025 22:14:28 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 22:14:36 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 22:14:36 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <lorenzo.stoakes@oracle.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <mhocko@suse.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes using robust futexes
Date: Mon, 18 Aug 2025 22:14:31 +0800
Message-ID: <20250818141431.10547-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <d5013a33-c08a-44c5-a67f-9dc8fd73c969@lucifer.local>
References: <d5013a33-c08a-44c5-a67f-9dc8fd73c969@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 94AA8C0007
X-Stat-Signature: kt4ogz3ki8ra9u4e3pj6x9pz9j91qtcq
X-Rspam-User: 
X-HE-Tag: 1755526484-605450
X-HE-Meta: U2FsdGVkX18fVdrherhewk/m8gJlDopM5wa0ybazBFG95grj0bSekt9KVYrrHH1Avl2oLvBz8SIIkR+xLzlUornODWIsIW0+qJHHWDInTDlwoX5eW+FqG0vTvcQptS2Zo2LUlnyV8B2G5xD7jkGegLHqLOIjGvSPJArAkAZnUx53xKGI9jBudbuej/3RYUzkE15Asbowz3MZQY/3tpIcV2pm0gJpSH5w+Q2dvQdLJrn9KVMEWd1hViIiVJqsAmh3HkFiEo7FBSg6L9elkIer8SouPf3TaMGCuk/PNtVsvNOoOPwoEvDlRZeVly6n12PWR1z6IfHKHW5H9OhjcGuTI6jF450SYjl5IQA+1ocTJ0WCWFFa6ayRvUSbHJsBUJBIudwAV5+SdZG+KAt9/Ryl0a1l/U7hfjY7TUdSknGZj4TQmW3An4bNYRhvJLb8Qg2DPhQfUWzCSAqBbYuG75nAzt8WNCNItOCSDeWiQNiXJnWa/Yy1pk4/cB4ei4bNz8TVuOUlIdHKCBmn2wJnWihFmtx9X8iEDLVbKvxjdTuZXWoB0HFJyCYF4IKwiAv8gLrEtu/srYTbrh3Uz4le0Rn+PogOVbh3CTtVDV4XIS/M8L3UuQzR/titvkdOcfc5+Yn24JA71QtPl9Ef3H5JC0XkBWla1Ii2dDzG0SHyFVQ/D9R5BkxfB7ye/A8yataqpntH1tRb7oXLSuxZyiXKn2EhLnKbJU5ybWQec/T5LFpFgVzBbeZ9equoaS0/7pEWD4L2yw/yQM5w/nHO1fkVK+LKvg2039Z5agDXj69e8DrsFFgnPpfcfTzofY+3CDxa5tcPOdT6zcWSJ3ryVwt3QX4iluHGJkuCXDPVFAYX/OLrBNNkz2hmPS8k5fqWb/WjTCSKsPNJ/DzLtaHFuW/8inze34be5UQoFzvcMKDrfbI1pzrjdsWyy1AeJhYt/WD8uNap01kN9SbiTEPl9I339IT
 8OgwPXnt
 4Y9+YUzcixUJwomnVks4xOfYSTVoVT6oDbBCm4RfOUZ/G7rEM98zONmmGxsXAlu0ILCPPNuwb7qX2i40t9mjGnrDoG+a2F2j1hzu3hw5vvK2IbXVVxpKMGqlEDm2cDtuZhyTfem77JJ3creb3dTD2ff+ogkDqjR4w2pSUd25INns0LJTOBHSEEY302oP7/1bo1CpY1Ifeus0pQPIv1kTCmsADi8036mmfGufwNGlpZltVNUkoe2ZYCsFfvKtosthj9hEWS6P3Degx+l+4/HR4yq1orzHVWWD07AQAMv0wicjKXWva5U2UNV8zfq41P6sTTSf2KSwaG84QxXeIX5j+U6qeSwqhZ5N6kZgm0cZRMhQ5Jjp+r1WhY7DHGGwdtuqzq8kRBtM0eqwPX7Exs0jKUnyj1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu, Aug 14, 2025 at 09:55:54PM +0800, zhongjinji@honor.com wrote:
> > From: zhongjinji <zhongjinji@honor.com>
> >
> > The OOM reaper can quickly reap a process's memory when the system encounters
> > OOM, helping the system recover. Without the OOM reaper, if a process frozen
> > by cgroup v1 is OOM killed, the victims' memory cannot be freed, and the
> > system stays in a poor state. Even if the process is not frozen by cgroup v1,
> > reaping victims' memory is still meaningful, because having one more process
> > working speeds up memory release.
> >
> > When processes holding robust futexes are OOM killed but waiters on those
> > futexes remain alive, the robust futexes might be reaped before
> > futex_cleanup() runs. It would cause the waiters to block indefinitely.
> > To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
> > The OOM reaper now rarely runs since many killed processes exit within 2
> > seconds.
> 
> God, I really don't love that that got merged. So arbitrary. Are futexes really
> this broken?
> 
> >
> > Because robust futex users are few, it is unreasonable to delay OOM reap for
> > all victims. For processes that do not hold robust futexes, the OOM reaper
> > should not be delayed and for processes holding robust futexes, the OOM
> > reaper must still be delayed to prevent the waiters to block indefinitely [1].
> 
> I really hate that we do this :/
> 
> >
> > Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> 
> 
> > ---
> >  mm/oom_kill.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 38 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..7ae4001e47c1 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/ptrace.h>
> >  #include <linux/freezer.h>
> >  #include <linux/ftrace.h>
> > +#include <linux/futex.h>
> >  #include <linux/ratelimit.h>
> >  #include <linux/kthread.h>
> >  #include <linux/init.h>
> > @@ -692,7 +693,7 @@ static void wake_oom_reaper(struct timer_list *timer)
> >   * before the exit path is able to wake the futex waiters.
> >   */
> >  #define OOM_REAPER_DELAY (2*HZ)
> > -static void queue_oom_reaper(struct task_struct *tsk)
> > +static void queue_oom_reaper(struct task_struct *tsk, bool delay)
> >  {
> >  	/* mm is already queued? */
> >  	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
> > @@ -700,7 +701,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
> >
> >  	get_task_struct(tsk);
> >  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> > -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> > +	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);
> 
> Since this is predicated on the task_struct you have here, can we avoid all this
> horrible threading of 'delay' and just check here?

Yeah, It is great! I will update it in next version.

> 
> >  	add_timer(&tsk->oom_reaper_timer);
> >  }
> >
> > @@ -742,7 +743,7 @@ static int __init oom_init(void)
> >  }
> >  subsys_initcall(oom_init)
> >  #else
> > -static inline void queue_oom_reaper(struct task_struct *tsk)
> > +static inline void queue_oom_reaper(struct task_struct *tsk, bool delay)
> >  {
> >  }
> >  #endif /* CONFIG_MMU */
> > @@ -843,6 +844,16 @@ bool oom_killer_disable(signed long timeout)
> >  	return true;
> >  }
> >
> > +/*
> > + * If the owner thread of robust futexes is killed by OOM, the robust futexes might be freed
> > + * by the OOM reaper before futex_cleanup() runs, which could cause the waiters to
> > + * block indefinitely. So when the task hold robust futexes, delay oom reaper.
> > + */
> > +static inline bool should_delay_oom_reap(struct task_struct *task)
> > +{
> > +	return process_has_robust_futex(task);
> > +}
> > +
> >  static inline bool __task_will_free_mem(struct task_struct *task)
> >  {
> >  	struct signal_struct *sig = task->signal;
> > @@ -865,17 +876,19 @@ static inline bool __task_will_free_mem(struct task_struct *task)
> >  }
> >
> >  /*
> > - * Checks whether the given task is dying or exiting and likely to
> > - * release its address space. This means that all threads and processes
> > + * Determine whether the given task should be reaped based on
> > + * whether it is dying or exiting and likely to release its
> > + * address space. This means that all threads and processes
> >   * sharing the same mm have to be killed or exiting.
> >   * Caller has to make sure that task->mm is stable (hold task_lock or
> >   * it operates on the current).
> >   */
> > -static bool task_will_free_mem(struct task_struct *task)
> > +static bool should_reap_task(struct task_struct *task, bool *delay_reap)
> >  {
> >  	struct mm_struct *mm = task->mm;
> >  	struct task_struct *p;
> >  	bool ret = true;
> > +	bool delay;
> >
> >  	/*
> >  	 * Skip tasks without mm because it might have passed its exit_mm and
> > @@ -888,6 +901,8 @@ static bool task_will_free_mem(struct task_struct *task)
> >  	if (!__task_will_free_mem(task))
> >  		return false;
> >
> > +	delay = should_delay_oom_reap(task);
> > +
> >  	/*
> >  	 * This task has already been drained by the oom reaper so there are
> >  	 * only small chances it will free some more
> > @@ -912,8 +927,11 @@ static bool task_will_free_mem(struct task_struct *task)
> >  		ret = __task_will_free_mem(p);
> >  		if (!ret)
> >  			break;
> > +		if (!delay)
> > +			delay = should_delay_oom_reap(p);
> >  	}
> >  	rcu_read_unlock();
> > +	*delay_reap = delay;
> >
> >  	return ret;
> >  }
> > @@ -923,6 +941,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
> >  	struct task_struct *p;
> >  	struct mm_struct *mm;
> >  	bool can_oom_reap = true;
> > +	bool delay_reap;
> >
> >  	p = find_lock_task_mm(victim);
> >  	if (!p) {
> > @@ -959,6 +978,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
> >  		from_kuid(&init_user_ns, task_uid(victim)),
> >  		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
> >  	task_unlock(victim);
> > +	delay_reap = should_delay_oom_reap(victim);
> >
> 
> Yeah I really think we can just simplify by testing this at the point where we
> decide whether or not to do the horrible 2s thing.
> 
> Let's not try to 'generalise' this just yet.
> 
> >  	/*
> >  	 * Kill all user processes sharing victim->mm in other thread groups, if
> > @@ -990,11 +1010,13 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
> >  		if (unlikely(p->flags & PF_KTHREAD))
> >  			continue;
> >  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
> > +		if (!delay_reap)
> > +			delay_reap = should_delay_oom_reap(p);
> >  	}
> >  	rcu_read_unlock();
> >
> >  	if (can_oom_reap)
> > -		queue_oom_reaper(victim);
> > +		queue_oom_reaper(victim, delay_reap);
> >
> >  	mmdrop(mm);
> >  	put_task_struct(victim);
> > @@ -1020,6 +1042,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
> >  	struct mem_cgroup *oom_group;
> >  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> >  					      DEFAULT_RATELIMIT_BURST);
> > +	bool delay_reap = false;
> >
> >  	/*
> >  	 * If the task is already exiting, don't alarm the sysadmin or kill
> > @@ -1027,9 +1050,9 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
> >  	 * so it can die quickly
> >  	 */
> >  	task_lock(victim);
> > -	if (task_will_free_mem(victim)) {
> > +	if (should_reap_task(victim, &delay_reap)) {
> >  		mark_oom_victim(victim);
> > -		queue_oom_reaper(victim);
> > +		queue_oom_reaper(victim, delay_reap);
> >  		task_unlock(victim);
> >  		put_task_struct(victim);
> >  		return;
> > @@ -1112,6 +1135,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
> >  bool out_of_memory(struct oom_control *oc)
> >  {
> >  	unsigned long freed = 0;
> > +	bool delay_reap = false;
> >
> >  	if (oom_killer_disabled)
> >  		return false;
> > @@ -1128,9 +1152,9 @@ bool out_of_memory(struct oom_control *oc)
> >  	 * select it.  The goal is to allow it to allocate so that it may
> >  	 * quickly exit and free its memory.
> >  	 */
> > -	if (task_will_free_mem(current)) {
> > +	if (should_reap_task(current, &delay_reap)) {
> >  		mark_oom_victim(current);
> > -		queue_oom_reaper(current);
> > +		queue_oom_reaper(current, delay_reap);
> >  		return true;
> >  	}
> >
> > @@ -1209,6 +1233,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	struct task_struct *p;
> >  	unsigned int f_flags;
> >  	bool reap = false;
> > +	bool delay_reap = false;
> >  	long ret = 0;
> >
> >  	if (flags)
> > @@ -1231,7 +1256,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	mm = p->mm;
> >  	mmgrab(mm);
> >
> > -	if (task_will_free_mem(p))
> > +	if (should_reap_task(p, &delay_reap))
> 
> You can figure out whether you dealyed or not from the task again right? No need
> to thread this.
> 
> I don't think it's a big deal to check twice, we are in the OOM code path which
> is not (or should not be... :) a hot path so we're good.
> 
> >  		reap = true;
> >  	else {
> >  		/* Error only if the work has not been done already */
> > @@ -1240,7 +1265,7 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	}
> >  	task_unlock(p);
> >
> > -	if (!reap)
> > +	if (!reap || delay_reap)
> >  		goto drop_mm;
> >
> >  	if (mmap_read_lock_killable(mm)) {
> > --
> > 2.17.1
> >
> >


