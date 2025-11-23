Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 413DCCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 12:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4756B0022; Sun, 23 Nov 2025 07:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4776B0030; Sun, 23 Nov 2025 07:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6947A6B00B0; Sun, 23 Nov 2025 07:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 539836B0022
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 07:16:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05BE18A651
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:16:24 +0000 (UTC)
X-FDA: 84141769530.06.CE3A4D3
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 333E880003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:16:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gy2dblsM;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763900183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmnwA2LRgXHvVpWEUlTYwlypqcI9gTX6hAKhklpoPjU=;
	b=A9Z0HG/XZxF5bFs+Vah4jGqArtuLSnjdhMmIX3BX5tP9ZNpJpnU0M00wUb57QqxDfplyQF
	jnelxzkL4+j7P1lNy1PZWJ3VHsu5jH/PWLcm/cpk1CYPConHUgze3eI4W2EId+vt5305yb
	yVefYrZ1eI69p8jKr1WuocIuWRoLFHs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gy2dblsM;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763900183; a=rsa-sha256;
	cv=none;
	b=UPO9LD1Aicz1OmYZkE/7iBc9qW8EIzKXZiuLpoDTD9sdIw+onk5/w6qrEGd6ANiXVldYGB
	lDMr4tptgYK1LwMQvLOxfbKzXiOYpVlN2VFcgAx5vY1ijwAC0w9o7R/Qff6pEaSupSzXnU
	mT0ipMpsIOH5flo4nu8B+TsVfs9AjHI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so5442270a12.2
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 04:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763900181; x=1764504981; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmnwA2LRgXHvVpWEUlTYwlypqcI9gTX6hAKhklpoPjU=;
        b=gy2dblsMY9iUz3yaOCMrzo4CAyoWzKBgW3WIxJtUxVgUQd9u4tvPjQx5Qj0ZSrqEGZ
         pYYHnCsk4kIjIHzWDgOt6s2aRmLWm14NdhaGPmEn3xRrA0P06OsnY79SI+jW3q9rJnTr
         bIFFJ+frGaHbliX1HEeTQvVNqzhIsidsKXoD0NLD7LjeCbeipv30skId9ZFhkwNxfz4a
         vxc4YQ1/OcuT0dRTcum9i7wLCtGLhxpKsU6Vw5nN1/6S+YkanCAYg+g8KfNp2y4AtUb3
         ZrwHuCo94MhKjuDG8la4mdxs95ZwfXrH1dl+ze/YfVmHnmpS/0cFSNtoMXph83ZA4sLD
         VU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763900181; x=1764504981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vmnwA2LRgXHvVpWEUlTYwlypqcI9gTX6hAKhklpoPjU=;
        b=o76EpN0Z/aG38H7ERAGG9k3gk4jrV82LkT+jAIpeTamDMrsncLzBM3PeCy6aLx2Cxy
         xeMKUO3GGq5VENLLzIvjB0/s4MohMiltcMbLyqrevMKkQDXpcqE/kmsaa+YkvVn5R9Sr
         DQkC36bLvrlMyP8iLI9B23uG11HbXW/5/beXjpiNdzNEP7cy4EzoN63jVzhi3hYmoLWY
         frSUcW/tkv/AcF9hpjyOsI9pSlMz5g7UxoQadCbUj282mnP8hRZFHoFmCggdQzoD/TBR
         LTm5YL3YGqQskfWlpcmZ5k/dCRwj+Z85BezuAQYItAnNiJxwn2lpH9cA6O72BohG0Bxj
         zZwA==
X-Forwarded-Encrypted: i=1; AJvYcCXSNbsDSwT2WU6GFgL8jW/ylBpAUozkjeU5UHa9f458Ta4DihjmQUr78Brgb7k+S2T8/kWfoRNmvQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4n1yg4PwXKsGu7jzA6WI7Mivkm122ywoaOSMhEZrhdeKgXuAp
	U2xdGx6Ua005VHCNPXj76UdWDXkFYxSvVyexklThABYqJq1zO/ZziTiFWSptohUUMCVm2Yj3Y3t
	hqAKDYR5PssxqJ3k7ViSGoMYGnhsULaEOLuNOSg8qLg==
X-Gm-Gg: ASbGncuR71I/LY091a5b1Y0z2qLyvSQWMQQybEgQ/sT8mKU4GHInh8kojKLcNzrrKFW
	BU1z1T6VAVIH+SynaQgi/x8VIh7CGCB9r3Jtc6DqkcSocA5PJrmSbp+m5vrZB4xlVzMS9gpRmNJ
	UxPDKNjNAWQ3QZf/NvYxIFyu6JFQ+ruqi55BKxtjY5tDj7V9cMdCZqE6iRPO2m1Ol+pZjMrGsgv
	I9tID48FH6O8cTEn8scqi86fMF7jvS4gkZi/aRrg/qottA3fhRYOXWqSclq4/H3bIntYd+GvZeo
	sqs=
X-Google-Smtp-Source: AGHT+IEImagg3AdF5WYifMqKzRIwHznKxuAvKL3KeryKA1i40NWKG5ne+tX3JUrb7aTNo7+cwTyqLluVcxsGwvMzoxU=
X-Received: by 2002:a05:6402:1447:b0:643:ce6:a7e6 with SMTP id
 4fb4d7f45d1cf-64555d22c5bmr7096672a12.31.1763900181343; Sun, 23 Nov 2025
 04:16:21 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-2-pasha.tatashin@soleen.com> <aSLsCxLhrnyUlcy4@kernel.org>
In-Reply-To: <aSLsCxLhrnyUlcy4@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 07:15:44 -0500
X-Gm-Features: AWmQ_bn_xMt7b_XynypKNmLzsgZ0R3niD3BWBC1dy3KZJb4mBkKZVlkWV4PjVSU
Message-ID: <CA+CK2bCN7x=eMwfTXF-2+vR=Gn3=41z6Xxx6wM1m7i-rxzug9w@mail.gmail.com>
Subject: Re: [PATCH v7 01/22] liveupdate: luo_core: Live Update Orchestrator
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 333E880003
X-Stat-Signature: bo5ejtx5xyfwmann4h8m7qdty3s5j373
X-Rspam-User: 
X-HE-Tag: 1763900182-349340
X-HE-Meta: U2FsdGVkX1+rWFO5IJEG1XRkMsbVU7u9EhhAOmIfgx2LVWNgcTB432Jy8deNGjQ4J9ftNA8/FJOc2v0ti438zMyMQIgtawL7iAbip6Chby/VTotOxFsRd8BCrmgSHV7SNYGRgyI4Gowyr/MlFuLR++Z8G617hEKu26xrmFGSf5/ckpobY4dyHfxFTc/CSuDIKO5eBXgUVcPWXoT+FEp76HV+9JwLoYbDxF7VYty1PkAEH2PDv2+gz862KTiloPQNNQne5rAXCqKyEU096crpWzWwH2Suf5k2j1ztTwZCaw/StmFktHav62C8rLpMCZFqUN7q7aLIlu8iBNUMMvbsjZiqxU4JUjAATdaL1FaXe6Nx8QJqus0LKOHFgoNw9keHjfQ+Wxz/FJ+O3uChq6Di0Ct18RxRtmOVleftFnM9pSW270fDBAb0g8AREE0Rp4LYno+C9q7sxPf1ZLfFgijVzhTnBxzfGgSYYgnEPGEjsZwnkzAurlfj8aXCv1qmzntcD9qk4oRuje3p2Mn7AhEnOrHS4llLv2xYCsbjolcOWsMoi+jS4AxGPuGB0+COJfnBgQs4AGZdoMioUW6mLPai2BKcvPmIot1UgKL1APnB69LbXSXzmluD3ZK37+HplmSV55aUZ67mM/UHq5TVj8h0vj4sO2Jp+Hp7Nq+MnVgvCBp4dQZR9ufxooCMMZCmoYsuFiYgWZQnbrK9YN2xDyWtRVdoCbyxuJZ+IhrbXmZ3lWzq3TEc1jvy9+7RUEH33Z9NilH+nNCCkFJTb2R8wW7FTXWijMItgmSN9vcCcHlBdT03lC2dhV7JFqgTIe019aJaYgkhfPOLoxWu7XYXyq5B1+SjeUv5tE1vpY+NL7Jkr5ZXSAAId5z2l0hA6RC/7n+4c6OmBBQNKlkpWpKXM5+yG3cSs8ltIC9EQAEiK0AFxL2PLKJ9oUQWIhaAkKXYduGzg6/ozPHrb8M2YtQdZ2G
 PdGgDv+s
 C/RuDEc7R3ybGDWRmwv5vQWUZsImakH/tyrgPrrlb77pph8TVid18fpmsjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 6:12=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 22, 2025 at 05:23:28PM -0500, Pasha Tatashin wrote:
> > Introduce LUO, a mechanism intended to facilitate kernel updates while
> > keeping designated devices operational across the transition (e.g., via
> > kexec). The primary use case is updating hypervisors with minimal
> > disruption to running virtual machines. For userspace side of hyperviso=
r
> > update we have copyless migration. LUO is for updating the kernel.
> >
> > This initial patch lays the groundwork for the LUO subsystem.
> >
> > Further functionality, including the implementation of state transition
> > logic, integration with KHO, and hooks for subsystems and file
> > descriptors, will be added in subsequent patches.
> >
> > Create a character device at /dev/liveupdate.
> >
> > A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
> > structures. The magic number for IOCTL is registered in
> > Documentation/userspace-api/ioctl/ioctl-number.rst.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thank you

>
> with a few nits below
>
> > ---
>
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index a973a54447de..90857dccb359 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -1,4 +1,10 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# Copyright (c) 2025, Google LLC.
> > +# Pasha Tatashin <pasha.tatashin@soleen.com>
> > +#
> > +# Live Update Orchestrator
> > +#
>
> If you are adding copyrights it should have Amazon and Microsoft as well.
> I believe those from kexec_handover.c would work.
>
> @Alex?

Sure, or I can remove all of them from Kconfig, whatever you prefer :-)

>
> >  menu "Live Update and Kexec HandOver"
> >       depends on !DEFERRED_STRUCT_PAGE_INIT
> > @@ -51,4 +57,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
> >         The default behavior can still be overridden at boot time by
> >         passing 'kho=3Doff'.
> >
> > +config LIVEUPDATE
> > +     bool "Live Update Orchestrator"
> > +     depends on KEXEC_HANDOVER
> > +     help
> > +       Enable the Live Update Orchestrator. Live Update is a mechanism=
,
> > +       typically based on kexec, that allows the kernel to be updated
> > +       while keeping selected devices operational across the transitio=
n.
> > +       These devices are intended to be reclaimed by the new kernel an=
d
> > +       re-attached to their original workload without requiring a devi=
ce
> > +       reset.
> > +
> > +       Ability to handover a device from current to the next kernel de=
pends
> > +       on specific support within device drivers and related kernel
> > +       subsystems.
>
> Sorry, somehow this slipped during v6 review.
> These days LUO is less about devices and more about file descriptors :)

Device preservation through file descriptors: memfd, iommufd, vfiofd
are all dependencies for preserving devices.

That Kconfig description is correct and essential because the core
complexity of the LUO is the preservation of device state and I/O
across a kernel transition, which is a harder problem than just
preserving memory or files, for that we could have used a file system
instead of inventing something new with logic of can_preserve() etc.

Device preservation requires exactly what is stated in the description
for this config:
"Ability to handover a device from current to the next kernel depends
on specific support within device drivers and related kernel
subsystems." The only subsystem that is getting upstreamed with this
series is MEMFD, it is a hard pre-requirement for iommufd
preservation; the other subsystems: VFIO, PCI, IOMMU are WIP.

> > +
> > +       This feature primarily targets virtual machine hosts to quickly=
 update
> > +       the kernel hypervisor with minimal disruption to the running vi=
rtual
> > +       machines.
> > +
> > +       If unsure, say N.
> > +
> >  endmenu
>
> --
> Sincerely yours,
> Mike.

