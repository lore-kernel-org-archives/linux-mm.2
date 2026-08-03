Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A994EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1AF6B008A; Mon,  3 Aug 2026 13:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862EC6B0092; Mon,  3 Aug 2026 13:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751306B0093; Mon,  3 Aug 2026 13:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBC56B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:45:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE6741C132B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:45:40 +0000 (UTC)
X-FDA: 85060685640.10.20128B3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id F38432000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:45:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X8J9hBuZ;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785779139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BRpMmWn7ih469Fj36TmA1mRpR7obmZjKnWSavtgAWok=;
	b=n5xR6ilIrjE3p3EOhN7aFc4wfLxeOpjGq5Ngsf4KhHDpW9uI6C+QDWIaEh7TAxH42a8akk
	sqrZuMn7TFmKQi/lLCstySzdn+5z3Ft9yHSEhuKHzIaAhO0l6y1XT+JCg3DMdoHnl8UdZa
	lSb95BqnjwfuaZJllyXpRA1mzA374Lk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785779139;
	b=GCvcC2N+emIxu5ZGPS5EIV94i/HpHRJPnVywdp5YOckmR+ZOBT45MQfnXdUt04Yno577PZ
	uymLOLeQSu2T4JK+RENDQhd9X+inmhTUkAETjLG9EHTG49ZywUmfZtcSyjwhK5oJYOJbDD
	Mh/z6Jni8PaYtw8IJ0Gqz987w8BCWIw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X8J9hBuZ;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10ed63c0so12951cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:45:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785779138; cv=none;
        d=google.com; s=arc-20260327;
        b=p2f1HRW+FdUkqTqoHj2mY2mtT5gK85VU2Hw5TnWyM0u+Ix0CTdfKnLRntt6RZGYHMT
         ydXW+yrtfS3o8gYuqraMRFd5XIfehRxcDNM3hh+oHQUOJOhOctlvMUSf5iqY98Quqdwn
         kEeYrYKWsx5EnJJFrQSr7ATbdCy/WKhkgXdxUN7YynoBSNu4iOt65wfWq8oNNOI+dQa/
         V0GHVbzjvpB+KhbZCG9eTpyX6hRbbvOCV2XYnnYWmy6pVtZ3N95bqIcEtPc5zGbRLkOE
         AywmwJeQgQ95KMQ89KyYABapjlsiaqc9cJdYCo3SZiKHfWzjZ7LgNLicRl52cRyLuKcf
         tMvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BRpMmWn7ih469Fj36TmA1mRpR7obmZjKnWSavtgAWok=;
        fh=b6/43zvxFKTcJlVBATSvreN8eOpwSWCCaMmKOCDkMtQ=;
        b=Ov337Z+1iE1BN+o7NW6o+Xk7i4gKoxx/xeEKbIXHy+O6hEn12Uz48qs3frdMvzNVs6
         6o4yeNMOfxwfZ4HhdYR1VcqCFU3zfQQ2qV3em+hGkar+A9yMBsVPRI4a/yvIQ6bMip2X
         4d0o4CLzpOgIF9zHV13qHDW8SfYaQQLAiNn5pQ0agCTjkewDucPmCscwsWrq686bQHiY
         dRQQZGKFnjPeDpyHN4i+lcZwK/ZW4Xbf05e3Ty7UK/PUHQSFpLo4N4JIRB3r4SI9/BVi
         FbYJdvCcbgsecqseb5SUOHbAwRNlyhs8PFzIvK0Mm0yifF5GSjob+mCxYk+4KMU7I+0Z
         qcyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785779138; x=1786383938; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BRpMmWn7ih469Fj36TmA1mRpR7obmZjKnWSavtgAWok=;
        b=X8J9hBuZJO6k97Zn3UEpj+XD/XYFN4IZ00T2zkWoPSwL4QxsASrGce4ALYADPzsuvW
         kpbXQehrwEJzsUy6aZi6eG+9+LURMa49IXI6HCxx7FVtBglgWgDA6FQcpv7CxusT6jlq
         Mf5HgGY4ox3mh1OyXNsx0pCegvXpIYZVhejxXcfnfVLJm5xk7hsr0D/FPNQpNpg/m2WL
         iL9PM7Lrif9DFUvzsUtZXhuleKwyNjBOLAJT3Co99R9EtCO0rg3sLP/1tli0uXojGKOm
         Q6vS3dEWzzFHQeUCxkKwPKfa2tZCLS/S1tu/K5u61cWaNaHTpIA4guyj7ZW00Ubri/N2
         08ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785779138; x=1786383938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BRpMmWn7ih469Fj36TmA1mRpR7obmZjKnWSavtgAWok=;
        b=ZHfDrTqDGuy3VL9AkckkQ9P4rrUQqMn8TZDyQbj5vvB296kce95kcyqyvpWdpK/dan
         n7BlVEArHL3+5cwLdrAtQB8vZryF11kPS2EcsSDb+iHIzbRLK8NzaptxNZVFcZUgbzfA
         MCB2K9FA9MQMtZnJXUov8vlTZgzHPj9BUrQPnR5o8XUwEZ1lhD28UYx1n/7f2Sm7GFCd
         aa3l4WZzCQ27DReiVi+GkF95qYBQhDToEHl3tjbqsTZq/HcJYBxe78vcKy961D/UjsB8
         fuJmbSjiUvCqV9NJbelEstSbZPwsnn9ymy1aIEzIwhBD+noqAb+5ABNxTLjdDVAxnULY
         Jb/A==
X-Forwarded-Encrypted: i=1; AHgh+RrK96cHiOdTxfH9p2Efv7yaOqSQs/cB/3k04Fo8lAFB6vy6Oqknwk3S9o8uDffTKYuTRnD+NN5TAw==@kvack.org
X-Gm-Message-State: AOJu0Yyn1NhKWN/IzVViam41VU5cC52iS4mAVQSoxQ7g4Ap/QwjT9IFX
	GTSIcRifqrkldnBryJSXvXyxtqsgTCZru1UFcOtz5CopMHpbABtfkQciuf87tqNjKQLdcWmOm9T
	v1LgjFflsp2aITMMlGpb+x94kSEFqML7z9jTJD4v1
X-Gm-Gg: AR+sD11ZzfskA1Dr4u4Os2NzbAvOquk9iGvD1URdZiN3dCVA670KBscCsFSmtIDIT4R
	q3htndrdHeHFTDnqwQX/zLyIkTJL7hTNHt6jggbqbHIUsoYBlFut4aPFD/FN7/zgTASaOJUL8+9
	928x8FI4+vlEel/RsEcofdLJa+kdul3Hon7A9RpNr5i232pOKu03luRXGLVjjyYzrpA0MenpbV6
	/4fTR+n4yMUuB+8l+dALJE/8IzAS/lZlCiHu2v4XUrappwsJiZoubLYN8IsxGZJFainKxFmhO/c
	C2cTnN5HTZzGM7VENmTKxYGkiY+Et8zgQAcsIZ5RzGAEQKyyCsCFVA==
X-Received: by 2002:a05:622a:2291:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52cd4fcddfamr586201cf.12.1785779137391; Mon, 03 Aug 2026
 10:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com>
 <anC1iE21eonDK06n@lucifer> <CAJuCfpHNMHKgmP=JLPKY65e6gO6MRpGE5MjUtjd_-2+LHr2Gpg@mail.gmail.com>
In-Reply-To: <CAJuCfpHNMHKgmP=JLPKY65e6gO6MRpGE5MjUtjd_-2+LHr2Gpg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 10:45:26 -0700
X-Gm-Features: AUfX_mxBR2LOxXxJQ1PIuO4cTsQwU7lloBbSc867VOvDBN4dk3ilj-U4-2El9T4
Message-ID: <CAJuCfpE0xtaXd7r3kHPhscox+5siXh5+c0Ssjbz+qLJUFWA4MA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F38432000F
X-Stat-Signature: 9f1ehozfcdrn7mpqtm6r5anwt53smqzg
X-Rspam-User: 
X-HE-Tag: 1785779138-548515
X-HE-Meta: U2FsdGVkX1/xfP06247tvz9ApcJ4W9mmD6ap1sKvC+YaR6PEI90O3cf6TJXI2YTpODDJE63EeXMKqjugeSotvb0+C1ziphvhbpDm34xJnuCFpOlOB0d6NB6NzTGdho4ks8ziY19uhHz+Kbzo5Lm+JOuaz9MCmlYLSBMzwDzy3QicXW2fqF53Qy8cDusLRvfGGhjVA5wPSH59tytWZBcdXkMZfvaYmm9kMsGAJzqEQBBUCiwzavZ77ZU+ScO8BaCxuHMeSc048HwNhtUXDnMeluYnnOBOJ4EGTEyunT5nAN4l+uClWYKl8ESUh/laMGOKnsEp0902VSeZjYnBwOPtKZz5J88h+h5z9ia2DVSzkdsMDWYi94xr/hhvnOtpY/4I1RQKLcVQ8+qvaSfqBjmCtfGrUGwxNTpTuz6y2Mmu5y3rqtcBn+iG55rZZdBMhMaUSh1KKLzrB7QNOYGpEnJjEhaLDf/n8tAC9Lspk3QrKyGohkkPO8+EI8oMtwBRQDaotHrVv9D6mNZ78SdSnI/we/GIla6AhLr8xEgUWSMZNt4F2X7+gZU3mU0So2ABRugkifntrj2TBMLPSLC/UAzZ0ND9VB0yaOvkaKF5TwaNbrb2yA7XNz4H5RAmCVzL3sDYZwyIbZsfTehSIe2HTnRrI7z4hXxovga88NWJNdu5c48HYiJq7leSHO1Di2shkbO08F1iIlI0PX6T8JJjAWmz0zIvqjZE3FwMz8eRMe6OqQ68eF53FHXdMRzHtugQPuhcq/IWV0meRRJy8QcmXoIMmopqCphEyyIPBOf74wtoSoWPu4P4Y5dtac38JmM8yar5eWYMIGXvkvLisCnHIjAWEWbVeDQbGLG23ggryyLPjv15BGL6684dcfdODYjuT5SZJtiG4O7lhcTfMCE1ESMNrJ/zWQ0x0ZiTBe2+cHZA+fpwLXrpz995i2oa7/klG61bk5hMnoeq+UzHfyb1jz9
 wLvQYji8
 c9YUHB3DoackFnfcJR78599GouR9CMxvF+9PIXlbzuJMar6o73/04TduiAVXbd2NzGRTmu1YDRN0K+MleaGv5osgcRhn4vzGPJmZBaOGDDhhPIoH7y/AKV8PZEmmpbPRvtOZUtOSjvqW1m/2KmRK2hbrjdSE8AeEaxICkcaD2bhwEl7c03rIUPZSZ8D20IPp9+k4UKYkLkBzf9Wwl9vkAizQkup+Nq9QICs8teG9rJdz1Ob0GyqTmVzd18VweqKGrVJ4mp+4Ynviyl31p8Sk6t2gXmjh1ty3Vu0Vkw0nygfs+KepIT36SrmS4VisXH//NkVKD/7tgDC/l9qRlvyrwLfD9Zrq0rEOyhyXLTVomP6M5OSYLM7JHrcXmJ8+VjUZasjji/hB3B37CoEOWbmNLjwVeezv3t1cZdd+7w38fJhHmFS/bM5uWxMtFQoMPh4AWMe1vXvMeXDg99/8n38H9NBgNPZS3YpYLZOhpeh5hrMjA7pIN2qzJyxP+9hJ/b/XhR3E0ffMuA14dUSNVue38X9Y6Z/+cS7wj8WWF0ZCwxBX/7zbOroD5n0fSZu3h92KbYOIQJg7H+UIL0U7PMl4EQfQOWS0IF6aSKb1Tkrrd8zhayXSKvTESDjnt+aZyNx820bfweHJxFoLG1FP+a6+tI4+uJZJsvn9gTSAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 10:41=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Aug 3, 2026 at 9:08=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
> >
> > On Mon, Aug 03, 2026 at 08:24:44AM -0700, Suren Baghdasaryan wrote:
> > > On Sun, Aug 2, 2026 at 2:55=E2=80=AFPM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > > >
> > > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > >
> > > > The per-VMA locks have been around for several years. They've had s=
ome
> > > > bugs worked out of them and have seen quite wide use. However, they
> > > > are still only available when architectures explicitly enable them.
> > > > Remove the conditional compilation around the per-VMA locks, making
> > > > them available on all architectures and configs.
> > > >
> > > > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LO=
CK
> > > > when the architecture started using per-VMA locks in the fault
> > > > handler. But, contrary to the naming, the Kconfig option does not
> > > > really indicate whether the architecture supports per-VMA locks or
> > > > not. It is more of a marker for whether the architecture is likely =
to
> > > > benefit from per-VMA locks.
> > > >
> > > > To me, the most important thing side-effect of universal availabili=
ty
> > > > is letting per-VMA locks be used in SMP=3Dn configs. This lets us u=
se
> > > > per-VMA locking in all x86 code without fallbacks.
> > > >
> > > > Overall, this just generally makes the kernel simpler. Just look at
> > > > the diffstat. It also opens the door to users that want to use the
> > > > per-VMA locks in common code. Doing *that* brings additional
> > > > simplifications.
> > > >
> > > > The downside of this is adding some fields to vm_area_struct and
> > > > mm_struct. There are likely ways to optimize this, especially for
> > > > things like SMP=3Dn configs. For now, do the simplest thing: use th=
e
> > > > same implementation everywhere.
> > > >
> > > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > > Cc: linux-mm@kvack.org
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > > > Cc: Todd Kjos <tkjos@android.com>
> > > > Cc: Christian Brauner <christian@brauner.io>
> > > > Cc: Carlos Llamas <cmllamas@google.com>
> > > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: David Ahern <dsahern@kernel.org>
> > > > Cc: netdev@vger.kernel.org
> > > > ---
> >
> > <snip>
> >
> > > > -#endif /* CONFIG_PER_VMA_LOCK */
> > >
> > > Now that I'm looking closer into this, I think we would break NOMMU
> > > case because nommu.c does not take VMA write locks at all. So,
> > > lock_vma_under_rcu() for example would always succeed.
> >
> > I don't think anything's broken actually.
> >
> > Per-VMA locks was gated on CONFIG_MMU so nothing there assumes per-VMA =
flags,
> > but now you have stuff that happens that didn't before but:
> >
> > * vm_area_free() -> vma_assert_detached() - fine - it's always detached=
 in nommu.
> > * vm_area_dup() -> vma_lock_init() - no asserts, just sets refcount to =
0 (correct).
> >
> > AFAICT nothing else.
> >
> > So seems fine to me?
>
> One place that needs fixing is in BPF iterators. They use
> lock_vma_under_rcu() which would always succeeds even if the VMA is
> being modified. Instead of removing !IS_ENABLED(CONFIG_PER_VMA_LOCK)
> check in bpf_iter_task_vma_new() I'll need to change it to
> !IS_ENABLED(CONFIG_MMU).
> I'll look into other parts and try to verify they do not affect NOMMU
> but ultimately I would like to run some tests with this config, which
> is not trivial...
>
> >
> > >
> > > Extra per_VMA lock-related fields in the vm_area_struct and mm_struct
> > > would also inflate NOMMU structure sizes without them being used. I'm
> > > not sure if this is an issue we should consider.
> >
> > As nommu co-maintainer, no it's not :) I won't have that stuff blocking
> > important changes for real arches.
> >
> > Go ahead! :)

Thanks for confirmation!

> >
> > --
> > Cheers, Lorenzo

