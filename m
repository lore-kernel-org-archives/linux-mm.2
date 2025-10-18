Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9142CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 15:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E24C8E0005; Sat, 18 Oct 2025 11:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B4A8E0002; Sat, 18 Oct 2025 11:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2327C8E0005; Sat, 18 Oct 2025 11:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4268E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 11:32:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2EF61A04D8
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:32:17 +0000 (UTC)
X-FDA: 84011626314.02.AE6861F
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id A14B380010
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 15:32:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V5K0NDa3;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760801535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VsDvzwluOWLRYb/lK+lEAn58q7ZQz+5TWTRfSTNft4=;
	b=K2Q2J+syIVmNkBwdT2X/tDQDPcJML1iG1Au5vQrI9l4MGX4vDVYRaUoafUN923W3jj9e+i
	P5CaiMyN7nMoe7wsQ5OXUsQe7bCKzMQ0xYO6oevgGg7ACuzW1SpAUJcgMHpJjJhThMPgEH
	U3p6Cw4b7WRgKA5DFilKvLSEIT7aToM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=V5K0NDa3;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760801535; a=rsa-sha256;
	cv=none;
	b=7ujGteu3kMPTQNyGjQe026NWWu/uaHOmrWT7wqLJ5aahFK6Z5+qtGOoHqLeczgodCYD++Y
	v7TNxPewcpXPgQIsGAXuUaE4NZ0jjhwIDFCglie043q6jQJonA9kWbWvSf2DMt1EHGem2P
	i2k7YgcLy6OaZsJNw/j14SrAVVIf0Bk=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-63c2d72582cso2634910a12.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 08:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760801534; x=1761406334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VsDvzwluOWLRYb/lK+lEAn58q7ZQz+5TWTRfSTNft4=;
        b=V5K0NDa3p8aL/EV5Yov+HUrf6Y67gvxp9FDPvVc2thYHyWl2rixk2hkKh2ym6cOLEe
         61YcypIInp8YKnxw3mqjRzHgkEGEQyM6qUiAjZiAYl2SjbwmE826YkJJ0xNFnPdJo1qk
         U2DRO3NiZ5Lx2fJJSvLAFUqXZKLVFv7CIw9fPCXfDfnIQzMefdbBvbYXOFYpcqcSzrC/
         MMx2jC2F6RwxNIozYnr3uZhIxtEYPfevfZAAHhskB/m91foAYvNAgjmwiVpzSe9Dcyu0
         mIuyq3KDplqzuscWdmpVi7tEKZ+HgrHcpQxdBe41EJ4H+Y4ymAM5E5YORGxUaex5Hmv3
         DdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760801534; x=1761406334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9VsDvzwluOWLRYb/lK+lEAn58q7ZQz+5TWTRfSTNft4=;
        b=gDR3Exm5Nvucqv0uI1ZBDY5F6qm55hkUG7RO1/OIw7u/BrcbG7X4eOU0IDUV8pCqjO
         uPEtVoP54IbEax2koj3JL+ZQXJYn7/EdfeprREMIsFWEkSclVeYcUZ4/B+/QWiCYvmFI
         O1c3d5qi+9AkLWbtj45BYaAybn4Smi+i4tblHhxiOXZ6zyLA29qCAdpbTlhFXlZdeb+K
         PwP7IkCCt6n4oDuai6ie7+ru5bQCZ0f8aJuGThjOaw+ypganRheI6cdQeMi/BKGTzEWN
         KepKptuj4QEkPlk2w2eV/rJHzu+YSay5m9wxuC5FH8De6fAqFs1MNpP7RLi/vZrZL/As
         rJcw==
X-Forwarded-Encrypted: i=1; AJvYcCXzjivAvOEG+ot41njB/94WXtu87XBNz0XYOc50UESsUXBuGavCKh8Glcm+CLKIMiLfNhU3oZF3gw==@kvack.org
X-Gm-Message-State: AOJu0Yz55HQ73Pdu4kQKu4yeVv+5Mzrqhb0Q/bHdWVvgNeDxsuivHutx
	BwAfX7+bT4jxNUURoAtzenEp68gXba8V0DIRUX+JNn3KCJchmYqMxPPfjC3LWXBL2wcJE4G5b1s
	ar10sutvqSR2kOkyAl6pL/8w4j+y6M31ASU66fn/JDg==
X-Gm-Gg: ASbGnctM5ybK4Nvgv5AFMDrcZZ3MF4QdPHMBQRleVTWzTlcEiGpxW6VH5d/kS8p0gOn
	N2yu7Okf6hpH0mttpdekK+h/jyu1pQdwKrB4ruRLoLumoI+q4W55BBgiSj5YR3+mLcPSpJ8iElz
	twtAxwZDXEU6i9TC+J8RQ76lOjSOItJW9odc0PoMW3u5gIJkzo4GjXcSxhITr01OXCHy35ZWn2z
	yzfATvPYoFxaKilo70w8InLz1LdJ2McveAzmU0FzTSc1yAttUuZDagDiq8Bck2DiXYV7gIdkMjC
	ObfAM1MFUJ240ayC
X-Google-Smtp-Source: AGHT+IF3cipF6bc/oqKvCyt+BiwXJFIE1+mPSjPv6l90gLXlAbCAIy8PMbygYaIUPYg1G8/+J8KtWKzhzNqhtzHIHeY=
X-Received: by 2002:a50:c949:0:b0:637:e271:8071 with SMTP id
 4fb4d7f45d1cf-63c1f6d5dd8mr5412618a12.27.1760801534100; Sat, 18 Oct 2025
 08:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-2-pasha.tatashin@soleen.com> <aO9ZiERHff7vQiBL@kernel.org>
 <CA+CK2bA5Eyz6TUMTy3pa5HBvZ7KkiHX3EHn17T=d6LX_X5i3bg@mail.gmail.com> <aPEqDfajAlNnhoeN@kernel.org>
In-Reply-To: <aPEqDfajAlNnhoeN@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 18 Oct 2025 11:31:37 -0400
X-Gm-Features: AS18NWAgHFUQgLd3GmKT5ixSVjoVgRSpizTftBZSz0idzsJU9vI8LHQCq5QGRPk
Message-ID: <CA+CK2bDkc9POgvZpHFWzTsbic6UjExU+YN5SO=D-ODaHQRMTFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A14B380010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: stn66m3bkuenf5q76c66ozwruiz1s6hq
X-HE-Tag: 1760801535-460038
X-HE-Meta: U2FsdGVkX1+gD1ITwttMo+iBJMnCh9EkTsjq8HaEGRdX3T9B8i0YCMdDpFdbGh+OOurPuxfsI0lGB9woVVboeuit6vLFQGcZBVA06c3htIV48L+c25ITEy2YXPH4JS+i0nVaMuOo9HOZTOuUOaJN+Y0infh8e76ctqi59KzbVeC+YJEpnBLuHe3zQ+Gkk5GEbcXWJkQDcV8LXw+n2jbZJoEra79GDWtGgHWgDkb/+Uf3BddH22aOQdIth0bcabcR5+z8GqofwYxMlsKDJKRVSxh3i7Ysa/nWxkI0VMN673C+e8rgE4NimpPNzDjmpiJOsJr6X1P9T6Lh/20SlsX1IPQY2xDnccLHX3PbO2SrYwBvCUYbrPN8VfFN+/9ElduEVZGuNQXjlJ3vxXXpl6cnMWvZW84RqdB/xzv9TsL3VZ5rl0EtZEMNiGXajY30BiuYEYNA1Tr3lPJFGQAcG9Fbx+Xgp9QmGQw6wdVu2FVNbVQD3s42/8bxy5uniU94jwRjFGM3RHt0YxTEgQ4XdqRiuJcyWp60QugQGntxzna9n3vuzr2NIS/+86dNkxujkas4oCDhv314aO9Yw+SbPb36CPCJlhccfrKK9dxbR28MzVTQ3KR0hJYJRkjVg/J2Q1pX+eUOI+7cYHspRU+E4M1HaOVx55gSb+QQ4yBLCXQX59l7Zhtd01hD7TyD+uSMDPcpD9ooL66WFSgLbQ/kZyGQxF1B+As7RKPZoH9FB5T9qtWySDBA2DBHyhYkzkFjcJdqsSgeUbsnacXIQvEDGDMBSwMuzSsrBW0pKKyTCPdp7l59wIFUv3o6J5xkzDwD1UeOT3iABNjwt7Fd9xLbFl6FFMkzkl9x+kNQiouPFZz9wfhFQc5qBgo9/jRZE2PfdBd7+YRJZxgS2iFFEokLzhhqjVMezayrFufbFkHObeCo+ybRC57X6FNUnOCzBibISmSF1IUHP/7EAvZFI5AYkR9
 NRI8szRr
 LLbzGYo+CG5VsUqHc22NqkVYmmeadTST4no6ljI2wz8hE1cT9GXk9kWiLm12Zr5gbB8wrJGZgX7dL2ZziDEPPAWHdl8lyNFrwF2shAvO+63x6BrU6S1Lr5uIUzZWCfagvgZZ8T8jbTsgLuzbI8LRuPxKB0cdaTH5CGD/ZOkRFlBBAFNWyIP8HKqPbewlULbpNi0xvbXJqctgSScwZWQT8t/rUFwIkUxQ+rXX8ylMpCmrPBfsd3swtNN1I0jyddHtWLZNXrSOWy/8/XK1K9qxIrv/nHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 1:23=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Oct 15, 2025 at 08:36:25AM -0400, Pasha Tatashin wrote:
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > ---
> > > >  kernel/liveupdate/Kconfig                   | 15 ++++++++++
> > >
> > > Feels like kernel/liveupdate/Makefile change is missing
> >
> > It's not, we already have KEXEC_HANDOVER_DEBUGFS that pulls in
> > kexec_handover_debug.c
> >
> > That debug file contains KHO debugfs and debug code. The debug code
> > adds KEXEC_HANDOVER_DEBUGFS as a dependency, which I think is
> > appropriate for a debug build.
> >
> > However, I do not like ugly ifdefs in .c, so perhaps, we should have tw=
o files:
> > kexec_handover_debugfs.c for debugfs and kexec_handover_debug.c ? What
> > do you think?
> >
> > > >  kernel/liveupdate/kexec_handover.c          | 32 +++++++++++++++++=
+---
> > > >  kernel/liveupdate/kexec_handover_debug.c    | 18 ++++++++++++
> > > >  kernel/liveupdate/kexec_handover_internal.h |  9 ++++++
> > > >  4 files changed, 70 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > > > index 522b9f74d605..d119f4f3f4b1 100644
> > > > --- a/kernel/liveupdate/Kconfig
> > > > +++ b/kernel/liveupdate/Kconfig
> > > > @@ -27,4 +27,19 @@ config KEXEC_HANDOVER_DEBUGFS
> > > >         Also, enables inspecting the KHO fdt trees with the debugfs=
 binary
> > > >         blobs.
> > > >
> > > > +config KEXEC_HANDOVER_DEBUG
> > > > +     bool "Enable Kexec Handover debug checks"
> > > > +     depends on KEXEC_HANDOVER_DEBUGFS
> > > > +     help
> > > > +       This option enables extra sanity checks for the Kexec Hando=
ver
> > > > +       subsystem.
> > > > +
> > > > +       These checks verify that neither preserved memory regions n=
or KHO's
> > > > +       internal metadata are allocated from within a KHO scratch a=
rea.
> > > > +       An overlap can lead to memory corruption during a subsequen=
t kexec
> > > > +       operation.
> > > > +
> > > > +       If an overlap is detected, the kernel will print a warning =
and the
> > > > +       offending operation will fail. This should only be enabled =
for
> > > > +       debugging purposes due to runtime overhead.
> > > >  endmenu
> > > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate=
/kexec_handover.c
> > > > index 5da21f1510cc..ef1e6f7a234b 100644
> > > > --- a/kernel/liveupdate/kexec_handover.c
> > > > +++ b/kernel/liveupdate/kexec_handover.c
> > > > @@ -141,6 +141,11 @@ static void *xa_load_or_alloc(struct xarray *x=
a, unsigned long index, size_t sz)
> > > >       if (!elm)
> > > >               return ERR_PTR(-ENOMEM);
> > > >
> > > > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> > > > +             kfree(elm);
> > >
> > > I think __free() cleanup would be better than this.
> >
> > Sorry, not sure what do you mean. kfree() is already is in this
> > function in case of failure.
>
> There's __free(kfree) cleanup function defined in include/linux/cleanup.h
> that ensures that on return from a function resources are not leaked.
> With kfree we could do something like
>
>         void *elm __free(kfree) =3D NULL;
>
>         if (error)
>                 return ERR_PTR(errno);
>
>         return no_free_ptr(elm);
>
> There's no __free() definition for free_page() though :(
>
> The second best IMHO is to use goto for error handling rather than free()
> inside if (error).

Makes sense, let me try to get it done. I actually like what cleanup.h prov=
ides.

>
> > > > +             return ERR_PTR(-EINVAL);
> > > > +     }
> > > > +
> > > >       res =3D xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> > > >       if (xa_is_err(res))
> > > >               res =3D ERR_PTR(xa_err(res));
> > > > @@ -354,7 +359,13 @@ static struct khoser_mem_chunk *new_chunk(stru=
ct khoser_mem_chunk *cur_chunk,
> > > >
> > > >       chunk =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
> > > >       if (!chunk)
> > > > -             return NULL;
> > > > +             return ERR_PTR(-ENOMEM);
> > >
> > > I don't think it's important to return -errno here, it's not that it'=
s
> > > called from a syscall and we need to set errno for the userspace.
> > > BTW, the same applies to xa_load_or_alloc() IMO.
> >
> > HM, but they are very different errors: ENOMEM, the KHO user can try
> > again after more memory is available, but the new -EINVAL return from
> > this function tells the caller that there is something broken in the
> > system, and using KHO is futile until this bug is fixed.
>
> Do you really see the callers handling this differently?
> And we already have WARN_ON() because something is broken in the system.

Maybe, also maybe for some self-tests. I think it is more consistent
to return PTR_ERR() based on other code in this file (i.e.
xa_load_or_alloc() already uses it). Let's keep it.

>
> > > > +
> > > > +     if (WARN_ON(kho_scratch_overlap(virt_to_phys(chunk), PAGE_SIZ=
E))) {
> > > > +             kfree(chunk);
> > > > +             return ERR_PTR(-EINVAL);
> > > > +     }
> > > > +
>
> --
> Sincerely yours,
> Mike.

