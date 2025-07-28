Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4A2C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 22:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D14E6B0088; Mon, 28 Jul 2025 18:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0819E6B0089; Mon, 28 Jul 2025 18:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2A06B008A; Mon, 28 Jul 2025 18:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC8946B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:53:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C2918032F
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:53:55 +0000 (UTC)
X-FDA: 83715177630.19.2B6C910
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id A997240006
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:53:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hJfp5vRC;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753743233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4Qt12vqG6j3Vgncu41uP3H99WwAJYr2jwWzpmpk2jg=;
	b=XGZmynZ4LjsuFXfZZ8Me7dV7tViHpZz3hZs0WKsJM1seogNfPjtjmAYFTMXlZS1rcweav/
	Z5AEugN0eTq02FdTfFSR7AWx9d9YDSXV2dcBC4XjFixGdgnxvRNqVYaXqBaUTIXbo0lQW7
	dqvegnTmwUO4JIzooIP3tagVCR4u8J0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753743233; a=rsa-sha256;
	cv=none;
	b=jAt9ooKdAtH1q21Pj2avwi3QjyZG/bSXN1y6cPzdbdF5dc2HtWxwlBkliXg4N/KT0B4rZx
	2U9u25g6nPF3eKKGhF/Ay7GrpFGxRNMgFQQrY65pMzAXxOz+gvdglg6mIl4VPsaPv2KChp
	w3FqQ9aHFTjHApVsJ4kB5SjrnIfcjM8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hJfp5vRC;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3855fca3so68721cf.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753743233; x=1754348033; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4Qt12vqG6j3Vgncu41uP3H99WwAJYr2jwWzpmpk2jg=;
        b=hJfp5vRC5BdZ3Qo9uXkDXIBNNuq+T6NNVa9KFSqxVV+t2+UVS0EoA6vsT9skkEww8Y
         lAceT5vK1kyMdKYM07++pZ1toYBoGllQYU1sG0U3SpINThElhcuaftuKEKai5pTS61lV
         kf/zKd6rTPIZ4ch8rFU3K0qZS9rYRGawbSPz2gTpTBQoEtutlmgy7hE4Ho0Q2sAvC5qT
         azbkETz+iZTvhvrWOksAuWvCkuSe0X37STJIfn+9eq4+sW/yMrA9vWPH4NnOtUXSdz5N
         knjjx69RdygWJFAeSMqX+TOzA95tx1rmc72WyK76xTFY/7ug4Vxq/G1z71oluPLjPzIE
         5QgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753743233; x=1754348033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4Qt12vqG6j3Vgncu41uP3H99WwAJYr2jwWzpmpk2jg=;
        b=vBNyJjmYwY5lFUQD29MEkfeQucCFaSEpvmPn4h+ZmhbqCdIAEpiH7jlOz/DWa+vZ1o
         RwLe/TT3/EFcxXO8rFMTHWukOSRd6jbyHmvJM8cjaAN9rRjkCb0tEDVLDH8xi9+ybOOA
         AKrWKup1Sv1g53x2a4Vvn/xXyCSWQq1v5sfc5zdd2twXGFnZGYBB6v7hMJDmxwJhWBmw
         heBK0hEgzy+Ulf9bCiGgHXjz3jgsMADisHtqMcnZF1fGKxuCTBMd+9FD0bgW5psNIgRT
         MAbbc4x4ZEh7XxXDq0Kfuxt3LuR+FlBZ5tkaWmdUpkJlFHCYvnV5/RjOe1CX3D/DRv3e
         C+yg==
X-Forwarded-Encrypted: i=1; AJvYcCUqVJWGG2MfJrk5LOmwFvMpiXIJRUVvhRqspB5VJ0LY55mFlsRYJC1UnSh/HrZLz2M7FRHB7eon3g==@kvack.org
X-Gm-Message-State: AOJu0YwA82zcJaHlVDkL+TAyJUl5mPnNhPLQFmhUwh0MgDOdeuxct3pu
	u4FNvlpQwt/aoeis1Dt+nYfZE4AdMsfb4+35nrei05pIK1I/2Fiuoly8FRNjG5WcIi+yg3vz3Ef
	VDw+2uelBJYxqHMA3IbN7VKo1qIwriyfCw08F1OJ0
X-Gm-Gg: ASbGncsDEtbY74ExBwQtQ9cNJyJiwwbE1XVeXKtIiCvzgPbUT+A7TSLy+Yj6aryOqBX
	AcOeOJDw33r4cHcepcGWs2rqBI77XeFS9wVEsa4MaI/gAJsRBec12TKOl7R1jn2noxpovlXVGUC
	ntVFBLvhI0g//BDcHm9ZjrMT2uSc3T95mFwuUZHzv2xAImATxIQKLXwXfh1Uf2MjW9M37DMaqVt
	/Of7wN74NhTgyzrkG6lIs+NgCVn7v46gFvs+je8wngVsw==
X-Google-Smtp-Source: AGHT+IGATSooD8GgEjASGSXd3OgOeRWrGHiPgkXjO2g/J75z5wCxzzWlwo3yh3PbhmnWOhAg0GHBVwvm9kJx3eRxq08=
X-Received: by 2002:ac8:580b:0:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4aecda09537mr1715651cf.6.1753743232125; Mon, 28 Jul 2025
 15:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250728175355.2282375-1-surenb@google.com> <197389ce-9f42-4d6a-91c4-fce116e988b4@suse.cz>
In-Reply-To: <197389ce-9f42-4d6a-91c4-fce116e988b4@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 22:53:41 +0000
X-Gm-Features: Ac12FXzf7uyrUFgvW6_WolevPBj5eXWmthBTkEGcLn2Bxpz2kQtaKNbJdU9mnS4
Message-ID: <CAJuCfpFzxCayf083d35dS7Py0AK-CSr3H=_mymP9yXcyWzOqPQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A997240006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fwkr84fp6cpejamkb8moq41h36buobwf
X-HE-Tag: 1753743233-610954
X-HE-Meta: U2FsdGVkX1+ylEtHVdg7Pqm3hSbxIfL6XXj8m/5r86oY4+xOEnvVcWGYSaSrFIMfQYMKnOpsbZIv4+Uik1dmWoZl4CH5AepqYbrxAqZvZOaJ4qCAerYU+UYaXB8799khHWWQUZEySJS+wu10h5efwHlLcqoY6x+OOkN6FWxzSfZpzApzNCnv0ucLd3nU3/rf+QTCl6bYBRea4r7YzaPa9QkQNbcTsKiEbGU2dpLChqZkISV7ojmZ5IKP0oBXjj9z0DaVtqgHsf/NKB2Acokc/2FDSfwg7M+CIS0Y6j3TxDwsUW2kE1KK4//iUNsHSqyzEgYm1yZr07EiOct3pmP1q7P6plxL0G4FwPLnys2EqCIDnfqA2hpRO/yOziI3fyxWJmNHhghZFMgUKilu8mXXJcHNpeETJrY6odKDdvD0MRX5SljQnslM6MQ3ONSntO3c+zam+jtg9J/ikMJx+HWntmF5N7WRZkQdX+DVaWe7tKcA/Nw+jaxJaujBA3YoWAtYjIDoC4+N/HobPeDD8D0dRVcVcAs/Adv6M4G6PQiqX1EmdMhDVtM5kX77eU36QfzF1eUwuor20gNOuga065q2UKr2uz7rxNUuLcpbH7UUqCk3j2Y6H53eQcfTfC6OHteeGM1nTeL2NLJZfETE9gzS5ynrwINowGRt98l5gjJcD5Q44w1b/KRY/vD/v6oBcUQo83lAhigKIWfd38R6OlNELaTzBMyLIpwbXV8xFCwLr/dxujXHbkQZs+bUaZ2cWb2czomw/deZjUOMcxuHgQcvGkjShK/br9o0ECkr6g0uyJQfCH9LwWAoRQYtbJJqZp2ZAmLyBntFetLsxt95xWOTY4J3YmCrKJP/gu79HNdGaoI65nNXlpSjsC2+t+NB2jUByZQwZfmZv+yHuLgLeRCvlnkYW4PMid/2TObl2Gy1XqpG5JhrKMFo/yp/eswN8wMXB1gQJd8KX335TheV+bz
 Idwt3awX
 0FFUIZpjjE4MZZE09MmCSduL1HMSHrPCbcDW5ZJMkhlNwiWKFfVVF9128fU0fGuAuSvlZKsBjqyBrTU1yPXAPbLvH3mh94ZLxkThAc+tz8Qn5ZmFCNDKB1yFnBFtZQQFYNGFA360g+n4lOLgi2Wjz8g0/Q5O/DyUc7wiM7MM+8hLZ11l0cPY+SpRHzPfPSoHWyfGNXokdK/eCkj7g35RIwUgdPKYrXaavCF871d6fiT1ienX3zBs9JPAak/we32ZBYJ4sRaZ5GGkqgdDz6QfwBroetzAz3fHyh9GhEgL7AclHZru13I6moyOL8MeDviLgdG5dk/NT0FJQi6hG1JtspkKW2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:04=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 7/28/25 19:53, Suren Baghdasaryan wrote:
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
> As for further steps, considered replying to [1] but maybe it's better he=
re.
>
> As for a KISS fix including stable, great. Seems a nice improvement to
> actually handle "vma->vm_mm !=3D mm" in vma_start_read() like this - good=
 idea!
>
> Less great is that there's now a subtle assumption that some (but not all=
!)
> cases where vma_start_read() returns NULL imply that we dropped the rcu
> lock. And it doesn't matter as the callers abort or fallback to mmap sem
> anyway in that case. Hopefully we can improve that a bit.
>
> The idea of moving rcu lock and mas walk inside vma_start_read() is indee=
d
> busted with lock_next_vma(). The iterator difference could be perhaps sol=
ved
> by having lock_vma_under_rcu() set up its own one (instead of MA_STATE) i=
n a
> way that vma_next() would do the right thing for it. However there would
> still be the difference that lock_next_vma() expects we are already under
> rcu lock, and lock_vma_under_rcu() doesn't.
>
> So what we can perhaps do instead is move vma_start_read() to mm/mmap_loc=
k.c
> (no other users so why expose it in a header for potential misuse). And t=
hen
> indeed just make it drop rcu lock completely (and not reacquire) any time
> it's returning NULL, document that and adjust callers to that. I think it=
's
> less subtle than dropping and reacquring, and should simplify the error
> handling in the callers a bit.

Thanks for the suggestion. That was actually exactly one of the
options I was considering but I thought this dropping RCU schema would
still be uglier than dropping and reacquiring the RCU lock. If you
think otherwise I can make the change as you suggested for mm-unstable
and keep this original change for stable only. Should I do that?

>
> [1]
> https://lore.kernel.org/all/CAJuCfpEMhGe_eZuFm__4CDstM9%3DOG2kTUTziNL-f%3=
DM3BYQor2A@mail.gmail.com/
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
> > +             /*
> > +              * __mmdrop() is a heavy operation and we don't need RCU
> > +              * protection here. Release RCU lock during these operati=
ons.
> > +              */
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
> > +     if (unlikely(from_addr >=3D vma->vm_end))
> >               goto fallback_unlock;
> >
> >       /*
> >
> > base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
>

