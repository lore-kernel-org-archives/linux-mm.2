Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C244C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 19:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E45D6B0186; Wed, 23 Jul 2025 15:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5931F6B0187; Wed, 23 Jul 2025 15:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481F86B0188; Wed, 23 Jul 2025 15:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E60E6B0186
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:44:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D75891401EA
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:44:15 +0000 (UTC)
X-FDA: 83696555670.08.7F403B2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD15EC0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:44:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GTAQY9pK;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753299854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaN1WGDKQHaiwhr4TxEnHlfmCKQPYHCZzOv+G3IA8EE=;
	b=sCmyN5KwvFNxauO/wGA4HdWyWciXNYpQiDYKw8pv7U+Gz1pWKwi6Y9mHR27AsWa3bQ1ro7
	0806eSMZW9tqLdaApUndNfkhPmgDVJ7PFncfgjRrNrI4jnzPJ3x5L7bW/368Rn5XUKtCVk
	gMyVpF0odvI/sxqH5gI8hwaM4Eg4G/U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GTAQY9pK;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753299854; a=rsa-sha256;
	cv=none;
	b=LubJka13MChp4ORWRaLm0s6qp9hgug9MXeqQF76S1w3/MNBRViqQYGDgkULCtIkQaImjfP
	5kQQP79MnkhfiXhX6jcnYMn3qQs7cn6bkzsZEQsoYg81NArF8BFBZZfFJCEklvAWo6Jb4X
	KIhYx94D5l3DPL08DzYlkyFcaPOnU1w=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso312a12.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753299852; x=1753904652; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaN1WGDKQHaiwhr4TxEnHlfmCKQPYHCZzOv+G3IA8EE=;
        b=GTAQY9pKgcYgDwz6TbiA9NS44NJlhcXEDgIk4L+jB33yjy6ulmawkUSNqrF4IVp3Ub
         81X7yegqZRnaIB7XhRri2CAoOpvImfKXPJ/Tx25nMPFIwHfUwEHez9kKPY99zSW9qc+C
         yTATiSoA6MIocQxJlOcXKFGa86egdQh3ePbv+yV1V4OfQ+z+naAMK6FMay74pQpz7715
         piEBeyyRk2rd2wVRtSxxpDsbiXfqfIw/ORZ55sTA75o+jLfmn4HGE/UXl00yWKssNk+o
         W8OwbYVl6ZieM7r64uxT/LIADtC4Jc5/oVE866CpYCiDVr3Umtwf+DV7QD8pnFMQ9dAN
         8ydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753299852; x=1753904652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XaN1WGDKQHaiwhr4TxEnHlfmCKQPYHCZzOv+G3IA8EE=;
        b=MRdKiGD8J7+e8vWQz2KxVKveP/QVZnv3fJsPC1RlQZGxwiIz84kpbno3NE4IN4uW0g
         a71XN9YgyDVClZkT9necZK67zEQp4rWMvc6hQktsuqERln7lco89Qc11Q8mbw0vzPECs
         A8wqVsAORKBrgP9/+GZi2Rv/9boy9DJaK30TC87Cy/w2gD3qpKSAkx/GlkDqj7Wxw2VV
         rKGAWdTYzfkNQ/VM8C3KFSvVhVLtoWuhEAa4hXpuxK3ogLtydS5N84p9dvcz3WRh8r8O
         uZmUMwJm9mwNWFX6IXBQ3qMuCKZa41lNU4TmO58DSPowrsyEzP9VM6zhL6NRNgTDuLEs
         +ZVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnDeHS8dpBL06znL6gs92RuU8bSl7Xh+2eGoLZi0hFuwYs2SK8eMAah2EpjRUGm+6/VWKd6cYWQg==@kvack.org
X-Gm-Message-State: AOJu0YxryZChyZiLR5wSApkuPREkmRQsnw2zxFooC8RRaj9JCWzmHcVX
	XDYqKeIiKcEjKhaAtsqIRylyfoXhVP/ZVUA1gI5EJ0a7DP1pZ5PG9CO8iMp28SIa6bXYLWEqPAh
	Gv2/6vs3AdWcv+VjVUkXIRaGGgJmHL2Hd4IHKR0qq
X-Gm-Gg: ASbGnctfmIApsinWlp8iudKWo9MbQomv1f1eY5nb5oJDNKs46N8951y9myqepIyR4X2
	PPZiscniHRyLgT0qiCe73tfX3ANkx27f8Wwm2Q9pCSmoEHbObG+AJf0LT47irL6J8ZQNabxnYZg
	RlqST4FDs+XRoEqFhN/H47N2/xcwmm3zEfFd2kCtaR2TJd+ygoRc5cPCw8H/ADoYpiC8dqJKMPt
	Da/trCmTgeaf7vPRR++FuBMzf9Cee5fqGE=
X-Google-Smtp-Source: AGHT+IFMeqCitJD6jm1zqvi8Ttzy3WukgRxUcRQxmGCyWwc9SJ6vzxv4EsIqbCmMjDmLpqk2WxMCVB8xiYvHJZ/JAfg=
X-Received: by 2002:a05:6402:290e:b0:60e:5391:a9e5 with SMTP id
 4fb4d7f45d1cf-614c50e54camr8707a12.5.1753299851863; Wed, 23 Jul 2025 12:44:11
 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <6df9812c-96a5-41be-8b0e-5fff95ec757c@lucifer.local> <CAG48ez1A17JC7Q35jmurY+Co0t_a78bPy9eRWRim7xJy9oLCvA@mail.gmail.com>
 <3a233a85-3a94-422e-87be-591f93acbac7@lucifer.local>
In-Reply-To: <3a233a85-3a94-422e-87be-591f93acbac7@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 21:43:35 +0200
X-Gm-Features: Ac12FXxW2NJbsvvD76QaLD1QW0CpKWEf0udDddiz4nnxYVo6u6jF9RMz2kxQd3k
Message-ID: <CAG48ez36AcGBy8_wo09WEHz98Dp44yKZ_FiVtFt8tcV9WiHafA@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, 
	Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: np3yrs8mrd74prs3u8mxydb95cyfqqzd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD15EC0002
X-Rspam-User: 
X-HE-Tag: 1753299853-885801
X-HE-Meta: U2FsdGVkX18XWe1TuG3zaJES+XUJunhLd+kzVdCmJN7dIX/dkmQwicp3BXRjpl56/M+n12sd3HdEwxzFjmk/55Kyp+QSlqzCvU6YM1mkDCPpAqXwitifxPfXyBA0PU/9Yj8K8wMVEutsXDIHf1VqrxlvrBoSxSiUBj1CjcaK319Iv+kGjR2TO3hldNSrPtMsj/jex2YSCgiaUvi8BQPm3UcyHB3a6JJ5APKC5HM1Q+ueOQFk+S67GUOQXW64q/srZXsshdyBx12ZbJ4B3lOjidKHKO5fRlFkF3xpCF3ADomOtJHKzeFIpJSvuwKq70/g+dcCQQCCvUOTQiYvubqZ5bAOXdIJ0jPIx7vKMg9xuy1Ib8X61ACexOU8pnYBORYK3EzoerorumtuQ+i/Qq5XFfyMzePpz036assyDYBTTYP8d+OyfC5MbNtXOWENznF8poik+BVO26C5IRmmuSvRJhzwWJP/SxMtPqLzQXtmMPUjb4i7UwoKvp9WOCZJ+DA+SH6dyVGj3i7KUyo7/SdVCFoHGgbCKgVUP2bgyx250fw3Ps7LKYp8lvgr4AZchaoWf3KRQ0a/c4o+fFvCmUigvpF9LCVsKhzYWnVj8Nm/ZX18pdOMHU9gzrtFbKmY2h19NajIvYH7LCgsL1jX5S28AuUvqG5a/3Xy6SgTRV7BwzelXLmZA4I2dEbl8ZNXAnfdra+t4JWQONV31FK5Tcpzq22nHT2RBKb8B3wNtZ6vLzHfXlou2cN3cUsMvDXEsMompDhKG1t3SEInq1oEpYFrK2BsFW7eS51pNZ7+chct2u1ScSrMbbCSrInqYb9RPVaZzO6LLZPk6r3tzuRu+KlnSVJDxAPsNJef3nlPhed4LSi3AFuKOdzQglfColFMm1SpcKqP1GQk34/XP/7PGgpUFLDFj4hJeqo709kVU8XIGYGeSxZ8edEvMDiWdO3sGjVYnbcoc9PhLl88c7onvtD
 +Hfg828c
 9nqKyAb23iF8Up/1gMwPb5RULOPWV1v5z21zvo9uatVFZ+0CcR1deKwvxsro1vHITet+yte/8Eybvk8nOyoyT4Fz5+kSg+yqthAUrgZPmTOh0jLoPVJYn3joVyxaeXcvqKCPYoIP3cOSF6pS1+aEtTGlZSLvS8OnjES1PjkvMUJKnEKBWI2M+lO49lDk+QfxZu/6fw4DubitWfHqxCMGgu2ySVhfe67X4Y2hB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, while typing up this mail I realized I didn't have this stuff
particularly straight in my head myself when writing my previous mails
about this...

On Wed, Jul 23, 2025 at 8:45=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jul 23, 2025 at 08:30:30PM +0200, Jann Horn wrote:
> > On Wed, Jul 23, 2025 at 8:14=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Wed, Jul 23, 2025 at 06:26:53PM +0200, Jann Horn wrote:
> > > > There's a racy UAF in `vma_refcount_put()` when called on the
> > > > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is used
> > > > without sufficient protection against concurrent object reuse:
> > > >
> > > > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() unde=
r
> > > > rcu_read_lock(). At that point, the VMA may be concurrently freed, =
and
> > > > it can be recycled by another process. vma_start_read() then
> > > > increments the vma->vm_refcnt (if it is in an acceptable range), an=
d
> > > > if this succeeds, vma_start_read() can return a reycled VMA. (As a
> > > > sidenote, this goes against what the surrounding comments above
> > > > vma_start_read() and in lock_vma_under_rcu() say - it would probabl=
y
> > > > be cleaner to perform the vma->vm_mm check inside vma_start_read().=
)
> > > >
> > > > In this scenario where the VMA has been recycled, lock_vma_under_rc=
u()
> > > > will then detect the mismatching ->vm_mm pointer and drop the VMA
> > > > through vma_end_read(), which calls vma_refcount_put().
> > >
> > > So in _correctly_ identifying the recycling, we then hit a problem. F=
un!
> > >
> > > > vma_refcount_put() does this:
> > > >
> > > > ```
> > > > static inline void vma_refcount_put(struct vm_area_struct *vma)
> > > > {
> > > >         /* Use a copy of vm_mm in case vma is freed after we drop v=
m_refcnt */
> > > >         struct mm_struct *mm =3D vma->vm_mm;
> > >
> > > Are we at a point where we _should_ be looking at a VMA with vma->vm_=
mm =3D=3D
> > > current->mm here?
> >
> > Well, you _hope_ to be looking at a VMA with vma->vm_mm=3D=3Dcurrent->m=
m,
> > but if you lose a race it is intentional that you can end up with
> > another MM's VMA here.

(I forgot: The mm passed to lock_vma_under_rcu() is potentially
different from current->mm if we're coming from uffd_mfill_lock(),
which would be intentional and desired, but that's not relevant here.
Sorry for making things more confusing.)

> > > Or can we not safely assume this?
> >
> > No.
>
> What code paths lead to vma_refcount_put() with a foreign mm?

Calls to vma_refcount_put() from vma_start_read() or from
lock_vma_under_rcu() can have an MM different from the mm that was
passed to lock_vma_under_rcu().

Basically, lock_vma_under_rcu() locklessly looks up a VMA in the maple
tree of the provided MM; and so immediately after the maple tree
lookup, before we grab any sort of reference on the VMA, the VMA can
be freed, and reallocated by another process. If we then essentially
read-lock this VMA which is used by another MM (by incrementing its
refcount), waiters in that other MM might start waiting for us; and in
that case, when we notice we got the wrong VMA and bail out, we have
to wake those waiters up again after unlocking the VMA by dropping its
refcount.

> I mean maybe it's an unsafe assumption.
>
> I realise we are doing stuff for _reasons_, but I sort of HATE that we ha=
ve
> put ourselves in a position where we might always see a recycled VMA and
> rely on a very very complicated seqnum-based locking mechanism to make su=
re
> this doesn't happen.

Yes, that is pretty much the definition of SLAB_TYPESAFE_BY_RCU. ^^
You get higher data cache hit rates in exchange for complicated "grab
some kinda stable object reference and then recheck if we got the
right one" stuff, though it is less annoying when dealing with a
normal refcount or spinlock or such rather than this kind of
open-coded sleepable read-write semaphore.

> It feels like we've made ourselves a challenging bed and uncomfy bed...
>
> >
> > > Because if we can, can we not check for that here?
> > >
> > > Do we need to keep the old mm around to wake up waiters if we're happ=
ily
> > > freeing it anyway?
> >
> > Well, we don't know if the MM has already been freed, or if it is
> > still alive and well and has writers who are stuck waiting for our
> > wakeup.
>
> But the mm we're talking about here is some recycled one from another
> thread?

The MM is not recycled, the VMA is recycled.

> Right so, we have:
>
> 'mm we meant to get' (which apparently can't be assumed to be current->mm=
)
> 'mm we actually got' (which may or may not be freed at any time)
>
> The _meant to get_ one might have eternal waiters. Or might not even need
> to be woken up.
>
> I don't see why keeping the 'actually got' one around really helps us? Am=
 I
> missing something?

We basically have taken a read lock on a VMA that is part of the
"actually got" MM, and so we may have caused writers from that MM to
block and sleep, and since we did that we have to wake them back up
and say "sorry, locked the wrong object, please continue".

