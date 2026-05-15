Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D900CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 20:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63486B0005; Fri, 15 May 2026 16:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C130E6B008A; Fri, 15 May 2026 16:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02116B008C; Fri, 15 May 2026 16:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFEB6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:43:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31EE7120194
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:43:04 +0000 (UTC)
X-FDA: 84770828688.04.BF97C3F
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 21E40100005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:43:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CFWHGADw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778877782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIEPnncosyxG+qoVtyVWxbkjLGRLxQV9lWWWkRh9UR8=;
	b=0jc7ToqKFmxIAbJQXUGsXpBfUOofqUgWe2mT2zGRUb9i7ofvMixb+lFe10ESbw+WIoQ2yR
	UuENam6CIhAo3OnwOi6Bp86BT26bd+oLvNmmlTbES+dCe1J9htZ4CC2lGFTAxm8WkJA9iT
	DE15cnAd+pf/ghgG6AQskC+hvocQe2k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778877782; a=rsa-sha256;
	cv=pass;
	b=bUqKGh3qiRLk4lkfQXcjnEYbUp07SOCLTdy874CO2ae6angjq7mN3LoB5mkCNSzbMfis0q
	5Nu/Y9WVXFoSUkOxe7UqOX+Fq31XXfUxnMuDYvAvgRa3geVpo98sXM4jddwNaI/rtfdCpF
	mtPXu9zjKd0h2GjcBCCrSgyCTxEir7Q=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CFWHGADw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e61648f10so9221cf.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 13:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778877781; cv=none;
        d=google.com; s=arc-20240605;
        b=bdBLHbRQ+QUfYT9MRsfYn0fGgswLqzGN8iIFOGhu/CSIOHx2Naa9kyWM3YLnPBg2qr
         8dWDDI1ULq5hNymzi7EWWGAqvqMNGbVKLfSdKEXJKKKQE0/ilvW7HW4dkfe5vpxyqe7s
         1KiRW2IOab7cjEywIzS+B4deD6yhRd0pqRYax/ucS8Wjd5ECuxCgR0amtbZGPko93FcS
         PrrBEcOqKq8bpnV7KDIvyFUkySGiRpoxu4b/NX9Cl2pc+O86POh53SAVAotxbW9tYwmf
         tJRYnmOBOVaFjwqpYWjIevFZN6NFwZWnobcAH5ASGPZ2qOU1/3LjqPey5te+nb1ViWfI
         fjGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oIEPnncosyxG+qoVtyVWxbkjLGRLxQV9lWWWkRh9UR8=;
        fh=IAXF/x3PS8IrrhvzV/B44bJCa7jaEQ/PM8wU1+hN+sY=;
        b=e8qc4H8xa2jAs4p0h23j/Wose6s8HJHoy/zxULQT6H8zwTIbHM3EiJgxT4xQHW5Ev2
         3GifQzVJZ8SV8eCh6qoMwaFExo8IPagmAp8lLb9pBgJtVjqKRDyQ/zweYY3sbcJnDZwU
         dQvdI2yu0N9Y+xBaL61yxVpZocZym7Xnlow7SpKl1CopWOpKRvJN5qezkmXfoTFs+4fI
         J4ziP2FHyU3AvViWnsmPX9RQPi7+vcCaMmEcDGwTB1R8ZiBlJbNMV78+FbtB+94vnAw1
         VjI68UOtckdRmSoQHUK75dwC4mKUkGotMv0OTAkryJRIS3GuP63a9e+FulkWpqIfkmzJ
         VBoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778877781; x=1779482581; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIEPnncosyxG+qoVtyVWxbkjLGRLxQV9lWWWkRh9UR8=;
        b=CFWHGADwdZxkbn9fx4dt1jA8tf8sqYYK8ZOxogCo26la/WflBYsGy8EksUxLF+2lEU
         rw1HMRauU+zQHGb7mNWZd0ouovuPCktdP83paWpksOm8K6tJrjyIPVTqs/gloJWl/hYq
         ejZG9FTG/jhLzuFmYAU7U5SPy/a3MSlMlVVH09btZnVYqOmnkoefusOgiSO8dXPJtn5q
         5LaXBFPfuJZqwyzLzFh+O+1kLDjIwLQTYr8B4XlK4cWR9CmJRdcPYvNcZUKYmyIeqFci
         OWNv/env3+ejBheLyAl31eHKDWgSH9K0D11V4PcToOlv5PBy61SnPUYhyKP9fGzeCql/
         vS4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778877781; x=1779482581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oIEPnncosyxG+qoVtyVWxbkjLGRLxQV9lWWWkRh9UR8=;
        b=r9SwkI6B0UsipsagdD624YAGF68q4eUe9rIc1o7pGLqgGZllo0omRXy8qjlaSLyce+
         AEU3IukTAJRLhxkWFBoIh2BFPEebJNZ6d1gurwSYKYmA4pnHmxWgn7QqTkyidCxEyPLn
         i1C5hKO+lOPvNkesv74SY1a3bo2uqOw1sUPe+sfXQv6Qrsfr8Eq7XWajByJuhjwy6Eax
         3VXP9eNY7kTjyTG7VLbJ622nmSi5ZYSD6cM1N8+uYHoUrT7gbj7GQNq7yqTyZsnnHHjn
         0qgyGWgMdVQzrP/d7mb04tjLuV2k7431zKb2tX7pgYBVzi8iq5sK8r2eyYRxrPuuL2t9
         YRuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CEWav2vhywHV0ojcGrREkJ//GnXU6fwbTcCCKyOM6jwkYoe6a12pKjnJ9KELm6wdBVZEC9U8i6Q==@kvack.org
X-Gm-Message-State: AOJu0YxZUznxNu4QQG02tb+QYPAEzlB8eVjHqCttDgAkPMFq1twXJIsZ
	MCvumvJDVZPN9iEitlJTTlTdMX0fetgJLlF1ALEtmZTmGFZlnZUQ7TnZuNwIM10hLqY5++Bl+yJ
	ldm/CB6bQMPznBGXe9+sY/p2yC/viQFrRpAsoa0Yo
X-Gm-Gg: Acq92OFgPgUo062j6me/udzVknLkUysBB8CKpLLEBWsJa2d09pcoKqLSeoNXbbsHScN
	5Dk5wT8u1Gt3wA4BIV2aJ+9ZoeubimPuuFrRn71FdvRPsq0N2T+2kbW4JDLHu8OP1hXSp6wEWZd
	rbIAeXsubHJkQetZfP+VxeoKHWH53IrmhbBtADrc/eLEFf3GB5sdb1kTuSeWpgkDO803OZrMtr+
	kK25ivuSE2rDgzlXF5IhhWvyogv6bshkKsakOLSAAqM6uMgSvtIu+ewBOHe4jwXms1Y5mdmARyD
	CrPyry0YheNvaufI
X-Received: by 2002:a05:622a:8d0f:b0:50f:bea3:9485 with SMTP id
 d75a77b69052e-5167000f1ddmr2427121cf.2.1778877780506; Fri, 15 May 2026
 13:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260511214226.937793-1-minchan@kernel.org> <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
In-Reply-To: <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 15 May 2026 13:42:48 -0700
X-Gm-Features: AVHnY4LaA8ooM-LgAY3QYxs9bJUt5O1D11inE3Tl56Z1Ia-0ys_ET_0vdoKDU4Y
Message-ID: <CAJuCfpE_Kew9+umy2=7hzPdAe6yT23y=sk0BB=4BQpMZCJUvpA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL
 flag
To: Christian Brauner <brauner@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Jann Horn <jannh@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, timmurray@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E40100005
X-Rspamd-Server: rspam04
X-Stat-Signature: yy1udw8no75pfg8g6q87auewhig48cus
X-HE-Tag: 1778877781-327794
X-HE-Meta: U2FsdGVkX1/cqTLK+KfNOMFUQuxbMY0p8+Q+/uuZ5AEKzq9TUbJXL+da9d5sMBQpD2YU2tJ1Gf1EuuwRMN8C8nFfk3NEQ0e6bza2bfJ0smDXKEUb/nBopFClxjw/VN4gij9eCBFnMcH/HSxY9AOKPtvYvcBroATxx6bOgPGMFRyQWKQIynbbaiZhnIedY1ErM3RFjmV1Z1qf6Sm6KzFcAIeasL8A5JjsDkintL9G9nF6ZhcrsTHhxwA3cD2WPhXRqZ45c5mKOHCaiklXXbIms7FITPuo+fQGpvom6jD0IHv+IN5HhRLm9IufacRGQmsn3Ia12pRj/MvMKX+gQckYWBo6S4dJwpj2w6NeoH2qiOnlnfZwZ5W9DrF1l3Kx3181la75EHdXNe2uv95xaSEOlMakKd2pkw0Ad4RXNCGM7ptquN92ufOsdn+WyXKY95CSLEXUijaZKA/TPs9jWf9InDynyvhNVNInwD/YsCuKRoWnvQ9JWbnmZxJG7nT14SKhAKN/8HRS8/BiQime5K9wmtNluFqdGxQJWyUCaJir0D5Q1488R/on70/HAzb7R1omg12zdy5obFxMGczh/inSxGUHlz9l0Kztxi/0tcZWvMLl7c9sHsE/4AhTcvnQm2IQHCii7Ui4jARWcJJnimWc/9G/O3sRUeue4Ig6AeTQXbvWUztxbrfcoIM3JpWZ5OMGMwZ/xz6gjx9Lbr31JhJ/p6wd3y0fPSvlpn8YKQ9e65GH3CPICJYLr4/SZTcOyyz414hVqW0CrUep1uYdbOjZSmaoJGmuNiaP0/QuYQB+Q27HJT+RxbYSwVIfUKXrjFE9RuPp4U0B+OKyo7vBJ4WvM0LrduqVaiHGEUEPbkmlcgGnHkuLqQMwxdJPrIfdTSUwU5aCG2TDQvRP5cHE0ewguYlkJF14//qmpdKU9wNsc3jYVD2P9S3gCpdPWKLMdFZtajhogiVuFIyRp2ZXdtB
 bqoTpv82
 004duo//ynasUPkIHQB+4M5xopm7bhOacsnAeWbSZxCQ4MbCXnboKaOizztfCSFYVZ1VOHvv/EUuikUMdLchvKaFnPiTs5bLUCDclB1j8ErqQJdihwxhdh8i+Yi8+T8FxDwRybaZKuacEF4C2Xdx45RPJlvUwGlln+uvNQZe/XQdAvYexR1Ze6RiXjTxUuALPkFOeIVecPf8mn7YWViic/DtaoZ8FI5o9cyLJn5owWO5KoWloLCKhASpYjL887lEPPxltUYNCqAI4EZ0ytiTufOUlKrHbNOYG7RZD8w1P/zbbkp22dY2racpCSgwmEGEI9w+MdBYtHOw7Uk7wSIyvztTAnL2lAO48TRezdwiMV1MgfsmSUQbklmZzYueF4od9qFP07MSQxQgYyM5ZjGhqz2/GIh01MqvDFHt4a9oBYKTCywJco0jipKS/Su0WPOqqtCwsS72HoDb1mloD0mBaHovaczjLluPtp4FA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 7:41=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, May 11, 2026 at 02:42:26PM -0700, Minchan Kim wrote:
> > Currently, process_mrelease() requires userspace to send a SIGKILL sign=
al
> > prior to invocation. This separation introduces a scheduling race windo=
w
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> >
> > When the victim enters the exit path (do_exit -> exit_mm), it clears it=
s
> > task->mm immediately. This causes process_mrelease() to fail with -ESRC=
H,
>
> To be quite frank about the patch as written below: I think this is a
> completely crazy api. And I really dislike it.
>
> Right now we have clear and simple signal sending semantics for pidfds:
>
> * thread-specific pidfd -> thread-directed signal (unless signal is threa=
d-group scoped by default)
> * thread-group pidfd -> thread-group directed signal
>
> with specific overrides for pidfd_send_signal():
>
> * PIDFD_SIGNAL_THREAD           -> only signal thread
> * PIDFD_SIGNAL_THREAD_GROUP     -> signal thread-group
> * PIDFD_SIGNAL_PROCESS_GROUP    -> signal process-group
>
> And now this patch aims to elevate process_mrelease() to a _signal
> sending function_. And the semantics are complete special sauce too.
>
> You are effectively introducing a custom signal scope that is mm-based
> and then also plumbing it into a completely unrelated function that
> should have absolutely nothing to do with this.
>
> This is such Zebroid API. I really would hate to see it land.
>
> This came up because of the ptrace bug that was just recently discovered
> and that Linus fixed yesterday. This is another instance where I think
> the correct fix is to keep task->mm around until the process is reaped
> and then you can throw away all of the really ugly semantic in this
> patch afaict. I'd really like to see that merged as it would also clean
> up the ptrace code:
>
> https://lore.kernel.org/all/20201016024019.1882062-1-jannh@google.com

Yeah, I think this patchset would help process_mrelease() find the mm
to reap even after the process has passed its exit_mm(). We just need
to add:

if (!mm)
        mm =3D task->exit_mm;

Inside process_mrelease(). I had a similar idea of stashing mm and the
approach seems sane to me. Keeping UAPI unchanged is another upside
IMHO.

>
> > leaving the actual address space teardown (exit_mmap) to be deferred un=
til
> > the mm's reference count drops to zero. In the field (e.g., Android),
> > arbitrary reference counts (reading /proc/<pid>/cmdline, or various oth=
er
> > remote VM accesses) frequently delay this teardown indefinitely,
> > defeating the purpose of expedited reclamation.
> >
> > In Android's LMKD scenarios, this delay keeps memory pressure high, for=
cing
> > the system to unnecessarily kill additional innocent background apps be=
fore
> > the memory from the first victim is recovered.
> >
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to suppo=
rt
> > an integrated auto-kill mode. When specified, process_mrelease() direct=
ly
> > injects a SIGKILL into the target task after finding its mm.
> >
> > To solve the race condition, we grab the mm reference via mmgrab() befo=
re
> > sending the SIGKILL. If the user passed PROCESS_MRELEASE_REAP_KILL, we =
assume
> > it will free its memory and proceed with reaping, making the logic as s=
imple
> > as reap =3D reap_kill || task_will_free_mem(p).
> >
> > To handle shared address spaces, we deliver SIGKILL to all processes sh=
aring
> > the same address space using do_pidfd_send_signal_pidns(). This ensures=
 the
> > target pid resides inside the caller's PID namespace hierarchy prior to
> > signal delivery. We iterate over all processes sharing the mm and deliv=
er
> > SIGKILL to each. If delivering the signal to any of the sharing process=
es
> > fails, we return an error. Note that this approach may leave partial
> > side-effects if some processes are killed successfully before a failure=
 occurs.
> >
> > Cc: Christian Brauner <brauner@kernel.org>
> > Suggested-by: Michal Hocko <mhocko@suse.com>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  include/linux/signal.h    |  4 +++
> >  include/uapi/linux/mman.h |  4 +++
> >  kernel/signal.c           | 29 ++++++++++++++++++---
> >  mm/oom_kill.c             | 55 ++++++++++++++++++++++++++++++++++-----
> >  4 files changed, 81 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/signal.h b/include/linux/signal.h
> > index f19816832f05..bdbe6b3addec 100644
> > --- a/include/linux/signal.h
> > +++ b/include/linux/signal.h
> > @@ -276,6 +276,8 @@ static inline int valid_signal(unsigned long sig)
> >
> >  struct timespec;
> >  struct pt_regs;
> > +struct mm_struct;
> > +struct pid;
> >  enum pid_type;
> >
> >  extern int next_signal(struct sigpending *pending, sigset_t *mask);
> > @@ -283,6 +285,8 @@ extern int do_send_sig_info(int sig, struct kernel_=
siginfo *info,
> >                               struct task_struct *p, enum pid_type type=
);
> >  extern int group_send_sig_info(int sig, struct kernel_siginfo *info,
> >                              struct task_struct *p, enum pid_type type)=
;
> > +extern int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum p=
id_type type,
> > +                                   siginfo_t __user *info, unsigned in=
t flags);
> >  extern int send_signal_locked(int sig, struct kernel_siginfo *info,
> >                             struct task_struct *p, enum pid_type type);
> >  extern int sigprocmask(int, sigset_t *, sigset_t *);
> > diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> > index e89d00528f2f..4266976b45ad 100644
> > --- a/include/uapi/linux/mman.h
> > +++ b/include/uapi/linux/mman.h
> > @@ -56,4 +56,8 @@ struct cachestat {
> >       __u64 nr_recently_evicted;
> >  };
> >
> > +/* Flags for process_mrelease */
> > +#define PROCESS_MRELEASE_REAP_KILL   (1 << 0)
> > +#define PROCESS_MRELEASE_VALID_FLAGS (PROCESS_MRELEASE_REAP_KILL)
> > +
> >  #endif /* _UAPI_LINUX_MMAN_H */
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index d65d0fe24bfb..b2dc08a9bdd3 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -4046,6 +4046,30 @@ static int do_pidfd_send_signal(struct pid *pid,=
 int sig, enum pid_type type,
> >       return kill_pid_info_type(sig, &kinfo, pid, type);
> >  }
> >
> > +/**
> > + * do_pidfd_send_signal_pidns - Send a signal to a process via its str=
uct pid
> > + *                              while validating PID namespace hierarc=
hy.
> > + * @pid:   the struct pid of the target process
> > + * @sig:   signal to send
> > + * @type:  scope of the signal (e.g. PIDTYPE_TGID)
> > + * @info:  signal info payload
> > + * @flags: signaling flags
> > + *
> > + * Verify that the target pid resides inside the caller's PID namespac=
e
> > + * hierarchy prior to signal delivery.
> > + *
> > + * Return: 0 on success, negative errno on failure.
> > + */
> > +int do_pidfd_send_signal_pidns(struct pid *pid, int sig, enum pid_type=
 type,
> > +                            siginfo_t __user *info, unsigned int flags=
)
> > +{
> > +     /* Enforce PID namespace hierarchy boundary */
> > +     if (!access_pidfd_pidns(pid))
> > +             return -EINVAL;
> > +
> > +     return do_pidfd_send_signal(pid, sig, type, info, flags);
> > +}
> > +
> >  /**
> >   * sys_pidfd_send_signal - Signal a process through a pidfd
> >   * @pidfd:  file descriptor of the process
> > @@ -4094,16 +4118,13 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, =
int, sig,
> >               if (IS_ERR(pid))
> >                       return PTR_ERR(pid);
> >
> > -             if (!access_pidfd_pidns(pid))
> > -                     return -EINVAL;
> > -
> >               /* Infer scope from the type of pidfd. */
> >               if (fd_file(f)->f_flags & PIDFD_THREAD)
> >                       type =3D PIDTYPE_PID;
> >               else
> >                       type =3D PIDTYPE_TGID;
> >
> > -             return do_pidfd_send_signal(pid, sig, type, info, flags);
> > +             return do_pidfd_send_signal_pidns(pid, sig, type, info, f=
lags);
> >       }
> >       }
> >
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 5c6c95c169ee..253aa80770f2 100644
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
> > @@ -925,6 +926,39 @@ static bool task_will_free_mem(struct task_struct =
*task)
> >       return ret;
> >  }
> >
> > +/*
> > + * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the g=
iven address space.
> > + * @victim: the targeted OOM process group leader
> > + * @mm:     the virtual memory space being reaped
> > + *
> > + * Traverse all threads globally and signal any user processes sharing=
 the identical
> > + * mm footprints, ensuring no concurrent users pin the memory. Skips t=
he system
> > + * global init and kernel worker threads.
> > + */
> > +static int kill_all_shared_mm(struct task_struct *victim, struct mm_st=
ruct *mm)
> > +{
> > +     struct task_struct *p;
> > +     bool failed =3D false;
> > +
> > +     rcu_read_lock();
> > +     for_each_process(p) {
> > +             if (!process_shares_mm(p, mm))
> > +                     continue;
> > +             if (is_global_init(p)) {
>
> You can't signal init in any shape or form any way. Why bother reporting
> failure at all.
>
> > +                     failed =3D true;
> > +                     continue;
> > +             }
> > +             if (unlikely(p->flags & PF_KTHREAD))
> > +                     continue;
> > +
> > +             if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDT=
YPE_TGID, NULL, 0))
> > +                     failed =3D true;
> > +     }
> > +     rcu_read_unlock();
> > +
> > +     return failed ? -EBUSY : 0;
>
> Why are you returning EBUSY? This makes no sense imho.
>
> > +}
> > +
> >  static void __oom_kill_process(struct task_struct *victim, const char =
*message)
> >  {
> >       struct task_struct *p;
> > @@ -1217,9 +1251,11 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, un=
signed int, flags)
> >       unsigned int f_flags;
> >       bool reap =3D false;
> >       long ret =3D 0;
> > +     bool reap_kill;
> >
> > -     if (flags)
> > +     if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
> >               return -EINVAL;
> > +     reap_kill =3D !!(flags & PROCESS_MRELEASE_REAP_KILL);
> >
> >       task =3D pidfd_get_task(pidfd, &f_flags);
> >       if (IS_ERR(task))
> > @@ -1236,19 +1272,24 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, u=
nsigned int, flags)
> >       }
> >
> >       mm =3D p->mm;
> > -     mmgrab(mm);
> >
> > -     if (task_will_free_mem(p))
> > -             reap =3D true;
> > -     else {
> > +     reap =3D reap_kill || task_will_free_mem(p);
> > +     if (!reap) {
> >               /* Error only if the work has not been done already */
> >               if (!mm_flags_test(MMF_OOM_SKIP, mm))
> >                       ret =3D -EINVAL;
> > +             task_unlock(p);
> > +             goto put_task;
> >       }
> > +
> > +     mmgrab(mm);
> >       task_unlock(p);
> >
> > -     if (!reap)
> > -             goto drop_mm;
> > +     if (reap_kill) {
> > +             ret =3D kill_all_shared_mm(task, mm);
> > +             if (ret)
> > +                     goto drop_mm;
> > +     }
> >
> >       if (mmap_read_lock_killable(mm)) {
> >               ret =3D -EINTR;
> > --
> > 2.54.0.563.g4f69b47b94-goog
> >
> >

