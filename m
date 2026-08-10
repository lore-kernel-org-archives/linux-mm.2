Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BDAC5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5E06B008C; Mon, 10 Aug 2026 13:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FB86B0092; Mon, 10 Aug 2026 13:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBB06B0093; Mon, 10 Aug 2026 13:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2D436B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:04:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C97C740235
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:04:29 +0000 (UTC)
X-FDA: 85085983458.23.2A28023
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id BF9864000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:04:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t63tSWyf;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786381467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjX4YrLw+cDwJ0ZquVDEURnRs6O2DP182dhFnTf/qAc=;
	b=ein92QHzbqXDL04FLMwhEyB1snSIjjU6dHDw8IXWaeRgHdrX+fC/fwx7zpaGoHM8SZ3e9g
	5oEUueVpV4tQLxa4pKjRfr1AUYtDFewOTytqGT1sMVbrewOg+ECl+buNcexo4ZSFMifYi+
	9DN2lzqcdW7NKGjoKs3SgZ7WezOUGHw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786381467;
	b=A+hicDvpusBXDH9dTwOTk5tmrdrUM+Snv8MDlfcZRFiCBz9lJXPJW4dz5SCsrGI7yrt6AL
	Iel2dZqZzyF267EM3ZqM7SwANk1678usesKxjAAOzDDfV2FP5HkrVjz0d9E7CsiM3E9Rl2
	vj0xs66ZGxpvGmqfx8U0VcQ7Xf6md70=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t63tSWyf;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c01c79467so6741cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:04:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786381467; cv=none;
        d=google.com; s=arc-20260327;
        b=nZXh5PPMpcaoxDMQNZM+E4QkggF4hoWhDQ0E7Ouvqrx/JGdnGHW6oVJCfQ6858tF+e
         fbli3HUYm/8lmuqXQXn/95vGpwY/VLFas9iiAuIWjQCjQ6Qu3A4Rbi+liirwdC8t9N4F
         IAmUDFlUx425IJnzwuiYpFiYnyVUijbUiy85m+jztUDvpqkYQHH3gEsOAkxjIDALEC62
         u8LYX8gvRDbqfrZBfoURVj76ON+OBNiZMErAgyHCS0r3BhCmlKm+aswviAkMY3bLGGWq
         0Rby1/96ou6KkphIdUsalEKOySnGj2sFxp8xFUpHVxyfUVqrX+DGj1rAZV2hjPrSQ+O+
         qj6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KjX4YrLw+cDwJ0ZquVDEURnRs6O2DP182dhFnTf/qAc=;
        fh=AhFKa2nkJ0qHhJN0Mg5gYOWaTG7lhBoNwSdf5I62m+I=;
        b=QVDozjkEFXgF0dWdzfAhzIOn02V+Of9+4dYNuoXd5R1U94UxzDiJecJAimDb9assvM
         H45aJxL4IXvrfY/fVXSzFWz71WpvjheRjwQzfv1p3yz4PbzGLa3AWyxj4WvsXKRczLB5
         5wuZZ02Uv0GhjHN2bFJZbl/QlIoiZDFS+lRTeRrwhU0wV3qd0XxZOVCNuCcvQ7mgwISP
         5CYnrb2HudCnxm+IUKWwgOksMXDlzte9xFHO1DiOtQDqkTmnOLyCAJU8UVt4FwdGvTwU
         2ngcsF5kYpxHaoWJrKNceoqmGWahQ9DlgaU1WxRIQAlk59npes7WBRXh7vQ68/nKotM4
         PAKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786381467; x=1786986267; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KjX4YrLw+cDwJ0ZquVDEURnRs6O2DP182dhFnTf/qAc=;
        b=t63tSWyfzwDX3YhTRW133SoBYDnTKN21xeFXwNgdRA6pyGChc2SX3Oa5SyCrZ/4VWc
         iq4gr4Hc+ARJpKBLRX5A1dWlj6n4ewrWYJDLgsDluOg6z0PHXHjCRl5lWu68TrxpU4+/
         4eWKQ76AUBFSplBYPcc7ZwJjM+zN7bfufQVUIHwFIeysP4njyUexyCxfgYFke471FE9y
         8s/Qv0s6Y2oFbf2xJXfDxNbHmkyWCVetX/hVL4A/+QXKcX1Hv9spErvD1ZXvf/OS2S1R
         +rzgp1v9RPgPMYdpmrMvfyVsglcy1/wILWz3TGbX9PoAB7MPFPMozL8oOTvkBM2y0uCM
         28WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786381467; x=1786986267;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KjX4YrLw+cDwJ0ZquVDEURnRs6O2DP182dhFnTf/qAc=;
        b=FhM8HNpvoC0wqiFjMggcf3QdqUDqcKKlY4eVYrYVBkG4LItWIC3mpDsCPS4JuG8dww
         +hR6Mcg2ncOkeLpitu5ygOTaDovwu8k8jfCuTCbeZ7pbxUC4Sqoe1Loor65qDv2uEf59
         ePNz1+rToTNG10ga6nbBuyGigg4vFV32m6TKtVraQejwFsYhJYNMCOMhmBhANV0697CO
         UFW+dYqYBoWG5CSdcNuuIxepAdcCwnatq5sDlhHsqEDiZjTQRV1B6Q3LrWiejInNl924
         ZQhgs7Z4qzPZmwnobjofJQcHbBtZGkkUtdabWTFD90sX6VgUYuVzZ3XKqPtCrURNlit1
         9riA==
X-Forwarded-Encrypted: i=1; AHgh+RpaC2a6T4H0M5Dzvcc/jaqV4elu7K0AotZP2HO1OWYUB4qswWZ4R6zao4gxYScye+7genThu0a30Q==@kvack.org
X-Gm-Message-State: AOJu0Yyzuy81cmNbhS7kvhsHkNlyx6CaK42EhIyqcMEQtVfZ0w0g8OfL
	GAs9YqQM56U1Zgs8WfaAVs3P9NL2E3QcL3mMVuyWJIRldq+3TSbZtSYUeiUq+UsOnLDmdbzeYjk
	/rGAQ8SbRHnDwvbnr5DCrmpJwXU5yaONafGmLrbPK
X-Gm-Gg: AR+sD10VSzZi9IPhklQhhaO5y1+3/CNHo0fp8mi1AqKwuZaQc3nagIVVXDXjRS7rTmK
	XgLDhT3+KE+SWyRu2vW9X0/C1HOU3kkEpbpG+YURdL41IG20c6pplH3kGdBozYUkNpRstZYuK5M
	aQYSsMHnisFnI6t2DrW3haf30mtZFUcUnFhw6hpv7R2cpltQZh39tID35yXYXMs9fN+yg4ma5dQ
	6/fis4AJw06X9gA4PWegd/kgBhPCY93dG7hlGIvv5joC7Ha4EB8nacZ0NCc5d8hlwNhN9x1aHeU
	QNsnQ+3paerPTj/arlkPBmafLXKLbXDp++Y3ZYRxo9WmD4zFH0WT+3yUcuInziwVaQ==
X-Received: by 2002:ac8:5709:0:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52d512286ecmr21891cf.12.1786381465596; Mon, 10 Aug 2026
 10:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-2-surenb@google.com>
 <anmTYW8X6c9TgaO0@lucifer>
In-Reply-To: <anmTYW8X6c9TgaO0@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 10:04:12 -0700
X-Gm-Features: AUfX_mxutE59rSUcfecMKUzyNOqPun4S736i4IYjCyorvL6ybmji2emlyeUIxvA
Message-ID: <CAJuCfpHicSdLmz3gPyY6x+M6KWFe-FC5DR2QivX90bc+V_0O9g@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@kernel.org, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF9864000F
X-Rspam-User: 
X-Stat-Signature: btpfab5sdq3d6rpjnreoeqxtf7t6pkmg
X-HE-Tag: 1786381467-571365
X-HE-Meta: U2FsdGVkX1/D2VYdoJZUWFjwyFGYZfVuQggV4a7XslwXxAA5h1WNnp3xgrlPUejfFPw0bk/b98tGB5DcwLl1xSI10dgUZojzQV9rwXEtxSz5VbNftJNGDFqZuB7i8C9w6lMHzRT0ZCjtqVs1hIU72CA6/ZeF/Ud4ATiHAKz6pWXMlf6szPKELHOMK04NnSIARa1/7ojcSR533Y9rlWHqGytKaONh52K6HW4KzibpLr6OSS/O5xfI9lWcifK4ctVsl3ROs8sYI+YDRNjsAfmzVX54MhGRm2Xe4HcjPso1pfZkaSK6uO0guIE92U1MBpGEGYxLm/fBYuesgWyS/a5c5maylYCwug8YAWZpPM1eqoLsoiAhoXAHTleBjAvDs8GqYWZ2AJ6NfLqCX6IXmN9znq3BfOmhKpYYvoaqa9uf+7HrpCox9JrMaN53UTkTMmb1Ovq61qVy0gvnj42LFibr/f2XdhiBsVphyYjF4yf35mujwUrvxIVBJED5iwLq7VoZB7/myM8ZMjYMBgVWr5S8b36y49xSfYFNR+DTIId9FaST/+JOmeDHtB7PyFlhv16xKpAvgHZUv+CH8B/bei7dTTer915l9+WLC3n9ZrVfw0zcSr3Wx3ANoU7CcRPjLmt9PvWAI66n03ZK5KDSBE1Xxs5lfGXtafQje4Y9/OgG3c71sdQMjzDaaszi34aHojZPiB6mG62rj2UGMsN3UT3yRN5s47pwcbNJX/vBvNwRJ7m44SOgr14yVeXkIwq767fr2pSxUny8rpsdemq0mz6JyAwuLaEzT+m6HIllIkVs7/XmCYSBfUE1su/xxuvByozXs44t2ImB7WcZMIYqKizavllsQErjrKjBne5qRv7+Rj3oU0qHmo+1ClHFuD1hdlX4yv8poDhayYRoUOUEWWETWYQLynZ99fvLymNQuddo4J/RN2+wueRu2uWIxcVx88rGYD6zWywMP0pI9uCb8ll
 iiP+nOSq
 Ck6QTaDhLbtkUIcHxLw0inWeruv23zwTnd4ttgPviezGqRL2GQNWTXZv8wbcUTg605Kc0d6klc3q8U10BEsoe68+r4FMypvmF1Vhu8J8ghwqYHPzQoszdXzB1g0A73zFbk43a+AhqvuONGDt+IZzrSNujJvy4RsMtAdd4Y6Xu4ZBi8ER37UOYVxHNddsJ+hum/1rx1ztRRAtwsd7w8NwuPNBtSaDpb/mZEOG58K0i/UTW1osT67JSaUZsQp57+wgCiPLVnaerrzwMgLTUJztVnaG4owEbCdPMndaGj8V3DFyNUdVW+1Ba6y1+1dTfEaPlE/mSipBUa+G2ReCeGsScmPnTyeth3L+DCWaehYYMJ0rt1BH4/jADjxg/+GFaVm8dnYnOj5tq/ZNdyjsrNry2Pbrf4+83koFqvDKfDBEiCGldW+hVnUTh3W9TP8AF2u3BPUfz08sUB92T5tfugYlGcFLWZ5PQJxZv9psFzK/bE7ber25Y771NYgnuS/12Dv35Gw2UXcoh1N4oVjuRGtqwy9rwX6lrJerTiqPUKGILtf9YHNmLlumOK5vUge/PnIUCNxXV9x6N92QalERlFtrMB1L4g5no10eqZm3USuPs9bTikAncdS+M+5jH791tuuqyT4zzmkLsVmq4ODh+7xbTmREOKrSy3D8cyuP6AEJk0KM/+IoKkOBtyZibJxQLUoH0av5d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 3:17=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
> >
> > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > when the architecture started using per-VMA locks in the fault
> > handler. But, contrary to the naming, the Kconfig option does not
> > really indicate whether the architecture supports per-VMA locks or
> > not. It is more of a marker for whether the architecture is likely to
> > benefit from per-VMA locks.
>
> Thanks for clarifying this. I'm very glad we're getting rid of this :) it
> was a bit too conservative I think.
>
> >
> > To me, the most important thing side-effect of universal availability
> > is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> > per-VMA locking in all x86 code without fallbacks.
> >
> > Overall, this just generally makes the kernel simpler. Just look at
> > the diffstat. It also opens the door to users that want to use the
> > per-VMA locks in common code. Doing *that* brings additional
> > simplifications.
>
> Yes!
>
> >
> > The downside of this is adding some fields to vm_area_struct and
> > mm_struct. There are likely ways to optimize this, especially for
> > things like SMP=3Dn configs. For now, do the simplest thing: use the
> > same implementation everywhere.
>
> I think for most cases SMP=3Dn arches are not going to be scaling too cra=
zily
> on threads/processes anyway.
>
> If real world usecases exist that the struct bloat causes problems for th=
en
> optimisations for those can be looked into.

Agree. If any regressions are reported we will address them.

>
> But I wonder if cache line alignment would in any case alter the impact o=
f
> this anyway?

I'll see what pahole tells me on SMP=3Dn and maybe we can reason about the =
impact.

>
> >
> > =3D=3D Considerations for NOMMU config =3D=3D
> >
> > NOMMU systems do not write-lock VMAs, therefore read-locking a VMA
> > would always succeed unless VMA is detached. Therefore for NOMMU
> > config we make vma_mark_attached() a NOOP, which keeps VMAs always in
> > detached state. This causes VMA read-locking to always fail and the
> > caller falls back to locking mmap_lock.
>
> Nice, I think this is the best way of handling nommu.

That's what you and Jann suggested :)

>
> >
> > The following functions will have a different implementation in NOMMU
> > config:
> >
> > - vma_mark_attached(), vma_mark_detached() are made NOOPs, keeping VMAs
> > always in a detached state and preventing assertions and refcount
> > underflows;
> >
> > - vma_start_write(), vma_start_write_killable() are made NOOPs to avoid
> > warnings in __vma_start_write() due to VMAs being detached.
> > These functions are not used in NOMMU code but __vma_start_write()
> > is an exported function, therefore might be used by drivers.
>
> OK so being cautious. It sucks to do it but the IS_ENABLED(CONFIG_MMU)
> guard pattern makes it much less egregious.
>
> >
> > - vma_assert_attached() is made NOOP because it's reachable from NOMMU
> > code via split_vma()->vma_iter_store_new()->vma_iter_store_overwrite();
>
> Ugh yeah.
>
> >
> > - vma_assert_write_locked() is asserting vma->vm_mm is write-locked;
>
> I'm confused by this one how is that reachable and how is that addressed?
> Seems like this sentence is missing something :)

Basically, I'm keeping this assert for NOMMU as it was before this
change. If NOMMU code asserts this, we would expect it to hold mmap
write lock, so I kept it that way. Does that make sense?
Maybe I should amend the explanation as:

vma_assert_write_locked() is asserting vma->vm_mm is write-locked as before=
;

>
> >
> > The following functions work for both MMU and NOMMU configs:
> >
> > - vma_lock_init() performs the same initialization as for MMU config;
> >
> > - mm_lock_seqcount_init(), mm_lock_seqcount_begin(), mm_lock_seqcount_e=
nd()
> > are called from mmap_write_{lock|unlock} and update mm_lock_seq correct=
ly.
> >
> > - mmap_lock_speculate_try_begin(), mmap_lock_speculate_retry() work as =
is
> > because mm_lock_seq is updated correctly;
> >
> > - vma_start_read(), vma_start_read_locked() will always fail because VM=
As
> > are always detached;
> >
> > - vma_end_read() will never be called because vma_start_read() never
> > succeeds;
> >
> > - vma_is_attached() always return false because VMAs are always detache=
d;
> >
> > - vma_assert_detached() will never trigger because VMAs are never attac=
hed;
>
> Nice thanks for the write up!
>
> Maybe worth looking ahead and pointing out that vma_start_read_unlocked()
> will also be safe (i.e. the attempted read lock will bail).

Ack. Will add.

>
> Though perhaps you'd want an IS_ENABLED(CONFIG_MMU) there to avoid wasted
> mmap lock toggling (will comment on that patch if you didn't already hand=
le
> that there! :)

I think adding IS_ENABLED(CONFIG_MMU) at the beginning of
lock_vma_under_rcu(), as you suggest later, would be best. That way
vma_start_read_unlocked() will use that too.

>
> >
> > Changes in the following files are not affecting NOMMU config:
> >
> > task_mmu.c - not compiled when CONFIG_MMU=3Dn;
> > pagewalk.c - not compiled when CONFIG_MMU=3Dn;
> > userfaultfd.c - not compiled when CONFIG_MMU=3Dn (CONFIG_USERFAULTFD de=
pends
> > on CONFIG_MMU);
> >
> > The following changes are made to keep NOMMU config working like before=
:
> >
> > stack_map_lock_vma() - keeps mmap_lock in NOMMU config;
> > bpf_iter_task_vma_new() - bails out in NOMMU config;
>
> Worth saying both are in the BPF code.

Ack.

>
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  arch/arm/Kconfig                       |  1 -
> >  arch/arm64/Kconfig                     |  1 -
> >  arch/loongarch/Kconfig                 |  1 -
> >  arch/powerpc/platforms/powernv/Kconfig |  1 -
> >  arch/powerpc/platforms/pseries/Kconfig |  1 -
> >  arch/riscv/Kconfig                     |  1 -
> >  arch/s390/Kconfig                      |  1 -
> >  arch/x86/Kconfig                       |  2 -
> >  fs/proc/internal.h                     |  2 -
> >  fs/proc/task_mmu.c                     | 93 --------------------------
> >  include/linux/mm.h                     | 12 ----
> >  include/linux/mm_types.h               |  8 +--
> >  include/linux/mmap_lock.h              | 70 ++++++-------------
> >  kernel/bpf/stackmap.c                  | 15 ++---
> >  kernel/bpf/task_iter.c                 |  2 +-
> >  kernel/fork.c                          |  2 -
> >  mm/Kconfig                             | 12 ----
> >  mm/Kconfig.debug                       |  1 -
> >  mm/debug.c                             |  4 --
> >  mm/init-mm.c                           |  2 -
> >  mm/memory.c                            |  2 -
> >  mm/mmap_lock.c                         | 24 -------
> >  mm/pagewalk.c                          |  2 -
> >  mm/rmap.c                              |  2 -
> >  mm/userfaultfd.c                       | 55 ---------------
> >  rust/kernel/mm.rs                      | 32 +++------
> >  tools/testing/vma/include/dup.h        |  5 +-
> >  tools/testing/vma/vma_internal.h       |  1 -
> >  28 files changed, 39 insertions(+), 316 deletions(-)
>
> Still a lovely diffstat :) good.
>
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 9187240a02db..f815209167cd 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -41,7 +41,6 @@ config ARM
> >       select ARCH_SUPPORTS_ATOMIC_RMW
> >       select ARCH_SUPPORTS_CFI
> >       select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_USE_BUILTIN_BSWAP
> >       select ARCH_USE_CMPXCHG_LOCKREF
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 11a9c534b7b4..21eb64b24a2c 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -81,7 +81,6 @@ config ARM64
> >       select ARCH_HAS_PTE_PROTNONE
> >       select ARCH_SUPPORTS_NUMA_BALANCING
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SCHED_SMT
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index e20acbe5fe7b..7741e39eca2b 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -69,7 +69,6 @@ config LOONGARCH
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> >       select ARCH_HAS_PTE_PROTNONE if 64BIT
> >       select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SCHED_SMT if SMP
> >       select ARCH_SUPPORTS_SCHED_MC  if SMP
> > diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/plat=
forms/powernv/Kconfig
> > index b5ad7c173ef0..dd8f6060fb7a 100644
> > --- a/arch/powerpc/platforms/powernv/Kconfig
> > +++ b/arch/powerpc/platforms/powernv/Kconfig
> > @@ -17,7 +17,6 @@ config PPC_POWERNV
> >       select PPC_DOORBELL
> >       select MMU_NOTIFIER
> >       select FORCE_SMP
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
> >       default y
> >
> > diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/plat=
forms/pseries/Kconfig
> > index 74910ce3a541..7d125e288f6e 100644
> > --- a/arch/powerpc/platforms/pseries/Kconfig
> > +++ b/arch/powerpc/platforms/pseries/Kconfig
> > @@ -23,7 +23,6 @@ config PPC_PSERIES
> >       select HOTPLUG_CPU
> >       select FORCE_SMP
> >       select SWIOTLB
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
> >       default y
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 7b9c373d82fa..faa85a031fe5 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -70,7 +70,6 @@ config RISCV
> >       select ARCH_SUPPORTS_LTO_CLANG_THIN
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
> >       select ARCH_HAS_PTE_PROTNONE if MMU
> >       select ARCH_SUPPORTS_RT
> >       select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
> > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > index ab8fccc2cc4e..d1274bca8c39 100644
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -151,7 +151,6 @@ config S390
> >       select ARCH_HAS_PTE_PROTNONE
> >       select ARCH_SUPPORTS_NUMA_BALANCING
> >       select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
> >       select ARCH_USE_BUILTIN_BSWAP
> >       select ARCH_USE_CMPXCHG_LOCKREF
> >       select ARCH_USE_SYM_ANNOTATIONS
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index fb298e219179..79479d29576f 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -27,7 +27,6 @@ config X86_64
> >       select ARCH_HAS_GIGANTIC_PAGE
> >       select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> >       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> > -     select ARCH_SUPPORTS_PER_VMA_LOCK
>
> I'm glad we're getting rid of ARCH_SUPPORTS_PER_VMA_LOCK, it seemed to be
> an arbitrary 'these are arches that both _use_ it and _support_ it'.
>
> And really every arch supports them.
>
> We can't really have assumed anyway that an arch would definitely take a
> VMA read lock (alone) for page faulting as that was always a best-effort
> thing, so dropping this can't break anything.
>
> In general I can't see any reason why actively using VMA locks the way we
> do in core mm would be detrimental to arches that don't currently have
> ARCH_SUPPORTS_PER_VMA_LOCK.
>
> And on the same basis I think they should also do the same VMA lock
> faulting logic as everybody else. I can't see why they wouldn't just be
> faster on !ARCH_SUPPORTS_PER_VMA_LOCK arches.
>
> But they will be at worse equivalently performing or perhaps _less_
> adventageous than other arches.
>
> And, in general, having consistent per-arch fault logic would be a good
> thing (TM) (and particularly - as Matthew intends to do - having shared
> code for this is a _really_ good idea, the duplication right now is
> horrible).
>
> So perhaps Matthew could do this as part of his changes or you could foll=
ow
> up with changes to do that?
>
> I think his work would be made easier by this being the same everywhere,
> however.

Sounds like he already plans for this :)

>
> >       select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
> >       select HAVE_ARCH_SOFT_DIRTY
> >       select MODULES_USE_ELF_RELA
> > @@ -1846,7 +1845,6 @@ config X86_USER_SHADOW_STACK
> >       bool "X86 userspace shadow stack"
> >       depends on AS_WRUSS
> >       depends on X86_64
> > -     depends on PER_VMA_LOCK
> >       select ARCH_USES_HIGH_VMA_FLAGS
> >       select ARCH_HAS_USER_SHADOW_STACK
> >       select X86_CET
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index b232e1098117..6713757da099 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -385,10 +385,8 @@ struct mem_size_stats;
> >
> >  struct proc_maps_locking_ctx {
> >       struct mm_struct *mm;
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       bool mmap_locked;
> >       struct vm_area_struct *locked_vma;
> > -#endif
> >  };
> >
> >  struct proc_maps_private {
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 817e3e0f9194..096bf0b0b9e0 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -130,8 +130,6 @@ static void release_task_mempolicy(struct proc_maps=
_private *priv)
> >  }
> >  #endif
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> > @@ -233,46 +231,6 @@ static inline void reacquire_rcu(struct proc_maps_=
private *priv)
> >       vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return mmap_read_lock_killable(lock_ctx->mm);
> > -}
> > -
> > -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ct=
x)
> > -{
> > -     mmap_read_unlock(lock_ctx->mm);
> > -}
> > -
> > -static inline bool lock_vma_range(struct seq_file *m,
> > -                               struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> > -}
> > -
> > -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > -{
> > -     unlock_ctx_mm(lock_ctx);
> > -}
> > -
> > -static struct vm_area_struct *get_next_vma(struct proc_maps_private *p=
riv,
> > -                                        loff_t last_pos)
> > -{
> > -     return vma_next(&priv->iter);
> > -}
> > -
> > -static inline bool fallback_to_mmap_lock(struct proc_maps_private *pri=
v,
> > -                                      loff_t pos)
> > -{
> > -     return false;
> > -}
> > -
> > -static inline void drop_rcu(struct proc_maps_private *priv) {}
> > -static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
>
> Lovely :)
>
> >  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t =
*ppos)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > @@ -560,8 +518,6 @@ static int pid_maps_open(struct inode *inode, struc=
t file *file)
> >               PROCMAP_QUERY_VMA_FLAGS                         \
> >  )
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       reset_lock_ctx(lock_ctx);
> > @@ -612,26 +568,6 @@ static struct vm_area_struct *query_vma_find_by_ad=
dr(struct proc_maps_locking_ct
> >       return vma;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     return mmap_read_lock_killable(lock_ctx->mm);
> > -}
> > -
> > -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> > -{
> > -     mmap_read_unlock(lock_ctx->mm);
> > -}
> > -
> > -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > -                                                  unsigned long addr)
> > -{
> > -     return find_vma(lock_ctx->mm, addr);
> > -}
> > -
> > -#endif  /* CONFIG_PER_VMA_LOCK */
> > -
> >  static struct vm_area_struct *query_matching_vma(struct proc_maps_lock=
ing_ctx *lock_ctx,
> >                                                unsigned long addr, u32 =
flags)
> >  {
> > @@ -1314,8 +1250,6 @@ static const struct mm_walk_ops smaps_shmem_walk_=
ops =3D {
> >       .walk_lock              =3D PGWALK_RDLOCK,
> >  };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
> >       .pmd_entry              =3D smaps_pte_range,
> >       .hugetlb_entry          =3D smaps_hugetlb_range,
> > @@ -1345,22 +1279,6 @@ get_smaps_shmem_walk_ops(struct proc_maps_privat=
e *priv)
> >       return &smaps_shmem_walk_vma_lock_ops;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline const struct mm_walk_ops *
> > -get_smaps_walk_ops(struct proc_maps_private *priv)
> > -{
> > -     return &smaps_walk_ops;
> > -}
> > -
> > -static inline const struct mm_walk_ops *
> > -get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> > -{
> > -     return &smaps_shmem_walk_ops;
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  /*
> >   * Gather mem stats from @vma with the indicated beginning
> >   * address @start, and keep them in @mss.
> > @@ -3497,7 +3415,6 @@ static const struct mm_walk_ops show_numa_ops =3D=
 {
> >       .walk_lock =3D PGWALK_RDLOCK,
> >  };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
> >       .hugetlb_entry =3D gather_hugetlb_stats,
> >       .pmd_entry =3D gather_pte_stats,
> > @@ -3512,16 +3429,6 @@ get_show_numa_ops(struct proc_maps_private *priv=
)
> >       return &show_numa_vma_lock_ops;
> >  }
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline const struct mm_walk_ops *
> > -get_show_numa_ops(struct proc_maps_private *priv)
> > -{
> > -     return &show_numa_ops;
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  /*
> >   * Display pages allocated per node and memory policy via /proc.
> >   */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 7fabe6c66b4b..d9850f846242 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -931,7 +931,6 @@ static inline void vma_numab_state_free(struct vm_a=
rea_struct *vma) {}
> >   * These must be here rather than mmap_lock.h as dependent on vm_fault=
 type,
> >   * declared in this header.
> >   */
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static inline void release_fault_lock(struct vm_fault *vmf)
> >  {
> >       if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> > @@ -947,17 +946,6 @@ static inline void assert_fault_locked(const struc=
t vm_fault *vmf)
> >       else
> >               mmap_assert_locked(vmf->vma->vm_mm);
> >  }
> > -#else
> > -static inline void release_fault_lock(struct vm_fault *vmf)
> > -{
> > -     mmap_read_unlock(vmf->vma->vm_mm);
> > -}
> > -
> > -static inline void assert_fault_locked(const struct vm_fault *vmf)
> > -{
> > -     mmap_assert_locked(vmf->vma->vm_mm);
> > -}
> > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> >  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
> >  {
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b5d4cd3b067b..d8e246fd09d3 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -950,7 +950,6 @@ struct vm_area_struct {
> >               vma_flags_t flags;
> >       };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Can only be written (using WRITE_ONCE()) while holding both:
> >        *  - mmap_lock (in write mode)
> > @@ -966,7 +965,7 @@ struct vm_area_struct {
> >        * slowpath.
> >        */
> >       unsigned int vm_lock_seq;
> > -#endif
> > +
> >       /*
> >        * Low 32-bits of virtual page offset.
> >        * See vma_start_virt_pgoff() comment for details.
>
> <3 the consistent red in this diff :)
>
> [Sorry to be awkward but this change must have been based on mm-new and a=
n
> old revision of my series and needs a rebase :) all the *_virt_*()
> functions were renamed to *_anon_*().]

It was over mm-unstable but probably before your final changes went
in. I'll rebase the nest version over mm-unstrable again.

>
> > @@ -1003,7 +1002,6 @@ struct vm_area_struct {
> >  #ifdef CONFIG_NUMA_BALANCING
> >       struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
> >  #endif
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Used to keep track of firstly, whether the VMA is attached, se=
condly,
> >        * if attached, how many read locks are taken, and thirdly, if th=
e
> > @@ -1046,7 +1044,6 @@ struct vm_area_struct {
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >       struct lockdep_map vmlock_dep_map;
> >  #endif
> > -#endif
> >  #ifdef CONFIG_64BIT
> >       /*
> >        * High 32-bits of virtual page offset.
> > @@ -1254,7 +1251,6 @@ struct mm_struct {
> >                                         * init_mm.mmlist, and are prote=
cted
> >                                         * by mmlist_lock
> >                                         */
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               struct rcuwait vma_writer_wait;
> >               /*
> >                * This field has lock-like semantics, meaning it is some=
times
> > @@ -1274,7 +1270,7 @@ struct mm_struct {
> >                * mmap_lock.
> >                */
> >               seqcount_t mm_lock_seq;
> > -#endif
> > +
> >               struct futex_mm_data    futex;
> >
> >               unsigned long hiwater_rss; /* High-watermark of RSS usage=
 */
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 87f77e3da77f..7b2bbb09a952 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -76,8 +76,6 @@ static inline void mmap_assert_write_locked(const str=
uct mm_struct *mm)
> >       rwsem_assert_held_write(&mm->mmap_lock);
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  #ifdef CONFIG_LOCKDEP
> >  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
> >  #else
> > @@ -297,6 +295,9 @@ int __vma_start_write(struct vm_area_struct *vma, i=
nt state);
> >   */
> >  static inline void vma_start_write(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
>
> Nice and neat.
>
> >       if (__is_vma_write_locked(vma))
> >               return;
> >
> > @@ -319,6 +320,9 @@ static inline void vma_start_write(struct vm_area_s=
truct *vma)
> >  static inline __must_check
> >  int vma_start_write_killable(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return 0;
> > +
> >       if (__is_vma_write_locked(vma))
> >               return 0;
> >
> > @@ -331,6 +335,11 @@ int vma_start_write_killable(struct vm_area_struct=
 *vma)
> >   */
> >  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU)) {
> > +             mmap_assert_write_locked(vma->vm_mm);
> > +             return;
> > +     }
> > +
>
> Hmm don't love that this kinda reinstates the fallback, but I guess nommu
> may as well get the appropriate mmap equivalent check.

Yeah, I want this assertion to work correctly in NOMMU case instead of
being just a NOOP.

>
> >       VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
> >  }
> >
> > @@ -432,6 +441,9 @@ static inline bool vma_is_attached(struct vm_area_s=
truct *vma)
> >   */
> >  static inline void vma_assert_attached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       WARN_ON_ONCE(!vma_is_attached(vma));
> >  }
> >
> > @@ -442,6 +454,9 @@ static inline void vma_assert_detached(struct vm_ar=
ea_struct *vma)
> >
> >  static inline void vma_mark_attached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
> >       vma_assert_write_locked(vma);
> >       vma_assert_detached(vma);
> >       refcount_set_release(&vma->vm_refcnt, 1);
> > @@ -451,6 +466,9 @@ void __vma_exclude_readers_for_detach(struct vm_are=
a_struct *vma);
> >
> >  static inline void vma_mark_detached(struct vm_area_struct *vma)
> >  {
> > +     if (!IS_ENABLED(CONFIG_MMU))
> > +             return;
> > +
>
> OK all the least-worse means of handling nommu like it :)
>
> >       vma_assert_write_locked(vma);
> >       vma_assert_attached(vma);
> >
> > @@ -484,54 +502,6 @@ struct vm_area_struct *lock_next_vma(struct mm_str=
uct *mm,
> >                                    struct vma_iterator *iter,
> >                                    unsigned long address);
> >
> > -#else /* CONFIG_PER_VMA_LOCK */
> > -
> > -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> > -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> > -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> > -
> > -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm,=
 unsigned int *seq)
> > -{
> > -     return false;
> > -}
> > -
> > -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, uns=
igned int seq)
> > -{
> > -     return true;
> > -}
> > -static inline void vma_lock_init(struct vm_area_struct *vma, bool rese=
t_refcnt) {}
> > -static inline void vma_end_read(struct vm_area_struct *vma) {}
> > -static inline void vma_start_write(struct vm_area_struct *vma) {}
> > -static inline __must_check
> > -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> > -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> > -             { mmap_assert_write_locked(vma->vm_mm); }
> > -static inline bool vma_is_attached(struct vm_area_struct *vma)
> > -             { return true; }
> > -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> > -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> > -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> > -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> > -
> > -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_stru=
ct *mm,
> > -             unsigned long address)
> > -{
> > -     return NULL;
> > -}
> > -
> > -static inline void vma_assert_locked(struct vm_area_struct *vma)
> > -{
> > -     mmap_assert_locked(vma->vm_mm);
> > -}
> > -
> > -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> > -{
> > -     /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> > -     mmap_assert_locked(vma->vm_mm);
> > -}
> > -
> > -#endif /* CONFIG_PER_VMA_LOCK */
> > -
> >  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
> >  {
> >       if (vma_is_attached(vma))
> > diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> > index 41fe87d7302f..b15ee4b9ac4e 100644
> > --- a/kernel/bpf/stackmap.c
> > +++ b/kernel/bpf/stackmap.c
> > @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
> >  /*
> >   * Acquire a stable read-side reference on the VMA covering @ip.
> >   *
> > - * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VMA re=
ad
> > - * lock held and mmap_lock dropped, so the caller may sleep.
> > - *
> > - * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock still
> > - * held; the caller must snapshot any fields it needs and pin vm_file
> > - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> > - * the VMA may be split, merged, or freed after that.
> > + * This returns a VMA with its per-VMA read lock held and mmap_lock
> > + * dropped, so the caller may sleep.
>
> As per sub-thread, this should be updated as per Matthew's suggestion.
>
> But also - if !CONFIG_MMU it returns with the mmap lock held. Have you
> audited all callers to make sure they correctly handle this?

That's how it worked before this change, the only difference is that
instread of using #ifdef CONFIG_PER_VMA_LOCK we use #ifdef CONFIG_MMU.

>
> >   *
> >   * Returns NULL on failure, in which case no lock is held.
> >   */
> > @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock,=
 unsigned long ip)
> >       struct mm_struct *mm =3D lock->mm;
> >       struct vm_area_struct *vma;
> >
> > -     /* noop under !CONFIG_PER_VMA_LOCK */
> >       vma =3D lock_vma_under_rcu(mm, ip);
>
> Hmm what does this do in nommu?

It would return NULL because all VMAs are detached in NOMMU case. So,
it's pretty much a NOOP.

>
> This is the only place I think that nommu would ever call this function,
> why not just avoid the possibility that this does something wrong (and
> confusion around that and instead do:
>
>         if (IS_ENABLED(CONFIG_MMU) && (vma =3D lock_vma_under_rcu(mm, ip)=
)) {
>                 lock->vma =3D vma;
>                 return vma;
>         }
>
> Or if that's too cute then obviously:
>
>         if (IS_ENABLED(CONFIG_MMU)) {
>                 vma =3D lock_vma_under_rcu(mm, ip);
>                 if (vma) {
>                         lock->vma =3D vma;
>                         return vma;
>                 }
>         }
>
> Or you could do a:
>
>         if (!IS_ENABLED(CONFIG_MMU))
>                 return NULL;
>
> At the start of lock_vma_under_rcu()?

Yes!

>
> >       if (vma) {
> >               lock->vma =3D vma;
> > @@ -308,21 +302,20 @@ stack_map_lock_vma(struct stack_map_vma_lock *loc=
k, unsigned long ip)
> >               return NULL;
> >       }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >       if (!vma_start_read_locked(vma)) {
> >               mmap_read_unlock(mm);
> >               return NULL;
> >       }
> >       mmap_read_unlock(mm);
> >  #endif
> > -
>
> This all feels like vma_start_read_unlocked() in not so many words :)
>
> It's a bit catch-22 so maybe worth still doing the code this way for now
> maybe with a comment saying it'll get get updated to use
> vma_start_read_unlocked() later and changing it in that patch?
>
> It feels like it'd be a nice simplification!

Yes, I think you are right. I'll try this simplification in the next versio=
n.

>
> >       lock->vma =3D vma;
> >       return vma;
> >  }
> >
> >  static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
> >  {
> > -#ifdef CONFIG_PER_VMA_LOCK
> > +#ifdef CONFIG_MMU
> >       vma_end_read(lock->vma);
> >  #else
> >       mmap_read_unlock(lock->mm);
> > diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> > index e791ae065c39..245f74ec491d 100644
> > --- a/kernel/bpf/task_iter.c
> > +++ b/kernel/bpf/task_iter.c
> > @@ -835,7 +835,7 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_it=
er_task_vma *it,
> >       BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(st=
ruct bpf_iter_task_vma));
> >       BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __al=
ignof__(struct bpf_iter_task_vma));
> >
> > -     if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
> > +     if (!IS_ENABLED(CONFIG_MMU)) {
> >               kit->data =3D NULL;
> >               return -EOPNOTSUPP;
> >       }
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index f0e2e131a9a5..ff91f5f66c80 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1077,9 +1077,7 @@ static void mmap_init_lock(struct mm_struct *mm)
> >  {
> >       init_rwsem(&mm->mmap_lock);
> >       mm_lock_seqcount_init(mm);
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       rcuwait_init(&mm->vma_writer_wait);
> > -#endif
> >  }
> >
> >  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_str=
uct *p)
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 331daf7fcfab..1503e2131b49 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1429,18 +1429,6 @@ config LRU_GEN_WALKS_MMU
> >       depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> >  # }
> >
> > -config ARCH_SUPPORTS_PER_VMA_LOCK
> > -       def_bool n
> > -
> > -config PER_VMA_LOCK
> > -     def_bool y
> > -     depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> > -     help
> > -       Allow per-vma locking during page fault handling.
> > -
> > -       This feature allows locking each virtual memory area separately=
 when
> > -       handling page faults instead of taking mmap_lock.
> > -
> >  config LOCK_MM_AND_FIND_VMA
> >       bool
> >       depends on !STACK_GROWSUP
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index 5737a504efbb..1dd150edfe71 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
> >
> >  config PER_VMA_LOCK_STATS
> >       bool "Statistics for per-vma locks"
> > -     depends on PER_VMA_LOCK
> >       help
> >         Say Y here to enable success, retry and failure counters of pag=
e
> >         faults handled under protection of per-vma locks. When enabled,=
 the
> > diff --git a/mm/debug.c b/mm/debug.c
> > index 9a0297b3988d..655e6bcc0e8d 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struct *vma)
> >       pr_emerg("vma %px start %px end %px mm %px\n"
> >               "prot %lx anon_vma %px vm_ops %px\n"
> >               "pgoff %lx file %px private_data %px\n"
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               "refcnt %x\n"
> > -#endif
> >               "flags: %#lx(%pGv)\n",
> >               vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_=
mm,
> >               (unsigned long)pgprot_val(vma->vm_page_prot),
> >               vma->anon_vma, vma->vm_ops, vma_start_pgoff(vma),
> >               vma->vm_file, vma->vm_private_data,
> > -#ifdef CONFIG_PER_VMA_LOCK
> >               refcount_read(&vma->vm_refcnt),
> > -#endif
> >               vma->vm_flags, &vma->vm_flags);
> >  }
> >  EXPORT_SYMBOL(dump_vma);
> > diff --git a/mm/init-mm.c b/mm/init-mm.c
> > index 3e792aad7626..a1bb2c2d0284 100644
> > --- a/mm/init-mm.c
> > +++ b/mm/init-mm.c
> > @@ -39,10 +39,8 @@ struct mm_struct init_mm =3D {
> >       .page_table_lock =3D  __SPIN_LOCK_UNLOCKED(init_mm.page_table_loc=
k),
> >       .arg_lock       =3D  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
> >       .mmlist         =3D LIST_HEAD_INIT(init_mm.mmlist),
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       .vma_writer_wait =3D __RCUWAIT_INITIALIZER(init_mm.vma_writer_wai=
t),
> >       .mm_lock_seq    =3D SEQCNT_ZERO(init_mm.mm_lock_seq),
> > -#endif
> >  #ifdef CONFIG_SCHED_MM_CID
> >       .mm_cid.lock =3D __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
> >  #endif
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6ae52e3869b1..65e5fdf4f824 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -6814,7 +6814,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_=
area_struct *vma,
> >                                !is_cow_mapping(vma->vm_flags)))
> >                       return VM_FAULT_SIGSEGV;
> >       }
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT becau=
se of
> >        * the assumption that lock is dropped on VM_FAULT_RETRY.
> > @@ -6823,7 +6822,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_=
area_struct *vma,
> >                       (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =
=3D=3D
> >                       (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
> >               return VM_FAULT_SIGSEGV;
> > -#endif
> >
> >       return 0;
> >  }
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 898c2ef1e958..e20d01e8d38f 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struct mm_struct *=
mm, bool write)
> >  EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> >  #endif /* CONFIG_TRACING */
> >
> > -#ifdef CONFIG_MMU
> > -#ifdef CONFIG_PER_VMA_LOCK
> > -
> >  /* State shared across __vma_[start, end]_exclude_readers. */
> >  struct vma_exclude_readers_state {
> >       /* Input parameters. */
> > @@ -431,7 +428,6 @@ struct vm_area_struct *lock_next_vma(struct mm_stru=
ct *mm,
> >
> >       return vma;
> >  }
> > -#endif /* CONFIG_PER_VMA_LOCK */
> >
> >  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
> >  #include <linux/extable.h>
> > @@ -548,23 +544,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct=
 mm_struct *mm,
> >       return NULL;
> >  }
> >  #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
> > -
> > -#else /* CONFIG_MMU */
> > -
> > -/*
> > - * At least xtensa ends up having protection faults even with no
> > - * MMU.. No stack expansion, at least.
> > - */
> > -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
> > -                     unsigned long addr, struct pt_regs *regs)
> > -{
> > -     struct vm_area_struct *vma;
> > -
> > -     mmap_read_lock(mm);
> > -     vma =3D vma_lookup(mm, addr);
> > -     if (!vma)
> > -             mmap_read_unlock(mm);
> > -     return vma;
> > -}
> > -
> > -#endif /* CONFIG_MMU */
>
> Oh lovely to get rid of this :)
>
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index ed4860c01936..fbcf64c59a97 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(struct mm_s=
truct *mm,
> >  static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> >                                        enum page_walk_lock walk_lock)
> >  {
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> >               vma_start_write(vma);
> > @@ -461,7 +460,6 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               /* PGWALK_RDLOCK is handled by process_mm_walk_lock */
> >               break;
> >       }
> > -#endif
> >  }
> >
> >  /*
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index b917431759ee..4e4a4b747977 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct vm_area_st=
ruct *dst,
> >       /* For the anon_vma to be compatible, it can only be singular. */
> >       VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
> >                       !list_is_singular(&src->anon_vma_chain));
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /* Only merging an unfaulted VMA leaves the destination attached.=
 */
> >       VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
> >                       vma_is_attached(dst));
>
> Yeah this should be fine as VMAs are always !vma_is_attached() for nommu.
>
> > -#endif
> >  }
> >
> >  static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 258b03182a78..edd90892f8cc 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -122,7 +122,6 @@ struct vm_area_struct *find_vma_and_prepare_anon(st=
ruct mm_struct *mm,
> >       return vma;
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  /*
> >   * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
> >   * @mm: mm to search vma in.
> > @@ -182,34 +181,6 @@ static void uffd_mfill_unlock(struct vm_area_struc=
t *vma)
> >       vma_end_read(vma);
> >  }
> >
> > -#else
> > -
> > -static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm=
,
> > -                                           unsigned long dst_start,
> > -                                           unsigned long len)
> > -{
> > -     struct vm_area_struct *dst_vma;
> > -
> > -     mmap_read_lock(dst_mm);
> > -     dst_vma =3D find_vma_and_prepare_anon(dst_mm, dst_start);
> > -     if (IS_ERR(dst_vma))
> > -             goto out_unlock;
> > -
> > -     if (validate_dst_vma(dst_vma, dst_start + len))
> > -             return dst_vma;
> > -
> > -     dst_vma =3D ERR_PTR(-ENOENT);
> > -out_unlock:
> > -     mmap_read_unlock(dst_mm);
> > -     return dst_vma;
> > -}
> > -
> > -static void uffd_mfill_unlock(struct vm_area_struct *vma)
> > -{
> > -     mmap_read_unlock(vma->vm_mm);
> > -}
> > -#endif
> > -
> >  static void mfill_put_vma(struct mfill_state *state)
> >  {
> >       if (!state->vma)
> > @@ -1852,7 +1823,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
> >       return 0;
> >  }
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >  static int uffd_move_lock(struct mm_struct *mm,
> >                         unsigned long dst_start,
> >                         unsigned long src_start,
> > @@ -1927,31 +1897,6 @@ static void uffd_move_unlock(struct vm_area_stru=
ct *dst_vma,
> >               vma_end_read(dst_vma);
> >  }
> >
> > -#else
> > -
> > -static int uffd_move_lock(struct mm_struct *mm,
> > -                       unsigned long dst_start,
> > -                       unsigned long src_start,
> > -                       struct vm_area_struct **dst_vmap,
> > -                       struct vm_area_struct **src_vmap)
> > -{
> > -     int err;
> > -
> > -     mmap_read_lock(mm);
> > -     err =3D find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, s=
rc_vmap);
> > -     if (err)
> > -             mmap_read_unlock(mm);
> > -     return err;
> > -}
> > -
> > -static void uffd_move_unlock(struct vm_area_struct *dst_vma,
> > -                          struct vm_area_struct *src_vma)
> > -{
> > -     mmap_assert_locked(src_vma->vm_mm);
> > -     mmap_read_unlock(dst_vma->vm_mm);
> > -}
> > -#endif
> > -
> >  /**
> >   * move_pages - move arbitrary anonymous pages of an existing vma
> >   * @ctx: pointer to the userfaultfd context
> > diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> > index 4764d7b68f2a..f4fa54616085 100644
> > --- a/rust/kernel/mm.rs
> > +++ b/rust/kernel/mm.rs
> > @@ -170,30 +170,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::=
mm_struct) -> &'a MmWithUser {
> >      ///
> >      /// This is an optimistic trylock operation, so it may fail if the=
re is contention. In that
> >      /// case, you should fall back to taking the mmap read lock.
> > -    ///
> > -    /// When per-vma locks are disabled, this always returns `None`.
> >      #[inline]
> >      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaRea=
dGuard<'_>> {
> > -        #[cfg(CONFIG_PER_VMA_LOCK)]
> > -        {
> > -            // SAFETY: Calling `bindings::lock_vma_under_rcu` is alway=
s okay given an mm where
> > -            // `mm_users` is non-zero.
> > -            let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_=
raw(), vma_addr) };
> > -            if !vma.is_null() {
> > -                return Some(VmaReadGuard {
> > -                    // SAFETY: If `lock_vma_under_rcu` returns a non-n=
ull ptr, then it points at a
> > -                    // valid vma. The vma is stable for as long as the=
 vma read lock is held.
> > -                    vma: unsafe { VmaRef::from_raw(vma) },
> > -                    _nts: NotThreadSafe,
> > -                });
> > -            }
> > +        // SAFETY: Calling `bindings::lock_vma_under_rcu` is always ok=
ay given an mm where
> > +        // `mm_users` is non-zero.
> > +        let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_raw(=
), vma_addr) };
> > +        if vma.is_null() {
> > +            return None;
> >          }
> > -
> > -        // Silence warnings about unused variables.
> > -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> > -        let _ =3D vma_addr;
> > -
> > -        None
> > +        Some(VmaReadGuard {
> > +            // SAFETY: If `lock_vma_under_rcu` returns a non-null ptr,=
 then it points at a
> > +            // valid vma. The vma is stable for as long as the vma rea=
d lock is held.
> > +            vma: unsafe { VmaRef::from_raw(vma) },
> > +            _nts: NotThreadSafe,
> > +        })
> >      }
> >
> >      /// Lock the mmap read lock.
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/includ=
e/dup.h
> > index 800e5fa02d78..362feda28526 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -582,7 +582,6 @@ struct vm_area_struct {
> >               vma_flags_t flags;
> >       };
> >
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /*
> >        * Can only be written (using WRITE_ONCE()) while holding both:
> >        *  - mmap_lock (in write mode)
> > @@ -598,7 +597,7 @@ struct vm_area_struct {
> >        * slowpath.
> >        */
> >       unsigned int vm_lock_seq;
> > -#endif
> > +
> >       unsigned int __vm_virt_pgoff_lo;
>
> Similar rebase issue here :)
>
> >
> >       /*
> > @@ -632,10 +631,8 @@ struct vm_area_struct {
> >  #ifdef CONFIG_NUMA_BALANCING
> >       struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
> >  #endif
> > -#ifdef CONFIG_PER_VMA_LOCK
> >       /* Unstable RCU readers are allowed to read this. */
> >       refcount_t vm_refcnt;
> > -#endif
> >  #ifdef CONFIG_64BIT
> >       unsigned int __vm_virt_pgoff_hi;
>
> And here.
>
> Anyway, since this is for 7.4 I guess, you will need to be fairly
> rebase-happy anyway as things evolve! :)

Yes, will rebase over the latest mm-unstable.
Thanks for the review, Lorenzo!

>
> >  #endif
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_i=
nternal.h
> > index 8a48b231aa7a..54d5c3360aa2 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -15,7 +15,6 @@
> >  #include <stdlib.h>
> >
> >  #define CONFIG_MMU           1
> > -#define CONFIG_PER_VMA_LOCK  1
> >
> >  #ifdef __CONCAT
> >  #undef __CONCAT
> > --
> > 2.55.0.654.g21b8a5bc05-goog
> >
>
> --
> Cheers, Lorenzo

