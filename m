Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EC7C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF598E0001; Tue, 29 Jul 2025 10:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160486B0099; Tue, 29 Jul 2025 10:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076458E0001; Tue, 29 Jul 2025 10:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86096B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:24:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A59DF1A013E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:24:38 +0000 (UTC)
X-FDA: 83717523036.07.D749A36
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id BDA86A0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:24:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZOk6Qc5c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753799076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVNRcNSlbkisMQ7P3F3haQRx0uZA0/7rOJPK9raObGg=;
	b=f1W4W5Ci64MpevEUE2fQEjfpAeHiy53dgjsZ3nxPExuXGy75KhJcazd+VWTPZ4qgbs+5LL
	GdCOyS8iX4y9qhfgc1BgejWVVo52/PjgSQcodCx6pqKhU7KoBTZSuOO6HO7lxejBXSHBIB
	FWj9ybyfwqezLvi+kQHIT0N7ujbeRnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753799076; a=rsa-sha256;
	cv=none;
	b=SRT0Gueh//da0L5/bEbhn7P67i0BaBtoSmWx1GizyKcJN5vWmL/DsELxTSizVmh7KeuWJh
	tKw1y4FLHSmAfM3qRMYq+K0unn+9wNm/OLd0KA4Ft96o9KrWx4uKrsd6cyM6rTWVlbR3HP
	0Vwn5s1NKwCKiTbaZwu28f15Aj/AaUg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZOk6Qc5c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab3855fca3so314841cf.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753799076; x=1754403876; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVNRcNSlbkisMQ7P3F3haQRx0uZA0/7rOJPK9raObGg=;
        b=ZOk6Qc5cDJ8zljtgJJBovfIQU5ClK0+k2xwGXLdVqN4XeWsRIg2hfTykNqziFZvnXV
         b/mo+3NOTu5mxPSLnJZJlBI4vZSvZnaKIyGD8lDlr4YNqwiXqeowl7Go6odpbD1QZO4O
         hAkJOXg2oiAaJyX6Yl6ovtG1+E915G/ZekXM61MR6SMZ9MH59l0UlRkHbfl+DOBG0rKa
         A9dxYdGnhKYWZXuA+Q6/5IqWKLaD71yfnsrlNqE0nn2EiOlGdnzYmitxtqMZzVQ52D5P
         Xg8z9L/r0EK+rJOchfJSh7pHxGijkrYD1Dp2KpizU1ePpteXznJ2pvekpZvBxt7Hl6MF
         xcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753799076; x=1754403876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVNRcNSlbkisMQ7P3F3haQRx0uZA0/7rOJPK9raObGg=;
        b=TP1yY4V8BJN73EAgPjdy45qWmsQdgv/DCxq2ONttLF2rnmJ1WpQa0u3qCnpXVT6ENP
         IHelLVaqT2Z8O+QXCESGuCpfzQCZkx4xkIUTdso+mjowXyErfcQvjkRC1xEfd229xd5M
         sfKClHT0S+xFZiYwFIWEmWjU8LAO14x+WuDgRNpyIfiq9hi0GWEumcS65XHHuEKOMqiT
         hfjUO8O9/SEhJHnKJtd2NGtf5vNoog0t5yvS2l0N6EnertUuXBDSvaiQssGMQu5L7VIA
         MVXSn1SEutEfyopRcDHyzc+rj2l3OiWwW9YIu6LaAh51oW6d2LDk7lLUba9yaDKUGLlV
         w57Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzzfiDgaRtGekhkqfiByLoH/ooFRy56wVFhEED2QdAkK6C+OJ59mosc4zpiF1t7DaPe43xV3cvAQ==@kvack.org
X-Gm-Message-State: AOJu0YxGf+Eqhn2nLM0JYCG3+cvmTAkCt52WIz088nNtXIboLYwpmUqU
	S/ws3FH9Oa+1XaFTVmNxHVJEG1ZbS9WhtlB5cLohLlX2xfUxN0IziK3wm2vMAjSZmk2UbJejxzl
	fJ3WTV68XwmRccVUdlz7YFU9LXj+p3wabiUabCV2G
X-Gm-Gg: ASbGncvcC3imCPFAjhVuqFkrp/PHlS332xS2rIWmyJy3sSUszutDFUzfoOFbvILERfe
	GsFE3GtlEQDRUwDAPhZDKHfCaqPVLl+PiGL5yKEiB/L/WL9mnSj15pffm1wct7yhxQ5/VU9h3yC
	vT0kP/l9oBF+cVPjOiA4XwN0iwgR0kUdYjALO9HOP0mesDYdpWJG2WUAaWEx1Yrf2fzXQLddj9a
	U9eTL2GCCi9GjJDYESis/UABT5KPd37Db54fw==
X-Google-Smtp-Source: AGHT+IEXo19Mea95cq4eF+yZwTGp8JvbbbpniaHFDfY2wI+smq2JppWdL8kf+LAMrq8yQm/JSqfb/IL1F9mrSpQdTpE=
X-Received: by 2002:a05:622a:a:b0:4aa:cba2:2e67 with SMTP id
 d75a77b69052e-4aecfa456f1mr4144421cf.21.1753799074080; Tue, 29 Jul 2025
 07:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250728175355.2282375-1-surenb@google.com> <63d2682f-a24e-4fe2-82d1-fb58a8575c6c@lucifer.local>
In-Reply-To: <63d2682f-a24e-4fe2-82d1-fb58a8575c6c@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 29 Jul 2025 07:24:23 -0700
X-Gm-Features: Ac12FXynCQs1QPHMicNL6A7GQQxpOS8RnWUYjhc0eE8qQpCjkBRUbMLdsSemDCk
Message-ID: <CAJuCfpEHdv5VXrD06SO1WkB4itqNsaWq3YKoXVYtyLPP+Cq4Mg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 776db5g4ah53m3sbkcs7m6c6yhgmj8ep
X-Rspamd-Queue-Id: BDA86A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753799076-812510
X-HE-Meta: U2FsdGVkX19bxmvpR1aSTRz8NrPOL4q6RXaH18yHgLJKqAffMEAbuS7geVl69S1OMZVAC0hG8LqCMSMZRvpB0PyqGvyewq8uBTo5tVMn38Q/AvbhL+TVn1blWP3gwt84GkC6H+bIcktA/KL6Na9sJ2DaW6VPC5vcJYCTOCfFrVi44uSzHlIkY1bi1iy5ZIwn7ycon/XUP3Tq8Mc5AZ4UAdOFIJ0MGzUK4baILQf/3c7fO9o2XjCvj4uM9WTOaxZO3N/kMfD98l8C1O08jYunnIZaHkBuNuid0bH6J0h+tp8Lvd1la0fr/bOqOduoxoWHGbRQwM1m4kf6afKabUDzNlzi2Ts/KW9WViODkRsv//1YZsqzXUwBY8ArFwtvttdIBzgwTQ1enSSjjc564Xt2lJJCp7tHOhzo5333YHx84oNQuCe7Pv6me3e3TlDMgxmOQozUhxvbUAojf08b1NxJcxqz+8wdAcaDNnxjISTzEP10t38Qg7A5E0R5OKKcNZZsj3OdVnG76SSFv7AASNvMznTzv8r5icOMGJ9b8zUvkbV5LtGFFAGPxnQANoLDfDekxP+PN5gYrg1aBGG7cE2ynJF8a/WCIk3W3Dbqyaq83kw+K7ObAEnQstD1SfHkt8CpKiRCzM0WwUZ2mh3LHpgp+UexwSVE5zILthWpRd4ywy2WhPhNrSC0hUi6+a4h8x86cCGMaI2uJ6gvPVqeCS5HEaEV/H1Hyh/xDI9DA/ewv560mI5K3/X7QMJwLG6QRn09RS91TSbaMHYv7ecsBXKJitUNAiUwyxAdG8bTgqmp23SayyDBpgK7CUuuI5mEBcfFN/ti2agRwuPqOn2ubEnFrSFVAmGP1nG4XYRUUi7H9fwHyXdGxrNPXGoBR7Kzt5okf4Y3T1KuQ5Da6cHDztBsbc/Jzrfu5cnZ6dgRDl41ljPNnelnofd6vrgcISKn2VdcLME65w6ktXBsdJ3NGIy
 gj4jL/L8
 PIeQoJan3mv9QEfF/ZXvOYDT4WpZ3WVJIRWA7Wk/T3t8xLREilLEv7+aRSQFXIGCiaDNP4H4fjvuvpmNnYYY85k/SHeQvEsaS6P+bc/M5PbSnnNQCPMp4zUWKlL6bZKCnMiu3uCUrkS5z4A6koyuP4ACb7vws2pCPqd3apEum1D5zU3WALZ7kOc2+3U4co2aqtyxawzCz7iioYh5T6gPkezMcY/j3wWZbIIortAlwWDmDBCsBncH8OpVt8/SEPkya2jmoH/01PYwmQRsedk6I/lMU2ytCuxnYTgc4/j2ocPvBRWHxHVwdGiDN/55YALihIaQ2yma5LuIqAvGnkhUxK35i/SCKkSr6aGnEwJT2U7RXleg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 2:57=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Jul 28, 2025 at 10:53:55AM -0700, Suren Baghdasaryan wrote:
> > By inducing delays in the right places, Jann Horn created a reproducer
> > for a hard to hit UAF issue that became possible after VMAs were allowe=
d
> > to be recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.
> >
> > Race description is borrowed from Jann's discovery report:
> > lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> > rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> > it can be recycled by another process. vma_start_read() then
> > increments the vma->vm_refcnt (if it is in an acceptable range), and
> > if this succeeds, vma_start_read() can return a recycled VMA.
> >
> > In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> > will then detect the mismatching ->vm_mm pointer and drop the VMA
> > through vma_end_read(), which calls vma_refcount_put().
> > vma_refcount_put() drops the refcount and then calls rcuwait_wake_up()
> > using a copy of vma->vm_mm. This is wrong: It implicitly assumes that
> > the caller is keeping the VMA's mm alive, but in this scenario the call=
er
> > has no relation to the VMA's mm, so the rcuwait_wake_up() can cause UAF=
.
> >
> > The diagram depicting the race:
> > T1         T2         T3
> > =3D=3D         =3D=3D         =3D=3D
> > lock_vma_under_rcu
> >   mas_walk
> >           <VMA gets removed from mm>
> >                       mmap
> >                         <the same VMA is reallocated>
> >   vma_start_read
> >     __refcount_inc_not_zero_limited_acquire
> >                       munmap
> >                         __vma_enter_locked
> >                           refcount_add_not_zero
> >   vma_end_read
> >     vma_refcount_put
> >       __refcount_dec_and_test
> >                           rcuwait_wait_event
> >                             <finish operation>
> >       rcuwait_wake_up [UAF]
> >
> > Note that rcuwait_wait_event() in T3 does not block because refcount
> > was already dropped by T1. At this point T3 can exit and free the mm
> > causing UAF in T1.
> > To avoid this we move vma->vm_mm verification into vma_start_read() and
> > grab vma->vm_mm to stabilize it before vma_refcount_put() operation.
> >
> > Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
> > Reported-by: Jann Horn <jannh@google.com>
> > Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=3DE3jbkWx=3DX3uVbd8=
nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: <stable@vger.kernel.org>
>
> This LGTM AFAICT, so:
>
> Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!
I think I'll respin v3 to add a warning comment to vma_start_read(),
so will address your nits there.

>
> I'll fold a description of this check into the detailed impl notes I'm wr=
iting.
>
> > ---
> > Changes since v1 [1]
> > - Made a copy of vma->mm before using it in vma_start_read(),
> > per Vlastimil Babka
> >
> > Notes:
> > - Applies cleanly over mm-unstable.
> > - Should be applied to 6.15 and 6.16 but these branches do not
> > have lock_next_vma() function, so the change in lock_next_vma() should =
be
> > skipped when applying to those branches.
> >
> > [1] https://lore.kernel.org/all/20250728170950.2216966-1-surenb@google.=
com/
> >
> >  include/linux/mmap_lock.h | 23 +++++++++++++++++++++++
> >  mm/mmap_lock.c            | 10 +++-------
> >  2 files changed, 26 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 1f4f44951abe..da34afa2f8ef 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
> >  #include <linux/tracepoint-defs.h>
> >  #include <linux/types.h>
> >  #include <linux/cleanup.h>
> > +#include <linux/sched/mm.h>
> >
> >  #define MMAP_LOCK_INITIALIZER(name) \
> >       .mmap_lock =3D __RWSEM_INITIALIZER((name).mmap_lock),
> > @@ -183,6 +184,28 @@ static inline struct vm_area_struct *vma_start_rea=
d(struct mm_struct *mm,
> >       }
> >
> >       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> > +
> > +     /*
> > +      * If vma got attached to another mm from under us, that mm is no=
t
> > +      * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> > +      * is dropped and before rcuwait_wake_up(mm) is called. Grab it b=
efore
> > +      * releasing vma->vm_refcnt.
> > +      */
> > +     if (unlikely(vma->vm_mm !=3D mm)) {
> > +             /* Use a copy of vm_mm in case vma is freed after we drop=
 vm_refcnt */
> > +             struct mm_struct *other_mm =3D vma->vm_mm;
>
> NIT: Not sure if we should have a space before the comment below. But it =
doesn't
> matter... :)
>
> > +             /*
> > +              * __mmdrop() is a heavy operation and we don't need RCU
> > +              * protection here. Release RCU lock during these operati=
ons.
> > +              */
>
> NIT: Maybe worth saying 'we reinstate the RCU read lock as the caller exp=
ects it
> to be held when this functino returns even on error' or something like th=
is.
>
> > +             rcu_read_unlock();
> > +             mmgrab(other_mm);
> > +             vma_refcount_put(vma);
> > +             mmdrop(other_mm);
> > +             rcu_read_lock();
> > +             return NULL;
> > +     }
> > +
> >       /*
> >        * Overflow of vm_lock_seq/mm_lock_seq might produce false locked=
 result.
> >        * False unlocked result is impossible because we modify and chec=
k
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 729fb7d0dd59..aa3bc42ecde0 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -164,8 +164,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm=
_struct *mm,
> >        */
> >
> >       /* Check if the vma we locked is the right one. */
> > -     if (unlikely(vma->vm_mm !=3D mm ||
> > -                  address < vma->vm_start || address >=3D vma->vm_end)=
)
> > +     if (unlikely(address < vma->vm_start || address >=3D vma->vm_end)=
)
> >               goto inval_end_read;
> >
> >       rcu_read_unlock();
> > @@ -236,11 +235,8 @@ struct vm_area_struct *lock_next_vma(struct mm_str=
uct *mm,
> >               goto fallback;
> >       }
> >
> > -     /*
> > -      * Verify the vma we locked belongs to the same address space and=
 it's
> > -      * not behind of the last search position.
> > -      */
> > -     if (unlikely(vma->vm_mm !=3D mm || from_addr >=3D vma->vm_end))
> > +     /* Verify the vma is not behind of the last search position. */
>
> NIT: 'behind of' should be 'behind', 'behind of' is weird sounding here
>
> > +     if (unlikely(from_addr >=3D vma->vm_end))
> >               goto fallback_unlock;
> >
> >       /*
> >
> > base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
> > --
> > 2.50.1.487.gc89ff58d15-goog
> >

