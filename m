Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC31FCAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172098E000E; Mon, 15 Sep 2025 20:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A3B8E0001; Mon, 15 Sep 2025 20:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F148E000E; Mon, 15 Sep 2025 20:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5B758E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:56:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73CA05B60C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:56:34 +0000 (UTC)
X-FDA: 83893297908.06.E26BAC3
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 728A84000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:56:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ekjmTLW8;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757984192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiLgYf6D3jEC57AgzquBhXF5i1lApomfHdREXpHN454=;
	b=F2wgzYik4L9C/f0QF/tmI7CBEyPf00NMcqlBdJmYD1q43IEbpzHN5BaufplshKiFtlHE04
	0A48doPevNEY5w7j6hkA7HhZfn+xunrAtXGhN6A0yVZvHaIjWAovvn+O5sfJBHDDANiHzA
	EFdQCB2GGODK+K1l4yDAPQ7Ni6Q50mc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ekjmTLW8;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757984192; a=rsa-sha256;
	cv=none;
	b=JO+ooEbhL2Vxgk2Pf9zjKpbrAA1DNYrYQx2Wll2nfD1Gqdo0wiTLpUdrQjmQW/j4plrylv
	am3BTe1quCWlFpkuioUSURh429zn5KB28u37LrjPvaHtrwb+lo4VNjzNws7gxlNMCTLWlm
	yFS+MXa4h7I8UfxjiRWPpZIByUrIkbA=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3eb3f05c35bso1099311f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757984191; x=1758588991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiLgYf6D3jEC57AgzquBhXF5i1lApomfHdREXpHN454=;
        b=ekjmTLW89pG+yOhYgV2c/XaWEjldV9tHcPO8Oba048bzy4OziOYVw1JFS7kz80P6zy
         LU/69QAXwZM6SLssZJxO5nf0HbMycFUswapHsGWC/dDebg7eJFrls4rx3tYpbL32Lj1f
         1t9IcbP7gStSjrt7j6CrZKx2iGmBdjI+SoWMrIdWyoctZgTffKYSObVM7Wzb4PD36uUy
         WTe1S2iMVtceqC+7h+6zeprGYd5ddeMERNXgzWbYTQG6RE5eLn9Z2J9xxceNj1RRe2MK
         uHIXwow5irR/V8EWP0ZlMnw/7ooyJsz++u84kaARecG5DHtz/5ieto2iclMuMVpKn92M
         zXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757984191; x=1758588991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WiLgYf6D3jEC57AgzquBhXF5i1lApomfHdREXpHN454=;
        b=jmr0ib9RoleQWa94EOQn0iiFLR6kI/VAKRBDLP23L7yLktJr2KTOm2ajxbF8JUP0W/
         loRaeF9fenmQaGg64dL2vvBS6VtTLtfQq1b0Mr1GGwSveShmz2orzqu//ctv11crjxVt
         7ZQvEZkbBnHt184AcERKUw+U4lV1e9Zxiw2YMRSCHlbVGyPRa9duwMez6siWE2ejV4IC
         kWrZwIukfiz0gKZIhkZ3HttpkgwEL353/mAS4biPoksU89iqrbOpnnksLFxt5b3nytZD
         yvJnNL7b9IS3uXG9ae/0xjPvEM6s70zb+Lkdm3Z4HLVUc57reL9zTCO7THEBfdEuVZP5
         2akQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbvCb9SsNWNhOpTpGWOGVlm7qW5J2nIS/TFsnLuRsozg2YNwQSEhMk03XIYWrPre6tb9iaSyL1FA==@kvack.org
X-Gm-Message-State: AOJu0YwzZwY9nXqhAe+Y0WCYk2i6FglXH6jSdpyEgsDyd11I1D2Lw49m
	rmWWMNgkOoe+40454S89DFezE6Y3T5koclZ1TRhyRe53WNoMZivROvscYea++t3RRDH3Qcu6g6+
	42DN8DQNH3zWM6+eUhEQX/MwlMifvDhg=
X-Gm-Gg: ASbGnct+hNZY2p8C31NOtAQ7pJP7xgq7gHOd0q6wwI4N3z4/hhWQnCtIXBaT5H1bZXA
	JopaTy7W/in0TZm6Ij+LJhnHTsY1tRBemlQjm6pu6PaGa9caDe+Wg3DYpUtUVWQoPJExOLmdMw7
	aJUkhWYKkQxNSLKVN9KVTgAFUWJ3aqREb/iDP9RijsMK2zht7dF9ylq9eONXbx5CQ3fYDe94Pes
	Op5db+qaNk4GPu7kNWGlYW8rPDv3v7As9UY
X-Google-Smtp-Source: AGHT+IGFlGJIoK5ZUsaOwb586HCPIbfPVyUQh1WbZv2OmQrk5XYYtC5YYb0VRb1ejdHUEPi98odbmMRH1yhd4sqIA7o=
X-Received: by 2002:a5d:5d0a:0:b0:3e5:50:e070 with SMTP id ffacd0b85a97d-3e765a19cbbmr11529191f8f.50.1757984190560;
 Mon, 15 Sep 2025 17:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-7-alexei.starovoitov@gmail.com> <aMgMIQVYnAq2weuE@hyeyoo>
 <451c6823-40fa-4ef1-91d7-effb1ca43c90@suse.cz>
In-Reply-To: <451c6823-40fa-4ef1-91d7-effb1ca43c90@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 15 Sep 2025 17:56:18 -0700
X-Gm-Features: AS18NWDoijexVV3I4ZuOqf6kTb_heztvckNsKdsfc8goyLACjGgfAmPHGSP44to
Message-ID: <CAADnVQKC=BA73ifNnyiE2c8ExtzS4LjR00--m5Xe8pqPLSGJfA@mail.gmail.com>
Subject: Re: [PATCH slab v5 6/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cpeipxor1wymg4ky7sr8wiow6hi97116
X-Rspam-User: 
X-Rspamd-Queue-Id: 728A84000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1757984192-934528
X-HE-Meta: U2FsdGVkX18f3ITD8MCD6B0HJDDF2nol0uGbZtxSG+IK/Iqn3DgvFV046CmLGAL8QBAjYm6QJvCLTaRoL256v9jert9il6+BWFpQQPyM2IyIWyfmQd8koe16SYYOPIzNK4RZiT5UeNVERys5P3pAV7ZVp+NmX7otp/AXV3f6Atpoe8nkVAF2JqPU3JUR6TqxC0WxN5wO1geTBQzQ5DA1YssLGZqMfB6a99Xdf7OCLnd/y+/R0/6ecRHBYMP88sFI9Dc8fnaJY+sAwK5P0h6wri6hYbkQrybjm3upxj3lnuurygT8xu8a9uyrIdaGiOKL3TqH4hJMw9in9XsALaocTTFvTYBjbiGYwjZD24E8j4pxZ2ECZnaiYbk7bADf+KwImmDoJny3dtSvsoMJP+JfvHflRE5LXABLlw4lD90aPR0gctIP4ctX5ji0ggVZ/hLBe8CIf5jDP+R9AhvcPhi+IT5WoNe6Byv5IY3wOC4wlnMX4agY+ildJNBGvg3wngZ/nGY6o/EZTG0jF+vlpkt4qMH7mk3ZXCnp1Z7DtLSqfDqC5grZj+KDrgBrKeuy//ScTOmcB/5zqN0BzSrk3XvyIdGmB03Dtp46szNI7/6/SS3rG2hcsR5YW3/wI0ebvP8xgaXPiaksQy6WwjD8F0Esy4Q7ENlnHsCHfzxTd66adeHFCaFj7+0cZp4oyeF6Ylt6dBoW+yISn1fBfLAn1Y2iQGfH9ay4B/O5vAI08tAZue2UZ63GiPRoHmgIDwvtSNt5QlM20fmYz8xguPi6X4M35uyZUWvZ+6zZ7JAH6jQz15umt/uRV92wnWRZxpjjtGcX2yjFIxkxGrVVDa0UBNmLg7wlAUJvrniiN+Ru0m/ZtSk4A/Ijcy+N5iblMggfYMo9FlPRX2HlfeWXaokz2O8KE8+f88lp1zkQGcRKCqnpSbtyDGS5EmqzNO7xkQMQc8PxfMOOe4i/tg++YgDoQiL
 qLlvbs+t
 gNLuZf4pM3s8F11VtnF/wJaC+/RZXloHkGPkiIFMpGcZ5clLsQ7vqtUcQCNndwPwJWrv6H9VVPSwoMAENi5yvsUuETXjD628PA455/SDxbH3AphUS8mxNnIMn/mLdJ3vG9TbcWa9sRRXiaGxObRTCMEj98YC0qpoXjXQjo3I+yFfsQZa9ljog1nIr9lub+CSungDfGJd0pzHrfGWVQxJI/NoSzpVJr2C/etjWe9xWLA66DCa2tEWPRCATl2wiTJnVPcQnpo7BfNyrWmhSNR+KDhZwO7C+H3AkbbSZ7+VhjV6JNrW5heFg6sNGrg0CVDbvO+mRUW9MvX/1e7hmSpwAXQNP6m8Ial9zydNSZoEGMXtD2/1isB3uKX0qbpLlt20G2FPko/lYEfZfnPt0VSQMwkGmy4g6Z2V+5cA6aJCe8DeVnX1MbrObfyf+QrYk9SHktNRrHaW+WuQIlFU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 7:39=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/15/25 14:52, Harry Yoo wrote:
> > On Mon, Sep 08, 2025 at 06:00:07PM -0700, Alexei Starovoitov wrote:
> >> From: Alexei Starovoitov <ast@kernel.org>
> >>
> >> kmalloc_nolock() relies on ability of local_trylock_t to detect
> >> the situation when per-cpu kmem_cache is locked.
> >>
> >> In !PREEMPT_RT local_(try)lock_irqsave(&s->cpu_slab->lock, flags)
> >> disables IRQs and marks s->cpu_slab->lock as acquired.
> >> local_lock_is_locked(&s->cpu_slab->lock) returns true when
> >> slab is in the middle of manipulating per-cpu cache
> >> of that specific kmem_cache.
> >>
> >> kmalloc_nolock() can be called from any context and can re-enter
> >> into ___slab_alloc():
> >>   kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> NMI -> bpf ->
> >>     kmalloc_nolock() -> ___slab_alloc(cache_B)
> >> or
> >>   kmalloc() -> ___slab_alloc(cache_A) -> irqsave -> tracepoint/kprobe =
-> bpf ->
> >>     kmalloc_nolock() -> ___slab_alloc(cache_B)
> >>
> >> Hence the caller of ___slab_alloc() checks if &s->cpu_slab->lock
> >> can be acquired without a deadlock before invoking the function.
> >> If that specific per-cpu kmem_cache is busy the kmalloc_nolock()
> >> retries in a different kmalloc bucket. The second attempt will
> >> likely succeed, since this cpu locked different kmem_cache.
> >>
> >> Similarly, in PREEMPT_RT local_lock_is_locked() returns true when
> >> per-cpu rt_spin_lock is locked by current _task_. In this case
> >> re-entrance into the same kmalloc bucket is unsafe, and
> >> kmalloc_nolock() tries a different bucket that is most likely is
> >> not locked by the current task. Though it may be locked by a
> >> different task it's safe to rt_spin_lock() and sleep on it.
> >>
> >> Similar to alloc_pages_nolock() the kmalloc_nolock() returns NULL
> >> immediately if called from hard irq or NMI in PREEMPT_RT.
> >>
> >> kfree_nolock() defers freeing to irq_work when local_lock_is_locked()
> >> and (in_nmi() or in PREEMPT_RT).
> >>
> >> SLUB_TINY config doesn't use local_lock_is_locked() and relies on
> >> spin_trylock_irqsave(&n->list_lock) to allocate,
> >> while kfree_nolock() always defers to irq_work.
> >>
> >> Note, kfree_nolock() must be called _only_ for objects allocated
> >> with kmalloc_nolock(). Debug checks (like kmemleak and kfence)
> >> were skipped on allocation, hence obj =3D kmalloc(); kfree_nolock(obj)=
;
> >> will miss kmemleak/kfence book keeping and will cause false positives.
> >> large_kmalloc is not supported by either kmalloc_nolock()
> >> or kfree_nolock().
> >>
> >> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >> ---
> >>  include/linux/kasan.h      |  13 +-
> >>  include/linux/memcontrol.h |   2 +
> >>  include/linux/slab.h       |   4 +
> >>  mm/Kconfig                 |   1 +
> >>  mm/kasan/common.c          |   5 +-
> >>  mm/slab.h                  |   6 +
> >>  mm/slab_common.c           |   3 +
> >>  mm/slub.c                  | 473 +++++++++++++++++++++++++++++++++---=
-
> >>  8 files changed, 453 insertions(+), 54 deletions(-)
> >> @@ -3704,6 +3746,44 @@ static void deactivate_slab(struct kmem_cache *=
s, struct slab *slab,
> >>      }
> >>  }
> >>
> >> +/*
> >> + * ___slab_alloc()'s caller is supposed to check if kmem_cache::kmem_=
cache_cpu::lock
> >> + * can be acquired without a deadlock before invoking the function.
> >> + *
> >> + * Without LOCKDEP we trust the code to be correct. kmalloc_nolock() =
is
> >> + * using local_lock_is_locked() properly before calling local_lock_cp=
u_slab(),
> >> + * and kmalloc() is not used in an unsupported context.
> >> + *
> >> + * With LOCKDEP, on PREEMPT_RT lockdep does its checking in local_loc=
k_irqsave().
> >> + * On !PREEMPT_RT we use trylock to avoid false positives in NMI, but
> >> + * lockdep_assert() will catch a bug in case:
> >> + * #1
> >> + * kmalloc() -> ___slab_alloc() -> irqsave -> NMI -> bpf -> kmalloc_n=
olock()
> >> + * or
> >> + * #2
> >> + * kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bp=
f -> kmalloc_nolock()
> >> + *
> >> + * On PREEMPT_RT an invocation is not possible from IRQ-off or preemp=
t
> >> + * disabled context. The lock will always be acquired and if needed i=
t
> >> + * block and sleep until the lock is available.
> >> + * #1 is possible in !PREEMPT_RT only.
> >> + * #2 is possible in both with a twist that irqsave is replaced with =
rt_spinlock:
> >> + * kmalloc() -> ___slab_alloc() -> rt_spin_lock(kmem_cache_A) ->
> >> + *    tracepoint/kprobe -> bpf -> kmalloc_nolock() -> rt_spin_lock(km=
em_cache_B)
> >> + *
> >> + * local_lock_is_locked() prevents the case kmem_cache_A =3D=3D kmem_=
cache_B
> >> + */
> >> +#if defined(CONFIG_PREEMPT_RT) || !defined(CONFIG_LOCKDEP)
> >> +#define local_lock_cpu_slab(s, flags)       \
> >> +    local_lock_irqsave(&(s)->cpu_slab->lock, flags)
> >> +#else
> >> +#define local_lock_cpu_slab(s, flags)       \
> >> +    lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab->lock, flags)=
)
> >> +#endif
> >> +
> >> +#define local_unlock_cpu_slab(s, flags)     \
> >> +    local_unlock_irqrestore(&(s)->cpu_slab->lock, flags)
> >
> > nit: Do we still need this trick with patch "slab: Make slub local_(try=
)lock
> > more precise for LOCKDEP"?
>
> I think we only make it more precise on PREEMPT_RT because on !PREEMPT_RT=
 we
> can avoid it using this trick. It's probably better for lockdep's overhea=
d
> to avoid the class-per-cache when we can.

yes.

> Perhaps we can even improve by having a special class only for kmalloc
> caches? With kmalloc_nolock we shouldn't ever recurse from one non-kmallo=
c
> cache to another non-kmalloc cache?

Probably correct.
The current algorithm of kmalloc_nolock() (pick a different bucket)
works only for kmalloc caches, so other caches won't see _nolock()
version any time soon...
but caches are mergeable, so other kmem_cache_create()-d cache
might get merged with kmalloc ? Still shouldn't be an issue.

I guess we can fine tune "bool finegrain_lockdep" in that patch
to make it false for non-kmalloc caches, but I don't know how to do it.
Some flag struct kmem_cache ? I can do a follow up.

> >>
> >> +/**
> >> + * kmalloc_nolock - Allocate an object of given size from any context=
.
> >> + * @size: size to allocate
> >> + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO allowed.
> >> + * @node: node number of the target node.
> >> + *
> >> + * Return: pointer to the new object or NULL in case of error.
> >> + * NULL does not mean EBUSY or EAGAIN. It means ENOMEM.
> >> + * There is no reason to call it again and expect !NULL.
> >> + */
> >> +void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
> >> +{
> >> +    gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> >> +    struct kmem_cache *s;
> >> +    bool can_retry =3D true;
> >> +    void *ret =3D ERR_PTR(-EBUSY);
> >> +
> >> +    VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO));
> >> +
> >> +    if (unlikely(!size))
> >> +            return ZERO_SIZE_PTR;
> >> +
> >> +    if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> >> +            /* kmalloc_nolock() in PREEMPT_RT is not supported from i=
rq */
> >> +            return NULL;
> >> +retry:
> >> +    if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> >> +            return NULL;
> >> +    s =3D kmalloc_slab(size, NULL, alloc_gfp, _RET_IP_);
> >> +
> >> +    if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
> >> +            /*
> >> +             * kmalloc_nolock() is not supported on architectures tha=
t
> >> +             * don't implement cmpxchg16b, but debug caches don't use
> >> +             * per-cpu slab and per-cpu partial slabs. They rely on
> >> +             * kmem_cache_node->list_lock, so kmalloc_nolock() can
> >> +             * attempt to allocate from debug caches by
> >> +             * spin_trylock_irqsave(&n->list_lock, ...)
> >> +             */
> >> +            return NULL;
> >> +
> >> +    /*
> >> +     * Do not call slab_alloc_node(), since trylock mode isn't
> >> +     * compatible with slab_pre_alloc_hook/should_failslab and
> >> +     * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
> >> +     * and slab_post_alloc_hook() directly.
> >> +     *
> >> +     * In !PREEMPT_RT ___slab_alloc() manipulates (freelist,tid) pair
> >> +     * in irq saved region. It assumes that the same cpu will not
> >> +     * __update_cpu_freelist_fast() into the same (freelist,tid) pair=
.
> >> +     * Therefore use in_nmi() to check whether particular bucket is i=
n
> >> +     * irq protected section.
> >> +     *
> >> +     * If in_nmi() && local_lock_is_locked(s->cpu_slab) then it means=
 that
> >> +     * this cpu was interrupted somewhere inside ___slab_alloc() afte=
r
> >> +     * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
> >> +     * In this case fast path with __update_cpu_freelist_fast() is no=
t safe.
> >> +     */
> >> +#ifndef CONFIG_SLUB_TINY
> >> +    if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
> >> +#endif
> >
> > On !PREEMPT_RT, how does the kernel know that it should not use
> > the lockless fastpath in kmalloc_nolock() in the following path:
> >
> > kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf -> =
kmalloc_nolock()
> >
> > For the same reason as in NMIs (as slowpath doesn't expect that).
>
> Hmm... seems a good point, unless I'm missing something.

Good point indeed.
tracepoints are not an issue, since there are no tracepoints
in the middle of freelist operations,
but kprobe in the middle of ___slab_alloc() is indeed problematic.

>
> > Maybe check if interrupts are disabled instead of in_nmi()?

but calling if (irqs_disabled()) isn't fast (list time I benchmarked it)
and unnecessarily restrictive.

I think it's better to add 'notrace' to ___slab_alloc
or I can denylist that function on bpf side to disallow attaching.

>
> Why not just check for local_lock_is_locked(&s->cpu_slab->lock) then and
> just remove the "!in_nmi() ||" part? There shouldn't be false positives?

That wouldn't be correct. Remember you asked why
access &s->cpu_slab->lock is stable? in_nmi() guarantees that
the task won't migrate.
Adding slub_put_cpu_ptr() wrap around local_lock_is_locked() _and_
subsequent call to __slab_alloc_node() will fix it,
but it's ugly.
Potentially can do
if (!allow_sping && local_lock_is_locked())
right before calling __update_cpu_freelist_fast()
but it's even uglier, since it will affect the fast path for everyone.

So I prefer to leave this bit as-is.
I'll add filtering of ___slab_alloc() on bpf side.
We already have a precedent: btf_id_deny set.
That would be one line patch that I can do in bpf tree.
Good to disallow poking into ___slab_alloc() anyway.

