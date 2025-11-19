Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C83FBCF58FE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 22:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB546B00AB; Wed, 19 Nov 2025 17:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DFE6B00AC; Wed, 19 Nov 2025 17:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010A56B00AD; Wed, 19 Nov 2025 17:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA1406B00AB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:13:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BB441606A3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:13:05 +0000 (UTC)
X-FDA: 84128757930.19.C881436
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5AC071A0009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 22:13:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Lfd/UOKP";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763590383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmO/rmQDeDDD4oFLN2kD77+FOiHPR0yrD5sudAmDUFo=;
	b=lj34/Pz1K98zmxQrikQCI3TphYImRtjDliczX8DPFmT7CJzUmU5fFsz2wV4M1/CJ5LAu8I
	PnYUfF+1hb1O0mSu4N7HNgb5erpaVOKR4cGp7z0d5j0dZ4+a86WWRrCOfCEXC/Dz+4G3L8
	opsdFmwn9m4xV/Mu5tbse7xyBZxXl0w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Lfd/UOKP";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763590383; a=rsa-sha256;
	cv=none;
	b=GePFGIf+Dd8HdqVGJO5IbH0RcGE6EXqRVnCI2RAemnxNBwe11st9JBjLCwJYw7XuVs2I+Z
	hohaiCAAU1TvB4mqR3B5g5pXxFqltUmDpqMCu+Wrl2MFvZufZUa6XOeJCXOC4ftLoe1Pgk
	+Avl6BwkEacn6POwKIn8/a7pkEhiZd4=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso413958a12.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763590382; x=1764195182; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmO/rmQDeDDD4oFLN2kD77+FOiHPR0yrD5sudAmDUFo=;
        b=Lfd/UOKPF3WHZdThYSeRPSF2y9KzLR1Asg9yBgs4zDmr6h1bT6fAoOYqPPoGSwVtNS
         w4MQzbNZTV2h0dvH1LWgsKO8L7WGKe+D2bNU98hB3PWzkIlGZ2pqnQRG6/K1vMHDPVqc
         NHJQes8ASQgI82e9GnI/X961yG/EjGSpSzihcS9QwAAEvRotnlAw9rEBHfgXy7Ly8ntA
         3CnDkU67OcmJqGgLWyIfSDNQouM7AecT7b7v+FU1szf7c8nsY1oeAYwXWeH86cybjxwS
         mKa7p+Mu06SQ0+WKQybyo8sFl4HEuoTi4y3tlXxMTQvjx5Y3eMhtA4Z4dT8EIXZUsfVn
         jEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763590382; x=1764195182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jmO/rmQDeDDD4oFLN2kD77+FOiHPR0yrD5sudAmDUFo=;
        b=qfBtRtADdvyMwtjIVFkvp+1RKkBGqu3owaGAVZn1Pgp2u0pS00J2Ui7HzuwutwdUwO
         yBdRtGFCoNOhyC+evmjQV4eW9lCqBqiliSL1ntkrV9VhdakUafPwF/vR9OHmgJz0NFJN
         vfcyjiR4Sk0bDvialYTqCrUKs4Y06h/4Wgb+Jo+kijI49QB25QALNoLWzXD/N/2EkMhf
         Y9wZlfg4qyVa35YnLXlj1UdBPmfNYM7GmywvCK/z1K8JTAJYe1slPTnwrmbHCI4iTgHi
         VcSu96Juq6+kYMfrsJQX2KpoIopSk9GaldFK3H9WW/UvtAzZT9RGJMPz1WafOvgLQSFg
         ztfA==
X-Forwarded-Encrypted: i=1; AJvYcCWOSqflmRu9XWVpIw9bJG99B0eELmmHN7ChCnfHj6WFE4FPK/Tbf84iLeNsG/F4NJtLmH8UFD+qww==@kvack.org
X-Gm-Message-State: AOJu0YxB68hf6GWShgyl5klgAp76x3OXCU/E9kLMkRJ/6xNl6By2eVQY
	8bZyaAFM7SMqbg3R4YFGEwNx+foQeLNfBdm8dQp6yNKM7H/jJ+pXJkjzxqGGFAyve3LMWClzFD0
	oWh6DOXJJYDOGCf3UGN3bN3NjY+F3F6daPwN3Ji2OMQ==
X-Gm-Gg: ASbGncu+OFXZgSmISLRQXLgpAP4hKy4v0UDet0i3hruzWA9VKOK9dDz7cASgA2r0LeE
	7ruwTpMvrkqCl5XYYXYeWgdVgU1ir9rS+z5jSU11z7F/RUxb/7cP8ZDDm01+qZIW4RbsG9AyBcG
	QbJpthofGjcAInUwv0DFRPokORn8n3HLJmsmXx37o5D3WMNltVk5NuOeqoSkpNVfUFBisQF+A4E
	zyriXcvkePedjxygtfuKmZVr1Qb8n93Ye/FMhNZ/Z3QFTrGq4biwqHCKfwwIxfn1SlScv6B3wlh
	O6OPMhYOh1bngw==
X-Google-Smtp-Source: AGHT+IFw6kDorU2RenWoIYJjhBpjj+66hDpPciDjAImJ3B8hxUcjgpzXU/StGuyx3A6WKe/RvhzZdqNdpa9gP61f3nc=
X-Received: by 2002:a05:6402:3492:b0:640:b625:b920 with SMTP id
 4fb4d7f45d1cf-6453966533fmr137250a12.6.1763590381585; Wed, 19 Nov 2025
 14:13:01 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <aR40oVOxZ-dezpy0@google.com>
In-Reply-To: <aR40oVOxZ-dezpy0@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 19 Nov 2025 17:12:24 -0500
X-Gm-Features: AWmQ_bn2ZiiYRRhjdL5Zxy3O1nTVtrU9qOIx56eMo9t0_SUIdxuoIchWFpNGDbY
Message-ID: <CA+CK2bBoantuwMxqe1=PnRO+RX86Qo0epf89kbmZx5z8i2ivLQ@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
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
X-Rspamd-Queue-Id: 5AC071A0009
X-Stat-Signature: qicu636gj3hd1fxcjcfyqcgc75w6da13
X-Rspam-User: 
X-HE-Tag: 1763590383-40911
X-HE-Meta: U2FsdGVkX19BDHtccTTUIv5xRSpbRJFA7AZUdiB/FP/RaLFpy6Cl5kT/Rape8XVJfQqpYhmzQAMv9sO7niF4mvuAuo7+6/7Pl+GJMsZUrOyVcyh5cTPCbiFDmKIqiZMA5/dPgoFjImj6GaG7O07KrDLFMECeD6q+tYL7/jPCMECigGZjwBcUBlecJqKOpeQ6UUYV0XWyCUZmxlaP3+Ofz73I5QWiVEGOoLWE6aSxF1PhsX6Sioqhwz/5v1E9o9E4iKXjU+oVGCEnlvhDlAJHR3rY27zRWdlGJAT3hUxqAT+7Vm9pavCtlDq/qAtqt2kgPJaWwYsSVBYWujEnuMiu2M+FPSE1v+nU16Zti1wVIRB4uOuuoPu8er8g9BmwmOxNLieNyioLoMli4xz1O+WCKRtbyC9Z0WVwRxiAkvQJIt4SNMHlPH2llHN1NJkb/YZJzoV3fRAzeEI9uYXwVHKye4s93H4xalUxg5t/fbmUb7dLdI0fGmU1Q+TThX6qWMFi1WxA7/mStMY+tntbL7A9zuzS5tZPpTe893exnocCA3h5R5bILrEFOPwDUQfCeVDG7pFKhMZkSOm1Gu+ca+lSb5xq4GBowmN2dzIQylQ8yZzLj5bG0XLGRBUFzI3CgZVZQFZsZ74Odzt2VJDlAQzj/Req6S4W0G8UHPSCWDK04xBqsDkBQYp6aB72H5qVG8aaUj5DacwSns53bwxm+SqT2tGfF5L9BIgW1oL4XP0BsGRjOMcnyaaEHFkrOjrOD+PpXqMTdzCx7wVZWHBmHh2eVtHEgpfmZPdO1xsnZlBFohM+5Mk/XloohNZn1g6Poa3CsP1IgV9Ek5mBO7v3qRLTa3cTYNL6QThZTls8F2Ax6LQUQR3D8n4NEB1ABOKy268BOMFeWL02+XQ/O5T9jN8gVvL9Ydu1yvQ9Pmsq6Oq0DF919jnlLr4NTS4zp9x48+ooXHmBW5ivTKjqrqfbRmB
 sj3V/iGI
 FZJamrkspkGb8sBMGnZWY/72GkJqs1qZAV5O/XRKtGAZZY6rsV4lfLJ9dix1scv/LviYdmkoZIkTS7Ympccnesw0blxhQktJp7FR/KVkAnHTVi1rqzj8kwcCYR/zsZhzI121SMSqcJh3aT5XUaAmHlghNNgwUHJDehebXgQUwArkVlNltX6NhNCM0+2IsjVEg7E4oEzQucld0+D2KXzrQaGQZ7sLxiPCAV241LJh+9C8PFkycr3NJjYxktfSHNZUEFqv4aesrFOjYYmq9pzr59+ZVBsHhdjcJ61a8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 4:20=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-11-15 06:34 PM, Pasha Tatashin wrote:
>
> > diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/tes=
ting/selftests/liveupdate/do_kexec.sh
> > new file mode 100755
> > index 000000000000..3c7c6cafbef8
> > --- /dev/null
> > +++ b/tools/testing/selftests/liveupdate/do_kexec.sh
> > @@ -0,0 +1,16 @@
> > +#!/bin/sh
> > +# SPDX-License-Identifier: GPL-2.0
> > +set -e
> > +
> > +# Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initra=
mfs
>
> It'd be nice to use proper command line options for KERNEL and INITRAMFS
> instead of relying on environment variables.

Now that tests and do_kexec are separate, I do not think we should
complicate do_kexec.sh to support every possible environment. On most
modern distros kexec is managed via systemd, and the load and reboot
commands are going to be handled through systemd. do_kexec.sh is meant
for a very simplistic environment such as with busybox rootfs to
perform selftests.

> e.g.
>
>   ./do_kexec.sh -k <kernel> -i <initramfs>
>
> > +
> > +KERNEL=3D"${KERNEL:-/boot/bzImage}"
> > +set -- -l -s --reuse-cmdline "$KERNEL"
>
> I've observed --reuse-cmdline causing overload of the kernel command
> line when doing repeated kexecs, since it includes the built-in command
> line (CONFIG_CMDLINE) which then also gets added by the next kernel
> during boot.

There is a problem with CONFIG_CMDLINE + KEXEC, ideally, it should be
addressed in the kernel

>
> Should we have something like this instead?
>
> diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/testi=
ng/selftests/liveupdate/do_kexec.sh
> index 3c7c6cafbef8..2590a870993d 100755
> --- a/tools/testing/selftests/liveupdate/do_kexec.sh
> +++ b/tools/testing/selftests/liveupdate/do_kexec.sh
> @@ -4,8 +4,16 @@ set -e
>
>  # Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramf=
s
>
> +# Determine the boot command line we need to pass to the kexec kernel.  =
Note
> +# that the kernel will append to it its builtin command line, so make su=
re we
> +# subtract the builtin command to avoid accumulating kernel parameters a=
nd
> +# eventually overflowing the command line.
> +full_cmdline=3D$(cat /proc/cmdline)
> +builtin_cmdline=3D$(zcat /proc/config.gz|grep CONFIG_CMDLINE=3D|cut -f2 =
-d\")

This also implies we have /proc/config.gz or CONFIG_IKCONFIG_PROC ...

> +cmdline=3D${full_cmdline/$builtin_cmdline /}
> +
>  KERNEL=3D"${KERNEL:-/boot/bzImage}"
> -set -- -l -s --reuse-cmdline "$KERNEL"
> +set -- -l -s --command-line=3D"${cmdline}" "$KERNEL"
>
>  INITRAMFS=3D"${INITRAMFS:-/boot/initramfs}"
>  if [ -f "$INITRAMFS" ]; then
>
> > +
> > +INITRAMFS=3D"${INITRAMFS:-/boot/initramfs}"
> > +if [ -f "$INITRAMFS" ]; then
> > +    set -- "$@" --initrd=3D"$INITRAMFS"
> > +fi
> > +
> > +kexec "$@"
> > +kexec -e
>
> Consider separating the kexec load into its own script, in case systems h=
ave
> their own ways of shutting down for kexec.

I think, if do_kexec.sh does not work (load + reboot), the user should
use whatever the standard way on a distro to do kexec.

>
> e.g. a kexec_load.sh script that does everything that do_kexec.sh does ex=
ecpt
> the `kexec -e`. Then do_kexec.sh just calls kexec_load.sh and kexec -e.

