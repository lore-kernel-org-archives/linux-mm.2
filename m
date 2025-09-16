Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D662CCAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1EE8E0007; Tue, 16 Sep 2025 14:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252148E0005; Tue, 16 Sep 2025 14:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148218E0007; Tue, 16 Sep 2025 14:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01FF58E0005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:46:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAA11584AE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:46:20 +0000 (UTC)
X-FDA: 83895993720.21.8C37029
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id B99C81C000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:46:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kGbbALAp;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758048378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIfHkkN0KymLLDe2RxUNHtpRmvEkAgg1GpcLf9403Ls=;
	b=H81r//VH3gOQ9jwkOc85dJcV4UAq+SsY4UnbDBvaDnBp+1ISd7UkVJeL7nSZhoEL9VpHsZ
	RdHEIsrlk+YeT2BeHhIaHw9DjrQzZaQB4veQeCT24FnDOpmZpmfaPPhyZUejo9TvIZO2HW
	N7D6JooffAoQH/y2p+/xyeJGdQrF4Qk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kGbbALAp;
	spf=pass (imf20.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758048378; a=rsa-sha256;
	cv=none;
	b=a7+K9ZcHwCbii2dPIgxF3VWesZbPW85WOXcFoKl0NsaDzrMXdtdEy/D2hFi9N27wxMqQMR
	ZNf3MvB+oJhCvdo1jZp8Nxhi/TPoHrxFC02uk6yhraWCtLemo/uYJmhtxqJVsYHCbKLrvh
	8Pmz3ykitu4XsMLlZupnZAGUIA5CQ7Q=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45b9c35bc0aso51844255e9.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758048377; x=1758653177; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIfHkkN0KymLLDe2RxUNHtpRmvEkAgg1GpcLf9403Ls=;
        b=kGbbALApFuCGFA2n9WfLWwqGqVDfzsdVmUgblFzUIF7zyoDpEnRSL/4r+XmQ0RzFO+
         vSlIycITVisUAI0klM/7o5CrK9CRvZgK05Ii8Ko3KJUomGR5kcYBPMT8C+NWWGPb+l5t
         SkHMMGISWOGdwzBN6Mn/s6vks2pyZfg5KMZwuEwkhniUpFaK1WTr3XCuqT0i/6GsspFH
         sYSJoNGALdCksLZ8LbgsJFCA8gBLqPxLoDJdGk4KrjdMR43K6ET69xLaxYsWVLi3BkBf
         87b4REika+yvzketInVyabC19m8SQYF0j6r6FhhWnoIJcbdIr41cUv99XMtRvCVUgmUu
         Rx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758048377; x=1758653177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIfHkkN0KymLLDe2RxUNHtpRmvEkAgg1GpcLf9403Ls=;
        b=aqzvNV4oDn2EOzCn2Jk3eOFzLwWbo7lgMM5dVcaZKCGFBlekYme3vEUavo5erl8iqr
         DptcQhYgyEr5ZuFOvzwUuNzgPtM/lS5ZeHhyYCIABQfcWpLsTYPmmzQ+xpea6OAJSz0r
         IW6ZCvXswgP+dP1kDIM+i9XwtJGuMTkEunWuKWbdfXnJotNLr6VV5Fh4PShSwFHEM5MR
         Ufjg8viCsJjWhDhiAzbG1Q4G1t12Ka6ip4rvDbZ1vi5oN90ZFBwazeS6U2Gwm8XaS1ZC
         q//MiU7plGbw6KJU7qgetKFU38ThTltx3IdsBBqIQzVG1vfu1BKO4+C5KeMOoxZHt1X7
         oUDA==
X-Forwarded-Encrypted: i=1; AJvYcCWtokccrkXNkBPLX/w4ET8n8cMuZWiOX09rFj9haug9mJcBOsUjy3MNvSJO+JJvSkFKpBPuiar7Sw==@kvack.org
X-Gm-Message-State: AOJu0YwakQ7NXqbnlsOZRlo/jAtaX2/+d9HoDiDAfRYmHv1aNuSfIGfB
	QH73J4MphtCQ8JjhNPIFrjgDYSsJYrtBmk7yZvFo+7/UVnP3NVK8Xti8hFzG+hb5/nIh+oDn5Wz
	bKZ6PJGUKcPuBeFpO5zeaHnSLaYUalhA=
X-Gm-Gg: ASbGncv2oPk6q972qV7wK5lV+dB1KvPGWD5kxmATyO8O+aJ+8akDajyM2H4msgoQBCV
	fn41b0SWgvAHKXgoiS1eQ+uCrYhggD/w0CLDduLUhBsrtRJzl8NHcufo4cIBuP28tZkp9ROi6q4
	qwQpncYuBoY/xNRknhElh0B55lhk4l9CoSDfMKbAo+N4x2Pd0Zibhnqn0bYbswDCu0XHPS7Ph5A
	AkXGx0lHjlPCvyZHP8wJA==
X-Google-Smtp-Source: AGHT+IG33XVggnQTCWyt+uISmmOdR25xYnNt8+Yi6eqJTmHqOpfm4zbSvcmiDKC06vULGm1Y1ykX5yVSimFu6NJYlIY=
X-Received: by 2002:a05:600c:1552:b0:45f:2cb5:ecff with SMTP id
 5b1f17b1804b1-45f314c15d6mr62874075e9.31.1758048376981; Tue, 16 Sep 2025
 11:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz> <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz>
In-Reply-To: <0beac436-1905-4542-aebe-92074aaea54f@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 16 Sep 2025 11:46:03 -0700
X-Gm-Features: AS18NWCSLewPB96ssRVHAm1hP_pc692yCwKaHpAAYlQc7dk2NoKof6uxKdPFMiU
Message-ID: <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: B99C81C000C
X-Stat-Signature: p56hnneryrd8w3gt4um5jnks9qx5riio
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758048378-91509
X-HE-Meta: U2FsdGVkX1/8l8TAnWgGH2Cxe7jX/yn9nCEhKYhk2O5ev8PRCu9SfCsqFqzEnnRT0xqzRb/qAcGpWeq9hICLc/P/h7xKJcLhSJTGMNY0PF0kYNEujMBueWEdh8wD03PNOJsq5yVvC2X4ScVttbLrUbCP6I4W5L9Tv6+jpXmQfBdxccNqg0yOwdpd8b8icwcTw4cDjJDrrJUC0z4v7R2yO1b5jblYIj2sp2u/Os/RKv7UCMGq7V5rxJ2q9A2LKU8/Mr5YZHb7LXKrh6MbqZkzqeVVRB6hBjSTrL++v0cCbFfYjzQGNpL09lAKC/2WAvxWwMyoZ/c0Ojv6EyCpU3oI2C3ZmfFhux02Pup3o+Q3h4UcxJYlJH0nBWWTH4NvOjBLFNMzrfAXSdZAwgTZxH2S43WjFRvEsSGQk6O6Dwh1KhoFQP8zs7GcBQiSpTpbXkopwLMMGLWATm+i9YzoI0cW9u2LLif8clZlFzpA/oAhdKPa9621GG/HVa5+6gpI9BlMrnbbSNFaMpnTLZi/OEUeppDm2JfW4ccz5/p/e49q2xvN1s5TjDo05v73lxcoLnURQyLegS8TMuMPSOAVU0WJSrUGuQiPNps2/M05MtpHJVT+YYDo+TQMAJS44vE4FXPUvkKMVHDVHQnQ574AxdVAsbYe/uNlmA+Td1GlZFaylx+zQGMKVxxlOBUP0L2wSeFfkVEJkbIiMd7PS1/eXBZfXN1BiI+JMPUsdU+gZePNGU8dZennUdzaTyl+vnKN0sIjh/M2s5jICrz9daSjMGJNNsqrDdDNtzkIER5IhkPvFbjpqWL/Qv9RmXk+FLLIOi1mCYRkr+FrZVZNvd3YaIUT2BasnJ8kl0QRXW+upH3xFM0zBzWS2sGA+vBoRqWzjvehopEC3Dxr/8bA5+rZbaUe9obo3PUWhs60DofdK/SiX5fc+rCEDs92vhLhJRVW89t4CHb/4nDgufmPJIXsqup
 tgxr82b/
 nWsyKuzqx5HphaSGJlZNkCGJMWjVp1rFWqYfh7np35hRzfcZmuRyYUE8x71c1j0n75Y7/anedD6VkYTkYt2HLWPk1EhUR9eMWl6JpIi7WfDPu2Jt8L4WNFcyHaUx4gZf/4Xm2In9VJIZMv54spSwgUxMutAapksSyuHjC1v42lk6XghicDcCy/OcDXrudU3H+9080Yx9ROybyN5yBWNUXuylQbkR9ySPXocLW7dItrv4AqsP6xHuvE5MWpepU0S8HrucRp+U82XKwO9ELONBxckO3hJbMFVfGaArc4gymOEGkAcFVoxO/lRjk/xt+DmEv9J06grU9QMveRb/SnHDJMLPRmBcDr2GdBThObBBa2ewd8Gebe57woebO0mORujcweIqDqNWwNwQ5gxFmjuNZ4kk5Kkn1GanlSlIBOGvgF/2ouyKnPmrFrfTPv+7prh1Nvo6N8ZFalHEM8Vg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:12=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 9/16/25 18:18, Alexei Starovoitov wrote:
> > On Tue, Sep 16, 2025 at 6:13=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> On 9/16/25 14:58, Harry Yoo wrote:
> >> > On Tue, Sep 16, 2025 at 12:40:12PM +0200, Vlastimil Babka wrote:
> >> >> On 9/16/25 04:21, Alexei Starovoitov wrote:
> >> >> > From: Alexei Starovoitov <ast@kernel.org>
> >> >> >
> >> >> > Disallow kprobes in ___slab_alloc() to prevent reentrance:
> >> >> > kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> >> >> > kprobe -> bpf -> kmalloc_nolock().
> >> >> >
> >> >> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> >>
> >> >> I wanted to fold this in "slab: Introduce kmalloc_nolock() and kfre=
e_nolock()."
> >> >> and update comments to explain the NOKPROBE_SYMBOL(___slab_alloc);
> >> >>
> >> >> But now I'm not sure if we still need to invent the lockdep classes=
 for PREEMPT_RT anymore:
> >> >>
> >> >> > /*
> >> >> >  * ___slab_alloc()'s caller is supposed to check if kmem_cache::k=
mem_cache_cpu::lock
> >> >> >  * can be acquired without a deadlock before invoking the functio=
n.
> >> >> >  *
> >> >> >  * Without LOCKDEP we trust the code to be correct. kmalloc_noloc=
k() is
> >> >> >  * using local_lock_is_locked() properly before calling local_loc=
k_cpu_slab(),
> >> >> >  * and kmalloc() is not used in an unsupported context.
> >> >> >  *
> >> >> >  * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local=
_lock_irqsave().
> >> >> >  * On !PREEMPT_RT we use trylock to avoid false positives in NMI,=
 but
> >> >> >  * lockdep_assert() will catch a bug in case:
> >> >> >  * #1
> >> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmall=
oc_nolock()
> >> >> >  * or
> >> >> >  * #2
> >> >> >  * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -=
> bpf -> kmalloc_nolock()
> >> >>
> >> >> AFAICS see we now eliminated this possibility.
> >> >
> >> > Right.
> >> >
> >> >> >  * On PREEMPT_RT an invocation is not possible from IRQ-off or pr=
eempt
> >> >> >  * disabled context. The lock will always be acquired and if need=
ed it
> >> >> >  * block and sleep until the lock is available.
> >> >> >  * #1 is possible in !PREEMPT_RT only.
> >> >>
> >> >> Yes because this in kmalloc_nolock_noprof()
> >> >>
> >> >>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardir=
q()))
> >> >>                 /* kmalloc_nolock() in PREEMPT_RT is not supported =
from irq */
> >> >>                 return NULL;
> >> >>
> >> >>
> >> >> >  * #2 is possible in both with a twist that irqsave is replaced w=
ith rt_spinlock:
> >> >> >  * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
> >> >> >  *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_loc=
k(kmem_cache_B)
> >> >> And this is no longer possible, so can we just remove these comment=
s and drop
> >> >> "slab: Make slub local_(try)lock more precise for LOCKDEP" now?
> >> >
> >> > Makes sense and sounds good to me.
> >> >
> >> > Also in the commit mesage should be adjusted too:
> >> >> kmalloc_nolock() can be called from any context and can re-enter
> >> >> into ___slab_alloc():
> >> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> NMI -> bpf ->
> >> >>     kmalloc_nolock() -> ___slab_alloc(cache_B)
> >> >> or
> >> >>  kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> tracepoint/kprob=
e -> bpf ->
> >> >>    kmalloc_nolock() -> ___slab_alloc(cache_B)
> >> >
> >> > The lattter path is not possible anymore,
> >> >
> >> >> Similarly, in PREEMPT_RT local_lock_is_locked() returns true when p=
er-cpu
> >> >> rt_spin_lock is locked by current _task_. In this case re-entrance =
into
> >> >> the same kmalloc bucket is unsafe, and kmalloc_nolock() tries a dif=
ferent
> >> >> bucket that is most likely is not locked by the current task.
> >> >> Though it may be locked by a different task it's safe to rt_spin_lo=
ck() and
> >> >> sleep on it.
> >> >
> >> > and this paragraph is no longer valid either?
> >>
> >> Thanks for confirming! Let's see if Alexei agrees or we both missed
> >> something.
> >
> > Not quite.
> > This patch prevents
> > kmalloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> >     kprobe -> bpf
> >
> > to make sure kprobe cannot be inserted in the _middle_ of
> > freelist operations.
> > kprobe/tracepoint outside of freelist is not a concern,
> > and
> > malloc() -> ___slab_alloc() -> local_lock_irqsave() ->
> >    tracepoint -> bpf
> >
> > is still possible. Especially on RT.
>
> Hm I see. I wrongly reasoned as if NOKPROBE_SYMBOL(___slab_alloc) covers =
the
> whole scope of ___slab_alloc() but that's not the case. Thanks for cleari=
n
> that up.

hmm. NOKPROBE_SYMBOL(___slab_alloc) covers the whole function.
It disallows kprobes anywhere within the body,
but it doesn't make it 'notrace', so tracing the first nop5
is still ok.

> > I thought about whether do_slab_free() should be marked as NOKPROBE,
> > but that's not necessary. There is freelist manipulation
> > there under local_lock_cpu_slab(), but it's RT only,
> > and there is no fast path there.
>
> There's __update_cpu_freelist_fast() called from do_slab_free() for !RT?

yes.
do_slab_free() -> USE_LOCKLESS_FAST_PATH -> __update_cpu_freelist_fast.

> >>
> >> >> >  * local_lock_is_locked() prevents the case kmem_cache_A =3D=3D k=
mem_cache_B
> >> >> >  */
> >> >>
> >> >> However, what about the freeing path?
> >> >> Shouldn't we do the same with __slab_free() to prevent fast path me=
ssing up
> >> >> an interrupted slow path?
> >> >
> >> > Hmm right, but we have:
> >> >
> >> > (in_nmi() || !USE_LOCKLESS_FAST_PATH()) && local_lock_is_locked()
> >>
> >> Yes, but like in the alloc case, this doesn't trigger in the
> >> !in_nmi() && !PREEMPT_RT case, i.e. a kprobe handler on !PREEMPT_RT, r=
ight?
> >>
> >> But now I think I see another solution here. Since we're already under
> >> "if (!allow_spin)" we could stick a very ugly goto there to skip the
> >> fastpath if we don't defer_free()?
> >> (apparently declaration under a goto label is a C23 extension)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 6e858a6e397c..212c0e3e5007 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -6450,6 +6450,7 @@ static __always_inline void do_slab_free(struct =
kmem_cache *s,
> >>  {
> >>         /* cnt =3D=3D 0 signals that it's called from kfree_nolock() *=
/
> >>         bool allow_spin =3D cnt;
> >> +       __maybe_unused unsigned long flags;
> >>         struct kmem_cache_cpu *c;
> >>         unsigned long tid;
> >>         void **freelist;
> >> @@ -6489,6 +6490,9 @@ static __always_inline void do_slab_free(struct =
kmem_cache *s,
> >>                         return;
> >>                 }
> >>                 cnt =3D 1; /* restore cnt. kfree_nolock() frees one ob=
ject at a time */
> >> +
> >> +               /* prevent a fastpath interrupting a slowpath */
> >> +               goto no_lockless;
> >
> > I'm missing why this is needed.
> >
> > do_slab_free() does:
> >                 if ((in_nmi() || !USE_LOCKLESS_FAST_PATH()) &&
> >                     local_lock_is_locked(&s->cpu_slab->lock)) {
> >                         defer_free(s, head); return;
> >
> > It's the same check as in kmalloc_nolock() to avoid invalid:
> > freelist ops -> nmi -> bpf -> __update_cpu_freelist_fast.
> >
> > The big comment in kmalloc_nolock() applies here too.
>
> But with nmi that's variant of #1 of that comment.
>
> Like for ___slab_alloc() we need to prevent #2 with no nmi?
> example on !RT:
>
> kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf ->
> kfree_nolock() -> do_slab_free()
>
> in_nmi() || !USE_LOCKLESS_FAST_PATH()
> false || false, we proceed, no checking of local_lock_is_locked()
>
> if (USE_LOCKLESS_FAST_PATH()) { - true (!RT)
> -> __update_cpu_freelist_fast()
>
> Am I missing something?

It's ok to call __update_cpu_freelist_fast(). It won't break anything.
Because only nmi can make this cpu to be in the middle of freelist update.

