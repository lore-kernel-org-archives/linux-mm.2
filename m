Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44186C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64676B017D; Wed, 23 Jul 2025 14:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14CE6B017E; Wed, 23 Jul 2025 14:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3646B017F; Wed, 23 Jul 2025 14:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 794936B017D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:31:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BECD1D8C6D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:31:12 +0000 (UTC)
X-FDA: 83696371584.22.38C4EBC
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 022071C000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:31:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aR4uFDFR;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753295470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxdQ/2scAxyhDcmRUHh4GMEXZ+h/aTnjT/f58sFEb/0=;
	b=PuSri0CGXpzH+AmkKfPHuYqnAetmIow8iEKmhBAoWwgLwrYt1cQ7mhHjNtd0HZzOUd/RMZ
	mNL6xYSsiyYtDbDvKbSLA3gSpkBvxz0Z+jwBrLrEDqSWeq6PI6Tf7frEATSD6Sl69pwnaz
	6b1bJUlJ2oixjsUiY1fMLhZOGXk6xUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753295470; a=rsa-sha256;
	cv=none;
	b=T0dcS29WGsKJEBkZudtujSQAoTEYOMcf5F/rTG2mJAPhe4Lmm9BmGV8buybu/UxptzZIRx
	EubK4e2kjusa6AdIzsJ+e5cOtXyF88sLJtjY5se/OUTSMwMRzCn06nVC8nzRYlEIrYp/ST
	AgaPNKx5Z/0PSfgJBzzkmFm9Tbt1qkI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aR4uFDFR;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso1941a12.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753295468; x=1753900268; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxdQ/2scAxyhDcmRUHh4GMEXZ+h/aTnjT/f58sFEb/0=;
        b=aR4uFDFR69QK9oM3DSMF1chpQGOMjb4ld3t7Qve+oIhaeTWtw3CKCOQZVunf9ZCaeb
         1isADiSkTpJpSO7cy0Bf+e8MqA60u5qDEcae9SWVwYtfNn107H60ZrGZjcPR7ZHTl2K5
         J+A5dxdxcSqD56P2bYElvZZoDz7PbNnMVYf+CNY5U8SI9OEaUrosADksAMGPLo+jGb4C
         OCfphPI+ILR5EKkNUCV6s0Ln82luUcvJfCxMidfOOBWMSWYr+v7F2RCpetAYKFN2E9pw
         J5bGW1nhdHvHm9qdQYvIyDAGIdw7ITwHbweDhFHKSMP15e7XV+1akJfaJ7qPjGGNgAUh
         tQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753295468; x=1753900268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxdQ/2scAxyhDcmRUHh4GMEXZ+h/aTnjT/f58sFEb/0=;
        b=A+6XvzuC/4F9n+WUYUB8azfheR07iFmat/hTxzismYdwtAtsD+Ra6ePuh2gwf0mgto
         KO7XDU0xppVJNqi0eVUuYMQ0GL9x0OJfb+7+bgphwzthK7fh2aHH2Ec0y6uKd7Kij4Y/
         Z/HXzMgFPEibSUeQaPvNz4h3bnbd5IZ++cyFkt3SvPQ6DezIMy08HtrxgsM05zCLWYOo
         EF1neSFzihsJfvmCNeJgOHLIPLvtfx87qC7yZlxeGFPLilmO9S9fpE/SPhZjNVU+jVSS
         1RqfF9pO/v+HG94WCwm3Y3rFpAcZEoLoOXN8CtRRBA3NI7QlP0rcQOB0n5YggclIbqwA
         fNmg==
X-Forwarded-Encrypted: i=1; AJvYcCXs5xXNrZTlebMT5QAVHta5Lv5WUyY473rX1irsx1ESUo0BrIw4wCw+ueuY4v8TiUc5Sc2xuZSNow==@kvack.org
X-Gm-Message-State: AOJu0Yx3ETRUdSgmMRboyEyAocbkZxz8/6Dv4d8uPZrefxteSTvGNTEp
	5dBwvTBK2EEDHDAMA1u1pqpkGvEa+4+/Ytvsb5iMDOkdFEx2m57KXpHrteLdcmno+wEt8BztREz
	qH7+kCbzNZ6UXsGRn/hywaISoS+kUM59aaSriidzf
X-Gm-Gg: ASbGncuxOmk319uRAOh04M0uMzTieVmMohdCZTokZ0mXo6TWVRJPgHKXkOMWswknxuG
	+5eX/fZghQSfFNGVR9ull4NvBHXAYaSMCfKFRwFSjQ7/53p+09jU1fDQIwJYKqZW/c0lVps5MMu
	+clg/34/HUducYWOall8E9Z9nRv4UwmrhPnsG6tpBGw8WBwIPtgW3jfzyQsFzqEYvi4ewPlxuPc
	2EXz41+fWj044om/NLHfaQzuJ8c2XFoyBg=
X-Google-Smtp-Source: AGHT+IFrP5YlrTclJr4hnQq4xu1KXB4Tzina61Zi3tUWZhFyV8bZGBSC09/EiVrv02o5c3QT1Qvs43q/HqOY+cnRl9M=
X-Received: by 2002:a05:6402:1c94:b0:60e:2e88:13b4 with SMTP id
 4fb4d7f45d1cf-614c50ca843mr2659a12.3.1753295467875; Wed, 23 Jul 2025 11:31:07
 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local>
In-Reply-To: <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 20:30:30 +0200
X-Gm-Features: Ac12FXxNoJl69yJqOiOLuD0JUEmbVCZC18OJvmewyPdVImEJfUHr0S8XmycP6Gw
Message-ID: <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, 
	Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 022071C000D
X-Stat-Signature: qosts7qj1k5djxtczkusojhz5czuy437
X-Rspam-User: 
X-HE-Tag: 1753295469-292876
X-HE-Meta: U2FsdGVkX1890i3IQh9+F28NQhdjA8CybSzbudOJrHBPaOUP5RioTyJOYFbv4gU8E2Oh20Uh4wjPoh6R+wV0DjwElKG57+SHQ4Ek6qeecvYYPEgY3En7LwizGucW7C6nnAoB1QynnjlOMfzGv1BDNFZ5cQN4bRcjseqEv6WFXpU9QF3BQp6k5DFZRCBPbmDVFKq9cvOqd+Kc9fIkpc1oZStjDqSRRhkwreGKoeDE5o7IFt3gPjGcvEViLFwfeRcQy7Ikhxz8aPVdYl63vCrw4SbKew+PUERC2OFRZS2l177BOewsR37pMesor0O1l+y93I5gRJBtfzA6zgaPO0w8c0vloidckAg5ml6oYY6xkVtx+KH7WnWT1hnolbo8q58k3nkZtCYDZReH+sF9WgLuezHiOBZNC88m8trxQBd1bbpveV8WDbxmTKYVzEEgzAGYSpdIYZaq8nOVy8TR4qcQVPN+TdX6rKDQ+uxNE6CPGVM6+9lqwwCarMFns2ZZR+NW6NJIjPW3oD+SHBvqUi4wOV/kbsWjy5xJyz4qtSrWniu3+rmuov3XB7aEu6Dki2JKovM9TlNSCp+dUp7IgCL6CyLTrlaubXWM9Ujy6jsCXxMrCeuYCJ2UrOJJMJ/+Qd/po8Q1JP7A/7nqrfJFSIdM9QLieEnEacIY15J39UkVENGbm5BAEr/UR9Mdsv1vglcywQaBJEQuVMgJxYeHsIZUoOnx2xZhN3//E9u6sd3cBM0nluY+BDVbgduL/aIx2RWY1lhHl6DVDAzy5CE0c20ivB0Yzh5+lZIBNegwl1LzAkX33Y9jzkR0hguRa39knSUfCF2ZzYswrqXyNx3BGbM4V0dZ8fypiux2AoEf6Vuw+HGIsqyKTJCt7V5yVGwI73IQXbkDAGZ2aUoqKU0SzWeLXYz9fQx4Us9w7XethitpPgCUbxsRinJDYtcnmZ1swMocFP/rsp4RtWPUZt4rWSS
 2uUIVT78
 HsCJcW/NnLCn9Qp8kFzc1vPGiufvgsEyn7vFhCTMa0bhtjPH1EiEFeU7buRt0rYB8xG5mbcnMmpkOfp8qaQyLM2cHDRA+LuYvIVOmnOEluAYYMWMbUgyMUCnp19S36e1YWkagOUXe4q4ZpDz81LFHeln0rG4IaJihPW3Bw6AGXDReF1tU2tJfqd0zrGAOLQi7RaG5oLTqJD72ETn7yA/mu7cIqk3fkl9BIk6jOduxoPqrWZdhKy7/OgLopgZtCQgBmL8UQaf+fgdqLGk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 8:14=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> > There's a racy UAF in `vma_refcount_put()` when called on the
> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > without sufficient protection against concurrent object reuse:
> >
> > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> > rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> > it can be recycled by another process. vma_start_read() then
> > increments the vma->vm_refcnt (if it is in an acceptable range), and
> > if this succeeds, vma_start_read() can return a reycled VMA. (As a
> > sidenote, this goes against what the surrounding comments above
> > vma_start_read() and in lock_vma_under_rcu() say - it would probably
> > be cleaner to perform the vma->vm_mm check inside vma_start_read().)
> >
> > In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> > will then detect the mismatching ->vm_mm pointer and drop the VMA
> > through vma_end_read(), which calls vma_refcount_put().
>
> So in _correctly_ identifying the recycling, we then hit a problem. Fun!
>
> > vma_refcount_put() does this:
> >
> > ```
> > static inline void vma_refcount_put(struct vm_area_struct *vma)
> > {
> >         /* Use a copy of vm_mm in case vma is freed after we drop vm_re=
fcnt */
> >         struct mm_struct *mm =3D vma->vm_mm;
>
> Are we at a point where we _should_ be looking at a VMA with vma->vm_mm =
=3D=3D
> current->mm here?

Well, you _hope_ to be looking at a VMA with vma->vm_mm=3D=3Dcurrent->mm,
but if you lose a race it is intentional that you can end up with
another MM's VMA here.

> Or can we not safely assume this?

No.

> Because if we can, can we not check for that here?
>
> Do we need to keep the old mm around to wake up waiters if we're happily
> freeing it anyway?

Well, we don't know if the MM has already been freed, or if it is
still alive and well and has writers who are stuck waiting for our
wakeup.

> If not, then surely we can just do this check, and not do the wake up if
> false?
>
> I may be mising something or being stupid here so :P
>
> >         int oldcnt;
> >
> >         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> >         if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
> >
> >                 if (is_vma_writer_only(oldcnt - 1))
> >                         rcuwait_wake_up(&mm->vma_writer_wait);
> >         }
> > }
> > ```
> >
> > This is wrong: It implicitly assumes that the caller is keeping the
> > VMA's mm alive, but in this scenario the caller has no relation to the
> > VMA's mm, so the rcuwait_wake_up() can cause UAF.
>
> Oh yikes. Yikes yikes yikes.
>
> >
> > In theory, this could happen to any multithreaded process where thread
> > A is in the middle of pagefault handling while thread B is
> > manipulating adjacent VMAs such that VMA merging frees the VMA looked
> > up by thread A - but in practice, for UAF to actually happen, I think
> > you need to at least hit three race windows in a row that are each on
> > the order of a single memory access wide.
>
> Hmm ok this is confusing, below you reference threads by number with
> letter=3Dprocess, and here you say thread 'A' and "B'.

Ah, yeah, sorry.

> > The interleaving leading to UAF is the following, where threads A1 and
> > A2 are part of one process and thread B1 is part of another process:
>
> Err but you refer to A1, A2, A3 below, should A3=3DB1?

... clearly I should have proofread this more carefully. Yes, A3 should be =
B1.

>
> > ```
> > A1               A2               A3
> > =3D=3D               =3D=3D               =3D=3D
> > lock_vma_under_rcu
> >   mas_walk
> >                  <VMA modification removes the VMA>
> >                                   mmap
> >                                     <reallocate the VMA>
> >   vma_start_read
> >     READ_ONCE(vma->vm_lock_seq)
> >     __refcount_inc_not_zero_limited_acquire
> >                                   munmap
>                                    ^
>                                    |
>                                    OK so here, we have unmapped and
>                                    returned VMA to the slab so
>                                    SLAB_TYPESAFE_BY_RCU may now result in
>                                    you having a VMA with vma->vm_mm !=3D
>                                    current->mm right?

Yes. The VMA is unmapped and returned to the slab at the "<VMA
modification removes the VMA>" in A2 above, and then reallocated when
B1 does "mmap".

> >                                     __vma_enter_locked
> >                                       refcount_add_not_zero
> >   vma_end_read
> >     vma_refcount_put
>       ^
>       |
>       Then here, we're grabbing process
>       B's mm... whoops...

Yeah.

> >       __refcount_dec_and_test
> >                                       rcuwait_wait_event
> >                                     <finish operation>
>                                       ^
>                                       |
>                                       Then here, the VMA is finally
>                                       freed right?

Yeah.

> >       rcuwait_wake_up [UAF]
>         ^
>         |
>         And then here we try to deref freed mm->vma_writer_wait
>         and boom.

Yeah.

> > I'm not sure what the right fix is; I guess one approach would be to
> > have a special version of vma_refcount_put() for cases where the VMA
> > has been recycled by another MM that grabs an extra reference to the
> > MM? But then dropping a reference to the MM afterwards might be a bit
> > annoying and might require something like mmdrop_async()...
>
> This seems a bit convoluted... And I worry about us getting the refcount
> stuff wrong somehow, we'd have to be very careful about this to avoid
> leaking VMAs somehow...

FWIW, the slow and boring solution would be to use wake_up_var() and
wait_var_event(), but those might be too slow for this usecase.

