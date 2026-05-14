Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E65CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2464E6B0088; Wed, 13 May 2026 20:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6C66B008A; Wed, 13 May 2026 20:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5876B008C; Wed, 13 May 2026 20:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1AA86B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:47:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 812D3402FD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:47:40 +0000 (UTC)
X-FDA: 84764187480.22.4DAC487
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92209A000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:47:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PRZE5A/S";
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778719658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6ZowgjF+P+8NRaNNYYkx/QLM7LILhRAI2BNl2woims=;
	b=A0E2eZvCT5uiI8Ym14S4sZR6cNnCqIkyiC9O29VEkyy/sg0Cm4OjRE2eOS5lFGPK9vxju5
	wDbY5x5ewgHtIBYX9muwHFmDIaB4CXLznOQcDmacaYwo/bbxZyfM0Ahq5nKd0kb49vl/IR
	F/Jm+0Tn59GihhAXDf01kd5wUcoitpY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778719658; a=rsa-sha256;
	cv=pass;
	b=hyxK34HO7UoMgORrrn1DPDCqcoCVBf3nYMZwVwgfWhDkQq+bnN985gGGPJlXrecROJFP9N
	m0KiWfyTbuZ530z5MbkGRSwgFMmEpQmuKPGczRwcgt2CL11NeccdNDvzou1iBxOzPb/3Yo
	w8GAhqpULvbWLNSzLDORpBFLEXTxEds=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PRZE5A/S";
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d6b393d60so163591cf.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 17:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778719657; cv=none;
        d=google.com; s=arc-20240605;
        b=JighqYJVYBsMlRUDwmyZQ8MbcAbDQBguKdpbKCpWZmf9x9k3HS2iv/AxZYshb590Gx
         p9LEjJXDXPHz8bqJX6RVdMYQ3OtjJtTSvsj4yrdBbK7bFW/abgjYCQPUp52Hnx8rq09V
         Rj1R8KJ2nc9+P0AR8pj13J58hKhRJbueVfJ61Y/ckm+/IUB4dur6bianc2+riSaOpw/k
         ELusaPwpqlLS5BXSvowvOReVYTAwqvIqpHWtgBJme3J3mvtGtr+CYqK84cHgbZcLqPL0
         RiLwq73sUW9s54ZazlGSCIlZVGv/TgKf+wn8XPdXzCczleUB4zBcZpyLBvVszvfnRPLM
         heyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k6ZowgjF+P+8NRaNNYYkx/QLM7LILhRAI2BNl2woims=;
        fh=4FdaQqBd+8EupU9FdXdzhgZ4nxK5ZGi8LNXEiUi9Ipg=;
        b=EBmcoeaHuVW4SliM/F0r7vxcJNuCkOui8akz6naVO2ObTkTNqGaxzYfKSVCQnawQ+3
         fgOlV3mcFv0F0BNSjyKK5YfcNOZH0Q09T8reCw86OwqNnX8QLiHAfKPDM5RJXRRGjr2K
         zIU5H0VVyo235FCx1aeoBFFWgxarhDCqTa+86I01ui/zCTZg/Ft3KkU9QZ7Wr6lPNW9d
         yvByZNiTSbUw72AYp95Mah+mmQ5M0IEDWMkfEiTsmSFmkvv8PFnddoD30FJ3p/qNmXQB
         /3D9qPBE1jA3/nT2CuCh9z7Gqz6BZZo3UO56ScJjm1BIRzsoBApwAcb0bEp/MQCHW5sX
         fjYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778719657; x=1779324457; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6ZowgjF+P+8NRaNNYYkx/QLM7LILhRAI2BNl2woims=;
        b=PRZE5A/SPBsBZVfZEnmtH5d1eG9XxIh730OZioEUrPMm9wply3qJ6A6xPx2N3+ZuL+
         rikmx1327EoJXQj1CM/oUB2v5RJb8T42mqf9syqOmBgHQRnwDVo7lsLtFD70KxWYTFTq
         Zh4KJNeClF4jzJV+RuGBj8KPNkEHI32OCFjguUbMQiRBSsGigJeLMoRI7cTJaUyXTQ3q
         X1FfXeQMjrQQz/0ZyJ2YK1jjONFFf5cha16uQJb0qmd5XDCdLh5QAB9Cpc+mi5b1nWgV
         xQq3HdSSnXGMw3pdnuz0+EhZcJ0MgtAUiG8rrMctwMQrwf+BHrqwvWsjA3InVgnVDcry
         bg7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778719657; x=1779324457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k6ZowgjF+P+8NRaNNYYkx/QLM7LILhRAI2BNl2woims=;
        b=WFeUzzjbyTskyPpQAXpcBM7H7OBlrh7zv8zeLNh9Esp7ogB4+hNj0qQiWUKsAQh4+w
         Mn2ozqeTGDyAQoO4zoosFR0HrPv+Dvz7LT3/Z60BgKQkUXT352SxvC1pYLhoF9o2/mR/
         CKe6sVFtBV37tyhPGYFYb9dAgnkfRko1Dv5NeCwHb1Xtgi6qJBNCe7NI72zgyIQFBSWT
         twx0yIg/1MnTPG1TKvB0lURzjseMDDZScuaoNvXYAOT5EHff9/FSDUOl35ZM4RiOuxm2
         Vujwomq/xsXQ/QibvPYLVpy+O5L4xKszvPjDVrjVTon+63vOAQYWETwzTSkX/XSqns2z
         dSfw==
X-Forwarded-Encrypted: i=1; AFNElJ/2bmqAL/rpXUsURR9Ydm0lo0pZwLAkD+f1vmwzSkM1k/p44XMXRuzf1DgQt/WKuZ4Qt064N+HNSg==@kvack.org
X-Gm-Message-State: AOJu0YzEXwdFn6W89TsG7wLw1c4M1TjUZkrDOVvQWpYhLa63NMhTrea/
	/ns7ae2Q6BiTyOSt3hGpLMaV8q126dBEon2lpJJpIvjMBtvENUQdEbGQFIaM7rlLgP5uS998i1T
	7AXw3f4lX6ZRU8zSB6OT3tXdUr5ERVzaDem6UUBr/
X-Gm-Gg: Acq92OH2cnMyGpNmY3OMjmeH6j9dTpaNWnS1U9N/2BRB9lKzs45YLDIVS7hUUfXecOl
	0H4mn5MjNjUF1L0nipuXTKbM0LhL7VKgwR8iknXleHPnS84qrK0CgbdVVlcl9jvTCh9C7H/Ct5c
	7GKKRk6306ACo7YnHoqmJZKJ9TUSnV/PqurcdbCaYgxGRMQG/3axfdWBAU2zsSEOUZ7dc89ITU1
	ozO897Zq9MdVvbLub9NLqylLtFBcGQkFNbcU8/owOM8ySgiI0yEFOp6QQ3tXqR+2mfEKyuz2UzE
	NnkARpMIxS5vYTg5
X-Received: by 2002:a05:622a:9d8:10b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-516423230admr3206141cf.12.1778719657060; Wed, 13 May 2026
 17:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429181959.BC9DABC5@davehans-spike.ostc.intel.com> <af4Zx0gJIWbdDeY2@lucifer>
In-Reply-To: <af4Zx0gJIWbdDeY2@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 17:47:25 -0700
X-Gm-Features: AVHnY4LEZzSiNX91WMwuAMNuW8RrRL823RecrSud8fqgZfb8dRiXaR89NuKI6UA
Message-ID: <CAJuCfpE=8PTy+FzfSph583=qZEgb5Xi7evuiTCT=8iQh=bW2rg@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm: Add RCU-based VMA lookup that waits for writers
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92209A000B
X-Stat-Signature: ogqgtitep3m37f41ijibsup1ou5hmzfp
X-Rspam-User: 
X-HE-Tag: 1778719658-302532
X-HE-Meta: U2FsdGVkX1+mTMNnXuo1S86/SG/Y5BxOttHz2q3BLcZLo6Q5UG6j0AEH6fnD4ZaUisW2UTUDdWTcqImehuxW42rk9jaOHYUULGt46Q/yPol/DmgNWR9ihXCifzIPMd4aAmF9yc5u/ehlwQcQDa2FmnlmEdpl7c5pWckw9HBoAn/rIVNE6G2ijMcU/9sPLEXU0lWdTBb9F8UCpBQY6TWfn/EZfNkvHyO3baTDy9SUE9MdkbSArUZelk6cMzyJ+Yjkz8mHN3IKeZn8KmSe3cmO3t4o2ymc6czxHFVLH0lM8P/1/ITmiWGlIgIdtc+W9iQ3X+4J9SWpHfJAPkXPC3OLulIWHfvbkGJaqD7bevskOysyq3CXNMwjHQDZa9w1NvfxOIfhXxEm7FUCjRCyT+4DPDvHZQ3RvZhhNy8IUIciwvsDuVJynB8Xba8Lg4N1UxgkIoAT2qQHKUxWcEm++1O4JONU0EpDOWCDmTI9OhspgbLY4U6fwEL2j3Jw7+jnzUo5+uVF4ttP3gPXYYtS0cMbo7yC9w/DeJmCBo5+ybc8QfLUdn9DJZ8mpEonCBol1Mkz2LxjV2e/3C9lKHlzNleK/PEO5o8RZmCZ5OVAqsT0yOruUZ+gBSxw38aur5k+g7qG7Abfh5TXNyRJOTpCUfgvE5U1r59u0iT93ElKoj4XCwRf4pRRpyMNuBW/K5VINobKAUCgvOohZIcFvhKHISdoJZaG4ECdwTgvsvd2JCZeE6QpMttX1B1xywfTMGTvTHKlK+MdgWEYS3fk4j0lSyeAc1enNpQiq3FtLBcQVwxF6IURCorBBdC74LhCi2TsoCgd8jARXSIR38WWtnnlpsmCjcM+Y9kG0VDiiXWfy7D3n+eQDJR5bREoYyPySXvUKCurghvPMrVaWprzXDe53iQ+ktVBZQ9pT+rmEr2e4SxixLhLoCo8glERiz6XH9KqQt24uIUBcfujqdCyeCsJn9E
 C6fD/C2H
 pf/6gRL4rTJpXPxtBUP1Dch/tClBhwiTT6Z8EhSaf0dDiMnfp7Gbw4My3FVrlLGX5cBGpBolu127C6LqTVdIc3eVzUqQdj8GysnDAC3yO4aSGDyfzFB3cNKkiMvC7U8U4rheb1oaJM3OV0Lybg8n3b0RXDZK6dQFMC96tNZkBu8ychYIQ8RwatDKhe3az1gAcard+jcH1OicibySjQayN9Zbg9z5++u3iZnwoo7A5VmITAKfEKg+FuYzIbsnrKcQGJpASAciysXd5DNlYnw6xkZUCPwEJ4sslFbI8Hz5ZwJUA6XHndP9HC1FMXquTYu/cM4SoPjF1IwEx8n5jV/CxtagSXB3JjeFEyXyhGsRO+zEdwBoCJyOw1EVLnv5BCYwPOmZvBlioCtWolAUbCCOoUvkI4mG64FQTdkgiE8OtV/dfPHakrVe3wTgZRRd1rAioMsOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 8, 2026 at 10:26=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 29, 2026 at 11:19:59AM -0700, Dave Hansen wrote:
> >
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > =3D=3D Background =3D=3D
> >
> > There are basically two parallel ways to look up a VMA: the
> > traditional way, which is protected by mmap_lock, and the RCU-based
> > per-VMA lock way which is based on RCU and refcounts.
> >
> > =3D=3D Problems =3D=3D
> >
> > The mmap_lock one is more straightforward to use but it has a big
> > disadvantage in that it can not be mixed with page faults since those
> > can take mmap_lock for read.

Hmm. You can take mmap_read_lock and execute VMA lookup without
blocking page faults. It's the mmap_write_lock that would interfere
with page faults but you don't need a write lock for a lookup.
The disadvantage of using mmap_lock is that you will block (or wait
for) all other writers even if they want to modify VMAs unrelated to
your VMA.

Reading this problem statement I'm still unclear what the problem is
and the fact that the helper function is not yet used is not
helping... Hopefully in the later patches where it's used I can find
the clues.

> >
> > The RCU one can be mixed with faults, but it is not available in all
> > configs, so all RCU users need to be able to fall back to the
> > traditional way.
> >
> > =3D=3D Solution =3D=3D
> >
> > Add a variant of the RCU-based lookup that waits for writers. This is
> > basically the same as the existing RCU-based lookup, but it also takes
> > mmap_lock for read and waits for writers to finish before returning
> > the VMA. This has two big advantages:
> >
> >  1. Callers do not need to have a fallback path for when they
> >     collide with writers.
> >  2. It can be used in contexts where page faults can happen because
> >     it can take the mmap_lock for read but never *holds* it.
> >
> > =3D=3D Discussion =3D=3D
> >
> > I am not married to the naming here at all. Naming suggestions would
> > be much appreciated.
> >
> > This basically uses mmap_lock to wait for writers, nothing else. The
> > VMA is obviously stable under mmap_read_lock() and the code _can_
> > likely take advantage of that and possibly even remove the goto. For
> > instance, it could (probably) bump the VMA refcount and exclude future
> > writers. That would eliminate the goto.
> >
> > But the approach as-is is probably the smallest line count and
> > arguably the simplest approach. It is a good place to start a
> > conversation if nothing else.

This idea is totally sane and we already have something very similar
in the form of uffd_lock_vma(). I would suggest using it as an
example.

> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > ---
> >
> >  b/include/linux/mmap_lock.h |    2 ++
> >  b/mm/mmap_lock.c            |   43 +++++++++++++++++++++++++++++++++++=
++++++++
> >  2 files changed, 45 insertions(+)
> >
> > diff -puN include/linux/mmap_lock.h~lock-vma-under-rcu-wait include/lin=
ux/mmap_lock.h
> > --- a/include/linux/mmap_lock.h~lock-vma-under-rcu-wait       2026-04-2=
9 11:18:50.633628887 -0700
> > +++ b/include/linux/mmap_lock.h       2026-04-29 11:18:50.707631737 -07=
00
> > @@ -470,6 +470,8 @@ static inline void vma_mark_detached(str
> >
> >  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
> >                                         unsigned long address);
> > +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> > +                                       unsigned long address);
> >
> >  /*
> >   * Locks next vma pointed by the iterator. Confirms the locked vma has=
 not
> > diff -puN mm/mmap_lock.c~lock-vma-under-rcu-wait mm/mmap_lock.c
> > --- a/mm/mmap_lock.c~lock-vma-under-rcu-wait  2026-04-29 11:18:50.70463=
1622 -0700
> > +++ b/mm/mmap_lock.c  2026-04-29 11:18:50.707631737 -0700
> > @@ -340,6 +340,49 @@ inval:
> >       return NULL;
> >  }
> >
> > +/*
> > + * Find the VMA covering 'address' and lock it for reading. Waits for =
writers to
> > + * finish if the VMA is being modified. Returns NULL if there is no VM=
A covering
> > + * 'address'.
> > + *
> > + * The fast path does not take mmap lock.
> > + */
> > +struct vm_area_struct *lock_vma_under_rcu_wait(struct mm_struct *mm,
> > +                                            unsigned long address)
> > +{
> > +     struct vm_area_struct *vma;
> > +
> > +retry:
> > +     vma =3D lock_vma_under_rcu(mm, address);
> > +     /* Fast path: return stable VMA covering 'address': */
> > +     if (vma)
> > +             return vma;
> > +
> > +     /*
> > +      * Slow path: the VMA covering 'address' is being modified.
> > +      * or there is no VMA covering 'address'. Rule out the
> > +      * possibility that the VMA is being modified:
> > +      */
> > +     mmap_read_lock(mm);
> > +     vma =3D vma_lookup(mm, address);
> > +     mmap_read_unlock(mm);
> > +
> > +     /* There was for sure no VMA covering 'address': */
> > +     if (!vma)
> > +             return NULL;
> > +
> > +     /*
> > +      * VMA was likely being modified during RCU lookup. Try again.
> > +      * mmap_read_lock() waited for the writer to complete and the
> > +      * writer is now done.
> > +      *
> > +      * There is no guarantee that any single retry will succeed,
> > +      * and it is possible but highly unlikely this will loop
> > +      * forever.
> > +      */
> > +     goto retry;
> > +}
>
> Hmm yeah this is not ideal :)
>
> You don't have to do any of this we already have logic to help out here -
> vma_start_read_locked().

+1

>
> That uses the fact the mmap read lock is held to pin the VMA lock, becaus=
e VMA
> write locks require an mmap write lock, and the mmap read lock prevents t=
hem.
>
> That way you can eliminate the retry.
>
> So instead:
>
> /*
>  * Tries to lock under RCU, failing that it acquires the VMA lock with th=
e mmap
>  * read lock held.
>  */
> struct vm_area_struct *vma_start_read_unlocked(struct mm_struct *mm,
>                                                unsigned long address)
> {
>         struct vm_area_struct *vma;
>
>         might_sleep();
>
>         vma =3D lock_vma_under_rcu(mm, address);
>         if (vma)
>                 return vma;
>
>         /* Slow path: preclude VMA writers by getting mmap read lock. */
>         guard(rwsem_read)(&mm->mmap_lock);
>         vma =3D vma_lookup(mm, address);
>         /* VMA isn't there. */
>         if (!vma)
>                 return NULL;
>
>         return vma_start_read_locked(vma);
> }
>
> (Untested, not even build tested code)

uffd_lock_vma() has beed merged for a while, so that one is tested and
can be used as a model. Unfortunately it has some additional logic, so
we can't simply replace it with a new generic version, I think.

>
> Not sure if we can use the linux/cleanup.h guard here, because mmap_read_=
lock()
> also does some trace stuff, but the guard makes it WAY nicer so (when it =
goes
> out of scope the mmap read lock is dropped).
>
> Maybe we could add a custom mmap lock guard to cover that too?
>
> Suren - I actually wonder if vma_start_read_locked() actually needs to re=
turn a
> boolean? The failure cases for __refcount_inc_not_zero_limited_acquire() =
are -
> detached or excluding readers on write/detach.
>
> But in both of those cases, vma_lookup() would surely not find the VMA, a=
nd
> since we're precluding writers (so no write lock, no detach possible) tha=
t means
> we should never hit it?
>
> Wonder if we should make it a void and add a VM_WARN_ON_ONCE()?

vma_start_read_locked_nested() uses
__refcount_inc_not_zero_limited_acquire(..., VM_REFCNT_LIMIT) to
protect the refcount from overflowing into
VM_REFCNT_EXCLUDE_READERS_FLAG bit. So, even though this is a very
unlikely case, we still need to consider it and return failure even
when there is no contention.

>
>
> > +
> >  static struct vm_area_struct *lock_next_vma_under_mmap_lock(struct mm_=
struct *mm,
> >                                                           struct vma_it=
erator *vmi,
> >                                                           unsigned long=
 from_addr)
> > _
>
> Cheers, Lorenzo

