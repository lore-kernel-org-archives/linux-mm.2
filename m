Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D9FC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CBD6B008A; Mon, 28 Jul 2025 13:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCAD6B008C; Mon, 28 Jul 2025 13:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBCB6B0092; Mon, 28 Jul 2025 13:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 574806B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:37:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1531A58941
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:37:27 +0000 (UTC)
X-FDA: 83714380134.27.25E8629
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 25480A0002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:37:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MQOXAd8p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTCbhOW20UHq+C7vediNNb7AZzzKUerbw3OMJQ79PLs=;
	b=0U+M3oY/Y5a5YU8KEo7S/pKkMfr5QuweGwa12/3R+BnJdDmomrUSZRttS26Cl+bOIf3UBM
	b5u7BVJtQjPceArpK+HjUt8XGc1qikuAY3QCyfhEYEWPvcD1gK+9WUX77A8ZGbERwjNi9+
	SQysWzckn2MZKOmv1nxooFRbXgPlGl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724245; a=rsa-sha256;
	cv=none;
	b=naWRMo83blnKFA2TwOcJgyNsclWf4kQu5RnfqchEmd0D2yhfMqu7eiANUu4Lki0flLkR9F
	4OZz3ueHI7M5smBvogIU4yC7I2aTUOTQD5JXAl7p2fMlwl5zx035PYJbeEaJKMGypNxHHs
	kCxEi3WvYlWvjCLOKlNKH9yZWvT/kdA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MQOXAd8p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso48811cf.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753724244; x=1754329044; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pTCbhOW20UHq+C7vediNNb7AZzzKUerbw3OMJQ79PLs=;
        b=MQOXAd8p18N/HA1m64zblIqxhpihQf2Fr7qYgk8Sk2kBqOu3SP8IHCY6AAqFJW58Ov
         x1FvwBYkhWXuKgByMFpOQBXOYcg2h3gzEK/gZ2nbEpCdnm8L7ZHRcCyxvTdkeh1t7j4O
         xJ467I0vpawem4ZYrDzibJKtlE2vInhwVWkHjJHci+tS/gjwOXMi2GZbumcqJIdSAQm8
         dXOmMia+uYbL1dM4CJ2uPs5XJtbfI6QkXhw1MNHTjeHT+H8BG2VTQ6FGchKnjwBxthkz
         J83wsv5C3NjHR9nPkMeArMWFDtTte+38pSGwCGq5Ler4lgbABdXF9P1uAlM3Cve80gYA
         VkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753724244; x=1754329044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pTCbhOW20UHq+C7vediNNb7AZzzKUerbw3OMJQ79PLs=;
        b=OwKyX4nA1GFTEGkCmbsd4AdANJDIK22N8JNytqUoWhdL0wSj/krQwtEgmgCGp9n55z
         VHU/GujHiNJrBQF7Pq5m/TYISJYwjKXC23ATCw31f2TIzclqS2zkK0CzWWtvLgARSpnf
         oEyQ59hBi6CcJS+dz40j58DyDeABuWr4mQEwbgAiHLtUkEGjObu8PXxcRmOGTQEnP8fZ
         hdJ1A8QWc0mfNDRH7fSmCf8WmKXT6mbCvujdAqJUnAF1y1TLAKNrns7tUTivAOrKitxS
         dt4bl+HwVAFIhDwSqIWHNnqKzzYxla12GcjxRwxBpOouj3LpiAJP7LtKf5Wofwfk9ZJ9
         8nnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmKpBzy2CqP/ADs8ZcNEhj690f4X8/rMekJU1YI7AajZsRu1xAtKb55gPPMTRVeZmwcxD3YRb2lQ==@kvack.org
X-Gm-Message-State: AOJu0YyH/0zNabt2RajliyOBQbPT3OBLwsm+ayqgLPojn4FaCnRViybv
	rrFNnzPApjextOVN7D5JzpineIciP3j5xd/aPYzt0zUOBsvwh22/APKKb6cJMVQFUFhR+oUD2qT
	zlRRF+1rlt2MPAOlvAH8aYnXJt80Wx7Rt46bYK87x
X-Gm-Gg: ASbGncsPtsmFhznnNusPMgaulJEc+YH/102USmXttOZNeNrRJLOnicbzqe3b7KhgfgZ
	uk8wfbaw1vXXe1jU0laVr9xaV41mEm8TiQGTWUy5VkkJ0uq09oYgXR0hO6inaulEMmtw23zHNGy
	VXbJAfbK4IyrYZ+K5X+HNNj/+V7JSAJ1Px+Upj8vybEgGLung9hYhN17uTSn+rauylcMe/bLtOV
	BW/VmgcEUlKd5vD
X-Google-Smtp-Source: AGHT+IENa5AGIFuVcHbre+a/L8J3WjIlVRfxGzMy9W5lbE7QXr2SDd/9GH/kk2ilXf1n4ePG0C3rZTZ7IKDT0LXZrMY=
X-Received: by 2002:a05:622a:4591:b0:4a8:eb0:c528 with SMTP id
 d75a77b69052e-4ae9e817721mr5765641cf.15.1753724243449; Mon, 28 Jul 2025
 10:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250728170950.2216966-1-surenb@google.com> <3f8c28f4-6935-4581-83ec-d3bc1e6c400e@suse.cz>
In-Reply-To: <3f8c28f4-6935-4581-83ec-d3bc1e6c400e@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 10:37:11 -0700
X-Gm-Features: Ac12FXybVm9KWjF_cAJM2oZct0U7vehd95FOiYr0FOaxIl4MJxcEbBTmA3eMfZ8
Message-ID: <CAJuCfpGZXGF_k_QVQqHWZpnypB-sWB8hwZeOYMOD0xmAFOBxkA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bgpkt7fe9muc1pieyphg9pj81unqutdm
X-Rspamd-Queue-Id: 25480A0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753724244-566404
X-HE-Meta: U2FsdGVkX1/qM9q2mEBnJVK/ShOZZMsVaJwCqsxr2K8InaCq9dY961osNySc6eaeD63H6wkF9onjBLEKY7al5HSccM4U0s8t6ZcTaHDbXsGssXJFmGG7YiTskZg1YFFVrcYbx8Zc56oAiE2rSHbWjRdAzPnnO8FASQN6RAxhU/X6a9P1ZLSGZHdNbOKe0uirKjx+I54Ge3VL1t7GSOC3BLrQB6Ss4j47ZmQnzgu4qlJe0vVHf8ZCYtQ/NSvHgSBLEZtkAA8HaRrVc2ZQzV79cvuYCbs9YiQofZuEEwE0yQuUkVII7D4n24a6+zZMPBhWBujdMHx6sisnwZvoM0PLkx8mdm/WR1309yStO/SJB6sMfgK825mzzye2V94xljKCPWrvEfJpWmG5lVgf/GxQzsVbNUNDKYy0TvoMrRt7UJt8q7B+prqKWX2ugA0hYrWQwcgVkuDOBayGoBln0JzuO2jRna8NpsHWE46/oimVxLCXUktJceCSHKO12uORYwbQiNyHbJ7zZXSW1csJG0IhmGZJ0zImf7E+1qhh53ywILyMkWkbCrsGI1TSPywlDbtPjw9nsfE6IgcPjwDm8T5QeCegCQwXgwULbaRqfwj6IF3SE7S+egRv0A0vmk1PGpUJpk9Ar5RcjO7dDwaOQCMB1EeVRxSE3+WRanJ3zWJfFyFGCsEdTUtT3o+418vXixSbE9Q5cTAt/7OZfi4LMsUVwb+y1rSTD9zw/IKeyVmdyAClIy00n+NO3VtjMTMKBcsdQb/6KyYKrHck83sLPcdeWUIwolCa/FU53AnvMeF+Lz4omWqOs211Z6mG2Rwc/Qi/RVOkBnxO+wP93dg0hRdsQo0JFvNUjpiFhmeOH7M91A4bb5BFi+Zq0Aolur/nVXiEStM9l/vaaDnVX2KnJwNTGwBSW7FNJ/GOrsfLmOa8gkUDmpprtgIskyU4N4YOcZvYbqSBT1PKAwGnQSLg4EA
 LWobl9rJ
 qmVDBVOLvbaOLH2UUdsYxRcYdyqYz3WvxEITEqrB5AT4hXZt1FJNse92Tv3gDejobCaqmX+KYngBhGmuJHgLO6wD9A9YUwlx8ZXI6xLa2A5jyM2L1ehY3Qj0QOlcCev1MdOikNSFVm9qaYzL9Vsi/vwAIZmg5Q/7jQB6GsF4d0ny4cfU1d20RbQ+GvNLLkDfv84aAoGRVRDa/ythoSCK281z3O0/QpWKbcAEkE+iQjAySWTRdQ/PToLSu3EP56wXzhkr0y2OBu62wxqCrxzcFdi7YDv9Kuqp47nyn3jSq/XDdKGjTi8MB5LKH3yw8NfkUwsxr4ocee1lo0PouxHkKKfAb7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:19=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 7/28/25 19:09, Suren Baghdasaryan wrote:
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
> > ---
> > - Applies cleanly over mm-unstable.
> > - Should be applied to 6.15 and 6.16 but these branches do not
> > have lock_next_vma() function, so the change in lock_next_vma() should =
be
> > skipped when applying to those branches.
> >
> >  include/linux/mmap_lock.h | 21 +++++++++++++++++++++
> >  mm/mmap_lock.c            | 10 +++-------
> >  2 files changed, 24 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 1f4f44951abe..4ee4ab835c41 100644
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
> > @@ -183,6 +184,26 @@ static inline struct vm_area_struct *vma_start_rea=
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
> > +             /*
> > +              * __mmdrop() is a heavy operation and we don't need RCU
> > +              * protection here. Release RCU lock during these operati=
ons.
> > +              */
> > +             rcu_read_unlock();
> > +             mmgrab(vma->vm_mm);
> > +             vma_refcount_put(vma);
>
> The vma can go away here.

No, the vma can't go away here because we are holding vm_refcnt. So,
the vma and its mm are stable up until vma_refcount_put() drops
vm_refcnt.

>
> > +             mmdrop(vma->vm_mm);
>
> So we need to copy the vma->vm_mm first?
>
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
> > +     if (unlikely(from_addr >=3D vma->vm_end))
> >               goto fallback_unlock;
> >
> >       /*
> >
> > base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
>

