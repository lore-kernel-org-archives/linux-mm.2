Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F6ACCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6300A8E010E; Wed, 29 Oct 2025 18:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607DF8E0106; Wed, 29 Oct 2025 18:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D548E010E; Wed, 29 Oct 2025 18:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3818E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:23:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB38588FFE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:23:26 +0000 (UTC)
X-FDA: 84052579212.03.39DFE0E
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id F1103180009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:23:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iAHZTwhZ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761776605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpv6Bu1gRrUbx52oNEm6LTdZ6YidJrARd+ghcU8tGMU=;
	b=rn8M9FG1eDvbcjpHWXhoVV2lmm1ujoF3Txaa7J4UThjIWqnBYLylNPbi82fWz+LLCjAUa0
	Isx9e9JcDKj3hR0m4FagRKt5kbvBuLL7FY1545V3ZgF+pdub3uquqHjXUcHPvUBEgrsap2
	lseUpf7EPxIB5SPYPiC5LzV62Iq4Cdk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iAHZTwhZ;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761776605; a=rsa-sha256;
	cv=none;
	b=KXJQEFXeQ4FViauJStfZJCwTywPkup5vm+TuA7ngZf3BOQAICoKUPygJcNkf0EVNE0FOHA
	IDO5HrqqLSr1LMh02i4guRMJJ2NinmHm0EmvAe1wwBLswdCTqlD8qexwSuAp3zG8UuhnC6
	POwWQ7Itht8MTShIfKA+2IvWzuLKKJk=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7042e50899so98572866b.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761776603; x=1762381403; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpv6Bu1gRrUbx52oNEm6LTdZ6YidJrARd+ghcU8tGMU=;
        b=iAHZTwhZRpp/pspv1mMmVvrhgpu1Mik0WG0JqEufFKazQefOYekm4LkGgfedmVW7Cj
         5C9cahv3dEQqICexz8Y5cLMjUOYZJb5hJkPMiyS7v75lpHHyAhakQ16u1TRZmG6SIIot
         pFgA5aQQlvhOxUuYKiiFxTkDyLb16QDmpPtpDk/uq2qUkleGQdLZ2WLuZsIA0SbobLI/
         kBfHXjOKPNQTTn9fZK1A63m1ykmxsWl4JiOx+/jdmDFfoDDSBrKhp+7I4uf/BSLZdb8h
         ZaQ9tHD5sRxFh2fLVSK/cHow4MHnbrQvV1WpFsI5sfv9W5VdT3ngZao/tDAnz+Xt2t3F
         SC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761776603; x=1762381403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gpv6Bu1gRrUbx52oNEm6LTdZ6YidJrARd+ghcU8tGMU=;
        b=kgLDd+kJ10/2CQDQCCmr/upqW11TFEDhaRBez891s9lL/o/yBTIm/T9QrQ+ImGTgKi
         GT2/uOTCOtpiQL5pkVFgFMvASq86CWLLZ7bbNdv/h1ro1gOaFZk8D2wlywbnn5N8sbH9
         +hLceuiI0zhQNoL77VUE+74jMe2tkM20HMOP0ds2SVvCOQu7F0ReMfd+4ky/k+Y1fwzV
         V3yH/s7LDHdp7uXyKvI/swMk7q8rBpR8RRawajcGK/e7xKLJyUEyYKA4+Ua2y4Ac+tqj
         a88JT0tEGjolVWsq7q8fW+CGsYGR0HQUv1gYfTWfu9vHSbSRMm2q0K9VWLuxl5Tp8F9H
         IKBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH5pzcMWMhu2HHHVemro42KMY6N4vAkBa7cN285uVy89m7H4HrWa4K38pdi9TfECO2RZeJdfMOug==@kvack.org
X-Gm-Message-State: AOJu0YxrNDrE1HoeZao3VE366uX9pOTLIPcdeo1xfo4iYyYju8gZzOPH
	DhrdiyDpap1SFjMzORREhZJ2KMX19Itaiq4KQrIvprWinaVh+5sOZb+tNrsMvc1BjFl/FXIh8cF
	BKWNSc3nYdUqnWmJHA1Ekmz8B7hb1gYaN9m6cZDa3HQ==
X-Gm-Gg: ASbGncsZ6fNShHuHu0QPHFq3XFDQEiCJJFokEUsogDfD6pwnlPbelj1J6bwOPgPpw6A
	ynYMVTQdrAwSxK8Yr5HgZJjxaesQFKpbvuZXfa4wNdU0LaWcDbRcFhQRQOGveO7PREgHSihHlJ9
	Z4eGQ4IRfWhnWaA7OZMFCUcewsSax0HSoC8LHvsg1p74HEbZCuXnuAw7izTfu21uoppoeYLbvoE
	ZQ2VJoRpgZS3s+ZhdIRVvsjHwlNpTqRCHyE7rwkjmAWsxNPJkXaWhZNdGBy5Dp5jzni
X-Google-Smtp-Source: AGHT+IEGXWbi1zL2MYQq1jWo5fkcmj13mveE6SjemKqwCk4bOIMfIzJadEzaXl9lawQXtRHdx+HKvLwQpuN1CFTNwBw=
X-Received: by 2002:a17:907:7292:b0:b33:a2ef:c7 with SMTP id
 a640c23a62f3a-b703d5cb7efmr522068666b.55.1761776603191; Wed, 29 Oct 2025
 15:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-2-pasha.tatashin@soleen.com> <aQHUyyFtiNZhx8jo@kernel.org>
In-Reply-To: <aQHUyyFtiNZhx8jo@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 18:22:46 -0400
X-Gm-Features: AWmQ_bmdWz_K-6x0FqPYXVy37hUITH8KVofabeFsr0NG2wwGh65pPSXncqtE7HQ
Message-ID: <CA+CK2bB=k6ZxeEuLC9Xwtzmgm5MZdpH2sRgk84WQVm4uoeHsVw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1103180009
X-Stat-Signature: zoznnzqf6n57np96wq3s48w4o3x3sp4b
X-Rspam-User: 
X-HE-Tag: 1761776604-734574
X-HE-Meta: U2FsdGVkX1+r0kBdffzdg4pr43wigidRcN3e30ulnUctLVijGmHp7UQlEjxsm/gHdsmktiAe5QYbWChWHUQBSxdOWkGFT32ZuN7sG7WNktZf5Cx0L3ohKhhhIj0/EXjiPE0OwiIeAW+EDdEEdv4bw4wLW6U/Wilmq78Og83nl5PHHolDlCxqZhLh8Z1naoFSYp6skN31/C/visARDNdT8dIQd9cr2kYSyEw9wD4+b0B7Jt4j2SM9LuiAX8wfu7YTRgfDWSTN18nWhC/5fC4EwjXd5qapxRj04ayWZuKTgyL+QgFJ49U6eQGcrrwuqJLfrxGupoar0EdOiBeQooRLYxcktrtJcnp+lHJov/8FYGoBozgRXuGG9TenXBNTcWLa88VFBwi50oPJIi2e9EZAfVLBenSUkGnnE6K0ZOV9vo+mD8123SaT1/TXn4f0uHhWiBIAX662oBSiEpTiyis75y8ZMMZ60QzclQeIUiWbK4wHv5691Twcd5yAUSXM6lGpvCxDhjTYR43kZvdb/+iKtvwwOUP997Wid5dbP6+dXW9KkSDdJlkaXY4RloZ+WahBYwozKSzfYiMWqCMDSYFKPI8Qo4E2yc8EGmf1L2bxRk+W6swdYBa2OPTVGVcW/EXRi8+19q0f2WJhrPxWNataLEvfzLglzrNKCUy8AvvKgnSClk6vzkh0kwETUdu/p929V3+Nz9M5uzRwX0L9oFCxsUyXr47/90bLD9+hM02XjI/6HiXOEEpZPimmNWGG8DnJ6zK44bDqTxRxFIfQJ/p7mj28QBOqI3NkaM5Grt47xvBg8dpjtvgpCPUdwJtYYD07zhEEreL4aI+LDYXQS5SBhha2OA9IqtwNl9bPCwgo+Z8VjJJJhUrOt9KJzKubO/O9hop3Vt5/quuLpjKLt7YW9yaqCaCCFl04ueKB8Bc5QDQcJd/rFDuUJEI/9EaWiqn0VjdsRX8KnYWmkWaC5dC
 MkDbg+UH
 263NKOYkxf1sj99+NxSvSs77U+UzG7XKDdivc4lJvXkGKfpo+ZR407v4WcxR/5bZbkhqU39aQ3krnk0dltflDIFD0QQ5MHvqByR3nERUYSmBIyN4GESiA5zrV/ak/0ywIaVc0NrCdOuO+dhVCFJCKec3JCx8J3iNzqg8e2qbUXEtijiGvAPkDEwXCgnBu7L4OK0AnCv14G/dsZs9kL3RMpCQhO/f3acEMDDpWgInHhuVnGJNOLmdSJs/zGKON0Vb3Rf44GwsCwOeKrfsIreHHwPPBlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Would you like me to resend the series with the "+       depends on
KEXEC_HANDOVER" fix from Mike, or would you apply it into your tree
directly?

Thank you,
Pasha

On Wed, Oct 29, 2025 at 4:48=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Pasha,
>
> On Mon, Oct 20, 2025 at 08:08:50PM -0400, Pasha Tatashin wrote:
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
> >  kernel/Kconfig.kexec             |  9 ++++++
> >  kernel/Makefile                  |  1 +
> >  kernel/kexec_handover.c          | 53 ++++++++++++++++++++++----------
> >  kernel/kexec_handover_debug.c    | 25 +++++++++++++++
> >  kernel/kexec_handover_internal.h | 16 ++++++++++
> >  5 files changed, 87 insertions(+), 17 deletions(-)
> >  create mode 100644 kernel/kexec_handover_debug.c
> >  create mode 100644 kernel/kexec_handover_internal.h
> >
> > diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> > index 422270d64820..c94d36b5fcd9 100644
> > --- a/kernel/Kconfig.kexec
> > +++ b/kernel/Kconfig.kexec
> > @@ -109,6 +109,15 @@ config KEXEC_HANDOVER
> >         to keep data or state alive across the kexec. For this to work,
> >         both source and target kernels need to have this option enabled=
.
> >
> > +config KEXEC_HANDOVER_DEBUG
> > +     bool "Enable Kexec Handover debug checks"
> > +     depends on KEXEC_HANDOVER_DEBUGFS
>
> I missed that in the earlier review, should be "depends on KEXEC_HANDOVER=
"
>
> @Andrew, can you please fold this into what's now commit 0e0faeffd144
> ("kho: warn and fail on metadata or preserved memory in scratch area")
>
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index c94d36b5fcd9..54e581072617 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -111,7 +111,7 @@ config KEXEC_HANDOVER
>
>  config KEXEC_HANDOVER_DEBUG
>         bool "Enable Kexec Handover debug checks"
> -       depends on KEXEC_HANDOVER_DEBUGFS
> +       depends on KEXEC_HANDOVER
>         help
>           This option enables extra sanity checks for the Kexec Handover
>           subsystem. Since, KHO performance is crucial in live update
>
> > +     help
> > +       This option enables extra sanity checks for the Kexec Handover
> > +       subsystem. Since, KHO performance is crucial in live update
> > +       scenarios and the extra code might be adding overhead it is
> > +       only optionally enabled.
> > +
> >  config CRASH_DUMP
> >       bool "kernel crash dumps"
> >       default ARCH_DEFAULT_CRASH_DUMP
>
> --
> Sincerely yours,
> Mike.

