Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA100C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 19:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382F36B00C9; Wed, 23 Jul 2025 15:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35AAA6B00CA; Wed, 23 Jul 2025 15:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A106B00CD; Wed, 23 Jul 2025 15:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09D606B00C9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:53:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 939AE1601FD
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:53:21 +0000 (UTC)
X-FDA: 83696578602.08.7E4E2C5
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C0E440009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 19:53:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XZPhYEIT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753300399; a=rsa-sha256;
	cv=none;
	b=g0keg4CXxJruMzhv6J/X1IWZL9z2jd5td4FN3ocXUoXRUjl3iT1rdTUYTX7laQfcnotqCP
	8aoJFTOS0wmUiY4j1bEMX0Q7U3hKTw08UXbn314l2a+YJ5+SbP5w2SeAEUPCsEXvuRFQU/
	nApI6iHVuThOeyAqOtyfdfAbr4pKZuU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XZPhYEIT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753300399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bnpcnE1fkwQyW3rhyr9hOHNwso9We4QMT1uHZvBtss=;
	b=ZNoVRzTxQmY1TGiLoZoV/kV+rPi1Z079Dl1mhIpavWxLA0gtmIMZRkigDwbAdaTkLRQWHw
	QmEuzUwfIEXGL7tQ6u7KLz5HTxudcwNxdY8hGofjLfiIL5gXRtsBCot477z2f4LO18vCMX
	Xlg5Wb6x+IMNAYdqxFBQCxTPAOMPXoI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso415a12.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753300398; x=1753905198; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bnpcnE1fkwQyW3rhyr9hOHNwso9We4QMT1uHZvBtss=;
        b=XZPhYEITWglHUzldplY5AMon4yj67Y/HPmVXRo+WjgO1fS4ytGfGuOU7c3ySmMYnYe
         GCQX4pdmbHy7jr34EFxRd+UGykRltql9+wsOULCWcgwtX5cKWtg8yiBsbxkW4nbzyrmh
         8pVvtJcJrf82Euxe4KUUSgugypMtxD5OhRnaYOm1oO8legbZ3MSGtI2cG8hbyLe9HQKi
         q6VwE0KXHHIm/gUec5nTqiLUr5ehUYJVwLjT4uPVOY8OiwEeLGaCr+OrAJ6NpiMF12xL
         2TbrFp+ngKcuS/ccO1ydf+qNswIooBhkbW0SRffELBY4qd3F5TDKJ2i2PAJuJ2tKt16H
         giKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753300398; x=1753905198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bnpcnE1fkwQyW3rhyr9hOHNwso9We4QMT1uHZvBtss=;
        b=CVF2MDhsYLyQcrqws7lgEPnZeWP6P5PpfVE26fRFm/L7UisI6vra7YKBcn4gG//VXU
         aauw4oYa8uNnSsnuYlZ4S3Z+/ehLVHFaGxi1KRyFmO5RJnoq/Vx9rFaRJT6kYTs7oXhM
         oCqEp+0JoC2uYhGSNPsHcNvteNCKRXPugbMbDb8/QtFblmK+Q4kUCX9q7vW4OX/ynXud
         MkH8UCmlxwGx9eC5EJB3y+WT+tMhQuT90w4Q7oHihL3Xlpbl1O2zgSOQjNObsd4tlVuE
         sHj2AOX520ZqsrZFT5g8Ey4SikBH2NZ1UrfTYzVepOQHCTXxosWqlCAn06SfNdJCr0Ib
         C43Q==
X-Forwarded-Encrypted: i=1; AJvYcCVS3CrE9Dl9Zk2otPC2ik94PjBFo+8b9N+duxlBGVx8S7LGJwjoC5MpQs7dXRK5jj53YXKn6hYccA==@kvack.org
X-Gm-Message-State: AOJu0YzFeZTxphUFKzUMqgK0onZUNDW+Jt82nfEVU4NQWQ25Z7tTLPfA
	cxnVNVXdeujGyt3dYPdiZmj+UBLmKudBhdvDRxRmn0dVfpjtuXERCJh+clF957KHlawsdMtcw+D
	A0bnrFgB7t3w/helLW6E4kOuL2wyp2FO0zM4a2fhm
X-Gm-Gg: ASbGncu6bLud0G6/s9vjIoQLBsn9Po4a33++bhtDv2VlZXV9Ya+wzyGpAMgI2M4q3k3
	Zy2004w6tzfmbHuuhctvdh/vYELLrBaZY3LrgTKUigUUQ69FErwaYZSV2GuI2TSzCLwSjuDh3qJ
	RETJUhHx++lVVyFrKEibpt+y3gl8f23buullg7mcV96EmClF8vGLZXmWMxFtBQkIpoCuayHFkhc
	bJhXwyyaOQvg1lZb0yXb7PkQrFdmmCJ140=
X-Google-Smtp-Source: AGHT+IEpUE9GYvSLtb7w3d/O+eozi8+DViR6ZZEdPliTC+wgOSS818919CJlmXbVLWW4EIEGd+NJv6m8e+Vvpdp5io8=
X-Received: by 2002:a05:6402:290e:b0:60e:5391:a9e5 with SMTP id
 4fb4d7f45d1cf-614c50e54camr9355a12.5.1753300397200; Wed, 23 Jul 2025 12:53:17
 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <28e1fc65-995c-4185-b5c2-7eb001312698@lucifer.local>
In-Reply-To: <28e1fc65-995c-4185-b5c2-7eb001312698@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 21:52:41 +0200
X-Gm-Features: Ac12FXwPWJF6R7SG9BtZJpb2I9YFfCkUYHPki1cbGvCKwCZKU_i67BSwznUK6t8
Message-ID: <CAG48ez0KE9bfFJ+yAMPUAj=_hcNRfes3=nfQd7Rv95TSnHtUCg@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a6xr6p1b31drxe16kseig3dj91e1n8yh
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C0E440009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753300399-111554
X-HE-Meta: U2FsdGVkX1969sVdIZyOZ4zPLkOfepnIq5bJ7sw3zEJR7STM2cXuhenElS98GnvUrCLR6k4OpxwZyqZEOpxTweCxNkOoRWfQQVyhUp5wEBsyIbevGlIqVDk0s2eqr+IZSm64ZJNFTvJJh/r2qkZgx3a3F0XGBafVlKHKBGBCSTL/XSNbL/TTATW53YwcimHCKQo9yxkUi+g2YJ9BcCHJ6nfwMWHSK3+gb9mIYQD2/uk2r7xDf/PJpocexwuJkAc3fKesFKi6qA7JAIxzZaG4rGUw9s2DJbMzQoECZdhQKz36w2jsKiDyjMQTVb+yWDBSJi7UFrNuf2DB/eyG/cIuhQvIdC0KOdmNHJ2ms7hYgITZoKitR3ftuDODKLIgU03YXuk+WCHass4FKlpeF+k3Y3tbupviiO5r/WWmJRTAYsfZdNB7ZqOWOYE7Jsx6PSOA/ZFdKgMAnoC5oafE/R73xziKqpEe50BRnL20NKh4MUFVswu+6UsPWY9xfpFKhM+aLeXwXqf7ale1KAeK2cMvb0VKjBYuVo+HJOR2FSVuJudMnYT2La6dMXf1f0I0eoMFTb5RrAEFGaq2ZX/q/qeUiwr7e/Um4yF1oSt+VqU6qJ4GAxIbQ2EU6m5mdFxDbfkyYGWF0X/ItY1ZRCykR7rlSt6ZnWdj+t8buNcUjRbSgIYhAOTOnLIEwubmZrgs1gfRGRGGO1NdrlyyEvooBQ4pOnmQJwuuueBZfw7ias4JzQ/OiVuWJewTGm6Pc0gHcyra6KYUw7lxyZmZOzPbD+WGVkiUcXGmXaPpHdauGIS7a89PrOzihh5ZVEzeZ2JCp2Ir4IepPX+ajcWbENlosb4DSm8PAi5e+xjkp2WfVzQ08yctPtTuCgh93YZxJdrEbN707e8pFTA+sSyMZS+iqKVYnRHr9xGy8/vgd/Vy2IyBABKwp9DHg1CycHvg/AavkUB00dAt+J2ZucwGPFNoKbr
 pGmsKPqm
 h/+mzzpE1cvXYitF4ceOjvFYi71g+iVvJHEzgVyGXrCMJ97+we02zF1+45sg9Tc5PYkmmGlmwo1GKL5p9aAajosYiqoDkv+FgZmlb8/Xp0ADfrWSfLJJNfWRg7pVYmi3joLvOoM81HoOQ9e++V2vBF0SVT20nWOQkisuvQB3SysrMRDX15CjeCn/ZvgSWfdFyVxn5BaDbeBVZRXKEfQ8F9FIxojCvh7qVnDjtfoPbveEEdMy+dK0qxJw2lxpjZyr2bbnmMUv08BrFKFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 8:39=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Wed, Jul 23, 2025 at 08:19:09PM +0200, Jann Horn wrote:
> > On Wed, Jul 23, 2025 at 8:10=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > > On 7/23/25 19:49, Jann Horn wrote:
> > > > On Wed, Jul 23, 2025 at 7:32=E2=80=AFPM Vlastimil Babka <vbabka@sus=
e.cz> wrote:
> > > >> On 7/23/25 18:26, Jann Horn wrote:
> > > >> > There's a racy UAF in `vma_refcount_put()` when called on the
> > > >> > `lock_vma_under_rcu()` path because `SLAB_TYPESAFE_BY_RCU` is us=
ed
> > > >> > without sufficient protection against concurrent object reuse:
> > > >>
> > > >> Oof.
> > > >>
> > > >> > I'm not sure what the right fix is; I guess one approach would b=
e to
> > > >> > have a special version of vma_refcount_put() for cases where the=
 VMA
> > > >> > has been recycled by another MM that grabs an extra reference to=
 the
> > > >> > MM? But then dropping a reference to the MM afterwards might be =
a bit
> > > >> > annoying and might require something like mmdrop_async()...
> > > >>
> > > >> Would we need mmdrop_async()? Isn't this the case for mmget_not_ze=
ro() and
> > > >> mmput_async()?
> > > >
> > > > Now I'm not sure anymore if either of those approaches would work,
> > > > because they rely on the task that's removing the VMA to wait until=
 we
> > > > do __refcount_dec_and_test() before deleting the MM... but I don't
> > > > think we have any such guarantee...
> > >
> > > I think it would be waiting in exit_mmap->vma_mark_detached(), but th=
en
> > > AFAIU you're right and we'd really need to work with mmgrab/mmdrop be=
cause
> > > at that point the  mmget_not_zero() would already be failing...
> >
> > Ah, I see! vma_mark_detached() drops its reference, then does
> > __vma_enter_locked() to bump the refcount by VMA_LOCK_OFFSET again
> > (after which the reader path can't acquire it anymore), then waits
> > until the refcount drops to VMA_LOCK_OFFSET, and then decrements it
> > down to 0 from there. Makes sense.
>
> Sorry, this is really my fault because I didn't closely follow the
> reimplementation of the VMA locks closely enough and so am a little behin=
d
> here (I'll fix this, probably by documenting them fully in the relevant d=
oc
> page).
>
> So forgive me if I"m asking stupid questions.
>
> What exactly is the issue with the waiter not being triggered?
>
> I see in vma_mark_detached():
>
>         /*
>          * We are the only writer, so no need to use vma_refcount_put().
>          * The condition below is unlikely because the vma has been alrea=
dy
>          * write-locked and readers can increment vm_refcnt only temporar=
ily
>          * before they check vm_lock_seq, realize the vma is locked and d=
rop
>          * back the vm_refcnt. That is a narrow window for observing a ra=
ised
>          * vm_refcnt.
>          */
>
> So, if this is happening at the point of the unmap, and we're unlucky eno=
ugh to
> have some readers have spuriously incremented the refcnt before they chec=
k
> vm_lock_seq, we trigger __vma_enter_locked() and wait on other VMAs to
> vma_refcount_put() to wake it up vai rcuwait_wake_up() if the refcount is=
 still
> raised (which it should be right?)

I'm not sure if I'm understanding you correctly; but yes,
__vma_enter_locked() waits for all the waiters to drop their
"refcounts". (It's not really a refcount, you can also think of it as
a sleepable read-write lock where the low bits are the number of
readers.)

> So actually are we going to be left with readers sat around waiting forev=
er? If
> the scenario mentioned happens?

I'm not sure I understand the question. Readers don't wait, they bail
out if they hit contention and retry with the mmap lock. As far as VMA
locks are concerned, readers basically always trylock, only writers
can wait.

> If we make the rando mm we are now referencing stick around, aren't we ju=
st
> spuriously triggering this thing while potentially leaving actual waiters
> waiting?

In that case, the thing we've read-locked is not part of the MM we
were trying to operate on, it is part of the rando other VM, so the
writers we've blocked are also part of the rando other VM, and so the
rando other VM is where we have to do a wakeup.

> I may be completely misunderstanding here...

