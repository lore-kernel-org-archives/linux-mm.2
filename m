Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D964CD6E61
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCF88E0011; Thu, 13 Nov 2025 08:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895058E0002; Thu, 13 Nov 2025 08:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA468E0011; Thu, 13 Nov 2025 08:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68ED48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:56:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A17E12E76C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:56:48 +0000 (UTC)
X-FDA: 84105734496.02.D6663CA
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0EE1D1C0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:56:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=B7sapkgs;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qyNFyNK1thmREVHkgbpHK+c6E8B7TJCRh3ULLZ5C1c=;
	b=5uz1zTN1uFYN8iz4wYde+QSqjdlE2fAmJw9QJ0W2DamUlCBxvJtxbV51EbLes8UY/36m2y
	89CQtF1Q/is3INN+7+L8kOq6SxbHOtE1mv33GdeJTG7JsfoBLBWK99/ot+a/AG1K2cRV0r
	+Nrk1qPGe1XLtKj1sy5AhSSY/tvnBGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042206; a=rsa-sha256;
	cv=none;
	b=bbrj6kwd+v7k2bbZmT5agdK9zYbqEXzRdl+gZPxWWqypT++RQNAqXHYdlYq3YR7FD1hB9A
	afjYlZn098WNFGlsxv1Md4xkAsN3SgeYTiJ8lmpjj6MZRJIOblM5PydlvQjlAe7yPTKwy/
	XYkrRwEhBbLn9N+d4SA1kV2787NkOss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=B7sapkgs;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64149f78c0dso1380887a12.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763042204; x=1763647004; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6qyNFyNK1thmREVHkgbpHK+c6E8B7TJCRh3ULLZ5C1c=;
        b=B7sapkgsTWDcxnVUt2Z30rRTn9EfqlNRSgl+2f96eFipEbBcETJk9mZCDfyCv0jgkM
         5byNp3l6t7H+qscLkYBtW8WsAuVX1Ui89HmxnH/amkwcN9ytOCiVpj4hGybXG7/B1IS3
         WdMQm6rFzsd0j+r5MNUVsDsArIazdBKjSWxaHX/CSozxMAxe5XGZQ4QwFxxQx+BQD7tn
         9heH5IFq7Qo6Kzg/GlKz/MUx6B561cgU/fh5u/yVxO+aW5dZYw1oRp7quSQ/PG3m5Nts
         0Z28QcK3s6lajAySB5wyw4v403MjzKSjcM0wIasTSNupHHWmRvpMimzhkaQOsjMMJbEN
         0j6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042204; x=1763647004;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6qyNFyNK1thmREVHkgbpHK+c6E8B7TJCRh3ULLZ5C1c=;
        b=Ggxrf9karsoMRc8UBulm5z5Q3bVbBdloEZBfZQMUh2fWSaGZlJZzDRHw/QasDPoRnN
         hIvDLCsvESUJRjRgV9EILYJPrl5N7uGTT/kJxV9MXPQ1QPQoPbbxKQ7EVqaO6QJTqa9T
         4c4NGmyOLmNksOleKXmtOM/QMzRI1WVpvUsepQRm2blX2DqYTEG26YAOSQG3A4Tm4qxP
         PqUhL6BKCdPmJlY0NzyafOochNtxU3goQABHmku/8jBnL2+swLINBpL87vWYqOyG/U//
         ugtxpabSPFql+p346iD4BJO9bbeTr2UaH8zhAUuYX+h1AmZpS6rijQc4OSAFDuGkzmjP
         ngEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3lG0KuglsWPAaTVT199noK1VCJ2Q3d7FRzp/i11uYAAorwpVU+axDcDSDnBzPfMVscawtGp/xgg==@kvack.org
X-Gm-Message-State: AOJu0Yy9/fAMND8JpEtihb5XqvlDMvH/3gQUbk1lbQwVoajS0tlYILuc
	Qkz/ryREaiPs0af1OhXTcHZI+siZPGW98NaKl25FiKVfV5W8jlOwlFhj6WYnNR0a/ZMVuoSA3zf
	yNAEqFYQ6Dmt1pL/2hXBXonYSmv5HfNRGr/39etzeFw==
X-Gm-Gg: ASbGncsaO9p7KsY9PvKAJIsgm/qgbmlaXUy1RK2sBLW8/zTrOnOlmdoCyAI+PBUnok5
	JR8XjpQSEf/FtgcrhBce8BxsRzsGHH/SUYjo/+ETHOYB/tiXAR+wMtIQx5Ud13RWX5oKfEYss6/
	tE8U2GfUptWzJejDXsTdtwQ8qqbZd4dlJ+3YVDkTw3ZsKGXzjO4DP/kXYWbRgYh6eFP4ZTFonjV
	3pUqIAgud+Ut2JtHhmxf7CfmZUXsH1t5IRFvMGJXzoqkarrxPTrredR+4ULDVH49QeD
X-Google-Smtp-Source: AGHT+IGY+tZRbaslLz2kOHg+aNV3t0hpe7oMeZfcGmL5vq41YDW/o61wTpChY/KiKQIFV5hvmww+CFYOhBuLb1d6YYI=
X-Received: by 2002:a05:6402:2106:b0:640:f481:984 with SMTP id
 4fb4d7f45d1cf-6431a395d5cmr5583802a12.2.1763042203396; Thu, 13 Nov 2025
 05:56:43 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-2-pasha.tatashin@soleen.com> <aRXfKPfoi96B68Ef@kernel.org>
In-Reply-To: <aRXfKPfoi96B68Ef@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 08:56:06 -0500
X-Gm-Features: AWmQ_bmd0HSccxoETOjnPXP7LM0Avf6TAjDFvEucAEYN_rSyfWXxN426kJbKdTA
Message-ID: <CA+CK2bA9DtFd5sCfWg11TGdRj9JCgevO_mrjBsBvY1ebgUD4dQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/22] liveupdate: luo_core: luo_ioctl: Live Update Orchestrator
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EE1D1C0007
X-Stat-Signature: 5s6jn8kk8epubrkhofdeske7i65jyayc
X-HE-Tag: 1763042205-873782
X-HE-Meta: U2FsdGVkX183C5bXl8414Dzpz0hVPEP7ZXRE6XDJLym3GscdupIPz05cTVGW6CZhQu36o3iLXsqb53aWC+tG4EnowFoixgCaiBtCMWWm2umfMZFYZ5ObbVjc4QkCHpvcxO8/Lz0v9XmYxGW7hcsWmJyYUm9c5KccYC9RMTNafAsqK8bspfXco5ksEPZAm2TaMoeRVSPmCSQBW8zvdQtWyriipGaZMELq5nSVbAWSNQ9tfEPTnbbmaeA9X7DEVaxyfs+jd/ymLibfmtZone1hD0KzG/L2lZMDzl8coce5bAFkFJK34v7v0kwZqRejoLT9nOrOy80p+MHFUmOCUUtkmSnCgXQfYO/pCuSaKKPJfN+7emRGhZRpNhHAKU3HXbX1k4ogke8oCD703LwraiFLZhO4kEH/S8UXdSyG9t9riY2WGenrpSaEhki4ab3BoJnTbrnb/60snyqcAfMfQv7GMfwLRzogHHCHZq1mQ4Fg6Yqvx01i01aVZ/owVkkirSx16w/JjgnB59Nz/9WrVfvRAvqSrqq2FChjiEV7zxr9bPXtYvwI2gI4NAnWBzl6aVqK3+kl29FZEGDTNQQpfCJAm2VxRh1pkOI+qEv0/dKgbRhiTQZluyetkWUyvag/DpSNEWQqW1sS3VvLY1o8B/mxobilIXMxAvNcE9rrZV0OayF1pn3ipDIRqZZ/7/KI4NPl67hFg+kPOEwyZMEbMzpv/T46UJ9CHmStCj1WHMHEA9fWH2jomq2cV46x0lptVfMu3f3C9LdlIqevqWAdZ/TJM7gHzBKoSK+YRj3NM9HMCItMCy559o2BS+J6Ltg6SE2ShAABL6k9GFuGGNSKZZnlzW/1B5Zeog2ZGIbrwh0VItzKGrLpwgo2b6pmyiuM7h7KmuUTfcc33cRyQpORBHoQPtZ2UF2AG9DqlklayK0gbXlUWNu1pYIu6KKUY8bPzIixgFCa/Cei3pHE/uWQKnl
 mrt2B5Lv
 hh2TBX0Z6SZpzBjrCoy/c3nqUW7Lj7R5fmyx3TVGdjy3iP3yFp/As7qmrwZ1hqHeoPnMIh1KhMYU16NY5SEGRnwOAcjUN+EYSvKkCVu30YRAqsS0adJr+Nubq1pACWOIFVT5/RTJ8thR6yiMINvwmrbFs4TD0d7WtnY0DYyULF7dVsumET24DF4e8eoe6FMx5muhTH7YSbXCjfA95Q6orPjWWmmgEEQocXgkuoJ2YSO9ljRUmL/YK4WK4yAU5/kJAMTJ/P3aPTU6RK3ZS+KBawsq/YxB0AKS0QP/Ww/3xQUQRyrLnXyzNp2zPYV2kr8l8gXTUWIfBsLWGwwbEMITKzZIcRg94khynhYoYOokFvqfe3dWDyflALBQNX7K/clmXhZA0sYNp0VcR3ywSxShKrGBOpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +/**
> > + * DOC: General ioctl format
> > + *
>
> It seems it's not linked from Documentation/.../liveupdate.rst

It is linked:
Here is uAPI: https://docs.kernel.org/next/userspace-api/liveupdate.html

And also from the main Doc:
https://docs.kernel.org/next/core-api/liveupdate.html
There is a link in "Sea Also" section: Live Update uAPI

> > + * The ioctl interface follows a general format to allow for extensibility. Each
> > + * ioctl is passed in a structure pointer as the argument providing the size of
> > + * the structure in the first u32. The kernel checks that any structure space
> > + * beyond what it understands is 0. This allows userspace to use the backward
> > + * compatible portion while consistently using the newer, larger, structures.
> > + *
> > + * ioctls use a standard meaning for common errnos:
> > + *
> > + *  - ENOTTY: The IOCTL number itself is not supported at all
> > + *  - E2BIG: The IOCTL number is supported, but the provided structure has
> > + *    non-zero in a part the kernel does not understand.
> > + *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
> > + *    understood, however a known field has a value the kernel does not
> > + *    understand or support.
> > + *  - EINVAL: Everything about the IOCTL was understood, but a field is not
> > + *    correct.
> > + *  - ENOENT: A provided token does not exist.
> > + *  - ENOMEM: Out of memory.
> > + *  - EOVERFLOW: Mathematics overflowed.
> > + *
> > + * As well as additional errnos, within specific ioctls.
>
> ...
>
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -1,7 +1,34 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# Copyright (c) 2025, Google LLC.
> > +# Pasha Tatashin <pasha.tatashin@soleen.com>
> > +#
> > +# Live Update Orchestrator
> > +#
> >
> >  menu "Live Update and Kexec HandOver"
> >
> > +config LIVEUPDATE
> > +     bool "Live Update Orchestrator"
> > +     depends on KEXEC_HANDOVER
> > +     help
> > +       Enable the Live Update Orchestrator. Live Update is a mechanism,
> > +       typically based on kexec, that allows the kernel to be updated
> > +       while keeping selected devices operational across the transition.
> > +       These devices are intended to be reclaimed by the new kernel and
> > +       re-attached to their original workload without requiring a device
> > +       reset.
> > +
> > +       Ability to handover a device from current to the next kernel depends
> > +       on specific support within device drivers and related kernel
> > +       subsystems.
> > +
> > +       This feature primarily targets virtual machine hosts to quickly update
> > +       the kernel hypervisor with minimal disruption to the running virtual
> > +       machines.
> > +
> > +       If unsure, say N.
> > +
>
> Not a big deal, but since LIVEUPDATE depends on KEXEC_HANDOVER, shouldn't
> it go after KEXEC_HANDOVER?

Sure, I'll move them to the end of the file.

Thanks,
Pasha

