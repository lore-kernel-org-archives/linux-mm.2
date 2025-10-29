Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8360ECCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32EE8E00FF; Wed, 29 Oct 2025 16:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2EF8E00B2; Wed, 29 Oct 2025 16:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1F18E00FF; Wed, 29 Oct 2025 16:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA4488E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:59:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67F5D13BCB8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:59:21 +0000 (UTC)
X-FDA: 84052367322.20.B05534A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id A329A180013
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:59:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bl92c1Y9;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761771559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfAN57AJ3VlZrtEXkpg0YM0RNnc6zjLGC6mTJFKCfBA=;
	b=sDysohdxcGA4yLMP74R4GVV2hP8QU1p96YykDu6pROtTom55gY4AVo1e3blF0hw/gZ60Ab
	wz8cIb/Vo9w0cvaM91XDM5lJx8Jx4x6KZc7YrAqLMN8AVOXI1S9G3qYv6inPKNqGHHX1cj
	b+hcHeJ4Vace3IYwMGbA7q949egFjME=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bl92c1Y9;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761771559; a=rsa-sha256;
	cv=none;
	b=588AQz/2kwdIg563lgDCuylkS9cQf4cfUS4zW+omj395BGCN+GGA1j5Yyzfv4gh/0lVXJR
	12yGAubFhLB6KEA6K7mt6MZr7RSfHxJACYbP1V1lc6iUX+OkW1jr/lmS+DUoGNAiZfJIAN
	EG3dPUT0STx++c6Ao9IfCVH+KhAKrmE=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so61808166b.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761771558; x=1762376358; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfAN57AJ3VlZrtEXkpg0YM0RNnc6zjLGC6mTJFKCfBA=;
        b=bl92c1Y9c2k+dBIltioFGxn2aOPxM1jCr87apmPEClPiJe2j/73JthFY3u5xLPpRAs
         c2k/9LTg6v0SlydCSJED1ZPEIsskucP9HMghsHYWAb48PnsmWXFJYgT1syZ1Jhydku6K
         UPJSwZV+Dj9CieNUR6STEiDr6Y2jG46hYW1g9bz3nMCQjVAGslubSRPbRb+fRu7DvmRR
         Jp4fLdUKiAnqvSGlm8Z3A9wMPdgbB0QOm46gWLdzeS4t41D342DabXdjzU+sUHhzPW2a
         nzabeQ/fVj/pVGOdzyBdiQO8w35DCLMaQo+HY4PQx3nGfnpue2IH+wGKaXPbPxcWUsZR
         1yvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761771558; x=1762376358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfAN57AJ3VlZrtEXkpg0YM0RNnc6zjLGC6mTJFKCfBA=;
        b=swutL4ouxNp6PCoxq0SmoHkJXbKe+cWBF98d0rHZ4PKZn5pozuPUI1ZRg0jtJCV4HX
         xisHz/7NwVkDmD6UnPU3W9NzdxPgupWbJXLoKmMGMy/O3ILi4N9lisS22y9deWFDe1ts
         mUbGsYMVjSd7Y3Oc+6wx/bVBiw/d+rteqqMdI3a1WwmIiVMHOoJ6Gca1Dm/YIf3ENnR9
         2iVaUGOkmsdS47jo/OAcZXPgt6fE4SWL5KlopjH5NhEM6koD5kyq71O04otM+SKTSpve
         vGdRZpYnL7a2JctWKonFVpK+UWSuCOuD5jjfZn3awVCKaiQeTwc3n1xuNdF6IzUuPtfc
         rWUw==
X-Forwarded-Encrypted: i=1; AJvYcCW2XRfz7OwdVQXCKnDqpkBLNK/Y8WXYMnZfqJ/R/PWWGfmdMuFYx7En+NXgr2K8DQ9AZ8Qoillxaw==@kvack.org
X-Gm-Message-State: AOJu0Yxk+FfWxnS3xopMQvwxUEgjDviusKcn0pSUXPHiMZNEK3UkpedZ
	4TI1t2SjY/9LtEoOxPBTs0Ff150Eh0z1VlF2UoEJsv6XoxGQi3/fGJlatGWyDIiYcW/BUrUzCle
	/jEiRl+ePfvUYfHcHtnbkNf4wfX6Mdk3BVWPUPdMLBw==
X-Gm-Gg: ASbGncvfkFd9fJRveCtUU/neYN9gviKn8oye6l7tMDS9HTl+sKbgBFCdM3tcVNV/oLF
	nTOLC5T0RKjersJfiVZR1pLx0yYf19h54pPm5St1I+F9EA75VpbA4QFkEgYL7irOwSV91GJ+YLF
	l7bwQCTTO3csRwwxeT+FDkqWgtiPVOg6M3r54dO03RsWpooKs8t/gkYi2fmwGJvAuapK/SbcIta
	XDR0CWYNPAOZkC1kTRcd7zVLKzOwojl+ybXxuABidQpDVyZ/sFn4mex2g==
X-Google-Smtp-Source: AGHT+IE/RXMv8hoooZh1E58NXDF0M8rMKt7Jq2/dOGekqdl2XNp/FrTs01ETHE1dw8Wf9fSE9rBqLnrH1cmST40VDnY=
X-Received: by 2002:a17:906:6a10:b0:b5c:753a:a4d8 with SMTP id
 a640c23a62f3a-b703d601679mr444730266b.62.1761771557853; Wed, 29 Oct 2025
 13:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0pla5cuml.fsf@kernel.org>
In-Reply-To: <mafs0pla5cuml.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 16:58:40 -0400
X-Gm-Features: AWmQ_bl42EDPtm_TaUQbgHgrX7gDrKin3DS3aEDrxO6qieGZ-fwZboHP8lat9pQ
Message-ID: <CA+CK2bB6e_=yQ9tQgvh7tJ3q34vCo9v4KpYG8DRF5pRa+YuUrQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
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
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A329A180013
X-Stat-Signature: zbt58f61wi8hwehjfdxb3xmnwekgux9x
X-Rspam-User: 
X-HE-Tag: 1761771559-620192
X-HE-Meta: U2FsdGVkX1/Tt1nN/vbHKIdNBzGR+oPZ4QJlqbbLEk/vifviEjuuFaqbmDIbXsNKXurPPx1ymPxT7r5Qmfaw2sZU0ncwXqciJhso6MIjXDhZyDQHB0TNHrf0EJXwakyP1CgoUNb2LZrPREQRj+DqcLMDGay9d5vSgTpFmeL8lgMIxPxf8S8gH+qFspJ7DOtRBbcJTp9N/nO3Ml/CcsGXhOJKhSv5bqHMheG4Ew/bPwyJ9n25DKgilSlVjjS89FWK1kku4d1UU+dIgY6z5zdjOGCko/4xVt2tb/6M+UKJZ5qgMK0pXbfBPhJTEaL8NVkFjaEK+sF7gVZAUsf+h3xUI7vcT6JRGokXOf1RGtPxXhSMlDzV762RiRov+BnOX5ZSXgwukSmyB6k7JIHNRh7IAhduAIkAOKBlbv02MkYCWRrYQW7mYQHXxhHdgqsrWWP9qKR2pwuXEWJUm1ejuYXv3/+w83GVa9s4im6xy1ZxiUsGRrLPgSfsIwI8PKWTHoWxvLHNus2wo0zla9znGC/9EhZ32EAyV+LHEStxGT3jUT8SlCnF758n2vsYUMczdu0J/uai6Ymwie4NlG4UO+HITmyvUbLMLO74rcUfAyxgdql8ekV6b0nH2UfWjpyYq/HbnqsgqwpUj0G+z1gE0PlxrQtXuFx/mxCeuygRn9wRzmFX69RuNfh9G1HVfHU0+CFR55vkzDKAmwRGPNcYzmdYOsfrk/3PGI7CNQG9V/bpBXmuccnOYystUn55hOFzQqhn1+LPpVleoRsXB8NtrwZ0iaUvgdJCdxI/FDAt8CbexUOZYApl9S5Lgge8AhszRaGutV2ZnckzHjIHvtiuq0MNKHr2SrNlqh0RRyqcPf3I6tq1x7hY45gjBrJ+ztste34OnUwTrIUM7WGMOqF72oh4MUUv7k9bYdSmMNLj3K945xduajYo/Tg9XqybM/rIuTtaLDR4qwrP0om5XGq8LiD
 X2HbEsQV
 Q3zQLrcN3m2cQquztcLDyoEL0pGhWpkIESJyAPJUPXGCwMcb49H/aVkOknw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 4:37=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > Introducing the userspace interface and internal logic required to
> > manage the lifecycle of file descriptors within a session. Previously, =
a
> > session was merely a container; this change makes it a functional
> > management unit.
> >
> > The following capabilities are added:
> >
> > A new set of ioctl commands are added, which operate on the file
> > descriptor returned by CREATE_SESSION. This allows userspace to:
> > - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
> >   to be preserved across the live update.
> > - LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
> >   descriptor from the session.
> > - LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
> >   new kernel using its unique token.
> >
> > A state machine for each individual session, distinct from the global
> > LUO state. This enables more granular control, allowing userspace to
> > prepare or freeze specific sessions independently. This is managed via:
> > - LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
> >   CANCEL, or FINISH events to a single session.
> > - LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
> >   of a single session.
> >
> > The global subsystem callbacks (luo_session_prepare, luo_session_freeze=
)
> > are updated to iterate through all existing sessions. They now trigger
> > the appropriate per-session state transitions for any sessions that
> > haven't already been transitioned individually by userspace.
> >
> > The session's .release handler is enhanced to be state-aware. When a
> > session's file descriptor is closed, it now correctly cancels or
> > finishes the session based on its current state before freeing all
> > associated file resources, preventing resource leaks.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> [...]
> > +static int luo_session_restore_fd(struct luo_session *session,
> > +                               struct luo_ucmd *ucmd)
> > +{
> > +     struct liveupdate_session_restore_fd *argp =3D ucmd->cmd;
> > +     struct file *file;
> > +     int ret;
> > +
> > +     guard(rwsem_read)(&luo_state_rwsem);
> > +     if (!liveupdate_state_updated())
> > +             return -EBUSY;
> > +
> > +     argp->fd =3D get_unused_fd_flags(O_CLOEXEC);
> > +     if (argp->fd < 0)
> > +             return argp->fd;
> > +
> > +     guard(mutex)(&session->mutex);
> > +
> > +     /* Session might have already finished independatly from global s=
tate */
> > +     if (session->state !=3D LIVEUPDATE_STATE_UPDATED)
> > +             return -EBUSY;
> > +
> > +     ret =3D luo_retrieve_file(session, argp->token, &file);
>
> The retrieve behaviour here causes some nastiness.
>
> When the session is deserialized by luo_session_deserialize(), all the
> files get added to the session's files_list. Now when a process
> retrieves the session after kexec and restores a file, the file
> handler's retrieve callback is invoked, deserializing and restoring the
> file. Once deserialization is done, the callback usually frees up the
> metadata. All this is fine.
>
> The problem is that the file stays on on the files_list. When the
> process closes the session FD, the unpreserve callback is invoked for
> all files.


> The unpreserve callback should undo what preserve did. That is, free up

Right, we discussed that continous preservation is not going to be
possible. So, this bug is not going to be present in the next version.

