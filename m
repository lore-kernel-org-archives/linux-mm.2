Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB51CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2CB6B008A; Thu, 21 May 2026 02:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5726C6B008C; Thu, 21 May 2026 02:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413E76B0092; Thu, 21 May 2026 02:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4E06B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:23:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D381CC1732
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:23:57 +0000 (UTC)
X-FDA: 84790436514.04.CE33121
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id D752C160006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:23:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jxnx976c;
	spf=pass (imf08.hostedemail.com: domain of chenguanyou9338@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779344635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DN6lDGP0zoTEsywu0P4AciXwBGxL+M+bZB0GgpJgtqg=;
	b=nxMb8GJuSQJUpN+voeAARvZ80ukbak82als2GlYeG10bbi3GsG/KRCsDQrd1zVXmCTorYh
	EtnHhmIeOnr3TmRZegxURreZjrbZxazXbIHNQfE4lyUcTdHN0jXWcg8IsQZSR4OFnO826X
	hey9oBL5IooD/xM5+Zul0ZScWbQosEY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jxnx976c;
	spf=pass (imf08.hostedemail.com: domain of chenguanyou9338@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779344635; a=rsa-sha256;
	cv=pass;
	b=emMc2w7cwvWcnh/9p1Xq0jt0nyvuq1HFcw/IFg/fCBaT3421PCTkSWybeAmrdMnVVeaRlz
	T5NuGyIt81LuDQLhJIL8OmCGGZMbQAejpr+WkJ9JbYsKx1LtzLB44KMxvxqbScaWLVUsbH
	IN4tXQxAyt1iZiotJGk63yXLxN55Hwo=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12db2e415a7so2775405c88.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 23:23:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779344635; cv=none;
        d=google.com; s=arc-20240605;
        b=KOh1n13TMX76h4nseyHUgJzy6BLsA7D0SI7SXQgxRyhKpg2URGXAsC3SCx/xzunsD/
         nvsF80nGhPBnf/ViTFvymFwrhNxF0uRzdWb5SXohISvbqZ4DlasgjdIHuUU+o8YPufC6
         baObppG1/ID6om2umykbUMXamJxPn5Ny7AZLMJEM8ESUXKl4JQoL9yAeReRoMZ7SQq0L
         RFNdI1es/a48+Mw83NIkwt5vH/CaAx7D5Z7Mu23qyw8aWwFqLKKbbifBkkmxK63ysme4
         ArKDNDeyOmmCrdhma/bd8gKe+6QvWGJe0dRQRgg0DQk7QfzlzJH8JYkB9b/5Y36akZKP
         aa0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :dkim-signature;
        bh=DN6lDGP0zoTEsywu0P4AciXwBGxL+M+bZB0GgpJgtqg=;
        fh=L91HXCius01XAVdcqbxu5pVzttcW+q7fmR/j06SO7v8=;
        b=h3ZmlsYiRFBQ9U4bwjsaGUNC8k5hOWkKtH3EMpkfROKZP25oHqL2w6lyNVe6+5o2UX
         O2qrs0aIh9HDOY1ffOT4+98hpg3IAaZTxv/UCxN7OzRDhhDl8GidVwhawpCOUjp3GDS9
         DqzO9V7lumleW+xFy+bC7ii7cGFe3wNA34Mc2RleVfrI/8nlVL7hkySlzwEHy9Eg6bk5
         /XsZe1pLw6m6sfXbBqEejeaYI71/eif7s2bWFJLhzZgg4x2EJ/AuQL+hLMEjsoshq0lA
         v6MT/sR6L6bOtRGerm+j/gJlv9Y3Azlc1qzqJCy04dIF/Y0GWDhm7EHLS6/RMCmetUaP
         8ZHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779344635; x=1779949435; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DN6lDGP0zoTEsywu0P4AciXwBGxL+M+bZB0GgpJgtqg=;
        b=jxnx976cJcI1p9a4S+Zd7t+9/ggyRiu3rsMKhabOv6XwoqCwWif6jC38B+2YPbrI4x
         ysmbXMwYcy5L4yrgwNHLGH++o7TRotAIjjUdbkAxzkCY4AunXHXigb3u/8XxczJdarXe
         ybWS7cKe1J5eu7X7TnfWkzoIGqIAQuR20pFUSkdhJYUclhdwwhQOrsMWboo+UOiOoYMy
         WHatVcuu0mM8911ky9e18S7L+dBWDYWSEyDh1QX0kisY7t+VUNOxbmAUV6rt3UNM3FHd
         xMaJVvnZpurw/ijYwcWE4SWDcFJ9aJgVPaKY/uRzvWNzJE+qyvoRPgxlkTuIYT4yyOR5
         kgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779344635; x=1779949435;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DN6lDGP0zoTEsywu0P4AciXwBGxL+M+bZB0GgpJgtqg=;
        b=gLEVbqf9Tj212iH8QEgjr+EjhJ2Dnz7jfe10/R1fs9X7sggRtE3kKvDp/1xHuk5Cib
         XM+VrMR/JJtEskwGMyyJzm4W3HdeQPgCuSB7lrqL8vBncZy5Keh7CPpLlA2m3zDebILo
         BDlENn+UiJfYTOQP0voQ0rSlfcY0t49hd2VIu4Xrgz50JUU7LK1O7idC8WIqkfWzvkod
         zn/TPgd+IUKKs+DSzEFDgu0U5T799AR6CVUwf6+sxUbJ48yG5wZJRac2QHy+bkaIA33Z
         UnJ6YkoKpMnF+/Yg2URyUFt+ccTXhImyCbn9EeAUKRMfNogGX4DRQr4AKZl8sKTswmQU
         1Fsw==
X-Forwarded-Encrypted: i=1; AFNElJ9MDungqSGVYZo9qFcr0A6q26zE+bzA4Q4fi9iesqHuVxJx01hHwZIBivwXW0O+kHyDqs+R+d3WUQ==@kvack.org
X-Gm-Message-State: AOJu0YyYw3nSekyW78M6UJua2c+Pp4niUKM6NXB5ipqcZEzwaXEu204A
	paXRugEJcFirKMrOJkcqS9O6OJOTMbgeWPOYPC36xguzW9KglWJ9kFOTDVaqK1L5WspXJ5egyhG
	66obC20txJdXjfz4rk8vQIL+bpnCYH94=
X-Gm-Gg: Acq92OHcjGVdLEfKMQmsV3OdF7GcG8BnknMe9caRNQqaUtXA/FCC5GLznlB3329Dxd4
	JAW/0oJ1wzSBtB29vDwYbJpjYj6DoiumjcfJmB2z75h4+gtS4Cbz7gxm6fEMFdQws6MwEqUwZOM
	67uw0M5XKfEFN0Srp7Y9GkyDmqsVexHFcMAJy8w9eCJ0apOtHxYoEAAVIzz7yeOw3QDxNdvla4Y
	zqIPeyJTUX2m9rfwR/h2GFz8cYbbSvYpImhvd4YgwtSt6BLq9Dr2Mz6/RWQaUJLA31DowvdV+Ya
	aC+k64XB
X-Received: by 2002:a05:7022:40c:b0:12a:6c4b:9cf0 with SMTP id
 a92af1059eb24-136327e48ebmr852300c88.3.1779344634489; Wed, 20 May 2026
 23:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260521025250.1469390-1-chenguanyou@xiaomi.com> <ag55bY5OsuM7cbCB@debian>
In-Reply-To: <ag55bY5OsuM7cbCB@debian>
From: Guanyou Chen <chenguanyou9338@gmail.com>
Date: Thu, 21 May 2026 14:23:42 +0800
X-Gm-Features: AVHnY4LTnnggUFnr0trrPnZdgFGj7BrZTztOH3m9ZRRemKhoDu-8cb8x_lHkYGU
Message-ID: <CAHS3RMXeNV7QF7iq+CbTR27zc292Kty4MqBUtFApoj06jj+Vdg@mail.gmail.com>
Subject: Re: [PATCH] sched: restore timer_slack_ns when resetting RT policy on fork
To: Cunlong Li <shenxiaogll@gmail.com>, "Guanyou.Chen" <chenguanyou9338@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Felix Moessbauer <felix.moessbauer@siemens.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Kees Cook <kees@kernel.org>, chenguanyou@xiaomi.com, 
	linqiaoting@xiaomi.com, chunhui.li@mediatek.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="000000000000df2dfc06524df417"
X-Stat-Signature: 97sx9qu5gh4kgxaouq53htcteokzam61
X-Rspamd-Queue-Id: D752C160006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779344635-658383
X-HE-Meta: U2FsdGVkX189yOrt5qZ+ly+jVghCZCZBZ7DhSPiBEBxDVkuz2IhJ+gq6mICLk/IVgbChAQDBYp2Vy25R1cAOsHGyuFT6ideo1MGRAFc/n3P1H6gICUm5+42xG3TdGH0u+x+7vp5MaRulHHxmqu7Sx3SdL9CeCsCDpyw3JC6XyatB7wKeFeyIstsfSXp6skbK5xXgqd7VTzJIhhewx5b7bdkwIT9fOWhAZIi69J5lC6VHG8c/oTYrfcUEfnCIaWo2V1dxcd5uFG//gI+fuX3ApHmdx7/NQRBS9XBMqbtONfNAAhdmSKTnA0FZiYjRYov+hE/Xg6LnN8s7qDIx0KWje3xYFE7O1U/Ll+F0StYdHJoAqZLmV2vEsHqJic1liIH5IYUD0Gqc9UAdTtOFRXFT/TM2H/u8+apvkvhvMUqSTWMjhr2mKLCm5XCMDi09bJ1tpKlyasGvBUlb9VI7XfwxkZydLfv/ZhpXzjm4gqSYseZj/P/I3c3NddNFRo57U3MQBX3gyhsAAG1fHDIElzIipiYPy3F7ElBKFjkDtVtceormVbeHuRteRvJ++Ot5m94i2B8w4/DUW9cah/U2StRZ1V05OOvXQ82nDuIpHCBT2DNOwvmzGTFqMPqJgaDj2otuawKsay7vtf2twD2IT6/kiPSdGARxvoZpUsj/EsMz1FNhKQjpk8y2vls+BUFfglfOyQFyLJ3TcxUJD84kN5qrT21dZhXEe1zxEvRZheW0EpIHi3ylRS5K7WASqhUziCI7QSeQZbnB7ZvoDU7C4wimPzrdrugoGh+atBTNUED3CiVl96YSq+uTAMLso9jAcre3j/MJje5RQJaaAM+KHL1f6eN/l4uibQIBKW8K3VfMxBr7sLhWFkmafARj/XsguzwKb/KMkCH0xur/xaEMSMq7mf0Zun+jclTK8CyEjsd96raE3cYr2Gcs5OJl2/Rw+ejiwaWeg4WJuxIVbkseMcE
 DUxqkXGi
 XR6WWGBvtY6xXLTX89wiKqCXMjrTp6Z5eyY6CbnmlLcisu0L/Vfl2utEfOuwJcGVwojnNi2lFuxcwKPBWF24DMkvTzCvaUoSVMp2WaiW+rB43f05VeFAN6USht3Sc56RGVdlX/ePsgC43oEDuwWrXjbBK0RF/PXa411K4E+uQM78rNG4TUFCmQIO3o/OCi20+JJhPRiYQ7axK9QpkY1w7i0JM1DuxTUzfAg0/aJaSrCVt5jT0SZJcsgBbb7SSg3yi/8HeJGQBBvUPuTBreCB2CcLFE/LsKEbL/+8tLErt1FT8NQc3CzGnaQY+q19mvNqzq6Yfk1zUFf77NyDwaUrNCJP2TVCmS9duOf9VIOMXVEgBDj504Ol7D+o355xnbzQ+BmV4bwVo4ZBOdKMkZ3UJQGlIbdEfBtrjHJrsDnjMHA3S5zBwJhes/li2sXW0duc0+pLQ1aVefBpjjPfBBRAJlCboCZC2C6gE5cIqu7G+gOXj2jH7hK2Dp62Bh2W9GoVQL3+oLXovk+r7VNBkq1BM5jI+LIfKGERpjcKbdKNYr/9th+1poT4+hoowZvEq/qI3eY8010sVlrdBP761L5SusL/IUjfzG6DW7QjT09kXqt1XyBOfsHZoGxnlgtvbdSernNvAa4RaI/J3HOHOmb4wTbP9jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000df2dfc06524df417
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

> On Thu, May 21, 2026 at 10:52:50AM +0800, Guanyou.Chen wrote:
> > Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
> > for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
> > __setscheduler_params(). However, when an RT task with
> SCHED_RESET_ON_FORK
> > creates child threads, the children inherit timer_slack_ns=3D0 from the
> > parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
> > not restore timer_slack_ns, leaving the child permanently running with
> > zero slack.
> >
> > Additionally, init_task never initialized default_timer_slack_ns, so al=
l
> > processes in the system have default_timer_slack_ns=3D0 inherited from
> init.
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
> > Fixes: 6976675d9404 ("hrtimer: create a "timer_slack" field in the task
> struct")
> > Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
> for realtime tasks")
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
> > @@ -170,6 +170,7 @@ struct task_struct init_task
> __aligned(L1_CACHE_BYTES) =3D {
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
>                 p->default_timer_slack_ns =3D
> current->default_timer_slack_ns;
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
t
> *p)
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
>

--000000000000df2dfc06524df417
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Cunlong,<div><br><div><div>Thanks for looking at this.=
=C2=A0</div><div><br>You&#39;re right that this changes the behavior for no=
n-RT tasks - the</div><div>child&#39;s default_timer_slack_ns would come fr=
om dup_task_struct (parent&#39;s<br>default_timer_slack_ns) rather than par=
ent&#39;s timer_slack_ns.<br><br>However, looking at the original commit 69=
76675d9404 that introduced<br>default_timer_slack_ns, its purpose is descri=
bed as a &quot;reset target&quot; for</div><div>prctl(PR_SET_TIMERSLACK, 0)=
. There&#39;s no documented requirement that<br>children should inherit the=
 parent&#39;s effective slack as their default.<br><br>That said, I&#39;m h=
appy to narrow the fix to only handle the RT parent<br>case if maintainers =
prefer preserving the existing behavior. Will wait<br>for their input.<br><=
br>Thanks<br>Guanyou<br></div></div></div></div><br><div class=3D"gmail_quo=
te gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">Cunlong Li =
&lt;<a href=3D"mailto:shenxiaogll@gmail.com">shenxiaogll@gmail.com</a>&gt; =
=E4=BA=8E2026=E5=B9=B45=E6=9C=8821=E6=97=A5=E5=91=A8=E5=9B=9B 11:18=E5=86=
=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">On Thu, May 21, 2026 at 10:52:50AM +0800, Guanyou.Chen wrote:<br>
&gt; Commit ed4fb6d7ef68 (&quot;hrtimer: Use and report correct timerslack =
values<br>
&gt; for realtime tasks&quot;) sets timer_slack_ns to 0 for RT tasks in<br>
&gt; __setscheduler_params(). However, when an RT task with SCHED_RESET_ON_=
FORK<br>
&gt; creates child threads, the children inherit timer_slack_ns=3D0 from th=
e<br>
&gt; parent. sched_fork() resets the child&#39;s policy to SCHED_NORMAL but=
 does<br>
&gt; not restore timer_slack_ns, leaving the child permanently running with=
<br>
&gt; zero slack.<br>
&gt; <br>
&gt; Additionally, init_task never initialized default_timer_slack_ns, so a=
ll<br>
&gt; processes in the system have default_timer_slack_ns=3D0 inherited from=
 init.<br>
&gt; The original fork code masked this by using timer_slack_ns (50000) as =
the<br>
&gt; source for default_timer_slack_ns. After ed4fb6d7ef68, RT tasks have<b=
r>
&gt; timer_slack_ns=3D0, exposing this latent bug.<br>
&gt; <br>
&gt; This causes unnecessary timer interrupts and increased power consumpti=
on,<br>
&gt; as NORMAL threads with slack=3D0 prevent timer coalescing.<br>
&gt; <br>
&gt; Fix this by:<br>
&gt; 1. Initializing default_timer_slack_ns=3D50000 in init_task.<br>
&gt; 2. In copy_process(), removing the incorrect default_timer_slack_ns<br=
>
&gt;=C2=A0 =C2=A0 override (dup_task_struct already copies both timer_slack=
_ns and<br>
&gt;=C2=A0 =C2=A0 default_timer_slack_ns correctly from the parent).<br>
&gt; 3. In sched_fork(), restoring timer_slack_ns from default_timer_slack_=
ns<br>
&gt;=C2=A0 =C2=A0 when resetting from RT/DL to NORMAL policy.<br>
&gt; <br>
&gt; Before this fix (RT parent, RESET_ON_FORK, 32 child threads usleep(1))=
:<br>
&gt;=C2=A0 =C2=A0child slack=3D0, avg_sleep=3D38us, ~832K interrupts/s<br>
&gt; <br>
&gt; After this fix:<br>
&gt;=C2=A0 =C2=A0child slack=3D50000, avg_sleep=3D88us, ~363K interrupts/s<=
br>
&gt; <br>
&gt; Fixes: 6976675d9404 (&quot;hrtimer: create a &quot;timer_slack&quot; f=
ield in the task struct&quot;)<br>
&gt; Fixes: ed4fb6d7ef68 (&quot;hrtimer: Use and report correct timerslack =
values for realtime tasks&quot;)<br>
&gt; Reported-by: Qiaoting.Lin &lt;<a href=3D"mailto:linqiaoting@xiaomi.com=
" target=3D"_blank">linqiaoting@xiaomi.com</a>&gt;<br>
&gt; Signed-off-by: Guanyou.Chen &lt;<a href=3D"mailto:chenguanyou@xiaomi.c=
om" target=3D"_blank">chenguanyou@xiaomi.com</a>&gt;<br>
&gt; Signed-off-by: Chunhui.Li &lt;<a href=3D"mailto:chunhui.li@mediatek.co=
m" target=3D"_blank">chunhui.li@mediatek.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 init/init_task.c=C2=A0 =C2=A0 | 1 +<br>
&gt;=C2=A0 kernel/fork.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 --<br>
&gt;=C2=A0 kernel/sched/core.c | 1 +<br>
&gt;=C2=A0 3 files changed, 2 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/init/init_task.c b/init/init_task.c<br>
&gt; index 5c838757fc10..57ff8dae9bfb 100644<br>
&gt; --- a/init/init_task.c<br>
&gt; +++ b/init/init_task.c<br>
&gt; @@ -170,6 +170,7 @@ struct task_struct init_task __aligned(L1_CACHE_BY=
TES) =3D {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_CPU_TIMERS(init_task)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0.pi_lock=C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D __RA=
W_SPIN_LOCK_UNLOCKED(init_task.pi_lock),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0.timer_slack_ns =3D 50000, /* 50 usec defaul=
t slack */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0.default_timer_slack_ns =3D 50000, /* 50 usec def=
ault slack */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0.thread_pid=C2=A0 =C2=A0 =C2=A0=3D &amp;init=
_struct_pid,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0.thread_node=C2=A0 =C2=A0 =3D LIST_HEAD_INIT=
(init_signals.thread_head),<br>
&gt;=C2=A0 #ifdef CONFIG_AUDIT<br>
&gt; diff --git a/kernel/fork.c b/kernel/fork.c<br>
&gt; index 65113a304518..8358df80e11d 100644<br>
&gt; --- a/kernel/fork.c<br>
&gt; +++ b/kernel/fork.c<br>
&gt; @@ -2133,8 +2133,6 @@ __latent_entropy struct task_struct *copy_proces=
s(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EAGAIN;<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0p-&gt;default_timer_slack_ns =3D current-&gt;time=
r_slack_ns;<br>
Hi Guanyou,<br>
<br>
This changes behavior for normal (non-RT) tasks. If a process calls<br>
prctl(PR_SET_TIMERSLACK, 200000) and then forks, the child currently<br>
gets default_timer_slack_ns=3D200000 (the parent&#39;s effective slack).<br=
>
With this removal, the child would get default_timer_slack_ns=3D50000<br>
(the parent&#39;s original default), so a subsequent PR_SET_TIMERSLACK(0)<b=
r>
in the child would reset to a different value than before.<br>
I think the fix should be narrowed to only handle the RT parent case:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rt_or_dl_task_policy(current))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;default_timer=
_slack_ns =3D current-&gt;default_timer_slack_ns;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p-&gt;default_timer=
_slack_ns =3D current-&gt;timer_slack_ns;<br>
Thanks<br>
&gt; -<br>
&gt;=C2=A0 #ifdef CONFIG_PSI<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0p-&gt;psi_flags =3D 0;<br>
&gt;=C2=A0 #endif<br>
&gt; diff --git a/kernel/sched/core.c b/kernel/sched/core.c<br>
&gt; index b7f77c165a6e..b1a241810ce0 100644<br>
&gt; --- a/kernel/sched/core.c<br>
&gt; +++ b/kernel/sched/core.c<br>
&gt; @@ -4649,6 +4649,7 @@ int sched_fork(u64 clone_flags, struct task_stru=
ct *p)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0p-&gt;policy =3D SCHED_NORMAL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0p-&gt;static_prio =3D NICE_TO_PRIO(0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0p-&gt;rt_priority =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0p-&gt;timer_slack_ns =3D p-&gt;default_timer_slack_ns;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (PRIO_=
TO_NICE(p-&gt;static_prio) &lt; 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0p-&gt;static_prio =3D NICE_TO_PRIO(0);<br>
&gt;=C2=A0 <br>
&gt; -- <br>
&gt; 2.34.1<br>
&gt; <br>
</blockquote></div>

--000000000000df2dfc06524df417--

