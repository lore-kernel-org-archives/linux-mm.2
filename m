Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBB4CFA442
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27AEF6B0030; Thu, 20 Nov 2025 15:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252CF6B0088; Thu, 20 Nov 2025 15:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168576B0089; Thu, 20 Nov 2025 15:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 064926B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:26:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C427C57ECF
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:26:09 +0000 (UTC)
X-FDA: 84132117258.15.D766262
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4565140007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:26:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NMFZFOgL;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763670367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqIhtMYQq6hQ/aIE/gJLhPbAAZf5g6u9uLXykoPMVFQ=;
	b=1AKtKIoxd4r2pD4fjlPhG9zMDYdGuQh54N1KI/L7OqPWT3IhgEyxJJ8X61zc/BolqxQ+iL
	2QJ4jLxisXIYQKWFbwrhypK1uR6/V+wS9HfBGsqHOokMW/mS294faCALI7bxDEaWbSk7V+
	3ArYfvlfGZkoy+76aolehnaBI2VVklw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NMFZFOgL;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763670367; a=rsa-sha256;
	cv=none;
	b=x+cvON6PjwamvPLs4EIkLR0kOoIHn1e79VjNLW1qTGu1V6qJ2fIJVRGLkIDVz47hrv9Af7
	TYJMgwdQnfFtSVCM/99Tuld1f4pYc9vuy0Shj0/Jg5iPuIx0ulL4BLi3WqXyIhYc4ejtHW
	wziax+B5Ccs4gqYmNwNhL40jTaiVmGw=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so2151592a12.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763670366; x=1764275166; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqIhtMYQq6hQ/aIE/gJLhPbAAZf5g6u9uLXykoPMVFQ=;
        b=NMFZFOgLWYzOU3nsiIV9T+8MS7H83PB7oHG1ajnMgd73BEYmDczZAXd+H96p7lwdBg
         dSraqGzJidyHVVgrslro7oNPElncHM3xJlkEWDrmGnXEbdJdBfkxn9gEBz0pxiIFefFq
         9u/yj2RvJBkh9eb/uNIFSgh9oVfXwbcIx10yn4Bo8rGAF0JgJAtcvFgVUBGXcdrcuUDJ
         cVN9F14YWx9RsXZ2AQqY2jEUkxw1V6Gikrx/23FSIlhjVjk3zpgYYjsA49DrWceuxECr
         zG97cJl30Nld5uI3ehmOXcYzlgdQnedZ8xIFSyd0Wn1Bjn6rTIkV1//jG+jyabYzJt/9
         orhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763670366; x=1764275166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PqIhtMYQq6hQ/aIE/gJLhPbAAZf5g6u9uLXykoPMVFQ=;
        b=UGRpBdvNQCogJyxneMLRxP5MruHz6Zd1ip5pEwlWqqMq+Sx+fSvlHJjAXCTlDsNlyF
         2w7vpjGg44k+GWe6Bt4GQdLIBhaGeBMQkAUH+X2Jfk3ELwmWcqpUMeZ1wJc/bxV9Azev
         gN1d4ffxByQ7ignVc8qYBT8nxCZa9aMk91u47Aw9+y6Be1J99QlQ79vfunaOJCJfHPzm
         tIDJDOuP2KWKR/3/33az8RtI7j4E+sAfnTFnRESO3/0F7nupVwnCvfrQozMuA3LsnBL9
         Lr8TXDrKBSAutMDtawM7F4DGbP4j3XSFFDRjwpC4x65xBHKgeeD3gBU1n50Xpnhtytuu
         QJWg==
X-Forwarded-Encrypted: i=1; AJvYcCVdighc2hRvY50Cn+I2mZviQZKfPsKh4V43sO/k+VLjnxcOQd5aiGcXe2ukypnOY/2rdjXCB69sww==@kvack.org
X-Gm-Message-State: AOJu0YwuxSJX7bfgx/Ah9s684NUzdexSEAQIIx3QzHF/nbslOVxhh0E1
	RtbGpGXAWUBZhjWeV0INAzMvqK91tih6oDmF1Ci8Zc5rd41VDYDY0Hp/u9dsx6Uj9NqIKv9BU0g
	bJTzCaGSPVuONPqyfmShKskHSbjfh+2yv27Ek+2RFOw==
X-Gm-Gg: ASbGncvrg+Ntk0A/uMH9eSulF1Fb0ONcUXXxJDnPc42+i/juKNdj13jRb04b/MVsJmF
	BhtCnLXK8v+tJ7Qc5H5oXkv4kYNeI5fiVjzUk6faUmjLTYpfxNM7Rpw7Q5lJTjimGkX5ke4ga2I
	+LjTwXL1hVMkFmbgEurcJRAnLYj1lRusX/0LLw0D77NVK87dOMlFtB0ctGSbawBSUu/PsOmkE4W
	YsAdu1XcAg7npJ6UQb7Ci4F+lsPISTSeOftvpGhCvyuAX67l5cLFjwjJVyGcsciNhWY3q9PdqqI
	siI=
X-Google-Smtp-Source: AGHT+IHQa+0J7ga3uOxgiO5UWDnt3zS3XFLtQ5KrArOQzn1GSk7RNpL77vJHQpSi8zpQevLWXRXWPqNncA9R8gIVg0E=
X-Received: by 2002:a05:6402:510b:b0:643:e03:db14 with SMTP id
 4fb4d7f45d1cf-6455468513dmr12410a12.19.1763670366147; Thu, 20 Nov 2025
 12:26:06 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-7-pasha.tatashin@soleen.com> <aRoU1DSgVmplHr3E@kernel.org>
 <CA+CK2bBFS754hdPfNAkMp_PqNpOB2nY02OkWbhRdoUiZ+ah=jw@mail.gmail.com> <aR9N14KWaz6SdFcw@kernel.org>
In-Reply-To: <aR9N14KWaz6SdFcw@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 20 Nov 2025 15:25:29 -0500
X-Gm-Features: AWmQ_bkGcmBhhiXsN0wvCp8At9RZAkpij5uzcyGIDeVMn-hUhCRg5LgwnVtdQKA
Message-ID: <CA+CK2bDMS7g_9Z4aC1n-rYOGcXP9X+12cJhpYbx1HpsDfaMcfg@mail.gmail.com>
Subject: Re: [PATCH v6 06/20] liveupdate: luo_file: implement file systems callbacks
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4565140007
X-Stat-Signature: snizwibwddezt9ee5upgoncyg8jpkiqi
X-Rspam-User: 
X-HE-Tag: 1763670367-404755
X-HE-Meta: U2FsdGVkX19SO1aincP7t91Q63hTNLmvoBjuxIopLFvTsrHh1KuNDhVWar5eoyP/BG9FT7fnJq1pXjm7LW4D60RjeRyJlUagblRCzB9qeVqO/Od1KTGNrTj4lsLhYyclqbbfugba8kenMAZ8GtsKJt0JCuZ3Tpjwlmj3Ni2XJSpP4q+0ahlpw8UejMAUfsO92+/LqBKJM6E4xhry8buSssoXLamfSp9RnnYJDNWN2V8pUvH4MwbqGwWBVCVHv15gZshOc/ajrbRa7AXo52nABEznzD1P/eICXZ1pRI8wPIHYWZSGmU6g+TbaezBjdcNFN27xmMtDXOkI3IhanI5WhIOs0XwqCD5Rz1ytDbxy/37vJG+msuaoNWr23yVA0bKVGF9NOScsi/PYgj2GaMWosU+qmn6j118xW1IZFAgaJ/i9WbfQrLG6J4Zb8OBSQxVoRXNdwD+s3LyDw8iYULaQf0zMY7J4lgHaKOL7ySh3egetZjxfqpoLuPnYVF81A1rgLWEkU50w/cFRzQQPbAwtLdHSYkyIkOcjDQxTjzGNgkOtPCbz1ldBQsnXN2EhMd1Xhgp6FzjgR7+k92w/7kogSPiotGtx+gFEJ/DRkKiVeo8G7SeeSj7VhCX6U5FIoHkghtEi3AFJnFOzHAwalENv6o0RTBFXLPR0/0FbjF8GdAoo6bjIMDwyzYz9FsK4N7yPIMC+u8noGHOe4pi3gPOsKcyKrHngoPYnc5drjLH0gN1lsxrj8KM43PY01wZK9ceGRYGa3nPI7czXbgo/ZzWYpPt7rg5SEzo1aMkhOmbqjvr3EpMPaYqbnkvk70RA6lK2b3mKJ0DQKAqvGdbej3xsMXLeUkqn/XPlLc+6m8M7nD38mGn+8klcT8rILbvZtm2A+x32YVU9o71rQQp44h8L08+lDNRVEdZmTC29WlaxVTHAsC3SYi4a+DsYtFXo/GC5bVscDnnbfC+Ramd9oY0
 dzFglZg2
 fREJ9w83rSz2uSN+tesQ0DaHYxq2fsShayx9Z7wigUdUf7nJHeSl9k770sFYn+vhbnDnIg5fFszB8V00qDcTfxSR6TTP3fgIh159v+vdiAGM2NyVSvqbXNi7bx7jgqFovhMxtubV7Y7EZuVsRiVQ+hZV7M5+ZmHb/sSmoWIdxcFMDf/4XN8CHI8qtKt1nW28U4Tcn1cs5lo7g5F68qzYHtwVh1Dkz6yApwGzFmQhan4dAmZQyryL4pYmnEQgfaPBziTSqAiYQ6DdYpnteeM+iRgom26PWOAPSzaJ6ZRSXACplXXtCSdg5SoxKDealhJj9pIsrYKx2ynPUvsSg/uyZ9D88LcsHYzfsO6ffnqUZFquf9TQe42h3sU2UBOIsF3zWhEQ3rnwJs68ORDWi5stdjG9KxVstuqx/DkOrAw9R+YkdbitYcrhv5Q7oBqzK/LnibzglbmoAFqW5U2fBvJdRPqiHYLrEy7EuOOkxt+iUuNqLNPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 12:20=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Mon, Nov 17, 2025 at 12:50:56PM -0500, Pasha Tatashin wrote:
> > > > +struct liveupdate_file_handler;
> > > > +struct liveupdate_session;
> > >
> > > Why struct liveupdate_session is a part of public LUO API?
> >
> > It is an obscure version of private "struct luo_session", in order to
> > give subsystem access to:
> > liveupdate_get_file_incoming(s, token, filep)
> > liveupdate_get_token_outgoing(s, file, tokenp)
> >
> > For example, if your FD depends on another FD within a session, you
> > can check if another FD is already preserved via
> > liveupdate_get_token_outgoing(), and during retrieval time you can
> > retrieve the "struct file" for your dependency.
>
> And it's essentially unused right now.

I am going to move this API to the end of the series, next to FLB :-)

>
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +
> > > > +exit_err:
> > > > +     fput(file);
> > > > +     luo_session_free_files_mem(session);
> > >
> > > The error handling in this function is a mess. Pasha, please, please,=
 use
> > > goto consistently.
> >
> > How is this a mess? There is a single exit_err destination, no
> > exception, no early returns except at the very top of the function
> > where we do early returns before fget() which makes total sense.
> >
> > Do you want to add a separate destination for
> > luo_session_free_files_mem() ? But that is not necessary, in many
> > places it is considered totally reasonable for free(NULL) to work
> > correctly...
>
> You have a mix of releasing resources with goto or inside if (err).
> And while basic free() primitives like kfree() and vfree() work correctly
> with NULL as a parameter, luo_session_free_files_mem() is already not a
> basic primitive and it may grow with a time. It already has two condition=
s
> that essentially prevent anything from freeing and this will grow with th=
e
> time.
>
> So yes, I want a separate goto destination for freeing each resource and =
a
> goto for
>
>         err =3D fh->ops->preserve(&args);
>         if (err)

Thanks, I made the change.

>
> case.
>
> > > > +             luo_file =3D kzalloc(sizeof(*luo_file), GFP_KERNEL);
> > > > +             if (!luo_file)
> > > > +                     return -ENOMEM;
> > >
> > > Shouldn't we free files allocated on the previous iterations?
> >
> > No, for the same reason explained in luo_session.c :-)
>
> A comment here as well please :)

Done

>
> > > > +int liveupdate_get_file_incoming(struct liveupdate_session *s, u64=
 token,
> > > > +                              struct file **filep)
> > > > +{
> > >
> > > Ditto.
> >
> > These two functions are part of the public API allowing dependency
> > tracking for vfio->iommu->memfd during preservation.
>
> So like with FLB, until we get actual users for them they are dead code.
> And until it's clear how exactly dependency tracking for vfio->iommu->mem=
fd
> will work, we won't know if this API is useful at all or we'll need
> something else in the end.

SGTM

>
> --
> Sincerely yours,
> Mike.

