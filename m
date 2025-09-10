Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0301CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272BB8E000A; Wed, 10 Sep 2025 11:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249938E0006; Wed, 10 Sep 2025 11:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F208E000A; Wed, 10 Sep 2025 11:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02EE48E0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:24:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92CE8140942
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:24:12 +0000 (UTC)
X-FDA: 83873711544.23.A2E95AF
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id A7BC340015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:24:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uVZEauUw;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757517850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLzimIwCrnqvV3j5sA3GYOxbGdhxDlHB4mZ0xdr+3d4=;
	b=0SU5FCR8xFvZ4esigA92F/o5K4YHBrItgOxS13gGwniOYe2KO/BMZtg5bQ26noqXC8x/Z1
	wMRfZpqPytV+mVpl4bu+7FnUP3q8as1v/AKvaziUqXdVHNPuaI+bR8quFaxjJtqiRNJVIx
	Z9r2qJH5nVUma2l628uNyv/n29+kiZQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uVZEauUw;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757517850; a=rsa-sha256;
	cv=none;
	b=0t6UANZZSLv7g1ny0QEX93IoFR3aErlQx2p2YBiiPM5eDB9jbxyFahlHoJiMKIyeX/fjb8
	oY/1PRBJChchGVYfkIxzONN7HmZSDh2o7Nx5SWQ+r9ZqOdc2K8o8SFD96VsOJWS1udUncR
	DxWUBdryHb7GjiGtpnp06FybZNDq8Gw=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so16774a12.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757517849; x=1758122649; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLzimIwCrnqvV3j5sA3GYOxbGdhxDlHB4mZ0xdr+3d4=;
        b=uVZEauUw6v2jLfJYMBbXHwG32waMQH5uxa/Wem/49fLrpWLe4brW/LtCNJvGniXYcF
         VKM+M7gzZz0GUgRwtBV/LpjxfECq3ZtFSU5T6N5cDYbVFRfW3yWR99NBFa1humpBeiU8
         LyscTEy0pmk4SwkS9//Yl8B/J/FPWd7UHpvGJASbi94dZAHIST7QO7fYC95jSK2n5Ch7
         fZpY80oW+8RLASH0WPSVC1gkSFf3PFYVuYW6DguzA4PbTykGt4lnb5DKdofJm+jkUUJG
         nrIRpqCDXEdhFjvuLhRjt315ws2BImaZMcjxfEIKapbp7XU9EPWBFLJIxY10cGDWQrkj
         3i3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757517849; x=1758122649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YLzimIwCrnqvV3j5sA3GYOxbGdhxDlHB4mZ0xdr+3d4=;
        b=bxa6QWC9oaZ66+pzYlGg9rvlZokEuTZtP2nOxquBu87ikzbzc7wvYElz3geF/z5A4I
         PpoDmBqMqeZLejex8Y7gZNsb/O1lBCwKKgMr9ggDS7y5p1TexO5EwEHldhzINEBuJ1Qn
         kQUQY13WfTi+lIinxd/K0JrLfd2w31VAv81JawCtte2ziR5Zl6BPhAeGmC614WieQgYL
         VMuPcpvTGJkEoEeVQSB5yVmjPI+pWR3Zdg5Rnr1+HtnJ1zLgQW2MtuicSLVWPU0EHj06
         W7cEHMoBWJSodxO2KMwd9iMkg8BSyucRmpUUvPJiEuQnIyFc1kB9SwwR5CJHGStMP4KC
         qO4w==
X-Forwarded-Encrypted: i=1; AJvYcCVYjrTwkLefHOiNzREFKcKgfCRGZQsfzadhEsk8y+i+d4Z0zEhiZSrwPqcUPNKzNwymMwyipitqVQ==@kvack.org
X-Gm-Message-State: AOJu0YzvUFiDgWsFxWH54fKAmoHxI4t5AsfYvsBnd1Lx2htggd4ob5Fs
	lz73hgULxuXjSXuX6YKBab5c6Mq6dFMwvd08QGTZ/eMp9m3vNYNm9JkhnaD5JlcBGYsPEqLPvED
	guzssjMXeUqLWalDGSe0kwSPyvKH8kGVLdb0GItnA
X-Gm-Gg: ASbGncvcBnADfYZSP65y/w5sfq83GfYa4bIkE4kKcVVj7AB3BTxHvodIfSiwwFlqvWW
	KLsCNl89DoTtvSAb4oDtey+j/+/BlhYxzGEWl/osdVc54C/VKeqTo5m23UG+uxJRDy+rLe/rIok
	6Pomnzf/JOwwEDfE2GRooTVqFf1tQtulxhOXnegZkE18nFgsl/ZALzPfY+NEzgCYJN7vDO8mUaL
	4MDH+zDcgByfq3um49SzeoNLfIFDRfbQRwOpbo2b+c=
X-Google-Smtp-Source: AGHT+IF5Ohw+Igdpiqfr2NaLOCuYq2aGHC6zAz0SPaARab0f2dpehIyUKQUWFW1zcPOADAw5vISpP/RgxkTdWGpY8YI=
X-Received: by 2002:aa7:d5cc:0:b0:61c:32fb:999b with SMTP id
 4fb4d7f45d1cf-62d4e5c8ed1mr83463a12.1.1757517848839; Wed, 10 Sep 2025
 08:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250910143726.19905-1-zhongjinji@honor.com> <20250910143726.19905-2-zhongjinji@honor.com>
 <aMGWAg5jIitYCXdZ@tiehlicka>
In-Reply-To: <aMGWAg5jIitYCXdZ@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 10 Sep 2025 08:23:56 -0700
X-Gm-Features: AS18NWAJ45hQ9B-n7p6XQn7GBwUVm3h_aYmSoIZyWzjk4e_caUPvzXaPHJVMs7E
Message-ID: <CAJuCfpEu_pq5kDgQ2jDnWVNuzVPrMKz2Gw0EeoPU6WD38aBXVA@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] mm/oom_kill: Thaw the entire OOM victim process
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A7BC340015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8g7igmffdz4fgtn5o779gmc168wst3fp
X-HE-Tag: 1757517850-289805
X-HE-Meta: U2FsdGVkX1/Ka95xCzKwkQ974EjZiz3LunVXfS7ZTTbJTzO5Aw1gDuuC5Z7V4bVsPHkP8hojmAe28l2xgp2vRWNtPkP0eKf/WEw8PGSp3T+NkVVTjCMbOL/kbCU5u1loRYE0otpqyZCgfQ+IpwyRsG94bVqyqXRzwU/MZZ8EalFqsbohDPU1CQxQXadcRq2TgfX22L6YpwYlI6nrFgMJOQToAWQ3gaTXH7Yz7s8XEZfAg+nQ3qo3ebDDP69c0CckFFArYQtKlVcuWT79O46jGyMOXLXKyU+kTTd3DRRsHgr8S24v7ItkskJ4ST2xN7ynqdmw/tGW1J9AyWAp2uAdCvasx8Hrw997NGU1mpcNvFpwrWNfLbdyDXuyPhsDiM7dDdhRQC3qqlfGN+Zb22COEMhnGKvgE3KmCMBABd2P29tuKNeQO8yGXSfdCKdrA7s/JVyg/7NeFcqVIdE1+IAehAiYncUVxGCg29bAO7FffYQ0MNkyrSMjov2+KQL3pkkCh+NQT6BdoIbfqE2gqIBsgU7nhxidBV318JSW398jLnu3fclcuGznkIkIrifsnD9+9i3zP/Aw7jI+AIVjy7wGommT2R5o2wPEnR+PdZDXEuOLQwj9Xp95s2CTMzIRU48E0Y8ErqjmnmVv26HTxBHt5QySf0QOtOljwUbRX0d0X/xzRVUaxgMX7ZiodP6Qmkn36JBh7n8eEPjPoHIJVGx9ZKfXi08ZsUiDEC2P9RGP/J6rUArTp5y20gpwm8QdoJJTuMrX4d8gSflts/mcgPx8qJlAhFG1wq7Bd32bh5q5/q6mH9Q4VzkJA/2ZnJJpwxgGcQ2yPNAlT6oM6x+q/vTLv5cxCnqFgafJuQz1JOxxUBrYQIGZ0dMsht30VI4E7gVfgZ7uG7A7Wcgu81RLjm3jHNeatTzZebS7M0TwuywL5CAQryZH3MTxcJwZvOkaLWSFsPr6ebZyUOmQuvJKQJs
 8lFnlPjH
 yt/tTE+thuoGrbShT1Md/IOHhKXXMchwAKQXpdzhbZho2hlatlCpbEsbqTlNQW4eS7iNqtt464+RQfZA7l+qC3yQ/yHGdOV0TScmdROIMaCPaT8I40fxrU0H2+S1hgAALRHRq2d7LMjhoSVaGaYes+ax1/saU+naLbMVZu6aYLp1uL7DK5nGkAaG4rRqgMyDV5ULSrroBCNF9fQNj67vCbuq2vlVNEXVZwflX7fP97yvQrK1WZEXlel+bmTrUtiOdotdvVTHBXRKC38/Ysp7pJfelyzltVQ9p5q+YrbZVLKA0NxWzG6eeZGsGNjPIQuLe0gUo0iUrpvpijuK2zSAIySRgucC1nD8e8Y/KejpFG5C9VrafclKO8xKk0YjCV1fPi2oRuacul244yhhBVsSvuedxeKKqSl6N1hNLLfYV7fHs3mo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 8:15=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Wed 10-09-25 22:37:25, zhongjinji wrote:
> > OOM killer is a mechanism that selects and kills processes when the sys=
tem
> > runs out of memory to reclaim resources and keep the system stable. But=
 the
> > oom victim cannot terminate on its own when it is frozen, even if the O=
OM
> > victim task is thawed through __thaw_task(). This is because __thaw_tas=
k() can
> > only thaw a single OOM victim thread, and cannot thaw the entire OOM vi=
ctim
> > process.
> >
> > Also, freezing_slow_path() decides whether a task is an OOM victim by c=
hecking
> > the task's TIF_MEMDIE flag. When a task is thawed, the freezer bypasses=
 PM
> > freezing and cgroup freezing states to thaw it. But TIF_MEMDIE is not a=
 thread
> > group shared flag, and only one thread is marked with TIF_MEMDIE. If ot=
her
> > threads are thawed, they may still remain frozen due to PM freezing and=
 cgroup
> > freezing states.
> >
> > To solve this, thaw_process() is introduced to thaw all threads of the =
victim,
> > ensuring every thread in the victim process can be thawed. The freezer =
uses
> > tsk_is_oom_victim() to determine whether a task is an OOM victim, becau=
se
> > tsk->signal->oom_mm is data shared by all threads. This allows all vict=
im threads
> > to rely on it to be thawed.
>
> A history detour for future reference.
> TIF_MEMDIE was a "this is the oom victim & it has access to memory
> reserves" flag in the past. It has that thread vs. process problems and
> tsk_is_oom_victim was introduced later to get rid of them and other
> issues as well as the guarantee that we can identify the oom victim's mm =
reliably
> for other oom_reaper. I recommend reading git log of mm/oom_kill.c to
> get hairy history of that area and how tricky it is due all the subtle
> interaction with process exit paths etc.
>
> >
> > This change will thaw the entire victim process when OOM occurs,
> > ensuring that the oom victim can terminate on its own.
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> >
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  include/linux/freezer.h |  2 ++
> >  kernel/freezer.c        | 20 +++++++++++++++++++-
> >  mm/oom_kill.c           | 10 +++++-----
> >  3 files changed, 26 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > index b303472255be..32884c9721e5 100644
> > --- a/include/linux/freezer.h
> > +++ b/include/linux/freezer.h
> > @@ -47,6 +47,7 @@ extern int freeze_processes(void);
> >  extern int freeze_kernel_threads(void);
> >  extern void thaw_processes(void);
> >  extern void thaw_kernel_threads(void);
> > +extern void thaw_process(struct task_struct *p);
> >
> >  static inline bool try_to_freeze(void)
> >  {
> > @@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -EN=
OSYS; }
> >  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
> >  static inline void thaw_processes(void) {}
> >  static inline void thaw_kernel_threads(void) {}
> > +static inline void thaw_process(struct task_struct *p) {}
> >
> >  static inline bool try_to_freeze(void) { return false; }
> >
> > diff --git a/kernel/freezer.c b/kernel/freezer.c
> > index 6a96149aede9..ddc11a8bd2ea 100644
> > --- a/kernel/freezer.c
> > +++ b/kernel/freezer.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/export.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/freezer.h>
> > +#include <linux/oom.h>
> >  #include <linux/kthread.h>
> >
> >  /* total number of freezing conditions in effect */
> > @@ -40,7 +41,7 @@ bool freezing_slow_path(struct task_struct *p)
> >       if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
> >               return false;
> >
> > -     if (test_tsk_thread_flag(p, TIF_MEMDIE))
> > +     if (tsk_is_oom_victim(p))
> >               return false;
> >
> >       if (pm_nosig_freezing || cgroup_freezing(p))
> > @@ -206,6 +207,23 @@ void __thaw_task(struct task_struct *p)
> >               wake_up_state(p, TASK_FROZEN);
> >  }
> >
> > +/*
> > + * thaw_process - Thaw a frozen process
> > + * @p: the process to be thawed
> > + *
> > + * Iterate over all threads of @p and call __thaw_task() on each.
> > + */
> > +void thaw_process(struct task_struct *p)
> > +{
> > +     struct task_struct *t;
> > +
> > +     rcu_read_lock();
> > +     for_each_thread(p, t) {
> > +             __thaw_task(t);
> > +     }
> > +     rcu_read_unlock();
> > +}
> > +
> >  /**
> >   * set_freezable - make %current freezable
> >   *
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..88356b66cc35 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -772,12 +772,12 @@ static void mark_oom_victim(struct task_struct *t=
sk)
> >               mmgrab(tsk->signal->oom_mm);
> >
> >       /*
> > -      * Make sure that the task is woken up from uninterruptible sleep
> > -      * if it is frozen because OOM killer wouldn't be able to free
> > -      * any memory and livelock. freezing_slow_path will tell the free=
zer
> > -      * that TIF_MEMDIE tasks should be ignored.
> > +      * Make sure that the process is woken up from uninterruptible sl=
eep
> > +      * if it is frozen because OOM killer wouldn't be able to free an=
y
> > +      * memory and livelock. The freezer will thaw the tasks that are =
OOM
> > +      * victims regardless of the PM freezing and cgroup freezing stat=
es.
> >        */
> > -     __thaw_task(tsk);
> > +     thaw_process(tsk);
> >       atomic_inc(&oom_victims);
> >       cred =3D get_task_cred(tsk);
> >       trace_mark_victim(tsk, cred->uid.val);
> > --
> > 2.17.1
>
> --
> Michal Hocko
> SUSE Labs
>

