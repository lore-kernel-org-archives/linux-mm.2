Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954C1C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B2F6B0095; Mon, 28 Jul 2025 13:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC716B0096; Mon, 28 Jul 2025 13:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3E66B0098; Mon, 28 Jul 2025 13:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 083E56B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:17:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 727FB133AD9
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:17:14 +0000 (UTC)
X-FDA: 83714329188.16.8803C52
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F7D6180015
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:17:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fzbsJWEf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753723032; a=rsa-sha256;
	cv=none;
	b=oBB2crb4SWYrZcRvFL7VO/9K1h0ymzryBKZxNe1UCQjPH1Nu9DWVNRCl8RkVJJdjVDUKxM
	7GYv/9a8XFJE5P9rZ6I7hO4QSszzVwcosf2qAw9Q+dzQoYe7NucjH9ZMNeNSV6tvFHbAVq
	lXDIcukce/J3AtZl/2tJqI/aLIKQ8ww=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fzbsJWEf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753723032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vKuqsMcT46hBPIeeydmoWyK22Wv2QkCzgzDxJHhBAg=;
	b=sGWHcroT5pbpYwtci1xCeoIigr2qXnOda0cPgg7mTJg7inWs9eVwYm5wHTkKs1bwAy/k18
	K/yqugOSNEjzzCvemroUr8Muqp3nXuhl9rksVSKLxkQ2B2mMKwadSfY1XJ3p3jq/Pt1Qh9
	TXkcHmijaV0zpgHACn5GgIdM29+qL90=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab86a29c98so17801cf.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753723031; x=1754327831; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2vKuqsMcT46hBPIeeydmoWyK22Wv2QkCzgzDxJHhBAg=;
        b=fzbsJWEfohQmKBX6Hpm6mTcKkyJa0RlMTtwwCK4vKwdhNLCmgsOVEkTr38JeVSQztS
         z3G/nvp7LtWOTdT0pUUzOcojvquxieBPOA/UT92/h1VTTSEJSTvEy2r4DrtRc5iy8XBq
         +dC2EDV59rGV+6H9fI6G7qKfBDogcKe3x8mz8W9aE4RygOPiMPg1Tr0KbgGf2PsouBEj
         ehJ9xCcfQUadR5v+6jDwX7gmZQokYb6X+NK08VwU1G44V/RIcj5hSMaju8gnPo3Y0KbC
         yV+wppu2+HqIr8Vwxu+3f3aK3CWnnN5ARJJsBMQVh7sevs63tj3S9k9jM2LMD58B73G+
         szdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753723031; x=1754327831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vKuqsMcT46hBPIeeydmoWyK22Wv2QkCzgzDxJHhBAg=;
        b=GY4xO2HjuntOok3jHZBNO/arY9sRK2Fu8ZlhfhGRSi5Y/45wUI3YjD3wog21V3PWqY
         2nX0XcZTNz0FSs1iznDUj9KKC6MVjL2/Au6XJ0ZCgwyHXc4yB/4oV4Z6Zat7tsFuVsXX
         AyIHXUUZWjYV26sR3EGRhpH778PH14sEGkz069H61En/PHYRmT6KL0Xro4Lw9ERF0v9U
         pdL7ypgsaJA8695fBFUqChbMOA9i8tu+kBAbPp6M6W7MxxIWnnG3mFh/wcNOgeBa2vEK
         2n2qbqqOARn8wIOWT8Bn1T21lidFYV55ByrkcWmHvJOOCGUFzDrvGH0rRI7+vK798m8K
         GEvw==
X-Forwarded-Encrypted: i=1; AJvYcCW3Sbv7Wyb58cIgX87oue6vAC/Lz1LsRjUV4dpZI8BCFgB/bMSL7Tf+nENIhcV2aZpvEqd1aAGA6g==@kvack.org
X-Gm-Message-State: AOJu0YwDq5YfWZHnKjowx+GKjk/dJz1EEX4EFphQWIMHH65VFKBO7CqE
	0aFPoo9ndnCizjZyjr5uDcxrQLIbOP/N4CQfbB1Par8NLW5TQyhB3hN/90jNcsSbENhKyY3rfCR
	c2OzltuhIvRw8wnpS3MmEgGz6l0zQspCLL8iirSQ1
X-Gm-Gg: ASbGncvUzQZ2BSS5Ic7gWjEc2wtYBb3CxSOAVymrTAOrHXDuuPi9pBAOmsr1n1poJ3N
	ZbpnE1nhiOuM6mxw8gTNnaEfdXaEwBiEWWGFSZ9lckFF8FowYGwysZium1YvdPwtepAK6bPSlcf
	xrD5fx8D6N9DmedkylkzVfeO9UoB3px77589Gbb8wp5r3PddjJoOKbs3FNAsRgXnVf0oT76KObL
	WdN+U5gDt8XQNxvv2ObD7ZDE8RElmMo0XvD3L3ucZb2IBJ9
X-Google-Smtp-Source: AGHT+IELxZqzgYWAQP9Ngohy4ApnkBo9oFMQtzvoZOAJ7yizj5sLIqWpkPtI4MboAEZl0uq5UgdDsHMj4GTXCTR/jaM=
X-Received: by 2002:a05:622a:148c:b0:4a7:e3b:50be with SMTP id
 d75a77b69052e-4ae9cc0b2f3mr8431311cf.16.1753723030772; Mon, 28 Jul 2025
 10:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250728170950.2216966-1-surenb@google.com>
In-Reply-To: <20250728170950.2216966-1-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 10:16:59 -0700
X-Gm-Features: Ac12FXx5Ajyiy-dotDY0A444StrFRdZUfUHPwsQH_l1PjmWS7zmm2-g_4bnZRTc
Message-ID: <CAJuCfpGDFcz0rTdnJx3UkSCDt3Ri-R55swZcqOoiLBbg8iF2zw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F7D6180015
X-Stat-Signature: 1awiozegexeyzeapkpoim559j8pxuzqw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753723032-103331
X-HE-Meta: U2FsdGVkX1+1cLhtE7S+hsObjFnhjfzsYGbiDQQuPRhd+YRhU20++PweZh9PRUMAmkjh9e1j+aZne8uyQ7rdBRek88uAMogsABa79NmIQeCDOWIfbJYtNPxwgeEN92hRXwBRJ9ntoT1OlT2zJohc6TubZeypdx+z6KuBWVR69WSFuMaeuOFFcRobTSNGmhS3MFget8trymrS1BZKyuD3T0hHNKgqhIslP66LtaJ6RWfxsk/ZC3NmUlNJp/xV77ZZRS5OgA9i1lDQLtqarsbfiTuQr9tKaU19kMtSwKn5CDR9V1slZ5W/l60WkEHzOuvfawCXe1b5AX2P7NDeUrfxz4DpYign1792sESXGMEiRBn3GwMGgqIA1xoPrh1mqPRh3HNhs7EfuShlA9IA6Q8jYxpQQByUv8KR0X4yrnBCjM76q5AOi0cYHVUtoebNAQqpICI5KWWmXEaoDWyy0I+ef4i6rplD5teQNw9ReMTO8fChGcWnBCodHseg9glkmbBqQ3Yt/9w2vZdKd0ZLordPa5HJt5R0RsoDElIpP/PccVu36p7vnrChqw5gGw7b2EfA3t1LQl7KhWq5rs26q07RtKJfqNstr2jEMFsHRE6uPmgG71w/Gv44sSX/It2z4dxdlKL6niOGGp/O3I/TqZJJJO8HGtWpf4Q81Qo67+9MqZCrzxqwBzTxN3C7/MzC6xLGZPx3XlpDqfraA6afjBkiwI4A+PxeeLUIlHEjpujGchyo3wGSEQgoxAJ5rl9a+WC5PWlMKXBWC18sY7B8ONvMe8YNwwNEooJxsi41mxTkPqQd0r3h1CAbSRBvvmE1FA8onrFBpPtvFuwSXKsstpC5ipwdP0pnUXKnyDLaLWEoGiCIeoypIYfkBX39UIrCFrXCZL+rO8I8DCNm/fm9ikMB+wd4WXjrdTHlwILjCcytcLbwv0z8Sph90DapTdzXumIU6RGY4JSXo/GjJb7jXqu
 4LILSpIA
 zzUwarc1iz3D5QfY8vVgGiBPzEvoa3n/6la+NeWaQKesUNykHfTvsw7QXDIaM8nmWLsCx9vGKP284M4yn2TAiyEWeIRRWyKVoa/HEh8htHf9vdRE9adhbn6zqVuLFKrHRrTbcx4oLrHCbcrVE8dzUAaai3D3LgufZFS2qABYaGAYHefGpSxK6pAU62Kb/mSyTVvHYe5sJmBg97NLfOEiotR+qkHWfHpVS8RKE0squd9vqXQy/b4TCjzh+A0lZn/pjYaUMUp5axmaJcZ1/zysGaYEiJzfh9w/7XhGqzf1bGXDL/0EhqHLhHnBEriVYtzA5aqJZoXMxgu6nI5gkqBBnrKlTUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:09=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> By inducing delays in the right places, Jann Horn created a reproducer
> for a hard to hit UAF issue that became possible after VMAs were allowed
> to be recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.
>
> Race description is borrowed from Jann's discovery report:
> lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> it can be recycled by another process. vma_start_read() then
> increments the vma->vm_refcnt (if it is in an acceptable range), and
> if this succeeds, vma_start_read() can return a recycled VMA.
>
> In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> will then detect the mismatching ->vm_mm pointer and drop the VMA
> through vma_end_read(), which calls vma_refcount_put().
> vma_refcount_put() drops the refcount and then calls rcuwait_wake_up()
> using a copy of vma->vm_mm. This is wrong: It implicitly assumes that
> the caller is keeping the VMA's mm alive, but in this scenario the caller
> has no relation to the VMA's mm, so the rcuwait_wake_up() can cause UAF.
>
> The diagram depicting the race:
> T1         T2         T3
> =3D=3D         =3D=3D         =3D=3D
> lock_vma_under_rcu
>   mas_walk
>           <VMA gets removed from mm>
>                       mmap
>                         <the same VMA is reallocated>
>   vma_start_read
>     __refcount_inc_not_zero_limited_acquire
>                       munmap
>                         __vma_enter_locked
>                           refcount_add_not_zero
>   vma_end_read
>     vma_refcount_put
>       __refcount_dec_and_test
>                           rcuwait_wait_event
>                             <finish operation>
>       rcuwait_wake_up [UAF]
>
> Note that rcuwait_wait_event() in T3 does not block because refcount
> was already dropped by T1. At this point T3 can exit and free the mm
> causing UAF in T1.
> To avoid this we move vma->vm_mm verification into vma_start_read() and
> grab vma->vm_mm to stabilize it before vma_refcount_put() operation.
>
> Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
> Reported-by: Jann Horn <jannh@google.com>
> Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=3DE3jbkWx=3DX3uVbd8nW=
eo6kbJPQ0KoUD+m2tA@mail.gmail.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org>
> ---
> - Applies cleanly over mm-unstable.
> - Should be applied to 6.15 and 6.16 but these branches do not
> have lock_next_vma() function, so the change in lock_next_vma() should be
> skipped when applying to those branches.

Andrew, if you would like me to post a separate patch for 6.15 and
6.16 please let me know. The merge conflict in those branches should
be trivial: just skip the change in lock_next_vma() which does not
exist in those branches.

>
>  include/linux/mmap_lock.h | 21 +++++++++++++++++++++
>  mm/mmap_lock.c            | 10 +++-------
>  2 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 1f4f44951abe..4ee4ab835c41 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
>  #include <linux/tracepoint-defs.h>
>  #include <linux/types.h>
>  #include <linux/cleanup.h>
> +#include <linux/sched/mm.h>
>
>  #define MMAP_LOCK_INITIALIZER(name) \
>         .mmap_lock =3D __RWSEM_INITIALIZER((name).mmap_lock),
> @@ -183,6 +184,26 @@ static inline struct vm_area_struct *vma_start_read(=
struct mm_struct *mm,
>         }
>
>         rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +
> +       /*
> +        * If vma got attached to another mm from under us, that mm is no=
t
> +        * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> +        * is dropped and before rcuwait_wake_up(mm) is called. Grab it b=
efore
> +        * releasing vma->vm_refcnt.
> +        */
> +       if (unlikely(vma->vm_mm !=3D mm)) {
> +               /*
> +                * __mmdrop() is a heavy operation and we don't need RCU
> +                * protection here. Release RCU lock during these operati=
ons.
> +                */
> +               rcu_read_unlock();
> +               mmgrab(vma->vm_mm);
> +               vma_refcount_put(vma);
> +               mmdrop(vma->vm_mm);
> +               rcu_read_lock();
> +               return NULL;
> +       }
> +
>         /*
>          * Overflow of vm_lock_seq/mm_lock_seq might produce false locked=
 result.
>          * False unlocked result is impossible because we modify and chec=
k
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 729fb7d0dd59..aa3bc42ecde0 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -164,8 +164,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_s=
truct *mm,
>          */
>
>         /* Check if the vma we locked is the right one. */
> -       if (unlikely(vma->vm_mm !=3D mm ||
> -                    address < vma->vm_start || address >=3D vma->vm_end)=
)
> +       if (unlikely(address < vma->vm_start || address >=3D vma->vm_end)=
)
>                 goto inval_end_read;
>
>         rcu_read_unlock();
> @@ -236,11 +235,8 @@ struct vm_area_struct *lock_next_vma(struct mm_struc=
t *mm,
>                 goto fallback;
>         }
>
> -       /*
> -        * Verify the vma we locked belongs to the same address space and=
 it's
> -        * not behind of the last search position.
> -        */
> -       if (unlikely(vma->vm_mm !=3D mm || from_addr >=3D vma->vm_end))
> +       /* Verify the vma is not behind of the last search position. */
> +       if (unlikely(from_addr >=3D vma->vm_end))
>                 goto fallback_unlock;
>
>         /*
>
> base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
> --
> 2.50.1.487.gc89ff58d15-goog
>

