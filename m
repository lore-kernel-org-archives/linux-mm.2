Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15B6CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4AF8E0007; Mon, 17 Nov 2025 09:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CB48E0002; Mon, 17 Nov 2025 09:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A22A8E0007; Mon, 17 Nov 2025 09:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 075108E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:10:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 938F81A0133
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:09 +0000 (UTC)
X-FDA: 84120283338.16.A1B0A56
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86C6D40011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GK4vHQuY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763388607; a=rsa-sha256;
	cv=none;
	b=dnw6Tr1aa96r1L59nnEhUB/CKNZ4BTEV50UQsp0Jb1xXevnu1t4vSJG0t/EWyhiWdROIkP
	6LTnVtOCb5eRGDmLnuwvoJQze7NHZmzJo+A/h48rT4fwAOQteNmHmiuTZk70FF2Ci76CPC
	kLUMZHoSBVMQRJD3nU/jO9Eq785m9MQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GK4vHQuY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763388607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PGJ4MM2xZvUtFSBpssoTJJO3KUHMCo+rFkEgLZfONk=;
	b=wpQQ1KdNMN2PTq5vD1mj+u2og61msDofw/zArmSs7yYuuuumLDoJF/TtPLA0jNj0H24IRx
	JDz1ad1Pez31oL7aHE6oH1h5gwYl187F6VUIgxrE6wKhgDhDQ8q2UUwLgKufQv12+CcP6S
	F2dTTaeoC5BhwSns6+FQRlgihNILlco=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso3220155a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763388606; x=1763993406; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PGJ4MM2xZvUtFSBpssoTJJO3KUHMCo+rFkEgLZfONk=;
        b=GK4vHQuYt59F01ZZEK2hl7x2SmAfS91uUITfuSmOY5hRmDVC5REya8Q32exoDE1zKu
         GRD+7oPQbRXlBurs4LRjMlQX4fvvg+ozT5NJy+PytkLmknWnsCpMCD5c3jawXugONnpI
         4nOIQ6wZyT9TxUsgFaCaF0NM34D01kpkTXeg5OHZvJKncb6QeC3xoic9lvhc4ZjhmHC3
         eci3FDmCl0y1lmlQDSnRUJYgQ9QCn7stma0AppQ2GSGdo1ZENymgfgkuYBPbIHdLTA34
         kW93NIJuQAKrjXa4w3BCcpMjq1hASN0u7I3cPiRxMb5h2Z0HU/+mM+xRMHrPMt9fRzbq
         Ljvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763388606; x=1763993406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3PGJ4MM2xZvUtFSBpssoTJJO3KUHMCo+rFkEgLZfONk=;
        b=pxMxo4F+Mi88NNxYtB6rY4E3nNPOJS6n9KpoZ0BK7zEeSO7D3mQdZz9UhUCkD+DOwW
         uZVxu5Zd6oNl7GdnAqnsmJNIr6mj1UZv+ZuUIfx4S7hquH69aR6cTLGZlr+YvVcFpKLC
         Sd+lcdDBI6cz0Q8Y1Gp/CnL0KHV/GJoZBUSsFlcy1m65rGBbxPARuhzQ1d03LOKcp4wf
         C+hf9yBg4PPhy7AQAaDlN2DlumKN7KwaOmsThVZtbjzczD19Eyca3YQaxkcp91IxcT5a
         zEVkEhGg6ogIBYhXVkH5yKxHYVy5w26q73Jvy3EifF2uzLeUuO9R2YhDFf1XwqhWh0nU
         crvQ==
X-Forwarded-Encrypted: i=1; AJvYcCX21nYnCgf73HCvXGb72FuOaBwA2gACsXpQ3oWKiC9mTjdWNkLKG5bjPdYdaZD8vagSKZfOAXcaPg==@kvack.org
X-Gm-Message-State: AOJu0Yx+staCY9H8C7iJ/tZ/5Nim4eTmKtQre6/1esM4eR7imAZ9Npne
	Xo8HB1C/TRW1xsyN/PlgtT2p6VF65gAsDVp4LQzUWmmZgS3LBO6Gd3NDzaKnlqVjRn4Sfd3RhZQ
	XrnOA8yYLAAlwBlNYCE6LsB7iprgFhA2hytAiKFuIcw==
X-Gm-Gg: ASbGnctZ/G5mBaObSn8eP910RPZkYUgqPC1WPZ8KaEVvA3uuqSac7ilEqZCpzSY5vFT
	J+uK6Fyt8kn9Sn+U0VT0HR94DSWxJmKdjr2UbbSKQlQAY9nLjy9vvsHFTbkBH4CyZ9XtKhQf8V+
	2E6wmrpVi4YjauuDSX6r2QZBT+Je0u1XTVgn6dohNjuROi8p5K0em1Gs0w5TLmDm8VV8cZPf+hu
	S8nRVYtRchpjFjBmYhyerZKcXVoepJcfr2OSyh8NTGkdiqdjUE/gAgjwA==
X-Google-Smtp-Source: AGHT+IHyLzyeccVSv3nqReJu90qTJog06h04xHxwwv6NgUkMio7F7ZWagqKrKcNrhIU9HnI/zZ5Tv0lJMZm643IIHWQ=
X-Received: by 2002:a05:6402:13d3:b0:640:ef03:82de with SMTP id
 4fb4d7f45d1cf-6434f80ffe7mr13322416a12.4.1763388605308; Mon, 17 Nov 2025
 06:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-23-pasha.tatashin@soleen.com> <aRTs3ZouoL1CGHst@kernel.org>
 <CA+CK2bBVRHwBu6a77gkvsbmWkQFDcTvNo+5aOT586mie13zqqA@mail.gmail.com> <aRoZq2bYYm5MGihy@kernel.org>
In-Reply-To: <aRoZq2bYYm5MGihy@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 09:09:27 -0500
X-Gm-Features: AWmQ_bn46kZnBDhZ7XIZjxCaG1X1VXV9A3jh512R99RJsaOy_fU1KnHkeK4KJxI
Message-ID: <CA+CK2bCeYfUGHo49PWqC4sngxKWP3MjcSL9EU7bNNCfsJtDCXg@mail.gmail.com>
Subject: Re: [PATCH v5 22/22] tests/liveupdate: Add in-kernel liveupdate test
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 86C6D40011
X-Rspamd-Server: rspam07
X-Stat-Signature: tbxr7nr3jmsfz5x4ucan4i3mhfs7ndhd
X-Rspam-User: 
X-HE-Tag: 1763388607-829014
X-HE-Meta: U2FsdGVkX18rEHM0OsswgfUZFajLEyY9ygxDXo4qSzlbWfoHAIpat+SCC7Y28wfsNAnlrma+ZMbpnEURFX6IT2e/S5J4FwDRLiKsGzuR3YBlD7GNhj0500Ec6Rl8tbsKG8XWiffYCbFZ2sofs8a+jX1cYcHe+3ymAqpwmA4ciyMt+1yjgBP9awZXaGXNpXhrRRHyVqkj8vJHnr5D0KDoIoyKJsrpqa5UfGOU7nrlk7/a38FSr9Ghig1pqzOiY5x/AhUzMVaGppzDP5ADyWa39Z82iKkMMQ9qlcvTX+CTfD74Inq4K2K+QtJcv4amUUWn4yvr0rCdCXpNgP6BzDYkrLhpzH6WkhCDnaDI8xVbyGNKfpf8kPIF2keRBsUA6+QpyMG+N0khmqZYcyDCHvr9R0AooLEMPuarea94Td4hqcOMTcAZ9KWvLNJyEaOclyw+/UPK8LAkEfjD+FTON0WT/th7vt0dKpFVz9PidTKRhLA7rWU+BxI3X4cymiBhXnUxqokSkjgvumgVArxGLw6w6abpxcT34aPoD3VqAxW+th+lkrRjfAcTDdsBRaOccu9tMOwC6yHCkrjtO7KnMcBBlYtb7Q5LHiz5mSJ2ch4z/a/J86A7Uanz9Z/E1r07n2Ujl8mQd2hPaHqq6k3W9Ihe7quL10BJs4raQlqQgLX/v4CkwoNJftwWV1Qq+JK3rBHbmQU4/3gg8h0w7jtoZp+fmiyGTdgBAKvKU2XnzIEd57HVrVznE32HHT3OXoKLIKdIsXDQC5Zk5vwzFL1WVKqfJLr8Mr6pV8qtOVfjAbsS1XdKCPgr/0BcWuKt/WqMR+sSXHbSqomrNpxGUy5AMBBCbcCKKyigdad/NqxnSEo2GmIQo9bNSe9Bhrp9NS5DSGJREaycJqwQDl7odgYEw39yBNnS8I+/r4HnUL1XoCRHGo/9biwzlEkCDtjlwticwFRxBM2qQZRYIn4/ySFBV5/
 UBCD+Wus
 1hGoXwyQl/uiYRjTFb8MpHGZEsjikpWQlYf/KRZYI1LhoXHTrF0FoDNzORSMM0aJbwi3k6TlgkF6dz2QxaqymXR+4chptp7SSZdrHslH9BTNEdfL6+udy+L9DS9sgwT7pdnkKzvy+EaN6cuAIzbAimHq+TDDr5/KM4eEfscT2rNNf0QXF4Zll9wXmCqmREi2ixcKuhid31K6WR55kIgK3KNszPaviLldOiZzFOfJpL+sSe+9ULT8SYM5pwCcHtSRwyW+KDw55Dv9a1geXO5p3eZTv0gAN3UQODrkT/VMD5wmB+lEckVDK1dZ8TWc3baMXoeaUoEtIjGiV3olRlVCjTtd05g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 1:36=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Nov 12, 2025 at 03:40:53PM -0500, Pasha Tatashin wrote:
> > On Wed, Nov 12, 2025 at 3:24=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Fri, Nov 07, 2025 at 04:03:20PM -0500, Pasha Tatashin wrote:
> > > > Introduce an in-kernel test module to validate the core logic of th=
e
> > > > Live Update Orchestrator's File-Lifecycle-Bound feature. This
> > > > provides a low-level, controlled environment to test FLB registrati=
on
> > > > and callback invocation without requiring userspace interaction or
> > > > actual kexec reboots.
> > > >
> > > > The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.
> > > >
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > ---
> > > >  kernel/liveupdate/luo_file.c     |   2 +
> > > >  kernel/liveupdate/luo_internal.h |   8 ++
> > > >  lib/Kconfig.debug                |  23 ++++++
> > > >  lib/tests/Makefile               |   1 +
> > > >  lib/tests/liveupdate.c           | 130 +++++++++++++++++++++++++++=
++++
> > > >  5 files changed, 164 insertions(+)
> > > >  create mode 100644 lib/tests/liveupdate.c
> > > >
> > > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_f=
ile.c
> > > > index 713069b96278..4c0a75918f3d 100644
> > > > --- a/kernel/liveupdate/luo_file.c
> > > > +++ b/kernel/liveupdate/luo_file.c
> > > > @@ -829,6 +829,8 @@ int liveupdate_register_file_handler(struct liv=
eupdate_file_handler *fh)
> > > >       INIT_LIST_HEAD(&fh->flb_list);
> > > >       list_add_tail(&fh->list, &luo_file_handler_list);
> > > >
> > > > +     liveupdate_test_register(fh);
> > > > +
> > >
> > > Do it mean that every flb user will be added here?
> >
> > No, FLB users will use:
> >
> > liveupdate_register_flb() from various subsystems. This
> > liveupdate_test_register() is only to allow kernel test to register
> > test-FLBs to every single file-handler for in-kernel testing purpose
> > only.
>
> Why the in kernel test cannot liveupdate_register_flb()?

The kernel tests call liveupdate_register_flb() with every
file-handler that registers with LUO. It is unreasonable to expect
that all file handlers from various subsystems are going to be
exported and accessible to kernel test.

>
> > Pasha
>
> --
> Sincerely yours,
> Mike.

