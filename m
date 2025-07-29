Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144C8C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96506B0095; Tue, 29 Jul 2025 10:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DD66B0096; Tue, 29 Jul 2025 10:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984496B0099; Tue, 29 Jul 2025 10:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8675D6B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:31:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4393512C8D5
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:31:25 +0000 (UTC)
X-FDA: 83717540130.24.B60223A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D62F4000F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:31:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wrgIk6RN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753799483; a=rsa-sha256;
	cv=none;
	b=Jris6ju5QBcjDxKf29tjadkI5sT93pQJEhDW14udGPt3l79+AI7G/WG9K9xbBBlKTEjeWz
	PMO7VErP29YTvXuDhECU2ECS9dL2tZw4R3z/ykVk+CMrWJzftYE2SLitPs7qIlQ9DNhSwX
	bOtDW1VJ6D9vBUX7HzydVP/JNy1yB4M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wrgIk6RN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753799483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ElbbAul9DmjYMfnPC5TQkAxMKcYjjk3KRBzaYjpxjg=;
	b=pKPAL9v2QVRVjTbyd3iJDHWYG40ozzxQ6JubLGMo7mu3ZHQ874aiv58jfvEGSqWcqdWapb
	xHh/gsCEN2GmkErzEBBX6QK+2IIuXhQFdB/y/4sL9LQuH8PJXq+JHewB4dLEimJUl4QOwo
	qPT/8UsJzvJs12df6rpEIGf3MaPW8bA=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab86a29c98so295011cf.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753799482; x=1754404282; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ElbbAul9DmjYMfnPC5TQkAxMKcYjjk3KRBzaYjpxjg=;
        b=wrgIk6RN4cTFq/FYaZEIerVyRJut1CkkbJd9fAqJ9GvOqi+R6zK9tA0vvHyK1OkwOK
         3dkF1CpKFQpMvlEcal4MX90XsbFvPanTCt0x1LfkGJS2wlHG7XVJMh54B5SNdnTqgnF9
         yG49xQyhwQiuFgQIfArHuef9d6y4pkefIKV40dFmvH6LaBDIGwlaA68BbTngy8wn352T
         dpX0uCUI+r5l4Y7o2rkvd4v2jUzu9KzE0lXbVAJPyh/cylPOBc4EQ3st/rIEhEp7Kh9R
         zzPIEZe61Z2BXlj6tDo0GXlLMDI45SB3O6MZkDuevzEnJo6L+1NYZpPuSDXTydWK0grJ
         D6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753799482; x=1754404282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ElbbAul9DmjYMfnPC5TQkAxMKcYjjk3KRBzaYjpxjg=;
        b=o2ob9ZAN4P5NYqljkX8e22+7sZAn1leqyC4TOvcyz1bCk8umJSfZWW/6uYgL8WWD1d
         mMGgVzKwO4H/+Kct5Lqa24aIIldpb9QPFZF0xKA3nDkH8HZrGMfIMvllw6POp82N5/YT
         svCG5z55ruYfSTVq2gwaWxGJqXCgSm7tsW9FORco1EWzG8/HcaanNuodWNyCllGCfb0u
         45wZFU1+ypASbgcllVRv7qo9DFo1ZstgTHoiGqPDXFXwtd8aSHwbwBD+vwbety+bjOuk
         dIexCwnA+MaEIHY6CqF9KVMZZzmRlRP4m/mmBAd+JttR2vcSY4Ykda58vCcts8gsFWwE
         EHiA==
X-Forwarded-Encrypted: i=1; AJvYcCU4j4NKE3E2Bc6o46G57l4hknv8KZ48a1nxN9VYARoIeCVZ4D5p0dSPX6RwZpiIgWU4mkOgBX9xSw==@kvack.org
X-Gm-Message-State: AOJu0YxYjcEIk9SFeK38opTuz2TZ2oCk8lNyrOfeVf/eC8zzYk3joleF
	75w74gTzNeesJh1rF/uqSvB2xGjfmSkd4VZuo00ZQf2uI2nOf4qNTf9e49vTRJsG+RBUPNL+RJ6
	6CyTdc0R/kZqv43P2CfQ9a3YW5oc8t+V827AOeWuqxAuUYEvxnRFYE3ZfEPY=
X-Gm-Gg: ASbGncvGgFqh7xlo19dGq35KHPr5XxKrV6aHZ4n7lOF9hsy8IkB1urhNKoqaLeN+/9P
	TjhoIpvR85h0+zbPl1Ku8Zj/OsdUnWKIk9PwdsWMej4uRYQET5YzFVRlDa5iWV6tmuEmCJBu6z+
	aNNEdK3nj3cOK2vdNr3YdLvLfKqaJGGHaCxJ7kPAMrTuEh+YaopKEbUSCiQPxj2i5nfyYgRgxWj
	4GQ6jFi8agpp9nKASrCLZHf/gwAoRgf2qZi3w==
X-Google-Smtp-Source: AGHT+IGdl6AXgbdWoLsOYvwIWq5+uqEWUkN6UVFuEEGPrB/FwqSld5ISLVkEnPjv1C4r9M89ETi4WKoVgF6yNVc3La0=
X-Received: by 2002:ac8:580b:0:b0:4a8:ea8:67e with SMTP id d75a77b69052e-4aecda096e6mr5199861cf.2.1753799481979;
 Tue, 29 Jul 2025 07:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250728175355.2282375-1-surenb@google.com> <197389ce-9f42-4d6a-91c4-fce116e988b4@suse.cz>
 <CAJuCfpFzxCayf083d35dS7Py0AK-CSr3H=_mymP9yXcyWzOqPQ@mail.gmail.com> <717f1f43-3ec0-41a7-b0a9-05383a4325d4@suse.cz>
In-Reply-To: <717f1f43-3ec0-41a7-b0a9-05383a4325d4@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 29 Jul 2025 07:31:10 -0700
X-Gm-Features: Ac12FXz_KOV-YfOYg-xXhwzGmtvp7EhVOk939edJ822ZJfzo6Pfs3_KFmp6ytRc
Message-ID: <CAJuCfpEHCt0pczKG_W8X-e+Mi9yFMRpTeQRRS31Xq4fNfaFQ5g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b6ykiwbidq73yw3jtdp918s47whf96xt
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D62F4000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1753799483-914115
X-HE-Meta: U2FsdGVkX1/dgqV+ZmkxDo4QY5PPRD/KGPQWVaaX3Oa1VOKLuSAMBM3G+CsRCr9F3EYS4I0jQ4A4c2iCsY02ClLeXSsS9r1qAkfUbBNIsSQda85vJJkGhcK671NTHC+XlI4+8PRg8MgUd+xzVMc/nPwkVJN7/c9YXxcbLbn65LwCx0GmBMOby2gYGqeGjTYW2+ogHLT2fyMF1rbuObCc9BULE02xkg908GS92vWCZIrd7LV1BOtOcJyDyJfVBCLaBjstYZfJLvi6UJ/N9WPRnfu1p24SJBMxh59zOSbC/a0E+tQDP15/09DJ3HOMNkU4DyDYKFO0aW8nEkcDq0RTriGpMXnNJVkw0gj5RfIRvS7AVn0ZvQk0r4mJSuLUsz6nTHLHccXZSxE2llKjBVFv/7000AfNNV4+nZEyI8nnEZSwgQhtpDdSnya3yzAYxkjufdWmIzn6WitI8deB11g6gHxHFD2aaNm6cjtv/ok1RS1O/XowpBf+mn/WlvXngqFtbh7xo6r3EOIxqpMOJED+cUMZRctmTLzICV1U/lhQ9HOHENT4SmWen4nYCQogYOMeXHheSBTxkBDsOsD/3x2fXhMRsgy/NuA8BLBJoqroOtBzODh6cIZ//YFU+Owgo4OI9/ND+ufgXX7cKm1gEZVsZWWRR8Z7fhVy3QTXk44IS+avfj24e39KYfUEvsjYLmFAOTf1A53YXWFBBADI2F4iqCRzpmgJ1NYTWj5ansBw2Xn7WwFYs45l2G+5SrQ3kX7tdppel9ITuG3KSkMO/WbFtlbJQzXi2bs10N1gdu0htXC4+hMmCkImeNNfItSruHuLdzifhacVdUJaGD1FAf7LjPHstOHdeCL/1nWuMnmmAvFLOVnZHxubvzxzP6p/Iy5ow/5xxrr5hHjV15byc7VF4hrrBu7azqvGgT6yxk9MkFFBaoXk2TvGLPg9P8IK8aAUDmMekGjgI3IBImHRSmi
 TvmS+cpp
 hSY08ONvVwVj0mrg3h7boPJLufn2tL7VspeR5K6RRXPEeMCKVjGjO15FVD7u+Oo3TMcSlImm/Nkw6NuoOFHw53sqILDCdHzgComWoIkDcYssal5sPgOrwv2rkF9JS9obNuhih6ijUReU6yeQP9eBfCTTSFhqSWOG5fJKGrb2DaW7pFDRTPwOtHVz9Lc1UbfmL0ZkZXdgDo96F4lKaUPejHJCpYRnWq2lxYm/NWe63xguchzGAXcGUFFSTBskhv/ZILeMqPPdsqPiUJ9dp/0VPUdpIcrthEDug/nJ28WEQ0vQJH2vGKTEiK8rMOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 5:03=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 7/29/25 00:53, Suren Baghdasaryan wrote:
> > On Mon, Jul 28, 2025 at 10:04=E2=80=AFPM Vlastimil Babka <vbabka@suse.c=
z> wrote:
> >>
> >> As for further steps, considered replying to [1] but maybe it's better=
 here.
> >>
> >> As for a KISS fix including stable, great. Seems a nice improvement to
> >> actually handle "vma->vm_mm !=3D mm" in vma_start_read() like this - g=
ood idea!
> >>
> >> Less great is that there's now a subtle assumption that some (but not =
all!)
> >> cases where vma_start_read() returns NULL imply that we dropped the rc=
u
> >> lock. And it doesn't matter as the callers abort or fallback to mmap s=
em
> >> anyway in that case. Hopefully we can improve that a bit.
> >>
> >> The idea of moving rcu lock and mas walk inside vma_start_read() is in=
deed
> >> busted with lock_next_vma(). The iterator difference could be perhaps =
solved
> >> by having lock_vma_under_rcu() set up its own one (instead of MA_STATE=
) in a
> >> way that vma_next() would do the right thing for it. However there wou=
ld
> >> still be the difference that lock_next_vma() expects we are already un=
der
> >> rcu lock, and lock_vma_under_rcu() doesn't.
> >>
> >> So what we can perhaps do instead is move vma_start_read() to mm/mmap_=
lock.c
> >> (no other users so why expose it in a header for potential misuse). An=
d then
> >> indeed just make it drop rcu lock completely (and not reacquire) any t=
ime
> >> it's returning NULL, document that and adjust callers to that. I think=
 it's
> >> less subtle than dropping and reacquring, and should simplify the erro=
r
> >> handling in the callers a bit.
> >
> > Thanks for the suggestion. That was actually exactly one of the
> > options I was considering but I thought this dropping RCU schema would
> > still be uglier than dropping and reacquiring the RCU lock. If you
> > think otherwise I can make the change as you suggested for mm-unstable
> > and keep this original change for stable only. Should I do that?
>
> If we decide anything, I would do it as a cleanup on top of the fix that
> will now go to mainline and then stable. We don't want to deviate for sta=
ble
> unnecessarily (removing an extraneous hunk in stable backport is fine).

Good point. I'll do the refactoring on top of this fix and that one
does not need to go into stable branch.

>
> As for which case is uglier, I don't know really. Dropping and reacquirin=
g
> rcy lock in very rare cases, leading to even rarer situations where it wo=
uld
> cause an issue, seems more dangerous to me than just dropping everytime w=
e
> return NULL for any of the reasons, which is hopefully less rare and an
> error such as caller trying to drop rcu lock again will blow up immediate=
ly.
> Maybe others have opinions...

Yeah, you are probably right. It would be more explicit that the VMA
can't be used after a failed vma_start_read() if vma_start_read() were
to always drop RCU on exit. Either way I think I should add a big fat
warning to vma_start_read() comment that the VMA passed to
vma_start_read() can't be used if this function fails to lock it. I'll
post a v3 with that comment added and Lorenzo's nits addressed, then
I'll prepare a refactoring patchset for mm-unstable to drop RCU upon
vma_start_read() exit.

>
> >>
> >> [1]
> >> https://lore.kernel.org/all/CAJuCfpEMhGe_eZuFm__4CDstM9%3DOG2kTUTziNL-=
f%3DM3BYQor2A@mail.gmail.com/
> >>
> >> > ---
> >> > Changes since v1 [1]
> >> > - Made a copy of vma->mm before using it in vma_start_read(),
> >> > per Vlastimil Babka
> >> >
> >> > Notes:
> >> > - Applies cleanly over mm-unstable.
> >> > - Should be applied to 6.15 and 6.16 but these branches do not
> >> > have lock_next_vma() function, so the change in lock_next_vma() shou=
ld be
> >> > skipped when applying to those branches.
> >> >
> >> > [1] https://lore.kernel.org/all/20250728170950.2216966-1-surenb@goog=
le.com/
> >> >
> >> >  include/linux/mmap_lock.h | 23 +++++++++++++++++++++++
> >> >  mm/mmap_lock.c            | 10 +++-------
> >> >  2 files changed, 26 insertions(+), 7 deletions(-)
> >> >
> >> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> >> > index 1f4f44951abe..da34afa2f8ef 100644
> >> > --- a/include/linux/mmap_lock.h
> >> > +++ b/include/linux/mmap_lock.h
> >> > @@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
> >> >  #include <linux/tracepoint-defs.h>
> >> >  #include <linux/types.h>
> >> >  #include <linux/cleanup.h>
> >> > +#include <linux/sched/mm.h>
> >> >
> >> >  #define MMAP_LOCK_INITIALIZER(name) \
> >> >       .mmap_lock =3D __RWSEM_INITIALIZER((name).mmap_lock),
> >> > @@ -183,6 +184,28 @@ static inline struct vm_area_struct *vma_start_=
read(struct mm_struct *mm,
> >> >       }
> >> >
> >> >       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> >> > +
> >> > +     /*
> >> > +      * If vma got attached to another mm from under us, that mm is=
 not
> >> > +      * stable and can be freed in the narrow window after vma->vm_=
refcnt
> >> > +      * is dropped and before rcuwait_wake_up(mm) is called. Grab i=
t before
> >> > +      * releasing vma->vm_refcnt.
> >> > +      */
> >> > +     if (unlikely(vma->vm_mm !=3D mm)) {
> >> > +             /* Use a copy of vm_mm in case vma is freed after we d=
rop vm_refcnt */
> >> > +             struct mm_struct *other_mm =3D vma->vm_mm;
> >> > +             /*
> >> > +              * __mmdrop() is a heavy operation and we don't need R=
CU
> >> > +              * protection here. Release RCU lock during these oper=
ations.
> >> > +              */
> >> > +             rcu_read_unlock();
> >> > +             mmgrab(other_mm);
> >> > +             vma_refcount_put(vma);
> >> > +             mmdrop(other_mm);
> >> > +             rcu_read_lock();
> >> > +             return NULL;
> >> > +     }
> >> > +
> >> >       /*
> >> >        * Overflow of vm_lock_seq/mm_lock_seq might produce false loc=
ked result.
> >> >        * False unlocked result is impossible because we modify and c=
heck
> >> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> >> > index 729fb7d0dd59..aa3bc42ecde0 100644
> >> > --- a/mm/mmap_lock.c
> >> > +++ b/mm/mmap_lock.c
> >> > @@ -164,8 +164,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct=
 mm_struct *mm,
> >> >        */
> >> >
> >> >       /* Check if the vma we locked is the right one. */
> >> > -     if (unlikely(vma->vm_mm !=3D mm ||
> >> > -                  address < vma->vm_start || address >=3D vma->vm_e=
nd))
> >> > +     if (unlikely(address < vma->vm_start || address >=3D vma->vm_e=
nd))
> >> >               goto inval_end_read;
> >> >
> >> >       rcu_read_unlock();
> >> > @@ -236,11 +235,8 @@ struct vm_area_struct *lock_next_vma(struct mm_=
struct *mm,
> >> >               goto fallback;
> >> >       }
> >> >
> >> > -     /*
> >> > -      * Verify the vma we locked belongs to the same address space =
and it's
> >> > -      * not behind of the last search position.
> >> > -      */
> >> > -     if (unlikely(vma->vm_mm !=3D mm || from_addr >=3D vma->vm_end)=
)
> >> > +     /* Verify the vma is not behind of the last search position. *=
/
> >> > +     if (unlikely(from_addr >=3D vma->vm_end))
> >> >               goto fallback_unlock;
> >> >
> >> >       /*
> >> >
> >> > base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509
> >>
>

