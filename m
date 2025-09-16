Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04A0CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0D28E0005; Tue, 16 Sep 2025 12:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461678E0001; Tue, 16 Sep 2025 12:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3501E8E0005; Tue, 16 Sep 2025 12:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6DA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:19:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85DD485763
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:19:10 +0000 (UTC)
X-FDA: 83895622860.06.19D7615
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8FDD740004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:19:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kg65WTnH;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758039548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouS58sMvfoM+nXCDhUN11FIrTKtMJ3xUiuA35NMXazI=;
	b=v5cAsBpIVaAn5+EqnUgVQqUR8P9tglnn8BMN73Aw0XZ94tjg+mrE3Qn6MWAcNstb0Q6VF6
	kiSviinS8l91FYi3JmujLsrtXyIo5XWKsxh4pNygVun3uUfH/NmeNMPJKnCZ2Rzn4BRM+F
	RwW8JVlaglEH1WLYBcefHEvJzLAiqBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758039548; a=rsa-sha256;
	cv=none;
	b=zaAgdZhjiBSkMR4huN3utW94kbgVjk4BGXdTTfJmvZx8y4jBy/30zniftvSnSLAluCvD9p
	5IM4wdK1VXrdT2Pras9UJy8VPfXnGFauioxS7Z8qAExyOaVpXkOXn/HjjSJK3k/wsccNGx
	GncrQITeSYzdTb6qJ0PERQxlZZMuqWA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kg65WTnH;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45decc9e83eso62638265e9.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758039547; x=1758644347; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouS58sMvfoM+nXCDhUN11FIrTKtMJ3xUiuA35NMXazI=;
        b=kg65WTnHHPlOv+nP1q4R/1aFNbKRJSREk2fK/fQa0mgSvHMT5ScAGelUVAMlG/2uOj
         ibe5C5FwvOrhgjB9QQspdB8yHfvNwck3fr9iolYZu9eh14Gq3W6K2wEKGvXGqD7PbAKb
         tpB8bLI9mZMgGJZeFoLhWmkzj+DGwRQLS6O6bJJDnxqHt4N8IAdsKxskdp1EElwIDtH4
         oX+welpM6RV+RtWJOMnIovSAqxcBB1A6SsGzksIDs4J4BVFuYPqH5UghCJizdPe1dXyF
         AIE5o+Oz41WKf8PHiKXXiR8uwMk57Yl1jZDLuaZDEa3nMsqCVcOia9JrqV4LZ7E5UNyW
         /6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758039547; x=1758644347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouS58sMvfoM+nXCDhUN11FIrTKtMJ3xUiuA35NMXazI=;
        b=cRWkbo1ux292MRGAZjtTw84LoHqrDD5bFDiDIG4tFnnW14rZ9qtMe/GhJrF3VkJXik
         Fv5uta/B72kfl7IS5nX+xP021nFiOzAXoks+NEldZiSaBYT3/6xkWgp6omcCik/6qb/y
         Vv3E94XLQ1KCZtI+LO+afeyDMgpnas96H9LBKmAfJNJ1rxAySu5RbnrkkyRNS502c6RN
         USDuFp2jDO+HZLTSSNh/6HBMtUuJTsXA3lCzxqZzPHzjSQgq88+BGBCHvj5TsqfqB+1A
         R3OsrcKJAQObwdypthZBX8rfr8WD7Z5YKx13aO6ZgT+46UxNaJaR4R1Vd/NF3BqHIat2
         JERg==
X-Forwarded-Encrypted: i=1; AJvYcCWWxUEDv1eoZuukyyG6BzP/AyLNNm5Df7Y5AWPf+pP6Cn0uByg1paKJed8IOwiksCGke8kPocDtAg==@kvack.org
X-Gm-Message-State: AOJu0YyFCSWM8RyxU6ZOkOdkyY9ejyYRFW7wN/wKvWq+HXbkNumfyQcw
	6Icdsi2MDR7C2B4KPfs0a6OMFbQCtVA4zpXsFrHNm2/k4HzulI/vaxuwKpL7kkXLfeFnTlMiRta
	cpNX+Horp/UDfxinybP8yCq/4w3aQaUI=
X-Gm-Gg: ASbGnctoHTuOrNuQEfZ3XG7pPKyNh8hxJ/RDnVrNfIeQFDERvzvqnpzMuXWPid4A+12
	E+oWEYT5RVcG4cgDT0Rh3+aOiE+2vvKSd3L5TTwXmRm+wddEBv7j4PbFt2ACZVO7aUFvLYkJkY/
	xc156CGqd5oKGtKFXTh+ldOb9+NBnhvLaFLjfy1JSLdCNPeNd1NeRxRV52ch+BpVMhq4zVCtMfk
	oFMEwx4hM6jAzRUWBk9aQ==
X-Google-Smtp-Source: AGHT+IFbSqcghwg20PclUzSC55sPzfzZOVKAiQJdo5k+zPzjlYzFO1Idmqk7QmwROtx6CfIxX2Bb608DGKedAV+yrcc=
X-Received: by 2002:a05:6000:26c9:b0:3ec:a019:393a with SMTP id
 ffacd0b85a97d-3eca0193af4mr2753349f8f.18.1758039546469; Tue, 16 Sep 2025
 09:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo> <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz>
In-Reply-To: <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 16 Sep 2025 09:18:52 -0700
X-Gm-Features: AS18NWAVwzfTfIA1ia83p45aX2WthP-MAQG-ap9soO4nTXDDqIGs2hVvFhykNdo
Message-ID: <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gehkpz95h3h9a6iiufdsgz1kzwye6dxi
X-Rspamd-Queue-Id: 8FDD740004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758039548-236224
X-HE-Meta: U2FsdGVkX1/WN4jb53a7lE8fgIHRaqkGPQpgJQVt1KUb5d7PaWFBiKFX1yFwCtNQ6si0LxwFL7craiFoccvmhST9S20g30J9F1Fvwdfyixxm/QcUjxvNPWK5hEslCKFqJHeYe7QMtaBmMw5P+5kDJk+pTDeOJ5tRuYxPlJcH5tGA+yjn6zjXLlI1+pGqQYQlXF34Pp/X1auKfqbx52AMy3EC9DbVtZfhBN/s66yM6MiQQ21+KKBCV56bSGBW5NSmwS10EIHjUc17haX1X/mdq5rSs0OYLBAhWBvZ5HAA+PAhJ/DScbNU/m/TfdBngdIYvtNlnIQU9fbbRHe1Heqxj1zxnHDphdvBqRziFOdcsjk5PkhbDgkOWu7PEzmOz+YOpB2sLEN59N65yFrZsqZWcSoW27HGAHV61v9UvsGLySphrwk9dyCbxe4A65iBVcv8nNDzAaAvx59pTJlSo762Ywl+mUEjU/mI3G28OQC/hXrtrX6dqOeKzEeX9r4uwhFoXfaP70XQRqCYsg2e8CSpdmPdKdZiAZoqj3gnzRw8IldUoAf8FsThmzdrykbwCJXhSzLy8dhoICvZaeDczw1Ql09QfajURjH6AIZiQJ6updEyOWdwfaFgZXdnm3metvk35xkXIuk9DAF6P6OvtOXr/uk6Ne+TLvFhGmeFwi83bsRos1nrgSUm0Zv2p9Anu/ecHPfo2pQBwebGAeh9v2REJjDc1sxNSD0ObkGopAqI/BF/0Kps3/Dx5LUglQ9Pqe6/SPnDwznqGPgOJ42le2Q1GFw8F5Uok3CezIL81Lyq1oAY2SFwQWclDbTXnPolKXOZEEEGcaWDfS6znKtV5mTwzPx0v2iiDBY/+UdsBsELr+eHn5eWlNLLsSbJw+vrJTh8W0E0P81Jn0JEi1znbQZsyKTruP7j6Ztc29SCbB1wKbmIzurGQviJpxLriFpJtPZHoFYLmeLzKp1ed5vmrUU
 loH1v56d
 sdGJvoOFdiNvBql9Voe/+NFx0LIPVnvfWtqKJ+0Lkw/ATMJpoSifD9nWeOV6rXL1SB6l8e3vsBvfEgUXoXz+3SiJLDUx9oHKwplkTADWyKCfj+z1fLTG5TTS0+OhfsaDe7TkeevbmiCE2gyIaKCb2v+ioWCZYU7ipVCglYLp4agzjx0KZLOCWXAuM1T5+SF2HiQoHafPZ6YgTM7+UVANuDSF6bv47MRpx0IZ/jz6MPrbqZvfT8pg+kBFpwKCbdGY8pRvrUvi9D6cCpZ/8NmY1C8/ud0pLaGYfXYbHHNRPllXZTLG/TfJGAZDTpRCW3+LwJciab6c2rZOdId0NHFU4rr50GTZ+KSWtcFBbjXEwiRpnwusUqHEpkCocf5ap1T5f3G7U0FiIMLauUrV0xTHbzOtCchaY4YKNkCQKOyytX0xFalL2MvGjhGGxDvrs1M7KESyOVI+vpUoNHwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 6:13=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/16/25 14:58, Harry Yoo wrote:
> > On Tue, Sep 16, 2025 at 12:40:12PM +0200, Vlastimil Babka wrote:
> >> On 9/16/25 04:21, Alexei Starovoitov wrote:
> >> > From: Alexei Starovoitov <ast@kernel.org>
> >> >
> >> > Disallow kprobes in ___slab_alloc() to prevent reentrance:
> >> > kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> >> > kprobe -> bpf -> kmalloc_nolock().
> >> >
> >> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >>
> >> I wanted to fold this in "slab: Introduce kmalloc_nolock() and kfree_n=
olock()."
> >> and update comments to explain the NOKPROBE_SYMBOL(___slab_alloc);
> >>
> >> But now I'm not sure if we still need to invent the lockdep classes fo=
r PREEMPT_RT anymore:
> >>
> >> > /*
> >> >  * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem=
_cache_cpu::lock
> >> >  * can be acquired without a deadlock before invoking the function.
> >> >  *
> >> >  * Without LOCKDEP we trust the code to be correct. kmalloc_nolock()=
 is
> >> >  * using local_lock_is_locked() properly before calling local_lock_c=
pu_slab(),
> >> >  * and kmalloc() is not used in an unsupported context.
> >> >  *
> >> >  * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_lo=
ck_irqsave().
> >> >  * On !PREEMPT_RT we use trylock to avoid false positives in NMI, bu=
t
> >> >  * lockdep_assert() will catch a bug in case:
> >> >  * #1
> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_=
nolock()
> >> >  * or
> >> >  * #2
> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> b=
pf -> kmalloc_nolock()
> >>
> >> AFAICS see we now eliminated this possibility.
> >
> > Right.
> >
> >> >  * On PREEMPT_RT an invocation is not possible from IRQ-off or preem=
pt
> >> >  * disabled context. The lock will always be acquired and if needed =
it
> >> >  * block and sleep until the lock is available.
> >> >  * #1 is possible in !PREEMPT_RT only.
> >>
> >> Yes because this in kmalloc_nolock_noprof()
> >>
> >>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()=
))
> >>                 /* kmalloc_nolock() in PREEMPT_RT is not supported fro=
m irq */
> >>                 return NULL;
> >>
> >>
> >> >  * #2 is possible in both with a twist that irqsave is replaced with=
 rt_spinlock:
> >> >  * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
> >> >  *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(k=
mem_cache_B)
> >> And this is no longer possible, so can we just remove these comments a=
nd drop
> >> "slab: Make slub local_(try)lock more precise for LOCKDEP" now?
> >
> > Makes sense and sounds good to me.
> >
> > Also in the commit mesage should be adjusted too:
> >> kmalloc_nolock() can be called from any context and can re-enter
> >> into ___slab_alloc():
> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> NMI -> bpf ->
> >>     kmalloc_nolock() -> ___slab_alloc(cache_B)
> >> or
> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> tracepoint/kprobe -=
> bpf ->
> >>    kmalloc_nolock() -> ___slab_alloc(cache_B)
> >
> > The lattter path is not possible anymore,
> >
> >> Similarly, in PREEMPT_RT local_lock_is_locked() returns true when per-=
cpu
> >> rt_spin_lock is locked by current _task_. In this case re-entrance int=
o
> >> the same kmalloc bucket is unsafe, and kmalloc_nolock() tries a differ=
ent
> >> bucket that is most likely is not locked by the current task.
> >> Though it may be locked by a different task it's safe to rt_spin_lock(=
) and
> >> sleep on it.
> >
> > and this paragraph is no longer valid either?
>
> Thanks for confirming! Let's see if Alexei agrees or we both missed
> something.

Not quite.
This patch prevents
kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
    kprobe -> bpf

to make sure kprobe cannot be inserted in the _middle_ of
freelist operations.
kprobe/tracepoint outside of freelist is not a concern,
and
malloc() -> ___slab_alloc() -> local_lock_irqsave() ->
   tracepoint -> bpf

is still possible. Especially on RT.

For example, there are trace_contention_begin/end in spinlocks
and mutexes, so on RT it's easy to construct such reentrance
because local_lock_irqsave() is an rtmutex.
On !RT it's just irqsave and as far as I could analyze
the code there are no tracepoints in
local_lock_cpu_slab()/unlock critical sections.

But it would be fine to add a tracepoint (though silly)
if it is not splitting freelist operation.
Like, local_lock_cpu_slab() is used in put_cpu_partial().
There is no need to mark it as NOKPROBE,
since it doesn't conflict with __update_cpu_freelist_fast().
and it's ok to add a tracepoint _anywhere_ in put_cpu_partial().
It's also fine to add a tracepoint right after
local_lock_cpu_slab() in ___slab_alloc(),
but not within freelist manipulations.
rtmutex's trace_contention tracepoint is such
safe tracepoint within a critical section.

So "more precise for LOCKDEP" patch is still needed.

I thought about whether do_slab_free() should be marked as NOKPROBE,
but that's not necessary. There is freelist manipulation
there under local_lock_cpu_slab(), but it's RT only,
and there is no fast path there.

>
> >> >  * local_lock_is_locked() prevents the case kmem_cache_A =3D=3D kmem=
_cache_B
> >> >  */
> >>
> >> However, what about the freeing path?
> >> Shouldn't we do the same with __slab_free() to prevent fast path messi=
ng up
> >> an interrupted slow path?
> >
> > Hmm right, but we have:
> >
> > (in_nmi() || !USE_LOCKLESS_FAST_PATH()) && local_lock_is_locked()
>
> Yes, but like in the alloc case, this doesn't trigger in the
> !in_nmi() && !PREEMPT_RT case, i.e. a kprobe handler on !PREEMPT_RT, righ=
t?
>
> But now I think I see another solution here. Since we're already under
> "if (!allow_spin)" we could stick a very ugly goto there to skip the
> fastpath if we don't defer_free()?
> (apparently declaration under a goto label is a C23 extension)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 6e858a6e397c..212c0e3e5007 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6450,6 +6450,7 @@ static __always_inline void do_slab_free(struct kme=
m_cache *s,
>  {
>         /* cnt =3D=3D 0 signals that it's called from kfree_nolock() */
>         bool allow_spin =3D cnt;
> +       __maybe_unused unsigned long flags;
>         struct kmem_cache_cpu *c;
>         unsigned long tid;
>         void **freelist;
> @@ -6489,6 +6490,9 @@ static __always_inline void do_slab_free(struct kme=
m_cache *s,
>                         return;
>                 }
>                 cnt =3D 1; /* restore cnt. kfree_nolock() frees one objec=
t at a time */
> +
> +               /* prevent a fastpath interrupting a slowpath */
> +               goto no_lockless;

I'm missing why this is needed.

do_slab_free() does:
                if ((in_nmi() || !USE_LOCKLESS_FAST_PATH()) &&
                    local_lock_is_locked(&s->cpu_slab->lock)) {
                        defer_free(s, head); return;

It's the same check as in kmalloc_nolock() to avoid invalid:
freelist ops -> nmi -> bpf -> __update_cpu_freelist_fast.

The big comment in kmalloc_nolock() applies here too.
I didn't copy paste it.
Maybe worth adding a reference like:
/* See comment in kmalloc_nolock() why fast path should be skipped
in_nmi() && lock_is_locked() */

So this patch with NOKPROBE_SYMBOL(___slab_alloc)
is enough, afaict.
Maybe expand a comment with the above details while folding?

