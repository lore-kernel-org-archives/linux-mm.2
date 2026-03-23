Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65770F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E3B6B0095; Mon, 23 Mar 2026 15:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26436B0098; Mon, 23 Mar 2026 15:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914F86B0099; Mon, 23 Mar 2026 15:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF7A6B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:29:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 358EEC3B45
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:29:29 +0000 (UTC)
X-FDA: 84578316858.13.BC98715
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3FE54C000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:29:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bmuVNK7m;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774294167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rL6rgT4p4eg6pWVBxL1qRwcnXbeBJSn9vYxp2HwXMQ4=;
	b=gdZcjdETn4UBtTLU+gvnbQ5uyGiNm1lB0XJr6xxftbmehV4GFkSE7L+YIuZlZNlJHzlr32
	+tWeHM05Boh89gAIQ1GwSY6V8rhASQppBSrXjr74Wc1fAEUzjxcCnyt0edQ0PZCQYwKbnt
	M1m0HwGTBbrk3P9K07+JpFB/1hS0xh8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774294167; a=rsa-sha256;
	cv=pass;
	b=eYW0PJG9/ezSnikOlZr9GjIRSA67pQfo5Krxg4/SjEknyJIP95DIDcmlOStFva9rAkXbCR
	cLFX0hDG+FCWXQq+R10dPJnJc2nFR31E8Acnm/oPO/J4kbd5VtYvEOqx1tQSJnhabS/bVs
	L12mZ6TnL7QKmCkWD+sqIqJwzzykDa0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bmuVNK7m;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509062d829dso11321cf.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:29:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774294166; cv=none;
        d=google.com; s=arc-20240605;
        b=a4yYqqtI0rdhyo1MgUK6Wlb3/IhBsdvKylGyyKiH9YwyYGtdylg8Eqftyv/oZTmmpO
         fCju1QdP9P3JIHLtmoD8fkXcPsxN9RhcW+pPuHUdReJr5sAmESTW9slwnRReIiiXe1GI
         BMi1C8XdHCJgnrcw4MIc3EZTeOMFr0QllCrqOEidJ7MZ0axfkKAlqVnQw81Xjvj/VhnH
         GYyhuXvjuGPiYtZZy29JBAH8msN5n4mp3io2YiSNM87VbvFXwzBjzVNs3/Em3GWzYt/3
         mdEqqqx051j7JU6nvB6VfpUgqW4avXLo3+r1BR/yVxwkAHnhlgf1GaNuqfXMowM2PVWj
         RoMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rL6rgT4p4eg6pWVBxL1qRwcnXbeBJSn9vYxp2HwXMQ4=;
        fh=ZoAE/mxsBi1ET22XVGtvJKUND1CWeMqIdPhtUAmyvM8=;
        b=IQIeLTz98fzPlX13b1Jogw4Nccc51pzaS8BXaxKRlL7BxXkj9Mu9AIKWBV31RVFg20
         6y42uT8Z79C5TlP0Z8JoSoK0/RzK6LEiW2+UpuK1DjY28D81L7sKwb/Ia6P+hJ52f247
         3ko5jTTQH83d4LrAvDz46el/dvMdZ264IkV0I3iprFpoEDaBF5usCEhhWszWyMXhAij9
         G746eQGEXUP0beKDXNTyvgKVRfWZXddo4Y9RNDpxpRP6td3eZ49x4am9x/+eDLaeMK3A
         bZXRIwrAvXcDotbK7zdlrHPdXDhnCLZAIef0sYjvRGF8dNkB62/NpTbUrHV+mjK+7OGB
         /qSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774294166; x=1774898966; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rL6rgT4p4eg6pWVBxL1qRwcnXbeBJSn9vYxp2HwXMQ4=;
        b=bmuVNK7mEwz6txM4ABvddTNDV5HtAul7tGKH6SSzEWUGmL7OaaYX2ZoxxEAx458DaA
         tlDKqLc5XkyIuNNaHCJ9Uxx7R+A77XW3dgFKAHa1HWIHbK1e3TdcmwU7lkkV6YbKiPOw
         yWcIT0RPGyYXkk91U5LhYZlypc22v/kK+ae8lZzPyZ4hTKaS31S5t4bGCzcdUKi7j5mM
         nMgBJJcwUSbbbqc3aZwJMHUn+EbqdFRLU0yBe4u4bJ0t9Yv1tZ47oDgvFV4eONRkU9zL
         eDq4F+8dge+6HF2K3v+9VxoaaI3KtGbUEhfhA1u77qEOUzhZADkwMD+2w+IvgFTFfJpk
         shwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774294166; x=1774898966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rL6rgT4p4eg6pWVBxL1qRwcnXbeBJSn9vYxp2HwXMQ4=;
        b=Ef2HZwMC+kTWw6gaqzKiQ7bLZKOeFf98dx1Dop7ipKQmyUuYE4Ndzh4C7aPScxAGqe
         WcCrIXHC1RAYXfguUD+z7qhXlVbwGFAkpC8cS/XJSjZGkZ2APUflF6MfjMBRY9cBVRdM
         b6T372ULqYMDw4ccy2DzmNSeDXlwPZv0IVHrAgOwrlG34k0+wXv+0PrxUpZ2mkQqsLC+
         fB3BGq2S9ch2kDIncdSzUuRzrgMdxPfZRkKKLsxUZnYSgQiPtF8qeGmAGZ3m3P747Tyq
         boySe8828jQ28kMxnU28x0wMtzcheY2eJ7gy88oaeEZ+hceroXBaH2N1X32KKyBzQoPn
         xyWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtjXzAa2po5uoeuJS5iQbAFQCWFci25Zfea16AESnAboie3NMsjCE4PpTuMTZlsKl4QoOL/Eu9Tg==@kvack.org
X-Gm-Message-State: AOJu0Yw87I4qB2P4wP54Cgw9o73sgxw5bHuEP7hbTwhehJ11oERR1CXK
	Pr5pWZComN/bXBfnhmAb8x/i72/yhYzieGy+naiO8jc0bsruFP8ZuKqbYrc8Iuo7ls3mydAPEEo
	CziUtexbqgmOPQkKysr8EH3KGyxZR15S9Q183Q6WW
X-Gm-Gg: ATEYQzyC4gcfuGczHHTZzJ2Ufj/LewaYWTcSwVrByXJX8Trq9t4edX3iL0vTnAeTHo9
	kflN964hqHtuYj+lW4+HXfVQnGjXn1gXshfvMh0vUr/1zN9opURUpcpc4aQooL4L2ckbSKOE7Ou
	jwGF7jODCwhh1rVqHmLAhtLLU7s8iGozLIm+mDfZBIw3qZWbty1x64z75cI40dX9IQuNi/RiWZs
	2OxoVBL74EQidxcTbOfbNMq3h/eJo2Qzl5Uit7vuajYZOLFCYl94p7Z2ODLAvRZDo+3lZMsss7O
	Lzpp9Nw6pUmx8nEq
X-Received: by 2002:a05:622a:a986:20b0:508:fd42:fd05 with SMTP id
 d75a77b69052e-50b6fe1094amr2337331cf.15.1774294165477; Mon, 23 Mar 2026
 12:29:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com> <20260322054309.898214-5-surenb@google.com>
 <1c44dd0b-4f5a-4fc1-983f-f728b31c9e4d@lucifer.local>
In-Reply-To: <1c44dd0b-4f5a-4fc1-983f-f728b31c9e4d@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 12:29:14 -0700
X-Gm-Features: AQROBzCQaEF_cPLZfBQCzrdp1WYDK-0_JtC25zQIk1w6f-8rEEzfFfTeX5PuZ2c
Message-ID: <CAJuCfpGk3sTw2_owiRZM=V2e0UGDad5MrDbCsPbY3GUvT4u63A@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FE54C000E
X-Stat-Signature: yphobnncef5jmiubw49smzz6a8k17xjp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774294167-64052
X-HE-Meta: U2FsdGVkX19Hrpf3QGHJrNRI1+FrYHgSLbiArZW0/mYecNMwLCEIR5rCf9w1h81nI/GmYGiiVALAgGZ72cUMt1icfLgtaQWhEVGJlOgpPZWgkL6IWc8tOA4hv/eIcyIWBkKqKpw3Tdmwy8i8cDYAsgnzDplkPBR66NhtOHN2NMSeJ07hkIAMoUFL9bBjf45hXyFVh1rv5fWc0ezcAqS5wuIGiuFt8TT80sxAZVkc0l+/MOEu5g+kvfsQ0L6T3XjlGyDoFMcNRAqBzcLrfJ1vUe7mEm09eXRP/cEjXT1w8cR2Sav5uY3JT6G4WyJ4jBfbYxGGNgxRNDhhbuS0T1eSo6Dj0cfFyA9d51aeafNOeqFMHpBtkcHmEuyJkIQ0RiRdqTg7fyz33lMW+oSNtKMxXdduveM5bsmtbFtRj9ytHaXZRyDxf/0Wml8QqDutohtj5Cyb6e2R0SZ/NpZMRFe6V3AOxJn3a57cN0rc7zz4tqfLUXuCJCFe1dVfboC2Yp/s4kqiNQFIANJ1esrviQW1OSgYsDcug4sk+aPtgUra4oOGJIbuDMEYFU1p//gH+cDO4nsrwLAWpF8SQvjnJNfk9WYe1o/12N6TFS4N98LNpcbIuhMcTTrPz2d4K6jnELhByl3JUMQXGuIg3rkHXG+9t0SIDXab7QVKm66VuF/SVKR5grmgEt1qSJG+BHldDMfSML0oXVkV/RXi5PKCO04uWiJEA2M5ovclJFtCY4LD4fDRT61VZjSwmMuMecLws3PhzTS63rBXLvGxGnsbK63egX59gdFB8WPGVCej36Ko2cM2+oTBCfC1Isa9tpNKmdNSiFZ5ePOpaDSY1rr/hg2oMDVZuKET9fF+DcoCvzY6sIrCBJH0Uwz+X7h3tJ9yeaYYkm1bbdvZqIWnLm19K4kGvFDPQDcmAMwTJ4S33L0vDmfJVE81m2If+PFO4iKVu6t/6ojVuZ1dQLIVztCblf/
 xyIsOZO6
 o8vN0oK2deLO5A/lQiMGEHsAGUPSGbUhgN7TRVmvkguD2PmLB7krqzskQwdsLouzPdPW2tRDgsNuIEfTxulkn48Yrv6XexZqTwkA5xuijkaTuwvOIkFYfSsRKsAT7nLgxlkwIU2CEbi6v6BIvNIh+ynt4xsIRCs1j+9uD93hJQ2GpOHwwAsV2F9MBC87KU91FZaaNeGtI5s/7d5W04M2Hr8F8Y073Jm9Bsmyshwhx6bz5DRLLidg3pCx5rJFg/L2Vckt5u35ulj/rBKfgnFkFRCiKtpuvvOqUaTAHhiGPg6dNWaSVxWEokolFhsEffc9tr7jbCqy9ST7F5zzdSQ8a9izJiUpbTxXfQdfga2Sm7ZXk10sh5iiPo2/haetwFXd7CX7npF25uBxmfxwqjBQkw9lrrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:04=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sat, Mar 21, 2026 at 10:43:08PM -0700, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c |  5 ++++-
> >  mm/mempolicy.c     |  1 +
> >  mm/pagewalk.c      | 20 ++++++++++++++------
> >  3 files changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e091931d7ca1..2fe3d11aad03 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >               struct clear_refs_private cp =3D {
> >                       .type =3D type,
> >               };
> > +             int err;
>
> Maybe better to make it a ssize_t given return type of function?

Ack.

>
> >
> >               if (mmap_write_lock_killable(mm)) {
> >                       count =3D -EINTR;
> > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >                                               0, mm, 0, -1UL);
> >                       mmu_notifier_invalidate_range_start(&range);
> >               }
> > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_ops, =
&cp);
> > +             if (err)
> > +                     count =3D err;
>
> Hmm this is gross, but it's an established pattern here, ugh.
>
> Now we have an err though, could we update:
>
>                 if (mmap_write_lock_killable(mm)) {
> -                       count =3D -EINTR;
> +                       err =3D -EINTR;
>                         goto out_mm;
>                 }
>
> Then we can just do:
>
> +               err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_ops, =
&cp);
>
> And at the end do:
>
>         return err ?: count;
>
> Which possibly _necessitates_ err being a ssize_t.

Sounds doable. Let me try that.

>
> >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> >                       mmu_notifier_invalidate_range_end(&range);
> >                       flush_tlb_mm(mm);
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 929e843543cf..bb5b0e83ce0f 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -969,6 +969,7 @@ static const struct mm_walk_ops queue_pages_lock_vm=
a_walk_ops =3D {
> >   *      (a hugetlbfs page or a transparent huge page being counted as =
1).
> >   * -EIO - a misplaced page found, when MPOL_MF_STRICT specified withou=
t MOVEs.
> >   * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK uns=
pecified.
> > + * -EINTR - walk got terminated due to pending fatal signal.
>
> Thanks!
>
> >   */
> >  static long
> >  queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned =
long end,
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index eda74273c8ec..a42cd6a6d812 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -438,14 +438,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >               mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
>
> NIT: Don't need this to be an inline any longer. May as well fix up while=
 we're
> here.

Ack.

>
> >                                        enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> > -             vma_start_write(vma);
> > -             break;
> > +             return vma_start_write_killable(vma);
>
> LGTM
>
> >       case PGWALK_WRLOCK_VERIFY:
> >               vma_assert_write_locked(vma);
> >               break;
> > @@ -457,6 +456,7 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               break;
> >       }
> >  #endif
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -500,7 +500,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm,=
 unsigned long start,
> >                       if (ops->pte_hole)
> >                               err =3D ops->pte_hole(start, next, -1, &w=
alk);
> >               } else { /* inside vma */
> > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > +                     err =3D process_vma_walk_lock(vma, ops->walk_lock=
);
> > +                     if (err)
> > +                             break;
>
> In every other case we set walk.vma =3D vma or NULL. Is it a problem not =
setting
> it at all in this code path?

IIUC the other cases set walk.vma because they later call
ops->pte_hole(..., walk). In our case we immediately break out of the
loop and exit the function, which pushes "walk" variable out of scope.
So, walk.vma won't be used and setting it would achieve nothing.

>
> >                       walk.vma =3D vma;
> >                       next =3D min(end, vma->vm_end);
> >                       vma =3D find_vma(mm, vma->vm_end);
> > @@ -717,6 +719,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (start >=3D end || !walk.mm)
> >               return -EINVAL;
> > @@ -724,7 +727,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
>
> LGTM
>
> >       return __walk_page_range(start, end, &walk);
> >  }
> >
> > @@ -747,6 +752,7 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (!walk.mm)
> >               return -EINVAL;
> > @@ -754,7 +760,9 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
>
> LGTM
>
> >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> >  }
> >
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >
>
> Thanks, Lorenzo

