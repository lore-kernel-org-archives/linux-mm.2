Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546A7C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B518E0091; Thu, 24 Jul 2025 10:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCDA8E007C; Thu, 24 Jul 2025 10:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12B28E0091; Thu, 24 Jul 2025 10:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF06A8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:51:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71FEB16036B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:51:29 +0000 (UTC)
X-FDA: 83699446698.20.434860F
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7955A180009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:51:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sn6MfGHJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368687; a=rsa-sha256;
	cv=none;
	b=Vx/pkV7ilNcPscRviPpuJfW7v8xrLXOdq3+j8ucTZ7KVTqJPO4L+TgRxtx5P7EUcJULxVj
	rbBf7mUtnPQO6URoP6CLSaJ2slfV3L17bnkUhaTCodEFS6km7tvRUt1rmrwLhyl4RqFGos
	J8NV6gyKlJaIUhiH70ZxVlMBDX4r9H4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sn6MfGHJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZBzBNB+u1GHY7Eewg0Wa8/2bvpUh1nZ72QzMOssxqc=;
	b=uW+xCfI1UKXOwT87h3uQ8ZtBIa0PXOta0N5xF8cPgu0DEZeJcpdIDwZFkc2Sd81FKg+IV9
	5wJK20ciODvUhI0oaPUhzSaHLXZ5zRtKJC7B3UCcVRZKB+82UMvLMvTdubC1/fz1El6Yoz
	ThHgDYCA/rPcOZ0Y8pV7vmimNQKjV7Q=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so10539a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753368686; x=1753973486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZBzBNB+u1GHY7Eewg0Wa8/2bvpUh1nZ72QzMOssxqc=;
        b=Sn6MfGHJssQgcmN0zzvJo/GIYPQl6jtkAyzU7CQj/SJiaentJo9euSMl1NQzVQhtC3
         mk3jhEER4pW3tCWKXPUu/sfZByxMFFjDv8t/yP0QNawp7T4t/3OgPDpQF/IpP0m4c7eg
         y0WPQyL4+Nj6GAZ1hJslDkPhaqEiXOzcm9ebjZZro/miS7DiTsXBceWn4mn5h3OIATkP
         ElVQVT09ojMUwlNLG5B3ztVfi2Uw14r9qgVt8WmWOv/nD/1Tfq31jEc0t8JOEuWG65uY
         Kliyb+ihDAk2GGfvlmeYoHvJI+bgPsQc+PrOVkpu0u5hDC3hJjceYnLEkTQpzKmIPI4b
         kXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753368686; x=1753973486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZBzBNB+u1GHY7Eewg0Wa8/2bvpUh1nZ72QzMOssxqc=;
        b=jg0p4tPLufScg5IpHJ78ZZr6N+rjE6T0yPUfPlevnQHpf6EorLV9XOjUKdNR3waVq/
         n5b82+enFtUQ+f56B9gLwYPKAj+Qw1qFDykvwJSTpP19Yxw3cnzT02cXKgcCnHZ72vFd
         Vd8s9o+Wq0DdNEj0aRPba6MtoOlxYeXDA/ik2iPQ+6houwryNoMUgTGQNcxVSwmMxXi8
         jnjplxW6KWG7QI8KkpJF7iPbqTpyqcuwSbwuzu/rwd/5XPHIaUwRYLqxdb6gFvFnVGAL
         LS53fVK24K1HHwNKSJiVq4fQTcPvnTCtj0PBeJxJ103mAQKHMuoEQYMtwNus/IPW5PhV
         W5ng==
X-Forwarded-Encrypted: i=1; AJvYcCX8LFT1nN8TDuNmBcI2reG2RPNu2BsDXXTd5uv170gAvbEL8a48HMCqrz8d/2z6Ti+SMBRyamV5qg==@kvack.org
X-Gm-Message-State: AOJu0YyN3DoBjm8Cja6x7JTxdNI21KBYEZM487qWscR+Lngu6j/oUj1q
	WChay+o0PTfFjfqjf+8RtMHy9+JNyLoK+1QoFsTekw5OKUwTddjw5/5/qyAKNT5OZpG3coJwt9X
	E9ffhbR7qvkJm8Hke3kb/kAfjeyea+TVHFBzK86eH
X-Gm-Gg: ASbGncsOON22/ZSFIM7LXrpdI6QFP/Gpj44KD8t7/kPfAla7GVtDzokiXNj7ruqDHXH
	J5tQStj56WCcOFnU1D5uvdp8NMMUFQ9W2WSLf9i01Cn6o3QP4czzbmEhfwBbP/71mhSMx4fKcj1
	2LU9txgKMntKcuX+anWPi/kmFXHvAybc8I1fmYWr2ItPKw5NwN9F5/Hqi7Qbdltq8dy4yJlyYzQ
	r/yhddzeov4hiPxizXRS+p6Q2xZiRco4g==
X-Google-Smtp-Source: AGHT+IEOrsDqVo5ci8aYn8jCdtj5CeXQAyO6/Tl1aEs7FqRIBfFdqhP4tUAk0s46m+L4Fi+pXaBVScYi4SEPT7gsT8s=
X-Received: by 2002:a50:c2c9:0:b0:613:5007:6448 with SMTP id
 4fb4d7f45d1cf-614cce2f1efmr81961a12.3.1753368685537; Thu, 24 Jul 2025
 07:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local> <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
 <3a233a85-3a94-422e-87be-591f93acbac7@lucifer.local> <CAG48ez36AcGBy8_wo09WEHz98Dp44yKZ_FiVtFt8tcV9WiHafA@mail.gmail.com>
 <b798c84e-f3fd-486d-ad70-c827385a558a@lucifer.local>
In-Reply-To: <b798c84e-f3fd-486d-ad70-c827385a558a@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Jul 2025 16:50:49 +0200
X-Gm-Features: Ac12FXyobmXk6Rg8bysoNNk35-q0E97inAQrfimfGZSKIsFeLOaEfZN3ZnDmKGw
Message-ID: <CAG48ez07dfabOERsOQoh8LWkcYTXo+svQk9X31afmWVGAVg9Tg@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, 
	Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7955A180009
X-Stat-Signature: 7561sfrmaba5txbkbypx8riamfhn3uqi
X-Rspam-User: 
X-HE-Tag: 1753368687-680297
X-HE-Meta: U2FsdGVkX1/xYCWub4nzK0jaValV5G/5Wyyor6MzJ48s/HaJJQQ3JNbJu02ewipva/cnLtGoWG7e2LO4Kc4JuCuP8B/eB+Bu/JzdWHITIiyCTtJ8DV6r7luqRcbcrtQ+jORGYbhwJwH02Xiw5mv664eUEjy4kY+LznwUKj/mmOkLEtbxoZqyBVfThhVH/O4FCLb8sAlLWIfesAmanGxjRdhJEeBDC6ce3uNxmQeAWXQzw+5CQafjYfbcwVK8786fnII46XxZcG4WXjT0ysyA0v5EH4wrbsIPQ0dO8RDtYC7LWeIK8GSeNkQbn10K79BnNP9SwDVpi+/PSbIy7Lt354NkU6vvbZv7wXsrSAL2wh80/S6IEIO9Se3DJydXy5rpJT0P8DpzYV70/NYIJ2MDcJLNpJY842g8XcEFbwmia1kfkyrNxDzlyehqW+hWNIHo15ROkb6Esn+huF0KmyrEn1jKbgL1WPb9b2EhKIZjW1+FVQDlU2xNjE7DtaAN3Yx0IRD75yX7a83VxosvkWqSMuk/rLeGVBgETYF/e0AP2D11z+ndNJQzvYwWPbiJI+3TnUZzJz8kfwaBPm37eqQ5+N8jN0Nm6HLOXS6UDuMUlWQOYUgO4wevvVjNGpDKuFUuJQoU761Uw0FZDezfLCTieoi9kZ710NW6jpQAWBB6c4I8Kwr7khFQ4IcZW75ETfleaVEj0pysEjRZ3H3NTy9hiGPQEqnSJCcp62HhQIFMALB/3JgamtutP9pfVQizihRp5UgqkEs9mv1LurBm7svSkxcP9RtlPOiZXN3ECGX3oshGXVdy8OA76qhwrU9GYn8cfzwgq8LXxJuPREtUxY61EjfOUuSbsey3pdOrBLH+fYm3n/R+KEYVrEPWbNYN+MpnrMjSjidOScmIuoPGvUCK6muxGjek6Pic6zX/AWg0d9g+EEiPh15cc9RGNaVcpY+ECVvSydga1mqcDJ2yjzQ
 kfJyGx6G
 hl6/D5V3WNHJX48i0T1LqokosAY83Nx/v8fRmMaPsMFNQoYZaRV1y8VxYdyf5OHLZKXvHrUTDfd5el/PEAbcKnrnl2WBn+Kz6WJqLFWjcxEVOOkROnFlZPSetGtFyL4BTY62dzGkKUHufUpxIx98BYVy6WN1g0Cz88y5xaTi7+Rhbd6XVqnuMp1y90cjWVx48Y1IOCiLSeYIibIw+xotbtojJUgQQWnrZooSN6/b8g1fsvKb72mTjO5At6CnDneA9BrurETPeG37iQhkxTxFhLsiXYPz43CczKDSGsvvPnCUiep/Hqk3p6crkPFp98bSSAbV87LYZaLX1hLy5+4T6ojV60g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 7:13=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jul 23, 2025 at 09:43:35PM +0200, Jann Horn wrote:
> > Sorry, while typing up this mail I realized I didn't have this stuff
> > particularly straight in my head myself when writing my previous mails
> > about this...
> >
> > On Wed, Jul 23, 2025 at 8:45=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Wed, Jul 23, 2025 at 08:30:30PM +0200, Jann Horn wrote:
> > > > On Wed, Jul 23, 2025 at 8:14=E2=80=AFPM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> > > > > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is u=
sed
> > > > > > without sufficient protection against concurrent object reuse:
> > > > > >
> > > > > > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() =
under
> > > > > > rcu_read_lock(). At that point, the VMA may be concurrently fre=
ed, and
> > > > > > it can be recycled by another process. vma_start_read() then
> > > > > > increments the vma->vm_refcnt (if it is in an acceptable range)=
, and
> > > > > > if this succeeds, vma_start_read() can return a reycled VMA. (A=
s a
> > > > > > sidenote, this goes against what the surrounding comments above
> > > > > > vma_start_read() and in lock_vma_under_rcu() say - it would pro=
bably
> > > > > > be cleaner to perform the vma->vm_mm check inside vma_start_rea=
d().)
> > > > > >
> > > > > > In this scenario where the VMA has been recycled, lock_vma_unde=
r_rcu()
> > > > > > will then detect the mismatching ->vm_mm pointer and drop the V=
MA
> > > > > > through vma_end_read(), which calls vma_refcount_put().
> > > > >
> > > > > So in _correctly_ identifying the recycling, we then hit a proble=
m. Fun!
> > > > >
> > > > > > vma_refcount_put() does this:
> > > > > >
> > > > > > ```
> > > > > > static inline void vma_refcount_put(struct vm_area_struct *vma)
> > > > > > {
> > > > > >         /* Use a copy of vm_mm in case vma is freed after we dr=
op vm_refcnt */
> > > > > >         struct mm_struct *mm =3D vma->vm_mm;
> > > > >
> > > > > Are we at a point where we _should_ be looking at a VMA with vma-=
>vm_mm =3D=3D
> > > > > current->mm here?
> > > >
> > > > Well, you _hope_ to be looking at a VMA with vma->vm_mm=3D=3Dcurren=
t->mm,
> > > > but if you lose a race it is intentional that you can end up with
> > > > another MM's VMA here.
>
> Right I get the SLAB_TYPESAFE_BY_RCU thing, what I'm saying overall is 'c=
an we
> detect that we lost the race by knowing what mm this should be'...
>
> >
> > (I forgot: The mm passed to lock_vma_under_rcu() is potentially
> > different from current->mm if we're coming from uffd_mfill_lock(),
> > which would be intentional and desired, but that's not relevant here.
> > Sorry for making things more confusing.)
>
> ...and because of this, no we can't. I hate how uffd is implemented.

I mean, we are in a context where we're looking up a VMA under a
specific MM, we know which MM the VMA should be from. And we have a
bailout that checks for this. It's just that by the time we can check
if the MM matches the expected one, we've already grabbed the VMA.

> > > Right so, we have:
> > >
> > > 'mm we meant to get' (which apparently can't be assumed to be current=
->mm)
> > > 'mm we actually got' (which may or may not be freed at any time)
> > >
> > > The _meant to get_ one might have eternal waiters. Or might not even =
need
> > > to be woken up.
> > >
> > > I don't see why keeping the 'actually got' one around really helps us=
? Am I
> > > missing something?
> >
> > We basically have taken a read lock on a VMA that is part of the
> > "actually got" MM, and so we may have caused writers from that MM to
> > block and sleep, and since we did that we have to wake them back up
> > and say "sorry, locked the wrong object, please continue".
>
> OK I think this is the crux of it then, and what I've been missing here -
> we have taken a read lock _by mistake_ in effect on the recycled mm, whic=
h
> may end up to be a spurious one that we need to immediately drop, but
> because of this we might have waiters that could wait forever.
>
> OK I get it. But to safely reference the mm here we need to be assured it
> stays around because in case of this not being true, we have nothing to
> prevent that mm going away right?

Yes - as Suren explained, as long as we hold a reference to the VMA,
the MM also stays around, but to access the MM after dropping the VMA
we need to somehow grab a reference on the MM first.

