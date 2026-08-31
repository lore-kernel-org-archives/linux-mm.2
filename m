Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D5CC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3307F6B00AC; Mon, 31 Aug 2026 15:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0B66B00AD; Mon, 31 Aug 2026 15:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB056B00AE; Mon, 31 Aug 2026 15:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57F66B00AC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:28:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F1F580232
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:28:52 +0000 (UTC)
X-FDA: 85162552104.30.E92D86A
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C380180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:28:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OzOGSfpt;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788204530;
	b=y38chdmBbXid4oChFAYvQXxNpIBCIwDcLJUy4aJTCC7u6k11QW1DTNgJTZ4gGllYjTxMjU
	uxAw6kN/TsOfRpuNhZKmTMkwLCfpU3iWdvG/DNXJrkPO+h2U/eaLfyz+WmeFz7Vl22Mh+u
	FMjwojRiemRp6hScleWjgOriCr+W5sY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOrdrxaxaxWhGxafBxna8Qbb07ro71OXhgW0DP7l1OQ=;
	b=Wd6q5Ugfr+MxdszP5q8wdDyYyIZKiP3ePX4f32WMDOfKv8L9uxRSjjPbTKXDArn/DC4uSl
	LSQX2EWSwLG3TDVsucjzgA2PwUynD/fWN/RJTMHGuUpuxYieDS7xuSmYpjlfKKgr2IGdgp
	YnbAaEdr1muFhkegTp7KMiyBEFcm5Pg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OzOGSfpt;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39266382df6so3298556a91.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788204529; x=1788809329; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jOrdrxaxaxWhGxafBxna8Qbb07ro71OXhgW0DP7l1OQ=;
        b=OzOGSfpt6HO8CxTEzfT4+UfuvLF4a8x1DPC8Mwpzw/CNeOEwm6HExvTMkJDUPMb0KA
         QQ/a1Hi5l/p8WXdUeS5tTQFqej23qhvWpUT7pcv077uTePYiVpfKj+mCSJPZnXgthHaB
         bTPWhJW5YshkcaRFDLchrwSfmoYm5M6yaNLR0eJzmjH33PWbVtKlvZz1Ho0WZASmmnHx
         NneChHC7utTPzz42vi1PPS011EgBHEsem7xc8P1yZe8wgXWJvrZGGA3TTdOO3BcvmNFG
         w9X6HpHF+Nqep6SGEQ4VcXXOTO7ZW4jkMq7+MQTJiN0OWWUhNadricXtNcya2cl2DGkQ
         vPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788204529; x=1788809329;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jOrdrxaxaxWhGxafBxna8Qbb07ro71OXhgW0DP7l1OQ=;
        b=LT29BC/9exgzkwOJZXMXt8ewbfZ445e4F32lr99T98sSwfwO/tjnm9aW+XHLZrLk8H
         bB67V/AcCnZhyDBt6rX89N8mQbUbCIqGyN0VgmN+/LCXV3adGJedYONfzLdKRfSfHMeS
         fiKZoGl5EucjVAp6tnqz/vXwpKX6CCNTXxrMN6UU8tGtAxU6GNLeZFPpI+NhsVf2oEpl
         y07+nqJl9mWUsoDuQ5cvuZyjjYY4YDX8ULDL5c8q8MOP90V+oB/OkfRgm7oESDpTr7Nb
         46d9Urr5Ksl7MVbComAcy1T2f6Q3NgxCoUokQcKWX8pCT598oZF2VyrzDX1BBePoijX6
         3Kog==
X-Forwarded-Encrypted: i=1; AKwUvBy/e7txjQgfepro9FE1dGAIEaLCPqjav8toyT6BF4S9EwijZJJDf94okYykSQFk7YP2ozHjfYel3g==@kvack.org
X-Gm-Message-State: AFuF++lvwWc4mmpF4d6Qz5rtO1iDaxIfpte+OOfgYsc1xOYGrkFDbPYy
	J6DecXfxGMu/UrmYMK7XuV/XyoHWNp/qPZM0heVANucR5ROnY11vxYyy
X-Gm-Gg: AYBFou2qzqu7CIvs81tHOC7rISS7Vqgex5nFDU5OQ9+MH+V9o3rLYLWEvaL48l0Ge+o
	cNJyC7nFpJqlWypnA6nAnvdwR7uQ+CATzMjQVtUQ4yPFZdpxrm3i9wt+CCaXxOvx+1bOJ2f8RLc
	Xfi9LXhi2a2dWjRRq9LUZpn/LenyeLWD/E5V5RnEcQtqYYM4XRlFnS4knsY1tTuZbAHW9I0VxEl
	J9ee1IG8Z0GwZk4PuG5vHK6uRzwBjff00+G1FwAKv4fUOv9A9cLgMkTx7G0fVR+6baVJHPY72mJ
	lrfPvTA1qPgwTRdlGabG62gsJluD8mCuLNawSqciUJgdZsUcg91cdLPIpTC1/rbWyTC9rqErJ1E
	DSgcMUF55ZB7TMInDDWaXtyALckuiMmqZlqfpL4C2nauEucRLZMHN8fTUNBOEcfHlrQMurbTikW
	d2sxvAAYZY7E0iSuG+STvwYCZn8VdPnv5TsQR/ZX50zYtDMPYrf6BhiFUVYWKV+xqq6JCS1Y+CN
	r15Fh+s
X-Received: by 2002:a17:90b:5827:b0:381:11eb:d78e with SMTP id 98e67ed59e1d1-39907d6909fmr4255743a91.14.1788204529334;
        Mon, 31 Aug 2026 12:28:49 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bcf7c9csm1138684a91.2.2026.08.31.12.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 12:28:48 -0700 (PDT)
Date: Tue, 1 Sep 2026 04:28:42 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Kees Cook <kees@kernel.org>,
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
Message-ID: <apXV6t-7drLDf-lL@v4bel>
References: <apPb-Dr4nPYuHQOK@v4bel>
 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C380180005
X-Stat-Signature: rb7686mzdcepdjg6ktghkcps8z7ijth5
X-HE-Tag: 1788204530-144239
X-HE-Meta: U2FsdGVkX1+DHLJVScWPWB07ZPBrTUVWfwjpOZT2etc23PE9XqS3trKABpvu1qPTlvKZ7sHmQ+S8iH9TIFcfUqbWsmQ0/8fiwefd+UmrYFVkWD2epZoxGv1VNZJ17NtJPwFXa6Bwsl1jhuy2GNPkCkd3tRqbAktEymcEKUxWnT4Xdz3+DOVRpD/WGVOBWYmFo9N5dH9aO+DsgcEq+fAE4RPXEcDrPUA9Yi4Q3SqUdwXWbS+QVBz4W1j7CKPXPpCCf+Lb5M6KLf9A86L2J62CjRrJj9V6NMXr/iE9Drv4qLh6T3r7eTfcj4ISNwjoQ7QuoghnekrpQv4B6F1mLLNvygSKmGAlHogVt+6qu3RlJo0G5u17ovPO6vmmrSKKUyoPxyXfFRjRpQLT/cXeN6aQwhqO6Zhl/tI+f8Rq+/GK7Yf7gLCv9FDTeUxWRsKsSvUqRu7F8KvWSp8tdCMUefcGlPHEYcC9DiogqJmN0Kb9Qjsz6T6Wzir+hz7tDlr3II+fQoeHwbcMb6zYYZ4TAIK53lhYLHx9JnslFO675qKA0dfglIVCenC1wtI7w0yvIk4dt4Ln5IOlDRUZiikKJOjqJAUGBm2f20DnozKWJnG3bi39VxC7tfVgdRJiNk3XIciVltJp5b0QhJLpXbacYPS7NZUlL7oZuxEO7lFsvLYnoISjAdnOsgPUteMrY/A15Q4EUp6ydP5roGu5Erclwtt9EnK3aFgfSpQ4d93XFNaz+xiwR4gghACWVii11simNSXuKWm6+3qKe1XywEDMqQFPwh6LiF/zdeOiWZb9eNcA2B1LE1OtIyeqA/ks9Ci5u9zhFgD4vkGFq7H7JGIU72Lj0S4RtTqXOM/cR/gRDBoQ5RR6Z8qB7sTGh1NHrOkX00mAB7J0e1opEoqbeNEEY6vmcS9c8DDlHnNfNk9tei7FrU4torNgmTIKzyoQTtpK+ip5b/jWjxGegUW1tfW9joC
 eKL9KSLv
 2BztuGty5pildP1pk0oZopb2r1GXkerWtGKMAC+AFOuuZxlZtdILAk/ucnxdJOzjeYPauQ/uv2ttuwiD7n5jvmYlArm7gP9phHym/DdAnTWn2YXa0XCcKiF0Li7QPlqr01A69ZJBCtfHry90DnHW+LqM6VVESZ/GS0ARTzDz+PeVm4c35ivzTB92OCP4TrdxGjIq76eZ/grgOP/OAxPJHBbmyfEINY/1EgA0LOAK5H2f7+G/Bh5Glb6Wn/XFARWjN5FcSRKb5Wx/CBLEzKKGpWlzp7rnn2ejNIJw+R2ypt+wszINrgoJKXxx6vq3LaHtAjENEM05N7n2H7zl6PG/NAXTLoL+QrIG4Q/p7UxquT+nftJ21RTQ8Dxj9RWG/lWu1KZcP5gddRj9kdR9rb4hC9RS96CJG/8oDkd1vdgfbnRP8RpsQNVkxIoL3d4B7EdLkO7Bmz8Bx5xW/agcvwFmZpJBWKCQO1Lq4ijZOXWAUiiom7Qx3BGdGnYGEHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 12:22:45PM +0800, Chen, Yu C wrote:
> Hi Hyunwoo,
> 
> On 8/30/2026 3:30 PM, Hyunwoo Kim wrote:
> > When the waker cannot use the wakelist, ttwu_queue() takes the target rq
> > lock and goes down into update_curr(). If the target rq belongs to another
> > CPU, the task handed to account_mm_sched() is the one running on that CPU,
> > not the task being woken.
> > 
> > account_mm_sched() reads p->mm and updates mm->sc_stat. Nothing keeps that
> > mm alive. The rq lock and rq->cpu_epoch_lock it holds have nothing to do
> > with the lifetime of the mm.
> > 
> > If that task happens to be in execve(), exec_mmap() points tsk->mm and
> > tsk->active_mm at the new mm, and exec_mm_put_old() from setup_new_exec()
> > drops the old one. free_bprm() does the same when exec fails. On the way
> > from mmput() down to __mmdrop(), mm_destroy_sched() calls free_percpu() on
> > sc_stat.pcpu_sched and free_mm() returns the mm_struct.
> > 
> > Whoever already read the old pointer keeps using it. It adds to runtime in
> > the freed per-cpu area and reads sc_stat in the freed mm_struct. Depending
> > on the condition it also writes sc_stat.cpu. That is a use-after-free.
> > 
> > Commit 9f23469401b0 ("sched/cache: Fix potential NULL mm pointer access")
> > changed the remaining p->mm dereference to the local variable, and said the
> > active_mm reference keeps the structure allocated. That holds for the other
> > paths that detach an mm, since they take an mmgrab_lazy_tlb() reference.
> > exec reassigns active_mm to the new mm as well, so that reference is gone.
> > What is left is the mm_users reference in bprm->old_mm, and dropping it is
> > the free.
> > 
> >               CPU0                                CPU1
> > 
> >                                        write(pipe)
> >                                        try_to_wake_up()
> >                                          ttwu_queue()      // takes rq0 lock
> >                                            enqueue_task_fair()
> >                                              update_curr()
> >                                                update_se()
> >                                                  account_mm_sched()
> >                                                    mm = rq0->curr->mm
> >                                                          // old mm
> >    execve()
> >      exec_mmap()                       // tsk->mm = new mm
> >      setup_new_exec()
> >        exec_mm_put_old()
> >          mmput() -> ... -> __mmdrop()
> >            mm_destroy_sched()          // free_percpu()
> >            free_mm()
> >                                                    read mm->sc_stat.epoch
> >                                                          // use-after-free
> > 
> 
> Ah, thanks for catching this.
> 
> > ---
> >   fs/exec.c             |  1 +
> >   include/linux/sched.h |  4 ++++
> >   kernel/events/core.c  |  2 ++
> >   kernel/sched/fair.c   | 16 ++++++++++++++++
> >   4 files changed, 23 insertions(+)
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 745f6eb5279e6..6194c38807980 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -916,6 +916,7 @@ static void exec_mm_put_old(struct mm_struct *old_mm)
> >   {
> >   	setmax_mm_hiwater_rss(&current->signal->maxrss, old_mm);
> >   	mm_update_next_owner(old_mm);
> > +	sched_cache_exec_done();
> >   	mmput(old_mm);
> >   }
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 8b3d47a325cca..6ae31bffe049e 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2415,10 +2415,14 @@ struct sched_cache_stat {
> >   	int cpu;
> >   } ____cacheline_aligned_in_smp;
> > +void sched_cache_exec_done(void);
> > +
> >   #else
> >   struct sched_cache_stat { };
> > +static inline void sched_cache_exec_done(void) { }
> > +
> >   #endif
> >   #ifndef MODULE
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index a6c8e38a31104..2f29cbccf03f1 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -5427,6 +5427,8 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
> >   	if (!cd)
> >   		return -ENOMEM;
> > +	/* @old, loaded by the try_cmpxchg() below, is only stable under RCU. */
> > +	guard(rcu)();
> 
> Is this change related to this UAF issue?

Duh.. that one is unrelated. My mistake.

> 
> > +/* exec() has switched to the new mm and is about to drop the old one. */
> > +void sched_cache_exec_done(void)
> > +{
> > +	struct rq_flags rf;
> > +	struct rq *rq;
> > +
> > +	/*
> > +	 * account_mm_sched() dereferences rq->curr->mm under this rq's lock,
> > +	 * so a remote CPU can still be using the old mm. The lock cycle waits
> > +	 * for it, and the store to tsk->mm cannot be reordered past the
> > +	 * release, so later acquirers see the new mm.
> > +	 */
> > +	rq = this_rq_lock_irq(&rf);
> 
> A smart fix, learnt! It behaves like a synchronize_rcu() to protect against
> the read in account_mm_sched(). Small open: since the context of invoking
> account_mm_sched() is preemption-disabled, I wonder if we can simply use
> synchronize_rcu() directly instead of this_rq_lock_irq() - just to avoid
> contention for rq-lock in heavy system?

Yeah, that works too. I think rcu is nicer here as well. I'll do some
testing and send a v2.


Best regards,
Hyunwoo Kim

