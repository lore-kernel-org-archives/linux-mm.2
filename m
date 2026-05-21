Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593C5CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1E16B0088; Thu, 21 May 2026 02:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2296B0092; Thu, 21 May 2026 02:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690F96B0093; Thu, 21 May 2026 02:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 573046B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:31:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEC4E1A04D8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:31:38 +0000 (UTC)
X-FDA: 84790455876.07.35F9971
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 129EEC0016
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:31:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jazI6ffM;
	spf=pass (imf22.hostedemail.com: domain of chenguanyou9338@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779345097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AJoDhF3ETeyKEOdxVy0RXaD013qsjQvrAyiROViV9w=;
	b=TxQVjJP6jPpgF6k599nVDUlJK9qDVU5UVV/nFyMoYWxzpzr1xGGzPL+w0GmYJQ/ALJjvGO
	TOSLMfDMgKA7JR1iOVPs5b3XF37QI/rAIL7KJcB1XX97mBn09m2dLK/iGbvJUfizDZQJun
	+ESH3bei0sI4c+JjQ/eYrYzBaqnygmc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jazI6ffM;
	spf=pass (imf22.hostedemail.com: domain of chenguanyou9338@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779345097; a=rsa-sha256;
	cv=pass;
	b=hsBxvltHKnBb6FUlo60oYlbwEqrYbrQMuv7qPxwaDhit7ilqcrsq0k3IJR5MXCVlPA0QBQ
	+zsKVNxCGuZx7GXO85AcKi+SAPvfQ09H9s73u/dT2nwbVh+cFsT49WDHlvqayyWfSq2+mY
	x0OcC6zEZTI8FOvY6lL194ZD/kLlNg8=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12ddbe104ccso4109573c88.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 23:31:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779345096; cv=none;
        d=google.com; s=arc-20240605;
        b=INu+Fa0gIMXU3wj9juWx+dyJ8JnaRbGhqW6a0h2f4gMjRYmKFMIzDtmUzCWCc5h2IA
         yOMd2vDzd9eZm6LBsJ4YnaT0oKQ8q/T9llYmqqj33rWpRlxqfb3MdQV8swSNs7hFAdvu
         R3uwXGJT4kJOYTv+4EG+CsZNYXp3jWupu/8lUT1I6Jdin+GCjsq3E3DYiV8MWGN4/4Q2
         svtIsYa1CrDI826lbbB0mCvgfMSa//M+6Wk/j5Wws2RPKvisyDKh70twOQ7ZHYzU1aE6
         n2DBEFwZ5Ui4stBPDjCGrQsYwLk37547gp686orFjxcUGQrrkriNXUeUrgh8t55HZlCu
         oqdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8AJoDhF3ETeyKEOdxVy0RXaD013qsjQvrAyiROViV9w=;
        fh=LbLVwUO3GFce/UJzRJzFjIxTpIrSTN/70XzNA1NlaIM=;
        b=hrDToQrhm/79AXq9ad86apJqoETd9KwA7MEgKwumlOkcqASecYR34DxY17lyi5vN9D
         ahPod/uh8crNHxmt2GAfLr/0AZxjnIsEkzbya1BlF6pXglVxmsu2lBTo/FIUItMfvMye
         OsnzRbKmVWc/fVf51aOtJ8luW/XgGQE+5+PNIg9FShrGCJt+Ynb1C6detgm3kc8fgsmE
         nW53FSg1r+SBhSQUpEYPydwGsPz87S07kr8kbxCKAsJoqVJk33Z5fo7d2Y2s5G7VucTV
         vw3XhFUYk2JskBhmE+DBR7fx1FcsrAjiSsSJPPDsO6VwBPiiUA774JdeZffgf0IGzkBF
         BHLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779345096; x=1779949896; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AJoDhF3ETeyKEOdxVy0RXaD013qsjQvrAyiROViV9w=;
        b=jazI6ffM/TE5wGoQL9A23//dpa1Kpt9BJCr5KpJJhk4gG7k1JZc5hcNhGOT2FeK9jj
         zMrldy09yrn+7w5IwdBWRrv0DP3a2l4kikyiPtmOAd4R8IOmD6YtLArCJvXgEgEQ921O
         A5WSFtBEyeM2YzvnwFtU2l0Jpv2l1et8369MT0HKgraHT5WuqNwvbYrjPBqZJzQUICRA
         vvOBgV3nd4DRwHA0faeEhjy2cX2S0861R/AkhmYQ0LCYlyqwsWFevoinyUf/oCoYLwfH
         mkejmRKhoIHSdVGIb1P/ar/uLVuYLuni5iTiXqoV+1kKbEqecFDQr6ZiNFUvL5YH5GYv
         2fnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779345096; x=1779949896;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8AJoDhF3ETeyKEOdxVy0RXaD013qsjQvrAyiROViV9w=;
        b=ZyKmx2YIrmbF02/M8t56OzcOl6k54e5KeC2pRycgBKY+uAZj94Apl5xoycC3FF8Dvn
         r+NbDlJQbzEpHI6ozxVr0ynYvxKt9inwCdsO9iSiiDl6YrLCI6iEpLvVkBU3Wg6vqthb
         PkT7uxPJszC9R2ZocpJQ2VMVvRD4KmwgwF8drv6KNUSRnmgsbRh8AsAibdi8IlTFJwhr
         8WxncuJ0+g7XhZO5phgnSu9o8AbtnhUqLwxwF/LYoz0WxTGS/CEMMVMtzvs7Z3yldYkF
         60VZC77kdzZbmWIv8xkPQKJ4z1dvGIw5y/VBtFi3q+Lpzh9mtlZQWpciGJOhqWhZ/iwX
         evwg==
X-Forwarded-Encrypted: i=1; AFNElJ+4Vo9NDWb+LBGAYrZewujc0zRwr2Z7p23Ks3rdxA8jXe7Jb/HJVyY1sa8VMV24Wq9aH209j7y/bw==@kvack.org
X-Gm-Message-State: AOJu0YyC6Y2f0nLOCbJ0uTb9G+GsKlkrt6T8SFmD2dtqIFbwM/m36ATQ
	xnrIabFuJPYvoLOyn07LUfPoP7VgWjN6DOdUC+l0zgGegrE9+FKPC9xVNPkrZlJZHDycBj+4gab
	DeC0KfwBbd0JjIWwXSIQ7JlST8m+57vE=
X-Gm-Gg: Acq92OFtU3Hn/m1f8Z1TBDJqyMKEWNGg4oQM1wOZzAVRUfqXObaw0gN7yB+qDI3lzO9
	jSjZdhNo9BEqnD4XAu7N4KsOLYTsEuXwzBQ7yFPep3aYaKlczNiZrqLECok51GC396StQl9nAiK
	KBQqI7vdXHI4vAENIoz8sE2o6b2pXUy9x2L4kPwlsEzCDWiicsHH8cxD3ZPg+cgx4BSBrtUbKTP
	UaJq1arB4oxvTU+tmqbTf0xphmIN293/b9Vhl89BV0FB+HvKmZ0MbQayRVDkQls9Nq60gOK1zIR
	rNkWOX8r
X-Received: by 2002:a05:701b:2406:b0:134:ff2e:a71c with SMTP id
 a92af1059eb24-136327f2936mr476828c88.9.1779345095723; Wed, 20 May 2026
 23:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260521025250.1469390-1-chenguanyou@xiaomi.com> <ag55bY5OsuM7cbCB@debian>
In-Reply-To: <ag55bY5OsuM7cbCB@debian>
From: Guanyou Chen <chenguanyou9338@gmail.com>
Date: Thu, 21 May 2026 14:31:24 +0800
X-Gm-Features: AVHnY4KGJEAMyzuB1AKwEU9_lh1cRriGhKZOAObcVmQsjDm31owSuRm2MLx20m0
Message-ID: <CAHS3RMUPmcdt+eP9oYejTJkav7hhc25wNs0gVgECCn9Gv3HnJg@mail.gmail.com>
Subject: Re: [PATCH] sched: restore timer_slack_ns when resetting RT policy on fork
To: Cunlong Li <shenxiaogll@gmail.com>, "Guanyou.Chen" <chenguanyou9338@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Felix Moessbauer <felix.moessbauer@siemens.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Kees Cook <kees@kernel.org>, chenguanyou@xiaomi.com, 
	linqiaoting@xiaomi.com, chunhui.li@mediatek.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 129EEC0016
X-Rspam-User: 
X-Stat-Signature: pictdw1kcsh6wmyzbubqfxyft8ar7sfk
X-HE-Tag: 1779345096-975581
X-HE-Meta: U2FsdGVkX1/KYLHRMoX/ymUK7UIKsBtnBaO+43MlsTXZQIWmJHx8FFHr8kaQ0+L4U33B3INGUNdMfZr6YOcKFugVeg/q0DeDb2rrEpFtmDomyrUFQXeca5icVfzKoq9KWkHVSX/BtEjBGCj4i2vkTem0VlVZe7g6rMB8cPrdooJjeu1kWKYwsNP7qwZh3PhxLuFy6Yxnox0NWvCV3mecb4KSwev80OLOnMaHQgPC35kis0I5uNI6s7/Ni41MbrMUXYCtgUpiRIx9jxR/DMCK3ye/eXjoHAet4iG4fhbogdOyRWB7pDGra28sBXOVvwgdvCyyQ0mT/py5r1+SXGcP+n1jssnINvPVETek/+N8Fc1zjZELOdAQWflFj5mxnjOXi/b+simGJzuHmkfAFpm9XsRpNuWiJBXyovZtD2QMvBAzG1LDazg5kU6KheEqvIbAc9saFg8IfYbp3JaDYjaQIbc+Pv+s1rZq8o0CluFhw5Ss1HhTdifKFZgdRlHdCwjaRE4j4V+eMKWHFD/QLgsn64FQtZeJTfPhN9+7OTMZ57m50y5SLiFUOM8gT1x7+/z9f5wFMuEhN3MK9Sko9v4gl05fteUjK9zWes0hKdZJUJzkVwWCVhpwv1Dhst93gHkUnwyo0HC7pAQKxA+noVxqkmcbon2yQgsqPPYjEfL4jzPqMSsBU5olh+DYUUzxQnvwFqZ5WTvFh6KT/Nas4pjPnM3wT+STK8vKanB2/IBTASCAt77AAf39sX8qb5at9nb0UeBpHVA6C8k7zcTJolxVd1TpJQQg+5j6lJ5wt3HyBbwZAu3CkYkcRLmYpbEJKGTVw+TiVI63SLcdDhkgbKZvzRNcTTRP0OyiFc0OnnMePrbqgwjfiWmwGbP5TDtFotZdgd75WgQu4KGi16Uio6uKYrBvXla5L8o9+BU9B0KwPqPYjAdMgkAXDEvk0kN6eKua3DqJ/eMUTIwLSNVdQEC
 RAuEiKQp
 9Ehby6kckSJH/nBp/EfSpljEb2E+Lg+EpmBCgdhx7Y6zWq4+hYBeUlDlhSwfFCjCv+Aw+id6xjPAfX7mbbXCnSaTStwjrVHhJsupVsvjtJjThZ+ty9EIyYVTgYujlQ+0zXY6FDDLDutcw7q+avOyVNtF66I9pIVrzSITYEcf/JDZ9mhXaV7X1N1nKY8Z+eWpL3rYrhSwWbPpAVYny/6/IOt5gmr7X91mLkvBxLR/EEeSgUJmUvr0DcbMhGbKy6GsGN6jDA4CUJ6oQ1p4MmrEBKy3KDxs1czGBMRS/jSDuaG7rSV0s/RlkipfOyMUMy143aazmV3nHQ5/usMWz7B4y4jtst9kpwhooiZR17WVASAZIY3A7yLvD/kG6HVoouIXh/XDsJVPGPu4ysAZWSCl+jfuYtakimjVcjzKFjfv3fFU0meSzboWAXsT1QJU8FuhIOuLVnAXDUrV2D97sY+2YZFCwAsJVhC9jJW/z+tiwGZfmndwiyo3Gvkovtmvky5a2q22iGsc1m99G4HDXwWcx5r0NlWP5td6+gmxePfK+69DD9Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Cunlong,

Thanks for looking at this.

You're right that this changes the behavior for non-RT tasks - the
child's default_timer_slack_ns would come from dup_task_struct (parent's
default_timer_slack_ns) rather than parent's timer_slack_ns.

However, looking at the original commit 6976675d9404 that introduced
default_timer_slack_ns, its purpose is described as a "reset target" for
prctl(PR_SET_TIMERSLACK, 0). There's no documented requirement that
children should inherit the parent's effective slack as their default.

That said, I'm happy to narrow the fix to only handle the RT parent
case if maintainers prefer preserving the existing behavior. Will wait
for their input.

Thanks
Guanyou


Cunlong Li <shenxiaogll@gmail.com> =E4=BA=8E2026=E5=B9=B45=E6=9C=8821=E6=97=
=A5=E5=91=A8=E5=9B=9B 11:18=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, May 21, 2026 at 10:52:50AM +0800, Guanyou.Chen wrote:
> > Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
> > for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
> > __setscheduler_params(). However, when an RT task with SCHED_RESET_ON_F=
ORK
> > creates child threads, the children inherit timer_slack_ns=3D0 from the
> > parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
> > not restore timer_slack_ns, leaving the child permanently running with
> > zero slack.
> >
> > Additionally, init_task never initialized default_timer_slack_ns, so al=
l
> > processes in the system have default_timer_slack_ns=3D0 inherited from =
init.
> > The original fork code masked this by using timer_slack_ns (50000) as t=
he
> > source for default_timer_slack_ns. After ed4fb6d7ef68, RT tasks have
> > timer_slack_ns=3D0, exposing this latent bug.
> >
> > This causes unnecessary timer interrupts and increased power consumptio=
n,
> > as NORMAL threads with slack=3D0 prevent timer coalescing.
> >
> > Fix this by:
> > 1. Initializing default_timer_slack_ns=3D50000 in init_task.
> > 2. In copy_process(), removing the incorrect default_timer_slack_ns
> >    override (dup_task_struct already copies both timer_slack_ns and
> >    default_timer_slack_ns correctly from the parent).
> > 3. In sched_fork(), restoring timer_slack_ns from default_timer_slack_n=
s
> >    when resetting from RT/DL to NORMAL policy.
> >
> > Before this fix (RT parent, RESET_ON_FORK, 32 child threads usleep(1)):
> >   child slack=3D0, avg_sleep=3D38us, ~832K interrupts/s
> >
> > After this fix:
> >   child slack=3D50000, avg_sleep=3D88us, ~363K interrupts/s
> >
> > Fixes: 6976675d9404 ("hrtimer: create a "timer_slack" field in the task=
 struct")
> > Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values=
 for realtime tasks")
> > Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
> > Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
> > Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
> > ---
> >  init/init_task.c    | 1 +
> >  kernel/fork.c       | 2 --
> >  kernel/sched/core.c | 1 +
> >  3 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/init/init_task.c b/init/init_task.c
> > index 5c838757fc10..57ff8dae9bfb 100644
> > --- a/init/init_task.c
> > +++ b/init/init_task.c
> > @@ -170,6 +170,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYT=
ES) =3D {
> >       INIT_CPU_TIMERS(init_task)
> >       .pi_lock        =3D __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
> >       .timer_slack_ns =3D 50000, /* 50 usec default slack */
> > +     .default_timer_slack_ns =3D 50000, /* 50 usec default slack */
> >       .thread_pid     =3D &init_struct_pid,
> >       .thread_node    =3D LIST_HEAD_INIT(init_signals.thread_head),
> >  #ifdef CONFIG_AUDIT
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 65113a304518..8358df80e11d 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2133,8 +2133,6 @@ __latent_entropy struct task_struct *copy_process=
(
> >       retval =3D -EAGAIN;
> >  #endif
> >
> > -     p->default_timer_slack_ns =3D current->timer_slack_ns;
> Hi Guanyou,
>
> This changes behavior for normal (non-RT) tasks. If a process calls
> prctl(PR_SET_TIMERSLACK, 200000) and then forks, the child currently
> gets default_timer_slack_ns=3D200000 (the parent's effective slack).
> With this removal, the child would get default_timer_slack_ns=3D50000
> (the parent's original default), so a subsequent PR_SET_TIMERSLACK(0)
> in the child would reset to a different value than before.
> I think the fix should be narrowed to only handle the RT parent case:
>         if (rt_or_dl_task_policy(current))
>                 p->default_timer_slack_ns =3D current->default_timer_slac=
k_ns;
>         else
>                 p->default_timer_slack_ns =3D current->timer_slack_ns;
> Thanks
> > -
> >  #ifdef CONFIG_PSI
> >       p->psi_flags =3D 0;
> >  #endif
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index b7f77c165a6e..b1a241810ce0 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4649,6 +4649,7 @@ int sched_fork(u64 clone_flags, struct task_struc=
t *p)
> >                       p->policy =3D SCHED_NORMAL;
> >                       p->static_prio =3D NICE_TO_PRIO(0);
> >                       p->rt_priority =3D 0;
> > +                     p->timer_slack_ns =3D p->default_timer_slack_ns;
> >               } else if (PRIO_TO_NICE(p->static_prio) < 0)
> >                       p->static_prio =3D NICE_TO_PRIO(0);
> >
> > --
> > 2.34.1
> >

