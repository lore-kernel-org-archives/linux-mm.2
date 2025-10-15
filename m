Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACE3CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BB38E0029; Wed, 15 Oct 2025 08:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633278E0020; Wed, 15 Oct 2025 08:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548FB8E0029; Wed, 15 Oct 2025 08:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3D78E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:41:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7981160191
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:41:06 +0000 (UTC)
X-FDA: 84000308532.20.71A1121
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id F00D4C0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:41:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WTU6zJv+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760532065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FipoM8XHkQDqrmj0YxqfPPlg2b8IjYcJe+/Om+8rUJs=;
	b=dlNnS4zB6BGPNvPgign9ZH7O4Wxd8mLdoo26SDuOh4kLhRWJcCcgWF5un3Xm88wXLxlEuR
	6MHLv5WyDqgRHHWSaW0dOobzH3TEnaSZuuYXz95UoQ9hz4qpIpX4BzrlB2UWrA9b5oEFuv
	GqF+PkJ+zsHY2914VfnhixH+DMkqBvQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WTU6zJv+;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760532065; a=rsa-sha256;
	cv=none;
	b=trfOVHObNbbxf6Nklx3RJ5xZ6f8p94o1KZEqXREB1XV78UqqLv540u6yp470EPT8UKgxq7
	Jsi02ZUQBHhsHh7ajHdcXiqUs1y5k8mgJuJDKd8//PKNxBAcLg3oxcZd5FnPCvSZLbqTip
	+sEBmFVXuP340ELPejfwuYm0u9LlgGE=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63bdc7d939fso2997713a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760532063; x=1761136863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FipoM8XHkQDqrmj0YxqfPPlg2b8IjYcJe+/Om+8rUJs=;
        b=WTU6zJv+YGGNjARdC8MFBL80p75k1+ThyswXQ7dOf6V+jRhvZOs2nsamPnG33brYaC
         VnWkyaqRsRgvEk/hzBqCuGex4ru0+1YpYkTTM8Gl2fTEiyUHcrSAbRY1+0hx4l3YiGRn
         Y3VtRYY6UWdMgWe7r7v6H/5VhJyU93MekfhbKSc3pDtmin2Solcq8t4pCw20eWQIevCr
         EZR7RI/LGzFF4++FZO2jVuO008wBWJHkUUriEBS8Lh0k/k5L4uNGp5BCRv63AgHehN7M
         xwXSC8B2hZuZSQvQ4tVWj/lmqN5kczM3g01kiJWUFYhmvjooNxdGPCewm7bKQCuWEh2U
         g7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760532063; x=1761136863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FipoM8XHkQDqrmj0YxqfPPlg2b8IjYcJe+/Om+8rUJs=;
        b=l9pCKzZenz1/b3wyu5lcjjqJRdsayHAb1fAk+RrFwjelTztHPrgH4VLmh8OwwDS8vd
         X+E6HDIyzLxjXMitL0yajmdl8J9ODT1EFJEaWNfQp1rqbSBOvelEEizDDPwsMYA69M8V
         ugb2OBNlZnIEOlr/VxaDlLP36abPcObYvEeP6yn5++hOAsXMYPc4oVBukdjtOXz+KAMT
         4vyWd2diGM6/RTuKK+ULDrravqD4fb8Rb40Nv3Mibg/BfK18l7eCBFTWfkxfUB9kU2Q+
         a+Xo36e7jkmp+bvbf884zIYDZMw+ng0Ac4GSeTPgMQjnb3QbHd2FuDDFBJZoYByHEP+3
         uUSA==
X-Forwarded-Encrypted: i=1; AJvYcCX8bCMACKyAPbsrtrMjbStU5zKN8OcjOjKJz/e4aN26I5W5gNgn5lemLCBPOl4XgIwDVmf0MeLRaw==@kvack.org
X-Gm-Message-State: AOJu0YyMICzjelixA9lWDRoATtJNZHJbi9Fr2mFYgfa0DF6ETqR6raV3
	z1X4NwQiSXZj4JaUgeBQaZFNZ6X+2K+Q1qK1x3+2N35nSvCzsiidmFPSal85ez9HGuFnCEIXXER
	6/vvciK2xMOBRoYJEc6Q+QQkkCYXoTJmnDtyQ+wjP8w==
X-Gm-Gg: ASbGnct8nmFVW89K9ZoC5+pidj+StorH/FFBbZLbOfoLKb46uVSYsWAZMAjity7JqFs
	CrDDhfI3OoOJhMuyITwYS0WsfzsYEVwRAGUpl/0FqsNTltpwFDYTZpkJfknPRjNK8bUfn8l4LXd
	+tebFg3Jlui4VncV6wgWLBjQXq+tU5hC4uFq6Bs0DqRDwds73ZQ9vEt6UQu/WIE7GMMt8r3dYlE
	aCAq1j1kE8e7JlxNyrXkMoynMHM1zYNEw==
X-Google-Smtp-Source: AGHT+IHVW/aOfxAnOknHtkPVdgNnM4tNmxh+uGWj/wtje/WHNOH4EeyB3zfHx5JMTKCACj6PKn5d59raSVcEvzYo1NE=
X-Received: by 2002:a05:6402:3487:b0:639:f548:6894 with SMTP id
 4fb4d7f45d1cf-639f548ba3fmr23286278a12.3.1760532063349; Wed, 15 Oct 2025
 05:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com> <mafs0zf9sjrgc.fsf@kernel.org>
In-Reply-To: <mafs0zf9sjrgc.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 08:40:26 -0400
X-Gm-Features: AS18NWBP9oBjba4zuXY2WUb88hXZWd7h5EjNqKrj5u46Vy6IINb-vIhf0-yb0QU
Message-ID: <CA+CK2bD4z_j_jMhMtrvvQ5nOMEFT6yrRHk9rk7BEiQPSPCHiqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F00D4C0007
X-Stat-Signature: 6hn9i5m6m91axdjc6nsp1zbbukrt4pwz
X-Rspam-User: 
X-HE-Tag: 1760532064-264157
X-HE-Meta: U2FsdGVkX1/gTtUaABwvHRi1XGT2xPc5TQaQkWgdOAnHpI3mAyooW7s0x1kpajAn3gpNjGHKtiPG8W60J0Xh9wXCqRf2fGbkT4h4jSLiLyc9gqmF0Vatnr4lkQahJ17kfoa/LIY+FmoQheMMBA9Czqqtc+Uk9kYhaOy2v+8+KBr2BLF8QkYLFGe76m2qmGM/bMsj39OK56wbyo9C/htsfFEGWtaJajoRmc07+UDRrfaKbkReO7tpJugYrCC8g8OVgJ3KfTa4is+cWg9JFPQyZf4rssKtOris/y4xB9IGMgAdOHu8jQmbB2bYD2EhXhWH3iCtj/VZJe8bzbnpRqijFTOhUtIOC5WWNBaX49aZPQlG/ry/fHK5l1rP48qMT7tVHOEITk1HRR8/bMK8poFUNANT4i7cLL+urgx+tUsC1eObYGgXfr9fyTED7JjlSLs0LldnBKb35xjtzlGLu+nBdVxMoHx4LxNuQvDYlVzf1ru7HL8WAkHB0EmGnznnGUYzvO078yNQBKWPT/MYdiyy8G/HraYwotjY457EYyM7hBQB5WEH2YjEfRrL8ik6vdV7TI7Wer5ePcp5IAkYqnblHfkeDUT4V/V5WM25MaIPkmfvVEoRouPxw87JZAChSdOdCOgTdhv9hF+/KQxOl2wb96CL/W42Da+nVyeeLIhjSLlIpBSGYM4fza1AX0R8c6F3POrJnlwqA/yXO4uEPpon3WVkY+x9JSJ53/JOrBqqj01XN5XGqljSyVNR96lcCGrCU4Gybt1z0F8HX0550X4zIbQZQxMqa7MGjbbeta4XCG9LASFqXUun9TmXVQl8beCcnqknSqH6uc5Q10Kcw3Clsb0JrDK7uPpZl7u9DQeLPlDjCmxIQgH7H2R24dJjo4VnBFdgHGgv13fsU/BJ32jqixXm9nUIv/MpthmW5/9br1COeDt4oxtUEVAD+a0h1yaKGxnGj9mE/0AjmUlgfGA
 WeQ6PSa0
 K2CI1r71j+qBitArNCT6RhSMv0nCYhCwHDamWvQa+CSgWIRvSJDTeKckbna9r3wJRWKWUfCF6nyAyPC4zCf8M5KlwSE0tl4n3R/u1tGWF2VA6w0ZLCkAs/KkxWL02OzNerKz1097Og3R4BoinxGtuBMxU0Cg8/MY0peXkKNe/q3oJ1h4mxzxluvQ52YMjyNTjV4By/FbqtTkXAH/VBo3YPyBMSt2zxa4E0qMC9pQzium45wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 8:10=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Wed, Oct 15 2025, Pasha Tatashin wrote:
>
> > It is invalid for KHO metadata or preserved memory regions to be locate=
d
> > within the KHO scratch area, as this area is overwritten when the next
> > kernel is loaded, and used early in boot by the next kernel. This can
> > lead to memory corruption.
> >
> > Adds checks to kho_preserve_* and KHO's internal metadata allocators
> > (xa_load_or_alloc, new_chunk) to verify that the physical address of th=
e
> > memory does not overlap with any defined scratch region. If an overlap
> > is detected, the operation will fail and a WARN_ON is triggered. To
> > avoid performance overhead in production kernels, these checks are
> > enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/Kconfig                   | 15 ++++++++++
> >  kernel/liveupdate/kexec_handover.c          | 32 ++++++++++++++++++---
> >  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
> >  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
> >  4 files changed, 70 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index 522b9f74d605..d119f4f3f4b1 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
> >         Also, enables inspecting the KHO fdt trees with the debugfs bin=
ary
> >         blobs.
> >
> > +config KEXEC_HANDOVER_DEBUG
> > +     bool "Enable Kexec Handover debug checks"
> > +     depends on KEXEC_HANDOVER_DEBUGFS
>
> Why the dependency on debugfs? Why can't the debug checks be enabled
> independently?

Because there is one kexec_handover_debug.c file, that I thought would
make sense to use for both, but now thinking about this, perhaps we
should split the code: KEXEC_HANDOVER_DEBUGFS and
KEXEC_HANDOVER_DEBUG, and add two files:
kexec_handover_debugfs.c and kexec_handover_debug.c, this would avoid
ifdefs in .c.

>
> > +     help
> > +       This option enables extra sanity checks for the Kexec Handover
> > +       subsystem.
> > +
> > +       These checks verify that neither preserved memory regions nor K=
HO's
> > +       internal metadata are allocated from within a KHO scratch area.
> > +       An overlap can lead to memory corruption during a subsequent ke=
xec
> > +       operation.
>
> I don't think the checks that are done should be listed here since as
> soon as another check is added this list will become out of date.

I thought it could be expanded when new features are added, but I can
remove this description.

>
> > +
> > +       If an overlap is detected, the kernel will print a warning and =
the
> > +       offending operation will fail. This should only be enabled for
>
> This also describes the behaviour of the checks, which might change
> later. Maybe for some checks the operation won't fail? I suppose just
> leave it at "the kernel will print a warning"?

If it changes, and Kconfig should be updated as well.

>
> > +       debugging purposes due to runtime overhead.
> >  endmenu
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 5da21f1510cc..ef1e6f7a234b 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *xa, u=
nsigned long index, size_t sz)
> >       if (!elm)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> > +             kfree(elm);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> >       res =3D xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> >       if (xa_is_err(res))
> >               res =3D ERR_PTR(xa_err(res));
> > @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(struct k=
hoser_mem_chunk *cur_chunk,
> >
> >       chunk =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> >       if (!chunk)
> > -             return NULL;
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZE)))=
 {
> > +             kfree(chunk);
> > +             return ERR_PTR(-EINVAL);
> > +     }
> > +
> >       chunk->hdr.order =3D order;
> >       if (cur_chunk)
> >               KHOSER_STORE_PTR(cur_chunk->hdr.next, chunk);
> > @@ -379,14 +390,17 @@ static int kho_mem_serialize(struct kho_out *kho_=
out)
> >       struct khoser_mem_chunk *chunk =3D NULL;
> >       struct kho_mem_phys *physxa;
> >       unsigned long order;
> > +     int ret =3D -ENOMEM;
> >
> >       xa_for_each(&kho_out->track.orders, order, physxa) {
> >               struct kho_mem_phys_bits *bits;
> >               unsigned long phys;
> >
> >               chunk =3D new_chunk(chunk, order);
> > -             if (!chunk)
> > +             if (IS_ERR(chunk)) {
> > +                     ret =3D PTR_ERR(chunk);
> >                       goto err_free;
> > +             }
> >
> >               if (!first_chunk)
> >                       first_chunk =3D chunk;
> > @@ -396,8 +410,10 @@ static int kho_mem_serialize(struct kho_out *kho_o=
ut)
> >
> >                       if (chunk->hdr.num_elms =3D=3D ARRAY_SIZE(chunk->=
bitmaps)) {
> >                               chunk =3D new_chunk(chunk, order);
> > -                             if (!chunk)
> > +                             if (IS_ERR(chunk)) {
> > +                                     ret =3D PTR_ERR(chunk);
> >                                       goto err_free;
> > +                             }
> >                       }
> >
> >                       elm =3D &chunk->bitmaps[chunk->hdr.num_elms];
> > @@ -414,7 +430,7 @@ static int kho_mem_serialize(struct kho_out *kho_ou=
t)
> >
> >  err_free:
> >       kho_mem_ser_free(first_chunk);
> > -     return -ENOMEM;
> > +     return ret;
> >  }
> >
> >  static void __init deserialize_bitmap(unsigned int order,
> > @@ -737,6 +753,9 @@ int kho_preserve_folio(struct folio *folio)
> >       const unsigned int order =3D folio_order(folio);
> >       struct kho_mem_track *track =3D &kho_out.track;
> >
> > +     if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << o=
rder)))
> > +             return -EINVAL;
> > +
> >       return __kho_preserve_order(track, pfn, order);
> >  }
> >  EXPORT_SYMBOL_GPL(kho_preserve_folio);
> > @@ -784,6 +803,11 @@ int kho_preserve_pages(struct page *page, unsigned=
 int nr_pages)
> >       unsigned long failed_pfn =3D 0;
> >       int err =3D 0;
> >
> > +     if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> > +                                     nr_pages << PAGE_SHIFT))) {
> > +             return -EINVAL;
> > +     }
> > +
> >       while (pfn < end_pfn) {
> >               const unsigned int order =3D
> >                       min(count_trailing_zeros(pfn), ilog2(end_pfn - pf=
n));
> > diff --git a/kernel/liveupdate/kexec_handover_debug.c b/kernel/liveupda=
te/kexec_handover_debug.c
> > index eb47f000887d..294d1d290142 100644
> > --- a/kernel/liveupdate/kexec_handover_debug.c
> > +++ b/kernel/liveupdate/kexec_handover_debug.c
> > @@ -214,3 +214,21 @@ __init int kho_debugfs_init(void)
> >               return -ENOENT;
> >       return 0;
> >  }
> > +
> > +#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
> > +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> > +{
> > +     phys_addr_t scratch_start, scratch_end;
> > +     unsigned int i;
> > +
> > +     for (i =3D 0; i < kho_scratch_cnt; i++) {
> > +             scratch_start =3D kho_scratch[i].addr;
> > +             scratch_end =3D kho_scratch[i].addr + kho_scratch[i].size=
 - 1;
>
> Nit: wouldn't it be a tad bit simpler to do
>
>                 scratch_end =3D kho_scratch[i].addr + kho_scratch[i].size=
;
>
> > +
> > +             if (phys <=3D scratch_end && (phys + size) > scratch_star=
t)
>
> and here
>
>                 if (phys < scratch_end && (phys + size) > scratch_start)
>
> At least I find it slightly easier to understand, though I don't think
> it makes too much of a difference so either way is fine.
>
> > +                     return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
> > diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveu=
pdate/kexec_handover_internal.h
> > index b3fc1957affa..92798346fa5a 100644
> > --- a/kernel/liveupdate/kexec_handover_internal.h
> > +++ b/kernel/liveupdate/kexec_handover_internal.h
> > @@ -44,4 +44,13 @@ static inline void kho_debugfs_fdt_remove(struct kho=
_debugfs *dbg,
> >                                         void *fdt) { }
> >  #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
> >
> > +#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
> > +bool kho_scratch_overlap(phys_addr_t phys, size_t size);
> > +#else
> > +static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> > +{
> > +     return false;
> > +}
> > +#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
> > +
> >  #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
>
> --
> Regards,
> Pratyush Yadav

