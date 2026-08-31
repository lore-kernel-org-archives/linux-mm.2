Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A50C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 21:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB4D6B0088; Mon, 31 Aug 2026 17:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C7F6B008A; Mon, 31 Aug 2026 17:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144C86B008C; Mon, 31 Aug 2026 17:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCC056B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:44:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61EEFA028A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:44:35 +0000 (UTC)
X-FDA: 85162894110.03.6E926C5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 87B2980007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:44:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p0s5EAv5;
	spf=pass (imf02.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788212673;
	b=HHOxg3uy8E0DBEN5QI+f93sgZ9aNw21Uwj2b3A8sxQcuAGeiOUmsIVYVlZ2wCvWt0lmOcy
	SHConHiyddLEw9LSVPqDz9PqeTWdjo76+I5C4yXq/E7wzB5p7a3dtzYR8BypiS0lVsKLa3
	TDWpdODcITBFTiGujYDwR1oINzoX3iU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p0s5EAv5;
	spf=pass (imf02.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788212673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVDll6WIE5UiMa75pvf0sUPkvEMMcWUBr73CfpmM+D0=;
	b=RLXyt0BhoRs1C8Em3H/GVanNq7CT2Y002X1FFh4vdVNfc3SdOCpGz3bNzGoPnntrIf74bZ
	wz+38X4NTZTA4yQlUHjlwc2m6MKNIzxhTGwEb6xsD6Iq7RMaNJixn/xy8w0/MidY6f4e+D
	B7gUTz4Wqq+7UdcILJxUy7dM8pnnrhU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8520161fdb9so246015b3a.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788212672; x=1788817472; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aVDll6WIE5UiMa75pvf0sUPkvEMMcWUBr73CfpmM+D0=;
        b=p0s5EAv5aWNDklBD8iytDBhybc76Rsbv9SNjCA7PjNCVV6QADJ5mGvlksMyToPFUrc
         699M1o9DphLCaHL9TAzSEJYDPBj/XcW7pruhNHrNYigyt4G3mSWoY96+mbikluM8pmCb
         7FgcZ8zk0G4ZJCwhwTY6pdaZIjb9lWBtGu+BtuLoEkoL0zZoKcul2tsdlqyLLNg4e/0X
         m48FLHtfY9PkyJzYYT429m+H+0SudmTTrLDfzy50xBeHV/7is+u00oIQg/IXmqlSi7fP
         fOF1vUysjcDwhnMX8qwLbeBJT/hREk6kTuUoqwQTSd+qc9fbDp6jmeQcWKhwdqT54Q65
         wEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788212672; x=1788817472;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aVDll6WIE5UiMa75pvf0sUPkvEMMcWUBr73CfpmM+D0=;
        b=LRtlVx2d4nbhHLeWYoBfHIm0lh3++/jEoF/Vh90ZWaTT1FSM2QSleKWoq4dns/gAaU
         uV2smxH6++1SS5UH3dU0rAxoyfn2iZD8jrmnrVtkg66lO28hL4wQgnZr5UgPz0lmnT06
         3BtaUZwda24i7q+upTrZDgnZUnLYgj1ScE74zZCYzr2GYeHj0p+LTr9lN9X6f4QN8k9u
         zfmk/VBJM1TWPV0GgBtA5rfNd36RbHJxd0CIXP3eirttLVtDkVWtnwjTQxDJ8GLcCa7C
         toqokLcJLQEPSuiRgcpMpfZ0pZBPH8rrRz583Gic2kpPNUSyED4YhsVOAfxnfSVqALWe
         ouLQ==
X-Forwarded-Encrypted: i=1; AHgh+RqxYhS0O9wf62nGoQidXW1tuD8MIu7b0Fbob/sDqGZd/X03qjzVaTVl82hjonhiIz1MQuxSpaR9TA==@kvack.org
X-Gm-Message-State: AFuF++m/9OGJwid9kSBmZp/WLOuWSmSzZc9jbCAoOOHq7hmRQIJINCxv
	PLGjl5XaSTiwEuxS3NFa0Vry+F8uiaIjKCAAXcIyMoP5dAPjnP65uroE
X-Gm-Gg: AR+sD10ls8RooBpdnsRwu2tDTGHyX3hHeRj5XohD52xZA5ysI+tUnwapk7QFKy2h2vD
	iBvnM6oCZa/kS5AdaJNDtQ3maTxxoneUEc01kz30lV4AwNSDW7MLmCmmqKKJh6MKWRfL6O0l1M2
	j6fFkZjRjr0O3xUAQJvK1lA55sba7irNoMdDrG6dqh1CAzb3224irs4ioSjfhUosZtJuYYjMO7Y
	SSYuY8ciU9PL7yKN/SWsV5LBM3hLFRXuScn1Fl5AIJkb67QJM5zwhrtAI98tbypRrvH9czZ7F7U
	A7N/xX2YLBe0SbMbSD2OildwAzyorXV1xXodM5/huDGz8DslFmfhaxR5sSzk3h39XqXfFdhTFnr
	GpnDPJuwa2c57jV6jogxfp+MYaME5ZKuS5z5JbOeNfFcMBsL6N7bXz9Gc62687Bm0rgAI2uLMBe
	vC0AdsoKEYpWH0LQOq1kpRJHpFgqsZJ51wCVRBGuqo3VsarQA2XZjwkrENsRcQ3umo1oM0BDzUk
	HYuAq0=
X-Received: by 2002:a05:6a00:ab0a:b0:84e:7ec:aa42 with SMTP id d2e1a72fcca58-85629f09863mr48227025b3a.10.1788212672297;
        Mon, 31 Aug 2026 14:44:32 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85be5d9b768sm87355b3a.3.2026.08.31.14.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 14:44:31 -0700 (PDT)
Date: Tue, 1 Sep 2026 06:44:25 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Chen, Yu C" <yu.c.chen@intel.com>, Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"chen.yu@linux.dev" <chen.yu@linux.dev>, imv4bel@gmail.com
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
Message-ID: <apX1ufR1reYZ9LBc@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
 <apXV6t-7drLDf-lL@v4bel>
 <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87B2980007
X-Stat-Signature: 5b6a5z89xn9ijt75xwcut3bzqgm897qo
X-Rspam-User: 
X-HE-Tag: 1788212673-905644
X-HE-Meta: U2FsdGVkX19QpYSrVtV9NDpM2T+Wlh4pW9N9PpYcFmpybifeDqDiAj1bKez/Xk7ARDE2K7FBpTg/uUAepNYeI+tE0GphWhPUyB4fYCpKnR8+Svy10TzY55UI10cV8COu4rRsWJoETrNw06Ct8o3OvosfUnY7C3hQdIGhN6dwdOwJ1Dl+1ctsOt7TpfAM9UOp2rCYuC5L8Eyv+NefkhEF0vlbQ2B8GkA9IFQZiBIoh85rYNuSIYw6bln4M5dzvymam69SsoQYUH6sxmyLaMLWdzOJBBknSEdFODcvidQWlcunp28H8REPAOG00KkWwH77+pUMosWYxk0ysH+6aQPeq7BnbtAtR3C75TqBwTfNhxctKFeFKQj/G+LRVuqRzikY9r5RXMpLo++TQmScEI3Z1Jb4JnG35/yQyGfzrfMJQY+SrW5TVaH+kdehlBHeRSw7yr9FNPw+k6ICBHgMyZQHTa9tLz320Ay5EVha3c7ILaP/IoiMlRZjevG/GUavb2CGuiyd2biw6gPyLiJMdv7xzIaeXgT5ZPaUi5hJaXvBsgZ3+MYU8IzvypYHlWwWnbuZHB8CJbwcFbkQsgp4dWQyL8lEhdrWtQbpxUg6ggqkiVpIZ864VUYuf75AgVJhNFJJVcpH1DD6iuK0pPXHxWYV5vv08sJfRIFlLPEK9JizwrimzWruQApI+1WyI8S+bgxAlXbpLmRdifGNBMXxV4VZEQ/geVho1jpQ75HNDPcryMSrudj65SM1cv46/e1a3AoK7K5IupizOy/6jourxbxXwGQOszKzF4pfOtfktFeRNMnDY7C2gIN/Us6pWjYc2lHoX9+IYtU/fbGknqtd1I6KYLc7LpwY0r92aKKkUgpnWEQcGRSV6fMZWDxIiYHItkFpyzDWtO9yAcdz4t9GQxJ8n7yJnrM3A9G4LvA2QlbPETl10v8RU//iGHlzG11lS/2PMYFbeUAY+y2CaQRgCCw
 m6Sg0kXh
 6PX5bKaNY08Wc8CdbH1ga62QQEQOGrmJH3drZzsoGAHFjlBbSycVl2gS71gAKtGS4KipBm9MFogQCpf7f3zGbBO3xOLiB0QKg4SFrGeYAk6Hia2ta2m940JKeHMD9qUjk8qdC5jRwEknckBEuPCgBCs5Ts2faMKJyH2RaYgQV1NfL3qiuozB0w0x4iuDHtK+vlTgiuu+h9H0LUQ/PLFyWyRu1Pbe9biffmWa2JxYoeXMcDqdMmqm62LfAiMtfd/IMtPbsT5N5sEfdQ3DUR81qfR5bGGzzA1t2nGEAZdjU7D7EPd0jeFbcMIG1adQV2BR/yiRVKv4+hy1xpI4YRWo11smLbOXRjpSu4nhaU8c+E/sEzuB/k2R1cLoflY/Xu6ZHBHkjTgxbfgPh6rlpmyO2gI7tetByHWml8uEW+OgPExyg3Bdsd+uGCmu+nGJ+RYePOJIK8Necwb4TMQgukYlmOHrkie5gsiDvy8rGDZHxFRae1+cdHG+cYc/G/ytczzN8Y0F7i3LB8QUbcI3ULR3M5hKedHecJBfuEboVLf61saPlXPo468afAIAnK2CexcbfT+Z2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 01:25:06PM -0700, Tim Chen wrote:
> On Tue, 2026-09-01 at 04:28 +0900, Hyunwoo Kim wrote:
> > On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> > > Hi Hyunwoo,
> > > 
> > > On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > > > When the waker cannot use the wakelist, ttwu_queue() takes the target rq
> > > > lock and goes down into update_curr(). If the target rq belongs to another
> > > > CPU, the task handed to account_mm_sched() is the one running on that CPU,
> > > > not the task being woken.
> > > > 
> > > > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps that
> > > > mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to do
> > > > with the lifetime of the mm.
> > > > 
> > > > If that task happens to be in execve(), exec_mmap() points tsk->mm and
> > > > tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_exec()
> > > > drops the old one. free_bprm() does the same when exec fails. On the way
> > > > from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu() on
> > > > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > > > 
> > > > Whoever already read the old pointer keeps using it. It adds to runtime in
> > > > the freed per-cpu area and reads sc_stat in the freed mm_struct. Depending
> > > > on the condition it also writes sc_stat.cpu. That is a use-after-free.
> > > > 
> > > > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer access")
> > > > changed the remaining p->mm dereference to the local variable, and said the
> > > > active_mm reference keeps the structure allocated. That holds for the other
> > > > paths that detach an mm, since they take an mmgrab_lazy_tlb() reference.
> > > > exec reassigns active_mm to the new mm as well, so that reference is gone.
> > > > What is left is the mm_users reference in bprm->old_mm, and dropping it is
> > > > the free.
> > > > 
> > > >               CPU0                                CPU1
> > > > 
> > > >                                        write(pipe)
> > > >                                        try_to_wake_up()
> > > >                                          ttwu_queue()      // takes rq0 lock
> > > >                                            enqueue_task_fair()
> > > >                                              update_curr()
> > > >                                                update_se()
> > > >                                                  account_mm_sched()
> > > >                                                    mm = rq0->curr->mm
> > > >                                                          // old mm
> > > >    execve()
> > > >      exec_mmap()                       // tsk->mm = new mm
> > > >      setup_new_exec()
> > > >        exec_mm_put_old()
> > > >          mmput() -> ... -> __mmdrop()
> > > >            mm_destroy_sched()          // free_percpu()
> > > >            free_mm()
> > > >                                                    read mm->sc_stat.epoch
> > > >                                                          // use-after-free
> > > > 
> > > 
> > > Ah, thanks for catching this.
> > > 
> > > > ---
> > > >   fs/exec.c             |  1 +
> > > >   include/linux/sched.h |  4 ++++
> > > >   kernel/events/core.c  |  2 ++
> > > >   kernel/sched/fair.c   | 16 ++++++++++++++++
> > > >   4 files changed, 23 insertions(+)
> > > > 
> > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > index 745f6eb5279e6..6194c38807980 100644
> > > > --- a/fs/exec.c
> > > > +++ b/fs/exec.c
> > > > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old_mm)
> > > >   {
> > > >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> > > >   	mm_update_next_owner(old_mm);
> > > > +	sched_cache_exec_done();
> > > >   	mmput(old_mm);
> > > >   }
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index 8b3d47a325cca..6ae31bffe049e 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> > > >   	int cpu;
> > > >   } ____cacheline_aligned_in_smp;
> > > > +void sched_cache_exec_done(void);
> > > > +
> > > >   #else
> > > >   struct sched_cache_stat { };
> > > > +static inline void sched_cache_exec_done(void) { }
> > > > +
> > > >   #endif
> > > >   #ifndef MODULE
> > > > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > > > index a6c8e38a31104..2f29cbccf03f1 100644
> > > > --- a/kernel/events/core.c
> > > > +++ b/kernel/events/core.c
> > > > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
> > > >   	if (!cd)
> > > >   		return -ENOMEM;
> > > > +	/* @old, loaded by the try_cmpxchg() below, is only stable under RCU. */
> > > > +	guard(rcu)();
> > > 
> > > Is this change related to this UAF issue?
> > 
> > Duh.. that one is unrelated. My mistake.
> > 
> > > 
> > > > +/* exec() has switched to the new mm and is about to drop the old one. */
> > > > +void sched_cache_exec_done(void)
> > > > +{
> > > > +	struct rq_flags rf;
> > > > +	struct rq *rq;
> > > > +
> > > > +	/*
> > > > +	 * account_mm_sched() dereferences rq->curr->mm under this rq's lock,
> > > > +	 * so a remote CPU can still be using the old mm. The lock cycle waits
> > > > +	 * for it, and the store to tsk->mm cannot be reordered past the
> > > > +	 * release, so later acquirers see the new mm.
> > > > +	 */
> > > > +	rq = this_rq_lock_irq(&rf);
> > > 
> > > A smart fix, learnt! It behaves like a synchronize_rcu() to protect against
> > > the read in account_mm_sched(). Small open: since the context of invoking
> > > account_mm_sched() is preemption-disabled, I wonder if we can simply use
> > > synchronize_rcu() directly instead of this_rq_lock_irq() - just to avoid
> > > contention for rq-lock in heavy system?
> 
> Thanks to Kyunwoo to show this potential use-after-free problem.

It is a real, triggerable issue.

> 
> While synchronize_rcu() avoids rq lock, it could introduce a long delay
> of a full grace period that will be undesirable.
> 
> 
> I think a better fix is to decouple sc_stat from mm and make it its own structure.
> Then we can do proper refcounting and rcu management on sc_stat itself.
> We will let task points to sc_stat with proper ref count and change the access
> as task->sc_stat directly nstead of via task->mm->sc_stat.
> 
> Then we will know sc_stat exists in account_mm_sched() execution
> as long as a task points to it and do not have to worry that sc_stat is
> released due to the mm life cycle.
> 
> In the first 2 patches of the prctl control series for cache aware scheduling
> we posted, we introduced the change I described above and should 
> fix this issue without additional rq locking or synchronize_rcu() overhead.
>  https://lore.kernel.org/lkml/cover.1787955777.git.tim.c.chen@linux.intel.com/
> 
> We should probably prioritize to merge the first couple of patches from
> that series now in light of this issue.  It will make maintenance and future
> modification of the cache aware scheduling code easier.

That is a fairly large change. 

If you add a Reported-by: tag for this UAF to the patch, I am fine with 
handling it that way.


Best regards,
Hyunwoo Kim

